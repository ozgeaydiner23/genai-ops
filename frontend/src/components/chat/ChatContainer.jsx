import React, { useEffect, useRef } from 'react'
import { useChat } from '../../context/ChatContext'
import MessageList from './MessageList'
import TypingIndicator from './TypingIndicator'
import { MessageSquare } from 'lucide-react'

const ChatContainer = () => {
  const { messages, isLoading, error } = useChat()
  const messagesEndRef = useRef(null)

  // Auto-scroll to bottom when new messages arrive
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages, isLoading])

  return (
    <div className="messages-container">
      <div className="messages-wrapper">
        {messages.length === 0 && !isLoading ? (
          <div className="chat-empty-state">
            <MessageSquare className="chat-empty-icon" size={64} />
            <h3 className="chat-empty-title">Start a Conversation</h3>
            <p className="chat-empty-description">
              Ask me anything about operations, troubleshooting, or system issues.
              I'm here to help!
            </p>
          </div>
        ) : (
          <>
            <MessageList messages={messages} />
            {isLoading && <TypingIndicator />}
            {error && (
              <div className="message-error">
                <span className="message-error-icon">⚠️</span>
                <span>{error}</span>
              </div>
            )}
          </>
        )}
        <div ref={messagesEndRef} />
      </div>
    </div>
  )
}

export default ChatContainer
