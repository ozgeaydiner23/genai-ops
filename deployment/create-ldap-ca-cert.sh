#!/bin/bash
# Vpara LDAP Root CA Certificate ConfigMap oluştur

set -e

echo "=== Creating Vpara LDAP CA Certificate ConfigMap ==="

# CA sertifika dosyasının yolunu belirt
CA_CERT_FILE="vpara-root-ca.crt"

if [ ! -f "$CA_CERT_FILE" ]; then
  echo "❌ Error: CA certificate file not found: $CA_CERT_FILE"
  echo ""
  echo "Please obtain the Vpara Root CA certificate and save it as: $CA_CERT_FILE"
  echo ""
  echo "To export from LDAP server:"
  echo "  openssl s_client -connect 172.31.234.41:636 -showcerts < /dev/null 2>/dev/null | openssl x509 -outform PEM > vpara-root-ca.crt"
  echo ""
  echo "Or from Windows:"
  echo "  1. Open certmgr.msc"
  echo "  2. Navigate to Trusted Root Certification Authorities > Certificates"
  echo "  3. Find Vpara Root CA"
  echo "  4. Right-click > All Tasks > Export"
  echo "  5. Choose Base-64 encoded X.509 (.CER)"
  echo "  6. Save as vpara-root-ca.crt"
  exit 1
fi

echo "✓ Found CA certificate file: $CA_CERT_FILE"

# ConfigMap oluştur
oc create configmap vpara-ldap-ca-cert \
  --from-file=vpara-root-ca.crt=$CA_CERT_FILE \
  -n genai-ops \
  --dry-run=client -o yaml | oc apply -f -

echo "✓ ConfigMap created/updated: vpara-ldap-ca-cert"

# Verify
echo ""
echo "=== Verifying ConfigMap ==="
oc get configmap vpara-ldap-ca-cert -n genai-ops

echo ""
echo "=== ConfigMap Content ==="
oc get configmap vpara-ldap-ca-cert -n genai-ops -o yaml | head -20

echo ""
echo "✓ Done! Now restart backend deployment:"
echo "  oc rollout restart deployment/genai-ops-backend -n genai-ops"
