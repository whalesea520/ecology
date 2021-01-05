DROP TABLE hrm_fieldgroup
GO
create table hrm_fieldgroup (
   id                   int      IDENTITY(1,1)           not null,
   grouplabel           int                  null,
   grouporder           int                  null,
   grouptype            int                  null
)
GO

INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(1361,1,-1)
GO
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(32938,2,-1)
GO
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(32946,3,-1)
GO
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(15687,1,1)
GO
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(15688,1,3)
GO
INSERT INTO hrm_fieldgroup ( grouplabel, grouporder, grouptype ) 
VALUES  ( 1361, 1, 4)
GO
INSERT INTO hrm_fieldgroup ( grouplabel, grouporder, grouptype ) 
VALUES  ( 1361, 1, 5)
GO