ALTER TABLE VotingQuestion ADD imageWidth int DEFAULT 0
/
ALTER TABLE VotingQuestion ADD imageHeight int DEFAULT 0
/

ALTER TABLE VotingOption ADD remark nvarchar2(2000) DEFAULT '' 
/
ALTER TABLE VotingOption ADD innershow int DEFAULT 0 
/
ALTER TABLE VotingOption ADD remarkorder int DEFAULT 0 
/

CREATE TABLE VotingPath
(
id int primary key,
type int,
title nvarchar2(500),
optionid int,
imagefileid int,
innershow int
)
/
create sequence VotingPath_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger VotingPath_id_Tri
before insert on VotingPath
for each row
begin
select VotingPath_id.nextval into :new.id from dual;
end;
/
