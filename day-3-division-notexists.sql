with famous_director as (
	select * from person 
	where name in (
		'Clint Eastwood',
		'Quentin Tarantino',
		'Steven Spielberg',
		'Martin Scorsese'
	)
)
select *
from person actor
where not exists (
	select * 
	from famous_director 
	where not exists (
		select * 
		from
			movie m join 
			play pl on m.id = pl.movie_id
		where 
			pl.actor_id = actor.id
			and m.director_id = famous_director.id
	)
);

