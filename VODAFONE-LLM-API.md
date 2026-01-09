# Vodafone Practicus LLM API Integration

Bu döküman GENAI-OPS uygulamasının Vodafone Practicus LLM API'si ile nasıl entegre olduğunu detaylı olarak açıklar.

## 📋 API Özeti

**Vodafone LLM as a Service**, Büyük Dil Modeli (LLM) yeteneklerinin bir API aracılığıyla uzaktan erişilebilir bir hizmet olarak sunulmasını sağlar.

### API Endpoint Detayları

| Özellik | Değer |
|---------|-------|
| **Base URL** | `https://practicus.vodafone.local` |
| **Endpoint Path** | `/models/{model_name}/` |
| **Model Name** | `cwyd-llm-general-prod` |
| **Full URL** | `https://practicus.vodafone.local/models/cwyd-llm-general-prod/` |
| **HTTP Method** | `POST` |
| **Authentication** | Bearer Token |
| **Content-Type** | `application/json` |
| **Timeout** | 45 seconds (önerilen) |

---

## 🔐 Authentication

### Bearer Token

Tüm API istekleri `Authorization` header'ında Bearer token gerektirir:

```http
Authorization: Bearer {API_TOKEN}
```

**Token Yönetimi:**
- Token, OpenShift Secret'ta saklanır
- Environment variable olarak backend'e inject edilir
- Her istekte otomatik olarak eklenir

---

## 📤 Request Format

### Request Body Structure

```json
{
  "mode": "llm_as_service",
  "system_prompt": "LLM rolü ve talimatları",
  "user_prompt": "Kullanıcının mesajı"
}
```

### Field Açıklamaları

#### 1. mode (Required)
- **Type:** String
- **Value:** `"llm_as_service"`
- **Açıklama:** Hizmet çağrısının çalışma modunu belirtir
- **Sabit değer:** Her zaman `llm_as_service` olmalı

#### 2. system_prompt (Required)
- **Type:** String
- **Açıklama:** LLM'nin rolünü, davranış kurallarını ve görev tanımını belirler
- **ConfigMap'te yönetilir:** `LLM_SYSTEM_PROMPT`
- **Best Practices:**
  - Açık rol tanımı
  - Tek görev odaklı
  - Kalite ve doğruluk vurgusu
  - Ekstra yorum yok

**Örnek System Prompt:**
```
You are an AI operations assistant for Vodafone. 
Your role is to help users with technical issues, 
provide troubleshooting guidance, and answer questions 
about systems and operations. Provide clear, accurate, 
and helpful responses in a professional manner.
```

#### 3. user_prompt (Required)
- **Type:** String
- **Açıklama:** LLM'nin işlemesi gereken gerçek kullanıcı girişi
- **Örnek:** `"Vodafone'da çalışmak güzel iş!"`

---

## 📥 Response Format

### Successful Response

```json
{
  "status_code": "200",
  "status": "success",
  "message": "Answer has been generated successfully",
  "answer": "AI generated response text\n\n"
}
```

### Field Açıklamaları

| Field | Type | Açıklama |
|-------|------|----------|
| `status_code` | String | HTTP status code (string format) |
| `status` | String | İşlem sonucu: `"success"` veya `"error"` |
| `message` | String | İşlem hakkında açıklayıcı mesaj |
| `answer` | String | LLM tarafından üretilen yanıt (whitespace içerebilir) |

**Not:** `answer` field'ı newline karakterleri (`\n`) veya whitespace içerebilir. Backend tarafında `.trim()` ile temizlenir.

---

## 🔄 GENAI-OPS Implementation

### Java Implementation (LLMService.java)

