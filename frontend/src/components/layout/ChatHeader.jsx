import React from 'react'
import { Settings, HelpCircle } from 'lucide-react'

const ChatHeader = () => {
  return (
    <div className="chat-header">
      <div className="chat-header-title">
        GENAI-OPS
      </div>
      <div className="chat-header-actions">
        <button className="btn-icon" aria-label="Help">
          <HelpCircle size={20} />
        </button>
        <button className="btn-icon" aria-label="Settings">
          <Settings size={20} />
        </button>
      </div>
    </div>
  )
}

export default ChatHeader
