# Database Mimari Dokümantasyonu

## Genel Bakış

GENAI-OPS uygulaması PostgreSQL 15+ veritabanı kullanır. Phase 1.1'de minimal kullanım, Phase 1.2'de tam audit logging ve persistence planlanmıştır.

**Database Bilgileri:**
- **DBMS:** PostgreSQL 15-alpine
- **Database Name:** genaiops
- **Default User:** genaiops_user
- **Port:** 5432

## Teknoloji Stack

### Database Management System
- **PostgreSQL 15-alpine** - Lightweight container image
- **pg_isready** - Health check utility

### ORM & Migration
- **Hibernate/JPA** - Object-Relational Mapping
- **Spring Data JPA** - Data access abstraction
- **Hibernate DDL Auto** - Schema management

### Planned (Phase 2)
- **Flyway** veya **Liquibase** - Database migration tool

## Deployment Stratejileri

### Phase 1.1 (Şu Anki Durum)

**Minimal Kullanım:**
- Database bağlantısı gerekli (health check)
- Tablo yapısı opsiyonel
- Backend in-memory çalışıyor
- Hibernate auto-DDL ile tablo oluşturma

**Konfigürasyon:**
```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: update  # Otomatik tablo oluştur/güncelle
```

### Phase 1.2 (Planlanan)

**Tam Persistence:**
- Audit logging
- Chat history
- Feedback storage
- User tracking

## Database Schema

### Entity Relationship Diagram

```
┌─────────────────┐
│     users       │
│─────────────────│
│ id (PK)         │
│ username (UK)   │
│ display_name    │
│ email           │
│ ldap_dn         │
│ groups[]        │
│ created_at      │
│ updated_at      │
│ last_login_at   │
└─────────────────┘
         │
         │ 1:N
         ↓
┌─────────────────┐
│ chat_sessions   │
│─────────────────│
│ id (PK)         │
│ user_id (FK)    │
│ session_name    │
│ created_at      │
│ updated_at      │
│ ended_at        │
│ is_active       │
└─────────────────┘
         │
         │ 1:N
         ↓
┌─────────────────┐
│ chat_messages   │
│─────────────────│
│ id (PK)         │
│ session_id (FK) │
│ user_id (FK)    │
│ message_type    │
│ content         │
│ created_at      │
│ llm_model       │
│ llm_response_   │
│   time_ms       │
│ tokens_used     │
│ error_message   │
└─────────────────┘
         │
         │ 1:N
         ↓
┌─────────────────┐
│    feedback     │
│─────────────────│
│ id (PK)         │
│ message_id (FK) │
│ user_id (FK)    │
│ feedback_type   │
│ comment         │
│ created_at      │
│ updated_at      │
└─────────────────┘

┌─────────────────┐
│  audit_logs     │
│─────────────────│
│ id (PK)         │
│ user_id (FK)    │
│ username        │
│ action          │
│ resource_type   │
│ resource_id     │
│ details (JSON)  │
│ ip_address      │
│ user_agent      │
│ status          │
│ error_message   │
│ created_at      │
└─────────────────┘
```

### Tablo Detayları

#### 1. users
**Amaç:** LDAP authenticated kullanıcıları takip etme

**Kolonlar:**
- `id` UUID PRIMARY KEY - Unique identifier
- `username` VARCHAR(255) UNIQUE NOT NULL - LDAP username
- `display_name` VARCHAR(255) - Görünen ad
- `email` VARCHAR(255) - Email adresi
- `ldap_dn` TEXT - LDAP Distinguished Name
- `groups` TEXT[] - LDAP grup listesi (array)
- `created_at` TIMESTAMP WITH TIME ZONE - Kayıt tarihi
- `updated_at` TIMESTAMP WITH TIME ZONE - Güncelleme tarihi
- `last_login_at` TIMESTAMP WITH TIME ZONE - Son giriş

**Indexes:**
- `idx_users_username` ON username
- `idx_users_email` ON email

