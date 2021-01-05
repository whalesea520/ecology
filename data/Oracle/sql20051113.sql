declare
	secid_1 integer;
	secMax integer;
	execCount integer;
	recordCount integer;
	i integer;

begin
select   max(id) into secMax  from docseccategory;
execCount := secMax/5000+1;
i := 0;

while i<execCount
loop  
	for sec_cursor in(    
	select id from docseccategory where id>i*5000+1 and id <(i+1)*5000+1 order by id desc)
	loop 
		secid_1 := sec_cursor.id;
		select  count(id) into recordCount from secCreaterDocPope where secid=secid_1 ;
		if recordCount=0 
		then
			insert into secCreaterDocPope (secid,PCreater,PCreaterManager,PCreaterJmanager,PCreaterDownOwner,PCreaterSubComp,PCreaterDepart,PCreaterDownOwnerLS,PCreaterSubCompLS,PCreaterDepartLS,PCreaterW,PCreaterManagerW,PCreaterJmanagerW) values (secid_1,3,1,0,0,0,0,0,0,0,3,1,0);
		end if;   

    end loop;
	i:= i+1;   
end loop;
end;
/
