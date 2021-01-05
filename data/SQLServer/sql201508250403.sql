create table mode_batchmodify
(
  ID      int identity(1,1) primary key,
  name    VARCHAR(400),
  remark  VARCHAR(4000),
  modeid  int,
  formid  int
)
GO
create table mode_batchmodifydetail
(
  ID         int identity(1,1) primary key,
  MAINID     int,
  changetype int,
  feildid    int,
  feildvalue VARCHAR(400)
)
GO