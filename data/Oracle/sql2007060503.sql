

alter table Prj_ProjectType add insertWorkPlan char(1)
/
update Prj_ProjectType set insertWorkPlan='1'
/

create or replace PROCEDURE Prj_ProjectType_Update
(
	id_1	 	integer, 
	fullname_1 	varchar2,
	description_1 	varchar2, 
	protypecode_1 varchar2, 
	wfid_1	 	integer, 
	insertWorkPlan_1 char,
	flag out	integer,
	msg	out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
AS
begin
	UPDATE Prj_ProjectType  
	SET  fullname=fullname_1, description=description_1, wfid=wfid_1, protypecode=protypecode_1, insertWorkPlan=insertWorkPlan_1
	WHERE (id=id_1);
end;
/



create or replace PROCEDURE Prj_ProjectType_Insert (
	fullname_1 varchar2 ,
	description_1 varchar2, 
	wfid_1 integer,
	protypecode_1 varchar2,
	insertWorkPlan_1 char,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
	INSERT INTO Prj_ProjectType ( 
	fullname,
	description,
	wfid,
	protypecode,
	insertWorkPlan)
VALUES ( 
	fullname_1,
	description_1,
	wfid_1,
	protypecode_1,
	insertWorkPlan_1) ;
end;
/