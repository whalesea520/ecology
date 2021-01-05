CREATE TABLE groupchatvote(
  id int primary key NOT NULL,
  votetheme varchar(1000) NULL,
  themeimageid int NULL,
  choosemodel int NULL,
  maxvoteoption int NULL,
  voteprivacy int NULL,
  createrid int NULL,
  createdate char(10) NULL,
  createtime char(8) NULL,
  enddate char(10) NULL,
  endtime char(8) NULL,
  voteremind int NULL,
  votestatus int NULL,
  groupid varchar(200) NULL
  )
/  

CREATE TABLE groupchatvoteoption(
	id int primary key NOT NULL,
	optioncontent varchar(4000) NULL,
	votingid int NULL
)
/

 
CREATE TABLE groupchatvoteresult(
	id int NOT NULL,
	voteoptionid int NULL,
	voteuserid int NULL,
	votedate char(10) NULL,
	votetime char(8) NULL,
	votingid int NULL
)
/

  
CREATE OR REPLACE PROCEDURE SequenceIndex_GroupChatVoteid 
(flag  out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  
AS begin open thecursor 
for select currentid 
from SequenceIndex 
where indexdesc='groupchatvoteid' 
for update; 
update SequenceIndex 
set currentid = currentid+1 
where indexdesc='groupchatvoteid'; 
end;
/


CREATE OR REPLACE PROCEDURE SequenceIndex_GroupChatVoteOid 
(flag  out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  
AS begin open thecursor 
for select currentid 
from SequenceIndex 
where indexdesc='groupchatvoteoptionid' 
for update; 
update SequenceIndex 
set currentid = currentid+1 
where indexdesc='groupchatvoteoptionid'; 
end; 
/

 
CREATE OR REPLACE PROCEDURE SequenceIndex_GroupChatVoteRid 
(flag  out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  
AS begin open thecursor 
for select currentid 
from SequenceIndex 
where indexdesc='groupchatvoteresultid' 
for update; 
update SequenceIndex 
set currentid = currentid+1 
where indexdesc='groupchatvoteresultid'; 
end;
/ 
 
insert into SequenceIndex(indexdesc,currentid)values('groupchatvoteid','0')
/
insert into SequenceIndex(indexdesc,currentid)values('groupchatvoteoptionid','0')
/
insert into SequenceIndex(indexdesc,currentid)values('groupchatvoteresultid','0')
/
