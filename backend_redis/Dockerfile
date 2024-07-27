# Dockerfile for backend_redis

FROM python:3.10-slim

# Set the working directory to /app
WORKDIR /app

# Copy requirements.txt and install any dependencies
COPY backend_redis/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files into the container at /app
COPY backend_redis /app/

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run manage.py when the container launches
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
