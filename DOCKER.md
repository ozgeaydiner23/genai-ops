# 🐳 Docker ile GENAI-OPS Kurulumu

Docker kullanarak projeyi çalıştırmak için bu rehberi takip edin.

## 📋 Gereksinimler

- Docker Desktop (Windows için)
- En az 4GB RAM
- En az 10GB disk alanı

## 🚀 Hızlı Başlangıç

### 1. Docker Desktop'ın Çalıştığından Emin Olun

```powershell
docker --version
docker-compose --version
```

### 2. Projeyi Başlatın

Proje klasöründe şu komutu çalıştırın:

```powershell
docker-compose up --build
```

Bu komut:
- PostgreSQL veritabanını başlatır
- Backend'i derler ve çalıştırır
- Frontend'i derler ve çalıştırır

### 3. Uygulamayı Açın

Tarayıcınızda şu adresi açın:
```
http://localhost:3000
```

### 4. Giriş Yapın

Herhangi bir kullanıcı adı ve şifre ile giriş yapabilirsiniz (mock authentication):
- Kullanıcı adı: `admin`
- Şifre: `admin`

---

## 🎯 Docker Komutları

### Servisleri Başlatma

```powershell
# İlk kez başlatma (build ile)
docker-compose up --build

# Arka planda çalıştırma
docker-compose up -d

# Sadece belirli servisi başlatma
docker-compose up backend
```

### Servisleri Durdurma

```powershell
# Servisleri durdur
docker-compose down

# Servisleri durdur ve volume'leri sil
docker-compose down -v
```

### Logları Görüntüleme

```powershell
# Tüm servislerin logları
docker-compose logs -f

# Sadece backend logları
docker-compose logs -f backend

# Sadece frontend logları
docker-compose logs -f frontend
```

### Servisleri Yeniden Başlatma

```powershell
# Tüm servisleri yeniden başlat
docker-compose restart

# Sadece backend'i yeniden başlat
docker-compose restart backend
```

### Container'lara Bağlanma

```powershell
# Backend container'ına bağlan
docker exec -it genai-ops-backend sh

# PostgreSQL'e bağlan
docker exec -it genai-ops-db psql -U genaiops -d genaiops
```

---

## 🔧 Yapılandırma

### Port Değiştirme

`docker-compose.yml` dosyasında portları değiştirebilirsiniz:

```yaml
services:
  frontend:
    ports:
      - "3001:80"  # 3000 yerine 3001 kullan
  
  backend:
    ports:
      - "8081:8080"  # 8080 yerine 8081 kullan
```

### Environment Variables

Backend için environment variables `docker-compose.yml` içinde:

```yaml
backend:
  environment:
    JWT_SECRET: your-secret-key-here
    JWT_EXPIRATION: 86400000
```

---

## 🐛 Sorun Giderme

### Port Zaten Kullanımda

**Hata:** `Bind for 0.0.0.0:3000 failed: port is already allocated`

**Çözüm:** Portu değiştirin veya çakışan uygulamayı kapatın:

```powershell
# Windows'ta port kullanan process'i bul
netstat -ano | findstr :3000

# Process'i kapat (PID ile)
taskkill /PID <PID> /F
```

### Docker Build Hatası

**Çözüm:** Cache'i temizleyip yeniden build edin:

```powershell
docker-compose build --no-cache
docker-compose up
```

### Container Başlamıyor

**Çözüm:** Logları kontrol edin:

```powershell
docker-compose logs backend
docker-compose logs frontend
```

### Veritabanı Bağlantı Hatası

**Çözüm:** PostgreSQL'in hazır olmasını bekleyin:

```powershell
# PostgreSQL health check
docker-compose ps
```

### Tüm Docker Verilerini Temizleme

```powershell
# Tüm container'ları durdur
docker-compose down -v

# Kullanılmayan image'leri temizle
docker system prune -a

# Yeniden başlat
docker-compose up --build
```

---

## 📊 Servis Bilgileri

| Servis | Port | URL |
|--------|------|-----|
| Frontend | 3000 | http://localhost:3000 |
| Backend | 8080 | http://localhost:8080 |
| PostgreSQL | 5432 | localhost:5432 |

### API Endpoints

- Health Check: http://localhost:8080/actuator/health
- API Docs: http://localhost:8080/swagger-ui.html (eğer eklenirse)

---

## 🔄 Geliştirme Modu

Kod değişikliklerini anında görmek için:

### Backend Hot Reload

Backend için Spring Boot DevTools zaten aktif. Container'ı yeniden başlatın:

```powershell
docker-compose restart backend
```

### Frontend Hot Reload

Development mode için ayrı bir docker-compose dosyası:

```powershell
# docker-compose.dev.yml oluşturun
docker-compose -f docker-compose.dev.yml up
```

---

## 📦 Production Build

Production için optimize edilmiş build:

```powershell
# Production build
docker-compose -f docker-compose.yml build

# Production'da çalıştır
docker-compose up -d
```

---

## ✅ Doğrulama

Kurulumun başarılı olduğunu doğrulamak için:

```powershell
# Container'ların çalıştığını kontrol et
docker-compose ps

# Backend health check
curl http://localhost:8080/actuator/health

# Frontend'e tarayıcıdan eriş
start http://localhost:3000
```

---

## 🎓 Docker Komutları Özeti

```powershell
# Başlat
docker-compose up -d

# Durdur
docker-compose down

# Loglar
docker-compose logs -f

# Yeniden başlat
docker-compose restart

# Temizle
docker-compose down -v
docker system prune -a
```

---

## 📞 Destek

Sorun yaşarsanız:
1. Logları kontrol edin: `docker-compose logs -f`
2. Container durumunu kontrol edin: `docker-compose ps`
3. Docker Desktop'ın çalıştığından emin olun

**Happy Dockerizing! 🐳**
