CREATE TABLE HrmMessagerAccount (
  userid                varchar(20)            NOT NULL,
  psw     varchar(50) 
)
GO

update ofproperty  set propvalue='SELECT lower(psw) as password FROM HrmMessagerAccount WHERE userid=?' where name='jdbcAuthProvider.passwordSQL'
GO
