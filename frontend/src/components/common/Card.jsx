import React from 'react'

const Card = ({
  children,
  variant = 'standard',
  className = '',
  title,
  ...props
}) => {
  const baseClass = variant === 'glass' ? 'card-glass' : 'card'
  const classes = `${baseClass} ${className}`.trim()

  return (
    <div className={classes} {...props}>
      {title && (
        <div className="card-header">
          <h3 className="card-title">{title}</h3>
        </div>
      )}
      <div className="card-body">{children}</div>
    </div>
  )
}

export default Card
