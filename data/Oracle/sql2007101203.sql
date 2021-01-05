CREATE or REPLACE PROCEDURE Voting_Insert
(subject_1   varchar2,
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
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	insert into voting (subject,detail,createrid,createdate,createtime,approverid,approvedate,approvetime,begindate,begintime,enddate,endtime,isanony,docid,crmid,projid,requestid,votingcount,status)
	values (subject_1,detail_2,createrid_3,createdate_4,createtime_5,approverid_6,approvedate_7,approvetime_8,begindate_9,begintime_10,enddate_11,endtime_12,isanony_13,docid_14,crmid_15,projid_16,requestid_17,votingcount_18,status_19);
open thecursor for
select max(id) from voting;
end;
/