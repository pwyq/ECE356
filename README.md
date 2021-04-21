# ECE356

## Running the Client App

Following instructions are for Linux/macOS.

1. Connect to UWaterloo Network (VPN etc).

2. 

```
> cd ClientApp
```

3. Create a python3 virtual environment and source it

```
> python3 -m venv ./venv>
> source ./venv/bin/activate
```

4. Enter your credentials in `mydb.py`, specifically the `user` and `password` field in the `database` variable.

5.

```
> pip3 install -r requirements.txt
> python3 main.py
```

## Running tests

```
> cd ClientApp
> python3 -m unittest unit_tests
```

## Datasets

1. Prof: No need to use all indicated datasets

- [US Election 2020 Tweets](https://www.kaggle.com/manchunhui/us-election-2020-tweets) 830MB
    - Data is messy
    - created_at	tweet_id	tweet	likes	retweet_count	source	user_id	user_name	user_screen_name	user_description	user_join_date	user_followers_count	user_location	lat	long	city	country	continent	state	state_code	collected_at
- [Election, COVID, and Demographic Data by County](https://www.kaggle.com/etsc9287/2020-general-election-polls) 8MB
- [US Election 2020](https://www.kaggle.com/unanimad/us-election-2020) 3MB
    - (results for president_...csv only needed from this)
- Possibly useful [US County Social Health](https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data?select=us_county_sociohealth_data.csv) 5MB

- (Addresses will be needed for tying tweet source to voting county) [Debate data](https://www.kaggle.com/headsortails/us-election-2020-presidential-debates) (ignore the .mp3 files)