**Triggers:**
- `update_users_updated_at` - updated_at otomatik güncelleme

#### 2. chat_sessions
**Amaç:** Chat oturumlarını organize etme

**Kolonlar:**
- `id` UUID PRIMARY KEY
- `user_id` UUID NOT NULL FK → users(id)
- `session_name` VARCHAR(255) - Oturum adı
- `created_at` TIMESTAMP WITH TIME ZONE
- `updated_at` TIMESTAMP WITH TIME ZONE
- `ended_at` TIMESTAMP WITH TIME ZONE - Oturum bitiş
- `is_active` BOOLEAN DEFAULT true

**Indexes:**
- `idx_chat_sessions_user_id` ON user_id
- `idx_chat_sessions_created_at` ON created_at DESC
- `idx_chat_sessions_is_active` ON is_active

**Cascade:**
- ON DELETE CASCADE (user silinince sessions silinir)

#### 3. chat_messages
**Amaç:** Kullanıcı ve AI mesajlarını saklama

**Kolonlar:**
- `id` UUID PRIMARY KEY
- `session_id` UUID NOT NULL FK → chat_sessions(id)
- `user_id` UUID NOT NULL FK → users(id)
- `message_type` VARCHAR(50) NOT NULL - 'USER' | 'AI'
- `content` TEXT NOT NULL - Mesaj içeriği
- `created_at` TIMESTAMP WITH TIME ZONE
- `llm_model` VARCHAR(100) - Model adı (örn: cwyd-llm-general-prod)
- `llm_response_time_ms` INTEGER - Response süresi (ms)
- `tokens_used` INTEGER - Kullanılan token sayısı
- `error_message` TEXT - Hata mesajı (varsa)

**Indexes:**
- `idx_chat_messages_session_id` ON session_id
- `idx_chat_messages_user_id` ON user_id
- `idx_chat_messages_created_at` ON created_at DESC
- `idx_chat_messages_type` ON message_type

**Cascade:**
- ON DELETE CASCADE (session silinince messages silinir)

#### 4. feedback
**Amaç:** AI yanıtlarına kullanıcı feedback'i

**Kolonlar:**
- `id` UUID PRIMARY KEY
- `message_id` UUID NOT NULL FK → chat_messages(id)
- `user_id` UUID NOT NULL FK → users(id)
- `feedback_type` VARCHAR(20) NOT NULL - 'LIKE' | 'DISLIKE'
- `comment` TEXT - Opsiyonel yorum
- `created_at` TIMESTAMP WITH TIME ZONE
- `updated_at` TIMESTAMP WITH TIME ZONE

**Indexes:**
- `idx_feedback_message_id` ON message_id
- `idx_feedback_user_id` ON user_id
- `idx_feedback_type` ON feedback_type
- `idx_feedback_created_at` ON created_at DESC

**Cascade:**
- ON DELETE CASCADE (message silinince feedback silinir)

**Triggers:**
- `update_feedback_updated_at` - updated_at otomatik güncelleme

#### 5. audit_logs
**Amaç:** Comprehensive audit trail

**Kolonlar:**
- `id` UUID PRIMARY KEY
- `user_id` UUID FK → users(id) - NULL olabilir
- `username` VARCHAR(255) NOT NULL - Username (user silinse bile)
- `action` VARCHAR(100) NOT NULL - 'LOGIN', 'LOGOUT', 'SEND_MESSAGE', etc.
- `resource_type` VARCHAR(100) - 'SESSION', 'MESSAGE', 'FEEDBACK'
- `resource_id` UUID - İlgili resource ID
- `details` JSONB - Ek detaylar (JSON format)
- `ip_address` INET - Client IP
- `user_agent` TEXT - Browser/client info
- `status` VARCHAR(50) DEFAULT 'SUCCESS' - 'SUCCESS', 'FAILURE', 'ERROR'
- `error_message` TEXT - Hata detayı
- `created_at` TIMESTAMP WITH TIME ZONE

