import plotly.express as px
import pandas as pd
import numpy as np
import datetime as dt

blocks = [[2,1,4,1],[1,3,2,3],[2,4,1,2],[3,2,3,1]]

def get_launch_moments(T):
    launch_moments = []
    # constructing an array of launching moments
    for i in range(len(T)):
        start_anchor = 0
        if i != 0:
            for j in range(i):
                start_anchor += T[i-1][j]
        launch_moments.append(start_anchor)
    return launch_moments

def get_sync2_launch_moments(T):
    launch_moments = []

    for i in range(len(T)):
        start_anchor = 0
        if i != 0:
            for j in range(i):
                start_anchor += T[j][0]
        launch_moments.append(start_anchor)
    return launch_moments


def gantt_converter_async(T):
    launch_moments = get_launch_moments(T)
    result = []
    # constructing a chart's metadata
    for (i, process) in enumerate(T):
        c_sum = launch_moments[i]
        for (j, block_time) in enumerate(process):
            result.append(
                dict(
                    process=i,
                    block=j,
                    duration=dt.datetime.fromtimestamp(block_time+c_sum).strftime('%Y-%m-%d %H:%M:%S'),
                    start=dt.datetime.fromtimestamp(c_sum).strftime('%Y-%m-%d %H:%M:%S')
                )
            )
            c_sum += block_time
    return result


def gantt_converter_sync1(T):
    launch_moments = [0 for _ in range(len(T))]
    result = []
    
    for i in range(len(T)):
        if i > 0:
            for j in range(len(T[i])):
                if T[i-1][j]>T[i][j]:
                    launch_moments[i]+=(T[i-1][j]-T[i][j])

        for j in range(i+1,len(T)):
            launch_moments[j]=launch_moments[i]

    for (i, process) in enumerate(T):
        c_sum = launch_moments[i]
        for (j, block_time) in enumerate(process):
            result.append(
                dict(
                    process=i,
                    block=j,
                    duration=dt.datetime.fromtimestamp(block_time+c_sum).strftime('%Y-%m-%d %H:%M:%S'),
                    start=dt.datetime.fromtimestamp(c_sum).strftime('%Y-%m-%d %H:%M:%S')
                )
            )
            c_sum += block_time
    return result
    

def gantt_converter_sync2(T):
    # launch_moments = get_launch_moments(T)
    result = []

    launch_moments = get_sync2_launch_moments(T)
    
    # traversal through blocks by processes
    for i in range(len(T[0])):
        
        for j in range(len(T)):
            block_duration = T[j][i]

            #peeking for out of range
            if j != 0:
                if launch_moments[j] < launch_moments[j-1]:
                    launch_moments[j] = launch_moments[j-1]

            start_point = launch_moments[j]
            result.append(
                dict(
                    process=j,
                    block=i,
                    duration=dt.datetime.fromtimestamp(block_duration+start_point).strftime('%Y-%m-%d %H:%M:%S'),
                    start=dt.datetime.fromtimestamp(start_point).strftime('%Y-%m-%d %H:%M:%S')
                )
            )
            launch_moments[j] += block_duration
    return result



# result = sorted(gantt_converter_sync2(blocks), key=lambda i: i["process"])
result = gantt_converter_sync1(blocks)
# for i in result:
#     print(i)

# print(gantt_converter_sync1(blocks))

c_df = pd.DataFrame(result)
c_fig = px.timeline(c_df, x_start="start", x_end="duration", y="process", color="block")
c_fig.show()

