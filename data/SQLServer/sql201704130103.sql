CREATE TABLE Fullsearch_E_Faq (
id int NOT NULL IDENTITY(1,1) PRIMARY KEY,
ask varchar(200) NULL ,
answer text NULL ,
createrId int NULL ,
status int NULL ,
createdate char(10) NULL ,
createtime char(8) NULL ,
processdate char(10) NULL ,
processtime char(8) NULL ,
processId int NULL ,
targetFlag int NULL ,
sendReply int NULL ,
readFlag int NULL ,
checkOutId int NULL ,
targetDo int NULL ,
faqTargetId int NULL ,
commitTag int NULL 
)
GO