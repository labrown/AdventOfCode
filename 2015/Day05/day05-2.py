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


def find_nonoverlap_double(word):
    res = re.findall(r'(..).*\1', word)
    return len(res)


def find_split_repeat(word):
    res = re.findall(r'(.).\1', word)
    return len(res)


nice = 0
for line in lines:
    if find_nonoverlap_double(line) and find_split_repeat(line):
        nice += 1

print(nice)
