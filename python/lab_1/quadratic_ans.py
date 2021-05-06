# -*- coding: utf-8 -*-
import cmath
import math
import sys

# Start get_float
def get_float(msg, allow_zero):
    x = None
    while x is None:
        try:
            x = float(input(msg))
            if not allow_zero and abs(x) < sys.float_info.epsilon:
                print("zero is not allowed")
                x = None

        except ValueError as err:
            print(err)
    return x
# End get_float


# Start 1st block
print("ax\N{SUPERSCRIPT TWO} + bx + c = 0")
a = get_float("enter a: ", False)
b = get_float("enter b: ", False)
c = get_float("enter c: ", False)
# End 1st block

# Start 2d block
x1 = None
x2 = None
discriminant = (b ** 2) - (4 * a * c)
if discriminant == 0:
    x1 = -(b / (2 * a))
else:
    if discriminant > 0:
        root = math.sqrt(discriminant)
    else:       # discriminant < 0
        root = cmath.sqrt(discriminant)
    x1 = (-b + root) / (2 * a)
    x2 = (-b - root) / (2 * a)
# End 2d block

def builder(coffs):
    formats = ["{0}x\N{SUPERSCRIPT TWO}", "{0}x", "{0}"]
    equation = ""
    for count, form in enumerate(formats):
        coff = coffs[count]
        if coff != 0:
            equation += " + " if count in range(1,3) and coff > 0 else " "
            equation += form.format(coff)
    return equation

# Start 3d block
equation = builder([a,b,c]) + " \N{RIGHTWARDS ARROW} x = {0}".format(x1) + " or x = {0}".format(x2) if x2 is not None else ""
print(equation)
# End 3d block
