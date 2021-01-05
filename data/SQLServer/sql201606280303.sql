create table ecologypackageinfo(
  id INT NOT NULL IDENTITY(1,1),
  label VARCHAR(10),
  name VARCHAR(200),
  type VARCHAR(1),
  lastDate VARCHAR(200),
  lastTime VARCHAR(200),
  status  VARCHAR(1)
)
go
alter table ecologypackageinfo add content varchar(2000)
go
alter table ecologypackageinfo add downloadid varchar(100)
go
alter table ecologypackageinfo add description varchar(2000)
go