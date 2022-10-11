# Alpine is bare boned linux OS
FROM python:3.9-alpine3.13

LABEL maintainer="rcond002"

# Print directly to console
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Create Virtual Environment and upgrade/install requirements
# Remove the requirements directory after done
# Add user as best practice to not use root user!
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol

# Create directories after command to make django user owner of these directories (-p for all subdirectories)
# chown -> change owner to assign to django-user
# chmod -> change permission (755 = read/write/execute)

# Updates the environment variable in image
# Now will be able to run command with less syntax
ENV PATH="/py/bin:$PATH"

# Specify the user to switch to when running the container
# Will run container as django-user
USER django-user