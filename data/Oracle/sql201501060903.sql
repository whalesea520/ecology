declare
  cursor test is
    select table_name, column_name, data_length
      from user_tab_columns t
     where data_type = 'VARCHAR2'
       and data_length <= 1000
       and column_name not in
           (select column_name
              from user_ind_columns o
             where t.table_name = o.table_name)
       and table_name not in (select view_name from user_views);
  v_table_name  varchar2(100);
  v_column_name varchar2(100);
  v_data_length number;
  v_sql         varchar2(200);
begin
  open test;
  fetch test
    into v_table_name, v_column_name, v_data_length;
  while test%found loop
    if (v_data_length<=125) then
 v_sql := 'alter table ' || v_table_name || ' modify &quot;' || v_column_name ||'&quot; varchar2('||v_data_length*8||')';
  execute immediate(v_sql);
else
 v_sql := 'alter table ' || v_table_name || ' modify &quot;' || v_column_name ||'&quot; varchar2(1000)';
  execute immediate(v_sql);
    
    end if;
  fetch test
      into v_table_name, v_column_name, v_data_length;
  end loop;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('>>>>>>' || v_sql);
    close test;
  
end;
/

CREATE OR REPLACE FUNCTION f_GetPy(P_NAME IN VARCHAR2) RETURN VARCHAR2 AS V_COMPARE varchar2(4000); V_RETURN varchar2(4000);  FUNCTION F_NLSSORT(P_WORD IN VARCHAR2) RETURN VARCHAR2 AS BEGIN RETURN NLSSORT(P_WORD, 'NLS_SORT=SCHINESE_PINYIN_M'); END; BEGIN  FOR I IN 1..NVL(LENGTH(P_NAME), 0) LOOP V_COMPARE := F_NLSSORT(SUBSTR(P_NAME, I, 1)); IF V_COMPARE >= F_NLSSORT('ﬂπ') AND V_COMPARE <= F_NLSSORT('Úà') THEN V_RETURN := V_RETURN || 'A'; ELSIF V_COMPARE >= F_NLSSORT('∞À') AND V_COMPARE <= F_NLSSORT('≤æ') THEN V_RETURN := V_RETURN || 'B'; ELSIF V_COMPARE >= F_NLSSORT('‡Í') AND V_COMPARE <= F_NLSSORT('Âe') THEN V_RETURN := V_RETURN || 'C'; ELSIF V_COMPARE >= F_NLSSORT('Öˆ') AND V_COMPARE <= F_NLSSORT('˘z') THEN V_RETURN := V_RETURN || 'D'; ELSIF V_COMPARE >= F_NLSSORT('ää') AND V_COMPARE <= F_NLSSORT('òﬁ') THEN V_RETURN := V_RETURN || 'E'; ELSIF V_COMPARE >= F_NLSSORT('∑¢') AND V_COMPARE <= F_NLSSORT('™g') THEN V_RETURN := V_RETURN || 'F'; ELSIF V_COMPARE >= F_NLSSORT('Í∏') AND V_COMPARE <= F_NLSSORT('ƒB') THEN V_RETURN := V_RETURN || 'G'; ELSIF V_COMPARE >= F_NLSSORT('äo') AND V_COMPARE <= F_NLSSORT('â˛') THEN V_RETURN := V_RETURN || 'H'; ELSIF V_COMPARE >= F_NLSSORT('ÿ¢') AND V_COMPARE <= F_NLSSORT('îh') THEN V_RETURN := V_RETURN || 'J'; ELSIF V_COMPARE >= F_NLSSORT('ﬂ«') AND V_COMPARE <= F_NLSSORT('∑i') THEN V_RETURN := V_RETURN || 'K'; ELSIF V_COMPARE >= F_NLSSORT('¿¨') AND V_COMPARE <= F_NLSSORT('î^') THEN V_RETURN := V_RETURN || 'L'; ELSIF V_COMPARE >= F_NLSSORT('á`') AND V_COMPARE <= F_NLSSORT('ó“') THEN V_RETURN := V_RETURN || 'M'; ELSIF V_COMPARE >= F_NLSSORT('íÇ') AND V_COMPARE <= F_NLSSORT('Øë') THEN V_RETURN := V_RETURN || 'N'; ELSIF V_COMPARE >= F_NLSSORT('πp') AND V_COMPARE <= F_NLSSORT('ùa') THEN V_RETURN := V_RETURN || 'O'; ELSIF V_COMPARE >= F_NLSSORT('är') AND V_COMPARE <= F_NLSSORT('∆ÿ') THEN V_RETURN := V_RETURN || 'P'; ELSIF V_COMPARE >= F_NLSSORT('∆ﬂ') AND V_COMPARE <= F_NLSSORT('—d') THEN V_RETURN := V_RETURN || 'Q'; ELSIF V_COMPARE >= F_NLSSORT('Åí') AND V_COMPARE <= F_NLSSORT('˙U') THEN V_RETURN := V_RETURN || 'R'; ELSIF V_COMPARE >= F_NLSSORT('ÿÌ') AND V_COMPARE <= F_NLSSORT('ŒR') THEN V_RETURN := V_RETURN || 'S'; ELSIF V_COMPARE >= F_NLSSORT('Ç@') AND V_COMPARE <= F_NLSSORT('ªX') THEN V_RETURN := V_RETURN || 'T'; ELSIF V_COMPARE >= F_NLSSORT('å‹') AND V_COMPARE <= F_NLSSORT('˙F') THEN V_RETURN := V_RETURN || 'W'; ELSIF V_COMPARE >= F_NLSSORT('œ¶') AND V_COMPARE <= F_NLSSORT('ËR') THEN V_RETURN := V_RETURN || 'X'; ELSIF V_COMPARE >= F_NLSSORT('—æ') AND V_COMPARE <= F_NLSSORT('Ìç') THEN V_RETURN := V_RETURN || 'Y'; ELSIF V_COMPARE >= F_NLSSORT('éâ') AND V_COMPARE <= F_NLSSORT('Ö¯') THEN V_RETURN := V_RETURN || 'Z'; END IF; END LOOP; RETURN V_RETURN; END;
/

