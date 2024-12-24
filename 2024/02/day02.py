#!/usr/bin/env python

from aocd import puzzle


def check_safe(values: list[int]) -> int:
    if values[1] > values[0]:
        dir = "ASC"
    elif values[1] < values[0]:
        dir = "DES"
    else:
        return 0

    safe = 1
    cur = values.pop(0)
    while len(values):
        next = values.pop(0)
        delta = abs(next - cur)
        # print(f"  {dir} {cur} {next} {delta} ", end="")
        if delta < 1 or delta > 3:
            # print("FAIL delta")
            safe = 0
            break
        if dir == "ASC" and next <= cur:
            # print("FAIL asc")
            safe = 0
            break
        elif dir == "DES" and next >= cur:
            # print("FAIL desc")
            safe = 0
            break
        else:
            # print("GOOD")
            cur = next
    return safe


def check_dampened(values: list[int]):
    # print(f"dampened input: {values}")
    for i in range(len(values)):
        test = values.copy()
        del test[i]
        # print(f"index: {i} Test values: {test}")
        if check_safe(test):
            return 1
    return 0


def check_input(input, dampen: bool = False):
    lines = input.split("\n")

    total_safe = 0
    for line in lines:
        values = [int(v) for v in line.split()]
        # print(f"values: {values}")

        safe = check_safe(values.copy())
        if safe == 0 and dampen:
            safe = check_dampened(values)
        # print(f"safe: {safe}")
        total_safe += safe
        # print("==")
    return total_safe


def check_example_a():
    safe = check_input(puzzle.examples[0].input_data)
    print(f"Example result is {safe}")


def check_part_a():
    safe = check_input(puzzle.input_data)
    print(f"Part a result is {safe}")
    puzzle.answer_a = safe


def check_example_a_dampened():
    safe = check_input(puzzle.examples[0].input_data, True)
    print(f"Example result dampened is {safe}")


def check_part_b():
    safe = check_input(puzzle.input_data, True)
    print(f"Part b result is {safe}")
    puzzle.answer_b = safe


check_example_a()
check_part_a()
print("###################")
check_example_a_dampened()
check_part_b()
