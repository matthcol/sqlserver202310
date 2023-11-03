-- Filmographie réalisateur Clint Eastwood
with person_of_interest as (
	select id, name
	from person
	where name = 'Clint Eastwood'
)
select
	p.id as person_id, 
	p.name as director_name, 
	m.id as movie_id, 
	m.year, 
	m.title as movie_title
from 
	movie m 
	join person_of_interest p on m.director_id = p.id
order by m.year desc, m.title;

-- Filmographie acteur Clint Eastwood
with person_of_interest as (
	select id, name
	from person
	where name = 'Clint Eastwood'
)
select
	p.id as person_id, 
	p.name as actor_name, 
	m.id as movie_id, 
	m.year, 
	m.title as movie_title,
	pl.role
from 
	movie m 
	join play pl on pl.movie_id = m.id 
	join person_of_interest p on pl.actor_id = p.id
order by m.year desc, m.title;

-- Qui a joué James Bond ? donner la liste des films de chacun
-- Combien de film chaque acteur a-t-il fait ? année du 1er, année du dernier
select
	a.id as actor_id, a.name as actor_name,
	m.id as movie_id, m.year, m.title,
	pl.role
from 
	movie m
	join play pl on m.id = pl.movie_id
	join person a on a.id = pl.actor_id
where pl.role like 'James Bond' --'%James Bond%'
order by m.year;

select
	a.id as actor_id, 
	a.name as actor_name,
	count(m.id) as movie_count,
	min(m.year) as first_year,
	max(m.year) as last_year
from 
	movie m
	join play pl on m.id = pl.movie_id
	join person a on a.id = pl.actor_id
where pl.role like 'James Bond' -- '%James Bond%'
group by a.id, a.name
order by movie_count desc;

-- MAJ de données: INSERT, UPDATE, DELETE
UPDATE play
SET role = 'James Bond'
WHERE 
	movie_id = 82398
	AND actor_id = 549;

DELETE FROM play
WHERE role = 'James Bond in Gunbarrel Sequence';

-- supprimer le 'film': London 2012 Olympic Opening Ceremony: Isles of Wonder
DELETE FROM movie
where id = 2305700; 
-- The DELETE statement conflicted with the REFERENCE constraint "FK_PLAY_MOVIE". The conflict occurred in database "dbmovie", table "dbo.play", column 'movie_id'.
-- Solution: supprimer les lignes de la table have_genre et play qui référencent ce movie
DELETE FROM play where movie_id = 2305700; -- 301 suppressions
DELETE FROM have_genre where movie_id = 2305700;
DELETE FROM movie where id = 2305700; -- maintenant OK


-- Ajouter le film De James Bond: No Time to Die (2021) avec Daniel Craig (185819) dans le role de James Bond
INSERT INTO movie (title, year) VALUES ('No Time to Die', 2021);
SELECT * FROM movie where title = 'No Time to Die'; -- id du film: 8080248
INSERT INTO PLAY (movie_id, actor_id, role) VALUES (8080248, 185819, 'James Bond');

-- 
select
	a.id as actor_id, a.name as actor_name,
	m.id as movie_id, m.year, m.title,
	pl.role,
	count(m.id) over (partition by a.id) as movie_count,
	rank() over (partition by a.id order by m.year) as rank_actor,
	first_value(m.year) over (partition by a.id order by m.year) as first_year_actor,
	first_value(m.year) over (partition by a.id order by m.year desc) as last_year_actor, -- bug last_value ????
	first_value(m.year) over (order by m.year) as first_year,
	first_value(m.year) over (order by m.year desc) as last_year 
from 
	movie m
	join play pl on m.id = pl.movie_id
	join person a on a.id = pl.actor_id
where pl.role like 'James Bond' --'%James Bond%'
order by m.year, actor_name;











-- filmographie Clint Eastwood en tant que réalisateur et acteur
with person_of_interest as (
	select id, name
	from person
	where name = 'Clint Eastwood'
)
select
	p.id as person_id, 
	p.name, 
	m.id as movie_id, 
	m.year, 
	m.title as movie_title
from 
	movie m 
	join person_of_interest p on m.director_id = p.id
UNION  -- UNION ALL garde les doublons
select
	p.id as person_id, 
	p.name, 
	m.id as movie_id, 
	m.year, 
	m.title as movie_title
from 
	movie m 
	join play pl on pl.movie_id = m.id 
	join person_of_interest p on pl.actor_id = p.id
-- clause order by commune à l'union des 2 requetes
order by m.year desc, m.title;

-- idem with role + mention acteur/réalisateur
with person_of_interest as (
	select id, name
	from person
	where name = 'Clint Eastwood'
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
order by m.year desc, m.title;