import React from 'react'

const Button = ({
  children,
  variant = 'primary',
  type = 'button',
  disabled = false,
  onClick,
  className = '',
  icon,
  ...props
}) => {
  const baseClass = 'btn'
  const variantClass = `btn-${variant}`
  const classes = `${baseClass} ${variantClass} ${className}`.trim()

  return (
    <button
      type={type}
      className={classes}
      disabled={disabled}
      onClick={onClick}
      {...props}
    >
      {icon && <span className="btn-icon-wrapper">{icon}</span>}
      {children}
    </button>
  )
}

export default Button
