FROM debian:buster AS qemu_arm64

#QEMU Download
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v4.0.0%2Bdev.2%2Bjenkins-balena-qemu-21/qemu-4.0.0.dev.2.jenkins-balena-qemu-21-aarch64.tar.gz
             
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && curl -k -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm64v8/python:3
COPY --from=qemu_arm64 qemu-aarch64-static /usr/bin

WORKDIR /usr/src/app

COPY rf_receiver.py /.
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

COPY rf_receiver.py /.

# Define default command
ENTRYPOINT ["python", "./rf_receiver.py"]