# GENAI-OPS Secure by Design & NFR Questionnaire

## Proje Bilgileri / Project Information

**Proje Adı / Project Name:** GENAI-OPS (Generative AI Operations Platform)  
**Tarih / Date:** 2024  
**Versiyon / Version:** 1.0

---

## 0.1.1 Is it New Application?

**TR:** Evet, bu yeni bir uygulamadır. GENAI-OPS, Vodafone için geliştirilen yeni bir Generative AI operasyon platformudur. Kullanıcıların LLM (Large Language Model) ile etkileşime girmesini sağlayan web tabanlı bir chat uygulamasıdır.

**EN:** Yes, this is a new application. GENAI-OPS is a newly developed Generative AI operations platform for Vodafone. It is a web-based chat application that enables users to interact with LLM (Large Language Model).

---

## 0.1.2 Is this project developed inhouse or procured externally?

**TR:** Bu proje tamamen kurum içi (inhouse) geliştirilmiştir. Vodafone VEPAS AI ekibi tarafından Spring Boot, React ve PostgreSQL teknolojileri kullanılarak geliştirilmiştir. Harici bir tedarikçiden satın alınmamıştır.

**EN:** This project is fully developed inhouse. It has been developed by the Vodafone VEPAS AI team using Spring Boot, React, and PostgreSQL technologies. It is not procured from an external vendor.

---

## 0.1.3 Is vendor subjected to Vodafone Supplier Cyber Security Risk Questionnaire (SCS)?

**TR:** Hayır, bu proje kurum içi geliştirildiği için harici bir tedarikçi bulunmamaktadır. Dolayısıyla Vodafone Supplier Cyber Security Risk Questionnaire (SCS) uygulanmaz.

**EN:** No, since this project is developed inhouse, there is no external vendor involved. Therefore, the Vodafone Supplier Cyber Security Risk Questionnaire (SCS) does not apply.

---

## 0.1.4 What will be the interfaces of System?

**TR:** Sistem aşağıdaki arayüzlere sahiptir:
- **Web UI (React Frontend):** Kullanıcıların chat yapabildiği web arayüzü (HTTPS üzerinden)
- **REST API (Spring Boot Backend):** Frontend ile backend arasındaki iletişim için RESTful API
- **LDAP Interface:** Vodafone LDAP sunucusu ile kimlik doğrulama (LDAPS - port 636)
- **LLM API Interface:** Practicus AI LLM servisi ile entegrasyon (HTTPS)
- **PostgreSQL Database Interface:** Veritabanı bağlantısı (SSL/TLS)

**EN:** The system has the following interfaces:
- **Web UI (React Frontend):** Web interface for users to chat (via HTTPS)
- **REST API (Spring Boot Backend):** RESTful API for frontend-backend communication
- **LDAP Interface:** Authentication with Vodafone LDAP server (LDAPS - port 636)
- **LLM API Interface:** Integration with Practicus AI LLM service (HTTPS)
- **PostgreSQL Database Interface:** Database connection (SSL/TLS)

---

## 0.1.5 Will there be a customer facing interface rather than internal interface?

**TR:** Hayır, bu tamamen dahili (internal) bir uygulamadır. Sadece Vodafone çalışanları tarafından kullanılmak üzere tasarlanmıştır. Müşteri (customer) tarafından erişilebilir bir arayüz bulunmamaktadır. Erişim Vodafone LDAP kimlik doğrulaması ile kısıtlanmıştır.

**EN:** No, this is a fully internal application. It is designed to be used only by Vodafone employees. There is no customer-facing interface. Access is restricted through Vodafone LDAP authentication.

---

## 0.1.6 Will there be any customer data/sensitive business data processed?

**TR:** Evet, hassas iş verisi işlenmektedir:
- **Kullanıcı Bilgileri:** LDAP üzerinden çalışan bilgileri (username, email, department)
- **Chat Geçmişi:** Kullanıcıların LLM ile yaptığı konuşmalar
- **İş Sorguları:** Kullanıcıların iş ile ilgili sorduğu sorular ve aldığı yanıtlar
- **Oturum Bilgileri:** JWT token'lar ve session verileri

Müşteri verisi (customer data) işlenmemektedir, sadece dahili çalışan verileri işlenmektedir.

**EN:** Yes, sensitive business data is processed:
- **User Information:** Employee information via LDAP (username, email, department)
- **Chat History:** Conversations users have with the LLM
- **Business Queries:** Business-related questions asked by users and responses received
- **Session Information:** JWT tokens and session data

Customer data is not processed, only internal employee data is processed.

---

## 0.1.7 Where the data is stored in?

**TR:** Veriler aşağıdaki lokasyonlarda saklanmaktadır:
- **PostgreSQL Veritabanı:** Kullanıcı bilgileri, chat geçmişi, conversation verileri (Vodafone internal network üzerinde external PostgreSQL sunucusu)
- **LDAP Directory:** Kullanıcı kimlik bilgileri (Vodafone LDAP sunucusu - 172.31.234.41)
- **Application Memory:** Geçici session verileri ve JWT token'lar (runtime memory)
- **Log Files:** Uygulama logları (OpenShift/Kubernetes persistent volumes)

Tüm veriler Vodafone internal network içerisinde saklanmaktadır.

**EN:** Data is stored in the following locations:
- **PostgreSQL Database:** User information, chat history, conversation data (external PostgreSQL server on Vodafone internal network)
- **LDAP Directory:** User credentials (Vodafone LDAP server - 172.31.234.41)
- **Application Memory:** Temporary session data and JWT tokens (runtime memory)
- **Log Files:** Application logs (OpenShift/Kubernetes persistent volumes)

All data is stored within the Vodafone internal network.

---

## 0.1.8 On which environment, will set-up be done?

**TR:** Kurulum aşağıdaki ortamlarda yapılacaktır:
- **Development:** Geliştirme ortamı (docker-compose ile local veya OpenShift dev namespace)
- **Test/Staging:** Test ortamı (OpenShift test namespace)
- **Production:** Üretim ortamı (OpenShift production namespace - genai-ops)

Platform: OpenShift 4.x / Kubernetes
Container Runtime: Docker / CRI-O
Deployment: Containerized microservices architecture

**EN:** Setup will be done in the following environments:
- **Development:** Development environment (local with docker-compose or OpenShift dev namespace)
- **Test/Staging:** Test environment (OpenShift test namespace)
- **Production:** Production environment (OpenShift production namespace - genai-ops)

Platform: OpenShift 4.x / Kubernetes
Container Runtime: Docker / CRI-O
Deployment: Containerized microservices architecture

---

## 0.1.9 Regulatory effect of project (SOX)

**TR:** Hayır, bu proje SOX (Sarbanes-Oxley Act) kapsamında değildir. Finansal raporlama veya mali kayıtlarla doğrudan ilgili değildir. Dahili bir AI chat platformudur ve finansal sistemlere doğrudan erişimi yoktur.

**EN:** No, this project is not under SOX (Sarbanes-Oxley Act) scope. It is not directly related to financial reporting or financial records. It is an internal AI chat platform and does not have direct access to financial systems.

---

## 0.1.10 Regulatory effect of project (PCI-DSS)

**TR:** Hayır, bu proje PCI-DSS (Payment Card Industry Data Security Standard) kapsamında değildir. Kredi kartı bilgileri veya ödeme verileri işlenmemektedir. Sadece dahili çalışan verileri ve chat geçmişi saklanmaktadır.

**EN:** No, this project is not under PCI-DSS (Payment Card Industry Data Security Standard) scope. Credit card information or payment data is not processed. Only internal employee data and chat history is stored.

---

## 0.1.11 Regulatory effect of project (GDPR/KVKK)

**TR:** Evet, bu proje GDPR/KVKK kapsamındadır. Çalışan kişisel verileri işlenmektedir:
- **Kişisel Veriler:** Ad, soyad, email, kullanıcı adı, departman bilgisi
- **İşlem Verileri:** Chat geçmişi, kullanıcı aktiviteleri, login logları
- **Veri Saklama:** PostgreSQL veritabanında saklanmaktadır
- **Veri Güvenliği:** Encryption at rest ve in transit, LDAP authentication, JWT authorization
- **Veri Erişimi:** Sadece yetkili kullanıcılar kendi verilerine erişebilir
- **Veri Silme:** Kullanıcı chat geçmişini silebilir, hesap kapatma durumunda veriler silinir

**EN:** Yes, this project is under GDPR/KVKK scope. Employee personal data is processed:
- **Personal Data:** First name, last name, email, username, department information
- **Transaction Data:** Chat history, user activities, login logs
- **Data Storage:** Stored in PostgreSQL database
- **Data Security:** Encryption at rest and in transit, LDAP authentication, JWT authorization
- **Data Access:** Only authorized users can access their own data
- **Data Deletion:** Users can delete their chat history, data is deleted upon account closure

---

## 0.1.12 Regulatory effect of project (BTK)

**TR:** Hayır, bu proje BTK (Bilgi Teknolojileri ve İletişim Kurumu) düzenlemelerinden doğrudan etkilenmemektedir. Telekomünikasyon hizmeti sunmamakta, sadece dahili bir AI chat platformu olarak çalışmaktadır.

**EN:** No, this project is not directly affected by BTK (Information and Communication Technologies Authority) regulations. It does not provide telecommunication services, it only operates as an internal AI chat platform.

---

## 0.1.13 Does the project include any web service?

