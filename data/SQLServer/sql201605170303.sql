alter table meeting alter column address varchar(200)
GO
alter table meeting alter column ck_address varchar(200)
GO
alter table meeting alter column customizeAddress varchar(400)
GO
alter table meeting alter column desc_n text
GO
alter table meeting alter column begindate varchar(10)
GO
alter table meeting alter column begintime varchar(8)
GO
alter table meeting alter column enddate varchar(10)
GO
alter table meeting alter column endtime varchar(8)
GO
alter table meeting alter column createdate varchar(10)
GO
alter table meeting alter column createtime varchar(8)
GO
alter table meeting alter column approvedate varchar(10)
GO
alter table meeting alter column approvetime varchar(8)
GO
alter table meeting alter column decisiondate varchar(10)
GO
alter table meeting alter column decisiontime varchar(8)
GO
alter table meeting alter column rptWeekDays varchar(400)
GO
alter table meeting alter column repeatbegindate varchar(10)
GO
alter table meeting alter column repeatenddate varchar(10)
GO

alter table bill_meeting alter column address varchar(200)
GO
alter table bill_meeting alter column begindate char(10)
GO
alter table bill_meeting alter column begintime char(8)
GO
alter table bill_meeting alter column enddate char(10)
GO
alter table bill_meeting alter column endtime char(8)
GO
alter table bill_meeting alter column approvedate char(10)
GO
alter table bill_meeting alter column customizeaddress varchar(400)
GO
alter table bill_meeting alter column rptweekdays varchar(400)
GO
alter table bill_meeting alter column services text
GO

update meeting_formfield set fielddbtype='varchar(200)',type=184 where fieldname='address'
GO
update meeting_formfield set fielddbtype='text' where fieldname='desc_n'
GO
update meeting_formfield set fielddbtype='text' where fieldname='crmids'
GO
update workflow_billfield set fielddbtype='text' where billid=85 and fieldname='crmids'
GO
delete from workflow_browserurl where id=184
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 184,24168,'varchar(400)','/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutilMeetingRoomBrowser.jsp?selectedids=','MeetingRoom','name','id','/meeting/Maint/MeetingRoom.jsp?id=')
GO
IF NOT EXISTS(SELECT * FROM syscolumns WHERE [ID] = object_id(N'meetingroom') AND [NAME] = N'images')
ALTER TABLE meetingroom ADD images varchar(300)
GO 
IF NOT EXISTS(SELECT * FROM syscolumns WHERE [ID] = object_id(N'meetingroom') AND [NAME] = N'hrmids')
ALTER TABLE meetingroom ADD hrmids varchar(300)
GO 
update meetingroom set hrmids=hrmid
GO
update workflow_billfield set type=184 where type=87 and billid=85
GO
if exists (select * from dbo.sysobjects  where id =object_id(N'P_updateAddress') and OBJECTPROPERTY(id, N'IsProcedure')= 1)
BEGIN
print 'drop P_updateAddress'
drop PROCEDURE P_updateAddress
END
GO
create PROCEDURE P_updateAddress
AS
declare @billid int,@tablename VARCHAR(2000),@strsql VARCHAR(2000);
DECLARE rs CURSOR FOR SELECT billid,tablename FROM  meeting_bill where defined=1 and billid<>85;
OPEN rs;
FETCH NEXT FROM rs INTO @billid,@tablename;
 WHILE @@fetch_status = 0
 BEGIN
	print @billid
	print @tablename

	set  @strsql='alter table '+ @tablename+' add address_new_tmp varchar(200)'
  EXEC(@strsql)

	set @strsql='update '+ @tablename+' set address_new_tmp=address'
	EXEC(@strsql)

  set @strsql='alter table '+ @tablename+' drop column  address'
 	EXEC(@strsql) 

  set @strsql= @tablename+'.address_new_tmp' 
  exec sp_rename @strsql,'address','COLUMN'

	set @strsql='alter table '+ @tablename+' alter column desc_n text'
  EXEC(@strsql)

	set @strsql='update workflow_billfield set fielddbtype=''text'' where fieldname=''crmids'' and billid='+convert(varchar,@billid)
  exec(@strsql)
	
	set @strsql='update workflow_billfield set fielddbtype=''text'' where fieldname=''desc_n'' and billid='+convert(varchar,@billid)
  exec(@strsql)
  
  set @strsql='update workflow_billfield set fielddbtype=''varchar(200)'' ,type=184 where fieldname=''address'' and billid='+convert(varchar,@billid)
  exec(@strsql)
  
  fetch next from rs into @billid,@tablename
