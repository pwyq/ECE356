-- Select database
-- use project_26;

/*
select 'Tweets for Trump from Top 10 Non-US Countries';
with TweetDT_Distinct as (
		select distinct * from Tweet
	),
	ValidTweetDT as (
		select * from TweetDT_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country is not NULL
	),
	ValidTweetDT_NonUSA as (
		select * from ValidTweetDT
			where (country<>'United States of America' and country<>'United States')
			and hashtag_donald_trump=1
			and hashtag_joe_biden=0
	)
select
	country,
	count(country)*100/(select count(*) from ValidTweetDT_NonUSA) as Portion,
	count(country) as 'TweetsByCountry',
	(select count(*) from ValidTweetDT_NonUSA) as 'TotalTweets'
from ValidTweetDT_NonUSA
group by country
order by Portion desc
limit 10
;

select 'Tweets for Biden from Top 10 Non-US Countries';
with Tweet_Distinct as (
		select distinct * from Tweet
	),
	ValidTweet as (
		select * from Tweet_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country is not NULL
	),
	ValidTweetBiden_NonUSA as (
		select * from ValidTweet
			where (country<>'United States of America' and country<>'United States')
			and hashtag_joe_biden=1
			and hashtag_donald_trump=0
	)
select
	country,
	count(country)*100/(select count(*) from ValidTweetBiden_NonUSA) as Portion,
	count(country) as 'TweetsByCountry',
	(select count(*) from ValidTweetBiden_NonUSA) as 'TotalTweets'
from ValidTweetBiden_NonUSA
group by country
order by Portion desc
limit 10
;

select 'Tweets for Trump&Biden from Top 10 Non-US Countries';
with Tweet_Distinct as (
		select distinct * from Tweet
	),
	ValidTweet as (
		select * from Tweet_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country is not NULL
	),
	ValidTweet_NonUSA as (
		select * from ValidTweet
			where (country<>'United States of America' and country<>'United States')
			and hashtag_joe_biden=1
			and hashtag_donald_trump=1
	)
select
	country,
	count(country)*100/(select count(*) from ValidTweet_NonUSA) as Portion,
	count(country) as 'TweetsByCountry',
	(select count(*) from ValidTweet_NonUSA) as 'TotalTweets'
from ValidTweet_NonUSA
group by country
order by Portion desc
limit 10
;

-- 1. Removed tweets that mentioned both president candidates
-- 2. Assumed tweets that mentioned a single candidate are inclined to that candidate

-- We observed that the prediction is bad (50% accuracy) when based solely on region tweet count (w/o sentiment analysis)
*/
with Tweet_Distinct as (
		select distinct * from Tweet
	),
	ValidTweet_USA as (
		select * from Tweet_Distinct
			where
				country='United States of America'
				and state is not NULL
				and state not in ('Guam', 'Puerto Rico')
				and ((hashtag_joe_biden=1 and hashtag_donald_trump=0)
					or (hashtag_joe_biden=0 and hashtag_donald_trump=1))
	),
	TweetBiden as (
		select
			state,
			count(hashtag_joe_biden)*100/(select count(*) from ValidTweet_USA) as 'PercentBiden'
		from ValidTweet_USA
		where hashtag_joe_biden=1
		group by state
	),
	TweetTrump as (
		select
			state,
			count(hashtag_donald_trump)*100/(select count(*) from ValidTweet_USA) as 'PercentTrump'
		from ValidTweet_USA
		where hashtag_donald_trump=1
		group by state
	),
	TweetTotal as (
		select TweetBiden.state, TweetBiden.PercentBiden, TweetTrump.PercentTrump
		from TweetBiden
		inner join TweetTrump
		on TweetBiden.state = TweetTrump.state
	),
	TweetPercent as (
		select
			min(PercentBiden)-0.0001 as MinBiden, max(PercentBiden)+0.0001 as MaxBiden,
			min(PercentTrump)-0.0001 as MinTrump, max(PercentTrump)+0.0001 as MaxTrump,
			sum(PercentBiden) as SumBiden, sum(PercentTrump) as sumTrump
		from TweetTotal
	),
	NormalizedTweetTotal1 as (
		select
			TweetTotal.state,
			(PercentBiden-TweetPercent.MinBiden)/(TweetPercent.MaxBiden-TweetPercent.MinBiden) as 'NormBiden',
			(PercentTrump-TweetPercent.MinTrump)/(TweetPercent.MaxTrump-TweetPercent.MinTrump) as 'NormTrump'
		from TweetTotal, TweetPercent
	),
	NormalizedTweetTotal2 as (
		select
			TweetTotal.state,
			PercentBiden/TweetPercent.SumBiden as 'NormBiden',
			PercentTrump/TweetPercent.SumTrump as 'NormTrump'
		from TweetTotal, TweetPercent
	),
	Benchmark as (
		select * from ASR
	)
select
	state,
	c.name as 'ActualWinner',
	if(NormBiden > NormTrump, 'Joe Biden', 'Donald Trump') as 'Winner'
--	NormBiden, NormTrump
from NormalizedTweetTotal2 a
inner join Benchmark b on b.name=a.state
inner join Candidate c on c.ID = b.candidate_ID
;
