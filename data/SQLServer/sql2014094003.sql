CREATE TABLE  MatrixInfo
(
   id                  int IDENTITY(1,1) primary key,
   name                varchar(100),
   descr               varchar(400),
   priority               int,
   createdate          varchar(30),
   createtime          varchar(30),
   createrid           int
)
GO


CREATE TABLE  MatrixMaintInfo
(
   id                  int IDENTITY(1,1) primary key,
   matrixid	       int,
   type	               int,
   resourceid          int,
   subcompanyid	       int,
   departmentid	       int,
   roleid	       int,
   seclevel	       int,
   rolelevel	       int,
   foralluser	       int
)

GO


CREATE TABLE  MatrixFieldInfo
(
   id                  int IDENTITY(1,1)  primary key,
   matrixid	       int,
   browsertypeid       int,
   browservalue        varchar(400),
   custombrowser       char,
   displayname         varchar(100),
   fieldname	       varchar(100),
   fieldtype	       char,
   priority	       int,
   colwidth	       int
)

GO

