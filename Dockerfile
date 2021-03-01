FROM alpine AS qemu

#QEMU Download
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

# Pull base image
FROM arm64v8/python:3
COPY --from=qemu qemu-aarch64-static /usr/bin
MAINTAINER Andreas Rauch <mail@andreas-rauch.de>

WORKDIR /usr/src/app

COPY rf_receiver.py /.
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

COPY rf_receiver.py /.

# Define default command
ENTRYPOINT ["python", "./rf_receiver.py"]