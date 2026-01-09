# LLM Service Integration Guide

Bu döküman GENAI-OPS uygulamasının LLM servisi ile nasıl entegre olduğunu açıklar.

## 🔗 LLM Servis Bağlantısı (Vodafone Practicus API)

### Yapılandırma

LLM servisi ile bağlantı için 6 parametre kullanılır:

| Parametre | Açıklama | Kaynak | Örnek Değer |
|-----------|----------|--------|-------------|
| `LLM_ENDPOINT_BASE_URL` | Vodafone Practicus base URL | ConfigMap | `https://practicus.vodafone.local` |
| `LLM_MODEL_NAME` | LLM model adı | ConfigMap | `cwyd-llm-general-prod` |
| `LLM_MODE` | Servis modu | ConfigMap | `llm_as_service` |
| `LLM_API_TOKEN` | JWT token veya API key | **Secret** | `Bearer token` |
| `LLM_TIMEOUT` | Request timeout (ms) | ConfigMap | `45000` (45 saniye) |
| `LLM_SYSTEM_PROMPT` | LLM rolü ve talimatları | ConfigMap | `You are an AI assistant...` |

### ConfigMap Örneği

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: genai-ops-config
data:
  # Vodafone Practicus LLM API Configuration
  LLM_ENDPOINT_BASE_URL: "https://practicus.vodafone.local"
  LLM_MODEL_NAME: "cwyd-llm-general-prod"
  LLM_MODE: "llm_as_service"
  LLM_TIMEOUT: "45000"  # 45 seconds (recommended by Vodafone)
  LLM_SYSTEM_PROMPT: "You are an AI operations assistant for Vodafone. Your role is to help users with technical issues, provide troubleshooting guidance, and answer questions about systems and operations. Provide clear, accurate, and helpful responses in a professional manner."
```

### Secret Örneği

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: genai-ops-secret
type: Opaque
stringData:
  # JWT token veya API key
  LLM_API_TOKEN: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnZW5haS1vcHMiLCJpYXQiOjE2..."
```

---

## 📡 HTTP Request Format (Vodafone Practicus API)

### API Endpoint Structure

```
Base URL: https://practicus.vodafone.local
Endpoint: /models/{model_name}/
Full URL: https://practicus.vodafone.local/models/cwyd-llm-general-prod/
```

### Request

```http
POST https://practicus.vodafone.local/models/cwyd-llm-general-prod/
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "mode": "llm_as_service",
  "system_prompt": "You are an AI operations assistant for Vodafone...",
  "user_prompt": "User's message here"
}
```

### Response (Vodafone API Format)

```json
{
  "status_code": "200",
  "status": "success",
  "message": "Answer has been generated successfully",
  "answer": "AI generated response here\n\n"
}
```

**Not:** Response'daki `answer` field'ı whitespace ve newline karakterleri içerebilir, bu yüzden `.trim()` ile temizlenir.

---

## 🔐 Authentication

### Bearer Token

LLM servisine yapılan tüm isteklerde **Bearer token authentication** kullanılır:

```java
// LLMService.java
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);
headers.setBearerAuth(llmApiToken);  // Authorization: Bearer <token>
```

### Token Türleri

LLM servisinizin authentication mekanizmasına göre:

1. **JWT Token**: Standart JWT formatında token
   ```
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnZW5haS1vcHMifQ...
   ```

2. **API Key**: Basit API key
   ```
   sk-1234567890abcdef
   ```

3. **Custom Token**: Özel format
   ```
   custom-token-format-here
   ```

---

## 🔄 Request Flow

```
User Message
    ↓
ChatController
    ↓
ChatService
    ↓
LLMService.sendMessage()
    ↓
Build Full URL: {base_url}/models/{model_name}/
    ↓
HTTP POST to Vodafone Practicus API
    ├─ URL: https://practicus.vodafone.local/models/cwyd-llm-general-prod/
    ├─ Headers:
    │   ├─ Authorization: Bearer <LLM_API_TOKEN>
    │   └─ Content-Type: application/json
    └─ Body:
        {
          "mode": "llm_as_service",
          "system_prompt": "You are an AI assistant...",
          "user_prompt": "user message"
        }
    ↓
Vodafone LLM Service Response
    {
      "status_code": "200",
      "status": "success",
      "message": "Answer has been generated successfully",
      "answer": "AI response text"
    }
    ↓
Parse Response (extract 'answer' field)
    ↓
Trim whitespace/newlines
    ↓
Return to User
```

