# coding: utf-8

import lamblackbox
import os
import json
import slack


SLACK_API_TOKEN = os.getenv('SLACK_API_TOKEN')
slack_client = slack.WebClient(token=SLACK_API_TOKEN)


@lamblackbox.sqs
def lambda_handler(record, context):
    messages = json.loads(record['body'])
    response = slack_client.chat_postMessage(**messages)
    print(response)
