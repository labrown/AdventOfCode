#!/usr/bin/env python

import sys
import re

filename = sys.argv[1]

with open(filename) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]


def find_vowels(word):
    res = re.findall(r'[aeiou]', word)
    return len(res)


def find_double(word):
    res = re.findall(r'(.)\1', word)
    return len(res)


def find_bad(word):
    res = re.findall(r'ab|cd|pq|xy', word)
    return len(res)


nice = 0
for line in lines:
    if find_vowels(line) >= 3 and find_double(line) > 0 and find_bad(line) == 0:
        nice += 1

print(nice)
