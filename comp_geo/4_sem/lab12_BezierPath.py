import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np
import random

matplotlib.use('TkAgg')
fig, ax = plt.subplots()

MIN = -50
MAX = 50

bcurve_points = np.empty(shape=[0, 2], dtype=float)
points = []
segments = []
t = 0.0


def plot_points(points):
    [plt.scatter(p[0], p[1], color="c") for p in points]


def plot_curve(points):
    plt.plot(points[::, 0], points[::, 1], 'r', linewidth=4.0)


def plot_lines(lines, color='k'):
    for line in lines:
        x,y = zip(*line)
        plt.plot(x, y, color)
        

def find_point(segment, t):
    return (segment[0] * t) + (segment[1] * (1 - t))


def find_bezier_curve_point_recursive(segments, t):
    if len(segments) == 1:
        return find_point(segments[0], t)
        
    new_points = [find_point(segments[i], t) for i in range(len(segments))]
    new_segments = [[new_points[i], new_points[i + 1]] for i in range(len(new_points) - 1)]
    plot_lines(new_segments)
    return find_bezier_curve_point_recursive(new_segments, t)


def animate(a):
    global segments
    global t
    global bcurve_points
    plt.clf()
    plot_points(points)
    plot_lines(segments, 'g')
    bcurve_point = find_bezier_curve_point_recursive(segments, t)
    bcurve_points = np.append(bcurve_points, np.array([bcurve_point]), axis=0)
    plot_curve(bcurve_points)
    t += 0.01


def main():
    print("Input points number")
    n = int(input("n: "))
    global points
    points = np.random.randint(MIN,MAX,size=(n,2))
        
    global segments
    segments = [[points[i], points[i+1]] for i in range(0,n - 1)]

    ani = animation.FuncAnimation(fig, animate, frames=100, interval=10, repeat=False)
    plt.show()


if __name__ == "__main__":
    main()