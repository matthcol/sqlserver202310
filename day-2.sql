-- Chercher Steve McQueen
-- Chercher Tarantino
-- Chercher les gens dont le nom finit par O'Hara
select *
from person
where name like '% O''Hara'
order by name;

-- Les personnes n�es en 1930 tri�es par ordre alphab�tique
-- Hint: datepart ou year
select *
from person
where year(birthdate) = 1930
order by name;

select *
from person
where datepart(year, birthdate) = 1930
order by name;


-- Quel age aura Clint Eastwood � la fin de l'ann�e ?
-- les films des ann�es 70s durant entre 2H et 2H10 
--		tri�s par dur�e d�croissante puis par titre
select
	name,
	birthdate,
	DATEDIFF(year, birthdate, CURRENT_TIMESTAMP)
from person
where name like 'Clint Eastwood';

-- Combien y a t il de Steve McQueen ?
select count(*) as nb_smq
from person
where name like 'Steve McQueen';

-- Combien y a t il de noms diff�rents de personne ? 
-- 		Combien sont r�p�t�s ?
select 
	count(*) as nb_person
	, count(distinct name) as nb_name
	, count(*) - count(distinct name) as nb_name_repeated
	, (count(*) - count(distinct name)) /  cast(count(*) as decimal) as percent_name_repeated
from person;

-- 
select *
from movie
where title in (
	'Titanic', 
	'The Terminator', 
	'E.T. the Extra-Terrestrial', 
	'Kill Bill: Vol. 1'
);

select *
from person
where id in (229, 233, 116);

-- jointure interne (inner join=join)
select *
from
	movie m
	join person p on m.director_id = p.id
;

-- equivalent: join = inner join
select *
from
	movie m
	inner join person p on m.director_id = p.id
;

select 
	m.title,
	m.year,
	p.name
from
	movie m
	inner join person p on m.director_id = p.id
;

select 
	m.title,
	m.year,
	p.name
from
	movie m
	inner join person p on m.director_id = p.id
where m.title in (
	'Titanic', 
	'The Terminator', 
	'E.T. the Extra-Terrestrial', 
	'Kill Bill: Vol. 1'
);

-- filmographie (en tant que r�alisateur) de Quentin Tarantino
-- (chronologie invers�e)
select 
	m.title,
	m.year,
	p.name
from
	movie m
	inner join person p on m.director_id = p.id
where p.name = 'Quentin Tarantino'
order by m.year desc;

-- filmographie (en tant que r�alisateur) de Clint Eastwood
-- dans les ann�es 80s, chronologie croissante
select 
	m.title,
	m.year,
	p.name
from
	movie m
	inner join person p on m.director_id = p.id
where 
	p.name = 'Clint Eastwood'
	and m.year between 1980 and 1989
order by m.year;

-- autre �criture (jointure pivot)
select 
	m.title,
	m.year,
	p.name
from
	movie m
	, person p
where 
	m.director_id = p.id  -- condition jointure
	and p.name = 'Clint Eastwood' -- filtre sur la table person
	and m.year between 1980 and 1989 -- filtre sur la table movie
order by m.year;

-- acteurs (avec leur personnage) du film Titanic
select 
	m.title,
	m.year,
	pe.name,
	pl.role
from
	movie m
	join play pl on pl.movie_id = m.id
	join person pe on pl.actor_id = pe.id
where m.title = 'Titanic'
order by m.year, pe.name;

select
	m.id,
	m.title,
	m.year,
	pe.name,
	pl.role
from
	movie m
	join play pl on pl.movie_id = m.id
	join person pe on pl.actor_id = pe.id
where m.title = 'The Man Who Knew Too Much'
order by m.year, pe.name;

-- en 2x 
-- 1- les films 'The MAn ...' => 2 r�sultats: 25452, 49470
select *
from movie m
where m.title = 'The Man Who Knew Too Much';
-- 2 - faire la requ�te avec les acteurs en nen gardant que le film 
-- ave l'id qui nous int�resse
select
	m.id,
	m.title,
	m.year,
	pe.name,
	pl.role
from
	movie m
	join play pl on pl.movie_id = m.id
	join person pe on pl.actor_id = pe.id
where m.id = 49470
order by pe.name;

-- genres du film Titanic
select
	m.title,
	m.year,
	g.genre
from
	movie m
	join have_genre g on g.movie_id = m.id
where m.title like 'Titanic'
;