END
CLOSE rs
deallocate  rs;
GO
EXEC P_updateAddress
GO
drop PROCEDURE P_updateAddress
GO
ALTER procedure [Meeting_Insert] ( @meetingtype [int] , @name varchar(4000) , @caller [int] , @contacter [int] , @projectid[int], @address varchar(4000) , @begindate varchar(4000), @begintime varchar(4000), @enddate varchar(4000), @endtime varchar(4000), @desc_n varchar(4000), @creater [int], @createdate varchar(4000), @createtime varchar(4000) , @totalmember   int, @othermembers   text, @addressdesc   varchar(4000), @description text, @remindType int, @remindBeforeStart int, @remindBeforeEnd int, @remindTimesBeforeStart int, @remindTimesBeforeEnd int, @customizeAddress   varchar(4000), @flag integer output, @msg varchar(4000) output) AS INSERT INTO [Meeting] ( [meetingtype] , [name] , [caller] , [contacter] , [projectid], [address] , [begindate]  , [begintime] , [enddate] , [endtime] , [desc_n], [creater] , [createdate] , [createtime], totalmember, othermembers, addressdesc, description, remindType, remindBeforeStart, remindBeforeEnd, remindTimesBeforeStart, remindTimesBeforeEnd, customizeAddress ) VALUES ( @meetingtype , @name, @caller, @contacter, @projectid, @address , @begindate , @begintime , @enddate , @endtime , @desc_n , @creater , @createdate , @createtime, @totalmember, @othermembers, @addressdesc, @description, @remindType, @remindBeforeStart, @remindBeforeEnd, @remindTimesBeforeStart, @remindTimesBeforeEnd, @customizeAddress ) select IDENT_CURRENT('Meeting') set @flag = 1 set @msg = 'OK!' ;
GO
ALTER procedure [Meeting_Update] ( @meetingid [int] , @name varchar(4000) , @caller [int] , @contacter [int] , @projectid [int], @address varchar(4000) , @begindate varchar(4000)  , @begintime varchar(4000)  , @enddate varchar(4000)  , @endtime varchar(4000)  , @desc_n varchar(4000)  , @totalmember   int, @othermembers   text, @addressdesc   varchar(4000), @description text, @remindType int, @remindBeforeStart int, @remindBeforeEnd int, @remindTimesBeforeStart int, @remindTimesBeforeEnd int, @customizeAddress   varchar(4000), @flag integer output, @msg varchar(4000) output ) AS Update [Meeting] set [name]=@name , [caller]=@caller , [contacter]=@contacter , [projectid]=@projectid, [address]=@address , [begindate]=@begindate , [begintime]=@begintime , [enddate]=@enddate , [endtime]=@endtime , [desc_n]=@desc_n, totalmember=@totalmember, othermembers=@othermembers, addressdesc=@addressdesc, description=@description, remindType=@remindType, remindBeforeStart=@remindBeforeStart, remindBeforeEnd=@remindBeforeEnd, remindTimesBeforeStart=@remindTimesBeforeStart, remindTimesBeforeEnd=@remindTimesBeforeEnd, customizeAddress = @customizeAddress where id = @meetingid set @flag = 1 set @msg = 'OK!' ;
GO
update workflow_base set custompage='/meeting/template/MeetingSubmitRequestJs.jsp',custompage4Emoble='/meeting/template/MeetingSubmitRequestJs4Mobile.jsp' where id in(select id from workflow_base wb join meeting_bill mb on mb.billid=wb.formid where mb.billid<>85 and mb.defined=1)
GO