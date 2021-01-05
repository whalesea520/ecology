CREATE or REPLACE procedure crmshareinfo_mutidel
as
crmid_1 integer;
userid_1 integer;
usertype_1 integer;
sharelevel_1 integer;

begin

for all_cursor in
(SELECT crmid, userid , usertype 
FROM CrmShareDetail 
GROUP BY crmid, userid , usertype  
HAVING (COUNT(crmid) > 1) )

loop
    crmid_1 := all_cursor.crmid ;
    userid_1 := all_cursor.userid ;
    usertype_1 := all_cursor.usertype ;

    select max(sharelevel) into sharelevel_1 from CrmShareDetail  
    where crmid = crmid_1 and  userid = userid_1 and usertype = usertype_1  ;

    delete CrmShareDetail where crmid = crmid_1 and  userid = userid_1 and usertype = usertype_1 ;

    insert into CrmShareDetail (crmid,userid,usertype,sharelevel) 
	values (crmid_1 , userid_1 , usertype_1 , sharelevel_1 );    
end loop;
end;
/

call crmshareinfo_mutidel()
/

drop procedure crmshareinfo_mutidel
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Update 
 (
 id_1 		integer,
 name_1 		varchar2,
 language_1 	integer,
 engname_1 	varchar2,
 address1_1 	varchar2, 
 address2_1 	varchar2,
 address3_1 	varchar2, 
 zipcode_1 	varchar2, 
 city_1	 	integer,
 country_1 	integer, 
 province_1 	integer, 
 county_1 	varchar2, 
 phone_1 	varchar2,
 fax_1	 	varchar2,
 email_1 	varchar2, 
 website_1 	varchar2,
 source_1 	integer,
 sector_1 	integer,
 size_n_1	 	integer, 
 manager_1 	integer, 
 agent_1 	integer,
 parentid_1 	integer,
 department_1 	integer,
 subcompanyid1_1 	integer,
 fincode_1 	integer, 
 currency_1 	integer,
 contractlevel_1	integer,
 creditlevel_1 	integer,
 creditoffset_1 	varchar2, 
 discount_1 	decimal, 
 taxnumber_1 	varchar2, 
 bankacount_1 	varchar2,
 invoiceacount_1 integer, 
 deliverytype_1 	integer,
 paymentterm_1 	integer,
 paymentway_1 	integer,
 saleconfirm_1 	integer,
 creditcard_1 	varchar2,
 creditexpire_1 	varchar2, 
 documentid_1 	integer,
 seclevel_1 	integer,
 picid_1 	integer,
 type_1	 	integer,
 typebegin_1 	varchar2,
 description_1 	integer,
 status_1 	integer, 
 rating_1 	integer, 
 introductionDocid_1 integer, 
 CreditAmount_1 number ,
 CreditTime_1 integer,
 datefield1_1 	varchar2,
 datefield2_1 	varchar2,
 datefield3_1 	varchar2, 
 datefield4_1 	varchar2,
 datefield5_1 	varchar2,
 numberfield1_1 	float,
 numberfield2_1 	float,
 numberfield3_1 	float, 
 numberfield4_1 	float, 
 numberfield5_1 	float, 
 textfield1_1 	varchar2, 
 textfield2_1 	varchar2, 
 textfield3_1 	varchar2,
 textfield4_1 	varchar2,
 textfield5_1 	varchar2, 
 tinyintfield1_1 	smallint, 
 tinyintfield2_1 	smallint,
 tinyintfield3_1 	smallint,
 tinyintfield4_1 	smallint, 
 tinyintfield5_1 	smallint,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerInfo  SET  
 name	 	 = name_1,
 language	 = language_1, 
 engname	 = engname_1,
 address1	 = address1_1,
address2	 = address2_1,
address3	 = address3_1, 
zipcode	 = zipcode_1,
city	 = city_1, 
country	 = country_1,
province	 = province_1,
county	 = county_1,
phone	 = phone_1,
fax	 = fax_1, 
email	 = email_1, 
website	 = website_1,
source	 = source_1,
sector	 = sector_1, 
size_n	 = size_n_1,
manager	 = manager_1,
agent	 = agent_1,
parentid	 = parentid_1,
department	 = department_1, 
subcompanyid1	 = subcompanyid1_1,
fincode	 = fincode_1,
currency	 = currency_1,
contractlevel = contractlevel_1, 
creditlevel	 = creditlevel_1, 
creditoffset	 = to_number(creditoffset_1),
discount	 = discount_1,
taxnumber	 = taxnumber_1,
bankacount	 = bankacount_1,
invoiceacount	 = invoiceacount_1,
deliverytype	 = deliverytype_1, 
paymentterm	 = paymentterm_1,
paymentway	 = paymentway_1,
saleconfirm	 = saleconfirm_1,
creditcard	 = creditcard_1,
creditexpire	 = creditexpire_1,
documentid	 = documentid_1,
seclevel = seclevel_1, 
picid	 = picid_1,
type	 = type_1,
typebegin	 = typebegin_1,
description	 = description_1,
status	 = status_1,
rating	 = rating_1,
datefield1	 = datefield1_1, 
datefield2	 = datefield2_1, 
datefield3	 = datefield3_1,
datefield4	 = datefield4_1,
datefield5	 = datefield5_1,
numberfield1	 = numberfield1_1, 
numberfield2	 = numberfield2_1,
numberfield3	 = numberfield3_1,
numberfield4	 = numberfield4_1, 
numberfield5	 = numberfield5_1, 
textfield1	 = textfield1_1,
textfield2	 = textfield2_1,
textfield3	 = textfield3_1,
textfield4	 = textfield4_1,
textfield5	 = textfield5_1,
tinyintfield1	 = tinyintfield1_1,
tinyintfield2	 = tinyintfield2_1, 
tinyintfield3	 = tinyintfield3_1, 
tinyintfield4	 = tinyintfield4_1, 
tinyintfield5	 = tinyintfield5_1  ,
introductionDocid = introductionDocid_1 , 
CreditAmount = CreditAmount_1 , 
CreditTime = CreditTime_1 
WHERE ( id	 = id_1); 
end;
/