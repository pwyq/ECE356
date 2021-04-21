CREATE TABLE _PresidentCounty (
	state VARCHAR(100) NOT NULL,
    county VARCHAR(100) NOT NULL,
    num_current_votes INT NOT NULL,
    num_total_votes INT NOT NULL,
    percent INT NOT NULL
    );

load data infile '/var/lib/mysql-files/05-2020-Election/president_county.csv' ignore into table _PresidentCounty 
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 lines
     (state, county, num_current_votes, num_total_votes, percent);
     
CREATE TABLE _PresidentCountyCandidate (
	state VARCHAR(100) NOT NULL,
    county VARCHAR(100) NOT NULL,
    candidate VARCHAR(100) NOT NULL,
    party CHAR(3) NOT NULL,
    num_total_votes INT NOT NULL,
    won TINYINT(1) NOT NULL
    );
    
load data infile '/var/lib/mysql-files/05-2020-Election/president_county_candidate.csv' ignore into table _PresidentCountyCandidate
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 lines
     (
     state, 
     county, 
     candidate, 
     party,
     num_total_votes, 
     @won
     )
     set won = IF(@won='False',0,1);
     
-- Remove all the "County" suffixes from the names in County since these do not align with the other CSVs
UPDATE _PresidentCountyCandidate SET county=RTRIM(REVERSE(SUBSTRING(REVERSE(county),LOCATE(" ",REVERSE(county))))) WHERE county LIKE '% County';
     
CREATE TABLE _PresidentState (
	state VARCHAR(100) NOT NULL,
    num_total_votes INT NOT NULL
);
load data infile '/var/lib/mysql-files/05-2020-Election/president_state.csv' ignore into table _PresidentState
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 lines
     (
     state, 
     num_total_votes
);

CREATE TABLE _CountyStatistics (
	id INT NOT NULL,
	county varchar(100) NOT NULL,
    state varchar(100) NOT NULL,
	fraction16_Donald_Trump DECIMAL(4,3) NOT NULL,
	fraction16_Hillary_Clinton DECIMAL(4,3) NOT NULL,
	total_votes16 INT NOT NULL,
	votes16_Donald_Trump INT NOT NULL,
	votes16_Hillary_Clinton INT NOT NULL,
	fraction20_Donald_Trump DECIMAL(4,3) NOT NULL,
	fraction20_Joe_Biden DECIMAL(4,3) NOT NULL,
	total_votes20 INT NOT NULL,
	votes20_Donald_Trump INT NOT NULL,
	votes20_Joe_Biden INT NOT NULL,
	num_cases INT NOT NULL,
	num_deaths INT NOT NULL,
	total_pop INT NOT NULL,
	num_men INT NOT NULL,
	num_women INT NOT NULL,
	percent_hispanic DECIMAL(4,2) NOT NULL,
	percent_white DECIMAL(4,2) NOT NULL,
	percent_black DECIMAL(4,2) NOT NULL,
	percent_native DECIMAL(4,2) NOT NULL,
	percent_asian DECIMAL(4,2) NOT NULL,
	percent_pacific DECIMAL(4,2) NOT NULL,
	num_voting_age_citizen INT NOT NULL,
	median_income INT NOT NULL,
	income_err INT NOT NULL, 
	income_per_cap INT NOT NULL,
	income_per_cap_err INT NOT NULL,
	pecent_poverty DECIMAL(4,2) NOT NULL,
	pecent_child_poverty DECIMAL(4,2) NOT NULL,
	percent_professional DECIMAL(4,2) NOT NULL,
	percent_service DECIMAL(4,2) NOT NULL,
	percent_office DECIMAL(4,2) NOT NULL,
	percent_construction DECIMAL(4,2) NOT NULL,
	percent_production DECIMAL(4,2) NOT NULL,
	num_employed INT NOT NULL,
	unemployment_rate DECIMAL(4,2) NOT NULL
);


