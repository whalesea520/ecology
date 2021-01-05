/*sql 脚本*/
/*TD:1250,加入短语,董平修改*/
CREATE TABLE sysPhrase (
	id int IDENTITY (1, 1) NOT NULL ,
    hrmId int NOT NULL,
    phraseShort varchar(30)  NULL,
    phraseDesc varchar(200)  NULL
)
GO

CREATE PROCEDURE sysPhrase_selectByHrmId (  
    @hrmId int ,
    @flag integer output, 
    @msg varchar(80) output 
)
AS 
    select * from sysPhrase where hrmid = @hrmId order by id
GO


CREATE PROCEDURE sysPhrase_selectById (
    @id int,
    @flag integer output, 
    @msg varchar(80) output 
)
AS 
    select * from sysPhrase where id = @id 
GO


CREATE PROCEDURE sysPhrase_insert (   
    @hrmId int,
    @phraseShort varchar(30),
    @phraseDesc varchar(200),
    @flag integer output, 
    @msg varchar(80) output 
)
AS 
    insert into sysPhrase (hrmId,phraseShort,phraseDesc) values(@hrmId,@phraseShort,@phraseDesc)
GO



CREATE PROCEDURE sysPhrase_update (
    @id int,
    @hrmId int,
    @phraseShort varchar(30),
    @phraseDesc varchar(200),
    @flag integer output, 
    @msg varchar(80) output 
)
AS 
    update sysPhrase set  hrmId=@hrmId,phraseShort=@phraseShort,phraseDesc=@phraseDesc where id = @id
GO

CREATE PROCEDURE sysPhrase_deleteById (
    @id int,
    @flag integer output, 
    @msg varchar(80) output 
)
AS 
    delete sysPhrase where id = @id 
GO


INSERT INTO HtmlLabelIndex values(17561,'流程短语设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(17561,'流程短语设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17561,'workflow sysPhrase setting',8) 
GO

