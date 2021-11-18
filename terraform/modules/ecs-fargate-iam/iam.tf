# Role to access AWS services
data "template_file" "task_policy" {
  template = file("${path.module}/templates/task_policy.json.tpl")
  vars = {
    aws_region = var.aws_region
    aws_account_id = var.aws_account_id
  }
}

resource "aws_iam_policy" "task_policy" {
  name        = "TaskPolicy${var.environment}"
  path        = "/"
  description = " task policy to access AWS resources"

  policy = length(var.task_policy) == 0 ?  data.template_file.task_policy.rendered : var.task_policy

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}

data "template_file" "execution" {
  template = file("${path.module}/templates/execution_role.json.tpl")
  vars = {
    aws_region = var.aws_region
    aws_account_id = var.aws_account_id
  }
}

resource "aws_iam_policy" "execution_task_policy" {
  name        = "ExecuteTaskPolicy${var.environment}"
  path        = "/"
  description = "Task policy to access AWS resources"

  policy = length(var.execution_task_policy) == 0 ?  data.template_file.execution.rendered : var.execution_task_policy

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}

# Roles
resource "aws_iam_role" "task" {
  name = "TaskRole"
  description = "Role to access AWS resources from an ECS task"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}

resource "aws_iam_role" "execution_task" {
  name = "ExecutionTaskRole${var.environment}"
  description = "Role to access AWS resources from an ECS task"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}

# Attach policies to roles
resource "aws_iam_policy_attachment" "task_policy_attach" {
  name       = "TaskPolicyAttachment${var.environment}"
  roles      = [aws_iam_role.task.name]
  policy_arn = aws_iam_policy.task_policy.arn
}

resource "aws_iam_policy_attachment" "execution_task_policy_attach" {
  name       = "ExecutionTaskPolicyAttachment${var.environment}"
  roles      = [aws_iam_role.execution_task.name]
  policy_arn = aws_iam_policy.execution_task_policy.arn
}