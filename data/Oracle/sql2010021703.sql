Create or replace procedure Crm_ExcelToDB(
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
  status_19 integer,
  crmCode_20 varchar2,
  bankName_21 varchar2,
  accountName_22 varchar2,
  accounts_23 varchar2,
  createdate_24 varchar2,
  flag out integer, 
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)
  as
  maxid integer;
  count_1 integer;
  begin
  insert into Crm_CustomerInfo (name,engname,address1,zipcode,phone,fax,email,country,type,description , size_n,sector,creditamount,credittime,deleted,status,rating,website,source,manager,city,province,language,crmcode,bankName,accountName,accounts,createdate,seclevel) values (name_1,engname_2,address1_3,zipcode_4,phone_5,fax_6,email_7,country_8,type_9,description_10, size_11, sector_12,trunc(creditamount_13),credittime_14,'0',status_19,'1',website_15,'9',manager_18,city_16,province_17,'7',crmCode_20,bankName_21,accountName_22,accounts_23,createdate_24,0);
end;
/
