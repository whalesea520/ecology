alter table outter_sys add  urlencodeflag char(1)
/
alter table outter_sys add  urllinkimagid int
/
 
CREATE TABLE shareoutter(
	id int  NOT NULL,
	sysid  varchar2(1000)  NOT NULL,
	type int NOT NULL,
	content int NOT NULL,
	seclevel int NOT NULL,
	sharelevel int NOT NULL,
	seclevelmax varchar2(1000) NULL
)
/
create sequence shareoutter_seq  increment by 1 start with 1
/
 create or replace trigger shareoutter_tri
          before insert on shareoutter     
          for each row                       
          begin                              
                 select shareoutter_seq.nextval into :new.id from dual;   
          end;
/
INSERT INTO hpBaseElement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleen,titlethk,loginview)
VALUES ('outterSys','2','集成登录','resource/image/jobsinfo_wev8.gif',10,'2','getJobsInfoMore','集成登录','1','Integrated login','集成登录',0)
/
