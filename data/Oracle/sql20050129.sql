create table Voting(
    id  integer  primary key ,
    subject     varchar2(100),
    detail      varchar2(4000),
    createrid  integer,
    createdate  char(10),
    createtime  char(8),
    approverid  integer,
    approvedate char(10),
    approvetime char(8),
    begindate   char(10),
    begintime   char(8),
    enddate     char(10),
    endtime     char(8),
    isanony     integer,
    docid       integer,
    crmid       integer,
    projid      integer,
    requestid   integer,
    votingcount integer,
    status      integer           /*0,待审批 1,正常 2,结束 3,暂停  4,延期*/
)
/
create sequence Voting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Voting_Trigger
before insert on Voting
for each row
begin
select Voting_id.nextval into :new.id from dual;
end;
/

create table VotingQuestion(
    id  integer  primary key ,
    subject     varchar2(100),
    description varchar2(255),
    votingid    integer,
    ismulti     integer,
    isother     integer,
    questioncount   integer)
/
create sequence VotingQuestion_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger VotingQuestion_Trigger
before insert on VotingQuestion
for each row
begin
select VotingQuestion_id.nextval into :new.id from dual;
end;
/

create table VotingOption(
    id  integer   primary key ,
    votingid    integer,
    questionid  integer,
    description varchar2(255),
    optioncount integer
)
/
create sequence VotingOption_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger VotingOption_Trigger
before insert on VotingOption
for each row
begin
select VotingOption_id.nextval into :new.id from dual;
end;
/


create table VotingResource(
    votingid    integer,
    questionid  integer,
    optionid    integer,
    resourceid      integer,
    operatedate char(10),
    operatetime char(8)
)
/

create table VotingResourceRemark(
    votingid    integer,
    questionid  integer,
    resourceid  integer,
    useranony   integer,
    otherinput   varchar2(255),
    operatedate char(10),
    operatetime char(8)
)
/

create table VotingRemark(
    votingid    integer,
    resourceid  integer,
    useranony   integer,
    remark      varchar2(4000),
    operatedate char(10),
    operatetime char(8)
)
/

create table VotingShare(
    id  integer  primary key ,
    votingid    integer,
    sharetype   integer,   /*1人力资源2分部3部门4角色5所有人*/
    resourceid      integer,
    subcompanyid    integer,
    departmentid    integer,
    roleid          integer,
    seclevel     integer,
    rolelevel   integer,
    foralluser  integer
)
/
create sequence VotingShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger VotingShare_Trigger
before insert on VotingShare
for each row
begin
select VotingShare_id.nextval into :new.id from dual;
end;
/

create table VotingShareDetail(
    votingid    integer,
    resourceid  integer
)
/

create table VotingMaintDetail(
    id  integer  primary key ,
    createrid   integer,
    approverid  integer
)
/
create sequence VotingMaintDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger VotingMaintDetail_Trigger
before insert on VotingMaintDetail
for each row
begin
select VotingMaintDetail_id.nextval into :new.id from dual;
end;
/

