from peewee import fn

import mydb as my_db


def init_db():
    my_db.database.connect()


def show_distinct_counties():
    counties = my_db.County.select(my_db.County.name).distinct()
    print("Here are all the counties we have statistics on:")

    for idx, county in enumerate(counties):
        if idx % 9 == 0:
            print("\n")

        print("{}, ".format(county.name), end='')


def show_distinct_states():
    states = my_db.State.select(my_db.State.name).distinct()
    print("Here are all the States we have statistics on:")

    for idx, state in enumerate(states):
        if idx % 9 == 0:
            print("\n")

        print("{}, ".format(state.name), end='')


def show_distinct_candidates():
    candiates = my_db.Candidate.select(my_db.Candidate.name).distinct()
    print("Here are all the Candidates we have statistics on:")
    for idx, candidate in enumerate(candiates):
        if idx % 9 == 0:
            print("\n")

        print("{}, ".format(candidate.name), end='')


def get_county_stats():
    filters = {1: '1) Filter by year (2020 by default)', 2: '2) Filter by county name (all counties by default)',
               3: '3) Filter by winner party (Democratic Party by default)'}
    year = 2020
    county_name = ''
    winner_party = 'Democratic Party'
    keep_going = 1

    while keep_going == 1 and len(filters) > 0:

        for idx, val in filters.items():
            print(val)

        val = int(input("Please enter a value: "))

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
            winner_party = str(input("Please enter Democratic, Republic or Other: "))
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
            .where((my_db.CountyResult.year == year) & (my_db.Candidate.party == winner_party))
    else:
        results = my_db.CountyResult \
            .select(my_db.County.name.alias('county_name'), my_db.Candidate.name.alias('candidate_name'),
                    my_db.Candidate.party, my_db.CountyResult.fraction_vote_dem,
                    my_db.CountyResult.fraction_vote_rep, my_db.CountyResult.fraction_vote_other) \
            .join(my_db.County) \
            .join(my_db.Candidate, on=(my_db.Candidate.id == my_db.CountyResult.winner)) \
            .where((my_db.CountyResult.year == year) & (my_db.County.name == county_name))

    for res in results.dicts():
        print(res)


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

        val = int(input("Please enter a value: "))

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
            winner_party = str(input("Please enter Democratic, Republic or Other: "))
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
            .where((my_db.CountyResult.year == year) & (my_db.Candidate.party == winner_party))
    else:
        results = my_db.CountyResult \
            .select(my_db.County.name.alias('county_name'), my_db.Candidate.name.alias('candidate_name'),
                    my_db.Candidate.party, my_db.CountyResult.fraction_vote_dem,
                    my_db.CountyResult.fraction_vote_rep, my_db.CountyResult.fraction_vote_other, my_db.State.name) \
            .join(my_db.County) \
            .join(my_db.State, on=(my_db.State.id == my_db.County.state_ID)) \
            .join(my_db.Candidate, on=(my_db.Candidate.id == my_db.CountyResult.winner)) \
            .where((my_db.CountyResult.year == year) & (my_db.Candidate.party == winner_party) & (my_db.State.name == state))

    for res in results.dicts():
        print(res)


def get_county_covid_stats():
    filters = {1: '1) Filter by county name', 2: '2) Select all counties'}
    for idx, val in filters.items():
        print(val)

    county_name = ''
    val = int(input("Please enter a value: "))

    if val == 1:
        county_name = str(input("Enter a county name to filter by : "))

    if county_name == '':
        results = my_db.CountyCovid.select(my_db.CountyCovid.num_cases, my_db.CountyCovid.num_deaths, my_db.County.name)\
            .join(my_db.County)
    else:
        results = my_db.CountyCovid.select(my_db.CountyCovid.num_cases, my_db.CountyCovid.num_deaths, my_db.County.name)\
            .join(my_db.County)\
            .where(my_db.County.name == county_name)

    for res in results.dicts():
        print(res)


def get_state_covid_stats():
    filters = {1: '1) Filter by state name (all states by default)', 2: '2) Select all states'}
    for idx, val in filters.items():
        print(val)

    state_name = ''
    val = int(input("Please enter a value: "))

    if val == 1:
        state_name = str(input("Enter a county name to filter by or simple press 0 to select all counties: "))

    if state_name == '':
        results = my_db.CountyCovid.select(fn.Sum(my_db.CountyCovid.num_cases), fn.Sum(my_db.CountyCovid.num_deaths),
                                           my_db.State.name) \
            .join(my_db.County) \
            .join(my_db.State, on=(my_db.State.id == my_db.County.state_ID)).group_by(my_db.State.id)
    else:
        results = my_db.CountyCovid.select(fn.Sum(my_db.CountyCovid.num_cases), fn.Sum(my_db.CountyCovid.num_deaths),
                                           my_db.State.name) \
            .join(my_db.County) \
            .join(my_db.State, on=(my_db.State.id == my_db.County.state_ID)).group_by(my_db.State.id)\
            .where(my_db.State.name == state_name)

    for res in results.dicts():
        print(res)


def get_county_stats_with_demographics():
    filters = {1: '1) Filter by unemployment rate', 2: '2) Filter by percent poverty',
               3: '3) Filter by median income', 4: '4) Filter by percent white',
               5: '5) Filter by percent black', 6: '6) Filter by percent hispanic',
               7: '7) Filter by percent native', 8: '8) Filter by percent asian',
               9: '9) Filter by county name '}

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

        val = int(input("Please enter a value: "))

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
        else:
            print("ENDED!")
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

    for res in results.dicts():
        print(res)


def show_main_menu_options():
    print("Enter a number to select the option!")
    print("1) Get county stats from year 2016 or 2020")
    print("2) Get state stats from year 2016 or 2020")
    print("3) Get number of deaths and cases covid stats for counties")
    print("4) Get number of deaths and cases covid stats for states")
    print("5) Get election results from counties with county demographics for year 2020")
    print("9) Exit the program")


if __name__ == '__main__':
    init_db()
    while True:
        show_main_menu_options()
        input_val = int(input("Please enter a value: "))
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
        elif input_val == 9:
            break
