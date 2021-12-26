#!/usr/bin/env python

import sys

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

visit(x, y, visited)

for line in lines:
    for step in line:
        if step == '^':
            x -= 1
        elif step == 'v':
            x += 1
        elif step == '<':
            y -= 1
        elif step == '>':
            y += 1
        else:
            print("OOPS on " + step)
            exit(1)

        visit(x, y, visited)

print(len(visited.keys()))
