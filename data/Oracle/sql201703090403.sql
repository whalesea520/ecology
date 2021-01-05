alter table mailresource add mr_uuid varchar2(50)
/

CREATE INDEX mailresource_mr_uuid ON mailresource(mr_uuid)
/

CREATE OR REPLACE PROCEDURE MailResource_Insert ( 
		 mr_uuid_1 varchar2,
		 resourceid_2 integer,
         priority_3 char,
         sendfrom_4 varchar2,
         sendcc_5 varchar2,
         sendbcc_6 varchar2,
         sendto_7 varchar2,
         senddate_8 varchar2,
         size_9 integer,
         subject_10 varchar2,
         content_11 clob,
         mailtype_12 char,
         hasHtmlImage_13 char,
         mailAccountId_14 integer,
         status_15 char,
         folderId_16 integer,
         flag out integer,
         msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor ) AS 
begin INSERT INTO MailResource (
		 mr_uuid,
		 resourceid,
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
         hasHtmlImage,
         mailAccountId,
         status,
         folderId
) VALUES (
         mr_uuid_1,
         resourceid_2,
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
         hasHtmlImage_13,
         mailAccountId_14,
         status_15,
         folderId_16) ; 
    open thecursor for SELECT id FROM MailResource WHERE mr_uuid = mr_uuid_1 ; 
	commit;
end;  
/