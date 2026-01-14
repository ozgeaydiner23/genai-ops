#!/bin/bash
# Backend ve Frontend arasındaki bağlantıyı debug et

echo "=== GENAI-OPS Connection Debug ==="

echo -e "\n1. Backend Service Status:"
oc get svc genai-ops-backend -n genai-ops

echo -e "\n2. Backend Endpoints:"
oc get endpoints genai-ops-backend -n genai-ops

echo -e "\n3. Backend Pods:"
oc get pods -n genai-ops -l component=backend

echo -e "\n4. Frontend Pods:"
oc get pods -n genai-ops -l component=frontend

echo -e "\n5. Routes:"
oc get routes -n genai-ops

echo -e "\n6. Backend Health Check:"
BACKEND_POD=$(oc get pod -n genai-ops -l component=backend -o jsonpath='{.items[0].metadata.name}')
if [ ! -z "$BACKEND_POD" ]; then
  echo "Backend Pod: $BACKEND_POD"
  oc exec -n genai-ops $BACKEND_POD -- wget -O- --timeout=5 http://localhost:8080/actuator/health 2>&1
fi

echo -e "\n7. Frontend to Backend Connection Test:"
FRONTEND_POD=$(oc get pod -n genai-ops -l component=frontend -o jsonpath='{.items[0].metadata.name}')
if [ ! -z "$FRONTEND_POD" ]; then
  echo "Frontend Pod: $FRONTEND_POD"
  echo "Testing: http://genai-ops-backend:8080/actuator/health"
  oc exec -n genai-ops $FRONTEND_POD -- wget -O- --timeout=5 http://genai-ops-backend:8080/actuator/health 2>&1
fi

echo -e "\n8. ConfigMap Check:"
oc get configmap genai-ops-config -n genai-ops -o yaml | grep -E "(DB_URL|LDAP_URL|LLM_ENDPOINT)"

echo -e "\n=== Debug Complete ==="
