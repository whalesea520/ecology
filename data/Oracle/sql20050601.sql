INSERT INTO HtmlLabelIndex values(17678,'客户导入')
/
INSERT INTO HtmlLabelInfo VALUES(17678,'客户导入',7)
/
INSERT INTO HtmlLabelInfo VALUES(17678,'Import customer data form Excel',8)
/
INSERT INTO HtmlLabelIndex values(17648,'客户监控')
/
INSERT INTO HtmlLabelInfo VALUES(17648,'客户监控',7)
/
INSERT INTO HtmlLabelInfo VALUES(17648,'customer monitor',8)
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3157,'客户删除','EditCustomer:Delete',101)
/
insert into SystemRights (id,rightdesc,righttype) values (583,'客户删除','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (583,7,'客户删除','客户监控，用来删除客户') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (583,8,'Customer Delete','Customer Monitor to delete') 
/

 CREATE or replace procedure Crm_ExcelToDB (
  name_1 varchar2,
  engname_2 varchar2,
  address1_3 varchar2, 
  zipcode_4 varchar2,
  phone_5 varchar2, 
  fax_6 varchar2,
  email_7 varchar2,
  country_8  varchar2, 
  type_9 integer,
  description_10 integer,
  size_11 integer,
  sector_12 integer,
  creditamount_13 varchar2,
  credittime_14 integer,
  website_15 varchar2, 
  city_16 integer,
  province_17 integer ,
  manager_18 integer, 
  flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor )
  as
  maxid integer;
  begin
	  insert into Crm_CustomerInfo (
		  name,engname,address1,zipcode,phone,fax,email,country,type,description , size_n,sector,creditamount,credittime,deleted,status,rating,website,source,manager,city,province,language) values (name_1,engname_2,address1_3,zipcode_4,phone_5,fax_6,email_7,country_8,type_9,description_10, size_11, sector_12,trunc(creditamount_13),credittime_14,'0','2','1',website_15,'9',manager_18,city_16,province_17,'7'); 
	  select max(id) into maxid from Crm_CustomerInfo;
	  insert into CrmShareDetail (crmid,userid,usertype,sharelevel) values(maxid,'1','1','2');
end;
/
