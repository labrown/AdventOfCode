import re


def part1(lines):
    sum = 0
    for line in lines:
        nums = re.findall(r"\d", line)
        sum += int(nums[0] + nums[-1])
    return sum


def part2(lines):
    sum = 0
    subs = [
        ["one", 1],
        ["two", 2],
        ["three", 3],
        ["four", 4],
        ["five", 5],
        ["six", 6],
        ["seven", 7],
        ["eight", 8],
        ["nine", 9],
        ["zero", 0],
    ]
    for line in lines:
        sum = 0
        print(line)
        for s in subs:
            line = re.sub(s[0], s[1], line)
        print(line)
        nums = re.findall(r"\d", line)
        sum += int(nums[0] + nums[-1])
    return sum
