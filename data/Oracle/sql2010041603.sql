ALTER table WorkPlan ADD test varchar2(4000)
/
update WorkPlan set test = resourceid
/
ALTER table  WorkPlan drop column resourceid
/
ALTER TABLE WorkPlan RENAME COLUMN test TO resourceid
/