load data infile '/var/lib/mysql-files/05-2020-Election/county_statistics.csv' ignore into table _CountyStatistics
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 lines
     (
     id,
     county,
    state,
	fraction16_Donald_Trump,
	fraction16_Hillary_Clinton ,
	total_votes16 ,
	votes16_Donald_Trump ,
	votes16_Hillary_Clinton,
	fraction20_Donald_Trump,
	fraction20_Joe_Biden ,
	total_votes20 ,
	votes20_Donald_Trump ,
	votes20_Joe_Biden ,
	@ignore ,
	@ignore ,
	num_cases ,
	num_deaths ,
	total_pop ,
	num_men ,
	num_women ,
	percent_hispanic ,
	percent_white ,
	percent_black ,
	percent_native ,
	percent_asian ,
	percent_pacific,
	num_voting_age_citizen ,
	median_income ,
	income_err ,
	income_per_cap,
	income_per_cap_err ,
	pecent_poverty ,
	pecent_child_poverty ,
	percent_professional ,
	percent_service ,
	percent_office ,
	percent_construction ,
	percent_production ,
	@ignore ,
	@ignore,
	@ignore,
	@ignore,
	@ignore,
	@ignore,
	@ignore,
	num_employed ,
	@ignore,
	@ignore,
	@ignore,
	@ignore,
	unemployment_rate
);


CREATE TABLE _HashtagDonaldTrump (
	created_at DATETIME NOT NULL,
	tweet_id VARCHAR(100),
	user_id VARCHAR(100),
	latitude DECIMAL(10, 8) NULL,
	longitude DECIMAL(10, 8) NULL,
	city VARCHAR(255),
	country VARCHAR(100),
	continent VARCHAR(100),
	state VARCHAR(100),
	state_code VARCHAR(3), 
	collected_at DATETIME NOT NULL
);

load data infile '/var/lib/mysql-files/05-2020-Election/hashtag_donaldtrump.csv' ignore into table _HashtagDonaldTrump
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 lines
     (
		@created_at,
		tweet_id,
		@ignore,
		@ignore,
        @ignore,
        @ignore,
		user_id,
		@ignore,
        @ignore,
        @ignore,
        @ignore,
        @ignore,
		@ignore,
		latitude,
		longitude,
		city,
		country,
		continent,
		state,
		state_code,
		@collected_at
    )
    SET created_at = STR_TO_DATE(@created_at,'%Y-%m-%d %H:%i:%s'),
    collected_at = STR_TO_DATE(@collected_at,'%Y-%m-%d %H:%i:%s');
    
    CREATE TABLE _HashtagJoeBiden LIKE _HashtagDonaldTrump;
    
    load data infile '/var/lib/mysql-files/05-2020-Election/hashtag_joebiden.csv' ignore into table _HashtagJoeBiden
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 lines
     (
		@created_at,
		tweet_id,
		@ignore,
		@ignore,
        @ignore,
        @ignore,
		user_id,
		@ignore,
        @ignore,
        @ignore,
        @ignore,
        @ignore,
		@ignore,
		latitude,
		longitude,
		city,
		country,
		continent,
		state,
		state_code,
		@collected_at
    )
    SET created_at = STR_TO_DATE(@created_at,'%Y-%m-%d %H:%i:%s'),
    collected_at = STR_TO_DATE(@collected_at,'%Y-%m-%d %H:%i:%s');
    
    
-- ************************************************************************************
-- States and Counties Lookup Tables **************************************************
-- ************************************************************************************
CREATE TABLE State(
	ID INT NOT NULL, -- FIPS Code
    name VARCHAR(100) NOT NULL UNIQUE,
    abbreviation VARCHAR(2),
    -- Key Constraints
	PRIMARY KEY (ID)
);

