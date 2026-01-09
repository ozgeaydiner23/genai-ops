# GENAI-OPS Database Scripts

Bu klasör GENAI-OPS uygulaması için PostgreSQL database scriptlerini içerir.

## 📁 Dosyalar

| Dosya | Açıklama | Ne Zaman Kullanılır |
|-------|----------|---------------------|
| `schema.sql` | Tam database schema (Phase 1.2) | Production deployment |
| `phase1-minimal.sql` | Minimal setup (Phase 1.1) | İlk kurulum testi |
| `rollback.sql` | Tüm tabloları sil | Temizlik/Rollback |

---

## 🚀 Kurulum

### Phase 1.1 (Şu Anki Durum)

**Not:** Phase 1.1'de database tabloları **opsiyonel**dir. Backend:
- Mock authentication kullanır (LDAP + admin fallback)
- Chat mesajlarını persist etmez
- Feedback'i console'a loglar

**Sadece bağlantı testi için:**

```bash
# PostgreSQL'e bağlan
psql -h your-postgres-host -U postgres

# Database ve user oluştur
CREATE DATABASE genaiops;
CREATE USER genaiops_user WITH PASSWORD 'your-secure-password';
GRANT ALL PRIVILEGES ON DATABASE genaiops TO genaiops_user;

# genaiops database'ine geç
\c genaiops

# PostgreSQL 15+ için schema permissions
GRANT ALL ON SCHEMA public TO genaiops_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO genaiops_user;

# Bağlantıyı test et
\q
psql -h your-postgres-host -U genaiops_user -d genaiops

# Minimal test script çalıştır (opsiyonel)
\i phase1-minimal.sql
```

### Phase 1.2 (Audit Logging)

**Tam schema kurulumu:**

```bash
# PostgreSQL'e bağlan
psql -h your-postgres-host -U genaiops_user -d genaiops

# Schema'yı çalıştır
\i schema.sql

# Tabloları kontrol et
\dt

# View'ları kontrol et
\dv

# Başarılı!
```

---

## 🔧 Backend Yapılandırması

### Hibernate Auto DDL (Önerilen)

Backend `application.yml` dosyasında:

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: update  # Tabloları otomatik oluştur/güncelle
```

**Seçenekler:**
- `none`: Hiçbir şey yapma
- `validate`: Sadece doğrula
- `update`: Tabloları oluştur/güncelle (önerilen)
- `create`: Her başlatmada yeniden oluştur (DEV only)
- `create-drop`: Başlatmada oluştur, kapanışta sil (TEST only)

**Production için:** `update` veya `validate` kullanın.

### Manuel Schema Yönetimi

Eğer Hibernate DDL kullanmak istemiyorsanız:

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: none  # Manuel schema yönetimi
```

Sonra `schema.sql` scriptini manuel çalıştırın.

---

## 📊 Tablo Yapısı

### Phase 1.1 (Şu Anki)
- ❌ Tablo yok (opsiyonel)
- Backend in-memory çalışıyor

### Phase 1.2 (Planlanan)

```
users
├── chat_sessions
│   └── chat_messages
│       └── feedback
└── audit_logs
```

**Tablolar:**
- `users` - LDAP authenticated users
- `chat_sessions` - Chat oturumları
- `chat_messages` - Mesajlar (user + AI)
- `feedback` - Like/dislike feedback
- `audit_logs` - Comprehensive audit trail

**Views:**
- `user_activity_summary` - Kullanıcı aktivite özeti
- `daily_usage_stats` - Günlük kullanım istatistikleri
- `feedback_stats` - Feedback istatistikleri

---

## 🧪 Test

### Bağlantı Testi

```bash
# Backend pod'undan test
oc exec deployment/genai-ops-backend -- bash -c "
  echo 'SELECT version();' | psql -h your-postgres-host -U genaiops_user -d genaiops
"
```

### Tablo Kontrolü

```sql
-- Tabloları listele
SELECT tablename FROM pg_tables WHERE schemaname = 'public';

-- Tablo detayları
\d+ users
\d+ chat_messages
\d+ audit_logs

-- Kayıt sayıları
SELECT 
    'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'chat_sessions', COUNT(*) FROM chat_sessions
UNION ALL
SELECT 'chat_messages', COUNT(*) FROM chat_messages
UNION ALL
SELECT 'feedback', COUNT(*) FROM feedback
UNION ALL
SELECT 'audit_logs', COUNT(*) FROM audit_logs;
```

---

## 🔄 Migration (Gelecek)

Phase 2'de Flyway veya Liquibase kullanılabilir:

### Flyway Örneği

```
database/
└── migrations/
    ├── V1__initial_schema.sql
    ├── V2__add_audit_logs.sql
    └── V3__add_indexes.sql
```

---

## 🗑️ Rollback

**UYARI:** Tüm verileri siler!

```bash
# Backup al (önemli!)
pg_dump -h your-postgres-host -U genaiops_user genaiops > backup.sql

# Rollback çalıştır
psql -h your-postgres-host -U genaiops_user -d genaiops -f rollback.sql

# Restore (gerekirse)
psql -h your-postgres-host -U genaiops_user -d genaiops < backup.sql
```

---

## 📝 Notlar

### Phase 1.1 (Şu Anki Durum)
- ✅ Database bağlantısı gerekli (health check için)
- ❌ Tablo yapısı opsiyonel
- ✅ Backend otomatik tablo oluşturabilir (`ddl-auto: update`)

### Phase 1.2 (Gelecek)
- ✅ Tam schema gerekli
- ✅ Audit logging aktif
- ✅ Feedback persistence
- ✅ Chat history

### Güvenlik
- ✅ Şifreleri asla kod içinde tutma
- ✅ Secret kullan (OpenShift)
- ✅ SSL/TLS bağlantısı kullan
- ✅ Minimum privilege principle

---

## 🆘 Troubleshooting

### Permission Denied

```sql
-- PostgreSQL 15+ için
GRANT ALL ON SCHEMA public TO genaiops_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO genaiops_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO genaiops_user;
```

### Connection Refused

```bash
# Network erişimini test et
oc exec deployment/genai-ops-backend -- curl -v telnet://your-postgres-host:5432

# PostgreSQL listen_addresses kontrol et (sunucuda)
# postgresql.conf: listen_addresses = '*'
```

### Tables Not Created

```yaml
# application.yml
spring:
  jpa:
    hibernate:
      ddl-auto: update  # 'none' veya 'validate' değil!
```

---

**Database hazır! 🗄️**
