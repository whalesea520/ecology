/* proc 1 */

create or replace package cursor_define as
	type weavercursor is ref cursor ;
end ;
/

 CREATE or REPLACE PROCEDURE Base_FreeField_Select 
 (tablename_1 	varchar2,
 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
 AS
 begin
 open thecursor for 
 SELECT * FROM Base_FreeField WHERE  tablename	 = tablename_1;
 end;
/

/*2002-9-20 11:30*/
 CREATE or REPLACE PROCEDURE Bill_Approve_SelectByID
 (
	id_1		integer,
	flag out integer  , 
  	msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor
	)
as
begin
 open thecursor for 
	select * from Bill_Approve where id=id_1;
	end;
/


 CREATE or REPLACE PROCEDURE Bill_Discuss_Insert
 (
	billid_1 integer,
	requestid_1  integer,
	resourceid_1 integer,
	accepterid_1 varchar2,
	subject_1    varchar2,
	isend_1      integer,
	projectid_1  integer,
	crmid_1      integer,
	relatedrequestid_1   integer,
	status_1     char,
	flag out integer  , 
  	msg  out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
	)
as
begin 
	insert into bill_Discuss (billid,requestid,resourceid,accepterid,subject,isend,projectid,crmid,relatedrequestid,status)
	values(billid_1,requestid_1,resourceid_1,accepterid_1,subject_1,isend_1,projectid_1,crmid_1,relatedrequestid_1,status_1);
    open thecursor for  
    select max(id) from bill_Discuss;
	end;
/


 CREATE or REPLACE PROCEDURE Bill_Discuss_Update 
 (
	id_1     integer,
	billid_1 integer,
	requestid_1  integer,
	resourceid_1 integer,
	accepterid_1 varchar2,
	subject_1    varchar2,
	isend_1      integer,
	projectid_1  integer,
	crmid_1      integer,
	relatedrequestid_1   integer,
	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	as
	begin
	update bill_Discuss 
	set billid=billid_1,
	    requestid=requestid_1,
	    resourceid=resourceid_1,
	    accepterid=accepterid_1,
	    subject=subject_1,
	    isend=isend_1,
	    projectid=projectid_1,
	    crmid=crmid_1,
	    relatedrequestid=relatedrequestid_1
	where id=id_1;
	end;
/


 CREATE or REPLACE PROCEDURE Bill_ExpenseDetail_Delete 
 (expenseid_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 DELETE Bill_ExpenseDetail  WHERE ( expenseid	 = expenseid_1) ;
 end;
/


 CREATE or REPLACE PROCEDURE Bill_ExpenseDetail_Insert
 (
	expenseid_1		integer,
	relatedate_1		char,
	detailremark_1	varchar2,
	feetypeid_1		integer,
	feesum_1			number,
	accessory_1		integer,
	invoicenum_1		varchar2,
	feerule_1        number,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
	insert into bill_expensedetail 
	(expenseid,relatedate,detailremark,feetypeid,feesum,accessory,invoicenum,feerule)
	values
	(expenseid_1,relatedate_1,detailremark_1,feetypeid_1,feesum_1,accessory_1,invoicenum_1,feerule_1);
end;
/


 CREATE or REPLACE PROCEDURE Bill_ExpenseDetali_SelectByID 
 (id_1 integer,
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
 AS
 begin
 open thecursor for 
 select *  from Bill_ExpenseDetail where expenseid=id_1 ;
 end;
/


 CREATE or REPLACE PROCEDURE Bill_HireResource_SelectByID 
 (
	id_1		integer,
	
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for 
	select * from bill_HireResource where id=id_1;
	end;
/


 CREATE or REPLACE PROCEDURE Bill_HotelBook_SelectByID 
 (
	id_1		integer,

 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
	select * from bill_HotelBook where id=id_1;
	end;
/


 CREATE or REPLACE PROCEDURE Bill_HrmResourceAbsense_SByW 
 (flag out integer  ,
 msg out varchar2,

	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 select distinct workflowid , workflowname from Bill_HrmResourceAbsense;
 end;
/


 CREATE or REPLACE PROCEDURE Bill_HrmResourceAbsense_SByID 
 (id_1 integer,
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 select *  from Bill_HrmResourceAbsense where id=id_1;
 end;
/


 CREATE or REPLACE PROCEDURE Bill_HrmResourceAbsense_UStat 
 (id_1 integer,
 usestatus_1 char ,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 update Bill_HrmResourceAbsense set usestatus = usestatus_1 where id=id_1;
 end;
/


 CREATE or REPLACE PROCEDURE Bill_LeaveJob_SelectByID 
 (
	id_1		integer,

	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
	select * from bill_LeaveJob where id=id_1;
	end;
/


 CREATE or REPLACE PROCEDURE Bill_MailboxApply_SelectByID 
 (
	id_1		integer,

	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
	select * from bill_MailboxApply where id=id_1;
	end;
/


 CREATE or REPLACE PROCEDURE Bill_Meetingroom_SelectByID 
 (
 id_1 integer, 

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 select *  from Bill_Meetingroom where id=id_1;
 end;
/


 CREATE or REPLACE PROCEDURE Bill_NameCard_SelectByID
 (
 	id_1		integer,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
	select * from bill_namecard where id=id_1;
	end;
/


 CREATE or REPLACE PROCEDURE Bill_NameCardinfo_Insert 
 (
	resourceid_1		integer,
	cname_1          varchar2,
	cjobtitle_1      varchar2,
	cdepartment_1    varchar2,
	phone_1          varchar2,
	mobile_1         varchar2,
	email_1          varchar2,
	ename_1          varchar2,
	ejobtitle_1      varchar2,
	edepartment_1    varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
	insert into bill_namecardinfo (resourceid,cname,cjobtitle,cdepartment,phone,mobile,email,ename,ejobtitle,edepartment)
	values(resourceid_1,cname_1,cjobtitle_1,cdepartment_1,phone_1,mobile_1,email_1,ename_1,ejobtitle_1,edepartment_1);
	end;
/


 CREATE or REPLACE PROCEDURE Bill_NameCardinfo_Update 
 (
	resourceid_1		integer,
	cname_1          varchar2,
	cjobtitle_1      varchar2,
	cdepartment_1    varchar2,
	phone_1          varchar2,
	mobile_1         varchar2,
	email_1          varchar2,
	ename_1          varchar2,
	ejobtitle_1      varchar2,
	edepartment_1    varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
	update bill_namecardinfo 
	set cname=cname_1,
	    cjobtitle=cjobtitle_1,
	    cdepartment=cdepartment_1,
	    phone=phone_1,
	    mobile=mobile_1,
	    email=email_1,
	    ename=ename_1,
	    ejobtitle=ejobtitle_1,
	    edepartment=edepartment_1
	where resourceid=resourceid_1;
end;
/

 CREATE or REPLACE PROCEDURE Bill_TotalBudget_SelectByID
 (
	id_1		integer,
	
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
	select * from Bill_TotalBudget where id=id_1; 
end;
/

 CREATE or REPLACE PROCEDURE Bill_workinfo_SelectByID
 (
	id_1		integer,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
	select * from bill_workinfo where id=id_1; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_AddressType_Delete 
 (id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 DELETE CRM_AddressType WHERE ( id=id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_AddressType_Insert 
 (fullname_1 	varchar2,
 description_1 	varchar2, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_AddressType ( fullname, description, candelete) VALUES ( fullname_1, description_1, 'y'); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_AddressType_SelectAll 
 (flag out	integer	,
 msg out	varchar2,	

	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_AddressType ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_AddressType_SelectByID 
 (id_1 	integer,
 flag out	integer	,
 msg out	varchar2,	

	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_AddressType WHERE ( id	 = id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_AddressType_Update 
 (id_1 	integer,
 fullname_1 	varchar2,
 description_1 	varchar, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_AddressType 
 SET  fullname	 = fullname_1, description	 = description_1 WHERE ( id	 = id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactLog_Insert 
 (customerid_1 	integer,
 contacterid_1 	integer,
 resourceid_1 	integer,
 agentid_1 	integer,
 contactway_1 	integer,
 ispassive_1 	smallint,
 subject_1 	varchar2,
 contacttype_1 	integer,
 contactdate_1 	varchar2,
 contacttime_1 	varchar2,
 enddate_1 	varchar2, 
 endtime_1 	varchar2,
 contactinfo_1 	varchar2, 
 documentid_1  	integer,
 submitdate_1 	varchar2,
 submittime_1 	varchar2,
 issublog_1 	smallint,
 parentid_1 	integer, 
 isfinished_1  smallint,
 flag out	integer	,
 msg out	varchar2	,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 INSERT INTO CRM_ContactLog ( 
 customerid, 
 contacterid,
 resourceid,
 agentid, 
 contactway,
 ispassive,
 subject, 
 contacttype,
 contactdate,
 contacttime, 
 enddate,
 endtime, 
 contactinfo, 
 documentid,
 submitdate, 
 submittime,
 issublog, 
 parentid, 
 isfinished, 
 isprocessed, 
 processdate,
 processtime)  
 VALUES (
 customerid_1,
 contacterid_1, 
 resourceid_1,
 agentid_1, 
 contactway_1, 
 ispassive_1, 
 subject_1,
 contacttype_1,
 contactdate_1,
 contacttime_1,
 enddate_1, 
 endtime_1,
 contactinfo_1,
 documentid_1,
 submitdate_1,
 submittime_1,
 issublog_1,
 parentid_1,
 isfinished_1,
 0,
 '',
 '');
 open thecursor for
 SELECT id FROM (select id from CRM_ContactLog ORDER BY id DESC) where rownum=1;
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactLog_InsertID 
 (flag out	integer,
 msg out	varchar2,	

	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT id FROM (select id from CRM_ContactLog ORDER BY id DESC) where rownum=1;
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactLog_Process 
 (id_1 	integer,
 processdate_1 	varchar2,
 processtime_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_ContactLog  
 SET
 isprocessed	 = 1, processdate	 = processdate_1, processtime	 = processtime_1
 WHERE ( id	 = id_1);
 end; 
/

 CREATE or REPLACE PROCEDURE CRM_ContactLog_S_Plan_byAgent 
 (userid_1 	integer,
	
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT id,subject,customerid,contacterid,contactdate,contacttime from CRM_ContactLog
 WHERE (agentid = userid_1) and (isfinished = 0)
 ORDER BY contactdate ASC, contacttime ASC ;     
 end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactLog_Select 
 (id_1 		integer,
 issub		smallint,
 parent	integer,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * from CRM_ContactLog WHERE (customerid = id_1) AND (issublog = issub) AND (parentid = parent) ORDER BY contactdate DESC, contacttime DESC ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactLog_SelectByID 
 (id_1 		integer,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * from CRM_ContactLog WHERE (id = id_1);
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactLog_Select_Plan 
 (resourceid_1 	integer,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT id,subject,customerid,contacterid,contactdate,contacttime from CRM_ContactLog WHERE (resourceid = resourceid_1) and (isfinished = 0)  ORDER BY contactdate ASC, contacttime ASC ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_ContactLog_Update 
 (id_1 	integer,
 contacterid_1 	integer, 
 resourceid_1 	integer,
 agentid_1 	integer,
 contactway_1 	integer,
 ispassive_1 	smallint,
 subject_1 	varchar2,
 contacttype_1 	integer,
 contactdate_1 	varchar2,
 contacttime_1 	varchar2,
 enddate_1 	varchar2,
 endtime_1 	varchar2,
 contactinfo_1 	varchar2,
 documentid_1 	integer, 
 isfinished_1 smallint,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_ContactLog  SET
 contacterid	 = contacterid_1,
 resourceid	 = resourceid_1,
 agentid	 = agentid_1,
 contactway	 = contactway_1,
 ispassive	 = ispassive_1,
 subject	 = subject_1,
 contacttype	 = contacttype_1,
 contactdate	 = contactdate_1,
 contacttime	 = contacttime_1,
 enddate	 = enddate_1,
 endtime	 = endtime_1,
 contactinfo	 = contactinfo_1,
 documentid	 = documentid_1,
 isfinished	 = isfinished_1 
 WHERE ( id	 = id_1) ;
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactWay_Delete 
 (id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 DELETE CRM_ContactWay WHERE ( id	 = id_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactWay_Insert 
 (fullname_1 	varchar2,
 description_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_ContactWay ( fullname, description) VALUES ( fullname_1, description_1);
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactWay_SelectAll 
 ( flag out	integer	,
 msg out	varchar2,	

	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_ContactWay; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactWay_SelectByID 
 (id_1 	integer,
 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_ContactWay WHERE ( id	 = id_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContactWay_Update 
 (id_1 	integer,
fullname_1 varchar2,
description_1 varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_ContactWay SET  fullname	 = fullname_1, description	 = description_1 WHERE ( id	 = id_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContacterTitle_Delete 
 (id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 DELETE CRM_ContacterTitle WHERE ( id	 = id_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_ContacterTitle_Insert 
 (fullname_1 	varchar2,
 description_1 	varchar2,
 usetype_1 	char,
 language_1 	integer,
 abbrev_1 	varchar2, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_ContacterTitle ( fullname, description, usetype, language, abbrev) VALUES ( fullname_1, description_1, usetype_1, language_1, abbrev_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_ContacterTitle_SelectAll 
 (

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_ContacterTitle ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_ContacterTitle_SelectByID 
 (id_1	integer,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for 
 SELECT * FROM CRM_ContacterTitle WHERE ( id	 = id_1) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_ContacterTitle_Update 
 (id_1 	integer,
 fullname_1 	varchar2,
 description_1 	varchar2,
 usetype_1 	char,
 language_1 	integer,
 abbrev_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_ContacterTitle SET  fullname	 = fullname_1, description	 = description_1, usetype	 = usetype_1, language	 = language_1, abbrev	 = abbrev_1 WHERE ( id	 = id_1) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CreditInfo_Delete 
 (id1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 DELETE CRM_CreditInfo WHERE ( id	 = id1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CreditInfo_Insert 
 (fullname_1 	varchar2,
 creditamount_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS 
 begin
 INSERT INTO CRM_CreditInfo ( fullname, creditamount) VALUES ( fullname_1, to_number(creditamount_1)); 
end;
/    

 CREATE or REPLACE PROCEDURE CRM_CreditInfo_SelectAll 
 (	
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_CreditInfo ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CreditInfo_SelectByID 
 (id_1 	integer,
	
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_CreditInfo WHERE ( id	 = id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CreditInfo_Update 
 (id1 	integer, 
 fullname1 	varchar2,
 creditamount1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)    
 AS
 begin
 UPDATE CRM_CreditInfo SET  fullname	 = fullname1, creditamount	 = to_number(creditamount1 ) WHERE ( id	 = id1);
end;
/     



 CREATE or REPLACE PROCEDURE CRM_CustomerAddress_Insert 
 (typeid_1 	integer,
 customerid_1 	integer,
 isequal_1 	smallint,
 address1_1 	varchar2,
 address2_1 	varchar2,
 address3_1 	varchar2,
 zipcode_1 	varchar2,
 city_1 	integer,
 country_1 	integer, 
 province_1 	integer, 
 county_1 	varchar2,
 phone_1 	varchar2,
 fax_1 	varchar2,
 email_1 	varchar2,
 contacter_1 	integer,
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
 INSERT INTO CRM_CustomerAddress (
 typeid,
 customerid, 
 isequal,
 address1,
 address2, 
 address3, 
 zipcode,
 city,
 country, 
 province,
 county, 
 phone,
 fax,
 email,
 contacter, 
 datefield1,
 datefield2,
 datefield3,
 datefield4,
 datefield5,
 numberfield1,
 numberfield2,
 numberfield3, 
 numberfield4,
 numberfield5,
 textfield1,
 textfield2, 
 textfield3,
 textfield4,
 textfield5,
 tinyintfield1, 
 tinyintfield2, 
 tinyintfield3,
 tinyintfield4, 
 tinyintfield5
 )
 VALUES (
 typeid_1,
 customerid_1, 
 isequal_1, 
 address1_1,
 address2_1,
 address3_1,
 zipcode_1,
 city_1,
 country_1,
 province_1,
 county_1, 
 phone_1, 
 fax_1,
 email_1,
 contacter_1,
 datefield1_1,
 datefield2_1,
 datefield3_1,
 datefield4_1, 
 datefield5_1, 
 numberfield1_1,
 numberfield2_1,
 numberfield3_1,
 numberfield4_1,
 numberfield5_1, 
 textfield1_1, 
 textfield2_1,
 textfield3_1,
 textfield4_1, 
 textfield5_1,
 tinyintfield1_1, 
 tinyintfield2_1, 
 tinyintfield3_1,
 tinyintfield4_1, 
 tinyintfield5_1
 );
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerAddress_Select 
 (tid_1 	integer,
 cid_1 	integer,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_CustomerAddress WHERE (typeid = tid_1) AND (customerid = cid_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerAddress_UEqual 
 (typeid_1 	integer, 
 customerid_2 	integer,
 isequal_3 	smallint,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerAddress  SET  isequal	 = isequal_3  WHERE ( typeid	 = typeid_1 AND customerid	 = customerid_2); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerAddress_Update 
 (typeid_1 	integer,
 customerid_2 	integer,
 isequal_3 	smallint, 
 address1_4 	varchar2,
 address2_5 	varchar2,
 address3_6 	varchar2,
 zipcode_7 	varchar2,
 city_8 	integer,
 country_9 	integer,
 province_10 	integer,
 county_11 	varchar2,
 phone_12 	varchar2,
 fax_13 	varchar2,
 email_14 	varchar2,
 contacter_15 	integer, 
 datefield1_16 	varchar2,
 datefield2_17 	varchar2,
 datefield3_18 	varchar2,
 datefield4_19 	varchar2,
 datefield5_20 	varchar2,
 numberfield1_21 	float,
 numberfield2_22 	float, 
 numberfield3_23 	float,
 numberfield4_24 	float, 
 numberfield5_25 	float,
 textfield1_26 	varchar2, 
 textfield2_27 	varchar2,
 textfield3_28 	varchar2,
 textfield4_29 	varchar2,
 textfield5_30 	varchar2,
 tinyintfield1_31 	smallint,
 tinyintfield2_32 	smallint,
 tinyintfield3_33 	smallint,
 tinyintfield4_34 	smallint,
 tinyintfield5_35 	smallint,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
begin
 UPDATE CRM_CustomerAddress  SET  
 isequal	 = isequal_3,
 address1	 = address1_4,
 address2	 = address2_5,
 address3	 = address3_6, 
 zipcode	 = zipcode_7,
 city	 = city_8, 
 country	 = country_9,
 province	 = province_10,
 county	 = county_11,
 phone	 = phone_12,
 fax	 = fax_13,
 email	 = email_14,
 contacter	 = contacter_15, 
 datefield1	 = datefield1_16, 
 datefield2	 = datefield2_17,
 datefield3	 = datefield3_18,
 datefield4	 = datefield4_19,
 datefield5	 = datefield5_20, 
 numberfield1	 = numberfield1_21, 
 numberfield2	 = numberfield2_22,
 numberfield3	 = numberfield3_23, 
 numberfield4	 = numberfield4_24, 
 numberfield5	 = numberfield5_25,
 textfield1	 = textfield1_26,
 textfield2	 = textfield2_27,
 textfield3	 = textfield3_28,
 textfield4	 = textfield4_29, 
 textfield5	 = textfield5_30, 
 tinyintfield1	 = tinyintfield1_31, 
 tinyintfield2	 = tinyintfield2_32,
 tinyintfield3	 = tinyintfield3_33,
 tinyintfield4	 = tinyintfield4_34,
 tinyintfield5	 = tinyintfield5_35
 WHERE ( typeid	 = typeid_1 AND customerid	 = customerid_2); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerContacter_Delete 
 (id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 DELETE CRM_CustomerContacter  WHERE ( id	 = id_1);
 end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerContacter_Insert 
 (customerid_1 	integer,
 title_2 	integer,
 fullname_3 	varchar2,
 lastname_4 	varchar2,
 firstname_5 	varchar2,
 jobtitle_6 	varchar2,
 email_7 	varchar2,
 phoneoffice_8 	varchar2,
 phonehome_9 	varchar2,
 mobilephone_10 	varchar2,
 fax_11 	varchar2,
 language_12 	integer,
 manager_13 	integer,
 main_14 	smallint,
 picid_15 	integer,
 datefield1_16 	varchar2,
 datefield2_17 	varchar2,
 datefield3_18 	varchar2,
 datefield4_19 	varchar2,
 datefield5_20 	varchar2,
 numberfield1_21 	float, 
 numberfield2_22 	float, 
 numberfield3_23 	float,
 numberfield4_24 	float,
 numberfield5_25 	float,
 textfield1_26 	varchar2, 
 textfield2_27 	varchar2,
 textfield3_28 	varchar2,
 textfield4_29 	varchar2,
 textfield5_30 	varchar2,
 tinyintfield1_31 	smallint,
 tinyintfield2_32 	smallint,
 tinyintfield3_33 	smallint,
 tinyintfield4_34 	smallint,
 tinyintfield5_35 	smallint,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_CustomerContacter (
 customerid,
 title,
 fullname,
 lastname,
 firstname,
 jobtitle, 
 email,
 phoneoffice,
 phonehome,
 mobilephone, 
 fax,
 language,
 manager,
 main, 
 picid, 
 datefield1,
 datefield2,
 datefield3,
 datefield4,
 datefield5,
 numberfield1, 
 numberfield2,
 numberfield3, 
 numberfield4,
 numberfield5, 
 textfield1, 
 textfield2,
 textfield3,
 textfield4,
 textfield5,
 tinyintfield1,
 tinyintfield2,
 tinyintfield3,
 tinyintfield4,
 tinyintfield5)
 VALUES (
 customerid_1,
 title_2, 
 fullname_3,
 lastname_4,
 firstname_5,
 jobtitle_6,
 email_7, 
 phoneoffice_8, 
 phonehome_9, 
 mobilephone_10,
 fax_11, 
 language_12,
 manager_13,
 main_14, 
 picid_15,
 datefield1_16,
 datefield2_17,
 datefield3_18, 
 datefield4_19,
 datefield5_20, 
 numberfield1_21,
 numberfield2_22,
 numberfield3_23,
 numberfield4_24,
 numberfield5_25,
 textfield1_26,
 textfield2_27,
 textfield3_28,
 textfield4_29, 
 textfield5_30,
 tinyintfield1_31,
 tinyintfield2_32,
 tinyintfield3_33,
 tinyintfield4_34,
 tinyintfield5_35) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerContacter_SAll 
 ( flag out integer, msg out varchar2,

	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_CustomerContacter  ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerContacter_SByID 
 (id_1 	integer, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_CustomerContacter WHERE ( id	 = id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerContacter_SMain 
 (id_1 	integer,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_CustomerContacter WHERE ( customerid	 = id_1) AND (main = 1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerContacter_UMain 
 (id_1	 	integer,
 main_1	  smallint,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS
	begin
	UPDATE CRM_CustomerContacter  SET	 main	 = main_1  WHERE ( id	 = id_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerContacter_Update 
 (id_1 	integer,
 title_3 	integer,
 fullname_4 	varchar2,
 lastname_5 	varchar2,
 firstname_6 	varchar2,
 jobtitle_7 	varchar2,
 email_8 	varchar2,
 phoneoffice_9 	varchar2,
 phonehome_10 	varchar2,
 mobilephone_11 	varchar2,
 fax_12 	varchar2,
 language_13 	integer,
 manager_14 	integer,
 main_15 	smallint,
 picid_16 	integer,
 datefield1_17 	varchar2,
 datefield2_18 	varchar2,
 datefield3_19 	varchar2,
 datefield4_20 	varchar2,
 datefield5_21 	varchar2,
 numberfield1_22 	float, 
 numberfield2_23 	float,
 numberfield3_24 	float,
 numberfield4_25 	float, 
 numberfield5_26 	float,
 textfield1_27 	varchar2,
 textfield2_28 	varchar2,
 textfield3_29 	varchar2,
 textfield4_30 	varchar2,
 textfield5_31 	varchar2,
 tinyintfield1_32 	smallint,
 tinyintfield2_33 	smallint,
 tinyintfield3_34  smallint, 
 tinyintfield4_35  smallint,
 tinyintfield5_36  smallint,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerContacter  SET	
 title	 = title_3,
 fullname	 = fullname_4,
 lastname	 = lastname_5,
 firstname	 = firstname_6, 
 jobtitle	 = jobtitle_7,
 email	 = email_8, 
 phoneoffice	 = phoneoffice_9, 
 phonehome	 = phonehome_10, 
 mobilephone	 = mobilephone_11,
 fax	 = fax_12, 
 language	 = language_13,
 manager	 = manager_14, 
 main	 = main_15,
 picid	 = picid_16,
 datefield1	 = datefield1_17, 
 datefield2	 = datefield2_18, 
 datefield3	 = datefield3_19,
 datefield4	 = datefield4_20,
 datefield5	 = datefield5_21,
 numberfield1	 = numberfield1_22,
 numberfield2	 = numberfield2_23, 
 numberfield3	 = numberfield3_24,
 numberfield4	 = numberfield4_25,
 numberfield5	 = numberfield5_26,
 textfield1	 = textfield1_27,
 textfield2	 = textfield2_28, 
 textfield3	 = textfield3_29,
 textfield4	 = textfield4_30, 
 textfield5	 = textfield5_31, 
 tinyintfield1	 = tinyintfield1_32,
 tinyintfield2	 = tinyintfield2_33, 
 tinyintfield3	 = tinyintfield3_34,
 tinyintfield4	 = tinyintfield4_35, 
 tinyintfield5	 = tinyintfield5_36
 WHERE ( id	 = id_1) ;
 end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerCount_SelectByType 
 (city_1 integer,
  type_1 integer,
 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
  SELECT count(id) as countid FROM CRM_CustomerInfo where city=city_1 and type=type_1;
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerDesc_Delete 
 (id_1 	integer,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 DELETE CRM_CustomerDesc WHERE ( id	 = id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerDesc_Insert 
 (fullname_1 	varchar2,
 description_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_CustomerDesc ( fullname, description) VALUES ( fullname_1, description_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerDesc_SelectAll 
 (                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerDesc ;
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerDesc_SelectByID 
 (id_1 	integer,                            
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerDesc WHERE ( id	 = id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerDesc_Update 
 (id_1 	integer,
 fullname_1 	varchar2,
 description_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerDesc SET  fullname	 = fullname_1, description	 = description_1 WHERE ( id	 = id_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Approve 
 (id_1 		integer, 
 status_1 	integer,
 rating_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerInfo  SET  	  status	 = status_1, rating	 = rating_1  WHERE ( id	 = id_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Delete 
 (id_1 		integer,
 deleted_1  smallint,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 UPDATE CRM_CustomerInfo  
 SET  	 deleted = deleted_1 WHERE ( id	 = id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Insert 
 (name_1 		varchar2,language_1 	integer,
 engname_1 	varchar2,address1_1 	varchar2,
 address2_1 	varchar2,
 address3_1 	varchar2,
 zipcode_1 	varchar2,
 city_1	 	integer,
 country_1 	integer,
 province_1 	integer,
 county_1	varchar2,
 phone_1 	varchar2,
 fax_1	 	varchar2,
 email_1 	varchar2,
 website_1 	varchar2,
 source_1 	integer,
 sector_1 	integer,
 size_1	 	integer,
 manager_1 	integer,
 agent_1 	integer,
 parentid_1 	integer,
 department_1 	integer,
 subcompanyid1_1 	integer,
 fincode_1	integer,
 currency_1 	integer,
 contractlevel_1	integer,
 creditlevel_1 	integer,
 creditoffset_1 	varchar2, 
 discount_1 	decimal,
 taxnumber_1 	varchar2,
 bankacount_1 	varchar2, 
 invoiceacount_1	integer,
 deliverytype_1 	integer,
 paymentterm_1 	integer,
 paymentway_1 	integer,
 saleconfirm_1 	integer,
 creditcard_1 	varchar2, 
 creditexpire_1 	varchar2,
 documentid_1 	integer,
 seclevel_1 	integer,
 picid_1 	integer,
 type_1 		integer,
 typebegin_1 	varchar2,
 description_1 	integer,
 status_1 	integer,
 rating_1 	integer,
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
 tinyintfield1_1 smallint,
 tinyintfield2_1 smallint,
 tinyintfield3_1 smallint, 
 tinyintfield4_1 smallint,
 tinyintfield5_1 smallint,
 createdate_1 	varchar2,
 flag out integer, msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
 AS
 begin
 INSERT INTO CRM_CustomerInfo ( name, 
 language,
 engname, 
 address1,
 address2, 
 address3, 
 zipcode,
 city,
 country,
 province,
 county,
 phone,
 fax,
 email,
 website,
 source,
 sector,
 size_n,
 manager,
 agent,
 parentid,
 department, 
 subcompanyid1,
 fincode,
 currency,
 contractlevel,
 creditlevel,
 creditoffset, 
 discount,
 taxnumber, 
 bankacount,
 invoiceacount,
 deliverytype,
 paymentterm, 
 paymentway,
 saleconfirm,
 creditcard,
 creditexpire,
 documentid,
 seclevel, 
 picid, 
 type,
 typebegin,
 description,
 status,
 rating, 
 datefield1,
 datefield2,
 datefield3,
 datefield4, 
 datefield5,
 numberfield1,
 numberfield2,
 numberfield3,
 numberfield4,
 numberfield5,
 textfield1, 
 textfield2, 
 textfield3,
 textfield4,
 textfield5,
 tinyintfield1,
 tinyintfield2,
 tinyintfield3,
 tinyintfield4,
 tinyintfield5,
 deleted,
 createdate) 
 VALUES 
 ( name_1, 
 language_1,
 engname_1, 
 address1_1,
 address2_1, 
 address3_1,
 zipcode_1,
 city_1, 
 country_1,
 province_1,
 county_1, 
 phone_1, 
 fax_1, 
 email_1,
 website_1, 
 source_1,
 sector_1, 
 size_1,
 manager_1,
 agent_1, 
 parentid_1, 
 department_1,
 subcompanyid1_1,
 fincode_1,
 currency_1,
 contractlevel_1,
 creditlevel_1,
 to_number(creditoffset_1),
 discount_1, 
 taxnumber_1,
 bankacount_1,
 invoiceacount_1, 
 deliverytype_1,
 paymentterm_1,
 paymentway_1,
 saleconfirm_1,
 creditcard_1,
 creditexpire_1,
 documentid_1,
 seclevel_1,
 picid_1,
 type_1,
 typebegin_1,
 description_1,
 status_1,
 rating_1,
 datefield1_1,
 datefield2_1,
 datefield3_1,
 datefield4_1,
 datefield5_1,
 numberfield1_1,
 numberfield2_1,
 numberfield3_1,
 numberfield4_1,
 numberfield5_1,
 textfield1_1,
 textfield2_1,
 textfield3_1,
 textfield4_1,
 textfield5_1,
 tinyintfield1_1,
 tinyintfield2_1,
 tinyintfield3_1,
 tinyintfield4_1,
 tinyintfield5_1,
 0, 
 createdate_1);
 open thecursor for 
select id from(SELECT  id from CRM_CustomerInfo ORDER BY id DESC) where rownum=1; 
end;
/




 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_InsertID 
 (
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
select id from (SELECT  id from CRM_CustomerInfo ORDER BY id DESC) where rownum=1 ; 
END;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Portal 
(id1 integer,
portalstatus1 integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE CRM_CustomerInfo  SET  	 
portalstatus = portalstatus1 WHERE ( id = id1);
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_PortalPasswor 
(id_1 integer, portalloginid_1 varchar2, portalpassword_1 varchar2,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
AS
begin
UPDATE CRM_CustomerInfo  SET  	 
portalloginid = portalloginid_1 , portalpassword = portalpassword_1  WHERE ( id = id_1);
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_SByLoginID 
 ( 
  portalloginid_1 varchar2,
   
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for  
  select * from CRM_CustomerInfo where portalloginid = portalloginid_1; 
 end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_SSumByManager 
 (
 id_1	integer ,

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 select count(id) from CRM_CustomerInfo where manager = id_1 ;
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_SelectAll 
 (                          
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerInfo ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_SelectByID 
 (id_1 	integer,                              
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerInfo WHERE (id = id_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Update 
 (id_1 	integer,
 name_1	varchar2,
 language_1 	integer,
 engname_1 	varchar2,
 address1_1 	varchar2,
 address2_1 varchar2,
 address3_1 varchar2,
 zipcode_1 	varchar2,
 city_1	 	integer,
 country_1 	integer,
 province_1 integer,
 county_1 varchar2,
 phone_1 varchar2,
 fax_1	 varchar2,
 email_1 varchar2,
 website_1 varchar2,
 source_1 	integer,
 sector_1 	integer,
 size_1	integer,
 manager_1 	integer,
 agent_1 	integer,
 parentid_1 integer,
 department_1 integer,
 subcompanyid1_1 integer,
 fincode_1 	integer,
 currency_1 integer,
 contractlevel_1 integer,
 creditlevel_1 	integer,
 creditoffset_1  varchar2,
 discount_1  decimal,
 taxnumber_1  varchar2,
 bankacount_1  varchar2,
 invoiceacount_1 integer,
 deliverytype_1 integer,
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
 tinyintfield1_1  smallint,
 tinyintfield2_1  smallint, 
 tinyintfield3_1  smallint,
 tinyintfield4_1  smallint,
 tinyintfield5_1  smallint,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerInfo  
 SET
 name = name_1,
 language = language_1,
 engname = engname_1,
 address1 = address1_1,
 address2 = address2_1,
 address3 = address3_1,
 zipcode = zipcode_1,
 city = city_1,
 country = country_1,
 province = province_1,
 county	= county_1,
 phone = phone_1,
 fax = fax_1,
 email = email_1,
 website = website_1,
 source	= source_1,
 sector = sector_1,
 size_n = size_1,
 manager = manager_1,
 agent = agent_1,
 parentid = parentid_1,
 department = department_1,
 subcompanyid1 = subcompanyid1_1,
 fincode = fincode_1,
 currency = currency_1,
 contractlevel = contractlevel_1,
 creditlevel = creditlevel_1,
 creditoffset	= to_number(creditoffset_1),
 discount = discount_1,
 taxnumber = taxnumber_1,
 bankacount = bankacount_1,
 invoiceacount = invoiceacount_1,
 deliverytype = deliverytype_1,
 paymentterm = paymentterm_1,
 paymentway	= paymentway_1,
 saleconfirm = saleconfirm_1,
 creditcard = creditcard_1,
 creditexpire = creditexpire_1,
 documentid	= documentid_1,
 seclevel= seclevel_1,
 picid = picid_1,
 type = type_1,
 typebegin = typebegin_1,
 description = description_1,
 status	= status_1,
 rating = rating_1,
 datefield1 = datefield1_1,
 datefield2 = datefield2_1,
 datefield3 = datefield3_1,
 datefield4 = datefield4_1,
 datefield5 = datefield5_1,
 numberfield1 = numberfield1_1,
 numberfield2 = numberfield2_1,
 numberfield3 = numberfield3_1,
 numberfield4 = numberfield4_1,
 numberfield5 = numberfield5_1,
 textfield1 = textfield1_1,
 textfield2 = textfield2_1,
 textfield3 = textfield3_1,
 textfield4 = textfield4_1,
 textfield5 = textfield5_1,
 tinyintfield1 = tinyintfield1_1,
 tinyintfield2 = tinyintfield2_1,
 tinyintfield3 = tinyintfield3_1,
 tinyintfield4 = tinyintfield4_1,
 tinyintfield5 = tinyintfield5_1
 WHERE ( id = id_1); 
end;
/        


 CREATE or REPLACE PROCEDURE CRM_CustomerRating_Delete 
 (id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 DELETE CRM_CustomerRating WHERE ( id	 = id_1) ;
 end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerRating_Insert 
 (fullname_1 	varchar2,
 description_1 	varchar2,
 workflow11_1 integer,
 workflow12_1 integer,
 workflow21_1 integer,
 workflow22_1 integer,
 workflow31_1 integer,
 workflow32_1 integer,
 canupgrade_1 char,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 INSERT INTO CRM_CustomerRating ( fullname, description, workflow11, workflow12, workflow21, workflow22, workflow31, workflow32, canupgrade) 
 VALUES
 ( fullname_1, description_1, workflow11_1, workflow12_1, workflow21_1, workflow22_1, workflow31_1, workflow32_1, canupgrade_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerRating_SelectAll 
 (flag out integer, msg out varchar2,                             

	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerRating ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerRating_SelectByID 
 (id_1 	integer,                             
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerRating WHERE ( id	 = id_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerRating_Update 
 (id_1 	integer,
 fullname_1 	varchar2,
 description_1 	varchar2,
 workflow11_1 integer,
 workflow12_1 integer,
 workflow21_1 integer,
 workflow22_1 integer,
 workflow31_1 integer,
 workflow32_1 integer,
 canupgrade_1 char, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 UPDATE CRM_CustomerRating SET 
 fullname	 = fullname_1, 
 description	 = description_1,
 workflow11 = workflow11_1,
 workflow12 = workflow12_1,
 workflow21 = workflow21_1,
 workflow22 = workflow22_1,
 workflow31 = workflow31_1,
 workflow32 = workflow32_1,
 canupgrade = canupgrade WHERE ( id	 = id_1);
  end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerSize_Delete 
 (id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 DELETE CRM_CustomerSize WHERE ( id	 = id_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerSize_Insert 
 (fullname_1 	varchar2,
 description_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_CustomerSize ( fullname, description) 
 VALUES ( fullname_1, description_1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerSize_SelectAll 
 (                          
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerSize ;
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerSize_SelectByID 
 (id_1 	int,                         
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerSize WHERE ( id	 = id_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerSize_Update 
 (id_1 	integer,
 fullname_1 	varchar2, 
 description_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 UPDATE CRM_CustomerSize SET  fullname	 = fullname_1, description	 = description_1 WHERE ( id	 = id_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerStatus_Delete 
 (id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 DELETE CRM_CustomerStatus WHERE ( id	 = id_1) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerStatus_Insert 
 (fullname_1 	varchar2,
 description_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_CustomerStatus ( fullname, description) VALUES ( fullname_1, description_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerStatus_SelectAll 
 (                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerStatus ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerStatus_SelectByID 
 (id1 	int,                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerStatus WHERE ( id	 = id1) ; 
end;
/

 CREATE or REPLACE PROCEDURE CRM_CustomerStatus_Update 
 (id_1 	integer,
 fullname_1 	varchar2,
 description_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerStatus
 SET
 fullname	 = fullname_1, 
 description	 = description_1 WHERE ( id	 = id_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerType_Delete 
 (id1 integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 DELETE CRM_CustomerType WHERE ( id = id1) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerType_Insert 
 (fullname_1 varchar2,
 description_1 varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	 
 AS
 begin
 INSERT INTO CRM_CustomerType ( fullname, description) VALUES ( fullname_1, description_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerType_SelectAll 
 (                          
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerType ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerType_SelectByID 
 (id1 integer,                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomerType WHERE ( id = id1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomerType_Update 
 (id1 	integer, 
 fullname1 	varchar2, description1 	varchar2, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerType SET  fullname	 = fullname1, description	 = description1 WHERE ( id	 = id1); 
end;
/



 CREATE or REPLACE PROCEDURE CRM_CustomizeOption_SelectAll 
 (                             
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomizeOption ;
end;
/


 CREATE or REPLACE PROCEDURE CRM_CustomizeOption_SelectByID 
 (id1 	integer,                             
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_CustomizeOption WHERE ( id	 = id1) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_Customize_Insert 
 (userid_1 	integer, logintype  smallint, 
 row1col1_2 	integer,
 row1col2_3 	integer,
 row1col3_4 	integer,
 row1col4_5 	integer,
 row1col5_6 	integer,
 row1col6_7 	integer,
 row2col1_8 	integer,
 row2col2_9 	integer,
 row2col4_10 	integer,
 row2col3_11 	integer,
 row2col5_12 	integer,
 row2col6_13 	integer,
 row3col1_14 	integer,
 row3col2_15 	integer,
 row3col3_16 	integer,
 row3col4_17 	integer,
 row3col5_18 	integer,
 row3col6_19 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_Customize 
 ( userid,
 logintype, row1col1, 
 row1col2, row1col3,
 row1col4, row1col5,
 row1col6, row2col1,
 row2col2, row2col4,
 row2col3, row2col5,
 row2col6, row3col1,
 row3col2, row3col3,
 row3col4, row3col5, row3col6) 
 VALUES
 ( userid_1, logintype, 
 row1col1_2, row1col2_3,
 row1col3_4, row1col4_5, 
 row1col5_6, row1col6_7, 
 row2col1_8, row2col2_9, 
 row2col4_10, row2col3_11, 
 row2col5_12, row2col6_13, 
 row3col1_14, row3col2_15, 
 row3col3_16, row3col4_17,
 row3col5_18, row3col6_19); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_Customize_SelectByUid 
 (uid_1 	integer, logintype1  smallint,                         
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_Customize WHERE ( userid = uid_1 and logintype	 = logintype1) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_Customize_Update 
 (userid_1 	integer, 
 logintype_1  smallint,
 row1col1_2 	integer,
 row1col2_3 	integer,
 row1col3_4 	integer,
 row1col4_5 	integer,
 row1col5_6 	integer,
 row1col6_7 	integer,
 row2col1_8 	integer,
 row2col2_9 	integer,
 row2col4_10 	integer,
 row2col3_11 	integer,
 row2col5_12 	integer,
 row2col6_13 	integer,
 row3col1_14 	integer,
 row3col2_15 	integer,
 row3col3_16 	integer,
 row3col4_17 	integer,
 row3col5_18 	integer,
 row3col6_19 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)   
 AS
 begin
 UPDATE CRM_Customize  SET
 row1col1	 = row1col1_2, 
 row1col2	 = row1col2_3,
 row1col3	 = row1col3_4,
 row1col4	 = row1col4_5, 
 row1col5	 = row1col5_6, row1col6	 = row1col6_7,
 row2col1	 = row2col1_8, row2col2	 = row2col2_9, 
 row2col4	 = row2col4_10, row2col3	 = row2col3_11, 
 row2col5	 = row2col5_12, row2col6	 = row2col6_13, 
 row3col1	 = row3col1_14, row3col2	 = row3col2_15,
 row3col3	 = row3col3_16, row3col4	 = row3col4_17,
 row3col5	 = row3col5_18, row3col6	 = row3col6_19 
 WHERE ( userid	 = userid_1 and logintype	 = logintype_1);
end;
/


 CREATE or REPLACE PROCEDURE CRM_DeliveryType_Delete 
 (id1 	integer,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 DELETE CRM_DeliveryType WHERE ( id	 = id1);
 end;
/

 CREATE or REPLACE PROCEDURE CRM_DeliveryType_Insert 
 (fullname_1 	varchar2,
 description_1 	varchar2,
 sendtype_1 	varchar2, 
 shipment_1 	varchar2,
 receive_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_DeliveryType ( fullname, description, sendtype, shipment, receive)
 VALUES
 ( fullname_1, description_1, sendtype_1, shipment_1, receive_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_DeliveryType_SelectAll 
 (                     
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_DeliveryType ;
end;
/


 CREATE or REPLACE PROCEDURE CRM_DeliveryType_SelectByID 
 (id1	integer,                              
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_DeliveryType WHERE ( id	 = id1) ;
end;
/


 CREATE or REPLACE PROCEDURE CRM_DeliveryType_Update 
 (id1 	integer, fullname1 	varchar2, description1 	varchar2, sendtype1 	varchar2, shipment1 	varchar2, receive1 	varchar2,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 UPDATE CRM_DeliveryType SET  fullname	 = fullname1, description	 = description1, sendtype	 = sendtype1, shipment	 = shipment1, receive	 = receive1 WHERE ( id	 = id1);
end;
/


 CREATE or REPLACE PROCEDURE CRM_Find_Creater 
 (id1 	integer,                     
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT submiter,submitdate,submitertype from CRM_Log WHERE (customerid = id1) and (logtype = 'n'); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_Find_CustomerContacter 
 (id_1	int,                        
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT id,title,fullname,jobtitle FROM CRM_CustomerContacter WHERE (customerid = id_1) ORDER BY main DESC,fullname ASC ;
end;
/


CREATE or replace PROCEDURE CRM_Find_LastModifier 
(id_1	integer, 
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for 
SELECT submiter,submitdate,submitertype from (select submiter,submitdate,submitertype from CRM_Log 
WHERE customerid = id_1 and (not (logtype = 'n')) ORDER BY submitdate DESC) where rownum=1;
end;
/


 CREATE or replace PROCEDURE CRM_Find_RecentRemark 
 (id_1 	integer,
 flag	out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 open thecursor for
 SELECT * from (select * from CRM_Log WHERE (customerid = id_1) ORDER BY submitdate DESC, submittime
 DESC) where rownum<4;
 end;
/


 CREATE or replace PROCEDURE CRM_Info_SelectCountByResource 
(id_1 	integer, 
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select count(*) from CRM_CustomerInfo where manager = id_1;
end;
/


 CREATE or REPLACE PROCEDURE CRM_LedgerInfo_Delete 
 (
 customerid1	integer,
 tradetype1	char, flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 as 
 begin
 delete from CRM_LedgerInfo where customerid=customerid1 and tradetype=tradetype1 ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_LedgerInfo_Insert 
 (
 customerid_1	integer,
 customercode_1	char,
 tradetype_1	char, 
 ledger1_1	integer,
 ledger2_1	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 as
 begin
 insert into CRM_LedgerInfo values(customerid_1,customercode_1,tradetype_1,ledger1_1,ledger2_1); 
end;
/

 CREATE or REPLACE PROCEDURE CRM_LedgerInfo_Select 
 (
 customerid1	integer, tradetype1	char,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 as
 begin
 open thecursor for
 select * from crm_ledgerinfo where customerid=customerid1 and tradetype=tradetype1 ; 
 end;
/


 CREATE or REPLACE PROCEDURE CRM_LedgerInfo_SelectAll
 (
 customerid1	integer, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 as
 begin
 open thecursor for
 select * from crm_ledgerinfo where customerid=customerid1;
end;
/


 CREATE or REPLACE PROCEDURE CRM_LedgerInfo_Update 
 (
 customerid1	integer, customercode1	char, tradetype1	char,
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 as
 begin
 update CRM_LedgerInfo set customercode=customercode1 where customerid=customerid1 and tradetype=tradetype1; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_Log_Insert 
 (customerid_1 	integer,
 logtype_1 	char,
 documentid_1 	integer,
 logcontent_1 	varchar2,
 submitdate_1 	varchar2, 
 submittime_1 	varchar2,
 submiter_1 	integer,
 submitertype_1  smallint,
 clientip_1 	char, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_Log ( customerid, logtype, documentid, logcontent, submitdate, submittime, submiter, submitertype, clientip)
 VALUES ( customerid_1, logtype_1, documentid_1, logcontent_1, submitdate_1, submittime_1, submiter_1, submitertype_1, clientip_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_Log_Select 
 (id_1 	int,                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * from CRM_Log WHERE (customerid = id_1) ORDER BY submitdate DESC, submittime DESC; 
end;
/



 CREATE or REPLACE PROCEDURE CRM_LoginLog_Insert 
 (
 id_1	integer,  
 logindate_1	char,
 logintime_1	char,
 ipaddress_1	char,
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 insert into CRM_loginLog (id, logindate, logintime, ipaddress) values(id_1, logindate_1, logintime_1, ipaddress_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_Modify_Insert 
 (customerid_1 	integer,
 tabledesc_1 	char,
 type_1 		integer,
 addresstype_1 	integer,
 fieldname_1 	varchar2,
 modifydate_1 	varchar2,
 modifytime_1 	varchar2,
 original_1 	varchar2, 
 modified_1 	varchar2,
 modifier_1 	integer,
 submitertype_1  smallint, 
 clientip_1 	char,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_Modify ( customerid, tabledesc, type, addresstype, fieldname, modifydate, modifytime, original, modified, modifier, submitertype, clientip)
 VALUES ( customerid_1, tabledesc_1, type_1, addresstype_1, fieldname_1, modifydate_1, modifytime_1, original_1, modified_1, modifier_1, submitertype_1, clientip_1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_Modify_Select 
 (id_1 	int,                             
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_Modify WHERE ( customerid	 = id_1) ORDER BY modifydate DESC, modifytime DESC ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_PaymentTerm_Delete 
 (id1 	int,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS 
 begin
 DELETE CRM_PaymentTerm WHERE ( id	 = id1) ;
end;
/


 CREATE or REPLACE PROCEDURE CRM_PaymentTerm_Insert 
 (fullname1 	varchar2, description1 	varchar2,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 INSERT INTO CRM_PaymentTerm ( fullname, description) VALUES ( fullname1, description1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_PaymentTerm_SelectAll 
 (                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_PaymentTerm ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_PaymentTerm_SelectByID 
 (id1 	int,                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_PaymentTerm WHERE ( id	 = id1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_PaymentTerm_Update 
 (id1 	integer, fullname1 	varchar2, description1 	varchar2,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 UPDATE CRM_PaymentTerm SET  fullname	 = fullname1, description	 = description1 WHERE ( id	 = id1) ; 
end;
/


CREATE or replace PROCEDURE CRM_RpSum 
(optional_1	varchar2, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
if  optional_1='contactway' then
open thecursor for
select source  resultid,COUNT(id)  resultcount from CRM_Customerinfo
where deleted=0 group by source order by resultcount;
end if;  
if  optional_1='customersize' then
open thecursor for 
select size_n  resultid,COUNT(id)  resultcount from CRM_Customerinfo 
where deleted=0 group by size_n order by resultcount;
end if;  
if  optional_1='customertype' then
open thecursor for 
select type  resultid,COUNT(id)  resultcount from CRM_Customerinfo 
where deleted=0 group by type order by resultcount;
end if;  
if  optional_1='customerdesc' then
open thecursor for 
select description  resultid,COUNT(id)  resultcount from CRM_Customerinfo 
where deleted=0 group by description order by resultcount;
end if;  
if  optional_1='customerstatus' then 
open thecursor for
select status  resultid,COUNT(id)  resultcount 
from CRM_Customerinfo where deleted=0 group by status order by resultcount ;
end if; 
if  optional_1='paymentterm' then 
open thecursor for
select paymentterm  resultid,COUNT(id)  resultcount 
from CRM_Customerinfo where deleted=0 group by paymentterm order by resultcount;
end if;  
if  optional_1='customerrating' then
open thecursor for
select rating  resultid,COUNT(id)  resultcount 
from CRM_Customerinfo where deleted=0 group by rating order by resultcount;
end if;
if  optional_1='creditinfo' then 
open thecursor for
select creditlevel  resultid,COUNT(id)  resultcount 
from CRM_Customerinfo where deleted=0 group by creditlevel order by resultcount;
end if;  
if  optional_1='tradeinfo' then 
open thecursor for
select contractlevel  resultid,COUNT(id)  resultcount 
from CRM_Customerinfo where deleted=0 group by contractlevel order by resultcount;
end if; 
if  optional_1='manager' then 
open thecursor for
select manager  resultid,COUNT(id)  resultcount 
from CRM_Customerinfo where deleted=0 group by manager order by resultcount;
end if;  
if  optional_1='department' then
open thecursor for
select department  resultid,COUNT(id)  resultcount 
from CRM_Customerinfo where deleted=0 group by department order by resultcount;
end if;
end;
/




 CREATE or REPLACE PROCEDURE CRM_SectorInfo_Delete 
 (id_1 	integer,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS 
 begin
 DELETE CRM_SectorInfo WHERE ( id=id_1) ; 
end;
/


 
 CREATE or REPLACE PROCEDURE CRM_SectorInfo_Insert 
 (fullname_1 	varchar2, 
 description_1 	varchar2,
 parentid_1 	integer,
 seclevel_1 	integer,
 sectors_1	varchar2,
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS 
  id_1  integer; 
  id_2  integer; 
  begin
   id_1 := 1;
   id_2 := 0;
    select count(*) INTO id_2  from CRM_SectorInfo;
    if(id_2 > 0) then
        select max(id) INTO id_1  from CRM_SectorInfo ;
        id_1 := id_1+1;
        end if;
  INSERT INTO CRM_SectorInfo (id, fullname, description, parentid, seclevel, sectors)
  VALUES (id_1, fullname_1, description_1, parentid_1, seclevel_1, sectors_1); 
end;
/



 CREATE or REPLACE PROCEDURE CRM_SectorInfo_SelectAll 
 (parentid1	integer, flag out integer,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_SectorInfo WHERE	(parentid = parentid1) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_SectorInfo_SelectAllInfo 
 (                             
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_SectorInfo ; 
end;
/



 CREATE or REPLACE PROCEDURE CRM_SectorInfo_SelectByID 
 (id1 	int,                         
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_SectorInfo WHERE ( id	 = id1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_SectorInfo_Update 
 (id1 	integer, fullname1 	varchar2, description1 	varchar2, 
 parentid1 	integer, seclevel1 	integer, sectors1	varchar2, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_SectorInfo SET  fullname	 = fullname1, description	 = description1, parentid	 = parentid1, seclevel	 = seclevel1, sectors	 = sectors1 WHERE ( id	 = id1); 
end;
/


CREATE or replace PROCEDURE CRM_SectorRpSum
(parentid_1	varchar,
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
tempstr_1 varchar2(30);
tempid_1 integer;
begin
tempstr_1 :='%,'|| parentid_1 ||',%' ;
tempid_1 := cast(parentid_1 as integer);
open thecursor for
select count(id)  from crm_customerinfo 
where sector in(select id from crm_sectorinfo where id=tempid_1 or sectors like tempstr_1);
end;
/

 CREATE or REPLACE PROCEDURE CRM_ShareInfo_Delete 
 (id1 integer, flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
DELETE from CRM_ShareInfo  WHERE ( id = id1); 
end;
/

CREATE or replace PROCEDURE CRM_ShareInfo_Insert 
(relateditemid_1 integer,
sharetype_1 smallint,
seclevel_1  smallint,
rolelevel_1 smallint,
sharelevel_1 smallint,
userid_1 integer,
departmentid_1 integer,
roleid_1 integer,
foralluser_1 smallint,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
INSERT INTO CRM_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid,
departmentid, roleid, foralluser ) VALUES 
( relateditemid_1 , sharetype_1, seclevel_1 , rolelevel_1 , sharelevel_1, userid_1, departmentid_1,
roleid_1, foralluser_1);
end;
/


 CREATE or REPLACE PROCEDURE CRM_ShareInfo_SbyRelateditemid 
 (relateditemid1 integer ,                            
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * from CRM_ShareInfo where ( relateditemid = relateditemid1 ) order by sharetype ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_ShareInfo_SelectbyID 
 (id1 integer ,                        
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * from CRM_ShareInfo where (id = id1 ) ;
end;
/


 CREATE or REPLACE PROCEDURE CRM_TradeInfo_Delete 
 (id1 	integer,flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 DELETE CRM_TradeInfo WHERE ( id	 = id1); 
end;
/

CREATE or replace PROCEDURE CRM_TradeInfo_Insert 
(fullname_1	varchar2,
rangelower_1 	varchar2, 
rangeupper_1 	varchar2,
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as begin insert into CRM_TradeInfo ( fullname, rangelower, rangeupper) 
VALUES ( fullname_1, to_number(rangelower_1), to_number(rangeupper_1));
end;
/


 CREATE or REPLACE PROCEDURE CRM_TradeInfo_SelectAll 
 (                          
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_TradeInfo ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_TradeInfo_SelectByID 
 (id1 	int,                           
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT * FROM CRM_TradeInfo WHERE ( id	 = id1); 
end;
/


 CREATE or REPLACE PROCEDURE CRM_TradeInfo_Update 
 (id_1 	integer, fullname_1 	varchar2, rangelower_1 	varchar2,
 rangeupper_1 	varchar2,
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 UPDATE CRM_TradeInfo SET  fullname	 = fullname_1, rangelower	 = to_number (rangelower_1),
 rangeupper	 = to_number(rangeupper_1) WHERE ( id	 = id_1) ; 
end;
/


 CREATE or REPLACE PROCEDURE CRM_ViewLog1_Insert
 (
 id_1	integer,
 viewer_1	integer,
 submitertype_1  smallint,
 viewdate_1	char,
 viewtime_1	char,
 ipaddress_1	char,
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 insert into CRM_viewLog1 (id, viewer, submitertype, viewdate, viewtime, ipaddress)
 values(id_1, viewer_1, submitertype_1, viewdate_1, viewtime_1, ipaddress_1); 
end;
/


 CREATE or REPLACE PROCEDURE CptAssortmentShare_Insert 
(assortmentid_1 integer,
sharetype_2 smallint,
seclevel_3 smallint,
rolelevel_4 smallint,
sharelevel_5 smallint,
userid_6 integer,
departmentid_7 integer,
roleid_8 integer,
foralluser_9 smallint,
flag out integer , msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)

AS 
begin
INSERT INTO CptAssortmentShare
( assortmentid,
sharetype,
seclevel,
rolelevel,
sharelevel,
userid,
departmentid,
roleid,
foralluser)
VALUES
( assortmentid_1,
sharetype_2,
seclevel_3,
rolelevel_4,
sharelevel_5,
userid_6,
departmentid_7,
roleid_8,
foralluser_9);
 open thecursor for
select max(id)  id from CptAssortmentShare;
end;
/


/*资产类型删除(替代原来的资产类型)*/
CREATE or replace PROCEDURE CptCapitalAssortment_Delete
(id_1 	integer,
flag out integer, 
msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS 
count_1 integer; 
supassortmentid_1 integer;
supassortmentid_count integer;
count_01 integer;
count_02 integer;
begin

select  count(capitalcount) into count_01 from CptCapitalAssortment where id = id_1; 
if(count_01>0)then

select  capitalcount into count_1 from CptCapitalAssortment where id = id_1; 
end if;
    if count_1 <> 0 then
       open thecursor for
       select -1 from dual ;
	return ;
    end if ;

    select  count(subassortmentcount) into count_02  from CptCapitalAssortment where id = id_1;
    if count_02>0 then

    select  subassortmentcount into count_1  from CptCapitalAssortment where id = id_1;
    end if;
    if count_1 <> 0 then
    open thecursor for
	select -1 from dual ;
	return ;
    end if ;
      
	
	select  count(supassortmentid) into supassortmentid_count from CptCapitalAssortment where id= id_1 ;
	if supassortmentid_count >0 then
	 
    select  supassortmentid into supassortmentid_1 from CptCapitalAssortment where id= id_1 ;
    update CptCapitalAssortment set subassortmentcount = subassortmentcount-1 where id=supassortmentid_1 ;
    DELETE CptCapitalAssortment WHERE id = id_1 ; 
	end if;
end;
/
 


/*新增资产类型*/
 CREATE or REPLACE PROCEDURE CptCapitalAssortment_Insert 
  ( assortmentname_1 	varchar2,
    assortmentmark_1	varchar2,
    assortmentremark_1 	varchar2, 
   supassortmentid_1 	integer, 
   supassortmentstr_1 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
    AS 
	count_1 integer ;
	count_01 integer;
	begin

    if supassortmentid_1 <>0  then
     /*上级类型不能有物品*/

	   select  count(capitalcount) INTO count_01  from CptCapitalAssortment      where id = supassortmentid_1 ;
    if count_01>0 then

     select  capitalcount INTO count_1  from CptCapitalAssortment 
     where id = supassortmentid_1 ;
	 end if;
	 end if;

     if count_1 <> 0 then
	  open thecursor for
	 select -1 from dual;
     return;
	 end if; /*上级类型子类型数+1*/


      UPDATE CptCapitalAssortment 
      SET subassortmentcount=subassortmentcount+1 
      WHERE id = supassortmentid_1 ; 
	  
		INSERT INTO
 CptCapitalAssortment
 (assortmentname,assortmentmark, assortmentremark, supassortmentid, supassortmentstr, subassortmentcount, capitalcount )
 VALUES (assortmentname_1, assortmentmark_1,assortmentremark_1, supassortmentid_1, supassortmentstr_1, 0, 0);
	  open thecursor for

select max(id) from CptCapitalAssortment ;
end;
/





/*按id查询资产类型*/
 CREATE or REPLACE PROCEDURE CptCapitalAssortment_SByID 
  (id_1 	integer, 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
   select * from CptCapitalAssortment where id = id_1 ;
end;
/


/*选择没有子类型的资产类型*/
 CREATE or REPLACE PROCEDURE CptCapitalAssortment_SLeaf 
 (
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
  select * from CptCapitalAssortment where subassortmentcount = 0;
end;
/


/*2002-9-17 15:48*/
/*选择资产种类根结点*/
 CREATE or REPLACE PROCEDURE CptCapitalAssortment_SRoot
 ( 
 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for 
  select * from CptCapitalAssortment where supassortmentid = 0;
end;
/


/*资产类型选择上级资产字符串*/
 CREATE or REPLACE PROCEDURE CptCapitalAssortment_SSupAssor 
 (
  id_1 	integer, 
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for  
  select supassortmentstr from  CptCapitalAssortment  where id = id_1;
end;
/


/*查询资产类型*/
 CREATE or REPLACE PROCEDURE CptCapitalAssortment_Select 
 (

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for  
 select * from CptCapitalAssortment order by assortmentname;
end;
/


/*查询所有资产类型*/
 CREATE or REPLACE PROCEDURE CptCapitalAssortment_SelectAll 
  ( 
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for  
   select * from CptCapitalAssortment;
end;
/


 CREATE or REPLACE PROCEDURE CptCapitalAssortment_Update 
  (id_1 	integer,
   assortmentname_3 	varchar2, 
    assortmentmark_1	varchar2,
    assortmentremark_7 	varchar2,
    supassortmentid_8 	integer, 
    supassortmentstr_9 	varchar2, 
   	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
  	AS 
	begin
	UPDATE CptCapitalAssortment  
  	SET assortmentname	 = assortmentname_3,
	assortmentmark = assortmentmark_1,
assortmentremark	 = assortmentremark_7, 
  	supassortmentid	 = supassortmentid_8, 
supassortmentstr	 = supassortmentstr_9
  WHERE ( id	 = id_1);
end;
/


/*资产组删除*/
 CREATE or REPLACE PROCEDURE CptCapitalGroup_Delete 
(id_1 	integer, 
flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
)
 AS

 count_1 integer; 
 begin
select count(*) INTO count_1 from  CptCapitalGroup where parentid = id_1;
if count_1<>0 then

 open thecursor for
select -1 from dual;
return;
end if;

IF count_1=0 then
DELETE CptCapitalGroup 
WHERE ( id = id_1);
end if;
end;
/

/*资产组新增*/
CREATE or replace PROCEDURE CptCapitalGroup_Insert 
(name_1 	varchar2, 
description_1 	varchar2, 
parentid_1 	integer, 
flag	out integer,
msg out varchar2,thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
INSERT INTO CptCapitalGroup ( name,description, parentid) VALUES ( name_1, description_1, parentid_1);
end;
/

/*按照父资产组查询*/
 CREATE or replace PROCEDURE CptCapitalGroup_SelectAll 
(parentid_1	integer,
 flag	out integer, msg out varchar2,thecursor IN OUT cursor_define.weavercursor) 
AS
begin
open thecursor for
SELECT * FROM CptCapitalGroup WHERE (parentid = parentid_1);
end;
/


/*查询所有资产组*/
CREATE or replace PROCEDURE CptCapitalGroup_SelectAllInfo 
( flag	out integer, msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
 as begin open thecursor for select * FROM CptCapitalGroup;
 end;
/

/*按照id查询资产组*/
CREATE or replace PROCEDURE CptCapitalGroup_SelectByID
 (id_1 	integer, flag	out integer, msg out varchar2,thecursor IN OUT cursor_define.weavercursor) 
as begin open thecursor for select * FROM CptCapitalGroup 
WHERE ( id=id_1);
end;
/


/*资产组更新*/
 CREATE or REPLACE PROCEDURE CptCapitalGroup_Update 
 (id_1 	integer, 
name_1 	varchar2,
 description_1 	varchar2,
 parentid_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CptCapitalGroup 
SET  name	 = name_1, 
description	 = description_1,
 parentid	 = parentid_1
 WHERE ( id	 = id_1);
end;
/


/*删除共享信息*/
 CREATE or REPLACE PROCEDURE CptCapitalShareInfo_Delete 
(id_1 integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
DELETE CptCapitalShareInfo

WHERE
( id = id_1);
end;
/


/*新增共享信息*/
 CREATE or REPLACE PROCEDURE CptCapitalShareInfo_Insert 
(relateditemid_1 integer,
sharetype_2 smallint,
seclevel_3 smallint,
rolelevel_4 smallint,
sharelevel_5 smallint,
userid_6 integer,
departmentid_7 integer,
roleid_8 integer,
foralluser_9 smallint,
flag out integer, msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)

AS
begin
INSERT INTO CptCapitalShareInfo
( relateditemid,
sharetype,
seclevel,
rolelevel,
sharelevel,
userid,
departmentid,
roleid,
foralluser)



VALUES
( relateditemid_1,
sharetype_2,
seclevel_3,
rolelevel_4,
sharelevel_5,
userid_6,
departmentid_7,
roleid_8,
foralluser_9);
 open thecursor for
select max(id)  id from CptCapitalShareInfo;
end;
/


/*2002-8-28*/
/*按照相关项查找共享信息*/
 CREATE or REPLACE PROCEDURE CptCapitalShareInfo_SbyRelated 
  (relateditemid_1 integer , 
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for 
  select * from CptCapitalShareInfo where ( relateditemid = relateditemid ) order by sharetype;
end;
/

/*按照id查询共享信息*/
 CREATE or REPLACE PROCEDURE CptCapitalShareInfo_SelectbyID 
  (id1 integer , 
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for 
  select * from CptCapitalShareInfo where (id = id1 );
end;
/


/*资产状态删除*/
 CREATE or REPLACE PROCEDURE CptCapitalState_Delete 
	(id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
DELETE CptCapitalState 

WHERE 
	( id	 = id_1);
end;
/

/*资产状态新增*/
 CREATE or REPLACE PROCEDURE CptCapitalState_Insert 
	( name_2 	varchar2,
	 description_3 	varchar2,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 


AS
begin
INSERT INTO CptCapitalState 
	 ( name,
	 description) 
 
VALUES 
	( name_2,
	 description_3);
end;
/


/*查询所有资产状态*/
 CREATE or REPLACE PROCEDURE CptCapitalState_Select 
(	
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
select * from CptCapitalState;
end;
/


/*按照id查询资产状态*/
 CREATE or REPLACE PROCEDURE CptCapitalState_SelectByID 
 (
	 id_1 varchar2 , 
	
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 select * from CptCapitalState
      where id = to_number ( id_1); 
end;
/


/*资产状态更新*/
CREATE or replace PROCEDURE CptCapitalState_Update
	(id_1 	integer,
	 name_2 	varchar2,
	 description_3 	varchar2,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin update CptCapitalState SET  name=name_2, description=description_3 WHERE ( id=id_1);
end;
/


/*资产类型删除*/
 CREATE or REPLACE PROCEDURE CptCapitalType_Delete 
	(id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
DELETE CptCapitalType 

WHERE 
	( id	 = id_1);
end;
/


/*资产类型新增*/
CREATE or replace PROCEDURE CptCapitalType_Insert
	(name_1 	varchar2,
	 description_2 	varchar2,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin 
insert into CptCapitalType  ( name,description) VALUES ( name_1, description_2);
end;
/


/*查询所有资产类型*/
CREATE or replace PROCEDURE CptCapitalType_Select 
(flag out integer ,msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
as begin open thecursor for select * from CptCapitalType;
end;
/


/*按照id查询资产类型*/
CREATE or replace PROCEDURE CptCapitalType_SelectByID
	 (id_1 varchar2 , 
	 flag out integer , 
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
 as begin open thecursor for select * from CptCapitalType
      where id =to_number(id_1); 
end;
/

/*更新资产类型*/
CREATE or replace PROCEDURE CptCapitalType_Update
	(id_1 	integer,
	 name_2 	varchar2,
	 description_3 	varchar2,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin update CptCapitalType SET  name=name_2,description=description_3 WHERE ( id=id_1);
end;
/

/*修改资产卡片删除*/
CREATE or replace PROCEDURE CptCapital_Delete
(id_1 	integer,flag out integer,msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
AS
begin
update CptCapitalAssortment set capitalcount = capitalcount-1 
where id in (select capitaltypeid from CptCapital where id = id_1 );

DELETE CptCapital WHERE ( id=id_1);
open thecursor for
select max(id) from CptCapital;
end;
/



/*复制当前资产*/
 CREATE or REPLACE PROCEDURE CptCapital_Duplicate 
	(capitalid_1 	integer,
	flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
)

AS
begin
INSERT INTO CptCapital 
(mark,
name,
barcode,
startdate,
enddate,
seclevel,
departmentid,
costcenterid,
resourceid,
crmid,
sptcount,
currencyid ,
capitalcost,
startprice,
depreendprice,
capitalspec,
capitallevel,
manufacturer,
manudate,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
currentnum,
replacecapitalid,
version,
itemid,
remark,
capitalimageid,
depremethod1,
depremethod2,
deprestartdate,
depreenddate,
customerid,
attribute,
stateid,
location,
usedhours,
datefield1,
datefield2,
datefield3,
datefield4,
datefield5,
numberfield1,
numberfield2,
numberfield3,
numberfield4,
numberfield5,
textfield1,
textfield2,
textfield3,
textfield4,
textfield5,
tinyintfield1,
tinyintfield2,
tinyintfield3,
tinyintfield4,
tinyintfield5,
createrid,
createdate,
createtime,
lastmoderid,
lastmoddate,
lastmodtime,
isdata,
datatype,
relatewfid)
select 
mark,
name,
barcode,
startdate,
enddate	,
seclevel,
departmentid,
costcenterid,
resourceid,
crmid,
sptcount,
currencyid ,
capitalcost,
startprice,
depreendprice,
capitalspec,
capitallevel,
manufacturer,
manudate,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
currentnum,
replacecapitalid,
version,
itemid,
remark,
capitalimageid,
depremethod1,
depremethod2,
deprestartdate,
depreenddate,
customerid,
attribute,
stateid,
location,
usedhours,
datefield1,
datefield2,
datefield3,
datefield4,
datefield5,
numberfield1,
numberfield2,
numberfield3,
numberfield4,
numberfield5,
textfield1,
textfield2,
textfield3,
textfield4,
textfield5,
tinyintfield1,
tinyintfield2,
tinyintfield3,
tinyintfield4,
tinyintfield5,
createrid,
createdate,
createtime,
lastmoderid,
lastmoddate,
lastmodtime,
isdata,
datatype,
relatewfid
 from CptCapital
where id = capitalid_1;
 open thecursor for

select max(id)  from CptCapital;
end;
/

CREATE or replace PROCEDURE CptCapital_HandBackSelect
( resourceid_1	integer,
  managerid_1	integer,
  flag out integer , 
  msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select * from CptCapital
where isdata = '2' and resourceid = resourceid_1 and datatype in (select id from CptCapital 
where isdata = '1' and resourceid = managerid_1);
end;
/


/*insert altered at 2002-8-13,新增6个字段*/
/*2002-9-16增加类型数计算*/
/*新增资产*/
CREATE or replace PROCEDURE CptCapital_Insert
	(mark_1		varchar2, 
	 name_2 	varchar2,
	 barcode_3 	varchar2,
	 seclevel_6 	smallint,
         resourceid_1	integer,		
	 sptcount_1	char,
	 currencyid_10 	integer,
	 capitalcost_11 	number,
	 startprice_12 	number,
	 depreendprice_1 number,
	 capitalspec_1		varchar2,			
	 capitallevel_1		varchar2,	
	 manufacturer_1		varchar2,			
	 capitaltypeid_13 	integer,
	 capitalgroupid_14 	integer,
	 unitid_15 	integer,
	 capitalnum_1	decimal,
	 replacecapitalid_17 	integer,
	 version_18 	varchar2,
	 remark_20 	varchar2,
	 capitalimageid_21 	integer,
	 depremethod1_22 	integer,
	 depremethod2_23 	integer,
	 customerid_26 	integer,
	 attribute_27 	smallint,
	 datefield1_30 	char,
	 datefield2_31 	char,
	 datefield3_32 	char,
	 datefield4_33 	char,
	 datefield5_34 	char,
	 numberfield1_35 	float,
	 numberfield2_36 	float,
	 numberfield3_37 	float,
	 numberfield4_38 	float,
	 numberfield5_39 	float,
	 textfield1_40 	varchar2,
	 textfield2_41 	varchar2,
	 textfield3_42 	varchar2,
	 textfield4_43 	varchar2,
	 textfield5_44 	varchar2,
	 tinyintfield1_45 	char,
	 tinyintfield2_46 	char,
	 tinyintfield3_47 	char,
	 tinyintfield4_48 	char,
	 tinyintfield5_49 	char,
	 createrid_50 	integer,
	 createdate_51 	char,
	 createtime_52 	char,
	 lastmoderid_53 	integer,
	 lastmoddate_54 	char,
	 lastmodtime_55 	char,
	 isdata_1	char,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as
thisid_1 integer;
begin insert into CptCapital 
	 ( mark,
	 name,
	 barcode,
	 seclevel,
	 resourceid,
	 sptcount,
	 currencyid,
	 capitalcost,
	 startprice,
	 depreendprice,	
	 capitalspec,		
	 capitallevel,	
	 manufacturer,	
	 capitaltypeid,
	 capitalgroupid,
	 unitid,
	 capitalnum,
	 replacecapitalid,
	 version,
	 remark,
	 capitalimageid,
	 depremethod1,
	 depremethod2,
	 customerid,
	 attribute,
	 datefield1,
	 datefield2,
	 datefield3,
	 datefield4,
	 datefield5,
	 numberfield1,
	 numberfield2,
	 numberfield3,
	 numberfield4,
	 numberfield5,
	 textfield1,
	 textfield2,
	 textfield3,
	 textfield4,
	 textfield5,
	 tinyintfield1,
	 tinyintfield2,
	 tinyintfield3,
	 tinyintfield4,
	 tinyintfield5,
	 createrid,
	 createdate,
	 createtime,
	 lastmoderid,
	 lastmoddate,
	 lastmodtime,
	 isdata)
VALUES 
	(mark_1,
	 name_2,
	 barcode_3,
	 seclevel_6,
	 resourceid_1,
	 sptcount_1,
	 currencyid_10,
	 capitalcost_11,
	 startprice_12,
	 depreendprice_1,
	 capitalspec_1,			
	 capitallevel_1,			
	 manufacturer_1,			
	 capitaltypeid_13,
	 capitalgroupid_14,
	 unitid_15,
	 capitalnum_1,
	 replacecapitalid_17,
	 version_18,
	 remark_20,
	 capitalimageid_21,
	 depremethod1_22,
	 depremethod2_23,
	 customerid_26,
	 attribute_27,
	 datefield1_30,
	 datefield2_31,
	 datefield3_32,
	 datefield4_33,
	 datefield5_34,
	 numberfield1_35,
	 numberfield2_36,
	 numberfield3_37,
	 numberfield4_38,
	 numberfield5_39,
	 textfield1_40,
	 textfield2_41,
	 textfield3_42,
	 textfield4_43,
	 textfield5_44,
	 tinyintfield1_45,
	 tinyintfield2_46,
	 tinyintfield3_47,
	 tinyintfield4_48,
	 tinyintfield5_49,
	 createrid_50,
	 createdate_51,
	 createtime_52,
	 lastmoderid_53,
	 lastmoddate_54,
	 lastmodtime_55,
	 isdata_1);


select max(id) INTO thisid_1 from CptCapital;
update CptCapitalAssortment set capitalcount = capitalcount+1 where id
in (select capitalgroupid from CptCapital where id = thisid_1);
open thecursor for
select max(id) from CptCapital;
end;
/







/*  2002-9-11 */
 CREATE or REPLACE PROCEDURE CptCapital_SSumByCapitalgroup 
 (flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for
select capitalgroupid  resultid, COUNT(id)  resultcount 
from CptCapital
group by capitalgroupid  
order by  resultcount desc;
end;
/


 CREATE or REPLACE PROCEDURE CptCapital_SSumByCapitaltypeid 
 (flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for
select capitaltypeid  resultid, COUNT(id)  resultcount 
from CptCapital
group by capitaltypeid  
order by  resultcount desc;
end;
/


 CREATE or REPLACE PROCEDURE CptCapital_SSumByCustomerid 
 (flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for
select customerid AS resultid, COUNT(id) AS resultcount 
from CptCapital
group by customerid  
order by  resultcount desc;
end;
/


 CREATE or REPLACE PROCEDURE CptCapital_SSumByDepartmentid 
 (flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for
select departmentid  resultid, COUNT(id)  resultcount 
from CptCapital
group by departmentid  
order by  resultcount desc;
end;
/


 CREATE or REPLACE PROCEDURE CptCapital_SSumByResourceid 
  (flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for
select resourceid  resultid, COUNT(id) resultcount 
from CptCapital
group by resourceid  
order by  resultcount desc;
end;
/


/*查询所有资产*/
 CREATE or REPLACE PROCEDURE CptCapital_SelectAll 
(flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for
select * from CptCapital order by departmentid ;
end;
/


 CREATE or REPLACE PROCEDURE CptCapital_SByCapitalGroupID 
(id_1 	integer, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for 
  select * from CptCapital where (capitalgroupid = id_1) and (isdata  ='2');
end;
/


/*按资产类型选择资产*/
 CREATE or REPLACE PROCEDURE CptCapital_SByCapitalTypeID 
(id_1 	integer, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for select * from CptCapital where capitaltypeid = id_1;
end;
/


 CREATE or REPLACE PROCEDURE CptCapital_SelectByDataType 
(datatype_1 	integer, 
 departmentid_1  integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for
select * from CptCapital where (datatype = datatype_1) and (departmentid = departmentid_1);
end;
/


/*2002-8-9*/
/*按照id查询资产*/
CREATE or replace PROCEDURE CptCapital_SelectByID 
(id_1 	integer, 
flag      out integer , 
 msg       out    varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
 begin
 open thecursor for  
select * from CptCapital where id = id_1;
end;
/


CREATE or replace PROCEDURE CptCapital_SelectByRandR
(managerid_1 	integer,
 resourceid_1  integer,
 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
  AS 
 begin
 open thecursor for 
 select * from CptCapital where isdata = '2' and resourceid = resourceid_1 and 
datatype in (select id from CptCapital where isdata = '1' and resourceid = managerid_1);
end;
/


 CREATE or REPLACE PROCEDURE CptCapital_SCountByDataType 
(datatype_1 	integer, 
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
  AS 
 begin
 open thecursor for 
select count(id) from CptCapital where capitalgroupid = (select distinct(capitalgroupid) from CptCapital where datatype =  datatype_1) and (isdata='2');
end;
/



 CREATE or REPLACE PROCEDURE CptCapital_SCountByResourceid 
(resourceid_1 	integer, 
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
  AS 
 begin
 open thecursor for 
select count(id) from CptCapital where resourceid = resourceid_1 and isdata= '2' ;
end;
/



 CREATE or REPLACE PROCEDURE CptCapital_SelectSumByStateid 
 (flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
  AS 
 begin
 open thecursor for 
select stateid  resultid, COUNT(id)  resultcount 
from CptCapital
group by stateid  
order by  resultcount desc;
end;
/


/*2002-9-17 17:19*/
/*按人力资源和类型查询资产*/
 CREATE or REPLACE PROCEDURE CptCapital_SelectbyRandT 
  (resourceid_1 integer,
   capitaltypeid_1 integer,
   flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
  AS 
 begin
 open thecursor for 
  select id,name,capitalspec,capitalnum from CptCapital 
  where (resourceid = resourceid_1 and  capitaltypeid=capitaltypeid_1);
end;
/

CREATE or replace PROCEDURE CptCapital_Update
	(id_1 	integer,
	 name_3 	varchar2,
	 barcode_4 	varchar2,
	 startdate_1		char,
	 enddate_1		char,
	 seclevel_7 	smallint,
	 resourceid_1	integer,
	 sptcount_1 	char,
	 currencyid_11 	integer,
	 capitalcost_12 	decimal,
	 startprice_13 	decimal,
	depreendprice_1 number,
	capitalspec_1		varchar2,			
	capitallevel_1		varchar2,			
	manufacturer_1		varchar2,
	manudate_1		char,			
	 capitaltypeid_14 	integer,
	 capitalgroupid_15 	integer,
	 unitid_16 	integer,
	 replacecapitalid_18 	integer,
	 version_19 	varchar2,
	 location_1      varchar2,
	 remark_21 	varchar,
	 capitalimageid_22 	integer,
	 depremethod1_23 	integer,
	 depremethod2_24 	integer,
	 deprestartdate_1	char,
	 depreenddate_1		char,
	 customerid_27 	integer,
	 attribute_28 	smallint,
	 datefield1_31 	char,
	 datefield2_32 	char,
	 datefield3_33 	char,
	 datefield4_34 	char,
	 datefield5_35 	char,
	 numberfield1_36 	float,
	 numberfield2_37 	float,
	 numberfield3_38 	float,
	 numberfield4_39 	float,
	 numberfield5_40 	float,
	 textfield1_41 	varchar2,
	 textfield2_42 	varchar2,
	 textfield3_43 	varchar2,
	 textfield4_44 	varchar2,
	 textfield5_45 	varchar2,
	 tinyintfield1_46 	char,
	 tinyintfield2_47 	char,
	 tinyintfield3_48 	char,
	 tinyintfield4_49 	char,
	 tinyintfield5_50 	char,
	 lastmoderid_51 	integer,
	 lastmoddate_52 	char,
	 lastmodtime_53 	char,
	 relatewfid_1		integer,
	 alertnum_1         number,
	fnamark_1	    varchar2,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as 
tempgroupid_1 integer ;
begin 



select capitalgroupid into  tempgroupid_1 from CptCapital where id=id_1 ;
if tempgroupid_1 <> capitalgroupid_15 then
	update CptCapitalAssortment set capitalcount = capitalcount-1 
	where id=tempgroupid_1 ;
	update CptCapitalAssortment set capitalcount = capitalcount+1 
	where id=capitalgroupid_15 ;
end if ;

update CptCapital 

SET  	 name=name_3,
	 barcode=barcode_4,
	 startdate = startdate_1,
	 enddate=enddate_1,	
	 seclevel=seclevel_7,
	 resourceid = resourceid_1,
	 sptcount	= sptcount_1,	
	 currencyid=currencyid_11,
	 capitalcost=capitalcost_12,
	 startprice=startprice_13,
	 depreendprice	= depreendprice_1,
	 capitalspec	= capitalspec_1,
	 capitallevel	= capitallevel_1,
	 manufacturer	= manufacturer_1,
	 manudate      = manudate_1,
	 capitaltypeid=capitaltypeid_14,
	 capitalgroupid=capitalgroupid_15,
	 unitid=unitid_16,
	 replacecapitalid=replacecapitalid_18,
	 version=version_19,
	 location	  = location_1,
	 remark=remark_21,
	 capitalimageid=capitalimageid_22,
	 depremethod1=depremethod1_23,
	 depremethod2=depremethod2_24,
	 deprestartdate= deprestartdate_1,
	 depreenddate  = depreenddate_1,
	 customerid=customerid_27,
	 attribute=attribute_28,
	 datefield1=datefield1_31,
	 datefield2=datefield2_32,
	 datefield3=datefield3_33,
	 datefield4=datefield4_34,
	 datefield5=datefield5_35,
	 numberfield1=numberfield1_36,
	 numberfield2=numberfield2_37,
	 numberfield3=numberfield3_38,
	 numberfield4=numberfield4_39,
	 numberfield5=numberfield5_40,
	 textfield1=textfield1_41,
	 textfield2=textfield2_42,
	 textfield3=textfield3_43,
	 textfield4=textfield4_44,
	 textfield5=textfield5_45,
	 tinyintfield1=tinyintfield1_46,
	 tinyintfield2=tinyintfield2_47,
	 tinyintfield3=tinyintfield3_48,
	 tinyintfield4=tinyintfield4_49,
	 tinyintfield5=tinyintfield5_50,
	 lastmoderid=lastmoderid_51,
	 lastmoddate=lastmoddate_52,
	 lastmodtime=lastmodtime_53,
	 relatewfid	= relatewfid_1,
	 alertnum	 = alertnum_1,
	 fnamark	= fnamark_1

WHERE 
	( id=id_1);
end;
/

/*资产卡片参考价格更新*/
 CREATE or REPLACE PROCEDURE CptCapital_UpdatePrice 
 (id_1 	integer, 
price 	number,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CptCapital 
SET  startprice=price
 WHERE ( id	 = id_1) ;
 end;
/



/*按盘点单id删除详细单*/
 CREATE or REPLACE PROCEDURE CptCheckStockList_DByCheckSto 
	(checkstockid_1 	integer,
	price 	number,
flag out integer, msg out varchar2 )

AS
begin
DELETE CptCheckStockList 

WHERE 
	( checkstockid	 = checkstockid_1);
end;
/

/*盘点详细单新增*/
CREATE or replace PROCEDURE CptCheckStockList_Insert
	(checkstockid_1 	integer,
	 capitalid_2 	integer,
	 theorynumber_3 	integer,
	 realnumber_4 	integer,
	 price_5 	decimal,
	 remark_6 	varchar2,
	capitalimageid_2     integer, 
	 flag out integer,
	msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin insert into CptCheckStockList 
	 ( checkstockid,
	 capitalid,
	 theorynumber,
	 realnumber,
	 price,
	 remark) 
 
VALUES 
	( checkstockid_1,
	 capitalid_2,
	 theorynumber_3,
	 realnumber_4,
	 price_5,
	 remark_6);
end;
/



/*按盘点单id查找盘点详细单*/
CREATE or replace PROCEDURE CptCheckStockList_SByCheckSto
(checkstockid_1 varchar2 , 
	 flag out integer , 
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
 as begin open thecursor for select * from CptCheckStockList
      where checkstockid =to_number(checkstockid_1);
      end;
/



/*盘点详细单更新*/
CREATE or replace PROCEDURE CptCheckStockList_Update
	(id_1 	integer,
	 realnumber_2 	integer,
	 remark_3 	varchar2,
	apitalimageid_2     integer, 
	 flag out integer,
	msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin update CptCheckStockList 

SET  realnumber=realnumber_2,
	 remark=remark_3 

WHERE 
	( id=id_1);
end;
/


/*盘点单审批*/
CREATE or replace PROCEDURE CptCheckStock_Approve
	(id_1 	integer,
 	 approverid_1 integer,
	 approvedate_1 char,
	 flag out integer,
	msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
as begin update CptCheckStock 
SET  checkstatus='1',
        approverid = approverid_1,
        approvedate = approvedate_1

WHERE 
	( id=id_1);
end;
/


/*盘点单删除*/
CREATE or replace PROCEDURE CptCheckStock_Delete
	(id_1 	integer,
	 flag out integer,
	msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
AS 
begin
delete CptCheckStockList where checkstockid=id_1;
DELETE CptCheckStock WHERE ( id=id_1);
end;
/



/*盘点单新增*/
 CREATE or replace PROCEDURE CptCheckStock_Insert
	(checkstockno_1 	varchar2,
	 checkstockdesc_2 	varchar2,
	 departmentid_3 	integer,
	 location_4 	varchar2,
	 checkerid_5 	integer,
	 createdate_7 	varchar2,
	 checkstatus_9 	char,
	flag out integer,
	msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin insert into CptCheckStock 
	 ( checkstockno,
	 checkstockdesc,
	 departmentid,
	 location,
	 checkerid,
	 createdate,
	 checkstatus) 
 
VALUES 
	( checkstockno_1,
	 checkstockdesc_2,
	 departmentid_3,
	 location_4,
	 checkerid_5,
	 createdate_7,
	 checkstatus_9);
open thecursor for
select max(id) from CptCheckStock;
end;
/


/*2002-9-9*/

/*按id查找盘点单*/

CREATE or replace PROCEDURE CptCheckStock_SelectByID
	( id_1 varchar2 , 
	 flag out integer , 
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
 as begin open thecursor for select * from CptCheckStock
      where id =to_number(id_1);
end;
/


/*盘点单更新*/
CREATE or replace PROCEDURE CptCheckStock_Update
	(id_1 	integer,
	 checkstockno_2 	varchar2,
	 checkstockdesc_3 	varchar2,
	flag out integer,
	msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
as begin update CptCheckStock 

SET  checkstockno=checkstockno_2,
	 checkstockdesc=checkstockdesc_3 

WHERE 
	( id=id_1);
end;
/


/*折旧法一删除*/
CREATE or replace PROCEDURE CptDepreMethod1_Delete
	(id_1 	integer,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin delete CptDepreMethod1 

WHERE 
	( id=id_1);
end;
/




/*折旧法一新增*/
CREATE or replace PROCEDURE CptDepreMethod1_Insert
	(name_1 	varchar2,
	 description_2 	varchar2,
	 depretype_3 	char,
	 timelimit_4 	decimal,
	 startunit_5 	decimal,
	 endunit_6 	decimal,
	 deprefunc_7 	varchar2,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
as begin insert into CptDepreMethod1 
	 ( name,
	 description,
	 depretype,
	 timelimit,
	 startunit,
	 endunit,
	 deprefunc) 
 
VALUES 
	( name_1,
	 description_2,
	 depretype_3,
	 timelimit_4,
	 startunit_5,
	 endunit_6,
	 deprefunc_7);
open thecursor for
select max(id) from CptDepreMethod1;
end;
/

/*按照类型查询折旧法一二*/
CREATE or replace PROCEDURE CptDepreMethod1_Select 
(depretype_1		char,
 flag out integer,
 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
 as
 begin
open thecursor for
select * from CptDepreMethod1 where depretype = depretype_1;
end;
/


/*按照id查询折旧法一二*/
 
 CREATE or replace PROCEDURE CptDepreMethod1_SelectByID
 (id_1 	integer, flag	out integer, msg out varchar2,thecursor IN OUT cursor_define.weavercursor) 
 as
 begin
open thecursor for
SELECT * FROM CptDepreMethod1 
WHERE ( id=id_1);
end;
/

/*折旧法一更新*/
 CREATE or replace PROCEDURE CptDepreMethod1_Update
	(id_1 	integer,
	 name_2 	varchar2,
	 description_3 	varchar2,
	 depretype_4 	char,
	 timelimit_5 	decimal,
	 startunit_6 	decimal,
	 endunit_7 	decimal,
	 deprefunc_8 	varchar2,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin update CptDepreMethod1 

SET  name=name_2,
	 description=description_3,
	 depretype=depretype_4,
	 timelimit=timelimit_5,
	 startunit=startunit_6,
	 endunit=endunit_7,
	 deprefunc=deprefunc_8 

WHERE 
	( id=id_1);
end;
/



/*折旧法二删除(按照depreid)*/
 CREATE or REPLACE PROCEDURE CptDepreMethod2_DByDepreID 
	(depreid_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
DELETE CptDepreMethod2 

WHERE 
	( depreid	 = depreid_1);
end;
/


/*折旧法二按照id删除*/
 CREATE or REPLACE PROCEDURE CptDepreMethod2_Delete 
	(id_1 	integer,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
DELETE CptDepreMethod2 

WHERE 
	( id	 = id_1);
end;
/


/*折旧法二新增*/
CREATE or replace PROCEDURE CptDepreMethod2_Insert
	(depreid_1 	integer,
	 time_2 	decimal,
	 depreunit_3 	decimal,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
as begin insert into CptDepreMethod2 
	 ( depreid,
	 time,
	 depreunit) 
 
VALUES 
	( depreid_1,
	 time_2,
	 depreunit_3);
end;
/

/*折旧法二查询*/
 CREATE or REPLACE PROCEDURE CptDepreMethod2_SByDepreID 
 (depreid1 	integer, flag out integer, msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
AS
begin
 open thecursor for
SELECT * FROM CptDepreMethod2 
WHERE  depreid	 = depreid1
order by  time ;
end;
/


/*折旧法二更新*/
CREATE or replace PROCEDURE CptDepreMethod2_Update
	(id_1 	integer,
	 depreid_2 	integer,
	 time_3 	decimal,
	 depreunit_4 	decimal,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin update CptDepreMethod2 

SET  depreid=depreid_2,
	 time=time_3,
	 depreunit=depreunit_4 

WHERE 
	( id=id_1);
end;
/


/*查询所有折旧法*/
CREATE or replace PROCEDURE CptDepreMethod_Select 
(flag out integer,
msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
 AS 
 begin
 open thecursor for
select * from CptDepreMethod1 order by depretype;
end;
/


 CREATE or replace PROCEDURE CptRelateWorkflow_Select  
(flag out integer,
msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
as begin open thecursor for select * from CptRelateWorkflow;
end;
/


/*2002-8-15*/
/*搜索模板删除*/
CREATE or replace PROCEDURE CptSearchMould_Delete
	(id_1 	integer,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin delete CptSearchMould 

WHERE 
	( id=id_1);
end;
/


/*搜索模板新增*/
CREATE or replace PROCEDURE CptSearchMould_Insert
	(mouldname_1 	varchar2,
	 userid_2 	integer,
	 mark_3 	varchar2,
	 name_4 	varchar2,
	 startdate_5 	char,
	 startdate1_6 	char,
	 enddate_7 	char,
	 enddate1_8 	char,
	 seclevel_9 	smallint,
	 seclevel1_10 	smallint,
	 departmentid_11 	integer,
	 costcenterid_12 	integer,
	 resourceid_13 	integer,
	 currencyid_14 	integer,
	 capitalcost_15 	varchar2,
	 capitalcost1_16 	varchar2,
	 startprice_17 	varchar2,
	 startprice1_18 	varchar2,
	 depreendprice_19 	varchar2,
	 depreendprice1_20 	varchar2,
	 capitalspec_21 	varchar2,
	 capitallevel_22 	varchar2,
	 manufacturer_23 	varchar2,
	 manudate_24 	char,
	 manudate1_25 	char,
	 capitaltypeid_26 	integer,
	 capitalgroupid_27 	integer,
	 unitid_28 	integer,
	 capitalnum_29 	varchar2,
	 capitalnum1_30 	varchar2,
	 currentnum_31 	varchar2,
	 currentnum1_32 	varchar2,
	 replacecapitalid_33 	integer,
	 version_34 	varchar2,
	 itemid_35 	integer,
	 depremethod1_36 	integer,
	 depremethod2_37 	integer,
	 deprestartdate_38 	char,
	 deprestartdate1_39 	char,
	 depreenddate_40 	char,
	 depreenddate1_41 	char,
	 customerid_42 	integer,
	 attribute_43 	char,
	 stateid_44 	integer,
	 location_45 	varchar2,
	isdata		char,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin insert into CptSearchMould 
	 ( mouldname,
	 userid,
	 mark,
	 name,
	 startdate,
	 startdate1,
	 enddate,
	 enddate1,
	 seclevel,
	 seclevel1,
	 departmentid,
	 costcenterid,
	 resourceid,
	 currencyid,
	 capitalcost,
	 capitalcost1,
	 startprice,
	 startprice1,
	 depreendprice,
	 depreendprice1,
	 capitalspec,
	 capitallevel,
	 manufacturer,
	 manudate,
	 manudate1,
	 capitaltypeid,
	 capitalgroupid,
	 unitid,
	 capitalnum,
	 capitalnum1,
	 currentnum,
	 currentnum1,
	 replacecapitalid,
	 version,
	 itemid,
	 depremethod1,
	 depremethod2,
	 deprestartdate,
	 deprestartdate1,
	 depreenddate,
	 depreenddate1,
	 customerid,
	 attribute,
	 stateid,
	 location,
	isdata) 
 
VALUES 
	( mouldname_1,
	 userid_2,
	 mark_3,
	 name_4,
	 startdate_5,
	 startdate1_6,
	 enddate_7,
	 enddate1_8,
	 seclevel_9,
	 seclevel1_10,
	 departmentid_11,
	 costcenterid_12,
	 resourceid_13,
	 currencyid_14,
	 capitalcost_15,
	 capitalcost1_16,
	 startprice_17,
	 startprice1_18,
	 depreendprice_19,
	 depreendprice1_20,
	 capitalspec_21,
	 capitallevel_22,
	 manufacturer_23,
	 manudate_24,
	 manudate1_25,
	 capitaltypeid_26,
	 capitalgroupid_27,
	 unitid_28,
	 capitalnum_29,
	 capitalnum1_30,
	 currentnum_31,
	 currentnum1_32,
	 replacecapitalid_33,
	 version_34,
	 itemid_35,
	 depremethod1_36,
	 depremethod2_37,
	 deprestartdate_38,
	 deprestartdate1_39,
	 depreenddate_40,
	 depreenddate1_41,
	 customerid_42,
	 attribute_43,
	 stateid_44,
	 location_45,
	 isdata);
open thecursor for
select max(id) from CptSearchMould;
end;
/

/*按照id查询模板*/

CREATE or replace PROCEDURE CptSearchMould_SelectByID 
(id_1 	integer, 
flag out integer,
msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
as
begin
 open thecursor for 
select * from CptSearchMould where id = id_1;
end;
/


/*按照用户id查询模板*/
CREATE or replace PROCEDURE CptSearchMould_SelectByUserID 
(userid_1 	integer, 
flag out integer,
msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
as
begin
 open thecursor for 
select * from CptSearchMould 
where userid = userid_1;
end;
/

/*搜索模板更新*/
CREATE or replace PROCEDURE CptSearchMould_Update
	(id_1 	integer,
	 userid_2 	integer,
	 mark_3 	varchar2,
	 name_4 	varchar2,
	 startdate_5 	char,
	 startdate1_6 	char,
	 enddate_7 	char,
	 enddate1_8 	char,
	 seclevel_9 	smallint,
	 seclevel1_10 	smallint,
	 departmentid_11 	integer,
	 costcenterid_12 	integer,
	 resourceid_13 	integer,
	 currencyid_14 	integer,
	 capitalcost_15 	varchar2,
	 capitalcost1_16 	varchar2,
	 startprice_17 	varchar2,
	 startprice1_18 	varchar2,
	 depreendprice_19 	varchar2,
	 depreendprice1_20 	varchar2,
	 capitalspec_21 	varchar2,
	 capitallevel_22 	varchar2,
	 manufacturer_23 	varchar2,
	 manudate_24 	char,
	 manudate1_25 	char,
	 capitaltypeid_26 	integer,
	 capitalgroupid_27 	integer,
	 unitid_28 	integer,
	 capitalnum_29 	varchar2,
	 capitalnum1_30 	varchar2,
	 currentnum_31 	varchar2,
	 currentnum1_32 	varchar2,
	 replacecapitalid_33 	integer,
	 version_34 	varchar2,
	 itemid_35 	integer,
	 depremethod1_36 	integer,
	 depremethod2_37 	integer,
	 deprestartdate_38 	char,
	 deprestartdate1_39 	char,
	 depreenddate_40 	char,
	 depreenddate1_41 	char,
	 customerid_42 	integer,
	 attribute_43 	char,
	 stateid_44 	integer,
	 location_45 	varchar2,
	isdata_1		char,
	flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin update CptSearchMould 

SET  userid=userid_2,
	 mark=mark_3,
	 name=name_4,
	 startdate=startdate_5,
	 startdate1=startdate1_6,
	 enddate=enddate_7,
	 enddate1=enddate1_8,
	 seclevel=seclevel_9,
	 seclevel1=seclevel1_10,
	 departmentid=departmentid_11,
	 costcenterid=costcenterid_12,
	 resourceid=resourceid_13,
	 currencyid=currencyid_14,
	 capitalcost=capitalcost_15,
	 capitalcost1=capitalcost1_16,
	 startprice=startprice_17,
	 startprice1=startprice1_18,
	 depreendprice=depreendprice_19,
	 depreendprice1=depreendprice1_20,
	 capitalspec=capitalspec_21,
	 capitallevel=capitallevel_22,
	 manufacturer=manufacturer_23,
	 manudate=manudate_24,
	 manudate1=manudate1_25,
	 capitaltypeid=capitaltypeid_26,
	 capitalgroupid=capitalgroupid_27,
	 unitid=unitid_28,
	 capitalnum=capitalnum_29,
	 capitalnum1=capitalnum1_30,
	 currentnum=currentnum_31,
	 currentnum1=currentnum1_32,
	 replacecapitalid=replacecapitalid_33,
	 version=version_34,
	 itemid=itemid_35,
	 depremethod1=depremethod1_36,
	 depremethod2=depremethod2_37,
	 deprestartdate=deprestartdate_38,
	 deprestartdate1=deprestartdate1_39,
	 depreenddate=depreenddate_40,
	 depreenddate1=depreenddate1_41,
	 customerid=customerid_42,
	 attribute=attribute_43,
	 stateid=stateid_44,
	 location=location_45 ,
	isdata		= isdata_1

WHERE 
	( id=id_1);
end;
/



 CREATE or REPLACE PROCEDURE CptShareDetail_DeleteByCptId 
	(cptid_1 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
DELETE CptShareDetail 

WHERE 
	( cptid	 = cptid_1);
end;
/


/*2002-11-19*/
 CREATE or REPLACE PROCEDURE CptShareDetail_DeleteByUserId 
	(userid_1 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
DELETE CptShareDetail 

WHERE 
	( userid	 = userid_1)  and( usertype = '1' );
end;
/


/*2002-11-18*/

 CREATE or REPLACE PROCEDURE CptShareDetail_Insert 
	(capitalid_1 	integer,
              userid_1 	integer,
	 usertype_1 	integer,
	 sharelevel_1 	integer ,      
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
INSERT INTO CptShareDetail 
	 ( cptid,	 userid ,
	 usertype,
	 sharelevel
 	) 
 
VALUES 
	( capitalid_1,userid_1,
	 usertype_1,
	 sharelevel_1
	);
end;
/


/*资产流转表盘盈亏信息添加*/
CREATE or replace PROCEDURE CptUseLogCheckStock_Insert
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
	 realnum_1	integer,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO CptUseLog 
	 ( capitalid,
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
	( capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	usestatus_10,
	 remark_11);

update CptCapital set capitalnum = realnum_1 where id = capitalid_1;
end;
/


/*资产流转表盘盈亏信息更新*/
CREATE or replace PROCEDURE CptUseLogCheckStock_Update
	(capitalid_1 	integer,
	 userequest_2 	integer,
	 usestatus_3 	varchar2,
	 usecount_4 	integer,
	 fee_1		decimal,
	 realnum_1	integer,
	 remark_1           varchar,
	 flag out integer ,
 	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin update CptUseLog 

SET  usecount=usecount_4,
	fee = fee_1,
	 usestatus=usestatus_3,
             remark = remark_1
	 

WHERE 
	( capitalid=capitalid_1 AND
	 userequest=userequest_2 AND
	 (usestatus='-1' or
	  usestatus='-2'));

update CptCapital
set capitalnum = realnum_1 
where id = capitalid_1;
end;
/

/*资产流程新增:资产报废*/
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
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as 
begin 
insert into CptUseLog 
	 ( capitalid,
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
	( capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '5',
	 remark_11);

Update CptCapital
Set 
departmentid = null,
costcenterid = null,
resourceid   = null,
location	     =  null,
stateid = usestatus_10
where id = capitalid_1;
end;
/

/*资产流程新增:资产移交*/
 CREATE or replace PROCEDURE CptUseLogHandOver_Insert
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
	 remark_11 	varchar,
	 costcenterid_1   integer,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO CptUseLog 
	 ( capitalid,
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
	( capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '-6',
	 remark_11);

Update CptCapital
	Set 
	location = useaddress_6,
	departmentid = usedeptid_3,
	costcenterid = costcenterid_1,
	resourceid   = useresourceid_4,
	stateid = usestatus_10
	where id = capitalid_1;
end;
/

/*资产流程新增:资产入库*/
CREATE or replace PROCEDURE CptUseLogInStock2_Insert
	(capitalid_1 	integer,
	 usedate_2 	char,
	  usecount_5 	integer,
	  userequest_7  integer,
	 remark_11 	varchar2,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

AS 
departmentid_1  integer;
resourceid_1 integer;
location_1 varchar2(100);
num_1 integer;
recordcount integer;
begin

select 	count(*) into recordcount from CptCapital where id = capitalid_1;
if recordcount > 0 then 

	select 	departmentid,resourceid,location,capitalnum into departmentid_1,
	resourceid_1,location_1,num_1 from CptCapital where id = capitalid_1;
end if ;

INSERT INTO CptUseLog 
	 ( capitalid,
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
	( capitalid_1,
	 usedate_2,
	 departmentid_1,
	 resourceid_1,
	 usecount_5,
	 location_1,
	 userequest_7,
	 '',
	 0,
	 '1',
	 remark_11);

Update CptCapital Set capitalnum = num_1+usecount_5 where id = capitalid_1;
end;
/


/**/
 CREATE or REPLACE PROCEDURE CptUseLogInStock_Insert 
	(capitalid_1 	integer,
	 usedate_1 	char,
	 usedeptid_1 	integer,
	 useresourceid_1 	IN OUT integer,
	 checkerid_1 	integer,
	 usecount_1 	number,
	 useaddress_1 	varchar2,
	 userequest_1 	integer,
	 maintaincompany_1 varchar2,
	 fee_1 			number,
	 usestatus_1 		varchar2,
	 remark_1 		varchar2,
	 mark_1				varchar2,
	 datatype_1			integer,
	 startdate_1			char,
	 enddate_1			char,
	 deprestartdate_1	char,
	 depreenddate_1		char,
	 manudate_1			char,
	 lastmoderid_1		integer,
	 lastmoddate_1		char,
	 lastmodtime_1    	char,
	 inprice_1		number,
	 crmid_1		integer,
	 counttype_1		char,
	 isinner_1		char,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)

AS
num_1 number(18,3) ;
num_count integer;
begin

if usestatus_1 ='2' then

	 INSERT INTO CptUseLog 
		 ( capitalid,
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
		( capitalid_1,
		 usedate_1,
		 usedeptid_1,
		 checkerid_1,
		 usecount_1,
		 useaddress_1,
		 userequest_1,
		 maintaincompany_1,
		 fee_1,
		'1',
		 remark_1);
end if ;

 INSERT INTO CptUseLog 
	 ( capitalid,
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
	( capitalid_1,
	 usedate_1,
	 usedeptid_1,
	 useresourceid_1,
	 usecount_1,
	 useaddress_1,
	 userequest_1,
	 maintaincompany_1,
	 fee_1,
	usestatus_1,
	 remark_1);

select count(capitalnum) INTO num_count from CptCapital where id = capitalid_1;
  if  num_count > 0 then 

    select capitalnum INTO num_1 from CptCapital where id = capitalid_1;
  end if;

if usestatus_1 = '1' then
    useresourceid_1 := 0 ;
end if;

if usedeptid_1 = 0 then

Update CptCapital
Set 
mark = mark_1,
capitalnum = usecount_1 + num_1,
location = useaddress_1,
departmentid = null ,
resourceid   = useresourceid_1,
stateid = usestatus_1,
datatype = datatype_1,
isdata = '2',
startdate = startdate_1,
enddate = enddate_1,
deprestartdate = deprestartdate_1,
depreenddate = depreenddate_1,
manudate = manudate_1,
lastmoderid = lastmoderid_1,
lastmoddate = lastmoddate_1,
lastmodtime = lastmodtime_1,
startprice  = inprice_1,
customerid		  =	crmid_1,
counttype    = counttype_1,
isinner     = isinner_1
where id = capitalid_1;
else 
Update CptCapital
Set 
mark = mark_1,
capitalnum = usecount_1 + num_1,
location = useaddress_1,
departmentid = usedeptid_1,
resourceid   = useresourceid_1,
stateid = usestatus_1,
datatype = datatype_1,
isdata = '2',
startdate = startdate_1,
enddate = enddate_1,
deprestartdate = deprestartdate_1,
depreenddate = depreenddate_1,
manudate = manudate_1,
lastmoderid = lastmoderid_1,
lastmoddate = lastmoddate_1,
lastmodtime = lastmodtime_1,
startprice  = inprice_1,
customerid		  =	crmid_1,
counttype    = counttype_1,
isinner     = isinner_1
where id = capitalid_1;
end if ;

end;
/




/*资产流程新增:资产租借*/
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
	 costcenterid   integer,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin insert into CptUseLog 
	 ( capitalid,
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
	( capitalid_1,
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
departmentid = null,
costcenterid = null,
resourceid   = null,
location=  useaddress_6,
stateid = usestatus_10,
crmid = useresourceid_4
where id = capitalid_1;
end;
/


/*资产流程新增:资产损失*/
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
	 costcenterid_1   integer,
	 sptcount_1	char,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

AS 
 num_1 integer;
 num_count integer;
begin
if sptcount_1<>'1' then
   select count(capitalnum) into num_count from CptCapital where id = capitalid_1;
   if num_count > 0 then
  
      select capitalnum into num_1 from CptCapital where id = capitalid_1;
      if num_1<usecount_5 then
         open thecursor for
	     select -1 from dual; 
	     return;
      else 
      num_1:=num_1-usecount_5;
	  end if;
   end if;
end if;

INSERT INTO CptUseLog 
	 ( capitalid,
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
	( capitalid_1,
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
if sptcount_1='1' then
    if usestatus_10='5' then
	Update CptCapital Set departmentid=null,costcenterid=null,resourceid=null,stateid = usestatus_10 where id = capitalid_1;
    else  Update CptCapital Set stateid = usestatus_10 where id = capitalid_1;
    end if;
else 
    Update CptCapital Set capitalnum = num_1 where id = capitalid_1;
end if;
open thecursor for
select 1 from dual;
return;
end;
/



/*资产流程新增:资产调出*/
CREATE or replace PROCEDURE CptUseLogMoveOut_Insert
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
	 remark_11 	varchar,
	 costcenterid_1   integer,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

AS 
 num_1 integer;
 num_count integer;
begin 
select count(capitalnum) into num_count from CptCapital where id = capitalid_1;
if num_count >0 then

    select capitalnum into num_1 from CptCapital where id = capitalid_1;
     if num_1<usecount_5 then
         open thecursor for
	     select -1 from dual;
	     return;
     else
        num_1:= num_1-usecount_5;
     end if;
end if;



insert into CptUseLog 
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
	( capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '-5',
	 remark_11);

Update CptCapital Set capitalnum = num_1 where id = capitalid_1;
open thecursor for
select 1 from dual;
return;
end;
/




/*资产流程新增:资产调拨*/
CREATE or replace PROCEDURE CptUseLogMove_Insert
	(capitalid_1 	integer,
	 usedate_2 	char,
	 departmentid_1   integer,
	 costcenterid_1   integer,
	 resourceid_1      integer,
	 usecount_5 	decimal,
	 userequest_7  integer,
	 location_1	varchar2,
	 fee_1	     number,
	 remark_11 	varchar2,
	 olddepartmentid_1 integer,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO CptUseLog 
	 ( capitalid,
	 usedate,
	 usedeptid,
	 useresourceid,
	 usecount,
	 useaddress,
	 userequest,
	 maintaincompany,
	 fee,
	 usestatus,
	 remark,
	 olddeptid) 
VALUES 
	( capitalid_1,
	 usedate_2,
	 departmentid_1,
	 resourceid_1,
	 1,
	 location_1,
	 userequest_7,
	 '',
	 fee_1,
	 '-4',
	 remark_11,
	 olddepartmentid_1);
Update CptCapital
Set
	departmentid = departmentid_1,
	costcenterid = costcenterid_1,
	resourceid    = resourceid_1
where id = capitalid_1;
end;
/



/*资产流程新增:其它状态流程*/
 CREATE or REPLACE PROCEDURE CptUseLogOther_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	number,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	number,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 costcenterid_1   integer,
	 sptcount_1	char,
	 flag out integer ,
	 msg out varchar2 ,
	 thecursor IN OUT cursor_define.weavercursor)

AS 
num_1 integer;
num_count integer;
begin
/*判断数量是否足够(对于非单独核算的资产*/
if sptcount_1 <>'1' then
    select count(capitalnum) INTO num_count  from CptCapital where id = capitalid_1;
    if num_count >0 then

       select capitalnum INTO num_1  from CptCapital where id = capitalid_1;
        if num_1 <usecount_5 then
              open thecursor for
              select -1 from dual;
	          return;
        else 
        num_1 := num_1-usecount_5;
        end if;
    end if;
end if;
INSERT INTO CptUseLog 
	 ( capitalid,
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
	( capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 usestatus_10,
	 remark_11) ;
/*单独核算的资产*/
if sptcount_1 ='1' then

	Update CptCapital
	Set 
	location = useaddress_6,
	departmentid = usedeptid_3,
	costcenterid = costcenterid_1,
	resourceid   = useresourceid_4,
	stateid = usestatus_10
	where id = capitalid_1 ;

/*非单独核算的资产*/
else 

	Update CptCapital
	Set
	capitalnum = num_1
	where id = capitalid_1;
end if;

open thecursor for
select 1 from dual ;
end ;
/

/*资产流程新增:资产归还*/
 CREATE or replace PROCEDURE CptUseLogReturn_Insert
	(capitalid_1 		integer,
	 usedate_1		char,
	 resourceid_1		integer,
	 todepartmentid_1      integer,
	 costcenterid_1 		integer,
	 fromdepartmentid_1	integer,
	 capitalnum_1		number,
	 relatereq_1		integer,
	 sptcount_1		char,
	 flag out		integer,
	 msg out		varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)
as
id_1 integer;
num_1 number;
recordcount integer;
begin
INSERT INTO CptUseLog 
	 ( capitalid,
	 usedate,
	 usedeptid,
	 useresourceid,
	 usecount,
	 useaddress,
	 userequest,
	 maintaincompany,
	 fee,
	 usestatus,
	 remark,
	 olddeptid) 
 
VALUES 
	( capitalid_1,
	 usedate_1,
	 todepartmentid_1,
	 resourceid_1,
	 capitalnum_1,
	 '',
	 relatereq_1,
	 '',
	 0,
	 '0',
	 '',
	 fromdepartmentid_1);

if sptcount_1 <> '1' then      
    select count(*) INTO recordcount from CptCapital where isdata='2' and 
	datatype in (select datatype from CptCapital where id = capitalid_1)   and departmentid = todepartmentid_1;
	if  recordcount >0 then

	   select id,capitalnum into id_1,num_1 from CptCapital where isdata='2' and 
       datatype in (select datatype from CptCapital where id = capitalid_1) 
       and departmentid = todepartmentid_1;  
	 end if;  
    if (id_1<>'' AND id_1 is not null) then
	Update CptCapital Set capitalnum = num_1+capitalnum_1,stateid = '1' where id=id_1;
	delete from CptCapital where id = capitalid_1;
	else
	Update CptCapital Set departmentid = todepartmentid_1,
	costcenterid = costcenterid_1,resourceid= resourceid_1,stateid='1'
	where id = capitalid_1;
	end if;
else
	Update CptCapital Set departmentid = todepartmentid_1,
	costcenterid = costcenterid_1,resourceid= resourceid_1,stateid='1'
	where id = capitalid_1;
end if;
end;
/

/*资产流程新增:资产领用*/
 CREATE or REPLACE PROCEDURE CptUseLogUse_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	number,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	number,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 costcenterid_1   integer,
	 sptcount_1	char,
	 olddeptid integer,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
 num_1 number;
 num_count integer;
 begin
/*判断数量是否足够(对于非单独核算的资产*/
if sptcount_1 <> '1' then
    select count(capitalnum) INTO num_count from CptCapital where id = capitalid_1;
	if(num_count > 0) then

    select capitalnum INTO num_1 from CptCapital where id = capitalid_1;
    if num_1 < usecount_5 then
      open thecursor for
	  select -1 from dual;
	  return;
   else 
   	num_1 := num_1-usecount_5;
   end if;
   end if;
end if;

INSERT INTO CptUseLog 
	 ( capitalid,
	 usedate,
	 usedeptid,
	 useresourceid,
	 usecount,
	 useaddress,
	 userequest,
	 maintaincompany,
	 fee,
	 usestatus,
	 remark,
	 olddeptid) 
 
VALUES 
	( capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '2',
	 remark_11,
              0);
/*单独核算的资产*/
if sptcount_1 ='1' then
	Update CptCapital
	Set 
	location = useaddress_6,
	departmentid = usedeptid_3,
	costcenterid = costcenterid_1,
	resourceid   = useresourceid_4,
	stateid = usestatus_10
	where id = capitalid_1 ;
/*非单独核算的资产*/
else 
	Update CptCapital
	Set
	capitalnum = num_1
	where id = capitalid_1;
open thecursor for
select 1 from dual;
end if;
end;
/



/*查询资产l流转情况*/
 CREATE or REPLACE PROCEDURE CptUseLog_SelectByCapitalID 
 (
	capitalid_1 integer,
	flag out integer  ,
 	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select * from CptUseLog 
where capitalid = capitalid_1;
end;
/


/*按照id查询资产流转情况*/
 CREATE or REPLACE PROCEDURE CptUseLog_SelectByID
 (
	 id_1 varchar2 , 
	 flag out integer  ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for 
select * from CptUseLog
      where id = to_number( id_1); 
end;
/


 CREATE or REPLACE PROCEDURE CrmShareDetail_DByCrmId 
	(crmid_1 	integer ,
	 flag out integer, 
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
DELETE CrmShareDetail 
WHERE 
	( crmid	 = crmid_1);
end;
/


 CREATE or REPLACE PROCEDURE CrmShareDetail_DByUserId 
	(userid_1 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE CrmShareDetail 
WHERE 
	( userid	 = userid_1  )and (usertype = '1' );
end;
/


 CREATE or REPLACE PROCEDURE CrmShareDetail_Insert 
	(crmid_1 	integer,
	 userid_2 	integer,
	 usertype_3 	integer,
	 sharelevel_4 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO CrmShareDetail 
	 ( crmid,
	 userid,
	 usertype,
	 sharelevel) 
VALUES 
	( crmid_1,
	 userid_2,
	 usertype_3,
	 sharelevel_4);
end;
/


 CREATE or REPLACE PROCEDURE CrmShareDetail_SByCrmId 
	(crmid_1 integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
select * from CrmShareDetail where crmid = crmid_1 ;
end;
/


 CREATE or REPLACE PROCEDURE CrmShareDetail_SByResourceId 
	(resourceid_1 integer ,
		 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
select crmid , sharelevel from CrmShareDetail where (userid = resourceid_1) and (usertype = '1');  
end;
/


 CREATE or REPLACE PROCEDURE DocApproveRemark_Insert 
 (
	docid_1		integer,
	approveremark_1      varchar2,
	approverid_1     integer,
	approvedate_1    char,
	approvetime_1    char,
	isapprover_1      char,
		 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
	insert into docApproveRemark (docid,approveremark,approverid,approvedate,approvetime,isapprover)
	values(docid_1,approveremark_1,approverid_1,approvedate_1,approvetime_1,isapprover_1);
end;
/


 CREATE or REPLACE PROCEDURE DocApproveRemark_SelectByDocid 
 (
	docid_1		integer,
		 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
open thecursor for

	select * from docapproveremark where docid=docid_1;
end;
/


/****************************2002-12-11 18:13*******************************/
 CREATE or REPLACE PROCEDURE DocDetailLog_SRead 
 (
	docid_1  integer,
	userid_1 integer,
		 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
open thecursor for
	select * from DocDetailLog where ((operatetype='0' and operateuserid=userid_1) or doccreater=userid_1 )
	and docid=docid_1 ;
end;
/


/*2002-9-20 11:30*/

 CREATE or REPLACE PROCEDURE DocDetail_Approve 
 (
	approverid_1		integer,
	docstatus_1      char,
	approvedate_1    char,
	approvetime_1    char,
	docid_1          integer,
		 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
	update DocDetail set docstatus=docstatus_1,docapproveuserid=approverid_1,docapprovedate=approvedate_1,docapprovetime=approvetime_1 
	where id=docid_1; 
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SCountByResource 
(id_1 	integer,
 id_2  integer,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
AS
begin
open thecursor for
select count(hrmresid) from DocDetail t1, DocUserView t2 where hrmresid = id_1 and t2.userid=id_2 and t1.id=t2.docid ; 
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SelectByCreater 
	(resourceid_1 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
open thecursor for
select distinct id from DocDetail where doccreaterid = resourceid_1 or ownerid = resourceid_1;
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SelectByOwner 
	(resourceid_1 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
open thecursor for
select distinct id from DocDetail where  ownerid = resourceid_1;
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SelectCountByCapital 
(id_1 	integer, 
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
open thecursor for
 select count(*) from DocDetail where assetid = id_1;
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SelectCountByItem 
 (id_1 	integer, 		                            
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT count(*) from DocDetail where itemid = id_1; 
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SelectCountByOwner 
	(id_1 	integer, 
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
open thecursor for
	select count(*) from DocDetail where ownerid = id_1; 
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SCountByResource2 
 (id_1 	integer, 
 		
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
SELECT count(*) from DocDetail where doccreaterid = id_1 ;
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SelectCrmCountByCrm 
(id_1 	integer,
 id_2 integer,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
AS 
begin
open thecursor  for
select count(crmid) from DocDetail t1, DocUserView t2 where( t1.crmid = id_1 )and( t2.userid=id_2) and (t2.docid=t1.id ) ;
end;
/


 CREATE or REPLACE PROCEDURE DocDetail_SProCountByProjID 
(id_1 	integer,
 id_2 integer,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
AS 
begin
open thecursor  for
select count(projectid) from DocDetail t1, DocUserView t2 where (t1.projectid = id_1) and (t2.userid=id_2 )and( t2.docid=t1.id);  
end;
/


 CREATE or REPLACE PROCEDURE DocFrontpage_ALLCount 
(
logintype_1		integer,
usertype_1		integer,
userid_1			integer,
userseclevel_1	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
if logintype_1 =1 then
    open thecursor for
    Select count(distinct n.id ) countnew from DocDetail n , DocShareDetail d  where n.id=d.docid and d.userid= userid_1 and d.usertype = 1 and  (n.docpublishtype='2' or n.docpublishtype='3') and n.docstatus in('1','2','5');
else
    open thecursor for
    Select count(distinct n.id ) countnew from DocDetail n , DocShareDetail d  where n.id=d.docid and d.usertype= usertype_1 and d.userid<= userseclevel_1 and (n.docpublishtype='2' or n.docpublishtype='3') and n.docstatus in('1','2','5');
end if;
end;
/


 CREATE or REPLACE PROCEDURE DocFrontpage_Delete 
	(id_1 	integer ,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
DELETE DocFrontpage 

WHERE 
	( id	 = id_1);
end;
/

 CREATE or REPLACE PROCEDURE DocFrontpage_Insert 
	(frontpagename_1 	varchar2,
	 frontpagedesc_2 	varchar2,
	 isactive_3 	char ,
	 departmentid_4 	integer,
	 linktype_5 	varchar2,
	 hasdocsubject_6 	char ,
	 hasfrontpagelist_7 	char ,
	 newsperpage_8  smallint,
	 titlesperpage_9  smallint,
	 defnewspicid_10 	integer,
	 backgroundpicid_11 	integer,
	 importdocid_12 	integer,
	 headerdocid_13 	integer,
	 footerdocid_14 	integer,
	 secopt_15 	varchar2,
	 seclevelopt_16  smallint,
	 departmentopt_17 	integer,
	 dateopt_18 	integer,
	 languageopt_19 	integer,
	 clauseopt_20 	varchar2,
	 newsclause_21 	varchar2,
	 languageid_22 	integer,
	 publishtype_23 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
INSERT INTO DocFrontpage 
	 ( frontpagename,
	 frontpagedesc,
	 isactive,
	 departmentid,
	 linktype,
	 hasdocsubject,
	 hasfrontpagelist,
	 newsperpage,
	 titlesperpage,
	 defnewspicid,
	 backgroundpicid,
	 importdocid,
	 headerdocid,
	 footerdocid,
	 secopt,
	 seclevelopt,
	 departmentopt,
	 dateopt,
	 languageopt,
	 clauseopt,
	 newsclause,
	 languageid,
	 publishtype) 
 
VALUES 
	( frontpagename_1,
	 frontpagedesc_2,
	 isactive_3,
	 departmentid_4,
	 linktype_5,
	 hasdocsubject_6,
	 hasfrontpagelist_7,
	 newsperpage_8,
	 titlesperpage_9,
	 defnewspicid_10,
	 backgroundpicid_11,
	 importdocid_12,
	 headerdocid_13,
	 footerdocid_14,
	 secopt_15,
	 seclevelopt_16,
	 departmentopt_17,
	 dateopt_18,
	 languageopt_19,
	 clauseopt_20,
	 newsclause_21,
	 languageid_22,
	 publishtype_23);
open thecursor for
select max(id) from DocFrontpage;
end;
/


 CREATE or REPLACE PROCEDURE DocFrontpage_SelectAll 
	(	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
open thecursor for
select * from DocFrontpage order by id;
end;
/














 CREATE or REPLACE PROCEDURE DocFrontpage_SelectByid 
	(id_1  integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
open thecursor for
select * from DocFrontpage where id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE DocFrontpage_SelectDefID 
	(usertype_1 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
open thecursor for
select min(id) from DocFrontpage where publishtype = usertype_1;
end;
/

 CREATE or REPLACE PROCEDURE DocFrontpage_Update 
	(id_1 	integer,
	 frontpagename_2 	varchar2,
	 frontpagedesc_3 	varchar2,
	 isactive_4 	char ,
	 departmentid_5 	integer,
	 hasdocsubject_7 	char ,
	 hasfrontpagelist_8 	char ,
	 newsperpage_9  smallint,
	 titlesperpage_10  smallint,
	 defnewspicid_11 	integer,
	 backgroundpicid_12 	integer,
	 importdocid_13 	integer,
	 headerdocid_14 	integer,
	 footerdocid_15 	integer,
	 secopt_16 	varchar2,
	 seclevelopt_17  smallint,
	 departmentopt_18 	integer,
	 dateopt_19 	integer,
	 languageopt_20 	integer,
	 clauseopt_21 	varchar,
	 newsclause_22 	varchar,
	 languageid_23 	integer,
	 publishtype_24 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
UPDATE DocFrontpage 

SET  frontpagename	 = frontpagename_2,
	 frontpagedesc	 = frontpagedesc_3,
	 isactive	 = isactive_4,
	 departmentid	 = departmentid_5,
	 hasdocsubject	 = hasdocsubject_7,
	 hasfrontpagelist	 = hasfrontpagelist_8,
	 newsperpage	 = newsperpage_9,
	 titlesperpage	 = titlesperpage_10,
	 defnewspicid	 = defnewspicid_11,
	 backgroundpicid	 = backgroundpicid_12,
	 importdocid	 = importdocid_13,
	 headerdocid	 = headerdocid_14,
	 footerdocid	 = footerdocid_15,
	 secopt	 = secopt_16,
	 seclevelopt	 = seclevelopt_17,
	 departmentopt	 = departmentopt_18,
	 dateopt	 = dateopt_19,
	 languageopt	 = languageopt_20,
	 clauseopt	 = clauseopt_21,
	 newsclause	 = newsclause_22,
	 languageid	 = languageid_23,
	 publishtype	 = publishtype_24 

WHERE 
	( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE DocPicUpload_Delete 
	(id_1 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
DELETE DocPicUpload 

WHERE 
	( id = id_1);
end;
/


 CREATE or REPLACE PROCEDURE DocPicUpload_Insert 
	(picname_1 	varchar2,
	 pictype_2 	char ,
	 imagefilename_3 	varchar2,
	 imagefileid_4 	integer,
	 imagefilewidth_5 	smallint,
	 imagefileheight_6 	smallint,
	 imagefilesize_7 	integer,
	 imagefilescale_8 	decimal ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
INSERT INTO DocPicUpload 
	 ( picname,
	 pictype,
	 imagefilename,
	 imagefileid,
	 imagefilewidth,
	 imagefileheight,
	 imagefilesize,
	 imagefilescale) 
 
VALUES 
	( picname_1,
	 pictype_2,
	 imagefilename_3,
	 imagefileid_4,
	 imagefilewidth_5,
	 imagefileheight_6,
	 imagefilesize_7,
	 imagefilescale_8);

	 open thecursor for

select max(id) from DocPicUpload;
end;
/


 CREATE or REPLACE PROCEDURE DocPicUpload_SelectAll 
	(	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
open thecursor for
select * from DocPicUpload ;
end;
/


 CREATE or REPLACE PROCEDURE DocPicUpload_SelectByID 
	(id_1 	integer ,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
open thecursor for
select * from DocPicUpload where id= id_1;
end;
/


 CREATE or REPLACE PROCEDURE DocPicUpload_Update 
	(id_1 	integer,
	 picname_2 	varchar2,
	 pictype_3 	char ,
	 imagefilename_4 	varchar2,
	 imagefileid_5 	integer,
	 imagefilewidth_6 	smallint,
	 imagefileheight_7 	smallint,
	 imagefilesize_8 	integer,
	 imagefilescale_9 	decimal,
	 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
UPDATE DocPicUpload 

SET  picname	 = picname_2,
	 pictype	 = pictype_3,
	 imagefilename	 = imagefilename_4,
	 imagefileid	 = imagefileid_5,
	 imagefilewidth	 = imagefilewidth_6,
	 imagefileheight	 = imagefileheight_7,
	 imagefilesize	 = imagefilesize_8,
	 imagefilescale	 = imagefilescale_9 

WHERE 
	( id	 = id_1);
end;
/


CREATE or REPLACE PROCEDURE DocReadRpSum 
  (fromdate_1	varchar2,
  todate_1	varchar2,
  userid_1       integer,
  flag	out integer, 
  msg 	out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  docid_1	integer ;
  acount_1 integer ;
  doccreaterid_1 integer ;
  docdepartmentid_1 integer ;
  maincategory_1 integer ; 
  begin 
  
  if fromdate_1<>'0' and todate_1 <>'0' then
	  for docid_cursor in( 
	  select * from (select count(t3.id) result,t1.docid resultid from DocDetailLog  t1,DocShareDetail  t2 ,DocDetail  t3 
	  where t2.usertype=1 and operatetype='0' and operatedate > fromdate_1 and operatedate<todate_1 and t1.docid=t2.docid and t1.docid=t3.id and t2.userid=userid_1
	  group by t1.docid order by result desc ) where rownum<51)
	  loop
		  acount_1 :=docid_cursor.result;
		  docid_1 :=docid_cursor.resultid;
		  select maincategory , doccreaterid ,docdepartmentid into maincategory_1, doccreaterid_1 , docdepartmentid_1 from DocDetail where id= docid_1  ;
		  insert into TM_DocReadRpSum values(docid_1,acount_1,doccreaterid_1, docdepartmentid_1,maincategory_1);
          end loop;
  end if ;

  if fromdate_1 ='0' and todate_1 <>'0' then
	  for docid_cursor in( 
	  select * from (select count(t3.id) result,t1.docid resultid from DocDetailLog  t1,DocShareDetail  t2  ,DocDetail  t3 
	  where t2.usertype=1 and  operatetype='0' and operatedate<todate_1 and t1.docid=t2.docid  and t1.docid=t3.id and t2.userid=userid_1
	  group by t1.docid order by result desc ) where rownum<51)
	  loop
		  acount_1 :=docid_cursor.result;
		  docid_1 :=docid_cursor.resultid;
		  select maincategory , doccreaterid ,docdepartmentid into maincategory_1, doccreaterid_1 , docdepartmentid_1 from DocDetail where id= docid_1  ;
		  insert into TM_DocReadRpSum values(docid_1,acount_1,doccreaterid_1, docdepartmentid_1,maincategory_1);
          end loop;
end if;

  if fromdate_1 <>'0' and todate_1 ='0' then
	  for docid_cursor in( 
	  select * from (select count(t3.id) result,t1.docid resultid from DocDetailLog  t1,DocShareDetail  t2 ,DocDetail  t3 
	  where  t2.usertype=1 and operatetype='0' and operatedate>fromdate_1 and t1.docid=t2.docid  and t1.docid=t3.id and t2.userid=userid_1
	  group by t1.docid order by result desc ) where rownum<51)
	  loop
		  acount_1 :=docid_cursor.result;
		  docid_1 :=docid_cursor.resultid;
		  select maincategory , doccreaterid ,docdepartmentid into maincategory_1, doccreaterid_1 , docdepartmentid_1 from DocDetail where id= docid_1  ;
		  insert into TM_DocReadRpSum values(docid_1,acount_1,doccreaterid_1, docdepartmentid_1,maincategory_1);
          end loop;
  end if;
  
  if fromdate_1 ='0' and todate_1 ='0'  then
	  for docid_cursor in( 
	  select * from (select count(t3.id) result,t1.docid resultid from DocDetailLog  t1,DocShareDetail  t2 ,DocDetail  t3 
	  where  t2.usertype=1 and operatetype='0' and t1.docid=t2.docid  and t1.docid=t3.id and t2.userid=userid_1
	  group by t1.docid order by result desc ) where rownum<51) 
	  loop
		  acount_1 :=docid_cursor.result;
		  docid_1 :=docid_cursor.resultid;
		  select maincategory , doccreaterid ,docdepartmentid into maincategory_1, doccreaterid_1 , docdepartmentid_1 from DocDetail where id= docid_1  ;
		  insert into TM_DocReadRpSum values(docid_1,acount_1,doccreaterid_1, docdepartmentid_1,maincategory_1);
          end loop;
  end if;
  open thecursor for
  select * from TM_DocReadRpSum order by acount desc ;
end;
/




 CREATE or REPLACE PROCEDURE DocRpSum 
 (optional_1	varchar2,
 userid_1 integer,
 flag	out integer,
 msg   out  varchar2,
thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
 resultid_1  integer;
 count_1  integer;
 replycount_1  integer ;
 begin
     if   optional_1='doccreater' then
	for resultid_cursor in(
	select * from (select count(id) resultcount,ownerid resultid from docdetail  t1,DocShareDetail  t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 group by ownerid order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1  and doccreaterid=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
        end loop; 
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

     if   optional_1='crm'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,t1.crmid resultid from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 group by t1.crmid order by resultcount desc) where rownum<21) 
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail  t1,DocShareDetail  t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 and t1.crmid=resultid_1 and isreply='1' ; 
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ;
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

     if   optional_1='resource'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,hrmresid resultid from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 group by hrmresid order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail  t1,DocShareDetail  t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 and hrmresid=resultid_1 and isreply='1';
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

    if   optional_1='project' then
	for resultid_cursor in(
	select * from (select count(id) resultcount,projectid resultid from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 group by projectid order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail  t1,DocShareDetail  t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 and projectid=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ; 
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

    if   optional_1='department'  then 
	for resultid_cursor in(
	select * from (select count(id) resultcount,docdepartmentid resultid from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1  group by docdepartmentid order by resultcount desc) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 and docdepartmentid=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ; 
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

   if   optional_1='language'  then 
	for resultid_cursor in(
	select * from (select count(id) resultcount,doclangurage resultid from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 group by doclangurage order by resultcount desc 
	) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 and doclangurage=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ;
        end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

   if   optional_1='item'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,itemid resultid from docdetail t1,DocShareDetail t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 group by itemid order by resultcount desc) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
	select count(id) into replycount_1 from docdetail t1,DocShareDetail t2 where t2.usertype=1 and t1.id=t2.docid and t2.userid=userid_1 and itemid=resultid_1 and isreply='1';
	insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;
end;
/



 CREATE or REPLACE PROCEDURE DocSearchMould_Delete 
	(id_1 	integer,
	 		 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
DELETE DocSearchMould 

WHERE 
	( id	 = id_1);
end;
/

 

CREATE GLOBAL TEMPORARY TABLE temp_table_04
 ( id integer , 
 docsubject varchar2 (200) ,
 doccreatedate char (10),
 doccreatetime char (8))
 ON COMMIT DELETE ROWS
/

 
 
 CREATE or REPLACE PROCEDURE DocFrontpage_SelectAllId 
(
pagenumber_1     integer,
perpage_1        integer,
countnumber_1    integer,
logintype_1		integer,
usertype_1		integer,
userid_1			integer,
userseclevel_1	integer,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
 pagecount_1 integer ; 
 pagecount2_1 integer ; 
 id_1    integer;
 docsubject_1 varchar2(200);
 doccreatedate_1 char(10);
 doccreatetime_1  char(8); 


 CURSOR all_cursor01 is
       select * from(
       Select distinct  n.id, n.docsubject , n.doccreatedate , n.doccreatetime 
       from DocDetail n , DocShareDetail d  
       where 
       n.id=d.docid
       and d.userid=userid_1
       and d.usertype = 1 
       and  (n.docpublishtype='2' or n.docpublishtype='3') 
       and n.docstatus in('1','2','5') 
       order by n.doccreatedate desc , n.doccreatetime desc )
       where rownum<(pagecount_1+1);


 CURSOR all_cursor02 is
       select * from(
       Select  n.id , n.docsubject , n.doccreatedate , n.doccreatetime 
       from DocDetail n , DocShareDetail d  
       where  
       n.id=d.docid
       and d.usertype=usertype_1
       and d.userid<=userseclevel_1 
       and (n.docpublishtype='2' or n.docpublishtype='3')
       and n.docstatus in('1','2','5') 
       order by n.doccreatedate desc, n.doccreatetime desc )
       where rownum< (pagecount_1+1);

 begin

 pagecount_1 :=  pagenumber_1 * perpage_1;
if (countnumber_1 -(pagenumber_1 - 1)*perpage_1) < perpage_1 then       					
 pagecount2_1 := countnumber_1-(pagenumber_1 - 1) * perpage_1;
else 
 pagecount2_1 := perpage_1 ;
end if;

if  logintype_1 = 1 then 
  open all_cursor01;
	loop
		fetch all_cursor01 INTO id_1,docsubject_1,doccreatedate_1, doccreatetime_1; 
		exit when all_cursor01%NOTFOUND;	
		insert into temp_table_04 (id,docsubject,doccreatedate, doccreatetime)
			values (id_1,docsubject_1,doccreatedate_1, doccreatetime_1) ;
	end  loop;
	open thecursor for
        select * from (select * from temp_table_04 order by doccreatedate, doccreatetime)
	where rownum<(pagecount2_1+1);
 end if;

if   logintype_1<>1  then
       open all_cursor02;
         loop
		fetch all_cursor02 INTO id_1,docsubject_1,doccreatedate_1, doccreatetime_1; 
		exit when all_cursor02%NOTFOUND;	
		insert into temp_table_04 (id,docsubject,doccreatedate, doccreatetime)
			values (id_1,docsubject_1,doccreatedate_1, doccreatetime_1) ;
	end  loop;
	open thecursor for       
        select * from(select * from temp_table_04 order by doccreatedate, doccreatetime) 
        where rownum< (pagecount2_1+1);
 end if;

end;
/



/* proc 2 */


create or replace package cursor_define as
	type weavercursor is ref cursor ;
end ;
/

 CREATE or REPLACE PROCEDURE DocSearchMould_Insert 
	( mouldname_1 	varchar2,
	  userid_2 	integer,
	  docsubject_3 	varchar2,
	  doccontent_4 	varchar2,
	  containreply_5 	char,
	  maincategory_6 	integer,
	  subcategory_7 	integer,
	  seccategory_8 	integer,
	  docid_9 	integer,
	  createrid_10 	integer,
	  departmentid_11 	integer,
	  doclangurage_12 	smallint,
	  hrmresid_13 	integer,
	  itemid_14 	integer,
	  itemmaincategoryid_15 	integer,
	  crmid_16 	integer,
	  projectid_17 	integer,
	  financeid_18 	integer,
	  docpublishtype_19 	char,
	  docstatus_20 	char,
	  keyword_21 	varchar2,
	  ownerid_22 	integer,
	  docno_23 	varchar2,
	  doclastmoddatefrom_24 	char,
	  doclastmoddateto_25 	char,
	  docarchivedatefrom_26 	char,
	  docarchivedateto_27 	char,
	  doccreatedatefrom_28 	char,
	  doccreatedateto_29 	char,
	  docapprovedatefrom_30 	char,
	  docapprovedateto_31 	char,
	  replaydoccountfrom_32 	integer,
	  replaydoccountto_33 	integer,
	  accessorycountfrom_34 	integer,
	  accessorycountto_35 	integer,
	  doclastmoduserid_36 	integer,
	  docarchiveuserid_37 	integer,
	  docapproveuserid_38 	integer,
	  assetid_39 	integer,
	  flag out integer,
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 

 INSERT INTO DocSearchMould 
	 (mouldname,
	 userid,
	 docsubject,
	 doccontent,
	 containreply,
	 maincategory,
	 subcategory,
	 seccategory,
	 docid,
	 createrid,
	 departmentid,
	 doclangurage,
	 hrmresid,
	 itemid,
	 itemmaincategoryid,
	 crmid,
	 projectid,
	 financeid,
	 docpublishtype,
	 docstatus,
	 keyword,
	 ownerid,
	 docno,
	 doclastmoddatefrom,
	 doclastmoddateto,
	 docarchivedatefrom,
	 docarchivedateto,
	 doccreatedatefrom,
	 doccreatedateto,
	 docapprovedatefrom,
	 docapprovedateto,
	 replaydoccountfrom,
	 replaydoccountto,
	 accessorycountfrom,
	 accessorycountto,
	 doclastmoduserid,
	 docarchiveuserid,
	 docapproveuserid,
	 assetid) 
 
VALUES 
	( mouldname_1,
	  userid_2,
	  docsubject_3,
	  doccontent_4,
	  containreply_5,
	  maincategory_6,
	  subcategory_7,
	  seccategory_8,
	  docid_9,
	  createrid_10,
	  departmentid_11,
	  doclangurage_12,
	  hrmresid_13,
	  itemid_14,
	  itemmaincategoryid_15,
	  crmid_16,
	  projectid_17,
	  financeid_18,
	  docpublishtype_19,
	  docstatus_20,
	  keyword_21,
	  ownerid_22,
	  docno_23,
	  doclastmoddatefrom_24,
	  doclastmoddateto_25,
	  docarchivedatefrom_26,
	  docarchivedateto_27,
	  doccreatedatefrom_28,
	  doccreatedateto_29,
	  docapprovedatefrom_30,
	  docapprovedateto_31,
	  replaydoccountfrom_32,
	  replaydoccountto_33,
	  accessorycountfrom_34,
	  accessorycountto_35,
	  doclastmoduserid_36,
	  docarchiveuserid_37,
	  docapproveuserid_38,
	  assetid_39);
open thecursor for
select max(id) from DocSearchMould;

end;
/

 CREATE or REPLACE PROCEDURE DocSearchMould_SelectByID 
	( id_1 	integer,
	  flag out integer,
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

select * from DocSearchMould where id= id_1;
 
 end;
/










 CREATE or REPLACE PROCEDURE DocSearchMould_SelectByUserid 
	( userid_1 	integer,
	  flag out integer,
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select id,mouldname from DocSearchMould where userid= userid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocSearchMould_Update 
	( id_1 	integer,
	  mouldname_2 	varchar2,
	  userid_3 	integer,
	  docsubject_4 	varchar2,
	  doccontent_5 	varchar2,
	  containreply_6 	char,
	  maincategory_7 	integer,
	  subcategory_8 	integer,
	  seccategory_9 	integer,
	  docid_10 	integer,
	  createrid_11 	integer,
	  departmentid_12 	integer,
	  doclangurage_13 	smallint,
	  hrmresid_14 	integer,
	  itemid_15 	integer,
	  itemmaincategoryid_16 	integer,
	  crmid_17 	integer,
	  projectid_18 	integer,
	  financeid_19 	integer,
	  docpublishtype_20 	char,
	  docstatus_21 	char,
	  keyword_22 	varchar2,
	  ownerid_23 	integer,
	  docno_24 	varchar2,
	  doclastmoddatefrom_25 	char,
	  doclastmoddateto_26 	char,
	  docarchivedatefrom_27 	char,
	  docarchivedateto_28 	char,
	  doccreatedatefrom_29 	char,
	  doccreatedateto_30 	char,
	  docapprovedatefrom_31 	char,
	  docapprovedateto_32 	char,
	  replaydoccountfrom_33 	integer,
	  replaydoccountto_34 	integer,
	  accessorycountfrom_35 	integer,
	  accessorycountto_36 	integer,
	  doclastmoduserid_37 	integer,
	  docarchiveuserid_38 	integer,
	  docapproveuserid_39 	integer,
	  assetid_40 	integer,
	  flag out integer,
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 

 UPDATE DocSearchMould 

SET  mouldname	 =  mouldname_2,
	 userid	 =  userid_3,
	 docsubject	 =  docsubject_4,
	 doccontent	 =  doccontent_5,
	 containreply	 =  containreply_6,
	 maincategory	 =  maincategory_7,
	 subcategory	 =  subcategory_8,
	 seccategory	 =  seccategory_9,
	 docid	 =  docid_10,
	 createrid	 =  createrid_11,
	 departmentid	 =  departmentid_12,
	 doclangurage	 =  doclangurage_13,
	 hrmresid	 =  hrmresid_14,
	 itemid	 =  itemid_15,
	 itemmaincategoryid	 =  itemmaincategoryid_16,
	 crmid	 =  crmid_17,
	 projectid	 =  projectid_18,
	 financeid	 =  financeid_19,
	 docpublishtype	 =  docpublishtype_20,
	 docstatus	 =  docstatus_21,
	 keyword	 =  keyword_22,
	 ownerid	 =  ownerid_23,
	 docno	 =  docno_24,
	 doclastmoddatefrom	 =  doclastmoddatefrom_25,
	 doclastmoddateto	 =  doclastmoddateto_26,
	 docarchivedatefrom	 =  docarchivedatefrom_27,
	 docarchivedateto	 =  docarchivedateto_28,
	 doccreatedatefrom	 =  doccreatedatefrom_29,
	 doccreatedateto	 =  doccreatedateto_30,
	 docapprovedatefrom	 =  docapprovedatefrom_31,
	 docapprovedateto	 =  docapprovedateto_32,
	 replaydoccountfrom	 =  replaydoccountfrom_33,
	 replaydoccountto	 =  replaydoccountto_34,
	 accessorycountfrom	 =  accessorycountfrom_35,
	 accessorycountto	 =  accessorycountto_36,
	 doclastmoduserid	 =  doclastmoduserid_37,
	 docarchiveuserid	 =  docarchiveuserid_38,
	 docapproveuserid	 =  docapproveuserid_39,
	 assetid	 =  assetid_40 

WHERE 
	( id	 =  id_1);

 end;
/

 CREATE or REPLACE PROCEDURE DocSecCategoryShare_Delete 
	( id_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
	delete from DocSecCategoryShare where id= id_1;
 end;
/

 CREATE or REPLACE PROCEDURE DocSecCategoryShare_Insert 
	(secid_1	integer,
	 sharetype_2	integer,
	 seclevel_3	smallint,
	 rolelevel_4	smallint,
	 sharelevel_5	smallint,
	 userid_6	integer,
	 subcompanyid_7	integer,
	 departmentid_8	integer,
	 roleid_9	integer,
	 foralluser_10	smallint,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	insert into DocSecCategoryShare
	(seccategoryid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser)
	values(secid_1,sharetype_2,seclevel_3,rolelevel_4,sharelevel_5,userid_6,subcompanyid_7,departmentid_8,roleid_9,foralluser_10);

 end;
/

 CREATE or REPLACE PROCEDURE DocSecCategoryShare_SBySecCate 
( seccategoryid_1  	integer, 
 flag                             out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for 
 
select * from DocSecCategoryShare 
where seccategoryid  =  seccategoryid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocSecCategoryShare_SBySecID 
	( secid	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select * from DocSecCategoryShare where seccategoryid= secid;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocSecCategory_SByCustomerType 
	( cusertype_1 	integer,
	  cuserseclevel_2 	smallint,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select id,subcategoryid from DocSecCategory where cusertype=  cusertype_1 and cuserseclevel<= cuserseclevel_2  order by subcategoryid;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocShareDetail_DeleteByDocId 
	( docid_1 	integer ,
	  flag	out  integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 
 
 DELETE FROM DocShareDetail 

WHERE 
	( docid	 =  docid_1);

 end;
/

 CREATE or REPLACE PROCEDURE DocShareDetail_DeleteByUserId 
	( userid_1 	integer ,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 

 DELETE DocShareDetail 

WHERE 
	( userid	 =  userid_1  and usertype = '1' );

 end;
/

 CREATE or REPLACE PROCEDURE DocShareDetail_Insert 
	( docid_1 	integer,
	  userid_2 	integer,
	  usertype_3 	integer,
	  sharelevel_4 	integer ,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 

 INSERT into DocShareDetail 
	 ( docid,
	 userid,
	 usertype,
	 sharelevel) 
 
VALUES 
	(  docid_1,
	  userid_2,
	  usertype_3,
	  sharelevel_4);

 end;
/

 CREATE or REPLACE PROCEDURE DocShareDetail_SByResourceId 
	( resourceid_1 integer ,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 
open thecursor for 
 
select docid , sharelevel from DocShareDetail where userid =  resourceid_1 and usertype = '1';  
 
 end;
/

 CREATE or REPLACE PROCEDURE DocShareDetail_SelectByDocId 
	( docid_1 integer ,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 
open thecursor for 
 
select * from DocShareDetail where docid =  docid_1; 
 
 end;
/

 CREATE or REPLACE PROCEDURE DocShare_Delete 
	( id	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 


	delete from DocShare where id= id;

 end;
/

 CREATE or REPLACE PROCEDURE DocShare_IFromDocSecCategory 
       ( docid_1          integer,
	 sharetype_2	integer,
	 seclevel_3	smallint,
	 rolelevel_4	smallint,
	 sharelevel_5	smallint,
	 userid_6	integer,
	 subcompanyid_7	integer,
	 departmentid_8	integer,
	 roleid_9	integer,
	 foralluser_10	smallint,
	 crmid_11	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 


	insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid) 
	values( docid_1, sharetype_2, seclevel_3, rolelevel_4, sharelevel_5, userid_6, subcompanyid_7, departmentid_8, roleid_9, foralluser_10, crmid_11);

 end;
/

 CREATE or REPLACE PROCEDURE DocShare_SelectByDocID 
	( docid_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select * from DocShare where docid =  docid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocSysDefault_Update 
	( fgpicwidth_1	smallint,
	 fgpicfixtype_2	char,
	 docdefmouldid_3	integer,
	 docapprovewfid_4 integer ,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	update DocSysDefault 
	set fgpicwidth= fgpicwidth_1,fgpicfixtype= fgpicfixtype_2,docdefmouldid= docdefmouldid_3,docapprovewfid= docapprovewfid_4; 

 end;
/

 CREATE or REPLACE PROCEDURE DocUserCategory_DByCategory 
	 (secid_1	integer, 
	 flag	out integer, 
	 msg	out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
	delete from DocUserCategory where secid= secid_1 ;

 end;
/

 CREATE or REPLACE PROCEDURE DocUserCategory_DeleleByUser 
	 (userid_1	integer, 
	 usertype_2	char,
	 flag	out integer, 
	 msg	out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 


	delete from DocUserCategory where userid= userid_1 and usertype= usertype_2;

 end;
/

CREATE or REPLACE PROCEDURE DocUserCategory_IByCategory 
	 (secid_1	integer, 
	 flag	out integer, 
	 msg	varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as
		 mainid_1	integer;
		 subid_1	integer;
		 userid_1	integer;
		 cusertype_1	char;
		 cuserseclevel_1	smallint;
		 cdepartmentid1_1	integer;
		 cdepseclevel1_1	smallint;
		 cdepartmentid2_1	integer;
		 cdepseclevel2_1	smallint;
		 croleid1_1		integer;
		 crolelevel1_1	char;
		 croleid2_1		integer;
		 crolelevel2_1	char;
		 croleid3_1		integer;
		 crolelevel3_1	char;
		 usertype_1		char;
		 recordcount integer;
		 mainid_count integer;
begin 
	    select  count(*) 
		into recordcount 
		from docseccategory where id= secid_1;
	
	if recordcount>0 then
     
     		select  subcategoryid, cusertype, cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,
		cdepseclevel2, croleid1, crolelevel1, croleid2, crolelevel2, croleid3, crolelevel3 
		into subid_1,cusertype_1,cuserseclevel_1,cdepartmentid1_1,cdepseclevel1_1,cdepartmentid2_1,
		cdepseclevel2_1,croleid1_1,crolelevel1_1,croleid2_1,crolelevel2_1,croleid3_1,crolelevel3_1 
		from docseccategory where id= secid_1;
	end if;


    	select  count(maincategoryid) into mainid_count from docsubcategory where id= subid_1;
       if mainid_count>0 then
	    
	select  maincategoryid into mainid_1 from docsubcategory where id= subid_1;
	end if;
	
	if  cusertype_1 ='0' then
			usertype_1:='0';
			
			FOR all_cursor in (
			select id from hrmresource where seclevel>= cuserseclevel_1
			union
			select t1.id id from hrmresource t1,hrmdepartment t2 where 
			(t1.seclevel>= cdepseclevel1_1 and t2.id= cdepartmentid1_1 and t1.departmentid=t2.id)
			or (t1.seclevel>= cdepseclevel2_1 and t2.id= cdepartmentid2_1 and t1.departmentid=t2.id)
			union
			select t1.id id from hrmresource t1,hrmroles t2,hrmrolemembers t3 where 
			(t1.id=t3.resourceid and t3.roleid=t2.id and t2.id= croleid1_1 and t3.rolelevel>= crolelevel1_1)
			or (t1.id=t3.resourceid and t3.roleid=t2.id and t2.id= croleid2_1 and t3.rolelevel>= crolelevel2_1)
			or (t1.id=t3.resourceid and t3.roleid=t2.id and t2.id= croleid3_1 and t3.rolelevel>= crolelevel3_1) )
			
			loop 
				userid_1 := all_cursor.id  ;   
				insert into  docusercategory (secid,mainid,subid,userid,usertype)
				values ( secid_1, mainid_1, subid_1, userid_1, usertype_1) ;
			end loop;
	else
			usertype_1 := '1' ;
			FOR all_cursor in (
			select id from crm_customerinfo where type= cusertype_1 and seclevel>= cuserseclevel_1 )
			
			loop
                        userid_1 := all_cursor.id  ;
					insert into  docusercategory (secid,mainid,subid,userid,usertype)
					values ( secid_1, mainid_1, subid_1, userid_1, usertype_1) ;
			end loop ;
	end if ;
 end;
/


 CREATE or REPLACE PROCEDURE DocUserCategory_InsertByUser 
	 (userid_1	integer, 
	 usertype_1 char,
	 flag	out integer, 
	 msg	varchar2 , 
thecursor IN OUT cursor_define.weavercursor)
as
mainid_1	integer;
subid_1	integer;
secid_1	integer;
seclevel_1	smallint;
crmtype_1	integer;
begin 
			
	if  usertype_1='0' then 
		
			for  all_cursor in(
			select distinct t1.id id from docseccategory t1,hrmresource t2,hrmrolemembers t5
			where t1.cusertype='0' and t2.id= userid_1 
			and(( t2.seclevel>=t1.cuserseclevel) 
			or( t2.seclevel >= t1.cdepseclevel1 and t2.departmentid=t1.cdepartmentid1) 
			or( t2.seclevel >= t1.cdepseclevel2 and t2.departmentid=t1.cdepartmentid2) 
			or( t5.roleid=t1.croleid1 and t5.rolelevel=t1.crolelevel1 and t2.id=t5.resourceid )
			or( t5.roleid=t1.croleid2 and t5.rolelevel=t1.crolelevel2 and t2.id=t5.resourceid )
			or( t5.roleid=t1.croleid3 and t5.rolelevel=t1.crolelevel3 and t2.id=t5.resourceid )))
			loop
				secid_1 := all_cursor.id;
				select  subcategoryid into subid_1 from docseccategory where id= secid_1;
				select  maincategoryid into mainid_1 from docsubcategory where id= subid_1;
				insert into  docusercategory (secid,mainid,subid,userid,usertype)
				values (secid_1,mainid_1,subid_1,userid_1,usertype_1);
			end loop;
		
	else
			select  type , seclevel into crmtype_1, seclevel_1 from crm_customerinfo where id= userid_1;
			for  all_cursor in(
			select id from DocSecCategory 
			where cusertype= crmtype_1 and cuserseclevel<= seclevel_1 )
			loop
				select  subcategoryid into subid_1 from docseccategory where id= secid_1;
				select  maincategoryid into mainid_1 from docsubcategory where id= subid_1;
				insert into  docusercategory (secid,mainid,subid,userid,usertype)
				values (secid_1,mainid_1,subid_1,userid_1,usertype_1);
			end loop;
	end if;

 end;
/

/* -------------- 8.30 -----------*/

 CREATE or REPLACE PROCEDURE DocUserCategory_SMainByUser 
	 (userid_1	integer, 
	 usertype_2	char,
	 flag	out integer, 
	 msg	out varchar2,
	 thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
	
open thecursor for 
	select id as mainid from DocMainCategory 
	where id in ( select distinct mainid from docusercategory where userid= userid_1 and usertype= usertype_2 )
	order by categoryorder; 
 end;
/

 CREATE or REPLACE PROCEDURE DocUserCategory_SSecByUser 
	 (userid_1	integer, 
	 usertype_2	char,
	 flag	out integer, 
	 msg	varchar2,
	 thecursor IN OUT cursor_define.weavercursor )
as 
begin 
open thecursor for 
 
	select distinct secid from docusercategory where userid= userid_1 and usertype= usertype_2;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocUserCategory_SSubByUser 
	 (userid_1	integer, 
	 usertype_2	char,
	 flag	out integer, 
	 msg	varchar2,
	 thecursor IN OUT cursor_define.weavercursor )
as 
begin 
open thecursor for 
 
	select distinct subid from docusercategory where userid= userid_1 and usertype= usertype_2;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocUserCategory_SelectByUserId 
	( userid_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select * from DocShare where userid =  userid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocUserView_DeletebyDocId 
( docid_1 	integer,
  flag	out integer,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
 
	delete from DocUserView where docid= docid_1;

 end;
/

 CREATE or REPLACE PROCEDURE DocUserView_DeletebyUserId 
( userid_1 	integer,
  flag	out integer,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	delete from DocUserView where userid= userid_1;
 end;
/

 CREATE or REPLACE PROCEDURE DocUserView_InsertByUser 
     (seclevel_1 integer,
     departmentid_1 integer,
     subcompanyid_1 integer,
     userid_1	integer, 
     flag	out integer, 
     msg	varchar2 , 
thecursor IN OUT cursor_define.weavercursor)
as 
docid_1	integer;
 cursor all_cursor is
  select Distinct docid from DocShare  where sharetype=5 or (sharetype=3 and  seclevel>=seclevel_1 and  departmentid= departmentid_1) 
  OR (sharetype=2 and  seclevel>= seclevel_1 and  subcompanyid= subcompanyid_1) ;

begin 
  
  OPEN  all_cursor ;
  FETCH all_cursor into  docid_1;  
  while all_cursor%found 
  loop
            insert into DocUserView (docid,userid) values ( docid_1 ,  userid_1);
            FETCH all_cursor into  docid_1 ;
  end loop;
 end;
/

 CREATE or REPLACE PROCEDURE DocUserView_SelectByDocId 
( docid_1 	integer,
  flag	out integer,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select userid from DocUserView where docid= docid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE DocUserView_SelectCopyByUserId 
( secid_1  integer,
  userid_2 	integer,
  flag	out integer,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select t1.id,t1.docsubject,t1.doccreaterid,t1.doccreatedate,t1.docstatus  
from DocDetail t1, DocUserView t2 where t1.id=t2.docid and t1.seccategory=secid_1 
and t2.userid=userid_2;
end;
/

 CREATE or REPLACE PROCEDURE DocUserView_SelectbyUserId 
( userid_1 	integer,
  flag	out integer,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select docid from DocUserView where userid= userid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE Doc_SecCategory_Delete 
	( id_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 


	delete from Docseccategory where id= id_1;

 end;
/

 CREATE or REPLACE PROCEDURE Doc_SecCategory_Insert 
	(
	  subcategoryid_1 	integer,
	  categoryname_2 	varchar2,
	  docmouldid_3 	integer,
	  publishable_4 	char,
	  replyable_5 	char,
	  shareable_6 	char,
	  cusertype_7 	integer,
	  cuserseclevel_8 	smallint,
	  cdepartmentid1_9 	integer,
	  cdepseclevel1_10 	smallint,
	  cdepartmentid2_11 	integer,
	  cdepseclevel2_12 	smallint,
	  croleid1_13	 		integer,
	  crolelevel1_14	 	char,
	  croleid2_15	 	integer,
	  crolelevel2_16 	char,
	  croleid3_17	 	integer,
	  crolelevel3_18 	char,
	  hasaccessory_19	 	char,
	  accessorynum_20	 	smallint,
	  hasasset_21		 	char,
	  assetlabel_22	 	varchar2,
	  hasitems_23	 	char,
	  itemlabel_24 	varchar2,
	  hashrmres_25 	char,
	  hrmreslabel_26 	varchar2,
	  hascrm_27	 	char,
	  crmlabel_28	 	varchar2,
	  hasproject_29 	char,
	  projectlabel_30 	varchar2,
	  hasfinance_31 	char,
	  financelabel_32 	varchar2,
	  approveworkflowid_33	integer,	
	  flag	out integer,
	 msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	insert into docseccategory 
	(subcategoryid  ,
	categoryname  ,
	docmouldid  ,
	publishable  ,
	replyable  ,
	shareable  ,
	cusertype  ,
	cuserseclevel  ,
	cdepartmentid1  ,
	cdepseclevel1  ,
	cdepartmentid2  ,
	cdepseclevel2  ,
	croleid1 ,
	crolelevel1  ,
	croleid2  ,
	crolelevel2 ,
	croleid3  ,
	crolelevel3  ,
	hasaccessory  ,
	accessorynum  ,
	hasasset  ,
	assetlabel  ,
	hasitems  ,
	itemlabel  ,
	hashrmres ,
	hrmreslabel  ,
	hascrm  ,
	crmlabel  ,
	hasproject  ,
	projectlabel  ,
	hasfinance  ,
	financelabel  ,
	approveworkflowid )
	values(
	  subcategoryid_1 	,
	  categoryname_2 	,
	  docmouldid_3 		,
	  publishable_4		,
	  replyable_5 		,
	  shareable_6 		,
	  cusertype_7 		,
	  cuserseclevel_8 	,
	  cdepartmentid1_9 	,
	  cdepseclevel1_10 	,
	  cdepartmentid2_11 	,
	  cdepseclevel2_12 	,
	  croleid1_13	 	,
	  crolelevel1_14	,
	  croleid2_15	 	,
	  crolelevel2_16 	,
	  croleid3_17	 	,
	  crolelevel3_18 	,
	  hasaccessory_19	,
	  accessorynum_20	,
	  hasasset_21		,
	  assetlabel_22	 	,
	  hasitems_23	 	,
	  itemlabel_24 		,
	  hashrmres_25 		,
	  hrmreslabel_26 	,
	  hascrm_27	 	,
	  crmlabel_28	 	,
	  hasproject_29 	,
	  projectlabel_30 	,
	  hasfinance_31 	,
	  financelabel_32 	,
	  approveworkflowid_33	);
open thecursor for 
	select max(id) from docseccategory;
 
 end;
/

 CREATE or REPLACE PROCEDURE Doc_SecCategory_SelectByID 
	( id_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select * from docseccategory where id= id_1;
 end;
/

 CREATE or REPLACE PROCEDURE Doc_SecCategory_Update 
	( id_1	integer,
	  subcategoryid_2 	integer,
	  categoryname_3 	varchar2,
	  docmouldid_4 	integer,
	  publishable_5 	char,
	  replyable_6 	char,
	  shareable_7 	char,
	  cusertype_8 	integer,
	  cuserseclevel_9 	smallint,
	  cdepartmentid1_10 	integer,
	  cdepseclevel1_11 	smallint,
	  cdepartmentid2_12 	integer,
	  cdepseclevel2_13 	smallint,
	  croleid1_14	 		integer,
	  crolelevel1_15	 	char,
	  croleid2_16	 	integer,
	  crolelevel2_17 	char,
	  croleid3_18	 	integer,
	  crolelevel3_19 	char,
	  hasaccessory_20	 	char,
	  accessorynum_21	 	smallint,
	  hasasset_22		 	char,
	  assetlabel_23	 	varchar2,
	  hasitems_24	 	char,
	  itemlabel_25 	varchar2,
	  hashrmres_26 	char,
	  hrmreslabel_27 	varchar2,
	  hascrm_28	 	char,
	  crmlabel_29	 	varchar2,
	  hasproject_30 	char,
	  projectlabel_31 	varchar2,
	  hasfinance_32 	char,
	  financelabel_33 	varchar2,
	  approveworkflowid_34	integer,
	  flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	update docseccategory 
	set
	 subcategoryid= subcategoryid_2,
	 categoryname= categoryname_3,
	 docmouldid= docmouldid_4,
	 publishable= publishable_5,
	 replyable= replyable_6,
	 shareable= shareable_7,
	 cusertype= cusertype_8,
	 cuserseclevel= cuserseclevel_9,
	 cdepartmentid1= cdepartmentid1_10,
	 cdepseclevel1= cdepseclevel1_11,
	 cdepartmentid2= cdepartmentid2_12,
	 cdepseclevel2= cdepseclevel2_13,
	 croleid1= croleid1_14,
	 crolelevel1= crolelevel1_15,
	 croleid2= croleid2_16,
	 crolelevel2= crolelevel2_17,
	 croleid3= croleid3_18,
	 crolelevel3= crolelevel3_19,
	 approveworkflowid= approveworkflowid_34,
	 hasaccessory= hasaccessory_20,
	 accessorynum= accessorynum_21,
	 hasasset= hasasset_22,
	 assetlabel= assetlabel_23,
	 hasitems= hasitems_24,
	 itemlabel= itemlabel_25,
	 hashrmres= hashrmres_26,
	 hrmreslabel= hrmreslabel_27,
	 hascrm= hascrm_28,
	 crmlabel= crmlabel_29,
	 hasproject= hasproject_30,
	 projectlabel= projectlabel_31,
	 hasfinance= hasfinance_32,
	 financelabel= financelabel_33
	where id= id_1;

 end;
/

CREATE or replace PROCEDURE FnaAccountList_Process 
(departmentid_1 	integer,
tranperiods_2    char, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
count_1 integer;
ledgerid_1 integer;
tranid_1 integer;
tranperiods_1 char(6);
tranmark_1 integer;
trandate_1 char(10); 
tranremark_1 varchar2(200);
tranaccount_1 number(18,3);
tranbalance_1 char(1);

cursor transaction_cursor is
select ledgerid, t.id, tranperiods, tranmark, trandate, d.tranremark, tranaccount, tranbalance 
from FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid
and trandepartmentid = departmentid_1 and tranperiods = tranperiods_2 and transtatus = '1';

begin
select count(id) into count_1 from FnaYearsPeriodsList 
where fnayearperiodsid < tranperiods_2 and isactive = '1' and isclose ='0' ;
 
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return;
end if;
  
open transaction_cursor;
fetch transaction_cursor into ledgerid_1,tranid_1,tranperiods_1,
tranmark_1,trandate_1, tranremark_1,tranaccount_1,tranbalance_1;
while transaction_cursor%found loop
insert into FnaAccountList ( ledgerid, tranid, tranperiods, tranmark, trandate, tranremark, 
tranaccount, tranbalance)  VALUES ( ledgerid_1, tranid_1, tranperiods_1, tranmark_1, trandate_1, 
tranremark_1, tranaccount_1, tranbalance_1);
 end loop;
 close transaction_cursor; 
update FnaTransaction set transtatus = '2' where trandepartmentid = departmentid_1 
and tranperiods = tranperiods_2 and transtatus = '1';
end;
/

 CREATE or REPLACE PROCEDURE FnaAccountList_Select 
  (ledgerid_0 	integer,  
  periods_1    char, 
  periods_2    char, 
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
count_1 integer;  
ledgerid_1 integer ; 
tranmark_1 integer ; 
trandate_1 char(10); 
tranremark_1 varchar2(200);
tranid_1 integer;
tranaccount_1 number(18,3);
tranremain_1 number(18,3); 
tranbalance_1 char(1);
tmptranperiods_1 char(6);
tranremain_1_count integer;

begin 
 
 

if   ledgerid_0 = 0 then 

	 for account_cursor in ( select ledgerid,tranid,tranmark,trandate,tranremark,tranaccount, tranbalance from  FnaAccountList where tranperiods >=  periods_1 and  tranperiods <=  periods_2  )
	 
	loop 
		ledgerid_1 := account_cursor.ledgerid ;
		tranid_1 := account_cursor.tranid ;
		tranmark_1 := account_cursor.tranmark ;
		trandate_1 := account_cursor.trandate ;
		tranremark_1 := account_cursor.tranremark ;
		tranaccount_1 := account_cursor.tranaccount ;
		tranbalance_1 := account_cursor.tranbalance ; 

		insert into TM_FnaAccountList_Select values( ledgerid_1, tranid_1, tranmark_1, trandate_1, tranremark_1, tranaccount_1, tranbalance_1) ;
	 end loop ;
	 
	 for ledger_cursor in ( select ledgerid from TM_FnaAccountList_Select group by ledgerid ) 
	 loop
		ledgerid_1 :=  ledger_cursor.ledgerid ;
		tranremain_1 := 0 ;
		select  count(id) , max(tranperiods) into count_1, tmptranperiods_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods <  periods_1 ;

		if  count_1 <> 0 then
		
			select  tranremain into tranremain_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods =  tmptranperiods_1 ;
		end if ;
		
		insert into TM_FnaAccountList_Select values( ledgerid_1,0,0,null,null, tranremain_1,null) ;
	 end loop ;

	 open thecursor for 
	 select * from TM_FnaAccountList_Select order by ledgerid , tranmark ;
 
else 

	 for account_cursor in ( select ledgerid,tranid,tranmark,trandate,tranremark,tranaccount, tranbalance from  FnaAccountList where tranperiods >=  periods_1 and  tranperiods <=  periods_2 and ledgerid =  ledgerid_0  )
	 
	 loop
		ledgerid_1 := account_cursor.ledgerid ;
		tranid_1 := account_cursor.tranid ;
		tranmark_1 := account_cursor.tranmark ;
		trandate_1 := account_cursor.trandate ;
		tranremark_1 := account_cursor.tranremark ;
		tranaccount_1 := account_cursor.tranaccount ;
		tranbalance_1 := account_cursor.tranbalance ;

		insert into TM_FnaAccountList_Select values( ledgerid_1, tranid_1, tranmark_1, trandate_1, tranremark_1, tranaccount_1, tranbalance_1) ;
	 end loop ;

	 tranremain_1 := 0 ;
	 select  count(id) , max(tranperiods) into count_1, tmptranperiods_1 from FnaAccount where ledgerid =  ledgerid_0 and tranperiods <  periods_1 ;
	 if  count_1 <> 0 then

	  select  count(tranremain) into tranremain_1_count from FnaAccount where ledgerid =  ledgerid_0 and tranperiods =  tmptranperiods_1 ;
	  if tranremain_1_count =0 then
	  tranremain_1_count :=null;
	  else
		 select  tranremain into tranremain_1 from FnaAccount where ledgerid =  ledgerid_0 and tranperiods =  tmptranperiods_1 ;
		 end if;
	 end if ;
	 
	 insert into TM_FnaAccountList_Select values( ledgerid_1,0,0,null,null, tranremain_1,null) ; 
	 
	 open thecursor for 
	 select * from TM_FnaAccountList_Select order by ledgerid , tranmark ;
end if ;
 
 end;
/

CREATE or REPLACE PROCEDURE FnaAccount_Select 
  (ledgerid_0 	integer,  
  periods_1    char, 
  periods_2    char,  
  flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
count_1 integer; 
 ledgerid_1 integer ;
 tranperiods_1 char(6);
 trandaccount_1 decimal(18,3);
trancaccount_1 decimal(18,3); 
tranremain_1 decimal(18,3); 
tmptranperiods_1 char(6);  

begin 

if  ledgerid_0 = 0 then

	for account_cursor in (select ledgerid,tranperiods,trandaccount,trancaccount,tranremain from  FnaAccount where tranperiods >=  periods_1 and  tranperiods <=  periods_2 )
	loop
		ledgerid_1 := account_cursor.ledgerid;
		tranperiods_1 := account_cursor.tranperiods;
		trandaccount_1 := account_cursor.trandaccount;
		trancaccount_1 := account_cursor.trancaccount;
		tranremain_1 := account_cursor.tranremain;
		insert into TM_FnaAccount_Select values( ledgerid_1, tranperiods_1, trandaccount_1, trancaccount_1, tranremain_1);
	end loop;

	for ledger_cursor in (select ledgerid from TM_FnaAccount_Select group by ledgerid)
	loop
		ledgerid_1 := ledger_cursor.ledgerid;
		tranremain_1 := 0 ;
		select  count(id), max(tranperiods) into count_1,tmptranperiods_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods <  periods_1 ;
		if  count_1 <> 0 then 
		select  tranremain  into tranremain_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods =  tmptranperiods_1 ;
		end if;
		insert into TM_FnaAccount_Select values( ledgerid_1,null,null,null, tranremain_1); 
	end loop;
	open thecursor for
	select * from TM_FnaAccount_Select order by ledgerid , tranperiods;
	
else

	for account1_cursor in (select tranperiods,trandaccount,trancaccount,tranremain from  FnaAccount where tranperiods >=  periods_1 and  tranperiods <=  periods_2 and ledgerid =  ledgerid_0 )
	loop
		tranperiods_1 := account1_cursor.tranperiods ;
		trandaccount_1 := account1_cursor.trandaccount ;
		trancaccount_1 := account1_cursor.trancaccount ;
		tranremain_1 := account1_cursor.tranremain ;
		insert into TM_FnaAccount_Select values( ledgerid_0, tranperiods_1, trandaccount_1, trancaccount_1, tranremain_1) ; 
	end loop;
	tranremain_1 := 0; 
	select  count(id) , max(tranperiods) into count_1 , tmptranperiods_1 from FnaAccount where ledgerid =  ledgerid_0 and tranperiods <  periods_1;
	if  count_1 <> 0 then	
	select  tranremain into tranremain_1 from FnaAccount where ledgerid =  ledgerid_0 and tranperiods =  tmptranperiods_1 ;
	end if;
	insert into TM_FnaAccount_Select values( ledgerid_0,null,null,null, tranremain_1);
	open thecursor for
	select * from TM_FnaAccount_Select order by ledgerid , tranperiods; 
 end if;	
 end;
/

CREATE or REPLACE PROCEDURE FnaAccount_SelectBalance 
 (periodsfrom_1  char , 
 periodsto_1   in out  char ,  
 searchtype_1    integer ,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
 thelastperiods_1  char(6) ;
 thenewperiods_1 char(6); 
 ledgerid_1 integer ;
 precount_1 decimal(18,3) ; 
 lastcount_1 decimal(18,3);
 c_count integer;
begin 
   select  count(tranperiods) into c_count from FnaAccount where tranperiods <  periodsfrom_1; 
if(c_count >0) then

    select  max(tranperiods) into thelastperiods_1 from FnaAccount where tranperiods <  periodsfrom_1; 
    if  thelastperiods_1 = null then
	 thelastperiods_1 := '000000';
    end if;   
    select max(tranperiods) into thenewperiods_1 from FnaAccount; 
    if  thenewperiods_1 <  periodsto_1  then
	periodsto_1 :=  thenewperiods_1 ;
    end if;  
end if;
    if  searchtype_1 = 1 then
	for ledgerid_cursor in(select id from FnaLedger where supledgerid =0 and ledgergroup ='1' )
	loop
		ledgerid_1 :=ledgerid_cursor.id;
		precount_1 := 0; 
		lastcount_1 := 0; 
		if  thelastperiods_1 = '000000' then
			select  tranremain  into precount_1  from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  thelastperiods_1;
		else 
			select  (-2*to_number(tranbalance)+3)*tranremain  into precount_1  from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  thelastperiods_1; 
			select  (-2*to_number(tranbalance)+3)*tranremain  into lastcount_1  from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  periodsto_1;  
			insert into TM_FnaAccount_SelectBalance values( ledgerid_1, precount_1, lastcount_1);
		end if;
	end loop;
	open thecursor for
	select * from TM_FnaAccount_SelectBalance ; 
    end if ;

    if  searchtype_1 = 2 then

	for ledgerid_cursor in(select id from FnaLedger where supledgerid =0 and ledgergroup ='2' )
	loop
		ledgerid_1 := ledgerid_cursor.id;
		precount_1 := 0 ;
		lastcount_1 := 0 ;
		if  thelastperiods_1 = '000000' then
			select  tranremain into precount_1  from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  thelastperiods_1;
		else 
			select  (2*to_number(tranbalance)-3)*tranremain into precount_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  thelastperiods_1 ;
			select  (2*to_number(tranbalance)-3)*tranremain into lastcount_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  periodsto_1;  
			insert into TM_FnaAccount_SelectBalance values( ledgerid_1, precount_1, lastcount_1);
		end if;
	end loop;
	open thecursor for
	select * from TM_FnaAccount_SelectBalance ; 
    end if; 
    if  searchtype_1 = 3 then

	for ledgerid_cursor in(select id from FnaLedger where supledgerid =0 and ledgergroup ='3')
	loop
		ledgerid_1 := ledgerid_cursor.id;
		precount_1 := 0 ;
		lastcount_1 := 0 ;
		if  thelastperiods_1 = '000000' then
			select  tranremain  into  precount_1  from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  thelastperiods_1 ;
		else 
			select  (2*to_number(tranbalance)-3)*tranremain into precount_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  thelastperiods_1 ;
			select  (2*to_number(tranbalance)-3)*tranremain  into lastcount_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods=  periodsto_1 ;
			insert into TM_FnaAccount_SelectBalance values( ledgerid_1, precount_1, lastcount_1); 
		end if;
	end loop;
	open thecursor for
	select * from TM_FnaAccount_SelectBalance ;
    end if;

end;
/

 CREATE or REPLACE PROCEDURE FnaAccount_SelectPL 
 ( periodsfrom_1  char , 
 periodsto_1     char ,
 lastperiodsfrom_1  char , 
 lastperiodsto_1  char ,  
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
 ledgerid_1 integer ; 
 precount_1 decimal(18,3) ; 
 lastcount_1 decimal(18,3) ;
begin 

 for ledgerid_cursor in(select id from FnaLedger where supledgerid =0 and ledgergroup ='5' )
 loop
	 ledgerid_1 := ledgerid_cursor.id ;
	 precount_1 := 0 ;
	 lastcount_1 := 0 ;
	 select  sum(trancaccount)-sum(trandaccount) into precount_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods >=  lastperiodsfrom_1 and tranperiods <=  lastperiodsto_1 ;
	 select  sum(trancaccount)-sum(trandaccount) into lastcount_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods >=  periodsfrom_1 and tranperiods <=  periodsto_1  ;
	 insert into TM_FnaAccount_SelectPL values( ledgerid_1, precount_1, lastcount_1); 
 end loop;
 open thecursor for 
 select * from TM_FnaAccount_SelectPL;
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetDetail_Insert 
 ( budgetid_1 	integer,  
 ledgerid_2 	integer, 
 budgetcrmid_3 	integer, 
 budgetitemid_4 	integer,  
 budgetdocid_5 	integer,  
 budgetprojectid_6 	integer, 
 budgetaccount_7 	decimal,  
 budgetdefaccount_8 	decimal,  
 budgetremark_9 	varchar2,  
 flag out integer , 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
 as 
begin 

 INSERT into FnaBudgetDetail ( budgetid, ledgerid, budgetcrmid, budgetitemid, budgetdocid, budgetprojectid, budgetaccount, budgetdefaccount, budgetremark)  
 VALUES (  budgetid_1,  ledgerid_2,  budgetcrmid_3,  budgetitemid_4,  budgetdocid_5,  budgetprojectid_6,  budgetaccount_7,  budgetdefaccount_8,  budgetremark_9); 

 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetDetail_SByBudgetID 
 ( id_1 	integer,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) as 
begin 
open thecursor for 
 select * from FnaBudgetDetail where budgetid =  id_1 ;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetList_Process 
  (departmentid_1 	integer,  
  periodsfrom_2    char,
  periodsto_2      char, 
  flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 

 ledgerid_1 integer ;
 budgetid_1 integer ; 
 budgetmoduleid_1 integer ;
 budgetperiods_1 char(6); 

 budgetdepartmentid_1 integer;
 budgetcostcenterid_1 integer;
 budgetresourceid_1 integer;

 budgetremark_1 varchar2(200);
 budgetaccount_1 decimal(18,3); 

begin 
 
 for budget_cursor in(select ledgerid, b.id budgetid, budgetmoduleid, budgetperiods, budgetdepartmentid, budgetcostercenterid, budgetresourceid, d.budgetremark , budgetdefaccount from FnaBudget b , FnaBudgetDetail d where b.id = d.budgetid and budgetdepartmentid =  departmentid_1 and budgetperiods >=  periodsfrom_2 and budgetperiods <=  periodsto_2 and budgetstatus = '1' )
 loop
	 
	 ledgerid_1 := budget_cursor.ledgerid ;
	 budgetid_1 := budget_cursor.budgetid ;
	 budgetmoduleid_1 := budget_cursor.budgetmoduleid ;
	 budgetperiods_1 := budget_cursor.budgetperiods ;
	 budgetdepartmentid_1 := budget_cursor.budgetdepartmentid ;
	 budgetcostcenterid_1 := budget_cursor.budgetcostercenterid ;
	 budgetresourceid_1 := budget_cursor.budgetresourceid ;
	 budgetremark_1 := budget_cursor.budgetremark ;
	 budgetaccount_1  := budget_cursor.budgetdefaccount ;	
	 
	 insert into FnaBudgetList ( ledgerid, budgetid, budgetmoduleid, budgetperiods, budgetdepartmentid, budgetcostcenterid, budgetresourceid, budgetremark, budgetaccount)  VALUES ( ledgerid_1, budgetid_1, budgetmoduleid_1, budgetperiods_1, budgetdepartmentid_1, budgetcostcenterid_1, budgetresourceid_1, budgetremark_1, budgetaccount_1);
 end loop ;

 update FnaBudget set budgetstatus = '2' where budgetdepartmentid =  departmentid_1 and budgetperiods >=  periodsfrom_2 and budgetperiods <=  periodsto_2 and budgetstatus = '1' ;
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetModule_Delete 
 ( id_1 	integer,  
 flag out integer , 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 

 DELETE FnaBudgetModule WHERE ( id	 =  id_1); 
 open thecursor for
select '20' from dual; 

 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetModule_Insert 
 ( budgetname_1 	varchar2,  
 budgetdesc_2 	varchar2,  
 fnayear_3 	char,  
 periodsidfrom_4 	integer,  
 periodsidto_5 	integer,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  as 
begin 

 INSERT into FnaBudgetModule ( budgetname, budgetdesc, fnayear, periodsidfrom, periodsidto)  VALUES (  budgetname_1,  budgetdesc_2,  fnayear_3,  periodsidfrom_4,  periodsidto_5); 
 open thecursor for 
 select max(id) from FnaBudgetModule; 
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetModule_Select 
  (flag out integer ,  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from FnaBudgetModule; 
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetModule_SelectByID 
  (id_1 	integer,  
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from FnaBudgetModule where id =  id_1 ;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetModule_Update 
 ( id_1 	integer,  
 budgetname_2 	varchar2,  
 budgetdesc_3 	varchar2,  
 fnayear_4 	char,  
 periodsidfrom_5 	integer,  
 periodsidto_6 	integer,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 

 UPDATE FnaBudgetModule  SET  budgetname	 =  budgetname_2, budgetdesc	 =  budgetdesc_3, fnayear	 =  fnayear_4, periodsidfrom	 =  periodsidfrom_5, periodsidto	 =  periodsidto_6  WHERE ( id	 =  id_1) ;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudget_Approve 
  (id_1 	integer,  
  approverid_1  integer,  
  approverdate_1  char,  
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
count0 integer;
begin 

 select  count(id) into count0 from FnaBudget where id =  id_1 and createrid =  approverid_1;  
 if  count0 <> 0 then 
 open thecursor for
 select -1 from dual; 
 end if;
 update FnaBudget set budgetstatus='1' , approverid= approverid_1 , approverdate= approverdate_1 where id = id_1 ;
 end;
/




 CREATE or REPLACE PROCEDURE FnaBudget_Delete 
 ( id_1 	integer,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 

  DELETE FnaBudget WHERE   (id	 =  id_1);  
  delete FnaBudgetDetail where (budgetid =  id_1); 

 end;
/

CREATE or REPLACE PROCEDURE FnaBudget_Insert 
 ( budgetmoduleid_1 	integer,  
 budgetperiods_2 	char,  
 budgetdepartmentid_3 	integer,  
 budgetcostercenterid_4 	integer,  
 budgetresourceid_5 	integer,  
 budgetcurrencyid_6 	integer,  
 budgetdefcurrencyid_7 	integer,  
 budgetexchangerate_8 	varchar2,  
 budgetremark_9 	varchar2,  
 budgetstatus_10 	char,  
 createrid_11 	integer,  
 createdate_12 	char,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
 as 
 count_1 integer ;
 fnayear_1 char(4) ;  
 periodsid_1 integer ;
 isclose_1 char(1) ; 
begin 

 select  count(id) into count_1  from FnaBudget where budgetresourceid =  budgetresourceid_5 and budgetperiods =  budgetperiods_2  ;
 if  count_1 <> 0  then
 open thecursor for
 select -1 from dual;
 return ;
 end  if;

 select  count(id) into count_1  from FnaYearsPeriodsList where isclose = '0' and isactive = '1' and fnayearperiodsid =  budgetperiods_2 ;

 if  count_1 = 0 then
 open thecursor for
 select -2 from dual;
 return ;
 end  if;

 INSERT into FnaBudget
 ( budgetmoduleid, budgetperiods, budgetdepartmentid, budgetcostercenterid, budgetresourceid, budgetcurrencyid, budgetdefcurrencyid, budgetexchangerate, budgetremark, budgetstatus, createrid, createdate) 
 VALUES
 (  budgetmoduleid_1,  budgetperiods_2,  budgetdepartmentid_3,  budgetcostercenterid_4,  budgetresourceid_5,  budgetcurrencyid_6,  budgetdefcurrencyid_7,  budgetexchangerate_8,  budgetremark_9,  budgetstatus_10,  createrid_11,  createdate_12);

 open thecursor for
 select max(id) from FnaBudget ;
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudget_Reopen 
  (id_1 	integer,  
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

 update FnaBudget set budgetstatus='0' , approverid = null , approverdate=null where id =  id_1 ;

 end;
/

 CREATE or REPLACE PROCEDURE FnaBudget_SelectByResourceID 
 ( budgetperiods_1 	char,  
 budgetresourceid_2 	integer,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
 select * from FnaBudget where budgetperiods =  budgetperiods_1 and budgetresourceid =  budgetresourceid_2 ;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudget_Update 
 ( id_1 	integer,  
 budgetmoduleid_3 	integer,  
 budgetcurrencyid_4 	integer,  
 budgetdefcurrencyid_5 	integer,  
 budgetexchangerate_6 	varchar2,  
 budgetremark_7 	varchar2,  
 budgetstatus_8 	char,  
 createrid_9 	integer,  
 createdate_10 	char,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 

 UPDATE FnaBudget  SET  budgetmoduleid	=  budgetmoduleid_3, budgetcurrencyid =  budgetcurrencyid_4, budgetdefcurrencyid = budgetdefcurrencyid_5, budgetexchangerate	 =  budgetexchangerate_6, 
 budgetremark =  budgetremark_7, budgetstatus = budgetstatus_8,
 createrid = createrid_9, createdate = createdate_10  WHERE ( id	 =  id_1) ; 

 delete FnaBudgetDetail where budgetid =  id_1 ;

 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Delete 
	 (id_1		integer,
	 flag	out integer, 
	 msg  out  varchar2 )
as 
begin 

 
	delete from fnaBudgetfeetype where id= id_1;

 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Insert 
	 (name_1	varchar2,
	 description_1	varchar2,
	 flag	out integer, 
	 msg	out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 

 
	insert into fnaBudgetfeetype (name,description) values( name_1, description_1);
	open thecursor for 
	select max(id) from fnaBudgetfeeType;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Select 
	 (flag	out integer, 
	 msg	varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
 
	select * from fnaBudgetfeetype order by id;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetfeeType_SelectByID 
	 (id_1		integer,
	 flag	out integer, 
	 msg	varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
 
	select * from fnaBudgetfeetype where id= id_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Update 
	 (id_1		integer,
	 name_1	varchar2,
	 description_1	varchar2,
	 flag	out integer, 
	 msg	varchar2 )
as 
begin 

 
	update fnaBudgetfeetype set name= name_1,description= description_1 where id= id_1;

 end;
/

 CREATE or REPLACE PROCEDURE FnaCurrencyExchange_Delete 
 ( id_1 	integer,  
 fnayear_2 	char,  
 periodsid_3 	integer,  
 flag           out integer, 
 msg         out  varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
 as 
  isclose_1 char; 
  isclose_count integer;
  begin 
  select  count(isclose) into isclose_count  from FnaYearsPeriodsList where fnayear =  fnayear_2  and Periodsid =  periodsid_3; 
if isclose_count > 0 then

  select  isclose into isclose_1  from FnaYearsPeriodsList where fnayear =  fnayear_2  and Periodsid =  periodsid_3;   
  if  isclose_1 = '1' then
  open thecursor for
  select -1  from dual;
  return;
  end if;
  DELETE FnaCurrencyExchange WHERE ( id	 =  id_1 );
end if;  
 end;
/

 CREATE or REPLACE PROCEDURE FnaCurrencyExchange_Insert 
 ( defcurrencyid_1 	integer,  
 thecurrencyid_2 	integer,  
 fnayear_3 	char,  
 periodsid_4 	integer,  
 fnayearperiodsid_5 	char,  
 avgexchangerate_6 	varchar2,  
 endexchangerage_7 	varchar2,  
 flag                             out integer, 
 msg                      out       varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
 as 
 count_1 integer;
 isclose_1 char;
 isclose_count integer;
begin 

   select count(id) into count_1 from FnaCurrencyExchange where fnayearperiodsid =  fnayearperiodsid_5 and thecurrencyid =  thecurrencyid_2;
   if count_1 <> 0  then
   open thecursor for
   select -1 from dual;
   return;
   end if;
   select  count(isclose) into isclose_count  from FnaYearsPeriodsList where fnayear =  fnayear_3  and Periodsid =  periodsid_4;
if(isclose_count > 0) then 

   select  isclose into isclose_1  from FnaYearsPeriodsList where fnayear =  fnayear_3  and Periodsid =  periodsid_4;
   if isclose_1 = '1' then
   open thecursor for
   select -2  from dual;
   return; 
   end if;
end if;

   INSERT INTO FnaCurrencyExchange ( defcurrencyid, thecurrencyid, fnayear, periodsid, fnayearperiodsid,
avgexchangerate, endexchangerage)  VALUES ( defcurrencyid_1, thecurrencyid_2, fnayear_3,
 periodsid_4, fnayearperiodsid_5, avgexchangerate_6, endexchangerage_7);
   open thecursor for 
   select max(id) from FnaCurrencyExchange;
 end;
/

 CREATE or REPLACE PROCEDURE FnaCurrencyExchange_SByCurrenc 
 ( id_1 	integer, 
 flag                             out integer, 
 msg                             varchar2, 
thecursor IN OUT cursor_define.weavercursor  )
 as 
begin 
open thecursor for 
 select * from FnaCurrencyExchange where thecurrencyid =  id_1 order by fnayearperiodsid desc ;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaCurrencyExchange_SelectByID 
 ( id_1 	integer,  
 flag                             out integer, 
 msg                             varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
 as 
begin 
open thecursor for 
 select * from FnaCurrencyExchange where id =  id_1; 
 
 end;
/


CREATE or REPLACE PROCEDURE FnaCurrencyExchange_SByLast 
  (flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
 defcurrencyid_1 integer;  
 endexchangerage_1 varchar2 (20);
begin 
 for currencyid_cursor  in (select thecurrencyid , max(fnayearperiodsid) maxfnayearperiodsid from  FnaCurrencyExchange group by thecurrencyid ) 
 loop
	  select defcurrencyid ,endexchangerage into defcurrencyid_1 , endexchangerage_1 from FnaCurrencyExchange where thecurrencyid=  currencyid_cursor.thecurrencyid and fnayearperiodsid= currencyid_cursor.maxfnayearperiodsid ; 
	  insert into TM_FnaCurrencyExchange values(defcurrencyid_1 ,currencyid_cursor.thecurrencyid , endexchangerage_1) ;
 end loop;
 open thecursor for 
 select * from TM_FnaCurrencyExchange ; 
 end;
/

 CREATE or replace PROCEDURE FnaCurrencyExchange_Update
(id_1 	integer, 
avgexchangerate_2 	varchar2,
endexchangerage_3 	varchar2, 
fnayear_4 	char,
periodsid_5 	integer,
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
isclose_1 char;
isclose_count integer;
begin
select  count(isclose) into isclose_count from FnaYearsPeriodsList where fnayear = fnayear_4 
and Periodsid = periodsid_5;
if  isclose_count>0 then 

	select  isclose into isclose_1 from FnaYearsPeriodsList where fnayear = fnayear_4 
	and Periodsid = periodsid_5;
	if isclose_1= '1' then
	open thecursor for
	select -1 from dual;
	return;
	end if;
end if;
UPDATE FnaCurrencyExchange  SET  avgexchangerate=avgexchangerate_2,
endexchangerage=endexchangerage_3  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE FnaCurrency_Insert 
(currencyname_1 	varchar2, 
 currencydesc_2 	varchar2,
 activable_3 	char,
 isdefault_4 	char,
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
AS 
count_1 integer;
begin
select count(id) into count_1 from FnaCurrency where currencyname = currencyname_1;
if count_1 <>0 then
open thecursor for
select -1 from dual;
return;
end if;
 if isdefault_4 = '1' then
 update FnaCurrency set isdefault = '0';
 INSERT INTO FnaCurrency ( currencyname, currencydesc, activable, isdefault) 
 VALUES ( currencyname_1, currencydesc_2, activable_3, isdefault_4); 
 open thecursor for
 select max(id) from FnaCurrency;
end if;
end;
/

CREATE or replace PROCEDURE FnaCurrency_SelectAll 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for select * from FnaCurrency;  
end;
/


CREATE or replace PROCEDURE FnaCurrency_SelectByDefault 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
 begin 
open thecursor for select * from FnaCurrency where isdefault = '1';
end;
/

CREATE or replace PROCEDURE FnaCurrency_SelectByID 
(id_1 	integer,
 flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
 open thecursor for select * from FnaCurrency where id = id_1;
end;
/

CREATE or replace PROCEDURE FnaCurrency_Update
(id_1 	integer, 
currencydesc_2 	varchar2, 
activable_3 	char, 
isdefault_1	char, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
if isdefault_1 = '1' then
update FnaCurrency set isdefault = '0';
 UPDATE FnaCurrency SET currencydesc=currencydesc_2, 
activable=activable_3 , isdefault = '1' WHERE ( id=id_1);
else 
UPDATE FnaCurrency  SET  currencydesc=currencydesc_2, activable=activable_3 WHERE ( id=id_1);
end if;
end;
/

 CREATE or REPLACE PROCEDURE FnaDptToKingdee_Delete 
  ( flag out integer,
   msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor
)  
  as 
begin 

 
  delete from FnaDptToKingdee;

 end;
/

 CREATE or REPLACE PROCEDURE FnaDptToKingdee_Insert 
 ( departmentid_1 integer,
   kingdeecode_1  varchar2,
   flag out integer,
   msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
  as 
begin 
    
  INSERT into FnaDptToKingdee(departmentid,kingdeecode )  VALUES (  departmentid_1, kingdeecode_1 ); 
  
 end;
/

 CREATE or REPLACE PROCEDURE FnaDptToKingdee_Select 
  ( flag out integer,
    msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
  as 
begin 
open thecursor for 
 
  select * from FnaDptToKingdee;
 
 end;
/

 CREATE or REPLACE PROCEDURE FnaExpensefeeRules_Delete 
	 (feeid_1		integer,
	 resourceid_1  integer,
	 flag out integer , 
  	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	delete from FnaExpensefeeRules 
	where feeid= feeid_1 and resourceid= resourceid_1;

 end;
/




 CREATE or REPLACE PROCEDURE FnaExpensefeeRules_DByFeeid 
	 (feeid_1		integer,
	 flag out integer , 
  	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	delete from FnaExpensefeeRules where feeid= feeid_1;

 end;
/

 CREATE or REPLACE PROCEDURE FnaExpensefeeRules_Insert 
	 (feeid_1		integer,
	 resourceid_1   integer,
	 standardfee_1    decimal,
	 flag out integer , 
  	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	insert into FnaExpensefeeRules (feeid,resourceid,standardfee)
	values ( feeid_1, resourceid_1, standardfee_1);

 end;
/



 CREATE or REPLACE PROCEDURE FnaExpensefeeRules_SByFandR 
	 (feeid_1		integer,
	 resourceid_1        integer,
	 flag out integer , 
  	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
open thecursor for 

	select * from FnaExpensefeeRules where feeid= feeid_1 and resourceid= resourceid_1;
 
 end;
/




 CREATE or REPLACE PROCEDURE FnaExpensefeeRules_SByFeeid 
	 (feeid_1		integer,
	 flag out integer , 
  	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
open thecursor for 

	select * from FnaExpensefeeRules where feeid= feeid_1;
 
 end;
/





 CREATE or REPLACE PROCEDURE FnaExpensefeeRules_Update 
	 (feeid_1		integer,
	 resourceid_1 integer,
	 standardfee_1    decimal,
	 flag out integer , 
  	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 

	Update FnaExpensefeeRules set standardfee= standardfee_1
	where feeid= feeid_1 and resourceid= resourceid_1;

 end;
/

 CREATE or REPLACE PROCEDURE FnaExpensefeeType_Delete 
	 (id_1		integer,
	 flag	out integer, 
	 msg	varchar2 )
as 
begin 
 
	delete from fnaexpensefeetype where id= id_1;

 end;
/

CREATE or replace PROCEDURE FnaExpensefeeType_Insert
(name_1	varchar2,
remark_1	varchar2,
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
	insert into fnaexpensefeetype (name,remark) values (name_1,remark_1);
open thecursor for
	select max(id) from fnaExpensefeeType;
end;
/

/* 9.2 */
CREATE or replace PROCEDURE FnaExpensefeeType_Select
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
open thecursor for
select * from fnaexpensefeetype order by id;
end;
/

CREATE or replace PROCEDURE FnaExpensefeeType_SelectByID
(id_1		integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
open thecursor for
	select * from fnaexpensefeetype where id=id_1;
end;
/

CREATE or replace PROCEDURE FnaExpensefeeType_Update
	(id_1		integer,
	name_1	varchar2,
	remark_1	varchar2,
	flag	out integer, 
	msg out varchar2,thecursor IN OUT cursor_define.weavercursor) 
as 
begin
	update fnaexpensefeetype set name=name_1,remark=remark_1 where id=id_1;
end;
/

CREATE or replace PROCEDURE FnaIndicator_Delete
(id_1 	integer, 
indicatortype_2 	char, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as
begin 
delete FnaIndicator WHERE ( id=id_1);
if indicatortype_2 = '0' then
delete FnaIndicatordetail where indicatorid = id_1;
end if;
end;
/

 CREATE or REPLACE PROCEDURE FnaIndicator_Insert 
 ( indicatorname_1 	varchar2,  
 indicatordesc_2 	varchar2,  
 indicatortype_3 	char,  
 indicatorbalance_4 	char,  
 haspercent_5 		char,  
 indicatoridfirst_6 	integer,  
 indicatoridlast_7 	integer,  
 flag out		integer ,  
 msg out		varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 

 INSERT into FnaIndicator
 ( indicatorname, indicatordesc, indicatortype, indicatorbalance, haspercent, indicatoridfirst, indicatoridlast)   VALUES (  indicatorname_1,  indicatordesc_2,  indicatortype_3,  indicatorbalance_4,  haspercent_5,  indicatoridfirst_6,  indicatoridlast_7);
 open thecursor for 
 select max(id) from FnaIndicator ;
 
 end;
/

CREATE or replace PROCEDURE FnaIndicator_Select
( flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for 
select * from FnaIndicator;
end;
/

CREATE or replace PROCEDURE FnaIndicator_SelectByID 
(id_1  integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
 select * from FnaIndicator where id = id_1;
end;
/

CREATE or replace PROCEDURE FnaIndicator_SelectMinYear
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for 
select min(id) from FnaIndicator where  indicatortype='0';
end;
/

 CREATE or REPLACE PROCEDURE FnaIndicator_Update 
 ( id_1 	integer, 
 indicatorname_2 	varchar2,  
 indicatordesc_3 	varchar2,  
 indicatorbalance_4 	char, 
 haspercent_5 	char,  
 indicatoridfirst_6 	integer, 
 indicatoridlast_7 	integer, 
 flag out integer ,  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
 UPDATE FnaIndicator  SET  indicatorname = indicatorname_2, indicatordesc = indicatordesc_3, indicatorbalance = indicatorbalance_4, haspercent = haspercent_5, indicatoridfirst = indicatoridfirst_6, indicatoridlast = indicatoridlast_7  WHERE ( id=  id_1) ;
 end;
/

 CREATE or REPLACE PROCEDURE FnaIndicatordetail_Delete 
 ( id_1 	integer,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 

 DELETE FnaIndicatordetail  WHERE ( id =  id_1) ;

 end;
/

 CREATE or REPLACE PROCEDURE FnaIndicatordetail_Insert 
 ( indicatorid_1 	integer,
 ledgerid_2 	integer, 
 flag out integer , 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 as 
begin 

 INSERT into FnaIndicatordetail ( indicatorid, ledgerid) VALUES (  indicatorid_1,  ledgerid_2); 

 end;
/

 CREATE or REPLACE PROCEDURE FnaIndicatordetail_SelectByID 
  (id_1  integer ,  
  flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from FnaIndicatordetail where indicatorid =  id_1 ;
 
 end;
/

CREATE or replace PROCEDURE FnaLedgerCategory_Delete 
(id_1 	integer,
 flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS 
count_1 integer ;
begin
select  count(id) into count_1 from FnaLedger where Categoryid = id_1;
if count_1 <> 0 then
open thecursor for
select '20' from dual;
return;
end if;
delete from FnaLedgerCategory WHERE  ( id=id_1);
end;
/

 CREATE or REPLACE PROCEDURE FnaLedgerCategory_Insert 
 (categoryname_1 	varchar2,
 categorydesc_2 	varchar2,
 flag out integer , 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 as 
 begin
 INSERT into FnaLedgerCategory 
 (categoryname, categorydesc) 
 VALUES( categoryname_1,  categorydesc_2);
 open thecursor for 
 select max(id) from FnaLedgerCategory ;
 
 end;
/

CREATE or replace PROCEDURE FnaLedgerCategory_Select
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as
begin
open thecursor 
for select * from FnaLedgerCategory;
end;
/

CREATE or replace PROCEDURE FnaLedgerCategory_SelectByID
( id_1 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
open thecursor for 
select * from FnaLedgerCategory where id = id_1;
end;
/

 CREATE or REPLACE PROCEDURE FnaLedgerCategory_Update 
 ( id_1 	integer, 
 categoryname_2 	varchar2,  
 categorydesc_3 	varchar2, 
 flag out integer , 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  as 
begin 

 UPDATE FnaLedgerCategory  SET  categoryname	 =  categoryname_2, categorydesc	 =  categorydesc_3  WHERE ( id =  id_1) ;

 end;
/

CREATE or replace PROCEDURE FnaLedger_Delete
(id_1 	integer, 
supledgerid_2 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS 
count_1 integer; 
recordcount integer;
begin
select count(subledgercount) into recordcount from FnaLedger where id = id_1;
if recordcount>0 then

select subledgercount into count_1 from FnaLedger where id = id_1;
end if;
if count_1<> 0 then
open thecursor for
select '20'  from dual;
return;
end if; 
select count(id) into count_1 from FnaTransactionDetail where ledgerid = id_1;
if count_1 <> 0 then
open thecursor for
select '20' from dual;
return;
end if;
DELETE FnaLedger WHERE ( id=id_1 ); 
if  supledgerid_2 <> 0 then
 update FnaLedger set subledgercount = subledgercount-1 where id = supledgerid_2;
end if;
delete FnaAccount where ledgerid = id_1;
end;
/

CREATE or replace PROCEDURE FnaLedger_DeleteAuto 
(crmcode_1 	varchar2,
 crmtype_1 	char,
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 count_1 integer; 
 ledgermark_1 varchar2(60); 
 ledgermark_2 varchar2(60);
 ledgerid_1 integer; 
 ledgerid_2 integer;
 supledgerid_1 integer;
 supledgerid_2 integer; 
 ledgermark_count_1 integer;
 ledgermark_count_2 integer;
 recordcount integer;

begin
if crmtype_1 = '1' then
	select count(ledgermark) into ledgermark_count_1 from FnaLedger where autosubledger = '1' ;
	if ledgermark_count_1>0 then

	select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '1' ;
	end if;
	select count(ledgermark) into ledgermark_count_2 from FnaLedger where autosubledger = '2' ;
	if ledgermark_count_2>0 then

	select ledgermark into ledgermark_2 from FnaLedger where autosubledger = '2' ;
	end if;
end if;
if crmtype_1 = '2' then 
	select count(ledgermark) into ledgermark_count_1 from FnaLedger where autosubledger = '3' ;
		if ledgermark_count_1>0 then
	
	select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '3';
	    end if;
	
	select count(ledgermark) into ledgermark_count_2 from FnaLedger where autosubledger = '4' ;
	if ledgermark_count_2>0 then

	select ledgermark into ledgermark_2 from FnaLedger where autosubledger = '4';
	end if;
end if ;
select  count(id) INTO recordcount  from FnaLedger ;
IF (recordcount>0) THEN
 
select  id,supledgerid into ledgerid_1, supledgerid_1 from FnaLedger 
where  ledgermark = concat(ledgermark_1 , crmcode_1);
end if;

select count(id) into count_1 from FnaTransactionDetail where ledgerid = ledgerid_1;
if count_1 <> 0 then
open thecursor for
 select 2 from dual;
 return;
 end if;  
select  count(id) INTO recordcount  from FnaLedger ;
 IF (recordcount>0) THEN

 select id,supledgerid into ledgerid_2 ,supledgerid_2 from FnaLedger
 where  ledgermark = concat(ledgermark_2 , crmcode_1);
 end if;
 select  count(id) into count_1 from FnaTransactionDetail where ledgerid = ledgerid_2 ;
if count_1 <> 0 then
open thecursor for
 select 2 from dual;
return;
end if;
delete FnaLedger where id = ledgerid_1;
delete FnaLedger where id = ledgerid_2 ;
 update FnaLedger set subledgercount = subledgercount-1 where id = supledgerid_1;
 update FnaLedger set subledgercount = subledgercount-1 where id = supledgerid_2 ;
open thecursor for
 select 0 from dual;
end;
/

 cREATE or replace PROCEDURE FnaLedger_Insert
(ledgermark_1 	varchar2,
 ledgername_2 	varchar2, 
 ledgertype_3 	char,
 ledgergroup_4 	char, 
 ledgerbalance_5 	char, 
 autosubledger_6 	char,
 ledgercurrency_7 	char,
 supledgerid_8 	integer,
 Categoryid_9 	integer,
 supledgerall_10 	varchar2, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
count_1 integer; 
init_1 number;
init_count integer;
begin
if supledgerid_8 <> 0 then

select  count(initaccount) into init_count from FnaLedger where id = supledgerid_8; 
if init_count>0 then

select  initaccount into init_1 from FnaLedger where id = supledgerid_8; 
 end if; 
if init_1 <> 0 then
open thecursor for
 select -1 from dual;
return ;
end if;
select count(id) into count_1 from FnaTransactionDetail where ledgerid = supledgerid_8; 
if count_1 <> 0 then
open thecursor for 
select -1 from dual;
return; 
end if;
end if;
select count(id) into count_1 from FnaLedger where ledgermark = ledgermark_1; 
if count_1 <> 0 then
open thecursor for
select -2 from dual;
return;
end if;
if autosubledger_6 <> '0' then
select count(id) into count_1 from FnaLedger
where autosubledger = autosubledger_6 ;
if count_1 <> 0 then
open thecursor for
 select -3 from dual;
return;
end if; 
end if; 
INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance,
 autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall)  
VALUES ( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, 
autosubledger_6, ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10);
if supledgerid_8 <> 0 then
update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8;
end if;
open thecursor for
select max(id) from FnaLedger;
end;
/

CREATE or replace PROCEDURE FnaLedger_InsertAuto 
(crmname_1 	varchar2,
 crmtype_1 	char,
 crmcode_1 	varchar2, 
 flag out integer ,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor) 
 AS  
 count_1 integer;  
 init_1 number(18,3);
 ledgermark_1 varchar2(60);
 ledgername_2 varchar2(200);
 ledgertype_3 char(1);
 ledgergroup_4  char(1);
 ledgerbalance_5 char(1);
 ledgercurrency_7 char(1);
 supledgerid_8 integer;
 Categoryid_9 integer;
 supledgerall_10 varchar2(100);
 ledgerid1_1 integer;
 ledgerid2_1 integer ;
 ledgermark_count integer;
 recordcount_2 integer;
 recordcount_1 integer;
begin
 if crmtype_1 = '1'  then 
     select count(ledgermark) into ledgermark_count from FnaLedger where autosubledger = '1';
	 if ledgermark_count>0 then

	 select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '1';
	 end if;
	 select count(id) into count_1 from FnaLedger where  ledgermark = (ledgermark_1 || crmcode_1);

	 if count_1 <> 0 then 
	 open thecursor for
	 select 1,0,0 from dual;
	 return;
	 end if;
	 select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '2' ;
	 select count(id) into count_1 from FnaLedger where  ledgermark = (ledgermark_1 || crmcode_1) ;

	if count_1<> 0 then
	open thecursor for
	select 1,0,0 from dual;
	return;
	end if;

	select count(*)
	into recordcount_1 from FnaLedger where autosubledger = '1';
	if recordcount_1>0 then

	select ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance,ledgercurrency,id,Categoryid,supledgerall 
	into ledgermark_1, ledgername_2,ledgertype_3,ledgergroup_4,ledgerbalance_5,ledgercurrency_7,
	supledgerid_8,Categoryid_9,supledgerall_10 from FnaLedger where autosubledger = '1';
	end if;

	 ledgermark_1:=ledgermark_1 || crmcode_1;
	 ledgername_2 := ledgername_2 || '-' || crmname_1 ;
	 supledgerall_10:= concat(supledgerall_10 ,( to_char(supledgerid_8) ||'|')) ;

	 INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance,
	 autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall)  
	 VALUES ( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, '0',
	 ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10) ;
	 
	 select  max(id) into ledgerid1_1 from FnaLedger;
	 update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8;
	  
	select ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance,ledgercurrency,id,Categoryid,supledgerall 
	into ledgermark_1, ledgername_2,ledgertype_3,ledgergroup_4,ledgerbalance_5,ledgercurrency_7,
	supledgerid_8,Categoryid_9,supledgerall_10 from FnaLedger where autosubledger = '2';

	ledgermark_1:= ledgermark_1 || crmcode_1 ;
	ledgername_2:= ledgername_2 || '-' || crmname_1;
	supledgerall_10:=supledgerall_10 || to_number(supledgerid_8) ||'|' ;
	INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance,
	autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall)  
	VALUES ( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, '0',
	ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10);
	  
	select max(id) into ledgerid2_1 from FnaLedger;
	update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8;  
end if;

if crmtype_1 = '2' then
     select count(ledgermark) into ledgermark_count from FnaLedger where autosubledger = '3';
	 if ledgermark_count>0 then

	select ledgermark into ledgermark_1  from FnaLedger where autosubledger = '3' ;
	end if;
	select count(id) into count_1 from FnaLedger where  ledgermark = (ledgermark_1 || crmcode_1) ;
	if count_1 <> 0 then
	open thecursor for
	select 1,0,0 from dual;
	return;
	end if;

	select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '4' ;
	select count(id) into count_1 from FnaLedger where  ledgermark = (ledgermark_1 || crmcode_1); 
	if count_1 <> 0 then
	open thecursor for
	select 1,0,0 from dual;
	return ;
	end if;

	select count(*)
	into recordcount_2 from FnaLedger where autosubledger = '3';
	if recordcount_2 >0 then


	select ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance,ledgercurrency,id,Categoryid,supledgerall
	into ledgermark_1, ledgername_2,ledgertype_3,ledgergroup_4,ledgerbalance_5,ledgercurrency_7,
	supledgerid_8,Categoryid_9,supledgerall_10 from FnaLedger where autosubledger = '3';
    end if;
	ledgermark_1:=ledgermark_1 || crmcode_1;
	ledgername_2:=ledgername_2 || '-' || crmname_1;
	supledgerall_10:=supledgerall_10 || to_char( supledgerid_8) ||'|' ; 

	INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance,
	 autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall)  VALUES 
	( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, '0',
	 ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10); 

	select max(id) into ledgerid1_1 from FnaLedger;
	update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8;

	select ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance,ledgercurrency,id,Categoryid,supledgerall
	into ledgermark_1, ledgername_2,ledgertype_3,ledgergroup_4,ledgerbalance_5,ledgercurrency_7,
	supledgerid_8,Categoryid_9,supledgerall_10 from FnaLedger where autosubledger = '4';


	ledgermark_1:=ledgermark_1 || crmcode_1;
	ledgername_2:=ledgername_2 || '-' || crmname_1;
	supledgerall_10:=supledgerall_10 || to_char(supledgerid_8) ||'|' ; 

	INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance,
	 autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall)  
	VALUES ( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, '0', 
	ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10); 

	select max(id) into ledgerid2_1 from FnaLedger;
	update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8;  
end if;

open thecursor for
select 0, ledgerid1_1, ledgerid2_1 from dual;
end;
/

CREATE or replace PROCEDURE FnaLedger_Select 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for 
select * from FnaLedger order by ledgermark;
end;
/

CREATE or replace PROCEDURE FnaLedger_SelectByID 
(id_1 	integer, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
AS 
count_1 integer;
count1_1 integer;
begin
select count(id) into count_1 from FnaAccountList where ledgerid = id_1;
select count(id) into count1_1 from FnaYearsPeriodsList where isclose = '1';
count_1:= count_1 + count1_1; 


open thecursor for
select id,ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance, autosubledger,ledgercurrency,
supledgerid,subledgercount,Categoryid, initaccount , count_1 as accountnum from FnaLedger where id = id_1;
end;
/

CREATE or replace PROCEDURE FnaLedger_SelectCountByBabance
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 AS 
 assetcount_1 integer;
 debitcount_1 integer; 
begin
select count(id) into assetcount_1 from FnaLedger where supledgerid =0 and ledgergroup ='1' ;
select count(id) into debitcount_1 from FnaLedger where supledgerid =0 and
 (ledgergroup ='2' or ledgergroup ='3' );
open thecursor for 
select assetcount_1 , debitcount_1 from dual;
end;
/

CREATE or replace PROCEDURE FnaLedger_SelectSupLedgerall 
(id_1 	integer, 
flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select supledgerall from FnaLedger  where id = id_1;
end;
/

CREATE or replace PROCEDURE FnaLedger_Update 
(id_1 	integer, 
 ledgermark_2 	varchar2,
 ledgername_3 	varchar2,
 ledgertype_4 	char,
 ledgergroup_5 	char, 
 ledgerbalance_6 	char,
 autosubledger_7 	char,
 ledgercurrency_8 	char,
 initaccount_9         number,
 doinit_10              char,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
 count_1 integer;
begin
if autosubledger_7 <> '0' then
select count(id) into count_1 from FnaLedger where autosubledger = autosubledger_7 and id != id_1 ;
if count_1 <> 0 then 
open thecursor for
select -3 from dual;
return ;
end if;
end if; 
UPDATE FnaLedger  SET ledgermark=ledgermark_2, ledgername=ledgername_3, ledgertype=ledgertype_4,
ledgergroup=ledgergroup_5, ledgerbalance=ledgerbalance_6, autosubledger=autosubledger_7, 
ledgercurrency=ledgercurrency_8, initaccount=initaccount_9  WHERE ( id=id_1); 
if doinit_10 = '1' then  
delete FnaAccount where ledgerid = id_1;
insert into FnaAccount(ledgerid,tranperiods,tranremain) values(id_1,'000000',initaccount_9);
end if;
end;
/

CREATE or replace PROCEDURE FnaLedger_UpdateAuto 
(oldcrmcode_1 	varchar2,
 crmcode_1 	varchar2, 
 crmtype_1 	char, 
 flag out integer , 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)  
AS  
 count_1 integer ;
 ledgermark_1 varchar2(60);
 ledgermark_2 varchar2(60);
 ledgerid_1 integer;
 ledgerid_2 integer;
 ledgermark_count_1 integer;
 ledgermark_count_2 integer;
 recordcount integer;
 begin
 if crmtype_1 = '1' then
	 select count(ledgermark) into ledgermark_count_1 from FnaLedger where autosubledger = '1';
     if ledgermark_count_1>0 then

	 select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '1';
     end if;
	 select count(ledgermark) into ledgermark_count_2 from FnaLedger where autosubledger = '2';
     if ledgermark_count_2>0 then

	 select ledgermark into ledgermark_2 from FnaLedger where autosubledger = '2';
	 end if;
 end if;
 if crmtype_1 = '2' then
	 select count(ledgermark) into ledgermark_count_1 from FnaLedger where autosubledger = '3';
     if ledgermark_count_1>0 then
	 
	 select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '3';
	 end if;
	 select count(ledgermark) into ledgermark_count_2 from FnaLedger where autosubledger = '4';
     if ledgermark_count_2>0 then

	 select ledgermark into ledgermark_2 from FnaLedger where autosubledger = '4';
	 end if;
 end if;
select count(id) into count_1 from FnaLedger where  ledgermark = concat(ledgermark_1 , crmcode_1) ;
if count_1 <> 0 then
open thecursor for
select 1 from dual;
return;
end if; 
select count(id) into recordcount from FnaLedger where  ledgermark = concat(ledgermark_1 , oldcrmcode_1);
if(recordcount > 0) then

select id into ledgerid_1 from FnaLedger where  ledgermark = concat(ledgermark_1 , oldcrmcode_1);
end if;
select count(id) into count_1 from FnaTransactionDetail where ledgerid = ledgerid_1 ;
if count_1<> 0 then 
open thecursor for
select 2 from dual;
return ;
end if;
select count(id) into count_1 from FnaLedger where  ledgermark = concat(ledgermark_2 , crmcode_1);
if count_1 <> 0 then
open thecursor for
select 1 from dual;
return;
end if; 

select id into ledgerid_2 from FnaLedger where  ledgermark = concat(ledgermark_2 , oldcrmcode_1) ;
select count(id) into count_1 from FnaTransactionDetail where ledgerid = ledgerid_2 ;
if count_1 <> 0 then
open thecursor for
 select 2 from dual;
return ;
end if;
update FnaLedger set ledgermark = concat(ledgermark_1 , crmcode_1) where id = ledgerid_1 ;
update FnaLedger set ledgermark = concat(ledgermark_2 , crmcode_1) where id = ledgerid_2 ;
open thecursor for
select 0 from dual;
end;
/

 CREATE or REPLACE PROCEDURE FnaTransactionDetail_Insert 
 ( tranid_1 	integer,  
 ledgerid_2 	integer, 
 tranaccount_3 	decimal,
 trandefaccount_3 	decimal,  
 tranbalance_4 	char,  
 tranremark_5 	varchar2,  
 flag                             out integer,  
 msg                       out      varchar2 )
 as 
begin 

 INSERT into FnaTransactionDetail ( tranid, ledgerid, tranaccount, trandefaccount, tranbalance, tranremark)  VALUES (  tranid_1,  ledgerid_2,  tranaccount_3,  trandefaccount_3 ,  tranbalance_4,  tranremark_5) ;

 end;
/

 CREATE or REPLACE PROCEDURE FnaTransactionDetail_SByID 
  (id_1 	integer,  
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
open thecursor for 
 select * from FnaTransactionDetail where tranid =  id_1; 
 
 end;
/

CREATE or replace PROCEDURE FnaTransaction_Approve 
(id_1 	integer, 
approverid_1  integer, 
approverdate_1  char, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
count1_1 number;
count2_1 number;
count0_1 integer;
begin
select count(id) into count0_1 from FnaTransaction where id = id_1 and createrid = approverid_1;
if count0_1 <> 0 then 
open thecursor for
select -1 from dual;
return;
end if;
select sum(tranaccount) into count1_1 from FnaTransactionDetail where tranid = id_1 and tranbalance = '1';
select sum(tranaccount) into count2_1 from FnaTransactionDetail where tranid = id_1 and tranbalance = '2'; 
if count1_1 is null  then 
count1_1:= 0;
end if;
if count2_1 is null then 
 count2_1:= 0;
end if;
if count1_1<> count2_1 then
open thecursor for
select -2 from dual;
return;
end if;
update FnaTransaction set transtatus='1' , approverid=approverid_1 , approverdate=approverdate_1 
where id = id_1;
open thecursor for
select tranperiods from FnaTransaction where id = id_1;
end;
/

CREATE or replace PROCEDURE FnaTransaction_Delete 
(id_1 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
select tranperiods from FnaTransaction where id = id_1;
DELETE FnaTransaction WHERE  ( id=id_1);
DELETE FnaTransactionDetail WHERE  ( tranid=id_1);
end;
/

CREATE or replace PROCEDURE FnaTransaction_Insert 
(tranmark_1 	varchar2,
 trandate_2 	char, 
 trandepartmentid_3 	integer,
 trancostercenterid_4 	integer,
 trancurrencyid_5 	integer,
 trandefcurrencyid_6 	integer,
 tranexchangerate_7 	varchar2,
 tranaccessories_8 	smallint,
 tranresourceid_9 	integer,
 trancrmid_10 	integer,
 tranitemid_11 	integer,
 trandocid_12 	integer,
 tranprojectid_13 	integer,
 trandaccount_14 	decimal,
 trancaccount_15 	decimal,
 trandefdaccount_16 	decimal,
 trandefcaccount_17 	decimal,
 tranremark_18 	varchar2,
 transtatus_19 	char,
 createrid_20 	integer,
 createdate_21 	char,
 flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
 count_1 integer;
 fnayear_1 char(4);
 periodsid_1 integer;
 isclose_1 char;
 fnayearp_1 char(6);
 recordcount integer;
begin
select count(id) into count_1 from FnaTransaction where tranmark = tranmark_1;
if count_1 <> 0 then
open thecursor for
select -1,'0' from dual;
return;
end if; 
select count(id) into count_1 from FnaYearsPeriodsList where isclose = '0' 
and isactive = '1' and startdate <= trandate_2 and enddate >= trandate_2; 
if count_1 = 0 then
open thecursor for
select -2,'0' from dual;
return;
end if;
fnayear_1:='';
periodsid_1 := 0;
fnayearp_1:='';

select count(*) INTO recordcount from FnaYearsPeriodsList where startdate <= trandate_2 and enddate >= trandate_2 ;
if recordcount>0 then

select fnayear,Periodsid into fnayear_1,periodsid_1 from FnaYearsPeriodsList
where startdate <= trandate_2 and enddate >= trandate_2 ;
end if;

if periodsid_1< 9 then
fnayearp_1:= concat(concat(fnayear_1, '0') , TO_CHAR( periodsid_1));
else 
fnayearp_1:= concat(fnayear_1 , TO_CHAR(periodsid_1));
end if;
INSERT INTO FnaTransaction ( tranmark, trandate, tranperiods, trandepartmentid, trancostercenterid,
trancurrencyid, trandefcurrencyid, tranexchangerate, tranaccessories, tranresourceid, trancrmid,
tranitemid, trandocid, tranprojectid, trandaccount, trancaccount, trandefdaccount, trandefcaccount,
tranremark, transtatus, createrid, createdate) 
VALUES ( tranmark_1, trandate_2, fnayearp_1 ,trandepartmentid_3, trancostercenterid_4,
trancurrencyid_5, trandefcurrencyid_6, tranexchangerate_7, tranaccessories_8, tranresourceid_9,
trancrmid_10, tranitemid_11,trandocid_12, tranprojectid_13, trandaccount_14, trancaccount_15,
trandefdaccount_16, trandefcaccount_17, tranremark_18, transtatus_19, createrid_20, 
createdate_21);
open thecursor for
select max(id) , fnayearp_1 from FnaTransaction;
end;
/

CREATE or replace PROCEDURE FnaTransaction_Reopen 
(id_1 	integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
update FnaTransaction set transtatus='0' , approverid = null , approverdate=null where id = id_1;
open thecursor for  
select tranperiods from FnaTransaction where id = id_1;
end;
/

CREATE or replace PROCEDURE FnaTransaction_SelectByID
(id_1 	integer,
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
 begin 
 open thecursor for select * from FnaTransaction where id = id_1;
end;
/

CREATE or replace PROCEDURE FnaTransaction_SelectByMaxmark 
(flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
 begin 
 open thecursor for
 select max(tranmark) from FnaTransaction;
end;
/

 CREATE or replace PROCEDURE FnaTransaction_Update 
(id_1 	integer, 
 trandate_2 	char,
 trandepartmentid_3 	integer, 
 trancostercenterid_4 	integer,
 trancurrencyid_5 	integer, 
 trandefcurrencyid_6 	integer, 
 tranexchangerate_7 	varchar2, 
 tranaccessories_8 	smallint, 
 tranresourceid_9 	integer,
 trancrmid_10 	integer, 
 tranitemid_11 	integer,
 trandocid_12 	integer, 
 tranprojectid_13 	integer,
 trandaccount_14 	decimal,
 trancaccount_15 	decimal,
 trandefdaccount_16 	decimal,
 trandefcaccount_17 	decimal,
 tranremark_18 	varchar2,
 transtatus_19 	char,
 createrid_20 	integer, 
 createdate_21 	char, 
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)

 AS 
 count_1 integer ;
 fnayear_1 char(4) ;
 periodsid_1 integer; 
 fnayearp_1 char(6); 
 recordcount integer;
begin
select  count(id) into count_1 from FnaYearsPeriodsList where isclose = '0' and isactive = '1' 
and startdate <= trandate_2 and enddate >= trandate_2;
if count_1 = 0 then 
open thecursor for
select -2 from dual;
return;
end if;
fnayear_1:='';
periodsid_1:=0;
fnayearp_1:='';


select count(*)  INTO recordcount from FnaYearsPeriodsList where startdate <= trandate_2 and enddate >= trandate_2; 
if recordcount > 0 then
select fnayear,Periodsid into fnayear_1,periodsid_1 from FnaYearsPeriodsList
where startdate <= trandate_2 and enddate >= trandate_2; 

end if;
if periodsid_1 < 9 then
fnayearp_1:= concat(concat(fnayear_1 , '0') , TO_CHAR(periodsid_1));
else 
fnayearp_1:= concat(fnayear_1 ,TO_CHAR(periodsid_1)) ;
end if;
UPDATE FnaTransaction  SET trandate=trandate_2,tranperiods= fnayearp_1,
trandepartmentid=trandepartmentid_3, trancostercenterid=trancostercenterid_4,
trancurrencyid=trancurrencyid_5, trandefcurrencyid=trandefcurrencyid_6, 
tranexchangerate=tranexchangerate_7, tranaccessories=tranaccessories_8, 
tranresourceid=tranresourceid_9, trancrmid=trancrmid_10, tranitemid=tranitemid_11,
trandocid=trandocid_12, tranprojectid=tranprojectid_13, trandaccount=trandaccount_14,
trancaccount=trancaccount_15, trandefdaccount=trandefdaccount_16,
trandefcaccount=trandefcaccount_17, tranremark=tranremark_18, transtatus=transtatus_19,
createrid=createrid_20, createdate=createdate_21  WHERE ( id=id_1);
DELETE FnaTransactionDetail WHERE  ( tranid=id_1);
open thecursor for
select fnayearp_1 from dual;
end;
/

  CREATE or REPLACE PROCEDURE FnaYearsPeriodsList_Close 
 ( id_1 	integer,  
 fnayearperiods_1  char,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
count_1 integer;
ledgerid_1 integer;  
departmentid_1 integer ;  
costcenterid_1 integer; 
trandaccount_1 number(18,3); 
trancaccount_1 number(18,3); 
ledgerbalance_1 char ; 
subledgercount_1 integer ;
tranremain_1 number(18,3); 
tmptranperiods_1 char(6);
tmplegderstr_1  varchar(30); 
budgetmoduleid_1 integer; 
budgetaccount_1 number(18,3); 
budgetperiods_1 char(6); 
fnayear_1 char(4) ;
theperiods_1 integer ;
tranremain_count integer;
count_01 integer;
begin 

 /* 判断是否有未关闭的前一周期 */ 
 select  count(id) into count_1 from FnaYearsPeriodsList where fnayearperiodsid <  fnayearperiods_1 
 and isactive = '1' and isclose ='0' ; 
 
 if  count_1 <> 0 then 
	 open thecursor for
	 select -1 from dual;
	 return;
 end if; 

 /* 判断是否有未登帐的本期分录 */ 
 select  count(id) into count_1 from FnaTransaction where transtatus != '2' 
 and tranperiods =  fnayearperiods_1 ; 
 
 if  count_1 <> 0 then
	 open thecursor for
	 select -2 from dual;
	 return;
 end if; 
 
 /* 判断是否有未登帐的本期预算 */ 
 select  count(id) into count_1 from FnaBudget where budgetstatus != '2' and budgetperiods =  fnayearperiods_1;
 
 if  count_1 <> 0 then
	 open thecursor for
	 select -2 from dual;
	 return; 
 end if;    


 /* 开始进行统计 */ 
 delete FnaAccount where tranperiods =  fnayearperiods_1; 
 delete FnaAccountDepartment where tranperiods =  fnayearperiods_1;
 delete FnaAccountCostcenter where tranperiods =  fnayearperiods_1 ;
 delete FnaBudgetDepartment where budgetperiods =  fnayearperiods_1 ;
 delete FnaBudgetCostcenter where budgetperiods =  fnayearperiods_1  ;


   
 /* 将所有明细(subledgercount = 0) 科目进行总帐统计 */ 
 for ledgerid_cursor in ( select id from  FnaLedger where subledgercount = 0 )
 loop
	ledgerid_1 := ledgerid_cursor.id ;
	trandaccount_1 := 0 ;
	trancaccount_1 := 0 ;
	tranremain_1 := 0 ;
	
	select  count(id) ,  max(tranperiods) into count_1, tmptranperiods_1 from FnaAccount 
	where ledgerid =  ledgerid_1 ;
	
	if  count_1 <> 0 then 

		select  count(tranremain) into tranremain_count from FnaAccount 
		where ledgerid =  ledgerid_1 and tranperiods =  tmptranperiods_1 ;
		if tranremain_count>0 then
    

		select  tranremain into tranremain_1 from FnaAccount 
		where ledgerid =  ledgerid_1 and tranperiods =  tmptranperiods_1 ;

		 end if;
	end if ;
	select  count(ledgerbalance) into count_01 from FnaLedger 	where id =  ledgerid_1 ;
	if count_01 >0 then
   
	select  ledgerbalance into ledgerbalance_1 from FnaLedger 	where id =  ledgerid_1 ;
    end if;


	select  sum(tranaccount) into trandaccount_1 from FnaAccountList 
	where ledgerid =  ledgerid_1 and tranperiods =  fnayearperiods_1 and tranbalance = '1' ;
	
	select  sum(tranaccount) into trancaccount_1 from FnaAccountList 
	where ledgerid =  ledgerid_1 and tranperiods =  fnayearperiods_1 and tranbalance = '2' ;
	
	if  trandaccount_1 is null then
		trandaccount_1 := 0 ;
	end if ;
	
	if  trancaccount_1 is null then
		trancaccount_1 := 0 ;
	end if ;
	
	if  tranremain_1 is null then
		tranremain_1 := 0  ;
	end if ;
	
	if  ledgerbalance_1 = '1' then
		tranremain_1 :=  tranremain_1 +  trandaccount_1 -  trancaccount_1 ;
	else 
		tranremain_1 :=  tranremain_1 -  trandaccount_1 +  trancaccount_1 ;
	end if ;
	
	insert into FnaAccount(ledgerid,tranperiods,trandaccount,trancaccount,tranremain,tranbalance) 
	values( ledgerid_1, fnayearperiods_1, trandaccount_1, trancaccount_1, tranremain_1, ledgerbalance_1) ; 
 end loop ;
 
 /*将所有明细科目和部门的分录进行统计 ,按部门和明细科目*/ 
 
 for departmentid_cursor in ( select ledgerid, trandepartmentid from  FnaTransaction t , 
			      FnaTransactionDetail d where t.id = d.tranid and tranperiods =  fnayearperiods_1
			      group by ledgerid , trandepartmentid  )
 loop
	ledgerid_1 := departmentid_cursor.ledgerid ;
	departmentid_1 := departmentid_cursor.trandepartmentid ;
	trandaccount_1 := 0 ; 
	trancaccount_1 := 0 ;
	tranremain_1 := 0 ;
	
	select  ledgerbalance into ledgerbalance_1 from FnaLedger where id =  ledgerid_1 ;
	
	select  sum(trandefaccount) into trandaccount_1 from FnaTransaction t , FnaTransactionDetail d 
	where t.id = d.tranid and tranperiods =  fnayearperiods_1 and ledgerid =  ledgerid_1 
	and trandepartmentid= departmentid_1 and tranbalance = '1' ;
	
	select  sum(trandefaccount) into trancaccount_1 from FnaTransaction t , FnaTransactionDetail d 
	where t.id = d.tranid and tranperiods =  fnayearperiods_1 and ledgerid =  ledgerid_1 
	and trandepartmentid= departmentid_1 and tranbalance = '2' ;
	
	if  trandaccount_1 is null then 
		trandaccount_1 := 0 ;
	end if ;
	
	if  trancaccount_1 is null then 
		trancaccount_1 := 0 ;
	end if ;

	if  ledgerbalance_1 = '1' then
		tranremain_1 :=  trandaccount_1 -  trancaccount_1 ;
	else 
		tranremain_1 :=  trancaccount_1 -  trandaccount_1  ;
	end if ;
	
	insert into FnaAccountDepartment(ledgerid,departmentid,tranperiods,tranaccount,tranbalance) 
	values( ledgerid_1, departmentid_1, fnayearperiods_1, tranremain_1, ledgerbalance_1) ;
 end loop ;
 
 /*将所有明细科目和成本中心的分录进行统计 ,按成本中心和明细科目*/ 
 
 for costcenterid_cursor in ( select ledgerid, trancostercenterid from  FnaTransaction t , 
			      FnaTransactionDetail d where t.id = d.tranid and tranperiods =  fnayearperiods_1 
			      group by ledgerid , trancostercenterid )
 loop
	ledgerid_1 := costcenterid_cursor.ledgerid ;
	costcenterid_1 :=  costcenterid_cursor.trancostercenterid ;
	trandaccount_1 := 0 ;
	trancaccount_1 := 0 ;
	tranremain_1 := 0 ;
	
	select  ledgerbalance into ledgerbalance_1 from FnaLedger 
	where id =  ledgerid_1 ;
	
	select  sum(trandefaccount) into trandaccount_1 from FnaTransaction t , FnaTransactionDetail d 
	where t.id = d.tranid and tranperiods =  fnayearperiods_1 and ledgerid =  ledgerid_1 
	and trancostercenterid= costcenterid_1 and tranbalance = '1' ;
	
	select  sum(trandefaccount) into trancaccount_1 from FnaTransaction t , FnaTransactionDetail d 
	where t.id = d.tranid and tranperiods =  fnayearperiods_1 and ledgerid =  ledgerid_1 
	and trancostercenterid= costcenterid_1 and tranbalance = '2' ;
	
	if  trandaccount_1 is null then 
		trandaccount_1 := 0 ;
	end if ;
	
	if  trancaccount_1 is null then 
		trancaccount_1 := 0 ;
	end if ;
	
	if  ledgerbalance_1 = '1' then 
		tranremain_1 :=  trandaccount_1 -  trancaccount_1 ;
	else 
		tranremain_1 :=  trancaccount_1 -  trandaccount_1  ;
	end if ;
	
	insert into FnaAccountCostcenter(ledgerid,costcenterid,tranperiods,tranaccount,tranbalance) 
	values( ledgerid_1, costcenterid_1, fnayearperiods_1, tranremain_1, ledgerbalance_1); 
 end loop ;
 
 /*将所有明细科目和部门的预算进行统计 ,按部门和明细科目*/  
 for departmentbudgetid_cursor in ( select ledgerid, budgetdepartmentid,budgetmoduleid, sum(budgetaccount) 
				    as budgetaccount from  FnaBudgetList where budgetperiods =  fnayearperiods_1 
				    group by ledgerid ,budgetmoduleid, budgetdepartmentid  )
 loop 
	ledgerid_1 := departmentbudgetid_cursor.ledgerid ;
	departmentid_1 := departmentbudgetid_cursor.budgetdepartmentid ;
	budgetmoduleid_1 := departmentbudgetid_cursor.budgetmoduleid ;
	budgetaccount_1 := departmentbudgetid_cursor.budgetaccount ;

	insert into FnaBudgetDepartment(ledgerid,departmentid,budgetmoduleid,budgetperiods,budgetaccount) 
	values( ledgerid_1, departmentid_1, budgetmoduleid_1, fnayearperiods_1, budgetaccount_1) ;
 end loop ;
 /*将所有明细科目和成本中心的预算进行统计 ,按成本中心和明细科目*/  
 
 for costcenterbudgetid_cursor in ( select ledgerid, budgetcostcenterid,budgetmoduleid, sum(budgetaccount) 
				    as budgetaccount from  FnaBudgetList where budgetperiods =  fnayearperiods_1 
				    group by ledgerid ,budgetmoduleid, budgetcostcenterid  )
 loop
	ledgerid_1 := costcenterbudgetid_cursor.ledgerid ;
	costcenterid_1 :=  costcenterbudgetid_cursor.budgetcostcenterid ;
	budgetmoduleid_1 :=  costcenterbudgetid_cursor.budgetmoduleid ;
	budgetaccount_1 :=  costcenterbudgetid_cursor.budgetaccount ;
	
	insert into FnaBudgetCostcenter(ledgerid,costcenterid,budgetmoduleid,budgetperiods,budgetaccount) 
	values( ledgerid_1, costcenterid_1, budgetmoduleid_1, fnayearperiods_1, budgetaccount_1) ;
 end loop ;

 
 /*对所有总帐(非明细科目)进行统计, 记入总帐*/ 
 for ledgeridsup_cursor in ( select id from  FnaLedger where subledgercount != 0  )
 loop
	ledgerid_1 := ledgeridsup_cursor.id ;
	trandaccount_1 := 0 ;
	trancaccount_1 := 0 ;
	tranremain_1 := 0 ; 
	tmplegderstr_1 := concat(concat('%' , TO_CHAR(ledgerid_1)) , '|%') ;
	
	select  count(id) , max(tranperiods) into count_1, tmptranperiods_1 
	from FnaAccount where ledgerid =  ledgerid_1 ;
	
	if  count_1 <> 0 then
		select  tranremain into tranremain_1 from FnaAccount 
		where ledgerid =  ledgerid_1 and tranperiods =  tmptranperiods_1 ;
	end if ;
		
	select ledgerbalance into ledgerbalance_1 from FnaLedger 
	where id =  ledgerid_1 ;
	
	select  sum(a.trandaccount) ,sum(a.trancaccount) into trandaccount_1 ,  trancaccount_1 
	from FnaAccount a , FnaLedger b where a.ledgerid = b.id and b.supledgerall like  tmplegderstr_1 
	and b.subledgercount = 0 and a.tranperiods =  fnayearperiods_1 ;
	
	if  trandaccount_1 is null then 
		trandaccount_1 := 0 ;
	end if ;
	
	if  trancaccount_1 is null then 
		trancaccount_1 := 0 ;
	end if ;
	
	if  tranremain_1 is null then 
		tranremain_1 := 0 ;
	end if ;
	
	if  ledgerbalance_1 = '1' then 
		tranremain_1 :=  tranremain_1 +  trandaccount_1 -  trancaccount_1 ; 
	else 
	tranremain_1 :=  tranremain_1 -  trandaccount_1 +  trancaccount_1 ;
	end if ;
	
	insert into FnaAccount(ledgerid,tranperiods,trandaccount,trancaccount,tranremain,tranbalance) 
	values( ledgerid_1, fnayearperiods_1, trandaccount_1, trancaccount_1, tranremain_1, ledgerbalance_1) ;
 end loop ;


 /*建立临时表, 保存部门和总帐(非明细), 成本中心和总帐(非明细) 的所有记录 */ 
 
 for ledgerdepartment_cursor in ( select a.id as aid , b.id as bid , a.ledgerbalance as ledgerbalance 
				  from  FnaLedger a, HrmDepartment b where subledgercount != 0  )
 loop 
	ledgerid_1 := ledgerdepartment_cursor.aid ;
	departmentid_1 := ledgerdepartment_cursor.bid ;
	ledgerbalance_1 := ledgerdepartment_cursor.ledgerbalance ;

	insert into TM_FnaYearsPeriodsListClose1 values( ledgerid_1, departmentid_1, ledgerbalance_1) ;
 end loop ;
 
 for ledgercostcenter_cursor in ( select a.id as aid, b.id as bid, a.ledgerbalance as ledgerbalance
				  from  FnaLedger a, HrmCostcenter b where subledgercount != 0  )
 loop
	ledgerid_1 := ledgercostcenter_cursor.aid ;
	costcenterid_1 := ledgercostcenter_cursor.bid ;
	ledgerbalance_1 := ledgercostcenter_cursor.ledgerbalance ;
	
	insert into TM_FnaYearsPeriodsListClose2 values( ledgerid_1, costcenterid_1, ledgerbalance_1) ;
 end loop ;
 
 /*将所有的总帐与部门的收支进行统计 */ 
 for departmentsupledger_cursor in ( select * from TM_FnaYearsPeriodsListClose1 )
 loop
	ledgerid_1 := departmentsupledger_cursor.ledgerid ;
	departmentid_1 := departmentsupledger_cursor.departmentid ;
	ledgerbalance_1 := departmentsupledger_cursor.ledgerbalance ;
	trandaccount_1 := 0 ;
	trancaccount_1 := 0 ;
	tranremain_1 := 0 ;
	tmplegderstr_1 := concat(concat('%' , TO_CHAR(ledgerid_1)) , '|%') ;

	select  sum(a.tranaccount) into trandaccount_1 from FnaAccountDepartment a , FnaLedger b 
	where a.ledgerid = b.id and b.supledgerall like  tmplegderstr_1 and a.departmentid =  departmentid 
	and a.tranperiods =  fnayearperiods_1 and a.tranbalance =  ledgerbalance_1 ;
	
	select  sum(a.tranaccount) into trancaccount_1 from FnaAccountDepartment a , FnaLedger b 
	where a.ledgerid = b.id and b.supledgerall like  tmplegderstr_1 and a.departmentid =  departmentid 
	and a.tranperiods =  fnayearperiods_1 and a.tranbalance !=  ledgerbalance_1 ;
	
	if  trandaccount_1 is null then 
		trandaccount_1 := 0 ;
	end if ;
	
	if  trancaccount_1 is null then 
		trancaccount_1 := 0 ;
	end if ;
	
	tranremain_1 :=  trandaccount_1 -  trancaccount_1 ;
	
	if  tranremain_1 <> 0 then 
		insert into FnaAccountDepartment(ledgerid,departmentid,tranperiods,tranaccount,tranbalance) 
		values( ledgerid_1, departmentid_1, fnayearperiods_1, tranremain_1, ledgerbalance_1) ; 
	end if ;
 end loop ;
 
 /*将所有的总帐与成本中心的收支进行统计 */ 
 for costcentersupledger_cursor in ( select * from TM_FnaYearsPeriodsListClose2)
 loop 
	ledgerid_1 := costcentersupledger_cursor.ledgerid ;
	costcenterid_1 := costcentersupledger_cursor.costcenterid ;
	ledgerbalance_1 := costcentersupledger_cursor.ledgerbalance ;
	trandaccount_1 := 0 ;
	trancaccount_1 := 0 ;
	tranremain_1 := 0 ;
	tmplegderstr_1 := concat(concat('%' , TO_CHAR(ledgerid_1)) , '|%') ;

	select  sum(a.tranaccount) into trandaccount_1 from FnaAccountCostcenter a , FnaLedger b 
	where a.ledgerid = b.id and b.supledgerall like  tmplegderstr_1 and a.costcenterid =  costcenterid_1 
	and a.tranperiods =  fnayearperiods_1 and a.tranbalance =  ledgerbalance_1 ;
	
	select  sum(a.tranaccount) into trancaccount_1 from FnaAccountCostcenter a , FnaLedger b 
	where a.ledgerid = b.id and b.supledgerall like  tmplegderstr_1 and a.costcenterid =  costcenterid_1 
	and a.tranperiods =  fnayearperiods_1 and a.tranbalance !=  ledgerbalance_1 ;
	
	if  trandaccount_1 is null then 
		trandaccount_1 := 0 ;
	end if ;
	
	if  trancaccount_1 is null then 
		trancaccount_1 := 0 ;
	end if ;
	
	tranremain_1 :=  trandaccount_1 -  trancaccount_1 ;
	
	if  tranremain_1 <> 0 then
		insert into FnaAccountCostcenter(ledgerid,costcenterid,tranperiods,tranaccount,tranbalance) 
		values( ledgerid_1, costcenterid_1, fnayearperiods_1, tranremain_1, ledgerbalance_1) ;
	end if ;
 end loop ;
 
 /*建立临时表, 保存部门和总帐(非明细), 成本中心和总帐(非明细) 的所有预算记录 */ 
 

 fnayear_1 := substr( fnayearperiods_1 ,1,4)  ;
 theperiods_1 := TO_NUMBER( substr( fnayearperiods_1,1,2) )   ;
 
 for budgetdepartmentmodule_cursor in ( select a.id aid, b.id bid, c.id cid from  FnaLedger a, 
					HrmDepartment b ,FnaBudgetModule c where subledgercount != 0 
					and c.fnayear =  fnayear_1 and c.periodsidfrom <=  theperiods_1 
					and c.periodsidto >=  theperiods_1)
 loop 
	ledgerid_1 := budgetdepartmentmodule_cursor.aid ;
	departmentid_1 := budgetdepartmentmodule_cursor.bid ;
	budgetmoduleid_1 := budgetdepartmentmodule_cursor.cid ;

	insert into TM_FnaYearsPeriodsListClose3 values( ledgerid_1, departmentid_1, budgetmoduleid_1) ;
 end loop ;
 
 for budgetcostcentermodule_cursor in ( select a.id aid, b.id bid, c.id cid from  FnaLedger a, HrmCostcenter b ,
					FnaBudgetModule c where subledgercount != 0 and c.fnayear =  fnayear_1 
					and c.periodsidfrom <=  theperiods_1 and c.periodsidto >=  theperiods_1)
 loop 
	ledgerid_1 := budgetcostcentermodule_cursor.aid ;
	costcenterid_1 := budgetcostcentermodule_cursor.bid ;
	budgetmoduleid_1 := budgetcostcentermodule_cursor.cid ;

	insert into TM_FnaYearsPeriodsListClose4 values( ledgerid_1, costcenterid_1, budgetmoduleid_1) ;
 end loop ;
 
 /*将所有的总帐与部门的预算进行统计 */ 
 for departmentsupledgerbudget in ( select * from TM_FnaYearsPeriodsListClose3 )
 loop
	ledgerid_1 := departmentsupledgerbudget.ledgerid ;
	departmentid_1 := departmentsupledgerbudget.departmentid ;
	budgetmoduleid_1 := departmentsupledgerbudget.budgetmoduleid ;
	
	budgetaccount_1 := 0 ;
	tmplegderstr_1 := concat(concat('%' , TO_CHAR(ledgerid_1)) , '|%') ;
	
	select  sum(budgetaccount) into budgetaccount_1 from FnaBudgetList a , FnaLedger b 
	where a.ledgerid = b.id and b.supledgerall like  tmplegderstr_1 and a.budgetdepartmentid =  departmentid_1 
	and a.budgetperiods =  fnayearperiods_1 and a.budgetmoduleid =  budgetmoduleid_1 ;
	
	if  budgetaccount_1 <> 0 then 
		insert into FnaBudgetDepartment(ledgerid,departmentid,budgetmoduleid,budgetperiods,budgetaccount) 
		values( ledgerid_1, departmentid_1, budgetmoduleid_1, budgetperiods_1, budgetaccount_1) ;
	end if ;
 end loop ;
 
 /*将所有的总帐与成本中心的预算进行统计 */ 
 for  costcentersupledgerbudget in ( select * from TM_FnaYearsPeriodsListClose4)
 loop
	ledgerid_1 := costcentersupledgerbudget.ledgerid ;
	costcenterid_1 := costcentersupledgerbudget.costcenterid ;
	budgetmoduleid_1 := costcentersupledgerbudget.budgetmoduleid ;
	
	budgetaccount_1 := 0 ;
	tmplegderstr_1 := concat(concat('%' , TO_CHAR(ledgerid_1)) , '|%') ;
	
	select  sum(budgetaccount) into budgetaccount_1 from FnaBudgetList a , FnaLedger b 
	where a.ledgerid = b.id and b.supledgerall like  tmplegderstr_1 and a.budgetcostcenterid =  costcenterid_1 
	and a.budgetperiods =  fnayearperiods_1 and a.budgetmoduleid =  budgetmoduleid_1 ;
	
	if  budgetaccount_1 <> 0 then
		insert into FnaBudgetCostcenter(ledgerid,costcenterid,budgetmoduleid,budgetperiods,budgetaccount) 
		values( ledgerid_1, costcenterid_1, budgetmoduleid_1, budgetperiods_1, budgetaccount_1) ;
	end if ;
 end loop ;

 /* 将所有分录状态改为结帐 */ 
 update FnaTransaction set transtatus = '3' where tranperiods =  fnayearperiods_1  ;
 
 /* 将所有预算状态改为结帐 */ 
 update FnaBudget set budgetstatus = '3' where budgetperiods =  fnayearperiods_1   ;
 
 /* 将该期间关闭*/ 
 UPDATE FnaYearsPeriodsList SET  isclose = '1' WHERE ( id =  id_1)  ;

 end;
/

CREATE or replace PROCEDURE FnaYearsPeriodsList_Insert 
(fnayearid_1 	integer,
 Periodsid_2 	integer, 
 fnayear_3 	char, 
 startdate_4 	char, 
 enddate_5 	char,
 isactive_6 	char,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
fnayearperiodsid_1 char(6);
begin
if Periodsid_2 <= 9 then
fnayearperiodsid_1:=fnayear_3 ||'0' || to_char(Periodsid_2); 
else
fnayearperiodsid_1:= fnayear_3 || to_char(Periodsid_2);
end if;
INSERT INTO FnaYearsPeriodsList ( fnayearid, Periodsid, fnayear, startdate, enddate, isactive,
fnayearperiodsid)  VALUES ( fnayearid_1, Periodsid_2, fnayear_3, startdate_4, enddate_5,
 isactive_6, fnayearperiodsid_1);
end;
/

CREATE or replace PROCEDURE FnaYearsPeriodsList_Reopen 
(id_1 	integer,
 fnayearperiods_1 char,
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 AS 
count_1 integer;
begin
select count(id) into count_1 from FnaYearsPeriodsList where fnayearperiodsid > fnayearperiods_1
and isclose ='1' ;
if count_1<> 0 then
open thecursor for
select -1 from dual; 
return; 
end  if;
delete FnaAccount where tranperiods = fnayearperiods_1;
delete FnaAccountDepartment where tranperiods = fnayearperiods_1;
delete FnaAccountCostcenter where tranperiods = fnayearperiods_1;
delete FnaAccountList where tranperiods > fnayearperiods_1;
delete FnaBudgetDepartment where budgetperiods = fnayearperiods_1;
delete FnaBudgetCostcenter where budgetperiods = fnayearperiods_1;
update FnaTransaction set transtatus = '2' where tranperiods = fnayearperiods_1;
update FnaTransaction set transtatus = '1' where tranperiods > fnayearperiods_1;
update FnaBudget set budgetstatus = '2' where budgetperiods = fnayearperiods_1;
UPDATE FnaYearsPeriodsList SET  isclose='0' WHERE ( id=id_1);
end;
/

 CREATE or REPLACE PROCEDURE FnaYearsPeriodsList_SByFnayear 
  (id_1 	integer,  
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
open thecursor for 
 select * from FnaYearsPeriodsList where fnayearid =  id_1; 
 
 end;
/

CREATE or replace PROCEDURE FnaYearsPeriodsList_SelectByID
(id_1 	integer, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
count_1 integer;
fnayearperiodsid_1 char(6);
fnayearperiodsid_count integer;
begin
select count(fnayearperiodsid) into fnayearperiodsid_count from FnaYearsPeriodsList where id = id_1 ;
if fnayearperiodsid_count>0 then

select fnayearperiodsid into fnayearperiodsid_1 from FnaYearsPeriodsList where id = id_1 ;
end if;

select count(id) into count_1 from FnaTransaction where tranperiods = fnayearperiodsid_1;
if count_1 = 0 then
select count(id) into count_1 from FnaBudget where budgetperiods = fnayearperiodsid_1;
open thecursor for
select id,fnayearid,Periodsid,fnayear,startdate,enddate,isclose,isactive,fnayearperiodsid,
count_1 as trancount from FnaYearsPeriodsList where id = id_1;
end if;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriodsList_Update 
(id_1 	integer,
 startdate_2 	char,
 enddate_3 	char, 
 fnayearid_4    integer, 
 isactive_5 	char,
 flag out integer , 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 minfromdate_1 char(10); 
 maxenddate_1 char(10); 
begin
UPDATE FnaYearsPeriodsList SET  startdate=startdate_2, enddate=enddate_3 , isactive=isactive_5
WHERE ( id=id_1);
select min(startdate) into minfromdate_1 from FnaYearsPeriodsList 
where fnayearid=fnayearid_4 and (startdate <> '' AND startdate is not null);
select  max(enddate) into maxenddate_1 from FnaYearsPeriodsList 
where fnayearid=fnayearid_4 and (enddate <> '' AND enddate is not null) ;
update FnaYearsPeriods set startdate=minfromdate_1 , enddate = maxenddate_1 where id = fnayearid_4;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_Delete 
(id_1 	integer,
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS 
count_1 integer;
begin
select count(id) into count_1 from FnaYearsPeriodsList where fnayearid = id_1 
and isclose ='1';  
if count_1 <> 0 then
open thecursor for
select '20' from dual;
return ;
end if;
DELETE FnaYearsPeriods  WHERE ( id=id_1);
DELETE FnaYearsPeriodsList where  fnayearid = id_1;
end;
/

 CREATE or replace PROCEDURE FnaYearsPeriods_Insert 
(fnayear_1 	char, 
startdate_2 	char, 
enddate_3 	char,
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS
count_1 integer;
begin
select count(id) into count_1 from FnaYearsPeriods where fnayear =  fnayear_1;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return;
end if;
INSERT INTO FnaYearsPeriods (fnayear,startdate,enddate) VALUES ( fnayear_1, startdate_2, enddate_3); 
open thecursor for 
select max(id) from FnaYearsPeriods;
end;
/

 CREATE or REPLACE PROCEDURE FnaYearsPeriods_SDefaultBudget 
  (fnayear_1    char, 
  flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
budgetid_1 integer;
budgetid_count integer;
begin 

 select  count(budgetid) into budgetid_count from FnaYearsPeriods where fnayear =  fnayear_1;
 if(budgetid_count>0 )then

 select  budgetid into budgetid_1 from FnaYearsPeriods where fnayear =  fnayear_1;
 end if;

 if  budgetid_1 is null or  budgetid_1 =0 then 
 open thecursor for 
 select min(id) from FnaBudgetModule where fnayear =  fnayear_1;
 return;
 else 
 open thecursor for 
 select  budgetid_1 from dual ;
 return;
 end if;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_Select 
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
 begin 
 open thecursor for 
 select * from FnaYearsPeriods;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_SelectByID
(id_1 	integer,
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
open thecursor for 
select * from FnaYearsPeriods where id = id_1;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_SelectMaxYear
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
fnayear_1 char(4);
fnayear_count integer;
begin
select count(fnayear) into fnayear_count from FnaYearsPeriods ;
if fnayear_count>0 then
select max(fnayear) into fnayear_1 from FnaYearsPeriods ;
end if;

open thecursor for
select * from FnaYearsPeriods where fnayear = fnayear_1;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_Update 
(id_1 	integer, 
budgetid_2 	integer, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin
update FnaYearsPeriods  SET  budgetid=budgetid_2  WHERE ( id=id_1);
end;
/

 CREATE or REPLACE PROCEDURE HrmAbsense1_Delete 
	( id_1 	integer,
	 flag                   out integer, 
	 msg                   varchar2 )

as 
begin 

 DELETE Bill_HrmResourceAbsense WHERE ( id=  id_1);

 end;
/

 CREATE or replace PROCEDURE HrmAbsense1_Insert
	(departmentid_1 	integer,
	 resourceid_2 	integer,
	 absenseremark_3 	varchar2,
	 startdate_4 	char,
	 starttime_5 	char,
	 enddate_6 	char,
	 endtime_7 	char,
	 absenseday_8 	decimal,
	 workflowid_9 	integer,
	 workflowname_10 	varchar2,
	 usestatus_11 	char,
	 flag out integer ,
     msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
insert into Bill_HrmResourceAbsense 
	 (departmentid,
	 resourceid,
	 absenseremark,
	 startdate,
	 starttime,
	 enddate,
	 endtime,
	 absenseday,
	 workflowid,
	 workflowname,
	 usestatus) 
VALUES (departmentid_1,
	 resourceid_2,
	 absenseremark_3,
	 startdate_4,
	 starttime_5,
	 enddate_6,
	 endtime_7,
	 absenseday_8,
	 workflowid_9,
	 workflowname_10,
	 usestatus_11);
end;
/

 CREATE or replace PROCEDURE HrmAbsense1_SelectByID
(id_1 varchar2 , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for 
select * from Bill_HrmResourceAbsense where id =TO_NUMBER(id_1);
end;
/

 CREATE or REPLACE PROCEDURE HrmAbsense1_SelectByResourceID 
	  (resourceid_1 varchar2 , 
	  flag out integer , 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from Bill_HrmResourceAbsense
      where resourceid =to_number(resourceid_1);
 
 end;
/

CREATE or replace PROCEDURE HrmAbsense1_Update
	(id_1 	integer,
	 departmentid_2 	integer,
	 resourceid_3 	integer,
	 absenseremark_4 	varchar2,
	 startdate_5 	char,
	 starttime_6 	char,
	 enddate_7 	char,
	 endtime_8 	char,
	 absenseday_9 	decimal,
	 workflowid_10 	integer,
	 workflowname_11 	varchar2,
	 usestatus_12 	char,
	 flag out integer ,
         msg out varchar2, 
         thecursor IN OUT cursor_define.weavercursor)  

as begin update Bill_HrmResourceAbsense 

SET  departmentid=departmentid_2,
	 resourceid=resourceid_3,
	 absenseremark=absenseremark_4,
	 startdate=startdate_5,
	 starttime=starttime_6,
	 enddate=enddate_7,
	 endtime=endtime_8,
	 absenseday=absenseday_9,
	 workflowid=workflowid_10,
	 workflowname=workflowname_11,
	 usestatus=usestatus_12 

WHERE 
	( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmActivitiesCompetency_Delete 
(jobactivityid_1 	integer, 
flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as 
begin 
delete HrmActivitiesCompetency WHERE ( jobactivityid=jobactivityid_1);
end;
/

CREATE or replace PROCEDURE HrmActivitiesCompetency_Insert 
(jobactivityid_1 	integer,
 competencyid_2 	integer,
 flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as 
begin
insert into HrmActivitiesCompetency ( jobactivityid, competencyid)  VALUES 
( jobactivityid_1, competencyid_2);
end;
/

 CREATE or REPLACE PROCEDURE HrmActivitiesCompetency_Select 
 ( jobactivityid_1 	integer, 
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as 
begin 
open thecursor for 
 select * from  HrmActivitiesCompetency where jobactivityid = to_number(jobactivityid_1) ;
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmApplyRemark_Insert 
	( applyid_1 	integer,
	  remark_2 	varchar2,
	  resourceid_3 	integer,
	  date_4 	char,
	  time_5 	char,
	 flag out integer , 
  	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 
 
 INSERT into HrmApplyRemark 
	 (applyid,
	 remark,
	 resourceid,
	 date_n,
	 time) 
 
VALUES 
	(  applyid_1,
	  remark_2,
	  resourceid_3,
	  date_4,
	  time_5);

 end;
/

/*2002-8-9*/
 CREATE or REPLACE PROCEDURE HrmApplyRemark_Select 
(applyid_1	integer,
 flag  out integer, 
 msg   out  varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for 
select * from HrmApplyRemark where applyid =  applyid_1;
 
 end;
/

CREATE or replace PROCEDURE HrmBank_Delete
 (id_1 	integer,
 flag out integer, 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor )  
as 
begin 
delete from hrmbank where id=id_1;
end;
/

CREATE or replace PROCEDURE HrmBank_Insert 
( bankname_1	varchar2,
  bankdesc_1	varchar2, 
  checkstr_1	varchar2,
   flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
  as 
  begin 
  insert into hrmbank(bankname,bankdesc,checkstr) values(bankname_1,bankdesc_1,checkstr_1);
  open thecursor for
  select max(id) from hrmbank ; 
 end;
/

CREATE or replace PROCEDURE HrmBank_SelectAll 
( flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )   
as
begin
open thecursor for
 select * from HrmBank order by id ;
end;
/

CREATE or replace PROCEDURE HrmBank_Update 
(id_1 	integer,
 bankname_1	varchar2,
 bankdesc_1	varchar2,
 checkstr_1	varchar2,
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
 begin
 update hrmbank set bankname=bankname_1,bankdesc=bankdesc_1, checkstr=checkstr_1 where id=id_1;
end;
/ 

 CREATE or REPLACE PROCEDURE HrmCareerApplyOtherInfo_SByApp 
 (applyid_1 	integer, 
 flag	out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 SELECT * FROM HrmCareerApplyOtherInfo WHERE applyid  =  applyid_1; 
 
 end;
/

CREATE or replace PROCEDURE HrmCareerApply_Delete 
(id_1 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin
delete HrmEducationInfo where resourceid = id_1;
 delete HrmWorkResume where resourceid = id_1 ;
 DELETE HrmCareerApply WHERE ( id=id_1) ;
 delete HrmCareerApplyOtherInfo where applyid = id_1;
end;
/

CREATE or replace PROCEDURE HrmCareerApply_Insert 
(id_1 	integer, 
 ischeck_1 char,
 ishire_1		char, 
 careerid_1	integer,
 firstname_2 	varchar2,
 lastname_3 	varchar2,
 titleid_4 	integer, 
 sex_5 	char,
 birthday_6 	char,
 nationality_7  IN OUT	integer,
 defaultlanguage_8  IN OUT	integer,
 certificateCategory_9 	varchar2,
 certificatenum_10 	varchar2, 
 nativeplace_11 	varchar2, 
 educationlevel_12 	char,
 bememberdate_13 	char,
 bepartydate_14 	char,
 bedemocracydate_15 	char,
 regresidentplace_16 	varchar2,
 healthinfo_17 	char,
 residentplace_18 	varchar2,
 policy_19 	varchar2,
 degree_20 	varchar2,
 height_21 	varchar2,
 homepage_22 	varchar2,
 maritalstatus_23 	char,
 marrydate_24 	char, 
 train_25 	varchar2,
 email_26 	varchar2,
 homeaddress_27 	varchar2,
 homepostcode_28 	varchar2,
 homephone_29 	varchar2,
 Category_3 	char,
 contactor_4 	varchar2,
 major_5 	varchar2,
 salarynow_6 	varchar2,
 worktime_7 	varchar2,
 salaryneed_8 	varchar2,
 currencyid_9 	integer,
 reason_10 	varchar2,
 otherrequest_11 	varchar2,
 selfcomment_12 	varchar2,
 createdate_1		char,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 dfdf integer;
begin
	if nationality_7=0 then
		nationality_7:= null;
	end if;

	if defaultlanguage_8=0 then 
		defaultlanguage_8:= null;
	end if;

	INSERT INTO HrmCareerApply 
	(id, ischeck, ishire, careerid, firstname, lastname, titleid, sex, 
	birthday, nationality, defaultlanguage, certificatecategory, certificatenum, nativeplace, 
	educationlevel, bememberdate, bepartydate, bedemocracydate, regresidentplace, healthinfo, 
	residentplace, policy, degree, height, homepage, maritalstatus, marrydate, train, email, 
	homeaddress, homepostcode, homephone, createrid, createdate) 
	VALUES(id_1, ischeck_1, ishire_1,careerid_1, firstname_2, lastname_3, titleid_4, 
	sex_5, birthday_6, nationality_7, defaultlanguage_8, certificateCategory_9, certificatenum_10,
	nativeplace_11, educationlevel_12,bememberdate_13, bepartydate_14, bedemocracydate_15, 
	regresidentplace_16, healthinfo_17, residentplace_18, policy_19, degree_20, height_21,
	homepage_22, maritalstatus_23,marrydate_24, train_25, email_26, homeaddress_27, 
	homepostcode_28, homephone_29, id_1,createdate_1);

	INSERT INTO HrmCareerApplyOtherInfo (applyid, Category, contactor, major, salarynow, worktime,
	salaryneed, currencyid, reason, otherrequest, selfcomment)  VALUES ( id_1, Category_3, contactor_4,
	major_5, salarynow_6, worktime_7, salaryneed_8, currencyid_9, reason_10, otherrequest_11,
	selfcomment_12);
end;
/

CREATE or replace PROCEDURE HrmCareerApply_SelectById
 (id_1 	integer, 
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as begin open thecursor for select * FROM HrmCareerApply WHERE id  = id_1;
end;
/

CREATE or replace PROCEDURE HrmCareerApply_Update 
(id_1  	integer,
judge_1 	char, 
flag  out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
if judge_1='0' then
UPDATE HrmCareerApply SET  ischeck=1 WHERE ( id=id_1) ;
else 
UPDATE HrmCareerApply SET  ishire=1 WHERE ( id=id_1);
end if;
end;
/

CREATE or replace PROCEDURE HrmCareerInvite_Delete 
(id_1 	integer, 
flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 as
 begin delete HrmCareerInvite  WHERE ( id=id_1);
end;
/


 CREATE or replace PROCEDURE HrmCareerInvite_Insert 
(careername_1 	varchar2,
 careerpeople_2 	char,
 careerage_3 	varchar2,
 careersex_4 	char, 
 careeredu_5 	char,
 careermode_6 	varchar2,
 careeraddr_7 	varchar2,
 careerclass_8 	varchar2,
 careerdesc_9 	varchar2,
 careerrequest_10 	varchar2,
 careerremark_11 	varchar2,
 createrid_12 	integer, 
 createdate_13 	char,
 flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
insert into HrmCareerInvite ( careername, careerpeople, careerage, careersex, careeredu, 
careermode, careeraddr, careerclass, careerdesc, careerrequest, careerremark, createrid, createdate)  
VALUES ( careername_1, careerpeople_2, careerage_3, careersex_4, careeredu_5, careermode_6,
 careeraddr_7, careerclass_8, careerdesc_9, careerrequest_10, careerremark_11, createrid_12, 
createdate_13);
end;
/

CREATE or replace PROCEDURE HrmCareerInvite_Select 
( flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
 begin open thecursor for select * FROM HrmCareerInvite;
end;
/

CREATE or replace PROCEDURE HrmCareerInvite_SelectById
(id_1 	integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
 open thecursor for select * FROM HrmCareerInvite WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE HrmCareerInvite_Update 
(id_1 	integer,
 careername_2 	varchar2, 
 careerpeople_3 	char,
 careerage_4 	varchar2,
 careersex_5 	char,
 careeredu_6 	char,
 careermode_7 	varchar2, 
 careeraddr_8 	varchar2, 
 careerclass_9 	varchar2, 
 careerdesc_10 	varchar2, 
 careerrequest_11 	varchar2, 
 careerremark_12 	varchar2, 
 lastmodid_13 	integer, 
 lastmoddate_14 	char, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
update HrmCareerInvite SET  careername=careername_2, careerpeople=careerpeople_3,
careerage=careerage_4, careersex=careersex_5, careeredu=careeredu_6, careermode=careermode_7, 
careeraddr=careeraddr_8, careerclass=careerclass_9, careerdesc=careerdesc_10, 
careerrequest=careerrequest_11, careerremark=careerremark_12, lastmodid=lastmodid_13, 
lastmoddate=lastmoddate_14  WHERE ( id=id_1);
end;
/


CREATE or replace PROCEDURE HrmCareerWorkexp_DByApplyId
 (applyid_1 	integer, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 as
 begin 
delete HrmCareerWorkexp  WHERE ( applyid = applyid_1);
end;
/

CREATE or replace PROCEDURE HrmCareerWorkexp_Insert 
(ftime_1 	char, 
ttime_2 	char, 
company_3 	varchar2, 
jobtitle_4 	varchar2,
workdesc_5 	varchar2, 
applyid_6 	integer,
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
insert into HrmCareerWorkexp ( ftime, ttime, company, jobtitle, workdesc, applyid) 
 VALUES ( ftime_1, ttime_2, company_3, jobtitle_4, workdesc_5, applyid_6);
end;
/

 CREATE or REPLACE PROCEDURE HrmCareerWorkexp_SByApplyId 
 ( applyid_1 	integer, 
 flag	out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 SELECT * FROM HrmCareerWorkexp WHERE applyid  =  applyid_1; 
 
 end;
/

CREATE or replace PROCEDURE HrmCertification_Delete
	(id_1 	integer,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin delete HrmCertification 

WHERE 
	( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmCertification_Insert
	(resourceid_1 	integer,
	 datefrom_2 	char,
	 dateto_3 	char,
	 certname_4 	varchar2,
	 awardfrom_5 	varchar2,
	 createid_6 	integer,
	 createdate_7 	char,
	 createtime_8 	char,
	 lastmoderid_9 	integer,
	 lastmoddate_10 	char,
	 lastmodtime_11 	char,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin insert into HrmCertification 
	 ( resourceid,
	 datefrom,
	 dateto,
	 certname,
	 awardfrom,
	 createid,
	 createdate,
	 createtime,
	 lastmoderid,
	 lastmoddate,
	 lastmodtime) 
 
VALUES 
	( resourceid_1,
	 datefrom_2,
	 dateto_3,
	 certname_4,
	 awardfrom_5,
	 createid_6,
	 createdate_7,
	 createtime_8,
	 lastmoderid_9,
	 lastmoddate_10,
	 lastmodtime_11);
end;
/

CREATE or replace PROCEDURE HrmCertification_SelectByID
	(id_1 varchar2 , 
	 flag out integer , 
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
 as 
begin
open thecursor for select * from HrmCertification where id =TO_NUMBER(id_1); 
end;
/


CREATE or REPLACE PROCEDURE HrmCertification_SByResource 
	  (resourceid_1 varchar2, 
	  flag out integer , 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmCertification
      where resourceid = to_number(resourceid_1);
 
 end;
/

CREATE or replace PROCEDURE HrmCertification_Update
	(id_1 	integer,
	 resourceid_2 	integer,
	 datefrom_3 	char,
	 dateto_4 	char,
	 certname_5 	varchar2,
	 awardfrom_6 	varchar2,
	 lastmoderid_7 	integer,
	 lastmoddate_8 	char,
	 lastmodtime_9 	char,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin update HrmCertification 

SET  resourceid=resourceid_2,
	 datefrom=datefrom_3,
	 dateto=dateto_4,
	 certname=certname_5,
	 awardfrom=awardfrom_6,
	 lastmoderid=lastmoderid_7,
	 lastmoddate=lastmoddate_8,
	 lastmodtime=lastmodtime_9 

WHERE 
	( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmCity_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as
begin 
delete HrmCity  WHERE ( id=id_1);
end;
/ 

CREATE or replace PROCEDURE HrmCity_Insert 
(cityname_1 	varchar2,
 citylongitude_1 number,  
citylatitude_1 number, 
provinceid_1 integer, 
countryid_1 integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as begin insert into HrmCity ( cityname, citylongitude, citylatitude, provinceid, countryid )  
VALUES ( cityname_1, citylongitude_1, citylatitude_1, provinceid_1, countryid_1);
open thecursor for
select max(id) from HrmCity;
end;
/

CREATE or replace PROCEDURE HrmCity_Select
(countryid_1 integer, 
provinceid_1 integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
if countryid_1 = 0 then
open thecursor for
select * from HrmCity;
elsif provinceid_1= 0 then
open thecursor for
select * from HrmCity where countryid = countryid_1;
else 
open thecursor for
select * from HrmCity where countryid = countryid_1 and provinceid = provinceid_1;
end if;
end;
/

CREATE or replace PROCEDURE HrmCity_Update 
(id_1 	integer,
 cityname_1 	varchar2 , 
 citylongitude_1 number, 
 citylatitude_1 number,
 provinceid_1 integer, 
 countryid_1 integer,
 flag out integer, 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor )  
as 
begin 
update HrmCity  SET  cityname=cityname_1, citylongitude = citylongitude_1, 
citylatitude = citylatitude_1, provinceid = provinceid_1, countryid = countryid_1  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmCompany_Select 
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin open thecursor for select * from HrmCompany;
end;
/

CREATE or replace PROCEDURE HrmCompany_Update 
(id_1 	smallint,
 companyname_2 	varchar2, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin update HrmCompany  SET  companyname=companyname_2  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmCompetency_Delete 
(id_1 	integer,
 flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
delete HrmCompetency  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmCompetency_Insert
 (competencymark_1 	varchar2,
 competencyname_2 	varchar2,
 competencyremark_3 	varchar2,
 flag out integer, 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor )  
 as
 begin
 insert into HrmCompetency ( competencymark, competencyname, competencyremark)  
 VALUES ( competencymark_1, competencyname_2, competencyremark_3); 
open thecursor for
select max(id) from  HrmCompetency;
end;
/

CREATE or replace PROCEDURE HrmCompetency_Select
( flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin open thecursor for select * from HrmCompetency;
end;
/

CREATE or replace PROCEDURE HrmCompetency_SelectByID
(id_1 varchar2 ,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin open thecursor for 
select * from HrmCompetency where id =TO_NUMBER(id_1);
end;
/

CREATE or replace PROCEDURE HrmCompetency_Update 
(id_1 	integer,
 competencymark_2 	varchar2,
competencyname_3 	varchar2, 
competencyremark_4 	varchar2, 
flag out integer, msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )  
as
 begin 
update HrmCompetency  SET  competencymark=competencymark_2, competencyname=competencyname_3,
 competencyremark=competencyremark_4  WHERE ( id=id_1);
end;
/

 CREATE or REPLACE PROCEDURE HrmCostcenterMainCategory_S 
  (flag out integer ,  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmCostcenterMainCategory ;
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmCostcenterMainCategory_U 
 ( id_1 	smallint,  
 ccmaincategoryname_2 	varchar2, 
 flag out integer,  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 

 UPDATE HrmCostcenterMainCategory  SET  ccmaincategoryname =  ccmaincategoryname_2  WHERE ( id =  id_1);

 end;
/

 CREATE or REPLACE PROCEDURE HrmCostcenterSubCategory_D 
 (id_1 integer, 
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
as 
recordercount integer;
begin 
 Select  count(id) into recordercount from HrmCostcenter where ccsubcategory1 =to_number(id_1)  or ccsubcategory2 =to_number(id_1) or ccsubcategory3 =to_number(id_1)  or ccsubcategory4 =to_number(id_1);
 if  recordercount = 0 then 
 DELETE HrmCostcenterSubCategory  WHERE ( id =  id_1) ; 
 else 
 open thecursor for 
 select '20' from dual;
 end if;
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmCostcenterSubCategory_I 
 ( ccsubcategoryname_1 	varchar2,  
 ccsubcategorydesc_2 	varchar2,  
 ccmaincategoryid_3 	smallint, 
 flag out integer,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
  INSERT into HrmCostcenterSubCategory ( ccsubcategoryname, ccsubcategorydesc, ccmaincategoryid )  VALUES (  ccsubcategoryname_1,  ccsubcategorydesc_2,  ccmaincategoryid_3 ); 
  open thecursor for 
  select (max(id)) from HrmCostcenterSubCategory ;
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmCostcenterSubCategory_S 
  (flag out integer ,  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmCostcenterSubCategory ; 
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmCostcenterSubCategory_U 
 ( id_1 	integer,  
 ccsubcategoryname_2 	varchar2,  
 ccsubcategorydesc_3 	varchar2, 
 ccmaincategoryid_4 	smallint,  
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 

 UPDATE HrmCostcenterSubCategory  SET  ccsubcategoryname =  ccsubcategoryname_2, ccsubcategorydesc	 =  ccsubcategorydesc_3, ccmaincategoryid =  ccmaincategoryid_4  WHERE ( id	 =  id_1);

 end;
/

CREATE or replace PROCEDURE HrmCostcenter_Delete 
(id_1 	integer,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
AS
recordercount_1 integer;
begin
Select count(id) INTO recordercount_1 from HrmResource where costcenterid =TO_NUMBER(id_1);

if recordercount_1 = 0 then
DELETE HrmCostcenter  WHERE ( id=id_1); 
else
open thecursor for
select '20'  from dual;
end if;
end;
/

CREATE or replace PROCEDURE HrmCostcenter_Insert 
(costcentermark_1 	varchar2,
 costcentername_2 	varchar2, 
activable_3 	char, 
departmentid_4 	integer, 
ccsubCategory1_5 	integer, 
ccsubCategory2_6 	integer, 
ccsubCategory3_7 	integer, 
ccsubCategory4_8 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
insert into HrmCostcenter ( costcentermark, costcentername, activable, departmentid,ccsubCategory1,
 ccsubCategory2, ccsubCategory3, ccsubCategory4)  VALUES 
(costcentermark_1, costcentername_2, activable_3, departmentid_4, ccsubCategory1_5,
 ccsubCategory2_6, ccsubCategory3_7, ccsubCategory4_8);
open thecursor for
select max(id) from HrmCostcenter;
end;
/

CREATE or replace PROCEDURE HrmCostcenter_Select
(flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin
 open thecursor for select * from HrmCostcenter;
end;
/

CREATE or replace PROCEDURE HrmCostcenter_SelectByDeptID
(id_1 varchar2 , 
 groupby_1 varchar2 ,
 flag out integer , 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
 AS 
 begin
if TO_NUMBER(groupby_1)=1 then 
open thecursor for
select ccsubCategory1 from HrmCostcenter where departmentid =TO_NUMBER( id_1) 
group by ccsubCategory1; 
elsif TO_NUMBER(groupby_1)=2 then
open thecursor for
select ccsubCategory2 from HrmCostcenter where departmentid =TO_NUMBER(id_1) 
group by ccsubCategory2;
elsif TO_NUMBER(groupby_1)=3 then
open thecursor for
select ccsubCategory3 from HrmCostcenter where departmentid =TO_NUMBER(id_1) 
group by ccsubCategory3;
elsif TO_NUMBER(groupby_1)=4 then
open thecursor for
select ccsubCategory4 from HrmCostcenter where departmentid=TO_NUMBER(id_1) 
group by ccsubCategory4;
end if;
end;
/

CREATE or replace PROCEDURE HrmCostcenter_SelectByID
(id_1 varchar2 , 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select * from HrmCostcenter where id =TO_NUMBER(id_1);
end;
/

CREATE or replace PROCEDURE HrmCostcenter_Update 
(id_1 	integer, 
costcentermark_2 	varchar2, 
costcentername_3 	varchar2, 
activable_4 	char,
departmentid_5 	integer,
ccsubCategory1_6 	integer,
ccsubCategory2_7 	integer,
ccsubCategory3_8 	integer,
ccsubCategory4_9 	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin
update HrmCostcenter  SET  costcentermark=costcentermark_2, costcentername=costcentername_3, 
activable=activable_4, departmentid=departmentid_5, ccsubCategory1=ccsubCategory1_6, 
ccsubCategory2=ccsubCategory2_7, ccsubCategory3=ccsubCategory3_8, ccsubCategory4=ccsubCategory4_9  
WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmCountry_Delete 
(id_1 	integer,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as 
begin 
delete HrmCountry  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmCountry_Insert 
(countryname_1 	varchar2, 
countrydesc_2 	varchar2,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin
insert into HrmCountry ( countryname, countrydesc)  VALUES ( countryname_1, countrydesc_2);
open thecursor for
select max(id) from HrmCountry;
end;
/

CREATE or replace PROCEDURE HrmCountry_Select
(flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select * from HrmCountry;
end;
/

 CREATE or replace PROCEDURE HrmCountry_Update
(id_1 	integer,
countryname_2 	varchar2, 
countrydesc_3 	varchar2, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
update HrmCountry  SET  countryname=countryname_2, countrydesc=countrydesc_3 WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmDepartment_Delete 
(id_1 	integer, 
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin 
delete HrmDepartment  WHERE ( id=id_1);

open thecursor for
select count(id) ROWCOUNT from HrmDepartment where id=id_1;
end;
/

CREATE or replace PROCEDURE HrmDepartment_Insert 
(departmentmark_1 	varchar2,
departmentname_2 	varchar2,
countryid_3 	integer,
addedtax_4 	varchar2,
website_5 	varchar2,
startdate_6 	char,
enddate_7 	char,
currencyid_8 	integer,
seclevel_9 	smallint,
subcompanyid1_10 	integer,
subcompanyid2_11 	integer,
subcompanyid3_12 	integer,
subcompanyid4_13 	integer,
createrid_14 	integer,
createrdate_15 	char,
lastmoduserid_16 	integer,
lastmoddate_17 	char,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS  
begin
INSERT INTO HrmDepartment ( departmentmark, departmentname, countryid, addedtax, website, startdate,
enddate, currencyid, seclevel, subcompanyid1, subcompanyid2, subcompanyid3, subcompanyid4, createrid,
createrdate, lastmoduserid, lastmoddate)  VALUES ( departmentmark_1, departmentname_2, countryid_3,
addedtax_4, website_5, startdate_6, enddate_7, currencyid_8, seclevel_9, subcompanyid1_10,
subcompanyid2_11, subcompanyid3_12, subcompanyid4_13, createrid_14, createrdate_15,
lastmoduserid_16, lastmoddate_17);
open thecursor for
select (max(id)) from HrmDepartment;
end;
/

CREATE or replace PROCEDURE HrmDepartment_Select 
(flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for select * from HrmDepartment;
end;
/

CREATE or replace PROCEDURE HrmDepartment_SelectByID
(id_1 varchar2 ,
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmDepartment where id =to_number(id_1);
end;
/

 CREATE or replace PROCEDURE HrmDepartment_Update 
(id_1 	integer, 
departmentmark_2 	varchar2,
departmentname_3 	varchar2, 
countryid_4 	integer, 
addedtax_5 	varchar2,
website_6 	varchar2, 
startdate_7 	char, 
enddate_8 	char, 
currencyid_9 	integer,
seclevel_10 	smallint, 
subcompanyid1_11 	integer, 
subcompanyid2_12 	integer, 
subcompanyid3_13 	integer, 
subcompanyid4_14 	integer,
createrid_15 	integer, 
createrdate_16 	char, 
lastmoduserid_17 	integer, 
lastmoddate_18 	char, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor  )
as 
begin 
update HrmDepartment  SET  departmentmark=departmentmark_2, departmentname=departmentname_3, 
countryid=countryid_4, addedtax=addedtax_5, website=website_6, startdate=startdate_7, 
enddate=enddate_8, currencyid=currencyid_9, seclevel=seclevel_10, subcompanyid1=subcompanyid1_11,
subcompanyid2=subcompanyid2_12, subcompanyid3=subcompanyid3_13, subcompanyid4=subcompanyid4_14, 
createrid=createrid_15, createrdate=createrdate_16, lastmoduserid=lastmoduserid_17,
lastmoddate=lastmoddate_18  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmEducationInfo_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as begin delete HrmEducationInfo  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmEducationInfo_Insert 
(resourceid_1 	integer, 
startdate_2 	char, 
enddate_3 	char, 
school_4 	varchar2, 
speciality_5 	varchar2, 
educationlevel_6 	char, 
studydesc_7 	varchar2, 
createid_8 	integer, 
createdate_9 	char, 
createtime_10 	char, 
lastmoderid_11 	integer, 
lastmoddate_12 	char, 
lastmodtime_13 	char,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as
begin 
insert into HrmEducationInfo ( resourceid, startdate, enddate, school, speciality, educationlevel, 
studydesc, createid, createdate, createtime, lastmoderid, lastmoddate, lastmodtime) 
VALUES ( resourceid_1, startdate_2, enddate_3, school_4, speciality_5, educationlevel_6,
studydesc_7, createid_8, createdate_9, createtime_10, lastmoderid_11, lastmoddate_12, 
lastmodtime_13);
end;
/

 CREATE or REPLACE PROCEDURE HrmEducationInfo_SByResourceID 
  (resourceid_1 varchar2 , 
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
 select * from HrmEducationInfo where resourceid =to_number(resourceid_1);
 
 end;
/

CREATE or replace PROCEDURE HrmEducationInfo_SelectByID
(id_1 varchar2 ,
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmEducationInfo where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmEducationInfo_Update
(id_1 	integer,
resourceid_2 	integer,
startdate_3 	char, 
enddate_4 	char, 
school_5 	varchar2, 
speciality_6 	varchar2, 
educationlevel_7 	char, 
studydesc_8 	varchar2, 
lastmoderid_12 	integer, 
lastmoddate_13 	char, 
lastmodtime_14 	char,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
update HrmEducationInfo  SET  resourceid=resourceid_2, startdate=startdate_3, enddate=enddate_4, 
school=school_5, speciality=speciality_6, educationlevel=educationlevel_7, studydesc=studydesc_8,
lastmoderid=lastmoderid_12, lastmoddate=lastmoddate_13, lastmodtime=lastmodtime_14  
WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmFamilyInfo_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as begin delete HrmFamilyInfo  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmFamilyInfo_Insert
(resourceid_1 	integer,
member_2 	varchar2, 
title_3 	varchar2,
company_4 	varchar2,
jobtitle_5 	varchar2, 
address_6 	varchar2, 
createid_7 	integer, 
createdate_8 	char,
createtime_9 	char,
lastmoderid_10 	integer, 
lastmoddate_11 	char,
lastmodtime_12 	char,
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
insert into HrmFamilyInfo ( resourceid, member, title, company, jobtitle, address, createid,
createdate, createtime, lastmoderid, lastmoddate, lastmodtime)  VALUES ( resourceid_1, member_2, 
title_3, company_4, jobtitle_5, address_6, createid_7, createdate_8, createtime_9,
lastmoderid_10, lastmoddate_11, lastmodtime_12);
end;
/

 CREATE or REPLACE PROCEDURE HrmFamilyInfo_SbyResourceID 
  (resourceid_1 varchar2 , 
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmFamilyInfo where resourceid = to_number(resourceid_1);
 
 end;
/

CREATE or replace PROCEDURE HrmFamilyInfo_SelectByID
(id_1 varchar2 , 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for
select * from HrmFamilyInfo where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmFamilyInfo_Update 
(id_1 	integer,
resourceid_2 	integer, 
member_3 	varchar2,
title_4 	varchar2,
company_5 	varchar2,
jobtitle_6 	varchar2,
address_7 	varchar2,
lastmoderid_8 	integer,
lastmoddate_9 	char,
lastmodtime_10 	char,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
update HrmFamilyInfo  SET  resourceid=resourceid_2, member=member_3, title=title_4, 
company=company_5, jobtitle=jobtitle_6, address=address_7, lastmoderid=lastmoderid_8, 
lastmoddate=lastmoddate_9, lastmodtime=lastmodtime_10  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE HrmJobActivities_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as
begin
delete HrmJobActivities  WHERE ( id=id_1) ;
end;
/

 CREATE or REPLACE PROCEDURE HrmJobActivities_Insert 
 ( jobactivitymark_1 	varchar2,  
 jobactivityname_2 	varchar2,  
 docid_3 	 IN OUT integer,  
 jobactivityremark_4 	varchar2,  
 jobgroupid_5 	integer,  
 flag out integer,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as
begin  
 if  docid_3 = 0 then
 docid_3:=null ; 
 end if;
 INSERT into HrmJobActivities( jobactivitymark, jobactivityname, docid, jobactivityremark, jobgroupid)  
 VALUES(  jobactivitymark_1,  jobactivityname_2,  docid_3,  jobactivityremark_4,  jobgroupid_5); 
 open thecursor for 
 select max(id) from  HrmJobActivities ; 
 
 end;
/

CREATE or replace PROCEDURE HrmJobActivities_Select 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for select * from HrmJobActivities;
end;
/

CREATE or replace PROCEDURE HrmJobActivities_SelectByID
(id_1 varchar2 , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmJobActivities where id =to_number(id_1);
end;
/

 CREATE or REPLACE PROCEDURE HrmJobActivities_Update 
 ( id_1 	integer,  
 jobactivitymark_2 	varchar2,  
 jobactivityname_3 	varchar2, 
 docid_4  in out integer,  
 jobactivityremark_5 	varchar2,  
 jobgroupid_6 	integer,  
 flag out integer,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 

 if   docid_4= 0  then
 docid_4:=null;
 end if;
 UPDATE HrmJobActivities  SET  jobactivitymark	 =  jobactivitymark_2, jobactivityname	 =  jobactivityname_3, docid	 =  docid_4, jobactivityremark	 =  jobactivityremark_5, jobgroupid	 =  jobgroupid_6  WHERE ( id	 =  id_1);
 
 end;
/

CREATE or replace PROCEDURE HrmJobCall_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin
delete HrmJobCall  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmJobCall_Insert 
(name_1 	varchar2, 
description_2 	varchar2, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
insert into HrmJobCall ( name, description)  VALUES ( name_1, description_2);
end;
/

CREATE or replace PROCEDURE HrmJobCall_Select
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
select * from HrmJobCall;
end;
/

CREATE or replace PROCEDURE HrmJobCall_SelectByID 
(id_1 varchar2 , 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select * from HrmJobCall where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmJobCall_Update 
(id_1 	integer, 
name_2 	varchar2,
description_3 	varchar2, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
update HrmJobCall  SET  name=name_2, description=description_3  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmJobGroups_Delete 
(id_1 	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
delete HrmJobGroups  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmJobGroups_Insert 
(jobgroupmark_1 	varchar2,
jobgroupname_2 	varchar2, 
docid_3  in out integer, 
jobgroupremark_4 	varchar2,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
if docid_3=0 then 
docid_3:=null;
end if;
INSERT INTO HrmJobGroups ( jobgroupmark, jobgroupname, docid, jobgroupremark) 
VALUES ( jobgroupmark_1, jobgroupname_2, docid_3, jobgroupremark_4);
open thecursor for
select max(id) from HrmJobGroups;
end;
/

CREATE or replace PROCEDURE HrmJobGroups_Select
(flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for select * from HrmJobGroups;
end;
/

CREATE or replace PROCEDURE HrmJobGroups_SelectByID
(id_1 varchar2 , 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for
select * from HrmJobGroups where id =to_number(id_1);
end;
/

 CREATE or replace PROCEDURE HrmJobGroups_Update 
(id_1 	integer,
jobgroupmark_2 	varchar2,
jobgroupname_3 	varchar2, 
docid_4 	in out integer, 
jobgroupremark_5 	varchar2,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
if docid_4 =0 then
docid_4:=null;
end if;
UPDATE HrmJobGroups  SET  jobgroupmark=jobgroupmark_2, jobgroupname=jobgroupname_3, 
docid=docid_4, jobgroupremark=jobgroupremark_5  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmJobTitles_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
delete HrmJobTitles  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmJobTitles_Insert 
(jobtitlemark_1 	varchar2, 
jobtitlename_2 	varchar2, 
seclevel_3 	smallint, 
joblevelfrom_4 	smallint,
joblevelto_5 	smallint,
docid_6 	in out integer, 
jobtitleremark_7 	varchar2, 
jobgroupid_8 	integer,
jobactivityid_9 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
AS 
begin
if  docid_6 = 0 then 
docid_6:= null;
end if;
INSERT INTO HrmJobTitles ( jobtitlemark, jobtitlename, seclevel, joblevelfrom, joblevelto, docid, 
jobtitleremark, jobgroupid, jobactivityid)  VALUES ( jobtitlemark_1, jobtitlename_2, seclevel_3,
joblevelfrom_4, joblevelto_5, docid_6, jobtitleremark_7, jobgroupid_8, jobactivityid_9);
open thecursor for
select max(id) from  HrmJobTitles;
end;
/

CREATE or replace PROCEDURE HrmJobTitles_Select 
(flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
select * from HrmJobTitles;
end;
/

CREATE or replace PROCEDURE HrmJobTitles_Update
(id_1 	integer,
jobtitlemark_2 	varchar2, 
jobtitlename_3 	varchar2,
seclevel_4 	smallint,
joblevelfrom_5 	smallint,
joblevelto_6 	smallint,
docid_7 	in out integer,
jobtitleremark_8 	varchar2,
jobgroupid_9 	integer,
jobactivityid_10 	integer,
flag out integer, msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
begin
if  docid_7 = 0 then 
docid_7:= null;
end if;
UPDATE HrmJobTitles  SET  jobtitlemark=jobtitlemark_2, jobtitlename=jobtitlename_3, 
seclevel=seclevel_4, joblevelfrom=joblevelfrom_5, joblevelto=joblevelto_6, docid= docid_7,
jobtitleremark=jobtitleremark_8, jobgroupid=jobgroupid_9, jobactivityid=jobactivityid_10  WHERE ( id=id_1);
end;
/



 CREATE or replace PROCEDURE HrmJobType_Delete
	(id_1 	integer,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as begin delete HrmJobType 

WHERE 
	( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmJobType_Insert 
(name_1 	varchar2,
description_2 	varchar2,
flag out integer, msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
insert into HrmJobType ( name, description)  VALUES ( name_1, description_2);
end;
/

CREATE or replace PROCEDURE HrmJobType_Select
 (flag out integer , 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
 open thecursor for
 select * from HrmJobType;
 end;
/

CREATE or replace PROCEDURE HrmJobType_SelectByID
( id_1 varchar2 , 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmJobType where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmJobType_Update
(id_1 	integer,
name_2 	varchar2,
description_3 	varchar2, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
update HrmJobType  SET  name=name_2, description=description_3  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmLanguageAbility_Delete
	(id_1 	integer,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)

as 
begin
delete  HrmLanguageAbility
WHERE 
	( id=id_1);
	end;
/


 CREATE or replace PROCEDURE HrmLanguageAbility_Insert
	(resourceid_1 	integer,
	 language_2 	varchar2,
	 thelevel_3 	char,
	 memo_4 	    varchar2,
	 createid_5 	integer,
	 createdate_6 	char,
	 createtime_7 	char,
	 lastmoderid_8 	integer,
	 lastmoddate_9 	char,
	 lastmodtime_10 	char,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

as 
begin 
insert into HrmLanguageAbility 
	 ( resourceid,
	 language,
	 level_n,
	 memo,
	 createid,
	 createdate,
	 createtime,
	 lastmoderid,
	 lastmoddate,
	 lastmodtime) 
	 VALUES 
	( resourceid_1,
	 language_2,
	 thelevel_3,
	 memo_4,
	 createid_5,
	 createdate_6,
	 createtime_7,
	 lastmoderid_8,
	 lastmoddate_9,
	 lastmodtime_10);
end;
/

 CREATE or REPLACE PROCEDURE HrmLanguageAbility_SByResourID 
	  (resourceid_1 varchar2 , 
	  flag out integer , 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmLanguageAbility
      where resourceid = to_number(resourceid_1) ;
 
 end;
/

CREATE or replace PROCEDURE HrmLanguageAbility_SelectByID
(id_1 varchar2 , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select * from HrmLanguageAbility where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmLanguageAbility_Update
	(id_1 	integer,
	 resourceid_2 	integer,
	 language_3 	varchar2,
	 thelevel_4 	char,
	 memo_5 	varchar2,
	 lastmoderid_9 	integer,
	 lastmoddate_10 	char,
	 lastmodtime_11 	char,
	 flag out integer,
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

as begin 
update HrmLanguageAbility
SET  resourceid=resourceid_2,
	 language=language_3,
	 level_n=thelevel_4,
	 memo=memo_5,
	 lastmoderid=lastmoderid_9,
	 lastmoddate=lastmoddate_10,
	 lastmodtime=lastmodtime_11 

WHERE 
	( id=id_1);
end;
/

CREATE or REPLACE PROCEDURE HrmList_SelectAll 
( flag  out integer,
msg  out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
open thecursor for 
 select id,name,validate_n from HrmListValidate;
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmList_Update 
(id_1 integer, 
flag  out integer,  
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor  ) as 
begin 


 update HrmListValidate  set validate_n=1 where id= id_1;
 
 end;
/

CREATE or replace PROCEDURE HrmLocations_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
as
begin
delete HrmLocations  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmLocations_Insert 
(locationname_1 	varchar2,
locationdesc_2 	varchar2, 
address1_3 	varchar2, 
address2_4 	varchar2, 
locationcity_5 	varchar2, 
postcode_6 	varchar2, 
countryid_7 	integer, 
telephone_8 	varchar2, 
fax_9 	varchar2, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as 
begin 
insert into HrmLocations ( locationname, locationdesc, address1, address2, locationcity, postcode,
countryid, telephone, fax)  VALUES ( locationname_1, locationdesc_2, address1_3, address2_4,
locationcity_5, postcode_6, countryid_7, telephone_8, fax_9);
open thecursor for
select max(id) from HrmLocations;
end;
/

CREATE or replace PROCEDURE HrmLocations_Select
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for 
select * from HrmLocations;
end;
/

CREATE or replace PROCEDURE HrmLocations_SelectByID
(id_1 varchar2 , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for
select * from HrmLocations where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmLocations_Update 
(id_1 	integer, 
locationname_2 	varchar2, 
locationdesc_3 	varchar2, 
address1_4 	varchar2, 
address2_5 	varchar2, 
locationcity_6 	varchar2,
postcode_7 	varchar2, 
countryid_8 	integer, 
telephone_9 	varchar2, 
fax_10 	varchar2,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin
update HrmLocations  SET  locationname=locationname_2, locationdesc=locationdesc_3, 
address1=address1_4, address2=address2_5, locationcity=locationcity_6, postcode=postcode_7, 
countryid=countryid_8, telephone=telephone_9, fax=fax_10  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmOtherInfoType_Delete 
(id_1 	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
delete from hrmotherinfotype where id=id_1;
end;
/

CREATE or replace PROCEDURE HrmOtherInfoType_Insert 
( typename_1	varchar2, 
typeremark_1	varchar2,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
insert into hrmotherinfotype (typename,typeremark) values(typename_1,typeremark_1);
open thecursor for
select max(id) from hrmotherinfotype;
end;
/

CREATE or replace PROCEDURE HrmOtherInfoType_SelectAll 
(flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
open thecursor for 
select * from HrmOtherInfoType order by id;
end;
/

CREATE or replace PROCEDURE HrmOtherInfoType_Update 
(id_1 	integer,
typename_1	varchar2, 
typeremark_1	varchar2, 
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as
begin 
update hrmotherinfotype set typename=typename_1,typeremark=typeremark_1 where id=id_1;
end;
/

CREATE or replace PROCEDURE HrmPlanColor_SelectByID
	(resourceid_1	integer,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
	select * from hrmplancolor where resourceid=resourceid_1;
end;
/

CREATE or replace PROCEDURE HrmPlanColor_Update
	(resourceid_1	integer,
	 basictype_1		integer,
	 colorid1_1		varchar2,
	 colorid2_1		varchar2,
	 flag out integer,
	 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
AS
	count_1	integer;
    begin
	select count(*) into count_1 from HrmPlancolor 
	where resourceid=resourceid_1 and basictype=basictype_1;
	if	count_1=0 then
		insert into hrmplancolor (resourceid,basictype,colorid1,colorid2)
		values(resourceid_1,basictype_1,colorid1_1,colorid2_1);
	else
		update hrmplancolor set colorid1=colorid1_1 ,colorid2=colorid2_1
		where resourceid=resourceid_1 and basictype=basictype_1;
	end if;
end;
/

CREATE or replace PROCEDURE HrmProvince_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
delete HrmProvince  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmProvince_Insert 
(provincename_1 	varchar2, 
provincedesc_2 	varchar2,
countryid_3 integer,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
maxid	integer;
begin
 
 select max(id) into maxid from HrmProvince ;
 maxid :=maxid+1 ;
insert into HrmProvince (id, provincename, provincedesc,countryid)  
VALUES ( maxid,provincename_1, provincedesc_2, countryid_3);
open thecursor for
select max(id) from HrmProvince;
end;
/

CREATE or replace PROCEDURE HrmProvince_Select 
(countryid_1 integer, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
if countryid_1 = 0 then
open thecursor for
select * from HrmProvince; 
else
open thecursor for
select * from HrmProvince where countryid = countryid_1; 
end if;
end;
/

CREATE or replace PROCEDURE HrmProvince_Update 
(id_1 	integer,
provincename_2 	varchar2,
provincedesc_3 	varchar2, 
countryid_4 integer, 
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin 
update HrmProvince  SET  provincename=provincename_2, provincedesc=provincedesc_3,
countryid = countryid_4  WHERE ( id=id_1);
end;
/

CREATE or REPLACE PROCEDURE HrmPubHoliday_Copy 
(fromyear_1   varchar2, 
toyear_1       char,
countryid_1 varchar2,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 AS 
 tempdate_1 char(10);
 tempname_1 varchar(255); 
 begin
 delete from hrmpubholiday where substr(holidaydate,1,4) = toyear_1 and countryid = countryid_1 ;
 FOR all_cursor in(select substr(holidaydate,5,6) tempdate , holidayname from hrmpubholiday where substr(holidaydate,1,4)= fromyear_1 and countryid = countryid_1)
 loop  
 tempdate_1 :=all_cursor.tempdate ;
 tempname_1 :=all_cursor.holidayname ;
 insert into hrmpubholiday(countryid,holidaydate,holidayname) values (to_number(countryid_1) ,concat(toyear_1,tempdate_1) , tempname_1);
 end loop; 
end;
/

CREATE or replace PROCEDURE HrmPubHoliday_Delete 
(id_1 integer,
countryid_1 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
as begin delete from hrmpubholiday where id=id_1;
END;
/

CREATE or replace PROCEDURE HrmPubHoliday_Insert 
(countryid_1 	integer, 
holidaydate_2 	char,
holidayname_3 	varchar2,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
xx integer;
begin

select count(id) into xx from hrmpubholiday where countryid=countryid_1 and holidaydate=holidaydate_2; 
if xx<>0 then
INSERT INTO HrmPubHoliday ( countryid, holidaydate, holidayname) 
VALUES (countryid_1, holidaydate_2, holidayname_3);
end if;
open thecursor for
select max(id) from hrmpubholiday;
end;
/

CREATE or replace PROCEDURE HrmPubHoliday_SelectByID 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for
select * from HrmPubHoliday where id=id_1;
end;
/

CREATE or replace PROCEDURE HrmPubHoliday_SelectByYear 
(year_1 	char,
countryid_1    integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select * from HrmPubHoliday where substr(holidaydate,1,4)=year_1 and countryid=countryid_1
order by holidaydate;
end;
/

CREATE or replace PROCEDURE HrmPubHoliday_Update 
(id_1 integer,
countryid_1 	integer,
holidaydate_1 	char,
holidayname_1 	varchar2, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
update HrmPubHoliday set countryid=countryid_1, holidaydate=holidaydate_1, holidayname=holidayname_1 
where id=id_1;
end;
/

 CREATE or replace PROCEDURE HrmResourceCompetency_Insert 
(resourceid_1 	integer, 
competencyid_2 	integer, 
currentgrade_3 	real,
currentdate_4 	char,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
recordercount_1 integer;
begin
Select count(id) into recordercount_1 from HrmResourceCompetency 
where resourceid = resourceid_1 and competencyid = competencyid_2;
if recordercount_1 = 0 then 
INSERT INTO HrmResourceCompetency ( resourceid, competencyid, currentgrade, currentdate, countgrade,
counttimes)  VALUES ( resourceid_1, competencyid_2, currentgrade_3, currentdate_4, 
currentgrade_3, 1);
else 
Update HrmResourceCompetency set lastgrade = currentgrade ,
lastdate = currentdate, currentgrade = currentgrade_3, currentdate = currentdate_4,
countgrade = countgrade + currentgrade_3, counttimes = counttimes+1 
where resourceid = resourceid_1 and competencyid = competencyid_2;
end if;
end;
/

 CREATE or REPLACE PROCEDURE HrmResourceCompetency_SByID 
 ( id_1 	integer,  
 flag           out integer,
 msg		out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 as 
begin 
open thecursor for 
 select * from HrmResourceCompetency where resourceid =  id_1;
 
 end;
/

CREATE or replace PROCEDURE HrmResourceCompetency_Update 
(resourceid_1 	integer, 
competencyid_2 	integer,
currentgrade_3 	real,
currentdate_4 	char,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
recordercount_1 integer;
begin
Select count(id) into recordercount_1 from HrmResourceCompetency where resourceid = resourceid_1 
and competencyid = competencyid_2; 
if recordercount_1 = 0 then
INSERT INTO HrmResourceCompetency ( resourceid, competencyid, currentgrade, currentdate, countgrade,
counttimes)  VALUES ( resourceid_1, competencyid_2, currentgrade_3, currentdate_4, 
currentgrade_3, 1);
else
Update HrmResourceCompetency set countgrade = countgrade - currentgrade + currentgrade_3,
currentgrade = currentgrade_3 where resourceid = resourceid_1 and competencyid = competencyid_2; 
end if;
end;
/

CREATE or replace PROCEDURE HrmResourceComponent_Delete 
(id_1 	integer,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as
begin
delete HrmResourceComponent  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE HrmResourceComponent_Insert 
(resourceid_1 	integer, 
componentid_2 	integer,
componentmark_3 	varchar2, 
selbank_6 	char, 
salarysum_8 	decimal, 
canedit 	char, 
currencyid_9 	integer, 
startdate_10 	char,
enddate_11 	char,
remark_13 	varchar2,
createid_14 	integer,
createdate_15 	char,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS 
ledgerid_4 integer;
bankid_7 integer;
componentperiod_5 	char(1); 
bankid_count1 integer;
bankid_count2 integer;
recordcount integer;
begin
if selbank_6 = '1' then

select count(bankid1) into bankid_count1 from HrmResource where id = resourceid_1;
	if bankid_count1>0 then
	select bankid1 into bankid_7 from HrmResource where id = resourceid_1;
	end if;
else 
    select count(bankid2) into bankid_count2 from HrmResource where id = resourceid_1;
	if bankid_count2>0 then
    select bankid2 into bankid_7 from HrmResource where id = resourceid_1;
	end if;
end if;
select count(*) into recordcount from HrmSalaryComponent where id = componentid_2; 
if recordcount> 0 then

select ledgerid,componentperiod into ledgerid_4,componentperiod_5 from HrmSalaryComponent 
where id = componentid_2; 
end if;
INSERT INTO HrmResourceComponent ( resourceid, componentid, componentmark, ledgerid, componentperiod,
selbank, bankid, salarysum, canedit, currencyid, startdate, enddate, hasused, remark, createid, 
createdate)  VALUES ( resourceid_1, componentid_2, componentmark_3, ledgerid_4, 
componentperiod_5, selbank_6, bankid_7, salarysum_8, canedit, currencyid_9, startdate_10, 
enddate_11, '0', remark_13, createid_14, createdate_15);
end;
/

 CREATE or REPLACE PROCEDURE HrmResourceComponent_SByID 
 ( id_1 	integer, 
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmResourceComponent where id =  id_1; 
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmResourceComponent_SByResour 
 ( id_1 	integer,  
 flag out integer,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
 select * from HrmResourceComponent where resourceid =  id_1 ;
 
 end;
/

CREATE or replace PROCEDURE HrmResourceComponent_Update 
(id_1 	integer,
resourceid_1 	integer, 
componentid_2 	integer,
componentmark_3 	varchar2, 
selbank_6 	char, 
salarysum_8 	decimal, 
canedit_1       char, 
currencyid_9 	integer, 
startdate_10 	char, 
enddate_11 	char,
remark_13 	varchar2,
lastmoderid_14 	integer, 
lastmoddate_15 	char, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
ledgerid_4 integer;
bankid_7 integer;
componentperiod_5 char(1);
bankid_count1 integer;
bankid_count2 integer;
recordcount integer;
begin
if selbank_6 = '1' then

   select count(bankid1) into bankid_count1 from HrmResource where id = resourceid_1;
	if bankid_count1>0 then

    select bankid1 into bankid_7 from HrmResource where id = resourceid_1;
    end if;

else 

    select count(bankid2) into bankid_count2 from HrmResource where id = resourceid_1;
	if bankid_count2>0 then

    select bankid2 into bankid_7 from HrmResource where id = resourceid_1;
	end if;
end if;
select count(*) into recordcount from HrmSalaryComponent where id = componentid_2; 
if recordcount > 0 then


select ledgerid,componentperiod into ledgerid_4, componentperiod_5  from HrmSalaryComponent
where id = componentid_2;
end if;

UPDATE HrmResourceComponent  SET  componentid=componentid_2, componentmark=componentmark_3,
ledgerid=ledgerid_4, componentperiod=componentperiod_5, selbank=selbank_6, bankid=bankid_7,
salarysum=salarysum_8, canedit= canedit_1 , currencyid=currencyid_9, startdate=startdate_10, 
enddate=enddate_11, remark=remark_13, lastmoderid=lastmoderid_14, lastmoddate=lastmoddate_15 
WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmResourceOtherInfo_Delete 
(id_1 	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
delete HrmResourceOtherInfo  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmResourceOtherInfo_Insert 
(resourceid_1 	integer,
infoname_2 	varchar2,
startdate_3 	char, 
enddate_4 	char,
docid_5 	IN out integer, 
inforemark_6 	varchar2,
infotype_7 	integer, 
seclevel_8 	smallint,
createid_9 	integer,
createdate_10 	char, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS 
begin
if docid_5 =0 then
 docid_5:= null;
 end if;
INSERT INTO HrmResourceOtherInfo ( resourceid, infoname, startdate, enddate, docid, inforemark, 
infotype, seclevel, createid, createdate)  VALUES ( resourceid_1, infoname_2, startdate_3, 
enddate_4, docid_5, inforemark_6, infotype_7, seclevel_8, createid_9, createdate_10);
end;
/

 CREATE or REPLACE PROCEDURE HrmResourceOtherInfo_SByID 
 ( id_1  integer, 
 flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
 select * from HrmResourceOtherInfo  where id =  id_1; 
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmResourceOtherInfo_SByType 
 ( userid_1  integer,  
 typeid_1   integer, 
 seclevel_1  smallint,
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
 select id , infoname ,inforemark from HrmResourceOtherInfo where resourceid =  userid_1 and infotype =  typeid_1 and seclevel <=  seclevel_1; 
 
 end;
/

CREATE or replace PROCEDURE HrmResourceOtherInfo_Select 
(userid_1  integer,
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 

select infotype ,count(id) as infocount from HrmResourceOtherInfo  
where resourceid = userid_1 group by infotype;
end;
/

 CREATE or REPLACE PROCEDURE HrmResourceOtherInfo_SByType2 
  ( userid_1  integer, 
  typeid_1   integer,
  flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
 select inforemark  from HrmResourceOtherInfo where resourceid =  userid_1 and infotype =  typeid_1 ;
 end;
/

CREATE or replace PROCEDURE HrmResourceOtherInfo_Update 
(id_1 	integer, 
infoname_3 	varchar2,
startdate_4 	char, 
enddate_5 	char, 
docid_6 	IN out integer, 
inforemark_7 	varchar2,
infotype_8 	integer,
seclevel_9 	smallint, 
lastmoderid_10 	integer,
lastmoddate_11 	char,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS  
begin
if docid_6 =0 then
docid_6:= null; 
end if;
UPDATE HrmResourceOtherInfo  SET infoname=infoname_3, startdate=startdate_4, enddate=enddate_5, 
docid=docid_6, inforemark=inforemark_7, infotype=infotype_8, seclevel=seclevel_9, 
lastmoderid=lastmoderid_10, lastmoddate=lastmoddate_11  WHERE ( id=id_1);
end;
/


 CREATE or REPLACE PROCEDURE HrmResourceSkill_Delete 
 ( id_1 	integer, 
 flag           out integer,  
 msg           out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 as 
begin 

 DELETE HrmResourceSkill  WHERE ( id	 =  id_1); 

 end;
/

CREATE or replace PROCEDURE HrmResourceSkill_Insert 
(resourceid_1 	integer, 
skilldesc_2 	varchar2,
flag out integer,  
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin insert into HrmResourceSkill ( resourceid, skilldesc)  VALUES ( resourceid_1, skilldesc_2);
end;
/

CREATE or replace PROCEDURE HrmResourceSkill_Select 
(resourceid_1 	integer, 
flag out integer,  
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmResourceSkill where resourceid = resourceid_1;
end;
/

CREATE or replace PROCEDURE HrmResourceSkill_SelectByID
 (id_1 	integer,
flag out integer,  
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmResourceSkill where id = id_1;
end;
/


CREATE or replace PROCEDURE HrmResourceSkill_Update 
(id_1 	integer,
 skilldesc_2 	varchar2,
 flag out integer,  
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as begin
update HrmResourceSkill  SET  skilldesc=skilldesc_2  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmResource_Delete 
(id_1 	integer, 
 flag out integer,  
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
delete HrmResource  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE HrmResource_Insert
(resourceid_1 integer,
loginid_1 	varchar2, 
password_2 	varchar2, 
firstname_3 	varchar2,
lastname_4 	varchar2, 
aliasname_5 	varchar2, 
titleid_6 in out	integer,
sex_8 	char, 
birthday_9 	char,
nationality_10 IN OUT	integer, 
defaultlanguage_11 IN OUT	integer, 
systemlanguage_12 IN OUT	integer, 
maritalstatus_13 	char, 
marrydate_14 	char, 
telephone_15 	varchar2, 
mobile_16 	varchar2, 
mobilecall_17 	varchar2, 
email_18 	varchar2, 
countryid_19 IN OUT	integer, 
locationid_20 IN OUT	integer, 
workroom_21 	varchar2, 
homeaddress_22 	varchar2, 
homepostcode_23 	varchar2,
 homephone_24 	varchar2, 
resourcetype_25 	char, 
startdate_26 	char,
 enddate_27 	char, 
contractdate_28 	char,
 jobtitle_29 IN OUT	integer, 
jobgroup_30 IN OUT	integer,
 jobactivity_31 IN OUT	integer,
 jobactivitydesc_32 	varchar2, 
joblevel_33 	smallint, 
seclevel_34 	smallint,
 departmentid_35 IN OUT	integer,
 subcompanyid1_36 IN OUT	integer, 
subcompanyid2_37 IN OUT	integer,
 subcompanyid3_38 IN OUT	integer, 
subcompanyid4_39 IN OUT	integer, 
costcenterid_40 IN OUT	integer, 
managerid_41 IN OUT	integer, 
assistantid_42 	IN OUT integer, 
purchaselimit_43 	decimal,
currencyid_44 IN OUT	integer, 
bankid1_45 IN OUT	integer, 
accountid1_46 	varchar2, 
bankid2_47 IN OUT	integer, 
accountid2_48 	varchar2, 
securityno_49 	varchar2,
 creditcard_50 	varchar2, 
expirydate_51 	char, 
resourceimageid_52 	integer, 
createrid_53 	integer, 
createdate_54 	char, 
lastmodid_55 	integer, 
lastmoddate_56 	char, 
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
 textfield1_1	varchar2, 
textfield2_1 	varchar2, 
textfield3_1 	varchar2, 
textfield4_1 	varchar2, 
textfield5_1 	varchar2, 
tinyintfield1_1 smallint, 
tinyintfield2_1 smallint, 
tinyintfield3_1 smallint,
tinyintfield4_1 smallint, 
tinyintfield5_1 smallint, 
certificateCategory_1	varchar2,			
certificatenum_1		varchar2,			
nativeplace_1		varchar2,			
educationlevel_1		char,			
bememberdate_1		char,			
bepartydate_1		char,		
bedemocracydate_1		char,			
regresidentplace_1 varchar2,				
healthinfo_1		char,			
residentplace_1		varchar2,			
policy_1			varchar2,			
degree_1			varchar2,			
height_1			varchar2,		
homepage_1		varchar2,			
train_1			varchar2,				
worktype_1		varchar2,			
usekind_1	in out		integer,				
workcode_1		varchar2,			
contractbegintime_1	char,			
jobright_1		varchar2,	
jobcall_1	in out		integer,		
jobtype_1	in out		integer,	
accumfundaccount_1	varchar2,	
birthplace_1		varchar2,
folk_1			varchar2,
residentphone_1		varchar2,
residentpostcode_1	varchar2,
extphone_1      	varchar2,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
AS
count_1  integer;
begin 
if titleid_6=0 then
titleid_6:= null;
end if;
if nationality_10=0 then
nationality_10:= null; 
end if;
if defaultlanguage_11=0 then
defaultlanguage_11:= null;
end if;
if systemlanguage_12 = 0 then
systemlanguage_12:= null;
end if;
if countryid_19 = 0 then
countryid_19:= null;
end if;
if locationid_20 = 0 then
locationid_20:= null;
end if;
if jobtitle_29 = 0 then
jobtitle_29:= null;
end if;
if jobgroup_30 = 0 then
jobgroup_30:= null;
end if;
if jobactivity_31 = 0 then 
jobactivity_31:= null;
end if;
if departmentid_35 = 0 then 
departmentid_35:= null;
end if;
if subcompanyid1_36 = 0 then
subcompanyid1_36:= null;
end if;
if subcompanyid2_37 = 0 then
subcompanyid2_37:= null;
end if;
if subcompanyid3_38 = 0 then 
subcompanyid3_38:= null;
end if;
if subcompanyid4_39 = 0 then
subcompanyid4_39:= null;
end if;
if costcenterid_40 = 0 then 
costcenterid_40:= null;
end if;
if managerid_41 = 0 then 
managerid_41:= null;
end if;
if assistantid_42 = 0 then
assistantid_42:= null;
end if;
if currencyid_44 = 0 then
currencyid_44:= null;
end if;
if bankid1_45= 0 THEN 
bankid1_45:= null;
end if;
if bankid2_47 = 0 THEN 
bankid2_47:= null;
end if; 
if usekind_1 = 0 then
 usekind_1:= null ;
end if;
if jobcall_1 = 0 then
 jobcall_1:= null ;
end if;
if jobtype_1 = 0 then
jobtype_1:=null;
end if;


select count(*) into count_1 from HrmResource where loginid = loginid_1;
if count_1<>0 then 
open thecursor for
select -1 from dual;
return;
end if;

INSERT INTO HrmResource (id,loginid, password, firstname, lastname, aliasname, titleid, sex, birthday, nationality, 
defaultlanguage, systemlanguage, maritalstatus, marrydate, telephone, mobile, mobilecall, email,
countryid, locationid,workroom, homeaddress, homepostcode, homephone, resourcetype, startdate,
enddate, contractdate, jobtitle, jobgroup, jobactivity, jobactivitydesc, joblevel, seclevel, 
departmentid, subcompanyid1, subcompanyid2, subcompanyid3, subcompanyid4,costcenterid, managerid, 
assistantid, purchaselimit, currencyid, bankid1, accountid1, bankid2, accountid2, securityno,
creditcard, expirydate, resourceimageid, createrid, createdate, lastmodid, lastmoddate, datefield1, 
datefield2, datefield3,datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4,
numberfield5, textfield1, textfield2, textfield3,textfield4, textfield5, tinyintfield1,
tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5,certificateCategory,certificatenum,				
nativeplace,educationlevel,bememberdate,bepartydate,			
bedemocracydate,				
regresidentplace,				
healthinfo,		
residentplace,						
policy,						
degree,						
height,				
homepage,				
train,						
worktype,			
usekind,							
workcode,					
contractbegintime,				
jobright,		
jobcall,		
jobtype,	
accumfundaccount,
birthplace,
folk,
residentphone,
residentpostcode,
extphone)
VALUES ( resourceid_1,loginid_1, password_2, firstname_3, lastname_4, aliasname_5, titleid_6,
 sex_8,
 birthday_9, nationality_10, defaultlanguage_11, systemlanguage_12, maritalstatus_13, marrydate_14, 
telephone_15, mobile_16, mobilecall_17, email_18, countryid_19, locationid_20, workroom_21, homeaddress_22,
 homepostcode_23, homephone_24, resourcetype_25, startdate_26, enddate_27, contractdate_28, jobtitle_29, jobgroup_30, 
jobactivity_31, jobactivitydesc_32, joblevel_33, seclevel_34, departmentid_35, subcompanyid1_36, subcompanyid2_37, 
subcompanyid3_38, subcompanyid4_39, costcenterid_40, managerid_41, assistantid_42, purchaselimit_43, currencyid_44, 
bankid1_45, accountid1_46, bankid2_47, accountid2_48, securityno_49, creditcard_50, expirydate_51, resourceimageid_52,
 createrid_53, createdate_54, lastmodid_55, lastmoddate_56, 
datefield1_1, datefield2_1, datefield3_1, datefield4_1, 
datefield5_1, numberfield1_1, numberfield2_1, numberfield3_1, numberfield4_1, numberfield5_1, 
textfield1_1, textfield2_1, textfield3_1, 
textfield4_1, textfield5_1, tinyintfield1_1, tinyintfield2_1, tinyintfield3_1, 
tinyintfield4_1, tinyintfield5_1,
certificateCategory_1,		
certificatenum_1,				
nativeplace_1,					
educationlevel_1,					
bememberdate_1,					
bepartydate_1,			
bedemocracydate_1,				
regresidentplace_1,				
healthinfo_1,		
residentplace_1,						
policy_1,						
degree_1,						
height_1,				
homepage_1,				
train_1,						
worktype_1,			
usekind_1,							
workcode_1,					
contractbegintime_1,				
jobright_1,		
jobcall_1,		
jobtype_1,	
accumfundaccount_1,
birthplace_1,
folk_1,
residentphone_1,
residentpostcode_1,
extphone_1);
open thecursor for 
SELECT max(id) FROM HrmResource;
end;
/ 

 CREATE or REPLACE PROCEDURE HrmResource_SByLoginIDPass 
 (loginid_1   varchar2,  
 password_1  varchar2, 
 flag	out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
count_1 integer;
begin 
 select  count(id) into count_1 from HrmResource where loginid=  loginid_1 ; 
 if  count_1 <> 0 then 
 select  count(id) into count_1 from HrmResource where loginid=  loginid_1 and password =  password_1; 
 if  count_1 <> 0 then
 open thecursor for 
 select * from HrmResource where loginid=  loginid_1; 
 else 
 open thecursor for 
 select 0 from dual; 
 end if;
 end if;
 end;
/

 CREATE or REPLACE PROCEDURE HrmResource_SCountBySubordinat 
 ( id_1 	integer,  
 flag        out integer, 
 msg         out  varchar2, 
thecursor IN OUT cursor_define.weavercursor  )
 as 
begin 
open thecursor for 
 select count(*) from HrmResource where managerid =  id_1 ;

 end;
/

CREATE or replace PROCEDURE HrmResource_SelectAll 
(flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )   
as 
begin 
open thecursor for 
select id,loginid,firstname,lastname,titleid,sex,resourcetype,email,locationid,workroom, departmentid,
costcenterid,jobtitle,managerid,assistantid ,seclevel from HrmResource;
end;
/


CREATE or replace PROCEDURE HrmResource_SelectByID
 (id_1 	integer,
 flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
open thecursor for 
select * from HrmResource where id = id_1;
end;
/

CREATE or replace PROCEDURE HrmResource_SelectByLoginID 
(id_1 	varchar2, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
open thecursor for 
select * from HrmResource where loginid = id_1;
end;
/

CREATE or replace PROCEDURE HrmResource_SelectByManagerID
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
as
 begin
 open thecursor for 
select * from HrmResource where managerid = id_1;
end;
/ 

 CREATE or REPLACE PROCEDURE HrmResource_SSubordinatesID 
 ( id_1 	integer, 
 flag       out integer,
 msg     varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
 as 
begin 
open thecursor for 
 select id from HrmResource where managerid =  id_1 ;

 end;
/

CREATE or replace PROCEDURE HrmResource_SelectTheSub
	(resourceid_1 	int ,
	 flag	out integer, 
	 msg out varchar2,thecursor IN OUT cursor_define.weavercursor)

AS
begin 
open thecursor for
select id from hrmresource where managerid = resourceid_1;
end;
/

 CREATE or replace PROCEDURE HrmResource_Update 
(id_1 	integer, 
loginid_2 	varchar2, 
password_3 	varchar2, 
firstname_4 	varchar2, 
lastname_5 	varchar2,
aliasname_6 	varchar2,
titleid_7 IN OUT	integer, 
sex_9 	char, 
birthday_10 	char, 
nationality_11 IN OUT	integer,
defaultlanguage_12 IN OUT integer, 
systemlanguage_13 IN OUT	integer,
maritalstatus_14 	char,
marrydate_15 	char,
telephone_16 	varchar2, 
mobile_17 	varchar2,
mobilecall_18 	varchar2, 
email_19 	varchar2, 
countryid_20 IN OUT	integer, 
locationid_21 IN OUT	integer,
workroom_22 	varchar2, 
homeaddress_23 	varchar2, 
homepostcode_24 	varchar2,
 homephone_25 	varchar2,
 resourcetype_26 	char,
 startdate_27 	char, 
enddate_28 	char,
 contractdate_29 	char,
 jobtitle_30 IN OUT	integer,
 jobgroup_31 	IN OUT integer, 
jobactivity_32 IN OUT	integer,
 jobactivitydesc_33 	varchar2,
 joblevel_34 	smallint, 
seclevel_35 	smallint, 
departmentid_36 IN OUT	integer,
 subcompanyid1_37 IN OUT	integer, 
subcompanyid2_38 IN OUT	integer, 
subcompanyid3_39 IN OUT	integer, 
subcompanyid4_40 IN OUT	integer, 
costcenterid_41 IN OUT	integer,
 managerid_42 IN OUT	integer, 
assistantid_43 IN OUT	integer, 
purchaselimit_44 	decimal, 
currencyid_45 IN OUT	integer, 
bankid1_46 IN OUT	integer, 
accountid1_47 	varchar2,
 bankid2_48 IN OUT	integer, 
accountid2_49 	varchar2, 
securityno_50 	varchar2, 
creditcard_51 	varchar2, 
expirydate_52 	char,
 resourceimageid_53 	integer, 
lastmodid_54 	integer, 
lastmoddate_55 	char,
 datefield1_1 	varchar2, 
datefield2_1	varchar2,
 datefield3_1 	varchar2, 
datefield4_1	varchar2, 
datefield5_1 	varchar2, 
numberfield1_1 	float, 
numberfield2_1	float,
numberfield3_1	float, 
numberfield4_1 	float, 
numberfield5_1 	float, 
textfield1_1 	varchar2, 
textfield2_1 	varchar2, 
textfield3_1 	varchar2, 
textfield4_1 	varchar2, 
textfield5_1	varchar2, 
tinyintfield1_1 	smallint, 
tinyintfield2_1 	smallint, 
tinyintfield3_1 	smallint, 
tinyintfield4_1 	smallint, 
tinyintfield5_1		smallint, 
certificateCategory_1	varchar2,			
certificatenum_1	varchar2,			
nativeplace_1		varchar2,			
educationlevel_1		char,			
bememberdate_1		char,			
bepartydate_1		char,		
bedemocracydate_1		char,			
regresidentplace_1	varchar2,			
healthinfo_1		char,			
residentplace_1		varchar2,			
policy_1			varchar2,			
degree_1			varchar2,			
height_1			varchar2,		
homepage_1		varchar2,			
train_1			varchar2,				
worktype_1		varchar2,			
usekind_1 in out			integer,				
workcode_1		varchar2,			
contractbegintime_1	char,			
jobright_1		varchar2,			
jobcall_1	in out		integer,				
jobtype_1	in out		integer,			
accumfundaccount_1	varchar2,	
birthplace_1		varchar2,
folk_1			varchar2,
residentphone_1		varchar2,
residentpostcode_1	varchar2,
extphone_1		varchar2,
flag	out integer, 
msg out varchar2,thecursor IN OUT cursor_define.weavercursor)

AS 
count_1 integer;
begin
if titleid_7=0 then 
titleid_7:= null;
end if;
if nationality_11=0 then
nationality_11:= null;
end if;
if defaultlanguage_12=0 then
defaultlanguage_12:= null;
end if;
if systemlanguage_13= 0 then 
systemlanguage_13:= null;
end if;
if countryid_20= 0 then
countryid_20:= null;
end if;
if locationid_21= 0 then 
locationid_21:= null ;
end if;
if jobtitle_30 = 0 then 
jobtitle_30:= null;
end if;
if jobgroup_31 = 0 then 
jobgroup_31:= null ;
end if;
if jobactivity_32 = 0 then 
jobactivity_32:= null;
end if;
if departmentid_36= 0 then 
departmentid_36:= null;
end if; 
if subcompanyid1_37 = 0 then 
subcompanyid1_37:= null;
end if;
if subcompanyid2_38 = 0 then 
 subcompanyid2_38:= null;
end if;
if subcompanyid3_39= 0 then 
subcompanyid3_39:= null;
end if;
if subcompanyid4_40= 0 then 
subcompanyid4_40:= null;
end if;
if costcenterid_41= 0 then 
 costcenterid_41:= null;
end if;
if managerid_42 = 0 then 
managerid_42 := null;
end if;
if assistantid_43= 0 then 
 assistantid_43:= null;
end if;
if currencyid_45 = 0 then 
 currencyid_45:= null;
end if;
if bankid1_46 = 0 then 
bankid1_46:= null;
end if;
if bankid2_48 = 0 then 
 bankid2_48:= null;
end if;
if usekind_1 = 0 then 
 usekind_1:= null; 
end if;
if jobcall_1 = 0 then 
 jobcall_1:= null;
end if; 
if jobtype_1 = 0 then 
 jobtype_1:= null;
end if;




select count(*) into count_1 from HrmResource where loginid = loginid_2 and id<>id_1;
if count_1<>0 then
open thecursor for
select -1 from dual;
return;
end if;

if password_3 != '0' then
 UPDATE HrmResource  SET  loginid=loginid_2, password=password_3, firstname=firstname_4,
 lastname=lastname_5, aliasname=aliasname_6, titleid=titleid_7, sex=sex_9,
 birthday=birthday_10, nationality=nationality_11, defaultlanguage=defaultlanguage_12,
 systemlanguage=systemlanguage_13, maritalstatus=maritalstatus_14, marrydate=marrydate_15, 
telephone=telephone_16, mobile=mobile_17, mobilecall=mobilecall_18, email=email_19, 
countryid=countryid_20, locationid=locationid_21, workroom=workroom_22, 
homeaddress=homeaddress_23, homepostcode=homepostcode_24, homephone=homephone_25,
 resourcetype=resourcetype_26, startdate=startdate_27, enddate=enddate_28, 
contractdate=contractdate_29, jobtitle=jobtitle_30, jobgroup=jobgroup_31, 
jobactivity=jobactivity_32, jobactivitydesc=jobactivitydesc_33, joblevel=joblevel_34, 
seclevel=seclevel_35, departmentid=departmentid_36, subcompanyid1=subcompanyid1_37,
 subcompanyid2=subcompanyid2_38, subcompanyid3=subcompanyid3_39, subcompanyid4=subcompanyid4_40,
 costcenterid=costcenterid_41, managerid=managerid_42, assistantid=assistantid_43,
 purchaselimit=purchaselimit_44, currencyid=currencyid_45, bankid1=bankid1_46,
 accountid1=accountid1_47, bankid2=bankid2_48, accountid2=accountid2_49, securityno=securityno_50,
 creditcard=creditcard_51, expirydate=expirydate_52, resourceimageid=resourceimageid_53, 
lastmodid=lastmodid_54, lastmoddate=lastmoddate_55 , datefield1=datefield1_1, 
datefield2=datefield2_1,
 datefield3=datefield3_1, datefield4=datefield4_1, datefield5=datefield5_1,
 numberfield1=numberfield1_1, numberfield2=numberfield2_1, numberfield3=numberfield3_1, 
numberfield4=numberfield4_1, numberfield5=numberfield5_1, textfield1=textfield1_1,
 textfield2=textfield2_1, textfield3=textfield3_1, textfield4=textfield4_1, textfield5=textfield5_1, 
tinyintfield1=tinyintfield1_1, tinyintfield2=tinyintfield2_1, tinyintfield3=tinyintfield3_1,
 tinyintfield4=tinyintfield4_1, 
tinyintfield5=tinyintfield5_1,
certificateCategory = certificateCategory_1,			
certificatenum	= certificatenum_1,			
nativeplace = nativeplace_1,		
educationlevel = educationlevel_1,			
bememberdate = bememberdate_1,			
bepartydate = bepartydate_1,
bedemocracydate = bedemocracydate_1,			
regresidentplace = regresidentplace_1,				
healthinfo = healthinfo_1,			
residentplace = residentplace_1,			
policy = policy_1,		
degree = degree_1,	
height = height,
homepage = homepage_1,			
train = train_1,				
worktype = worktype_1,			
usekind	= usekind_1,				
workcode = workcode_1,			
contractbegintime = contractbegintime_1,		
jobright = jobright_1,			
jobcall	= jobcall_1,				
jobtype	= jobtype_1,			
accumfundaccount = accumfundaccount_1,
birthplace = birthplace_1,
folk = folk_1,
residentphone = residentphone_1,
residentpostcode = residentpostcode_1,
extphone = extphone_1 
WHERE ( id=id_1);

else 
UPDATE HrmResource  SET  loginid=loginid_2, firstname=firstname_4, lastname=lastname_5,
aliasname=aliasname_6, titleid=titleid_7, sex=sex_9, birthday=birthday_10, 
nationality=nationality_11, defaultlanguage=defaultlanguage_12, systemlanguage=systemlanguage_13,
maritalstatus=maritalstatus_14, marrydate=marrydate_15, telephone=telephone_16, mobile=mobile_17,
mobilecall=mobilecall_18, email=email_19, countryid=countryid_20, locationid=locationid_21, 
workroom=workroom_22, homeaddress=homeaddress_23, homepostcode=homepostcode_24,
homephone=homephone_25, resourcetype=resourcetype_26, startdate=startdate_27, enddate=enddate_28,
contractdate=contractdate_29, jobtitle=jobtitle_30, jobgroup=jobgroup_31, 
jobactivity=jobactivity_32, jobactivitydesc=jobactivitydesc_33, joblevel=joblevel_34,
seclevel=seclevel_35, departmentid=departmentid_36, subcompanyid1=subcompanyid1_37,
subcompanyid2=subcompanyid2_38, subcompanyid3=subcompanyid3_39, subcompanyid4=subcompanyid4_40,
 costcenterid=costcenterid_41, managerid=managerid_42, assistantid=assistantid_43, 
purchaselimit=purchaselimit_44, currencyid=currencyid_45, bankid1=bankid1_46, 
accountid1=accountid1_47, bankid2=bankid2_48, accountid2=accountid2_49, securityno=securityno_50, 
creditcard=creditcard_51, expirydate=expirydate_52, resourceimageid=resourceimageid_53, 
lastmodid=lastmodid_54, lastmoddate=lastmoddate_55 , datefield1=datefield1_1, 
datefield2=datefield2_1, datefield3=datefield3_1, datefield4=datefield4_1, datefield5=datefield5_1,
numberfield1=numberfield1_1, numberfield2=numberfield2_1, numberfield3=numberfield3_1,
numberfield4=numberfield4_1, numberfield5=numberfield5_1, textfield1=textfield1_1, 
textfield2=textfield2_1, textfield3=textfield3_1, textfield4=textfield4_1, textfield5=textfield5_1,
tinyintfield1=tinyintfield1_1, tinyintfield2=tinyintfield2_1, tinyintfield3=tinyintfield3_1,
tinyintfield4=tinyintfield4_1, 
tinyintfield5=tinyintfield5_1,
certificateCategory = certificateCategory_1,			
certificatenum	= certificatenum_1,			
nativeplace = nativeplace_1,		
educationlevel = educationlevel_1,			
bememberdate = bememberdate_1,			
bepartydate = bepartydate_1,
bedemocracydate = bedemocracydate_1,			
regresidentplace = regresidentplace_1,				
healthinfo = healthinfo_1,			
residentplace = residentplace_1,			
policy = policy_1,		
degree = degree_1,	
height = height_1,
homepage = homepage_1,			
train = train_1,				
worktype = worktype_1,			
usekind	= usekind_1,				
workcode = workcode_1,			
contractbegintime = contractbegintime_1,		
jobright = jobright_1,			
jobcall	= jobcall_1,				
jobtype	= jobtype_1,			
accumfundaccount = accumfundaccount_1,
birthplace = birthplace_1,
folk = folk_1,
residentphone = residentphone_1,
residentpostcode = residentpostcode_1,
extphone = extphone_1 
WHERE ( id=id_1); 
end if;
open thecursor for
select 1 from dual;
end;
/

CREATE or replace PROCEDURE HrmResource_UpdateLoginDate 
(id_1 	integer, 
lastlogindate_1 char , 
flag	out integer, 
msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
as 
begin
 update HrmResource set lastlogindate = lastlogindate_1 where id = id_1;
end;
/

CREATE or replace PROCEDURE HrmResource_UpdatePassword 
(id_1 	integer,
 passwordold_2     varchar2, 
 passwordnew_3     varchar2,
 flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
xx integer;
begin 
select count(id) into xx  from HrmResource where id=id_1 and password = passwordold_2;
if xx>0 then
update HrmResource set password = passwordnew_3 where id=id_1 and password = passwordold_2;
open thecursor for
select 1 from dual;
return;
else 
open thecursor for
select 2 from dual; 
return; 
end if;
end;
/

CREATE or replace PROCEDURE HrmResource_UpdatePic
 (id_1 	integer, 
resourceimageid_2     integer,
 flag	out integer, 
msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
update HrmResource set resourceimageid = 0 where id = id_1;
delete ImageFile where imagefileid = resourceimageid_2; 
 end;
/

CREATE or replace PROCEDURE HrmRewardsRecord_Delete
 (id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 as 
begin 
delete HrmRewardsRecord  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmRewardsRecord_Insert 
(resourceid_1 	integer,
 rewardsdate_2 	char, 
rewardstype_3 	integer,
 remark_4 	varchar2,
 createid_5 	integer, 
createdate_6 	char, 
createtime_7 	char,
 lastmoderid_8 	integer,
 lastmoddate_9 	char,
 lastmodtime_10 	char,
 flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
insert into HrmRewardsRecord ( resourceid, rewardsdate, rewardstype, remark, createid, createdate, 
createtime, lastmoderid, lastmoddate, lastmodtime)  VALUES ( resourceid_1, rewardsdate_2,
rewardstype_3, remark_4, createid_5, createdate_6, createtime_7, lastmoderid_8, 
lastmoddate_9, lastmodtime_10);
end;
/

 CREATE or REPLACE PROCEDURE HrmRewardsRecord_SByResourceID 
  (resourceid_1 varchar2,  
  flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmRewardsRecord where resourceid = to_number(resourceid_1) ; 

 end;
/

CREATE or replace PROCEDURE HrmRewardsRecord_SelectByID
(id_1 varchar2 ,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )
as 
begin 
open thecursor for 
select * from HrmRewardsRecord where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmRewardsRecord_Update
(id_1 	integer,
 resourceid_2 	integer,
 rewardsdate_3 	char,
 rewardstype_4 	integer, 
 remark_5 	varchar2,
 lastmoderid_6 	integer, 
 lastmoddate_7 	char,
 lastmodtime_8 	char,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
 update HrmRewardsRecord  SET  resourceid=resourceid_2, rewardsdate=rewardsdate_3, 
rewardstype=rewardstype_4, remark=remark_5, lastmoderid=lastmoderid_6, lastmoddate=lastmoddate_7,
lastmodtime=lastmodtime_8  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmRewardsType_Delete 
(id_1 	integer, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete HrmRewardsType  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmRewardsType_Insert 
(flag_1 	char, 
name_2 	varchar2,
 description_3 	varchar2,
 flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
  as
 begin 
insert into HrmRewardsType ( flag, name, description)  VALUES ( flag_1, name_2, description_3);
end;
/

CREATE or replace PROCEDURE HrmRewardsType_Select
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for 
select * from HrmRewardsType ;
end;
/

CREATE or replace PROCEDURE HrmRewardsType_SelectByID 
(id_1 varchar2 , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for 
select * from HrmRewardsType where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmRewardsType_Update
 (id_1 	integer, 
flag_2 	char,
name_3 	varchar2,
 description_4 	varchar2,
 flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
  as 
begin 
update HrmRewardsType  SET  flag=flag_2, name=name_3, description=description_4  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmRightTransfer_CRM 
(fromid_1	integer,
 toid_1	integer, 
 customerid_1	integer,
 flag	out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
as 
tempid_1   integer; 
CURSOR all_cursor is 
select id from CRM_CustomerInfo where manager=fromid_1;
begin
if customerid_1=0 then
OPEN all_cursor;
loop
 FETCH all_cursor INTO tempid_1; 
    exit when all_cursor%NOTFOUND;	
update CRM_CustomerInfo set manager=toid_1 where id=tempid_1;
end loop;
CLOSE all_cursor;
else 
update CRM_CustomerInfo set manager=toid_1 where id=customerid_1;
end if;
end;
/

 CREATE or replace PROCEDURE HrmRightTransfer_Doc 
       (fromid_1	integer, 
	toid_1 	integer, 
	userid_1	integer, 
	todeptid_1	integer, 
	flag	out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as 
      tempid_1		integer; 
      CURSOR all_cursor is 
      select id from docdetail where ownerid=fromid_1;
begin
        if userid_1=0 then
	   OPEN all_cursor; 
           loop
	   FETCH all_cursor INTO tempid_1;
           exit when all_cursor%notfound; 
	   update docdetail set ownerid=toid_1, docdepartmentid=todeptid_1 where id=tempid_1;
	   end loop;
	   CLOSE all_cursor;
	else 
	   update docdetail set ownerid=toid_1, docdepartmentid=todeptid_1 where id=userid_1; 
	end if;
end;
/


CREATE or replace PROCEDURE HrmRightTransfer_Project
(fromid_1	integer, 
toid_1	integer, 
projectid_1	integer,
 flag	out integer,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
tempid_1 integer; 
CURSOR all_cursor is 
select id from Prj_ProjectInfo where manager=fromid_1;
begin
if projectid_1=0 then
OPEN all_cursor;
loop
FETCH all_cursor INTO tempid_1;
exit when all_cursor%notfound;
update Prj_ProjectInfo set manager=toid_1 where id=tempid_1; 
end loop;
CLOSE all_cursor;
else 
update Prj_ProjectInfo set manager=toid_1 where id=projectid_1;
end if;
end;
/

CREATE or replace PROCEDURE HrmRightTransfer_Resource
(fromid_1	integer,
 toid_1	integer,
 resourceid_1	integer,
 flag	out integer,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
tempid_1	integer; 
CURSOR all_cursor is
select id from hrmresource where managerid=fromid_1;
begin
if resourceid_1=0 then
OPEN all_cursor;
loop
FETCH all_cursor INTO tempid_1;  
exit when all_cursor%notfound;
update hrmresource set managerid=toid_1 where id=tempid_1; 
end loop;
CLOSE all_cursor; 
else
update hrmresource set managerid=toid_1 where id=resourceid_1;
end if;
end;
/

CREATE or replace PROCEDURE HrmRoleMembers_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 as 
begin
 delete HrmRoleMembers  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmRoleMembers_Insert
(employeeid_1 integer, 
roleid_1 integer, 
level_1 integer, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
count_1 integer;
count_01 integer;
begin
select  count(id) into count_01 from HrmRoleMembers where roleid = roleid_1 and resourceid = employeeid_1;
if count_01>0 then

select  id into count_1 from HrmRoleMembers where roleid = roleid_1 and resourceid = employeeid_1;
end if;

if count_1 is null then
insert into HrmRoleMembers(roleid,resourceid,rolelevel) values(roleid_1,employeeid_1,level_1);
open thecursor for
select max(id) from HrmRoleMembers;
else
update HrmRoleMembers set rolelevel=level_1 where roleid = roleid and resourceid = employeeid_1;
open thecursor for
select count_1 from dual;
end if;
end;
/

 CREATE or REPLACE PROCEDURE HrmRoleMembers_SByDepartmentID 
 ( id_1 integer, 
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select resourceid,roleid,rolelevel from HrmRoleMembers, HrmResource WHERE HrmRoleMembers.resourceid = HrmResource.id and HrmResource.departmentid =  id_1 order by resourceid , rolelevel desc ;
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmRoleMembers_SByResourceID 
 ( id_1 	integer, 
 flag out integer,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmRoleMembers WHERE ( resourceid =  id_1) ;
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmRoleMembers_SelectByID 
 ( id_1 	integer,  
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmRoleMembers WHERE ( id =  id_1); 
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmRoleMembers_SByIDandLevel 
 ( id_1 	integer,
 level_1 char,  
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmRoleMembers WHERE ( roleid =  id_1) and rolelevel >=  level_1; 
 
 end;
/

 CREATE or REPLACE PROCEDURE HrmRoleMembers_Update 
 ( id_1 	integer,  
 rolelevel_2 	char, 
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

 UPDATE HrmRoleMembers  SET  rolelevel	 =  rolelevel_2  WHERE ( id	 =  id_1) ;

 end;
/

 CREATE or REPLACE PROCEDURE HrmRoles_SystemRight 
  (roleid_1 integer, 
  flag out integer, 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
 rightid_1 integer ; 
 rolelevel_1 varchar(8);
 rightgroupname_1 varchar(80); 
begin 
  for right_cursor1 in(select rightid,rolelevel from systemrightroles where roleid= roleid_1)
  loop
	  rightid_1 :=right_cursor1.rightid ;
	  rolelevel_1 :=right_cursor1.rolelevel ;
	  insert into TM_HrmRoles_SystemRight(rightid,rightlevel) values( rightid_1, rolelevel_1) ;
	  rightgroupname_1 := '' ;
	  select  rightgroupname into rightgroupname_1 from Systemrightgroups a, SystemRightToGroup b where rightid =  rightid_1 and a.id=b.groupid ;
	  update TM_HrmRoles_SystemRight set rightgroup =  rightgroupname_1 where rightid =  rightid_1;
  end loop;
  open thecursor for
  select rightgroup,rightlevel,rightid from TM_HrmRoles_SystemRight order by rightgroup ;

 end;
/

CREATE or replace PROCEDURE HrmRoles_deleteSingle
(roleid_1 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
xx integer;
begin 
open thecursor for
select count(id) into xx from hrmrolemembers where roleid=roleid_1;
if xx<>0 then
flag:=11;
open thecursor for
select flag from dual; 
return;
else 
delete hrmroles where id=roleid_1;
flag:=0;
open thecursor for
select flag from dual; 
end if;
end;
/

CREATE or replace PROCEDURE HrmRoles_insert
(rolesmark_1 varchar2, 
rolesname_1 varchar2, 
docid_1 in out integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
if docid_1 = 0 then
docid_1:=null;  
end if;
insert into HrmRoles(rolesmark,rolesname,docid) values(rolesmark_1,rolesname_1,docid_1);
open thecursor for 
select id from hrmroles where rolesmark=rolesmark_1 and rolesname=rolesname_1 and docid= docid_1;
end;
/

 CREATE or REPLACE PROCEDURE HrmSalaryComponentDetail_D 
  (componentid_1	integer, 
  flag   out integer, 
  msg    out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

 delete from HrmSalaryComponentDetail where componentid= componentid_1;

 end;
/

 CREATE or REPLACE PROCEDURE HrmSalaryComponentDetail_I 
  (componentid_1	integer,
  detailmark_1    varchar2, 
  joblevel_1      smallint,  
  salarysum_temp_1	varchar2,  
  editable_1		char, 
  flag          out integer, 
  msg           out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
 salarysum_1	decimal(10,3); 
 begin 

 if  salarysum_temp_1 = '' then
 salarysum_1:= null ;
 else 
 salarysum_1:= to_number(salarysum_temp_1);
 end if; 
 INSERT into HrmSalaryComponentDetail VALUES( componentid_1, detailmark_1, joblevel_1, salarysum_1, editable_1); 
 end;
/

 CREATE or REPLACE PROCEDURE HrmSalaryComponentDetail_SByID 
  (id_1   integer,  
  flag out integer ,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmSalaryComponentDetail where  componentid= id_1 ;
 end;
/

CREATE or replace PROCEDURE HrmSalaryComponentTypes_Delete
(id_1                                  integer,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
delete from HrmSalaryComponentTypes where id=id_1;
end;
/

CREATE or replace PROCEDURE HrmSalaryComponentTypes_Insert 
(typemark_1                     varchar2,
typename_1                    varchar2,
 colorid_1                        varchar2, 
typeorder_1            integer,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
insert into HrmSalaryComponentTypes (typemark,typename,colorid,typeorder) 
VALUES (typemark_1,typename_1,colorid_1,typeorder_1);
open thecursor for
select max(id) from HrmSalaryComponentTypes;
end;
/

CREATE or replace PROCEDURE HrmSalaryComponentTypes_Select
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select * from HrmSalaryComponentTypes order by typeorder;
end;
/

CREATE or replace PROCEDURE HrmSalaryComponentTypes_Update 
(id_1 	integer,
 typemark_1                     varchar2, 
 typename_1                   varchar2,
 colorid_1                         varchar2, 
 typeorder_1	            integer, 
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
update hrmsalarycomponenttypes set typemark=typemark_1,typename=typename_1,colorid=colorid_1,
typeorder=typeorder_1 where id=id_1;
end;
/

CREATE or replace PROCEDURE HrmSalaryComponent_Delete
(id_1 	integer,
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
delete FROM HrmSalaryComponent where id=id_1;
Delete from HrmSalaryComponentDetail where componentid=id_1;
end;
/

CREATE or replace PROCEDURE HrmSalaryComponent_Insert
(componentname_1	varchar2, 
 countryid_1         in out    integer, 
 jobactivityid_1              integer,
 componenttype_1	char, 
 componentperiod_1	char,
 currencyid_1 in out	integer,
 ledgerid_1	integer, 
 docid_1	in out	integer,
 startdate_1	char,
 enddate_1	char, 
 includetex_1	char, 
 componenttypeid_1	integer, 
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
if countryid_1=0 then		
countryid_1:=null;
end if; 
if currencyid_1=0 then	
currencyid_1:=null;
end if; 
if docid_1=0	then	
docid_1:=null;
end if;   
INSERT INTO HrmSalaryComponent (componentname,countryid,jobactivityid,componenttype,
 componentperiod,currencyid,ledgerid,docid,startdate, enddate,includetex,
componenttypeid) VALUES (componentname_1,countryid_1,jobactivityid_1,componenttype_1,
 componentperiod_1,currencyid_1,ledgerid_1,docid_1,startdate_1, enddate_1,includetex_1,
componenttypeid_1);
open thecursor for
select max(id) from HrmSalaryComponent;
end;
/ 

CREATE or replace PROCEDURE HrmSalaryComponent_Select 
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
 select * from HrmSalaryComponent; 
end;
/

CREATE or replace PROCEDURE HrmSalaryComponent_SelectAll
(jobactivityid_1           integer, 
countryid_1	integer, 
typeid_1 integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 AS 
begin
if jobactivityid_1=0 and countryid_1=0 and typeid_1=0 then
open thecursor for
select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2
where t1.id=t2.componentid and t1.countryid is null;
end if;
if jobactivityid_1=0 and countryid_1=0 and typeid_1<>0 then
open thecursor for
select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 
where t1.componenttypeid=typeid_1 and t1.id=t2.componentid and  t1.countryid is null;
end if; 
if jobactivityid_1=0 and countryid_1<>0 and typeid_1=0 then
open thecursor for
select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 
where t1.countryid=countryid_1 and t1.id=t2.componentid;
 end if; 
if jobactivityid_1<>0 and countryid_1=0 and typeid_1=0 then
open thecursor for
select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 
where  t1.jobactivityid=jobactivityid_1 and t1.id=t2.componentid and t1.countryid is null;
 end if;
if jobactivityid_1=0 and countryid_1<>0 and typeid_1<>0 then
open thecursor for
select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 
where t1.componenttypeid=typeid_1 and t1.countryid=countryid_1 and t1.id=t2.componentid;
end if; 
if jobactivityid_1<>0 and countryid_1=0 and typeid_1<>0 then
open thecursor for
select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 
where  t1.componenttypeid=typeid_1 and t1.jobactivityid=jobactivityid_1 and t1.id=t2.componentid 
and t1.countryid is null;
end if;  
if jobactivityid_1<>0 and countryid_1<>0 and typeid_1=0 then
open thecursor for
select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2
where  t1.countryid=countryid_1 and t1.jobactivityid=jobactivityid_1 and t1.id=t2.componentid;
end if; 
if jobactivityid_1<>0 and countryid_1<>0 and typeid_1<>0 then
open thecursor for
select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 
where t1.componenttypeid=typeid_1 and t1.countryid=countryid_1 and t1.jobactivityid=jobactivityid_1 
and t1.id=t2.componentid;
end if;
end;
/

CREATE or replace PROCEDURE HrmSalaryComponent_SelectByID
(id_1   integer,
 flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as begin 
open thecursor for 
select t1.* from HrmSalaryComponent t1 where  t1.id= id_1;
end;
/

CREATE or replace PROCEDURE HrmSalaryComponent_Update 
(id_1 	integer, 
componentname_1	varchar2,
countryid_1        in out           integer, 
jobactivityid_1              integer,
componenttype_1	char, 
componentperiod_1	char,
currencyid_1 in out	integer, 
ledgerid_1	integer, 
docid_1		in out	integer, 
startdate_1	char, 
enddate_1	char, 
includetex_1	char, 
componenttypeid_1	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
if countryid_1=0 then		
countryid_1:=null;
end if;
if currencyid_1=0 then	
currencyid_1:=null;
end if;
if docid_1=0 then	
docid_1:=null; 
end if;
update HrmSalaryComponent set componentname=componentname_1, countryid=countryid_1, 
jobactivityid=jobactivityid_1, componenttype=componenttype_1, componentperiod=componentperiod_1, 
currencyid=currencyid_1, ledgerid=ledgerid_1, docid=docid_1, startdate=startdate_1, 
enddate=enddate_1,includetex=includetex_1, componenttypeid=componenttypeid_1 where id=id_1;
end;
/

CREATE or replace PROCEDURE HrmScheduleDiff_Delete
 (id_1 	integer, 
flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as
begin
delete HrmScheduleDiff  WHERE ( id=id_1) ;
end;
/

CREATE or replace PROCEDURE HrmScheduleDiff_Insert
 (diffname_1 	varchar2,
 diffdesc_2 	varchar2, 
difftype_3 	char,
 difftime_4 	char, 
mindifftime_5 	smallint, 
workflowid_6 	integer, 
salaryable_7 	char,
 counttype_8 	char, 
countnum_9 	integer,
 currencyid_10 	integer, 
userid_11 	integer, 
diffremark_12 	varchar2,
 flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
insert into HrmScheduleDiff ( diffname, diffdesc, difftype, difftime, mindifftime, workflowid, 
salaryable, counttype, countnum, currencyid, docid, diffremark)  VALUES ( diffname_1, diffdesc_2,
 difftype_3, difftime_4, mindifftime_5, workflowid_6, salaryable_7, counttype_8, countnum_9,
 currencyid_10, userid_11, diffremark_12);
open thecursor for
 select max(id) from HrmScheduleDiff;
end;
/

CREATE or replace PROCEDURE HrmScheduleDiff_Select_ByID 
(id_1 integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
 select * from HrmScheduleDiff where id = (id_1); 
end;
/

CREATE or replace PROCEDURE HrmScheduleDiff_Update
(id_1 	integer,
 diffname_2 	varchar2,
 diffdesc_3 	varchar2, 
 difftype_4 	char, 
 difftime_5 	char, 
 mindifftime_6 	smallint,
 workflowid_7 	integer, 
 salaryable_8 	char,
 counttype_9 	char,
 countnum_1      varchar2,
 currencyid_11 	in out integer,
 docid_12 	in out integer,
 diffremark_13 	varchar2,
 flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 AS
countnum_10 number(10,3);
begin
if docid_12 = 0 then
docid_12:=null;
end if;
if currencyid_11=0 then         
currencyid_11:=null;
end if;
if countnum_1 <>'' then
countnum_10:= to_number(countnum_1);
else 
countnum_10:= 0;
end if;  
UPDATE HrmScheduleDiff  SET  diffname=diffname_2, diffdesc=diffdesc_3, difftype=difftype_4,
difftime=difftime_5, mindifftime=mindifftime_6, workflowid=workflowid_7,
salaryable=salaryable_8, counttype=counttype_9, countnum=countnum_10, currencyid=currencyid_11,
docid= docid_12, diffremark=diffremark_13  WHERE ( id=id_1); 
end;
/

CREATE or replace PROCEDURE HrmSchedule_Delete 
(id_1 	integer, 
flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete HrmSchedule  WHERE ( id=id_1);
end;
/ 

 CREATE or replace PROCEDURE HrmSchedule_Insert 
(relatedid_1 	integer, 
monstarttime1_2 	char,
 monendtime1_3 	char, 
monstarttime2_4 	char, 
monendtime2_5 	char, 
tuestarttime1_6 	char,
 tueendtime1_7 	char,
 tuestarttime2_8 	char, 
tueendtime2_9 	char, 
wedstarttime1_10 	char,
 wedendtime1_11 	char, 
wedstarttime2_12 	char, 
wedendtime2_13 	char, 
thustarttime1_14 	char, 
thuendtime1_15 	char, 
thustarttime2_16 	char,
 thuendtime2_17 	char,
 fristarttime1_18 	char,
 friendtime1_19 	char, 
fristarttime2_20 	char,
friendtime2_21 	char,
 satstarttime1_22 	char,
 satendtime1_23 	char, 
satstarttime2_24 	char, 
satendtime2_25 	char, 
sunstarttime1_26 	char, 
sunendtime1_27 	char, 
sunstarttime2_28 	char,
 sunendtime2_29 	char,
 totaltime_1            char,
 scheduletype_30 	char, 
flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
insert into HrmSchedule ( relatedid, monstarttime1, monendtime1, monstarttime2, monendtime2, 
tuestarttime1, tueendtime1, tuestarttime2, tueendtime2, wedstarttime1, wedendtime1, wedstarttime2,
 wedendtime2, thustarttime1, thuendtime1, thustarttime2, thuendtime2, fristarttime1, friendtime1,
 fristarttime2, friendtime2, satstarttime1, satendtime1, satstarttime2, satendtime2, sunstarttime1,
 sunendtime1, sunstarttime2, sunendtime2, totaltime, scheduletype)  VALUES ( relatedid_1,
 monstarttime1_2, monendtime1_3, monstarttime2_4, monendtime2_5, tuestarttime1_6,
 tueendtime1_7, tuestarttime2_8, tueendtime2_9, wedstarttime1_10, wedendtime1_11, 
wedstarttime2_12, wedendtime2_13, thustarttime1_14, thuendtime1_15, thustarttime2_16,
 thuendtime2_17, fristarttime1_18, friendtime1_19, fristarttime2_20, friendtime2_21, 
satstarttime1_22, satendtime1_23, satstarttime2_24, satendtime2_25, sunstarttime1_26,
 sunendtime1_27, sunstarttime2_28, sunendtime2_29, totaltime_1, scheduletype_30);
open thecursor for
 select max(id) from HrmSchedule;
end;
/

CREATE or replace PROCEDURE HrmSchedule_Select
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as
 begin
open thecursor for
 select * from HrmSchedule where scheduletype='0';
end;
/

CREATE or replace PROCEDURE HrmSchedule_Select_All
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for 
select id, diffname from HrmScheduleDiff order by id; 
end;
/

CREATE or replace PROCEDURE HrmSchedule_Select_ByID 
(id_1 varchar2 ,
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
 select * from HrmSchedule where id = to_number(id_1);
end;
/


CREATE or replace PROCEDURE HrmSchedule_Select_CheckExist
(relatedid_1 integer,
 scheduletype_1 char, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
 open thecursor for
 select * from HrmSchedule where relatedid = relatedid_1 and scheduletype =scheduletype_1;
end;
/

CREATE or replace PROCEDURE HrmSchedule_Select_Default 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
open thecursor for
 select * from HrmSchedule where scheduletype ='0';
end;
/

CREATE or replace PROCEDURE HrmSchedule_Select_DeptAll
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
 begin
 open thecursor for 
select t1.id,t1.relatedid from HrmSchedule t1 where scheduletype='1';
end;
/

CREATE or replace PROCEDURE HrmSchedule_Select_ResouceAll
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for
 select t1.id,t1.relatedid from HrmSchedule t1 where scheduletype='2';
end;
/

CREATE or replace PROCEDURE HrmSchedule_Update 
(id_1 	integer, 
relatedid_2 	integer, 
monstarttime1_3 	char, 
monendtime1_4 	char, 
monstarttime2_5 	char, 
monendtime2_6 	char, 
tuestarttime1_7 	char, 
tueendtime1_8 	char,
tuestarttime2_9 	char, 
tueendtime2_10 	char, 
wedstarttime1_11 	char, 
wedendtime1_12 	char, 
wedstarttime2_13 	char, 
wedendtime2_14 	char, 
thustarttime1_15 	char, 
thuendtime1_16 	char, 
thustarttime2_17 	char, 
thuendtime2_18 	char, 
fristarttime1_19 	char, 
friendtime1_20 	char, 
fristarttime2_21 	char, 
friendtime2_22 	char, 
satstarttime1_23 	char, 
satendtime1_24 	char, 
satstarttime2_25 	char, 
satendtime2_26 	char, 
sunstarttime1_27 	char, 
sunendtime1_28 	char, 
sunstarttime2_29 	char, 
sunendtime2_30 	char, 
totaltime_1              char, 
scheduletype_31 	char, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
update HrmSchedule  SET  relatedid=relatedid_2, monstarttime1=monstarttime1_3,
 monendtime1=monendtime1_4, monstarttime2=monstarttime2_5, monendtime2=monendtime2_6,
 tuestarttime1=tuestarttime1_7, tueendtime1=tueendtime1_8, tuestarttime2=tuestarttime2_9, 
tueendtime2=tueendtime2_10, wedstarttime1=wedstarttime1_11, wedendtime1=wedendtime1_12, 
wedstarttime2=wedstarttime2_13, wedendtime2=wedendtime2_14, thustarttime1=thustarttime1_15, 
thuendtime1=thuendtime1_16, thustarttime2=thustarttime2_17, thuendtime2=thuendtime2_18,
 fristarttime1=fristarttime1_19, friendtime1=friendtime1_20, fristarttime2=fristarttime2_21, 
friendtime2=friendtime2_22, satstarttime1=satstarttime1_23, satendtime1=satendtime1_24, 
satstarttime2=satstarttime2_25, satendtime2=satendtime2_26, sunstarttime1=sunstarttime1_27, 
sunendtime1=sunendtime1_28, sunstarttime2=sunstarttime2_29, sunendtime2=sunendtime2_30, 
totaltime= totaltime_1, scheduletype=scheduletype_31  WHERE ( id=id_1);
end;
/ 

CREATE or replace PROCEDURE HrmSearchMould_Delete 
(id_1 	integer,
 flag out integer,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as
 begin 
delete HrmSearchMould  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE HrmSearchMould_Insert 
(mouldname_1 	varchar2, 
userid_1_2 	integer, 
resourceid_3 	integer, 
resourcename_4 	varchar2, 
jobtitle_5 	integer, 
activitydesc_6 	varchar2,
 jobgroup_7 	integer,
 jobactivity_8 	integer, 
costcenter_9 	integer, 
competency_10 	integer, 
resourcetype_11 	char,
 status_12 	char, 
subcompany1_13 	integer,
 subcompany2_14 	integer, 
subcompany3_15 	integer, 
subcompany4_16 	integer, 
department_17 	integer, 
location_18 	integer,
 manager_19 	integer, 
assistant_20 	integer, 
roles_21 	integer, 
seclevel_22 	smallint,
joblevel_23 	smallint, 
workroom_24 	varchar2, 
telephone_25 	varchar2,
 startdate_26 	char,
 enddate_27 	char, 
contractdate_28 	char, 
birthday_29 	char,
 sex_30 	char, 
seclevelTo_1 smallint,
joblevelTo_1 smallint,
startdateTo_1 char,
enddateTo_1 char,
contractdateTo_1 char,
birthdayTo_1 char,
age_1 integer,
ageTo_1 integer,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as begin insert into HrmSearchMould ( mouldname, userid, resourceid, 
resourcename, jobtitle, activitydesc, jobgroup, jobactivity, costcenter,
 competency, resourcetype, status, subcompany1, subcompany2,
 subcompany3, subcompany4, department, location, manager, assistant, 
roles, seclevel, joblevel, workroom, telephone, startdate, enddate,
 contractdate, birthday, sex,
seclevelTo,
joblevelTo,
startdateTo,
enddateTo,
contractdateTo,
birthdayTo,
age,
ageTo)
  VALUES ( mouldname_1, userid_1_2, 
resourceid_3, resourcename_4, jobtitle_5, 
activitydesc_6, jobgroup_7, jobactivity_8, 
costcenter_9, competency_10, resourcetype_11, status_12, 
subcompany1_13, subcompany2_14, subcompany3_15,
 subcompany4_16, department_17, location_18, manager_19,
 assistant_20, roles_21, seclevel_22, joblevel_23, workroom_24,
 telephone_25, startdate_26, enddate_27, contractdate_28, 
birthday_29, sex_30,
seclevelTo_1,
joblevelTo_1,
startdateTo_1,
enddateTo_1,
contractdateTo_1,
birthdayTo_1,
age_1,
ageTo_1
);
open thecursor for
select max(id) from HrmSearchMould; 
end;
/

CREATE or replace PROCEDURE HrmSearchMould_SelectByID
(id_1 varchar2 , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
open thecursor for 
select * from HrmSearchMould where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmSearchMould_SelectByUserID
(id_1 varchar2 , 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for 
select * from HrmSearchMould where userid =to_number(id_1);
end;
/

 CREATE or replace PROCEDURE HrmSearchMould_Update
 (id_1 			integer,
 userid_1_3 		integer,
 resourceid_4		integer,
 resourcename_5 	varchar2,
 jobtitle_6 		integer, 
 activitydesc_7 	varchar2,
 jobgroup_8 		integer, 
 jobactivity_9 	integer,
 costcenter_10 	integer,
 competency_11 	integer,
 resourcetype_12 	char, 
 status_13 		char, 
 subcompany1_14 	integer, 
 subcompany2_15 	integer,
 subcompany3_16 	integer, 
 subcompany4_17 	integer,
 department_18 	integer,
 location_19 		integer,
 manager_20 		integer,
 assistant_21		integer, 
 roles_22		integer,
 seclevel_23		smallint, 
joblevel_24 		smallint,
 workroom_25 		varchar2,
 telephone_26 		varchar2,
 startdate_27 		char,
 enddate_28 		char,
 contractdate_29 	char,
 birthday_30 		char, 
sex_31 		char, 
seclevelTo_1		smallint,
joblevelTo_1		smallint,
startdateTo_1		char,
enddateTo_1		char,
contractdateTo_1	char,
birthdayTo_1		char,
age_1			integer,
ageTo_1		integer,
flag out		integer, 
msg out			varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
update HrmSearchMould  SET   userid=userid_1_3, resourceid=resourceid_4, 
resourcename=resourcename_5, jobtitle=jobtitle_6, activitydesc=activitydesc_7, jobgroup=jobgroup_8, 
jobactivity=jobactivity_9, costcenter=costcenter_10, competency=competency_11,
resourcetype=resourcetype_12, status=status_13, subcompany1=subcompany1_14,
subcompany2=subcompany2_15, subcompany3=subcompany3_16, subcompany4=subcompany4_17, 
department=department_18, location=location_19, manager=manager_20, assistant=assistant_21,
roles=roles_22, seclevel=seclevel_23,joblevel=joblevel_24, workroom=workroom_25, 
telephone=telephone_26, startdate=startdate_27, enddate=enddate_28, contractdate=contractdate_29,
birthday=birthday_30, sex=sex_31 ,seclevelTo = seclevelTo_1,joblevelTo = joblevelTo_1,
startdateTo = startdateTo_1,enddateTo = enddateTo_1,contractdateTo = contractdateTo_1,
birthdayTo = birthdayTo_1,age = age_1,ageTo = ageTo_1 WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmSpeciality_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
 as 
begin delete HrmSpeciality  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmSpeciality_Insert 
(name_1 	varchar2,
 description_2 	varchar2,
 flag out integer, 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
  as
 begin insert into HrmSpeciality ( name, description)  VALUES ( name_1, description_2);
end;
/

CREATE or replace PROCEDURE HrmSpeciality_Select
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
  as 
begin 
open thecursor for 
select * from HrmSpeciality; 
end;
/

CREATE or replace PROCEDURE HrmSpeciality_SelectByID
(id_1 varchar2 , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
open thecursor for 
select * from HrmSpeciality where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmSpeciality_Update 
(id_1 	integer,
 name_2 	varchar2,
 description_3 	varchar2,
 flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as
 begin 
update HrmSpeciality  SET  name=name_2, description=description_3  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmSubCompany_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
recordercount_1 integer;
begin 
Select count(id) into recordercount_1 from HrmDepartment where subcompanyid1 =to_number(id_1)
or subcompanyid2=to_number(id_1) or  subcompanyid3 =to_number(id_1) or subcompanyid4 =to_number(id_1);
if recordercount_1 = 0 then
DELETE HrmSubCompany  WHERE ( id=id_1); 
else 
open thecursor for
select '20' from dual;
end if; 
end;
/ 

CREATE or replace PROCEDURE HrmSubCompany_Insert 
(subcompanyname_1 	varchar2,
 subcompanydesc_2 	varchar2, 
companyid_3 	smallint, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS  
begin
INSERT INTO HrmSubCompany ( subcompanyname, subcompanydesc, companyid) 
 VALUES ( subcompanyname_1, subcompanydesc_2, companyid_3);
open thecursor for
 select (max(id)) from HrmSubCompany;
end;
/


 CREATE or REPLACE PROCEDURE HrmSubCompany_SByCompanyID 
 (id_1 varchar2 ,  
 flag out integer ,  
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmSubCompany where companyid = to_number(id_1) ;

 end;
/

CREATE or replace PROCEDURE HrmSubCompany_Select
(flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for select * from HrmSubCompany; 
end;
/

CREATE or replace PROCEDURE HrmSubCompany_Update
 (id_1 	integer, 
 subcompanyname_2 	varchar2,
 subcompanydesc_3 	varchar2,
 companyid_4 	smallint,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
as
begin 
update HrmSubCompany  SET  subcompanyname=subcompanyname_2, subcompanydesc=subcompanydesc_3, 
companyid=companyid_4  WHERE ( id=id_1); 
end;
/

 CREATE or REPLACE PROCEDURE HrmTrainRecord_Delete 
 ( id_1  integer, 
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 

 DELETE HrmTrainRecord  WHERE ( id =  id_1) ;
 end;
/

 CREATE or replace PROCEDURE HrmTrainRecord_Insert 
(resourceid_1 	integer,
trainstartdate_2 	char, 
trainenddate_3 	char, 
traintype_4 	integer, 
trainrecord_5 	varchar2, 
createid_6 	integer, 
createdate_7 	char, 
createtime_8 	char,
lastmoderid_9 	integer,
lastmoddate_10 	char, 
lastmodtime_11 	char,
trainhour_1		decimal,
trainunit_1		varchar2, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as
begin 
insert into HrmTrainRecord ( resourceid, trainstartdate, trainenddate, traintype, trainrecord, 
createid, createdate, createtime, lastmoderid, lastmoddate, lastmodtime, trainhour, trainunit )  
VALUES ( resourceid_1, trainstartdate_2, trainenddate_3, traintype_4, trainrecord_5, createid_6,
createdate_7, createtime_8, lastmoderid_9, lastmoddate_10, lastmodtime_11, trainhour_1,
trainunit_1);
end;
/

 CREATE or REPLACE PROCEDURE HrmTrainRecord_SByResourceID 
  (resourceid_1 varchar2 ,
  flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmTrainRecord where resourceid = to_number(resourceid_1) ;
 end;
/

CREATE or replace PROCEDURE HrmTrainRecord_SelectByID
(id_1 varchar2 ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
select * from HrmTrainRecord where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmTrainRecord_Update 
(id_1 	integer,
resourceid_3 	integer, 
trainstartdate_4 	char, 
trainenddate_2 	char, 
traintype_5 	integer,
trainrecord_6 	varchar2, 
lastmoderid_7 	integer, 
lastmoddate_8 	char,
lastmodtime_9 	char,
trainhour_1		decimal,
trainunit_1		varchar2, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
update HrmTrainRecord  SET resourceid=resourceid_3, trainstartdate=trainstartdate_4, 
trainenddate=trainenddate_2, traintype=traintype_5, trainrecord=trainrecord_6, 
lastmoderid=lastmoderid_7, lastmoddate=lastmoddate_8, lastmodtime=lastmodtime_9, 
trainhour= trainhour_1, trainunit= trainunit_1  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmTrainType_Delete 
(id_1 	integer, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin delete HrmTrainType  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmTrainType_Insert 
(name_1 	varchar2, 
description_2 	varchar2,
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin 
insert into HrmTrainType ( name, description)  VALUES ( name_1, description_2);
end;
/

CREATE or replace PROCEDURE HrmTrainType_Select
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select * from HrmTrainType;
end;
/


CREATE or replace PROCEDURE HrmTrainType_SelectByID 
(id_1 varchar2 ,
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmTrainType where id =to_number(id_1);
end;
/

CREATE or replace PROCEDURE HrmTrainType_Update
(id_1 	integer, 
name_2 	varchar2,
description_3 	varchar2, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin
update HrmTrainType  SET  name=name_2, description=description_3  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmUseKind_Delete 
(id_1 	integer, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin delete HrmUseKind  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmUseKind_Insert 
(name_1 	varchar2, 
description_2 	varchar2, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert into HrmUseKind ( name, description)  VALUES ( name_1, description_2);
end;
/

CREATE or replace PROCEDURE HrmUseKind_Select
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
open thecursor for
select * from HrmUseKind; 
end;
/

CREATE or replace PROCEDURE HrmUseKind_SelectByID
(id_1 varchar2 ,
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select * from HrmUseKind where id =to_number(id_1) ;
end;
/


CREATE or replace PROCEDURE HrmUseKind_Update 
(id_1 	integer,
name_2 	varchar2,
description_3 	varchar2, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
update HrmUseKind  SET  name=name_2, description=description_3  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmUserDefine_Insert
(userid_1 		integer,
 hasresourceid_2 	char,
 hasresourcename_3 	char,
 hasjobtitle_4 	char,
 hasactivitydesc_5 	char,
 hasjobgroup_6 	char, 
 hasjobactivity_7 	char,
 hascostcenter_8 	char,
 hascompetency_9 	char,
 hasresourcetype_10 	char, 
 hasstatus_11		char,
 hassubcompany_12 	char, 
 hasdepartment_13 	char,
 haslocation_14 	char, 
 hasmanager_15 	char,
 hasassistant_16 	char, 
 hasroles_17 		char,
 hasseclevel_18 	char, 
 hasjoblevel_19 	char,
 hasworkroom_20 	char, 
 hastelephone_21 	char,
 hasstartdate_22 	char, 
 hasenddate_23 	char,
 hascontractdate_24 	char, 
 hasbirthday_25 	char,
 hassex_26 		char, 
 projectable_27 	char,
 crmable_28 		char,
 itemable_29 		char,
 docable_30 		char,
 workflowable_31 	char,
 subordinateable_32 	char,
 trainable_33 		char,
 budgetable_34 	char, 
 fnatranable_35 	char,
 dspperpage_36 	smallint, 
 hasage_1		char,
 flag out		integer,
 msg out		varchar2,	
 thecursor IN OUT cursor_define.weavercursor )  
AS 
recordercount_1 integer;
begin
Select count(userid) INTO recordercount_1 from HrmUserDefine 
where userid =to_number(userid_1);
if recordercount_1 = 0 then
INSERT INTO HrmUserDefine
(userid, hasresourceid, hasresourcename, hasjobtitle, 
hasactivitydesc, hasjobgroup, hasjobactivity, hascostcenter, 
hascompetency, hasresourcetype, hasstatus, hassubcompany, 
hasdepartment, haslocation, hasmanager, hasassistant, hasroles, 
hasseclevel, hasjoblevel, hasworkroom, hastelephone, 
hasstartdate, hasenddate, hascontractdate, hasbirthday, hassex, 
projectable, crmable, itemable, docable, workflowable, subordinateable, 
trainable, budgetable, fnatranable, dspperpage,hasage)  
VALUES ( userid_1, hasresourceid_2, hasresourcename_3, 
hasjobtitle_4, hasactivitydesc_5, hasjobgroup_6, hasjobactivity_7, 
hascostcenter_8, hascompetency_9, hasresourcetype_10, 
hasstatus_11, hassubcompany_12, hasdepartment_13,
 haslocation_14, hasmanager_15, hasassistant_16, hasroles_17, 
hasseclevel_18, hasjoblevel_19, hasworkroom_20, hastelephone_21,
 hasstartdate_22, hasenddate_23, hascontractdate_24, hasbirthday_25, 
hassex_26, projectable_27, crmable_28, itemable_29, docable_30, 
workflowable_31, subordinateable_32, trainable_33, budgetable_34,
fnatranable_35, dspperpage_36,hasage_1); 
else 
UPDATE HrmUserDefine  SET  hasresourceid=hasresourceid_2, hasresourcename=hasresourcename_3, 
hasjobtitle=hasjobtitle_4, hasactivitydesc=hasactivitydesc_5, hasjobgroup=hasjobgroup_6, 
hasjobactivity=hasjobactivity_7, hascostcenter=hascostcenter_8, hascompetency=hascompetency_9, 
hasresourcetype=hasresourcetype_10, hasstatus=hasstatus_11, hassubcompany=hassubcompany_12,
hasdepartment=hasdepartment_13, haslocation=haslocation_14, hasmanager=hasmanager_15, 
hasassistant=hasassistant_16, hasroles=hasroles_17, hasseclevel=hasseclevel_18, 
hasjoblevel=hasjoblevel_19, hasworkroom=hasworkroom_20, hastelephone=hastelephone_21,
hasstartdate=hasstartdate_22, hasenddate=hasenddate_23, hascontractdate=hascontractdate_24, 
hasbirthday=hasbirthday_25, hassex=hassex_26, projectable=projectable_27, crmable=crmable_28, 
itemable=itemable_29, docable=docable_30, workflowable=workflowable_31, 
subordinateable=subordinateable_32, trainable=trainable_33, budgetable=budgetable_34, 
fnatranable=fnatranable_35,dspperpage=dspperpage_36, hasage = hasage_1
WHERE ( userid=userid_1); 
end if;
end;
/

CREATE or replace PROCEDURE HrmUserDefine_SelectByID
(id_1 varchar2 , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
recordercount_1 integer;
begin
Select count(userid) INTO recordercount_1 from HrmUserDefine where userid =to_number(id_1);  
if recordercount_1 = 0 then
open thecursor for
select * from HrmUserDefine where userid =-1; 
else 
open thecursor for
select * from HrmUserDefine where userid =to_number(id_1);
end if;
end; 
/

 CREATE or replace PROCEDURE HrmUserDefine_Update
(userid_1 		integer,
hasresourceid_2 	char, 
hasresourcename_3 	char, 
hasjobtitle_4 		char,
hasactivitydesc_5 	char,
hasjobgroup_6 		char,
hasjobactivity_7 	char,
hascostcenter_8 	char,
hascompetency_9 	char,
hasresourcetype_10 	char,
hasstatus_11 		char,
hassubcompany_12 	char,
hasdepartment_13 	char,
haslocation_14 	char,
hasmanager_15 		char,
hasassistant_16 	char,
hasroles_17 		char,
hasseclevel_18 	char,
hasjoblevel_19 	char,
hasworkroom_20 	char,
hastelephone_21 	char,
hasstartdate_22 	char,
hasenddate_23 		char,
hascontractdate_24 	char,
hasbirthday_25 	char,
hassex_26 		char,
projectable_27 	char,
crmable_28 		char,
itemable_29 		char,
docable_30 		char,
workflowable_31 	char,
subordinateable_32 	char,
trainable_33 		char,
budgetable_34 		char,
fnatranable_35 	char,
dspperpage_36 		smallint,
flag out		integer,
msg out			varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
update HrmUserDefine  SET  hasresourceid=hasresourceid_2, hasresourcename=hasresourcename_3, 
hasjobtitle=hasjobtitle_4, hasactivitydesc=hasactivitydesc_5, hasjobgroup=hasjobgroup_6,
hasjobactivity=hasjobactivity_7, hascostcenter=hascostcenter_8, hascompetency=hascompetency_9,
hasresourcetype=hasresourcetype_10, hasstatus=hasstatus_11, hassubcompany=hassubcompany_12, 
hasdepartment=hasdepartment_13, haslocation=haslocation_14, hasmanager=hasmanager_15, 
hasassistant=hasassistant_16, hasroles=hasroles_17, hasseclevel=hasseclevel_18,
hasjoblevel=hasjoblevel_19, hasworkroom=hasworkroom_20, hastelephone=hastelephone_21,
hasstartdate=hasstartdate_22, hasenddate=hasenddate_23, hascontractdate=hascontractdate_24,
hasbirthday=hasbirthday_25, hassex=hassex_26, projectable=projectable_27, crmable=crmable_28,
itemable=itemable_29, docable=docable_30, workflowable=workflowable_31,
subordinateable=subordinateable_32, trainable=trainable_33, budgetable=budgetable_34, 
fnatranable=fnatranable_35, dspperpage=dspperpage_36  WHERE ( userid=userid_1);
end;
/

CREATE or replace PROCEDURE HrmWelfare_Delete
(id_1 	integer,
flag out		integer,
msg out			varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
delete HrmWelfare WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE HrmWelfare_Insert
	(resourceid_1 		integer,
	 datefrom_2 		char,
	 dateto_3 		char,
	 basesalary_4 		decimal,
	 homesub_5 		decimal,
	 vehiclesub_6 		decimal,
	 mealsub_7 		decimal,
	 othersub_8 		decimal,
	 adjustreason_9 	varchar2,
	 createid_10 		integer,
	 createdate_11 		char,
	 createtime_12 		char,
	 lastmoderid_13 	integer,
	 lastmoddate_14 	char,
	 lastmodtime_15 	char,
	 flag out		integer,
	 msg out		varchar2,
	thecursor IN OUT cursor_define.weavercursor )

as 
begin
insert into HrmWelfare 
	 (resourceid,
	 datefrom,
	 dateto,
	 basesalary,
	 homesub,
	 vehiclesub,
	 mealsub,
	 othersub,
	 adjustreason,
	 createid,
	 createdate,
	 createtime,
	 lastmoderid,
	 lastmoddate,
	 lastmodtime) 
 
VALUES 
	( resourceid_1,
	 datefrom_2,
	 dateto_3,
	 basesalary_4,
	 homesub_5,
	 vehiclesub_6,
	 mealsub_7,
	 othersub_8,
	 adjustreason_9,
	 createid_10,
	 createdate_11,
	 createtime_12,
	 lastmoderid_13,
	 lastmoddate_14,
	 lastmodtime_15);
	 end;
/

CREATE or replace PROCEDURE HrmWelfare_SelectByID
	 (id_1 varchar2 , 
	 flag out integer , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
 as 
 begin 
 open thecursor for
 select * from HrmWelfare where id =to_number(id_1);
 end;
/

 CREATE or replace PROCEDURE HrmWelfare_SelectByResourceID
	 (resourceid_1 varchar2 , 
	 flag out integer , 
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmWelfare where resourceid =to_number(resourceid_1);
end;
/

CREATE or replace PROCEDURE HrmWelfare_Update
	(id_1 			integer,
	 resourceid_2 		integer,
	 datefrom_3 		char,
	 dateto_4 		char,
	 basesalary_5		decimal,
	 homesub_6 		decimal,
	 vehiclesub_7		decimal,
	 mealsub_8 		decimal,
	 othersub_9 		decimal,
	 adjustreason_10 	varchar2,
	 lastmoderid_11 	integer,
	 lastmoddate_12 	char,
	 lastmodtime_13 	char,
	 flag out		integer , 
	 msg out		varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

as 
begin update HrmWelfare 
SET  resourceid=resourceid_2,
	 datefrom=datefrom_3,
	 dateto=dateto_4,
	 basesalary=basesalary_5,
	 homesub=homesub_6,
	 vehiclesub=vehiclesub_7,
	 mealsub=mealsub_8,
	 othersub=othersub_9,
	 adjustreason=adjustreason_10,
	 lastmoderid=lastmoderid_11,
	 lastmoddate=lastmoddate_12,
	 lastmodtime=lastmodtime_13 

WHERE 
	( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmWorkResumeIn_Delete
	(id_1 	integer,
	 flag out integer,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)

as 
begin 
delete from HrmWorkResumeIn WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE HrmWorkResumeIn_Insert
	(resourceid_1		integer,
	 datefrom_2 		char,
	 dateto_3 		char,
	 departmentid_4 	integer,
	 jobtitle_5 		integer,
	 joblevel_6 		smallint,
	 createid_7 		integer,
	 createdate_8 		char,
	 createtime_9 		char,
	 lastmoderid_10 	integer,
	 lastmoddate_11 	char,
	 lastmodtime_12 	char,
	 flag out		integer,
	 msg out		varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)

as begin insert into HrmWorkResumeIn 
	 ( resourceid,
	 datefrom,
	 dateto,
	 departmentid,
	 jobtitle,
	 joblevel,
	 createid,
	 createdate,
	 createtime,
	 lastmoderid,
	 lastmoddate,
	 lastmodtime) 
 
VALUES 
	( resourceid_1,
	 datefrom_2,
	 dateto_3,
	 departmentid_4,
	 jobtitle_5,
	 joblevel_6,
	 createid_7,
	 createdate_8,
	 createtime_9,
	 lastmoderid_10,
	 lastmoddate_11,
	 lastmodtime_12);
end;
/

CREATE or REPLACE PROCEDURE HrmWorkResumeIn_SByResourceID 
	  (resourceid_1 varchar2 , 
	  flag out integer , 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from HrmWorkResumeIn where resourceid = to_number(resourceid_1);

 end;
/


CREATE or replace PROCEDURE HrmWorkResumeIn_SelectByID
	 (id_1 varchar2 , 
	 flag out integer , 
	 msg out varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
 open thecursor for 
 select * from HrmWorkResumeIn where id =to_number(id_1);
 end;
/

 CREATE or replace PROCEDURE HrmWorkResumeIn_Update
	(id_1 			integer,
	 resourceid_2 		integer,
	 datefrom_3 		char,
	 dateto_4 		char,
	 departmentid_5 	integer,
	 jobtitle_6 		integer,
	 joblevel_7 		smallint,
	 lastmoderid_8 	integer,
	 lastmoddate_9 	char,
	 lastmodtime_10 	char,
	 flag out		integer,
	 msg out		varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)
as
begin update HrmWorkResumeIn 
SET  resourceid=resourceid_2,
	 datefrom=datefrom_3,
	 dateto=dateto_4,
	 departmentid=departmentid_5,
	 jobtitle=jobtitle_6,
	 joblevel=joblevel_7,
	 lastmoderid=lastmoderid_8,
	 lastmoddate=lastmoddate_9,
	 lastmodtime=lastmodtime_10 
WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE HrmWorkResume_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as
begin 
delete HrmWorkResume  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE HrmWorkResume_Insert 
(resourceid_1 	integer,
startdate_2 	char,
enddate_3 	char,
company_4 	varchar2,
companystyle_5 	integer,
jobtitle_6 	varchar2,
workdesc_7 	varchar2,
leavereason_8 	varchar2,
createid_9 	integer,
createdate_10 	char,
createtime_11 	char,
lastmoderid_12 	integer,
lastmoddate_13 	char,
lastmodtime_14 	char,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
insert into HrmWorkResume ( resourceid, startdate, enddate, company, companystyle, jobtitle, workdesc,
leavereason, createid, createdate, createtime, lastmoderid, lastmoddate, lastmodtime)  
VALUES ( resourceid_1, startdate_2, enddate_3, company_4, companystyle_5, jobtitle_6,
workdesc_7, leavereason_8, createid_9, createdate_10, createtime_11, lastmoderid_12,
lastmoddate_13, lastmodtime_14);
end;
/

 CREATE or REPLACE PROCEDURE HrmWorkResume_SByResourceID 
  (resourceid_1 varchar2 , 
  flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
open thecursor for 
 select * from HrmWorkResume where resourceid = to_number(resourceid_1) ;

 end;
/

CREATE or replace PROCEDURE HrmWorkResume_SelectByID 
(id_1 varchar2 ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from HrmWorkResume where id =to_number(id_1); 
end;
/

CREATE or replace PROCEDURE HrmWorkResume_Update 
(id_1 	integer,
resourceid_2 	integer,
startdate_3 	char,
enddate_4 	char,
company_5 	varchar2, 
companystyle_6 	integer, 
jobtitle_7 	varchar2,
workdesc_8 	varchar2, 
leavereason_9 	varchar2,
lastmoderid_13 	integer,
lastmoddate_14 	char,
lastmodtime_15 	char,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin 
update HrmWorkResume  SET  resourceid=resourceid_2, startdate=startdate_3, enddate=enddate_4,
company=company_5, companystyle=companystyle_6, jobtitle=jobtitle_7, workdesc=workdesc_8, 
leavereason=leavereason_9, lastmoderid=lastmoderid_13, lastmoddate=lastmoddate_14, 
lastmodtime=lastmodtime_15  WHERE ( id=id_1);
end;
/



 CREATE or REPLACE PROCEDURE HtmlLabelIndex_Insert 
	 (id_1		integer,
	 indexdesc_1	varchar2,
	 flag		out integer, 
	 msg		varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
	insert into HtmlLabelIndex
	(id,indexdesc)
	values
	( id_1, indexdesc_1);

 end;
/

 CREATE or REPLACE PROCEDURE HtmlLabelInfo_Insert 
	 (id_1		integer,
         labelname_1	varchar2,
	 langid_1		integer,
	 flag		out integer, 
	 msg		varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
	insert into HtmlLabelInfo 
	(indexid,labelname,languageid)
	values
	( id_1, labelname_1, langid_1);

 end;
/

CREATE or replace PROCEDURE ImageFile_DeleteByImagefileID
	(imagefileid_1 	integer ,
	 flag	out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)

AS 
begin
delete from ImageFile where imagefileid = imagefileid_1;
end;
/


CREATE or replace PROCEDURE LgcAssetAssortment_Delete 
(id_1 	integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
AS 
count_1 integer ;
supassortmentid_1 integer;
count_01 integer;
count_02 integer;
count_03 integer;
begin

select count(assetcount) INTO count_01 from LgcAssetAssortment where id = id_1; 
 if(count_01>0)then

select assetcount INTO count_1 from LgcAssetAssortment where id = id_1; 
end if;

if count_1 <> 0 then
open thecursor for
select -1 from dual;
return ;
end if;

select count(assetcount) INTO count_02 from LgcAssetAssortment where id = id_1; 
 if(count_02>0)then

select subassortmentcount INTO count_1  from LgcAssetAssortment where id = id_1;
end if;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return ;
end if;
select count(assetcount) INTO count_03 from LgcAssetAssortment where id = id_1; 
 if(count_03>0)then

select supassortmentid into supassortmentid_1 from LgcAssetAssortment where id= id_1;

end if;
update LgcAssetAssortment set subassortmentcount = subassortmentcount-1 where id= supassortmentid_1;
DELETE LgcAssetAssortment WHERE id = id_1; 
end;
/

 CREATE or replace PROCEDURE LgcAssetAssortment_Insert 
(assortmentmark_1 	varchar2, 
assortmentname_2 	varchar2, 
seclevel_3 	smallint,
resourceid_4 	integer, 
assortmentimageid_5 	integer,
assortmentremark_6 	varchar2,
supassortmentid_7 	integer, 
supassortmentstr_8 	varchar2,
dff01name_11 	varchar2, 
dff01use_12 	smallint,
dff02name_13 	varchar2, 
dff02use_14 	smallint, 
dff03name_15 	varchar2,
dff03use_16 	smallint,
dff04name_17 	varchar2,
dff04use_18 	smallint,
dff05name_19 	varchar2,
dff05use_20 	smallint,
nff01name_21 	varchar2,
nff01use_22 	smallint, 
nff02name_23 	varchar2,
nff02use_24 	smallint,
nff03name_25 	varchar2, 
nff03use_26 	smallint,
nff04name_27 	varchar2,
nff04use_28 	smallint, 
nff05name_29 	varchar2,
nff05use_30 	smallint,
tff01name_31 	varchar2,
tff01use_32 	smallint,
tff02name_33 	varchar2, 
tff02use_34 	smallint,
tff03name_35 	varchar2,
tff03use_36 	smallint,
tff04name_37 	varchar2,
tff04use_38 	smallint,
tff05name_39 	varchar2,
tff05use_40 	smallint, 
bff01name_41 	varchar2,
bff01use_42 	smallint, 
bff02name_43 	varchar2,
bff02use_44 	smallint, 
bff03name_45 	varchar2,
bff03use_46 	smallint,
bff04name_47 	varchar2,
bff04use_48 	smallint, 
bff05name_49 	varchar2,
bff05use_50 	smallint, 
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
count_1 integer;
count_01 integer;
begin
if supassortmentid_7 <>0  then /*上级类型不能有物品*/ 
select count(assetcount) INTO count_01 from LgcAssetAssortment where id = supassortmentid_7;
if(count_01>0)then
select assetcount INTO count_1 from LgcAssetAssortment where id = supassortmentid_7;
end if;


if count_1 <> 0 then
open thecursor for
select -1 from dual;
return;
end if;
UPDATE LgcAssetAssortment SET subassortmentcount=subassortmentcount+1 WHERE id = supassortmentid_7;
end if;
INSERT INTO LgcAssetAssortment ( assortmentmark, assortmentname, seclevel, resourceid,
assortmentimageid, assortmentremark, supassortmentid, supassortmentstr, subassortmentcount,
assetcount, dff01name, dff01use, dff02name, dff02use, dff03name, dff03use, dff04name, dff04use, 
dff05name, dff05use, nff01name, nff01use, nff02name, nff02use, nff03name, nff03use, nff04name, 
nff04use, nff05name, nff05use, tff01name, tff01use, tff02name, tff02use, tff03name, tff03use, 
tff04name, tff04use, tff05name, tff05use, bff01name, bff01use, bff02name, bff02use, bff03name,
bff03use, bff04name, bff04use, bff05name, bff05use)  VALUES ( assortmentmark_1, assortmentname_2,
seclevel_3, resourceid_4, assortmentimageid_5, assortmentremark_6, supassortmentid_7, 
supassortmentstr_8, 0, 0, dff01name_11, dff01use_12, dff02name_13, dff02use_14, dff03name_15, 
dff03use_16, dff04name_17, dff04use_18, dff05name_19, dff05use_20, nff01name_21, nff01use_22,
nff02name_23, nff02use_24, nff03name_25, nff03use_26, nff04name_27, nff04use_28, nff05name_29, 
nff05use_30, tff01name_31, tff01use_32, tff02name_33, tff02use_34, tff03name_35, tff03use_36,
tff04name_37, tff04use_38, tff05name_39, tff05use_40, bff01name_41, bff01use_42, bff02name_43,
bff02use_44, bff03name_45, bff03use_46, bff04name_47, bff04use_48, bff05name_49, bff05use_50);
open thecursor for
select max(id) from LgcAssetAssortment;
end;
/

 CREATE or REPLACE PROCEDURE LgcAssetAssortment_SSupAssort 
  (id_1 	integer,  
  flag out integer ,  
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
open thecursor for 
 select supassortmentstr from  LgcAssetAssortment  where id =  id_1 ;
 
 end;
/

CREATE or replace PROCEDURE LgcAssetAssortment_Select 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
select * from LgcAssetAssortment order by assortmentmark;
end;
/

CREATE or replace PROCEDURE LgcAssetAssortment_SelectByID 
(id_1 	integer,
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
open thecursor for
select * from LgcAssetAssortment where id = id_1;
end;
/

CREATE or replace PROCEDURE LgcAssetAssortment_SelectLeaf
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
select * from LgcAssetAssortment where subassortmentcount = 0;
end;
/

CREATE or replace PROCEDURE LgcAssetAssortment_Update
(id_1 	integer,
assortmentmark_2 	varchar2,
assortmentname_3 	varchar2,
seclevel_4 	smallint,
resourceid_5 	integer,
assortmentimageid_6 	integer,
assortmentremark_7 	varchar2,
supassortmentid_8 	integer,
supassortmentstr_9 	varchar2,
dff01name_12 	varchar2,
dff01use_13 	smallint,
dff02name_14 	varchar2,
dff02use_15 	smallint,
dff03name_16 	varchar2,
dff03use_17 	smallint,
dff04name_18 	varchar2,
dff04use_19 	smallint,
dff05name_20 	varchar2,
dff05use_21 	smallint,
nff01name_22 	varchar2,
nff01use_23 	smallint,
nff02name_24 	varchar2,
nff02use_25 	smallint,
nff03name_26 	varchar2,
nff03use_27 	smallint,
nff04name_28 	varchar2,
nff04use_29 	smallint,
nff05name_30 	varchar2,
nff05use_31 	smallint,
tff01name_32 	varchar2,
tff01use_33 	smallint,
tff02name_34 	varchar2,
tff02use_35 	smallint,
tff03name_36 	varchar2,
tff03use_37 	smallint,
tff04name_38 	varchar2,
tff04use_39 	smallint,
tff05name_40 	varchar2,
tff05use_41 	smallint,
bff01name_42 	varchar2,
bff01use_43 	smallint,
bff02name_44 	varchar2,
bff02use_45 	smallint,
bff03name_46 	varchar2,
bff03use_47 	smallint,
bff04name_48 	varchar2,
bff04use_49 	smallint,
bff05name_50 	varchar2,
bff05use_51 	smallint,
flag out	integer,
msg out		varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin 
update LgcAssetAssortment  SET  assortmentmark=assortmentmark_2, assortmentname=assortmentname_3,
seclevel=seclevel_4, resourceid=resourceid_5, assortmentimageid=assortmentimageid_6,
assortmentremark=assortmentremark_7, supassortmentid=supassortmentid_8, 
supassortmentstr=supassortmentstr_9, dff01name=dff01name_12, dff01use=dff01use_13, 
dff02name=dff02name_14, dff02use=dff02use_15, dff03name=dff03name_16, dff03use=dff03use_17, 
dff04name=dff04name_18, dff04use=dff04use_19, dff05name=dff05name_20, dff05use=dff05use_21,
nff01name=nff01name_22, nff01use=nff01use_23, nff02name=nff02name_24, nff02use=nff02use_25,
nff03name=nff03name_26, nff03use=nff03use_27, nff04name=nff04name_28, nff04use=nff04use_29, 
nff05name=nff05name_30, nff05use=nff05use_31, tff01name=tff01name_32, tff01use=tff01use_33, 
tff02name=tff02name_34, tff02use=tff02use_35, tff03name=tff03name_36, tff03use=tff03use_37, 
tff04name=tff04name_38, tff04use=tff04use_39, tff05name=tff05name_40, tff05use=tff05use_41, 
bff01name=bff01name_42, bff01use=bff01use_43, bff02name=bff02name_44, bff02use=bff02use_45, 
bff03name=bff03name_46, bff03use=bff03use_47, bff04name=bff04name_48, bff04use=bff04use_49, 
bff05name=bff05name_50, bff05use=bff05use_51  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcAssetAssortment_UpdatePic 
(id_1 	integer,
assortmentimageid_2     integer,
flag out	integer,
msg out		varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin
update LgcAssetAssortment set assortmentimageid = 0 where id = id_1;
delete ImageFile where imagefileid = assortmentimageid_2;
end;
/

CREATE or replace PROCEDURE LgcAssetCountry_Insert 
(assetid_1 	integer,
assetname_2 	varchar2, 
assetcountyid_3 	integer,
startdate_4 	char,
enddate_5 	char,
departmentid_6 	integer, 
resourceid_7 	integer, 
assetremark_8 	varchar2,
currencyid_9 	integer, 
salesprice_10 	in out varchar2,
costprice_11 	in out varchar2, 
datefield1_12 	char, 
datefield2_13 	char, 
datefield3_14 	char, 
datefield4_15 	char, 
datefield5_16 	char, 
numberfield1_17 	float,
numberfield2_18 	float, 
numberfield3_19 	float, 
numberfield4_20 	float,
numberfield5_21 	float,
textfield1_22 	varchar2,
textfield2_23 	varchar2, 
textfield3_24 	varchar2, 
textfield4_25 	varchar2, 
textfield5_26 	varchar2, 
tinyintfield1_27 	char,
tinyintfield2_28 	char,
tinyintfield3_29 	char, 
tinyintfield4_30 	char, 
tinyintfield5_31 	char, 
createrid_32 	integer,
createdate_33 	char, 
lastmoderid_34 	integer, 
lastmoddate_35 	char, 
isdefault_36 	char,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
count_1 integer;
begin
SELECT  count(*) into count_1 from LgcAssetCountry where assetid=assetid_1 
and assetcountyid=assetcountyid_3;
if count_1<>0 then
open thecursor for
select -1 from dual; 
return;
end if;
salesprice_10:= to_number(salesprice_10);
costprice_11:= to_number(costprice_11);
if isdefault_36 <>'0' then
update LgcAssetCountry SET isdefault='0' WHERE assetid = assetid_1;
end if;
INSERT INTO LgcAssetCountry ( assetid, assetname, assetcountyid, startdate, enddate, departmentid, 
resourceid, assetremark, currencyid, salesprice, costprice, datefield1, datefield2, datefield3,
datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5,
textfield1, textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, 
tinyintfield3, tinyintfield4, tinyintfield5, createrid, createdate, lastmoderid, lastmoddate,
isdefault)  VALUES ( assetid_1, assetname_2, assetcountyid_3, startdate_4, enddate_5, 
departmentid_6, resourceid_7, assetremark_8, currencyid_9, salesprice_10, costprice_11, 
datefield1_12, datefield2_13, datefield3_14, datefield4_15, datefield5_16, numberfield1_17,
numberfield2_18, numberfield3_19, numberfield4_20, numberfield5_21, textfield1_22, 
textfield2_23, textfield3_24, textfield4_25, textfield5_26, tinyintfield1_27, 
tinyintfield2_28, tinyintfield3_29, tinyintfield4_30, tinyintfield5_31, createrid_32,
createdate_33, lastmoderid_34, lastmoddate_35, isdefault_36);
end;
/


 CREATE or REPLACE PROCEDURE LgcAssetCountry_SByAssetID 
 ( id_1 	integer,
 flag out integer , 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from LgcAssetCountry where assetid =  id_1 ;
 end;
/

 CREATE or REPLACE PROCEDURE LgcAssetCountry_SSumByResource 
 ( id_1	 	integer,  
 flag	out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select count(id) from LgcAssetCountry where resourceid =  id_1; 

 end;
/

CREATE or replace PROCEDURE LgcAssetCountry_SelectByID
(id_1 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for
select * from  LgcAssetCountry where id = id_1;
end;
/

CREATE or replace PROCEDURE LgcAssetCrm_Delete 
(id_1 	integer, 
flag	out integer,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
delete LgcAssetCrm  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcAssetCrm_Insert 
(assetid_1 	integer, 
 crmid_2 	integer, 
 countryid_3 	integer,
 ismain_4 	char,
 assetcode_5 	char,
 currencyid_6 	integer,
 purchaseprice_7 in out	varchar2,
 taxrate_8 	integer,
 unitid_9 	integer, 
 packageunit_10 	varchar2,
 supplyremark_11 	varchar2,
 userid_12 in out integer,
 flag	out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
begin
purchaseprice_7:= to_number(purchaseprice_7);
if userid_12 = 0 then
userid_12:= null; 
end if; 
INSERT INTO LgcAssetCrm ( assetid, crmid, countryid, ismain, assetcode, currencyid, purchaseprice,
 taxrate, unitid, packageunit, supplyremark, docid)  VALUES ( assetid_1, crmid_2, countryid_3,
 ismain_4, assetcode_5, currencyid_6, purchaseprice_7, taxrate_8, unitid_9, packageunit_10,
 supplyremark_11, userid_12);
open thecursor for
select max(id) from LgcAssetCrm;
end;
/

CREATE or replace PROCEDURE LgcAssetCrm_SelectByAsset 
(assetid_1 integer, 
 type_1 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 open thecursor for 
 select a.id,a.crmid,a.countryid,a.purchaseprice,a.currencyid,a.ismain from LgcAssetCrm a,
CRM_CustomerInfo b where a.assetid = assetid_1 and  b.type=type_1 and a.crmid=b.id order by a.countryid;
end;
/

CREATE or replace PROCEDURE LgcAssetCrm_SelectByID
(id_1 	integer, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for 
select * from LgcAssetCrm where id = id_1;
end;
/

CREATE or replace PROCEDURE LgcAssetCrm_SelectType 
(assetid_1 integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
open thecursor for 
select type FROM CRM_CustomerInfo a ,LgcAssetCrm b where a.id = b.crmid
and b.assetid=assetid_1 group by type;
end;
/

 CREATE or replace PROCEDURE LgcAssetCrm_Update
(id_1 	integer, 
 assetid_2 	integer,
 crmid_3 	integer,
 countryid_4 	integer, 
 ismain_5 	char,
 assetcode_6 	char,
 currencyid_7 	integer,
 purchaseprice_8 in out	varchar2,
 taxrate_9 	integer,
 unitid_10 	integer,
 packageunit_11 	varchar2,
 supplyremark_12 	varchar2, 
 userid_13 in out integer, 
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
begin
 purchaseprice_8:= to_number(purchaseprice_8);
 if userid_13 = 0 then
 userid_13:= null;
 end if;
 UPDATE LgcAssetCrm  SET  assetid=assetid_2, crmid=crmid_3, countryid=countryid_4, 
 ismain=ismain_5, assetcode=assetcode_6, currencyid=currencyid_7, purchaseprice=purchaseprice_8, 
 taxrate=taxrate_9, unitid=unitid_10, packageunit=packageunit_11, supplyremark=supplyremark_12,
 docid=userid_13  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcAssetPrice_Delete
 (id_1  integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 open thecursor for
 select * from LgcAssetPrice where id=id_1;
 DELETE LgcAssetPrice  WHERE  id = id_1;
end;
/

 CREATE or replace PROCEDURE LgcAssetPrice_Insert
 (assetid_1 	integer,
 assetcountyid_2 	integer,
 pricedesc_3 	varchar2,
 numfrom_4  in out integer,
 numto_5  in out integer,
 currencyid_6 	integer,
 unitprice_7 in out varchar2,
 taxrate_8 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
  AS
begin
 if numfrom_4 = 0 then
 numfrom_4:= null;
 end if;
 if numto_5 = 0 then
 numto_5:= null;
 end if;
 unitprice_7:= to_number(unitprice_7);
 INSERT INTO LgcAssetPrice ( assetid, assetcountyid, pricedesc, numfrom, numto, currencyid, 
unitprice, taxrate)  VALUES ( assetid_1, assetcountyid_2, pricedesc_3, numfrom_4, numto_5, 
currencyid_6, unitprice_7, taxrate_8);
open thecursor for
select max(id) from LgcAssetPrice;
end;
/

CREATE or replace PROCEDURE LgcAssetPrice_Select
 ( assetid_1 integer,
 countryid_1  integer,
 assetcount_1  float ,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
 unitprice_1 number;
 taxrate_1 integer;
 currencyid_1 integer; 
cursor theprice_cursor is 
select unitprice,taxrate, currencyid from LgcAssetPrice where assetid = assetid_1 and
assetcountyid = countryid_1 and numfrom <= assetcount_1 and 
(numto >= assetcount_1 or numto=0 or numto is null);
begin
open theprice_cursor;
fetch theprice_cursor into unitprice_1 , taxrate_1, currencyid_1;
if theprice_cursor%found then
open thecursor for
select unitprice_1 , taxrate_1 , currencyid_1 from dual;
else 
open thecursor for
select salesprice , 0 , currencyid from LgcAssetCountry where assetid = assetid_1 and 
assetcountyid = countryid_1;
end if;

close theprice_cursor;
end;
/

CREATE or replace PROCEDURE LgcAssetPrice_SelectByAsset
(assetid_1 integer,
 assetcountryid_2 integer,
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
 begin
 open
 thecursor for 
 select * from LgcAssetPrice where assetid=assetid_1 and assetcountyid=assetcountryid_2;
end;
/

CREATE or replace PROCEDURE LgcAssetPrice_SelectById
(id_1 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 open thecursor for 
 select * from LgcAssetPrice where id=id_1;
 end;
/

CREATE or replace PROCEDURE LgcAssetPrice_Update 
(id_1 	integer, 
 pricedesc_4 	varchar2, 
 numfrom_5 in out	integer,
 numto_6  in out	integer,
 currencyid_7 	integer,
 unitprice_8 in out	varchar2,
 taxrate_9 	integer,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 if numfrom_5 = 0 then
 numfrom_5:= null;
 end if; 
 if numto_6 = 0 then
 numto_6 := null;
 end if;
 unitprice_8:= to_number(unitprice_8); 
UPDATE LgcAssetPrice  SET pricedesc=pricedesc_4, numfrom=numfrom_5, numto=numto_6, 
currencyid=currencyid_7, unitprice=unitprice_8, taxrate=taxrate_9  WHERE ( id=id_1);
open thecursor for
select * from LgcAssetPrice where id = id_1;
end;
/

CREATE or replace PROCEDURE LgcAssetRelationType_Delete 
(id_1 	integer,
 flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 AS
count_1 integer;
begin
select count(id) into count_1 from LgcConfiguration where relationtypeid = id_1;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return;
end if;
DELETE LgcAssetRelationType WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcAssetRelationType_Insert
 (typename_1 	varchar2,
 typedesc_2 	varchar2,
 typekind_3 	char,
 shopadvice_4 	char,
 contractlimit_5 	char,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 insert into LgcAssetRelationType ( typename, typedesc, typekind, shopadvice, contractlimit)  
VALUES ( typename_1, typedesc_2, typekind_3, shopadvice_4, contractlimit_5);
open thecursor for
select max(id) from LgcAssetRelationType;
end;
/


 CREATE or REPLACE PROCEDURE LgcAssetRelationType_SByID 
  (id_1 integer ,  
  flag out integer , 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select * from LgcAssetRelationType where id =  id_1;
 end;
/

CREATE or replace PROCEDURE LgcAssetRelationType_Select
(flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 open thecursor
 for select * from LgcAssetRelationType;
end;
/

CREATE or replace PROCEDURE LgcAssetRelationType_Update 
(id_1 	integer,
 typename_2 	varchar2,
 typedesc_3 	varchar2,
 typekind_4 	char,
 shopadvice_5 	char,
 contractlimit_6 	char,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
 begin
 update LgcAssetRelationType  SET  typename=typename_2, typedesc=typedesc_3, typekind=typekind_4,
 shopadvice=shopadvice_5, contractlimit=contractlimit_6  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcAssetStock_Delete 
(id_1 	integer,
 warehouseid_2 	integer,
 assetid_3 	integer,
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
count_1 integer;
inoutid_1 integer;
inoutdetailid_1 integer; 
count_01 integer;
begin
select count(*) into count_1 from LgcStockInOut a,LgcStockInOutDetail b
where a.warehouseid=warehouseid_2 and b.assetid=assetid_3 and a.id=b.inoutid 
and a.stockmodeid<>-2;
if count_1>0 then
open thecursor for
select -1 from dual;
return; 
end if;
DELETE LgcAssetStock   WHERE ( id = id_1);

select count(*) into count_01 from LgcStockInOut a,LgcStockInOutDetail b 
where a.warehouseid=warehouseid_2 and b.assetid=assetid_3 and a.id=b.inoutid;
if count_01>0 then

open thecursor for
select a.id,b.id into inoutid_1,inoutdetailid_1 from LgcStockInOut a,LgcStockInOutDetail b 
where a.warehouseid=warehouseid_2 and b.assetid=assetid_3 and a.id=b.inoutid;
end if;
DELETE LgcStockInOut   WHERE ( id = inoutid_1);
DELETE LgcStockInOutDetail   WHERE ( id = inoutdetailid_1);
end;
/

CREATE or replace PROCEDURE LgcAssetStock_EditOrView
 ( assetid_3 	integer,
 warehouseid_2 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
  AS 
count_1 integer;
begin
select count(*) into count_1 from LgcStockInOut a,LgcStockInOutDetail b 
where a.warehouseid=warehouseid_2 and b.assetid=assetid_3 and a.id=b.inoutid and a.stockmodeid<>-2; 
if count_1>0 then
open thecursor for
select -1 from dual;
return;
else 
open thecursor for
select  1 from dual
return;
end if;
end;
/

 CREATE or replace PROCEDURE LgcAssetStock_Insert 
 (warehouseid_1 	integer,
 assetid_2 	integer, 
 stocknum_3 	float,
 unitprice_4  IN out	varchar2, 
 trandefcurrencyid_1 integer, 
 currencyid_1       integer,
 exchangerate_1 in out varchar2, 
 flag	out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS  
 count_1 integer;
 maxid_1 integer;
 temp_1 number;
 begin
 select count(*) INTO count_1  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=warehouseid_1
 and b.assetid=assetid_2 and a.id=b.inoutid; 
 if count_1>0 then
 open thecursor for
 select -1 from dual;
 return;
 end if; 
 unitprice_4:= to_number(unitprice_4);
 exchangerate_1:= to_number(exchangerate_1);
 temp_1:=to_number(unitprice_4);  
 INSERT INTO LgcAssetStock ( warehouseid, assetid, stocknum, unitprice)  VALUES
 ( warehouseid_1, assetid_2, stocknum_3, unitprice_4); 
 INSERT INTO LgcStockInOut ( warehouseid, stockmodeid, currencyid, defcurrencyid, exchangerate, 
 defcountprice, countprice)  VALUES ( warehouseid_1, -2, currencyid_1, trandefcurrencyid_1, 
 exchangerate_1, stocknum_3*temp_1/exchangerate_1, stocknum_3*unitprice_4);  
 select max(id) into maxid_1 from LgcStockInOut;  
 INSERT INTO LgcStockInOutDetail ( inoutid, assetid, number_n, currencyid, defcurrencyid, exchangerate,
 defunitprice, unitprice)  VALUES ( maxid_1, assetid_2, stocknum_3, currencyid_1, trandefcurrencyid_1,
 exchangerate_1, temp_1/exchangerate_1, unitprice_4);  
 open thecursor for
 select max(id) from LgcAssetStock;
 end;
/

CREATE or replace PROCEDURE LgcAssetStock_SelectByAsset 
(assetid_1 integer, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
select id,warehouseid,stocknum,unitprice,stocknum*unitprice unitpriceall from LgcAssetStock
where assetid = assetid_1;
end;
/

CREATE or replace PROCEDURE LgcAssetStock_SelectByID
 (id_1 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 open thecursor for
 select * from LgcAssetStock where id = id_1;
end;
/

 CREATE or replace PROCEDURE LgcAssetStock_Update 
(id_1 	integer,
 warehouseid_2 	integer,
 assetid_3 	integer, 
 stocknum_4 	float, 
 unitprice_5  in out  varchar2, 
 trandefcurrencyid_1 integer,
 currencyid_1       integer,
 exchangerate_1 varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
count_1 integer;
inoutid_1 integer;
inoutdetailid_1 integer;
temp_1 number;
begin
unitprice_5:= to_number(unitprice_5);  
temp_1:= unitprice_5; 
select count(*) into count_1 from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=warehouseid_2
and b.assetid=assetid_3 and a.id=b.inoutid and a.stockmodeid<>-2;
if count_1>0 then
open thecursor for
select -1 from dual;
return;
end if;
UPDATE LgcAssetStock  SET  warehouseid=warehouseid_2, assetid=assetid_3, stocknum=stocknum_4, 
unitprice= unitprice_5  WHERE ( id= id_1);
select a.id,b.id into inoutid_1,inoutdetailid_1 from LgcStockInOut a,LgcStockInOutDetail b 
where a.warehouseid=warehouseid_2 and b.assetid=assetid_3 and a.id=b.inoutid;
UPDATE LgcStockInOut  SET  warehouseid= warehouseid_2, currencyid= currencyid_1, 
defcurrencyid=trandefcurrencyid_1, exchangerate= exchangerate_1, 
defcountprice = stocknum_4*unitprice_5/exchangerate_1, countprice= stocknum_4*unitprice_5
WHERE ( id= inoutid_1);
UPDATE LgcStockInOutDetail  SET number_n = stocknum_4, currencyid= currencyid_1, 
defcurrencyid = trandefcurrencyid_1, exchangerate= exchangerate_1, defunitprice = temp_1/exchangerate_1, 
unitprice= unitprice_5 WHERE ( id= inoutdetailid_1);
end;
/

CREATE or replace PROCEDURE LgcAssetType_Delete 
(id_1 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 count_1 integer;
 begin
 select count(id) into count_1 from LgcAsset where assettypeid = id_1;
 if count_1 <> 0 then
 open thecursor for
 select -1 from dual; 
 return; 
 end if;
DELETE LgcAssetType WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcAssetType_Insert 
(typemark_1 	varchar2,
 typename_2 	varchar2,
 typedesc_3 	varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 as
 begin
insert into LgcAssetType ( typemark, typename, typedesc) VALUES(typemark_1, typename_2, typedesc_3);
open thecursor for
select max(id) from LgcAssetType;
end;
/


CREATE or replace PROCEDURE LgcAssetType_Select
(flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 open thecursor for
 select * from LgcAssetType;
end;
/

CREATE or replace PROCEDURE LgcAssetType_SelectByID 
(id_1  integer, 
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 open thecursor for
 select * from LgcAssetType  where id = id_1;
 end;
/

CREATE or replace PROCEDURE LgcAssetType_Update
(id_1 	integer, 
 typemark_2 	varchar2,
 typename_3 	varchar2,
 typedesc_4 	varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
update LgcAssetType  SET  typemark=typemark_2, typename=typename_3, typedesc=typedesc_4  
WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcAssetUnit_Delete 
(id_1 	integer,
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 count_1 integer ;
begin
select count(id) into count_1 from LgcAsset where assetunitid = id_1 ;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return;
end if;
DELETE LgcAssetUnit WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcAssetUnit_Insert 
(unitmark_1 	varchar2,
 unitname_2 	varchar2,
 unitdesc_3 	varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
as 
begin 
insert into LgcAssetUnit ( unitmark, unitname, unitdesc)  
VALUES ( unitmark_1, unitname_2, unitdesc_3);
open thecursor for
select max(id) from LgcAssetUnit;
end;
/

CREATE or replace PROCEDURE LgcAssetUnit_Select
(flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for select * from LgcAssetUnit;
end;
/

CREATE or replace PROCEDURE LgcAssetUnit_SelectByID
(id_1  integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin open thecursor for
 select * from LgcAssetUnit  where id = id_1;
end;
/

 CREATE or replace PROCEDURE LgcAssetUnit_Update
 (id_1 	integer,
 unitmark_2 	varchar2,
 unitname_3 	varchar2,
 unitdesc_4 	varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
  as 
begin 
update LgcAssetUnit SET unitmark=unitmark_2,unitname=unitname_3,unitdesc=unitdesc_4 WHERE (id=id_1);
end;
/

CREATE or replace PROCEDURE LgcAsset_Delete 
(id_1 	integer,
 assetcountryid_2 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
isdefault_1 char(1);
isdefault_count integer;
begin
select count(isdefault) into isdefault_count from LgcAssetCountry where assetid=id_1 and assetcountyid = assetcountryid_2;
if isdefault_count>0 then


select isdefault into isdefault_1 from LgcAssetCountry where assetid=id_1 and assetcountyid = assetcountryid_2;
end if;
if isdefault_1='1' then
open thecursor for 
select -1 from dual;
return;
end if;
DELETE LgcAssetCountry  WHERE assetid=id_1 and assetcountyid = assetcountryid_2;
end;
/

 CREATE or replace PROCEDURE LgcAsset_Insert 
(assetmark_1 	varchar2,
 barcode_2 	varchar2,
 seclevel_3 	smallint, 
 assetimageid_4 	integer,
 assettypeid_5 	integer, 
 assetunitid_6 	integer,
 replaceassetid_7 	integer, 
 assetversion_8 	varchar2,
 assetattribute_9 	varchar2,
 counttypeid_10 	integer,
 assortmentid_11 	integer,
 assortmentstr_12 	varchar2,
 relatewfid_1   integer,
 assetname_2 	varchar2,
 assetcountyid_3 	integer,
 startdate_4 	char,
 enddate_5 	char,
 departmentid_6 	integer,
 resourceid_7 	integer,
 assetremark_8 	varchar2,
 currencyid_9 	integer,
 salesprice_10 in out	varchar2,
 costprice_11 	in out  varchar2,
 datefield1_12 	char,
 datefield2_13 	char,
 datefield3_14 	char,
 datefield4_15 	char,
 datefield5_16 	char,
 numberfield1_17 	float,
 numberfield2_18 	float,
 numberfield3_19 	float,
 numberfield4_20 	float,
 numberfield5_21 	float,
 textfield1_22 	varchar2,
 textfield2_23 	varchar2,
 textfield3_24 	varchar2,
 textfield4_25 	varchar2,
 textfield5_26 	varchar2,
 tinyintfield1_27 	char,
 tinyintfield2_28 	char,
 tinyintfield3_29 	char,
 tinyintfield4_30 	char,
 tinyintfield5_31 	char,
 createrid_32 		integer,
 createdate_33 	char,
 flag	out		integer,
 msg out		varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 

count_1 integer;
assetid_1 integer;
begin
salesprice_10:= to_number(salesprice_10);
costprice_11:= to_number(costprice_11);

select count(*) into count_1 from LgcAsset where assetmark = assetmark_1;
if count_1<> 0 then
open thecursor for
select -1 from dual;
return;
end if;
INSERT INTO LgcAsset ( assetmark, barcode, seclevel, assetimageid, assettypeid, assetunitid,
replaceassetid, assetversion, assetattribute, counttypeid, assortmentid, assortmentstr, relatewfid)
VALUES ( assetmark_1, barcode_2, seclevel_3, assetimageid_4, assettypeid_5, assetunitid_6, 
replaceassetid_7, assetversion_8, assetattribute_9, counttypeid_10, assortmentid_11,
assortmentstr_12, relatewfid_1);

select max(id) into assetid_1 from LgcAsset;

INSERT INTO LgcAssetCountry ( assetid, assetname, assetcountyid, startdate, enddate, departmentid,
 resourceid, assetremark, currencyid, salesprice, costprice, datefield1, datefield2, datefield3, 
 datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5,
 textfield1, textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2,
 tinyintfield3, tinyintfield4, tinyintfield5, createrid, createdate, lastmoderid, lastmoddate, 
 isdefault)  VALUES ( assetid_1, assetname_2, assetcountyid_3, startdate_4, enddate_5,
 departmentid_6, resourceid_7, assetremark_8, currencyid_9, salesprice_10, costprice_11, 
 datefield1_12, datefield2_13, datefield3_14, datefield4_15, datefield5_16, numberfield1_17,
 numberfield2_18, numberfield3_19, numberfield4_20, numberfield5_21, textfield1_22,
 textfield2_23, textfield3_24, textfield4_25, textfield5_26, tinyintfield1_27,
 tinyintfield2_28, tinyintfield3_29, tinyintfield4_30, tinyintfield5_31, createrid_32,
 createdate_33, createrid_32, createdate_33, '1');
 update LgcAssetAssortment set assetcount = assetcount+1 where id= assortmentid_11;
open thecursor for
 select max(id) from LgcAsset;
end;
/

CREATE or replace PROCEDURE LgcAsset_SelectAll 
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 AS 
begin
open thecursor for 
select * from LgcAsset , LgcAssetCountry where LgcAsset.id = LgcAssetCountry.assetid 
and isdefault ='1';
end;
/

CREATE or replace PROCEDURE LgcAsset_SelectByAssortment 
(assortmentid_1	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
 open thecursor for 
 select LgcAsset.id , assetmark,assetname,assettypeid,seclevel from LgcAsset , LgcAssetCountry 
 where LgcAsset.id = LgcAssetCountry.assetid and isdefault ='1' and assortmentid = assortmentid_1;
end;
/

CREATE or replace PROCEDURE LgcAsset_SelectById 
( id_1 integer,
 assetcountryid_1 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS  
begin
if assetcountryid_1<>-1 then
open thecursor for
select * from LgcAsset , LgcAssetCountry where LgcAsset.id = id_1 
and LgcAssetCountry.assetid = id_1 and LgcAssetCountry.assetcountyid = assetcountryid_1;
else
open thecursor for
select * from LgcAsset , LgcAssetCountry where LgcAsset.id = id_1 
and LgcAssetCountry.assetid = id_1 and isdefault ='1';
end if;
end;
/

CREATE or replace PROCEDURE LgcAsset_SelectSumByAssetType
(flag	out integer,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for
select assettypeid  resultid, COUNT(id) resultcount from LgcAsset group by assettypeid 
order by  resultcount desc;
end;
/

CREATE or replace PROCEDURE LgcAsset_SelectSumByAssortment 
(flag	out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
open thecursor for
select assortmentid AS resultid, COUNT(id) AS resultcount from LgcAsset group by assortmentid
  order by  resultcount desc;
end;
/

CREATE or replace PROCEDURE LgcAsset_SelectSumByConfigue 
(flag	out integer,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as 
begin
open thecursor for 
select relationtypeid AS resultid, COUNT(id) AS resultcount from LgcConfiguration  
group by relationtypeid  order by  resultcount desc;
end;
/

CREATE or replace PROCEDURE LgcAsset_SelectSumByDepartment 
(flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as
begin 
open thecursor for
select departmentid AS resultid, COUNT(id) AS resultcount from LgcAssetCountry 
where departmentid !=0 group by departmentid  order by  resultcount desc;
end;
/

CREATE or replace PROCEDURE LgcAsset_SelectSumByResource 
(flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select resourceid AS resultid, COUNT(id) AS resultcount from LgcAssetCountry 
where resourceid !=0 group by resourceid  order by  resultcount desc;
end;
/

CREATE or replace PROCEDURE LgcAsset_Update 
(id_1 	integer,
 assetcountryid_2 in out integer,
 barcode_3 	varchar2,
 seclevel_4 	smallint,
 assetimageid_5 	integer,
 assettypeid_6 	integer,
 assetunitid_7 	integer, 
 replaceassetid_8 	integer,
 assetversion_9 	varchar2,
 assetattribute_10 	varchar2,
 counttypeid_11 	integer,
 assortmentid_12 	integer,
 assortmentstr_13 	varchar2,
 relatewfid_1    integer,
 assetname_2 	varchar2,
 assetcountyid_3 	integer,
 startdate_4 	char,
 enddate_5 	char,
 departmentid_6 	integer,
 resourceid_7 	integer,
 assetremark_8 	varchar2,
 currencyid_9 	integer,
 salesprice_10 in out	varchar2,
 costprice_11 in out	varchar2, 
 datefield1_12 	char,
 datefield2_13 	char,
 datefield3_14 	char,
 datefield4_15 	char,
 datefield5_16 	char,
 numberfield1_17 	float,
 numberfield2_18 	float,
 numberfield3_19 	float,
 numberfield4_20 	float,
 numberfield5_21 	float,
 textfield1_22 	varchar2,
 textfield2_23 	varchar2,
 textfield3_24 	varchar2,
 textfield4_25 	varchar2,
 textfield5_26 	varchar2,
 tinyintfield1_27 	char,
 tinyintfield2_28 	char,
 tinyintfield3_29 	char,
 tinyintfield4_30 	char,
 tinyintfield5_31 	char,
 lastmoderid_32 	integer,
 lastmoddate_33 	char,
 isdefault_1 		char,
 flag	out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
begin
salesprice_10:= to_number(salesprice_10);
costprice_11:= to_number(costprice_11);
UPDATE LgcAsset SET  relatewfid = relatewfid_1, barcode=barcode_3, seclevel=seclevel_4, 
assetimageid=assetimageid_5, assettypeid=assettypeid_6, assetunitid=assetunitid_7,
replaceassetid=replaceassetid_8, assetversion=assetversion_9, assetattribute=assetattribute_10,
counttypeid=counttypeid_11, assortmentid=assortmentid_12, assortmentstr=assortmentstr_13 
WHERE ( id=id_1);
if  assetcountryid_2=-1 then
select assetcountyid into assetcountryid_2 from LgcAssetCountry where assetid=id_1 and isdefault='1';
end if; 
if  isdefault_1='1' then
update LgcAssetCountry set isdefault='0' where assetid=id_1;
end if;
UPDATE LgcAssetCountry SET  assetname=assetname_2, assetcountyid = assetcountyid_3, 
startdate=startdate_4, enddate=enddate_5, departmentid=departmentid_6, resourceid=resourceid_7,
assetremark=assetremark_8, currencyid=currencyid_9, salesprice=salesprice_10, 
costprice=costprice_11, datefield1=datefield1_12, datefield2=datefield2_13,
datefield3=datefield3_14, datefield4=datefield4_15, datefield5=datefield5_16,
numberfield1=numberfield1_17, numberfield2=numberfield2_18, numberfield3=numberfield3_19, 
numberfield4=numberfield4_20, numberfield5=numberfield5_21, textfield1=textfield1_22, 
textfield2=textfield2_23, textfield3=textfield3_24, textfield4=textfield4_25,
textfield5=textfield5_26, tinyintfield1 = tinyintfield1_27, tinyintfield2 = tinyintfield2_28, 
tinyintfield3 = tinyintfield3_29, tinyintfield4 = tinyintfield4_30, 
tinyintfield5 = tinyintfield5_31, lastmoderid=lastmoderid_32, lastmoddate=lastmoddate_33 ,
isdefault= isdefault_1  WHERE ( (assetid = id_1) and (assetcountyid =assetcountryid_2));
end;
/

CREATE or replace PROCEDURE LgcAsset_UpdatePic 
(id_1 	integer,
 assetimageid_2     integer,
 flag	out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
as 
begin
update LgcAsset set assetimageid = 0 where id = id_1;
delete ImageFile where imagefileid = assetimageid_2;
end;
/

CREATE or replace PROCEDURE LgcAssetmark_Change 
(assetid_1	integer,
 assetmark_1  varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
count_1 integer;
begin
select count(id) into count_1 from LgcAsset where assetmark = assetmark_1;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return;
end if;
update LgcAsset set assetmark = assetmark_1 where id = assetid_1;
end;
/

 CREATE or replace PROCEDURE LgcAssortmentMove_ChgCount 
(assortmentid1_1	integer,
 assortmentid2_1  integer,
 countid_1  integer, 
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
update LgcAssetAssortment set assetcount = assetcount-countid_1 where id=assortmentid1_1 ;
update LgcAssetAssortment set assetcount = assetcount+countid_1 where id=assortmentid2_1;
end;
/


CREATE or replace PROCEDURE LgcAssortmentMove_Move 
(assortmentid_1		integer,
 assetid_1		integer, 
flag out		integer , 
msg out			varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
supassortmentstr_1 varchar2(200);
supassortmentstr_count integer;
begin
 select count(supassortmentstr) into supassortmentstr_count from LgcAssetAssortment where id =  assortmentid_1;
if supassortmentstr_count>0 then

 select supassortmentstr into supassortmentstr_1 from LgcAssetAssortment where id =  assortmentid_1;
 end if;
 supassortmentstr_1 :=  concat(concat(supassortmentstr_1 , to_char(assortmentid_1)) , '|');
 
 update LgcAsset set assortmentid =  assortmentid_1 , assortmentstr =  supassortmentstr_1 where id =  assetid_1; 
 end;
/

CREATE or replace PROCEDURE LgcAttributeMove_Add 
(assortmentid_1 	integer, 
selectedattr_1  varchar2 ,
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
assetattribute_x varchar2(100);
CURSOR  xx is 
select assetattribute from LgcAsset where assortmentid = assortmentid_1 and assetattribute not like '%'||selectedattr_1||'%';
begin
open xx;
fetch xx into assetattribute_x;
while xx%found loop
update LgcAsset set assetattribute = assetattribute_x || selectedattr_1;
DBMS_OUTPUT.PUT_LINE(TO_CHAR(xx%ROWCOUNT));
fetch xx into assetattribute_x;
end loop;
close xx;
end;
/

CREATE or replace PROCEDURE LgcAttributeMove_Remove
 (assortmentid_1 	integer,
 selectedattr_1  varchar2 , 
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
update LgcAsset set assetattribute = replace(assetattribute,selectedattr_1,'')
where assortmentid = assortmentid_1;
open thecursor for
select count(id) ROWCOUNT from LgcAsset where assortmentid = assortmentid_1;
end;
/

CREATE or replace PROCEDURE LgcCatalogs_Delete 
(id_1 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
delete LgcCatalogs  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcCatalogs_Insert 
(catalogname_1 	varchar2, 
catalogdesc_2 	varchar2, 
catalorder_3 	integer, 
perpage_4 	integer, 
seclevelfrom_5 	smallint, 
seclevelto_6 	smallint,
navibardsp_7 	char,
navibarbgcolor_8 	char,
navibarfontcolor_9 	char,
navibarfontsize_10 	varchar2, 
navibarfonttype_11 	varchar2,
toolbardsp_12 	char,
toolbarwidth_13 	integer,
toolbarbgcolor_14 	char, 
toolbarfontcolor_15 	char, 
toolbarlinkbgcolor_16 	char,
toolbarlinkfontcolor_17 	char,
toolbarfontsize_18 	varchar2,
toolbarfonttype_19 	varchar2,
countrydsp_20 	char, 
countrydeftype_21 	char, 
countryid_22 	integer, 
searchbyname_23 	char,
searchbycrm_24 	char,
searchadv_25 	char,
assortmentdsp_26 	char, 
assortmentname_27 	varchar2, 
assortmentsql_28 	varchar2, 
attributedsp_29 	char, 
attributecol_30 	integer, 
attributefontsize_31 	varchar2, 
attributefonttype_32 	varchar2, 
assetsql_33 	varchar2, 
assetcol1_34 	varchar2, 
assetcol2_35 	varchar2, 
assetcol3_36 	varchar2, 
assetcol4_37 	varchar2, 
assetcol5_38 	varchar2, 
assetcol6_39 	varchar2, 
assetfontsize_40 	varchar2, 
assetfonttype_41 	varchar2, 
webshopdap_42 	char, 
webshoptype_43 	char, 
webshopreturn_44 	char, 
webshopmanageid_45 	integer, 
createrid_46 	integer, 
createdate_47 	char, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
insert into LgcCatalogs ( catalogname, catalogdesc, catalogorder, perpage, seclevelfrom, seclevelto, 
navibardsp, navibarbgcolor, navibarfontcolor, navibarfontsize, navibarfonttype, toolbardsp, 
toolbarwidth, toolbarbgcolor, toolbarfontcolor, toolbarlinkbgcolor, toolbarlinkfontcolor, 
toolbarfontsize, toolbarfonttype, countrydsp, countrydeftype, countryid, searchbyname, searchbycrm,
 searchadv, assortmentdsp, assortmentname, assortmentsql, attributedsp, attributecol, 
attributefontsize, attributefonttype, assetsql, assetcol1, assetcol2, assetcol3, assetcol4,
 assetcol5, assetcol6, assetfontsize, assetfonttype, webshopdap, webshoptype, webshopreturn, 
webshopmanageid, createrid, createdate)  VALUES ( catalogname_1, catalogdesc_2, catalorder_3,
 perpage_4, seclevelfrom_5, seclevelto_6, navibardsp_7, navibarbgcolor_8, navibarfontcolor_9,
 navibarfontsize_10, navibarfonttype_11, toolbardsp_12, toolbarwidth_13, toolbarbgcolor_14,
 toolbarfontcolor_15, toolbarlinkbgcolor_16, toolbarlinkfontcolor_17, toolbarfontsize_18, 
toolbarfonttype_19, countrydsp_20, countrydeftype_21, countryid_22, searchbyname_23, 
searchbycrm_24, searchadv_25, assortmentdsp_26, assortmentname_27, assortmentsql_28, 
attributedsp_29, attributecol_30, attributefontsize_31, attributefonttype_32, assetsql_33,
 assetcol1_34, assetcol2_35, assetcol3_36, assetcol4_37, assetcol5_38, assetcol6_39, 
assetfontsize_40, assetfonttype_41, webshopdap_42, webshoptype_43, webshopreturn_44, 
webshopmanageid_45, createrid_46, createdate_47);
open thecursor for
select max(id) from LgcCatalogs;
end;
/

 CREATE or REPLACE PROCEDURE LgcCatalogs_SDefaultByUser 
 ( userseclevel_1  integer ,
 flag out integer , 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
 catalogid_1 integer ;
 cursor catalogid_cursor is
 select id from LgcCatalogs where seclevelfrom <=  userseclevel_1 and seclevelto >=  userseclevel_1 order by catalogorder ; 
begin 

open catalogid_cursor;
fetch catalogid_cursor into catalogid_1;

open thecursor for 
select catalogid_1  from dual; 


close catalogid_cursor; 
end;
/

CREATE or replace PROCEDURE LgcCatalogs_Select 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for 
select id,catalogname,catalogdesc,catalogorder,seclevelfrom,seclevelto from LgcCatalogs;
end;
/

 CREATE or replace PROCEDURE LgcCatalogs_SelectByID
(id_1  integer,
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
open thecursor for
 select * from LgcCatalogs where id= id_1;
end;
/

CREATE or replace PROCEDURE LgcCatalogs_SelectByUser 
(userseclevel_1  integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
  as 
begin 
open thecursor for 
select id,catalogname,navibarbgcolor from LgcCatalogs where seclevelfrom <= userseclevel_1 
and seclevelto >= userseclevel_1;
end;
/


CREATE or replace PROCEDURE LgcCatalogs_Update 
(id_1 	integer, 
 catalogname_2 	varchar2, 
 catalogdesc_3 	varchar2, 
 catalorder_4 	integer,
 perpage_5 	integer, 
 seclevelfrom_6 	smallint,
 seclevelto_7 	smallint, 
 navibardsp_8 	char, 
 navibarbgcolor_9 	char,  
 navibarfontcolor_10 	char, 
 navibarfontsize_11 	varchar2,
 navibarfonttype_12 	varchar2,
 toolbardsp_13 	char, 
 toolbarwidth_14 	integer,
 toolbarbgcolor_15 	char, 
 toolbarfontcolor_16 	char, 
 toolbarlinkbgcolor_17 	char, 
 toolbarlinkfontcolor_18 	char, 
 toolbarfontsize_19 	varchar2, 
 toolbarfonttype_20 	varchar2, 
 countrydsp_21 	char, 
 countrydeftype_22 	char,
 countryid_23 	integer, 
 searchbyname_24 	char,
 searchbycrm_25 	char,
 searchadv_26 	char,
 assortmentdsp_27 	char,
 assortmentname_28 	varchar2,
 assortmentsql_29 	varchar2,
 attributedsp_30 	char,
 attributecol_31 	integer,
 attributefontsize_32 	varchar2,
 attributefonttype_33 	varchar2,
 assetsql_34 	varchar2,
 assetcol1_35 	varchar2,
 assetcol2_36 	varchar2,
 assetcol3_37 	varchar2,
 assetcol4_38 	varchar2,
 assetcol5_39 	varchar2,
 assetcol6_40 	varchar2,
 assetfontsize_41 	varchar2,
 assetfonttype_42 	varchar2,
 webshopdap_43 	char,
 webshoptype_44 	char,
 webshopreturn_45 	char,
 webshopmanageid_46 	integer,
 lastmoderid_47 	integer,
 lastmoddate_48 	char,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as begin update LgcCatalogs  SET  catalogname=catalogname_2, catalogdesc=catalogdesc_3,
 catalogorder=catalorder_4, perpage=perpage_5, seclevelfrom=seclevelfrom_6,
 seclevelto=seclevelto_7, navibardsp=navibardsp_8, navibarbgcolor=navibarbgcolor_9,
 navibarfontcolor=navibarfontcolor_10, navibarfontsize=navibarfontsize_11,
 navibarfonttype=navibarfonttype_12, toolbardsp=toolbardsp_13, toolbarwidth=toolbarwidth_14,
 toolbarbgcolor=toolbarbgcolor_15, toolbarfontcolor=toolbarfontcolor_16,
 toolbarlinkbgcolor=toolbarlinkbgcolor_17, toolbarlinkfontcolor=toolbarlinkfontcolor_18,
 toolbarfontsize=toolbarfontsize_19, toolbarfonttype=toolbarfonttype_20,
 countrydsp=countrydsp_21, countrydeftype=countrydeftype_22, countryid=countryid_23,
 searchbyname=searchbyname_24, searchbycrm=searchbycrm_25, searchadv=searchadv_26,
 assortmentdsp=assortmentdsp_27, assortmentname=assortmentname_28,
 assortmentsql=assortmentsql_29, attributedsp=attributedsp_30, attributecol=attributecol_31,
 attributefontsize=attributefontsize_32, attributefonttype=attributefonttype_33,
 assetsql=assetsql_34, assetcol1=assetcol1_35, assetcol2=assetcol2_36, assetcol3=assetcol3_37,
 assetcol4=assetcol4_38, assetcol5=assetcol5_39, assetcol6=assetcol6_40,
 assetfontsize=assetfontsize_41, assetfonttype=assetfonttype_42, webshopdap=webshopdap_43,
 webshoptype=webshoptype_44, webshopreturn=webshopreturn_45,
 webshopmanageid=webshopmanageid_46, lastmoderid=lastmoderid_47, 
 lastmoddate=lastmoddate_48  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcConfiguration_Delete 
(id_1 	integer,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )
 as 
begin 
delete LgcConfiguration  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcConfiguration_Insert 
(supassetid_1 	integer,
 subassetid_2 	integer,
 relationtypeid_3 	integer,
 flag out integer, msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )
  AS 
begin
 if supassetid_1=subassetid_2 then
 open thecursor for
 select -1 from dual;
 return; 
 end if;
 INSERT INTO LgcConfiguration ( supassetid, subassetid, relationtypeid)  
 VALUES ( supassetid_1, subassetid_2, relationtypeid_3);
end;
/

 CREATE or REPLACE PROCEDURE LgcConfiguration_SByWebshop 
 ( assetid_1  integer , 
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
 select subassetid,typename from LgcConfiguration ,  LgcAssetRelationType where supassetid =  assetid_1 and relationtypeid = LgcAssetRelationType.id and shopadvice ='1' ;
 
 end;
/

CREATE or replace PROCEDURE LgcConfiguration_Select
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as begin open thecursor for select * from LgcConfiguration;
end;
/

 CREATE or replace PROCEDURE LgcConfiguration_SelectByAsset 
( id_1 integer,
 direction_1 char,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
begin
if direction_1='1' then
open thecursor for
select * from LgcConfiguration 
where subassetid=id_1;
else 
open thecursor for
select * from LgcConfiguration where supassetid=id_1;
end if;
end;
/

CREATE or replace PROCEDURE LgcConfiguration_SelectById 
( id_1 integer, 
flag out integer , 
msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for
 select * from LgcConfiguration where id=id_1;
end;
/

CREATE or replace PROCEDURE LgcConfiguration_Update
 (id_1 	integer, 
 supassetid_2 	integer,
 subassetid_3 	integer,
 relationtypeid_4 	integer, 
 flag out integer, 
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 if supassetid_2=subassetid_3 then
open thecursor for
select -1 from dual;
return;
end if;  
UPDATE LgcConfiguration  SET  supassetid=supassetid_2, subassetid=subassetid_3, 
relationtypeid=relationtypeid_4  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcCountType_Delete 
(id_1 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
count_1 integer; 
begin
select count(id) into count_1 from LgcAsset where counttypeid = id_1;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return; 
end if;
DELETE LgcCountType WHERE  ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcCountType_Insert 
(typename_1 	varchar2, 
 typedesc_2 	varchar2,
 salesinid_3 	integer,
 salescostid_4 	integer,
 salestaxid_5 	integer,
 purchasetaxid_6 	integer,
 stockid_7 	integer,
 stockdiffid_8 	integer,
 producecostid_9 	int ,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
insert into LgcCountType ( typename, typedesc, salesinid, salescostid, salestaxid, purchasetaxid,
stockid, stockdiffid, producecostid)  VALUES ( typename_1, typedesc_2, salesinid_3, salescostid_4,
salestaxid_5, purchasetaxid_6, stockid_7, stockdiffid_8, producecostid_9);
open thecursor for
select max(id) from LgcCountType;
end;
/

 CREATE or replace PROCEDURE LgcCountType_Select
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for 
select * from LgcCountType;
end;
/

CREATE or replace PROCEDURE LgcCountType_SelectByID
(id_1  integer,
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for
 select * from LgcCountType  where id = id_1;
end;
/

 CREATE or replace PROCEDURE LgcCountType_Update 
(id_1 	integer, 
typename_2 	varchar2, 
typedesc_3 	varchar2, 
salesinid_4 	integer, 
salescostid_5 	integer, 
salestaxid_6 	integer, 
purchasetaxid_7 	integer, 
stockid_8 	integer, 
stockdiffid_9 	integer, 
producecostid_10 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
update LgcCountType  SET  typename=typename_2, typedesc=typedesc_3, salesinid=salesinid_4, 
salescostid=salescostid_5, salestaxid=salestaxid_6, purchasetaxid=purchasetaxid_7, 
stockid=stockid_8, stockdiffid=stockdiffid_9, producecostid=producecostid_10  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcPaymentType_Delete 
(id_1 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS  
count_1 integer;
begin
DELETE LgcPaymentType WHERE  ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcPaymentType_Insert 
(typename_1 	varchar2, 
typedesc_2 	varchar2, 
paymentid_3 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin
insert into LgcPaymentType ( typename, typedesc, paymentid)  VALUES ( typename_1, typedesc_2,
paymentid_3);
open thecursor for
select max(id) from LgcPaymentType;
end;
/

CREATE or replace PROCEDURE LgcPaymentType_Select
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for
 select * from LgcPaymentType;
end;
/

 CREATE or replace PROCEDURE LgcPaymentType_SelectByID 
(id_1  integer, 
flag out integer ,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
 select * from LgcPaymentType  where id = id_1;
end;
/

 CREATE or replace PROCEDURE LgcPaymentType_Update 
(id_1 	integer, 
typename_2 	varchar2, 
typedesc_3 	varchar2, 
paymentid_4 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
update LgcPaymentType  SET  typename=typename_2, typedesc=typedesc_3, paymentid=paymentid_4 
 WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcSearchDefine_Insert 
(userid_1 	integer,
 hasassetmark_2 	char,
 hasassetname_3 	char,
 hasassetcountry_4 	char, 
hasassetassortment_5 	char, 
hasassetstatus_6 	char, 
hasassettype_7 	char, 
hasassetversion_8 	char, 
hasassetattribute_9 	char, 
hasassetsalesprice_10 	char, 
hasdepartment_11 	char, 
hasresource_12 	char, 
hascrm_13 	char, 
perpage_14 	integer, 
assetcol1_15 	varchar2, 
assetcol2_16 	varchar2,
 assetcol3_17 	varchar2, 
assetcol4_18 	varchar2, 
assetcol5_19 	varchar2, 
assetcol6_20 	varchar2, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
delete LgcSearchDefine where userid = userid_1;
INSERT INTO LgcSearchDefine ( userid, hasassetmark, hasassetname, hasassetcountry, hasassetassortment,
 hasassetstatus, hasassettype, hasassetversion, hasassetattribute, hasassetsalesprice, hasdepartment,
 hasresource, hascrm, perpage, assetcol1, assetcol2, assetcol3, assetcol4, assetcol5, assetcol6)
 VALUES ( userid_1, hasassetmark_2, hasassetname_3, hasassetcountry_4, hasassetassortment_5,
 hasassetstatus_6, hasassettype_7, hasassetversion_8, hasassetattribute_9, hasassetsalesprice_10,
 hasdepartment_11, hasresource_12, hascrm_13, perpage_14, assetcol1_15, assetcol2_16,
 assetcol3_17, assetcol4_18, assetcol5_19, assetcol6_20);
end;
/

CREATE or replace PROCEDURE LgcSearchDefine_SelectByID 
(userid_1	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS 
count_1 integer;
begin
select count(userid) into count_1 from LgcSearchDefine where userid = userid_1;
if count_1 <> 0 then
open thecursor for
select * from LgcSearchDefine where userid = userid_1;
else 
open thecursor for
select * from LgcSearchDefine where userid = -1;
end if;
end;
/

CREATE or replace PROCEDURE LgcSearchMould_Delete 
(id_1 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 as 
 begin 
 delete LgcSearchMould  WHERE ( id=id_1);
 end;
/


 CREATE or replace PROCEDURE LgcSearchMould_Insert 
(mouldname_1 	varchar2, 
userid_1_2 	integer, 
assetmark_3 	varchar2, 
assetname_4 	varchar2, 
assetcountry_5 	in out integer, 
assetassortment_6 	in out integer, 
assetstatus_7 	char, 
assettype_8 	in out integer, 
assetversion_9 	varchar2, 
assetattribute_10 	varchar2, 
assetsalespricefrom_1	varchar2, 
assetsalespriceto_1 	varchar2, 
departmentid_13 in out	integer, 
resourceid_14 in out	integer, 
crmid_15 in out	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS 
assetsalespricefrom_11 number(18,3);
assetsalespriceto_12 number(18,3);
begin
if assetsalespricefrom_1 = '' then
assetsalespricefrom_11:= null;
else 
assetsalespricefrom_11:= to_number(assetsalespricefrom_1);
end if;
if assetsalespriceto_1= '' then
assetsalespriceto_12:= null;
else 
assetsalespriceto_12:= to_number(assetsalespriceto_1);
end if;
if crmid_15 = 0 then
crmid_15:= null;
end if;
if assetcountry_5 = 0 then
assetcountry_5:= null;
end if;
if assetassortment_6 = 0 then
assetassortment_6:= null;
end if;
if assettype_8 = 0 then
assettype_8:= null ;
end if;
if departmentid_13 = 0 then
departmentid_13:= null;
end if;
if resourceid_14 = 0 then
resourceid_14:= null;
end if;
  INSERT INTO LgcSearchMould ( mouldname, userid, assetmark, assetname, assetcountry, assetassortment,
 assetstatus, assettype, assetversion, assetattribute, assetsalespricefrom, assetsalespriceto,
 departmentid, resourceid, crmid)  VALUES ( mouldname_1, userid_1_2, assetmark_3, assetname_4, 
assetcountry_5, assetassortment_6, assetstatus_7, assettype_8, assetversion_9, 
assetattribute_10, assetsalespricefrom_11, assetsalespriceto_12, departmentid_13, resourceid_14,
 crmid_15);
open thecursor for
 select max(id) from LgcSearchMould;
end ;
/

 CREATE or replace PROCEDURE LgcSearchMould_SelectByMouldID 
(mouldid_1	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin
 open thecursor for
 select * from LgcSearchMould where id = mouldid_1;
end;
/


CREATE or replace PROCEDURE LgcSearchMould_SelectByUserID 
(userid_1	integer,
 flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for select id,mouldname from LgcSearchMould where userid = userid_1;
end;
/

 CREATE or replace PROCEDURE LgcSearchMould_Update 
(id_1 	integer, 
assetmark_2 	varchar2,
assetname_3 	varchar2, 
assetcountry_4 in out	integer, 
assetassortment_5 in out	integer, 
assetstatus_6 	char, 
assettype_7 	in out integer, 
assetversion_8 	varchar2, 
assetattribute_9 	varchar2, 
assetsalespricefrom_1 in out	varchar2, 
assetsalespriceto_1	in out varchar2,
departmentid_12 in out	integer, 
resourceid_13 	in out integer, 
crmid_14 in out	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS
assetsalespricefrom_10 number(18,3);
assetsalespriceto_11 number(18,3);
begin 
if assetsalespricefrom_1 = '' then
assetsalespricefrom_10:= null;
else
assetsalespricefrom_10:= to_number(assetsalespricefrom_1); 
end if; 
if assetsalespriceto_1 = '' then
 assetsalespriceto_11:= null;
else
assetsalespriceto_11:= to_number(assetsalespriceto_1); 
end if;  
if crmid_14 = 0 then
crmid_14:= null;
end if; 
if assetcountry_4 = 0 then
assetcountry_4:= null;
end if; 
if assetassortment_5 = 0 then
assetassortment_5:= null; 
end if; 
if assettype_7 = 0 then
assettype_7:= null;
end if; 
if departmentid_12 = 0 then
departmentid_12:= null;
end if;  
if resourceid_13 = 0  then
resourceid_13:= null;
end if;   
UPDATE LgcSearchMould  SET  assetmark=assetmark_2, assetname=assetname_3, 
assetcountry=assetcountry_4, assetassortment=assetassortment_5, assetstatus=assetstatus_6,
assettype=assettype_7, assetversion=assetversion_8, assetattribute=assetattribute_9,
assetsalespricefrom=assetsalespricefrom_10, assetsalespriceto=assetsalespriceto_11, 
departmentid=departmentid_12, resourceid=resourceid_13, crmid=crmid_14  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcStockInOutDetail_Insert 
(inoutid_1 	integer, 
assetid_2 	integer, 
batchmark_3 	varchar2,
number_4 	float, 
currencyid_5 	integer, 
defcurrencyid_6 	integer, 
exchangerate_7 	decimal, 
defunitprice_8 	decimal, 
unitprice_9 	decimal, 
taxrate_10 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
insert into LgcStockInOutDetail ( inoutid, assetid, batchmark, number_n, currencyid, defcurrencyid, 
exchangerate, defunitprice, unitprice, taxrate)  VALUES ( inoutid_1, assetid_2, batchmark_3, 
number_4, currencyid_5, defcurrencyid_6, exchangerate_7, defunitprice_8, unitprice_9, taxrate_10);
end;
/

CREATE or replace PROCEDURE LgcStockInOutDetail_Insert1 
(inoutid_1 	integer, 
assetid_2 	integer, 
batchmark_3 	varchar2, 
number_4 	float, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin 
insert into LgcStockInOutDetail ( inoutid, assetid, batchmark,number_n)  
VALUES ( inoutid_1, assetid_2, batchmark_3, number_4);
end;
/

CREATE or replace PROCEDURE LgcStockInOutDetail_Select 
(id_1 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for
 select *  from LgcStockInOutDetail where inoutid=id_1;
end;
/


 CREATE or replace PROCEDURE LgcStockInOutDetail_Update 
(id_1 	integer,
 inoutid_2 	integer,
 assetid_3 	integer,
 batchmark_4 	varchar2,
 thenumber_5 	float,
 currencyid_6 	integer,
 defcurrencyid_7 	integer,
 exchangerate_8 	decimal,
 defunitprice_9 	decimal,
 unitprice_10 	decimal,
 taxrate_11 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 as 
begin 
update LgcStockInOutDetail  SET  inoutid=inoutid_2, assetid=assetid_3, batchmark=batchmark_4, 
number_n=thenumber_5, currencyid=currencyid_6, defcurrencyid=defcurrencyid_7, exchangerate=exchangerate_8,
defunitprice=defunitprice_9, unitprice=unitprice_10, taxrate=taxrate_11  WHERE ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcStockInOutDetail_Update1 
(id_1 	integer, 
inoutid_2 	integer, 
assetid_3 	integer, 
batchmark_4 	varchar2, 
thenumber_5 	float, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
  as 
begin 
update LgcStockInOutDetail  SET  inoutid=inoutid_2, assetid=assetid_3, batchmark=batchmark_4,
number_n=thenumber_5  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcStockInOut_SelectByAsset
(assetid_1 integer,
 warehouseid_1 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for 
select *  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=warehouseid_1 
and b.assetid=assetid_1 and a.id=b.inoutid;
end;
/


 CREATE or replace PROCEDURE LgcStockInOut_SelectById 
(id_1 integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
select *  from LgcStockInOut where id=id_1;
end;
/

CREATE or replace PROCEDURE LgcStockMode_Delete 
(id_1 	integer,
 flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS
count_1 integer;
begin
select count(id) into count_1 from LgcStockInOut where stockmodeid = id_1 ;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return; 
end if;
DELETE LgcStockMode WHERE  ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcStockMode_Insert
(modename_1 	varchar2, 
 modetype_1  char ,
 modestatus_1  char,
 modedesc_2 	varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
 insert into LgcStockMode ( modename, modetype, modestatus, modedesc)  VALUES ( modename_1, 
 modetype_1, modestatus_1, modedesc_2);
open thecursor for
  select max(id) from LgcStockMode;
end;
/

CREATE or replace PROCEDURE LgcStockMode_Select 
(flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for 
select * from LgcStockMode;
end;
/

CREATE or replace PROCEDURE LgcStockMode_SelectByID
(id_1  integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for 
select * from LgcStockMode  where id = id_1;
end;
/

CREATE or replace PROCEDURE LgcStockMode_Update 
(id_1 	integer,
 modename_2 	varchar2,
 modetype_1  char ,
 modestatus_1  char, 
 modedesc_3 	varchar2, 
 flag out integer , msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  
as 
begin 
update LgcStockMode  SET  modename=modename_2, modetype=modetype_1, modestatus=modestatus_1, 
modedesc=modedesc_3  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcWarehouse_Delete 
(id_1 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
 count_1 int;
begin
select count(id) into count_1 from LgcStockInOut where warehouseid = id_1;
if count_1 <> 0 then
open thecursor for
select -1 from dual; 
return;
end if;
DELETE LgcWarehouse WHERE  ( id=id_1);
end;
/

CREATE or replace PROCEDURE LgcWarehouse_Insert 
(warehousename_1 	varchar2,
 warehousedesc_2 	varchar2,
 roleid_3 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
 insert into LgcWarehouse ( warehousename, warehousedesc, roleid) 
 VALUES ( warehousename_1, warehousedesc_2, roleid_3);
open thecursor for
  select max(id) from LgcWarehouse;
end;
/

CREATE or replace PROCEDURE LgcWarehouse_Select 
(flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 open thecursor
 for select * from LgcWarehouse;
end;
/

CREATE or replace PROCEDURE LgcWarehouse_SelectByID 
(id_1  integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for
 select * from LgcWarehouse  where id = id_1;
end;
/

CREATE or replace PROCEDURE LgcWarehouse_Update 
(id_1 	integer, 
warehousename_2 	varchar2, 
warehousedesc_3 	varchar2, 
roleid_4 	integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
update LgcWarehouse  SET  warehousename=warehousename_2, warehousedesc=warehousedesc_3, 
roleid=roleid_4  WHERE ( id=id_1);
end;
/

 CREATE or replace PROCEDURE LgcWebShopDetail_Insert 
(webshopid_1 	integer,
 assetid_2 	integer,
 countryid_1     integer,
 currencyid_3 	integer,
 assetprice_1 	varchar2,
 taxrate_5 	integer,
 purchasenum_6 	float,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  
AS 
assetprice_4 	decimal(18,3);
begin
assetprice_4:= to_number(assetprice_1);
INSERT INTO LgcWebShopDetail ( webshopid, assetid, countryid , currencyid, assetprice, taxrate, 
purchasenum)  VALUES ( webshopid_1, assetid_2, countryid_1 , currencyid_3, assetprice_4,
taxrate_5, purchasenum_6);
end;
/

CREATE or replace PROCEDURE LgcWebShopDetail_SelectById 
(id_1  integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
open thecursor for
 select * from LgcWebShopDetail  where webshopid = id_1;
end;
/

CREATE or replace PROCEDURE LgcWebShop_Delete 
(id_1  integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
delete LgcWebShop  where id = id_1;
delete LgcWebShopDetail  where webshopid = id_1;
end;
/

CREATE or replace PROCEDURE LgcWebShop_Insert 
(usertype_1 	smallint,
 userid_1_2 	integer, 
 username_3 	varchar2,
 usercountry_4 	integer,
 useremail_5 	varchar2,
 receiveaddress_6 	varchar2,
 receivetype_7 	integer,
 postcode_8 	varchar2,
 telephone1_9 	varchar2,
 telephone2_10 	varchar2,
 paymentmode_11 	varchar2,
 currencyid_12 	integer,
 purchasecount_1 	varchar2,
 purchaseremark_14 	varchar2,
 purchasedate_15 	char,
 manageid_16 	integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
purchasecount_13 number;
begin
purchasecount_13:= to_number(purchasecount_1);
INSERT INTO LgcWebShop ( usertype, userid, username, usercountry, useremail, receiveaddress,
 receivetype, postcode, telephone1, telephone2, paymentmode, currencyid, purchasecount,
 purchaseremark, purchasedate, purchasestatus, manageid)  VALUES ( usertype_1, userid_1_2, 
username_3, usercountry_4, useremail_5, receiveaddress_6, receivetype_7, postcode_8,
 telephone1_9, telephone2_10, paymentmode_11, currencyid_12, purchasecount_13, 
purchaseremark_14, purchasedate_15, '0', manageid_16);
open thecursor for
select max(id) from LgcWebShop;
end;
/

CREATE or replace PROCEDURE LgcWebShop_SelectById
(id_1  integer, 
flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from LgcWebShop  where id = id_1;
end;
/

CREATE or replace PROCEDURE LgcWebShop_Update
(id_1  integer,
 purchasestatus_1 char,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
update LgcWebShop  set purchasestatus = purchasestatus_1 where id = id_1;
end;
/

 CREATE or REPLACE PROCEDURE MailPassword_IByResourceid 
	( resourceid_1 	integer,
	  resourcemail_2 	varchar2,
	  password_3	varchar2,
	  flag out integer,
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
count_1 integer;
begin 
select  count(*) into count_1 from MailPassword where resourceid= resourceid_1;
if  count_1>0 then 
    update MailPassword set resourcemail= resourcemail_2,password= password_3 where resourceid= resourceid_1;
else
    insert into MailPassword values( resourceid_1, resourcemail_2, password_3); 
end if;
 end;
/

 CREATE or REPLACE PROCEDURE MailPassword_SbyResourceid 
	( resourceid_1 	integer,
	  flag out integer,
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

select * from MailPassword where resourceid =  resourceid_1;

 end;
/

 CREATE or REPLACE PROCEDURE MailResource_Delete 
	( mailid_1  integer,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
delete from MailResourceFile where mailid =  mailid_1;
delete from MailResource where id =  mailid_1;
end;
/

 CREATE or REPLACE PROCEDURE MailResource_Insert 
	( resourceid_2 	integer,
	  priority_3 	char,
	  sendfrom_4 	varchar2,
	  sendcc_5 	varchar2,
	  sendbcc_6 	varchar2,
	  sendto_7 	varchar2,
	  senddate_8 	varchar2,
	  size_9 	integer,
	  subject_10 	varchar2,
	  content_11 	varchar2,
	  mailtype_12	char ,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 

 INSERT into MailResource 
	 (resourceid,
	 priority,
	 sendfrom,
	 sendcc,
	 sendbcc,
	 sendto,
	 senddate,
	 size_n,
	 subject,
	 content,
	 mailtype) 
 
VALUES 
	( resourceid_2,
	  priority_3,
	  sendfrom_4,
	  sendcc_5,
	  sendbcc_6,
	  sendto_7,
	  senddate_8,
	  size_9,
	  subject_10,
	  content_11,
	  mailtype_12);
open thecursor for 
select max(id) from MailResource;
 
 end;
/

 CREATE or REPLACE PROCEDURE MailResource_SelectCount 
	( resourceid_1  integer,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
localcount integer;
draftcount integer;
deletecount integer;
sendcount integer;
begin 

select  count(*) into localcount from MailResource where mailtype = '0' and resourceid =  resourceid_1;
select  count(*) into sendcount from MailResource where mailtype = '1' and resourceid =  resourceid_1;
select  count(*) into draftcount from MailResource where mailtype = '2' and resourceid =  resourceid_1;
select  count(*) into deletecount from MailResource where mailtype = '3' and resourceid =  resourceid_1;
open thecursor for 
select  localcount, sendcount, draftcount, deletecount from dual;

 end;
/

 CREATE or REPLACE PROCEDURE MailResource_UpdateMailtype 
	( mailid_1  integer,
	  mailtype_2  char,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

update MailResource set mailtype =  mailtype_2 where id =  mailid_1;

 end;
/

 CREATE or REPLACE PROCEDURE MailShare_Delete 
	( id_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
 	delete from MailShare where id= id_1;
 end;
/

 CREATE or REPLACE PROCEDURE MailShare_Insert 
       ( mailgroupid_1         integer,
	 sharetype_1	smallint,
	 seclevel_1	smallint,
	 rolelevel_1	smallint,
	 sharelevel_1	smallint,
	 userid_1	        integer,
	 subcompanyid_1	integer,
	 departmentid_1	integer,
	 roleid_1	        integer,
	 foralluser_1	smallint,
	 sharedcrm_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
	insert into MailShare (mailgroupid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,sharedcrm) values
	( mailgroupid_1, sharetype_1, seclevel_1, rolelevel_1, sharelevel_1, userid_1, subcompanyid_1, departmentid_1, roleid_1, foralluser_1, sharedcrm_1);

 end;
/

/*********************************/
 CREATE or REPLACE PROCEDURE MailShare_InsertByUser 
     (seclevel_1 integer,
     departmentid_1 integer,
     subcompanyid_1 integer,
     userid_1	integer, 
     flag	out integer, 
     msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
as 
 mailgroupid_1	integer;
  cursor all_cursor is
  select Distinct mailgroupid from MailShare  where sharetype=5 or (sharetype=3 and  seclevel>= seclevel_1 and  departmentid= departmentid_1) 
  OR (sharetype=2 and  seclevel>= seclevel_1 and  subcompanyid= subcompanyid_1);
begin 
  
  OPEN  all_cursor ;
  FETCH  all_cursor into  mailgroupid_1;  
  WHILE  all_cursor%found 
  loop
  insert into MailUserShare (mailgroupid,userid) values ( mailgroupid_1 ,  userid_1);
  FETCH  all_cursor into  mailgroupid_1;  
  end loop;
  CLOSE  all_cursor;

 end;
/

 CREATE or REPLACE PROCEDURE MailShare_SelectByMailgroupid 
	( mailgroupid_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select * from MailShare where mailgroupid =  mailgroupid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE MailUserAddress_Delete 
 ( 
 mailgroupid_1 integer,
 mailaddress_1     varchar2,
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

delete from MailUserAddress WHERE mailgroupid= mailgroupid_1 and mailaddress= mailaddress_1;

 end;
/

 CREATE or REPLACE PROCEDURE MailUserAddress_Insert 
 ( 
 mailgroupid_1 integer,
 mailaddress_1     varchar2,
 maildesc_1   varchar2,
 flag out integer, 
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

insert into MailUserAddress values ( mailgroupid_1, mailaddress_1, maildesc_1);

 end;
/

 CREATE or REPLACE PROCEDURE MailUserAddress_SelectAllById 
 ( 
 mailgroupid_1 integer,
 flag out  integer, 
 msg  out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 
select * from MailUserAddress WHERE mailgroupid= mailgroupid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE MailUserGroup_DeleteById 
 ( 
 mailgroupid_1 integer,
 flag out integer, 
 msg  out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
delete from MailUserGroup WHERE mailgroupid= mailgroupid_1;

 end;
/

 CREATE or REPLACE PROCEDURE MailUserGroup_Insert 
  ( 
 mailgroupname_1  varchar2,
 operatedesc_1 varchar2 ,				
 createrid_1   integer,		                      
 createrdate_1    char ,			    
 flag  out integer, 
 msg  varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

INSERT into MailUserGroup  (mailgroupname,operatedesc,createrid,createrdate)
VALUES ( mailgroupname_1, operatedesc_1, createrid_1, createrdate_1);

 end;
/

 CREATE or REPLACE PROCEDURE MailUserGroup_SelectAll 
  ( 
 flag out integer, 
 msg  varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

select * from MailUserGroup; 
 
 end;
/


 CREATE or REPLACE PROCEDURE MailUserGroup_SelectByUser 
  ( 
 userid_1     integer,
 flag out integer, 
 msg  varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
select * from MailUserGroup where createrid= userid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE MailUserGroup_SMailgroupname 
 ( 
 userid_1	integer,
 flag   out integer, 
 msg  varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

select mailgroupname from MailUserGroup where createrid= userid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE MailUserGroup_SelectNameById 
 ( 
 mailgroupid_1 integer,
 flag   out integer, 
 msg  varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

select mailgroupname,operatedesc from MailUserGroup WHERE mailgroupid= mailgroupid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE MailUserGroup_UpdateById 
 ( 
 mailgroupname_1  varchar2,
 operatedesc_1 varchar2 ,				 
 mailgroupid_1 integer,
 flag  out integer, 
 msg  varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

update MailUserGroup set mailgroupname= mailgroupname_1,operatedesc= operatedesc_1
WHERE mailgroupid= mailgroupid_1;

 end;
/

 CREATE or REPLACE PROCEDURE MailUserShare_DbyMailgroupId 
( mailgroupid_1 	integer,
  flag	out integer,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	delete from MailUserShare where mailgroupid= mailgroupid_1;

 end;
/

 CREATE or REPLACE PROCEDURE MailUserShare_DeletebyUserId 
( userid_1 	integer,
  flag	out integer,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
	delete from MailUserShare where userid= userid_1;
 end;
/

 CREATE or REPLACE PROCEDURE MailUserShare_SelectbyUserId 
( userid_1 	integer,
  flag	out integer,
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

	select mailgroupid from MailUserShare where userid= userid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE MailUser_DeleteById 
 ( 
 mailgroupid_1    integer,
 resourceid_1 integer,
 flag out integer, 
 msg out  varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
delete from MailUser WHERE resourceid= resourceid_1 and mailgroupid= mailgroupid_1;
 end;
/

 CREATE or REPLACE PROCEDURE MailUser_Insert 
  ( 
 mailgroupid_1 integer,   /*mail user group */
 resourceid_1  integer,   /*appointeger user*/    
 flag out integer, 
 msg  out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
INSERT into MailUser (mailgroupid,resourceid)
VALUES ( mailgroupid_1, resourceid_1);
 end;
/

 CREATE or REPLACE PROCEDURE MailUser_SelectAllById 
 ( 
 mailgroupid_1 integer,
 flag  out  integer, 
 msg  out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for 

select * from MailUser WHERE mailgroupid= mailgroupid_1;
 
 end;
/

 CREATE or REPLACE PROCEDURE MeetingCaller_Delete 
	 (id_1 integer,
	 flag out integer , 
  	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
as 
begin 


	delete from MeetingCaller where id= id_1;

 end;
/



/* proc 3 */


 CREATE or REPLACE PROCEDURE MeetingCaller_Insert 
 (
	meetingtype_1 integer,
	callertype_1  integer,
	seclevel_1    integer,
	rolelevel_1   integer,
	userid_1      integer,
	departmentid_1      integer,
	roleid_1      integer,
	foralluser_1  integer,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
	insert into MeetingCaller(meetingtype,callertype,seclevel,rolelevel,userid,departmentid,roleid,foralluser)
	values (meetingtype_1,callertype_1,seclevel_1,rolelevel_1,userid_1,departmentid_1,roleid_1,foralluser_1);
end;
/


 CREATE or REPLACE PROCEDURE MeetingCaller_SByMeeting 
 (
	meetingtype_1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
begin
open thecursor for
	select * from MeetingCaller where meetingtype=meetingtype_1;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Address_Delete 
 (id_1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS
	begin
	delete Meeting_Address WHERE ( id = id_1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Address_Insert 
(
meetingtype_1 integer, 
 addressid_1 integer, 
 desc_n_1 varchar2, 
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
AS 
begin
INSERT INTO Meeting_Address ( meetingtype,addressid,desc_n)  VALUES ( meetingtype_1, addressid_1, desc_n_1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Address_SelectAll 
 ( meetingtype_1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Address where meetingtype = meetingtype_1; 
end;
/

 CREATE or REPLACE PROCEDURE Meeting_Approve 
 (
 meetingid_1 integer , approver_1 integer , approvedate_1 varchar2  ,approvetime_1 varchar2  ,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS
	begin
Update Meeting 
set
isapproved='2', approver=approver_1, approvedate=approvedate_1, approvetime=approvetime_1  
where id = meetingid_1;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Decision_Delete 
 (meetingid_1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS 
	begin
	delete Meeting_Decision WHERE ( meetingid = meetingid_1 ) ; 
end;
/


/*20021105*/



 CREATE or REPLACE PROCEDURE Meeting_Decision_Insert 
 (meetingid_1 integer,
 requestid_1 integer, coding_1 varchar2 ,	subject_1 varchar2 ,	
 hrmid01_1 varchar2 , hrmid02_1 integer, begindate_1 varchar2  ,
 begintime_1 varchar2  , enddate_1 varchar2  , endtime_1 varchar2 ,
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS
begin
INSERT INTO 
Meeting_Decision
 ( meetingid ,requestid , coding, subject, hrmid01, hrmid02, begindate, begintime, enddate, endtime )
 VALUES ( meetingid_1 , requestid_1 , coding_1, subject_1, hrmid01_1, hrmid02_1, begindate_1, begintime_1, enddate_1, endtime_1  ); 
end;
/

 CREATE or REPLACE PROCEDURE Meeting_Decision_SelectAll 
 ( meetingid_1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS
begin
open thecursor for
SELECT * FROM Meeting_Decision where meetingid = meetingid_1; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Delete 
 (id_1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS
	begin
	delete Meeting WHERE ( id = id_1 ) ; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Insert 
(meetingtype_1 integer,
 name_1 varchar2 ,
 caller_1 integer,
 contacter_1 integer,
 projectid_1 integer,
 address_1 integer,
 begindate_1 varchar2,
 begintime_1 varchar2,
 enddate_1 varchar2,
 endtime_1 varchar2,
 desc_n_1 varchar2,
 creater_1 integer,
 createdate_1 varchar2,
 createtime_1 varchar2 , 
 totalmember_1   integer,
 othermembers_1   varchar2,
 addressdesc_1   varchar2,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
INSERT INTO Meeting ( meetingtype ,name ,caller ,contacter ,projectid,address ,begindate  ,begintime ,enddate ,endtime ,desc_n,creater ,createdate ,createtime,totalmember,othermembers,addressdesc)  
VALUES ( meetingtype_1 ,name_1,caller_1,	contacter_1,projectid_1,address_1 ,begindate_1  ,begintime_1  ,enddate_1 ,endtime_1 ,desc_n_1  ,creater_1 ,createdate_1 ,createtime_1,totalmember_1,othermembers_1,addressdesc_1) ;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Member2_Delete 
 (meetingid_1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS
	begin
	delete Meeting_Member2 WHERE ( meetingid = meetingid_1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Member2_Insert 
 (meetingid_1 integer, membertype_1 smallint,	memberid_1 integer,	membermanager_1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
INSERT INTO Meeting_Member2 ( meetingid ,membertype ,memberid ,membermanager) 
VALUES ( meetingid_1 , membertype_1, memberid_1, membermanager_1); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Member2_SelectByID 
 ( id_1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Member2 where id = id_1 ;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Member2_SelectByType 
 ( meetingid_1 integer, membertype_1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Member2 where meetingid = meetingid_1 and membertype = membertype_1; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Member2_Update 
 (id_1 integer, isattend_1 varchar2 ,	
 begindate_1 varchar2  , begintime_1 varchar2  ,
 enddate_1 varchar2  ,	endtime_1 varchar2 ,	
 bookroom_1 varchar2 ,	roomstander_1 varchar2 ,
 bookticket_1 varchar2 ,	ticketstander_1 varchar2 ,
 othermember_1 varchar2 ,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS 
begin
Update Meeting_Member2 
set
isattend=isattend_1 , begindate=begindate_1 , begintime=begintime_1 , enddate=enddate_1, endtime=endtime_1 , bookroom=bookroom_1 ,roomstander=roomstander_1 , bookticket=bookticket_1 , ticketstander=ticketstander_1  , othermember=othermember_1 
where id = id_1;
end;
/

 CREATE or REPLACE PROCEDURE Meeting_MemberCrm_Delete 
 (memberrecid_1 	integer, 
    flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS 
	begin
	delete Meeting_MemberCrm WHERE ( memberrecid = memberrecid_1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_MemberCrm_Insert 
 (meetingid_1 integer, memberrecid_1 integer, name_1 varchar2, sex_1 smallint, occupation_1 varchar2, tel_1  varchar2,
 handset_1 varchar2, desc_n_1 varchar2 ,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS
	begin
INSERT INTO Meeting_MemberCrm ( meetingid ,memberrecid ,name, sex ,occupation, tel ,handset, desc_n)
VALUES ( meetingid_1 , memberrecid_1, name_1, sex_1 , occupation_1, tel_1 , handset_1, desc_n_1) ;
end;
/




 CREATE or REPLACE PROCEDURE Meeting_MemberCrm_SelectAll 
 ( memberrecid_1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_MemberCrm where memberrecid = memberrecid_1; 
end;
/



 CREATE or REPLACE PROCEDURE Meeting_Member_Delete 
 (id_1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS
	begin
	delete Meeting_Member WHERE ( id = id_1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Member_Insert 
 (meetingtype_1 integer, membertype_1 smallint, memberid_1 integer, desc_n_1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  )  
	AS
	begin
INSERT INTO Meeting_Member ( meetingtype,membertype,memberid,desc_n)
VALUES ( meetingtype_1, membertype_1, memberid_1, desc_n_1 ) ;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Member_SelectAll 
 ( meetingtype_1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Member where meetingtype = meetingtype_1 order by membertype; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Member_SelectByType 
 ( meetingtype1 integer, membertype1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Member where meetingtype = meetingtype1 and membertype = membertype1 ;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Schedule 
 (meetingid1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
Update Meeting set isapproved='3'  
where id = meetingid1;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_SelectByID 
 ( meetingid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting where id = meetingid1; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_SelectMaxID 
 (  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT max(id) FROM Meeting ;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Service2_Delete 
 (meetingid1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
	begin
	delete Meeting_Service2 WHERE ( meetingid = meetingid1 ); 
end;
/

 CREATE or REPLACE PROCEDURE Meeting_Service2_Insert 
 (meetingid1 integer, hrmid1 integer, name1 varchar2  , desc_n1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
INSERT INTO Meeting_Service2 ( meetingid ,hrmid ,name, desc_n)  VALUES ( meetingid1 , hrmid1, name1 , desc_n1) ;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Service2_SelectAll 
 ( meetingid1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Service2 where meetingid = meetingid1;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Service_Delete 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
	delete Meeting_Service WHERE ( id = id1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Service_Insert 
 (meetingtype1 integer, hrmid1 integer, name1 varchar2, desc_n1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  )  AS 
begin
INSERT INTO Meeting_Service ( meetingtype,hrmid,name,desc_n)  VALUES ( meetingtype1, hrmid1, name1, desc_n1 ) ;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Service_SelectAll 
 ( meetingtype1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Service where meetingtype = meetingtype1; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Submit 
 (meetingid1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
	begin
Update Meeting set isapproved='1'  
where id = meetingid1;
end;
/



 CREATE or REPLACE PROCEDURE Meeting_TopicDate_Delete 
 (meetingid1 integer, topicid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS
	begin
	delete Meeting_TopicDate WHERE ( meetingid = meetingid1 and topicid = topicid1 ) ; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_TopicDate_Insert 
 (meetingid1 integer, topicid1 integer, begindate1 varchar2  , begintime1 varchar2  , enddate1 varchar2 ,	endtime1 varchar2  ,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
INSERT INTO Meeting_TopicDate ( meetingid ,topicid ,begindate,begintime,enddate,endtime)
VALUES ( meetingid1 , topicid1, begindate1 , begintime1  , enddate1 , endtime1 ); 
end;
/



 CREATE or REPLACE PROCEDURE Meeting_TopicDate_SelectAll 
 ( meetingid1 integer, topicid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_TopicDate where meetingid = meetingid1 and topicid = topicid1; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_TopicDoc_Delete 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
	delete Meeting_TopicDoc WHERE ( id = id1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_TopicDoc_Insert 
 (meetingid1 integer, topicid1 integer, docid1 integer, hrmid1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
INSERT INTO Meeting_TopicDoc ( meetingid ,topicid ,docid,hrmid)  VALUES ( meetingid1 , topicid1, docid1, hrmid1); 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_TopicDoc_SelectAll 
 ( meetingid1 integer, topicid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT t1.id,t1.docid,t1.hrmid,t2.docsubject,t2.ownerid 
FROM Meeting_TopicDoc  t1, DocDetail  t2
where t1.meetingid = meetingid1 and t1.topicid = topicid1 and t1.docid=t2.id ;
end;
/



 CREATE or REPLACE PROCEDURE Meeting_Topic_Delete 
 (meetingid1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
	delete Meeting_Topic WHERE ( meetingid = meetingid1 ) ;
	end;
/



 CREATE or REPLACE PROCEDURE Meeting_Topic_Insert 
(meetingid1 integer, 
 hrmid1 integer, 
 subject1 varchar2 , 
 hrmids1 varchar2 , 
 projid1 integer,
 crmid1  integer,
 isopen1 smallint, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
INSERT INTO Meeting_Topic ( meetingid ,hrmid ,subject,hrmids, isopen,projid,crmid)  
VALUES ( meetingid1 , hrmid1, subject1 , hrmids1, isopen1,projid1,crmid1) ;
end;
/





 CREATE or REPLACE PROCEDURE Meeting_Topic_SelectAll 
 ( meetingid1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Topic where meetingid = meetingid1; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Topic_Update 
(id1    integer,
 hrmid1 integer, 
 subject1 varchar2 , 
 hrmids1 varchar2 , 
 projid1 integer,
 crmid1  integer,
 isopen1 smallint, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
update Meeting_Topic 
set
hrmid=hrmid1 ,subject=subject1,hrmids=hrmids1,projid=projid1,crmid=crmid1,isopen=isopen1 where id=id1;
end;
/



 CREATE or REPLACE PROCEDURE Meeting_Type_Delete 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
	begin
	delete Meeting_Type WHERE ( id = id1 ) ; 
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Type_Insert 
 (name1 varchar2, approver1 integer, desc_n1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  )  AS 
	begin
INSERT INTO Meeting_Type ( name, approver, desc_n)  VALUES ( name1, approver1, desc_n1 ); 
end;
/



 CREATE or REPLACE PROCEDURE Meeting_Type_SelectAll 
 ( 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Type ;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Type_SelectByID 
 ( id1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Type where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Type_Update 
 (id1 integer, name1 varchar2, approver1 integer, desc_n1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  )  AS 
	begin
update Meeting_Type  set name=name1, approver=approver1, desc_n=desc_n1  
where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE Meeting_Update 
(meetingid1 integer,
 name1 varchar2 ,
 caller1 integer,	
 contacter1 integer,
 projectid1 integer,
 address1 integer,
 begindate1 varchar2  ,
 begintime1 varchar2 ,
 enddate1 varchar2  ,
 endtime1 varchar2  ,
 desc_n1 varchar2 , 
 totalmember1   integer,
 othermembers1   varchar2,
 addressdesc1  varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
Update Meeting 
set
name=name1 ,
caller=caller1 ,
contacter=contacter1 ,
projectid=projectid1,
address=address1 ,
begindate=begindate1 ,
begintime=begintime1 ,
enddate=enddate1 ,
endtime=endtime1 ,
desc_n=desc_n1,
totalmember=totalmember1,
othermembers=othermembers1,
addressdesc=addressdesc1  
where id = meetingid1;
end;
/



 CREATE or REPLACE PROCEDURE Meeting_UpdateDecision 
 (meetingid1 integer, isdecision1 integer,  decision1 varchar2, decisiondocid1 integer, decisiondate1 varchar2  , decisiontime1 varchar2 , decisionhrmid1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS
	begin
Update Meeting set isdecision=isdecision1, decision=decision1, decisiondocid=decisiondocid1, decisiondate=decisiondate1, decisiontime=decisiontime1, decisionhrmid=decisionhrmid1  
where id = meetingid1;
end;
/


 CREATE or REPLACE PROCEDURE MemberRoleInfo_Select 
 (flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS
begin
open thecursor for
SELECT resourceid , roleid , rolelevel from HrmRoleMembers order by resourceid ;
end;
/


 CREATE or REPLACE PROCEDURE NewDocFrontpage_DeleteByDocId 
  (
   docid1  integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
  AS 
begin
  delete from  NewDocFrontpage where docid=docid1;
end;
/


 CREATE or REPLACE PROCEDURE NewDocFrontpage_DeleteByUser 
  (usertype1 integer,
   userid1 integer,
   docid1  integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
  AS
  begin
  delete from  NewDocFrontpage where usertype=usertype1 and userid=userid1 and docid=docid1;
end;
/


 CREATE or REPLACE PROCEDURE NewDocFrontpage_Insert 
  (usertype1 integer,
   userid1 integer,
   docid1  integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
  AS 
  begin
  insert into NewDocFrontpage (usertype,userid,docid) VALUES(usertype1,userid1,docid1);
end;
/



 CREATE or REPLACE PROCEDURE NewDocFrontpage_SMRecentCount 
(
logintype_1		integer,
usertype_1		integer,
userid_1			integer,
userseclevel_1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
if logintype_1=1  then 

open thecursor for
Select count(distinct c.id ) countnew from NewDocFrontpage n , DocShareDetail d , docdetail c where n.docid=d.docid 
and n.docid=c.id and n.userid=d.userid and  d.usertype=1 and n.userid=userid_1 and (c.docpublishtype='2' or c.docpublishtype='3') 
and c.docstatus in('1','2','5') and c.maincategory='5' ;


else
 
 open thecursor for
  Select count(distinct c.id ) countnew from NewDocFrontpage n , DocShareDetail d  , docdetail c where  n.docid=d.docid 
  and n.docid= c.id and  n.usertype = d.usertype and n.usertype=usertype_1 and d.userid<=userseclevel_1 and ( c.docpublishtype='2' 
  or c.docpublishtype='3') and c.docstatus in('1','2','5') and maincategory='5' ;
end if;
end;
/




 CREATE or REPLACE PROCEDURE NewDocFrontpage_SRecentCount 
(
logintype2		integer,
usertype2		integer,
userid2			integer,
userseclevel2	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
if logintype2=1 then

open thecursor for
Select count(distinct c.id ) countnew from NewDocFrontpage n , DocShareDetail d , docdetail c where n.docid=d.docid 
and n.docid=c.id and n.userid=d.userid and  d.usertype=1 and n.userid=userid2 and (c.docpublishtype='2' or c.docpublishtype='3') 
and c.docstatus in('1','2','5');

else
   
  open thecursor for
  Select count(distinct c.id ) countnew from NewDocFrontpage n , DocShareDetail d  , docdetail c where  n.docid=d.docid 
  and n.docid= c.id and  n.usertype = d.usertype and n.usertype=usertype2 and d.userid<=userseclevel2 and ( c.docpublishtype='2'
  or c.docpublishtype='3') and c.docstatus in('1','2','5');
end if;
end;
/


CREATE GLOBAL TEMPORARY TABLE temp_table_03
 (id integer,
 docsubject varchar2 (200),
 doccreatedate char (10),
 doccreatetime char (8))
 ON COMMIT DELETE ROWS
/



 CREATE or REPLACE PROCEDURE NewDocFrontpage_SelectAllNId 
(
pagenumber_1     integer,
perpage_1        integer,
countnumber_1    integer,
logintype_1		integer,
usertype_1		integer,
userid_1			integer,
userseclevel_1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as
 pagecount_1 integer ;
 pagecount2_1 integer ;
 id_1    integer;
 docsubject_1 varchar2(200);
 doccreatedate_1 char(10);
 doccreatetime_1  char(8); 

 CURSOR all_cursor01 is
	Select * from(Select distinct  c.id , c.docsubject , c.doccreatedate , c.doccreatetime
	from NewDocFrontpage n , DocShareDetail d , docdetail c 
	where 
	n.docid=d.docid 
	and n.docid=c.id 
	and n.userid=d.userid 
	and  d.usertype=1 
	and n.userid=userid_1 
	and (c.docpublishtype='2' or c.docpublishtype='3')
	and c.docstatus in('1','2','5') 
	order by c.doccreatedate  desc , c.doccreatetime desc )
	WHERE rownum < (pagecount_1+1) ;

 CURSOR all_cursor02 is
	Select * from(Select distinct  c.id , c.docsubject , c.doccreatedate , c.doccreatetime 
	from NewDocFrontpage n , DocShareDetail d  , docdetail c 
	where  
	n.docid=d.docid
	and n.docid= c.id
	and  n.usertype = d.usertype 
	and n.usertype=usertype_1
	and d.userid <= userseclevel_1 
	and ( c.docpublishtype='2' or c.docpublishtype='3')
	and c.docstatus in('1','2','5') 
	order by c.doccreatedate desc , c.doccreatetime desc ) 
	WHERE rownum < (pagecount_1+1); 
begin

 pagecount_1 :=  pagenumber_1 * perpage_1;
if (countnumber_1-(pagenumber_1-1)*perpage_1) < perpage_1 then      					
 pagecount2_1  := countnumber_1-(pagenumber_1-1)*perpage_1;
else 
 pagecount2_1 := perpage_1; 
end if;

if logintype_1=1 then
    open all_cursor01;
	loop
		fetch all_cursor01 INTO id_1,docsubject_1,doccreatedate_1, doccreatetime_1; 
		exit when all_cursor01%NOTFOUND;	
		insert into temp_table_03 (id,docsubject,doccreatedate, doccreatetime)
			values (id_1,docsubject_1,doccreatedate_1, doccreatetime_1) ;
	end  loop;
	open thecursor for
	select * from (select * from temp_table_03 order by doccreatedate, doccreatetime) WHERE rownum<(pagecount2_1+1);
end if;
if logintype_1<> 1 then
    open all_cursor02;
	loop
		fetch all_cursor02 INTO id_1,docsubject_1,doccreatedate_1, doccreatetime_1; 
		exit when all_cursor02%NOTFOUND;	
		insert into temp_table_03 (id,docsubject,doccreatedate, doccreatetime)
			values (id_1,docsubject_1,doccreatedate_1, doccreatetime_1) ;
	end  loop;
	open thecursor for
	select * from (select * from temp_table_03 order by doccreatedate, doccreatetime) WHERE rownum<(pagecount2_1+1);
end if;
end;
/







CREATE or replace PROCEDURE PRJ_Find_LastModifier 
(id_1 	integer, 
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for 
select submiter,submitdate from (select submiter,submitdate from Prj_Log WHERE projectid = id_1
and (not (logtype = 'n')) ORDER BY submitdate DESC) where rownum=1; 
end;
/


 CREATE or REPLACE PROCEDURE PrjShareDetail_DByPrjId 
	(prjid_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
DELETE PrjShareDetail 
WHERE 
	( prjid	 = prjid_1);
end;
/


 CREATE or REPLACE PROCEDURE PrjShareDetail_DByUserId 
	(userid_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
DELETE PrjShareDetail 
WHERE 
	( userid	 = userid_1  and usertype = '1' );
end;
/


 CREATE or REPLACE PROCEDURE PrjShareDetail_Insert 
	(prjid_1 	integer,
	 userid_2 	integer,
	 usertype_3 	integer,
	 sharelevel_4 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO PrjShareDetail 
	 ( prjid,
	 userid,
	 usertype,
	 sharelevel) 
VALUES 
	( prjid_1,
	 userid_2,
	 usertype_3,
	 sharelevel_4);
end;
/




 CREATE or REPLACE PROCEDURE PrjShareDetail_SByPrjId 
	(prjid_1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
select * from PrjShareDetail where prjid = prjid_1; 
end;
/


 CREATE or REPLACE PROCEDURE PrjShareDetail_SByResourceId 
	(resourceid_1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
select prjid , sharelevel from PrjShareDetail where userid = resourceid_1 and usertype = '1'  ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Cpt_Insert 
 (prjid1	integer, taskid1 	integer, requestid1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  )  AS 
begin
INSERT INTO Prj_Cpt ( prjid, taskid, requestid)  VALUES ( prjid1, taskid1, requestid1) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Customer_DeleteByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
delete Prj_Customer WHERE ( id = id1 ) ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Customer_FindByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_Customer WHERE ( id	 = id1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Customer_FindByTaskID 
 (prjid1 	integer, taskid1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_Customer WHERE ( prjid	 = prjid1 and taskid = taskid1 ) ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Customer_Insert 
 (prjid1 	integer, taskid1 	integer, customerid1 	integer, powerlevel1 	smallint, reasondesc1	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
	INSERT INTO Prj_Customer ( prjid, taskid, customerid, powerlevel, reasondesc)  VALUES ( prjid1, taskid1, customerid1, powerlevel1, reasondesc1) ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Customer_Update 
 (id1 	integer, customerid1 	integer, powerlevel1 	smallint, reasondesc1	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
	begin
	Update Prj_Customer set customerid=customerid1, powerlevel=powerlevel1, reasondesc=reasondesc1  where id=id1 ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Doc_Insert 
 (prjid1 integer, taskid1 integer, docid1 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  )  AS
begin
INSERT INTO Prj_Doc ( prjid, taskid, docid)  VALUES ( prjid1, taskid1, docid1) ;
end;
/






 CREATE or REPLACE PROCEDURE Prj_Find_Customer 
 (id_1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_Customer WHERE (prjid = id_1) ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_Material 
 (prjid1 	integer, taskid1 integer, version1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_Material WHERE (prjid = prjid1 and taskid = taskid1 and version LIKE  
concat(concat('%' , version1) , '%') ) order by material ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_MaterialProcess 
 (prjid1 	integer, taskid1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_MaterialProcess WHERE (prjid = prjid1 and taskid = taskid1  and ( isactived = '2' or isactived = '3' )) order by material ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_MaterialProcessbyid 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_MaterialProcess WHERE (id = id1) ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_Materialbyid 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_Material WHERE (id = id1);
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_Member 
 (prjid1 	integer, taskid1 integer, version1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_Member WHERE (prjid = prjid1 and taskid = taskid1 and version like 
concat(concat('%' , version1) , '%') ) order by relateid  ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Find_MemberHasRightByPrjid 
 (prjid1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT distinct * from Prj_MemberProcess WHERE (prjid = prjid1 and  isactived <> '1' ) order by relateid ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_MemberProcess 
 (prjid1 	integer, taskid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_MemberProcess WHERE (prjid = prjid1 and taskid = taskid1 and ( isactived = '2' or isactived = '3' ) ) order by relateid ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_MemberProcessByPrjid 
 (prjid1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT distinct * from Prj_MemberProcess WHERE (prjid = prjid1  and ( isactived = '2' or isactived = '3' ) ) order by relateid ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_MemberProcessbyid 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_MemberProcess WHERE (id = id1) ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_Memberbyid 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_Member WHERE (id = id1) ; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_RecentRemark 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT  * from
(select* from Prj_Log WHERE (projectid = id1) ORDER BY submitdate DESC, submittime DESC)
WHERE rownum<4;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_Tool 
 (prjid1 	integer, taskid1 integer, version1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_Tool WHERE (prjid = prjid1 and taskid = taskid1 and version like 
concat(concat('%' , version1) , '%') ) order by relateid ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_ToolProcess 
 (prjid1 	integer, taskid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_ToolProcess WHERE (prjid = prjid1 and taskid = taskid1 and ( isactived = '2' or isactived = '3' ) ) 
order by relateid ;
end;
/

 CREATE or REPLACE PROCEDURE Prj_Find_ToolProcessbyid 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_ToolProcess WHERE (id = id1) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Find_Toolbyid 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from Prj_Tool WHERE (id = id1) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Info_SelectCountByResource 
 (id_1 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) AS
begin
open thecursor for
SELECT count(*) from PRJ_ProjectInfo where manager = id_1 ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Jianbao_Insert 
 (projectid1 	integer, type1 	char , documentid1 	integer, content1 	varchar2, submitdate1 	varchar2, submittime1 	varchar2, submiter1	integer, submitertype1 smallint, clientip1 char, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	INSERT INTO Prj_Jianbao ( projectid, type, documentid, content, submitdate, submittime, submiter, submitertype, clientip) 
	VALUES ( projectid1, type1, documentid1, content1, submitdate1, submittime1, submiter1, submitertype1, clientip1) ;
	end;
/


 CREATE or REPLACE PROCEDURE Prj_Jianbao_Select 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_Jianbao WHERE ( projectid	 = id1) ORDER BY submitdate DESC, submittime DESC ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Log_Insert 
 (projectid1 	integer, logtype1 	char , documentid1 	integer, logcontent1 	varchar2, submitdate1 	varchar2, submittime1 	varchar, submiter1	integer, submitertype1 	smallint, clientip1	char, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS 
	begin
	INSERT INTO Prj_Log ( projectid, logtype, documentid, logcontent, submitdate, submittime, submiter, submitertype, clientip)  
	VALUES ( projectid1, logtype1, documentid1, logcontent1, submitdate1, submittime1, submiter1, submitertype1, clientip1); 
end;
/




 CREATE or REPLACE PROCEDURE Prj_Log_Select 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_Log WHERE ( projectid	 = id1) ORDER BY submitdate DESC, submittime DESC ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_MaterialProcess_Delete 
 (id1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
	update Prj_MaterialProcess set isactived = '1'  WHERE ( id = id1 ) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_MaterialProcess_Insert 
 (prjid1 	integer, taskid1 integer, material1 	 varchar2, unit1 	 varchar2, isactived1 smallint, begindate1 	varchar2, enddate1 varchar2, quantity1 integer, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
	AS 
	begin
	INSERT INTO Prj_MaterialProcess ( prjid, taskid, material, unit, isactived, begindate, enddate, quantity, cost)
	VALUES ( prjid1 , taskid1 , material1 	, unit1 	, isactived1, begindate1, enddate1, quantity1, cost1 ); 
end;
/


 CREATE or REPLACE PROCEDURE Prj_MaterialProcess_Update 
  (id1 integer,  material1 	 varchar2, unit1 	 varchar2,  begindate1 	varchar2, enddate1 varchar2, quantity1 integer, cost1 number,
   flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS
	begin
update Prj_MaterialProcess set material=material1, begindate=begindate1, enddate=enddate1, unit=unit1, quantity=quantity1, cost=cost1  WHERE ( id = id1)  ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Material_Delete 
 (id1 integer, version1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
	update Prj_Material set version=replace(version, version1, '')  WHERE ( id = id1) ;
	delete Prj_Material WHERE ( id = id1 and (version='' or version is null) ) ;
	end;
/




 CREATE or REPLACE PROCEDURE Prj_Material_Insert 
 (prjid1 	integer, taskid1 integer, material1 	 varchar2, unit1 	 varchar2, version1 varchar2, begindate1 	varchar2, enddate1 varchar2, 
 quantity1 integer, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS
	begin
INSERT INTO Prj_Material ( prjid, taskid, material, unit, version, begindate, enddate, quantity, cost) 
VALUES ( prjid1, taskid1 , material1 	, unit1 	, version1, begindate1, enddate1, quantity1, cost1 ) ;
INSERT INTO Prj_MaterialProcess ( prjid, taskid, material, unit, isactived)  
VALUES ( prjid1 , taskid1 , material1 	, unit1 	, '0');
end;
/


 CREATE or REPLACE PROCEDURE Prj_Material_SelectAllPlan 
 (prjid1 integer, version1 varchar2, material1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT t1.*,t2.wbscoding,t2.subject,t2.id   taskrecordid 
FROM Prj_Material  t1, Prj_TaskInfo  t2 
WHERE ( t1.prjid	 = prjid1 and t1.version like concat(concat('%|' , version1) , '|%') and t1.material = material1 and t2.prjid	 = prjid1 and t2.version = version1  and t1.taskid=t2.taskid ) order by t2.wbscoding; 
end;
/


 CREATE or REPLACE PROCEDURE Prj_Material_SelectAllProcess 
 (prjid1 integer, material1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT t1.*,t3.wbscoding,t3.subject,t2.id   taskrecordid 
FROM Prj_MaterialProcess   t1, Prj_TaskProcess   t2 , Prj_TaskInfo    t3
WHERE ( t1.prjid	 = prjid1 and ( t1.isactived = '2' or t1.isactived = '3' ) and t1.material = material1 and t2.prjid	 = prjid1
and ( t2.isactived = '2' or t2.isactived = '3' )  and t1.taskid=t2.taskid and t3.prjid = prjid1 and t3.taskid = t2.taskid
and t3.version =t2.version ) order by t3.wbscoding ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Material_SumPlan 
 (prjid1 integer, version1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT material, sum(quantity)   quantity, sum(cost*quantity)   cost FROM Prj_Material 
WHERE ( prjid	 = prjid1 and version like concat(concat('%|' , version1) , '|%') ) group by material;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Material_SumProcess 
 (prjid1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT material, sum(quantity)   quantity, sum(cost*quantity)   cost FROM Prj_MaterialProcess
WHERE ( prjid	 = prjid1 and ( isactived = '2' or isactived = '3' ) ) group by material ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Material_Update 
 (id1 integer, version1 varchar2 , prjid1 	integer, taskid1 integer, material1 	 varchar2, unit1 	 varchar2,  begindate1 	varchar2, 
 enddate1 varchar2, quantity1 integer, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS
	begin
update Prj_Material set version=replace(version, version1, '')  
WHERE ( id = id1);
delete Prj_Material WHERE ( id = id1 and (version='' OR version is null) );  
INSERT INTO Prj_Material ( prjid, taskid, material, unit, version, begindate, enddate, quantity, cost)
VALUES ( prjid1 , taskid1 , material1 	, unit1 	, version1, begindate1, enddate1, quantity1, cost1 );
end;
/


 CREATE or REPLACE PROCEDURE Prj_MemberProcess_Delete 
 (id1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS
	begin
	update Prj_MemberProcess set isactived = '1'  WHERE ( id = id1) ;
	end;
/


 CREATE or REPLACE PROCEDURE Prj_MemberProcess_Insert 
 (prjid1 	integer, taskid1 integer, relateid1 	integer,  isactived1 smallint, begindate1 	varchar2, enddate1 varchar2, workday1 number, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
	AS
	begin
	INSERT INTO Prj_MemberProcess ( prjid, taskid, relateid, isactived, begindate, enddate, workday, cost)  
	VALUES ( prjid1 , taskid1 , relateid1 , isactived1 , begindate1, enddate1, workday1, cost1 );
	end;
/



 CREATE or REPLACE PROCEDURE Prj_MemberProcess_Update 
  (id1 integer,  relateid1 	integer,  begindate1 	varchar2, enddate1 varchar2, workday1 number, cost1 number,
  flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
update Prj_MemberProcess set relateid=relateid1, begindate=begindate1, 
enddate=enddate1, workday=workday1, cost=cost1  WHERE ( id = id1);
end;
/

 CREATE or REPLACE PROCEDURE Prj_Member_Delete 
 (id1 integer, version1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
	AS
	begin
	update Prj_Member set version=replace(version, version1, '')  WHERE ( id = id1);
	delete Prj_Member WHERE ( id = id1 and (version='' OR version is null) ) ;
	end;
/



 CREATE or REPLACE PROCEDURE Prj_Member_Insert 
 (prjid1 	integer, taskid1 integer, relateid1 	integer, 
 version1 varchar2, begindate1 	varchar2, enddate1 varchar2, workday1 number, cost1 number,
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
begin
INSERT INTO Prj_Member ( prjid, taskid, relateid, version, begindate, enddate, workday, cost)
VALUES ( prjid1 , taskid1 , relateid1 	, version1, begindate1, enddate1, workday1, cost1 );  
INSERT INTO Prj_MemberProcess ( prjid, taskid, relateid, isactived)  VALUES ( prjid1 , taskid1 , relateid1 , '0') ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Member_SelectAllPlan 
 (prjid1 integer, version1 varchar2, relateid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for

SELECT t1.*,t2.wbscoding,t2.subject,t2.id   taskrecordid 
FROM Prj_Member   t1, Prj_TaskInfo   t2 
WHERE ( t1.prjid	 = prjid1 and t1.version like concat(concat('%|' , version1) , '|%') 
and t1.relateid = relateid1 and t2.prjid	 = prjid1
and t2.version = version1  and t1.taskid=t2.taskid ) order by t2.wbscoding  ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Member_SelectAllProcess 
 (prjid1 integer, hrmid1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_TaskProcess WHERE ( prjid	 = prjid1 and  parenthrmids like 
concat(concat('%,',hrmid1),'|%')  and isdelete<>'1') 
order by parentids ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Member_SelectSumByMember 
 (id_1	 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS 
	begin
	open thecursor for
select count(distinct(t1.id)) from prj_projectinfo t1,prj_taskprocess t2 
where ( t2.hrmid=id_1 and t2.prjid=t1.id and t1.isblock=1 ) or t1.manager=id_1;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Member_SumPlan 
 (prjid1 integer, version1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT relateid, sum(workday)   workday, min(begindate)   begindate, max(enddate)   enddate, 
sum(cost*workday)   cost FROM Prj_Member
WHERE ( prjid	 = prjid1 and version like concat(concat('%|' , version1) , '|%') ) group by relateid ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Member_SumProcess 
 (prjid1 integer, hrmid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	begin
if hrmid1 = 0 then
open thecursor for

SELECT hrmid,  min(begindate)   begindate1, max(enddate)   enddate1 FROM Prj_TaskProcess
WHERE ( prjid	 = prjid1  and isdelete <> 1 ) group by hrmid ; 
else
open thecursor for
SELECT hrmid,  min(begindate)   begindate1, max(enddate)   enddate1 FROM Prj_TaskProcess
WHERE ( prjid	 = prjid1  and isdelete <> 1 and hrmid=hrmid1) group by hrmid; 
end if;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Member_Update 
  (id1 integer, version1 varchar2, prjid1 	integer, taskid1 integer, 
  relateid1 	integer,  begindate1 	varchar2, enddate1 varchar2, 
  workday1 number, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
update Prj_Member set version=replace(version, version1, '')  WHERE ( id = id1) ;
delete Prj_Member WHERE ( id = id1 and (version='' OR version is null) );  
INSERT INTO Prj_Member ( prjid, taskid, relateid, version, begindate, enddate, workday, cost) 
VALUES ( prjid1 , taskid1 , relateid1 	, version1, begindate1, enddate1, workday1, cost1 );
end;
/

 CREATE or REPLACE PROCEDURE Prj_Modify_Insert 
 (projectid_1 	integer, 
 type_2 	char ,
 fieldname_3 	varchar2, 
 modifydate_4 	varchar2,
 modifytime_5 	varchar2,
 original_6 	varchar2, 
 modified_7 	varchar2, 
 modifier_8 	integer,
 submitertype1 	smallint, 
 clientip_9 	char , 	
 flag out integer ,
	 msg out varchar2,

	thecursor IN OUT cursor_define.weavercursor)  
	AS
	begin
	INSERT INTO Prj_Modify ( projectid, type, fieldname, modifydate, modifytime, original, modified, modifier, submitertype, clientip)
	VALUES ( projectid_1, type_2, fieldname_3, modifydate_4, modifytime_5, original_6, modified_7, modifier_8, submitertype1, clientip_9);
	end;
/



 CREATE or REPLACE PROCEDURE Prj_Modify_Select 
 (id_1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_Modify WHERE ( projectid	 = id_1) ORDER BY modifydate DESC, modifytime DESC ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_PlanInfo_Delete 
 (id_1 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS
	begin
	DELETE Prj_PlanInfo  WHERE ( id	 = id_1) ;
	end;
/

 CREATE or REPLACE PROCEDURE Prj_PlanInfo_Insert 
 (prjid_1 	integer, subject_2 	varchar2, begindate_3 	varchar2, enddate_4 	varchar2, 
 begintime_5 	varchar2, endtime_6 	varchar2, resourceid_7 	integer, content_8 	varchar2,
 budgetmoney_9 	varchar2, docid_10 	integer, plansort_11 	integer,
 plantype_12 	integer, validate_13 	smallint,	 
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  ) 
	AS
	begin
	INSERT INTO Prj_PlanInfo ( prjid, subject, begindate, enddate, begintime, endtime, resourceid, content, budgetmoney, docid, plansort, plantype, validate_n) 
	VALUES ( prjid_1, subject_2, begindate_3, enddate_4, begintime_5, endtime_6, resourceid_7, content_8, budgetmoney_9, docid_10, plansort_11, plantype_12, validate_13) ;
	end;
/


 CREATE or REPLACE PROCEDURE Prj_PlanInfo_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_PlanInfo;
end;
/


 CREATE or REPLACE PROCEDURE Prj_PlanInfo_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_PlanInfo WHERE ( id	 = id1);
end;
/


 CREATE or REPLACE PROCEDURE Prj_PlanInfo_Update 
 (id_1 	integer, subject_2 	varchar2, begindate_3 	varchar2, enddate_4 	varchar2, begintime_5 	varchar2, 
 endtime_6 	varchar2, resourceid_7 	integer, content_8 	varchar2, budgetmoney_9 	varchar2, docid_10 	integer,
 plansort_11 	integer, plantype_12 	integer, updatedate_13 	varchar2, 
 updatetime_14 	varchar2, updater_15 	integer, validate_16 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
	AS 
	begin
	UPDATE Prj_PlanInfo  SET  subject	 = subject_2, begindate	 = begindate_3, 
	enddate	 = enddate_4, begintime	 = begintime_5, endtime	 = endtime_6, resourceid	 = resourceid_7, 
	content	 = content_8, budgetmoney	 = budgetmoney_9, docid	 = docid_10, plansort	 = plansort_11,
	plantype	 = plantype_12, updatedate	 = updatedate_13, updatetime	 = updatetime_14, 
	updater	 = updater_15, validate_n	 = validate_16  WHERE ( id	 = id_1) ;
	end;
/




 CREATE or REPLACE PROCEDURE Prj_PlanInfo_Validate 
 (id_1 	integer, validate_16 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
	AS
	begin
	UPDATE Prj_PlanInfo  SET validate_n	 = validate_16  WHERE ( id	 = id_1) ;
	end;
/





 CREATE or REPLACE PROCEDURE Prj_PlanSort_Delete 
 (id1	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	DELETE Prj_PlanSort  WHERE ( id	 = id1) ;
	end;
/

 CREATE or REPLACE PROCEDURE Prj_PlanSort_Insert 
 (fullname1 	varchar2, description1 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS
	begin
	INSERT INTO Prj_PlanSort ( fullname, description)  VALUES ( fullname1, description1)  ;
	end;
/



 CREATE or REPLACE PROCEDURE Prj_PlanSort_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_PlanSort ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_PlanSort_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_PlanSort WHERE ( id	 = id1);
end;
/



 CREATE or REPLACE PROCEDURE Prj_PlanSort_Update 
 (id1	 	integer, fullname1 	varchar2, description1 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS 
	begin
	UPDATE Prj_PlanSort  SET  fullname	 = fullname1, description	 = description1  WHERE ( id	 = id1) ;
	end;
/

 CREATE or REPLACE PROCEDURE Prj_PlanType_Delete 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	DELETE Prj_PlanType  WHERE ( id	 = id1) ;
	end;
/




 CREATE or REPLACE PROCEDURE Prj_PlanType_Insert 
 (fullname1 	varchar2, description1 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	INSERT INTO Prj_PlanType ( fullname, description)  VALUES ( fullname1, description1) ;
	end;
/




 CREATE or REPLACE PROCEDURE Prj_PlanType_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_PlanType;
end;
/


 CREATE or REPLACE PROCEDURE Prj_PlanType_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_PlanType WHERE ( id	 = id1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_PlanType_Update 
 (id1	 	integer, fullname1 	varchar2, description1 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS 
	begin
	UPDATE Prj_PlanType  SET  fullname	 = fullname1, description	 = description1  WHERE ( id	 = id1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Plan_Approve 
(prjid_1 	integer,  
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )  
 AS 
 
		taskid_1 	integer;
		wbscoding_1 	varchar2(20); 
		subject_1 	varchar2(50);
		begindate_1 	varchar2(10); 
		enddate_1 	varchar2(10);
		workday_1        number (10,1); 
		content_1 	varchar2(255); 
		fixedcost_1	number(10,2);
		parentid_1	integer;
		parentids_1	varchar2(255);
		parenthrmids_1	varchar2(255);
		level_1		smallint;
		hrmid_1		integer;
		

CURSOR all_cursor is	
select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost,
parentid, parentids, parenthrmids, level_n, hrmid from Prj_TaskProcess where prjid = prjid_1; 

begin
open all_cursor;
loop
	fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1,
	workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1;
	exit when all_cursor%NOTFOUND;	

	INSERT INTO Prj_TaskInfo (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid,
	parentids, parenthrmids, level_n, hrmid, isactived, version)  
	VALUES (  prjid_1, taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1,
	workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1,2,1);
end  loop;
 
CLOSE all_cursor;
end;
/







CREATE or REPLACE PROCEDURE Prj_Plan_SaveFromProcess 
(prjid_1 	integer, 
 version_1	smallint,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )    
 AS 
 
		taskid_1 	integer;
		wbscoding_1 	varchar2(20); 
		subject_1 	varchar2(50); 
		begindate_1 	varchar2(10); 
		enddate_1 	varchar2(10); 
		workday_1        number (10,1); 
		content_1 	varchar2(255);
		fixedcost_1	number(10,2);
		parentid_1	integer;
		parentids_1	varchar2(255);
		parenthrmids_1	varchar2(255);
		level_1		smallint;
		hrmid_1		integer;

CURSOR all_cursor is
select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, 
parentid, parentids, parenthrmids, level_n, hrmid 
from Prj_TaskProcess where prjid = prjid_1; 

begin
open all_cursor;
loop
	fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1,
	workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1;
	exit when all_cursor%NOTFOUND;	

        INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content,
	fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version)  
	VALUES (  prjid_1, taskid_1 , wbscoding_1, subject_1 , begindate_1, enddate_1, workday_1,
	content_1, fixedcost_1, parentid_1, parentids_1, parenthrmids_1, level_1, hrmid_1,'1',version_1);
end  loop;


CLOSE all_cursor;
end;
/





 CREATE or REPLACE PROCEDURE Prj_Plan_Submit 
 (prjid1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
UPDATE Prj_TaskProcess  SET isactived	 = '1'  WHERE ( prjid	 = prjid1 ) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Process_SumCostMaterial 
 (prjid1 integer, wbscoding1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT sum(t3.quantity*t3.cost)   cost FROM Prj_TaskProcess   t1, Prj_TaskInfo   t2, Prj_MaterialProcess   t3
WHERE ( t1.prjid = prjid1 and t1.isactived <> '0' and t1.isactived <> '1' and t2.prjid = prjid1
and t1.taskid = t2.taskid  and t1.version	 = t2.version and t2.wbscoding like concat(wbscoding1,'%') 
and t3.prjid = prjid1 and t3.taskid = t1.taskid and (t3.isactived = '2' or t3.isactived = '3')) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Process_SumCostMember 
 (prjid1 integer, wbscoding1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT sum(t3.workday*t3.cost)   cost FROM Prj_TaskProcess   t1, Prj_TaskInfo   t2, Prj_MemberProcess   t3
WHERE ( t1.prjid = prjid1 and t1.isactived <> '0' and t1.isactived <> '1' 
and t2.prjid = prjid1 and t1.taskid = t2.taskid  and t1.version	 = t2.version 
and t2.wbscoding like concat(wbscoding1,'%') and t3.prjid = prjid1 and t3.taskid = t1.taskid 
and (t3.isactived = '2' or t3.isactived = '3')) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Process_SumCostTool 
 (prjid1 integer, wbscoding1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT sum(t3.workday*t3.cost)   cost FROM Prj_TaskProcess   t1, Prj_TaskInfo   t2, Prj_ToolProcess   t3
WHERE ( t1.prjid = prjid1 and t1.isactived <> '0' and t1.isactived <> '1' and t2.prjid = prjid1
and t1.taskid = t2.taskid  and t1.version	 = t2.version and t2.wbscoding like concat(wbscoding1,'%') 
and t3.prjid = prjid1 and t3.taskid = t1.taskid and (t3.isactived = '2' or t3.isactived = '3')) ;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProcessingType_Delete 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS 
	begin
	DELETE Prj_ProcessingType  WHERE ( id	 = id1) ;
	end;
/





 CREATE or REPLACE PROCEDURE Prj_ProcessingType_Insert 
 (fullname1 	varchar2, description1 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	INSERT INTO Prj_ProcessingType ( fullname, description)  VALUES ( fullname1, description1);
	end;
/




 CREATE or REPLACE PROCEDURE Prj_ProcessingType_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_ProcessingType;
end;
/



 CREATE or REPLACE PROCEDURE Prj_ProcessingType_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_ProcessingType WHERE ( id	 = id1) ;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProcessingType_Update 
 (id1	 	integer, fullname1 	varchar2, description1 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	UPDATE Prj_ProcessingType  SET  fullname	 = fullname1, description	 = description1  WHERE ( id	 = id1) ;
	end;
/



 CREATE or REPLACE PROCEDURE Prj_Processing_Archive 
 (id_1 	integer, isprocessed_2 	smallint, processdate_3 	varchar2, 
 processtime_4 	varchar2, processor_5 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
	UPDATE Prj_Processing  SET  isprocessed	 = isprocessed_2, processdate	 = processdate_3, processtime	 = processtime_4, processor	 = processor_5  WHERE ( id	 = id_1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Processing_Insert 
 (prjid_1 	integer, planid_2 	integer, title_3 	varchar2, content_4 	varchar2,
 type_5 	integer, docid1 	integer, parentids_6  IN OUT	varchar2, submitdate_7 	varchar2,
 submittime_8 	varchar2, submiter_9 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
	AS

	 count1 integer ;
	 count_01 integer;
	 begin
	select count(id) INTO count_01 from  Prj_Processing ;
	if  count_01>0 then

	
	select max(id) INTO count1 from  Prj_Processing ;
	end if;
	count1 := count1 + 1;
	 parentids_6 := concat(concat(parentids_6,','), to_char(count1))  ;
	INSERT INTO Prj_Processing ( prjid, planid, title, content, type, docid, parentids, submitdate, submittime, submiter) 
	VALUES ( prjid_1, planid_2, title_3, content_4, type_5, docid1, parentids_6, submitdate_7, submittime_8, submiter_9)  ;
	end;
/

 CREATE or REPLACE PROCEDURE Prj_Processing_SelectAll 
 ( prjid1	integer, parentids1	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_Processing where ( prjid	 = prjid1) and (parentids like parentids1) order by parentids ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Processing_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_Processing WHERE ( id	 = id1);
end;
/


 CREATE or REPLACE PROCEDURE Prj_Processing_Update 
 (id_1 	integer, title_2 	varchar2, content_3 	varchar2, type_4 	integer, docid1 	integer, 
 updatedate_5 	varchar2, updatetime_6 	varchar2, updater_7 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
	AS 
	begin
	UPDATE Prj_Processing  SET  title	 = title_2, content	 = content_3, type	 = type_4, docid	 = docid1, 
	updatedate	 = updatedate_5, updatetime	 = updatetime_6, updater	 = updater_7 
	WHERE ( id	 = id_1) ;
	end;
/





 CREATE or REPLACE PROCEDURE Prj_ProjectInfo_Insert 
 (name_1 	varchar2, description_2 	varchar2,
 prjtype_3 	integer, worktype_4 	integer, securelevel_5 integer, 
 status_6 	integer, isblock_7 	smallint, managerview_8 	smallint, 
 parentview_9 	smallint, budgetmoney_10 	varchar2, moneyindeed_11 	varchar2, 
 budgetincome_12 	varchar2, imcomeindeed_13 	varchar2, planbegindate_14 	varchar2, 
 planbegintime_15 	varchar2, planenddate_16 	varchar2, planendtime_17 	varchar2,
 truebegindate_18 	varchar2, truebegintime_19 	varchar2, trueenddate_20 	varchar2,
 trueendtime_21 	varchar2, planmanhour_22 	integer, truemanhour_23 	integer, 
 picid_24 	integer, intro_25 	varchar2, parentid_26 	integer, envaluedoc_27 	integer,
 confirmdoc_28 	integer, proposedoc_29 	integer, manager_30 	integer, department_31 	integer, 
 subcompanyid1 	integer, creater_32 	integer, createdate_33 	varchar2, createtime_34 	varchar2,
 isprocessed_35 	smallint, processer_36 	integer, processdate_37 	varchar2, processtime_38 	varchar2,
 datefield1_39 	varchar2, datefield2_40 	varchar2, datefield3_41 	varchar2, datefield4_42 	varchar2, 
 datefield5_43 	varchar2, numberfield1_44 	float, numberfield2_45 	float, numberfield3_46 	float,
 numberfield4_47 	float, numberfield5_48 	float, textfield1_49 	varchar2,
 textfield2_50 	varchar2, textfield3_51 	varchar2, textfield4_52 	varchar2, textfield5_53 	varchar2, 
 boolfield1_54 	smallint, boolfield2_55 	smallint, boolfield3_56 	smallint, boolfield4_57 	smallint, 
 boolfield5_58 	smallint, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS 
	begin
	INSERT INTO Prj_ProjectInfo ( name, description, prjtype, worktype, securelevel, status, isblock, managerview, parentview,
	budgetmoney, moneyindeed, budgetincome, imcomeindeed, planbegindate, planbegintime, planenddate, planendtime, truebegindate,
	truebegintime, trueenddate, trueendtime, planmanhour, truemanhour, picid, intro, parentid, envaluedoc, confirmdoc, proposedoc,
	manager, department, subcompanyid1, creater, createdate, createtime, isprocessed, processer, processdate, processtime, datefield1,
	datefield2, datefield3, datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1,
	textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5) 
	VALUES ( name_1, description_2, prjtype_3, worktype_4, securelevel_5, status_6, isblock_7, managerview_8, parentview_9,
	to_number(budgetmoney_10), to_number(moneyindeed_11), to_number(budgetincome_12), to_number(imcomeindeed_13),
planbegindate_14, planbegintime_15, planenddate_16, planendtime_17, truebegindate_18, truebegintime_19, trueenddate_20,
trueendtime_21, planmanhour_22, truemanhour_23, picid_24, intro_25, parentid_26, envaluedoc_27, confirmdoc_28, proposedoc_29, manager_30, department_31, subcompanyid1, creater_32, createdate_33, createtime_34, isprocessed_35, processer_36, processdate_37,
processtime_38, datefield1_39, datefield2_40, datefield3_41, datefield4_42, datefield5_43, numberfield1_44, numberfield2_45,
numberfield3_46, numberfield4_47, numberfield5_48, textfield1_49, textfield2_50, textfield3_51, textfield4_52, textfield5_53,
boolfield1_54, boolfield2_55, boolfield3_56, boolfield4_57, boolfield5_58) ;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProjectInfo_InsertID 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
begin
open thecursor for
SELECT  id  from( select id from Prj_ProjectInfo ORDER BY id DESC ) WHERE rownum=1;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProjectInfo_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_ProjectInfo;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProjectInfo_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_ProjectInfo WHERE ( id	 = id1) ;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProjectInfo_Update 
 (id_1 	integer, name_2 	varchar2, description_3 	varchar2, prjtype_4 	integer, worktype_5 	integer, 
 securelevel_6 	integer, status_7 	integer, isblock_8 	smallint, managerview_9 	smallint, parentview_10 	smallint,
 budgetmoney_11 	varchar2, moneyindeed_12 	varchar2, budgetincome_13 	varchar2, imcomeindeed_14 	varchar2, 
 planbegindate_15 	varchar2, planbegintime_16 	varchar2, planenddate_17 	varchar2, planendtime_18 	varchar2,
 truebegindate_19 	varchar2, truebegintime_20 	varchar2, trueenddate_21 	varchar2, trueendtime_22 	varchar2, 
 planmanhour_23 	integer, truemanhour_24 	integer, picid_25 	integer, intro_26 	varchar2, parentid_27 	integer,
 envaluedoc_28 	integer, confirmdoc_29 	integer, proposedoc_30 	integer, manager_31 	integer, department_32 	integer, 
 subcompanyid12 	integer, datefield1_40 	varchar2, datefield2_41 	varchar2, datefield3_42 	varchar2, 
 datefield4_43 	varchar2, datefield5_44 	varchar2, numberfield1_45 	float, numberfield2_46 	float, 
 numberfield3_47 	float, numberfield4_48 	float, numberfield5_49 	float, textfield1_50 	varchar2,
 textfield2_51 	varchar2, textfield3_52 	varchar2, textfield4_53 	varchar2, textfield5_54 	varchar2, boolfield1_55 	smallint, boolfield2_56 	smallint, boolfield3_57 	smallint, boolfield4_58 	smallint, boolfield5_59 	smallint, 	 
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS 
	begin
	UPDATE Prj_ProjectInfo  SET  name	 = name_2, description	 = description_3, prjtype	 = prjtype_4, 
	worktype	 = worktype_5, securelevel	 = securelevel_6, status	 = status_7, isblock	 = isblock_8,
	managerview	 = managerview_9, parentview	 = parentview_10, 
	budgetmoney	 = to_number(budgetmoney_11), 
	moneyindeed	 = to_number(moneyindeed_12),
	budgetincome	 = to_number(budgetincome_13), 
	imcomeindeed	 = to_number(imcomeindeed_14),
	planbegindate	 = planbegindate_15, 
	planbegintime	 = planbegintime_16, planenddate	 = planenddate_17, 
	planendtime	 = planendtime_18, truebegindate	 = truebegindate_19, truebegintime	 = truebegintime_20, 
	trueenddate	 = trueenddate_21, trueendtime	 = trueendtime_22, planmanhour	 = planmanhour_23, 
	truemanhour	 = truemanhour_24, picid	 = picid_25, intro	 = intro_26, parentid	 = parentid_27, envaluedoc	 = envaluedoc_28, 
	confirmdoc	 = confirmdoc_29, proposedoc	 = proposedoc_30, manager	 = manager_31, department	 = department_32, 
	subcompanyid1 = subcompanyid12, datefield1	 = datefield1_40, datefield2	 = datefield2_41, 
	datefield3	 = datefield3_42, datefield4	 = datefield4_43, datefield5	 = datefield5_44, 
	numberfield1	 = numberfield1_45, numberfield2	 = numberfield2_46, numberfield3	 = numberfield3_47, 
	numberfield4	 = numberfield4_48, numberfield5	 = numberfield5_49, textfield1	 = textfield1_50, 
	textfield2	 = textfield2_51, textfield3	 = textfield3_52, textfield4	 = textfield4_53,
	textfield5	 = textfield5_54, tinyintfield1	 = boolfield1_55, tinyintfield2	 = boolfield2_56, 
	tinyintfield3	 = boolfield3_57, tinyintfield4	 = boolfield4_58, tinyintfield5	 = boolfield5_59
	WHERE ( id	 = id_1); 
end;
/



 CREATE or REPLACE PROCEDURE Prj_ProjectStatus_Delete 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	DELETE Prj_ProjectStatus  WHERE ( id	 = id1) ;
	end;
/




 CREATE or REPLACE PROCEDURE Prj_ProjectStatus_Insert 
 (fullname1 	varchar2, description1 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS 
	begin
	INSERT INTO Prj_ProjectStatus ( fullname, description)  
	VALUES ( fullname1, description1)  ;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProjectStatus_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_ProjectStatus ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_ProjectStatus_SelectByID 
 (id1	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_ProjectStatus WHERE ( id	 = id1) ;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProjectStatus_Update 
 (id1	 	integer, fullname1 	varchar2, description1 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	UPDATE Prj_ProjectStatus  SET  fullname	 = fullname1, description	 = description1  WHERE ( id	 = id1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_ProjectType_Delete 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS 
	begin
	DELETE Prj_ProjectType  WHERE ( id	 = id1)  ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_ProjectType_Insert 
 (fullname1 	varchar2, description1 	varchar2, wfid1	 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	INSERT INTO Prj_ProjectType ( fullname, description, wfid)  
	VALUES ( fullname1, description1, wfid1)  ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_ProjectType_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_ProjectType;
end;
/




 CREATE or REPLACE PROCEDURE Prj_ProjectType_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_ProjectType WHERE ( id	 = id1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_ProjectType_Update 
 (id1	 	integer, fullname1 	varchar2, description1 	varchar2, wfid1	 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS 
	begin
	UPDATE Prj_ProjectType  SET  fullname	 = fullname1, description	 = description1, wfid	 = wfid1  WHERE ( id	 = id1) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Request_Insert 
 (prjid1 	integer, taskid1 	integer, requestid1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  )  AS 
	begin
INSERT INTO Prj_Request ( prjid, taskid, requestid)  VALUES ( prjid1, taskid1, requestid1) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_RpSum 
 (
 optional2	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)
AS
begin

if  optional2='projecttype' then
open thecursor for
select prjtype   resultid, COUNT(id)   resultcount from Prj_Projectinfo  group by prjtype order by resultcount ;
end if;
if  optional2='worktype' then
open thecursor for
select worktype   resultid,COUNT(id)   resultcount from Prj_Projectinfo  group by worktype order by resultcount  ;
end if;
if  optional2='projectstatus' then
open thecursor for
select status   resultid,COUNT(id)   resultcount from Prj_Projectinfo  group by status order by resultcount ;
end if;
if  optional2='manager' then
open thecursor for
select manager   resultid,COUNT(id)   resultcount from Prj_Projectinfo  group by manager order by resultcount ;
end if;
if  optional2='department' then
open thecursor for
select department   resultid,COUNT(id)   resultcount from Prj_Projectinfo  group by department order by resultcount ;
end if;
end;
/



 CREATE or REPLACE PROCEDURE Prj_SearchMould_Delete 
 (id_1 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
	DELETE Prj_SearchMould  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_SearchMould_Insert 
 (mouldname_1 	varchar2, userid_2 	integer, 
 prjid_3 	varchar2, status_4 	varchar2, prjtype_5 	varchar2, 
 worktype_6 	integer, nameopt_7 	integer, name_8 	varchar2, 
 description_9 	varchar2, customer_10 	integer, parent_11 	integer,
 securelevel_12 	integer, department_13 	integer, manager_14 	integer,
 member_15 	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
	AS 
	begin
	INSERT INTO Prj_SearchMould
    
	( mouldname, userid, prjid, status, prjtype, worktype, nameopt, name, description, customer, parent, securelevel, department, manager, member)
	VALUES ( mouldname_1, userid_2, prjid_3, status_4, prjtype_5, worktype_6, nameopt_7, name_8, description_9, customer_10, parent_11, securelevel_12, department_13, manager_14, member_15) ;
	open thecursor for
	select max(id) from Prj_SearchMould;
end;
/


 CREATE or REPLACE PROCEDURE Prj_SearchMould_SelectByID 
 (
 id1 varchar2 , flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT * from Prj_SearchMould where id = to_number( id1);
end;
/



 CREATE or REPLACE PROCEDURE Prj_SearchMould_SelectByUserID 
 (
 id1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT * from  Prj_SearchMould where userid = to_number ( id1) ;
end;
/





 CREATE or REPLACE PROCEDURE Prj_SearchMould_Update  
 (id_1 	integer, userid_2 	integer, prjid_3 	varchar2, status_4 	varchar2, prjtype_5 	varchar2, worktype_6 	integer, 
 nameopt_7 	integer, name_8 	varchar2, description_9 	varchar2, customer_10 	integer, parent_11 	integer,
 securelevel_12 	integer, department_13 	integer, manager_14 	integer, member_15 	integer,	
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
	AS
	begin
	UPDATE Prj_SearchMould  SET  userid	 = userid_2, prjid	 = prjid_3, status	 = status_4,
	prjtype	 = prjtype_5, worktype	 = worktype_6, nameopt	 = nameopt_7, name	 = name_8, 
	description	 = description_9, customer	 = customer_10, parent	 = parent_11, 
	securelevel	 = securelevel_12, department	 = department_13, 
	manager	 = manager_14, member	 = member_15 
	WHERE ( id	 = id_1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_ShareInfo_Delete 
  (id1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
  AS 
  begin
  DELETE from Prj_ShareInfo  WHERE ( id = id1)  ;
 end;
/



 CREATE or REPLACE PROCEDURE Prj_ShareInfo_Insert 
  (relateditemid1 integer, sharetype1 smallint, seclevel1  smallint, rolelevel1 smallint, sharelevel1 smallint, 
  userid1 integer, departmentid1 integer, roleid1 integer, foralluser1 smallint,	
  flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
  AS 
  begin
  INSERT INTO Prj_ShareInfo 
  ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser )  
  VALUES 
  ( relateditemid1 , sharetype1 , seclevel1 , rolelevel1 , sharelevel1, userid1, departmentid1, roleid1, foralluser1  ) ;
 end;
/



 CREATE or REPLACE PROCEDURE Prj_ShareInfo_SbyRelateditemid 
  (relateditemid1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  begin
open thecursor for
  select * from Prj_ShareInfo where ( relateditemid = relateditemid1 ) order by sharetype;
end;
/



 CREATE or REPLACE PROCEDURE Prj_ShareInfo_SelectbyID 
  (id1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  begin
open thecursor for
  select * from Prj_ShareInfo where (id = id1 ) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskInfo_Approve 
 (prjid1 integer, version1 smallint, isactived1 smallint,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin

UPDATE Prj_TaskInfo  SET isactived	 = isactived1  WHERE ( prjid	 = prjid1 and version	 = version1 ) ;

if isactived1 ='2' then 

UPDATE Prj_TaskProcess  SET isactived	 = '1', version=version1  WHERE ( prjid	 = prjid1 and isactived	 = '3'  );
UPDATE Prj_TaskProcess  SET isactived	 = '2', version=version1  WHERE ( prjid	 = prjid1 and isactived	 <> '1'  );
UPDATE Prj_MemberProcess  SET isactived	 = '2'  WHERE ( prjid	 = prjid1 and isactived	 = '0'  );
UPDATE Prj_ToolProcess  SET isactived	 = '2'  WHERE ( prjid	 = prjid1 and isactived	 = '0'  );
UPDATE Prj_MaterialProcess  SET isactived	 = '2'  WHERE ( prjid	 = prjid1 and isactived	 = '0'  );
update Prj_MemberProcess set isactived='1'  WHERE ( prjid	 = prjid1 and isactived='3'  )  ;
update Prj_ToolProcess set isactived='1'  WHERE ( prjid	 = prjid1 and isactived='3'  )  ;
update Prj_MaterialProcess set isactived='1'  WHERE ( prjid	 = prjid1 and isactived='3'  );  

end if;
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskInfo_DeleteByID 
 (id1 	integer, prjid1 integer, version1 varchar2, taskid1 integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin

delete Prj_TaskInfo  WHERE ( id	 = id1)  ;
update Prj_TaskProcess set isactived='3'  WHERE ( prjid	 = prjid1 and taskid = taskid1 and version<>version1  )  ;
delete Prj_TaskProcess WHERE ( prjid = prjid1  and taskid = taskid1 and version=version1 ) ;
update Prj_Member set version=replace(version,concat(concat( '|',version1),'|'), '')
WHERE ( prjid	 = prjid1 and taskid = taskid1  )  ;
delete Prj_Member WHERE ( prjid = prjid1  and taskid = taskid1 and (version='' OR version is null) )  ;
update Prj_Tool set version=replace(version, concat(concat( '|',version1),'|'), '')  WHERE ( prjid	 = prjid1 and taskid = taskid1 );  
delete Prj_Tool WHERE ( prjid	 = prjid1  and taskid = taskid1 and (version='' OR version is null) ) ;
update Prj_Material set version=replace(version, concat(concat( '|',version1),'|'), '')  WHERE ( prjid	 = prjid1 and taskid = taskid1 ) ; 
delete Prj_Material WHERE ( prjid	 = prjid1  and taskid = taskid1 and (version='' OR version is null) )  ;
delete Prj_MemberProcess WHERE ( prjid = prjid1  and taskid = taskid1 and isactived='0' );  
update Prj_MemberProcess set isactived='3'  WHERE ( prjid	 = prjid1 and taskid = taskid1 and isactived<>'1'  ) ; 
delete Prj_ToolProcess WHERE ( prjid = prjid  and taskid = taskid and isactived='0' ) ;
update Prj_ToolProcess set isactived='3'  WHERE ( prjid	 = prjid1 and taskid = taskid1 and isactived<>'1'  );  
delete Prj_MaterialProcess WHERE ( prjid = prjid1  and taskid = taskid1 and isactived='0' ) ;
update Prj_MaterialProcess set isactived='3'  WHERE ( prjid	 = prjid1 and taskid = taskid1 and isactived<>'1'  ) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskInfo_DeleteByVesion 
 (prjid1 integer, version1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
delete Prj_TaskInfo  WHERE ( prjid	 = prjid1 and version	 = version1 ) ;
delete Prj_TaskProcess  WHERE ( prjid	 = prjid1 and version	 = version1 ); 
update Prj_TaskProcess set isactived='2'  
WHERE ( prjid	 = prjid1 and version<>version1 and isactived <> '1' ) ;
update Prj_Member set version=replace(version, concat(concat( '|',version1),'|'), '') 
WHERE ( prjid	 = prjid1 and version	 like 
concat(concat(concat('%' , '|'),version1), concat('|' , '%')) )  ;
delete Prj_Member WHERE ( prjid	 = prjid1 and (version='' OR version is null) );  
update Prj_Tool set version=replace(version, concat(concat( '|',version1),'|'), '') 
WHERE ( prjid	 = prjid1 and version	 like 
concat(concat(concat('%' , '|'),version1), concat('|' , '%')) )  ;
delete Prj_Tool WHERE ( prjid	 = prjid1 and (version='' OR version is null) ); 
update Prj_Material set version=replace(version, concat(concat( '|',version1),'|'), '') 
WHERE ( prjid	 = prjid1 and version	 like 
concat(concat(concat('%' , '|'),version1), concat('|' , '%')) )  ;
delete Prj_Material WHERE ( prjid	 = prjid1 and (version='' OR version is null) ) ;
delete Prj_MemberProcess WHERE ( prjid = prjid1  and isactived='0' ) ; 
delete Prj_ToolProcess WHERE ( prjid = prjid1   and isactived='0' ) ;
delete Prj_MaterialProcess WHERE ( prjid = prjid1  and isactived='0' ); 
update Prj_MemberProcess set isactived='2'  WHERE ( prjid	 = prjid1 and isactived='3'  ) ; 
update Prj_ToolProcess set isactived='2'  WHERE ( prjid	 = prjid1 and isactived='3'  )  ;
update Prj_MaterialProcess set isactived='2'  WHERE ( prjid	 = prjid1 and isactived='3'  )  ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskInfo_Insert 
 (prjid1 	integer, taskid1 	integer,  wbscoding1 	varchar2, subject1 	varchar2, version1 	smallint, begindate1 	varchar2, enddate1 	varchar2, workday1 number, 
 content1	varchar2, fixedcost1 number, 	
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  )  AS 
	begin
INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost) 
VALUES ( prjid1, taskid1 , wbscoding1, subject1 , version1 , begindate1, enddate1, workday1, content1, fixedcost1); 
INSERT INTO Prj_TaskProcess ( prjid, taskid ,  version, begindate, enddate ) 
VALUES ( prjid1, taskid1 ,  version1, 'x', '-') ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskInfo_NewPlan 
( prjid_1 	  integer,  
oldversion_1  varchar2 , 
newversion_1  varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )  
 AS 
 	taskid_1 	integer;
		wbscoding_1 	varchar2(20); 
		subject_1 	varchar2(50); 
		version_1 	smallint;
		begindate_1 	varchar2(10); 
		enddate_1 	varchar2(10);
		workday_1        number (10,1); 
		content_1 	varchar2(255); 
		fixedcost_1	 number(10,2);
		temp_1		smallint;
		temp_count integer;



CURSOR all_cursor is
select  taskid , wbscoding, subject , begindate, enddate, workday, content, fixedcost from Prj_TaskInfo where prjid =prjid_1 
and version=temp_1;
begin 

select count(version) INTO  temp_count from prj_taskinfo where prjid=prjid_1;
if(temp_count>0)then
select max(version) INTO  temp_1 from prj_taskinfo where prjid=prjid_1;
 version_1 := temp_1 + 1;
 end if;
open all_cursor;
    loop
	fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1,
	workday_1,content_1,fixedcost_1;
	exit when all_cursor%NOTFOUND;	
	INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost)
	VALUES (prjid_1,taskid_1 ,wbscoding_1,subject_1 ,version_1 ,begindate_1,enddate_1,workday_1,content_1,fixedcost_1);
end  loop;
CLOSE all_cursor;

update Prj_Member set version = concat(version , newversion_1)   WHERE (prjid =prjid_1  and
version like   concat(concat('%' ,oldversion_1) , '%') );
update Prj_Tool set version = concat(version , newversion_1)   WHERE (prjid =prjid_1  and 
version like  concat(concat('%' ,oldversion_1) , '%') );
update Prj_Material set version = concat(version , newversion_1)   WHERE (prjid =prjid_1  and 
version like  concat(concat('%' ,oldversion_1) , '%') );
end;
/




 CREATE or REPLACE PROCEDURE Prj_TaskInfo_SelectAll 
 (prjid1 integer, version1 smallint, level_n1 smallint, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_TaskInfo WHERE ( prjid	 = prjid1 and version	 = version1 and level_n <= level_n1 and isdelete<>'1') order by parentids  ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskInfo_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_TaskInfo WHERE ( id	 = id1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskInfo_SelectMaxID 
 (prjid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT max(taskid) FROM Prj_TaskInfo WHERE ( prjid	 = prjid1 ) ;
end;
/




 CREATE or REPLACE PROCEDURE Prj_TaskInfo_SelectMaxVersion 
 (prjid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT isactived, version from ( SELECT isactived, version  FROM Prj_TaskInfo WHERE ( prjid	 = prjid1 ) order by version desc)
WHERE rownum =1;
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskInfo_Sum 
 (prjid1 integer, version1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT sum(workday)   workday, min(begindate)   begindate, max(enddate)   enddate FROM Prj_TaskInfo
WHERE ( prjid = prjid1 and parentid = '0' and version = version1   and isdelete<>'1');
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskInfo_SumCostMaterial 
 (prjid1 integer, version1 varchar2, wbscoding1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT sum(t2.quantity*t2.cost)   cost FROM Prj_TaskInfo   t1, Prj_Material   t2 
WHERE ( t1.prjid	 = prjid1 and t1.version	 = version1 and  t1.wbscoding like concat(wbscoding1,'%') 
and t1.taskid = t2.taskid and t2.prjid = prjid1  and t2.version like concat(concat('%|' , version1) , '|%') );
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskInfo_SumCostMember 
 (prjid1 integer, version1 varchar2, wbscoding1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT sum(t2.workday*t2.cost)   cost FROM Prj_TaskInfo   t1, Prj_Member   t2 
WHERE ( t1.prjid	 = prjid1 and t1.version	 = version1 and  t1.wbscoding like concat(wbscoding1,'%') 
and t1.taskid = t2.taskid and t2.prjid = prjid1  and t2.version like concat(concat('%|' , version1) , '|%')) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskInfo_SumCostTool 
 (prjid1 integer, version1 varchar2, wbscoding1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT sum(t2.workday*t2.cost)   cost FROM Prj_TaskInfo   t1, Prj_Tool   t2 
WHERE ( t1.prjid	 = prjid1 and t1.version	 = version1 and  t1.wbscoding LIKE concat(wbscoding1,'%') 
and t1.taskid = t2.taskid and t2.prjid = prjid1  and t2.version like concat(concat('%|' , version1) , '|%')) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskInfo_Update 
 (id1	integer, wbscoding1 varchar2, subject1 	varchar2, begindate1 	varchar2, enddate1 	varchar2,
 workday1 number, content1 	varchar2, fixedcost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS
	begin
	UPDATE Prj_TaskInfo  SET  wbscoding = wbscoding1, subject = subject1 , begindate = begindate1,
	enddate = enddate1 	, workday = workday1, content = content1, fixedcost = fixedcost1
	WHERE ( id	 = id1);
	end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskProcess_DeleteByID 
 (id1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
update Prj_TaskProcess set isdelete='1'  WHERE ( id	 = id1 or concat(',',parentids) like 
concat (concat('%,',id1),',%')) ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskProcess_Insert 
 (prjid1 	integer, 
 taskid1 	integer,  
 wbscoding1 	varchar2, 
 subject1 	varchar2, 
 version1 	smallint, 
 begindate1 	varchar2, 
 enddate1 	varchar2, 
 workday1	number, 
 content1 	varchar2, 
 fixedcost1 number, 
 parentid1 integer,
 parentids1 varchar2, 
 parenthrmids1 varchar2, 
 level_n1 smallint, 
 hrmid1 integer, 	 
 flag out integer ,
 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  ) 
AS 
 id1 integer;
 maxid1 varchar2(255);
 maxhrmid1 varchar2(255);
begin


INSERT INTO Prj_TaskProcess ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid)  

VALUES 
( prjid1, taskid1 , wbscoding1, subject1 , version1 , begindate1, enddate1, workday1, content1, fixedcost1, parentid1, parentids1, parenthrmids1, level_n1, hrmid1); 

select  max(id) INTO id1 from Prj_TaskProcess; 
 maxid1 := concat(to_char( id1) , ',');
 maxhrmid1 := concat(concat('|' , to_char( id1)) , concat(concat( ',' , to_char( hrmid1)) , '|') );
update Prj_TaskProcess set parentids= concat(parentids1, maxid1), parenthrmids=concat(parenthrmids1 , maxhrmid1)  where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskProcess_SelectAll 
 (prjid1 integer, level_n1 smallint, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_TaskProcess WHERE ( prjid	 = prjid1 and  level_n <= level_n1 and isdelete<>'1') order by parentids  ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskProcess_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_TaskProcess WHERE ( id	 = id1 );
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskProcess_Sum 
 (prjid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT sum(workday)   workday, min(begindate)   begindate, max(enddate)   enddate, to_number(sum(finish*workday)/sum(workday))   finish
FROM Prj_TaskProcess WHERE ( prjid = prjid1 and parentid = '0' and isdelete<>'1') ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskProcess_Update 
 (id1	integer, wbscoding1 varchar2, subject1 	varchar2, begindate1 	varchar2, enddate1 	varchar2,
 workday1 number, content1 	varchar2, fixedcost1 number, hrmid1 integer, oldhrmid1 integer, finish1 smallint,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
	AS 
	  currenthrmid1 varchar2(255);
	  currentoldhrmid1 varchar2(255);
	begin
UPDATE Prj_TaskProcess  SET  wbscoding = wbscoding1, subject = subject1 , begindate = begindate1,
enddate = enddate1 	, workday = workday1, content = content1, fixedcost = fixedcost1, hrmid = hrmid, 
finish = finish1 
WHERE ( id	 = id1) ;
if hrmid1 <> oldhrmid1 then


 currenthrmid1 := concat(concat(concat('|' , to_char( id1)) , ',') , concat(to_char( hrmid1) , '|'));
  currentoldhrmid1 :=  concat(concat(concat('|' , to_char( id1)) , ',') , concat(to_char( oldhrmid1) , '|'));
UPDATE Prj_TaskProcess 
set parenthrmids =replace(parenthrmids,currentoldhrmid1,currenthrmid1) where (parenthrmids like
concat(concat('%',currentoldhrmid1),'%'));
end if;
end;
/


 CREATE or REPLACE PROCEDURE Prj_TaskProcess_UpdateParent 
 (parentid_1	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
	AS 

 begindate_1 varchar2(30); 
 enddate_1 varchar2(30);
 workday_1 number;
 finish_1 number;
begin

select  min(begindate), max(enddate), sum(workday) , to_number(sum(workday*finish)/sum(workday)) 
INTO begindate_1, enddate_1, workday_1,finish_1 
 from Prj_TaskProcess where parentid=parentid_1;

UPDATE Prj_TaskProcess  SET   begindate = begindate_1, enddate = enddate_1, workday = workday_1, finish = finish_1
WHERE ( id = parentid_1);
end;
/


 CREATE or REPLACE PROCEDURE Prj_ToolProcess_Delete 
 (id1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS
	begin
	update Prj_ToolProcess set isactived = '1'  WHERE ( id = id1)   ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_ToolProcess_Insert 
 (prjid1 	integer, taskid1 integer, relateid1 	integer,  isactived1 smallint, 
 begindate1 	varchar2, enddate1 varchar2, workday1 number, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
	INSERT INTO Prj_ToolProcess ( prjid, taskid, relateid, isactived, begindate, enddate, workday, cost)
	VALUES ( prjid1 , taskid1 , relateid1 , isactived1 , begindate1, enddate1, workday1, cost1 ) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_ToolProcess_Update 
  (id1 integer,  relateid1 	integer,  begindate1 	varchar2, enddate1 varchar2, workday1 number, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
update Prj_ToolProcess set relateid=relateid1, begindate=begindate1, enddate=enddate1, workday=workday1, cost=cost1
WHERE ( id = id1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Tool_Delete 
 (id1 integer, version1 varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
	update Prj_Tool set version=replace(version, version1, '')  WHERE ( id = id1) ;
	delete Prj_Tool WHERE ( id = id1 and (version='' OR version is null) ) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Tool_Insert 
 (prjid1 	integer, taskid1 integer, relateid1 	integer, version1 varchar2, begindate1 	varchar2,
 enddate1 varchar2, workday1 number, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
INSERT INTO Prj_Tool ( prjid, taskid, relateid, version, begindate, enddate, workday, cost)
VALUES ( prjid1 , taskid1 , relateid1 	, version1, begindate1, enddate1, workday1, cost1 ) ;
INSERT INTO Prj_ToolProcess ( prjid, taskid, relateid, isactived)  
VALUES ( prjid1 , taskid1 , relateid1 , '0') ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Tool_SelectAllPlan 
 (prjid1 integer, version1 varchar2, relateid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT t1.*,t2.wbscoding,t2.subject,t2.id   taskrecordid FROM Prj_Tool   t1, Prj_TaskInfo   t2
WHERE ( t1.prjid	 = prjid1 and t1.version like concat(concat('%|' , version1) , '|%') and t1.relateid = relateid1
and t2.prjid	 = prjid1 and t2.version = version1  and t1.taskid=t2.taskid ) order by t2.wbscoding ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Tool_SelectAllProcess 
 (prjid1 integer, relateid1 integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT t1.*,t3.wbscoding,t3.subject,t2.id   taskrecordid FROM Prj_toolProcess   t1, Prj_TaskProcess   t2 , Prj_TaskInfo   t3 
WHERE ( t1.prjid	 = prjid1 and ( t1.isactived = '2' or t1.isactived = '3' ) and t1.relateid = relateid1
and t2.prjid	 = prjid1 and ( t2.isactived = '2' or t2.isactived = '3' )  
and t1.taskid=t2.taskid and t3.prjid = prjid1 and t3.taskid = t2.taskid and t3.version =t2.version ) order by t3.wbscoding  ;
end;
/


 CREATE or REPLACE PROCEDURE Prj_Tool_SumPlan 
 (prjid1 integer, version1 varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT relateid, sum(workday)   workday, min(begindate)   begindate, max(enddate)   enddate, sum(cost*workday)   cost 
FROM Prj_Tool 
WHERE ( prjid	 = prjid1 and version like concat(concat('%|' , version1) , '|%') ) group by relateid ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Tool_SumProcess 
 (prjid1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT relateid, sum(workday)   workday, min(begindate)   begindate, max(enddate)   enddate, sum(cost*workday)   cost 
FROM Prj_ToolProcess WHERE ( prjid	 = prjid1 and ( isactived = '2' or isactived = '3' )  ) group by relateid ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_Tool_Update 
 (id1 integer, version1 varchar2, prjid1 	integer, taskid1 integer, relateid1 	integer, begindate1 	varchar2, enddate1 varchar2, workday1 number, cost1 number,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  AS 
	begin
update Prj_Tool set version=replace(version, version1, '')  
WHERE ( id = id1) ;
delete Prj_Tool WHERE ( id = id1 and (version='' OR version is null) )  ;
INSERT INTO Prj_Tool ( prjid, taskid, relateid, version, begindate, enddate, workday, cost) 
VALUES ( prjid1 , taskid1 , relateid1 	, version1, begindate1, enddate1, workday1, cost1 );
end;
/



 CREATE or REPLACE PROCEDURE Prj_ViewLog1_Insert 
 (
 id1	integer, viewer1	integer, submitertype1 	smallint, viewdate1	char, 
 viewtime1	char, ipaddress1	char, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
insert into Prj_viewLog1 (id, viewer, submitertype, viewdate, viewtime, ipaddress)
values(id1, viewer1, submitertype1, viewdate1, viewtime1, ipaddress1) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_WorkType_Delete 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
	begin
	DELETE Prj_WorkType  WHERE ( id	 = id1) ;
	end;
/



 CREATE or REPLACE PROCEDURE Prj_WorkType_Insert 
 (fullname_1 	varchar2, description_2 	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	INSERT INTO Prj_WorkType ( fullname, description)  VALUES ( fullname_1, description_2) ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_WorkType_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_WorkType ;
end;
/



 CREATE or REPLACE PROCEDURE Prj_WorkType_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_WorkType WHERE ( id	 = id1);
end;
/




 CREATE or REPLACE PROCEDURE Prj_WorkType_Update 
 (id1	 	integer, fullname1 	varchar2, description1	varchar2, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	begin
	UPDATE Prj_WorkType  SET  fullname	 = fullname1, description	 = description1 
	WHERE ( id	 = id1)  ;
end;
/



 CREATE or REPLACE PROCEDURE ProcedureInfo_Delete 
 (id_1  		integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  AS 
begin
DELETE ProcedureInfo  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE ProcedureInfo_Insert 
 (procedurename_1 	varchar2, proceduretabel_2 	varchar2, procedurescript_3 	varchar2, proceduredesc_4 	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) AS 
begin
INSERT INTO ProcedureInfo ( procedurename, proceduretabel, procedurescript, proceduredesc) 
VALUES ( procedurename_1, proceduretabel_2, procedurescript_3, proceduredesc_4) ;
end;
/



 CREATE or REPLACE PROCEDURE ProcedureInfo_Select 
 (
 procedurename1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT * from ProcedureInfo where procedurename like procedurename1 ;
end;
/




 CREATE or REPLACE PROCEDURE ProcedureInfo_SelectByID 
 (
 id1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT * from ProcedureInfo where id = to_number( id1);
end;
/


 CREATE or REPLACE PROCEDURE ProcedureInfo_Update 
 (id_1 	integer, procedurename_2 	varchar2, proceduretabel_3 	varchar2, procedurescript_4 	varchar2, proceduredesc_5 	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  AS 
begin
UPDATE ProcedureInfo  SET  procedurename	 = procedurename_2, proceduretabel	 = proceduretabel_3, procedurescript	 = procedurescript_4, proceduredesc	 = proceduredesc_5  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE RoleRightdetailInfo_Select 
 (flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS
begin
open thecursor for
SELECT roleid , rightdetail , rolelevel from SystemRightDetail, SystemRightRoles where SystemRightDetail.rightid = SystemRightRoles.rightid order by roleid ;
end;
/



 CREATE or REPLACE PROCEDURE SequenceIndex_SelectNextID 
	(indexdesc_1 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
  currentid_1  integer ;
  currentid_count integer;
  begin
select count(currentid) INTO  currentid_count   from SequenceIndex where indexdesc = indexdesc_1;
if currentid_count>0 then

select currentid INTO  currentid_1   from SequenceIndex where indexdesc = indexdesc_1;
end if;
update SequenceIndex set currentid = currentid_1 +1 where indexdesc= indexdesc_1;
open thecursor for
select currentid_1 from dual;
end;
/


 CREATE or REPLACE PROCEDURE SequenceIndex_Sub 
 (indexdesc_1 	varchar2,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
 AS 
 c1 integer;
 count_1 integer;
 begin
 select  count(currentid) INTO count_1 from SequenceIndex   WHERE ( indexdesc	 = indexdesc_1) ;
 if count_1>0 then

 select  currentid INTO c1 from SequenceIndex   WHERE ( indexdesc	 = indexdesc_1) ;
c1 := c1-1;
end if;
 UPDATE SequenceIndex  
SET  currentid	 = c1 
 WHERE ( indexdesc	 = indexdesc_1) ;
open thecursor for
 select currentid  from SequenceIndex where ( indexdesc	 = indexdesc_1);
end;
/



 CREATE or REPLACE PROCEDURE SequenceIndex_Update 
 (indexdesc_1 	varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS 
	
 c1 integer;
 count_1 integer;
 begin
  select  count(currentid) INTO count_1 from SequenceIndex   WHERE ( indexdesc	 = indexdesc_1) ;
  if count_1>0 then

 select  currentid INTO c1 from SequenceIndex   WHERE ( indexdesc	 = indexdesc_1) ;
c1 := c1+1;
end if;
 UPDATE SequenceIndex  
SET  currentid	 = c1 
 WHERE ( indexdesc	 = indexdesc_1) ;
open thecursor for
 select currentid  from SequenceIndex where ( indexdesc	 = indexdesc_1);
end;
/

 CREATE or REPLACE PROCEDURE SysFavourite_DeleteByID 
	(id1 		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	delete from sysfavourite where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE SysFavourite_Insert 
 ( resourceid1 integer, Adddate1 char, Addtime1 char, Pagename1    varchar2, URL1     varchar2, 
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
   totalcount   integer; 
   begin
select count(*)  INTO totalcount  from sysfavourite where resourceid=resourceid1 ;
if totalcount > 14 then 
delete  from sysfavourite where resourceid=resourceid1 
and adddate=(select  adddate from ( select adddate from sysfavourite where resourceid=resourceid1 order by adddate) WHERE rownum =1) 
and addtime=(select  addtime from ( select addtime from sysfavourite where resourceid=resourceid1 order by adddate,addtime)WHERE rownum =1); 
end if; 
INSERT INTO SysFavourite ( Resourceid, Adddate, Addtime, Pagename, URL) VALUES ( Resourceid1, Adddate1, Addtime1, Pagename1, URL1) ;
end;
/


 CREATE or REPLACE PROCEDURE SysFavourite_SelectByUserID 
 (Resourceid1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from sysfavourite where resourceid in (resourceid1,0) order by resourceid,adddate desc,addtime desc ;
end;
/


 CREATE or REPLACE PROCEDURE SysFavourite_Update 
 (id_1 	integer, pagename_1   varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
UPDATE sysfavourite  SET  pagename	 = pagename_1  WHERE ( id = id_1)  ;
end;
/









 CREATE or REPLACE PROCEDURE SysRemindInfo_DeleteHasendwf
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as

   tmp varchar2(255);
   tmp_count integer;
  begin
    select  count(hasendwf) INTO tmp_count  from SysRemindInfo where userid = userid1 and usertype = usertype1;
	if tmp_count >0 then
	
  select  hasendwf INTO tmp  from SysRemindInfo where userid = userid1 and usertype = usertype1;
  end if;
  if tmp is not null  then
  
	    tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');
	
	  if length (tmp) < 2  then
	 
		   tmp := '';

     else
	 	   tmp := SUBSTR(tmp,2,length(tmp)-2);
        end if;
	  update SysRemindInfo set hasendwf = tmp where userid = userid1 and usertype = usertype1;
	 
end if;
end;  
/


 CREATE or REPLACE PROCEDURE SysRemindInfo_DeleteHasnewwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmp varchar2(255);
   tmp_count integer;
  begin
  select  count(hasnewwf) INTO tmp_count from SysRemindInfo where userid = userid1 and usertype = usertype1;
  if(tmp_count>0)then
  select  hasnewwf INTO tmp from SysRemindInfo where userid = userid1 and usertype = usertype1;
  end if;
  if tmp is not null then
	 tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');
	 if length(tmp) < 2 then
		   tmp := null;
	else
	 	   tmp := SUBSTR(tmp,2,length(tmp)-2);
	end if;
	 update SysRemindInfo set hasnewwf = tmp where userid = userid1 and usertype = usertype1;
  end if; 
end;
/



 CREATE or REPLACE PROCEDURE SysRemindInfo_IPasstimeNode 
 (
userid1		integer,
usertype1	integer,
haspasstimenode1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid_count integer;
   begin
     select  count(userid) INTO tmpid_count  from SysRemindInfo where userid = userid1 and usertype = usertype1;
	 if tmpid_count>0 then
  insert into SysRemindInfo(userid,usertype,haspasstimenode) values(userid1,usertype1,haspasstimenode1);
  else
  update SysRemindInfo set haspasstimenode = haspasstimenode1 where userid = userid1 and usertype = usertype1;
  end if;
end;
/


 CREATE or REPLACE PROCEDURE SysRemindInfo_InserCrmcontact 
 (
userid1		integer,
usertype1	integer,
hascrmcontact1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid integer ;
   begin
   select count(userid) into tmpid from SysRemindInfo where userid = userid1 and usertype = usertype1;
  if tmpid = 0 then
	  insert into SysRemindInfo(userid,usertype,hascrmcontact) values(userid1,usertype1,hascrmcontact1);
  else
	  update SysRemindInfo set hascrmcontact = hascrmcontact1 where userid = userid1 and usertype = usertype1;
  end if;
end;
/






 CREATE or REPLACE PROCEDURE SysRemindInfo_InserDealwf 
 (
userid1		integer,
usertype1	integer,
hasdealwf1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
	tmpid_count integer;
	begin
select   count(userid) INTO tmpid_count from SysRemindInfo where userid = userid1 and usertype = usertype1;
if tmpid_count=0  then
  insert into SysRemindInfo(userid,usertype,hasdealwf) values(userid1,usertype1,hasdealwf1);
  else
  update SysRemindInfo set hasdealwf = hasdealwf1 where userid = userid1 and usertype = usertype1;
  end if;
end;
/



CREATE or REPLACE PROCEDURE SysRemindInfo_InserHasendwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid integer ;
    tmp varchar2(255);
	recordcount integer;
	begin
  select count(*) INTO recordcount  from SysRemindInfo where userid = userid1 and usertype = usertype1;
  if recordcount>0 then
      select hasendwf , userid INTO tmp, tmpid  from SysRemindInfo where userid = userid1 and usertype = usertype1;
      if tmp = '' or tmp is null then
           update SysRemindInfo set hasendwf = to_char(requestid1) 
		   where userid = userid1 and usertype = usertype1;
      else 
           if instr(  concat(concat(',', to_char(requestid1)),',') ,  concat(concat(',',tmp),','),1,1)=0 then
	              update SysRemindInfo set hasendwf = concat(concat(hasendwf ,','),to_char(requestid1))
				  where userid = userid1 and usertype = usertype1;
           end if;
	  end if;
  else 
  insert into SysRemindInfo(userid,usertype,hasendwf) values(userid1,usertype1,to_char(requestid1));
  end if;
end;
/



CREATE or REPLACE PROCEDURE SysRemindInfo_InserHasnewwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid integer ;
   tmp varchar(255);
   recordcount integer;
begin
  select count(*) INTO recordcount  from SysRemindInfo where userid = userid1 and usertype = usertype1;
  if recordcount=0 then
    insert into SysRemindInfo(userid,usertype,hasnewwf) values(userid1,usertype1,to_char(requestid1));
  else
	select userid,hasnewwf into   tmpid, tmp
	     from SysRemindInfo where userid = userid1 and usertype = usertype1;
	if tmp = '' or tmp is null then
		 update SysRemindInfo set hasnewwf = to_char(requestid1)
		 where userid = userid1 and usertype = usertype1;
	else 
        if instr (  concat(concat(',', to_char(requestid1)),',') ,  concat(concat(',',tmp),','),1,1)=0 then  
		    update SysRemindInfo set hasnewwf =concat(concat(hasendwf ,','),to_char(requestid1))
		    where userid = userid1 and usertype = usertype1;
	    end if;
	end if;
  end if;
end;
/





 CREATE or REPLACE PROCEDURE Sys_Slogan_Select 
 (flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  AS
begin
open thecursor for
SELECT * from Sys_Slogan ;
end;
/



 CREATE or REPLACE PROCEDURE Sys_Slogan_Update 
 (slogan1 	varchar2, speed1 	smallint, fontcolor1 	char, backcolor1 	char, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  
AS
begin
UPDATE Sys_Slogan  SET  slogan	 = slogan1, speed	 = speed1, fontcolor	 = fontcolor1, backcolor	 = backcolor1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemLogItem_Delete 
 (itemid_1 	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  AS
begin
DELETE SystemLogItem  WHERE ( itemid	 = itemid_1) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemLogItem_Insert 
 (itemid_1 	varchar2, lableid_2 	integer, itemdesc_3 	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
begin
INSERT INTO SystemLogItem ( itemid, lableid, itemdesc)  VALUES ( itemid_1, lableid_2, itemdesc_3) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemLogItem_Select 
 (
 itemdesc1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT itemid, itemdesc from SystemLogItem where itemdesc like itemdesc1 order by to_number(itemid) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemLogItem_SelectByID 
 (
 id1 varchar2 , flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT * from SystemLogItem where itemid = id1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemLogItem_Update 
 (itemid_1 	varchar2, lableid_2 	integer, itemdesc_3 	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  AS
begin
UPDATE SystemLogItem  SET  	 lableid	 = lableid_2, itemdesc	 = itemdesc_3  WHERE ( itemid	 = itemid_1 ) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemLog_Delete 
 (createdate_1 	char, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS 
begin
delete SystemLog where createdate <= createdate_1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemLog_Insert 
 (createdate_1 	char , createtime_2 	char , classname1  varchar  , sqlstr_3 	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS 
begin
INSERT INTO SystemLog ( createdate, createtime, classname, sqlstr) 
VALUES ( createdate_1, createtime_2, classname1 , sqlstr_3) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightDetail_Delete 
 (id_1 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS 
begin
DELETE SystemRightDetail  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightDetail_Insert 
 (rightdetailname_1 	varchar2, rightdetail_2 	varchar2, rightid_3 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS 
begin
INSERT INTO SystemRightDetail ( rightdetailname, rightdetail, rightid)  VALUES ( rightdetailname_1, rightdetail_2, rightid_3) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightDetail_SByRightID 
 (
 id1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT * from SystemRightDetail where rightid = id1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightDetail_Select 
 (
 rightdetailname1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT * from SystemRightDetail where rightdetailname like rightdetailname1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightDetail_SelectByID 
 (
 id1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)AS
begin
open thecursor for
SELECT * from SystemRightDetail where id = id1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightDetail_Update 
 (id_1 	integer, rightdetailname_2 	varchar2, rightdetail_3 	varchar2, rightid_4 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
UPDATE SystemRightDetail  SET  rightdetailname	 = rightdetailname_2, rightdetail	 = rightdetail_3, rightid	 = rightid_4  
WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightGroup_Delete 
 (
 id1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)AS
begin
open thecursor for
SELECT rightgroupname from SystemRightGroups where id=id1;
delete SystemRightGroups where id=id1;
delete SystemRightToGroup where groupid=id1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightGroup_Update 
 (
 id1 integer, mark1 varchar2, description1 varchar2, notes1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)as 
begin
update SystemRightGroups set rightgroupmark=mark1,rightgroupname=description1,rightgroupremark=notes1 where id=id1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightGroup_sbygroupid 
 (
 id1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)as 
begin
open thecursor for
select rightgroupmark,rightgroupname,rightgroupremark from systemrightgroups where id=id1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightGroups_Insert
 (
 mark1 varchar2, description1 varchar2, notes1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)as
begin 
insert INTO  systemrightgroups (rightgroupmark  ,rightgroupname  ,rightgroupremark) values(mark1,description1,notes1) ;
open thecursor for
select max(id) from systemrightgroups ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightRoles_Delete 
 (id_1 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS 
begin
DELETE 
SystemRightRoles  WHERE ( id	 = id_1) ;
end;
/







 CREATE or REPLACE PROCEDURE SystemRightRoles_Insert 
 (rightid_1 	integer, roleid_2 	integer, rolelevel_3 	char, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 

 count1 integer;
begin

select  count(id) INTO  count1 from SystemRightRoles where rightid = rightid_1 and roleid = roleid_2  ;

if count1 = 0 then

INSERT INTO SystemRightRoles ( rightid, roleid, rolelevel)  VALUES ( rightid_1, roleid_2, rolelevel_3) ;
 else
 update SystemRightRoles set rolelevel = rolelevel_3 where rightid = rightid_1 and roleid = roleid_2 ;
 end if ;
end;
/






 CREATE or REPLACE PROCEDURE SystemRightRoles_SByRightid 
 (
 id1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)AS
begin
open thecursor for
SELECT * from SystemRightRoles where rightid = id1;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightRoles_SelectByID 
 (id_1 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS
begin
open thecursor for
SELECT * from SystemRightRoles where id = id_1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightRoles_Update 
 (id_1 	integer, rolelevel_2 	char, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS
begin
UPDATE SystemRightRoles  SET  rolelevel	 = rolelevel_2  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightToGroup_Delete 
 (groupid_1 	integer, rightid_2 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS 
begin
DELETE SystemRightToGroup  WHERE ( groupid	 = groupid_1) and ( rightid	 = rightid_2) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightToGroup_Insert 
 (groupid_1 	integer, rightid_2 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS
 count1 integer ;
 begin
select count(id) INTO  count1 from SystemRightToGroup where groupid = groupid_1 and rightid = rightid_2 ;
     if count1 = 0 then
	 
	  INSERT INTO SystemRightToGroup ( groupid, rightid)  VALUES ( groupid_1, rightid_2) ;
	  end if;
	  end;
/





CREATE GLOBAL TEMPORARY TABLE temp_table_01
 (id  integer,
 groupname varchar2(200),
 cnt integer)
 ON COMMIT DELETE ROWS
/
 
 
CREATE or REPLACE PROCEDURE SystemRight_selectRightGroup 
(
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)

as
id_1 integer;
groupname_1 varchar2(200);
count_1 integer;
begin

select count(*) into count_1  from SystemRights ;
insert into temp_table_01 (id,groupname,cnt)  values(-1,'全部',count_1) ;

for right_cursor in (select id , rightgroupname from SystemRightGroups order by id )
loop
    id_1 := right_cursor.id;
    groupname_1 := right_cursor.rightgroupname;
    select count(rightid) INTO  count_1  from SystemRightToGroup where groupid= id_1;
    insert into temp_table_01 (id,groupname,cnt)  values (id_1,groupname_1,count_1) ;
end loop;
open thecursor for
select id,groupname,cnt from temp_table_01 ;
end;
/








 CREATE or REPLACE PROCEDURE SystemRightsLanguage_Insert 
 (id_1 	integer, languageid_2 	integer, rightname_3 	varchar2, rightdesc_4 	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS
begin
INSERT INTO SystemRightsLanguage ( id, languageid, rightname, rightdesc)  VALUES ( id_1, languageid_2, rightname_3, rightdesc_4);
end;
/


 CREATE or REPLACE PROCEDURE SystemRightsLanguage_SByID 
 (
 id1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )AS
begin
open thecursor for
SELECT * from SystemRightsLanguage where id = id1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightsLanguage_SByIDLang 
 (
 id1 integer, languageid1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )AS
begin
open thecursor for
SELECT a.rightname, a.rightdesc, b.righttype from SystemRightsLanguage a, SystemRights b
where a.id = id1 and a.languageid = languageid1 and a.id = b.id ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRightsLanguage_Update 
 (id_1 	integer, languageid_2 	integer, rightname_3 	varchar2, rightdesc_4 	varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS
begin
UPDATE SystemRightsLanguage  SET  rightname	 = rightname_3, rightdesc	 = rightdesc_4  WHERE ( id	 = id_1 AND languageid	 = languageid_2) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRights_Delete 
 (id_1 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
 count1 integer ;
 begin
 select  count(id) INTO  count1  from SystemRightRoles where rightid = id_1 ;
if count1 <> 0 then
 return;
 DELETE SystemRights  WHERE ( id	 = id_1) ;
 DELETE SystemRightsLanguage  WHERE ( id	 = id_1);
 DELETE SystemRightToGroup  WHERE ( rightid = id_1) ;
end if;
end;
/


 CREATE or REPLACE PROCEDURE SystemRights_Insert 
 ( rightdesc_2 	varchar2, righttype_3 	char , flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO SystemRights ( rightdesc, righttype)  VALUES (  rightdesc_2, righttype_3) ;
open thecursor for
select max(id) from SystemRights ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRights_Select 
 (
 rightdesc1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )AS
begin
open thecursor for
SELECT * from SystemRights where rightdesc like rightdesc1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRights_SelectAll 
 (
  flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin 
open thecursor for
select id,languageid,rightname  from systemrightslanguage order by id,languageid ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRights_SelectAllID 
 (
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT id from SystemRights ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRights_SelectByID 
 (
 id1 varchar2, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from SystemRights where id = id1 ;
end;
/


 CREATE or REPLACE PROCEDURE SystemRights_Update 
 (id_1 	integer, rightdesc_2 	varchar2, righttype_3 	char, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  AS 
begin
UPDATE SystemRights  SET  rightdesc	 = rightdesc_2, righttype	 = righttype_3  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE SystemSet_Select 
 (flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from SystemSet ;
end;
/


 CREATE or REPLACE PROCEDURE SystemSet_Update 
 (emailserver1  varchar2 , debugmode1   char , logleaveday1 smallint, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS 
begin
update SystemSet set emailserver=emailserver1 , debugmode=debugmode1,logleaveday=logleaveday1 ;
end;
/


 CREATE or REPLACE PROCEDURE TransBudgetCount_Select 
 (
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
 count1 integer;
 begin
select  count(id) INTO  count1 from FnaBudget ;
if count1 <> 0 then
open thecursor for
select count1 from dual;

return ;
end if;
select count(id) INTO  count1 from FnaTransaction;
open thecursor for
select count1 from dual ;
end;
/


 CREATE or REPLACE PROCEDURE WF_CRM_ShareInfo_Add 
(crmid_1		integer,            
 sharelevel_1		integer,
 userid_1		integer,
 usertype_1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
 count_2 integer;
 begin

select count(*) INTO count_2 from CRM_ShareInfo where relateditemid=crmid_1 and sharelevel=sharelevel_1 and userid= userid_1;
	if count_2 =0  then
		
		  if usertype_1=0 then
			  
			 insert INTO  CRM_ShareInfo(relateditemid,sharetype,sharelevel,userid) values(crmid_1 , 1 ,sharelevel_1,userid_1);
			 end if;
		    if usertype_1=1 then
			
			insert INTO  CRM_ShareInfo(relateditemid,sharetype,sharelevel,crmid) values(crmid_1, 9 ,sharelevel_1,userid_1);
			end if;
		end if;
end;
/





 CREATE or REPLACE PROCEDURE WF_CptCapitalShareInfo_Add 
(cptid_1		integer,            
 sharelevel_1		integer,
 userid_1		integer,
 usertype_1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
 count_2 integer;
 begin

select count(*) INTO count_2 from CptCapitalShareInfo where relateditemid=cptid_1 and sharelevel=sharelevel_1 and userid= userid_1;
	if count_2=0 then
		
		     if usertype_1 = 0 then
			 
			 insert INTO  CptCapitalShareInfo(relateditemid,sharetype,sharelevel,userid) values(cptid_1,1,sharelevel_1,userid_1);
			 end if;
		     if usertype_1 = 1 then
			
			 insert INTO  CptCapitalShareInfo(relateditemid,sharetype,sharelevel,crmid) values(cptid_1,9,sharelevel_1,userid_1);
			 end if;
	end if;
end;
/


 CREATE or REPLACE PROCEDURE WF_DocShare_Add 
(docid_1		integer,            
 sharelevel_1		integer,
 userid_1		integer,
 usertype_1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
 count_1 integer;
 count_2 integer;
 begin
select count(*) INTO  count_1 from docdetail where usertype=usertype_1 and (ownerid=userid_1 or doccreaterid=userid_1);
if count_1=0 then
	
	select count(*) INTO count_2  from DocShare where docid=docid_1 and sharelevel=sharelevel_1 and userid= userid_1;
	if count_2=0 then
		
		     if usertype_1=0 then
			 
			 insert INTO  DocShare(docid,sharetype,sharelevel,userid) values(docid_1,1,sharelevel_1,userid_1);
			 end if;
		     if usertype_1=1 then
			
			insert into DocShare(docid,sharetype,sharelevel,crmid) values(docid_1,9,sharelevel_1,userid_1);
			end if;
	end if;
 end if;
end;
/


 CREATE or REPLACE PROCEDURE WF_Prj_ShareInfo_Add 
(prjid_1		integer,            
 sharelevel_1		integer,
 userid_1		integer,
 usertype_1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
 count_1 integer;
 count_2 integer;
 begin
select count(*) INTO count_1 from Prj_ProjectInfo where manager=userid_1 or creater=userid_1;
if count_1=0 then
	
	select count(*) INTO count_2  from Prj_ShareInfo where relateditemid=prjid_1 and sharelevel=sharelevel_1 and userid= userid_1;
	if count_2=0 then
		
		     if usertype_1=0 then
			 
			 insert into Prj_ShareInfo(relateditemid,sharetype,sharelevel,userid) values(prjid_1,1,sharelevel_1,userid_1);
			 end if;
		     if usertype_1=1 then
			
			insert INTO  Prj_ShareInfo(relateditemid,sharetype,sharelevel,crmid) values(prjid_1,9,sharelevel_1,userid_1);
			end if;
		end if;
	end if;
end;
/





 CREATE or REPLACE PROCEDURE Weather_Delete 
  (id_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
  AS 
  begin
  DELETE Weather  WHERE ( id	 = id_1) ;
end;
/




 CREATE or REPLACE PROCEDURE Weather_Insert 
  (thedate_1 	    char,
  picid_2 		    integer,
  thedesc_3 	    varchar2,
  temperature_4 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
  AS 
  c1 integer;
  begin
  open thecursor for
select count(*) INTO c1 from Weather where thedate = thedate_1;

  if  c1 > 0  then
    
             INSERT INTO Weather ( thedate, picid, thedesc,temperature)  
			 VALUES 
             ( thedate_1, picid_2, thedesc_3, temperature_4) ;
   end  if;
   open thecursor for
  select max(id) from Weather ;
 end;
/





 CREATE or REPLACE PROCEDURE Weather_SelectByID 
(id_1 	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )
AS
begin
open thecursor for
SELECT * from Weather where id=id_1 ;
end;
/


 CREATE or REPLACE PROCEDURE Weather_SelectByYear 
  (year_1 	 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  ) 
  AS 
  begin
 open thecursor for
  select * from Weather where substr(thedate,1,4)= year_1 order by thedate ;
end;
/


 CREATE or REPLACE PROCEDURE Weather_SelectTheDate 
(thedate_1 	char , 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )
AS
begin
open thecursor for
SELECT * from Weather where thedate = thedate_1;
end;
/


 CREATE or REPLACE PROCEDURE Weather_Update 
  (id_1            integer,
  thedate_1 	    char,
  picid_2 	    integer,
  thedesc_3 	    varchar2,
  temperature_4 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
  AS 
  begin
  update Weather set thedate = thedate_1, picid =picid_2 , thedesc = thedesc_3 ,temperature = temperature_4 
  where id= id_1 ;
  end;
/


 CREATE or REPLACE PROCEDURE WkfReportShareDetail_DBId 
	(reportid_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
DELETE WorkflowReportShareDetail 

WHERE 
	( reportid	 = reportid_1);
end;
/


 CREATE or REPLACE PROCEDURE WkfReportShareDetail_DByUId 
	(userid_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
DELETE WorkflowReportShareDetail 

WHERE 
	( userid	 = userid_1  and usertype = '1' );
end;
/


 CREATE or REPLACE PROCEDURE WkfReportShareDetail_Insert 
	(reportid_1 	integer,
	 userid_2 	integer,
	 usertype_3 	integer,
	 sharelevel_4 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO WorkflowReportShareDetail 
	 ( reportid,
	 userid,
	 usertype,
	 sharelevel) 
 
VALUES 
	( reportid_1,
	 userid_2,
	 usertype_3,
	 sharelevel_4);
end;
/


 CREATE or REPLACE PROCEDURE WorkflowReportShare_Delete 
	(id1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
	delete from WorkflowReportShare where id=id1;
	end;
/



 CREATE or REPLACE PROCEDURE WorkflowReportShare_Insert 
       (reportid_1       integer,
	sharetype_1	integer,
	seclevel_1	smallint,
	rolelevel_1	smallint,
	sharelevel_1	smallint,
	userid_1	integer,
	subcompanyid_1	integer,
	departmentid_1	integer,
	roleid_1	integer,
	foralluser_1	smallint,
	crmid_1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
	insert into WorkflowReportShare(reportid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid) 
	values(reportid_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,subcompanyid_1,departmentid_1,roleid_1,foralluser_1,crmid_1);
end;
/








/* 存储过程部分*/


 CREATE or REPLACE PROCEDURE WorkflowReportShare_SByReport 
	(reportid_1   integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for
	select * from WorkflowReportShare where reportid = reportid_1;
	end;
/



 CREATE or REPLACE PROCEDURE WorkflowRequestbase_SCountByC 
 (year1 	char, createrid1    integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT createdate , requestid from workflow_requestbase 
where creater = createrid1 and substr (createdate,1,4)=year1 group by createdate order by createdate ;
end;
/



 CREATE or REPLACE PROCEDURE Workflow_ReportDspField_ByRp 
	(id_1 	integer,
	 language_2 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
 isbill_3 char(1);
 isbill_count integer;
 begin
select  count(isbill) INTO   isbill_count  from workflow_base a , Workflow_Report b 
where b.id = id_1 and a.id = b.reportwfid;
if isbill_count>0 then

 open thecursor for
select  isbill INTO   isbill_3  from workflow_base a , Workflow_Report b 
where b.id = id_1 and a.id = b.reportwfid;
end if;

if isbill_3 = '0' then
open thecursor for
select a.id , b.fieldlable , a.dsporder , a.isstat ,a.dborder 
from Workflow_ReportDspField a , workflow_fieldlable b ,Workflow_Report c , workflow_base d 
where a.reportid = c.id and a.fieldid= b.fieldid and c.reportwfid = d.id and d.formid = b.formid 
and c.id = id_1 and  b.langurageid = language_2 order by a.dsporder;

else 
open thecursor for
select a.id , d.labelname , a.dsporder , a.isstat ,a.dborder  
from Workflow_ReportDspField a , workflow_billfield b ,Workflow_Report c ,HtmlLabelInfo d 
where a.reportid = c.id and a.fieldid= b.id and c.id = id_1 and b.fieldlabel = d.indexid and 
d.languageid = language_2  order by a.dsporder;
end if;
end;
/





 CREATE or REPLACE PROCEDURE Workflow_ReportDspField_Delete 
	(id_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
DELETE Workflow_ReportDspField 

WHERE 
	( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE Workflow_ReportDspField_Insert 
	(reportid_1 	integer,
	 fieldid_2 	integer,
	 dsporder_3 	integer,
	 isstat_4 	char,
	 dborder_5     char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO Workflow_ReportDspField 
	 ( reportid,
	 fieldid,
	 dsporder,
	 isstat,
	 dborder) 
 
VALUES 
	( reportid_1,
	 fieldid_2,
	 dsporder_3,
	 isstat_4,
	 dborder_5);
end;
/


 CREATE or REPLACE PROCEDURE Workflow_ReportType_Delete 
	(id_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
 count1 integer;
 begin
select count(id)INTO  count1  from Workflow_Report where reporttype = id_1;

if count1 <> 0 then
open thecursor for
select 0 from dual;
end if;

DELETE Workflow_ReportType 
WHERE 
	( id	 = id_1);
end;
/








 CREATE or REPLACE PROCEDURE Workflow_ReportType_Insert 
	(typename_1 	varchar2,
	 typedesc_2 	varchar2,
	 typeorder_3 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO Workflow_ReportType 
	 ( typename,
	 typedesc,
	 typeorder) 
 
VALUES 
	( typename_1,
	 typedesc_2,
	 typeorder_3);
end;
/


 CREATE or REPLACE PROCEDURE Workflow_ReportType_Select 
	(flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select * from Workflow_ReportType order by typeorder ;
end;
/


 CREATE or REPLACE PROCEDURE Workflow_ReportType_SelectByID 
	(id_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select * from Workflow_ReportType where id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE Workflow_ReportType_Update 
	(id_1 	integer,
	 typename_2 	varchar2,
	 typedesc_3 	varchar2,
	 typeorder_4 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE Workflow_ReportType 

SET  typename	 = typename_2,
	 typedesc	 = typedesc_3,
	 typeorder	 = typeorder_4 

WHERE 
	( id	 = id_1);
end;
/




 CREATE or REPLACE PROCEDURE Workflow_Report_Delete 
	(id_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
DELETE Workflow_Report 

WHERE 
	( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE Workflow_Report_Insert 
	(reportname_1 	varchar2,
	 reporttype_2 	integer,
	 reportwfid_3 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO Workflow_Report 
	 ( reportname,
	 reporttype,
	 reportwfid) 
 
VALUES 
	( reportname_1,
	 reporttype_2,
	 reportwfid_3);
end;
/








 CREATE or REPLACE PROCEDURE Workflow_Report_Select 
	(flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select * from Workflow_Report;
end;
/



 CREATE or REPLACE PROCEDURE Workflow_Report_SelectByID 
	(id_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select * from Workflow_Report where id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE Workflow_Report_Update 
	(id_1 	integer,
	 reportname_2 	varchar2,
	 reporttype_3 	integer,
	 reportwfid_4 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE Workflow_Report 

SET  reportname	 = reportname_2,
	 reporttype	 = reporttype_3,
	 reportwfid	 = reportwfid_4 

WHERE 
	( id	 = id_1);
end;
/




 CREATE or REPLACE PROCEDURE Workflow_StaticReport_Delete 
 (
	id1     integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as   
begin
	delete from workflow_StaticRpbase where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE Workflow_StaticReport_Insert 
 (
	name1   varchar2,
	description1    varchar2,
	pagename1   varchar2,
	module1     integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
     tmpid  integer;
	 begin
    
	insert into workflow_StaticRpbase(name,description,pagename,module)
	values (name1,description1,pagename1,module1);
	open thecursor for
	
	select max(id)INTO  tmpid from workflow_StaticRpbase;
	 
	update
	workflow_StaticRpbase set reportid=-id where id=tmpid;
end;
/




 CREATE or REPLACE PROCEDURE Workflow_StaticReport_Select
 (
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
open thecursor for
	select * from workflow_StaticRpbase order by id;
end;
/


 CREATE or REPLACE PROCEDURE Workflow_StaticReport_SByID 
 (
	id1     integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as   
begin
open thecursor for
	select * from workflow_StaticRpbase where id=id1;
end;
/



 CREATE or REPLACE PROCEDURE Workflow_StaticReport_SByMU 
 (
	module1     integer,
	userid1     integer,
	usertype1   integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin
open thecursor for
	select t1.* from workflow_StaticRpbase t1, WorkflowReportShareDetail t2
	where t1.module=module1 and t1.reportid=t2.reportid and t2.userid=userid1 and t2.usertype=usertype1;
end;
/


 CREATE or REPLACE PROCEDURE Workflow_StaticReport_SByModu 
 (
	module1     integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as   
begin
open thecursor for
	select * from workflow_StaticRpbase where module=module1;
end;
/


 CREATE or REPLACE PROCEDURE Workflow_StaticReport_Update 
 (
	id1     integer,
	name1   varchar2,
	description1    varchar2,
	pagename1   varchar2,
	module1     integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as   
begin
	update workflow_StaticRpbase 
	set name=name1,
	    description=description1,
	    pagename=pagename1,
	    module=module1
	where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE bill_Approve_UpdateStatus 
 (
	id1		integer,
	status1	char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	update Bill_Approve set status=status1 where id=id1; 
end;
/



 CREATE or REPLACE PROCEDURE bill_BudgetDetail_Insert
 (
	departmentid1	integer,
	feeid1		integer,
	month1		integer,
	budget1		number,
	year1       integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	insert into bill_budgetdetail values(departmentid1,feeid1,month1,budget1,year1);
end;
/


 CREATE or REPLACE PROCEDURE bill_BudgetDetail_SAllMonth 
 (
	month1		integer,
	year1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
open thecursor for
	select sum(budget) from bill_budgetdetail 
	where month=month1 and year=year1;
end;
/


 CREATE or REPLACE PROCEDURE bill_BudgetDetail_SMonthTotal 
 (
	departmentid1	integer,
	month1		integer,
	year1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
open thecursor for
	select sum(budget) from bill_budgetdetail 
	where departmentid=departmentid1 and month=month1 and year=year1;
end;
/


 CREATE or REPLACE PROCEDURE bill_BudgetDetail_SMonthToByf 
 (
	feeid1	integer,
	month1		integer,
	year1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
open thecursor for
	select sum(budget) from bill_budgetdetail 
	where feeid=feeid1 and month=month1 and year=year1;
end;
/


 CREATE or REPLACE PROCEDURE bill_BudgetDetail_SelectOne 
 (
	departmentid1	integer,
	feeid1		integer,
	month1		integer,
	year1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
open thecursor for
	select budget from bill_budgetdetail 
	where departmentid=departmentid1 and feeid=feeid1 and month=month1 and year=year1;
end;
/


 CREATE or REPLACE PROCEDURE bill_CptAdjustDetail_Insert 
	(cptadjustid1 	integer,
	cptid_1 	integer,
	 number_2 	number,
	 unitprice_3 	number,
	 amount_4 	number,
	 cptstatus1 	integer,
	 needdate_5 	varchar2,
	 purpose_6 	varchar2,
	 cptdesc_7 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptAdjustDetail 
	 ( cptadjustid,
	 cptid,
	 number_n,
	 unitprice,
	 amount,
	 cptstatus,
	 needdate,
	 purpose,
	 cptdesc) 
 
VALUES 
	( cptadjustid1,
	cptid_1,
	 number_2,
	 unitprice_3,
	 amount_4,
	 cptstatus1,
	 needdate_5,
	 purpose_6,
	 cptdesc_7);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptAdjustDetail_Select 
	(cptadjustid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptAdjustDetail 
WHERE 
	( cptadjustid	 = cptadjustid1);
	end;
/



 CREATE or REPLACE PROCEDURE bill_CptAdjustDetail_Update 
	(id_1 	integer,
	 cptid_3 	integer,
	 number_4 	number,
	 unitprice_5 	number,
	 amount_6 	number,
	 cptstatus1 	integer,
	 needdate_7 	varchar2,
	 purpose_8 	varchar2,
	 cptdesc_9 	varchar2,
	 capitalid 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE  bill_CptAdjustDetail 

SET  
	 cptid	 = cptid_3,
	 number_n	 = number_4,
	 unitprice	 = unitprice_5,
	 amount	 = amount_6,
	 cptstatus	 = cptstatus,
	 needdate	 = needdate_7,
	 purpose	 = purpose_8,
	 cptdesc	 = cptdesc_9 ,
	 capitalid	 = capitalid 

WHERE 
	( id	 = id_1);
end;
/




 CREATE or REPLACE PROCEDURE bill_CptAdjustMain_Select 
	(id1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptAdjustMain 
WHERE 
	( id	 = id1);
end;
/




 CREATE or REPLACE PROCEDURE bill_CptApplyDetail_Insert 
	(cptapplyid1 	integer,
	 cpttype1 	integer,
	cptid_1 	integer,
	 number_2 	number,
	 unitprice_3 	number,
	 amount_4 	number,
	 needdate_5 	varchar2,
	 purpose_6 	varchar2,
	 cptdesc_7 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptApplyDetail 
	 ( cptapplyid,
	 cpttype,
	 cptid,
	 number_n,
	 unitprice,
	 amount,
	 needdate,
	 purpose,
	 cptdesc) 
 
VALUES 
	( cptapplyid1,
	cpttype1,
	cptid_1,
	 number_2,
	 unitprice_3,
	 amount_4,
	 needdate_5,
	 purpose_6,
	 cptdesc_7);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptApplyDetail_Select 
	(cptapplyid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptApplyDetail 
WHERE 
	( cptapplyid	 = cptapplyid1);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptApplyDetail_Update 
	(id_1 	integer,
	cpttype1 	integer,
	 cptid_3 	integer,
	 number_4 	number,
	 unitprice_5 	number,
	 amount_6 	number,
	 needdate_7 	varchar2,
	 purpose_8 	varchar2,
	 cptdesc_9 	varchar2,	 
	 capitalid1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE  bill_CptApplyDetail 

SET  
	 cpttype	 = cpttype1,
	 cptid	 = cptid_3,
	 number_n	 = number_4,
	 unitprice	 = unitprice_5,
	 amount	 = amount_6,
	 needdate	 = needdate_7,
	 purpose	 = purpose_8,
	 cptdesc	 = cptdesc_9 ,
	 capitalid	 = capitalid1 

WHERE 
	( id	 = id_1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptApplyMain_Select 
	(id1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptApplyMain 
WHERE 
	( id	 = id1);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptCarFee_Insert 
	(requestid_1 	integer,
	 usedate_2 	varchar2,
	 driver_3 	integer,
	 carno_4 	integer,
	 oilfee_5 	number,
	 bridgefee_6 	number,
	 fixfee_7 	number,
	 phonefee_8 	number,
	 cleanfee_9 	number,
	 remax_10 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptCarFee 
	 ( requestid,
	 usedate,
	 driver,
	 carno,
	 oilfee,
	 bridgefee,
	 fixfee,
	 phonefee,
	 cleanfee,
	 remax) 
 
VALUES 
	( requestid_1,
	 usedate_2,
	 driver_3,
	 carno_4,
	 oilfee_5,
	 bridgefee_6,
	 fixfee_7,
	 phonefee_8,
	 cleanfee_9,
	 remax_10);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptCarFee_Update 
	(id_1 	integer,
	 usedate_2 	varchar2,
	 driver_3 	integer,
	 carno_4 	integer,
	 oilfee_5 	decimal,
	 bridgefee_6 	decimal,
	 fixfee_7 	decimal,
	 phonefee_8 	decimal,
	 cleanfee_9 	decimal,
	 remax_10 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
UPDATE bill_CptCarFee 

SET  usedate	 = usedate_2,
	 driver	 = driver_3,
	 carno	 = carno_4,
	 oilfee	 = oilfee_5,
	 bridgefee	 = bridgefee_6,
	 fixfee	 = fixfee_7,
	 phonefee	 = phonefee_8,
	 cleanfee	 = cleanfee_9,
	 remax	 = remax_10 

WHERE 
	( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptCarFix_Insert 
	(requestid_1 	integer,
	 usedate_2 	varchar2,
	 driver_3 	integer,
	 carno_4 	integer,
	 fixfee_5 	number,
	 remax_6 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO bill_CptCarFix 
	 ( requestid,
	 usedate,
	 driver,
	 carno,
	 fixfee,
	 remax) 
 
VALUES 
	( requestid_1,
	 usedate_2,
	 driver_3,
	 carno_4,
	 fixfee_5,
	 remax_6);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptCarFix_Update 
	(id_1 	integer,
	 usedate_2 	varchar2,
	 driver_3 	integer,
	 carno_4 	integer,
	 fixfee_5 	number,
	 remax_6 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE bill_CptCarFix 

SET  usedate	 = usedate_2,
	 driver	 = driver_3,
	 carno	 = carno_4,
	 fixfee	 = fixfee_5,
	 remax	 = remax_6 

WHERE 
	( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptCarMantant_Insert 
	(requestid_1 	integer,
	 usedate_2 	varchar2,
	 driver_3 	integer,
	 carno_4 	integer,
	 mantantfee_5 	number,
	 remax_6 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO bill_CptCarMantant 
	 ( requestid,
	 usedate,
	 driver,
	 carno,
	 mantantfee,
	 remax) 
 
VALUES 
	( requestid_1,
	 usedate_2,
	 driver_3,
	 carno_4,
	 mantantfee_5,
	 remax_6);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptCarMantant_Update 
	(id_1 	integer,
	 usedate_2 	varchar2,
	 driver_3 	integer,
	 carno_4 	integer,
	 mantantfee_5 	decimal,
	 remax_6 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE bill_CptCarMantant 

SET  usedate	 = usedate_2,
	 driver	 = driver_3,
	 carno	 = carno_4,
	 mantantfee	 = mantantfee_5,
	 remax	 = remax_6 

WHERE 
	( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptCarOut_Delete 
	(id_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS
begin
DELETE bill_CptCarOut 

WHERE 
	( id	 = id_1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptCarOut_Insert 
	(requestid_1 	integer,
	 date_2 	varchar2,
	 driver_3 	integer,
	 carno_4 	integer,
	 begindate_5 	varchar2,
	 begintime_6 	varchar2,
	 enddate_7 	varchar2,
	 endtime_8 	varchar2,
	 frompos_9 	varchar2,
	 beginnumber_10 	number,
	 endnumber_11 	number,
	 number_12 	number,
	 userid_13 	integer,
	 userdepid_14 	integer,
	 isotherplace_15 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptCarOut 
	 ( requestid,
	 usedate,
	 driver,
	 carno,
	 begindate,
	 begintime,
	 enddate,
	 endtime,
	 frompos,
	 beginnumber,
	 endnumber,
	 number_n,
	 userid,
	 userdepid,
	 isotherplace) 
 
VALUES 
	( requestid_1,
	 date_2,
	 driver_3,
	 carno_4,
	 begindate_5,
	 begintime_6,
	 enddate_7,
	 endtime_8,
	 frompos_9,
	 beginnumber_10,
	 endnumber_11,
	 number_12,
	 userid_13,
	 userdepid_14,
	 isotherplace_15);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptCarOut_Update 
	(id_1 	integer,
	 date_2 	varchar2,
	 driver_3 	integer,
	 carno_4 	integer,
	 begindate_5 	varchar2,
	 begintime_6 	varchar2,
	 enddate_7 	varchar2,
	 endtime_8 	varchar2,
	 frompos_9 	varchar2,
	 beginnumber_10 	number,
	 endnumber_11 	number,
	 number_12 	number,
	 userid_13 	integer,
	 userdepid_14 	integer,
	 isotherplace_15 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS
begin
UPDATE bill_CptCarOut 

SET  usedate	 = date_2,
	 driver	 = driver_3,
	 carno	 = carno_4,
	 begindate	 = begindate_5,
	 begintime	 = begintime_6,
	 enddate	 = enddate_7,
	 endtime	 = endtime_8,
	 frompos	 = frompos_9,
	 beginnumber	 = beginnumber_10,
	 endnumber	 = endnumber_11,
	 number_n	 = number_12,
	 userid	 = userid_13,
	 userdepid	 = userdepid_14,
	 isotherplace	 = isotherplace_15 

WHERE 
	( id	 = id_1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptCheckDetail_Insert 
	(cptcheckid1 	integer,
	cptid1 	integer,
	 theorynumber1 	number,
	 realnumber1 	number,
	 price1 	number,
	 remark1 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptCheckDetail 
	 ( cptcheckid,
	 cptid,
	 theorynumber,
	 realnumber,
	 price,
	 remark) 
 
VALUES 
	( cptcheckid1,
	cptid1,
	 theorynumber1,
	 realnumber1,
	 price1,
	 remark1);
end;
/




 CREATE or REPLACE PROCEDURE bill_CptCheckDetail_Select 
	(cptcheckid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptCheckDetail 
WHERE 
	( cptcheckid	 = cptcheckid1);
end;
/




 CREATE or REPLACE PROCEDURE bill_CptCheckMain_Select 
	(id1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptCheckMain 
WHERE 
	( id	 = id1);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptFetchDetail_Insert 
	(cptfetchid1 	integer,
	cptid_1 	integer,
	 number_2 	number,
	 unitprice_3 	number,
	 amount_4 	number,
	 needdate_5 	varchar2,
	 purpose_6 	varchar2,
	 cptdesc_7 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptFetchDetail 
	 ( cptfetchid,
	 cptid,
	 number_n,
	 unitprice,
	 amount,
	 needdate,
	 purpose,
	 cptdesc) 
 
VALUES 
	( cptfetchid1,
	cptid_1,
	 number_2,
	 unitprice_3,
	 amount_4,
	 needdate_5,
	 purpose_6,
	 cptdesc_7);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptFetchDetail_Select 
	(cptfetchid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptFetchDetail 
WHERE 
	( cptfetchid	 = cptfetchid1);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptFetchDetail_Update 
	(id_1 	integer,
	 cptid_3 	integer,
	 number_4 	number ,
	 unitprice_5 	number,
	 amount_6 	number,
	 needdate_7 	varchar2,
	 purpose_8 	varchar2,
	 cptdesc_9 	varchar2,
	 capitalid 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE  bill_CptFetchDetail 

SET  
	 cptid	 = cptid_3,
	 number_n	 = number_4,
	 unitprice	 = unitprice_5,
	 amount	 = amount_6,
	 needdate	 = needdate_7,
	 purpose	 = purpose_8,
	 cptdesc	 = cptdesc_9 ,
	 capitalid	 = capitalid

WHERE 
	( id	 = id_1);
	end;
/



 CREATE or REPLACE PROCEDURE bill_CptFetchMain_Select 
	(id1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptFetchMain 
WHERE 
	( id	 = id1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptPlanDetail_Insert 
	(cptplanid1 	integer,
	cptid_1 	integer,
	 number_2 	number,
	 unitprice_3 	number,
	 amount_4 	number,
	 needdate_5 	varchar2,
	 purpose_6 	varchar2,
	 cptdesc_7 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptPlanDetail 
	 ( cptplanid,
	 cptid,
	 number_n,
	 unitprice,
	 amount,
	 needdate,
	 purpose,
	 cptdesc) 
 
VALUES 
	( cptplanid1,
	cptid_1,
	 number_2,
	 unitprice_3,
	 amount_4,
	 needdate_5,
	 purpose_6,
	 cptdesc_7);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptPlanDetail_Select 
	(cptplanid_2 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptPlanDetail 
WHERE 
	( cptplanid	 = cptplanid_2);
end;
/




 CREATE or REPLACE PROCEDURE bill_CptPlanDetail_Update 
	(id_1 	integer,
	 cptplanid_2 	integer,
	 cptid_3 	integer,
	 number_4 	number,
	 unitprice_5 	number,
	 amount_6 	number,
	 needdate_7 	varchar2,
	 purpose_8 	varchar2,
	 cptdesc_9 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE  bill_CptPlanDetail 

SET  cptplanid	 = cptplanid_2,
	 cptid	 = cptid_3,
	 number_n	 = number_4,
	 unitprice	 = unitprice_5,
	 amount	 = amount_6,
	 needdate	 = needdate_7,
	 purpose	 = purpose_8,
	 cptdesc	 = cptdesc_9 

WHERE 
	( id	 = id_1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptPlanMain_Select 
	(id1 integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptPlanMain 
WHERE 
	( id	 = id1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptRequireDetail_Insert 
	(cptrequireid1 	integer,
	cpttype1 	integer,
	cptid_1 	integer,
	 number_2 	number,
	 unitprice_3 	number,
	 needdate_5 	varchar2,
	 purpose_6 	varchar2,
	 cptdesc_7 	varchar2,
	 buynumber1 	number,
	 adjustnumber1 	number,
	 fetchnumber1 	number,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptRequireDetail 
	 ( cptrequireid,
	 cpttype,
	 cptid,
	 number_n,
	 unitprice,
	 needdate,
	 purpose,
	 cptdesc,
	 buynumber,
	 adjustnumber,
	 fetchnumber) 
 
VALUES 
	( cptrequireid1,
	cpttype1,
	cptid_1,
	 number_2,
	 unitprice_3,
	 needdate_5,
	 purpose_6,
	 cptdesc_7,
	 buynumber1,
	 adjustnumber1,
	 fetchnumber1
	 );
end;
/



 CREATE or REPLACE PROCEDURE bill_CptRequireDetail_Select 
	(cptrequireid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptRequireDetail 
WHERE 
	( cptrequireid	 = cptrequireid1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptRequireDetail_Update 
	(id_1 	integer,
	 cpttype1 	integer,
	cptid_1 	integer,
	 number_2 	number,
	 unitprice_3 	number,
	 needdate_5 	varchar2,
	 purpose_6 	varchar2,
	 cptdesc_7 	varchar2,
	 buynumber1 	number,
	 adjustnumber1 	number,
	 fetchnumber1 	number,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE  bill_CptRequireDetail 

SET  
	 cpttype	 = cpttype1,
	 cptid	 = cptid_1,
	 number_n	 = number_2,
	 unitprice	 = unitprice_3,
	 needdate	 = needdate_5,
	 purpose	 = purpose_6,
	 cptdesc	 = cptdesc_7 ,
	 buynumber	 = buynumber1 ,
	 adjustnumber	 = adjustnumber1 ,
	 fetchnumber	 = fetchnumber1 

WHERE 
	( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE bill_CptRequireMain_Select 
	(id1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptRequireMain 
WHERE 
	( id	 = id1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptStockInDetail_Insert 
	(cptstockinid1 	integer,
	cptid_1 	integer,
	 number_2 	number,
	 unitprice_3 	number,
	 amount_4 	number,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO bill_CptStockInDetail 
	 ( cptstockinid,
	 cptid,
	 plannumber,
	 planprice,
	 planamount) 
 
VALUES 
	( cptstockinid1,
	cptid_1,
	 number_2,
	 unitprice_3,
	 amount_4);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptStockInDetail_Select 
	(cptstockinid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptStockInDetail 
WHERE 
	( cptstockinid	 = cptstockinid1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptStockInDetail_SSum 
	(cptstockinid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT count(id)  from  bill_CptStockInDetail 
WHERE 
	( cptstockinid	 = cptstockinid1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptStockInDetail_Update 
	(id_1 	integer,
	 cptno_3 	varchar2,
	 cptid_4 	integer,
	 cpttype_5 	varchar2,
	 plannumber_6 	decimal,
	 innumber_7 	decimal,
	 planprice_8 	decimal,
	 inprice_9 	decimal,
	 planamount_10 	decimal,
	 inamount_11 	decimal,
	 difprice_12 	decimal,
	  capitalid2 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE bill_CptStockInDetail 

SET  	 cptno	 = cptno_3,
	 cptid	 = cptid_4,
	 cpttype	 = cpttype_5,
	 plannumber	 = plannumber_6,
	 innumber	 = innumber_7,
	 planprice	 = planprice_8,
	 inprice	 = inprice_9,
	 planamount	 = planamount_10,
	 inamount	 = inamount_11,
	 difprice	 = difprice_12 ,
	 capitalid	 = capitalid2 

WHERE 
	( id	 = id_1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptStockInDetail_Update2 
	(id_1 	integer,
	 capitalid1 	integer,
	 mark1 	varchar2,
	 capitalspec1    varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE  bill_CptStockInDetail 

SET  
	 capitalid	 = capitalid1 ,
	 cptno	 = mark1,
	 cpttype   = capitalspec1

WHERE 
	( id	 = id_1);
end;
/



 CREATE or REPLACE PROCEDURE bill_CptStockInMain_Select 
	(id1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptStockInMain 
WHERE 
	( id	 = id1);
end;
/



 CREATE or REPLACE PROCEDURE bill_Discuss_UpdateStatus 
 (
	id1		integer,
	status1	 char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	update bill_Discuss set status=status where id=id1 ;
end;
/



 CREATE or REPLACE PROCEDURE bill_HireResource_UpdateStatus 
 (
	id1		integer,
	status1	char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	update bill_HireResource set status=status where id=id1;
end;
/



 CREATE or REPLACE PROCEDURE bill_HotelBookDetail_Delete
 (
	bookid1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	delete from bill_HotelBookDetail where bookid=bookid1;
end;
/


 CREATE or REPLACE PROCEDURE bill_HotelBookDetail_Insert 
 (
	bookid1		integer,
	hotelid1    integer,
	roomstyle1  varchar2,
	roomsum1    integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	insert into bill_HotelBookDetail (bookid,hotelid,roomstyle,roomsum)
	values (bookid1,hotelid1,roomstyle1,roomsum1);
end;
/


 CREATE or REPLACE PROCEDURE bill_HotelBookDetail_SByBooki 
 (
	bookid1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
open thecursor for

	select * from bill_HotelBookDetail where bookid=bookid1;
end;
/


 CREATE or REPLACE PROCEDURE bill_HotelBook_UpdateStatus 
 (
	id1		integer,
	status1	char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
	update bill_HotelBook set status=status1 where id=id1 ;
end;
/


/* 9.3 */
 CREATE or REPLACE PROCEDURE bill_HrmFinance_Insert 
 (
	resourceid1		integer,
	requestid1		integer,
	billid1			integer,
	basictype1		integer,
	detailtype1		integer,
	amount1			number,
	crmid1			integer,
	projectid1		integer,
	docid1			integer,
	name1			varchar2,
	description1 	varchar2,
	remark1			varchar2,
	occurdate1		char ,
	occurtime1		char ,
	relatedrequestid1	integer,
	relatedresource1	varchar2,
	accessory1		integer,
	debitledgeid1	integer,
	debitremark1        varchar2,			
	creditledgeid1      integer,					
	creditremark1       varchar2,		
	currencyid1         integer,					
	exchangerate1       varchar2,			
	status1				char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
	insert into bill_HrmFinance 
	(resourceid,requestid,billid,basictype,detailtype,amount,crmid,projectid,docid,name,
	 description,remark,occurdate,occurtime,relatedrequestid,relatedresource,accessory,
	 debitledgeid,debitremark,creditledgeid,creditremark,currencyid,exchangerate,status)
	values
	(resourceid1,requestid1,billid1,basictype1,detailtype1,amount1,crmid1,projectid1,docid1,name1,
	description1,remark1,occurdate1,occurtime1,relatedrequestid1,relatedresource1,accessory1,
	debitledgeid1,debitremark1,creditledgeid1,creditremark1,currencyid1,exchangerate1,status1);
	open thecursor for

	select max(id) from bill_hrmfinance;
end;
/


 CREATE or REPLACE PROCEDURE bill_HrmFinance_SelectByID 
 (
	id1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for

	select * from bill_hrmfinance where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE bill_HrmFinance_SelectLoan 
 (
  resourceid1	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
   tmpamount1   number(10,3);
         tmpamount2   number(10,3);
 begin

  select sum(amount) INTO tmpamount1 from bill_hrmfinance 
  where resourceid=resourceid1 and status='1' and basictype=3;
  
  select sum(amount) INTO  tmpamount2 from bill_hrmfinance
  where resourceid=resourceid1 and status='1' and basictype in(1,4);
  
  if    tmpamount1 is null then
          tmpamount1 := 0;
		  end if;
  if    tmpamount2 is null then
          tmpamount2 := 0;
		  end if;
  if tmpamount1>=tmpamount2 then
      tmpamount1 := tmpamount1-tmpamount2;
  else
      tmpamount1 := 0;
	  end if;
	  open thecursor for
  select tmpamount1 from dual; 
end;
/


 CREATE or REPLACE PROCEDURE bill_HrmFinance_Update 
 (
	id1				integer,
	resourceid1		integer,
	requestid1		integer,
	billid1			integer,
	basictype1		integer,
	detailtype1		integer,
	amount1			number,
	crmid1			integer,
	projectid1		integer,
	docid1			integer,
	name1			varchar2,
	description1	varchar2,
	remark1			varchar2,
	occurdate1		char ,
	occurtime1		char ,
	relatedrequestid1	integer,
	relatedresource1	varchar2,
	accessory1		integer,
	debitledgeid1	integer,
	debitremark1        varchar2,			
	creditledgeid1      integer,					
	creditremark1       varchar2,		
	currencyid1         integer,					
	exchangerate1       varchar2,			
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
	begin
	update bill_HrmFinance 
	set resourceid=resourceid1,requestid=requestid1,billid=billid1,
		basictype=basictype1,detailtype=detailtype1,amount=amount1,
		crmid=crmid1,projectid=projectid1,docid=docid1,name=name1,
	 	description=description1,remark=remark1,occurdate=occurdate1,
	 	occurtime=occurtime1,relatedrequestid=relatedrequestid1,
	 	relatedresource=relatedresource1,accessory=accessory1,
	 	debitledgeid=debitledgeid1,debitremark=debitremark1,
	 	creditledgeid=creditledgeid1,creditremark=creditremark1,
	 	currencyid=currencyid1,exchangerate=exchangerate1
	where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE bill_HrmFinance_UpdateRemind 
 (
  id1	integer, 
  isremind1        integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
  Update bill_hrmfinance set isremind=isremind1 where id=id1;
end;
/



 CREATE or REPLACE PROCEDURE bill_HrmFinance_UpdateStatus 
	(id1		integer,
	 status1	char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update bill_hrmfinance set status=status1 where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE bill_HrmTime_Insert 
	(resourceid1 	integer,
	 requestid1 	integer,
	 billid1 	integer,
	 basictype1 	integer,
	 detailtype1 	integer,
	 begindate1 	char,
	 begintime1 	char,
	 enddate1 	char,
	 endtime1 	char,
	 name1	 	varchar2,
	 description1 	varchar2,
	 remark1 	varchar2,
	 totaldays1 	integer,
	 totalhours1	number,
	 progress1	number,
	 projectid1	integer,
	 crmid1		integer,
	 docid1		integer,
	 relatedrequestid1	integer,
	 status1    	char,
	 customizeint11	integer,
	 customizeint21	integer,
	 customizeint31	integer,
	 customizefloat11	number,
	 customizestr11	varchar2,
	 customizestr21	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO bill_hrmtime
	(resourceid,requestid,billid,basictype,detailtype,
	 begindate,begintime,enddate,endtime,
	 name,description,remark,totaldays,totalhours,
	 progress,projectid,crmid,docid,
	 relatedrequestid,status,customizeint1,customizeint2,customizeint3,
	 customizefloat1,customizestr1,customizestr2) 
VALUES 
	(resourceid1,requestid1,billid1,basictype1,detailtype1,
	 begindate1,begintime1,enddate1,endtime1,
	 name1,description1,remark1,totaldays1,totalhours1,
	 progress1,projectid1,crmid1,docid1,
	 relatedrequestid1,status1,customizeint11,customizeint21,customizeint31,
	 customizefloat11,customizestr11,customizestr21) ;
	 open thecursor for
select max(id) from bill_hrmtime;
end;
/


 CREATE or REPLACE PROCEDURE bill_HrmTime_SelectByID 
	(id1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for

	select * from bill_hrmtime where id=id1;
end;
/


/* 8.22 */
 CREATE or REPLACE PROCEDURE bill_HrmTime_Update 
	(id1		integer,
	 resourceid1 	integer,
	 requestid1 	integer,
	 billid1 	integer,
	 basictype1 	integer,
	 detailtype1 	integer,
	 begindate1 	char ,
	 begintime1 	char ,
	 enddate1 	char ,
	 endtime1 	char ,
	 name1	 	varchar2,
	 description1 	varchar2,
	 remark1 	varchar2,
	 totaldays1 	integer,
	 totalhours1	number,
	 progress1	number,
	 projectid1	integer,
	 crmid1		integer,
	 docid1		integer,
	 relatedrequestid1	integer,
	 customizeint11	integer,
	 customizeint21	integer,
	 customizeint31	integer,
	 customizefloat11	number,
	 customizestr11	varchar2,
	 customizestr21 varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
update bill_hrmtime
set resourceid=resourceid1,
    requestid=requestid1,
    billid=billid1,
    basictype=basictype1,
    detailtype=detailtype1,
    begindate=begindate1,
    begintime=begintime1,
    enddate=enddate1,
    endtime=endtime1,
    name=name1,
    description=description1,
    remark=remark1,
    totaldays=totaldays1,
    totalhours=totalhours1,
    progress=progress1,
    projectid=projectid1,
    crmid=crmid1,
    docid=docid1,
    relatedrequestid=relatedrequestid1,
    customizeint1=customizeint11,
    customizeint2=customizeint21,
    customizeint3=customizeint31,
    customizefloat1=customizefloat11,
    customizestr1=customizestr11,
    customizestr2=customizestr21
where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE bill_HrmTime_UpdateRemind 
 (
  id1	integer, 
  isremind1        integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
  Update bill_hrmtime set isremind=isremind1 where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE bill_HrmTime_UpdateStatus 
	(id1		integer,
	 status1	char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update bill_hrmtime set status=status1 where id=id1;
end;
/

 CREATE or REPLACE PROCEDURE bill_LeaveJob_UpdateStatus 
 (
	id1		integer,
	status1	char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	update bill_LeaveJob set status=status1 where id=id1; 
end;
/

 CREATE or REPLACE PROCEDURE bill_MailboxApply_UpdateStatus 
 (
	id1		integer,
	status1	char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	update bill_MailboxApply set status=status1 where id=id1; 
end;
/


 CREATE or REPLACE PROCEDURE bill_NameCard_UpdateStatus 
 (
	id1		integer,
	status1	char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	update bill_NameCard set status=status1 where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE bill_NameCardinfo_SByResource 
 (
	resourceid1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
open thecursor for

	select * from bill_NameCardinfo where resourceid=resourceid1;
	end;
/



 CREATE or REPLACE PROCEDURE bill_TotalBudget_UpdateStatus 
 (
	id1		integer,
	status1	char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	update Bill_TotalBudget set status=status1 where id=id1; 
end;
/


 CREATE or REPLACE PROCEDURE bill_contract_SelectById 
 (id1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT *  from bill_contract where id=id1; 
end;
/


 CREATE or REPLACE PROCEDURE bill_contractdetail_Insert 
 (contractid1 	integer, assetid_2 	integer, batchmark_3 	varchar2, 
 number_4 	float, currencyid_5 	integer, defcurrencyid_6 	integer, 
 exchangerate_7 	number, defunitprice_8 	number, unitprice_9 	number, taxrate_10 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS
begin
INSERT INTO bill_contractdetail ( contractid, assetid, batchmark, 
number_n, currencyid, defcurrencyid, exchangerate, defunitprice, unitprice, taxrate)  
VALUES ( contractid1, assetid_2, batchmark_3, number_4, currencyid_5, defcurrencyid_6, exchangerate_7, defunitprice_8, unitprice_9, taxrate_10) ;
end;
/


 CREATE or REPLACE PROCEDURE bill_contractdetail_Select 
 (id1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT *  from bill_contractdetail where contractid=id1; 
end;
/


 CREATE or REPLACE PROCEDURE bill_contractdetail_Update 
 (id_1 	integer, contractid1 	integer, assetid_3 	integer, 
 batchmark_4 	varchar2, number_5 	float, currencyid_6 	integer,
 defcurrencyid_7 	integer, exchangerate_8 	number, defunitprice_9 	number,
 unitprice_10 	number, taxrate_11 	integer,  flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS
begin
UPDATE bill_contractdetail  SET  contractid	 = contractid1, 
assetid	 = assetid_3, batchmark	 = batchmark_4, number_n	 = number_5, 
currencyid	 = currencyid_6, defcurrencyid	 = defcurrencyid_7, 
exchangerate	 = exchangerate_8, defunitprice	 = defunitprice_9,
unitprice	 = unitprice_10, taxrate	 = taxrate_11  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE bill_includepages_SelectByID 
 (
id1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
open thecursor for

select * from workflow_bill where id=id1;
end;
/


 CREATE or REPLACE PROCEDURE bill_itemusage_Select 
 (
 id1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
SELECT * from bill_itemusage where id=id1; 
end;
/


 CREATE or REPLACE PROCEDURE bill_itemusage_UpdateStatus 
 (id1 integer, usestatus1 char ,flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
update bill_itemusage set usestatus = usestatus1 where id=id1; 
end;
/


 CREATE or REPLACE PROCEDURE bill_monthinfodetail_DByType 
 (
	infoid1		integer,
	type1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
	delete from bill_monthinfodetail where infoid=infoid1 and type=type1;
end;
/


 CREATE or REPLACE PROCEDURE bill_monthinfodetail_Insert 
 (
	infoid1		integer,
	type1		integer,
	targetname1	varchar2,
	targetresult1	varchar2,
	forecastdate1	char,
	scale1		number,
	point1		smallint,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)as
begin
	insert into bill_monthinfodetail (infoid,type,targetname,targetresult,forecastdate,scale,point)
	values (infoid1,type1,targetname1,targetresult1,forecastdate1,scale1,point1);
end;
/


 CREATE or REPLACE PROCEDURE bill_monthinfodetail_SByType 
 (
	infoid1		integer,
	type1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
open thecursor for

	select * from bill_monthinfodetail where infoid=infoid1 and type=type1;
end;
/


 CREATE or REPLACE PROCEDURE bill_monthinfodetail_UByPoint 
 (
	id1		integer,
	point1	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)as
begin
	update bill_monthinfodetail set point=point1 where id=id1; 
end;
/


 CREATE or REPLACE PROCEDURE bill_workinfo_SSubordinate 
 (
	formid1		integer,
	userid1     integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)as
begin
open thecursor for

	select * from bill_workinfo where billid=formid1 and status='1' and mainid is null and manager=userid1;
end;
/


 CREATE or REPLACE PROCEDURE bill_workinfo_UpdateMainid 
 (
	formid1		integer,
	userid1     integer,
	mainid1     integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	update bill_workinfo set mainid=mainid1
	where billid=formid1 and status='1' and mainid is null and manager=userid1;
end;
/


 CREATE or REPLACE PROCEDURE bill_workinfo_UpdateStatus
 (
	id1		integer,
	status1	char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
	update bill_workinfo set status=status where id=id1; 
end;
/


 CREATE or REPLACE PROCEDURE bill_workinfodetail_DByType 
 (
	infoid1		integer,
	type1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	delete from bill_weekinfodetail where infoid=infoid1 and type=type1;
end;
/


 CREATE or REPLACE PROCEDURE bill_workinfodetail_Insert 
 (
	infoid1		integer,
	type1		integer,
	workname1	varchar2,
	workdesc1	varchar2,
	forecastdate1	char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
	insert into bill_weekinfodetail (infoid,type,workname,workdesc,forecastdate)
	values (infoid1,type1,workname1,workdesc1,forecastdate1);
end;
/


 CREATE or REPLACE PROCEDURE bill_workinfodetail_SByType 
 (
	infoid1		integer,
	type1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
open thecursor for

	select * from bill_weekinfodetail where infoid=infoid1 and type=type1;
end;
/


 CREATE or REPLACE PROCEDURE hrmroles_selectSingle 
 (
 id1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )as

begin 
open thecursor for

select rolesmark,rolesname,docid from hrmroles where id=id1 ;
end;
/




CREATE GLOBAL TEMPORARY TABLE temp_table_02
 (id integer,
 rolesmark varchar2(60), 
 rolesname varchar2(200), 
 cnt int null)
 ON COMMIT DELETE ROWS
/


 CREATE or REPLACE PROCEDURE hrmroles_selectall 
 (
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 as 
 id_1 integer;
 rolesmark_1 varchar2(60);
 rolesname_1 varchar2(200);
 id_2 integer;
 cnt_2 integer;
CURSOR all_cursor is select id,rolesmark,rolesname from hrmroles ;
CURSOR roles_cursor is select id from hrmroles ;
 begin 
	open all_cursor;
		loop
		fetch all_cursor INTO id_1,rolesmark_1,rolesname_1; 
		exit when all_cursor%NOTFOUND;	
	 insert into temp_table_02 (id,rolesmark,rolesname)
	 values (id_1,rolesmark_1,rolesname_1) ;
	end  loop;

    
	open roles_cursor;
		loop
		fetch roles_cursor INTO id_2; 
		exit when roles_cursor%NOTFOUND;	

	  select count(id) INTO cnt_2 from HrmRoleMembers where roleid=id_2 ;
      update  temp_table_02 set cnt=cnt_2 where id=id_2 ;
	end  loop;
 open thecursor for
 select id,rolesmark,rolesname,cnt from temp_table_02; 
 close all_cursor ;
 close roles_cursor ;
end;
/







 CREATE or REPLACE PROCEDURE hrmroles_selectbyrole 
 (
 roleid1 integer, rolelevel1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )AS
begin
open thecursor for
SELECT resourceid,rolelevel,id from hrmrolemembers where roleid=roleid1 and rolelevel=rolelevel1 order by rolelevel ;
end;
/


 CREATE or REPLACE PROCEDURE hrmroles_update 
 (
 id1 integer,
 rolesmark1 varchar2,
 rolesname1 varchar2, 
 docid1 IN OUT  integer, 
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
if  docid1 = 0   then
 docid1 := null ;
 end if;
 update hrmroles
 set rolesmark=rolesmark1,rolesname=rolesname1,docid=docid1 
where id=id1 ;
end;
/


 CREATE or REPLACE PROCEDURE imagefile_AddByDoc 
 (fileid1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS 
	begin
	update imagefile set imagefileused=imagefileused+1 where imagefileid= fileid1; 
end;
/


 CREATE or REPLACE PROCEDURE imagefile_DeleteByDoc 
 (fileid1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  AS
	
	 imagefileused1 integer;
	 begin
	update imagefile 
	set imagefileused=imagefileused-1 where imagefileid= fileid1;
	select imagefileused  INTO  imagefileused1 from imagefile where imagefileid= fileid1;
	if imagefileused1 = 0 then
	delete from ImageFile where imagefileid = fileid1;
	end if;
end;
/






 

 CREATE or REPLACE PROCEDURE systemright_Srightsbygroup 
 (
 id1 integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin 
open thecursor for

select rightid from systemrighttogroup where groupid=id1;
end; 
/







 CREATE or REPLACE PROCEDURE workflow_CreateNode_Select 
 (
 workflowid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
open thecursor for
SELECT nodeid from workflow_flownode where workflowid=workflowid1 and nodetype='0' ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_CurrentOperator_I 
 (
    requestid1	integer, 
    userid1		integer, 
    groupid1	in out integer, 
    workflowid1	integer, 
    workflowtype1	integer, 
    usertype1	integer, 
    isremark1	char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
    AS 
	begin
	if groupid1 is null then
		groupid1 := 0 ;
	end if ;
    insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark)
    values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1);
end;
/


 CREATE or REPLACE PROCEDURE workflow_FieldForm_Select 
 (
 nodeid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
isbill1 char(1) ;
begin
select a.isbill into isbill1 from workflow_base a, workflow_flownode b 
where a.id = b.workflowid and b.nodeid = nodeid1 ;

if isbill1 = '1' then
open thecursor for
SELECT distinct a.* , b.dsporder from workflow_nodeform a, workflow_billfield b where a.fieldid= b.id and  nodeid=nodeid1 order by b.dsporder; 
else 
open thecursor for
SELECT * from workflow_nodeform  where  nodeid=nodeid1 order by fieldid ; 
end if ;

end;
/


 CREATE or REPLACE PROCEDURE workflow_FieldID_Select 
 (
  formid1		integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
   AS 
   begin
   open thecursor for

   select fieldid,fieldorder from workflow_formfield where formid=formid1 order by fieldid;
end;
/


 CREATE or REPLACE PROCEDURE workflow_FieldLabel_Select 
 (
 formid1		integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )AS
begin
open thecursor for
SELECT * from workflow_fieldlable where formid=formid1 and isdefault='1' order by fieldid ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_FieldValue_Select 
 (
 requestid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from workflow_form where requestid=requestid1; 
end;
/


 CREATE or REPLACE PROCEDURE workflow_NodeGroup_Select 
 (
 nodeid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
SELECT * from workflow_nodegroup where nodeid=nodeid1 order by id ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_NodeGroup_SelectByid 
 (
   id1	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
   AS 
   begin
   open thecursor for

   select * from workflow_nodegroup where id=id1;
end;
/



 CREATE or REPLACE PROCEDURE workflow_NodeLink_SPasstime 
 (
  nodeid1	integer, 
  nodepasstime1	float, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
  AS 
  begin
  open thecursor for

  select min(nodepasstime)   nodepasstime from workflow_nodelink where nodeid=nodeid1 and nodepasstime>nodepasstime1; 
end;
/


 CREATE or REPLACE PROCEDURE workflow_NodeLink_Select 
 (
  nodeid1	integer, 
  isreject1  char , 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  begin
if isreject1 = '1' then 
  open thecursor for
  select * from workflow_nodelink where nodeid=nodeid1 and isreject='1' 
  order by nodepasstime ,id;
else 
  open thecursor for
  select * from workflow_nodelink where nodeid=nodeid1 and (isreject is null or isreject !='1' )
  order by nodepasstime ,id;
end if;
end;
/


 CREATE or REPLACE PROCEDURE workflow_NodeType_Select 
 (
 workflowid1	integer, nodeid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT nodetype from workflow_flownode where workflowid=workflowid1 and nodeid=nodeid1; 
end;
/


 CREATE or REPLACE PROCEDURE workflow_Nodebase_SelectByID 
 (
 nodeid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )AS
begin
open thecursor for
SELECT * from workflow_nodebase where id=nodeid1; 
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestID_Update 
 (
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
update workflow_requestsequence set requestid=requestid+1  ;
open thecursor for
select requestid from workflow_requestsequence ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestLog_Insert 
 (
  requestid1	integer, 
  workflowid1	integer, 
  nodeid1	integer, 
  logtype1	char , 
  operatedate1	char, 
  operatetime1	char, 
  operator1	integer, 
  remark1	varchar2, 
  clientip1	char, 
  operatortype1	integer, 
  destnodeid1	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS
   count1 integer;
begin
  if logtype1 = '1' then
	 
	select  count(*) INTO  count1 from workflow_requestlog 
	where requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 
	and operator = operator1 and operatortype = operatortype1;
   
	  if count1 > 0 then
		
		update workflow_requestlog 
		SET	 operatedate	 = operatedate1,
			 operatetime	 = operatetime1,
			 remark	 = remark1,
			 clientip	 = clientip1,
			 destnodeid	 = destnodeid1 

		WHERE 
			( requestid	 = requestid1 AND
			 nodeid	 = nodeid1 AND
			 logtype	 = logtype1 AND
			 operator	 = operator1 AND
			 operatortype	 = operatortype1);
		
	  else
		
		insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator,
		remark,clientip,operatortype,destnodeid)
		values(requestid1,workflowid1,nodeid1,logtype1, operatedate1,operatetime1,operator1,
		 remark1,clientip1,operatortype1,destnodeid1);
		end if;
	
   else 
	
	delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype1='1' or logtype1='7') 
				and operator = operator1 and operatortype = operatortype1;
	
	insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator,
	remark,clientip,operatortype,destnodeid)
	values(requestid1,workflowid1,nodeid1,logtype1, operatedate1,operatetime1,operator1, remark1,clientip1,operatortype1,destnodeid1);
	
end if;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestLog_SBUser 
 (
	requestid1	integer, 
	operator1 integer,
	operatortype1 integer,
	logtype1 char  ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
select * from workflow_requestlog 
where requestid=requestid1 and operator=operator1 
and operatortype=operatortype1 and logtype=logtype1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestLog_SNSave 
 (
 requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS 
 begin
 open thecursor for
 select  t1.*, t2.nodename 
 from workflow_requestlog t1,workflow_nodebase t2 
 where requestid=requestid1 and t1.nodeid=t2.id and 
 t1.logtype != '1' 
 order by operatedate desc,operatetime desc;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestLog_SNSRemark 
 (
 requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 open thecursor for

 select  t1.*, t2.nodename 
 from workflow_requestlog t1,workflow_nodebase t2 
 where requestid=requestid1 and t1.nodeid=t2.id and 
 t1.logtype != '1' and t1.logtype != '7' 
 order by operatedate desc,operatetime desc;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestLog_Select
 (
 requestid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT t1.*,t2.nodename from workflow_requestlog t1,workflow_nodebase t2 where requestid=requestid1 and t1.nodeid=t2.id order by operatedate desc,operatetime desc ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestRemark_Delete 
 (
 requestid1	integer, userid1		integer, isremark1	char , flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )AS
begin
delete from workflow_currentoperator where requestid=requestid1 and userid=userid1 and isremark=isremark1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestRemark_Insert 
 (
	requestid1	integer,
	userid1		integer,
	groupid1 in out integer,
	workflowid1	integer,
	workflowtype1	integer,
	isremark1	char,
	usertype1	char,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
	if groupid1 is null then
		groupid1 := 0 ;
	end if ;

	insert into workflow_currentoperator
	(requestid,userid,groupid,workflowid,workflowtype,isremark,usertype)
	values
	(requestid1,userid1,groupid1,workflowid1,workflowtype1,isremark1,usertype1);
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestRemark_SByUser 
 (
	requestid1	integer,
	userid1		integer,
	isremark1	char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for

	select * from workflow_currentoperator
	where requestid=requestid1 and userid=userid1 and isremark=isremark1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestRemark_Select 
 (
 requestid1	integer, isremark1	char , flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) AS
begin
open thecursor for
SELECT userid from workflow_currentoperator where requestid=requestid1 and isremark=isremark1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RUserDefault_Insert
 (
  userid1	integer, 
  selectedworkflow1 varchar2,
  isuserdefault1    char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
  insert into workflow_requestUserdefault values(userid1,selectedworkflow1,isuserdefault1);
end;
/


 CREATE or REPLACE PROCEDURE workflow_RUserDefault_Select 
 (
  userid1	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
open thecursor for

  select * from workflow_requestUserdefault where userid=userid1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RUserDefault_Update 
 (
  userid1	integer, 
  selectedworkflow1 varchar2,
  isuserdefault1    char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
  Update workflow_requestUserdefault set selectedworkflow=selectedworkflow1,isuserdefault=isuserdefault1
  where userid=userid1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_RequestViewLog_Insert 
 (
   id1	integer, 
   viewer1	integer, 
   viewdate1	char , 
   viewtime1	char , 
   clientip1	char , 
   viewtype1	integer,
   currentnodeid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
    AS 
	begin
	insert into workflow_requestviewlog (id,viewer, viewdate,viewtime,ipaddress,viewtype,currentnodeid)
    values(id1,viewer1, viewdate1,viewtime1,clientip1,viewtype1,currentnodeid1);
end;
/


 CREATE or REPLACE PROCEDURE workflow_Requestbase_Delete 
 (
 requestid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )as
begin
update workflow_requestbase set deleted=1 where requestid=requestid1; 
end;
/


 CREATE or REPLACE PROCEDURE workflow_Requestbase_Insert 
 (
   requestid1	integer, 
   workflowid1	integer, 
   lastnodeid1	integer, 
   lastnodetype1	char , 
   currentnodeid1	integer, 
   currentnodetype1	char , 
   status1		varchar2, 
   passedgroups1	integer, 
   totalgroups1	integer, 
   requestname1	varchar2, 
   creater1	integer, 
   createdate1	char , 
   createtime1	char, 
   lastoperator1	integer, 
   lastoperatedate1	char, 
   lastoperatetime1	char, 
   deleted1	in out integer, 
   creatertype1	integer, 
   lastoperatortype1	integer, 
   nodepasstime1	float, 
   nodelefttime1	float, 
   docids1 		varchar2,
   crmids1 		varchar2,
   hrmids1 		varchar2,
   prjids1 		varchar2,
   cptids1 		varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
   AS 
   begin
   deleted1 :=0 ;

   insert into workflow_requestbase (requestid,workflowid,lastnodeid,lastnodetype, currentnodeid,currentnodetype,
   status, passedgroups,totalgroups,requestname, creater,createdate,createtime,lastoperator,
  lastoperatedate,lastoperatetime,deleted,creatertype,lastoperatortype,nodepasstime,nodelefttime,docids,crmids,hrmids,prjids,cptids) 
   values(requestid1,workflowid1,lastnodeid1,lastnodetype1, currentnodeid1,currentnodetype1,status1, 
   passedgroups1,totalgroups1,requestname1, creater1,createdate1,createtime1,lastoperator1,
  lastoperatedate1,lastoperatetime1,deleted1,creatertype1,lastoperatortype1,nodepasstime1,nodelefttime1,
  docids1,crmids1,hrmids1,prjids1,cptids1)  ; 
end;
/


 CREATE or REPLACE PROCEDURE workflow_Requestbase_SByID 
 (
 requestid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
SELECT * from workflow_requestbase where requestid=requestid1; 
end;
/


 CREATE or REPLACE PROCEDURE workflow_Requestbase_Update 
 (
  requestid1	integer, 
  workflowid1	integer, 
  lastnodeid1	integer, 
  lastnodetype1	char , 
  currentnodeid1	integer, 
  currentnodetype1	char , 
  status1		varchar2, 
  passedgroups1	integer, 
  totalgroups1	integer, 
  requestname1	varchar2, 
  creater1	integer, 
  createdate1	char , 
  createtime1	char , 
  lastoperator1	integer, 
  lastoperatedate1	char , 
  lastoperatetime1	char ,
   deleted1	in out integer, 
   creatertype1	integer, 
   lastoperatortype1	integer, 
    nodepasstime1	float, 
   nodelefttime1	float, 
   docids1 		varchar2,
   crmids1 		varchar2,
   hrmids1 		varchar2,
   prjids1 		varchar2,
   cptids1 		varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
   AS 
   begin

   update workflow_requestbase set 
   workflowid=workflowid1, 
   lastnodeid=lastnodeid1, 
   lastnodetype=lastnodetype1, 
   currentnodeid=currentnodeid1, 
   currentnodetype=currentnodetype1, 
   status=status1, 
   passedgroups=passedgroups1, 
   totalgroups=totalgroups1, 
   requestname=requestname1, 
   creater=creater1, 
   createdate=createdate1, 
   createtime=createtime1, 
   lastoperator=lastoperator1, 
   lastoperatedate=lastoperatedate1, 
   lastoperatetime=lastoperatetime1, 
   deleted=deleted1 ,
   creatertype=creatertype1,
   lastoperatortype=lastoperatortype1,
   nodepasstime=nodepasstime1,
   nodelefttime=nodelefttime1,
   docids=docids1,
   crmids=crmids1,
   hrmids=hrmids1,
   prjids=prjids1,
   cptids=cptids1
   where requestid=requestid1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_Rbase_UpdateLevel 
 (
  requestid1	integer, 
  level_n1        integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
  Update workflow_requestbase set requestlevel=level_n1 where requestid=requestid1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_SelectItemSByvalue 
  (id_1 varchar2, 
  isbill_2 varchar2, 
  selectvalue_3 integer ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  begin
  open thecursor for

  select * from workflow_SelectItem where fieldid = id_1 and isbill = isbill_2 and selectvalue = selectvalue_3;
end;
/

 CREATE or REPLACE PROCEDURE workflow_SelectItemSelectByid 
 (
  id1 varchar2, 
  isbill1 varchar2, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  begin 
  open thecursor for

  select * from workflow_SelectItem where fieldid = id1 and isbill = isbill1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_SelectItem_DByFieldid 
	(fieldid2 		integer,
	 isbill2 		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin

	delete from workflow_selectitem where fieldid=fieldid2 and isbill=isbill2;
end;
/


 CREATE or REPLACE PROCEDURE workflow_SelectItem_Insert 
	(fieldid2 		integer,
	 isbill2 		integer,
	 selectvalue2 	integer,
	 selectname2 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)
	values(fieldid2,isbill2,selectvalue2,selectname2);
end;
/


 CREATE or REPLACE PROCEDURE workflow_Workflowbase_SByID 
 (
 workflowid	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
SELECT * from workflow_base where id=workflowid ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_addinoperate_Delete 
	(id_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
DELETE workflow_addinoperate 

WHERE 
	( id	 = id_1);
end;
/



 CREATE or REPLACE PROCEDURE workflow_addinoperate_Insert 
	(objid_1 	integer,
	 isnode_2 	integer,
	 workflowid_3 	integer,
	 fieldid_4 	integer,
	 fieldop1id_5 	integer,
	 fieldop2id_6 	integer,
	 operation_7 	integer,
	 customervalue_8 	varchar2,
	 rules_9 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)

AS 
begin
INSERT INTO workflow_addinoperate 
	 ( objid,
	 isnode,
	 workflowid,
	 fieldid,
	 fieldop1id,
	 fieldop2id,
	 operation,
	 customervalue,
	 rules) 
 
VALUES 
	( objid_1,
	 isnode_2,
	 workflowid_3,
	 fieldid_4,
	 fieldop1id_5,
	 fieldop2id_6,
	 operation_7,
	 customervalue_8,
	 rules_9);
end;
/


 CREATE or REPLACE PROCEDURE workflow_addinoperate_select 
	(id1 	integer,
	isnode1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for

	select * from workflow_addinoperate where objid=id1 and isnode=isnode1 order by id;
end;
/


 CREATE or REPLACE PROCEDURE workflow_base_SelectByFormid 
	(formid2	integer,
	 isbill2	char ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS

begin
open thecursor for

	select * from workflow_base where formid=formid2 and isbill=isbill2;
end;
/


 CREATE or REPLACE PROCEDURE workflow_base_SelectByType 
 (
 workflowtypeid1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * from workflow_base where workflowtype=workflowtypeid1; 
end;
/


 CREATE or REPLACE PROCEDURE workflow_billfield_Select 
 (
formid1		integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for

select * from workflow_billfield where billid=formid1 order by dsporder;
end;
/


 CREATE or REPLACE PROCEDURE workflow_billfield_SelectByID 
 (
 id2	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
SELECT * from workflow_billfield where id=id2 ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_createrlist_Delete 
	(workflowid_1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
DELETE workflow_createrlist 

WHERE 
	( workflowid	 = workflowid_1);
end;
/


 CREATE or REPLACE PROCEDURE workflow_createrlist_Insert 
	(workflowid_1 	integer,
	 userid_2 	integer,
	 usertype_3 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO workflow_createrlist 
	 ( workflowid,
	 userid,
	 usertype) 
 
VALUES 
	( workflowid_1,
	 userid_2,
	 usertype_3);
end;
/


 CREATE or REPLACE PROCEDURE workflow_currentoperator_SByUs 
 (
  userid1		integer, 
  usertype1		integer, 
  requestid1	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )
  as 
  begin
  open thecursor for

  select * from workflow_currentoperator where requestid=requestid1 and userid=userid1 and usertype = usertype1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_currentoperator_SWf 
 (
  userid1		integer, 
usertype1	integer, 
  complete1 	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )
  as 
  begin
  if complete1=0  then
   open thecursor for

  select count( distinct t1.requestid) workflowcount,t1.workflowid from workflow_currentoperator t1,workflow_requestbase t2 
  where t1.isremark in( '0','1') and t1.userid=userid1 and t1.usertype=usertype1 and t1.requestid=t2.requestid 
  and (t2.deleted=0 or t2.deleted is null) and t2.currentnodetype<>'3' group by t1.workflowid ;
  end if; 
  if complete1=1 then
open thecursor for

   select count( distinct t1.requestid) workflowcount,t1.workflowid from workflow_currentoperator t1,workflow_requestbase t2
  where t1.userid=userid1 and t1.usertype=usertype1 and t1.requestid=t2.requestid and (t2.deleted=0 or t2.deleted is null) and t2.currentnodetype='3'
  group by t1.workflowid ;
  end if;
end;
/


 CREATE or REPLACE PROCEDURE workflow_currentoperator_SWft 
 (
  userid1		integer,
usertype1	integer, 
   complete1	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
    as 
	begin

    if complete1=0 then
     open thecursor for
    select count(distinct t1.requestid) typecount,t1.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 
	where t1.userid=userid1 and t1.isremark in( '0','1') and t1.usertype=usertype1 and t1.requestid=t2.requestid 
	and (t2.deleted=0 or t2.deleted is null) and t2.currentnodetype<>'3' group by t1.workflowtype ;
    end if;
    if complete1=1 then
open thecursor for
    select count(distinct t1.requestid) typecount,t1.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 
	where t1.userid=userid1 and t1.usertype=usertype1 and t1.requestid=t2.requestid and (t2.deleted=0 or t2.deleted is null) and t2.currentnodetype='3' group by t1.workflowtype ;
    end if;
end;
/


/* 8.21 */
 CREATE or REPLACE PROCEDURE workflow_form_SByRequestid 
	(requestid1 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
	select * from workflow_form where requestid=requestid1;
end;
/


 CREATE or REPLACE PROCEDURE workflow_groupdetail_DbyGroup 
 (id_1 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  AS 
begin
DELETE workflow_groupdetail  WHERE ( groupid	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_groupdetail_Delete 
 (id_1 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  AS 
begin
DELETE workflow_groupdetail  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_groupdetail_Insert 
  (groupid_1 	integer, 
  type_2 	integer, 
  objid_3 	integer, 
  level_4 	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
    AS 
	begin
    INSERT INTO workflow_groupdetail ( groupid, type, objid, level_n)
   VALUES ( groupid_1, type_2, objid_3, level_4) ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_groupdetail_SByGroup 
 (id_1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM workflow_groupdetail WHERE ( groupid = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_nodegroup_Delete 
 (id_1 	integer, flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  AS
begin
DELETE workflow_nodegroup  WHERE ( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE workflow_requestbase_SByUser 
 (
 userid1		integer, wftype1	integer, workflowid1	integer, complete1	integer, 
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
if wftype1<>0 then
   
      if complete1=0 then
    open thecursor for
     select  t1.* from workflow_requestbase t1,workflow_base t2
	 where t1.creater = userid1 and t1.workflowid=t2.id and t2.workflowtype = wftype1 and (t1.deleted=0 or t1.deleted is null) 
	 and t1.currentnodetype<>'3' order by t1.createdate desc,t1.createtime desc ;
	  end if;
	 if complete1=1 then
     open thecursor for
	 select  t1.* from workflow_requestbase t1,workflow_base t2 
	 where t1.creater = userid1 and t1.workflowid=t2.id and t2.workflowtype = wftype1 and (t1.deleted=0 or t1.deleted is null) 
	 and t1.currentnodetype= '3' order by t1.createdate desc,t1.createtime desc ;
	 end if;
else if wftype1=0 and workflowid1<>0 then
     
	   if complete1=0 then
       open thecursor for
	   select * from workflow_requestbase 
	   where creater = userid1 and workflowid = workflowid1 and (deleted=0 or deleted is null) and currentnodetype<>'3'
	   order by createdate desc,createtime desc ; 
	   end if;
	   if complete1=1 then
       open thecursor for
	   select * from workflow_requestbase 
	   where creater = userid1 and workflowid = workflowid1 and (deleted=0 or deleted is null) and currentnodetype='3' 
	   order by createdate desc,createtime desc ;
	   end if;
  end if;
  end if;
end;
/


 CREATE or REPLACE PROCEDURE workflow_requestbase_SWftype 
 (
userid1		integer, 
usertype1	integer,
complete1	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

as 
begin 

if complete1=0 then
 open thecursor for
select count(distinct t1.requestid) typecount,t2.workflowtype 
from workflow_requestbase t1, workflow_base t2 
where t1.creater = userid1 and t1.creatertype=usertype1 and t1.workflowid=t2.id and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype<>'3' 
group by t2.workflowtype ;
end if;

if complete1=1 then
 open thecursor for
select count(distinct t1.requestid) typecount,t2.workflowtype 
from workflow_requestbase t1, workflow_base t2 
where t1.creater = userid1 and t1.creatertype=usertype1 and t1.workflowid=t2.id and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype='3' 
group by t2.workflowtype ;
end if;
end;
/


 CREATE or REPLACE PROCEDURE workflow_requestbase_Select 
 (
  userid1		integer, 
  wftype1	integer, 
  workflowid1	integer, 
  complete1	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )
  AS 
  begin
  if wftype1<>0 then
   
      if complete1=0 then
open thecursor for
      select distinct t1.requestid,t1.requestname,t1.workflowid,t1.lastoperatedate,t1.lastoperatetime,t1.lastoperator,t1.status,	  t1.createdate,t1.createtime from workflow_requestbase t1,workflow_currentoperator t2 
	  where t2.userid=userid1 and t1.requestid=t2.requestid and t2.workflowtype=wftype1 and t2.isremark in ('0','1') 
	  and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype<>'3' order by t1.createdate desc,t1.createtime desc ;
	  end if;
      if complete1=1 then
open thecursor for
      select distinct t1.requestid,t1.requestname,t1.workflowid,t1.lastoperatedate,t1.lastoperatetime,t1.lastoperator,t1.status,
      t1.createdate,t1.createtime from workflow_requestbase t1,workflow_currentoperator t2 where t2.userid=userid1 
      and t1.requestid=t2.requestid and t2.workflowtype=wftype1 and t2.isremark='0' and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype='3' 
	  order by t1.createdate desc,t1.createtime desc ;
	  end if;
   
  else if wftype1=0 and workflowid1<>0 then
   
        if complete1=0 then
open thecursor for
        select distinct t1.requestid,t1.requestname,t1.workflowid,t1.lastoperatedate,t1.lastoperatetime,t1.lastoperator,t1.status,	
		t1.createdate,t1.createtime from workflow_requestbase t1,workflow_currentoperator t2 where t2.userid=userid1 
		and t1.requestid=t2.requestid and t2.workflowid=workflowid1 and t2.isremark in ('0','1') and (t1.deleted=0 or t1.deleted is null) 
		and t1.currentnodetype<>'3' order by t1.createdate desc,t1.createtime desc; 
		end if;

        if complete1=1 then
open thecursor for
        select distinct t1.requestid,t1.requestname,t1.workflowid,t1.lastoperatedate,t1.lastoperatetime,t1.lastoperator,t1.status,
		t1.createdate,t1.createtime from workflow_requestbase t1,workflow_currentoperator t2 where t2.userid=userid1 and
		t1.requestid=t2.requestid and t2.workflowid=workflowid1 and t2.isremark='0' and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype='3'
		order by t1.createdate desc,t1.createtime desc ;
		end if;
    end if;
end if;
end;
/
  


 CREATE or REPLACE PROCEDURE workflow_requestbase_SelectWf 
 (
userid1		integer, 
usertype1	integer, 
complete1	integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin

if complete1=0 then
 open thecursor for
select count( distinct requestid) workflowcount, workflowid 
from workflow_requestbase 
where creater = userid1 and creatertype = usertype1 and (deleted=0 or deleted is null) and currentnodetype<>'3' 
group by workflowid ;
end if;

if complete1=1 then
 open thecursor for
select count( distinct requestid) workflowcount, workflowid 
from workflow_requestbase 
where creater = userid1 and creatertype = usertype1 and (deleted=0 or deleted is null) and currentnodetype='3' 
group by workflowid  ;
end if;
end;
/


 CREATE or REPLACE PROCEDURE workflow_wftype_Insert 
  (typename_1 	varchar2, 
  typedesc_2 	varchar2, 
  dsporder1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
   AS 
   begin
   INSERT INTO workflow_type ( typename, typedesc,dsporder)  
   VALUES ( typename_1, typedesc_2,dsporder1);
end;
/


 CREATE or REPLACE PROCEDURE workflow_wftype_SelectByID 
 (id1 	integer, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM workflow_type WHERE ( id	 = id1) ;
end;
/


 CREATE or REPLACE PROCEDURE workflow_wftype_Update 
   (id1	 	integer, 
   typename1 	varchar2, 
   typedesc1 	varchar2,
   dsporder1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
   AS
   begin
   UPDATE workflow_type  SET  typename = typename1, typedesc = typedesc1 ,dsporder = dsporder1 
   WHERE ( id	 = id1) ;
end;
/


create or REPLACE PROCEDURE ErrorMsgIndex_Insert
(
	id_1		integer,
	indexdesc_1	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
	insert into ErrorMsgIndex
	(id,indexdesc)
	values
	(id_1,indexdesc_1);
end;
/




create or REPLACE PROCEDURE ErrorMsgInfo_Insert
(
	id_1		integer,
            errormsgname_1	varchar2,
	langid_1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
	insert into ErrorMsgInfo 
	(indexid,msgname,languageid)
	values
	(id_1,errormsgname_1,langid_1);
end;
/




create or REPLACE PROCEDURE HtmlNoteIndex_Insert
(
	id_1		integer,
	indexdesc_1	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
	insert into HtmlNoteIndex 
	(id,indexdesc)
	values
	(id_1,indexdesc_1);
end;
/



create or REPLACE PROCEDURE HtmlNoteInfo_Insert
(
	id_1		integer,
        notename_1	varchar2,
	langid_1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
	insert into HtmlNoteInfo 
	(indexid,notename,languageid)
	values
	(id_1,notename_1,langid_1);

end;
/


/*人力资源招聘 */

CREATE or replace PROCEDURE HrmCareerApply_Insert 
(id_1 	integer, 
 ischeck_1 char,
 ishire_1		char, 
 careerid_1	integer,
 firstname_2 	varchar2,
 lastname_3 	varchar2,
 titleid_4 	integer, 
 sex_5 	char,
 birthday_6 	char,
 nationality_7  IN OUT	integer,
 defaultlanguage_8  IN OUT	integer,
 certificateCategory_9 	varchar2,
 certificatenum_10 	varchar2, 
 nativeplace_11 	varchar2, 
 educationlevel_12 	char,
 bememberdate_13 	char,
 bepartydate_14 	char,
 bedemocracydate_15 	char,
 regresidentplace_16 	varchar2,
 healthinfo_17 	char,
 residentplace_18 	varchar2,
 policy_19 	varchar2,
 degree_20 	varchar2,
 height_21 	varchar2,
 homepage_22 	varchar2,
 maritalstatus_23 	char,
 marrydate_24 	char, 
 train_25 	varchar2,
 numberid_1	varchar2,
 email_26 	varchar2,
 homeaddress_27 	varchar2,
 homepostcode_28 	varchar2,
 homephone_29 	varchar2,
 Category_3 	char,
 contactor_4 	varchar2,
 major_5 	varchar2,
 salarynow_6 	varchar2,
 worktime_7 	varchar2,
 salaryneed_8 	varchar2,
 currencyid_9 	integer,
 reason_10 	varchar2,
 otherrequest_11 	varchar2,
 selfcomment_12 	varchar2,
 createdate_1		char,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
begin
if nationality_7=0 then
nationality_7:= null;
end if;
if defaultlanguage_8=0 then 
defaultlanguage_8:= null;
end if;
INSERT INTO HrmCareerApply 
(id, ischeck, ishire, careerid, firstname, lastname, titleid, sex, 
birthday, nationality, defaultlanguage, certificatecategory, certificatenum, nativeplace, 
educationlevel, bememberdate, bepartydate, bedemocracydate, regresidentplace, healthinfo, 
residentplace, policy, degree, height, homepage, maritalstatus, marrydate, train, email, 
homeaddress, homepostcode, homephone, createrid, createdate,NumberId) 
VALUES(id_1, ischeck_1, ishire_1,careerid_1, firstname_2, lastname_3, titleid_4, 
sex_5, birthday_6, nationality_7, defaultlanguage_8, certificateCategory_9, certificatenum_10,
nativeplace_11, educationlevel_12,bememberdate_13, bepartydate_14, bedemocracydate_15, 
regresidentplace_16, healthinfo_17, residentplace_18, policy_19, degree_20, height_21,
homepage_22, maritalstatus_23,marrydate_24, train_25, email_26, homeaddress_27, 
homepostcode_28, homephone_29, id_1,createdate_1,numberid_1);

 INSERT INTO HrmCareerApplyOtherInfo (applyid, Category, contactor, major, salarynow, worktime,
 salaryneed, currencyid, reason, otherrequest, selfcomment)  VALUES ( id_1, Category_3, contactor_4,
 major_5, salarynow_6, worktime_7, salaryneed_8, currencyid_9, reason_10, otherrequest_11,
 selfcomment_12);
end;
/

CREATE or replace PROCEDURE  HrmCareerApply_U
 (
 ischeck_1 char, 
 ishire_1 char, 
 careerid_1	integer, 
 firstname_2 	varchar2, 
 lastname_3 	varchar2, 
 titleid_4 	integer, 
 sex_5 	char, 
 birthday_6 	char, 
 nationality_7 	IN OUT integer,
 defaultlanguage_8 	IN OUT integer, 
 certificatecategory_9 	varchar2, 
 certificatenum_10 	varchar2, 
 nativeplace_11 	varchar2, 
 educationlevel_12 	char, 
 bememberdate_13 	char, 
 bepartydate_14 	char, 
 bedemocracydate_15 	char, 
 regresidentplace_16 	varchar2,
 healthinfo_17 	char, 
 residentplace_18 	varchar2, 
 policy_19 	varchar2, 
 degree_20 	varchar2, 
 height_21 	varchar2, 
 homepage_22 	varchar2, 
 maritalstatus_23 	char, 
 marrydate_24 	char, 
 train_25 	varchar2, 
 NumberId_1       varchar2, 
 email_26 	varchar2, 
 homeaddress_27 	varchar2, 
 homepostcode_28 	varchar2, 
 homephone_29 	varchar2,
 category_3 	char, 
 contactor_4 	varchar2, 
 major_5 	varchar2, 
 salarynow_6 	varchar2, 
 worktime_7 	varchar2, 
 salaryneed_8 	varchar2, 
 currencyid_9 	integer, 
 reason_10 	varchar2, 
 otherrequest_11 	varchar2, 
 selfcomment_12 	varchar2, 
 createdate_1		char, 
 id_1 	integer,  
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
 begin
if nationality_7=0 then
nationality_7:= null;
end if;
if defaultlanguage_8=0 then 
defaultlanguage_8:= null;
end if;

UPDATE HrmCareerApply SET
ischeck=ischeck_1, ishire=ishire_1, 
careerid=careerid_1, firstname=firstname_2, lastname=lastname_3,
titleid=titleid_4, sex=sex_5, birthday=birthday_6, 
nationality=nationality_7, defaultlanguage=defaultlanguage_8, certificatecategory=certificatecategory_9,
certificatenum=certificatenum_10, nativeplace=nativeplace_11, educationlevel=educationlevel_12,
bememberdate=bememberdate_13, bepartydate=bepartydate_14, bedemocracydate=bedemocracydate_15,
regresidentplace=regresidentplace_16, healthinfo=healthinfo_17, residentplace=residentplace_18, 
policy=policy_19, degree=degree_20, height=height_21, homepage=homepage_22, 
maritalstatus=maritalstatus_23, marrydate=marrydate_24, train=train_25, NumberId=NumberId_1,
email=email_26, homeaddress=homeaddress_27, homepostcode=homepostcode_28, 
homephone=homephone_29, createrid=id_1, createdate=createdate_1  WHERE id=id_1 ;

update HrmCareerApplyOtherInfo set
category=category_3, 
contactor=contactor_4, 
major=major_5, 
salarynow=salarynow_6, 
worktime=worktime_7, 
salaryneed=salaryneed_8, 
currencyid=currencyid_9, 
reason=reason_10, 
otherrequest=otherrequest_11,
selfcomment=selfcomment_12
where applyid=id_1 ;

end ;
/


CREATE or replace PROCEDURE  HrmShare_Insert
(hrmid_1 integer,
 applyid_1 integer,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
as
count_1 integer ;
begin

select count(*) into count_1 from HrmShare where hrmid= hrmid_1 and applyid= applyid_1 ;

IF count_1 > 0 then
return ;
end If ;

INSERT INTO HrmShare (hrmid,applyid) values (hrmid_1, applyid_1) ;
end ;
/


CREATE or replace PROCEDURE  HrmShare_SelectByHrmApply
(
hrmid_1 integer,
applyid_1 integer,
flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
as
begin
open thecursor for
select * from HrmShare where hrmid=hrmid_1 and applyid=applyid_1 ;
end ;
/


CREATE or replace PROCEDURE  HrmShare_SelectByApply
(
applyid_1 integer,
flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
as
begin
open thecursor for
select * from HrmShare where applyid=applyid_1 ;
end ;
/

CREATE or replace PROCEDURE  HrmShare_Delete
(
hrmid_1 integer,
applyid_1 integer,
flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
as
begin
delete  from HrmShare where hrmid=hrmid_1 and applyid=applyid_1 ;
end ;
/

CREATE or replace PROCEDURE  HrmCareerApply_SelectId
(
id_1 integer,
flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
as
begin
open thecursor for
select firstname, lastname from HrmCareerApply where id=id_1 ;
end ;
/

