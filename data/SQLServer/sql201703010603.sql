CREATE TABLE [social_ImGroup](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NULL,
	[createUserId] [varchar](100) NULL
) ON [PRIMARY]
GO
CREATE TABLE [social_ImGroup_Rel](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[rel_id] [int],
	[userId] [varchar](100) NULL,
	[groupId] [varchar](100) NULL,
	[groupName] [varchar](1000) NULL,
	[groupRowID] [int],
	[isOpenFire] [int]
) ON [PRIMARY]
GO
insert into social_ImGroup values('我的群聊','ALL')
GO
delete from social_ImGroup_Rel
GO
insert into social_ImGroup_rel (rel_id,userid,groupid,groupName,isopenfire)
select (select id from social_ImGroup where name = '我的群聊' and createUserId = 'ALL') as rel_id,a.userid,a.group_id ,b.targetname,a.isopenfire from
(select userid,group_id,isopenfire from mobile_rongGroup group by userid,group_id,isopenfire) a,(select targetid,targetname from social_IMConversation group by targetid,targetname) b
where a.group_id = b.targetid
GO