**Indexes:**
- `idx_audit_logs_user_id` ON user_id
- `idx_audit_logs_username` ON username
- `idx_audit_logs_action` ON action
- `idx_audit_logs_created_at` ON created_at DESC
- `idx_audit_logs_status` ON status
- `idx_audit_logs_details` ON details USING gin - JSON indexing

**Cascade:**
- ON DELETE SET NULL (user silinince user_id NULL olur, log kalır)

### Views (Analytics)

#### user_activity_summary
**Amaç:** Kullanıcı aktivite özeti

**Kolonlar:**
- id, username, display_name
- total_sessions - Toplam oturum sayısı
- total_messages - Toplam mesaj sayısı
- total_feedback - Toplam feedback sayısı
- last_login - Son giriş tarihi
- first_session - İlk oturum tarihi
- last_session - Son oturum tarihi

**Query:**
```sql
SELECT * FROM user_activity_summary 
WHERE username = 'john.doe'
ORDER BY last_login DESC;
```

#### daily_usage_stats
**Amaç:** Günlük kullanım istatistikleri

**Kolonlar:**
- date - Tarih
- unique_users - Benzersiz kullanıcı sayısı
- total_sessions - Toplam oturum
- total_messages - Toplam mesaj
- avg_response_time_ms - Ortalama LLM response süresi

**Query:**
```sql
SELECT * FROM daily_usage_stats 
WHERE date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY date DESC;
```

#### feedback_stats
**Amaç:** Feedback istatistikleri

**Kolonlar:**
- date - Tarih
- feedback_type - 'LIKE' | 'DISLIKE'
- count - Feedback sayısı
- unique_users - Benzersiz kullanıcı sayısı

**Query:**
```sql
SELECT 
    date,
    SUM(CASE WHEN feedback_type = 'LIKE' THEN count ELSE 0 END) as likes,
    SUM(CASE WHEN feedback_type = 'DISLIKE' THEN count ELSE 0 END) as dislikes
FROM feedback_stats
WHERE date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY date
ORDER BY date DESC;
```

### Functions & Triggers

#### update_updated_at_column()
**Amaç:** updated_at kolonunu otomatik güncelleme

**Trigger'lar:**
- users tablosu
- chat_sessions tablosu
- feedback tablosu

**Kullanım:**
```sql
CREATE TRIGGER update_users_updated_at 
BEFORE UPDATE ON users
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();
```

## Data Types & Constraints

### UUID Generation
```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid()
```

**Avantajlar:**
- Globally unique
- Distributed system friendly
- Security (non-sequential)

### Timestamp with Time Zone
```sql
created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
```

**Avantajlar:**
- Timezone aware
- UTC storage
- Automatic conversion

### Array Type
```sql
groups TEXT[]
```

**Kullanım:**
```sql
-- Insert
INSERT INTO users (username, groups) 
VALUES ('john', ARRAY['admin', 'vepas_genaiops_edit']);

-- Query
SELECT * FROM users 
WHERE 'admin' = ANY(groups);
```

### JSONB Type
```sql
details JSONB
```

**Kullanım:**
```sql
-- Insert
INSERT INTO audit_logs (action, details) 
VALUES ('LOGIN', '{"ip": "192.168.1.1", "browser": "Chrome"}');

-- Query
SELECT * FROM audit_logs 
WHERE details->>'ip' = '192.168.1.1';

-- Index
CREATE INDEX idx_audit_logs_details ON audit_logs USING gin(details);
```

### INET Type
```sql
ip_address INET
```

**Kullanım:**
```sql
-- Insert
INSERT INTO audit_logs (ip_address) 
VALUES ('192.168.1.1');

-- Query
SELECT * FROM audit_logs 
WHERE ip_address << '192.168.0.0/16';
```

## Indexing Strategy

### Primary Keys
- Tüm tablolarda UUID PRIMARY KEY
- Otomatik index oluşturulur

