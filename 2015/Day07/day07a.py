#!/usr/bin/env python

# from aocd import lines
import sys
import re


class Wire:

    # Wire has 4 attributes
    # pin0 - input 0
    # pin1 - input 1
    # operation - What operation to be performed

    def __init__(self, op1, oper, op2, wire):
        self.op1 = int(op1) if op1 and op1.isdigit() else op1
        self.op2 = int(op2) if op2 and op2.isdigit() else op2
        self.oper = oper
        self.wire = wire

    def __str__(self):
        op1 = "" if self.op1 is None else self.op1
        oper = "" if self.oper is None else self.oper
        return f'{op1} {oper} {self.op2} -> {self.wire}'.lstrip()

    @ classmethod
    def from_line(cls, line):
        m = re.match(
            r'(?:(?P<op1>[a-z]+|\d+) )?(?:(?P<oper>[A-Z]+) )?(?P<op2>[a-z]+|\d+) -> (?P<wire>[a-z]+)', line)
        if m:
            return cls(**m.groupdict())
        else:
            raise ValueError('Not valid line')

    def evaluate(self):
        # Check op1
        # Check op2
        # evaluate result


filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]


wires = {}

for line in lines:
    wire = Wire.from_line(line)
    wires[wire.wire] = wire


def solve(wire):
