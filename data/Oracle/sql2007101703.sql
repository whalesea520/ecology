alter table Prj_SearchMould add procode varchar2(100)
/

 CREATE or REPLACE PROCEDURE Prj_SearchMould_Update  
 (id_1 	integer, userid_2 	integer, prjid_3 	varchar2, status_4 	varchar2, prjtype_5 	varchar2, worktype_6 	integer, 
 nameopt_7 	integer, name_8 	varchar2, description_9 	varchar2, customer_10 	integer, parent_11 	integer,
 securelevel_12 	integer, department_13 	integer, manager_14 	integer, member_15 	integer,procode_16      varchar2,	
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )  
	AS
	begin
	UPDATE Prj_SearchMould  SET  userid	 = userid_2, prjid	 = prjid_3, status	 = status_4,
	prjtype	 = prjtype_5, worktype	 = worktype_6, nameopt	 = nameopt_7, name	 = name_8, 
	description	 = description_9, customer	 = customer_10, parent	 = parent_11, 
	securelevel	 = securelevel_12, department	 = department_13, 
	manager	 = manager_14, member	 = member_15,procode=procode_16 
	WHERE ( id	 = id_1) ;
end;
/

 CREATE or REPLACE PROCEDURE Prj_SearchMould_Insert 
 (mouldname_1 	varchar2, userid_2 	integer, 
 prjid_3 	varchar2, status_4 	varchar2, prjtype_5 	varchar2, 
 worktype_6 	integer, nameopt_7 	integer, name_8 	varchar2, 
 description_9 	varchar2, customer_10 	integer, parent_11 	integer,
 securelevel_12 	integer, department_13 	integer, manager_14 	integer,
 member_15 	integer,procode_16      varchar2,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
	AS 
	begin
	INSERT INTO Prj_SearchMould
    
	( mouldname, userid, prjid, status, prjtype, worktype, nameopt, name, description, customer, parent, securelevel, department, manager, member,procode)
	VALUES ( mouldname_1, userid_2, prjid_3, status_4, prjtype_5, worktype_6, nameopt_7, name_8, description_9, customer_10, parent_11, securelevel_12, department_13, manager_14, member_15,procode_16) ;
	open thecursor for
	select max(id) from Prj_SearchMould;
end;
/