### Foreign Keys
- Tüm FK'lar index'lenir
- JOIN performance için kritik

### Timestamp Indexes
- created_at DESC - Son kayıtlar için
- Pagination ve sorting için

### Composite Indexes (Gelecek)
```sql
CREATE INDEX idx_messages_session_created 
ON chat_messages(session_id, created_at DESC);
```

### GIN Indexes
- JSONB kolonlar için
- Array kolonlar için (gelecek)

## Performance Optimization

### Connection Pooling

**HikariCP (Spring Boot Default):**
```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 10
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

### Query Optimization

**Prepared Statements:**
- JPA/Hibernate otomatik kullanır
- SQL injection koruması
- Query plan caching

**Pagination:**
```java
Pageable pageable = PageRequest.of(0, 20, Sort.by("createdAt").descending());
Page<ChatMessage> messages = messageRepository.findAll(pageable);
```

### Partitioning (Gelecek)

**audit_logs için:**
```sql
-- Aylık partitioning
CREATE TABLE audit_logs_2024_01 PARTITION OF audit_logs
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
```

## Backup & Recovery

### Backup Stratejisi

**pg_dump:**
```bash
# Full backup
pg_dump -h postgres-host -U genaiops_user genaiops > backup.sql

# Schema only
pg_dump -h postgres-host -U genaiops_user --schema-only genaiops > schema.sql

# Data only
pg_dump -h postgres-host -U genaiops_user --data-only genaiops > data.sql

# Compressed
pg_dump -h postgres-host -U genaiops_user -Fc genaiops > backup.dump
```

**Automated Backup (Kubernetes CronJob):**
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: postgres-backup
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: postgres:15-alpine
            command:
            - /bin/sh
            - -c
            - pg_dump -h postgres-service -U genaiops genaiops | gzip > /backup/backup-$(date +%Y%m%d).sql.gz
```

### Recovery

**Full Restore:**
```bash
# From SQL file
psql -h postgres-host -U genaiops_user genaiops < backup.sql

# From compressed dump
pg_restore -h postgres-host -U genaiops_user -d genaiops backup.dump
```

**Point-in-Time Recovery (PITR):**
- WAL archiving gerekli
- Production için önerilir

## Security

### Authentication

**PostgreSQL User:**
```sql
CREATE USER genaiops_user WITH PASSWORD 'secure-password';
GRANT ALL PRIVILEGES ON DATABASE genaiops TO genaiops_user;
```

**Connection:**
```yaml
spring:
  datasource:
    url: jdbc:postgresql://host:5432/genaiops?ssl=true&sslmode=require
    username: genaiops_user
    password: ${DB_PASSWORD}  # From Secret
```

### Authorization

**Principle of Least Privilege:**
```sql
-- Application user - only necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO genaiops_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO genaiops_user;

-- Read-only user (analytics)
CREATE USER genaiops_readonly WITH PASSWORD 'readonly-password';
GRANT CONNECT ON DATABASE genaiops TO genaiops_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO genaiops_readonly;
```

### Encryption

**At Rest:**
- PostgreSQL transparent data encryption (TDE)
- Disk-level encryption (LUKS)

**In Transit:**
- SSL/TLS connections
- Certificate validation

**Sensitive Data:**
```sql
-- Password hashing (application level)
-- PII encryption (application level)
```

### Audit

**pg_audit Extension:**
```sql
CREATE EXTENSION pg_audit;

-- Audit all DDL and DML
ALTER SYSTEM SET pgaudit.log = 'ddl, write';
```

## Monitoring & Maintenance

### Health Checks

**Liveness Probe:**
```yaml
livenessProbe:
  exec:
    command:
    - pg_isready
    - -U
    - genaiops
  initialDelaySeconds: 30
  periodSeconds: 10
```

**Readiness Probe:**
```yaml
readinessProbe:
  exec:
    command:
    - pg_isready
    - -U
    - genaiops
  initialDelaySeconds: 10
  periodSeconds: 5
```

