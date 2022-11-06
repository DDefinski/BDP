--zad1
select * from t2019_kar_buildings b2019 left join t2018_kar_buildings b2018 on b2018.geom=b2019.geom where b2018.gid is null;

--zad2
with
    POI as (select p2019.gid, p2019.poi_id, p2019.type, p2019.geom from t2019_kar_poi_table p2019 left join t2018_kar_poi_table p2018 on p2018.geom=p2019.geom where p2018.gid is null),
    buildings as (select b2019.gid, b2019.polygon_id, b2019.type, b2019.geom from t2019_kar_buildings b2019 left join t2018_kar_buildings b2018 on b2018.geom=b2019.geom where b2018.gid is null)
select count(distinct POI.gid), POI.type from POI join buildings on st_dwithin(POI.geom,buildings.geom, 500) group by POI.type;

--zad3
create table streets_reprojected as select * from t2019_kar_streets;
update streets_reprojected set geom=ST_Transform(ST_SetSRID(streets_reprojected.geom,4326), 3068);

--zad4
create table input_points( _id integer not null primary key , geom geometry);
insert into input_points values (1, 'POINT(8.36093 49.03174)');
insert into input_points values (2, 'POINT(8.39876 49.00644)');

--zad5
update input_points set geom=ST_Transform(ST_SetSRID(geom,4326), 3068);

--zad6
update t2019_kar_street_node set geom=ST_Transform(ST_SetSRID(geom,4326), 3068) WHERE gid>0;
with line as (select ST_MAKELINE(geom) as l from input_points)
select * from t2019_kar_street_node join line on ST_DWITHIN(t2019_kar_street_node.geom,line.l, 200);

--zad7
with stores as (select * from t2019_kar_poi_table where type = 'Sporting Goods Store')
select count(distinct stores.gid) from stores join t2019_kar_land_use_a on ST_DWITHIN(stores.geom,t2019_kar_land_use_a.geom, 300);

--zad8
select distinct st_intersection(t2019_kar_water_lines.geom, t2019_kar_railways.geom) into T2019_KAR_BRIDGES FROM t2019_kar_water_lines, t2019_kar_railways;
