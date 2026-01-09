import React from 'react'
import Avatar from '../common/Avatar'
import { useAuth } from '../../context/AuthContext'

const UserMessage = ({ message }) => {
  const { user } = useAuth()
  
  const formatTime = (timestamp) => {
    const date = new Date(timestamp)
    return date.toLocaleTimeString('en-US', { 
      hour: '2-digit', 
      minute: '2-digit' 
    })
  }

  return (
    <div className="message message-user">
      <Avatar
        initials={user?.username?.charAt(0).toUpperCase() || 'U'}
        className="message-avatar"
      />
      <div className="message-content">
        <div className="message-bubble">
          <p className="message-text">{message.text}</p>
        </div>
        <span className="message-timestamp">{formatTime(message.timestamp)}</span>
      </div>
    </div>
  )
}

export default UserMessage
