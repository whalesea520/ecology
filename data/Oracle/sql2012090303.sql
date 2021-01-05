create table workflowcentersettingdetail (
      id int  NOT NULL ,  
      eid int not null ,                                   
      tabid int not null,      
      type varchar2(100) not null,                        
      content varchar2(100) not null,  
      srcfrom int not null
)
/
create sequence workflowcentersettingdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflowcentersettingdetail_T
  before insert on workflowcentersettingdetail
  for each row
begin
  select workflowcentersettingdetail_id.nextval into :new.id from dual;
end;
/
CREATE INDEX workflowcentersettingdetail_i ON workflowcentersettingdetail (eid,tabid,TYPE, CONTENT)
/

CREATE OR REPLACE PROCEDURE IWorkflowCenterSettingDetailP as
id_1          integer;
eid_1         integer;
typeids_1     varchar2(4000);
flowids_1     varchar2(4000);
nodeids_1     varchar2(4000);
tabid_1       integer;

content_1    varchar2(100);

srcfrom_1     integer;
type_1        varchar2(100);
i integer;
begin
    DELETE workflowcentersettingdetail ;

    for shareuserid_cursor in (select id,eid, typeids, flowids, nodeids, tabid from hpsetting_wfcenter ) loop
        id_1:=shareuserid_cursor.id;
        eid_1:=shareuserid_cursor.eid;
        typeids_1:= dbms_lob.substr( shareuserid_cursor.typeids, 4000, 1 );
        flowids_1:= dbms_lob.substr( shareuserid_cursor.flowids, 4000, 1 );
        nodeids_1:= dbms_lob.substr( shareuserid_cursor.nodeids, 4000, 1 );
        tabid_1:=shareuserid_cursor.tabid;
        
        srcfrom_1:=id_1;
         
        if length(typeids_1) >0 then
          begin
            i:=instr(typeids_1,',');
            type_1 := 'typeid';
            while i>0 loop
              begin
                content_1:=substr(typeids_1,1,i-1);
                
                 insert into workflowcentersettingdetail
                (

                  eid,
                  tabid,
                  type,
                  content,
                  srcfrom
                 )values(

                  eid_1,
                  tabid_1,
                  type_1,
                  content_1,
                  srcfrom_1
                 );

             typeids_1:=substr(typeids_1,i   +1);
             i:=instr(typeids_1,',');
  
                
                end;
              end loop;
              content_1:=typeids_1;
             
              insert into workflowcentersettingdetail
              (

                eid,
                tabid,
                type,
                content,
                srcfrom
               )values(

                eid_1,
                tabid_1,
                type_1,
                content_1,
                srcfrom_1
               );
            end;
         end if;
         
         if length(flowids_1) >0 then
          begin
            i:=instr(flowids_1,',');
           
            type_1 := 'flowid';
            while i>0 loop
              begin
                content_1:=substr(flowids_1,1,i-1);
                
                 insert into workflowcentersettingdetail
                (

                  eid,
                  tabid,
                  type,
                  content,
                  srcfrom
                 )values(

                  eid_1,
                  tabid_1,
                  type_1,
                  content_1,
                  srcfrom_1
                 );
                  
             flowids_1:=substr(flowids_1,i+1);
             
             i:=instr(flowids_1,',');
            
                
                end;
              end loop;
              content_1:=flowids_1;
             
              insert into workflowcentersettingdetail
              (

                eid,
                tabid,
                type,
                content,
                srcfrom
               )values(

                eid_1,
                tabid_1,
                type_1,
                content_1,
                srcfrom_1
               );
            end;
         end if;
         
         if length(nodeids_1) >0 then
          begin
            i:=instr(nodeids_1,',');
            type_1 := 'nodeid';
            while i>0 loop
              begin
                content_1:=substr(nodeids_1,1,i-1);
                
                 insert into workflowcentersettingdetail
                (

                  eid,
                  tabid,
                  type,
                  content,
                  srcfrom
                 )values(

                  eid_1,
                  tabid_1,
                  type_1,
                  content_1,
                  srcfrom_1
                 );

             nodeids_1:=substr(nodeids_1,i   +1);
             i:=instr(nodeids_1,',');
  
                
                end;
              end loop;
              content_1:=nodeids_1;
             
              insert into workflowcentersettingdetail
              (

                eid,
                tabid,
                type,
                content,
                srcfrom
               )values(

                eid_1,
                tabid_1,
                type_1,
                content_1,
                srcfrom_1
               );
            end;
         end if;
         
         
      end loop;

end;
/
call IWorkflowCenterSettingDetailP()
/