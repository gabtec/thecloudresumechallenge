const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const {
  DynamoDBDocumentClient,
  PutCommand,
  GetCommand,
} = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({ region: 'eu-west-1' });
const dynamo = DynamoDBDocumentClient.from(client);

const tableName = 't_visits';
const siteID = 'gabtec.fun';

module.exports.handler = async (event) => {
  let body;
  let statusCode = 200;
  const headers = {
    'Content-Type': 'application/json',
    // enable cors
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Methods': '*',
  };

  try {
    switch (event.httpMethod) {
      case 'GET':
        data = await dynamo.send(
          new GetCommand({
            TableName: tableName,
            Key: {
              id: siteID,
            },
          })
        );
        body = data.Item;
        break;
      case 'PUT':
        let requestJSON = JSON.parse(event.body);
        await dynamo.send(
          new PutCommand({
            TableName: tableName,
            Item: {
              id: siteID,
              visitsCount: requestJSON.count,
            },
          })
        );
        body = `Put item ${requestJSON.count} OK`;
        break;
      default:
        throw new Error(`Unsupported method "${event.httpMethod}"`);
    }
  } catch (err) {
    statusCode = '400';
    body = err.message;
  } finally {
    body = JSON.stringify(body);
  }

  return {
    statusCode,
    body,
    headers,
  };
};
