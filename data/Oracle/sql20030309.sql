CREATE TABLE CptCapitalModify (
	id integer NOT NULL ,
	cptid integer NULL ,
	field integer NULL ,
	oldvalue varchar2 (200)  NULL ,
	currentvalue varchar2 (200)  NULL ,
	resourceid integer NULL ,
	modifydate varchar2 (10) NULL 
)
/
create sequence CptCapitalModify_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCapitalModify_Trigger
before insert on CptCapitalModify
for each row
begin
select CptCapitalModify_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CptCapitalModifyField (
	field integer NULL ,
	name varchar2 (100)  NULL
)
/


 CREATE or replace PROCEDURE CptUseLogLend_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	integer,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 costcenterid_12   integer,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO CptUseLog 
	 (capitalid,
	 usedate,
	 usedeptid,
	 useresourceid,
	 usecount,
	 useaddress,
	 userequest,
	 maintaincompany,
	 fee,
	 usestatus,
	 remark) 
 
VALUES 
	(capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '3',
	 remark_11);

Update CptCapital
Set 
departmentid = usedeptid_3,
resourceid   = useresourceid_4,
location	     =  useaddress_6,
stateid = usestatus_10
where id = capitalid_1;
end;
/



CREATE or replace PROCEDURE CptUseLogLoss_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	integer,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 costcenterid_12   integer,
	 sptcount_13	char,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

AS 
num_1 integer;
begin
if sptcount_13<>'1' then
   select capitalnum into num_1 from CptCapital where id = capitalid_1;
   if num_1<usecount_5 then
	open thecursor for
	select -1 from dual; 
	return;
   else
	num_1 := num_1 - usecount_5;
   end if;
end if;

INSERT INTO CptUseLog 
	 (capitalid,
	  usedate,
	  usedeptid ,
	  useresourceid ,
	  usecount ,
	  useaddress ,
	  userequest ,
	  maintaincompany ,
	  fee ,
	  usestatus ,
	  remark ) 
 
VALUES 
	(capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '-7',
	 remark_11);
if sptcount_13='1' then
	Update CptCapital
	Set 
	departmentid=null,
	costcenterid=null,
	resourceid=null,
	stateid = usestatus_10
	where id = capitalid_1;
else 
	Update CptCapital
	Set
	capitalnum = num_1
	where id = capitalid_1;
end if;
open thecursor for
select 1 from dual;
return;
end;
/


CREATE or replace PROCEDURE CptUseLogBack_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	integer,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 costcenterid_12   integer,
	 sptcount_13	char,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

AS 
num_1 integer ;
begin
if sptcount_13<>'1' then
   select capitalnum into num_1 from CptCapital where id = capitalid_1 ;
end if;

INSERT INTO CptUseLog
	 (capitalid ,
	  usedate ,
	  usedeptid ,
	  useresourceid ,
	  usecount ,
	  useaddress ,
	  userequest ,
	  maintaincompany ,
	  fee ,
	  usestatus ,
	  remark ) 
 
VALUES 
	(capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '0',
	 remark_11) ;
if sptcount_13 ='1' then
	Update CptCapital
	Set 
	departmentid=null,
	costcenterid=null,
	resourceid=null,
	stateid = usestatus_10
	where id = capitalid_1 ;
else 
	Update CptCapital
	Set
	capitalnum = num_1 + usecount_5
	where id = capitalid_1 ;
end if;

open thecursor for
select 1 from dual;
return;
end;
/

CREATE or replace PROCEDURE CptUseLogDiscard_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	integer,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 sptcount_12	char,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

AS
num_1 integer ;
begin
if sptcount_12<>'1' then
   select capitalnum into num_1  from CptCapital where id = capitalid_1 ;
   if num_1<usecount_5 then   
	open thecursor for
	select -1 from dual; 
	return;  
   else
	num_1 := num_1 - usecount_5 ;
   end if;
end if;
INSERT INTO CptUseLog
	 (capitalid,
	  usedate,
	  usedeptid ,
	  useresourceid ,
	  usecount ,
	  useaddress ,
	  userequest ,
	  maintaincompany ,
	  fee ,
	  usestatus ,
	  remark ) 
 
VALUES 
	(capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '5',
	 remark_11) ;
if sptcount_12 ='1' then
	Update CptCapital
	Set 
	departmentid = null,
	costcenterid = null,
	resourceid   = null,
	location	     =  null,
	stateid = usestatus_10
	where id = capitalid_1 ;
else 
	Update CptCapital
	Set
	capitalnum = num_1
	where id = capitalid_1 ;
end if ;

open thecursor for
select 1 from dual;
return;
end;
/


