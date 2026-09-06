#!/usr/bin/env bash
set -euo pipefail

PROFILE="devops-lab"
BUCKET="utec-s3-lab-597088017869"

echo "=== Cleanup S3 ==="
echo "Bucket: $BUCKET"

if aws s3api head-bucket \
  --bucket "$BUCKET" \
  --profile "$PROFILE" >/dev/null 2>&1; then

  echo "Eliminando contenido del bucket..."

  aws s3 rm "s3://$BUCKET" \
    --recursive \
    --profile "$PROFILE"

  echo "Eliminando bucket..."

  aws s3api delete-bucket \
    --bucket "$BUCKET" \
    --profile "$PROFILE"

  echo "Bucket $BUCKET eliminado"

else

  echo "El bucket $BUCKET no existe. Nada que limpiar."

fi
