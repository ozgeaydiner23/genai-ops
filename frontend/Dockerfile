# Multi-stage build for React frontend
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build argument for API URL (can be overridden at build time)
ARG VITE_API_URL=http://localhost:8080
ENV VITE_API_URL=$VITE_API_URL

# Build the app
RUN npm run build

# Production stage with nginx (OpenShift compatible)
FROM nginx:alpine

# Create nginx user and set permissions for OpenShift
RUN chgrp -R 0 /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R g+rwX /var/cache/nginx /var/run /var/log/nginx && \
    rm /etc/nginx/conf.d/default.conf

# Copy built files to nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Set permissions for html directory
RUN chgrp -R 0 /usr/share/nginx/html && \
    chmod -R g+rwX /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Use non-root user (OpenShift will override this with random UID)
USER 1001

# Expose port 8080 (OpenShift default)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
