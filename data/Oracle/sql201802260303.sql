create sequence hp_func_server_seq increment by 1 start with 1 nomaxvalue nocycle cache 10
/
create table  hp_nonstandard_func_server(
	id int not null,
	funcid int not null,
	serverid int not null,
	status int 
)
/
create or replace trigger hp_func_server_trigger
before insert on hp_nonstandard_func_server for each row
begin  
select hp_func_server_seq.nextval into :new.id 

 from dual;
end;
/

create sequence hp_server_info_seq increment by 1 start with 1 nomaxvalue nocycle cache 10
/

create table  hp_server_info(
	id int not null,
	serverIP varchar(1000) not null,
	serverType int
)
/
create or replace trigger hp_server_trigger
before insert on hp_server_info for each row
begin  
select hp_server_info_seq.nextval into :new.id 

 from dual;
end;
/
