# Stage 1: Build Stage
FROM python:3 AS builder

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# COPY the entire devops directory into the builder stage
COPY devops /app/devops/

# Stage 2: Production Stage
FROM python:3-slim

WORKDIR /app

# Copy only the necessary files and dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.*/site-packages/ /usr/local/lib/python3.*/site-packages/
COPY --from=builder /app/devops/ /app/devops/

# Install Django in the production stage
RUN pip install django

WORKDIR /app/devops

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

