CREATE TABLE sap_broFieldtonew
(
       id int primary key not null identity(1,1), 
       oldfield  int,
       newfield  int,
       oldformid int,
       newformid int,
       type    int
)
GO