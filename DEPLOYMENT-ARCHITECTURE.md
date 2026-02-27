# Deployment Mimari Dokümantasyonu

## Genel Bakış

GENAI-OPS uygulaması OpenShift/Kubernetes platformunda containerized microservices mimarisi ile deploy edilir. Multi-stage Docker build, automated CI/CD pipeline ve comprehensive monitoring içerir.

**Platform:**
- **Container Orchestration:** OpenShift 4.x / Kubernetes
- **Container Runtime:** Docker / CRI-O
- **CI/CD:** GitHub Actions
- **Registry:** containers.github.vpara.local

## Deployment Mimarisi

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    OpenShift Cluster                     │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │              Namespace: genai-ops               │    │
│  │                                                 │    │
│  │  ┌──────────────┐      ┌──────────────┐       │    │
│  │  │   Frontend   │      │   Backend    │       │    │
│  │  │  (Nginx)     │◄─────┤  (Spring)    │       │    │
│  │  │  Replicas: 2 │      │  Replicas: 2 │       │    │
│  │  └──────┬───────┘      └──────┬───────┘       │    │
│  │         │                     │                │    │
│  │         │                     │                │    │
│  │         │                     ↓                │    │
│  │         │              ┌──────────────┐        │    │
│  │         │              │  PostgreSQL  │        │    │
│  │         │              │  (External)  │        │    │
│  │         │              └──────────────┘        │    │
│  │         │                                      │    │
│  │         ↓                                      │    │
│  │  ┌──────────────┐                             │    │
│  │  │    Route     │                             │    │
│  │  │  (Ingress)   │                             │    │
│  │  └──────────────┘                             │    │
│  └─────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                         │
                         ↓
              ┌──────────────────┐
              │  External Users  │
              └──────────────────┘
```

### Component Diagram

```
Internet
    │
    ↓
┌─────────────────┐
│  Route (HTTPS)  │
│  TLS Edge       │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Frontend Svc   │
│  ClusterIP:80   │
└────────┬────────┘
         │
         ↓
