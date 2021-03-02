FROM python:3-alpine

WORKDIR /usr/src/app

COPY rf_receiver.py /.
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Define default command
ENTRYPOINT ["python", "./rf_receiver.py"]