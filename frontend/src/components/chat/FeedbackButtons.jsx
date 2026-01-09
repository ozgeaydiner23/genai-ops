import React, { useState } from 'react'
import { ThumbsUp, ThumbsDown } from 'lucide-react'
import { useChat } from '../../context/ChatContext'
import chatService from '../../services/chatService'

const FeedbackButtons = ({ messageId, currentFeedback }) => {
  const [feedback, setFeedback] = useState(currentFeedback)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const { updateMessageFeedback } = useChat()

  const handleFeedback = async (type) => {
    // If clicking the same feedback, do nothing
    if (feedback === type) return

    setIsSubmitting(true)

    try {
      await chatService.submitFeedback(messageId, type)
      
      // Update local state
      setFeedback(type)
      updateMessageFeedback(messageId, type)
      
      console.log(`Feedback "${type}" submitted for message ${messageId}`)
    } catch (error) {
      console.error('Failed to submit feedback:', error)
      // Optionally show error notification
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="feedback-buttons">
      <button
        className={`feedback-btn ${feedback === 'like' ? 'liked' : ''}`}
        onClick={() => handleFeedback('like')}
        disabled={isSubmitting}
        aria-label="Like this response"
      >
        <ThumbsUp size={14} />
        <span>Helpful</span>
      </button>
      
      <button
        className={`feedback-btn ${feedback === 'dislike' ? 'disliked' : ''}`}
        onClick={() => handleFeedback('dislike')}
        disabled={isSubmitting}
        aria-label="Dislike this response"
      >
        <ThumbsDown size={14} />
        <span>Not Helpful</span>
      </button>
    </div>
  )
}

export default FeedbackButtons
