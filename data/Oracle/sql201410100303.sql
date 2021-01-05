create table cus_formsetting (
   id                   int                  null,
   module               varchar(60)          null,
   page                 varchar(200)         null,
   status               int                  null,
   page_url             varchar(500)         null
)
/
INSERT INTO cus_formsetting( id, module, page, status, page_url )
VALUES  ( 1,'hrm','HrmResourceBase',0,null)
/        
INSERT INTO cus_formsetting( id, module, page, status, page_url )
VALUES  ( 2,'hrm','HrmResourcePersonal',0,NULL)        
/         
INSERT INTO cus_formsetting( id, module, page, status, page_url )
VALUES  ( 3,'hrm','HrmResourceWork',0,NULL)
/