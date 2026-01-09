import React, { useState, useRef, useEffect } from 'react'
import { Send, Paperclip } from 'lucide-react'
import { useChat } from '../../context/ChatContext'
import chatService from '../../services/chatService'

const ChatInput = () => {
  const [message, setMessage] = useState('')
  const textareaRef = useRef(null)
  const { addUserMessage, addAIMessage, setLoadingState, setErrorState } = useChat()

  const handleSubmit = async (e) => {
    e.preventDefault()
    
    if (!message.trim()) return

    const userMessage = message.trim()
    setMessage('')
    
    // Add user message to chat
    addUserMessage(userMessage)
    
    // Set loading state
    setLoadingState(true)
    setErrorState(null)

    try {
      // Send message to backend
      const response = await chatService.sendMessage(userMessage)
      
      // Add AI response to chat
      addAIMessage(response.response, response.messageId)
    } catch (error) {
      console.error('Failed to send message:', error)
      setErrorState(error.message || 'Failed to get response from AI')
    } finally {
      setLoadingState(false)
    }
  }

  const handleKeyDown = (e) => {
    // Submit on Enter (without Shift)
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      handleSubmit(e)
    }
  }

  // Auto-resize textarea
  useEffect(() => {
    if (textareaRef.current) {
      textareaRef.current.style.height = 'auto'
      textareaRef.current.style.height = `${textareaRef.current.scrollHeight}px`
    }
  }, [message])

  return (
    <div className="chat-input-area">
      <div className="chat-input-wrapper">
        <form onSubmit={handleSubmit}>
          <div className="chat-input-container">
            <button
              type="button"
              className="chat-attachment-btn"
              aria-label="Attach file"
            >
              <Paperclip size={20} />
            </button>
            
            <textarea
              ref={textareaRef}
              className="chat-input"
              placeholder="Ask GENAI-OPS anything..."
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              onKeyDown={handleKeyDown}
              rows={1}
              style={{ 
                minHeight: '24px',
                maxHeight: '120px',
                overflow: 'auto',
                resize: 'none'
              }}
            />
            
            <button
              type="submit"
              className="chat-send-btn"
              disabled={!message.trim()}
              aria-label="Send message"
            >
              <Send size={20} />
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default ChatInput
