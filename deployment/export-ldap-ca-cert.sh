#!/bin/bash
# Vpara LDAP sunucusundan CA sertifikasını export et

LDAP_HOST="172.31.234.41"
LDAP_PORT="636"
OUTPUT_FILE="vpara-root-ca.crt"

echo "=== Exporting CA Certificate from LDAP Server ==="
echo "LDAP Server: ${LDAP_HOST}:${LDAP_PORT}"
echo "Output File: ${OUTPUT_FILE}"
echo ""

# OpenSSL ile sertifikayı al
echo "Connecting to LDAP server..."
echo | openssl s_client -connect ${LDAP_HOST}:${LDAP_PORT} -showcerts 2>/dev/null | \
  openssl x509 -outform PEM > ${OUTPUT_FILE}

if [ -f "${OUTPUT_FILE}" ] && [ -s "${OUTPUT_FILE}" ]; then
  echo "✓ Certificate exported successfully!"
  echo ""
  echo "=== Certificate Details ==="
  openssl x509 -in ${OUTPUT_FILE} -text -noout | grep -E "(Subject:|Issuer:|Not Before|Not After)"
  echo ""
  echo "Next steps:"
  echo "  1. Review the certificate details above"
  echo "  2. Run: ./create-ldap-ca-cert.sh"
else
  echo "❌ Failed to export certificate"
  echo ""
  echo "Alternative methods:"
  echo ""
  echo "1. From Windows (if you have access):"
  echo "   - Open certmgr.msc"
  echo "   - Trusted Root Certification Authorities > Certificates"
  echo "   - Find Vpara Root CA"
  echo "   - Right-click > All Tasks > Export"
  echo "   - Base-64 encoded X.509 (.CER)"
  echo "   - Save as ${OUTPUT_FILE}"
  echo ""
  echo "2. From LDAP admin:"
  echo "   - Contact LDAP administrator"
  echo "   - Request Vpara Root CA certificate in PEM format"
  exit 1
fi
