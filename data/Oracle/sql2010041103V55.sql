create or replace procedure HrmResource_Dismiss
	(id_1 integer,
	 changedate_2 char,
	 changereason_3 clob,
	 changecontractid_4 integer,
	 infoman_5 varchar2,
	 oldjobtitleid_7 integer,
	 type_n_8 char, 
	 operator_9 integer,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	INSERT INTO HrmStatusHistory 
	(resourceid,
	 changedate,
	 changereason,
	 changecontractid,
	 infoman,
	 oldjobtitleid,
	 type_n,
	 operator)
	VALUES
	(id_1, 
	 changedate_2,
	 changereason_3,
	 changecontractid_4,
	 infoman_5,
	 oldjobtitleid_7,
	 type_n_8,
	 operator_9);
	UPDATE HrmResource SET 
	 enddate = changedate_2
	WHERE
	 id = id_1;
end;
/

create or replace PROCEDURE HrmResource_Extend 
	(id_1 integer, 
	 changedate_2 char, 
	 changeenddate_3 char, 
	 changereason_4 clob, 
	 changecontractid_5 integer, 
	 infoman_6 varchar2, 
	 oldjobtitleid_7 integer, 
	 type_n_8 char,
	 status_9 integer,
	 operator_10 integer,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid, 
 changedate, 
 changeenddate, 
 changereason, 
 changecontractid, 
 infoman, 
 oldjobtitleid, 
 type_n,
 status,
 operator) 
VALUES 
(id_1, 
 changedate_2, 
 changeenddate_3, 
 changereason_4, 
 changecontractid_5, 
 infoman_6, 
 oldjobtitleid_7 , 
 type_n_8,
 status_9,
 operator_10
 );
UPDATE HrmResource SET enddate = changeenddate_3 WHERE id = id_1;
end;
/

create or replace  PROCEDURE HrmResource_Fire
	(id_1 integer,
	 changedate_2 char,
	 changereason_3 clob,
	 changecontractid_4 integer,
	 infoman_5 varchar2,
	 oldjobtitleid_7 integer,
	 type_n_8 char,  
	 operator_9 integer,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	INSERT INTO HrmStatusHistory 
	(resourceid,
	 changedate,
	 changereason,
	 changecontractid,
	 infoman,
	 oldjobtitleid,
	 type_n,
	 operator)
	VALUES
	(id_1, 
	 changedate_2,
	 changereason_3,
	 changecontractid_4,
	 infoman_5,
	 oldjobtitleid_7 ,
	 type_n_8,
	 operator_9);
	UPDATE HrmResource SET  enddate = changedate_2	WHERE id = id_1;
end;
/

create or replace PROCEDURE HrmResource_Hire
	(id_1 integer,
	 changedate_2 char,
	 changereason_3 clob,
	 infoman_5 varchar2,
	 oldjobtitleid_7 integer,
	 type_n_8 char,  
	 operator_9 integer,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO HrmStatusHistory
	(resourceid,
	 changedate,
	 changereason,
	 infoman,
	 oldjobtitleid,
	 type_n,
	 operator)
	VALUES
	(id_1, 
	 changedate_2,
	 changereason_3,
	 infoman_5,
	 oldjobtitleid_7 ,
	 type_n_8,
	 operator_9);
end;
/

CREATE OR REPLACE PROCEDURE HrmResource_Redeploy(id_1              integer,
                                                 changedate_2      char,
                                                 changereason_4    clob,
                                                 oldjobtitleid_7   integer,
                                                 oldjoblevel_8     integer,
                                                 newjobtitleid_9   integer,
                                                 newjoblevel_10    integer,
                                                 infoman_6         varchar2,
                                                 type_n_11         integer,
                                                 ischangesalary_12 integer,
                                                 oldmanagerid_1    integer,
                                                 newmanagerid_1    integer,
                                                 oldDepartmentId_1    integer,
                                                 newDepartmentId_1    integer,
                                                 oldSubcompanyId_1    integer,
                                                 newSubcompanyId_1    integer,
                                                 operator_19 integer,
                                                 flag              out integer,
                                                 msg               out varchar2,
                                                 thecursor         IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO HrmStatusHistory
    (resourceid,
     changedate,
     changereason,
     oldjobtitleid,
     oldjoblevel,
     newjobtitleid,
     newjoblevel,
     infoman,
     type_n,
     ischangesalary,
     oldmanagerid,
     newmanagerid,
     oldDepartmentId,
     newDepartmentId,
     oldSubcompanyId,
     newSubcompanyId,
     operator
     )
  VALUES
    (id_1,
     changedate_2,
     changereason_4,
     oldjobtitleid_7,
     oldjoblevel_8,
     newjobtitleid_9,
     newjoblevel_10,
     infoman_6,
     type_n_11,
     ischangesalary_12,
     oldmanagerid_1,
     newmanagerid_1,
     oldDepartmentId_1,
     newDepartmentId_1,
     oldSubcompanyId_1,
     newSubcompanyId_1,
     operator_19
     );
end;
/

create or replace PROCEDURE HrmResource_Rehire
	(id_1 integer,
	 changedate_2 char,
	 changeenddate_3 char,
	 changereason_4 clob,
	 changecontractid_5 integer,
	 infoman_6 varchar2,
	 oldjobtitleid_7 integer,
	 type_n_8 char,
	 operator_9 integer,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	INSERT INTO HrmStatusHistory 
	(resourceid,
	 changedate,
	 changeenddate,
	 changereason,
	 changecontractid,
	 infoman,
	 oldjobtitleid,
	 type_n,
	 operator
	 )
	VALUES
	(id_1, 
	 changedate_2,
	 changeenddate_3,
	 changereason_4,
	 changecontractid_5,
	 infoman_6,
	 oldjobtitleid_7 ,
	 type_n_8,
	 operator_9
	 );
	UPDATE HrmResource SET 
	 startdate = changedate_2,
	 enddate = changeenddate_3
	WHERE id = id_1;
 end;
/

create or replace PROCEDURE HrmResource_Retire
	(id_1 integer,
	 changedate_2 char,
	 changereason_3 clob,
	 changecontractid_4 integer,
	 infoman_5 varchar2,
	 oldjobtitleid_7 integer,
	 type_n_8 char,
	 operator_9 integer,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	INSERT INTO HrmStatusHistory 
	(resourceid,
	 changedate,
	 changereason,
	 changecontractid,
	 infoman,
	 oldjobtitleid,
	 type_n,
	 operator)
	VALUES
	(id_1, 
	 changedate_2,
	 changereason_3,
	 changecontractid_4,
	 infoman_5,
	 oldjobtitleid_7,
	 type_n_8,
	 operator_9);
	UPDATE HrmResource SET	 enddate = changedate_2	WHERE	 id = id_1;
end;
/

create or REPLACE PROCEDURE HrmResource_Try
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,  
 operator_9 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 INSERT INTO HrmStatusHistory
    (resourceid,
     changedate,
     changereason,
     infoman,
     oldjobtitleid,
     type_n,
     operator
     )
VALUES
    (id_1, 
     changedate_2,
     changereason_3,
     infoman_5,
     oldjobtitleid_7 ,
     type_n_8,
     operator_9
     );
end;
/
