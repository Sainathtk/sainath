import json
import requests
import os

def lambda_handler(event, context):
    # Retrieve subnet ID dynamically from environment variable
    subnet_id = os.getenv('SUBNET_ID', 'your-subnet-id')

    # Payload data
    payload = {
        "subnet_id": subnet_id,
        "name": "sainath kulsange",  # Replace with your full name
        "email": "sainathkulsange60@example.com"  # Replace with your email
    }

    # API URL and headers
    api_url = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"
    headers = {
        "X-Siemens-Auth": "test"
    }

    # Send POST request
    response = requests.post(api_url, json=payload, headers=headers)

    # Log the response
    print(f"Response: {response.text}")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Request completed successfully')
    }
