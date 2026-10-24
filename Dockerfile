# ==============================================================================
# SECTION 15: PRODUCTION DOCKER DEPLOYMENT PROFILE 
# ==============================================================================
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies required for potential cryptographic compiling lines
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy framework configurations and dependencies parameters
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire master framework code file natively
COPY yolo_master_core.py .

EXPOSE 8000

# Execute server initialization protocols using Uvicorn
CMD ["python", "yolo_master_core.py"]
