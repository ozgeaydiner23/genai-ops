import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import authService from '../services/authService'
import Button from '../components/common/Button'
import Input from '../components/common/Input'
import Loading from '../components/common/Loading'

const LoginPage = () => {
  const navigate = useNavigate()
  const { login } = useAuth()
  
  const [formData, setFormData] = useState({
    username: '',
    password: '',
  })
  const [errors, setErrors] = useState({})
  const [isLoading, setIsLoading] = useState(false)
  const [apiError, setApiError] = useState('')

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }))
    // Clear error when user types
    if (errors[name]) {
      setErrors((prev) => ({
        ...prev,
        [name]: '',
      }))
    }
    setApiError('')
  }

  const validateForm = () => {
    const newErrors = {}

    if (!formData.username.trim()) {
      newErrors.username = 'Username is required'
    }

    if (!formData.password) {
      newErrors.password = 'Password is required'
    } else if (formData.password.length < 3) {
      newErrors.password = 'Password must be at least 3 characters'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setApiError('')

    if (!validateForm()) {
      return
    }

    setIsLoading(true)

    try {
      const response = await authService.login(
        formData.username,
        formData.password
      )
      
      // Login successful
      login(response.user, response.token)
      navigate('/chat')
    } catch (error) {
      console.error('Login error:', error)
      setApiError(
        error.message || 'Login failed. Please check your credentials.'
      )
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="login-container">
      <div className="login-card">
        {/* Logo */}
        <div className="login-logo">
          <svg
            width="64"
            height="64"
            viewBox="0 0 64 64"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <circle cx="32" cy="32" r="32" fill="#E60000" />
            <path
              d="M32 16L44 28L32 40L20 28L32 16Z"
              fill="white"
              opacity="0.9"
            />
            <circle cx="32" cy="32" r="6" fill="white" />
          </svg>
          <h1 style={{ 
            fontSize: '24px', 
            fontWeight: 'bold', 
            color: '#333', 
            marginTop: '16px' 
          }}>
            GENAI-OPS
          </h1>
        </div>

        {/* Header */}
        <div className="login-header">
          <h2 className="login-title">Welcome Back</h2>
          <p className="login-subtitle">Sign in to your account</p>
        </div>

        {/* Form */}
        <form className="login-form" onSubmit={handleSubmit}>
          <Input
            label="Username"
            type="text"
            name="username"
            placeholder="Enter your username"
            value={formData.username}
            onChange={handleChange}
            error={errors.username}
            disabled={isLoading}
            required
          />

          <Input
            label="Password"
            type="password"
            name="password"
            placeholder="Enter your password"
            value={formData.password}
            onChange={handleChange}
            error={errors.password}
            disabled={isLoading}
            required
          />

          {apiError && (
            <div className="message-error" style={{ marginTop: '8px' }}>
              <span>⚠️</span>
              <span>{apiError}</span>
            </div>
          )}

          <Button
            type="submit"
            variant="primary"
            className="login-submit"
            disabled={isLoading}
          >
            {isLoading ? (
              <>
                <Loading size="default" />
                <span>Signing in...</span>
              </>
            ) : (
              'Sign In'
            )}
          </Button>
        </form>

        {/* Forgot Password */}
        <div className="login-forgot">
          <a href="#" className="login-forgot-link">
            Forgot Password?
          </a>
        </div>
      </div>
    </div>
  )
}

export default LoginPage
