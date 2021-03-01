FROM debian:stretch AS qemu-src
RUN apt-get update && apt-get install -y qemu-user-static

# Pull base image
FROM arm64v8/python:3
COPY --from=qemu-src /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64-static

WORKDIR /usr/src/app

COPY rf_receiver.py /.
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

COPY rf_receiver.py /.

# Define default command
ENTRYPOINT ["python", "./rf_receiver.py"]