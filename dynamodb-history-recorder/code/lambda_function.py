import json
import os

import boto3

client = boto3.client('dynamodb')
partition_key_attribute_name = os.environ.get('DYNAMODB_PARTITION_KEY_ATTRIBUTE_NAME')
sort_key_attribute_name = os.environ.get('DYNAMODB_SORT_KEY_ATTRIBUTE_NAME')
history_table_name = os.environ.get('DYNAMODB_HISTORY_TABLE_NAME')


def get_original_item_id(keys):
    partition_key = keys[partition_key_attribute_name]

    sort_key = None
    if sort_key_attribute_name:
        sort_key = keys[sort_key_attribute_name]
        if sort_key.get("S"):
            sort_key = sort_key.get("S")
        elif sort_key.get("N"):
            sort_key = sort_key.get("N")

    if partition_key.get("S"):
        partition_key = partition_key.get("S")
    elif partition_key.get("N"):
        partition_key = partition_key.get("N")

    if sort_key:
        return partition_key + sort_key
    else:
        return partition_key


def process_record(record):
    event_id = record["eventID"]
    event_name = record["eventName"]
    dynamodb = record["dynamodb"]

    # determine keys
    keys = dynamodb["Keys"]
    original_item_id = get_original_item_id(keys)
    approximate_creation_date_time = dynamodb.get("ApproximateCreationDateTime")
    new_image = dynamodb.get("NewImage")
    old_image = dynamodb.get("OldImage")

    print("Processing eventId %s, eventName %s, entityID %s" % (event_id, event_name, original_item_id))

    item = {
        "eventID": {
            "S": event_id,
        },
        "originalItemID": {
            "S": original_item_id,
        },
        "approximateTimestamp": {
            "N": str(approximate_creation_date_time),
        },
    }

    if new_image:
        item["newImage"] = {
            "S": json.dumps(new_image)
        }

    if old_image:
        item["oldImage"] = {
            "S": json.dumps(old_image)
        }

    response = client.put_item(
        TableName=history_table_name,
        Item=item
    )

    print("Response for eventId %s: %s" % (event_id, json.dumps(response)))


def lambda_handler(event, context):
    records = event["Records"]
    for record in records:
        process_record(record)

    return "Ok"
