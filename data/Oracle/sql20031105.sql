CREATE OR REPLACE PROCEDURE SystemRights_Select 
(rightdesc_1 varchar2 , 
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
open thecursor for 
select * from SystemRights where rightdesc like rightdesc_1 order by id desc ;
end; 
/



CREATE OR REPLACE PROCEDURE SystemRights_Insert 
 ( 
 rightdesc_2 	varchar2, 
 righttype_3 	char, 
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  
 AS 
 maxid integer;
 begin
 select (max(id) + 1) into maxid from SystemRights;

 INSERT INTO SystemRights ( id , rightdesc, righttype)  VALUES (  maxid , rightdesc_2, righttype_3);
 open thecursor for 
 select max(id) from SystemRights ;
 end;
/



CREATE OR REPLACE PROCEDURE SystemRightDetail_Select 
(rightdetailname_1 varchar2 , 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for 
select * from SystemRightDetail where rightdetailname like rightdetailname_1 order by rightid desc , id desc;
end;
/

CREATE OR REPLACE PROCEDURE SystemRightDetail_Insert 
(rightdetailname_1 	varchar2, 
 rightdetail_2 	varchar2, 
 rightid_3 	integer, 
 flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  
AS 
maxid integer;
begin
select (max(id) + 1) into maxid from SystemRightDetail ;

INSERT INTO SystemRightDetail ( id, rightdetailname, rightdetail, rightid)  VALUES ( maxid , rightdetailname_1, rightdetail_2, rightid_3);
end;
/


update HtmlLabelInfo set labelname = '¹Ø¼ü×Ö' where indexid = 2005 and  languageid = 7
/

update HtmlLabelInfo set labelname = '¹Ø¼ü×Ö' where indexid = 2095 and  languageid = 7
/

