ALTER table votingquestion ADD test varchar(400)
go
update votingquestion set test = subject
go
ALTER table votingquestion drop column subject
go
EXEC sp_rename   'votingquestion.[test]',   'subject',   'COLUMN'   
go
