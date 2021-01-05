create or replace procedure mode_pageexpand_historydata2
as
icount integer;
cursor m_cursor is
      select * from modeinfo;
      m_row modeinfo%rowtype;
begin
  for m_row in m_cursor loop
        select count(*) into icount from mode_pageexpand where modeid=m_row.id and expendname='ÅúÁ¿¹²Ïí';
        if icount<1 then
          insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable)
               select m_row.id,mp.expendname,mp.showtype,mp.opentype,mp.hreftype,mp.hrefid,mp.hreftarget,mp.isshow,mp.showorder,mp.issystem,mp.issystemflag,mp.expenddesc,mp.isbatch,mp.defaultenable
               from mode_pageexpandtemplate mp where mp.issystemflag=104;
        end if;                    
  end loop;
end;
/
begin
    mode_pageexpand_historydata2;
end;
/
