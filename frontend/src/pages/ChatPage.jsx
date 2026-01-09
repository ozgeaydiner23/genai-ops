import React from 'react'
import Sidebar from '../components/layout/Sidebar'
import ChatHeader from '../components/layout/ChatHeader'
import ChatContainer from '../components/chat/ChatContainer'
import ChatInput from '../components/chat/ChatInput'

const ChatPage = () => {
  return (
    <div className="app-container">
      <Sidebar />
      <div className="main-content">
        <div className="chat-container">
          <ChatHeader />
          <ChatContainer />
          <ChatInput />
        </div>
      </div>
    </div>
  )
}

export default ChatPage
