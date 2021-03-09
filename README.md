# Deprecated: 433Mhz receiver in python is too flaky...

# openhab_rfsniffer
Docker image for raspberrypi to send a Rest API request to Openhab if a rf code is received via GPIO

Image can be configured via command-line arguments like this:

```
docker run -d --network="host" --restart=always --privileged --name=openhab_rfsniffer arauch82/openhab_rfsniffer:latest --gpio 27 --openhab_ip 192.168.178.97 --item doorBell --code 15555555 --fritzbox_ip 192.168.178.1 --fritzbox_password awesomepassword --fritzbox_phone **611

```

The Fritzbox specific arguments can be omitted if you don't want a connection to a Fritzbox or trigger any phone call.
