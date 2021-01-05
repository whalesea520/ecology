CREATE or REPLACE PROCEDURE SysRemindInfo_DeleteHasnewwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   /* tmp varchar2(255); */
   tmp_count integer;
  begin
  select  count(hasnewwf) INTO tmp_count from SysRemindInfo where userid = userid1 and usertype = usertype1;
/*  if(tmp_count>0)then
  select  hasnewwf INTO tmp from SysRemindInfo where userid = userid1 and usertype = usertype1;
  end if;
  if tmp is not null then
	 tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');
	 if length(tmp) < 2 then
		   tmp := null;
	else
	 	   tmp := SUBSTR(tmp,2,length(tmp)-2);
	end if;
	 update SysRemindInfo set hasnewwf = tmp where userid = userid1 and usertype = usertype1;
  end if;  */
end;
/


CREATE or REPLACE PROCEDURE SysRemindInfo_IPasstimeNode 
 (
userid1		integer,
usertype1	integer,
haspasstimenode1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid_count integer;
   begin
     select  count(userid) INTO tmpid_count  from SysRemindInfo where userid = userid1 and usertype = usertype1;
/*	 if tmpid_count>0 then
  insert into SysRemindInfo(userid,usertype,haspasstimenode) values(userid1,usertype1,haspasstimenode1);
  else
  update SysRemindInfo set haspasstimenode = haspasstimenode1 where userid = userid1 and usertype = usertype1;
  end if; */
end;
/


 CREATE or REPLACE PROCEDURE SysRemindInfo_InserCrmcontact 
 (
userid1		integer,
usertype1	integer,
hascrmcontact1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid integer ;
   begin
   select count(userid) into tmpid from SysRemindInfo where userid = userid1 and usertype = usertype1;
/*  if tmpid = 0 then
	  insert into SysRemindInfo(userid,usertype,hascrmcontact) values(userid1,usertype1,hascrmcontact1);
  else
	  update SysRemindInfo set hascrmcontact = hascrmcontact1 where userid = userid1 and usertype = usertype1;
  end if;  */
end;
/


CREATE or REPLACE PROCEDURE SysRemindInfo_InserDealwf 
 (
userid1		integer,
usertype1	integer,
hasdealwf1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
	tmpid_count integer;
	begin
select   count(userid) INTO tmpid_count from SysRemindInfo where userid = userid1 and usertype = usertype1;
/*if tmpid_count=0  then
  insert into SysRemindInfo(userid,usertype,hasdealwf) values(userid1,usertype1,hasdealwf1);
  else
  update SysRemindInfo set hasdealwf = hasdealwf1 where userid = userid1 and usertype = usertype1;
  end if; */
end;
/

CREATE or REPLACE PROCEDURE SysRemindInfo_InserHasendwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid integer ;
    tmp varchar2(255);
	recordcount integer;
	begin
  select count(*) INTO recordcount  from SysRemindInfo where userid = userid1 and usertype = usertype1;
/*  if recordcount>0 then
      select hasendwf , userid INTO tmp, tmpid  from SysRemindInfo where userid = userid1 and usertype = usertype1;
      if tmp = '' or tmp is null then
           update SysRemindInfo set hasendwf = to_char(requestid1) 
		   where userid = userid1 and usertype = usertype1;
      else 
           if instr(  concat(concat(',', to_char(requestid1)),',') ,  concat(concat(',',tmp),','),1,1)=0 then
	              update SysRemindInfo set hasendwf = concat(concat(hasendwf ,','),to_char(requestid1))
				  where userid = userid1 and usertype = usertype1;
           end if;
	  end if;
  else 
  insert into SysRemindInfo(userid,usertype,hasendwf) values(userid1,usertype1,to_char(requestid1));
  end if;  */
end;
/

CREATE or REPLACE PROCEDURE SysRemindInfo_InserHasnewwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid integer ;
   tmp varchar(255);
   recordcount integer;
begin
  select count(*) INTO recordcount  from SysRemindInfo where userid = userid1 and usertype = usertype1;
/*  if recordcount=0 then
    insert into SysRemindInfo(userid,usertype,hasnewwf) values(userid1,usertype1,to_char(requestid1));
  else
	select userid,hasnewwf into   tmpid, tmp
	     from SysRemindInfo where userid = userid1 and usertype = usertype1;
	if tmp = '' or tmp is null then
		 update SysRemindInfo set hasnewwf = to_char(requestid1)
		 where userid = userid1 and usertype = usertype1;
	else 
        if instr (  concat(concat(',', to_char(requestid1)),',') ,  concat(concat(',',tmp),','),1,1)=0 then  
		    update SysRemindInfo set hasnewwf =concat(concat(hasendwf ,','),to_char(requestid1))
		    where userid = userid1 and usertype = usertype1;
	    end if;
	end if;
  end if; */
end;
/

CREATE or REPLACE PROCEDURE T_OutReport_SelectAll
	(flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 

AS 
recordcount integer;
begin
select 1 into recordcount from dual ;
/*open thecursor for
select * from T_OutReport; */
end;
/

CREATE or REPLACE PROCEDURE T_OutReport_SelectByUserid
	(userid integer ,
	usertype char,
	flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 

AS 
recordcount integer;
begin
select 1 into recordcount from dual ;
/*open thecursor for
select a.* from T_OutReport a, T_OutReportShare b 
where a.outrepid = b.outrepid and b.userid=userid and b.usertype = usertype ; */
end;
/