select 
	p.*
	, pl.role
	, m.year
	, m.title
from 
	person p 
	join play pl on p.id = pl.actor_id 
	join movie m on m.id = pl.movie_id 
where  
	role in  ('Q', '''Q''')
order by m.year;