CREATE TABLE LMMEETINGFORTOP
(
       ID int primary key not null identity(1,1), 
       MEETINGPIC VARCHAR(4000) NULL,
       MEETPICNAME VARCHAR(500) NULL,
       CREATEDATETIME CHAR(20) NOT NULL,      
       LASTUPDATETIME CHAR(20) NOT NULL,   
       MEETBEGINDATE CHAR(10),
       MEETENDDATE CHAR(10),
       ISDEL CHAR(1) NOT NULL                  
)
GO
CREATE TABLE CPBUSINESSLICENSE 
(
       LICENSEID int primary key not null identity(1,1), 
       COMPANYID int NOT NULL, 
       requestname varchar(400),
       requestaffixid varchar(4000),
       LICENSEAFFIXID int NOT NULL, 
       REGISTERADDRESS varchar(4000) NULL,
       CORPORATION varchar(200) NULL,    
       RECORDNUM varchar(200) NULL,  
       requestid int,
       USEFULBEGINDATE CHAR(10) NULL,        
       USEFULENDDATE CHAR(10) NULL,         
       USEFULYEAR  VARCHAR(10) NULL,         
       DATEINSSUE  CHAR(10) NOT NULL,        
       LICENSESTATU  CHAR(1) NULL,            
       ANNUALINSPECTION  CHAR(10) NULL,       
       DEPARTINSSUE  varchar(4000) NOT NULL,  
       SCOPEBUSINESS varchar(4000) NULL,      
       REGISTERCAPITAL varchar(200) NULL,   
       PAICLUPCAPITAL  varchar(200) NULL,     
       CURRENCYID  int NULL,              
       CORPORATDELEGATE  VARCHAR(50) NULL,    
       LICENSEREGISTNUM  varchar(200) NULL,                                
       MEMO varchar(4000) NULL,   
       affixdoc varchar(4000),
       VERSIONID int NULL,  
       mainlicenseid int,
       CREATEDATETIME CHAR(20) NOT NULL,       
       LASTUPDATETIME CHAR(20) NOT NULL,  
       companytype varchar(200),
       ISDEL CHAR(1) NOT NULL                   
)
GO
CREATE TABLE CPLMLICENSEAFFIX   
(
       LICENSEAFFIXID  int primary key not null identity(1,1), 
       LICENSENAME varchar(500) NOT NULL,          
       LICENSETYPE CHAR(1) NULL,     
       affixindex int,
       AFFIXDOC  VARCHAR(4000)  NULL,  
       ISMULTI   int,
       UPLOADDATETIME  CHAR(20) NOT NULL                
)
GO
CREATE TABLE CPBOARDDIRECTORS                   
(
  DIRECTORSID int primary key not null identity(1,1), 
  COMPANYID int NOT NULL,          
  CHAIRMAN varchar(200)  NOT NULL,          
  APPOINTBEGINDATE  CHAR(10) NOT NULL,          
  APPOINTENDDATE  CHAR(10) NOT NULL,                  
  SUPERVISOR varchar(200)  NULL,            
  GENERALMANAGER varchar(200)  NULL,          
  DRECTORSAFFIX varchar(4000)  NULL,         
  VERSIONID int NULL,   
  managerbegindate char(10),
  managerenddate char(10),
  managerduetime varchar(50),
  APPOINTDUETIME varchar(50),
  LICENSEID int NULL, 
  ischairman char(1),
  CREATEDATETIME CHAR(20) NOT NULL,          
  LASTUPDATETIME CHAR(20) NOT NULL,           
  ISDEL CHAR(1) NOT NULL                   
)
GO
CREATE TABLE CPBOARDOFFICER  
(
       BOARDOFFICERID int primary key not null identity(1,1), 
       DIRECTORSID int NOT NULL,              
       SESSIONS  varchar(50)  NULL,                      
       OFFICENAME  varchar(200) NULL,             
       OFFICEBEGINDATE CHAR(10)  NULL,  
       remark varchar(4000),
       OFFICEENDDATE CHAR(10)  NULL,               
       ISSTOP  CHAR(1)  NOT NULL                    
)
GO
CREATE TABLE CPCONSTITUTION     
(
       CONSTITUTIONID int primary key not null identity(1,1),                
       AGGREGATEINVEST varchar(50)  NULL,             
       THEBOARD  varchar(500)  NOT NULL,                
       STITUBEGINDATE  CHAR(10) NOT NULL,              
       STITUENDDATE  CHAR(10) NOT NULL,                 
       ISVISITORS  CHAR(1)  NULL,                      
       BOARDVISITORS varchar(500) NOT NULL,            
       VISITBEGINDATE  CHAR(10) NULL,                    
       VISITENDDATE  CHAR(10) NULL,                              
       ISREAPPOINT CHAR(1) NULL,                        
       GENERALMANAGER varchar(200)  NULL,             
       EFFECTBEGINDATE CHAR(10)  NULL,            
       EFFECTENDDATE CHAR(10)   NULL,              
       CONSTITUAFFIX varchar(4000)  NULL,          
       VERSIONID int NULL,                      
       CREATEDATETIME CHAR(20) NOT NULL,               
       LASTUPDATETIME CHAR(20) NOT NULL, 
       currencyid char(1),
       APPOINTDUETIME varchar(50),
       companyid int,
       ISDEL CHAR(1) NOT NULL                        
)
GO
CREATE TABLE CPSHAREHOLDER      
(
       SHAREID int primary key not null identity(1,1),                                
       BOARDSHAREHOLDER  varchar(500)  NOT NULL,       
       ESTABLISHED CHAR(10) NOT NULL,   
       companyid int,
       SHAREAFFIX  varchar(4000) NULL,                
       VERSIONID int NULL,                         
       CREATEDATETIME CHAR(20) NOT NULL,               
       LASTUPDATETIME CHAR(20) NOT NULL,              
       ISDEL CHAR(1) NOT NULL                         
)
GO
CREATE TABLE CPSHAREOFFICERS  
(
       SHAREOFFICERID int primary key not null identity(1,1),     
       SHAREID int NOT NULL,    
       companyid int,
       ishow char(1),
       OFFICERNAME varchar(200) NULL,                        
       ISSTOP  CHAR(1)  NOT NULL,                               
       AGGREGATEINVEST varchar(50) NULL,                      
       AGGREGATEDATE CHAR(10) NULL,  
       CURRENCYID int,
       INVESTMENT  VARCHAR(20)  NULL                             
)
GO
CREATE TABLE CPBUSINESSTYPE      
(
       ID int primary key not null identity(1,1),            
       BUSITYPENAME  varchar(50) NULL,            
       BUSITYPEORDER int NULL                  
)
GO
CREATE TABLE CPBUSINESSLICENSEVERSION    
(
  VERSIONID int primary key not null identity(1,1),          
  LICENSEID int NOT NULL,                                                                 
  CREATEDATETIME  CHAR(20) NOT NULL,                  
  VERSIONMEMO VARCHAR(4000) NULL,  
  VERSIONNUM varchar(50),
  VERSIONNAME varchar(200),
  addway varchar(50),
  COMPANYID int,
  LICENSEAFFIXID int ,
  REGISTERADDRESS varchar(4000),
  CORPORATION varchar(200),
  RECORDNUM varchar(200),
  USEFULBEGINDATE CHAR(10),
  USEFULENDDATE CHAR(10),
  USEFULYEAR  VARCHAR(10),
  DATEINSSUE  CHAR(10),
  LICENSESTATU  CHAR(1),
  ANNUALINSPECTION  CHAR(10),
  DEPARTINSSUE  varchar(4000),
  SCOPEBUSINESS varchar(4000),
  REGISTERCAPITAL varchar(200),
  PAICLUPCAPITAL  varchar(200),
  CURRENCYID  int,
  CORPORATDELEGATE  VARCHAR(50),
  LICENSEREGISTNUM  varchar(200),
  MEMO varchar(4000),
  affixdoc varchar(4000),
  companytype varchar(200),
  requestid int,
  requestname varchar(400),
  requestaffixid varchar(4000),
  VERSIONAFFIX  VARCHAR(4000)  NULL               
)
GO
CREATE TABLE CPBOARDVERSION   
(
  VERSIONID int primary key not null identity(1,1),    
  DIRECTORSID int NOT NULL,                                           
  CREATEDATETIME  CHAR(20) NOT NULL,                    
  VERSIONMEMO VARCHAR(4000) NULL,                   
  VERSIONAFFIX  VARCHAR(4000)  NULL  ,
  COMPANYID int,
  CHAIRMAN varchar(200),
  managerbegindate char(10),
  managerenddate char(10),
  managerduetime varchar(50),
  APPOINTBEGINDATE CHAR(10),
  APPOINTENDDATE CHAR(10),
  appointduetime varchar(50),
  SUPERVISOR varchar(200),
  GENERALMANAGER varchar(200),
  DRECTORSAFFIX varchar(4000),
  VERSIONNUM varchar(50),
  VERSIONNAME varchar(200),
  ischairman char(1)
)
GO
CREATE TABLE CPCONSTITUTIONVERSION     
(
  VERSIONID int primary key not null identity(1,1),          
  CONSTITUTIONID int NOT NULL,                                                      
  CREATEDATETIME  CHAR(20) NOT NULL,                    
  VERSIONMEMO VARCHAR(4000) NULL,              
  VERSIONAFFIX  VARCHAR(4000)  NULL  ,
  AGGREGATEINVEST varchar(50),
  THEBOARD  varchar(500),
  STITUBEGINDATE CHAR(10),
  STITUENDDATE CHAR(10),
  ISVISITORS CHAR(1),
  appointduetime varchar(50),
  BOARDVISITORS varchar(500),
  VISITBEGINDATE CHAR(10),
  VISITENDDATE CHAR(10),
  ISREAPPOINT CHAR(1),
  GENERALMANAGER varchar(200),
  EFFECTBEGINDATE CHAR(10),
  EFFECTENDDATE CHAR(10),
  CONSTITUAFFIX varchar(4000),
  currencyid char(1),
  companyid int,
  VERSIONNUM varchar(50),
  VERSIONNAME varchar(200)
)
GO
CREATE TABLE CPSHAREHOLDERVERSION     
(
  VERSIONID int primary key not null identity(1,1),          
  SHAREID int NOT NULL,                                                                  
  CREATEDATETIME  CHAR(20) NOT NULL,               
  VERSIONMEMO VARCHAR(4000) NULL,                   
  VERSIONAFFIX  VARCHAR(4000)  NULL ,
  BOARDSHAREHOLDER  varchar(500),
  ESTABLISHED CHAR(10),
  SHAREAFFIX  varchar(4000),
  companyid int,
  VERSIONNUM varchar(50),
  VERSIONNAME varchar(200)
)
GO
CREATE TABLE CPCOMPANYAFFIXSEARCH
(
       ID int primary key not null identity(1,1),
       SEARCHFIELD0 varchar(200) NULL,
       SEARCHFIELD1 varchar(200) NULL,
       SEARCHFIELD2 varchar(200) NULL,
       SEARCHFIELD3 varchar(200) NULL,
       SEARCHFIELD4 varchar(200) NULL,
       SEARCHFIELD5 varchar(200) NULL,
       SEARCHFIELD6 varchar(200) NULL,
       SEARCHFIELD7 varchar(200) NULL,
       SEARCHFIELD8 varchar(200) NULL,
       SEARCHFIELD9 varchar(200) NULL,
       SEARCHSHIP0 varchar(200) NULL,
       SEARCHSHIP1 varchar(200) NULL,
       SEARCHSHIP2 varchar(200) NULL,
       SEARCHSHIP3 varchar(200) NULL,
       SEARCHSHIP4 varchar(200) NULL,
       SEARCHSHIP5 varchar(200) NULL,
       SEARCHSHIP6 varchar(200) NULL,
       SEARCHSHIP7 varchar(200) NULL,
       SEARCHSHIP8 varchar(200) NULL,
       WHICHMOUDEL varchar(50) NULL,
       SEARCHCONDITION varchar(4000) NULL,
       SEARCHNAME varchar(200) NULL,
       CREATEDATETIME CHAR(20) NOT NULL,
       LASTUPDATETIME CHAR(20) NOT NULL, 
       ISDEL CHAR(1) NOT NULL ,
       userid int,
       companyid int
)
GO
CREATE TABLE CPCOMPANYTIMEOVER
(
  ID int primary key not null identity(1,1),
  tofaren varchar(200),
  todsh varchar(200),
  tozhzh varchar(200),
  togd varchar(200),
  tozhch varchar(200),
  tonjian varchar(200),
  chdsh varchar(200),
  chzhzh varchar(200),
  chgd varchar(200),
  chzhch varchar(200),
  chxgs varchar(200)   
)
Go
CREATE TABLE CPCOMPANYUPGRADE
(
       ID int primary key not null identity(1,1),
       UPTYPE varchar(200) NULL,
       UPVERSION varchar(50) NULL,
       discription varchar(500),
       companyid int,
       CREATEDATETIME CHAR(20) NOT NULL
)
GO
create table GroupVersionInfo(
	ID int primary key not null identity(1,1),
	companyid   INTEGER,
	no varchar(50) null,
	name varchar(200) null,
	createdate varchar(20) null,
	gdesc varchar(4000) null,
	xmlconent text null
)
GO
create table CPBOARDSUPER(
       BOARDSUPERID int primary key not null identity(1,1),
       DIRECTORSID int NOT NULL,
       SUPERNAME varchar(200) NULL,
       SUPERBEGINDATE CHAR(10) NULL,
       SUPERENDDATE CHAR(10) NULL,
       ISSTOP CHAR(1) NULL,
       REMARK varchar(4000) NULL,
       SESSIONS varchar(50) NULL
)
GO
create table cpcominforight
( 
  id  int primary key not null identity(1,1),
  comid    int,
  comrright  int,
  permtype  int,
  seclevel  int,
  subComid  int,
  depid  int,
  roleid  int,
  userid  int,
  rolelevel  int,
  usertype  int,
  comallright     int
)
GO
create table CPCOMPANYINFO
( 
	companyid int primary key not null identity(1,1),
	archivenum  varchar(500) NULL,
        COMPANYSTATU CHAR(1),
	LOANCARD varchar(50),
	createdatetime CHAR(20),
	lastupdatetime CHAR(20),
	isdel CHAR(1),
	companyvestin char(1),
	BUSINESSTYPE int,
	COMPANYREGION int,
	companyname    varchar(500),
	COMPANYADDRESS varchar(500),
	subcompanyid int,
	cpparentid varchar(4000),
	COMPANYENAME  varchar(500)
)
GO
insert into CPCOMPANYTIMEOVER (tofaren,todsh,tozhzh,togd,tozhch,Tonjian)
values ('30','30','30','30','30','30')
GO
CREATE TABLE CPGDTEMP(
   COMPANYID int NULL,
   CPSTATU varchar(10) NULL
)
GO
CREATE TABLE CPGDLINE(
   COMPANYIDS varchar(50) NULL,
   CPPOINT varchar(200) NULL
)
GO
create table GroupRelation
(
    cpid int null,
    cpparentid varchar(4000) null
)
GO
create table CPBOARDSUPERVERSION(
       versionnum varchar(50) null,
       DIRECTORSID int NOT NULL,
       SUPERNAME varchar(200) NULL,
       SUPERBEGINDATE CHAR(10) NULL,
       SUPERENDDATE CHAR(10) NULL,
       ISSTOP CHAR(1) NULL,
       REMARK varchar(4000) NULL,
       SESSIONS varchar(50) NULL
)
GO
create table pro_taskLog
( 
    plog_id   int primary key not null identity(1,1),
    plog_qf   varchar(100),
    plog_protaskid   varchar(100),
    plog_proname         varchar(500),
    plog_coding       varchar(500),
    plog_desc    varchar(1000),
    plog_data    varchar(20),
    plog_time    varchar(20),
    plog_person   varchar(50)
)
GO
insert into CPLMLICENSEAFFIX (Licensename,Licensetype,Uploaddatetime) values('企业法人营业执照','1','2011-01-01 00:00:00')
GO
CREATE TABLE CPBOARDOFFICERVERSION
( 
       versionnum varchar(50) NOT NULL,
       DIRECTORSID int NOT NULL,
       SESSIONS  int  NULL,
       OFFICENAME  varchar(200) NULL,  
       OFFICEBEGINDATE CHAR(10)  NULL,
       OFFICEENDDATE CHAR(10)  NULL,
       ISSTOP  CHAR(1)  NOT NULL,
       REMARK varchar(4000) NULL
)
GO
CREATE TABLE CPSHAREOFFICERSVERSION
(
       versionnum varchar(50),
       VERSIONTYPE varchar(20) NULL,
       SHAREID int NOT NULL,
       OFFICERNAME varchar(200) NULL,
       ISSTOP	CHAR(1)	NOT NULL,
       AGGREGATEINVEST varchar(50) NULL,
       AGGREGATEDATE CHAR(10) NULL,
       INVESTMENT	VARCHAR(20)	NULL,
       COMPANYID int NULL,
       ishow char(1),
       CURRENCYID int NULL
)
GO
CREATE TABLE CompanyBusinessService 
(
       id int primary key not null identity(1,1),
       name varchar(400)             
)
GO
CREATE TABLE Companyattributable 
(
       id int primary key not null identity(1,1),
       name varchar(400)             
)
GO
CREATE TABLE mytrainaccessoriestype 
(
       id int primary key not null identity(1,1),
       mainId varchar(10),
       subId  varchar(10),
       secId  varchar(10),
       accessoriesname    varchar(50),
       isuse    int       
)
GO
CREATE TABLE CPCOMPANYINFOAB 
(
     ABtime varchar(20),
     status varchar(2)
)
GO
insert into CPCOMPANYINFOAB (abtime,status) values('','s')
GO
insert into mytrainaccessoriestype (mainid,subid,secid,accessoriesname,isuse) values (0,0,0,'trainaffix',5)
GO
insert into mytrainaccessoriestype (mainid,subid,secid,accessoriesname,isuse) values(0,0,0,'topmeeting',7)
GO
insert into mytrainaccessoriestype(mainid,subid,secid,accessoriesname,isuse)values(0,0,0,'lmlicense',8)
GO
insert into mytrainaccessoriestype(mainid,subid,secid,accessoriesname,isuse)values(0,0,0,'lmconstitution',9)
GO
insert into mytrainaccessoriestype(mainid,subid,secid,accessoriesname,isuse)values(0,0,0,'lmshare',10)
GO
insert into mytrainaccessoriestype(mainid,subid,secid,accessoriesname,isuse)values(0,0,0,'lmdirectors',11)
GO