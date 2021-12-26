#!/usr/bin/env python

import sys
import re

filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]

lights = [[0]*1000 for i in range(1000)]

for line in lines:
    m = re.match(
        r'.*(?P<cmd>on|off|toggle) (?P<x1>\d+),(?P<y1>\d+) through (?P<x2>\d+),(?P<y2>\d+)', line)
    if m:
        dict = m.groupdict()
        print(dict)

        x1 = int(m['x1'])
        x2 = int(m['x2'])
        y1 = int(m['y1'])
        y2 = int(m['y2'])

        if m['cmd'] == 'toggle':
            for x in range(x1, x2+1):
                for y in range(y1, y2+1):
                    lights[x][y] = 0 if lights[x][y] else 1
        elif m['cmd'] == 'on' or m['cmd'] == 'off':
            result = 1 if m['cmd'] == 'on' else 0
            for x in range(x1, x2+1):
                for y in range(y1, y2+1):
                    pre = lights[x][y]
                    lights[x][y] = result
                    post = lights[x][y]
                    #print(f"{pre} > {post} {result}")
        else:
            print("GOOPS on line")
            exit(1)

lights_on = 0
for x in range(1000):
    for y in range(1000):
        lights_on += lights[x][y]

print(lights_on)
