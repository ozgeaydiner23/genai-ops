import React, { useState } from 'react'
import { Copy, Check } from 'lucide-react'

const CodeBlock = ({ language, code }) => {
  const [copied, setCopied] = useState(false)

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(code)
      setCopied(true)
      setTimeout(() => setCopied(false), 2000)
    } catch (err) {
      console.error('Failed to copy code:', err)
    }
  }

  return (
    <div className="code-block">
      <div className="code-header">
        <span className="code-language">{language}</span>
        <button
          className="code-copy-btn"
          onClick={handleCopy}
          aria-label="Copy code"
        >
          {copied ? (
            <>
              <Check size={16} />
              <span>Copied!</span>
            </>
          ) : (
            <>
              <Copy size={16} />
              <span>Copy code</span>
            </>
          )}
        </button>
      </div>
      <div className="code-content">
        <pre>{code}</pre>
      </div>
    </div>
  )
}

export default CodeBlock
