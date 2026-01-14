#!/bin/bash
# Frontend pod'unda nginx proxy'nin çalışıp çalışmadığını test et

echo "=== Testing Frontend to Backend Connection ==="

POD=$(oc get pod -n genai-ops -l component=frontend -o jsonpath='{.items[0].metadata.name}')
echo "Frontend Pod: $POD"

echo -e "\n=== 1. Checking Nginx Config ==="
oc exec -n genai-ops $POD -- cat /etc/nginx/conf.d/default.conf | grep -A 10 "location /api/"

echo -e "\n=== 2. Testing Backend Service DNS ==="
oc exec -n genai-ops $POD -- nslookup genai-ops-backend

echo -e "\n=== 3. Testing Backend Health Endpoint ==="
oc exec -n genai-ops $POD -- wget -O- --timeout=5 http://genai-ops-backend:8080/actuator/health 2>&1

echo -e "\n=== 4. Testing API Login Endpoint via Proxy ==="
oc exec -n genai-ops $POD -- wget -O- --timeout=5 http://localhost:8080/api/actuator/health 2>&1

echo -e "\n=== 5. Checking Frontend Logs ==="
oc logs -n genai-ops $POD --tail=20
