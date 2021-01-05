update workflow_modeview
   set isview = '1', isedit = '1'
 where fieldid in (select distinct a.fieldid
                     from workflow_modeview a, workflow_billfield b
                    where a.fieldid = b.id
                      and b.fieldhtmltype = 9)
and isview = '1' 
/

update workflow_nodeform
   set isview = '1', isedit = '1'
 where fieldid in (
                   
                   SELECT distinct a.fieldid
                     from workflow_nodeform a, workflow_billfield b
                    where a.fieldid = b.id
                      and b.fieldhtmltype = 9)
and isview = '1' 
/

update workflow_modeview
   set isview = '1', isedit = '1'
 where fieldid in
       (
        
        select distinct a.fieldid
        
          from workflow_modeview a, workflow_formfield b, workflow_formdict c
         where a.fieldid = b.fieldid
           and b.fieldid = c.id
           and c.fieldhtmltype = 9)
and isview = '1' 


/
update workflow_nodeform
   set isview = '1', isedit = '1'
 where fieldid in (SELECT a.fieldid
                     from workflow_nodeform  a,
                          workflow_formfield b,
                          workflow_formdict  c
                    where a.fieldid = b.fieldid
                      and b.fieldid = c.id
                      and c.fieldhtmltype = 9)
and isview = '1' 
/