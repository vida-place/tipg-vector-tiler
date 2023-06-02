# Use specific version of uvicorn-gunicorn image
ARG PYTHON_VERSION=3.11
FROM ghcr.io/vincentsarago/uvicorn-gunicorn:${PYTHON_VERSION}

# Set app dir
WORKDIR /src

# Allow for Python logging and add app directory to PYTHONPATH
ENV PYTHONUNBUFFERED=True \
    PYTHONPATH=/src

# Install requirements
# First, COPY only the requirements.txt file to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy the rest of the app
COPY . .

# Use an ENTRYPOINT to allow for additional command-line arguments
ENTRYPOINT ["gunicorn", "main:app", "-c", "gunicorn_config.py"]
