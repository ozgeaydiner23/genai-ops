# GENAI-OPS Backend

AI-powered operations assistant chatbot API built with Spring Boot 3.

## Tech Stack

- **Framework:** Spring Boot 3.2.0
- **Language:** Java 17
- **Build Tool:** Maven
- **Database:** PostgreSQL (Phase 1.2)
- **Security:** Spring Security + JWT
- **ORM:** Spring Data JPA + Hibernate

## Getting Started

### Prerequisites

- Java 17+
- Maven 3.8+
- PostgreSQL 14+ (for Phase 1.2)

### Installation

```bash
mvn clean install
```

### Development

```bash
mvn spring-boot:run
```

Server runs on http://localhost:8080

### Build

```bash
mvn clean package
```

## Project Structure

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/vodafone/genaiops/
│   │   │   ├── controller/      # REST controllers
│   │   │   ├── service/         # Business logic
│   │   │   ├── model/           # Entity models
│   │   │   ├── repository/      # Data repositories
│   │   │   ├── dto/             # Data transfer objects
│   │   │   ├── config/          # Configuration classes
│   │   │   ├── security/        # Security components
│   │   │   └── GenaiOpsApplication.java
│   │   └── resources/
│   │       ├── application.yml
│   │       └── application-dev.yml
│   └── test/
├── pom.xml
└── README.md
```

## API Endpoints

### Phase 1.1 (Mock Authentication)

#### Authentication
- POST /api/auth/login - Mock login

#### Chat
- POST /api/chat/message - Send message to AI
- POST /api/chat/feedback - Submit feedback

### Phase 1.2 (LDAP + Database)

#### Authentication
- POST /api/auth/login - LDAP authentication

#### Chat
- POST /api/chat/message - Send message (with audit logging)
- POST /api/chat/feedback - Submit feedback (persisted to DB)

## Configuration

### application.yml

```yaml
server:
  port: 8080

spring:
  application:
    name: genai-ops-backend
  
  # Database (Phase 1.2)
  datasource:
    url: jdbc:postgresql://localhost:5432/genaiops_audit
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false

# LLM Configuration
llm:
  endpoint: ${LLM_ENDPOINT_URL}
  api-token: ${LLM_API_TOKEN}
  timeout: 30000

# JWT Configuration
jwt:
  secret: ${JWT_SECRET}
  expiration: 28800000  # 8 hours

# LDAP Configuration (Phase 1.2)
ldap:
  url: ${LDAP_URL}
  base-dn: ${LDAP_BASE_DN}
  bind-dn: ${LDAP_BIND_DN}
  bind-password: ${LDAP_BIND_PASSWORD}
  auth-group: ${LDAP_AUTH_GROUP}
```

## Environment Variables

Create `.env` file or set in OpenShift ConfigMap/Secret:

```
# Phase 1.1
LLM_ENDPOINT_URL=http://llm-service/api/chat
LLM_API_TOKEN=your-token-here
JWT_SECRET=your-secret-key-here

# Phase 1.2
DB_USERNAME=genaiops
DB_PASSWORD=your-db-password
LDAP_URL=ldap://ldap.vpara.local:389
LDAP_BASE_DN=dc=vpara,dc=local
LDAP_BIND_DN=cn=admin,dc=vpara,dc=local
LDAP_BIND_PASSWORD=your-ldap-password
LDAP_AUTH_GROUP=vepas_genaiops_edit
```

## Testing

```bash
mvn test
```

## Docker Build

```bash
docker build -t genai-ops-backend:latest .
```
