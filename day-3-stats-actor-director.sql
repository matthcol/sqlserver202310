select * from person where name in (
	'Clint Eastwood'
	,'Steve McQueen'
	,'Quentin Tarantino'
	,'Ryan Gosling'
	,'James Dean'
	,'Marilyn Monroe'
	,'Marion Cotillard'
	,'John Wayne'
);

select 
	actor_id
	, count(*) as movie_played_count
from play
group by actor_id
order by movie_played_count desc;


select 
	director_id
	, count(*) as movie_directed_count
from movie
group by director_id
order by movie_directed_count desc;

--draft

select 
	p.id
	, p.name
	, actor_stat.movie_played_count
	, director_stat.movie_directed_count
from 
	person p
	join (
		select 
			actor_id
			, count(*) as movie_played_count
		from play
		group by actor_id
	) actor_stat on p.id = actor_stat.actor_id
	join (
		select 
			director_id
			, count(*) as movie_directed_count
		from movie
		group by director_id
	) director_stat on p.id = director_stat.director_id
where name in (
	'Clint Eastwood'
	,'Steve McQueen'
	,'Quentin Tarantino'
	,'Ryan Gosling'
	,'James Dean'
	,'Marilyn Monroe'
	,'Marion Cotillard'
	,'John Wayne'
)
order by (actor_stat.movie_played_count + director_stat.movie_directed_count) desc;

with actor_stat as (
	select 
			actor_id
			, count(*) as movie_played_count
		from play
		group by actor_id
), director_stat as (
		select 
			director_id
			, count(*) as movie_directed_count
		from movie
		group by director_id
)
select 
	p.id
	, p.name
	, actor_stat.movie_played_count
	, director_stat.movie_directed_count
from 
	person p
	join actor_stat on p.id = actor_stat.actor_id
	join director_stat on p.id = director_stat.director_id
where name in (
	'Clint Eastwood'
	,'Steve McQueen'
	,'Quentin Tarantino'
	,'Ryan Gosling'
	,'James Dean'
	,'Marilyn Monroe'
	,'Marion Cotillard'
	,'John Wayne'
)
order by (movie_played_count + movie_directed_count) desc;

with person_of_interest as (
	select *
	from person p
	where name in (
		'Clint Eastwood'
		,'Steve McQueen'
		,'Quentin Tarantino'
		,'Ryan Gosling'
		,'James Dean'
		,'Marilyn Monroe'
		,'Marion Cotillard'
		,'John Wayne'
	)
), actor_stat as (
	select 
			actor_id
			, count(*) as movie_played_count
		from play
		where actor_id in (select id from person_of_interest)
		group by actor_id
), director_stat as (
		select 
			director_id
			, count(*) as movie_directed_count
		from movie
		where director_id in (select id from person_of_interest)
		group by director_id
)
select 
	p.id
	, p.name
	, actor_stat.movie_played_count
	, director_stat.movie_directed_count
from 
	person_of_interest p
	join actor_stat on p.id = actor_stat.actor_id
	join director_stat on p.id = director_stat.director_id
order by (movie_played_count + movie_directed_count) desc;





















