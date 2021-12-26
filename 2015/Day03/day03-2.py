#!/usr/bin/env python

import sys
from textwrap import wrap

filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]


def visit(x, y, visited):
    key = str(x) + ',' + str(y)
    if key in visited:
        visited[key] += 1
    else:
        visited[key] = 1


x = 0
y = 0
visited = {}
i = 0
santas = [[0, 0], [0, 0]]

visit(x, y, visited)

for line in lines:
    for step in line:
        s = i % 2
        i += 1
        if step == '^':
            santas[s][0] -= 1
        elif step == 'v':
            santas[s][0] += 1
        elif step == '<':
            santas[s][1] -= 1
        elif step == '>':
            santas[s][1] += 1
        else:
            print("OOPS on " + step)
            exit(1)

        visit(santas[s][0], santas[s][1], visited)

print(len(visited.keys()))