```java
@Service
@Slf4j
public class LLMService {

    @Value("${llm.endpoint-base-url}")
    private String llmEndpointBaseUrl;  // https://practicus.vodafone.local

    @Value("${llm.model-name}")
    private String llmModelName;  // cwyd-llm-general-prod

    @Value("${llm.mode}")
    private String llmMode;  // llm_as_service

    @Value("${llm.api-token}")
    private String llmApiToken;  // Bearer token

    @Value("${llm.system-prompt}")
    private String systemPrompt;  // LLM role definition

    public String sendMessage(String message) {
        // Build full URL
        String fullApiUrl = String.format("%s/models/%s/", 
            llmEndpointBaseUrl, llmModelName);

        // Prepare request
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + llmApiToken);

        // Build request body
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("mode", llmMode);
        requestBody.put("system_prompt", systemPrompt);
        requestBody.put("user_prompt", message);

        // Send request
        ResponseEntity<Map> response = restTemplate.exchange(
            fullApiUrl, HttpMethod.POST, 
            new HttpEntity<>(requestBody, headers), 
            Map.class
        );

        // Parse response
        Map<String, Object> responseBody = response.getBody();
        String statusCode = (String) responseBody.get("status_code");
        String status = (String) responseBody.get("status");

        if ("200".equals(statusCode) && "success".equals(status)) {
            String answer = (String) responseBody.get("answer");
            return answer.trim();  // Remove whitespace
        }

        return getMockResponse(message);  // Fallback
    }
}
```

---

## ⚙️ Configuration

### ConfigMap (deployment/configmap.yaml)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: genai-ops-config
data:
  # Vodafone Practicus LLM API
  LLM_ENDPOINT_BASE_URL: "https://practicus.vodafone.local"
  LLM_MODEL_NAME: "cwyd-llm-general-prod"
  LLM_MODE: "llm_as_service"
  LLM_TIMEOUT: "45000"
  LLM_SYSTEM_PROMPT: |
    You are an AI operations assistant for Vodafone. 
    Your role is to help users with technical issues, 
    provide troubleshooting guidance, and answer questions 
    about systems and operations. Provide clear, accurate, 
    and helpful responses in a professional manner.
```

### Secret (deployment/secret.yaml)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: genai-ops-secret
type: Opaque
stringData:
  LLM_API_TOKEN: "your-vodafone-api-token-here"
```

### application.yml

```yaml
llm:
  endpoint-base-url: ${LLM_ENDPOINT_BASE_URL:https://practicus.vodafone.local}
  model-name: ${LLM_MODEL_NAME:cwyd-llm-general-prod}
  mode: ${LLM_MODE:llm_as_service}
  api-token: ${LLM_API_TOKEN:mock-token}
  timeout: ${LLM_TIMEOUT:45000}
  system-prompt: ${LLM_SYSTEM_PROMPT:You are an AI assistant...}
```

---

## 🧪 Testing

### Test with curl

```bash
# Set variables
BASE_URL="https://practicus.vodafone.local"
MODEL_NAME="cwyd-llm-general-prod"
API_TOKEN="your-token-here"
FULL_URL="${BASE_URL}/models/${MODEL_NAME}/"

# Test request
curl -X POST "$FULL_URL" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "llm_as_service",
    "system_prompt": "You are an AI assistant.",
    "user_prompt": "Hello, how are you?"
  }'
```

### Expected Response

```json
{
  "status_code": "200",
  "status": "success",
  "message": "Answer has been generated successfully",
  "answer": "Hello! I'm doing well, thank you for asking. How can I assist you today?\n\n"
}
```

### Test from OpenShift

```bash
# Get configuration
LLM_BASE_URL=$(oc get configmap genai-ops-config -o jsonpath='{.data.LLM_ENDPOINT_BASE_URL}')
LLM_MODEL=$(oc get configmap genai-ops-config -o jsonpath='{.data.LLM_MODEL_NAME}')
LLM_TOKEN=$(oc get secret genai-ops-secret -o jsonpath='{.data.LLM_API_TOKEN}' | base64 -d)

# Build URL
FULL_URL="${LLM_BASE_URL}/models/${LLM_MODEL}/"

# Test
curl -X POST "$FULL_URL" \
  -H "Authorization: Bearer $LLM_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "llm_as_service",
    "system_prompt": "You are an AI assistant.",
    "user_prompt": "test message"
  }'
```

