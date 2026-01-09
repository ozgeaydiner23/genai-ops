# GitHub Actions Workflow Setup

Bu döküman GitHub Actions CI/CD pipeline'ının nasıl kurulacağını ve çalıştırılacağını açıklar.

## 📋 Workflow Özeti

**Dosya:** `.github/workflows/deploy.yml`

### Workflow Tetikleyicileri

- **Push:** `main` ve `develop` branch'lerine push
- **Pull Request:** `main` branch'ine PR

### Jobs

1. **build-backend** - Backend build ve test
2. **build-frontend** - Frontend build ve test
3. **deploy** - OpenShift'e deployment (sadece main branch)

---

## 🔐 Gerekli GitHub Secrets

Repository Settings → Secrets and variables → Actions → New repository secret

| Secret Name | Açıklama | Örnek Değer |
|-------------|----------|-------------|
| `REGISTRY_URL` | Container registry URL | `quay.io/vodafone` |
| `REGISTRY_USERNAME` | Registry kullanıcı adı | `robot-account` |
| `REGISTRY_PASSWORD` | Registry şifresi | `***` |
| `OPENSHIFT_SERVER` | OpenShift API server | `https://api.ocp.vpara.local:6443` |
| `OPENSHIFT_TOKEN` | Service account token | `sha256~***` |

### Secret'ları Nasıl Alırsınız?

#### 1. Container Registry Credentials

```bash
# Quay.io kullanıyorsanız
# 1. Quay.io'da robot account oluşturun
# 2. Credentials'ı kopyalayın
```

#### 2. OpenShift Token

```bash
# Service account oluşturun
oc create serviceaccount github-actions -n genai-ops

# Role binding
oc policy add-role-to-user edit system:serviceaccount:genai-ops:github-actions -n genai-ops

# Token alın
oc create token github-actions -n genai-ops --duration=8760h
```

---

## 🚀 Workflow Adımları

### 1. Build Backend

```yaml
- Checkout code
- Setup JDK 17
- Maven build (mvn clean package)
- Run tests (mvn test)
- Docker build & push
  - Tag: latest
  - Tag: {git-sha}
```

**Başarısız olursa:** Pipeline durur (test hatası)

### 2. Build Frontend

```yaml
- Checkout code
- Setup Node.js 18
- npm install
- Run tests (optional)
- Docker build & push
  - Build arg: VITE_API_URL
  - Tag: latest
  - Tag: {git-sha}
```

**Başarısız olursa:** Frontend test hatası devam eder (test yoksa)

### 3. Deploy to OpenShift

**Sadece `main` branch'e push olduğunda çalışır**

```yaml
1. LDAP CA Certificate kontrolü
2. ConfigMap deployment
3. Secret kontrolü (güvenlik uyarısı)
4. PostgreSQL deployment
5. Backend deployment
6. Frontend deployment
7. Routes deployment
8. Verification
```

---

## ⚠️ Önemli Kontroller

### 1. LDAP CA Certificate

```bash
# Workflow bu ConfigMap'i kontrol eder
oc get configmap vpara-ldap-ca-cert -n genai-ops
```

**Yoksa:** Uyarı verir ama devam eder

**Nasıl oluşturulur:**
```bash
# VPARA-LDAP-SETUP.md dökümanına bakın
oc apply -f deployment/ldap-ca-cert-configmap.yaml
```

### 2. Secret Güvenliği

```bash
# Workflow Secret'ı kontrol eder
oc get secret genai-ops-secret -n genai-ops
```

**Yoksa:** Template'ten oluşturur ve UYARI verir

**⚠️ UYARI:** Template değerleri production için güvenli değil!

**Production için güncellenmeli:**
- `DB_PASSWORD`
- `LDAP_BIND_PASSWORD`
- `LLM_API_TOKEN`
- `JWT_SECRET`
- `ADMIN_PASSWORD`

```bash
# Secret'ı manuel güncelleme
oc edit secret genai-ops-secret -n genai-ops
```

---

## 📊 Workflow Çıktısı

### Başarılı Deployment

```
✓ LDAP CA Certificate ConfigMap exists
✓ ConfigMap deployed
✓ Secret exists (not updating to preserve production values)
Waiting for PostgreSQL to be ready...
✓ PostgreSQL deployed
Waiting for backend rollout...
✓ Backend deployed
Waiting for frontend rollout...
✓ Frontend deployed
✓ Routes deployed

=== Deployment Summary ===

=== Pods ===
NAME                                  READY   STATUS    RESTARTS   AGE
genai-ops-backend-xxx                 1/1     Running   0          2m
genai-ops-frontend-xxx                1/1     Running   0          1m
postgres-xxx                          1/1     Running   0          3m

✓ Deployment completed successfully!

🌐 Application URLs:
  Frontend: https://genaiops.vpara.local
  Backend:  https://genaiops-api.vpara.local
```

### Uyarılar

```
⚠️  WARNING: vpara-ldap-ca-cert ConfigMap not found!
Please create it manually with Vpara Root CA certificate
See VPARA-LDAP-SETUP.md for instructions
```

