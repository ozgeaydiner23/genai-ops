# Backend Mimari Dokümantasyonu

## Genel Bakış

GENAI-OPS Backend, Vodafone için geliştirilmiş bir AI operasyon asistanı API'sidir. Spring Boot 3.2.0 ve Java 17 kullanılarak geliştirilmiştir.

**Proje Bilgileri:**
- **Grup ID:** com.vodafone
- **Artifact ID:** genai-ops-backend
- **Versiyon:** 1.0.0
- **Port:** 8080

## Teknoloji Stack

### Core Framework
- **Spring Boot 3.2.0** - Ana uygulama framework'ü
- **Java 17** - Programlama dili

### Spring Modülleri
- **Spring Boot Web** - REST API endpoint'leri
- **Spring Boot Security** - Güvenlik ve kimlik doğrulama
- **Spring Boot Actuator** - Health check ve monitoring
- **Spring Data JPA** - Veritabanı ORM katmanı
- **Spring LDAP** - Active Directory entegrasyonu
- **Spring Security LDAP** - LDAP kimlik doğrulama

### Veritabanı
- **PostgreSQL** - İlişkisel veritabanı
- **Hibernate** - JPA implementasyonu

### Güvenlik
- **JWT (JSON Web Tokens)** - Token tabanlı kimlik doğrulama
  - jjwt-api 0.12.3
  - jjwt-impl 0.12.3
  - jjwt-jackson 0.12.3

### Yardımcı Kütüphaneler
- **Lombok** - Boilerplate kod azaltma
- **Spring Boot DevTools** - Geliştirme araçları

## Mimari Katmanlar

Backend uygulaması klasik 3-katmanlı mimari yapısını takip eder:

```
┌─────────────────────────────────────────┐
│         Controller Layer                │
│  (REST API Endpoints - HTTP İstekleri)  │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│          Service Layer                  │
│    (İş Mantığı ve Orchestration)        │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      Data Access Layer (DTO/Util)       │
│  (Veri Transfer ve Yardımcı Sınıflar)  │
└─────────────────────────────────────────┘
```

## Paket Yapısı

```
com.vodafone.genaiops/
├── GenaiOpsApplication.java          # Ana Spring Boot uygulaması
├── config/                            # Konfigürasyon sınıfları
│   ├── SecurityConfig.java           # Spring Security yapılandırması
│   └── CorsConfig.java                # CORS yapılandırması
├── controller/                        # REST API Controller'ları
│   ├── AuthController.java           # Kimlik doğrulama endpoint'leri
│   └── ChatController.java           # Chat endpoint'leri
├── service/                           # İş mantığı servisleri
│   ├── AuthService.java              # Kimlik doğrulama servisi
│   ├── ChatService.java              # Chat işlemleri servisi
│   └── LLMService.java                # LLM entegrasyon servisi
├── dto/                               # Data Transfer Objects
│   ├── LoginRequest.java
│   ├── LoginResponse.java
│   ├── ChatMessageRequest.java
│   ├── ChatMessageResponse.java
│   ├── FeedbackRequest.java
│   ├── FeedbackResponse.java
│   └── UserDTO.java
└── util/                              # Yardımcı sınıflar
    └── JwtUtil.java                   # JWT token işlemleri
```

## Detaylı Katman Analizi

### 1. Configuration Layer (config/)

#### SecurityConfig.java
**Amaç:** Spring Security yapılandırması

**Özellikler:**
- CSRF koruması devre dışı (stateless API)
- CORS devre dışı (nginx proxy kullanımı)
- Stateless session yönetimi (JWT kullanımı)
- Endpoint yetkilendirme kuralları:
  - `/api/auth/**` - Herkese açık
  - `/actuator/health/**` - Herkese açık
  - `/actuator/info` - Herkese açık
  - Diğer tüm endpoint'ler - Kimlik doğrulama gerekli

**Güvenlik Stratejisi:**
```java
SessionCreationPolicy.STATELESS  // Her istek bağımsız, session yok
```

#### CorsConfig.java
**Amaç:** Cross-Origin Resource Sharing yapılandırması

