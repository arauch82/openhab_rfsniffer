# Pull base image
FROM arm64v8/python:3
COPY qemu-aarch64-static /usr/bin
MAINTAINER Andreas Rauch <mail@andreas-rauch.de>

WORKDIR /usr/src/app

COPY rf_receiver.py /.
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

COPY rf_receiver.py /.

# Define default command
ENTRYPOINT ["python", "./rf_receiver.py"]