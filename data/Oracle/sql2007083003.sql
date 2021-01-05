update hrmsalarypaydetail set departmentid=(select b.departmentid from hrmresource b where b.id=hrmid) where departmentid is null
/