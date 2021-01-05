/*个人设置 label*/
INSERT INTO HtmlLabelIndex values(17627,'个人设置') 
/
INSERT INTO HtmlLabelInfo VALUES(17627,'个人设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17627,'user setting',8) 
/

/*RTX是否自动登陆 label*/
INSERT INTO HtmlLabelIndex values(17628,'RTX是否自动登陆') 
/
INSERT INTO HtmlLabelInfo VALUES(17628,'RTX是否自动登陆',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17628,'RTX AutoOnload',8) 
/

/* 用户自定义的设置表 */
CREATE TABLE HrmUserSetting ( 
    id integer NOT NULL,
    resourceId integer,
    rtxOnload char(1)) 
/
create sequence HrmUserSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmUserSetting_Trigger
before insert on HrmUserSetting
for each row
begin
select HrmUserSetting_id.nextval into :new.id from dual;
end;
/
