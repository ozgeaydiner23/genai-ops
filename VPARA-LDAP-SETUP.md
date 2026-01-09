# LDAP Authentication Setup - Vpara Active Directory

Bu döküman, Vpara ortamında LDAP/Active Directory authentication'ın nasıl kurulacağını açıklar.

## Genel Bakış

Vpara ortamında LDAPS (LDAP over SSL) kullanarak Active Directory authentication yapıyoruz. Authentication akışı şu şekilde:

1. **Service Account ile Bind** - Uygulama, özel bir service account ile LDAP'a bağlanır
2. **Kullanıcı Arama** - Giriş yapan kullanıcı Active Directory'de aranır
3. **DN Bulma** - Kullanıcının Distinguished Name (DN) bulunur
4. **Şifre Doğrulama** - Kullanıcının DN'i ile bind yapılarak şifre doğrulanır

## Gereksinimler

### 1. IT Ekibinden Alınması Gerekenler

#### a) LDAP Bağlantı Bilgileri
- **LDAP Server IP**: `172.31.234.41`
- **Port**: `636` (LDAPS)
- **Domain**: `Vpara.local`
- **Search Base**: `DC=vpara,DC=local`

#### b) Service Account Bilgileri
- **Bind DN**: `CN=srvc.ldap_prd,OU=VFTR_Admin,OU=VPARA,DC=vpara,DC=local`
- **Password**: IT ekibinden alınmalı

#### c) CA Certificate
- **Vpara Root CA Certificate**: `vpara-root-ca.crt`
- LDAPS bağlantısı için gerekli
- Base64 encoded formatında

#### d) Network Erişimi
- Pod'lardan `172.31.234.41:636` portuna erişim açılmalı

### 2. Active Directory Yapısı

```
DC=vpara,DC=local
├── OU=VPARA
│   ├── OU=VFTR_Admin
│   │   └── CN=srvc.ldap_prd (Service Account)
│   └── OU=Users
│       └── CN=Kullanıcı Adı (Normal kullanıcılar)
└── OU=Groups
    └── CN=VF_FinWatcher_Admins (Uygulama grupları)
```

**Kullanıcı Özellikleri:**
- `sAMAccountName`: Kullanıcı adı (örn: `kafeinbsarihan`)
- `displayName`: Görünen ad (örn: `Kafein Sarıhan`)
- `mail`: Email adresi
- `memberOf`: Kullanıcının üye olduğu gruplar

## Kurulum Adımları

### Adım 1: CA Certificate ConfigMap Oluşturma

1. IT ekibinden `vpara-root-ca.crt` dosyasını alın
2. Sertifikayı base64 encode edin:

```bash
cat vpara-root-ca.crt | base64 -w 0
```

3. `deployment/ldap-ca-cert-configmap.yaml` dosyasını oluşturun:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: vpara-ldap-ca-cert
  namespace: genai-ops
  labels:
    app: genai-ops
binaryData:
  vpara-root-ca.crt: |
    <BASE64_ENCODED_CERTIFICATE>
```

4. ConfigMap'i apply edin:

```bash
oc apply -f deployment/ldap-ca-cert-configmap.yaml
```

### Adım 2: LDAP Secret Güncelleme

`deployment/secret.yaml` dosyasında LDAP bilgilerini güncelleyin:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: genai-ops-secret
type: Opaque
stringData:
  # LDAP Configuration (Vpara Active Directory)
  LDAP_URL: "ldaps://172.31.234.41:636"
  LDAP_DOMAIN: "Vpara.local"
  LDAP_BASE_DN: "DC=vpara,DC=local"
  LDAP_BIND_DN: "CN=srvc.ldap_prd,OU=VFTR_Admin,OU=VPARA,DC=vpara,DC=local"
  LDAP_BIND_PASSWORD: "<IT_EKIBINDEN_ALINACAK_SIFRE>"
  LDAP_USER_SEARCH_BASE: "OU=VPARA,DC=vpara,DC=local"
  LDAP_USER_SEARCH_FILTER: "(sAMAccountName={0})"
  LDAP_AUTH_GROUP: "CN=vepas_genaiops_edit,OU=Groups,DC=vpara,DC=local"
```

### Adım 3: Backend Deployment Yapılandırması

Backend deployment'ında CA certificate mount edilmeli:

```yaml
volumeMounts:
  - name: vpara-ca-cert
    mountPath: /etc/ssl/certs/vpara-ca
    readOnly: true

volumes:
  - name: vpara-ca-cert
    configMap:
      name: vpara-ldap-ca-cert
      defaultMode: 0644
```

Environment variable ekleyin:

```yaml
- name: LDAP_CA_CERT_PATH
  value: "/etc/ssl/certs/vpara-ca/vpara-root-ca.crt"
```

## Authentication Akışı Detayları

### 1. Service Account Bind

```
Bind DN: CN=srvc.ldap_prd,OU=VFTR_Admin,OU=VPARA,DC=vpara,DC=local
Password: <service_account_password>
```

### 2. Kullanıcı Arama

```
Search Base: DC=vpara,DC=local
Search Filter: (sAMAccountName=kafeinbsarihan)
Attributes: distinguishedName, mail, displayName, memberOf, sAMAccountName
```

### 3. Kullanıcı DN Bulma

