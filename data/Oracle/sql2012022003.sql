CREATE OR REPLACE PROCEDURE  HrmResource_up_AllManagerstr 
   as
   begin 
    declare
    val_id integer;
    val_tempid integer;
    val_managerid integer;
    val_tempmanagerid integer;
    val_managerCount integer;
    var_managetstr VARCHAR2(4000);
    var_hrmcount integer;
    cursor cursor0 is SELECT id,managerid FROM HrmResource order by id;
    begin
        var_managetstr:='';
        val_tempmanagerid:=0;
        if cursor0%isopen = false then
            open cursor0;
        end if;
        
        fetch cursor0 into val_id,val_managerid;
        while cursor0%found loop
           WHILE val_managerid<>0 AND val_managerid IS NOT NULL and ((val_id=val_managerid and val_managerCount=1) or (val_id<>val_managerid and val_managerCount<=2 AND instr(var_managetstr||',',','||to_char(val_managerid)||',',1)=0 )) loop
              val_tempmanagerid:=val_managerid;
              SELECT count(*) into var_hrmcount FROM HrmResource WHERE id=val_managerid;
              if var_hrmcount>0 then
                 begin
	              SELECT id into val_tempid FROM HrmResource WHERE id=val_managerid;
	              SELECT managerid into val_managerid FROM HrmResource WHERE id=val_managerid;
	              var_managetstr:=var_managetstr||','||to_char(val_tempid);
	             end; 
	          end if; 
	          
	         if val_tempmanagerid=val_managerid then
                val_managerCount:=val_managerCount+1;
             end if;
	          
	          var_hrmcount:=0;
           end loop;
           
           if var_managetstr is not null then
              var_managetstr:=var_managetstr||',';
           end if;
           
           UPDATE HrmResource SET managerstr=var_managetstr WHERE id=val_id;
           var_managetstr:='';
           val_tempmanagerid:=0;
           val_managerCount:=1;
           
           fetch cursor0 into val_id,val_managerid;
        end loop;
        
        close cursor0;
    end;    
   end; 
    /

begin
HrmResource_up_AllManagerstr;
end;
/