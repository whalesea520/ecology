CREATE TABLE outter_network(
	 id  int not null,
	inceptipaddress varchar2(1000) NULL,
	endipaddress varchar2(1000) NULL,
	sysid  varchar2(1000) NULL
	
)
/
create sequence  outter_network_seq  increment by 1 start with 1
/
create or replace trigger outter_network_tri
          before insert on outter_network     
          for each row                       
          begin                              
                 select outter_network_seq.nextval into :new.id from dual;   
          end;
 /
alter table outter_sys add autologin char(1)
/
CREATE TABLE outter_encryptclass(
	 id  int not null,
	encryptclass varchar2(1000) NULL,
	encryptmethod varchar2(1000) NULL
	
	
)
/
create sequence  outter_encryptclass_seq  increment by 1 start with 1
/
create or replace trigger outter_encryptclass_tri
          before insert on outter_encryptclass     
          for each row                       
          begin                              
                 select outter_encryptclass_seq.nextval into :new.id from dual;   
          end;
 /
alter table outter_sys add encryptclassId int 
/
alter table outter_sys add imagewidth int 
/
alter table outter_sys add imageheight int 
/
CREATE TABLE outter_Moreview1(
	 id  int not null,
	c1 varchar2(4000) NULL,
	c2 varchar2(4000) NULL,
	c3 varchar2(4000) NULL,
	c4 varchar2(4000) NULL,
	c5 varchar2(4000) NULL
	
)
/
create sequence  outter_Moreview1_seq  increment by 1 start with 1
/
create or replace trigger outter_Moreview1_tri
          before insert on outter_Moreview1     
          for each row                       
          begin                              
                 select outter_Moreview1_seq.nextval into :new.id from dual;   
          end;
 /