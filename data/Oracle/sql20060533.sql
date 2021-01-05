Create table MailContent(mailid integer,mailcontent CLOB)
/

CREATE OR REPLACE PROCEDURE MailResource_Delete 
	(mailid_1  integer,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select filerealpath from MailResourceFile where mailid = mailid_1;
delete from MailResourceFile where mailid = mailid_1;
delete from MailResource where id = mailid_1;
delete from MailContent where mailid = mailid_1;
end;
/

