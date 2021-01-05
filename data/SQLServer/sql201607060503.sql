ALTER TABLE VotingQuestion ADD imageWidth int DEFAULT 0
GO
ALTER TABLE VotingQuestion ADD imageHeight int DEFAULT 0
GO

ALTER TABLE VotingOption ADD remark text DEFAULT '' 
GO
ALTER TABLE VotingOption ADD innershow int DEFAULT 0 
GO
ALTER TABLE VotingOption ADD remarkorder int DEFAULT 0 
GO

CREATE TABLE VotingPath
(
id int primary key identity(1,1),
type int,
title varchar(500),
optionid int,
imagefileid int,
innershow int
)
GO
