import random
import numpy as np

def find_excess(positions, excess_value=30):
    min_excess_times = np.full(shape=(positions.shape[0]), fill_value=np.nan)
    for i, walker in enumerate(positions):
        it = np.nditer(walker, flags=['f_index'])
        while not it.finished:
            if abs(it[0]) >= excess_value:
                min_excess_times[i] = it.index
                break
            it.iternext()
    return min_excess_times[np.logical_not(np.isnan(min_excess_times))].min()

def many_random_walk_ans(walkers_num, steps_num, algo="randint"):
    if algo == "randint":
        steps = np.random.randint(0, 2, size=(walkers_num, steps_num + 1), dtype='int')
        steps = np.where(steps > 0, 1, -1)
    elif algo == "normal":
        steps = np.random.normal(0, 2, size=(walkers_num, steps_num + 1))
        steps = np.where(steps > 0, 1, -1)
    else:
        steps = np.array([[1 if random.randint(0, 1) else -1 for j in range(steps_num + 1)] for i in range(walkers_num)])
    steps[:, 0] = 0
    positions = steps.cumsum(axis=1)
    return positions

def main():
    for algo in ["randint", "normal", "random"]:
        positions = many_random_walk_ans(5000,300, algo=algo)
        print("———————————————————————————————")
        print("\nmin: {}, max: {}".format(positions.min(), positions.max()))
        print("excess time: {}".format(find_excess(positions)))
        print("generator kind '{}':\n".format(algo))

if __name__ == '__main__':
    main()