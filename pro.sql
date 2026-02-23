use project;
select * from netflix;
describe netflix;
#Q1
insert into netflix values(1,"Movie","RRR","Rajamoli","Ram Charan, NTR","India","December 27,2024",2022,"R","International,Action, Drama","An action-packed telugu-language epic set in 1920s pre-independence India");
create table netflix1(show_id VARCHAR(10) PRIMARY KEY, type1 VARCHAR(20) NOT NULL CHECK (type1 IN ('Movie', 'TV Show')),
    title VARCHAR(255) NOT NULL, director VARCHAR(255), cast TEXT, country VARCHAR(255), date_added DATE, 
    release_year INT, rating VARCHAR(20), duration VARCHAR(50), listed_in VARCHAR(255), description1 TEXT
);
#Q2
select title,count(title) as more_than_1 from netflix group by title having more_than_1>1;
delete from netflix where show_id not in ( select * from (select min(show_id) FROM netflix GROUP BY title) as t);
select title,release_year from netflix where release_year=(select max(release_year) from netflix);
#Q3
create table titles (
    show_id      varchar(10) primary key,
    type         varchar(20),
    title        varchar(255),
    release_year int,
    rating       varchar(20),
    duration     varchar(50),
    description  text
);
create table directors (
    director_id int auto_increment primary key,
    show_id     varchar(10),
    director    varchar(255),
    foreign key (show_id) references titles(show_id)
);
create table cast_members (
    cast_id   int auto_increment primary key,
    show_id   varchar(10),
    cast_name varchar(255),
    foreign key (show_id) references titles(show_id)
);
create table countries (
    country_id int auto_increment primary key,
    show_id    varchar(10),
    country    varchar(255),
    foreign key (show_id) references titles(show_id)
);
create table categories (
    category_id int auto_increment primary key,
    show_id     varchar(10),
    category    varchar(255),
    foreign key (show_id) references titles(show_id)
);
insert into titles (show_id, type, title, release_year, rating, duration, description)
values ('s10', 'movie', 'interstellar', 2014, 'pg-13', '169 min', 'a space exploration adventure.');
insert into directors (show_id, director) values ('s10', 'christopher nolan');
insert into cast_members (show_id, cast_name)values ('s10', 'matthew mcconaughey'),('s10', 'anne hathaway'),('s10', 'jessica chastain');
insert into countries (show_id, country) values ('s10', 'united states');
insert into categories (show_id, category)values ('s10', 'sci-fi'), ('s10', 'drama');
insert into titles (show_id, type, title, release_year, rating, duration, description) values('s20', 'tv show', 'money heist', 2017, 'tv-ma', '5 seasons', 'a group executes a high-stakes heist.');
insert into directors (show_id, director)values ('s20', 'alex pina');
insert into cast_members (show_id, cast_name) values ('s20', 'ursula corbero'),('s20', 'alvaro morte');
insert into countries (show_id, country) values ('s20', 'spain');
insert into categories (show_id, category) values ('s20', 'crime'), ('s20', 'thriller');
insert into titles (show_id, type, title, release_year, rating, duration, description) values ('s30', 'tv show', 'stranger things', 2016, 'tv-14', '4 seasons', 'mysterious events in a small town.');
insert into directors (show_id, director) values ('s30', 'duffer brothers');
insert into cast_members (show_id, cast_name) values('s30', 'millie bobby brown'), ('s30', 'finn wolfhard');
insert into countries (show_id, country) values ('s30', 'united states');
insert into categories (show_id, category) values ('s30', 'sci-fi'), ('s30', 'horror');
select t.show_id,
    t.type,
    t.title,
    t.release_year,
    t.rating,
    t.duration,
    d.director,
    c.cast_name,
    co.country,
    cat.category,
    t.description
from titles t
left join directors d on t.show_id = d.show_id
left join cast_members c on t.show_id = c.show_id
left join countries co on t.show_id = co.show_id
left join categories cat on t.show_id = cat.show_id
order by t.show_id;
#Q4
select n1.title as title_1, n2.title as title_2, n1.director from netflix n1 join netflix n2
    on n1.director = n2.director
    and n1.title <> n2.title
    and n1.director is not null
    and n1.director <> ''
    and n1.show_id < n2.show_id;
#Q5
select n1.release_year as year1, n2.release_year as year2 from netflix n1 join netflix n2 
	on n1.title = n2.title
    and (n1.release_year<>n2.release_year or n1.type <>n2.type)
    and n1.show_id<n2.show_id;
#Q6
select 
    director,
    count(*) as total_titles
from netflix
where director <> ''
group by director
having count(*) > ( select avg(dir_count)from 
( select director, count(*) as dir_count
        from netflix where director is not null and director <> '' group by director
    ) as t
);
#Q7
select 
    type,
    count(*) as total_count,
    (count(*) * 100 / (select count(*) from netflix)) as percentage_contribution
from netflix
group by type;
#Q8
select 
    country,
    count(title) as total_titles,
    dense_rank() over (order by count(title) desc) as rank_country
from netflix
where country <> ''
group by country
order by total_titles desc;

#Q9
select rating,release_year fom (
select rating,release_year,dense_rank() over (partition by rating order by release_year desc) as rnk from netflix
    where rating is not null and rating <> '') as t where rnk = 2;
#q10
select date_added,count(*) as titles_added,sum(count(*)) over (order by date_added) as cumulative_total from netflix where date_added is not null
group by date_added order by date_added;

#Q11
select year(date_added) as year_added,count(*) as titles_added,lag(count(*)) over (order by year(date_added)) as previous_year_count,
count(*) - lag(count(*)) over (order by year(date_added)) as difference from netflix where date_added is not null group by year(date_added) order by year_added;

#Q12
select title, country, count(*) over (partition by country) as country_total, count(*) over () as overall_total from netflix 
where country is not null and country <> '';

#Q13
select title, release_year from (select title, release_year, lag(release_year) over (order by release_year) as previous_year, 
lead(release_year) over (order by release_year) as next_year from netflix) as t where release_year > previous_year and release_year < next_year;

#Q14
call get_netflix_titles('movie', 2015);

#Q15
select country, count(*) as total_titles, dense_rank() over (order by count(*) desc) as rank_country from netflix
where country is not null and country <> '' group by country;

