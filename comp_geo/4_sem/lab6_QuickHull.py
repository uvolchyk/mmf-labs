import math
import random
import time
from matplotlib import pyplot as plt
from celluloid import Camera
from Point import Point
from Vector import Vector

# Quick hull algorithm + points motion with the condition

fig = plt.figure()
camera = Camera(fig)

def init_points():
    points = []
    xs = [random.randint(0, 10) for _ in range(10)]
    ys = [random.randint(0, 10) for _ in range(10)]
    for i in range(len(xs)):
        x = Point(xs[i], ys[i])
        points.append(x)
    return points

def init_vectors_of_moving(points: list):
    vectors = []
    xs = [random.randint(-1, 1) for _ in range(len(points))]
    ys = [random.randint(-1, 1) for _ in range(len(points))]
    for i in range(len(xs)):
        p = Point(xs[i], ys[i])
        while p.x == 0 and p.y == 0:
            p = Point(random.randint(-1, 1), random.randint(-1, 1))
        vectors.append(p)
    return vectors

def opposite_vectors_of_moving(vectors: list):
    for i in range(len(vectors)):
        vectors[i] = Point(-vectors[i].x, -vectors[i].y)
    return vectors

def det(a, b, c, d):
    return a * d - b * c

def get_point_position_to_line(p0: Point, p1: Point, p2: Point):
    d = det(p2.x - p1.x, p2.y - p1.y, p0.x - p1.x, p0.y - p1.y)
    if d > 0:
        return "left"
    elif d < 0:
        return "right"
    else:
        return "on the line"

def find_point_with_min_x(points: list):
    min_point = points[0]
    min_x = points[0].x
    for i in range(1, len(points)):
        if min_x > points[i].x:
            min_point = points[i]
            min_x = points[i].x
    return min_point

def find_point_with_max_x(points: list):
    max_point = points[0]
    max_x = points[0].x
    for i in range(1, len(points)):
        if max_x < points[i].x:
            max_point = points[i]
            max_x = points[i].x
    return max_point

def find_lefter_points(points: list, p1: Point, p2: Point):
    lefter_points = []
    for i in range(len(points)):
        if get_point_position_to_line(points[i], p1, p2) == "left":
            lefter_points.append(points[i])
    return lefter_points

def find_righter_points(points: list, p1: Point, p2: Point):
    righter_points = []
    for i in range(len(points)):
        if get_point_position_to_line(points[i], p1, p2) == "right":
            righter_points.append(points[i])
    return righter_points


# Quick hull algorithm
def partial_convex_hull(left: Point, right: Point, points: list, convex_hull_points: list):
    max_area_triangle = triangle_area(left, right, points[0])
    sep = points[0]
    for i in range(1, len(points)):
        if triangle_area(left, right, points[i]) > max_area_triangle:
            max_area_triangle = triangle_area(left, right, points[i])
            sep = points[i]
            print("sep ", sep.x, ":", sep.y, " left ", left.x, ":", left.y, " right ", right.x, ":", right.y)

    s1 = find_lefter_points(points, left, sep)
    s2 = find_lefter_points(points, sep, right)

    if s1:
        partial_convex_hull(left, sep, s1, convex_hull_points)
        convex_hull_points.append(sep)
    else:
        convex_hull_points.append(sep)

    if s2:
        partial_convex_hull(sep, right, s2, convex_hull_points)
    else:
        convex_hull_points.append(sep)


# Quick hull algorithm
def complete_convex_hull(points: list):
    pl = find_point_with_min_x(points)
    pr = find_point_with_max_x(points)
    convex_hull_points = []

    lefter_points = find_lefter_points(points, pl, pr)
    righter_points = find_righter_points(points, pl, pr)

    convex_hull_points.append(pl)
    partial_convex_hull(pl, pr, lefter_points, convex_hull_points)
    convex_hull_points.append(pr)
    partial_convex_hull(pr, pl, righter_points, convex_hull_points)

    convex_hull_points.append(convex_hull_points[0])
    return convex_hull_points


def draw_convex_hull(convex_hull_points: list, color: str):
    for i in range(len(convex_hull_points) - 1):
        plt.plot([convex_hull_points[i].x, convex_hull_points[i + 1].x],
                 [convex_hull_points[i].y, convex_hull_points[i + 1].y], color=color)

def triangle_area(p1: Point, p2: Point, p3: Point):
    v1 = Vector(p2, p1)
    v2 = Vector(p3, p2)
    v3 = Vector(p3, p1)

    semi_perimeter = (v1.get_length() + v2.get_length() + v3.get_length()) / 2

    return math.sqrt(abs(semi_perimeter * (semi_perimeter - v1.get_length()) * (semi_perimeter - v2.get_length()) * \
                         semi_perimeter - v3.get_length()))

def perimeter(points: list):
    perimeter = 0
    for i in range(len(points) - 1):
        perimeter += Vector(points[i], points[i + 1]).get_length()
    perimeter += Vector(points[len(points) - 1], points[0]).get_length()
    return perimeter


def move(moving_points: list, vectors: list):
    for i in range(len(moving_points)):
        moving_points[i] = moving_points[i] + vectors[i]

def init_motion(points: list):
    vectors = init_vectors_of_moving(points)
    PERIMETER_LIMIT = 100

    i = 0
    while i < 70:
        convex_hull_points = complete_convex_hull(points)

        draw_points(points)
        draw_convex_hull(convex_hull_points, "blue")
        camera.snap()

        if perimeter(convex_hull_points) >= PERIMETER_LIMIT:
            vectors = opposite_vectors_of_moving(vectors)

        move(points, vectors)

        i += 1


def draw_point(point: Point):
    plt.scatter(point.x, point.y)


def draw_points(points: list):
    for i in range(len(points)):
        draw_point(points[i])


def init():
    points = init_points()
    # draw_points(points)

    init_motion(points)

    # convex_hull_points = complete_convex_hull(points)
    # print("length: ", len(convex_hull_points))
    # draw_convex_hull(convex_hull_points, "blue")

    plt.grid(True)
    animation = camera.animate(blit=False, interval=300)
    plt.show()


init()
