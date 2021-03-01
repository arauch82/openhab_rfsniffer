FROM golang:1.12.0 AS builder
WORKDIR /builder/working/directory
RUN curl -L https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz | tar zxvf - -C . && mv qemu-3.0.0+resin-aarch64/qemu-aarch64-static .

# Pull base image
FROM arm64v8/python:3
COPY --from=builder /builder/working/directory/qemu-aarch64-static /usr/bin
MAINTAINER Andreas Rauch <mail@andreas-rauch.de>

WORKDIR /usr/src/app

COPY rf_receiver.py /.
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

COPY rf_receiver.py /.

# Define default command
ENTRYPOINT ["python", "./rf_receiver.py"]