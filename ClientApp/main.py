from peewee import fn
from tabulate import tabulate

import mydb as my_db

user_name = None


def init_db():
    my_db.database.connect()


def show_distinct_counties():
    counties = my_db.County.select(my_db.County.name)
    print("Here are all the counties we have statistics on:")
    print(tabulate(counties.dicts(), headers="keys"))


def show_distinct_states():
    states = my_db.State.select(my_db.State.name)
    print("Here are all the States we have statistics on:")
    print(tabulate(states.dicts(), headers="keys"))


def show_distinct_candidates():
    candidates = my_db.Candidate.select(my_db.Candidate.name)
    print("Here are all the Candidates we have statistics on:")
    print(tabulate(candidates.dicts(), headers="keys"))


def show_distinct_parties():
    parties = my_db.Candidate.select(my_db.Candidate.abbreviation, my_db.Candidate.party).distinct()
    print("Here are all the parties that we have stats on:")
    print(tabulate(parties.dicts(), headers="keys"))


def get_county_stats():
    filters = {1: '1) Filter by year (2020 by default)', 2: '2) Filter by county name (all counties by default)',
               3: '3) Filter by winner party (Democratic Party by default)'}
    year = 2020
    county_name = ''
    winner_party = 'DEM'
    keep_going = 1

    while keep_going == 1 and len(filters) > 0:

        for idx, val in filters.items():
            print(val)

        val = int(input("\n Please enter a value: "))

        if val == 1:
            year = int(input("Enter year to filter by (2020 or 2016): "))
            del filters[val]
        elif val == 2:
            valid_name = str(input("If you don't know any valid county names please enter 1 else 0: "))
            if valid_name == 1:
                show_distinct_counties()
            county_name = str(input("Please enter a valid county name: "))
            del filters[val]
        elif val == 3:
            winner_party = str(input("Please enter DEM, REP or ...: "))
            del filters[val]
        else:
            print("ENDED!")
        keep_going = int(input("Do you want to keep filtering by the remaining options? Please enter 1 or 0: "))

    if county_name == '':
        results = my_db.CountyResult \
            .select(my_db.County.name.alias('county_name'), my_db.Candidate.name.alias('candidate_name'),
                    my_db.Candidate.party, my_db.CountyResult.fraction_vote_dem,
                    my_db.CountyResult.fraction_vote_rep, my_db.CountyResult.fraction_vote_other) \
            .join(my_db.County) \
            .join(my_db.Candidate, on=(my_db.Candidate.id == my_db.CountyResult.winner)) \
            .where((my_db.CountyResult.year == year) & (my_db.Candidate.abbreviation == winner_party))
    else:
        results = my_db.CountyResult \
            .select(my_db.County.name.alias('county_name'), my_db.Candidate.name.alias('candidate_name'),
                    my_db.Candidate.party, my_db.CountyResult.fraction_vote_dem,
                    my_db.CountyResult.fraction_vote_rep, my_db.CountyResult.fraction_vote_other) \
            .join(my_db.County) \
            .join(my_db.Candidate, on=(my_db.Candidate.id == my_db.CountyResult.winner)) \
            .where((my_db.CountyResult.year == year) & (my_db.County.name == county_name))

    print(tabulate(results.dicts(), headers="keys"))


def get_state_stats():
    filters = {1: '1) Filter by year (2020 by default)', 2: '2) Filter by state name (all states by default)',
               3: '3) Filter by winner party (Democratic Party by default)'}
    year = 2020
    state = ''
    winner_party = 'Democratic Party'
    keep_going = 1

    while keep_going == 1 and len(filters) > 0:

        for idx, val in filters.items():
            print(val)

        val = int(input("\n Please enter a value: "))

        if val == 1:
            year = int(input("Enter year to filter by (2020 or 2016): "))
            del filters[val]
        elif val == 2:
            valid_name = str(input("If you don't know any valid state names please enter 1 else 0: "))
            if valid_name == 1:
                show_distinct_states()
            state = str(input("Please enter a valid state: "))
            del filters[val]
        elif val == 3:
            winner_party = str(input("Please enter DEM, REP or Other: "))
            del filters[val]
        else:
            print("ENDED!")
        keep_going = int(input("Do you want to keep filtering by the remaining options? Please enter 1 or 0: "))

    if state == '':
        results = my_db.CountyResult \
            .select(my_db.County.name.alias('county_name'), my_db.Candidate.name.alias('candidate_name'),
                    my_db.Candidate.party, my_db.CountyResult.fraction_vote_dem,
                    my_db.CountyResult.fraction_vote_rep, my_db.CountyResult.fraction_vote_other, my_db.State.name) \
            .join(my_db.County) \
            .join(my_db.State, on=(my_db.State.id == my_db.County.state_ID)) \
            .join(my_db.Candidate, on=(my_db.Candidate.id == my_db.CountyResult.winner)) \
            .where((my_db.CountyResult.year == year) & (my_db.Candidate.abbreviation == winner_party))
    else:
        results = my_db.CountyResult \
            .select(my_db.County.name.alias('county_name'), my_db.Candidate.name.alias('candidate_name'),
                    my_db.Candidate.party, my_db.CountyResult.fraction_vote_dem,
                    my_db.CountyResult.fraction_vote_rep, my_db.CountyResult.fraction_vote_other, my_db.State.name) \
            .join(my_db.County) \
            .join(my_db.State, on=(my_db.State.id == my_db.County.state_ID)) \
            .join(my_db.Candidate, on=(my_db.Candidate.id == my_db.CountyResult.winner)) \
            .where(
            (my_db.CountyResult.year == year) & (my_db.Candidate.abbreviation == winner_party) & (
                    my_db.State.name == state))

    print(tabulate(results.dicts(), headers="keys"))