create or replace function getchilds(i_id int) return t_table pipelined as v hrmline_table; begin for myrow in( select id,lastname,managerid from hrmresource where id=i_id union select  a.id,a.lastname,a.managerid from HrmResource a  start with a.id = i_id connect by prior a.id=a.managerid ) loop v:=hrmline_table(myrow.id,myrow.lastname,myrow.managerid); pipe row(v); end loop; return; end;
/

CREATE OR REPLACE FUNCTION GetDocShareDetailTable (userid_1 varchar2, usertype_2  varchar2) RETURN table_DocShare AS seclevel_1 varchar2(4000); departmentid_2 varchar2(4000); subcompanyid_3 varchar2(4000); type_4 varchar2(4000); count_5 integer; isSysadmin_1 integer; DocShareDetail table_DocShare := table_DocShare(); BEGIN if usertype_2 ='1' then select count(id) into count_5 from  hrmresource where id = userid_1; if count_5 >0 then select seclevel into seclevel_1 from hrmresource where id = userid_1; select  departmentid into departmentid_2  from hrmresource where id = userid_1; select subcompanyid1 into subcompanyid_3 from hrmresource where id = userid_1; end if; select count(*) into isSysadmin_1 from hrmresourcemanager where id = userid_1; if isSysadmin_1=1 then SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail  from shareinnerdoc where (type=1 and content= userid_1) or (  type=4 and content in (select concat(to_char(roleid),to_char(rolelevel)) from hrmrolemembers where resourceid = userid_1) and seclevel <= seclevel_1) GROUP BY sourceid; else SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail from shareinnerdoc where (type=1 and content = userid_1) or  (type=2 and content = subcompanyid_3 and seclevel <= seclevel_1) or (type=3 and content = departmentid_2 and seclevel <= seclevel_1) or (type=4 and content in (select concat(to_char(roleid),to_char(rolelevel)) from hrmrolemembers where resourceid = userid_1) and seclevel <= seclevel_1) GROUP BY sourceid; end if; else select count(id) into count_5 from crm_customerinfo where id = userid_1; if count_5 >0 then select type into type_4 from crm_customerinfo where id = userid_1; select seclevel into seclevel_1 from crm_customerinfo where id = userid_1; end if; SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail from shareouterdoc where (type=9 and content = userid_1) or (type=10 and content = type_4 and seclevel <= seclevel_1) GROUP BY sourceid; end if; RETURN DocShareDetail; END;
/

