alter table workflow_bill add invalid integer
/
update workflow_bill set invalid=1 where id in(50,66,67,68,6,22,23,29,161,162)
/