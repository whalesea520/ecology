alter table workflow_agent add backDate char(10)
/
alter table workflow_agent add backTime char(8)
/

create table cotype_sharemanager(
    id integer,
    cotypeid integer,
    sharetype integer,
    sharevalue varchar2(4000),
    seclevel integer,
    rolelevel integer
)
/
create sequence sharemanager_Id start with 1 increment by 1 nomaxvalue nocycle
/
CREATE OR REPLACE TRIGGER sharemanager_Id_Trigger before insert on cotype_sharemanager for each row begin select sharemanager_Id.nextval into :new.id from dual; end;
/

create table cotype_sharemembers(
    id integer,
    cotypeid integer,
    sharetype integer,
    sharevalue varchar2(4000),
    seclevel integer,
    rolelevel integer
)
/
create sequence sharemembers_Id start with 1 increment by 1 nomaxvalue nocycle
/
CREATE OR REPLACE TRIGGER sharemembers_Id_Trigger before insert on cotype_sharemembers for each row begin select sharemembers_Id.nextval into :new.id from dual; end;
/

create or replace procedure InitCotypePro
as 
typeid integer;
managerid clob;
members clob;
pos1 integer;
begin
    for initcotypes IN (select id,managerid,members from cowork_types)
    loop
        typeid:=initcotypes.id;
        managerid:=initcotypes.managerid;
        members:=initcotypes.members;

        while length(managerid)<>0 loop
 
            if length(managerid)>4000 then
                pos1:=DBMS_LOB.INSTR(managerid,',',3500,1);
                insert into cotype_sharemanager(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values(typeid,1,DBMS_LOB.substr(managerid,pos1,1),0,0);
                managerid:=DBMS_LOB.substr(managerid,length(managerid),pos1);
            else  
		        insert into cotype_sharemanager(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values(typeid,1,managerid,0,0);
                managerid:='';   
            end if;  
        end loop; 
    
        while length(members)<>0 loop
 
           if length(members)>4000 then
                pos1:=DBMS_LOB.INSTR(members,',',3500,1);
                insert into cotype_sharemembers(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values(typeid,1,DBMS_LOB.substr(members,pos1,1),0,0);
                members:=DBMS_LOB.substr(members,length(members),pos1);
           else  
		        insert into cotype_sharemembers(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values(typeid,1,members,0,0);
                members:='';   
           end if;  
        end loop; 
 
    end loop;
end;
/

call InitCotypePro()
/

drop procedure InitCotypePro
/
