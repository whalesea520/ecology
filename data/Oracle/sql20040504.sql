/*Èº·¢ÓÊ¼þ*/
drop table MailSendRecord
/
drop PROCEDURE MailSendRecord_Insert
/

insert into SequenceIndex(indexdesc,currentid) values('mailsendmain',1)
/

CREATE or replace PROCEDURE SequenceIndex_SMailSendId 
( flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)  
AS
begin
update SequenceIndex set currentid = currentid+1 where indexdesc='mailsendmain';
open thecursor for
select currentid from SequenceIndex 
where indexdesc='mailsendmain' ;
end;
/

CREATE TABLE MailSendMain ( 
    id integer,
    sendfrom varchar2(200),
    sendcc varchar2(200),
    sendbcc varchar2(200),
    charset char(1),
    priority char(1),
    senddate char(10),
    sendtime char(8),
    isfinished char(1),
    sendtotype char(1),
    sender integer) 
/

CREATE TABLE MailSendRecord ( 
    id integer ,
    sendto varchar2(200),
    subject varchar2(200),
    body Varchar2(4000),
    sendcount integer,
    sendtoid integer)
/


CREATE or replace PROCEDURE MailSendMain_Insert
	(id_1 	integer,
	 sendfrom_2 	varchar2,
	 sendcc_3 	varchar2,
	 sendbcc_4 	varchar2,
	 charset_5 	char,
	 priority_6 	char,
	 senddate_7 	char,
	 sendtime_8 	char,
	 isfinished_9 	char,
	 sendtotype_10 	char,
	 sender_11 	integer,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO MailSendMain 
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
	( id_1,
	 sendfrom_2,
	 sendcc_3,
	 sendbcc_4,
	 charset_5,
	 priority_6,
	 senddate_7,
	 sendtime_8,
	 isfinished_9,
	 sendtotype_10,
	 sender_11);
end;
/

CREATE or replace PROCEDURE MailSendRecord_Insert
	(id_1 	integer,
	 sendto_2 	varchar2,
     subject_3 varchar2,
     body_4 varchar2,
	 sendcount_5 	integer,
	 sendtoid_6 	integer,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO MailSendRecord 
	 ( id,
	 sendto,
     subject,
     body,
	 sendcount,
	 sendtoid) 
 
VALUES 
	( id_1,
	 sendto_2,
     subject_3,
     body_4,
	 sendcount_5,
	 sendtoid_6);
end;
/