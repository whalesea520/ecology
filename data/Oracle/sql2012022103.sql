delete LeftMenuInfo where id=97
/
update LeftMenuInfo set parentId=140 where parentId=97
/
update WorkPlanType set workPlanTypeColor=17 where workPlanTypeID=0
/
delete LeftMenuInfo  where id=59
/

update  LeftMenuInfo set labelId=27910 where id=240
/
update  LeftMenuInfo set labelId=20190 where id=242
/
update  LeftMenuInfo set labelId=27911 where id=209
/

update LeftMenuInfo set defaultIndex=1 where id=60
/
update LeftMenuInfo set defaultIndex=2 where id=240
/
update LeftMenuInfo set defaultIndex=3 where id=209
/
update LeftMenuInfo set defaultIndex=4 where id=242
/
update LeftMenuInfo set defaultIndex=5 where id=61
/

update leftmenuconfig set viewindex=1 where infoId=60
/
update leftmenuconfig set viewindex=2 where infoId=240
/
update leftmenuconfig set viewindex=3 where infoId=209
/
update leftmenuconfig set viewindex=4 where infoId=242
/
update leftmenuconfig set viewindex=5 where infoId=61
/
