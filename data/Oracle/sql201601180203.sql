INSERT INTO SysPoppupInfo( type ,link ,description ,statistic ,typedescription)VALUES  ( 25 ,'/hrm/HrmTab.jsp?_fromURL=HrmGroupSuggestList' ,'126253' ,'y' , '126253')
/
CREATE TABLE HrmGroupSuggest(
id INT PRIMARY KEY NOT NULL,
suggesttitle VARCHAR(500),
groupid INT,
suggesttype int,
content varchar(4000),
STATUS INT,
creater INT,
createdate VARCHAR(10)
)
/
create sequence HrmGroupSuggest_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 281
increment by 1
cache 20
/
create or replace trigger HrmGroupSuggest_ID_Tri before insert on HrmGroupSuggest for each row begin select HrmGroupSuggest_ID.nextval into :new.id from dual; end;
/