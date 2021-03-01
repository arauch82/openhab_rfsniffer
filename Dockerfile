# Pull base image
FROM balenalib/raspberrypi4-64-python
MAINTAINER Andreas Rauch <mail@andreas-rauch.de>

RUN [ "cross-build-start" ]

# Install dependencies
RUN install_packages python python-dev python-pip

# Install rpi-rf
RUN pip install rpi-rf

# Define working directory
WORKDIR /data

COPY rf_receiver.py /data
RUN chmod +x /data/rf_receiver.py

RUN [ "cross-build-end" ]

# Define default command
ENTRYPOINT ["python", "/data/rf_receiver.py"]