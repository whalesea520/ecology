ALTER TABLE MailResourceFile ADD isfileattrachment char(1)
/
ALTER TABLE MailResourceFile ADD fileContentId varchar2(100)
/

CREATE or REPLACE PROCEDURE MailResource_Insert 
	( resourceid_2 	integer,
	  priority_3 	char,
	  sendfrom_4 	varchar2,
	  sendcc_5 	varchar2,
	  sendbcc_6 	varchar2,
	  sendto_7 	varchar2,
	  senddate_8 	varchar2,
	  size_9 	integer,
	  subject_10 	varchar2,
	  content_11 	varchar2,
	  mailtype_12	char ,
      hasHtmlImage_13	char ,
	  flag	out integer, 
	  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)

as 
begin 

 INSERT into MailResource 
	 (resourceid,
	 priority,
	 sendfrom,
	 sendcc,
	 sendbcc,
	 sendto,
	 senddate,
	 size_n,
	 subject,
	 content,
	 mailtype,
     hasHtmlImage) 
 
VALUES 
	( resourceid_2,
	  priority_3,
	  sendfrom_4,
	  sendcc_5,
	  sendbcc_6,
	  sendto_7,
	  senddate_8,
	  size_9,
	  subject_10,
	  content_11,
	  mailtype_12,
      hasHtmlImage_13);
open thecursor for 
select max(id) from MailResource;
 
 end;
/

CREATE OR REPLACE PROCEDURE MailResourceFile_Insert
	(mailid_1 	integer,
	 filename_2 	varchar2,
	 filetype_3 	varchar2,
	 filerealpath_4 	varchar2,
     iszip_5 char ,
	 isencrypt_6 	char ,
     isfileattrachment_7  char,
     fileContentId_8 	varchar2,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO MailResourceFile 
	 ( mailid,
	 filename,
	 filetype,
	 filerealpath,
     iszip,
	 isencrypt,
     isfileattrachment,
     fileContentId) 
 
VALUES 
	( mailid_1,
	 filename_2,
	 filetype_3,
	 filerealpath_4,
     iszip_5 ,
     isencrypt_6,
     isfileattrachment_7,
     fileContentId_8);
end;
/

CREATE OR REPLACE PROCEDURE MailResourceFile_Insert
	(mailid_1 	integer,
	 filename_2 	varchar2,
	 filetype_3 	varchar2,
	 filerealpath_4 	varchar2,
     iszip_5 char ,
	 isencrypt_6 	char ,
     isfileattrachment_7 char,
     fileContentId_8 varchar2,
     isEncoded_9 char,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO MailResourceFile 
	 ( mailid,
	 filename,
	 filetype,
	 filerealpath,
     iszip,
	 isencrypt,
     isfileattrachment,
     fileContentId,
     isEncoded
     ) 
 
VALUES 
	( mailid_1,
	 filename_2,
	 filetype_3,
	 filerealpath_4,
     iszip_5 ,
     isencrypt_6,
     isfileattrachment_7,
     fileContentId_8,
     isEncoded_9);
end;
/