delete from workflow_fieldtype
where id = 9
GO
insert into workflow_fieldtype
  (ID, TYPENAME, NAMELABEL, CLASSNAME, IFDETAILUSE, ORDERID, STATUS)
values
  (9, 'λ��', 22981, 'weaver.workflow.field.LocationElement', 0, 32, 1)
GO