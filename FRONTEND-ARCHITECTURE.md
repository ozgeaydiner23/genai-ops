# Frontend Mimari Dokümantasyonu

## Genel Bakış

GENAI-OPS Frontend, React 18 ve Vite kullanılarak geliştirilmiş modern bir single-page application (SPA)'dir. Vodafone için AI destekli operasyon asistanı arayüzü sağlar.

**Proje Bilgileri:**
- **Proje Adı:** genai-ops-frontend
- **Versiyon:** 1.0.0
- **Build Tool:** Vite 5.0.8
- **Dev Server Port:** 3000

## Teknoloji Stack

### Core Framework
- **React 18.2.0** - UI kütüphanesi
- **React DOM 18.2.0** - DOM rendering
- **Vite 5.0.8** - Build tool ve dev server

### Routing & State Management
- **React Router DOM 6.20.0** - Client-side routing
- **React Context API** - Global state management

### HTTP & API
- **Axios 1.6.2** - HTTP client

### UI & Icons
- **Lucide React 0.294.0** - Icon kütüphanesi
- **Custom CSS** - Vodafone design system

### Development Tools
- **ESLint 8.55.0** - Code linting
- **@vitejs/plugin-react 4.2.1** - React plugin for Vite

## Proje Yapısı

```
frontend/
├── public/                    # Static assets
├── src/
│   ├── components/           # React components
│   │   ├── chat/            # Chat-specific components
│   │   ├── common/          # Reusable UI components
│   │   └── layout/          # Layout components
│   ├── context/             # React Context providers
│   ├── pages/               # Page components
│   ├── services/            # API service layer
│   ├── styles/              # CSS stylesheets
│   ├── App.jsx              # Root component
│   └── main.jsx             # Entry point
├── index.html               # HTML template
├── vite.config.js           # Vite configuration
├── package.json             # Dependencies
├── Dockerfile               # Container image
└── nginx.conf               # Nginx configuration
```

## Mimari Katmanlar

Frontend uygulaması 5 ana katmandan oluşur:

```
┌─────────────────────────────────────────┐
│         Pages Layer                     │
│    (Route-based page components)        │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      Components Layer                   │
│  (Reusable UI & Feature Components)     │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│       Context Layer                     │
│    (Global State Management)            │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│       Services Layer                    │
│    (API Communication)                  │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│         Styles Layer                    │
│    (CSS Design System)                  │
└─────────────────────────────────────────┘
```

## Detaylı Katman Analizi

### 1. Entry Point (main.jsx)

**Amaç:** Uygulamanın başlangıç noktası

**Sorumluluklar:**
- React root oluşturma
- CSS dosyalarını import etme
- App component'ini render etme

**CSS Import Sırası:**
1. variables.css - CSS değişkenleri
2. global.css - Global stiller
3. components.css - Component stilleri
4. layouts.css - Layout stilleri
5. chat.css - Chat-specific stiller

**Strict Mode:**
- React.StrictMode ile development'ta ek kontroller

### 2. Root Component (App.jsx)

**Amaç:** Uygulamanın kök component'i

**Yapı:**
```jsx
<Router>
  <AuthProvider>
    <ChatProvider>
      <Routes>
        <Route path="/login" />
        <Route path="/chat" />
        <Route path="/" redirect />
      </Routes>
    </ChatProvider>
  </AuthProvider>
</Router>
```

**Provider Hiyerarşisi:**
1. **BrowserRouter** - Routing
2. **AuthProvider** - Authentication state
3. **ChatProvider** - Chat state

**Route Yapısı:**
- `/login` → LoginPage (Public)
- `/chat` → ChatPage (Protected)
- `/` → Redirect to /login

### 3. Services Layer (services/)

#### api.js
**Amaç:** Axios instance ve interceptor'lar

**Konfigürasyon:**
```javascript
baseURL: window.ENV?.VITE_API_URL || ''
timeout: 30000 ms (30 saniye)
headers: { 'Content-Type': 'application/json' }
```

**Request Interceptor:**
- localStorage'dan token alır
- Authorization header ekler: `Bearer <token>`
- Request'i console'a loglar

**Response Interceptor:**
- Response'u console'a loglar
- 401 Unauthorized durumunda:
  - Token ve user bilgisini temizler
  - /login sayfasına yönlendirir

