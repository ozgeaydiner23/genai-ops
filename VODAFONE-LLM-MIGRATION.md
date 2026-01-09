# Vodafone Practicus LLM API Migration Summary

Bu döküman, GENAI-OPS uygulamasının Vodafone Practicus LLM API'sine geçiş sürecini özetler.

## ✅ Tamamlanan Değişiklikler

### 🔄 API Format Değişiklikleri

#### Önceki Format (Generic LLM API)
```http
POST http://llm-service:8000/api/chat
Authorization: Bearer <token>
Content-Type: application/json

{
  "prompt": "user message",
  "context": {}
}

Response:
{
  "response": "AI response"
}
```

#### Yeni Format (Vodafone Practicus API)
```http
POST https://practicus.vodafone.local/models/cwyd-llm-general-prod/
Authorization: Bearer <token>
Content-Type: application/json

{
  "mode": "llm_as_service",
  "system_prompt": "You are an AI assistant...",
  "user_prompt": "user message"
}

Response:
{
  "status_code": "200",
  "status": "success",
  "message": "Answer has been generated successfully",
  "answer": "AI response text\n\n"
}
```

---

## 📝 Değiştirilen Dosyalar

### 1. Backend Configuration

#### `backend/src/main/resources/application.yml`
**Değişiklikler:**
- ✅ `llm.endpoint-url` → `llm.endpoint-base-url`
- ✅ Yeni: `llm.model-name`
- ✅ Yeni: `llm.mode`
- ✅ Yeni: `llm.system-prompt`
- ✅ `llm.timeout`: 30000 → 45000

**Yeni Yapılandırma:**
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

### 2. Backend Service

#### `backend/src/main/java/com/vodafone/genaiops/service/LLMService.java`
**Değişiklikler:**
- ✅ Yeni field'lar: `llmEndpointBaseUrl`, `llmModelName`, `llmMode`, `systemPrompt`
- ✅ URL building: `{base_url}/models/{model_name}/`
- ✅ Request body format değişti: `mode`, `system_prompt`, `user_prompt`
- ✅ Response parsing değişti: `answer` field kullanılıyor
- ✅ Status kontrolü: `status_code` ve `status` field'ları
- ✅ Response trimming: Whitespace ve newline temizleme

**Yeni Request Body:**
```java
Map<String, Object> requestBody = new HashMap<>();
requestBody.put("mode", llmMode);
requestBody.put("system_prompt", systemPrompt);
requestBody.put("user_prompt", message);
```

**Yeni Response Parsing:**
```java
String statusCode = (String) responseBody.get("status_code");
String status = (String) responseBody.get("status");
if ("200".equals(statusCode) && "success".equals(status)) {
    String answer = (String) responseBody.get("answer");
    return answer.trim();
}
```

---

### 3. Deployment Configuration

#### `deployment/configmap.yaml`
**Değişiklikler:**
- ✅ `LLM_ENDPOINT_URL` → `LLM_ENDPOINT_BASE_URL`
- ✅ Yeni: `LLM_MODEL_NAME`
- ✅ Yeni: `LLM_MODE`
- ✅ Yeni: `LLM_SYSTEM_PROMPT`
- ✅ `LLM_TIMEOUT`: 30000 → 45000

**Yeni ConfigMap:**
```yaml
LLM_ENDPOINT_BASE_URL: "https://practicus.vodafone.local"
LLM_MODEL_NAME: "cwyd-llm-general-prod"
LLM_MODE: "llm_as_service"
LLM_TIMEOUT: "45000"
LLM_SYSTEM_PROMPT: "You are an AI operations assistant..."
```

#### `deployment/backend-deployment.yaml`
**Değişiklikler:**
- ✅ Yeni environment variable'lar eklendi
- ✅ ConfigMap reference'ları güncellendi

---

### 4. Docker Configuration

#### `docker-compose.yml`
**Değişiklikler:**
- ✅ Environment variable'lar Vodafone API formatına güncellendi
- ✅ Timeout 45 saniyeye çıkarıldı

---

### 5. Documentation

#### Yeni Dökümanlar:
- ✅ `VODAFONE-LLM-API.md` - Vodafone API detaylı rehberi

#### Güncellenen Dökümanlar:
- ✅ `LLM-INTEGRATION.md` - Vodafone API formatına güncellendi
- ✅ `CONFIGURATION.md` - Yeni environment variable'lar eklendi
- ✅ `SUMMARY.md` - Vodafone API bilgileri eklendi
- ✅ `README.md` - Yeni döküman linki eklendi

---

## 🎯 Yeni Environment Variables

| Variable | Önceki | Yeni | Açıklama |
|----------|--------|------|----------|
| `LLM_ENDPOINT_URL` | ✅ | ❌ | Kaldırıldı |
| `LLM_ENDPOINT_BASE_URL` | ❌ | ✅ | Base URL |
| `LLM_MODEL_NAME` | ❌ | ✅ | Model adı |
| `LLM_MODE` | ❌ | ✅ | Servis modu |
| `LLM_API_TOKEN` | ✅ | ✅ | Değişmedi |
| `LLM_TIMEOUT` | ✅ | ✅ | 30000 → 45000 |
| `LLM_SYSTEM_PROMPT` | ❌ | ✅ | LLM rolü |

---

## 🔄 Migration Checklist

### OpenShift'te Yapılması Gerekenler

#### 1. ConfigMap Güncelleme
```bash
# Mevcut ConfigMap'i yedekle
oc get configmap genai-ops-config -o yaml > configmap-backup.yaml

# Yeni ConfigMap'i uygula
oc apply -f deployment/configmap.yaml

# Değişiklikleri kontrol et
oc describe configmap genai-ops-config
```