**Özellikler:**
- Tüm origin'lere izin (nginx proxy arkasında)
- İzin verilen HTTP metodları: GET, POST, PUT, DELETE, OPTIONS, PATCH
- Tüm header'lara izin
- Credential desteği aktif
- Preflight cache: 1 saat
- Expose edilen header'lar: Authorization, Content-Type

### 2. Controller Layer (controller/)

#### AuthController.java
**Endpoint:** `/api/auth`

**Metodlar:**
- `POST /api/auth/login` - Kullanıcı girişi

**İş Akışı:**
1. LoginRequest alır (username, password)
2. AuthService.login() çağırır
3. Başarılı: LoginResponse döner (token + user bilgisi)
4. Başarısız: 400 Bad Request veya 500 Internal Server Error

**Hata Yönetimi:**
- IllegalArgumentException → 400 Bad Request
- Diğer Exception'lar → 500 Internal Server Error

#### ChatController.java
**Endpoint:** `/api/chat`

**Metodlar:**
1. `POST /api/chat/message` - Chat mesajı gönderme
   - Authorization header gerekli (Bearer token)
   - ChatMessageRequest alır
   - ChatMessageResponse döner

2. `POST /api/chat/feedback` - Feedback gönderme
   - Authorization header gerekli
   - FeedbackRequest alır (messageId, feedback, comment)
   - FeedbackResponse döner

**Güvenlik:**
- Her istekte Authorization header kontrolü
- Bearer token formatı: `Bearer <jwt-token>`

### 3. Service Layer (service/)

#### AuthService.java
**Sorumluluklar:**
- Kullanıcı kimlik doğrulama
- LDAP entegrasyonu
- JWT token üretimi

**Kimlik Doğrulama Stratejisi:**
1. **Admin Kullanıcı Kontrolü**
   - Öncelikle admin credentials kontrol edilir
   - Başarılı: Admin grupları ile token üretilir

2. **LDAP Kimlik Doğrulama**
   - Vpara Active Directory ile entegrasyon
   - İki farklı bind metodu:
     - **Service Account Bind:** Servis hesabı ile kullanıcı arama
     - **Direct User Bind:** Doğrudan kullanıcı bind (fallback)

**LDAP Konfigürasyonu:**
```yaml
URL: ldaps://172.31.234.41:636
Domain: Vpara.local
Base DN: DC=vpara,DC=local
User Search Base: OU=VPARA,DC=vpara,DC=local
Search Filter: (sAMAccountName={0})
Auth Group: CN=vepas_genaiops_edit,OU=Groups,DC=vpara,DC=local
```

**Username Temizleme:**
Desteklenen formatlar:
- `username` → username
- `DOMAIN\username` → username
- `username@domain.com` → username

**Service Account Bind İş Akışı:**
1. Servis hesabı ile LDAP'a bağlan
2. sAMAccountName ile kullanıcıyı ara
3. Kullanıcının DN'ini al
4. Kullanıcı DN ve şifresi ile bind yap (şifre doğrulama)
5. Grup üyeliğini kontrol et (opsiyonel)
6. JWT token üret

**Direct Bind İş Akışı (Fallback):**
1. Farklı DN formatlarını dene:
   - `username@Vpara.local`
   - `VPARA\username`
   - `CN=username,DC=vpara,DC=local`
2. Başarılı bind ile kimlik doğrula

**Token Üretimi:**
```java
Claims:
- userId: UUID
- groups: List<String>
- subject: username
- issuedAt: şimdiki zaman
- expiration: 8 saat sonra
```

#### ChatService.java
**Sorumluluklar:**
- Chat mesajlarını işleme
- LLM servisi ile iletişim
- Feedback kaydetme

**processMessage() İş Akışı:**
1. JWT token doğrulama
2. Username çıkarma
3. Unique message ID üretme (UUID)
4. LLMService.sendMessage() çağırma
5. Response oluşturma
6. Console'a loglama (Phase 1.1 - veritabanı yok)

**processFeedback() İş Akışı:**
1. JWT token doğrulama
2. Username çıkarma
3. Feedback bilgilerini loglama
4. Success response dönme

**Loglama Formatı:**
```
=== CHAT LOG ===
User: username
Message ID: uuid
Request: user message
Response: llm response
Timestamp: ISO-8601
================
```

#### LLMService.java
**Sorumluluklar:**
- Vodafone Practicus LLM API entegrasyonu
- Mock response üretimi (fallback)

