#!/bin/bash
/usr/sbin/chat '' AT+GCI=57 OK AT+MS=92 OK ATA CONNECT \c
stty cooked
cat
