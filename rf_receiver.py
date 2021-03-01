#!/usr/bin/env python3

import argparse
import signal
import sys
import time
import logging
import requests

from rpi_rf import RFDevice

rfdevice = None

# pylint: disable=unused-argument
def exithandler(signal, frame):
    rfdevice.cleanup()
    sys.exit(0)

logging.basicConfig(level=logging.INFO, datefmt='%Y-%m-%d %H:%M:%S',
                    format='%(asctime)-15s - [%(levelname)s] %(module)s: %(message)s', )

parser = argparse.ArgumentParser(description='Receives a decimal code via a 433/315MHz GPIO device')
parser.add_argument('--gpio', dest='gpio', type=int, default=27,
                    help="GPIO pin (Default: 27)")
parser.add_argument('--ip_address', dest='ip_address', type=str, required=true,
                    help="IP address of Openhab")
parser.add_argument('--item', dest='item', type=str, required=true,
                    help="Item to be switched")
parser.add_argument('--code', dest='code', type=str, required=true,
                    help="Code to be received")
args = parser.parse_args()

item_address = "http://" + args.ip_address + ":8080/rest/items/" + args.item
signal.signal(signal.SIGINT, exithandler)
rfdevice = RFDevice(args.gpio)
rfdevice.enable_rx()
timestamp = None
logging.info("Listening for codes on GPIO " + str(args.gpio))
while True:
    if rfdevice.rx_code_timestamp != timestamp:
        timestamp = rfdevice.rx_code_timestamp
        logging.info(str(rfdevice.rx_code) +
                     " [pulselength " + str(rfdevice.rx_pulselength) +
                     ", protocol " + str(rfdevice.rx_proto) + "]")
		if(str(rfdevice.rx_code) == args.code){
			logging.info("Sending RestAPI Post to Openhab")
			resp = requests.post(item_address, data='ON', headers={'Content-Type': 'text/plain', 'Accept': 'application/json'})
		}
    time.sleep(0.01)
rfdevice.cleanup()