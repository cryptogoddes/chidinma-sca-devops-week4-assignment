#!/bin/bash
# Week 4 Assessment: Database Backup Script (Fixed)
set -e

# 1. Update this to your EXACT bucket name from the AWS Console
BUCKET_NAME="wordpress-backup-chidinmanwamadu-2026-904690835815-us-east-1-an"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)
BACKUP_FILE="backup-$TIMESTAMP.sql"

echo "Starting database backup..."

# 2. Run mysqldump with the --no-tablespaces flag to fix the permission error
docker exec mysql_db mysqldump --no-tablespaces -u wp_user -pwp_password123 wordpress_db > $BACKUP_FILE

echo "Backup created: $BACKUP_FILE"

# 3. Upload to S3
echo "Uploading to S3 bucket: $BUCKET_NAME"
aws s3 cp $BACKUP_FILE s3://$BUCKET_NAME/backups/$BACKUP_FILE

echo "Success! Your backup is stored in S3."

# Clean up local file
rm $BACKUP_FILE
