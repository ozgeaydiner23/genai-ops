# GENAI-OPS Configuration Guide

Bu döküman GENAI-OPS uygulamasının yapılandırma seçeneklerini açıklar.

## 📋 Yapılandırma Yöntemi

Tüm yapılandırma değerleri **environment variables** üzerinden yönetilir. Bu sayede:
- ✅ Kod içinde hassas bilgi bulunmaz
- ✅ OpenShift ConfigMap ve Secret ile yönetim kolaylaşır
- ✅ Farklı ortamlar (dev, test, prod) için farklı değerler kullanılabilir

## 🔧 Backend Yapılandırması

### Database Configuration

| Environment Variable | Açıklama | Varsayılan Değer | ConfigMap/Secret |
|---------------------|----------|------------------|------------------|
| `DB_URL` | PostgreSQL JDBC URL | `jdbc:postgresql://localhost:5432/genaiops` | ConfigMap |
| `DB_USERNAME` | Database kullanıcı adı | `genaiops` | ConfigMap |
| `DB_PASSWORD` | Database şifresi | - | **Secret** |

**Örnek:**
```yaml
# ConfigMap
DB_URL: "jdbc:postgresql://postgres-service:5432/genaiops"
DB_USERNAME: "genaiops"

# Secret
DB_PASSWORD: "your-secure-password"
```

---

### LLM Service Configuration (Vodafone Practicus API)

| Environment Variable | Açıklama | Varsayılan Değer | ConfigMap/Secret |
|---------------------|----------|------------------|------------------|
| `LLM_ENDPOINT_BASE_URL` | Vodafone Practicus base URL | `https://practicus.vodafone.local` | ConfigMap |
| `LLM_MODEL_NAME` | LLM model adı | `cwyd-llm-general-prod` | ConfigMap |
| `LLM_MODE` | Servis modu | `llm_as_service` | ConfigMap |
| `LLM_API_TOKEN` | LLM API JWT token (Bearer token) | - | **Secret** |
| `LLM_TIMEOUT` | Timeout (ms) | `45000` (45 saniye) | ConfigMap |
| `LLM_SYSTEM_PROMPT` | LLM rolü ve talimatları | AI assistant prompt | ConfigMap |

**Açıklama:**
- **Full URL Format:** `{LLM_ENDPOINT_BASE_URL}/models/{LLM_MODEL_NAME}/`
- **Request Format:** Vodafone API formatı kullanılır: `mode`, `system_prompt`, `user_prompt`
- **Response Format:** `status_code`, `status`, `message`, `answer` field'ları içerir
- `LLM_API_TOKEN`: HTTP isteklerinde `Authorization: Bearer <token>` header'ında kullanılır
- `LLM_SYSTEM_PROMPT`: LLM'nin rolünü ve davranışını tanımlar (ConfigMap'te yönetilebilir)

**Örnek:**
```yaml
# ConfigMap
LLM_ENDPOINT_BASE_URL: "https://practicus.vodafone.local"
LLM_MODEL_NAME: "cwyd-llm-general-prod"
LLM_MODE: "llm_as_service"
LLM_TIMEOUT: "45000"
LLM_SYSTEM_PROMPT: "You are an AI operations assistant for Vodafone..."

# Secret
LLM_API_TOKEN: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."  # JWT token
```

**API Request Format:**
```json
{
  "mode": "llm_as_service",
  "system_prompt": "You are an AI assistant...",
  "user_prompt": "User's message"
}
```

**API Response Format:**
```json
{
  "status_code": "200",
  "status": "success",
  "message": "Answer has been generated successfully",
  "answer": "AI response text"
}
```

---

### LDAP Configuration

| Environment Variable | Açıklama | Varsayılan Değer | ConfigMap/Secret |
|---------------------|----------|------------------|------------------|
| `LDAP_URL` | LDAP sunucu URL'i | `ldap://ldap.vpara.local:389` | ConfigMap |
| `LDAP_BASE_DN` | LDAP base DN | `dc=vpara,dc=local` | ConfigMap |
| `LDAP_BIND_DN` | LDAP bind DN | `cn=admin,dc=vpara,dc=local` | ConfigMap |
| `LDAP_BIND_PASSWORD` | LDAP bind şifresi | - | **Secret** |
| `LDAP_USER_SEARCH_BASE` | Kullanıcı arama base | `ou=users` | ConfigMap |
| `LDAP_USER_SEARCH_FILTER` | Kullanıcı arama filtresi | `(uid={0})` | ConfigMap |
| `LDAP_AUTH_GROUP` | Yetkili grup adı | `vepas_genaiops_edit` | ConfigMap |

