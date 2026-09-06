#!/usr/bin/env bash
set -euo pipefail

PROFILE="devops-lab"
REGION="us-east-1"
BUCKET="utec-s3-lab-597088017869"
SITE_DIR="site"

echo "=== Deploy S3 Site ==="
echo "Bucket: $BUCKET"
echo "Region: $REGION"

if aws s3api head-bucket \
  --bucket "$BUCKET" \
  --profile "$PROFILE" 2>/dev/null; then

  echo "Bucket ya existe, reutilizando"

else
  echo "Creando bucket..."

  aws s3api create-bucket \
    --bucket "$BUCKET" \
    --region "$REGION" \
    --profile "$PROFILE"

  echo "Bucket creado"
fi

echo "Desactivando bloqueo de acceso público..."

aws s3api put-public-access-block \
  --bucket "$BUCKET" \
  --public-access-block-configuration \
  "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false" \
  --profile "$PROFILE"

echo "Configurando website estático..."

aws s3api put-bucket-website \
  --bucket "$BUCKET" \
  --website-configuration '{
    "IndexDocument": {
      "Suffix": "index.html"
    },
    "ErrorDocument": {
      "Key": "error.html"
    }
  }' \
  --profile "$PROFILE"

echo "Configurando política pública..."

aws s3api put-bucket-policy \
  --bucket "$BUCKET" \
  --profile "$PROFILE" \
  --policy "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
      {
        \"Sid\": \"PublicReadGetObject\",
        \"Effect\": \"Allow\",
        \"Principal\": \"*\",
        \"Action\": \"s3:GetObject\",
        \"Resource\": \"arn:aws:s3:::$BUCKET/*\"
      }
    ]
  }"

echo "Subiendo sitio..."

aws s3 sync "$SITE_DIR/" "s3://$BUCKET/" \
  --delete \
  --profile "$PROFILE"

echo ""
echo "=== Deploy completado ==="
echo "Website:"
echo "http://$BUCKET.s3-website-$REGION.amazonaws.com"
