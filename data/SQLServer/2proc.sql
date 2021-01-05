
 CREATE PROCEDURE Base_FreeField_Select 
 (@tablename 	[varchar](2), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Base_FreeField] WHERE ( [tablename]	 = @tablename) set @flag = 1 set @msg = 'OK!' 
GO

/*2002-9-20 11:30*/
 CREATE PROCEDURE Bill_Approve_SelectByID 
	@id		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from Bill_Approve where id=@id 

GO



create  PROCEDURE ErrorMsgIndex_Insert
	@id		int,
	@indexdesc	varchar(250),
	@flag		int	output, 
	@msg		varchar(80) output
as
	insert into ErrorMsgIndex
	(id,indexdesc)
	values
	(@id,@indexdesc)
GO



create  PROCEDURE ErrorMsgInfo_Insert
	@id		int,
            @errormsgname	varchar(100),
	@langid		int,
	@flag		int	output, 
	@msg		varchar(80) output
as
	insert into ErrorMsgInfo 
	(indexid,msgname,languageid)
	values
	(@id,@errormsgname,@langid)
GO



create  PROCEDURE HtmlNoteIndex_Insert
	@id		int,
	@indexdesc	varchar(250),
	@flag		int	output, 
	@msg		varchar(80) output
as
	insert into HtmlNoteIndex 
	(id,indexdesc)
	values
	(@id,@indexdesc)
GO


create  PROCEDURE HtmlNoteInfo_Insert
	@id		int,
        @notename	varchar(100),
	@langid		int,
	@flag		int	output, 
	@msg		varchar(80) output
as
	insert into HtmlNoteInfo 
	(indexid,notename,languageid)
	values
	(@id,@notename,@langid)

GO

 CREATE PROCEDURE Bill_Discuss_Insert 
	@billid int,
	@requestid  int,
	@resourceid int,
	@accepterid text,
	@subject    varchar(255),
	@isend      int,
	@projectid  int,
	@crmid      int,
	@relatedrequestid   int,
	@status     char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into bill_Discuss (billid,requestid,resourceid,accepterid,subject,isend,projectid,crmid,relatedrequestid,status)
	values(@billid,@requestid,@resourceid,@accepterid,@subject,@isend,@projectid,@crmid,@relatedrequestid,@status)
    
    select max(id) from bill_Discuss

GO

 CREATE PROCEDURE Bill_Discuss_Update 
	@id     int,
	@billid int,
	@requestid  int,
	@resourceid int,
	@accepterid text,
	@subject    varchar(255),
	@isend      int,
	@projectid  int,
	@crmid      int,
	@relatedrequestid   int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_Discuss 
	set billid=@billid,
	    requestid=@requestid,
	    resourceid=@resourceid,
	    accepterid=@accepterid,
	    subject=@subject,
	    isend=@isend,
	    projectid=@projectid,
	    crmid=@crmid,
	    relatedrequestid=@relatedrequestid
	where id=@id

GO

 CREATE PROCEDURE Bill_ExpenseDetail_Delete 
 (@expenseid_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [Bill_ExpenseDetail]  WHERE ( [expenseid]	 = @expenseid_1) 
GO

 CREATE PROCEDURE Bill_ExpenseDetail_Insert 
	@expenseid		int,
	@relatedate		char(10),
	@detailremark	varchar(250),
	@feetypeid		int,
	@feesum			decimal(10,3),
	@accessory		int,
	@invoicenum		varchar(250),
	@feerule        decimal(10,3),
    @realfeesum		decimal(10,2),
	@flag			int	output, 
	@msg			varchar(80) output
as
	insert into bill_expensedetail 
	(expenseid,relatedate,detailremark,feetypeid,feesum,accessory,invoicenum,feerule,realfeesum)
	values
	(@expenseid,@relatedate,@detailremark,@feetypeid,@feesum,@accessory,@invoicenum,@feerule,@realfeesum)


GO

 CREATE PROCEDURE Bill_ExpenseDetali_SelectByID 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from Bill_ExpenseDetail where expenseid=@id 
GO

 CREATE PROCEDURE Bill_Expense_SelectByID 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from Bill_Expense where id=@id 
GO

 CREATE PROCEDURE Bill_Expense_UpdateStatus 
 (@id [int], @usestatus char(1) ,@flag integer output , @msg varchar(80) output) AS update Bill_Expense set usestatus = @usestatus where id=@id 
GO

 CREATE PROCEDURE Bill_HireResource_SelectByID 
	@id		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_HireResource where id=@id 

GO

 CREATE PROCEDURE Bill_HotelBook_SelectByID 
	@id		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_HotelBook where id=@id 

GO

 CREATE PROCEDURE Bill_HrmResourceAbsense_SByW 
 (@flag integer output , @msg varchar(80) output) AS select distinct workflowid , workflowname from Bill_HrmResourceAbsense 
GO

 CREATE PROCEDURE Bill_HrmResourceAbsense_SByID 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from Bill_HrmResourceAbsense where id=@id 
GO

 CREATE PROCEDURE Bill_HrmResourceAbsense_UStat 
 (@id [int], @usestatus char(1) ,@flag integer output , @msg varchar(80) output) AS update Bill_HrmResourceAbsense set usestatus = @usestatus where id=@id 
GO

 CREATE PROCEDURE Bill_HrmResourcePlan_SByID 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from Bill_HrmResourcePlan where id=@id 
GO

 CREATE PROCEDURE Bill_HrmResourcePlan_UStatus 
 (@id [int], @usestatus char(1) ,@flag integer output , @msg varchar(80) output) AS update Bill_HrmResourcePlan set usestatus = @usestatus where id=@id 
GO

 CREATE PROCEDURE Bill_LeaveJob_SelectByID 
	@id		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_LeaveJob where id=@id 

GO

 CREATE PROCEDURE Bill_MailboxApply_SelectByID 
	@id		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_MailboxApply where id=@id 

GO

 CREATE PROCEDURE Bill_Meetingroom_SelectByID 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from Bill_Meetingroom where id=@id 
GO

 CREATE PROCEDURE Bill_NameCard_SelectByID 
	@id		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_namecard where id=@id 

GO

 CREATE PROCEDURE Bill_NameCardinfo_Insert 
	@resourceid		int,
	@cname          varchar(50),
	@cjobtitle      varchar(50),
	@cdepartment    varchar(100),
	@phone          varchar(50),
	@mobile         varchar(50),
	@email          varchar(50),
	@ename          varchar(50),
	@ejobtitle      varchar(50),
	@edepartment    varchar(100),
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into bill_namecardinfo (resourceid,cname,cjobtitle,cdepartment,phone,mobile,email,ename,ejobtitle,edepartment)
	values(@resourceid,@cname,@cjobtitle,@cdepartment,@phone,@mobile,@email,@ename,@ejobtitle,@edepartment)

GO

 CREATE PROCEDURE Bill_NameCardinfo_Update 
	@resourceid		int,
	@cname          varchar(50),
	@cjobtitle      varchar(50),
	@cdepartment    varchar(100),
	@phone          varchar(50),
	@mobile         varchar(50),
	@email          varchar(50),
	@ename          varchar(50),
	@ejobtitle      varchar(50),
	@edepartment    varchar(100),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_namecardinfo 
	set cname=@cname,
	    cjobtitle=@cjobtitle,
	    cdepartment=@cdepartment,
	    phone=@phone,
	    mobile=@mobile,
	    email=@email,
	    ename=@ename,
	    ejobtitle=@ejobtitle,
	    edepartment=@edepartment
	where resourceid=@resourceid

GO

 CREATE PROCEDURE Bill_TotalBudget_SelectByID 
	@id		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from Bill_TotalBudget where id=@id 

GO

 CREATE PROCEDURE Bill_workinfo_SelectByID 
	@id		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_workinfo where id=@id 

GO

 CREATE PROCEDURE CRM_AddressType_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_AddressType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_AddressType_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_AddressType] ( [fullname], [description], [candelete]) VALUES ( @fullname, @description, 'y') set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_AddressType_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_AddressType] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_AddressType_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_AddressType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_AddressType_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_AddressType] SET  [fullname]	 = @fullname, [description]	 = @description WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactLog_Insert 
 (@customerid 	[int], @contacterid 	[int], @resourceid 	[int], @agentid 	[int], @contactway 	[int], @ispassive 	[tinyint], @subject 	[varchar](100), @contacttype 	[int], @contactdate 	[varchar](10), @contacttime 	[varchar](8), @enddate 	[varchar](10), @endtime 	[varchar](8), @contactinfo 	text, @documentid 	[int], @submitdate 	[varchar](10), @submittime 	[varchar](8), @issublog 	[tinyint], @parentid 	[int], @isfinished  [tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [CRM_ContactLog] ( [customerid], [contacterid], [resourceid], [agentid], [contactway], [ispassive], [subject], [contacttype], [contactdate], [contacttime], [enddate], [endtime], [contactinfo], [documentid], [submitdate], [submittime], [issublog], [parentid], [isfinished], [isprocessed], [processdate], [processtime])  VALUES ( @customerid, @contacterid, @resourceid, @agentid, @contactway, @ispassive, @subject, @contacttype, @contactdate, @contacttime, @enddate, @endtime, @contactinfo, @documentid, @submitdate, @submittime, @issublog, @parentid, @isfinished, 0, '', '')  SELECT top 1 id FROM [CRM_ContactLog] ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_ContactLog_InsertID 
 (@flag	[int]	output, @msg	[varchar](80)	output)  AS SELECT top 1 id FROM [CRM_ContactLog] ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactLog_Process 
 (@id 	[int], @processdate 	[varchar](10), @processtime 	[varchar](8), @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [CRM_ContactLog]  SET  	 [isprocessed]	 = 1, [processdate]	 = @processdate, [processtime]	 = @processtime  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactLog_S_Plan_byAgent 
 (@userid 	[int],  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT id,subject,customerid,contacterid,contactdate,contacttime from [CRM_ContactLog] WHERE ([agentid] = @userid) and ([isfinished] = 0)  ORDER BY contactdate ASC, contacttime ASC set @flag = 1 set @msg = 'OK!' 


GO

 CREATE PROCEDURE CRM_ContactLog_Select 
 (@id 		[int], @issub		[tinyint], @parent	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [CRM_ContactLog] WHERE ([customerid] = @id) AND ([issublog] = @issub) AND ([parentid] = @parent) ORDER BY contactdate DESC, contacttime DESC set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_ContactLog_SelectByID 
 (@id 		[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [CRM_ContactLog] WHERE ([id] = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactLog_Select_Plan 
 (@resourceid 	[int],  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT id,subject,customerid,contacterid,contactdate,contacttime from [CRM_ContactLog] WHERE ([resourceid] = @resourceid) and ([isfinished] = 0)  ORDER BY contactdate ASC, contacttime ASC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactLog_Update 
 (@id 	[int], @contacterid 	[int], @resourceid 	[int], @agentid 	[int],  @contactway 	[int], @ispassive 	[tinyint], @subject 	[varchar](100), @contacttype 	[int], @contactdate 	[varchar](10), @contacttime 	[varchar](8), @enddate 	[varchar](10), @endtime 	[varchar](8), @contactinfo 	[varchar](255), @documentid 	[int], @isfinished [tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [CRM_ContactLog]  SET  	 [contacterid]	 = @contacterid, [resourceid]	 = @resourceid,  [agentid]	 = @agentid, [contactway]	 = @contactway, [ispassive]	 = @ispassive, [subject]	 = @subject, [contacttype]	 = @contacttype, [contactdate]	 = @contactdate, [contacttime]	 = @contacttime, [enddate]	 = @enddate, [endtime]	 = @endtime, [contactinfo]	 = @contactinfo, [documentid]	 = @documentid, [isfinished]	 = @isfinished  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_ContactWay_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_ContactWay] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactWay_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_ContactWay] ( [fullname], [description]) VALUES ( @fullname, @description) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactWay_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_ContactWay] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactWay_SelectByID 
 (@id 	[int], @Flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_ContactWay] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContactWay_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_ContactWay] SET  [fullname]	 = @fullname, [description]	 = @description WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContacterTitle_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_ContacterTitle] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContacterTitle_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @usetype 	[char](1), @language 	[int], @abbrev 	[varchar](50), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_ContacterTitle] ( [fullname], [description], [usetype], [language], [abbrev]) VALUES ( @fullname, @description, @usetype, @language, @abbrev) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContacterTitle_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_ContacterTitle] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContacterTitle_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_ContacterTitle] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ContacterTitle_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @usetype 	[char](1), @language 	[int], @abbrev 	[varchar](50), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_ContacterTitle] SET  [fullname]	 = @fullname, [description]	 = @description, [usetype]	 = @usetype, [language]	 = @language, [abbrev]	 = @abbrev WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CreditInfo_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_CreditInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CreditInfo_Insert 
 (@fullname 	[varchar](50), @creditamount 	[varchar](50), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_CreditInfo] ( [fullname], [creditamount]) VALUES ( @fullname, convert(money,@creditamount)) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CreditInfo_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CreditInfo] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CreditInfo_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CreditInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CreditInfo_Update 
 (@id 	[int], @fullname 	[varchar](50), @creditamount 	[varchar](50), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CreditInfo] SET  [fullname]	 = @fullname, [creditamount]	 = convert(money,@creditamount ) WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerAddress_Insert 
 (@typeid 	[int], @customerid 	[int], @isequal 	[tinyint], @address1 	[varchar](250), @address2 	[varchar](250), @address3 	[varchar](250), @zipcode 	[varchar](10), @city 	[int], @country 	[int], @province 	[int], @county 	[varchar](50), @phone 	[varchar](50), @fax 	[varchar](50), @email 	[varchar](150), @contacter 	[int], @datefield1 	[varchar](10), @datefield2 	[varchar](10), @datefield3 	[varchar](10), @datefield4 	[varchar](10), @datefield5 	[varchar](10), @numberfield1 	[float], @numberfield2 	[float], @numberfield3 	[float], @numberfield4 	[float], @numberfield5 	[float], @textfield1 	[varchar](100), @textfield2 	[varchar](100), @textfield3 	[varchar](100), @textfield4 	[varchar](100), @textfield5 	[varchar](100), @tinyintfield1 	[tinyint], @tinyintfield2 	[tinyint], @tinyintfield3 	[tinyint], @tinyintfield4 	[tinyint], @tinyintfield5 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [CRM_CustomerAddress] ( [typeid], [customerid], [isequal], [address1], [address2], [address3], [zipcode], [city], [country], [province], [county], [phone], [fax], [email], [contacter], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5])  VALUES ( @typeid, @customerid, @isequal, @address1, @address2, @address3, @zipcode, @city, @country, @province, @county, @phone, @fax, @email, @contacter, @datefield1, @datefield2, @datefield3, @datefield4, @datefield5, @numberfield1, @numberfield2, @numberfield3, @numberfield4, @numberfield5, @textfield1, @textfield2, @textfield3, @textfield4, @textfield5, @tinyintfield1, @tinyintfield2, @tinyintfield3, @tinyintfield4, @tinyintfield5)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_CustomerAddress_Select 
 (@tid 	[int], @cid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerAddress] WHERE ([typeid] = @tid) AND ([customerid] = @cid) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_CustomerAddress_UEqual 
 (@typeid_1 	[int], @customerid_2 	[int], @isequal_3 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [CRM_CustomerAddress]  SET  [isequal]	 = @isequal_3  WHERE ( [typeid]	 = @typeid_1 AND [customerid]	 = @customerid_2)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_CustomerAddress_Update 
 (@typeid_1 	[int], @customerid_2 	[int], @isequal_3 	[tinyint], @address1_4 	[varchar](250), @address2_5 	[varchar](250), @address3_6 	[varchar](250), @zipcode_7 	[varchar](10), @city_8 	[int], @country_9 	[int], @province_10 	[int], @county_11 	[varchar](50), @phone_12 	[varchar](50), @fax_13 	[varchar](50), @email_14 	[varchar](150), @contacter_15 	[int], @datefield1_16 	[varchar](10), @datefield2_17 	[varchar](10), @datefield3_18 	[varchar](10), @datefield4_19 	[varchar](10), @datefield5_20 	[varchar](10), @numberfield1_21 	[float], @numberfield2_22 	[float], @numberfield3_23 	[float], @numberfield4_24 	[float], @numberfield5_25 	[float], @textfield1_26 	[varchar](100), @textfield2_27 	[varchar](100), @textfield3_28 	[varchar](100), @textfield4_29 	[varchar](100), @textfield5_30 	[varchar](100), @tinyintfield1_31 	[tinyint], @tinyintfield2_32 	[tinyint], @tinyintfield3_33 	[tinyint], @tinyintfield4_34 	[tinyint], @tinyintfield5_35 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [CRM_CustomerAddress]  SET  [isequal]	 = @isequal_3, [address1]	 = @address1_4, [address2]	 = @address2_5, [address3]	 = @address3_6, [zipcode]	 = @zipcode_7, [city]	 = @city_8, [country]	 = @country_9, [province]	 = @province_10, [county]	 = @county_11, [phone]	 = @phone_12, [fax]	 = @fax_13, [email]	 = @email_14, [contacter]	 = @contacter_15, [datefield1]	 = @datefield1_16, [datefield2]	 = @datefield2_17, [datefield3]	 = @datefield3_18, [datefield4]	 = @datefield4_19, [datefield5]	 = @datefield5_20, [numberfield1]	 = @numberfield1_21, [numberfield2]	 = @numberfield2_22, [numberfield3]	 = @numberfield3_23, [numberfield4]	 = @numberfield4_24, [numberfield5]	 = @numberfield5_25, [textfield1]	 = @textfield1_26, [textfield2]	 = @textfield2_27, [textfield3]	 = @textfield3_28, [textfield4]	 = @textfield4_29, [textfield5]	 = @textfield5_30, [tinyintfield1]	 = @tinyintfield1_31, [tinyintfield2]	 = @tinyintfield2_32, [tinyintfield3]	 = @tinyintfield3_33, [tinyintfield4]	 = @tinyintfield4_34, [tinyintfield5]	 = @tinyintfield5_35  WHERE ( [typeid]	 = @typeid_1 AND [customerid]	 = @customerid_2)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_CustomerContacter_Delete 
 (@id_1 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS DELETE [CRM_CustomerContacter]  WHERE ( [id]	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerContacter_Insert 
 (@customerid_1 	[int], @title_2 	[int], @fullname_3 	[varchar](50), @lastname_4 	[varchar](50), @firstname_5 	[varchar](50), @jobtitle_6 	[varchar](100), @email_7 	[varchar](150), @phoneoffice_8 	[varchar](20), @phonehome_9 	[varchar](20), @mobilephone_10 	[varchar](20), @fax_11 	[varchar](20), @language_12 	[int], @manager_13 	[int], @main_14 	[tinyint], @picid_15 	[int], @datefield1_16 	[varchar](10), @datefield2_17 	[varchar](10), @datefield3_18 	[varchar](10), @datefield4_19 	[varchar](10), @datefield5_20 	[varchar](10), @numberfield1_21 	[float], @numberfield2_22 	[float], @numberfield3_23 	[float], @numberfield4_24 	[float], @numberfield5_25 	[float], @textfield1_26 	[varchar](100), @textfield2_27 	[varchar](100), @textfield3_28 	[varchar](100), @textfield4_29 	[varchar](100), @textfield5_30 	[varchar](100), @tinyintfield1_31 	[tinyint], @tinyintfield2_32 	[tinyint], @tinyintfield3_33 	[tinyint], @tinyintfield4_34 	[tinyint], @tinyintfield5_35 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [CRM_CustomerContacter] ( [customerid], [title], [fullname], [lastname], [firstname], [jobtitle], [email], [phoneoffice], [phonehome], [mobilephone], [fax], [language], [manager], [main], [picid], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5])  VALUES ( @customerid_1, @title_2, @fullname_3, @lastname_4, @firstname_5, @jobtitle_6, @email_7, @phoneoffice_8, @phonehome_9, @mobilephone_10, @fax_11, @language_12, @manager_13, @main_14, @picid_15, @datefield1_16, @datefield2_17, @datefield3_18, @datefield4_19, @datefield5_20, @numberfield1_21, @numberfield2_22, @numberfield3_23, @numberfield4_24, @numberfield5_25, @textfield1_26, @textfield2_27, @textfield3_28, @textfield4_29, @textfield5_30, @tinyintfield1_31, @tinyintfield2_32, @tinyintfield3_33, @tinyintfield4_34, @tinyintfield5_35)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerContacter_SAll 
 ( @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerContacter]  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerContacter_SByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerContacter] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerContacter_SMain 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerContacter] WHERE ( [customerid]	 = @id) AND ([main] = 1) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerContacter_UMain 
 (@id	 	[int], @main	 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [CRM_CustomerContacter]  SET	 [main]	 = @main  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerContacter_Update 
 (@id_1 	[int], @title_3 	[int], @fullname_4 	[varchar](50), @lastname_5 	[varchar](50), @firstname_6 	[varchar](50), @jobtitle_7 	[varchar](100), @email_8 	[varchar](150), @phoneoffice_9 	[varchar](20), @phonehome_10 	[varchar](20), @mobilephone_11 	[varchar](20), @fax_12 	[varchar](20), @language_13 	[int], @manager_14 	[int], @main_15 	[tinyint], @picid_16 	[int], @datefield1_17 	[varchar](10), @datefield2_18 	[varchar](10), @datefield3_19 	[varchar](10), @datefield4_20 	[varchar](10), @datefield5_21 	[varchar](10), @numberfield1_22 	[float], @numberfield2_23 	[float], @numberfield3_24 	[float], @numberfield4_25 	[float], @numberfield5_26 	[float], @textfield1_27 	[varchar](100), @textfield2_28 	[varchar](100), @textfield3_29 	[varchar](100), @textfield4_30 	[varchar](100), @textfield5_31 	[varchar](100), @tinyintfield1_32 	[tinyint], @tinyintfield2_33 	[tinyint], @tinyintfield3_34 	[tinyint], @tinyintfield4_35 	[tinyint], @tinyintfield5_36 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [CRM_CustomerContacter]  SET	 [title]	 = @title_3, [fullname]	 = @fullname_4, [lastname]	 = @lastname_5, [firstname]	 = @firstname_6, [jobtitle]	 = @jobtitle_7, [email]	 = @email_8, [phoneoffice]	 = @phoneoffice_9, [phonehome]	 = @phonehome_10, [mobilephone]	 = @mobilephone_11, [fax]	 = @fax_12, [language]	 = @language_13, [manager]	 = @manager_14, [main]	 = @main_15, [picid]	 = @picid_16, [datefield1]	 = @datefield1_17, [datefield2]	 = @datefield2_18, [datefield3]	 = @datefield3_19, [datefield4]	 = @datefield4_20, [datefield5]	 = @datefield5_21, [numberfield1]	 = @numberfield1_22, [numberfield2]	 = @numberfield2_23, [numberfield3]	 = @numberfield3_24, [numberfield4]	 = @numberfield4_25, [numberfield5]	 = @numberfield5_26, [textfield1]	 = @textfield1_27, [textfield2]	 = @textfield2_28, [textfield3]	 = @textfield3_29, [textfield4]	 = @textfield4_30, [textfield5]	 = @textfield5_31, [tinyintfield1]	 = @tinyintfield1_32, [tinyintfield2]	 = @tinyintfield2_33, [tinyintfield3]	 = @tinyintfield3_34, [tinyintfield4]	 = @tinyintfield4_35, [tinyintfield5]	 = @tinyintfield5_36  WHERE ( [id]	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerCount_SelectByType 
 (@city [int],
  @type [int],
  @flag	[int]	output, 
  @msg	[varchar](80)	output) 
  AS SELECT count(id) as countid FROM [CRM_CustomerInfo] where city=@city and type=@type
  
GO

 CREATE PROCEDURE CRM_CustomerDesc_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_CustomerDesc] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerDesc_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_CustomerDesc] ( [fullname], [description]) VALUES ( @fullname, @description) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerDesc_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerDesc] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerDesc_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerDesc] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerDesc_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerDesc] SET  [fullname]	 = @fullname, [description]	 = @description WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerInfo_Approve 
 (@id 		[int], @status 	[int], @rating 	[int],  @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerInfo]  SET  	  [status]	 = @status, [rating]	 = @rating  WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_CustomerInfo_Delete 
 (@id 		[int], @deleted 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerInfo]  SET  	 [deleted]	 	 = @deleted WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerInfo_Insert 
 (@name 		[varchar](50), @language 	[int], @engname 	[varchar](50), @address1 	[varchar](250), @address2 	[varchar](250), @address3 	[varchar](250), @zipcode 	[varchar](10), @city	 	[int], @country 	[int], @province 	[int], @county 	[varchar](50), @phone 	[varchar](50), @fax	 	[varchar](50), @email 	[varchar](150), @website 	[varchar](150), @source 	[int], @sector 	[int], @size_n	 	[int], @manager 	[int], @agent 	[int], @parentid 	[int], @department 	[int], @subcompanyid1 	[int], @fincode 	[int], @currency 	[int], @contractlevel	[int], @creditlevel 	[int], @creditoffset 	[varchar](50), @discount 	[real], @taxnumber 	[varchar](50), @bankacount 	[varchar](50), @invoiceacount	[int], @deliverytype 	[int], @paymentterm 	[int], @paymentway 	[int], @saleconfirm 	[int], @creditcard 	[varchar](50), @creditexpire 	[varchar](10), @documentid 	[int], @seclevel 	[int], @picid 	[int], @type 		[int], @typebegin 	[varchar](10), @description 	[int], @status 	[int], @rating 	[int], @datefield1 	[varchar](10), @datefield2 	[varchar](10), @datefield3 	[varchar](10), @datefield4 	[varchar](10), @datefield5 	[varchar](10), @numberfield1 	[float], @numberfield2 	[float], @numberfield3 	[float], @numberfield4 	[float], @numberfield5 	[float], @textfield1 	[varchar](100), @textfield2 	[varchar](100), @textfield3 	[varchar](100), @textfield4 	[varchar](100), @textfield5 	[varchar](100), @tinyintfield1 [tinyint], @tinyintfield2 [tinyint], @tinyintfield3 [tinyint], @tinyintfield4 [tinyint], @tinyintfield5 [tinyint], @createdate 	[varchar](10), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [CRM_CustomerInfo] ( [name], [language], [engname], [address1], [address2], [address3], [zipcode], [city], [country], [province], [county], [phone], [fax], [email], [website], [source], [sector], [size_n], [manager], [agent], [parentid], [department], [subcompanyid1], [fincode], [currency], [contractlevel], [creditlevel], [creditoffset], [discount], [taxnumber], [bankacount], [invoiceacount], [deliverytype], [paymentterm], [paymentway], [saleconfirm], [creditcard], [creditexpire], [documentid], [seclevel], [picid], [type], [typebegin], [description], [status], [rating], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5], [deleted], [createdate])  VALUES ( @name, @language, @engname, @address1, @address2, @address3, @zipcode, @city, @country, @province, @county, @phone, @fax, @email, @website, @source, @sector, @size_n, @manager, @agent, @parentid, @department, @subcompanyid1, @fincode, @currency, @contractlevel, @creditlevel, convert(money,@creditoffset), @discount, @taxnumber, @bankacount, @invoiceacount, @deliverytype, @paymentterm, @paymentway, @saleconfirm, @creditcard, @creditexpire, @documentid, @seclevel, @picid, @type, @typebegin, @description, @status, @rating, @datefield1, @datefield2, @datefield3, @datefield4, @datefield5, @numberfield1, @numberfield2, @numberfield3, @numberfield4, @numberfield5, @textfield1, @textfield2, @textfield3, @textfield4, @textfield5, @tinyintfield1, @tinyintfield2, @tinyintfield3, @tinyintfield4, @tinyintfield5, 0, @createdate)  SELECT top 1 id from CRM_CustomerInfo ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 


GO

 CREATE PROCEDURE CRM_CustomerInfo_InsertID 
 (@flag	[int]	output, @msg	[varchar](80)	output)  AS SELECT top 1 id from CRM_CustomerInfo ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerInfo_Portal 
(@id [int], @portalstatus [int], @flag	[int] output, @msg [varchar](80) output) 
AS UPDATE [CRM_CustomerInfo]  SET  	 
[portalstatus] = @portalstatus WHERE ( [id] = @id) set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE CRM_CustomerInfo_PortalPasswor 
(@id [int], @portalloginid [varchar](60), @portalpassword [varchar](100), @flag	[int] output, @msg [varchar](80) output) 
AS UPDATE [CRM_CustomerInfo]  SET  	 
[portalloginid] = @portalloginid , [portalpassword] = @portalpassword  WHERE ( [id] = @id) set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE CRM_CustomerInfo_SByLoginID 
 ( 
  @portalloginid [varchar](60), @flag  integer output, @msg  varchar(80) output 
  ) AS 
  select * from CRM_CustomerInfo where portalloginid = @portalloginid 
   set @flag=1 set @msg='ok'  

GO

 CREATE PROCEDURE CRM_CustomerInfo_SSumByManager 
 @id	int , @flag	[int]	output, @msg	[varchar](80)	output AS select count(id) from CRM_CustomerInfo where manager = @id 
GO

 CREATE PROCEDURE CRM_CustomerInfo_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerInfo] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerInfo_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerInfo] WHERE ([id] = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerInfo_Update 
 (@id 		[int], @name 		[varchar](50), @language 	[int], @engname 	[varchar](50), @address1 	[varchar](250), @address2 	[varchar](250), @address3 	[varchar](250), @zipcode 	[varchar](10), @city	 	[int], @country 	[int], @province 	[int], @county 	[varchar](50), @phone 	[varchar](50), @fax	 	[varchar](50), @email 	[varchar](150), @website 	[varchar](150), @source 	[int], @sector 	[int], @size_n	 	[int], @manager 	[int], @agent 	[int], @parentid 	[int], @department 	[int], @subcompanyid1 	[int], @fincode 	[int], @currency 	[int], @contractlevel	[int], @creditlevel 	[int], @creditoffset 	[varchar](50), @discount 	[real], @taxnumber 	[varchar](50), @bankacount 	[varchar](50), @invoiceacount [int], @deliverytype 	[int], @paymentterm 	[int], @paymentway 	[int], @saleconfirm 	[int], @creditcard 	[varchar](50), @creditexpire 	[varchar](10), @documentid 	[int], @seclevel 	[int], @picid 	[int], @type	 	[int], @typebegin 	[varchar](10), @description 	[int], @status 	[int], @rating 	[int], @datefield1 	[varchar](10), @datefield2 	[varchar](10), @datefield3 	[varchar](10), @datefield4 	[varchar](10), @datefield5 	[varchar](10), @numberfield1 	[float], @numberfield2 	[float], @numberfield3 	[float], @numberfield4 	[float], @numberfield5 	[float], @textfield1 	[varchar](100), @textfield2 	[varchar](100), @textfield3 	[varchar](100), @textfield4 	[varchar](100), @textfield5 	[varchar](100), @tinyintfield1 	[tinyint], @tinyintfield2 	[tinyint], @tinyintfield3 	[tinyint], @tinyintfield4 	[tinyint], @tinyintfield5 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerInfo]  SET  	 [name]	 	 = @name, [language]	 = @language, [engname]	 = @engname, [address1]	 = @address1, [address2]	 = @address2, [address3]	 = @address3, [zipcode]	 = @zipcode, [city]	 = @city, [country]	 = @country, [province]	 = @province, [county]	 = @county, [phone]	 = @phone, [fax]	 = @fax, [email]	 = @email, [website]	 = @website, [source]	 = @source, [sector]	 = @sector, [size_n]	 = @size_n, [manager]	 = @manager, [agent]	 = @agent, [parentid]	 = @parentid, [department]	 = @department, [subcompanyid1]	 = @subcompanyid1, [fincode]	 = @fincode, [currency]	 = @currency, [contractlevel] = @contractlevel, [creditlevel]	 = @creditlevel, [creditoffset]	 = convert(money,@creditoffset), [discount]	 = @discount, [taxnumber]	 = @taxnumber, [bankacount]	 = @bankacount, [invoiceacount]	 = @invoiceacount, [deliverytype]	 = @deliverytype, [paymentterm]	 = @paymentterm, [paymentway]	 = @paymentway, [saleconfirm]	 = @saleconfirm, [creditcard]	 = @creditcard, [creditexpire]	 = @creditexpire, [documentid]	 = @documentid, [seclevel] = @seclevel, [picid]	 = @picid, [type]	 = @type, [typebegin]	 = @typebegin, [description]	 = @description, [status]	 = @status, [rating]	 = @rating, [datefield1]	 = @datefield1, [datefield2]	 = @datefield2, [datefield3]	 = @datefield3, [datefield4]	 = @datefield4, [datefield5]	 = @datefield5, [numberfield1]	 = @numberfield1, [numberfield2]	 = @numberfield2, [numberfield3]	 = @numberfield3, [numberfield4]	 = @numberfield4, [numberfield5]	 = @numberfield5, [textfield1]	 = @textfield1, [textfield2]	 = @textfield2, [textfield3]	 = @textfield3, [textfield4]	 = @textfield4, [textfield5]	 = @textfield5, [tinyintfield1]	 = @tinyintfield1, [tinyintfield2]	 = @tinyintfield2, [tinyintfield3]	 = @tinyintfield3, [tinyintfield4]	 = @tinyintfield4, [tinyintfield5]	 = @tinyintfield5  WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_CustomerRating_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_CustomerRating] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerRating_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @workflow11 [int], @workflow12 [int], @workflow21 [int], @workflow22 [int], @workflow31 [int], @workflow32 [int], @canupgrade [char](1), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_CustomerRating] ( [fullname], [description], [workflow11], [workflow12], [workflow21], [workflow22], [workflow31], [workflow32], [canupgrade]) VALUES ( @fullname, @description, @workflow11, @workflow12, @workflow21, @workflow22, @workflow31, @workflow32, @canupgrade) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerRating_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerRating] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerRating_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerRating] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerRating_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @workflow11 [int], @workflow12 [int], @workflow21 [int], @workflow22 [int], @workflow31 [int], @workflow32 [int], @canupgrade [char](1), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerRating] SET  [fullname]	 = @fullname, [description]	 = @description, [workflow11] = @workflow11, [workflow12] = @workflow12, [workflow21] = @workflow21, [workflow22] = @workflow22, [workflow31] = @workflow31, [workflow32] = @workflow32, [canupgrade] = @canupgrade WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerSize_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_CustomerSize] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerSize_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_CustomerSize] ( [fullname], [description]) VALUES ( @fullname, @description) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerSize_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerSize] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerSize_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerSize] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerSize_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerSize] SET  [fullname]	 = @fullname, [description]	 = @description WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerStatus_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_CustomerStatus] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerStatus_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_CustomerStatus] ( [fullname], [description]) VALUES ( @fullname, @description) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerStatus_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerStatus] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerStatus_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerStatus] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerStatus_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerStatus] SET  [fullname]	 = @fullname, [description]	 = @description WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerType_Delete 
 (@id [int], @flag [int]	output, @msg [varchar](80) output) AS DELETE [CRM_CustomerType] WHERE ( [id] = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerType_Insert 
 (@fullname [varchar](50), @description [varchar](150), @flag [int] output, @msg [varchar](80)	output) AS INSERT INTO [CRM_CustomerType] ( [fullname], [description]) VALUES ( @fullname, @description) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerType_SelectAll 
 (@flag [int] output, @msg	[varchar](80) output) AS SELECT * FROM [CRM_CustomerType] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerType_SelectByID 
 (@id [int], @flag [int]	output, @msg [varchar](80) output) AS SELECT * FROM [CRM_CustomerType] WHERE ( [id] = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomerType_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerType] SET  [fullname]	 = @fullname, [description]	 = @description WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomizeOption_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomizeOption] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_CustomizeOption_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomizeOption] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_Customize_Insert 
 (@userid_1 	[int], @logintype 	[tinyint], @row1col1_2 	[int], @row1col2_3 	[int], @row1col3_4 	[int], @row1col4_5 	[int], @row1col5_6 	[int], @row1col6_7 	[int], @row2col1_8 	[int], @row2col2_9 	[int], @row2col4_10 	[int], @row2col3_11 	[int], @row2col5_12 	[int], @row2col6_13 	[int], @row3col1_14 	[int], @row3col2_15 	[int], @row3col3_16 	[int], @row3col4_17 	[int], @row3col5_18 	[int], @row3col6_19 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [CRM_Customize] ( [userid], [logintype], [row1col1], [row1col2], [row1col3], [row1col4], [row1col5], [row1col6], [row2col1], [row2col2], [row2col4], [row2col3], [row2col5], [row2col6], [row3col1], [row3col2], [row3col3], [row3col4], [row3col5], [row3col6])  VALUES ( @userid_1, @logintype, @row1col1_2, @row1col2_3, @row1col3_4, @row1col4_5, @row1col5_6, @row1col6_7, @row2col1_8, @row2col2_9, @row2col4_10, @row2col3_11, @row2col5_12, @row2col6_13, @row3col1_14, @row3col2_15, @row3col3_16, @row3col4_17, @row3col5_18, @row3col6_19)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_Customize_SelectByUid 
 (@uid 	[int], @logintype 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_Customize] WHERE ( [userid] = @uid and [logintype]	 = @logintype) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_Customize_Update 
 (@userid_1 	[int], @logintype 	[tinyint], @row1col1_2 	[int], @row1col2_3 	[int], @row1col3_4 	[int], @row1col4_5 	[int], @row1col5_6 	[int], @row1col6_7 	[int], @row2col1_8 	[int], @row2col2_9 	[int], @row2col4_10 	[int], @row2col3_11 	[int], @row2col5_12 	[int], @row2col6_13 	[int], @row3col1_14 	[int], @row3col2_15 	[int], @row3col3_16 	[int], @row3col4_17 	[int], @row3col5_18 	[int], @row3col6_19 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [CRM_Customize]  SET  [row1col1]	 = @row1col1_2, [row1col2]	 = @row1col2_3, [row1col3]	 = @row1col3_4, [row1col4]	 = @row1col4_5, [row1col5]	 = @row1col5_6, [row1col6]	 = @row1col6_7, [row2col1]	 = @row2col1_8, [row2col2]	 = @row2col2_9, [row2col4]	 = @row2col4_10, [row2col3]	 = @row2col3_11, [row2col5]	 = @row2col5_12, [row2col6]	 = @row2col6_13, [row3col1]	 = @row3col1_14, [row3col2]	 = @row3col2_15, [row3col3]	 = @row3col3_16, [row3col4]	 = @row3col4_17, [row3col5]	 = @row3col5_18, [row3col6]	 = @row3col6_19  WHERE ( [userid]	 = @userid_1 and [logintype]	 = @logintype)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_DeliveryType_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_DeliveryType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_DeliveryType_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @sendtype 	[varchar](150), @shipment 	[varchar](150), @receive 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_DeliveryType] ( [fullname], [description], [sendtype], [shipment], [receive]) VALUES ( @fullname, @description, @sendtype, @shipment, @receive) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_DeliveryType_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_DeliveryType] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_DeliveryType_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_DeliveryType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_DeliveryType_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @sendtype 	[varchar](150), @shipment 	[varchar](150), @receive 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_DeliveryType] SET  [fullname]	 = @fullname, [description]	 = @description, [sendtype]	 = @sendtype, [shipment]	 = @shipment, [receive]	 = @receive WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_Find_Creater 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT submiter,submitdate,submitertype from [CRM_Log] WHERE ([customerid] = @id) and ([logtype] = 'n') set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_Find_CustomerContacter 
 (@id	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT id,title,fullname,jobtitle FROM [CRM_CustomerContacter] WHERE (customerid = @id) ORDER BY main DESC,fullname ASC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_Find_LastModifier 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT top 1 submiter,submitdate,submitertype from [CRM_Log] WHERE ([customerid] = @id) and (not ([logtype] = 'n')) ORDER BY submitdate DESC set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_Find_RecentRemark 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT top 3 * from [CRM_Log] WHERE ([customerid] = @id) ORDER BY submitdate DESC, submittime DESC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_Info_SelectCountByResource 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select count(*) from CRM_CustomerInfo where manager = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源文档总数信息成功' return end else begin set @flag=0 set @msg='查询人力资源文档总数信息失败' return end 
GO

 CREATE PROCEDURE CRM_LedgerInfo_Delete 
 @customerid	int, @tradetype	char(1), @flag integer output , @msg varchar(80) output as delete from CRM_LedgerInfo where customerid=@customerid and tradetype=@tradetype 
GO

 CREATE PROCEDURE CRM_LedgerInfo_Insert 
 @customerid	int, @customercode	char(10), @tradetype	char(1), @ledger1	int, @ledger2	int, @flag integer output , @msg varchar(80) output as insert into CRM_LedgerInfo values(@customerid,@customercode,@tradetype,@ledger1,@ledger2) 
GO

 CREATE PROCEDURE CRM_LedgerInfo_Select 
 @customerid	int, @tradetype	char(1), @flag integer output , @msg varchar(80) output as select * from crm_ledgerinfo where customerid=@customerid and tradetype=@tradetype 
GO

 CREATE PROCEDURE CRM_LedgerInfo_SelectAll 
 @customerid	int, @flag integer output , @msg varchar(80) output as select * from crm_ledgerinfo where customerid=@customerid 
GO

 CREATE PROCEDURE CRM_LedgerInfo_Update 
 @customerid	int, @customercode	char(10), @tradetype	char(1), @flag integer output , @msg varchar(80) output as update CRM_LedgerInfo set customercode=@customercode where customerid=@customerid and tradetype=@tradetype 
GO

 CREATE PROCEDURE CRM_Log_Insert 
 (@customerid 	[int], @logtype 	[char](2), @documentid 	[int], @logcontent 	text, @submitdate 	[varchar](10), @submittime 	[varchar](8), @submiter 	[int], @submitertype 	[tinyint], @clientip 	[char](15), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [CRM_Log] ( [customerid], [logtype], [documentid], [logcontent], [submitdate], [submittime], [submiter], [submitertype], [clientip])  VALUES ( @customerid, @logtype, @documentid, @logcontent, @submitdate, @submittime, @submiter, @submitertype, @clientip) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_Log_Select 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [CRM_Log] WHERE ([customerid] = @id) ORDER BY submitdate DESC, submittime DESC set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_LoginLog_Insert 
 @id	int,  @logindate	char(10), @logintime	char(8), @ipaddress	char(15), @flag integer output , @msg varchar(80) output AS insert into CRM_loginLog (id, logindate, logintime, ipaddress) values(@id, @logindate, @logintime, @ipaddress) 

GO

 CREATE PROCEDURE CRM_Modify_Insert 
 (@customerid 	[int], @tabledesc 	[char](1), @type 		[int], @addresstype 	[int], @fieldname 	[varchar](100), @modifydate 	[varchar](10), @modifytime 	[varchar](8), @original 	[varchar](255), @modified 	[varchar](255), @modifier 	[int], @submitertype 	[tinyint], @clientip 	[char](15), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_Modify] ( [customerid], [tabledesc], [type], [addresstype], [fieldname], [modifydate], [modifytime], [original], [modified], [modifier], [submitertype], [clientip]) VALUES ( @customerid, @tabledesc, @type, @addresstype, @fieldname, @modifydate, @modifytime, @original, @modified, @modifier, @submitertype, @clientip) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_Modify_Select 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_Modify] WHERE ( [customerid]	 = @id) ORDER BY modifydate DESC, modifytime DESC set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE CRM_PaymentTerm_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_PaymentTerm] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_PaymentTerm_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_PaymentTerm] ( [fullname], [description]) VALUES ( @fullname, @description) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_PaymentTerm_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_PaymentTerm] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_PaymentTerm_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_PaymentTerm] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_PaymentTerm_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_PaymentTerm] SET  [fullname]	 = @fullname, [description]	 = @description WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_RpSum 
 @optional	varchar(30), @flag	int output, @msg varchar(80) output AS if  @optional='contactway' select source AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by source order by resultcount  if  @optional='customersize' select size_n AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by size_n order by resultcount  if  @optional='customertype' select type AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by type order by resultcount  if  @optional='customerdesc' select description AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by description order by resultcount  if  @optional='customerstatus' select status AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by status order by resultcount  if  @optional='paymentterm' select paymentterm AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by paymentterm order by resultcount  if  @optional='customerrating' select rating AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by rating order by resultcount  if  @optional='creditinfo' select creditlevel AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by creditlevel order by resultcount  if  @optional='tradeinfo' select contractlevel AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by contractlevel order by resultcount  if  @optional='manager' select manager AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by manager order by resultcount  if  @optional='department' select department AS resultid,COUNT(id) AS resultcount from CRM_Customerinfo where deleted=0 group by department order by resultcount 
GO

 CREATE PROCEDURE CRM_SectorInfo_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_SectorInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_SectorInfo_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @parentid 	[int], @seclevel 	[int], @sectors	[varchar](255), @flag	[int]	output, @msg	[varchar](80)	output) AS declare @id int set @id=1 if((select count(*) from CRM_SectorInfo)>0) begin select @id=max(id)+1 from CRM_SectorInfo end INSERT INTO [CRM_SectorInfo] (id, [fullname], [description], [parentid], [seclevel], [sectors]) VALUES (@id, @fullname, @description, @parentid, @seclevel, @sectors) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_SectorInfo_SelectAll 
 (@parentid	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_SectorInfo] WHERE	([parentid] = @parentid) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_SectorInfo_SelectAllInfo 
 ( @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_SectorInfo]  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_SectorInfo_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_SectorInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_SectorInfo_Update 
 (@id 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @parentid 	[int], @seclevel 	[int], @sectors	[varchar](255), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_SectorInfo] SET  [fullname]	 = @fullname, [description]	 = @description, [parentid]	 = @parentid, [seclevel]	 = @seclevel, [sectors]	 = @sectors WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_SectorRpSum 
 @parentid	varchar(30), @flag	int output, @msg varchar(80) output AS declare @tempstr varchar(30), @tempid int set @tempstr='%,'+@parentid+',%' set @tempid=cast(@parentid as int)  select count(id) as resultcount from crm_customerinfo where sector in(select id from crm_sectorinfo where id=@tempid or sectors like @tempstr) 
GO

 CREATE PROCEDURE CRM_ShareInfo_Delete 
 (@id int, @flag integer output, @msg varchar(80) output ) AS DELETE from CRM_ShareInfo  WHERE ( id = @id) set @flag=1 set @msg='ok' 
GO

 CREATE PROCEDURE CRM_ShareInfo_Insert 
 (@relateditemid int, @sharetype tinyint, @seclevel  tinyint, @rolelevel tinyint, @sharelevel tinyint, @userid int, @departmentid int, @roleid int, @foralluser tinyint, @flag integer output, @msg varchar(80) output ) AS INSERT INTO CRM_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser ) VALUES ( @relateditemid , @sharetype , @seclevel , @rolelevel , @sharelevel, @userid, @departmentid, @roleid, @foralluser  ) set @flag=1 set @msg='ok' 
GO

 CREATE PROCEDURE CRM_ShareInfo_SbyRelateditemid 
 (@relateditemid int , @flag integer output , @msg varchar(80) output ) AS select * from CRM_ShareInfo where ( relateditemid = @relateditemid ) order by sharetype set  @flag = 1 set  @msg = 'ok' 
GO

 CREATE PROCEDURE CRM_ShareInfo_SelectbyID 
 (@id int , @flag integer output , @msg varchar(80) output ) AS select * from CRM_ShareInfo where (id = @id ) set  @flag = 1 set  @msg = 'ok' 
GO

 CREATE PROCEDURE CRM_TradeInfo_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [CRM_TradeInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_TradeInfo_Insert 
 (@fullname 	[varchar](50), @rangelower 	[varchar](50), @rangeupper 	[varchar](50), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [CRM_TradeInfo] ( [fullname], [rangelower], [rangeupper]) VALUES ( @fullname, convert(money,@rangelower), convert(money,@rangeupper)) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_TradeInfo_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_TradeInfo] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_TradeInfo_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_TradeInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_TradeInfo_Update 
 (@id 	[int], @fullname 	[varchar](50), @rangelower 	[varchar](50), @rangeupper 	[varchar](50), @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_TradeInfo] SET  [fullname]	 = @fullname, [rangelower]	 = convert(money,@rangelower), [rangeupper]	 = convert(money,@rangeupper) WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE CRM_ViewLog1_Insert 
 @id	int, @viewer	int, @submitertype 	[tinyint], @viewdate	char(10), @viewtime	char(8), @ipaddress	char(15), @flag integer output , @msg varchar(80) output AS insert into CRM_viewLog1 (id, viewer, submitertype, viewdate, viewtime, ipaddress) values(@id, @viewer, @submitertype, @viewdate, @viewtime, @ipaddress) 

GO

 CREATE PROCEDURE CptAssortmentShare_Insert 
(@assortmentid_1 [int],
@sharetype_2 [tinyint],
@seclevel_3 [tinyint],
@rolelevel_4 [tinyint],
@sharelevel_5 [tinyint],
@userid_6 [int],
@departmentid_7 [int],
@roleid_8 [int],
@foralluser_9 [tinyint],
@flag integer output,
@msg varchar(80) output)

AS INSERT INTO [CptAssortmentShare]
( [assortmentid],
[sharetype],
[seclevel],
[rolelevel],
[sharelevel],
[userid],
[departmentid],
[roleid],
[foralluser])

VALUES
( @assortmentid_1,
@sharetype_2,
@seclevel_3,
@rolelevel_4,
@sharelevel_5,
@userid_6,
@departmentid_7,
@roleid_8,
@foralluser_9)

select max(id)  id from CptAssortmentShare


GO

/*资产类型删除(替代原来的资产类型)*/
 CREATE PROCEDURE CptCapitalAssortment_Delete 
	(@id_1 	[int],
	@flag integer output, 
	 @msg varchar(80) output )
AS 
	declare @count integer , @supassortmentid int 
	
	/*不能有相同的标识*/
	select @count = capitalcount from CptCapitalAssortment where id = @id_1
	if @count <> 0
	begin
	select -1
	return
	end

	select @count = subassortmentcount  from CptCapitalAssortment where id = @id_1
	if @count <> 0
	begin
	select -1
	return
	end

	/*一级目录不可删除*/
	select @supassortmentid = supassortmentid from CptCapitalAssortment where id= @id_1
	
	if @supassortmentid = 0
	begin
	select -1
	return
	end
	
	update CptCapitalAssortment set subassortmentcount = subassortmentcount-1 where id= @supassortmentid
	

	DELETE [CptCapitalAssortment] 
	WHERE [id] = @id_1
GO

/*新增资产类型*/
 CREATE PROCEDURE CptCapitalAssortment_Insert 
  ( @assortmentname_2 	[varchar](60),
    @assortmentmark	[varchar](30),
    @assortmentremark_6 	[text], 
   @supassortmentid_7 	[int], 
   @supassortmentstr_8 	[varchar](200),
   @flag integer output, @msg varchar(80) output ) 
    AS declare @count integer  
    if @supassortmentid_7 <>0 
    begin /*上级类型不能有物品*/
     select @count = capitalcount from CptCapitalAssortment 
     where id = @supassortmentid_7 
     if @count <> 0 begin select -1 
     return end /*上级类型子类型数+1*/
      UPDATE CptCapitalAssortment 
      SET subassortmentcount=subassortmentcount+1 
      WHERE id = @supassortmentid_7 end  INSERT INTO
 [CptCapitalAssortment]
 ([assortmentname],[assortmentmark], [assortmentremark], [supassortmentid], [supassortmentstr], [subassortmentcount], [capitalcount] )VALUES (@assortmentname_2, @assortmentmark,@assortmentremark_6, @supassortmentid_7, @supassortmentstr_8, 0, 0) 
select max(id) from CptCapitalAssortment
GO

/*按id查询资产类型*/
 CREATE PROCEDURE CptCapitalAssortment_SByID 
  (@id_1 	[int], @flag integer output , @msg varchar(80) output) 
  AS
   select * from CptCapitalAssortment where id = @id_1

GO

/*选择没有子类型的资产类型*/
 CREATE PROCEDURE CptCapitalAssortment_SLeaf 
  @flag integer output , @msg varchar(80) output 
  AS 
  select * from CptCapitalAssortment where subassortmentcount = 0

GO

/*2002-9-17 15:48*/
/*选择资产种类根结点*/
 CREATE PROCEDURE CptCapitalAssortment_SRoot 
  @flag integer output , @msg varchar(80) output 
  AS 
  select * from CptCapitalAssortment where supassortmentid = 0

GO

/*资产类型选择上级资产字符串*/
 CREATE PROCEDURE CptCapitalAssortment_SSupAssor 
  @id_1 	[int], @flag integer output , @msg varchar(80) output 
  AS 
  select supassortmentstr from  CptCapitalAssortment  where id = @id_1

GO

/*查询资产类型*/
 CREATE PROCEDURE CptCapitalAssortment_Select 
 @flag integer output , @msg varchar(80) output 
  AS select * from CptCapitalAssortment order by assortmentname

GO

/*查询所有资产类型*/
 CREATE PROCEDURE CptCapitalAssortment_SelectAll 
  ( @flag integer output , @msg varchar(80) output) 
  AS
   select * from CptCapitalAssortment
GO

 CREATE PROCEDURE CptCapitalAssortment_Update 
  (@id_1 	[int],
   @assortmentname_3 	[varchar](60), 
    @assortmentmark	[varchar](30),
    @assortmentremark_7 	[text],
    @supassortmentid_8 	[int], 
    @supassortmentstr_9 	[varchar](200), 
   	@flag integer output, @msg varchar(80) output )  
  	AS UPDATE [CptCapitalAssortment]  
  	SET [assortmentname]	 = @assortmentname_3,
	[assortmentmark] = @assortmentmark,
[assortmentremark]	 = @assortmentremark_7, 
  	[supassortmentid]	 = @supassortmentid_8, 
[supassortmentstr]	 = @supassortmentstr_9
  WHERE ( [id]	 = @id_1)

GO

/*资产组删除*/
 CREATE PROCEDURE CptCapitalGroup_Delete 
(@id 	[int], 
@flag	[int]	output,
 @msg	[varchar](80)	output)
 AS
declare @count int
select @count=count(*) from  CptCapitalGroup where parentid = @id
if @count<>0
begin
select -1
end
else
begin
DELETE [CptCapitalGroup] 
WHERE ( [id] = @id) set @flag = 1 set @msg = 'OK!'
end

GO

/*资产组新增*/
 CREATE PROCEDURE CptCapitalGroup_Insert 
(@name 	[varchar](60), 
@description 	[varchar](200), 
@parentid 	[int], 
@flag	[int]	output,
@msg	[varchar](80)	output) 
AS 
INSERT INTO [CptCapitalGroup]
 ( [name],
 [description], 
[parentid])
 VALUES ( @name, @description, @parentid) set @flag = 1 set @msg = 'OK!'

GO

/*按照父资产组查询*/
 CREATE PROCEDURE CptCapitalGroup_SelectAll 
(@parentid	[int],
 @flag	[int]	output, @msg	[varchar](80)	output) 
AS
SELECT * FROM [CptCapitalGroup]
 WHERE ([parentid] = @parentid) set @flag = 1 set @msg = 'OK!'

GO

/*查询所有资产组*/
 CREATE PROCEDURE CptCapitalGroup_SelectAllInfo 
( @flag	[int]	output, @msg	[varchar](80)	output)
 AS SELECT * FROM [CptCapitalGroup]  set @flag = 1 set @msg = 'OK!'

GO

/*按照id查询资产组*/
 CREATE PROCEDURE CptCapitalGroup_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
AS 
SELECT * FROM [CptCapitalGroup] 
WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'

GO

/*资产组更新*/
 CREATE PROCEDURE CptCapitalGroup_Update 
 (@id 	[int], 
@name 	[varchar](60),
 @description 	[varchar](200),
 @parentid 	[int],
@flag	[int]	output, @msg	[varchar](80)	output)
 AS
 UPDATE [CptCapitalGroup] 
SET  [name]	 = @name, 
[description]	 = @description,
 [parentid]	 = @parentid
 WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'

GO

/*删除共享信息*/
 CREATE PROCEDURE CptCapitalShareInfo_Delete 
(@id_1 [int],
@flag integer output,
@msg varchar(80) output)

AS DELETE [CptCapitalShareInfo]

WHERE
( [id] = @id_1)

GO

/*新增共享信息*/
 CREATE PROCEDURE CptCapitalShareInfo_Insert 
(@relateditemid_1 [int],
@sharetype_2 [tinyint],
@seclevel_3 [tinyint],
@rolelevel_4 [tinyint],
@sharelevel_5 [tinyint],
@userid_6 [int],
@departmentid_7 [int],
@roleid_8 [int],
@foralluser_9 [tinyint],
@flag integer output,
@msg varchar(80) output)

AS INSERT INTO [CptCapitalShareInfo]
( [relateditemid],
[sharetype],
[seclevel],
[rolelevel],
[sharelevel],
[userid],
[departmentid],
[roleid],
[foralluser])

VALUES
( @relateditemid_1,
@sharetype_2,
@seclevel_3,
@rolelevel_4,
@sharelevel_5,
@userid_6,
@departmentid_7,
@roleid_8,
@foralluser_9)

select max(id)  id from CptCapitalShareInfo

GO

/*2002-8-28*/
/*按照相关项查找共享信息*/
 CREATE PROCEDURE CptCapitalShareInfo_SbyRelated 
  (@relateditemid int , @flag integer output , @msg varchar(80) output )
  AS 
  select * from CptCapitalShareInfo where ( relateditemid = @relateditemid ) order by sharetype
  set  @flag = 1 set  @msg = 'ok'

GO

/*按照id查询共享信息*/
 CREATE PROCEDURE CptCapitalShareInfo_SelectbyID 
  (@id int , @flag integer output , @msg varchar(80) output )
  AS
  select * from CptCapitalShareInfo where (id = @id )
  set  @flag = 1 set  @msg = 'ok'

GO

/*资产状态删除*/
 CREATE PROCEDURE CptCapitalState_Delete 
	(@id_1 	[int],
	@flag integer output,
	 @msg varchar(80) output)

AS DELETE [CptCapitalState] 

WHERE 
	( [id]	 = @id_1)

GO

/*资产状态新增*/
 CREATE PROCEDURE CptCapitalState_Insert 
	( @name_2 	[varchar](60),
	 @description_3 	[varchar](200),
	@flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CptCapitalState] 
	 ( [name],
	 [description]) 
 
VALUES 
	( @name_2,
	 @description_3)

GO

/*查询所有资产状态*/
 CREATE PROCEDURE CptCapitalState_Select 
	@flag integer output ,
 	@msg varchar(80) output 

AS select * from CptCapitalState
set  @flag = 0 set  @msg = '操作成功完成'

GO

/*按照id查询资产状态*/
 CREATE PROCEDURE CptCapitalState_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from CptCapitalState
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

/*资产状态更新*/
 CREATE PROCEDURE CptCapitalState_Update 
	(@id_1 	[int],
	 @name_2 	[varchar](60),
	 @description_3 	[varchar](200),
	@flag integer output,
	 @msg varchar(80) output)

AS UPDATE [CptCapitalState] 

SET  [name]	 = @name_2,
	 [description]	 = @description_3 

WHERE 
	( [id]	 = @id_1)

GO

/*资产类型删除*/
 CREATE PROCEDURE CptCapitalType_Delete 
	(@id_1 	[int],
	@flag integer output,
	 @msg varchar(80) output)

AS DELETE [CptCapitalType] 

WHERE 
	( [id]	 = @id_1)

GO

/*资产类型新增*/
 CREATE PROCEDURE CptCapitalType_Insert 
	(@name_1 	[varchar](60),
	 @description_2 	[varchar](200),
	@flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CptCapitalType] 
	 ( [name],
	 [description]) 
 
VALUES 
	( @name_1,
	 @description_2)

GO

/*查询所有资产类型*/
 CREATE PROCEDURE CptCapitalType_Select 
	@flag integer output ,
 	@msg varchar(80) output 

AS select * from CptCapitalType
set  @flag = 0 set  @msg = '操作成功完成'

GO

/*按照id查询资产类型*/
 CREATE PROCEDURE CptCapitalType_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from CptCapitalType
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

/*更新资产类型*/
 CREATE PROCEDURE CptCapitalType_Update 
	(@id_1 	[int],
	 @name_2 	[varchar](60),
	 @description_3 	[varchar](200),
	@flag integer output,
	 @msg varchar(80) output)

AS UPDATE [CptCapitalType] 

SET  [name]	 = @name_2,
	 [description]	 = @description_3 

WHERE 
	( [id]	 = @id_1)

GO

/*修改资产卡片删除*/
 CREATE PROCEDURE CptCapital_Delete 
	(@id_1 	[int],
	@flag integer output,
	 @msg varchar(80) output)

AS 
declare @count int

select @count=count(*) from CptCapital where datatype = @id_1
begin
	if @count<>0
	begin
		select -1
		return
	end
end

update CptCapitalAssortment set capitalcount = capitalcount-1 
where id in (select capitalgroupid from CptCapital where id = @id_1 )

DELETE [CptCapital] 

WHERE 
	( [id]	 = @id_1)

select max(id) from CptCapital

GO

/*复制当前资产*/
 CREATE PROCEDURE CptCapital_Duplicate 
	(@capitalid 	int,
	@flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CptCapital] 
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
where id = @capitalid

select max(id)  from CptCapital
GO

 CREATE PROCEDURE CptCapital_HandBackSelect 
	 @resourceid	int,
	 @managerid	int,
	 @flag integer output , 
	 @msg varchar(80) output
 AS
select * from CptCapital
where isdata = '2' and resourceid = @resourceid 
and datatype in (select id from CptCapital where isdata = '1' 
				and resourceid = @managerid)
GO

/*insert altered at 2002-8-13,新增6个字段*/
/*2002-9-16增加类型数计算*/
/*新增资产*/
 CREATE PROCEDURE CptCapital_Insert 
	(@mark		[varchar](60), 
	@name_2 	[varchar](60),
	 @barcode_3 	[varchar](30),
	 @seclevel_6 	[tinyint],
     	@resourceid	[int],		
	 @sptcount	[char](1),
	 @currencyid_10 	[int],
	 @capitalcost_11 	[decimal](18,3),
	 @startprice_12 	[decimal](18,3),
	@depreendprice [decimal](18,3),
	@capitalspec		varchar(60),			
	@capitallevel		varchar(30),	
	@manufacturer		varchar(100),			
	 @capitaltypeid_13 	[int],
	 @capitalgroupid_14 	[int],
	 @unitid_15 	[int],
	 @capitalnum	[decimal](18,3),
	 @replacecapitalid_17 	[int],
	 @version_18 	[varchar](60),
	 @remark_20 	[text],
	 @capitalimageid_21 	[int],
	 @depremethod1_22 	[int],
	 @depremethod2_23 	[int],
	 @customerid_26 	[int],
	 @attribute_27 	[tinyint],
	 @datefield1_30 	[char](10),
	 @datefield2_31 	[char](10),
	 @datefield3_32 	[char](10),
	 @datefield4_33 	[char](10),
	 @datefield5_34 	[char](10),
	 @numberfield1_35 	[float],
	 @numberfield2_36 	[float],
	 @numberfield3_37 	[float],
	 @numberfield4_38 	[float],
	 @numberfield5_39 	[float],
	 @textfield1_40 	[varchar](100),
	 @textfield2_41 	[varchar](100),
	 @textfield3_42 	[varchar](100),
	 @textfield4_43 	[varchar](100),
	 @textfield5_44 	[varchar](100),
	 @tinyintfield1_45 	[char](1),
	 @tinyintfield2_46 	[char](1),
	 @tinyintfield3_47 	[char](1),
	 @tinyintfield4_48 	[char](1),
	 @tinyintfield5_49 	[char](1),
	 @createrid_50 	[int],
	 @createdate_51 	[char](10),
	 @createtime_52 	[char](8),
	 @lastmoderid_53 	[int],
	 @lastmoddate_54 	[char](10),
	 @lastmodtime_55 	[char](8),
	 @isdata		[char](1),
	@flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CptCapital] 
	 ( [mark],
	 [name],
	 [barcode],
	 [seclevel],
	 [resourceid],
	 sptcount,
	 [currencyid],
	 [capitalcost],
	 [startprice],
	 depreendprice,	
	 capitalspec,		
	 capitallevel,	
	 manufacturer,	
	 [capitaltypeid],
	 [capitalgroupid],
	 [unitid],
	 [capitalnum],
	 [replacecapitalid],
	 [version],
	 [remark],
	 [capitalimageid],
	 [depremethod1],
	 [depremethod2],
	 [customerid],
	 [attribute],
	 [datefield1],
	 [datefield2],
	 [datefield3],
	 [datefield4],
	 [datefield5],
	 [numberfield1],
	 [numberfield2],
	 [numberfield3],
	 [numberfield4],
	 [numberfield5],
	 [textfield1],
	 [textfield2],
	 [textfield3],
	 [textfield4],
	 [textfield5],
	 [tinyintfield1],
	 [tinyintfield2],
	 [tinyintfield3],
	 [tinyintfield4],
	 [tinyintfield5],
	 [createrid],
	 [createdate],
	 [createtime],
	 [lastmoderid],
	 [lastmoddate],
	 [lastmodtime],
	 [isdata]) 
 
VALUES 
	(@mark,
	 @name_2,
	 @barcode_3,
	 @seclevel_6,
	 @resourceid,
	 @sptcount,
	 @currencyid_10,
	 @capitalcost_11,
	 @startprice_12,
	@depreendprice,
	@capitalspec,			
	@capitallevel,			
	@manufacturer,			
	 @capitaltypeid_13,
	 @capitalgroupid_14,
	 @unitid_15,
	 @capitalnum,
	 @replacecapitalid_17,
	 @version_18,
	 @remark_20,
	 @capitalimageid_21,
	 @depremethod1_22,
	 @depremethod2_23,
	 @customerid_26,
	 @attribute_27,
	 @datefield1_30,
	 @datefield2_31,
	 @datefield3_32,
	 @datefield4_33,
	 @datefield5_34,
	 @numberfield1_35,
	 @numberfield2_36,
	 @numberfield3_37,
	 @numberfield4_38,
	 @numberfield5_39,
	 @textfield1_40,
	 @textfield2_41,
	 @textfield3_42,
	 @textfield4_43,
	 @textfield5_44,
	 @tinyintfield1_45,
	 @tinyintfield2_46,
	 @tinyintfield3_47,
	 @tinyintfield4_48,
	 @tinyintfield5_49,
	 @createrid_50,
	 @createdate_51,
	 @createtime_52,
	 @lastmoderid_53,
	 @lastmoddate_54,
	 @lastmodtime_55,
	 @isdata)


declare @thisid int

select @thisid = max(id) from CptCapital

update CptCapitalAssortment set capitalcount = capitalcount+1 
where id in (select capitalgroupid from CptCapital where id = @thisid)

select max(id) from CptCapital
GO

 CREATE PROCEDURE CptCapital_SCountByCapitalGrou 
(@capitalgroupid 	int, 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select count(id) from CptCapital where capitalgroupid = @capitalgroupid
 if @@error<>0 begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end
GO







/*  2002-9-11 */
 CREATE PROCEDURE CptCapital_SSumByCapitalgroup 
 (@flag	[int]	output, 
@msg	[varchar](80)	output)
 AS 
select capitalgroupid AS resultid, COUNT(id) AS resultcount 
from CptCapital
group by capitalgroupid  
order by  resultcount desc

GO

 CREATE PROCEDURE CptCapital_SSumByCapitaltypeid 
 (@flag	[int]	output, 
@msg	[varchar](80)	output)
 AS 
select capitaltypeid AS resultid, COUNT(id) AS resultcount 
from CptCapital
group by capitaltypeid  
order by  resultcount desc

GO

 CREATE PROCEDURE CptCapital_SSumByCustomerid 
 (@flag	[int]	output, 
@msg	[varchar](80)	output)
 AS 
select customerid AS resultid, COUNT(id) AS resultcount 
from CptCapital
group by customerid  
order by  resultcount desc

GO

 CREATE PROCEDURE CptCapital_SSumByDepartmentid 
 (@flag	[int]	output, 
@msg	[varchar](80)	output)
 AS 
select departmentid AS resultid, COUNT(id) AS resultcount 
from CptCapital
group by departmentid  
order by  resultcount desc

GO

 CREATE PROCEDURE CptCapital_SSumByResourceid 
 (@flag	[int]	output, 
@msg	[varchar](80)	output)
 AS 
select resourceid AS resultid, COUNT(id) AS resultcount 
from CptCapital
group by resourceid  
order by  resultcount desc

GO

/*查询所有资产*/
 CREATE PROCEDURE CptCapital_SelectAll 
(@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptCapital order by departmentid
  if @@error<>0 
begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end
GO

 CREATE PROCEDURE CptCapital_SByCapitalGroupID 
(@id_1 	[int], 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptCapital where capitalgroupid = @id_1 and isdata  ='2'
 if @@error<>0 begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end
GO

/*按资产类型选择资产*/
 CREATE PROCEDURE CptCapital_SByCapitalTypeID 
(@id_1 	[int], 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptCapital where capitaltypeid = @id_1
 if @@error<>0 begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end

GO

 CREATE PROCEDURE CptCapital_SelectByDataType 
(@datatype 	int, 
 @departmentid  int,
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptCapital where datatype = @datatype and departmentid = @departmentid
 if @@error<>0 begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end
GO

/*2002-8-9*/
/*按照id查询资产*/
 CREATE PROCEDURE CptCapital_SelectByID 
(@id_1 	[int], 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptCapital where id = @id_1
 if @@error<>0 begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end

GO

 CREATE PROCEDURE CptCapital_SelectByRandR 
  (@managerid 	[int],
   @resourceid   [int],
 @flag integer output , @msg varchar(80) output) 
  AS
   select * from CptCapital
  where isdata = '2' and resourceid = @resourceid and 
datatype in (select id from CptCapital where isdata = '1' 
		and resourceid = @managerid)
GO

 CREATE PROCEDURE CptCapital_SCountByDataType 
(@datatype 	int, 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select count(id) from CptCapital where capitalgroupid = (select distinct(capitalgroupid) from CptCapital where datatype =  @datatype) and isdata='2'

 if @@error<>0 begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end
GO

 CREATE PROCEDURE CptCapital_SCountByResourceid 
(@resourceid 	int, 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select count(id) from CptCapital where resourceid = @resourceid and isdata= '2'
 if @@error<>0 begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end
GO

 CREATE PROCEDURE CptCapital_SelectSumByStateid 
 (@flag	[int]	output, 
@msg	[varchar](80)	output)
 AS 
select stateid AS resultid, COUNT(id) AS resultcount 
from CptCapital
group by stateid  
order by  resultcount desc

GO

/*2002-9-18 1:05 修改流转表,新增字段:流出部门*/
--alter table CptUseLog add olddeptid int null

/*2002-9-17 17:19*/
/*按人力资源和类型查询资产*/
 CREATE PROCEDURE CptCapital_SelectbyRandT 
  (@resourceid int,
   @capitaltypeid int,
   @flag integer output ,
   @msg varchar(80) output )

  AS
  select id,name,capitalspec,capitalnum from CptCapital 
  where (resourceid = @resourceid and  capitaltypeid=@capitaltypeid)
  set  @flag = 1 set  @msg = 'ok'
GO

 CREATE PROCEDURE CptCapital_Update 
	(@id_1 	[int],
	 @name_3 	[varchar](60),
	 @barcode_4 	[varchar](30),
	 @startdate		[char](10),
	 @enddate		[char](10),
	 @seclevel_7 	[tinyint],
	 @resourceid	[int],
	 @sptcount 	[char](1),
	 @currencyid_11 	[int],
	 @capitalcost_12 	[decimal](18,3),
	 @startprice_13 	[decimal](18,3),
	@depreendprice [decimal](18,3),
	@capitalspec		varchar(60),			
	@capitallevel		varchar(30),			
	@manufacturer		varchar(100),
	@manudate		[char](10),			
	 @capitaltypeid_14 	[int],
	 @capitalgroupid_15 	[int],
	 @unitid_16 	[int],
	 @replacecapitalid_18 	[int],
	 @version_19 	[varchar](60),
	 @location      [varchar](100),
	 @remark_21 	[text],
	 @capitalimageid_22 	[int],
	 @depremethod1_23 	[int],
	 @depremethod2_24 	[int],
	 @deprestartdate	[char](10),
	 @depreenddate		[char](10),
	 @customerid_27 	[int],
	 @attribute_28 	[tinyint],
	 @datefield1_31 	[char](10),
	 @datefield2_32 	[char](10),
	 @datefield3_33 	[char](10),
	 @datefield4_34 	[char](10),
	 @datefield5_35 	[char](10),
	 @numberfield1_36 	[float],
	 @numberfield2_37 	[float],
	 @numberfield3_38 	[float],
	 @numberfield4_39 	[float],
	 @numberfield5_40 	[float],
	 @textfield1_41 	[varchar](100),
	 @textfield2_42 	[varchar](100),
	 @textfield3_43 	[varchar](100),
	 @textfield4_44 	[varchar](100),
	 @textfield5_45 	[varchar](100),
	 @tinyintfield1_46 	[char](1),
	 @tinyintfield2_47 	[char](1),
	 @tinyintfield3_48 	[char](1),
	 @tinyintfield4_49 	[char](1),
	 @tinyintfield5_50 	[char](1),
	 @lastmoderid_51 	[int],
	 @lastmoddate_52 	[char](10),
	 @lastmodtime_53 	[char](8),
	 @relatewfid		[int],
     @alertnum          [decimal](18,3),
     @fnamark			[varchar](60),
	 @flag integer output,
	 @msg varchar(80) output)

AS 
/*更新资产组中的资产卡片数量信息*/
declare @tempgroupid int
select @tempgroupid=capitalgroupid from CptCapital where id=@id_1
if @tempgroupid<>@capitalgroupid_15
begin
	update CptCapitalAssortment set capitalcount = capitalcount-1 
	where id=@tempgroupid
	update CptCapitalAssortment set capitalcount = capitalcount+1 
	where id=@capitalgroupid_15
end

UPDATE [CptCapital] 

SET  	 [name]	 = @name_3,
	 [barcode]	 = @barcode_4,
	 [startdate] = @startdate,
	 [enddate]	 = @enddate,	
	 [seclevel]	 = @seclevel_7,
	 [resourceid] = @resourceid,
	 [sptcount]	= @sptcount,	
	 [currencyid]	 = @currencyid_11,
	 [capitalcost]	 = @capitalcost_12,
	 [startprice]	 = @startprice_13,
	 depreendprice	= @depreendprice,
	 capitalspec	= @capitalspec,
	 capitallevel	= @capitallevel,
	 manufacturer	= @manufacturer,
	 manudate      = @manudate,
	 [capitaltypeid]	 = @capitaltypeid_14,
	 [capitalgroupid]	 = @capitalgroupid_15,
	 [unitid]	 = @unitid_16,
	 [replacecapitalid]	 = @replacecapitalid_18,
	 [version]	 = @version_19,
	 [location]	  = @location,
	 [remark]	 = @remark_21,
	 [capitalimageid]	 = @capitalimageid_22,
	 [depremethod1]	 = @depremethod1_23,
	 [depremethod2]	 = @depremethod2_24,
	 [deprestartdate]= @deprestartdate,
	 [depreenddate]  = @depreenddate,
	 [customerid]	 = @customerid_27,
	 [attribute]	 = @attribute_28,
	 [datefield1]	 = @datefield1_31,
	 [datefield2]	 = @datefield2_32,
	 [datefield3]	 = @datefield3_33,
	 [datefield4]	 = @datefield4_34,
	 [datefield5]	 = @datefield5_35,
	 [numberfield1]	 = @numberfield1_36,
	 [numberfield2]	 = @numberfield2_37,
	 [numberfield3]	 = @numberfield3_38,
	 [numberfield4]	 = @numberfield4_39,
	 [numberfield5]	 = @numberfield5_40,
	 [textfield1]	 = @textfield1_41,
	 [textfield2]	 = @textfield2_42,
	 [textfield3]	 = @textfield3_43,
	 [textfield4]	 = @textfield4_44,
	 [textfield5]	 = @textfield5_45,
	 [tinyintfield1]	 = @tinyintfield1_46,
	 [tinyintfield2]	 = @tinyintfield2_47,
	 [tinyintfield3]	 = @tinyintfield3_48,
	 [tinyintfield4]	 = @tinyintfield4_49,
	 [tinyintfield5]	 = @tinyintfield5_50,
	 [lastmoderid]	 = @lastmoderid_51,
	 [lastmoddate]	 = @lastmoddate_52,
	 [lastmodtime]	 = @lastmodtime_53,
	 [relatewfid]	= @relatewfid,
	 [alertnum]	 = @alertnum,
	 [fnamark]	= @fnamark
	 

WHERE 
	( [id]	 = @id_1)
GO

/*删除图片信息*/
 CREATE PROCEDURE CptCapital_UpdatePic 
 (@id_1 	[int], @capitalimageid_2     [int], 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
update CptCapital
set capitalimageid = 0 where id = @id_1 delete ImageFile where imagefileid = @capitalimageid_2 
 if @@error<>0
 begin 
set @flag=1 set @msg='删除资产信息图片成功' return 
end 
else
 begin
set @flag=0 set @msg='删除资产信息图片失败' return 
end

GO

/*资产卡片参考价格更新*/
 CREATE PROCEDURE CptCapital_UpdatePrice 
 (@id 	[int], 
@price 	[decimal](18,3),
@flag	[int]	output, @msg	[varchar](80)	output)
 AS
 UPDATE [CptCapital] 
SET  [startprice]=@price
 WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'
GO

/*按盘点单id删除详细单*/
 CREATE PROCEDURE CptCheckStockList_DByCheckSto 
	(@checkstockid_1 	[int],
	@flag                             integer output, 
	@msg                             varchar(80) output )

AS DELETE [CptCheckStockList] 

WHERE 
	( [checkstockid]	 = @checkstockid_1)

GO

/*盘点详细单新增*/
 CREATE PROCEDURE CptCheckStockList_Insert 
	(@checkstockid_1 	[int],
	 @capitalid_2 	[int],
	 @theorynumber_3 	[int],
	 @realnumber_4 	[int],
	 @price_5 	[decimal](10,2),
	 @remark_6 	[varchar](200),
	@flag                             integer output, 
	@msg                             varchar(80) output )

AS INSERT INTO [CptCheckStockList] 
	 ( [checkstockid],
	 [capitalid],
	 [theorynumber],
	 [realnumber],
	 [price],
	 [remark]) 
 
VALUES 
	( @checkstockid_1,
	 @capitalid_2,
	 @theorynumber_3,
	 @realnumber_4,
	 @price_5,
	 @remark_6)

GO

/*按盘点单id查找盘点详细单*/
 CREATE PROCEDURE CptCheckStockList_SByCheckSto 
	 @checkstockid varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from CptCheckStockList
      where checkstockid =convert(int, @checkstockid)
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

/*盘点详细单更新*/
 CREATE PROCEDURE CptCheckStockList_Update 
	(@id_1 	[int],
	 @realnumber_2 	[int],
	 @remark_3 	[varchar](200),
	@flag                             integer output, 
	@msg                             varchar(80) output )

AS UPDATE [CptCheckStockList] 

SET  [realnumber]	 = @realnumber_2,
	 [remark]	 = @remark_3 

WHERE 
	( [id]	 = @id_1)

GO

/*盘点单审批*/
 CREATE PROCEDURE CptCheckStock_Approve 
	(@id_1 	[int],
 	 @approverid int,
	 @approvedate char(10),
	 @flag                             integer output, 
	@msg                             varchar(80) output )

AS UPDATE [CptCheckStock] 

SET  [checkstatus]	 = '1',
        approverid = @approverid,
        approvedate = @approvedate

WHERE 
	( [id]	 = @id_1)

GO

/*盘点单删除*/
 CREATE PROCEDURE CptCheckStock_Delete 
	(@id_1 	[int],
	 @flag                             integer output, 
	 @msg                             varchar(80) output )

AS 
delete CptCheckStockList
where checkstockid=@id_1

DELETE [CptCheckStock] 

WHERE 
	( [id]	 = @id_1)

GO

/*盘点单新增*/
 CREATE PROCEDURE CptCheckStock_Insert 
	(@checkstockno_1 	[varchar](20),
	 @checkstockdesc_2 	[varchar](200),
	 @departmentid_3 	[int],
	 @location_4 	[varchar](200),
	 @checkerid_5 	[int],
	 @createdate_7 	[varchar](10),
	 @checkstatus_9 	[char](1),
	 @flag                             integer output, 
	 @msg                             varchar(80) output )

AS INSERT INTO [CptCheckStock] 
	 ( [checkstockno],
	 [checkstockdesc],
	 [departmentid],
	 [location],
	 [checkerid],
	 [createdate],
	 [checkstatus]) 
 
VALUES 
	( @checkstockno_1,
	 @checkstockdesc_2,
	 @departmentid_3,
	 @location_4,
	 @checkerid_5,
	 @createdate_7,
	 @checkstatus_9)
select max(id) from CptCheckStock

GO

/*2002-9-9*/

/*按id查找盘点单*/
 CREATE PROCEDURE CptCheckStock_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from CptCheckStock
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

/*盘点单更新*/
 CREATE PROCEDURE CptCheckStock_Update 
	(@id_1 	[int],
	 @checkstockno_2 	[varchar](20),
	 @checkstockdesc_3 	[varchar](200),
	@flag                             integer output, 
	@msg                             varchar(80) output )

AS UPDATE [CptCheckStock] 

SET  [checkstockno]	 = @checkstockno_2,
	 [checkstockdesc]	 = @checkstockdesc_3 

WHERE 
	( [id]	 = @id_1)

GO

/*折旧法一删除*/
 CREATE PROCEDURE CptDepreMethod1_Delete 
	(@id_1 	[int],
	@flag integer output,
	 @msg varchar(80) output)

AS DELETE [CptDepreMethod1] 

WHERE 
	( [id]	 = @id_1)

GO

/*折旧法一新增*/
 CREATE PROCEDURE CptDepreMethod1_Insert 
	(@name_1 	[varchar](60),
	 @description_2 	[varchar](200),
	 @depretype_3 	[char](1),
	 @timelimit_4 	[decimal](18,3),
	 @startunit_5 	[decimal](5,3),
	 @endunit_6 	[decimal](5,3),
	 @deprefunc_7 	[varchar](200),
	@flag integer output,
	 @msg varchar(80) output)
AS INSERT INTO [CptDepreMethod1] 
	 ( [name],
	 [description],
	 [depretype],
	 [timelimit],
	 [startunit],
	 [endunit],
	 [deprefunc]) 
 
VALUES 
	( @name_1,
	 @description_2,
	 @depretype_3,
	 @timelimit_4,
	 @startunit_5,
	 @endunit_6,
	 @deprefunc_7)
select max(id) from CptDepreMethod1

GO

/*按照类型查询折旧法一二*/
 CREATE PROCEDURE CptDepreMethod1_Select 
(@depretype		char(1),
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptDepreMethod1 where depretype = @depretype
  if @@error<>0 
begin set @flag=1 set @msg='查询折旧法成功' return end else begin set @flag=0 set @msg='查询折旧法失败' return end

GO

/*按照id查询折旧法一二*/
 CREATE PROCEDURE CptDepreMethod1_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
AS 
SELECT * FROM [CptDepreMethod1] 
WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'

GO

/*折旧法一更新*/
 CREATE PROCEDURE CptDepreMethod1_Update 
	(@id_1 	[int],
	 @name_2 	[varchar](60),
	 @description_3 	[varchar](200),
	 @depretype_4 	[char](1),
	 @timelimit_5 	[decimal](18,3),
	 @startunit_6 	[decimal](5,3),
	 @endunit_7 	[decimal](5,3),
	 @deprefunc_8 	[varchar](200),
	@flag integer output,
	 @msg varchar(80) output)

AS UPDATE [CptDepreMethod1] 

SET  [name]	 = @name_2,
	 [description]	 = @description_3,
	 [depretype]	 = @depretype_4,
	 [timelimit]	 = @timelimit_5,
	 [startunit]	 = @startunit_6,
	 [endunit]	 = @endunit_7,
	 [deprefunc]	 = @deprefunc_8 

WHERE 
	( [id]	 = @id_1)

GO

/*折旧法二删除(按照depreid)*/
 CREATE PROCEDURE CptDepreMethod2_DByDepreID 
	(@depreid_1 	[int],
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS DELETE [CptDepreMethod2] 

WHERE 
	( [depreid]	 = @depreid_1)

GO

/*折旧法二按照id删除*/
 CREATE PROCEDURE CptDepreMethod2_Delete 
	(@id_1 	[int],
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS DELETE [CptDepreMethod2] 

WHERE 
	( [id]	 = @id_1)

GO

/*折旧法二新增*/
 CREATE PROCEDURE CptDepreMethod2_Insert 
	(@depreid_1 	[int],
	 @time_2 	[decimal](9,3),
	 @depreunit_3 	[decimal](5,3),
	@flag                             integer output, 
@msg                             varchar(80) output )
AS INSERT INTO [CptDepreMethod2] 
	 ( [depreid],
	 [time],
	 [depreunit]) 
 
VALUES 
	( @depreid_1,
	 @time_2,
	 @depreunit_3)

GO

/*折旧法二查询*/
 CREATE PROCEDURE CptDepreMethod2_SByDepreID 
 (@depreid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
AS 
SELECT * FROM [CptDepreMethod2] 
WHERE  [depreid]	 = @depreid
order by  [time] 
set @flag = 1 set @msg = 'OK!'

GO

/*折旧法二更新*/
 CREATE PROCEDURE CptDepreMethod2_Update 
	(@id_1 	[int],
	 @depreid_2 	[int],
	 @time_3 	[decimal](9,3),
	 @depreunit_4 	[decimal](5,3),
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS UPDATE [CptDepreMethod2] 

SET  [depreid]	 = @depreid_2,
	 [time]	 = @time_3,
	 [depreunit]	 = @depreunit_4 

WHERE 
	( [id]	 = @id_1)

GO

/*查询所有折旧法*/
 CREATE PROCEDURE CptDepreMethod_Select 
(@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptDepreMethod1 order by depretype
  if @@error<>0 
begin set @flag=1 set @msg='查询折旧法成功' return end else begin set @flag=0 set @msg='查询折旧法失败' return end

GO

 CREATE PROCEDURE CptRelateWorkflow_Select 
	@flag integer output ,
 	@msg varchar(80) output 

AS select * from CptRelateWorkflow
set  @flag = 0 set  @msg = '操作成功完成'
GO

/*2002-8-15*/
/*搜索模板删除*/
 CREATE PROCEDURE CptSearchMould_Delete 
	(@id_1 	[int],
	@flag integer output,
	 @msg varchar(80) output)

AS DELETE [CptSearchMould] 

WHERE 
	( [id]	 = @id_1)

GO

/*搜索模板新增*/
 CREATE PROCEDURE CptSearchMould_Insert 
	(@mouldname_1 	[varchar](200),
	 @userid_2 	[int],
	 @mark_3 	[varchar](60),
	 @name_4 	[varchar](60),
	 @startdate_5 	[char](10),
	 @startdate1_6 	[char](10),
	 @enddate_7 	[char](10),
	 @enddate1_8 	[char](10),
	 @seclevel_9 	[tinyint],
	 @seclevel1_10 	[tinyint],
	 @departmentid_11 	[int],
	 @costcenterid_12 	[int],
	 @resourceid_13 	[int],
	 @currencyid_14 	[int],
	 @capitalcost_15 	[varchar](30),
	 @capitalcost1_16 	[varchar](30),
	 @startprice_17 	[varchar](30),
	 @startprice1_18 	[varchar](30),
	 @depreendprice_19 	[varchar](30),
	 @depreendprice1_20 	[varchar](30),
	 @capitalspec_21 	[varchar](60),
	 @capitallevel_22 	[varchar](30),
	 @manufacturer_23 	[varchar](100),
	 @manudate_24 	[char](10),
	 @manudate1_25 	[char](10),
	 @capitaltypeid_26 	[int],
	 @capitalgroupid_27 	[int],
	 @unitid_28 	[int],
	 @capitalnum_29 	[varchar](30),
	 @capitalnum1_30 	[varchar](30),
	 @currentnum_31 	[varchar](30),
	 @currentnum1_32 	[varchar](30),
	 @replacecapitalid_33 	[int],
	 @version_34 	[varchar](60),
	 @itemid_35 	[int],
	 @depremethod1_36 	[int],
	 @depremethod2_37 	[int],
	 @deprestartdate_38 	[char](10),
	 @deprestartdate1_39 	[char](10),
	 @depreenddate_40 	[char](10),
	 @depreenddate1_41 	[char](10),
	 @customerid_42 	[int],
	 @attribute_43 	char(1),
	 @stateid_44 	[int],
	 @location_45 	[varchar](100),
	@isdata		[char](1),
	@counttype	[char](1),
	@isinner	[char](1),
	@flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CptSearchMould] 
	 ( [mouldname],
	 [userid],
	 [mark],
	 [name],
	 [startdate],
	 [startdate1],
	 [enddate],
	 [enddate1],
	 [seclevel],
	 [seclevel1],
	 [departmentid],
	 [costcenterid],
	 [resourceid],
	 [currencyid],
	 [capitalcost],
	 [capitalcost1],
	 [startprice],
	 [startprice1],
	 [depreendprice],
	 [depreendprice1],
	 [capitalspec],
	 [capitallevel],
	 [manufacturer],
	 [manudate],
	 [manudate1],
	 [capitaltypeid],
	 [capitalgroupid],
	 [unitid],
	 [capitalnum],
	 [capitalnum1],
	 [currentnum],
	 [currentnum1],
	 [replacecapitalid],
	 [version],
	 [itemid],
	 [depremethod1],
	 [depremethod2],
	 [deprestartdate],
	 [deprestartdate1],
	 [depreenddate],
	 [depreenddate1],
	 [customerid],
	 [attribute],
	 [stateid],
	 [location],
	[isdata],
	[counttype],
	[isinner]) 
 
VALUES 
	( @mouldname_1,
	 @userid_2,
	 @mark_3,
	 @name_4,
	 @startdate_5,
	 @startdate1_6,
	 @enddate_7,
	 @enddate1_8,
	 @seclevel_9,
	 @seclevel1_10,
	 @departmentid_11,
	 @costcenterid_12,
	 @resourceid_13,
	 @currencyid_14,
	 @capitalcost_15,
	 @capitalcost1_16,
	 @startprice_17,
	 @startprice1_18,
	 @depreendprice_19,
	 @depreendprice1_20,
	 @capitalspec_21,
	 @capitallevel_22,
	 @manufacturer_23,
	 @manudate_24,
	 @manudate1_25,
	 @capitaltypeid_26,
	 @capitalgroupid_27,
	 @unitid_28,
	 @capitalnum_29,
	 @capitalnum1_30,
	 @currentnum_31,
	 @currentnum1_32,
	 @replacecapitalid_33,
	 @version_34,
	 @itemid_35,
	 @depremethod1_36,
	 @depremethod2_37,
	 @deprestartdate_38,
	 @deprestartdate1_39,
	 @depreenddate_40,
	 @depreenddate1_41,
	 @customerid_42,
	 @attribute_43,
	 @stateid_44,
	 @location_45,
	 @isdata,
	 @counttype,
	 @isinner)
select max(id) from CptSearchMould
GO

/*按照id查询模板*/
 CREATE PROCEDURE CptSearchMould_SelectByID 
(@id_1 	[int], 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptSearchMould where id = @id_1
 if @@error<>0 begin set @flag=1 set @msg='查询信息成功' return end else begin set @flag=0 set @msg='查询信息失败' return end

GO

/*按照用户id查询模板*/
 CREATE PROCEDURE CptSearchMould_SelectByUserID 
(@userid_1 	[int], 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from CptSearchMould 
where userid = @userid_1

GO

/*搜索模板更新*/
 CREATE PROCEDURE CptSearchMould_Update 
	(@id_1 	[int],
	 @userid_2 	[int],
	 @mark_3 	[varchar](60),
	 @name_4 	[varchar](60),
	 @startdate_5 	[char](10),
	 @startdate1_6 	[char](10),
	 @enddate_7 	[char](10),
	 @enddate1_8 	[char](10),
	 @seclevel_9 	[tinyint],
	 @seclevel1_10 	[tinyint],
	 @departmentid_11 	[int],
	 @costcenterid_12 	[int],
	 @resourceid_13 	[int],
	 @currencyid_14 	[int],
	 @capitalcost_15 	[varchar](30),
	 @capitalcost1_16 	[varchar](30),
	 @startprice_17 	[varchar](30),
	 @startprice1_18 	[varchar](30),
	 @depreendprice_19 	[varchar](30),
	 @depreendprice1_20 	[varchar](30),
	 @capitalspec_21 	[varchar](60),
	 @capitallevel_22 	[varchar](30),
	 @manufacturer_23 	[varchar](100),
	 @manudate_24 	[char](10),
	 @manudate1_25 	[char](10),
	 @capitaltypeid_26 	[int],
	 @capitalgroupid_27 	[int],
	 @unitid_28 	[int],
	 @capitalnum_29 	[varchar](30),
	 @capitalnum1_30 	[varchar](30),
	 @currentnum_31 	[varchar](30),
	 @currentnum1_32 	[varchar](30),
	 @replacecapitalid_33 	[int],
	 @version_34 	[varchar](60),
	 @itemid_35 	[int],
	 @depremethod1_36 	[int],
	 @depremethod2_37 	[int],
	 @deprestartdate_38 	[char](10),
	 @deprestartdate1_39 	[char](10),
	 @depreenddate_40 	[char](10),
	 @depreenddate1_41 	[char](10),
	 @customerid_42 	[int],
	 @attribute_43 	char(1),
	 @stateid_44 	[int],
	 @location_45 	[varchar](100),
	@isdata		[char](1),
            @counttype	[char](1),
	@isinner	[char](1),
	@flag integer output,
	 @msg varchar(80) output)

AS UPDATE [CptSearchMould] 

SET  [userid]	 = @userid_2,
	 [mark]	 = @mark_3,
	 [name]	 = @name_4,
	 [startdate]	 = @startdate_5,
	 [startdate1]	 = @startdate1_6,
	 [enddate]	 = @enddate_7,
	 [enddate1]	 = @enddate1_8,
	 [seclevel]	 = @seclevel_9,
	 [seclevel1]	 = @seclevel1_10,
	 [departmentid]	 = @departmentid_11,
	 [costcenterid]	 = @costcenterid_12,
	 [resourceid]	 = @resourceid_13,
	 [currencyid]	 = @currencyid_14,
	 [capitalcost]	 = @capitalcost_15,
	 [capitalcost1]	 = @capitalcost1_16,
	 [startprice]	 = @startprice_17,
	 [startprice1]	 = @startprice1_18,
	 [depreendprice]	 = @depreendprice_19,
	 [depreendprice1]	 = @depreendprice1_20,
	 [capitalspec]	 = @capitalspec_21,
	 [capitallevel]	 = @capitallevel_22,
	 [manufacturer]	 = @manufacturer_23,
	 [manudate]	 = @manudate_24,
	 [manudate1]	 = @manudate1_25,
	 [capitaltypeid]	 = @capitaltypeid_26,
	 [capitalgroupid]	 = @capitalgroupid_27,
	 [unitid]	 = @unitid_28,
	 [capitalnum]	 = @capitalnum_29,
	 [capitalnum1]	 = @capitalnum1_30,
	 [currentnum]	 = @currentnum_31,
	 [currentnum1]	 = @currentnum1_32,
	 [replacecapitalid]	 = @replacecapitalid_33,
	 [version]	 = @version_34,
	 [itemid]	 = @itemid_35,
	 [depremethod1]	 = @depremethod1_36,
	 [depremethod2]	 = @depremethod2_37,
	 [deprestartdate]	 = @deprestartdate_38,
	 [deprestartdate1]	 = @deprestartdate1_39,
	 [depreenddate]	 = @depreenddate_40,
	 [depreenddate1]	 = @depreenddate1_41,
	 [customerid]	 = @customerid_42,
	 [attribute]	 = @attribute_43,
	 [stateid]	 = @stateid_44,
	 [location]	 = @location_45 ,
	[isdata]		= @isdata,
	[counttype]	= @counttype,
	[isinner]		= @isinner

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE CptShareDetail_DeleteByCptId 
	(@cptid 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [CptShareDetail] 

WHERE 
	( [cptid]	 = @cptid)


GO

/*2002-11-19*/
 CREATE PROCEDURE CptShareDetail_DeleteByUserId 
	(@userid 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [CptShareDetail] 

WHERE 
	( [userid]	 = @userid  and usertype = '1' )


GO

/*2002-11-18*/

 CREATE PROCEDURE CptShareDetail_Insert 
	(@capitalid 	[int],
              @userid 	[int],
	 @usertype 	[int],
	 @sharelevel 	[int] ,      
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [CptShareDetail] 
	 ( [cptid],	 [userid] ,
	 [usertype],
	 [sharelevel]
 	) 
 
VALUES 
	( @capitalid,@userid,
	 @usertype,
	 @sharelevel
	)

GO

/*资产流转表盘盈亏信息添加*/
 CREATE PROCEDURE CptUseLogCheckStock_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @realnum	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS 

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	@usestatus_10,
	 @remark_11)

update CptCapital
set capitalnum = @realnum 
where id = @capitalid_1

GO

/*资产流转表盘盈亏信息更新*/
 CREATE PROCEDURE CptUseLogCheckStock_Update 
	(@capitalid_1 	[int],
	 @userequest_2 	[int],
	 @usestatus_3 	[varchar](2),
	 @usecount_4 	[int],
	 @fee		[decimal](18,3),
	 @realnum	[int],
	 @remark           text,
	 @flag integer output ,
 	 @msg varchar(80) output)

AS UPDATE [CptUseLog] 

SET  [usecount]	 = @usecount_4,
	[fee] = @fee,
	 [usestatus]	 = @usestatus_3,
             remark = @remark
	 

WHERE 
	( [capitalid]	 = @capitalid_1 AND
	 [userequest]	 = @userequest_2 AND
	 ([usestatus]	 = '-1' or
	  [usestatus]	 = '-2'))

update CptCapital
set capitalnum = @realnum 
where id = @capitalid_1

GO

/*资产流程新增:资产报废*/
 CREATE PROCEDURE CptUseLogDiscard_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	varchar(2),
	 @remark_11 	[text],
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '5',
	 @remark_11)

Update CptCapital
Set 
departmentid = null,
costcenterid = null,
resourceid   = null,
location	     =  null,
stateid = @usestatus_10
where id = @capitalid_1

GO

/*资产流程新增:资产移交*/
 CREATE PROCEDURE CptUseLogHandOver_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @costcenterid   [int],
	 @flag integer output,
	 @msg varchar(80) output)

AS 

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '-6',
	 @remark_11)

Update CptCapital
	Set 
	location = @useaddress_6,
	departmentid = @usedeptid_3,
	costcenterid = @costcenterid,
	resourceid   = @useresourceid_4,
	stateid = @usestatus_10
	where id = @capitalid_1

GO

/*资产流程新增:资产入库*/
 CREATE PROCEDURE CptUseLogInStock2_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	  @usecount_5 	[int],
	  @userequest_7  [int],
	 @remark_11 	[text],
	 @flag integer output,
	 @msg varchar(80) output)

AS 
declare @departmentid  int,@resourceid int,@location varchar(100),@num int

select 	@departmentid 	=departmentid,
	@resourceid	=resourceid,
	@location	=location,
	@num		=capitalnum
from CptCapital 
where id = @capitalid_1

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @departmentid,
	 @resourceid,
	 @usecount_5,
	 @location,
	 @userequest_7,
	 '',
	 0,
	 '1',
	 @remark_11)

Update CptCapital
Set
	capitalnum = @num+@usecount_5
where id = @capitalid_1

GO

 CREATE PROCEDURE CptUseLogInStock_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @checkerid 	[int],
	 @usecount_5 	[decimal](18,3),
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 [varchar](100),
	 @fee_9 			[decimal](18,3),
	 @usestatus_10 		[varchar](2),
	 @remark_11 		[text],
	 @mark				[varchar](60),
	 @datatype			[int],
	 @startdate			[char](10),
	 @enddate			[char](10),
	 @deprestartdate	[char](10),
	 @depreenddate		[char](10),
	 @manudate			[char](10),
	 @lastmoderid		[int],
	 @lastmoddate		[char](10),
	 @lastmodtime    	[char](8),
	 @inprice		[decimal](18,3),
	 @crmid		[int],
	 @counttype		[char](1),
	 @isinner		[char](1),
	 @flag integer output,
	 @msg varchar(80) output)

AS
if @usestatus_10='2'
begin
	 INSERT INTO [CptUseLog] 
		 ( [capitalid],
		 [usedate],
		 [usedeptid],
		 [useresourceid],
		 [usecount],
		 [useaddress],
		 [userequest],
		 [maintaincompany],
		 [fee],
		 [usestatus],
		 [remark]) 
	 
	VALUES 
		( @capitalid_1,
		 @usedate_2,
		 @usedeptid_3,
		 @checkerid,
		 @usecount_5,
		 @useaddress_6,
		 @userequest_7,
		 @maintaincompany_8,
		 @fee_9,
		'1',
		 @remark_11)
end

 INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	@usestatus_10,
	 @remark_11)

declare @num decimal(18,3)
select @num=capitalnum from CptCapital where id = @capitalid_1

if @usestatus_10 = '1'
begin
    set @useresourceid_4 = 0
end

if @usedeptid_3 = 0 
begin
set @usedeptid_3 = null 
end

Update CptCapital
Set 
mark = @mark,
capitalnum = @usecount_5+@num,
location = @useaddress_6,
departmentid = @usedeptid_3,
resourceid   = @useresourceid_4,
stateid = @usestatus_10,
datatype = @datatype,
isdata = '2',
startdate = @startdate,
enddate = @enddate,
deprestartdate = @deprestartdate,
depreenddate = @depreenddate,
manudate = @manudate,
[lastmoderid] = @lastmoderid,
[lastmoddate] = @lastmoddate,
[lastmodtime] = @lastmodtime,
[startprice]  = @inprice,
[customerid]		  =	@crmid,
[counttype]    = @counttype,
[isinner]     = @isinner
where id = @capitalid_1

GO

/*资产流程新增:资产租借*/
 CREATE PROCEDURE CptUseLogLend_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @costcenterid   [int],
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '3',
	 @remark_11)

Update CptCapital
Set 
departmentid = null,
costcenterid = null,
resourceid   = null,
location	     =  @useaddress_6,
stateid = @usestatus_10,
crmid = @useresourceid_4
where id = @capitalid_1

GO

/*资产流程新增:资产损失*/
 CREATE PROCEDURE CptUseLogLoss_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @costcenterid   [int],
	 @sptcount	[char](1),
	 @flag integer output,
	 @msg varchar(80) output)

AS 
declare @num int
/*判断数量是否足够(对于非单独核算的资产*/
if @sptcount<>'1'
begin
   select @num=capitalnum  from CptCapital where id = @capitalid_1
   if @num<@usecount_5
   begin
	select -1
	return
   end
   else
   begin
	select @num = @num-@usecount_5
   end
end

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '-7',
	 @remark_11)
/*单独核算的资产*/
if @sptcount='1'
begin
      if @usestatus_10='5'
      begin
	Update CptCapital
	Set 
	departmentid=null,
	costcenterid=null,
	resourceid=null,
	stateid = @usestatus_10
	where id = @capitalid_1
      end	
      else
      begin	 
	Update CptCapital
	Set 
	stateid = @usestatus_10
	where id = @capitalid_1
       end
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num
	where id = @capitalid_1
end

select 1

GO

/*资产流程新增:资产维修*/
 CREATE PROCEDURE CptUseLogMend_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @flag integer output,
	 @msg varchar(80) output)

AS 

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '4',
	 @remark_11)

Update CptCapital
	Set 
	stateid = @usestatus_10
	where id = @capitalid_1

GO

/*资产流程新增:资产调出*/
 CREATE PROCEDURE CptUseLogMoveOut_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @costcenterid   [int],
	 @flag integer output,
	 @msg varchar(80) output)

AS 
declare @num int
/*判断数量是否足够(对于非单独核算的资产*/
   select @num=capitalnum  from CptCapital where id = @capitalid_1
   if @num<@usecount_5
   begin
	select -1
	return
   end
   else
   begin
	select @num = @num-@usecount_5
   end

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '-5',
	 @remark_11)

Update CptCapital
Set
capitalnum = @num
where id = @capitalid_1

select 1

GO

/*资产流程新增:资产调拨*/
 CREATE PROCEDURE CptUseLogMove_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
     @departmentid   [int],
     @costcenterid   [int],
	 @resourceid      [int],
	 @usecount_5 	decimal(18,3),
	 @userequest_7  [int],
	 @location	[varchar](200),
	 @fee	     [decimal](18,3),
	 @remark_11 	[text],
	 @olddepartmentid [int],
	 @flag integer output,
	 @msg varchar(80) output)
AS 

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark],
	 [olddeptid]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @departmentid,
	 @resourceid,
	 1,
	 @location,
	 @userequest_7,
	 '',
	 @fee,
	 '-4',
	 @remark_11,
	 @olddepartmentid)

Update CptCapital
Set
	departmentid = @departmentid,
	costcenterid = @costcenterid,
	resourceid    = @resourceid,
	stateid = '2'
where id = @capitalid_1
GO

/*资产流程新增:其它状态流程*/
 CREATE PROCEDURE CptUseLogOther_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @costcenterid   [int],
	 @sptcount	[char](1),
	 @flag integer output,
	 @msg varchar(80) output)

AS 
declare @num int
/*判断数量是否足够(对于非单独核算的资产*/
if @sptcount<>'1'
begin
   select @num=capitalnum  from CptCapital where id = @capitalid_1
   if @num<@usecount_5
   begin
	select -1
	return
   end
   else
   begin
	select @num = @num-@usecount_5
   end
end

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 @usestatus_10,
	 @remark_11)
/*单独核算的资产*/
if @sptcount='1'
begin
	Update CptCapital
	Set 
	location = @useaddress_6,
	departmentid = @usedeptid_3,
	costcenterid = @costcenterid,
	resourceid   = @useresourceid_4,
	stateid = @usestatus_10
	where id = @capitalid_1
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num
	where id = @capitalid_1
end

select 1

GO

/*资产流程新增:资产归还*/
 CREATE PROCEDURE CptUseLogReturn_Insert 
	(@capitalid_1 	   [int],
	 @usedate		   [char](10),
	 @resourceid 	   [int],
	 @todepartmentid   [int],
	 @costcenterid 	   [int],
	 @fromdepartmentid [int],
	 @capitalnum	   [decimal](18,3),
	 @relatereq 	   [int],
	 @sptcount		   [char](1),
	 @flag integer output,
	 @msg varchar(80) output)

AS 

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark],
	 [olddeptid]) 
 
VALUES 
	( @capitalid_1,
	 @usedate,
	 @todepartmentid,
	 @resourceid,
	 @capitalnum,
	 '',
	 @relatereq,
	 '',
	 0,
	 '0',
	 '',
	 @fromdepartmentid)
/*使用中的资产归还*/
declare @id int,@num decimal(18,3)
/*非单独核算的资产*/
if @sptcount <> '1'
begin
	select @id=id,@num=capitalnum from CptCapital where isdata='2' and 
	datatype in (select datatype from CptCapital where id = @capitalid_1) and departmentid = @todepartmentid
	if @id<>''
	begin
	Update CptCapital
	Set
	capitalnum = @num+@capitalnum,
	stateid = '1'
	where id = @id
	delete from CptCapital where id = @capitalid_1
	end
	else
	begin
	Update CptCapital
	Set
	departmentid = @todepartmentid,
	costcenterid = @costcenterid,
	resourceid   = @resourceid,
	stateid		 = '1'
	where id = @capitalid_1
	end
end
else
begin
	Update CptCapital
	Set
	departmentid = @todepartmentid,
	costcenterid = @costcenterid,
	resourceid   = @resourceid,
	stateid		 = '1'
	where id = @capitalid_1
end
GO

/*资产流程新增:资产领用*/
 CREATE PROCEDURE CptUseLogUse_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	decimal(18,3),
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @costcenterid   int,
	 @sptcount	[char](1),
	 @flag integer output,
	 @msg varchar(80) output)

AS 
declare @num decimal(18,3)
/*判断数量是否足够(对于非单独核算的资产*/
if @sptcount<>'1'
begin
   select @num=capitalnum  from CptCapital where id = @capitalid_1
   if @num<@usecount_5
   begin
	select -1
	return
   end
   else
   begin
	select @num = @num-@usecount_5
   end
end

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark],
	 [olddeptid]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '2',
	 @remark_11,
              0)
/*单独核算的资产*/
if @sptcount='1'
begin
	Update CptCapital
	Set 
	location = @useaddress_6,
	departmentid = @usedeptid_3,
	costcenterid = @costcenterid,
	resourceid   = @useresourceid_4,
	stateid = @usestatus_10
	where id = @capitalid_1
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num
	where id = @capitalid_1
end

select 1
GO

/*查询资产l流转情况*/
 CREATE PROCEDURE CptUseLog_SelectByCapitalID 
	@capitalid int,
	@flag integer output ,
 	@msg varchar(80) output 

AS select * from CptUseLog 
where capitalid = @capitalid
set  @flag = 0 set  @msg = '操作成功完成'

GO

/*按照id查询资产流转情况*/
 CREATE PROCEDURE CptUseLog_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from CptUseLog
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE CrmShareDetail_DByCrmId 
	(@crmid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS DELETE [CrmShareDetail] 
WHERE 
	( [crmid]	 = @crmid_1)

GO

 CREATE PROCEDURE CrmShareDetail_DByUserId 
	(@userid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS DELETE [CrmShareDetail] 
WHERE 
	( [userid]	 = @userid_1  and usertype = '1' )

GO

 CREATE PROCEDURE CrmShareDetail_Insert 
	(@crmid_1 	[int],
	 @userid_2 	[int],
	 @usertype_3 	[int],
	 @sharelevel_4 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS INSERT INTO [CrmShareDetail] 
	 ( [crmid],
	 [userid],
	 [usertype],
	 [sharelevel]) 
VALUES 
	( @crmid_1,
	 @userid_2,
	 @usertype_3,
	 @sharelevel_4)

GO

 CREATE PROCEDURE CrmShareDetail_SByCrmId 
	(@crmid_1 int ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS 
select * from CrmShareDetail where crmid = @crmid_1 

GO

 CREATE PROCEDURE CrmShareDetail_SByResourceId 
	(@resourceid_1 int ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS 
select crmid , sharelevel from CrmShareDetail where userid = @resourceid_1 and usertype = '1'  

GO

 CREATE PROCEDURE DocApproveRemark_Insert 
	@docid		int,
	@approveremark      varchar(2000),
	@approverid     int,
	@approvedate    char(10),
	@approvetime    char(8),
	@isapprover      char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into docApproveRemark (docid,approveremark,approverid,approvedate,approvetime,isapprover)
	values(@docid,@approveremark,@approverid,@approvedate,@approvetime,@isapprover)

GO

 CREATE PROCEDURE DocApproveRemark_SelectByDocid 
	@docid		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from docapproveremark where docid=@docid

GO

/****************************2002-12-11 18:13*******************************/
 CREATE PROCEDURE DocDetailLog_SRead 
	@docid  int,
	@userid int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from DocDetailLog where ((operatetype='0' and operateuserid=@userid) or doccreater=@userid )
	and docid=@docid

GO

/*2002-9-20 11:30*/

 CREATE PROCEDURE DocDetail_Approve 
	@approverid		int,
	@docstatus      char(1),
	@approvedate    char(10),
	@approvetime    char(8),
	@docid          int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	update DocDetail set docstatus=@docstatus,docapproveuserid=@approverid,docapprovedate=@approvedate,docapprovetime=@approvetime where id=@docid 

GO

 CREATE PROCEDURE DocDetail_SCountByResource 
(@id_1 	[int],
 @id_2  [int],
 @flag  integer output,
 @msg  varchar(80) output ) 
AS select count(hrmresid) from DocDetail t1, DocUserView t2 where hrmresid = @id_1 and t2.userid=@id_2 and t1.id=t2.docid  if @@error<>0 begin set @flag=1 set @msg='查询人力资源文档总数信息成功' return end else begin set @flag=0 set @msg='查询人力资源文档总数信息失败' return end 

GO

 CREATE PROCEDURE DocDetail_SelectByCreater 
	(@resourceid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
select distinct id from DocDetail where doccreaterid = @resourceid_1 or ownerid = @resourceid_1

GO

 CREATE PROCEDURE DocDetail_SelectByOwner 
	(@resourceid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
select distinct id from DocDetail where  ownerid = @resourceid_1

GO

 CREATE PROCEDURE DocDetail_SelectCountByCapital 
(@id_1 	[int], @flag                             integer output, 
@msg                             varchar(80) output )
 AS
 select count(*) from DocDetail where assetid = @id_1
GO

 CREATE PROCEDURE DocDetail_SelectCountByItem 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select count(*) from DocDetail where itemid = @id_1 
GO

 CREATE PROCEDURE DocDetail_SelectCountByOwner 
	(@id_1 	[int], 
	@flag    integer output, 
	@msg   varchar(80) output )
AS 
	select count(*) from DocDetail where ownerid = @id_1 

GO

 CREATE PROCEDURE DocDetail_SCountByResource2 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select count(*) from DocDetail where doccreaterid = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源文档总数信息成功' return end else begin set @flag=0 set @msg='查询人力资源文档总数信息失败' return end 
GO

 CREATE PROCEDURE DocDetail_SelectCrmCountByCrm 
(@id_1 	[int],
 @id_2 [int],
 @flag  integer output,
 @msg  varchar(80) output ) 
AS select count(crmid) from DocDetail t1, DocUserView t2 where t1.crmid = @id_1 and t2.userid=@id_2 and t2.docid=t1.id  if @@error<>0 begin set @flag=1 set @msg='查询人力资源文档总数信息成功' return end else begin set @flag=0 set @msg='查询人力资源文档总数信息失败' return end 

GO

 CREATE PROCEDURE DocDetail_SProCountByProjID 
(@id_1 	[int],
 @id_2 [int],
 @flag  integer output,
 @msg  varchar(80) output ) 
AS select count(projectid) from DocDetail t1, DocUserView t2 where t1.projectid = @id_1 and t2.userid=@id_2 and t2.docid=t1.id  if @@error<>0 begin set @flag=1 set @msg='查询人力资源文档总数信息成功' return end else begin set @flag=0 set @msg='查询人力资源文档总数信息失败' return end 

GO

 CREATE PROCEDURE DocFrontpage_ALLCount 
(
@logintype		int,
@usertype		int,
@userid			int,
@userseclevel	int,
@flag integer output,
@msg varchar(80) output)
as
if @logintype=1 
begin
Select count(distinct n.id ) countnew from DocDetail n INNER JOIN DocShareDetail d ON n.id=d.docid where d.userid=@userid and d.usertype = 1 and  (n.docpublishtype='2' or n.docpublishtype='3') and n.docstatus in('1','2','5')
end
else
  begin 
  Select count(distinct n.id ) countnew from DocDetail n INNER JOIN DocShareDetail d ON n.id=d.docid where  d.usertype=@usertype and d.userid<=@userseclevel and (n.docpublishtype='2' or n.docpublishtype='3') and n.docstatus in('1','2','5')
end

GO

 CREATE PROCEDURE DocFrontpage_Delete 
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [DocFrontpage] 

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE DocFrontpage_Insert 
	(@frontpagename_1 	[varchar](200),
	 @frontpagedesc_2 	[varchar](200),
	 @isactive_3 	[char](1),
	 @departmentid_4 	[int],
	 @linktype_5 	[varchar](2),
	 @hasdocsubject_6 	[char](1),
	 @hasfrontpagelist_7 	[char](1),
	 @newsperpage_8 	[tinyint],
	 @titlesperpage_9 	[tinyint],
	 @defnewspicid_10 	[int],
	 @backgroundpicid_11 	[int],
	 @importdocid_12 	[int],
	 @headerdocid_13 	[int],
	 @footerdocid_14 	[int],
	 @secopt_15 	[varchar](2),
	 @seclevelopt_16 	[tinyint],
	 @departmentopt_17 	[int],
	 @dateopt_18 	[int],
	 @languageopt_19 	[int],
	 @clauseopt_20 	[text],
	 @newsclause_21 	[text],
	 @languageid_22 	[int],
	 @publishtype_23 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [DocFrontpage] 
	 ( [frontpagename],
	 [frontpagedesc],
	 [isactive],
	 [departmentid],
	 [linktype],
	 [hasdocsubject],
	 [hasfrontpagelist],
	 [newsperpage],
	 [titlesperpage],
	 [defnewspicid],
	 [backgroundpicid],
	 [importdocid],
	 [headerdocid],
	 [footerdocid],
	 [secopt],
	 [seclevelopt],
	 [departmentopt],
	 [dateopt],
	 [languageopt],
	 [clauseopt],
	 [newsclause],
	 [languageid],
	 [publishtype]) 
 
VALUES 
	( @frontpagename_1,
	 @frontpagedesc_2,
	 @isactive_3,
	 @departmentid_4,
	 @linktype_5,
	 @hasdocsubject_6,
	 @hasfrontpagelist_7,
	 @newsperpage_8,
	 @titlesperpage_9,
	 @defnewspicid_10,
	 @backgroundpicid_11,
	 @importdocid_12,
	 @headerdocid_13,
	 @footerdocid_14,
	 @secopt_15,
	 @seclevelopt_16,
	 @departmentopt_17,
	 @dateopt_18,
	 @languageopt_19,
	 @clauseopt_20,
	 @newsclause_21,
	 @languageid_22,
	 @publishtype_23)

select max(id) from DocFrontpage
GO

 CREATE PROCEDURE DocFrontpage_SelectAll 
	(@flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
select * from DocFrontpage order by id

GO









/*****right**********/
 CREATE PROCEDURE DocFrontpage_SelectAllId 
(
@pagenumber     int,
@perpage        int,
@countnumber    int,
@logintype		int,
@usertype		int,
@userid			int,
@userseclevel	int,
@flag integer output,
@msg varchar(80) output)
as
declare @pagecount int 
declare @pagecount2 int 
set @pagecount =  @pagenumber*@perpage

if (@countnumber-(@pagenumber-1)*@perpage)<@perpage       					
set @pagecount2 =@countnumber-(@pagenumber-1)*@perpage
else 
set @pagecount2 =@perpage 

if @logintype=1 
begin
exec('Select distinct top '+@pagecount+' n.id, n.docsubject , n.doccreatedate , n.doccreatetime into #temp from DocDetail n INNER JOIN DocShareDetail d ON n.id=d.docid where d.userid='+@userid+' and d.usertype = 1 and  (n.docpublishtype=''2'' or n.docpublishtype=''3'') and n.docstatus in(''1'',''2'',''5'') order by n.doccreatedate desc , n.doccreatetime desc ;'+
'select top '+@pagecount2+' * from #temp order by doccreatedate, doccreatetime')
end
if @logintype<>1
begin
  exec ('Select distinct top '+@pagecount+' n.id , n.docsubject , n.doccreatedate , n.doccreatetime into #temp from DocDetail n INNER JOIN DocShareDetail d ON n.id=d.docid where  d.usertype='+@usertype+' and d.userid<='+@userseclevel+' and (n.docpublishtype=''2'' or n.docpublishtype=''3'') and n.docstatus in(''1'',''2'',''5'') order by n.doccreatedate desc, n.doccreatetime desc ;'+
 'select top '+@pagecount2+' * from #temp order by doccreatedate, doccreatetime')
end


GO

 CREATE PROCEDURE DocFrontpage_SelectByid 
	(@id_1  integer ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
select * from DocFrontpage where id = @id_1

GO

 CREATE PROCEDURE DocFrontpage_SelectDefID 
	(@usertype 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS 
select min(id) from DocFrontpage where publishtype = @usertype

GO

 CREATE PROCEDURE DocFrontpage_Update 
	(@id_1 	[int],
	 @frontpagename_2 	[varchar](200),
	 @frontpagedesc_3 	[varchar](200),
	 @isactive_4 	[char](1),
	 @departmentid_5 	[int],
	 @hasdocsubject_7 	[char](1),
	 @hasfrontpagelist_8 	[char](1),
	 @newsperpage_9 	[tinyint],
	 @titlesperpage_10 	[tinyint],
	 @defnewspicid_11 	[int],
	 @backgroundpicid_12 	[int],
	 @importdocid_13 	[int],
	 @headerdocid_14 	[int],
	 @footerdocid_15 	[int],
	 @secopt_16 	[varchar](2),
	 @seclevelopt_17 	[tinyint],
	 @departmentopt_18 	[int],
	 @dateopt_19 	[int],
	 @languageopt_20 	[int],
	 @clauseopt_21 	[text],
	 @newsclause_22 	[text],
	 @languageid_23 	[int],
	 @publishtype_24 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS UPDATE [DocFrontpage] 

SET  [frontpagename]	 = @frontpagename_2,
	 [frontpagedesc]	 = @frontpagedesc_3,
	 [isactive]	 = @isactive_4,
	 [departmentid]	 = @departmentid_5,
	 [hasdocsubject]	 = @hasdocsubject_7,
	 [hasfrontpagelist]	 = @hasfrontpagelist_8,
	 [newsperpage]	 = @newsperpage_9,
	 [titlesperpage]	 = @titlesperpage_10,
	 [defnewspicid]	 = @defnewspicid_11,
	 [backgroundpicid]	 = @backgroundpicid_12,
	 [importdocid]	 = @importdocid_13,
	 [headerdocid]	 = @headerdocid_14,
	 [footerdocid]	 = @footerdocid_15,
	 [secopt]	 = @secopt_16,
	 [seclevelopt]	 = @seclevelopt_17,
	 [departmentopt]	 = @departmentopt_18,
	 [dateopt]	 = @dateopt_19,
	 [languageopt]	 = @languageopt_20,
	 [clauseopt]	 = @clauseopt_21,
	 [newsclause]	 = @newsclause_22,
	 [languageid]	 = @languageid_23,
	 [publishtype]	 = @publishtype_24 

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE DocPicUpload_Delete 
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [DocPicUpload] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE DocPicUpload_Insert 
	(@picname_1 	[varchar](200),
	 @pictype_2 	[char](1),
	 @imagefilename_3 	[varchar](200),
	 @imagefileid_4 	[int],
	 @imagefilewidth_5 	[smallint],
	 @imagefileheight_6 	[smallint],
	 @imagefilesize_7 	[int],
	 @imagefilescale_8 	[real] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [DocPicUpload] 
	 ( [picname],
	 [pictype],
	 [imagefilename],
	 [imagefileid],
	 [imagefilewidth],
	 [imagefileheight],
	 [imagefilesize],
	 [imagefilescale]) 
 
VALUES 
	( @picname_1,
	 @pictype_2,
	 @imagefilename_3,
	 @imagefileid_4,
	 @imagefilewidth_5,
	 @imagefileheight_6,
	 @imagefilesize_7,
	 @imagefilescale_8)
select max(id) from DocPicUpload

GO

 CREATE PROCEDURE DocPicUpload_SelectAll 
	(@flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS 
select * from DocPicUpload 

GO

 CREATE PROCEDURE DocPicUpload_SelectByID 
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS 
select * from DocPicUpload where id= @id_1

GO

 CREATE PROCEDURE DocPicUpload_Update 
	(@id_1 	[int],
	 @picname_2 	[varchar](200),
	 @pictype_3 	[char](1),
	 @imagefilename_4 	[varchar](200),
	 @imagefileid_5 	[int],
	 @imagefilewidth_6 	[smallint],
	 @imagefileheight_7 	[smallint],
	 @imagefilesize_8 	[int],
	 @imagefilescale_9 	[real],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS UPDATE [DocPicUpload] 

SET  [picname]	 = @picname_2,
	 [pictype]	 = @pictype_3,
	 [imagefilename]	 = @imagefilename_4,
	 [imagefileid]	 = @imagefileid_5,
	 [imagefilewidth]	 = @imagefilewidth_6,
	 [imagefileheight]	 = @imagefileheight_7,
	 [imagefilesize]	 = @imagefilesize_8,
	 [imagefilescale]	 = @imagefilescale_9 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE DocReadRpSum 
  @fromdate	varchar(10),
  @todate	varchar(10),
  @userid       int,
  @flag	int output, 
  @msg 	varchar(80) output
  AS declare
  @docid	int,
  @acount int,
  @doccreaterid int,
  @docdepartmentid int,
  @maincategory int 
  create table #temp( docid  int , acount  int, doccreaterid	int, docdepartmentid	int, maincategory	int )
  
  if @fromdate<>'0' and @todate <>'0'
  begin declare docid_cursor cursor for 
  select top 50 count(t3.id) result,t1.docid resultid from DocDetailLog as t1,DocShareDetail as t2 ,DocDetail as t3 
  where t2.usertype=1 and operatetype='0' and operatedate > @fromdate and operatedate<@todate and t1.docid=t2.docid and t1.docid=t3.id and t2.userid=@userid
  group by t1.docid order by result desc 
  end 

  if @fromdate='0' and @todate <>'0' 
  begin declare docid_cursor cursor for 
  select top 50 count(t3.id) result,t1.docid resultid from DocDetailLog as t1,DocShareDetail as t2  ,DocDetail as t3 
  where t2.usertype=1 and  operatetype='0' and operatedate<@todate and t1.docid=t2.docid  and t1.docid=t3.id and t2.userid=@userid
  group by t1.docid order by result desc 
  end 

  if @fromdate<>'0' and @todate ='0' 
  begin declare docid_cursor cursor for 
  select top 50 count(t3.id) result,t1.docid resultid from DocDetailLog as t1,DocShareDetail as t2 ,DocDetail as t3 
  where  t2.usertype=1 and operatetype='0' and operatedate>@fromdate and t1.docid=t2.docid  and t1.docid=t3.id and t2.userid=@userid
  group by t1.docid order by result desc 
  end
  
  if @fromdate='0' and @todate ='0' 
  begin declare docid_cursor cursor for
  select top 50 count(t3.id) result,t1.docid resultid from DocDetailLog as t1,DocShareDetail as t2 ,DocDetail as t3 
  where  t2.usertype=1 and operatetype='0' and t1.docid=t2.docid  and t1.docid=t3.id and t2.userid=@userid
  group by t1.docid order by result desc 
  end  

  open docid_cursor fetch next from docid_cursor into @acount,@docid while @@fetch_status=0 
  begin 
  select @maincategory = maincategory , @doccreaterid=doccreaterid, @docdepartmentid= docdepartmentid from DocDetail 
  where id= @docid  insert into 
  #temp values(@docid,@acount,@doccreaterid, @docdepartmentid,@maincategory) fetch next 
  from docid_cursor into @acount,@docid 
  end 
  close docid_cursor deallocate docid_cursor  
  select * from #temp order by acount desc



GO

 CREATE PROCEDURE DocRpSum 
 @optional	varchar(30),
 @userid int,
 @flag	int output,
 @msg 	varchar(80) output 
 AS declare 
 @resultid  int,
 @count  int,
 @replycount  int 
 create table #temp( resultid  int , acount  int, replycount int ) 
     if   @optional='doccreater' 
 	begin declare resultid_cursor cursor for 
	select top 20 count(id) resultcount,ownerid resultid from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid 
	group by ownerid order by resultcount desc 
	open resultid_cursor fetch next from resultid_cursor into @count,@resultid 
	while @@fetch_status=0 
	begin 
	select @replycount=count(id) from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid  
	and doccreaterid=@resultid and isreply='1' insert into #temp 
	values(@resultid,@count,@replycount) 
	fetch next from resultid_cursor into @count,@resultid
        end close resultid_cursor deallocate resultid_cursor select * from #temp 
	order by acount desc 
	end  

     if   @optional='crm' 
	begin declare resultid_cursor cursor for 
	select top 20 count(id) resultcount,t1.crmid resultid from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid  
	group by t1.crmid order by resultcount desc 
	open resultid_cursor fetch next from resultid_cursor into @count,@resultid 
	while @@fetch_status=0 
	begin 
	select @replycount=count(id) from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid  
	and t1.crmid=@resultid and isreply='1' insert into #temp 
	values(@resultid,@count,@replycount) fetch next from resultid_cursor into @count,@resultid 
	end close resultid_cursor deallocate resultid_cursor 
	select * from #temp order by acount desc 
	end  

     if   @optional='resource' 
	begin declare resultid_cursor cursor for 
	select top 20 count(id) resultcount,hrmresid resultid from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid  
	group by hrmresid order by resultcount desc 
	open resultid_cursor fetch next from resultid_cursor into @count,@resultid 
	while @@fetch_status=0 
	begin select @replycount=count(id) from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid   
	and hrmresid=@resultid and isreply='1' insert into #temp 
	values(@resultid,@count,@replycount) fetch next from resultid_cursor into @count,@resultid 
	end close resultid_cursor deallocate resultid_cursor 
	select * from #temp order by acount desc 
	end  

    if   @optional='project' 
	begin declare resultid_cursor cursor for 
	select top 20 count(id) resultcount,projectid resultid from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid  
	group by projectid order by resultcount desc 
	open resultid_cursor fetch next from resultid_cursor into @count,@resultid 
	while @@fetch_status=0 
	begin select @replycount=count(id) from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid   
	and projectid=@resultid and isreply='1' insert into #temp 
	values(@resultid,@count,@replycount) fetch next from resultid_cursor into @count,@resultid 
	end close resultid_cursor deallocate resultid_cursor 
	select * from #temp order by acount desc 
	end  

    if   @optional='department' 
	begin declare resultid_cursor cursor for 
	select top 20 count(id) resultcount,docdepartmentid resultid from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid  
	group by docdepartmentid order by resultcount desc 
	open resultid_cursor fetch next from resultid_cursor into @count,@resultid 
	while @@fetch_status=0 
	begin select @replycount=count(id) from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid  
	and docdepartmentid=@resultid and isreply='1' insert into #temp 
	values(@resultid,@count,@replycount) fetch next from resultid_cursor into @count,@resultid 
	end close resultid_cursor deallocate resultid_cursor 
	select * from #temp order by acount desc 
	end  

   if   @optional='language' 
	begin declare resultid_cursor cursor for 
	select top 20 count(id) resultcount,doclangurage resultid from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid   
	group by doclangurage order by resultcount desc 
	open resultid_cursor fetch next from resultid_cursor into @count,@resultid 
	while @@fetch_status=0 
	begin select @replycount=count(id) from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid   
	and doclangurage=@resultid and isreply='1' insert into #temp 
	values(@resultid,@count,@replycount) fetch next from resultid_cursor into @count,@resultid 
        end close resultid_cursor deallocate resultid_cursor 
	select * from #temp order by acount desc 
	end  

   if   @optional='item' 
	begin declare resultid_cursor cursor for 
	select top 20 count(id) resultcount,itemid resultid from docdetail as t1,DocShareDetail as t2 where  t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid   
	group by itemid order by resultcount desc 
	open resultid_cursor fetch next from resultid_cursor into @count,@resultid 
	while @@fetch_status=0 
	begin select @replycount=count(id) from docdetail as t1,DocShareDetail as t2 where t2.usertype=1 and t1.id=t2.docid and t2.userid=@userid   
	and itemid=@resultid and isreply='1' insert into #temp 
	values(@resultid,@count,@replycount) fetch next from resultid_cursor into @count,@resultid 
	end close resultid_cursor deallocate resultid_cursor 
	select * from #temp order by acount desc 
	end
 

GO

 CREATE PROCEDURE DocSearchMould_Delete 
	(@id_1 	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS DELETE [DocSearchMould] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE DocSearchMould_Insert 
	(@mouldname_1 	[varchar](200),
	 @userid_2 	[int],
	 @docsubject_3 	[varchar](200),
	 @doccontent_4 	[varchar](200),
	 @containreply_5 	[char](1),
	 @maincategory_6 	[int],
	 @subcategory_7 	[int],
	 @seccategory_8 	[int],
	 @docid_9 	[int],
	 @createrid_10 	[int],
	 @departmentid_11 	[int],
	 @doclangurage_12 	[tinyint],
	 @hrmresid_13 	[int],
	 @itemid_14 	[int],
	 @itemmaincategoryid_15 	[int],
	 @crmid_16 	[int],
	 @projectid_17 	[int],
	 @financeid_18 	[int],
	 @docpublishtype_19 	[char](1),
	 @docstatus_20 	[char](1),
	 @keyword_21 	[varchar](255),
	 @ownerid_22 	[int],
	 @docno_23 	[varchar](60),
	 @doclastmoddatefrom_24 	[char](10),
	 @doclastmoddateto_25 	[char](10),
	 @docarchivedatefrom_26 	[char](10),
	 @docarchivedateto_27 	[char](10),
	 @doccreatedatefrom_28 	[char](10),
	 @doccreatedateto_29 	[char](10),
	 @docapprovedatefrom_30 	[char](10),
	 @docapprovedateto_31 	[char](10),
	 @replaydoccountfrom_32 	[int],
	 @replaydoccountto_33 	[int],
	 @accessorycountfrom_34 	[int],
	 @accessorycountto_35 	[int],
	 @doclastmoduserid_36 	[int],
	 @docarchiveuserid_37 	[int],
	 @docapproveuserid_38 	[int],
	 @assetid_39 	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [DocSearchMould] 
	 ( [mouldname],
	 [userid],
	 [docsubject],
	 [doccontent],
	 [containreply],
	 [maincategory],
	 [subcategory],
	 [seccategory],
	 [docid],
	 [createrid],
	 [departmentid],
	 [doclangurage],
	 [hrmresid],
	 [itemid],
	 [itemmaincategoryid],
	 [crmid],
	 [projectid],
	 [financeid],
	 [docpublishtype],
	 [docstatus],
	 [keyword],
	 [ownerid],
	 [docno],
	 [doclastmoddatefrom],
	 [doclastmoddateto],
	 [docarchivedatefrom],
	 [docarchivedateto],
	 [doccreatedatefrom],
	 [doccreatedateto],
	 [docapprovedatefrom],
	 [docapprovedateto],
	 [replaydoccountfrom],
	 [replaydoccountto],
	 [accessorycountfrom],
	 [accessorycountto],
	 [doclastmoduserid],
	 [docarchiveuserid],
	 [docapproveuserid],
	 [assetid]) 
 
VALUES 
	( @mouldname_1,
	 @userid_2,
	 @docsubject_3,
	 @doccontent_4,
	 @containreply_5,
	 @maincategory_6,
	 @subcategory_7,
	 @seccategory_8,
	 @docid_9,
	 @createrid_10,
	 @departmentid_11,
	 @doclangurage_12,
	 @hrmresid_13,
	 @itemid_14,
	 @itemmaincategoryid_15,
	 @crmid_16,
	 @projectid_17,
	 @financeid_18,
	 @docpublishtype_19,
	 @docstatus_20,
	 @keyword_21,
	 @ownerid_22,
	 @docno_23,
	 @doclastmoddatefrom_24,
	 @doclastmoddateto_25,
	 @docarchivedatefrom_26,
	 @docarchivedateto_27,
	 @doccreatedatefrom_28,
	 @doccreatedateto_29,
	 @docapprovedatefrom_30,
	 @docapprovedateto_31,
	 @replaydoccountfrom_32,
	 @replaydoccountto_33,
	 @accessorycountfrom_34,
	 @accessorycountto_35,
	 @doclastmoduserid_36,
	 @docarchiveuserid_37,
	 @docapproveuserid_38,
	 @assetid_39)
select max(id) from DocSearchMould

GO

 CREATE PROCEDURE DocSearchMould_SelectByID 
	(@id_1 	integer,
	 @flag integer output,
	 @msg varchar(80) output)
AS
select * from DocSearchMould where id=@id_1

GO










 CREATE PROCEDURE DocSearchMould_SelectByUserid 
	(@userid_1 	integer,
	 @flag integer output,
	 @msg varchar(80) output)
AS
select id,mouldname from DocSearchMould where userid=@userid_1

GO

 CREATE PROCEDURE DocSearchMould_Update 
	(@id_1 	[int],
	 @mouldname_2 	[varchar](200),
	 @userid_3 	[int],
	 @docsubject_4 	[varchar](200),
	 @doccontent_5 	[varchar](200),
	 @containreply_6 	[char](1),
	 @maincategory_7 	[int],
	 @subcategory_8 	[int],
	 @seccategory_9 	[int],
	 @docid_10 	[int],
	 @createrid_11 	[int],
	 @departmentid_12 	[int],
	 @doclangurage_13 	[tinyint],
	 @hrmresid_14 	[int],
	 @itemid_15 	[int],
	 @itemmaincategoryid_16 	[int],
	 @crmid_17 	[int],
	 @projectid_18 	[int],
	 @financeid_19 	[int],
	 @docpublishtype_20 	[char](1),
	 @docstatus_21 	[char](1),
	 @keyword_22 	[varchar](255),
	 @ownerid_23 	[int],
	 @docno_24 	[varchar](60),
	 @doclastmoddatefrom_25 	[char](10),
	 @doclastmoddateto_26 	[char](10),
	 @docarchivedatefrom_27 	[char](10),
	 @docarchivedateto_28 	[char](10),
	 @doccreatedatefrom_29 	[char](10),
	 @doccreatedateto_30 	[char](10),
	 @docapprovedatefrom_31 	[char](10),
	 @docapprovedateto_32 	[char](10),
	 @replaydoccountfrom_33 	[int],
	 @replaydoccountto_34 	[int],
	 @accessorycountfrom_35 	[int],
	 @accessorycountto_36 	[int],
	 @doclastmoduserid_37 	[int],
	 @docarchiveuserid_38 	[int],
	 @docapproveuserid_39 	[int],
	 @assetid_40 	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS UPDATE [DocSearchMould] 

SET  [mouldname]	 = @mouldname_2,
	 [userid]	 = @userid_3,
	 [docsubject]	 = @docsubject_4,
	 [doccontent]	 = @doccontent_5,
	 [containreply]	 = @containreply_6,
	 [maincategory]	 = @maincategory_7,
	 [subcategory]	 = @subcategory_8,
	 [seccategory]	 = @seccategory_9,
	 [docid]	 = @docid_10,
	 [createrid]	 = @createrid_11,
	 [departmentid]	 = @departmentid_12,
	 [doclangurage]	 = @doclangurage_13,
	 [hrmresid]	 = @hrmresid_14,
	 [itemid]	 = @itemid_15,
	 [itemmaincategoryid]	 = @itemmaincategoryid_16,
	 [crmid]	 = @crmid_17,
	 [projectid]	 = @projectid_18,
	 [financeid]	 = @financeid_19,
	 [docpublishtype]	 = @docpublishtype_20,
	 [docstatus]	 = @docstatus_21,
	 [keyword]	 = @keyword_22,
	 [ownerid]	 = @ownerid_23,
	 [docno]	 = @docno_24,
	 [doclastmoddatefrom]	 = @doclastmoddatefrom_25,
	 [doclastmoddateto]	 = @doclastmoddateto_26,
	 [docarchivedatefrom]	 = @docarchivedatefrom_27,
	 [docarchivedateto]	 = @docarchivedateto_28,
	 [doccreatedatefrom]	 = @doccreatedatefrom_29,
	 [doccreatedateto]	 = @doccreatedateto_30,
	 [docapprovedatefrom]	 = @docapprovedatefrom_31,
	 [docapprovedateto]	 = @docapprovedateto_32,
	 [replaydoccountfrom]	 = @replaydoccountfrom_33,
	 [replaydoccountto]	 = @replaydoccountto_34,
	 [accessorycountfrom]	 = @accessorycountfrom_35,
	 [accessorycountto]	 = @accessorycountto_36,
	 [doclastmoduserid]	 = @doclastmoduserid_37,
	 [docarchiveuserid]	 = @docarchiveuserid_38,
	 [docapproveuserid]	 = @docapproveuserid_39,
	 [assetid]	 = @assetid_40 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE DocSecCategoryShare_Delete 
	(@id	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	delete from DocSecCategoryShare where id=@id

GO

 CREATE PROCEDURE DocSecCategoryShare_Insert 
	(@secid	int,
	@sharetype	int,
	@seclevel	tinyint,
	@rolelevel	tinyint,
	@sharelevel	tinyint,
	@userid	int,
	@subcompanyid	int,
	@departmentid	int,
	@roleid	int,
	@foralluser	tinyint,
	@flag	int output,
	@msg	varchar(80)	output)
as
	insert into DocSecCategoryShare values
	(@secid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser)

GO

 CREATE PROCEDURE DocSecCategoryShare_SBySecCate 
(@seccategoryid  	[int], 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select * from DocSecCategoryShare 
where seccategoryid  = @seccategoryid

GO

 CREATE PROCEDURE DocSecCategoryShare_SBySecID 
	(@secid	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	select * from DocSecCategoryShare where seccategoryid=@secid

GO

 CREATE PROCEDURE DocSecCategory_SByCustomerType 
	(@cusertype 	[int],
	 @cuserseclevel 	[tinyint],
	@flag	int output,
	@msg	varchar(80)	output)
as
	select id,subcategoryid from DocSecCategory where cusertype= @cusertype and cuserseclevel<=@cuserseclevel  order by subcategoryid


GO

 CREATE PROCEDURE DocShareDetail_DeleteByDocId 
	(@docid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [DocShareDetail] 

WHERE 
	( [docid]	 = @docid_1)

GO

 CREATE PROCEDURE DocShareDetail_DeleteByUserId 
	(@userid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [DocShareDetail] 

WHERE 
	( [userid]	 = @userid_1  and usertype = '1' )

GO

 CREATE PROCEDURE DocShareDetail_Insert 
	(@docid_1 	[int],
	 @userid_2 	[int],
	 @usertype_3 	[int],
	 @sharelevel_4 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [DocShareDetail] 
	 ( [docid],
	 [userid],
	 [usertype],
	 [sharelevel]) 
 
VALUES 
	( @docid_1,
	 @userid_2,
	 @usertype_3,
	 @sharelevel_4)

GO

 CREATE PROCEDURE DocShareDetail_SByResourceId 
	(@resourceid_1 int ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS 
select docid , sharelevel from DocShareDetail where userid = @resourceid_1 and usertype = '1'  

GO

 CREATE PROCEDURE DocShareDetail_SelectByDocId 
	(@docid_1 int ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS 
select * from DocShareDetail where docid = @docid_1 

GO

 CREATE PROCEDURE DocShare_Delete 
	(@id	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	delete from DocShare where id=@id

GO

 CREATE PROCEDURE DocShare_IFromDocSecCategory 
       (@docid          int,
	@sharetype	int,
	@seclevel	tinyint,
	@rolelevel	tinyint,
	@sharelevel	tinyint,
	@userid	int,
	@subcompanyid	int,
	@departmentid	int,
	@roleid	int,
	@foralluser	tinyint,
	@crmid	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid) 
	values(@docid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser,@crmid)



GO

 CREATE PROCEDURE DocShare_SelectByDocID 
	(@docid	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	select * from DocShare where docid = @docid


GO

 CREATE PROCEDURE DocSysDefault_Update 
	(@fgpicwidth	smallint,
	@fgpicfixtype	char(1),
	@docdefmouldid	int,
	@docapprovewfid int ,
	@flag	int output,
	@msg	varchar(80)	output)
as
	update DocSysDefault 
	set fgpicwidth=@fgpicwidth,fgpicfixtype=@fgpicfixtype,docdefmouldid=@docdefmouldid,docapprovewfid=@docapprovewfid 


GO

 CREATE PROCEDURE DocUserCategory_DByCategory 
	@secid	int, 
	@flag	int	output, 
	@msg	varchar(80) output 
as
	delete from DocUserCategory where secid=@secid

GO

 CREATE PROCEDURE DocUserCategory_DeleleByUser 
	@userid	int, 
	@usertype	char(1),
	@flag	int	output, 
	@msg	varchar(80) output 
as
	delete from DocUserCategory where userid=@userid and usertype=@usertype

GO

/* 8.30 */
 CREATE PROCEDURE DocUserCategory_IByCategory 
	@secid	int, 
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	declare	@mainid	int,
			@subid	int,
			@userid	int,
			@all_cursor cursor,
			@cusertype	char(1),
			@cuserseclevel	tinyint,
			@cdepartmentid1	int,
			@cdepseclevel1	tinyint,
			@cdepartmentid2	int,
			@cdepseclevel2	tinyint,
			@croleid1		int,
			@crolelevel1	char(1),
			@croleid2		int,
			@crolelevel2	char(1),
			@croleid3		int,
			@crolelevel3	char(1),
			@usertype		char(1)
			
	select @subid=subcategoryid, 
			@cusertype=cusertype,
			@cuserseclevel=cuserseclevel,
			@cdepartmentid1=cdepartmentid1,
			@cdepseclevel1=cdepseclevel1,
			@cdepartmentid2=cdepartmentid2,
			@cdepseclevel2=cdepseclevel2,
			@croleid1=croleid1,
			@crolelevel1=crolelevel1,
			@croleid2=croleid2,
			@crolelevel2=crolelevel2,
			@croleid3=croleid3,
			@crolelevel3=crolelevel3 from docseccategory where id=@secid
	select @mainid=maincategoryid from docsubcategory where id=@subid
	
	if @cusertype='0'
		begin
			set @usertype='0'
			SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
				
			select id from hrmresource where seclevel>=@cuserseclevel
			union
			select t1.id from hrmresource t1,hrmdepartment t2 where 
			(t1.seclevel>=@cdepseclevel1 and t2.id=@cdepartmentid1 and t1.departmentid=t2.id)
			or (t1.seclevel>=@cdepseclevel2 and t2.id=@cdepartmentid2 and t1.departmentid=t2.id)
			union
			select t1.id from hrmresource t1,hrmroles t2,hrmrolemembers t3 where 
			(t1.id=t3.resourceid and t3.roleid=t2.id and t2.id=@croleid1 and t3.rolelevel>=@crolelevel1)
			or (t1.id=t3.resourceid and t3.roleid=t2.id and t2.id=@croleid2 and t3.rolelevel>=@crolelevel2)
			or (t1.id=t3.resourceid and t3.roleid=t2.id and t2.id=@croleid3 and t3.rolelevel>=@crolelevel3)
			
			OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @userid  
			WHILE @@FETCH_STATUS = 0 
				begin 
					insert into  docusercategory (secid,mainid,subid,userid,usertype)
					values (@secid,@mainid,@subid,@userid,@usertype)
					FETCH NEXT FROM @all_cursor INTO @userid 
				end 
			CLOSE @all_cursor DEALLOCATE @all_cursor   
		end
	else
		begin
			set @usertype='1'
			SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
			select id from crm_customerinfo where type=@cusertype and seclevel>=@cuserseclevel 
			OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @userid  
			WHILE @@FETCH_STATUS = 0 
				begin 
					insert into  docusercategory (secid,mainid,subid,userid,usertype)
					values (@secid,@mainid,@subid,@userid,@usertype)
					FETCH NEXT FROM @all_cursor INTO @userid 
				end 
			CLOSE @all_cursor DEALLOCATE @all_cursor  
		end
GO

 CREATE PROCEDURE DocUserCategory_InsertByUser 
	@userid	int, 
	@usertype char(1),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	declare	@mainid	int,
			@subid	int,
			@secid	int,
			@seclevel	tinyint,
			@crmtype	int,
			@all_cursor cursor
			
	if @usertype='0'
		begin
			SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
			select distinct t1.id from docseccategory t1,hrmresource t2,hrmrolemembers t5
			where t1.cusertype='0' and t2.id=@userid 
			and(( t2.seclevel>=t1.cuserseclevel) 
			or( t2.seclevel >= t1.cdepseclevel1 and t2.departmentid=t1.cdepartmentid1) 
			or( t2.seclevel >= t1.cdepseclevel2 and t2.departmentid=t1.cdepartmentid2) 
			or( t5.roleid=t1.croleid1 and t5.rolelevel=t1.crolelevel1 and t2.id=t5.resourceid )
			or( t5.roleid=t1.croleid2 and t5.rolelevel=t1.crolelevel2 and t2.id=t5.resourceid )
			or( t5.roleid=t1.croleid3 and t5.rolelevel=t1.crolelevel3 and t2.id=t5.resourceid ))
			OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @secid  
			WHILE @@FETCH_STATUS = 0 
				begin
					select @subid=subcategoryid from docseccategory where id=@secid
					select @mainid=maincategoryid from docsubcategory where id=@subid
					insert into  docusercategory (secid,mainid,subid,userid,usertype)
					values (@secid,@mainid,@subid,@userid,@usertype)
					FETCH NEXT FROM @all_cursor INTO @secid 
				end 
			CLOSE @all_cursor DEALLOCATE @all_cursor
		end
	else
		begin
			select @crmtype=type,@seclevel=seclevel from crm_customerinfo where id=@userid
			SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
			select id from DocSecCategory 
			where cusertype=@crmtype and cuserseclevel<=@seclevel 
			OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @secid  
			WHILE @@FETCH_STATUS = 0 
				begin
					select @subid=subcategoryid from docseccategory where id=@secid
					select @mainid=maincategoryid from docsubcategory where id=@subid
					insert into  docusercategory (secid,mainid,subid,userid,usertype)
					values (@secid,@mainid,@subid,@userid,@usertype)
					FETCH NEXT FROM @all_cursor INTO @secid 
				end 
			CLOSE @all_cursor DEALLOCATE @all_cursor
		end


GO

 CREATE PROCEDURE DocUserCategory_SMainByUser 
	@userid	int, 
	@usertype	char(1),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	select 'mainid' = id from DocMainCategory 
	where id in ( select distinct mainid from docusercategory where userid=@userid and usertype=@usertype )
	order by categoryorder 


GO

 CREATE PROCEDURE DocUserCategory_SSecByUser 
	@userid	int, 
	@usertype	char(1),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	select distinct secid from docusercategory where userid=@userid and usertype=@usertype

GO

 CREATE PROCEDURE DocUserCategory_SSubByUser 
	@userid	int, 
	@usertype	char(1),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	select distinct subid from docusercategory where userid=@userid and usertype=@usertype

GO

 CREATE PROCEDURE DocUserCategory_SelectByUserId 
	(@userid	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	select * from DocShare where userid = @userid


GO

 CREATE PROCEDURE DocUserView_DeletebyDocId 
(@docid 	[int],
 @flag	int output,
 @msg	varchar(80)	output)
as
	delete from DocUserView where docid=@docid

GO

 CREATE PROCEDURE DocUserView_DeletebyUserId 
(@userid 	[int],
 @flag	int output,
 @msg	varchar(80)	output)
as
	delete from DocUserView where userid=@userid

GO

 CREATE PROCEDURE DocUserView_InsertByUser 
    @seclevel int,
    @departmentid int,
    @subcompanyid int,
    @userid	int, 
    @flag	int	output, 
    @msg	varchar(80) output 
as 
	declare	@docid	int,
 @all_cursor cursor
  SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
  select Distinct docid from DocShare  where sharetype=5 or (sharetype=3 and @seclevel>=seclevel and @departmentid=departmentid) 
  OR (sharetype=2 and @seclevel>=seclevel and @subcompanyid=subcompanyid) 
  OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @docid  
  WHILE @@FETCH_STATUS = 0 
			begin
            insert into DocUserView (docid,userid) values (@docid , @userid)
            FETCH NEXT FROM @all_cursor INTO @docid 
			end 
 CLOSE @all_cursor DEALLOCATE @all_cursor


GO

 CREATE PROCEDURE DocUserView_SelectByDocId 
(@docid 	[int],
 @flag	int output,
 @msg	varchar(80)	output)
as
	select userid from DocUserView where docid=@docid

GO

 CREATE PROCEDURE DocUserView_SelectCopyByUserId 
(@secid  int,
 @userid 	[int],
 @flag	int output,
 @msg	varchar(80)	output)
as
select t1.id,t1.docsubject,t1.doccreaterid,t1.doccreatedate,t1.docstatus  
from DocDetail as t1, DocUserView as t2 where t1.id=t2.docid and t1.seccategory=@secid 
and t2.userid=@userid


GO

 CREATE PROCEDURE DocUserView_SelectbyUserId 
(@userid 	[int],
 @flag	int output,
 @msg	varchar(80)	output)
as
	select docid from DocUserView where userid=@userid

GO

 CREATE PROCEDURE Doc_SecCategory_Delete 
	(@id	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	delete from Docseccategory where id=@id

GO

 CREATE PROCEDURE Doc_SecCategory_Insert 
	(
	 @subcategoryid 	[int],
	 @categoryname 	[varchar](200),
	 @docmouldid 	[int],
	 @publishable 	[char](1),
	 @replyable 	[char](1),
	 @shareable 	[char](1),
	 @cusertype 	[int],
	 @cuserseclevel 	[tinyint],
	 @cdepartmentid1 	[int],
	 @cdepseclevel1 	[tinyint],
	 @cdepartmentid2 	[int],
	 @cdepseclevel2 	[tinyint],
	 @croleid1	 		[int],
	 @crolelevel1	 	[char](1),
	 @croleid2	 	[int],
	 @crolelevel2 	[char](1),
	 @croleid3	 	[int],
	 @crolelevel3 	[char](1),
	 @hasaccessory	 	[char](1),
	 @accessorynum	 	[tinyint],
	 @hasasset		 	[char](1),
	 @assetlabel	 	[varchar](200),
	 @hasitems	 	[char](1),
	 @itemlabel 	[varchar](200),
	 @hashrmres 	[char](1),
	 @hrmreslabel 	[varchar](200),
	 @hascrm	 	[char](1),
	 @crmlabel	 	[varchar](200),
	 @hasproject 	[char](1),
	 @projectlabel 	[varchar](200),
	 @hasfinance 	[char](1),
	 @financelabel 	[varchar](200),
	 @approveworkflowid	int,	
	 @flag	int output,
	@msg	varchar(80)	output)
as
	insert into docseccategory 
	values(
	 @subcategoryid,
	 @categoryname,
	 @docmouldid,
	 @publishable,
	 @replyable,
	 @shareable,
	 @cusertype,
	 @cuserseclevel,
	 @cdepartmentid1,
	 @cdepseclevel1,
	 @cdepartmentid2,
	 @cdepseclevel2,
	 @croleid1,
	 @crolelevel1,
	 @croleid2,
	 @crolelevel2,
	 @croleid3,
	 @crolelevel3,
	 @hasaccessory,
	 @accessorynum,
	 @hasasset,
	 @assetlabel,
	 @hasitems,
	 @itemlabel,
	 @hashrmres,
	 @hrmreslabel,
	 @hascrm,
	 @crmlabel,
	 @hasproject,
	 @projectlabel,
	 @hasfinance,
	 @financelabel,
	 @approveworkflowid)
	select max(id) from docseccategory

GO

 CREATE PROCEDURE Doc_SecCategory_SelectByID 
	(@id	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	select * from docseccategory where id=@id

GO

 CREATE PROCEDURE Doc_SecCategory_Update 
	(@id	int,
	 @subcategoryid 	[int],
	 @categoryname 	[varchar](200),
	 @docmouldid 	[int],
	 @publishable 	[char](1),
	 @replyable 	[char](1),
	 @shareable 	[char](1),
	 @cusertype 	[int],
	 @cuserseclevel 	[tinyint],
	 @cdepartmentid1 	[int],
	 @cdepseclevel1 	[tinyint],
	 @cdepartmentid2 	[int],
	 @cdepseclevel2 	[tinyint],
	 @croleid1	 		[int],
	 @crolelevel1	 	[char](1),
	 @croleid2	 	[int],
	 @crolelevel2 	[char](1),
	 @croleid3	 	[int],
	 @crolelevel3 	[char](1),
	 @hasaccessory	 	[char](1),
	 @accessorynum	 	[tinyint],
	 @hasasset		 	[char](1),
	 @assetlabel	 	[varchar](200),
	 @hasitems	 	[char](1),
	 @itemlabel 	[varchar](200),
	 @hashrmres 	[char](1),
	 @hrmreslabel 	[varchar](200),
	 @hascrm	 	[char](1),
	 @crmlabel	 	[varchar](200),
	 @hasproject 	[char](1),
	 @projectlabel 	[varchar](200),
	 @hasfinance 	[char](1),
	 @financelabel 	[varchar](200),
	 @approveworkflowid	int,
	 @flag	int output,
	@msg	varchar(80)	output)
as
	update docseccategory 
	set
	 subcategoryid=@subcategoryid,
	 categoryname=@categoryname,
	 docmouldid=@docmouldid,
	 publishable=@publishable,
	 replyable=@replyable,
	 shareable=@shareable,
	 cusertype=@cusertype,
	 cuserseclevel=@cuserseclevel,
	 cdepartmentid1=@cdepartmentid1,
	 cdepseclevel1=@cdepseclevel1,
	 cdepartmentid2=@cdepartmentid2,
	 cdepseclevel2=@cdepseclevel2,
	 croleid1=@croleid1,
	 crolelevel1=@crolelevel1,
	 croleid2=@croleid2,
	 crolelevel2=@crolelevel2,
	 croleid3=@croleid3,
	 crolelevel3=@crolelevel3,
	 approveworkflowid=@approveworkflowid,
	 hasaccessory=@hasaccessory,
	 accessorynum=@accessorynum,
	 hasasset=@hasasset,
	 assetlabel=@assetlabel,
	 hasitems=@hasitems,
	 itemlabel=@itemlabel,
	 hashrmres=@hashrmres,
	 hrmreslabel=@hrmreslabel,
	 hascrm=@hascrm,
	 crmlabel=@crmlabel,
	 hasproject=@hasproject,
	 projectlabel=@projectlabel,
	 hasfinance=@hasfinance,
	 financelabel=@financelabel
	where id=@id

GO

 CREATE PROCEDURE FnaAccountList_Process 
 @departmentid_1 	[int], @tranperiods_2    char(6), @flag integer output , @msg varchar(80) output AS declare @count integer declare @ledgerid int ,@tranid int ,@tranperiods char(6),@tranmark int,@trandate char(10) declare @tranremark varchar(200),@tranaccount decimal(18,3),@tranbalance char(1)  select @count = count(id) from FnaYearsPeriodsList where fnayearperiodsid < @tranperiods_2 and isactive = '1' and isclose ='0'  if @count <> 0 begin select -1 return end  declare transaction_cursor cursor for select ledgerid, t.id, tranperiods, tranmark, trandate, d.tranremark, tranaccount, tranbalance from FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid and trandepartmentid = @departmentid_1 and tranperiods = @tranperiods_2 and transtatus = '1'  open transaction_cursor fetch next from transaction_cursor into @ledgerid,@tranid,@tranperiods,@tranmark,@trandate, @tranremark,@tranaccount,@tranbalance while @@fetch_status=0 begin insert into FnaAccountList ( [ledgerid], [tranid], [tranperiods], [tranmark], [trandate], [tranremark], [tranaccount], [tranbalance])  VALUES ( @ledgerid, @tranid, @tranperiods, @tranmark, @trandate, @tranremark, @tranaccount, @tranbalance)  fetch next from transaction_cursor into @ledgerid,@tranid,@tranperiods,@tranmark,@trandate, @tranremark,@tranaccount,@tranbalance end close transaction_cursor deallocate transaction_cursor  update FnaTransaction set transtatus = '2' where trandepartmentid = @departmentid_1 and tranperiods = @tranperiods_2 and transtatus = '1' 
GO

 CREATE PROCEDURE FnaAccountList_Select 
 @ledgerid_0 	int, @periods_1    char(6), @periods_2    char(6), @flag integer output , @msg varchar(80) output AS declare @count int, @ledgerid int ,@tranmark int ,@trandate char(10),@tranremark varchar(200),@tranid int declare @tranaccount decimal(18,3),@tranremain decimal(18,3),@tranbalance char(1),@tmptranperiods char(6)  create table #temp ( ledgerid        int , tranid          int  , tranmark        int  , trandate        char(10)   , tranremark      varchar(200) , tranaccount     decimal(18,3) , tranbalance     char(1) )  if  @ledgerid_0 = 0 begin declare account_cursor cursor for select ledgerid,tranid,tranmark,trandate,tranremark,tranaccount, tranbalance from  FnaAccountList where tranperiods >= @periods_1 and  tranperiods <= @periods_2  open account_cursor fetch next from account_cursor into @ledgerid,@tranid,@tranmark,@trandate,@tranremark,@tranaccount,@tranbalance while @@fetch_status=0 begin insert into #temp values(@ledgerid,@tranid,@tranmark,@trandate,@tranremark,@tranaccount,@tranbalance) fetch next from account_cursor into @ledgerid,@tranid,@tranmark,@trandate,@tranremark,@tranaccount,@tranbalance end close account_cursor deallocate account_cursor  declare ledger_cursor cursor for select ledgerid from #temp group by ledgerid  open ledger_cursor fetch next from ledger_cursor into @ledgerid while @@fetch_status=0 begin set @tranremain = 0 select @count = count(id) ,@tmptranperiods = max(tranperiods) from FnaAccount where ledgerid = @ledgerid and tranperiods < @periods_1 if @count <> 0 begin select @tranremain = tranremain from FnaAccount where ledgerid = @ledgerid and tranperiods = @tmptranperiods end insert into #temp values(@ledgerid,0,0,null,null,@tranremain,null) fetch next from ledger_cursor into @ledgerid end close ledger_cursor deallocate ledger_cursor  select * from #temp order by ledgerid , tranmark end else begin declare accountid_cursor cursor for select ledgerid,tranid,tranmark,trandate,tranremark,tranaccount, tranbalance from  FnaAccountList where tranperiods >= @periods_1 and  tranperiods <= @periods_2 and ledgerid = @ledgerid_0  open accountid_cursor fetch next from accountid_cursor into @ledgerid,@tranid,@tranmark,@trandate,@tranremark,@tranaccount,@tranbalance while @@fetch_status=0 begin insert into #temp values(@ledgerid,@tranid,@tranmark,@trandate,@tranremark,@tranaccount,@tranbalance) fetch next from accountid_cursor into @ledgerid,@tranid,@tranmark,@trandate,@tranremark,@tranaccount,@tranbalance end close accountid_cursor deallocate accountid_cursor  set @tranremain = 0 select @count = count(id) ,@tmptranperiods = max(tranperiods) from FnaAccount where ledgerid = @ledgerid_0 and tranperiods < @periods_1 if @count <> 0 begin select @tranremain = tranremain from FnaAccount where ledgerid = @ledgerid_0 and tranperiods = @tmptranperiods end insert into #temp values(@ledgerid,0,0,null,null,@tranremain,null) select * from #temp order by ledgerid , tranmark end 
GO

 CREATE PROCEDURE FnaAccount_Select 
 @ledgerid_0 	int, @periods_1    char(6), @periods_2    char(6), @flag integer output , @msg varchar(80) output AS declare @count int, @ledgerid int ,@tranperiods char(6),@trandaccount decimal(18,3) declare @trancaccount decimal(18,3),@tranremain decimal(18,3),@tmptranperiods char(6)  create table #temp ( ledgerid int , tranperiods char(6), trandaccount     decimal(18,3) , trancaccount     decimal(18,3) , tranremain      decimal(18,3) )  if  @ledgerid_0 = 0 begin declare account_cursor cursor for select ledgerid,tranperiods,trandaccount,trancaccount,tranremain from  FnaAccount where tranperiods >= @periods_1 and  tranperiods <= @periods_2  open account_cursor fetch next from account_cursor into @ledgerid,@tranperiods,@trandaccount,@trancaccount,@tranremain while @@fetch_status=0 begin insert into #temp values(@ledgerid,@tranperiods,@trandaccount,@trancaccount,@tranremain) fetch next from account_cursor into @ledgerid,@tranperiods,@trandaccount,@trancaccount,@tranremain end close account_cursor deallocate account_cursor  declare ledger_cursor cursor for select ledgerid from #temp group by ledgerid  open ledger_cursor fetch next from ledger_cursor into @ledgerid while @@fetch_status=0 begin set @tranremain = 0 select @count = count(id) ,@tmptranperiods = max(tranperiods) from FnaAccount where ledgerid = @ledgerid and tranperiods < @periods_1 if @count <> 0 begin select @tranremain = tranremain from FnaAccount where ledgerid = @ledgerid and tranperiods = @tmptranperiods end insert into #temp values(@ledgerid,null,null,null,@tranremain) fetch next from ledger_cursor into @ledgerid end close ledger_cursor deallocate ledger_cursor  select * from #temp order by ledgerid , tranperiods end else begin declare account1_cursor cursor for select tranperiods,trandaccount,trancaccount,tranremain from  FnaAccount where tranperiods >= @periods_1 and  tranperiods <= @periods_2 and ledgerid = @ledgerid_0  open account1_cursor fetch next from account1_cursor into @tranperiods,@trandaccount,@trancaccount,@tranremain while @@fetch_status=0 begin insert into #temp values(@ledgerid_0,@tranperiods,@trandaccount,@trancaccount,@tranremain) fetch next from account1_cursor into @tranperiods,@trandaccount,@trancaccount,@tranremain end close account1_cursor deallocate account1_cursor  set @tranremain = 0 select @count = count(id) ,@tmptranperiods = max(tranperiods) from FnaAccount where ledgerid = @ledgerid_0 and tranperiods < @periods_1 if @count <> 0 begin select @tranremain = tranremain from FnaAccount where ledgerid = @ledgerid_0 and tranperiods = @tmptranperiods end insert into #temp values(@ledgerid_0,null,null,null,@tranremain) select * from #temp order by ledgerid , tranperiods end 
GO

 CREATE PROCEDURE FnaAccount_SelectBalance 
 (@periodsfrom  char(6) , @periodsto     char(6) , @searchtype    int , @flag integer output , @msg varchar(80) output)  AS create table #templedgercount( ledgerid  int , precount  decimal(18,3), lastcount  decimal(18,3) ) declare @thelastperiods  char(6) ,@thenewperiods char(6), @ledgerid int , @precount decimal(18,3) , @lastcount decimal(18,3) select @thelastperiods = max(tranperiods) from FnaAccount where tranperiods < @periodsfrom if @thelastperiods = null  set @thelastperiods = '000000' select @thenewperiods = max(tranperiods) from FnaAccount if @thenewperiods < @periodsto  set @periodsto = @thenewperiods  if @searchtype = 1 begin  declare ledgerid_cursor cursor for select id from FnaLedger where supledgerid =0 and ledgergroup ='1' open ledgerid_cursor fetch next from ledgerid_cursor into @ledgerid while @@fetch_status=0 begin set @precount = 0 set @lastcount = 0 if @thelastperiods = '000000' select @precount = tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @thelastperiods else select @precount = (-2*convert(int,tranbalance)+3)*tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @thelastperiods select @lastcount = (-2*convert(int,tranbalance)+3)*tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @periodsto  insert into #templedgercount values(@ledgerid,@precount,@lastcount) fetch next from ledgerid_cursor into @ledgerid end close ledgerid_cursor deallocate ledgerid_cursor select * from #templedgercount  end  if @searchtype = 2 begin  declare ledgerid_cursor cursor for select id from FnaLedger where supledgerid =0 and ledgergroup ='2' open ledgerid_cursor fetch next from ledgerid_cursor into @ledgerid while @@fetch_status=0 begin set @precount = 0 set @lastcount = 0 if @thelastperiods = '000000' select @precount = tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @thelastperiods else select @precount = (2*convert(int,tranbalance)-3)*tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @thelastperiods select @lastcount = (2*convert(int,tranbalance)-3)*tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @periodsto  insert into #templedgercount values(@ledgerid,@precount,@lastcount) fetch next from ledgerid_cursor into @ledgerid end close ledgerid_cursor deallocate ledgerid_cursor select * from #templedgercount  end  if @searchtype = 3 begin  declare ledgerid_cursor cursor for select id from FnaLedger where supledgerid =0 and ledgergroup ='3' open ledgerid_cursor fetch next from ledgerid_cursor into @ledgerid while @@fetch_status=0 begin set @precount = 0 set @lastcount = 0 if @thelastperiods = '000000' select @precount = tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @thelastperiods else select @precount = (2*convert(int,tranbalance)-3)*tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @thelastperiods select @lastcount = (2*convert(int,tranbalance)-3)*tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @periodsto  insert into #templedgercount values(@ledgerid,@precount,@lastcount) fetch next from ledgerid_cursor into @ledgerid end close ledgerid_cursor deallocate ledgerid_cursor select * from #templedgercount end 
GO

 CREATE PROCEDURE FnaAccount_SelectPL 
 (@periodsfrom  char(6) , @periodsto     char(6) , @lastperiodsfrom  char(6) , @lastperiodsto  char(6) , @flag integer output , @msg varchar(80) output)  AS create table #templedgercount( ledgerid  int , precount  decimal(18,3), lastcount  decimal(18,3) )  declare @ledgerid int , @precount decimal(18,3) , @lastcount decimal(18,3) declare ledgerid_cursor cursor for select id from FnaLedger where supledgerid =0 and ledgergroup ='5' open ledgerid_cursor fetch next from ledgerid_cursor into @ledgerid while @@fetch_status=0 begin set @precount = 0 set @lastcount = 0 select @precount = sum(trancaccount)-sum(trandaccount) from FnaAccount where ledgerid = @ledgerid and tranperiods >= @lastperiodsfrom and tranperiods <= @lastperiodsto select @lastcount = sum(trancaccount)-sum(trandaccount) from FnaAccount where ledgerid = @ledgerid and tranperiods >= @periodsfrom and tranperiods <= @periodsto  insert into #templedgercount values(@ledgerid,@precount,@lastcount) fetch next from ledgerid_cursor into @ledgerid end close ledgerid_cursor deallocate ledgerid_cursor select * from #templedgercount 
GO

 CREATE PROCEDURE FnaBudgetDetail_Insert 
 (@budgetid_1 	[int], @ledgerid_2 	[int], @budgetcrmid_3 	[int], @budgetitemid_4 	[int], @budgetdocid_5 	[int], @budgetprojectid_6 	[int], @budgetaccount_7 	[decimal](18,3), @budgetdefaccount_8 	[decimal](18,3), @budgetremark_9 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [FnaBudgetDetail] ( [budgetid], [ledgerid], [budgetcrmid], [budgetitemid], [budgetdocid], [budgetprojectid], [budgetaccount], [budgetdefaccount], [budgetremark])  VALUES ( @budgetid_1, @ledgerid_2, @budgetcrmid_3, @budgetitemid_4, @budgetdocid_5, @budgetprojectid_6, @budgetaccount_7, @budgetdefaccount_8, @budgetremark_9) 
GO

 CREATE PROCEDURE FnaBudgetDetail_SByBudgetID 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output) AS select * from FnaBudgetDetail where budgetid = @id_1 
GO

 CREATE PROCEDURE FnaBudgetList_Process 
 @departmentid_1 	[int], @periodsfrom_2    char(6), @periodsto_2      char(6), @flag integer output , @msg varchar(80) output AS declare @ledgerid int ,@budgetid int ,@budgetmoduleid int ,@budgetperiods char(6) declare @budgetdepartmentid int,@budgetcostcenterid int,@budgetresourceid int declare @budgetremark varchar(200),@budgetaccount decimal(18,3)   declare budget_cursor cursor for select ledgerid, b.id, budgetmoduleid, budgetperiods, budgetdepartmentid, budgetcostercenterid, budgetresourceid, d.budgetremark , budgetdefaccount from FnaBudget b , FnaBudgetDetail d where b.id = d.budgetid and budgetdepartmentid = @departmentid_1 and budgetperiods >= @periodsfrom_2 and budgetperiods <= @periodsto_2 and budgetstatus = '1'  open budget_cursor fetch next from budget_cursor into @ledgerid,@budgetid,@budgetmoduleid,@budgetperiods,@budgetdepartmentid, @budgetcostcenterid,@budgetresourceid,@budgetremark,@budgetaccount while @@fetch_status=0 begin insert into FnaBudgetList ( [ledgerid], [budgetid], [budgetmoduleid], [budgetperiods], [budgetdepartmentid], [budgetcostcenterid], [budgetresourceid], [budgetremark], [budgetaccount])  VALUES ( @ledgerid, @budgetid, @budgetmoduleid, @budgetperiods, @budgetdepartmentid, @budgetcostcenterid, @budgetresourceid, @budgetremark, @budgetaccount)  fetch next from budget_cursor into @ledgerid,@budgetid,@budgetmoduleid,@budgetperiods,@budgetdepartmentid, @budgetcostcenterid,@budgetresourceid,@budgetremark,@budgetaccount end close budget_cursor deallocate budget_cursor  update FnaBudget set budgetstatus = '2' where budgetdepartmentid = @departmentid_1 and budgetperiods >= @periodsfrom_2 and budgetperiods <= @periodsto_2 and budgetstatus = '1' 
GO

 CREATE PROCEDURE FnaBudgetModule_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [FnaBudgetModule] WHERE ( [id]	 = @id_1) select '20' 
GO

 CREATE PROCEDURE FnaBudgetModule_Insert 
 (@budgetname_1 	[varchar](60), @budgetdesc_2 	[varchar](200), @fnayear_3 	[char](4), @periodsidfrom_4 	[int], @periodsidto_5 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [FnaBudgetModule] ( [budgetname], [budgetdesc], [fnayear], [periodsidfrom], [periodsidto])  VALUES ( @budgetname_1, @budgetdesc_2, @fnayear_3, @periodsidfrom_4, @periodsidto_5) select max(id) from FnaBudgetModule 
GO

 CREATE PROCEDURE FnaBudgetModule_Select 
 @flag integer output , @msg varchar(80) output AS select * from FnaBudgetModule 
GO

 CREATE PROCEDURE FnaBudgetModule_SelectByID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select * from FnaBudgetModule where id = @id_1 
GO

 CREATE PROCEDURE FnaBudgetModule_Update 
 (@id_1 	[int], @budgetname_2 	[varchar](60), @budgetdesc_3 	[varchar](200), @fnayear_4 	[char](4), @periodsidfrom_5 	[int], @periodsidto_6 	[int], @flag integer output , @msg varchar(80) output)  AS UPDATE [FnaBudgetModule]  SET  [budgetname]	 = @budgetname_2, [budgetdesc]	 = @budgetdesc_3, [fnayear]	 = @fnayear_4, [periodsidfrom]	 = @periodsidfrom_5, [periodsidto]	 = @periodsidto_6  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE FnaBudget_Approve 
 @id_1 	[int], @approverid  [int], @approverdate  char(10), @flag integer output , @msg varchar(80) output AS declare @count0 integer select @count0 = count(id) from FnaBudget where id = @id_1 and createrid = @approverid  if @count0 <> 0 begin select -1 return end   update FnaBudget set budgetstatus='1' , approverid=@approverid , approverdate=@approverdate where id = @id_1 
GO

 CREATE PROCEDURE FnaBudget_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS  DELETE [FnaBudget] WHERE  ( [id]	 = @id_1)  delete FnaBudgetDetail where budgetid = @id_1 
GO

 CREATE PROCEDURE FnaBudget_Insert 
 (@budgetmoduleid_1 	[int], @budgetperiods_2 	[char](6), @budgetdepartmentid_3 	[int], @budgetcostercenterid_4 	[int], @budgetresourceid_5 	[int], @budgetcurrencyid_6 	[int], @budgetdefcurrencyid_7 	[int], @budgetexchangerate_8 	[varchar](20), @budgetremark_9 	[varchar](250), @budgetstatus_10 	[char](1), @createrid_11 	[int], @createdate_12 	[char](10), @flag integer output , @msg varchar(80) output)  AS declare @count integer , @fnayear char(4) , @periodsid integer , @isclose char(1)  select @count = count(id) from FnaBudget where budgetresourceid = @budgetresourceid_5 and budgetperiods = @budgetperiods_2 if @count <> 0 begin select -1 return end  select @count = count(id) from FnaYearsPeriodsList where isclose = '0' and isactive = '1' and fnayearperiodsid = @budgetperiods_2  if @count = 0 begin select -2 return end   INSERT INTO [FnaBudget] ( [budgetmoduleid], [budgetperiods], [budgetdepartmentid], [budgetcostercenterid], [budgetresourceid], [budgetcurrencyid], [budgetdefcurrencyid], [budgetexchangerate], [budgetremark], [budgetstatus], [createrid], [createdate])  VALUES ( @budgetmoduleid_1, @budgetperiods_2, @budgetdepartmentid_3, @budgetcostercenterid_4, @budgetresourceid_5, @budgetcurrencyid_6, @budgetdefcurrencyid_7, @budgetexchangerate_8, @budgetremark_9, @budgetstatus_10, @createrid_11, @createdate_12)  select max(id) from FnaBudget 
GO

 CREATE PROCEDURE FnaBudget_Reopen 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS update FnaBudget set budgetstatus='0' , approverid = null , approverdate=null where id = @id_1 
GO

 CREATE PROCEDURE FnaBudget_SelectByResourceID 
 (@budgetperiods_1 	[char](6), @budgetresourceid_2 	[int], @flag integer output , @msg varchar(80) output) AS select * from FnaBudget where budgetperiods = @budgetperiods_1 and budgetresourceid = @budgetresourceid_2 
GO

 CREATE PROCEDURE FnaBudget_Update 
 (@id_1 	[int], @budgetmoduleid_3 	[int], @budgetcurrencyid_4 	[int], @budgetdefcurrencyid_5 	[int], @budgetexchangerate_6 	[varchar](20), @budgetremark_7 	[varchar](250), @budgetstatus_8 	[char](1), @createrid_9 	[int], @createdate_10 	[char](10), @flag integer output , @msg varchar(80) output) AS UPDATE [FnaBudget]  SET  [budgetmoduleid]	 = @budgetmoduleid_3, [budgetcurrencyid]	 = @budgetcurrencyid_4, [budgetdefcurrencyid]	 = @budgetdefcurrencyid_5, [budgetexchangerate]	 = @budgetexchangerate_6, [budgetremark]	 = @budgetremark_7, [budgetstatus]	 = @budgetstatus_8, [createrid]	 = @createrid_9, [createdate]	 = @createdate_10  WHERE ( [id]	 = @id_1)  delete FnaBudgetDetail where budgetid = @id_1 
GO

 CREATE PROCEDURE FnaBudgetfeeType_Delete 
	@id		int,
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	delete from fnaBudgetfeetype where id=@id

GO

 CREATE PROCEDURE FnaBudgetfeeType_Insert 
	@name	varchar(50),
	@description	varchar(255),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	insert into fnaBudgetfeetype (name,description) values (@name,@description)
	select max(id) from fnaBudgetfeeType

GO

 CREATE PROCEDURE FnaBudgetfeeType_Select 
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	select * from fnaBudgetfeetype order by id

GO

 CREATE PROCEDURE FnaBudgetfeeType_SelectByID 
	@id		int,
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	select * from fnaBudgetfeetype where id=@id

GO

 CREATE PROCEDURE FnaBudgetfeeType_Update 
	@id		int,
	@name	varchar(50),
	@description	varchar(250),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	update fnaBudgetfeetype set name=@name,description=@description where id=@id

GO

 CREATE PROCEDURE FnaCurrencyExchange_Delete 
 (@id_1 	[int], @fnayear_2 	[char](4), @periodsid_3 	[int], @flag                             integer output, @msg                             varchar(80) output )  AS  declare @isclose char(1) select @isclose = isclose from FnaYearsPeriodsList where fnayear = @fnayear_2  and Periodsid = @periodsid_3  if @isclose = '1' begin select -1 return end  DELETE [FnaCurrencyExchange] WHERE ( [id]	 = @id_1 ) 
GO

 CREATE PROCEDURE FnaCurrencyExchange_Insert 
 (@defcurrencyid_1 	[int], @thecurrencyid_2 	[int], @fnayear_3 	[char](4), @periodsid_4 	[int], @fnayearperiodsid_5 	[char](6), @avgexchangerate_6 	[varchar](20), @endexchangerage_7 	[varchar](20), @flag                             integer output, @msg                             varchar(80) output )  AS declare @count integer declare @isclose char(1)  select @count = count(id) from FnaCurrencyExchange where fnayearperiodsid = @fnayearperiodsid_5 and thecurrencyid = @thecurrencyid_2  if @count <> 0 begin select -1 return end  select @isclose = isclose from FnaYearsPeriodsList where fnayear = @fnayear_3  and Periodsid = @periodsid_4  if @isclose = '1' begin select -2 return end  INSERT INTO [FnaCurrencyExchange] ( [defcurrencyid], [thecurrencyid], [fnayear], [periodsid], [fnayearperiodsid], [avgexchangerate], [endexchangerage])  VALUES ( @defcurrencyid_1, @thecurrencyid_2, @fnayear_3, @periodsid_4, @fnayearperiodsid_5, @avgexchangerate_6, @endexchangerage_7)  select max(id) from FnaCurrencyExchange 
GO

 CREATE PROCEDURE FnaCurrencyExchange_SByCurrenc 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select * from FnaCurrencyExchange where thecurrencyid = @id_1 order by fnayearperiodsid desc 
GO

 CREATE PROCEDURE FnaCurrencyExchange_SelectByID 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select * from FnaCurrencyExchange where id = @id_1 
GO

 CREATE PROCEDURE FnaCurrencyExchange_SByLast 
 @flag integer output , @msg varchar(80) output AS declare @thecurrencyid int, @defcurrencyid int, @fnayearperiodsid char(6) , @endexchangerage varchar(20) create table #temp( defcurrencyid  int , thecurrencyid  int, endexchangerage       varchar(20) )  declare currencyid_cursor cursor for select thecurrencyid , max(fnayearperiodsid) from  FnaCurrencyExchange group by thecurrencyid  open currencyid_cursor fetch next from currencyid_cursor into @thecurrencyid,@fnayearperiodsid while @@fetch_status=0 begin select @defcurrencyid = defcurrencyid , @endexchangerage=endexchangerage from FnaCurrencyExchange where thecurrencyid= @thecurrencyid and fnayearperiodsid=@fnayearperiodsid  insert into #temp values(@defcurrencyid,@thecurrencyid,@endexchangerage) fetch next from currencyid_cursor into @thecurrencyid,@fnayearperiodsid end close currencyid_cursor deallocate currencyid_cursor  select * from #temp 
GO

 CREATE PROCEDURE FnaCurrencyExchange_Update 
 (@id_1 	[int], @avgexchangerate_2 	[varchar](20), @endexchangerage_3 	[varchar](20), @fnayear_4 	[char](4), @periodsid_5 	[int], @flag                             integer output, @msg                             varchar(80) output )  AS declare @isclose char(1) select @isclose = isclose from FnaYearsPeriodsList where fnayear = @fnayear_4  and Periodsid = @periodsid_5  if @isclose = '1' begin select -1 return end  UPDATE [FnaCurrencyExchange]  SET  [avgexchangerate]	 = @avgexchangerate_2, [endexchangerage]	 = @endexchangerage_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE FnaCurrency_Insert 
 (@currencyname_1 	[varchar](60), @currencydesc_2 	[varchar](200), @activable_3 	[char](1), @isdefault_4 	[char](1), @flag                             integer output, @msg                             varchar(80) output )  AS declare @count integer select @count = count(id) from FnaCurrency where currencyname = @currencyname_1 if @count <>0 begin select -1 return end  if @isdefault_4 = '1' update FnaCurrency set isdefault = '0'  INSERT INTO [FnaCurrency] ( [currencyname], [currencydesc], [activable], [isdefault])  VALUES ( @currencyname_1, @currencydesc_2, @activable_3, @isdefault_4)  select max(id) from FnaCurrency 
GO

 CREATE PROCEDURE FnaCurrency_SelectAll 
 (@flag                             integer output, @msg                             varchar(80) output ) AS select * from FnaCurrency  if @@error<>0 begin set @flag=1 set @msg='查询币种信息成功' return end else begin set @flag=0 set @msg='查询币种信息失败' return end 
GO

 CREATE PROCEDURE FnaCurrency_SelectByDefault 
 (@flag                             integer output, @msg                             varchar(80) output ) AS select * from FnaCurrency where isdefault = '1' 
GO

 CREATE PROCEDURE FnaCurrency_SelectByID 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select * from FnaCurrency where id = @id_1 
GO

 CREATE PROCEDURE FnaCurrency_Update 
 (@id_1 	[int], @currencydesc_2 	[varchar](200), @activable_3 	[char](1), @isdefault 	[char](1), @flag                             integer output, @msg                             varchar(80) output )  AS if @isdefault = '1' begin update FnaCurrency set isdefault = '0' UPDATE [FnaCurrency] SET  [currencydesc]	 = @currencydesc_2, [activable]	 = @activable_3 , isdefault = '1' WHERE ( [id]	 = @id_1) end else begin UPDATE [FnaCurrency]  SET  [currencydesc]	 = @currencydesc_2, [activable]	 = @activable_3  WHERE ( [id]	 = @id_1) end 
GO

 CREATE PROCEDURE FnaDptToKingdee_Delete 
  (@flag integer output,
  @msg varchar(80) output)  
  AS 
  delete from FnaDptToKingdee

GO

 CREATE PROCEDURE FnaDptToKingdee_Insert 
 (@departmentid int,
  @kingdeecode  varchar(20),
  @flag integer output,
  @msg varchar(80) output)  
  AS    
  INSERT INTO FnaDptToKingdee(departmentid,kingdeecode )  VALUES ( @departmentid,@kingdeecode ) 
  if @@error<>0
  begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end

GO

 CREATE PROCEDURE FnaDptToKingdee_Select 
  (@flag integer output,
   @msg varchar(80) output)  
  AS 
  select * from FnaDptToKingdee

GO

 CREATE PROCEDURE FnaExpensefeeRules_Delete 
	@feeid		int,
	@resourceid int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	delete from FnaExpensefeeRules 
	where feeid=@feeid and resourceid=@resourceid

GO




--select * from htmllabelinfo where labelname like '%报%'
 CREATE PROCEDURE FnaExpensefeeRules_DByFeeid 
	@feeid		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	delete from FnaExpensefeeRules where feeid=@feeid

GO

 CREATE PROCEDURE FnaExpensefeeRules_Insert 
	@feeid		int,
	@resourceid int,
	@standardfee    decimal(10,3),
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into FnaExpensefeeRules (feeid,resourceid,standardfee)
	values (@feeid,@resourceid,@standardfee)

GO




--select * from htmllabelinfo where labelname like '%报%'
 CREATE PROCEDURE FnaExpensefeeRules_SByFandR 
	@feeid		int,
	@resourceid int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from FnaExpensefeeRules where feeid=@feeid and resourceid=@resourceid

GO




--select * from htmllabelinfo where labelname like '%报%'
 CREATE PROCEDURE FnaExpensefeeRules_SByFeeid 
	@feeid		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from FnaExpensefeeRules where feeid=@feeid

GO




--select * from htmllabelinfo where labelname like '%报%'
 CREATE PROCEDURE FnaExpensefeeRules_Update 
	@feeid		int,
	@resourceid int,
	@standardfee    decimal(10,3),
	@flag integer output , 
  	@msg varchar(80) output  
as
	Update FnaExpensefeeRules set standardfee=@standardfee
	where feeid=@feeid and resourceid=@resourceid

GO

 CREATE PROCEDURE FnaExpensefeeType_Delete 
	@id		int,
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	delete from fnaexpensefeetype where id=@id

GO

 CREATE PROCEDURE FnaExpensefeeType_Insert 
	@name	varchar(50),
	@remark	varchar(255),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	insert into fnaexpensefeetype (name,remark) values (@name,@remark)
	select max(id) from fnaExpensefeeType

GO

/* 9.2 */
 CREATE PROCEDURE FnaExpensefeeType_Select 
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	select * from fnaexpensefeetype order by id

GO

 CREATE PROCEDURE FnaExpensefeeType_SelectByID 
	@id		int,
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	select * from fnaexpensefeetype where id=@id

GO

 CREATE PROCEDURE FnaExpensefeeType_Update 
	@id		int,
	@name	varchar(50),
	@remark	varchar(250),
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	update fnaexpensefeetype set name=@name,remark=@remark where id=@id

GO

 CREATE PROCEDURE FnaIndicator_Delete 
 (@id_1 	[int], @indicatortype_2 	[char], @flag integer output , @msg varchar(80) output)  AS DELETE [FnaIndicator] WHERE ( [id]	 = @id_1)  if @indicatortype_2 = '0' delete FnaIndicatordetail where indicatorid = @id_1 
GO

 CREATE PROCEDURE FnaIndicator_Insert 
 (@indicatorname_1 	[varchar](60), @indicatordesc_2 	[varchar](200), @indicatortype_3 	[char](1), @indicatorbalance_4 	[char](1), @haspercent_5 	[char](1), @indicatoridfirst_6 	[int], @indicatoridlast_7 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [FnaIndicator] ( [indicatorname], [indicatordesc], [indicatortype], [indicatorbalance], [haspercent], [indicatoridfirst], [indicatoridlast])  VALUES ( @indicatorname_1, @indicatordesc_2, @indicatortype_3, @indicatorbalance_4, @haspercent_5, @indicatoridfirst_6, @indicatoridlast_7)  select max(id) from FnaIndicator 
GO

 CREATE PROCEDURE FnaIndicator_Select 
 @flag integer output , @msg varchar(80) output AS select * from FnaIndicator 
GO

 CREATE PROCEDURE FnaIndicator_SelectByID 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from FnaIndicator where id = @id 
GO

 CREATE PROCEDURE FnaIndicator_SelectMinYear 
 @flag integer output , @msg varchar(80) output AS select min(id) from FnaIndicator where  indicatortype='0' 
GO

 CREATE PROCEDURE FnaIndicator_Update 
 (@id_1 	[int], @indicatorname_2 	[varchar](60), @indicatordesc_3 	[varchar](200), @indicatorbalance_4 	[char](1), @haspercent_5 	[char](1), @indicatoridfirst_6 	[int], @indicatoridlast_7 	[int], @flag integer output , @msg varchar(80) output)  AS UPDATE [FnaIndicator]  SET  [indicatorname]	 = @indicatorname_2, [indicatordesc]	 = @indicatordesc_3, [indicatorbalance]	 = @indicatorbalance_4, [haspercent]	 = @haspercent_5, [indicatoridfirst]	 = @indicatoridfirst_6, [indicatoridlast]	 = @indicatoridlast_7  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE FnaIndicatordetail_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [FnaIndicatordetail]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE FnaIndicatordetail_Insert 
 (@indicatorid_1 	[int], @ledgerid_2 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [FnaIndicatordetail] ( [indicatorid], [ledgerid]) VALUES ( @indicatorid_1, @ledgerid_2) 
GO

 CREATE PROCEDURE FnaIndicatordetail_SelectByID 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from FnaIndicatordetail where indicatorid = @id 
GO

 CREATE PROCEDURE FnaLedgerCategory_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count integer select @count = count(id) from FnaLedger where categoryid = @id_1 if @count <> 0 begin select '20' return end  DELETE [FnaLedgerCategory] WHERE  ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE FnaLedgerCategory_Insert 
 (@categoryname_1 	[varchar](60), @categorydesc_2 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [FnaLedgerCategory] ( [categoryname], [categorydesc]) VALUES ( @categoryname_1, @categorydesc_2) select max(id) from FnaLedgerCategory 
GO

 CREATE PROCEDURE FnaLedgerCategory_Select 
 @flag integer output , @msg varchar(80) output AS select * from FnaLedgerCategory 
GO

 CREATE PROCEDURE FnaLedgerCategory_SelectByID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select * from FnaLedgerCategory where id = @id_1 
GO

 CREATE PROCEDURE FnaLedgerCategory_Update 
 (@id_1 	[int], @categoryname_2 	[varchar](60), @categorydesc_3 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS UPDATE [FnaLedgerCategory]  SET  [categoryname]	 = @categoryname_2, [categorydesc]	 = @categorydesc_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE FnaLedger_Delete 
 (@id_1 	[int], @supledgerid_2 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count integer select @count = subledgercount from FnaLedger where [id] = @id_1 if @count <> 0 begin select '20' return end  select @count = count(id) from FnaTransactionDetail where ledgerid = @id_1 if @count <> 0 begin select '20' return end  DELETE [FnaLedger] WHERE ( [id]	 = @id_1 ) if  @supledgerid_2 <> 0 begin update FnaLedger set subledgercount = subledgercount-1 where id = @supledgerid_2 end  delete FnaAccount where ledgerid = @id_1 
GO

 CREATE PROCEDURE FnaLedger_DeleteAuto 
 (@crmcode 	[varchar](20), @crmtype 	[char](1), @flag integer output , @msg varchar(80) output)  AS declare @count integer declare @ledgermark_1 [varchar](60), @ledgermark_2 [varchar](60), @ledgerid_1 int, @ledgerid_2 int declare @supledgerid_1 int, @supledgerid_2 int  if @crmtype = '1' begin select @ledgermark_1 = ledgermark from FnaLedger where autosubledger = '1' select @ledgermark_2 = ledgermark from FnaLedger where autosubledger = '2' end  if @crmtype = '2' begin select @ledgermark_1 = ledgermark from FnaLedger where autosubledger = '3' select @ledgermark_2 = ledgermark from FnaLedger where autosubledger = '4' end  select @ledgerid_1 = id , @supledgerid_1 = supledgerid from FnaLedger where  ledgermark = (@ledgermark_1 + @crmcode) select @count = count(id) from FnaTransactionDetail where ledgerid = @ledgerid_1 if @count <> 0 begin select 2 return end   select @ledgerid_2 = id , @supledgerid_2 = supledgerid from FnaLedger where  ledgermark = (@ledgermark_2 + @crmcode) select @count = count(id) from FnaTransactionDetail where ledgerid = @ledgerid_2 if @count <> 0 begin select 2 return end  delete FnaLedger where id = @ledgerid_1 delete FnaLedger where id = @ledgerid_2  update FnaLedger set subledgercount = subledgercount-1 where id = @supledgerid_1 update FnaLedger set subledgercount = subledgercount-1 where id = @supledgerid_2  select 0 
GO

 CREATE PROCEDURE FnaLedger_Insert 
 (@ledgermark_1 	[varchar](60), @ledgername_2 	[varchar](200), @ledgertype_3 	[char](1), @ledgergroup_4 	[char](1), @ledgerbalance_5 	[char](1), @autosubledger_6 	[char](1), @ledgercurrency_7 	[char](1), @supledgerid_8 	[int], @categoryid_9 	[int], @supledgerall_10 	[varchar](100), @flag integer output , @msg varchar(80) output)  AS declare @count integer , @init decimal(18,3)  if @supledgerid_8 <> 0 begin  select @init = initaccount from FnaLedger where id = @supledgerid_8 if @init <> 0 begin select -1 return end  select @count = count(id) from FnaTransactionDetail where ledgerid = @supledgerid_8 if @count <> 0 begin select -1 return end  /*不能自动明细手动加入  暂时不考虑 select @count = count(id) from FnaLedger where autosubledger != '0' and id =  @supledgerid_8 if @count <> 0 begin select -4 return end */  end  /*不能有相同的标识*/ select @count = count(id) from FnaLedger where ledgermark = @ledgermark_1 if @count <> 0 begin select -2 return end  /*不能有相同的自动明细类型*/ if @autosubledger_6 <> '0' begin select @count = count(id) from FnaLedger where autosubledger = @autosubledger_6 if @count <> 0 begin select -3 return end end   INSERT INTO [FnaLedger] ( [ledgermark], [ledgername], [ledgertype], [ledgergroup], [ledgerbalance], [autosubledger], [ledgercurrency], [supledgerid], [categoryid], [supledgerall])  VALUES ( @ledgermark_1, @ledgername_2, @ledgertype_3, @ledgergroup_4, @ledgerbalance_5, @autosubledger_6, @ledgercurrency_7, @supledgerid_8, @categoryid_9, @supledgerall_10)  if @supledgerid_8 <> 0 begin update FnaLedger set subledgercount = subledgercount+1 where id = @supledgerid_8 end select max(id) from FnaLedger 
GO

 CREATE PROCEDURE FnaLedger_InsertAuto 
 (@crmname 	[varchar](60), @crmtype 	[char](1), @crmcode 	[varchar](20), @flag integer output , @msg varchar(80) output)  AS  declare @count integer , @init decimal(18,3) declare @ledgermark_1 [varchar](60), @ledgername_2 [varchar](200), @ledgertype_3 [char](1), @ledgergroup_4  [char](1) declare	@ledgerbalance_5 [char](1), @ledgercurrency_7 [char](1), @supledgerid_8 [int] declare @categoryid_9 [int], @supledgerall_10 [varchar](100), @ledgerid1 int , @ledgerid2 int  if @crmtype = '1' begin  select @ledgermark_1 = ledgermark from FnaLedger where autosubledger = '1' select @count = count(id) from FnaLedger where  ledgermark = (@ledgermark_1 + @crmcode) if @count <> 0 begin select 1,0,0 return end  select @ledgermark_1 = ledgermark from FnaLedger where autosubledger = '2' select @count = count(id) from FnaLedger where  ledgermark = (@ledgermark_1 + @crmcode) if @count <> 0 begin select 1,0,0 return end  select @ledgermark_1 = ledgermark, @ledgername_2= ledgername, @ledgertype_3= ledgertype, @ledgergroup_4=ledgergroup, @ledgerbalance_5= ledgerbalance, @ledgercurrency_7=ledgercurrency, @supledgerid_8=id , @categoryid_9=categoryid , @supledgerall_10 = supledgerall from FnaLedger where autosubledger = '1' set @ledgermark_1 = @ledgermark_1 + @crmcode set @ledgername_2 = @ledgername_2 + '-' + @crmname set @supledgerall_10 = @supledgerall_10 + convert(varchar(10), @supledgerid_8) +'|'  INSERT INTO [FnaLedger] ( [ledgermark], [ledgername], [ledgertype], [ledgergroup], [ledgerbalance], [autosubledger], [ledgercurrency], [supledgerid], [categoryid], [supledgerall])  VALUES ( @ledgermark_1, @ledgername_2, @ledgertype_3, @ledgergroup_4, @ledgerbalance_5, '0', @ledgercurrency_7, @supledgerid_8, @categoryid_9, @supledgerall_10)  select @ledgerid1 = max(id) from FnaLedger update FnaLedger set subledgercount = subledgercount+1 where id = @supledgerid_8  select @ledgermark_1 = ledgermark, @ledgername_2= ledgername, @ledgertype_3= ledgertype, @ledgergroup_4=ledgergroup, @ledgerbalance_5= ledgerbalance, @ledgercurrency_7=ledgercurrency, @supledgerid_8=id , @categoryid_9=categoryid , @supledgerall_10 = supledgerall from FnaLedger where autosubledger = '2' set @ledgermark_1 = @ledgermark_1 + @crmcode set @ledgername_2 = @ledgername_2 + '-' + @crmname set @supledgerall_10 = @supledgerall_10 + convert(varchar(10), @supledgerid_8) +'|'  INSERT INTO [FnaLedger] ( [ledgermark], [ledgername], [ledgertype], [ledgergroup], [ledgerbalance], [autosubledger], [ledgercurrency], [supledgerid], [categoryid], [supledgerall])  VALUES ( @ledgermark_1, @ledgername_2, @ledgertype_3, @ledgergroup_4, @ledgerbalance_5, '0', @ledgercurrency_7, @supledgerid_8, @categoryid_9, @supledgerall_10)  select @ledgerid2 = max(id) from FnaLedger update FnaLedger set subledgercount = subledgercount+1 where id = @supledgerid_8  end  if @crmtype = '2' begin  select @ledgermark_1 = ledgermark from FnaLedger where autosubledger = '3' select @count = count(id) from FnaLedger where  ledgermark = (@ledgermark_1 + @crmcode) if @count <> 0 begin select 1,0,0 return end  select @ledgermark_1 = ledgermark from FnaLedger where autosubledger = '4' select @count = count(id) from FnaLedger where  ledgermark = (@ledgermark_1 + @crmcode) if @count <> 0 begin select 1,0,0 return end  select @ledgermark_1 = ledgermark, @ledgername_2= ledgername, @ledgertype_3= ledgertype, @ledgergroup_4=ledgergroup, @ledgerbalance_5= ledgerbalance, @ledgercurrency_7=ledgercurrency, @supledgerid_8=id , @categoryid_9=categoryid , @supledgerall_10 = supledgerall from FnaLedger where autosubledger = '3' set @ledgermark_1 = @ledgermark_1 + @crmcode set @ledgername_2 = @ledgername_2 + '-' + @crmname set @supledgerall_10 = @supledgerall_10 + convert(varchar(10), @supledgerid_8) +'|'  INSERT INTO [FnaLedger] ( [ledgermark], [ledgername], [ledgertype], [ledgergroup], [ledgerbalance], [autosubledger], [ledgercurrency], [supledgerid], [categoryid], [supledgerall])  VALUES ( @ledgermark_1, @ledgername_2, @ledgertype_3, @ledgergroup_4, @ledgerbalance_5, '0', @ledgercurrency_7, @supledgerid_8, @categoryid_9, @supledgerall_10)  select @ledgerid1 = max(id) from FnaLedger update FnaLedger set subledgercount = subledgercount+1 where id = @supledgerid_8  select @ledgermark_1 = ledgermark, @ledgername_2= ledgername, @ledgertype_3= ledgertype, @ledgergroup_4=ledgergroup, @ledgerbalance_5= ledgerbalance, @ledgercurrency_7=ledgercurrency, @supledgerid_8=id , @categoryid_9=categoryid , @supledgerall_10 = supledgerall from FnaLedger where autosubledger = '4' set @ledgermark_1 = @ledgermark_1 + @crmcode set @ledgername_2 = @ledgername_2 + '-' + @crmname set @supledgerall_10 = @supledgerall_10 + convert(varchar(10), @supledgerid_8) +'|'  INSERT INTO [FnaLedger] ( [ledgermark], [ledgername], [ledgertype], [ledgergroup], [ledgerbalance], [autosubledger], [ledgercurrency], [supledgerid], [categoryid], [supledgerall])  VALUES ( @ledgermark_1, @ledgername_2, @ledgertype_3, @ledgergroup_4, @ledgerbalance_5, '0', @ledgercurrency_7, @supledgerid_8, @categoryid_9, @supledgerall_10)  select @ledgerid2 = max(id) from FnaLedger update FnaLedger set subledgercount = subledgercount+1 where id = @supledgerid_8  end  select 0, @ledgerid1, @ledgerid2 
GO

 CREATE PROCEDURE FnaLedger_Select 
 @flag integer output , @msg varchar(80) output AS select * from FnaLedger order by ledgermark 
GO

 CREATE PROCEDURE FnaLedger_SelectByID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS declare @count integer ,@count1 integer select @count = count(id) from FnaAccountList where ledgerid = @id_1 select @count1 = count(id) from FnaYearsPeriodsList where isclose = '1' set @count = @count + @count1 select id,ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance, autosubledger,ledgercurrency,supledgerid,subledgercount,categoryid, initaccount, 'accountnum'=@count from FnaLedger  where id = @id_1 
GO

 CREATE PROCEDURE FnaLedger_SelectCountByBabance 
 (@flag integer output , @msg varchar(80) output)  AS declare @assetcount int , @debitcount int select @assetcount = count(id) from FnaLedger where supledgerid =0 and ledgergroup ='1'  select @debitcount = count(id) from FnaLedger where supledgerid =0 and (ledgergroup ='2' or ledgergroup ='3' )  select @assetcount , @debitcount 
GO

 CREATE PROCEDURE FnaLedger_SelectSupLedgerall 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select supledgerall from FnaLedger  where id = @id_1 
GO

 CREATE PROCEDURE FnaLedger_Update 
 (@id_1 	[int], @ledgermark_2 	[varchar](60), @ledgername_3 	[varchar](200), @ledgertype_4 	[char](1), @ledgergroup_5 	[char](1), @ledgerbalance_6 	[char](1), @autosubledger_7 	[char](1), @ledgercurrency_8 	[char](1), @initaccount_9         decimal(18,3), @doinit_10              char(1), @flag integer output , @msg varchar(80) output)  AS declare @count integer if @autosubledger_7 <> '0' begin select @count = count(id) from FnaLedger where autosubledger = @autosubledger_7 and id != @id_1 if @count <> 0 begin select -3 return end end   UPDATE [FnaLedger]  SET  [ledgermark]	 = @ledgermark_2, [ledgername]	 = @ledgername_3, [ledgertype]	 = @ledgertype_4, [ledgergroup]	 = @ledgergroup_5, [ledgerbalance]	 = @ledgerbalance_6, [autosubledger]	 = @autosubledger_7, [ledgercurrency]	 = @ledgercurrency_8, [initaccount]	 = @initaccount_9  WHERE ( [id]	 = @id_1)  if @doinit_10 = '1' begin  delete FnaAccount where ledgerid = @id_1 insert into FnaAccount(ledgerid,tranperiods,tranremain) values(@id_1,'000000',@initaccount_9)  end 
GO

 CREATE PROCEDURE FnaLedger_UpdateAuto 
 (@oldcrmcode 	[varchar](20), @crmcode 	[varchar](20), @crmtype 	[char](1), @flag integer output , @msg varchar(80) output)  AS  declare @count integer declare @ledgermark_1 [varchar](60), @ledgermark_2 [varchar](60), @ledgerid_1 int, @ledgerid_2 int  if @crmtype = '1' begin select @ledgermark_1 = ledgermark from FnaLedger where autosubledger = '1' select @ledgermark_2 = ledgermark from FnaLedger where autosubledger = '2' end  if @crmtype = '2' begin select @ledgermark_1 = ledgermark from FnaLedger where autosubledger = '3' select @ledgermark_2 = ledgermark from FnaLedger where autosubledger = '4' end  select @count = count(id) from FnaLedger where  ledgermark = (@ledgermark_1 + @crmcode) if @count <> 0 begin select 1 return end  select @ledgerid_1 = id from FnaLedger where  ledgermark = (@ledgermark_1 + @oldcrmcode) select @count = count(id) from FnaTransactionDetail where ledgerid = @ledgerid_1 if @count <> 0 begin select 2 return end  select @count = count(id) from FnaLedger where  ledgermark = (@ledgermark_2 + @crmcode) if @count <> 0 begin select 1 return end  select @ledgerid_2 = id from FnaLedger where  ledgermark = (@ledgermark_2 + @oldcrmcode) select @count = count(id) from FnaTransactionDetail where ledgerid = @ledgerid_2 if @count <> 0 begin select 2 return end  update FnaLedger set ledgermark = (@ledgermark_1 + @crmcode) where id = @ledgerid_1 update FnaLedger set ledgermark = (@ledgermark_2 + @crmcode) where id = @ledgerid_2  select 0 
GO

 CREATE PROCEDURE FnaTransactionDetail_Insert 
 (@tranid_1 	[int], @ledgerid_2 	[int], @tranaccount_3 	[decimal](18,3), @trandefaccount_3 	[decimal](18,3), @tranbalance_4 	[char](1), @tranremark_5 	[varchar](200), @flag                             integer output, @msg                             varchar(80) output )  AS INSERT INTO [FnaTransactionDetail] ( [tranid], [ledgerid], [tranaccount], [trandefaccount], [tranbalance], [tranremark])  VALUES ( @tranid_1, @ledgerid_2, @tranaccount_3, @trandefaccount_3 , @tranbalance_4, @tranremark_5) 
GO

 CREATE PROCEDURE FnaTransactionDetail_SByID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select * from FnaTransactionDetail where tranid = @id_1 
GO

 CREATE PROCEDURE FnaTransaction_Approve 
 @id_1 	[int], @approverid  [int], @approverdate  char(10), @flag integer output , @msg varchar(80) output AS declare @count1 decimal(18,3) , @count2 decimal(18,3),@count0 integer select @count0 = count(id) from FnaTransaction where id = @id_1 and createrid = @approverid  if @count0 <> 0 begin select -1 return end  select @count1= sum(tranaccount) from FnaTransactionDetail where tranid = @id_1 and tranbalance = '1'  select @count2= sum(tranaccount) from FnaTransactionDetail where tranid = @id_1 and tranbalance = '2'  if @count1 is null set @count1 = 0 if @count2 is null set @count2 = 0  if @count1 <> @count2 begin select -2 return end  update FnaTransaction set transtatus='1' , approverid=@approverid , approverdate=@approverdate where id = @id_1  select tranperiods from FnaTransaction where id = @id_1 
GO

 CREATE PROCEDURE FnaTransaction_Delete 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output )  AS select tranperiods from FnaTransaction where [id] = @id_1  DELETE [FnaTransaction] WHERE  ( [id]	 = @id_1)  DELETE [FnaTransactionDetail] WHERE  ( [tranid]	 = @id_1) 
GO

 CREATE PROCEDURE FnaTransaction_Insert 
 (@tranmark_1 	[varchar](60), @trandate_2 	[char](10), @trandepartmentid_3 	[int], @trancostercenterid_4 	[int], @trancurrencyid_5 	[int], @trandefcurrencyid_6 	[int], @tranexchangerate_7 	[varchar](20), @tranaccessories_8 	[tinyint], @tranresourceid_9 	[int], @trancrmid_10 	[int], @tranitemid_11 	[int], @trandocid_12 	[int], @tranprojectid_13 	[int], @trandaccount_14 	[decimal](18,3), @trancaccount_15 	[decimal](18,3), @trandefdaccount_16 	[decimal](18,3), @trandefcaccount_17 	[decimal](18,3), @tranremark_18 	[varchar](250), @transtatus_19 	[char](1), @createrid_20 	[int], @createdate_21 	[char](10), @flag                             integer output, @msg                             varchar(80) output )  AS declare @count integer , @fnayear char(4) , @periodsid integer , @isclose char(1), @fnayearp char(6)  select @count = count(id) from FnaTransaction where tranmark = @tranmark_1 if @count <> 0 begin select -1,'0' return end  select @count = count(id) from FnaYearsPeriodsList where isclose = '0' and isactive = '1' and startdate <= @trandate_2 and enddate >= @trandate_2  if @count = 0 begin select -2,'0' return end   select @fnayear = '' , @periodsid = 0 ,  @fnayearp = '' select @fnayear=fnayear , @periodsid=Periodsid from FnaYearsPeriodsList where startdate <= @trandate_2 and enddate >= @trandate_2   if @periodsid < 9 select @fnayearp = @fnayear + '0' + convert(char(1) , @periodsid) else select @fnayearp = @fnayear + convert(char(2) , @periodsid)    INSERT INTO [FnaTransaction] ( [tranmark], [trandate], [tranperiods], [trandepartmentid], [trancostercenterid], [trancurrencyid], [trandefcurrencyid], [tranexchangerate], [tranaccessories], [tranresourceid], [trancrmid], [tranitemid], [trandocid], [tranprojectid], [trandaccount], [trancaccount], [trandefdaccount], [trandefcaccount], [tranremark], [transtatus], [createrid], [createdate])  VALUES ( @tranmark_1, @trandate_2, @fnayearp , @trandepartmentid_3, @trancostercenterid_4, @trancurrencyid_5, @trandefcurrencyid_6, @tranexchangerate_7, @tranaccessories_8, @tranresourceid_9, @trancrmid_10, @tranitemid_11, @trandocid_12, @tranprojectid_13, @trandaccount_14, @trancaccount_15, @trandefdaccount_16, @trandefcaccount_17, @tranremark_18, @transtatus_19, @createrid_20, @createdate_21)  select max(id) , @fnayearp from FnaTransaction 
GO

 CREATE PROCEDURE FnaTransaction_Reopen 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS update FnaTransaction set transtatus='0' , approverid = null , approverdate=null where id = @id_1  select tranperiods from FnaTransaction where [id] = @id_1 
GO

 CREATE PROCEDURE FnaTransaction_SelectByID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select * from FnaTransaction where id = @id_1 
GO

 CREATE PROCEDURE FnaTransaction_SelectByMaxmark 
 (@flag                             integer output, @msg                             varchar(80) output )  AS select max(tranmark) from FnaTransaction 
GO

 CREATE PROCEDURE FnaTransaction_Update 
 (@id_1 	[int], @trandate_2 	[char](10), @trandepartmentid_3 	[int], @trancostercenterid_4 	[int], @trancurrencyid_5 	[int], @trandefcurrencyid_6 	[int], @tranexchangerate_7 	[varchar](20), @tranaccessories_8 	[tinyint], @tranresourceid_9 	[int], @trancrmid_10 	[int], @tranitemid_11 	[int], @trandocid_12 	[int], @tranprojectid_13 	[int], @trandaccount_14 	[decimal](18,3), @trancaccount_15 	[decimal](18,3), @trandefdaccount_16 	[decimal](18,3), @trandefcaccount_17 	[decimal](18,3), @tranremark_18 	[varchar](250), @transtatus_19 	[char](1), @createrid_20 	[int], @createdate_21 	[char](10), @flag                             integer output, @msg                             varchar(80) output )  AS declare @count integer , @fnayear char(4) , @periodsid integer ,  @fnayearp char(6)  select @count = count(id) from FnaYearsPeriodsList where isclose = '0' and isactive = '1' and startdate <= @trandate_2 and enddate >= @trandate_2  if @count = 0 begin select -2 return end   select @fnayear = '' , @periodsid = 0 ,  @fnayearp = '' select @fnayear=fnayear , @periodsid=Periodsid from FnaYearsPeriodsList where startdate <= @trandate_2 and enddate >= @trandate_2   if @periodsid < 9 select @fnayearp = @fnayear + '0' + convert(char(1) , @periodsid) else select @fnayearp = @fnayear + convert(char(2) , @periodsid)  UPDATE [FnaTransaction]  SET	 [trandate]	 = @trandate_2, [tranperiods]   = @fnayearp , [trandepartmentid]	 = @trandepartmentid_3, [trancostercenterid]	 = @trancostercenterid_4, [trancurrencyid]	 = @trancurrencyid_5, [trandefcurrencyid]	 = @trandefcurrencyid_6, [tranexchangerate]	 = @tranexchangerate_7, [tranaccessories]	 = @tranaccessories_8, [tranresourceid]	 = @tranresourceid_9, [trancrmid]	 = @trancrmid_10, [tranitemid]	 = @tranitemid_11, [trandocid]	 = @trandocid_12, [tranprojectid]	 = @tranprojectid_13, [trandaccount]	 = @trandaccount_14, [trancaccount]	 = @trancaccount_15, [trandefdaccount]	 = @trandefdaccount_16, [trandefcaccount]	 = @trandefcaccount_17, [tranremark]	 = @tranremark_18, [transtatus]	 = @transtatus_19, [createrid]	 = @createrid_20, [createdate]	 = @createdate_21  WHERE ( [id]	 = @id_1)  DELETE [FnaTransactionDetail] WHERE  ( [tranid]	 = @id_1)  select @fnayearp 
GO

 CREATE PROCEDURE FnaYearsPeriodsList_Close 
 (@id_1 	[int], @fnayearperiods  char(6), @flag integer output , @msg varchar(80) output)  AS declare @count integer  /* 判断是否有未关闭的前一周期 */ select @count = count(id) from FnaYearsPeriodsList where fnayearperiodsid < @fnayearperiods and isactive = '1' and isclose ='0'  if @count <> 0 begin select -1 return end  /* 判断是否有未登帐的本期分录 */ select @count = count(id) from FnaTransaction where transtatus != '2' and tranperiods = @fnayearperiods  if @count <> 0 begin select -2 return end   /* 判断是否有未登帐的本期预算 */ select @count = count(id) from FnaBudget where budgetstatus != '2' and budgetperiods = @fnayearperiods  if @count <> 0 begin select -2 return end    /* 开始进行统计 */ delete FnaAccount where tranperiods = @fnayearperiods delete FnaAccountDepartment where tranperiods = @fnayearperiods delete FnaAccountCostcenter where tranperiods = @fnayearperiods delete FnaBudgetDepartment where budgetperiods = @fnayearperiods delete FnaBudgetCostcenter where budgetperiods = @fnayearperiods  declare @ledgerid int , @departmentid int , @costcenterid int,@trandaccount decimal(18,3),@trancaccount decimal(18,3) declare @ledgerbalance char(1) , @subledgercount int ,@tranremain decimal(18,3),@tmptranperiods char(6) declare @tmplegderstr  varchar(30),@budgetmoduleid int,@budgetaccount decimal(18,3),@budgetperiods char(6)  /* 将所有明细(subledgercount = 0) 科目进行总帐统计 */ declare ledgerid_cursor cursor for select id from  FnaLedger where subledgercount = 0  open ledgerid_cursor fetch next from ledgerid_cursor into @ledgerid while @@fetch_status=0 begin set @trandaccount = 0 set @trancaccount = 0 set @tranremain = 0 select @count = count(id) ,@tmptranperiods = max(tranperiods) from FnaAccount where ledgerid = @ledgerid if @count <> 0 begin select @tranremain = tranremain from FnaAccount where ledgerid = @ledgerid and tranperiods = @tmptranperiods end select @ledgerbalance=ledgerbalance from FnaLedger where id = @ledgerid select @trandaccount = sum(tranaccount) from FnaAccountList where ledgerid = @ledgerid and tranperiods = @fnayearperiods and tranbalance = '1' select @trancaccount = sum(tranaccount) from FnaAccountList where ledgerid = @ledgerid and tranperiods = @fnayearperiods and tranbalance = '2' if @trandaccount is null set @trandaccount = 0 if @trancaccount is null set @trancaccount = 0 if @tranremain is null set @tranremain = 0  if @ledgerbalance = '1' set @tranremain = @tranremain + @trandaccount - @trancaccount else set @tranremain = @tranremain - @trandaccount + @trancaccount  insert into FnaAccount(ledgerid,tranperiods,trandaccount,trancaccount,tranremain,tranbalance) values(@ledgerid,@fnayearperiods,@trandaccount,@trancaccount,@tranremain,@ledgerbalance) fetch next from ledgerid_cursor into @ledgerid end close ledgerid_cursor deallocate ledgerid_cursor   /*将所有明细科目和部门的分录进行统计 ,按部门和明细科目*/ declare departmentid_cursor cursor for select ledgerid, trandepartmentid from  FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid and tranperiods = @fnayearperiods group by ledgerid , trandepartmentid  open departmentid_cursor fetch next from departmentid_cursor into @ledgerid,@departmentid while @@fetch_status=0 begin set @trandaccount = 0 set @trancaccount = 0 set @tranremain = 0 select @ledgerbalance =ledgerbalance from FnaLedger where id = @ledgerid select @trandaccount = sum(trandefaccount) from FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid and tranperiods = @fnayearperiods and ledgerid = @ledgerid and trandepartmentid=@departmentid and tranbalance = '1' select @trancaccount = sum(trandefaccount) from FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid and tranperiods = @fnayearperiods and ledgerid = @ledgerid and trandepartmentid=@departmentid and tranbalance = '2' if @trandaccount is null set @trandaccount = 0 if @trancaccount is null set @trancaccount = 0 if @ledgerbalance = '1' set @tranremain = @trandaccount - @trancaccount else set @tranremain = @trancaccount - @trandaccount  insert into FnaAccountDepartment(ledgerid,departmentid,tranperiods,tranaccount,tranbalance) values(@ledgerid,@departmentid,@fnayearperiods,@tranremain,@ledgerbalance) fetch next from departmentid_cursor into @ledgerid,@departmentid end close departmentid_cursor deallocate departmentid_cursor   /*将所有明细科目和成本中心的分录进行统计 ,按成本中心和明细科目*/ declare costcenterid_cursor cursor for select ledgerid, trancostercenterid from  FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid and tranperiods = @fnayearperiods group by ledgerid , trancostercenterid  open costcenterid_cursor fetch next from costcenterid_cursor into @ledgerid,@costcenterid while @@fetch_status=0 begin set @trandaccount = 0 set @trancaccount = 0 set @tranremain = 0 select @ledgerbalance =ledgerbalance from FnaLedger where id = @ledgerid select @trandaccount = sum(trandefaccount) from FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid and tranperiods = @fnayearperiods and ledgerid = @ledgerid and trancostercenterid=@costcenterid and tranbalance = '1' select @trancaccount = sum(trandefaccount) from FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid and tranperiods = @fnayearperiods and ledgerid = @ledgerid and trancostercenterid=@costcenterid and tranbalance = '2' if @trandaccount is null set @trandaccount = 0 if @trancaccount is null set @trancaccount = 0 if @ledgerbalance = '1' set @tranremain = @trandaccount - @trancaccount else set @tranremain = @trancaccount - @trandaccount  insert into FnaAccountCostcenter(ledgerid,costcenterid,tranperiods,tranaccount,tranbalance) values(@ledgerid,@costcenterid,@fnayearperiods,@tranremain,@ledgerbalance) fetch next from costcenterid_cursor into @ledgerid,@costcenterid end close costcenterid_cursor deallocate costcenterid_cursor  /*将所有明细科目和部门的预算进行统计 ,按部门和明细科目*/  declare departmentbudgetid_cursor cursor for select ledgerid, budgetdepartmentid,budgetmoduleid, sum(budgetaccount) from  FnaBudgetList where budgetperiods = @fnayearperiods group by ledgerid ,budgetmoduleid, budgetdepartmentid  open departmentbudgetid_cursor fetch next from departmentbudgetid_cursor into @ledgerid,@departmentid,@budgetmoduleid,@budgetaccount while @@fetch_status=0 begin insert into FnaBudgetDepartment(ledgerid,departmentid,budgetmoduleid,budgetperiods,budgetaccount) values(@ledgerid,@departmentid,@budgetmoduleid,@fnayearperiods,@budgetaccount) fetch next from departmentbudgetid_cursor into @ledgerid,@departmentid,@budgetmoduleid,@budgetaccount end close departmentbudgetid_cursor deallocate departmentbudgetid_cursor    /*将所有明细科目和成本中心的预算进行统计 ,按成本中心和明细科目*/  declare costcenterbudgetid_cursor cursor for select ledgerid, budgetcostcenterid,budgetmoduleid, sum(budgetaccount) from  FnaBudgetList where budgetperiods = @fnayearperiods group by ledgerid ,budgetmoduleid, budgetcostcenterid  open costcenterbudgetid_cursor fetch next from costcenterbudgetid_cursor into @ledgerid,@costcenterid,@budgetmoduleid,@budgetaccount while @@fetch_status=0 begin insert into FnaBudgetCostcenter(ledgerid,costcenterid,budgetmoduleid,budgetperiods,budgetaccount) values(@ledgerid,@costcenterid,@budgetmoduleid,@fnayearperiods,@budgetaccount) fetch next from costcenterbudgetid_cursor into @ledgerid,@costcenterid,@budgetmoduleid,@budgetaccount end close costcenterbudgetid_cursor deallocate costcenterbudgetid_cursor    /*对所有总帐(非明细科目)进行统计, 记入总帐*/ declare ledgeridsup_cursor cursor for select id from  FnaLedger where subledgercount != 0  open ledgeridsup_cursor fetch next from ledgeridsup_cursor into @ledgerid while @@fetch_status=0 begin set @trandaccount = 0 set @trancaccount = 0 set @tranremain = 0 set @tmplegderstr = '%' + convert(varchar(10),@ledgerid) + '|%' select @count = count(id) ,@tmptranperiods = max(tranperiods) from FnaAccount where ledgerid = @ledgerid if @count <> 0 begin select @tranremain = tranremain from FnaAccount where ledgerid = @ledgerid and tranperiods = @tmptranperiods end select @ledgerbalance =ledgerbalance from FnaLedger where id = @ledgerid select @trandaccount = sum(a.trandaccount) , @trancaccount = sum(a.trancaccount) from FnaAccount a , FnaLedger b where a.ledgerid = b.id and b.supledgerall like @tmplegderstr and b.subledgercount = 0 and a.tranperiods = @fnayearperiods  if @trandaccount is null set @trandaccount = 0 if @trancaccount is null set @trancaccount = 0 if @tranremain is null set @tranremain = 0 if @ledgerbalance = '1' set @tranremain = @tranremain + @trandaccount - @trancaccount else set @tranremain = @tranremain - @trandaccount + @trancaccount insert into FnaAccount(ledgerid,tranperiods,trandaccount,trancaccount,tranremain,tranbalance) values(@ledgerid,@fnayearperiods,@trandaccount,@trancaccount,@tranremain,@ledgerbalance) fetch next from ledgeridsup_cursor into @ledgerid end close ledgeridsup_cursor deallocate ledgeridsup_cursor   /*建立临时表, 保存部门和总帐(非明细), 成本中心和总帐(非明细) 的所有记录 */ create table #tempdepartment( ledgerid  int , departmentid  int, ledgerbalance  char(1) )  create table #tempcostcenter( ledgerid  int , costcenterid  int, ledgerbalance  char(1) )  declare ledgerdepartment_cursor cursor for select a.id , b.id , a.ledgerbalance from  FnaLedger a, HrmDepartment b where subledgercount != 0  open ledgerdepartment_cursor fetch next from ledgerdepartment_cursor into @ledgerid,@departmentid,@ledgerbalance while @@fetch_status=0 begin insert into #tempdepartment values(@ledgerid,@departmentid,@ledgerbalance) fetch next from ledgerdepartment_cursor into @ledgerid,@departmentid,@costcenterid end close ledgerdepartment_cursor deallocate ledgerdepartment_cursor  declare ledgercostcenter_cursor cursor for select a.id , b.id , a.ledgerbalance from  FnaLedger a, HrmCostcenter b where subledgercount != 0  open ledgercostcenter_cursor fetch next from ledgercostcenter_cursor into @ledgerid,@costcenterid,@ledgerbalance while @@fetch_status=0 begin insert into #tempcostcenter values(@ledgerid,@costcenterid,@ledgerbalance) fetch next from ledgercostcenter_cursor into @ledgerid,@costcenterid,@ledgerbalance end close ledgercostcenter_cursor deallocate ledgercostcenter_cursor   /*将所有的总帐与部门的收支进行统计 */ declare departmentsupledger_cursor cursor for select * from #tempdepartment  open departmentsupledger_cursor fetch next from departmentsupledger_cursor into @ledgerid,@departmentid,@ledgerbalance while @@fetch_status=0 begin set @trandaccount = 0 set @trancaccount = 0 set @tranremain = 0 set @tmplegderstr = '%' + convert(varchar(10),@ledgerid) + '|%' select @trandaccount = sum(a.tranaccount) from FnaAccountDepartment a , FnaLedger b where a.ledgerid = b.id and b.supledgerall like @tmplegderstr and a.departmentid = @departmentid and a.tranperiods = @fnayearperiods and a.tranbalance = @ledgerbalance select @trancaccount = sum(a.tranaccount) from FnaAccountDepartment a , FnaLedger b where a.ledgerid = b.id and b.supledgerall like @tmplegderstr and a.departmentid = @departmentid and a.tranperiods = @fnayearperiods and a.tranbalance != @ledgerbalance if @trandaccount is null set @trandaccount = 0 if @trancaccount is null set @trancaccount = 0 set @tranremain = @trandaccount - @trancaccount if @tranremain <> 0 begin insert into FnaAccountDepartment(ledgerid,departmentid,tranperiods,tranaccount,tranbalance) values(@ledgerid,@departmentid,@fnayearperiods,@tranremain,@ledgerbalance) end fetch next from departmentsupledger_cursor into @ledgerid,@departmentid,@ledgerbalance end close departmentsupledger_cursor deallocate departmentsupledger_cursor   /*将所有的总帐与成本中心的收支进行统计 */ declare costcentersupledger_cursor cursor for select * from #tempcostcenter  open costcentersupledger_cursor fetch next from costcentersupledger_cursor into @ledgerid,@costcenterid,@ledgerbalance while @@fetch_status=0 begin set @trandaccount = 0 set @trancaccount = 0 set @tranremain = 0 set @tmplegderstr = '%' + convert(varchar(10),@ledgerid) + '|%' select @trandaccount = sum(a.tranaccount) from FnaAccountCostcenter a , FnaLedger b where a.ledgerid = b.id and b.supledgerall like @tmplegderstr and a.costcenterid = @costcenterid and a.tranperiods = @fnayearperiods and a.tranbalance = @ledgerbalance select @trancaccount = sum(a.tranaccount) from FnaAccountCostcenter a , FnaLedger b where a.ledgerid = b.id and b.supledgerall like @tmplegderstr and a.costcenterid = @costcenterid and a.tranperiods = @fnayearperiods and a.tranbalance != @ledgerbalance if @trandaccount is null set @trandaccount = 0 if @trancaccount is null set @trancaccount = 0 set @tranremain = @trandaccount - @trancaccount if @tranremain <> 0 begin insert into FnaAccountCostcenter(ledgerid,costcenterid,tranperiods,tranaccount,tranbalance) values(@ledgerid,@costcenterid,@fnayearperiods,@tranremain,@ledgerbalance) end fetch next from costcentersupledger_cursor into @ledgerid,@costcenterid,@ledgerbalance end close costcentersupledger_cursor deallocate costcentersupledger_cursor   /*建立临时表, 保存部门和总帐(非明细), 成本中心和总帐(非明细) 的所有预算记录 */ create table #tempdepartmentbuget( ledgerid  int , departmentid  int, budgetmoduleid int )  create table #tempcostcenterbudget( ledgerid  int , costcenterid  int, budgetmoduleid int )  declare @fnayear char(4) , @theperiods int select @fnayear = left(@fnayearperiods ,4) select @theperiods = convert(int,right(@fnayearperiods,2))  declare budgetdepartmentmodule_cursor cursor for select a.id , b.id , c.id from  FnaLedger a, HrmDepartment b ,FnaBudgetModule c where subledgercount != 0 and c.fnayear = @fnayear and c.periodsidfrom <= @theperiods and c.periodsidto >= @theperiods  open budgetdepartmentmodule_cursor fetch next from budgetdepartmentmodule_cursor into @ledgerid,@departmentid,@budgetmoduleid while @@fetch_status=0 begin insert into #tempdepartmentbuget values(@ledgerid,@departmentid,@budgetmoduleid) fetch next from budgetdepartmentmodule_cursor into @ledgerid,@departmentid,@budgetmoduleid end close budgetdepartmentmodule_cursor deallocate budgetdepartmentmodule_cursor  declare budgetcostcentermodule_cursor cursor for select a.id , b.id , c.id from  FnaLedger a, HrmCostcenter b ,FnaBudgetModule c where subledgercount != 0 and c.fnayear = @fnayear and c.periodsidfrom <= @theperiods and c.periodsidto >= @theperiods  open budgetcostcentermodule_cursor fetch next from budgetcostcentermodule_cursor into @ledgerid,@costcenterid,@budgetmoduleid while @@fetch_status=0 begin insert into #tempcostcenterbudget values(@ledgerid,@costcenterid,@budgetmoduleid) fetch next from budgetcostcentermodule_cursor into @ledgerid,@costcenterid,@budgetmoduleid end close budgetcostcentermodule_cursor deallocate budgetcostcentermodule_cursor     /*将所有的总帐与部门的预算进行统计 */ declare departmentsupledgerbudget_cursor cursor for select * from #tempdepartmentbuget  open departmentsupledgerbudget_cursor fetch next from departmentsupledgerbudget_cursor into @ledgerid,@departmentid,@budgetmoduleid while @@fetch_status=0 begin set @budgetaccount = 0 set @tmplegderstr = '%' + convert(varchar(10),@ledgerid) + '|%' select @budgetaccount = sum(budgetaccount) from FnaBudgetList a , FnaLedger b where a.ledgerid = b.id and b.supledgerall like @tmplegderstr and a.budgetdepartmentid = @departmentid and a.budgetperiods = @fnayearperiods and a.budgetmoduleid = @budgetmoduleid  if @budgetaccount <> 0 begin insert into FnaBudgetDepartment(ledgerid,departmentid,budgetmoduleid,budgetperiods,budgetaccount) values(@ledgerid,@departmentid,@budgetmoduleid,@budgetperiods,@budgetaccount) end fetch next from departmentsupledgerbudget_cursor into @ledgerid,@departmentid,@budgetmoduleid end close departmentsupledgerbudget_cursor deallocate departmentsupledgerbudget_cursor   /*将所有的总帐与成本中心的预算进行统计 */ declare costcentersupledgerbudget_cursor cursor for select * from #tempcostcenterbudget  open costcentersupledgerbudget_cursor fetch next from costcentersupledgerbudget_cursor into @ledgerid,@costcenterid,@budgetmoduleid while @@fetch_status=0 begin set @budgetaccount = 0 set @tmplegderstr = '%' + convert(varchar(10),@ledgerid) + '|%' select @budgetaccount = sum(budgetaccount) from FnaBudgetList a , FnaLedger b where a.ledgerid = b.id and b.supledgerall like @tmplegderstr and a.budgetcostcenterid = @costcenterid and a.budgetperiods = @fnayearperiods and a.budgetmoduleid = @budgetmoduleid  if @budgetaccount <> 0 begin insert into FnaBudgetCostcenter(ledgerid,costcenterid,budgetmoduleid,budgetperiods,budgetaccount) values(@ledgerid,@costcenterid,@budgetmoduleid,@budgetperiods,@budgetaccount) end fetch next from costcentersupledgerbudget_cursor into @ledgerid,@costcenterid,@budgetmoduleid end close costcentersupledgerbudget_cursor deallocate costcentersupledgerbudget_cursor   /* 将所有分录状态改为结帐 */ update FnaTransaction set transtatus = '3' where tranperiods = @fnayearperiods  /* 将所有预算状态改为结帐 */ update FnaBudget set budgetstatus = '3' where budgetperiods = @fnayearperiods   /* 将该期间关闭*/ UPDATE [FnaYearsPeriodsList] SET  [isclose]	 = '1' WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE FnaYearsPeriodsList_Insert 
 (@fnayearid_1 	[int], @Periodsid_2 	[int], @fnayear_3 	[char](4), @startdate_4 	[char](10), @enddate_5 	[char](10), @isactive_6 	[char](1), @flag integer output , @msg varchar(80) output)  AS declare @fnayearperiodsid char(6) if @Periodsid_2 <= 9 select @fnayearperiodsid = @fnayear_3 + '0' + convert(char(1),@Periodsid_2) else select @fnayearperiodsid = @fnayear_3 + convert(char(2),@Periodsid_2)  INSERT INTO [FnaYearsPeriodsList] ( [fnayearid], [Periodsid], [fnayear], [startdate], [enddate], [isactive], [fnayearperiodsid])  VALUES ( @fnayearid_1, @Periodsid_2, @fnayear_3, @startdate_4, @enddate_5, @isactive_6, @fnayearperiodsid) 
GO

 CREATE PROCEDURE FnaYearsPeriodsList_Reopen 
 (@id_1 	[int], @fnayearperiods  char(6), @flag integer output , @msg varchar(80) output)  AS declare @count integer select @count = count(id) from FnaYearsPeriodsList where fnayearperiodsid > @fnayearperiods and isclose ='1'  if @count <> 0 begin select -1 return end  delete FnaAccount where tranperiods = @fnayearperiods delete FnaAccountDepartment where tranperiods = @fnayearperiods delete FnaAccountCostcenter where tranperiods = @fnayearperiods delete FnaAccountList where tranperiods > @fnayearperiods delete FnaBudgetDepartment where budgetperiods = @fnayearperiods delete FnaBudgetCostcenter where budgetperiods = @fnayearperiods update FnaTransaction set transtatus = '2' where tranperiods = @fnayearperiods update FnaTransaction set transtatus = '1' where tranperiods > @fnayearperiods update FnaBudget set budgetstatus = '2' where budgetperiods = @fnayearperiods   UPDATE [FnaYearsPeriodsList] SET  [isclose]	 = '0' WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE FnaYearsPeriodsList_SByFnayear 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select * from FnaYearsPeriodsList where fnayearid = @id_1 
GO

 CREATE PROCEDURE FnaYearsPeriodsList_SelectByID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS declare @count integer ,  @fnayearperiodsid char(6) select @fnayearperiodsid = fnayearperiodsid from FnaYearsPeriodsList where id = @id_1 select @count = count(id) from FnaTransaction where tranperiods = @fnayearperiodsid if @count = 0 select @count = count(id) from FnaBudget where budgetperiods = @fnayearperiodsid  select id,fnayearid,Periodsid,fnayear,startdate,enddate,isclose,isactive,fnayearperiodsid,'trancount'=@count from FnaYearsPeriodsList where id = @id_1 
GO

 CREATE PROCEDURE FnaYearsPeriodsList_Update 
 (@id_1 	[int], @startdate_2 	[char](10), @enddate_3 	[char](10), @fnayearid_4    int , @isactive_5 	[char](1), @flag integer output , @msg varchar(80) output)  AS declare @minfromdate [char](10) declare @maxenddate [char](10)  UPDATE [FnaYearsPeriodsList] SET  [startdate]	 = @startdate_2, [enddate]	 = @enddate_3 , [isactive]	 = @isactive_5 WHERE ( [id]	 = @id_1)  select @minfromdate = min(startdate) from FnaYearsPeriodsList where fnayearid=@fnayearid_4 and startdate <> '' select @maxenddate = max(enddate) from FnaYearsPeriodsList where fnayearid=@fnayearid_4 and enddate <> ''  update FnaYearsPeriods set startdate=@minfromdate , enddate = @maxenddate where id = @fnayearid_4 
GO

 CREATE PROCEDURE FnaYearsPeriods_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count integer select @count = count(id) from FnaYearsPeriodsList where fnayearid = @id_1 and isclose ='1'  if @count <> 0 begin select '20' return end  DELETE [FnaYearsPeriods]  WHERE ( [id]	 = @id_1) DELETE FnaYearsPeriodsList where  fnayearid = @id_1 
GO

 CREATE PROCEDURE FnaYearsPeriods_Insert 
 (@fnayear_1 	[char](4), @startdate_2 	[char](10), @enddate_3 	[char](10), @flag integer output , @msg varchar(80) output)  AS declare @count integer select @count = count(id) from FnaYearsPeriods where fnayear =  @fnayear_1 if @count <> 0 begin select -1 return end  INSERT INTO [FnaYearsPeriods] ( [fnayear], [startdate], [enddate])  VALUES ( @fnayear_1, @startdate_2, @enddate_3)  select max(id) from FnaYearsPeriods 
GO

 CREATE PROCEDURE FnaYearsPeriods_SDefaultBudget 
 @fnayear    char(4), @flag integer output , @msg varchar(80) output AS declare @budgetid int  select @budgetid = budgetid from FnaYearsPeriods where fnayear = @fnayear  if @budgetid is null or @budgetid =0 select min(id) from FnaBudgetModule where fnayear = @fnayear else select @budgetid 
GO

 CREATE PROCEDURE FnaYearsPeriods_Select 
 @flag integer output , @msg varchar(80) output AS select * from FnaYearsPeriods 
GO

 CREATE PROCEDURE FnaYearsPeriods_SelectByID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select * from FnaYearsPeriods where id = @id_1 
GO

 CREATE PROCEDURE FnaYearsPeriods_SelectMaxYear 
 @flag integer output , @msg varchar(80) output AS declare @fnayear char(4) select @fnayear = max(fnayear) from FnaYearsPeriods select * from FnaYearsPeriods where fnayear = @fnayear 
GO

 CREATE PROCEDURE FnaYearsPeriods_Update 
 (@id_1 	[int], @budgetid_2 	[int], @flag integer output , @msg varchar(80) output)  AS UPDATE [FnaYearsPeriods]  SET  [budgetid]	 = @budgetid_2  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmAbsense1_Delete 
	(@id_1 	[int],
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS DELETE [Bill_HrmResourceAbsense] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmAbsense1_Insert 
	(@departmentid_1 	[int],
	 @resourceid_2 	[int],
	 @absenseremark_3 	[text],
	 @startdate_4 	[char](10),
	 @starttime_5 	[char](8),
	 @enddate_6 	[char](10),
	 @endtime_7 	[char](8),
	 @absenseday_8 	[decimal](10,2),
	 @workflowid_9 	[int],
	 @workflowname_10 	[varchar](100),
	 @usestatus_11 	[char](1),
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS INSERT INTO [Bill_HrmResourceAbsense] 
	 ( [departmentid],
	 [resourceid],
	 [absenseremark],
	 [startdate],
	 [starttime],
	 [enddate],
	 [endtime],
	 [absenseday],
	 [workflowid],
	 [workflowname],
	 [usestatus]) 
 
VALUES 
	( @departmentid_1,
	 @resourceid_2,
	 @absenseremark_3,
	 @startdate_4,
	 @starttime_5,
	 @enddate_6,
	 @endtime_7,
	 @absenseday_8,
	 @workflowid_9,
	 @workflowname_10,
	 @usestatus_11)

GO

 CREATE PROCEDURE HrmAbsense1_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from Bill_HrmResourceAbsense
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE HrmAbsense1_SelectByResourceID 
	 @resourceid varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
AS select * from Bill_HrmResourceAbsense
      where resourceid =convert(int, @resourceid) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE HrmAbsense1_Update 
	(@id_1 	[int],
	 @departmentid_2 	[int],
	 @resourceid_3 	[int],
	 @absenseremark_4 	[text],
	 @startdate_5 	[char](10),
	 @starttime_6 	[char](8),
	 @enddate_7 	[char](10),
	 @endtime_8 	[char](8),
	 @absenseday_9 	[decimal](10,2),
	 @workflowid_10 	[int],
	 @workflowname_11 	[varchar](100),
	 @usestatus_12 	[char](1),
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS UPDATE [Bill_HrmResourceAbsense] 

SET  [departmentid]	 = @departmentid_2,
	 [resourceid]	 = @resourceid_3,
	 [absenseremark]	 = @absenseremark_4,
	 [startdate]	 = @startdate_5,
	 [starttime]	 = @starttime_6,
	 [enddate]	 = @enddate_7,
	 [endtime]	 = @endtime_8,
	 [absenseday]	 = @absenseday_9,
	 [workflowid]	 = @workflowid_10,
	 [workflowname]	 = @workflowname_11,
	 [usestatus]	 = @usestatus_12 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmActivitiesCompetency_Delete 
 (@jobactivityid_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmActivitiesCompetency] WHERE ( [jobactivityid]	 = @jobactivityid_1) if @@error<>0 begin set @flag=1 set @msg='删除储存过程失败' return end else begin set @flag=0 set @msg='删除储存过程成功' return end 
GO

 CREATE PROCEDURE HrmActivitiesCompetency_Insert 
 (@jobactivityid_1 	[int], @competencyid_2 	[int], @flag integer output, @msg varchar(80) output )  AS INSERT INTO [HrmActivitiesCompetency] ( [jobactivityid], [competencyid])  VALUES ( @jobactivityid_1, @competencyid_2) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmActivitiesCompetency_Select 
 (@jobactivityid_1 	[int], @flag integer output, @msg varchar(80) output )  AS select * from  [HrmActivitiesCompetency] where jobactivityid =convert(int, @jobactivityid_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmApplyRemark_Insert 
	(@applyid_1 	[int],
	 @remark_2 	[varchar](200),
	 @resourceid_3 	[int],
	 @date_4 	[char](10),
	 @time_5 	[char](8),
	@flag integer output , 
  	@msg varchar(80) output  )

AS INSERT INTO [HrmApplyRemark] 
	 ( [applyid],
	 [remark],
	 [resourceid],
	 [date_n],
	 [time]) 
 
VALUES 
	( @applyid_1,
	 @remark_2,
	 @resourceid_3,
	 @date_4,
	 @time_5)

GO

/*2002-8-9*/
 CREATE PROCEDURE HrmApplyRemark_Select 
@applyid		int,
@flag                             integer output, 
@msg                             varchar(80) output
 AS
select * from HrmApplyRemark where applyid = @applyid
GO

 CREATE PROCEDURE HrmBank_Delete 
 (@id	int, @flag                             integer output, @msg                             varchar(80) output ) AS delete from hrmbank where id=@id  if @@error<>0 begin set @flag=1 set @msg='right' return end else begin set @flag=0 set @msg='wrong' return end 
GO

 CREATE PROCEDURE HrmBank_Insert 
 ( @bankname	varchar(60), @bankdesc	varchar(200), @checkstr	varchar(200), @flag                             integer output, @msg                             varchar(80) output ) AS INSERT INTO hrmbank values(@bankname,@bankdesc,@checkstr)  select max(id) from hrmbank  if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmBank_SelectAll 
 (  @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmBank order by id  if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmBank_Update 
 (@id	int, @bankname	varchar(60), @bankdesc	varchar(200), @checkstr	varchar(200), @flag                             integer output, @msg                             varchar(80) output ) AS update hrmbank set bankname=@bankname,bankdesc=@bankdesc, checkstr=@checkstr where id=@id  if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmCareerApplyOtherInfo_SByApp 
 (@applyid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM HrmCareerApplyOtherInfo WHERE applyid  = @applyid 
GO

 CREATE PROCEDURE HrmCareerApply_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS delete HrmEducationInfo where resourceid = @id_1  delete HrmWorkResume where resourceid = @id_1  DELETE [HrmCareerApply] WHERE ( [id]	 = @id_1)  delete HrmCareerApplyOtherInfo where applyid = @id_1 
GO

 CREATE PROCEDURE HrmCareerApply_Insert 
 (@id_1 	[int], @ischeck [char](1), @ishire		[char](1), @careerid	[int], @firstname_2 	[varchar](60), @lastname_3 	[varchar](60), @titleid_4 	[int], @sex_5 	[char](1), @birthday_6 	[char](10), @nationality_7 	[int], @defaultlanguage_8 	[int], @certificatecategory_9 	[varchar](30), @certificatenum_10 	[varchar](60), @nativeplace_11 	[varchar](100), @educationlevel_12 	[char](1), @bememberdate_13 	[char](10), @bepartydate_14 	[char](10), @bedemocracydate_15 	[char](10), @regresidentplace_16 	[varchar](60), @healthinfo_17 	[char](1), @residentplace_18 	[varchar](60), @policy_19 	[varchar](30), @degree_20 	[varchar](30), @height_21 	[varchar](10), @homepage_22 	[varchar](100), @maritalstatus_23 	[char](1), @marrydate_24 	[char](10), @train_25 	[text], @email_26 	[varchar](60), @homeaddress_27 	[varchar](100), @homepostcode_28 	[varchar](20), @homephone_29 	[varchar](60), @category_3 	[char](1), @contactor_4 	[varchar](30), @major_5 	[varchar](60), @salarynow_6 	[varchar](60), @worktime_7 	[varchar](10), @salaryneed_8 	[varchar](60), @currencyid_9 	[int], @reason_10 	[varchar](200), @otherrequest_11 	[varchar](200), @selfcomment_12 	[text], @createdate		[char](10), @flag integer output, @msg varchar(80) output)  AS if @nationality_7=0 set @nationality_7= null if @defaultlanguage_8=0 set @defaultlanguage_8= null  INSERT INTO [HrmCareerApply] ( [id], ischeck, ishire, [careerid], [firstname], [lastname], [titleid], [sex], [birthday], [nationality], [defaultlanguage], [certificatecategory], [certificatenum], [nativeplace], [educationlevel], [bememberdate], [bepartydate], [bedemocracydate], [regresidentplace], [healthinfo], [residentplace], [policy], [degree], [height], [homepage], [maritalstatus], [marrydate], [train], [email], [homeaddress], [homepostcode], [homephone], createrid, createdate)  VALUES ( @id_1, @ischeck, @ishire, @careerid, @firstname_2, @lastname_3, @titleid_4, @sex_5, @birthday_6, @nationality_7, @defaultlanguage_8, @certificatecategory_9, @certificatenum_10, @nativeplace_11, @educationlevel_12, @bememberdate_13, @bepartydate_14, @bedemocracydate_15, @regresidentplace_16, @healthinfo_17, @residentplace_18, @policy_19, @degree_20, @height_21, @homepage_22, @maritalstatus_23, @marrydate_24, @train_25, @email_26, @homeaddress_27, @homepostcode_28, @homephone_29, @id_1, @createdate)  INSERT INTO [HrmCareerApplyOtherInfo] ([applyid], [category], [contactor], [major], [salarynow], [worktime], [salaryneed], [currencyid], [reason], [otherrequest], [selfcomment])  VALUES ( @id_1, @category_3, @contactor_4, @major_5, @salarynow_6, @worktime_7, @salaryneed_8, @currencyid_9, @reason_10, @otherrequest_11, @selfcomment_12) 
GO

 CREATE PROCEDURE HrmCareerApply_SelectById 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM HrmCareerApply WHERE id  = @id 
GO

 CREATE PROCEDURE HrmCareerApply_Update 
 (@id_1  	[int], @judge 	[char](1), @flag  integer output, @msg varchar(80) output)  AS if @judge='0' begin UPDATE [HrmCareerApply] SET  [ischeck]	 = 1 WHERE ( [id]	 = @id_1) end else begin UPDATE [HrmCareerApply] SET  [ishire]	 = 1 WHERE ( [id]	 = @id_1) end 
GO

 CREATE PROCEDURE HrmCareerInvite_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [HrmCareerInvite]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmCareerInvite_Insert 
 (@careername_1 	[varchar](80), @careerpeople_2 	[char](4), @careerage_3 	[varchar](60), @careersex_4 	[char](1), @careeredu_5 	[char](1), @careermode_6 	[varchar](60), @careeraddr_7 	[varchar](100), @careerclass_8 	[varchar](60), @careerdesc_9 	[text], @careerrequest_10 	[text], @careerremark_11 	[text], @createrid_12 	[int], @createdate_13 	[char](10), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [HrmCareerInvite] ( [careername], [careerpeople], [careerage], [careersex], [careeredu], [careermode], [careeraddr], [careerclass], [careerdesc], [careerrequest], [careerremark], [createrid], [createdate])  VALUES ( @careername_1, @careerpeople_2, @careerage_3, @careersex_4, @careeredu_5, @careermode_6, @careeraddr_7, @careerclass_8, @careerdesc_9, @careerrequest_10, @careerremark_11, @createrid_12, @createdate_13) 
GO

 CREATE PROCEDURE HrmCareerInvite_Select 
 ( @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [HrmCareerInvite] 
GO

 CREATE PROCEDURE HrmCareerInvite_SelectById 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [HrmCareerInvite] WHERE ( [id]	 = @id) 
GO

 CREATE PROCEDURE HrmCareerInvite_Update 
 (@id_1 	[int], @careername_2 	[varchar](80), @careerpeople_3 	[char](4), @careerage_4 	[varchar](60), @careersex_5 	[char](1), @careeredu_6 	[char](1), @careermode_7 	[varchar](60), @careeraddr_8 	[varchar](100), @careerclass_9 	[varchar](60), @careerdesc_10 	[text], @careerrequest_11 	[text], @careerremark_12 	[text], @lastmodid_13 	[int], @lastmoddate_14 	[char](10), @flag integer output , @msg varchar(80) output)  AS UPDATE [HrmCareerInvite]  SET  [careername]	 = @careername_2, [careerpeople]	 = @careerpeople_3, [careerage]	 = @careerage_4, [careersex]	 = @careersex_5, [careeredu]	 = @careeredu_6, [careermode]	 = @careermode_7, [careeraddr]	 = @careeraddr_8, [careerclass]	 = @careerclass_9, [careerdesc]	 = @careerdesc_10, [careerrequest]	 = @careerrequest_11, [careerremark]	 = @careerremark_12, [lastmodid]	 = @lastmodid_13, [lastmoddate]	 = @lastmoddate_14  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmCareerWorkexp_DByApplyId 
 (@applyid_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [HrmCareerWorkexp]  WHERE ( [applyid] = @applyid_1) 
GO

 CREATE PROCEDURE HrmCareerWorkexp_Insert 
 (@ftime_1 	[char](10), @ttime_2 	[char](10), @company_3 	[varchar](100), @jobtitle_4 	[varchar](100), @workdesc_5 	[text], @applyid_6 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [HrmCareerWorkexp] ( [ftime], [ttime], [company], [jobtitle], [workdesc], [applyid])  VALUES ( @ftime_1, @ttime_2, @company_3, @jobtitle_4, @workdesc_5, @applyid_6) 
GO

 CREATE PROCEDURE HrmCareerWorkexp_SByApplyId 
 (@applyid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM HrmCareerWorkexp WHERE applyid  = @applyid 
GO

 CREATE PROCEDURE HrmCertification_Delete 
	(@id_1 	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS DELETE [HrmCertification] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmCertification_Insert 
	(@resourceid_1 	[int],
	 @datefrom_2 	[char](10),
	 @dateto_3 	[char](10),
	 @certname_4 	[varchar](60),
	 @awardfrom_5 	[varchar](100),
	 @createid_6 	[int],
	 @createdate_7 	[char](10),
	 @createtime_8 	[char](8),
	 @lastmoderid_9 	[int],
	 @lastmoddate_10 	[char](10),
	 @lastmodtime_11 	[char](8),
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [HrmCertification] 
	 ( [resourceid],
	 [datefrom],
	 [dateto],
	 [certname],
	 [awardfrom],
	 [createid],
	 [createdate],
	 [createtime],
	 [lastmoderid],
	 [lastmoddate],
	 [lastmodtime]) 
 
VALUES 
	( @resourceid_1,
	 @datefrom_2,
	 @dateto_3,
	 @certname_4,
	 @awardfrom_5,
	 @createid_6,
	 @createdate_7,
	 @createtime_8,
	 @lastmoderid_9,
	 @lastmoddate_10,
	 @lastmodtime_11)

GO

/*按id查询资格证书*/
 CREATE PROCEDURE HrmCertification_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from HrmCertification
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO





--按resourceid查询资格证书
 CREATE PROCEDURE HrmCertification_SByResource 
	 @resourceid varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
AS select * from HrmCertification
      where resourceid =convert(int, @resourceid) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE HrmCertification_Update 
	(@id_1 	[int],
	 @resourceid_2 	[int],
	 @datefrom_3 	[char](10),
	 @dateto_4 	[char](10),
	 @certname_5 	[varchar](60),
	 @awardfrom_6 	[varchar](100),
	 @lastmoderid_7 	[int],
	 @lastmoddate_8 	[char](10),
	 @lastmodtime_9 	[char](8),
	 @flag integer output,
	 @msg varchar(80) output)

AS UPDATE [HrmCertification] 

SET  [resourceid]	 = @resourceid_2,
	 [datefrom]	 = @datefrom_3,
	 [dateto]	 = @dateto_4,
	 [certname]	 = @certname_5,
	 [awardfrom]	 = @awardfrom_6,
	 [lastmoderid]	 = @lastmoderid_7,
	 [lastmoddate]	 = @lastmoddate_8,
	 [lastmodtime]	 = @lastmodtime_9 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmCity_Delete 
 (@id 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmCity]  WHERE ( [id]	 = @id) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCity_Insert 
 (@cityname 	[varchar](60), @citylongitude [decimal](8,3),  @citylatitude [decimal](8,3), @provinceid [int], @countryid [int], @flag integer output, @msg varchar(80) output )  AS INSERT INTO [HrmCity] ( [cityname], [citylongitude], [citylatitude], [provinceid], [countryid] )  VALUES ( @cityname, @citylongitude, @citylatitude, @provinceid, @countryid ) select max(id) from [HrmCity] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCity_Select 
 @countryid int , @provinceid int , @flag integer output , @msg varchar(80) output AS if @countryid = 0 begin select * from HrmCity end else if @provinceid = 0 begin select * from HrmCity where countryid = @countryid end else begin select * from HrmCity where countryid = @countryid and provinceid = @provinceid end set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmCity_Update 
 (@id 	[int], @cityname 	[varchar](60) , @citylongitude [decimal](8,3),  @citylatitude [decimal](8,3), @provinceid [int], @countryid [int], @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmCity]  SET  [cityname]	 = @cityname, [citylongitude] = @citylongitude, [citylatitude] = @citylatitude, [provinceid] = @provinceid, [countryid] = @countryid  WHERE ( [id]	 = @id) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCompany_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmCompany set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmCompany_Update 
 (@id_1 	[tinyint], @companyname_2 	[varchar](200), @flag                             integer output, @msg                             varchar(80) output )  AS UPDATE [HrmCompany]  SET  [companyname]	 = @companyname_2  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCompetency_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmCompetency]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCompetency_Insert 
 (@competencymark_1 	[varchar](60), @competencyname_2 	[varchar](200), @competencyremark_3 	[text], @flag integer output, @msg varchar(80) output )  AS INSERT INTO [HrmCompetency] ( [competencymark], [competencyname], [competencyremark])  VALUES ( @competencymark_1, @competencyname_2, @competencyremark_3) select max(id) from  [HrmCompetency]  if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCompetency_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmCompetency set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmCompetency_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmCompetency where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmCompetency_Update 
 (@id_1 	[int], @competencymark_2 	[varchar](60), @competencyname_3 	[varchar](200), @competencyremark_4 	[text], @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmCompetency]  SET  [competencymark]	 = @competencymark_2, [competencyname]	 = @competencyname_3, [competencyremark]	 = @competencyremark_4  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCostcenterMainCategory_S 
 @flag integer output , @msg varchar(80) output AS select * from HrmCostcenterMainCategory set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmCostcenterMainCategory_U 
 (@id_1 	[tinyint], @ccmaincategoryname_2 	[varchar](200), @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmCostcenterMainCategory]  SET  [ccmaincategoryname]	 = @ccmaincategoryname_2  WHERE ( [id]	 = @id_1) IF @@error<>0 begin set @flag=1 set @msg='更新储存过程失败' return END ELSE begin set @flag=1 set @msg='更新储存过程失败' return END 
GO

 CREATE PROCEDURE HrmCostcenterSubCategory_D 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DECLARE @recordercount integer Select @recordercount = count(id) from HrmCostcenter where ccsubcategory1 =convert(int, @id_1)  or ccsubcategory2 =convert(int, @id_1)  or ccsubcategory3 =convert(int, @id_1)  or ccsubcategory4 =convert(int, @id_1) if @recordercount = 0 begin DELETE [HrmCostcenterSubCategory]  WHERE ( [id]	 = @id_1) end else begin select '20' end  if @@error<>0 begin set @flag=1 set @msg='删除储存过程失败' return end else begin set @flag=0 set @msg='删除储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCostcenterSubCategory_I 
 (@ccsubcategoryname_1 	[varchar](60), @ccsubcategorydesc_2 	[varchar](200), @ccmaincategoryid_3 	[tinyint], @flag integer output, @msg varchar(80) output ) AS  INSERT INTO [HrmCostcenterSubCategory] ( [ccsubcategoryname], [ccsubcategorydesc], [ccmaincategoryid] )  VALUES ( @ccsubcategoryname_1, @ccsubcategorydesc_2, @ccmaincategoryid_3 ) select (max(id)) from [HrmCostcenterSubCategory] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCostcenterSubCategory_S 
 @flag integer output , @msg varchar(80) output AS select * from HrmCostcenterSubCategory set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmCostcenterSubCategory_U 
 (@id_1 	[int], @ccsubcategoryname_2 	[varchar](60), @ccsubcategorydesc_3 	[varchar](200), @ccmaincategoryid_4 	[tinyint], @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmCostcenterSubCategory]  SET  [ccsubcategoryname]	 = @ccsubcategoryname_2, [ccsubcategorydesc]	 = @ccsubcategorydesc_3, [ccmaincategoryid]	 = @ccmaincategoryid_4  WHERE ( [id]	 = @id_1) IF @@error<>0 begin set @flag=1 set @msg='更新储存过程失败' return END ELSE begin set @flag=1 set @msg='更新储存过程失败' return END 
GO

 CREATE PROCEDURE HrmCostcenter_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DECLARE @recordercount integer Select @recordercount = count(id) from HrmResource where costcenterid =convert(int, @id_1) if @recordercount = 0 begin DELETE [HrmCostcenter]  WHERE ( [id]	 = @id_1) end else begin select '20' end IF @@error<>0 begin set @flag=1 set @msg='更新储存过程失败' return END ELSE begin set @flag=1 set @msg='更新储存过程失败' return END 
GO

 CREATE PROCEDURE HrmCostcenter_Insert 
 (@costcentermark_1 	[varchar](60), @costcentername_2 	[varchar](200), @activable_3 	[char](1), @departmentid_4 	[int], @ccsubcategory1_5 	[int], @ccsubcategory2_6 	[int], @ccsubcategory3_7 	[int], @ccsubcategory4_8 	[int], @flag integer output, @msg varchar(80) output )  AS INSERT INTO [HrmCostcenter] ( [costcentermark], [costcentername], [activable], [departmentid], [ccsubcategory1], [ccsubcategory2], [ccsubcategory3], [ccsubcategory4])  VALUES ( @costcentermark_1, @costcentername_2, @activable_3, @departmentid_4, @ccsubcategory1_5, @ccsubcategory2_6, @ccsubcategory3_7, @ccsubcategory4_8) select max(id) from [HrmCostcenter]  if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCostcenter_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmCostcenter set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmCostcenter_SelectByDeptID 
 @id varchar(100) , @groupby varchar(100) , @flag integer output , @msg varchar(80) output AS if convert(int,@groupby)=1 begin select ccsubcategory1 from HrmCostcenter where departmentid =convert(int, @id) group by ccsubcategory1 end else if convert(int,@groupby)=2 begin select ccsubcategory2 from HrmCostcenter where departmentid =convert(int, @id) group by ccsubcategory2 end else if convert(int,@groupby)=3 begin select ccsubcategory3 from HrmCostcenter where departmentid =convert(int, @id) group by ccsubcategory3 end else if convert(int,@groupby)=4 begin select ccsubcategory4 from HrmCostcenter where departmentid =convert(int, @id) group by ccsubcategory4 end  set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmCostcenter_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmCostcenter where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmCostcenter_Update 
 (@id_1 	[int], @costcentermark_2 	[varchar](60), @costcentername_3 	[varchar](200), @activable_4 	[char](1), @departmentid_5 	[int], @ccsubcategory1_6 	[int], @ccsubcategory2_7 	[int], @ccsubcategory3_8 	[int], @ccsubcategory4_9 	[int], @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmCostcenter]  SET  [costcentermark]	 = @costcentermark_2, [costcentername]	 = @costcentername_3, [activable]	 = @activable_4, [departmentid]	 = @departmentid_5, [ccsubcategory1]	 = @ccsubcategory1_6, [ccsubcategory2]	 = @ccsubcategory2_7, [ccsubcategory3]	 = @ccsubcategory3_8, [ccsubcategory4]	 = @ccsubcategory4_9  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCountry_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmCountry]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCountry_Insert 
 (@countryname_1 	[varchar](60), @countrydesc_2 	[varchar](200), @flag integer output, @msg varchar(80) output )  AS INSERT INTO [HrmCountry] ( [countryname], [countrydesc])  VALUES ( @countryname_1, @countrydesc_2) select max(id) from [HrmCountry] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmCountry_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmCountry set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmCountry_Update 
 (@id_1 	[int], @countryname_2 	[varchar](60), @countrydesc_3 	[varchar](200), @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmCountry]  SET  [countryname]	 = @countryname_2, [countrydesc]	 = @countrydesc_3  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmDepartment_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmDepartment]  WHERE ( [id]	 = @id_1) select @@ROWCOUNT if @@error<>0 begin set @flag=1 set @msg='删除储存过程失败' return end else begin set @flag=0 set @msg='删除储存过程成功' return end 
GO

 CREATE PROCEDURE HrmDepartment_Insert 
 (@departmentmark_1 	[varchar](60), @departmentname_2 	[varchar](200), @countryid_3 	[int], @addedtax_4 	[varchar](50), @website_5 	[varchar](200), @startdate_6 	[char](10), @enddate_7 	[char](10), @currencyid_8 	[int], @seclevel_9 	[tinyint], @subcompanyid1_10 	[int], @subcompanyid2_11 	[int], @subcompanyid3_12 	[int], @subcompanyid4_13 	[int], @createrid_14 	[int], @createrdate_15 	[char](10), @lastmoduserid_16 	[int], @lastmoddate_17 	[char](10), @flag integer output , @msg varchar(80) output )  AS  INSERT INTO [HrmDepartment] ( [departmentmark], [departmentname], [countryid], [addedtax], [website], [startdate], [enddate], [currencyid], [seclevel], [subcompanyid1], [subcompanyid2], [subcompanyid3], [subcompanyid4], [createrid], [createrdate], [lastmoduserid], [lastmoddate])  VALUES ( @departmentmark_1, @departmentname_2, @countryid_3, @addedtax_4, @website_5, @startdate_6, @enddate_7, @currencyid_8, @seclevel_9, @subcompanyid1_10, @subcompanyid2_11, @subcompanyid3_12, @subcompanyid4_13, @createrid_14, @createrdate_15, @lastmoduserid_16, @lastmoddate_17) select (max(id)) from [HrmDepartment] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmDepartment_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmDepartment order by seclevel set  @flag = 0 set  @msg = '操作成功完成' 

GO

 CREATE PROCEDURE HrmDepartment_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmDepartment where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmDepartment_Update 
 (@id_1 	[int], @departmentmark_2 	[varchar](60), @departmentname_3 	[varchar](200), @countryid_4 	[int], @addedtax_5 	[varchar](50), @website_6 	[varchar](200), @startdate_7 	[char](10), @enddate_8 	[char](10), @currencyid_9 	[int], @seclevel_10 	[tinyint], @subcompanyid1_11 	[int], @subcompanyid2_12 	[int], @subcompanyid3_13 	[int], @subcompanyid4_14 	[int], @createrid_15 	[int], @createrdate_16 	[char](10), @lastmoduserid_17 	[int], @lastmoddate_18 	[char](10), @flag integer output, @msg varchar(80) output  )  AS UPDATE [HrmDepartment]  SET  [departmentmark]	 = @departmentmark_2, [departmentname]	 = @departmentname_3, [countryid]	 = @countryid_4, [addedtax]	 = @addedtax_5, [website]	 = @website_6, [startdate]	 = @startdate_7, [enddate]	 = @enddate_8, [currencyid]	 = @currencyid_9, [seclevel]	 = @seclevel_10, [subcompanyid1]	 = @subcompanyid1_11, [subcompanyid2]	 = @subcompanyid2_12, [subcompanyid3]	 = @subcompanyid3_13, [subcompanyid4]	 = @subcompanyid4_14, [createrid]	 = @createrid_15, [createrdate]	 = @createrdate_16, [lastmoduserid]	 = @lastmoduserid_17, [lastmoddate]	 = @lastmoddate_18  WHERE ( [id]	 = @id_1) IF @@error<>0 begin set @flag=1 set @msg='更新储存过程失败' return END ELSE begin set @flag=1 set @msg='更新储存过程失败' return END 
GO

 CREATE PROCEDURE HrmEducationInfo_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmEducationInfo]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmEducationInfo_Insert 
 (@resourceid_1 	[int], @startdate_2 	[char](10), @enddate_3 	[char](10), @school_4 	[varchar](100), @speciality_5 	[varchar](60), @educationlevel_6 	[char](1), @studydesc_7 	[text], @createid_8 	[int], @createdate_9 	[char](10), @createtime_10 	[char](8), @lastmoderid_11 	[int], @lastmoddate_12 	[char](10), @lastmodtime_13 	[char](8), @flag integer output, @msg varchar(80) output) AS INSERT INTO [HrmEducationInfo] ( [resourceid], [startdate], [enddate], [school], [speciality], [educationlevel], [studydesc], [createid], [createdate], [createtime], [lastmoderid], [lastmoddate], [lastmodtime])  VALUES ( @resourceid_1, @startdate_2, @enddate_3, @school_4, @speciality_5, @educationlevel_6, @studydesc_7, @createid_8, @createdate_9, @createtime_10, @lastmoderid_11, @lastmoddate_12, @lastmodtime_13) 
GO

 CREATE PROCEDURE HrmEducationInfo_SByResourceID 
 @resourceid varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmEducationInfo where resourceid =convert(int, @resourceid) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmEducationInfo_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmEducationInfo where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmEducationInfo_Update 
 (@id_1 	[int], @resourceid_2 	[int], @startdate_3 	[char](10), @enddate_4 	[char](10), @school_5 	[varchar](100), @speciality_6 	[varchar](60), @educationlevel_7 	[char](1), @studydesc_8 	[text], @lastmoderid_12 	[int], @lastmoddate_13 	[char](10), @lastmodtime_14 	[char](8), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmEducationInfo]  SET  [resourceid]	 = @resourceid_2, [startdate]	 = @startdate_3, [enddate]	 = @enddate_4, [school]	 = @school_5, [speciality]	 = @speciality_6, [educationlevel]	 = @educationlevel_7, [studydesc]	 = @studydesc_8, [lastmoderid]	 = @lastmoderid_12, [lastmoddate]	 = @lastmoddate_13, [lastmodtime]	 = @lastmodtime_14  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmFamilyInfo_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmFamilyInfo]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmFamilyInfo_Insert 
 (@resourceid_1 	[int], @member_2 	[varchar](30), @title_3 	[varchar](30), @company_4 	[varchar](100), @jobtitle_5 	[varchar](100), @address_6 	[varchar](100), @createid_7 	[int], @createdate_8 	[char](10), @createtime_9 	[char](8), @lastmoderid_10 	[int], @lastmoddate_11 	[char](10), @lastmodtime_12 	[char](8), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmFamilyInfo] ( [resourceid], [member], [title], [company], [jobtitle], [address], [createid], [createdate], [createtime], [lastmoderid], [lastmoddate], [lastmodtime])  VALUES ( @resourceid_1, @member_2, @title_3, @company_4, @jobtitle_5, @address_6, @createid_7, @createdate_8, @createtime_9, @lastmoderid_10, @lastmoddate_11, @lastmodtime_12) 
GO

 CREATE PROCEDURE HrmFamilyInfo_SbyResourceID 
 @resourceid varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmFamilyInfo where resourceid =convert(int, @resourceid) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmFamilyInfo_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmFamilyInfo where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmFamilyInfo_Update 
 (@id_1 	[int], @resourceid_2 	[int], @member_3 	[varchar](30), @title_4 	[varchar](30), @company_5 	[varchar](100), @jobtitle_6 	[varchar](100), @address_7 	[varchar](100), @lastmoderid_8 	[int], @lastmoddate_9 	[char](10), @lastmodtime_10 	[char](8), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmFamilyInfo]  SET  [resourceid]	 = @resourceid_2, [member]	 = @member_3, [title]	 = @title_4, [company]	 = @company_5, [jobtitle]	 = @jobtitle_6, [address]	 = @address_7, [lastmoderid]	 = @lastmoderid_8, [lastmoddate]	 = @lastmoddate_9, [lastmodtime]	 = @lastmodtime_10  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmJobActivities_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmJobActivities]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmJobActivities_Insert 
 (@jobactivitymark_1 	[varchar](60), @jobactivityname_2 	[varchar](200), @docid_3 	[int], @jobactivityremark_4 	[text], @jobgroupid_5 	[int], @flag integer output, @msg varchar(80) output )  AS if  @docid_3 = 0 set  @docid_3  = null INSERT INTO [HrmJobActivities] ( [jobactivitymark], [jobactivityname], [docid], [jobactivityremark], [jobgroupid])  VALUES ( @jobactivitymark_1, @jobactivityname_2, @docid_3, @jobactivityremark_4, @jobgroupid_5) select max(id) from  [HrmJobActivities] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmJobActivities_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmJobActivities set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmJobActivities_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmJobActivities where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmJobActivities_Update 
 (@id_1 	[int], @jobactivitymark_2 	[varchar](60), @jobactivityname_3 	[varchar](200), @docid_4 	[int], @jobactivityremark_5 	[text], @jobgroupid_6 	[int], @flag integer output, @msg varchar(80) output )  AS if  @docid_4= 0  set  @docid_4=null UPDATE [HrmJobActivities]  SET  [jobactivitymark]	 = @jobactivitymark_2, [jobactivityname]	 = @jobactivityname_3, [docid]	 = @docid_4, [jobactivityremark]	 = @jobactivityremark_5, [jobgroupid]	 = @jobgroupid_6  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmJobCall_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmJobCall]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmJobCall_Insert 
 (@name_1 	[varchar](60), @description_2 	[varchar](60), @flag integer output, @msg varchar(80) output) AS INSERT INTO [HrmJobCall] ( [name], [description])  VALUES ( @name_1, @description_2) 
GO

 CREATE PROCEDURE HrmJobCall_Select 
 @flag integer output , @msg varchar(80) output  AS select * from HrmJobCall set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmJobCall_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmJobCall where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmJobCall_Update 
 (@id_1 	[int], @name_2 	[varchar](60), @description_3 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmJobCall]  SET  [name]	 = @name_2, [description]	 = @description_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmJobGroups_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmJobGroups]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmJobGroups_Insert 
 (@jobgroupmark_1 	[varchar](60), @jobgroupname_2 	[varchar](200), @docid_3 	[int], @jobgroupremark_4 	[text], @flag integer output, @msg varchar(80) output )  AS if @docid_3=0 set @docid_3=null INSERT INTO [HrmJobGroups] ( [jobgroupmark], [jobgroupname], [docid], [jobgroupremark])  VALUES ( @jobgroupmark_1, @jobgroupname_2, @docid_3, @jobgroupremark_4) select max(id) from [HrmJobGroups] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmJobGroups_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmJobGroups set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmJobGroups_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmJobGroups where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmJobGroups_Update 
 (@id_1 	[int], @jobgroupmark_2 	[varchar](60), @jobgroupname_3 	[varchar](200), @docid_4 	[int], @jobgroupremark_5 	[text], @flag integer output, @msg varchar(80) output )  AS if @docid_4=0 set @docid_4=null UPDATE [HrmJobGroups]  SET  [jobgroupmark]	 = @jobgroupmark_2, [jobgroupname]	 = @jobgroupname_3, [docid]	 = @docid_4, [jobgroupremark]	 = @jobgroupremark_5  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmJobTitles_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmJobTitles]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmJobTitles_Insert 
 (@jobtitlemark_1 	[varchar](60), @jobtitlename_2 	[varchar](200), @seclevel_3 	[tinyint], @joblevelfrom_4 	[tinyint], @joblevelto_5 	[tinyint], @docid_6 	[int], @jobtitleremark_7 	[text], @jobgroupid_8 	[int], @jobactivityid_9 	[int], @flag integer output, @msg varchar(80) output )  AS if  @docid_6 = 0 set  @docid_6  = null INSERT INTO [HrmJobTitles] ( [jobtitlemark], [jobtitlename], [seclevel], [joblevelfrom], [joblevelto], [docid], [jobtitleremark], [jobgroupid], [jobactivityid])  VALUES ( @jobtitlemark_1, @jobtitlename_2, @seclevel_3, @joblevelfrom_4, @joblevelto_5, @docid_6, @jobtitleremark_7, @jobgroupid_8, @jobactivityid_9) select max(id) from  [HrmJobTitles] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmJobTitles_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmJobTitles set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmJobTitles_Update 
 (@id_1 	[int], @jobtitlemark_2 	[varchar](60), @jobtitlename_3 	[varchar](200), @seclevel_4 	[tinyint], @joblevelfrom_5 	[tinyint], @joblevelto_6 	[tinyint], @docid_7 	[int], @jobtitleremark_8 	[text], @jobgroupid_9 	[int], @jobactivityid_10 	[int], @flag integer output, @msg varchar(80) output )  AS if  @docid_7 = 0 set  @docid_7  = null UPDATE [HrmJobTitles]  SET  [jobtitlemark]	 = @jobtitlemark_2, [jobtitlename]	 = @jobtitlename_3, [seclevel]	 = @seclevel_4, [joblevelfrom]	 = @joblevelfrom_5, [joblevelto]	 = @joblevelto_6, [docid]	 = @docid_7, [jobtitleremark]	 = @jobtitleremark_8, [jobgroupid]	 = @jobgroupid_9, [jobactivityid]	 = @jobactivityid_10  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO





--职务类别删除
 CREATE PROCEDURE HrmJobType_Delete 
	(@id_1 	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS DELETE [HrmJobType] 

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE HrmJobType_Insert 
 (@name_1 	[varchar](60), @description_2 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmJobType] ( [name], [description])  VALUES ( @name_1, @description_2) 
GO

 CREATE PROCEDURE HrmJobType_Select 
 @flag integer output , @msg varchar(80) output  AS select * from HrmJobType set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmJobType_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmJobType where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmJobType_Update 
 (@id_1 	[int], @name_2 	[varchar](60), @description_3 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmJobType]  SET  [name]	 = @name_2, [description]	 = @description_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmLanguageAbility_Delete 
	(@id_1 	[int],
	@flag integer output,
	 @msg varchar(80) output)

AS DELETE [HrmLanguageAbility] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmLanguageAbility_Insert 
	(@resourceid_1 	[int],
	 @language_2 	[varchar](30),
	 @level_3 	[char](1),
	 @memo_4 	[text],
	 @createid_5 	[int],
	 @createdate_6 	[char](10),
	 @createtime_7 	[char](8),
	 @lastmoderid_8 	[int],
	 @lastmoddate_9 	[char](10),
	 @lastmodtime_10 	[char](8),
	@flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [HrmLanguageAbility] 
	 ( [resourceid],
	 [language],
	 [level_n],
	 [memo],
	 [createid],
	 [createdate],
	 [createtime],
	 [lastmoderid],
	 [lastmoddate],
	 [lastmodtime]) 
 
VALUES 
	( @resourceid_1,
	 @language_2,
	 @level_3,
	 @memo_4,
	 @createid_5,
	 @createdate_6,
	 @createtime_7,
	 @lastmoderid_8,
	 @lastmoddate_9,
	 @lastmodtime_10)

GO

 CREATE PROCEDURE HrmLanguageAbility_SByResourID 
	 @resourceid varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from HrmLanguageAbility
      where resourceid =convert(int, @resourceid) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE HrmLanguageAbility_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from HrmLanguageAbility
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE HrmLanguageAbility_Update 
	(@id_1 	[int],
	 @resourceid_2 	[int],
	 @language_3 	[varchar](30),
	 @level_4 	[char](1),
	 @memo_5 	[text],
	 @lastmoderid_9 	[int],
	 @lastmoddate_10 	[char](10),
	 @lastmodtime_11 	[char](8),
	@flag integer output,
	 @msg varchar(80) output)

AS UPDATE [HrmLanguageAbility] 

SET  [resourceid]	 = @resourceid_2,
	 [language]	 = @language_3,
	 [level_n]	 = @level_4,
	 [memo]	 = @memo_5,
	 [lastmoderid]	 = @lastmoderid_9,
	 [lastmoddate]	 = @lastmoddate_10,
	 [lastmodtime]	 = @lastmodtime_11 

WHERE 
	( [id]	 = @id_1)

GO

/*20021108*/
 CREATE PROCEDURE HrmList_SelectAll 
(@flag  integer output, @msg  varchar(80) output ) AS
 select id,name,validate_n from HrmListValidate  
 set @flag=0 set @msg='ok'

GO

 CREATE PROCEDURE HrmList_Update 
(@id int,@flag  integer output, @msg  varchar(80) output ) AS
 update HrmListValidate  set validate_n=1 where id=@id
 set @flag=0 set @msg='ok'

GO

 CREATE PROCEDURE HrmLocations_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmLocations]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmLocations_Insert 
 (@locationname_1 	[varchar](200), @locationdesc_2 	[varchar](200), @address1_3 	[varchar](200), @address2_4 	[varchar](200), @locationcity_5 	[varchar](200), @postcode_6 	[varchar](20), @countryid_7 	[int], @telephone_8 	[varchar](60), @fax_9 	[varchar](60), @flag integer output, @msg varchar(80) output )  AS INSERT INTO [HrmLocations] ( [locationname], [locationdesc], [address1], [address2], [locationcity], [postcode], [countryid], [telephone], [fax])  VALUES ( @locationname_1, @locationdesc_2, @address1_3, @address2_4, @locationcity_5, @postcode_6, @countryid_7, @telephone_8, @fax_9) select max(id) from [HrmLocations] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmLocations_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmLocations set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmLocations_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmLocations where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmLocations_Update 
 (@id_1 	[int], @locationname_2 	[varchar](200), @locationdesc_3 	[varchar](200), @address1_4 	[varchar](200), @address2_5 	[varchar](200), @locationcity_6 	[varchar](200), @postcode_7 	[varchar](20), @countryid_8 	[int], @telephone_9 	[varchar](60), @fax_10 	[varchar](60), @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmLocations]  SET  [locationname]	 = @locationname_2, [locationdesc]	 = @locationdesc_3, [address1]	 = @address1_4, [address2]	 = @address2_5, [locationcity]	 = @locationcity_6, [postcode]	 = @postcode_7, [countryid]	 = @countryid_8, [telephone]	 = @telephone_9, [fax]	 = @fax_10  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmOtherInfoType_Delete 
 (@id	int, @flag                             integer output, @msg                             varchar(80) output ) AS delete from hrmotherinfotype where id=@id  if @@error<>0 begin set @flag=1 set @msg='right' return end else begin set @flag=0 set @msg='wrong' return end 
GO

 CREATE PROCEDURE HrmOtherInfoType_Insert 
 ( @typename	varchar(60), @typeremark	varchar(200), @flag                             integer output, @msg                             varchar(80) output ) AS INSERT INTO hrmotherinfotype values(@typename,@typeremark)  select max(id) from hrmotherinfotype  if @@error<>0 begin set @flag=1 set @msg='y' return end else begin set @flag=0 set @msg='n' return end 
GO

 CREATE PROCEDURE HrmOtherInfoType_SelectAll 
 (  @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmOtherInfoType order by id  if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmOtherInfoType_Update 
 (@id	int, @typename	varchar(60), @typeremark	varchar(200), @flag                             integer output, @msg                             varchar(80) output ) AS update hrmotherinfotype set typename=@typename,typeremark=@typeremark where id=@id  if @@error<>0 begin set @flag=1 set @msg='y' return end else begin set @flag=0 set @msg='n' return end 
GO

 CREATE PROCEDURE HrmPlanColor_SelectByID 
	(@resourceid	int,
	 @flag integer output,
	 @msg varchar(80) output)
AS
	select * from hrmplancolor where resourceid=@resourceid

GO

/* 8.27 */
 CREATE PROCEDURE HrmPlanColor_Update 
	(@resourceid	int,
	 @basictype		int,
	 @colorid1		varchar(6),
	 @colorid2		varchar(6),
	 @flag integer output,
	 @msg varchar(80) output)
AS
	declare @count	int
	select @count=count(*) from HrmPlancolor 
	where resourceid=@resourceid and basictype=@basictype
	if	@count=0 
	begin
		insert into hrmplancolor (resourceid,basictype,colorid1,colorid2)
		values(@resourceid,@basictype,@colorid1,@colorid2)
	end
	else
	begin
		update hrmplancolor set colorid1=@colorid1 ,colorid2=@colorid2
		where resourceid=@resourceid and basictype=@basictype
	end

GO

 CREATE PROCEDURE HrmProvince_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmProvince]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmProvince_Insert 
 (@provincename_1 	[varchar](60),
 @provincedesc_2 	[varchar](200), 
 @countryid_3 [int],
 @flag integer output,
 @msg varchar(80) output ) 
 AS
 declare @maxid	int
 select @maxid=max(id)+1 from HrmProvince 
 INSERT INTO [HrmProvince] ([id], [provincename], [provincedesc],[countryid])  
 VALUES (@maxid, @provincename_1, @provincedesc_2, @countryid_3) 
 select max(id) from [HrmProvince] 
 if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end
 else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmProvince_Select 
 @countryid_1 int , @flag integer output , @msg varchar(80) output AS if @countryid_1 = 0 begin select * from HrmProvince end else begin select * from HrmProvince where countryid = @countryid_1 end set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmProvince_Update 
 (@id_1 	[int], @provincename_2 	[varchar](60), @provincedesc_3 	[varchar](200), @countryid_4 [int] , @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmProvince]  SET  [provincename]	 = @provincename_2, [provincedesc]	 = @provincedesc_3, [countryid] = @countryid_4  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmPubHoliday_Copy 
 (@fromyear varchar(4), @toyear       varchar(4), @countryid varchar(4), @flag integer output, @msg varchar(80) output) AS delete from hrmpubholiday where substring(holidaydate,1,4)=@toyear and countryid=@countryid declare @all_cursor cursor, @tempdate varchar(10), @tempname varchar(255)  SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR  select substring(holidaydate,5,6),holidayname from hrmpubholiday where substring(holidaydate,1,4)=@fromyear and countryid=@countryid OPEN @all_cursor  FETCH NEXT FROM @all_cursor INTO @tempdate, @tempname  WHILE @@FETCH_STATUS = 0 begin insert into hrmpubholiday values(@countryid,@toyear+@tempdate,@tempname) FETCH NEXT FROM @all_cursor INTO @tempdate, @tempname end  CLOSE @all_cursor DEALLOCATE @all_cursor  if @@error<>0 begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end 
GO

 CREATE PROCEDURE HrmPubHoliday_Delete 
 (@id int, @countryid  int, @flag integer output, @msg varchar(80) output)  AS delete from hrmpubholiday where id=@id if  @@error<>0 begin set @flag=1 set @msg='失败' end else begin set @flag=0 set @msg='操作成功' end select @flag,@msg 
GO

 CREATE PROCEDURE HrmPubHoliday_Insert 
 (@countryid_1 	[int], @holidaydate_2 	[char](10), @holidayname_3 	[varchar](200), @flag integer output, @msg varchar(80) output)  AS if  not exists( select * from hrmpubholiday where countryid=@countryid_1 and holidaydate=@holidaydate_2) begin INSERT INTO [HrmPubHoliday] ( [countryid], [holidaydate], [holidayname])  VALUES ( @countryid_1, @holidaydate_2, @holidayname_3) end select max(id) from hrmpubholiday if @@error<>0 begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end 
GO

 CREATE PROCEDURE HrmPubHoliday_SelectByID 
 (@id 	int, @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmPubHoliday where id=@id if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmPubHoliday_SelectByYear 
 (@year 	[char](4), @countryid    int, @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmPubHoliday where substring(holidaydate,1,4)=@year and countryid=@countryid order by holidaydate if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmPubHoliday_Update 
 (@id int, @countryid 	[int], @holidaydate 	[char](10), @holidayname 	[varchar](200), @flag integer output, @msg varchar(80) output)  AS update [HrmPubHoliday] set countryid=@countryid, holidaydate=@holidaydate, holidayname=@holidayname where id=@id if @@error<>0 begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end 
GO

 CREATE PROCEDURE HrmResourceCompetency_Insert 
 (@resourceid_1 	[int], @competencyid_2 	[int], @currentgrade_3 	[real], @currentdate_4 	[char](10), @flag                             integer output, @msg                             varchar(80) output )  AS DECLARE @recordercount integer Select @recordercount = count(id) from HrmResourceCompetency where resourceid = @resourceid_1 and competencyid = @competencyid_2  if @recordercount = 0 begin INSERT INTO [HrmResourceCompetency] ( [resourceid], [competencyid], [currentgrade], [currentdate], [countgrade], [counttimes])  VALUES ( @resourceid_1, @competencyid_2, @currentgrade_3, @currentdate_4, @currentgrade_3, 1) end else begin Update [HrmResourceCompetency] set lastgrade = currentgrade , lastdate = currentdate, currentgrade = @currentgrade_3, currentdate = @currentdate_4, countgrade = countgrade + @currentgrade_3, counttimes = counttimes+1 where resourceid = @resourceid_1 and competencyid = @competencyid_2 end 
GO

 CREATE PROCEDURE HrmResourceCompetency_SByID 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmResourceCompetency where resourceid = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源技能信息成功' return end else begin set @flag=0 set @msg='查询人力资源技能信息失败' return end 
GO

 CREATE PROCEDURE HrmResourceCompetency_Update 
 (@resourceid_1 	[int], @competencyid_2 	[int], @currentgrade_3 	[real], @currentdate_4 	[char](10), @flag                             integer output, @msg                             varchar(80) output )  AS DECLARE @recordercount integer Select @recordercount = count(id) from HrmResourceCompetency where resourceid = @resourceid_1 and competencyid = @competencyid_2  if @recordercount = 0 begin INSERT INTO [HrmResourceCompetency] ( [resourceid], [competencyid], [currentgrade], [currentdate], [countgrade], [counttimes])  VALUES ( @resourceid_1, @competencyid_2, @currentgrade_3, @currentdate_4, @currentgrade_3, 1) end else begin Update [HrmResourceCompetency] set countgrade = countgrade - currentgrade + @currentgrade_3, currentgrade = @currentgrade_3 where resourceid = @resourceid_1 and competencyid = @competencyid_2 end 
GO

 CREATE PROCEDURE HrmResourceComponent_Delete 
 (@id_1 	[int], @flag int output, @msg varchar(80) output)  AS DELETE [HrmResourceComponent]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmResourceComponent_Insert 
 (@resourceid_1 	[int], @componentid_2 	[int], @componentmark_3 	varchar(60), @selbank_6 	[char](1), @salarysum_8 	[decimal](18,3), @canedit 	[char](1), @currencyid_9 	[int], @startdate_10 	[char](10), @enddate_11 	[char](10), @remark_13 	[text], @createid_14 	[int], @createdate_15 	[char](10), @flag int output, @msg varchar(80) output)  AS declare @ledgerid_4 [int], @bankid_7 [int] ,@componentperiod_5 	[char](1) if @selbank_6 = '1' select @bankid_7 = bankid1 from HrmResource where id = @resourceid_1 else select @bankid_7 = bankid2 from HrmResource where id = @resourceid_1  select @ledgerid_4 = ledgerid, @componentperiod_5 = componentperiod from HrmSalaryComponent where id = @componentid_2  INSERT INTO [HrmResourceComponent] ( [resourceid], [componentid], [componentmark], [ledgerid], [componentperiod], [selbank], [bankid], [salarysum], [canedit], [currencyid], [startdate], [enddate], [hasused], [remark], [createid], [createdate])  VALUES ( @resourceid_1, @componentid_2, @componentmark_3, @ledgerid_4, @componentperiod_5, @selbank_6, @bankid_7, @salarysum_8, @canedit, @currencyid_9, @startdate_10, @enddate_11, '0', @remark_13, @createid_14, @createdate_15) 
GO

 CREATE PROCEDURE HrmResourceComponent_SByID 
 (@id_1 	[int], @flag int output, @msg varchar(80) output) AS select * from HrmResourceComponent where id = @id_1 
GO

 CREATE PROCEDURE HrmResourceComponent_SByResour 
 (@id_1 	[int], @flag int output, @msg varchar(80) output) AS select * from HrmResourceComponent where resourceid = @id_1 
GO

 CREATE PROCEDURE HrmResourceComponent_Update 
 (@id_1 	[int], @resourceid_1 	[int], @componentid_2 	[int], @componentmark_3 	varchar(60), @selbank_6 	[char](1), @salarysum_8 	[decimal](18,3), @canedit       char(1), @currencyid_9 	[int], @startdate_10 	[char](10), @enddate_11 	[char](10), @remark_13 	[text], @lastmoderid_14 	[int], @lastmoddate_15 	[char](10), @flag int output, @msg varchar(80) output)  AS declare @ledgerid_4 [int], @bankid_7 [int] ,@componentperiod_5 	[char](1) if @selbank_6 = '1' select @bankid_7 = bankid1 from HrmResource where id = @resourceid_1 else select @bankid_7 = bankid2 from HrmResource where id = @resourceid_1  select @ledgerid_4 = ledgerid, @componentperiod_5 = componentperiod from HrmSalaryComponent where id = @componentid_2   UPDATE [HrmResourceComponent]  SET  [componentid]	 = @componentid_2, [componentmark]	 = @componentmark_3, [ledgerid]	 = @ledgerid_4, [componentperiod]	 = @componentperiod_5, [selbank]	 = @selbank_6, [bankid]	 = @bankid_7, [salarysum]	 = @salarysum_8, [canedit]       = @canedit , [currencyid]	 = @currencyid_9, [startdate]	 = @startdate_10, [enddate]	 = @enddate_11, [remark]	 = @remark_13, [lastmoderid]	 = @lastmoderid_14, [lastmoddate]	 = @lastmoddate_15  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmResourceOtherInfo_Delete 
 (@id_1 	[int], @flag int output, @msg varchar(80) output)  AS DELETE [HrmResourceOtherInfo]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmResourceOtherInfo_Insert 
 (@resourceid_1 	[int], @infoname_2 	[varchar](100), @startdate_3 	[char](10), @enddate_4 	[char](10), @docid_5 	[int], @inforemark_6 	[text], @infotype_7 	[int], @seclevel_8 	[tinyint], @createid_9 	[int], @createdate_10 	[char](10), @flag int output, @msg varchar(80) output)  AS if @docid_5 =0 set  @docid_5 = null INSERT INTO [HrmResourceOtherInfo] ( [resourceid], [infoname], [startdate], [enddate], [docid], [inforemark], [infotype], [seclevel], [createid], [createdate])  VALUES ( @resourceid_1, @infoname_2, @startdate_3, @enddate_4, @docid_5, @inforemark_6, @infotype_7, @seclevel_8, @createid_9, @createdate_10) 


GO

 CREATE PROCEDURE HrmResourceOtherInfo_SByID 
 (@id  int, @flag int output, @msg varchar(80) output) as select * from HrmResourceOtherInfo  where id = @id 
GO

 CREATE PROCEDURE HrmResourceOtherInfo_SByType 
 (@userid  int, @typeid   int, @seclevel  tinyint, @flag int output, @msg varchar(80) output) as select id , infoname ,inforemark from HrmResourceOtherInfo where resourceid = @userid and infotype = @typeid and seclevel <= @seclevel 
GO

 CREATE PROCEDURE HrmResourceOtherInfo_Select 
 (@userid  int, @flag int output, @msg varchar(80) output) as select infotype ,'infocount'=count(id) from HrmResourceOtherInfo  where resourceid = @userid group by infotype 
GO

 CREATE PROCEDURE HrmResourceOtherInfo_SByType2 
  (@userid  int, @typeid   int, @flag int output, @msg varchar(80) output) as select inforemark  from HrmResourceOtherInfo where resourceid = @userid and infotype = @typeid 

GO

 CREATE PROCEDURE HrmResourceOtherInfo_Update 
 (@id_1 	[int], @infoname_3 	[varchar](100), @startdate_4 	[char](10), @enddate_5 	[char](10), @docid_6 	[int], @inforemark_7 	[text], @infotype_8 	[int], @seclevel_9 	[tinyint], @lastmoderid_10 	[int], @lastmoddate_11 	[char](10), @flag int output, @msg varchar(80) output)  AS  if @docid_6 =0 set @docid_6 = null UPDATE [HrmResourceOtherInfo]  SET  	 [infoname]	 = @infoname_3, [startdate]	 = @startdate_4, [enddate]	 = @enddate_5, [docid]	 = @docid_6, [inforemark]	 = @inforemark_7, [infotype]	 = @infotype_8, [seclevel]	 = @seclevel_9, [lastmoderid]	 = @lastmoderid_10, [lastmoddate]	 = @lastmoddate_11  WHERE ( [id]	 = @id_1) 


GO

 CREATE PROCEDURE HrmResourceSkill_Delete 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output )  AS DELETE [HrmResourceSkill]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmResourceSkill_Insert 
 (@resourceid_1 	[int], @skilldesc_2 	[varchar](200), @flag                             integer output, @msg                             varchar(80) output )  AS INSERT INTO [HrmResourceSkill] ( [resourceid], [skilldesc])  VALUES ( @resourceid_1, @skilldesc_2) 
GO

 CREATE PROCEDURE HrmResourceSkill_Select 
 (@resourceid_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmResourceSkill where resourceid = @resourceid_1 set @flag=1 set @msg='查询人力资源技能信息成功' 
GO

 CREATE PROCEDURE HrmResourceSkill_SelectByID 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmResourceSkill where id = @id_1 set @flag=1 set @msg='查询人力资源技能信息成功' 
GO

 CREATE PROCEDURE HrmResourceSkill_Update 
 (@id_1 	[int], @skilldesc_2 	[varchar](200), @flag                             integer output, @msg                             varchar(80) output )  AS UPDATE [HrmResourceSkill]  SET  [skilldesc]	 = @skilldesc_2  WHERE ( [id]	 = @id_1) set @flag=1 set @msg='修改人力资源技能信息成功' 
GO

 CREATE PROCEDURE HrmResource_Delete 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output)  AS DELETE [HrmResource]  WHERE ( [id]	 = @id_1)  if @@error<>0 begin set @flag=1 set @msg='删除人力资源信息失败' return end else begin set @flag=0 set @msg='删除人力资源信息成功' return end 
GO

 CREATE PROCEDURE HrmResource_Insert 
 (@resourceid [int],
@loginid_1 	[varchar](60), 
@password_2 	[varchar](100), 
@firstname_3 	[varchar](60),
@lastname_4 	[varchar](60), 
@aliasname_5 	[varchar](60), 
@titleid_6 	[int],
 @sex_8 	[char](1), 
@birthday_9 	[char](10),
 @nationality_10 	[int], 
@defaultlanguage_11 	[int], 
@systemlanguage_12 	[int], 
@maritalstatus_13 	[char](1), 
@marrydate_14 	[char](10), 
@telephone_15 	[varchar](60), 
@mobile_16 	[varchar](60), 
@mobilecall_17 	[varchar](60), 
@email_18 	[varchar](60), 
@countryid_19 	[int], 
@locationid_20 	[int], 
@workroom_21 	[varchar](60), 
@homeaddress_22 	[varchar](100), 
@homepostcode_23 	[varchar](20),
 @homephone_24 	[varchar](60), 
@resourcetype_25 	[char](1), 
@startdate_26 	[char](10),
 @enddate_27 	[char](10), 
@contractdate_28 	[char](10),
 @jobtitle_29 	[int], 
@jobgroup_30 	[int],
 @jobactivity_31 	[int],
 @jobactivitydesc_32 	[varchar](200), 
@joblevel_33 	[tinyint], 
@seclevel_34 	[tinyint],
 @departmentid_35 	[int],
 @subcompanyid1_36 	[int], 
@subcompanyid2_37 	[int],
 @subcompanyid3_38 	[int], 
@subcompanyid4_39 	[int], 
@costcenterid_40 	[int], 
@managerid_41 	[int], 
@assistantid_42 	[int], 
@purchaselimit_43 	[decimal],
@currencyid_44 	[int], 
@bankid1_45 	[int], 
@accountid1_46 	[varchar](100), 
@bankid2_47 	[int], 
@accountid2_48 	[varchar](100), 
@securityno_49 	[varchar](100),
 @creditcard_50 	[varchar](100), 
@expirydate_51 	[char](10), 
@resourceimageid_52 	[int], 
@createrid_53 	[int], 
@createdate_54 	[char](10), 
@lastmodid_55 	[int], 
@lastmoddate_56 	[char](10), 
@datefield1 	[varchar](10),
 @datefield2 	[varchar](10),
 @datefield3 	[varchar](10),
 @datefield4 	[varchar](10),
 @datefield5 	[varchar](10),
 @numberfield1 	[float],
 @numberfield2 	[float],
 @numberfield3 	[float],
 @numberfield4 	[float],
 @numberfield5 	[float],
 @textfield1 	[varchar](100), 
@textfield2 	[varchar](100), 
@textfield3 	[varchar](100), 
@textfield4 	[varchar](100), 
@textfield5 	[varchar](100), 
@tinyintfield1 [tinyint], 
@tinyintfield2 [tinyint], 
@tinyintfield3 [tinyint],
 @tinyintfield4 [tinyint], 
@tinyintfield5 [tinyint], 
@certificatecategory	varchar(30),			
@certificatenum		varchar(60),			
@nativeplace		varchar(100),			
@educationlevel		char(1),			
@bememberdate		char(10),			
@bepartydate		char(10),		
@bedemocracydate		char(10),			
@regresidentplace	varchar(60),				
@healthinfo		char(1),			
@residentplace		varchar(60),			
@policy			varchar(30),			
@degree			varchar(30),			
@height			varchar(10),		
@homepage		varchar(100),			
@train			text,				
@worktype		varchar(60),			
@usekind			int,				
@workcode		varchar(60),			
@contractbegintime	char(10),			
@jobright		varchar(100),	
@jobcall			int,		
@jobtype			int,	
@accumfundaccount	varchar(30),	
@birthplace		varchar(60),
@folk			varchar(30),
@residentphone		varchar(60),
@residentpostcode	varchar(60),
@extphone       	varchar(50),
@flag                             integer output, 
@msg                             varchar(80) output)  
AS if @titleid_6=0 set @titleid_6 = null
 if @nationality_10=0 set @nationality_10 = null 
if @defaultlanguage_11=0 set @defaultlanguage_11 = null if @systemlanguage_12 = 0 set @systemlanguage_12 = null if @countryid_19 = 0 set @countryid_19 = null if @locationid_20 = 0 set @locationid_20 = null if @jobtitle_29 = 0 set @jobtitle_29 = null if @jobgroup_30 = 0 set @jobgroup_30 = null if @jobactivity_31 = 0 set @jobactivity_31 = null if @departmentid_35 = 0 set @departmentid_35 = null if @subcompanyid1_36 = 0 set @subcompanyid1_36 = null if @subcompanyid2_37 = 0 set @subcompanyid2_37 = null if @subcompanyid3_38 = 0 set @subcompanyid3_38 = null if @subcompanyid4_39 = 0 set @subcompanyid4_39 = null if @costcenterid_40 = 0 set @costcenterid_40 = null if @managerid_41 = 0 set @managerid_41 = null if @assistantid_42 = 0 set @assistantid_42 = null if @currencyid_44 = 0 set @currencyid_44 = null if @bankid1_45 = 0 set @bankid1_45 = null 
if @bankid2_47 = 0 set @bankid2_47 = null 
if @usekind = 0 set @usekind = null 
if @jobcall = 0 set @jobcall = null 
if @jobtype = 0 set @jobtype = null 

declare @count   int

/*判断是否有重复登录名*/
select @count=count(*) from HrmResource where loginid = @loginid_1
if @count<>0
begin
select -1
return
end

 INSERT INTO [HrmResource] ([id],[loginid], 
[password], [firstname], [lastname], [aliasname], [titleid], [sex], [birthday], [nationality], 
[defaultlanguage], [systemlanguage], [maritalstatus], [marrydate], [telephone], [mobile], [mobilecall], [email], [countryid], [locationid],
 [workroom], [homeaddress], [homepostcode], [homephone], [resourcetype], [startdate], [enddate], [contractdate], [jobtitle], [jobgroup], 
[jobactivity], [jobactivitydesc], [joblevel], [seclevel], [departmentid], [subcompanyid1], [subcompanyid2], [subcompanyid3], [subcompanyid4],
 [costcenterid], [managerid], [assistantid], [purchaselimit], [currencyid], [bankid1], [accountid1], [bankid2], [accountid2], [securityno],
 [creditcard], [expirydate], [resourceimageid], [createrid], [createdate], [lastmodid], [lastmoddate], [datefield1], [datefield2], [datefield3],
[datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3],
 [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5],
certificatecategory,		
certificatenum,				
nativeplace,					
educationlevel,					
bememberdate,					
bepartydate,			
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
VALUES ( @resourceid,@loginid_1, @password_2, @firstname_3, @lastname_4, @aliasname_5, @titleid_6, @sex_8,
 @birthday_9, @nationality_10, @defaultlanguage_11, @systemlanguage_12, @maritalstatus_13, @marrydate_14, 
@telephone_15, @mobile_16, @mobilecall_17, @email_18, @countryid_19, @locationid_20, @workroom_21, @homeaddress_22,
 @homepostcode_23, @homephone_24, @resourcetype_25, @startdate_26, @enddate_27, @contractdate_28, @jobtitle_29, @jobgroup_30, 
@jobactivity_31, @jobactivitydesc_32, @joblevel_33, @seclevel_34, @departmentid_35, @subcompanyid1_36, @subcompanyid2_37, 
@subcompanyid3_38, @subcompanyid4_39, @costcenterid_40, @managerid_41, @assistantid_42, @purchaselimit_43, @currencyid_44, 
@bankid1_45, @accountid1_46, @bankid2_47, @accountid2_48, @securityno_49, @creditcard_50, @expirydate_51, @resourceimageid_52,
 @createrid_53, @createdate_54, @lastmodid_55, @lastmoddate_56, @datefield1, @datefield2, @datefield3, @datefield4, 
@datefield5, @numberfield1, @numberfield2, @numberfield3, @numberfield4, @numberfield5, @textfield1, @textfield2, @textfield3, 
@textfield4, @textfield5, @tinyintfield1, @tinyintfield2, @tinyintfield3, @tinyintfield4, @tinyintfield5,
@certificatecategory,		
@certificatenum,				
@nativeplace,					
@educationlevel,					
@bememberdate,					
@bepartydate,			
@bedemocracydate,				
@regresidentplace,				
@healthinfo,		
@residentplace,						
@policy,						
@degree,						
@height,				
@homepage,				
@train,						
@worktype,			
@usekind,							
@workcode,					
@contractbegintime,				
@jobright,		
@jobcall,		
@jobtype,	
@accumfundaccount,
@birthplace,
@folk,
@residentphone,
@residentpostcode,
@extphone
)  

SELECT max(id) FROM HrmResource  if @@error<>0 begin set @flag=1 set @msg='插入人力资源信息失败' return end else begin set @flag=0 set @msg='插入人力资源信息成功' return end
GO

 CREATE PROCEDURE HrmResource_SByLoginIDPass 
 ( @loginid   varchar(60), @password  varchar(100), @flag	[int]	output, @msg	[varchar](80)	output ) AS declare @count int select @count = count(id) from HrmResource where loginid= @loginid  if @count <> 0 begin select @count = count(id) from HrmResource where loginid= @loginid and password = @password if @count <> 0 select * from HrmResource where loginid= @loginid else select 0 end 
GO

 CREATE PROCEDURE HrmResource_SCountBySubordinat 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select count(*) from HrmResource where managerid = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源下属总数信息成功' return end else begin set @flag=0 set @msg='查询人力资源下属总数信息失败' return end 
GO

 CREATE PROCEDURE HrmResource_SelectAll 
 (@flag                             integer output, @msg                             varchar(80) output ) AS select id,loginid,firstname,lastname,titleid,sex,resourcetype,email,locationid,workroom, departmentid,costcenterid,jobtitle,managerid,assistantid ,seclevel,joblevel  from HrmResource  if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmResource_SelectByID 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmResource where id = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmResource_SelectByLoginID 
 (@id_1 	[varchar](60), @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmResource where loginid = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmResource_SelectByManagerID 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmResource where managerid = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

 CREATE PROCEDURE HrmResource_SSubordinatesID 
 (@id_1 	[int], @flag       integer output, @msg     varchar(80) output ) AS select id from HrmResource where managerid = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源下属信息成功' return end else begin set @flag=0 set @msg='查询人力资源下属信息失败' return end 
GO

 CREATE PROCEDURE HrmResource_SelectTheSub 
	(@resourceid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
select id from hrmresource where managerid = @resourceid_1

GO

 CREATE PROCEDURE HrmResource_Update 
 (@id_1 	[int], @loginid_2 	[varchar](60), @password_3 	[varchar](100), @firstname_4 	[varchar](60), @lastname_5 	[varchar](60), @aliasname_6 	[varchar](60), @titleid_7 	[int], @sex_9 	[char](1), @birthday_10 	[char](10), @nationality_11 	[int], @defaultlanguage_12 	[int], @systemlanguage_13 	[int], @maritalstatus_14 	[char](1), @marrydate_15 	[char](10), @telephone_16 	[varchar](60), @mobile_17 	[varchar](60), @mobilecall_18 	[varchar](60), @email_19 	[varchar](60), @countryid_20 	[int], @locationid_21 	[int], @workroom_22 	[varchar](60), @homeaddress_23 	[varchar](100), @homepostcode_24 	[varchar](20), @homephone_25 	[varchar](60), @resourcetype_26 	[char](1), @startdate_27 	[char](10), @enddate_28 	[char](10), @contractdate_29 	[char](10), @jobtitle_30 	[int], @jobgroup_31 	[int], @jobactivity_32 	[int], @jobactivitydesc_33 	[varchar](200), @joblevel_34 	[tinyint], @seclevel_35 	[tinyint], @departmentid_36 	[int], @subcompanyid1_37 	[int], @subcompanyid2_38 	[int], @subcompanyid3_39 	[int], @subcompanyid4_40 	[int], @costcenterid_41 	[int], @managerid_42 	[int], @assistantid_43 	[int], @purchaselimit_44 	[decimal], @currencyid_45 	[int], @bankid1_46 	[int], @accountid1_47 	[varchar](100), @bankid2_48 	[int], @accountid2_49 	[varchar](100), @securityno_50 	[varchar](100), @creditcard_51 	[varchar](100), @expirydate_52 	[char](10), @resourceimageid_53 	[int], @lastmodid_54 	[int], @lastmoddate_55 	[char](10), @datefield1 	[varchar](10), @datefield2 	[varchar](10), @datefield3 	[varchar](10), @datefield4 	[varchar](10), @datefield5 	[varchar](10), @numberfield1 	[float], @numberfield2 	[float], @numberfield3 	[float], @numberfield4 	[float], @numberfield5 	[float], @textfield1 	[varchar](100), @textfield2 	[varchar](100), @textfield3 	[varchar](100), @textfield4 	[varchar](100), @textfield5 	[varchar](100), @tinyintfield1 	[tinyint], @tinyintfield2 	[tinyint], @tinyintfield3 	[tinyint], @tinyintfield4 	[tinyint], @tinyintfield5 	[tinyint], 
@certificatecategory	varchar(30),			
@certificatenum		varchar(60),			
@nativeplace		varchar(100),			
@educationlevel		char(1),			
@bememberdate		char(10),			
@bepartydate		char(10),		
@bedemocracydate		char(10),			
@regresidentplace	varchar(60),			
@healthinfo		char(1),			
@residentplace		varchar(60),			
@policy			varchar(30),			
@degree			varchar(30),			
@height			varchar(10),		
@homepage		varchar(100),			
@train			text,				
@worktype		varchar(60),			
@usekind			int,				
@workcode		varchar(60),			
@contractbegintime	char(10),			
@jobright		varchar(100),			
@jobcall			int,				
@jobtype			int,			
@accumfundaccount	varchar(30),	
@birthplace		varchar(60),
@folk			varchar(30),
@residentphone		varchar(60),
@residentpostcode	varchar(60),
@extphone		varchar(50),
@flag                             integer output, @msg                             varchar(80) output) 

AS if @titleid_7=0 set @titleid_7 = null if @nationality_11=0 set @nationality_11 = null if @defaultlanguage_12=0 set @defaultlanguage_12 = null if @systemlanguage_13 = 0 set @systemlanguage_13 = null if @countryid_20 = 0 set @countryid_20 = null if @locationid_21 = 0 set @locationid_21 = null if @jobtitle_30 = 0 set @jobtitle_30 = null if @jobgroup_31 = 0 set @jobgroup_31 = null if @jobactivity_32 = 0 set @jobactivity_32 = null if @departmentid_36 = 0 set @departmentid_36 = null if @subcompanyid1_37 = 0 set @subcompanyid1_37 = null if @subcompanyid2_38 = 0 set @subcompanyid2_38 = null if @subcompanyid3_39 = 0 set @subcompanyid3_39 = null if @subcompanyid4_40 = 0 set @subcompanyid4_40 = null if @costcenterid_41 = 0 set @costcenterid_41 = null if @managerid_42 = 0 set @managerid_42 = null if @assistantid_43 = 0 set @assistantid_43 = null if @currencyid_45 = 0 set @currencyid_45 = null if @bankid1_46 = 0 set @bankid1_46 = null
if @bankid2_48 = 0 set @bankid2_48 = null 
if @usekind = 0 set @usekind = null 
if @jobcall = 0 set @jobcall = null 
if @jobtype = 0 set @jobtype = null 

/*判断是否有重复登录名*/
declare @count int
select @count=count(*) from HrmResource where loginid = @loginid_2 and [id]<>@id_1
if @count<>0
begin
select -1
return
end

if @password_3 != '0'
 UPDATE [HrmResource]  SET  [loginid]	 = @loginid_2, [password]	 = @password_3, [firstname]	 = @firstname_4, [lastname]	 = @lastname_5, [aliasname]	 = @aliasname_6, [titleid]	 = @titleid_7, [sex]	 = @sex_9, [birthday]	 = @birthday_10, [nationality]	 = @nationality_11, [defaultlanguage]	 = @defaultlanguage_12, [systemlanguage]	 = @systemlanguage_13, [maritalstatus]	 = @maritalstatus_14, [marrydate]	 = @marrydate_15, [telephone]	 = @telephone_16, [mobile]	 = @mobile_17, [mobilecall]	 = @mobilecall_18, [email]	 = @email_19, [countryid]	 = @countryid_20, [locationid]	 = @locationid_21, [workroom]	 = @workroom_22, [homeaddress]	 = @homeaddress_23, [homepostcode]	 = @homepostcode_24, [homephone]	 = @homephone_25, [resourcetype]	 = @resourcetype_26, [startdate]	 = @startdate_27, [enddate]	 = @enddate_28, [contractdate]	 = @contractdate_29, [jobtitle]	 = @jobtitle_30, [jobgroup]	 = @jobgroup_31, [jobactivity]	 = @jobactivity_32, [jobactivitydesc]	 = @jobactivitydesc_33, [joblevel]	 = @joblevel_34, [seclevel]	 = @seclevel_35, [departmentid]	 = @departmentid_36, [subcompanyid1]	 = @subcompanyid1_37, [subcompanyid2]	 = @subcompanyid2_38, [subcompanyid3]	 = @subcompanyid3_39, [subcompanyid4]	 = @subcompanyid4_40, [costcenterid]	 = @costcenterid_41, [managerid]	 = @managerid_42, [assistantid]	 = @assistantid_43, [purchaselimit]	 = @purchaselimit_44, [currencyid]	 = @currencyid_45, [bankid1]	 = @bankid1_46, [accountid1]	 = @accountid1_47, [bankid2]	 = @bankid2_48, [accountid2]	 = @accountid2_49, [securityno]	 = @securityno_50, [creditcard]	 = @creditcard_51, [expirydate]	 = @expirydate_52, [resourceimageid]	 = @resourceimageid_53, [lastmodid]	 = @lastmodid_54, [lastmoddate]	 = @lastmoddate_55 , [datefield1]	 = @datefield1, [datefield2]	 = @datefield2, [datefield3]	 = @datefield3, [datefield4]	 = @datefield4, [datefield5]	 = @datefield5, [numberfield1]	 = @numberfield1, [numberfield2]	 = @numberfield2, [numberfield3]	 = @numberfield3, [numberfield4]	 = @numberfield4, [numberfield5]	 = @numberfield5, [textfield1]	 = @textfield1, [textfield2]	 = @textfield2, [textfield3]	 = @textfield3, [textfield4]	 = @textfield4, [textfield5]	 = @textfield5, [tinyintfield1]	 = @tinyintfield1, [tinyintfield2]	 = @tinyintfield2, [tinyintfield3]	 = @tinyintfield3, [tinyintfield4]	 = @tinyintfield4, 
[tinyintfield5]	 = @tinyintfield5 ,
certificatecategory = @certificatecategory,			
certificatenum	= @certificatenum,			
nativeplace = @nativeplace,		
educationlevel = @educationlevel,			
bememberdate = @bememberdate,			
bepartydate = @bepartydate,
bedemocracydate = @bedemocracydate,			
regresidentplace = @regresidentplace,				
healthinfo = @healthinfo,			
residentplace = @residentplace,			
policy = @policy,		
degree = @degree,	
height = @height,
homepage = @homepage,			
train = @train,				
worktype = @worktype,			
usekind	= @usekind,				
workcode = @workcode,			
contractbegintime = @contractbegintime,		
jobright = @jobright,			
jobcall	= @jobcall,				
jobtype	= @jobtype,			
accumfundaccount = @accumfundaccount,
birthplace = @birthplace,
folk = @folk,
residentphone = @residentphone,
residentpostcode = @residentpostcode,
extphone = @extphone
WHERE ( [id]	 = @id_1) 

else 
UPDATE [HrmResource]  SET  [loginid]	 = @loginid_2, [firstname]	 = @firstname_4, [lastname]	 = @lastname_5, [aliasname]	 = @aliasname_6, [titleid]	 = @titleid_7, [sex]	 = @sex_9, [birthday]	 = @birthday_10, [nationality]	 = @nationality_11, [defaultlanguage]	 = @defaultlanguage_12, [systemlanguage]	 = @systemlanguage_13, [maritalstatus]	 = @maritalstatus_14, [marrydate]	 = @marrydate_15, [telephone]	 = @telephone_16, [mobile]	 = @mobile_17, [mobilecall]	 = @mobilecall_18, [email]	 = @email_19, [countryid]	 = @countryid_20, [locationid]	 = @locationid_21, [workroom]	 = @workroom_22, [homeaddress]	 = @homeaddress_23, [homepostcode]	 = @homepostcode_24, [homephone]	 = @homephone_25, [resourcetype]	 = @resourcetype_26, [startdate]	 = @startdate_27, [enddate]	 = @enddate_28, [contractdate]	 = @contractdate_29, [jobtitle]	 = @jobtitle_30, [jobgroup]	 = @jobgroup_31, [jobactivity]	 = @jobactivity_32, [jobactivitydesc]	 = @jobactivitydesc_33, [joblevel]	 = @joblevel_34, [seclevel]	 = @seclevel_35, [departmentid]	 = @departmentid_36, [subcompanyid1]	 = @subcompanyid1_37, [subcompanyid2]	 = @subcompanyid2_38, [subcompanyid3]	 = @subcompanyid3_39, [subcompanyid4]	 = @subcompanyid4_40, [costcenterid]	 = @costcenterid_41, [managerid]	 = @managerid_42, [assistantid]	 = @assistantid_43, [purchaselimit]	 = @purchaselimit_44, [currencyid]	 = @currencyid_45, [bankid1]	 = @bankid1_46, [accountid1]	 = @accountid1_47, [bankid2]	 = @bankid2_48, [accountid2]	 = @accountid2_49, [securityno]	 = @securityno_50, [creditcard]	 = @creditcard_51, [expirydate]	 = @expirydate_52, [resourceimageid]	 = @resourceimageid_53, [lastmodid]	 = @lastmodid_54, [lastmoddate]	 = @lastmoddate_55 , [datefield1]	 = @datefield1, [datefield2]	 = @datefield2, [datefield3]	 = @datefield3, [datefield4]	 = @datefield4, [datefield5]	 = @datefield5, [numberfield1]	 = @numberfield1, [numberfield2]	 = @numberfield2, [numberfield3]	 = @numberfield3, [numberfield4]	 = @numberfield4, [numberfield5]	 = @numberfield5, [textfield1]	 = @textfield1, [textfield2]	 = @textfield2, [textfield3]	 = @textfield3, [textfield4]	 = @textfield4, [textfield5]	 = @textfield5, [tinyintfield1]	 = @tinyintfield1, [tinyintfield2]	 = @tinyintfield2, [tinyintfield3]	 = @tinyintfield3, [tinyintfield4]	 = @tinyintfield4, 
[tinyintfield5]	 = @tinyintfield5 ,
certificatecategory = @certificatecategory,			
certificatenum	= @certificatenum,			
nativeplace = @nativeplace,		
educationlevel = @educationlevel,			
bememberdate = @bememberdate,			
bepartydate = @bepartydate,
bedemocracydate = @bedemocracydate,			
regresidentplace = @regresidentplace,				
healthinfo = @healthinfo,			
residentplace = @residentplace,			
policy = @policy,		
degree = @degree,	
height = @height,
homepage = @homepage,			
train = @train,				
worktype = @worktype,			
usekind	= @usekind,				
workcode = @workcode,			
contractbegintime = @contractbegintime,		
jobright = @jobright,			
jobcall	= @jobcall,				
jobtype	= @jobtype,			
accumfundaccount = @accumfundaccount,
birthplace = @birthplace,
folk = @folk,
residentphone = @residentphone,
residentpostcode = @residentpostcode,
extphone = @extphone
WHERE ( [id]	 = @id_1) 

 if @@error<>0 begin set @flag=1 set @msg='修改人力资源信息失败' return end else begin set @flag=0 set @msg='修改人力资源信息成功' return end

select 1
GO

 CREATE PROCEDURE HrmResource_UpdateLoginDate 
 (@id_1 	[int], @lastlogindate char(10) , @flag                             integer output, @msg                             varchar(80) output ) AS update HrmResource set lastlogindate = @lastlogindate where id = @id_1 
GO

 CREATE PROCEDURE HrmResource_UpdatePassword 
 (@id_1 	[int], @passwordold_2     [varchar](100), @passwordnew_3     [varchar](100), @flag                             integer output, @msg                             varchar(80) output ) AS update HrmResource set password = @passwordnew_3 where id=@id_1 and password = @passwordold_2  if @@ROWCOUNT<>0 begin set @flag=1 set @msg='更改密码成功' select 1 return end else begin set @flag=1 set @msg='更改密码失败' select 2 return end 
GO

 CREATE PROCEDURE HrmResource_UpdatePic 
 (@id_1 	[int], @resourceimageid_2     [int], @flag                             integer output, @msg                             varchar(80) output ) AS update HrmResource set resourceimageid = 0 where id = @id_1 delete ImageFile where imagefileid = @resourceimageid_2  if @@error<>0 begin set @flag=1 set @msg='删除人力资源信息图片成功' return end else begin set @flag=0 set @msg='删除人力资源信息图片失败' return end 
GO

 CREATE PROCEDURE HrmRewardsRecord_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmRewardsRecord]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmRewardsRecord_Insert 
 (@resourceid_1 	[int], @rewardsdate_2 	[char](10), @rewardstype_3 	[int], @remark_4 	[text], @createid_5 	[int], @createdate_6 	[char](10), @createtime_7 	[char](8), @lastmoderid_8 	[int], @lastmoddate_9 	[char](10), @lastmodtime_10 	[char](8), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmRewardsRecord] ( [resourceid], [rewardsdate], [rewardstype], [remark], [createid], [createdate], [createtime], [lastmoderid], [lastmoddate], [lastmodtime])  VALUES ( @resourceid_1, @rewardsdate_2, @rewardstype_3, @remark_4, @createid_5, @createdate_6, @createtime_7, @lastmoderid_8, @lastmoddate_9, @lastmodtime_10) 
GO

 CREATE PROCEDURE HrmRewardsRecord_SByResourceID 
 @resourceid varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmRewardsRecord where resourceid =convert(int, @resourceid) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmRewardsRecord_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmRewardsRecord where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmRewardsRecord_Update 
 (@id_1 	[int], @resourceid_2 	[int], @rewardsdate_3 	[char](10), @rewardstype_4 	[int], @remark_5 	[text], @lastmoderid_6 	[int], @lastmoddate_7 	[char](10), @lastmodtime_8 	[char](8), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmRewardsRecord]  SET  [resourceid]	 = @resourceid_2, [rewardsdate]	 = @rewardsdate_3, [rewardstype]	 = @rewardstype_4, [remark]	 = @remark_5, [lastmoderid]	 = @lastmoderid_6, [lastmoddate]	 = @lastmoddate_7, [lastmodtime]	 = @lastmodtime_8  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmRewardsType_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmRewardsType]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmRewardsType_Insert 
 (@flag_1 	[char](1), @name_2 	[varchar](60), @description_3 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmRewardsType] ( [flag], [name], [description])  VALUES ( @flag_1, @name_2, @description_3) 
GO

 CREATE PROCEDURE HrmRewardsType_Select 
 @flag integer output , @msg varchar(80) output  AS select * from HrmRewardsType set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmRewardsType_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmRewardsType where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmRewardsType_Update 
 (@id_1 	[int], @flag_2 	[char](1), @name_3 	[varchar](60), @description_4 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmRewardsType]  SET  [flag]	 = @flag_2, [name]	 = @name_3, [description]	 = @description_4  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmRightTransfer_CRM 
 @fromid	int, @toid	int, @customerid	int, @flag	int	output, @msg	varchar(80) output as if	@customerid=0 begin declare @all_cursor cursor, @tempid		int SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select id from CRM_CustomerInfo where manager=@fromid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @tempid  WHILE @@FETCH_STATUS = 0 begin update CRM_CustomerInfo set manager=@toid where id=@tempid FETCH NEXT FROM @all_cursor INTO @tempid end CLOSE @all_cursor DEALLOCATE @all_cursor end else update CRM_CustomerInfo set manager=@toid where id=@customerid if @@error<>0 begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end 
GO

 CREATE PROCEDURE HrmRightTransfer_Doc 
	@fromid	int, 
	@toid	int, 
	@docid	int, 
	@todeptid	int, 
	@flag	int	output, 
	@msg	varchar(80) output 
as 
	if	@docid=0 
	begin 
		declare @all_cursor cursor, @tempid		int 
		SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR 
		select id from docdetail where ownerid=@fromid 
		OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @tempid  
		WHILE @@FETCH_STATUS = 0 
		begin 
			update docdetail set ownerid=@toid, docdepartmentid=@todeptid 
			where id=@tempid 
			FETCH NEXT FROM @all_cursor INTO @tempid 
		end 
		CLOSE @all_cursor DEALLOCATE @all_cursor 
	end 
	else 
		update docdetail set ownerid=@toid, docdepartmentid=@todeptid 
		where id=@docid 
		
	if @@error<>0 
	begin 
		set @flag=1 set @msg='插入失败' 
	end 
	else 
	begin 
		set @flag=0 set @msg='操作成功' 
	end

GO

 CREATE PROCEDURE HrmRightTransfer_Project 
 @fromid	int, @toid	int, @projectid	int, @flag	int	output, @msg	varchar(80) output as if	@projectid=0 begin declare @all_cursor cursor, @tempid		int SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select id from Prj_ProjectInfo where manager=@fromid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @tempid  WHILE @@FETCH_STATUS = 0 begin update Prj_ProjectInfo set manager=@toid where id=@tempid FETCH NEXT FROM @all_cursor INTO @tempid end CLOSE @all_cursor DEALLOCATE @all_cursor end else update Prj_ProjectInfo set manager=@toid where id=@projectid if @@error<>0 begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end 
GO

 CREATE PROCEDURE HrmRightTransfer_Resource 
 @fromid	int, @toid	int, @resourceid	int, @flag	int	output, @msg	varchar(80) output as if	@resourceid=0 begin declare @all_cursor cursor, @tempid		int SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select id from hrmresource where managerid=@fromid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @tempid  WHILE @@FETCH_STATUS = 0 begin update hrmresource set managerid=@toid where id=@tempid FETCH NEXT FROM @all_cursor INTO @tempid end CLOSE @all_cursor DEALLOCATE @all_cursor end else update hrmresource set managerid=@toid where id=@resourceid if @@error<>0 begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end 
GO

 CREATE PROCEDURE HrmRoleMembers_Delete 
 (@id_1 	[int], @flag int output, @msg varchar(80) output)  AS DELETE [HrmRoleMembers]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmRoleMembers_Insert 
 @employeeid int, @roleid int, @level_n int, @flag int output, @msg varchar(80) output as declare @count integer select @count = id from HrmRoleMembers where roleid = @roleid and resourceid = @employeeid if @count is null begin insert into HrmRoleMembers(roleid,resourceid,rolelevel) values(@roleid,@employeeid,@level_n) select max(id) from HrmRoleMembers end else begin update HrmRoleMembers set rolelevel=@level_n where roleid = @roleid and resourceid = @employeeid select @count end 
GO

 CREATE PROCEDURE HrmRoleMembers_SByDepartmentID 
 (@id_1 	[int], @flag int output, @msg varchar(80) output)  AS select resourceid,roleid,rolelevel from HrmRoleMembers, HrmResource WHERE HrmRoleMembers.resourceid = HrmResource.id and HrmResource.departmentid = @id_1 order by resourceid , rolelevel desc 
GO

 CREATE PROCEDURE HrmRoleMembers_SByResourceID 
 (@id_1 	[int], @flag int output, @msg varchar(80) output)  AS select * from HrmRoleMembers WHERE ( [resourceid] = @id_1) 
GO

 CREATE PROCEDURE HrmRoleMembers_SelectByID 
 (@id_1 	[int], @flag int output, @msg varchar(80) output)  AS select * from HrmRoleMembers WHERE ( [id] = @id_1) 
GO

 CREATE PROCEDURE HrmRoleMembers_SByIDandLevel 
 (@id_1 	[int], @level_n char(1), @flag int output, @msg varchar(80) output)  AS select * from HrmRoleMembers WHERE ( [roleid] = @id_1) and [rolelevel] >= @level_n 
GO

 CREATE PROCEDURE HrmRoleMembers_Update 
 (@id_1 	[int], @rolelevel_2 	[char](1), @flag int output, @msg varchar(80) output)  AS UPDATE [HrmRoleMembers]  SET  [rolelevel]	 = @rolelevel_2  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmRoles_SystemRight 
 @roleid int, @flag int output, @msg varchar(80) output as declare @rightid int , @rolelevel varchar(8), @rightgroupname varchar(80) create table #temp( rightgroup varchar(80), rightlevel char(1), rightid int ) declare right_cursor1 cursor for select rightid,rolelevel from systemrightroles where roleid=@roleid  open right_cursor1 fetch next from right_cursor1 into @rightid , @rolelevel while @@fetch_status=0 begin insert into #temp(rightid,rightlevel) values(@rightid,@rolelevel) select @rightgroupname= '' select @rightgroupname=rightgroupname from Systemrightgroups a, SystemRightToGroup b where rightid = @rightid and a.id=b.groupid update #temp set rightgroup = @rightgroupname where rightid = @rightid fetch next from right_cursor1 into @rightid , @rolelevel end close right_cursor1 deallocate right_cursor1 select rightgroup,rightlevel,rightid from #temp order by rightgroup 
GO

 CREATE PROCEDURE HrmRoles_deleteSingle 
 @roleid int, @flag int output, @msg varchar(80) output as begin if exists(select id from hrmrolemembers where roleid=@roleid) begin set @flag=11 select @flag return end else begin delete hrmroles where id=@roleid set @flag=0 select @flag end end 
GO

 CREATE PROCEDURE HrmRoles_insert 
 @rolesmark varchar(60), @rolesname varchar(200), @docid int, @flag int output, @msg varchar(80) output as  if @docid = 0 set @docid = null  begin insert into HrmRoles(rolesmark,rolesname,docid) values(@rolesmark,@rolesname,@docid) if @@error<>0 begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end select id from hrmroles where rolesmark=@rolesmark and rolesname=@rolesname and docid=@docid end 
GO

 CREATE PROCEDURE HrmSalaryComponentDetail_D 
 @componentid	int, @flag                              integer output, @msg                             varchar(80) output  AS delete from HrmSalaryComponentDetail where componentid=@componentid  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSalaryComponentDetail_I 
 @componentid	int, @detailmark                   varchar(60), @joblevel              tinyint, @salarysum_temp	varchar(10), @editable	char(1), @flag                              integer output, @msg                             varchar(80) output  AS declare @salarysum	decimal(10,3) if @salarysum_temp='' set @salarysum=null else set @salarysum=@salarysum_temp INSERT INTO [HrmSalaryComponentDetail] VALUES(@componentid,@detailmark,@joblevel,@salarysum,@editable)  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSalaryComponentDetail_SByID 
 @id   int, @flag integer output , @msg varchar(80) output AS select * from HrmSalaryComponentDetail where  componentid= @id set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSalaryComponentTypes_Delete 
 @id                                  int, @flag                              integer output, @msg                             varchar(80) output  AS delete from HrmSalaryComponentTypes where id=@id  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSalaryComponentTypes_Insert 
 @typemark                     varchar(60), @typename                    varchar(200), @colorid                         varchar(6), @typeorder	            int, @flag                              integer output, @msg                             varchar(80) output  AS INSERT INTO [HrmSalaryComponentTypes] VALUES (@typemark,@typename,@colorid,@typeorder)  select max(id) from [HrmSalaryComponentTypes]  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSalaryComponentTypes_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmSalaryComponentTypes order by typeorder set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSalaryComponentTypes_Update 
 @id	int, @typemark                     varchar(60), @typename                    varchar(200), @colorid                         varchar(6), @typeorder	            int, @flag                              integer output, @msg                             varchar(80) output  AS UPDATE hrmsalarycomponenttypes set typemark=@typemark,typename=@typename,colorid=@colorid,typeorder=@typeorder where id=@id  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSalaryComponent_Delete 
 @id	int, @flag                              integer output, @msg                             varchar(80) output  AS DELETE FROM HrmSalaryComponent where id=@id Delete from HrmSalaryComponentDetail where componentid=@id if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSalaryComponent_Insert 
 @componentname	varchar(200), @countryid                   int, @jobactivityid              int, @componenttype	char(1), @componentperiod	char(1), @currencyid	int, @ledgerid	int, @docid		int, @startdate	char(10), @enddate	char(10), @includetex	char(1), @componenttypeid	int, @flag                              integer output, @msg                             varchar(80) output  AS if @countryid=0		set @countryid=null if @currencyid=0	set @currencyid=null if @docid=0		set @docid=null  INSERT INTO [HrmSalaryComponent] VALUES (@componentname,@countryid,@jobactivityid,@componenttype, @componentperiod,@currencyid,@ledgerid,@docid,@startdate, @enddate,@includetex,@componenttypeid)  select max(id) from [HrmSalaryComponent]  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSalaryComponent_S_CheckEx 
 @typeid int, @flag integer output , @msg varchar(80) output AS select * from HrmSalaryComponent where componenttypeid=@typeid set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSalaryComponent_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmSalaryComponent set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSalaryComponent_SelectAll 
 @jobactivityid           int, @countryid	int, @typeid int, @flag integer output , @msg varchar(80) output AS if @jobactivityid=0 and @countryid=0 and @typeid=0 select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 where t1.id=t2.componentid and t1.countryid is null  if @jobactivityid=0 and @countryid=0 and @typeid<>0 select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 where t1.componenttypeid=@typeid and t1.id=t2.componentid and  t1.countryid is null  if @jobactivityid=0 and @countryid<>0 and @typeid=0 select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 where t1.countryid=@countryid and t1.id=t2.componentid  if @jobactivityid<>0 and @countryid=0 and @typeid=0 select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 where  t1.jobactivityid=@jobactivityid and t1.id=t2.componentid and t1.countryid is null  if @jobactivityid=0 and @countryid<>0 and @typeid<>0 select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 where t1.componenttypeid=@typeid and t1.countryid=@countryid and t1.id=t2.componentid  if @jobactivityid<>0 and @countryid=0 and @typeid<>0 select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 where  t1.componenttypeid=@typeid and t1.jobactivityid=@jobactivityid and t1.id=t2.componentid and t1.countryid is null  if @jobactivityid<>0 and @countryid<>0 and @typeid=0 select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 where  t1.countryid=@countryid and t1.jobactivityid=@jobactivityid and t1.id=t2.componentid  if @jobactivityid<>0 and @countryid<>0 and @typeid<>0 select * from hrmsalarycomponent t1, hrmsalarycomponentdetail t2 where t1.componenttypeid=@typeid and t1.countryid=@countryid and t1.jobactivityid=@jobactivityid and t1.id=t2.componentid  set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSalaryComponent_SelectByID 
 @id   int, @flag integer output , @msg varchar(80) output AS select t1.* from HrmSalaryComponent t1 where  t1.id= @id set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSalaryComponent_Update 
 @id	int, @componentname	varchar(200), @countryid                   int, @jobactivityid              int, @componenttype	char(1), @componentperiod	char(1), @currencyid	int, @ledgerid	int, @docid		int, @startdate	char(10), @enddate	char(10), @includetex	char(1), @componenttypeid	int, @flag                              integer output, @msg                             varchar(80) output  AS if @countryid=0		set @countryid=null if @currencyid=0	set @currencyid=null if @docid=0		set @docid=null  update [HrmSalaryComponent] set 	componentname=@componentname, countryid=@countryid, jobactivityid=@jobactivityid, componenttype=@componenttype, componentperiod=@componentperiod, currencyid=@currencyid, ledgerid=@ledgerid, docid=@docid, startdate=@startdate, enddate=@enddate, includetex=@includetex, componenttypeid=@componenttypeid where id=@id  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmScheduleDiff_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmScheduleDiff]  WHERE ( [id]	 = @id_1)  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmScheduleDiff_Insert 
 (@diffname_1 	[varchar](60), @diffdesc_2 	[varchar](200), @difftype_3 	[char](1), @difftime_4 	[char](1), @mindifftime_5 	[smallint], @workflowid_6 	[int], @salaryable_7 	[char](1), @counttype_8 	[char](1), @countnum_9 	[int], @currencyid_10 	[int], @docid_11 	[int], @diffremark_12 	[text], @flag                integer output, @msg                varchar(80) output)  AS INSERT INTO [HrmScheduleDiff] ( [diffname], [diffdesc], [difftype], [difftime], [mindifftime], [workflowid], [salaryable], [counttype], [countnum], [currencyid], [docid], [diffremark])  VALUES ( @diffname_1, @diffdesc_2, @difftype_3, @difftime_4, @mindifftime_5, @workflowid_6, @salaryable_7, @counttype_8, @countnum_9, @currencyid_10, @docid_11, @diffremark_12) select max(id) from [HrmScheduleDiff] if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmScheduleDiff_Select_ByID 
 @id int , @flag integer output , @msg varchar(80) output AS select * from HrmScheduleDiff where id = (@id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmScheduleDiff_Update 
 (@id_1 	[int], @diffname_2 	[varchar](60), @diffdesc_3 	[varchar](200), @difftype_4 	[char](1), @difftime_5 	[char](1), @mindifftime_6 	[smallint], @workflowid_7 	[int], @salaryable_8 	[char](1), @counttype_9 	[char](1), @countnum      [varchar](10), @currencyid_11 	[int], @docid_12 	[int], @diffremark_13 	[text], @flag integer output, @msg varchar(80) output) AS declare  @countnum_10 decimal(10,3) if @docid_12=0         set @docid_12=null if @currencyid_11=0         set @currencyid_11=null if @countnum <>'' set @countnum_10 = convert(decimal(10,3),@countnum) else set @countnum_10 = 0  UPDATE [HrmScheduleDiff]  SET  [diffname]	 = @diffname_2, [diffdesc]	 = @diffdesc_3, [difftype]	 = @difftype_4, [difftime]	 = @difftime_5, [mindifftime]	 = @mindifftime_6, [workflowid]	 = @workflowid_7, [salaryable]	 = @salaryable_8, [counttype]	 = @counttype_9, [countnum]	 = @countnum_10, [currencyid]	 = @currencyid_11, [docid]	 = @docid_12, [diffremark]	 = @diffremark_13  WHERE ( [id]	 = @id_1)  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSchedule_Delete 
 (@id_1 	[int], @flag        integer output, @msg         varchar(80) output) AS DELETE [HrmSchedule]  WHERE ( [id]	 = @id_1)  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSchedule_Insert 
 (@relatedid_1 	[int], @monstarttime1_2 	[char](5), @monendtime1_3 	[char](5), @monstarttime2_4 	[char](5), @monendtime2_5 	[char](5), @tuestarttime1_6 	[char](5), @tueendtime1_7 	[char](5), @tuestarttime2_8 	[char](5), @tueendtime2_9 	[char](5), @wedstarttime1_10 	[char](5), @wedendtime1_11 	[char](5), @wedstarttime2_12 	[char](5), @wedendtime2_13 	[char](5), @thustarttime1_14 	[char](5), @thuendtime1_15 	[char](5), @thustarttime2_16 	[char](5), @thuendtime2_17 	[char](5), @fristarttime1_18 	[char](5), @friendtime1_19 	[char](5), @fristarttime2_20 	[char](5), @friendtime2_21 	[char](5), @satstarttime1_22 	[char](5), @satendtime1_23 	[char](5), @satstarttime2_24 	[char](5), @satendtime2_25 	[char](5), @sunstarttime1_26 	[char](5), @sunendtime1_27 	[char](5), @sunstarttime2_28 	[char](5), @sunendtime2_29 	[char](5), @totaltime                       [char](5), @scheduletype_30 	[char](1), @flag                              integer output, @msg                             varchar(80) output)  AS INSERT INTO [HrmSchedule] ( [relatedid], [monstarttime1], [monendtime1], [monstarttime2], [monendtime2], [tuestarttime1], [tueendtime1], [tuestarttime2], [tueendtime2], [wedstarttime1], [wedendtime1], [wedstarttime2], [wedendtime2], [thustarttime1], [thuendtime1], [thustarttime2], [thuendtime2], [fristarttime1], [friendtime1], [fristarttime2], [friendtime2], [satstarttime1], [satendtime1], [satstarttime2], [satendtime2], [sunstarttime1], [sunendtime1], [sunstarttime2], [sunendtime2], [totaltime], [scheduletype])  VALUES ( @relatedid_1, @monstarttime1_2, @monendtime1_3, @monstarttime2_4, @monendtime2_5, @tuestarttime1_6, @tueendtime1_7, @tuestarttime2_8, @tueendtime2_9, @wedstarttime1_10, @wedendtime1_11, @wedstarttime2_12, @wedendtime2_13, @thustarttime1_14, @thuendtime1_15, @thustarttime2_16, @thuendtime2_17, @fristarttime1_18, @friendtime1_19, @fristarttime2_20, @friendtime2_21, @satstarttime1_22, @satendtime1_23, @satstarttime2_24, @satendtime2_25, @sunstarttime1_26, @sunendtime1_27, @sunstarttime2_28, @sunendtime2_29, @totaltime, @scheduletype_30)  select max(id) from [HrmSchedule] if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSchedule_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmSchedule where scheduletype='0' set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSchedule_Select_All 
 @flag integer output , @msg varchar(80) output AS select id, diffname from HrmScheduleDiff order by id set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSchedule_Select_ByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmSchedule where id = convert(int,@id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmSchedule_Select_CheckExist 
 @relatedid integer, @scheduletype char(1), @flag integer output , @msg varchar(80) output AS select * from HrmSchedule where relatedid = (@relatedid) and scheduletype = (@scheduletype) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmSchedule_Select_Default 
 (@flag                             integer output, @msg                             varchar(80) output ) AS select * from HrmSchedule where scheduletype ='0' 
GO

 CREATE PROCEDURE HrmSchedule_Select_DeptAll 
 @flag integer output , @msg varchar(80) output AS select t1.id,t1.relatedid from HrmSchedule t1 where scheduletype='1' set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSchedule_Select_ResouceAll 
 @flag integer output , @msg varchar(80) output AS select t1.id,t1.relatedid from HrmSchedule t1 where scheduletype='2' set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSchedule_Update 
 (@id_1 	[int], @relatedid_2 	[int], @monstarttime1_3 	[char](5), @monendtime1_4 	[char](5), @monstarttime2_5 	[char](5), @monendtime2_6 	[char](5), @tuestarttime1_7 	[char](5), @tueendtime1_8 	[char](5), @tuestarttime2_9 	[char](5), @tueendtime2_10 	[char](5), @wedstarttime1_11 	[char](5), @wedendtime1_12 	[char](5), @wedstarttime2_13 	[char](5), @wedendtime2_14 	[char](5), @thustarttime1_15 	[char](5), @thuendtime1_16 	[char](5), @thustarttime2_17 	[char](5), @thuendtime2_18 	[char](5), @fristarttime1_19 	[char](5), @friendtime1_20 	[char](5), @fristarttime2_21 	[char](5), @friendtime2_22 	[char](5), @satstarttime1_23 	[char](5), @satendtime1_24 	[char](5), @satstarttime2_25 	[char](5), @satendtime2_26 	[char](5), @sunstarttime1_27 	[char](5), @sunendtime1_28 	[char](5), @sunstarttime2_29 	[char](5), @sunendtime2_30 	[char](5), @totaltime                      [char](5), @scheduletype_31 	[char](1), @flag        integer output, @msg         varchar(80) output) AS UPDATE [HrmSchedule]  SET  [relatedid]	 = @relatedid_2, [monstarttime1]	 = @monstarttime1_3, [monendtime1]	 = @monendtime1_4, [monstarttime2]	 = @monstarttime2_5, [monendtime2]	 = @monendtime2_6, [tuestarttime1]	 = @tuestarttime1_7, [tueendtime1]	 = @tueendtime1_8, [tuestarttime2]	 = @tuestarttime2_9, [tueendtime2]	 = @tueendtime2_10, [wedstarttime1]	 = @wedstarttime1_11, [wedendtime1]	 = @wedendtime1_12, [wedstarttime2]	 = @wedstarttime2_13, [wedendtime2]	 = @wedendtime2_14, [thustarttime1]	 = @thustarttime1_15, [thuendtime1]	 = @thuendtime1_16, [thustarttime2]	 = @thustarttime2_17, [thuendtime2]	 = @thuendtime2_18, [fristarttime1]	 = @fristarttime1_19, [friendtime1]	 = @friendtime1_20, [fristarttime2]	 = @fristarttime2_21, [friendtime2]	 = @friendtime2_22, [satstarttime1]	 = @satstarttime1_23, [satendtime1]	 = @satendtime1_24, [satstarttime2]	 = @satstarttime2_25, [satendtime2]	 = @satendtime2_26, [sunstarttime1]	 = @sunstarttime1_27, [sunendtime1]	 = @sunendtime1_28, [sunstarttime2]	 = @sunstarttime2_29, [sunendtime2]	 = @sunendtime2_30, [totaltime]            = @totaltime, [scheduletype]	 = @scheduletype_31  WHERE ( [id]	 = @id_1)  if @@error<>0 begin set @flag=1 set @msg='操作失败' return end else begin set @flag=0 set @msg='操作成功' return end 
GO

 CREATE PROCEDURE HrmSearchMould_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [HrmSearchMould]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmSearchMould_Insert 
(@mouldname_1 	[varchar](200), 
@userid_2 	[int], 
@resourceid_3 	[int], 
@resourcename_4 	[varchar](60), 
@jobtitle_5 	[int], @activitydesc_6 	[varchar](200), @jobgroup_7 	[int],
 @jobactivity_8 	[int], @costcenter_9 	[int], @competency_10 	[int], 
@resourcetype_11 	[char](1), @status_12 	[char](1), 
@subcompany1_13 	[int], @subcompany2_14 	[int], 
@subcompany3_15 	[int], @subcompany4_16 	[int], 
@department_17 	[int], @location_18 	[int], @manager_19 	[int], 
@assistant_20 	[int], @roles_21 	[int], @seclevel_22 	[tinyint],
@joblevel_23 	[tinyint], @workroom_24 	[varchar](60), 
@telephone_25 	[varchar](60), @startdate_26 	[char](10),
 @enddate_27 	[char](10), @contractdate_28 	[char](10), 
@birthday_29 	[char](10), @sex_30 	[char](1), 
@seclevelTo [tinyint],
@joblevelTo [tinyint],
@startdateTo [char](10),
@enddateTo [char](10),
@contractdateTo [char](10),
@birthdayTo [char](10),
@age [int],
@ageTo [int],
@flag integer output, 
@msg varchar(80) output )  
AS INSERT INTO [HrmSearchMould] ( [mouldname], [userid], [resourceid], 
[resourcename], [jobtitle], [activitydesc], [jobgroup], [jobactivity], [costcenter],
 [competency], [resourcetype], [status], [subcompany1], [subcompany2],
 [subcompany3], [subcompany4], [department], [location], [manager], [assistant], 
[roles], [seclevel], [joblevel], [workroom], [telephone], [startdate], [enddate],
 [contractdate], [birthday], [sex],
seclevelTo,
joblevelTo,
startdateTo,
enddateTo,
contractdateTo,
birthdayTo,
age,
ageTo)
  VALUES ( @mouldname_1, @userid_2, 
@resourceid_3, @resourcename_4, @jobtitle_5, 
@activitydesc_6, @jobgroup_7, @jobactivity_8, 
@costcenter_9, @competency_10, @resourcetype_11, @status_12, 
@subcompany1_13, @subcompany2_14, @subcompany3_15,
 @subcompany4_16, @department_17, @location_18, @manager_19,
 @assistant_20, @roles_21, @seclevel_22, @joblevel_23, @workroom_24,
 @telephone_25, @startdate_26, @enddate_27, @contractdate_28, 
@birthday_29, @sex_30,
@seclevelTo,
@joblevelTo,
@startdateTo,
@enddateTo,
@contractdateTo,
@birthdayTo,
@age,
@ageTo
) 

select max(id) from [HrmSearchMould] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end

GO

 CREATE PROCEDURE HrmSearchMould_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmSearchMould where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmSearchMould_SelectByUserID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmSearchMould where userid =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmSearchMould_Update 
 (@id_1 	[int], 
 @userid_3 	[int], @resourceid_4 	[int],
 @resourcename_5 	[varchar](60), @jobtitle_6 	[int], 
@activitydesc_7 	[varchar](200), @jobgroup_8 	[int], 
@jobactivity_9 	[int], @costcenter_10 	[int],
 @competency_11 	[int], @resourcetype_12 	[char](1), 
@status_13 	[char](1), @subcompany1_14 	[int], 
@subcompany2_15 	[int], @subcompany3_16 	[int], 
@subcompany4_17 	[int], @department_18 	[int],
 @location_19 	[int], @manager_20 	[int], @assistant_21 	[int], 
@roles_22 	[int], @seclevel_23 	[tinyint], @joblevel_24 	[tinyint],
 @workroom_25 	[varchar](60), @telephone_26 	[varchar](60),
 @startdate_27 	[char](10), @enddate_28 	[char](10),
 @contractdate_29 	[char](10), @birthday_30 	[char](10), 
@sex_31 	[char](1), 
@seclevelTo [tinyint],
@joblevelTo [tinyint],
@startdateTo [char](10),
@enddateTo [char](10),
@contractdateTo [char](10),
@birthdayTo [char](10),
@age [int],
@ageTo [int],
@flag integer output, @msg varchar(80) output ) 
 AS UPDATE [HrmSearchMould]  
SET   [userid]	 = @userid_3, [resourceid]	 = @resourceid_4, 
[resourcename]	 = @resourcename_5, [jobtitle]	 = @jobtitle_6, [activitydesc]	 = @activitydesc_7, [jobgroup]	 = @jobgroup_8, [jobactivity]	 = @jobactivity_9, [costcenter]	 = @costcenter_10, [competency]	 = @competency_11, [resourcetype]	 = @resourcetype_12, [status]	 = @status_13, [subcompany1]	 = @subcompany1_14, [subcompany2]	 = @subcompany2_15, [subcompany3]	 = @subcompany3_16, [subcompany4]	 = @subcompany4_17, 
[department]	 = @department_18, [location]	 = @location_19, 
[manager]	 = @manager_20, [assistant]	 = @assistant_21,
 [roles]	 = @roles_22, [seclevel]	 = @seclevel_23,
 [joblevel]	 = @joblevel_24, [workroom]	 = @workroom_25, [telephone]	 = @telephone_26, [startdate]	 = @startdate_27, [enddate]	 = @enddate_28, [contractdate]	 = @contractdate_29, [birthday]	 = @birthday_30, 
[sex]	 = @sex_31 ,
seclevelTo = @seclevelTo,
joblevelTo = @joblevelTo,
startdateTo = @startdateTo,
enddateTo = @enddateTo,
contractdateTo = @contractdateTo,
birthdayTo = @birthdayTo,
age = @age,
ageTo = @ageTo
 WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end

GO

 CREATE PROCEDURE HrmSpeciality_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmSpeciality]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmSpeciality_Insert 
 (@name_1 	[varchar](60), @description_2 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmSpeciality] ( [name], [description])  VALUES ( @name_1, @description_2) 
GO

 CREATE PROCEDURE HrmSpeciality_Select 
 @flag integer output , @msg varchar(80) output  AS select * from HrmSpeciality set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSpeciality_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmSpeciality where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmSpeciality_Update 
 (@id_1 	[int], @name_2 	[varchar](60), @description_3 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmSpeciality]  SET  [name]	 = @name_2, [description]	 = @description_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmSubCompany_Delete 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output)  AS  DECLARE @recordercount integer Select @recordercount = count(id) from HrmDepartment where subcompanyid1 =convert(int, @id_1) or  subcompanyid2=convert(int, @id_1) or  subcompanyid3 =convert(int, @id_1) or  subcompanyid4 =convert(int, @id_1) if @recordercount = 0 begin DELETE [HrmSubCompany]  WHERE ( [id]	 = @id_1) end else begin select '20' end  if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO

 CREATE PROCEDURE HrmSubCompany_Insert 
 (@subcompanyname_1 	[varchar](200), @subcompanydesc_2 	[varchar](200), @companyid_3 	[tinyint], @flag                             integer output, @msg                             varchar(80) output)  AS  INSERT INTO [HrmSubCompany] ( [subcompanyname], [subcompanydesc], [companyid])  VALUES ( @subcompanyname_1, @subcompanydesc_2, @companyid_3) select (max(id)) from [HrmSubCompany] if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO

 CREATE PROCEDURE HrmSubCompany_SByCompanyID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmSubCompany where companyid =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmSubCompany_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmSubCompany set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmSubCompany_Update 
 (@id_1 	[int], @subcompanyname_2 	[varchar](200), @subcompanydesc_3 	[varchar](200), @companyid_4 	[tinyint], @flag                             integer output, @msg                             varchar(80) output)  AS UPDATE [HrmSubCompany]  SET  [subcompanyname]	 = @subcompanyname_2, [subcompanydesc]	 = @subcompanydesc_3, [companyid]	 = @companyid_4  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO

 CREATE PROCEDURE HrmTrainRecord_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmTrainRecord]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmTrainRecord_Insert 
 (@resourceid_1 	[int], @trainstartdate_2 	[char](10), @trainenddate_3 	[char](10), @traintype_4 	[int], @trainrecord_5 	[text], @createid_6 	[int], @createdate_7 	[char](10), @createtime_8 	[char](8), @lastmoderid_9 	[int], @lastmoddate_10 	[char](10), @lastmodtime_11 	[char](8), @trainhour		[decimal](18,3), @trainunit		[varchar](100), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmTrainRecord] ( [resourceid], [trainstartdate], [trainenddate], [traintype], [trainrecord], [createid], [createdate], [createtime], [lastmoderid], [lastmoddate], [lastmodtime], trainhour, trainunit )  VALUES ( @resourceid_1, @trainstartdate_2, @trainenddate_3, @traintype_4, @trainrecord_5, @createid_6, @createdate_7, @createtime_8, @lastmoderid_9, @lastmoddate_10, @lastmodtime_11, @trainhour, @trainunit) 
GO

 CREATE PROCEDURE HrmTrainRecord_SByResourceID 
 @resourceid varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmTrainRecord where resourceid =convert(int, @resourceid) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmTrainRecord_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmTrainRecord where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmTrainRecord_Update 
 (@id_1 	[int], @resourceid_3 	[int], @trainstartdate_4 	[char](10), @trainenddate_2 	[char](10), @traintype_5 	[int], @trainrecord_6 	[text], @lastmoderid_7 	[int], @lastmoddate_8 	[char](10), @lastmodtime_9 	[char](8), @trainhour		[decimal](18,3), @trainunit		[varchar](100), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmTrainRecord]  SET 	 [resourceid]	 = @resourceid_3, [trainstartdate]	 = @trainstartdate_4, [trainenddate]	 = @trainenddate_2, [traintype]	 = @traintype_5, [trainrecord]	 = @trainrecord_6, [lastmoderid]	 = @lastmoderid_7, [lastmoddate]	 = @lastmoddate_8, [lastmodtime]	 = @lastmodtime_9, trainhour	= @trainhour, trainunit		= @trainunit  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmTrainType_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output )  AS DELETE [HrmTrainType]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmTrainType_Insert 
 (@name_1 	[varchar](60), @description_2 	[varchar](60), @flag integer output , @msg varchar(80) output )  AS INSERT INTO [HrmTrainType] ( [name], [description])  VALUES ( @name_1, @description_2) 
GO

 CREATE PROCEDURE HrmTrainType_Select 
 @flag integer output , @msg varchar(80) output  AS select * from HrmTrainType set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmTrainType_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmTrainType where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmTrainType_Update 
 (@id_1 	[int], @name_2 	[varchar](60), @description_3 	[varchar](60), @flag integer output , @msg varchar(80) output )  AS UPDATE [HrmTrainType]  SET  [name]	 = @name_2, [description]	 = @description_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmUseKind_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmUseKind]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmUseKind_Insert 
 (@name_1 	[varchar](60), @description_2 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmUseKind] ( [name], [description])  VALUES ( @name_1, @description_2) 
GO

 CREATE PROCEDURE HrmUseKind_Select 
 @flag integer output , @msg varchar(80) output  AS select * from HrmUseKind set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE HrmUseKind_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmUseKind where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmUseKind_Update 
 (@id_1 	[int], @name_2 	[varchar](60), @description_3 	[varchar](60), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmUseKind]  SET  [name]	 = @name_2, [description]	 = @description_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmUserDefine_Insert 
 (@userid_1 	[int], @hasresourceid_2 	[char](1),
 @hasresourcename_3 	[char](1), @hasjobtitle_4 	[char](1),
 @hasactivitydesc_5 	[char](1), @hasjobgroup_6 	[char](1), 
@hasjobactivity_7 	[char](1), @hascostcenter_8 	[char](1),
 @hascompetency_9 	[char](1), @hasresourcetype_10 	[char](1), 
@hasstatus_11 	[char](1), @hassubcompany_12 	[char](1), 
@hasdepartment_13 	[char](1), @haslocation_14 	[char](1), 
@hasmanager_15 	[char](1), @hasassistant_16 	[char](1), 
@hasroles_17 	[char](1), @hasseclevel_18 	[char](1), 
@hasjoblevel_19 	[char](1), @hasworkroom_20 	[char](1), 
@hastelephone_21 	[char](1), @hasstartdate_22 	[char](1), 
@hasenddate_23 	[char](1), @hascontractdate_24 	[char](1), 
@hasbirthday_25 	[char](1), @hassex_26 	[char](1), 
@projectable_27 	[char](1), @crmable_28 	[char](1),
 @itemable_29 	[char](1), @docable_30 	[char](1),
 @workflowable_31 	[char](1), @subordinateable_32 	[char](1),
 @trainable_33 	[char](1), @budgetable_34 	[char](1), 
@fnatranable_35 	[char](1), @dspperpage_36 	[tinyint], 
@hasage [char](1),
@flag integer output, @msg varchar(80) output )  
AS DECLARE @recordercount integer
 Select @recordercount = count(userid) from HrmUserDefine 
where userid =convert(int, @userid_1)
 if @recordercount = 0
 begin INSERT INTO [HrmUserDefine]
 ( [userid], [hasresourceid], [hasresourcename], [hasjobtitle], 
[hasactivitydesc], [hasjobgroup], [hasjobactivity], [hascostcenter], 
[hascompetency], [hasresourcetype], [hasstatus], [hassubcompany], 
[hasdepartment], [haslocation], [hasmanager], [hasassistant], [hasroles], 
[hasseclevel], [hasjoblevel], [hasworkroom], [hastelephone], 
[hasstartdate], [hasenddate], [hascontractdate], [hasbirthday], [hassex], 
[projectable], [crmable], [itemable], [docable], [workflowable], [subordinateable], 
[trainable], [budgetable], [fnatranable], [dspperpage],hasage)  
VALUES ( @userid_1, @hasresourceid_2, @hasresourcename_3, 
@hasjobtitle_4, @hasactivitydesc_5, @hasjobgroup_6, @hasjobactivity_7, 
@hascostcenter_8, @hascompetency_9, @hasresourcetype_10, 
@hasstatus_11, @hassubcompany_12, @hasdepartment_13,
 @haslocation_14, @hasmanager_15, @hasassistant_16, @hasroles_17, 
@hasseclevel_18, @hasjoblevel_19, @hasworkroom_20, @hastelephone_21,
 @hasstartdate_22, @hasenddate_23, @hascontractdate_24, @hasbirthday_25, 
@hassex_26, @projectable_27, @crmable_28, @itemable_29, @docable_30, 
@workflowable_31, @subordinateable_32, @trainable_33, @budgetable_34,
@fnatranable_35, @dspperpage_36,@hasage) end else begin UPDATE [HrmUserDefine]  SET  [hasresourceid]	 = @hasresourceid_2, [hasresourcename]	 = @hasresourcename_3, [hasjobtitle]	 = @hasjobtitle_4, [hasactivitydesc]	 = @hasactivitydesc_5, [hasjobgroup]	 = @hasjobgroup_6, [hasjobactivity]	 = @hasjobactivity_7, [hascostcenter]	 = @hascostcenter_8, [hascompetency]	 = @hascompetency_9, [hasresourcetype]	 = @hasresourcetype_10, [hasstatus]	 = @hasstatus_11, [hassubcompany]	 = @hassubcompany_12, [hasdepartment]	 = @hasdepartment_13, [haslocation]	 = @haslocation_14, [hasmanager]	 = @hasmanager_15, [hasassistant]	 = @hasassistant_16, [hasroles]	 = @hasroles_17, [hasseclevel]	 = @hasseclevel_18, [hasjoblevel]	 = @hasjoblevel_19, [hasworkroom]	 = @hasworkroom_20, [hastelephone]	 = @hastelephone_21, [hasstartdate]	 = @hasstartdate_22, [hasenddate]	 = @hasenddate_23, [hascontractdate]	 = @hascontractdate_24, [hasbirthday]	 = @hasbirthday_25, [hassex]	 = @hassex_26, [projectable]	 = @projectable_27, [crmable]	 = @crmable_28, [itemable]	 = @itemable_29, [docable]	 = @docable_30, [workflowable]	 = @workflowable_31, [subordinateable]	 = @subordinateable_32, [trainable]	 = @trainable_33, [budgetable]	 = @budgetable_34, [fnatranable]	 = @fnatranable_35, 
[dspperpage]	 = @dspperpage_36, 
hasage = @hasage
WHERE ( [userid]	 = @userid_1) end if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end

GO

 CREATE PROCEDURE HrmUserDefine_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS DECLARE @recordercount integer Select @recordercount = count(userid) from HrmUserDefine where userid =convert(int, @id)  if @recordercount = 0 begin select * from HrmUserDefine where userid =-1 end else begin select * from HrmUserDefine where userid =convert(int, @id) end set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmUserDefine_Update 
 (@userid_1 	[int], @hasresourceid_2 	[char](1), @hasresourcename_3 	[char](1), @hasjobtitle_4 	[char](1), @hasactivitydesc_5 	[char](1), @hasjobgroup_6 	[char](1), @hasjobactivity_7 	[char](1), @hascostcenter_8 	[char](1), @hascompetency_9 	[char](1), @hasresourcetype_10 	[char](1), @hasstatus_11 	[char](1), @hassubcompany_12 	[char](1), @hasdepartment_13 	[char](1), @haslocation_14 	[char](1), @hasmanager_15 	[char](1), @hasassistant_16 	[char](1), @hasroles_17 	[char](1), @hasseclevel_18 	[char](1), @hasjoblevel_19 	[char](1), @hasworkroom_20 	[char](1), @hastelephone_21 	[char](1), @hasstartdate_22 	[char](1), @hasenddate_23 	[char](1), @hascontractdate_24 	[char](1), @hasbirthday_25 	[char](1), @hassex_26 	[char](1), @projectable_27 	[char](1), @crmable_28 	[char](1), @itemable_29 	[char](1), @docable_30 	[char](1), @workflowable_31 	[char](1), @subordinateable_32 	[char](1), @trainable_33 	[char](1), @budgetable_34 	[char](1), @fnatranable_35 	[char](1), @dspperpage_36 	[tinyint], @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmUserDefine]  SET  [hasresourceid]	 = @hasresourceid_2, [hasresourcename]	 = @hasresourcename_3, [hasjobtitle]	 = @hasjobtitle_4, [hasactivitydesc]	 = @hasactivitydesc_5, [hasjobgroup]	 = @hasjobgroup_6, [hasjobactivity]	 = @hasjobactivity_7, [hascostcenter]	 = @hascostcenter_8, [hascompetency]	 = @hascompetency_9, [hasresourcetype]	 = @hasresourcetype_10, [hasstatus]	 = @hasstatus_11, [hassubcompany]	 = @hassubcompany_12, [hasdepartment]	 = @hasdepartment_13, [haslocation]	 = @haslocation_14, [hasmanager]	 = @hasmanager_15, [hasassistant]	 = @hasassistant_16, [hasroles]	 = @hasroles_17, [hasseclevel]	 = @hasseclevel_18, [hasjoblevel]	 = @hasjoblevel_19, [hasworkroom]	 = @hasworkroom_20, [hastelephone]	 = @hastelephone_21, [hasstartdate]	 = @hasstartdate_22, [hasenddate]	 = @hasenddate_23, [hascontractdate]	 = @hascontractdate_24, [hasbirthday]	 = @hasbirthday_25, [hassex]	 = @hassex_26, [projectable]	 = @projectable_27, [crmable]	 = @crmable_28, [itemable]	 = @itemable_29, [docable]	 = @docable_30, [workflowable]	 = @workflowable_31, [subordinateable]	 = @subordinateable_32, [trainable]	 = @trainable_33, [budgetable]	 = @budgetable_34, [fnatranable]	 = @fnatranable_35, [dspperpage]	 = @dspperpage_36  WHERE ( [userid]	 = @userid_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE HrmWelfare_Delete 
	(@id_1 	[int],
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS DELETE [HrmWelfare] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmWelfare_Insert 
	(@resourceid_1 	[int],
	 @datefrom_2 	[char](10),
	 @dateto_3 	[char](10),
	 @basesalary_4 	[decimal](18,2),
	 @homesub_5 	[decimal](18,2),
	 @vehiclesub_6 	[decimal](18,2),
	 @mealsub_7 	[decimal](18,2),
	 @othersub_8 	[decimal](18,2),
	 @adjustreason_9 	[varchar](200),
	 @createid_10 	[int],
	 @createdate_11 	[char](10),
	 @createtime_12 	[char](8),
	 @lastmoderid_13 	[int],
	 @lastmoddate_14 	[char](10),
	 @lastmodtime_15 	[char](8),
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS INSERT INTO [HrmWelfare] 
	 ( [resourceid],
	 [datefrom],
	 [dateto],
	 [basesalary],
	 [homesub],
	 [vehiclesub],
	 [mealsub],
	 [othersub],
	 [adjustreason],
	 [createid],
	 [createdate],
	 [createtime],
	 [lastmoderid],
	 [lastmoddate],
	 [lastmodtime]) 
 
VALUES 
	( @resourceid_1,
	 @datefrom_2,
	 @dateto_3,
	 @basesalary_4,
	 @homesub_5,
	 @vehiclesub_6,
	 @mealsub_7,
	 @othersub_8,
	 @adjustreason_9,
	 @createid_10,
	 @createdate_11,
	 @createtime_12,
	 @lastmoderid_13,
	 @lastmoddate_14,
	 @lastmodtime_15)

GO

 CREATE PROCEDURE HrmWelfare_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from HrmWelfare
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE HrmWelfare_SelectByResourceID 
	 @resourceid varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
AS select * from HrmWelfare
      where resourceid =convert(int, @resourceid) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE HrmWelfare_Update 
	(@id_1 	[int],
	 @resourceid_2 	[int],
	 @datefrom_3 	[char](10),
	 @dateto_4 	[char](10),
	 @basesalary_5 	[decimal](18,2),
	 @homesub_6 	[decimal](18,2),
	 @vehiclesub_7 	[decimal](18,2),
	 @mealsub_8 	[decimal](18,2),
	 @othersub_9 	[decimal](18,2),
	 @adjustreason_10 	[varchar](200),
	 @lastmoderid_11 	[int],
	 @lastmoddate_12 	[char](10),
	 @lastmodtime_13 	[char](8),
	@flag                   integer output, 
	@msg                   varchar(80) output )

AS UPDATE [HrmWelfare] 

SET  [resourceid]	 = @resourceid_2,
	 [datefrom]	 = @datefrom_3,
	 [dateto]	 = @dateto_4,
	 [basesalary]	 = @basesalary_5,
	 [homesub]	 = @homesub_6,
	 [vehiclesub]	 = @vehiclesub_7,
	 [mealsub]	 = @mealsub_8,
	 [othersub]	 = @othersub_9,
	 [adjustreason]	 = @adjustreason_10,
	 [lastmoderid]	 = @lastmoderid_11,
	 [lastmoddate]	 = @lastmoddate_12,
	 [lastmodtime]	 = @lastmodtime_13 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmWorkResumeIn_Delete 
	(@id_1 	[int],
	@flag integer output,
	 @msg varchar(80) output)

AS DELETE [HrmWorkResumeIn] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmWorkResumeIn_Insert 
	(@resourceid_1 	[int],
	 @datefrom_2 	[char](10),
	 @dateto_3 	[char](10),
	 @departmentid_4 	[int],
	 @jobtitle_5 	[int],
	 @joblevel_6 	[tinyint],
	 @createid_7 	[int],
	 @createdate_8 	[char](10),
	 @createtime_9 	[char](8),
	 @lastmoderid_10 	[int],
	 @lastmoddate_11 	[char](10),
	 @lastmodtime_12 	[char](8),
	@flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [HrmWorkResumeIn] 
	 ( [resourceid],
	 [datefrom],
	 [dateto],
	 [departmentid],
	 [jobtitle],
	 [joblevel],
	 [createid],
	 [createdate],
	 [createtime],
	 [lastmoderid],
	 [lastmoddate],
	 [lastmodtime]) 
 
VALUES 
	( @resourceid_1,
	 @datefrom_2,
	 @dateto_3,
	 @departmentid_4,
	 @jobtitle_5,
	 @joblevel_6,
	 @createid_7,
	 @createdate_8,
	 @createtime_9,
	 @lastmoderid_10,
	 @lastmoddate_11,
	 @lastmodtime_12)

GO





--按resourceid查询入职后工作经历
 CREATE PROCEDURE HrmWorkResumeIn_SByResourceID 
	 @resourceid varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
AS select * from HrmWorkResumeIn
      where resourceid =convert(int, @resourceid) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

/*按id查询入职后工作经历*/
 CREATE PROCEDURE HrmWorkResumeIn_SelectByID 
	 @id varchar(100) , 
	 @flag integer output , 
	 @msg varchar(80) output
 AS select * from HrmWorkResumeIn
      where id =convert(int, @id) 
     set  @flag = 0 set  @msg = '查询存储过程成功'

GO

 CREATE PROCEDURE HrmWorkResumeIn_Update 
	(@id_1 	[int],
	 @resourceid_2 	[int],
	 @datefrom_3 	[char](10),
	 @dateto_4 	[char](10),
	 @departmentid_5 	[int],
	 @jobtitle_6 	[int],
	 @joblevel_7 	[tinyint],
	 @lastmoderid_8 	[int],
	 @lastmoddate_9 	[char](10),
	 @lastmodtime_10 	[char](8),
	@flag integer output,
	 @msg varchar(80) output)

AS UPDATE [HrmWorkResumeIn] 

SET  [resourceid]	 = @resourceid_2,
	 [datefrom]	 = @datefrom_3,
	 [dateto]	 = @dateto_4,
	 [departmentid]	 = @departmentid_5,
	 [jobtitle]	 = @jobtitle_6,
	 [joblevel]	 = @joblevel_7,
	 [lastmoderid]	 = @lastmoderid_8,
	 [lastmoddate]	 = @lastmoddate_9,
	 [lastmodtime]	 = @lastmodtime_10 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE HrmWorkResume_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output)  AS DELETE [HrmWorkResume]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE HrmWorkResume_Insert 
 (@resourceid_1 	[int], @startdate_2 	[char](10), @enddate_3 	[char](10), @company_4 	[varchar](100), @companystyle_5 	[int], @jobtitle_6 	[varchar](30), @workdesc_7 	[text], @leavereason_8 	[varchar](200), @createid_9 	[int], @createdate_10 	[char](10), @createtime_11 	[char](8), @lastmoderid_12 	[int], @lastmoddate_13 	[char](10), @lastmodtime_14 	[char](8), @flag integer output, @msg varchar(80) output)  AS INSERT INTO [HrmWorkResume] ( [resourceid], [startdate], [enddate], [company], [companystyle], [jobtitle], [workdesc], [leavereason], [createid], [createdate], [createtime], [lastmoderid], [lastmoddate], [lastmodtime])  VALUES ( @resourceid_1, @startdate_2, @enddate_3, @company_4, @companystyle_5, @jobtitle_6, @workdesc_7, @leavereason_8, @createid_9, @createdate_10, @createtime_11, @lastmoderid_12, @lastmoddate_13, @lastmodtime_14) 
GO

 CREATE PROCEDURE HrmWorkResume_SByResourceID 
 @resourceid varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmWorkResume where resourceid =convert(int, @resourceid) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmWorkResume_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from HrmWorkResume where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE HrmWorkResume_Update 
 (@id_1 	[int], @resourceid_2 	[int], @startdate_3 	[char](10), @enddate_4 	[char](10), @company_5 	[varchar](100), @companystyle_6 	[int], @jobtitle_7 	[varchar](30), @workdesc_8 	[text], @leavereason_9 	[varchar](200), @lastmoderid_13 	[int], @lastmoddate_14 	[char](10), @lastmodtime_15 	[char](8), @flag integer output, @msg varchar(80) output)  AS UPDATE [HrmWorkResume]  SET  [resourceid]	 = @resourceid_2, [startdate]	 = @startdate_3, [enddate]	 = @enddate_4, [company]	 = @company_5, [companystyle]	 = @companystyle_6, [jobtitle]	 = @jobtitle_7, [workdesc]	 = @workdesc_8, [leavereason]	 = @leavereason_9, [lastmoderid]	 = @lastmoderid_13, [lastmoddate]	 = @lastmoddate_14, [lastmodtime]	 = @lastmodtime_15  WHERE ( [id]	 = @id_1) 
GO

/*20021028*/

 CREATE PROCEDURE HtmlLabelIndex_Insert 
	@id		int,
	@indexdesc	varchar(250),
	@flag		int	output, 
	@msg		varchar(80) output
as
	insert into HtmlLabelIndex 
	(id,indexdesc)
	values
	(@id,@indexdesc)



GO

 CREATE PROCEDURE HtmlLabelInfo_Insert 
	@id		int,
        @labelname	varchar(100),
	@langid		int,
	@flag		int	output, 
	@msg		varchar(80) output
as
	insert into HtmlLabelInfo 
	(indexid,labelname,languageid)
	values
	(@id,@labelname,@langid)



GO

 CREATE PROCEDURE ImageFile_DeleteByImagefileID 
	(@imagefileid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS 
delete from ImageFile where imagefileid = @imagefileid_1

GO

 CREATE PROCEDURE LgcAssetAssortment_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output ) AS declare @count integer , @supassortmentid int  /*不能有相同的标识*/ select @count = assetcount from LgcAssetAssortment where id = @id_1 if @count <> 0 begin select -1 return end  select @count = subassortmentcount  from LgcAssetAssortment where id = @id_1 if @count <> 0 begin select -1 return end  select @supassortmentid = supassortmentid from LgcAssetAssortment where id= @id_1 update LgcAssetAssortment set subassortmentcount = subassortmentcount-1 where id= @supassortmentid   DELETE [LgcAssetAssortment] WHERE [id] = @id_1 
GO

 CREATE PROCEDURE LgcAssetAssortment_Insert 
 (@assortmentmark_1 	[varchar](60), @assortmentname_2 	[varchar](60), @seclevel_3 	[tinyint], @resourceid_4 	[int], @assortmentimageid_5 	[int], @assortmentremark_6 	[text], @supassortmentid_7 	[int], @supassortmentstr_8 	[varchar](200), @dff01name_11 	[varchar](100), @dff01use_12 	[tinyint], @dff02name_13 	[varchar](100), @dff02use_14 	[tinyint], @dff03name_15 	[varchar](100), @dff03use_16 	[tinyint], @dff04name_17 	[varchar](100), @dff04use_18 	[tinyint], @dff05name_19 	[varchar](100), @dff05use_20 	[tinyint], @nff01name_21 	[varchar](100), @nff01use_22 	[tinyint], @nff02name_23 	[varchar](100), @nff02use_24 	[tinyint], @nff03name_25 	[varchar](100), @nff03use_26 	[tinyint], @nff04name_27 	[varchar](100), @nff04use_28 	[tinyint], @nff05name_29 	[varchar](100), @nff05use_30 	[tinyint], @tff01name_31 	[varchar](100), @tff01use_32 	[tinyint], @tff02name_33 	[varchar](100), @tff02use_34 	[tinyint], @tff03name_35 	[varchar](100), @tff03use_36 	[tinyint], @tff04name_37 	[varchar](100), @tff04use_38 	[tinyint], @tff05name_39 	[varchar](100), @tff05use_40 	[tinyint], @bff01name_41 	[varchar](100), @bff01use_42 	[tinyint], @bff02name_43 	[varchar](100), @bff02use_44 	[tinyint], @bff03name_45 	[varchar](100), @bff03use_46 	[tinyint], @bff04name_47 	[varchar](100), @bff04use_48 	[tinyint], @bff05name_49 	[varchar](100), @bff05use_50 	[tinyint], @flag integer output, @msg varchar(80) output )  AS declare @count integer  if @supassortmentid_7 <>0 begin /*上级类型不能有物品*/ select @count = assetcount from LgcAssetAssortment where id = @supassortmentid_7 if @count <> 0 begin select -1 return end /*上级类型子类型数+1*/ UPDATE LgcAssetAssortment SET subassortmentcount=subassortmentcount+1 WHERE id = @supassortmentid_7 end  INSERT INTO [LgcAssetAssortment] ( [assortmentmark], [assortmentname], [seclevel], [resourceid], [assortmentimageid], [assortmentremark], [supassortmentid], [supassortmentstr], [subassortmentcount], [assetcount], [dff01name], [dff01use], [dff02name], [dff02use], [dff03name], [dff03use], [dff04name], [dff04use], [dff05name], [dff05use], [nff01name], [nff01use], [nff02name], [nff02use], [nff03name], [nff03use], [nff04name], [nff04use], [nff05name], [nff05use], [tff01name], [tff01use], [tff02name], [tff02use], [tff03name], [tff03use], [tff04name], [tff04use], [tff05name], [tff05use], [bff01name], [bff01use], [bff02name], [bff02use], [bff03name], [bff03use], [bff04name], [bff04use], [bff05name], [bff05use])  VALUES ( @assortmentmark_1, @assortmentname_2, @seclevel_3, @resourceid_4, @assortmentimageid_5, @assortmentremark_6, @supassortmentid_7, @supassortmentstr_8, 0, 0, @dff01name_11, @dff01use_12, @dff02name_13, @dff02use_14, @dff03name_15, @dff03use_16, @dff04name_17, @dff04use_18, @dff05name_19, @dff05use_20, @nff01name_21, @nff01use_22, @nff02name_23, @nff02use_24, @nff03name_25, @nff03use_26, @nff04name_27, @nff04use_28, @nff05name_29, @nff05use_30, @tff01name_31, @tff01use_32, @tff02name_33, @tff02use_34, @tff03name_35, @tff03use_36, @tff04name_37, @tff04use_38, @tff05name_39, @tff05use_40, @bff01name_41, @bff01use_42, @bff02name_43, @bff02use_44, @bff03name_45, @bff03use_46, @bff04name_47, @bff04use_48, @bff05name_49, @bff05use_50) select max(id) from LgcAssetAssortment 
GO

 CREATE PROCEDURE LgcAssetAssortment_SSupAssort 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select supassortmentstr from  LgcAssetAssortment  where id = @id_1 
GO

 CREATE PROCEDURE LgcAssetAssortment_Select 
 @flag integer output , @msg varchar(80) output AS select * from LgcAssetAssortment order by assortmentmark 
GO

 CREATE PROCEDURE LgcAssetAssortment_SelectByID 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output) AS select * from LgcAssetAssortment where id = @id_1 
GO

 CREATE PROCEDURE LgcAssetAssortment_SelectLeaf 
 @flag integer output , @msg varchar(80) output AS select * from LgcAssetAssortment where subassortmentcount = 0 
GO

 CREATE PROCEDURE LgcAssetAssortment_Update 
 (@id_1 	[int], @assortmentmark_2 	[varchar](60), @assortmentname_3 	[varchar](60), @seclevel_4 	[tinyint], @resourceid_5 	[int], @assortmentimageid_6 	[int], @assortmentremark_7 	[text], @supassortmentid_8 	[int], @supassortmentstr_9 	[varchar](200), @dff01name_12 	[varchar](100), @dff01use_13 	[tinyint], @dff02name_14 	[varchar](100), @dff02use_15 	[tinyint], @dff03name_16 	[varchar](100), @dff03use_17 	[tinyint], @dff04name_18 	[varchar](100), @dff04use_19 	[tinyint], @dff05name_20 	[varchar](100), @dff05use_21 	[tinyint], @nff01name_22 	[varchar](100), @nff01use_23 	[tinyint], @nff02name_24 	[varchar](100), @nff02use_25 	[tinyint], @nff03name_26 	[varchar](100), @nff03use_27 	[tinyint], @nff04name_28 	[varchar](100), @nff04use_29 	[tinyint], @nff05name_30 	[varchar](100), @nff05use_31 	[tinyint], @tff01name_32 	[varchar](100), @tff01use_33 	[tinyint], @tff02name_34 	[varchar](100), @tff02use_35 	[tinyint], @tff03name_36 	[varchar](100), @tff03use_37 	[tinyint], @tff04name_38 	[varchar](100), @tff04use_39 	[tinyint], @tff05name_40 	[varchar](100), @tff05use_41 	[tinyint], @bff01name_42 	[varchar](100), @bff01use_43 	[tinyint], @bff02name_44 	[varchar](100), @bff02use_45 	[tinyint], @bff03name_46 	[varchar](100), @bff03use_47 	[tinyint], @bff04name_48 	[varchar](100), @bff04use_49 	[tinyint], @bff05name_50 	[varchar](100), @bff05use_51 	[tinyint], @flag integer output, @msg varchar(80) output )  AS UPDATE [LgcAssetAssortment]  SET  [assortmentmark]	 = @assortmentmark_2, [assortmentname]	 = @assortmentname_3, [seclevel]	 = @seclevel_4, [resourceid]	 = @resourceid_5, [assortmentimageid]	 = @assortmentimageid_6, [assortmentremark]	 = @assortmentremark_7, [supassortmentid]	 = @supassortmentid_8, [supassortmentstr]	 = @supassortmentstr_9, [dff01name]	 = @dff01name_12, [dff01use]	 = @dff01use_13, [dff02name]	 = @dff02name_14, [dff02use]	 = @dff02use_15, [dff03name]	 = @dff03name_16, [dff03use]	 = @dff03use_17, [dff04name]	 = @dff04name_18, [dff04use]	 = @dff04use_19, [dff05name]	 = @dff05name_20, [dff05use]	 = @dff05use_21, [nff01name]	 = @nff01name_22, [nff01use]	 = @nff01use_23, [nff02name]	 = @nff02name_24, [nff02use]	 = @nff02use_25, [nff03name]	 = @nff03name_26, [nff03use]	 = @nff03use_27, [nff04name]	 = @nff04name_28, [nff04use]	 = @nff04use_29, [nff05name]	 = @nff05name_30, [nff05use]	 = @nff05use_31, [tff01name]	 = @tff01name_32, [tff01use]	 = @tff01use_33, [tff02name]	 = @tff02name_34, [tff02use]	 = @tff02use_35, [tff03name]	 = @tff03name_36, [tff03use]	 = @tff03use_37, [tff04name]	 = @tff04name_38, [tff04use]	 = @tff04use_39, [tff05name]	 = @tff05name_40, [tff05use]	 = @tff05use_41, [bff01name]	 = @bff01name_42, [bff01use]	 = @bff01use_43, [bff02name]	 = @bff02name_44, [bff02use]	 = @bff02use_45, [bff03name]	 = @bff03name_46, [bff03use]	 = @bff03use_47, [bff04name]	 = @bff04name_48, [bff04use]	 = @bff04use_49, [bff05name]	 = @bff05name_50, [bff05use]	 = @bff05use_51  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAssetAssortment_UpdatePic 
 (@id_1 	[int], @assortmentimageid_2     [int], @flag                             integer output, @msg                             varchar(80) output ) AS update LgcAssetAssortment set assortmentimageid = 0 where id = @id_1 delete ImageFile where imagefileid = @assortmentimageid_2  if @@error<>0 begin set @flag=1 set @msg='删除图片成功' return end else begin set @flag=0 set @msg='删除图片失败' return end 
GO

 CREATE PROCEDURE LgcAssetCountry_Insert 
 (@assetid_1 	[int], @assetname_2 	[varchar](60), @assetcountyid_3 	[int], @startdate_4 	[char](10), @enddate_5 	[char](10), @departmentid_6 	[int], @resourceid_7 	[int], @assetremark_8 	[text], @currencyid_9 	[int], @salesprice_10 	varchar(30), @costprice_11 	varchar(30), @datefield1_12 	[char](10), @datefield2_13 	[char](10), @datefield3_14 	[char](10), @datefield4_15 	[char](10), @datefield5_16 	[char](10), @numberfield1_17 	[float], @numberfield2_18 	[float], @numberfield3_19 	[float], @numberfield4_20 	[float], @numberfield5_21 	[float], @textfield1_22 	[varchar](100), @textfield2_23 	[varchar](100), @textfield3_24 	[varchar](100), @textfield4_25 	[varchar](100), @textfield5_26 	[varchar](100), @tinyintfield1_27 	[char](1), @tinyintfield2_28 	[char](1), @tinyintfield3_29 	[char](1), @tinyintfield4_30 	[char](1), @tinyintfield5_31 	[char](1), @createrid_32 	[int], @createdate_33 	[char](10), @lastmoderid_34 	[int], @lastmoddate_35 	[char](10), @isdefault_36 	[char](1), @flag integer output, @msg varchar(80) output )  AS declare @count int select @count=count(*) from LgcAssetCountry where assetid=@assetid_1 and assetcountyid=@assetcountyid_3 if @count<>0 begin select -1 return end  set @salesprice_10 = convert([decimal](18,3) , @salesprice_10) set @costprice_11 = convert([decimal](18,3) , @costprice_11)  if @isdefault_36 <>'0' begin UPDATE LgcAssetCountry SET isdefault='0' WHERE assetid = @assetid_1 end  INSERT INTO [LgcAssetCountry] ( [assetid], [assetname], [assetcountyid], [startdate], [enddate], [departmentid], [resourceid], [assetremark], [currencyid], [salesprice], [costprice], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5], [createrid], [createdate], [lastmoderid], [lastmoddate], [isdefault])  VALUES ( @assetid_1, @assetname_2, @assetcountyid_3, @startdate_4, @enddate_5, @departmentid_6, @resourceid_7, @assetremark_8, @currencyid_9, @salesprice_10, @costprice_11, @datefield1_12, @datefield2_13, @datefield3_14, @datefield4_15, @datefield5_16, @numberfield1_17, @numberfield2_18, @numberfield3_19, @numberfield4_20, @numberfield5_21, @textfield1_22, @textfield2_23, @textfield3_24, @textfield4_25, @textfield5_26, @tinyintfield1_27, @tinyintfield2_28, @tinyintfield3_29, @tinyintfield4_30, @tinyintfield5_31, @createrid_32, @createdate_33, @lastmoderid_34, @lastmoddate_35, @isdefault_36) 
GO

 CREATE PROCEDURE LgcAssetCountry_SByAssetID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select * from LgcAssetCountry where assetid = @id_1 
GO

 CREATE PROCEDURE LgcAssetCountry_SSumByResource 
 (@id	 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS select count(id) from LgcAssetCountry where resourceid = @id 
GO

 CREATE PROCEDURE LgcAssetCountry_SelectByID 
 @id_1 	[int], @flag integer output , @msg varchar(80) output AS select * from  LgcAssetCountry where id = @id_1 
GO

 CREATE PROCEDURE LgcAssetCrm_Delete 
 (@id_1 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS DELETE [LgcAssetCrm]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAssetCrm_Insert 
 (@assetid_1 	[int], @crmid_2 	[int], @countryid_3 	[int], @ismain_4 	[char](1), @assetcode_5 	[char](60), @currencyid_6 	[int], @purchaseprice_7 	varchar(30), @taxrate_8 	[int], @unitid_9 	[int], @packageunit_10 	[varchar](100), @supplyremark_11 	[text], @docid_12 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS set @purchaseprice_7 = convert([decimal](18,3) , @purchaseprice_7) if @docid_12 = 0 set @docid_12 = null  INSERT INTO [LgcAssetCrm] ( [assetid], [crmid], [countryid], [ismain], [assetcode], [currencyid], [purchaseprice], [taxrate], [unitid], [packageunit], [supplyremark], [docid])  VALUES ( @assetid_1, @crmid_2, @countryid_3, @ismain_4, @assetcode_5, @currencyid_6, @purchaseprice_7, @taxrate_8, @unitid_9, @packageunit_10, @supplyremark_11, @docid_12) select max(id) from LgcAssetCrm 
GO

 CREATE PROCEDURE LgcAssetCrm_SelectByAsset 
 (@assetid [int], @type [int], @flag integer output , @msg varchar(80) output) AS select a.id,a.crmid,a.countryid,a.purchaseprice,a.currencyid,a.ismain from LgcAssetCrm a,CRM_CustomerInfo b where a.assetid = @assetid and  b.type=@type and a.crmid=b.id order by a.countryid 
GO

 CREATE PROCEDURE LgcAssetCrm_SelectByID 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output) AS select * from LgcAssetCrm where id = @id_1 
GO

 CREATE PROCEDURE LgcAssetCrm_SelectType 
 (@assetid [int], @flag integer output , @msg varchar(80) output) AS SELECT type FROM CRM_CustomerInfo a INNER JOIN LgcAssetCrm b ON a.id = b.crmid where b.assetid=@assetid group by type 
GO

 CREATE PROCEDURE LgcAssetCrm_Update 
 (@id_1 	[int], @assetid_2 	[int], @crmid_3 	[int], @countryid_4 	[int], @ismain_5 	[char](1), @assetcode_6 	[char](60), @currencyid_7 	[int], @purchaseprice_8 	varchar(30), @taxrate_9 	[int], @unitid_10 	[int], @packageunit_11 	[varchar](100), @supplyremark_12 	[text], @docid_13 	[int], @flag integer output , @msg varchar(80) output)  AS set @purchaseprice_8 = convert([decimal](18,3) , @purchaseprice_8) if @docid_13 = 0 set @docid_13 = null  UPDATE [LgcAssetCrm]  SET  [assetid]	 = @assetid_2, [crmid]	 = @crmid_3, [countryid]	 = @countryid_4, [ismain]	 = @ismain_5, [assetcode]	 = @assetcode_6, [currencyid]	 = @currencyid_7, [purchaseprice]	 = @purchaseprice_8, [taxrate]	 = @taxrate_9, [unitid]	 = @unitid_10, [packageunit]	 = @packageunit_11, [supplyremark]	 = @supplyremark_12, [docid]	 = @docid_13  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAssetPrice_Delete 
 (@id_1  [int], @flag integer output , @msg varchar(80) output)  AS select * from LgcAssetPrice where id=@id_1  DELETE [LgcAssetPrice]  WHERE  id = @id_1 
GO

 CREATE PROCEDURE LgcAssetPrice_Insert 
 (@assetid_1 	[int], @assetcountyid_2 	[int], @pricedesc_3 	[varchar](200), @numfrom_4 	[int], @numto_5 	[int], @currencyid_6 	[int], @unitprice_7 	varchar(30), @taxrate_8 	[int], @flag integer output , @msg varchar(80) output)  AS if @numfrom_4 = 0 set @numfrom_4 = null if @numto_5 = 0 set @numto_5 = null  set @unitprice_7 = convert([decimal](18,3) , @unitprice_7)  INSERT INTO [LgcAssetPrice] ( [assetid], [assetcountyid], [pricedesc], [numfrom], [numto], [currencyid], [unitprice], [taxrate])  VALUES ( @assetid_1, @assetcountyid_2, @pricedesc_3, @numfrom_4, @numto_5, @currencyid_6, @unitprice_7, @taxrate_8) select max(id) from LgcAssetPrice 
GO

 CREATE PROCEDURE LgcAssetPrice_Select 
 ( @assetid  int , @countryid  int , @assetcount  float , @flag integer output , @msg varchar(80) output) AS declare @unitprice decimal(18,3) , @taxrate int ,  @currencyid int declare theprice_cursor cursor for select unitprice,taxrate, currencyid from LgcAssetPrice where assetid = @assetid and assetcountyid = @countryid and numfrom <= @assetcount and (numto >= @assetcount or numto=0 or numto is null) open theprice_cursor fetch next from theprice_cursor into @unitprice , @taxrate , @currencyid if @@fetch_status=0 select @unitprice , @taxrate , @currencyid else select salesprice , 0 , currencyid from LgcAssetCountry where assetid = @assetid and assetcountyid = @countryid close theprice_cursor deallocate theprice_cursor 
GO

 CREATE PROCEDURE LgcAssetPrice_SelectByAsset 
 @assetid_1 int, @assetcountryid_2 int, @flag integer output , @msg varchar(80) output AS select * from LgcAssetPrice where assetid=@assetid_1 and assetcountyid=@assetcountryid_2 
GO

 CREATE PROCEDURE LgcAssetPrice_SelectById 
 @id_1 int, @flag integer output , @msg varchar(80) output AS select * from LgcAssetPrice where id=@id_1 
GO

 CREATE PROCEDURE LgcAssetPrice_Update 
 (@id_1 	[int], @pricedesc_4 	[varchar](200), @numfrom_5 	[int], @numto_6 	[int], @currencyid_7 	[int], @unitprice_8 	varchar(30), @taxrate_9 	[int], @flag integer output, @msg varchar(80) output )  AS if @numfrom_5 = 0 set @numfrom_5 = null if @numto_6 = 0 set @numto_6 = null  set @unitprice_8 = convert([decimal](18,3) , @unitprice_8)  UPDATE [LgcAssetPrice]  SET	 [pricedesc]	 = @pricedesc_4, [numfrom]	 = @numfrom_5, [numto]	 = @numto_6, [currencyid]	 = @currencyid_7, [unitprice]	 = @unitprice_8, [taxrate]	 = @taxrate_9  WHERE ( [id]	 = @id_1)  select * from LgcAssetPrice where id = @id_1 
GO

 CREATE PROCEDURE LgcAssetRelationType_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int  select @count = count(id) from LgcConfiguration where relationtypeid = @id_1 if @count <> 0 begin select -1 return end  DELETE [LgcAssetRelationType] WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAssetRelationType_Insert 
 (@typename_1 	[varchar](60), @typedesc_2 	[varchar](200), @typekind_3 	[char](1), @shopadvice_4 	[char](1), @contractlimit_5 	[char](1), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcAssetRelationType] ( [typename], [typedesc], [typekind], [shopadvice], [contractlimit])  VALUES ( @typename_1, @typedesc_2, @typekind_3, @shopadvice_4, @contractlimit_5) select max(id) from LgcAssetRelationType 
GO

 CREATE PROCEDURE LgcAssetRelationType_SByID 
 @id int , @flag integer output , @msg varchar(80) output AS select * from LgcAssetRelationType where id = @id 
GO

 CREATE PROCEDURE LgcAssetRelationType_Select 
 @flag integer output , @msg varchar(80) output AS select * from LgcAssetRelationType 
GO

 CREATE PROCEDURE LgcAssetRelationType_Update 
 (@id_1 	[int], @typename_2 	[varchar](60), @typedesc_3 	[varchar](200), @typekind_4 	[char](1), @shopadvice_5 	[char](1), @contractlimit_6 	[char](1), @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcAssetRelationType]  SET  [typename]	 = @typename_2, [typedesc]	 = @typedesc_3, [typekind]	 = @typekind_4, [shopadvice]	 = @shopadvice_5, [contractlimit]	 = @contractlimit_6  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAssetStock_Delete 
 (@id_1 	[int], @warehouseid_2 	[int], @assetid_3 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int,@inoutid int,@inoutdetailid int select @count=count(*)  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=@warehouseid_2 and b.assetid=@assetid_3 and a.id=b.inoutid and a.stockmodeid<>-2 if @count>0 begin select -1 return end  DELETE [LgcAssetStock]   WHERE ( [id] = @id_1)  select @inoutid=a.id,@inoutdetailid=b.id  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=@warehouseid_2 and b.assetid=@assetid_3 and a.id=b.inoutid  DELETE [LgcStockInOut]   WHERE ( [id] = @inoutid)  DELETE [LgcStockInOutDetail]   WHERE ( [id] = @inoutdetailid) 
GO

 CREATE PROCEDURE LgcAssetStock_EditOrView 
 ( @assetid_3 	[int], @warehouseid_2 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int select @count=count(*)  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=@warehouseid_2 and b.assetid=@assetid_3 and a.id=b.inoutid and a.stockmodeid<>-2 if @count>0 begin select -1 return end else begin select  1 return end 
GO

 CREATE PROCEDURE LgcAssetStock_Insert 
 (@warehouseid_1 	[int], @assetid_2 	[int], @stocknum_3 	[float], @unitprice_4 	varchar(30), @trandefcurrencyid int, @currencyid       int, @exchangerate varchar(30), @flag	[int]	output, @msg	[varchar](80)	output) AS  declare @count int,@maxid int,@temp decimal(18,3)  select @count=count(*)  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=@warehouseid_1 and b.assetid=@assetid_2 and a.id=b.inoutid if @count>0 begin select -1 return end  set @unitprice_4 = convert([decimal](18,3) , @unitprice_4) set @exchangerate = convert([decimal](18,3) , @exchangerate) set @temp=convert([decimal](18,3) , @unitprice_4)  INSERT INTO [LgcAssetStock] ( [warehouseid], [assetid], [stocknum], [unitprice])  VALUES ( @warehouseid_1, @assetid_2, @stocknum_3, @unitprice_4)   INSERT INTO [LgcStockInOut] ( [warehouseid], [stockmodeid], [currencyid], [defcurrencyid], exchangerate, defcountprice, countprice)  VALUES ( @warehouseid_1, -2, @currencyid, @trandefcurrencyid, @exchangerate, @stocknum_3*@temp/@exchangerate, @stocknum_3*@unitprice_4)  select @maxid=max(id) from LgcStockInOut  INSERT INTO [LgcStockInOutDetail] ( [inoutid], [assetid], [number_n], [currencyid], defcurrencyid, exchangerate, defunitprice, unitprice)  VALUES ( @maxid, @assetid_2, @stocknum_3, @currencyid, @trandefcurrencyid, @exchangerate, @temp/@exchangerate, @unitprice_4)   select max(id) from LgcAssetStock 
GO

 CREATE PROCEDURE LgcAssetStock_SelectByAsset 
 (@assetid int, @flag integer output , @msg varchar(80) output) AS select id,warehouseid,stocknum,unitprice,stocknum*unitprice unitpriceall from LgcAssetStock where assetid = @assetid 
GO

 CREATE PROCEDURE LgcAssetStock_SelectByID 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output) AS select * from LgcAssetStock where id = @id_1 
GO

 CREATE PROCEDURE LgcAssetStock_Update 
 (@id_1 	[int], @warehouseid_2 	[int], @assetid_3 	[int], @stocknum_4 	[float], @unitprice_5    varchar(30), @trandefcurrencyid int, @currencyid       int, @exchangerate varchar(30), @flag integer output , @msg varchar(80) output)  AS set @unitprice_5 = convert([decimal](18,3) , @unitprice_5)   declare @count int,@inoutid int,@inoutdetailid int,@temp decimal(18,3)  set @temp = @unitprice_5  select @count=count(*)  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=@warehouseid_2 and b.assetid=@assetid_3 and a.id=b.inoutid and a.stockmodeid<>-2 if @count>0 begin select -1 return end  UPDATE [LgcAssetStock]  SET  [warehouseid]	 = @warehouseid_2, [assetid]	 = @assetid_3, [stocknum]	 = @stocknum_4, [unitprice]	 = @unitprice_5  WHERE ( [id]	 = @id_1)  select @inoutid=a.id,@inoutdetailid=b.id  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=@warehouseid_2 and b.assetid=@assetid_3 and a.id=b.inoutid  UPDATE [LgcStockInOut]  SET  [warehouseid]	 = @warehouseid_2, [currencyid]	 = @currencyid, [defcurrencyid] = @trandefcurrencyid, [exchangerate]	 = @exchangerate, [defcountprice] = @stocknum_4*@unitprice_5/@exchangerate, [countprice]    = @stocknum_4*@unitprice_5 WHERE ( [id]	 = @inoutid)  UPDATE [LgcStockInOutDetail]  SET  [number_n]	 = @stocknum_4, [currencyid]	 = @currencyid, [defcurrencyid] = @trandefcurrencyid, [exchangerate]	 = @exchangerate, [defunitprice] = @temp/@exchangerate, [unitprice]	 = @unitprice_5 WHERE ( [id]	 = @inoutdetailid) 
GO

 CREATE PROCEDURE LgcAssetType_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int  select @count = count(id) from LgcAsset where assettypeid = @id_1 if @count <> 0 begin select -1 return end  DELETE [LgcAssetType] WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAssetType_Insert 
 (@typemark_1 	[varchar](60), @typename_2 	[varchar](60), @typedesc_3 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcAssetType] ( [typemark], [typename], [typedesc])  VALUES ( @typemark_1, @typename_2, @typedesc_3)  select max(id) from LgcAssetType 
GO

 CREATE PROCEDURE LgcAssetType_Select 
 @flag integer output , @msg varchar(80) output AS select * from LgcAssetType 
GO

 CREATE PROCEDURE LgcAssetType_SelectByID 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from LgcAssetType  where id = @id 
GO

 CREATE PROCEDURE LgcAssetType_Update 
 (@id_1 	[int], @typemark_2 	[varchar](60), @typename_3 	[varchar](60), @typedesc_4 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcAssetType]  SET  [typemark]	 = @typemark_2, [typename]	 = @typename_3, [typedesc]	 = @typedesc_4  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAssetUnit_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int  select @count = count(id) from LgcAsset where assetunitid = @id_1 if @count <> 0 begin select -1 return end  DELETE [LgcAssetUnit] WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAssetUnit_Insert 
 (@unitmark_1 	[varchar](60), @unitname_2 	[varchar](60), @unitdesc_3 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcAssetUnit] ( [unitmark], [unitname], [unitdesc])  VALUES ( @unitmark_1, @unitname_2, @unitdesc_3)  select max(id) from LgcAssetUnit 
GO

 CREATE PROCEDURE LgcAssetUnit_Select 
 @flag integer output , @msg varchar(80) output AS select * from LgcAssetUnit 
GO

 CREATE PROCEDURE LgcAssetUnit_SelectByID 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from LgcAssetUnit  where id = @id 
GO

 CREATE PROCEDURE LgcAssetUnit_Update 
 (@id_1 	[int], @unitmark_2 	[varchar](60), @unitname_3 	[varchar](60), @unitdesc_4 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcAssetUnit]  SET  [unitmark]	 = @unitmark_2, [unitname]	 = @unitname_3, [unitdesc]	 = @unitdesc_4  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcAsset_Delete 
 (@id_1 	[int], @assetcountryid_2 [int], @flag                             integer output, @msg                             varchar(80) output) AS declare @isdefault char(1) select @isdefault= isdefault from LgcAssetCountry where assetid=@id_1 and assetcountyid = @assetcountryid_2 if @isdefault='1' begin select -1 return end  DELETE [LgcAssetCountry]  WHERE assetid=@id_1 and assetcountyid = @assetcountryid_2 
GO

 CREATE PROCEDURE LgcAsset_Insert 
 (@assetmark_1 	[varchar](60), @barcode_2 	[varchar](30), @seclevel_3 	[tinyint], @assetimageid_4 	[int], @assettypeid_5 	[int], @assetunitid_6 	[int], @replaceassetid_7 	[int], @assetversion_8 	[varchar](20), @assetattribute_9 	[varchar](100), @counttypeid_10 	[int], @assortmentid_11 	[int], @assortmentstr_12 	[varchar](200), @relatewfid    int, @assetname_2 	[varchar](60), @assetcountyid_3 	[int], @startdate_4 	[char](10), @enddate_5 	[char](10), @departmentid_6 	[int], @resourceid_7 	[int], @assetremark_8 	[text], @currencyid_9 	[int], @salesprice_10 	varchar(30), @costprice_11 	        varchar(30), @datefield1_12 	[char](10), @datefield2_13 	[char](10), @datefield3_14 	[char](10), @datefield4_15 	[char](10), @datefield5_16 	[char](10), @numberfield1_17 	[float], @numberfield2_18 	[float], @numberfield3_19 	[float], @numberfield4_20 	[float], @numberfield5_21 	[float], @textfield1_22 	[varchar](100), @textfield2_23 	[varchar](100), @textfield3_24 	[varchar](100), @textfield4_25 	[varchar](100), @textfield5_26 	[varchar](100), @tinyintfield1_27 	[char](1), @tinyintfield2_28 	[char](1), @tinyintfield3_29 	[char](1), @tinyintfield4_30 	[char](1), @tinyintfield5_31 	[char](1), @createrid_32 	[int], @createdate_33 	[char](10), @Flag	[int]	output, @msg	[varchar](80)	output)  AS set @salesprice_10 = convert([decimal](18,3) , @salesprice_10) set @costprice_11 = convert([decimal](18,3) , @costprice_11)  declare @count integer  begin  select @count = count(*) from LgcAsset where assetmark = @assetmark_1 if @count <> 0 begin select -1 return end  end  INSERT INTO [LgcAsset] ( [assetmark], [barcode], [seclevel], [assetimageid], [assettypeid], [assetunitid], [replaceassetid], [assetversion], [assetattribute], [counttypeid], [assortmentid], [assortmentstr], relatewfid)  VALUES ( @assetmark_1, @barcode_2, @seclevel_3, @assetimageid_4, @assettypeid_5, @assetunitid_6, @replaceassetid_7, @assetversion_8, @assetattribute_9, @counttypeid_10, @assortmentid_11, @assortmentstr_12, @relatewfid)  declare @assetid integer  select @assetid = max(id) from LgcAsset  INSERT INTO [LgcAssetCountry] ( [assetid], [assetname], [assetcountyid], [startdate], [enddate], [departmentid], [resourceid], [assetremark], [currencyid], [salesprice], [costprice], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5], [createrid], [createdate], [lastmoderid], [lastmoddate], [isdefault])  VALUES ( @assetid, @assetname_2, @assetcountyid_3, @startdate_4, @enddate_5, @departmentid_6, @resourceid_7, @assetremark_8, @currencyid_9, @salesprice_10, @costprice_11, @datefield1_12, @datefield2_13, @datefield3_14, @datefield4_15, @datefield5_16, @numberfield1_17, @numberfield2_18, @numberfield3_19, @numberfield4_20, @numberfield5_21, @textfield1_22, @textfield2_23, @textfield3_24, @textfield4_25, @textfield5_26, @tinyintfield1_27, @tinyintfield2_28, @tinyintfield3_29, @tinyintfield4_30, @tinyintfield5_31, @createrid_32, @createdate_33, @createrid_32, @createdate_33, '1')  update LgcAssetAssortment set assetcount = assetcount+1 where id= @assortmentid_11 select max(id) from LgcAsset 
GO

 CREATE PROCEDURE LgcAsset_SelectAll 
 (@flag integer output , @msg varchar(80) output) AS  select * from LgcAsset , LgcAssetCountry where LgcAsset.id = LgcAssetCountry.assetid and isdefault ='1' 
GO

 CREATE PROCEDURE LgcAsset_SelectByAssortment 
 (@assortmentid 	[int], @flag integer output , @msg varchar(80) output) AS select LgcAsset.id , assetmark,assetname,assettypeid,seclevel from LgcAsset , LgcAssetCountry where LgcAsset.id = LgcAssetCountry.assetid and isdefault ='1' and assortmentid = @assortmentid 
GO

 CREATE PROCEDURE LgcAsset_SelectById 
 ( @id int, @assetcountryid int, @flag integer output , @msg varchar(80) output) AS  if @assetcountryid<>-1 begin select * from LgcAsset , LgcAssetCountry where LgcAsset.id = @id and LgcAssetCountry.assetid = @id and LgcAssetCountry.assetcountyid = @assetcountryid end else begin select * from LgcAsset , LgcAssetCountry where LgcAsset.id = @id and LgcAssetCountry.assetid = @id and isdefault ='1' end 
GO

 CREATE PROCEDURE LgcAsset_SelectSumByAssetType 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS select assettypeid AS resultid, COUNT(id) AS resultcount from LgcAsset group by assettypeid  order by  resultcount desc 
GO

 CREATE PROCEDURE LgcAsset_SelectSumByAssortment 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS select assortmentid AS resultid, COUNT(id) AS resultcount from LgcAsset group by assortmentid  order by  resultcount desc 
GO

 CREATE PROCEDURE LgcAsset_SelectSumByConfigue 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS select relationtypeid AS resultid, COUNT(id) AS resultcount from LgcConfiguration  group by relationtypeid  order by  resultcount desc 
GO

 CREATE PROCEDURE LgcAsset_SelectSumByDepartment 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS select departmentid AS resultid, COUNT(id) AS resultcount from LgcAssetCountry where departmentid !=0 group by departmentid  order by  resultcount desc 
GO

 CREATE PROCEDURE LgcAsset_SelectSumByResource 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS select resourceid AS resultid, COUNT(id) AS resultcount from LgcAssetCountry where resourceid !=0 group by resourceid  order by  resultcount desc 
GO

 CREATE PROCEDURE LgcAsset_Update 
 (@id_1 	[int], @assetcountryid_2 [int], @barcode_3 	[varchar](30), @seclevel_4 	[tinyint], @assetimageid_5 	[int], @assettypeid_6 	[int], @assetunitid_7 	[int], @replaceassetid_8 	[int], @assetversion_9 	[varchar](20), @assetattribute_10 	[varchar](100), @counttypeid_11 	[int], @assortmentid_12 	[int], @assortmentstr_13 	[varchar](200), @relatewfid    int, @assetname_2 	[varchar](60), @assetcountyid_3 	[int], @startdate_4 	[char](10), @enddate_5 	[char](10), @departmentid_6 	[int], @resourceid_7 	[int], @assetremark_8 	[text], @currencyid_9 	[int], @salesprice_10 	varchar(30), @costprice_11 	varchar(30), @datefield1_12 	[char](10), @datefield2_13 	[char](10), @datefield3_14 	[char](10), @datefield4_15 	[char](10), @datefield5_16 	[char](10), @numberfield1_17 	[float], @numberfield2_18 	[float], @numberfield3_19 	[float], @numberfield4_20 	[float], @numberfield5_21 	[float], @textfield1_22 	[varchar](100), @textfield2_23 	[varchar](100), @textfield3_24 	[varchar](100), @textfield4_25 	[varchar](100), @textfield5_26 	[varchar](100), @tinyintfield1_27 	[char](1), @tinyintfield2_28 	[char](1), @tinyintfield3_29 	[char](1), @tinyintfield4_30 	[char](1), @tinyintfield5_31 	[char](1), @lastmoderid_32 	[int], @lastmoddate_33 	[char](10), @isdefault 		[char](1), @Flag	[int]	output, @msg	[varchar](80)	output)  AS set @salesprice_10 = convert([decimal](18,3) , @salesprice_10) set @costprice_11 = convert([decimal](18,3) , @costprice_11)  UPDATE [LgcAsset] SET  	 relatewfid = @relatewfid , [barcode]	 = @barcode_3, [seclevel]	 = @seclevel_4, [assetimageid]	 = @assetimageid_5, [assettypeid]	 = @assettypeid_6, [assetunitid]	 = @assetunitid_7, [replaceassetid]	 = @replaceassetid_8, [assetversion]	 = @assetversion_9, [assetattribute]	 = @assetattribute_10, [counttypeid]	 = @counttypeid_11, [assortmentid]	 = @assortmentid_12, [assortmentstr]	 = @assortmentstr_13  WHERE ( [id]	 = @id_1)  if  @assetcountryid_2=-1 begin select @assetcountryid_2=assetcountyid from LgcAssetCountry where assetid=@id_1 and isdefault='1' end  if  @isdefault='1' begin update LgcAssetCountry set isdefault='0' where assetid=@id_1 end  UPDATE [LgcAssetCountry] SET      [assetname]	 = @assetname_2, [assetcountyid] = @assetcountyid_3, [startdate]	 = @startdate_4, [enddate]	 = @enddate_5, [departmentid]	 = @departmentid_6, [resourceid]	 = @resourceid_7, [assetremark]	 = @assetremark_8, [currencyid]	 = @currencyid_9, [salesprice]	 = @salesprice_10, [costprice]	 = @costprice_11, [datefield1]	 = @datefield1_12, [datefield2]	 = @datefield2_13, [datefield3]	 = @datefield3_14, [datefield4]	 = @datefield4_15, [datefield5]	 = @datefield5_16, [numberfield1]	 = @numberfield1_17, [numberfield2]	 = @numberfield2_18, [numberfield3]	 = @numberfield3_19, [numberfield4]	 = @numberfield4_20, [numberfield5]	 = @numberfield5_21, [textfield1]	 = @textfield1_22, [textfield2]	 = @textfield2_23, [textfield3]	 = @textfield3_24, [textfield4]	 = @textfield4_25, [textfield5]	 = @textfield5_26, [tinyintfield1] = @tinyintfield1_27, [tinyintfield2] = @tinyintfield2_28, [tinyintfield3] = @tinyintfield3_29, [tinyintfield4] = @tinyintfield4_30, [tinyintfield5] = @tinyintfield5_31, [lastmoderid]	 = @lastmoderid_32, [lastmoddate]	 = @lastmoddate_33 , [isdefault]	= @isdefault  WHERE ( (assetid = @id_1) and (assetcountyid =@assetcountryid_2)) 
GO

 CREATE PROCEDURE LgcAsset_UpdatePic 
 (@id_1 	[int], @assetimageid_2     [int], @flag                             integer output, @msg                             varchar(80) output ) AS update LgcAsset set assetimageid = 0 where id = @id_1 delete ImageFile where imagefileid = @assetimageid_2  if @@error<>0 begin set @flag=1 set @msg='删除图片成功' return end else begin set @flag=0 set @msg='删除图片失败' return end 
GO

 CREATE PROCEDURE LgcAssetmark_Change 
 (@assetid	[int], @assetmark  [varchar](60), @flag integer output , @msg varchar(80) output) AS declare @count int select @count = count(id) from LgcAsset where assetmark = @assetmark if @count <> 0 begin select -1 return end  update LgcAsset set assetmark = @assetmark where id = @assetid 
GO

 CREATE PROCEDURE LgcAssortmentMove_ChgCount 
 (@assortmentid1	[int], @assortmentid2  [int], @countid  [int], @flag integer output , @msg varchar(80) output) AS update LgcAssetAssortment set assetcount = assetcount-@countid where id=@assortmentid1 update LgcAssetAssortment set assetcount = assetcount+@countid where id=@assortmentid2 
GO

 CREATE PROCEDURE LgcAssortmentMove_Move 
 (@assortmentid	[int], @assetid  [int], @flag integer output , @msg varchar(80) output) AS declare @supassortmentstr varchar(200) select @supassortmentstr = supassortmentstr from LgcAssetAssortment where id = @assortmentid select @supassortmentstr = @supassortmentstr + convert(varchar(10), @assortmentid) + '|' update LgcAsset set assortmentid = @assortmentid , assortmentstr = @supassortmentstr where id = @assetid 
GO

 CREATE PROCEDURE LgcAttributeMove_Add 
 (@assortmentid 	[int], @selectedattr  varchar(10) , @flag integer output , @msg varchar(80) output) AS update LgcAsset set assetattribute = assetattribute + @selectedattr where assortmentid = @assortmentid and assetattribute not like '%'+@selectedattr+'%' select @@ROWCOUNT 
GO

 CREATE PROCEDURE LgcAttributeMove_Remove 
 (@assortmentid 	[int], @selectedattr  varchar(10) , @flag integer output , @msg varchar(80) output) AS update LgcAsset set assetattribute = replace(assetattribute,@selectedattr,'') where assortmentid = @assortmentid select @@ROWCOUNT 
GO

 CREATE PROCEDURE LgcCatalogs_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [LgcCatalogs]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcCatalogs_Insert 
 (@catalogname_1 	[varchar](60), @catalogdesc_2 	[varchar](200), @catalogorder_3 	[int], @perpage_4 	[int], @seclevelfrom_5 	[tinyint], @seclevelto_6 	[tinyint], @navibardsp_7 	[char](1), @navibarbgcolor_8 	[char](6), @navibarfontcolor_9 	[char](6), @navibarfontsize_10 	[varchar](20), @navibarfonttype_11 	[varchar](20), @toolbardsp_12 	[char](1), @toolbarwidth_13 	[int], @toolbarbgcolor_14 	[char](6), @toolbarfontcolor_15 	[char](6), @toolbarlinkbgcolor_16 	[char](6), @toolbarlinkfontcolor_17 	[char](6), @toolbarfontsize_18 	[varchar](20), @toolbarfonttype_19 	[varchar](20), @countrydsp_20 	[char](1), @countrydeftype_21 	[char](1), @countryid_22 	[int], @searchbyname_23 	[char](1), @searchbycrm_24 	[char](1), @searchadv_25 	[char](1), @assortmentdsp_26 	[char](1), @assortmentname_27 	[varchar](60), @assortmentsql_28 	[text], @attributedsp_29 	[char](1), @attributecol_30 	[int], @attributefontsize_31 	[varchar](20), @attributefonttype_32 	[varchar](20), @assetsql_33 	[text], @assetcol1_34 	[varchar](40), @assetcol2_35 	[varchar](40), @assetcol3_36 	[varchar](40), @assetcol4_37 	[varchar](40), @assetcol5_38 	[varchar](40), @assetcol6_39 	[varchar](40), @assetfontsize_40 	[varchar](40), @assetfonttype_41 	[varchar](40), @webshopdap_42 	[char](1), @webshoptype_43 	[char](1), @webshopreturn_44 	[char](1), @webshopmanageid_45 	[int], @createrid_46 	[int], @createdate_47 	[char](10), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcCatalogs] ( [catalogname], [catalogdesc], [catalogorder], [perpage], [seclevelfrom], [seclevelto], [navibardsp], [navibarbgcolor], [navibarfontcolor], [navibarfontsize], [navibarfonttype], [toolbardsp], [toolbarwidth], [toolbarbgcolor], [toolbarfontcolor], [toolbarlinkbgcolor], [toolbarlinkfontcolor], [toolbarfontsize], [toolbarfonttype], [countrydsp], [countrydeftype], [countryid], [searchbyname], [searchbycrm], [searchadv], [assortmentdsp], [assortmentname], [assortmentsql], [attributedsp], [attributecol], [attributefontsize], [attributefonttype], [assetsql], [assetcol1], [assetcol2], [assetcol3], [assetcol4], [assetcol5], [assetcol6], [assetfontsize], [assetfonttype], [webshopdap], [webshoptype], [webshopreturn], [webshopmanageid], [createrid], [createdate])  VALUES ( @catalogname_1, @catalogdesc_2, @catalogorder_3, @perpage_4, @seclevelfrom_5, @seclevelto_6, @navibardsp_7, @navibarbgcolor_8, @navibarfontcolor_9, @navibarfontsize_10, @navibarfonttype_11, @toolbardsp_12, @toolbarwidth_13, @toolbarbgcolor_14, @toolbarfontcolor_15, @toolbarlinkbgcolor_16, @toolbarlinkfontcolor_17, @toolbarfontsize_18, @toolbarfonttype_19, @countrydsp_20, @countrydeftype_21, @countryid_22, @searchbyname_23, @searchbycrm_24, @searchadv_25, @assortmentdsp_26, @assortmentname_27, @assortmentsql_28, @attributedsp_29, @attributecol_30, @attributefontsize_31, @attributefonttype_32, @assetsql_33, @assetcol1_34, @assetcol2_35, @assetcol3_36, @assetcol4_37, @assetcol5_38, @assetcol6_39, @assetfontsize_40, @assetfonttype_41, @webshopdap_42, @webshoptype_43, @webshopreturn_44, @webshopmanageid_45, @createrid_46, @createdate_47) select max(id) from LgcCatalogs 
GO

 CREATE PROCEDURE LgcCatalogs_SDefaultByUser 
 (@userseclevel  int , @flag integer output , @msg varchar(80) output)  AS declare @catalogid int declare catalogid_cursor cursor for select id from LgcCatalogs where seclevelfrom <= @userseclevel and seclevelto >= @userseclevel order by catalogorder  open catalogid_cursor fetch next from catalogid_cursor into @catalogid if @@fetch_status=0 select @catalogid  close catalogid_cursor deallocate catalogid_cursor 
GO

 CREATE PROCEDURE LgcCatalogs_Select 
 (@flag integer output , @msg varchar(80) output)  AS select id,catalogname,catalogdesc,catalogorder,seclevelfrom,seclevelto from LgcCatalogs 
GO

 CREATE PROCEDURE LgcCatalogs_SelectByID 
 (@id  int , @flag integer output , @msg varchar(80) output)  AS select * from LgcCatalogs where id= @id 
GO

 CREATE PROCEDURE LgcCatalogs_SelectByUser 
 (@userseclevel  int , @flag integer output , @msg varchar(80) output)  AS select id,catalogname,navibarbgcolor from LgcCatalogs where seclevelfrom <= @userseclevel and seclevelto >= @userseclevel 
GO

 CREATE PROCEDURE LgcCatalogs_Update 
 (@id_1 	[int], @catalogname_2 	[varchar](60), @catalogdesc_3 	[varchar](200), @catalogorder_4 	[int], @perpage_5 	[int], @seclevelfrom_6 	[tinyint], @seclevelto_7 	[tinyint], @navibardsp_8 	[char](1), @navibarbgcolor_9 	[char](6), @navibarfontcolor_10 	[char](6), @navibarfontsize_11 	[varchar](20), @navibarfonttype_12 	[varchar](20), @toolbardsp_13 	[char](1), @toolbarwidth_14 	[int], @toolbarbgcolor_15 	[char](6), @toolbarfontcolor_16 	[char](6), @toolbarlinkbgcolor_17 	[char](6), @toolbarlinkfontcolor_18 	[char](6), @toolbarfontsize_19 	[varchar](20), @toolbarfonttype_20 	[varchar](20), @countrydsp_21 	[char](1), @countrydeftype_22 	[char](1), @countryid_23 	[int], @searchbyname_24 	[char](1), @searchbycrm_25 	[char](1), @searchadv_26 	[char](1), @assortmentdsp_27 	[char](1), @assortmentname_28 	[varchar](60), @assortmentsql_29 	[text], @attributedsp_30 	[char](1), @attributecol_31 	[int], @attributefontsize_32 	[varchar](20), @attributefonttype_33 	[varchar](20), @assetsql_34 	[text], @assetcol1_35 	[varchar](40), @assetcol2_36 	[varchar](40), @assetcol3_37 	[varchar](40), @assetcol4_38 	[varchar](40), @assetcol5_39 	[varchar](40), @assetcol6_40 	[varchar](40), @assetfontsize_41 	[varchar](40), @assetfonttype_42 	[varchar](40), @webshopdap_43 	[char](1), @webshoptype_44 	[char](1), @webshopreturn_45 	[char](1), @webshopmanageid_46 	[int], @lastmoderid_47 	[int], @lastmoddate_48 	[char](10), @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcCatalogs]  SET  [catalogname]	 = @catalogname_2, [catalogdesc]	 = @catalogdesc_3, [catalogorder]	 = @catalogorder_4, [perpage]	 = @perpage_5, [seclevelfrom]	 = @seclevelfrom_6, [seclevelto]	 = @seclevelto_7, [navibardsp]	 = @navibardsp_8, [navibarbgcolor]	 = @navibarbgcolor_9, [navibarfontcolor]	 = @navibarfontcolor_10, [navibarfontsize]	 = @navibarfontsize_11, [navibarfonttype]	 = @navibarfonttype_12, [toolbardsp]	 = @toolbardsp_13, [toolbarwidth]	 = @toolbarwidth_14, [toolbarbgcolor]	 = @toolbarbgcolor_15, [toolbarfontcolor]	 = @toolbarfontcolor_16, [toolbarlinkbgcolor]	 = @toolbarlinkbgcolor_17, [toolbarlinkfontcolor]	 = @toolbarlinkfontcolor_18, [toolbarfontsize]	 = @toolbarfontsize_19, [toolbarfonttype]	 = @toolbarfonttype_20, [countrydsp]	 = @countrydsp_21, [countrydeftype]	 = @countrydeftype_22, [countryid]	 = @countryid_23, [searchbyname]	 = @searchbyname_24, [searchbycrm]	 = @searchbycrm_25, [searchadv]	 = @searchadv_26, [assortmentdsp]	 = @assortmentdsp_27, [assortmentname]	 = @assortmentname_28, [assortmentsql]	 = @assortmentsql_29, [attributedsp]	 = @attributedsp_30, [attributecol]	 = @attributecol_31, [attributefontsize]	 = @attributefontsize_32, [attributefonttype]	 = @attributefonttype_33, [assetsql]	 = @assetsql_34, [assetcol1]	 = @assetcol1_35, [assetcol2]	 = @assetcol2_36, [assetcol3]	 = @assetcol3_37, [assetcol4]	 = @assetcol4_38, [assetcol5]	 = @assetcol5_39, [assetcol6]	 = @assetcol6_40, [assetfontsize]	 = @assetfontsize_41, [assetfonttype]	 = @assetfonttype_42, [webshopdap]	 = @webshopdap_43, [webshoptype]	 = @webshoptype_44, [webshopreturn]	 = @webshopreturn_45, [webshopmanageid]	 = @webshopmanageid_46, [lastmoderid]	 = @lastmoderid_47, [lastmoddate]	 = @lastmoddate_48  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcConfiguration_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [LgcConfiguration]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcConfiguration_Insert 
 (@supassetid_1 	[int], @subassetid_2 	[int], @relationtypeid_3 	[int], @flag integer output, @msg varchar(80) output )  AS if @supassetid_1=@subassetid_2 begin select -1 return end INSERT INTO [LgcConfiguration] ( [supassetid], [subassetid], [relationtypeid])  VALUES ( @supassetid_1, @subassetid_2, @relationtypeid_3) 
GO

 CREATE PROCEDURE LgcConfiguration_SByWebshop 
 (@assetid  int , @flag integer output , @msg varchar(80) output)  AS select subassetid,typename from LgcConfiguration ,  LgcAssetRelationType where supassetid = @assetid and relationtypeid = LgcAssetRelationType.id and shopadvice ='1' 
GO

 CREATE PROCEDURE LgcConfiguration_Select 
 @flag integer output , @msg varchar(80) output AS  select * from LgcConfiguration 
GO

 CREATE PROCEDURE LgcConfiguration_SelectByAsset 
 ( @id int, @direction char(1), @flag integer output , @msg varchar(80) output) AS  if @direction='1' select * from LgcConfiguration where subassetid=@id else select * from LgcConfiguration where supassetid=@id 
GO

 CREATE PROCEDURE LgcConfiguration_SelectById 
 ( @id int, @flag integer output , @msg varchar(80) output) AS select * from LgcConfiguration where id=@id 
GO

 CREATE PROCEDURE LgcConfiguration_Update 
 (@id_1 	[int], @supassetid_2 	[int], @subassetid_3 	[int], @relationtypeid_4 	[int], @flag integer output, @msg varchar(80) output )  AS if @supassetid_2=@subassetid_3 begin select -1 return end  UPDATE [LgcConfiguration]  SET  [supassetid]	 = @supassetid_2, [subassetid]	 = @subassetid_3, [relationtypeid]	 = @relationtypeid_4  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcCountType_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int  select @count = count(id) from LgcAsset where counttypeid = @id_1 if @count <> 0 begin select -1 return end  DELETE [LgcCountType] WHERE  ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcCountType_Insert 
 (@typename_1 	[varchar](60), @typedesc_2 	[varchar](200), @salesinid_3 	[int], @salescostid_4 	[int], @salestaxid_5 	[int], @purchasetaxid_6 	[int], @stockid_7 	[int], @stockdiffid_8 	[int], @producecostid_9 	[int] , @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcCountType] ( [typename], [typedesc], [salesinid], [salescostid], [salestaxid], [purchasetaxid], [stockid], [stockdiffid], [producecostid])  VALUES ( @typename_1, @typedesc_2, @salesinid_3, @salescostid_4, @salestaxid_5, @purchasetaxid_6, @stockid_7, @stockdiffid_8, @producecostid_9) select max(id) from LgcCountType 
GO

 CREATE PROCEDURE LgcCountType_Select 
 @flag integer output , @msg varchar(80) output AS select * from LgcCountType 
GO

 CREATE PROCEDURE LgcCountType_SelectByID 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from LgcCountType  where id = @id 
GO

 CREATE PROCEDURE LgcCountType_Update 
 (@id_1 	[int], @typename_2 	[varchar](60), @typedesc_3 	[varchar](200), @salesinid_4 	[int], @salescostid_5 	[int], @salestaxid_6 	[int], @purchasetaxid_7 	[int], @stockid_8 	[int], @stockdiffid_9 	[int], @producecostid_10 	[int], @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcCountType]  SET  [typename]	 = @typename_2, [typedesc]	 = @typedesc_3, [salesinid]	 = @salesinid_4, [salescostid]	 = @salescostid_5, [salestaxid]	 = @salestaxid_6, [purchasetaxid]	 = @purchasetaxid_7, [stockid]	 = @stockid_8, [stockdiffid]	 = @stockdiffid_9, [producecostid]	 = @producecostid_10  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcPaymentType_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int  /* 还没有 select @count = count(id) from LgcAsset where counttypeid = @id_1 if @count <> 0 begin select -1 return end */  DELETE [LgcPaymentType] WHERE  ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcPaymentType_Insert 
 (@typename_1 	[varchar](60), @typedesc_2 	[varchar](200), @paymentid_3 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcPaymentType] ( [typename], [typedesc], [paymentid])  VALUES ( @typename_1, @typedesc_2, @paymentid_3)  select max(id) from LgcPaymentType 
GO

 CREATE PROCEDURE LgcPaymentType_Select 
 @flag integer output , @msg varchar(80) output AS select * from LgcPaymentType 
GO

 CREATE PROCEDURE LgcPaymentType_SelectByID 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from LgcPaymentType  where id = @id 
GO

 CREATE PROCEDURE LgcPaymentType_Update 
 (@id_1 	[int], @typename_2 	[varchar](60), @typedesc_3 	[varchar](200), @paymentid_4 	[int], @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcPaymentType]  SET  [typename]	 = @typename_2, [typedesc]	 = @typedesc_3, [paymentid]	 = @paymentid_4  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcSearchDefine_Insert 
 (@userid_1 	[int], @hasassetmark_2 	[char](1), @hasassetname_3 	[char](1), @hasassetcountry_4 	[char](1), @hasassetassortment_5 	[char](1), @hasassetstatus_6 	[char](1), @hasassettype_7 	[char](1), @hasassetversion_8 	[char](1), @hasassetattribute_9 	[char](1), @hasassetsalesprice_10 	[char](1), @hasdepartment_11 	[char](1), @hasresource_12 	[char](1), @hascrm_13 	[char](1), @perpage_14 	[int], @assetcol1_15 	[varchar](40), @assetcol2_16 	[varchar](40), @assetcol3_17 	[varchar](40), @assetcol4_18 	[varchar](40), @assetcol5_19 	[varchar](40), @assetcol6_20 	[varchar](40), @flag integer output , @msg varchar(80) output)  AS delete LgcSearchDefine where userid = @userid_1 INSERT INTO [LgcSearchDefine] ( [userid], [hasassetmark], [hasassetname], [hasassetcountry], [hasassetassortment], [hasassetstatus], [hasassettype], [hasassetversion], [hasassetattribute], [hasassetsalesprice], [hasdepartment], [hasresource], [hascrm], [perpage], [assetcol1], [assetcol2], [assetcol3], [assetcol4], [assetcol5], [assetcol6])  VALUES ( @userid_1, @hasassetmark_2, @hasassetname_3, @hasassetcountry_4, @hasassetassortment_5, @hasassetstatus_6, @hasassettype_7, @hasassetversion_8, @hasassetattribute_9, @hasassetsalesprice_10, @hasdepartment_11, @hasresource_12, @hascrm_13, @perpage_14, @assetcol1_15, @assetcol2_16, @assetcol3_17, @assetcol4_18, @assetcol5_19, @assetcol6_20) 
GO

 CREATE PROCEDURE LgcSearchDefine_SelectByID 
 (@userid	[int], @flag integer output , @msg varchar(80) output) AS declare @count int select @count = count(userid) from LgcSearchDefine where userid = @userid if @count <> 0 select * from LgcSearchDefine where userid = @userid else select * from LgcSearchDefine where userid = -1 
GO

 CREATE PROCEDURE LgcSearchMould_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [LgcSearchMould]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcSearchMould_Insert 
 (@mouldname_1 	[varchar](200), @userid_2 	[int], @assetmark_3 	[varchar](60), @assetname_4 	[varchar](60), @assetcountry_5 	[int], @assetassortment_6 	[int], @assetstatus_7 	[char](1), @assettype_8 	[int], @assetversion_9 	[varchar](20), @assetattribute_10 	[varchar](100), @assetsalespricefrom 	[varchar](30), @assetsalespriceto 	[varchar](30), @departmentid_13 	[int], @resourceid_14 	[int], @crmid_15 	[int], @flag integer output , @msg varchar(80) output)  AS declare @assetsalespricefrom_11 decimal(18,3) , @assetsalespriceto_12 decimal(18,3) if @assetsalespricefrom = '' set @assetsalespricefrom_11 = null else set @assetsalespricefrom_11 = convert(decimal(18,3),@assetsalespricefrom)  if @assetsalespriceto = '' set @assetsalespriceto_12 = null else set @assetsalespriceto_12 = convert(decimal(18,3),@assetsalespriceto)  if @crmid_15 = 0 set @crmid_15 = null if @assetcountry_5 = 0 set @assetcountry_5 = null if @assetassortment_6 = 0 set @assetassortment_6 = null if @assettype_8 = 0 set @assettype_8 = null if @departmentid_13 = 0 set @departmentid_13 = null if @resourceid_14 = 0 set @resourceid_14 = null  INSERT INTO [LgcSearchMould] ( [mouldname], [userid], [assetmark], [assetname], [assetcountry], [assetassortment], [assetstatus], [assettype], [assetversion], [assetattribute], [assetsalespricefrom], [assetsalespriceto], [departmentid], [resourceid], [crmid])  VALUES ( @mouldname_1, @userid_2, @assetmark_3, @assetname_4, @assetcountry_5, @assetassortment_6, @assetstatus_7, @assettype_8, @assetversion_9, @assetattribute_10, @assetsalespricefrom_11, @assetsalespriceto_12, @departmentid_13, @resourceid_14, @crmid_15) select max(id) from LgcSearchMould 
GO

 CREATE PROCEDURE LgcSearchMould_SelectByMouldID 
 (@mouldid	[int], @flag integer output , @msg varchar(80) output) AS select * from LgcSearchMould where id = @mouldid 
GO

 CREATE PROCEDURE LgcSearchMould_SelectByUserID 
 (@userid	[int], @flag integer output , @msg varchar(80) output) AS select id,mouldname from LgcSearchMould where userid = @userid 
GO

 CREATE PROCEDURE LgcSearchMould_Update 
 (@id_1 	[int], @assetmark_2 	[varchar](60), @assetname_3 	[varchar](60), @assetcountry_4 	[int], @assetassortment_5 	[int], @assetstatus_6 	[char](1), @assettype_7 	[int], @assetversion_8 	[varchar](20), @assetattribute_9 	[varchar](100), @assetsalespricefrom 	[varchar](30), @assetsalespriceto 	[varchar](30), @departmentid_12 	[int], @resourceid_13 	[int], @crmid_14 	[int], @flag integer output , @msg varchar(80) output)  AS declare @assetsalespricefrom_10 decimal(18,3) , @assetsalespriceto_11 decimal(18,3) if @assetsalespricefrom = '' set @assetsalespricefrom_10 = null else set @assetsalespricefrom_10 = convert(decimal(18,3),@assetsalespricefrom)  if @assetsalespriceto = '' set @assetsalespriceto_11 = null else set @assetsalespriceto_11 = convert(decimal(18,3),@assetsalespriceto)  if @crmid_14 = 0 set @crmid_14 = null if @assetcountry_4 = 0 set @assetcountry_4 = null if @assetassortment_5 = 0 set @assetassortment_5 = null if @assettype_7 = 0 set @assettype_7 = null if @departmentid_12 = 0 set @departmentid_12 = null if @resourceid_13 = 0 set @resourceid_13 = null  UPDATE [LgcSearchMould]  SET  [assetmark]	 = @assetmark_2, [assetname]	 = @assetname_3, [assetcountry]	 = @assetcountry_4, [assetassortment]	 = @assetassortment_5, [assetstatus]	 = @assetstatus_6, [assettype]	 = @assettype_7, [assetversion]	 = @assetversion_8, [assetattribute]	 = @assetattribute_9, [assetsalespricefrom]	 = @assetsalespricefrom_10, [assetsalespriceto]	 = @assetsalespriceto_11, [departmentid]	 = @departmentid_12, [resourceid]	 = @resourceid_13, [crmid]	 = @crmid_14  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcStockInOutDetail_Insert 
 (@inoutid_1 	[int], @assetid_2 	[int], @batchmark_3 	[varchar](20), @number_4 	[float], @currencyid_5 	[int], @defcurrencyid_6 	[int], @exchangerate_7 	[decimal], @defunitprice_8 	[decimal], @unitprice_9 	[decimal], @taxrate_10 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcStockInOutDetail] ( [inoutid], [assetid], [batchmark], [number_n], [currencyid], [defcurrencyid], [exchangerate], [defunitprice], [unitprice], [taxrate])  VALUES ( @inoutid_1, @assetid_2, @batchmark_3, @number_4, @currencyid_5, @defcurrencyid_6, @exchangerate_7, @defunitprice_8, @unitprice_9, @taxrate_10) 
GO

 CREATE PROCEDURE LgcStockInOutDetail_Insert1 
 (@inoutid_1 	[int], @assetid_2 	[int], @batchmark_3 	[varchar](20), @number_4 	[float], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcStockInOutDetail] ( [inoutid], [assetid], [batchmark], [number_n])  VALUES ( @inoutid_1, @assetid_2, @batchmark_3, @number_4) 
GO

 CREATE PROCEDURE LgcStockInOutDetail_Select 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from LgcStockInOutDetail where inoutid=@id 
GO

 CREATE PROCEDURE LgcStockInOutDetail_Update 
 (@id_1 	[int], @inoutid_2 	[int], @assetid_3 	[int], @batchmark_4 	[varchar](20), @number_5 	[float], @currencyid_6 	[int], @defcurrencyid_7 	[int], @exchangerate_8 	[decimal], @defunitprice_9 	[decimal], @unitprice_10 	[decimal], @taxrate_11 	[int],  @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcStockInOutDetail]  SET  [inoutid]	 = @inoutid_2, [assetid]	 = @assetid_3, [batchmark]	 = @batchmark_4, [number_n]	 = @number_5, [currencyid]	 = @currencyid_6, [defcurrencyid]	 = @defcurrencyid_7, [exchangerate]	 = @exchangerate_8, [defunitprice]	 = @defunitprice_9, [unitprice]	 = @unitprice_10, [taxrate]	 = @taxrate_11  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcStockInOutDetail_Update1 
 (@id_1 	[int], @inoutid_2 	[int], @assetid_3 	[int], @batchmark_4 	[varchar](20), @number_5 	[float], @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcStockInOutDetail]  SET  [inoutid]	 = @inoutid_2, [assetid]	 = @assetid_3, [batchmark]	 = @batchmark_4, [number_n]	 = @number_5  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcStockInOut_SelectByAsset 
 (@assetid [int], @warehouseid [int], @flag integer output , @msg varchar(80) output) AS select *  from LgcStockInOut a,LgcStockInOutDetail b where a.warehouseid=@warehouseid and b.assetid=@assetid and a.id=b.inoutid 
GO

 CREATE PROCEDURE LgcStockInOut_SelectById 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from LgcStockInOut where id=@id 
GO

 CREATE PROCEDURE LgcStockMode_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int  select @count = count(id) from LgcStockInOut where stockmodeid = @id_1 if @count <> 0 begin select -1 return end  DELETE [LgcStockMode] WHERE  ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcStockMode_Insert 
 (@modename_1 	[varchar](60), @modetype  char(1) , @modestatus  char(1), @modedesc_2 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcStockMode] ( [modename], modetype, modestatus, [modedesc])  VALUES ( @modename_1, @modetype, @modestatus, @modedesc_2)  select max(id) from LgcStockMode 
GO

 CREATE PROCEDURE LgcStockMode_Select 
 @flag integer output , @msg varchar(80) output AS select * from LgcStockMode 
GO

 CREATE PROCEDURE LgcStockMode_SelectByID 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from LgcStockMode  where id = @id 
GO

 CREATE PROCEDURE LgcStockMode_Update 
 (@id_1 	[int], @modename_2 	[varchar](60), @modetype  char(1) , @modestatus  char(1), @modedesc_3 	[varchar](200), @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcStockMode]  SET  [modename]	 = @modename_2, [modetype]	 = @modetype, [modestatus]	 = @modestatus, [modedesc]	 = @modedesc_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcWarehouse_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count int  select @count = count(id) from LgcStockInOut where warehouseid = @id_1 if @count <> 0 begin select -1 return end  DELETE [LgcWarehouse] WHERE  ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcWarehouse_Insert 
 (@warehousename_1 	[varchar](60), @warehousedesc_2 	[varchar](200), @roleid_3 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [LgcWarehouse] ( [warehousename], [warehousedesc], [roleid])  VALUES ( @warehousename_1, @warehousedesc_2, @roleid_3)  select max(id) from LgcWarehouse 
GO

 CREATE PROCEDURE LgcWarehouse_Select 
 @flag integer output , @msg varchar(80) output AS select * from LgcWarehouse 
GO

 CREATE PROCEDURE LgcWarehouse_SelectByID 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from LgcWarehouse  where id = @id 
GO

 CREATE PROCEDURE LgcWarehouse_Update 
 (@id_1 	[int], @warehousename_2 	[varchar](60), @warehousedesc_3 	[varchar](200), @roleid_4 	[int], @flag integer output , @msg varchar(80) output)  AS UPDATE [LgcWarehouse]  SET  [warehousename]	 = @warehousename_2, [warehousedesc]	 = @warehousedesc_3, [roleid]	 = @roleid_4  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE LgcWebShopDetail_Insert 
 (@webshopid_1 	[int], @assetid_2 	[int], @countryid     int , @currencyid_3 	[int], @assetprice 	[varchar](30), @taxrate_5 	[int], @purchasenum_6 	[float], @flag integer output , @msg varchar(80) output)  AS declare @assetprice_4 	[decimal](18,3) set @assetprice_4 = convert(decimal(18,3) , @assetprice)  INSERT INTO [LgcWebShopDetail] ( [webshopid], [assetid], countryid , [currencyid], [assetprice], [taxrate], [purchasenum])  VALUES ( @webshopid_1, @assetid_2, @countryid , @currencyid_3, @assetprice_4, @taxrate_5, @purchasenum_6) 
GO

 CREATE PROCEDURE LgcWebShopDetail_SelectById 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from LgcWebShopDetail  where webshopid = @id 
GO

 CREATE PROCEDURE LgcWebShop_Delete 
 @id  int , @flag integer output , @msg varchar(80) output AS delete LgcWebShop  where id = @id delete LgcWebShopDetail  where webshopid = @id 
GO

 CREATE PROCEDURE LgcWebShop_Insert 
 (@usertype_1 	[tinyint], @userid_2 	[int], @username_3 	[varchar](60), @usercountry_4 	[int], @useremail_5 	[varchar](60), @receiveaddress_6 	[varchar](200), @receivetype_7 	[int], @postcode_8 	[varchar](10), @telephone1_9 	[varchar](20), @telephone2_10 	[varchar](20), @paymentmode_11 	[varchar](2), @currencyid_12 	[int], @purchasecount 	[varchar](30), @purchaseremark_14 	[text], @purchasedate_15 	[char](10), @manageid_16 	int, @flag integer output , @msg varchar(80) output)  AS declare @purchasecount_13 [decimal](18,3) set @purchasecount_13 = convert(decimal(18,3),@purchasecount)  INSERT INTO [LgcWebShop] ( [usertype], [userid], [username], [usercountry], [useremail], [receiveaddress], [receivetype], [postcode], [telephone1], [telephone2], [paymentmode], [currencyid], [purchasecount], [purchaseremark], [purchasedate], [purchasestatus], manageid)  VALUES ( @usertype_1, @userid_2, @username_3, @usercountry_4, @useremail_5, @receiveaddress_6, @receivetype_7, @postcode_8, @telephone1_9, @telephone2_10, @paymentmode_11, @currencyid_12, @purchasecount_13, @purchaseremark_14, @purchasedate_15, '0', @manageid_16) select max(id) from LgcWebShop 
GO

 CREATE PROCEDURE LgcWebShop_SelectById 
 @id  int , @flag integer output , @msg varchar(80) output AS select * from LgcWebShop  where id = @id 
GO

 CREATE PROCEDURE LgcWebShop_Update 
 @id  int , @purchasestatus char(1), @flag integer output , @msg varchar(80) output AS update LgcWebShop  set purchasestatus = @purchasestatus where id = @id 
GO

 CREATE PROCEDURE MailPassword_IByResourceid 
	(@resourceid_1 	int,
	 @resourcemail_2 	varchar(60),
	 @password	varchar(40),
	 @flag integer output,
	 @msg varchar(80) output)
AS
declare @count int
select @count=count(*) from MailPassword where resourceid=@resourceid_1
if @count>0
    update MailPassword set resourcemail=@resourcemail_2,password=@password where resourceid=@resourceid_1
else
    insert into MailPassword values(@resourceid_1,@resourcemail_2,@password) 

GO

 CREATE PROCEDURE MailPassword_SbyResourceid 
	(@resourceid_1 	int,
	 @flag integer output,
	 @msg varchar(80) output)
AS
select * from MailPassword where resourceid = @resourceid_1

GO

 CREATE PROCEDURE MailResource_Delete 
	(@mailid_1  integer,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
delete from MailResourceFile where mailid = @mailid_1
delete from MailResource where id = @mailid_1

GO

 CREATE PROCEDURE MailResource_Insert 
	(@resourceid_2 	[int],
	 @priority_3 	[char](1),
	 @sendfrom_4 	[varchar](200),
	 @sendcc_5 	[varchar](200),
	 @sendbcc_6 	[varchar](200),
	 @sendto_7 	[varchar](200),
	 @senddate_8 	[varchar](30),
	 @size_9 	[int],
	 @subject_10 	[varchar](250),
	 @content_11 	[text],
	 @mailtype_12	[char](1) ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [MailResource] 
	 ([resourceid],
	 [priority],
	 [sendfrom],
	 [sendcc],
	 [sendbcc],
	 [sendto],
	 [senddate],
	 [size_n],
	 [subject],
	 [content],
	 mailtype) 
 
VALUES 
	(@resourceid_2,
	 @priority_3,
	 @sendfrom_4,
	 @sendcc_5,
	 @sendbcc_6,
	 @sendto_7,
	 @senddate_8,
	 @size_9,
	 @subject_10,
	 @content_11,
	 @mailtype_12)

select max(id) from MailResource

GO

 CREATE PROCEDURE MailResource_SelectCount 
	(@resourceid_1  integer,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
declare @localcount integer , @draftcount integer, @deletecount integer , @sendcount integer

select @localcount = count(*) from MailResource where mailtype = '0' and resourceid = @resourceid_1
select @sendcount = count(*) from MailResource where mailtype = '1' and resourceid = @resourceid_1
select @draftcount = count(*) from MailResource where mailtype = '2' and resourceid = @resourceid_1
select @deletecount = count(*) from MailResource where mailtype = '3' and resourceid = @resourceid_1

select @localcount,@sendcount,@draftcount,@deletecount

GO

 CREATE PROCEDURE MailResource_UpdateMailtype 
	(@mailid_1  integer,
	 @mailtype_2  char(1),
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
update MailResource set mailtype = @mailtype_2 where id = @mailid_1

GO

 CREATE PROCEDURE MailShare_Delete 
	(@id	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	delete from MailShare where id=@id

GO

 CREATE PROCEDURE MailShare_Insert 
       (@mailgroupid         int,
	@sharetype	tinyint,
	@seclevel	tinyint,
	@rolelevel	tinyint,
	@sharelevel	tinyint,
	@userid	        int,
	@subcompanyid	int,
	@departmentid	int,
	@roleid	        int,
	@foralluser	tinyint,
	@sharedcrm	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	insert into MailShare (mailgroupid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,sharedcrm) values
	(@mailgroupid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser,@sharedcrm)


GO

/*********************************/
 CREATE PROCEDURE MailShare_InsertByUser 
    @seclevel int,
    @departmentid int,
    @subcompanyid int,
    @userid	int, 
    @flag	int	output, 
    @msg	varchar(80) output 
as 
	declare	@mailgroupid	int,
 @all_cursor cursor
  SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
  select Distinct mailgroupid from MailShare  where sharetype=5 or (sharetype=3 and @seclevel>=seclevel and @departmentid=departmentid) 
  OR (sharetype=2 and @seclevel>=seclevel and @subcompanyid=subcompanyid) 
  OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @mailgroupid  
  WHILE @@FETCH_STATUS = 0 
			begin
            insert into MailUserShare (mailgroupid,userid) values (@mailgroupid , @userid)
            FETCH NEXT FROM @all_cursor INTO @mailgroupid 
			end 
 CLOSE @all_cursor DEALLOCATE @all_cursor


GO

 CREATE PROCEDURE MailShare_SelectByMailgroupid 
	(@mailgroupid	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	select * from MailShare where mailgroupid = @mailgroupid


GO

 CREATE PROCEDURE MailUserAddress_Delete 
 ( 
@mailgroupid int,
@mailaddress     varchar(255),
@flag [int]  output, 
@msg  [varchar](80) output)
as
delete from MailUserAddress WHERE mailgroupid=@mailgroupid and mailaddress=@mailaddress

GO

 CREATE PROCEDURE MailUserAddress_Insert 
 ( 
@mailgroupid int,
@mailaddress     varchar(255),
@maildesc   varchar(255),
@flag [int]  output, 
@msg  [varchar](80) output)
as
insert into MailUserAddress values (@mailgroupid,@mailaddress,@maildesc)

GO

 CREATE PROCEDURE MailUserAddress_SelectAllById 
 ( 
@mailgroupid int,
@flag [int]  output, 
@msg  [varchar](80) output)
as
select * from MailUserAddress WHERE mailgroupid=@mailgroupid

GO

 CREATE PROCEDURE MailUserGroup_DeleteById 
 ( 
@mailgroupid int,
@flag [int]  output, 
@msg  [varchar](80) output)
as
delete from MailUserGroup WHERE mailgroupid=@mailgroupid

GO

 CREATE PROCEDURE MailUserGroup_Insert 
  ( 
@mailgroupname  varchar(200),
@operatedesc varchar(255) ,				 /*描述*/
@createrid   int,		                         /*创建者*/
@createrdate    char(10) ,			 /*操作日期 格式为 2002-09－15 */      
@flag [int]  output, 
@msg  [varchar](80) output)
as
INSERT INTO MailUserGroup  (mailgroupname,operatedesc,createrid,createrdate)
VALUES (@mailgroupname,@operatedesc,@createrid,@createrdate)


GO

 CREATE PROCEDURE MailUserGroup_SelectAll 
  ( 
@flag [int]  output, 
@msg  [varchar](80) output)
as
select * from MailUserGroup 

GO

/************************2002-12-12 11:31 alter wl********************************/
 CREATE PROCEDURE MailUserGroup_SelectByUser 
  ( 
@userid     int,
@flag [int]  output, 
@msg  [varchar](80) output)
as
select * from MailUserGroup where createrid=@userid

GO

 CREATE PROCEDURE MailUserGroup_SMailgroupname 
 ( 
@userid	int,
@flag [int]  output, 
@msg  [varchar](80) output)
as
select mailgroupname from MailUserGroup where createrid=@userid

GO

 CREATE PROCEDURE MailUserGroup_SelectNameById 
 ( 
@mailgroupid int,
@flag [int]  output, 
@msg  [varchar](80) output)
as
select mailgroupname,operatedesc from MailUserGroup WHERE mailgroupid=@mailgroupid

GO

 CREATE PROCEDURE MailUserGroup_UpdateById 
 ( 
@mailgroupname  varchar(200),
@operatedesc varchar(255) ,				 
@mailgroupid int,
@flag [int]  output, 
@msg  [varchar](80) output)
as
update MailUserGroup set mailgroupname=@mailgroupname,operatedesc=@operatedesc
WHERE mailgroupid=@mailgroupid

GO

 CREATE PROCEDURE MailUserShare_DbyMailgroupId 
(@mailgroupid 	[int],
 @flag	int output,
 @msg	varchar(80)	output)
as
	delete from MailUserShare where mailgroupid=@mailgroupid

GO

 CREATE PROCEDURE MailUserShare_DeletebyUserId 
(@userid 	[int],
 @flag	int output,
 @msg	varchar(80)	output)
as
	delete from MailUserShare where userid=@userid

GO

 CREATE PROCEDURE MailUserShare_SelectbyUserId 
(@userid 	[int],
 @flag	int output,
 @msg	varchar(80)	output)
as
	select mailgroupid from MailUserShare where userid=@userid

GO

 CREATE PROCEDURE MailUser_DeleteById 
 ( 
@mailgroupid    int,
@resourceid int,
@flag [int]  output, 
@msg  [varchar](80) output)
as
delete from MailUser WHERE resourceid=@resourceid and mailgroupid=@mailgroupid

GO

 CREATE PROCEDURE MailUser_Insert 
  ( 
@mailgroupid int,   /*mail user group */
@resourceid  int,   /*appoint user*/    
@flag [int]  output, 
@msg  [varchar](80) output)
as
INSERT INTO MailUser (mailgroupid,resourceid)
VALUES (@mailgroupid,@resourceid)


GO

 CREATE PROCEDURE MailUser_SelectAllById 
 ( 
@mailgroupid int,
@flag [int]  output, 
@msg  [varchar](80) output)
as
select * from MailUser WHERE mailgroupid=@mailgroupid

GO

 CREATE PROCEDURE MeetingCaller_Delete 
	@id int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	delete from MeetingCaller where id=@id

GO

 CREATE PROCEDURE MeetingCaller_Insert 
	@meetingtype int,
	@callertype  int,
	@seclevel    int,
	@rolelevel   int,
	@userid      int,
	@departmentid      int,
	@roleid      int,
	@foralluser  int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into MeetingCaller(meetingtype,callertype,seclevel,rolelevel,userid,departmentid,roleid,foralluser)
	values (@meetingtype,@callertype,@seclevel,@rolelevel,@userid,@departmentid,@roleid,@foralluser)

GO

 CREATE PROCEDURE MeetingCaller_SByMeeting 
	@meetingtype int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from MeetingCaller where meetingtype=@meetingtype

GO

 CREATE PROCEDURE Meeting_Address_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_Address] WHERE ( id = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Address_Insert 
(@meetingtype [int], 
 @addressid [int], 
 @desc_n [varchar](255), 
 @flag integer output, 
 @msg varchar(80) output  )  
AS 
INSERT INTO [Meeting_Address] ( [meetingtype],[addressid],[desc_n])  VALUES ( @meetingtype, @addressid, @desc_n ) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Address_SelectAll 
 ( @meetingtype [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Address] where meetingtype = @meetingtype set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Approve 
 (@meetingid [int] , @approver [int] , @approvedate [varchar] (10)  ,@approvetime [varchar] (8)  , @flag integer output, @msg varchar(80) output) AS 
Update [Meeting] set [isapproved]='2', [approver]=@approver, [approvedate]=@approvedate, [approvetime]=@approvetime  
where id = @meetingid
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Decision_Delete 
 (@meetingid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_Decision] WHERE ( meetingid = @meetingid ) set @flag = 1 set @msg = 'OK!' 

GO

/*20021105*/



 CREATE PROCEDURE Meeting_Decision_Insert 
 (@meetingid [int] , @requestid [int] , @coding varchar(100) ,	@subject varchar(255) ,	@hrmid01 varchar(255) , @hrmid02 [int] , @begindate varchar (10)  , @begintime varchar (8)  , @enddate varchar (10)  , @endtime varchar (8) , @flag integer output, @msg varchar(80) output) AS
INSERT INTO 
[Meeting_Decision]
 ( [meetingid] ,[requestid] , coding, subject, hrmid01, hrmid02, begindate, begintime, enddate, endtime )  VALUES ( @meetingid , @requestid , @coding, @subject, @hrmid01, @hrmid02, @begindate, @begintime, @enddate, @endtime  ) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Decision_SelectAll 
 ( @meetingid [int],  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Decision] where meetingid = @meetingid set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting] WHERE ( id = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Insert 
(@meetingtype [int] ,
 @name [varchar] (255) ,
 @caller [int] ,
 @contacter [int] ,
 @projectid[int],
 @address [int] ,
 @begindate [varchar] (10),
 @begintime [varchar] (8),
 @enddate [varchar] (10),
 @endtime [varchar] (8),
 @desc_n [varchar] (255),
 @creater [int],
 @createdate [varchar] (10),
 @createtime [varchar] (8) , 
 @totalmember   int,
 @othermembers   text,
 @addressdesc   varchar(255),
 @flag integer output, @msg varchar(80) output) 
AS
INSERT INTO [Meeting] ( [meetingtype] ,[name] ,[caller] ,[contacter] ,[projectid],[address] ,[begindate]  ,[begintime] ,[enddate] ,[endtime] ,[desc_n],[creater] ,[createdate] ,[createtime],totalmember,othermembers,addressdesc)  
VALUES ( @meetingtype ,@name,@caller,	@contacter,@projectid,@address ,@begindate  ,@begintime  ,@enddate ,@endtime ,@desc_n  ,@creater ,@createdate ,@createtime,@totalmember,@othermembers,@addressdesc) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Member2_Delete 
 (@meetingid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_Member2] WHERE ( meetingid = @meetingid ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Member2_Insert 
 (@meetingid [int] , @membertype [tinyint] ,	@memberid [int],	@membermanager [int] , @flag integer output, @msg varchar(80) output) AS 
INSERT INTO [Meeting_Member2] ( [meetingid] ,[membertype] ,[memberid] ,[membermanager])  VALUES ( @meetingid , @membertype, @memberid, @membermanager) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Member2_SelectByID 
 ( @id [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Member2] where id = @id set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Member2_SelectByType 
 ( @meetingid [int], @membertype [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Member2] where meetingid = @meetingid and membertype = @membertype set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Member2_Update 
 (@id [int] , @isattend varchar(50) ,	@begindate varchar (10)  , @begintime varchar (8)  , @enddate varchar (10)  ,	@endtime varchar (8)  ,	@bookroom varchar(50) ,	@roomstander varchar(50) , @bookticket varchar(50) ,	@ticketstander varchar(50) ,	@othermember varchar(255) , @flag integer output, @msg varchar(80) output) AS 
Update [Meeting_Member2] set  [isattend]=@isattend , [begindate]=@begindate , [begintime]=@begintime , [enddate]=@enddate, [endtime]=@endtime , [bookroom]=@bookroom ,[roomstander]=@roomstander , [bookticket]=@bookticket , [ticketstander]=@ticketstander  , [othermember]=@othermember 
where id = @id
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_MemberCrm_Delete 
 (@memberrecid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_MemberCrm] WHERE ( memberrecid = @memberrecid ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_MemberCrm_Insert 
 (@meetingid [int] , @memberrecid [int] , @name [varchar] (100), @sex [tinyint], @occupation [varchar] (100), @tel  [varchar] (100), @handset [varchar] (100), @desc_n [varchar] (255), @flag integer output, @msg varchar(80) output) AS 
INSERT INTO [Meeting_MemberCrm] ( [meetingid] ,[memberrecid] ,[name], [sex] ,[occupation], [tel] ,[handset], [desc_n])  VALUES ( @meetingid , @memberrecid, @name, @sex , @occupation, @tel , @handset, @desc_n) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_MemberCrm_SelectAll 
 ( @memberrecid [int],  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_MemberCrm] where memberrecid = @memberrecid set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Member_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_Member] WHERE ( id = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Member_Insert 
 (@meetingtype [int], @membertype [tinyint], @memberid [int], @desc_n [varchar](255), @flag integer output, @msg varchar(80) output  )  AS 
INSERT INTO [Meeting_Member] ( [meetingtype],[membertype],[memberid],[desc_n])  VALUES ( @meetingtype, @membertype, @memberid, @desc_n ) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Member_SelectAll 
 ( @meetingtype [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Member] where meetingtype = @meetingtype order by membertype set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Member_SelectByType 
 ( @meetingtype [int], @membertype [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Member] where meetingtype = @meetingtype and membertype = @membertype set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Schedule 
 (@meetingid [int] , @flag integer output, @msg varchar(80) output) AS 
Update [Meeting] set [isapproved]='3'  
where id = @meetingid
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_SelectByID 
 ( @meetingid [int] , @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting] where id = @meetingid set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_SelectMaxID 
 (  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT max(id) FROM [Meeting] set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Service2_Delete 
 (@meetingid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_Service2] WHERE ( meetingid = @meetingid ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Service2_Insert 
 (@meetingid [int] , @hrmid [int] , @name [varchar](255) , @desc_n [varchar](255), @flag integer output, @msg varchar(80) output) AS 
INSERT INTO [Meeting_Service2] ( [meetingid] ,[hrmid] ,[name], [desc_n])  VALUES ( @meetingid , @hrmid, @name , @desc_n) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Service2_SelectAll 
 ( @meetingid [int],  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Service2] where meetingid = @meetingid set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Service_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_Service] WHERE ( id = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Service_Insert 
 (@meetingtype [int], @hrmid [int], @name [varchar](255), @desc_n [varchar](255), @flag integer output, @msg varchar(80) output  )  AS 
INSERT INTO [Meeting_Service] ( [meetingtype],[hrmid],[name],[desc_n])  VALUES ( @meetingtype, @hrmid, @name, @desc_n ) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Service_SelectAll 
 ( @meetingtype [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Service] where meetingtype = @meetingtype set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Submit 
 (@meetingid [int] , @flag integer output, @msg varchar(80) output) AS 
Update [Meeting] set [isapproved]='1'  
where id = @meetingid
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_TopicDate_Delete 
 (@meetingid [int], @topicid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_TopicDate] WHERE ( meetingid = @meetingid and topicid = @topicid ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_TopicDate_Insert 
 (@meetingid [int] , @topicid [int] , @begindate varchar (10)  , @begintime varchar (8)  , @enddate varchar (10)  ,	@endtime varchar (8)  , @flag integer output, @msg varchar(80) output) AS 
INSERT INTO [Meeting_TopicDate] ( [meetingid] ,[topicid] ,[begindate],[begintime],[enddate],[endtime])  VALUES ( @meetingid , @topicid, @begindate , @begintime  , @enddate , @endtime ) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_TopicDate_SelectAll 
 ( @meetingid [int], @topicid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM Meeting_TopicDate where meetingid = @meetingid and topicid = @topicid  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_TopicDoc_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_TopicDoc] WHERE ( id = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_TopicDoc_Insert 
 (@meetingid [int] , @topicid [int] , @docid [int], @hrmid [int], @flag integer output, @msg varchar(80) output) AS 
INSERT INTO [Meeting_TopicDoc] ( [meetingid] ,[topicid] ,[docid],[hrmid])  VALUES ( @meetingid , @topicid, @docid, @hrmid) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_TopicDoc_SelectAll 
 ( @meetingid [int], @topicid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT t1.id,t1.docid,t1.hrmid,t2.docsubject,t2.ownerid FROM Meeting_TopicDoc as t1, DocDetail as t2 where t1.meetingid = @meetingid and t1.topicid = @topicid and t1.docid=t2.id set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Topic_Delete 
 (@meetingid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_Topic] WHERE ( meetingid = @meetingid ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Topic_Insert 
(@meetingid [int] , 
 @hrmid [int] , 
 @subject [varchar](255) , 
 @hrmids [varchar](255) , 
 @projid int,
 @crmid  int,
 @isopen [tinyint], 
 @flag integer output, 
 @msg varchar(80) output) 
AS
INSERT INTO [Meeting_Topic] ( [meetingid] ,[hrmid] ,[subject],[hrmids], [isopen],projid,crmid)  
VALUES ( @meetingid , @hrmid, @subject , @hrmids, @isopen,@projid,@crmid) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Topic_SelectAll 
 ( @meetingid [int],  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Topic] where meetingid = @meetingid set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Topic_Update 
(@id    int,
 @hrmid [int] , 
 @subject [varchar](255) , 
 @hrmids [varchar](255) , 
 @projid int,
 @crmid  int,
 @isopen [tinyint], 
 @flag integer output, 
 @msg varchar(80) output) 
AS
update [Meeting_Topic] set hrmid=@hrmid ,subject=@subject,hrmids=@hrmids,projid=@projid,crmid=@crmid,isopen=@isopen where id=@id
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Type_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Meeting_Type] WHERE ( id = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Type_Insert 
 (@name [varchar](255), @approver [int], @desc_n [varchar](255), @flag integer output, @msg varchar(80) output  )  AS 
INSERT INTO [Meeting_Type] ( [name], [approver], [desc_n])  VALUES ( @name, @approver, @desc_n ) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Type_SelectAll 
 ( @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Type] set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Type_SelectByID 
 ( @id [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Meeting_Type] where id=@id set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Meeting_Type_Update 
 (@id [int], @name [varchar](255), @approver [int], @desc_n [varchar](255), @flag integer output, @msg varchar(80) output  )  AS 
update [Meeting_Type]  set [name]=@name, [approver]=@approver, [desc_n]=@desc_n  
where id=@id
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_Update 
(@meetingid [int] ,
 @name [varchar] (255) ,
 @caller [int] ,	
 @contacter [int] ,
 @projectid [int],
 @address [int] ,
 @begindate [varchar] (10)  ,
 @begintime [varchar] (8)  ,
 @enddate [varchar] (10)  ,
 @endtime [varchar] (8)  ,
 @desc_n [varchar] (255)  , 
 @totalmember   int,
 @othermembers   text,
 @addressdesc   varchar(255),
 @flag integer output, 
 @msg varchar(80) output) 
AS
Update [Meeting] set  [name]=@name ,[caller]=@caller ,[contacter]=@contacter ,[projectid]=@projectid,[address]=@address ,[begindate]=@begindate ,[begintime]=@begintime ,[enddate]=@enddate ,[endtime]=@endtime ,[desc_n]=@desc_n,totalmember=@totalmember,othermembers=@othermembers,addressdesc=@addressdesc  
where id = @meetingid
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Meeting_UpdateDecision 
 (@meetingid [int] , @isdecision [int],  @decision [text], @decisiondocid [int], @decisiondate [varchar] (10)  , @decisiontime [varchar] (8) , @decisionhrmid [int] , @flag integer output, @msg varchar(80) output) AS 
Update [Meeting] set [isdecision]=@isdecision, [decision]=@decision, decisiondocid=@decisiondocid, [decisiondate]=@decisiondate, [decisiontime]=@decisiontime, decisionhrmid=@decisionhrmid  
where id = @meetingid
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE MemberRoleInfo_Select 
 (@flag int output, @msg varchar(80) output)  AS select resourceid , roleid , rolelevel from HrmRoleMembers order by resourceid 
GO

 CREATE PROCEDURE NewDocFrontpage_DeleteByDocId 
  (
   @docid  int,
   @flag integer output,
   @msg varchar(80) output)  
  AS 
  delete from  NewDocFrontpage where docid=@docid

GO

 CREATE PROCEDURE NewDocFrontpage_DeleteByUser 
  (@usertype int,
   @userid int,
   @docid  int,
   @flag integer output,
   @msg varchar(80) output)  
  AS 
  delete from  NewDocFrontpage where usertype=@usertype and userid=@userid and docid=@docid

GO

 CREATE PROCEDURE NewDocFrontpage_Insert 
  (@usertype int,
   @userid int,
   @docid  int,
   @flag integer output,
   @msg varchar(80) output)  
  AS 
  insert into NewDocFrontpage (usertype,userid,docid) VALUES(@usertype,@userid,@docid)

GO

 CREATE PROCEDURE NewDocFrontpage_SMRecentCount 
(
@logintype		int,
@usertype		int,
@userid			int,
@userseclevel	int,
@flag integer output,
@msg varchar(80) output) 
as
if @logintype=1 
begin
Select count(distinct c.id ) countnew from NewDocFrontpage n , DocShareDetail d , docdetail c where n.docid=d.docid and n.docid=c.id and n.userid=d.userid and  d.usertype=1 and n.userid=@userid and (c.docpublishtype='2' or c.docpublishtype='3') and c.docstatus in('1','2','5') and c.maincategory='5'
end
else
  begin 
  Select count(distinct c.id ) countnew from NewDocFrontpage n , DocShareDetail d  , docdetail c where  n.docid=d.docid and n.docid= c.id and  n.usertype = d.usertype and n.usertype=@usertype and d.userid<=@userseclevel and ( c.docpublishtype='2' or c.docpublishtype='3') and c.docstatus in('1','2','5') and maincategory='5'
end

GO

 CREATE PROCEDURE NewDocFrontpage_SRecentCount 
(
@logintype		int,
@usertype		int,
@userid			int,
@userseclevel	int,
@flag integer output,
@msg varchar(80) output) 
as
if @logintype=1 
begin
Select count(distinct c.id ) countnew from NewDocFrontpage n , DocShareDetail d , docdetail c where n.docid=d.docid and n.docid=c.id and n.userid=d.userid and  d.usertype=1 and n.userid=@userid and (c.docpublishtype='2' or c.docpublishtype='3') and c.docstatus in('1','2','5')
end
else
  begin 
  Select count(distinct c.id ) countnew from NewDocFrontpage n , DocShareDetail d  , docdetail c where  n.docid=d.docid and n.docid= c.id and  n.usertype = d.usertype and n.usertype=@usertype and d.userid<=@userseclevel and ( c.docpublishtype='2' or c.docpublishtype='3') and c.docstatus in('1','2','5')
end

GO

 CREATE PROCEDURE NewDocFrontpage_SelectAllNId 
(
@pagenumber     int,
@perpage        int,
@countnumber    int,
@logintype		int,
@usertype		int,
@userid			int,
@userseclevel	int,
@flag integer output,
@msg varchar(80) output) 
as
declare @pagecount int 
declare @pagecount2 int 
set @pagecount =  @pagenumber*@perpage
if (@countnumber-(@pagenumber-1)*@perpage)<@perpage       					
set @pagecount2 =@countnumber-(@pagenumber-1)*@perpage
else 
set @pagecount2 =@perpage 

if @logintype=1 
begin
exec ('Select distinct top ' + @pagecount+ ' c.id , c.docsubject , c.doccreatedate , c.doccreatetime into #temp from NewDocFrontpage n , DocShareDetail d , docdetail c where n.docid=d.docid and n.docid=c.id and n.userid=d.userid and  d.usertype=1 and n.userid='+@userid+' and (c.docpublishtype=''2'' or c.docpublishtype=''3'') and c.docstatus in(''1'',''2'',''5'') order by c.doccreatedate  desc , c.doccreatetime desc ;'+
'select top '+@pagecount2+'* from #temp order by doccreatedate, doccreatetime')
end
if @logintype<>1
begin
   exec ('Select distinct top '+@pagecount+' c.id , c.docsubject , c.doccreatedate , c.doccreatetime into #temp from NewDocFrontpage n , DocShareDetail d  , docdetail c where  n.docid=d.docid and n.docid= c.id and  n.usertype = d.usertype and n.usertype='+@usertype+' and d.userid<='+@userseclevel+' and ( c.docpublishtype=''2'' or c.docpublishtype=''3'') and c.docstatus in(''1'',''2'',''5'') order by c.doccreatedate desc , c.doccreatetime desc ;'+
   'select top '+@pagecount2+' * from #temp order by doccreatedate, doccreatetime') 
end


GO

 CREATE PROCEDURE NewDocFrontpage_SelectMAllNId 
(
@pagenumber     int,
@perpage        int,
@countnumber    int,
@logintype		int,
@usertype		int,
@userid			int,
@userseclevel	int,
@flag integer output,
@msg varchar(80) output) 
as
declare @pagecount int 
declare @pagecount2 int 
set @pagecount =  @pagenumber*@perpage
if (@countnumber-(@pagenumber-1)*@perpage)<@perpage       					
set @pagecount2 =@countnumber-(@pagenumber-1)*@perpage
else 
set @pagecount2 =@perpage

if @logintype=1 
begin
exec ('Select distinct top ' + @pagecount+ ' c.id , c.docsubject , c.doccreatedate , c.doccreatetime into #temp from NewDocFrontpage n , DocShareDetail d , docdetail c where n.docid=d.docid and n.docid=c.id and n.userid=d.userid and  d.usertype=1 and n.userid='+@userid+' and (c.docpublishtype=''2'' or c.docpublishtype=''3'') and c.docstatus in(''1'',''2'',''5'') and maincategory=''5'' order by c.doccreatedate  desc , c.doccreatetime desc ;'+
'select top '+@pagecount2+'* from #temp order by doccreatedate, doccreatetime')
end
if @logintype<>1
begin 
  exec ('Select distinct top '+@pagecount+' c.id , c.docsubject , c.doccreatedate , c.doccreatetime into #temp from NewDocFrontpage n , DocShareDetail d  , docdetail c where  n.docid=d.docid and n.docid= c.id and  n.usertype = d.usertype and n.usertype='+@usertype+' and d.userid<='+@userseclevel+' and ( c.docpublishtype=''2'' or c.docpublishtype=''3'') and c.docstatus in(''1'',''2'',''5'') and maincategory=''5'' order by c.doccreatedate desc , c.doccreatetime desc ;'+
 'select top '+@pagecount2+' * from #temp order by doccreatedate, doccreatetime')
   
end


GO

 CREATE PROCEDURE PRJ_Find_LastModifier 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT top 1 submiter,submitdate from [Prj_Log] WHERE ([projectid] = @id) and (not ([logtype] = 'n')) ORDER BY submitdate DESC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE PrjShareDetail_DByPrjId 
	(@prjid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS DELETE [PrjShareDetail] 
WHERE 
	( [prjid]	 = @prjid_1)

GO

 CREATE PROCEDURE PrjShareDetail_DByUserId 
	(@userid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS DELETE [PrjShareDetail] 
WHERE 
	( [userid]	 = @userid_1  and usertype = '1' )

GO

 CREATE PROCEDURE PrjShareDetail_Insert 
	(@prjid_1 	[int],
	 @userid_2 	[int],
	 @usertype_3 	[int],
	 @sharelevel_4 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS INSERT INTO [PrjShareDetail] 
	 ( [prjid],
	 [userid],
	 [usertype],
	 [sharelevel]) 
VALUES 
	( @prjid_1,
	 @userid_2,
	 @usertype_3,
	 @sharelevel_4)

GO

 CREATE PROCEDURE PrjShareDetail_SByPrjId 
	(@prjid_1 int ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS 
select * from PrjShareDetail where prjid = @prjid_1 

GO

 CREATE PROCEDURE PrjShareDetail_SByResourceId 
	(@resourceid_1 int ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS 
select prjid , sharelevel from PrjShareDetail where userid = @resourceid_1 and usertype = '1'  

GO

 CREATE PROCEDURE Prj_Cpt_Insert 
 (@prjid 	[int], @taskid 	[int], @requestid [int], @flag integer output, @msg varchar(80) output  )  AS 
INSERT INTO [Prj_Cpt] ( prjid, taskid, requestid)  VALUES ( @prjid, @taskid, @requestid) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Customer_DeleteByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS delete [Prj_Customer] WHERE ( id = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Customer_FindByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_Customer] WHERE ( id	 = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Customer_FindByTaskID 
 (@prjid 	[int], @taskid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_Customer] WHERE ( prjid	 = @prjid and taskid = @taskid ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Customer_Insert 
 (@prjid 	[int], @taskid 	[int], @customerid 	[int], @powerlevel 	[tinyint], @reasondesc	[varchar](100), @flag	[int]	output, @msg	[varchar](80)	output) AS INSERT INTO [Prj_Customer] ( [prjid], [taskid], [customerid], [powerlevel], [reasondesc])  VALUES ( @prjid, @taskid, @customerid, @powerlevel, @reasondesc)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Customer_Update 
 (@id 	[int], @customerid 	[int], @powerlevel 	[tinyint], @reasondesc	[varchar](100), @flag	[int]	output, @msg	[varchar](80)	output) AS Update [Prj_Customer] set customerid=@customerid, powerlevel=@powerlevel, reasondesc=@reasondesc  where id=@id set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Doc_Insert 
 (@prjid [int], @taskid [int], @docid 	[int], @flag integer output, @msg varchar(80) output  )  AS 
INSERT INTO [Prj_Doc] ( prjid, taskid, docid)  VALUES ( @prjid, @taskid, @docid) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Find_Contract 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_Contract] WHERE ([projid] = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_Find_Customer 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_Customer] WHERE ([prjid] = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_Material 
 (@prjid 	[int], @taskid [int] , @version [varchar] (10), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_Material] WHERE ([prjid] = @prjid and [taskid] = @taskid and [version] like '%' + @version + '%' ) order by material  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_MaterialProcess 
 (@prjid 	[int], @taskid [int] ,  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_MaterialProcess] WHERE ([prjid] = @prjid and [taskid] = @taskid  and ( [isactived] = '2' or [isactived] = '3' )) order by material  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_MaterialProcessbyid 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_MaterialProcess] WHERE ([id] = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_Materialbyid 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_Material] WHERE ([id] = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_Member 
 (@prjid 	[int], @taskid [int] , @version [varchar] (10), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_Member] WHERE ([prjid] = @prjid and [taskid] = @taskid and [version] like '%' + @version + '%' ) order by relateid  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_MemberHasRightByPrjid 
 (@prjid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT distinct * from [Prj_MemberProcess] WHERE ([prjid] = @prjid  and  [isactived] <> '1' ) order by relateid  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_MemberProcess 
 (@prjid 	[int], @taskid [int] , @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_MemberProcess] WHERE ([prjid] = @prjid and [taskid] = @taskid and ( [isactived] = '2' or [isactived] = '3' ) ) order by relateid  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_MemberProcessByPrjid 
 (@prjid 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT distinct * from [Prj_MemberProcess] WHERE ([prjid] = @prjid  and ( [isactived] = '2' or [isactived] = '3' ) ) order by relateid  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_MemberProcessbyid 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_MemberProcess] WHERE ([id] = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_Memberbyid 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_Member] WHERE ([id] = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_RecentRemark 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT top 3 * from [Prj_Log] WHERE ([projectid] = @id) ORDER BY submitdate DESC, submittime DESC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_Find_Tool 
 (@prjid 	[int], @taskid [int] , @version [varchar] (10), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_Tool] WHERE ([prjid] = @prjid and [taskid] = @taskid and [version] like '%' + @version + '%' ) order by relateid  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_ToolProcess 
 (@prjid 	[int], @taskid [int] , @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_ToolProcess] WHERE ([prjid] = @prjid and [taskid] = @taskid and ( [isactived] = '2' or [isactived] = '3' ) ) order by relateid  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_ToolProcessbyid 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_ToolProcess] WHERE ([id] = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Find_Toolbyid 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * from [Prj_Tool] WHERE ([id] = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Info_SelectCountByResource 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select count(*) from PRJ_ProjectInfo where manager = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源文档总数信息成功' return end else begin set @flag=0 set @msg='查询人力资源文档总数信息失败' return end 
GO

 CREATE PROCEDURE Prj_Jianbao_Insert 
 (@projectid 	[int], @type 	[char](2), @documentid 	[int], @content 	[varchar](255), @submitdate 	[varchar](10), @submittime 	[varchar](8), @submiter	[int], @submitertype 	[tinyint], @clientip	[char](15), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_Jianbao] ( [projectid], [type], [documentid], [content], [submitdate], [submittime], [submiter], [submitertype], [clientip])  VALUES ( @projectid, @type, @documentid, @content, @submitdate, @submittime, @submiter, @submitertype, @clientip)  set @flag = 1 set @msg = 'OK!' 


GO

 CREATE PROCEDURE Prj_Jianbao_Select 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_Jianbao] WHERE ( [projectid]	 = @id) ORDER BY submitdate DESC, submittime DESC set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Log_Insert 
 (@projectid 	[int], @logtype 	[char](2), @documentid 	[int], @logcontent 	[varchar](255), @submitdate 	[varchar](10), @submittime 	[varchar](8), @submiter	[int], @submitertype 	[tinyint], @clientip	[char](15), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_Log] ( [projectid], [logtype], [documentid], [logcontent], [submitdate], [submittime], [submiter], [submitertype], [clientip])  VALUES ( @projectid, @logtype, @documentid, @logcontent, @submitdate, @submittime, @submiter, @submitertype, @clientip)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Log_Select 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_Log] WHERE ( [projectid]	 = @id) ORDER BY submitdate DESC, submittime DESC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_MaterialProcess_Delete 
 (@id [int],  @flag integer output, @msg varchar(80) output )  AS update [Prj_MaterialProcess] set [isactived] = '1'  WHERE ( [id] = @id )  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_MaterialProcess_Insert 
 (@prjid 	[int], @taskid [int], @material 	 [varchar] (100), @unit 	 [varchar] (10), @isactived [tinyint], @begindate 	[varchar](10), @enddate [varchar](10), @quantity [int], @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS INSERT INTO [Prj_MaterialProcess] ( [prjid], [taskid], [material], [unit], [isactived], [begindate], [enddate], [quantity], [cost])  VALUES ( @prjid , @taskid , @material 	, @unit 	, @isactived, @begindate, @enddate, @quantity, @cost ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_MaterialProcess_Update 
  (@id [int],  @material 	 [varchar] (100), @unit 	 [varchar] (10),  @begindate 	[varchar](10), @enddate [varchar](10), @quantity [int], @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
update [Prj_MaterialProcess] set material=@material, begindate=@begindate, enddate=@enddate, unit=@unit, quantity=@quantity, cost=@cost  WHERE ( [id] = @id)  
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Material_Delete 
 (@id [int], @version [varchar] (10), @flag integer output, @msg varchar(80) output )  AS update [Prj_Material] set version=replace(version, @version, '')  WHERE ( [id] = @id) delete [Prj_Material] WHERE ( [id] = @id and version='' )  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Material_Insert 
 (@prjid 	[int], @taskid [int], @material 	 [varchar] (100), @unit 	 [varchar] (10), @version [varchar] (10), @begindate 	[varchar](10), @enddate [varchar](10), @quantity [int], @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
INSERT INTO [Prj_Material] ( [prjid], [taskid], [material], [unit], [version], [begindate], [enddate], [quantity], [cost])  VALUES ( @prjid , @taskid , @material 	, @unit 	, @version, @begindate, @enddate, @quantity, @cost ) 
INSERT INTO [Prj_MaterialProcess] ( [prjid], [taskid], [material], [unit], [isactived])  VALUES ( @prjid , @taskid , @material 	, @unit 	, '0')
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Material_SelectAllPlan 
 (@prjid [int], @version [varchar] (10), @material [varchar] (100), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT t1.*,t2.wbscoding,t2.subject,t2.id as taskrecordid FROM [Prj_Material] as t1, [Prj_TaskInfo] as t2 WHERE ( t1.prjid	 = @prjid and t1.version like '%|' + @version + '|%' and t1.material = @material and t2.prjid	 = @prjid and t2.version = @version  and t1.taskid=t2.taskid ) order by t2.wbscoding  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Material_SelectAllProcess 
 (@prjid [int], @material [varchar] (100), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT t1.*,t3.wbscoding,t3.subject,t2.id as taskrecordid FROM [Prj_MaterialProcess] as t1, [Prj_TaskProcess] as t2 , [Prj_TaskInfo] as t3 WHERE ( t1.prjid	 = @prjid and ( t1.isactived = '2' or t1.isactived = '3' ) and t1.material = @material and t2.prjid	 = @prjid and ( t2.isactived = '2' or t2.isactived = '3' )  and t1.taskid=t2.taskid and t3.prjid = @prjid and t3.taskid = t2.taskid and t3.version =t2.version ) order by t3.wbscoding  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Material_SumPlan 
 (@prjid [int], @version [varchar] (10), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT material, sum(quantity) as quantity, sum(cost*quantity) as cost FROM [Prj_Material] WHERE ( prjid	 = @prjid and version like '%|' + @version + '|%' ) group by material set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Material_SumProcess 
 (@prjid [int],  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT material, sum(quantity) as quantity, sum(cost*quantity) as cost FROM [Prj_MaterialProcess] WHERE ( prjid	 = @prjid and ( isactived = '2' or isactived = '3' ) ) group by material set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Material_Update 
 (@id [int], @version [varchar] (10), @prjid 	[int], @taskid [int], @material 	 [varchar] (100), @unit 	 [varchar] (10),  @begindate 	[varchar](10), @enddate [varchar](10), @quantity [int], @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
update [Prj_Material] set version=replace(version, @version, '')  WHERE ( [id] = @id) delete [Prj_Material] WHERE ( [id] = @id and version='' )  
INSERT INTO [Prj_Material] ( [prjid], [taskid], [material], [unit], [version], [begindate], [enddate], [quantity], [cost])  VALUES ( @prjid , @taskid , @material 	, @unit 	, @version, @begindate, @enddate, @quantity, @cost )
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_MemberProcess_Delete 
 (@id [int],  @flag integer output, @msg varchar(80) output )  AS update [Prj_MemberProcess] set [isactived] = '1'  WHERE ( [id] = @id)    set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_MemberProcess_Insert 
 (@prjid 	[int], @taskid [int], @relateid 	[int],  @isactived [tinyint], @begindate 	[varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS INSERT INTO [Prj_MemberProcess] ( [prjid], [taskid], [relateid], [isactived], [begindate], [enddate], [workday], [cost])  VALUES ( @prjid , @taskid , @relateid , @isactived , @begindate, @enddate, @workday, @cost ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_MemberProcess_Update 
  (@id [int],  @relateid 	[int],  @begindate 	[varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
update [Prj_MemberProcess] set relateid=@relateid, begindate=@begindate, enddate=@enddate, workday=@workday, cost=@cost  WHERE ( [id] = @id)  
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Member_Delete 
 (@id [int], @version [varchar] (10), @flag integer output, @msg varchar(80) output )  AS update [Prj_Member] set version=replace(version, @version, '')  WHERE ( [id] = @id)  delete [Prj_Member] WHERE ( [id] = @id and version='' )  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Member_Insert 
 (@prjid 	[int], @taskid [int], @relateid 	[int], @version [varchar] (200), @begindate 	[varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
INSERT INTO [Prj_Member] ( [prjid], [taskid], [relateid], [version], [begindate], [enddate], [workday], [cost])  VALUES ( @prjid , @taskid , @relateid 	, @version, @begindate, @enddate, @workday, @cost )  
INSERT INTO [Prj_MemberProcess] ( [prjid], [taskid], [relateid], [isactived])  VALUES ( @prjid , @taskid , @relateid , '0') 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Member_SelectAllPlan 
 (@prjid [int], @version [varchar] (10), @relateid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT t1.*,t2.wbscoding,t2.subject,t2.id as taskrecordid FROM [Prj_Member] as t1, [Prj_TaskInfo] as t2 WHERE ( t1.prjid	 = @prjid and t1.version like '%|' + @version + '|%' and t1.relateid = @relateid and t2.prjid	 = @prjid and t2.version = @version  and t1.taskid=t2.taskid ) order by t2.wbscoding  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Member_SelectAllProcess 
 (@prjid [int], @hrmid [varchar](10), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_TaskProcess] WHERE ( [prjid]	 = @prjid and  [parenthrmids] like '%,'+@hrmid+'|%'  and isdelete<>'1') order by parentids  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Member_SelectSumByMember 
 (@id	 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS 
select count(distinct(t1.id)) from prj_projectinfo t1,prj_taskprocess t2 where ( t2.hrmid=@id and t2.prjid=t1.id and t1.isblock=1 ) or t1.manager=@id
GO

 CREATE PROCEDURE Prj_Member_SumPlan 
 (@prjid [int], @version [varchar] (10), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT relateid, sum(workday) as workday, min(begindate) as begindate, max(enddate) as enddate, sum(cost*workday) as cost FROM [Prj_Member] WHERE ( prjid	 = @prjid and version like '%|' + @version + '|%' ) group by relateid set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Member_SumProcess 
 (@prjid [int], @hrmid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS 
if @hrmid=''
begin
SELECT hrmid,  min(begindate) as begindate, max(enddate) as enddate FROM [Prj_TaskProcess] WHERE ( prjid	 = @prjid  and isdelete<>'1' ) group by hrmid 
end
else
begin
SELECT hrmid,  min(begindate) as begindate, max(enddate) as enddate FROM [Prj_TaskProcess] WHERE ( prjid	 = @prjid  and isdelete<>'1' and hrmid=@hrmid) group by hrmid 
end
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Member_Update 
  (@id [int], @version [varchar] (10), @prjid 	[int], @taskid [int], @relateid 	[int],  @begindate 	[varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
update [Prj_Member] set version=replace(version, @version, '')  WHERE ( [id] = @id)  delete [Prj_Member] WHERE ( [id] = @id and version='' )  
INSERT INTO [Prj_Member] ( [prjid], [taskid], [relateid], [version], [begindate], [enddate], [workday], [cost])  VALUES ( @prjid , @taskid , @relateid 	, @version, @begindate, @enddate, @workday, @cost )
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Modify_Insert 
 (@projectid_1 	[int], @type_2 	[char](20), @fieldname_3 	[varchar](100), @modifydate_4 	[varchar](10), @modifytime_5 	[varchar](8), @original_6 	[varchar](255), @modified_7 	[varchar](255), @modifier_8 	[int], @submitertype 	[tinyint], @clientip_9 	[char](15), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_Modify] ( [projectid], [type], [fieldname], [modifydate], [modifytime], [original], [modified], [modifier], [submitertype], [clientip])  VALUES ( @projectid_1, @type_2, @fieldname_3, @modifydate_4, @modifytime_5, @original_6, @modified_7, @modifier_8, @submitertype, @clientip_9)  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Modify_Select 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_Modify] WHERE ( [projectid]	 = @id) ORDER BY modifydate DESC, modifytime DESC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanInfo_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [Prj_PlanInfo]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_PlanInfo_Insert 
 (@prjid_1 	[int], @subject_2 	[varchar](50), @begindate_3 	[varchar](10), @enddate_4 	[varchar](10), @begintime_5 	[varchar](8), @endtime_6 	[varchar](8), @resourceid_7 	[int], @content_8 	[varchar](255), @budgetmoney_9 	[varchar](50), @docid_10 	[int], @plansort_11 	[int], @plantype_12 	[int], @validate_13 	[tinyint], @flag integer output, @msg varchar(80) output  )  AS INSERT INTO [Prj_PlanInfo] ( [prjid], [subject], [begindate], [enddate], [begintime], [endtime], [resourceid], [content], [budgetmoney], [docid], [plansort], [plantype], [validate_n])  VALUES ( @prjid_1, @subject_2, @begindate_3, @enddate_4, @begintime_5, @endtime_6, @resourceid_7, @content_8, @budgetmoney_9, @docid_10, @plansort_11, @plantype_12, @validate_13) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_PlanInfo_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_PlanInfo] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanInfo_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_PlanInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanInfo_Update 
 (@id_1 	[int], @subject_2 	[varchar](50), @begindate_3 	[varchar](10), @enddate_4 	[varchar](10), @begintime_5 	[varchar](8), @endtime_6 	[varchar](8), @resourceid_7 	[int], @content_8 	[varchar](255), @budgetmoney_9 	[varchar](50), @docid_10 	[int], @plansort_11 	[int], @plantype_12 	[int], @updatedate_13 	[varchar](10), @updatetime_14 	[varchar](5), @updater_15 	[int], @validate_16 	[int], @flag integer output, @msg varchar(80) output )  AS UPDATE [Prj_PlanInfo]  SET  [subject]	 = @subject_2, [begindate]	 = @begindate_3, [enddate]	 = @enddate_4, [begintime]	 = @begintime_5, [endtime]	 = @endtime_6, [resourceid]	 = @resourceid_7, [content]	 = @content_8, [budgetmoney]	 = @budgetmoney_9, [docid]	 = @docid_10, [plansort]	 = @plansort_11, [plantype]	 = @plantype_12, [updatedate]	 = @updatedate_13, [updatetime]	 = @updatetime_14, [updater]	 = @updater_15, [validate_n]	 = @validate_16  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_PlanInfo_Validate 
 (@id_1 	[int], @validate_16 	[int], @flag integer output, @msg varchar(80) output )  AS UPDATE [Prj_PlanInfo]  SET [validate_n]	 = @validate_16  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_PlanSort_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS DELETE [Prj_PlanSort]  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanSort_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_PlanSort] ( [fullname], [description])  VALUES ( @fullname, @description)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanSort_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_PlanSort] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanSort_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_PlanSort] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanSort_Update 
 (@id	 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [Prj_PlanSort]  SET  [fullname]	 = @fullname, [description]	 = @description  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanType_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS DELETE [Prj_PlanType]  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanType_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_PlanType] ( [fullname], [description])  VALUES ( @fullname, @description)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanType_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_PlanType] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanType_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_PlanType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_PlanType_Update 
 (@id	 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [Prj_PlanType]  SET  [fullname]	 = @fullname, [description]	 = @description  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_Plan_Approve 
(@prjid 	[int],  
 @flag integer output, 
 @msg varchar(80) output  )  
 AS 
 declare
		@taskid 	[int], 
		@wbscoding 	[varchar](20), 
		@subject 	[varchar](50), 
		@begindate 	[varchar](10), 
		@enddate 	[varchar](10), 
		@workday        [decimal] (10,1), 
		@content 	[varchar](255), 
		@fixedcost	[decimal](10,2),
		@parentid	[int],
		@parentids	[varchar](255),
		@parenthrmids	[varchar](255),
		@level_n		[tinyint],
		@hrmid		[int],
		@all_cursor	cursor
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR	
select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid from [Prj_TaskProcess] where prjid = @prjid 
OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate,
	@workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid
WHILE @@FETCH_STATUS = 0 
begin 
	INSERT INTO [Prj_TaskInfo] (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'2','1')
	FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate,
	@workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid
end 
CLOSE @all_cursor DEALLOCATE @all_cursor

GO

 CREATE PROCEDURE Prj_Plan_SaveFromProcess 
(@prjid 	[int], 
 @version	[tinyint],
 @flag integer output, 
 @msg varchar(80) output  )  
 AS 
 declare
		@taskid 	[int], 
		@wbscoding 	[varchar](20), 
		@subject 	[varchar](50), 
		@begindate 	[varchar](10), 
		@enddate 	[varchar](10), 
		@workday        [decimal] (10,1), 
		@content 	[varchar](255), 
		@fixedcost	[decimal](10,2),
		@parentid	[int],
		@parentids	[varchar](255),
		@parenthrmids	[varchar](255),
		@level_n		[tinyint],
		@hrmid		[int],
		@all_cursor	cursor
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR	
select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid from [Prj_TaskProcess] where prjid = @prjid 
OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate,
	@workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid
WHILE @@FETCH_STATUS = 0 
begin 
	INSERT INTO [Prj_TaskInfo] ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'1',@version)
	FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate,
	@workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid
end 
CLOSE @all_cursor DEALLOCATE @all_cursor

GO

 CREATE PROCEDURE Prj_Plan_Submit 
 (@prjid [int], @flag integer output, @msg varchar(80) output )  AS 
UPDATE [Prj_TaskProcess]  SET [isactived]	 = '1'  WHERE ( [prjid]	 = @prjid ) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Process_SumCostMaterial 
 (@prjid [int], @wbscoding [varchar](20), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT sum(t3.quantity*t3.cost) as cost FROM [Prj_TaskProcess] as t1, [Prj_TaskInfo] as t2, [Prj_MaterialProcess] as t3 WHERE ( t1.prjid = @prjid and t1.isactived <> '0' and t1.isactived <> '1' and t2.prjid = @prjid and t1.taskid = t2.taskid  and t1.version	 = t2.version and t2.wbscoding like @wbscoding+'%' and t3.prjid = @prjid and t3.taskid = t1.taskid and (t3.isactived = '2' or t3.isactived = '3')) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Process_SumCostMember 
 (@prjid [int], @wbscoding [varchar](20), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT sum(t3.workday*t3.cost) as cost FROM [Prj_TaskProcess] as t1, [Prj_TaskInfo] as t2, [Prj_MemberProcess] as t3 WHERE ( t1.prjid = @prjid and t1.isactived <> '0' and t1.isactived <> '1' and t2.prjid = @prjid and t1.taskid = t2.taskid  and t1.version	 = t2.version and t2.wbscoding like @wbscoding+'%' and t3.prjid = @prjid and t3.taskid = t1.taskid and (t3.isactived = '2' or t3.isactived = '3')) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Process_SumCostTool 
 (@prjid [int], @wbscoding [varchar](20), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT sum(t3.workday*t3.cost) as cost FROM [Prj_TaskProcess] as t1, [Prj_TaskInfo] as t2, [Prj_ToolProcess] as t3 WHERE ( t1.prjid = @prjid and t1.isactived <> '0' and t1.isactived <> '1' and t2.prjid = @prjid and t1.taskid = t2.taskid  and t1.version	 = t2.version and t2.wbscoding like @wbscoding+'%' and t3.prjid = @prjid and t3.taskid = t1.taskid and (t3.isactived = '2' or t3.isactived = '3')) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_ProcessingType_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS DELETE [Prj_ProcessingType]  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProcessingType_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_ProcessingType] ( [fullname], [description])  VALUES ( @fullname, @description)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProcessingType_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_ProcessingType] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProcessingType_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_ProcessingType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProcessingType_Update 
 (@id	 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [Prj_ProcessingType]  SET  [fullname]	 = @fullname, [description]	 = @description  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_Processing_Archive 
 (@id_1 	[int], @isprocessed_2 	[tinyint], @processdate_3 	[varchar](10), @processtime_4 	[varchar](8), @processor_5 	[int], @flag integer output, @msg varchar(80) output )  AS UPDATE [Prj_Processing]  SET  [isprocessed]	 = @isprocessed_2, [processdate]	 = @processdate_3, [processtime]	 = @processtime_4, [processor]	 = @processor_5  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_Processing_Insert 
 (@prjid_1 	[int], @planid_2 	[int], @title_3 	[varchar](50), @content_4 	[varchar](255), @type_5 	[int], @docid 	[int], @parentids_6 	[varchar](255), @submitdate_7 	[varchar](10), @submittime_8 	[varchar](5), @submiter_9 	[int], @flag integer output, @msg varchar(80) output )  AS declare @count integer select @count = max(id)+1 from  [Prj_Processing] select @parentids_6 = @parentids_6+','+convert(varchar(4),@count)  INSERT INTO [Prj_Processing] ( [prjid], [planid], [title], [content], [type], [docid], [parentids], [submitdate], [submittime], [submiter])  VALUES ( @prjid_1, @planid_2, @title_3, @content_4, @type_5, @docid, @parentids_6, @submitdate_7, @submittime_8, @submiter_9)  if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_Processing_SelectAll 
 ( @prjid	[int], @parentids	varchar(255), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_Processing] where ( [prjid]	 = @prjid) and ([parentids] like @parentids) order by parentids set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_Processing_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_Processing] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_Processing_Update 
 (@id_1 	[int], @title_2 	[varchar](50), @content_3 	[varchar](255), @type_4 	[int], @docid 	[int], @updatedate_5 	[varchar](10), @updatetime_6 	[varchar](5), @updater_7 	[int], @flag integer output, @msg varchar(80) output )  AS UPDATE [Prj_Processing]  SET  [title]	 = @title_2, [content]	 = @content_3, [type]	 = @type_4, [docid]	 = @docid, [updatedate]	 = @updatedate_5, [updatetime]	 = @updatetime_6, [updater]	 = @updater_7  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_ProjectInfo_Insert 
 (@name_1 	[varchar](50), @description_2 	[varchar](250), @prjtype_3 	[int], @worktype_4 	[int], @securelevel_5 	[int], @status_6 	[int], @isblock_7 	[tinyint], @managerview_8 	[tinyint], @parentview_9 	[tinyint], @budgetmoney_10 	[varchar](50), @moneyindeed_11 	[varchar](50), @budgetincome_12 	[varchar](50), @imcomeindeed_13 	[varchar](50), @planbegindate_14 	[varchar](10), @planbegintime_15 	[varchar](5), @planenddate_16 	[varchar](10), @planendtime_17 	[varchar](5), @truebegindate_18 	[varchar](10), @truebegintime_19 	[varchar](5), @trueenddate_20 	[varchar](10), @trueendtime_21 	[varchar](5), @planmanhour_22 	[int], @truemanhour_23 	[int], @picid_24 	[int], @intro_25 	[varchar](255), @parentid_26 	[int], @envaluedoc_27 	[int], @confirmdoc_28 	[int], @proposedoc_29 	[int], @manager_30 	[int], @department_31 	[int], @subcompanyid1 	[int], @creater_32 	[int], @createdate_33 	[varchar](10), @createtime_34 	[varchar](8), @isprocessed_35 	[tinyint], @processer_36 	[int], @processdate_37 	[varchar](10), @processtime_38 	[varchar](8), @datefield1_39 	[varchar](10), @datefield2_40 	[varchar](10), @datefield3_41 	[varchar](10), @datefield4_42 	[varchar](10), @datefield5_43 	[varchar](10), @numberfield1_44 	[float], @numberfield2_45 	[float], @numberfield3_46 	[float], @numberfield4_47 	[float], @numberfield5_48 	[float], @textfield1_49 	[varchar](100), @textfield2_50 	[varchar](100), @textfield3_51 	[varchar](100), @textfield4_52 	[varchar](100), @textfield5_53 	[varchar](100), @boolfield1_54 	[tinyint], @boolfield2_55 	[tinyint], @boolfield3_56 	[tinyint], @boolfield4_57 	[tinyint], @boolfield5_58 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_ProjectInfo] ( [name], [description], [prjtype], [worktype], [securelevel], [status], [isblock], [managerview], [parentview], [budgetmoney], [moneyindeed], [budgetincome], [imcomeindeed], [planbegindate], [planbegintime], [planenddate], [planendtime], [truebegindate], [truebegintime], [trueenddate], [trueendtime], [planmanhour], [truemanhour], [picid], [intro], [parentid], [envaluedoc], [confirmdoc], [proposedoc], [manager], [department], [subcompanyid1], [creater], [createdate], [createtime], [isprocessed], [processer], [processdate], [processtime], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5])  VALUES ( @name_1, @description_2, @prjtype_3, @worktype_4, @securelevel_5, @status_6, @isblock_7, @managerview_8, @parentview_9, convert(money,@budgetmoney_10), convert(money,@moneyindeed_11), convert(money,@budgetincome_12), convert(money,@imcomeindeed_13), @planbegindate_14, @planbegintime_15, @planenddate_16, @planendtime_17, @truebegindate_18, @truebegintime_19, @trueenddate_20, @trueendtime_21, @planmanhour_22, @truemanhour_23, @picid_24, @intro_25, @parentid_26, @envaluedoc_27, @confirmdoc_28, @proposedoc_29, @manager_30, @department_31, @subcompanyid1, @creater_32, @createdate_33, @createtime_34, @isprocessed_35, @processer_36, @processdate_37, @processtime_38, @datefield1_39, @datefield2_40, @datefield3_41, @datefield4_42, @datefield5_43, @numberfield1_44, @numberfield2_45, @numberfield3_46, @numberfield4_47, @numberfield5_48, @textfield1_49, @textfield2_50, @textfield3_51, @textfield4_52, @textfield5_53, @boolfield1_54, @boolfield2_55, @boolfield3_56, @boolfield4_57, @boolfield5_58) 

GO

 CREATE PROCEDURE Prj_ProjectInfo_InsertID 
 (@flag	[int]	output, @msg	[varchar](80)	output)  AS SELECT top 1 id from Prj_ProjectInfo ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectInfo_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_ProjectInfo] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectInfo_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_ProjectInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectInfo_Update 
 (@id_1 	[int], @name_2 	[varchar](50), @description_3 	[varchar](250), @prjtype_4 	[int], @worktype_5 	[int], @securelevel_6 	[int], @status_7 	[int], @isblock_8 	[tinyint], @managerview_9 	[tinyint], @parentview_10 	[tinyint], @budgetmoney_11 	[varchar](50), @moneyindeed_12 	[varchar](50), @budgetincome_13 	[varchar](50), @imcomeindeed_14 	[varchar](50), @planbegindate_15 	[varchar](10), @planbegintime_16 	[varchar](5), @planenddate_17 	[varchar](10), @planendtime_18 	[varchar](5), @truebegindate_19 	[varchar](10), @truebegintime_20 	[varchar](5), @trueenddate_21 	[varchar](10), @trueendtime_22 	[varchar](5), @planmanhour_23 	[int], @truemanhour_24 	[int], @picid_25 	[int], @intro_26 	[varchar](255), @parentid_27 	[int], @envaluedoc_28 	[int], @confirmdoc_29 	[int], @proposedoc_30 	[int], @manager_31 	[int], @department_32 	[int], @subcompanyid1 	[int], @datefield1_40 	[varchar](10), @datefield2_41 	[varchar](10), @datefield3_42 	[varchar](10), @datefield4_43 	[varchar](10), @datefield5_44 	[varchar](10), @numberfield1_45 	[float], @numberfield2_46 	[float], @numberfield3_47 	[float], @numberfield4_48 	[float], @numberfield5_49 	[float], @textfield1_50 	[varchar](100), @textfield2_51 	[varchar](100), @textfield3_52 	[varchar](100), @textfield4_53 	[varchar](100), @textfield5_54 	[varchar](100), @boolfield1_55 	[tinyint], @boolfield2_56 	[tinyint], @boolfield3_57 	[tinyint], @boolfield4_58 	[tinyint], @boolfield5_59 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [Prj_ProjectInfo]  SET  [name]	 = @name_2, [description]	 = @description_3, [prjtype]	 = @prjtype_4, [worktype]	 = @worktype_5, [securelevel]	 = @securelevel_6, [status]	 = @status_7, [isblock]	 = @isblock_8, [managerview]	 = @managerview_9, [parentview]	 = @parentview_10, [budgetmoney]	 = convert(money,@budgetmoney_11), [moneyindeed]	 = convert(money,@moneyindeed_12), [budgetincome]	 = convert(money,@budgetincome_13), [imcomeindeed]	 = convert(money,@imcomeindeed_14), [planbegindate]	 = @planbegindate_15, [planbegintime]	 = @planbegintime_16, [planenddate]	 = @planenddate_17, [planendtime]	 = @planendtime_18, [truebegindate]	 = @truebegindate_19, [truebegintime]	 = @truebegintime_20, [trueenddate]	 = @trueenddate_21, [trueendtime]	 = @trueendtime_22, [planmanhour]	 = @planmanhour_23, [truemanhour]	 = @truemanhour_24, [picid]	 = @picid_25, [intro]	 = @intro_26, [parentid]	 = @parentid_27, [envaluedoc]	 = @envaluedoc_28, [confirmdoc]	 = @confirmdoc_29, [proposedoc]	 = @proposedoc_30, [manager]	 = @manager_31, [department]	 = @department_32, [subcompanyid1] = @subcompanyid1, [datefield1]	 = @datefield1_40, [datefield2]	 = @datefield2_41, [datefield3]	 = @datefield3_42, [datefield4]	 = @datefield4_43, [datefield5]	 = @datefield5_44, [numberfield1]	 = @numberfield1_45, [numberfield2]	 = @numberfield2_46, [numberfield3]	 = @numberfield3_47, [numberfield4]	 = @numberfield4_48, [numberfield5]	 = @numberfield5_49, [textfield1]	 = @textfield1_50, [textfield2]	 = @textfield2_51, [textfield3]	 = @textfield3_52, [textfield4]	 = @textfield4_53, [textfield5]	 = @textfield5_54, [tinyintfield1]	 = @boolfield1_55, [tinyintfield2]	 = @boolfield2_56, [tinyintfield3]	 = @boolfield3_57, [tinyintfield4]	 = @boolfield4_58, [tinyintfield5]	 = @boolfield5_59  WHERE ( [id]	 = @id_1) 

GO

 CREATE PROCEDURE Prj_ProjectStatus_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS DELETE [Prj_ProjectStatus]  WHERE ( [id]	 = @id)   set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectStatus_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_ProjectStatus] ( [fullname], [description])  VALUES ( @fullname, @description)   set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectStatus_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_ProjectStatus] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectStatus_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_ProjectStatus] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectStatus_Update 
 (@id	 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [Prj_ProjectStatus]  SET  [fullname]	 = @fullname, [description]	 = @description  WHERE ( [id]	 = @id)   set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectType_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS DELETE [Prj_ProjectType]  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectType_Insert 
 (@fullname 	[varchar](50), @description 	[varchar](150), @wfid	 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_ProjectType] ( [fullname], [description], [wfid])  VALUES ( @fullname, @description, @wfid)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectType_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_ProjectType] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectType_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_ProjectType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_ProjectType_Update 
 (@id	 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @wfid	 	[int], @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [Prj_ProjectType]  SET  [fullname]	 = @fullname, [description]	 = @description, [wfid]	 = @wfid  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_Request_Insert 
 (@prjid 	[int], @taskid 	[int], @requestid [int], @flag integer output, @msg varchar(80) output  )  AS 
INSERT INTO [Prj_Request] ( prjid, taskid, requestid)  VALUES ( @prjid, @taskid, @requestid) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_RpSum 
 @optional	varchar(30), @flag	int output, @msg varchar(80) output AS if  @optional='projecttype' select prjtype AS resultid,COUNT(id) AS resultcount from Prj_Projectinfo  group by prjtype order by resultcount  if  @optional='worktype' select worktype AS resultid,COUNT(id) AS resultcount from Prj_Projectinfo  group by worktype order by resultcount  if  @optional='projectstatus' select status AS resultid,COUNT(id) AS resultcount from Prj_Projectinfo  group by status order by resultcount  if  @optional='manager' select manager AS resultid,COUNT(id) AS resultcount from Prj_Projectinfo  group by manager order by resultcount  if  @optional='department' select department AS resultid,COUNT(id) AS resultcount from Prj_Projectinfo  group by department order by resultcount 
GO

 CREATE PROCEDURE Prj_SearchMould_Delete 
 (@id_1 	[int], @flag integer output, @msg varchar(80) output )  AS DELETE [Prj_SearchMould]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_SearchMould_Insert 
 (@mouldname_1 	[varchar](200), @userid_2 	[int], @prjid_3 	[varchar](60), @status_4 	[varchar](60), @prjtype_5 	[varchar](60), @worktype_6 	[int], @nameopt_7 	[int], @name_8 	[varchar](60), @description_9 	[varchar](250), @customer_10 	[int], @parent_11 	[int], @securelevel_12 	[int], @department_13 	[int], @manager_14 	[int], @member_15 	[int], @flag integer output, @msg varchar(80) output )  AS INSERT INTO [Prj_SearchMould] ( [mouldname], [userid], [prjid], [status], [prjtype], [worktype], [nameopt], [name], [description], [customer], [parent], [securelevel], [department], [manager], [member])  VALUES ( @mouldname_1, @userid_2, @prjid_3, @status_4, @prjtype_5, @worktype_6, @nameopt_7, @name_8, @description_9, @customer_10, @parent_11, @securelevel_12, @department_13, @manager_14, @member_15) select max(id) from [Prj_SearchMould] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_SearchMould_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from Prj_SearchMould where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE Prj_SearchMould_SelectByUserID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from  Prj_SearchMould where userid =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE Prj_SearchMould_Update  
 (@id_1 	[int], @userid_2 	[int], @prjid_3 	[varchar](60), @status_4 	[varchar](60), @prjtype_5 	[varchar](60), @worktype_6 	[int], @nameopt_7 	[int], @name_8 	[varchar](60), @description_9 	[varchar](250), @customer_10 	[int], @parent_11 	[int], @securelevel_12 	[int], @department_13 	[int], @manager_14 	[int], @member_15 	[int], @flag integer output, @msg varchar(80) output )  AS UPDATE [Prj_SearchMould]  SET  [userid]	 = @userid_2, [prjid]	 = @prjid_3, [status]	 = @status_4, [prjtype]	 = @prjtype_5, [worktype]	 = @worktype_6, [nameopt]	 = @nameopt_7, [name]	 = @name_8, [description]	 = @description_9, [customer]	 = @customer_10, [parent]	 = @parent_11, [securelevel]	 = @securelevel_12, [department]	 = @department_13, [manager]	 = @manager_14, [member]	 = @member_15  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE Prj_ShareInfo_Delete 
  (@id int, @flag integer output, @msg varchar(80) output )  
  AS 
  DELETE from Prj_ShareInfo  WHERE ( id = @id)  
  set @flag=1 set @msg='ok'
 
GO

 CREATE PROCEDURE Prj_ShareInfo_Insert 
  (@relateditemid int, @sharetype tinyint, @seclevel  tinyint, @rolelevel tinyint, @sharelevel tinyint, @userid int, @departmentid int, @roleid int, @foralluser tinyint, @flag integer output, @msg varchar(80) output )  
  AS 
  INSERT INTO Prj_ShareInfo 
  ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser )  
  VALUES 
  ( @relateditemid , @sharetype , @seclevel , @rolelevel , @sharelevel, @userid, @departmentid, @roleid, @foralluser  ) 
  set @flag=1 set @msg='ok'  

GO

 CREATE PROCEDURE Prj_ShareInfo_SbyRelateditemid 
  (@relateditemid int , @flag integer output , @msg varchar(80) output )
  AS 
  select * from Prj_ShareInfo where ( relateditemid = @relateditemid ) order by sharetype
  set  @flag = 1 set  @msg = 'ok'
 
GO

 CREATE PROCEDURE Prj_ShareInfo_SelectbyID 
  (@id int , @flag integer output , @msg varchar(80) output )
  AS 
  select * from Prj_ShareInfo where (id = @id ) 
  set  @flag = 1 set  @msg = 'ok'
 
GO

 CREATE PROCEDURE Prj_TaskInfo_Approve 
 (@prjid [int], @version [tinyint], @isactived [tinyint], @flag integer output, @msg varchar(80) output )  AS 
UPDATE [Prj_TaskInfo]  SET [isactived]	 = @isactived  WHERE ( [prjid]	 = @prjid and [version]	 = @version ) 
if @isactived='2' 
begin
UPDATE [Prj_TaskProcess]  SET [isactived]	 = '1', [version]=@version  WHERE ( [prjid]	 = @prjid and [isactived]	 = '3'  )
UPDATE [Prj_TaskProcess]  SET [isactived]	 = '2', [version]=@version  WHERE ( [prjid]	 = @prjid and [isactived]	 <> '1'  )
UPDATE [Prj_MemberProcess]  SET [isactived]	 = '2'  WHERE ( [prjid]	 = @prjid and [isactived]	 = '0'  )
UPDATE [Prj_ToolProcess]  SET [isactived]	 = '2'  WHERE ( [prjid]	 = @prjid and [isactived]	 = '0'  )
UPDATE [Prj_MaterialProcess]  SET [isactived]	 = '2'  WHERE ( [prjid]	 = @prjid and [isactived]	 = '0'  )
update [Prj_MemberProcess] set isactived='1'  WHERE ( [prjid]	 = @prjid and [isactived]='3'  )  
update [Prj_ToolProcess] set isactived='1'  WHERE ( [prjid]	 = @prjid and [isactived]='3'  )  
update [Prj_MaterialProcess] set isactived='1'  WHERE ( [prjid]	 = @prjid and [isactived]='3'  )  

end
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_TaskInfo_DeleteByID 
 (@id 	[int], @prjid [int], @version [varchar] (10), @taskid [int] , @flag integer output, @msg varchar(80) output )  AS 
delete [Prj_TaskInfo]  WHERE ( [id]	 = @id)  
update [Prj_TaskProcess] set isactived='3'  WHERE ( [prjid]	 = @prjid and [taskid] = @taskid and [version]<>@version  )  
delete [Prj_TaskProcess] WHERE ( [prjid] = @prjid  and [taskid] = @taskid and version=@version ) 
update [Prj_Member] set version=replace(version, '|'+@version+'|', '')  WHERE ( [prjid]	 = @prjid and [taskid] = @taskid  )  
delete [Prj_Member] WHERE ( [prjid] = @prjid  and [taskid] = @taskid and version='' )  
update [Prj_Tool] set version=replace(version, '|'+@version+'|', '')  WHERE ( [prjid]	 = @prjid and [taskid] = @taskid )  
delete [Prj_Tool] WHERE ( [prjid]	 = @prjid  and [taskid] = @taskid and version='' ) 
update [Prj_Material] set version=replace(version, '|'+@version+'|', '')  WHERE ( [prjid]	 = @prjid and [taskid] = @taskid )  
delete [Prj_Material] WHERE ( [prjid]	 = @prjid  and [taskid] = @taskid and version='' )  
delete [Prj_MemberProcess] WHERE ( [prjid] = @prjid  and [taskid] = @taskid and isactived='0' )  
update [Prj_MemberProcess] set isactived='3'  WHERE ( [prjid]	 = @prjid and [taskid] = @taskid and [isactived]<>'1'  )  
delete [Prj_ToolProcess] WHERE ( [prjid] = @prjid  and [taskid] = @taskid and isactived='0' ) 
update [Prj_ToolProcess] set isactived='3'  WHERE ( [prjid]	 = @prjid and [taskid] = @taskid and [isactived]<>'1'  )  
delete [Prj_MaterialProcess] WHERE ( [prjid] = @prjid  and [taskid] = @taskid and isactived='0' ) 
update [Prj_MaterialProcess] set isactived='3'  WHERE ( [prjid]	 = @prjid and [taskid] = @taskid and [isactived]<>'1'  )  
set @flag=1 set @msg='ok'  

GO

 CREATE PROCEDURE Prj_TaskInfo_DeleteByVesion 
 (@prjid [int], @version [varchar] (10), @flag integer output, @msg varchar(80) output )  AS 
delete [Prj_TaskInfo]  WHERE ( [prjid]	 = @prjid and [version]	 = @version ) 
delete [Prj_TaskProcess]  WHERE ( [prjid]	 = @prjid and [version]	 = @version ) 
update [Prj_TaskProcess] set isactived='2'  WHERE ( [prjid]	 = @prjid and [version]<>@version  and isactived <> '1' ) 
update [Prj_Member] set version=replace(version, '|'+@version+'|', '')  WHERE ( [prjid]	 = @prjid and [version]	 like  '%' + '|'+@version+'|' + '%' )  
delete [Prj_Member] WHERE ( [prjid]	 = @prjid and version='' )  
update [Prj_Tool] set version=replace(version, '|'+@version+'|', '')  WHERE ( [prjid]	 = @prjid and [version]	 like  '%' + '|'+@version+'|' + '%' )  
delete [Prj_Tool] WHERE ( [prjid]	 = @prjid and version='' ) 
update [Prj_Material] set version=replace(version, '|'+@version+'|', '')  WHERE ( [prjid]	 = @prjid and [version]	 like  '%' + '|'+@version+'|' + '%' )  
delete [Prj_Material] WHERE ( [prjid]	 = @prjid and version='' ) 
delete [Prj_MemberProcess] WHERE ( [prjid] = @prjid  and isactived='0' )  
delete [Prj_ToolProcess] WHERE ( [prjid] = @prjid   and isactived='0' ) 
delete [Prj_MaterialProcess] WHERE ( [prjid] = @prjid  and isactived='0' ) 
update [Prj_MemberProcess] set isactived='2'  WHERE ( [prjid]	 = @prjid and [isactived]='3'  )  
update [Prj_ToolProcess] set isactived='2'  WHERE ( [prjid]	 = @prjid and [isactived]='3'  )  
update [Prj_MaterialProcess] set isactived='2'  WHERE ( [prjid]	 = @prjid and [isactived]='3'  )  
set @flag=1 set @msg='ok'  

GO

 CREATE PROCEDURE Prj_TaskInfo_Insert 
 (@prjid 	[int], @taskid 	[int],  @wbscoding 	[varchar](20), @subject 	[varchar](80) , @version 	[tinyint], @begindate 	[varchar](10), @enddate 	[varchar](10), @workday [decimal] (10,1), @content 	[varchar](255), @fixedcost [decimal] (10,2),  @flag integer output, @msg varchar(80) output  )  AS 
INSERT INTO [Prj_TaskInfo] ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost)  VALUES ( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate, @workday, @content, @fixedcost) 
INSERT INTO [Prj_TaskProcess] ( prjid, taskid ,  version, begindate, enddate )  VALUES ( @prjid, @taskid ,  @version, 'x', '-') 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_TaskInfo_NewPlan 
(@prjid 	[int],  
 @oldversion [varchar] (10), 
 @newversion [varchar] (10),
 @flag integer output, 
 @msg varchar(80) output  )  
 AS 
 declare	@taskid 	[int], 
		@wbscoding 	[varchar](20), 
		@subject 	[varchar](50), 
		@version 	[tinyint], 
		@begindate 	[varchar](10), 
		@enddate 	[varchar](10), 
		@workday        [decimal] (10,1), 
		@content 	[varchar](255), 
		@fixedcost	[decimal](10,2),
		@temp		[tinyint],
		@all_cursor	cursor
select @temp=max(version) from prj_taskinfo where prjid=@prjid
set @version=@temp+1
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR	
select  taskid , wbscoding, subject , begindate, enddate, workday, content, fixedcost from [Prj_TaskInfo] where prjid = @prjid and version=@temp
OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate,
	@workday,@content,@fixedcost
WHILE @@FETCH_STATUS = 0 
begin 
	INSERT INTO [Prj_TaskInfo] ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost)  VALUES ( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate, @workday, @content, @fixedcost)
	FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate,
	@workday,@content,@fixedcost
end 
CLOSE @all_cursor DEALLOCATE @all_cursor  
update [Prj_Member] set version = version +  @newversion   WHERE ([prjid] = @prjid  and [version] like '%' + @oldversion + '%' )
update [Prj_Tool] set version = version +  @newversion   WHERE ([prjid] = @prjid  and [version] like '%' + @oldversion + '%' )
update [Prj_Material] set version = version +  @newversion   WHERE ([prjid] = @prjid  and [version] like '%' + @oldversion + '%' )

GO

 CREATE PROCEDURE Prj_TaskInfo_SelectAll 
 (@prjid [int], @version [tinyint], @level_n [tinyint], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_TaskInfo] WHERE ( [prjid]	 = @prjid and [version]	 = @version and [level_n] <= @level_n and isdelete<>'1') order by parentids  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskInfo_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_TaskInfo] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskInfo_SelectMaxID 
 (@prjid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT max(taskid) FROM [Prj_TaskInfo] WHERE ( [prjid]	 = @prjid ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskInfo_SelectMaxVersion 
 (@prjid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT top 1 isactived, version FROM [Prj_TaskInfo] WHERE ( [prjid]	 = @prjid ) order by version desc set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskInfo_Sum 
 (@prjid [int], @version [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT sum(workday) as workday, min(begindate) as begindate, max(enddate) as enddate FROM [Prj_TaskInfo] WHERE ( prjid = @prjid and parentid = '0' and version = @version  and isdelete<>'1') set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskInfo_SumCostMaterial 
 (@prjid [int], @version [varchar] (10), @wbscoding [varchar](20), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT sum(t2.quantity*t2.cost) as cost FROM [Prj_TaskInfo] as t1, [Prj_Material] as t2 WHERE ( t1.prjid	 = @prjid and t1.version	 = @version and  t1.wbscoding like @wbscoding+'%' and t1.taskid = t2.taskid and t2.prjid = @prjid  and t2.version like '%|' + @version + '|%' ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskInfo_SumCostMember 
 (@prjid [int], @version [varchar] (10), @wbscoding [varchar](20), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT sum(t2.workday*t2.cost) as cost FROM [Prj_TaskInfo] as t1, [Prj_Member] as t2 WHERE ( t1.prjid	 = @prjid and t1.version	 = @version and  t1.wbscoding like @wbscoding+'%' and t1.taskid = t2.taskid and t2.prjid = @prjid  and t2.version like '%|' + @version + '|%' ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskInfo_SumCostTool 
 (@prjid [int], @version [varchar] (10), @wbscoding [varchar](20), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT sum(t2.workday*t2.cost) as cost FROM [Prj_TaskInfo] as t1, [Prj_Tool] as t2 WHERE ( t1.prjid	 = @prjid and t1.version	 = @version and  t1.wbscoding like @wbscoding+'%' and t1.taskid = t2.taskid and t2.prjid = @prjid  and t2.version like '%|' + @version + '|%' ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskInfo_Update 
 (@id	[int], @wbscoding [varchar](20), @subject 	[varchar](80) , @begindate 	[varchar](10), @enddate 	[varchar](10), @workday [decimal] (10,1), @content 	[varchar](255), @fixedcost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS UPDATE [Prj_TaskInfo]  SET  wbscoding = @wbscoding, subject = @subject , begindate = @begindate, enddate = @enddate 	, workday = @workday, content = @content, fixedcost = @fixedcost  WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskProcess_DeleteByID 
 (@id varchar(10), @flag integer output, @msg varchar(80) output )  AS 
update [Prj_TaskProcess] set isdelete='1'  WHERE ( [id]	 = @id or ','+parentids like  '%,'+@id+',%') 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_TaskProcess_Insert 
 (@prjid 	[int], @taskid 	[int],  @wbscoding 	[varchar](20), @subject 	[varchar](80) , @version 	[tinyint], @begindate 	[varchar](10), @enddate 	[varchar](10), @workday [decimal] (10,1), @content 	[varchar](255), @fixedcost [decimal] (10,2), @parentid [int], @parentids [varchar] (255), @parenthrmids [varchar] (255), @level_n [tinyint], @hrmid [int],  @flag integer output, @msg varchar(80) output  ) 
AS 
INSERT INTO [Prj_TaskProcess] ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid)  
VALUES 
( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid) 
Declare @id int, @maxid varchar(10), @maxhrmid varchar(255)
select @id = max(id) from Prj_TaskProcess 
set @maxid = convert(varchar(10), @id) + ','
set @maxhrmid = '|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
update Prj_TaskProcess set parentids=parentids+@maxid, parenthrmids=parenthrmids+@maxhrmid  where id=@id
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_TaskProcess_SelectAll 
 (@prjid [int], @level_n [tinyint], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_TaskProcess] WHERE ( [prjid]	 = @prjid and  [level_n] <= @level_n and isdelete<>'1') order by parentids  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskProcess_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_TaskProcess] WHERE ( id	 = @id ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskProcess_Sum 
 (@prjid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT sum(workday) as workday, min(begindate) as begindate, max(enddate) as enddate, convert(int,sum(finish*workday)/sum(workday)) as finish FROM [Prj_TaskProcess] WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_TaskProcess_Update 
 (@id	[int], @wbscoding [varchar](20), @subject 	[varchar](80) , @begindate 	[varchar](10), @enddate 	[varchar](10), @workday [decimal] (10,1), @content 	[varchar](255), @fixedcost [decimal] (10,2), @hrmid [int], @oldhrmid [int], @finish [tinyint], @flag integer output, @msg varchar(80) output )  AS 
UPDATE [Prj_TaskProcess]  SET  wbscoding = @wbscoding, subject = @subject , begindate = @begindate, enddate = @enddate 	, workday = @workday, content = @content, fixedcost = @fixedcost, hrmid = @hrmid, finish = @finish  WHERE ( [id]	 = @id) 
if @hrmid<>@oldhrmid
begin
Declare @currenthrmid varchar(255), @currentoldhrmid varchar(255)
set @currenthrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
set @currentoldhrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @oldhrmid) + '|'
UPDATE [Prj_TaskProcess] set parenthrmids=replace(parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%')
end
set @flag = 1 set @msg = 'OK!'
GO

 CREATE PROCEDURE Prj_TaskProcess_UpdateParent 
 (@parentid	[int], @flag integer output, @msg varchar(80) output )  AS 
Declare @begindate [varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @finish [int] 
select @begindate = min(begindate), @enddate = max(enddate), @workday = sum(workday), @finish = convert(int,sum(workday*finish)/sum(workday)) from Prj_TaskProcess where parentid=@parentid
UPDATE [Prj_TaskProcess]  SET   begindate = @begindate, enddate = @enddate, workday = @workday, finish = @finish  WHERE ( [id] = @parentid) 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_ToolProcess_Delete 
 (@id [int],  @flag integer output, @msg varchar(80) output )  AS update [Prj_ToolProcess] set [isactived] = '1'  WHERE ( [id] = @id)    set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_ToolProcess_Insert 
 (@prjid 	[int], @taskid [int], @relateid 	[int],  @isactived [tinyint], @begindate 	[varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS INSERT INTO [Prj_ToolProcess] ( [prjid], [taskid], [relateid], [isactived], [begindate], [enddate], [workday], [cost])  VALUES ( @prjid , @taskid , @relateid , @isactived , @begindate, @enddate, @workday, @cost ) set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_ToolProcess_Update 
  (@id [int],  @relateid 	[int],  @begindate 	[varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
update [Prj_ToolProcess] set relateid=@relateid, begindate=@begindate, enddate=@enddate, workday=@workday, cost=@cost  WHERE ( [id] = @id)  
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Tool_Delete 
 (@id [int], @version [varchar] (10), @flag integer output, @msg varchar(80) output )  AS update [Prj_Tool] set version=replace(version, @version, '')  WHERE ( [id] = @id) delete [Prj_Tool] WHERE ( [id] = @id and version='' )  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Tool_Insert 
 (@prjid 	[int], @taskid [int], @relateid 	[int], @version [varchar] (10), @begindate 	[varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
INSERT INTO [Prj_Tool] ( [prjid], [taskid], [relateid], [version], [begindate], [enddate], [workday], [cost])  VALUES ( @prjid , @taskid , @relateid 	, @version, @begindate, @enddate, @workday, @cost ) 
INSERT INTO [Prj_ToolProcess] ( [prjid], [taskid], [relateid], [isactived])  VALUES ( @prjid , @taskid , @relateid , '0') 
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_Tool_SelectAllPlan 
 (@prjid [int], @version [varchar] (10), @relateid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT t1.*,t2.wbscoding,t2.subject,t2.id as taskrecordid FROM [Prj_Tool] as t1, [Prj_TaskInfo] as t2 WHERE ( t1.prjid	 = @prjid and t1.version like '%|' + @version + '|%' and t1.relateid = @relateid and t2.prjid	 = @prjid and t2.version = @version  and t1.taskid=t2.taskid ) order by t2.wbscoding  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Tool_SelectAllProcess 
 (@prjid [int], @relateid [int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT t1.*,t3.wbscoding,t3.subject,t2.id as taskrecordid FROM [Prj_toolProcess] as t1, [Prj_TaskProcess] as t2 , [Prj_TaskInfo] as t3 WHERE ( t1.prjid	 = @prjid and ( t1.isactived = '2' or t1.isactived = '3' ) and t1.relateid = @relateid and t2.prjid	 = @prjid and ( t2.isactived = '2' or t2.isactived = '3' )  and t1.taskid=t2.taskid and t3.prjid = @prjid and t3.taskid = t2.taskid and t3.version =t2.version ) order by t3.wbscoding  set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Tool_SumPlan 
 (@prjid [int], @version [varchar] (10), @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT relateid, sum(workday) as workday, min(begindate) as begindate, max(enddate) as enddate, sum(cost*workday) as cost FROM [Prj_Tool] WHERE ( prjid	 = @prjid and version like '%|' + @version + '|%' ) group by relateid set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Tool_SumProcess 
 (@prjid [int],  @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT relateid, sum(workday) as workday, min(begindate) as begindate, max(enddate) as enddate, sum(cost*workday) as cost FROM [Prj_ToolProcess] WHERE ( prjid	 = @prjid and ( isactived = '2' or isactived = '3' )  ) group by relateid set @flag = 1 set @msg = 'OK!' 

GO

 CREATE PROCEDURE Prj_Tool_Update 
 (@id [int], @version [varchar] (10), @prjid 	[int], @taskid [int], @relateid 	[int], @begindate 	[varchar](10), @enddate [varchar](10), @workday [decimal] (10,1), @cost [decimal] (10,2), @flag integer output, @msg varchar(80) output )  AS 
update [Prj_Tool] set version=replace(version, @version, '')  WHERE ( [id] = @id) delete [Prj_Tool] WHERE ( [id] = @id and version='' )  
INSERT INTO [Prj_Tool] ( [prjid], [taskid], [relateid], [version], [begindate], [enddate], [workday], [cost])  VALUES ( @prjid , @taskid , @relateid 	, @version, @begindate, @enddate, @workday, @cost )
set @flag = 1 set @msg = 'OK!'

GO

 CREATE PROCEDURE Prj_ViewLog1_Insert 
 @id	int, @viewer	int, @submitertype 	[tinyint], @viewdate	char(10), @viewtime	char(8), @ipaddress	char(15), @flag integer output , @msg varchar(80) output AS insert into Prj_viewLog1 (id, viewer, submitertype, viewdate, viewtime, ipaddress) values(@id, @viewer, @submitertype, @viewdate, @viewtime, @ipaddress) 

GO

 CREATE PROCEDURE Prj_WorkType_Delete 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS DELETE [Prj_WorkType]  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_WorkType_Insert 
 (@fullname_1 	[varchar](50), @description_2 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_WorkType] ( [fullname], [description])  VALUES ( @fullname_1, @description_2)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_WorkType_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_WorkType] set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_WorkType_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_WorkType] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE Prj_WorkType_Update 
 (@id	 	[int], @fullname 	[varchar](50), @description 	[varchar](150), @flag	[int]	output, @msg	[varchar](80)	output)  AS UPDATE [Prj_WorkType]  SET  [fullname]	 = @fullname, [description]	 = @description  WHERE ( [id]	 = @id)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE ProcedureInfo_Delete 
 (@id_1  		[int], @flag                             integer output, @msg                             varchar(80) output )  AS DELETE [ProcedureInfo]  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='删除储存过程失败' return end else begin set @flag=0 set @msg='删除储存过程成功' return end 
GO

 CREATE PROCEDURE ProcedureInfo_Insert 
 (@procedurename_1 	[varchar](100), @proceduretabel_2 	[varchar](200), @procedurescript_3 	[text], @proceduredesc_4 	[text], @flag                             integer output, @msg                             varchar(80) output ) AS INSERT INTO [ProcedureInfo] ( [procedurename], [proceduretabel], [procedurescript], [proceduredesc])  VALUES ( @procedurename_1, @proceduretabel_2, @procedurescript_3, @proceduredesc_4) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 CREATE PROCEDURE ProcedureInfo_Select 
 @procedurename varchar(100) , @flag integer output , @msg varchar(80) output AS select * from ProcedureInfo where procedurename like @procedurename set  @flag = 0 set  @msg = '操作成功完成' 
GO

 CREATE PROCEDURE ProcedureInfo_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from ProcedureInfo where id =convert(int, @id) set  @flag = 0 set  @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE ProcedureInfo_Update 
 (@id_1 	[int], @procedurename_2 	[varchar](100), @proceduretabel_3 	[varchar](200), @procedurescript_4 	[text], @proceduredesc_5 	[text], @flag                             integer output, @msg                             varchar(80) output )  AS UPDATE [ProcedureInfo]  SET  [procedurename]	 = @procedurename_2, [proceduretabel]	 = @proceduretabel_3, [procedurescript]	 = @procedurescript_4, [proceduredesc]	 = @proceduredesc_5  WHERE ( [id]	 = @id_1)  if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO

 CREATE PROCEDURE RoleRightdetailInfo_Select 
 (@flag int output, @msg varchar(80) output)  AS select roleid , rightdetail , rolelevel from SystemRightDetail, SystemRightRoles where SystemRightDetail.rightid = SystemRightRoles.rightid order by roleid 
GO

 CREATE PROCEDURE SequenceIndex_SelectNextID 
	(@indexdesc_1 	[varchar](60),
	 @flag integer output,
	 @msg varchar(80) output)

AS
declare @currentid_1 integer
select @currentid_1 = currentid from SequenceIndex where indexdesc = @indexdesc_1
update SequenceIndex set currentid = currentid+1 where indexdesc= @indexdesc_1
select @currentid_1

GO

 CREATE PROCEDURE SequenceIndex_Sub 
 (@indexdesc_1 	[varchar](30),
 @flag integer output, @msg varchar(80) output)
 AS  UPDATE [SequenceIndex]  
SET  [currentid]	 = currentid-1 
 WHERE ( [indexdesc]	 = @indexdesc_1)   select currentid  from SequenceIndex where ( [indexdesc]	 = @indexdesc_1)
GO

 CREATE PROCEDURE SequenceIndex_Update 
 (@indexdesc_1 	[varchar](30), @flag integer output, @msg varchar(80) output) AS  UPDATE [SequenceIndex]  SET  [currentid]	 = currentid+1  WHERE ( [indexdesc]	 = @indexdesc_1)   select currentid  from SequenceIndex where ( [indexdesc]	 = @indexdesc_1) 
GO

 CREATE PROCEDURE SysFavourite_DeleteByID 
	(@id 		int,
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	delete from sysfavourite where id=@id

GO

 CREATE PROCEDURE SysFavourite_Insert 
 (@Resourceid [int], @Adddate [char](10), @Addtime [char](8), @Pagename    [varchar](150), @URL     [varchar](100), @flag [int]  output, @msg  [varchar](80) output) AS declare    @totalcount   int select @totalcount=count(*) from sysfavourite where resourceid=@resourceid if @totalcount>14 begin delete from sysfavourite where resourceid=@resourceid and adddate=(select top 1 adddate from sysfavourite where resourceid=@resourceid order by adddate) and addtime=(select top 1 addtime from sysfavourite where resourceid=@resourceid order by adddate,addtime) end  INSERT INTO [SysFavourite] ( [Resourceid], [Adddate], [Addtime], [Pagename], [URL]) VALUES ( @Resourceid, @Adddate, @Addtime, @Pagename, @URL) 
GO

 CREATE PROCEDURE SysFavourite_SelectByUserID 
 (@Resourceid [int], @flag [int]  output, @msg  [varchar](80) output) as select * from sysfavourite where resourceid in (@resourceid,0) order by resourceid,adddate desc,addtime desc 
GO

 CREATE PROCEDURE SysFavourite_Update 
 (@id_1 	[int], @pagename_1   [varchar](100), @flag   integer output, @msg   varchar(80) output ) 
AS 
UPDATE [sysfavourite]  SET  [pagename]	 = @pagename_1  WHERE ( [id] = @id_1)  if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end


GO








 CREATE PROCEDURE SysRemindInfo_DeleteHasendwf 
@userid		int,
@usertype	int,
@requestid	int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmp varchar(255)
  
  select @tmp = convert(varchar,hasendwf) from SysRemindInfo where userid = @userid and usertype = @usertype
  if @tmp is not null 
  begin
	 set  @tmp = Replace(','+@tmp+',',','+convert(varchar,@requestid)+',',',')
	  if LEN(@tmp) < 2 
	begin 
		 set  @tmp = ''

	end
	else
	begin
	 	set  @tmp = SUBSTRING(@tmp,2,LEN(@tmp)-2)
	end
	  update SysRemindInfo set hasendwf = @tmp where userid = @userid and usertype = @usertype
  end  

GO

 CREATE PROCEDURE SysRemindInfo_DeleteHasnewwf 
@userid		int,
@usertype	int,
@requestid	int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmp varchar(255)
  
  select @tmp = convert(varchar,hasnewwf) from SysRemindInfo where userid = @userid and usertype = @usertype
  if @tmp is not null 
  begin
	 set  @tmp = Replace(','+@tmp+',',','+convert(varchar,@requestid)+',',',')
	 if LEN(@tmp) < 2 
	begin 
		 set  @tmp = ''

	end
	else
	begin
	 	set  @tmp = SUBSTRING(@tmp,2,LEN(@tmp)-2)
	end
	 update SysRemindInfo set hasnewwf = @tmp where userid = @userid and usertype = @usertype
  end  

GO

 CREATE PROCEDURE SysRemindInfo_IPasstimeNode 
@userid		int,
@usertype	int,
@haspasstimenode int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmpid integer 
  select @tmpid = userid from SysRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysRemindInfo(userid,usertype,haspasstimenode) values(@userid,@usertype,@haspasstimenode)
  end
  else
  begin
  update SysRemindInfo set haspasstimenode = @haspasstimenode where userid = @userid and usertype = @usertype
  end
  

GO

 CREATE PROCEDURE SysRemindInfo_InserCrmcontact 
@userid		int,
@usertype	int,
@hascrmcontact int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmpid integer 
  select @tmpid = userid from SysRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysRemindInfo(userid,usertype,hascrmcontact) values(@userid,@usertype,@hascrmcontact)
  end
  else
  begin
  update SysRemindInfo set hascrmcontact = @hascrmcontact where userid = @userid and usertype = @usertype
  end
  

GO

 CREATE PROCEDURE SysRemindInfo_InserDealwf 
@userid		int,
@usertype	int,
@hasdealwf int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmpid integer 
  select @tmpid = userid from SysRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysRemindInfo(userid,usertype,hasdealwf) values(@userid,@usertype,@hasdealwf)
  end
  else
  begin
  update SysRemindInfo set hasdealwf = @hasdealwf where userid = @userid and usertype = @usertype
  end
  

GO

 CREATE PROCEDURE SysRemindInfo_InserHasendwf 
@userid		int,
@usertype	int,
@requestid	int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmpid integer 
   declare @tmp varchar(255)
  select @tmpid = userid,@tmp=convert(varchar,hasendwf) from SysRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysRemindInfo(userid,usertype,hasendwf) values(@userid,@usertype,convert(varchar,@requestid))
  end
  else
  begin
  if @tmp = '' or @tmp is null
  begin
  update SysRemindInfo set hasendwf = convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  else if CHARINDEX(','+@tmp+',',','+convert(varchar,@requestid)+',')=0
  begin
  update SysRemindInfo set hasendwf = convert(varchar,hasendwf)+','+convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  end
  

GO

 CREATE PROCEDURE SysRemindInfo_InserHasnewwf 
@userid		int,
@usertype	int,
@requestid	int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmpid integer 
   declare @tmp varchar(255)
  select @tmpid = userid,@tmp=convert(varchar,hasnewwf) from SysRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysRemindInfo(userid,usertype,hasnewwf) values(@userid,@usertype,convert(varchar,@requestid))
  end
  else
  begin
  if @tmp = '' or @tmp is null
  begin
  update SysRemindInfo set hasnewwf = convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  else if CHARINDEX(','+@tmp+',',','+convert(varchar,@requestid)+',')=0
  begin
  update SysRemindInfo set hasnewwf = convert(varchar,hasnewwf)+','+convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  end
  

GO

 CREATE PROCEDURE Sys_Slogan_Select 
 (@flag                             integer output, @msg                             varchar(80) output )  AS select * from Sys_Slogan 
GO

 CREATE PROCEDURE Sys_Slogan_Update 
 (@slogan 	[varchar](255), @speed 	[tinyint], @fontcolor 	[char](6), @backcolor 	[char](6), @flag                             integer output, @msg                             varchar(80) output )  AS UPDATE [Sys_Slogan]  SET  [slogan]	 = @slogan, [speed]	 = @speed, [fontcolor]	 = @fontcolor, [backcolor]	 = @backcolor 
GO

 CREATE PROCEDURE SystemLogItem_Delete 
 (@itemid_1 	[varchar](3), @flag                             integer output, @msg                             varchar(80) output )  AS DELETE [SystemLogItem]  WHERE ( [itemid]	 = @itemid_1) 
GO

 CREATE PROCEDURE SystemLogItem_Insert 
 (@itemid_1 	[varchar](3), @lableid_2 	[int], @itemdesc_3 	[varchar](40), @flag                             integer output, @msg                             varchar(80) output )  AS INSERT INTO [SystemLogItem] ( [itemid], [lableid], [itemdesc])  VALUES ( @itemid_1, @lableid_2, @itemdesc_3) 
GO

 CREATE PROCEDURE SystemLogItem_Select 
 @itemdesc varchar(40) , @flag integer output , @msg varchar(80) output AS select itemid, itemdesc from SystemLogItem where itemdesc like @itemdesc order by convert(int,itemid) set  @flag = 0 set  @msg = '查询日志项目信息成功' 
GO

 CREATE PROCEDURE SystemLogItem_SelectByID 
 @id varchar(3) , @flag integer output , @msg varchar(80) output AS select * from SystemLogItem where itemid = @id set  @flag = 0 set  @msg = '查询日志项目信息成功' 
GO

 CREATE PROCEDURE SystemLogItem_Update 
 (@itemid_1 	[varchar](3), @lableid_2 	[int], @itemdesc_3 	[varchar](40), @flag                             integer output, @msg                             varchar(80) output )  AS UPDATE [SystemLogItem]  SET  	 [lableid]	 = @lableid_2, [itemdesc]	 = @itemdesc_3  WHERE ( [itemid]	 = @itemid_1 ) 
GO

 CREATE PROCEDURE SystemLog_Delete 
 (@createdate_1 	[char](10), @flag int output, @msg varchar(80) output)  AS delete SystemLog where createdate <= @createdate_1 
GO

 CREATE PROCEDURE SystemLog_Insert 
 (@createdate_1 	[char](10), @createtime_2 	[char](7), @classname  varchar(30) , @sqlstr_3 	[text], @flag int output, @msg varchar(80) output)  AS INSERT INTO [SystemLog] ( [createdate], [createtime], classname, [sqlstr])  VALUES ( @createdate_1, @createtime_2, @classname , @sqlstr_3) 
GO

 CREATE PROCEDURE SystemRightDetail_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [SystemRightDetail]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE SystemRightDetail_Insert 
 (@rightdetailname_1 	[varchar](100), @rightdetail_2 	[varchar](100), @rightid_3 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [SystemRightDetail] ( [rightdetailname], [rightdetail], [rightid])  VALUES ( @rightdetailname_1, @rightdetail_2, @rightid_3) 
GO

 CREATE PROCEDURE SystemRightDetail_SByRightID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from SystemRightDetail where rightid = @id set  @flag = 0 set  @msg = '查询系统权限详细成功' 
GO

 CREATE PROCEDURE SystemRightDetail_Select 
 @rightdetailname varchar(100) , @flag integer output , @msg varchar(80) output AS select * from SystemRightDetail where rightdetailname like @rightdetailname set  @flag = 0 set  @msg = '查询系统权限详细成功' 
GO

 CREATE PROCEDURE SystemRightDetail_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from SystemRightDetail where id = @id set  @flag = 0 set  @msg = '查询系统权限详细成功' 
GO

 CREATE PROCEDURE SystemRightDetail_Update 
 (@id_1 	[int], @rightdetailname_2 	[varchar](100), @rightdetail_3 	[varchar](100), @rightid_4 	[int], @flag integer output , @msg varchar(80) output)  AS UPDATE [SystemRightDetail]  SET  [rightdetailname]	 = @rightdetailname_2, [rightdetail]	 = @rightdetail_3, [rightid]	 = @rightid_4  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE SystemRightGroup_Delete 
 @id int, @flag int output, @msg varchar(80) output as select rightgroupname from SystemRightGroups where id=@id delete SystemRightGroups where id=@id delete SystemRightToGroup where groupid=@id set @flag=0 set @msg='操作成功' select @flag,@msg 
GO

 CREATE PROCEDURE SystemRightGroup_Update 
 @id int, @mark varchar(60), @description varchar(200), @notes text, @flag int output, @msg varchar(80) output as begin update SystemRightGroups set rightgroupmark=@mark,rightgroupname=@description,rightgroupremark=@notes where id=@id if @@error=0 begin set @flag=0 set @msg='操作成功' end else begin set @flag=13 set @msg='修改记录失败' end select @flag ,@msg end 
GO

 CREATE PROCEDURE SystemRightGroup_sbygroupid 
 @id int, @flag int output, @msg varchar(80) output as begin select rightgroupmark,rightgroupname,rightgroupremark from systemrightgroups where id=@id end 
GO

 CREATE PROCEDURE SystemRightGroups_Insert 
 @mark varchar(60), @description varchar(200), @notes text, @flag int output, @msg varchar(200) output as begin insert systemrightgroups(rightgroupmark,rightgroupname,rightgroupremark) values(@mark,@description,@notes) select max(id) from systemrightgroups if @@error<>0 begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end select @flag,@msg end 
GO

 CREATE PROCEDURE SystemRightRoles_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [SystemRightRoles]  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE SystemRightRoles_Insert 
 (@rightid_1 	[int], @roleid_2 	[int], @rolelevel_3 	[char](1), @flag integer output , @msg varchar(80) output)  AS DECLARE @count integer select @count = count(id) from SystemRightRoles where rightid = @rightid_1 and roleid = @roleid_2  if @count =0 begin INSERT INTO [SystemRightRoles] ( [rightid], [roleid], [rolelevel])  VALUES ( @rightid_1, @roleid_2, @rolelevel_3) end else begin update SystemRightRoles set rolelevel = @rolelevel_3 where rightid = @rightid_1 and roleid = @roleid_2 end 
GO

 CREATE PROCEDURE SystemRightRoles_SByRightid 
 @id int , @flag integer output , @msg varchar(80) output AS select * from SystemRightRoles where rightid = @id set  @flag = 0 set  @msg = '查询系统权限角色成功' 
GO

 CREATE PROCEDURE SystemRightRoles_SelectByID 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output)  AS select * from SystemRightRoles where id = @id_1 
GO

 CREATE PROCEDURE SystemRightRoles_Update 
 (@id_1 	[int], @rolelevel_2 	[char](1), @flag integer output , @msg varchar(80) output)  AS UPDATE [SystemRightRoles]  SET  [rolelevel]	 = @rolelevel_2  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE SystemRightToGroup_Delete 
 (@groupid_1 	[int], @rightid_2 	[int], @flag integer output , @msg varchar(80) output)  AS DELETE [SystemRightToGroup]  WHERE ( [groupid]	 = @groupid_1) and ( [rightid]	 = @rightid_2) 
GO

 CREATE PROCEDURE SystemRightToGroup_Insert 
 (@groupid_1 	[int], @rightid_2 	[int], @flag integer output , @msg varchar(80) output)  AS declare @count integer select @count = count(id) from SystemRightToGroup where groupid = @groupid_1 and rightid = @rightid_2 if @count = 0 begin INSERT INTO [SystemRightToGroup] ( [groupid], [rightid])  VALUES ( @groupid_1, @rightid_2) end 
GO

 CREATE PROCEDURE SystemRight_selectRightGroup 
 @flag int output, @msg varchar(80) output as declare @id int,@groupname varchar(200),@count int create table #temp( id  int, groupname varchar(200), cnt int ) select @count=count(*) from SystemRights insert into #temp values(-1,'全部',@count)  declare right_cursor cursor for select id , rightgroupname from SystemRightGroups order by id  open right_cursor fetch next from right_cursor into @id,@groupname while @@fetch_status=0 begin select @count = count(rightid) from SystemRightToGroup where groupid= @id insert into #temp values(@id,@groupname,@count) fetch next from right_cursor into @id,@groupname end close right_cursor deallocate right_cursor  select id,groupname,cnt from #temp 
GO

 CREATE PROCEDURE SystemRightsLanguage_Insert 
 (@id_1 	[int], @languageid_2 	[int], @rightname_3 	[varchar](100), @rightdesc_4 	[varchar](100), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [SystemRightsLanguage] ( [id], [languageid], [rightname], [rightdesc])  VALUES ( @id_1, @languageid_2, @rightname_3, @rightdesc_4) 
GO

 CREATE PROCEDURE SystemRightsLanguage_SByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from SystemRightsLanguage where id = @id set  @flag = 0 set  @msg = '查询系统权限成功' 
GO

 CREATE PROCEDURE SystemRightsLanguage_SByIDLang 
 @id int , @languageid int , @flag integer output , @msg varchar(80) output AS select a.rightname, a.rightdesc, b.righttype from SystemRightsLanguage a, SystemRights b where a.id = @id and a.languageid = @languageid and a.id = b.id set  @flag = 0 set  @msg = '查询系统权限成功' 
GO

 CREATE PROCEDURE SystemRightsLanguage_Update 
 (@id_1 	[int], @languageid_2 	[int], @rightname_3 	[varchar](100), @rightdesc_4 	[varchar](100), @flag integer output , @msg varchar(80) output)  AS UPDATE [SystemRightsLanguage]  SET  [rightname]	 = @rightname_3, [rightdesc]	 = @rightdesc_4  WHERE ( [id]	 = @id_1 AND [languageid]	 = @languageid_2) 
GO

 CREATE PROCEDURE SystemRights_Delete 
 (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output )  AS Declare @count integer select @count = count(id) from SystemRightRoles where rightid = @id_1 if @count <> 0 return DELETE [SystemRights]  WHERE ( [id]	 = @id_1) DELETE [SystemRightsLanguage]  WHERE ( [id]	 = @id_1) DELETE [SystemRightToGroup]  WHERE ( [rightid] = @id_1) 
GO

 CREATE PROCEDURE SystemRights_Insert 
 ( @rightdesc_2 	[varchar](200), @righttype_3 	[char](1), @flag integer output , @msg varchar(80) output)  AS INSERT INTO [SystemRights] ( [rightdesc], [righttype])  VALUES (  @rightdesc_2, @righttype_3)  select max(id) from SystemRights 
GO

 CREATE PROCEDURE SystemRights_Select 
 @rightdesc varchar(100) , @flag integer output , @msg varchar(80) output AS select * from SystemRights where rightdesc like @rightdesc set  @flag = 0 set  @msg = '查询系统权限成功' 
GO

 CREATE PROCEDURE SystemRights_SelectAll 
  @flag int output, @msg varchar(80) output as begin select id,languageid,rightname  from systemrightslanguage order by id,languageid end 
GO

 CREATE PROCEDURE SystemRights_SelectAllID 
 @flag integer output , @msg varchar(80) output AS select id from SystemRights set  @flag = 0 set  @msg = '查询系统权限成功' 
GO

 CREATE PROCEDURE SystemRights_SelectByID 
 @id varchar(100) , @flag integer output , @msg varchar(80) output AS select * from SystemRights where id = @id set  @flag = 0 set  @msg = '查询系统权限成功' 
GO

 CREATE PROCEDURE SystemRights_Update 
 (@id_1 	[int], @rightdesc_2 	[varchar](200), @righttype_3 	[char](1), @flag integer output , @msg varchar(80) output)  AS UPDATE [SystemRights]  SET  [rightdesc]	 = @rightdesc_2, [righttype]	 = @righttype_3  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE SystemSet_Select 
 (@flag int output, @msg varchar(80) output) AS select * from SystemSet 
GO

 CREATE PROCEDURE SystemSet_Update 
 (@emailserver  varchar(60) , @debugmode   char(1) , @logleaveday  tinyint , @flag int output, @msg varchar(80) output) AS update SystemSet set emailserver=@emailserver , debugmode=@debugmode,logleaveday=@logleaveday 
GO

 CREATE PROCEDURE TransBudgetCount_Select 
 @flag integer output , @msg varchar(80) output AS declare @count int select @count= count(id) from FnaBudget if @count <> 0 begin select @count return end select @count= count(id) from FnaTransaction select @count 
GO

 CREATE PROCEDURE WF_CRM_ShareInfo_Add 
(@crmid_1		int,            
 @sharelevel_1		int,
 @userid_1		int,
 @usertype_1		int,
 @flag                             integer output,
 @msg                             varchar(80) output )
as
declare @count_2 int
select @count_2=count(*)  from CRM_ShareInfo where relateditemid=@crmid_1 and sharelevel=@sharelevel_1 and userid= @userid_1
	if @count_2=0
		begin
		if @usertype_1=0
			 begin
			 insert CRM_ShareInfo(relateditemid,sharetype,sharelevel,userid) values(@crmid_1,'1',@sharelevel_1,@userid_1)
			 end
		if @usertype_1=1
			begin
			insert CRM_ShareInfo(relateditemid,sharetype,sharelevel,crmid) values(@crmid_1,'9',@sharelevel_1,@userid_1)
			end
		end


GO

 CREATE PROCEDURE WF_CptCapitalShareInfo_Add 
(@cptid		int,            
 @sharelevel_1		int,
 @userid_1		int,
 @usertype_1		int,
 @flag                             integer output,
 @msg                             varchar(80) output )
as
declare @count_2 int
select @count_2=count(*)  from CptCapitalShareInfo where relateditemid=@cptid and sharelevel=@sharelevel_1 and userid= @userid_1
	if @count_2=0
		begin
		if @usertype_1=0
			 begin
			 insert CptCapitalShareInfo(relateditemid,sharetype,sharelevel,userid) values(@cptid,'1',@sharelevel_1,@userid_1)
			 end
		if @usertype_1=1
			begin
			insert CptCapitalShareInfo(relateditemid,sharetype,sharelevel,crmid) values(@cptid,'9',@sharelevel_1,@userid_1)
			end
		end

GO

 CREATE PROCEDURE WF_DocShare_Add 
(@docid_1		int,            
 @sharelevel_1		int,
 @userid_1		int,
 @usertype_1		int,
 @flag                             integer output,
 @msg                             varchar(80) output )
as
declare @count_1 int
declare @count_2 int
select @count_1=count(*)  from docdetail where usertype=@usertype_1 and (ownerid=@userid_1 or doccreaterid=@userid_1)
if @count_1=0
	begin
	select @count_2=count(*)  from DocShare where docid=@docid_1 and sharelevel=@sharelevel_1 and userid= @userid_1
	if @count_2=0
		begin
		if @usertype_1=0
			 begin
			 insert DocShare(docid,sharetype,sharelevel,userid) values(@docid_1,'1',@sharelevel_1,@userid_1)
			 end
		if @usertype_1=1
			begin
			insert DocShare(docid,sharetype,sharelevel,crmid) values(@docid_1,'9',@sharelevel_1,@userid_1)
			end
		end
	end

GO

 CREATE PROCEDURE WF_Prj_ShareInfo_Add 
(@prjid_1		int,            
 @sharelevel_1		int,
 @userid_1		int,
 @usertype_1		int,
 @flag                             integer output,
 @msg                             varchar(80) output )
as
declare @count_1 int
declare @count_2 int
select @count_1=count(*)  from Prj_ProjectInfo where manager=@userid_1 or creater=@userid_1
if @count_1=0
	begin
	select @count_2=count(*)  from Prj_ShareInfo where relateditemid=@prjid_1 and sharelevel=@sharelevel_1 and userid= @userid_1
	if @count_2=0
		begin
		if @usertype_1=0
			 begin
			 insert Prj_ShareInfo(relateditemid,sharetype,sharelevel,userid) values(@prjid_1,'1',@sharelevel_1,@userid_1)
			 end
		if @usertype_1=1
			begin
			insert Prj_ShareInfo(relateditemid,sharetype,sharelevel,crmid) values(@prjid_1,'9',@sharelevel_1,@userid_1)
			end
		end
	end

GO

 CREATE PROCEDURE Weather_Delete 
  (@id_1 	[int],
  @flag                             integer output,
  @msg                             varchar(80) output) 
  AS 
  DELETE [Weather]  WHERE ( [id]	 = @id_1)  

GO

 CREATE PROCEDURE Weather_Insert 
  (@thedate_1 	    char(10),
  @picid_2 		    int,
  @thedesc_3 	    varchar(100),
  @temperature_4 	varchar(40),
  @flag integer output,
  @msg varchar(80) output)  
  AS 
  if  not exists( select * from Weather where thedate = @thedate_1) 
  begin 
  INSERT INTO Weather ( thedate, picid, thedesc,temperature)  VALUES 
  ( @thedate_1, @picid_2, @thedesc_3, @temperature_4) 
  end 
  select max(id) from Weather 
  if @@error<>0
  begin set @flag=1 set @msg='插入失败' end else begin set @flag=0 set @msg='操作成功' end

GO

 CREATE PROCEDURE Weather_SelectByID 
(@id_1 	int, 
@flag                             integer output,
@msg                             varchar(80) output )
AS select * from Weather where id=@id_1 

GO

 CREATE PROCEDURE Weather_SelectByYear 
  (@year_1 	 int,
  @flag                             integer output,
  @msg                             varchar(80) output ) 
  AS 
  select * from Weather where substring(thedate,1,4)= @year_1 order by thedate 

GO

 CREATE PROCEDURE Weather_SelectTheDate 
(@thedate_1 	char(10), 
@flag                             integer output,
@msg                             varchar(80) output )
AS select * from Weather where thedate = @thedate_1

GO

 CREATE PROCEDURE Weather_Update 
  (@id_1            int,
  @thedate_1 	    char(10),
  @picid_2 	    int,
  @thedesc_3 	    varchar(100),
  @temperature_4 	varchar(40),
  @flag integer output,
  @msg varchar(80) output)
  AS 
  update [Weather] set thedate = @thedate_1, picid =@picid_2 , thedesc = @thedesc_3 ,temperature = @temperature_4 
  where id= @id_1 

GO

 CREATE PROCEDURE WkfReportShareDetail_DBId 
	(@reportid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [WorkflowReportShareDetail] 

WHERE 
	( [reportid]	 = @reportid_1)


GO

 CREATE PROCEDURE WkfReportShareDetail_DByUId 
	(@userid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [WorkflowReportShareDetail] 

WHERE 
	( [userid]	 = @userid_1  and usertype = '1' )


GO

 CREATE PROCEDURE WkfReportShareDetail_Insert 
	(@reportid_1 	[int],
	 @userid_2 	[int],
	 @usertype_3 	[int],
	 @sharelevel_4 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [WorkflowReportShareDetail] 
	 ( [reportid],
	 [userid],
	 [usertype],
	 [sharelevel]) 
 
VALUES 
	( @reportid_1,
	 @userid_2,
	 @usertype_3,
	 @sharelevel_4)


GO

 CREATE PROCEDURE WorkflowReportShare_Delete 
	(@id	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	delete from WorkflowReportShare where id=@id


GO

 CREATE PROCEDURE WorkflowReportShare_Insert 
       (@reportid_1       int,
	@sharetype_1	int,
	@seclevel_1	tinyint,
	@rolelevel_1	tinyint,
	@sharelevel_1	tinyint,
	@userid_1	int,
	@subcompanyid_1	int,
	@departmentid_1	int,
	@roleid_1	int,
	@foralluser_1	tinyint,
	@crmid_1	int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	insert into WorkflowReportShare(reportid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid) 
	values(@reportid_1,@sharetype_1,@seclevel_1,@rolelevel_1,@sharelevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@roleid_1,@foralluser_1,@crmid_1)



GO







/* 存储过程部分*/


 CREATE PROCEDURE WorkflowReportShare_SByReport 
	(@reportid_1   int,
	@flag	int output,
	@msg	varchar(80)	output)
as
	select * from WorkflowReportShare where reportid = @reportid_1



GO

 CREATE PROCEDURE WorkflowRequestbase_SCountByC 
 (@year 	[char](4), @createrid    int, @flag int output, @msg varchar(80) output) AS select createdate , count(requestid) from workflow_requestbase where creater = @createrid and substring(createdate,1,4)=@year group by createdate order by createdate 
GO

 CREATE PROCEDURE Workflow_ReportDspField_ByRp 
	(@id_1 	[int],
	 @language_2 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
declare @isbill_3 char(1)
select @isbill_3 = isbill from workflow_base a , Workflow_Report b 
where b.id = @id_1 and a.id = b.reportwfid

if @isbill_3 = '0' 
select a.id , b.fieldlable , a.dsporder , a.isstat ,a.dborder 
from Workflow_ReportDspField a , workflow_fieldlable b ,Workflow_Report c , workflow_base d 
where a.reportid = c.id and a.fieldid= b.fieldid and c.reportwfid = d.id and d.formid = b.formid 
and c.id = @id_1 and  b.langurageid = @language_2 order by a.dsporder

else 
select a.id , d.labelname , a.dsporder , a.isstat ,a.dborder  
from Workflow_ReportDspField a , workflow_billfield b ,Workflow_Report c ,HtmlLabelInfo d 
where a.reportid = c.id and a.fieldid= b.id and c.id = @id_1 and b.fieldlabel = d.indexid and 
d.languageid = @language_2  order by a.dsporder

GO

 CREATE PROCEDURE Workflow_ReportDspField_Delete 
	(@id_1 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [Workflow_ReportDspField] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE Workflow_ReportDspField_Insert 
	(@reportid_1 	[int],
	 @fieldid_2 	[int],
	 @dsporder_3 	[int],
	 @isstat_4 	[char](1),
	 @dborder_5     char(1) ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [Workflow_ReportDspField] 
	 ( [reportid],
	 [fieldid],
	 [dsporder],
	 [isstat],
	 dborder) 
 
VALUES 
	( @reportid_1,
	 @fieldid_2,
	 @dsporder_3,
	 @isstat_4,
	 @dborder_5)

GO

 CREATE PROCEDURE Workflow_ReportType_Delete 
	(@id_1 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS 
declare @count integer
select @count = count(id) from Workflow_Report where reporttype = @id_1

if @count <> 0
select 0

DELETE [Workflow_ReportType] 
WHERE 
	( [id]	 = @id_1)

GO








 CREATE PROCEDURE Workflow_ReportType_Insert 
	(@typename_1 	[varchar](60),
	 @typedesc_2 	[varchar](250),
	 @typeorder_3 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [Workflow_ReportType] 
	 ( [typename],
	 [typedesc],
	 [typeorder]) 
 
VALUES 
	( @typename_1,
	 @typedesc_2,
	 @typeorder_3)

GO

 CREATE PROCEDURE Workflow_ReportType_Select 
	(@flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
select * from Workflow_ReportType order by typeorder 

GO

 CREATE PROCEDURE Workflow_ReportType_SelectByID 
	(@id_1 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
select * from Workflow_ReportType where id = @id_1

GO

 CREATE PROCEDURE Workflow_ReportType_Update 
	(@id_1 	[int],
	 @typename_2 	[varchar](60),
	 @typedesc_3 	[varchar](250),
	 @typeorder_4 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS UPDATE [Workflow_ReportType] 

SET  [typename]	 = @typename_2,
	 [typedesc]	 = @typedesc_3,
	 [typeorder]	 = @typeorder_4 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE Workflow_Report_Delete 
	(@id_1 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS DELETE [Workflow_Report] 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE Workflow_Report_Insert 
	(@reportname_1 	[varchar](100),
	 @reporttype_2 	[int],
	 @reportwfid_3 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS INSERT INTO [Workflow_Report] 
	 ( [reportname],
	 [reporttype],
	 [reportwfid]) 
 
VALUES 
	( @reportname_1,
	 @reporttype_2,
	 @reportwfid_3)

GO








 CREATE PROCEDURE Workflow_Report_Select 
	(@flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
select * from Workflow_Report

GO

 CREATE PROCEDURE Workflow_Report_SelectByID 
	(@id_1 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
select * from Workflow_Report where id = @id_1

GO

 CREATE PROCEDURE Workflow_Report_Update 
	(@id_1 	[int],
	 @reportname_2 	[varchar](100),
	 @reporttype_3 	[int],
	 @reportwfid_4 	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS UPDATE [Workflow_Report] 

SET  [reportname]	 = @reportname_2,
	 [reporttype]	 = @reporttype_3,
	 [reportwfid]	 = @reportwfid_4 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE Workflow_StaticReport_Delete 
	@id     int,
	@flag integer output , 
  	@msg varchar(80) output  
as   
	delete from workflow_StaticRpbase where id=@id

GO

 CREATE PROCEDURE Workflow_StaticReport_Insert 
	@name   varchar(50),
	@description    varchar(250),
	@pagename   varchar(50),
	@module     int,
	@flag integer output , 
  	@msg varchar(80) output  
as
    declare @tmpid  int
    
	insert into workflow_StaticRpbase(name,description,pagename,module)
	values (@name,@description,@pagename,@module)
	
	select @tmpid=max(id) from workflow_StaticRpbase
	
	update workflow_StaticRpbase set reportid=-id where id=@tmpid

GO

 CREATE PROCEDURE Workflow_StaticReport_Select 
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from workflow_StaticRpbase order by id

GO

 CREATE PROCEDURE Workflow_StaticReport_SByID 
	@id     int,
	@flag integer output , 
  	@msg varchar(80) output  
as   
	select * from workflow_StaticRpbase where id=@id

GO

 CREATE PROCEDURE Workflow_StaticReport_SByMU 
	@module     int,
	@userid     int,
	@usertype   int,
	@flag integer output , 
  	@msg varchar(80) output  
as   
	select t1.* from workflow_StaticRpbase t1,WorkflowReportShareDetail t2
	where t1.module=@module and t1.reportid=t2.reportid and t2.userid=@userid and t2.usertype=@usertype

GO

 CREATE PROCEDURE Workflow_StaticReport_SByModu 
	@module     int,
	@flag integer output , 
  	@msg varchar(80) output  
as   
	select * from workflow_StaticRpbase where module=@module

GO

 CREATE PROCEDURE Workflow_StaticReport_Update 
	@id     int,
	@name   varchar(50),
	@description    varchar(250),
	@pagename   varchar(50),
	@module     int,
	@flag integer output , 
  	@msg varchar(80) output  
as   
	update workflow_StaticRpbase 
	set name=@name,
	    description=@description,
	    pagename=@pagename,
	    module=@module
	where id=@id

GO

 CREATE PROCEDURE bill_Approve_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update Bill_Approve set status=@status where id=@id 

GO

 CREATE PROCEDURE bill_BudgetDetail_Insert 
	@departmentid	int,
	@feeid		int,
	@month		int,
	@budget		decimal(10,3),
	@year       int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into bill_budgetdetail values(@departmentid,@feeid,@month,@budget,@year)


GO

 CREATE PROCEDURE bill_BudgetDetail_SAllMonth 
	@month		int,
	@year		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select sum(budget) from bill_budgetdetail 
	where month=@month and year=@year

GO

 CREATE PROCEDURE bill_BudgetDetail_SMonthTotal 
	@departmentid	int,
	@month		int,
	@year		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select sum(budget) from bill_budgetdetail 
	where departmentid=@departmentid and month=@month and year=@year
GO

 CREATE PROCEDURE bill_BudgetDetail_SMonthToByf 
	@feeid	int,
	@month		int,
	@year		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select sum(budget) from bill_budgetdetail 
	where feeid=@feeid and month=@month and year=@year

GO

 CREATE PROCEDURE bill_BudgetDetail_SelectOne 
	@departmentid	int,
	@feeid		int,
	@month		int,
	@year		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select budget from bill_budgetdetail 
	where departmentid=@departmentid and feeid=@feeid and month=@month and year=@year

GO

 CREATE PROCEDURE bill_CptAdjustDetail_Insert 
	(@cptadjustid 	[int],
	@cptid_1 	[int],
	 @number_2 	[decimal](10,3),
	 @unitprice_3 	[decimal](10,3),
	 @amount_4 	[decimal](10,3),
	 @cptstatus 	[int],
	 @needdate_5 	[varchar](10),
	 @purpose_6 	[varchar](60),
	 @cptdesc_7 	[varchar](60),
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptAdjustDetail] 
	 ( [cptadjustid],
	 [cptid],
	 [number_n],
	 [unitprice],
	 [amount],
	 [cptstatus],
	 [needdate],
	 [purpose],
	 [cptdesc]) 
 
VALUES 
	( @cptadjustid,
	@cptid_1,
	 @number_2,
	 @unitprice_3,
	 @amount_4,
	 @cptstatus,
	 @needdate_5,
	 @purpose_6,
	 @cptdesc_7)

GO

 CREATE PROCEDURE bill_CptAdjustDetail_Select 
	(@cptadjustid 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptAdjustDetail] 
WHERE 
	( [cptadjustid]	 = @cptadjustid)

GO

 CREATE PROCEDURE bill_CptAdjustDetail_Update 
	(@id_1 	[int],
	 @cptid_3 	[int],
	 @number_4 	[decimal](10,3),
	 @unitprice_5 	[decimal](10,3),
	 @amount_6 	[decimal](10,3),
	 @cptstatus 	[int],
	 @needdate_7 	[varchar](10),
	 @purpose_8 	[varchar](60),
	 @cptdesc_9 	[varchar](60),
	 @capitalid 	[int],
  @flag integer output , 
  @msg varchar(80) output)

AS UPDATE  [bill_CptAdjustDetail] 

SET  
	 [cptid]	 = @cptid_3,
	 [number_n]	 = @number_4,
	 [unitprice]	 = @unitprice_5,
	 [amount]	 = @amount_6,
	 [cptstatus]	 = @cptstatus,
	 [needdate]	 = @needdate_7,
	 [purpose]	 = @purpose_8,
	 [cptdesc]	 = @cptdesc_9 ,
	 [capitalid]	 = @capitalid 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE bill_CptAdjustMain_Select 
	(@id 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptAdjustMain] 
WHERE 
	( [id]	 = @id)

GO

 CREATE PROCEDURE bill_CptApplyDetail_Insert 
	(@cptapplyid 	[int],
	 @cpttype 	[int],
	@cptid_1 	[int],
	 @number_2 	[decimal](10,3),
	 @unitprice_3 	[decimal](10,3),
	 @amount_4 	[decimal](10,3),
	 @needdate_5 	[varchar](10),
	 @purpose_6 	[varchar](60),
	 @cptdesc_7 	[varchar](60),
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptApplyDetail] 
	 ( [cptapplyid],
	 [cpttype],
	 [cptid],
	 [number_n],
	 [unitprice],
	 [amount],
	 [needdate],
	 [purpose],
	 [cptdesc]) 
 
VALUES 
	( @cptapplyid,
	@cpttype,
	@cptid_1,
	 @number_2,
	 @unitprice_3,
	 @amount_4,
	 @needdate_5,
	 @purpose_6,
	 @cptdesc_7)

GO

 CREATE PROCEDURE bill_CptApplyDetail_Select 
	(@cptapplyid 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptApplyDetail] 
WHERE 
	( [cptapplyid]	 = @cptapplyid)

GO

 CREATE PROCEDURE bill_CptApplyDetail_Update 
	(@id_1 	[int],
	@cpttype 	[int],
	 @cptid_3 	[int],
	 @number_4 	[decimal](10,3),
	 @unitprice_5 	[decimal](10,3),
	 @amount_6 	[decimal](10,3),
	 @needdate_7 	[varchar](10),
	 @purpose_8 	[varchar](60),
	 @cptdesc_9 	[varchar](60),	 
	 @capitalid 	[int],
  @flag integer output , 
  @msg varchar(80) output)

AS UPDATE  [bill_CptApplyDetail] 

SET  
	 [cpttype]	 = @cpttype,
	 [cptid]	 = @cptid_3,
	 [number_n]	 = @number_4,
	 [unitprice]	 = @unitprice_5,
	 [amount]	 = @amount_6,
	 [needdate]	 = @needdate_7,
	 [purpose]	 = @purpose_8,
	 [cptdesc]	 = @cptdesc_9 ,
	 [capitalid]	 = @capitalid 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE bill_CptApplyMain_Select 
	(@id 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptApplyMain] 
WHERE 
	( [id]	 = @id)

GO

 CREATE PROCEDURE bill_CptCarFee_Insert 
	(@requestid_1 	[int],
	 @usedate_2 	[varchar](10),
	 @driver_3 	[int],
	 @carno_4 	[int],
	 @oilfee_5 	[decimal],
	 @bridgefee_6 	[decimal],
	 @fixfee_7 	[decimal],
	 @phonefee_8 	[decimal],
	 @cleanfee_9 	[decimal],
	 @remax_10 	[varchar](255),
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptCarFee] 
	 ( [requestid],
	 [usedate],
	 [driver],
	 [carno],
	 [oilfee],
	 [bridgefee],
	 [fixfee],
	 [phonefee],
	 [cleanfee],
	 [remax]) 
 
VALUES 
	( @requestid_1,
	 @usedate_2,
	 @driver_3,
	 @carno_4,
	 @oilfee_5,
	 @bridgefee_6,
	 @fixfee_7,
	 @phonefee_8,
	 @cleanfee_9,
	 @remax_10)
GO

 CREATE PROCEDURE bill_CptCarFee_Update 
	(@id_1 	[int],
	 @usedate_2 	[varchar](10),
	 @driver_3 	[int],
	 @carno_4 	[int],
	 @oilfee_5 	[decimal],
	 @bridgefee_6 	[decimal],
	 @fixfee_7 	[decimal],
	 @phonefee_8 	[decimal],
	 @cleanfee_9 	[decimal],
	 @remax_10 	[varchar](255),
  @flag integer output , 
  @msg varchar(80) output )

AS UPDATE [bill_CptCarFee] 

SET  [usedate]	 = @usedate_2,
	 [driver]	 = @driver_3,
	 [carno]	 = @carno_4,
	 [oilfee]	 = @oilfee_5,
	 [bridgefee]	 = @bridgefee_6,
	 [fixfee]	 = @fixfee_7,
	 [phonefee]	 = @phonefee_8,
	 [cleanfee]	 = @cleanfee_9,
	 [remax]	 = @remax_10 

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE bill_CptCarFix_Insert 
	(@requestid_1 	[int],
	 @usedate_2 	[varchar](10),
	 @driver_3 	[int],
	 @carno_4 	[int],
	 @fixfee_5 	[decimal](10,3),
	 @remax_6 	[varchar](255),
  @flag integer output , 
  @msg varchar(80) output)

AS INSERT INTO [bill_CptCarFix] 
	 ( [requestid],
	 [usedate],
	 [driver],
	 [carno],
	 [fixfee],
	 [remax]) 
 
VALUES 
	( @requestid_1,
	 @usedate_2,
	 @driver_3,
	 @carno_4,
	 @fixfee_5,
	 @remax_6)

GO

 CREATE PROCEDURE bill_CptCarFix_Update 
	(@id_1 	[int],
	 @usedate_2 	[varchar](10),
	 @driver_3 	[int],
	 @carno_4 	[int],
	 @fixfee_5 	[decimal](10,3),
	 @remax_6 	[varchar](255),
  @flag integer output , 
  @msg varchar(80) output)

AS UPDATE [bill_CptCarFix] 

SET  [usedate]	 = @usedate_2,
	 [driver]	 = @driver_3,
	 [carno]	 = @carno_4,
	 [fixfee]	 = @fixfee_5,
	 [remax]	 = @remax_6 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE bill_CptCarMantant_Insert 
	(@requestid_1 	[int],
	 @usedate_2 	[varchar](10),
	 @driver_3 	[int],
	 @carno_4 	[int],
	 @mantantfee_5 	[decimal],
	 @remax_6 	[varchar](255),
  @flag integer output , 
  @msg varchar(80) output)

AS INSERT INTO [bill_CptCarMantant] 
	 ( [requestid],
	 [usedate],
	 [driver],
	 [carno],
	 [mantantfee],
	 [remax]) 
 
VALUES 
	( @requestid_1,
	 @usedate_2,
	 @driver_3,
	 @carno_4,
	 @mantantfee_5,
	 @remax_6)
GO

 CREATE PROCEDURE bill_CptCarMantant_Update 
	(@id_1 	[int],
	 @usedate_2 	[varchar](10),
	 @driver_3 	[int],
	 @carno_4 	[int],
	 @mantantfee_5 	[decimal],
	 @remax_6 	[varchar](255),
  @flag integer output , 
  @msg varchar(80) output)

AS UPDATE [bill_CptCarMantant] 

SET  [usedate]	 = @usedate_2,
	 [driver]	 = @driver_3,
	 [carno]	 = @carno_4,
	 [mantantfee]	 = @mantantfee_5,
	 [remax]	 = @remax_6 

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE bill_CptCarOut_Delete 
	(@id_1 	[int],
  @flag integer output , 
  @msg varchar(80) output )

AS DELETE [bill_CptCarOut] 

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE bill_CptCarOut_Insert 
	(@requestid_1 	[int],
	 @date_2 	[varchar](10),
	 @driver_3 	[int],
	 @carno_4 	[int],
	 @begindate_5 	[varchar](10),
	 @begintime_6 	[varchar](5),
	 @enddate_7 	[varchar](10),
	 @endtime_8 	[varchar](5),
	 @frompos_9 	[varchar](255),
	 @beginnumber_10 	[decimal],
	 @endnumber_11 	[decimal],
	 @number_12 	[decimal],
	 @userid_13 	[int],
	 @userdepid_14 	[int],
	 @isotherplace_15 	[int],
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptCarOut] 
	 ( [requestid],
	 [usedate],
	 [driver],
	 [carno],
	 [begindate],
	 [begintime],
	 [enddate],
	 [endtime],
	 [frompos],
	 [beginnumber],
	 [endnumber],
	 [number_n],
	 [userid],
	 [userdepid],
	 [isotherplace]) 
 
VALUES 
	( @requestid_1,
	 @date_2,
	 @driver_3,
	 @carno_4,
	 @begindate_5,
	 @begintime_6,
	 @enddate_7,
	 @endtime_8,
	 @frompos_9,
	 @beginnumber_10,
	 @endnumber_11,
	 @number_12,
	 @userid_13,
	 @userdepid_14,
	 @isotherplace_15)

GO

 CREATE PROCEDURE bill_CptCarOut_Update 
	(@id_1 	[int],
	 @date_2 	[varchar](10),
	 @driver_3 	[int],
	 @carno_4 	[int],
	 @begindate_5 	[varchar](10),
	 @begintime_6 	[varchar](5),
	 @enddate_7 	[varchar](10),
	 @endtime_8 	[varchar](5),
	 @frompos_9 	[varchar](255),
	 @beginnumber_10 	[decimal],
	 @endnumber_11 	[decimal],
	 @number_12 	[decimal],
	 @userid_13 	[int],
	 @userdepid_14 	[int],
	 @isotherplace_15 	[int],
  @flag integer output , 
  @msg varchar(80) output )

AS UPDATE [bill_CptCarOut] 

SET  [usedate]	 = @date_2,
	 [driver]	 = @driver_3,
	 [carno]	 = @carno_4,
	 [begindate]	 = @begindate_5,
	 [begintime]	 = @begintime_6,
	 [enddate]	 = @enddate_7,
	 [endtime]	 = @endtime_8,
	 [frompos]	 = @frompos_9,
	 [beginnumber]	 = @beginnumber_10,
	 [endnumber]	 = @endnumber_11,
	 [number_n]	 = @number_12,
	 [userid]	 = @userid_13,
	 [userdepid]	 = @userdepid_14,
	 [isotherplace]	 = @isotherplace_15 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE bill_CptCheckDetail_Insert 
	(@cptcheckid 	[int],
	@cptid 	[int],
	 @theorynumber 	[decimal](10,3),
	 @realnumber 	[decimal](10,3),
	 @price 	[decimal](10,3),
	 @remark 	[varchar](250),
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptCheckDetail] 
	 ( [cptcheckid],
	 [cptid],
	 [theorynumber],
	 [realnumber],
	 [price],
	 [remark]) 
 
VALUES 
	( @cptcheckid,
	@cptid,
	 @theorynumber,
	 @realnumber,
	 @price,
	 @remark)

GO

 CREATE PROCEDURE bill_CptCheckDetail_Select 
	(@cptcheckid 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptCheckDetail] 
WHERE 
	( [cptcheckid]	 = @cptcheckid)

GO

 CREATE PROCEDURE bill_CptCheckMain_Select 
	(@id 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptCheckMain] 
WHERE 
	( [id]	 = @id)

GO

 CREATE PROCEDURE bill_CptFetchDetail_Insert 
	(@cptfetchid 	[int],
	@cptid_1 	[int],
	 @number_2 	[decimal](10,3),
	 @unitprice_3 	[decimal](10,3),
	 @amount_4 	[decimal](10,3),
	 @needdate_5 	[varchar](10),
	 @purpose_6 	[varchar](60),
	 @cptdesc_7 	[varchar](60),
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptFetchDetail] 
	 ( [cptfetchid],
	 [cptid],
	 [number_n],
	 [unitprice],
	 [amount],
	 [needdate],
	 [purpose],
	 [cptdesc]) 
 
VALUES 
	( @cptfetchid,
	@cptid_1,
	 @number_2,
	 @unitprice_3,
	 @amount_4,
	 @needdate_5,
	 @purpose_6,
	 @cptdesc_7)

GO

 CREATE PROCEDURE bill_CptFetchDetail_Select 
	(@cptfetchid 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptFetchDetail] 
WHERE 
	( [cptfetchid]	 = @cptfetchid)

GO

 CREATE PROCEDURE bill_CptFetchDetail_Update 
	(@id_1 	[int],
	 @cptid_3 	[int],
	 @number_4 	[decimal](10,3),
	 @unitprice_5 	[decimal](10,3),
	 @amount_6 	[decimal](10,3),
	 @needdate_7 	[varchar](10),
	 @purpose_8 	[varchar](60),
	 @cptdesc_9 	[varchar](60),
	 @capitalid 	[int],
  @flag integer output , 
  @msg varchar(80) output)

AS UPDATE  [bill_CptFetchDetail] 

SET  
	 [cptid]	 = @cptid_3,
	 [number_n]	 = @number_4,
	 [unitprice]	 = @unitprice_5,
	 [amount]	 = @amount_6,
	 [needdate]	 = @needdate_7,
	 [purpose]	 = @purpose_8,
	 [cptdesc]	 = @cptdesc_9 ,
	 [capitalid]	 = @capitalid

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE bill_CptFetchMain_Select 
	(@id 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptFetchMain] 
WHERE 
	( [id]	 = @id)

GO

 CREATE PROCEDURE bill_CptPlanDetail_Insert 
	(@cptplanid 	[int],
	@cptid_1 	[int],
	 @number_2 	[decimal](10,3),
	 @unitprice_3 	[decimal](10,3),
	 @amount_4 	[decimal](10,3),
	 @needdate_5 	[varchar](10),
	 @purpose_6 	[varchar](60),
	 @cptdesc_7 	[varchar](60),
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptPlanDetail] 
	 ( [cptplanid],
	 [cptid],
	 [number_n],
	 [unitprice],
	 [amount],
	 [needdate],
	 [purpose],
	 [cptdesc]) 
 
VALUES 
	( @cptplanid,
	@cptid_1,
	 @number_2,
	 @unitprice_3,
	 @amount_4,
	 @needdate_5,
	 @purpose_6,
	 @cptdesc_7)

GO

 CREATE PROCEDURE bill_CptPlanDetail_Select 
	(@cptplanid_2 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptPlanDetail] 
WHERE 
	( [cptplanid]	 = @cptplanid_2)

GO

 CREATE PROCEDURE bill_CptPlanDetail_Update 
	(@id_1 	[int],
	 @cptplanid_2 	[int],
	 @cptid_3 	[int],
	 @number_4 	[decimal](10,3),
	 @unitprice_5 	[decimal](10,3),
	 @amount_6 	[decimal](10,3),
	 @needdate_7 	[varchar](10),
	 @purpose_8 	[varchar](60),
	 @cptdesc_9 	[varchar](60),
  @flag integer output , 
  @msg varchar(80) output)

AS UPDATE  [bill_CptPlanDetail] 

SET  [cptplanid]	 = @cptplanid_2,
	 [cptid]	 = @cptid_3,
	 [number_n]	 = @number_4,
	 [unitprice]	 = @unitprice_5,
	 [amount]	 = @amount_6,
	 [needdate]	 = @needdate_7,
	 [purpose]	 = @purpose_8,
	 [cptdesc]	 = @cptdesc_9 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE bill_CptPlanMain_Select 
	(@id 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptPlanMain] 
WHERE 
	( [id]	 = @id)

GO

 CREATE PROCEDURE bill_CptRequireDetail_Insert 
	(@cptrequireid 	[int],
	@cpttype 	[int],
	@cptid_1 	[int],
	 @number_2 	[decimal](10,3),
	 @unitprice_3 	[decimal](10,3),
	 @needdate_5 	[varchar](10),
	 @purpose_6 	[varchar](60),
	 @cptdesc_7 	[varchar](60),
	 @buynumber 	[decimal](10,3),
	 @adjustnumber 	[decimal](10,3),
	 @fetchnumber 	[decimal](10,3),
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptRequireDetail] 
	 ( [cptrequireid],
	 [cpttype],
	 [cptid],
	 [number_n],
	 [unitprice],
	 [needdate],
	 [purpose],
	 [cptdesc],
	 [buynumber],
	 [adjustnumber],
	 [fetchnumber]) 
 
VALUES 
	( @cptrequireid,
	@cpttype,
	@cptid_1,
	 @number_2,
	 @unitprice_3,
	 @needdate_5,
	 @purpose_6,
	 @cptdesc_7,
	 @buynumber,
	 @adjustnumber,
	 @fetchnumber
	 )

GO

 CREATE PROCEDURE bill_CptRequireDetail_Select 
	(@cptrequireid 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptRequireDetail] 
WHERE 
	( [cptrequireid]	 = @cptrequireid)

GO

 CREATE PROCEDURE bill_CptRequireDetail_Update 
	(@id_1 	[int],
	 @cpttype 	[int],
	@cptid_1 	[int],
	 @number_2 	[decimal](10,3),
	 @unitprice_3 	[decimal](10,3),
	 @needdate_5 	[varchar](10),
	 @purpose_6 	[varchar](60),
	 @cptdesc_7 	[varchar](60),
	 @buynumber 	[decimal](10,3),
	 @adjustnumber 	[decimal](10,3),
	 @fetchnumber 	[decimal](10,3),
  @flag integer output , 
  @msg varchar(80) output)

AS UPDATE  [bill_CptRequireDetail] 

SET  
	 [cpttype]	 = @cpttype,
	 [cptid]	 = @cptid_1,
	 [number_n]	 = @number_2,
	 [unitprice]	 = @unitprice_3,
	 [needdate]	 = @needdate_5,
	 [purpose]	 = @purpose_6,
	 [cptdesc]	 = @cptdesc_7 ,
	 [buynumber]	 = @buynumber ,
	 [adjustnumber]	 = @adjustnumber ,
	 [fetchnumber]	 = @fetchnumber 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE bill_CptRequireMain_Select 
	(@id 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptRequireMain] 
WHERE 
	( [id]	 = @id)

GO

 CREATE PROCEDURE bill_CptStockInDetail_Insert 
	(@cptstockinid 	[int],
	@cptid_1 	[int],
	 @number_2 	[decimal](10,3),
	 @unitprice_3 	[decimal](10,3),
	 @amount_4 	[decimal](10,3),
  @flag integer output , 
  @msg varchar(80) output )

AS INSERT INTO [bill_CptStockInDetail] 
	 ( [cptstockinid],
	 [cptid],
	 [plannumber],
	 [planprice],
	 [planamount]) 
 
VALUES 
	( @cptstockinid,
	@cptid_1,
	 @number_2,
	 @unitprice_3,
	 @amount_4)

GO

 CREATE PROCEDURE bill_CptStockInDetail_Select 
	(@cptstockinid 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptStockInDetail] 
WHERE 
	( [cptstockinid]	 = @cptstockinid)

GO

 CREATE PROCEDURE bill_CptStockInDetail_SSum 
	(@cptstockinid 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select count(id)  from  [bill_CptStockInDetail] 
WHERE 
	( [cptstockinid]	 = @cptstockinid)
GO

 CREATE PROCEDURE bill_CptStockInDetail_Update 
	(@id_1 	[int],
	 @cptno_3 	[varchar](50),
	 @cptid_4 	[int],
	 @cpttype_5 	[varchar](80),
	 @plannumber_6 	[decimal],
	 @innumber_7 	[decimal],
	 @planprice_8 	[decimal],
	 @inprice_9 	[decimal],
	 @planamount_10 	[decimal],
	 @inamount_11 	[decimal],
	 @difprice_12 	[decimal],
	  @capitalid 	[int],
  @flag integer output , 
  @msg varchar(80) output)

AS UPDATE [bill_CptStockInDetail] 

SET  	 [cptno]	 = @cptno_3,
	 [cptid]	 = @cptid_4,
	 [cpttype]	 = @cpttype_5,
	 [plannumber]	 = @plannumber_6,
	 [innumber]	 = @innumber_7,
	 [planprice]	 = @planprice_8,
	 [inprice]	 = @inprice_9,
	 [planamount]	 = @planamount_10,
	 [inamount]	 = @inamount_11,
	 [difprice]	 = @difprice_12 ,
	 [capitalid]	 = @capitalid 

WHERE 
	( [id]	 = @id_1)

GO

 CREATE PROCEDURE bill_CptStockInDetail_Update2 
	(@id_1 	[int],
	 @capitalid 	[int],
	 @mark 	[varchar](60),
	 @capitalspec    [varchar](100),
	  @flag integer output , 
	  @msg varchar(80) output)

AS UPDATE  [bill_CptStockInDetail] 

SET  
	 [capitalid]	 = @capitalid ,
	 [cptno]	 = @mark,
	 [cpttype]   = @capitalspec

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE bill_CptStockInMain_Select 
	(@id 	[int],	 
  @flag integer output , 
  @msg varchar(80) output)

AS select * from  [bill_CptStockInMain] 
WHERE 
	( [id]	 = @id)

GO

 CREATE PROCEDURE bill_Discuss_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_Discuss set status=@status where id=@id 

GO

 CREATE PROCEDURE bill_HireResource_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_HireResource set status=@status where id=@id 

GO

 CREATE PROCEDURE bill_HotelBookDetail_Delete 
	@bookid		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	delete from bill_HotelBookDetail where bookid=@bookid

GO

 CREATE PROCEDURE bill_HotelBookDetail_Insert 
	@bookid		int,
	@hotelid    int,
	@roomstyle  varchar(50),
	@roomsum    int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into bill_HotelBookDetail (bookid,hotelid,roomstyle,roomsum)
	values (@bookid,@hotelid,@roomstyle,@roomsum)

GO

 CREATE PROCEDURE bill_HotelBookDetail_SByBooki 
	@bookid		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_HotelBookDetail where bookid=@bookid

GO

 CREATE PROCEDURE bill_HotelBook_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_HotelBook set status=@status where id=@id 

GO

/* 9.3 */
 CREATE PROCEDURE bill_HrmFinance_Insert 
	@resourceid		int,
	@requestid		int,
	@billid			int,
	@basictype		int,
	@detailtype		int,
	@amount			decimal(10,2),
	@crmid			int,
	@projectid		int,
	@docid			int,
	@name			varchar(50),
	@description	varchar(250),
	@remark			varchar(250),
	@occurdate		char(10),
	@occurtime		char(8),
	@relatedrequestid	int,
	@relatedresource	varchar(250),
	@accessory		int,
	@debitledgeid	int,
	@debitremark        varchar(250),			
	@creditledgeid      int,					
	@creditremark       varchar(250),		
	@currencyid         int,					
	@exchangerate       varchar(20),			
	@status				char(1),
	@flag			int	output, 
	@msg			varchar(80) output
as
	insert into bill_HrmFinance 
	(resourceid,requestid,billid,basictype,detailtype,amount,crmid,projectid,docid,name,
	 description,remark,occurdate,occurtime,relatedrequestid,relatedresource,accessory,
	 debitledgeid,debitremark,creditledgeid,creditremark,currencyid,exchangerate,status)
	values
	(@resourceid,@requestid,@billid,@basictype,@detailtype,@amount,@crmid,@projectid,@docid,@name,
	@description,@remark,@occurdate,@occurtime,@relatedrequestid,@relatedresource,@accessory,
	@debitledgeid,@debitremark,@creditledgeid,@creditremark,@currencyid,@exchangerate,@status)
	
	select max(id) from bill_hrmfinance

GO

 CREATE PROCEDURE bill_HrmFinance_SelectByID 
	@id		int,
	@flag			int	output, 
	@msg			varchar(80) output
as
	select * from bill_hrmfinance where id=@id

GO

 CREATE PROCEDURE bill_HrmFinance_SelectLoan 
  @resourceid	int, 
  @flag integer output , 
  @msg varchar(80) output 
AS 
  declare @tmpamount1   decimal(10,3),
          @tmpamount2   decimal(10,3)
  select @tmpamount1=sum(amount) from bill_hrmfinance 
  where resourceid=@resourceid and status='1' and basictype=3
  
  select @tmpamount2=sum(amount) from bill_hrmfinance
  where resourceid=@resourceid and status='1' and basictype in(1,4)
  
  if    @tmpamount1 is null
        set @tmpamount1=0
  if    @tmpamount2 is null
        set @tmpamount2=0
  if @tmpamount1>=@tmpamount2
    set @tmpamount1=@tmpamount1-@tmpamount2
  else
    set @tmpamount1=0
  select @tmpamount1 

GO

 CREATE PROCEDURE bill_HrmFinance_Update 
	@id				int,
	@resourceid		int,
	@requestid		int,
	@billid			int,
	@basictype		int,
	@detailtype		int,
	@amount			decimal(10,2),
	@crmid			int,
	@projectid		int,
	@docid			int,
	@name			varchar(50),
	@description	varchar(250),
	@remark			varchar(250),
	@occurdate		char(10),
	@occurtime		char(8),
	@relatedrequestid	int,
	@relatedresource	varchar(250),
	@accessory		int,
	@debitledgeid	int,
	@debitremark        varchar(250),			
	@creditledgeid      int,					
	@creditremark       varchar(250),		
	@currencyid         int,					
	@exchangerate       varchar(20),			
	@flag			int	output, 
	@msg			varchar(80) output
as
	update bill_HrmFinance 
	set resourceid=@resourceid,requestid=@requestid,billid=@billid,
		basictype=@basictype,detailtype=@detailtype,amount=@amount,
		crmid=@crmid,projectid=@projectid,docid=@docid,name=@name,
	 	description=@description,remark=@remark,occurdate=@occurdate,
	 	occurtime=@occurtime,relatedrequestid=@relatedrequestid,
	 	relatedresource=@relatedresource,accessory=@accessory,
	 	debitledgeid=@debitledgeid,debitremark=@debitremark,
	 	creditledgeid=@creditledgeid,creditremark=@creditremark,
	 	currencyid=@currencyid,exchangerate=@exchangerate
	where id=@id

GO

 CREATE PROCEDURE bill_HrmFinance_UpdateRemind 
  @id	int, 
  @isremind        int,
  @flag integer output , 
  @msg varchar(80) output 
AS 
  Update bill_hrmfinance set isremind=@isremind where id=@id

GO

 CREATE PROCEDURE bill_HrmFinance_UpdateStatus 
	(@id		int,
	 @status	char(1),
	 @flag integer output,
	 @msg varchar(80) output)
AS
	update bill_hrmfinance set status=@status where id=@id

GO

 CREATE PROCEDURE bill_HrmTime_Insert 
	(@resourceid 	int,
	 @requestid 	int,
	 @billid 	int,
	 @basictype 	int,
	 @detailtype 	int,
	 @begindate 	char(10),
	 @begintime 	char(8),
	 @enddate 	char(10),
	 @endtime 	char(5),
	 @name	 	varchar(50),
	 @description 	varchar(255),
	 @remark 	text,
	 @totaldays 	int,
	 @totalhours	bigint,
	 @progress	decimal(8,3),
	 @projectid	int,
	 @crmid		int,
	 @docid		int,
	 @relatedrequestid	int,
	 @status	char(1),
	 @customizeint1	int,
	 @customizeint2	int,
	 @customizeint3	int,
	 @customizefloat1	decimal(8,3),
	 @customizestr1	varchar(255),
	 @customizestr2	varchar(255),
	@flag integer output,
	 @msg varchar(80) output)
AS 

INSERT INTO bill_hrmtime
	(resourceid,requestid,billid,basictype,detailtype,
	 begindate,begintime,enddate,endtime,
	 name,description,remark,totaldays,totalhours,
	 progress,projectid,crmid,docid,
	 relatedrequestid,status,customizeint1,customizeint2,customizeint3,
	 customizefloat1,customizestr1,customizestr2) 
VALUES 
	(@resourceid,@requestid,@billid,@basictype,@detailtype,
	 @begindate,@begintime,@enddate,@endtime,
	 @name,@description,@remark,@totaldays,@totalhours,
	 @progress,@projectid,@crmid,@docid,
	 @relatedrequestid,@status,@customizeint1,@customizeint2,@customizeint3,
	 @customizefloat1,@customizestr1,@customizestr2) 

select max(id) from bill_hrmtime

GO

 CREATE PROCEDURE bill_HrmTime_SelectByID 
	(@id 	int,
	@flag integer output,
	 @msg varchar(80) output)
AS 
	select * from bill_hrmtime where id=@id

GO

/* 8.22 */
 CREATE PROCEDURE bill_HrmTime_Update 
	(@id		int,
	 @resourceid 	int,
	 @requestid 	int,
	 @billid 	int,
	 @basictype 	int,
	 @detailtype 	int,
	 @begindate 	char(10),
	 @begintime 	char(8),
	 @enddate 	char(10),
	 @endtime 	char(5),
	 @name	 	varchar(50),
	 @description 	varchar(255),
	 @remark 	text,
	 @totaldays 	int,
	 @totalhours	bigint,
	 @progress	decimal(8,3),
	 @projectid	int,
	 @crmid		int,
	 @docid		int,
	 @relatedrequestid	int,
	 @customizeint1	int,
	 @customizeint2	int,
	 @customizeint3	int,
	 @customizefloat1	decimal(8,3),
	 @customizestr1	varchar(255),
	 @customizestr2 varchar(255),
	@flag integer output,
	 @msg varchar(80) output)
AS 
update bill_hrmtime
set resourceid=@resourceid,
    requestid=@requestid,
    billid=@billid,
    basictype=@basictype,
    detailtype=@detailtype,
    begindate=@begindate,
    begintime=@begintime,
    enddate=@enddate,
    endtime=@endtime,
    name=@name,
    description=@description,
    remark=@remark,
    totaldays=@totaldays,
    totalhours=@totalhours,
    progress=@progress,
    projectid=@projectid,
    crmid=@crmid,
    docid=@docid,
    relatedrequestid=@relatedrequestid,
    customizeint1=@customizeint1,
    customizeint2=@customizeint2,
    customizeint3=@customizeint3,
    customizefloat1=@customizefloat1,
    customizestr1=@customizestr1,
    customizestr2=@customizestr2
where id=@id

GO

 CREATE PROCEDURE bill_HrmTime_UpdateRemind 
  @id	int, 
  @isremind        int,
  @flag integer output , 
  @msg varchar(80) output 
AS 
  Update bill_hrmtime set isremind=@isremind where id=@id

GO

 CREATE PROCEDURE bill_HrmTime_UpdateStatus 
	(@id		int,
	 @status	char(1),
	 @flag integer output,
	 @msg varchar(80) output)
AS
	update bill_hrmtime set status=@status where id=@id

GO

 CREATE PROCEDURE bill_LeaveJob_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_LeaveJob set status=@status where id=@id 

GO

 CREATE PROCEDURE bill_MailboxApply_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_MailboxApply set status=@status where id=@id 

GO

 CREATE PROCEDURE bill_NameCard_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_NameCard set status=@status where id=@id 

GO

 CREATE PROCEDURE bill_NameCardinfo_SByResource 
	@resourceid		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_NameCardinfo where resourceid=@resourceid 

GO

 CREATE PROCEDURE bill_TotalBudget_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update Bill_TotalBudget set status=@status where id=@id 

GO

 CREATE PROCEDURE bill_contract_SelectById 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from bill_contract where id=@id 
GO

 CREATE PROCEDURE bill_contractdetail_Insert 
 (@contractid 	[int], @assetid_2 	[int], @batchmark_3 	[varchar](20), @number_4 	[float], @currencyid_5 	[int], @defcurrencyid_6 	[int], @exchangerate_7 	[decimal], @defunitprice_8 	[decimal], @unitprice_9 	[decimal], @taxrate_10 	[int], @flag integer output , @msg varchar(80) output)  AS INSERT INTO [bill_contractdetail] ( [contractid], [assetid], [batchmark], [number_n], [currencyid], [defcurrencyid], [exchangerate], [defunitprice], [unitprice], [taxrate])  VALUES ( @contractid, @assetid_2, @batchmark_3, @number_4, @currencyid_5, @defcurrencyid_6, @exchangerate_7, @defunitprice_8, @unitprice_9, @taxrate_10) 
GO

 CREATE PROCEDURE bill_contractdetail_Select 
 (@id [int], @flag integer output , @msg varchar(80) output) AS select *  from bill_contractdetail where contractid=@id 
GO

 CREATE PROCEDURE bill_contractdetail_Update 
 (@id_1 	[int], @contractid 	[int], @assetid_3 	[int], @batchmark_4 	[varchar](20), @number_5 	[float], @currencyid_6 	[int], @defcurrencyid_7 	[int], @exchangerate_8 	[decimal], @defunitprice_9 	[decimal], @unitprice_10 	[decimal], @taxrate_11 	[int],  @flag integer output , @msg varchar(80) output)  AS UPDATE [bill_contractdetail]  SET  [contractid]	 = @contractid, [assetid]	 = @assetid_3, [batchmark]	 = @batchmark_4, [number_n]	 = @number_5, [currencyid]	 = @currencyid_6, [defcurrencyid]	 = @defcurrencyid_7, [exchangerate]	 = @exchangerate_8, [defunitprice]	 = @defunitprice_9, [unitprice]	 = @unitprice_10, [taxrate]	 = @taxrate_11  WHERE ( [id]	 = @id_1) 
GO

 CREATE PROCEDURE bill_includepages_SelectByID 
@id	int, @flag integer output , @msg varchar(80) output 
AS 
select * from workflow_bill where id=@id

GO

 CREATE PROCEDURE bill_itemusage_Select 
 @id	int, @flag integer output , @msg varchar(80) output AS select * from bill_itemusage where id=@id 
GO

 CREATE PROCEDURE bill_itemusage_UpdateStatus 
 (@id [int], @usestatus char(1) ,@flag integer output , @msg varchar(80) output) AS update bill_itemusage set usestatus = @usestatus where id=@id 
GO

 CREATE PROCEDURE bill_monthinfodetail_DByType 
	@infoid		int,
	@type		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	delete from bill_monthinfodetail where infoid=@infoid and type=@type

GO

 CREATE PROCEDURE bill_monthinfodetail_Insert 
	@infoid		int,
	@type		int,
	@targetname	varchar(250),
	@targetresult	text,
	@forecastdate	char(10),
	@scale		decimal(10,3),
	@point		tinyint,
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into bill_monthinfodetail (infoid,type,targetname,targetresult,forecastdate,scale,point)
	values (@infoid,@type,@targetname,@targetresult,@forecastdate,@scale,@point)

GO

 CREATE PROCEDURE bill_monthinfodetail_SByType 
	@infoid		int,
	@type		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_monthinfodetail where infoid=@infoid and type=@type

GO

 CREATE PROCEDURE bill_monthinfodetail_UByPoint 
	@id		int,
	@point	varchar(5),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_monthinfodetail set point=@point where id=@id 


GO

 CREATE PROCEDURE bill_workinfo_SSubordinate 
	@formid		int,
	@userid     int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_workinfo where billid=@formid and status='1' and mainid is null and manager=@userid

GO

 CREATE PROCEDURE bill_workinfo_UpdateMainid 
	@formid		int,
	@userid     int,
	@mainid     int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_workinfo set mainid=@mainid
	where billid=@formid and status='1' and mainid is null and manager=@userid

GO

 CREATE PROCEDURE bill_workinfo_UpdateStatus 
	@id		int,
	@status	char(1),
	@flag integer output , 
  	@msg varchar(80) output  
as
	update bill_workinfo set status=@status where id=@id 

GO

 CREATE PROCEDURE bill_workinfodetail_DByType 
	@infoid		int,
	@type		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	delete from bill_weekinfodetail where infoid=@infoid and type=@type

GO

 CREATE PROCEDURE bill_workinfodetail_Insert 
	@infoid		int,
	@type		int,
	@workname	varchar(250),
	@workdesc	text,
	@forecastdate	char(10),
	@flag integer output , 
  	@msg varchar(80) output  
as
	insert into bill_weekinfodetail (infoid,type,workname,workdesc,forecastdate)
	values (@infoid,@type,@workname,@workdesc,@forecastdate)

GO

 CREATE PROCEDURE bill_workinfodetail_SByType 
	@infoid		int,
	@type		int,
	@flag integer output , 
  	@msg varchar(80) output  
as
	select * from bill_weekinfodetail where infoid=@infoid and type=@type

GO

 CREATE PROCEDURE hrmroles_selectSingle 
 @id int, @flag int output, @msg varchar(80) output as begin select rolesmark,rolesname,docid from hrmroles where id=@id if @@error<>0 begin set @flag=1 set @msg='操作失败' end else begin set @flag=0 set @msg='操作成功' end  end 
GO

 CREATE PROCEDURE hrmroles_selectall 
 @flag integer output, @msg varchar(30) output as begin set nocount on create table #temp( id int, rolesmark varchar(60), rolesname varchar(200), cnt int null ) insert into #temp(id,rolesmark,rolesname) select id,rolesmark,rolesname from hrmroles  declare roles_cursor cursor for select id from hrmroles open roles_cursor declare  @id int,@cnt int fetch next from roles_cursor into @id while @@fetch_status=0 begin select @cnt=count(id) from HrmRoleMembers where roleid=@id update  #temp set cnt=@cnt where id=@id fetch next from roles_cursor into @id end   select id,rolesmark,rolesname,cnt from #temp close roles_cursor deallocate roles_cursor end 
GO

 CREATE PROCEDURE hrmroles_selectbyrole 
 @roleid int, @rolelevel int, @flag int output, @msg varchar(80) output as select resourceid,rolelevel,id from hrmrolemembers where roleid=@roleid and rolelevel=@rolelevel order by rolelevel 
GO

 CREATE PROCEDURE hrmroles_update 
 @id int, @rolesmark varchar(60), @rolesname varchar(200), @docid int, @flag int output, @msg varchar(80) output as if @docid = 0 set @docid = null begin update hrmroles set rolesmark=@rolesmark,rolesname=@rolesname,docid=@docid where id=@id if @@error<>0 begin set @flag=1 set @msg='更新失败' end else begin set @flag=0 set @msg='更新成功' end end 
GO

 CREATE PROCEDURE imagefile_AddByDoc 
 (@fileid 	int, @flag	[int]	output, @msg	[varchar](80)	output)  AS update imagefile set imagefileused=imagefileused+1 where imagefileid= @fileid 
GO

 CREATE PROCEDURE imagefile_DeleteByDoc 
 (@fileid 	int, @flag	[int]	output, @msg	[varchar](80)	output)  AS declare @imagefileused int update imagefile set imagefileused=imagefileused-1 where imagefileid= @fileid select @imagefileused = imagefileused from imagefile where imagefileid= @fileid if @imagefileused = 0 delete from ImageFile where imagefileid = @fileid 
GO

 CREATE PROCEDURE proc_count_addonline 
 @userName Varchar(20), @SessionID varchar(4), @ServerIP Varchar(10), @RemoteIP varchar(10), @UserType varchar(8), @FLAG int output, @MSG varchar(80) output AS Begin   Insert into T_CountUserOnLine(UserName,SessionID,ServerIP,RemoteIP,UserType,Cdate) Values(@UserName,@SessionID,@ServerIP,@RemoteIP,@UserType,getdate())   Select '1'  End 
GO

 CREATE PROCEDURE proc_count_reduceonline 
 @SessionID varchar(30), @ServerIP varchar(10), @RemoteIP varchar(10), @flag int output, @msg varchar(80) output AS Begin  Delete from T_CountUserOnLine where SessionID = @SessionID and ServerIP = @ServerIP and RemoteIP = @RemoteIP   select '1' End 
GO

 CREATE PROCEDURE proc_count_restart 
 @ServerIP varchar(10), @FLAG int output, @msg varchar(80) output as Begin   Delete from T_CountUserOnLine where ServerIP = @ServerIP; Select '1' End 
GO

 CREATE PROCEDURE proc_onlineuser_count 
 @T_UserType varchar(1), @FLAG int output, @MSG varchar(80) output AS  Begin declare @v_count1 int declare @v_count2 int set @FLAG = 0 set @MSG = '存取过程执行成功！' select  @v_count1=count(*) from T_CountUserOnLine where UserType = 'reg' select @v_count2=count(*)  from T_CountUserOnLine where usertype='guest' IF @T_UserType = 'all' Select @v_count1 + @v_count2 ELSe if @T_UserType = 'reg' select @v_count1 ELSe if @T_UserType = 'guest' Select @v_count2 if @@error<>0 begin set @flag=1 set @msg='执行失败' End end 
GO

 CREATE PROCEDURE proc_onlineuser_list 
 @T_UserType Varchar(8), @FLAG  int output, @MSG varchar(80) output AS Begin  if @T_UserType = 'reg' Select distinct 'reg',UserName,null,null,null,null from T_CountUserOnLine where UserType = 'reg' order by username desc; else Select UserType,UserName,SessionID,ServerIP,RemoteIP,convert(datetime,cdate) from T_CountUserOnLine where UserType = 'guest' order by username desc;  End 
GO

 CREATE PROCEDURE systemright_Srightsbygroup 
 @id int, @flag int output, @msg varchar(80) output as begin select rightid from systemrighttogroup where groupid=@id end 
GO

 CREATE PROCEDURE test 
 (@periodsfrom  char(6) , @periodsto     char(6))  AS create table #templedgercount( ledgerid  int , precount  decimal(18,3), lastcount  decimal(18,3) ) declare @thelastperiods  char(6) ,@thenewperiods char(6), @ledgerid int , @precount decimal(18,3) , @lastcount decimal(18,3) select @thelastperiods = max(tranperiods) from FnaAccount where tranperiods < @periodsfrom if @thelastperiods = null  set @thelastperiods = '000000' select @thenewperiods = max(tranperiods) from FnaAccount if @thenewperiods < @periodsto  set @periodsto = @thenewperiods   declare ledgerid_cursor cursor for select id from FnaLedger where supledgerid =0 and ledgergroup ='1' open ledgerid_cursor fetch next from ledgerid_cursor into @ledgerid while @@fetch_status=0 begin set @precount = 0 set @lastcount = 0 select @precount = (-2*convert(int,tranbalance)+3)*tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @thelastperiods select @lastcount = (-2*convert(int,tranbalance)+3)*tranremain  from FnaAccount where ledgerid = @ledgerid and tranperiods= @periodsto  insert into #templedgercount values(@ledgerid,@precount,@lastcount) fetch next from ledgerid_cursor into @ledgerid end close ledgerid_cursor deallocate ledgerid_cursor select * from #templedgercount select @thelastperiods 
GO

 CREATE PROCEDURE workflow_BillValue_Select 
 @requestid	int, @flag integer output , @msg varchar(80) output AS declare @billformid int , @billid int select @billformid = billformid , @billid = billid from workflow_form where requestid=@requestid  if @billformid = 1 select * from bill_itemusage where id = @billid  else if @billformid = 2 select * from LgcStockInOut where id = @billid  else if @billformid = 3 select * from LgcStockInOut where id = @billid  else if @billformid = 4 select * from bill_contract where id = @billid  else if @billformid = 5 select * from Bill_Meetingroom where id = @billid  else if @billformid = 6 select * from Bill_HrmResourcePlan where id = @billid  else if @billformid = 7 select * from Bill_Expense where id = @billid  else if @billformid = 8 select * from Bill_HrmResourceAbsense where id = @billid  else select * from workflow_form where requestid=@requestid 
GO

 CREATE PROCEDURE workflow_CreateNode_Select 
 @workflowid	int, @flag integer output , @msg varchar(80) output AS select nodeid from workflow_flownode where workflowid=@workflowid and nodetype='0' 
GO

 CREATE PROCEDURE workflow_CurrentOperator_I 
    @requestid	int, 
    @userid		int, 
    @groupid	int, 
    @workflowid	int, 
    @workflowtype	int, 
    @usertype	int, 
    @isremark	char(1),
    @flag integer output , 
    @msg varchar(80) output 
    AS 
    insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark)
    values(@requestid,@userid,@groupid, @workflowid,@workflowtype,@usertype,@isremark)

GO


 create  PROCEDURE workflow_FieldForm_Select 
 (
 @nodeid1	int , 
 @flag integer output ,
 @msg varchar(80) output 
)
AS
declare @isbill1 char(1) 

select @isbill1 = a.isbill from workflow_base a, workflow_flownode b 
where a.id = b.workflowid and b.nodeid = @nodeid1 

if @isbill1 = '1' 
SELECT distinct a.* , b.dsporder from workflow_nodeform a, workflow_billfield b where a.fieldid= b.id and  nodeid=@nodeid1 order by b.dsporder
else 
SELECT * from workflow_nodeform  where  nodeid=@nodeid1 order by fieldid 

GO

 CREATE PROCEDURE workflow_FieldID_Select 
  @formid		int, 
  @flag integer output ,
   @msg varchar(80) output 
   AS 
   select fieldid,fieldorder from workflow_formfield where formid=@formid order by fieldid


GO

 CREATE PROCEDURE workflow_FieldLabel_Select 
 @formid		int, @flag integer output , @msg varchar(80) output AS select * from workflow_fieldlable where formid=@formid and isdefault='1' order by fieldid 
GO

 CREATE PROCEDURE workflow_FieldValue_Select 
 @requestid	int, @flag integer output , @msg varchar(80) output AS select * from workflow_form where requestid=@requestid 
GO

 CREATE PROCEDURE workflow_NodeGroup_Select 
 @nodeid	int, @flag integer output , @msg varchar(80) output AS select * from workflow_nodegroup where nodeid=@nodeid order by id 
GO

 CREATE PROCEDURE workflow_NodeGroup_SelectByid 
   @id	int, 
   @flag integer output , 
   @msg varchar(80) output 
   AS 
   select * from workflow_nodegroup where id=@id

GO

 CREATE PROCEDURE workflow_NodeLink_SPasstime 
  @nodeid	int, 
  @nodepasstime	float, 
  @flag integer output , 
  @msg varchar(80) output 
  AS 
  select min(nodepasstime) as nodepasstime from workflow_nodelink where nodeid=@nodeid and nodepasstime>@nodepasstime  

GO

 CREATE PROCEDURE workflow_NodeLink_Select 
  @nodeid	int, 
  @isreject	char(1), 
  @flag integer output , 
  @msg varchar(80) output 
  AS 
  if @isreject<>'1'  set @isreject='' 
  select * from workflow_nodelink where nodeid=@nodeid and isreject=@isreject 
order by nodepasstime ,id
GO

 CREATE PROCEDURE workflow_NodeType_Select 
 @workflowid	int, @nodeid	int, @flag integer output , @msg varchar(80) output AS select nodetype from workflow_flownode where workflowid=@workflowid and nodeid=@nodeid 
GO

 CREATE PROCEDURE workflow_Nodebase_SelectByID 
 @nodeid	int, @flag integer output , @msg varchar(80) output AS select * from workflow_nodebase where id=@nodeid 
GO

 CREATE PROCEDURE workflow_RequestID_Update 
 @flag integer output , @msg varchar(80) output AS update workflow_requestsequence set requestid=requestid+1  select requestid from workflow_requestsequence 
GO

 CREATE PROCEDURE workflow_RequestLog_Insert 
  @requestid	int, 
  @workflowid	int, 
  @nodeid	int, 
  @logtype	char(1), 
  @operatedate	char(10), 
  @operatetime	char(8), 
  @operator	int, 
  @remark	text, 
  @clientip	char(15), 
  @operatortype	int, 
  @destnodeid	int, 
  @flag integer output , 
  @msg varchar(80) output 
  AS
  declare @count integer

  if @logtype = '1'
	begin
	select @count = count(*) from workflow_requestlog 
	where requestid=@requestid and nodeid=@nodeid and logtype=@logtype 
	and operator = @operator and operatortype = @operatortype

	if @count > 0 
		begin
		update workflow_requestlog 
		SET	 [operatedate]	 = @operatedate,
			 [operatetime]	 = @operatetime,
			 [remark]	 = @remark,
			 [clientip]	 = @clientip,
			 [destnodeid]	 = @destnodeid 

		WHERE 
			( [requestid]	 = @requestid AND
			 [nodeid]	 = @nodeid AND
			 [logtype]	 = @logtype AND
			 [operator]	 = @operator AND
			 [operatortype]	 = @operatortype)
		end
	else
		begin
		insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid)
		values(@requestid,@workflowid,@nodeid,@logtype, @operatedate,@operatetime,@operator, @remark,@clientip,@operatortype,@destnodeid)
		end
	end
   else 
	begin
	 if @logtype = '1'
		delete workflow_requestlog where requestid=@requestid and nodeid=@nodeid and (logtype='1' or logtype='7')  
		and operator = @operator and operatortype = @operatortype
	
	insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid)
	values(@requestid,@workflowid,@nodeid,@logtype, @operatedate,@operatetime,@operator, @remark,@clientip,@operatortype,@destnodeid)
	
	end



GO

 CREATE PROCEDURE workflow_RequestLog_SBUser 
	@requestid	int, 
	@operator int ,
	@operatortype int ,
	@logtype char(1) ,
	@flag integer output , 
	@msg varchar(80) output 
AS 
select * from workflow_requestlog 
where requestid=@requestid and operator=@operator 
and operatortype=@operatortype and logtype=@logtype

GO

 CREATE PROCEDURE workflow_RequestLog_SNSave 
 @requestid	int,
 @flag integer output , 
 @msg varchar(80) output 
 AS 
 
 select  t1.*, t2.nodename 
 from workflow_requestlog t1,workflow_nodebase t2 
 where requestid=@requestid and t1.nodeid=t2.id and 
 t1.logtype != '1' 
 order by operatedate desc,operatetime desc

GO

 CREATE PROCEDURE workflow_RequestLog_SNSRemark 
 @requestid	int,
 @flag integer output , 
 @msg varchar(80) output 
 AS 
 
 select  t1.*, t2.nodename 
 from workflow_requestlog t1,workflow_nodebase t2 
 where requestid=@requestid and t1.nodeid=t2.id and 
 t1.logtype != '1' and t1.logtype != '7' 
 order by operatedate desc,operatetime desc

GO

 CREATE PROCEDURE workflow_RequestLog_Select 
 @requestid	int, @flag integer output , @msg varchar(80) output AS select t1.*,t2.nodename from workflow_requestlog t1,workflow_nodebase t2 where requestid=@requestid and t1.nodeid=t2.id order by operatedate desc,operatetime desc 
GO

 CREATE PROCEDURE workflow_RequestRemark_Delete 
 @requestid	int, @userid		int, @isremark	char(1), @flag	int output, @msg	varchar(80) output AS delete from workflow_currentoperator where requestid=@requestid and userid=@userid and isremark=@isremark 
GO

 CREATE PROCEDURE workflow_RequestRemark_Insert 
	@requestid	int,
	@userid		int,
	@groupid	int,
	@workflowid	int,
	@workflowtype	int,
	@isremark	char(1),
	@usertype	char(1),
	@flag	int output,
	@msg	varchar(80) output
AS
	insert into workflow_currentoperator
	(requestid,userid,groupid,workflowid,workflowtype,isremark,usertype)
	values
	(@requestid,@userid,@groupid,@workflowid,@workflowtype,@isremark,@usertype)

GO

 CREATE PROCEDURE workflow_RequestRemark_SByUser 
	@requestid	int,
	@userid		int,
	@isremark	char(1),
	@flag	int output,
	@msg	varchar(80) output
AS
	select * from workflow_currentoperator
	where requestid=@requestid and userid=@userid and isremark=@isremark

GO

 CREATE PROCEDURE workflow_RequestRemark_Select 
 @requestid	int, @isremark	char(1), @flag	int output, @msg	varchar(80) output AS select userid from workflow_currentoperator where requestid=@requestid and isremark=@isremark 
GO

 CREATE PROCEDURE workflow_RUserDefault_Insert 
  @userid	int, 
  @selectedworkflow text,
  @isuserdefault    char(1),
  @flag integer output , 
  @msg varchar(80) output 
AS 
  insert into workflow_requestUserdefault values(@userid,@selectedworkflow,@isuserdefault)

GO

 CREATE PROCEDURE workflow_RUserDefault_Select 
  @userid	int, 
  @flag integer output , 
  @msg varchar(80) output 
AS 
  select * from workflow_requestUserdefault where userid=@userid

GO

 CREATE PROCEDURE workflow_RUserDefault_Update 
  @userid	int, 
  @selectedworkflow text,
  @isuserdefault    char(1),
  @flag integer output , 
  @msg varchar(80) output 
AS 
  Update workflow_requestUserdefault set selectedworkflow=@selectedworkflow,isuserdefault=@isuserdefault
  where userid=@userid

GO

 CREATE PROCEDURE workflow_RequestViewLog_Insert 
   @id	int, 
   @viewer	int, 
   @viewdate	char(10), 
   @viewtime	char(8), 
   @clientip	char(15), 
   @viewtype 	int,
   @currentnodeid	int,
   @flag integer output , 
   @msg varchar(80) output
    AS insert into workflow_requestviewlog (id,viewer, viewdate,viewtime,ipaddress,viewtype,currentnodeid)
    values(@id,@viewer, @viewdate,@viewtime,@clientip,@viewtype,@currentnodeid)

GO

 CREATE PROCEDURE workflow_Requestbase_Delete 
 @requestid	int, @flag integer output , @msg varchar(80) output as update workflow_requestbase set deleted=1 where requestid=@requestid 
GO

 CREATE PROCEDURE workflow_Requestbase_Insert 
   @requestid	int, 
   @workflowid	int, 
   @lastnodeid	int, 
   @lastnodetype	char(1), 
   @currentnodeid	int, 
   @currentnodetype	char(1), 
   @status		varchar(50), 
   @passedgroups	int, 
   @totalgroups	int, 
   @requestname	varchar(255), 
   @creater	int, 
   @createdate	char(10), 
   @createtime	char(8), 
   @lastoperator	int, 
   @lastoperatedate	char(10), 
   @lastoperatetime	char(8), 
   @deleted	int, 
   @creatertype	int, 
   @lastoperatortype	int, 
   @nodepasstime	float, 
   @nodelefttime	float, 
   @docids 		[text],
   @crmids 		[text],
   @hrmids 		[text],
   @prjids 		[text],
   @cptids 		[text],
   @flag integer output , 
   @msg varchar(80) output 
   AS 
   insert into workflow_requestbase (requestid,workflowid,lastnodeid,lastnodetype, currentnodeid,currentnodetype,status, passedgroups,totalgroups,requestname, creater,createdate,createtime,lastoperator, lastoperatedate,lastoperatetime,deleted,creatertype,lastoperatortype,nodepasstime,nodelefttime,docids,crmids,hrmids,prjids,cptids) 
   values(@requestid,@workflowid,@lastnodeid,@lastnodetype, @currentnodeid,@currentnodetype,@status, @passedgroups,@totalgroups,@requestname, @creater,@createdate,@createtime,@lastoperator, @lastoperatedate,@lastoperatetime,@deleted,@creatertype,@lastoperatortype,@nodepasstime,@nodelefttime,@docids,@crmids,@hrmids,@prjids,@cptids)   

GO

 CREATE PROCEDURE workflow_Requestbase_SByID 
 @requestid	int, @flag integer output , @msg varchar(80) output AS select * from workflow_requestbase where requestid=@requestid 
GO

 CREATE PROCEDURE workflow_Requestbase_Update 
  @requestid	int, 
  @workflowid	int, 
  @lastnodeid	int, 
  @lastnodetype	char(1), 
  @currentnodeid	int, 
  @currentnodetype	char(1), 
  @status		varchar(50), 
  @passedgroups	int, 
  @totalgroups	int, 
  @requestname	varchar(255), 
  @creater	int, 
  @createdate	char(10), 
  @createtime	char(8), 
  @lastoperator	int, 
  @lastoperatedate	char(10), 
  @lastoperatetime	char(8),
   @deleted	int, 
   @creatertype	int, 
   @lastoperatortype	int, 
    @nodepasstime	float, 
   @nodelefttime	float, 
   @docids 		[text],
   @crmids 		[text],
   @hrmids 		[text],
   @prjids 		[text],
   @cptids 		[text],
   @flag integer output , 
   @msg varchar(80) output 
   AS update workflow_requestbase set 
   workflowid=@workflowid, 
   lastnodeid=@lastnodeid, 
   lastnodetype=@lastnodetype, 
   currentnodeid=@currentnodeid, 
   currentnodetype=@currentnodetype, 
   status=@status, 
   passedgroups=@passedgroups, 
   totalgroups=@totalgroups, 
   requestname=@requestname, 
   creater=@creater, 
   createdate=@createdate, 
   createtime=@createtime, 
   lastoperator=@lastoperator, 
   lastoperatedate=@lastoperatedate, 
   lastoperatetime=@lastoperatetime, 
   deleted=@deleted ,
   creatertype=@creatertype,
   lastoperatortype=@lastoperatortype,
   nodepasstime=@nodepasstime,
   nodelefttime=@nodelefttime,
   docids=@docids,
   crmids=@crmids,
   hrmids=@hrmids,
   prjids=@prjids,
   cptids=@cptids
   where requestid=@requestid

GO

 CREATE PROCEDURE workflow_Rbase_UpdateLevel 
  @requestid	int, 
  @level_n        int,
  @flag integer output , 
  @msg varchar(80) output 
AS 
  Update workflow_requestbase set requestlevel=@level_n where requestid=@requestid

GO

 CREATE PROCEDURE workflow_SelectItemSByvalue 
  (@id_1 varchar(100) , 
  @isbill_2 varchar(100) , 
  @selectvalue_3 integer ,
  @flag integer output , 
  @msg varchar(80) output )
  AS 
  select * from workflow_SelectItem where fieldid = @id_1 and isbill = @isbill_2 and selectvalue = @selectvalue_3


GO

 CREATE PROCEDURE workflow_SelectItemSelectByid 
  @id varchar(100) , 
  @isbill varchar(100) , 
  @flag integer output , 
  @msg varchar(80) output 
  AS 
  select * from workflow_SelectItem where fieldid = @id and isbill = @isbill
  set  @flag = 0 set  @msg = ''


GO

 CREATE PROCEDURE workflow_SelectItem_DByFieldid 
	(@fieldid 		int,
	 @isbill 		int,
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	delete from workflow_selectitem where fieldid=@fieldid and isbill=@isbill

GO

 CREATE PROCEDURE workflow_SelectItem_Insert 
	(@fieldid 		int,
	 @isbill 		int,
	 @selectvalue 	int,
	 @selectname 	varchar(250),
	 @flag integer output,
	 @msg varchar(80) output)
AS 
	insert into workflow_selectitem(fieldid,isbill,selectvalue,selectname)
	values(@fieldid,@isbill,@selectvalue,@selectname)

GO

 CREATE PROCEDURE workflow_Workflowbase_SByID 
 @workflowid	int, @flag integer output , @msg varchar(80) output AS select * from workflow_base where id=@workflowid 
GO

 CREATE PROCEDURE workflow_addinoperate_Delete 
	(@id_1 	[int],
@flag integer output,
	 @msg varchar(80) output)

AS DELETE [workflow_addinoperate] 

WHERE 
	( [id]	 = @id_1)
GO

 CREATE PROCEDURE workflow_addinoperate_Insert 
	(@objid_1 	[int],
	 @isnode_2 	[int],
	 @workflowid_3 	[int],
	 @fieldid_4 	[int],
	 @fieldop1id_5 	[int],
	 @fieldop2id_6 	[int],
	 @operation_7 	[int],
	 @customervalue_8 	[varchar](255),
	 @rules_9 	[int],
@flag integer output,
	 @msg varchar(80) output
)

AS INSERT INTO [workflow_addinoperate] 
	 ( [objid],
	 [isnode],
	 [workflowid],
	 [fieldid],
	 [fieldop1id],
	 [fieldop2id],
	 [operation],
	 [customervalue],
	 [rules]) 
 
VALUES 
	( @objid_1,
	 @isnode_2,
	 @workflowid_3,
	 @fieldid_4,
	 @fieldop1id_5,
	 @fieldop2id_6,
	 @operation_7,
	 @customervalue_8,
	 @rules_9)
GO

 CREATE PROCEDURE workflow_addinoperate_select 
	(@id 	int,
	@isnode 	int,
	@flag integer output,
	 @msg varchar(80) output)
AS 
	select * from workflow_addinoperate where objid=@id and isnode=@isnode order by id


GO

 CREATE PROCEDURE workflow_base_SelectByFormid 
	(@formid	int,
	 @isbill	char(1),
	 @flag integer output,
	 @msg varchar(80) output)
AS
	select * from workflow_base where formid=@formid and isbill=@isbill

GO

 CREATE PROCEDURE workflow_base_SelectByType 
 @workflowtypeid	int, @flag integer output , @msg varchar(80) output AS select * from workflow_base where workflowtype=@workflowtypeid 
GO

 CREATE PROCEDURE workflow_billfield_Select 
@formid		int, 
@flag integer output , 
@msg varchar(80) output 
AS 
select * from workflow_billfield where billid=@formid order by dsporder
GO

 CREATE PROCEDURE workflow_billfield_SelectByID 
 @id		int, @flag integer output , @msg varchar(80) output AS select * from workflow_billfield where id=@id 
GO

 CREATE PROCEDURE workflow_createrlist_Delete 
	(@workflowid_1 	[int],
   @flag integer output , 
   @msg varchar(80) output )

AS DELETE [workflow_createrlist] 

WHERE 
	( [workflowid]	 = @workflowid_1)
GO

 CREATE PROCEDURE workflow_createrlist_Insert 
	(@workflowid_1 	[int],
	 @userid_2 	[int],
	 @usertype_3 	[int],
   @flag integer output , 
   @msg varchar(80) output )

AS INSERT INTO [workflow_createrlist] 
	 ( [workflowid],
	 [userid],
	 [usertype]) 
 
VALUES 
	( @workflowid_1,
	 @userid_2,
	 @usertype_3)
GO

 CREATE PROCEDURE workflow_currentoperator_SByUs 
  @userid		int, 
  @usertype		int, 
  @requestid	int, 
  @flag integer output , 
  @msg varchar(80) output  
  as 
  select * from workflow_currentoperator where requestid=@requestid and userid=@userid and usertype = @usertype

GO

 CREATE PROCEDURE workflow_currentoperator_SWf 
  @userid		int, 
@usertype	int, 
  @complete	int, 
  @flag integer output , 
  @msg varchar(80) output  
  as 
  if @complete=0 
  begin 
  select count( distinct t1.requestid) workflowcount,t1.workflowid from workflow_currentoperator t1,workflow_requestbase t2 where t1.isremark in( '0','1') and t1.userid=@userid and t1.usertype=@usertype and t1.requestid=t2.requestid and t2.deleted=0 and t2.currentnodetype<>'3' group by t1.workflowid 
  end 
  if @complete=1 begin select count( distinct t1.requestid) workflowcount,t1.workflowid from workflow_currentoperator t1,workflow_requestbase t2 where t1.userid=@userid and t1.usertype=@usertype and t1.requestid=t2.requestid and t2.deleted=0 and t2.currentnodetype='3' group by t1.workflowid 
  end
GO

 CREATE PROCEDURE workflow_currentoperator_SWft 
  @userid		int,
@usertype	int, 
   @complete	int, @flag integer output ,
    @msg varchar(80) output  
    as 
    if @complete=0 
    begin 
    select count(distinct t1.requestid) typecount,t1.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 where t1.userid=@userid and t1.isremark in( '0','1') and t1.usertype=@usertype and t1.requestid=t2.requestid and t2.deleted=0 and t2.currentnodetype<>'3' group by t1.workflowtype 
    end 
    if @complete=1 
    begin 
    select count(distinct t1.requestid) typecount,t1.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 where t1.userid=@userid and t1.usertype=@usertype and t1.requestid=t2.requestid and t2.deleted=0 and t2.currentnodetype='3' group by t1.workflowtype 
    end
GO

/* 8.21 */
 CREATE PROCEDURE workflow_form_SByRequestid 
	(@requestid 	int,
	@flag integer output,
	 @msg varchar(80) output)
AS 
	select * from workflow_form where requestid=@requestid

GO

 CREATE PROCEDURE workflow_groupdetail_DbyGroup 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output )  AS DELETE [workflow_groupdetail]  WHERE ( [groupid]	 = @id_1) set @flag = 0 set @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE workflow_groupdetail_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output )  AS DELETE [workflow_groupdetail]  WHERE ( [id]	 = @id_1) set @flag = 0 set @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE workflow_groupdetail_Insert 
  (@groupid_1 	[int], 
  @type_2 	[int], 
  @objid_3 	[int], 
  @level_4 	[int], 
  @flag integer output ,
   @msg varchar(80) output ) 
    AS 
    INSERT INTO [workflow_groupdetail] ( [groupid], [type], [objid], [level_n])  VALUES ( @groupid_1, @type_2, @objid_3, @level_4) 
    set @flag = 0 set @msg = '????????' 

GO

 CREATE PROCEDURE workflow_groupdetail_SByGroup 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [workflow_groupdetail] WHERE ( [groupid]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE workflow_nodegroup_Delete 
 (@id_1 	[int], @flag integer output , @msg varchar(80) output )  AS DELETE [workflow_nodegroup]  WHERE ( [id]	 = @id_1) set @flag = 0 set @msg = '查询存储过程成功' 
GO

 CREATE PROCEDURE workflow_requestbase_SByUser 
 @userid		int, @wftype	int, @workflowid	int, @complete	int, @flag integer output , @msg varchar(80) output AS  if @wftype<>0 begin  if @complete=0  select  t1.* from workflow_requestbase t1,workflow_base t2 where t1.creater = @userid and t1.workflowid=t2.id and t2.workflowtype = @wftype and t1.deleted=0 and t1.currentnodetype<>'3' order by t1.createdate desc,t1.createtime desc  if @complete=1 select  t1.* from workflow_requestbase t1,workflow_base t2 where t1.creater = @userid and t1.workflowid=t2.id and t2.workflowtype = @wftype and t1.deleted=0 and t1.currentnodetype= '3' order by t1.createdate desc,t1.createtime desc  end  else if @wftype=0 and @workflowid<>0 begin  if @complete=0 select * from workflow_requestbase where creater = @userid and workflowid = @workflowid and deleted=0 and currentnodetype<>'3' order by createdate desc,createtime desc  if @complete=1 select * from workflow_requestbase where creater = @userid and workflowid = @workflowid and deleted=0 and currentnodetype='3' order by createdate desc,createtime desc  end 
GO

 CREATE PROCEDURE workflow_requestbase_SWftype 
@userid		int, 
@usertype	int,
@complete	int, 
@flag integer output , 
@msg varchar(80) output  

as 

if @complete=0 
begin 
select count(distinct t1.requestid) typecount,t2.workflowtype 
from workflow_requestbase t1, workflow_base t2 
where t1.creater = @userid and t1.creatertype=@usertype and t1.workflowid=t2.id and t1.deleted=0 and t1.currentnodetype<>'3' 
group by t2.workflowtype 
end 

if @complete=1 
begin 
select count(distinct t1.requestid) typecount,t2.workflowtype 
from workflow_requestbase t1, workflow_base t2 
where t1.creater = @userid and t1.creatertype=@usertype and t1.workflowid=t2.id and t1.deleted=0 and t1.currentnodetype='3' 
group by t2.workflowtype 
end


GO

 CREATE PROCEDURE workflow_requestbase_Select 
  @userid		int, 
  @wftype	int, 
  @workflowid	int, 
  @complete	int, 
  @flag integer output , 
  @msg varchar(80) output  
  AS 
  if @wftype<>0 
  begin 
  if @complete=0 
  select distinct t1.requestid,t1.requestname,t1.workflowid,t1.lastoperatedate,t1.lastoperatetime,t1.lastoperator,t1.status,t1.createdate,t1.createtime from workflow_requestbase t1,workflow_currentoperator t2 where t2.userid=@userid and t1.requestid=t2.requestid and t2.workflowtype=@wftype and t2.isremark in ('0','1') and t1.deleted=0 and t1.currentnodetype<>'3' order by t1.createdate desc,t1.createtime desc 
  if @complete=1 
  select distinct t1.requestid,t1.requestname,t1.workflowid,t1.lastoperatedate,t1.lastoperatetime,t1.lastoperator,t1.status,t1.createdate,t1.createtime from workflow_requestbase t1,workflow_currentoperator t2 where t2.userid=@userid and t1.requestid=t2.requestid and t2.workflowtype=@wftype and t2.isremark='0' and t1.deleted=0 and t1.currentnodetype='3' order by t1.createdate desc,t1.createtime desc 
  end 
  else if @wftype=0 and @workflowid<>0 
  begin 
  if @complete=0 
  select distinct t1.requestid,t1.requestname,t1.workflowid,t1.lastoperatedate,t1.lastoperatetime,t1.lastoperator,t1.status,t1.createdate,t1.createtime from workflow_requestbase t1,workflow_currentoperator t2 where t2.userid=@userid and t1.requestid=t2.requestid and t2.workflowid=@workflowid and t2.isremark in ('0','1') and t1.deleted=0 and t1.currentnodetype<>'3' order by t1.createdate desc,t1.createtime desc 
  if @complete=1 
  select distinct t1.requestid,t1.requestname,t1.workflowid,t1.lastoperatedate,t1.lastoperatetime,t1.lastoperator,t1.status,t1.createdate,t1.createtime from workflow_requestbase t1,workflow_currentoperator t2 where t2.userid=@userid and t1.requestid=t2.requestid and t2.workflowid=@workflowid and t2.isremark='0' and t1.deleted=0 and t1.currentnodetype='3' order by t1.createdate desc,t1.createtime desc 
  end
GO

 CREATE PROCEDURE workflow_requestbase_SelectWf 
@userid		int, 
@usertype	int, 
@complete	int, 
@flag integer output , 
@msg varchar(80) output  
as 

if @complete=0 
begin 
select count( distinct requestid) workflowcount, workflowid 
from workflow_requestbase 
where creater = @userid and creatertype = @usertype and deleted=0 and currentnodetype<>'3' 
group by workflowid 
end 

if @complete=1 
begin 
select count( distinct requestid) workflowcount, workflowid 
from workflow_requestbase 
where creater = @userid and creatertype = @usertype and deleted=0 and currentnodetype='3' 
group by workflowid  
end


GO

 CREATE PROCEDURE workflow_wftype_Insert 
  (@typename_1 	[varchar](60), 
  @typedesc_2 	[varchar](100), 
  @dsporder	[int],
  @flag	[int]	output, 
  @msg	[varchar](80)	output) 
   AS 
   INSERT INTO [workflow_type] ( [typename], [typedesc],[dsporder])  
   VALUES ( @typename_1, @typedesc_2,@dsporder)

GO

 CREATE PROCEDURE workflow_wftype_SelectByID 
 (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [workflow_type] WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE workflow_wftype_Update 
   (@id	 	[int], 
   @typename 	[varchar](60), 
   @typedesc 	[varchar](100),
   @dsporder	[int],
   @flag	[int]	output, 
   @msg	[varchar](80)	output)  
   AS
   UPDATE [workflow_type]  SET  [typename] = @typename, [typedesc] = @typedesc ,[dsporder] = @dsporder 
   WHERE ( [id]	 = @id) 

GO


/* 人力资源招聘 */

create procedure HrmCareerApply_U
 (@ischeck [char](1), @ishire		[char](1), @careerid	[int], 
 @firstname_2 	[varchar](60), @lastname_3 	[varchar](60), @titleid_4 	[int], 
 @sex_5 	[char](1), @birthday_6 	[char](10), @nationality_7 	[int],
 @defaultlanguage_8 	[int], @certificatecategory_9 	[varchar](30), @certificatenum_10 	[varchar](60), 
 @nativeplace_11 	[varchar](100), @educationlevel_12 	[char](1), @bememberdate_13 	[char](10), 
 @bepartydate_14 	[char](10), @bedemocracydate_15 	[char](10), @regresidentplace_16 	[varchar](60),
 @healthinfo_17 	[char](1), @residentplace_18 	[varchar](60), @policy_19 	[varchar](30), 
 @degree_20 	[varchar](30), @height_21 	[varchar](10), @homepage_22 	[varchar](100), 
 @maritalstatus_23 	[char](1), @marrydate_24 	[char](10), @train_25 	[text], @NumberId varchar(30), @email_26 	[varchar](60), 
 @homeaddress_27 	[varchar](100), @homepostcode_28 	[varchar](20), @homephone_29 	[varchar](60),
 @category_3 	[char](1), @contactor_4 	[varchar](30), @major_5 	[varchar](60), 
 @salarynow_6 	[varchar](60), @worktime_7 	[varchar](10), @salaryneed_8 	[varchar](60), 
 @currencyid_9 	[int], @reason_10 	[varchar](200), @otherrequest_11 	[varchar](200), 
 @selfcomment_12 	[text], @createdate		[char](10), @id_1 	[int],  @flag integer output, @msg varchar(80) output) 
 AS if @nationality_7=0 set @nationality_7= null 
 if @defaultlanguage_8=0 set @defaultlanguage_8= null  
 UPDATE [HrmCareerApply] SET
ischeck=@ischeck, ishire=@ishire, 
[careerid]=@careerid, [firstname]=@firstname_2, [lastname]=@lastname_3,
[titleid]=@titleid_4, [sex]=@sex_5, [birthday]=@birthday_6, 
[nationality]=@nationality_7, [defaultlanguage]=@defaultlanguage_8, [certificatecategory]=@certificatecategory_9,
[certificatenum]=@certificatenum_10, [nativeplace]=@nativeplace_11, [educationlevel]=@educationlevel_12,
[bememberdate]=@bememberdate_13, [bepartydate]=@bepartydate_14, [bedemocracydate]=@bedemocracydate_15,
[regresidentplace]=@regresidentplace_16, [healthinfo]=@healthinfo_17, [residentplace]=@residentplace_18, 
[policy]=@policy_19, [degree]=@degree_20, [height]=@height_21, [homepage]=@homepage_22, 
[maritalstatus]=@maritalstatus_23, [marrydate]=@marrydate_24, [train]=@train_25, NumberId=@NumberId,
[email]=@email_26, [homeaddress]=@homeaddress_27, [homepostcode]=@homepostcode_28, 
[homephone]=@homephone_29, createrid=@id_1, createdate=@createdate  WHERE [id]=@id_1

update [HrmCareerApplyOtherInfo] set
 
[category]=@category_3, 
[contactor]=@contactor_4, 
[major]=@major_5, 
[salarynow]=@salarynow_6, 
[worktime]=@worktime_7, 
[salaryneed]=@salaryneed_8, 
[currencyid]=@currencyid_9, 
[reason]=@reason_10, 
[otherrequest]=@otherrequest_11,
 [selfcomment]=@selfcomment_12
 where [applyid]=@id_1

go

  alter PROCEDURE [HrmCareerApply_Insert] 
  (@id_1 	[int], @ischeck [char](1), @ishire		[char](1), @careerid	[int], @firstname_2 	[varchar](60), 
  @lastname_3 	[varchar](60), @titleid_4 	[int], @sex_5 	[char](1), @birthday_6 	[char](10), @nationality_7 	[int],
  @defaultlanguage_8 	[int], @certificatecategory_9 	[varchar](30), @certificatenum_10 	[varchar](60), 
  @nativeplace_11 	[varchar](100), @educationlevel_12 	[char](1), @bememberdate_13 	[char](10),
  @bepartydate_14 	[char](10), @bedemocracydate_15 	[char](10), @regresidentplace_16 	[varchar](60),
  @healthinfo_17 	[char](1), @residentplace_18 	[varchar](60), @policy_19 	[varchar](30), @degree_20 	[varchar](30), 
  @height_21 	[varchar](10), @homepage_22 	[varchar](100), @maritalstatus_23 	[char](1), @marrydate_24 	[char](10),
  @train_25 	[text], @numberid [varchar](30), @email_26 	[varchar](60), @homeaddress_27 	[varchar](100), @homepostcode_28 	[varchar](20), 
  @homephone_29 	[varchar](60), @category_3 	[char](1), @contactor_4 	[varchar](30), @major_5 	[varchar](60), 
  @salarynow_6 	[varchar](60), @worktime_7 	[varchar](10), @salaryneed_8 	[varchar](60), @currencyid_9 	[int], 
  @reason_10 	[varchar](200), @otherrequest_11 	[varchar](200), @selfcomment_12 	[text], @createdate		[char](10),
  @flag integer output, @msg varchar(80) output)  AS if @nationality_7=0 set @nationality_7= null 
  if @defaultlanguage_8=0 set @defaultlanguage_8= null  INSERT INTO [HrmCareerApply] 
  ( [id], ischeck, ishire, [careerid], [firstname], [lastname], [titleid], [sex], [birthday], [nationality],
  [defaultlanguage], [certificatecategory], [certificatenum], [nativeplace], [educationlevel], [bememberdate], 
  [bepartydate], [bedemocracydate], [regresidentplace], [healthinfo], [residentplace], [policy], [degree], [height],
  [homepage], [maritalstatus], [marrydate], [train],[NumberId], [email], [homeaddress], [homepostcode], [homephone], createrid, 
  createdate)  VALUES ( @id_1, @ischeck, @ishire, @careerid, @firstname_2, @lastname_3, @titleid_4, @sex_5, @birthday_6,
  @nationality_7, @defaultlanguage_8, @certificatecategory_9, @certificatenum_10, @nativeplace_11, @educationlevel_12,
  @bememberdate_13, @bepartydate_14, @bedemocracydate_15, @regresidentplace_16, @healthinfo_17, @residentplace_18,
  @policy_19, @degree_20, @height_21, @homepage_22, @maritalstatus_23, @marrydate_24, @train_25, @numberid, @email_26, @homeaddress_27, @homepostcode_28, @homephone_29, @id_1, @createdate)  INSERT INTO [HrmCareerApplyOtherInfo] ([applyid], [category], [contactor], [major], [salarynow], [worktime], [salaryneed], [currencyid], [reason], [otherrequest], [selfcomment])  VALUES ( @id_1, @category_3, @contactor_4, @major_5, @salarynow_6, @worktime_7, @salaryneed_8, @currencyid_9, @reason_10, @otherrequest_11, @selfcomment_12)
GO

create  procedure HrmShare_Insert
(@hrmid int,
@applyid int,
@flag integer output,
@msg varchar(80) output)
as
DECLARE	@count integer
select @count=count(*) from HrmShare where hrmid= @hrmid and applyid= @applyid
IF @count > 0 return
INSERT INTO HrmShare (hrmid,applyid) values (@hrmid, @applyid)
go


create procedure HrmShare_SelectByHrmApply
(
@hrmid int,
@applyid int,
@flag integer output,
@msg varchar(80) output)
as
select * from HrmShare where hrmid=@hrmid and applyid=@applyid
go

create procedure HrmShare_SelectByApply
(
@applyid int,
@flag integer output,
@msg varchar(80) output)
as
select * from HrmShare where applyid=@applyid
go

create procedure HrmShare_Delete
(
@hrmid int,
@applyid int,
@flag integer output,
@msg varchar(80) output)
as
delete  from HrmShare where hrmid=@hrmid and applyid=@applyid


go

create procedure HrmCareerApply_SelectId
(
@id int,
@flag integer output,
@msg varchar(80) output)
as
select firstname, lastname from HrmCareerApply where id=@id
go

