ALTER table cus_formsetting
ADD  base_datatable VARCHAR(50)
/
ALTER table cus_formsetting
ADD  base_id VARCHAR(50)
/
ALTER table cus_formsetting
ADD  defined_datatable VARCHAR(50)
/
ALTER table cus_formsetting
ADD  base_definedid VARCHAR(50)
/
ALTER table cus_formsetting
ADD  scopeid int
/
ALTER TABLE hrm_formfield 
ADD imgwidth INT
/
ALTER TABLE hrm_formfield 
ADD imgheight INT
/
ALTER TABLE hrm_formfield 
ADD textheight INT
/
ALTER TABLE hrm_formfield 
ADD issystem INT
/
CREATE TABLE HrmDepartmentDefined
(
 id INT PRIMARY KEY NOT NULL,
 deptid INT NOT NULL
)
/
create sequence HrmDepartmentDefined_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 281
increment by 1
cache 20
/
create or replace trigger HrmDepartDefined_id_Tri before insert on HrmDepartmentDefined for each row begin select HrmDepartmentDefined_ID.nextval into :new.id from dual; end;
/
CREATE TABLE HrmSubcompanyDefined
(
 id INT PRIMARY KEY NOT NULL,
 subcomid INT NOT NULL
)
/
create sequence HrmSubcompanyDefined_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 281
increment by 1
cache 20
/
create or replace trigger HrmSubcomDefined_id_Tri before insert on HrmSubcompanyDefined for each row begin select HrmSubcompanyDefined_ID.nextval into :new.id from dual; end;
/
INSERT INTO cus_formsetting( id , module , page , status , page_url , base_datatable , defined_datatable ,scopeid , base_definedid , base_id)
VALUES  ( 13 , 'hrm' , 'HrmSubCompanyDsp' , 2 ,  NULL , 'hrmsubcompany' ,  'hrmsubcompanydefined' , 4 ,  'subcomid' , 'id' )
/
INSERT INTO cus_formsetting( id , module , page , status , page_url , base_datatable , defined_datatable ,scopeid , base_definedid , base_id)
VALUES  ( 14 , 'hrm' , 'HrmDepartmentDsp' , 2 ,  NULL , 'hrmdepartment' ,  'hrmdepartmentdefined' , 5 ,  'deptid' , 'id' )
/
