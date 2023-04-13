variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  default =     "AWS_ACCESS_KEY_ID"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  default =     "AWS_SECRET_ACCESS_KEY"
}

variable "ecs_optimized_ami_id" {
  description = "The Amazon ECS-optimized Amazon Linux 2 AMI ID for your region. See the latest IDs at https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html"
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair for SSH access to ECS instances"
}

variable "slack_webhook_url" {
  description = "The Slack webhook URL to send Lambda function logs"
}
