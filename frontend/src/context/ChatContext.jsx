import React, { createContext, useContext, useState, useCallback } from 'react'

const ChatContext = createContext(null)

export const useChat = () => {
  const context = useContext(ChatContext)
  if (!context) {
    throw new Error('useChat must be used within a ChatProvider')
  }
  return context
}

export const ChatProvider = ({ children }) => {
  const [messages, setMessages] = useState([])
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState(null)

  const addMessage = useCallback((message) => {
    setMessages((prev) => [...prev, message])
  }, [])

  const addUserMessage = useCallback((text) => {
    const message = {
      id: Date.now().toString(),
      type: 'user',
      text,
      timestamp: new Date().toISOString(),
    }
    addMessage(message)
    return message
  }, [addMessage])

  const addAIMessage = useCallback((text, messageId) => {
    const message = {
      id: messageId || Date.now().toString(),
      type: 'ai',
      text,
      timestamp: new Date().toISOString(),
      feedback: null,
    }
    addMessage(message)
    return message
  }, [addMessage])

  const updateMessageFeedback = useCallback((messageId, feedback) => {
    setMessages((prev) =>
      prev.map((msg) =>
        msg.id === messageId ? { ...msg, feedback } : msg
      )
    )
  }, [])

  const clearMessages = useCallback(() => {
    setMessages([])
    setError(null)
  }, [])

  const setLoadingState = useCallback((loading) => {
    setIsLoading(loading)
  }, [])

  const setErrorState = useCallback((error) => {
    setError(error)
  }, [])

  const value = {
    messages,
    isLoading,
    error,
    addUserMessage,
    addAIMessage,
    updateMessageFeedback,
    clearMessages,
    setLoadingState,
    setErrorState,
  }

  return <ChatContext.Provider value={value}>{children}</ChatContext.Provider>
}
