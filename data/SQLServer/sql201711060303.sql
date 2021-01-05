create table fnaVoucherObjInfo(
  id int not null PRIMARY KEY IDENTITY(1, 1), 
  fnaVoucherInitTypeStr varchar(200),
  displayOrder int,
  
  fieldName varchar(200),
  fieldValueType1 varchar(200),
  fieldValueType2 varchar(200),
  
  fieldValue varchar(200),
  fieldDbTbName varchar(200),
  
  detailTable varchar(200),
  fieldDbName varchar(200),
  fieldDbType varchar(200),
  
  memo varchar(200),
  isShow varchar(200),
  isLockDefType varchar(200)
)
GO
