CREATE or REPLACE PROCEDURE VotingShareDetail_Update
(votingid_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
          shareid_1 integer;
          sharetype_2   integer;
          resourceid_3  integer;
          subcompanyid_4    integer;
          departmentid_5    integer;
          roleid_6      integer;
          seclevel_7    integer;
          rolelevel_8   integer;
          foralluser_9  integer;
          userid_10 integer;
          count_11  integer;
  begin
    delete from votingsharedetail where votingid=votingid_1;
  for all_cursor in(select  id,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,rolelevel,foralluser from votingshare where votingid=votingid_1)
        loop
        shareid_1 :=all_cursor.id;
        sharetype_2 :=all_cursor.sharetype;
        resourceid_3 :=all_cursor.resourceid;
        subcompanyid_4 :=all_cursor.subcompanyid;
        departmentid_5 :=all_cursor.departmentid;
        roleid_6 :=all_cursor.roleid;
        seclevel_7 :=all_cursor.seclevel;
        rolelevel_8 :=all_cursor.rolelevel;
        foralluser_9 :=all_cursor.foralluser;
        if sharetype_2=1 then
        for detail_cursor in(select id from HrmResource where id = resourceid_3 and (seclevel >= seclevel_7 or (seclevel is null and seclevel_7=0)))
        loop 
                userid_10 := detail_cursor.id;
          select count(*) into count_11 from votingsharedetail where votingid=votingid_1 and resourceid=userid_10;
          if  count_11=0 then
              insert into votingsharedetail values(votingid_1,userid_10);
                end if;    
        end loop; 
      end if;
      
        if sharetype_2=2 
      then
        FOR detail_cursor in(        
        select id from HrmResource where subcompanyid1 = subcompanyid_4 and (seclevel >= seclevel_7 or (seclevel is null and seclevel_7=0)))
        loop
                userid_10 :=detail_cursor.id;
          select count(*) into count_11 from votingsharedetail where votingid=votingid_1 and resourceid=userid_10;
          if  count_11=0 then
              insert into votingsharedetail values(votingid_1,userid_10);
          end if;
        end  loop;
      end if;
        
        if sharetype_2=3 
      then
        FOR detail_cursor in(        
        select id from HrmResource where departmentid = departmentid_5 and (seclevel >= seclevel_7 or (seclevel is null and seclevel_7=0)))
        loop
          userid_10 :=detail_cursor.id;
                select count(*) into count_11 from votingsharedetail where votingid=votingid_1 and resourceid=userid_10;
          if  count_11=0 then
              insert into votingsharedetail values(votingid_1,userid_10);
          end if;
        end  loop;
      end if;
      
      if sharetype_2=4 
      then
        FOR detail_cursor in(        
        select resourceid from HrmRoleMembers where roleid = roleid_6 and rolelevel >= rolelevel_8 and resourceid<>1)
           loop 
         userid_10 := detail_cursor.resourceid;
          select count(*) into count_11 from votingsharedetail where votingid=votingid_1 and resourceid=userid_10;
          if  count_11=0 then
              insert into votingsharedetail values(votingid_1,userid_10);
          end if;
        end loop;
      end if;
      
      if sharetype_2=5 
      then
        FOR detail_cursor in(select id from HrmResource where (seclevel >= seclevel_7 or (seclevel is null and seclevel_7=0)))
        loop
                   userid_10 := detail_cursor.id;
          select count(*) into count_11 from votingsharedetail where votingid=votingid_1 and resourceid=userid_10;
          if  count_11=0 then
              insert into votingsharedetail values(votingid_1,userid_10);
          end if;
        end loop;
      end if;
        end loop; 
    end;
/

CREATE OR REPLACE PROCEDURE VotingViewerDetail_Update
(votingid_1    integer,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
	        shareid_1 integer;
	        sharetype_1   integer;
	        resourceid_1  integer;
	        subcompanyid_1    integer;
	        departmentid_1    integer;
	        roleid_1      integer;
	        seclevel_1    integer;
	        rolelevel_1   integer;
	        foralluser_1  integer;
	        userid_1 integer;
	        count_1  integer;
	
begin
	delete from votingviewerdetail where votingid=votingid_1;
	for all_cursor in(
    select id,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,rolelevel,foralluser from votingviewer where votingid=votingid_1
    )
    loop
    	shareid_1 := all_cursor.id ;
	sharetype_1 := all_cursor.sharetype ;
	resourceid_1 := all_cursor.resourceid ;
	subcompanyid_1 := all_cursor.subcompanyid ;
	departmentid_1 := all_cursor.departmentid ;
	roleid_1 := all_cursor.roleid ;
	seclevel_1 := all_cursor.seclevel ;
	rolelevel_1 := all_cursor.rolelevel ;
	foralluser_1 := all_cursor.foralluser ;
   
        if sharetype_1=1 then
    	
    		for all_cursor in(				
    		select id from HrmResource where id = resourceid_1 and (seclevel >= seclevel_1 or (seclevel is null and seclevel_1=0)))
		loop
                userid_1 := all_cursor.id ;
    		select count(*) into count_1 from votingviewerdetail where votingid=votingid_1 and resourceid=userid_1;
    		if  count_1=0 then
    	        insert into votingviewerdetail values(votingid_1,userid_1);
		end if;
       
    	end loop;
	end if;
    	    	
        if sharetype_1=2 then
    	
    		for all_cursor in(				
    		select id from HrmResource where subcompanyid1 = subcompanyid_1 and (seclevel >= seclevel_1 or (seclevel is null and seclevel_1=0)))
                loop
		userid_1 := all_cursor.id ;
                select count(*) into count_1 from votingviewerdetail where votingid=votingid_1 and resourceid=userid_1;
    			if  count_1=0 then
    			    insert into votingviewerdetail values(votingid_1,userid_1);
    			end if;    
    		end loop;
      end if;
        
        if sharetype_1=3 then
    	
    		for all_cursor in(			
    		select id from HrmResource where departmentid = departmentid_1 and (seclevel >= seclevel_1 or (seclevel is null and seclevel_1=0)))
    		loop
	        userid_1 := all_cursor.id ;
    		select count(*) into count_1 from votingviewerdetail where votingid=votingid_1 and resourceid=userid_1;
    			if  count_1=0 then
    			    insert into votingviewerdetail values(votingid_1,userid_1);
                        end if;
    			 
    	         end loop;
	end if;	 
    	
    	if sharetype_1=4 then
    	
    		for all_cursor in(				
    		select resourceid from HrmRoleMembers where roleid = roleid_1 and rolelevel >= rolelevel_1)
    		loop
		userid_1 := all_cursor.resourceid ;
    		select count(*) into count_1 from votingviewerdetail where votingid=votingid_1 and resourceid=userid_1;
    		if  count_1=0 then
    	        insert into votingviewerdetail values(votingid_1,userid_1);
    		end if;
		end loop;
        end if;
    	
    	
    	if sharetype_1=5 then
    	        
		for all_cursor in(				
    		select id from HrmResource where (seclevel >= seclevel_1 or (seclevel is null and seclevel_1=0)))
    		loop
		userid_1 := all_cursor.id ;
    		select count(*) into count_1 from votingviewerdetail where votingid=votingid_1 and resourceid=userid_1;
    		if  count_1=0 then
    	        insert into votingviewerdetail values(votingid_1,userid_1);
    		end if;
    		end loop;
         end if;

end loop;
end;

/