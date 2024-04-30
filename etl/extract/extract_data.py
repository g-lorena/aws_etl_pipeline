import json
import os
import pathlib
from datetime import datetime
from pathlib import Path

import boto3
import requests
import yaml
from System.LocalLocation import LocalLocation
from System.workspace import Workspace

DST_BUCKET = os.environ.get("DST_BUCKET")
REGION = os.environ.get("REGION")
RAW_FOLDER = os.environ.get("RAW_FOLDER")
API_KEY = os.environ.get("API_KEY")
API_HOST = os.environ.get("API_HOST")
URL = "https://zillow56.p.rapidapi.com/search"

#
# country = ["houston","pasadena","katy","Cypress"]

# fonction qui crée les repertoires dans le bucket
# QUERY = {"location": "houston, tx"}


def lambda_handler(event, context):
    list_workspace_object = create_workspace_objects()
    # bucket_name = 'glue-bucket-11794591'
    date = get_time()[1]
    for workspace_object in list_workspace_object:
        create_s3_directories(DST_BUCKET, workspace_object)

    # create_directories(workspace_object)
    # populate_database_table_local(data,date,list_workspace_object)
    populate_database_table_s3_bucket(DST_BUCKET, date, list_workspace_object)


def create_workspace_objects(config_file_path="system_config.yml"):
    local = LocalLocation()
    list_workspace_object = []
    if os.path.exists(config_file_path):
        list_workspace = local.readConfigFile(config_file_path)
        for workspace in list_workspace:
            list_workspace_object.append(
                Workspace(workspace.database, workspace.table_name)
            )
    return list_workspace_object


def fetch_api_data(url, query):
    headers = {
        # mettre api_key et api_host
        "X-RapidAPI-Key": API_KEY,
        "X-RapidAPI-Host": API_HOST,
    }
    response = requests.get(url, headers=headers, params=query)

    if response.status_code == 200:
        data = json.loads(response.text)
        return data["results"]
    else:
        raise Exception(f"Error fetching data: {response.text}")


def create_s3_directories(bucket_name, workspace_object):
    s3 = boto3.client("s3")
    database_name_s3 = RAW_FOLDER
    # database_name_s3 = workspace_object.get_database()
    table_name_s3 = workspace_object.get_table_name()
    # database_name_s3_prefix = str(database_name_s3)
    table_name_s3_prefix = str(database_name_s3) + "/" + str(table_name_s3)
    try:
        # s3.put_object(Bucket=bucket_name, Key=(database_name_s3_prefix + '/'))
        s3.put_object(Bucket=bucket_name, Key=(table_name_s3_prefix + "/"))
    except s3.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "404":
            pass


def populate_database_table_s3_bucket(bucket_name, date, list_workspace_object):
    query = None
    # url = URL

    s3 = boto3.client("s3", region_name=REGION)
    cpt = 0
    while cpt < len(list_workspace_object):
        try:
            workspace_object = None
            workspace_object = list_workspace_object[cpt]
            database_name = RAW_FOLDER
            # database_name = workspace_object.get_database()
            table_name = workspace_object.get_table_name()
            file_name = f"{table_name}_{date}.json"
            query = {"location": f"{table_name}, tx"}
            data = fetch_api_data(URL, query)
            # data = {"test":"alla"}
            s3_object_key = f"{database_name}/{table_name}/{date}/{file_name}"
            # Convert data to a byte stream (assuming it's serializable)
            if isinstance(data, dict):
                data_bytes = json.dumps(data, ensure_ascii=False).encode("utf-8")
            else:
                raise TypeError("Data must be a dictionary serializable to JSON")
            try:
                s3.put_object(Bucket=bucket_name, Key=s3_object_key, Body=data_bytes)
                cpt += 1
            except ClientError as e:
                raise Exception(
                    f"Error uploading data to S3: {e}"
                ) from e  # Re-raise with more context
        except Exception as e:
            print(f"Error populating table '{table_name}': {e}")


def get_time():
    dt = datetime.now()
    timestamp = str(datetime.timestamp(dt)).replace(".", "_")
    return timestamp, dt.strftime("%Y-%m-%d")


def create_local_directories(workspace_object):
    database_name = workspace_object.get_database()
    table_name = workspace_object.get_table_name()
    if not os.path.exists(database_name):
        os.makedirs(database_name)
    table_dir = os.path.join(database_name, table_name)
    if not os.path.exists(table_dir):
        os.makedirs(table_dir)  # Create the table directory


"""
def populate_database_table_local(data,date,list_workspace_object):   
    for workspace_object in list_workspace_object:
        try:
            database_name = workspace_object.get_database()
            table_name = workspace_object.get_table_name()
            file_name = f"{table_name}_{date}.json"
            table_partitioned = pathlib.Path(f"/Users/XXX/Desktop/GLUE/{database_name}/{table_name}/{date}")
            table_partitioned.mkdir(parents=True, exist_ok=True)
            with open(table_partitioned / file_name, 'w') as file:
                json.dump(data, file)
        except Exception as e: 
            print(f"Error populating table '{table_name}': {e}")
"""
