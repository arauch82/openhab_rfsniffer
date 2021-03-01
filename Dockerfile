# Pull base image
FROM balenalib/raspberrypi4-python
MAINTAINER Andreas Rauch <mail@andreas-rauch.de>

# Install dependencies
RUN apt-get update -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    python \
    python-dev \
    python-pip \
    python-virtualenv && \
rm -rf /var/lib/apt/lists/*

# Install rpi-rf
RUN pip install rpi-rf

# Define working directory
WORKDIR /data

COPY rf_receiver.py /data
RUN chmod +x /data/rf_receiver.py

# Define default command
ENTRYPOINT ["python", "/data/rf_receiver.py"]