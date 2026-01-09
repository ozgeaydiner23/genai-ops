# OpenShift Deployment Guide

Bu döküman GENAI-OPS uygulamasının OpenShift ortamına nasıl deploy edileceğini açıklar.

## 📋 Ön Gereksinimler

- OpenShift CLI (`oc`) kurulu olmalı
- OpenShift cluster'a erişim yetkisi
- Container registry erişimi (image push için)
- GitHub repository erişimi

## 🚀 Deployment Adımları

### 1. Namespace Oluşturma

```bash
oc new-project genai-ops
```

### 2. ConfigMap Oluşturma

ConfigMap'i düzenleyin ve ortamınıza göre ayarlayın:

```bash
# configmap.yaml dosyasını düzenleyin
vi deployment/configmap.yaml

# Değiştirmeniz gereken değerler:
# - LLM_ENDPOINT_URL: LLM servisinizin URL'i
# - LDAP_URL: LDAP sunucu adresi
# - LDAP_BASE_DN: LDAP base DN
# - LDAP_BIND_DN: LDAP bind DN
# - LDAP_AUTH_GROUP: Yetkili grup adı

# ConfigMap'i oluşturun
oc apply -f deployment/configmap.yaml
```

### 3. Secret Oluşturma

Secret'ı düzenleyin ve güvenli değerler girin:

```bash
# secret.yaml dosyasını düzenleyin
vi deployment/secret.yaml

# DEĞİŞTİRMENİZ GEREKEN DEĞERLER:
# - DB_PASSWORD: PostgreSQL şifresi
# - LDAP_BIND_PASSWORD: LDAP bind şifresi
# - LLM_API_TOKEN: LLM API token
# - JWT_SECRET: JWT secret key (minimum 256 bit)
# - ADMIN_PASSWORD: Admin kullanıcı şifresi

# Secret'ı oluşturun
oc apply -f deployment/secret.yaml
```

### 4. PostgreSQL Deployment

```bash
# PostgreSQL'i deploy edin
oc apply -f deployment/postgres-deployment.yaml

# PostgreSQL'in hazır olmasını bekleyin
oc wait --for=condition=ready pod -l component=database --timeout=120s
```

### 5. Backend Build & Deploy

#### Option A: GitHub Actions ile Otomatik Deploy

`.github/workflows/deploy.yml` dosyası otomatik build ve deploy yapar.

GitHub Secrets'a şunları ekleyin:
- `OPENSHIFT_SERVER`: OpenShift API server URL
- `OPENSHIFT_TOKEN`: Service account token
- `REGISTRY_URL`: Container registry URL
- `REGISTRY_USERNAME`: Registry kullanıcı adı
- `REGISTRY_PASSWORD`: Registry şifresi

#### Option B: Manuel Build & Deploy

```bash
# Backend'i build edin
cd backend
mvn clean package -DskipTests

# Docker image build edin
docker build -t your-registry/genai-ops-backend:latest .

# Image'i push edin
docker push your-registry/genai-ops-backend:latest

# Deployment YAML'ı güncelleyin (image URL)
vi deployment/backend-deployment.yaml

# Backend'i deploy edin
oc apply -f deployment/backend-deployment.yaml
```

### 6. Frontend Build & Deploy

```bash
# Frontend'i build edin
cd frontend

# API URL ile build edin
docker build \
  --build-arg VITE_API_URL=https://genaiops-api.vpara.local \
  -t your-registry/genai-ops-frontend:latest .

# Image'i push edin
docker push your-registry/genai-ops-frontend:latest

# Deployment YAML'ı güncelleyin (image URL)
vi deployment/frontend-deployment.yaml

# Frontend'i deploy edin
oc apply -f deployment/frontend-deployment.yaml
```

### 7. Route Oluşturma

```bash
# Route'ları oluşturun
oc apply -f deployment/route.yaml

# Route'ları kontrol edin
oc get routes
```

## ✅ Doğrulama

### Pod'ların Durumunu Kontrol Etme

```bash
# Tüm pod'ları listele
oc get pods

# Pod loglarını görüntüle
oc logs -f deployment/genai-ops-backend
oc logs -f deployment/genai-ops-frontend
oc logs -f deployment/postgres
```

### Servis Durumunu Kontrol Etme

```bash
# Servisleri listele
oc get svc

# Backend health check
oc exec deployment/genai-ops-backend -- curl http://localhost:8080/actuator/health
```

### Uygulama Erişimi

```bash
# Route URL'ini al
oc get route genai-ops -o jsonpath='{.spec.host}'

# Tarayıcıda aç
https://genaiops.vpara.local
```