---

## 🛡️ Error Handling

### Common Errors

#### 1. 401 Unauthorized

**Sebep:** Invalid or expired API token

**Çözüm:**
```bash
# Token'ı kontrol et
oc get secret genai-ops-secret -o jsonpath='{.data.LLM_API_TOKEN}' | base64 -d

# Token'ı güncelle
oc edit secret genai-ops-secret

# Backend'i yeniden başlat
oc rollout restart deployment/genai-ops-backend
```

#### 2. Connection Timeout

**Sebep:** Network issues or LLM service unavailable

**Çözüm:**
```bash
# Timeout'u artır
oc edit configmap genai-ops-config
# LLM_TIMEOUT: "60000"  # 60 seconds

# Backend'i yeniden başlat
oc rollout restart deployment/genai-ops-backend
```

#### 3. Invalid Response Format

**Sebep:** API response doesn't match expected format

**Fallback:** Mock response otomatik olarak döner

**Log Kontrolü:**
```bash
oc logs -f deployment/genai-ops-backend | grep -i llm
```

---

## 🔄 Fallback Mechanism

LLM servisi erişilemez olduğunda veya hata döndüğünde, sistem otomatik olarak **mock response** döner:

```java
try {
    // LLM API call
    return callVodafoneLLM(message);
} catch (Exception e) {
    log.error("Error calling LLM: {}", e.getMessage());
    return getMockResponse(message);  // Fallback
}
```

Mock response'lar keyword-based olarak üretilir ve kullanıcıya anlamlı yanıtlar sağlar.

---

## 📊 Monitoring

### Backend Logs

```bash
# LLM request/response logları
oc logs -f deployment/genai-ops-backend | grep -i llm

# Örnek log:
# 2025-11-24 13:27:13 INFO  LLMService - Sending message to Vodafone LLM: Hello
# 2025-11-24 13:27:13 DEBUG LLMService - LLM API URL: https://practicus.vodafone.local/models/cwyd-llm-general-prod/
# 2025-11-24 13:27:14 DEBUG LLMService - LLM Response - status_code: 200, status: success
# 2025-11-24 13:27:14 INFO  LLMService - LLM response received successfully (length: 156)
```

### Metrics to Monitor

- Request count
- Success rate
- Response time
- Error rate
- Fallback usage rate

---

## 📝 Best Practices

### 1. System Prompt Design

✅ **İyi Örnek:**
```
You are an AI operations assistant for Vodafone. 
Your role is to help users with technical issues, 
provide troubleshooting guidance, and answer questions 
about systems and operations. Provide clear, accurate, 
and helpful responses in a professional manner.
```

❌ **Kötü Örnek:**
```
You are a chatbot. Answer questions.
```

### 2. Token Management

- ✅ Token'ı Secret'ta sakla
- ✅ Environment variable kullan
- ✅ Düzenli olarak rotate et
- ❌ Kod içinde hardcode etme
- ❌ Log'larda gösterme

### 3. Error Handling

- ✅ Her zaman fallback mekanizması kullan
- ✅ Hataları detaylı logla
- ✅ User'a anlamlı mesaj göster
- ✅ Timeout değerini uygun ayarla (45s)

### 4. Testing

- ✅ Her deployment sonrası test et
- ✅ Token'ın geçerli olduğunu doğrula
- ✅ Response format'ını kontrol et
- ✅ Fallback mekanizmasını test et

---

## 🎯 Özet

- ✅ Vodafone Practicus LLM API entegrasyonu tamamlandı
- ✅ Request/Response format Vodafone API'sine uygun
- ✅ Tüm yapılandırma ConfigMap/Secret'ta
- ✅ Bearer token authentication
- ✅ System prompt configurable
- ✅ Fallback mekanizması aktif
- ✅ Kod içinde hassas bilgi yok

**Vodafone LLM API başarıyla entegre edildi! 🚀**