---

## 🛡️ Fallback Mechanism

LLM servisi erişilemez olduğunda **mock response** döner:

```java
try {
    // LLM servisine istek gönder
    ResponseEntity<Map> response = restTemplate.exchange(...);
    return response.getBody().get("response");
} catch (Exception e) {
    log.error("Error calling LLM service: {}", e.getMessage());
    return getMockResponse(message);  // Fallback
}
```

### Mock Response Örnekleri

- Error/Issue keywords → Troubleshooting steps
- Database keywords → Database connection fix
- Help keywords → Feature list
- Default → Generic helpful response

---

## ⚙️ Yapılandırma Örnekleri

### Local Development (docker-compose.yml)

```yaml
services:
  backend:
    environment:
      LLM_ENDPOINT_URL: http://localhost:8000/api/chat
      LLM_API_TOKEN: mock-token
      LLM_TIMEOUT: 30000
```

### OpenShift Development

```yaml
# ConfigMap
LLM_ENDPOINT_URL: "http://llm-dev.ai-platform.svc.cluster.local:8000/api/chat"
LLM_TIMEOUT: "30000"

# Secret
LLM_API_TOKEN: "dev-jwt-token-here"
```

### OpenShift Production

```yaml
# ConfigMap
LLM_ENDPOINT_URL: "http://llm-prod.ai-platform.svc.cluster.local:8000/api/chat"
LLM_TIMEOUT: "30000"

# Secret
LLM_API_TOKEN: "prod-jwt-token-here-with-proper-security"
```

---

## 🧪 Testing

### Test LLM Connection (Vodafone Practicus API)

```bash
# OpenShift'te
LLM_BASE_URL=$(oc get configmap genai-ops-config -o jsonpath='{.data.LLM_ENDPOINT_BASE_URL}')
LLM_MODEL=$(oc get configmap genai-ops-config -o jsonpath='{.data.LLM_MODEL_NAME}')
LLM_MODE=$(oc get configmap genai-ops-config -o jsonpath='{.data.LLM_MODE}')
LLM_SYSTEM_PROMPT=$(oc get configmap genai-ops-config -o jsonpath='{.data.LLM_SYSTEM_PROMPT}')
LLM_TOKEN=$(oc get secret genai-ops-secret -o jsonpath='{.data.LLM_API_TOKEN}' | base64 -d)

# Build full URL
FULL_URL="${LLM_BASE_URL}/models/${LLM_MODEL}/"

# Test request
curl -v \
  -H "Authorization: Bearer $LLM_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"mode\":\"$LLM_MODE\",\"system_prompt\":\"$LLM_SYSTEM_PROMPT\",\"user_prompt\":\"test message\"}" \
  $FULL_URL
```

### Test from Backend Pod

```bash
# Backend pod'undan test et (Vodafone API format)
oc exec deployment/genai-ops-backend -- sh -c '
  FULL_URL="${LLM_ENDPOINT_BASE_URL}/models/${LLM_MODEL_NAME}/"
  curl -v \
    -H "Authorization: Bearer ${LLM_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"mode\":\"${LLM_MODE}\",\"system_prompt\":\"${LLM_SYSTEM_PROMPT}\",\"user_prompt\":\"test message\"}" \
    $FULL_URL
'
```

### Check Environment Variables

```bash
# Backend pod'unda environment variable'ları kontrol et
oc exec deployment/genai-ops-backend -- env | grep LLM

# Çıktı (Vodafone API):
# LLM_ENDPOINT_BASE_URL=https://practicus.vodafone.local
# LLM_MODEL_NAME=cwyd-llm-general-prod
# LLM_MODE=llm_as_service
# LLM_API_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
# LLM_TIMEOUT=45000
# LLM_SYSTEM_PROMPT=You are an AI operations assistant...
```

---

## 📊 Monitoring

### Backend Logs

