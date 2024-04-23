import os
import json
import requests
from pathlib import Path
from datetime import datetime
#import boto3

DST_BUCKET = os.environ.get('DST_BUCKET')
REGION = os.environ.get('REGION')
RAW_FOLDER = os.environ.get('RAW_FOLDER')
API_KEY = os.environ.get('API_KEY')
API_HOST = os.environ.get('API_HOST')
URL = "https://zillow56.p.rapidapi.com/search"
QUERY = {"location": "houston, tx"}


def lambda_handler(event, context):
    data = fetch_api_data(API_KEY, API_HOST, URL, QUERY)
    folder_path = f"{RAW_FOLDER}/"
    timestamp = get_timestamp()
    file_name = f"api_request_{timestamp}.json"
    save_json_to_workspace(data, folder_path, file_name)
    #upload_to_s3(folder_path, DST_BUCKET, file_name)  # Call this method in cloud environment

def fetch_api_data(api_key, api_host, url, query): 
    headers = {
        # mettre api_key et api_host
        "X-RapidAPI-Key": "ee8d4d9ab3mshbfdc8af6048ab19p12715bjsn3bf8b6f98b0d",
        "X-RapidAPI-Host": "zillow56.p.rapidapi.com"
    }
    response = requests.get(url, headers=headers, params=query)
    
    if response.status_code == 200:
        data = json.loads(response.text)
        return data["results"]
    else:
        raise Exception(f'Error fetching data: {response.text}')

def save_json_to_workspace(data, folder_path, file_name):
    # mettre folder_path
    file_path = Path("/Users/tedsamba/Desktop/GLUE") / file_name
    with open(file_path, 'w') as file:
        json.dump(data, file)

def upload_to_s3(folder_path, bucket_name, file_name):
    s3 = boto3.client('s3', region_name=REGION)
    file_path = Path(folder_path) / file_name
    with open(file_path, 'rb') as file:
        s3.upload_fileobj(file, bucket_name, file_name)

def get_timestamp():  
    dt = datetime.now()
    timestamp = str(datetime.timestamp(dt)).replace('.', '_')
    return timestamp

lambda_handler(None, None)
