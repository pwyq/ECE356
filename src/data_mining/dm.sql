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
*/

-- 1. Removed tweets that mentioned both president candidates
-- 2. Assumed tweets that mentioned a single candidate are inclined to that candidate
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
			min(PercentBiden) as MinBiden, max(PercentBiden) as MaxBiden,
			min(PercentTrump) as MinTrump, max(PercentTrump) as MaxTrump,
			sum(PercentBiden) as SumBiden, sum(PercentTrump) as sumTrump
		from TweetTotal
	),
--	NormalizedTweetTotal as (
--		select
--			TweetTotal.state,
--			(PercentBiden-TweetPercent.MinBiden)/(TweetPercent.MaxBiden-TweetPercent.MinBiden) as 'NormBiden',
--			(PercentTrump-TweetPercent.MinTrump)/(TweetPercent.MaxTrump-TweetPercent.MinTrump) as 'NormTrump'
--		from TweetTotal, TweetPercent
--	)
	NormalizedTweetTotal as (
		select
			TweetTotal.state,
			PercentBiden/TweetPercent.SumBiden as 'NormBiden',
			PercentTrump/TweetPercent.SumTrump as 'NormTrump'
		from TweetTotal, TweetPercent
	)
select
	state,
	if(NormBiden > NormTrump, 'YES', 'NO') as 'BidenWon',
	NormBiden,
	NormTrump
from NormalizedTweetTotal
;

/*
-- We notice that when country='United States', there is no 'state' info.
select 'Tweets for Trump By US States';
with Tweet_Distinct as (
		select distinct * from Tweet
	),
	ValidTweet as (
		select * from Tweet_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country is not NULL
	),
	ValidTweetTrump_USA as (
		select * from ValidTweet
			where country='United States of America' and state is not NULL
	)
select 
	state,
	count(state)*100/(select count(*) from ValidTweetTrump_USA) as Portion,
	count(state) as 'TweetsByState',
	(select count(*) from ValidTweetTrump_USA) as 'TotalTweets'
from ValidTweetTrump_USA
group by state
order by Portion desc
;

select 'Tweets for Biden By US States';
with Tweet_Distinct as (
		select distinct * from Tweet
	),
	ValidTweet as (
		select * from Tweet_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country is not NULL
	),
	ValidTweetBiden_USA as (
		select * from ValidTweet
			where country='United States of America' and state is not NULL
	)
select 
	state,
	count(state)*100/(select count(*) from ValidTweetBiden_USA) as Portion,
	count(state) as 'TweetsByState',
	(select count(*) from ValidTweetBiden_USA) as 'TotalTweets'
from ValidTweetBiden_USA
group by state
order by Portion desc
;
*/

