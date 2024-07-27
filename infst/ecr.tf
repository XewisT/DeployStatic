resource "aws_ecr_repository" "backend_rds_dev" {
  name = "backend_rds_dev"
}

resource "aws_ecr_repository" "backend_rds_prod" {
  name = "backend_rds_prod"
}

resource "aws_ecr_repository" "backend_redis_dev" {
  name = "backend_redis_dev"
}

resource "aws_ecr_repository" "backend_redis_prod" {
  name = "backend_redis_prod"
}
