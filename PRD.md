# PRD.md - Vepas Gen AI Ops (Faz 1)

## Proje Özeti

Vepas Gen AI Ops, müşteri şikayetlerinin yapay zeka destekli çözümünü hedefleyen bir projedir. Faz 1'de, DevOps ekibinin hazırladığı RAG dokümanlarına dayalı olarak çalışan bir chatbot sistemi geliştirilecektir.

## Proje Kapsamı (Faz 1)

### Faz 1.1 - Temel Chatbot Arayüzü (İlk Geliştirme)

- Basit kullanıcı girişi (mock authentication - LDAP entegrasyonu olmadan)
- RAG dokümanlarına dayalı chatbot arayüzü
- LLM (Large Language Model) ile entegrasyon
- HITL (Human In The Loop) geri bildirim mekanizması (frontend UI)
- Temel UI/UX implementasyonu (design.md'ye göre)

### Faz 1.2 - Kimlik Doğrulama ve Loglama Entegrasyonu

- LDAP kimlik doğrulamalı kullanıcı girişi
- Audit log sistemi (database entegrasyonu)
- Geri bildirim verilerinin database'e kaydedilmesi
- Session yönetimi ve güvenlik iyileştirmeleri

**Kapsam Dışı:** Dcase sisteminden ticket çekme (Faz 2) ve Agentic AI ile otomatik çözüm (Faz 3).

---

## Teknik Mimari

### Deployment Ortamı

- **Platform:** OpenShift
- **Version Control:** GitHub Enterprise
- **CI/CD:** GitHub Actions - Workflow Pipelines
- **Configuration Management:** ConfigMap (konfigürasyon), Secret (şifreler/tokenler)
- **Load Balancer:** https://genaiops.vpara.local

### Teknoloji Stack

#### Frontend

- **Framework:** React 18.x
- **UI Kütüphanesi:** Custom CSS (design.md spesifikasyonuna göre)
- **State Management:** React Context API
- **HTTP Client:** Axios
- **Build Tool:** Vite
- **Styling:** CSS Modules / Tailwind CSS (design.md token'larına göre)
- **Icon Library:** Lucide React
- **Container:** Nginx (production için)

#### Backend

- **Framework:** Java Spring Boot 3.x
- **API Standardı:** RESTful API
- **Authentication:** Spring Security + LDAP (Faz 1.2)
- **HTTP Client:** RestTemplate / WebClient (LLM isteği için)
- **Logging:** SLF4J + Logback
- **Database:** PostgreSQL (audit log için - Faz 1.2)
- **ORM:** Spring Data JPA + Hibernate
- **Build Tool:** Maven / Gradle

#### Database

- **Tip:** PostgreSQL
- **Deployment:** OpenShift içi veya External
- **Amaç:** Audit log kayıtları (Faz 1.2'de aktif)

#### DevOps

- **Container:** Docker
- **Orchestration:** OpenShift/Kubernetes
- **Secret Management:** OpenShift Secrets
- **Config Management:** OpenShift ConfigMap

---

## Sistem Bileşenleri

### 1. Frontend (Chatbot UI)

#### 1.1 Login Ekranı

**Özellikler:**
- LDAP kimlik doğrulaması
- Username ve password input alanları
- Hata mesajı gösterimi
- Yetki kontrolü: `vepas_genaiops_edit` grubu

**Gereksinimler:**
- Form validasyonu
- Güvenli şifre girişi (masked input)
- Loading state gösterimi
- Session yönetimi (JWT token veya session cookie)

#### 1.2 Chatbot Ekranı

**Layout Bileşenleri:**
- **Header:** Navigasyon menüsü (Chatbot sekmesi)
- **Chat Mesaj Listesi:** Kullanıcı ve AI mesajlarının gösterildiği alan
- **Input Alanı:** Mesaj yazma alanı ve gönder butonu
- **Geri Bildirim Butonları:** Her AI cevabı için "Beğendim/Beğenmedim" butonları

**Özellikler:**
- Gerçek zamanlı mesajlaşma görünümü
- Mesaj geçmişi (session bazlı)
- Loading indicator (AI cevabı beklerken)
- Error handling ve kullanıcı bildirimleri
- Responsive design (mobil uyumlu olmasına gerek yok, internal kullanım)

**UI Component Hiyerarşisi:**

```
ChatbotPage
├── Header
│   └── Navigation (Chatbot link)
├── ChatContainer
│   ├── MessageList
│   │   └── MessageItem
│   │       ├── UserMessage
│   │       └── AIMessage
│   │           └── FeedbackButtons (Beğen/Beğenme)
│   └── InputArea
│       ├── TextInput
│       └── SendButton
```

---

### 2. Backend (API Service)

#### 2.1 API Endpoints

**Authentication:**

```
POST /api/auth/login
```
- **Request:** `{ username, password }`
- **Response:** `{ token, user: { id, username, groups } }`

**Chatbot:**

```
POST /api/chat/message
```
- **Headers:** `{ Authorization: Bearer <token> }`
- **Request:** `{ message: string }`
- **Response:** 
```json
{
  "response": string,
  "messageId": string,
  "timestamp": string
}
```

**Feedback (HITL):**

```
POST /api/chat/feedback
```
- **Headers:** `{ Authorization: Bearer <token> }`
- **Request:** 
```json
{
  "messageId": string,
  "feedback": "like" | "dislike",
  "comment": string (optional)
}
```
- **Response:** `{ success: boolean }`

#### 2.2 Servisler

**LDAPService:**
- LDAP bağlantısı ve kimlik doğrulama
- Grup kontrolü (`vepas_genaiops_edit`)
- ConfigMap'ten LDAP ayarlarını okuma

**LLMService:**
- LLM endpoint'ine istek gönderme
- AI ekibinin "LLM as a Service" dökümanındaki spec'e uygun request/response
- Timeout ve error handling
- ConfigMap'ten LLM endpoint URL'ini okuma

**AuditLogService:**
- Database'e audit log kaydetme
- Asenkron log yazma (performans için)

**ChatService:**
- Mesaj işleme orchestration
- LLMService ve AuditLogService koordinasyonu

#### 2.3 Konfigürasyon Yönetimi

**ConfigMap İçeriği:**

```yaml
# Faz 1.2'de aktif olacak
LDAP_URL: ldap://ldap.vpara.local:389
LDAP_BASE_DN: dc=vpara,dc=local
LDAP_BIND_DN: cn=admin,dc=vpara,dc=local
LDAP_AUTH_GROUP: vepas_genaiops_edit

# Faz 1.1'de aktif
LLM_ENDPOINT_URL: <AI ekibinden gelecek>
DATABASE_HOST: postgres-service
DATABASE_PORT: 5432
DATABASE_NAME: genaiops_audit
LOG_LEVEL: info
```

**Secret İçeriği:**

```yaml
LDAP_BIND_PASSWORD: <encrypted>
LLM_API_TOKEN: <encrypted>
DATABASE_PASSWORD: <encrypted>
JWT_SECRET: <encrypted>
```

---

### 3. Database Schema

**Audit Log Tablosu:**

```sql
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL,
    service_name VARCHAR(100) NOT NULL,
    request_message TEXT NOT NULL,
    response_message TEXT NOT NULL,
    feedback VARCHAR(20),
    feedback_comment TEXT,
    request_timestamp TIMESTAMP NOT NULL,
    response_timestamp TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_timestamp (request_timestamp)
);
```

---

## Detaylı Akış Senaryoları

### Senaryo 1: Kullanıcı Girişi

**Faz 1.1 (Mock Authentication):**

1. Kullanıcı Load Balancer URL'sine erişir: `https://genaiops.vpara.local`
2. Frontend login ekranı render edilir
3. Kullanıcı username ve password girer
4. Frontend → Backend: `POST /api/auth/login`
5. Backend mock authentication yapar (hardcoded credentials veya basit validation)
6. Başarılı ise mock JWT token üretilir ve frontend'e dönülür
7. Frontend token'ı localStorage'a kaydeder ve chatbot sayfasına yönlendirir

**Faz 1.2 (LDAP Authentication):**

1. Kullanıcı Load Balancer URL'sine erişir: `https://genaiops.vpara.local`
2. Frontend login ekranı render edilir
3. Kullanıcı username ve password girer
4. Frontend → Backend: `POST /api/auth/login`
5. Backend LDAP'a bağlanır ve kimlik doğrular (Spring Security LDAP)
6. LDAP kullanıcının `vepas_genaiops_edit` grubunda olup olmadığını kontrol eder
7. Başarılı ise JWT token üretilir ve frontend'e dönülür
8. Frontend token'ı localStorage'a kaydeder ve chatbot sayfasına yönlendirir

### Senaryo 2: Chatbot Mesajlaşması

**Faz 1.1:**

1. Kullanıcı chatbot ekranında mesaj yazar ve gönder butonuna basar
2. Frontend mesajı ekranda "kullanıcı mesajı" olarak gösterir
3. Frontend → Backend: `POST /api/chat/message` (JWT token header'da)
4. Backend:
   - Token'ı doğrular (mock validation)
   - Mesajı LLMService'e iletir
   - LLMService → LLM endpoint: AI'dan cevap alır
   - Console'a log yazar (audit log database'e yazılmaz)
   - Frontend'e response döner
5. Frontend AI cevabını ekranda gösterir
6. Frontend her AI mesajının altında "Beğendim/Beğenmedim" butonlarını gösterir

**Faz 1.2:**

1. Kullanıcı chatbot ekranında mesaj yazar ve gönder butonuna basar
2. Frontend mesajı ekranda "kullanıcı mesajı" olarak gösterir
3. Frontend → Backend: `POST /api/chat/message` (JWT token header'da)
4. Backend:
   - Token'ı doğrular (JWT validation)
   - Mesajı LLMService'e iletir
   - LLMService → LLM endpoint: AI'dan cevap alır
   - AuditLogService: Database'e log kaydeder (PostgreSQL)
   - Frontend'e response döner
5. Frontend AI cevabını ekranda gösterir
6. Frontend her AI mesajının altında "Beğendim/Beğenmedim" butonlarını gösterir

### Senaryo 3: Geri Bildirim (HITL)

**Faz 1.1:**

1. Kullanıcı bir AI cevabının altındaki "Beğendim" veya "Beğenmedim" butonuna basar
2. Frontend → Backend: `POST /api/chat/feedback`
3. Backend:
   - Feedback bilgisini console'a log yazar
   - Success response döner
4. Frontend kullanıcıya "Geri bildiriminiz kaydedildi" bildirimi gösterir

**Faz 1.2:**

1. Kullanıcı bir AI cevabının altındaki "Beğendim" veya "Beğenmedim" butonuna basar
2. Frontend → Backend: `POST /api/chat/feedback`
3. Backend:
   - messageId ile ilgili audit log kaydını bulur (PostgreSQL)
   - Feedback bilgisini günceller
   - Opsiyonel: AI ekibine feedback verisi push edilir (webhook veya queue)
4. Frontend kullanıcıya "Geri bildiriminiz kaydedildi" bildirimi gösterir

---

## Logging Gereksinimleri

### Console Logging

- **Seviyeler:** ERROR, WARN, INFO, DEBUG
- **Format:** JSON structured logs
- **Örnekler:**
  - INFO: API request/response
  - ERROR: LDAP bağlantı hataları, LLM timeout
  - DEBUG: Konfigürasyon yükleme, token validasyonu

### Audit Logging

**Kaydedilecek Bilgiler:**
- `user_id`: Kullanıcı ID
- `username`: Kullanıcı adı
- `service_name`: "chatbot" veya "feedback"
- `request_message`: Kullanıcının gönderdiği mesaj
- `response_message`: AI'dan gelen cevap
- `feedback`: "like" | "dislike" | null
- `feedback_comment`: Opsiyonel yorum
- `request_timestamp`: İstek zamanı
- `response_timestamp`: Cevap zamanı

---

## GitHub Actions Pipeline

### Workflow Aşamaları

**1. Build:**
- Frontend: `npm install && npm run build`
- Backend: `npm install` veya Docker image build / `mvn clean package`

**2. Test:**
- Unit testler (opsiyonel, Faz 1'de minimal)
- Linting

**3. Push:**
- Docker image'ı OpenShift internal registry'ye push

**4. Deploy:**
- OpenShift DeploymentConfig güncelleme
- ConfigMap ve Secret mounting
- Rolling update

### Pipeline Tetikleyicileri

- `main` branch'e push
- Pull request (build ve test, deploy yok)

---

## OpenShift Deployment

### Resources

**Frontend Deployment:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: genaiops-frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: genaiops-frontend
  template:
    spec:
      containers:
      - name: frontend
        image: <registry>/genaiops-frontend:latest
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: config
          mountPath: /etc/config
      volumes:
      - name: config
        configMap:
          name: genaiops-config
```

**Backend Deployment:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: genaiops-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: genaiops-backend
  template:
    spec:
      containers:
      - name: backend
        image: <registry>/genaiops-backend:latest
        ports:
        - containerPort: 3000
        env:
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: genaiops-secrets
              key: database-password
        volumeMounts:
        - name: config
          mountPath: /etc/config
      volumes:
      - name: config
        configMap:
          name: genaiops-config
```

**Service & Route:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: genaiops-frontend-service
spec:
  selector:
    app: genaiops-frontend
  ports:
  - port: 8080
    targetPort: 8080
---
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: genaiops-route
spec:
  host: genaiops.vpara.local
  to:
    kind: Service
    name: genaiops-frontend-service
  tls:
    termination: edge
```

---

## Error Handling

### Frontend

- Network hataları için retry mekanizması
- LDAP auth hatalarında kullanıcı dostu mesajlar
- LLM timeout durumunda "Sistem meşgul, lütfen tekrar deneyin" mesajı
- Token expire durumunda otomatik logout ve login ekranına yönlendirme

### Backend

- LDAP bağlantı hatalarında graceful degradation
- LLM endpoint timeout: 30 saniye
- Database connection pool yönetimi
- Global exception handler (500 Internal Server Error)
- Structured error responses:

```json
{
  "error": {
    "code": "LLM_TIMEOUT",
    "message": "AI servisi şu anda yanıt vermiyor",
    "details": "Timeout after 30 seconds"
  }
}
```

---

## Security

### Authentication & Authorization

- LDAP üzerinden kimlik doğrulama
- JWT token bazlı session yönetimi
- Token expiration: 8 saat
- Grup bazlı yetkilendirme

### Data Security

- HTTPS/TLS encryption (OpenShift Route level)
- Şifreler ve tokenler Secret'larda encrypted
- SQL injection koruması (ORM kullanımı)
- XSS koruması (input sanitization)

### Network Security

- OpenShift NetworkPolicy ile pod-to-pod iletişim kontrolü
- LDAP ve Database erişimi sadece backend pod'larından

---

## Performance

### Targets

- Login response time: < 2 saniye
- Chatbot message response time: < 5 saniye (LLM'e bağlı)
- Audit log yazma: Asenkron (kullanıcıyı bloklamaz)
- Frontend load time: < 3 saniye

### Scaling

- Frontend: Horizontal scaling (replica count artırılabilir)
- Backend: Horizontal scaling (stateless design)
- Database: Connection pooling (max 20 connections)

---

## Monitoring & Observability

### Metrics

- API response times
- LLM request success/failure rate
- LDAP authentication success rate
- Audit log kayıt sayısı
- Active user sessions

### Logs

- OpenShift pod logs (stdout/stderr)
- Centralized logging (opsiyonel: ELK stack)
- Log rotation policy

---

## Testing Strategy (Minimal - Faz 1)

### Frontend

- Manual testing (QA ekibi)
- Browser compatibility: Chrome, Edge (internal kullanım)

### Backend

- API endpoint testing (Postman/Insomnia)
- LDAP integration test (test LDAP sunucusu)
- LLM mock test (development ortamında)

### Integration Testing

- End-to-end login flow
- Chatbot message flow
- Feedback flow

---

## Deployment Plan

### Phase 1: Development Environment

1. GitHub repo oluşturma
2. ConfigMap ve Secret hazırlama
3. Frontend ve Backend geliştirme
4. Local Docker test
5. OpenShift dev namespace'e deploy

### Phase 2: Test Environment

1. Test LDAP ve Database kurulumu
2. AI ekibinden test LLM endpoint alma
3. Integration testing
4. Bug fixing

### Phase 3: Production

1. Production ConfigMap ve Secret hazırlama
2. Production namespace'e deploy
3. Load Balancer konfigürasyonu
4. Kullanıcı kabul testleri
5. Go-live

---

## Riskler ve Önlemler

| Risk | Olasılık | Etki | Önlem |
|------|----------|------|-------|
| LLM endpoint'i stabil değil | Orta | Yüksek | Timeout, retry, fallback mesajları |
| LDAP bağlantı sorunları | Düşük | Orta | Connection pool, health check |
| RAG dokümanları eksik/hatalı | Orta | Orta | AI ekibi ile koordinasyon, eval testleri |
| OpenShift kaynak yetersizliği | Düşük | Orta | Resource request/limit tanımlama |

---

## Başarı Kriterleri

- Kullanıcılar LDAP ile başarıyla login olabiliyor
- Chatbot arayüzü çalışıyor ve mesajlaşma akışı sorunsuz
- LLM'den gelen cevaplar RAG dokümanlarına dayalı ve doğru
- Audit log'lar database'e kaydediliyor
- HITL geri bildirim sistemi çalışıyor
- OpenShift'te stable çalışıyor (7/24 uptime)
- GitHub Actions pipeline sorunsuz çalışıyor

---

## Gelecek Fazlara Hazırlık

### Faz 2 için Gereksinimler

- Dcase API entegrasyonu için servis katmanı genişletme
- Ticket polling/webhook mekanizması

### Faz 3 için Gereksinimler

- Agentic AI entegrasyonu için async job queue
- Çözüm otomasyonu için workflow engine

---

## Ekler

### A. LLM Integration Spec

AI ekibinin "LLM as a Service" dökümanına göre:

- **Endpoint URL:** ConfigMap'ten okunacak
- **Authentication:** Bearer token (Secret'ta)
- **Request format:** `{ prompt: string, context?: object }`
- **Response format:** `{ response: string, metadata?: object }`

### B. RAG Doküman Listesi

1. Case #1: [Konu başlığı]
2. Case #2: [Konu başlığı]
3. Case #3: [Konu başlığı]
4. Case #4: [Konu başlığı]
5. Case #5: [Konu başlığı]
6. Case #6: [Konu başlığı]
7. Case #7: [Konu başlığı]
8. Dcase Sistem Kullanım Kılavuzu

### C. Ekran Görüntüsü Analizi

Diyagramda görülen akış:

- Actor → Load Balancer → Frontend (LDAP Auth + Audit Log)
- Frontend → Backend → LLM (request/response cycle)
- Alt kısımda detaylı UI component yapısı gösteriliyor
- Vodafone branding ve çeşitli servis entegrasyonları mevcut (gelecek fazlar için)

---

**Doküman Versiyonu:** 1.0  
**Son Güncelleme:** 17 Kasım 2025  
**Hazırlayan:** DevOps Ekibi  
**Onaylayan:** [İlgili yönetici]


---

## Design System Integration (design.md'den)

### CSS Design Tokens

Frontend geliştirmede kullanılacak design token'ları:

#### Color Variables

```css
:root {
  /* Primary Colors */
  --color-vodafone-red: #E60000;
  --color-dark-bg: #1a1a1a;
  --color-dark-bg-secondary: #2a2a2a;
  --color-charcoal: #333333;
  --color-charcoal-light: #444444;
  
  /* Secondary Colors */
  --color-white: #FFFFFF;
  --color-light-gray: #F5F5F5;
  --color-light-gray-dark: #E8E8E8;
  --color-medium-gray: #999999;
  --color-medium-gray-light: #CCCCCC;
  
  /* Status Colors */
  --color-success: #4CAF50;
  --color-success-bright: #00C853;
  --color-warning: #FFC107;
  --color-warning-bright: #FFB300;
  --color-error: #FF5252;
  --color-error-dark: #F44336;
  --color-info: #2196F3;
  --color-info-light: #42A5F5;
  
  /* Gradients */
  --gradient-red: linear-gradient(135deg, #E60000, #FF4444);
  --gradient-dark: linear-gradient(180deg, #1a1a1a, #2a2a2a);
  
  /* Glass Effect */
  --glass-bg: rgba(255, 255, 255, 0.05);
  --glass-border: rgba(255, 255, 255, 0.1);
}
```

#### Typography Variables

```css
:root {
  /* Font Family */
  --font-primary: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  --font-mono: "Fira Code", "Courier New", monospace;
  
  /* Font Sizes */
  --font-size-h1: 32px;
  --font-size-h2: 24px;
  --font-size-h3: 20px;
  --font-size-body-large: 16px;
  --font-size-body: 14px;
  --font-size-small: 12px;
  --font-size-tiny: 10px;
  
  /* Font Weights */
  --font-weight-regular: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;
}
```

#### Spacing Variables

```css
:root {
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;
  --spacing-2xl: 48px;
  --spacing-3xl: 64px;
}
```

#### Border Radius Variables

```css
:root {
  --radius-small: 4px;
  --radius-medium: 8px;
  --radius-large: 12px;
  --radius-xl: 16px;
  --radius-round: 50%;
}
```

#### Shadow Variables

```css
:root {
  --shadow-small: 0 2px 4px rgba(0, 0, 0, 0.1);
  --shadow-medium: 0 4px 12px rgba(0, 0, 0, 0.15);
  --shadow-large: 0 8px 24px rgba(0, 0, 0, 0.2);
  --shadow-red-glow: 0 4px 20px rgba(230, 0, 0, 0.3);
}
```

#### Transition Variables

```css
:root {
  --transition-fast: 200ms ease-in-out;
  --transition-normal: 300ms ease-in-out;
  --transition-smooth: 300ms cubic-bezier(0.4, 0, 0.2, 1);
}
```

### Component CSS Specifications

#### Button Styles

```css
/* Primary Button */
.btn-primary {
  background: var(--color-vodafone-red);
  color: var(--color-white);
  font-weight: var(--font-weight-semibold);
  padding: 12px 24px;
  border-radius: var(--radius-medium);
  border: none;
  cursor: pointer;
  transition: all var(--transition-fast);
}

.btn-primary:hover {
  background: #CC0000;
  transform: scale(1.02);
  box-shadow: var(--shadow-red-glow);
}

.btn-primary:active {
  transform: scale(0.98);
}

/* Secondary Button */
.btn-secondary {
  background: transparent;
  color: var(--color-white);
  font-weight: var(--font-weight-semibold);
  padding: 12px 24px;
  border-radius: var(--radius-medium);
  border: 1px solid var(--color-medium-gray);
  cursor: pointer;
  transition: all var(--transition-fast);
}

.btn-secondary:hover {
  border-color: var(--color-white);
  background: rgba(255, 255, 255, 0.05);
}

/* Ghost Button */
.btn-ghost {
  background: transparent;
  color: var(--color-medium-gray);
  font-weight: var(--font-weight-semibold);
  padding: 12px 24px;
  border: none;
  cursor: pointer;
  transition: color var(--transition-fast);
}

.btn-ghost:hover {
  color: var(--color-white);
}

/* Icon Button */
.btn-icon {
  width: 40px;
  height: 40px;
  border-radius: var(--radius-round);
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  cursor: pointer;
  transition: all var(--transition-fast);
}

.btn-icon:hover {
  background: rgba(255, 255, 255, 0.1);
}
```

#### Input Field Styles

```css
/* Text Input */
.input-field {
  height: 44px;
  background: var(--color-dark-bg-secondary);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-medium);
  padding: 12px 16px;
  font-size: var(--font-size-body);
  color: var(--color-white);
  font-family: var(--font-primary);
  transition: all var(--transition-fast);
}

.input-field::placeholder {
  color: var(--color-medium-gray);
  opacity: 0.6;
}

.input-field:focus {
  outline: none;
  border-color: var(--color-vodafone-red);
  box-shadow: 0 0 0 3px rgba(230, 0, 0, 0.1);
}

/* Input Label */
.input-label {
  font-size: var(--font-size-small);
  color: var(--color-medium-gray);
  margin-bottom: 6px;
  display: block;
}
```

#### Card Styles

```css
/* Standard Card */
.card {
  background: var(--color-dark-bg-secondary);
  border-radius: var(--radius-large);
  padding: 24px;
  box-shadow: var(--shadow-small);
  transition: all var(--transition-normal);
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-medium);
}

/* Glass Card */
.card-glass {
  background: var(--glass-bg);
  backdrop-filter: blur(10px);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-large);
  padding: 24px;
}
```

#### Badge Styles

```css
/* Status Badge Base */
.badge {
  padding: 4px 12px;
  border-radius: var(--radius-large);
  font-size: var(--font-size-small);
  font-weight: var(--font-weight-semibold);
  display: inline-block;
}

/* Status Variants */
.badge-success {
  background: rgba(76, 175, 80, 0.2);
  color: var(--color-success-bright);
}

.badge-warning {
  background: rgba(255, 193, 7, 0.2);
  color: var(--color-warning-bright);
}

.badge-error {
  background: rgba(255, 82, 82, 0.2);
  color: var(--color-error);
}

.badge-info {
  background: rgba(33, 150, 243, 0.2);
  color: var(--color-info-light);
}
```

#### Avatar Styles

```css
/* User Avatar */
.avatar {
  width: 36px;
  height: 36px;
  border-radius: var(--radius-round);
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar-large {
  width: 40px;
  height: 40px;
}

/* AI Avatar */
.avatar-ai {
  background: var(--color-charcoal);
  color: var(--color-white);
}
```

#### Chat Message Styles

```css
/* AI Message (Left) */
.message-ai {
  display: flex;
  flex-direction: row;
  gap: 12px;
  margin-bottom: 24px;
}

.message-ai .message-bubble {
  background: var(--color-dark-bg-secondary);
  border-radius: 12px;
  border-bottom-left-radius: 4px;
  padding: 16px 20px;
  max-width: 70%;
  box-shadow: var(--shadow-small);
}

.message-ai .message-text {
  font-size: var(--font-size-body);
  color: var(--color-white);
  line-height: 1.6;
}

/* User Message (Right) */
.message-user {
  display: flex;
  flex-direction: row-reverse;
  gap: 12px;
  margin-bottom: 24px;
}

.message-user .message-bubble {
  background: var(--color-vodafone-red);
  border-radius: 12px;
  border-bottom-right-radius: 4px;
  padding: 12px 20px;
  max-width: 60%;
}

.message-user .message-text {
  font-size: var(--font-size-body);
  color: var(--color-white);
  text-align: right;
}

/* Code Block in Message */
.code-block {
  background: #000000;
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-medium);
  padding: 16px;
  margin: 12px 0;
  font-family: var(--font-mono);
  font-size: 13px;
  overflow-x: auto;
}

.code-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.code-language {
  font-size: var(--font-size-small);
  color: var(--color-medium-gray);
}

.code-copy-btn {
  color: var(--color-medium-gray);
  cursor: pointer;
  transition: color var(--transition-fast);
}

.code-copy-btn:hover {
  color: var(--color-white);
}
```

#### Sidebar Styles

```css
/* Sidebar Container */
.sidebar {
  width: 240px;
  background: var(--color-dark-bg);
  border-right: 1px solid var(--glass-border);
  height: 100vh;
  position: fixed;
  left: 0;
  top: 0;
}

/* Sidebar Menu Item */
.sidebar-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  border-radius: var(--radius-medium);
  color: var(--color-white);
  font-size: var(--font-size-body);
  cursor: pointer;
  transition: all var(--transition-fast);
  margin-bottom: 4px;
}

.sidebar-item:hover {
  background: rgba(255, 255, 255, 0.05);
}

.sidebar-item.active {
  background: var(--color-vodafone-red);
}

.sidebar-item-icon {
  width: 20px;
  height: 20px;
}
```

#### Login Page Styles

```css
/* Login Container */
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #F5F5F5, #FFFFFF);
}

/* Login Card */
.login-card {
  width: 100%;
  max-width: 400px;
  background: var(--color-white);
  border-radius: var(--radius-xl);
  padding: 48px 40px;
  box-shadow: var(--shadow-large);
}

/* Login Header */
.login-header {
  text-align: center;
  margin-bottom: 32px;
}

.login-logo {
  margin-bottom: 64px;
}

.login-title {
  font-size: var(--font-size-h2);
  font-weight: var(--font-weight-bold);
  color: var(--color-charcoal);
  margin-bottom: 8px;
}

.login-subtitle {
  font-size: var(--font-size-body);
  color: var(--color-medium-gray);
}

/* Login Form */
.login-form-group {
  margin-bottom: 20px;
}

.login-submit {
  width: 100%;
  height: 48px;
  margin-top: 8px;
}

.login-forgot {
  text-align: center;
  margin-top: 16px;
}

.login-forgot-link {
  color: var(--color-vodafone-red);
  font-size: var(--font-size-small);
  text-decoration: none;
  transition: text-decoration var(--transition-fast);
}

.login-forgot-link:hover {
  text-decoration: underline;
}
```

#### Chat Input Area Styles

```css
/* Chat Input Container */
.chat-input-area {
  position: fixed;
  bottom: 0;
  left: 240px;
  right: 0;
  background: var(--color-dark-bg-secondary);
  border-top: 1px solid var(--glass-border);
  padding: 20px 32px;
}

.chat-input-wrapper {
  max-width: 900px;
  margin: 0 auto;
}

.chat-input-container {
  background: var(--color-dark-bg);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-large);
  padding: 12px 16px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.chat-input {
  flex: 1;
  background: transparent;
  border: none;
  color: var(--color-white);
  font-size: var(--font-size-body);
  font-family: var(--font-primary);
  outline: none;
}

.chat-input::placeholder {
  color: var(--color-medium-gray);
}

.chat-attachment-btn {
  color: var(--color-medium-gray);
  cursor: pointer;
  transition: color var(--transition-fast);
}

.chat-attachment-btn:hover {
  color: var(--color-white);
}

.chat-send-btn {
  width: 40px;
  height: 40px;
  border-radius: var(--radius-round);
  background: var(--color-vodafone-red);
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all var(--transition-fast);
}

.chat-send-btn:hover {
  background: #CC0000;
  box-shadow: var(--shadow-red-glow);
}
```

#### Feedback Button Styles

```css
/* Feedback Buttons Container */
.feedback-buttons {
  display: flex;
  gap: 8px;
  margin-top: 12px;
}

.feedback-btn {
  padding: 6px 12px;
  border-radius: var(--radius-medium);
  border: 1px solid var(--glass-border);
  background: transparent;
  color: var(--color-medium-gray);
  font-size: var(--font-size-small);
  cursor: pointer;
  transition: all var(--transition-fast);
  display: flex;
  align-items: center;
  gap: 4px;
}

.feedback-btn:hover {
  border-color: var(--color-vodafone-red);
  color: var(--color-vodafone-red);
}

.feedback-btn.active {
  background: var(--color-vodafone-red);
  border-color: var(--color-vodafone-red);
  color: var(--color-white);
}
```

### Layout Specifications

#### Main Layout Structure

```css
/* App Container */
.app-container {
  display: flex;
  min-height: 100vh;
  background: var(--color-dark-bg);
  color: var(--color-white);
  font-family: var(--font-primary);
}

/* Main Content Area */
.main-content {
  flex: 1;
  margin-left: 240px;
  display: flex;
  flex-direction: column;
}

/* Chat Container */
.chat-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* Messages Container */
.messages-container {
  flex: 1;
  overflow-y: auto;
  padding: 32px;
  max-width: 900px;
  margin: 0 auto;
  width: 100%;
}
```

### Responsive Design

```css
/* Tablet and Mobile */
@media (max-width: 1024px) {
  .sidebar {
    transform: translateX(-100%);
    transition: transform var(--transition-normal);
  }
  
  .sidebar.open {
    transform: translateX(0);
  }
  
  .main-content {
    margin-left: 0;
  }
  
  .chat-input-area {
    left: 0;
  }
}

@media (max-width: 768px) {
  .login-card {
    padding: 32px 24px;
  }
  
  .message-ai .message-bubble,
  .message-user .message-bubble {
    max-width: 85%;
  }
  
  .messages-container {
    padding: 16px;
  }
}
```

### Accessibility Styles

```css
/* Focus States */
*:focus-visible {
  outline: 2px solid var(--color-vodafone-red);
  outline-offset: 2px;
}

/* Skip to Content Link */
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: var(--color-vodafone-red);
  color: var(--color-white);
  padding: 8px 16px;
  text-decoration: none;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
```

### Animation Keyframes

```css
/* Loading Spinner */
@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.spinner {
  width: 24px;
  height: 24px;
  border: 3px solid var(--glass-border);
  border-top-color: var(--color-vodafone-red);
  border-radius: var(--radius-round);
  animation: spin 1s linear infinite;
}

/* Shimmer Effect for Loading */
@keyframes shimmer {
  0% {
    background-position: -1000px 0;
  }
  100% {
    background-position: 1000px 0;
  }
}

.skeleton {
  background: linear-gradient(
    90deg,
    var(--color-dark-bg-secondary) 0%,
    var(--color-charcoal) 50%,
    var(--color-dark-bg-secondary) 100%
  );
  background-size: 1000px 100%;
  animation: shimmer 2s infinite;
}

/* Fade In */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn 0.3s ease-out;
}

/* Slide In from Top */
@keyframes slideInTop {
  from {
    transform: translateY(-100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.notification {
  animation: slideInTop 0.3s ease-out;
}
```

---

## Frontend Implementation Guidelines

### Component Structure

Tüm React componentleri design.md'deki spesifikasyonlara göre geliştirilmelidir:

1. **Reusable Components** (`/src/components/common/`):
   - Button.jsx - Tüm button varyantları
   - Input.jsx - Form input elementleri
   - Card.jsx - Card container'lar
   - Badge.jsx - Status badge'leri
   - Avatar.jsx - User ve AI avatar'ları

2. **Layout Components** (`/src/components/layout/`):
   - Sidebar.jsx - Sol navigasyon menüsü
   - ChatHeader.jsx - Chat sayfası header'ı
   - ChatInput.jsx - Mesaj input alanı

3. **Feature Components** (`/src/components/chat/`):
   - ChatMessage.jsx - Mesaj bubble'ları
   - FeedbackButtons.jsx - Beğen/Beğenme butonları
   - MessageList.jsx - Mesaj listesi container'ı

4. **Pages** (`/src/pages/`):
   - LoginPage.jsx - Giriş sayfası
   - ChatPage.jsx - Ana chatbot sayfası

### CSS Organization

```
/src/styles/
  - variables.css      (Design tokens)
  - global.css         (Global styles, resets)
  - components.css     (Component-specific styles)
  - layouts.css        (Layout styles)
  - animations.css     (Keyframes and transitions)
  - utilities.css      (Helper classes)
```

### Development Checklist

**Faz 1.1:**
- [ ] Design token'larını CSS variables olarak tanımla
- [ ] Reusable component library oluştur
- [ ] Login sayfası UI implementasyonu
- [ ] Chat sayfası layout ve UI
- [ ] Message bubble'ları ve chat input
- [ ] Feedback butonları UI
- [ ] Mock authentication flow
- [ ] LLM entegrasyonu (backend)
- [ ] Responsive design testleri

**Faz 1.2:**
- [ ] LDAP authentication entegrasyonu
- [ ] Database schema oluşturma
- [ ] Audit log servisi implementasyonu
- [ ] Feedback database kayıt işlemleri
- [ ] Session yönetimi ve JWT
- [ ] Security iyileştirmeleri
- [ ] Production deployment hazırlıkları

---

**Design System Entegrasyonu Tamamlandı**
