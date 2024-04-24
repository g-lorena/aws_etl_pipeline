import requests
#from dotenv import load_dotenv
import os

from datetime import timedelta, datetime

DST_BUCKET = os.environ.get('DST_BUCKET')
REGION = os.environ.get('REGION')
RAW_FOLDER = os.environ.get('RAW_FOLDER')
s3 = boto3.resource('s3', region_name=REGION)

def lambda_handler(event, context):
    rapid_api_key = os.environ['API_KEY']
    rapid_api_host = os.environ['API_HOST']
    headers = {
        "X-RapidAPI-Key": rapid_api_key,
        "X-RapidAPI-Host": rapid_api_host
    }

    url = "https://zillow56.p.rapidapi.com/search"

    querystring = {"location":"houston, tx"}


    response = requests.get(url, headers=headers, params=querystring)

    #print(response.json())
    
    if response.status_code == 200:
        data = json.loads(response.text)
        extracted_data = data["results"]

        s3_client = boto3.client('s3')
        s3_client.put_object(
            Bucket=DST_BUCKET,
            Key=f"{RAW_FOLDER}/extract_data.json",
            Body=json.dumps(extracted_data)
        )

        return {
            'statusCode': 200,
            'body': json.dumps('Data extraction and S3 upload successful!')
        }
    else:
        return {
            'statusCode': response.status_code,
            'body': json.dumps(f'Error fetching data: {response.text}')
        }