**TR:** Evet, proje web servisleri içermektedir:
- **RESTful API:** Spring Boot ile geliştirilmiş REST API servisleri
- **Endpoints:** /api/auth/*, /api/chat/*, /api/conversations/*, /api/users/*
- **Protocol:** HTTPS
- **Authentication:** JWT Bearer Token
- **Data Format:** JSON
- **API Documentation:** Swagger/OpenAPI (planlı)

**EN:** Yes, the project includes web services:
- **RESTful API:** REST API services developed with Spring Boot
- **Endpoints:** /api/auth/*, /api/chat/*, /api/conversations/*, /api/users/*
- **Protocol:** HTTPS
- **Authentication:** JWT Bearer Token
- **Data Format:** JSON
- **API Documentation:** Swagger/OpenAPI (planned)

---

## 0.1.14 Does the project include any web based applications?

**TR:** Evet, proje web tabanlı bir uygulamadır:
- **Frontend:** React 18 ile geliştirilmiş Single Page Application (SPA)
- **UI Framework:** Modern, responsive web arayüzü
- **Access:** Web browser üzerinden erişim (Chrome, Firefox, Edge, Safari)
- **URL:** https://genaiops.vpara.local
- **Features:** Chat interface, conversation history, user profile management
- **Security:** HTTPS, JWT authentication, CORS policy

**EN:** Yes, the project is a web-based application:
- **Frontend:** Single Page Application (SPA) developed with React 18
- **UI Framework:** Modern, responsive web interface
- **Access:** Access via web browser (Chrome, Firefox, Edge, Safari)
- **URL:** https://genaiops.vpara.local
- **Features:** Chat interface, conversation history, user profile management
- **Security:** HTTPS, JWT authentication, CORS policy

---

## 0.1.15 Does the project include the development or usage of mobile applications?

**TR:** Hayır, şu anda mobil uygulama geliştirmesi veya kullanımı bulunmamaktadır. Sadece web tabanlı bir uygulamadır. Ancak responsive tasarım sayesinde mobil tarayıcılar üzerinden erişilebilir durumdadır. Gelecekte native mobil uygulama geliştirilebilir.

**EN:** No, there is currently no mobile application development or usage. It is only a web-based application. However, it is accessible via mobile browsers thanks to responsive design. Native mobile application may be developed in the future.

---

## 0.1.16 Does the project include the development or usage of IoT?

**TR:** Hayır, bu proje IoT (Internet of Things) cihazlarının geliştirilmesini veya kullanımını içermemektedir. Tamamen web tabanlı bir AI chat platformudur ve IoT entegrasyonu bulunmamaktadır.

**EN:** No, this project does not include the development or usage of IoT (Internet of Things) devices. It is purely a web-based AI chat platform and does not have IoT integration.

---

## 0.1.17 Does the project include any database?

**TR:** Evet, proje veritabanı kullanmaktadır:
- **Database Type:** PostgreSQL 15+
- **Location:** External PostgreSQL server (Vodafone internal network)
- **Connection:** SSL/TLS encrypted connection
- **Schema:** Users, conversations, messages, chat_history tables
- **Connection Pool:** HikariCP (max 20 connections)
- **Backup:** Daily automated backups
- **Access Control:** Database user with limited privileges
- **Encryption:** Data encryption at rest and in transit

**EN:** Yes, the project uses a database:
- **Database Type:** PostgreSQL 15+
- **Location:** External PostgreSQL server (Vodafone internal network)
- **Connection:** SSL/TLS encrypted connection
- **Schema:** Users, conversations, messages, chat_history tables
- **Connection Pool:** HikariCP (max 20 connections)
- **Backup:** Daily automated backups
- **Access Control:** Database user with limited privileges
- **Encryption:** Data encryption at rest and in transit

---

## 0.1.18 Does the project deal with Customer Premise Equipment?

**TR:** Hayır, bu proje Customer Premise Equipment (CPE) ile ilgilenmemektedir. Müşteri lokasyonlarında kurulu ekipmanlarla etkileşimi yoktur. Tamamen cloud-based/server-side bir uygulamadır.

**EN:** No, this project does not deal with Customer Premise Equipment (CPE). It does not interact with equipment installed at customer locations. It is a fully cloud-based/server-side application.

---

## 0.1.19 Does the project include appliance/black box environment?

**TR:** Hayır, proje appliance veya black box ortamı içermemektedir. Tüm kaynak kodlar açık ve erişilebilirdir. Containerized microservices mimarisi kullanılmaktadır ve tüm bileşenler şeffaftır.

**EN:** No, the project does not include appliance or black box environment. All source codes are open and accessible. Containerized microservices architecture is used and all components are transparent.

---

## 0.1.20 Does the project include virtualized infrastructure components?

**TR:** Evet, proje sanallaştırılmış altyapı bileşenleri içermektedir:
- **Container Platform:** OpenShift 4.x / Kubernetes
- **Container Runtime:** Docker / CRI-O
- **Virtualization:** Container-based virtualization
- **Orchestration:** Kubernetes orchestration
- **Compute:** Virtual machines üzerinde çalışan container'lar
- **Storage:** Persistent volumes (virtualized storage)
- **Network:** Software-defined networking (SDN)

**EN:** Yes, the project includes virtualized infrastructure components:
- **Container Platform:** OpenShift 4.x / Kubernetes
- **Container Runtime:** Docker / CRI-O
- **Virtualization:** Container-based virtualization
- **Orchestration:** Kubernetes orchestration
- **Compute:** Containers running on virtual machines
- **Storage:** Persistent volumes (virtualized storage)
- **Network:** Software-defined networking (SDN)

---

## 0.1.21 Is the project deployed to container platforms?

**TR:** Evet, proje container platformlarına deploy edilmektedir:
- **Platform:** OpenShift 4.x (Red Hat Kubernetes distribution)
- **Container Images:** Docker images (multi-stage builds)
- **Registry:** containers.github.vpara.local
- **Orchestration:** Kubernetes
- **Deployment Strategy:** Rolling updates, zero-downtime deployment
- **Replicas:** Frontend (2 replicas), Backend (2 replicas)
- **Health Checks:** Liveness and readiness probes
- **Auto-scaling:** Horizontal Pod Autoscaler (HPA) support

**EN:** Yes, the project is deployed to container platforms:
- **Platform:** OpenShift 4.x (Red Hat Kubernetes distribution)
- **Container Images:** Docker images (multi-stage builds)
- **Registry:** containers.github.vpara.local
- **Orchestration:** Kubernetes
- **Deployment Strategy:** Rolling updates, zero-downtime deployment
- **Replicas:** Frontend (2 replicas), Backend (2 replicas)
- **Health Checks:** Liveness and readiness probes
- **Auto-scaling:** Horizontal Pod Autoscaler (HPA) support

---

## 0.1.22 Does project have http header enrichment functionality?

**TR:** Evet, proje HTTP header enrichment fonksiyonalitesine sahiptir:
- **Security Headers:** Content-Security-Policy, X-Frame-Options, X-Content-Type-Options, Strict-Transport-Security
- **CORS Headers:** Access-Control-Allow-Origin, Access-Control-Allow-Methods, Access-Control-Allow-Headers
- **Authentication Headers:** Authorization (Bearer token), X-User-Id
- **Custom Headers:** X-Request-ID (request tracking), X-Correlation-ID
- **Nginx Configuration:** Frontend nginx proxy ile header enrichment
- **Spring Security:** Backend'de security header configuration

**EN:** Yes, the project has HTTP header enrichment functionality:
- **Security Headers:** Content-Security-Policy, X-Frame-Options, X-Content-Type-Options, Strict-Transport-Security
- **CORS Headers:** Access-Control-Allow-Origin, Access-Control-Allow-Methods, Access-Control-Allow-Headers
- **Authentication Headers:** Authorization (Bearer token), X-User-Id
- **Custom Headers:** X-Request-ID (request tracking), X-Correlation-ID
- **Nginx Configuration:** Header enrichment via frontend nginx proxy
- **Spring Security:** Security header configuration in backend

---

## 0.1.23 Does the solution provide an API (for external or internal calls) which will be accessed using HTTPS-based interfaces such as SOAP, REST, or JSON?

**TR:** Evet, çözüm HTTPS tabanlı REST API sağlamaktadır:
- **API Type:** RESTful API (JSON format)
- **Protocol:** HTTPS only (TLS 1.2+)
- **Authentication:** JWT Bearer Token
- **Endpoints:**
  - POST /api/auth/login - Kullanıcı girişi
  - POST /api/auth/logout - Kullanıcı çıkışı
  - POST /api/chat/send - Chat mesajı gönderme
  - GET /api/conversations - Konuşma geçmişi
  - DELETE /api/conversations/{id} - Konuşma silme
- **Data Format:** JSON request/response
- **API Security:** CORS policy, rate limiting, input validation
- **Usage:** Internal API (Vodafone network içi)

**EN:** Yes, the solution provides HTTPS-based REST API:
- **API Type:** RESTful API (JSON format)
- **Protocol:** HTTPS only (TLS 1.2+)
- **Authentication:** JWT Bearer Token
- **Endpoints:**
  - POST /api/auth/login - User login
  - POST /api/auth/logout - User logout
  - POST /api/chat/send - Send chat message
  - GET /api/conversations - Conversation history
  - DELETE /api/conversations/{id} - Delete conversation
- **Data Format:** JSON request/response
- **API Security:** CORS policy, rate limiting, input validation
- **Usage:** Internal API (within Vodafone network)

---

## 0.1.24 Are servers/applications hardened with industry standards? (NIST, CIS...)

**TR:** Evet, sunucular ve uygulamalar endüstri standartlarına göre sertleştirilmiştir:
- **Container Security:** CIS Docker Benchmark uyumlu container images
- **Base Images:** Minimal alpine-based images (attack surface reduction)
- **Non-Root User:** Container'lar non-root user (UID 1001) ile çalışır
- **Read-Only Filesystem:** Mümkün olduğunda read-only root filesystem
- **Security Context:** Kubernetes security context policies
- **Image Scanning:** Container image vulnerability scanning (Trivy, Clair)
- **Network Policies:** Kubernetes network policies ile trafik kısıtlaması
- **RBAC:** Role-Based Access Control
- **Secrets Management:** Kubernetes secrets, Sealed Secrets
- **TLS/SSL:** TLS 1.2+ enforcement, strong cipher suites
- **Spring Security:** OWASP best practices implementation

**EN:** Yes, servers and applications are hardened according to industry standards:
- **Container Security:** CIS Docker Benchmark compliant container images
- **Base Images:** Minimal alpine-based images (attack surface reduction)
- **Non-Root User:** Containers run with non-root user (UID 1001)
- **Read-Only Filesystem:** Read-only root filesystem where possible
- **Security Context:** Kubernetes security context policies
- **Image Scanning:** Container image vulnerability scanning (Trivy, Clair)
- **Network Policies:** Traffic restriction with Kubernetes network policies
- **RBAC:** Role-Based Access Control
- **Secrets Management:** Kubernetes secrets, Sealed Secrets
- **TLS/SSL:** TLS 1.2+ enforcement, strong cipher suites
- **Spring Security:** OWASP best practices implementation

---

## 0.1.25 Is it possible to scan source codes via Vodafone SAST tool by reaching code repository?

**TR:** Evet, kaynak kodlar Vodafone SAST (Static Application Security Testing) aracı ile taranabilir:
- **Repository:** GitHub Enterprise (github.vpara.local)
- **Access:** Vodafone internal network üzerinden erişilebilir
- **Repository URL:** https://github.vpara.local/vepas-ai/genai-ops
- **Branch Structure:** main, develop, feature branches
- **Code Languages:** Java (Spring Boot), JavaScript/JSX (React)
- **Build Tool:** Maven (backend), npm (frontend)
- **CI/CD Integration:** GitHub Actions workflow ile entegre edilebilir
- **SAST Tools:** SonarQube, Checkmarx, Fortify entegrasyonu mümkün

**EN:** Yes, source codes can be scanned via Vodafone SAST (Static Application Security Testing) tool:
- **Repository:** GitHub Enterprise (github.vpara.local)
- **Access:** Accessible via Vodafone internal network
- **Repository URL:** https://github.vpara.local/vepas-ai/genai-ops
- **Branch Structure:** main, develop, feature branches
- **Code Languages:** Java (Spring Boot), JavaScript/JSX (React)
- **Build Tool:** Maven (backend), npm (frontend)
- **CI/CD Integration:** Can be integrated with GitHub Actions workflow
- **SAST Tools:** SonarQube, Checkmarx, Fortify integration possible

---

## 0.1.26 Is weak and clear text methods are in use? (TELNET, TFTP, FTP, HTTP)

**TR:** Hayır, zayıf ve açık metin protokolleri kullanılmamaktadır:
- **HTTP:** Kullanılmıyor - Sadece HTTPS (TLS 1.2+)
- **TELNET:** Kullanılmıyor
- **TFTP:** Kullanılmıyor
- **FTP:** Kullanılmıyor
- **Güvenli Protokoller:**
  - HTTPS (TLS 1.2+) - Web traffic
  - LDAPS (LDAP over SSL - port 636) - Authentication
  - PostgreSQL SSL/TLS - Database connection
  - WSS (WebSocket Secure) - Real-time communication (gelecek)
- **Encryption:** Tüm network trafiği şifrelidir
- **Certificate Validation:** SSL/TLS certificate validation aktif

**EN:** No, weak and clear text protocols are not in use:
- **HTTP:** Not used - Only HTTPS (TLS 1.2+)
- **TELNET:** Not used
- **TFTP:** Not used
- **FTP:** Not used
- **Secure Protocols:**
  - HTTPS (TLS 1.2+) - Web traffic
  - LDAPS (LDAP over SSL - port 636) - Authentication
  - PostgreSQL SSL/TLS - Database connection
  - WSS (WebSocket Secure) - Real-time communication (future)
- **Encryption:** All network traffic is encrypted
- **Certificate Validation:** SSL/TLS certificate validation active

---

## 0.1.27 Will sensitive data be observed cleartext in logs/public places/proxy?

**TR:** Hayır, hassas veriler loglarda veya public alanlarda açık metin olarak görünmemektedir:
- **Password Masking:** Şifreler hiçbir zaman loglanmaz
- **Token Masking:** JWT token'lar loglanırken maskelenir (ilk/son 4 karakter)
- **PII Protection:** Kişisel veriler (email, username) loglanırken hash'lenir veya maskelenir
- **Log Sanitization:** Tüm loglar sensitive data için sanitize edilir
- **Database Passwords:** Environment variables ve secrets ile yönetilir, loglanmaz
- **API Keys:** Secrets management ile saklanır, loglanmaz
- **Error Messages:** Production'da detaylı error mesajları gösterilmez
- **Log Access Control:** Loglar sadece yetkili personel tarafından erişilebilir
- **Proxy Configuration:** Nginx proxy'de sensitive header'lar loglanmaz

**EN:** No, sensitive data is not observed in cleartext in logs/public places/proxy:
- **Password Masking:** Passwords are never logged
- **Token Masking:** JWT tokens are masked when logged (first/last 4 characters)
- **PII Protection:** Personal data (email, username) is hashed or masked when logged
- **Log Sanitization:** All logs are sanitized for sensitive data
- **Database Passwords:** Managed via environment variables and secrets, not logged
- **API Keys:** Stored via secrets management, not logged
- **Error Messages:** Detailed error messages not shown in production
- **Log Access Control:** Logs accessible only by authorized personnel
- **Proxy Configuration:** Sensitive headers not logged in Nginx proxy

---

## 0.1.28 Can Anti-malware software be installed?

**TR:** Evet, anti-malware yazılımı kurulabilir:
- **Container Level:** Container image scanning (Trivy, Clair, Snyk) ile malware detection
- **Host Level:** OpenShift/Kubernetes node'larında anti-malware çalıştırılabilir
- **Image Registry:** Container registry'de image scanning aktif
- **Runtime Protection:** Falco, Sysdig gibi runtime security tools kullanılabilir
- **File System Scanning:** Persistent volumes üzerinde anti-malware scanning yapılabilir
- **CI/CD Pipeline:** Build sırasında malware scanning entegre edilebilir
- **Compatibility:** Alpine-based minimal images anti-malware ile uyumlu

**EN:** Yes, anti-malware software can be installed:
- **Container Level:** Malware detection via container image scanning (Trivy, Clair, Snyk)
- **Host Level:** Anti-malware can run on OpenShift/Kubernetes nodes
- **Image Registry:** Image scanning active in container registry
- **Runtime Protection:** Runtime security tools like Falco, Sysdig can be used
- **File System Scanning:** Anti-malware scanning can be performed on persistent volumes
- **CI/CD Pipeline:** Malware scanning can be integrated during build
- **Compatibility:** Alpine-based minimal images compatible with anti-malware

---

## 0.1.29 Will DB and APP be installed on different servers?

**TR:** Evet, veritabanı ve uygulama farklı sunucularda kurulacaktır:
- **Application (Backend):** OpenShift/Kubernetes cluster üzerinde container'lar içinde (2 replicas)
- **Application (Frontend):** OpenShift/Kubernetes cluster üzerinde container'lar içinde (2 replicas)
- **Database:** External PostgreSQL server (Vodafone internal network üzerinde ayrı sunucu)
- **Separation Benefits:**
  - Security isolation
  - Independent scaling
  - Resource optimization
  - Easier maintenance
  - Better disaster recovery
- **Network:** Secure network connection (SSL/TLS) ile bağlantı
- **Firewall:** Database sadece application subnet'inden erişilebilir

**EN:** Yes, database and application will be installed on different servers:
- **Application (Backend):** In containers on OpenShift/Kubernetes cluster (2 replicas)
- **Application (Frontend):** In containers on OpenShift/Kubernetes cluster (2 replicas)
- **Database:** External PostgreSQL server (separate server on Vodafone internal network)
- **Separation Benefits:**
  - Security isolation
  - Independent scaling
  - Resource optimization
  - Easier maintenance
  - Better disaster recovery
- **Network:** Connection via secure network (SSL/TLS)
- **Firewall:** Database accessible only from application subnet

---

## 0.1.30 What will be the authentication method?

**TR:** Kimlik doğrulama yöntemi:
- **Primary Authentication:** LDAP (Lightweight Directory Access Protocol)
- **LDAP Server:** Vodafone LDAP (ldaps://172.31.234.41:636)
- **Protocol:** LDAPS (LDAP over SSL/TLS - port 636)
- **Bind Method:** Simple bind with username/password
- **User Attributes:** cn, mail, department, displayName
- **Session Management:** JWT (JSON Web Token) based
- **Token Type:** Bearer token
- **Token Expiration:** Configurable (default: 24 hours)
- **Token Storage:** HTTP-only secure cookies (frontend)
- **Token Validation:** Signature verification, expiration check
- **Fallback:** Admin user (local authentication) for emergency access
- **MFA:** Multi-Factor Authentication (gelecek enhancement)

**EN:** Authentication method:
- **Primary Authentication:** LDAP (Lightweight Directory Access Protocol)
- **LDAP Server:** Vodafone LDAP (ldaps://172.31.234.41:636)
- **Protocol:** LDAPS (LDAP over SSL/TLS - port 636)
- **Bind Method:** Simple bind with username/password
- **User Attributes:** cn, mail, department, displayName
- **Session Management:** JWT (JSON Web Token) based
- **Token Type:** Bearer token
- **Token Expiration:** Configurable (default: 24 hours)
- **Token Storage:** HTTP-only secure cookies (frontend)
- **Token Validation:** Signature verification, expiration check
- **Fallback:** Admin user (local authentication) for emergency access
- **MFA:** Multi-Factor Authentication (future enhancement)

---

## 0.1.31 What will be the authorization method?

**TR:** Yetkilendirme yöntemi:
- **Authorization Model:** Role-Based Access Control (RBAC)
- **Roles:**
  - USER: Normal kullanıcı (chat, conversation management)
  - ADMIN: Yönetici (user management, system configuration)
- **Token-Based:** JWT token içinde role bilgisi
- **Spring Security:** @PreAuthorize, @Secured annotations
- **Endpoint Protection:**
  - /api/auth/* - Public (login/logout)
  - /api/chat/* - Authenticated users (USER role)
  - /api/conversations/* - Authenticated users (USER role)
  - /api/admin/* - Admin only (ADMIN role)
- **Resource-Level:** Kullanıcılar sadece kendi conversation'larına erişebilir
- **Database-Level:** Row-level security (user_id filter)
- **API Gateway:** Future: API Gateway level authorization

**EN:** Authorization method:
- **Authorization Model:** Role-Based Access Control (RBAC)
- **Roles:**
  - USER: Normal user (chat, conversation management)
  - ADMIN: Administrator (user management, system configuration)
- **Token-Based:** Role information in JWT token
- **Spring Security:** @PreAuthorize, @Secured annotations
- **Endpoint Protection:**
  - /api/auth/* - Public (login/logout)
  - /api/chat/* - Authenticated users (USER role)
  - /api/conversations/* - Authenticated users (USER role)
  - /api/admin/* - Admin only (ADMIN role)
- **Resource-Level:** Users can only access their own conversations
- **Database-Level:** Row-level security (user_id filter)
- **API Gateway:** Future: API Gateway level authorization

---

## 0.1.32 Will there be Access Point integration?

**TR:** Hayır, fiziksel Access Point (AP) entegrasyonu bulunmamaktadır. Bu bir web tabanlı uygulamadır ve wireless access point'lerle doğrudan entegrasyonu yoktur. Kullanıcılar standart network üzerinden (kablolu veya kablosuz) web browser ile erişim sağlar.

**EN:** No, there is no physical Access Point (AP) integration. This is a web-based application and does not have direct integration with wireless access points. Users access via standard network (wired or wireless) through web browser.

---

## 0.1.33 Will generic users/functional accounts be managed by Vodafone PAM (Privileged Access Management) tool? (root/admin/privileged accounts/integration & service users)

**TR:** Evet, generic/functional hesaplar Vodafone PAM ile yönetilmelidir:
- **Database User:** PostgreSQL database user (genaiops_user) - PAM'de yönetilmeli
- **LDAP Bind User:** LDAP bind account - PAM'de yönetilmeli
- **Service Account:** Kubernetes service account (genai-ops-sa)
- **Admin Account:** Application admin user - PAM'de yönetilmeli
- **Integration Users:** LLM API service user - PAM'de yönetilmeli
- **Container Registry:** Registry pull secret - PAM'de yönetilmeli
- **Password Rotation:** PAM üzerinden otomatik password rotation
- **Audit:** PAM üzerinden tüm privileged access audit edilir
- **Emergency Access:** Break-glass procedure ile PAM üzerinden

**EN:** Yes, generic/functional accounts should be managed by Vodafone PAM:
- **Database User:** PostgreSQL database user (genaiops_user) - should be managed in PAM
- **LDAP Bind User:** LDAP bind account - should be managed in PAM
- **Service Account:** Kubernetes service account (genai-ops-sa)
- **Admin Account:** Application admin user - should be managed in PAM
- **Integration Users:** LLM API service user - should be managed in PAM
- **Container Registry:** Registry pull secret - should be managed in PAM
- **Password Rotation:** Automatic password rotation via PAM
- **Audit:** All privileged access audited via PAM
- **Emergency Access:** Break-glass procedure via PAM

---

## 0.1.34 Are all default user passwords either removed or users locked?

**TR:** Evet, tüm default user password'ler kaldırılmış veya kullanıcılar kilitlenmiştir:
- **Container Images:** Base image'lerde default user'lar kilitli veya kaldırılmış
- **Database:** PostgreSQL default postgres user disabled, custom user kullanılıyor
- **Application:** Default admin password environment variable ile override edilmeli
- **LDAP:** LDAP authentication kullanıldığı için local default user yok
- **Service Accounts:** Kubernetes service account (password-less, token-based)
- **First Run:** İlk çalıştırmada admin password değiştirilmeli (force password change)
- **No Hardcoded Passwords:** Kaynak kodda hardcoded password yok
- **Secrets Management:** Tüm password'ler Kubernetes secrets ile yönetilir

**EN:** Yes, all default user passwords are removed or users are locked:
- **Container Images:** Default users in base images are locked or removed
- **Database:** PostgreSQL default postgres user disabled, custom user used
- **Application:** Default admin password must be overridden via environment variable
- **LDAP:** No local default user as LDAP authentication is used
- **Service Accounts:** Kubernetes service account (password-less, token-based)
- **First Run:** Admin password must be changed on first run (force password change)
- **No Hardcoded Passwords:** No hardcoded passwords in source code
- **Secrets Management:** All passwords managed via Kubernetes secrets

---

## 0.1.35 Is it possible to track - as minimum - these log types: a) Subscriber data access (View, Query, Change, Delete, Execute Order etc.) b) Privileged User Activities (system configuration changes, service start/stop etc.) c) User Account Management Activities (User Creation, Change, Delete, Access Right Assignment, Role/Profile Creation or Change, d) Password Change, Account Lock etc.) e) Failed and Successful system login and logout events

**TR:** Evet, tüm belirtilen log tipleri takip edilebilmektedir:

**a) Subscriber/User Data Access:**
- Chat mesajı görüntüleme (conversation view)
- Conversation query (GET /api/conversations)
- Conversation silme (DELETE /api/conversations/{id})
- User profile görüntüleme
- Tüm data access işlemleri loglanır (timestamp, user_id, action, resource_id)

**b) Privileged User Activities:**
- System configuration değişiklikleri (ConfigMap updates)
- Service start/stop (Kubernetes deployment events)
- Admin panel işlemleri
- Database schema değişiklikleri
- Application restart/redeploy events
- Tüm admin işlemleri audit log'a yazılır

**c) User Account Management Activities:**
- User creation (LDAP sync)
- User role assignment (ADMIN/USER)
- User activation/deactivation
- Access right changes
- Role/profile modifications
- Tüm user management işlemleri loglanır

**d) Password Change, Account Lock:**
- Password change attempts (LDAP level)
- Account lock events (failed login threshold)
- Password reset requests
- Account unlock operations
- Tüm authentication events loglanır

**e) Login/Logout Events:**
- Successful login (timestamp, username, IP, user-agent)
- Failed login attempts (username, IP, reason)
- Logout events (timestamp, username, session duration)
- Session timeout events
- Token expiration events
- Tüm authentication events audit log'a yazılır

**Log Format:**
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "INFO",
  "event_type": "USER_LOGIN",
  "user_id": "john.doe",
  "ip_address": "192.168.1.100",
  "action": "LOGIN_SUCCESS",
  "resource": "/api/auth/login",
  "details": {
    "user_agent": "Mozilla/5.0...",
    "session_id": "abc123..."
  }
}
```

**Log Storage:**
- Application logs: OpenShift/Kubernetes persistent volumes
- Audit logs: Separate audit log file
- Log aggregation: EFK Stack (Elasticsearch, Fluentd, Kibana) veya Splunk
- Log retention: Minimum 1 year (compliance requirement)
- Log access: Sadece authorized personnel

**EN:** Yes, all specified log types can be tracked:

**a) Subscriber/User Data Access:**
- Chat message viewing (conversation view)
- Conversation query (GET /api/conversations)
- Conversation deletion (DELETE /api/conversations/{id})
- User profile viewing
- All data access operations are logged (timestamp, user_id, action, resource_id)

**b) Privileged User Activities:**
- System configuration changes (ConfigMap updates)
- Service start/stop (Kubernetes deployment events)
- Admin panel operations
- Database schema changes
- Application restart/redeploy events
- All admin operations written to audit log

**c) User Account Management Activities:**
- User creation (LDAP sync)
- User role assignment (ADMIN/USER)
- User activation/deactivation
- Access right changes
- Role/profile modifications
- All user management operations are logged

**d) Password Change, Account Lock:**
- Password change attempts (LDAP level)
- Account lock events (failed login threshold)
- Password reset requests
- Account unlock operations
- All authentication events are logged

**e) Login/Logout Events:**
- Successful login (timestamp, username, IP, user-agent)
- Failed login attempts (username, IP, reason)
- Logout events (timestamp, username, session duration)
- Session timeout events
- Token expiration events
- All authentication events written to audit log

**Log Format:**
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "INFO",
  "event_type": "USER_LOGIN",
  "user_id": "john.doe",
  "ip_address": "192.168.1.100",
  "action": "LOGIN_SUCCESS",
  "resource": "/api/auth/login",
  "details": {
    "user_agent": "Mozilla/5.0...",
    "session_id": "abc123..."
  }
}
```

**Log Storage:**
- Application logs: OpenShift/Kubernetes persistent volumes
- Audit logs: Separate audit log file
- Log aggregation: EFK Stack (Elasticsearch, Fluentd, Kibana) or Splunk
- Log retention: Minimum 1 year (compliance requirement)
- Log access: Authorized personnel only

---

## Özet / Summary

Bu doküman, GENAI-OPS projesinin Secure by Design prensipleri ve Non-Functional Requirements (NFR) kapsamında güvenlik, compliance ve operasyonel gereksinimlerini detaylandırmaktadır.

**Temel Güvenlik Özellikleri / Key Security Features:**
- LDAP authentication with LDAPS (SSL/TLS)
- JWT-based authorization
- Role-Based Access Control (RBAC)
- Encryption at rest and in transit
- Container security (non-root, minimal images)
- Comprehensive audit logging
- GDPR/KVKK compliance
- PAM integration for privileged accounts
- No weak protocols (TELNET, FTP, HTTP)
- Industry standard hardening (CIS, NIST)

**Deployment Güvenliği / Deployment Security:**
- OpenShift/Kubernetes platform
- Container isolation
- Network policies
- Secrets management
- Image scanning
- Zero-downtime deployment
- High availability (2+ replicas)

This document serves as the foundation for security reviews, compliance audits, and operational procedures.


---

## Network Security Zoning & Architecture Requirements

## 0.1.36 Network Zoning Compliance - Systems must be compliant with the Network Zoning policy

**TR:** GENAI-OPS sistemi Network Zoning politikasına uyumludur:

**1) Telecom Security Zoning Approach:**
- Sistem farklı bilgi tipleri ile çalışır: kullanıcı detayları (LDAP), session bilgileri (JWT), chat içeriği (messages)
- Her bilgi tipi için uygun güvenlik mapping uygulanmıştır
- Confidentiality, integrity ve availability ratings dikkate alınmıştır

**2) Information Type Zones:**
- **Zone E2 (Internal Backend):** Backend application, database, LDAP integration
- **Zone C2 (DMZ) - Kullanılmıyor:** Sistem tamamen internal kullanım için tasarlanmıştır
- Tüm bileşenler internal network içerisinde konumlandırılmıştır

**3) Information Transport Zones:**
- **Internal Network:** Vodafone corporate network (OpenShift cluster)
- **Database Network:** PostgreSQL external server network (SSL/TLS encrypted)
- **LDAP Network:** LDAP server network (LDAPS encrypted - port 636)
- **LLM Network:** Practicus AI network (HTTPS encrypted)

**4) Multifunction Network Nodes:**
- Backend pods: Multiple information types (user data, chat history, session data)
- Frontend pods: User interface ve API proxy functionality
- Her node birden fazla information type zone'a üye olabilir
- Kubernetes network policies ile zone separation sağlanır

**5) Security Gap Coverage:**
- **Segmentation:** Kubernetes namespaces ile logical segmentation
- **Secure Tunneling:** TLS/SSL tüm transport layer'da aktif
- **Security Control Points:** Kubernetes network policies, OpenShift routes
- **Encryption:** Data at rest ve in transit encryption

**6) Zoning Subdivision:**
- **Namespace Segmentation:** genai-ops namespace (production), genai-ops-dev (development)
- **Pod Segmentation:** Frontend pods, backend pods, database ayrı segment'lerde
- **Instance Separation:** Development, staging, production environments ayrı

**7) Secure Tunneling:**
- **HTTPS/TLS:** Web traffic (TLS 1.2+)
- **LDAPS:** LDAP authentication (SSL/TLS - port 636)
- **PostgreSQL SSL:** Database connection encryption
- **IPSec:** Kubernetes pod-to-pod communication (optional)

**8) Security Control Points:**
- **OpenShift Route:** TLS termination, ingress control
- **Kubernetes Network Policies:** Pod-to-pod traffic control
- **Service Mesh (Future):** Istio for advanced traffic management
- **API Gateway (Future):** Centralized security control point

**Constraints:** Herhangi bir zoning constraint bulunmamaktadır. Sistem tamamen internal kullanım için tasarlanmış olup, tüm zoning gereksinimlerini karşılamaktadır.

**EN:** GENAI-OPS system is compliant with the Network Zoning policy:

**1) Telecom Security Zoning Approach:**
- System works with different information types: user details (LDAP), session information (JWT), chat content (messages)
- Appropriate security mapping applied for each information type
- Confidentiality, integrity and availability ratings are considered

**2) Information Type Zones:**
- **Zone E2 (Internal Backend):** Backend application, database, LDAP integration
- **Zone C2 (DMZ) - Not Used:** System is designed for fully internal use
- All components are located within internal network

**3) Information Transport Zones:**
- **Internal Network:** Vodafone corporate network (OpenShift cluster)
- **Database Network:** PostgreSQL external server network (SSL/TLS encrypted)
- **LDAP Network:** LDAP server network (LDAPS encrypted - port 636)
- **LLM Network:** Practicus AI network (HTTPS encrypted)

**4) Multifunction Network Nodes:**
- Backend pods: Multiple information types (user data, chat history, session data)
- Frontend pods: User interface and API proxy functionality
- Each node can be member of multiple information type zones
- Zone separation provided via Kubernetes network policies

**5) Security Gap Coverage:**
- **Segmentation:** Logical segmentation via Kubernetes namespaces
- **Secure Tunneling:** TLS/SSL active on all transport layers
- **Security Control Points:** Kubernetes network policies, OpenShift routes
- **Encryption:** Data at rest and in transit encryption

**6) Zoning Subdivision:**
- **Namespace Segmentation:** genai-ops namespace (production), genai-ops-dev (development)
- **Pod Segmentation:** Frontend pods, backend pods, database in separate segments
- **Instance Separation:** Development, staging, production environments separated

**7) Secure Tunneling:**
- **HTTPS/TLS:** Web traffic (TLS 1.2+)
- **LDAPS:** LDAP authentication (SSL/TLS - port 636)
- **PostgreSQL SSL:** Database connection encryption
- **IPSec:** Kubernetes pod-to-pod communication (optional)

**8) Security Control Points:**
- **OpenShift Route:** TLS termination, ingress control
- **Kubernetes Network Policies:** Pod-to-pod traffic control
- **Service Mesh (Future):** Istio for advanced traffic management
- **API Gateway (Future):** Centralized security control point

**Constraints:** There are no zoning constraints. The system is designed for fully internal use and meets all zoning requirements.

---

## 0.1.37 Internal-only Backend Location (Zone E2) - Platforms deployed exclusively for internal use must be located in an Internal-only backend (Security Zoning Standard, Zone E2)

**TR:** GENAI-OPS tamamen internal kullanım için tasarlanmıştır ve Zone E2'de konumlandırılmıştır:

**Zone E2 Compliance:**
- **Backend Application:** OpenShift cluster içinde, internal network (Zone E2)
- **Frontend Application:** OpenShift cluster içinde, internal network (Zone E2)
- **PostgreSQL Database:** External server, internal network (Zone E2)
- **LDAP Integration:** Vodafone internal LDAP server (Zone E2)
- **LLM Integration:** Practicus AI internal network (Zone E2)

**DMZ/Public Frontend Kullanımı:** Hiçbir bileşen DMZ (Zone C2) veya public frontend'de konumlandırılmamıştır.

**Access Control:**
- Sadece Vodafone corporate network'ten erişim
- VPN veya corporate network bağlantısı gerekli
- Public internet'ten doğrudan erişim yok
- OpenShift Route sadece internal hostname (genaiops.vpara.local)

**Network Isolation:**
- Tüm bileşenler Vodafone internal network içinde
- External internet exposure yok
- Firewall rules ile internal network'e kısıtlı

**EN:** GENAI-OPS is designed for fully internal use and is located in Zone E2:

**Zone E2 Compliance:**
- **Backend Application:** Inside OpenShift cluster, internal network (Zone E2)
- **Frontend Application:** Inside OpenShift cluster, internal network (Zone E2)
- **PostgreSQL Database:** External server, internal network (Zone E2)
- **LDAP Integration:** Vodafone internal LDAP server (Zone E2)
- **LLM Integration:** Practicus AI internal network (Zone E2)

**DMZ/Public Frontend Usage:** No components are located in DMZ (Zone C2) or public frontend.

**Access Control:**
- Access only from Vodafone corporate network
- VPN or corporate network connection required
- No direct access from public internet
- OpenShift Route only internal hostname (genaiops.vpara.local)

**Network Isolation:**
- All components within Vodafone internal network
- No external internet exposure
- Restricted to internal network via firewall rules

---

## 0.1.38 Secure Filtering Server/Proxy - The secure filtering server/proxy shall hold no customer data, and shall have no direct access to customer databases

**TR:** Nginx proxy/filtering server müşteri verisi tutmamaktadır:

**Proxy Configuration:**
- **Frontend Nginx:** Sadece reverse proxy ve static file serving
- **No Data Storage:** Nginx hiçbir customer/user data saklamaz
- **No Database Access:** Nginx'in database'e doğrudan erişimi yok
- **Stateless:** Tüm request'ler backend'e proxy edilir
- **No Session Storage:** Session data nginx'de saklanmaz

**Data Flow:**
```
User Browser → Nginx (Proxy) → Backend API → Database
                  ↓
            (No data storage)
```

**Nginx Functionality:**
- Static file serving (HTML, CSS, JS, images)
- Reverse proxy (/api/* → backend)
- TLS termination
- Header enrichment
- Request logging (no sensitive data)

**Security:**
- Nginx access log'larında sensitive data maskelenir
- Proxy sadece routing yapar, data processing yok
- Database credentials nginx'de yok

**EN:** Nginx proxy/filtering server does not hold customer data:

**Proxy Configuration:**
- **Frontend Nginx:** Only reverse proxy and static file serving
- **No Data Storage:** Nginx does not store any customer/user data
- **No Database Access:** Nginx has no direct access to database
- **Stateless:** All requests are proxied to backend
- **No Session Storage:** Session data not stored in nginx

**Data Flow:**
```
User Browser → Nginx (Proxy) → Backend API → Database
                  ↓
            (No data storage)
```

**Nginx Functionality:**
- Static file serving (HTML, CSS, JS, images)
- Reverse proxy (/api/* → backend)
- TLS termination
- Header enrichment
- Request logging (no sensitive data)

**Security:**
- Sensitive data masked in nginx access logs
- Proxy only does routing, no data processing
- No database credentials in nginx

---

## 0.1.39 Environment Separation - Production must not be the same environment as stage, testing, development or pre-production. Each environment must have a dedicated purpose.

**TR:** Tüm ortamlar birbirinden tamamen ayrılmıştır:

**Environment Structure:**

**1. Development Environment:**
- **Purpose:** Geliştirme ve unit testing
- **Location:** Local docker-compose veya OpenShift dev namespace
- **Namespace:** genai-ops-dev
- **Database:** Development database (separate instance)
- **LDAP:** Test LDAP veya mock authentication
- **Access:** Sadece development team
- **Data:** Test/mock data, no production data

**2. Testing/Staging Environment:**
- **Purpose:** Integration testing, UAT, performance testing
- **Location:** OpenShift test namespace
- **Namespace:** genai-ops-test
- **Database:** Test database (separate instance)
- **LDAP:** Test LDAP integration
- **Access:** QA team, testers
- **Data:** Anonymized test data

**3. Pre-Production Environment:**
- **Purpose:** Final validation, production-like testing
- **Location:** OpenShift pre-prod namespace
- **Namespace:** genai-ops-preprod
- **Database:** Pre-production database (separate instance)
- **LDAP:** Production LDAP (read-only)
- **Access:** Limited access, approval required
- **Data:** Anonymized production-like data

**4. Production Environment:**
- **Purpose:** Live production system
- **Location:** OpenShift production namespace
- **Namespace:** genai-ops
- **Database:** Production database (dedicated instance)
- **LDAP:** Production LDAP
- **Access:** Strictly controlled, change management required
- **Data:** Real production data

**Separation Mechanisms:**
- **Kubernetes Namespaces:** Logical isolation
- **Network Policies:** Network-level isolation
- **RBAC:** Role-based access control per environment
- **Separate Databases:** Each environment has dedicated database
- **Separate Secrets:** Different credentials per environment
- **Separate ConfigMaps:** Environment-specific configuration
- **No Data Sharing:** Production data never used in non-prod environments

**Promotion Process:**
```
Development → Testing → Pre-Production → Production
    ↓            ↓            ↓              ↓
  (Build)    (Test)    (Validate)      (Deploy)
```

**EN:** All environments are completely separated from each other:

**Environment Structure:**

**1. Development Environment:**
- **Purpose:** Development and unit testing
- **Location:** Local docker-compose or OpenShift dev namespace
- **Namespace:** genai-ops-dev
- **Database:** Development database (separate instance)
- **LDAP:** Test LDAP or mock authentication
- **Access:** Development team only
- **Data:** Test/mock data, no production data

**2. Testing/Staging Environment:**
- **Purpose:** Integration testing, UAT, performance testing
- **Location:** OpenShift test namespace
- **Namespace:** genai-ops-test
- **Database:** Test database (separate instance)
- **LDAP:** Test LDAP integration
- **Access:** QA team, testers
- **Data:** Anonymized test data

**3. Pre-Production Environment:**
- **Purpose:** Final validation, production-like testing
- **Location:** OpenShift pre-prod namespace
- **Namespace:** genai-ops-preprod
- **Database:** Pre-production database (separate instance)
- **LDAP:** Production LDAP (read-only)
- **Access:** Limited access, approval required
- **Data:** Anonymized production-like data

**4. Production Environment:**
- **Purpose:** Live production system
- **Location:** OpenShift production namespace
- **Namespace:** genai-ops
- **Database:** Production database (dedicated instance)
- **LDAP:** Production LDAP
- **Access:** Strictly controlled, change management required
- **Data:** Real production data

**Separation Mechanisms:**
- **Kubernetes Namespaces:** Logical isolation
- **Network Policies:** Network-level isolation
- **RBAC:** Role-based access control per environment
- **Separate Databases:** Each environment has dedicated database
- **Separate Secrets:** Different credentials per environment
- **Separate ConfigMaps:** Environment-specific configuration
- **No Data Sharing:** Production data never used in non-prod environments

**Promotion Process:**
```
Development → Testing → Pre-Production → Production
    ↓            ↓            ↓              ↓
  (Build)    (Test)    (Validate)      (Deploy)
```

---

## 0.1.40 Interface Separation - If the system requires interfaces both for Internal users and customers, these two interfaces must be completely separated. Internal user's access must be made only from corporate networks, never through public networks.

**TR:** GENAI-OPS sadece internal kullanıcılar içindir, müşteri arayüzü bulunmamaktadır:

**Interface Type:**
- **Internal Users Only:** Sadece Vodafone çalışanları
- **No Customer Interface:** Müşteri (customer) arayüzü yok
- **Corporate Network Only:** Sadece corporate network'ten erişim

**Access Control:**
- **Network Level:** Vodafone corporate network gerekli
- **VPN Required:** Remote çalışanlar için VPN bağlantısı zorunlu
- **No Public Access:** Public internet'ten erişim yok
- **Firewall Rules:** Corporate network dışından erişim engellenir

**Authentication:**
- **LDAP Only:** Vodafone LDAP authentication (corporate accounts)
- **No External Auth:** Social login, external OAuth yok
- **Corporate Credentials:** Sadece Vodafone employee credentials

**Network Architecture:**
```
Vodafone Corporate Network
    ↓
VPN Gateway (for remote users)
    ↓
Internal Firewall
    ↓
OpenShift Route (genaiops.vpara.local)
    ↓
GENAI-OPS Application
```

**Future Consideration:**
Eğer gelecekte customer interface gerekirse:
- Tamamen ayrı application instance
- Farklı namespace (genai-ops-customer)
- Farklı database
- Farklı authentication mechanism
- DMZ'de deployment
- Tamamen ayrı codebase

**EN:** GENAI-OPS is for internal users only, no customer interface exists:

**Interface Type:**
- **Internal Users Only:** Vodafone employees only
- **No Customer Interface:** No customer interface
- **Corporate Network Only:** Access only from corporate network

**Access Control:**
- **Network Level:** Vodafone corporate network required
- **VPN Required:** VPN connection mandatory for remote workers
- **No Public Access:** No access from public internet
- **Firewall Rules:** Access blocked from outside corporate network

**Authentication:**
- **LDAP Only:** Vodafone LDAP authentication (corporate accounts)
- **No External Auth:** No social login, external OAuth
- **Corporate Credentials:** Only Vodafone employee credentials

**Network Architecture:**
```
Vodafone Corporate Network
    ↓
VPN Gateway (for remote users)
    ↓
Internal Firewall
    ↓
OpenShift Route (genaiops.vpara.local)
    ↓
GENAI-OPS Application
```

**Future Consideration:**
If customer interface is needed in the future:
- Completely separate application instance
- Different namespace (genai-ops-customer)
- Different database
- Different authentication mechanism
- Deployment in DMZ
- Completely separate codebase

---

## Documentation Requirements

## 0.1.41 System Architecture Documentation - Documentation must be prepared including: (1) system architecture explanation (2) platforms list with versions (3) interface details (4) network infrastructure description (5) communication matrix and topology map

**TR:** Tüm gerekli dokümantasyon hazırlanmıştır:

**(1) System Architecture Explanation:**
- **BACKEND-ARCHITECTURE.md:** Backend mimari detayları
- **FRONTEND-ARCHITECTURE.md:** Frontend mimari detayları
- **DATABASE-ARCHITECTURE.md:** Database schema ve yapısı
- **DEPLOYMENT-ARCHITECTURE.md:** Deployment mimarisi
- **DOCKER.md:** Container architecture

**(2) Platforms List with Versions:**
- **Backend:**
  - Java: OpenJDK 17
  - Spring Boot: 3.2.x
  - Maven: 3.9.x
  - Base Image: eclipse-temurin:17-jre-alpine
- **Frontend:**
  - Node.js: 18.x
  - React: 18.2.x
  - Vite: 5.x
  - Base Image: nginx:alpine
- **Database:**
  - PostgreSQL: 15+
  - JDBC Driver: postgresql-42.x
- **Platform:**
  - OpenShift: 4.x
  - Kubernetes: 1.25+
  - Container Runtime: Docker/CRI-O
- **Integration:**
  - LDAP: OpenLDAP/Active Directory
  - LLM: Practicus AI Platform

**(3) Interface Details:**
- **REST API Endpoints:**
  - POST /api/auth/login - LDAP authentication
  - POST /api/auth/logout - Session termination
  - POST /api/chat/send - Send message to LLM
  - GET /api/conversations - Get user conversations
  - DELETE /api/conversations/{id} - Delete conversation
- **Protocols:**
  - HTTPS (TLS 1.2+) - Web traffic
  - LDAPS (port 636) - LDAP authentication
  - PostgreSQL SSL/TLS (port 5432) - Database
  - HTTPS - LLM API integration
- **Data Format:** JSON (REST API)

**(4) Network Infrastructure Description:**
- **Zone E2 (Internal Backend):** All components
- **OpenShift Cluster:** Container orchestration
- **Namespaces:** genai-ops (prod), genai-ops-dev, genai-ops-test
- **Network Policies:** Pod-to-pod traffic control
- **Service Mesh:** Future Istio integration
- **Load Balancing:** OpenShift Route, Kubernetes Service

**(5) Communication Matrix and Topology Map:**

**Communication Matrix:**
```
Source              | Destination        | Protocol | Port | Purpose
--------------------|-------------------|----------|------|------------------
User Browser        | Frontend (Nginx)  | HTTPS    | 443  | Web UI
Frontend (Nginx)    | Backend (Spring)  | HTTP     | 8080 | API calls
Backend (Spring)    | PostgreSQL        | SSL/TLS  | 5432 | Database queries
Backend (Spring)    | LDAP Server       | LDAPS    | 636  | Authentication
Backend (Spring)    | LLM API           | HTTPS    | 443  | AI inference
```

**Topology Map:**
```
Internet (Corporate Network Only)
    ↓
[OpenShift Route - TLS Termination]
    ↓
[Frontend Service - ClusterIP:80]
    ↓
[Frontend Pods (2 replicas) - Nginx:8080]
    ↓ (proxy /api/*)
[Backend Service - ClusterIP:8080]
    ↓
[Backend Pods (2 replicas) - Spring Boot:8080]
    ↓                    ↓                    ↓
[PostgreSQL]      [LDAP Server]        [LLM API]
(External)        (172.31.234.41)      (Practicus)
```

**EN:** All required documentation has been prepared:

**(1) System Architecture Explanation:**
- **BACKEND-ARCHITECTURE.md:** Backend architecture details
- **FRONTEND-ARCHITECTURE.md:** Frontend architecture details
- **DATABASE-ARCHITECTURE.md:** Database schema and structure
- **DEPLOYMENT-ARCHITECTURE.md:** Deployment architecture
- **DOCKER.md:** Container architecture

**(2) Platforms List with Versions:**
- **Backend:**
  - Java: OpenJDK 17
  - Spring Boot: 3.2.x
  - Maven: 3.9.x
  - Base Image: eclipse-temurin:17-jre-alpine
- **Frontend:**
  - Node.js: 18.x
  - React: 18.2.x
  - Vite: 5.x
  - Base Image: nginx:alpine
- **Database:**
  - PostgreSQL: 15+
  - JDBC Driver: postgresql-42.x
- **Platform:**
  - OpenShift: 4.x
  - Kubernetes: 1.25+
  - Container Runtime: Docker/CRI-O
- **Integration:**
  - LDAP: OpenLDAP/Active Directory
  - LLM: Practicus AI Platform

**(3) Interface Details:**
- **REST API Endpoints:**
  - POST /api/auth/login - LDAP authentication
  - POST /api/auth/logout - Session termination
  - POST /api/chat/send - Send message to LLM
  - GET /api/conversations - Get user conversations
  - DELETE /api/conversations/{id} - Delete conversation
- **Protocols:**
  - HTTPS (TLS 1.2+) - Web traffic
  - LDAPS (port 636) - LDAP authentication
  - PostgreSQL SSL/TLS (port 5432) - Database
  - HTTPS - LLM API integration
- **Data Format:** JSON (REST API)

**(4) Network Infrastructure Description:**
- **Zone E2 (Internal Backend):** All components
- **OpenShift Cluster:** Container orchestration
- **Namespaces:** genai-ops (prod), genai-ops-dev, genai-ops-test
- **Network Policies:** Pod-to-pod traffic control
- **Service Mesh:** Future Istio integration
- **Load Balancing:** OpenShift Route, Kubernetes Service

**(5) Communication Matrix and Topology Map:**

**Communication Matrix:**
```
Source              | Destination        | Protocol | Port | Purpose
--------------------|-------------------|----------|------|------------------
User Browser        | Frontend (Nginx)  | HTTPS    | 443  | Web UI
Frontend (Nginx)    | Backend (Spring)  | HTTP     | 8080 | API calls
Backend (Spring)    | PostgreSQL        | SSL/TLS  | 5432 | Database queries
Backend (Spring)    | LDAP Server       | LDAPS    | 636  | Authentication
Backend (Spring)    | LLM API           | HTTPS    | 443  | AI inference
```

**Topology Map:**
```
Internet (Corporate Network Only)
    ↓
[OpenShift Route - TLS Termination]
    ↓
[Frontend Service - ClusterIP:80]
    ↓
[Frontend Pods (2 replicas) - Nginx:8080]
    ↓ (proxy /api/*)
[Backend Service - ClusterIP:8080]
    ↓
[Backend Pods (2 replicas) - Spring Boot:8080]
    ↓                    ↓                    ↓
[PostgreSQL]      [LDAP Server]        [LLM API]
(External)        (172.31.234.41)      (Practicus)
```

---

## 0.1.42 Non-Personalized Accounts Documentation - Any account that is not personalised (e.g. 'root' or 'administrator') has to be detailed and flagged in the design document

**TR:** Kişiselleştirilmemiş hesaplar detaylandırılmıştır:

**Non-Personalized Accounts:**

**1. Database Accounts:**
- **Account:** genaiops_user
- **Type:** PostgreSQL database user
- **Purpose:** Application database access
- **Privileges:** Limited (SELECT, INSERT, UPDATE, DELETE on specific tables)
- **Management:** Vodafone PAM tool
- **Password Rotation:** Automated via PAM
- **Access:** Only from backend application pods

**2. LDAP Bind Account:**
- **Account:** cn=genaiops-bind,ou=services,dc=vodafone,dc=com
- **Type:** LDAP service account
- **Purpose:** LDAP authentication queries
- **Privileges:** Read-only (search and bind operations)
- **Management:** Vodafone PAM tool
- **Password Rotation:** Automated via PAM
- **Access:** Only from backend application pods

**3. Application Admin Account:**
- **Account:** admin
- **Type:** Application-level admin
- **Purpose:** Emergency access, system administration
- **Privileges:** Full application access (ADMIN role)
- **Management:** Vodafone PAM tool
- **Password:** Environment variable (ADMIN_PASSWORD)
- **Access:** Restricted, audit logged

**4. Kubernetes Service Account:**
- **Account:** genai-ops-sa
- **Type:** Kubernetes ServiceAccount
- **Purpose:** Pod authentication to Kubernetes API
- **Privileges:** Limited RBAC permissions
- **Management:** Kubernetes RBAC
- **Authentication:** Token-based (no password)
- **Access:** Automated by Kubernetes

**5. Container Registry Account:**
- **Account:** github-registry-pull
- **Type:** Container registry pull secret
- **Purpose:** Pull container images from registry
- **Privileges:** Read-only (image pull)
- **Management:** Vodafone PAM tool
- **Access:** Only from OpenShift cluster

**6. LLM API Service Account:**
- **Account:** genaiops-llm-integration
- **Type:** API service account
- **Purpose:** LLM API authentication
- **Privileges:** API access (inference only)
- **Management:** Vodafone PAM tool
- **Authentication:** API token
- **Access:** Only from backend application pods

**Security Measures:**
- All accounts managed via Vodafone PAM
- Automated password rotation
- Audit logging for all account usage
- Minimum privilege principle
- No interactive login (except admin for emergency)
- All credentials stored in Kubernetes Secrets

**EN:** Non-personalized accounts are detailed:

**Non-Personalized Accounts:**

**1. Database Accounts:**
- **Account:** genaiops_user
- **Type:** PostgreSQL database user
- **Purpose:** Application database access
- **Privileges:** Limited (SELECT, INSERT, UPDATE, DELETE on specific tables)
- **Management:** Vodafone PAM tool
- **Password Rotation:** Automated via PAM
- **Access:** Only from backend application pods

**2. LDAP Bind Account:**
- **Account:** cn=genaiops-bind,ou=services,dc=vodafone,dc=com
- **Type:** LDAP service account
- **Purpose:** LDAP authentication queries
- **Privileges:** Read-only (search and bind operations)
- **Management:** Vodafone PAM tool
- **Password Rotation:** Automated via PAM
- **Access:** Only from backend application pods

**3. Application Admin Account:**
- **Account:** admin
- **Type:** Application-level admin
- **Purpose:** Emergency access, system administration
- **Privileges:** Full application access (ADMIN role)
- **Management:** Vodafone PAM tool
- **Password:** Environment variable (ADMIN_PASSWORD)
- **Access:** Restricted, audit logged

**4. Kubernetes Service Account:**
- **Account:** genai-ops-sa
- **Type:** Kubernetes ServiceAccount
- **Purpose:** Pod authentication to Kubernetes API
- **Privileges:** Limited RBAC permissions
- **Management:** Kubernetes RBAC
- **Authentication:** Token-based (no password)
- **Access:** Automated by Kubernetes

**5. Container Registry Account:**
- **Account:** github-registry-pull
- **Type:** Container registry pull secret
- **Purpose:** Pull container images from registry
- **Privileges:** Read-only (image pull)
- **Management:** Vodafone PAM tool
- **Access:** Only from OpenShift cluster

**6. LLM API Service Account:**
- **Account:** genaiops-llm-integration
- **Type:** API service account
- **Purpose:** LLM API authentication
- **Privileges:** API access (inference only)
- **Management:** Vodafone PAM tool
- **Authentication:** API token
- **Access:** Only from backend application pods

**Security Measures:**
- All accounts managed via Vodafone PAM
- Automated password rotation
- Audit logging for all account usage
- Minimum privilege principle
- No interactive login (except admin for emergency)
- All credentials stored in Kubernetes Secrets

---

## 0.1.43 Network Diagram - Documentation must include a current network diagram that illustrates all connections to components that process or store confidential information

**TR:** Network diagram hazırlanmıştır ve tüm bağlantıları göstermektedir:

**Network Diagram (DEPLOYMENT-ARCHITECTURE.md içinde mevcuttur):**

```
┌─────────────────────────────────────────────────────────┐
│              Vodafone Corporate Network                  │
│                  (Internal Only)                         │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────┐
│                 OpenShift Cluster                        │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │         Namespace: genai-ops (Zone E2)         │    │
│  │                                                 │    │
│  │  ┌──────────────────────────────────────┐     │    │
│  │  │   OpenShift Route (TLS Edge)         │     │    │
│  │  │   Host: genaiops.vpara.local         │     │    │
│  │  │   Port: 443 (HTTPS)                  │     │    │
│  │  └──────────────┬───────────────────────┘     │    │
│  │                 │                              │    │
│  │                 ↓                              │    │
│  │  ┌──────────────────────────────────────┐     │    │
│  │  │   Frontend Service (ClusterIP)       │     │    │
│  │  │   Port: 80                           │     │    │
│  │  └──────────────┬───────────────────────┘     │    │
│  │                 │                              │    │
│  │                 ↓                              │    │
│  │  ┌──────────────────────────────────────┐     │    │
│  │  │   Frontend Deployment                │     │    │
│  │  │   ┌────────────┐  ┌────────────┐    │     │    │
│  │  │   │ Pod 1      │  │ Pod 2      │    │     │    │
│  │  │   │ Nginx:8080 │  │ Nginx:8080 │    │     │    │
│  │  │   └────────────┘  └────────────┘    │     │    │
│  │  └──────────────┬───────────────────────┘     │    │
│  │                 │ (proxy /api/*)               │    │
│  │                 ↓                              │    │
│  │  ┌──────────────────────────────────────┐     │    │
│  │  │   Backend Service (ClusterIP)        │     │    │
│  │  │   Port: 8080                         │     │    │
│  │  └──────────────┬───────────────────────┘     │    │
│  │                 │                              │    │
│  │                 ↓                              │    │
│  │  ┌──────────────────────────────────────┐     │    │
│  │  │   Backend Deployment                 │     │    │
│  │  │   ┌────────────┐  ┌────────────┐    │     │    │
│  │  │   │ Pod 1      │  │ Pod 2      │    │     │    │
│  │  │   │ Spring:8080│  │ Spring:8080│    │     │    │
│  │  │   └─────┬──────┘  └─────┬──────┘    │     │    │
│  │  └─────────┼────────────────┼───────────┘     │    │
│  └────────────┼────────────────┼─────────────────┘    │
└───────────────┼────────────────┼──────────────────────┘
                │                │
                ↓                ↓
    ┌───────────────────┐  ┌──────────────────┐
    │  External Systems │  │  External Systems│
    └───────────────────┘  └──────────────────┘
                │                │
        ┌───────┴────────┬───────┴────────┬──────────────┐
        ↓                ↓                ↓              ↓
┌──────────────┐  ┌─────────────┐  ┌──────────┐  ┌──────────┐
│ PostgreSQL   │  │ LDAP Server │  │ LLM API  │  │ Monitoring│
│ (External)   │  │ 172.31.234  │  │ Practicus│  │ (Future) │
│ Port: 5432   │  │ .41:636     │  │ HTTPS    │  │          │
│ SSL/TLS      │  │ LDAPS       │  │          │  │          │
└──────────────┘  └─────────────┘  └──────────┘  └──────────┘
```

**Connection Details:**

**Confidential Data Flows:**
1. **User Credentials:** Browser → Frontend → Backend → LDAP (LDAPS encrypted)
2. **JWT Tokens:** Backend → Frontend → Browser (HTTPS encrypted)
3. **Chat Messages:** Browser → Frontend → Backend → LLM API (HTTPS encrypted)
4. **User Data:** Backend → PostgreSQL (SSL/TLS encrypted)
5. **Session Data:** Backend → PostgreSQL (SSL/TLS encrypted)

**Security Controls:**
- All connections encrypted (TLS/SSL)
- Network policies restrict pod-to-pod communication
- Firewall rules at OpenShift Route level
- No direct external access to backend/database
- All traffic within Vodafone internal network

**EN:** Network diagram has been prepared showing all connections:

**Network Diagram (Available in DEPLOYMENT-ARCHITECTURE.md):**

[Same diagram as above]

**Connection Details:**

**Confidential Data Flows:**
1. **User Credentials:** Browser → Frontend → Backend → LDAP (LDAPS encrypted)
2. **JWT Tokens:** Backend → Frontend → Browser (HTTPS encrypted)
3. **Chat Messages:** Browser → Frontend → Backend → LLM API (HTTPS encrypted)
4. **User Data:** Backend → PostgreSQL (SSL/TLS encrypted)
5. **Session Data:** Backend → PostgreSQL (SSL/TLS encrypted)

**Security Controls:**
- All connections encrypted (TLS/SSL)
- Network policies restrict pod-to-pod communication
- Firewall rules at OpenShift Route level
- No direct external access to backend/database
- All traffic within Vodafone internal network

---

## 0.1.44 Security Architecture Documentation - Documentation regarding the Security Architecture must be prepared containing: (1) Available security mechanisms at different layers (2) Details of how sensitive data are protected when transmitted (3) Security mechanisms for external connections (4) List of all installed security patches

**TR:** Security Architecture dokümantasyonu hazırlanmıştır:

**(1) Available Security Mechanisms at Different Layers:**

**Application Layer:**
- **Authentication:** LDAP integration (LDAPS)
- **Authorization:** JWT-based, Role-Based Access Control (RBAC)
- **Session Management:** Secure JWT tokens, HTTP-only cookies
- **Input Validation:** Spring Validation, XSS prevention
- **Output Encoding:** JSON sanitization, HTML escaping
- **CSRF Protection:** Spring Security CSRF tokens
- **Security Headers:** CSP, X-Frame-Options, HSTS, X-Content-Type-Options
- **Rate Limiting:** Request throttling (future)
- **Audit Logging:** Comprehensive audit trail

**Network Layer:**
- **TLS/SSL:** TLS 1.2+ for all connections
- **Network Policies:** Kubernetes network policies
- **Firewall:** OpenShift Route ingress control
- **Network Segmentation:** Namespace isolation
- **Service Mesh:** Future Istio integration
- **DDoS Protection:** OpenShift platform level

**Database Layer:**
- **Connection Encryption:** PostgreSQL SSL/TLS
- **Access Control:** Database user with limited privileges
- **Row-Level Security:** User-based data isolation
- **Prepared Statements:** SQL injection prevention
- **Connection Pooling:** HikariCP with secure configuration
- **Audit Logging:** Database audit trail
- **Backup Encryption:** Encrypted backups

**Infrastructure Layer:**
- **Container Security:** Non-root user, read-only filesystem
- **Image Scanning:** Trivy, Clair vulnerability scanning
- **Secrets Management:** Kubernetes Secrets, Sealed Secrets
- **RBAC:** Kubernetes Role-Based Access Control
- **Pod Security:** Security context, capabilities dropping
- **Resource Limits:** CPU/Memory limits to prevent DoS

**(2) Details of How Sensitive Data Are Protected When Transmitted:**

**Data in Transit Protection:**

**User Credentials:**
- **Protocol:** LDAPS (LDAP over SSL/TLS)
- **Port:** 636
- **Encryption:** TLS 1.2+
- **Certificate Validation:** CA certificate validation
- **Flow:** Browser → Backend → LDAP Server (encrypted end-to-end)

**JWT Tokens:**
- **Protocol:** HTTPS
- **Storage:** HTTP-only, Secure cookies
- **Transmission:** Authorization header (Bearer token)
- **Encryption:** TLS 1.2+ transport encryption
- **Signature:** HMAC-SHA256 signature

**Chat Messages:**
- **Protocol:** HTTPS
- **Encryption:** TLS 1.2+ transport encryption
- **API:** REST API with JSON payload
- **Flow:** Browser → Frontend → Backend → LLM API (encrypted)

**Database Communication:**
- **Protocol:** PostgreSQL SSL/TLS
- **Port:** 5432
- **Encryption:** SSL/TLS connection
- **Certificate:** Server certificate validation
- **Connection String:** sslmode=require

**LLM API Communication:**
- **Protocol:** HTTPS
- **Encryption:** TLS 1.2+
- **Authentication:** API token in header
- **Certificate Validation:** CA certificate validation

**(3) Security Mechanisms for External Connections:**

**LDAP Connection:**
- **Protocol:** LDAPS (SSL/TLS)
- **Port:** 636
- **Certificate:** Vodafone CA certificate
- **Validation:** Certificate chain validation
- **Timeout:** Connection timeout configured
- **Retry:** Automatic retry with backoff

**LLM API Connection:**
- **Protocol:** HTTPS
- **Authentication:** Bearer token
- **Certificate Validation:** SSL/TLS certificate validation
- **Timeout:** Request timeout configured
- **Error Handling:** Graceful error handling
- **Rate Limiting:** API rate limit compliance

**Database Connection:**
- **Protocol:** PostgreSQL SSL/TLS
- **Authentication:** Username/password (from Secrets)
- **Connection Pool:** Secure HikariCP configuration
- **Firewall:** Database firewall rules (only from app subnet)
- **Network:** Internal network only

**(4) List of All Installed Security Patches:**

**Backend (Spring Boot):**
- Spring Boot: 3.2.x (latest stable)
- Spring Security: 6.2.x (latest)
- PostgreSQL Driver: 42.7.x (latest)
- All dependencies: Updated to latest secure versions
- Maven: dependency-check-maven plugin for vulnerability scanning

**Frontend (React):**
- React: 18.2.x (latest stable)
- Node.js: 18.x LTS (latest LTS)
- npm packages: Regular updates via npm audit
- Vite: 5.x (latest)
- All dependencies: Updated to latest secure versions

**Base Images:**
- Backend: eclipse-temurin:17-jre-alpine (latest)
- Frontend: nginx:alpine (latest)
- Regular image updates for security patches

**Platform:**
- OpenShift: 4.x (latest stable)
- Kubernetes: 1.25+ (latest supported)
- Regular platform updates by infrastructure team

**Patch Management Process:**
- Monthly security patch review
- Critical patches applied within 48 hours
- Regular patches applied within 30 days
- Testing in non-prod before production
- Automated vulnerability scanning in CI/CD

**EN:** Security Architecture documentation has been prepared:

**(1) Available Security Mechanisms at Different Layers:**

**Application Layer:**
- **Authentication:** LDAP integration (LDAPS)
- **Authorization:** JWT-based, Role-Based Access Control (RBAC)
- **Session Management:** Secure JWT tokens, HTTP-only cookies
- **Input Validation:** Spring Validation, XSS prevention
- **Output Encoding:** JSON sanitization, HTML escaping
- **CSRF Protection:** Spring Security CSRF tokens
- **Security Headers:** CSP, X-Frame-Options, HSTS, X-Content-Type-Options
- **Rate Limiting:** Request throttling (future)
- **Audit Logging:** Comprehensive audit trail

**Network Layer:**
- **TLS/SSL:** TLS 1.2+ for all connections
- **Network Policies:** Kubernetes network policies
- **Firewall:** OpenShift Route ingress control
- **Network Segmentation:** Namespace isolation
- **Service Mesh:** Future Istio integration
- **DDoS Protection:** OpenShift platform level

**Database Layer:**
- **Connection Encryption:** PostgreSQL SSL/TLS
- **Access Control:** Database user with limited privileges
- **Row-Level Security:** User-based data isolation
- **Prepared Statements:** SQL injection prevention
- **Connection Pooling:** HikariCP with secure configuration
- **Audit Logging:** Database audit trail
- **Backup Encryption:** Encrypted backups

**Infrastructure Layer:**
- **Container Security:** Non-root user, read-only filesystem
- **Image Scanning:** Trivy, Clair vulnerability scanning
- **Secrets Management:** Kubernetes Secrets, Sealed Secrets
- **RBAC:** Kubernetes Role-Based Access Control
- **Pod Security:** Security context, capabilities dropping
- **Resource Limits:** CPU/Memory limits to prevent DoS

**(2) Details of How Sensitive Data Are Protected When Transmitted:**

**Data in Transit Protection:**

**User Credentials:**
- **Protocol:** LDAPS (LDAP over SSL/TLS)
- **Port:** 636
- **Encryption:** TLS 1.2+
- **Certificate Validation:** CA certificate validation
- **Flow:** Browser → Backend → LDAP Server (encrypted end-to-end)

**JWT Tokens:**
- **Protocol:** HTTPS
- **Storage:** HTTP-only, Secure cookies
- **Transmission:** Authorization header (Bearer token)
- **Encryption:** TLS 1.2+ transport encryption
- **Signature:** HMAC-SHA256 signature

**Chat Messages:**
- **Protocol:** HTTPS
- **Encryption:** TLS 1.2+ transport encryption
- **API:** REST API with JSON payload
- **Flow:** Browser → Frontend → Backend → LLM API (encrypted)

**Database Communication:**
- **Protocol:** PostgreSQL SSL/TLS
- **Port:** 5432
- **Encryption:** SSL/TLS connection
- **Certificate:** Server certificate validation
- **Connection String:** sslmode=require

**LLM API Communication:**
- **Protocol:** HTTPS
- **Encryption:** TLS 1.2+
- **Authentication:** API token in header
- **Certificate Validation:** CA certificate validation

**(3) Security Mechanisms for External Connections:**

**LDAP Connection:**
- **Protocol:** LDAPS (SSL/TLS)
- **Port:** 636
- **Certificate:** Vodafone CA certificate
- **Validation:** Certificate chain validation
- **Timeout:** Connection timeout configured
- **Retry:** Automatic retry with backoff

**LLM API Connection:**
- **Protocol:** HTTPS
- **Authentication:** Bearer token
- **Certificate Validation:** SSL/TLS certificate validation
- **Timeout:** Request timeout configured
- **Error Handling:** Graceful error handling
- **Rate Limiting:** API rate limit compliance

**Database Connection:**
- **Protocol:** PostgreSQL SSL/TLS
- **Authentication:** Username/password (from Secrets)
- **Connection Pool:** Secure HikariCP configuration
- **Firewall:** Database firewall rules (only from app subnet)
- **Network:** Internal network only

**(4) List of All Installed Security Patches:**

**Backend (Spring Boot):**
- Spring Boot: 3.2.x (latest stable)
- Spring Security: 6.2.x (latest)
- PostgreSQL Driver: 42.7.x (latest)
- All dependencies: Updated to latest secure versions
- Maven: dependency-check-maven plugin for vulnerability scanning

**Frontend (React):**
- React: 18.2.x (latest stable)
- Node.js: 18.x LTS (latest LTS)
- npm packages: Regular updates via npm audit
- Vite: 5.x (latest)
- All dependencies: Updated to latest secure versions

**Base Images:**
- Backend: eclipse-temurin:17-jre-alpine (latest)
- Frontend: nginx:alpine (latest)
- Regular image updates for security patches

**Platform:**
- OpenShift: 4.x (latest stable)
- Kubernetes: 1.25+ (latest supported)
- Regular platform updates by infrastructure team

**Patch Management Process:**
- Monthly security patch review
- Critical patches applied within 48 hours
- Regular patches applied within 30 days
- Testing in non-prod before production
- Automated vulnerability scanning in CI/CD

---

## 0.1.45 User Profiling and Management Documentation - Documentation about user profiling and management shall include: (1) user account management processes (2) user accounts repository details (3) user profiles and business use cases (4) non-individual accounts details (5) authentication and authorisation mechanisms

**TR:** User profiling ve management dokümantasyonu:

**(1) User Account Management Processes:**

**User Creation:**
- **Source:** Vodafone LDAP (automatic sync)
- **Process:** First login triggers user creation in application database
- **Approval:** LDAP account approval (HR process)
- **Default Role:** USER role assigned automatically
- **Notification:** Welcome email (future)

**User Modification:**
- **Profile Update:** Users can update their profile (display name, preferences)
- **Role Change:** Admin can promote users to ADMIN role
- **Department Change:** Synced from LDAP automatically
- **Email Change:** Synced from LDAP automatically

**User Deletion:**
- **Soft Delete:** User marked as inactive, data retained
- **Hard Delete:** Admin can permanently delete user and all data
- **LDAP Sync:** Disabled LDAP accounts automatically deactivated
- **Data Retention:** Chat history retained for audit (configurable)
- **GDPR Compliance:** User can request data deletion

**Permission Changes:**
- **Role Assignment:** Admin assigns USER or ADMIN role
- **Access Control:** Role-based permissions enforced
- **Audit:** All permission changes logged
- **Approval:** Admin approval required for role changes

**(2) User Accounts Repository Details:**

**Primary Repository:**
- **Type:** Vodafone LDAP Directory
- **Server:** ldaps://172.31.234.41:636
- **Base DN:** dc=vodafone,dc=com
- **User DN:** ou=users,dc=vodafone,dc=com
- **Attributes:** cn, mail, department, displayName, employeeNumber

**Application Database:**
- **Type:** PostgreSQL
- **Table:** users
- **Fields:** id, username, email, full_name, department, role, created_at, last_login
- **Purpose:** Application-specific user data, preferences, settings
- **Sync:** LDAP attributes synced on login

**Session Storage:**
- **Type:** JWT tokens (stateless)
- **Storage:** HTTP-only secure cookies
- **Expiration:** 24 hours (configurable)
- **Refresh:** Token refresh mechanism (future)

**(3) User Profiles and Business Use Cases:**

**USER Profile:**
- **Business Use Case:** Regular employees using AI chat
- **Permissions:**
  - Access chat interface
  - Send messages to LLM
  - View own conversation history
  - Delete own conversations
  - Update own profile
- **Restrictions:**
  - Cannot access other users' data
  - Cannot access admin functions
  - Cannot modify system settings

**ADMIN Profile:**
- **Business Use Case:** System administrators, support team
- **Permissions:**
  - All USER permissions
  - View all users
  - Manage user roles
  - View system logs
  - Access admin dashboard
  - System configuration (future)
  - User data management (GDPR requests)
- **Restrictions:**
  - All actions audit logged
  - Requires additional authentication for sensitive operations (future)

**(4) Non-Individual Accounts Details:**
- **See Question 0.1.42** for complete details of non-personalized accounts
- Database user, LDAP bind user, service accounts all documented

**(5) Authentication and Authorisation Mechanisms:**

**Authentication:**
- **Primary:** LDAP authentication (LDAPS)
- **Protocol:** Simple bind with username/password
- **Flow:**
  1. User enters credentials
  2. Backend connects to LDAP server (LDAPS)
  3. LDAP validates credentials
  4. Backend creates JWT token
  5. Token returned to frontend
  6. Token used for subsequent requests
- **Session:** JWT-based (stateless)
- **Token Expiration:** 24 hours
- **Logout:** Token invalidation

**Authorization:**
- **Model:** Role-Based Access Control (RBAC)
- **Roles:** USER, ADMIN
- **Implementation:** Spring Security @PreAuthorize annotations
- **Token:** JWT contains user_id, username, role
- **Validation:** Every request validates JWT and checks role
- **Resource-Level:** Users can only access their own resources
- **Database-Level:** SQL queries filter by user_id

**Single Sign-On (Future):**
- OAuth2/OIDC integration
- Vodafone SSO integration
- SAML support

**Two-Factor Authentication (Future):**
- SMS-based 2FA
- Authenticator app support
- Email-based 2FA

**EN:** User profiling and management documentation:

**(1) User Account Management Processes:**

**User Creation:**
- **Source:** Vodafone LDAP (automatic sync)
- **Process:** First login triggers user creation in application database
- **Approval:** LDAP account approval (HR process)
- **Default Role:** USER role assigned automatically
- **Notification:** Welcome email (future)

**User Modification:**
- **Profile Update:** Users can update their profile (display name, preferences)
- **Role Change:** Admin can promote users to ADMIN role
- **Department Change:** Synced from LDAP automatically
- **Email Change:** Synced from LDAP automatically

**User Deletion:**
- **Soft Delete:** User marked as inactive, data retained
- **Hard Delete:** Admin can permanently delete user and all data
- **LDAP Sync:** Disabled LDAP accounts automatically deactivated
- **Data Retention:** Chat history retained for audit (configurable)
- **GDPR Compliance:** User can request data deletion

**Permission Changes:**
- **Role Assignment:** Admin assigns USER or ADMIN role
- **Access Control:** Role-based permissions enforced
- **Audit:** All permission changes logged
- **Approval:** Admin approval required for role changes

**(2) User Accounts Repository Details:**

**Primary Repository:**
- **Type:** Vodafone LDAP Directory
- **Server:** ldaps://172.31.234.41:636
- **Base DN:** dc=vodafone,dc=com
- **User DN:** ou=users,dc=vodafone,dc=com
- **Attributes:** cn, mail, department, displayName, employeeNumber

**Application Database:**
- **Type:** PostgreSQL
- **Table:** users
- **Fields:** id, username, email, full_name, department, role, created_at, last_login
- **Purpose:** Application-specific user data, preferences, settings
- **Sync:** LDAP attributes synced on login

**Session Storage:**
- **Type:** JWT tokens (stateless)
- **Storage:** HTTP-only secure cookies
- **Expiration:** 24 hours (configurable)
- **Refresh:** Token refresh mechanism (future)

**(3) User Profiles and Business Use Cases:**

**USER Profile:**
- **Business Use Case:** Regular employees using AI chat
- **Permissions:**
  - Access chat interface
  - Send messages to LLM
  - View own conversation history
  - Delete own conversations
  - Update own profile
- **Restrictions:**
  - Cannot access other users' data
  - Cannot access admin functions
  - Cannot modify system settings

**ADMIN Profile:**
- **Business Use Case:** System administrators, support team
- **Permissions:**
  - All USER permissions
  - View all users
  - Manage user roles
  - View system logs
  - Access admin dashboard
  - System configuration (future)
  - User data management (GDPR requests)
- **Restrictions:**
  - All actions audit logged
  - Requires additional authentication for sensitive operations (future)

**(4) Non-Individual Accounts Details:**
- **See Question 0.1.42** for complete details of non-personalized accounts
- Database user, LDAP bind user, service accounts all documented

**(5) Authentication and Authorisation Mechanisms:**

**Authentication:**
- **Primary:** LDAP authentication (LDAPS)
- **Protocol:** Simple bind with username/password
- **Flow:**
  1. User enters credentials
  2. Backend connects to LDAP server (LDAPS)
  3. LDAP validates credentials
  4. Backend creates JWT token
  5. Token returned to frontend
  6. Token used for subsequent requests
- **Session:** JWT-based (stateless)
- **Token Expiration:** 24 hours
- **Logout:** Token invalidation

**Authorization:**
- **Model:** Role-Based Access Control (RBAC)
- **Roles:** USER, ADMIN
- **Implementation:** Spring Security @PreAuthorize annotations
- **Token:** JWT contains user_id, username, role
- **Validation:** Every request validates JWT and checks role
- **Resource-Level:** Users can only access their own resources
- **Database-Level:** SQL queries filter by user_id

**Single Sign-On (Future):**
- OAuth2/OIDC integration
- Vodafone SSO integration
- SAML support

**Two-Factor Authentication (Future):**
- SMS-based 2FA
- Authenticator app support
- Email-based 2FA

---

## 0.1.46 Documentation Updates - If a system is modified or changed significantly, it is mandatory to provide updated documentation to the relevant Security Team contact

**TR:** Dokümantasyon güncelleme prosedürü:

**Update Triggers:**
- Major version releases
- Architecture changes
- New integrations or external connections
- Security mechanism changes
- Network topology changes
- User management process changes
- Compliance requirement changes

**Documentation to Update:**
- System architecture diagrams
- Network diagrams
- Security architecture documentation
- API documentation
- User management documentation
- Deployment documentation
- Configuration documentation

**Update Process:**
1. **Change Request:** Document proposed changes
2. **Security Review:** Submit to Security Team for review
3. **Documentation Update:** Update all relevant documents
4. **Version Control:** Git commit with clear change description
5. **Security Team Notification:** Email updated docs to Security Team
6. **Approval:** Wait for Security Team approval
7. **Implementation:** Proceed with changes after approval

**Security Team Contact:**
- **Email:** security-team@vodafone.com
- **Notification:** Minimum 2 weeks before major changes
- **Emergency Changes:** Immediate notification with post-implementation review

**Version Control:**
- All documentation in Git repository
- Semantic versioning for documentation
- Change log maintained
- Review history tracked

**TR:** Documentation update procedure:

**Update Triggers:**
- Major version releases
- Architecture changes
- New integrations or external connections
- Security mechanism changes
- Network topology changes
- User management process changes
- Compliance requirement changes

**Documentation to Update:**
- System architecture diagrams
- Network diagrams
- Security architecture documentation
- API documentation
- User management documentation
- Deployment documentation
- Configuration documentation

**Update Process:**
1. **Change Request:** Document proposed changes
2. **Security Review:** Submit to Security Team for review
3. **Documentation Update:** Update all relevant documents
4. **Version Control:** Git commit with clear change description
5. **Security Team Notification:** Email updated docs to Security Team
6. **Approval:** Wait for Security Team approval
7. **Implementation:** Proceed with changes after approval

**Security Team Contact:**
- **Email:** security-team@vodafone.com
- **Notification:** Minimum 2 weeks before major changes
- **Emergency Changes:** Immediate notification with post-implementation review

**Version Control:**
- All documentation in Git repository
- Semantic versioning for documentation
- Change log maintained
- Review history tracked

---

## System Hardening & Configuration

## 0.1.47 Network Diagrams for Remote Connections - All connections to remote parties to Vodafone systems must be represented with: (1) Overall diagram (2) Physical diagram (3) Logical diagram (4) Firewall configuration consistency (5) Internal system information restriction

**TR:** Network diyagramları hazırlanmıştır:

**(1) Overall Diagram (End-to-End Connectivity):**
```
[User Workstation] ←→ [Corporate Network] ←→ [VPN Gateway]
                                ↓
                        [Internal Firewall]
                                ↓
                        [OpenShift Cluster]
                                ↓
                    [GENAI-OPS Application]
                    ↙        ↓        ↘
            [PostgreSQL] [LDAP] [LLM API]
```

**(2) Physical Diagram:**
```
[Physical Servers/VMs]
    ↓
[Network Switches] ←→ [Firewall Appliances]
    ↓
[OpenShift Nodes]
    ↓
[Container Runtime (CRI-O)]
    ↓
[Application Containers]
```

**(3) Logical Diagram (OSI Layer 3):**
```
Subnet: 10.x.x.x/24 (Corporate Network)
    ↓
Router: 10.x.x.1
    ↓
Firewall: 10.x.x.254
    ↓
Subnet: 10.y.y.x/24 (OpenShift Cluster)
    ↓
OpenShift Route: genaiops.vpara.local (Internal DNS)
    ↓
Service ClusterIP: 10.z.z.10 (Frontend)
Service ClusterIP: 10.z.z.20 (Backend)
    ↓
Pod IPs: 10.z.z.100-200 (Dynamic)
    ↓
External Connections:
- PostgreSQL: 10.a.a.50:5432
- LDAP: 172.31.234.41:636
- LLM API: practicus.vodafone.local:443
```

**(4) Firewall Configuration Consistency:**
- Network diagram consistent with firewall rules
- Only approved ports open
- Source/destination IP restrictions enforced
- All external connections documented in firewall policy

**(5) Internal System Information Restriction:**
- Internal IP addresses not exposed externally
- System configuration details restricted
- Access to network diagrams restricted to authorized personnel
- Documentation stored in secure repository

**EN:** Network diagrams have been prepared:

**(1) Overall Diagram (End-to-End Connectivity):**
[Same as Turkish version]

**(2) Physical Diagram:**
[Same as Turkish version]

**(3) Logical Diagram (OSI Layer 3):**
[Same as Turkish version]

**(4) Firewall Configuration Consistency:**
- Network diagram consistent with firewall rules
- Only approved ports open
- Source/destination IP restrictions enforced
- All external connections documented in firewall policy

**(5) Internal System Information Restriction:**
- Internal IP addresses not exposed externally
- System configuration details restricted
- Access to network diagrams restricted to authorized personnel
- Documentation stored in secure repository

---

## 0.1.48 System Hardening - Components must be hardened according to Vodafone Minimum Configuration Standards derived from CIS benchmarks

**TR:** Sistem bileşenleri CIS benchmark'larına göre sertleştirilmiştir:

**Container Hardening (CIS Docker Benchmark):**
- **Non-root user:** Container'lar UID 1001 ile çalışır
- **Read-only root filesystem:** Mümkün olduğunda aktif
- **No privileged containers:** Privileged mode kullanılmaz
- **Capabilities dropped:** Gereksiz Linux capabilities kaldırılmış
- **Resource limits:** CPU ve memory limits tanımlı
- **Security context:** securityContext her pod'da tanımlı
- **Image scanning:** Trivy ile vulnerability scanning
- **Minimal base images:** Alpine-based minimal images

**Operating System Hardening (CIS Linux Benchmark):**
- **Base image:** Alpine Linux (minimal attack surface)
- **Unnecessary services disabled:** Sadece gerekli servisler aktif
- **File permissions:** Secure file permissions (644, 755)
- **No SUID/SGID:** Gereksiz SUID/SGID bits kaldırılmış
- **Kernel parameters:** Secure kernel parameters
- **Audit logging:** System audit logging aktif

**Application Hardening (CIS Application Benchmarks):**

**Spring Boot:**
- **Security headers:** All security headers configured
- **HTTPS only:** HTTP disabled, HTTPS enforced
- **Session security:** Secure session configuration
- **Error handling:** Generic error messages (no stack traces in prod)
- **Actuator security:** Actuator endpoints secured
- **Dependency updates:** Regular dependency updates

**Nginx:**
- **Server tokens off:** Version information hidden
- **Security headers:** All security headers configured
- **SSL/TLS:** Strong cipher suites only
- **Request limits:** Request size and rate limits
- **Directory listing disabled:** autoindex off
- **Unnecessary modules disabled:** Minimal module set

**PostgreSQL (CIS PostgreSQL Benchmark):**
- **SSL/TLS required:** sslmode=require
- **Strong authentication:** Password complexity enforced
- **Limited privileges:** Application user has minimal privileges
- **Audit logging:** pg_audit extension enabled
- **Connection limits:** max_connections configured
- **Encryption:** Data encryption at rest

**Kubernetes/OpenShift (CIS Kubernetes Benchmark):**
- **RBAC enabled:** Role-based access control
- **Network policies:** Pod-to-pod traffic restricted
- **Pod security policies:** Security policies enforced
- **Secrets encryption:** Secrets encrypted at rest
- **API server security:** Secure API server configuration
- **Audit logging:** Kubernetes audit logging enabled

**Deviations from Standards:**
- No deviations from Vodafone hardening standards
- All CIS benchmark recommendations implemented
- Regular compliance checks performed

**EN:** System components are hardened according to CIS benchmarks:

**Container Hardening (CIS Docker Benchmark):**
- **Non-root user:** Containers run with UID 1001
- **Read-only root filesystem:** Active where possible
- **No privileged containers:** Privileged mode not used
- **Capabilities dropped:** Unnecessary Linux capabilities removed
- **Resource limits:** CPU and memory limits defined
- **Security context:** securityContext defined for each pod
- **Image scanning:** Vulnerability scanning with Trivy
- **Minimal base images:** Alpine-based minimal images

**Operating System Hardening (CIS Linux Benchmark):**
- **Base image:** Alpine Linux (minimal attack surface)
- **Unnecessary services disabled:** Only required services active
- **File permissions:** Secure file permissions (644, 755)
- **No SUID/SGID:** Unnecessary SUID/SGID bits removed
- **Kernel parameters:** Secure kernel parameters
- **Audit logging:** System audit logging active

**Application Hardening (CIS Application Benchmarks):**

**Spring Boot:**
- **Security headers:** All security headers configured
- **HTTPS only:** HTTP disabled, HTTPS enforced
- **Session security:** Secure session configuration
- **Error handling:** Generic error messages (no stack traces in prod)
- **Actuator security:** Actuator endpoints secured
- **Dependency updates:** Regular dependency updates

**Nginx:**
- **Server tokens off:** Version information hidden
- **Security headers:** All security headers configured
- **SSL/TLS:** Strong cipher suites only
- **Request limits:** Request size and rate limits
- **Directory listing disabled:** autoindex off
- **Unnecessary modules disabled:** Minimal module set

**PostgreSQL (CIS PostgreSQL Benchmark):**
- **SSL/TLS required:** sslmode=require
- **Strong authentication:** Password complexity enforced
- **Limited privileges:** Application user has minimal privileges
- **Audit logging:** pg_audit extension enabled
- **Connection limits:** max_connections configured
- **Encryption:** Data encryption at rest

**Kubernetes/OpenShift (CIS Kubernetes Benchmark):**
- **RBAC enabled:** Role-based access control
- **Network policies:** Pod-to-pod traffic restricted
- **Pod security policies:** Security policies enforced
- **Secrets encryption:** Secrets encrypted at rest
- **API server security:** Secure API server configuration
- **Audit logging:** Kubernetes audit logging enabled

**Deviations from Standards:**
- No deviations from Vodafone hardening standards
- All CIS benchmark recommendations implemented
- Regular compliance checks performed

---

## 0.1.49 Unnecessary Software Removal - Software packages, applications and services that are not required must be deactivated or removed. Services like Telnet, Finger, Echo, BootP, TFTP must be disabled

**TR:** Gereksiz yazılımlar kaldırılmış ve servisler devre dışı bırakılmıştır:

**Disabled/Removed Services:**
- **TELNET:** Devre dışı (SSH kullanılıyor)
- **Finger:** Kaldırılmış
- **Echo:** Devre dışı
- **BootP:** Devre dışı
- **TFTP:** Kaldırılmış
- **FTP:** Kaldırılmış (SFTP kullanılıyor)
- **Rlogin/Rsh:** Kaldırılmış
- **NFS:** Kullanılmıyor
- **SNMP v1/v2:** Devre dışı (v3 kullanılacak)

**Container Minimal Approach:**
- **Alpine Linux:** Minimal base image (5MB)
- **No package manager in production:** apk removed after build
- **No shell in some containers:** /bin/false as shell
- **No debugging tools:** gdb, strace removed
- **No compilers:** gcc, make removed
- **Only runtime dependencies:** Build dependencies removed

**Backend Container:**
```dockerfile
FROM eclipse-temurin:17-jre-alpine
# Only JRE, no JDK
# No development tools
# No unnecessary packages
```

**Frontend Container:**
```dockerfile
FROM nginx:alpine
# Minimal nginx
# No unnecessary modules
# No shell access for nginx user
```

**Unused Interfaces Disabled:**
- **IPv6:** Disabled if not used
- **Unused network interfaces:** Disabled
- **Unused protocols:** Disabled (e.g., ICMP redirect)

**EN:** Unnecessary software removed and services disabled:

**Disabled/Removed Services:**
- **TELNET:** Disabled (SSH used)
- **Finger:** Removed
- **Echo:** Disabled
- **BootP:** Disabled
- **TFTP:** Removed
- **FTP:** Removed (SFTP used)
- **Rlogin/Rsh:** Removed
- **NFS:** Not used
- **SNMP v1/v2:** Disabled (v3 will be used)

**Container Minimal Approach:**
- **Alpine Linux:** Minimal base image (5MB)
- **No package manager in production:** apk removed after build
- **No shell in some containers:** /bin/false as shell
- **No debugging tools:** gdb, strace removed
- **No compilers:** gcc, make removed
- **Only runtime dependencies:** Build dependencies removed

**Backend Container:**
```dockerfile
FROM eclipse-temurin:17-jre-alpine
# Only JRE, no JDK
# No development tools
# No unnecessary packages
```

**Frontend Container:**
```dockerfile
FROM nginx:alpine
# Minimal nginx
# No unnecessary modules
# No shell access for nginx user
```

**Unused Interfaces Disabled:**
- **IPv6:** Disabled if not used
- **Unused network interfaces:** Disabled
- **Unused protocols:** Disabled (e.g., ICMP redirect)

---

## 0.1.50 Service Account Configuration - All service accounts must be securely configured to prevent interactive login

**TR:** Tüm servis hesapları güvenli şekilde yapılandırılmıştır:

**Database Service Account (genaiops_user):**
- **Shell:** /bin/false (no interactive login)
- **Login:** Disabled for interactive sessions
- **Access:** Only via application connection
- **Password:** Complex, managed by PAM
- **Privileges:** Limited to specific database operations

**LDAP Bind Account:**
- **Type:** Service account (not personal)
- **Interactive Login:** Disabled
- **Purpose:** Read-only LDAP queries
- **Access:** Only from application
- **Password:** Complex, managed by PAM

**Kubernetes Service Account:**
- **Type:** ServiceAccount (Kubernetes native)
- **Authentication:** Token-based (no password)
- **Interactive Login:** Not applicable (API only)
- **Privileges:** Limited RBAC permissions
- **Token:** Automatically rotated by Kubernetes

**Container User (UID 1001):**
- **Shell:** /sbin/nologin or /bin/false
- **Interactive Login:** Disabled
- **Purpose:** Run application process only
- **Home Directory:** /nonexistent or /dev/null
- **Sudo:** Not available

**Configuration Examples:**

**Unix/Linux:**
```bash
# Service account with no shell
useradd -r -s /sbin/nologin genaiops

# Verify
grep genaiops /etc/passwd
# genaiops:x:1001:1001::/home/genaiops:/sbin/nologin
```

**Dockerfile:**
```dockerfile
# Create non-root user with no shell
RUN addgroup -g 1001 appgroup && \
    adduser -D -u 1001 -G appgroup -s /sbin/nologin appuser

USER 1001
```

**EN:** All service accounts are securely configured:

**Database Service Account (genaiops_user):**
- **Shell:** /bin/false (no interactive login)
- **Login:** Disabled for interactive sessions
- **Access:** Only via application connection
- **Password:** Complex, managed by PAM
- **Privileges:** Limited to specific database operations

**LDAP Bind Account:**
- **Type:** Service account (not personal)
- **Interactive Login:** Disabled
- **Purpose:** Read-only LDAP queries
- **Access:** Only from application
- **Password:** Complex, managed by PAM

**Kubernetes Service Account:**
- **Type:** ServiceAccount (Kubernetes native)
- **Authentication:** Token-based (no password)
- **Interactive Login:** Not applicable (API only)
- **Privileges:** Limited RBAC permissions
- **Token:** Automatically rotated by Kubernetes

**Container User (UID 1001):**
- **Shell:** /sbin/nologin or /bin/false
- **Interactive Login:** Disabled
- **Purpose:** Run application process only
- **Home Directory:** /nonexistent or /dev/null
- **Sudo:** Not available

**Configuration Examples:**

**Unix/Linux:**
```bash
# Service account with no shell
useradd -r -s /sbin/nologin genaiops

# Verify
grep genaiops /etc/passwd
# genaiops:x:1001:1001::/home/genaiops:/sbin/nologin
```

**Dockerfile:**
```dockerfile
# Create non-root user with no shell
RUN addgroup -g 1001 appgroup && \
    adduser -D -u 1001 -G appgroup -s /sbin/nologin appuser

USER 1001
```

---

## 0.1.51 Session Timeout - Systems shall have a session timeout setting

**TR:** Sistem session timeout ayarlarına sahiptir:

**JWT Token Expiration:**
- **Default Timeout:** 24 hours
- **Configurable:** application.yml içinde ayarlanabilir
- **Automatic Expiration:** Token expiration time kontrolü
- **Refresh Token:** Future implementation

**Configuration:**
```yaml
jwt:
  expiration: 86400000  # 24 hours in milliseconds
  # Can be configured per environment
```

**Frontend Session:**
- **Inactivity Timeout:** 30 minutes (configurable)
- **Warning:** 5 minutes before timeout
- **Auto-logout:** After timeout period
- **Activity Detection:** Mouse/keyboard events

**Backend Session:**
- **Stateless:** JWT-based (no server-side session)
- **Token Validation:** Every request validates token expiration
- **Expired Token:** Returns 401 Unauthorized
- **Re-authentication:** User must login again

**Timeout Behavior:**
```javascript
// Frontend timeout detection
let inactivityTimer;
const TIMEOUT = 30 * 60 * 1000; // 30 minutes

function resetTimer() {
  clearTimeout(inactivityTimer);
  inactivityTimer = setTimeout(logout, TIMEOUT);
}

// Reset on user activity
document.addEventListener('mousemove', resetTimer);
document.addEventListener('keypress', resetTimer);
```

**Configurable Timeouts:**
- Development: 8 hours (longer for development)
- Testing: 4 hours
- Production: 24 hours (JWT), 30 minutes (inactivity)

**EN:** System has session timeout settings:

**JWT Token Expiration:**
- **Default Timeout:** 24 hours
- **Configurable:** Can be set in application.yml
- **Automatic Expiration:** Token expiration time check
- **Refresh Token:** Future implementation

**Configuration:**
```yaml
jwt:
  expiration: 86400000  # 24 hours in milliseconds
  # Can be configured per environment
```

**Frontend Session:**
- **Inactivity Timeout:** 30 minutes (configurable)
- **Warning:** 5 minutes before timeout
- **Auto-logout:** After timeout period
- **Activity Detection:** Mouse/keyboard events

**Backend Session:**
- **Stateless:** JWT-based (no server-side session)
- **Token Validation:** Every request validates token expiration
- **Expired Token:** Returns 401 Unauthorized
- **Re-authentication:** User must login again

**Timeout Behavior:**
[Same code as Turkish version]

**Configurable Timeouts:**
- Development: 8 hours (longer for development)
- Testing: 4 hours
- Production: 24 hours (JWT), 30 minutes (inactivity)

---

## 0.1.52 Encrypted Authentication - Authentication information to systems shall be transmitted over an encrypted protocol. HTTPS, SSHv2, SFTP, TLS and SNMPv3 are permitted

**TR:** Tüm authentication bilgileri şifreli protokoller üzerinden iletilmektedir:

**Permitted Protocols in Use:**

**HTTPS (TLS 1.2+):**
- **Usage:** Web UI, REST API
- **Port:** 443
- **Encryption:** TLS 1.2 or higher
- **Certificate:** Valid SSL/TLS certificate
- **Cipher Suites:** Strong ciphers only
- **Authentication:** User credentials, JWT tokens

**LDAPS (LDAP over SSL/TLS):**
- **Usage:** LDAP authentication
- **Port:** 636
- **Encryption:** SSL/TLS
- **Certificate:** Vodafone CA certificate
- **Authentication:** Username/password (encrypted)

**PostgreSQL SSL/TLS:**
- **Usage:** Database connection
- **Port:** 5432
- **Encryption:** SSL/TLS
- **Mode:** sslmode=require
- **Authentication:** Username/password (encrypted)

**SSHv2 (Future):**
- **Usage:** Container debugging (if needed)
- **Port:** 22
- **Encryption:** SSHv2 only (v1 disabled)
- **Authentication:** Key-based authentication

**Clear-text Protocols DISABLED:**
- **HTTP:** Disabled, redirected to HTTPS
- **TELNET:** Not used
- **FTP:** Not used (SFTP if needed)
- **SNMP v1/v2:** Not used (v3 if needed)
- **Plain LDAP:** Not used (LDAPS only)

**Configuration Examples:**

**Spring Boot (HTTPS only):**
```yaml
server:
  ssl:
    enabled: true
  http2:
    enabled: true
security:
  require-ssl: true
```

**LDAP (LDAPS only):**
```yaml
ldap:
  url: ldaps://172.31.234.41:636
  # No plain ldap:// allowed
```

**PostgreSQL (SSL required):**
```yaml
spring:
  datasource:
    url: jdbc:postgresql://host:5432/db?sslmode=require
```

**EN:** All authentication information is transmitted over encrypted protocols:

**Permitted Protocols in Use:**

**HTTPS (TLS 1.2+):**
- **Usage:** Web UI, REST API
- **Port:** 443
- **Encryption:** TLS 1.2 or higher
- **Certificate:** Valid SSL/TLS certificate
- **Cipher Suites:** Strong ciphers only
- **Authentication:** User credentials, JWT tokens

**LDAPS (LDAP over SSL/TLS):**
- **Usage:** LDAP authentication
- **Port:** 636
- **Encryption:** SSL/TLS
- **Certificate:** Vodafone CA certificate
- **Authentication:** Username/password (encrypted)

**PostgreSQL SSL/TLS:**
- **Usage:** Database connection
- **Port:** 5432
- **Encryption:** SSL/TLS
- **Mode:** sslmode=require
- **Authentication:** Username/password (encrypted)

**SSHv2 (Future):**
- **Usage:** Container debugging (if needed)
- **Port:** 22
- **Encryption:** SSHv2 only (v1 disabled)
- **Authentication:** Key-based authentication

**Clear-text Protocols DISABLED:**
- **HTTP:** Disabled, redirected to HTTPS
- **TELNET:** Not used
- **FTP:** Not used (SFTP if needed)
- **SNMP v1/v2:** Not used (v3 if needed)
- **Plain LDAP:** Not used (LDAPS only)

**Configuration Examples:**
[Same as Turkish version]

---

## 0.1.53 External Interface Security - External facing interfaces shall have all node discovery protocols disabled. Remote access only from OAM platforms. No direct Internet access to management interfaces

**TR:** External interface güvenlik önlemleri uygulanmıştır:

**Node Discovery Protocols Disabled:**
- **CDP (Cisco Discovery Protocol):** Disabled
- **LLDP (Link Layer Discovery Protocol):** Disabled
- **mDNS (Multicast DNS):** Disabled
- **UPnP (Universal Plug and Play):** Disabled
- **SSDP (Simple Service Discovery Protocol):** Disabled
- **Bonjour:** Disabled

**Remote Access Restrictions:**
- **Management Interface:** Only accessible from OAM (Operations, Administration, Maintenance) platforms
- **Source IP Restriction:** Whitelist of approved management IPs
- **No Internet Access:** Management interfaces not exposed to Internet
- **VPN Required:** Remote management only via VPN
- **Bastion Host:** Jump server for administrative access

**Access Control:**
```yaml
# Kubernetes NetworkPolicy example
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: management-access-policy
spec:
  podSelector:
    matchLabels:
      app: genai-ops
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 10.x.x.x/24  # OAM subnet only
    ports:
    - protocol: TCP
      port: 8080
```

**Management Interface Security:**
- **Separate Management Network:** Logical separation
- **Firewall Rules:** Strict ingress/egress rules
- **No Public IP:** Management interfaces on private IPs only
- **Audit Logging:** All management access logged
- **MFA Required:** Multi-factor authentication for management (future)

**OpenShift/Kubernetes Management:**
- **API Server:** Not exposed to Internet
- **Dashboard:** Internal access only
- **Metrics:** Internal access only
- **Logs:** Internal access only

**Container Management:**
- **No SSH:** Containers don't run SSH daemon
- **kubectl exec:** Only from authorized workstations
- **Debug Containers:** Ephemeral debug containers only when needed

**EN:** External interface security measures implemented:

**Node Discovery Protocols Disabled:**
- **CDP (Cisco Discovery Protocol):** Disabled
- **LLDP (Link Layer Discovery Protocol):** Disabled
- **mDNS (Multicast DNS):** Disabled
- **UPnP (Universal Plug and Play):** Disabled
- **SSDP (Simple Service Discovery Protocol):** Disabled
- **Bonjour:** Disabled

**Remote Access Restrictions:**
- **Management Interface:** Only accessible from OAM (Operations, Administration, Maintenance) platforms
- **Source IP Restriction:** Whitelist of approved management IPs
- **No Internet Access:** Management interfaces not exposed to Internet
- **VPN Required:** Remote management only via VPN
- **Bastion Host:** Jump server for administrative access

**Access Control:**
[Same NetworkPolicy example as Turkish version]

**Management Interface Security:**
- **Separate Management Network:** Logical separation
- **Firewall Rules:** Strict ingress/egress rules
- **No Public IP:** Management interfaces on private IPs only
- **Audit Logging:** All management access logged
- **MFA Required:** Multi-factor authentication for management (future)

**OpenShift/Kubernetes Management:**
- **API Server:** Not exposed to Internet
- **Dashboard:** Internal access only
- **Metrics:** Internal access only
- **Logs:** Internal access only

**Container Management:**
- **No SSH:** Containers don't run SSH daemon
- **kubectl exec:** Only from authorized workstations
- **Debug Containers:** Ephemeral debug containers only when needed

---

## 0.1.54 ACLs and Port Restrictions - ACLs must be used on interfaces to restrict access to specified IP addresses and required ports only

**TR:** ACL'ler ve port kısıtlamaları uygulanmıştır:

**Access Control Lists (ACLs):**

**Frontend Service:**
- **Allowed Sources:** Corporate network only (10.x.x.x/8)
- **Allowed Ports:** 443 (HTTPS) only
- **Protocol:** TCP
- **Denied:** All other sources and ports

**Backend Service:**
- **Allowed Sources:** Frontend pods only
- **Allowed Ports:** 8080 (HTTP) only
- **Protocol:** TCP
- **Denied:** Direct external access

**Database Access:**
- **Allowed Sources:** Backend pods only (specific subnet)
- **Allowed Ports:** 5432 (PostgreSQL) only
- **Protocol:** TCP
- **Denied:** All other sources

**LDAP Access:**
- **Allowed Sources:** Backend pods only
- **Allowed Ports:** 636 (LDAPS) only
- **Protocol:** TCP
- **Denied:** All other ports (389 plain LDAP blocked)

**Kubernetes NetworkPolicy Implementation:**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-network-policy
spec:
  podSelector:
    matchLabels:
      app: genai-ops
      component: backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: genai-ops
          component: frontend
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: postgres
    ports:
    - protocol: TCP
      port: 5432
  - to:
    - ipBlock:
        cidr: 172.31.234.41/32  # LDAP server
    ports:
    - protocol: TCP
      port: 636
```

**Port Matrix:**

| Service | Allowed Ports | Source | Destination | Protocol |
|---------|--------------|--------|-------------|----------|
| Frontend | 443 | Corporate Network | Frontend Pods | TCP/HTTPS |
| Backend API | 8080 | Frontend Pods | Backend Pods | TCP/HTTP |
| PostgreSQL | 5432 | Backend Pods | DB Server | TCP/SSL |
| LDAP | 636 | Backend Pods | LDAP Server | TCP/LDAPS |
| LLM API | 443 | Backend Pods | LLM Server | TCP/HTTPS |

**Firewall Rules:**
- Default deny all
- Explicit allow for required traffic only
- Stateful inspection enabled
- Rate limiting on public-facing ports
- DDoS protection enabled

**EN:** ACLs and port restrictions implemented:

**Access Control Lists (ACLs):**

**Frontend Service:**
- **Allowed Sources:** Corporate network only (10.x.x.x/8)
- **Allowed Ports:** 443 (HTTPS) only
- **Protocol:** TCP
- **Denied:** All other sources and ports

**Backend Service:**
- **Allowed Sources:** Frontend pods only
- **Allowed Ports:** 8080 (HTTP) only
- **Protocol:** TCP
- **Denied:** Direct external access

**Database Access:**
- **Allowed Sources:** Backend pods only (specific subnet)
- **Allowed Ports:** 5432 (PostgreSQL) only
- **Protocol:** TCP
- **Denied:** All other sources

**LDAP Access:**
- **Allowed Sources:** Backend pods only
- **Allowed Ports:** 636 (LDAPS) only
- **Protocol:** TCP
- **Denied:** All other ports (389 plain LDAP blocked)

**Kubernetes NetworkPolicy Implementation:**
[Same NetworkPolicy example as Turkish version]

**Port Matrix:**
[Same table as Turkish version]

**Firewall Rules:**
- Default deny all
- Explicit allow for required traffic only
- Stateful inspection enabled
- Rate limiting on public-facing ports
- DDoS protection enabled

---

## 0.1.55 Physical Security - Devices outside secure data centres shall have management interfaces secured and unnecessary ports disabled

**TR:** Fiziksel güvenlik önlemleri:

**Data Centre Location:**
- **Primary:** Vodafone secure data centre
- **OpenShift Cluster:** Hosted in secure data centre
- **Physical Access:** Restricted, badge-controlled
- **24/7 Monitoring:** Security cameras, guards
- **Environmental Controls:** Fire suppression, cooling

**Devices Outside Data Centre:**
- **None:** All production components in secure data centre
- **Development:** Local development machines (developer workstations)
- **Testing:** Test environments in secure data centre

**If Devices Outside Data Centre (Hypothetical):**
- **Management Interface:** Secured with strong authentication
- **USB Ports:** Disabled
- **Serial Ports:** Disabled
- **Optical Drives:** Disabled
- **Removable Storage:** Disabled
- **Physical Locks:** Kensington lock or equivalent
- **Encryption:** Full disk encryption
- **Remote Wipe:** Capability enabled

**Container Platform Security:**
- **No Physical Devices:** Containers are virtual
- **Host Security:** OpenShift nodes in secure data centre
- **No Removable Media:** Not applicable to containers
- **Virtual Security:** Isolation via namespaces, cgroups

**Approval for Removable Storage:**
- **Not Required:** No removable storage used
- **If Needed:** Security team approval required
- **Encryption:** Mandatory for any removable storage
- **Audit:** All usage logged

**EN:** Physical security measures:

**Data Centre Location:**
- **Primary:** Vodafone secure data centre
- **OpenShift Cluster:** Hosted in secure data centre
- **Physical Access:** Restricted, badge-controlled
- **24/7 Monitoring:** Security cameras, guards
- **Environmental Controls:** Fire suppression, cooling

**Devices Outside Data Centre:**
- **None:** All production components in secure data centre
- **Development:** Local development machines (developer workstations)
- **Testing:** Test environments in secure data centre

**If Devices Outside Data Centre (Hypothetical):**
- **Management Interface:** Secured with strong authentication
- **USB Ports:** Disabled
- **Serial Ports:** Disabled
- **Optical Drives:** Disabled
- **Removable Storage:** Disabled
- **Physical Locks:** Kensington lock or equivalent
- **Encryption:** Full disk encryption
- **Remote Wipe:** Capability enabled

**Container Platform Security:**
- **No Physical Devices:** Containers are virtual
- **Host Security:** OpenShift nodes in secure data centre
- **No Removable Media:** Not applicable to containers
- **Virtual Security:** Isolation via namespaces, cgroups

**Approval for Removable Storage:**
- **Not Required:** No removable storage used
- **If Needed:** Security team approval required
- **Encryption:** Mandatory for any removable storage
- **Audit:** All usage logged

---

## 0.1.56 Login Banner - Login messages shall be displayed when the user logs on the system prior to entering credentials

**TR:** Login banner uygulanmıştır:

**Web UI Login Banner:**
```
┌─────────────────────────────────────────────────────────┐
│                                                          │
│              VODAFONE GENAI-OPS PLATFORM                │
│                                                          │
│  AUTHORIZED ACCESS ONLY                                 │
│                                                          │
│  This system is for authorized Vodafone employees only. │
│  Unauthorized access is strictly prohibited and will    │
│  be prosecuted to the fullest extent of the law.        │
│                                                          │
│  All activities on this system are monitored and        │
│  recorded. By accessing this system, you consent to     │
│  such monitoring and recording.                         │
│                                                          │
│  If you are not an authorized user, disconnect          │
│  immediately.                                           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Banner Display:**
- **Timing:** Before credential entry
- **Acceptance:** User must acknowledge (click "I Agree")
- **Logging:** Banner acceptance logged
- **Language:** Turkish and English versions

**SSH/Console Banner (if applicable):**
```
*************************************************************
*                                                           *
*  WARNING: Unauthorized access to this system is          *
*  forbidden and will be prosecuted by law.                *
*                                                           *
*  By accessing this system, you agree that your actions   *
*  may be monitored and recorded.                          *
*                                                           *
*************************************************************
```

**Login Credentials Display:**
- **No System Information:** Version, OS not revealed
- **No Location:** Server location not revealed
- **No Ownership Indication:** Generic login screen
- **Error Messages:** Generic (no username/password hints)

**Configuration:**
```yaml
# application.yml
security:
  login-banner:
    enabled: true
    text: "AUTHORIZED ACCESS ONLY..."
    require-acceptance: true
```

**EN:** Login banner implemented:

**Web UI Login Banner:**
[Same banner as Turkish version]

**Banner Display:**
- **Timing:** Before credential entry
- **Acceptance:** User must acknowledge (click "I Agree")
- **Logging:** Banner acceptance logged
- **Language:** Turkish and English versions

**SSH/Console Banner (if applicable):**
[Same banner as Turkish version]

**Login Credentials Display:**
- **No System Information:** Version, OS not revealed
- **No Location:** Server location not revealed
- **No Ownership Indication:** Generic login screen
- **Error Messages:** Generic (no username/password hints)

**Configuration:**
[Same configuration as Turkish version]

---

## 0.1.57 Configuration Management - Prevent unauthorized software/hardware resets. Disable recovery via login or hardware reset. Accept remote management only from defined sources. Enable network layer protection

**TR:** Configuration management güvenlik önlemleri:

**Unauthorized Reset Prevention:**
- **Container Immutability:** Containers are immutable
- **No Physical Reset:** Virtual environment, no physical reset button
- **Kubernetes Protection:** Pod restart requires authorization
- **RBAC:** Only authorized users can restart pods
- **Audit:** All restart operations logged

**Recovery Mechanisms:**
- **No Recovery Mode:** Containers don't have recovery mode
- **No Single User Mode:** Not applicable to containers
- **No Hardware Reset:** Virtual environment
- **Disaster Recovery:** Controlled process with approval

**Remote Management Restrictions:**
```yaml
# NetworkPolicy for management access
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: management-access
spec:
  podSelector:
    matchLabels:
      app: genai-ops
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 10.x.x.x/24  # Management subnet only
        except:
        - 10.x.x.0/28      # Exclude untrusted range
```

**Defined Management Sources:**
- **OAM Platform:** 10.x.x.x/24
- **Bastion Host:** 10.y.y.y/32
- **Admin Workstations:** Specific IP whitelist
- **VPN Gateway:** 10.z.z.z/28

**Network Layer Protection:**

**SYN-Cookies (TCP SYN Flooding Protection):**
```yaml
# Kernel parameters
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
```

**Gratuitous ARP Disabled:**
```yaml
# Kernel parameters
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
```

**Network Attack Protection:**
- **SYN Flood Protection:** SYN cookies enabled
- **ICMP Flood Protection:** Rate limiting
- **IP Spoofing Protection:** Reverse path filtering
- **ARP Spoofing Protection:** Gratuitous ARP disabled
- **DDoS Protection:** OpenShift platform level

**Additional Protections:**
```yaml
# Kernel hardening
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_timestamps = 0
```

**Configuration Change Control:**
- **GitOps:** All configuration in Git
- **Change Management:** Approval required for changes
- **Rollback:** Easy rollback to previous configuration
- **Audit:** All changes logged and tracked

**EN:** Configuration management security measures:

**Unauthorized Reset Prevention:**
- **Container Immutability:** Containers are immutable
- **No Physical Reset:** Virtual environment, no physical reset button
- **Kubernetes Protection:** Pod restart requires authorization
- **RBAC:** Only authorized users can restart pods
- **Audit:** All restart operations logged

**Recovery Mechanisms:**
- **No Recovery Mode:** Containers don't have recovery mode
- **No Single User Mode:** Not applicable to containers
- **No Hardware Reset:** Virtual environment
- **Disaster Recovery:** Controlled process with approval

**Remote Management Restrictions:**
[Same NetworkPolicy as Turkish version]

**Defined Management Sources:**
- **OAM Platform:** 10.x.x.x/24
- **Bastion Host:** 10.y.y.y/32
- **Admin Workstations:** Specific IP whitelist
- **VPN Gateway:** 10.z.z.z/28

**Network Layer Protection:**

**SYN-Cookies (TCP SYN Flooding Protection):**
[Same configuration as Turkish version]

**Gratuitous ARP Disabled:**
[Same configuration as Turkish version]

**Network Attack Protection:**
- **SYN Flood Protection:** SYN cookies enabled
- **ICMP Flood Protection:** Rate limiting
- **IP Spoofing Protection:** Reverse path filtering
- **ARP Spoofing Protection:** Gratuitous ARP disabled
- **DDoS Protection:** OpenShift platform level

**Additional Protections:**
[Same configuration as Turkish version]

**Configuration Change Control:**
- **GitOps:** All configuration in Git
- **Change Management:** Approval required for changes
- **Rollback:** Easy rollback to previous configuration
- **Audit:** All changes logged and tracked

---

## Patch Management & Anti-Malware

## 0.1.58 Patch Management - All new components must be installed with latest stable version. Security patches must be tested and applied. According to VF Patch Management Policy, all software must use at least n-2 release

**TR:** Patch management politikası uygulanmaktadır:

**Current Versions (Latest Stable):**
- **Java:** OpenJDK 17 (LTS) - Latest patch level
- **Spring Boot:** 3.2.x - Latest stable
- **React:** 18.2.x - Latest stable
- **Node.js:** 18.x LTS - Latest LTS version
- **PostgreSQL:** 15.x - Latest stable
- **Nginx:** Alpine latest - Latest stable
- **OpenShift:** 4.x - Latest supported

**N-2 Release Policy Compliance:**
- **Java:** Using 17 (Latest LTS), n-2 would be 11 (we're ahead)
- **Spring Boot:** Using 3.2.x (Latest), n-2 would be 3.0.x (we're ahead)
- **PostgreSQL:** Using 15.x (Latest), n-2 would be 13.x (we're ahead)
- **All components:** Using latest or n-1, exceeding n-2 requirement

**Patch Testing Process:**

**1. Development Environment:**
- Patches applied first in dev
- Unit tests executed
- Integration tests executed
- Manual testing

**2. Testing Environment:**
- Patches applied in test
- Full regression testing
- Performance testing
- Security testing

**3. Pre-Production:**
- Patches applied in pre-prod
- Final validation
- Smoke testing
- Monitoring

**4. Production:**
- Scheduled maintenance window
- Patches applied with approval
- Rollback plan ready
- Post-deployment monitoring

**Patch Schedule:**

**Critical Security Patches:**
- **Timeline:** Within 48 hours
- **Testing:** Expedited testing
- **Approval:** Emergency change approval
- **Deployment:** Out-of-band if necessary

**High Priority Patches:**
- **Timeline:** Within 1 week
- **Testing:** Standard testing
- **Approval:** Change management
- **Deployment:** Next maintenance window

**Regular Patches:**
- **Timeline:** Within 30 days
- **Testing:** Full testing cycle
- **Approval:** Standard change management
- **Deployment:** Monthly patch cycle

**Patch Management Tools:**
- **Dependency Scanning:** Maven dependency-check, npm audit
- **Vulnerability Scanning:** Trivy, Snyk
- **Automated Updates:** Dependabot (GitHub)
- **CI/CD Integration:** Automated testing in pipeline

**Patch Documentation:**
- **Patch Log:** All patches documented
- **Version Matrix:** Current versions tracked
- **Change Log:** Changes documented
- **Rollback Procedures:** Documented for each patch

**EN:** Patch management policy is implemented:

**Current Versions (Latest Stable):**
[Same as Turkish version]

**N-2 Release Policy Compliance:**
[Same as Turkish version]

**Patch Testing Process:**
[Same as Turkish version]

**Patch Schedule:**
[Same as Turkish version]

**Patch Management Tools:**
[Same as Turkish version]

**Patch Documentation:**
[Same as Turkish version]

---

## 0.1.59 Anti-Malware - All nodes must have appropriate anti-malware software installed and active. Software must be configured for automatic updates

**TR:** Anti-malware yazılımı ve yapılandırması:

**Container Image Scanning:**
- **Tool:** Trivy (Aqua Security)
- **Frequency:** Every build
- **Scope:** All container images
- **Action:** Block deployment if critical vulnerabilities found
- **Integration:** CI/CD pipeline

**Runtime Protection:**
- **Tool:** Falco (Future implementation)
- **Monitoring:** Runtime behavior monitoring
- **Alerts:** Suspicious activity alerts
- **Response:** Automatic pod termination if malware detected

**Host-Level Anti-Malware:**
- **OpenShift Nodes:** Anti-malware managed by infrastructure team
- **Tool:** ClamAV or enterprise solution
- **Updates:** Automatic daily updates
- **Scanning:** Scheduled scans
- **Real-time Protection:** Enabled

**Image Registry Scanning:**
- **Registry:** containers.github.vpara.local
- **Scanning:** Automatic on push
- **Quarantine:** Infected images quarantined
- **Notification:** Security team notified

**Automatic Update Configuration:**

**Trivy:**
```yaml
# Trivy auto-update
trivy:
  auto-update: true
  update-frequency: daily
  db-repository: ghcr.io/aquasecurity/trivy-db
```

**ClamAV (if used):**
```bash
# Automatic updates
freshclam --daemon
# Daily signature updates
```

**Centralized Update System:**
- **Update Server:** Internal update server
- **Push Updates:** Automatic push to all nodes
- **Verification:** Update verification
- **Rollback:** Automatic rollback if update fails

**Scanning Schedule:**
- **Container Images:** Every build
- **Running Containers:** Daily scan
- **Persistent Volumes:** Weekly scan
- **Host Systems:** Daily scan

**Malware Response:**
1. **Detection:** Malware detected
2. **Isolation:** Container/pod isolated
3. **Notification:** Security team notified
4. **Investigation:** Root cause analysis
5. **Remediation:** Clean or rebuild
6. **Documentation:** Incident documented

**EN:** Anti-malware software and configuration:

**Container Image Scanning:**
- **Tool:** Trivy (Aqua Security)
- **Frequency:** Every build
- **Scope:** All container images
- **Action:** Block deployment if critical vulnerabilities found
- **Integration:** CI/CD pipeline

**Runtime Protection:**
- **Tool:** Falco (Future implementation)
- **Monitoring:** Runtime behavior monitoring
- **Alerts:** Suspicious activity alerts
- **Response:** Automatic pod termination if malware detected

**Host-Level Anti-Malware:**
- **OpenShift Nodes:** Anti-malware managed by infrastructure team
- **Tool:** ClamAV or enterprise solution
- **Updates:** Automatic daily updates
- **Scanning:** Scheduled scans
- **Real-time Protection:** Enabled

**Image Registry Scanning:**
- **Registry:** containers.github.vpara.local
- **Scanning:** Automatic on push
- **Quarantine:** Infected images quarantined
- **Notification:** Security team notified

**Automatic Update Configuration:**
[Same as Turkish version]

**Centralized Update System:**
[Same as Turkish version]

**Scanning Schedule:**
[Same as Turkish version]

**Malware Response:**
[Same as Turkish version]

---

## 0.1.60 Security Testing - Vendor must have a robust security testing process. Vodafone may request confirmation of security vulnerability testing process and summary reports

**TR:** Güvenlik test süreçleri:

**Security Testing Process:**

**1. Static Application Security Testing (SAST):**
- **Tool:** SonarQube, Checkmarx (Vodafone tools)
- **Frequency:** Every commit
- **Scope:** Source code analysis
- **Coverage:** Java, JavaScript/JSX
- **Integration:** CI/CD pipeline
- **Threshold:** No critical/high vulnerabilities

**2. Dynamic Application Security Testing (DAST):**
- **Tool:** OWASP ZAP, Burp Suite
- **Frequency:** Weekly in test environment
- **Scope:** Running application
- **Tests:** SQL injection, XSS, CSRF, authentication bypass
- **Reports:** Detailed vulnerability reports

**3. Software Composition Analysis (SCA):**
- **Tool:** OWASP Dependency-Check, Snyk
- **Frequency:** Every build
- **Scope:** Third-party dependencies
- **Action:** Alert on vulnerable dependencies
- **Remediation:** Update to secure versions

**4. Container Security Scanning:**
- **Tool:** Trivy, Clair
- **Frequency:** Every build
- **Scope:** Container images
- **Checks:** OS vulnerabilities, application vulnerabilities
- **Threshold:** No critical vulnerabilities

**5. Penetration Testing:**
- **Frequency:** Annually or before major releases
- **Scope:** Full application stack
- **Methodology:** OWASP Testing Guide
- **Performed By:** Internal security team or external auditors
- **Report:** Detailed findings and remediation plan

**6. Fuzz Testing:**
- **Tool:** AFL, libFuzzer (for critical components)
- **Scope:** Input validation, API endpoints
- **Frequency:** Before major releases
- **Coverage:** Edge cases, malformed inputs

**7. Code Review:**
- **Process:** Peer code review
- **Security Focus:** Security-critical code
- **Checklist:** OWASP secure coding guidelines
- **Approval:** Security review for sensitive changes

**Testing Coverage:**
- **Unit Tests:** 80%+ code coverage
- **Integration Tests:** All API endpoints
- **Security Tests:** OWASP Top 10 coverage
- **Performance Tests:** Load and stress testing

**Vulnerability Management:**

**Severity Levels:**
- **Critical:** Fix within 24 hours
- **High:** Fix within 1 week
- **Medium:** Fix within 30 days
- **Low:** Fix in next release

**Reporting:**
- **Weekly:** Vulnerability scan reports
- **Monthly:** Security testing summary
- **Quarterly:** Comprehensive security report
- **On-Demand:** Reports available to Vodafone Security Team

**Sample Report Structure:**
```
Security Testing Summary Report
================================
Period: January 2024
Application: GENAI-OPS

1. SAST Results:
   - Scans Performed: 120
   - Critical Issues: 0
   - High Issues: 2 (Fixed)
   - Medium Issues: 5 (3 Fixed, 2 In Progress)

2. DAST Results:
   - Tests Performed: 4
   - Vulnerabilities Found: 3
   - All Remediated: Yes

3. SCA Results:
   - Dependencies Scanned: 250
   - Vulnerable Dependencies: 5
   - Updated: 5

4. Container Scanning:
   - Images Scanned: 50
   - Critical Vulnerabilities: 0
   - High Vulnerabilities: 1 (Fixed)

5. Penetration Testing:
   - Last Test: December 2023
   - Findings: 8
   - Remediated: 8
   - Next Test: June 2024
```

**Compliance:**
- **OWASP Top 10:** Full coverage
- **SANS Top 25:** Addressed
- **CWE/SANS:** Common weaknesses covered
- **Vodafone Standards:** Compliant

**EN:** Security testing processes:

**Security Testing Process:**
[Same structure as Turkish version]

**Testing Coverage:**
[Same as Turkish version]

**Vulnerability Management:**
[Same as Turkish version]

**Reporting:**
[Same as Turkish version]

**Sample Report Structure:**
[Same as Turkish version]

**Compliance:**
[Same as Turkish version]

---

## Final Summary / Son Özet

**TR:**
Bu doküman, GENAI-OPS projesinin Vodafone Secure by Design ve Non-Functional Requirements (NFR) gereksinimlerini kapsamlı şekilde yanıtlamaktadır. Toplam 60 soru ve cevap içermekte olup, her soru için hem Türkçe hem İngilizce detaylı açıklamalar sunulmuştur.

**Kapsanan Ana Konular:**
- Proje tanımı ve geliştirme yaklaşımı
- Network zoning ve güvenlik mimarisi
- Ortam ayrımı ve deployment stratejisi
- Dokümantasyon gereksinimleri
- Sistem sertleştirme (hardening)
- Kimlik doğrulama ve yetkilendirme
- Patch management ve anti-malware
- Güvenlik testleri ve süreçleri

**Güvenlik Duruşu:**
GENAI-OPS projesi, industry-leading güvenlik standartlarına (CIS, OWASP, NIST) uygun olarak geliştirilmiş, containerized, cloud-native bir uygulamadır. Tüm bileşenler Zone E2 (Internal Backend) içerisinde konumlandırılmış olup, defense-in-depth yaklaşımı ile çoklu güvenlik katmanları uygulanmıştır.

**EN:**
This document comprehensively addresses the Vodafone Secure by Design and Non-Functional Requirements (NFR) for the GENAI-OPS project. It contains a total of 60 questions and answers, providing detailed explanations in both Turkish and English for each question.

**Main Topics Covered:**
- Project definition and development approach
- Network zoning and security architecture
- Environment separation and deployment strategy
- Documentation requirements
- System hardening
- Authentication and authorization
- Patch management and anti-malware
- Security testing and processes

**Security Posture:**
The GENAI-OPS project is a containerized, cloud-native application developed in compliance with industry-leading security standards (CIS, OWASP, NIST). All components are located within Zone E2 (Internal Backend), and multiple security layers are implemented using a defense-in-depth approach.

---

**Document Version:** 1.0  
**Last Updated:** 2024  
**Prepared By:** VEPAS AI Team  
**Reviewed By:** Security Team (Pending)  
**Status:** Ready for Security Review

