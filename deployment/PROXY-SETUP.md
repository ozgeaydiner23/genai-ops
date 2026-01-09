# Frontend Nginx Proxy Yapılandırması

## Mimari

Frontend, Nginx reverse proxy kullanarak backend'e internal service üzerinden bağlanır:

```
Browser → OpenShift Route → Frontend (Nginx) → Backend Service (Internal)
         (HTTPS)              (Proxy /api/)     (HTTP cluster içi)
```

## Avantajlar

1. **Güvenlik**: Backend'e doğrudan external erişim yok
2. **Basitlik**: Tek bir route yeterli (frontend için)
3. **CORS Yok**: Same-origin olduğu için CORS problemi yok
4. **Performans**: Cluster içi iletişim daha hızlı

## Yapılandırma

### 1. Nginx Proxy (frontend/nginx.conf)

```nginx
location /api/ {
    proxy_pass http://genai-ops-backend:8080/api/;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_read_timeout 60s;
}
```

### 2. Frontend API URL (frontend/src/services/api.js)

```javascript
// Empty string = relative path (same origin)
const API_BASE_URL = ''
```

### 3. OpenShift Route (deployment/route.yaml)

```yaml
# Sadece frontend için route
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: genai-ops
spec:
  to:
    kind: Service
    name: genai-ops-frontend
  tls:
    termination: edge
```

## İstek Akışı

1. Browser: `GET https://genaiops-xxx.apps.ocp.local/api/auth/login`
2. OpenShift Route → Frontend Service
3. Nginx Proxy → `http://genai-ops-backend:8080/api/auth/login`
4. Backend Service → Response
5. Nginx → Browser

## Deployment

```bash
# 1. Frontend image'ı build et
docker build -t your-registry/genai-ops-frontend:latest ./frontend

# 2. Image'ı push et
docker push your-registry/genai-ops-frontend:latest

# 3. Deploy et
oc apply -f deployment/frontend-deployment.yaml
oc apply -f deployment/route.yaml

# 4. Route URL'ini al
oc get route genai-ops -n genai-ops
```

## Troubleshooting

### Nginx proxy hatası
```bash
# Frontend pod loglarını kontrol et
oc logs -f deployment/genai-ops-frontend -n genai-ops

# Backend service'in çalıştığını doğrula
oc get svc genai-ops-backend -n genai-ops
oc get endpoints genai-ops-backend -n genai-ops
```

### DNS çözümleme hatası
```bash
# Frontend pod'dan backend service'e erişimi test et
oc exec -it deployment/genai-ops-frontend -n genai-ops -- wget -O- http://genai-ops-backend:8080/actuator/health
```
