create or replace procedure HrmResourceDateCheck7(today_1   char,
                                                 flag      out integer,
                                                 msg       out varchar2,
                                                 thecursor in out cursor_define.weavercursor) as
begin
/* ���������ڵ��˵���Ա��Ϊ��������״̬ */
  update hrmresource
     set status = 3
   where status = 0
     and probationenddate < today_1
     and probationenddate is not null; 
/* ����������δ������Ա���������ڸĻ�����״̬ */
  update hrmresource
     set status = 0
   where status = 3
     and (probationenddate >= today_1 or probationenddate is null);
end;
/