CREATE or REPLACE PROCEDURE Voting_SelectAll
(flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
    open thecursor for
    select * from voting order by begindate desc,begintime desc;
end;
/

CREATE or REPLACE PROCEDURE Voting_SelectByStatus
(status_1     integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
    open thecursor for
    select * from voting where status=status_1 order by begindate desc,begintime desc;
end;
/

CREATE or REPLACE PROCEDURE Voting_SelectByID
(id_1     integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
    open thecursor for
    select * from voting where id=id_1;
end;
/

CREATE or REPLACE PROCEDURE Voting_Insert
(subject_1   varchar2,
 detail_2    varchar2,
 createrid_3 integer,
 createdate_4    char,
 createtime_5    char,
 approverid_6    integer,
 approvedate_7   char,
 approvetime_8   char,
 begindate_9     char,
 begintime_10     char,
 enddate_11       char,
 endtime_12       char,
 isanony_13       integer,
 docid_14         integer,
 crmid_15     integer,
 projid_16    integer,
 requestid_17 integer,
 votingcount_18   integer,
 status_19        integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	insert into voting (subject,detail,createrid,createdate,createtime,approverid,approvedate,approvetime,begindate,begintime,enddate,endtime,isanony,docid,crmid,projid,requestid,votingcount,status)
	values (subject_1,detail_2,createrid_3,createdate_4,createtime_5,approverid_6,approvedate_7,approvetime_8,begindate_9,begintime_10,enddate_11,endtime_12,isanony_13,docid_14,crmid_15,projid_16,requestid_17,votingcount_18,status_19);
open thecursor for
select greatest(id) from voting;
end;
/

CREATE or REPLACE PROCEDURE Voting_Update
(id_1    integer,
 subject_2   varchar2,
 detail_3    varchar2,
 createrid_4 integer,
 createdate_5    char,
 createtime_6    char,
 approverid_7    integer,
 approvedate_8   char,
 approvetime_9   char,
 begindate_10     char,
 begintime_11     char,
 enddate_12       char,
 endtime_13       char,
 isanony_14       integer,
 docid_15         integer,
 crmid_16     integer,
 projid_17    integer,
 requestid_18 integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update voting set
	subject=subject_2,
	detail=detail_3,
	createrid=createrid_4,
	createdate=createdate_5,
	createtime=createtime_6,
	approverid =approverid_7,
	approvedate=approvedate_8,
	approvetime=approvetime_9,
	begindate=begindate_10,
	begintime=begintime_11,
	enddate=enddate_12,
	endtime=endtime_13,
	isanony=isanony_14,
	docid=docid_15,
	crmid=crmid_16,
	projid=projid_17,
	requestid=requestid_18
	where id=id_1;
end;
/

CREATE or REPLACE PROCEDURE Voting_Delete
(id_1    integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
	delete from voting where id=id_1;
end;
/

CREATE or REPLACE PROCEDURE Voting_UpdateStatus
(id_1    integer,
status_2    integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update voting set status=status_2 where id=id_1;
end;
/

CREATE or REPLACE PROCEDURE VotingQuestion_SelectByVoting
(votingid_1  integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
	select * from votingquestion where votingid=votingid_1 order by id;
end;
/

CREATE or REPLACE PROCEDURE VotingQuestion_SelectByID
(id_1  integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
select * from votingquestion where id=id_1 order by id;
end;
/

CREATE or REPLACE PROCEDURE VotingQuestion_Insert
(votingid_1  integer,
 subject_2   varchar2,
 description_3   varchar2,
 ismulti_4       integer,
 isother_5       integer,
 questioncount_6 integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	insert into votingquestion (votingid,subject,description,ismulti,isother,questioncount)
	values (votingid_1,subject_2,description_3,ismulti_4,isother_5,questioncount_6);
	open thecursor for
	select greatest(id) from votingquestion;
end;
/

CREATE or REPLACE PROCEDURE VotingQuestion_Update
(id_1    integer,
 votingid_2  integer,
 subject_3   varchar2,
 description_4   varchar2,
 ismulti_5       integer,
 isother_6       integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update votingquestion set
	votingid=votingid_2,
	subject=subject_3,
	description=description_4,
	ismulti=ismulti_5,
	isother=isother_6
	where id=id_1;
end;
/

CREATE or REPLACE PROCEDURE VotingQuestion_Delete
(id_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	delete from votingoption where questionid=id_1;
	delete from votingquestion where id=id_1;
end;
/

CREATE or REPLACE PROCEDURE VotingOption_SelectByQuestion
(questionid_1  integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
    open thecursor for
	select * from votingoption where questionid=questionid_1 order by id;
end;
/

CREATE or REPLACE PROCEDURE VotingOption_SelectByID
(id_1  integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
    open thecursor for
	select * from votingoption where id=id_1 order by id;
end;
/

CREATE or REPLACE PROCEDURE VotingOption_Insert
(votingid_1  integer,
 questionid_2    integer,
 description_3   varchar2,
 optioncount_4   integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	insert into votingoption (votingid,questionid,description,optioncount)
	values (votingid_1,questionid_2,description_3,optioncount_4);
    open thecursor for
    select greatest(id) from votingoption;
end;
/

CREATE or REPLACE PROCEDURE VotingOption_Update
(id_1    integer,
 votingid_2  integer,
 questionid_3    integer,
 description_4   varchar2,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update votingoption set 
	votingid=votingid_2,
	questionid=questionid_3,
	description=description_4
	where id=id_1;
end;
/

CREATE or REPLACE PROCEDURE VotingOption_Delete
(id_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	delete from votingoption where id=id_1;
end;
/
CREATE or REPLACE PROCEDURE VotingShare_SelectByVotingid
(votingid_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
	select * from votingshare where votingid=votingid_1;
end;
/

CREATE or REPLACE PROCEDURE VotingShare_SelectByID
(id_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
	select * from votingshare where id=id_1;
end;
/

CREATE or REPLACE PROCEDURE VotingShare_Insert
(votingid_1    integer,
 sharetype_2     integer,
 resourceid_3      integer,
 subcompanyid_4  integer,
 departmentid_5  integer,
 roleid_6        integer,
 seclevel_7      integer,
 rolelevel_8     integer,
 foralluser_9    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into votingshare (votingid,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,rolelevel,foralluser)
	values (votingid_1,sharetype_2,resourceid_3,subcompanyid_4,departmentid_5,
    roleid_6,seclevel_7,rolelevel_8,foralluser_9);
    open thecursor for
    select greatest(id) from votingshare;
end;
/

CREATE or REPLACE PROCEDURE VotingShare_Delete
(id_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	delete from votingshare where id=id_1;
end;
/

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
    		for detail_cursor in(select id from HrmResource where id = resourceid_3 and seclevel >= seclevel_7)
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
    		select id from HrmResource where subcompanyid1 = subcompanyid_4 and seclevel >= seclevel_7)
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
    		select id from HrmResource where departmentid = departmentid_5 and seclevel >= seclevel_7)
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
    		select resourceid from HrmRoleMembers where roleid = roleid_6 and rolelevel >= rolelevel_8)
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
    		FOR detail_cursor in(select id from HrmResource where seclevel >= seclevel_7)
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

CREATE or REPLACE PROCEDURE VotingResource_SelectByUser
(votingid_1    integer,
 resourceid_2 integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
	select * from votingresource where votingid=votingid_1 and resourceid=resourceid_2;
end;
/

CREATE or REPLACE PROCEDURE VotingResource_Insert
(votingid_1    integer,
 questionid_2    integer,
 optionid_3   integer,
 resourceid_4 integer,
 operatedate_5   char,
 operatetime_6   char,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
	count_1 integer;
    begin
	select count(votingid) into count_1 from votingresource where optionid=optionid_3 and resourceid=resourceid_4;
	if  count_1=0
	then
    	insert into votingresource (votingid,questionid,optionid,resourceid,operatedate,operatetime)
    	values (votingid_1,questionid_2,optionid_3,resourceid_4,operatedate_5,operatetime_6);
	end if;
end;
/

CREATE or REPLACE PROCEDURE VotingResourceRemark_Insert
(votingid_1    integer,
 questionid_2    integer,
 resourceid_3 integer,
 useranony_4     integer,
 otherinput_5    varchar2,
 operatedate_6   char,
 operatetime_7   char,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into votingresourceremark (votingid,questionid,resourceid,useranony,otherinput,operatedate,operatetime)
	values (votingid_1,questionid_2,resourceid_3,useranony_4,otherinput_5,operatedate_6,operatetime_7);
end;
/

CREATE or REPLACE PROCEDURE VotingRemark_Insert
(votingid_1    integer,
 resourceid_2 integer,
 useranony_3     integer,
 remark_4    varchar2,
 operatedate_5   char,
 operatetime_6   char,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into votingremark (votingid,resourceid,useranony,remark,operatedate,operatetime)
	values (votingid_1,resourceid_2,useranony_3,remark_4,operatedate_5,operatetime_6);
end;
/
CREATE or REPLACE PROCEDURE Voting_UpdateCount
(votingid_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update voting set votingcount=votingcount+1 where id=votingid_1;
end ;
/

CREATE or REPLACE PROCEDURE VotingQuestion_UpdateCount
(questionid_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update votingquestion set questioncount=questioncount+1 where id=questionid_1;
end;
/

CREATE or REPLACE PROCEDURE VotingOption_UpdateCount
(optionid_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	update votingoption set optioncount=optioncount+1 where id = optionid_1;
end;
/

CREATE or REPLACE PROCEDURE VotingMaintDetail_Insert
(createrid_1    integer,
 approverid_2    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into votingmaintdetail (createrid,approverid)
	values (createrid_1,approverid_2);
end;
/

CREATE or REPLACE PROCEDURE VotingMaintDetail_Delete
(id_1    integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
	delete from  votingmaintdetail where id=id_1;
end;
/

/*建新权限 调查维护权限*/

insert into SystemRights (id,rightdesc,righttype) values (458,'调查维护权限','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (458,8,'votingMaint','votingMaint') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (458,7,'调查维护权限','调查维护权限') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3149,'调查维护权限','Voting:Maint',458) 
/
insert into SystemRightToGroup (groupid, rightid) values (2,458)
/
insert into systemrightroles(rightid,roleid,rolelevel) values (458,3,2)
/