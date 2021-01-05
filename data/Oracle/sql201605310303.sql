create or replace procedure initmapexpand   
as
tmpmodeid integer;
tmpexcount integer;
CURSOR modeCursor IS select id from modeinfo where isdelete=0;
begin
     open modeCursor;
     LOOP
       FETCH modeCursor into tmpmodeid;
       EXIT WHEN modeCursor%NOTFOUND;
    		 select count(*) into tmpexcount from mode_pageexpand where modeid=tmpmodeid and issystemflag='110';
         if tmpexcount=0 then
            insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable)
				           select tmpmodeid,t.expendname,t.showtype,t.opentype,t.hreftype,t.hrefid,t.hreftarget,t.isshow,t.showorder,t.issystem,t.issystemflag,t.expenddesc,t.isbatch,t.defaultenable from  mode_pageexpandtemplate t where t.issystemflag='110';
         end if;
         
     end LOOP;  
     CLOSE modeCursor;
end;
/
begin
 initmapexpand();
end;
/
drop procedure initmapexpand
/