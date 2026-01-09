import React from 'react'

const Avatar = ({
  src,
  alt = 'Avatar',
  size = 'default',
  variant = 'user',
  initials,
  className = '',
  ...props
}) => {
  const sizeClass = size === 'large' ? 'avatar-large' : ''
  const variantClass = variant === 'ai' ? 'avatar-ai' : ''
  const classes = `avatar ${sizeClass} ${variantClass} ${className}`.trim()

  return (
    <div className={classes} {...props}>
      {src ? (
        <img src={src} alt={alt} />
      ) : (
        <span>{initials || alt.charAt(0).toUpperCase()}</span>
      )}
    </div>
  )
}

export default Avatar