**Örnek:**
```yaml
# ConfigMap
LDAP_URL: "ldap://ldap.vpara.local:389"
LDAP_BASE_DN: "dc=vpara,dc=local"
LDAP_BIND_DN: "cn=admin,dc=vpara,dc=local"
LDAP_USER_SEARCH_BASE: "ou=users"
LDAP_USER_SEARCH_FILTER: "(uid={0})"
LDAP_AUTH_GROUP: "vepas_genaiops_edit"

# Secret
LDAP_BIND_PASSWORD: "your-ldap-password"
```

---

### JWT Configuration

| Environment Variable | Açıklama | Varsayılan Değer | ConfigMap/Secret |
|---------------------|----------|------------------|------------------|
| `JWT_SECRET` | JWT signing key (min 256 bit) | - | **Secret** |
| `JWT_EXPIRATION` | Token geçerlilik süresi (ms) | `28800000` (8 saat) | ConfigMap |

**Örnek:**
```yaml
# ConfigMap
JWT_EXPIRATION: "28800000"  # 8 hours

# Secret
JWT_SECRET: "your-very-long-secret-key-minimum-256-bits-required-for-security"
```

---

### Admin User Configuration

| Environment Variable | Açıklama | Varsayılan Değer | ConfigMap/Secret |
|---------------------|----------|------------------|------------------|
| `ADMIN_USERNAME` | Admin kullanıcı adı | `admin` | ConfigMap |
| `ADMIN_PASSWORD` | Admin şifresi | - | **Secret** |
| `ADMIN_ENABLED` | Admin user aktif mi? | `true` | ConfigMap |

**Örnek:**
```yaml
# ConfigMap
ADMIN_USERNAME: "admin"
ADMIN_ENABLED: "true"

# Secret
ADMIN_PASSWORD: "your-secure-admin-password"
```

**Not:** Admin user, LDAP bağlantısı olmadığında veya test amaçlı kullanılabilir.

---

## 🎨 Frontend Yapılandırması

### Build-time Configuration

Frontend için API URL **build time**'da belirlenir:

```bash
# Docker build ile
docker build --build-arg VITE_API_URL=https://genaiops-api.vpara.local -t frontend .

# Veya .env dosyası ile
echo "VITE_API_URL=https://genaiops-api.vpara.local" > frontend/.env
npm run build
```

---

## 🐳 Docker Compose Örneği

Local development için `docker-compose.yml`:

```yaml
services:
  backend:
    environment:
      # Database
      DB_URL: jdbc:postgresql://postgres:5432/genaiops
      DB_USERNAME: genaiops
      DB_PASSWORD: genaiops123
      
      # LLM
      LLM_ENDPOINT_URL: http://llm-service:8000/api/chat
      LLM_API_TOKEN: mock-token
      
      # LDAP
      LDAP_URL: ldap://ldap.vpara.local:389
      LDAP_BASE_DN: dc=vpara,dc=local
      LDAP_BIND_DN: cn=admin,dc=vpara,dc=local
      LDAP_BIND_PASSWORD: admin
      LDAP_AUTH_GROUP: vepas_genaiops_edit
      
      # JWT
      JWT_SECRET: local-dev-secret-key-change-in-production
      JWT_EXPIRATION: 28800000
      
      # Admin
      ADMIN_USERNAME: admin
      ADMIN_PASSWORD: admin
      ADMIN_ENABLED: "true"
```

---

