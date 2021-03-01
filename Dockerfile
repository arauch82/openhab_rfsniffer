# Pull base image
FROM balenalib/raspberrypi4-64-python
MAINTAINER Andreas Rauch <mail@andreas-rauch.de>

# Define working directory
WORKDIR /data

COPY rf_receiver.py /data
RUN chmod +x /data/rf_receiver.py

# Define default command
ENTRYPOINT ["python", "/data/rf_receiver.py"]