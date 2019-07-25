#!/bin/env python

import subprocess
import os
import time

#os.system('echo "test" &> /dev/null')
#out = subprocess.Popen(['wc', '-l', 'asound.conf'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
#stdout, stderr = out.communicate()
#print(stdout)


asound =  '#/etc/asound.conf \n'
asound += ' \n'
asound += 'defaults.bluealsa.interface "hci0" \n'
asound += 'defaults.bluealsa.device "FC:B6:D8:D7:BF:0B" \n'
asound += 'defaults.bluealsa.profile "a2dp" \n'
asound += 'defaults.bluealsa.delay 10000 \n'
asound += ' \n'
asound += 'pcm.airpod { \n'
asound += '	type plug \n'
asound += '	slave.pcm { \n'
asound += '		type bluealsa \n'
asound += '		device "FC:B6:D8:D7:BF:0B" \n'
asound += '		profile "a2dp" \n'
asound += '	} \n'
asound += '	hint { \n'
asound += '		show on \n'
asound += '		description "airpod" \n'
asound += '	} \n'
asound += '}  \n'
asound += ' \n'
asound += 'pcm.!default { \n'
asound += '    type plug \n'
asound += '    slave.pcm "airpod" \n'
asound += '} \n'
asound += 'ctl.!default { \n'
asound += '	type plug \n'
asound += '	slave.ctl "airpod" \n'
asound += '}'


FNULL = open(os.devnull, 'w')

out = subprocess.Popen(['bluetooth'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
stdout = out.communicate()
if str(stdout).find("off") != -1:
    ## Steps to connect
    ## 0. Turn on bluetooth
    subprocess.Popen(['bluetooth', 'on'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    time.sleep(5)
    ## 0.1 Run bluealsa
    subprocess.Popen(['bluealsa'], shell=True, stdout=FNULL, stderr=FNULL)
    time.sleep(5)
    ## 1. connect to airpod
    os.system('echo -e "power on\nexit" | bluetoothctl')
    time.sleep(5)
    os.system('echo -e "connect FC:B6:D8:D7:BF:0B\nexit" | bluetoothctl')
    ## 2. if airpod connected, change asound.conf fil    
    open("/etc/asound.conf", 'w').write(asound)
    ## 3. reload alsa if necessary

else:
    # steps to disconnect
    # 0. change back alsa config file
    os.remove("/etc/asound.conf")
    # 0.1 Stop bluealsa
    ## 1. disconnect the airpod 
    out = subprocess.Popen(['ps', 'a'],stdout=subprocess.PIPE, stderr=subprocess.STDOUT )
    stdout, stderr = out.communicate()
    lines = str(stdout).split('\\n')
    index = [i for i, s in enumerate(lines) if 'bluealsa' in s]
    if (index):
        col = lines[index[0]].split(" ")
        while '' in col:
            col.remove('')
        subprocess.Popen(['kill', col[0]], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    ## 2. turn off bluetooth
    subprocess.Popen(['bluetooth', 'off'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)


