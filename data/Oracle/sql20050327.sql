create or replace PROCEDURE CarType_Insert
    (name_1 	varchar2,
	description_2  varchar2,
	usefee_3    number ,
    flag out integer ,     
    msg  out varchar2,    
    thecursor IN OUT cursor_define.weavercursor	) 
AS 
begin
	insert into cartype(name,description,usefee) values (name_1,description_2,usefee_3);
end;
/

create or replace PROCEDURE CarType_Update
(   id_1 integer,
    name_2   varchar2,
    description_3    varchar2,
    usefee_4    number ,
	flag out integer ,
	msg out varchar2,
    thecursor in out cursor_define.weavercursor)
AS 
begin
	update cartype set name=name_2,description=description_3,usefee=usefee_4 where id=id_1;
end;
/

create or replace PROCEDURE CarType_Select
	(flag out integer ,
	 msg out varchar2,
     thecursor in out cursor_define.weavercursor)
AS 
begin
open thecursor for
	select * from cartype;
end;
/

create or replace PROCEDURE CarType_SelectByID
(   id_1 integer,
	flag out integer ,
	msg out varchar2,
    thecursor in out cursor_define.weavercursor)
AS 
begin
    open thecursor for
	select * from cartype where id=id_1;
end;
/

create or replace PROCEDURE CarType_Delete
(   id_1 integer,
	flag out integer ,
	msg out varchar2,
    thecursor in out cursor_define.weavercursor)
AS 
begin
	delete from cartype where id=id_1;
end;
/

create or replace PROCEDURE CarParameter_Insert
	(name_1 		varchar2,
	 paravalue_2     number,
	 description_3   varchar2,
     flag out integer ,     
     msg  out varchar2,    
     thecursor IN OUT cursor_define.weavercursor	)
AS 
begin
	insert into CarParameter(name,description,paravalue) values (name_1,description_3,paravalue_2);
end;
/

create or replace PROCEDURE CarParameter_Update
(   id_1 integer,
    name_2   varchar2,
    paravalue_3  number,
    description_4    varchar2,
    flag out integer ,     
    msg  out varchar2,    
    thecursor IN OUT cursor_define.weavercursor	)
AS
begin
	update CarParameter set name=name_2,description=description_4,paravalue=paravalue_3 where id=id_1;
end;
/

create or replace PROCEDURE CarParameter_Select
    (flag out integer ,     
     msg  out varchar2,    
     thecursor IN OUT cursor_define.weavercursor	)
AS 
begin
open thecursor for
	select * from CarParameter;
end;
/

create or replace PROCEDURE CarParameter_SelectByID
(   id_1 integer,
    flag out integer ,     
    msg  out varchar2,    
    thecursor IN OUT cursor_define.weavercursor	)
AS
begin
open thecursor for
	select * from CarParameter where id=id_1;
end;
/

create or replace PROCEDURE CarParameter_Delete
(   id_1 integer,
    flag out integer ,     
    msg  out varchar2,    
    thecursor IN OUT cursor_define.weavercursor	)
AS
begin
	delete from CarParameter where id=id_1;
end;
/

create or replace PROCEDURE CarDriverBasicinfo_Insert
(   basicsalary_1    number,
    overtimepara_2   number ,
    receptionpara_3  number,
    basicKM_4        number ,
    basicKMpara_5    number ,
    basictime_6      number ,
    basictimepara_7  number ,
    basicout_8       integer,
    basicoutpara_9   number ,
    publicpara_10     number ,
    flag out integer ,     
    msg  out varchar2,    
    thecursor IN OUT cursor_define.weavercursor	)
AS 
    count_1 integer;
begin
    select count(*) into count_1 from cardriverbasicinfo;
	if count_1=0 
    then
	    insert into cardriverbasicinfo values 
	    (basicsalary_1,overtimepara_2,receptionpara_3,basicKM_4,
        basicKMpara_5,basictime_6,basictimepara_7,basicout_8,basicoutpara_9,publicpara_10);
	else
	    update cardriverbasicinfo set basicsalary=basicsalary_1,overtimepara=overtimepara_2,
	    receptionpara=receptionpara_3,basicKM=basicKM_4,basicKMpara=basicKMpara_5,
	    basictime=basictime_6,basictimepara=basictimepara_7,basicout=basicout_8,basicoutpara=basicoutpara_9,publicpara=publicpara_10;
    end if;
end;	
/

