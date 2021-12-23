#!/usr/bin/env python

import sys

filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]

paper = 0
for line in lines:
    l, w, h = line.split('x')
    l = int(l)
    w = int(w)
    h = int(h)
    box_area = 2*l*w + 2*w*h + 2*h*l
    lengths = [l, w, h]
    min1 = min(lengths)
    lengths.remove(min1)
    min2 = min(lengths)
    extra_area = min1 * min2
    paper += box_area + extra_area

print(paper)
