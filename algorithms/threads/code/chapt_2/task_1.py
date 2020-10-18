import plotly.express as px
import pandas as pd
import numpy as np
import datetime as dt

blocks = [[2,1,4,1],[1,3,2,3],[2,4,1,2],[3,2,3,1]]

def gantt_converter_unjoint(T):

    result = []
    c_sum = 0
    for (i, process) in enumerate(T, start=1):
        for (j, block) in enumerate(process, start=1):
            
            result.append(
                dict(
                    process=i,
                    block=j,
                    duration=dt.datetime.fromtimestamp(c_sum+block).strftime('%Y-%m-%d %H:%M:%S'),
                    start=dt.datetime.fromtimestamp(c_sum).strftime('%Y-%m-%d %H:%M:%S')
                    )
                )
            c_sum+=block
    return result

def gantt_converter_async(T):

    launch_moments = []
    result = []

    # constructing an array of launching moments
    for i in range(len(T)):
        start_anchor = 0
        if i != 0:
            for j in range(i):
                start_anchor += T[i-1][j]
        launch_moments.append(start_anchor)

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

    


# gantt_converter_async(blocks)

c_df = pd.DataFrame(gantt_converter_async(blocks))
c_fig = px.timeline(c_df, x_start="start", x_end="duration", y="process", color="block")
c_fig.show()
