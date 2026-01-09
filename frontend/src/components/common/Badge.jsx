import React from 'react'

const Badge = ({
  children,
  variant = 'info',
  className = '',
  ...props
}) => {
  const classes = `badge badge-${variant} ${className}`.trim()

  return (
    <span className={classes} {...props}>
      {children}
    </span>
  )
}

export default Badge
