create table fontinfo(
       id integer,
       f_name varchar(50),
       f_desc varchar(50)
)
/
create sequence sq_fontinfo
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger tr_fontinfo
before insert on fontinfo
for each row
begin
select sq_fontinfo.nextval into :new.id from dual;
end;
/

insert into fontinfo(f_name,f_desc)values('����','����')
/
insert into fontinfo(f_name,f_desc)values('����','����')
/
insert into fontinfo(f_name,f_desc)values('Verdana','Verdana')
/
insert into fontinfo(f_name,f_desc)values('�����п�','�����п�')
/
insert into fontinfo(f_name,f_desc)values('���Ĳ���','���Ĳ���')
/

insert into fontinfo (f_name,f_desc) values('��������','��������')
/
insert into fontinfo (f_name,f_desc) values('����Ҧ��','����Ҧ��')
/
insert into fontinfo (f_name,f_desc) values('���ķ���','���ķ���')
/
insert into fontinfo (f_name,f_desc) values('���Ŀ���','���Ŀ���')
/
insert into fontinfo (f_name,f_desc) values('��������','��������')
/
insert into fontinfo (f_name,f_desc) values('��������','��������')
/
insert into fontinfo (f_name,f_desc) values('��������','��������')
/
insert into fontinfo (f_name,f_desc) values('΢���ź�','΢���ź�')
/
insert into fontinfo (f_name,f_desc) values('������','������')
/
insert into fontinfo (f_name,f_desc) values('����','����')
/
insert into fontinfo (f_name,f_desc) values('����','����')
/
insert into fontinfo (f_name,f_desc) values('����','����')
/
insert into fontinfo (f_name,f_desc) values('��Բ','��Բ')
/
insert into fontinfo (f_name,f_desc) values('serif','serif')
/
insert into fontinfo (f_name,f_desc) values('sans-serif','sans-serif')
/
insert into fontinfo (f_name,f_desc) values('cursive','cursive')
/
insert into fontinfo (f_name,f_desc) values('fantasy','fantasy')
/
insert into fontinfo (f_name,f_desc) values('monospace','monospace')
/
insert into fontinfo (f_name,f_desc) values('inherit','inherit')
/