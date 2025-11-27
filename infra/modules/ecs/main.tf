resource "aws_ecs_cluster" "this" {
  name = var.name
}

resource "aws_iam_role" "task_execution" {
  name = "${var.name}-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

# IAM policy attachments (AmazonECSTaskExecutionRolePolicy)

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name = "web"
      image = "${var.repo_url}:\${IMAGE_TAG}"
      essential = true
      portMappings = [{ containerPort = 80, hostPort = 80, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = "/ecs/${var.name}"
          "awslogs-region" = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        { name = "DATABASE_URL", value = var.database_url }
        # Secrets can be referenced from secrets manager via secrets block
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.name}-svc"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.app.arn
  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.svc_sg_id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "web"
    container_port   = 80
  }
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 200
}

