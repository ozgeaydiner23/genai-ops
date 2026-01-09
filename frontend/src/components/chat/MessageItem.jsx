import React from 'react'
import UserMessage from './UserMessage'
import AIMessage from './AIMessage'

const MessageItem = ({ message }) => {
  if (message.type === 'user') {
    return <UserMessage message={message} />
  }
  
  if (message.type === 'ai') {
    return <AIMessage message={message} />
  }
  
  return null
}

export default MessageItem
