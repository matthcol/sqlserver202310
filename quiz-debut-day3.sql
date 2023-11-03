-- Filmographie r�alisateur Clint Eastwood
with person_of_interest as 
	select id, name
	from person
	where name = 'Clint Eastwood'

select
	p.id as person_id, 
	p.name as director_name, 
	m.id as movie_id, 
	m.year, 
	m.title as movie_title
from 
	movie m 
	person_of_interest p
order by m.year desc, m.title;

-- Filmographie acteur Clint Eastwood
with person_of_interest as 
	select id, name
	from person
	where name = 'Clint Eastwood'

select
	p.id as person_id, 
	p.name as director_name, 
	m.id as movie_id, 
	m.year, 
	m.title as movie_title,
	pl.role
from 
	movie m 
	play pl
	person_of_interest p
order by m.year desc, m.title;

-- Qui a jou� James Bond ? donner la liste des films de chacun
-- Combien de film chaque acteur a-t-il fait ? ann�e du 1er, ann�e du dernier