CREATE or replace PROCEDURE CptCapitalModify_Insert 
	(capitalid_1 	integer,
	 field_1	integer,
	 oldvalue_1 	varchar2,
	 currentvalue_1 	varchar2,
	 resourceid_1 integer,
	 modifydate_1 char,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO CptCapitalModify
	(
	cptid ,
	field  ,
	oldvalue  ,
	currentvalue  ,
	resourceid ,
	modifydate )
VALUES 
	(capitalid_1,
	 field_1,
	 oldvalue_1,
	 currentvalue_1,
	 resourceid_1,
	 modifydate_1) ;

end;
/




CREATE or replace PROCEDURE CptCapitalModifyField_SAll 
	(
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
select * from CptCapitalModifyField order by field  ;
end;
/

insert into CptCapitalModifyField (field,name) values ('1','名称')
/
insert into CptCapitalModifyField (field,name) values ('2','条形码')
/
insert into CptCapitalModifyField (field,name) values ('3','生效日')
/
insert into CptCapitalModifyField (field,name) values ('4','生效至')
/
insert into CptCapitalModifyField (field,name) values ('5','安全级别')
/
insert into CptCapitalModifyField (field,name) values ('6','使用人')
/
insert into CptCapitalModifyField (field,name) values ('7','币种')
/
insert into CptCapitalModifyField (field,name) values ('8','成本')
/
insert into CptCapitalModifyField (field,name) values ('9','开始价格')
/
insert into CptCapitalModifyField (field,name) values ('10','折旧底价')
/
insert into CptCapitalModifyField (field,name) values ('11','规格型号')
/
insert into CptCapitalModifyField (field,name) values ('12','等级')
/
insert into CptCapitalModifyField (field,name) values ('13','制造厂商')
/
insert into CptCapitalModifyField (field,name) values ('14','出厂日期')
/
insert into CptCapitalModifyField (field,name) values ('15','资产类型')
/
insert into CptCapitalModifyField (field,name) values ('16','资产组')
/
insert into CptCapitalModifyField (field,name) values ('17','计量单位')
/
insert into CptCapitalModifyField (field,name) values ('18','替代')
/
insert into CptCapitalModifyField (field,name) values ('19','版本')
/
insert into CptCapitalModifyField (field,name) values ('20','存放地点')
/
insert into CptCapitalModifyField (field,name) values ('21','备注')
/
insert into CptCapitalModifyField (field,name) values ('22','折旧方法一')
/
insert into CptCapitalModifyField (field,name) values ('23','折旧方法二')
/
insert into CptCapitalModifyField (field,name) values ('24','折旧开始日期')
/
insert into CptCapitalModifyField (field,name) values ('25','折旧结束日期')
/
insert into CptCapitalModifyField (field,name) values ('26','供应商')
/
insert into CptCapitalModifyField (field,name) values ('27','属性')
/

insert into CptCapitalModifyField (field,name) values ('28','date1')
/
insert into CptCapitalModifyField (field,name) values ('29','date2')
/
insert into CptCapitalModifyField (field,name) values ('30','date3')
/
insert into CptCapitalModifyField (field,name) values ('31','date4')
/
insert into CptCapitalModifyField (field,name) values ('32','date5')
/
insert into CptCapitalModifyField (field,name) values ('33','float1')
/
insert into CptCapitalModifyField (field,name) values ('34','float2')
/
insert into CptCapitalModifyField (field,name) values ('35','float3')
/
insert into CptCapitalModifyField (field,name) values ('36','float4')
/
insert into CptCapitalModifyField (field,name) values ('37','float5')
/
insert into CptCapitalModifyField (field,name) values ('38','text1')
/
insert into CptCapitalModifyField (field,name) values ('39','text2')
/
insert into CptCapitalModifyField (field,name) values ('40','text3')
/
insert into CptCapitalModifyField (field,name) values ('41','text4')
/
insert into CptCapitalModifyField (field,name) values ('42','text5')
/
insert into CptCapitalModifyField (field,name) values ('43','boolean1')
/
insert into CptCapitalModifyField (field,name) values ('44','boolean2')
/
insert into CptCapitalModifyField (field,name) values ('45','boolean3')
/
insert into CptCapitalModifyField (field,name) values ('46','boolean4')
/
insert into CptCapitalModifyField (field,name) values ('47','boolean5')
/

insert into CptCapitalModifyField (field,name) values ('48','财务编号')
/
insert into CptCapitalModifyField (field,name) values ('49','报警数量')
/


insert into HtmlLabelIndex (id,indexdesc) values (6055,'资产变更')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6055,'资产变更',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6055,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6056,'原值')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6056,'原值',7)
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6056,'',8)
/
