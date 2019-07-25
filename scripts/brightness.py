#!/bin/env python

import argparse

# Define argument parser
parser = argparse.ArgumentParser(
        description="To adjust Thinkpad T470s brightness on Arch"
        )

parser.add_argument('-d','--down', action='store_true',
                    help="Reduce the brightness",
                    dest="down"
                    )

parser.add_argument('-u','--up', action='store_true',
                    help="Increase the brightness",
                    dest="up"
                    )
parser.add_argument('-p','--percent', action='store',
                    type=int,
                    dest='percent',
                    help="Change the brightness with the percentage given (0-100)"
                    )
parser.add_argument('-b', '--blank', action='store_true',
                    help="Turn to blank screen",
                    dest="b"
                    )
args = parser.parse_args()

fix_value = 450
max_brightness_file = "/sys/class/backlight/intel_backlight/max_brightness"
current_brightness_file = "/sys/class/backlight/intel_backlight/brightness"

def getMaxBrightness():
    return int(open(max_brightness_file, "r").read())

def getBrightness():
    return int(open(current_brightness_file, "r").read())

def updateBrightness(value):
    if value <= getMaxBrightness():
        open(current_brightness_file,"w").write(str(value))

if args.b:
    updateBrightness(0)

if args.down:
    updateBrightness(getBrightness() - fix_value)

if args.up:
    updateBrightness(getBrightness() + fix_value)

if args.percent is not None:
    if args.percent < 101 and args.percent > -1:
        updateBrightness(int(args.percent * getMaxBrightness()/100))
    else:
        print ("wrong value")
