drop table FnaSynchronized
/

create table FnaSynchronized
(
  lockStr  varchar2(200) primary key,
  lockGuid  varchar2(60) not null,
  userId  INTEGER not null,
  memo varchar2(4000),
  
  lockDate  char(10) not null, 
  lockTime char(8) not null
)
/

CREATE INDEX idx_FnaSynchronized_1 ON FnaSynchronized (lockGuid) 
/
CREATE INDEX idx_FnaSynchronized_2 ON FnaSynchronized (userId) 
/