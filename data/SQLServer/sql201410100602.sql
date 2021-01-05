delete from LeftMenuInfo where id in(81,495,100,99)
GO
update LeftMenuInfo set defaultIndex=2 where id=24
GO
update LeftMenuInfo set defaultIndex=1 where id=25
GO
update LeftMenuInfo set linkAddress='/CRM/data/MineCustomerTabFrame.jsp' where id=25
GO