def get_county_covid_stats():
    filters = {1: '1) Filter by county name', 2: '2) Select all counties'}
    for idx, val in filters.items():
        print(val)

    county_name = ''
    val = int(input("\n Please enter a value: "))

    if val == 1:
        valid_name = str(input("If you don't know any valid county names please enter 1 else 0: "))
        if valid_name == 1:
            show_distinct_counties()
        county_name = str(input("Please enter a valid county name: "))

    if county_name == '':
        results = my_db.CountyCovid.select(my_db.CountyCovid.num_cases, my_db.CountyCovid.num_deaths, my_db.County.name) \
            .join(my_db.County)
    else:
        results = my_db.CountyCovid.select(my_db.CountyCovid.num_cases, my_db.CountyCovid.num_deaths, my_db.County.name) \
            .join(my_db.County) \
            .where(my_db.County.name == county_name)

    print(tabulate(results.dicts(), headers="keys"))


def get_state_covid_stats():
    filters = {1: '1) Filter by state name (all states by default)', 2: '2) Select all states'}
    for idx, val in filters.items():
        print(val)

    state_name = ''
    val = int(input("\n Please enter a value: "))

    if val == 1:
        valid_name = str(input("If you don't know any valid state names please enter 1 else 0: "))
        if valid_name == 1:
            show_distinct_states()
        state_name = str(input("Please enter a valid state: "))
        del filters[val]

    if state_name == '':
        results = my_db.CountyCovid.select(fn.Sum(my_db.CountyCovid.num_cases), fn.Sum(my_db.CountyCovid.num_deaths),
                                           my_db.State.name) \
            .join(my_db.County) \
            .join(my_db.State, on=(my_db.State.id == my_db.County.state_ID)).group_by(my_db.State.id)
    else:
        results = my_db.CountyCovid.select(fn.Sum(my_db.CountyCovid.num_cases), fn.Sum(my_db.CountyCovid.num_deaths),
                                           my_db.State.name) \
            .join(my_db.County) \
            .join(my_db.State, on=(my_db.State.id == my_db.County.state_ID)).group_by(my_db.State.id) \
            .where(my_db.State.name == state_name)

    print(tabulate(results.dicts(), headers="keys"))


def get_county_stats_with_demographics():
    filters = {1: '1) Filter by unemployment rate', 2: '2) Filter by percent poverty',
               3: '3) Filter by median income', 4: '4) Filter by percent white population',
               5: '5) Filter by percent black population', 6: '6) Filter by percent hispanic population',
               7: '7) Filter by percent native population', 8: '8) Filter by percent asian population',
               9: '9) Filter by county name ', 0: '0) Go back to main menu'}

    unemployment_rate = 0
    percent_poverty = 0
    median_income = 0
    percent_white = 0
    percent_black = 0
    percent_hispanic = 0
    percent_native = 0
    percent_asian = 0
    county_name = ''
    keep_going = 1

    while keep_going == 1 and len(filters) > 0:

        for idx, val in filters.items():
            print(val)

        val = int(input("\n Please enter a value: "))

        if val == 1:
            unemployment_rate = str(input("Enter employment rate to filter by (greater than): "))
            del filters[val]
        elif val == 2:
            percent_poverty = str(input("Enter percent poverty to filter by (greater than): "))
            del filters[val]
        elif val == 3:
            median_income = str(input("Enter median income to filter by (greater than): "))
            del filters[val]
        elif val == 4:
            percent_white = str(input("Enter percent white to filter by (greater than): "))
            del filters[val]
        elif val == 5:
            percent_black = str(input("Enter percent black to filter by (greater than): "))
            del filters[val]
        elif val == 6:
            percent_hispanic = str(input("Enter percent hispanic to filter by (greater than): "))
            del filters[val]
        elif val == 7:
            percent_native = str(input("Enter percent native to filter by (greater than): "))
            del filters[val]
        elif val == 8:
            percent_asian = str(input("Enter percent asian to filter by (greater than): "))
            del filters[val]
        elif val == 9:
            valid_name = int(input("If you don't know any valid county names please enter 1 else 0: "))
            if valid_name == 1:
                show_distinct_counties()
            county_name = str(input("Please enter a valid county name: "))
            del filters[val]
        elif val == 0:
            return
        else:
            print("No valid options selected! Returning to main menu")
            return
        keep_going = int(input("Do you want to keep filtering by the remaining options? Please enter 1 or 0: "))

    if county_name == '':
        results = my_db.CountyDemographic \
            .select() \
            .join(my_db.County) \
            .where(my_db.CountyDemographic.percent_asian >= percent_asian &
                   my_db.CountyDemographic.percent_native >= percent_native &
                   my_db.CountyDemographic.median_income >= median_income &
                   my_db.CountyDemographic.percent_white >= percent_white &
                   my_db.CountyDemographic.percent_black >= percent_black &
                   my_db.CountyDemographic.percent_hispanic >= percent_hispanic &
                   my_db.CountyDemographic.unemployment_rate >= unemployment_rate &
                   my_db.CountyDemographic.percent_poverty >= percent_poverty)
    else:
        results = my_db.CountyDemographic \
            .select() \
            .join(my_db.County) \
            .where((my_db.CountyDemographic.percent_asian >= percent_asian) &
                   (my_db.CountyDemographic.percent_native >= percent_native) &
                   (my_db.CountyDemographic.median_income >= median_income) &
                   (my_db.CountyDemographic.percent_white >= percent_white) &
                   (my_db.CountyDemographic.percent_black >= percent_black) &
                   (my_db.CountyDemographic.percent_hispanic >= percent_hispanic) &
                   (my_db.CountyDemographic.unemployment_rate >= unemployment_rate) &
                   (my_db.CountyDemographic.percent_poverty >= percent_poverty) &
                   (my_db.County.name == county_name))

    print(tabulate(results.dicts(), headers="keys"))


