#!/bin/sh
# Runtime environment variable injection for React app

# Create runtime config file
cat <<EOF > /usr/share/nginx/html/config.js
window.ENV = {
  VITE_API_URL: '${VITE_API_URL:-}'
};
EOF

echo "Runtime config generated:"
cat /usr/share/nginx/html/config.js
