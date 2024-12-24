#!/usr/bin/env python

from aocd.models import Puzzle

# Get puzzle data
puzzle = Puzzle(year=2024, day=1)
input = puzzle.input_data
lines = input.split("\n")

numbers = input.split()

for l, r in numbers:
    print(f"l is {l}, r is {r}")

exit(0)

# Part a

left = []
right = []

for line in lines:
    l, r = line.split()
    left.append(int(l))
    right.append(int(r))

left.sort()
right.sort()

sum = 0
for l, r in zip(left, right):
    sum += abs(l - r)

print(f"Part a answer is {sum}")
puzzle.answer_a = sum

# Part b

left = []
right = {}

for line in lines:
    l, r = line.split()
    left.append(int(l))
    r = int(r)
    if r in right:
        right[r] += 1
    else:
        right[r] = 1


sum = 0
for l in left:
    if l in right:
        sum += l * right[l]

print(f"Part b answer is {sum}")
puzzle.answer_b = sum
