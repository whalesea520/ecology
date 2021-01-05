alter table DocSecCategoryShare modify  seclevelmax char(10)   DEFAULT '255' 
/
alter table docshare modify  seclevelmax char(10)  DEFAULT '255'  
/
alter table DirAccessControlList modify  seclevelmax  char(10)   DEFAULT '255'
/
alter table DirAccessControlDetail modify  seclevelmax    char(10)   DEFAULT '255' 
/
alter table shareinnerdoc modify   seclevelmax char(10)  DEFAULT '255'
/
alter table ShareouterDoc modify   seclevelmax char(10)  DEFAULT '255' 
/