create or replace function getparents(i_id int) return t_table pipelined as v hrmline_table; begin for myrow in( select id,lastname,managerid from hrmresource where id=i_id union select  a.id,a.lastname,a.managerid from HrmResource a  start with a.id = i_id connect by prior a.managerid=a.id ) loop v:=hrmline_table(myrow.id,myrow.lastname,myrow.managerid); pipe row(v); end loop; return; end;
/

CREATE OR REPLACE FUNCTION getPrjBeginDate (i_prjid int) RETURN char IS o_mindate char(10); BEGIN SELECT MIN(begindate) into o_mindate  FROM Prj_TaskProcess WHERE prjid=i_prjid; Return o_mindate; END;
/

CREATE OR REPLACE FUNCTION getPrjEndDate (i_prjid int) RETURN char IS o_maxdate char(10); BEGIN SELECT MAX(enddate) into o_maxdate  FROM Prj_TaskProcess WHERE prjid=i_prjid; Return o_maxdate; END;
/

CREATE OR REPLACE FUNCTION getPrjFinish (i_prjid int) RETURN int IS i_sumWorkday decimal(9); i_finish int default 0; BEGIN SELECT SUM(workday) into i_sumWorkday FROM Prj_TaskProcess WHERE ( prjid = i_prjid and parentid = '0' and isdelete<>'1') ; IF i_sumWorkday<>0 then SELECT (sum(finish*workday)/sum(workday)) into i_finish  FROM Prj_TaskProcess WHERE ( prjid = i_prjid and parentid = '0' and isdelete<>'1') ; END IF; Return i_finish; END;
/

CREATE OR REPLACE FUNCTION getSubComParentTree (subcom_id integer) RETURN tab_tree AS parent_id integer;  tab_tree_1 tab_tree := tab_tree(); BEGIN select  supsubcomid into parent_id from hrmsubcompany where id=subcom_id; while parent_id!=0 loop insert into temptree(id,supsubcomid) (select id,supsubcomid from hrmsubcompany where id=parent_id); select supsubcomid into parent_id from (select supsubcomid from temptree order by num desc) WHERE rownum =1; end loop; select obj_tree(id,supsubcomid) bulk collect into tab_tree_1 from temptree order by num desc; return tab_tree_1; END;
/

CREATE OR REPLACE FUNCTION SplitStr (src VARCHAR2, delimiter varchar2) RETURN mytable IS psrc varchar2(4000); a mytable := mytable(); i NUMBER := 1; j NUMBER := 1; BEGIN psrc := RTrim(LTrim(src, delimiter), delimiter); LOOP i := InStr(psrc, delimiter, j); IF i>0 THEN a.extend; a(a.Count) := Trim(SubStr(psrc, j, i-j)); j := i+1; END IF; EXIT WHEN i=0; END LOOP; IF j < Length(psrc) THEN a.extend; a(a.Count) := Trim(SubStr(psrc, j, Length(psrc)+1-j)); END IF; RETURN a; END;
/

create or replace function SQUIRREL_GET_ERROR_OFFSET (query IN varchar2) return number authid current_user is      l_theCursor     integer default dbms_sql.open_cursor;      l_status        integer; begin          begin          dbms_sql.parse(  l_theCursor, query, dbms_sql.native );          exception                  when others then l_status := dbms_sql.last_error_position;          end;          dbms_sql.close_cursor( l_theCursor );          return l_status; end;
/