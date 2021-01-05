create or replace procedure FormLabelMaintenance as
  indexidn    int;
  labelnamen  varchar2(2000);
  languageidn int;
begin
  FOR tmp_cursor IN (select hl.*
                       from (select h.indexid, count(h.languageid) cl
                               from workflow_bill b, htmllabelinfo h
                              where b.namelabel = h.indexid
                              and b.id<0
                              group by h.indexid
                             having count(h.languageid) < 3) r,
                            htmllabelinfo hl
                      where r.indexid = hl.indexid
                        and languageid = 7) loop
    indexidn    := tmp_cursor.indexid;
    labelnamen  := tmp_cursor.labelname;
    languageidn := tmp_cursor.languageid;
    delete from htmllabelinfo where indexid = indexidn;
    insert into htmllabelinfo
    values
      (indexidn, labelnamen, 7);
    insert into htmllabelinfo
    values
      (indexidn, labelnamen, 8);
    insert into htmllabelinfo
    values
      (indexidn, labelnamen, 9);
    commit;
  END LOOP;
end;
/
call FormLabelMaintenance()
/
