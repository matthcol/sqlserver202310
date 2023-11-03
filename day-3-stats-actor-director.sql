-- 3 requetes séparées
select * from person where name in (
	'Clint Eastwood'
	,'Steve McQueen'
	,'Quentin Tarantino'
	,'Ryan Gosling'
	,'James Dean'
	,'Marilyn Monroe'
	,'Marion Cotillard'
	,'John Wayne'
	,'Alfred Hitchcock'
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

-- assemblage des 3 requêtes (SOL 1)

select 
	p.id
	, p.name
	, coalesce(actor_stat.movie_played_count, 0) as movie_played_count
	, coalesce(director_stat.movie_directed_count, 0)  as movie_directed_count
from 
	person p
	left join (
		select 
			actor_id
			, count(*) as movie_played_count
		from play
		group by actor_id
	) actor_stat on p.id = actor_stat.actor_id
	left join (
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
	,'Alfred Hitchcock'
)
order by (movie_played_count + movie_directed_count) desc;

with actor_stat as (
		select 
			pl.actor_id
			, count(*) as movie_played_count
			, min(m.year) as first_year_played
			, max(m.year) as last_year_played
			, string_agg(concat(m.year,' - ', m.title), ' | ') within group (order by m.year) as titles_played
		from play pl join movie m on pl.movie_id = m.id
		group by pl.actor_id
), director_stat as (
		select 
			director_id
			, count(*) as movie_directed_count
			, min(year) as first_year_directed
			, max(year) as last_year_directed
			, string_agg(concat(year,' - ', title), ' | ') within group (order by year) as titles_directed
		from movie
		group by director_id
)
select 
	p.id
	, p.name
	, coalesce(actor_stat.movie_played_count, 0) as movie_played_count
	, actor_stat.first_year_played
	, actor_stat.last_year_played
	, actor_stat.titles_played
	, coalesce(director_stat.movie_directed_count, 0)  as movie_directed_count
	, director_stat.first_year_directed
	, director_stat.last_year_directed
	, director_stat.titles_directed
from 
	person p
	left join actor_stat on p.id = actor_stat.actor_id
	left join director_stat on p.id = director_stat.director_id
where name in (
	'Clint Eastwood'
	,'Steve McQueen'
	,'Quentin Tarantino'
	,'Ryan Gosling'
	,'James Dean'
	,'Marilyn Monroe'
	,'Marion Cotillard'
	,'John Wayne'
	,'Alfred Hitchcock'
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
		,'Alfred Hitchcock'
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
	, coalesce(actor_stat.movie_played_count, 0) as movie_played_count
	, coalesce(director_stat.movie_directed_count, 0)  as movie_directed_count
from 
	person_of_interest p
	left join actor_stat on p.id = actor_stat.actor_id
	left join director_stat on p.id = director_stat.director_id
order by (movie_played_count + movie_directed_count) desc;





















