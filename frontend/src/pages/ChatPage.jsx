import React from 'react'
import Sidebar from '../components/layout/Sidebar'
import ChatHeader from '../components/layout/ChatHeader'

const ChatPage = () => {
  return (
    <div className="app-container">
      <Sidebar />
      <div className="main-content">
        <div className="chat-container" style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
          <ChatHeader />
          <div style={{ flex: 1, overflow: 'hidden' }}>
            <iframe 
              src="https://practicus.vodafone.local/apps/it-genai-ops/v43/"
              style={{ 
                width: '100%', 
                height: '100%', 
                border: 'none',
                display: 'block'
              }}
              title="Practicus GenAI-OPS"
              allow="clipboard-read; clipboard-write"
            />
          </div>
        </div>
      </div>
    </div>
  )
}

export default ChatPage
