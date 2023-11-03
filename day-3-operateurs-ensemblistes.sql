with actor_and_director(person_id) as (
	select director_id from movie
	INTERSECT
	select actor_id from play
)
select *
from person
where id in (select person_id from actor_and_director)
order by name;

with actor_and_director(person_id) as (
	select director_id from movie
	INTERSECT
	select actor_id from play
)
select p.*
from person p join  actor_and_director ad on p.id = ad.person_id 
order by name;

with director_only(person_id) as (
	select director_id from movie
	EXCEPT
	select actor_id from play
)
select p.*
from person p join  director_only d on p.id = d.person_id 
order by name;

with actor_only(person_id) as (
	select actor_id from play
	EXCEPT
	select director_id from movie
)
select p.*
from person p join  actor_only a on p.id = a.person_id 
order by name;


select concat('texte', 123, 'autre texte', 124);