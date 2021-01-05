declare 
      num   number; 
begin 
      select count(1) into num from user_tables where TABLE_NAME = 'CRM_FAILFACTOR'; 
      if   num=0   then 
          execute immediate 'CREATE TABLE CRM_FAILFACTOR
   (	ID NUMBER(*,0) PRIMARY KEY, 
	FULLNAME VARCHAR2(150 BYTE), 
	DESCRIPTION VARCHAR2(150 BYTE), 
	ORDERKEY NUMBER(*,0)
   )'; 
      end   if; 
end; 
/ 