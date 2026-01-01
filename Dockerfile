FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    docker.io \
    sudo \
    vim \
    procps \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy downloaded packages
COPY packages/ /tmp/packages/
COPY requirements.txt /tmp/requirements.txt

# Install Langflow and dependencies
# Use local packages where available, but allow PyPI for build dependencies
RUN pip install --upgrade pip && \
    pip install --find-links=/tmp/packages/ --prefer-binary \
    -r /tmp/requirements.txt && \
    rm -rf /tmp/packages/ /tmp/requirements.txt

# Create langflow data directory
RUN mkdir -p /app/langflow_data

# Expose Langflow port
EXPOSE 7860

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:7860/health || exit 1

# Start Langflow
CMD ["langflow", "run", "--host", "0.0.0.0", "--port", "7860"]