```bash
# LLM request/response logları
oc logs -f deployment/genai-ops-backend | grep -i llm

# Örnek log çıktısı:
# 2025-11-24 13:27:13 [http-nio-8080-exec-2] INFO  c.v.g.service.LLMService - Sending message to LLM: Hello
# 2025-11-24 13:27:14 [http-nio-8080-exec-2] INFO  c.v.g.service.LLMService - LLM response received: Hi there!
```

### Error Scenarios

```bash
# LLM servis erişilemez
# 2025-11-24 13:27:13 ERROR c.v.g.service.LLMService - Error calling LLM service: Connection refused
# 2025-11-24 13:27:13 INFO  c.v.g.service.LLMService - Returning mock response

# LLM authentication hatası
# 2025-11-24 13:27:13 ERROR c.v.g.service.LLMService - Error calling LLM service: 401 Unauthorized
# 2025-11-24 13:27:13 INFO  c.v.g.service.LLMService - Returning mock response
```

---

## 🔧 Troubleshooting

### 1. Connection Refused

**Problem:** LLM servisine bağlanılamıyor

**Çözüm:**
```bash
# LLM servis URL'ini kontrol et
oc get configmap genai-ops-config -o jsonpath='{.data.LLM_ENDPOINT_URL}'

# Network bağlantısını test et
oc exec deployment/genai-ops-backend -- curl -v <LLM_URL>

# LLM servisinin çalıştığını kontrol et
oc get pods -n ai-platform | grep llm
```

### 2. 401 Unauthorized

**Problem:** LLM servisi authentication hatası veriyor

**Çözüm:**
```bash
# Token'ı kontrol et
oc get secret genai-ops-secret -o jsonpath='{.data.LLM_API_TOKEN}' | base64 -d

# Token'ı güncelle
oc edit secret genai-ops-secret

# Backend'i yeniden başlat
oc rollout restart deployment/genai-ops-backend
```

### 3. Timeout

**Problem:** LLM servisi yanıt vermiyor (timeout)

**Çözüm:**
```bash
# Timeout değerini artır
oc edit configmap genai-ops-config
# LLM_TIMEOUT: "60000"  # 60 seconds

# Backend'i yeniden başlat
oc rollout restart deployment/genai-ops-backend
```

### 4. Invalid Response Format

**Problem:** LLM servisi beklenmeyen format döndürüyor

**Çözüm:**
```bash
# LLM response'u loglardan kontrol et
oc logs deployment/genai-ops-backend | grep -A 5 "LLM response"

# LLM servisinin API dökümanını kontrol et
# Response format: {"response": "text"}
```

---

## 🔄 Token Rotation

### Token Güncelleme

```bash
# 1. Yeni token oluştur (LLM servis tarafında)

# 2. Secret'ı güncelle
oc edit secret genai-ops-secret
# LLM_API_TOKEN: <new-token-base64-encoded>

# 3. Backend'i yeniden başlat (zero-downtime)
oc rollout restart deployment/genai-ops-backend

# 4. Rollout durumunu izle
oc rollout status deployment/genai-ops-backend
```

---

## 📝 Best Practices

1. **Token Security**
   - Token'ı asla kod içinde tutma
   - Secret kullan
   - Düzenli olarak rotate et

2. **Error Handling**
   - Her zaman fallback mekanizması kullan
   - Hataları logla
   - User'a anlamlı mesaj göster

3. **Timeout**
   - Uygun timeout değeri belirle (30s önerilen)
   - Timeout durumunda mock response dön

4. **Monitoring**
   - LLM request/response loglarını izle
   - Error rate'i takip et
   - Response time'ı ölç

5. **Testing**
   - Her deployment sonrası LLM bağlantısını test et
   - Token'ın geçerli olduğunu doğrula
   - Mock response'un çalıştığını kontrol et

---

## 🎯 Özet

- ✅ LLM API token **Secret**'ta saklanıyor
- ✅ Bearer token authentication kullanılıyor
- ✅ ConfigMap ile endpoint ve timeout yönetiliyor
- ✅ Fallback mekanizması var
- ✅ Kod içinde hassas bilgi yok
- ✅ OpenShift ConfigMap/Secret ile yönetilebilir

**LLM JWT token artık tamamen ConfigMap/Secret yapısında yönetiliyor! 🚀**
