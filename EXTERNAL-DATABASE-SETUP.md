# External PostgreSQL Database Setup

Bu döküman, GENAI-OPS uygulamasının dış PostgreSQL veritabanına nasıl bağlanacağını açıklar.

## 📋 Genel Bakış

GENAI-OPS, OpenShift içinde PostgreSQL çalıştırmak yerine **dış (external) PostgreSQL** veritabanı kullanır. Bu yaklaşım:

- ✅ Mevcut veritabanı altyapısını kullanır
- ✅ Backup/restore işlemlerini kolaylaştırır
- ✅ Yüksek erişilebilirlik (HA) sağlar
- ✅ Merkezi veritabanı yönetimi

---

## 🔧 Gereksinimler

### 1. PostgreSQL Veritabanı

**Minimum Versiyon:** PostgreSQL 14+

**Gerekli Bilgiler:**
- Database Host/IP
- Port (varsayılan: 5432)
- Database Name
- Username
- Password

### 2. Network Erişimi

OpenShift pod'larından PostgreSQL sunucusuna erişim olmalı:
- Firewall kuralları
- Network policy
- Security group

### 3. Database Oluşturma

```sql
-- PostgreSQL'e bağlan
psql -h your-postgres-host -U postgres

-- Database oluştur
CREATE DATABASE genaiops;

-- User oluştur
CREATE USER genaiops_user WITH PASSWORD 'your-secure-password';

-- Yetkileri ver
GRANT ALL PRIVILEGES ON DATABASE genaiops TO genaiops_user;

-- Schema yetkileri (PostgreSQL 15+)
\c genaiops
GRANT ALL ON SCHEMA public TO genaiops_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO genaiops_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO genaiops_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO genaiops_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO genaiops_user;
```

---

## ⚙️ Yapılandırma

### 1. ConfigMap Güncelleme

`deployment/configmap.yaml` dosyasını düzenleyin:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: genai-ops-config
  namespace: genai-ops
data:
  # External PostgreSQL Configuration
  DB_URL: "jdbc:postgresql://your-postgres-host.vpara.local:5432/genaiops"
  DB_USERNAME: "genaiops_user"
```

**Örnek URL Formatları:**

```yaml
# Hostname ile
DB_URL: "jdbc:postgresql://postgres.vpara.local:5432/genaiops"

# IP adresi ile
DB_URL: "jdbc:postgresql://172.31.234.50:5432/genaiops"

# SSL ile (önerilen)
DB_URL: "jdbc:postgresql://postgres.vpara.local:5432/genaiops?ssl=true&sslmode=require"

# Custom port ile
DB_URL: "jdbc:postgresql://postgres.vpara.local:5433/genaiops"
```

### 2. Secret Güncelleme

`deployment/secret.yaml` dosyasını düzenleyin:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: genai-ops-secret
type: Opaque
stringData:
  # Database Password (External PostgreSQL)
  DB_PASSWORD: "your-secure-database-password"
```

**Veya OpenShift'te direkt güncelle:**

```bash
oc edit secret genai-ops-secret -n genai-ops
```

---

## 🚀 Deployment

### 1. ConfigMap Apply

```bash
oc apply -f deployment/configmap.yaml
```

### 2. Secret Apply (İlk Kez)

```bash
oc apply -f deployment/secret.yaml
```

**Veya Secret Güncelleme:**

```bash
# Base64 encode password
echo -n "your-password" | base64

# Secret'ı güncelle
oc edit secret genai-ops-secret -n genai-ops
# DB_PASSWORD değerini base64 encoded password ile değiştir
```

### 3. Backend Deployment

```bash
oc apply -f deployment/backend-deployment.yaml
oc rollout restart deployment/genai-ops-backend
```

---

## ✅ Bağlantı Testi

### 1. Backend Pod'undan Test

```bash
# Backend pod'una bağlan
POD_NAME=$(oc get pods -l component=backend -o jsonpath='{.items[0].metadata.name}')
oc exec -it $POD_NAME -- bash

# PostgreSQL bağlantısını test et (psql varsa)
psql -h your-postgres-host -U genaiops_user -d genaiops

# Veya Java ile test (backend içinde)
# Backend başladığında otomatik bağlanır
```

### 2. Backend Loglarını Kontrol Et

```bash
oc logs -f deployment/genai-ops-backend | grep -i "database\|postgres\|hikari"
```

**Başarılı Bağlantı Logları:**

```
HikariPool-1 - Starting...
HikariPool-1 - Start completed.
Initialized JPA EntityManagerFactory for persistence unit 'default'
```

**Hata Logları:**

