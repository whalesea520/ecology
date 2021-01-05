CREATE OR REPLACE TYPE ty_row_str_split  as object (strValue VARCHAR2 (4000))
/
CREATE OR REPLACE TYPE ty_tbl_str_split IS TABLE OF ty_row_str_split
/
CREATE OR REPLACE FUNCTION fn_split(p_str       IN VARCHAR2,
                                      p_delimiter IN VARCHAR2)
   RETURN ty_tbl_str_split IS
    j         INT := 0;
    i         INT := 1;
   len       INT := 0;
    len1      INT := 0;
   str       VARCHAR2(4000);
    str_split ty_tbl_str_split := ty_tbl_str_split();
 BEGIN
   len   := LENGTH(p_str);
    len1 := LENGTH(p_delimiter);


   WHILE j < len LOOP
      j := INSTR(p_str, p_delimiter, i);
   
     IF j = 0 THEN
        j    := len;
       str := SUBSTR(p_str, i);
        str_split.EXTEND;
        str_split(str_split.COUNT) := ty_row_str_split(strValue => str);
     
       IF i >= len THEN
         EXIT;
       END IF;
     ELSE
       str := SUBSTR(p_str, i, j - i);
        i    := j + len1;
        str_split.EXTEND;
        str_split(str_split.COUNT) := ty_row_str_split(strValue => str);
     END IF;
   END LOOP;


   RETURN str_split;
 END fn_split;
/


create or replace trigger Tri_Update_bill_HrmTime after update ON Prj_TaskProcess FOR each row 
when (new.isactived=2)
Declare 
prjid_1 integer ; 
taskid_1 integer ; 
subject_1 varchar2(4000); 
isactived_1	    integer ; 
begindate_1     char(10); 
enddate_1	    char(10) ; 
resourceid_1    integer ; 
hrmid_1		integer ;
resourceid_2    varchar2(300); 
tmpcount_1	    integer ; 
tmpbegindate_1   char(10); 
tmpenddate_1    char(10); 
tmpid_1       integer ; 
begin prjid_1:=:old.prjid ; 
resourceid_2:=:new.hrmid ; 
select name into subject_1 from prj_projectinfo where id=prjid_1 ;  
tmpbegindate_1:= '' ; 
tmpenddate_1:= '' ; 
begindate_1:=:new.begindate ; 
enddate_1:=:new.enddate ; 
for hrmid_1 in (select to_number(strvalue) as Value from table(fn_split(resourceid_2,',')))
      loop
if ( begindate_1 !='x' or enddate_1 != '-' ) and :new.isdelete <> 1 
then 
resourceid_1:=hrmid_1.Value ; 
if begindate_1 = 'x' then begindate_1:=enddate_1 ; 
end if ; 
if enddate_1 = '-' then enddate_1:=begindate_1 ; 
end if ;  
select count(id) into tmpcount_1 from bill_hrmtime where resourceid=resourceid_1 and requestid=prjid_1 and basictype=1 ;  
if tmpcount_1 > 0 then 
select id,begindate,enddate into tmpid_1,tmpbegindate_1,tmpenddate_1 from bill_hrmtime where resourceid=resourceid_1 and requestid=prjid_1 and basictype=1 ;  
if tmpbegindate_1 > begindate_1 then 
tmpbegindate_1:=begindate_1 ; 
end if ;  
if tmpenddate_1 < enddate_1 then 
tmpenddate_1:=enddate_1 ; 
end if ; 
update bill_hrmtime set begindate=tmpbegindate_1 ,enddate=tmpenddate_1 where id=tmpid_1 ; 
else 
if 
tmpcount_1 = 0 then insert into bill_hrmtime (resourceid,basictype,detailtype,requestid,name,begindate,enddate,status,accepterid) values (resourceid_1,1,1,prjid_1,subject_1,begindate_1,enddate_1,'0',to_char(resourceid_1)) ; 
end if ; 
end if ; 
end if ; 
end loop;
end ;
/