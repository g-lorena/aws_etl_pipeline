import os
import json
import requests
from pathlib import Path
from datetime import datetime
#import boto3
from System.LocalLocation import LocalLocation
from System.workspace import Workspace
import pathlib
import yaml


DST_BUCKET = os.environ.get('DST_BUCKET')
REGION = os.environ.get('REGION')
RAW_FOLDER = os.environ.get('RAW_FOLDER')
API_KEY = os.environ.get('API_KEY')
API_HOST = os.environ.get('API_HOST')
URL = "https://zillow56.p.rapidapi.com/search"

#
country = ["houston","pasadena","katy","Cypress"]

# fonction qui crée les repertoires dans le bucket 
QUERY = {"location": "houston, tx"}


def lambda_handler(event, context):
    data = fetch_api_data(API_KEY, API_HOST, URL, QUERY)
    list_workspace_object = create_workspace_objects()
    date = get_time()[1].split()[0]
    for workspace_object in list_workspace_object:
        create_directories(workspace_object)
    populate_database_table_local(data,date,list_workspace_object)
    #populate_database_table_s3_bucket(DST_BUCKET,data,date,list_workspace_object)
    


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

def get_time():  
    dt = datetime.now()
    timestamp = str(datetime.timestamp(dt)).replace('.', '_')
    return timestamp,dt

def create_workspace_objects(config_file_path='/Users/tedsamba/Desktop/GLUE/aws_etl_pipeline/etl/extract/system_config.yml'):
    local = LocalLocation()
    list_workspace_object = []
    if  os.path.exists(config_file_path):
        list_workspace = local.readConfigFile(config_file_path)
        for workspace in list_workspace:
            list_workspace_object.append(Workspace(workspace.database, workspace.table_name))
    return list_workspace_object


def create_directories(workspace_object):
    database_name = workspace_object.get_database()
    table_name = workspace_object.get_table_name()
    if not os.path.exists(database_name):
        os.makedirs(database_name)  
    table_dir = os.path.join(database_name, table_name)
    if not os.path.exists(table_dir):
        os.makedirs(table_dir)  # Create the table directory




def populate_database_table_local(data,date,list_workspace_object):   
    for workspace_object in list_workspace_object:
        try:
            database_name = workspace_object.get_database()
            table_name = workspace_object.get_table_name()
            file_name = f"{table_name}_{date}.json"
            table_partitioned = pathlib.Path(f"/Users/tedsamba/Desktop/GLUE/{database_name}/{table_name}/{date}")
            table_partitioned.mkdir(parents=True, exist_ok=True)
            with open(table_partitioned / file_name, 'w') as file:
                json.dump(data, file)
        except Exception as e: 
            print(f"Error populating table '{table_name}': {e}")


def populate_database_table_s3_bucket(bucket_name,data,date,list_workspace_object):  
    s3_client = boto3.client('s3', region_name=region_name) 
    for workspace_object in list_workspace_object:
        try:
            database_name = workspace_object.get_database()
            table_name = workspace_object.get_table_name()
            file_name = f"{table_name}_{date}.json"
            s3_object_key = f"{database_name}/{table_name}/{date}/{file_name}" 

            # Convert data to a byte stream (assuming it's serializable)
            if isinstance(data, dict):
                data_bytes = json.dumps(data, ensure_ascii=False).encode('utf-8')
            else:
                raise TypeError("Data must be a dictionary serializable to JSON")
            try:
                s3_client.upload_fileobj(data_bytes, bucket_name, s3_object_key)
            except ClientError as e:
                raise Exception(f"Error uploading data to S3: {e}") from e  # Re-raise with more context

        except Exception as e:
            print(f"Error populating table '{table_name}': {e}")

lambda_handler(None, None)
