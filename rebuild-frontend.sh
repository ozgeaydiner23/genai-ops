#!/bin/bash
# Frontend'i yeniden build et ve OpenShift'e deploy et

set -e

echo "=== Rebuilding Frontend with Nginx Proxy Configuration ==="

# Registry bilgilerini güncelle
REGISTRY="your-registry"
IMAGE_NAME="genai-ops-frontend"
TAG="latest"

echo -e "\n1. Building frontend Docker image..."
cd frontend
docker build -t ${REGISTRY}/${IMAGE_NAME}:${TAG} .

echo -e "\n2. Pushing image to registry..."
docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}

echo -e "\n3. Updating deployment in OpenShift..."
cd ..
oc apply -f deployment/frontend-deployment.yaml

echo -e "\n4. Restarting frontend pods..."
oc rollout restart deployment/genai-ops-frontend -n genai-ops

echo -e "\n5. Waiting for rollout to complete..."
oc rollout status deployment/genai-ops-frontend -n genai-ops

echo -e "\n6. Checking pod status..."
oc get pods -n genai-ops -l component=frontend

echo -e "\n7. Getting route URL..."
ROUTE_URL=$(oc get route genai-ops -n genai-ops -o jsonpath='{.spec.host}')
echo "Frontend URL: https://${ROUTE_URL}"

echo -e "\n8. Testing config.js..."
FRONTEND_POD=$(oc get pod -n genai-ops -l component=frontend -o jsonpath='{.items[0].metadata.name}')
echo "Checking config.js in pod: $FRONTEND_POD"
oc exec -n genai-ops $FRONTEND_POD -- cat /usr/share/nginx/html/config.js

echo -e "\n=== Rebuild Complete ==="
echo "Please test the application at: https://${ROUTE_URL}"
echo "Clear browser cache or use incognito mode!"
