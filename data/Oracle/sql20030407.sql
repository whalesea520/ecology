alter table license add software varchar(20) default 'ALL'
/

update license set software='ALL'
/

update workflow_browserurl set columname = 'lastname' where id = '1'
/

update workflow_browserurl set columname = 'lastname' where id = '17'
/

insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('公司点滴',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('公司制度',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('工作流程',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('新闻',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('公司文件',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('法律文件',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('会议资料',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('资源支持',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('员工沙龙',0,2)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('部门管理',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('企业监管',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('系统使用',0,1)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('公司知识库',0,3)
/
insert into DocMainCategory (categoryname,categoryiconid,categoryorder) values ('娱乐社区',0,3)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (1,'成长足迹',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (1,'大事记',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (1,'规划蓝图',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (2,'企业理念',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (2,'组织结构',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (3,'管理制度',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (4,'部门职能',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (4,'岗位职能',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (5,'工作流程',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (6,'外部新闻',0,'1','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',31)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (7,'公司新闻',0,'1','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',31)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (8,'公司发文',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (9,'公司收文',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (10,'采购合同',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (10,'销售合同',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (11,'其他',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (12,'会议资料',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (13,'办公助手',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (14,'信息参考',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (15,'法律法规',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (16,'公司培训',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (17,'金点子仓库',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (18,'生活指南',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (19,'友情提示',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (20,'问讯与答疑',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (21,'建议与意见',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (22,'新员工指南',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (23,'业务管理',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (24,'战略规划',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (25,'年度经营目标',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (26,'运营管理',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (27,'系统使用规范',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (28,'系统功能介绍',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (29,'行业动态',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (30,'最新技术',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (31,'行业信息',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (32,'休闲时光',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSecCategory (subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid) values (33,'谈天说地',0,'0','1','1','0',10,0,10,0,10,0,'0',0,'0',0,'0','1',2,' ','',' ','','1','',' ','',' ','',' ','',0)
/
insert into DocSubCategory (maincategoryid,categoryname) values (1,'历史发展')
/
insert into DocSubCategory (maincategoryid,categoryname) values (1,'企业文化')
/
insert into DocSubCategory (maincategoryid,categoryname) values (2,'管理制度')
/
insert into DocSubCategory (maincategoryid,categoryname) values (2,'工作职能')
/
insert into DocSubCategory (maincategoryid,categoryname) values (3,'工作流程')
/
insert into DocSubCategory (maincategoryid,categoryname) values (4,'外部新闻')
/
insert into DocSubCategory (maincategoryid,categoryname) values (4,'公司新闻')
/
insert into DocSubCategory (maincategoryid,categoryname) values (5,'公司发文')
/
insert into DocSubCategory (maincategoryid,categoryname) values (5,'公司收文')
/
insert into DocSubCategory (maincategoryid,categoryname) values (6,'合同协议')
/
insert into DocSubCategory (maincategoryid,categoryname) values (6,'其他')
/
insert into DocSubCategory (maincategoryid,categoryname) values (7,'会议资料')
/
insert into DocSubCategory (maincategoryid,categoryname) values (8,'办公助手')
/
insert into DocSubCategory (maincategoryid,categoryname) values (8,'信息参考')
/
insert into DocSubCategory (maincategoryid,categoryname) values (8,'法律法规')
/
insert into DocSubCategory (maincategoryid,categoryname) values (8,'公司培训')
/
insert into DocSubCategory (maincategoryid,categoryname) values (9,'金点子仓库')
/
insert into DocSubCategory (maincategoryid,categoryname) values (9,'生活指南')
/
insert into DocSubCategory (maincategoryid,categoryname) values (9,'友情提示')
/
insert into DocSubCategory (maincategoryid,categoryname) values (9,'问讯与答疑')
/
insert into DocSubCategory (maincategoryid,categoryname) values (9,'建议与意见')
/
insert into DocSubCategory (maincategoryid,categoryname) values (9,'新员工指南')
/
insert into DocSubCategory (maincategoryid,categoryname) values (10,'业务管理')
/
insert into DocSubCategory (maincategoryid,categoryname) values (10,'战略规划')
/
insert into DocSubCategory (maincategoryid,categoryname) values (11,'年度经营目标')
/
insert into DocSubCategory (maincategoryid,categoryname) values (11,'运营管理')
/
insert into DocSubCategory (maincategoryid,categoryname) values (12,'系统使用规范')
/
insert into DocSubCategory (maincategoryid,categoryname) values (12,'系统功能介绍')
/
insert into DocSubCategory (maincategoryid,categoryname) values (13,'行业动态')
/
insert into DocSubCategory (maincategoryid,categoryname) values (13,'最新技术')
/
insert into DocSubCategory (maincategoryid,categoryname) values (13,'行业信息')
/
insert into DocSubCategory (maincategoryid,categoryname) values (14,'休闲时光')
/
insert into DocSubCategory (maincategoryid,categoryname) values (14,'谈天说地')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (1,1,1,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (1,1,1,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (2,1,1,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (2,1,1,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (3,1,1,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (4,1,2,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (4,1,2,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (5,1,2,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (5,1,2,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (7,2,4,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (7,2,4,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (8,2,4,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (8,2,4,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (9,3,5,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (9,3,5,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (11,4,7,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (11,4,7,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (14,6,10,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (14,6,10,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (15,6,10,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (15,6,10,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (16,6,11,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (16,6,11,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (17,7,12,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (17,7,12,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (18,8,13,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (18,8,13,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (19,8,14,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (19,8,14,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (22,9,17,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (22,9,17,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (23,9,18,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (23,9,18,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (24,9,19,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (24,9,19,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (27,9,22,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (27,9,22,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (28,10,23,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (28,10,23,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (29,10,24,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (29,10,24,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (32,12,27,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (32,12,27,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (34,13,29,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (34,13,29,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (35,13,30,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (35,13,30,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (37,14,32,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (37,14,32,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (38,14,33,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (38,14,33,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (3,1,1,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (6,2,3,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (6,2,3,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (10,4,6,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (10,4,6,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (12,5,8,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (12,5,8,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (13,5,9,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (13,5,9,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (20,8,15,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (20,8,15,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (21,8,16,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (21,8,16,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (25,9,20,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (25,9,20,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (26,9,21,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (26,9,21,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (30,11,25,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (30,11,25,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (31,11,26,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (31,11,26,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (33,12,28,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (33,12,28,2,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (36,13,31,1,'0')
/
insert into DocUserCategory (secid,mainid,subid,userid,usertype) values (36,13,31,2,'0')
/

/* 2003 年 3 月 28日 为人力资源工资模块 */

drop table HrmSalaryItem
/
drop sequence HrmSalaryItem_id
/

/*工资项目表*/
CREATE TABLE HrmSalaryItem  (           
id	integer  NOT NULL  ,
itemname	varchar2(50) ,               /*工资项名称*/
itemcode  varchar2(50) ,                 /*工资项代码*/
itemtype  char(1),                     
/* 项目类型 
1:工资
2:福利
3:税收
4:计算
*/
personwelfarerate   integer ,               /*福利个人费率*/
companywelfarerate    integer ,             /*福利公司费率*/
taxrelateitem          integer ,            /*税收基准项目*/
amountecp             varchar2(200),     /*计算公式*/
feetype             integer ,               /*费用类型*/
isshow	char(1) default '1',            /*是否显示*/
showorder	integer default 1 ,             /*显示顺序*/
ishistory  Char(1) default '0'            /*是否记录历史变动*/
)
/
create sequence HrmSalaryItem_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryItem_Trigger
before insert on HrmSalaryItem
for each row
begin
select HrmSalaryItem_id.nextval into :new.id from dual;
end;
/
ALTER TABLE HrmSalaryItem  ADD 
	CONSTRAINT PK_HrmSalaryItem_id PRIMARY KEY 
	(
		id
	)
/


drop table HrmSalaryRank
/
drop sequence HrmSalaryRank_id
/

/*工资项目等级表(工资,福利等级)*/
create table  HrmSalaryRank (
id	int  NOT NULL ,
itemid  integer ,                           /*工资项目id*/
jobid   integer ,                           /*岗位id*/
joblevelfrom  integer ,                     /*级别从*/
joblevelto    integer ,                     /*级别到*/
amount  number(10,2)                   /*总金额*/
)
/
create sequence HrmSalaryRank_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryRank_Trigger
before insert on HrmSalaryRank
for each row
begin
select HrmSalaryRank_id.nextval into :new.id from dual;
end;
/





drop table HrmSalaryRate
/

/*税收基准表*/
create table HrmSalaryTaxbench (
id	integer  NOT NULL ,
itemid    integer,                          /*工资项目id*/
cityid    integer,                          /*城市id*/
taxbenchmark  integer                       /*税收基准*/
)
/
create sequence HrmSalaryTaxbench_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryTaxbench_Trigger
before insert on HrmSalaryTaxbench
for each row
begin
select HrmSalaryTaxbench_id.nextval into :new.id from dual;
end;
/


ALTER TABLE HrmSalaryTaxbench  ADD 
	CONSTRAINT PK_HrmSalaryTaxbench_id PRIMARY KEY 
	(
		id
	)
/



/*税收税率级距表*/
create table HrmSalaryTaxrate (
id	integer  NOT NULL ,
benchid  integer ,                          /*基准id*/
ranknum  integer ,                          /*级数*/
ranklow  integer ,                          /*含税级距 从*/
rankhigh integer ,                          /*含税级距 到*/
taxrate  integer                            /*税率*/
)
/
create sequence HrmSalaryTaxrate_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryTaxrate_Trigger
before insert on HrmSalaryTaxrate
for each row
begin
select HrmSalaryTaxrate_id.nextval into :new.id from dual;
end;
/


ALTER TABLE HrmSalaryTaxrate  ADD 
	CONSTRAINT PK_HrmSalaryTaxrate_id PRIMARY KEY 
	(
		id
	)
/



create table HrmSalaryChange (
id	integer  NOT NULL  ,
multresourceid  varchar2(255) ,                  /*被调整人*/
itemid          integer ,                           /*调整项目*/               
changedate  char(10) ,                          /*调整日期*/
changetype  char(1) ,                           /*调整类型*/
salary      number(10,2) ,                     /*调整金额*/
changeresion  varchar2(4000),                             /*调整原因*/
changeuser    integer                               /*调整人*/
)
/
create sequence HrmSalaryChange_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryChange_Trigger
before insert on HrmSalaryChange
for each row
begin
select HrmSalaryChange_id.nextval into :new.id from dual;
end;
/


ALTER TABLE HrmSalaryChange  ADD 
	CONSTRAINT PK_HrmSalaryChange_id PRIMARY KEY 
	(
		id
	)
/


create  INDEX HrmSalaryChange_multresid_in on HrmSalaryChange(multresourceid)
/

drop table HrmSalaryResult
/

create table HrmSalaryPay (
id	integer NOT NULL ,
paydate 	varchar2(7),
isvalidate integer default 0
)
/
create sequence HrmSalaryPay_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryPay_Trigger
before insert on HrmSalaryPay
for each row
begin
select HrmSalaryPay_id.nextval into :new.id from dual;
end;
/


ALTER TABLE HrmSalaryPay  ADD 
	CONSTRAINT PK_HrmSalaryPay_id PRIMARY KEY 
	(
		id
	)
/

create table HrmSalaryPaydetail (
payid   integer ,
itemid	varchar2(6),
hrmid	integer,
salary	number(12,2) default 0
)
/

create  INDEX HrmSalaryPaydetail_payid_in on HrmSalaryPaydetail(payid)
/
create  INDEX HrmSalaryPaydetail_hrmid_in on HrmSalaryPaydetail(hrmid)
/

 CREATE or REPLACE PROCEDURE HrmSalaryItem_Insert
	(itemname_1 	varchar2,
	 itemcode_2 	varchar2,
	 itemtype_3 	char,
	 personwelfarerate_4 	integer,
	 companywelfarerate_5 	integer,
	 taxrelateitem_6 	integer,
	 amountecp_7 	varchar2,
	 feetype_8 	integer,
	 isshow_9 	char,
	 showorder_10 	integer,
	 ishistory_11 	char,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO HrmSalaryItem 
	 (itemname,
	 itemcode,
	 itemtype,
	 personwelfarerate,
	 companywelfarerate,
	 taxrelateitem,
	 amountecp,
	 feetype,
	 isshow,
	 showorder,
	 ishistory) 
 
VALUES 
	( itemname_1,
	 itemcode_2,
	 itemtype_3,
	 personwelfarerate_4,
	 companywelfarerate_5,
	 taxrelateitem_6,
	 amountecp_7,
	 feetype_8,
	 isshow_9,
	 showorder_10,
	 ishistory_11);
 open thecursor for
select max(id) from HrmSalaryItem;
end;
/




CREATE or REPLACE PROCEDURE HrmSalaryItem_Update
	(id_1 	integer,
	 itemname_2 	varchar2,
	 itemcode_3 	varchar2,
	 itemtype_4 	char,
	 personwelfarerate_5 	integer,
	 companywelfarerate_6 	integer,
	 taxrelateitem_7 	integer,
	 amountecp_8 	varchar2,
	 feetype_9 	integer,
	 isshow_10 	char,
	 showorder_11 	integer,
	 ishistory_12 	char,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
 olditemtype_1 char(1); 
 benchid_1 integer;
begin

select  itemtype INTO olditemtype_1  from HrmSalaryItem where id = id_1 ;
UPDATE HrmSalaryItem 
SET  itemname	 = itemname_2,
	 itemcode	 = itemcode_3,
	 itemtype	 = itemtype_4,
	 personwelfarerate	 = personwelfarerate_5,
	 companywelfarerate	 = companywelfarerate_6,
	 taxrelateitem	 = taxrelateitem_7,
	 amountecp	 = amountecp_8,
	 feetype	 = feetype_9,
	 isshow	 = isshow_10,
	 showorder	 = showorder_11,
	 ishistory	 = ishistory_12 

WHERE 
	( id	 = id_1);

if olditemtype_1 = '1' or olditemtype_1 = '2' then
    delete from HrmSalaryRank where itemid = id_1;
else if olditemtype_1 = '3' then

    for benchid_cursor IN (select id from HrmSalaryTaxbench where itemid = id_1)
	loop
	benchid_1 := benchid_cursor.id;
        delete from HrmSalaryTaxrate where benchid = benchid_1;
        delete from HrmSalaryTaxbench where id = benchid_1;
	end loop;
	end if;
end if;
end;
/


CREATE or REPLACE PROCEDURE HrmSalaryItem_Delete
	(id_1 	integer ,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
 olditemtype_1 char(1); 
 benchid_1 integer;
 begin
select  itemtype INTO olditemtype_1  from HrmSalaryItem where id = id_1; 

DELETE HrmSalaryItem WHERE ( id	 = id_1);

if olditemtype_1 = '1' or olditemtype_1 = '2' then
    delete from HrmSalaryRank where itemid = id_1;
else if olditemtype_1 = '3' then

    for benchid_cursor IN (select id from HrmSalaryTaxbench where itemid = id_1 )
    loop
		benchid_1 := benchid_cursor.id;
        delete from HrmSalaryTaxrate where benchid = benchid_1;
        delete from HrmSalaryTaxbench where id = benchid_1;
	end loop;
    end if;
end if;
end ;
/





CREATE or REPLACE PROCEDURE HrmSalaryRank_Insert
	(itemid_1 	integer,
	 jobid_2 	integer,
	 joblevelfrom_3 	integer,
	 joblevelto_4 	integer,
	 amount_5 	number,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO HrmSalaryRank 
	 ( itemid,
	 jobid,
	 joblevelfrom,
	 joblevelto,
	 amount) 
 
VALUES 
	( itemid_1,
	 jobid_2,
	 joblevelfrom_3,
	 joblevelto_4,
	 amount_5);
end;
/


CREATE or REPLACE PROCEDURE HrmSalaryTaxbench_Insert
	(itemid_1 	integer,
	 cityid_2 	integer,
	 taxbenchmark_3 	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO HrmSalaryTaxbench 
	 ( itemid,
	 cityid,
	 taxbenchmark) 
 
VALUES 
	( itemid_1,
	 cityid_2,
	 taxbenchmark_3);
 open thecursor for
select max(id) from HrmSalaryTaxbench;
end;
/


CREATE or REPLACE PROCEDURE HrmSalaryTaxrate_Insert
	(benchid_1 	integer,
	 ranknum_2 	integer,
	 ranklow_3 	integer,
	 rankhigh_4 	integer,
	 taxrate_5 	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO HrmSalaryTaxrate 
	 ( benchid,
	 ranknum,
	 ranklow,
	 rankhigh,
	 taxrate) 
 
VALUES 
	( benchid_1,
	 ranknum_2,
	 ranklow_3,
	 rankhigh_4,
	 taxrate_5);
end;
/



CREATE or REPLACE PROCEDURE HrmSalaryPay_Insert
	(paydate_1 	varchar2,
	 isvalidate_2 	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO HrmSalaryPay 
	 ( paydate,
	 isvalidate) 
 
VALUES 
	( paydate_1,
	 isvalidate_2);
 open thecursor for
select max(id) from HrmSalaryPay;
end;
/



CREATE or REPLACE PROCEDURE HrmSalaryPay_Update
	(id_1 	integer,
	 isvalidate_2 	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE HrmSalaryPay 

SET  isvalidate	 = isvalidate_2 

WHERE 
	( id	 = id_1);
end;
/



CREATE or REPLACE PROCEDURE HrmSalaryPaydetail_Insert
	(payid_1 	integer,
	 itemid_2 	varchar2,
	 hrmid_3 	integer,
	 salary_4 	number,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO HrmSalaryPaydetail 
	 ( payid,
	 itemid,
	 hrmid,
	 salary) 
 
VALUES 
	( payid_1,
	 itemid_2,
	 hrmid_3,
	 salary_4);
end ;
/




CREATE or REPLACE PROCEDURE HrmSalaryPaydetail_Update
	(payid_1 	integer,
	 itemid_2 	varchar2,
	 hrmid_3 	integer,
	 salary_4 	number,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE HrmSalaryPaydetail 

SET  salary	 = salary_4 

WHERE 
	( payid	 = payid_1 AND
	 itemid	 = itemid_2 AND
	 hrmid	 = hrmid_3);
end;
/



CREATE or REPLACE PROCEDURE HrmSalaryChange_Insert
	(multresourceid_1 	varchar2,
	 itemid_2 	integer,
	 changedate_3 	char,
	 changetype_4 	char,
	 salary_5 	number,
	 changeresion_6 	varchar2,
	 changeuser_7 	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO HrmSalaryChange 
	 ( multresourceid,
	 itemid,
	 changedate,
	 changetype,
	 salary,
	 changeresion,
	 changeuser) 
 
VALUES 
	( multresourceid_1,
	 itemid_2,
	 changedate_3,
	 changetype_4,
	 salary_5,
	 changeresion_6,
	 changeuser_7);
end;
/


CREATE TABLE CRM_SellStatus (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence CRM_SellStatus_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_SellStatus_Trigger
before insert on CRM_SellStatus
for each row
begin
select CRM_SellStatus_id.nextval into :new.id from dual;
end;
/



CREATE TABLE CRM_SellChance (
	id integer  NOT NULL ,
	creater integer null,
	subject varchar2 (50) null,
	customerid integer null,
	comefromid integer null,
	sellstatusid integer null,
	endtatusid char(1) null,
	predate char(10) null,
	preyield number(18,2) null,
	currencyid integer null,
	probability number(8,2) null,
	createdate char(10) null,
	createtime char(8) null,
	content varchar2(4000) null,
	approver integer default 0,
	approvedate char(10) null,
	approvetime char(10) null,
	approvestatus char(1) default 0
	)
/
create sequence CRM_SellChance_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_SellChance_Trigger
before insert on CRM_SellChance
for each row
begin
select CRM_SellChance_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_ProductTable(
	sellchanceid integer null,
	productid integer null,
	assetunitid integer null,
	currencyid integer null,
	salesprice number(12,2) null,
	salesnum integer null,
	totelprice number(18,2) null
)
/



 CREATE or REPLACE PROCEDURE CRM_SellStatus_SelectAll 
(	 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 open thecursor for
 SELECT * FROM CRM_SellStatus;
end;
/

 CREATE or REPLACE PROCEDURE CRM_SellStatus_Insert 
 (fullname 	varchar2, 
 description 	varchar2, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)   
 AS 
 begin
 INSERT INTO 
 CRM_SellStatus 
 ( fullname, description) 
 VALUES ( fullname, description) ;
end;
/




 CREATE or REPLACE PROCEDURE CRM_SellStatus_SelectByID 
 (id 	integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
  begin
 open thecursor for
 SELECT * FROM CRM_SellStatus
 WHERE ( id	 = id)  ;
end;
/


CREATE or REPLACE PROCEDURE CRM_SellChance_SByCustomerID
 (
 id_1 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS
   begin
 open thecursor for
 SELECT * FROM CRM_SellChance WHERE customerid =id_1 order by predate desc ;
end;
/


 CREATE or REPLACE PROCEDURE CRM_SellStatus_Update 
 (id	 	integer, 
 fullname 	varchar2,
 description 	varchar2,  
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE CRM_SellStatus  
SET  fullname	 = fullname,
description	 = description
WHERE ( id	 = id)  ; 
end;
/



 CREATE or REPLACE PROCEDURE CRM_SellStatus_Delete 
 (id 	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 DELETE CRM_SellStatus  WHERE ( id	 = id) ;
 end;
/



/*销售机会*/
CREATE or REPLACE PROCEDURE CRM_SellChance_SelectAll
 (
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS
begin
 open thecursor for
 SELECT * FROM CRM_SellChance ;
end;
/



CREATE or REPLACE PROCEDURE CRM_SellChance_SelectByID
 (
 id_1 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 open thecursor for
 SELECT * FROM CRM_SellChance WHERE id=id_1;
end;
/



CREATE or REPLACE PROCEDURE CRM_SellChance_insert
(
	creater_1 integer ,
	subject_1 varchar2 ,
	customerid_1 integer ,
	comefromid_1 integer ,
	sellstatusid_1 integer ,
	endtatusid_1 char ,
	predate_1 char ,
	preyield_1 number ,
	currencyid_1 integer ,
	probability_1 number,
	createdate_1 char ,
	createtime_1 char ,
	content_1 varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
begin
insert INTO CRM_SellChance
(
	creater ,
	subject ,
	customerid ,
	comefromid ,
	sellstatusid ,
	endtatusid ,
	predate ,
	preyield ,
	currencyid ,
	probability ,
	createdate ,
	createtime ,
	content )
	values
	(
	creater_1  ,
	subject_1  ,
	customerid_1  ,
	comefromid_1  ,
	sellstatusid_1  ,
	endtatusid_1  ,
	predate_1  ,
	preyield_1  ,
	currencyid_1  ,
	probability_1 ,
	createdate_1  ,
	createtime_1  ,
	content_1 );
end;
/



CREATE or REPLACE PROCEDURE CRM_SellChance_SMAXID
 (
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 open thecursor for
 SELECT max(id) as sellchanceid FROM CRM_SellChance ;
end;
/



CREATE or REPLACE PROCEDURE CRM_ProductTable_insert
(
	sellchanceid_1 integer ,
	productid_1 integer ,
	assetunitid_1 integer ,
	currencyid_1 integer ,
	salesprice_1 number ,
	salesnum_1 integer ,
	totelprice_1 number ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
insert INTO CRM_ProductTable
(
	sellchanceid ,
	productid ,
	assetunitid,
	currencyid ,
	salesprice ,
	salesnum,
	totelprice )
	values
(
	sellchanceid_1  ,
	productid_1  ,
	assetunitid_1  ,
	currencyid_1  ,
	salesprice_1 ,
	salesnum_1  ,
	totelprice_1 
	);
end;
/


CREATE or REPLACE PROCEDURE CRM_Product_SelectByID
 (
 id_1 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 open thecursor for
 SELECT * FROM CRM_ProductTable WHERE sellchanceid =id_1;
end;
/





CREATE or REPLACE PROCEDURE CRM_SellChance_Update
(
	creater_1 integer ,
	subject_1 varchar2 ,
	customerid_1 integer ,
	comefromid_1 integer ,
	sellstatusid_1 integer ,
	endtatusid_1 char ,
	predate_1 char ,
	preyield_1 number ,
	currencyid_1 integer ,
	probability_1 number ,
	content_1 varchar2 ,
	id_1 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
update CRM_SellChance set

	creater = creater_1,
	subject = subject_1,
	customerid =customerid_1,
	comefromid =comefromid_1,
	sellstatusid=sellstatusid_1 ,
	endtatusid =endtatusid_1,
	predate=predate_1 ,
	preyield =preyield_1,
	currencyid =currencyid_1,
	probability =probability_1,
	content= content_1
WHERE id=id_1;
end;
/



CREATE or REPLACE PROCEDURE CRM_Product_Delete
(
	id_1 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete CRM_ProductTable WHERE sellchanceid=id_1;
end;
/



CREATE or REPLACE PROCEDURE CRM_SellChance_Delete
(
	id_1 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete CRM_SellChance WHERE id=id_1;
end;
/



CREATE GLOBAL TEMPORARY TABLE temp_sell_table_01
 (result  integer , sucess  integer, failure	integer, nothing	integer)
 ON COMMIT DELETE ROWS
/

CREATE or REPLACE PROCEDURE CRM_SellChance_Statistics
(
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as

result_1 integer;
sucess_1 integer;
failure_1 integer;
nothing_1 integer;
begin


select  count(*) INTO result_1 from CRM_SellChance ;
select  count(id) INTO sucess_1 from CRM_SellChance  WHERE endtatusid ='1';
select  count(id) INTO failure_1  from CRM_SellChance WHERE endtatusid ='2';
select  count(id) INTO nothing_1  from  CRM_SellChance WHERE endtatusid ='0';
insert INTO temp_sell_table_01(result,sucess,failure,nothing) values(result_1,sucess_1,failure_1,nothing_1);
open thecursor for
select * from temp_sell_table_01;
end;
/


insert into HtmlLabelInfo (indexid,labelname,languageid) values (2227,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2227,'销售机会',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2227,'销售机会')
/


create table HrmContractTemplet
(id integer not null,
 templetname varchar2(200) null,
 templetdocid integer null)
/
create sequence HrmContractTemplet_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmContractTemplet_Trigger
before insert on HrmContractTemplet
for each row
begin
select HrmContractTemplet_id.nextval into :new.id from dual;
end;
/

create table HrmContractType
(id integer not null,
 typename varchar2(200) null,
 contracttempletid integer null,
 saveurl varchar2(200) null,
 ishirecontract char(1) null,
 remindaheaddate integer null,
 remindman varchar2(200)
 )
/
create sequence HrmContractType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmContractType_Trigger
before insert on HrmContractType
for each row
begin
select HrmContractType_id.nextval into :new.id from dual;
end;
/


create table HrmContract
(id integer not null,
 contractname varchar2(200) null,
 contractman integer null,
 contracttypeid integer null,
 contractstartdate char(10) null,
 contractenddate char(10) null,
 contractdocid integer null)
/
create sequence HrmContract_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmContract_Trigger
before insert on HrmContract
for each row
begin
select HrmContract_id.nextval into :new.id from dual;
end;
/


alter table HrmTrainType add
 typecontent varchar2(4000) null
/
 alter table HrmTrainType add
 typeaim varchar2(4000) null
/
 alter table HrmTrainType add
 typedocurl varchar2(200) null
/
 alter table HrmTrainType add
 typetesturl varchar2(200) null
/
 alter table HrmTrainType add
 typeoperator varchar2(200) null
/


create table HrmTrainLayout
(id integer  not null,
 layoutname varchar2(60) null,
 typeid integer null,
 layoutstartdate char(10) null,
 layoutenddate char(10) null,
 layoutcontent varchar2(4000) null,
 layoutaim varchar2(4000) null,
 layouttestdate char(10) null,
 layoutassessor varchar2(200))
/
create sequence HrmTrainLayout_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainLayout_Trigger
before insert on HrmTrainLayout
for each row
begin
select HrmTrainLayout_id.nextval into :new.id from dual;
end;
/


create table HrmTrainLayoutAssess
(id integer not null,
 layoutid integer null,
 assessorid integer null,
 assessdate char(10) null,
 implement char(1) null,
 explain varchar2(4000) null,
 advice varchar2(4000) null)
/
create sequence HrmTrainLayoutAssess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainLayoutAssess_Trigger
before insert on HrmTrainLayoutAssess
for each row
begin
select HrmTrainLayoutAssess_id.nextval into :new.id from dual;
end;
/


create table HrmTrainPlan
(id integer  not null,
 planname varchar2(60) null,
 layoutid integer null,
 planorganizer varchar2(200) null,
 planstartdate char(10) null,
 planenddate char(10) null,
 plancontent varchar2(4000) null,
 planaim varchar2(4000) null,
 planaddress varchar2(200) null,
 planresource varchar2(200) null,
 planactor varchar2(4000) null,
 planbudget float null,
 planbudgettype char(1) null,
 openrange varchar(200) null,
 createrid integer null,
 createdate char(10) null)
/
create sequence HrmTrainPlan_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainPlan_Trigger
before insert on HrmTrainPlan
for each row
begin
select HrmTrainPlan_id.nextval into :new.id from dual;
end;
/


create table HrmTrainPlanDay
(id integer  not null,
 planid integer null,
 plandate char(10) null,
 plandaycontent varchar2(4000) null,
 plandayaim varchar2(4000) null)
/
create sequence HrmTrainPlanDay_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainPlanDay_Trigger
before insert on HrmTrainPlanDay
for each row
begin
select HrmTrainPlanDay_id.nextval into :new.id from dual;
end;
/

/*resource*/
create table HrmTrain
(id integer  not null,
 name varchar2(200) null,
 planid integer null,
 organizer varchar2(200) null,
 startdate char(10) null,
 enddate char(10) null,
 content varchar2(4000) null,
 aim varchar2(4000) null,
 resource_n varchar2(200) null,
 address varchar2(200) null,
 testdate char(10) null,
 createrid integer null,
 summarizer integer null,
 summarizedate char(10) null,
 fare float null,
 faretype integer null,
 advice varchar2(4000) null)
/
create sequence HrmTrain_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrain_Trigger
before insert on HrmTrain
for each row
begin
select HrmTrain_id.nextval into :new.id from dual;
end;
/


alter table HrmContract add
  proenddate char(10) null
/

alter table HrmLanguageAbility drop
  column createid
/
  alter table HrmLanguageAbility drop
  column createdate
/
  alter table HrmLanguageAbility drop
  column createtime
/
  alter table HrmLanguageAbility drop
  column lastmoderid
/
  alter table HrmLanguageAbility drop
  column lastmoddate
/
  alter table HrmLanguageAbility drop
  column lastmodtime
/


CREATE or REPLACE PROCEDURE HrmInfoStatus_Finish
(id_1 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmInfoStatus set
  status = 1
where
  hrmid = id_1;
end;
/

CREATE or REPLACE PROCEDURE HrmResourceDateCheck
 (today_1 char,
  flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 update HrmResource set
   status = 7
 where
    (status = 0 or status = 1 or status = 2 or status = 3) and enddate > today_1 and enddate <>'';
 update HrmResource set
   status = 3
 where
   status = 0 and probationenddate > today_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmConType_Insert
(typename_1 varchar2,
 contracttempletid_2 integer,
 saveurl_3 varchar2,
 ishirecontract_4 char,
 remindaheaddate_5 integer,
 remindman_6 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT into HrmContractType
(typename,
 contracttempletid,
 saveurl,
 ishirecontract,
 remindaheaddate,
 remindman)
VALUES
(typename_1,
 contracttempletid_2,
 saveurl_3,
 ishirecontract_4,
 remindaheaddate_5,
 remindman_6);
end;
/

CREATE or REPLACE PROCEDURE HrmConType_Update
(id_1 integer,
 typename_2 varchar2,
 contracttempletid_3 integer,
 saveurl_4 varchar2,
 ishirecontract_5 char,
 remindaheaddate_6 integer,
 remindman_7 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
UPDATE HrmContractType SET
 typename = typename_2,
 contracttempletid = contracttempletid_3,
 saveurl = saveurl_4,
 ishirecontract = ishirecontract_5,
 remindaheaddate = remindaheaddate_6 ,
 remindman = remindman_7
WHERE
 id = id_1;
end;
/

CREATE or REPLACE PROCEDURE HrmConType_Delete
(id_1 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE FROM HrmContractType
WHERE
  id = id_1;
end;
/





CREATE or REPLACE PROCEDURE HrmTrainType_Update
(id_1 integer,
 name_2 varchar2,
 description_3 varchar2,
 typecontent_4 varchar2 ,
 typeaim_5 varchar ,
 typedocurl_6 varchar2 ,
 typetesturl_7 varchar2 ,
 typeoperator_8 varchar2 ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE HrmTrainType SET
  name = name_2,
  description = description_3,
  typecontent = typecontent_4,
  typeaim = typeaim_5,
  typedocurl = typedocurl_6,
  typetesturl = typetesturl_7,
  typeoperator = typeoperator_8
WHERE
  id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainType_Insert
(name_2 varchar2,
 description_3 varchar2,
 typecontent_4 varchar2 ,
 typeaim_5 varchar2 ,
 typedocurl_6 varchar2 ,
 typetesturl_7 varchar2 ,
 typeoperator_8 varchar2 ,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT into HrmTrainType
( name,
  description ,
  typecontent ,
  typeaim ,
  typedocurl ,
  typetesturl,
  typeoperator)
VALUES
( name_2,
  description_3,
  typecontent_4,
  typeaim_5,
  typedocurl_6,
  typetesturl_7,
  typeoperator_8);
end;
/

CREATE or REPLACE PROCEDURE HrmTrainLayout_Insert
(layoutname_1 varchar2,
 typeid_2 integer,
 layoutstartdate_3 char,
 layoutenddate_4 char,
 layoutcontent_5 varchar2,
 layoutaim_6 varchar2,
 layouttestdate_7 char,
 layoutassessor_8 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert into HrmTrainLayout
 (layoutname ,
 typeid ,
 layoutstartdate ,
 layoutenddate,
 layoutcontent,
 layoutaim,
 layouttestdate,
 layoutassessor
)
values
(layoutname_1 ,
 typeid_2 ,
 layoutstartdate_3 ,
 layoutenddate_4 ,
 layoutcontent_5 ,
 layoutaim_6 ,
 layouttestdate_7 ,
 layoutassessor_8 
 );
end;
/


CREATE or REPLACE PROCEDURE HrmTrainLayout_Update
(layoutname_1 varchar2,
 typeid_2 integer,
 layoutstartdate_3 char,
 layoutenddate_4 char,
 layoutcontent_5 varchar2,
 layoutaim_6 varchar2,
 layouttestdate_7 char,
 layoutassessor_8 varchar2,
 id_9 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmTrainLayout set
 layoutname = layoutname_1,
 typeid = typeid_2,
 layoutstartdate = layoutstartdate_3,
 layoutenddate = layoutenddate_4,
 layoutcontent = layoutcontent_5,
 layoutaim = layoutaim_6,
 layouttestdate = layouttestdate_7,
 layoutassessor = layoutassessor_8
where 
  id = id_9;
end;
/

CREATE or REPLACE PROCEDURE HrmTrainLayout_Delete
(id_1 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete from HrmTrainLayout 
where
 id = id_1;
end;
/


CREATE or REPLACE PROCEDURE TrainLayoutAssess_Insert
(layoutid_1 integer,
 assessorid_2 integer,
 assessdate_3 char,
 implement_4 char,
 explain_5 varchar2,
 advice_6 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert into HrmTrainLayoutAssess
(layoutid,
 assessorid,
 assessdate,
 implement,
 explain,
 advice)
values
(layoutid_1,
 assessorid_2,
 assessdate_3,
 implement_4,
 explain_5,
 advice_6);
end;
/

CREATE or REPLACE PROCEDURE HrmTrainPlan_Update
(planname_1 varchar2,
 layoutid_2 integer,
 planorganizer_3 varchar2,
 planstartdate_4 char,
 planenddate_5 char,
 plancontent_6 varchar2,
 planaim_7 varchar2,
 planaddress_8 varchar2,
 planresource_9 varchar2,
 planactor_10 varchar2,
 planbudget_11 float,
 planbudgettype_12 char,
 openrange_13 varchar2,
 id_14 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
Update HrmTrainPlan set
 planname = planname_1,
 layoutid = layoutid_2,
 planorganizer = planorganizer_3 ,
 planstartdate = planstartdate_4,
 planenddate = planenddate_5,
 plancontent = plancontent_6,
 planaim = planaim_7,
 planaddress = planaddress_8,
 planresource = planresource_9,
 planactor = planactor_10,
 planbudget =  planbudget_11,
 planbudgettype = planbudgettype_12,
 openrange = openrange_13
where
(id = id_14);
end;
/


CREATE or REPLACE PROCEDURE HrmTrainPlan_Insert
(planname_1 varchar2,
 layoutid_2 integer,
 planorganizer_3 varchar2,
 planstartdate_4 char,
 planenddate_5 char,
 plancontent_6 varchar2,
 planaim_7 varchar2,
 planaddress_8 varchar2,
 planresource_9 varchar2,
 planactor_10 varchar2,
 planbudget_11 float,
 planbudgettype_12 char,
 openrange_13 varchar2,
 createrid_14 integer,
 createdate_15 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert INTO  HrmTrainPlan 
 (planname,
 layoutid ,
 planorganizer,
 planstartdate,
 planenddate,
 plancontent,
 planaim,
 planaddress,
 planresource,
 planactor,
 planbudget,
 planbudgettype,
 openrange,
 createrid,
 createdate)
values
(planname_1,
 layoutid_2,
 planorganizer_3,
 planstartdate_4,
 planenddate_5,
 plancontent_6,
 planaim_7,
 planaddress_8,
 planresource_9,
 planactor_10,
 planbudget_11,
 planbudgettype_12,
 openrange_13,
 createrid_14,
 createdate_15);
end;
/


CREATE or REPLACE PROCEDURE HrmTrainPlan_Delete
(id_1 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
delete from HrmTrainPlan
where
 id = id_1;
end;
/

CREATE or REPLACE PROCEDURE TrainPlanDay_Insert
(planid_1 integer,
 plandate_2 char,
 plandaycontent_3 varchar2,
 plandayaim_4 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert into HrmTrainPlanDay
(planid,
 plandate,
 plandaycontent,
 plandayaim)
values
(planid_1,
 plandate_2,
 plandaycontent_3,
 plandayaim_4);
end;
/


CREATE or REPLACE PROCEDURE TrainPlanDay_Delete
(id_1 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete from HrmTrainPlanDay
where
 planid = id_1;
end;
/


insert into HtmlLabelIndex (id,indexdesc) values (6084,'分成本中心')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6084,'分成本中心',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (6086,'岗位')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6086,'岗位',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (6087,'个人')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6087,'个人',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6087,'Personal',8)
/

 CREATE or REPLACE PROCEDURE HrmCostcenter_SelectByDeptID 
 (
 id_1 varchar2 , 
 groupby_1 varchar2 , 
  flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS 
 begin
 if to_number(groupby_1)=1 then
 open thecursor for
 select ccsubcategory1 from HrmCostcenter 
 where departmentid = to_number(id_1) group by ccsubcategory1 ;
 end if;
 end;
/
 

 CREATE or REPLACE PROCEDURE HrmLanguageAbility_Insert 
	(resourceid_1 	integer,
	 language_2 	varchar2,
	 level_3 	char,
	 memo_4 	varchar2,	 
  flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO HrmLanguageAbility 
	 ( resourceid,
	 language,
	 level_n,
	 memo) 
 
VALUES 
	( resourceid_1,
	 language_2,
	 level_3,
	 memo_4);
end;
/



CREATE or REPLACE PROCEDURE HrmContract_UpdateByHrm
(id_1 integer,
 startdate_2 char,
 enddate_3 char,
 proenddate_4 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
update HrmContract set
 contractstartdate = startdate_2,
 contractenddate = enddate_3,
 proenddate = proenddate_4
where
 contractman = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmResourceContactInfo_Update
(id_1 integer, 
 locationid_15 integer, 
 workroom_16 varchar2, 
 telephone_17 varchar2, 
 mobile_18 varchar2,
 mobilecall_19 varchar2 , 
 fax_20 varchar2, 
 systemlanguage_21 integer,
 email_22 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 UPDATE HrmResource SET
 locationid =   locationid_15,
 workroom =   workroom_16, 
 telephone =   telephone_17, 
 mobile =   mobile_18, 
 mobilecall =   mobilecall_19, 
 fax =   fax_20,
 email = email_22,
 systemlanguage = systemlanguage_21
 WHERE
 id =  id_1 ;
 end;
/


insert into HtmlLabelIndex (id,indexdesc) values (6088,'转正')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6088,'转正',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6088,'Hire',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6089,'续签')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6089,'续签',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6089,'Extend',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6090,'调动')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6090,'调动',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6090,'Redeploy',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6091,'离职')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6091,'离职',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6091,'Dismiss',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6092,'退休')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6092,'退休',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6092,'Retire',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6093,'反聘')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6093,'反聘',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6093,'Rehire',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6094,'解聘')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6094,'解聘',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6094,'Fire',8)
/

CREATE or REPLACE PROCEDURE HrmResource_CreateInfo
(id_1 integer,
 createrid_2 integer,
 createdate_3 char,
 lastmodid_4 integer,
 lastmoddate_5 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
update HrmResource set
 createrid = createrid_2,
 createdate = createdate_3,
 lastmodid = lastmodid_4,
 lastmoddate = lastmoddate_5
where
 id = id_1;
end;
/

CREATE or REPLACE PROCEDURE HrmResource_ModInfo
(id_1 integer,
 lastmodid_2 integer,
 lastmoddate_3 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
update HrmResource set
 lastmodid = lastmodid_2,
 lastmoddate = lastmoddate_3
where
 id = id_1;
end;
/

insert into HtmlLabelIndex (id,indexdesc) values (6096,'总成本中心')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6096,'总成本中心',7)
/

delete HrmSubCompany where companyid != 1
/
delete HrmCostcenterSubCategory where ccmaincategoryid != 1
/

CREATE or REPLACE PROCEDURE HrmInfoStatus_UpdateSystem
(id_1 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 update HrmInfoStatus set
 status = 1
 where 
 itemid = 1 and hrmid = id_1;
 end;
/

 
 CREATE or REPLACE PROCEDURE HrmInfoStatus_UpdateFinance
 (id_1 integer,
  flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as 
 begin
 update HrmInfoStatus set
   status = 1
 where
  itemid = 2 and hrmid = id_1;
end;
/

 
 CREATE or REPLACE PROCEDURE HrmInfoStatus_UpdateCapital
 (id_1 integer,
  flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 as 
 begin
 update HrmInfoStatus set
   status = 1
 where
  itemid = 3 and hrmid = id_1;
end;
/



  CREATE or REPLACE PROCEDURE HrmResource_SCountBySubordinat 
 (id_1 integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
  AS
begin
open thecursor for
  select count(*) from HrmResource 
  where 
   managerid = id_1 
   and (status =0 or status = 1 or status =2 or status =3);
end;
/



CREATE or REPLACE PROCEDURE HrmResource_SelectByManagerID 
 (id_1 integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
  AS
begin
open thecursor for  
  select * from HrmResource 
  where 
    managerid = id_1 
    and (status =0 or status = 1 or status =2 or status =3);
end;
/

 CREATE or REPLACE PROCEDURE HrmResource_Rehire
(id_1 integer,
 changedate_2 char,
 changeenddate_3 char,
 changereason_4 char,
 changecontractid_5 integer,
 infoman_6 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n
)
VALUES
(id_1, 
 changedate_2,
 changeenddate_3,
 changereason_4,
 changecontractid_5,
 infoman_6,
 oldjobtitleid_7 ,
 type_n_8
 );
UPDATE HrmResource SET 
 startdate = changedate_2,
 enddate = changeenddate_3
WHERE
 id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmResource_Retire
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 changecontractid_4 integer,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 changecontractid_4,
 infoman_5,
 oldjobtitleid_7,
 type_n_8);
UPDATE HrmResource SET
 enddate = changedate_2
WHERE
 id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmResource_Dismiss
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 changecontractid_4 integer,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char, 
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 changecontractid_4,
 infoman_5,
 oldjobtitleid_7,
 type_n_8);
UPDATE HrmResource SET 
 enddate = changedate_2
WHERE
 id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmResource_Hire
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,  
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO HrmStatusHistory
(resourceid,
 changedate,
 changereason,
 infoman,
 oldjobtitleid,
 type_n  )
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 infoman_5,
 oldjobtitleid_7 ,
 type_n_8   );
end;
/



CREATE or REPLACE PROCEDURE HrmResource_Fire
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 changecontractid_4 integer,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,  
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 changecontractid_4,
 infoman_5,
 oldjobtitleid_7 ,
 type_n_8 );
UPDATE HrmResource SET 
 enddate = changedate_2
WHERE
 id = id_1;
end;
/


/* 客户合同性质维护 */
CREATE TABLE CRM_ContractType (
	id integer NOT NULL ,
	name varchar2 (100)  NULL ,
	contractdesc varchar2 (200)  NULL ,
	workflowid integer NULL 
)
/
create sequence CRM_ContractType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_ContractType_Trigger
before insert on CRM_ContractType
for each row
begin
select CRM_ContractType_id.nextval into :new.id from dual;
end;
/


/* 客户合同维护 */
CREATE TABLE CRM_Contract (
	id integer NOT NULL ,
	name varchar2 (100)  NULL ,
	typeId integer NULL ,	
	docId integer NULL ,
	price number(10, 2) NULL ,
	crmId integer NULL ,
	contacterId integer NULL ,
	startDate char (10)  NULL ,
	endDate char (10)  NULL ,
	manager integer NULL ,
	status integer NULL ,
	isRemind integer NULL ,
	remindDay integer NULL ,
	creater integer NULL ,
	createDate char (10)  NULL ,
	createTime char (10)  NULL
)
/
create sequence CRM_Contract_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_Contract_Trigger
before insert on CRM_Contract
for each row
begin
select CRM_Contract_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_ContractProduct (
	id integer NOT NULL ,
	contractId integer NULL ,
	productId integer NULL ,	
	unitId integer NULL ,
	number_n integer NULL ,
	price number(10, 2) NULL ,
	currencyId integer NULL ,
	depreciation integer NULL , /*折扣*/
	sumPrice number(10, 2) NULL ,
	planDate char (10)  NULL ,
	factnumber_n integer NULL ,
	factDate char (10)  NULL ,
	isFinish integer NULL ,
	isRemind integer NULL 
)
/
create sequence CRM_ContractProduct_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_ContractProduct_Trigger
before insert on CRM_ContractProduct
for each row
begin
select CRM_ContractProduct_id.nextval into :new.id from dual;
end;
/



CREATE TABLE CRM_ContractPayMethod (
	id integer  NOT NULL ,
	contractId integer NULL ,
	prjName varchar2 (100)  NULL ,
	typeId integer NULL ,	
	payPrice number(10, 2) NULL ,
	payDate char (10)  NULL ,
	factPrice number(10, 2) NULL ,
	factDate char (10)  NULL ,
	qualification varchar2 (200)  NULL ,  /*付款条件*/	
	isFinish integer NULL ,
	isRemind integer NULL 	
)
/
create sequence CRM_ContractPayMethod_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_ContractPayMethod_Trigger
before insert on CRM_ContractPayMethod
for each row
begin
select CRM_ContractPayMethod_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_CustomerCredit (
	CreditAmount number(10, 2) NULL ,
	CreditTime int NULL  
)
/

ALTER TABLE CRM_CustomerInfo add CreditAmount decimal(10, 2)  /* 信用额度 */
/

ALTER TABLE CRM_CustomerInfo add CreditTime int /* 客户卡片的信用期间  */
/


CREATE TABLE CRM_Contract_Exchange (
	id integer NOT NULL ,
	contractId integer NULL ,
	name varchar2 (200)  NULL ,
	remark varchar2(4000)  NULL ,
	creater integer NULL ,
	createDate char (10)  NULL ,
	createTime char (10)  NULL
)
/
create sequence CRM_Contract_Exchange_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_Contract_Exchange_Trigger
before insert on CRM_Contract_Exchange
for each row
begin
select CRM_Contract_Exchange_id.nextval into :new.id from dual;
end;
/


/* 客户合同性质维护 */

CREATE or REPLACE PROCEDURE CRM_ContractType_Select
	(
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
 open thecursor for
SELECT * FROM CRM_ContractType ;
end;
/

CREATE or REPLACE PROCEDURE CRM_ContractType_SelectById
	(id_1 	integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
 open thecursor for
SELECT * FROM CRM_ContractType  where id = id_1 ;	
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractType_Insert 
	(name_1 	varchar2,
	 contractdesc_1	varchar2,
	 workflowid_1  integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO CRM_ContractType 
	 (name,
	 contractdesc,
	 workflowid) 
 
VALUES 
	( name_1,
	 contractdesc_1,
	 workflowid_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractType_Delete
	(id_1 	integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE CRM_ContractType 
WHERE 
	( id	 = id_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractType_Update 
	(id_1 	integer ,
	 name_1 	varchar2,
	 contractdesc_1	varchar2,
	 workflowid_1  integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_ContractType SET name = name_1, contractdesc = contractdesc_1 , workflowid = workflowid_1 where id = id_1;
end;
/



/* 合同维护 */

CREATE or REPLACE PROCEDURE CRM_Contract_SelectAll
	(
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
 open thecursor for
SELECT * FROM CRM_Contract; 
end;
/


CREATE or REPLACE PROCEDURE CRM_Contract_Select
	(crmId_1 integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
 open thecursor for
SELECT * FROM CRM_Contract  where crmId = crmId_1;
end;
/

CREATE or REPLACE PROCEDURE CRM_Contract_SelectById
	(id_1 	integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
 open thecursor for
SELECT * FROM CRM_Contract  where id = id_1; 	
end;
/



CREATE or REPLACE PROCEDURE CRM_Contract_Insert 
	(name_1  varchar2   ,
	 typeId_1  integer  ,	
	 docId_1  integer  ,
	 price_1  number  ,
	 crmId_1  integer  ,
	 contacterId_1  integer  ,
	 startDate_1  char    ,
	 endDate_1  char    ,
	 manager_1  integer  ,
	 status_1  integer  ,
	 isRemind_1  integer  ,
	 remindDay_1  integer  ,
	 creater_1  integer  ,
	 createDate_1  char   ,
	 createTime_1  char   ,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO CRM_Contract 
	 (name , 
	 typeId , 
	 docId , price , crmId , contacterId , startDate , endDate , manager , status , isRemind , remindDay , creater , createDate , createTime) 
 
VALUES 
	( name_1,
	 typeId_1,
	 docId_1, price_1 , crmId_1 , contacterId_1 , startDate_1 , endDate_1 , manager_1 , status_1 , isRemind_1 , remindDay_1 , creater_1 , createDate_1 , createTime_1);
open thecursor for
select * from( select* from CRM_Contract order by id desc ) WHERE rownum =1;
end;
/


CREATE or REPLACE PROCEDURE CRM_Contract_Update 
	(id_1 	integer ,
	 name_1  varchar2   ,
	 typeId_1  integer  ,	
	 docId_1  integer  ,
	 price_1  number  ,
	 crmId_1  integer  ,
	 contacterId_1  integer  ,
	 startDate_1  char    ,
	 endDate_1  char    ,
	 manager_1  integer  ,
	 status_1  integer  ,
	 isRemind_1  integer  ,
	 remindDay_1  integer  ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_Contract SET name = name_1, typeId = typeId_1 , docId = docId_1 , price = price_1 , 
crmId = crmId_1 , contacterId = contacterId_1 , startDate = startDate_1 , endDate = endDate_1 ,
manager = manager_1 , status = status_1 , isRemind = isRemind_1 , remindDay = remindDay_1  where id = id_1;
end;
/

CREATE or REPLACE PROCEDURE CRM_Contract_UpdateRemind
	(id_1 	integer ,	 
	 isRemind_1  integer , 
	 remindDay_1  char  ,	
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_Contract SET isRemind = isRemind_1, remindDay = remindDay_1   where id = id_1;
end;
/


/**/
CREATE or REPLACE PROCEDURE CRM_ContractProduct_Select
	(contractId_1 integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * FROM CRM_ContractProduct where contractId = contractId_1;
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractProduct_Delete
	(id_1 	integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE CRM_ContractProduct 
WHERE 
	( id	 = id_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractProduct_DelAll
	(contractId_1 	integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE CRM_ContractProduct 
WHERE 
	( contractId	 = contractId_1);

end;
/



CREATE or REPLACE PROCEDURE CRM_ContractProduct_Insert 
	(
	 contractId_1  integer  ,	
	 productId_1  integer  ,
	 unitId_1  integer  ,
	 number_n_1  integer  ,
	 price_1  number  ,
	 currencyId_1  integer  ,
	 depreciation_1  integer  ,
	 sumPrice_1  number  ,
	 planDate_1  char    ,
	 factnumber_n_1   integer  ,
	 factDate_1  char   ,
	 isFinish_1  integer  ,
	 isRemind_1  integer  ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO CRM_ContractProduct 
	 (contractId , 
	 productId , 
	 unitId , number_n , price , currencyId , depreciation , sumPrice , planDate , factnumber_n , factDate , isFinish , isRemind ) 
 
VALUES 
	( contractId_1,
	 productId_1,
	 unitId_1, number_n_1 , price_1 , currencyId_1 , depreciation_1 , sumPrice_1 , planDate_1 , factnumber_n_1 , factDate_1 , isFinish_1 , isRemind_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractProduct_Update 
	(id_1 	integer ,
	 factnumber_n_1  integer ,
	 factDate_1  char   ,	
	 isFinish_1  integer  ,
	 isRemind_1  integer , 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_ContractProduct SET factnumber_n = factnumber_n_1, factDate = factDate_1 , isFinish = isFinish_1 , isRemind = isRemind_1  where id = id_1;
end;
/


/**/
CREATE or REPLACE PROCEDURE CRM_ContractPayMethod_Select
	(contractId_1 integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * FROM CRM_ContractPayMethod  where contractId = contractId_1;
end;
/

CREATE or REPLACE PROCEDURE CRM_ContractPayMethod_Delete
	(id_1 	integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE CRM_ContractPayMethod 
WHERE 
	( id	 = id_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractPayMethod_DelAll
	(contractId_1 	integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE CRM_ContractPayMethod 
WHERE 
	( contractId	 = contractId_1);
end;
/



CREATE or REPLACE PROCEDURE CRM_ContractPayMethod_Insert 
	(
	 contractId_1  integer  ,	
	 prjName_1  varchar2   ,
	 typeId_1  integer  ,
	 payPrice_1  number  ,
	 payDate_1  char    ,
	 factPrice_1  number  ,
	 factDate_1  char   ,
	 qualification_1 varchar2 ,
	 isFinish_1  integer  ,
	 isRemind_1  integer  ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO CRM_ContractPayMethod 
	 (contractId , 
	 prjName , 
	 typeId , payPrice , payDate , factPrice , factDate , qualification , isFinish , isRemind ) 
 
VALUES 
	(contractId_1,
	 prjName_1,
	 typeId_1, payPrice_1 , payDate_1 , factPrice_1 , factDate_1 , qualification_1 , isFinish_1 , isRemind_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractPayMethod_Update 
	(id_1 	integer ,
	 factPrice_1  number  ,
	 factDate_1  char   ,	
	 isFinish_1  integer  ,
	 isRemind_1  integer , 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_ContractPayMethod SET factPrice = factPrice_1, factDate = factDate_1 , isFinish = isFinish_1 , isRemind = isRemind_1  where id = id_1;
end;
/


CREATE or REPLACE PROCEDURE CRM_CustomerCredit_Insert 
	(CreditAmount_1  number  ,	
	 CreditTime_1  integer  ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO CRM_CustomerCredit 
	    (CreditAmount,CreditTime)
VALUES(CreditAmount_1, CreditTime_1 );
end;
/




CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Insert 
 (name_1 		varchar2, 
 language_1 	integer,
 engname_1 	varchar2,
 address1_1 	varchar2, 
 address2_1 	varchar2, 
 address3_1 	varchar2,
 zipcode_1 	varchar2,
 city_1	 	integer, 
 country_1 	integer,
 province_1 	integer,
 county_1 	varchar2,
 phone_1 	varchar2, 
 fax_1	 	varchar2,
 email_1 	varchar2,
 website_1 	varchar2,
 source_1 	integer, 
 sector_1 	integer,
 size_n_1	 	integer,
 manager_1 	integer,
 agent_1 	integer, 
 parentid_1 	integer, 
 department_1 	integer,
 subcompanyid1_1 	integer,
 fincode_1 	integer,
 currency_1 	integer,
 contractlevel_1	integer, 
 creditlevel_1 	integer,
 creditoffset_1 	varchar2, 
 discount_1 	decimal, 
 taxnumber_1 	varchar2, 
 bankacount_1 	varchar2,
 invoiceacount_1	integer,
 deliverytype_1 	integer,
 paymentterm_1 	integer,
 paymentway_1 	integer,
 saleconfirm_1 	integer,
 creditcard_1 	varchar2,
 creditexpire_1 	varchar2,
 documentid_1 	integer,
 seclevel_1 	integer,
 picid_1 	integer, 
 type_1 		integer,
 typebegin_1 	varchar2, 
 description_1 	integer,
 status_1 	integer,
 rating_1 	integer,
 introductionDocid_1 integer,  
 CreditAmount_1 number, 
 CreditTime_1 integer,
 datefield1_1 	varchar2,
 datefield2_1 	varchar2,
 datefield3_1 	varchar2,
 datefield4_1 	varchar2,
 datefield5_1 	varchar2,
 numberfield1_1 	float,
 numberfield2_1 	float,
 numberfield3_1 	float,
 numberfield4_1 	float,
 numberfield5_1 	float, 
 textfield1_1 	varchar2,
 textfield2_1 	varchar2,
 textfield3_1 	varchar2,
 textfield4_1 	varchar2,
 textfield5_1 	varchar2,
 tinyintfield1_1 smallint,
 tinyintfield2_1 smallint,
 tinyintfield3_1 smallint,
 tinyintfield4_1 smallint,
 tinyintfield5_1 smallint, 
 createdate_1 	varchar2,
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS 
begin
 INSERT INTO CRM_CustomerInfo ( name,
 language,
 engname, 
 address1, 
 address2,
 address3,
 zipcode, 
 city, 
 country,
 province,
 county, 
 phone, 
 fax, 
 email, 
 website,
 source, 
 sector, 
 size_n,
 manager,
 agent, 
 parentid,
 department, 
 subcompanyid1, 
 fincode, 
 currency,
 contractlevel, 
 creditlevel, 
 creditoffset, 
 discount,
 taxnumber,
 bankacount,
 invoiceacount, 
 deliverytype, 
 paymentterm, 
 paymentway, 
 saleconfirm, 
 creditcard, 
 creditexpire,
 documentid,
 seclevel, 
 picid, 
 type, 
 typebegin, 
 description, 
 status, rating,
 datefield1, 
 datefield2, 
 datefield3,
 datefield4, 
 datefield5,
 numberfield1,
 numberfield2,
 numberfield3, 
 numberfield4,
 numberfield5,
 textfield1,
 textfield2, 
 textfield3,
 textfield4,
 textfield5, 
 tinyintfield1, 
 tinyintfield2, 
 tinyintfield3,
 tinyintfield4, 
 tinyintfield5,
 deleted, createdate,introductionDocid,CreditAmount,CreditTime) 
 VALUES (
 name_1, 
 language_1,
 engname_1,
 address1_1,
 address2_1,
 address3_1,
 zipcode_1, 
 city_1, 
 country_1, 
 province_1,
 county_1,
 phone_1,
 fax_1, 
 email_1, 
 website_1, 
 source_1,
 sector_1,
 size_n_1,
 manager_1,
 agent_1,
 parentid_1,
 department_1,
 subcompanyid1_1, 
 fincode_1,
 currency_1,
 contractlevel_1, 
 creditlevel_1,
 to_number(creditoffset_1), 
 discount_1,
 taxnumber_1,
 bankacount_1,
 invoiceacount_1,
 deliverytype_1,
 paymentterm_1,
 paymentway_1,
 saleconfirm_1,
 creditcard_1,
 creditexpire_1,
 documentid_1,
 seclevel_1,
picid_1,
type_1, 
typebegin_1,
description_1,
status_1, 
rating_1,
datefield1_1, 
datefield2_1,
datefield3_1, 
datefield4_1, 
datefield5_1,
numberfield1_1, 
numberfield2_1,
numberfield3_1, 
numberfield4_1,
numberfield5_1, 
textfield1_1, 
textfield2_1, 
textfield3_1, 
textfield4_1, 
textfield5_1, 
tinyintfield1_1,
tinyintfield2_1, 
tinyintfield3_1,
tinyintfield4_1,
tinyintfield5_1,
0, 
createdate_1,
introductionDocid_1,
CreditAmount_1 , 
CreditTime_1 );
open thecursor for
select  id from (SELECT  id from CRM_CustomerInfo ORDER BY id DESC ) WHERE rownum =1;
end;
/




 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Update 
 (
 id_1 		integer,
 name_1 		varchar2,
 language_1 	integer,
 engname_1 	varchar2,
 address1_1 	varchar2, 
 address2_1 	varchar2,
 address3_1 	varchar2, 
 zipcode_1 	varchar2, 
 city_1	 	integer,
 country_1 	integer, 
 province_1 	integer, 
 county_1 	varchar2, 
 phone_1 	varchar2,
 fax_1	 	varchar2,
 email_1 	varchar2, 
 website_1 	varchar2,
 source_1 	integer,
 sector_1 	integer,
 size_n_1	 	integer, 
 manager_1 	integer, 
 agent_1 	integer,
 parentid_1 	integer,
 department_1 	integer,
 subcompanyid1_1 	integer,
 fincode_1 	integer, 
 currency_1 	integer,
 contractlevel_1	integer,
 creditlevel_1 	integer,
 creditoffset_1 	varchar2, 
 discount_1 	decimal, 
 taxnumber_1 	varchar2, 
 bankacount_1 	varchar2,
 invoiceacount_1 integer, 
 deliverytype_1 	integer,
 paymentterm_1 	integer,
 paymentway_1 	integer,
 saleconfirm_1 	integer,
 creditcard_1 	varchar2,
 creditexpire_1 	varchar2, 
 documentid_1 	integer,
 seclevel_1 	integer,
 picid_1 	integer,
 type_1	 	integer,
 typebegin_1 	varchar2,
 description_1 	integer,
 status_1 	integer, 
 rating_1 	integer, 
 introductionDocid_1 integer, 
 CreditAmount_1 number ,
 CreditTime_1 integer,
 datefield1_1 	varchar2,
 datefield2_1 	varchar2,
 datefield3_1 	varchar2, 
 datefield4_1 	varchar2,
 datefield5_1 	varchar2,
 numberfield1_1 	float,
 numberfield2_1 	float,
 numberfield3_1 	float, 
 numberfield4_1 	float, 
 numberfield5_1 	float, 
 textfield1_1 	varchar2, 
 textfield2_1 	varchar2, 
 textfield3_1 	varchar2,
 textfield4_1 	varchar2,
 textfield5_1 	varchar2, 
 tinyintfield1_1 	smallint, 
 tinyintfield2_1 	smallint,
 tinyintfield3_1 	smallint,
 tinyintfield4_1 	smallint, 
 tinyintfield5_1 	smallint,
flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE CRM_CustomerInfo  SET  
 name	 	 = name_1,
 language	 = language_1, 
 engname	 = engname_1,
 address1	 = address1_1,
address2	 = address2_1,
address3	 = address3_1, 
zipcode	 = zipcode_1,
city	 = city_1, 
country	 = country_1,
province	 = province_1,
county	 = county_1,
phone	 = phone_1,
fax	 = fax_1, 
email	 = email_1, 
website	 = website_1,
source	 = source_1,
sector	 = sector_1, 
size_n	 = size_n_1,
manager	 = manager_1,
agent	 = agent_1,
parentid	 = parentid_1,
department	 = department_1, 
subcompanyid1	 = subcompanyid1_1,
fincode	 = fincode_1,
currency	 = currency_1,
contractlevel = contractlevel_1, 
creditlevel	 = creditlevel_1, 
creditoffset	 = to_number(creditoffset_1),
discount	 = discount_1,
taxnumber	 = taxnumber_1,
bankacount	 = bankacount_1,
invoiceacount	 = invoiceacount_1,
deliverytype	 = deliverytype_1, 
paymentterm	 = paymentterm_1,
paymentway	 = paymentway_1,
saleconfirm	 = saleconfirm_1,
creditcard	 = creditcard_1,
creditexpire	 = creditexpire_1,
documentid	 = documentid_1,
seclevel = seclevel_1, 
picid	 = picid_1,
type	 = type_1,
typebegin	 = typebegin_1,
description	 = description_1,
status	 = status_1,
rating	 = rating_1,
datefield1	 = datefield1_1, 
datefield2	 = datefield2_1, 
datefield3	 = datefield3_1,
datefield4	 = datefield4_1,
datefield5	 = datefield5_1,
numberfield1	 = numberfield1_1, 
numberfield2	 = numberfield2_1,
numberfield3	 = numberfield3_1,
numberfield4	 = numberfield4_1, 
numberfield5	 = numberfield5_1, 
textfield1	 = textfield1_1,
textfield2	 = textfield2_1,
textfield3	 = textfield3_1,
textfield4	 = textfield4_1,
textfield5	 = textfield5_1,
tinyintfield1	 = tinyintfield1_1,
tinyintfield2	 = tinyintfield2_1, 
tinyintfield3	 = tinyintfield3_1, 
tinyintfield4	 = tinyintfield4_1, 
tinyintfield5	 = tinyintfield5_1  ,
introductionDocid = introductionDocid_1 , 
CreditAmount = CreditAmount_1 , 
CreditTime = CreditTime_1 
WHERE ( id	 = id); 
end;
/



CREATE or REPLACE PROCEDURE CRM_ContractExch_Insert 
	(contractId_1 integer  ,
	 name_1  varchar2   ,
	 remark_1 varchar2  ,
	 creater_1  integer  ,
	 createDate_1  char    ,
	 createTime_1  char  ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO CRM_Contract_Exchange 
	 (contractId ,
	 name , 
	 remark , 
	 creater , createDate , createTime) 
 
VALUES 
	(contractId_1 ,
	 name_1,
	 remark_1,
	 creater_1 , createDate_1 , createTime_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractExch_Select
	(contractId_1 integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
 open thecursor for
SELECT * FROM CRM_Contract_Exchange where contractId = contractId_1 order by createDate desc, createTime;
end;
/

/* 客户合同性质维护 */
insert into SystemRights(id,rightdesc,righttype) values(352,'客户合同性质维护','0')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(352,7,'客户合同性质维护','客户合同性质维护')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(352,8,'','')
/

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2058,'客户合同性质添加','CRM_ContractTypeAdd:Add',352)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2059,'客户合同性质编辑','CRM_ContractTypeEdit:Edit',352)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2060,'客户合同性质删除','CRM_ContractTypeDelete:Delete',352)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2061,'客户合同性质日志','CRM_ContractType:Log',352)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (352,8,'1')
/

insert into SystemRightToGroup (groupid,rightid) values (6,352)
/


/* 客户信用额度/期间维护 */
insert into SystemRights(id,rightdesc,righttype) values(353,'客户信用额度/期间维护','0')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(353,7,'客户信用额度/期间维护','客户信用额度/期间维护')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(353,8,'','')
/

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2062,'客户合同性质添加','CRM_CustomerCreditAdd:Add',353)
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (353,8,'1')
/

insert into SystemRightToGroup (groupid,rightid) values (6,353)
/

insert into HtmlLabelIndex (id,indexdesc) values (6083	,'合同性质')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6083,'合同性质',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6083,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6095	,'签单')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6095,'签单',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6095,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6097	,'信用额度')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6097,'信用额度',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6097,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6098	,'信用期间')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6098,'信用期间',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6098,'',8)
/

insert into CRM_ContractType (name,contractdesc,workflowid) values ('产品销售合同','产品销售合同','0')
/
insert into CRM_ContractType (name,contractdesc,workflowid) values ('服务合同','服务合同','0')
/

insert into CRM_CustomerCredit (CreditAmount,CreditTime) values ('1000000','30')
/
update HrmInfoMaintenance set hrmid='2'
/
delete FROM HomePageDesign where id = 11
/