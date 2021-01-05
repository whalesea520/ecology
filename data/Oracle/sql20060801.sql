update systemrights set detachable=1 where id=109
/

alter table hrmsalaryitem add applyscope integer
/
alter table hrmsalaryitem add subcompanyid integer
/
alter table HrmSalaryItem add calMode integer
/
alter table HrmSalaryItem add  directModify integer
/
alter table HrmSalaryItem add  companyPercent float
/
alter table HrmSalaryItem add  personalPercent float
/
declare detachable_1 integer;
        defaultsubcom_1 integer;
        minsubcom_1 integer;

begin
select detachable into detachable_1  from systemset;
select dftsubcomid into defaultsubcom_1 from systemset;

if(detachable_1<>null and defaultsubcom_1<>null) then
update  hrmsalaryitem set applyscope=0,subcompanyid=defaultsubcom_1;
else
select  min(id) into minsubcom_1 from hrmsubcompany;
update  hrmsalaryitem set applyscope=0,subcompanyid=minsubcom_1;
end if;

end;
/



INSERT INTO HtmlLabelIndex values(19467,'范围')
/
INSERT INTO HtmlLabelInfo VALUES(19467,'范围',7)
/
INSERT INTO HtmlLabelInfo VALUES(19467,'scope',8)
/
create table HrmSalaryTaxscope ( itemid integer,
                                   benchid integer,
                                   scopetype integer,
                                   objectid integer)
/


INSERT INTO HtmlLabelIndex values(19482,'时间范围')
/
INSERT INTO HtmlLabelInfo VALUES(19482,'时间范围',7)
/
INSERT INTO HtmlLabelInfo VALUES(19482,'time scope',8)
/

INSERT INTO HtmlLabelIndex values(19483,'半年度')
/
INSERT INTO HtmlLabelInfo VALUES(19483,'半年度',7)
/
INSERT INTO HtmlLabelInfo VALUES(19483,'half year',8)
/

create table HrmSalaryCalBench(id integer,
                                 itemid integer,
                                 scopetype integer)
/
create sequence  HrmSalaryCalBench_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger HrmSalaryCalBench_trigger		
	before insert on HrmSalaryCalBench
	for each row
	begin
	select HrmSalaryCalBench_id.nextval into :new.id from dual;
	end ;
	/


create table HrmSalaryCalRate( id integer,
                                 benchid integer,
                                 timescope integer,
                                 condition varchar2(500),
                                 formular varchar2(500))
/
create sequence  HrmSalaryCalRate_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger HrmSalaryCalRate_trigger		
	before insert on HrmSalaryCalRate
	for each row
	begin
	select HrmSalaryCalRate_id.nextval into :new.id from dual;
	end ;
	/


create table HrmSalaryCalScope(itemid integer,
                                 benchid integer,
                                 objectid integer)
/



INSERT INTO HtmlLabelIndex values(19530,'分别计算')
/
INSERT INTO HtmlLabelIndex values(19529,'按百分比计算')
/
INSERT INTO HtmlLabelInfo VALUES(19529,'按百分比计算',7)
/
INSERT INTO HtmlLabelInfo VALUES(19529,'calculate by percent',8)
/
INSERT INTO HtmlLabelInfo VALUES(19530,'分别计算',7)
/
INSERT INTO HtmlLabelInfo VALUES(19530,'calculate seperately',8)
/
INSERT INTO HtmlLabelIndex values(19531,'直接修改工资单')
/
INSERT INTO HtmlLabelInfo VALUES(19531,'直接修改工资单',7)
/
INSERT INTO HtmlLabelInfo VALUES(19531,'directly modify salary bill',8)
/
INSERT INTO HtmlLabelIndex values(19545,'当前页面数据将会丢失')
/
INSERT INTO HtmlLabelInfo VALUES(19545,'当前页面数据将会丢失，是否继续？',7)
/
INSERT INTO HtmlLabelInfo VALUES(19545,'the data of current page will lost,be sure?',8)
/


 delete from HrmSalaryItem  where (itemtype>1  and itemtype<5) or itemtype=8
 /
 delete from HrmSalaryWelfarerate
 /
 delete from HrmSalaryTaxscope
 /
 delete from HrmSalaryTaxrate
 /
 delete from HrmSalaryTaxbench
 /

