# Pull base image
FROM balenalib/rpi-raspbian:buster
MAINTAINER Andreas Rauch <mail@andreas-rauch.de>

# Install dependencies
RUN apt-get update && apt-get install -y \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install rpi-rf
RUN pip install rpi-rf

# Define working directory
WORKDIR /data

COPY rf_receiver.py /data

# Define default command
ENTRYPOINT ["python", "/data/rf_receiver.py"]