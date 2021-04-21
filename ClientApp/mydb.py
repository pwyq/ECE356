from peewee import *

database = MySQLDatabase('project_26', **{'charset': 'utf8', 'sql_mode': 'PIPES_AS_CONCAT', 'use_unicode': True,
                                          'host': 'marmoset04.shoshin.uwaterloo.ca', 'user': 'user',
                                          'password': 'password'})


class UnknownField(object):
    def __init__(self, *_, **__): pass


class BaseModel(Model):
    class Meta:
        database = database


class Candidate(BaseModel):
    id = AutoField(column_name='ID')
    abbreviation = CharField(constraints=[SQL("DEFAULT 'NON'")])
    electoral_college_votes = IntegerField(null=True)
    name = CharField()
    party = CharField(constraints=[SQL("DEFAULT 'UNKNOWN'")])
    year = IntegerField()

    class Meta:
        table_name = 'Candidate'


class State(BaseModel):
    id = AutoField(column_name='ID')
    abbreviation = CharField(null=True)
    name = CharField(unique=True)

    class Meta:
        table_name = 'State'


class County(BaseModel):
    id = AutoField(column_name='ID')
    name = CharField()
    state_ID = IntegerField()

    class Meta:
        table_name = 'County'


class CountyCovid(BaseModel):
    county = ForeignKeyField(column_name='county_ID', field='id', model=County, primary_key=True)
    num_cases = IntegerField()
    num_deaths = IntegerField()

    class Meta:
        table_name = 'CountyCovid'


class CountyDemographic(BaseModel):
    county = ForeignKeyField(column_name='county_ID', field='id', model=County, primary_key=True)
    median_income = IntegerField(null=True)
    num_employed = IntegerField(null=True)
    num_men = IntegerField(null=True)
    num_voting_age_citizen = IntegerField(null=True)
    num_women = IntegerField(null=True)
    percent_child_poverty = DecimalField(null=True)
    percent_poverty = DecimalField(null=True)
    percent_asian = DecimalField(null=True)
    percent_black = DecimalField(null=True)
    percent_construction = DecimalField(null=True)
    percent_hispanic = DecimalField(null=True)
    percent_native = DecimalField(null=True)
    percent_office = DecimalField(null=True)
    percent_pacific = DecimalField(null=True)
    percent_production = DecimalField(null=True)
    percent_professional = DecimalField(null=True)
    percent_service = DecimalField(null=True)
    percent_white = DecimalField(null=True)
    total_pop = IntegerField()
    unemployment_rate = DecimalField(null=True)

    class Meta:
        table_name = 'CountyDemographic'


class CountyResult(BaseModel):
    county = ForeignKeyField(column_name='county_ID', field='id', model=County)
    fraction_vote_dem = DecimalField(null=True)
    fraction_vote_other = DecimalField(null=True)
    fraction_vote_rep = DecimalField(null=True)
    winner = ForeignKeyField(column_name='winner_ID', field='id', model=Candidate, null=True)
    year = IntegerField()

    class Meta:
        table_name = 'CountyResult'
        indexes = (
            (('county', 'year'), True),
        )
        primary_key = CompositeKey('county', 'year')


class FipsCode(BaseModel):
    fips = AutoField()
    name = CharField()
    state = CharField()

    class Meta:
        table_name = 'FIPSCode'


class Tweet(BaseModel):
    city = CharField(null=True)
    continent = CharField(null=True)
    country = CharField(null=True)
    created_at = DateTimeField()
    hashtag_donald_trump = IntegerField()
    hashtag_joe_biden = IntegerField()
    state = CharField(null=True)
    state_code = CharField(null=True)
    tweet_id = AutoField()

    class Meta:
        table_name = 'Tweet'


class CountyStatistics(BaseModel):
    county = CharField()
    fraction16_donald_trump = DecimalField(column_name='fraction16_Donald_Trump')
    fraction16_hillary_clinton = DecimalField(column_name='fraction16_Hillary_Clinton')
    fraction20_donald_trump = DecimalField(column_name='fraction20_Donald_Trump')
    fraction20_joe_biden = DecimalField(column_name='fraction20_Joe_Biden')
    id = IntegerField()
    income_err = IntegerField()
    income_per_cap = IntegerField()
    income_per_cap_err = IntegerField()
    median_income = IntegerField()
    num_cases = IntegerField()
    num_deaths = IntegerField()
    num_employed = IntegerField()
    num_men = IntegerField()
    num_voting_age_citizen = IntegerField()
    num_women = IntegerField()
    pecent_child_poverty = DecimalField()
    pecent_poverty = DecimalField()
    percent_asian = DecimalField()
    percent_black = DecimalField()
    percent_construction = DecimalField()
    percent_hispanic = DecimalField()
    percent_native = DecimalField()
    percent_office = DecimalField()
    percent_pacific = DecimalField()
    percent_production = DecimalField()
    percent_professional = DecimalField()
    percent_service = DecimalField()
    percent_white = DecimalField()
    state = CharField()
    total_pop = IntegerField()
    total_votes16 = IntegerField()
    total_votes20 = IntegerField()
    unemployment_rate = DecimalField()
    votes16_donald_trump = IntegerField(column_name='votes16_Donald_Trump')
    votes16_hillary_clinton = IntegerField(column_name='votes16_Hillary_Clinton')
    votes20_donald_trump = IntegerField(column_name='votes20_Donald_Trump')
    votes20_joe_biden = IntegerField(column_name='votes20_Joe_Biden')

    class Meta:
        table_name = '_CountyStatistics'
        primary_key = False


class HashtagDonaldTrump(BaseModel):
    city = CharField(null=True)
    collected_at = DateTimeField()
    continent = CharField(null=True)
    country = CharField(null=True)
    created_at = DateTimeField()
    latitude = DecimalField(null=True)
    longitude = DecimalField(null=True)
    state = CharField(null=True)
    state_code = CharField(null=True)
    tweet_id = CharField(null=True)
    user_id = CharField(null=True)

    class Meta:
        table_name = '_HashtagDonaldTrump'
        primary_key = False


class HashtagJoeBiden(BaseModel):
    city = CharField(null=True)
    collected_at = DateTimeField()
    continent = CharField(null=True)
    country = CharField(null=True)
    created_at = DateTimeField()
    latitude = DecimalField(null=True)
    longitude = DecimalField(null=True)
    state = CharField(null=True)
    state_code = CharField(null=True)
    tweet_id = CharField(null=True)
    user_id = CharField(null=True)

    class Meta:
        table_name = '_HashtagJoeBiden'
        primary_key = False


class PresidentCounty(BaseModel):
    county = CharField()
    num_current_votes = IntegerField()
    num_total_votes = IntegerField()
    percent = IntegerField()
    state = CharField()

    class Meta:
        table_name = '_PresidentCounty'
        primary_key = False


class PresidentCountyCandidate(BaseModel):
    candidate = CharField()
    county = CharField()
    num_total_votes = IntegerField()
    party = CharField()
    state = CharField()
    won = IntegerField()

    class Meta:
        table_name = '_PresidentCountyCandidate'
        primary_key = False


class PresidentState(BaseModel):
    num_total_votes = IntegerField()
    state = CharField()

    class Meta:
        table_name = '_PresidentState'
        primary_key = False


class Annotations(BaseModel):
    user_id = CharField()
    state = CharField()
    county = CharField()
    annotation = TextField()

    class Meta:
        table_name = 'annotations'
        primary_key = False

