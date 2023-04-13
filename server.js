const express = require('express');
const AWS = require('aws-sdk');
const app = express();
const sqs = new AWS.SQS();

app.use(express.json());

app.all('*', async (req, res) => {
  const params = {
    MessageBody: JSON.stringify(req.body),
    QueueUrl: process.env.SQS_QUEUE_URL,
  };
  try {
    await sqs.sendMessage(params).promise();
    res.status(200).send('Appcharge!!!');
  } catch (error) {
    console.error('Error sending message to SQS:', error);
    res.status(500).send('Error sending message to SQS');
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`App listening on port ${PORT}!`));