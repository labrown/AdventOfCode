#!/usr/bin/env python3

# from aocd import data

# print(data)

# from aocd.models import Puzzle

# puzzle = Puzzle(year=2024, day=2)

# print(Puzzle)

from aocd import puzzle


def check_safe(l: str) -> int:
    values = l.split()
    up = values[1] > values[0]
    cur = int(values.pop())
    while len(values):
        next = int(values.pop())
        delta = abs(next - cur)
        if delta < 1 or delta > 3:
            return 0
        if up and cur <= next:
            return 0
        elif not up and cur >= next:
            return 0
        else:
            cur = next
    return 1


example1 = puzzle.examples[0].input_data
lines = example1.split("\n")
safe = 0
for line in lines:
    safe += check_safe(line)

print(safe)
