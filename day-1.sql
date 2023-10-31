select * from movie;

-- projection: choix de colonnes
select title, year from movie;

-- selection: choix de lignes (avec une condition/prédicat)
select * from movie where year = 1918;
select * from movie where year <> 1918; -- différent
select * from movie where year != 1918; -- différent

select * from movie where year in (1918, 1990);
select * from movie where year not in (1918, 1990);

-- projection + selection
select title, year from movie where year = 1984;

select title, year from movie where year between 1980 and 1989;

-- tri
select title, year 
from movie 
where year between 1980 and 1989
order by year, title;

select title, year 
from movie 
where year between 1980 and 1989
order by year desc, title;

select title, year 
from movie 
where year not between 1920 and 1929
order by year;

-- operateur de comparaison numérique: < <= > >=
select title, year
from movie
where year >= 2020; 

select title, year
from movie
where year > 2020; 

-- liste des films (titre, année, durée) de durée entre 1H30 et 2H
-- triés par durée décroissante puis année puis titre

select title, year, duration
from movie
where duration between 90 and 120
order by duration desc, year, title;

select 
	title, 
	year, 
	duration,
	duration / 60 as duration_hour,
	duration % 60 as duration_minute
from movie
where duration between 90 and 120
order by duration desc, year, title;

select 
	title, 
	year, 
	duration,
	duration / 60 as duration_hour,
	duration % 60 as duration_minute
from movie
where 
	duration between 90 and 120
	and year between 1980 and 1989
order by duration desc, year, title;

select 
	title,
	year
from movie
where 
	year between 1960 and 1969
	or year between 1980 and 1989
order by year, title;

-- idem + filtre duree 1H30-2H
select 
	title,
	year,
	duration
from movie
where 
	duration between 90 and 120
	and (
		year between 1960 and 1969
		or year between 1980 and 1989
    )
order by year, title;

-- données textuelles (char, varchar, text)
select title, year
from movie
where title = 'The Terminator';

select title, year
from movie
where title = 'the terminator';

-- operateur like:
-- % vaut 0 à n caractères
-- _ vaut un caractère
select title, year
from movie
where title like '%godfather%'; -- qui contient

select title, year
from movie
where title like 'star %'; -- qui commence par

select title, year
from movie
where title like 'Star Wars: Episode __ - %';

select title, year
from movie
where title like 'Star Wars: Episode [IVX][IVX] - %';

select title, year
from movie
where 
	title like 'star %'
  	and title not like '%dust%';

-- attention requete qui peut être couteuse
-- cf recherche full text
select title, year
from movie
where 
	synopsis like '%star%';

-- Excuse Me (1915) par concaténation: + (autre DB: ||)
select 
	title + ' ('   + cast(year as varchar) + ')' as title_year
from movie
where year = 1982;

-- encadrer un nom de: base, table, colonne, ... avec "" ou []
select 
	title + ' ('   + cast(year as varchar) + ')' as "title year"
from movie
where year = 1982;

select 
	title + ' ('   + cast(year as varchar) + ')' as [title year]
from movie
where year = 1982;

-- casse: upper, lower
select 
	upper(title) + ' ('   + cast(year as varchar) + ')' as [title year]
from movie
where year = 1982;

-- len, substring, left, right, trim
select
	title,
	year,
	len(title) as title_length
from movie
where len(title) >= 80
order by title_length desc;	

-- liste des films de 1992 avec 100 premiers caractères du synopsis
select
	title,
	substring(synopsis, 1, 100) as synopsis
from movie
where year = 1992;

select
	title,
	year,
	duration / 60.0 as duration_hour
from movie
where year = 1992;

-- arrondis
select 
	round(1/3.0, 0),
	round(1/3.0, 1),
	round(1/3.0, 2),
	round(2/3.0, 0),
	round(2/3.0, 1),
	round(2/3.0, 2),
	CEILING(1/3.0),
	CEILING(2/3.0),
	FLOOR(1/3.0),
	FLOOR(2/3.0)
;


