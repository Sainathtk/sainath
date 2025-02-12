import json
import requests
import base64
import os

def lambda_handler(event, context):
    # Retrieve the environment variables set by Terraform
    subnet_id = os.environ['SUBNET_ID']
    name = os.environ['NAME']
    email = os.environ['EMAIL']

    # API endpoint URL
    api_url = 'https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data'

    # Headers to authenticate the request
    headers = {
        'X-Siemens-Auth': 'test'
    }

    # Prepare the payload
    payload = {
        "subnet_id": subnet_id,
        "name": name,
        "email": email
    }

    try:
        # POST request to the API
        response = requests.post(api_url, json=payload, headers=headers)

        # Log the API response
        if response.status_code == 200:
            print(f"Request was successful. Response: {response.text}")

            # Extract LogResult from the response (Base64 encoded)
            log_result_base64 = response.json().get("LogResult")
            if log_result_base64:
                # Decode the base64-encoded result
                decoded_log = base64.b64decode(log_result_base64).decode('utf-8')
                print(f"Decoded LogResult: {decoded_log}")

            return {
                'statusCode': 200,
                'body': json.dumps('Successfully invoked the API.')
            }
        else:
            print(f"Request failed with status code {response.status_code}")
            return {
                'statusCode': response.status_code,
                'body': json.dumps('Failed to invoke the API.')
            }

    except Exception as e:
        # Log error in case of failure
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Error occurred while invoking the API.')
        }
