--Dim_Passengers
create table dwh_avia.Dim_Passengers (
	id varchar(20),
	passenger_name text not null,
	email varchar(50),
	phone varchar(30),
	primary key (id)
);
----------------------------------------------------------------
--Dim_Aircrafts


create table dwh_avia.Dim_Aircrafts (
	aircraft_code bpchar(3),
	model varchar(20),
	range int4,
	PRIMARY KEY (aircraft_code)
);
----------------------------------------------------------------

---Dim_Airports

create table dwh_avia.Dim_Airports (
	airport_code bpchar(3),
	airport_name varchar(50),
	city varchar(50),
	coordinates point,
	timezone text,
	PRIMARY KEY (airport_code)
);

------------------------------------------

--Dim_Tariff

create table dwh_avia.Dim_Tariff (
	fare_conditions varchar(10),
	PRIMARY KEY (fare_conditions)
);

--------------------------------------------------------------------------------------------------
--Dim_Calendar


create table dwh_avia.Dim_Calendar (
	date date,
	PRIMARY KEY (date)
);
     
insert into dwh_avia.Dim_Calendar (date)  
SELECT date_trunc('day', dd):: date as date
FROM generate_series
        ( '2017-05-17'::timestamp 
        , '2017-09-15'::timestamp
        , '1 day'::interval) dd
        ;

-----------------------------------------------------------------------------------------------
--Fact_Flights

create table dwh_avia.Fact_Flights (
    id uuid DEFAULT uuid_generate_v4(),
    passenger_id varchar(20),
    foreign key (passenger_id) references dwh_avia.dim_passengers(id),
    actual_departure_date date,
    actual_departure_time timestamp,
    actual_arrival_date timestamp,
    foreign key (actual_arrival_date) references dwh_avia.Dim_Calendar(date),
     foreign key (actual_departure_date) references dwh_avia.Dim_Calendar(date),
    actual_arrival_time timestamp,
    depature_delay float,
    arrival_delay float,
    aircraft_code bpchar(3),
    foreign key (aircraft_code) references dwh_avia.dim_aircrafts (aircraft_code),
    departure_airport bpchar(3),
    arrival_airport bpchar(3),
    fare_conditions varchar(10),
    foreign key (departure_airport) references dwh_avia.dim_airports(airport_code),
    foreign key (arrival_airport) references dwh_avia.dim_airports(airport_code),
    foreign key (fare_conditions) references dwh_avia.dim_tariff(fare_conditions),
    total_amount numeric (10,2),
	PRIMARY KEY (id)
);







