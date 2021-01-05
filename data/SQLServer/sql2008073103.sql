alter table sysPhrase alter column phrasedesc varchar(1000)
GO

ALTER PROCEDURE sysPhrase_insert ( @hrmId int, @phraseShort varchar(30), @phraseDesc varchar(1000), @flag integer output, @msg varchar(80) output ) AS insert into sysPhrase (hrmId,phraseShort,phraseDesc) values(@hrmId,@phraseShort,@phraseDesc)
GO

ALTER PROCEDURE sysPhrase_update ( @id int, @hrmId int, @phraseShort varchar(30), @phraseDesc varchar(1000), @flag integer output, @msg varchar(80) output ) AS update sysPhrase set  hrmId=@hrmId,phraseShort=@phraseShort,phraseDesc=@phraseDesc where id = @id
GO