create or replace PROCEDURE CarDriverBasicinfo_Select
(   flag out integer ,
	msg out varchar2,
    thecursor in out cursor_define.weavercursor)
AS 
begin
open thecursor for
	select * from cardriverbasicinfo;
end;
/

create or replace PROCEDURE CarDriverData_Insert
	(driverid_1 		integer,
	 cartypeid_2   integer,
	 isreception_3   integer,
	 startdate_4     char,
	 starttime_5     char,
	 backdate_6      char,
	 backtime_7      char,
	 startkm_8       number ,
	 backkm_9        number ,
	 runKM_10         number ,
	 runtime_11       number ,
	 normalkm_12      number ,
	 overtimekm_13    number ,
	 normaltime_14    number ,
	 overtime_15      number ,
	 realkm_16        number ,
	 realtime_17      number ,
	 useperson_18     varchar2,
	 usedepartment_19  varchar2,
	 iscarout_20      integer,
	 remark_21        Varchar2 ,
	 isholiday_22     char,
	 flag out integer ,
	 msg out varchar2,
     thecursor in out cursor_define.weavercursor)
AS 
begin
	insert into CarDriverData(driverid,cartypeid,isreception,startdate,starttime,backdate,backtime,startkm,backkm,runKM,runtime,normalkm,overtimekm,normaltime,overtime,realkm,realtime,useperson,usedepartment,iscarout,remark,isholiday) values (driverid_1,cartypeid_2,isreception_3,startdate_4,starttime_5,backdate_6,backtime_7,startkm_8,backkm_9,
    runKM_10,runtime_11,normalkm_12,overtimekm_13,normaltime_14,overtime_15,realkm_16,realtime_17,
   useperson_18,usedepartment_19,iscarout_20,remark_21,isholiday_22);
   open thecursor for
	select greatest(id) from cardriverdata;
end;
/

create or replace PROCEDURE CarDriverData_Update
	(id_1       integer,
	 driverid_2 		integer,
	 cartypeid_3   integer,
	 isreception_4   integer,
	 startdate_5     char,
	 starttime_6     char,
	 backdate_7      char,
	 backtime_8      char,
	 startkm_9       number ,
	 backkm_10        number ,
	 runKM_11         number ,
	 runtime_12       number ,
	 normalkm_13      number ,
	 overtimekm_14    number ,
	 normaltime_15    number ,
	 overtime_16      number ,
	 realkm_17        number ,
	 realtime_18      number ,
	 useperson_19     varchar2,
	 usedepartment_20 varchar2,
	 iscarout_21      integer,
	 remark_22        Varchar2 ,
	 isholiday_23     char,
	 flag out integer ,
	 msg out varchar2,
     thecursor in out cursor_define.weavercursor)
AS 
begin
	update CarDriverData set 
	driverid=driverid_2,
	cartypeid=cartypeid_3,
	isreception=isreception_4,
	startdate=startdate_5,
	starttime=starttime_6,
	backdate=backdate_7,
	backtime=backtime_8,
	startkm=startkm_9,
	backkm=backkm_10,
	runKM=runKM_11,
	runtime=runtime_12,
	normalkm=normalkm_13,
	overtimekm=overtimekm_14,
	normaltime=normaltime_15,
	overtime=overtime_16,
	realkm=realkm_17,
	realtime=realtime_18,
	useperson=useperson_19,
	usedepartment=usedepartment_20,
	iscarout=iscarout_21,
	remark=remark_22,
	isholiday=isholiday_23
	where id=id_1;
end;
/

create or replace PROCEDURE CarDriverData_Delete
	(id_1        integer,
	 flag out integer,
	 msg out varchar2,
     thecursor in out cursor_define.weavercursor)
AS 
begin
	delete from CarDriverData where id=id_1;
end;
/

create or replace PROCEDURE CarDriverDataPara_Insert
	(driverdataid_1        integer,
	 paraid_2        integer,
	 flag out integer ,
	 msg out varchar2,
     thecursor in out cursor_define.weavercursor)
     AS 
     begin
	insert into CarDriverDataPara values (driverdataid_1,paraid_2);
end;
/

create or replace PROCEDURE CarDriverDataPara_Delete
	(driverdataid_1       integer,
	 flag out integer,
	 msg out varchar2,
     thecursor in out cursor_define.weavercursor)
AS
begin
	delete from CarDriverDataPara where driverdataid = driverdataid_1;
end;
/