### Metrics

**Key Metrics:**
- Connection count
- Query performance
- Cache hit ratio
- Disk usage
- Replication lag (if applicable)

**pg_stat_statements:**
```sql
CREATE EXTENSION pg_stat_statements;

-- Top 10 slowest queries
SELECT 
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    max_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;
```

### Vacuum & Analyze

**Auto Vacuum:**
```sql
-- Check autovacuum settings
SHOW autovacuum;

-- Manual vacuum
VACUUM ANALYZE;

-- Full vacuum (locks table)
VACUUM FULL;
```

### Disk Space

**Monitor:**
```sql
-- Database size
SELECT pg_size_pretty(pg_database_size('genaiops'));

-- Table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## Migration Strategy

### Phase 1.1 → Phase 1.2

**Hibernate DDL Auto:**
```yaml
# Phase 1.1
spring:
  jpa:
    hibernate:
      ddl-auto: update  # Auto-create tables

# Phase 1.2
spring:
  jpa:
    hibernate:
      ddl-auto: validate  # Only validate, no changes
```

**Manual Migration:**
```bash
# Apply schema
psql -h host -U user -d genaiops -f database/schema.sql

# Verify
psql -h host -U user -d genaiops -c "\dt"
```

### Future Migrations (Flyway)

**Structure:**
```
database/
└── migrations/
    ├── V1__initial_schema.sql
    ├── V2__add_audit_logs.sql
    ├── V3__add_indexes.sql
    └── V4__add_partitioning.sql
```

**Configuration:**
```yaml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: true
```

## Troubleshooting

### Connection Issues

**Test Connection:**
```bash
# From backend pod
oc exec deployment/genai-ops-backend -- \
  psql -h postgres-service -U genaiops -d genaiops -c "SELECT version();"
```

**Common Issues:**
- Network policy blocking
- Wrong credentials
- Database not created
- User permissions

### Performance Issues

**Slow Queries:**
```sql
-- Enable query logging
ALTER SYSTEM SET log_min_duration_statement = 1000;  -- Log queries > 1s

-- Check slow queries
SELECT * FROM pg_stat_activity 
WHERE state = 'active' 
AND query_start < NOW() - INTERVAL '5 seconds';
```

**Lock Contention:**
```sql
-- Check locks
SELECT * FROM pg_locks 
WHERE NOT granted;

-- Kill blocking query
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE pid = <blocking_pid>;
```

### Disk Space

**Clean Up:**
```sql
-- Vacuum old data
VACUUM FULL;

-- Drop old partitions (if using partitioning)
DROP TABLE audit_logs_2023_01;

-- Archive old data
-- Export and delete old audit_logs
```

## Best Practices

### Development

✅ Use Hibernate DDL auto for development
✅ Use migrations for production
✅ Test migrations on staging first
✅ Always backup before migration
✅ Use transactions for data changes

### Production

✅ Use connection pooling
✅ Enable SSL/TLS
✅ Regular backups (automated)
✅ Monitor performance
✅ Set up alerts
✅ Use read replicas for analytics
✅ Implement retention policies

### Security

✅ Strong passwords
✅ Least privilege principle
✅ Encrypt sensitive data
✅ Audit critical operations
✅ Regular security updates
✅ Network isolation

## Sonuç

GENAI-OPS database mimarisi, PostgreSQL'in güçlü özelliklerini kullanarak scalable, secure ve maintainable bir yapı sunar. Phase 1.1'de minimal kullanım, Phase 1.2'de comprehensive audit logging ve analytics için hazır.

**Güçlü Yönler:**
- UUID primary keys (distributed-friendly)
- JSONB for flexible data
- Comprehensive indexing
- Audit trail
- Analytics views
- Automatic triggers

**İyileştirme Alanları:**
- Partitioning (large tables)
- Read replicas (analytics)
- Advanced monitoring
- Automated retention policies