select
	m.title,
	m.year,
	string_agg(g.genre, ', ') as genres
from
	movie m
	join have_genre g on g.movie_id = m.id
where m.title like 'Titanic'
group by m.id, m.title, m.year;

select
	m.title,
	m.year,
	string_agg(g.genre, ', ') as genres
from
	movie m
	join have_genre g on g.movie_id = m.id
where m.title like 'The Man Who Knew Too Much'
group by m.id, m.title, m.year;

-- attention � ne pas m�langer les donn�es avec group by
select
	m.title,
	string_agg(g.genre, ', ') as genres
from
	movie m
	join have_genre g on g.movie_id = m.id
where m.title like 'The Man Who Knew Too Much'
group by m.title;

-- Film Titanic (titre, ann�e, dur�e) avec:
--    - r�alisateur (nom), 
--    - acteurs (nom, role)
--    - genre(s)
select 
	m.title
	, m.year
	, m.duration
	, d.name as director_name
	, a.name as actor_name
	, pl.role
	, g.genre
from 
	movie m
	join person d on m.director_id = d.id
	join play pl on pl.movie_id = m.id
	join person a on pl.actor_id = a.id
	join have_genre g on g.movie_id = m.id
where 
	m.title = 'Titanic'
order by actor_name, genre;

-- films dramatiques (Drama) de 1997
select
	m.title
	, m.year
	, g.genre
from 
	movie m
	join have_genre g on g.movie_id = m.id
where
	g.genre = 'Drama'
	and m.year = 1997
order by m.title;

-- idem sur plusieurs genres
-- NB: 2 lignes dans le r�sultat si le film a les 2 genres
select
	m.title
	, m.year
	, g.genre
from 
	movie m
	join have_genre g on g.movie_id = m.id
where
	g.genre in ('Drama', 'Horror')
	and m.year = 1997
order by m.title;

-- pour enlever les doublons: distinct
select distinct
	m.title
	, m.year
from 
	movie m
	join have_genre g on g.movie_id = m.id
where
	g.genre in ('Drama', 'Horror')
	and m.year = 1997
order by m.title;

-- idem avec sous requete ind�pendante
select
	title
	, year
from movie
where
	year = 1997
	and id in (
		select movie_id
		from have_genre
		where genre in ('Drama', 'Horror')
	)
order by title;

-- avec sous-requ�tes (en s�lection WHERE):
-- -1- filmographie de Clint Eastwood en tant que r�alisateur
select
	title
	, year
from movie
where director_id = ( -- = en considerant Clint Eastwood unique
	select id from person where name = 'Clint Eastwood'
)
order by year;
-- -2- filmographie de Clint Eastwood en tant qu'acteur
select
	title
	, year
from movie
where id in (
	select movie_id
	from play
	where actor_id = ( -- = en considerant Clint Eastwood unique
		select id from person where name = 'Clint Eastwood'
	)
)
order by year;
-- sol 2 avec jointure + sous-requ�te pour afficher le role dans chaque film
select
	m.title
	, m.year
	, pl.role
from
	movie m
	join play pl on pl.movie_id = m.id
where 
	pl.actor_id = (
		select id from person where name = 'Clint Eastwood'
	)
order by m.year;


-- -3- film(s) qui a/ont la dur�e la plus longue
select 
	*
from movie
where duration = (
	select
		max(duration)
	from movie
);
-- -3bis- film(s) qui a/ont la dur�e la plus courte
select 
	*
from movie
where duration = (
	select
		min(duration)
	from movie
);

-- sous-requete dans 1 where
--  1 : requete  � 1 seul r�sultat (1 colonne 1 ligne) => op�rateur =  <>  < <=  > >= ...
--  2 : requete � plusieurs r�sultats (1 colonne, plusieurs lignes) => op�rateurs
--			in : =ANY
--			not in : <>ALL
select *
from movie
where director_id =ANY (  -- IN eq  =ANY
	select id 
	from person
	where name in (
		'Clint Eastwood',
		'Quentin Tarantino',
		'Steven Spielberg',
		'Martin Scorsese'
	)
)
order by director_id;


select 
	year,
	max(duration)
from movie
where year between 1980 and 1989
group by year;

select 
	m.title,
	m.year,
	m.duration
from movie m
where
	year between 1980 and 1989
	and m.duration >=ANY ( -- tester avec >=ALL
	select 
		max(duration) * 0.90
	from movie
	where year between 1980 and 1989
	group by year
);