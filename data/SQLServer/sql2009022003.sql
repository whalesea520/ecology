alter table leftmenuinfo add module varchar(30)
GO

alter table mainmenuinfo add module varchar(30)
GO

/*左侧*/
/*信息中心*/
update leftmenuinfo set module='info' where id=111
GO

/*我的协作*/
update leftmenuinfo set module='cwork' where id=80
GO

/*我的流程*/
update leftmenuinfo set module='workflow' where id=1
GO

/*我的知识*/
update leftmenuinfo set module='doc' where id=2
GO

/*我的客户*/
update leftmenuinfo set module='crm' where id=3
GO

/* 我的人事*/
update leftmenuinfo set module='hrm' where id=5
GO

/*我的项目*/
update leftmenuinfo set module='proj' where id=4
GO

/*我的资产*/
update leftmenuinfo set module='cpt' where id=7
GO

/*我的会议*/
update leftmenuinfo set module='meeting' where id=6
GO

/*我的通信*/
update leftmenuinfo set module='message' where id=107
GO

/* 我的报表*/
update leftmenuinfo set module='report' where id=110
GO

/*我的日程*/
update leftmenuinfo set module='scheme' where id=140
GO

/*车辆管理*/
update leftmenuinfo set module='car' where id=144
GO

/*我的相册*/
update leftmenuinfo set module='photo' where id=199
GO

/*顶部*/
/*工作流程*/
update mainmenuinfo set module='workflow' where id=4
GO

/*知识管理*/
update mainmenuinfo set module='doc' where id=2
GO

/*人力资源*/
update mainmenuinfo set module='hrm' where id=3
GO

/*客户管理*/
update mainmenuinfo set module='crm' where id=5
GO

/*项目管理*/
update mainmenuinfo set module='proj' where id=6
GO

/*财务管理*/
update mainmenuinfo set module='finance' where id=7
GO

/*资产管理*/
update mainmenuinfo set module='cpt' where id=8
GO

/*门户管理*/
update mainmenuinfo set module='portal' where id=624
GO

/*设置中心*/
update mainmenuinfo set module='setting' where id=11
GO
