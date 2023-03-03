import math
import pandas as pd

from datetime import datetime
# import matplotlib.pyplot as plt
from meteostat import Point, Daily

data = pd.read_csv("./Fire_Department_Calls_for_Service.csv")

# Set time period
start = datetime(2001, 1, 1)
end = datetime(2001, 1, 1)

# Create Point for Vancouver, BC
location = Point(49.2497, -123.1193, 70)

# Get daily data for 2018
data = Daily(location, start, end)
data = data.fetch()
print(data)


# if __name__ == "__main__":
#     print(champernowne(10, 7))
