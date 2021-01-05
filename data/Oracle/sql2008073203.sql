alter table Voting add isSeeResult varchar2(10)
/
alter table votingquestion add ismultino integer
/

CREATE OR REPLACE PROCEDURE Voting_Insert (
	subject_1   varchar2, 
	detail_2    varchar2, 
	createrid_3 integer, 
	createdate_4    char, 
	createtime_5    char, 
	approverid_6    integer, 
	approvedate_7   char, 
	approvetime_8   char, 
	begindate_9     char, 
	begintime_10     char, 
	enddate_11       char, 
	endtime_12       char, 
	isanony_13       integer, 
	docid_14         integer, 
	crmid_15     integer, 
	projid_16    integer, 
	requestid_17 integer, 
	votingcount_18   integer, 
	status_19        integer, 
	isSeeResult_20 varchar2, 
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
AS
begin 
insert into voting (
	subject,
	detail,
	createrid,
	createdate,
	createtime,
	approverid,
	approvedate,
	approvetime,
	begindate,
	begintime,
	enddate,
	endtime,
	isanony,
	docid,
	crmid,
	projid,
	requestid,
	votingcount,
	status,
	isSeeResult
) 
values (
	subject_1,
	detail_2,
	createrid_3,
	createdate_4,
	createtime_5,
	approverid_6,
	approvedate_7,
	approvetime_8,
	begindate_9,
	begintime_10,
	enddate_11,
	endtime_12,
	isanony_13,
	docid_14,
	crmid_15,
	projid_16,
	requestid_17,
	votingcount_18,
	status_19,
	isSeeResult_20
); 
open thecursor for select max(id) from voting; 
end;
/
CREATE OR REPLACE PROCEDURE Voting_Update (
	id_1    integer, 
	subject_2   varchar2, 
	detail_3    varchar2, 
	createrid_4 integer, 
	createdate_5    char, 
	createtime_6    char, 
	approverid_7    integer, 
	approvedate_8   char, 
	approvetime_9   char, 
	begindate_10     char, 
	begintime_11     char, 
	enddate_12       char, 
	endtime_13       char, 
	isanony_14       integer, 
	docid_15         integer, 
	crmid_16     integer, 
	projid_17    integer, 
	requestid_18 integer, 
	isSeeResult_19 varchar2, 
	flag out integer, 
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
update voting 
set 
	subject=subject_2, 
	detail=detail_3, 
	createrid=createrid_4, 
	createdate=createdate_5, 
	createtime=createtime_6, 
	approverid =approverid_7, 
	approvedate=approvedate_8, 
	approvetime=approvetime_9, 
	begindate=begindate_10, 
	begintime=begintime_11, 
	enddate=enddate_12, 
	endtime=endtime_13, 
	isanony=isanony_14, 
	docid=docid_15, 
	crmid=crmid_16, 
	projid=projid_17, 
	requestid=requestid_18,
	isSeeResult=isSeeResult_19
where id=id_1; 
end;
/
CREATE OR REPLACE PROCEDURE VotingQuestion_Insert (
	votingid_1  integer, 
	subject_2   varchar2, 
	description_3   varchar2, 
	ismulti_4       integer, 
	isother_5       integer, 
	questioncount_6 integer, 
	ismultino_7 integer,
	flag out integer, 
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
insert into votingquestion (
	votingid,
	subject,
	description,
	ismulti,
	isother,
	questioncount,
	ismultino
)values(
	votingid_1,
	subject_2,
	description_3,
	ismulti_4,
	isother_5,
	questioncount_6,
	ismultino_7
); 
open thecursor for 
select greatest(id) from votingquestion; 
end;
/
CREATE OR REPLACE PROCEDURE VotingQuestion_Update (
	id_1    integer, 
	votingid_2  integer, 
	subject_3   varchar2, 
	description_4   varchar2, 
	ismulti_5       integer, 
	isother_6       integer, 
	ismultino_7     integer,
	flag out integer, 
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
update votingquestion 
set votingid=votingid_2, subject=subject_3, description=description_4, ismulti=ismulti_5, isother=isother_6, ismultino=ismultino_7 
where id=id_1;
end;
/