INSERT INTO State (name, abbreviation, ID) VALUES
('Alabama','AL',1),
('Alaska','AK',2), 
('Arizona','AZ',4),
('Arkansas','AR',5),
('California','CA',6),
('Colorado','CO',8),
('Connecticut','CT',9),
('Delaware','DE',10),
('District of Columbia','DC',11),
('Florida','FL',12),
('Georgia','GA',13),
('Hawaii','HI',15),
('Idaho','ID',16),
('Illinois','IL',17),
('Indiana','IN',18),
('Iowa','IA',19),
('Kansas','KS',20),
('Kentucky','KY',21),
('Louisiana','LA',22),
('Maine','ME',23),
('Maryland','MD',24),
('Massachusetts','MA',25),
('Michigan','MI',26),
('Minnesota','MN',27),
('Mississippi','MS',28),
('Missouri','MO',29),
('Montana','MT',30),
('Nebraska','NE',31),
('Nevada','NV',32),
('New Hampshire','NH',33),
('New Jersey','NJ',34),
('New Mexico','NM',35),
('New York','NY',36),
('North Carolina','NC',37),
('North Dakota','ND',38),
('Ohio','OH',39),
('Oklahoma','OK',40),
('Oregon','OR',41),
('Pennsylvania','PA',42),
('Rhode Island','RI',44),
('South Carolina','SC',45),
('South Dakota','SD',46),
('Tennessee','TN',47),
('Texas','TX',48),
('Utah','UT',49),
('Vermont','VT',50),
('Virginia','VA',51),
('Washington','WA',53),
('West Virginia','WV',54),
('Wisconsin','WI',55),
('Wyoming','WY',56);

 CREATE TABLE County(
	ID INT NOT NULL, -- FIPS Code
    name VARCHAR(100) NOT NULL,
    state_ID INT NOT NULL,
    -- Key Constraints
	PRIMARY KEY (ID),
    FOREIGN KEY (state_ID) REFERENCES State(ID),
    UNIQUE (name, state_ID)
);

-- We want to make sure the first two digits of County ID match the corresponding State's ID
ALTER TABLE County ADD CONSTRAINT CHECK(
	SUBSTRING(CAST(LPAD(ID, 5, 0) AS CHAR), 1, 2) = CAST(LPAD(state_ID, 2, 0) AS CHAR)
);


-- Now insert all the counties from FIPSCode
INSERT INTO County (ID, name, state_ID) (
	SELECT fips, FIPSCode.name, State.ID FROM FIPSCode 
    INNER JOIN
    State ON State.abbreviation = FIPSCode.state
);

-- ************************************************************************************
-- Candidate **************************************************************************
-- ************************************************************************************
 