def show_main_menu_options():
    print("\n Enter a number to select the option!")
    print("1) Get county stats from year 2016 or 2020")
    print("2) Get state stats from year 2016 or 2020")
    print("3) Get number of deaths and cases covid stats for counties")
    print("4) Get number of deaths and cases covid stats for states")
    print("5) Get election results from counties with county demographics for year 2020")
    print("6) Show all counties")
    print("7) Show all states")
    print("8) Show all candidates")
    print("9) Show all parties")
    print("10) Add annotations")
    print("0) Exit the program")


def add_annotations():
    print("Please enter what you'd like to annotate for? State or county or both?")
    option = int(input("Enter 0 for state, 1 for county and 2 for both:"))
    state = ''
    county = ''
    if option == 0:
        valid_name = str(input("If you don't know any valid state names please enter 1 else 0: "))
        if valid_name == 1:
            show_distinct_states()
        state = str(input("Please enter the state:"))
    elif option == 1:
        valid_name = str(input("If you don't know any valid county names please enter 1 else 0: "))
        if valid_name == 1:
            show_distinct_counties()
        county = str(input("Please enter the county:"))
    elif option == 2:
        valid_name = str(input("If you don't know any valid state names please enter 1 else 0: "))
        if valid_name == 1:
            show_distinct_states()
            valid_name = str(input("If you don't know any valid county names please enter 1 else 0: "))
        if valid_name == 1:
            show_distinct_counties()
        state = str(input("Please enter the state:"))
        county = str(input("Please enter the county:"))
    else:
        print("No valid options were selected, returning to main menu")
        return

    annotation = str(input("Please enter the text you'd like to annotate: "))
    insert_annotation(state, county, annotation)


def insert_annotation(state, county, annotation):
    result = my_db.Annotations.insert(user_id=user_name, state=state, county=county, annotation=annotation).execute()
    if result == 0:
        print("Successfully added the annotations! \n")


def get_annotations(state='', county=''):
    result = None
    if state == '' and user_name is not None:
        result = my_db.Annotations.select().where(my_db.Annotations.user_id == user_name,
                                                  my_db.Annotations.county == county)
    elif county == '' and user_name is not None:
        result = my_db.Annotations.select().where(my_db.Annotations.user_id == user_name,
                                                  my_db.Annotations.state == state)
    else:
        result = my_db.Annotations.select().where(my_db.Annotations.user_id == user_name)

    print(tabulate(result.dicts(), headers="keys"))


def add_user():
    global user_name
    print("Please enter a user name (without spaces) so you can annotate!")
    user_name = str(input("Please enter your user name: "))


if __name__ == '__main__':
    init_db()
    add_user()
    while True:
        show_main_menu_options()
        input_val = int(input("\n Please enter a value: "))
        if input_val == 1:
            get_county_stats()
        elif input_val == 2:
            get_state_stats()
        elif input_val == 3:
            get_county_covid_stats()
        elif input_val == 4:
            get_state_covid_stats()
        elif input_val == 5:
            get_county_stats_with_demographics()
        elif input_val == 6:
            show_distinct_counties()
        elif input_val == 7:
            show_distinct_states()
        elif input_val == 8:
            show_distinct_candidates()
        elif input_val == 9:
            show_distinct_parties()
        elif input_val == 10:
            add_annotations()
        elif input_val == 0:
            break