-- requêtes sans tables !
select 1 + 3;
select upper('ToUlouSe');
select '#' + trim('  Toulouse, ville rose   ') +'#';

-- gérer cases NULL
select * from movie where duration is null;
select * from movie where duration is not null;
select * from movie where color is not null;

select 
	title,
	year,
	coalesce(duration, -1) as duration
from movie 
where year = 1922;

select
	title,
	nullif(title, 'The Man Who Would Be King') as title_censored
from movie
where title like '%man who%';

select
	title,
	case
		when title like '%the man who%' then NULL
		else title
	end as title_censored
from movie
where title like '%man%'
order by title;

-- titre, année, durée et classification suivant la durée:
--		court pour moins d'une heure
--      moyen entre 1H et 2H
--      long au dessus de 2H
select 
	title,
	year,
	duration,
	case
		when duration < 60 then 'COURT'
		when duration < 120 then 'MOYEN'
		else 'LONG'
	end as duration_type
from movie;

-- gestion de données temporelles
select
	*
from person
where birthdate < '1900-01-01';

set dateformat dmy; -- ymd mdy
select
	*
from person
where birthdate < '01/01/1900';

-- Conversion failed when converting date and/or time from character string.
-- select
--	*
-- from person
-- where birthdate < '12/30/1900';

-- fonctions: datepart, datediff, dateadd

select
	name,
	birthdate,
	datepart(year, birthdate) as birth_year
from person
where datepart(year, birthdate) < 1900;

select 
	current_timestamp as now,
	-- current_date, 
	cast(CURRENT_TIMESTAMP as date) as today,
	datetrunc(day, CURRENT_TIMESTAMP) as today2, -- sql server 2022
	datetrunc(month, CURRENT_TIMESTAMP) as first_day_month,
	-- current_time
	cast(CURRENT_TIMESTAMP as time) as time2
;

-- conversion date => texte (voir tableau des styles dans la doc ci-dessous)
-- https://learn.microsoft.com/fr-fr/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver16

select
    name,
	convert(varchar, birthdate, 103) birthdate_fr
from person;

select @@version;

-- age des personnes
select
	name,
	birthdate,
	datepart(year, CURRENT_TIMESTAMP) - datepart(year, birthdate) as age,
	DATEDIFF(year, birthdate, CURRENT_TIMESTAMP) as age2
from person
order by age desc;

-- films sortis il y a moins de 10 ans
select 
	title,
	year
from movie
where year > datepart(year, CURRENT_TIMESTAMP) - 10
order by year;

select 
	m.title,
	m.year
from movie m
where m.year > datepart(year, CURRENT_TIMESTAMP) - 10
order by m.year;

-- fonctions d'aggregations (verticale, n valeurs => 1 val)

-- sur toute la table
select max(duration) as max_duration from movie;

select 
	min(duration) as min_duration,
	max(duration) as max_duration
from movie;

-- durée d'un marathon star wars
select
	*
from movie
where title like 'Star Wars%';

select
	count(*) count_sw, -- compte des lignes
	sum(duration) as total_duration_sw,
	sum(duration) / 60 as total_duration_sw_h,
	avg(duration) as average_duration,
	avg(cast(duration as decimal)) as average_duration2,
	STDEV(duration) as stdev_duration
from movie
where title like 'Star Wars%';

select count(color) from movie; -- que des NULL => 0

select *
from movie
where duration is null;

select
	count(*) as nb_movie,
	count(duration) as nb_duration,
	count(cast(synopsis as varchar)) as nb_synopsis,
	count(poster_uri) as nb_poster,
	sum(duration) as total_duration, -- NULL si que des NULL
	coalesce(sum(duration), 0) as total_duration2 -- 0 si que des NULL
from movie
where duration is null;

select
	count(*) as nb_movies,
	count(year) as nb_year,
	count(distinct year) as nb_year_distinct
from movie;

select
	count(*) as nb_movies,
	count(year) as nb_year,
	count(distinct year) as nb_year_distinct
from movie
where year not between 1940 and 1960;
