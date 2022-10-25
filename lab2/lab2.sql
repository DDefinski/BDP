--zad2
create database bdp2;

--zad3
create extension postgis;

--zad4
create table buildings( id integer not null primary key, geometry geometry, name varchar);
create table roads( id integer not null primary key, geometry geometry, name varchar);
create table poi( id integer not null primary key, geometry geometry, name varchar);

--zad5
insert into buildings values  (1, 'polygon((8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4))', 'BuildingA'),
                              (2, 'polygon((4 5, 6 5, 6 7, 4 7, 4 5))', 'BuildingB'),
                              (3, 'polygon((3 8, 5 8, 5 6, 3 6, 3 8))', 'BuildingC'),
                              (4, 'polygon((10 8, 10 9, 9 9, 9 8, 10 8))', 'BuildingD'),
                              (5, 'polygon((2 2, 2 1, 1 1, 1 2, 2 2))', 'BuildingE');

insert into roads values (1, 'linestring(12 4.5, 0 4.5)', 'RoadX'),
                         (2, 'linestring(7.5 0, 7.5 10.5)', 'RoadY');

insert into poi values (1,'point(1 3.5)','G'),
                       (2,'point(5.5 1.5)','H'),
                       (3,'point(9.5 6)','I'),
                       (4,'point(6.5 6)','J'),
                       (5,'point(6 9.5)','K');
--zad6
--a
select SUM(ST_LENGTH(geometry)) from roads;

--b
select ST_AsText(geometry), ST_Area(geometry), ST_Perimeter(geometry) from buildings where name='BuildingA';

--c
select name, ST_Area(geometry) from buildings order by name;

--d
select name, ST_Perimeter(geometry) from buildings order by ST_Perimeter(geometry) desc limit 2;

--e
select ST_Distance(buildings.geometry, poi.geometry) from buildings, poi where buildings.name = 'BuildingC' and poi.name = 'K';

--f
with BuildingB as (select geometry from buildings where name = 'BuildingB'), BuildingC as (select geometry from buildings where name = 'BuildingC')
select ST_Area(BuildingC.geometry) - ST_Area(ST_Intersection(ST_Buffer(BuildingB.geometry, 0.5), BuildingC.geometry)) as res from BuildingB, BuildingC;

--g
with RoadXPos as (select geometry from roads where name = 'RoadX')
select name from buildings,RoadXPos where ST_Y(ST_CENTROID(buildings.geometry)) > ST_Y(ST_Centroid(RoadXPos.geometry));

--h
with BuildingC as (select geometry from buildings where name = 'BuildingC')
select ST_Area(BuildingC.geometry) + ST_Area(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')) - 2 * ST_Area(ST_Intersection(BuildingC.geometry, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) from BuildingC;