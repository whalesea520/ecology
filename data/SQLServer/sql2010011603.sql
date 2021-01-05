ALTER TABLE VotingQuestion ADD showorder int default 0
GO
ALTER TABLE VotingOption ADD showorder int default 0
GO

CREATE TABLE voting_type ( 
    id int IDENTITY,
    typename varchar(100),
    approver int) 
GO

ALTER TABLE Voting ADD votingtype int default 0
GO

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) 
VALUES ( 182,24094,'int','/systeminfo/BrowserMain.jsp?url=/voting/VotingInfoBrowser.jsp?isfromworkflow=1','voting','subject','id','/voting/VotingView.jsp?isfromworkflow=1&votingid=')
GO
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) 
VALUES(241,24095,'bill_VotingApprove','','','','','','BillVotingApproveOperation.jsp') 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) 
VALUES (241,'votingname',24096,'int',3,182,1,0,'')
GO

CREATE TABLE bill_VotingApprove ( 
    id int IDENTITY,
    votingname int,
    requestid int) 
GO

ALTER PROCEDURE VotingOption_Insert (
@votingid  int, 
@questionid    int, 
@description   varchar(255), 
@optioncount   int,
@showorder     int,
@flag integer output, 
@msg varchar(80) output) 
AS 
insert into votingoption (votingid,questionid,description,optioncount,showorder) 
values (@votingid,@questionid,@description,@optioncount,@showorder) 
select max(id) from votingoption
go

ALTER PROCEDURE VotingOption_SelectByQuestion (
@questionid  int, 
@flag integer output, 
@msg varchar(80) output) 
AS 
select * from votingoption where questionid=@questionid order by showorder
go

ALTER  PROCEDURE VotingQuestion_Insert ( 
@votingid  int, 
@subject   varchar(100), 
@description   varchar(255), 
@ismulti       int, 
@isother       int, 
@questioncount int, 
@ismultino int, 
@showorder int,
@flag integer output, 
@msg varchar(80) output ) 
AS 
insert into votingquestion ( votingid, subject, description, ismulti, isother, questioncount, ismultino, showorder) 
values ( @votingid, @subject, @description, @ismulti, @isother, @questioncount, @ismultino ,@showorder) 
select max(id) from votingquestion
go

ALTER PROCEDURE VotingQuestion_SelectByVoting (
@votingid  int, 
@flag integer output, 
@msg varchar(80) output) 
AS
select * from votingquestion where votingid=@votingid order by showorder
go
