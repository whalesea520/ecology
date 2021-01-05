alter table outerdatawfsetdetail add CreateDate varchar2(10)
/
alter table outerdatawfsetdetail add CreateTime varchar2(10)
/
alter table outerdatawfsetdetail add ModifyDate varchar2(10)
/
alter table outerdatawfsetdetail add ModifyTime varchar2(10)
/
update outerdatawfsetdetail
   set CreateDate = to_char(sysdate, 'yyyy-mm-dd'),
       createtime = to_char(sysdate, 'hh24:mi:ss'),
       modifydate = to_char(sysdate, 'yyyy-mm-dd'),
       modifytime = to_char(sysdate, 'hh24:mi:ss')
 where CreateDate is null
    or CreateDate = ''
/