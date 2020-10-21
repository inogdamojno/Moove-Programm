-----------------------------------------
Принцип решения: нормализация таблиц с соблюдением 1-3 НФ. Добавления PK, FK. 
Построение индексов. 
Данный подход гарантирует быстродействие при работе с редкоизменяемыми данными (измерениями, а не фактами)
-----------------------------------------
--1
select r.*
		, e.first_name
		, e.last_name
from data.rooms r 
join data.employee e on e.room_id = r.room_id
where r.room = '2591';
--2
insert into data.phones (employee_id, phone)
select e.employee_id, '+1234567890'
from data.employee e 
where e.first_name = 'Aaron'
	and e.last_name = 'Briggs'
;
--3
select e.first_name
		, e.last_name
		, ph.phone
		, d.department_name
		, p.position_name
from data.employee e 
join data.departments d on d.department_id = e.department_id
join data.positions p on p.position_id = e.position_id
left join data.phones ph on ph.employee_id = e.employee_id
where d.department_name = 'R&D'
	and p.position_name = 'Manager';
--4
insert into data.employee (department_id, email, first_name, last_name, position_id, room_id)
select d.department_id
		, 'ivan.ivanov@mail.ru'
		, 'Ivan' first_name
		, 'Ivanov' last_name
		, p.position_id
		, r.room_id
from data.dictionary t 
left join data.departments d on d.department_name = 'R&D'
left join data.positions p on p.position_name = 'Intern'
left join data.rooms r on r.room = '2591'; 
--5
update data.employee e 
set department_id = (select d.department_id from data.departments d where d.department_name = 'R&D')
	, room_id = (select r.room_id from data.rooms r where r.room = '2591')
where e.first_name = 'Aaron'
	and e.last_name = 'Briggs';