```
❌ Connection refused: your-postgres-host:5432
❌ FATAL: password authentication failed for user "genaiops_user"
❌ FATAL: database "genaiops" does not exist
```

---

## 🔐 SSL/TLS Bağlantısı (Önerilen)

### PostgreSQL SSL Yapılandırması

```yaml
# ConfigMap
DB_URL: "jdbc:postgresql://postgres.vpara.local:5432/genaiops?ssl=true&sslmode=require"
```

**SSL Mode Seçenekleri:**

- `disable`: SSL kullanma
- `allow`: SSL tercih et ama zorunlu değil
- `prefer`: SSL tercih et (varsayılan)
- `require`: SSL zorunlu
- `verify-ca`: SSL + CA doğrulama
- `verify-full`: SSL + CA + hostname doğrulama

### CA Certificate (Gerekirse)

```bash
# CA certificate ConfigMap oluştur
oc create configmap postgres-ca-cert \
  --from-file=ca.crt=/path/to/postgres-ca.crt \
  -n genai-ops

# Backend deployment'a mount et
# deployment/backend-deployment.yaml
volumeMounts:
  - name: postgres-ca
    mountPath: /etc/ssl/certs/postgres
    readOnly: true

volumes:
  - name: postgres-ca
    configMap:
      name: postgres-ca-cert
```

---

## 🔧 Troubleshooting

### 1. Connection Refused

**Hata:** `Connection refused: your-postgres-host:5432`

**Çözüm:**
```bash
# Network erişimini test et
oc exec deployment/genai-ops-backend -- curl -v telnet://your-postgres-host:5432

# Firewall kurallarını kontrol et
# PostgreSQL'in listen_addresses ayarını kontrol et
```

### 2. Authentication Failed

**Hata:** `password authentication failed for user "genaiops_user"`

**Çözüm:**
```bash
# Secret'taki şifreyi kontrol et
oc get secret genai-ops-secret -o jsonpath='{.data.DB_PASSWORD}' | base64 -d

# PostgreSQL'de user'ı kontrol et
psql -h your-postgres-host -U postgres
SELECT * FROM pg_user WHERE usename = 'genaiops_user';

# pg_hba.conf'u kontrol et (PostgreSQL sunucusunda)
```

### 3. Database Does Not Exist

**Hata:** `database "genaiops" does not exist`

**Çözüm:**
```bash
# Database'i oluştur
psql -h your-postgres-host -U postgres
CREATE DATABASE genaiops;
```

### 4. Permission Denied

**Hata:** `permission denied for schema public`

**Çözüm:**
```sql
-- PostgreSQL 15+ için
\c genaiops
GRANT ALL ON SCHEMA public TO genaiops_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO genaiops_user;
```

---

## 📊 Database Schema

Backend ilk başlatıldığında otomatik olarak tabloları oluşturur (Hibernate DDL auto).

**Oluşturulacak Tablolar:**
- `audit_logs` - Audit log kayıtları
- `chat_sessions` - Chat oturumları
- `chat_messages` - Chat mesajları
- `feedback` - Kullanıcı feedback'leri

**application.yml:**
```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: update  # Tabloları otomatik oluştur/güncelle
```

---

## 🔄 Migration (Opsiyonel)

Production'da Flyway veya Liquibase kullanılabilir:

### Flyway Örneği

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
```

```yaml
# application.yml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
```

---

## 📝 Checklist

Dış PostgreSQL kullanımı için:

- [ ] PostgreSQL veritabanı oluşturuldu
- [ ] User oluşturuldu ve yetkiler verildi
- [ ] Network erişimi test edildi
- [ ] ConfigMap DB_URL güncellendi
- [ ] Secret DB_PASSWORD güncellendi
- [ ] SSL yapılandırması yapıldı (önerilen)
- [ ] Backend deployment yapıldı
- [ ] Bağlantı logları kontrol edildi
- [ ] Tablolar oluşturuldu

---

## 🎯 Özet

### Yapılandırma

```yaml
# ConfigMap
DB_URL: "jdbc:postgresql://your-postgres-host:5432/genaiops"
DB_USERNAME: "genaiops_user"

# Secret
DB_PASSWORD: "your-secure-password"
```

### Deployment

```bash
# 1. ConfigMap ve Secret güncelle
oc apply -f deployment/configmap.yaml
oc apply -f deployment/secret.yaml

# 2. Backend'i deploy et
oc apply -f deployment/backend-deployment.yaml

# 3. Logları kontrol et
oc logs -f deployment/genai-ops-backend
```

**Dış PostgreSQL başarıyla yapılandırıldı! 🗄️**