CREATE TABLE Candidate(
    ID INT NOT NULL AUTO_INCREMENT,
    year INT NOT NULL, 
    party VARCHAR(255) NOT NULL DEFAULT 'UNKNOWN',
    abbreviation CHAR(3) NOT NULL DEFAULT 'NON',
    electoral_college_votes INT NULL, -- Missing Kaggle data
    name VARCHAR(100) NOT NULL,
    -- Key Constraints
    PRIMARY KEY (ID)
);        
INSERT INTO Candidate (year, abbreviation, party, name) VALUES
	(2020, 'DEM', 'Democratic Party', 'Joe Biden'),
	(2020, 'REP', 'Republican Party', 'Donald Trump'),
	(2020, 'LIB', 'Libertarian Party', 'Jo Jorgensen'),
	(2020, 'GRN', 'Green Party of the United States', 'Howie Hawkins'),
	(2020, 'WRI', 'None', 'Write-ins'),
	(2020, 'PSL', 'Party for Socialism and Liberation', 'Gloria La Riva'),
	(2020, 'IND', 'Independent', 'Brock Pierce'),
	(2020, 'REP', 'Republican Party', 'Rocky De La Fuente'),
	(2020, 'CST', 'Constitution Party', 'Don Blankenship'),
	(2020, 'IND', 'Independent', 'Kanye West'),
	(2020, 'ASP', 'American Solidarity Party', 'Brian Carroll'),
	(2020, 'OTH', 'Genealogy Know Your Family History Party', 'Ricki Sue King'),
	(2020, 'IND', 'Independent', 'Jade Simmons'),
	(2020, 'IND', 'Independent', 'President Boddie'),
	(2020, 'UTY', 'Unity Party of America', 'Bill Hammons'),
	(2020, 'LLC', 'America\'s Party', 'Tom Hoefling'),
	(2020, 'SWP', 'Socialist Workers Party', 'Alyson Kennedy'),
	(2020, 'BAR', 'Bread and Roses', 'Jerome Segal'),
	(2020, 'PRO', 'Prohibition', 'Phil Collins'),
	(2020, 'NON', 'UNKNOWN', 'UNKNOWN'),
	(2020, 'CST', 'Constitution Party', 'Sheila Tittle'),
	(2020, 'PRG', 'Progressive Party', 'Dario Hunter'),
	(2020, 'UNA', 'Unaffiliated', 'Joe McHugh'),
	(2020, 'IND', 'Independent', 'Christopher LaFontaine'),
	(2020, 'BMP', 'UNKNOWN', 'Keith McCormic'),
	(2020, 'GOP', 'Republican Party', 'Brooke Paige'),
	(2020, 'BFP', 'Unity Party', 'Gary Swing'),
	(2020, 'IND', 'Independent', 'Richard Duncan'),
	(2020, 'APV', 'Approval Voting Party', 'Blake Huber'),
	(2020, 'IAP', 'Independent American Party', 'kyle Kopitke'),
	(2020, 'IND', 'Independent', 'Zachary Scalf'),
	(2020, 'GRN', 'Green Party of the United States', 'Jesse Ventura'),
	(2020, 'IND', 'Independent', 'Connie Gammon'),
	(2020, 'LLP', 'Life and Liberty Party', 'John Richard Myers'),
	(2020, 'IND', 'Independent', 'Mark Charles'),
	(2020, 'UNA', 'Unaffiliated', 'Princess Jacob-Fambro'),
	(2020, 'SEP', 'Socialist Equality Party', 'Joseph Kishore'),
	(2020, 'UNA', 'Unaffiliated', 'Jordan Scott'),
	(2016, 'LIB', 'Libertarian Party', 'Gary Johnson'),
	(2016, 'GRN', 'Green Party', 'Jill Stein'),
	(2016, 'NON', 'Better for America Group and others', 'Evan McMullin'),
	(2016, 'CST', 'Constitution Party', 'Darrell Castle'),
	(2016, 'NON', 'Party for Socialism and Liberation', 'Gloria La Riva'),
	(2016, 'NON', 'American Delta and Reform Parties', 'Rocky De La Fuente'),
	(2016, 'IND', 'Independent', 'Richard Duncan'),
	(2016, 'DEM', 'Democratic Party', 'Bernie Sanders'),
	(2016, 'NON', 'Legal Marijuana Now Party', 'Dan Vacek'),
	(2016, 'SWP', 'Socialist Workers Party', 'Alyson Kennedy'),
	(2016, 'NON', 'Veterans Party of America', 'Chris Keniston'),
	(2016, 'ASP', 'American Solidarity Party', 'Mike Maturen'),
	(2016, 'PRO', 'Prohibition Party', 'James Hedges'),
	(2016, 'LLC', 'America\'s Party', 'Tom Hoefling'),
	(2016, 'NON', 'Workers World Party', 'Monica Moorehead'),
	(2016, 'NON', 'American Party (South Carolina)', 'Peter Skewes'),
	(2016, 'IND', 'Independent', 'Laurence Kotlikoff'),
	(2016, 'IAP', 'Independent American Party', 'Rocky Giordani'),
	(2016, 'NON', 'Socialist Party USA', 'Emidio "Mimi" Soltysik'),
	(2016, 'NON', 'Nutrition Party', 'Rod Silva'),
	(2016, 'SEP', 'Socialist Equality Party', 'Jerry White');

-- ************************************************************************************
-- County Result **********************************************************************
-- ************************************************************************************
CREATE TABLE CountyResult (
  county_ID INT NOT NULL,
  year INT NOT NULL,
  winner_ID INT NULL, -- Sometimes the winner is not known in the Kaggle dataset
  fraction_vote_dem decimal(4,3) NULL,
  fraction_vote_rep decimal(4,3) NULL,
  fraction_vote_other decimal(4,3) NULL,
  -- Key constraints
  PRIMARY KEY (county_ID,year),
  FOREIGN KEY (winner_ID) REFERENCES Candidate(ID),
  FOREIGN KEY (county_ID) REFERENCES County(ID)
);

