
#--------------------------------------
# Поиск минимального элемента без i
#--------------------------------------
def min_element(lst, i):
    return min(x for idx, x in enumerate(lst) if idx != i)

#--------------------------------------
# Удаление строки index1 и столбца index2
#--------------------------------------
def delete_element(matrix, i, j):
    del matrix[i]
    for el in matrix:
        del el[j]
    return matrix

#--------------------------------------
# Вывод матрицы матрицы
#--------------------------------------
def print_matrix(matrix):
    print("---------------")
    for i in range(len(matrix)):
        print(matrix[i])
    print("---------------")

n = 6
initial_matrix = [
    [float('inf'), 5, 5, 7, 10, 15],
    [5, float('inf'), 4, 12, 5, 6],
    [5, 4, float('inf'), 2, 4, 3],
    [7, 12, 2, float('inf'), float('inf'), 14],
    [10, float('inf'), 4, 2, float('inf'), 3],
    [15, 6, 3, 14, 3, float('inf')]
]
H=0
path_length=0
Str=[]
Stb=[]
res=[]
result=[]
initial_matrix_copy=[]

#--------------------------------------
#Инициализируем массивы для сохранения индексов
#--------------------------------------
for i in range(n):
    Str.append(i)
    Stb.append(i)
	
#--------------------------------------
#Сохраняем изначальную матрицу
#--------------------------------------
for i in range(n):
    initial_matrix_copy.append(initial_matrix[i].copy())

#--------------------------------------
#Присваеваем главной диагонали float(inf)
#--------------------------------------
for i in range(n): 
    initial_matrix[i][i]=float('inf')

while True:
    #--------------------------------------
    # Вычитаем минимальный элемент в строках
    #--------------------------------------
    for i in range(len(initial_matrix)):
        temp = min(initial_matrix[i])
        H += temp
        for j in range(len(initial_matrix)):
            initial_matrix[i][j] -= temp

    #--------------------------------------
    # Вычитаем минимальный элемент в столбцах    
    #--------------------------------------
    for i in range(len(initial_matrix)):
        temp = min(row[i] for row in initial_matrix)
        H+=temp
        for j in range(len(initial_matrix)):
            initial_matrix[j][i]-=temp

    #--------------------------------------
    # Оцениваем нулевые клетки и ищем нулевую клетку с максимальной оценкой
    #--------------------------------------
    null_max = 0
    index1 = 0
    index2 = 0
    tmp = 0
    for i in range(len(initial_matrix)):
        for j in range(len(initial_matrix)):
            if initial_matrix[i][j]==0:
                tmp = min_element(initial_matrix[i],j) + min_element((row[j] for row in initial_matrix),i)
                if tmp >= null_max:
                    null_max = tmp
                    index1 = i
                    index2 = j
    #--------------------------------------
	# Находим нужный нам путь, записываем его в res и удаляем все ненужное
    #--------------------------------------
    res.append(Str[index1] + 1)
    res.append(Stb[index2] + 1)
	
    oldIndex1=Str[index1]
    oldIndex2=Stb[index2]
    if oldIndex2 in Str and oldIndex1 in Stb:
        newIndex1=Str.index(oldIndex2)
        newIndexj=Stb.index(oldIndex1)
        initial_matrix[newIndex1][newIndexj]=float('inf')
    del Str[index1]
    del Stb[index2]
    initial_matrix=delete_element(initial_matrix,index1,index2)
    if len(initial_matrix)==1:break
	
#--------------------------------------
# Формируем маршрут
#--------------------------------------
for i in range(0,len(res)-1,2):
	if res.count(res[i])<2:
		result.append(res[i])
		result.append(res[i+1])
for i in range(0,len(res)-1,2):
	for j in range(0,len(res)-1,2):
		if result[len(result)-1]==res[j]:
			result.append(res[j])
			result.append(res[j+1])
print("----------------------------------")
print(result)

#--------------------------------------
# Считаем длину маршрута
#--------------------------------------
for i in range(0,len(result)-1,2):
    if i==len(result)-2:
        path_length+=initial_matrix_copy[result[i]-1][result[i+1]-1]
        path_length+=initial_matrix_copy[result[i+1]-1][result[0]-1]
    else: path_length+=initial_matrix_copy[result[i]-1][result[i+1]-1]
print(path_length)
print("----------------------------------")

print_matrix(initial_matrix_copy)
