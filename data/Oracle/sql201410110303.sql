CREATE OR REPLACE PROCEDURE CptShareInfo_Insert_dft 
(relateditemid_1 integer, sharetype_2 int, seclevel_3 smallint, rolelevel_4 smallint, sharelevel_5 smallint, userid_6 integer, departmentid_7 integer, roleid_8 integer, foralluser_9 smallint, subcompanyid_10 integer,sharefrom_11 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS 
begin 
	INSERT INTO CptCapitalShareInfo (relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,subcompanyid, sharefrom,isdefault) VALUES (relateditemid_1, sharetype_2, seclevel_3, rolelevel_4, sharelevel_5, userid_6, departmentid_7, roleid_8, foralluser_9, subcompanyid_10,sharefrom_11,1);
end;
/