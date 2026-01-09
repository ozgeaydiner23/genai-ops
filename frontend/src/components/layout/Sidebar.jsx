import React from 'react'
import { MessageSquare, Plus, FileText, Wrench, LogOut } from 'lucide-react'
import { useAuth } from '../../context/AuthContext'
import { useNavigate } from 'react-router-dom'
import Button from '../common/Button'
import Avatar from '../common/Avatar'

const Sidebar = () => {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  const handleNewChat = () => {
    // TODO: Implement new chat functionality
    console.log('New chat clicked')
  }

  return (
    <div className="sidebar">
      {/* Header */}
      <div className="sidebar-header">
        <div className="sidebar-logo">
          <svg
            width="32"
            height="32"
            viewBox="0 0 64 64"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <circle cx="32" cy="32" r="32" fill="#E60000" />
            <path
              d="M32 16L44 28L32 40L20 28L32 16Z"
              fill="white"
              opacity="0.9"
            />
            <circle cx="32" cy="32" r="6" fill="white" />
          </svg>
          <span>GENAI-OPS</span>
        </div>
        <p className="sidebar-subtitle">AI Operations Assistant</p>
      </div>

      {/* Content */}
      <div className="sidebar-content">
        {/* New Chat Button */}
        <Button
          variant="primary"
          onClick={handleNewChat}
          icon={<Plus size={20} />}
          style={{ width: '100%', marginBottom: '24px' }}
        >
          New Chat
        </Button>

        {/* Quick Actions */}
        <div className="sidebar-menu">
          <h3 className="sidebar-menu-title">QUICK ACTIONS</h3>
          <button className="sidebar-item">
            <FileText className="sidebar-item-icon" size={20} />
            <span>Analyze Logs</span>
          </button>
          <button className="sidebar-item">
            <Wrench className="sidebar-item-icon" size={20} />
            <span>Suggest Fix</span>
          </button>
          <button className="sidebar-item">
            <FileText className="sidebar-item-icon" size={20} />
            <span>View Docs</span>
          </button>
        </div>

        {/* History */}
        <div className="sidebar-menu">
          <h3 className="sidebar-menu-title">HISTORY</h3>
          <button className="sidebar-item active">
            <MessageSquare className="sidebar-item-icon" size={20} />
            <span>Current Session</span>
          </button>
        </div>
      </div>

      {/* Footer */}
      <div className="sidebar-footer">
        <div style={{ 
          display: 'flex', 
          alignItems: 'center', 
          gap: '12px',
          padding: '8px',
          borderRadius: '8px',
          cursor: 'pointer',
          transition: 'background 0.2s'
        }}
        onMouseEnter={(e) => e.currentTarget.style.background = 'rgba(255,255,255,0.05)'}
        onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
        >
          <Avatar
            initials={user?.username?.charAt(0).toUpperCase() || 'U'}
            size="large"
          />
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ 
              fontSize: '14px', 
              fontWeight: '500',
              color: 'white',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap'
            }}>
              {user?.username || 'User'}
            </div>
            <button
              onClick={handleLogout}
              style={{
                fontSize: '12px',
                color: '#999',
                background: 'none',
                border: 'none',
                padding: 0,
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                gap: '4px'
              }}
            >
              <LogOut size={12} />
              Logout
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Sidebar
