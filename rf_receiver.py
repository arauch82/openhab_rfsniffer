#!/usr/bin/env python3

import argparse
import signal
import sys
import time
import logging
import requests

from rpi_rf import RFDevice

from fritzconnection import FritzConnection

rfdevice = None
fritz_connection = None

# pylint: disable=unused-argument
def exithandler(signal, frame):
    rfdevice.cleanup()
    sys.exit(0)

logging.basicConfig(level=logging.INFO, datefmt='%Y-%m-%d %H:%M:%S',
                    format='%(asctime)-15s - [%(levelname)s] %(module)s: %(message)s', )

parser = argparse.ArgumentParser(description='Receives a decimal code via a 433/315MHz GPIO device')
parser.add_argument('--gpio', dest='gpio', type=int, default=27,
                    help="GPIO pin (Default: 27)")
parser.add_argument('--openhab_ip', dest='openhab_ip', type=str, required=True,
                    help="IP address of Openhab")
parser.add_argument('--item', dest='item', type=str, required=True,
                    help="Item to be switched")
parser.add_argument('--code', dest='code', type=str, required=True,
                    help="Code to be received")
parser.add_argument('--fritzbox_ip', dest='fritzbox_ip', type=str,
                    help="IP address of Fritzbox")
parser.add_argument('--fritzbox_password', dest='fritzbox_password', type=str,
                    help="Password of Fritzbox")
parser.add_argument('--fritzbox_phone', dest='fritzbox_phone', type=str,
                    help="Phone number to call")
args = parser.parse_args()

item_address = "http://" + args.openhab_ip + ":8080/rest/items/" + args.item
signal.signal(signal.SIGINT, exithandler)
rfdevice = RFDevice(args.gpio)
rfdevice.enable_rx()

if args.fritzbox_ip:
    fritz_connection = FritzConnection(address=args.fritzbox_ip, password=args.fritzbox_password)
    logging.info("Established connection to Fritzbox")

timestamp = None
logging.info("Listening for codes on GPIO " + str(args.gpio))
while True:
    if rfdevice.rx_code_timestamp != timestamp:
        timestamp = rfdevice.rx_code_timestamp
        logging.info(str(rfdevice.rx_code) +
                     " [pulselength " + str(rfdevice.rx_pulselength) +
                     ", protocol " + str(rfdevice.rx_proto) + "]")
        if(str(rfdevice.rx_code) == args.code):
            logging.info("Sending RestAPI Post to Openhab")
            resp = requests.post(item_address, data='ON', headers={'Content-Type': 'text/plain', 'Accept': 'application/json'})
            if fritz_connection:
                arg = {'NewX_AVM-DE_PhoneNumber': args.fritzbox_phone}
                fritz_connection.call_action('X_VoIP1', 'X_AVM-DE_DialNumber', arguments=arg)
                time.sleep(5)
                fritz_connection.call_action('X_VoIP1', 'X_AVM-DE_DialHangup')
    time.sleep(0.01)
rfdevice.cleanup()
