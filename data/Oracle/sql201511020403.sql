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
    select max(id) from votingshare;
end;
/