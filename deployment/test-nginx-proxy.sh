#!/bin/bash
# Nginx proxy'nin doğru çalışıp çalışmadığını test et

FRONTEND_POD=$(oc get pod -n genai-ops -l component=frontend -o jsonpath='{.items[0].metadata.name}')

echo "=== Testing Nginx Proxy Configuration ==="
echo "Frontend Pod: $FRONTEND_POD"

echo -e "\n1. Nginx Config - API Proxy Location:"
oc exec -n genai-ops $FRONTEND_POD -- cat /etc/nginx/conf.d/default.conf | grep -A 15 "location /api/"

echo -e "\n2. Test Backend Service DNS Resolution:"
oc exec -n genai-ops $FRONTEND_POD -- nslookup genai-ops-backend 2>&1 || echo "DNS lookup failed"

echo -e "\n3. Test Direct Backend Connection:"
oc exec -n genai-ops $FRONTEND_POD -- wget -O- --timeout=5 http://genai-ops-backend:8080/actuator/health 2>&1

echo -e "\n4. Test Nginx Proxy to Backend (via localhost:8080/api/):"
oc exec -n genai-ops $FRONTEND_POD -- wget -O- --timeout=5 http://localhost:8080/api/actuator/health 2>&1

echo -e "\n5. Check Nginx Error Logs:"
oc exec -n genai-ops $FRONTEND_POD -- cat /var/log/nginx/error.log 2>&1 | tail -20

echo -e "\n6. Check Nginx Access Logs:"
oc exec -n genai-ops $FRONTEND_POD -- cat /var/log/nginx/access.log 2>&1 | tail -20

echo -e "\n=== Test Complete ==="