alter table HrmSalaryCalrate add   conditiondsp varchar2(500)
/
alter table HrmSalaryCalrate add   formulardsp varchar2(500)
/
alter table HrmSalarypaydetail add   condition varchar2(500)
/
alter table HrmSalarypaydetail add   formular varchar2(500)
/
alter table HrmSalarypaydetail add   conditiondsp varchar2(500)
/
alter table HrmSalarypaydetail add   formulardsp varchar2(500)
/



create or replace PROCEDURE HrmSalaryItem_Update (
id_1 	integer, 
itemname_2 	varchar2, 
itemcode_3 	varchar2, 
itemtype_4 	char, 
personwelfarerate_5 	integer, 
companywelfarerate_6 	integer, 
taxrelateitem_7 	integer, 
amountecp_8 	varchar2, 
feetype_9 	integer, 
isshow_10 	char, 
showorder_11 	integer, 
ishistory_12 	char , 
applyscope_13 	integer ,
calMode_14 integer, 
directModify_15 integer,
personalPercent_16 float,
companyPercent_17 float, 
flag   out       integer, 
msg   out        varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS

        olditemtype_1 char;
        benchid_1 integer;
begin
select itemtype into olditemtype_1  from HrmSalaryItem where id = id_1;
UPDATE HrmSalaryItem SET  itemname	 = itemname_2, itemcode	 = itemcode_3, itemtype	 = itemtype_4, personwelfarerate	 = personwelfarerate_5, companywelfarerate	 = companywelfarerate_6, taxrelateitem	 = taxrelateitem_7, amountecp	 = amountecp_8, feetype	 = feetype_9, isshow	 = isshow_10, showorder	 = showorder_11, ishistory	 = ishistory_12,applyscope=applyscope_13,calMode=calMode_14,directModify=directModify_15,personalPercent=personalPercent_16,companyPercent=companyPercent_17  WHERE ( id	 = id_1);
if olditemtype_1 = '1' then
delete from HrmSalaryRank where itemid = id_1;
delete from HrmSalaryResourcePay where itemid = id_1;
delete from HrmSalaryTaxscope where itemid = id_1;
end if;
 if olditemtype_1 = '2' then
delete from HrmSalaryRank where itemid = id_1;
delete from HrmSalaryWelfarerate where itemid = id_1;
delete from HrmSalaryResourcePay where itemid = id_1;
end if;
if olditemtype_1 = '5' or olditemtype_1 = '6' then
delete from HrmSalarySchedule where itemid = id_1;
end if;
 if olditemtype_1 = '7' then
delete from HrmSalaryShiftPay where itemid = id_1;
end if;
 if  olditemtype_1 = '8' then
delete from HrmSalaryResourcePay where itemid = id_1;
end if;
 if olditemtype_1 = '3' then

for all_cursor in(select id from HrmSalaryTaxbench where itemid = id_1)
loop
	benchid_1 := all_cursor.id ;

delete from HrmSalaryTaxrate where benchid = benchid_1;
delete from HrmSalaryTaxbench where id = benchid_1;
end loop;
end if;

 if olditemtype_1 = '4' or olditemtype_1 = '9' then
for all_cursor in(select id from HrmSalaryCalBench where itemid = id_1)
loop
	benchid_1 := all_cursor.id ;

delete from HrmSalaryCalRate where benchid = benchid_1;
delete from HrmSalaryCalBench where id = benchid_1;
end loop;
end if;

end;
/


create or replace PROCEDURE HrmSalaryItem_Insert
	(itemname_1 	varchar2,
	 itemcode_2 	varchar2,
	 itemtype_3 	char,
	 personwelfarerate_4 	integer,
	 companywelfarerate_5 	integer,
	 taxrelateitem_6 	integer,
	 amountecp_7 	varchar2,
	 feetype_8 	integer,
	 isshow_9 	char,
	 showorder_10 	integer,
	 ishistory_11 	char,
	 subcompanyid_12 integer,
	 applyscope_13 integer,
	 calMode_14 	integer,
	 directModify_15  integer,
	 personalPercent_16 float,
	 companyPercent_17 float,
     flag   out    integer,
     msg    out    varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO HrmSalaryItem
	 (itemname,
	 itemcode,
	 itemtype,
	 personwelfarerate,
	 companywelfarerate,
	 taxrelateitem,
	 amountecp,
	 feetype,
	 isshow,
	 showorder,
	 ishistory,
	 subcompanyid,
	 applyscope,
	 calMode,
	 directModify,
	 personalPercent,
	 companyPercent)

VALUES
	( itemname_1,
	 itemcode_2,
	 itemtype_3,
	 personwelfarerate_4,
	 companywelfarerate_5,
	 taxrelateitem_6,
	 amountecp_7,
	 feetype_8,
	 isshow_9,
	 showorder_10,
	 ishistory_11,
	 subcompanyid_12,
	 applyscope_13,
	 calMode_14,
	 directModify_15,
	 personalPercent_16,
	 companyPercent_17
	 );
open thecursor for
select max(id) from HrmSalaryItem;
end;

/


create or replace PROCEDURE HrmSalaryItem_Delete 
(id_1 	integer , 
 flag    out      integer, 
 msg     out      varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
         olditemtype_1 char;
         benchid_1 integer;
begin
 select  itemtype into olditemtype_1  from HrmSalaryItem where id = id_1;
 DELETE HrmSalaryItem WHERE  id	 = id_1;
 if olditemtype_1 = '1' then
 delete from HrmSalaryRank where itemid = id_1;
 delete from HrmSalaryResourcePay where itemid = id_1;
 delete from HrmSalaryTaxscope where itemid = id_1;
end if;
  if olditemtype_1 = '5' or olditemtype_1 = '6' then
 delete from HrmSalarySchedule where itemid = id_1;
 end if;

  if olditemtype_1 = '7' then
 delete from HrmSalaryShiftPay where itemid = id_1;
 end if;
  if olditemtype_1 = '8' then
 delete from HrmSalaryResourcePay where itemid = id_1;
 end if;
  if olditemtype_1 = '2' then
 
 delete from HrmSalaryRank where itemid = id_1;
 delete from HrmSalaryWelfarerate where itemid = id_1;
 delete from HrmSalaryResourcePay where itemid = id_1;
 end if;

  if olditemtype_1 = '3' then

 delete from HrmSalaryTaxscope where itemid=id_1;

for all_cursor in(select id from HrmSalaryTaxbench where itemid = id_1)
loop
	benchid_1 := all_cursor.id ;

 delete from HrmSalaryTaxrate where benchid = benchid_1;
 delete from HrmSalaryTaxbench where id = benchid_1;
end loop;
end if;

 if olditemtype_1 = '4' or olditemtype_1 = '9' then

for all_cursor in(select id from HrmSalaryCalBench where itemid = id_1)
loop
	benchid_1 := all_cursor.id ;

delete from HrmSalaryCalRate where benchid = benchid_1;
delete from HrmSalaryCalBench where id = benchid_1;
end loop;
end if;
end;
/


create or replace PROCEDURE HrmSalaryCalRate_Insert
	(benchid_1 	integer,
	 timescope_2 	integer,
	 condition_3 	varchar2,
	 formular_4 	varchar2,
	 conditiondsp_5 	varchar2,
	 formulardsp_6 	varchar2,
     flag  out         integer,
     msg  out         varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO HrmSalaryCalrate
	 ( benchid,
	 timescope,
	 condition,
	 formular,
	 conditiondsp,
	 formulardsp
	 )

VALUES
	( benchid_1,
	 timescope_2,
	 condition_3,
	 formular_4,
	 conditiondsp_5,
	 formulardsp_6);
end;

/

CREATE PROCEDURE HrmSalaryCalBench_Insert
	(itemid_1 	integer,
	 scopetype_2 	integer,
     flag    out      integer,
     msg     out     varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO HrmSalaryCalBench
	 ( itemid,
	 scopetype)

VALUES
	( itemid_1,
	 scopetype_2);
open thecursor for
select max(id) from HrmSalaryCalBench;
end;

/