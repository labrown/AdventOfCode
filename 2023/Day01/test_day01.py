import pytest
import pytest_aoc

import day01


@pytest.fixture()
def example_a():
    return ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]


@pytest.fixture()
def answer_a():
    return 142


@pytest.fixture()
def example_2():
    return [
        "two1nine",
        "eightwothree",
        "abcone2threexyz",
        "xtwone3four",
        "4nineeightseven2",
        "zoneight234",
        "7pqrstsixteen",
    ]


@pytest.fixture()
def answer_2():
    return 281


def test_part1_example(example_a, answer_a):
    assert day01.part1(example_a) == answer_a


def test_part1(day01_lines):
    answer = day01.part1(day01_lines)
    print(f"answer is {answer}")


def test_part1_example(example_2, answer_2):
    assert day01.part1(example_2) == answer_2
