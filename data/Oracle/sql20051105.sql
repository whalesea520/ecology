ALTER TABLE cowork_types add  managerid_n varchar2(4000)
/
update cowork_types set managerid_n = managerid 
/
ALTER TABLE cowork_types drop column managerid 
/
ALTER TABLE cowork_types add  managerid varchar2(4000)
/
update cowork_types set managerid  = managerid_n 
/
ALTER TABLE cowork_types  drop column managerid_n 
/

ALTER TABLE cowork_types add  members_n varchar2(3000)
/
update cowork_types set members_n = members 
/
ALTER TABLE cowork_types drop column members 
/
ALTER TABLE cowork_types add  members varchar2(3000)
/
update cowork_types set members  = members_n 
/
ALTER TABLE cowork_types  drop column members_n 
/



INSERT INTO HtmlLabelIndex values(17999,'δ�鵵') 
/
INSERT INTO HtmlLabelInfo VALUES(17999,'δ�鵵',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17999,'not finished',8) 
/

CREATE or replace PROCEDURE cowork_types_insert
	(typename_1 	varchar2,
	 departmentid_2 	integer,
	 managerid_3 	varchar2,
	 members_4 	varchar2,
	 flag out integer, 
	 msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
INSERT INTO cowork_types 
	 (typename,
	 departmentid,
	 managerid,
	 members) 
VALUES 
	(typename_1,
	 departmentid_2,
	 managerid_3,
	 members_4);
end;
/

CREATE or replace PROCEDURE cowork_types_update
(id_1 	integer,
typename_2 	varchar2,
departmentid_3 integer,
managerid_4 	varchar2,
members_5 	varchar2,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE cowork_types SET  typename = typename_2,
	 departmentid = departmentid_3,
	 managerid = managerid_4,
	 members = members_5 
WHERE ( id = id_1);
end;	
/