**LLM Konfigürasyonu:**
```yaml
Endpoint: https://practicus.vodafone.local
Model: cwyd-llm-general-prod
Mode: llm_as_service
Timeout: 45 saniye
Authentication: Bearer token
```

**API Request Formatı:**
```json
{
  "mode": "llm_as_service",
  "system_prompt": "AI assistant role tanımı",
  "user_prompt": "Kullanıcı mesajı"
}
```

**API Response Formatı:**
```json
{
  "status_code": "200",
  "status": "success",
  "message": "İşlem mesajı",
  "answer": "LLM cevabı"
}
```

**Hata Yönetimi:**
- API erişim hatası → Mock response
- Timeout → Mock response
- Non-success status → Mock response
- Missing answer field → Mock response

**Mock Response Stratejisi:**
Keyword tabanlı akıllı yanıtlar:
- "error", "issue" → Troubleshooting adımları
- "database", "connection" → Veritabanı çözümleri (kod örneği ile)
- "help", "how" → Genel yardım menüsü
- Default → Genel analiz ve öneriler

### 4. Data Transfer Objects (dto/)

#### LoginRequest
```java
- username: String
- password: String
```

#### LoginResponse
```java
- token: String (JWT)
- user: UserDTO
```

#### UserDTO
```java
- id: String (UUID)
- username: String
- groups: List<String>
```

#### ChatMessageRequest
```java
- message: String
```

#### ChatMessageResponse
```java
- response: String (LLM cevabı)
- messageId: String (UUID)
- timestamp: String (ISO-8601)
```

#### FeedbackRequest
```java
- messageId: String
- feedback: String ("like" veya "dislike")
- comment: String
```

#### FeedbackResponse
```java
- success: boolean
- message: String
```