## 🔧 Yapılandırma Değişiklikleri

### ConfigMap Güncelleme

```bash
# ConfigMap'i düzenle
oc edit configmap genai-ops-config

# Pod'ları yeniden başlat (değişikliklerin uygulanması için)
oc rollout restart deployment/genai-ops-backend
```

### Secret Güncelleme

```bash
# Secret'ı düzenle
oc edit secret genai-ops-secret

# Pod'ları yeniden başlat
oc rollout restart deployment/genai-ops-backend
```

### Scaling

```bash
# Backend replica sayısını artır
oc scale deployment/genai-ops-backend --replicas=3

# Frontend replica sayısını artır
oc scale deployment/genai-ops-frontend --replicas=3
```

## 🐛 Sorun Giderme

### Pod Başlamıyor

```bash
# Pod durumunu kontrol et
oc describe pod <pod-name>

# Pod loglarını kontrol et
oc logs <pod-name>

# Events'leri kontrol et
oc get events --sort-by='.lastTimestamp'
```

### Database Bağlantı Hatası

```bash
# PostgreSQL pod'una bağlan
oc exec -it deployment/postgres -- psql -U genaiops -d genaiops

# Bağlantıyı test et
oc exec deployment/genai-ops-backend -- curl postgres-service:5432
```

### LDAP Bağlantı Hatası

```bash
# Backend loglarını kontrol et
oc logs -f deployment/genai-ops-backend | grep -i ldap

# LDAP bağlantısını test et
oc exec deployment/genai-ops-backend -- curl -v ldap://ldap.vpara.local:389
```

### LLM Servis Bağlantı Hatası

```bash
# Backend loglarını kontrol et
oc logs -f deployment/genai-ops-backend | grep -i llm

# LLM endpoint'i test et (JWT token ile)
LLM_TOKEN=$(oc get secret genai-ops-secret -o jsonpath='{.data.LLM_API_TOKEN}' | base64 -d)
oc exec deployment/genai-ops-backend -- curl -v \
  -H "Authorization: Bearer $LLM_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"test message","context":{}}' \
  <LLM_ENDPOINT_URL>

# LLM token'ın set edildiğini kontrol et
oc exec deployment/genai-ops-backend -- env | grep LLM_API_TOKEN
```

## 🔄 Güncelleme

### Yeni Versiyon Deploy Etme

```bash
# Yeni image'i build ve push edin
docker build -t your-registry/genai-ops-backend:v1.1.0 .
docker push your-registry/genai-ops-backend:v1.1.0

# Deployment'ı güncelleyin
oc set image deployment/genai-ops-backend backend=your-registry/genai-ops-backend:v1.1.0

# Rollout durumunu izleyin
oc rollout status deployment/genai-ops-backend
```

### Rollback

```bash
# Önceki versiyona geri dön
oc rollout undo deployment/genai-ops-backend

# Belirli bir revision'a geri dön
oc rollout undo deployment/genai-ops-backend --to-revision=2

# Rollout geçmişini görüntüle
oc rollout history deployment/genai-ops-backend
```

## 📊 Monitoring

### Resource Kullanımı

```bash
# Pod resource kullanımı
oc adm top pods

# Node resource kullanımı
oc adm top nodes
```

### Logs

```bash
# Tüm backend logları
oc logs -f deployment/genai-ops-backend --all-containers=true

# Son 100 satır
oc logs deployment/genai-ops-backend --tail=100

# Belirli bir zaman aralığı
oc logs deployment/genai-ops-backend --since=1h
```

## 🔐 Güvenlik

### Network Policies

```bash
# Network policy oluştur (opsiyonel)
oc apply -f deployment/network-policy.yaml
```

### RBAC

```bash
# Service account oluştur
oc create serviceaccount genai-ops-sa

# Role binding oluştur
oc create rolebinding genai-ops-binding \
  --serviceaccount=genai-ops:genai-ops-sa \
  --role=edit
```

## 📝 Notlar

- **ConfigMap**: Hassas olmayan yapılandırma değerleri için kullanılır
- **Secret**: Şifreler, token'lar gibi hassas veriler için kullanılır
- **PVC**: PostgreSQL verileri için persistent storage kullanılır
- **Routes**: HTTPS termination edge'de yapılır
- **Health Checks**: Liveness ve readiness probe'lar yapılandırılmıştır

## 🆘 Destek

Sorun yaşarsanız:
1. Pod loglarını kontrol edin
2. Events'leri kontrol edin
3. ConfigMap ve Secret değerlerini doğrulayın
4. Network bağlantısını test edin

**Happy Deploying! 🚀**
