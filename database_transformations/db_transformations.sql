use on_the_movie;


ALTER TABLE user
ADD COLUMN age_category VARCHAR(20);

update user
set age_category =
    case
        when age < 18 then 'under_18'
        when age between 18 and 24 then '18-24'
        when age between 25 and 34 then '25-34'
        when age between 35 and 44 then '35-44'
        when age between 45 and 54 then '45-54'
        when age >= 55 then 'over_55'
    end
where user_id >= 1;

update user
set work =
    case
        when lower(work) in ('data scientis', 'data scientst', 'data scienist')
            then 'data scientist'
        else lower(work)
    end
    where user_id >= 1;
    


CREATE VIEW genre_counts AS
SELECT genre, COUNT(*) AS count
FROM movie
JOIN JSON_TABLE(
    genres,
    "$[*]" COLUMNS (genre VARCHAR(50) PATH "$")
) AS jt
GROUP BY genre
ORDER BY count DESC;




create view low_rated_movies as (
select m.movie_id, title, avg(rating), count(rating)
from movie m
left join ratings r
on m.movie_id = r.movie_id
group by m.movie_id, title
having avg(rating) < 3 and count(rating) > 250);



select m.movie_id, title, avg(rating), age_category, count(rating)
from movie m 
join ratings r
on m.movie_id = r.movie_id
join user u 
on r.user_id = u.user_id
where age_category = 'under_18' and count(rating) > 100
group by m.movie_id, title, age_category
order by avg(rating) desc; 

create or replace view movie_ratings_avg_count as(
select m.movie_id, title, rating, gender, age_category, 1
from movie m 
join ratings r
on m.movie_id = r.movie_id
join user u 
on r.user_id = u.user_id);



create view count_users_by_cap as (
select cap, count(user_id)
from user
group by cap
order by count(user_id)
limit 20);

create view count_by_job as (
select work, count(user_id) 
from user 
group by work);


create view province as (
select concat(left(cap, 2), '100')  as province_cap,
    CASE LEFT(cap, 2)
    WHEN '33' THEN 'Udine'
    WHEN '35' THEN 'Padova'
    WHEN '00' THEN 'Roma'
    WHEN '20' THEN 'Milano'
    WHEN '15' THEN 'Ancona'
    WHEN '09' THEN 'Cagliari'
    WHEN '14' THEN 'Alessandria'
    WHEN '45' THEN 'Rovigo'
    WHEN '36' THEN 'Vicenza'
    WHEN '84' THEN 'Salerno'
    WHEN '25' THEN 'Brescia'
    WHEN '21' THEN 'Varese'
    WHEN '26' THEN 'Cremona'
    WHEN '65' THEN 'Pescara'
    WHEN '47' THEN 'Forlì-Cesena'
    WHEN '40' THEN 'Bologna'
    WHEN '83' THEN 'Potenza'
    WHEN '44' THEN 'Ferrara'
    WHEN '10' THEN 'Torino'
    WHEN '70' THEN 'Bari'
    ELSE 'Unknown'
END AS province
 ,count(user_id)
from user
group by province_cap, province
order by count(user_id) desc);






