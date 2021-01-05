CREATE TABLE DocUserselfCategory (
	id integer  NOT NULL ,
	userid integer NULL ,
	name varchar2 (255)  NULL ,
	parentid integer NULL ,
	parentids varchar2 (255)  NULL ,
	createdate varchar2 (10) NULL ,
	createtime varchar2 (8) NULL 
) 
/

create sequence DocUserselfCategory_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger DocUserselfCategory_Trigger
before insert on DocUserselfCategory
for each row
begin
select DocUserselfCategory_id.nextval into :new.id from dual;
end;
/



CREATE or REPLACE PROCEDURE DocUserselfCategory_Insert
	(userid_1 	integer,
	 name_2 	varchar2,
	 parentid_3 	integer,
	 parentids_4 	varchar2,
	 createdate varchar2,
	 createtime varchar2, 
     flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor )
AS
BEGIN
INSERT INTO DocUserselfCategory 
    (userid,
	 name,
	 parentid,
	 parentids,
	 createdate,
	 createtime) 
 
VALUES 
	(userid_1,
	 name_2,
	 parentid_3,
	 parentids_4,
	 createdate,
	 createtime);
open thecursor for
select greatest(id) from DocUserselfCategory ;
end;
/


CREATE or REPLACE PROCEDURE DocUserselfCategory_Update
	(id_1 	integer,
	 userid_2 	integer,
	 name_3 	varchar2,
	 parentid_4 	integer,
	 parentids_5 	varchar2, 
     flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor )
AS
BEGIN
UPDATE DocUserselfCategory SET 
    userid = userid_2,
	name = name_3,
	parentid = parentid_4,
	parentids = parentids_5 
WHERE 
	( id = id_1);
end;
/

CREATE or REPLACE PROCEDURE DocUserselfCategory_Delete
    (id_1 	integer, 
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor )
AS
BEGIN
DELETE DocUserselfCategory  WHERE ( id = id_1);
end;
/


CREATE or REPLACE PROCEDURE DocUserselfCategory_SelectByID
    (id_1 	integer, 
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor )
AS 
begin
open thecursor for
select * from DocUserselfCategory WHERE ( id = id_1);
end;
/

CREATE TABLE DocUserselfDocs (
	docid integer NOT NULL ,
	userCatalogId integer NULL,
	userid integer NULL,
	doctype integer NULL,
    usertype integer null
) 
/
 