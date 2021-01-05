update mode_customdspfield
   set isorder = 0, ordertype = 0, ordernum = 0
 where exists
 (select 1
          from modeformextend a, mode_customsearch b, workflow_billfield d
         where a.formid = b.formid
           and a.formid = d.billid
           and lower(a.vprimarykey) = lower(d.fieldname)
           and mode_customdspfield.customid = b.id
           and mode_customdspfield.fieldid = d.id
           and a.isvirtualform = '1')
GO