#!/bin/bash
apt update -y
apt install awscli -y
apt install docker-compose -y
apt install docker.io -y
service docker start
usermod -a -G docker ubuntu
snap install yq
echo 'services:
  backend_rds:
    image: ./backend_rds
    environment:
      CORS_ALLOWED_ORIGINS: "https://dev-vysh.com"
      DB_NAME: mydatabase
      DB_PASSWORD: mypassword
      DB_USER: mydatabaseuser
      DB_HOST: db
      DB_PORT: 5432
    ports:
      - "3000:8000"
    depends_on:
      - db

  backend_redis:
    image: ./backend_redis
    environment:
      CORS_ALLOWED_ORIGINS: "https://dev-vysh.com"
      REDIS_HOST: redis
      REDIS_PORT: 6379
      REDIS_DB: 0
    ports:
      - "3001:8000"
    depends_on:
      - redis

  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: mydatabaseuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydatabase
    ports:
      - "5432:5432"
    volumes:
      - db_data:/var/lib/postgresql/data

  redis:
    image: redis:latest
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  db_data:
  redis_data:
' | sudo tee /home/ubuntu/docker-compose.yml > /dev/null