-- Remove all the "County" suffixes from the names in County since these do not align with the Kaggle data.
UPDATE County SET name=RTRIM(REVERSE(SUBSTRING(REVERSE(name),LOCATE(" ",REVERSE(name))))) WHERE name LIKE '% County';

-- Finally, insert the data into County result.
-- First for 2016
INSERT IGNORE INTO CountyResult(county_ID, year, fraction_vote_dem, fraction_vote_rep, fraction_vote_other, winner_ID) (
	SELECT county_ID, 
    2016,
    fraction16_Donald_Trump, 
    fraction16_Hillary_Clinton, 
    (1 - fraction16_Hillary_Clinton - fraction16_Donald_Trump),
    CASE WHEN fraction16_Donald_Trump > fraction16_Hillary_Clinton THEN (SELECT ID FROM Candidate WHERE name='Donald Trump' AND year=2016)
        WHEN fraction16_Hillary_Clinton > fraction16_Donald_Trump THEN (SELECT ID FROM Candidate WHERE name='Hillary Clinton' AND year=2016)
        ELSE NULL
        END
	AS winner_ID
    FROM _CountyStatistics a
    INNER JOIN (
		SELECT County.ID AS county_ID, County.name AS county, State.abbreviation AS abbr
        FROM County INNER JOIN State ON State.ID = County.state_ID
	) b 
	ON a.county = b.county AND a.state = b.abbr		
);

-- Then for 2020. Here we can use the _PresidentCountyCandidate data from Kaggle
INSERT IGNORE INTO CountyResult(county_ID, year, fraction_vote_dem, fraction_vote_rep, fraction_vote_other, winner_ID) (
	SELECT county_ID, 2020, 
    fraction20_Donald_Trump, 
    fraction20_Joe_Biden, 
    (1 - fraction20_Donald_Trump - fraction20_Joe_Biden),
    winner_ID
    FROM _CountyStatistics a
    INNER JOIN (
		SELECT County.ID AS county_ID, County.name AS county, State.abbreviation AS abbr, State.name AS state
        FROM County INNER JOIN State ON State.ID = County.state_ID
	) b 
	ON a.county = b.county AND a.state = b.abbr
	INNER JOIN (
		SELECT state, county, ID AS winner_ID FROM 
        _PresidentCountyCandidate a
		INNER JOIN Candidate b 
        ON a.candidate = b.name AND a.party = b.abbreviation 
        WHERE won=1
    ) AS Winners
    ON b.county = Winners.county AND b.state = Winners.state
);

-- Issue with _PresidentCountyCandidate is that all the Alaska counties are entered as "ED 10", "ED 11", etc. Which are not real county names...

-- ************************************************************************************
-- State Result ***********************************************************************
-- ************************************************************************************
-- State Result is a view since it must update when CountyResult updates
-- this view contains information on which candidate won in a specific state in a specific year
CREATE VIEW StateResult as
	(
		WITH countiesWonByState(state_ID, year, winner_ID, counties_won) AS (
				SELECT c.ID AS state_ID,
				year,
				winner_ID, 
				COUNT(winner_ID) AS counties_won
				FROM CountyResult a 
				INNER JOIN County b ON a.county_ID = b.ID 
				INNER JOIN State c ON c.ID = b.state_ID
				GROUP BY c.ID, year, winner_ID
		)
		SELECT countiesWonByState.state_ID, countiesWonByState.year, winner_ID FROM (
			SELECT state_ID, year, MAX(counties_won) AS max_counties FROM countiesWonByState
			GROUP BY state_ID, year
		) AS winnersByState
		INNER JOIN
		countiesWonByState 
		ON countiesWonByState.year=winnersByState.year 
		AND countiesWonByState.state_ID = winnersByState.state_ID
		AND countiesWonByState.counties_won = winnersByState.max_counties
	);
    
