/*Èº·¢ÓÊ¼þ*/
drop table MailSendRecord
go 
drop PROCEDURE MailSendRecord_Insert
go

insert into SequenceIndex(indexdesc,currentid) values('mailsendmain',1)
go

CREATE PROCEDURE SequenceIndex_SMailSendId (@flag int output, @msg varchar(80) output)  AS select currentid from SequenceIndex where indexdesc='mailsendmain' update SequenceIndex set currentid = currentid+1 where indexdesc='mailsendmain'
GO

CREATE TABLE MailSendMain ( 
    id int,
    sendfrom varchar(200),
    sendcc varchar(200),
    sendbcc varchar(200),
    charset char(1),
    priority char(1),
    senddate char(10),
    sendtime char(8),
    isfinished char(1),
    sendtotype char(1),
    sender int) 
GO

CREATE TABLE MailSendRecord ( 
    id int ,
    sendto varchar(200),
    subject varchar(200),
    body text,
    sendcount int,
    sendtoid int)
GO


CREATE PROCEDURE MailSendMain_Insert
	(@id_1 	int,
	 @sendfrom_2 	varchar(200),
	 @sendcc_3 	varchar(200),
	 @sendbcc_4 	varchar(200),
	 @charset_5 	char(1),
	 @priority_6 	char(1),
	 @senddate_7 	char(10),
	 @sendtime_8 	char(8),
	 @isfinished_9 	char(1),
	 @sendtotype_10 	char(1),
	 @sender_11 	int,
     @flag int output, 
     @msg varchar(80) output)

AS INSERT INTO MailSendMain 
	 ( id,
	 sendfrom,
	 sendcc,
	 sendbcc,
	 charset,
	 priority,
	 senddate,
	 sendtime,
	 isfinished,
	 sendtotype,
	 sender) 
 
VALUES 
	( @id_1,
	 @sendfrom_2,
	 @sendcc_3,
	 @sendbcc_4,
	 @charset_5,
	 @priority_6,
	 @senddate_7,
	 @sendtime_8,
	 @isfinished_9,
	 @sendtotype_10,
	 @sender_11)


GO

CREATE PROCEDURE MailSendRecord_Insert
	(@id_1 	int,
	 @sendto_2 	varchar(200),
     @subject_3 varchar(200),
     @body_4 text,
	 @sendcount_5 	int,
	 @sendtoid_6 	int,
     @flag int output, 
     @msg varchar(80) output)

AS INSERT INTO MailSendRecord 
	 ( id,
	 sendto,
     subject,
     body,
	 sendcount,
	 sendtoid) 
 
VALUES 
	( @id_1,
	 @sendto_2,
     @subject_3,
     @body_4,
	 @sendcount_5,
	 @sendtoid_6)
go