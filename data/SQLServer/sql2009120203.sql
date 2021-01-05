CREATE TABLE workflow_billfunctionlist (
	billid int NOT NULL ,
	indaffirmance char(1) NULL ,
	indmouldtype char(1) NULL,
	indShowChart char(1) NULL
)
GO
INSERT INTO workflow_billfunctionlist values(50,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(10,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(46,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(180,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(162,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(22,'0','1','1')
GO
INSERT INTO workflow_billfunctionlist values(42,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(23,'0','1','1')
GO
INSERT INTO workflow_billfunctionlist values(41,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(40,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(47,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(48,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(39,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(161,'0','1','1')
GO
INSERT INTO workflow_billfunctionlist values(45,'0','1','1')
GO
INSERT INTO workflow_billfunctionlist values(11,'0','1','1')
GO
INSERT INTO workflow_billfunctionlist values(158,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(157,'0','1','1')
GO
INSERT INTO workflow_billfunctionlist values(156,'0','1','1')
GO
INSERT INTO workflow_billfunctionlist values(13,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(7,'0','1','0')
GO
INSERT INTO workflow_billfunctionlist values(159,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(154,'1','0','1')
GO
INSERT INTO workflow_billfunctionlist values(14,'0','1','0')
GO
INSERT INTO workflow_billfunctionlist values(15,'0','1','0')
GO
INSERT INTO workflow_billfunctionlist values(18,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(19,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(201,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(220,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(221,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(222,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(224,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(163,'1','1','1')
GO
INSERT INTO workflow_billfunctionlist values(17,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(21,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(6,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(85,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(49,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(38,'0','0','1')
GO
INSERT INTO workflow_billfunctionlist values(79,'1','0','0')
GO
INSERT INTO workflow_billfunctionlist values(74,'1','0','0')
GO
INSERT INTO workflow_billfunctionlist values(152,'1','0','1')
GO
INSERT INTO workflow_billfunctionlist values(28,'1','0','0')
GO
INSERT INTO workflow_billfunctionlist values(29,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(192,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(68,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(66,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(67,'0','0','0')
GO
INSERT INTO workflow_billfunctionlist values(145,'1','0','1')
GO
INSERT INTO workflow_billfunctionlist values(146,'1','0','1')
GO
INSERT INTO workflow_billfunctionlist values(147,'0','0','1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=50 and exists(select 1 from workflow_base where formid=50 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=50 and exists(select 1 from workflow_nodemode where formid=50 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=50 and exists(select 1 from workflow_base where formid=50 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=46 and exists(select 1 from workflow_base where formid=46 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=46 and exists(select 1 from workflow_nodemode where formid=46 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=46 and exists(select 1 from workflow_base where formid=46 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=180 and exists(select 1 from workflow_base where formid=180 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=180 and exists(select 1 from workflow_nodemode where formid=180 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=180 and exists(select 1 from workflow_base where formid=180 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=22 and exists(select 1 from workflow_base where formid=22 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=42 and exists(select 1 from workflow_base where formid=42 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=42 and exists(select 1 from workflow_nodemode where formid=42 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=23 and exists(select 1 from workflow_base where formid=23 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=41 and exists(select 1 from workflow_base where formid=41 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=41 and exists(select 1 from workflow_nodemode where formid=41 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=40 and exists(select 1 from workflow_base where formid=40 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=40 and exists(select 1 from workflow_nodemode where formid=40 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=47 and exists(select 1 from workflow_base where formid=47 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=47 and exists(select 1 from workflow_nodemode where formid=47 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=48 and exists(select 1 from workflow_base where formid=48 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=48 and exists(select 1 from workflow_nodemode where formid=48 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=39 and exists(select 1 from workflow_base where formid=39 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=39 and exists(select 1 from workflow_nodemode where formid=39 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=161 and exists(select 1 from workflow_base where formid=161 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=45 and exists(select 1 from workflow_base where formid=45 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=11 and exists(select 1 from workflow_base where formid=11 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=157 and exists(select 1 from workflow_base where formid=157 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=156 and exists(select 1 from workflow_base where formid=156 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=13 and exists(select 1 from workflow_base where formid=13 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=13 and exists(select 1 from workflow_nodemode where formid=13 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=7 and exists(select 1 from workflow_base where formid=7 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=7 and exists(select 1 from workflow_base where formid=7 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=154 and exists(select 1 from workflow_nodemode where formid=154 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=14 and exists(select 1 from workflow_base where formid=14 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=14 and exists(select 1 from workflow_nodemode where formid=14 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=14 and exists(select 1 from workflow_base where formid=14 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=15 and exists(select 1 from workflow_base where formid=15 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=15 and exists(select 1 from workflow_base where formid=15 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=18 and exists(select 1 from workflow_base where formid=18 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=18 and exists(select 1 from workflow_nodemode where formid=18 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=18 and exists(select 1 from workflow_base where formid=18 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=19 and exists(select 1 from workflow_base where formid=19 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=19 and exists(select 1 from workflow_nodemode where formid=19 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=19 and exists(select 1 from workflow_base where formid=19 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=201 and exists(select 1 from workflow_base where formid=201 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=201 and exists(select 1 from workflow_nodemode where formid=201 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=201 and exists(select 1 from workflow_base where formid=201 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=17 and exists(select 1 from workflow_base where formid=17 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=17 and exists(select 1 from workflow_nodemode where formid=17 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=17 and exists(select 1 from workflow_base where formid=17 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=21 and exists(select 1 from workflow_base where formid=21 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=21 and exists(select 1 from workflow_nodemode where formid=21 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=21 and exists(select 1 from workflow_base where formid=21 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=6 and exists(select 1 from workflow_base where formid=6 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=6 and exists(select 1 from workflow_nodemode where formid=6 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=6 and exists(select 1 from workflow_base where formid=6 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=85 and exists(select 1 from workflow_base where formid=85 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=85 and exists(select 1 from workflow_nodemode where formid=85 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=85 and exists(select 1 from workflow_base where formid=85 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=49 and exists(select 1 from workflow_base where formid=49 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=49 and exists(select 1 from workflow_nodemode where formid=49 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=38 and exists(select 1 from workflow_base where formid=38 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=38 and exists(select 1 from workflow_nodemode where formid=38 and  isprint='0')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=79 and exists(select 1 from workflow_nodemode where formid=79 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=79 and exists(select 1 from workflow_base where formid=79 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=74 and exists(select 1 from workflow_nodemode where formid=74 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=74 and exists(select 1 from workflow_base where formid=74 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=152 and exists(select 1 from workflow_nodemode where formid=152 and  isprint='0')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=28 and exists(select 1 from workflow_nodemode where formid=28 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=28 and exists(select 1 from workflow_base where formid=28 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=29 and exists(select 1 from workflow_base where formid=29 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=29 and exists(select 1 from workflow_nodemode where formid=29 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=29 and exists(select 1 from workflow_base where formid=29 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=192 and exists(select 1 from workflow_base where formid=192 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=192 and exists(select 1 from workflow_nodemode where formid=192 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=192 and exists(select 1 from workflow_base where formid=192 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=68 and exists(select 1 from workflow_base where formid=68 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=68 and exists(select 1 from workflow_nodemode where formid=68 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=68 and exists(select 1 from workflow_base where formid=68 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=66 and exists(select 1 from workflow_base where formid=66 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=66 and exists(select 1 from workflow_nodemode where formid=66 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=66 and exists(select 1 from workflow_base where formid=66 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=67 and exists(select 1 from workflow_base where formid=67 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=67 and exists(select 1 from workflow_nodemode where formid=67 and  isprint='0')
GO
update workflow_billfunctionlist set indShowChart='1' where billid=67 and exists(select 1 from workflow_base where formid=67 and isbill='1' and isShowChart='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=145 and exists(select 1 from workflow_nodemode where formid=145 and  isprint='0')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=146 and exists(select 1 from workflow_nodemode where formid=146 and  isprint='0')
GO
update workflow_billfunctionlist set indaffirmance='1' where billid=147 and exists(select 1 from workflow_base where formid=147 and isbill='1' and needaffirmance='1')
GO
update workflow_billfunctionlist set indmouldtype='1' where billid=147 and exists(select 1 from workflow_nodemode where formid=147 and  isprint='0')
GO