**Runtime Configuration:**
- `window.ENV.VITE_API_URL` - Runtime'da env.sh ile inject edilir
- `import.meta.env.VITE_API_URL` - Build-time environment variable
- Empty string - Relative path (nginx proxy)

#### authService.js
**Amaç:** Authentication işlemleri

**Metodlar:**

1. **login(username, password)**
   - POST /api/auth/login
   - Returns: { token, user }
   - Error handling

2. **logout()**
   - localStorage'dan token ve user'ı siler

3. **isAuthenticated()**
   - Token varlığını kontrol eder
   - Returns: boolean

4. **getCurrentUser()**
   - localStorage'dan user bilgisini parse eder
   - Returns: user object | null

#### chatService.js
**Amaç:** Chat işlemleri

**Metodlar:**

1. **sendMessage(message)**
   - POST /api/chat/message
   - Returns: { response, messageId, timestamp }
   - Error handling ve logging

2. **submitFeedback(messageId, feedback, comment)**
   - POST /api/chat/feedback
   - feedback: 'like' | 'dislike'
   - Returns: { success, message }

### 4. Context Layer (context/)

#### AuthContext.jsx
**Amaç:** Global authentication state yönetimi

**State:**
```javascript
{
  user: object | null,
  token: string | null,
  isAuthenticated: boolean,
  loading: boolean
}
```

**Metodlar:**

1. **login(userData, authToken)**
   - State'i günceller
   - localStorage'a kaydeder

2. **logout()**
   - State'i temizler
   - localStorage'dan siler

**Lifecycle:**
- useEffect ile mount'ta localStorage kontrolü
- Token ve user varsa state'e yükler

**Custom Hook:**
```javascript
const { user, token, isAuthenticated, loading, login, logout } = useAuth()
```

#### ChatContext.jsx
**Amaç:** Chat messages ve state yönetimi

**State:**
```javascript
{
  messages: array,
  isLoading: boolean,
  error: string | null
}
```

**Message Structure:**
```javascript
{
  id: string,
  type: 'user' | 'ai',
  text: string,
  timestamp: ISO-8601,
  feedback: 'like' | 'dislike' | null  // AI messages only
}
```

**Metodlar:**

1. **addUserMessage(text)**
   - User mesajı oluşturur ve ekler
   - Returns: message object

2. **addAIMessage(text, messageId)**
   - AI mesajı oluşturur ve ekler
   - Returns: message object

3. **updateMessageFeedback(messageId, feedback)**
   - Mesajın feedback'ini günceller

4. **clearMessages()**
   - Tüm mesajları ve error'ı temizler

5. **setLoadingState(loading)**
   - Loading state'ini günceller

6. **setErrorState(error)**
   - Error state'ini günceller

**Custom Hook:**
```javascript
const { 
  messages, 
  isLoading, 
  error,
  addUserMessage,
  addAIMessage,
  updateMessageFeedback,
  clearMessages,
  setLoadingState,
  setErrorState
} = useChat()
```

### 5. Pages Layer (pages/)

#### LoginPage.jsx
**Amaç:** Kullanıcı giriş sayfası

**State:**
```javascript
{
  formData: { username, password },
  errors: { username?, password? },
  isLoading: boolean,
  apiError: string
}
```

**Form Validation:**
- Username: Required, trim kontrolü
- Password: Required, min 3 karakter

**İş Akışı:**
1. Form submit
2. Validation kontrolü
3. authService.login() çağrısı
4. Başarılı: AuthContext.login() + navigate('/chat')
5. Hata: Error mesajı göster

**UI Components:**
- Custom logo SVG
- Input components (username, password)
- Button component (loading state ile)
- Error message display

#### ChatPage.jsx
**Amaç:** Ana chat arayüzü

**Yapı:**
```jsx
<div className="app-container">
  <Sidebar />
  <div className="main-content">
    <ChatHeader />
    <iframe src="practicus.vodafone.local" />
  </div>
</div>
```

**Özellik:**
- Practicus AI platformunu iframe ile embed eder
- Sidebar ve header ile layout sağlar
- Full-height iframe (border: none)

### 6. Components Layer

#### 6.1 Layout Components (components/layout/)

##### Sidebar.jsx
**Amaç:** Sol navigasyon paneli

**Bölümler:**

1. **Header**
   - Vodafone logo (SVG)
   - "GENAI-OPS" başlık
   - "AI Operations Assistant" alt başlık

