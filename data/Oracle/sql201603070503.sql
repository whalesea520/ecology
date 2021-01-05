delete from hpelementsetting where name='searchid' and eid in (select id from hpElement where ebaseid='FormModeCustomSearch')
/
create procedure hpe_searchid   
as
maxid integer;
hpid integer;
CURSOR hpidCursor IS select id from hpElement where ebaseid='FormModeCustomSearch';
begin
     open hpidCursor;
     LOOP
       FETCH hpidCursor into hpid;
       EXIT WHEN hpidCursor%NOTFOUND;
    		 select count(*) into maxid from hpElementSetting;
         insert into hpElementSetting(id,eid,name)values(maxid,hpid,'searchid');
     end LOOP;  
     CLOSE hpidCursor;
end;
/
begin
 hpe_searchid();
end;
/
drop procedure hpe_searchid
/

insert into formmodeelement(eid,searchtitle,disorder,isshowunread) 
	select id,title,0,0 from hpElement where ebaseid='FormModeCustomSearch'
/
update hpelementsetting set value=(select id from formmodeelement f where hpelementsetting.eid=f.eid and rownum=1 ) where name='searchid'
/
update formmodeelement set reportid=(select value from hpelementsetting where formmodeelement.eid=hpelementsetting.eid and name='reportId' and value is not null and rownum=1)
/
update formmodeelement set fields=(select value from hpelementsetting where formmodeelement.eid=hpelementsetting.eid and name='fields' and value is not null and rownum=1)
/
update formmodeelement set fieldsWidth=(select value from hpelementsetting where formmodeelement.eid=hpelementsetting.eid and name='fieldsWidth' and value is not null and rownum=1)
/