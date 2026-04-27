#!/bin/bash
# scripts/send_to_defectdojo.sh - Versión final para PAI-4

REPORT_FILE="$1"
SCAN_TYPE="$2"

if [ -z "$REPORT_FILE" ] || [ -z "$SCAN_TYPE" ]; then
    echo "Uso: $0 <ruta_al_reporte> <scan_type>"
    echo "Ejemplo: $0 reports/semgrep-results.json \"Semgrep JSON Report\""
    exit 1
fi

if [ ! -f "$REPORT_FILE" ]; then
    echo "❌ Error: El archivo $REPORT_FILE no existe"
    exit 1
fi

echo "📤 Enviando $SCAN_TYPE → DefectDojo..."

curl -s -X POST "${DEFECTDOJO_URL}/api/v2/import-scan/" \
    -H "Authorization: Token ${DEFECTDOJO_API_KEY}" \
    -H "accept: application/json" \
    -F "file=@${REPORT_FILE}" \
    -F "scan_type=${SCAN_TYPE}" \
    -F "engagement=${DEFECTDOJO_ENGAGEMENT_ID}" \
    -F "product_name=${DEFECTDOJO_PRODUCT_NAME}" \
    -F "engagement_name=engadgement" \
    -F "auto_create_context=true" \
    -F "active=true" \
    -F "verified=false" \
    -F "minimum_severity=Info" \
    -F "close_old_findings=true" \
    -F "tags=github-actions,pai4,automated"

if [ $? -eq 0 ]; then
    echo "✅ Reporte enviado correctamente a DefectDojo"
else
    echo "❌ Error al enviar el reporte"
fi