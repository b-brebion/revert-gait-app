import argparse
import json
import numpy as np
import plotly.graph_objects as go

def parse_SIMD3(string):
    values = string[string.find('(')+1 : string.find(')')]
    return list(map(float, values.split(", ")))

def parse_data(data):
    x = []
    y = []
    z = []

    for i in range(len(data)):
        x.append([])
        y.append([])
        z.append([])
        data[i].pop("bodyOrientation")
        for name, value in data[i].items():
            values = parse_SIMD3(value)
            x[-1].append(values[0])
            y[-1].append(values[2])
            z[-1].append(values[1])
    
    return x, y, z

def create_figure(x, y, z):
    fig_dict = {"data": [], "layout": {"scene": {}}, "frames": []}

    # Initial data and display options
    fig_dict["data"] = go.Scatter3d(x=x[0], y=y[0], z=z[0], mode="markers", marker={"color": "green", "size": 6})

    # Frames configuration
    fig_dict["frames"] = [go.Frame(data=[go.Scatter3d(x=x[k], y=y[k], z=z[k])], traces=[0], name=f'frame{k}') for k in range(len(x))]

    # Layout configuration
    offset = 0.5

    fig_dict["layout"]["scene"]["xaxis"] = {"range": [np.min(x)-offset, np.max(x)+offset], "autorange": False}
    fig_dict["layout"]["scene"]["yaxis"] = {"range": [np.min(y)-offset, np.max(y)+offset], "autorange": False}
    fig_dict["layout"]["scene"]["zaxis"] = {"range": [np.min(z)-offset, np.max(z)+offset], "autorange": False}
    fig_dict["layout"]["scene"]["aspectratio"] = {"x": 1, "y": 1, "z": 1}
    fig_dict["layout"]["updatemenus"] = [
        {
            "buttons": [
                {
                    "label": "Play",
                    "method": "animate",
                    "args": [None, 
                                {
                                    "frame": {"duration": 15, "redraw": True},
                                    "fromcurrent": True,
                                    "transition": {"duration": 5, "easing": "quadratic-in-out"}
                                }
                            ]
                },
                {
                    "label": "Pause",
                    "method": "animate",
                    "args": [[None], 
                                {
                                    "frame": {"duration": 0, "redraw": False},
                                    "mode": "immediate",
                                    "transition": {"duration": 0}
                                }
                            ]
                }
            ],
            "direction": "left",
            "pad": {"r": 10, "t": 87},
            "showactive": False,
            "type": "buttons",
            "x": 0.1,
            "xanchor": "right",
            "y": 0,
            "yanchor": "top"
        }
    ]
    fig_dict["layout"]["sliders"] = [
        {
            "pad": {"b": 10, "t": 60},
            "len": 0.9,
            "x": 0.1,
            "y": 0, 
            "steps": [
                {
                    "args": [[f.name], {
                            "frame": {"duration": 10},
                            "mode": "immediate",
                            "fromcurrent": True,
                            "transition": {"duration": 5, "easing": "linear"},
                        }
                    ],
                    "label": str(k),
                    "method": "animate",
                } for k, f in enumerate(fig_dict["frames"])
            ]
        }
    ]
    
    return fig_dict

if __name__ == "__main__":
    # Command-line parser
    parser = argparse.ArgumentParser()
    parser.add_argument("JSON_path", type=argparse.FileType('r', encoding='UTF-8'), help="Path to the JSON file to replay")
    args = parser.parse_args()

    # Reading the file
    data = json.load(args.JSON_path)
    args.JSON_path.close()

    # Parse data
    x, y, z = parse_data(data)

    # Create and display figure
    fig_dict = create_figure(x, y, z)
    fig = go.Figure(fig_dict)
    fig.show()
