create table cpt_cptwfconf(
id int  not null,
wftype varchar2(20) null,
wfid int null,
sqr int null,
zczl int null,
zc int null,
sl int null,
zcz int null,
jg int null,
rq int null,
ggxh int null,
cfdd int null,
bz int null,
wxqx int null,
wxdw int null,
isasync int null,
actname varchar2(200) null
)
/
create sequence cpt_cptwfconf_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cpt_cptwfconf_TRIGGER before insert on cpt_cptwfconf for each row 
begin 
	select cpt_cptwfconf_ID.nextval into :new.id from dual; 
end;
/