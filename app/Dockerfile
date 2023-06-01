ARG PYTHON_VERSION=3.11

FROM ghcr.io/vincentsarago/uvicorn-gunicorn:${PYTHON_VERSION}

# Set app dir
ENV APP_HOME /app

# Set workdir
WORKDIR /code/app

# Allow for Python logging
ENV PYTHONUNBUFFERED True
ENV PYTHONPATH=/code/app

# Install requirements
COPY $APP_HOME/requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# Copy tiler
COPY .$APP_HOME /code/app

# # Copy env vars
# COPY .$APP_HOME/.env .$WORKDIR/

# Set service account env var
ENV GOOGLE_APPLICATION_CREDENTIALS=/code/app/service-account.json

# Run on startup using gunicorn webserver.
CMD exec gunicorn main:app -c gunicorn_config.py
