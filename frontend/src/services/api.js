import axios from 'axios'

// Get API URL from runtime config (injected by env.sh) or build-time env
// Empty string means use relative path (same origin via nginx proxy)
const API_BASE_URL = window.ENV?.VITE_API_URL || import.meta.env.VITE_API_URL || ''

// Create axios instance
const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 30000, // 30 seconds
})

// Request interceptor - Add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    console.log(`[API Request] ${config.method.toUpperCase()} ${config.url}`, config.data)
    return config
  },
  (error) => {
    console.error('[API Request Error]', error)
    return Promise.reject(error)
  }
)

// Response interceptor - Handle errors
api.interceptors.response.use(
  (response) => {
    console.log(`[API Response] ${response.config.url}`, response.data)
    return response
  },
  (error) => {
    console.error('[API Response Error]', error.response || error)
    
    // Handle 401 Unauthorized
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/login'
    }
    
    return Promise.reject(error)
  }
)

export default api
