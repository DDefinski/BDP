create extension postgis;

create table objects(id serial primary key , geom geometry, name varchar);

--zad1

insert into objects(geom, name) values
    (ST_Collect(array[
        ST_GeomFromText('LINESTRING(0 1 ,1 1)'),
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(1 1,2 0, 3 1)')),
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(3 1,4 2, 5 1)')),
        ST_GeomFromText('LINESTRING(5 1 ,6 1)')
    ]),'obiekt1'),
    (ST_Collect(array[
        ST_GeomFromText('LINESTRING(10 6 ,14 6)'),
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(14 6,16 4, 14 2)')),
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(14 2,12 0, 10 2)')),
        ST_GeomFromText('LINESTRING(10 2 ,10 6)'),
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(11 2,12 3, 13 2, 12 1, 11 2)'))]),
        'obiekt2'),
    (ST_MakePolygon(ST_GeomFromText('LINESTRING(7 15, 10 17, 12 13, 7 15)')),
     'obiekt3'),
    (ST_LineFromMultiPoint(ST_GeomFromText('MULTIPOINT(20 20, 25 25,27 24, 25 22, 26 21, 22 19, 20.5 19.5)')),
     'obiekt4'),
    (ST_Collect(ST_GeomFromText('POINT(30 30 59)'),
        ST_GeomFromText('POINT(38 32 234)')),
     'obiekt5'),
    (ST_Collect(ST_GeomFromText('LINESTRING(1 1, 3 2)'),
        ST_GeomFromText('POINT(4 2)')),
     'obiekt6');

--zad2

select ST_Area(ST_Buffer(ST_ShortestLine(obiekt3.geom, obiekt4.geom),5)) from
        (select geom from objects where name='obiekt3') as obiekt3,
        (select geom from objects where name='obiekt4') as obiekt4;

--zad3

update objects
    set geom = ST_MakePolygon(ST_AddPoint(geom, ST_PointN(geom,1))) where name='obiekt4';

--zad4

insert into objects(geom, name)
    (select ST_Collect(obiekt3.geom, obiekt4.geom), 'obiekt7' from
        (select geom from objects where name='obiekt3') as obiekt3,
        (select geom from objects where name='obiekt4') as obiekt4);

--zad5

select ST_Area(ST_Buffer(geom, 5)), name
    from objects
    where ST_HasArc(ST_LineToCurve(geom)) = false;