create table outerdatawfset(
  id int IDENTITY(1,1) primary key CLUSTERED,
  setname varchar(100),
  workflowid int,
  outermaintable varchar(30),
  outermainwhere varchar(500),
  successback varchar(500),
  failback varchar(500),
  outerdetailtables varchar(2000),
  outerdetailwheres varchar(2000)
)
GO

create table outerdatawfsetdetail(
  id int IDENTITY(1,1) primary key CLUSTERED,
  mainid int,
  wffieldid int,
  wffieldname varchar(30),
  wffieldhtmltype int,
  wffieldtype int,
  wffielddbtype varchar(50),
  outerfieldname varchar(50),
  changetype int,
  iswriteback char(1)
)
GO

create table outerdatawfperiodset(
  periodvalue int
)
GO
