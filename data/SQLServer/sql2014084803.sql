Delete from LeftMenuInfo where id=635
GO
EXECUTE LMConfig_U_ByInfoInsert 1,0,30
GO
EXECUTE LMInfo_Insert 635,15109,NULL,NULL,1,0,30,1
GO

Delete from LeftMenuInfo where id=635
GO
EXECUTE LMConfig_U_ByInfoInsert 1,0,30
GO
EXECUTE LMInfo_Insert 635,15109,NULL,NULL,1,0,30,1
GO


Delete from LeftMenuInfo where id=189
GO
EXECUTE LMConfig_U_ByInfoInsert 2,635,1
GO
EXECUTE LMInfo_Insert 189,20042,'/images_face/ecologyFace_2/LeftMenuIcon/voting_02.png','/voting/VotingList.jsp?viewResult=1',2,635,1,1 
GO

Delete from LeftMenuInfo where id=189
GO
EXECUTE LMConfig_U_ByInfoInsert 2,635,1
GO
EXECUTE LMInfo_Insert 189,20042,'/images_face/ecologyFace_2/LeftMenuIcon/voting_02.png','/voting/VotingList.jsp?viewResult=1',2,635,1,1 
GO


create table votingviewset(
  votingid            int primary key ,
  viewjson       varchar(4000)
)

GO



Delete from LeftMenuInfo where id=637
GO
EXECUTE LMConfig_U_ByInfoInsert 2,635,2
GO
EXECUTE LMInfo_Insert 637,33831,'/images_face/ecologyFace_2/LeftMenuIcon/voting_01.png','/voting/MyVoting.jsp',2,635,2,1 
GO

Delete from LeftMenuInfo where id=637
GO
EXECUTE LMConfig_U_ByInfoInsert 2,635,2
GO
EXECUTE LMInfo_Insert 637,33831,'/images_face/ecologyFace_2/LeftMenuIcon/voting_01.png','/voting/MyVoting.jsp',2,635,2,1 
GO