2. **Content**
   - New Chat button (Plus icon)
   - Quick Actions menu:
     - Analyze Logs
     - Suggest Fix
     - View Docs
   - History menu:
     - Current Session (active)

3. **Footer**
   - User avatar (initials)
   - Username
   - Logout button

**Interaktivite:**
- Hover effects
- Active state indicators
- Logout functionality

##### ChatHeader.jsx
**Amaç:** Üst header bar

**İçerik:**
- "GENAI-OPS" başlık
- Help button (HelpCircle icon)
- Settings button (Settings icon)

#### 6.2 Chat Components (components/chat/)

##### ChatContainer.jsx
**Amaç:** Ana chat container

**Özellikler:**
- Auto-scroll to bottom (useRef + useEffect)
- Empty state gösterimi
- MessageList render
- TypingIndicator gösterimi
- Error message display

**Empty State:**
- MessageSquare icon
- "Start a Conversation" başlık
- Açıklama metni

##### MessageList.jsx
**Amaç:** Mesaj listesi renderer

**Basit yapı:**
- messages.map() ile MessageItem render
- Key olarak message.id kullanımı

##### MessageItem.jsx
**Amaç:** Mesaj tipi router

**Mantık:**
```javascript
if (type === 'user') return <UserMessage />
if (type === 'ai') return <AIMessage />
return null
```

##### UserMessage.jsx
**Amaç:** Kullanıcı mesajı gösterimi

**Yapı:**
- Avatar (user initials)
- Message bubble
- Message text
- Timestamp (HH:MM format)

**Styling:**
- .message-user class
- Right-aligned layout

##### AIMessage.jsx
**Amaç:** AI mesajı gösterimi

**Yapı:**
- Avatar (AI variant)
- Message bubble
- Formatted content (code blocks support)
- Timestamp
- FeedbackButtons