**DTO Özellikleri:**
- Lombok annotations kullanımı (@Data, @Builder, @NoArgsConstructor, @AllArgsConstructor)
- Immutable olmayan yapı (setter'lar mevcut)
- Builder pattern desteği

### 5. Utility Layer (util/)

#### JwtUtil.java
**Sorumluluklar:**
- JWT token üretimi
- Token doğrulama
- Token parsing

**Konfigürasyon:**
```yaml
Secret: genai-ops-secret-key-change-in-production
Expiration: 28800000 ms (8 saat)
Algorithm: HS256
```

**Metodlar:**

1. **generateToken(UserDTO user)**
   - Claims oluşturur (userId, groups)
   - Subject olarak username set eder
   - IssuedAt ve Expiration tarihlerini ekler
   - HS256 ile imzalar

2. **validateToken(String token)**
   - Token'ı parse eder
   - İmza doğrulaması yapar
   - Expiration kontrolü yapar
   - Boolean döner

3. **extractUsername(String token)**
   - Token'dan subject (username) çıkarır

4. **extractAllClaims(String token)**
   - Token'ı parse edip tüm claims'leri döner

**Güvenlik:**
- HMAC-SHA256 algoritması
- Secret key byte array'e çevrilir
- Keys.hmacShaKeyFor() ile güvenli key üretimi

## Konfigürasyon Yönetimi

### application.yml Yapısı

#### Server Konfigürasyonu
```yaml
server:
  port: 8080
```

#### Database Konfigürasyonu
```yaml
spring:
  datasource:
    url: ${DB_URL:jdbc:postgresql://localhost:5432/genaiops}
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:postgres}
  jpa:
    hibernate:
      ddl-auto: update  # Otomatik schema güncelleme
    show-sql: false
```

#### LLM Konfigürasyonu
```yaml
llm:
  endpoint-base-url: ${LLM_ENDPOINT_BASE_URL}
  model-name: ${LLM_MODEL_NAME:cwyd-llm-general-prod}
  mode: ${LLM_MODE:llm_as_service}
  api-token: ${LLM_API_TOKEN}
  timeout: ${LLM_TIMEOUT:45000}
  system-prompt: ${LLM_SYSTEM_PROMPT}
```

#### JWT Konfigürasyonu
```yaml
jwt:
  secret: ${JWT_SECRET}
  expiration: 28800000  # 8 saat
```

#### LDAP Konfigürasyonu
```yaml
ldap:
  url: ${LDAP_URL:ldaps://172.31.234.41:636}
  domain: ${LDAP_DOMAIN:Vpara.local}
  base-dn: ${LDAP_BASE_DN:DC=vpara,DC=local}
  user-search-base: ${LDAP_USER_SEARCH_BASE}
  user-search-filter: ${LDAP_USER_SEARCH_FILTER:(sAMAccountName={0})}
  auth-group: ${LDAP_AUTH_GROUP}
  ca-cert-path: ${LDAP_CA_CERT_PATH}
```

#### Admin Konfigürasyonu
```yaml
admin:
  username: ${ADMIN_USERNAME:admin}
  password: ${ADMIN_PASSWORD:admin}
  enabled: ${ADMIN_ENABLED:true}
```

#### Actuator Konfigürasyonu
```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      probes:
        enabled: true  # Kubernetes liveness/readiness
  health:
    ldap:
      enabled: false  # Manuel LDAP health check
```

**Environment Variable Stratejisi:**
- Tüm hassas bilgiler environment variable'lardan alınır
- Default değerler development için sağlanır
- Production'da ConfigMap ve Secret kullanımı

## API Endpoint'leri

### Authentication Endpoints

#### POST /api/auth/login
**Amaç:** Kullanıcı girişi

**Request:**
```json
{
  "username": "user@domain.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "username": "user",
    "groups": ["vepas_genaiops_edit"]
  }
}
```

**Error Responses:**
- 400 Bad Request - Geçersiz credentials
- 500 Internal Server Error - Sunucu hatası

### Chat Endpoints

#### POST /api/chat/message
**Amaç:** LLM'e mesaj gönderme

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Request:**
```json
{
  "message": "How do I fix database connection timeout?"
}
```

**Response (200 OK):**
```json
{
  "response": "LLM cevabı...",
  "messageId": "uuid",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

#### POST /api/chat/feedback
**Amaç:** Mesaj için feedback gönderme

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Request:**
```json
{
  "messageId": "uuid",
  "feedback": "like",
  "comment": "Very helpful response"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Feedback recorded successfully"
}
```

### Health Check Endpoints

#### GET /actuator/health
**Amaç:** Uygulama sağlık kontrolü

**Response:**
```json
{
  "status": "UP"
}
```

#### GET /actuator/health/liveness
**Amaç:** Kubernetes liveness probe

#### GET /actuator/health/readiness
**Amaç:** Kubernetes readiness probe

## Güvenlik Mimarisi

### Kimlik Doğrulama Akışı

```
┌─────────┐                ┌─────────┐                ┌──────────┐
│ Client  │                │ Backend │                │   LDAP   │
└────┬────┘                └────┬────┘                └────┬─────┘
     │                          │                          │
     │  POST /api/auth/login    │                          │
     ├─────────────────────────>│                          │
     │  {username, password}    │                          │
     │                          │                          │
     │                          │  1. Admin check          │
     │                          │                          │
     │                          │  2. LDAP bind            │
     │                          ├─────────────────────────>│
     │                          │                          │
     │                          │  3. User search          │
     │                          │<─────────────────────────┤
     │                          │                          │
     │                          │  4. Password verify      │
     │                          ├─────────────────────────>│
     │                          │<─────────────────────────┤
     │                          │                          │
     │                          │  5. Group check          │
     │                          │                          │
     │  {token, user}           │  6. Generate JWT         │
     │<─────────────────────────┤                          │
     │                          │                          │
```

### JWT Token Yapısı

**Header:**
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**Payload:**
```json
{
  "sub": "username",
  "userId": "uuid",
  "groups": ["vepas_genaiops_edit"],
  "iat": 1705315200,
  "exp": 1705344000
}
```

**Signature:**
```
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret
)
```

### Authorization Akışı

```
┌─────────┐                ┌─────────┐
│ Client  │                │ Backend │
└────┬────┘                └────┬────┘
     │                          │
     │  POST /api/chat/message  │
     │  Authorization: Bearer   │
     ├─────────────────────────>│
     │                          │
     │                          │  1. Extract token
     │                          │  2. Validate token
     │                          │  3. Extract username
     │                          │  4. Process request
     │                          │
     │  {response}              │
     │<─────────────────────────┤
     │                          │
