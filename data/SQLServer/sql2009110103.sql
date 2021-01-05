alter table Meeting add remindType int default 0
GO
alter table Meeting add remindBeforeStart int default 0
GO
alter table Meeting add remindBeforeEnd int default 0
GO
alter table Meeting add remindTimesBeforeStart int default 0
GO
alter table Meeting add remindTimesBeforeEnd int default 0
GO

alter table Bill_Meeting add remindType int default 0
GO
alter table Bill_Meeting add remindBeforeStart int default 0
GO
alter table Bill_Meeting add remindBeforeEnd int default 0
GO
alter table Bill_Meeting add remindTimesBeforeStart int default 0
GO
alter table Bill_Meeting add remindTimesBeforeEnd int default 0
GO

insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindType', 18713, 'int', 5, 1, 7, 0, '', 1)
GO
insert into workflow_selectitem
  (fieldid, isbill, selectvalue, selectname,listorder,isdefault)
  select id, 1, 1, '不提醒',.00,'n'
    from workflow_billfield
   where fieldname = 'remindType'
     and billid = 85
GO
insert into workflow_selectitem
  (fieldid, isbill, selectvalue, selectname,listorder,isdefault)
  select id, 1, 2, '短信提醒',.00,'n'
    from workflow_billfield
   where fieldname = 'remindType'
     and billid = 85
GO
insert into workflow_selectitem
  (fieldid, isbill, selectvalue, selectname,listorder,isdefault)
  select id, 1, 3, '邮件提醒',.00,'n'
    from workflow_billfield
   where fieldname = 'remindType'
     and billid = 85
GO
insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindBeforeStart', 23807, 'int', 1, 1, 7, 0, '', 1)
GO
insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindBeforeEnd', 23806, 'int', 1, 1, 7, 0, '', 1)
GO
insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindTimesBeforeStart', 23808, 'int', 1, 1, 7, 0, '', 1)
GO
insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindTimesBeforeEnd', 23809, 'int', 1, 1, 7, 0, '', 1)
GO
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
	 (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindType'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
GO
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
	 (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindBeforeStart'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
GO
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
	 (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindBeforeEnd'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
GO
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
	 (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindTimesBeforeStart'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
GO
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
	 (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindTimesBeforeEnd'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
GO

ALTER PROCEDURE Meeting_Insert 
( @meetingtype [int] , 
	@name [varchar] (255) , 
	@caller [int] , 
	@contacter [int] , 
	@projectid[int], 
	@address [int] , 
	@begindate [varchar] (10), 
	@begintime [varchar] (8),
	@enddate [varchar] (10), 
	@endtime [varchar] (8),
	@desc_n [varchar] (4000), 
	@creater [int], 
	@createdate [varchar] (10),
	@createtime [varchar] (8) , 
	@totalmember   int, 
	@othermembers   text, 
	@addressdesc   varchar(255), 
	@description varchar(8000),
	@remindType int,
	@remindBeforeStart int,
	@remindBeforeEnd int, 
	@remindTimesBeforeStart int,
	@remindTimesBeforeEnd int,
	@customizeAddress   varchar(400), 
	@flag integer output, 
	@msg varchar(80) output) 
 AS 
 INSERT INTO [Meeting] 
( 
[meetingtype] , 
[name] , 
[caller] , 
[contacter] , 
[projectid], 
[address] , 
[begindate]  , 
[begintime] , 
[enddate] , 
[endtime] , 
[desc_n], 
[creater] , 
[createdate] , 
[createtime], 
totalmember, 
othermembers, 
addressdesc,
description,
remindType,
remindBeforeStart,
remindBeforeEnd,
remindTimesBeforeStart,
remindTimesBeforeEnd,
customizeAddress
) 
VALUES 
( 
@meetingtype , 
@name, 
@caller, 
@contacter, 
@projectid, 
@address , 
@begindate , 
@begintime , 
@enddate , 
@endtime , 
@desc_n , 
@creater , 
@createdate , 
@createtime, 
@totalmember, 
@othermembers, 
@addressdesc,
@description,
@remindType,
@remindBeforeStart,
@remindBeforeEnd,
@remindTimesBeforeStart,
@remindTimesBeforeEnd, 
@customizeAddress
) 
 select IDENT_CURRENT('Meeting') set @flag = 1 set @msg = 'OK!'
GO

ALTER PROCEDURE Meeting_Update 
( 
@meetingid [int] , 
@name [varchar] (255) ,
@caller [int] , 
@contacter [int] , 
@projectid [int], 
@address [int] , 
@begindate [varchar] (10)  , 
@begintime [varchar] (8)  , 
@enddate [varchar] (10)  , 
@endtime [varchar] (8)  , 
@desc_n [varchar] (4000)  , 
@totalmember   int, 
@othermembers   text, 
@addressdesc   varchar(255), 
@description varchar(8000),
@remindType int,
@remindBeforeStart int,
@remindBeforeEnd int, 
@remindTimesBeforeStart int,
@remindTimesBeforeEnd int,
@customizeAddress   varchar(400), 
@flag integer output, 
@msg varchar(80) output
) 
AS 
Update [Meeting] 
set [name]=@name , 
[caller]=@caller , 
[contacter]=@contacter , 
[projectid]=@projectid, 
[address]=@address , 
[begindate]=@begindate , 
[begintime]=@begintime , 
[enddate]=@enddate , 
[endtime]=@endtime , 
[desc_n]=@desc_n, 
totalmember=@totalmember, 
othermembers=@othermembers, 
addressdesc=@addressdesc, 
description=@description, 
remindType=@remindType,
remindBeforeStart=@remindBeforeStart,
remindBeforeEnd=@remindBeforeEnd,
remindTimesBeforeStart=@remindTimesBeforeStart,
remindTimesBeforeEnd=@remindTimesBeforeEnd,
customizeAddress = @customizeAddress 
where id = @meetingid 
set @flag = 1 set @msg = 'OK!'
GO
