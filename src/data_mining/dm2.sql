with SD as (
    -- State Demographics
        select
            State.name as state,
            State.ID as ID,
            sum(total_pop) as TotalPop,
--          sum(num_voting_age_citizen) as NumVoters,
            round(avg(median_income),2) as AvgMedianIncome,
            round(sum(num_men)*100/sum(total_pop),2) as PctMen,
            round(sum(num_women)*100/sum(total_pop),2) as PctWomen,
            round(sum(num_employed)*100/sum(total_pop),2) as PctEmployed,
            round(sum(round(total_pop*percent_poverty))/sum(total_pop),2) as PctPoverty,
            round(sum(round(total_pop*percent_child_poverty))/sum(total_pop),2) as PctChildPoverty,
            -- Race
            round(sum(round(total_pop*percent_hispanic))/sum(total_pop),2) as PctHispanic,
            round(sum(round(total_pop*percent_white))/sum(total_pop),2) as PctWhite,
            round(sum(round(total_pop*percent_black))/sum(total_pop),2) as PctBlack,
            round(sum(round(total_pop*percent_native))/sum(total_pop),2) as PctNative,
            round(sum(round(total_pop*percent_asian))/sum(total_pop),2) as PctAsian,
            round(sum(round(total_pop*percent_pacific))/sum(total_pop),2) as PctPacific,
            -- Professions
            round(sum(round(total_pop*percent_service))/sum(total_pop),2) as PctService,
            round(sum(round(total_pop*percent_office))/sum(total_pop),2) as PctOffice,
            round(sum(round(total_pop*percent_construction))/sum(total_pop),2) as PctConstruction,
            round(sum(round(total_pop*percent_production))/sum(total_pop),2) as PctProduction
        from CountyDemographic
        inner join County on CountyDemographic.county_ID = County.ID
        inner join State on County.state_ID = State.ID
        group by State.ID
    ),
    SDCovid as (
        select
            SD.*,
            round(StateCovid.num_cases*100/TotalPop, 2) as PctCovid,
            if(StateCovid.num_cases>0,
                round(StateCovid.num_deaths*100/StateCovid.num_cases, 2),
                0
            ) as PctCovidDeath
        from SD
        inner join StateCovid on StateCovid.state_ID = SD.ID
    ),
    CandidateScores as (
        select
            state,
            -- The weight is based on Edison Research for the National Election Pool
            -- Only a small fraction of indicators are used due to insufficient data
            -- https://www.nytimes.com/interactive/2020/11/03/us/elections/exit-polls-president.html
            PctMen*0.53+PctWomen*0.42+
            PctWhite*0.58+PctBlack*0.12+PctHispanic*0.32+PctAsian*0.34+
            (PctNative+PctPacific)*0.41+
            if(AvgMedianIncome<50000,0.44,0.42)+
            PctEmployed*0.51+(100-PctEmployed)*0.42+
            PctWhite*0.58+(100-PctWhite)*0.26+
            (PctCovid+PctCovidDeath)*0.15
            as 'TrumpScore'
            ,
            PctMen*0.45+PctWomen*0.57+
            PctWhite*0.41+PctBlack*0.87+PctHispanic*0.65+PctAsian*0.61+
            (PctNative+PctPacific)*0.55+
            if(AvgMedianIncome<50000,0.55,0.57)+
            PctEmployed*0.47+(100-PctEmployed)*0.57+
            PctWhite*0.41+(100-PctWhite)*0.71+
            (PctCovid+PctCovidDeath)*0.81
            as 'BidenScore'
        from SDCovid
    ),
    Benchmark as (
        select * from ASR
    )
select
    state,
    c.name as 'ActualWinner',
    if(TrumpScore > BidenScore, 'Donald Trump', 'Joe Biden') as 'Winner',
    TrumpScore, BidenScore
from CandidateScores a
inner join Benchmark b on b.name=a.state
inner join Candidate c on c.ID=b.candidate_ID
;
