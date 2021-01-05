update MainMenuInfo set labelId=16455, linkAddress='/hrm/company/HrmCompany_frm.jsp' where id=55
/ 
delete from MainMenuInfo where id=56
/ 
delete from MainMenuInfo where id=57
/

update LeftMenuInfo set linkAddress='/hrm/resource/HrmResource_frm.jsp' where id=42
/

INSERT INTO HtmlLabelIndex values(17898,'下级分部') 
/
INSERT INTO HtmlLabelIndex values(17900,'下级部门') 
/
INSERT INTO HtmlLabelIndex values(17899,'同级部门') 
/
INSERT INTO HtmlLabelIndex values(17897,'同级分部') 
/
INSERT INTO HtmlLabelInfo VALUES(17897,'同级分部',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17897,'subcompany same level',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17898,'下级分部',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17898,'subcompany low level',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17899,'同级部门',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17899,'department same level',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17900,'下级部门',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17900,'department low level',8) 
/


create or replace procedure HrmRSRPath_SeByURId
(userid_1 integer,
rightstr_2 varchar2,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
 tempsubid integer;
 CURSOR c1 is select id from temptree2;
begin
	insert into temptree4(subcomid,rightlevel)
		select subcompanyid,min(rightlevel) as rightlevel
		from SysRoleSubcomRight 
		where roleid in(select a.roleid 
				from HrmRoleMembers a,SystemRightRoles b
				where a.roleid=b.roleid and a.resourceid=userid_1 
				and b.rightid =(select rightid from SystemRightDetail where rightdetail=rightstr_2)
				)
		group by subcompanyid;

	insert into temptree2(id)
		select b.subcomid
		from hrmsubcompany a,temptree4 b
		where a.id=b.subcomid and a.supsubcomid!=0 and a.supsubcomid not in(select subcomid from temptree4);
	open c1 ;
		loop
			fetch c1 INTO tempsubid;
			exit when c1%NOTFOUND;
			insert into temptree3(id)
				select id from table(cast(getSubComParentTree(tempsubid) as tab_tree));
		end loop;
	open thecursor for
	select subcomid,rightlevel from  temptree4
	union
	select distinct(id),-1 from temptree3;
	close c1;
end;
/

create or replace procedure HrmRoleSRT_AddByNewSc
	(subcomid_1 integer,
	supsubcomid_2 integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as 
	roleid_1 integer;
	rightlevel_2 integer;
begin 
	for c1 in(select roleid,rightlevel from SysRoleSubcomRight where subcompanyid=supsubcomid_2)
	loop
		roleid_1 := c1.roleid;
		rightlevel_2 := c1.rightlevel;
		insert into SysRoleSubcomRight(roleid,subcompanyid,rightlevel) values(roleid_1, subcomid_1, rightlevel_2);
	end loop;
end;
/
