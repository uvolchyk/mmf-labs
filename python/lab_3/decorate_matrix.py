import numpy as np

def decorate_matrix(n):
    matrix = np.zeros((n, n), dtype='int')
    matrix[0] = 1
    matrix[-1] = 1
    matrix[:, 0] = 1
    matrix[:, -1] = 1
    return matrix

if __name__ == '__main__':
    print(str(decorate_matrix(10)))