## ☸️ OpenShift ConfigMap Örneği

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: genai-ops-config
data:
  # Database
  DB_URL: "jdbc:postgresql://postgres-service:5432/genaiops"
  DB_USERNAME: "genaiops"
  
  # LLM
  LLM_ENDPOINT_URL: "http://llm-service.ai-platform.svc.cluster.local:8000/api/chat"
  LLM_TIMEOUT: "30000"
  
  # LDAP
  LDAP_URL: "ldap://ldap.vpara.local:389"
  LDAP_BASE_DN: "dc=vpara,dc=local"
  LDAP_BIND_DN: "cn=admin,dc=vpara,dc=local"
  LDAP_USER_SEARCH_BASE: "ou=users"
  LDAP_USER_SEARCH_FILTER: "(uid={0})"
  LDAP_AUTH_GROUP: "vepas_genaiops_edit"
  
  # JWT
  JWT_EXPIRATION: "28800000"
  
  # Admin
  ADMIN_USERNAME: "admin"
  ADMIN_ENABLED: "true"
```

---

## 🔐 OpenShift Secret Örneği

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: genai-ops-secret
type: Opaque
stringData:
  DB_PASSWORD: "your-db-password"
  LDAP_BIND_PASSWORD: "your-ldap-password"
  LLM_API_TOKEN: "your-llm-token"
  JWT_SECRET: "your-jwt-secret-minimum-256-bits"
  ADMIN_PASSWORD: "your-admin-password"
```

---

## 🔄 Yapılandırma Değişikliği

### OpenShift'te ConfigMap Güncelleme

```bash
# ConfigMap'i düzenle
oc edit configmap genai-ops-config

# Pod'ları yeniden başlat (değişikliklerin uygulanması için)
oc rollout restart deployment/genai-ops-backend
```

### OpenShift'te Secret Güncelleme

```bash
# Secret'ı düzenle
oc edit secret genai-ops-secret

# Pod'ları yeniden başlat
oc rollout restart deployment/genai-ops-backend
```

---

## ✅ Yapılandırma Doğrulama

### Backend Loglarını Kontrol Etme

```bash
# Docker
docker-compose logs backend | grep -i "config\|ldap\|database"

# OpenShift
oc logs deployment/genai-ops-backend | grep -i "config\|ldap\|database"
```

### Environment Variables Kontrol Etme

```bash
# Docker
docker exec genai-ops-backend env | grep -E "DB_|LDAP_|LLM_|JWT_|ADMIN_"

# OpenShift
oc exec deployment/genai-ops-backend -- env | grep -E "DB_|LDAP_|LLM_|JWT_|ADMIN_"
```

---

## 🎯 Ortam Bazlı Yapılandırma

### Development
- Admin user: **Aktif**
- LDAP: **Opsiyonel**
- LLM: **Mock response**

### Test
- Admin user: **Aktif**
- LDAP: **Test LDAP sunucusu**
- LLM: **Test LLM servisi**

### Production
- Admin user: **Opsiyonel** (sadece acil durum için)
- LDAP: **Production LDAP sunucusu**
- LLM: **Production LLM servisi**

---

## 📝 Güvenlik Notları

1. **Asla** hassas bilgileri kod içinde tutmayın
2. **Secret** kullanarak şifreleri yönetin
3. **JWT_SECRET** minimum 256 bit olmalı
4. **Production**'da güçlü şifreler kullanın
5. **LDAP_BIND_PASSWORD** güvenli bir şekilde saklayın
6. **Admin user** production'da devre dışı bırakılabilir

---

## 🆘 Sorun Giderme

### LDAP Bağlantı Hatası

```bash
# LDAP URL'i test et
curl -v ldap://ldap.vpara.local:389

# Backend loglarını kontrol et
oc logs deployment/genai-ops-backend | grep -i ldap
```

### Database Bağlantı Hatası

```bash
# Database bağlantısını test et
oc exec deployment/genai-ops-backend -- curl postgres-service:5432

# PostgreSQL loglarını kontrol et
oc logs deployment/postgres
```

### LLM Servis Hatası

```bash
# LLM endpoint'i test et (JWT token ile)
oc exec deployment/genai-ops-backend -- curl -v \
  -H "Authorization: Bearer <LLM_API_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"test","context":{}}' \
  <LLM_ENDPOINT_URL>

# Backend loglarını kontrol et
oc logs deployment/genai-ops-backend | grep -i llm

# Token'ın doğru olduğunu kontrol et
oc get secret genai-ops-secret -o jsonpath='{.data.LLM_API_TOKEN}' | base64 -d
```

---

**Happy Configuring! 🚀**
