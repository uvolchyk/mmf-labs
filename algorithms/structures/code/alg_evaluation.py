import numpy as np
import time as t


def your_personal_knife(nums: list) -> tuple:
    odds, evens = [], []
    for element in nums:
        if element % 2 == 0:
            evens.append(element)
        else:
            odds.append(element)
    return (odds, evens)



array = [i for i in range(-10,10)]

print(your_personal_knife(array))