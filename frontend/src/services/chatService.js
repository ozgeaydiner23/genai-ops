import api from './api'

const chatService = {
  /**
   * Send a message to the AI chatbot
   * @param {string} message - User message
   * @returns {Promise<{response: string, messageId: string, timestamp: string}>}
   */
  sendMessage: async (message) => {
    try {
      const response = await api.post('/api/chat/message', {
        message,
      })
      return response.data
    } catch (error) {
      console.error('[Chat Service] Send message error:', error)
      throw error.response?.data || { message: 'Failed to send message' }
    }
  },

  /**
   * Submit feedback for an AI response
   * @param {string} messageId - ID of the AI message
   * @param {string} feedback - 'like' or 'dislike'
   * @param {string} comment - Optional comment
   * @returns {Promise<{success: boolean}>}
   */
  submitFeedback: async (messageId, feedback, comment = null) => {
    try {
      const response = await api.post('/api/chat/feedback', {
        messageId,
        feedback,
        comment,
      })
      return response.data
    } catch (error) {
      console.error('[Chat Service] Submit feedback error:', error)
      throw error.response?.data || { message: 'Failed to submit feedback' }
    }
  },
}

export default chatService
