import React, { useState } from 'react'
import Avatar from '../common/Avatar'
import FeedbackButtons from './FeedbackButtons'
import CodeBlock from './CodeBlock'

const AIMessage = ({ message }) => {
  const [showFeedback, setShowFeedback] = useState(true)
  
  const formatTime = (timestamp) => {
    const date = new Date(timestamp)
    return date.toLocaleTimeString('en-US', { 
      hour: '2-digit', 
      minute: '2-digit' 
    })
  }

  // Simple code block detection (can be enhanced)
  const hasCodeBlock = message.text.includes('```')
  
  const renderContent = () => {
    if (!hasCodeBlock) {
      return <p className="message-text">{message.text}</p>
    }

    // Split by code blocks
    const parts = message.text.split(/(```[\s\S]*?```)/g)
    
    return parts.map((part, index) => {
      if (part.startsWith('```') && part.endsWith('```')) {
        // Extract language and code
        const content = part.slice(3, -3)
        const lines = content.split('\n')
        const language = lines[0].trim() || 'text'
        const code = lines.slice(1).join('\n')
        
        return <CodeBlock key={index} language={language} code={code} />
      }
      
      return part ? <p key={index} className="message-text">{part}</p> : null
    })
  }

  return (
    <div className="message message-ai">
      <Avatar
        variant="ai"
        initials="AI"
        className="message-avatar"
      />
      <div className="message-content">
        <div className="message-bubble">
          {renderContent()}
        </div>
        <span className="message-timestamp">{formatTime(message.timestamp)}</span>
        {showFeedback && (
          <FeedbackButtons 
            messageId={message.id} 
            currentFeedback={message.feedback}
          />
        )}
      </div>
    </div>
  )
}

export default AIMessage
