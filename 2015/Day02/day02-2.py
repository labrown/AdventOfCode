#!/usr/bin/env python

import sys

filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]

ribbon = 0
for line in lines:
    l, w, h = line.split('x')
    l = int(l)
    w = int(w)
    h = int(h)
    lengths = [l, w, h]
    min1 = min(lengths)
    lengths.remove(min1)
    min2 = min(lengths)
    ribbon += 2 * min1 + 2 * min2
    ribbon += l * w * h

print(ribbon)
