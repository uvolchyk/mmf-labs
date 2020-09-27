# TODO:
#little buggy, it being fixed in the future

# convex hull dynamic build

import random
import math
import time
from matplotlib import pyplot as plt
from celluloid import Camera
from Point import Point
from Vector import Vector

# Dynamic convex hull algorithm

fig = plt.figure()
camera = Camera(fig)


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


def point_distance(p1: Point, p2: Point):
    return math.sqrt(abs((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)))


def find_middle_point(p1: Point, p2: Point, p3: Point):
    if Vector(p3, p1) * Vector(p3, p2) < 0:
        return p3
    elif Vector(p2, p1) * Vector(p2, p3) < 0:
        return p2
    else:
        return p1


def dynamic_convex_hull(points: list, latest_convex_hull: list):
    if len(points) <= 2:
        return points

    if len(points) == 3:
        if get_point_position_to_line(points[0], points[1], points[2]) == "on the line":
            mid_point = find_middle_point(points[0], points[1], points[2])
            if mid_point == points[0]:
                return [points[1], points[2]]
            elif mid_point == points[1]:
                return [points[0], points[2]]
            else:
                return [points[0], points[1]]
        else:
            if get_point_position_to_line(points[2], points[0], points[1]) == "left":
                return [points[0], points[1], points[2]]
            if get_point_position_to_line(points[2], points[0], points[1]) == "right":
                return [points[0], points[2], points[1]]

    if len(points) > 3:
        new_point = points[-1]

        right_edges_indexes = []
        gap_index = 0
        for i in range(len(latest_convex_hull)):
            if get_point_position_to_line(new_point, latest_convex_hull[i],
                                          latest_convex_hull[(i + 1) % len(latest_convex_hull)]) == "right":
                right_edges_indexes.append(i)
                if i + 1 not in right_edges_indexes:
                    right_edges_indexes.append(i + 1)
            else:
                gap_index = i + 1

        if len(right_edges_indexes) == 0:
            return latest_convex_hull

        new_convex_hull = []

        if get_point_position_to_line(new_point, latest_convex_hull[-1], latest_convex_hull[0]) == "left":
            start_index = right_edges_indexes[0]
            end_index = right_edges_indexes[-1]
            new_convex_hull.extend(latest_convex_hull[0: start_index + 1])
            new_convex_hull.append(new_point)
            new_convex_hull.extend(latest_convex_hull[end_index: len(latest_convex_hull)])
        else:        
            if right_edges_indexes[0] != 0:
                start_index = 0 
            else: 
                gap_index - 1

            end_index = gap_index

            for i in range(len(right_edges_indexes) - 1):
                delta = abs(right_edges_indexes[(i + 1) % len(right_edges_indexes)] - right_edges_indexes[i])
                if delta > 1:
                    start_index = right_edges_indexes[i]
                    end_index = (start_index + delta) % len(latest_convex_hull)
                    break

            new_convex_hull.append(new_point)
            for i in range(abs(end_index - start_index) + 1):
                new_convex_hull.append(latest_convex_hull[(start_index + i) % len(latest_convex_hull)])

        return new_convex_hull


def draw_convex_hull(convex_hull_points: list, color: str):
    for i in range(len(convex_hull_points)):
        plt.plot([convex_hull_points[i].x, convex_hull_points[(i + 1) % len(convex_hull_points)].x],
                 [convex_hull_points[i].y, convex_hull_points[(i + 1) % len(convex_hull_points)].y], color=color)


def draw_point(point: Point):
    plt.scatter(point.x, point.y)


def draw_points(points: list):
    for i in range(len(points)):
        draw_point(points[i])


def generate_point(points: list):
    points.append(Point(random.randint(0, 30), random.randint(0, 30)))


def init_generation():
    points = []
    convex_hull = []

    for i in range(25):
        generate_point(points)

        is_existed = False
        for j in range(len(points) - 1):
            if points[j] == points[-1]:
                is_existed = True
        if is_existed:
            print("point is exist")
            continue

        draw_points(points)
        convex_hull = dynamic_convex_hull(points, convex_hull)
        if len(convex_hull) == 1:
            draw_point(convex_hull[0])
        else:
            draw_convex_hull(convex_hull, "blue")
        camera.snap()


def init():
    init_generation()
    plt.grid(True)
    animation = camera.animate(blit=False, interval=350)
    plt.show()


init()
