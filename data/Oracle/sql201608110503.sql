CREATE OR REPLACE PROCEDURE MailResource_Update(id_1             integer,
                                                resourceid_2     integer,
                                                priority_3       char,
                                                sendfrom_4       varchar2,
                                                sendcc_5         varchar2,
                                                sendbcc_6        varchar2,
                                                sendto_7         varchar2,
                                                senddate_8       varchar2,
                                                size_9           integer,
                                                subject_10       varchar2,
                                                content_11       clob,
                                                mailtype_12      char,
                                                hasHtmlImage_13  char,
                                                mailAccountId_14 integer,
                                                status_15        char,
                                                folderId_16      integer,
                                                flag             out integer,
                                                msg              out varchar2,
                                                thecursor        IN OUT cursor_define.weavercursor) AS
begin
  update MailResource
     set resourceid    = resourceid_2,
         priority      = priority_3,
         sendfrom      = sendfrom_4,
         sendcc        = sendcc_5,
         sendbcc       = sendbcc_6,
         sendto        = sendto_7,
         senddate      = senddate_8,
         size_n        = size_9,
         subject       = subject_10,
         content       = content_11,
         mailtype      = mailtype_12,
         hasHtmlImage  = hasHtmlImage_13,
         mailAccountId = mailAccountId_14,
         status        = status_15,
         folderId      = folderId_16
   where id = id_1;
   commit;
end;
/

CREATE OR REPLACE PROCEDURE MailResource_Insert ( resourceid_2 integer,
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
begin INSERT INTO MailResource (resourceid,
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
         folderId) VALUES (resourceid_2,
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
    open thecursor for SELECT max(id) FROM MailResource WHERE resourceid = resourceid_2 ; 
	commit;
end;  
/