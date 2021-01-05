ALTER table cus_formsetting
ADD  base_datatable VARCHAR(50);
GO
ALTER table cus_formsetting
ADD  base_id VARCHAR(50);
GO
ALTER table cus_formsetting
ADD  defined_datatable VARCHAR(50);
GO
ALTER table cus_formsetting
ADD  base_definedid VARCHAR(50);
GO
ALTER table cus_formsetting
ADD  scopeid int;
GO
ALTER TABLE hrm_formfield 
ADD imgwidth INT
GO
ALTER TABLE hrm_formfield 
ADD imgheight INT
GO
ALTER TABLE hrm_formfield 
ADD textheight INT
GO
ALTER TABLE hrm_formfield 
ADD issystem INT
GO
CREATE TABLE HrmDepartmentDefined
(
 id INT PRIMARY KEY IDENTITY(1,1),
 deptid INT NOT NULL
)
GO
CREATE TABLE HrmSubcompanyDefined
(
 id INT PRIMARY KEY IDENTITY(1,1),
 subcomid INT NOT NULL
)
GO
INSERT INTO cus_formsetting( id , module , page , status , page_url , base_datatable , defined_datatable ,scopeid , base_definedid , base_id)
VALUES  ( 13 , 'hrm' , 'HrmSubCompanyDsp' , 2 ,  NULL , 'hrmsubcompany' ,  'hrmsubcompanydefined' , 4 ,  'subcomid' , 'id' )
GO
INSERT INTO cus_formsetting( id , module , page , status , page_url , base_datatable , defined_datatable ,scopeid , base_definedid , base_id)
VALUES  ( 14 , 'hrm' , 'HrmDepartmentDsp' , 2 ,  NULL , 'hrmdepartment' ,  'hrmdepartmentdefined' , 5 ,  'deptid' , 'id' )
GO
