ALTER table  CptSearchDefinition  ADD displayorder1 float
go
update   CptSearchDefinition set displayorder1 = displayorder
go
ALTER table  CptSearchDefinition  drop column displayorder
go
EXEC   sp_rename   'CptSearchDefinition.[displayorder1]',   'displayorder',   'COLUMN'   
go
