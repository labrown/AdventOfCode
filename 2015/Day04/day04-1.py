#!/usr/bin/env python

import sys
import hashlib

filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]

key = lines[0]

i = 1
while 1:
    if hashlib.md5((key + str(i)).encode('utf-8')).hexdigest().startswith('00000'):
        print(i)
        exit(0)
    i += 1
