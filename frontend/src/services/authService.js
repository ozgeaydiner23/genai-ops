import api from './api'

const authService = {
  /**
   * Login with username and password
   * @param {string} username
   * @param {string} password
   * @returns {Promise<{token: string, user: object}>}
   */
  login: async (username, password) => {
    try {
      const response = await api.post('/api/auth/login', {
        username,
        password,
      })
      return response.data
    } catch (error) {
      throw error.response?.data || { message: 'Login failed' }
    }
  },

  /**
   * Logout current user
   */
  logout: () => {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  },

  /**
   * Check if user is authenticated
   * @returns {boolean}
   */
  isAuthenticated: () => {
    const token = localStorage.getItem('token')
    return !!token
  },

  /**
   * Get current user from localStorage
   * @returns {object|null}
   */
  getCurrentUser: () => {
    const userStr = localStorage.getItem('user')
    return userStr ? JSON.parse(userStr) : null
  },
}

export default authService
