#!/usr/bin/env python

import sys

filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]


floor = 0
for line in lines:
    for element in line:
        if element == "(":
            floor += 1
        elif element == ")":
            floor -= 1

print(floor)
