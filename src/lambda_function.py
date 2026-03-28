import boto3
from datetime import datetime, timezone, timedelta
from dateutil.relativedelta import relativedelta  # This will handle leap year.
import os
import logging

# Logging setup
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Get environment variables
    retention_days = int(os.getenv('retention_days'))
    region = os.getenv('aws_region')
    
    # Initialize EC2 client
    ec2_client = boto3.client('ec2', region_name=region)
    
    # Calculate cutoff date for deletion
    now = datetime.now(timezone.utc)
    delete_limit_date = now - timedelta(days=retention_days)
    logger.info(f"Searching for snapshots older than: {delete_limit_date.strftime('%Y-%m-%d')}")

    # Get all Snapshots owned by the account
    paginator = ec2_client.get_paginator('describe_snapshots')
   
    deleted_snapshots = []
    skipped_snapshots = []
    delete_snapshots_failed = []
    total_snapshots = 0
    
    for page in paginator.paginate(OwnerIds=['self']):
        total_snapshots += len(page['Snapshots'])   
        # Snanpshot not found
        if total_snapshots == 0:
            logger.info("No snapshots found for this account.") 

        for snapshot in page['Snapshots']:
    
            snapshot_id = snapshot['SnapshotId']
            create_time = snapshot['StartTime'] # Snapshot creation time.
                
            if create_time < delete_limit_date:
                try:
                    logger.info(f"Deleting snapshot: {snapshot_id} created on {create_time.strftime('%Y-%m-%d')}")
                    ec2_client.delete_snapshot(SnapshotId=snapshot_id)
                    deleted_snapshots.append(snapshot_id)
                    logger.info(f"Deleted snapshot: {snapshot_id} created on {create_time.strftime('%Y-%m-%d')}")
                except Exception as e:
                    error_message = f"Error deleting snapshot {snapshot_id}: {e.response['Error']['Code']}"
                    logger.error(error_message)
                    delete_snapshots_failed.append(snapshot_id)
            else:
                skipped_snapshots.append(snapshot_id)
                logger.info(f"Skipping snapshot: {snapshot_id} created on {create_time.strftime('%Y-%m-%d')}") 
        # Snanpshot not found
        if total_snapshots == 0:
            logger.info("No snapshots found for this account.") 

    # Generate report
    report = {
        "total_snapshots": (total_snapshots),
        "deleted_snapshots": len(deleted_snapshots),
        "skipped_snapshots": len(skipped_snapshots),
        "deleted_snapshot_ids": deleted_snapshots,
        "skipped_snapshot_ids": skipped_snapshots,
        "deleted_snapshots_failed": len(delete_snapshots_failed),
        "deleted_snapshots_failed_ids": delete_snapshots_failed
    }        
    logger.info("Deletion Report Summary")
    logger.info(report)
    return {
        "statusCode": 200,
        "body": report
    }       