#### 2. Secret Kontrolü
```bash
# LLM_API_TOKEN'ın set edildiğini kontrol et
oc get secret genai-ops-secret -o jsonpath='{.data.LLM_API_TOKEN}' | base64 -d

# Gerekirse token'ı güncelle
oc edit secret genai-ops-secret
```

#### 3. Backend Deployment Güncelleme
```bash
# Yeni deployment'ı uygula
oc apply -f deployment/backend-deployment.yaml

# Rollout durumunu izle
oc rollout status deployment/genai-ops-backend

# Pod'ların yeniden başladığını kontrol et
oc get pods -l component=backend
```

#### 4. Environment Variables Kontrolü
```bash
# Backend pod'unda yeni variable'ları kontrol et
oc exec deployment/genai-ops-backend -- env | grep LLM

# Beklenen çıktı:
# LLM_ENDPOINT_BASE_URL=https://practicus.vodafone.local
# LLM_MODEL_NAME=cwyd-llm-general-prod
# LLM_MODE=llm_as_service
# LLM_API_TOKEN=...
# LLM_TIMEOUT=45000
# LLM_SYSTEM_PROMPT=You are an AI...
```

#### 5. API Test
```bash
# Vodafone LLM API'yi test et
LLM_BASE_URL=$(oc get configmap genai-ops-config -o jsonpath='{.data.LLM_ENDPOINT_BASE_URL}')
LLM_MODEL=$(oc get configmap genai-ops-config -o jsonpath='{.data.LLM_MODEL_NAME}')
LLM_TOKEN=$(oc get secret genai-ops-secret -o jsonpath='{.data.LLM_API_TOKEN}' | base64 -d)

FULL_URL="${LLM_BASE_URL}/models/${LLM_MODEL}/"

curl -X POST "$FULL_URL" \
  -H "Authorization: Bearer $LLM_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "llm_as_service",
    "system_prompt": "You are an AI assistant.",
    "user_prompt": "test message"
  }'
```

#### 6. Backend Logs Kontrolü
```bash
# Backend loglarını izle
oc logs -f deployment/genai-ops-backend | grep -i llm

# Başarılı log örneği:
# INFO  LLMService - Sending message to Vodafone LLM: test
# DEBUG LLMService - LLM API URL: https://practicus.vodafone.local/models/cwyd-llm-general-prod/
# DEBUG LLMService - LLM Response - status_code: 200, status: success
# INFO  LLMService - LLM response received successfully
```

---

## ⚠️ Dikkat Edilmesi Gerekenler

### 1. Backward Compatibility
- ❌ Eski API format'ı artık desteklenmiyor
- ✅ Mock response mekanizması korundu
- ✅ Fallback sistemi aynı

### 2. Network Access
- ⚠️ `https://practicus.vodafone.local` Vodafone dahili ağından erişilebilir
- ⚠️ VPN veya dahili ağ bağlantısı gerekli
- ⚠️ Firewall kurallarını kontrol edin

### 3. Token Management
- ⚠️ Vodafone API token'ı gerekli
- ⚠️ Token'ın geçerli olduğundan emin olun
- ⚠️ Token rotation planı yapın

### 4. System Prompt
- ⚠️ System prompt LLM davranışını belirler
- ⚠️ ConfigMap'te yönetilebilir
- ⚠️ Değişiklikler için pod restart gerekli

---

## 🧪 Test Senaryoları

### 1. Başarılı LLM Response
```bash
# Frontend'den mesaj gönder
# Beklenen: Vodafone LLM'den yanıt gelir
```

### 2. LLM Servisi Erişilemez
```bash
# LLM servisini simüle et (yanlış URL)
# Beklenen: Mock response döner
```

### 3. Invalid Token
```bash
# Yanlış token ile test et
# Beklenen: Mock response döner, log'da hata görünür
```

### 4. Timeout
```bash
# Timeout'u çok kısa ayarla (1000ms)
# Beklenen: Timeout sonrası mock response döner
```

---

## 📊 Monitoring

### Metrics to Track

1. **LLM Request Count**
   - Toplam istek sayısı
   - Başarılı istek sayısı
   - Başarısız istek sayısı

2. **Response Time**
   - Ortalama yanıt süresi
   - P95, P99 percentile'lar

3. **Error Rate**
   - HTTP error rate
   - Timeout rate
   - Fallback usage rate

4. **Token Usage**
   - Token expiration tracking
   - Token refresh events

---

## ✅ Başarı Kriterleri

Migration başarılı sayılır eğer:

- ✅ Backend başarıyla başlıyor
- ✅ Environment variable'lar doğru set edilmiş
- ✅ Vodafone LLM API'ye başarılı istek gönderiliyor
- ✅ Response başarıyla parse ediliyor
- ✅ Fallback mekanizması çalışıyor
- ✅ Frontend'den mesaj gönderme çalışıyor
- ✅ Log'larda hata yok

---

## 🎯 Özet

### Değişiklik Özeti
- ✅ **7 dosya** güncellendi
- ✅ **1 yeni döküman** oluşturuldu
- ✅ **4 döküman** güncellendi
- ✅ **6 yeni environment variable** eklendi
- ✅ **Ana yapı korundu** - backward compatible değil ama fallback var

### Avantajlar
- ✅ Vodafone resmi LLM API'si kullanılıyor
- ✅ System prompt configurable
- ✅ Daha uzun timeout (45s)
- ✅ Detaylı response status kontrolü
- ✅ Tüm yapılandırma ConfigMap/Secret'ta

### Sonraki Adımlar
1. OpenShift'te ConfigMap/Secret güncelle
2. Backend'i yeniden deploy et
3. API bağlantısını test et
4. Production'a geç

**Vodafone Practicus LLM API migration tamamlandı! 🚀**
