import pandas as pd
import os
from sodapy import Socrata
from datetime import datetime
# import matplotlib.pyplot as plt
from meteostat import Point, Daily
import re
import time


def get_data(file_path):
    if os.path.isfile(file_path):
        return pd.read_csv(file_path)
    else:
        # if file does not exist, then get the data. This may take a long time (IE 30mins)
        client = Socrata("data.sfgov.org", None)
        # Get 1 million results
        amount = (10**3)*1000
        results = client.get("nuek-vuh3", limit=(amount))
        fire_df = pd.DataFrame.from_records(results)
        fire_df.to_csv(file_path)
        # fire_df.head()
        return fire_df


def get_weather_data(fire_df, slim=False, verbose=False):
    new_data = {"tavg": [],  "tmin": [],  "tmax": [], "prcp": [], "snow": [
    ], "wdir": [], "wspd": [], "wpgt": [], "pres": [], "tsun": []}
    count = 0
    start_time = time.time()
    call_date = "Call Date"
    if slim:
        call_date = "Call.Date"
    for _, row in fire_df.iterrows():
        try:
            count += 1
            if verbose and count % 10000 == 0:
                print("time is: " + str(time.time()-start_time))
                print(
                    f"currently at: {count}\n{count/len(fire_df)*100} percent done!")
            if len(row[call_date]) > 0 and len(row["case_location"]) > 0:
                date = row[call_date].split("/")
                start = datetime(int(date[2]), int(date[0]), int(date[1]))
                end = start
                location = str(row["case_location"])
                location = re.split(r'\(| |\)', location)
                location = Point(float(location[3]), float(location[2]))
                data = Daily(location, start, end)
                data = data.fetch()
                if verbose and count % 100000 == 0:
                    print(data)
                for keys in new_data:
                    new_data[keys].append(data[keys][0])
            else:
                for keys in new_data:
                    new_data[keys].append(None)
        except Exception as e:
            print("Error Occured: ", e)
            print(row[call_date])
            print(row["case_location"])
            for keys in new_data:
                new_data[keys].append(None)
            continue
    print("Done!")
    return new_data


def save_weather(dict_data):
    csv_file = "weather.csv"
    import csv
    csv_columns = ["tavg",  "tmin",  "tmax", "prcp",
                   "snow", "wdir", "wspd", "wpgt", "pres", "tsun"]
    try:
        with open(csv_file, 'w') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=csv_columns)
            writer.writeheader()
            for data in dict_data:
                writer.writerow(data)
    except Exception as e:
        print("I/O error")


def combine_and_save_weather(fire_df, new_data, new_file):
    for keys in new_data:
        fire_df[keys] = new_data[keys]
    fire_df.drop(fire_df.filter(regex="Unname"), axis=1, inplace=True)
    fire_df.to_csv(new_file, index=False)


if __name__ == "__main__":
    file_name = "Fire_Department_Calls_for_Service_slim_50"
    fire_df = get_data(f"./{file_name}.csv")
    new_data = get_weather_data(
        fire_df, slim="slim" in file_name, verbose=True)
    save_weather(new_data)
    combine_and_save_weather(fire_df, new_data, f"./{file_name}_weather.csv")
