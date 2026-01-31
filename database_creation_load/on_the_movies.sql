drop database if  exists on_the_movie;

create database on_the_movie;

use on_the_movie;

create table user (
user_id int primary key,
gender varchar(1),
age int,
cap varchar(15),
work varchar(100));


create table movie (
movie_id int primary key,
title varchar(100),
genres JSON,
year date);

create table ratings (
user_id int,
movie_id int,
rating int,
timestamp timestamp,
foreign key (movie_id) references movie(movie_id),
foreign key (user_id) references user(user_id));


select * from on_the_movie;