-- ************************************************************************************
-- COVID Information by County ********************************************************
-- ************************************************************************************
CREATE TABLE CountyCovid (
	county_ID INT NOT NULL,
	num_cases INT NOT NULL,
	num_deaths INT NOT NULL,
    -- Key Constraints
    PRIMARY KEY(county_ID),
    FOREIGN KEY(county_ID) REFERENCES County(ID)
);

-- the _CountyStatistics table from Kaggle has all the data we need for this
INSERT IGNORE INTO CountyCovid (county_ID, num_cases, num_deaths) (
	SELECT County.ID AS county_ID, num_cases, num_deaths 
    FROM _CountyStatistics AS a
    INNER JOIN State ON State.abbreviation = a.state
    INNER JOIN County ON County.name = a.county AND County.state_ID = State.ID
);

-- ************************************************************************************
-- COVID Information by State *********************************************************
-- ************************************************************************************
-- Like the StateResults, this must be a view as well since it must update whenever CountyCovid updates
-- state_ID, num_cases, num_deaths, total_pop
CREATE VIEW StateCovid as
	(
		SELECT c.ID as state_ID, 
        SUM(num_cases) AS num_cases,
        SUM(num_deaths) AS num_deaths
        FROM 
        CountyCovid AS a
        INNER JOIN County AS b ON a.county_ID = b.ID
        INNER JOIN State AS c on b.state_ID = c.ID
        GROUP BY c.ID
	);
    
-- ************************************************************************************
-- County Demographic Information *****************************************************
-- ************************************************************************************

-- This is from Kaggle, and is specific to the year 2020
CREATE TABLE CountyDemographic (
	county_ID INT NOT NULL,
	total_pop INT NOT NULL,
	num_men INT,
	num_women INT,
	percent_hispanic DECIMAL(4,2) NULL,
	percent_white DECIMAL(4,2),
	percent_black DECIMAL(4,2),
	percent_native DECIMAL(4,2),
	percent_asian DECIMAL(4,2) ,
	percent_pacific DECIMAL(4,2),
	num_voting_age_citizen INT ,
	median_income INT ,
	pecent_poverty DECIMAL(4,2),
	pecent_child_poverty DECIMAL(4,2),
	percent_professional DECIMAL(4,2) ,
	percent_service DECIMAL(4,2) ,
	percent_office DECIMAL(4,2) ,
	percent_construction DECIMAL(4,2) ,
	percent_production DECIMAL(4,2) ,
	num_employed INT ,
	unemployment_rate DECIMAL(4,2) ,
    -- Key constraints
    PRIMARY KEY (county_ID),
    FOREIGN KEY (county_ID) REFERENCES County(ID)
);
-- Insert Kaggle data
INSERT IGNORE INTO CountyDemographic (
	SELECT County.ID, 
    total_pop, num_men,	num_women,
	percent_hispanic, percent_white,
	percent_black, percent_native,
	percent_asian, percent_pacific,
	num_voting_age_citizen,	median_income,
	pecent_poverty,	pecent_child_poverty,
	percent_professional, percent_service,
	percent_office,	percent_construction,
	percent_production, num_employed,
	unemployment_rate 
    FROM _CountyStatistics AS a
    INNER JOIN State ON State.abbreviation = a.state
    INNER JOIN County ON County.name = a.county AND County.state_ID = State.ID
);
alter table CountyDemographic change column pecent_poverty percent_poverty decimal(4,2);
alter table CountyDemographic change column pecent_child_poverty percent_child_poverty decimal(4,2);

-- ************************************************************************************
-- Tweets *****************************************************************************
-- ************************************************************************************
CREATE TABLE Tweet (
	tweet_id INT NOT NULL AUTO_INCREMENT, -- We want our table to have integer IDs for better join performance if needed
	created_at DATETIME NOT NULL,
	city VARCHAR(255),
	country VARCHAR(100),
	continent VARCHAR(100),
	state VARCHAR(100),
	state_code VARCHAR(3),
    hashtag_donald_trump TINYINT(1) NOT NULL,
    hashtag_joe_biden TINYINT(1) NOT NULL,
    -- Key constraints
    PRIMARY KEY (tweet_id)
);

