from bisect import bisect_left, insort
import numpy as np
import math
import itertools

class search:
    def __init__(self):
        self.values = []

    def insert(self, value):
        # not value in self.values
        print("insert", value)
        self.values.append(value)
        self.values = sorted(self.values, key=lambda p1: (p1[0], p1[1]))
        # insort(self.values, value)

    def isEmpty(self):
        return len(self.values) == 0

    def delete(self, value):
        # value in self.values
        print("delete", value)
        self.values.pop(self.position(value))

    def find_neighbors(self, value):
        p = self.position(value)
        l = None
        r = None
        if p>0: l = self.values[p-1]
        if p<len(self.values)-1: r = self.values[p+1]
        return (l,r)

    def shift(self):
        return self.values.pop(0)

    def position(self, value):
        for i, p in enumerate(self.values):
            if p[0]==value[0] and p[1]==value[1]:
                return i
        raise ValueError 

    def segmentAtPosition(self, i):
        return self.values[i]

    def array(self):
        return self.values



def det(p1,p2):
    return p1[0]*p2[1]-p2[0]*p1[1]
    # try: 
    #     return np.linalg.det([p1,p2])
    # except:
    #     return 0
    

def distanceTo(p1,p2):
    return math.pow(p1[0]-p2[0],2) + math.pow(p1[1]-p2[1],2)

def rotate(A,B,C):
    return (B[0]-A[0])*(C[1]-B[1])-(B[1]-A[1])*(C[0]-B[0])

def isToLeft(p1,p2,p3):
    p1,p2,p3 = np.array(p1),np.array(p2),np.array(p3)
    return True if ((p2[0]-p3[0])*(p4[1]-p3[1])-(p2[1]-p3[1])*(p4[0]-p3[0])) >= 0 else False

def moveOriginTo(origin, array):
    # result = []
    # for i in range(origin, len(array)):
    #     result.append(array[i])
    # for i in range(origin):
    #     result.append(array[i])
    # return result
    x,y = zip(*array)
    newX = x[origin:] + x[:origin]
    newY = y[origin:] + y[:origin]
    result = np.array(list(zip(newX, newY)))
    # print(result, "<---------HERE")
    return result

def line(p1, p2):
    A = (p1[1] - p2[1])
    B = (p2[0] - p1[0])
    C = (p1[0]*p2[1] - p2[0]*p1[1])
    return A, B, -C

def intersection(L1, L2):
    D  = L1[0] * L2[1] - L1[1] * L2[0]
    Dx = L1[1] * L2[0] - L1[0] * L2[1]
    Dy = L1[0] * L2[1] - L1[1] * L2[0]
    if D != 0:
        x = Dx / D
        y = Dy / D
        return x,y
    return []

def intersect(A,B,C,D): 
  return rotate(A,B,C)*rotate(A,B,D)<=0 and rotate(C,D,A)*rotate(C,D,B)<0

def jarvis(A):
    n = len(A)
    P = [i for i in range(n)]
    
    # start point
    for i in range(1,n):
      if A[P[i]][0]<A[P[0]][0]: 
        P[i], P[0] = P[0], P[i]  
    H = [P[0]]
    del P[0]
    P.append(H[0])
    while True:
      right = 0
      for i in range(1,len(P)):
        if rotate(A[H[-1]],A[P[right]],A[P[i]])<0:
          right = i
      if P[right]==H[0]: 
        break
      else:
        H.append(P[right])
        del P[right]
    result = [A[i] for i in H]      
    result.append(result[0])
    return result

