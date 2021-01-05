create table smsvoting(
	id integer NOT NULL,
	creater integer null,
	createdate varchar2(10) null,
	createtime varchar2(10) null,
	subject varchar2(100) null,
	senddate varchar2(10) null,
	sendtime varchar2(10) null,
	enddate varchar2(10) null,
	endtime varchar2(10) null,
	isseeresult integer null,
	status integer null,
	remark varchar2(2000) null,
	smscontent varchar2(500) null,
	portno varchar2(50) null,
	hrmids varchar2(2000) null,
	votingcount integer null,
	vaildvotingcount integer null
)
/
create sequence smsvoting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger smsvoting_id_Tri
before insert on smsvoting
for each row
begin
select smsvoting_id.nextval into :new.id from dual;
end;
/

create table smsvotingdetail(
	id integer NOT NULL,
	smsvotingid integer null,
	regcontent varchar2(10) null,
	remark varchar2(500) null,
	count integer null
)
/
create sequence smsvotingdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger smsvotingdetail_id_Tri
before insert on smsvotingdetail
for each row
begin
select smsvotingdetail_id.nextval into :new.id from dual;
end;
/
create table smsvotinghrm(
	id integer NOT NULL,
	smsvotingid integer null,
	smsvotingdetailid integer null,
	userid integer null,
	receivesms varchar2(500) null,
	receivedate varchar2(10) null,
	receivetime varchar2(10) null,
	status integer null
)
/
create sequence smsvotinghrm_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger smsvotinghrm_id_Tri
before insert on smsvotinghrm
for each row
begin
select smsvotinghrm_id.nextval into :new.id from dual;
end;
/



 