```

## Hata Yönetimi

### Exception Handling Stratejisi

1. **Controller Seviyesi**
   - try-catch blokları
   - HTTP status code mapping
   - Loglama

2. **Service Seviyesi**
   - Business logic validation
   - IllegalArgumentException fırlatma
   - Detaylı hata mesajları

3. **LDAP Hataları**
   - Connection timeout
   - Authentication failure
   - User not found
   - Group membership failure
   - Fallback mekanizması

4. **LLM Hataları**
   - API timeout
   - Connection error
   - Invalid response
   - Mock response fallback

### Loglama Stratejisi

**Log Seviyeleri:**
- **INFO:** Normal işlem akışı
- **DEBUG:** Detaylı debug bilgisi (LDAP, LLM)
- **WARN:** Uyarılar (login failure, fallback kullanımı)
- **ERROR:** Hatalar (exception'lar)

**Log Formatı:**
```
Console: %d{yyyy-MM-dd HH:mm:ss} - %msg%n
File: %d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
```

**Özel Loglar:**
- Chat mesajları (request/response)
- Feedback kayıtları
- LDAP authentication adımları
- LLM API çağrıları

## Deployment Mimarisi

### Container Yapısı

**Dockerfile Özellikleri:**
- Multi-stage build
- Maven build stage
- JRE runtime stage
- Port 8080 expose

### Kubernetes Deployment

**Resources:**
- CPU: 500m request, 1000m limit
- Memory: 512Mi request, 1Gi limit

**Probes:**
- Liveness: /actuator/health/liveness
- Readiness: /actuator/health/readiness

**Environment Variables:**
- ConfigMap: Non-sensitive config
- Secret: Passwords, tokens, keys

### External Dependencies

1. **PostgreSQL Database**
   - Connection pooling
   - Hibernate auto-update

2. **Vpara LDAP**
   - LDAPS (port 636)
   - CA certificate mount
   - Service account (optional)

3. **Vodafone LLM API**
   - HTTPS endpoint
   - Bearer token authentication
   - 45 second timeout

## Performans ve Ölçeklenebilirlik

### Stateless Design
- Session kullanımı yok
- JWT token tabanlı auth
- Horizontal scaling mümkün

### Connection Management
- Database connection pooling (HikariCP)
- RestTemplate timeout konfigürasyonu
- LDAP connection pooling

### Caching Stratejisi
- Şu an cache yok (Phase 1.1)
- Gelecek: Redis cache için hazır

## Güvenlik Best Practices

### Implemented
✅ JWT token authentication
✅ LDAPS (encrypted LDAP)
✅ Password hashing (LDAP tarafında)
✅ CSRF protection disabled (stateless API)
✅ Environment variable kullanımı
✅ Secret management (Kubernetes)
✅ Input validation
✅ Authorization header kontrolü

### Recommendations
⚠️ JWT secret production'da değiştirilmeli
⚠️ Rate limiting eklenebilir
⚠️ Request/response encryption (HTTPS)
⚠️ Audit logging eklenebilir
⚠️ Token refresh mechanism

## Gelecek Geliştirmeler (Roadmap)

### Phase 2 - Database Integration
- Chat history kaydetme
- Feedback veritabanına kaydetme
- User session tracking
- Analytics ve reporting

### Phase 3 - Advanced Features
- Multi-model LLM support
- Streaming responses
- File upload/download
- Context-aware conversations
- User preferences

### Phase 4 - Enterprise Features
- Multi-tenancy
- Role-based access control (RBAC)
- Audit logging
- Advanced analytics
- API rate limiting
- Caching layer (Redis)

## Sonuç

GENAI-OPS Backend, modern Spring Boot best practice'lerini takip eden, güvenli ve ölçeklenebilir bir mimari sunar. LDAP entegrasyonu, JWT authentication ve LLM servisi entegrasyonu ile enterprise-grade bir çözüm sağlar.

**Güçlü Yönler:**
- Temiz katmanlı mimari
- Comprehensive error handling
- Flexible LDAP authentication
- Mock fallback mekanizması
- Kubernetes-ready deployment
- Environment-based configuration

**İyileştirme Alanları:**
- Database persistence (Phase 2)
- Caching layer
- Rate limiting
- Advanced monitoring
- Token refresh mechanism
