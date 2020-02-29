#----------------------------------
#Creates a Redis queue
#----------------------------------
resource "aws_elasticache_parameter_group" "airflow_redis_pg" {
  family = "redis5.0"
  name = "${var.cluster_name}-queue-pg"
}

resource "aws_security_group" "airflow_elasticache_sg" {
  name        = "${var.cluster_name}-elaticache-sg"
#  count       =
  description = "Security group for airflow elasticache"
  vpc_id      = "${aws_vpc.airflow_vpc.id}"
  tags        = var.tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "airflow_elasticache_sg_rule" {
  from_port = 6379
  protocol = "tcp"
  security_group_id = aws_security_group.airflow_elasticache_sg.id
  to_port = 6379
  type = "ingress"
  source_security_group_id = aws_security_group.ec2-sg.id
}

resource "aws_elasticache_cluster" "airflow_queue" {
  cluster_id             = "${var.cluster_name}-queue"
  engine           = "redis"
  node_type = "cache.t3.small"
  num_cache_nodes = 1
  parameter_group_name = aws_elasticache_parameter_group.airflow_redis_pg.name
  subnet_group_name = aws_subnet.airflow_subnet_a.id
  security_group_ids = [aws_security_group.airflow_elasticache_sg.id]
  availability_zone =  aws_subnet.airflow_subnet_a.id
  tags             = var.tags
}


