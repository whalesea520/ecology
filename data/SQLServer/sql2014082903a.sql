alter table voting add descr varchar(1000)
GO
alter table voting add deploytype varchar(5)
GO
alter table voting add autoshowvote varchar(5)
GO
alter table voting add votetimecontrol varchar(5)
GO
alter table voting add votetimecontroltime varchar(100)
GO
alter table voting add forcevote varchar(5)
GO
alter table voting add remindtype varchar(5)
GO
alter table voting add remindtimebeforestart varchar(50)
GO
alter table voting add remindtimebeforeend varchar(50)
GO
alter table voting alter column isanony  varchar(5)
GO
alter table voting add hasremindedbeforestart varchar(5)
GO
alter table voting add hasremindedbeforeend varchar(5)
GO
alter table votingquestion  add pagenum varchar(5)
GO
alter table votingquestion  add questiontype  varchar(5)
GO
alter table votingoption  add roworcolumn  varchar(5)
GO

alter table votingquestion  add ismustinput  varchar(5)
GO
alter table votingquestion  add limit  varchar(5)
GO
alter table votingquestion  add max  varchar(5)
GO
alter table votingquestion  add perrowcols  varchar(5)
GO
alter table votingquestion  add israndomsort  varchar(5)
GO

alter table votingresource alter column optionid  varchar(100)
GO

alter table voting  add istemplate  varchar(5)
GO

drop procedure Voting_Insert
GO

CREATE PROCEDURE Voting_Insert ( @subject   varchar(100), @detail    text, @createrid int, @createdate    char(10), @createtime    char(8),
@approverid    int, @approvedate   char(10), @approvetime   char(8), @begindate     char(10), @begintime     char(8), @enddate       char(10),
@endtime       char(8), @isanony       varchar(5), @docid         int, @crmid     int, @projid    int, @requestid int, @votingcount   int, @status int,
@isSeeResult varchar(10), @descr varchar(1000), @deploytype varchar(5), @autoshowvote varchar(5), @votetimecontrol varchar(5), @votetimecontroltime varchar(100),
@forcevote varchar(5), @remindtype varchar(5), @remindtimebeforestart varchar(50), @remindtimebeforeend varchar(50), @istemplate varchar(5), @flag integer output, @msg varchar(80) output ) AS 
insert into voting ( subject, detail, createrid, createdate, createtime, approverid, approvedate, approvetime, begindate, begintime, enddate,endtime, isanony, docid, crmid, projid, requestid, votingcount, status, isSeeResult, 
descr,deploytype,autoshowvote,votetimecontrol,votetimecontroltime,forcevote,remindtype,remindtimebeforestart,remindtimebeforeend, istemplate) values ( @subject, @detail, @createrid, @createdate, @createtime,
@approverid, @approvedate, @approvetime, @begindate, @begintime, @enddate, @endtime, @isanony, @docid, @crmid, @projid, @requestid, @votingcount, @status,
@isSeeResult,@descr,@deploytype,@autoshowvote,@votetimecontrol,@votetimecontroltime,@forcevote,@remindtype,@remindtimebeforestart,@remindtimebeforeend, @istemplate) select max(id) from voting
GO


drop procedure Voting_Update
GO

 CREATE  PROCEDURE Voting_Update ( @id    int, @subject   varchar(100), @detail    text, @createrid int, @createdate    char(10),
@createtime    char(8), @approverid    int, @approvedate   char(10), @approvetime   char(8), @begindate     char(10), @begintime     char(8), 
@enddate       char(10), @endtime       char(8), @isanony        varchar(5), @docid         int, @crmid     int, @projid    int, @requestid int, 
@isSeeResult varchar(10), @descr varchar(1000), @deploytype varchar(5), @autoshowvote varchar(5), @votetimecontrol varchar(5), @votetimecontroltime varchar(100),
@forcevote varchar(5), @remindtype varchar(5), @remindtimebeforestart varchar(50), @remindtimebeforeend varchar(50), @istemplate varchar(5), @flag integer output, @msg varchar(80) output ) AS update 
voting set subject=@subject, detail=@detail, createrid=@createrid, createdate=@createdate, createtime=@createtime, approverid=@approverid, 
approvedate=@approvedate, approvetime=@approvetime, begindate=@begindate, begintime=@begintime, enddate=@enddate, endtime=@endtime, isanony=@isanony,
docid=@docid, crmid=@crmid, projid=@projid, requestid=@requestid, isSeeResult=@isSeeResult 
, descr=@descr , deploytype=@deploytype , autoshowvote=@autoshowvote , votetimecontrol=@votetimecontrol , votetimecontroltime=@votetimecontroltime 
, forcevote=@forcevote , remindtype=@remindtype , remindtimebeforestart=@remindtimebeforestart , remindtimebeforeend=@remindtimebeforeend, istemplate=@istemplate  where id=@id
GO


CREATE TABLE  votingconfig
(
   id                 int,
   doc                varchar(5),
   flow               varchar(5),
   customer           varchar(5),
   project            varchar(5),
   annex              varchar(5),
   annexcatalogpath   varchar(500),
   mainid             int,
   subid              int,
   seccateid          int,
   votingid           int
)
GO
insert into  votingconfig(id) values(0)
GO