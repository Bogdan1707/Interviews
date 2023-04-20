def lambda_handler(event, context):
    # Get the S3 bucket name and object key from the event
    s3_bucket = event['Records'][0]['s3']['bucket']['name']
    s3_key = event['Records'][0]['s3']['object']['key']
    
    # Specific action, for example, you can print the S3 bucket name and object key
    print(f"S3 bucket name: {s3_bucket}")
    print(f"S3 object key: {s3_key}")