-- acteurs ayant tourné avec TOUS les réalisateurs suivants:
with famous_director as (
	select * from person 
	where name in (
		'Clint Eastwood',
		'Quentin Tarantino',
		'Steven Spielberg',
		'Martin Scorsese'
	)
)
select
	actor.id, 
	actor.name,
	count(famous_director.id) as collaboration_count,
	count(distinct famous_director.id) as distinct_collaboration_count
from 
	person actor
	join play pl on pl.actor_id = actor.id
	join movie m on pl.movie_id = m.id
	join famous_director on m.director_id = famous_director.id
group by actor.id, actor.name
having count(distinct famous_director.id) = (select count(*) from famous_director)
-- order by distinct_collaboration_count desc, collaboration_count desc
;
;