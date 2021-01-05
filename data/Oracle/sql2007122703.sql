 CREATE or REPLACE PROCEDURE WF_Prj_ShareInfo_Add 
(prjid_1		integer,            
 sharelevel_1		integer,
 userid_1		integer,
 usertype_1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
 count_1 integer;
 count_2 integer;
 begin
select count(*) INTO count_1 from Prj_ProjectInfo where (manager=userid_1 or creater=userid_1) and id=prjid_1;
if count_1=0 then
	
	select count(*) INTO count_2  from Prj_ShareInfo where relateditemid=prjid_1 and sharelevel=sharelevel_1 and userid= userid_1;
	if count_2=0 then
		
		     if usertype_1=0 then
			 
			 insert into Prj_ShareInfo(relateditemid,sharetype,sharelevel,userid) values(prjid_1,1,sharelevel_1,userid_1);
			 end if;
		     if usertype_1=1 then
			
			insert INTO  Prj_ShareInfo(relateditemid,sharetype,sharelevel,crmid) values(prjid_1,9,sharelevel_1,userid_1);
			end if;
		end if;
	end if;
end;
/