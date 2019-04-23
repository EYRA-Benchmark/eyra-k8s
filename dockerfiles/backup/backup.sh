#!/bin/sh
export PGPASSWORD="${POSTGRES_PASSWORD:?You must set POSTGRES_PASSWORD}"
pg_dump \
    --dbname="${POSTGRES_DB:?You must set POSTGRES_DB}" \
    --host="${POSTGRES_HOST:?You must set POSTGRES_HOST}" \
    --port="${POSTGRES_PORT:?You must set POSTGRES_PORT}" \
    --username="${POSTGRES_USER:?You must set POSTGRES_USER}" \
    > /tmp/dbdump.sql

BASE_AWS_COMMAND="aws s3 --region=${S3_REGION:?You must set S3_REGION} "
ROOT_URL="s3://${S3_BUCKET:?You must set S3_BUCKET}/${ROOT_FOLDER:?You must set ROOT_FOLDER}"

OUTPUT_URL="${ROOT_URL}/backup_$(date -Iseconds).sql"

aws s3 --region="${S3_REGION:?You must set S3_REGION}" cp /tmp/dbdump.sql "${OUTPUT_URL}"
