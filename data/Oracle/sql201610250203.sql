create or replace procedure HrmResourceDateCheck7(today_1   char,
                                                 flag      out integer,
                                                 msg       out varchar2,
                                                 thecursor in out cursor_define.weavercursor) as
begin
/* 将试用日期到了的人员改为试用延期状态 */
  update hrmresource
     set status = 3
   where status = 0
     and probationenddate < today_1
     and probationenddate is not null; 
/* 将试用日期未到的人员由试用延期改回试用状态 */
  update hrmresource
     set status = 0
   where status = 3
     and (probationenddate >= today_1 or probationenddate is null);
end;
/
