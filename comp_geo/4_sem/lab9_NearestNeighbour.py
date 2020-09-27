import math
import random
from matplotlib import pyplot as plt
from celluloid import Camera
from Point import Point

fig = plt.figure()
camera = Camera(fig)
ax = fig.gca


def init_moving_points():
    points = []

    for i in range(25):
        x = random.randint(0, 90)
        y = random.randint(0, 90)
        p = Point(x, y)
        points.append(p)

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

def opposite_vectors_of_moving(vector: Point):
    vector = Point(-vector.x, -vector.y)
    return vector

def det(a, b, c, d):
    return a * d - b * c

def sort_x(points: list):
    sorted = []
    sorted.extend(points[0: len(points)])
    for i in range(len(sorted)):
        min_i = i
        for j in range(i+1, len(sorted)):
            if sorted[min_i].x >= sorted[j].x:
                min_i = j
        sorted[i], sorted[min_i] = sorted[min_i], sorted[i]
    return sorted

def sort_y(points: list):
    sorted = []
    sorted.extend(points[0: len(points)])
    for i in range(len(sorted)):
        min_i = i
        for j in range(i+1, len(sorted)):
            if sorted[min_i].y >= sorted[j].y:
                min_i = j
        sorted[i], sorted[min_i] = sorted[min_i], sorted[i]
    return sorted

def point_distance(p1: Point, p2: Point):
    return math.sqrt(abs((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)))

def min_set_distance(points: list):
    min_distance_length = point_distance(points[0], points[1])
    for i in range(len(points) - 1):
        for j in range(i + 1, len(points)):
            if point_distance(points[i], points[j]) <= min_distance_length:
                min_distance_length = point_distance(points[i], points[j])
    return min_distance_length

def close_pair(sorted_by_x: list, sorted_by_y: list):
    if 1<len(sorted_by_x)<=3:
        distance = min_set_distance(sorted_by_x)
        return distance
    
    sep = sorted_by_x[math.floor(len(sorted_by_x) / 2)]
    sep_index = sorted_by_x.index(sep)
    x_left = sorted_by_x[0:sep_index]
    x_right = sorted_by_x[sep_index: len(sorted_by_x)]

    y_left = []
    y_right = []
    
    for i in range(len(sorted_by_y)):
        if sorted_by_y[i].x < sep.x:
            y_left.append(sorted_by_y[i])
        else:
            y_right.append(sorted_by_y[i])

    min_distance_left = close_pair(x_left, y_left)
    min_distance_right = close_pair(x_right, y_right)
    min_distance = min(min_distance_left, min_distance_right)

    delta_set = []
    for i in range(len(sorted_by_y)):
        if abs(sorted_by_y[i].x - sep.x) <= min_distance:
            delta_set.append(sorted_by_y[i])
    
    k = 0
    if len(delta_set) < 7:
        k = len(delta_set)
    else:
        k = 7
    
    for i in range(k-1):
        for j in range(i+1,k):
            if point_distance(delta_set[i], delta_set[j])<min_distance:
                min_distance = point_distance(delta_set[i], delta_set[j])
    
    return min_distance

def draw_points(points: list, radius: int):
    for i in range(len(points)):
        point = points[i]
        point = plt.Circle((point.x, point.y), radius, color="purple")
        plt.gcf().gca().add_artist(point)

def get_closest_pair_indexes(points: list, closest_pair_diameter):
    for i in range(len(points) - 1):
        for j in range(i + 1, len(points)):
            if point_distance(points[i], points[j]) == closest_pair_diameter:
                return (i, j)

def draw_min_distance(points: list, closest_pair_diameter):
    closest_pair_indexes = get_closest_pair_indexes(points, closest_pair_diameter)
    plt.plot([points[closest_pair_indexes[0]].x, points[closest_pair_indexes[1]].x],
             [points[closest_pair_indexes[0]].y, points[closest_pair_indexes[1]].y], "red")

def move(moving_points: list, vectors: list):
    for i in range(len(moving_points)):
        moving_points[i] = moving_points[i] + vectors[i]

def init_motion(points: list):
    radius = 1
    vectors = init_vectors_of_moving(points)
    i = 0
    while i < 100:
        print(i)
        draw_points(points, radius)

        points_sorted_by_x = sort_x(points)
        points_sorted_by_y = sort_y(points)

        closest_pair_diameter = close_pair(points_sorted_by_x, points_sorted_by_y)
        closest_pair_indexes = get_closest_pair_indexes(points, closest_pair_diameter)
        draw_min_distance(points, closest_pair_diameter)
        camera.snap()

        if closest_pair_diameter <= 2 * radius:
            vectors[closest_pair_indexes[0]] = opposite_vectors_of_moving(vectors[closest_pair_indexes[0]])
            vectors[closest_pair_indexes[1]] = opposite_vectors_of_moving(vectors[closest_pair_indexes[1]])
        move(points, vectors)

        i += 1

def init():
    points = init_moving_points()
    init_motion(points)
    plt.grid(True)
    plt.gca().set_xlim((0, 100))
    plt.gca().set_ylim((0, 100))
    animation = camera.animate(blit=False, interval=100)
    plt.show()

init()