CREATE TABLE SysPopRemindInfo (
	userid int NULL ,
	usertype int NULL ,
	hascrmcontact tinyint NULL ,
	hasnewwf text  NULL ,
	hasendwf text  NULL ,
	haspasstimenode tinyint NULL ,
	hasapprovedoc tinyint NULL ,
	hasdealdoc tinyint NULL ,
	hasnewemail tinyint NULL 
) 
GO


delete SysRemindInfo 
GO


alter PROCEDURE SysRemindInfo_InserHasnewwf 
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
  else if CHARINDEX(','+convert(varchar,@requestid)+',',','+@tmp+',')=0
  begin
  update SysRemindInfo set hasnewwf = convert(varchar,hasnewwf)+','+convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  end

  set @tmpid = null 
  set @tmp = null

  select @tmpid = userid,@tmp=convert(varchar,hasnewwf) from SysPopRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysPopRemindInfo(userid,usertype,hasnewwf) values(@userid,@usertype,convert(varchar,@requestid))
  end
  else
  begin
  if @tmp = '' or @tmp is null
  begin
  update SysPopRemindInfo set hasnewwf = convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  else if CHARINDEX(','+convert(varchar,@requestid)+',',','+@tmp+',')=0
  begin
  update SysPopRemindInfo set hasnewwf = convert(varchar,hasnewwf)+','+convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  end
GO




alter PROCEDURE SysRemindInfo_InserHasendwf 
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
  else if CHARINDEX(','+convert(varchar,@requestid)+',',','+@tmp+',')=0
  begin
  update SysRemindInfo set hasendwf = convert(varchar,hasendwf)+','+convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  end

  set @tmpid = null 
  set @tmp = null

  select @tmpid = userid,@tmp=convert(varchar,hasendwf) from SysPopRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysPopRemindInfo(userid,usertype,hasendwf) values(@userid,@usertype,convert(varchar,@requestid))
  end
  else
  begin
  if @tmp = '' or @tmp is null
  begin
  update SysPopRemindInfo set hasendwf = convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  else if CHARINDEX(','+convert(varchar,@requestid)+',',','+@tmp+',')=0
  begin
  update SysPopRemindInfo set hasendwf = convert(varchar,hasendwf)+','+convert(varchar,@requestid) where userid = @userid and usertype = @usertype
  end
  end
GO




alter PROCEDURE SysRemindInfo_IPasstimeNode 
@userid		int,
@usertype	int,
@haspasstimenode int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmpid integer 
  select @tmpid = userid from SysPopRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysPopRemindInfo(userid,usertype,haspasstimenode) values(@userid,@usertype,@haspasstimenode)
  end
  else
  begin
  update SysPopRemindInfo set haspasstimenode = @haspasstimenode where userid = @userid and usertype = @usertype
  end
GO




alter PROCEDURE SysRemindInfo_DeleteHasendwf 
@userid		int,
@usertype	int,
@requestid	int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmp varchar(255)
  
  select @tmp = convert(varchar,hasendwf) from SysRemindInfo where userid = @userid and usertype = @usertype
  if @tmp is not null and @tmp <> ''
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

  set @tmp = null

  select @tmp = convert(varchar,hasendwf) from SysPopRemindInfo where userid = @userid and usertype = @usertype
  if @tmp is not null and @tmp <> ''
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
	 update SysPopRemindInfo set hasendwf = @tmp where userid = @userid and usertype = @usertype
  end

GO

 alter PROCEDURE SysRemindInfo_DeleteHasnewwf 
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

  set @tmp = null

  select @tmp = convert(varchar,hasnewwf) from SysPopRemindInfo where userid = @userid and usertype = @usertype
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
	 update SysPopRemindInfo set hasnewwf = @tmp where userid = @userid and usertype = @usertype
  end  

GO


alter PROCEDURE SysRemindInfo_InserCrmcontact 
@userid		int,
@usertype	int,
@hascrmcontact int,
@flag integer output , 
@msg varchar(80) output 
as
  declare @tmpid integer 
  select @tmpid = userid from SysPopRemindInfo where userid = @userid and usertype = @usertype
  if @tmpid is null 
  begin
  insert into SysPopRemindInfo(userid,usertype,hascrmcontact) values(@userid,@usertype,@hascrmcontact)
  end
  else
  begin
  update SysPopRemindInfo set hascrmcontact = @hascrmcontact where userid = @userid and usertype = @usertype
  end
GO  


INSERT INTO HtmlLabelIndex values(16897,'泛微网站') 
GO
INSERT INTO HtmlLabelInfo VALUES(16897,'泛微网站',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16897,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16898,'授权用户') 
GO
INSERT INTO HtmlLabelInfo VALUES(16898,'授权用户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16898,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16899,'版权所有') 
GO
INSERT INTO HtmlLabelInfo VALUES(16899,'版权所有',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16899,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16900,'关于') 
GO
INSERT INTO HtmlLabelInfo VALUES(16900,'关于',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16900,'',8) 
GO

/*注：版本更新时需更新该字段为相应的版本 */
UPDATE license set cversion = '2.0'
GO

