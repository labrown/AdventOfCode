#!/usr/bin/env python

from aocd import puzzle

import re


def scan_input(input: str) -> int:
    mulmatch = r"mul\((\d{1,3}),(\d{1,3})\)"
    mulre = re.compile(mulmatch)
    iterator = mulre.finditer(input)
    sum = 0
    for match in iterator:
        vals = match.groups()
        sum += int(vals[0]) * int(vals[1])
    return sum


example_input = puzzle.examples[0].input_data
example_sum = scan_input(example_input)
print(f"example a sum is {example_sum}")

part_a_input = puzzle.input_data
part_a = scan_input(part_a_input)
print(f"part a sum is {part_a}")
puzzle.answer_a = part_a


def scan_input_better(input: str) -> int:
    # mulmatch = r"mul\((\d{1,3}),(\d{1,3})\)|do(?:n't)?)\(\)"
    mulmatch = r"mul\((\d{1,3}),(\d{1,3})\)|do(?:n't)?\(\)"
    mulre = re.compile(mulmatch)
    iterator = mulre.finditer(input)
    sum = 0
    enabled = True
    for match in iterator:
        print(match)
        val = match.group()
        if val == "do()":
            enabled = True
        elif val == "don't()":
            enabled = False
        else:
            if enabled:
                vals = match.groups()
                sum += int(vals[0]) * int(vals[1])
    return sum


example_input_b = (
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
)
example_sum_b = scan_input_better(example_input_b)
print(f"example b sum is {example_sum_b}")
part_b_sum = scan_input_better(puzzle.input_data)
print(f"Part b answer is {part_b_sum}")
puzzle.answer_b = part_b_sum
