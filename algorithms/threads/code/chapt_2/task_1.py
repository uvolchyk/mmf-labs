import plotly.express as px
import pandas as pd
import numpy as np
import datetime as dt

blocks = [[2,1,4,1],[1,3,2,3],[2,4,1,2],[3,2,3,1]]

def ganttConverter(T):

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

c_df = pd.DataFrame(ganttConverter(blocks))
c_fig = px.timeline(c_df, x_start="start", x_end="duration", y="process", color="block")
c_fig.show()