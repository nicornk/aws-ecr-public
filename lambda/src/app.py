# -*- coding: UTF-8
import pandas
import json

def handler(event, context):
    http_body = json.loads(event["body"], strict=False)
    return {
        'isBase64Encoded': False,
        'statusCode': 200,
        'body': json.dumps(http_body)
    }