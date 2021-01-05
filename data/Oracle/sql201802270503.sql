create or replace function convToMultiLang(multilang in varchar2,
                                           langugeId in int)
  return varchar2 is
  dbk         varchar2(4000);
  rst         varchar2(4000);
  realdata    varchar2(2000);
  cndata      varchar2(2000);
  data1       varchar2(2000);
  data2       varchar2(2000);
  data3       varchar2(2000);
  data4       varchar2(2000);
  data5       varchar2(2000);
  
begin
  dbk := multilang;
  while(instr(dbk, '~`~`')>0) loop
	if(instr(dbk, '~`~`')>0) then
		data1 := substr(dbk,0,instr(dbk, '~`~`')-1);
	else
		data1 := substr(dbk,0,instr(dbk, '~`~`'));
	end if;
	data2 := substr(dbk,instr(dbk, '~`~`')+4,instr(dbk, '`~`~')-instr(dbk, '~`~`')-1);
	while(instr(data2,'`~`') > 0) loop
		data3 := substr(data2,0,instr(data2,'`~`')-1);
		data4 := substr(data3,0,2);
		if(length(data3) > 2) then
			data5 := substr(data3,3,length(data3)-2);
		else
			data5 := '';
		end if;  
		if (to_number(data4) = 7) then
			cndata := data5;
		end if ;
		if (to_number(data4) = langugeId) then
			realdata := data5;
			exit;
		else
			data2 := substr(data2,instr(data2,'`~`') + 3,length(data2) - instr(data2,'`~`') - 2);
		end if;
	 end loop;
	 if (realdata IS NULL OR length(realdata) = 0) then
		realdata := cndata;
	 end if;
	 rst := rst||data1||realdata;
         if (length(dbk) - instr(dbk,'`~`~') - 4 > 0) then
		dbk := substr(dbk,instr(dbk,'`~`~') + 4,length(dbk) - instr(dbk,'`~`~') - 3);
         else
		dbk := '';
         end if;
  end loop;
  rst := rst||dbk;        
  return rst;   
end;
/


create or replace function convToCN(multilang in varchar2) return varchar2 is
  rst        varchar2(4000);
  v_index    int;
  v_endindex int;
begin
  return convToMultiLang(multilang,7);
end;
/
