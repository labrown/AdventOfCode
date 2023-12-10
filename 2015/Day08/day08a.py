#!/usr/bin/env python

from aocd import data
import re


def part_a(data):
    # your code here..
    diff = 0
    p = re.compile(r'\\x(?P<hex>[0-9a-f]{2})')

    for line in data.splitlines():
        print(f"Before {line}")
        before = len(line)
        # replace \\ with \
        line = line.replace("\\\\", "\\")
        # replace all \xHH with ascii character
        while p.search(line) is not None:
            h = p.group('hex')
            a = h.decode("hex")
            line[p.span("hex")] = a
        # remove leading and ending "
        line = line[1:-1]
        print(f"After {line}")
        after = len(line)
        diff += before - after
        print(f"{before} {after} {diff}")
    return diff


# def part_b(data):
#     # more code here..
#     return result


test_data = """\
""
"abc"
"aaa\"aaa"
"\x27"
"""


if __name__ == "__main__":
    assert part_a(test_data) == 12
    # assert part_b(test_data) == "expected test result b"
    # print(part_a(data))
    # print(part_b(data))
