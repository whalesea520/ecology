update outerdatawfset
   set CreateDate = to_char(sysdate, 'yyyy-mm-dd'),
       createtime = to_char(sysdate, 'hh24:mi:ss'),
       modifydate = to_char(sysdate, 'yyyy-mm-dd'),
       modifytime = to_char(sysdate, 'hh24:mi:ss')
 where CreateDate is null
    or CreateDate = ''
/