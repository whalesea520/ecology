create table GP_ACCESSresetlog
(
  id          int not null primary KEY IDENTITY(1,1),
  scoreid   int,
  operator    int,
  operatedate varchar(20),
  operatetype int
)
GO