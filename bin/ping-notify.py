#! /usr/bin/python3
from subprocess import Popen, PIPE, check_call
import time
import re


def main():
    rCounter = 0    # Counts received packets
    sCounter = 0    # Counts sent packets
    dns = getdns()
    pattern = re.compile('([rs]eq)(=1)')
    while rCounter < 3:
        output = ping(dns)
        stdout = output[0]
        stderr = output[1]
        returnCode = output[2]
        sCounter += 1
        if returnCode != 0:      # if the return code is not zero
            rCounter = 0
            if stderr:  # if there is an error
                print(stderr.strip())
                time.sleep(1)
            else:
                stdoutLine2 = stdout.splitlines()[1]
                if stdoutLine2:
                    print(pattern.sub('\\1=' + str(sCounter), stdoutLine2))
                    time.sleep(1)
        else:             # if the return code is zero
            rCounter += 1
            print(pattern.sub('\\1=' + str(sCounter), stdout.splitlines()[1]))
            if rCounter == 3:
                notify(dns)
                break
            time.sleep(1)


def ping(dns):
    pingOutput = Popen(["ping", "-c", "1", "-w", "3", dns], stdout=PIPE, stderr=PIPE)
    output = pingOutput.communicate()
    returnCode = pingOutput.returncode
    stdout = output[0].decode("utf-8")
    stderr = output[1].decode("utf-8")
    # print((stdout, stderr, returnCode))
    return (stdout, stderr, returnCode)


def getdns():
    'Gets DNS information from /etc/resolv.conf and returns it'

    try:
        resolvFile = open('/etc/resolv.conf')
    except:
        print("Couldn't open /etc/resolv.conf, pinging 8.8.4.4")
        return "8.8.4.4"
    for line in resolvFile.readlines():
        dnsMatch = re.match('nameserver (.*)', line)
        if dnsMatch:
            break
    if dnsMatch:
        return dnsMatch.groups()[0]
    else:
        print("Couldn't find dns information in /etc/resolv.conf.\
                pinging 8.8.4.4")
        return "8.8.4.4"


def notify(dns):
    text = 'ping packets have been recieved from: ' + dns
    print(text)
    try:
        check_call(['notify-send', text])
    except:
        print("There was a problem running \"notify-send\"")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt as error:
        print('Keyboard Interreupt', error)
