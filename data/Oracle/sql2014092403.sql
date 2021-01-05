ALTER TABLE hrmdepartment ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE CRM_CustomerInfo ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE DocTreeDocField ADD ecology_pinyin_search varchar2(300) 
/
ALTER TABLE HrmRoles ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE hrmsubcompany ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE CptCapital ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE Prj_ProjectInfo ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE docdetail ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE Meeting_Type ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE workflow_nodebase ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE workflow_base ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE workflow_requestbase ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE DocSecCategory ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE CRM_CustomerContacter ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE hrmresource ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE hrmjobtitles ADD ecology_pinyin_search varchar2(300)
/
ALTER TABLE workflow_nodelink ADD ecology_pinyin_search varchar2(300)
/
CREATE OR REPLACE  TRIGGER hrmdepartment_getpinyin 
  before insert or update of departmentname on hrmdepartment
  for each row 
  begin
  select Lower(getpinyin((:new.departmentname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/



CREATE OR REPLACE  TRIGGER CRM_CustomerInfo_getpinyin 
 before insert or update of name on CRM_CustomerInfo
  for each row 
  begin
  select Lower(getpinyin((:new.name)))
    into :new.ecology_pinyin_search
    from dual;
end;
/
 
 CREATE OR REPLACE  TRIGGER DocTreeDocField_getpinyin 
 before insert or update of treeDocFieldName on DocTreeDocField
  for each row 
  begin
  select Lower(getpinyin((:new.treeDocFieldName)))
    into :new.ecology_pinyin_search
    from dual;
end;
/

 CREATE OR REPLACE  TRIGGER HrmRoles_getpinyin 
 before insert or update of rolesname on HrmRoles
  for each row 
  begin
  select Lower(getpinyin((:new.rolesname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/

CREATE OR REPLACE  TRIGGER hrmsubcompany_getpinyin 
before insert or update of subcompanyname on hrmsubcompany
  for each row 
  begin
  select Lower(getpinyin((:new.subcompanyname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/




CREATE OR REPLACE  TRIGGER CptCapital_getpinyin 
before insert or update of name on CptCapital
  for each row 
  begin
  select Lower(getpinyin((:new.name)))
    into :new.ecology_pinyin_search
    from dual;
end;
/



CREATE OR REPLACE  TRIGGER Prj_ProjectInfo_getpinyin 
before insert or update of name on Prj_ProjectInfo
  for each row 
  begin
  select Lower(getpinyin((:new.name)))
    into :new.ecology_pinyin_search
    from dual;
end;
/


CREATE OR REPLACE  TRIGGER docdetail_getpinyin 
before insert or update of docsubject on docdetail
  for each row 
  begin
  select Lower(getpinyin((:new.docsubject)))
    into :new.ecology_pinyin_search
    from dual;
end;
/

 

CREATE OR REPLACE  TRIGGER Meeting_Type_getpinyin
before insert or update of name on Meeting_Type
  for each row 
  begin
  select Lower(getpinyin((:new.name)))
    into :new.ecology_pinyin_search
    from dual;
end;
/

CREATE OR REPLACE  TRIGGER workflow_nodebase_getpinyin
before insert or update of nodename on workflow_nodebase
  for each row 
  begin
  select Lower(getpinyin((:new.nodename)))
    into :new.ecology_pinyin_search
    from dual;
end;
/



CREATE OR REPLACE  TRIGGER workflow_base_getpinyin
before insert or update of workflowname on workflow_base
  for each row 
  begin
  select Lower(getpinyin((:new.workflowname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/

CREATE OR REPLACE  TRIGGER workflow_requestbase_getpinyin
before insert or update of requestname on workflow_requestbase
  for each row 
  begin
  select Lower(getpinyin((:new.requestname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/


CREATE OR REPLACE  TRIGGER DocSecCategory_getpinyin
before insert or update of categoryname on DocSecCategory
  for each row 
  begin
  select Lower(getpinyin((:new.categoryname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/

CREATE OR REPLACE  TRIGGER CRM_Contacter_getpinyin 
before insert or update of fullname on CRM_CustomerContacter
  for each row 
  begin
  select Lower(getpinyin((:new.fullname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/


CREATE OR REPLACE  TRIGGER hrmresource_getpinyin
before insert or update of lastname on hrmresource
  for each row 
  begin
  select Lower(getpinyin((:new.lastname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/

CREATE OR REPLACE  TRIGGER workflow_nodelink_getpinyin
before insert or update of linkname on workflow_nodelink
  for each row 
  begin
  select Lower(getpinyin((:new.linkname)))
    into :new.ecology_pinyin_search
    from dual;
end;
/


