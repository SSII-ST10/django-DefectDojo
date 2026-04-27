#!/bin/bash
# scripts/send_to_defectdojo.sh - Versión estable para Windows + GitHub Actions

REPORT_FILE="$1"
SCAN_TYPE="$2"

if [ -z "$REPORT_FILE" ] || [ -z "$SCAN_TYPE" ]; then
    echo "❌ Uso: $0 <ruta_reporte> <scan_type>"
    exit 1
fi

if [ ! -f "$REPORT_FILE" ]; then
    echo "❌ Error: El archivo $REPORT_FILE no existe"
    exit 1
fi

echo "📤 Enviando '$SCAN_TYPE' desde $REPORT_FILE → DefectDojo..."
echo "   URL: $DEFECTDOJO_URL"
echo "   Engagement: $DEFECTDOJO_ENGAGEMENT_ID"
echo "   Product: $DEFECTDOJO_PRODUCT_NAME"

# Versión simple y explícita
curl -v -X POST "${DEFECTDOJO_URL}/api/v2/import-scan/" \
    -H "Authorization: Token ${DEFECTDOJO_API_KEY}" \
    -H "accept: application/json" \
    -F "file=@${REPORT_FILE}" \
    -F "scan_type=Generic Findings Import" \
    -F "engagement=${DEFECTDOJO_ENGAGEMENT_ID}" \
    -F "product_name=${DEFECTDOJO_PRODUCT_NAME}" \
    -F "engagement_name=engadgement" \
    -F "auto_create_context=true" \
    -F "active=true" \
    -F "minimum_severity=Info" \
    -F "close_old_findings=true" \
    -F "tags=github-actions,pai4"

echo ""
echo "Comando curl finalizado (código de salida: $?)"