alter table CptCapitalShareInfo add isdefault int
/

alter table Prj_ShareInfo add isdefault int
/
CREATE TABLE prj_members(id int  not null,relateditemid int null,userid int null)
/
create sequence prj_members_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_members_TRIGGER before insert on prj_members for each row 
begin select prj_members_ID.nextval into :new.id from dual; end;
/


create or replace trigger trg_prjmembers_update
AFTER INSERT OR UPDATE OF members ON Prj_ProjectInfo
FOR EACH ROW
declare 
  i_prjid int;
  i_members varchar2(4000);
  i_isblock int;
  i_idx int;
  i_userid int;
begin
    i_members:=:new.members||',';
    i_isblock:=:new.isblock;
    i_prjid:=:new.id;
    delete from prj_members where relateditemid=i_prjid;
    
    if i_isblock!=1 THEN RETURN; end if;
   	if i_members='' THEN RETURN; end if;
   	if i_members is null THEN RETURN; end if;
   	
   	i_idx:=INSTR(i_members,',',1,1) ;
	  
    while i_idx>0
    loop
      i_userid:=to_number(SUBSTR(i_members,0,(i_idx-1)));
      if i_userid>0 then
      	insert into prj_members(relateditemid,userid) values(i_prjid,i_userid);
      end if;
      i_members:=SUBSTR(i_members,(i_idx+1),LENGTH(i_members));
      i_idx:=INSTR(i_members,',',1,1);
    end loop;
end;
/


create or replace type hrmline_table as object
(
  id int,
  lastname varchar2(50),
  managerid int
)
/
create or replace type t_table is table of hrmline_table;
/
create or replace function getchilds(i_id int)
return t_table pipelined as v hrmline_table;
begin    
	for myrow in(
		select id,lastname,managerid from hrmresource where id=i_id
		union
		select  a.id,a.lastname,a.managerid from HrmResource a  start with a.id = i_id connect by prior a.id=a.managerid
	)
	loop 
	v:=hrmline_table(myrow.id,myrow.lastname,myrow.managerid);
	pipe row(v);
	end loop;
	return;
end;
/

create or replace function getparents(i_id int)
return t_table pipelined as v hrmline_table;
begin    
	for myrow in(
		select id,lastname,managerid from hrmresource where id=i_id
		union
		select  a.id,a.lastname,a.managerid from HrmResource a  start with a.id = i_id connect by prior a.managerid=a.id
	)
	loop 
	v:=hrmline_table(myrow.id,myrow.lastname,myrow.managerid);
	pipe row(v);
	end loop;
	return;
end;
/


CREATE OR REPLACE PROCEDURE CptAstShareInfo_Insert_dft 
(relateditemid_1 integer, sharetype_2 int, seclevel_3 smallint, rolelevel_4 smallint, sharelevel_5 smallint, userid_6 integer, departmentid_7 integer, roleid_8 integer, foralluser_9 smallint, sharefrom_10 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS 
begin 
	INSERT INTO CptCapitalShareInfo (relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser, sharefrom,isdefault) VALUES (relateditemid_1, sharetype_2, seclevel_3, rolelevel_4, sharelevel_5, userid_6, departmentid_7, roleid_8, foralluser_9, sharefrom_10,1);
end;
/

drop procedure Prj_ShareInfo_Update
/
CREATE OR REPLACE PROCEDURE Prj_ShareInfo_Update 
( typeid_1 integer , customerid_1 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) 
as 
theid_1 integer; relateditemid_1 integer; sharetype_1 smallint ; seclevel_1 smallint  ; rolelevel_1 smallint  ; sharelevel_1 smallint  ; userid_1 integer  ; departmentid_1 integer  ; roleid_1 integer  ; foralluser_1 smallint  ; crmid_1 integer; 
begin 
	for all_cursor IN (select id from Prj_T_ShareInfo WHERE relateditemid = typeid_1) loop theid_1 := all_cursor.id; 
	select   sharetype, seclevel , rolelevel, sharelevel, userid, departmentid, roleid, foralluser, crmid INTO sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,departmentid_1,roleid_1,foralluser_1, crmid_1 from Prj_T_ShareInfo WHERE id = theid_1; 
	insert INTO  Prj_ShareInfo (relateditemid ,	sharetype  ,seclevel ,rolelevel  ,sharelevel,userid ,departmentid ,	roleid,	foralluser ,crmid,isdefault ) 			values(customerid_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,departmentid_1,			roleid_1,foralluser_1,crmid_1,1) ; 
	end loop; 
end;
/



































