import math
import random
import time
from matplotlib import pyplot as plt
from celluloid import Camera
from Point import Point
from util import jarvis
from numpy import random as nprand

fig = plt.figure()
camera = Camera(fig)

def gen_ext_poly():
    points = []
    xs = [-10, -8, 20, 25, 27, 24, 22, 10, 1, -10]
    ys = [-10, -15, -14, 3, 7, 16, 18, 22, 15, -10]
    for i in range(len(xs)):
        x = Point(xs[i], ys[i])
        points.append(x)
    return points


def gen_int_poly():
    points = []
    xs = [7, 12, 15, 14, 11, 7, 8, 6, 7]
    ys = [4, -5, 0, 9, 12, 8, 8, 6, 4]
    for i in range(len(xs)):
        x = Point(xs[i], ys[i])
        points.append(x)
    return points


def gen_points():
    points = nprand.randint(low=-5,high=5, size=(12,2))
    return [Point(x,y) for (x,y) in points]


def draw_polygon(points: list, color):
    for i in range(len(points) - 1):
        plt.plot([points[i].x, points[i + 1].x], [points[i].y, points[i + 1].y], color=color)


def draw_point(point: Point):
    plt.scatter(point.x, point.y)


def det(a, b, c, d):
    return a * d - b * c


def point_position_to_line(p0: Point, p1: Point, p2: Point) -> str:
    d = det(p2.x - p1.x, p2.y - p1.y, p0.x - p1.x, p0.y - p1.y)
    if d > 0:
        return "left"
    elif d < 0:
        return "right"
    else:
        return "on the line"


def binary_test(p0: Point, points: list) -> str:
    start = 0
    end = len(points) - 1

    while end - start > 1:
        sep = math.floor((start + end) / 2)
        if point_position_to_line(p0, points[0], points[sep]) == "left":
            start = sep
        else:
            end = sep

    if point_position_to_line(p0, points[start], points[start + 1]) == 'left':
        return 'in'
    else:
        return 'out'


def octant(p1: Point, p2: Point):
    x = p2.x - p1.x
    y = p2.y - p1.y

    if 0 <= y <= x:
        return 1
    elif 0 < x <= y:
        return 2
    elif 0 <= -x < y:
        return 3
    elif 0 < y <= -x:
        return 4
    elif 0 <= -y < -x:
        return 5
    elif 0 < -x <= -y:
        return 6
    elif 0 < x < -y:
        return 7
    elif 0 < -y <= -x:
        return 8
    else:
        return 1


# Угловой тест
def octants_test(p0: Point, points: list) -> str:
    s = 0
    for i in range(len(points) - 1):
        beta1 = octant(p0, points[i])
        beta2 = octant(p0, points[i + 1])
        delta = beta2 - beta1
        if delta > 4:
            delta -= 8
        if delta < -4:
            delta += 8
        if delta == 4 or delta == -4:
            d = det(points[i].x - p0.x, points[i].y - p0.y, points[i + 1].x - p0.x, points[i + 1].y - p0.y)
            if d > 0:
                delta = 4
            if d < 0:
                delta = -4
            if d == 0:
                return "edge"
        s += delta
    if s == 8 or s == -8:
        return "in"
    elif s == 0:
        return "out"
    else:
        ArithmeticError("LOL, BOMB HAS BEEN PLANTED")


def gen_velocity(points: list):
    vectors = []
    xs = [random.randint(-1, 1) for _ in range(len(points))]
    ys = [random.randint(-1, 1) for _ in range(len(points))]
    for i in range(len(xs)):
        p = Point(xs[i], ys[i])
        while p.x == 0 and p.y == 0:
            p = Point(random.randint(-1, 1), random.randint(-1, 1))
        vectors.append(p)
    return vectors


def draw_points(points: list):
    for i in range(len(points)):
        draw_point(points[i])


def reflected_vector(a: Point, p1: Point, p2: Point):
    b = Point(p2.x - p1.x, p2.y - p1.y)
    result = b
    product = ((a * b) / (b * b)) * 2
    result.x *= product
    result.y *= product
    return result - a


def are_intersected(p1: Point, p2: Point, p3: Point, p4: Point) -> bool:
    d1 = det(p4.x - p3.x, p4.y - p3.y, p1.x - p3.x, p1.y - p3.y)
    d2 = det(p4.x - p3.x, p4.y - p3.y, p2.x - p3.x, p2.y - p3.y)
    d3 = det(p2.x - p1.x, p2.y - p1.y, p3.x - p1.x, p3.y - p1.y)
    d4 = det(p2.x - p1.x, p2.y - p1.y, p4.x - p1.x, p4.y - p1.y)

    if d1 * d2 <= 0 and d3 * d4 <= 0:
        return True
    else:
        return False


def intersected_edge(p1: Point, p2: Point, polygon_points: list):
    for i in range(len(polygon_points) - 1):
        if are_intersected(p1, p2, polygon_points[i], polygon_points[i + 1]):
            return [polygon_points[i], polygon_points[i + 1]]
    return []


def move(moving_points: list, vectors: list, i):
    moving_points[i] = moving_points[i] + vectors[i]


def remove_trapped(p0: Point, v0: Point, moving_points: list, vectors: list):
    moving_points.remove(p0)
    vectors.remove(v0)


def init_motion(moving_points: list, external_polygon: list, internal_polygon: list):
    vectors = gen_velocity(moving_points)
    while len(moving_points) != 0:
        draw_polygon(external_polygon, "k")
        draw_polygon(internal_polygon, "r")
        draw_points(moving_points)
        camera.snap()
        for i in range(len(moving_points)):
            if i >= len(moving_points):
                continue
            next_point = Point(moving_points[i].x + vectors[i].x, moving_points[i].y + vectors[i].y)
            while binary_test(next_point, external_polygon) == "out":
                
                edges = intersected_edge(moving_points[i], next_point, external_polygon)
                if len(edges) == 0:
                    
                    move(moving_points, vectors, i)
                    continue
                edge_p1 = edges[0]
                edge_p2 = edges[1]

                vectors[i] = reflected_vector(vectors[i], edge_p1, edge_p2)
                next_point = Point(moving_points[i].x + vectors[i].x, moving_points[i].y + vectors[i].y)

            if octants_test(next_point, internal_polygon) == "in":
                remove_trapped(moving_points[i], vectors[i], moving_points, vectors)
                continue
            move(moving_points, vectors, i)


def main():
    points = gen_points()
    ext_poly = gen_ext_poly()
    int_poly = gen_int_poly()
    init_motion(points, ext_poly, int_poly)
    ani = camera.animate(blit=False, interval=100)
    plt.show()


if __name__ == "__main__":
    main()