```
⚠️  WARNING: genai-ops-secret not found!
Creating from template - MUST UPDATE PRODUCTION VALUES!
⚠️  IMPORTANT: Update secret values before production use:
  - DB_PASSWORD
  - LDAP_BIND_PASSWORD
  - LLM_API_TOKEN
  - JWT_SECRET
  - ADMIN_PASSWORD
```

---

## 🧪 Test Etme

### Local Test (Workflow çalıştırmadan)

```bash
# Backend build test
cd backend
mvn clean package -DskipTests

# Frontend build test
cd frontend
npm ci
npm run build

# Docker build test
docker build -t test-backend ./backend
docker build -t test-frontend ./frontend
```

### Workflow Test (GitHub'da)

1. **Feature branch oluştur:**
```bash
git checkout -b feature/test-workflow
git push origin feature/test-workflow
```

2. **PR aç:** `main` branch'ine

3. **Workflow çalışır:** Build jobs çalışır, deploy çalışmaz

4. **Merge et:** `main` branch'e merge edilince deploy çalışır

---

## 🔧 Troubleshooting

### 1. Build Hatası

**Backend:**
```bash
# Local'de test et
cd backend
mvn clean package

# Hata loglarını kontrol et
```

**Frontend:**
```bash
# Local'de test et
cd frontend
npm ci
npm run build
```

### 2. Docker Push Hatası

**Hata:** `unauthorized: authentication required`

**Çözüm:**
- Registry credentials'ı kontrol et
- `REGISTRY_USERNAME` ve `REGISTRY_PASSWORD` secret'larını doğrula

### 3. OpenShift Login Hatası

**Hata:** `error: You must be logged in to the server`

**Çözüm:**
- `OPENSHIFT_TOKEN` secret'ını kontrol et
- Token'ın expire olmadığını doğrula
- Service account permissions'ı kontrol et

### 4. Deployment Timeout

**Hata:** `error: timed out waiting for the condition`

**Çözüm:**
```bash
# Pod loglarını kontrol et
oc logs deployment/genai-ops-backend -n genai-ops

# Events'leri kontrol et
oc get events -n genai-ops --sort-by='.lastTimestamp'

# Pod describe
oc describe pod <pod-name> -n genai-ops
```

### 5. Image Pull Hatası

**Hata:** `ImagePullBackOff`

**Çözüm:**
- Registry URL'i doğru mu?
- Image tag'i doğru mu?
- Registry credentials OpenShift'te var mı?

```bash
# Image pull secret oluştur
oc create secret docker-registry registry-secret \
  --docker-server=$REGISTRY_URL \
  --docker-username=$REGISTRY_USERNAME \
  --docker-password=$REGISTRY_PASSWORD \
  -n genai-ops

# Deployment'a ekle
oc set serviceaccount deployment/genai-ops-backend default -n genai-ops
oc secrets link default registry-secret --for=pull -n genai-ops
```

---

## 📝 Best Practices

### 1. Branch Strategy

- **main:** Production deployment
- **develop:** Development/staging
- **feature/*:** Feature branches (sadece build)

### 2. Secret Management

- ✅ Secrets'ı GitHub'da sakla
- ✅ Production secrets'ı manuel güncelle
- ❌ Secrets'ı kod içinde tutma
- ❌ Secrets'ı log'lama

### 3. Deployment Strategy

- ✅ Rolling update kullan
- ✅ Health check'leri bekle
- ✅ Rollout status kontrol et
- ✅ Rollback planı hazırla

### 4. Monitoring

- ✅ Workflow loglarını izle
- ✅ OpenShift events'leri kontrol et
- ✅ Application logs'ları izle
- ✅ Metrics'leri takip et

---

## 🔄 Rollback

Deployment başarısız olursa:

```bash
# Önceki versiyona dön
oc rollout undo deployment/genai-ops-backend -n genai-ops
oc rollout undo deployment/genai-ops-frontend -n genai-ops

# Belirli bir revision'a dön
oc rollout history deployment/genai-ops-backend -n genai-ops
oc rollout undo deployment/genai-ops-backend --to-revision=2 -n genai-ops
```

---

## ✅ Checklist

İlk deployment öncesi:

- [ ] GitHub Secrets oluşturuldu
- [ ] OpenShift namespace oluşturuldu (`genai-ops`)
- [ ] Service account oluşturuldu
- [ ] LDAP CA Certificate ConfigMap oluşturuldu
- [ ] Secret production değerleriyle güncellendi
- [ ] Container registry erişimi test edildi
- [ ] OpenShift token test edildi
- [ ] Network erişimi kontrol edildi (LDAP, LLM)

---

## 📞 Destek

Sorun yaşarsanız:

1. **Workflow logs:** GitHub Actions → Workflow run → Job logs
2. **OpenShift logs:** `oc logs deployment/genai-ops-backend`
3. **Events:** `oc get events --sort-by='.lastTimestamp'`
4. **Dökümanlar:** `DEPLOYMENT.md`, `VPARA-LDAP-SETUP.md`

---

**GitHub Actions CI/CD Pipeline hazır! 🚀**
