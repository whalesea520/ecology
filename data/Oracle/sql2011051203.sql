ALTER TABLE HrmUserSetting   ADD isCoworkHead integer
/
ALTER TABLE HrmUserSetting   ADD skin varchar2(100)
/
ALTER TABLE HrmUserSetting   ADD cutoverWay varchar2(100)
/
ALTER TABLE HrmUserSetting   ADD TransitionTime varchar2(100)
/
ALTER TABLE HrmUserSetting   ADD transitionWay varchar2(100)
/
update HrmUserSetting set isCoworkHead=1
/
alter table coworkshare modify (content varchar2(4000)  null)
/  

CREATE OR REPLACE PROCEDURE  cowork_sys_update as
begin
    declare
    val_coworkid integer;
    val_discussid integer;
    val_floorNum integer;
    var_isnew clob;
    var_important clob;
    var_coworkers clob;
    var_creater varchar2(10);
    var_principal varchar2(10);
    val_splitChar varchar2(1);
    var_userid varchar(10);
    pos1 integer;
    pos2 integer;
    cursor cursor0 is select id,isnew,userids,coworkers,creater,principal from cowork_items;
    cursor cursor1 is select id from cowork_discuss where coworkid=val_coworkid order by createdate asc,createtime asc;
    begin
        if cursor0%isopen = false then
            open cursor0;
        end if;

        fetch cursor0 into val_coworkid,var_isnew,var_important,var_coworkers,var_creater,var_principal;
        while cursor0%found loop
         
        
        while length(var_coworkers)<>0 loop
 
                if length(var_coworkers)>4000 then
                     pos1:=DBMS_LOB.INSTR(var_coworkers,',',3500,1);
                     insert into coworkshare(sourceid,type,content,seclevel,sharelevel,srcfrom) values(val_coworkid,1,DBMS_LOB.substr(var_coworkers,pos1,1),0,1,1);
                     var_coworkers:=DBMS_LOB.substr(var_coworkers,length(var_coworkers),pos1);
                else  
                     insert into coworkshare(sourceid,type,content,seclevel,sharelevel,srcfrom) values(val_coworkid,1,var_coworkers,0,1,1);
                     var_coworkers:='';   
                end if;  
          end loop;  
          insert into coworkshare (sourceid,type,content,seclevel,sharelevel,srcfrom) values(val_coworkid,1,var_creater,0,2,2);
          insert into coworkshare (sourceid,type,content,seclevel,sharelevel,srcfrom) values(val_coworkid,1,var_principal,0,2,3);
         
        while length(var_isnew)<>0 loop
              pos1:=DBMS_LOB.INSTR(var_isnew,',',1,1);
              pos2:=instr(DBMS_LOB.substr(var_isnew,length(var_isnew),DBMS_LOB.INSTR(var_isnew,',',1,1)+1),',',1,1);
              var_userid:=DBMS_LOB.substr(var_isnew,pos2-pos1,DBMS_LOB.INSTR(var_isnew,',',1,1)+1);
          if var_userid is not null then
                insert into cowork_read(coworkid,userid) values(val_coworkid,var_userid);  
          end if;    
          var_isnew:=DBMS_LOB.substr(var_isnew,length(var_isnew),instr(DBMS_LOB.substr(var_isnew,length(var_isnew),DBMS_LOB.INSTR(var_isnew,',',1,1)+1),',',1,1)+1);
    end loop;  

        if var_important is not null and length(var_important)<>0 then
             var_important:=','||var_important;
          end if ; 
        while length(var_important)<>0 loop
              pos1:=DBMS_LOB.INSTR(var_important,',',1,1);
              pos2:=instr(DBMS_LOB.substr(var_important,length(var_important),DBMS_LOB.INSTR(var_important,',',1,1)+1),',',1,1);
              var_userid:=DBMS_LOB.substr(var_important,pos2-pos1,DBMS_LOB.INSTR(var_important,',',1,1)+1);
          if var_userid is not null then
                insert into cowork_important(coworkid,userid) values(val_coworkid,var_userid);  
          end if;    
          var_important:=DBMS_LOB.substr(var_important,length(var_important),instr(DBMS_LOB.substr(var_important,length(var_important),DBMS_LOB.INSTR(var_important,',',1,1)+1),',',1,1)+1);
    end loop; 
           
          val_floorNum:=1;
          open cursor1;
          fetch cursor1 into val_discussid;
          while cursor1%found loop
             update cowork_discuss set floorNum=val_floorNum,replayid=0 where id=val_discussid;
             val_floorNum:=val_floorNum+1;
             fetch cursor1 into val_discussid;
          end loop;
          close cursor1;
             
          fetch cursor0 into val_coworkid,var_isnew,var_important,var_coworkers,var_creater,var_principal;
        end loop;

        close cursor0;
    end;
end; 
/

begin
cowork_sys_update;
end;
/