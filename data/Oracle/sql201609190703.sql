create or replace function convToCN(multilang in varchar2) return varchar2 is
  rst        varchar2(4000);
  v_index    integer;
  v_endindex integer;
begin
  select instr(multilang, '~`~`') into v_index from dual;
  select instr(multilang, '`~`',1,2) into v_endindex from dual;
  if (v_index > 0) then
    rst := substr(multilang, v_index+6,v_endindex-v_index-6);
  else
    rst := multilang;
  end if;
  return (rst);
end;
/

create or replace function convToMultiLang(multilang in varchar2,
                                           langugeId in integer)
  return varchar2 is
  rst         varchar2(4000);
  v_index     integer;
  v_midindex  integer;
  v_midindex2 integer;
  v_endindex  integer;
  lang1       varchar2(4000);
  lang2       varchar2(4000);
  lang3       varchar2(4000);
begin
  select instr(multilang, '~`~`') into v_index from dual;
  select instr(multilang, '`~`', 1, 2) into v_midindex from dual;
  select instr(multilang, '`~`', 1, 3) into v_midindex2 from dual;
  select instr(multilang, '`~`~') into v_endindex from dual;
  if (v_index > 0) then
    lang1 := substr(multilang, v_index + 4, v_midindex - v_index - 4);
    lang2 := substr(multilang, v_midindex + 3, v_midindex2 - v_midindex - 3);
    lang3 := substr(multilang,
                    v_midindex2 + 3,
                    v_endindex - v_midindex2 - 3);  
    if (to_number(substr(lang1, 1, 2)) = langugeId) then
      return substr(lang1, 2, length(lang1) - 1);
    end if; 
    if (to_number(substr(lang2, 1, 2)) = langugeId) then
      return substr(lang2, 2, length(lang2) - 1);
    end if;
    if (to_number(substr(lang3, 1, 2)) = langugeId) then
      return substr(lang3, 2, length(lang3) - 1);
    end if;
   return substr(lang1, 2, length(lang1) - 1);
  else
    rst := multilang;
  end if;
  return rst;
end;
/