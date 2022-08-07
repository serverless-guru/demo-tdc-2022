import type { APIGatewayProxyHandler } from 'aws-lambda';
import { DateTime } from "luxon";

export const handler: APIGatewayProxyHandler = async function handler(event) {
  console.log(event);
  try {
    return {
      statusCode: 200,
      body: JSON.stringify({ hello: 'world', localTime: DateTime.now }),
    };
  } catch (e) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: (e as Error).message }),
    };
  }
};