**Content Rendering:**
- Code block detection (```)
- Language extraction
- CodeBlock component kullanımı
- Plain text paragraflar

**Code Block Parsing:**
```
```language
code content
```
```

##### TypingIndicator.jsx
**Amaç:** AI yazıyor animasyonu

**Yapı:**
- AI avatar
- 3 animated dots
- CSS animation ile pulse effect

##### FeedbackButtons.jsx
**Amaç:** Like/Dislike feedback

**State:**
- feedback: 'like' | 'dislike' | null
- isSubmitting: boolean

**Buttons:**
1. **Like Button**
   - ThumbsUp icon
   - "Helpful" text
   - Active state styling

2. **Dislike Button**
   - ThumbsDown icon
   - "Not Helpful" text
   - Active state styling

**İş Akışı:**
1. Button click
2. Same feedback check (no-op)
3. chatService.submitFeedback()
4. Local state update
5. Context update (updateMessageFeedback)

##### CodeBlock.jsx
**Amaç:** Kod bloğu gösterimi

**Features:**
- Language badge
- Copy button
- Syntax highlighting (pre tag)
- Copied state feedback

**Copy Functionality:**
- navigator.clipboard.writeText()
- 2 saniye "Copied!" feedback
- Error handling

#### 6.3 Common Components (components/common/)

##### PrivateRoute.jsx
**Amaç:** Protected route wrapper

**Mantık:**
```javascript
if (!isAuthenticated) return <Navigate to="/login" />
return children
```

##### Button.jsx
**Amaç:** Reusable button component

**Props:**
- variant: 'primary' | 'secondary' | ...
- type: 'button' | 'submit' | 'reset'
- disabled: boolean
- icon: ReactNode
- onClick: function

**CSS Classes:**
- .btn (base)
- .btn-{variant}
- .btn-icon-wrapper (icon container)

##### Input.jsx
**Amaç:** Reusable input component

**Props:**
- label: string
- type: string
- placeholder: string
- value: string
- onChange: function
- error: string
- disabled: boolean
- required: boolean

**Features:**
- forwardRef support
- Error state styling
- Required indicator (*)
- Error message display

**CSS Classes:**
- .input-group
- .input-label
- .input-field
- .input-error
- .input-error-message

##### Loading.jsx
**Amaç:** Loading spinner

**Props:**
- size: 'default' | 'large'
- className: string

**Accessibility:**
- role="status"
- aria-label="Loading"
- .sr-only text

##### Avatar.jsx
**Amaç:** User/AI avatar

**Props:**
- src: string (image URL)
- alt: string
- size: 'default' | 'large'
- variant: 'user' | 'ai'
- initials: string

**Rendering:**
- Image varsa: <img>
- Yoksa: initials veya alt'ın ilk harfi

**CSS Classes:**
- .avatar
- .avatar-large
- .avatar-ai

##### Badge.jsx
**Amaç:** Status badge

**Props:**
- variant: 'info' | 'success' | 'warning' | 'error'
- children: ReactNode

**CSS Classes:**
- .badge
- .badge-{variant}

##### Card.jsx
**Amaç:** Card container

**Props:**
- variant: 'standard' | 'glass'
- title: string
- children: ReactNode

**Structure:**
- .card-header (optional)
- .card-title
- .card-body

### 7. Styles Layer (styles/)

#### variables.css
**Amaç:** CSS Design System değişkenleri

**Kategoriler:**

1. **Primary Colors**
   - --color-vodafone-red: #E60000
   - --color-dark-bg: #1a1a1a
   - --color-charcoal: #333333

2. **Secondary Colors**
   - --color-white: #FFFFFF
   - --color-light-gray: #F5F5F5
   - --color-medium-gray: #999999

3. **Status Colors**
   - --color-success: #4CAF50
   - --color-warning: #FFC107
   - --color-error: #FF5252
   - --color-info: #2196F3

4. **Gradients**
   - --gradient-red
   - --gradient-dark
   - --gradient-light

5. **Glass Effect**
   - --glass-bg: rgba(255, 255, 255, 0.05)
   - --glass-border: rgba(255, 255, 255, 0.1)

6. **Typography**
   - Font family: Inter
   - Font sizes: 10px - 32px
   - Font weights: 400, 500, 600, 700

7. **Spacing**
   - --spacing-xs: 4px
   - --spacing-sm: 8px
   - --spacing-md: 16px
   - --spacing-lg: 24px
   - --spacing-xl: 32px
   - --spacing-2xl: 48px
   - --spacing-3xl: 64px

8. **Border Radius**
   - --radius-small: 4px
   - --radius-medium: 8px
   - --radius-large: 12px
   - --radius-xl: 16px
   - --radius-round: 50%

9. **Shadows**
   - --shadow-small
   - --shadow-medium
   - --shadow-large
   - --shadow-red-glow

10. **Transitions**
    - --transition-fast: 200ms
    - --transition-normal: 300ms
    - --transition-smooth: 300ms cubic-bezier

11. **Z-Index Layers**
    - --z-index-base: 1
    - --z-index-dropdown: 100
    - --z-index-modal: 500
    - --z-index-tooltip: 700

#### global.css
**Amaç:** Global stiller ve reset

**İçerik:**

1. **CSS Reset**
   - box-sizing: border-box
   - margin/padding reset
   - Font smoothing

2. **Typography**
   - Heading styles (h1-h6)
   - Paragraph styles
   - Link styles

3. **Form Elements**
   - Button reset
   - Input/textarea/select styles
   - Focus states

4. **Scrollbar Styling**
   - Custom scrollbar (8px width)
   - Dark theme colors
   - Hover effects

5. **Selection**
   - Vodafone red background
   - White text

6. **Focus Visible**
   - 2px red outline
   - 2px offset

7. **Accessibility**
   - .sr-only class
   - .skip-link class

8. **Utility Classes**
   - .container
   - .flex, .flex-col
   - .items-center, .justify-center
   - .gap-sm, .gap-md, .gap-lg
   - .text-center, .text-right
   - .hidden, .visible, .invisible

## Vite Konfigürasyonu

### vite.config.js

**Plugins:**
- @vitejs/plugin-react - React support

**Dev Server:**
```javascript
{
  port: 3000,
  proxy: {
    '/api': {
      target: 'http://localhost:8080',
      changeOrigin: true
    }
  }
}
```

**Build:**
```javascript
{
  outDir: 'dist',
  sourcemap: true
}
```

**Proxy Stratejisi:**
- Development'ta backend'e proxy
- Production'da nginx reverse proxy

## Routing Yapısı

### Route Tanımları

```javascript
/                 → Navigate to /login
/login            → LoginPage (Public)
/chat             → ChatPage (Protected with PrivateRoute)
```

### Protected Routes

**PrivateRoute Component:**
- isAuthenticated kontrolü
- False ise: Navigate to /login
- True ise: children render

**Usage:**
```jsx
<Route path="/chat" element={
  <PrivateRoute>
    <ChatPage />
  </PrivateRoute>
} />
```

## State Management Stratejisi

### Local State (useState)
**Kullanım Alanları:**
- Form inputs
- UI toggles
- Component-specific state

**Örnekler:**
- LoginPage: formData, errors, isLoading
- ChatInput: message
- FeedbackButtons: feedback, isSubmitting
- CodeBlock: copied

### Context State (useContext)
**Kullanım Alanları:**
- Global authentication
- Chat messages
- Shared UI state

**Contexts:**
1. **AuthContext**
   - user, token, isAuthenticated
   - login, logout

2. **ChatContext**
   - messages, isLoading, error
   - addUserMessage, addAIMessage
   - updateMessageFeedback, clearMessages

### LocalStorage Persistence
**Stored Data:**
- token: JWT authentication token
- user: User object (JSON string)

**Lifecycle:**
- Login: Save to localStorage
- Logout: Remove from localStorage
- App mount: Load from localStorage

## API Communication

### Request Flow

```
Component
    ↓
Service (authService/chatService)
    ↓
API Instance (axios)
    ↓
Request Interceptor (add token)
    ↓
Backend API
    ↓
Response Interceptor (handle errors)
    ↓
Service
    ↓
Component (update state)
```

### Error Handling

**Levels:**

1. **Service Level**
   - try-catch blocks
   - Error transformation
   - Console logging

2. **Interceptor Level**
   - 401 handling (auto logout)
   - Global error logging

3. **Component Level**
   - Error state management
   - User feedback (error messages)

### Authentication Flow

```
1. User submits login form
2. LoginPage calls authService.login()
3. authService posts to /api/auth/login
4. Backend validates credentials
5. Backend returns { token, user }
6. authService returns response
7. LoginPage calls AuthContext.login()
8. AuthContext saves to localStorage
9. Navigate to /chat
10. Subsequent requests include token
```

### Chat Flow

```
1. User types message
2. ChatInput calls addUserMessage()
3. Message added to ChatContext
4. ChatInput calls chatService.sendMessage()
5. API request with Authorization header
6. Backend processes with LLM
7. Backend returns { response, messageId }
8. ChatInput calls addAIMessage()
9. AI message added to ChatContext
10. MessageList re-renders
```

## Component Composition Patterns

### Container/Presentational Pattern

**Container Components:**
- ChatContainer
- LoginPage
- ChatPage

**Presentational Components:**
- Button
- Input
- Avatar
- Badge
- Card

### Compound Components

**MessageItem Pattern:**
```jsx
<MessageItem message={message}>
  {type === 'user' ? <UserMessage /> : <AIMessage />}
</MessageItem>
```

### Render Props Pattern

**Not used extensively, but available for:**
- Custom hooks return values
- Context consumers

### Custom Hooks Pattern

**Implemented:**
- useAuth() - AuthContext consumer
- useChat() - ChatContext consumer

**Benefits:**
- Encapsulation
- Reusability
- Type safety (with proper usage)

## Performance Optimizations

### React Optimizations

1. **useCallback**
   - ChatContext metodları
   - Event handler'lar

2. **useRef**
   - messagesEndRef (auto-scroll)
   - textareaRef (auto-resize)

3. **Conditional Rendering**
   - Empty states
   - Loading states
   - Error states

### Build Optimizations

1. **Vite Features**
   - Fast HMR (Hot Module Replacement)
   - Optimized bundling
   - Tree shaking
   - Code splitting

2. **Production Build**
   - Minification
   - Source maps
   - Asset optimization

### Network Optimizations

1. **Axios Interceptors**
   - Request/response logging
   - Token caching
   - Error handling

2. **API Timeout**
   - 30 second timeout
   - Prevents hanging requests

## Accessibility (a11y)

### Implemented Features

1. **Semantic HTML**
   - Proper heading hierarchy
   - Form labels
   - Button types

2. **ARIA Attributes**
   - aria-label on icon buttons
   - role="status" on loading
   - .sr-only for screen readers

3. **Keyboard Navigation**
   - Tab order
   - Enter to submit
   - Focus visible styles

4. **Focus Management**
   - :focus-visible styles
   - 2px red outline
   - Skip links

### Improvements Needed

⚠️ Code syntax highlighting için accessibility
⚠️ Chat messages için ARIA live regions
⚠️ Modal/dialog accessibility
⚠️ Keyboard shortcuts documentation

## Styling Architecture

### CSS Methodology

**Approach:** BEM-inspired class naming

**Examples:**
- .sidebar
- .sidebar-header
- .sidebar-menu-title
- .message-user
- .message-bubble

### CSS Organization

**File Structure:**
1. variables.css - Design tokens
2. global.css - Reset & base styles
3. components.css - Component styles
4. layouts.css - Layout styles
5. chat.css - Chat-specific styles

### Responsive Design

**Strategy:**
- Mobile-first approach
- CSS Grid & Flexbox
- Media queries (to be implemented)

**Breakpoints (recommended):**
- Mobile: < 768px
- Tablet: 768px - 1024px
- Desktop: > 1024px

## Deployment Architecture

### Build Process

```bash
npm run build
  ↓
Vite build
  ↓
dist/ folder
  ↓
Docker image
  ↓
Nginx serves static files
```

### Docker Container

**Dockerfile:**
- Multi-stage build
- Node.js build stage
- Nginx runtime stage
- Port 80 expose

### Nginx Configuration

**Features:**
- Static file serving
- Gzip compression
- SPA routing (try_files)
- API proxy (optional)

### Environment Configuration

**Runtime Config (env.sh):**
```javascript
window.ENV = {
  VITE_API_URL: process.env.VITE_API_URL
}
```

**Injection:**
- env.sh generates config.js
- index.html loads config.js
- api.js reads window.ENV

## Security Best Practices

### Implemented

✅ JWT token in localStorage
✅ Authorization header
✅ Auto logout on 401
✅ HTTPS (production)
✅ Input validation
✅ XSS protection (React default)

### Recommendations

⚠️ HttpOnly cookies (instead of localStorage)
⚠️ CSRF protection
⚠️ Content Security Policy (CSP)
⚠️ Rate limiting (backend)
⚠️ Input sanitization (code blocks)

## Testing Strategy

### Current State
- No tests implemented (Phase 1.1)

### Recommended Tests

1. **Unit Tests**
   - Service functions
   - Utility functions
   - Custom hooks

2. **Component Tests**
   - Button, Input, Avatar
   - Message components
   - Form validation

3. **Integration Tests**
   - Login flow
   - Chat flow
   - Routing

4. **E2E Tests**
   - User journey
   - Authentication
   - Chat interaction

### Testing Tools (Recommended)

- **Vitest** - Unit testing
- **React Testing Library** - Component testing
- **Playwright** - E2E testing

## Error Handling Strategy

### Levels

1. **Service Level**
```javascript
try {
  const response = await api.post(...)
  return response.data
} catch (error) {
  throw error.response?.data || { message: 'Failed' }
}
```

2. **Component Level**
```javascript
try {
  await authService.login(...)
  navigate('/chat')
} catch (error) {
  setApiError(error.message)
}
```

3. **Context Level**
```javascript
setErrorState(error.message)
```

4. **Interceptor Level**
```javascript
if (error.response?.status === 401) {
  // Auto logout
}
```

### User Feedback

**Methods:**
- Error messages (inline)
- Toast notifications (to be implemented)
- Loading states
- Disabled states

## Future Enhancements (Roadmap)

### Phase 2 - Enhanced Features

- Chat history persistence
- Multi-session support
- File upload
- Voice input
- Export chat

### Phase 3 - Advanced UI

- Dark/light theme toggle
- Customizable sidebar
- Keyboard shortcuts
- Advanced code highlighting
- Markdown rendering

### Phase 4 - Enterprise Features

- Multi-language support (i18n)
- Advanced analytics
- User preferences
- Notification system
- Offline support (PWA)

## Sonuç

GENAI-OPS Frontend, modern React best practice'lerini takip eden, temiz ve maintainable bir mimari sunar. Context API ile state management, service layer ile API abstraction ve component-based architecture ile modüler bir yapı sağlar.

**Güçlü Yönler:**
- Temiz component hiyerarşisi
- Context API ile global state
- Service layer abstraction
- Reusable UI components
- Vodafone design system
- Responsive layout
- Accessibility features

**İyileştirme Alanları:**
- Test coverage
- Error boundaries
- Performance monitoring
- Advanced accessibility
- Internationalization
- Progressive Web App features
