with person_of_interest as (
	select id, name
	from person
	where name = 'Steve McQueen'
)
select
	p.id as person_id, 
	p.name, 
	m.id as movie_id, 
	m.year, 
	m.title as movie_title,
	NULL as role,
	'director' as credit
from 
	movie m 
	join person_of_interest p on m.director_id = p.id
UNION ALL -- garde les doublons mais y en a pas 
select
	p.id as person_id, 
	p.name, 
	m.id as movie_id, 
	m.year, 
	m.title as movie_title,
	pl.role,
	'actor' as credit
from 
	movie m 
	join play pl on pl.movie_id = m.id 
	join person_of_interest p on pl.actor_id = p.id
-- clause order by commune à l'union des 2 requetes
order by person_id, m.year desc, m.title;