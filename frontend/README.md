# GENAI-OPS Frontend

AI-powered operations assistant chatbot interface built with React 18 and Vite.

## Tech Stack

- **Framework:** React 18.x
- **Build Tool:** Vite
- **Styling:** Custom CSS (design.md specifications)
- **State Management:** React Context API
- **HTTP Client:** Axios
- **Icons:** Lucide React
- **Router:** React Router DOM

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn

### Installation

```bash
npm install
```

### Development

```bash
npm run dev
```

Server runs on http://localhost:3000

### Build

```bash
npm run build
```

### Preview Production Build

```bash
npm run preview
```

## Project Structure

```
frontend/
├── public/              # Static assets
├── src/
│   ├── components/      # React components
│   │   ├── common/      # Reusable components
│   │   ├── layout/      # Layout components
│   │   └── chat/        # Chat-specific components
│   ├── pages/           # Page components
│   ├── context/         # React Context providers
│   ├── services/        # API services
│   ├── styles/          # CSS files
│   ├── utils/           # Utility functions
│   ├── App.jsx          # Main App component
│   └── main.jsx         # Entry point
├── index.html
├── vite.config.js
└── package.json
```

## Design System

All UI components follow the design specifications in `design.md`:
- Vodafone Red (#E60000) as primary color
- Dark theme for chat interface
- Custom CSS with design tokens
- Glassmorphism effects
- Smooth animations

## API Integration

Backend API runs on http://localhost:8080

Endpoints:
- POST /api/auth/login
- POST /api/chat/message
- POST /api/chat/feedback

## Environment Variables

Create `.env` file:

```
VITE_API_URL=http://localhost:8080
```
