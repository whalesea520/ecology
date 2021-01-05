ALTER PROCEDURE FnaCurrency_SelectAll (@flag                             integer output, @msg                             varchar(80) output ) AS select * from FnaCurrency order by id asc if @@error<>0 begin set @flag=1 set @msg='查询币种信息成功' return end else begin set @flag=0 set @msg='查询币种信息失败' return end

GO