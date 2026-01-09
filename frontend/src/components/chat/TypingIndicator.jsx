import React from 'react'
import Avatar from '../common/Avatar'

const TypingIndicator = () => {
  return (
    <div className="message message-ai">
      <Avatar
        variant="ai"
        initials="AI"
        className="message-avatar"
      />
      <div className="message-content">
        <div className="typing-indicator">
          <div className="typing-dot"></div>
          <div className="typing-dot"></div>
          <div className="typing-dot"></div>
        </div>
      </div>
    </div>
  )
}

export default TypingIndicator
