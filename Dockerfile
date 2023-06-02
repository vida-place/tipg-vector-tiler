ARG PYTHON_VERSION=3.11

FROM ghcr.io/vincentsarago/uvicorn-gunicorn:${PYTHON_VERSION}

# Set app dir
ENV APP_HOME /src

# Set workdir
WORKDIR $APP_HOME

# Allow for Python logging
ENV PYTHONUNBUFFERED True
ENV PYTHONPATH=$APP_HOME

# Install requirements
COPY $APP_HOME/requirements.txt $APP_HOME/requirements.txt
RUN pip install --no-cache-dir --upgrade -r $APP_HOME/requirements.txt

# Copy tiler
COPY .$APP_HOME $APP_HOME

# Run on startup using gunicorn webserver.
CMD exec gunicorn main:app -c gunicorn_config.py
