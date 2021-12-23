#!/usr/bin/env python

import sys

filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]


floor = 0
i = 0
for line in lines:
    for element in line:
        i += 1
        if element == "(":
            floor += 1
        elif element == ")":
            floor -= 1
        if floor == -1:
            print(i)
            exit(0)
