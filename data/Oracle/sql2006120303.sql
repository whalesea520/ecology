alter table meeting modify(desc_n varchar2(4000))
/

create or replace PROCEDURE Meeting_Insert (
	meetingtype_1 integer , 
	name_1 varchar2 , 
	caller_1 integer , 
	contacter_1 integer , 
	projectid_1 integer, 
	address_1 integer , 
	begindate_1 varchar2, 
	begintime_1 varchar2, 
	enddate_1 varchar2, 
	endtime_1 varchar2, 
	desc_n_1 varchar2, 
	creater_1 integer, 
	createdate_1 varchar2, 
	createtime_1 varchar2 , 
	totalmember_1   integer, 
	othermembers_1   clob, 
	addressdesc_1   varchar2, 
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
INSERT INTO Meeting ( 
	meetingtype ,
	name ,
	caller ,
	contacter ,
	projectid,
	address ,
	begindate  ,
	begintime ,
	enddate ,
	endtime ,
	desc_n,
	creater ,
	createdate ,
	createtime,
	totalmember,
	othermembers,
	addressdesc) 
VALUES ( 
	meetingtype_1 ,
	name_1,
	caller_1,
	contacter_1,
	projectid_1,
	address_1 ,
	begindate_1 ,
	begintime_1 ,
	enddate_1 ,
	endtime_1 ,
	desc_n_1 ,
	creater_1 ,
	createdate_1 ,
	createtime_1,
	totalmember_1,
	othermembers_1,
	addressdesc_1) ;
end;
/


create or replace PROCEDURE Meeting_Update (
	meetingid_1 integer , 
	name_1 varchar2 , 
	caller_1 integer , 
	contacter_1 integer , 
	projectid_1 integer, 
	address_1 integer , 
	begindate_1 varchar2  , 
	begintime_1 varchar2 , 
	enddate_1 varchar2  , 
	endtime_1 varchar2 , 
	desc_n_1 varchar2 , 
	totalmember_1   integer, 
	othermembers_1   clob, 
	addressdesc_1   varchar2, 
	flag  out integer, 
	msg  out varchar,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
Update Meeting set  
	name=name_1 ,
	caller=caller_1 ,
	contacter=contacter_1 ,
	projectid=projectid_1,
	address=address_1 ,
	begindate=begindate_1 ,
	begintime=begintime_1 ,
	enddate=enddate_1 ,
	endtime=endtime_1 ,
	desc_n=desc_n_1,
	totalmember=totalmember_1,
	othermembers=othermembers_1,
	addressdesc=addressdesc_1 
	where id = meetingid_1 ;
end;

/