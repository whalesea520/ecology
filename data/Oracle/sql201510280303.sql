CREATE TABLE uf4mode_cptdepreconf (
id int  NOT NULL,
deprename varchar2(1000),
depremethod varchar2(2000),
sptcount int null,
isopen char(1) NULL,
issystem char(1) null,
creater int NULL,
createdate char(10) NULL,
createtime char(8) NULL,
lastmoddate char(10) NULL,
lastmodtime char(8) NULL,
guid1 char(36) NULL
)
/

create sequence uf4mode_cptdepreconf_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger uf4mode_cptdepreconf_Trigger
before insert on uf4mode_cptdepreconf
for each row
begin
select uf4mode_cptdepreconf_id.nextval into :new.id from dual;
end;
/
insert into uf4mode_cptdepreconf(deprename,depremethod,sptcount,isopen,issystem,creater,createdate,createtime,lastmoddate,lastmodtime,guid1) values ('����ƽ����(ϵͳ�Դ��۾ɷ�,���ʲ���1��ʹ�ÿ�ʼ���¼����۾�)','#<startprice>-(#<startprice>*(100-#<czcount>)/100)*#<usedmonth>/(#<depreyear>*12)',1,'1',1,1,'2015-10-10','16:39:45','2015-10-10','16:39:45','71bf0455-feb1-4f01-a461-cfac5727b344')
/
insert into uf4mode_cptdepreconf(deprename,depremethod,sptcount,isopen,issystem,creater,createdate,createtime,lastmoddate,lastmodtime,guid1) values ('�ǵ��������ʲ���ֵ(ϵͳ�Դ�)','#<startprice>*#<capitalnum>',0,'1',1,1,'2015-10-10','16:40:11','2015-10-10','16:40:11','5a6811ad-d267-4f61-9c08-7c00da2795b3')
/