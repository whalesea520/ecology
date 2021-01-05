CREATE TABLE VotingViewer (
	id integer  NOT NULL PRIMARY KEY,
	votingid integer NULL,
	sharetype integer NULL,
	resourceid integer NULL,
	subcompanyid integer NULL,
	departmentid integer NULL,
	roleid integer NULL,
	seclevel integer NULL,
	rolelevel integer NULL,
	foralluser integer NULL
)
/
create sequence  VotingViewer_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger VotingViewer_trigger		
	before insert on VotingViewer
	for each row
	begin
	select VotingViewer_id.nextval into :new.id from dual;
	end ;
	/


CREATE TABLE VotingViewerDetail (
	votingid integer NULL,
	resourceid integer NULL
)
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
    		select id from HrmResource where id = resourceid_1 and seclevel >= seclevel_1)
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
    		select id from HrmResource where subcompanyid1 = subcompanyid_1 and seclevel >= seclevel_1)
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
    		select id from HrmResource where departmentid = departmentid_1 and seclevel >= seclevel_1)
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
    		select id from HrmResource where seclevel >= seclevel_1)
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
