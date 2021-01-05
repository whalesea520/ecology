ALTER table meeting_type add subcompanyid integer
/
update meeting_type set subcompanyid = (select dftsubcomid from (select * from  SystemSet)WHERE rownum = 1)
/

ALTER table meetingroom add subcompanyid integer
/
update meetingroom set subcompanyid = (select dftsubcomid from (select * from  SystemSet)WHERE rownum =1)
/

CREATE or REPLACE PROCEDURE MeetingRoom_Update
	 (id_1 	integer  ,
	 name_1 varchar2  ,
	 roomdesc_1 varchar2 ,
	 hrmid_1 integer ,
	 subcompanyid_1 integer,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 ) 
 AS
	begin
		Update MeetingRoom  set  name=name_1, roomdesc=roomdesc_1, hrmid=hrmid_1,subcompanyid=subcompanyid_1  where id= id_1;
	end;
/

CREATE or REPLACE PROCEDURE MeetingRoom_Insert
	(name_1 varchar2 ,
	 roomdesc_1 varchar2  ,
	 hrmid_1 integer ,
     subcompanyid_1 integer,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 ) 
AS
begin
	INSERT INTO MeetingRoom
			 (name ,
			 roomdesc ,
			 hrmid,subcompanyid )
			VALUES
			(name_1,
			 roomdesc_1,
			 hrmid_1,
			 subcompanyid_1);
end;
/

CREATE or REPLACE PROCEDURE Meeting_Type_Update
	 (id_1	integer , 
	 name_2 varchar2  ,
	 approver_3 integer ,
	 desc_n_4 varchar2,
	 subcompanyid_5 integer,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 )
AS
begin
update Meeting_Type   set name = name_2, approver = approver_3, desc_n = desc_n_4,subcompanyid = subcompanyid_5 where id = id_1;
end;
/

CREATE or REPLACE PROCEDURE Meeting_Type_Insert
 (name_1 varchar2 ,
 approver_2 integer, 
 desc_n_3 varchar2 ,
 subcompanyid_4 integer,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 )
AS
begin
INSERT INTO Meeting_Type ( name , approver , desc_n ,subcompanyid)  VALUES ( name_1, approver_2, desc_n_3,subcompanyid_4 );
end;
/

update SystemRights set detachable=1 where id in(350,200)
/
