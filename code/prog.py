import json

def lambda_handler(event, context):
        httpMethod = json.loads(json.dumps(event['httpMethod']))
        if httpMethod == "GET":
            return {
                'statusCode': 200,
                'body': json.dumps('GET : Hello from Lambda GET Osama')
            }
        elif httpMethod == "POST":
            return {
                'statusCode': 200,
                'body': json.dumps('POST : Hello from Lambda POST Osama')
            }   
