create view PrjFieldAllview 
as 
 (select t1.prjtype,'1' as fieldtype, '1_'||t1.id as pkid,t1.id,t1.isopen,t1.ismand,t1.isused,t1.groupid,t1.issystem,t1.allowhide,t1.fieldname,t1.fieldlabel,t1.fielddbtype,t1.fieldhtmltype,t1.type,t1.dsporder,t1.textheight,t1.imgwidth,t1.imgheight,t1.childfieldid,t1.viewtype,t1.fromuser,t1.qfws from prjDefineField t1 where  t1.viewtype=0 
union 
select t1.scopeid as prjtype,'2' as fieldtype,'2_'||t2.id as pkid,t2.id,t1.isuse as isopen,t1.ismand,t1.prj_isopen as isused,t1.groupid,null as issystem,null as allowhide,t2.fieldname,t1.prj_fieldlabel as fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,t1.fieldorder as dsporder,null as textheight,null as imgwidth,null as imgheight,null as childfieldid,0 as viewtype,null as fromuser,t2.qfws from cus_formfield t1, cus_formdict t2 where t1.scope='ProjCustomField'  and t1.fieldid=t2.id
)
/