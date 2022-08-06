import { APIGatewayProxyHandler } from 'aws-lambda';

export const handler: APIGatewayProxyHandler = async function handler(event) {
  console.log(event);
  try {
    return {
      statusCode: 200,
      body: JSON.stringify({ hello: 'world' }),
    };
  } catch (e) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: (e as Error).message }),
    };
  }
};
