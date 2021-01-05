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
GO

CREATE TABLE groupchatvoteoption(
	id int primary key NOT NULL,
	optioncontent varchar(4000) NULL,
	votingid int NULL
 )
GO
 
CREATE TABLE groupchatvoteresult(
	id int NOT NULL,
	voteoptionid int NULL,
	voteuserid int NULL,
	votedate char(10) NULL,
	votetime char(8) NULL,
	votingid int NULL
)  
GO  
  
CREATE procedure SequenceIndex_GroupChatVoteid (@flag int output, @msg varchar(4000) output)  AS select currentid from SequenceIndex where indexdesc='groupchatvoteid' update SequenceIndex set currentid = currentid+1 where indexdesc='groupchatvoteid' 
GO

CREATE procedure SequenceIndex_GroupChatVoteOid (@flag int output, @msg varchar(4000) output)  AS select currentid from SequenceIndex where indexdesc='groupchatvoteoptionid' update SequenceIndex set currentid = currentid+1 where indexdesc='groupchatvoteoptionid' 
GO

CREATE procedure SequenceIndex_GroupChatVoteRid (@flag int output, @msg varchar(4000) output)  AS select currentid from SequenceIndex where indexdesc='groupchatvoteresultid' update SequenceIndex set currentid = currentid+1 where indexdesc='groupchatvoteresultid' 
GO

insert into SequenceIndex(indexdesc,currentid)values('groupchatvoteid','0')
GO
insert into SequenceIndex(indexdesc,currentid)values('groupchatvoteoptionid','0')
GO
insert into SequenceIndex(indexdesc,currentid)values('groupchatvoteresultid','0')
GO