```
Sonuç: CN=Kafein Sarihan,OU=Users,OU=VPARA,DC=vpara,DC=local
```

### 4. Şifre Doğrulama

```
Bind DN: CN=Kafein Sarihan,OU=Users,OU=VPARA,DC=vpara,DC=local
Password: <kullanici_sifresi>
```

## Kullanıcı Giriş Formatları

Kullanıcılar şu formatlardan herhangi biriyle giriş yapabilir:

- `kafeinbsarihan` (sadece kullanıcı adı) ✅ Önerilen
- `VPARA\kafeinbsarihan` (domain\username)
- `kafeinbsarihan@Vpara.local` (email formatı)

Sistem otomatik olarak temizleyip doğru formatı kullanır.

## Güvenlik Notları

### SSL/TLS
- **LDAPS (Port 636)** kullanılmalı, plain LDAP (389) kullanılmamalı
- CA certificate doğrulaması aktif olmalı
- TLS 1.2 veya üzeri kullanılmalı

### Service Account
- Service account şifresi güvenli bir şekilde saklanmalı
- Secret'lar asla git'e commit edilmemeli
- Service account sadece kullanıcı okuma yetkisine sahip olmalı

### Password Handling
- Kullanıcı şifreleri asla loglanmamalı
- HTTPS üzerinden iletilmeli
- Backend'de hashlenmiş olarak saklanmamalı (LDAP doğrular)

## Troubleshooting

### Bağlantı Hataları

**Hata:** `socket ssl wrapping error: no certificate or crl found`
- **Çözüm:** CA certificate ConfigMap'i doğru mount edilmemiş
- ConfigMap'in doğru namespace'de olduğunu kontrol edin
- Volume mount path'ini kontrol edin

**Hata:** `NTLM needs domain\username and a password`
- **Çözüm:** Service account bind kullanılmıyor
- `LDAP_BIND_DN` ve `LDAP_BIND_PASSWORD` environment variable'larını kontrol edin

**Hata:** `invalidCredentials`
- **Çözüm:** Service account şifresi yanlış veya kullanıcı şifresi yanlış
- Service account bilgilerini IT ekibinden doğrulayın
- Kullanıcının Active Directory'de aktif olduğunu kontrol edin

### Log Kontrolleri

Başarılı authentication logları:

```
LDAP Auth Manager initialized
  Domain: Vpara.local
  Search Base: DC=vpara,DC=local
  Bind DN: CN=srvc.ldap_prd,OU=VFTR_Admin,OU=VPARA,DC=vpara,DC=local

Using service account bind for user: kafeinbsarihan
Binding with service account: CN=srvc.ldap_prd...
✓ Service account bind successful

Searching for user: (sAMAccountName=kafeinbsarihan) in DC=vpara,DC=local
✓ User found: CN=Kafein Sarihan,OU=Users,OU=VPARA,DC=vpara,DC=local

Verifying password for user: CN=Kafein Sarihan...
✓ Password verified for user: kafeinbsarihan
✓ LDAP authentication successful for user: kafeinbsarihan
```

## Test Kullanıcısı

Development ortamında test için admin kullanıcısı var:

```
Username: admin
Password: admin (ConfigMap'ten)
```

Bu kullanıcı LDAP'a gitmeden direkt authenticate olur. Production'da `ADMIN_ENABLED=false` yapılabilir.

## GENAI-OPS Entegrasyonu

### ConfigMap Yapılandırması

```yaml
# deployment/configmap.yaml
LDAP_URL: "ldaps://172.31.234.41:636"
LDAP_DOMAIN: "Vpara.local"
LDAP_BASE_DN: "DC=vpara,DC=local"
LDAP_USER_SEARCH_BASE: "OU=VPARA,DC=vpara,DC=local"
LDAP_USER_SEARCH_FILTER: "(sAMAccountName={0})"
LDAP_AUTH_GROUP: "CN=vepas_genaiops_edit,OU=Groups,DC=vpara,DC=local"
```

### Secret Yapılandırması

```yaml
# deployment/secret.yaml
LDAP_BIND_DN: "CN=srvc.ldap_prd,OU=VFTR_Admin,OU=VPARA,DC=vpara,DC=local"
LDAP_BIND_PASSWORD: "<IT_EKIBINDEN_ALINACAK>"
```

### Backend Deployment

```yaml
# deployment/backend-deployment.yaml
volumeMounts:
  - name: vpara-ca-cert
    mountPath: /etc/ssl/certs/vpara-ca
    readOnly: true

volumes:
  - name: vpara-ca-cert
    configMap:
      name: vpara-ldap-ca-cert

env:
  - name: LDAP_CA_CERT_PATH
    value: "/etc/ssl/certs/vpara-ca/vpara-root-ca.crt"
```

## Referanslar

**Dosyalar:**
- `backend/src/main/java/com/vodafone/genaiops/service/AuthService.java` - LDAP authentication logic
- `backend/src/main/resources/application.yml` - LDAP configuration
- `deployment/secret.yaml` - LDAP credentials
- `deployment/ldap-ca-cert-configmap.yaml` - CA certificate
- `deployment/backend-deployment.yaml` - Environment variables

**LDAP Library:**
- Java: Spring LDAP + Spring Security LDAP
- Authentication: Service account bind + user verification

---

**Vpara LDAP Authentication başarıyla yapılandırıldı! 🔐**
