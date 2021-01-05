declare
  i integer;
 
begin
  select count(*) into i from user_tables where table_name='HPELEMENTIMG';
  if i>0 then
    
    execute immediate 'drop table hpelementimg';
  end if;
  execute immediate 'CREATE TABLE hpElementImg
(
  imagefileid INTEGER                        NOT NULL,
  eid INTEGER                        NOT NULL,
  filerealpath VARCHAR2(200) not null,
  miniimgpath VARCHAR2(200) not null,
  iszip VARCHAR2(1) not null,
  imgsize VARCHAR2(50)
)';
end;
/