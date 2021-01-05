CREATE or REPLACE PROCEDURE CRM_SectorInfo_Delete 
  (id_1 integer, 
  flag out integer,
  msg out varchar2, 
  thecursor IN OUT cursor_define.weavercursor) 
  AS 
  count_1 integer;
  begin
  SELECT count(id) into count_1 FROM CRM_CustomerInfo WHERE sector = to_char(id_1);
  if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;

  SELECT count(id) into count_1 FROM CRM_SectorInfo WHERE sectors LIKE CONCAT('%,', CONCAT(to_char(id_1), ',%'));
  if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
  DELETE CRM_SectorInfo WHERE ( id= id_1);
  end;
/