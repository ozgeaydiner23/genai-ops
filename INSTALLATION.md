# GENAI-OPS Installation Guide

## 🚀 Quick Start (Windows)

### Option 1: Automatic Installation (Recommended)

1. **Open PowerShell as Administrator**
   - Press `Win + X`
   - Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

2. **Allow script execution** (if needed)
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Run installation script**
   ```powershell
   .\install-tools.ps1
   ```
   This will install:
   - Chocolatey (package manager)
   - Node.js 18 LTS
   - Java 17 (Temurin)
   - Apache Maven
   - Git

4. **Restart your terminal/PowerShell**

5. **Setup the project**
   ```powershell
   .\setup-project.ps1
   ```

6. **Start the application**
   
   Terminal 1 (Backend):
   ```powershell
   cd backend
   mvn spring-boot:run
   ```
   
   Terminal 2 (Frontend):
   ```powershell
   cd frontend
   npm run dev
   ```

7. **Open browser**
   - Navigate to: http://localhost:3000
   - Login with any username/password

---

## 📦 Option 2: Manual Installation

### 1. Install Node.js

1. Download from: https://nodejs.org/en/download
2. Choose "Windows Installer (.msi)" - LTS version
3. Run installer
4. Make sure "Add to PATH" is checked
5. Restart terminal

Verify:
```bash
node --version
npm --version
```

### 2. Install Java 17

1. Download from: https://adoptium.net/
2. Choose "Temurin 17 (LTS)" - Windows x64 .msi
3. Run installer
4. Check "Set JAVA_HOME variable"
5. Check "Add to PATH"
6. Restart terminal

Verify:
```bash
java -version
```

### 3. Install Maven

1. Download from: https://maven.apache.org/download.cgi
2. Choose "Binary zip archive"
3. Extract to: `C:\Program Files\Apache\maven`
4. Add to System Environment Variables:
   - Variable: `MAVEN_HOME`
   - Value: `C:\Program Files\Apache\maven\apache-maven-3.x.x`
5. Add to PATH: `%MAVEN_HOME%\bin`
6. Restart terminal

Verify:
```bash
mvn -version
```

### 4. Setup Project

Frontend:
```bash
cd frontend
npm install
```

Create `frontend/.env`:
```
VITE_API_URL=http://localhost:8080
```

Backend:
```bash
cd backend
mvn clean install
```

### 5. Run Application

Terminal 1 (Backend):
```bash
cd backend
mvn spring-boot:run
```

Terminal 2 (Frontend):
```bash
cd frontend
npm run dev
```

Open: http://localhost:3000

---

## 🐛 Troubleshooting

### "command not found" errors

**Solution:** Restart your terminal after installation

### Port already in use

**Frontend (3000):**
Edit `frontend/vite.config.js`:
```js
server: {
  port: 3001
}
```

**Backend (8080):**
Edit `backend/src/main/resources/application.yml`:
```yaml
server:
  port: 8081
```

### Maven build fails

**Solution:** Make sure Java 17 is installed:
```bash
java -version
```

### npm install fails

**Solution:** Clear npm cache:
```bash
npm cache clean --force
npm install
```

---

## ✅ Verification

After installation, verify everything works:

```bash
# Check tools
node --version    # Should show v18.x.x or higher
npm --version     # Should show 9.x.x or higher
java -version     # Should show 17.x.x
mvn -version      # Should show 3.x.x

# Check frontend
cd frontend
npm run dev       # Should start on port 3000

# Check backend (new terminal)
cd backend
mvn spring-boot:run  # Should start on port 8080
```

---

## 🎯 Next Steps

After successful installation:

1. Read `DEVELOPMENT.md` for development guide
2. Check `README.md` for project overview
3. Review `tasks.md` for development status
4. See `PRD.md` for product requirements

---

## 📞 Support

If you encounter issues:
1. Check this troubleshooting section
2. Review error messages carefully
3. Ensure all prerequisites are installed
4. Restart your terminal/computer

---

**Happy Coding! 🚀**
