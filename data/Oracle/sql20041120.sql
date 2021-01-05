

/*TD:1250,加入流程的常用短语.dp*/         
CREATE TABLE sysPhrase (
	id integer  NOT NULL ,
    hrmId integer NOT NULL,
    phraseShort varchar2(30)  NULL,
    phraseDesc varchar2(200)  NULL
)
/

create sequence sysPhrase_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger sysPhrase_Trigger
before insert on sysPhrase
for each row
begin
select sysPhrase_id.nextval into :new.id from dual;
end;
/


CREATE OR REPLACE PROCEDURE sysPhrase_selectByHrmId (  
    hrm_1 integer,
    flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
)
AS
begin
    open thecursor for  
        select * from sysPhrase where hrmid = hrm_1 order by id;
end ;
/


CREATE OR REPLACE PROCEDURE sysPhrase_selectById (
    id_1 integer,
    flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    ) 
AS
begin
    open thecursor for  
        select * from sysPhrase where id = id_1 ;
end ;
/


CREATE OR REPLACE PROCEDURE sysPhrase_insert (  
    hrmId_1 integer,
    phraseShort_1 varchar2,
    PhraseDesc_1 varchar2,
    flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
AS
begin
    insert into sysPhrase (hrmId,phraseShort,PhraseDesc) values (hrmId_1,phraseShort_1,PhraseDesc_1) ;
end ;
/



CREATE OR REPLACE PROCEDURE sysPhrase_update (
    id_1 integer,
    hrmId_1 integer,
    phraseShort_1 varchar2,
    PhraseDesc_1 varchar2,
    flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor 
    )
AS
begin
    update sysPhrase set  hrmId=hrmId_1,phraseShort=phraseShort_1, PhraseDesc=PhraseDesc_1 where id = id_1 ;
end ;
/


CREATE OR REPLACE PROCEDURE sysPhrase_deleteById (
    id_1 integer,
    flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor 
    )
AS
begin
    delete sysPhrase where id = id_1  ;
end ;
/

INSERT INTO HtmlLabelIndex values(17561,'流程短语设置')  
/
INSERT INTO HtmlLabelInfo VALUES(17561,'流程短语设置',7)  
/
INSERT INTO HtmlLabelInfo VALUES(17561,'workflow sysPhrase setting',8) 
/