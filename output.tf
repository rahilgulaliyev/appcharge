output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer (ALB)"
  value       = aws_lb.alb.dns_name
}

output "sqs_queue_url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.queue.url
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.cluster.name
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.repository.repository_url
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.lambda.function_name
}
