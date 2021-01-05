create or replace function convToMultiLang(multilang in varchar2,
                                           langugeId in int)
  return varchar2 is
  rst         varchar2(4000);
  v_index     int;
  v_midindex  int;
  v_midindex2 int;
  v_endindex  int;
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
      return substr(lang1, 3, length(lang1) - 1);
    end if; 
    if (to_number(substr(lang2, 1, 2)) = langugeId) then
      return substr(lang2, 3, length(lang2) - 1);
    end if;
    if (to_number(substr(lang3, 1, 2)) = langugeId) then
      return substr(lang3, 3, length(lang3) - 1);
    end if;
   return substr(lang1, 3, length(lang1) - 1);
  else
    rst := multilang;
  end if;
  return rst;
end;
/