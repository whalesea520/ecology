declare
 mid integer;
 hid integer;
 tablstr varchar2(600);
 table_1 varchar2(200);
 dropse varchar2(600);
 creates varchar2(600);
 havesequences varchar2(600);
 sname varchar2(600);
begin
    for billtable in(select tablename  from workflow_billdetailtable where billid<0)
        loop

          table_1:=billtable.tablename;
               mid:=0;
               hid:=0;
               tablstr:='select max(id)+1 as maxid from '|| billtable.tablename;
                   execute immediate  tablstr into mid;
                     if (mid is null) then
                     mid:=1;
                     end if;
 		sname:=table_1||'_Id';
                  dropse:='drop sequence ' ||sname ;
                  creates:='create sequence ' ||sname||' start with ' || mid || ' increment by 1 nomaxvalue nocycle';
               havesequences:='select count(*) from user_sequences  where upper(sequence_name)='''|| upper(sname)||''''; 
                execute immediate havesequences into hid;
               if (hid>0) then 
               execute immediate dropse;
               end if;
               havesequences:='select count(*) from user_sequences  where upper(sequence_name)='''|| upper(sname)||''''; 
               execute immediate havesequences into hid;
               if (hid=0) then 
               execute immediate creates;  
               end if;                       
        end loop;
end;
/
