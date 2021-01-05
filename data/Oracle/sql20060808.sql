/*资产流程新增:资产领用*/
   CREATE or REPLACE  PROCEDURE CptUseLogUse_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	number,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar,
	 remark_11 	varchar2,
	 useaddress_12 varchar2,
	 sptcount_1	char,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)

AS 
 num_1 number;
 num_count integer;
begin
/*判断数量是否足够(对于非单独核算的资产*/
if sptcount_1 <> '1' then
    select count(capitalnum) INTO num_count from CptCapital where id = capitalid_1;
	if(num_count > 0) then

    select capitalnum INTO num_1 from CptCapital where id = capitalid_1;
    if num_1 < usecount_5 then
      open thecursor for
	  select -1 from dual;
	  return;
   else 
   	num_1 := num_1-usecount_5;
   end if;
   end if;
end if;

INSERT INTO CptUseLog 
	 ( capitalid,
	 usedate,
	 usedeptid,
	 useresourceid,
	 usecount,
	 maintaincompany,
	 fee,
	 usestatus,
	 remark,
	 useaddress,
	 olddeptid) 
 
VALUES 
	( capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 maintaincompany_8,
	 fee_9,
	 '2',
	 remark_11,
	 useaddress_12,
              0);
/*单独核算的资产*/
if sptcount_1 = '1' then
	Update CptCapital
	Set 
	departmentid = usedeptid_3,
	resourceid   = useresourceid_4,
	stateid = usestatus_10
	where id = capitalid_1;
	insert INTO HrmCapitalUse (capitalid,hrmid,cptnum)
	values(capitalid_1,useresourceid_4,1);
/*非单独核算的资产*/
else 
	Update CptCapital
	Set
	capitalnum = num_1
	where id = capitalid_1;
	insert INTO HrmCapitalUse (capitalid,hrmid,cptnum)
	values(capitalid_1,useresourceid_4,usecount_5);
	open thecursor for
	select 1 from dual;
	end if;
end;
/


insert into SystemRightToGroup(groupid,rightid) values(9,161)
/
insert into SystemRightToGroup(groupid,rightid) values(9,162)
/