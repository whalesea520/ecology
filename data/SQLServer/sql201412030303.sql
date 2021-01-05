CREATE TABLE WR_ReportShare(
id               INT identity,
reportid         INT NULL ,      
sharetype        INT NULL ,      
seclevel         TINYINT NULL , 
roleid           INT NULL ,   
rolelevel        TINYINT NULL , 
sharelevel       TINYINT NULL ,
userid           VARCHAR(1000) NULL,
deptid           VARCHAR(1000) NULL,
mutiuserid       VARCHAR(1000) NULL, 
mutideptid       VARCHAR(1000) NULL, 
muticpyid        VARCHAR(1000) NULL,
constraint PK_WR_REPORTSHARE primary key (id)
)
GO
