CREATE OR REPLACE PROCEDURE deleteVotingRemark
as
votingidtemp integer;
v_id integer;
begin
 for voting_cursor in (select id from voting where status = 1)
 loop
   select count(votingid) into v_id from votingoption where votingid = votingidtemp;
   if v_id = 0 then
     delete from votingremark where votingid = votingidtemp;
     delete from votingresourceremark where votingid = votingidtemp;
   end if;
 end loop;
end;
/
call deleteVotingRemark()
/

CREATE or REPLACE PROCEDURE VotingResource_Insert
(votingid_1    integer,
 questionid_2    integer,
 optionid_3   integer,
 resourceid_4 integer,
 operatedate_5   char,
 operatetime_6   char,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
	count_1 integer;
    begin
	select count(votingid) into count_1 from votingresource where optionid=optionid_3 and resourceid=resourceid_4 and votingid=votingid_1;
	if  count_1=0
	then
    	insert into votingresource (votingid,questionid,optionid,resourceid,operatedate,operatetime)
    	values (votingid_1,questionid_2,optionid_3,resourceid_4,operatedate_5,operatetime_6);
	end if;
end;
/
