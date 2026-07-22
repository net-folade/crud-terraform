import json
import boto3
from boto3.dynamodb.conditions import Key 
from datetime import datetime 
from decimal import Decimal
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])


class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            # int if whole number, else float
            return int(obj) if obj % 1 == 0 else float(obj)
        return super().default(obj)

def lambda_handler(event, context): 
    method = event['httpMethod']
    resource = event['resource']

    if method == 'POST' and resource == '/readings':
        data = json.loads(event['body'])
        if 'device_id' not in data:
            return { 'statusCode': 400, 'body': json.dumps('Missing required field: device_id') }

        item = {
            'device_id': data['device_id'],
            'recorded_at': datetime.now().isoformat(),
        }
        for field in ('temperature', 'humidity'):
            if data.get(field) is not None:
                item[field] = Decimal(str(data[field]))

        table.put_item(Item=item)
        return { 'statusCode': 201, 'body': json.dumps(item, cls=DecimalEncoder) }
    
    elif method == 'GET' and resource == '/readings':
        device_id = event['queryStringParameters']['device_id']
        response = table.query(KeyConditionExpression=Key('device_id').eq(device_id))
        items = response['Items']
        return { 'statusCode': 200, 'body': json.dumps(items, cls=DecimalEncoder) }
    
    elif method == 'GET' and resource == '/readings/{id}':
        device_id = event['queryStringParameters']['device_id']
        recorded_at = event['pathParameters']['id']
        response = table.get_item(Key = {'device_id': device_id, 'recorded_at': recorded_at})
        item = response.get('Item')
        if item is None:
            return { 'statusCode': 404, 'body': json.dumps('Item not found') }
        return { 'statusCode': 200, 'body': json.dumps(item, cls=DecimalEncoder) }

    
    elif method == 'PUT' and resource == '/readings/{id}':
        device_id = event['queryStringParameters']['device_id']
        recorded_at = event['pathParameters']['id']
        data = json.loads(event['body'])

        updates = []
        values = {}
        for field in ('temperature', 'humidity'):
            if data.get(field) is not None:
                updates.append(f'{field} = :{field[0]}')
                values[f':{field[0]}'] = Decimal(str(data[field]))

        if not updates:
            return { 'statusCode': 400, 'body': json.dumps('No updatable fields provided') }

        table.update_item(Key = {'device_id': device_id, 'recorded_at': recorded_at},
                          UpdateExpression = 'SET ' + ', '.join(updates), 
                          ExpressionAttributeValues = values)
        return { 'statusCode': 200, 'body': json.dumps('Updated') }
        

    elif method == 'DELETE' and resource == '/readings/{id}':
        device_id = event['queryStringParameters']['device_id']
        recorded_at = event['pathParameters']['id']
        table.delete_item(Key = {'device_id': device_id, 'recorded_at': recorded_at})
        return { 'statusCode': 204, 'body': json.dumps('Deleted') }

    else: 
        return { 'statusCode': 400, 'body': json.dumps('Invalid request') }