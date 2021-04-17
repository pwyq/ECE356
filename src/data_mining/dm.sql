-- Select database
-- use project_26;

select 'Tweets for Trump from Top 10 Non-US Countries';
with TweetDT_Distinct as (
		select distinct * from _HashtagDonaldTrump
	),
	ValidTweetDT as (
		select * from TweetDT_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country<>''
	),
	ValidTweetDT_NonUSA as (
		select * from ValidTweetDT
			where (country<>'United States of America' and country<>'United States')
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
		select distinct * from _HashtagJoeBiden
	),
	ValidTweet as (
		select * from Tweet_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country<>''
	),
	ValidTweetBiden_NonUSA as (
		select * from ValidTweet
			where (country<>'United States of America' and country<>'United States')
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

-- We notice that when country='United States', there is no 'state' info.
select 'Tweets for Trump By US States';
with Tweet_Distinct as (
		select distinct * from _HashtagDonaldTrump
	),
	ValidTweet as (
		select * from Tweet_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country<>''
	),
	ValidTweetTrump_USA as (
		select * from ValidTweet
			where country='United States of America' and state<>''
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
		select distinct * from _HashtagJoeBiden
	),
	ValidTweet as (
		select * from Tweet_Distinct 
			where created_at<>'0000-00-00 00:00:00' and country<>''
	),
	ValidTweetBiden_USA as (
		select * from ValidTweet
			where country='United States of America' and state<>''
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