┌─────────────────────────┐
│  Frontend Deployment    │
│  ┌─────────────────┐    │
│  │  Pod 1          │    │
│  │  Nginx:alpine   │    │
│  │  Port: 8080     │    │
│  └─────────────────┘    │
│  ┌─────────────────┐    │
│  │  Pod 2          │    │
│  │  Nginx:alpine   │    │
│  │  Port: 8080     │    │
│  └─────────────────┘    │
└─────────────────────────┘
         │
         │ /api/* proxy
         ↓
┌─────────────────┐
│  Backend Svc    │
│  ClusterIP:8080 │
└────────┬────────┘
         │
         ↓
┌─────────────────────────┐
│  Backend Deployment     │
│  ┌─────────────────┐    │
│  │  Pod 1          │    │
│  │  Spring Boot    │    │
│  │  Port: 8080     │    │
│  └─────────────────┘    │
│  ┌─────────────────┐    │
│  │  Pod 2          │    │
│  │  Spring Boot    │    │
│  │  Port: 8080     │    │
│  └─────────────────┘    │
└─────────────────────────┘
         │
         ↓
┌─────────────────┐
│  External DB    │
│  PostgreSQL     │
│  Port: 5432     │
└─────────────────┘
```

## Container Images

### Backend Image

**Dockerfile Strategy:** Multi-stage build

**Stage 1: Build**
```dockerfile
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests
```

**Stage 2: Runtime**
```dockerfile
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Image Details:**
- Base: eclipse-temurin:17-jre-alpine
- Size: ~200MB (optimized)
- Port: 8080
- Health: /actuator/health

### Frontend Image

**Dockerfile Strategy:** Multi-stage build + Nginx

**Stage 1: Build**
```dockerfile
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ARG VITE_API_URL=
ENV VITE_API_URL=$VITE_API_URL
RUN npm run build
```

**Stage 2: Runtime**
```dockerfile
FROM nginx:alpine
# OpenShift compatibility
RUN chgrp -R 0 /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R g+rwX /var/cache/nginx /var/run /var/log/nginx
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY env.sh /docker-entrypoint.d/env.sh
USER 1001
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
```

**Image Details:**
- Base: nginx:alpine
- Size: ~50MB
- Port: 8080 (OpenShift compatible)
- Non-root user: 1001

### Image Registry

**Registry:** containers.github.vpara.local

**Tagging Strategy:**
- `latest` - En son stable version
- `<git-sha>` - Specific commit
- `v1.0.0` - Semantic versioning (gelecek)

**Example:**
```
containers.github.vpara.local/vepas-ai/genai-ops-backend:latest
containers.github.vpara.local/vepas-ai/genai-ops-backend:abc123def
containers.github.vpara.local/vepas-ai/genai-ops-frontend:latest
```

## Kubernetes Resources

### Namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: genai-ops
  labels:
    app: genai-ops
    environment: production
```

### ConfigMap

**genai-ops-config:**
- Database URL
- LLM endpoint
- LDAP configuration
- Application settings

**Örnek:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: genai-ops-config
  namespace: genai-ops
data:
  DB_URL: "jdbc:postgresql://external-db:5432/genaiops"
  LLM_ENDPOINT_BASE_URL: "https://practicus.vodafone.local"
  LLM_MODEL_NAME: "cwyd-llm-general-prod"
  LDAP_URL: "ldaps://172.31.234.41:636"
```

### Secret

**genai-ops-secret:**
- Database password
- LDAP bind password
- LLM API token
- JWT secret
- Admin password

**Örnek:**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: genai-ops-secret
  namespace: genai-ops
type: Opaque
data:
  DB_PASSWORD: <base64-encoded>
  LDAP_BIND_PASSWORD: <base64-encoded>
  LLM_API_TOKEN: <base64-encoded>
  JWT_SECRET: <base64-encoded>
  ADMIN_PASSWORD: <base64-encoded>
```

**Security:**
- Sealed Secrets (önerilir)
- External Secrets Operator
- Vault integration

### Deployments

#### Backend Deployment

**Replicas:** 2 (High Availability)

**Resources:**
```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "1Gi"
    cpu: "500m"
```

**Probes:**
```yaml
livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    port: 8080
  initialDelaySeconds: 90
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 5

readinessProbe:
  httpGet:
    path: /actuator/health/readiness
    port: 8080
  initialDelaySeconds: 45
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 5
```

**Volumes:**
```yaml
volumes:
- name: vpara-ca-cert
  configMap:
    name: vpara-ldap-ca-cert
    defaultMode: 0644

volumeMounts:
- name: vpara-ca-cert
  mountPath: /etc/ssl/certs/vpara-ca
  readOnly: true
```

**Environment Variables:**
- ConfigMap references
- Secret references
- JAVA_TOOL_OPTIONS (SSL/TLS)

#### Frontend Deployment

**Replicas:** 2

**Resources:**
```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

**Probes:**
```yaml
livenessProbe:
  httpGet:
    path: /
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
```

### Services

#### Backend Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: genai-ops-backend
  namespace: genai-ops
spec:
  type: ClusterIP
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: genai-ops
    component: backend
```

#### Frontend Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: genai-ops-frontend
  namespace: genai-ops
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: genai-ops
    component: frontend
```

### Routes (OpenShift)

```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: genai-ops
  namespace: genai-ops
spec:
  host: genaiops.vpara.local
  to:
    kind: Service
    name: genai-ops-frontend
  port:
    targetPort: http
  tls:
    termination: edge
    insecureEdgeTerminationPolicy: Redirect
```

**Features:**
- HTTPS (TLS edge termination)
- HTTP → HTTPS redirect
- Custom hostname

## CI/CD Pipeline

### GitHub Actions Workflow

**Trigger:**
- Push to main/develop
- Pull request to main
- Manual dispatch

**Jobs:**

1. **build-backend**
   - Checkout code
   - Setup JDK 17
   - Install Maven
   - Build with Maven
   - Run tests
   - Build Docker image
   - Push to registry

2. **build-frontend**
   - Checkout code
   - Setup Node.js 18
   - Install dependencies
   - Run tests
   - Build Docker image
   - Push to registry

3. **deploy**
   - Install OpenShift CLI
   - Login to OpenShift
   - Deploy ConfigMap
   - Check/Create Secret
   - Deploy Backend
   - Deploy Frontend
   - Deploy Routes
   - Verify deployment

### Build Process

**Backend:**
```bash
mvn clean package -DskipTests
docker build -t backend:latest .
docker push registry/backend:latest
```

**Frontend:**
```bash
npm ci
npm run build
docker build --build-arg VITE_API_URL= -t frontend:latest .
docker push registry/frontend:latest
```

### Deployment Process

**Rolling Update:**
```bash
oc set image deployment/genai-ops-backend \
  backend=registry/backend:new-version

oc rollout status deployment/genai-ops-backend
```

**Rollback:**
```bash
oc rollout undo deployment/genai-ops-backend
oc rollout undo deployment/genai-ops-backend --to-revision=2
```

## Networking

### Internal Communication

**Service Discovery:**
- DNS-based (Kubernetes DNS)
- Service names as hostnames
- Example: `genai-ops-backend:8080`

**Frontend → Backend:**
```nginx
location /api/ {
    proxy_pass http://genai-ops-backend:8080/api/;
}
```

### External Communication

**Ingress:**
- OpenShift Route
- TLS termination
- Load balancing

**Egress:**
- External PostgreSQL
- LDAP server (ldaps://172.31.234.41:636)
- LLM API (https://practicus.vodafone.local)

### Network Policies (Optional)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: genai-ops-network-policy
spec:
  podSelector:
    matchLabels:
      app: genai-ops
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: genai-ops
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: genai-ops
  - to:  # External DB
    - namespaceSelector: {}
    ports:
    - protocol: TCP
      port: 5432
```

## Configuration Management

### Environment-Specific Config

**Development:**
```yaml
replicas: 1
resources:
  requests:
    memory: "256Mi"
    cpu: "100m"
```

**Production:**
```yaml
replicas: 2
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
```

### ConfigMap Strategy

**Immutable ConfigMaps:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: genai-ops-config-v2
immutable: true
data:
  ...
```

**Benefits:**
- Prevents accidental changes
- Enables rollback
- Version tracking

### Secret Management

**Best Practices:**
✅ Never commit secrets to Git
✅ Use Sealed Secrets or Vault
✅ Rotate secrets regularly
✅ Minimum privilege
✅ Audit access

**Sealed Secrets Example:**
```bash
kubeseal --format=yaml < secret.yaml > sealed-secret.yaml
oc apply -f sealed-secret.yaml
```

## Monitoring & Observability

### Health Checks

**Liveness Probe:**
- Checks if application is alive
- Restarts pod if fails
- Endpoint: `/actuator/health/liveness`

**Readiness Probe:**
- Checks if application is ready
- Removes from service if fails
- Endpoint: `/actuator/health/readiness`

### Metrics

**Spring Boot Actuator:**
```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

**Prometheus Integration:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: genai-ops-backend
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
    prometheus.io/path: "/actuator/prometheus"
```

### Logging

**Log Aggregation:**
- EFK Stack (Elasticsearch, Fluentd, Kibana)
- Splunk
- CloudWatch

**Log Format:**
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "INFO",
  "logger": "com.vodafone.genaiops",
  "message": "User logged in",
  "context": {
    "username": "john.doe",
    "ip": "192.168.1.1"
  }
}
```

**Access Logs:**
```bash
oc logs -f deployment/genai-ops-backend
oc logs -f deployment/genai-ops-frontend
```

### Tracing (Future)

**OpenTelemetry:**
- Distributed tracing
- Request correlation
- Performance analysis

## Scaling

### Horizontal Pod Autoscaler (HPA)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: genai-ops-backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: genai-ops-backend
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### Manual Scaling

```bash
# Scale up
oc scale deployment/genai-ops-backend --replicas=5

# Scale down
oc scale deployment/genai-ops-backend --replicas=2
```

### Database Scaling

**Read Replicas:**
- Master for writes
- Replicas for reads
- Connection pooling

**Connection Pool:**
```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
```

## High Availability

### Pod Distribution

**Anti-Affinity:**
```yaml
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - genai-ops
        topologyKey: kubernetes.io/hostname
```

### Pod Disruption Budget

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: genai-ops-backend-pdb
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: genai-ops
      component: backend
```

### Rolling Updates

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

**Zero Downtime:**
- maxUnavailable: 0
- Readiness probe
- Graceful shutdown

## Disaster Recovery

### Backup Strategy

**Application State:**
- Stateless design
- No local storage
- Database backup only

**Database Backup:**
```bash
# Daily backup
pg_dump -h db-host -U user genaiops | gzip > backup-$(date +%Y%m%d).sql.gz

# Upload to S3/Object Storage
aws s3 cp backup.sql.gz s3://backups/genaiops/
```

**Configuration Backup:**
```bash
# Export all resources
oc get all,configmap,secret -n genai-ops -o yaml > backup.yaml
```

### Recovery Procedures

**Application Recovery:**
```bash
# Redeploy from Git
git checkout <last-known-good-commit>
./deploy.sh

# Or rollback
oc rollout undo deployment/genai-ops-backend
```

**Database Recovery:**
```bash
# Restore from backup
gunzip < backup.sql.gz | psql -h db-host -U user genaiops
```

## Security

### Container Security

**Image Scanning:**
- Trivy
- Clair
- Snyk

**Non-Root User:**
```dockerfile
USER 1001
```

**Read-Only Root Filesystem:**
```yaml
securityContext:
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1001
```

### Network Security

**TLS Everywhere:**
- Route: TLS edge termination
- Backend → DB: SSL
- Backend → LDAP: LDAPS
- Backend → LLM: HTTPS

**Network Policies:**
- Restrict pod-to-pod communication
- Allow only necessary egress

### RBAC

**Service Account:**
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: genai-ops-sa
  namespace: genai-ops
```

**Role Binding:**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: genai-ops-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: genai-ops-role
subjects:
- kind: ServiceAccount
  name: genai-ops-sa
```

## Troubleshooting

### Common Issues

**Pod CrashLoopBackOff:**
```bash
# Check logs
oc logs <pod-name>

# Check events
oc describe pod <pod-name>

# Check resources
oc get pod <pod-name> -o yaml
```

**ImagePullBackOff:**
```bash
# Check image name
oc describe pod <pod-name> | grep Image

# Check registry credentials
oc get secret -n genai-ops

# Test image pull
docker pull <image-name>
```

**Service Unavailable:**
```bash
# Check service
oc get svc genai-ops-backend

# Check endpoints
oc get endpoints genai-ops-backend

# Check pod labels
oc get pods --show-labels
```

### Debug Commands

```bash
# Shell into pod
oc exec -it <pod-name> -- /bin/sh

# Port forward
oc port-forward <pod-name> 8080:8080

# View events
oc get events --sort-by='.lastTimestamp'

# Resource usage
oc adm top pods
oc adm top nodes
```

## Best Practices

### Development

✅ Use feature branches
✅ Test locally with docker-compose
✅ Run tests before commit
✅ Use semantic commit messages
✅ Code review before merge

### Deployment

✅ Use immutable tags (not :latest)
✅ Test in staging first
✅ Deploy during low-traffic hours
✅ Monitor after deployment
✅ Have rollback plan ready

### Operations

✅ Monitor metrics continuously
✅ Set up alerts
✅ Regular backups
✅ Security updates
✅ Capacity planning
✅ Documentation

## Sonuç

GENAI-OPS deployment mimarisi, modern cloud-native best practice'lerini takip eden, scalable, secure ve maintainable bir yapı sunar. Containerization, orchestration ve automation ile reliable ve efficient deployment sağlar.

**Güçlü Yönler:**
- Multi-stage Docker builds
- Kubernetes-native deployment
- Automated CI/CD pipeline
- High availability (2+ replicas)
- Health checks ve probes
- Rolling updates
- Comprehensive monitoring
- Security best practices

**İyileştirme Alanları:**
- Service mesh (Istio)
- Advanced monitoring (Prometheus/Grafana)
- Distributed tracing (Jaeger)
- GitOps (ArgoCD)
- Chaos engineering
- Multi-region deployment
