CREATE TABLE cowork_hidden(
	id integer not null,
	coworkid integer NULL,
	userid integer NULL
)
/
CREATE SEQUENCE cowork_hidden_id
     INCREMENT BY 1   
     START WITH 1     
     NOMAXVALUE       
     NOCYCLE         
/
CREATE TRIGGER cowork_hidden_id_trigger BEFORE
insert ON  cowork_hidden FOR EACH ROW
begin
select cowork_hidden_id.nextval into:New.id from dual;
end; 
/

CREATE TABLE cowork_important(
	id integer not null,
	coworkid integer NULL,
	userid integer NULL
)
/
CREATE SEQUENCE cowork_important_id
 INCREMENT BY 1   
     START WITH 1     
     NOMAXVALUE      
     NOCYCLE          
/
CREATE TRIGGER cowork_important_id_trigger BEFORE
insert ON  cowork_important FOR EACH ROW
begin
select cowork_important_id.nextval into:New.id from dual;
end; 
/

CREATE TABLE cowork_item_label(
	id integer not null,
	coworkid integer NULL,
	labelid integer NULL
)
/
CREATE SEQUENCE cowork_item_label_id
   INCREMENT BY 1   
     START WITH 1     
     NOMAXVALUE       
     NOCYCLE           
/
CREATE TRIGGER cowork_item_label_id_trigger BEFORE
insert ON  cowork_item_label FOR EACH ROW
begin
select cowork_item_label_id.nextval into:New.id from dual;
end; 
/

CREATE TABLE cowork_read(
	id integer not null,
	coworkid integer NULL,
	userid integer NULL
)
/
CREATE SEQUENCE cowork_read_id
 INCREMENT BY 1    
     START WITH 1      
     NOMAXVALUE         
     NOCYCLE          
/
CREATE TRIGGER cowork_read_id_trigger BEFORE
insert ON  cowork_read FOR EACH ROW
begin
select cowork_read_id.nextval into:New.id from dual;
end; 
/

CREATE TABLE cowork_label(
	id integer  not null,
	userid integer NULL,
	name varchar2(200),
	icon varchar2(200),
	createdate varchar2(50),
	createtime varchar2(50)
)
/
CREATE SEQUENCE cowork_label_id
 INCREMENT BY 1   
     START WITH 1      
     NOMAXVALUE       
     NOCYCLE          
/
CREATE OR REPLACE TRIGGER cowork_label_id_trigger BEFORE
insert ON  cowork_label FOR EACH ROW
begin
select cowork_label_id.nextval into:New.id from dual;
end; 
/

ALTER TABLE cowork_discuss   ADD  id  integer null
/
ALTER TABLE cowork_discuss   ADD floorNum integer null
/
ALTER TABLE cowork_discuss   ADD replayid integer null
/

update cowork_discuss set replayid=0 
/

CREATE SEQUENCE cowork_discuss_id
     INCREMENT BY 1   
     START WITH 1     
     NOMAXVALUE       
     NOCYCLE      
/

CREATE OR REPLACE TRIGGER cowork_discuss_id_trigger BEFORE
insert ON  cowork_discuss FOR EACH ROW
begin
select cowork_discuss_id.nextval into:New.id from dual;
end; 
/

update cowork_discuss set id=cowork_discuss_id.nextval
/

CREATE TABLE coworkshare (
	id     integer      NOT NULL,
	sourceid      integer         NOT NULL,
	type      integer         NOT NULL, 
	content      varchar2(4000)         NOT NULL,
	seclevel      integer         NOT NULL, 
	sharelevel      integer         NOT NULL,
	srcfrom      integer         NOT NULL
)
/
CREATE SEQUENCE coworkshare_id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/
CREATE OR REPLACE TRIGGER coworkshare_id_Trigger
	before insert on coworkshare
	for each row
	begin
	select coworkshare_id.nextval into :new.id from dual;
	end ;
/ 

CREATE OR REPLACE PROCEDURE COWORK_DISCUSS_INSERT
(   coworkid_1 	integer, 
	discussant_2 	integer,
	createdate_3 	char,
	createtime_4 	char,
	remark_5 	clob,
	relatedprj_6  varchar2,
	relatedcus_7  varchar2,
	relatedwf_8 	varchar2,
	relateddoc_9  varchar2,
	relatedacc_10 varchar2,
	mutil_prjs_11 varchar2,
	floorNum_12 integer,
	replayid_13 integer ,
	flag out integer  , 
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor )
AS 
begin 
INSERT INTO cowork_discuss 
	(coworkid, 
	discussant,
	createdate, 
	createtime, 
	remark, 
	relatedprj, 
	relatedcus, 
	relatedwf, 
	relateddoc, 
	ralatedaccessory, 
	mutil_prjs,
	floorNum,
	replayid )
VALUES ( 
    coworkid_1, 
    discussant_2, 
    createdate_3, 
    createtime_4, 
    remark_5, 
    relatedprj_6, 
    relatedcus_7, 
    relatedwf_8, 
    relateddoc_9, 
    relatedacc_10, 
    mutil_prjs_11,
    floorNum_12,
    replayid_13); 
end;
/
