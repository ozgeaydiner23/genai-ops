import React from 'react'

const Loading = ({ size = 'default', className = '' }) => {
  const sizeClass = size === 'large' ? 'spinner-large' : ''
  const classes = `spinner ${sizeClass} ${className}`.trim()

  return (
    <div className={classes} role="status" aria-label="Loading">
      <span className="sr-only">Loading...</span>
    </div>
  )
}

export default Loading
