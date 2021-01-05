DROP TABLE FNASYNCHRONIZED
GO

create table FnaSynchronized
(
  lockStr  varchar(200) primary key,
  lockGuid  varchar(60) not null,
  userId  INT not null,
  memo varchar(4000),
  
  lockDate  char(10) not null, 
  lockTime char(8) not null
)
GO

CREATE INDEX idx_FnaSynchronized_1 ON FnaSynchronized (lockGuid) 
GO
CREATE INDEX idx_FnaSynchronized_2 ON FnaSynchronized (userId) 
GO