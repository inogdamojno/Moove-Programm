create table data.dictionary (record_id numeric, department varchar(1024), email varchar(1024), first_name varchar(1024), last_name varchar(1024), phone varchar(50), position varchar(1024), room numeric);

copy data.dictionary(record_id, department, email, first_name, last_name, phone, position, room)
from '/Users/db_normalized.csv'
delimiter ','
csv header;

select *
from data.dictionary;

------

create table data.departments (department_id serial, department_name varchar(1024),
								primary key(department_id));

insert into data.departments (department_name)
select distinct department
from data.dictionary;

select *
from data.departments;
------
create table data.positions (position_id serial, position_name varchar(1024),
								primary key(position_id));

insert into data.positions (position_name)
select distinct position
from data.dictionary;

select *
from data.positions;
------
create table data.rooms (room_id serial, room numeric,
							primary key(room_id));

insert into data.rooms (room)
select distinct room
from data.dictionary;

select *
from data.rooms;
------

create table data.employee (employee_id serial, department_id int, email varchar(1024), first_name varchar(1024), last_name varchar(1024), position_id int, room_id int,
							primary key(employee_id)
							, constraint fk_department
								foreign key(department_id)
									references data.departments(department_id)
							, constraint fk_position
								foreign key(position_id)
									references data.positions(position_id)
							, constraint fk_room
								foreign key(room_id)
									references data.rooms(room_id));


insert into data.employee (department_id, email, first_name, last_name, position_id, room_id)
select distinct d.department_id
		, t.email
		, t.first_name
		, t.last_name
		, p.position_id
		, r.room_id
from data.dictionary t 
left join data.departments d on d.department_name = t.department
left join data.positions p on p.position_name = t.position
left join data.rooms r on r.room = t.room;


select *
from data.employee;
----

create table data.phones (employee_id int, phone varchar(50)
						  , constraint fk_employee
								foreign key(employee_id)
									references data.employee(employee_id));

insert into data.phones (employee_id, phone)
select distinct e.employee_id
		, t.phone
from data.dictionary t
join data.employee e on e.first_name = t.first_name
					and e.last_name = t.last_name
					and e.email = t.email;

select *
from data.phones;