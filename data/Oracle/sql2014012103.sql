CREATE TABLE OfUrlIcon ( 
    id integer not null,
    name varchar(20),
    type  varchar(100),
    icon  varchar(400),
    url  varchar(400),
    counturl varchar(400),
    sort  number
) 
/
create sequence OfUrlIcon_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger OfUrlIcon_id_trigger
before insert on OfUrlIcon
for each row
begin
select OfUrlIcon_id.nextval into :new.id from dual;
end;
/

CREATE TABLE OfIconList  ( 
    id integer not null,
    name varchar(20),
    url  varchar(400),
    width number,
    height  number
) 
/
create sequence OfIconList_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger OfIconList_id_trigger
before insert on OfIconList
for each row
begin
select OfIconList_id.nextval into :new.id from dual;
end;
/


delete from OfIconList
/
insert into OfIconList (name,url) values ('图标1','/plugins/emessage/images/icontab_cblog.png')
/
insert into OfIconList (name,url) values ('图标2','/plugins/emessage/images/icontab_createworkflow.png')
/
insert into OfIconList (name,url) values ('图标3','/plugins/emessage/images/icontab_customer.png')
/
insert into OfIconList (name,url) values ('图标4','/plugins/emessage/images/icontab_duanxin.png')
/
insert into OfIconList (name,url) values ('图标5','/plugins/emessage/images/icontab_email.png')
/
insert into OfIconList (name,url) values ('图标6','/plugins/emessage/images/icontab_handledworkflow.png')
/
insert into OfIconList (name,url) values ('图标7','/plugins/emessage/images/icontab_meetting.png')
/
insert into OfIconList (name,url) values ('图标8','/plugins/emessage/images/icontab_message.png')
/
insert into OfIconList (name,url) values ('图标9','/plugins/emessage/images/icontab_myrequest.png')
/
insert into OfIconList (name,url) values ('图标10','/plugins/emessage/images/icontab_processedworkflow.png')
/
insert into OfIconList (name,url) values ('图标11','/plugins/emessage/images/icontab_proj.png')
/
insert into OfIconList (name,url) values ('图标12','/plugins/emessage/images/icontab_todolist.png')
/
insert into OfIconList (name,url) values ('图标13','/plugins/emessage/images/icontab_xiezuo.png')
/