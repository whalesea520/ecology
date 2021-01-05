
CREATE TABLE TEMP_DOCMOULD (
    ID            NUMBER         NOT NULL,
    MOULDNAME     VARCHAR2(200)      NULL,
    MOULDTEXT     CLOB     NULL,
    ISSYSDEFAULT  CHAR(1)        DEFAULT '0'     NULL,
    ISUSERDEFAULT CHAR(1)            NULL,
    ISMAILDEFAULT CHAR(1)            NULL
)
/
CREATE TABLE TEMP_DOCMOULDFILE(
     ID        NUMBER         NOT NULL,
    MOULDNAME VARCHAR2(200)      NULL,
    MOULDTEXT CLOB     NULL,
    MOULDTYPE NUMBER             NULL,
    MOULDPATH VARCHAR2(100)      NULL
)
/
INSERT INTO TEMP_DOCMOULD
    SELECT ID,MOULDNAME,MOULDTEXT,ISSYSDEFAULT,ISUSERDEFAULT,ISMAILDEFAULT
    FROM DOCMOULD
/
INSERT INTO TEMP_DOCMOULDFILE
    SELECT ID,MOULDNAME,MOULDTEXT,MOULDTYPE,MOULDPATH
    FROM DOCMOULDFILE
/
   
    
    DROP TABLE DOCMOULD
/
    DROP TABLE DOCMOULDFILE
/
    
    
    ALTER TABLE TEMP_DOCMOULD
         RENAME TO DOCMOULD
/
    ALTER TABLE TEMP_DOCMOULDFILE
         RENAME TO DOCMOULDFILE
/

ALTER TABLE DocMould  ADD 
	 PRIMARY KEY 
	(
		id
	)
/

create or replace trigger DocMould_Trigger
before insert on DocMould
for each row
begin
select DocMould_id.nextval INTO :new.id from dual;
end;
/
ALTER TABLE DocMouldFILE  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
create or replace trigger DocMouldFile_Trigger
before insert on DocMouldFile
for each row
begin
select DocMouldFile_id.nextval INTO :new.id from dual;
end;
/

INSERT INTO HtmlLabelIndex values(17048,'您确定删除此记录吗？')
/
INSERT INTO HtmlLabelInfo VALUES(17048,'您确定删除此记录吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17048,'Are you sure to delete?',8) 
/


INSERT INTO HtmlLabelIndex values(17049,'由于数据关联，该记录无法删除！') 
/
INSERT INTO HtmlLabelInfo VALUES(17049,'由于数据关联，该记录无法删除！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17049,'You can delete this record for data consistency!',8) 
/
