-- THIS MAIN TABLE
create table company(
id serial, 
name varchar(23) not null,
age int not null,
address varchar(36) not null,
salary real not null);

-- We are perform operations on company table
-- this table is used for after inserting the value that record stored in audit table
create table audit(
aid serial,
Entry_Date text not null
);

-- I apply trigger  -- insert query always after .new
create or replace function auditlog() returns trigger
as $$
begin
insert into audit(aid,Entry_Date) values (new.id,current_timestamp);
return new;
end;
$$ language plpgsql;

-- apply for the company
create trigger auditcomp
after insert on company
for each row 
execute function auditlog();

-- ---------------------------------

-- before update the salary
create table beforeUpdateSal(
bid serial,
name varchar(23) not null,
salary real not null
);
-- I apply trigger  -- update query always after .new
create or replace function cbeforeUpdateSal() returns trigger
as $$
begin
insert into beforeUpdateSal(bid,name,salary) values (old.id,old.name,old.salary);
return old;
end;
$$ language plpgsql;

-- apply for the company
create trigger beforeupdatecompany
before update on company
for each row 
execute function cbeforeUpdateSal();

-- ---------------------------------

-- after update the salary
create table afterUpdateSal(
uid serial,
name varchar(23) not null,
salary real not null
);

-- I apply trigger  -- update query always after .new
create or replace function cafterUpdateSal() returns trigger
as $$
begin
insert into afterUpdateSal(uid,name,salary) values (new.id,new.name,new.salary);
return new;
end;
$$ language plpgsql;

-- apply for the company
create trigger afterupdatecompa
after update on company
for each row 
execute function cafterUpdateSal();

-- +++++++++++++++++++++++++++++++++++++++++++++++++
select * from company;
select * from audit;
select * from beforeUpdateSal;
select * from afterUpdateSal;


-- insert queries
insert into company(name,age,address,salary) values('Shejal',21,'Nagpur',64000);
insert into company(name,age,address,salary) values('Raj',30,'Pune',53000);
insert into company(name,age,address,salary) values('Collin',28,'Mumbai',100000);
insert into company(name,age,address,salary) values('Priya',31,'Delhi',30000);
insert into company(name,age,address,salary) values('Manish',22,'US',50000);

-- *************************************************************************

-- Before update 
update company set salary = salary+5000 where salary>=50000 -- before create update table
update company set salary = salary-1000 where salary>=100000

-- **********************************************************************
-- AFTER UPDATE
update company set salary = salary+1000 where salary>=100000;
update company set name = 'Kranti' where id=3;

