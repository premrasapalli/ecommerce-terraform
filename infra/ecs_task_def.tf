resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = "${var.ecr_repository_url}:${var.image_tag}"
      essential = true
      portMappings = [{ containerPort = 80, hostPort = 80, protocol = "tcp" }]

      environment = [
        { name = "DATABASE_HOST", value = module.rds.db_endpoint },
        { name = "DATABASE_USER", value = var.db_username }
      ]

      secrets = [
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = aws_secretsmanager_secret.db.arn
        },
        # If you stored JSON, you can reference full secret and parse in-app; or store separate secrets.
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = "/ecs/${var.project_name}"
          "awslogs-region" = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

