const { WebClient } = require('@slack/web-api');
const SLACK_TOKEN = process.env.SLACK_TOKEN;
const SLACK_CHANNEL = process.env.SLACK_CHANNEL;

exports.handler = async (event) => {
  const slackClient = new WebClient(SLACK_TOKEN);
  const messages = event.Records.map(record => JSON.parse(record.body));

  for (const message of messages) {
    await slackClient.chat.postMessage({
      channel: SLACK_CHANNEL,
      text: `Message received: ${JSON.stringify(message)}`,
    });
  }
};
