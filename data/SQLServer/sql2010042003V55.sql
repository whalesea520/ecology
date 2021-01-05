ALTER  PROCEDURE VotingQuestion_Insert ( 
@votingid  int, 
@subject   varchar(400), 
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

ALTER PROCEDURE VotingQuestion_Update
(@id    int,
 @votingid  int,
 @subject   varchar(400),
 @description   varchar(255),
 @ismulti       int,
 @isother       int,
 @ismultino     int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	update votingquestion set
	votingid=@votingid,
	subject=@subject,
	description=@description,
	ismulti=@ismulti,
	isother=@isother,
	ismultino=@ismultino
	where id=@id

GO
