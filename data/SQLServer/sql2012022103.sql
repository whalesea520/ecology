delete LeftMenuInfo where id=97
GO
update LeftMenuInfo set parentId=140 where parentId=97
GO
update WorkPlanType set workPlanTypeColor=17 where workPlanTypeID=0
GO
delete LeftMenuInfo  where id=59
GO

update  LeftMenuInfo set labelId=27910 where id=240
GO
update  LeftMenuInfo set labelId=20190 where id=242
GO
update  LeftMenuInfo set labelId=27911 where id=209
GO

update LeftMenuInfo set defaultIndex=1 where id=60
GO
update LeftMenuInfo set defaultIndex=2 where id=240
GO
update LeftMenuInfo set defaultIndex=3 where id=209
GO
update LeftMenuInfo set defaultIndex=4 where id=242
GO
update LeftMenuInfo set defaultIndex=5 where id=61
GO

update leftmenuconfig set viewindex=1 where infoId=60
GO
update leftmenuconfig set viewindex=2 where infoId=240
GO
update leftmenuconfig set viewindex=3 where infoId=209
GO
update leftmenuconfig set viewindex=4 where infoId=242
GO
update leftmenuconfig set viewindex=5 where infoId=61
GO