-- Do a full outer join on the two tables from Kaggle "_HashtagDonaldTrump" and "_HashtagJoeBiden"
INSERT INTO Tweet (created_at, city, country, continent, state, state_code, hashtag_donald_trump, hashtag_joe_biden) (
	SELECT 
    CASE
		WHEN created_at_a IS NULL THEN created_at_b
		ELSE created_at_a
	END AS created_at,
    CASE
		WHEN city_a IS NULL THEN city_b
		ELSE city_a
	END AS city,
    CASE
		WHEN country_a IS NULL THEN country_b
		ELSE country_a
	END AS country, 
    CASE
		WHEN continent_a IS NULL THEN continent_b
		ELSE continent_a
	END AS continent, 
    CASE
		WHEN state_a IS NULL THEN state_b
		ELSE state_a
	END AS state, 
    CASE
		WHEN state_code_a IS NULL THEN state_code_b
		ELSE state_code_a
	END AS state_code,
    CASE
		WHEN tweet_id_a IS NULL THEN 0
		ELSE 1
	END
    AS hashtag_donald_trump,
    CASE
		WHEN tweet_id_b IS NULL THEN 0
		ELSE 1
	END
    AS hashtag_joe_biden
    FROM (
		SELECT 
		_HashtagDonaldTrump.tweet_id AS tweet_id_a,
		_HashtagDonaldTrump.created_at AS created_at_a,
		_HashtagDonaldTrump.city AS city_a,
		_HashtagDonaldTrump.country AS country_a,
		_HashtagDonaldTrump.continent AS continent_a,
		_HashtagDonaldTrump.state AS state_a,
		_HashtagDonaldTrump.state_code AS state_code_a,
		_HashtagJoeBiden.tweet_id AS tweet_id_b,
		_HashtagJoeBiden.created_at AS created_at_b,
		_HashtagJoeBiden.city AS city_b,
		_HashtagJoeBiden.country AS country_b,
		_HashtagJoeBiden.continent AS continent_b,
		_HashtagJoeBiden.state AS state_b,
		_HashtagJoeBiden.state_code AS state_code_b
		FROM
		_HashtagDonaldTrump
		LEFT JOIN _HashtagJoeBiden 
		ON _HashtagDonaldTrump.tweet_id = _HashtagJoeBiden.tweet_id
		UNION 
		SELECT 
		_HashtagDonaldTrump.tweet_id AS tweet_id_a,
		_HashtagDonaldTrump.created_at AS created_at_a,
		_HashtagDonaldTrump.city AS city_a,
		_HashtagDonaldTrump.country AS country_a,
		_HashtagDonaldTrump.continent AS continent_a,
		_HashtagDonaldTrump.state AS state_a,
		_HashtagDonaldTrump.state_code AS state_code_a,
		_HashtagJoeBiden.tweet_id AS tweet_id_b,
		_HashtagJoeBiden.created_at AS created_at_b,
		_HashtagJoeBiden.city AS city_b,
		_HashtagJoeBiden.country AS country_b,
		_HashtagJoeBiden.continent AS continent_b,
		_HashtagJoeBiden.state AS state_b,
		_HashtagJoeBiden.state_code AS state_code_b
		FROM _HashtagDonaldTrump
		RIGHT JOIN _HashtagJoeBiden ON _HashtagDonaldTrump.tweet_id = _HashtagJoeBiden.tweet_id
    ) joined
);


-- Create Annotations table
CREATE TABLE annotations (user_id VARCHAR(255), county VARCHAR(100),
       state VARCHAR(100), annotation TEXT);


-- Update missing information (set to NULL so that it's clear, and so we can mine on this data properly)
UPDATE Tweet SET city=NULL WHERE city='';
UPDATE Tweet SET country=NULL WHERE country='';
UPDATE Tweet SET continent=NULL WHERE continent='';
UPDATE Tweet SET state=NULL WHERE state='';
UPDATE Tweet SET state_code=NULL WHERE state_code='';
