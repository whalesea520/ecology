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
insert into uf4mode_cptdepreconf(deprename,depremethod,sptcount,isopen,issystem,creater,createdate,createtime,lastmoddate,lastmodtime,guid1) values ('年限平均法(系统自带折旧法,从资产第1次使用开始按月计算折旧)','#<startprice>-(#<startprice>*(100-#<czcount>)/100)*#<usedmonth>/(#<depreyear>*12)',1,'1',1,1,'2015-10-10','16:39:45','2015-10-10','16:39:45','71bf0455-feb1-4f01-a461-cfac5727b344')
/
insert into uf4mode_cptdepreconf(deprename,depremethod,sptcount,isopen,issystem,creater,createdate,createtime,lastmoddate,lastmodtime,guid1) values ('非单独核算资产现值(系统自带)','#<startprice>*#<capitalnum>',0,'1',1,1,'2015-10-10','16:40:11','2015-10-10','16:40:11','5a6811ad-d267-4f61-9c08-7c00da2795b3')
/
