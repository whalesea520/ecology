drop TABLE HtmlLabelIndex
/

CREATE TABLE HtmlLabelIndex (
	id integer not null ,
	indexdesc varchar2 (400) 
)
/

delete HtmlLabelInfo where indexid < 16639 
/

alter table HtmlLabelIndex modify indexdesc varchar(400)
/

alter table HtmlLabelInfo modify labelname varchar(400)
/


insert into HtmlLabelIndex values(57,'部门导航') 
/
insert into HtmlLabelIndex values(58,'文档') 
/
insert into HtmlLabelIndex values(60,'维护') 
/
insert into HtmlLabelIndex values(61,'基本') 
/
insert into HtmlLabelIndex values(63,'类型') 
/
insert into HtmlLabelIndex values(64,'模板') 
/
insert into HtmlLabelIndex values(65,'主目录') 
/
insert into HtmlLabelIndex values(66,'分目录') 
/
insert into HtmlLabelIndex values(67,'子目录') 
/
insert into HtmlLabelIndex values(68,'设置') 
/
insert into HtmlLabelIndex values(70,'新闻页') 
/
insert into HtmlLabelIndex values(71,'邮件') 
/
insert into HtmlLabelIndex values(72,'常用工具') 
/
insert into HtmlLabelIndex values(73,'用户自定义') 
/
insert into HtmlLabelIndex values(74,'图片') 
/
insert into HtmlLabelIndex values(75,'上传') 
/
insert into HtmlLabelIndex values(76,'网站') 
/
insert into HtmlLabelIndex values(77,'复制') 
/
insert into HtmlLabelIndex values(78,'移动') 
/
insert into HtmlLabelIndex values(79,'所有者') 
/
insert into HtmlLabelIndex values(80,'转移') 
/
insert into HtmlLabelIndex values(81,'安装') 
/
insert into HtmlLabelIndex values(82,'新建') 
/
insert into HtmlLabelIndex values(83,'日志') 
/
insert into HtmlLabelIndex values(84,'标识') 
/
insert into HtmlLabelIndex values(85,'说明') 
/
insert into HtmlLabelIndex values(86,'保存') 
/
insert into HtmlLabelIndex values(87,'信息') 
/
insert into HtmlLabelIndex values(88,'顺序') 
/
insert into HtmlLabelIndex values(89,'显示') 
/
insert into HtmlLabelIndex values(91,'删除') 
/
insert into HtmlLabelIndex values(92,'目录') 
/
insert into HtmlLabelIndex values(93,'编辑') 
/
insert into HtmlLabelIndex values(95,'细节') 
/
insert into HtmlLabelIndex values(97,'日期') 
/
insert into HtmlLabelIndex values(99,'操作者') 
/
insert into HtmlLabelIndex values(101,'项目') 
/
insert into HtmlLabelIndex values(103,'修改') 
/
insert into HtmlLabelIndex values(104,'操作') 
/
insert into HtmlLabelIndex values(106,'对象') 
/
insert into HtmlLabelIndex values(108,'客户端') 
/
insert into HtmlLabelIndex values(110,'地址') 
/
insert into HtmlLabelIndex values(112,'设定') 
/
insert into HtmlLabelIndex values(114,'发布') 
/
insert into HtmlLabelIndex values(115,'允许') 
/
insert into HtmlLabelIndex values(117,'回复') 
/
insert into HtmlLabelIndex values(119,'共享') 
/
insert into HtmlLabelIndex values(120,'安全') 
/
insert into HtmlLabelIndex values(122,'角色') 
/
insert into HtmlLabelIndex values(124,'部门') 
/
insert into HtmlLabelIndex values(125,'创建') 
/
insert into HtmlLabelIndex values(127,'人') 
/
insert into HtmlLabelIndex values(129,'申请') 
/
insert into HtmlLabelIndex values(130,'承包商') 
/
insert into HtmlLabelIndex values(131,'雇员') 
/
insert into HtmlLabelIndex values(132,'代理商') 
/
insert into HtmlLabelIndex values(134,'学生') 
/
insert into HtmlLabelIndex values(136,'客户') 
/
insert into HtmlLabelIndex values(138,'供应商') 
/
insert into HtmlLabelIndex values(139,'级别') 
/
insert into HtmlLabelIndex values(140,'总部') 
/
insert into HtmlLabelIndex values(141,'分部') 
/
insert into HtmlLabelIndex values(142,'批准') 
/
insert into HtmlLabelIndex values(144,'经理') 
/
insert into HtmlLabelIndex values(145,'物品') 
/
insert into HtmlLabelIndex values(147,'CRM') 
/
insert into HtmlLabelIndex values(149,'默认') 
/
insert into HtmlLabelIndex values(151,'最高') 
/
insert into HtmlLabelIndex values(154,'一般') 
/
insert into HtmlLabelIndex values(155,'活跃') 
/
insert into HtmlLabelIndex values(156,'附件') 
/
insert into HtmlLabelIndex values(158,'数目') 
/
insert into HtmlLabelIndex values(160,'使用') 
/
insert into HtmlLabelIndex values(161,'否') 
/
insert into HtmlLabelIndex values(163,'是') 
/
insert into HtmlLabelIndex values(165,'未使用') 
/
insert into HtmlLabelIndex values(166,'可选择') 
/
insert into HtmlLabelIndex values(168,'强制性') 
/
insert into HtmlLabelIndex values(169,'状况') 
/
insert into HtmlLabelIndex values(170,'将来') 
/
insert into HtmlLabelIndex values(172,'选择') 
/
insert into HtmlLabelIndex values(174,'例子') 
/
insert into HtmlLabelIndex values(176,'标签') 
/
insert into HtmlLabelIndex values(178,'类别') 
/
insert into HtmlLabelIndex values(179,'人力资源') 
/
insert into HtmlLabelIndex values(181,'雇用') 
/
insert into HtmlLabelIndex values(182,'合伙人') 
/
insert into HtmlLabelIndex values(183,'prospect') 
/
insert into HtmlLabelIndex values(185,'银行') 
/
insert into HtmlLabelIndex values(187,'交易') 
/
insert into HtmlLabelIndex values(189,'财务') 
/
insert into HtmlLabelIndex values(191,'参考') 
/
insert into HtmlLabelIndex values(193,'加入') 
/
insert into HtmlLabelIndex values(195,'名称') 
/
insert into HtmlLabelIndex values(197,'搜索') 
/
insert into HtmlLabelIndex values(199,'重新设置') 
/
insert into HtmlLabelIndex values(201,'取消') 
/
insert into HtmlLabelIndex values(203,'宽度') 
/
insert into HtmlLabelIndex values(207,'高度') 
/
insert into HtmlLabelIndex values(209,'调整大小') 
/
insert into HtmlLabelIndex values(211,'调整图片类型1') 
/
insert into HtmlLabelIndex values(212,'调整图片类型2') 
/
insert into HtmlLabelIndex values(213,'调整图片类型3') 
/
insert into HtmlLabelIndex values(214,'调整图片类型4') 
/
insert into HtmlLabelIndex values(216,'合并') 
/
insert into HtmlLabelIndex values(218,'像素') 
/
insert into HtmlLabelIndex values(219,'字节') 
/
insert into HtmlLabelIndex values(220,'草稿') 
/
insert into HtmlLabelIndex values(221,'预览') 
/
insert into HtmlLabelIndex values(222,'Html') 
/
insert into HtmlLabelIndex values(224,'页眉') 
/
insert into HtmlLabelIndex values(225,'正常') 
/
insert into HtmlLabelIndex values(227,'主页') 
/
insert into HtmlLabelIndex values(229,'标题') 
/
insert into HtmlLabelIndex values(231,'语言') 
/
insert into HtmlLabelIndex values(233,'不') 
/
insert into HtmlLabelIndex values(235,'所有') 
/
insert into HtmlLabelIndex values(236,'退回') 
/
insert into HtmlLabelIndex values(244,'重新打开') 
/
insert into HtmlLabelIndex values(251,'归档') 
/
insert into HtmlLabelIndex values(256,'重载') 
/
insert into HtmlLabelIndex values(257,'打印') 
/
insert into HtmlLabelIndex values(258,'下载') 
/
insert into HtmlLabelIndex values(259,'工作流') 
/
insert into HtmlLabelIndex values(260,'阅读') 
/
insert into HtmlLabelIndex values(261,'字段') 
/
insert into HtmlLabelIndex values(264,'记录') 
/
insert into HtmlLabelIndex values(265,'每页') 
/
insert into HtmlLabelIndex values(271,'创建者') 
/
insert into HtmlLabelIndex values(275,'帮助') 
/
insert into HtmlLabelIndex values(277,'时间') 
/
insert into HtmlLabelIndex values(280,'尺寸') 
/
insert into HtmlLabelIndex values(293,'更改') 
/
insert into HtmlLabelIndex values(309,'关闭') 
/
insert into HtmlLabelIndex values(311,'清除') 
/
insert into HtmlLabelIndex values(316,'新闻') 
/
insert into HtmlLabelIndex values(320,'列表') 
/
insert into HtmlLabelIndex values(321,'每页记录') 
/
insert into HtmlLabelIndex values(322,'要闻') 
/
insert into HtmlLabelIndex values(323,'页脚') 
/
insert into HtmlLabelIndex values(324,'标准') 
/
insert into HtmlLabelIndex values(325,'大于或等于') 
/
insert into HtmlLabelIndex values(326,'小于或等于') 
/
insert into HtmlLabelIndex values(327,'等于') 
/
insert into HtmlLabelIndex values(328,'保留') 
/
insert into HtmlLabelIndex values(329,'天以内') 
/
insert into HtmlLabelIndex values(330,'目标') 
/
insert into HtmlLabelIndex values(331,'源') 
/
insert into HtmlLabelIndex values(332,'全部') 
/
insert into HtmlLabelIndex values(333,'按钮') 
/
insert into HtmlLabelIndex values(334,'背景') 
/
insert into HtmlLabelIndex values(335,'LOGO') 
/
insert into HtmlLabelIndex values(336,'比例') 
/
insert into HtmlLabelIndex values(337,'KB') 
/
insert into HtmlLabelIndex values(338,'排序') 
/
insert into HtmlLabelIndex values(339,'升序') 
/
insert into HtmlLabelIndex values(340,'降序') 
/
insert into HtmlLabelIndex values(341,'摘要') 
/
insert into HtmlLabelIndex values(342,'简单') 
/
insert into HtmlLabelIndex values(343,'定制') 
/
insert into HtmlLabelIndex values(344,'主题') 
/
insert into HtmlLabelIndex values(345,'内容') 
/
insert into HtmlLabelIndex values(346,'包含') 
/
insert into HtmlLabelIndex values(347,'高级') 
/
insert into HtmlLabelIndex values(348,'从') 
/
insert into HtmlLabelIndex values(349,'到') 
/
insert into HtmlLabelIndex values(350,'另存为') 
/
insert into HtmlLabelIndex values(351,'报告') 
/
insert into HtmlLabelIndex values(352,'统计') 
/
insert into HtmlLabelIndex values(353,'属于') 
/
insert into HtmlLabelIndex values(354,'刷新') 
/
insert into HtmlLabelIndex values(355,'总数') 
/
insert into HtmlLabelIndex values(356,'结果') 
/
insert into HtmlLabelIndex values(357,'职位') 
/
insert into HtmlLabelIndex values(358,'合计') 
/
insert into HtmlLabelIndex values(359,'审批') 
/
insert into HtmlLabelIndex values(360,'打开') 
/
insert into HtmlLabelIndex values(361,'详细') 
/
insert into HtmlLabelIndex values(362,'员工') 
/
insert into HtmlLabelIndex values(363,'计数') 
/
insert into HtmlLabelIndex values(364,'重新搜索') 
/
insert into HtmlLabelIndex values(365,'新') 
/
insert into HtmlLabelIndex values(366,'招聘信息') 
/
insert into HtmlLabelIndex values(367,'查看') 
/
insert into HtmlLabelIndex values(368,'申请人') 
/
insert into HtmlLabelIndex values(369,'时间表') 
/
insert into HtmlLabelIndex values(370,'公众') 
/
insert into HtmlLabelIndex values(371,'假日') 
/
insert into HtmlLabelIndex values(372,'非一致') 
/
insert into HtmlLabelIndex values(374,'人事期间') 
/
insert into HtmlLabelIndex values(375,'其他') 
/
insert into HtmlLabelIndex values(376,'组织') 
/
insert into HtmlLabelIndex values(377,'国家') 
/
insert into HtmlLabelIndex values(378,'位置') 
/
insert into HtmlLabelIndex values(380,'工作') 
/
insert into HtmlLabelIndex values(381,'结构') 
/
insert into HtmlLabelIndex values(382,'职责') 
/
insert into HtmlLabelIndex values(383,'职能') 
/
insert into HtmlLabelIndex values(384,'技能') 
/
insert into HtmlLabelIndex values(385,'权限') 
/
insert into HtmlLabelIndex values(386,'预算') 
/
insert into HtmlLabelIndex values(387,'要素') 
/
insert into HtmlLabelIndex values(388,'主体') 
/
insert into HtmlLabelIndex values(389,'银行帐户') 
/
insert into HtmlLabelIndex values(390,'日') 
/
insert into HtmlLabelIndex values(391,'小时') 
/
insert into HtmlLabelIndex values(392,'星期一') 
/
insert into HtmlLabelIndex values(393,'星期二') 
/
insert into HtmlLabelIndex values(394,'星期三') 
/
insert into HtmlLabelIndex values(395,'星期四') 
/
insert into HtmlLabelIndex values(396,'星期五') 
/
insert into HtmlLabelIndex values(397,'星期六') 
/
insert into HtmlLabelIndex values(398,'星期日') 
/
insert into HtmlLabelIndex values(399,'简称') 
/
insert into HtmlLabelIndex values(400,'未定义') 
/
insert into HtmlLabelIndex values(401,'建立') 
/
insert into HtmlLabelIndex values(402,'增值税') 
/
insert into HtmlLabelIndex values(403,'号码') 
/
insert into HtmlLabelIndex values(404,'起始') 
/
insert into HtmlLabelIndex values(405,'结束') 
/
insert into HtmlLabelIndex values(406,'币种') 
/
insert into HtmlLabelIndex values(407,'计划') 
/
insert into HtmlLabelIndex values(408,'能力') 
/
insert into HtmlLabelIndex values(409,'密码') 
/
insert into HtmlLabelIndex values(410,'其它信息') 
/
insert into HtmlLabelIndex values(411,'个人资料') 
/
insert into HtmlLabelIndex values(412,'登录名') 
/
insert into HtmlLabelIndex values(413,'姓名') 
/
insert into HtmlLabelIndex values(415,'不活跃') 
/
insert into HtmlLabelIndex values(416,'性别') 
/
insert into HtmlLabelIndex values(417,'男性') 
/
insert into HtmlLabelIndex values(418,'女性') 
/
insert into HtmlLabelIndex values(419,'工作地址') 
/
insert into HtmlLabelIndex values(420,'办公室') 
/
insert into HtmlLabelIndex values(421,'电话') 
/
insert into HtmlLabelIndex values(422,'手机') 
/
insert into HtmlLabelIndex values(423,'存在') 
/
insert into HtmlLabelIndex values(424,'修改者') 
/
insert into HtmlLabelIndex values(425,'成本') 
/
insert into HtmlLabelIndex values(426,'中心') 
/
insert into HtmlLabelIndex values(427,'总帐') 
/
insert into HtmlLabelIndex values(428,'收支') 
/
insert into HtmlLabelIndex values(430,'参与') 
/
insert into HtmlLabelIndex values(431,'成员') 
/
insert into HtmlLabelIndex values(432,'工作类型') 
/
insert into HtmlLabelIndex values(433,'描述') 
/
insert into HtmlLabelIndex values(434,'涉及') 
/
insert into HtmlLabelIndex values(436,'批准者') 
/
insert into HtmlLabelIndex values(437,'实现者') 
/
insert into HtmlLabelIndex values(438,'处理者') 
/
insert into HtmlLabelIndex values(439,'审批者') 
/
insert into HtmlLabelIndex values(440,'权限项') 
/
insert into HtmlLabelIndex values(441,'助理') 
/
insert into HtmlLabelIndex values(442,'下属') 
/
insert into HtmlLabelIndex values(443,'最后登录日期') 
/
insert into HtmlLabelIndex values(444,'寻呼') 
/
insert into HtmlLabelIndex values(445,'年') 
/
insert into HtmlLabelIndex values(446,'期间') 
/
insert into HtmlLabelIndex values(447,'变动') 
/
insert into HtmlLabelIndex values(448,'薪资') 
/
insert into HtmlLabelIndex values(449,'计算') 
/
insert into HtmlLabelIndex values(450,'相关时间') 
/
insert into HtmlLabelIndex values(451,'最小') 
/
insert into HtmlLabelIndex values(452,'倍数') 
/
insert into HtmlLabelIndex values(453,'固定值') 
/
insert into HtmlLabelIndex values(454,'备注') 
/
insert into HtmlLabelIndex values(455,'分类') 
/
insert into HtmlLabelIndex values(456,'增加') 
/
insert into HtmlLabelIndex values(457,'减少') 
/
insert into HtmlLabelIndex values(458,'休息日') 
/
insert into HtmlLabelIndex values(459,'固定') 
/
insert into HtmlLabelIndex values(460,'名字') 
/
insert into HtmlLabelIndex values(461,'姓') 
/
insert into HtmlLabelIndex values(462,'称呼') 
/
insert into HtmlLabelIndex values(463,'未知') 
/
insert into HtmlLabelIndex values(464,'出生日期') 
/
insert into HtmlLabelIndex values(465,'国籍') 
/
insert into HtmlLabelIndex values(466,'P&amp;L') 
/
insert into HtmlLabelIndex values(467,'口语') 
/
insert into HtmlLabelIndex values(468,'系统') 
/
insert into HtmlLabelIndex values(469,'婚姻状况') 
/
insert into HtmlLabelIndex values(470,'未婚') 
/
insert into HtmlLabelIndex values(471,'已婚') 
/
insert into HtmlLabelIndex values(472,'离异') 
/
insert into HtmlLabelIndex values(473,'同居') 
/
insert into HtmlLabelIndex values(474,'结婚日期') 
/
insert into HtmlLabelIndex values(475,'别名') 
/
insert into HtmlLabelIndex values(476,'办公信息') 
/
insert into HtmlLabelIndex values(477,'电子邮件') 
/
insert into HtmlLabelIndex values(478,'家庭信息') 
/
insert into HtmlLabelIndex values(479,'邮政编码') 
/
insert into HtmlLabelIndex values(480,'临时') 
/
insert into HtmlLabelIndex values(481,'起始日') 
/
insert into HtmlLabelIndex values(482,'合同终止日期') 
/
insert into HtmlLabelIndex values(483,'系统停止日期') 
/
insert into HtmlLabelIndex values(484,'工作级别') 
/
insert into HtmlLabelIndex values(485,'采购限制') 
/
insert into HtmlLabelIndex values(486,'社会安全号') 
/
insert into HtmlLabelIndex values(487,'信用卡') 
/
insert into HtmlLabelIndex values(488,'到期日') 
/
insert into HtmlLabelIndex values(490,'日历') 
/
insert into HtmlLabelIndex values(491,'清单') 
/
insert into HtmlLabelIndex values(492,'权限组') 
/
insert into HtmlLabelIndex values(493,'城市') 
/
insert into HtmlLabelIndex values(494,'传真') 
/
insert into HtmlLabelIndex values(495,'颜色') 
/
insert into HtmlLabelIndex values(496,'天数') 
/
insert into HtmlLabelIndex values(497,'外键') 
/
insert into HtmlLabelIndex values(498,'失败') 
/
insert into HtmlLabelIndex values(499,'前面') 
/
insert into HtmlLabelIndex values(500,'后面') 
/
insert into HtmlLabelIndex values(501,'确认密码') 
/
insert into HtmlLabelIndex values(502,'旧') 
/
insert into HtmlLabelIndex values(503,'工资单') 
/
insert into HtmlLabelIndex values(504,'意见') 
/
insert into HtmlLabelIndex values(505,'文档类型') 
/
insert into HtmlLabelIndex values(506,'文档模板') 
/
insert into HtmlLabelIndex values(507,'图片上传') 
/
insert into HtmlLabelIndex values(508,'文档复制转移') 
/
insert into HtmlLabelIndex values(509,'默认时间表') 
/
insert into HtmlLabelIndex values(510,'部门时间表') 
/
insert into HtmlLabelIndex values(511,'人力资源时间表') 
/
insert into HtmlLabelIndex values(512,'非一致工作时间') 
/
insert into HtmlLabelIndex values(513,'成本中心主目录') 
/
insert into HtmlLabelIndex values(514,'成本中心分目录') 
/
insert into HtmlLabelIndex values(515,'成本中心') 
/
insert into HtmlLabelIndex values(516,'公共假日') 
/
insert into HtmlLabelIndex values(517,'地区') 
/
insert into HtmlLabelIndex values(518,'工作职责') 
/
insert into HtmlLabelIndex values(519,'工作职能') 
/
insert into HtmlLabelIndex values(520,'工作技能') 
/
insert into HtmlLabelIndex values(521,'财务要素主体') 
/
insert into HtmlLabelIndex values(522,'相关') 
/
insert into HtmlLabelIndex values(523,'总计') 
/
insert into HtmlLabelIndex values(524,'当前') 
/
insert into HtmlLabelIndex values(525,'前一次') 
/
insert into HtmlLabelIndex values(526,'平均') 
/
insert into HtmlLabelIndex values(527,'查询') 
/
insert into HtmlLabelIndex values(528,'房间') 
/
insert into HtmlLabelIndex values(529,'全球') 
/
insert into HtmlLabelIndex values(530,'开始') 
/
insert into HtmlLabelIndex values(531,'快捷方式') 
/
insert into HtmlLabelIndex values(532,'培训') 
/
insert into HtmlLabelIndex values(533,'财务要素') 
/
insert into HtmlLabelIndex values(534,'金额') 
/
insert into HtmlLabelIndex values(535,'资产') 
/
insert into HtmlLabelIndex values(536,'津贴') 
/
insert into HtmlLabelIndex values(537,'减出') 
/
insert into HtmlLabelIndex values(538,'每半年') 
/
insert into HtmlLabelIndex values(539,'每日') 
/
insert into HtmlLabelIndex values(540,'每小时') 
/
insert into HtmlLabelIndex values(541,'每月') 
/
insert into HtmlLabelIndex values(542,'只一次') 
/
insert into HtmlLabelIndex values(543,'每季度') 
/
insert into HtmlLabelIndex values(544,'每两周') 
/
insert into HtmlLabelIndex values(545,'每周') 
/
insert into HtmlLabelIndex values(546,'每年') 
/
insert into HtmlLabelIndex values(547,'在线') 
/
insert into HtmlLabelIndex values(548,'含税') 
/
insert into HtmlLabelIndex values(549,'税后') 
/
insert into HtmlLabelIndex values(550,'总帐帐户') 
/
insert into HtmlLabelIndex values(551,'加入一行') 
/
insert into HtmlLabelIndex values(552,'私人') 
/
insert into HtmlLabelIndex values(553,'处理') 
/
insert into HtmlLabelIndex values(554,'输入') 
/
insert into HtmlLabelIndex values(555,'完成') 
/
insert into HtmlLabelIndex values(556,'全选') 
/
insert into HtmlLabelIndex values(557,'无') 
/
insert into HtmlLabelIndex values(558,'提示') 
/
insert into HtmlLabelIndex values(559,'屏蔽检查') 
/
insert into HtmlLabelIndex values(560,'其他信息类型') 
/
insert into HtmlLabelIndex values(561,'参数') 
/
insert into HtmlLabelIndex values(562,'组织图表') 
/
insert into HtmlLabelIndex values(563,'数据') 
/
insert into HtmlLabelIndex values(564,'指示器') 
/
insert into HtmlLabelIndex values(565,'工作时间参数') 
/
insert into HtmlLabelIndex values(566,'收入') 
/
insert into HtmlLabelIndex values(567,'版本') 
/
insert into HtmlLabelIndex values(568,'缩写') 
/
insert into HtmlLabelIndex values(569,'联系方法') 
/
insert into HtmlLabelIndex values(570,'空闲字段') 
/
insert into HtmlLabelIndex values(571,'帐户') 
/
insert into HtmlLabelIndex values(572,'联系人') 
/
insert into HtmlLabelIndex values(573,'Delivery Methods') 
/
insert into HtmlLabelIndex values(574,'市场销售') 
/
insert into HtmlLabelIndex values(575,'行业') 
/
insert into HtmlLabelIndex values(576,'规模') 
/
insert into HtmlLabelIndex values(577,'支付方式') 
/
insert into HtmlLabelIndex values(578,'分级') 
/
insert into HtmlLabelIndex values(579,'规则') 
/
insert into HtmlLabelIndex values(580,'信用等级') 
/
insert into HtmlLabelIndex values(581,'累计合同金额') 
/
insert into HtmlLabelIndex values(582,'门户') 
/
insert into HtmlLabelIndex values(583,'前缀') 
/
insert into HtmlLabelIndex values(584,'后缀') 
/
insert into HtmlLabelIndex values(585,'科目') 
/
insert into HtmlLabelIndex values(586,'项目类型') 
/
insert into HtmlLabelIndex values(587,'项目状态') 
/
insert into HtmlLabelIndex values(588,'汇率') 
/
insert into HtmlLabelIndex values(589,'还原') 
/
insert into HtmlLabelIndex values(590,'代码') 
/
insert into HtmlLabelIndex values(591,'上级客户') 
/
insert into HtmlLabelIndex values(593,'等级名称') 
/
insert into HtmlLabelIndex values(594,'上限') 
/
insert into HtmlLabelIndex values(595,'下限') 
/
insert into HtmlLabelIndex values(596,'上级') 
/
insert into HtmlLabelIndex values(597,'送货') 
/
insert into HtmlLabelIndex values(598,'发货') 
/
insert into HtmlLabelIndex values(599,'方式') 
/
insert into HtmlLabelIndex values(600,'运货') 
/
insert into HtmlLabelIndex values(601,'收货') 
/
insert into HtmlLabelIndex values(602,'状态') 
/
insert into HtmlLabelIndex values(603,'等级') 
/
insert into HtmlLabelIndex values(604,'方法') 
/
insert into HtmlLabelIndex values(605,'子行业') 
/
insert into HtmlLabelIndex values(606,'显示名') 
/
insert into HtmlLabelIndex values(607,'数字') 
/
insert into HtmlLabelIndex values(608,'文本') 
/
insert into HtmlLabelIndex values(609,'判断') 
/
insert into HtmlLabelIndex values(610,'项目卡') 
/
insert into HtmlLabelIndex values(611,'添加') 
/
insert into HtmlLabelIndex values(612,'名') 
/
insert into HtmlLabelIndex values(613,'原始') 
/
insert into HtmlLabelIndex values(614,'合同') 
/
insert into HtmlLabelIndex values(615,'提交') 
/
insert into HtmlLabelIndex values(616,'提交人') 
/
insert into HtmlLabelIndex values(617,'终止日') 
/
insert into HtmlLabelIndex values(618,'修改记录') 
/
insert into HtmlLabelIndex values(619,'住宅') 
/
insert into HtmlLabelIndex values(620,'移动电话') 
/
insert into HtmlLabelIndex values(621,'联系') 
/
insert into HtmlLabelIndex values(622,'情况') 
/
insert into HtmlLabelIndex values(623,'由') 
/
insert into HtmlLabelIndex values(624,'成员可见') 
/
insert into HtmlLabelIndex values(625,'是否客户主动') 
/
insert into HtmlLabelIndex values(626,'成员上级可见') 
/
insert into HtmlLabelIndex values(627,'上级成员可见') 
/
insert into HtmlLabelIndex values(628,'实际') 
/
insert into HtmlLabelIndex values(629,'支出') 
/
insert into HtmlLabelIndex values(630,'业务') 
/
insert into HtmlLabelIndex values(631,'抱怨') 
/
insert into HtmlLabelIndex values(632,'工时') 
/
insert into HtmlLabelIndex values(633,'管理') 
/
insert into HtmlLabelIndex values(634,'介绍') 
/
insert into HtmlLabelIndex values(635,'被动') 
/
insert into HtmlLabelIndex values(636,'上级项目') 
/
insert into HtmlLabelIndex values(637,'评价书') 
/
insert into HtmlLabelIndex values(638,'确认书') 
/
insert into HtmlLabelIndex values(639,'建议书') 
/
insert into HtmlLabelIndex values(640,'工作头衔') 
/
insert into HtmlLabelIndex values(642,'英文') 
/
insert into HtmlLabelIndex values(643,'省') 
/
insert into HtmlLabelIndex values(644,'县 ') 
/
insert into HtmlLabelIndex values(645,'获得途径') 
/
insert into HtmlLabelIndex values(646,'销售确认书') 
/
insert into HtmlLabelIndex values(647,'卡') 
/
insert into HtmlLabelIndex values(648,'请求') 
/
insert into HtmlLabelIndex values(649,'货币') 
/
insert into HtmlLabelIndex values(650,'信用金额修正') 
/
insert into HtmlLabelIndex values(651,'折扣率') 
/
insert into HtmlLabelIndex values(652,'支付类型') 
/
insert into HtmlLabelIndex values(653,'增值税号码') 
/
insert into HtmlLabelIndex values(655,'发票客户') 
/
insert into HtmlLabelIndex values(657,'交货方法') 
/
insert into HtmlLabelIndex values(658,'支付条件') 
/
insert into HtmlLabelIndex values(659,'类型从') 
/
insert into HtmlLabelIndex values(660,'全名') 
/
insert into HtmlLabelIndex values(661,'办公室电话') 
/
insert into HtmlLabelIndex values(662,'住宅电话') 
/
insert into HtmlLabelIndex values(663,'分录') 
/
insert into HtmlLabelIndex values(664,'登帐') 
/
insert into HtmlLabelIndex values(665,'监控') 
/
insert into HtmlLabelIndex values(666,'总分类帐') 
/
insert into HtmlLabelIndex values(667,'明细帐') 
/
insert into HtmlLabelIndex values(668,'分析') 
/
insert into HtmlLabelIndex values(669,'层次') 
/
insert into HtmlLabelIndex values(670,'请假') 
/
insert into HtmlLabelIndex values(671,'年龄') 
/
insert into HtmlLabelIndex values(672,'流入') 
/
insert into HtmlLabelIndex values(673,'流出') 
/
insert into HtmlLabelIndex values(674,'登录') 
/
insert into HtmlLabelIndex values(675,'评论') 
/
insert into HtmlLabelIndex values(676,'工作活动图表') 
/
insert into HtmlLabelIndex values(677,'邮件合并') 
/
insert into HtmlLabelIndex values(678,'活动') 
/
insert into HtmlLabelIndex values(679,'近期') 
/
insert into HtmlLabelIndex values(680,'期权') 
/
insert into HtmlLabelIndex values(681,'插入图片') 
/
insert into HtmlLabelIndex values(682,'后勤') 
/
insert into HtmlLabelIndex values(683,'安全级别') 
/
insert into HtmlLabelIndex values(684,'字段管理') 
/
insert into HtmlLabelIndex values(685,'字段名称') 
/
insert into HtmlLabelIndex values(686,'字段类型') 
/
insert into HtmlLabelIndex values(687,'表现形式') 
/
insert into HtmlLabelIndex values(688,'单行文本框') 
/
insert into HtmlLabelIndex values(689,'多行文本框') 
/
insert into HtmlLabelIndex values(690,'选择框') 
/
insert into HtmlLabelIndex values(691,'Check框') 
/
insert into HtmlLabelIndex values(694,'全部选择') 
/
insert into HtmlLabelIndex values(695,'浏览按钮') 
/
insert into HtmlLabelIndex values(696,'整数') 
/
insert into HtmlLabelIndex values(697,'浮点数') 
/
insert into HtmlLabelIndex values(698,'文本长度') 
/
insert into HtmlLabelIndex values(699,'表单管理') 
/
insert into HtmlLabelIndex values(700,'表单') 
/
insert into HtmlLabelIndex values(701,'增加字段') 
/
insert into HtmlLabelIndex values(702,'删除字段') 
/
insert into HtmlLabelIndex values(703,'资产类型') 
/
insert into HtmlLabelIndex values(704,'资产种类') 
/
insert into HtmlLabelIndex values(705,'计量单位') 
/
insert into HtmlLabelIndex values(706,'配置类型') 
/
insert into HtmlLabelIndex values(707,'核算方法') 
/
insert into HtmlLabelIndex values(708,'订货单') 
/
insert into HtmlLabelIndex values(709,'出货单') 
/
insert into HtmlLabelIndex values(710,'收付款方式') 
/
insert into HtmlLabelIndex values(711,'仓库') 
/
insert into HtmlLabelIndex values(712,'进出库方式') 
/
insert into HtmlLabelIndex values(713,'属性') 
/
insert into HtmlLabelIndex values(714,'编号') 
/
insert into HtmlLabelIndex values(715,'重新编号') 
/
insert into HtmlLabelIndex values(716,'种类') 
/
insert into HtmlLabelIndex values(717,'生效日') 
/
insert into HtmlLabelIndex values(718,'生效至') 
/
insert into HtmlLabelIndex values(719,'成本价格') 
/
insert into HtmlLabelIndex values(720,'采购价') 
/
insert into HtmlLabelIndex values(721,'销售价') 
/
insert into HtmlLabelIndex values(722,'创建日期') 
/
insert into HtmlLabelIndex values(723,'修改日期') 
/
insert into HtmlLabelIndex values(724,'配置') 
/
insert into HtmlLabelIndex values(725,'实现') 
/
insert into HtmlLabelIndex values(726,'价格') 
/
insert into HtmlLabelIndex values(727,'购物车') 
/
insert into HtmlLabelIndex values(728,'附属') 
/
insert into HtmlLabelIndex values(729,'关系') 
/
insert into HtmlLabelIndex values(730,'读取') 
/
insert into HtmlLabelIndex values(731,'用户信息') 
/
insert into HtmlLabelIndex values(732,'未完成') 
/
insert into HtmlLabelIndex values(733,'结束日') 
/
insert into HtmlLabelIndex values(734,'质量分析') 
/
insert into HtmlLabelIndex values(735,'网上订单') 
/
insert into HtmlLabelIndex values(736,'资产负债表') 
/
insert into HtmlLabelIndex values(737,'激活') 
/
insert into HtmlLabelIndex values(738,'资产购置计划') 
/
insert into HtmlLabelIndex values(739,'库存信息') 
/
insert into HtmlLabelIndex values(740,'开始日期') 
/
insert into HtmlLabelIndex values(741,'结束日期') 
/
insert into HtmlLabelIndex values(742,'开始时间') 
/
insert into HtmlLabelIndex values(743,'结束时间') 
/
insert into HtmlLabelIndex values(744,'损益表') 
/
insert into HtmlLabelIndex values(745,'买方') 
/
insert into HtmlLabelIndex values(746,'卖方') 
/
insert into HtmlLabelIndex values(747,'库存') 
/
insert into HtmlLabelIndex values(748,'出入库详细') 
/
insert into HtmlLabelIndex values(749,'出入库单据') 
/
insert into HtmlLabelIndex values(750,'出库单') 
/
insert into HtmlLabelIndex values(751,'入库单') 
/
insert into HtmlLabelIndex values(752,'入库单编号') 
/
insert into HtmlLabelIndex values(753,'入库日期') 
/
insert into HtmlLabelIndex values(754,'入库方式') 
/
insert into HtmlLabelIndex values(755,'入库单据') 
/
insert into HtmlLabelIndex values(756,'出库单编号 ') 
/
insert into HtmlLabelIndex values(757,'默认币种') 
/
insert into HtmlLabelIndex values(758,'默认币种进库总价') 
/
insert into HtmlLabelIndex values(759,'默认币种进库总税额') 
/
insert into HtmlLabelIndex values(760,'进库总价') 
/
insert into HtmlLabelIndex values(761,'进库总税额') 
/
insert into HtmlLabelIndex values(762,'出库方式 ') 
/
insert into HtmlLabelIndex values(763,'不限') 
/
insert into HtmlLabelIndex values(764,'高中') 
/
insert into HtmlLabelIndex values(765,'中专') 
/
insert into HtmlLabelIndex values(766,'大专') 
/
insert into HtmlLabelIndex values(767,'本科') 
/
insert into HtmlLabelIndex values(768,'硕士研究生') 
/
insert into HtmlLabelIndex values(769,'博士研究生') 
/
insert into HtmlLabelIndex values(770,'出库日期') 
/
insert into HtmlLabelIndex values(771,'合同编号 ') 
/
insert into HtmlLabelIndex values(772,'文档移动') 
/
insert into HtmlLabelIndex values(773,'应聘信息') 
/
insert into HtmlLabelIndex values(774,'系统设置') 
/
insert into HtmlLabelIndex values(775,'系统日志') 
/
insert into HtmlLabelIndex values(776,'重建数据库') 
/
insert into HtmlLabelIndex values(777,'科目－全部') 
/
insert into HtmlLabelIndex values(778,'科目－明细') 
/
insert into HtmlLabelIndex values(779,'会议室联系单') 
/
insert into HtmlLabelIndex values(780,'会议室') 
/
insert into HtmlLabelIndex values(781,'会议人数') 
/
insert into HtmlLabelIndex values(782,'相关项目') 
/
insert into HtmlLabelIndex values(783,'相关客户') 
/
insert into HtmlLabelIndex values(784,'提醒日期') 
/
insert into HtmlLabelIndex values(785,'提醒时间') 
/
insert into HtmlLabelIndex values(786,'个人计划') 
/
insert into HtmlLabelIndex values(787,'计划人') 
/
insert into HtmlLabelIndex values(788,'费用报销单') 
/
insert into HtmlLabelIndex values(789,'报销人') 
/
insert into HtmlLabelIndex values(790,'报销日期') 
/
insert into HtmlLabelIndex values(791,'事由') 
/
insert into HtmlLabelIndex values(792,'相关人员') 
/
insert into HtmlLabelIndex values(793,'相关请求') 
/
insert into HtmlLabelIndex values(794,'报销总金额') 
/
insert into HtmlLabelIndex values(795,'附件总数') 
/
insert into HtmlLabelIndex values(796,'借方科目') 
/
insert into HtmlLabelIndex values(797,'借方摘要') 
/
insert into HtmlLabelIndex values(798,'贷方科目') 
/
insert into HtmlLabelIndex values(799,'贷方摘要') 
/
insert into HtmlLabelIndex values(800,'省份') 
/
insert into HtmlLabelIndex values(801,'经度') 
/
insert into HtmlLabelIndex values(802,'纬度') 
/
insert into HtmlLabelIndex values(803,'专业') 
/
insert into HtmlLabelIndex values(804,'用工性质') 
/
insert into HtmlLabelIndex values(805,'职务类别') 
/
insert into HtmlLabelIndex values(806,'职称') 
/
insert into HtmlLabelIndex values(807,'培训类型') 
/
insert into HtmlLabelIndex values(808,'奖惩类型') 
/
insert into HtmlLabelIndex values(809,'奖励') 
/
insert into HtmlLabelIndex values(810,'惩罚') 
/
insert into HtmlLabelIndex values(811,'其它') 
/
insert into HtmlLabelIndex values(812,'工作简历') 
/
insert into HtmlLabelIndex values(813,'教育情况') 
/
insert into HtmlLabelIndex values(814,'家庭情况') 
/
insert into HtmlLabelIndex values(815,'语言能力') 
/
insert into HtmlLabelIndex values(816,'培训记录') 
/
insert into HtmlLabelIndex values(817,'奖惩记录') 
/
insert into HtmlLabelIndex values(818,'学历') 
/
insert into HtmlLabelIndex values(819,'初中') 
/
insert into HtmlLabelIndex values(820,'中技') 
/
insert into HtmlLabelIndex values(821,'良好') 
/
insert into HtmlLabelIndex values(822,'熟练') 
/
insert into HtmlLabelIndex values(823,'精通') 
/
insert into HtmlLabelIndex values(824,'优秀') 
/
insert into HtmlLabelIndex values(825,'较差') 
/
insert into HtmlLabelIndex values(826,'确定') 
/
insert into HtmlLabelIndex values(827,'请假人') 
/
insert into HtmlLabelIndex values(828,'请假天数') 
/
insert into HtmlLabelIndex values(829,'请假单') 
/
insert into HtmlLabelIndex values(830,'资产状态') 
/
insert into HtmlLabelIndex values(831,'资产组') 
/
insert into HtmlLabelIndex values(832,'子资产组') 
/
insert into HtmlLabelIndex values(833,'培训学时') 
/
insert into HtmlLabelIndex values(834,'培训人数') 
/
insert into HtmlLabelIndex values(835,'折旧法一') 
/
insert into HtmlLabelIndex values(836,'折旧法二') 
/
insert into HtmlLabelIndex values(837,'资产折旧法') 
/
insert into HtmlLabelIndex values(838,'联系实施人') 
/
insert into HtmlLabelIndex values(839,'多人力资源') 
/
insert into HtmlLabelIndex values(840,'多客户') 
/
insert into HtmlLabelIndex values(841,'项目计划') 
/
insert into HtmlLabelIndex values(842,'计划类型') 
/
insert into HtmlLabelIndex values(843,'计划种类') 
/
insert into HtmlLabelIndex values(844,'参考文档') 
/
insert into HtmlLabelIndex values(845,'预算金额') 
/
insert into HtmlLabelIndex values(846,'子项目') 
/
insert into HtmlLabelIndex values(847,'进度') 
/
insert into HtmlLabelIndex values(848,'重要性') 
/
insert into HtmlLabelIndex values(849,'加班申请') 
/
insert into HtmlLabelIndex values(850,'加班人') 
/
insert into HtmlLabelIndex values(851,'加班原因') 
/
insert into HtmlLabelIndex values(852,'总天数') 
/
insert into HtmlLabelIndex values(853,'总小时数') 
/
insert into HtmlLabelIndex values(854,'报销费用类型') 
/
insert into HtmlLabelIndex values(855,'申请日期') 
/
insert into HtmlLabelIndex values(856,'申请金额') 
/
insert into HtmlLabelIndex values(857,'相关文档') 
/
insert into HtmlLabelIndex values(858,'相关资产') 
/
insert into HtmlLabelIndex values(859,'申请原因') 
/
insert into HtmlLabelIndex values(860,'费用申请') 
/
insert into HtmlLabelIndex values(861,'原因') 
/
insert into HtmlLabelIndex values(862,'私人借款还款单') 
/
insert into HtmlLabelIndex values(863,'主分类') 
/
insert into HtmlLabelIndex values(864,'计划部门') 
/
insert into HtmlLabelIndex values(865,'计划人员') 
/
insert into HtmlLabelIndex values(866,'总计划金额') 
/
insert into HtmlLabelIndex values(867,'相关客户2') 
/
insert into HtmlLabelIndex values(868,'相关文档2') 
/
insert into HtmlLabelIndex values(869,'申购部门') 
/
insert into HtmlLabelIndex values(870,'申购人员') 
/
insert into HtmlLabelIndex values(871,'用途') 
/
insert into HtmlLabelIndex values(872,'资产申购单') 
/
insert into HtmlLabelIndex values(873,'报价人') 
/
insert into HtmlLabelIndex values(874,'凭证号') 
/
insert into HtmlLabelIndex values(875,'一周工作情况单') 
/
insert into HtmlLabelIndex values(876,'月工作计划单') 
/
insert into HtmlLabelIndex values(877,'月工作总结单') 
/
insert into HtmlLabelIndex values(878,'资产需求') 
/
insert into HtmlLabelIndex values(879,'申够个数') 
/
insert into HtmlLabelIndex values(880,'调拨个数') 
/
insert into HtmlLabelIndex values(881,'领用个数') 
/
insert into HtmlLabelIndex values(882,'创建人') 
/
insert into HtmlLabelIndex values(883,'资产调拨') 
/
insert into HtmlLabelIndex values(884,'原属部门') 
/
insert into HtmlLabelIndex values(885,'原属部门经理') 
/
insert into HtmlLabelIndex values(886,'资产领用') 
/
insert into HtmlLabelIndex values(887,'月份') 
/
insert into HtmlLabelIndex values(888,'原因分析') 
/
insert into HtmlLabelIndex values(889,'建设性意见') 
/
insert into HtmlLabelIndex values(890,'录用通知单') 
/
insert into HtmlLabelIndex values(891,'离职通知单') 
/
insert into HtmlLabelIndex values(892,'总部预算定制单') 
/
insert into HtmlLabelIndex values(893,'被录用人') 
/
insert into HtmlLabelIndex values(894,'用人部门') 
/
insert into HtmlLabelIndex values(895,'任职资格') 
/
insert into HtmlLabelIndex values(896,'接收者') 
/
insert into HtmlLabelIndex values(897,'离职人') 
/
insert into HtmlLabelIndex values(898,'离职时间') 
/
insert into HtmlLabelIndex values(899,'离职说明') 
/
insert into HtmlLabelIndex values(900,'发票号码') 
/
insert into HtmlLabelIndex values(901,'验收人') 
/
insert into HtmlLabelIndex values(902,'验收仓库') 
/
insert into HtmlLabelIndex values(903,'资产编号') 
/
insert into HtmlLabelIndex values(904,'规格型号') 
/
insert into HtmlLabelIndex values(905,'应收数量') 
/
insert into HtmlLabelIndex values(906,'实收数量') 
/
insert into HtmlLabelIndex values(907,'计划价格') 
/
insert into HtmlLabelIndex values(908,'实际价格') 
/
insert into HtmlLabelIndex values(909,'计划金额') 
/
insert into HtmlLabelIndex values(910,'实际金额') 
/
insert into HtmlLabelIndex values(911,'价格差异') 
/
insert into HtmlLabelIndex values(912,'验收入库') 
/
insert into HtmlLabelIndex values(913,'采购人') 
/
insert into HtmlLabelIndex values(914,'交来单位部门') 
/
insert into HtmlLabelIndex values(915,'资产盘点') 
/
insert into HtmlLabelIndex values(916,'盘点人员') 
/
insert into HtmlLabelIndex values(917,'盘点人员2') 
/
insert into HtmlLabelIndex values(918,'盘点部门') 
/
insert into HtmlLabelIndex values(919,'盘点时间') 
/
insert into HtmlLabelIndex values(920,'车辆') 
/
insert into HtmlLabelIndex values(921,'驱车记录') 
/
insert into HtmlLabelIndex values(922,'车辆费用报销') 
/
insert into HtmlLabelIndex values(923,'车辆保养') 
/
insert into HtmlLabelIndex values(924,'车辆维修') 
/
insert into HtmlLabelIndex values(925,'办公用品领用') 
/
insert into HtmlLabelIndex values(926,'相关会议') 
/
insert into HtmlLabelIndex values(1000,'指标下达人') 
/
insert into HtmlLabelIndex values(1001,'指标下达部门') 
/
insert into HtmlLabelIndex values(1002,'相关指标') 
/
insert into HtmlLabelIndex values(1003,'批准工作流') 
/
insert into HtmlLabelIndex values(1004,'审批流转单') 
/
insert into HtmlLabelIndex values(1005,'批注通过') 
/
insert into HtmlLabelIndex values(1006,'批注') 
/
insert into HtmlLabelIndex values(1007,'签字') 
/
insert into HtmlLabelIndex values(1008,'审批意见') 
/
insert into HtmlLabelIndex values(1009,'审批通过') 
/
insert into HtmlLabelIndex values(1010,'审批退回') 
/
insert into HtmlLabelIndex values(1011,'预算费用类型') 
/
insert into HtmlLabelIndex values(1012,'本部门费用预算表') 
/
insert into HtmlLabelIndex values(1013,'全年') 
/
insert into HtmlLabelIndex values(1014,'样式') 
/
insert into HtmlLabelIndex values(1015,'按部门统计') 
/
insert into HtmlLabelIndex values(1016,'按预算费用统计') 
/
insert into HtmlLabelIndex values(1017,'领用资产列表') 
/
insert into HtmlLabelIndex values(1018,'领用资产规格') 
/
insert into HtmlLabelIndex values(1019,'领用资产数量') 
/
insert into HtmlLabelIndex values(1020,'邮箱申请') 
/
insert into HtmlLabelIndex values(1021,'申请帐户名（英文或拼音）') 
/
insert into HtmlLabelIndex values(1022,'承诺协议') 
/
insert into HtmlLabelIndex values(1023,'名片印制') 
/
insert into HtmlLabelIndex values(1024,'印制盒数') 
/
insert into HtmlLabelIndex values(1025,'选项') 
/
insert into HtmlLabelIndex values(1026,'总费用') 
/
insert into HtmlLabelIndex values(1027,'宾馆预定') 
/
insert into HtmlLabelIndex values(1028,'入住时间') 
/
insert into HtmlLabelIndex values(1029,'退房时间') 
/
insert into HtmlLabelIndex values(1030,'住宿人') 
/
insert into HtmlLabelIndex values(1031,'报销标准') 
/
insert into HtmlLabelIndex values(1032,'具体标准') 
/
insert into HtmlLabelIndex values(1033,'需财务总裁确定') 
/
insert into HtmlLabelIndex values(1034,'是否超标') 
/
insert into HtmlLabelIndex values(1035,'完成日期') 
/
insert into HtmlLabelIndex values(1036,'完成时间') 
/
insert into HtmlLabelIndex values(1037,'工作提醒') 
/
insert into HtmlLabelIndex values(1038,'会议日程') 
/
insert into HtmlLabelIndex values(1039,'部门月工作汇总表') 
/
insert into HtmlLabelIndex values(1040,'借款人') 
/
insert into HtmlLabelIndex values(1041,'需要时间') 
/
insert into HtmlLabelIndex values(1042,'预计还款时间') 
/
insert into HtmlLabelIndex values(1043,'借款金额') 
/
insert into HtmlLabelIndex values(1044,'相关流程') 
/
insert into HtmlLabelIndex values(1045,'启用帐户名') 
/
insert into HtmlLabelIndex values(1046,'启用时间') 
/
insert into HtmlLabelIndex values(1047,'经办人') 
/
insert into HtmlLabelIndex values(1048,'印刷单位') 
/
insert into HtmlLabelIndex values(1049,'单号') 
/
insert into HtmlLabelIndex values(1050,'交货日期') 
/
insert into HtmlLabelIndex values(1051,'预定公司') 
/
insert into HtmlLabelIndex values(1052,'个人财务销帐') 
/
insert into HtmlLabelIndex values(1053,'个人往来明细') 
/
insert into HtmlLabelIndex values(1054,'业务招待费报销') 
/
insert into HtmlLabelIndex values(1055,'招待人数') 
/
insert into HtmlLabelIndex values(1056,'招待日期') 
/
insert into HtmlLabelIndex values(1057,'招待对象') 
/
insert into HtmlLabelIndex values(1058,'消费形式') 
/
insert into HtmlLabelIndex values(1059,'消费地点') 
/
insert into HtmlLabelIndex values(1060,'消费目的') 
/
insert into HtmlLabelIndex values(1201,'晚上好') 
/
insert into HtmlLabelIndex values(1202,'上午好') 
/
insert into HtmlLabelIndex values(1203,'中午好') 
/
insert into HtmlLabelIndex values(1204,'下午好') 
/
insert into HtmlLabelIndex values(1205,'退出') 
/
insert into HtmlLabelIndex values(1207,'待办事宜') 
/
insert into HtmlLabelIndex values(1208,'我的CRM') 
/
insert into HtmlLabelIndex values(1209,'我的资产') 
/
insert into HtmlLabelIndex values(1210,'我的请求') 
/
insert into HtmlLabelIndex values(1211,'我的项目') 
/
insert into HtmlLabelIndex values(1212,'我的文档') 
/
insert into HtmlLabelIndex values(1213,'我的邮件') 
/
insert into HtmlLabelIndex values(1214,'文档 - 近期') 
/
insert into HtmlLabelIndex values(1215,'文档 - 目录') 
/
insert into HtmlLabelIndex values(1216,'统计 - 基本信息') 
/
insert into HtmlLabelIndex values(1217,'统计 - 管理') 
/
insert into HtmlLabelIndex values(1218,'统计 - 客户信息') 
/
insert into HtmlLabelIndex values(1219,'获得方式') 
/
insert into HtmlLabelIndex values(1220,'地理分布') 
/
insert into HtmlLabelIndex values(1221,'客户联系情况') 
/
insert into HtmlLabelIndex values(1222,'客户共享情况') 
/
insert into HtmlLabelIndex values(1223,'登录 - 近期') 
/
insert into HtmlLabelIndex values(1224,'修改 - 近期') 
/
insert into HtmlLabelIndex values(1225,'读取 - 近期') 
/
insert into HtmlLabelIndex values(1226,'邮件发送') 
/
insert into HtmlLabelIndex values(1227,'批准->基础客户') 
/
insert into HtmlLabelIndex values(1228,'批准->潜在客户') 
/
insert into HtmlLabelIndex values(1229,'批准->成功客户') 
/
insert into HtmlLabelIndex values(1230,'批准->试点客户') 
/
insert into HtmlLabelIndex values(1231,'批准->典型客户') 
/
insert into HtmlLabelIndex values(1232,'冻结') 
/
insert into HtmlLabelIndex values(1233,'解冻') 
/
insert into HtmlLabelIndex values(1234,'门户申请') 
/
insert into HtmlLabelIndex values(1235,'门户批准') 
/
insert into HtmlLabelIndex values(1236,'门户冻结') 
/
insert into HtmlLabelIndex values(1237,'门户激活') 
/
insert into HtmlLabelIndex values(1238,'门户密码重生成') 
/
insert into HtmlLabelIndex values(1239,'新建工作流') 
/
insert into HtmlLabelIndex values(1240,'门户状态') 
/
insert into HtmlLabelIndex values(1241,'未开通') 
/
insert into HtmlLabelIndex values(1242,'申请中') 
/
insert into HtmlLabelIndex values(1243,'直接转帐收款单') 
/
insert into HtmlLabelIndex values(1244,'银行直接汇票') 
/
insert into HtmlLabelIndex values(1245,'以CHF及外币的支付') 
/
insert into HtmlLabelIndex values(1246,'支票') 
/
insert into HtmlLabelIndex values(1247,'直接转帐') 
/
insert into HtmlLabelIndex values(1248,'收款') 
/
insert into HtmlLabelIndex values(1249,'现金') 
/
insert into HtmlLabelIndex values(1250,'指定付款') 
/
insert into HtmlLabelIndex values(1251,'ESR支付') 
/
insert into HtmlLabelIndex values(1252,'汇票') 
/
insert into HtmlLabelIndex values(1253,'ES支付') 
/
insert into HtmlLabelIndex values(1254,'银行支票') 
/
insert into HtmlLabelIndex values(1255,'新增客户联系情况') 
/
insert into HtmlLabelIndex values(1256,'继续') 
/
insert into HtmlLabelIndex values(1258,'上一页') 
/
insert into HtmlLabelIndex values(1259,'下一页') 
/
insert into HtmlLabelIndex values(1260,'发件人Email地址') 
/
insert into HtmlLabelIndex values(1261,'发送到') 
/
insert into HtmlLabelIndex values(1262,'主联系人') 
/
insert into HtmlLabelIndex values(1263,'所有联系人') 
/
insert into HtmlLabelIndex values(1264,'版式') 
/
insert into HtmlLabelIndex values(1265,'正文') 
/
insert into HtmlLabelIndex values(1266,'客户代码') 
/
insert into HtmlLabelIndex values(1267,'交易方式') 
/
insert into HtmlLabelIndex values(1268,'客户名称') 
/
insert into HtmlLabelIndex values(1269,'客户没有科目信息') 
/
insert into HtmlLabelIndex values(1270,'上限金额') 
/
insert into HtmlLabelIndex values(1271,'下限金额') 
/
insert into HtmlLabelIndex values(1272,'读取时间') 
/
insert into HtmlLabelIndex values(1273,'读取人') 
/
insert into HtmlLabelIndex values(1275,'联系时间') 
/
insert into HtmlLabelIndex values(1276,'登录时间') 
/
insert into HtmlLabelIndex values(1278,'客户经理') 
/
insert into HtmlLabelIndex values(1279,'共享信息') 
/
insert into HtmlLabelIndex values(1280,'开通') 
/
insert into HtmlLabelIndex values(1281,'子分类') 
/
insert into HtmlLabelIndex values(1282,'客户类型') 
/
insert into HtmlLabelIndex values(1283,'客户描述') 
/
insert into HtmlLabelIndex values(1284,'客户状况') 
/
insert into HtmlLabelIndex values(1285,'客户规模') 
/
insert into HtmlLabelIndex values(1286,'项目新闻') 
/
insert into HtmlLabelIndex values(1287,'项目组织') 
/
insert into HtmlLabelIndex values(1288,'CRM 新闻') 
/
insert into HtmlLabelIndex values(1289,'CRM 组织') 
/
insert into HtmlLabelIndex values(1290,'返回') 
/
insert into HtmlLabelIndex values(1291,'项目权限') 
/
insert into HtmlLabelIndex values(1292,'查看基本信息') 
/
insert into HtmlLabelIndex values(1293,'查看详细信息') 
/
insert into HtmlLabelIndex values(1294,'项目简报') 
/
insert into HtmlLabelIndex values(1295,'计划&任务') 
/
insert into HtmlLabelIndex values(1296,'跟踪&监控') 
/
insert into HtmlLabelIndex values(1297,'分析报告') 
/
insert into HtmlLabelIndex values(1298,'工期') 
/
insert into HtmlLabelIndex values(1299,'人力成本') 
/
insert into HtmlLabelIndex values(1300,'设备成本') 
/
insert into HtmlLabelIndex values(1301,'材料成本') 
/
insert into HtmlLabelIndex values(1302,'固定资产调拨汇总表') 
/
insert into HtmlLabelIndex values(1303,'部门固定资产调出一栏表') 
/
insert into HtmlLabelIndex values(1304,'部门固定资产调入一栏表') 
/
insert into HtmlLabelIndex values(1305,'各部门固定资产采购计划表') 
/
insert into HtmlLabelIndex values(1306,'公司固定资产采购明细表') 
/
insert into HtmlLabelIndex values(1307,'本月各部门申请采购一览表') 
/
insert into HtmlLabelIndex values(1308,'部门一周工作汇总表') 
/
insert into HtmlLabelIndex values(1309,'各部门办公用品采购计划表') 
/
insert into HtmlLabelIndex values(1310,'各部门礼品采购计划表') 
/
insert into HtmlLabelIndex values(1311,'各部门低值易耗品采购计划表') 
/
insert into HtmlLabelIndex values(1312,'各部门IT设备采购计划表') 
/
insert into HtmlLabelIndex values(1313,'各部门家具采购计划表') 
/
insert into HtmlLabelIndex values(1314,'各部门图书采购计划表') 
/
insert into HtmlLabelIndex values(1315,'公司办公用品采购计划表') 
/
insert into HtmlLabelIndex values(1316,'公司礼品采购计划表') 
/
insert into HtmlLabelIndex values(1317,'公司低值易耗品采购计划表') 
/
insert into HtmlLabelIndex values(1318,'公司IT设备采购计划表') 
/
insert into HtmlLabelIndex values(1319,'公司家具采购计划表') 
/
insert into HtmlLabelIndex values(1320,'公司图书采购计划表') 
/
insert into HtmlLabelIndex values(1321,'编码') 
/
insert into HtmlLabelIndex values(1322,'起始日期') 
/
insert into HtmlLabelIndex values(1325,'固定成本') 
/
insert into HtmlLabelIndex values(1326,'设备') 
/
insert into HtmlLabelIndex values(1327,'成本/天') 
/
insert into HtmlLabelIndex values(1328,'材料') 
/
insert into HtmlLabelIndex values(1329,'单位') 
/
insert into HtmlLabelIndex values(1330,'单价') 
/
insert into HtmlLabelIndex values(1331,'数量') 
/
insert into HtmlLabelIndex values(1332,'任务') 
/
insert into HtmlLabelIndex values(1333,'计划版本') 
/
insert into HtmlLabelIndex values(1334,'请求说明') 
/
insert into HtmlLabelIndex values(1335,'当前状况') 
/
insert into HtmlLabelIndex values(1337,'项目计划通知') 
/
insert into HtmlLabelIndex values(1338,'执行') 
/
insert into HtmlLabelIndex values(1339,'创建时间') 
/
insert into HtmlLabelIndex values(1340,'所有人') 
/
insert into HtmlLabelIndex values(1341,'文档名称') 
/
insert into HtmlLabelIndex values(1342,'添加任务') 
/
insert into HtmlLabelIndex values(1343,'提交批准') 
/
insert into HtmlLabelIndex values(1344,'计划批准') 
/
insert into HtmlLabelIndex values(1345,'计划否决') 
/
insert into HtmlLabelIndex values(1346,'计划删除') 
/
insert into HtmlLabelIndex values(1347,'计划调整') 
/
insert into HtmlLabelIndex values(1348,'通知成员') 
/
insert into HtmlLabelIndex values(1349,'人力使用') 
/
insert into HtmlLabelIndex values(1350,'设备使用') 
/
insert into HtmlLabelIndex values(1351,'材料使用') 
/
insert into HtmlLabelIndex values(1352,'任务名称') 
/
insert into HtmlLabelIndex values(1353,'项目名称') 
/
insert into HtmlLabelIndex values(1354,'比较对象') 
/
insert into HtmlLabelIndex values(1355,'基准计划') 
/
insert into HtmlLabelIndex values(1356,'当前计划') 
/
insert into HtmlLabelIndex values(1357,'差值(基准)') 
/
insert into HtmlLabelIndex values(1358,'差值(当前)') 
/
insert into HtmlLabelIndex values(1359,'折旧方法') 
/
insert into HtmlLabelIndex values(1360,'财务相关') 
/
insert into HtmlLabelIndex values(1361,'基本信息') 
/
insert into HtmlLabelIndex values(1362,'条形码') 
/
insert into HtmlLabelIndex values(1363,'单独核算') 
/
insert into HtmlLabelIndex values(1364,'制造厂商') 
/
insert into HtmlLabelIndex values(1365,'出厂日期') 
/
insert into HtmlLabelIndex values(1366,'自制') 
/
insert into HtmlLabelIndex values(1367,'采购') 
/
insert into HtmlLabelIndex values(1368,'租赁') 
/
insert into HtmlLabelIndex values(1369,'出租') 
/
insert into HtmlLabelIndex values(1370,'租用') 
/
insert into HtmlLabelIndex values(1371,'替代') 
/
insert into HtmlLabelIndex values(1372,'开始价格') 
/
insert into HtmlLabelIndex values(1373,'折旧底价') 
/
insert into HtmlLabelIndex values(1374,'折旧信息') 
/
insert into HtmlLabelIndex values(1375,'入库') 
/
insert into HtmlLabelIndex values(1376,'调入') 
/
insert into HtmlLabelIndex values(1377,'调出') 
/
insert into HtmlLabelIndex values(1378,'领用') 
/
insert into HtmlLabelIndex values(1379,'租借') 
/
insert into HtmlLabelIndex values(1380,'流转') 
/
insert into HtmlLabelIndex values(1381,'移交') 
/
insert into HtmlLabelIndex values(1382,'维修') 
/
insert into HtmlLabelIndex values(1384,'归还') 
/
insert into HtmlLabelIndex values(1385,'损失') 
/
insert into HtmlLabelIndex values(1386,'报废') 
/
insert into HtmlLabelIndex values(1387,'存放地点') 
/
insert into HtmlLabelIndex values(1388,'已用年限，月份') 
/
insert into HtmlLabelIndex values(1389,'当前价值') 
/
insert into HtmlLabelIndex values(1390,'残值率') 
/
insert into HtmlLabelIndex values(1391,'月折旧率') 
/
insert into HtmlLabelIndex values(1392,'报废日期') 
/
insert into HtmlLabelIndex values(1393,'相关费用') 
/
insert into HtmlLabelIndex values(1394,'流转日期') 
/
insert into HtmlLabelIndex values(1395,'地点') 
/
insert into HtmlLabelIndex values(1396,'出库') 
/
insert into HtmlLabelIndex values(1397,'盘亏') 
/
insert into HtmlLabelIndex values(1398,'盘盈') 
/
insert into HtmlLabelIndex values(1399,'维修单位') 
/
insert into HtmlLabelIndex values(1400,'经费') 
/
insert into HtmlLabelIndex values(1401,'移交日期') 
/
insert into HtmlLabelIndex values(1402,'下一步') 
/
insert into HtmlLabelIndex values(1404,'租借日期') 
/
insert into HtmlLabelIndex values(1405,'数量超额') 
/
insert into HtmlLabelIndex values(1406,'损失日期') 
/
insert into HtmlLabelIndex values(1408,'损失后状态') 
/
insert into HtmlLabelIndex values(1409,'维修日期') 
/
insert into HtmlLabelIndex values(1410,'调入日期') 
/
insert into HtmlLabelIndex values(1411,'调出日期') 
/
insert into HtmlLabelIndex values(1412,'领用日期') 
/
insert into HtmlLabelIndex values(1413,'归还日期') 
/
insert into HtmlLabelIndex values(1414,'归还后状态') 
/
insert into HtmlLabelIndex values(1415,'盘点日期') 
/
insert into HtmlLabelIndex values(1416,'盘点人') 
/
insert into HtmlLabelIndex values(1417,'理论数量') 
/
insert into HtmlLabelIndex values(1418,'实际数量') 
/
insert into HtmlLabelIndex values(1419,'盈亏数量') 
/
insert into HtmlLabelIndex values(1420,'盈亏金额') 
/
insert into HtmlLabelIndex values(1421,'新增') 
/
insert into HtmlLabelIndex values(1422,'未审批') 
/
insert into HtmlLabelIndex values(1423,'已审批') 
/
insert into HtmlLabelIndex values(1425,'审批日期') 
/
insert into HtmlLabelIndex values(1426,'选中') 
/
insert into HtmlLabelIndex values(1427,'时间(月)') 
/
insert into HtmlLabelIndex values(1428,'添加项') 
/
insert into HtmlLabelIndex values(1429,'删除项') 
/
insert into HtmlLabelIndex values(1430,'时限(月)') 
/
insert into HtmlLabelIndex values(1431,'起始因子') 
/
insert into HtmlLabelIndex values(1432,'结束因子') 
/
insert into HtmlLabelIndex values(1433,'折旧函数(t)') 
/
insert into HtmlLabelIndex values(1434,'原部门') 
/
insert into HtmlLabelIndex values(1435,'流转至部门') 
/
insert into HtmlLabelIndex values(1436,'流转至人') 
/
insert into HtmlLabelIndex values(1437,'调拨') 
/
insert into HtmlLabelIndex values(1438,'资产总表') 
/
insert into HtmlLabelIndex values(1439,'资产情况') 
/
insert into HtmlLabelIndex values(1440,'总报表') 
/
insert into HtmlLabelIndex values(1441,'折旧报告') 
/
insert into HtmlLabelIndex values(1442,'工作流 － 统计报表') 
/
insert into HtmlLabelIndex values(1443,'大类') 
/
insert into HtmlLabelIndex values(1444,'小类') 
/
insert into HtmlLabelIndex values(1445,'资产名称') 
/
insert into HtmlLabelIndex values(1446,'库存数量') 
/
insert into HtmlLabelIndex values(1447,'总金额') 
/
insert into HtmlLabelIndex values(1448,'目前状态') 
/
insert into HtmlLabelIndex values(1449,'谁在使用') 
/
insert into HtmlLabelIndex values(1450,'现值') 
/
insert into HtmlLabelIndex values(1451,'当前数量') 
/
insert into HtmlLabelIndex values(1452,'总帐科目') 
/
insert into HtmlLabelIndex values(1453,'财务期间') 
/
insert into HtmlLabelIndex values(1454,'已处理') 
/
insert into HtmlLabelIndex values(1455,'费用名称') 
/
insert into HtmlLabelIndex values(1456,'费用描述') 
/
insert into HtmlLabelIndex values(1457,'报销费用类型名称') 
/
insert into HtmlLabelIndex values(1458,'报销费用类型描述') 
/
insert into HtmlLabelIndex values(1459,'期间 从 , 到') 
/
insert into HtmlLabelIndex values(1460,'期末') 
/
insert into HtmlLabelIndex values(1461,'比率') 
/
insert into HtmlLabelIndex values(1462,'费用类型') 
/
insert into HtmlLabelIndex values(1463,'正方') 
/
insert into HtmlLabelIndex values(1464,'百分比') 
/
insert into HtmlLabelIndex values(1465,'借方') 
/
insert into HtmlLabelIndex values(1466,'贷方') 
/
insert into HtmlLabelIndex values(1467,'自动明细') 
/
insert into HtmlLabelIndex values(1468,'客户:预收') 
/
insert into HtmlLabelIndex values(1469,'客户:应收') 
/
insert into HtmlLabelIndex values(1470,'供应商:预付') 
/
insert into HtmlLabelIndex values(1471,'供应商:应付') 
/
insert into HtmlLabelIndex values(1472,'类型, 余额方向:') 
/
insert into HtmlLabelIndex values(1473,'负债') 
/
insert into HtmlLabelIndex values(1474,'所有者权益') 
/
insert into HtmlLabelIndex values(1475,'损益') 
/
insert into HtmlLabelIndex values(1476,'货币兑换') 
/
insert into HtmlLabelIndex values(1477,'历史') 
/
insert into HtmlLabelIndex values(1478,'目录信息') 
/
insert into HtmlLabelIndex values(1479,'权限详细信息') 
/
insert into HtmlLabelIndex values(1480,'期初') 
/
insert into HtmlLabelIndex values(1481,'选用') 
/
insert into HtmlLabelIndex values(1482,'期初数') 
/
insert into HtmlLabelIndex values(1483,'期末数') 
/
insert into HtmlLabelIndex values(1484,'资产总计') 
/
insert into HtmlLabelIndex values(1485,'负债和所有者权益') 
/
insert into HtmlLabelIndex values(1486,'行次') 
/
insert into HtmlLabelIndex values(1487,'负债总计') 
/
insert into HtmlLabelIndex values(1488,'所有者权益总计') 
/
insert into HtmlLabelIndex values(1489,'负债和所有者权益总计') 
/
insert into HtmlLabelIndex values(1490,'部门费用预算表') 
/
insert into HtmlLabelIndex values(1491,'费用') 
/
insert into HtmlLabelIndex values(1492,'一月') 
/
insert into HtmlLabelIndex values(1493,'二月') 
/
insert into HtmlLabelIndex values(1494,'三月') 
/
insert into HtmlLabelIndex values(1495,'四月') 
/
insert into HtmlLabelIndex values(1496,'五月') 
/
insert into HtmlLabelIndex values(1497,'六月') 
/
insert into HtmlLabelIndex values(1498,'七月') 
/
insert into HtmlLabelIndex values(1499,'八月') 
/
insert into HtmlLabelIndex values(1500,'首页') 
/
insert into HtmlLabelIndex values(1501,'流转情况') 
/
insert into HtmlLabelIndex values(1502,'资格证书') 
/
insert into HtmlLabelIndex values(1503,'入职简历') 
/
insert into HtmlLabelIndex values(1504,'薪酬福利') 
/
insert into HtmlLabelIndex values(1505,'年休假记录') 
/
insert into HtmlLabelIndex values(1506,'盘点') 
/
insert into HtmlLabelIndex values(1507,'管理员') 
/
insert into HtmlLabelIndex values(1508,'使用人') 
/
insert into HtmlLabelIndex values(1509,'资产资料') 
/
insert into HtmlLabelIndex values(1510,'资产归总表') 
/
insert into HtmlLabelIndex values(1511,'费用分摊') 
/
insert into HtmlLabelIndex values(1512,'领用人') 
/
insert into HtmlLabelIndex values(1513,'日常办公用品一览表') 
/
insert into HtmlLabelIndex values(1514,'评价') 
/
insert into HtmlLabelIndex values(1515,'通讯录') 
/
insert into HtmlLabelIndex values(1516,'入职日期') 
/
insert into HtmlLabelIndex values(1517,'现在住址') 
/
insert into HtmlLabelIndex values(1518,'毕业学校') 
/
insert into HtmlLabelIndex values(1519,'毕业日期') 
/
insert into HtmlLabelIndex values(1520,'上月盘存数') 
/
insert into HtmlLabelIndex values(1521,'本月进货数') 
/
insert into HtmlLabelIndex values(1522,'本月领用数') 
/
insert into HtmlLabelIndex values(1523,'领用总价') 
/
insert into HtmlLabelIndex values(1524,'月末库存') 
/
insert into HtmlLabelIndex values(1800,'九月') 
/
insert into HtmlLabelIndex values(1801,'十月') 
/
insert into HtmlLabelIndex values(1802,'十一月') 
/
insert into HtmlLabelIndex values(1803,'十二月') 
/
insert into HtmlLabelIndex values(1804,'工资') 
/
insert into HtmlLabelIndex values(1805,'福利费') 
/
insert into HtmlLabelIndex values(1806,'上期累计数') 
/
insert into HtmlLabelIndex values(1807,'本期累计数') 
/
insert into HtmlLabelIndex values(1808,'损益报告') 
/
insert into HtmlLabelIndex values(1809,'明细分类帐') 
/
insert into HtmlLabelIndex values(1810,'期初余额') 
/
insert into HtmlLabelIndex values(1811,'余额') 
/
insert into HtmlLabelIndex values(1812,'期间,从') 
/
insert into HtmlLabelIndex values(1813,'期间,到') 
/
insert into HtmlLabelIndex values(1814,'年, 期间') 
/
insert into HtmlLabelIndex values(1815,'已登帐') 
/
insert into HtmlLabelIndex values(1816,'结帐') 
/
insert into HtmlLabelIndex values(1817,'余额方向') 
/
insert into HtmlLabelIndex values(1818,'方向') 
/
insert into HtmlLabelIndex values(1819,'分录日期') 
/
insert into HtmlLabelIndex values(1820,'借方金额') 
/
insert into HtmlLabelIndex values(1821,'贷方金额') 
/
insert into HtmlLabelIndex values(1822,'分录数') 
/
insert into HtmlLabelIndex values(1823,'汇总') 
/
insert into HtmlLabelIndex values(1824,'年/期间') 
/
insert into HtmlLabelIndex values(1825,'新:人力资源库') 
/
insert into HtmlLabelIndex values(1826,'身高(cm)') 
/
insert into HtmlLabelIndex values(1827,'健康状况') 
/
insert into HtmlLabelIndex values(1828,'户口所在地') 
/
insert into HtmlLabelIndex values(1829,'现居住地') 
/
insert into HtmlLabelIndex values(1830,'应届') 
/
insert into HtmlLabelIndex values(1831,'在职') 
/
insert into HtmlLabelIndex values(1832,'待业') 
/
insert into HtmlLabelIndex values(1833,'学位') 
/
insert into HtmlLabelIndex values(1834,'入团日期') 
/
insert into HtmlLabelIndex values(1835,'入党日期') 
/
insert into HtmlLabelIndex values(1836,'民主日期') 
/
insert into HtmlLabelIndex values(1837,'政治面貌') 
/
insert into HtmlLabelIndex values(1838,'证件类别') 
/
insert into HtmlLabelIndex values(1839,'证件号码') 
/
insert into HtmlLabelIndex values(1840,'籍贯') 
/
insert into HtmlLabelIndex values(1841,'培训及持有证书') 
/
insert into HtmlLabelIndex values(1842,'求职意向') 
/
insert into HtmlLabelIndex values(1843,'目前年薪') 
/
insert into HtmlLabelIndex values(1844,'工作年限(年)') 
/
insert into HtmlLabelIndex values(1845,'年薪底限') 
/
insert into HtmlLabelIndex values(1846,'流动理由') 
/
insert into HtmlLabelIndex values(1847,'其他要求') 
/
insert into HtmlLabelIndex values(1848,'个人主页') 
/
insert into HtmlLabelIndex values(1849,'自荐书') 
/
insert into HtmlLabelIndex values(1850,'学校') 
/
insert into HtmlLabelIndex values(1851,'公司') 
/
insert into HtmlLabelIndex values(1852,'复审') 
/
insert into HtmlLabelIndex values(1853,'录用') 
/
insert into HtmlLabelIndex values(1854,'应聘回复(邮件)') 
/
insert into HtmlLabelIndex values(1855,'应聘日期') 
/
insert into HtmlLabelIndex values(1856,'应聘职位') 
/
insert into HtmlLabelIndex values(1857,'工作国家') 
/
insert into HtmlLabelIndex values(1858,'职位描述') 
/
insert into HtmlLabelIndex values(1859,'人数') 
/
insert into HtmlLabelIndex values(1860,'最低学历') 
/
insert into HtmlLabelIndex values(1861,'发布人') 
/
insert into HtmlLabelIndex values(1862,'发布时间') 
/
insert into HtmlLabelIndex values(1863,'应聘') 
/
insert into HtmlLabelIndex values(1864,'需求人数') 
/
insert into HtmlLabelIndex values(1865,'职位种类') 
/
insert into HtmlLabelIndex values(1866,'用工方式') 
/
insert into HtmlLabelIndex values(1867,'人员') 
/
insert into HtmlLabelIndex values(1868,'人员要求') 
/
insert into HtmlLabelIndex values(1869,'常用查询条件') 
/
insert into HtmlLabelIndex values(1870,'曾就读学校') 
/
insert into HtmlLabelIndex values(1871,'曾就业公司') 
/
insert into HtmlLabelIndex values(1872,'年，期间') 
/
insert into HtmlLabelIndex values(1873,'指示器,成本中心') 
/
insert into HtmlLabelIndex values(1874,'货币, 因素') 
/
insert into HtmlLabelIndex values(1875,'比较, 版本') 
/
insert into HtmlLabelIndex values(1876,'上一步') 
/
insert into HtmlLabelIndex values(1877,'还没有键入符合标准的数据。') 
/
insert into HtmlLabelIndex values(1878,'分部名称') 
/
insert into HtmlLabelIndex values(1879,'分部描述') 
/
insert into HtmlLabelIndex values(1880,'所属总部') 
/
insert into HtmlLabelIndex values(1881,'请假类型') 
/
insert into HtmlLabelIndex values(1882,'课程') 
/
insert into HtmlLabelIndex values(1883,'工作流-统计报告') 
/
insert into HtmlLabelIndex values(1884,'出生年月') 
/
insert into HtmlLabelIndex values(1885,'出生地') 
/
insert into HtmlLabelIndex values(1886,'民族') 
/
insert into HtmlLabelIndex values(1887,'身份证号码') 
/
insert into HtmlLabelIndex values(1888,'待复审') 
/
insert into HtmlLabelIndex values(1889,'高级查询条件') 
/
insert into HtmlLabelIndex values(1890,'计数(小时)') 
/
insert into HtmlLabelIndex values(1891,'部门-人力资源') 
/
insert into HtmlLabelIndex values(1892,'人次') 
/
insert into HtmlLabelIndex values(1893,'基本工资') 
/
insert into HtmlLabelIndex values(1894,'房贴') 
/
insert into HtmlLabelIndex values(1895,'车贴') 
/
insert into HtmlLabelIndex values(1896,'饭贴') 
/
insert into HtmlLabelIndex values(1897,'调整原因') 
/
insert into HtmlLabelIndex values(1898,'主要学历') 
/
insert into HtmlLabelIndex values(1899,'邮编') 
/
insert into HtmlLabelIndex values(1900,'户籍住址') 
/
insert into HtmlLabelIndex values(1901,'政治身份') 
/
insert into HtmlLabelIndex values(1903,'学校名称') 
/
insert into HtmlLabelIndex values(1904,'所学专业') 
/
insert into HtmlLabelIndex values(1905,'颁发机构') 
/
insert into HtmlLabelIndex values(1906,'入职前工作经历') 
/
insert into HtmlLabelIndex values(1907,'入职后工作经历') 
/
insert into HtmlLabelIndex values(1908,'入职时间') 
/
insert into HtmlLabelIndex values(1909,'职级') 
/
insert into HtmlLabelIndex values(1910,'成就和论著') 
/
insert into HtmlLabelIndex values(1911,'曾受到何种奖励、处罚') 
/
insert into HtmlLabelIndex values(1912,'主要家庭成员') 
/
insert into HtmlLabelIndex values(1913,'与本人关系') 
/
insert into HtmlLabelIndex values(1914,'工作单位') 
/
insert into HtmlLabelIndex values(1915,'职务') 
/
insert into HtmlLabelIndex values(1916,'联系电话') 
/
insert into HtmlLabelIndex values(1917,'公司内部奖惩记录') 
/
insert into HtmlLabelIndex values(1918,'薪酬福利待遇') 
/
insert into HtmlLabelIndex values(1919,'病假') 
/
insert into HtmlLabelIndex values(1920,'事假') 
/
insert into HtmlLabelIndex values(1921,'产假') 
/
insert into HtmlLabelIndex values(1922,'婚丧假') 
/
insert into HtmlLabelIndex values(1923,'休假') 
/
insert into HtmlLabelIndex values(1924,'缺勤') 
/
insert into HtmlLabelIndex values(1925,'天') 
/
insert into HtmlLabelIndex values(1926,'周') 
/
insert into HtmlLabelIndex values(1927,'图示') 
/
insert into HtmlLabelIndex values(1928,'无效的日期') 
/
insert into HtmlLabelIndex values(1929,'当前状态') 
/
insert into HtmlLabelIndex values(1930,'现居住地电话') 
/
insert into HtmlLabelIndex values(1931,'现居住地邮编') 
/
insert into HtmlLabelIndex values(1932,'应聘人') 
/
insert into HtmlLabelIndex values(1933,'工号') 
/
insert into HtmlLabelIndex values(1934,'工种') 
/
insert into HtmlLabelIndex values(1935,'工作开始日期') 
/
insert into HtmlLabelIndex values(1936,'合同开始时间') 
/
insert into HtmlLabelIndex values(1937,'现职称') 
/
insert into HtmlLabelIndex values(1938,'工作权力') 
/
insert into HtmlLabelIndex values(1939,'公积金帐号') 
/
insert into HtmlLabelIndex values(1940,'工作开始时间') 
/
insert into HtmlLabelIndex values(1941,'支付银行') 
/
insert into HtmlLabelIndex values(1942,'详细描述') 
/
insert into HtmlLabelIndex values(1943,'家庭成员') 
/
insert into HtmlLabelIndex values(1944,'称谓') 
/
insert into HtmlLabelIndex values(1945,'因公流入') 
/
insert into HtmlLabelIndex values(1946,'因公流出') 
/
insert into HtmlLabelIndex values(1947,'因私流入') 
/
insert into HtmlLabelIndex values(1948,'因私流出') 
/
insert into HtmlLabelIndex values(1949,'费用报销') 
/
insert into HtmlLabelIndex values(1950,'普通费用申请') 
/
insert into HtmlLabelIndex values(1951,'出差费用申请') 
/
insert into HtmlLabelIndex values(1952,'私人还款') 
/
insert into HtmlLabelIndex values(1953,'私人借款') 
/
insert into HtmlLabelIndex values(1954,'语种') 
/
insert into HtmlLabelIndex values(1955,'项目相关') 
/
insert into HtmlLabelIndex values(1956,'缺勤相关') 
/
insert into HtmlLabelIndex values(1957,'加班相关') 
/
insert into HtmlLabelIndex values(1958,'普通加班') 
/
insert into HtmlLabelIndex values(1959,'节假日加班') 
/
insert into HtmlLabelIndex values(1960,'进行中') 
/
insert into HtmlLabelIndex values(1961,'已完成') 
/
insert into HtmlLabelIndex values(1962,'奖惩日期') 
/
insert into HtmlLabelIndex values(1963,'录入员') 
/
insert into HtmlLabelIndex values(1964,'生日') 
/
insert into HtmlLabelIndex values(1966,'入团,入党日期') 
/
insert into HtmlLabelIndex values(1967,'家庭地址') 
/
insert into HtmlLabelIndex values(1968,'家庭邮编') 
/
insert into HtmlLabelIndex values(1969,'家庭电话') 
/
insert into HtmlLabelIndex values(1970,'合同开始日期') 
/
insert into HtmlLabelIndex values(1971,'培训开始时间') 
/
insert into HtmlLabelIndex values(1972,'培训结束时间') 
/
insert into HtmlLabelIndex values(1973,'学时(小时)') 
/
insert into HtmlLabelIndex values(1974,'培训单位') 
/
insert into HtmlLabelIndex values(1975,'公司性质') 
/
insert into HtmlLabelIndex values(1976,'公司名称') 
/
insert into HtmlLabelIndex values(1977,'工作描述') 
/
insert into HtmlLabelIndex values(1978,'离职原因') 
/
insert into HtmlLabelIndex values(1979,'未开始') 
/
insert into HtmlLabelIndex values(1980,'等待他人') 
/
insert into HtmlLabelIndex values(1981,'已撤销') 
/
insert into HtmlLabelIndex values(1982,'超期') 
/
insert into HtmlLabelIndex values(1983,'文档复制移动') 
/
insert into HtmlLabelIndex values(1984,'不发布') 
/
insert into HtmlLabelIndex values(1985,'文档共享') 
/
insert into HtmlLabelIndex values(1986,'新建文档') 
/
insert into HtmlLabelIndex values(1988,'插入行数') 
/
insert into HtmlLabelIndex values(1989,'插入列数') 
/
insert into HtmlLabelIndex values(1990,'表属性') 
/
insert into HtmlLabelIndex values(1991,'单元格属性') 
/
insert into HtmlLabelIndex values(1992,'内部设定') 
/
insert into HtmlLabelIndex values(1993,'发布类型') 
/
insert into HtmlLabelIndex values(1994,'内部') 
/
insert into HtmlLabelIndex values(1995,'外部') 
/
insert into HtmlLabelIndex values(1996,'显示语言') 
/
insert into HtmlLabelIndex values(1997,'中文') 
/
insert into HtmlLabelIndex values(1999,'新闻页的附加显示条件.例如') 
/
insert into HtmlLabelIndex values(2000,'文档摘要') 
/
insert into HtmlLabelIndex values(2001,'回复文档数') 
/
insert into HtmlLabelIndex values(2002,'附件数') 
/
insert into HtmlLabelIndex values(2003,'文档总数为') 
/
insert into HtmlLabelIndex values(2004,'其中非回复') 
/
insert into HtmlLabelIndex values(2005,'关健字') 
/
insert into HtmlLabelIndex values(2006,'显示回复总数') 
/
insert into HtmlLabelIndex values(2007,'显示附件总数') 
/
insert into HtmlLabelIndex values(2008,'默认文档显示模板') 
/
insert into HtmlLabelIndex values(2009,'新闻页文档') 
/
insert into HtmlLabelIndex values(2010,'新闻页背景') 
/
insert into HtmlLabelIndex values(2011,'没有权限') 
/
insert into HtmlLabelIndex values(2012,'你没有访问当前页面的权限') 
/
insert into HtmlLabelIndex values(2013,'请返回或者进入不同的页面') 
/
insert into HtmlLabelIndex values(2014,'总计: 项目') 
/
insert into HtmlLabelIndex values(2015,'总计: 资产') 
/
insert into HtmlLabelIndex values(2016,'人力资源: 实际') 
/
insert into HtmlLabelIndex values(2017,'组织图表:成本中心') 
/
insert into HtmlLabelIndex values(2018,'总计: 客户') 
/
insert into HtmlLabelIndex values(2019,'总价') 
/
insert into HtmlLabelIndex values(2020,'剩余总价') 
/
insert into HtmlLabelIndex values(2021,'总计: 文档') 
/
insert into HtmlLabelIndex values(2022,'重置') 
/
insert into HtmlLabelIndex values(2023,'登录信息') 
/
insert into HtmlLabelIndex values(2024,'帐号') 
/
insert into HtmlLabelIndex values(2025,'保存密码') 
/
insert into HtmlLabelIndex values(2026,'组') 
/
insert into HtmlLabelIndex values(2027,'>邮件用户组已存在，请重新输入组名') 
/
insert into HtmlLabelIndex values(2028,'用户已存在邮件用户组，请重选择用户名') 
/
insert into HtmlLabelIndex values(2029,'新建邮件') 
/
insert into HtmlLabelIndex values(2030,'删除邮件') 
/
insert into HtmlLabelIndex values(2031,'永久删除') 
/
insert into HtmlLabelIndex values(2032,'邮件菜单') 
/
insert into HtmlLabelIndex values(2033,'邮件夹') 
/
insert into HtmlLabelIndex values(2034,'发件人') 
/
insert into HtmlLabelIndex values(2035,'发件时间') 
/
insert into HtmlLabelIndex values(2036,'大小') 
/
insert into HtmlLabelIndex values(2037,'本地邮件') 
/
insert into HtmlLabelIndex values(2038,'发件箱') 
/
insert into HtmlLabelIndex values(2039,'草稿箱') 
/
insert into HtmlLabelIndex values(2040,'垃圾箱') 
/
insert into HtmlLabelIndex values(2042,'本地邮件箱') 
/
insert into HtmlLabelIndex values(2043,'邮件箱') 
/
insert into HtmlLabelIndex values(2044,'邮件发送成功') 
/
insert into HtmlLabelIndex values(2045,'邮件发送失败') 
/
insert into HtmlLabelIndex values(2046,'收件人') 
/
insert into HtmlLabelIndex values(2047,'发件日期') 
/
insert into HtmlLabelIndex values(2048,'移至发件箱') 
/
insert into HtmlLabelIndex values(2049,'移至草稿箱') 
/
insert into HtmlLabelIndex values(2050,'移至本地') 
/
insert into HtmlLabelIndex values(2051,'发送邮件') 
/
insert into HtmlLabelIndex values(2052,'转发邮件') 
/
insert into HtmlLabelIndex values(2053,'回复全部') 
/
insert into HtmlLabelIndex values(2054,'回复邮件') 
/
insert into HtmlLabelIndex values(2056,'移动到本地') 
/
insert into HtmlLabelIndex values(2057,'复制到本地') 
/
insert into HtmlLabelIndex values(2058,'邮件服务器') 
/
insert into HtmlLabelIndex values(2059,'登录日志') 
/
insert into HtmlLabelIndex values(2060,'类名称') 
/
insert into HtmlLabelIndex values(2061,'日志日期') 
/
insert into HtmlLabelIndex values(2062,'客户联系计划') 
/
insert into HtmlLabelIndex values(2063,'新的工作流到达:新') 
/
insert into HtmlLabelIndex values(2064,'新的工作流到达:待处理工作流') 
/
insert into HtmlLabelIndex values(2065,'新的工作流到达:正常') 
/
insert into HtmlLabelIndex values(2066,'工作流完成') 
/
insert into HtmlLabelIndex values(2067,'工作流完成(待处理)') 
/
insert into HtmlLabelIndex values(2068,'节点超时') 
/
insert into HtmlLabelIndex values(2069,'审批文档') 
/
insert into HtmlLabelIndex values(2070,'处理文档') 
/
insert into HtmlLabelIndex values(2071,'数据库服务器') 
/
insert into HtmlLabelIndex values(2072,'用户名') 
/
insert into HtmlLabelIndex values(2073,'重设') 
/
insert into HtmlLabelIndex values(2074,'标题内容') 
/
insert into HtmlLabelIndex values(2075,'移动速度') 
/
insert into HtmlLabelIndex values(2076,'字体颜色') 
/
insert into HtmlLabelIndex values(2077,'背景颜色') 
/
insert into HtmlLabelIndex values(2078,'最后操作时间') 
/
insert into HtmlLabelIndex values(2079,'工作流名称') 
/
insert into HtmlLabelIndex values(2080,'最近新闻') 
/
insert into HtmlLabelIndex values(2081,'收藏夹') 
/
insert into HtmlLabelIndex values(2082,'加入时间') 
/
insert into HtmlLabelIndex values(2083,'发送') 
/
insert into HtmlLabelIndex values(2084,'抄送') 
/
insert into HtmlLabelIndex values(2085,'密送') 
/
insert into HtmlLabelIndex values(2086,'普通') 
/
insert into HtmlLabelIndex values(2087,'紧急') 
/
insert into HtmlLabelIndex values(2088,'不重要') 
/
insert into HtmlLabelIndex values(2089,'多收件人请用逗号分隔') 
/
insert into HtmlLabelIndex values(2090,'多抄送人请用逗号分隔') 
/
insert into HtmlLabelIndex values(2091,'多密送人请用逗号分隔') 
/
insert into HtmlLabelIndex values(2092,'保存到发件箱') 
/
insert into HtmlLabelIndex values(2093,'优先级别') 
/
insert into HtmlLabelIndex values(2094,'文档所有者') 
/
insert into HtmlLabelIndex values(2095,'关鍵字') 
/
insert into HtmlLabelIndex values(2096,'批复内容') 
/
insert into HtmlLabelIndex values(2097,'负责人') 
/
insert into HtmlLabelIndex values(2098,'子任务') 
/
insert into HtmlLabelIndex values(2099,'任务展开') 
/
insert into HtmlLabelIndex values(2100,'保存为计划') 
/
insert into HtmlLabelIndex values(2101,'我的计划') 
/
insert into HtmlLabelIndex values(2102,'我的会议') 
/
insert into HtmlLabelIndex values(2103,'会议') 
/
insert into HtmlLabelIndex values(2104,'会议类型') 
/
insert into HtmlLabelIndex values(2105,'会议地点') 
/
insert into HtmlLabelIndex values(2106,'参会人员') 
/
insert into HtmlLabelIndex values(2107,'会议服务') 
/
insert into HtmlLabelIndex values(2108,'回执') 
/
insert into HtmlLabelIndex values(2109,'记录数') 
/
insert into HtmlLabelIndex values(2110,'当前页码') 
/
insert into HtmlLabelIndex values(2111,'共有记录') 
/
insert into HtmlLabelIndex values(2112,'共享设置') 
/
insert into HtmlLabelIndex values(2113,'客户管理') 
/
insert into HtmlLabelIndex values(2114,'项目管理') 
/
insert into HtmlLabelIndex values(2115,'知识管理') 
/
insert into HtmlLabelIndex values(2116,'资产管理') 
/
insert into HtmlLabelIndex values(2117,'财务管理') 
/
insert into HtmlLabelIndex values(2118,'工作流程') 
/
insert into HtmlLabelIndex values(2119,'博士后') 
/
insert into HtmlLabelIndex values(2120,'直接上司') 
/
insert into HtmlLabelIndex values(2121,'详细信息') 
/
insert into HtmlLabelIndex values(2151,'会议名称') 
/
insert into HtmlLabelIndex values(2152,'召集人') 
/
insert into HtmlLabelIndex values(2153,'批准人') 
/
insert into HtmlLabelIndex values(2154,'其他地点') 
/
insert into HtmlLabelIndex values(2155,'服务类型') 
/
insert into HtmlLabelIndex values(2156,'负责人员') 
/
insert into HtmlLabelIndex values(2157,'服务项目') 
/
insert into HtmlLabelIndex values(2158,'多个服务项目之间请用英文逗号,分隔') 
/
insert into HtmlLabelIndex values(2159,'分隔') 
/
insert into HtmlLabelIndex values(2160,'会议回执') 
/
insert into HtmlLabelIndex values(2161,'公开') 
/
insert into HtmlLabelIndex values(2162,'会议日期') 
/
insert into HtmlLabelIndex values(2163,'大会议室') 
/
insert into HtmlLabelIndex values(2164,'小会议室') 
/
insert into HtmlLabelIndex values(2165,'查看会议室使用状况') 
/
insert into HtmlLabelIndex values(2166,'应到人数') 
/
insert into HtmlLabelIndex values(2167,'参会客户') 
/
insert into HtmlLabelIndex values(2168,'其他人员') 
/
insert into HtmlLabelIndex values(2169,'议程') 
/
insert into HtmlLabelIndex values(2170,'决议概述') 
/
insert into HtmlLabelIndex values(2171,'决议') 
/
insert into HtmlLabelIndex values(2172,'执行人') 
/
insert into HtmlLabelIndex values(2173,'检查人') 
/
insert into HtmlLabelIndex values(2174,'头等舱') 
/
insert into HtmlLabelIndex values(2175,'公务舱') 
/
insert into HtmlLabelIndex values(2176,'经济舱') 
/
insert into HtmlLabelIndex values(2177,'软卧') 
/
insert into HtmlLabelIndex values(2178,'硬卧') 
/
insert into HtmlLabelIndex values(2179,'硬座') 
/
insert into HtmlLabelIndex values(2180,'飞机') 
/
insert into HtmlLabelIndex values(2181,'火车') 
/
insert into HtmlLabelIndex values(2182,'交通工具') 
/
insert into HtmlLabelIndex values(2183,'回程日期.时间') 
/
insert into HtmlLabelIndex values(2184,'是否需订回程票') 
/
insert into HtmlLabelIndex values(2185,'是否需订房(标准)') 
/
insert into HtmlLabelIndex values(2186,'预计到达日期.时间') 
/
insert into HtmlLabelIndex values(2187,'是否参加') 
/
insert into HtmlLabelIndex values(2188,'其他人参加') 
/
insert into HtmlLabelIndex values(2189,'其他参会人员') 
/
insert into HtmlLabelIndex values(2190,'调配完毕') 
/
insert into HtmlLabelIndex values(2191,'调整') 
/
insert into HtmlLabelIndex values(2192,'日程安排') 
/
insert into HtmlLabelIndex values(2193,'查看会议室使用情况') 
/
insert into HtmlLabelIndex values(2194,'会议决议') 
/
insert into HtmlLabelIndex values(2195,'参加') 
/
insert into HtmlLabelIndex values(2196,'到达时间') 
/
insert into HtmlLabelIndex values(2197,'订房') 
/
insert into HtmlLabelIndex values(2198,'订房标准') 
/
insert into HtmlLabelIndex values(2199,'订回程票') 
/
insert into HtmlLabelIndex values(2200,'回程时间') 
/
insert into HtmlLabelIndex values(2201,'飞机头等舱') 
/
insert into HtmlLabelIndex values(2202,'飞机公务舱') 
/
insert into HtmlLabelIndex values(2203,'飞机经济舱') 
/
insert into HtmlLabelIndex values(2204,'火车软卧') 
/
insert into HtmlLabelIndex values(2205,'火车硬卧') 
/
insert into HtmlLabelIndex values(2206,'火车硬座') 
/
insert into HtmlLabelIndex values(2207,'已确定参会人员总计') 
/
insert into HtmlLabelIndex values(2208,'其中公司员工') 
/
insert into HtmlLabelIndex values(2209,'外部人员') 
/
insert into HtmlLabelIndex values(2210,'整理') 
/
insert into HtmlLabelIndex values(2211,'日程') 
/
insert into HtmlLabelIndex values(2212,'资料') 
/
insert into HtmlLabelIndex values(2213,'已实现') 
/
insert into HtmlLabelIndex values(2214,'个人所得税税率表') 
/
insert into HtmlLabelIndex values(2215,'参照费率') 
/
insert into HtmlLabelIndex values(2216,'基准等级') 
/
insert into HtmlLabelIndex values(2217,'工资项目表') 
/
insert into HtmlLabelIndex values(2218,'个人工资设置') 
/
insert into HtmlLabelIndex values(2219,'个人工资变动历史记录') 
/
insert into HtmlLabelIndex values(2220,'短信服务') 
/
insert into HtmlLabelIndex values(2221,'短信服务管理') 
/
insert into HtmlLabelIndex values(2222,'短信服务管理－用户自编短信统计') 
/
insert into HtmlLabelIndex values(2223,'短信服务管理－系统发送短信统计') 
/
insert into HtmlLabelIndex values(2224,'新入职员工') 
/
insert into HtmlLabelIndex values(2225,'入职项目表') 
/
insert into HtmlLabelIndex values(2226,'新入职员工项目设置') 
/
insert into HtmlLabelIndex values(2227,'销售机会') 
/
insert into HtmlLabelIndex values(2228,'项目状态：正常') 
/
insert into HtmlLabelIndex values(2229,'项目状态：延期') 
/
insert into HtmlLabelIndex values(2230,'项目状态：完成') 
/
insert into HtmlLabelIndex values(2231,'项目状态：冻结') 
/
insert into HtmlLabelIndex values(2232,'里程碑任务') 
/
insert into HtmlLabelIndex values(2233,'前置任务') 
/
insert into HtmlLabelIndex values(2234,'进度审批状态') 
/
insert into HtmlLabelIndex values(2235,'未批准') 
/
insert into HtmlLabelIndex values(2236,'已经审批') 
/
insert into HtmlLabelIndex values(2237,'进度图表') 
/
insert into HtmlLabelIndex values(2238,'工作流/文档') 
/
insert into HtmlLabelIndex values(2239,'监控类型') 
/
insert into HtmlLabelIndex values(2240,'任务说明') 
/
insert into HtmlLabelIndex values(2241,'全部选中') 
/
insert into HtmlLabelIndex values(2242,'待审批') 
/
insert into HtmlLabelIndex values(2243,'立项批准') 
/
insert into HtmlLabelIndex values(2244,'延期') 
/
insert into HtmlLabelIndex values(2245,'无效') 
/
insert into HtmlLabelIndex values(2246,'有效') 
/
insert into HtmlLabelIndex values(2247,'销售预期') 
/
insert into HtmlLabelIndex values(2248,'预期收益') 
/
insert into HtmlLabelIndex values(2249,'可能性') 
/
insert into HtmlLabelIndex values(2250,'销售状态') 
/
insert into HtmlLabelIndex values(2251,'查看：相关交流') 
/
insert into HtmlLabelIndex values(2252,'成功关键因数') 
/
insert into HtmlLabelIndex values(2253,'失败关键因数') 
/
insert into HtmlLabelIndex values(3000,'归档日期') 
/
insert into HtmlLabelIndex values(3001,'最后审批人') 
/
insert into HtmlLabelIndex values(3002,'最后修改人') 
/
insert into HtmlLabelIndex values(3003,'归档人') 
/
insert into HtmlLabelIndex values(3004,'文档审批工作流类') 
/
insert into HtmlLabelIndex values(3005,'共享级别') 
/
insert into HtmlLabelIndex values(5000,'天气预报') 
/
insert into HtmlLabelIndex values(5001,'温度') 
/
insert into HtmlLabelIndex values(6001,'下一级') 
/
insert into HtmlLabelIndex values(6002,'显示栏目') 
/
insert into HtmlLabelIndex values(6003,'工作流到达') 
/
insert into HtmlLabelIndex values(6004,'有新的通知公告发布') 
/
insert into HtmlLabelIndex values(6005,'分机号码') 
/
insert into HtmlLabelIndex values(6006,'现无新的公告发布') 
/
insert into HtmlLabelIndex values(6007,'新的公告') 
/
insert into HtmlLabelIndex values(6008,'秘书') 
/
insert into HtmlLabelIndex values(6009,'讨论交流') 
/
insert into HtmlLabelIndex values(6010,'讨论人') 
/
insert into HtmlLabelIndex values(6011,'转发') 
/
insert into HtmlLabelIndex values(6012,'是否需法律部审核') 
/
insert into HtmlLabelIndex values(6013,'总裁') 
/
insert into HtmlLabelIndex values(6014,'报销方式') 
/
insert into HtmlLabelIndex values(6015,'我的报告') 
/
insert into HtmlLabelIndex values(6016,'实报金额') 
/
insert into HtmlLabelIndex values(6050,'资产验收入库') 
/
insert into HtmlLabelIndex values(6051,'资产借用') 
/
insert into HtmlLabelIndex values(6052,'资产报废') 
/
insert into HtmlLabelIndex values(6053,'资产维修') 
/
insert into HtmlLabelIndex values(6054,'资产减损') 
/
insert into HtmlLabelIndex values(6055,'资产变更') 
/
insert into HtmlLabelIndex values(6056,'原值') 
/
insert into HtmlLabelIndex values(6057,'今日工作') 
/
insert into HtmlLabelIndex values(6058,'查看下属的工作安排') 
/
insert into HtmlLabelIndex values(6059,'我的客户') 
/
insert into HtmlLabelIndex values(6060,'查看下属的客户') 
/
insert into HtmlLabelIndex values(6061,'客户联系提醒') 
/
insert into HtmlLabelIndex values(6062,'首页定制') 
/
insert into HtmlLabelIndex values(6063,'降级->无效客户') 
/
insert into HtmlLabelIndex values(6064,'降级->基础客户') 
/
insert into HtmlLabelIndex values(6066,'兴趣') 
/
insert into HtmlLabelIndex values(6067,'爱好') 
/
insert into HtmlLabelIndex values(6068,'专长') 
/
insert into HtmlLabelIndex values(6069,'背景资料') 
/
insert into HtmlLabelIndex values(6070,'客户价值评估') 
/
insert into HtmlLabelIndex values(6071,'权重') 
/
insert into HtmlLabelIndex values(6072,'打分') 
/
insert into HtmlLabelIndex values(6073,'客户价值') 
/
insert into HtmlLabelIndex values(6074,'主') 
/
insert into HtmlLabelIndex values(6076,'月') 
/
insert into HtmlLabelIndex values(6077,'提前时间') 
/
insert into HtmlLabelIndex values(6078,'是否提醒') 
/
insert into HtmlLabelIndex values(6079,'客户关怀') 
/
insert into HtmlLabelIndex values(6080,'客户投诉') 
/
insert into HtmlLabelIndex values(6081,'客户建议') 
/
insert into HtmlLabelIndex values(6082,'客户联系') 
/
insert into HtmlLabelIndex values(6083,'合同性质') 
/
insert into HtmlLabelIndex values(6084,'分成本中心') 
/
insert into HtmlLabelIndex values(6086,'岗位') 
/
insert into HtmlLabelIndex values(6087,'个人') 
/
insert into HtmlLabelIndex values(6088,'转正') 
/
insert into HtmlLabelIndex values(6089,'续签') 
/
insert into HtmlLabelIndex values(6090,'调动') 
/
insert into HtmlLabelIndex values(6091,'离职') 
/
insert into HtmlLabelIndex values(6092,'退休') 
/
insert into HtmlLabelIndex values(6093,'反聘') 
/
insert into HtmlLabelIndex values(6094,'解聘') 
/
insert into HtmlLabelIndex values(6095,'签单') 
/
insert into HtmlLabelIndex values(6096,'总成本中心') 
/
insert into HtmlLabelIndex values(6097,'信用额度') 
/
insert into HtmlLabelIndex values(6098,'信用期间') 
/
insert into HtmlLabelIndex values(6099,'奖惩种类') 
/
insert into HtmlLabelIndex values(6100,'奖惩管理') 
/
insert into HtmlLabelIndex values(6101,'规划') 
/
insert into HtmlLabelIndex values(6102,'考评') 
/
insert into HtmlLabelIndex values(6103,'安排') 
/
insert into HtmlLabelIndex values(6104,'公开范围') 
/
insert into HtmlLabelIndex values(6105,'资源') 
/
insert into HtmlLabelIndex values(6106,'考核') 
/
insert into HtmlLabelIndex values(6107,'奖励申请') 
/
insert into HtmlLabelIndex values(6109,'奖励种类') 
/
insert into HtmlLabelIndex values(6110,'职位调动') 
/
insert into HtmlLabelIndex values(6111,'调动日期') 
/
insert into HtmlLabelIndex values(6112,'原岗位') 
/
insert into HtmlLabelIndex values(6113,'新岗位') 
/
insert into HtmlLabelIndex values(6114,'原职级') 
/
insert into HtmlLabelIndex values(6115,'现职级') 
/
insert into HtmlLabelIndex values(6116,'调动原因') 
/
insert into HtmlLabelIndex values(6119,'离职申请') 
/
insert into HtmlLabelIndex values(6120,'离职合同') 
/
insert into HtmlLabelIndex values(6121,'转正申请') 
/
insert into HtmlLabelIndex values(6122,'转正日期') 
/
insert into HtmlLabelIndex values(6123,'转正备注') 
/
insert into HtmlLabelIndex values(6124,'考核实施') 
/
insert into HtmlLabelIndex values(6125,'考核报告') 
/
insert into HtmlLabelIndex values(6126,'实报总金额') 
/
insert into HtmlLabelIndex values(6128,'培训规划') 
/
insert into HtmlLabelIndex values(6130,'培训种类') 
/
insert into HtmlLabelIndex values(6131,'用工需求') 
/
insert into HtmlLabelIndex values(6132,'招聘计划') 
/
insert into HtmlLabelIndex values(6133,'招聘管理') 
/
insert into HtmlLabelIndex values(6134,'面试') 
/
insert into HtmlLabelIndex values(6135,'结束信息') 
/
insert into HtmlLabelIndex values(6136,'培训活动') 
/
insert into HtmlLabelIndex values(6137,'入职维护') 
/
insert into HtmlLabelIndex values(6138,'考勤维护') 
/
insert into HtmlLabelIndex values(6139,'考勤种类') 
/
insert into HtmlLabelIndex values(6140,'人力资源考勤') 
/
insert into HtmlLabelIndex values(6150,'奖惩申请') 
/
insert into HtmlLabelIndex values(6151,'加班') 
/
insert into HtmlLabelIndex values(6152,'性质') 
/
insert into HtmlLabelIndex values(6153,'到位时间') 
/
insert into HtmlLabelIndex values(6155,'培训申请') 
/
insert into HtmlLabelIndex values(6156,'培训安排') 
/
insert into HtmlLabelIndex values(6157,'是否重新设置基准工资') 
/
insert into HtmlLabelIndex values(6158,'合同种类') 
/
insert into HtmlLabelIndex values(6159,'加班类型') 
/
insert into HtmlLabelIndex values(6160,'业务合同') 
/
insert into HtmlLabelIndex values(6161,'相关合同') 
/
insert into HtmlLabelIndex values(6162,'合同文档') 
/
insert into HtmlLabelIndex values(6163,'多文档') 
/
insert into HtmlLabelIndex values(6164,'会签人') 
/
insert into HtmlLabelIndex values(6165,'租用个数') 
/
insert into HtmlLabelIndex values(6117,'考核项目') 
/
insert into HtmlLabelIndex values(6118,'考核种类') 
/
insert into HtmlLabelIndex values(7172,'奖惩报告') 
/
insert into HtmlLabelIndex values(7173,'奖惩人员统计') 
/
insert into HtmlLabelIndex values(7174,'奖惩趋势图') 
/
insert into HtmlLabelIndex values(7171,'泛微插件下载') 
/
insert into HtmlLabelIndex values(7175,'部门＋安全级别') 
/
insert into HtmlLabelIndex values(7176,'角色＋安全级别＋级别') 
/
insert into HtmlLabelIndex values(7178,'用户类型＋安全级别') 
/
insert into HtmlLabelIndex values(7179,'用户类型') 
/
insert into HtmlLabelIndex values(7180,'总时间') 
/
insert into HtmlLabelIndex values(7181,'外部系统用户') 
/
insert into HtmlLabelIndex values(6141,'申请部门') 
/
insert into HtmlLabelIndex values(6146,'合同金额') 
/
insert into HtmlLabelIndex values(6141,'申请部门') 
/
insert into HtmlLabelIndex values(6146,'合同金额') 
/
insert into HtmlLabelIndex values(6166,'相关产品') 
/
insert into HtmlLabelIndex values(6166,'相关产品') 
/
insert into HtmlLabelIndex values(6167,'月工作总结与计划') 
/
insert into HtmlLabelIndex values(16356,'新闻中心') 
/
insert into HtmlLabelIndex values(16357,'文档: 所有者') 
/
insert into HtmlLabelIndex values(16358,'文档: 部门') 
/
insert into HtmlLabelIndex values(16359,'文档: 阅读') 
/
insert into HtmlLabelIndex values(16360,'最高 50: 被阅读') 
/
insert into HtmlLabelIndex values(16361,'最高 20: 所有者') 
/
insert into HtmlLabelIndex values(16362,'最高 20: 语言') 
/
insert into HtmlLabelIndex values(16363,'最高 20: CRM') 
/
insert into HtmlLabelIndex values(16364,'最高 20: 人力资源') 
/
insert into HtmlLabelIndex values(16365,'最高 20: 项目') 
/
insert into HtmlLabelIndex values(16366,'最高 20: 部门') 
/
insert into HtmlLabelIndex values(16367,'模板设置') 
/
insert into HtmlLabelIndex values(16368,'新闻页设置') 
/
insert into HtmlLabelIndex values(16369,'文档编辑模板') 
/
insert into HtmlLabelIndex values(16370,'文档显示模板') 
/
insert into HtmlLabelIndex values(16371,'数据中心') 
/
insert into HtmlLabelIndex values(16372,'报表中心') 
/
insert into HtmlLabelIndex values(16373,'设置中心') 
/
insert into HtmlLabelIndex values(16374,'操作 - 近期') 
/
insert into HtmlLabelIndex values(16375,'送货类型') 
/
insert into HtmlLabelIndex values(16376,'客户价值评估标准') 
/
insert into HtmlLabelIndex values(16377,'客户价值评估项目') 
/
insert into HtmlLabelIndex values(16378,'分类信息') 
/
insert into HtmlLabelIndex values(16379,'权限转移') 
/
insert into HtmlLabelIndex values(16380,'操作菜单') 
/
insert into HtmlLabelIndex values(16381,'打开本地文件') 
/
insert into HtmlLabelIndex values(16382,'存为本地文件') 
/
insert into HtmlLabelIndex values(16383,'签名印章') 
/
insert into HtmlLabelIndex values(16384,'打开版本') 
/
insert into HtmlLabelIndex values(16385,'显示/隐藏痕迹') 
/
insert into HtmlLabelIndex values(16386,'存为新版本') 
/
insert into HtmlLabelIndex values(16387,'新建签章') 
/
insert into HtmlLabelIndex values(16388,'新建模板') 
/
insert into HtmlLabelIndex values(15000,'外部系统接口') 
/
insert into HtmlLabelIndex values(15001,'请重启') 
/
insert into HtmlLabelIndex values(16390,'新闻设置') 
/
insert into HtmlLabelIndex values(16391,'我的流程') 
/
insert into HtmlLabelIndex values(16393,'查询流程') 
/
insert into HtmlLabelIndex values(16396,'分享知识') 
/
insert into HtmlLabelIndex values(16397,'最新文档') 
/
insert into HtmlLabelIndex values(16398,'文档目录') 
/
insert into HtmlLabelIndex values(16399,'查询文档') 
/
insert into HtmlLabelIndex values(16403,'联系提醒') 
/
insert into HtmlLabelIndex values(16405,'联系情况') 
/
insert into HtmlLabelIndex values(16407,'查询客户') 
/
insert into HtmlLabelIndex values(16409,'审批项目') 
/
insert into HtmlLabelIndex values(16410,'审批任务') 
/
insert into HtmlLabelIndex values(16412,'超期任务') 
/
insert into HtmlLabelIndex values(16419,'审批会议') 
/
insert into HtmlLabelIndex values(16423,'会议室报表') 
/
insert into HtmlLabelIndex values(16424,'查询会议') 
/
insert into HtmlLabelIndex values(16425,'查询资产') 
/
insert into HtmlLabelIndex values(16426,'新建计划') 
/
insert into HtmlLabelIndex values(16427,'查询计划') 
/
insert into HtmlLabelIndex values(16428,'我的日报') 
/
insert into HtmlLabelIndex values(16429,'我的周报') 
/
insert into HtmlLabelIndex values(16431,'我的季报') 
/
insert into HtmlLabelIndex values(16432,'我的年报') 
/
insert into HtmlLabelIndex values(16433,'动态报告') 
/
insert into HtmlLabelIndex values(16434,'绩效考核') 
/
insert into HtmlLabelIndex values(16437,'草稿邮箱') 
/
insert into HtmlLabelIndex values(16438,'垃圾邮箱') 
/
insert into HtmlLabelIndex values(16439,'本地邮箱') 
/
insert into HtmlLabelIndex values(16446,'版本描述') 
/
insert into HtmlLabelIndex values(16447,'目录设置') 
/
insert into HtmlLabelIndex values(16448,'模版设置') 
/
insert into HtmlLabelIndex values(16449,'编辑模板') 
/
insert into HtmlLabelIndex values(16452,'用户定义') 
/
insert into HtmlLabelIndex values(16453,'复制移动') 
/
insert into HtmlLabelIndex values(16454,'泛微插件') 
/
insert into HtmlLabelIndex values(16461,'岗位设置') 
/
insert into HtmlLabelIndex values(16463,'专业设置') 
/
insert into HtmlLabelIndex values(16465,'人员入职') 
/
insert into HtmlLabelIndex values(16466,'人员转正') 
/
insert into HtmlLabelIndex values(16468,'人员调动') 
/
insert into HtmlLabelIndex values(16470,'人员退休') 
/
insert into HtmlLabelIndex values(16471,'人员反聘') 
/
insert into HtmlLabelIndex values(16472,'人员解聘') 
/
insert into HtmlLabelIndex values(16473,'签章设置') 
/
insert into HtmlLabelIndex values(16474,'考勤设置') 
/
insert into HtmlLabelIndex values(16475,'公司时间') 
/
insert into HtmlLabelIndex values(16476,'部门时间') 
/
insert into HtmlLabelIndex values(16477,'人员时间') 
/
insert into HtmlLabelIndex values(16479,'合同模版') 
/
insert into HtmlLabelIndex values(16480,'工资福利') 
/
insert into HtmlLabelIndex values(16482,'类型设置') 
/
insert into HtmlLabelIndex values(16490,'分类设置') 
/
insert into HtmlLabelIndex values(16491,'行业设置') 
/
insert into HtmlLabelIndex values(16492,'规模设置') 
/
insert into HtmlLabelIndex values(16493,'类别设置') 
/
insert into HtmlLabelIndex values(16494,'描述设置') 
/
insert into HtmlLabelIndex values(16495,'状态设置') 
/
insert into HtmlLabelIndex values(16497,'评估项目') 
/
insert into HtmlLabelIndex values(16501,'合同信用') 
/
insert into HtmlLabelIndex values(16502,'额度期间') 
/
insert into HtmlLabelIndex values(16503,'字段定义') 
/
insert into HtmlLabelIndex values(16504,'期间设置') 
/
insert into HtmlLabelIndex values(16506,'财务销帐') 
/
insert into HtmlLabelIndex values(16508,'类型定义') 
/
insert into HtmlLabelIndex values(16509,'新建资料') 
/
insert into HtmlLabelIndex values(16510,'属性设置') 
/
insert into HtmlLabelIndex values(16511,'单位设置') 
/
insert into HtmlLabelIndex values(16512,'产品设置') 
/
insert into HtmlLabelIndex values(16521,'用户管理') 
/
insert into HtmlLabelIndex values(16523,'省份设置') 
/
insert into HtmlLabelIndex values(16529,'邮件及文件') 
/
insert into HtmlLabelIndex values(16530,'人事报表') 
/
insert into HtmlLabelIndex values(16535,'资产报表') 
/
insert into HtmlLabelIndex values(16537,'通讯录本') 
/
insert into HtmlLabelIndex values(16538,'统计报表') 
/
insert into HtmlLabelIndex values(16539,'计划任务') 
/
insert into HtmlLabelIndex values(16540,'工作报告') 
/
insert into HtmlLabelIndex values(16541,'任务统计') 
/
insert into HtmlLabelIndex values(16542,'流程报告') 
/
insert into HtmlLabelIndex values(16546,'职级报表') 
/
insert into HtmlLabelIndex values(16550,'学历报表') 
/
insert into HtmlLabelIndex values(16551,'部门报表') 
/
insert into HtmlLabelIndex values(16552,'岗位报表') 
/
insert into HtmlLabelIndex values(16553,'职务报表') 
/
insert into HtmlLabelIndex values(16554,'职称报表') 
/
insert into HtmlLabelIndex values(16555,'状态报表') 
/
insert into HtmlLabelIndex values(16556,'培训相关') 
/
insert into HtmlLabelIndex values(16559,'考勤报表') 
/
insert into HtmlLabelIndex values(16560,'薪金统计') 
/
insert into HtmlLabelIndex values(16561,'工资差异') 
/
insert into HtmlLabelIndex values(16564,'调动情况') 
/
insert into HtmlLabelIndex values(16565,'新增情况') 
/
insert into HtmlLabelIndex values(16568,'返聘情况') 
/
insert into HtmlLabelIndex values(16569,'退休情况') 
/
insert into HtmlLabelIndex values(16570,'离职情况') 
/
insert into HtmlLabelIndex values(16571,'解聘情况') 
/
insert into HtmlLabelIndex values(16572,'合同情况') 
/
insert into HtmlLabelIndex values(16573,'项目经理') 
/
insert into HtmlLabelIndex values(16575,'近期修改') 
/
insert into HtmlLabelIndex values(16576,'近期读取') 
/
insert into HtmlLabelIndex values(16577,'未完流程') 
/
insert into HtmlLabelIndex values(16579,'流程类型') 
/
insert into HtmlLabelIndex values(16583,'客户行业') 
/
insert into HtmlLabelIndex values(16584,'共享情况') 
/
insert into HtmlLabelIndex values(16585,'机会列表') 
/
insert into HtmlLabelIndex values(16588,'应收应付') 
/
insert into HtmlLabelIndex values(16589,'合同产品') 
/
insert into HtmlLabelIndex values(16590,'区域金额') 
/
insert into HtmlLabelIndex values(16591,'产品金额') 
/
insert into HtmlLabelIndex values(16594,'累计金额') 
/
insert into HtmlLabelIndex values(16595,'日志报表') 
/
insert into HtmlLabelIndex values(16596,'近期登录') 
/
insert into HtmlLabelIndex values(16597,'类型报表') 
/
insert into HtmlLabelIndex values(16598,'人员资产') 
/
insert into HtmlLabelIndex values(16600,'著者文档数量') 
/
insert into HtmlLabelIndex values(16601,'部门文档数量 ') 
/
insert into HtmlLabelIndex values(16602,'最近阅读日志') 
/
insert into HtmlLabelIndex values(16603,'知识沉积报表') 
/
insert into HtmlLabelIndex values(16604,'文档被阅报表') 
/
insert into HtmlLabelIndex values(16607,'最多文档著者') 
/
insert into HtmlLabelIndex values(16610,'最多关联人员') 
/
insert into HtmlLabelIndex values(16611,'最多文档项目') 
/
insert into HtmlLabelIndex values(16612,'最多文档部门') 
/
insert into HtmlLabelIndex values(16613,'会议报表') 
/
insert into HtmlLabelIndex values(16614,'会议室报表') 
/
insert into HtmlLabelIndex values(16615,'会议室设置') 
/
insert into HtmlLabelIndex values(16616,'会议类型设置') 
/
insert into HtmlLabelIndex values(16618,'数据中心设置') 
/
insert into HtmlLabelIndex values(16619,'关闭预算输入') 
/
insert into HtmlLabelIndex values(16620,'数据中心') 
/
insert into HtmlLabelIndex values(16621,'数据中心') 
/
insert into HtmlLabelIndex values(16625,'数据中心') 
/
insert into HtmlLabelIndex values(16627,'签章管理') 
/
insert into HtmlLabelIndex values(16629,'数据中心') 
/
insert into HtmlLabelIndex values(16630,'数据中心') 
/
insert into HtmlLabelIndex values(16632,'商店') 
/
insert into HtmlLabelIndex values(16634,'确认') 
/
insert into HtmlLabelIndex values(16638,'清除密码') 
/
insert into HtmlLabelIndex values(16640,'复制到服务器') 
/
insert into HtmlLabelIndex values(15002,'登入系统') 
/
insert into HtmlLabelIndex values(15003,'新建功能') 
/
insert into HtmlLabelIndex values(15004,'新建请求') 
/
insert into HtmlLabelIndex values(15005,'新建人员') 
/
insert into HtmlLabelIndex values(15006,'新建客户') 
/
insert into HtmlLabelIndex values(15007,'新建项目') 
/
insert into HtmlLabelIndex values(15008,'新建会议') 
/
insert into HtmlLabelIndex values(15009,'新建资产') 
/
insert into HtmlLabelIndex values(15010,'我的工作日历') 
/
insert into HtmlLabelIndex values(15011,'知识文档') 
/
insert into HtmlLabelIndex values(15012,'系统现有') 
/
insert into HtmlLabelIndex values(15013,'篇文档') 
/
insert into HtmlLabelIndex values(15014,'您创建') 
/
insert into HtmlLabelIndex values(15015,'篇') 
/
insert into HtmlLabelIndex values(15016,'您有未读') 
/
insert into HtmlLabelIndex values(15017,'浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。') 
/
insert into HtmlLabelIndex values(15018,'licence文件') 
/
insert into HtmlLabelIndex values(15019,'识别码') 
/
insert into HtmlLabelIndex values(15020,'提　示') 
/
insert into HtmlLabelIndex values(15021,'请将') 
/
insert into HtmlLabelIndex values(15022,'及') 
/
insert into HtmlLabelIndex values(15023,'提交给软件供应商,以获取License') 
/
insert into HtmlLabelIndex values(15024,'数据库') 
/
insert into HtmlLabelIndex values(15025,'数据库类型') 
/
insert into HtmlLabelIndex values(15026,'数据库名称') 
/
insert into HtmlLabelIndex values(15027,'使用现有数据库') 
/
insert into HtmlLabelIndex values(15028,'软件类型') 
/
insert into HtmlLabelIndex values(15029,'用户数') 
/
insert into HtmlLabelIndex values(15030,'有效期') 
/
insert into HtmlLabelIndex values(15031,'您有新的工作流需要处理') 
/
insert into HtmlLabelIndex values(15032,'您创建的工作流已经完成') 
/
insert into HtmlLabelIndex values(15033,'关闭窗口') 
/
insert into HtmlLabelIndex values(15034,'您想现在处理吗') 
/
insert into HtmlLabelIndex values(15035,'您想现在查看吗') 
/
insert into HtmlLabelIndex values(15036,'您收到提醒工作流') 
/
insert into HtmlLabelIndex values(15037,'邮件系统设置') 
/
insert into HtmlLabelIndex values(15038,'服务器') 
/
insert into HtmlLabelIndex values(15039,'是否需要发件认证') 
/
insert into HtmlLabelIndex values(15040,'群发SMTP服务器') 
/
insert into HtmlLabelIndex values(15041,'群发默认发件人地址') 
/
insert into HtmlLabelIndex values(15042,'群发默认认证用户名') 
/
insert into HtmlLabelIndex values(15043,'群发默认认证用户密码') 
/
insert into HtmlLabelIndex values(15044,'群发服务器是否需要发件认证') 
/
insert into HtmlLabelIndex values(15045,'文件系统设置') 
/
insert into HtmlLabelIndex values(15046,'文件存放目录') 
/
insert into HtmlLabelIndex values(15047,'文件备份目录') 
/
insert into HtmlLabelIndex values(15048,'文件备份周期') 
/
insert into HtmlLabelIndex values(15049,'分钟') 
/
insert into HtmlLabelIndex values(15050,'是否压缩存放') 
/
insert into HtmlLabelIndex values(15051,'基础数据报表') 
/
insert into HtmlLabelIndex values(15052,'系统角色') 
/
insert into HtmlLabelIndex values(15053,'人员角色') 
/
insert into HtmlLabelIndex values(15054,'资产管理基础数据') 
/
insert into HtmlLabelIndex values(15055,'客户管理基础数据') 
/
insert into HtmlLabelIndex values(15056,'知识管理基础数据') 
/
insert into HtmlLabelIndex values(15057,'审批工作流') 
/
insert into HtmlLabelIndex values(15058,'审批流程') 
/
insert into HtmlLabelIndex values(15059,'默认共享') 
/
insert into HtmlLabelIndex values(15060,'可') 
/
insert into HtmlLabelIndex values(15061,'类客户') 
/
insert into HtmlLabelIndex values(15062,'部门级') 
/
insert into HtmlLabelIndex values(15063,'分部级') 
/
insert into HtmlLabelIndex values(15064,'总部级') 
/
insert into HtmlLabelIndex values(15065,'人力资源基础数据') 
/
insert into HtmlLabelIndex values(15066,'人员角色基础数据') 
/
insert into HtmlLabelIndex values(15067,'系统角色基础数据') 
/
insert into HtmlLabelIndex values(15068,'角色名称') 
/
insert into HtmlLabelIndex values(15069,'工作流程基础数据') 
/
insert into HtmlLabelIndex values(15070,'节点名称') 
/
insert into HtmlLabelIndex values(15071,'无创建人') 
/
insert into HtmlLabelIndex values(15072,'操作组') 
/
insert into HtmlLabelIndex values(15073,'操作组定义') 
/
insert into HtmlLabelIndex values(15074,'目标节点') 
/
insert into HtmlLabelIndex values(15075,'是否退回') 
/
insert into HtmlLabelIndex values(15076,'退回节点') 
/
insert into HtmlLabelIndex values(15077,'流程涉及相关人员') 
/
insert into HtmlLabelIndex values(15078,'客户状态') 
/
insert into HtmlLabelIndex values(15079,'创建人本人') 
/
insert into HtmlLabelIndex values(15080,'创建人经理') 
/
insert into HtmlLabelIndex values(15081,'创建人本部门') 
/
insert into HtmlLabelIndex values(15082,'可退回') 
/
insert into HtmlLabelIndex values(15083,'不可退回') 
/
insert into HtmlLabelIndex values(15084,'上移') 
/
insert into HtmlLabelIndex values(15085,'下移') 
/
insert into HtmlLabelIndex values(15086,'有') 
/
insert into HtmlLabelIndex values(15087,'份邮件到达') 
/
insert into HtmlLabelIndex values(15088,'新闻与公告') 
/
insert into HtmlLabelIndex values(15089,'我的下属') 
/
insert into HtmlLabelIndex values(15090,'工作安排') 
/
insert into HtmlLabelIndex values(15091,'会议安排') 
/
insert into HtmlLabelIndex values(15092,'还款提醒') 
/
insert into HtmlLabelIndex values(15093,'安排工作') 
/
insert into HtmlLabelIndex values(15094,'登录名冲突') 
/
insert into HtmlLabelIndex values(15095,'本系统登陆名') 
/
insert into HtmlLabelIndex values(15096,'外部系统登陆名') 
/
insert into HtmlLabelIndex values(15097,'确定要删除吗?') 
/
insert into HtmlLabelIndex values(15098,'功能列表') 
/
insert into HtmlLabelIndex values(15099,'添加客户') 
/
insert into HtmlLabelIndex values(15100,'查找') 
/
insert into HtmlLabelIndex values(15101,'报表') 
/
insert into HtmlLabelIndex values(15102,'销售机会时间分布设置') 
/
insert into HtmlLabelIndex values(15103,'成功关键因素') 
/
insert into HtmlLabelIndex values(15104,'失败关键因素') 
/
insert into HtmlLabelIndex values(15105,'产品及报价') 
/
insert into HtmlLabelIndex values(15106,'产品类别') 
/
insert into HtmlLabelIndex values(15107,'产品维护') 
/
insert into HtmlLabelIndex values(15108,'产品列表') 
/
insert into HtmlLabelIndex values(15109,'调查') 
/
insert into HtmlLabelIndex values(15110,'新建调查') 
/
insert into HtmlLabelIndex values(15111,'后台管理') 
/
insert into HtmlLabelIndex values(15112,'归档状态') 
/
insert into HtmlLabelIndex values(15113,'时间分布') 
/
insert into HtmlLabelIndex values(15114,'区域') 
/
insert into HtmlLabelIndex values(15115,'产品') 
/
insert into HtmlLabelIndex values(15116,'销售人员') 
/
insert into HtmlLabelIndex values(15117,'合同应收应付') 
/
insert into HtmlLabelIndex values(15118,'合同相关产品') 
/
insert into HtmlLabelIndex values(15119,'数据库错误') 
/
insert into HtmlLabelIndex values(15120,'开发手册') 
/
insert into HtmlLabelIndex values(15121,'客户关系管理') 
/
insert into HtmlLabelIndex values(15122,'后退') 
/
insert into HtmlLabelIndex values(15123,'前进') 
/
insert into HtmlLabelIndex values(15124,'客户卡片相关') 
/
insert into HtmlLabelIndex values(15125,'帐务') 
/
insert into HtmlLabelIndex values(15126,'搜索关键字不够精确') 
/
insert into HtmlLabelIndex values(15127,'还未完成') 
/
insert into HtmlLabelIndex values(15128,'添加一行') 
/
insert into HtmlLabelIndex values(15129,'产品名称') 
/
insert into HtmlLabelIndex values(15130,'折扣') 
/
insert into HtmlLabelIndex values(15131,'付款方式') 
/
insert into HtmlLabelIndex values(15132,'付款项目') 
/
insert into HtmlLabelIndex values(15133,'付款性质') 
/
insert into HtmlLabelIndex values(15134,'付款金额') 
/
insert into HtmlLabelIndex values(15135,'付款日期') 
/
insert into HtmlLabelIndex values(15136,'付款条件') 
/
insert into HtmlLabelIndex values(15137,'应收') 
/
insert into HtmlLabelIndex values(15138,'应付') 
/
insert into HtmlLabelIndex values(15139,'新建客户合同') 
/
insert into HtmlLabelIndex values(15140,'客户合同') 
/
insert into HtmlLabelIndex values(15141,'完') 
/
insert into HtmlLabelIndex values(15142,'合同名称') 
/
insert into HtmlLabelIndex values(15143,'提交审批') 
/
insert into HtmlLabelIndex values(15144,'执行完成') 
/
insert into HtmlLabelIndex values(15145,'实际交货数量') 
/
insert into HtmlLabelIndex values(15146,'实际交货日期') 
/
insert into HtmlLabelIndex values(15147,'已完毕') 
/
insert into HtmlLabelIndex values(15148,'提醒') 
/
insert into HtmlLabelIndex values(15149,'付款') 
/
insert into HtmlLabelIndex values(15150,'实际付款日期') 
/
insert into HtmlLabelIndex values(15151,'已收款') 
/
insert into HtmlLabelIndex values(15152,'已付款') 
/
insert into HtmlLabelIndex values(15153,'相关交流') 
/
insert into HtmlLabelIndex values(15154,'部分') 
/
insert into HtmlLabelIndex values(15155,'客户门户申请') 
/
insert into HtmlLabelIndex values(15156,'门户状态变更') 
/
insert into HtmlLabelIndex values(15157,'客户状态变更') 
/
insert into HtmlLabelIndex values(15158,'客户级别变更') 
/
insert into HtmlLabelIndex values(15159,'客户经理变更') 
/
insert into HtmlLabelIndex values(15160,'确定要合并吗') 
/
insert into HtmlLabelIndex values(15161,'跟踪') 
/
insert into HtmlLabelIndex values(15162,'应收总额') 
/
insert into HtmlLabelIndex values(15163,'第一笔应收款时间') 
/
insert into HtmlLabelIndex values(15164,'变更客户合同') 
/
insert into HtmlLabelIndex values(15165,'调查表单的HTML文件') 
/
insert into HtmlLabelIndex values(15166,'如果你不希望再次收到此类邮件，请点击') 
/
insert into HtmlLabelIndex values(15167,'退订') 
/
insert into HtmlLabelIndex values(15168,'注') 
/
insert into HtmlLabelIndex values(15169,'请把下面的HTML代码粘贴到邮件模板中') 
/
insert into HtmlLabelIndex values(15170,'系统提示：对不起，空记录不能进行转换') 
/
insert into HtmlLabelIndex values(15171,'退订失败') 
/
insert into HtmlLabelIndex values(15172,'系统提示') 
/
insert into HtmlLabelIndex values(15173,'提交失败') 
/
insert into HtmlLabelIndex values(15174,'已提交的客户') 
/
insert into HtmlLabelIndex values(15175,'提交日期') 
/
insert into HtmlLabelIndex values(15176,'已提交') 
/
insert into HtmlLabelIndex values(15177,'未提交的客户') 
/
insert into HtmlLabelIndex values(15178,'未提交') 
/
insert into HtmlLabelIndex values(15179,'退订的客户') 
/
insert into HtmlLabelIndex values(15180,'退订日期') 
/
insert into HtmlLabelIndex values(15181,'调查表内容') 
/
insert into HtmlLabelIndex values(15182,'调查信息') 
/
insert into HtmlLabelIndex values(15183,'调查表单名称') 
/
insert into HtmlLabelIndex values(15184,'输入报表') 
/
insert into HtmlLabelIndex values(15185,'输入报表名称') 
/
insert into HtmlLabelIndex values(15186,'数据表名') 
/
insert into HtmlLabelIndex values(15187,'调查报表') 
/
insert into HtmlLabelIndex values(15188,'输入信息') 
/
insert into HtmlLabelIndex values(15189,'调查表名称') 
/
insert into HtmlLabelIndex values(15190,'数据库表名') 
/
insert into HtmlLabelIndex values(15191,'格式为') 
/
insert into HtmlLabelIndex values(15192,'其表名不能重复') 
/
insert into HtmlLabelIndex values(15193,'请输入您所需要链接的地址') 
/
insert into HtmlLabelIndex values(15194,'如') 
/
insert into HtmlLabelIndex values(15195,'邮件版式') 
/
insert into HtmlLabelIndex values(15196,'格式') 
/
insert into HtmlLabelIndex values(15197,'调查表信息') 
/
insert into HtmlLabelIndex values(15198,'邮件模板名') 
/
insert into HtmlLabelIndex values(15199,'输入项信息') 
/
insert into HtmlLabelIndex values(15200,'输入项') 
/
insert into HtmlLabelIndex values(15201,'单行文本型') 
/
insert into HtmlLabelIndex values(15202,'整数型') 
/
insert into HtmlLabelIndex values(15203,'浮点型') 
/
insert into HtmlLabelIndex values(15204,'单选型') 
/
insert into HtmlLabelIndex values(15205,'多选型') 
/
insert into HtmlLabelIndex values(15206,'多行文本型') 
/
insert into HtmlLabelIndex values(15207,'输入项名称') 
/
insert into HtmlLabelIndex values(15208,'输入项类型') 
/
insert into HtmlLabelIndex values(15209,'输入项字段名') 
/
insert into HtmlLabelIndex values(15210,'其字段名不能重复') 
/
insert into HtmlLabelIndex values(15211,'文本字段宽度') 
/
insert into HtmlLabelIndex values(15212,'小数位数') 
/
insert into HtmlLabelIndex values(15213,'调查表单输入项信息') 
/
insert into HtmlLabelIndex values(15214,'选择项详细值') 
/
insert into HtmlLabelIndex values(15215,'选择显示值和数据表值应一致') 
/
insert into HtmlLabelIndex values(15216,'选择显示值') 
/
insert into HtmlLabelIndex values(15217,'数据表值') 
/
insert into HtmlLabelIndex values(15218,'调查表单') 
/
insert into HtmlLabelIndex values(15219,'接收调查表情况') 
/
insert into HtmlLabelIndex values(15220,'应提交的总客户') 
/
insert into HtmlLabelIndex values(15221,'实际提交的总客户') 
/
insert into HtmlLabelIndex values(15222,'退订的总客户') 
/
insert into HtmlLabelIndex values(15223,'总权重指数不能大于') 
/
insert into HtmlLabelIndex values(15224,'已收') 
/
insert into HtmlLabelIndex values(15225,'未收') 
/
insert into HtmlLabelIndex values(15226,'已付') 
/
insert into HtmlLabelIndex values(15227,'未付') 
/
insert into HtmlLabelIndex values(15228,'应交货') 
/
insert into HtmlLabelIndex values(15229,'已交货') 
/
insert into HtmlLabelIndex values(15230,'未交货') 
/
insert into HtmlLabelIndex values(15231,'客户数') 
/
insert into HtmlLabelIndex values(15232,'上次联系时间') 
/
insert into HtmlLabelIndex values(15233,'交货提醒') 
/
insert into HtmlLabelIndex values(15234,'付款提醒') 
/
insert into HtmlLabelIndex values(15235,'客户合同到期提醒') 
/
insert into HtmlLabelIndex values(15236,'合同结束日期') 
/
insert into HtmlLabelIndex values(15237,'销售区间段天数') 
/
insert into HtmlLabelIndex values(15238,'销售区间段数目') 
/
insert into HtmlLabelIndex values(15239,'中介机构') 
/
insert into HtmlLabelIndex values(15240,'来源') 
/
insert into HtmlLabelIndex values(15241,'请输入0～1之间的数') 
/
insert into HtmlLabelIndex values(15242,'成功') 
/
insert into HtmlLabelIndex values(15243,'请输入正确的收益区间') 
/
insert into HtmlLabelIndex values(15244,'销售机会时间') 
/
insert into HtmlLabelIndex values(15245,'城市业绩统计') 
/
insert into HtmlLabelIndex values(15246,'城市名称') 
/
insert into HtmlLabelIndex values(15247,'销售业绩') 
/
insert into HtmlLabelIndex values(15248,'省份业绩统计') 
/
insert into HtmlLabelIndex values(15249,'新建销售机会') 
/
insert into HtmlLabelIndex values(15250,'编辑销售机会') 
/
insert into HtmlLabelIndex values(15251,'预期收益合计') 
/
insert into HtmlLabelIndex values(15252,'机会') 
/
insert into HtmlLabelIndex values(15253,'已签单合同') 
/
insert into HtmlLabelIndex values(15254,'请输入正确的合同金额区间') 
/
insert into HtmlLabelIndex values(15255,'销售经理') 
/
insert into HtmlLabelIndex values(15256,'区间') 
/
insert into HtmlLabelIndex values(15257,'销售机会统计') 
/
insert into HtmlLabelIndex values(15258,'机会计数') 
/
insert into HtmlLabelIndex values(15259,'销售机会金额') 
/
insert into HtmlLabelIndex values(15260,'金额百分比') 
/
insert into HtmlLabelIndex values(15261,'项目功能列表') 
/
insert into HtmlLabelIndex values(15262,'添加项目') 
/
insert into HtmlLabelIndex values(15263,'客户可见') 
/
insert into HtmlLabelIndex values(15264,'项目费用') 
/
insert into HtmlLabelIndex values(15265,'实际收入') 
/
insert into HtmlLabelIndex values(15266,'新建任务') 
/
insert into HtmlLabelIndex values(15267,'新建任务（执行）') 
/
insert into HtmlLabelIndex values(15268,'编辑任务（执行）') 
/
insert into HtmlLabelIndex values(15269,'新建任务（计划）') 
/
insert into HtmlLabelIndex values(15270,'编辑任务（计划）') 
/
insert into HtmlLabelIndex values(15271,'删除任务（执行）') 
/
insert into HtmlLabelIndex values(15272,'删除任务（计划）') 
/
insert into HtmlLabelIndex values(15273,'结束时间不能小于起始时间') 
/
insert into HtmlLabelIndex values(15274,'项目预算') 
/
insert into HtmlLabelIndex values(15275,'修改日志') 
/
insert into HtmlLabelIndex values(15276,'项目通知') 
/
insert into HtmlLabelIndex values(15277,'前置任务未完成') 
/
insert into HtmlLabelIndex values(15278,'请输入 0～100 之间的整数') 
/
insert into HtmlLabelIndex values(15279,'元') 
/
insert into HtmlLabelIndex values(15280,'通知对象：') 
/
insert into HtmlLabelIndex values(15281,'通知标题：') 
/
insert into HtmlLabelIndex values(15282,'通知内容：') 
/
insert into HtmlLabelIndex values(15283,'新建项目任务') 
/
insert into HtmlLabelIndex values(15284,'编辑任务') 
/
insert into HtmlLabelIndex values(15285,'任务负责人') 
/
insert into HtmlLabelIndex values(15286,'任务比较') 
/
insert into HtmlLabelIndex values(15287,'未开始任务') 
/
insert into HtmlLabelIndex values(15288,'进行中任务') 
/
insert into HtmlLabelIndex values(15289,'已完成任务') 
/
insert into HtmlLabelIndex values(15290,'超期未开始任务') 
/
insert into HtmlLabelIndex values(15291,'超期未完成任务') 
/
insert into HtmlLabelIndex values(15292,'(实际/计划)') 
/
insert into HtmlLabelIndex values(15293,'财务编号') 
/
insert into HtmlLabelIndex values(15294,'报警数量') 
/
insert into HtmlLabelIndex values(15295,'相关工作流') 
/
insert into HtmlLabelIndex values(15296,'统计报告') 
/
insert into HtmlLabelIndex values(15297,'帐内或帐外') 
/
insert into HtmlLabelIndex values(15298,'帐内') 
/
insert into HtmlLabelIndex values(15299,'帐外') 
/
insert into HtmlLabelIndex values(15300,'报废的资产') 
/
insert into HtmlLabelIndex values(15301,'入库部门') 
/
insert into HtmlLabelIndex values(15302,'入库数量') 
/
insert into HtmlLabelIndex values(15303,'数量错误') 
/
insert into HtmlLabelIndex values(15304,'借用的资产') 
/
insert into HtmlLabelIndex values(15305,'资产归还') 
/
insert into HtmlLabelIndex values(15306,'入库申请') 
/
insert into HtmlLabelIndex values(15307,'入库验收') 
/
insert into HtmlLabelIndex values(15308,'维修的资产') 
/
insert into HtmlLabelIndex values(15309,'调拨资产') 
/
insert into HtmlLabelIndex values(15310,'调拨申请人') 
/
insert into HtmlLabelIndex values(15311,'调往部门') 
/
insert into HtmlLabelIndex values(15312,'领用的资产') 
/
insert into HtmlLabelIndex values(15313,'领用的数量') 
/
insert into HtmlLabelIndex values(15314,'领用用途') 
/
insert into HtmlLabelIndex values(15315,'展开') 
/
insert into HtmlLabelIndex values(15316,'资产资料列表') 
/
insert into HtmlLabelIndex values(15317,'上一级') 
/
insert into HtmlLabelIndex values(15318,'不可全部为空') 
/
insert into HtmlLabelIndex values(15319,'数字校验错') 
/
insert into HtmlLabelIndex values(15320,'固定资产') 
/
insert into HtmlLabelIndex values(15321,'低值易耗品') 
/
insert into HtmlLabelIndex values(15322,'至') 
/
insert into HtmlLabelIndex values(15323,'第') 
/
insert into HtmlLabelIndex values(15324,'类') 
/
insert into HtmlLabelIndex values(15325,'借用') 
/
insert into HtmlLabelIndex values(15326,'统计人') 
/
insert into HtmlLabelIndex values(15327,'统计日期') 
/
insert into HtmlLabelIndex values(15328,'驾驶员统计表') 
/
insert into HtmlLabelIndex values(15329,'生成报表') 
/
insert into HtmlLabelIndex values(15330,'驾驶员') 
/
insert into HtmlLabelIndex values(15331,'德隆国际战略投资有限公司行政管理部驾驶员统计表') 
/
insert into HtmlLabelIndex values(15332,'制表人') 
/
insert into HtmlLabelIndex values(15333,'日到') 
/
insert into HtmlLabelIndex values(15334,'工作时间出车次数') 
/
insert into HtmlLabelIndex values(15335,'平时晚间出车次数') 
/
insert into HtmlLabelIndex values(15336,'休息日出车次数') 
/
insert into HtmlLabelIndex values(15337,'外地出车次数') 
/
insert into HtmlLabelIndex values(15338,'行驶公里数') 
/
insert into HtmlLabelIndex values(15339,'燃油费') 
/
insert into HtmlLabelIndex values(15340,'停车过路费') 
/
insert into HtmlLabelIndex values(15341,'修理费') 
/
insert into HtmlLabelIndex values(15342,'电话费') 
/
insert into HtmlLabelIndex values(15343,'加班补助') 
/
insert into HtmlLabelIndex values(15344,'季考核总分数') 
/
insert into HtmlLabelIndex values(15345,'车辆统计表') 
/
insert into HtmlLabelIndex values(15346,'德隆国际战略投资有限公司行政管理部车辆统计表') 
/
insert into HtmlLabelIndex values(15347,'车辆编号') 
/
insert into HtmlLabelIndex values(15348,'行驶总公里数') 
/
insert into HtmlLabelIndex values(15349,'保养费用及时间') 
/
insert into HtmlLabelIndex values(15350,'维修费用及时间') 
/
insert into HtmlLabelIndex values(15351,'清洁费用') 
/
insert into HtmlLabelIndex values(15352,'计划实际比较表') 
/
insert into HtmlLabelIndex values(15353,'生成图表') 
/
insert into HtmlLabelIndex values(15354,'各部门费用计划实际比较表') 
/
insert into HtmlLabelIndex values(15355,'部门需求统计表') 
/
insert into HtmlLabelIndex values(15356,'费用计划实际比较表') 
/
insert into HtmlLabelIndex values(15357,'验证') 
/
insert into HtmlLabelIndex values(15358,'作废') 
/
insert into HtmlLabelIndex values(15359,'验证入库') 
/
insert into HtmlLabelIndex values(15360,'列表显示') 
/
insert into HtmlLabelIndex values(15361,'资产或资料') 
/
insert into HtmlLabelIndex values(15362,'分级显示') 
/
insert into HtmlLabelIndex values(15363,'预算管理') 
/
insert into HtmlLabelIndex values(15364,'条件') 
/
insert into HtmlLabelIndex values(15365,'预算年度') 
/
insert into HtmlLabelIndex values(15366,'申报') 
/
insert into HtmlLabelIndex values(15367,'核准') 
/
insert into HtmlLabelIndex values(15368,'偏差') 
/
insert into HtmlLabelIndex values(15369,'导入申报值') 
/
insert into HtmlLabelIndex values(15370,'月度预算') 
/
insert into HtmlLabelIndex values(15371,'预算类型') 
/
insert into HtmlLabelIndex values(15372,'期') 
/
insert into HtmlLabelIndex values(15373,'季度预算') 
/
insert into HtmlLabelIndex values(15374,'半年预算') 
/
insert into HtmlLabelIndex values(15375,'年度预算') 
/
insert into HtmlLabelIndex values(15376,'通过') 
/
insert into HtmlLabelIndex values(15377,'核准编辑') 
/
insert into HtmlLabelIndex values(15378,'审批状态') 
/
insert into HtmlLabelIndex values(15379,'1、部门的预算申报的各项收入值必须大于或等于核准值(或者没有核准值)，审批才能通过！') 
/
insert into HtmlLabelIndex values(15380,'2、部门的预算申报的各项支出值必须小于或等于核准值(或者没有核准值)，审批才能通过！') 
/
insert into HtmlLabelIndex values(15381,'3、审批通过后，该部门本年度预算申报值和核准值便不能改动！') 
/
insert into HtmlLabelIndex values(15382,'是否继续？') 
/
insert into HtmlLabelIndex values(15383,'有不满足上述两个条件的申报存在，不能审批通过！') 
/
insert into HtmlLabelIndex values(15384,'本年') 
/
insert into HtmlLabelIndex values(15385,'收支类型') 
/
insert into HtmlLabelIndex values(15386,'周期') 
/
insert into HtmlLabelIndex values(15387,'偏差允许') 
/
insert into HtmlLabelIndex values(15388,'预算周期') 
/
insert into HtmlLabelIndex values(15389,'允许偏差') 
/
insert into HtmlLabelIndex values(15390,'部门名称') 
/
insert into HtmlLabelIndex values(15391,'部门编号') 
/
insert into HtmlLabelIndex values(15392,'销帐人') 
/
insert into HtmlLabelIndex values(15393,'所属部门') 
/
insert into HtmlLabelIndex values(15394,'销帐日期') 
/
insert into HtmlLabelIndex values(15395,'销帐金额') 
/
insert into HtmlLabelIndex values(15396,'个人帐务往来') 
/
insert into HtmlLabelIndex values(15397,'发生日期') 
/
insert into HtmlLabelIndex values(15398,'发生金额') 
/
insert into HtmlLabelIndex values(15399,'个人销帐') 
/
insert into HtmlLabelIndex values(15400,'个人欠款累计') 
/
insert into HtmlLabelIndex values(15401,'部门预算') 
/
insert into HtmlLabelIndex values(15402,'个人预算') 
/
insert into HtmlLabelIndex values(15403,'部门收支') 
/
insert into HtmlLabelIndex values(15404,'个人收支') 
/
insert into HtmlLabelIndex values(15405,'客户收支') 
/
insert into HtmlLabelIndex values(15406,'项目收支') 
/
insert into HtmlLabelIndex values(15407,'管理费用明细报表') 
/
insert into HtmlLabelIndex values(15408,'回退') 
/
insert into HtmlLabelIndex values(15409,'科目名称') 
/
insert into HtmlLabelIndex values(15410,'本期发生') 
/
insert into HtmlLabelIndex values(15411,'本年累计') 
/
insert into HtmlLabelIndex values(15412,'期末余额') 
/
insert into HtmlLabelIndex values(15413,'生成') 
/
insert into HtmlLabelIndex values(15414,'显示金额为零的记录') 
/
insert into HtmlLabelIndex values(15415,'显示发生额为零的记录') 
/
insert into HtmlLabelIndex values(15416,'显示包含未过帐凭证') 
/
insert into HtmlLabelIndex values(15417,'万元表') 
/
insert into HtmlLabelIndex values(15418,'货币资金报表') 
/
insert into HtmlLabelIndex values(15419,'上期余额') 
/
insert into HtmlLabelIndex values(15420,'本期借方发生') 
/
insert into HtmlLabelIndex values(15421,'本期贷方发生') 
/
insert into HtmlLabelIndex values(15422,'本期余额') 
/
insert into HtmlLabelIndex values(15423,'借方笔数') 
/
insert into HtmlLabelIndex values(15424,'贷方笔数') 
/
insert into HtmlLabelIndex values(15425,'个人往来报表') 
/
insert into HtmlLabelIndex values(15426,'财务年度') 
/
insert into HtmlLabelIndex values(15427,'预算审批状态') 
/
insert into HtmlLabelIndex values(15428,'月度收支') 
/
insert into HtmlLabelIndex values(15429,'季度收支') 
/
insert into HtmlLabelIndex values(15430,'半年收支') 
/
insert into HtmlLabelIndex values(15431,'年度收支') 
/
insert into HtmlLabelIndex values(15432,'相关处理') 
/
insert into HtmlLabelIndex values(15433,'工作流类型') 
/
insert into HtmlLabelIndex values(15434,'报表种类') 
/
insert into HtmlLabelIndex values(15435,'报表定义') 
/
insert into HtmlLabelIndex values(15436,'固定报表') 
/
insert into HtmlLabelIndex values(15437,'工作流管理') 
/
insert into HtmlLabelIndex values(15438,'流程图编辑') 
/
insert into HtmlLabelIndex values(15439,'默认总金额') 
/
insert into HtmlLabelIndex values(15440,'该字段名已经被使用') 
/
insert into HtmlLabelIndex values(15441,'字段名不能用中文,而且必须以英文字母开头(如f4)') 
/
insert into HtmlLabelIndex values(15442,'可选项文字') 
/
insert into HtmlLabelIndex values(15443,'添加内容') 
/
insert into HtmlLabelIndex values(15444,'删除内容') 
/
insert into HtmlLabelIndex values(15445,'没有选择一个删除项') 
/
insert into HtmlLabelIndex values(15446,'选择表单字段') 
/
insert into HtmlLabelIndex values(15447,'可选字段') 
/
insert into HtmlLabelIndex values(15448,'已选字段') 
/
insert into HtmlLabelIndex values(15449,'编辑字段') 
/
insert into HtmlLabelIndex values(15450,'编辑显示名') 
/
insert into HtmlLabelIndex values(15451,'表单名称') 
/
insert into HtmlLabelIndex values(15452,'表单描述') 
/
insert into HtmlLabelIndex values(15453,'全部字段') 
/
insert into HtmlLabelIndex values(15454,'表单没有字段信息') 
/
insert into HtmlLabelIndex values(15455,'缺省') 
/
insert into HtmlLabelIndex values(15456,'字段显示名') 
/
insert into HtmlLabelIndex values(15457,'必须先选择一种语言') 
/
insert into HtmlLabelIndex values(15458,'这种语言已经存在,请另外选择一种') 
/
insert into HtmlLabelIndex values(15459,'确定删除选定的信息吗') 
/
insert into HtmlLabelIndex values(15460,'序列号') 
/
insert into HtmlLabelIndex values(15461,'快递类型') 
/
insert into HtmlLabelIndex values(15462,'调整费用') 
/
insert into HtmlLabelIndex values(15463,'没有选择一个具体单据') 
/
insert into HtmlLabelIndex values(15464,'费用月结') 
/
insert into HtmlLabelIndex values(15465,'单据号') 
/
insert into HtmlLabelIndex values(15466,'印刷公司') 
/
insert into HtmlLabelIndex values(15467,'出票公司') 
/
insert into HtmlLabelIndex values(15468,'订票人') 
/
insert into HtmlLabelIndex values(15469,'订票日期') 
/
insert into HtmlLabelIndex values(15470,'市内快递') 
/
insert into HtmlLabelIndex values(15471,'快递公司') 
/
insert into HtmlLabelIndex values(15472,'特快专递') 
/
insert into HtmlLabelIndex values(15473,'机票预定') 
/
insert into HtmlLabelIndex values(15474,'购置金额') 
/
insert into HtmlLabelIndex values(15475,'购置用途') 
/
insert into HtmlLabelIndex values(15476,'要求时间') 
/
insert into HtmlLabelIndex values(15477,'整个公司合计') 
/
insert into HtmlLabelIndex values(15478,'固定资产名称') 
/
insert into HtmlLabelIndex values(15479,'预计总金额') 
/
insert into HtmlLabelIndex values(15480,'调入部门') 
/
insert into HtmlLabelIndex values(15481,'调出部门') 
/
insert into HtmlLabelIndex values(15482,'原价') 
/
insert into HtmlLabelIndex values(15483,'资产状况') 
/
insert into HtmlLabelIndex values(15484,'调拨原因') 
/
insert into HtmlLabelIndex values(15485,'本月工作小结') 
/
insert into HtmlLabelIndex values(15486,'序号') 
/
insert into HtmlLabelIndex values(15487,'完成情况描述') 
/
insert into HtmlLabelIndex values(15488,'权重指数') 
/
insert into HtmlLabelIndex values(15489,'考核评分') 
/
insert into HtmlLabelIndex values(15490,'下月工作计划') 
/
insert into HtmlLabelIndex values(15491,'下月工作目标') 
/
insert into HtmlLabelIndex values(15492,'达成结果') 
/
insert into HtmlLabelIndex values(15493,'本周工作小结') 
/
insert into HtmlLabelIndex values(15494,'主要事项') 
/
insert into HtmlLabelIndex values(15495,'完成的结果') 
/
insert into HtmlLabelIndex values(15496,'没完成事项') 
/
insert into HtmlLabelIndex values(15497,'原因或改进措施') 
/
insert into HtmlLabelIndex values(15498,'下周工作计划') 
/
insert into HtmlLabelIndex values(15499,'主要计划事项') 
/
insert into HtmlLabelIndex values(15500,'预计完成时间') 
/
insert into HtmlLabelIndex values(15501,'关键因素') 
/
insert into HtmlLabelIndex values(15502,'操作时间') 
/
insert into HtmlLabelIndex values(15503,'操作类型') 
/
insert into HtmlLabelIndex values(15504,'清空') 
/
insert into HtmlLabelIndex values(15505,'报表条件') 
/
insert into HtmlLabelIndex values(15506,'不等于') 
/
insert into HtmlLabelIndex values(15507,'不包含') 
/
insert into HtmlLabelIndex values(15508,'大于') 
/
insert into HtmlLabelIndex values(15509,'小于') 
/
insert into HtmlLabelIndex values(15510,'报表显示项') 
/
insert into HtmlLabelIndex values(15511,'是否统计') 
/
insert into HtmlLabelIndex values(15512,'排序字段') 
/
insert into HtmlLabelIndex values(15513,'显示顺序') 
/
insert into HtmlLabelIndex values(15514,'报表管理') 
/
insert into HtmlLabelIndex values(15515,'显示项') 
/
insert into HtmlLabelIndex values(15516,'是否排序字段') 
/
insert into HtmlLabelIndex values(15517,'报表名称') 
/
insert into HtmlLabelIndex values(15518,'重新查询') 
/
insert into HtmlLabelIndex values(15519,'报表种类管理') 
/
insert into HtmlLabelIndex values(15520,'种类名称') 
/
insert into HtmlLabelIndex values(15521,'种类描述') 
/
insert into HtmlLabelIndex values(15522,'请求类型') 
/
insert into HtmlLabelIndex values(15523,'最久时间') 
/
insert into HtmlLabelIndex values(15524,'计划完成统计') 
/
insert into HtmlLabelIndex values(15525,'接收人') 
/
insert into HtmlLabelIndex values(15526,'员工任务完成统计图') 
/
insert into HtmlLabelIndex values(15527,'固定报表管理') 
/
insert into HtmlLabelIndex values(15528,'页面名称') 
/
insert into HtmlLabelIndex values(15529,'对应模块') 
/
insert into HtmlLabelIndex values(15530,'读取者') 
/
insert into HtmlLabelIndex values(15531,'报表描述') 
/
insert into HtmlLabelIndex values(15532,'程度') 
/
insert into HtmlLabelIndex values(15533,'重要') 
/
insert into HtmlLabelIndex values(15534,'紧急程度') 
/
insert into HtmlLabelIndex values(15535,'没有相关工作流') 
/
insert into HtmlLabelIndex values(15536,'节点类型') 
/
insert into HtmlLabelIndex values(15537,'今天') 
/
insert into HtmlLabelIndex values(15538,'最后24小时') 
/
insert into HtmlLabelIndex values(15539,'本周') 
/
insert into HtmlLabelIndex values(15540,'最后日期') 
/
insert into HtmlLabelIndex values(15541,'本月') 
/
insert into HtmlLabelIndex values(15542,'本年度') 
/
insert into HtmlLabelIndex values(15543,'请先选择需要删除的信息') 
/
insert into HtmlLabelIndex values(15544,'操作者组') 
/
insert into HtmlLabelIndex values(15545,'操作组名称') 
/
insert into HtmlLabelIndex values(15546,'类型的节点只能有一个') 
/
insert into HtmlLabelIndex values(15547,'能否全程跟踪') 
/
insert into HtmlLabelIndex values(15548,'操作者条件') 
/
insert into HtmlLabelIndex values(15549,'人力资源字段') 
/
insert into HtmlLabelIndex values(15550,'文档字段') 
/
insert into HtmlLabelIndex values(15551,'项目字段') 
/
insert into HtmlLabelIndex values(15552,'资产字段') 
/
insert into HtmlLabelIndex values(15553,'客户字段') 
/
insert into HtmlLabelIndex values(15554,'门户相关') 
/
insert into HtmlLabelIndex values(15555,'人力资源字段本人') 
/
insert into HtmlLabelIndex values(15556,'非会签') 
/
insert into HtmlLabelIndex values(15557,'会签') 
/
insert into HtmlLabelIndex values(15558,'依次逐个处理') 
/
insert into HtmlLabelIndex values(15559,'人力资源字段经理') 
/
insert into HtmlLabelIndex values(15560,'人力资源字段下属') 
/
insert into HtmlLabelIndex values(15561,'人力资源字段本分部') 
/
insert into HtmlLabelIndex values(15562,'人力资源字段本部门') 
/
insert into HtmlLabelIndex values(15563,'人力资源字段上级部门') 
/
insert into HtmlLabelIndex values(15564,'文档字段所有者') 
/
insert into HtmlLabelIndex values(15565,'文档字段分部') 
/
insert into HtmlLabelIndex values(15566,'文档字段部门') 
/
insert into HtmlLabelIndex values(15567,'项目字段经理') 
/
insert into HtmlLabelIndex values(15568,'项目字段分部') 
/
insert into HtmlLabelIndex values(15569,'项目字段部门') 
/
insert into HtmlLabelIndex values(15570,'项目字段成员') 
/
insert into HtmlLabelIndex values(15571,'资产字段管理员') 
/
insert into HtmlLabelIndex values(15572,'资产字段分部') 
/
insert into HtmlLabelIndex values(15573,'资产字段部门') 
/
insert into HtmlLabelIndex values(15574,'客户字段经理') 
/
insert into HtmlLabelIndex values(15575,'客户字段联系人经理') 
/
insert into HtmlLabelIndex values(15576,'创建人下属') 
/
insert into HtmlLabelIndex values(15577,'创建人本分部') 
/
insert into HtmlLabelIndex values(15578,'创建人上级部门') 
/
insert into HtmlLabelIndex values(15579,'客户部门') 
/
insert into HtmlLabelIndex values(15580,'客户字段本人') 
/
insert into HtmlLabelIndex values(15581,'所有客户') 
/
insert into HtmlLabelIndex values(15582,'添加条件') 
/
insert into HtmlLabelIndex values(15583,'删除条件') 
/
insert into HtmlLabelIndex values(15584,'请先选择操作对象的值') 
/
insert into HtmlLabelIndex values(15585,'不会签') 
/
insert into HtmlLabelIndex values(15586,'节点') 
/
insert into HtmlLabelIndex values(15587,'出口') 
/
insert into HtmlLabelIndex values(15588,'是否门户相关') 
/
insert into HtmlLabelIndex values(15589,'非门户相关') 
/
insert into HtmlLabelIndex values(15590,'单据') 
/
insert into HtmlLabelIndex values(15591,'是否有效') 
/
insert into HtmlLabelIndex values(15592,'是否编号') 
/
insert into HtmlLabelIndex values(15593,'帮组文档') 
/
insert into HtmlLabelIndex values(15594,'工作流描述') 
/
insert into HtmlLabelIndex values(15595,'类型的节点有且只能有一个') 
/
insert into HtmlLabelIndex values(15596,'工作流节点') 
/
insert into HtmlLabelIndex values(15597,'请选择节点类型') 
/
insert into HtmlLabelIndex values(15598,'添加节点') 
/
insert into HtmlLabelIndex values(15599,'删除节点') 
/
insert into HtmlLabelIndex values(15600,'对应表单') 
/
insert into HtmlLabelIndex values(15601,'字段信息') 
/
insert into HtmlLabelIndex values(15602,'请选择当前节点') 
/
insert into HtmlLabelIndex values(15603,'是否显示') 
/
insert into HtmlLabelIndex values(15604,'是否可编辑') 
/
insert into HtmlLabelIndex values(15605,'是否必须输入') 
/
insert into HtmlLabelIndex values(15606,'出口信息') 
/
insert into HtmlLabelIndex values(15607,'添加出口') 
/
insert into HtmlLabelIndex values(15608,'删除出口') 
/
insert into HtmlLabelIndex values(15609,'是否reject') 
/
insert into HtmlLabelIndex values(15610,'附加规则') 
/
insert into HtmlLabelIndex values(15611,'出口名称') 
/
insert into HtmlLabelIndex values(15612,'请选择目标节点') 
/
insert into HtmlLabelIndex values(15613,'请先保存新插入的节点出口') 
/
insert into HtmlLabelIndex values(15614,'此网页使用了框架，但您的浏览器不支持框架。') 
/
insert into HtmlLabelIndex values(15615,'节点信息') 
/
insert into HtmlLabelIndex values(15616,'附加操作') 
/
insert into HtmlLabelIndex values(15617,'删除工作流将删除该工作流下的所有请求,并可能导致系统中相关这些请求的链接出现错误!') 
/
insert into HtmlLabelIndex values(15618,'第一字段') 
/
insert into HtmlLabelIndex values(15619,'第二字段') 
/
insert into HtmlLabelIndex values(15620,'目标字段') 
/
insert into HtmlLabelIndex values(15621,'加') 
/
insert into HtmlLabelIndex values(15622,'减') 
/
insert into HtmlLabelIndex values(15623,'乘') 
/
insert into HtmlLabelIndex values(15624,'除') 
/
insert into HtmlLabelIndex values(15625,'当前日期') 
/
insert into HtmlLabelIndex values(15626,'当前时间') 
/
insert into HtmlLabelIndex values(15627,'临时时间变量') 
/
insert into HtmlLabelIndex values(15628,'临时日期变量') 
/
insert into HtmlLabelIndex values(15629,'临时文本变量') 
/
insert into HtmlLabelIndex values(15630,'临时整型变量') 
/
insert into HtmlLabelIndex values(15631,'临时浮点型变量') 
/
insert into HtmlLabelIndex values(15632,'自定义值') 
/
insert into HtmlLabelIndex values(15633,'是否跳过周末') 
/
insert into HtmlLabelIndex values(15634,'是否跳过公共假日') 
/
insert into HtmlLabelIndex values(15635,'运算法则') 
/
insert into HtmlLabelIndex values(15636,'表达式') 
/
insert into HtmlLabelIndex values(15637,'附件规则') 
/
insert into HtmlLabelIndex values(15638,'跳过周末') 
/
insert into HtmlLabelIndex values(15639,'跳过公共假日') 
/
insert into HtmlLabelIndex values(15640,'请先选择第一个字段') 
/
insert into HtmlLabelIndex values(15641,'请先选择操作符号') 
/
insert into HtmlLabelIndex values(15642,'目标字段不能为空') 
/
insert into HtmlLabelIndex values(15643,'整数类型不匹配') 
/
insert into HtmlLabelIndex values(15644,'浮点数类型不匹配') 
/
insert into HtmlLabelIndex values(15645,'日期类型不匹配') 
/
insert into HtmlLabelIndex values(15646,'时间类型不匹配') 
/
insert into HtmlLabelIndex values(15647,'被考核人信息') 
/
insert into HtmlLabelIndex values(15648,'被考核人') 
/
insert into HtmlLabelIndex values(15649,'总成绩') 
/
insert into HtmlLabelIndex values(15650,'总考核人') 
/
insert into HtmlLabelIndex values(15651,'已考核人') 
/
insert into HtmlLabelIndex values(15652,'当前考核') 
/
insert into HtmlLabelIndex values(15653,'考核名称') 
/
insert into HtmlLabelIndex values(15654,'总的被考核人') 
/
insert into HtmlLabelIndex values(15655,'总的考核人') 
/
insert into HtmlLabelIndex values(15656,'已完成考核') 
/
insert into HtmlLabelIndex values(15657,'成绩') 
/
insert into HtmlLabelIndex values(15658,'优良') 
/
insert into HtmlLabelIndex values(15659,'合格') 
/
insert into HtmlLabelIndex values(15660,'差') 
/
insert into HtmlLabelIndex values(15661,'极差') 
/
insert into HtmlLabelIndex values(15662,'考核人') 
/
insert into HtmlLabelIndex values(15663,'总分') 
/
insert into HtmlLabelIndex values(15664,'奖惩人员') 
/
insert into HtmlLabelIndex values(15665,'奖惩标题') 
/
insert into HtmlLabelIndex values(15666,'奖惩名称') 
/
insert into HtmlLabelIndex values(15667,'适用情况') 
/
insert into HtmlLabelIndex values(15668,'招聘日期') 
/
insert into HtmlLabelIndex values(15669,'通知人') 
/
insert into HtmlLabelIndex values(15670,'新员工入职设置') 
/
insert into HtmlLabelIndex values(15671,'应聘岗位') 
/
insert into HtmlLabelIndex values(15672,'曾任岗位') 
/
insert into HtmlLabelIndex values(15673,'年薪低限') 
/
insert into HtmlLabelIndex values(15674,'体重') 
/
insert into HtmlLabelIndex values(15675,'应聘者类别') 
/
insert into HtmlLabelIndex values(15676,'离开原因') 
/
insert into HtmlLabelIndex values(15677,'培训情况') 
/
insert into HtmlLabelIndex values(15678,'培训名称') 
/
insert into HtmlLabelIndex values(15679,'培训开始日期') 
/
insert into HtmlLabelIndex values(15680,'培训结束日期') 
/
insert into HtmlLabelIndex values(15681,'颁发单位') 
/
insert into HtmlLabelIndex values(15682,'奖惩情况') 
/
insert into HtmlLabelIndex values(15683,'户口') 
/
insert into HtmlLabelIndex values(15684,'工会会员') 
/
insert into HtmlLabelIndex values(15685,'暂住证号码') 
/
insert into HtmlLabelIndex values(15686,'家庭状况') 
/
insert into HtmlLabelIndex values(15687,'个人信息') 
/
insert into HtmlLabelIndex values(15688,'工作信息') 
/
insert into HtmlLabelIndex values(15689,'备用') 
/
insert into HtmlLabelIndex values(15690,'淘汰') 
/
insert into HtmlLabelIndex values(15691,'邮件通知') 
/
insert into HtmlLabelIndex values(15692,'招聘信息发布时间') 
/
insert into HtmlLabelIndex values(15693,'已有考评') 
/
insert into HtmlLabelIndex values(15694,'步骤名称') 
/
insert into HtmlLabelIndex values(15695,'考评人') 
/
insert into HtmlLabelIndex values(15696,'考评日期') 
/
insert into HtmlLabelIndex values(15697,'考评结果') 
/
insert into HtmlLabelIndex values(15698,'评语') 
/
insert into HtmlLabelIndex values(15699,'不合格') 
/
insert into HtmlLabelIndex values(15700,'好') 
/
insert into HtmlLabelIndex values(15701,'已有考核') 
/
insert into HtmlLabelIndex values(15702,'考核日期') 
/
insert into HtmlLabelIndex values(15703,'考核结果') 
/
insert into HtmlLabelIndex values(15704,'备份') 
/
insert into HtmlLabelIndex values(15705,'是否已通知') 
/
insert into HtmlLabelIndex values(15706,'未考核') 
/
insert into HtmlLabelIndex values(15707,'照片') 
/
insert into HtmlLabelIndex values(15708,'职责描述') 
/
insert into HtmlLabelIndex values(15709,'直接上级') 
/
insert into HtmlLabelIndex values(15710,'试用') 
/
insert into HtmlLabelIndex values(15711,'正式') 
/
insert into HtmlLabelIndex values(15712,'办公地点') 
/
insert into HtmlLabelIndex values(15713,'办公电话') 
/
insert into HtmlLabelIndex values(15714,'其他电话') 
/
insert into HtmlLabelIndex values(15715,'水平') 
/
insert into HtmlLabelIndex values(15716,'入职前工作简历') 
/
insert into HtmlLabelIndex values(15717,'入职前培训') 
/
insert into HtmlLabelIndex values(15718,'入职前奖惩') 
/
insert into HtmlLabelIndex values(15719,'网上发布') 
/
insert into HtmlLabelIndex values(15720,'招聘日程') 
/
insert into HtmlLabelIndex values(15721,'审核人') 
/
insert into HtmlLabelIndex values(15722,'审核开始日期') 
/
insert into HtmlLabelIndex values(15723,'审核结束日期') 
/
insert into HtmlLabelIndex values(15724,'通知日期') 
/
insert into HtmlLabelIndex values(15725,'通知考核') 
/
insert into HtmlLabelIndex values(15726,'确定要通知审核人吗?') 
/
insert into HtmlLabelIndex values(15727,'面试考核通知') 
/
insert into HtmlLabelIndex values(15728,'总结建议') 
/
insert into HtmlLabelIndex values(15729,'具体信息') 
/
insert into HtmlLabelIndex values(15730,'被考评者') 
/
insert into HtmlLabelIndex values(15731,'面试步骤') 
/
insert into HtmlLabelIndex values(15732,'被面试者') 
/
insert into HtmlLabelIndex values(15733,'面试日期') 
/
insert into HtmlLabelIndex values(15734,'面试时间') 
/
insert into HtmlLabelIndex values(15735,'面试地点') 
/
insert into HtmlLabelIndex values(15736,'注意事项') 
/
insert into HtmlLabelIndex values(15737,'面试结果') 
/
insert into HtmlLabelIndex values(15738,'考评情况') 
/
insert into HtmlLabelIndex values(15739,'考评者') 
/
insert into HtmlLabelIndex values(15740,'确定要淘汰吗？') 
/
insert into HtmlLabelIndex values(15741,'确定要通过吗？') 
/
insert into HtmlLabelIndex values(15742,'确定要转入备用库吗？') 
/
insert into HtmlLabelIndex values(15743,'招聘负责通知') 
/
insert into HtmlLabelIndex values(15744,'招聘时间') 
/
insert into HtmlLabelIndex values(15745,'招聘步骤') 
/
insert into HtmlLabelIndex values(15746,'未处理') 
/
insert into HtmlLabelIndex values(15747,'正在招聘') 
/
insert into HtmlLabelIndex values(15748,'已满足') 
/
insert into HtmlLabelIndex values(15749,'无用') 
/
insert into HtmlLabelIndex values(15750,'失效') 
/
insert into HtmlLabelIndex values(15751,'确定要关闭吗？') 
/
insert into HtmlLabelIndex values(15752,'考核说明') 
/
insert into HtmlLabelIndex values(15753,'考核项名称') 
/
insert into HtmlLabelIndex values(15754,'考核项说明') 
/
insert into HtmlLabelIndex values(15755,'考核种类名称') 
/
insert into HtmlLabelIndex values(15756,'考核周期') 
/
insert into HtmlLabelIndex values(15757,'考核期') 
/
insert into HtmlLabelIndex values(15758,'考核开始日期') 
/
insert into HtmlLabelIndex values(15759,'考核资料') 
/
insert into HtmlLabelIndex values(15760,'考核参与人') 
/
insert into HtmlLabelIndex values(15761,'参与人') 
/
insert into HtmlLabelIndex values(15762,'所有上级') 
/
insert into HtmlLabelIndex values(15763,'本人') 
/
insert into HtmlLabelIndex values(15764,'直接下级') 
/
insert into HtmlLabelIndex values(15765,'所有下级') 
/
insert into HtmlLabelIndex values(15766,'本部门其他人') 
/
insert into HtmlLabelIndex values(15767,'全称') 
/
insert into HtmlLabelIndex values(15768,'公司网站') 
/
insert into HtmlLabelIndex values(15769,'所属分成本中心') 
/
insert into HtmlLabelIndex values(15770,'新建成本中心') 
/
insert into HtmlLabelIndex values(15771,'定制部门结构图布局') 
/
insert into HtmlLabelIndex values(15772,'上级部门') 
/
insert into HtmlLabelIndex values(15773,'上级部门不能为本部门!') 
/
insert into HtmlLabelIndex values(15774,'搜索条件') 
/
insert into HtmlLabelIndex values(15775,'合同类型') 
/
insert into HtmlLabelIndex values(15776,'合同人') 
/
insert into HtmlLabelIndex values(15777,'合同起止日期') 
/
insert into HtmlLabelIndex values(15778,'试用期结束日期') 
/
insert into HtmlLabelIndex values(15779,'请输入合同人！！') 
/
insert into HtmlLabelIndex values(15780,'合同类别') 
/
insert into HtmlLabelIndex values(15781,'通知') 
/
insert into HtmlLabelIndex values(15782,'确定要通知吗？') 
/
insert into HtmlLabelIndex values(15783,'人力资源合同到期通知') 
/
insert into HtmlLabelIndex values(15784,'试用期到期通知') 
/
insert into HtmlLabelIndex values(15785,'选择合同类别') 
/
insert into HtmlLabelIndex values(15786,'合同模板') 
/
insert into HtmlLabelIndex values(15787,'存放目录') 
/
insert into HtmlLabelIndex values(15788,'入职合同') 
/
insert into HtmlLabelIndex values(15789,'到期提前提醒期') 
/
insert into HtmlLabelIndex values(15790,'对应模板') 
/
insert into HtmlLabelIndex values(15791,'是否为入职合同') 
/
insert into HtmlLabelIndex values(15792,'提醒提前天数') 
/
insert into HtmlLabelIndex values(15793,'提醒人') 
/
insert into HtmlLabelIndex values(15794,'请输入合同模板') 
/
insert into HtmlLabelIndex values(15795,'类型名称') 
/
insert into HtmlLabelIndex values(15796,'查看新员工') 
/
insert into HtmlLabelIndex values(15797,'到职日期') 
/
insert into HtmlLabelIndex values(15798,'个人入职设定') 
/
insert into HtmlLabelIndex values(15799,'邮件帐户') 
/
insert into HtmlLabelIndex values(15800,'一卡通') 
/
insert into HtmlLabelIndex values(15801,'座位号') 
/
insert into HtmlLabelIndex values(15802,'分机直线') 
/
insert into HtmlLabelIndex values(15803,'密码与确认密码不符合') 
/
insert into HtmlLabelIndex values(15804,'系统信息') 
/
insert into HtmlLabelIndex values(15805,'财务信息') 
/
insert into HtmlLabelIndex values(15806,'资产信息') 
/
insert into HtmlLabelIndex values(15807,'任务监控人员') 
/
insert into HtmlLabelIndex values(15808,'未设置') 
/
insert into HtmlLabelIndex values(15809,'已设置') 
/
insert into HtmlLabelIndex values(15810,'确定要完成新员工设置吗？') 
/
insert into HtmlLabelIndex values(15811,'有一些设置没有完成，确定要强制完成新员工设置吗？') 
/
insert into HtmlLabelIndex values(15812,'工资银行') 
/
insert into HtmlLabelIndex values(15813,'有人力资源工资帐户使用该银行,该银行不能删除') 
/
insert into HtmlLabelIndex values(15814,'薪酬调整') 
/
insert into HtmlLabelIndex values(15815,'工资项目') 
/
insert into HtmlLabelIndex values(15816,'改变为') 
/
insert into HtmlLabelIndex values(15817,'调整历史') 
/
insert into HtmlLabelIndex values(15818,'被调整人') 
/
insert into HtmlLabelIndex values(15819,'调整项目') 
/
insert into HtmlLabelIndex values(15820,'调整日期') 
/
insert into HtmlLabelIndex values(15821,'调整类型') 
/
insert into HtmlLabelIndex values(15822,'调整薪酬') 
/
insert into HtmlLabelIndex values(15823,'调整人') 
/
insert into HtmlLabelIndex values(15824,'工资表显示') 
/
insert into HtmlLabelIndex values(15825,'福利') 
/
insert into HtmlLabelIndex values(15826,'税收') 
/
insert into HtmlLabelIndex values(15827,'税收基准项目') 
/
insert into HtmlLabelIndex values(15828,'计算公式') 
/
insert into HtmlLabelIndex values(15829,'财务费用类型') 
/
insert into HtmlLabelIndex values(15830,'注意： 代码只能为英文字母和阿拉伯数值，英文字母大小写敏感！') 
/
insert into HtmlLabelIndex values(15831,'职级从') 
/
insert into HtmlLabelIndex values(15832,'职级到') 
/
insert into HtmlLabelIndex values(15833,'费率') 
/
insert into HtmlLabelIndex values(15834,'税率') 
/
insert into HtmlLabelIndex values(15835,'税收基数') 
/
insert into HtmlLabelIndex values(15836,'级数') 
/
insert into HtmlLabelIndex values(15837,'含税级距(从)') 
/
insert into HtmlLabelIndex values(15838,'含税级距(到)') 
/
insert into HtmlLabelIndex values(15839,'批处理') 
/
insert into HtmlLabelIndex values(15840,'批处理将按照该项设置的规则重新设置人力资源工资表,') 
/
insert into HtmlLabelIndex values(15841,'以前所做的所有改动都将改变,是否继续') 
/
insert into HtmlLabelIndex values(15842,'人力资源状态') 
/
insert into HtmlLabelIndex values(15843,'基准工资') 
/
insert into HtmlLabelIndex values(15844,'试用延期') 
/
insert into HtmlLabelIndex values(15845,'生成工资单') 
/
insert into HtmlLabelIndex values(15846,'重新生成') 
/
insert into HtmlLabelIndex values(15847,'修改工资单') 
/
insert into HtmlLabelIndex values(15848,'发送工资单') 
/
insert into HtmlLabelIndex values(15849,'工资单日期') 
/
insert into HtmlLabelIndex values(15850,'未生成当前月工资单') 
/
insert into HtmlLabelIndex values(15851,'重新生成工资单将丢失对该工资单的所有修改信息，是否继续？') 
/
insert into HtmlLabelIndex values(15852,'工资单发送将使系统人员看到自己该月的工资，是否继续？') 
/
insert into HtmlLabelIndex values(15853,'是否需要重新计算税收项和计算项？') 
/
insert into HtmlLabelIndex values(15854,'职务类型') 
/
insert into HtmlLabelIndex values(15855,'所属职务') 
/
insert into HtmlLabelIndex values(15856,'岗位职责') 
/
insert into HtmlLabelIndex values(15857,'邮政编码 /城市') 
/
insert into HtmlLabelIndex values(15858,'联系方式') 
/
insert into HtmlLabelIndex values(15859,'必要信息不完整！') 
/
insert into HtmlLabelIndex values(15860,'年龄区间') 
/
insert into HtmlLabelIndex values(15861,'总人数') 
/
insert into HtmlLabelIndex values(15862,'人员年龄统计') 
/
insert into HtmlLabelIndex values(15863,'空') 
/
insert into HtmlLabelIndex values(15864,'岁') 
/
insert into HtmlLabelIndex values(15865,'人员成本中心统计') 
/
insert into HtmlLabelIndex values(15866,'人员部门统计') 
/
insert into HtmlLabelIndex values(15867,'人员学历统计') 
/
insert into HtmlLabelIndex values(15868,'人员职务统计') 
/
insert into HtmlLabelIndex values(15869,'人员职称统计') 
/
insert into HtmlLabelIndex values(15870,'人员职务类别统计') 
/
insert into HtmlLabelIndex values(15871,'职级区间') 
/
insert into HtmlLabelIndex values(15872,'级') 
/
insert into HtmlLabelIndex values(15873,'人员职级统计') 
/
insert into HtmlLabelIndex values(15874,'人员岗位统计') 
/
insert into HtmlLabelIndex values(15875,'人员婚姻状况统计') 
/
insert into HtmlLabelIndex values(15876,'任务完成统计') 
/
insert into HtmlLabelIndex values(15877,'人力资源状况') 
/
insert into HtmlLabelIndex values(15878,'工龄') 
/
insert into HtmlLabelIndex values(15879,'培训资源') 
/
insert into HtmlLabelIndex values(15880,'考勤') 
/
insert into HtmlLabelIndex values(15881,'会议室使用情况') 
/
insert into HtmlLabelIndex values(15882,'人事管理') 
/
insert into HtmlLabelIndex values(15883,'新增人员') 
/
insert into HtmlLabelIndex values(15884,'返聘') 
/
insert into HtmlLabelIndex values(15885,'应聘人员') 
/
insert into HtmlLabelIndex values(15886,'德隆国际战略投资有限公司') 
/
insert into HtmlLabelIndex values(15887,'年龄层次统计图') 
/
insert into HtmlLabelIndex values(15888,'人员安全级别统计') 
/
insert into HtmlLabelIndex values(15889,'人员性别统计') 
/
insert into HtmlLabelIndex values(15890,'员工状态') 
/
insert into HtmlLabelIndex values(15891,'人员状态统计') 
/
insert into HtmlLabelIndex values(15892,'规划名称') 
/
insert into HtmlLabelIndex values(15893,'规划考评人') 
/
insert into HtmlLabelIndex values(15894,'规划考评时间') 
/
insert into HtmlLabelIndex values(15895,'规划开始时间') 
/
insert into HtmlLabelIndex values(15896,'规划结束时间') 
/
insert into HtmlLabelIndex values(15897,'规划内容') 
/
insert into HtmlLabelIndex values(15898,'规划目的') 
/
insert into HtmlLabelIndex values(15899,'参加率') 
/
insert into HtmlLabelIndex values(15900,'培训规划名称') 
/
insert into HtmlLabelIndex values(15901,'相关活动考核情况') 
/
insert into HtmlLabelIndex values(15902,'相关活动考评情况') 
/
insert into HtmlLabelIndex values(15903,'相关培训活') 
/
insert into HtmlLabelIndex values(15904,'动考核情况') 
/
insert into HtmlLabelIndex values(15905,'动考评情况') 
/
insert into HtmlLabelIndex values(15906,'极差率') 
/
insert into HtmlLabelIndex values(15907,'差率') 
/
insert into HtmlLabelIndex values(15908,'一般率') 
/
insert into HtmlLabelIndex values(15909,'好率') 
/
insert into HtmlLabelIndex values(15910,'很好率') 
/
insert into HtmlLabelIndex values(15911,'不及格率') 
/
insert into HtmlLabelIndex values(15912,'及格率') 
/
insert into HtmlLabelIndex values(15913,'良好率') 
/
insert into HtmlLabelIndex values(15914,'优秀率') 
/
insert into HtmlLabelIndex values(15915,'培训组织人') 
/
insert into HtmlLabelIndex values(15916,'培训内容') 
/
insert into HtmlLabelIndex values(15917,'培训目的') 
/
insert into HtmlLabelIndex values(15918,'培训地点') 
/
insert into HtmlLabelIndex values(15919,'活动名称') 
/
insert into HtmlLabelIndex values(15920,'考核情况') 
/
insert into HtmlLabelIndex values(15921,'培训规划相关情况') 
/
insert into HtmlLabelIndex values(15922,'培训活动相关情况') 
/
insert into HtmlLabelIndex values(15923,'培训资源名称') 
/
insert into HtmlLabelIndex values(15924,'资源名称') 
/
insert into HtmlLabelIndex values(15925,'培训资源考评情况') 
/
insert into HtmlLabelIndex values(15926,'人员用工性质统计') 
/
insert into HtmlLabelIndex values(15927,'工龄区间') 
/
insert into HtmlLabelIndex values(15928,'人员工龄统计') 
/
insert into HtmlLabelIndex values(15929,'人力资源报表') 
/
insert into HtmlLabelIndex values(15930,'列名') 
/
insert into HtmlLabelIndex values(15931,'应聘类型') 
/
insert into HtmlLabelIndex values(15932,'间距') 
/
insert into HtmlLabelIndex values(15933,'年份') 
/
insert into HtmlLabelIndex values(15934,'到位日期') 
/
insert into HtmlLabelIndex values(15935,'显示内容') 
/
insert into HtmlLabelIndex values(15936,'应聘人员人数统计') 
/
insert into HtmlLabelIndex values(15937,'应聘类别') 
/
insert into HtmlLabelIndex values(15938,'人数统计') 
/
insert into HtmlLabelIndex values(15939,'合同报表') 
/
insert into HtmlLabelIndex values(15940,'年合同报表') 
/
insert into HtmlLabelIndex values(15941,'部门合同统计') 
/
insert into HtmlLabelIndex values(15942,'合同类别统计') 
/
insert into HtmlLabelIndex values(15943,'合同时间统计') 
/
insert into HtmlLabelIndex values(15944,'合同结束时间') 
/
insert into HtmlLabelIndex values(15945,'总人次') 
/
insert into HtmlLabelIndex values(15946,'合同数') 
/
insert into HtmlLabelIndex values(15947,'合同部门统计') 
/
insert into HtmlLabelIndex values(15948,'合同统计') 
/
insert into HtmlLabelIndex values(15949,'合同具体信息报表') 
/
insert into HtmlLabelIndex values(15950,'合同部门') 
/
insert into HtmlLabelIndex values(15951,'合同岗位') 
/
insert into HtmlLabelIndex values(15952,'合同时间') 
/
insert into HtmlLabelIndex values(15953,'合同日期') 
/
insert into HtmlLabelIndex values(15954,'续签时间统计') 
/
insert into HtmlLabelIndex values(15955,'离职报表') 
/
insert into HtmlLabelIndex values(15956,'年离职报表') 
/
insert into HtmlLabelIndex values(15957,'部门离职统计') 
/
insert into HtmlLabelIndex values(15958,'离职时间统计') 
/
insert into HtmlLabelIndex values(15959,'离职部门统计') 
/
insert into HtmlLabelIndex values(15960,'离职具体信息报表') 
/
insert into HtmlLabelIndex values(15961,'离职日期') 
/
insert into HtmlLabelIndex values(15962,'续签报表') 
/
insert into HtmlLabelIndex values(15963,'年续签报表') 
/
insert into HtmlLabelIndex values(15964,'部门续签统计') 
/
insert into HtmlLabelIndex values(15965,'续签时间') 
/
insert into HtmlLabelIndex values(15966,'续签结束时间') 
/
insert into HtmlLabelIndex values(15967,'续签部门统计') 
/
insert into HtmlLabelIndex values(15968,'续签统计') 
/
insert into HtmlLabelIndex values(15969,'续签具体信息报表') 
/
insert into HtmlLabelIndex values(15970,'续签日期') 
/
insert into HtmlLabelIndex values(15971,'续签结束日期') 
/
insert into HtmlLabelIndex values(15972,'解聘报表') 
/
insert into HtmlLabelIndex values(15973,'年解聘报表') 
/
insert into HtmlLabelIndex values(15974,'部门解聘统计') 
/
insert into HtmlLabelIndex values(15975,'解聘时间统计') 
/
insert into HtmlLabelIndex values(15976,'解聘时间') 
/
insert into HtmlLabelIndex values(15977,'解聘部门统计') 
/
insert into HtmlLabelIndex values(15978,'解聘统计') 
/
insert into HtmlLabelIndex values(15979,'解聘具体信息报表') 
/
insert into HtmlLabelIndex values(15980,'解聘日期') 
/
insert into HtmlLabelIndex values(15981,'转正报表') 
/
insert into HtmlLabelIndex values(15982,'年转正报表') 
/
insert into HtmlLabelIndex values(15983,'部门转正统计') 
/
insert into HtmlLabelIndex values(15984,'转正时间统计') 
/
insert into HtmlLabelIndex values(15985,'转正时间') 
/
insert into HtmlLabelIndex values(15986,'转正部门统计') 
/
insert into HtmlLabelIndex values(15987,'转正统计') 
/
insert into HtmlLabelIndex values(15988,'转正具体信息报表') 
/
insert into HtmlLabelIndex values(15989,'调动报表') 
/
insert into HtmlLabelIndex values(15990,'年调动报表') 
/
insert into HtmlLabelIndex values(15991,'部门调动统计') 
/
insert into HtmlLabelIndex values(15992,'调动时间统计') 
/
insert into HtmlLabelIndex values(15993,'调动时间') 
/
insert into HtmlLabelIndex values(15994,'调动前职级') 
/
insert into HtmlLabelIndex values(15995,'调动后职级') 
/
insert into HtmlLabelIndex values(15996,'调动部门统计') 
/
insert into HtmlLabelIndex values(15997,'调动统计') 
/
insert into HtmlLabelIndex values(15998,'调动具体信息报表') 
/
insert into HtmlLabelIndex values(15999,'调出岗位') 
/
insert into HtmlLabelIndex values(16000,'调入岗位') 
/
insert into HtmlLabelIndex values(16001,'被调动人') 
/
insert into HtmlLabelIndex values(16002,'返聘报表') 
/
insert into HtmlLabelIndex values(16003,'年返聘报表') 
/
insert into HtmlLabelIndex values(16004,'返聘时间统计') 
/
insert into HtmlLabelIndex values(16005,'返聘时间') 
/
insert into HtmlLabelIndex values(16006,'返聘结束时间') 
/
insert into HtmlLabelIndex values(16007,'返聘部门统计') 
/
insert into HtmlLabelIndex values(16008,'返聘统计') 
/
insert into HtmlLabelIndex values(16009,'返聘具体信息报表') 
/
insert into HtmlLabelIndex values(16010,'返聘部门') 
/
insert into HtmlLabelIndex values(16011,'返聘岗位') 
/
insert into HtmlLabelIndex values(16012,'返聘日期') 
/
insert into HtmlLabelIndex values(16013,'返聘结束日期') 
/
insert into HtmlLabelIndex values(16014,'部门返聘统计') 
/
insert into HtmlLabelIndex values(16015,'家庭联系方法') 
/
insert into HtmlLabelIndex values(16016,'工资帐号') 
/
insert into HtmlLabelIndex values(16017,'登陆帐号') 
/
insert into HtmlLabelIndex values(16018,'家庭联系方式') 
/
insert into HtmlLabelIndex values(16019,'新增统计') 
/
insert into HtmlLabelIndex values(16020,'加入时间统计') 
/
insert into HtmlLabelIndex values(16021,'加入部门统计') 
/
insert into HtmlLabelIndex values(16022,'新增人员报表') 
/
insert into HtmlLabelIndex values(16023,'年新增人员报表') 
/
insert into HtmlLabelIndex values(16024,'新增时间统计') 
/
insert into HtmlLabelIndex values(16025,'退休报表') 
/
insert into HtmlLabelIndex values(16026,'年退休报表') 
/
insert into HtmlLabelIndex values(16027,'部门退休统计') 
/
insert into HtmlLabelIndex values(16028,'退休时间统计') 
/
insert into HtmlLabelIndex values(16029,'退休时间') 
/
insert into HtmlLabelIndex values(16030,'退休部门统计') 
/
insert into HtmlLabelIndex values(16031,'退休统计') 
/
insert into HtmlLabelIndex values(16032,'退休具体信息报表') 
/
insert into HtmlLabelIndex values(16033,'退休部门') 
/
insert into HtmlLabelIndex values(16034,'退休岗位') 
/
insert into HtmlLabelIndex values(16035,'退休日期') 
/
insert into HtmlLabelIndex values(16036,'人次统计') 
/
insert into HtmlLabelIndex values(16037,'考勤开始日期') 
/
insert into HtmlLabelIndex values(16038,'考勤结束日期') 
/
insert into HtmlLabelIndex values(16039,'考勤开始时间') 
/
insert into HtmlLabelIndex values(16040,'考勤结束时间') 
/
insert into HtmlLabelIndex values(16041,'变动类型') 
/
insert into HtmlLabelIndex values(16042,'考勤部门统计') 
/
insert into HtmlLabelIndex values(16043,'天数统计') 
/
insert into HtmlLabelIndex values(16044,'考勤类别') 
/
insert into HtmlLabelIndex values(16045,'考勤部门') 
/
insert into HtmlLabelIndex values(16046,'种类报表') 
/
insert into HtmlLabelIndex values(16047,'种类天数报表') 
/
insert into HtmlLabelIndex values(16048,'考勤人员') 
/
insert into HtmlLabelIndex values(16049,'月份报表') 
/
insert into HtmlLabelIndex values(16050,'被考勤部门') 
/
insert into HtmlLabelIndex values(16051,'年人员') 
/
insert into HtmlLabelIndex values(16052,'月份人次报表') 
/
insert into HtmlLabelIndex values(16053,'月份天数报表') 
/
insert into HtmlLabelIndex values(16054,'考勤具体信息报表') 
/
insert into HtmlLabelIndex values(16055,'被考勤人') 
/
insert into HtmlLabelIndex values(16056,'实际计算时间') 
/
insert into HtmlLabelIndex values(16057,'实际计算天数') 
/
insert into HtmlLabelIndex values(16058,'种类人次报表') 
/
insert into HtmlLabelIndex values(16059,'年考勤种类') 
/
insert into HtmlLabelIndex values(16060,'人力资源用工需求') 
/
insert into HtmlLabelIndex values(16061,'用工需求人数统计') 
/
insert into HtmlLabelIndex values(16062,'用工需求具体信息报表') 
/
insert into HtmlLabelIndex values(16063,'人数报表') 
/
insert into HtmlLabelIndex values(16064,'年用工需求报表') 
/
insert into HtmlLabelIndex values(16065,'奖惩考核') 
/
insert into HtmlLabelIndex values(16066,'系统语言') 
/
insert into HtmlLabelIndex values(16067,'最后登陆日期') 
/
insert into HtmlLabelIndex values(16068,'正在参加的培训活动') 
/
insert into HtmlLabelIndex values(16069,'可以参加的培训安排') 
/
insert into HtmlLabelIndex values(16070,'考勤类型') 
/
insert into HtmlLabelIndex values(16071,'显示颜色') 
/
insert into HtmlLabelIndex values(16072,'此员工还没有输入直接上级，确定不输入吗？') 
/
insert into HtmlLabelIndex values(16073,'合同开始日期不能大于合同结束日期！') 
/
insert into HtmlLabelIndex values(16074,'工作地点') 
/
insert into HtmlLabelIndex values(16075,'删除图片') 
/
insert into HtmlLabelIndex values(16076,'联系信息') 
/
insert into HtmlLabelIndex values(16077,'离职通知人') 
/
insert into HtmlLabelIndex values(16078,'有效用户数已到license上限！') 
/
insert into HtmlLabelIndex values(16079,'被续签人') 
/
insert into HtmlLabelIndex values(16080,'续签状态') 
/
insert into HtmlLabelIndex values(16081,'续签备注') 
/
insert into HtmlLabelIndex values(16082,'续签合同') 
/
insert into HtmlLabelIndex values(16083,'续签通知人') 
/
insert into HtmlLabelIndex values(16084,'工资帐户') 
/
insert into HtmlLabelIndex values(16085,'公积金帐户') 
/
insert into HtmlLabelIndex values(16086,'被解聘人') 
/
insert into HtmlLabelIndex values(16087,'解聘原因') 
/
insert into HtmlLabelIndex values(16088,'解聘合同') 
/
insert into HtmlLabelIndex values(16089,'解聘通知人') 
/
insert into HtmlLabelIndex values(16090,'被转正人') 
/
insert into HtmlLabelIndex values(16091,'转正通知人') 
/
insert into HtmlLabelIndex values(16092,'密码修改成功') 
/
insert into HtmlLabelIndex values(16093,'工作日程') 
/
insert into HtmlLabelIndex values(16094,'日程类型') 
/
insert into HtmlLabelIndex values(16095,'项目日程') 
/
insert into HtmlLabelIndex values(16096,'年日程') 
/
insert into HtmlLabelIndex values(16097,'月日程') 
/
insert into HtmlLabelIndex values(16098,'周日程') 
/
insert into HtmlLabelIndex values(16099,'单日日程') 
/
insert into HtmlLabelIndex values(16100,'周一') 
/
insert into HtmlLabelIndex values(16101,'周二') 
/
insert into HtmlLabelIndex values(16102,'周三') 
/
insert into HtmlLabelIndex values(16103,'周四') 
/
insert into HtmlLabelIndex values(16104,'周五') 
/
insert into HtmlLabelIndex values(16105,'周六') 
/
insert into HtmlLabelIndex values(16106,'周日') 
/
insert into HtmlLabelIndex values(16107,'现岗位') 
/
insert into HtmlLabelIndex values(16108,'调动通知人') 
/
insert into HtmlLabelIndex values(16109,'被反聘人') 
/
insert into HtmlLabelIndex values(16110,'反聘开始日期') 
/
insert into HtmlLabelIndex values(16111,'反聘结束日期') 
/
insert into HtmlLabelIndex values(16112,'反聘原因') 
/
insert into HtmlLabelIndex values(16113,'反聘合同') 
/
insert into HtmlLabelIndex values(16114,'反聘通知人') 
/
insert into HtmlLabelIndex values(16115,'退休人') 
/
insert into HtmlLabelIndex values(16116,'退休备注') 
/
insert into HtmlLabelIndex values(16117,'退休合同') 
/
insert into HtmlLabelIndex values(16118,'退休通知人') 
/
insert into HtmlLabelIndex values(16119,'员工解聘通知') 
/
insert into HtmlLabelIndex values(16120,'员工转正通知') 
/
insert into HtmlLabelIndex values(16121,'员工续签通知') 
/
insert into HtmlLabelIndex values(16122,'员工调动通知') 
/
insert into HtmlLabelIndex values(16123,'员工离职通知') 
/
insert into HtmlLabelIndex values(16124,'员工退休通知') 
/
insert into HtmlLabelIndex values(16125,'员工反聘通知') 
/
insert into HtmlLabelIndex values(16126,'登陆名') 
/
insert into HtmlLabelIndex values(16127,'密码确认') 
/
insert into HtmlLabelIndex values(16128,'登录名冲突！！！') 
/
insert into HtmlLabelIndex values(16129,'登录用户数已到license上限,不能再设置新的用户登录信息！') 
/
insert into HtmlLabelIndex values(16130,'不及格') 
/
insert into HtmlLabelIndex values(16131,'及格') 
/
insert into HtmlLabelIndex values(16132,'很好') 
/
insert into HtmlLabelIndex values(16133,'具体情况') 
/
insert into HtmlLabelIndex values(16134,'日程内容') 
/
insert into HtmlLabelIndex values(16135,'未参加') 
/
insert into HtmlLabelIndex values(16136,'工作记录') 
/
insert into HtmlLabelIndex values(16137,'变动原因') 
/
insert into HtmlLabelIndex values(16138,'总公司') 
/
insert into HtmlLabelIndex values(16139,'系统管理员') 
/
insert into HtmlLabelIndex values(16140,'参加人员') 
/
insert into HtmlLabelIndex values(16141,'组织人') 
/
insert into HtmlLabelIndex values(16142,'目的') 
/
insert into HtmlLabelIndex values(16143,'培训考核') 
/
insert into HtmlLabelIndex values(16144,'培训考评') 
/
insert into HtmlLabelIndex values(16145,'效果') 
/
insert into HtmlLabelIndex values(16146,'培训人员') 
/
insert into HtmlLabelIndex values(16147,'此项培训活动已经被删除！！') 
/
insert into HtmlLabelIndex values(16148,'增加培训人') 
/
insert into HtmlLabelIndex values(16149,'通知考评') 
/
insert into HtmlLabelIndex values(16150,'培训日程') 
/
insert into HtmlLabelIndex values(16151,'增加培训日程') 
/
insert into HtmlLabelIndex values(16152,'培训活动总结') 
/
insert into HtmlLabelIndex values(16153,'实际培训费用') 
/
insert into HtmlLabelIndex values(16154,'总结人') 
/
insert into HtmlLabelIndex values(16155,'总结日期') 
/
insert into HtmlLabelIndex values(16156,'培训考评通知') 
/
insert into HtmlLabelIndex values(16157,'此项培训规划已经被删除！！') 
/
insert into HtmlLabelIndex values(16158,'实施情况') 
/
insert into HtmlLabelIndex values(16159,'建议') 
/
insert into HtmlLabelIndex values(16160,'较好') 
/
insert into HtmlLabelIndex values(16161,'新考评') 
/
insert into HtmlLabelIndex values(16162,'培训规划考评通知') 
/
insert into HtmlLabelIndex values(16163,'对不起，您无权建立此类培训！！！') 
/
insert into HtmlLabelIndex values(16164,'培训通知') 
/
insert into HtmlLabelIndex values(16165,'外部资源') 
/
insert into HtmlLabelIndex values(16166,'内部资源') 
/
insert into HtmlLabelIndex values(16167,'操作权限人') 
/
insert into HtmlLabelIndex values(16168,'部门快捷方式') 
/
insert into HtmlLabelIndex values(16169,'其他信息') 
/
insert into HtmlLabelIndex values(16170,'泛微插件下载') 
/
insert into HtmlLabelIndex values(16171,'文档模块升级') 
/
insert into HtmlLabelIndex values(16172,'修改共享') 
/
insert into HtmlLabelIndex values(16173,'资产使用') 
/
insert into HtmlLabelIndex values(16174,'是（可选择）') 
/
insert into HtmlLabelIndex values(16175,'否（未使用）') 
/
insert into HtmlLabelIndex values(16176,'是（强制性）') 
/
insert into HtmlLabelIndex values(16177,'人力资源使用') 
/
insert into HtmlLabelIndex values(16178,'项目使用') 
/
insert into HtmlLabelIndex values(16179,'剪切') 
/
insert into HtmlLabelIndex values(16180,'粘贴') 
/
insert into HtmlLabelIndex values(16181,'插入表格') 
/
insert into HtmlLabelIndex values(16182,'删除行') 
/
insert into HtmlLabelIndex values(16183,'删除列') 
/
insert into HtmlLabelIndex values(16184,'插入单元格') 
/
insert into HtmlLabelIndex values(16185,'删除单元格') 
/
insert into HtmlLabelIndex values(16186,'合并单元格') 
/
insert into HtmlLabelIndex values(16187,'拆分单元格') 
/
insert into HtmlLabelIndex values(16188,'请先选择所需的图片') 
/
insert into HtmlLabelIndex values(16189,'字体') 
/
insert into HtmlLabelIndex values(16190,'宋体') 
/
insert into HtmlLabelIndex values(16191,'新宋体') 
/
insert into HtmlLabelIndex values(16192,'黑体') 
/
insert into HtmlLabelIndex values(16193,'隶书') 
/
insert into HtmlLabelIndex values(16194,'幼园') 
/
insert into HtmlLabelIndex values(16195,'楷体') 
/
insert into HtmlLabelIndex values(16196,'仿宋') 
/
insert into HtmlLabelIndex values(16197,'字号') 
/
insert into HtmlLabelIndex values(16198,'加粗') 
/
insert into HtmlLabelIndex values(16199,'倾斜') 
/
insert into HtmlLabelIndex values(16200,'下划线') 
/
insert into HtmlLabelIndex values(16201,'突出显示') 
/
insert into HtmlLabelIndex values(16202,'左对齐') 
/
insert into HtmlLabelIndex values(16203,'居中') 
/
insert into HtmlLabelIndex values(16204,'右对齐') 
/
insert into HtmlLabelIndex values(16205,'项目符号') 
/
insert into HtmlLabelIndex values(16206,'减少缩进量') 
/
insert into HtmlLabelIndex values(16207,'增加缩进量') 
/
insert into HtmlLabelIndex values(16208,'超级链接') 
/
insert into HtmlLabelIndex values(16209,'插入图像') 
/
insert into HtmlLabelIndex values(16210,'撤销') 
/
insert into HtmlLabelIndex values(16211,'恢复') 
/
insert into HtmlLabelIndex values(16212,'绝对位置') 
/
insert into HtmlLabelIndex values(16213,'锁定') 
/
insert into HtmlLabelIndex values(16214,'吸附') 
/
insert into HtmlLabelIndex values(16215,'请输入文档编号') 
/
insert into HtmlLabelIndex values(16216,'全部展开') 
/
insert into HtmlLabelIndex values(16217,'选择颜色') 
/
insert into HtmlLabelIndex values(16218,'邮件模板') 
/
insert into HtmlLabelIndex values(16219,'这里HTML代码中的NAME名称应和数据表中的各字段名称一样.') 
/
insert into HtmlLabelIndex values(16220,'电邮') 
/
insert into HtmlLabelIndex values(16221,'工作日期') 
/
insert into HtmlLabelIndex values(16222,'系统结束日期') 
/
insert into HtmlLabelIndex values(16223,'工作类别') 
/
insert into HtmlLabelIndex values(16224,'所属成本中心') 
/
insert into HtmlLabelIndex values(16225,'物品简介') 
/
insert into HtmlLabelIndex values(16226,'公司宣传') 
/
insert into HtmlLabelIndex values(16227,'创建人部门,请参考HRM(大组-组-部门)') 
/
insert into HtmlLabelIndex values(16228,'文档内容') 
/
insert into HtmlLabelIndex values(16229,'创建人名称') 
/
insert into HtmlLabelIndex values(16230,'创建人名称和链接') 
/
insert into HtmlLabelIndex values(16231,'最后的修改人') 
/
insert into HtmlLabelIndex values(16232,'最后的修改日期') 
/
insert into HtmlLabelIndex values(16233,'使用的语言') 
/
insert into HtmlLabelIndex values(16234,'回复文档的主文档') 
/
insert into HtmlLabelIndex values(16235,'文档的状态(草稿,打开,正常,归档)') 
/
insert into HtmlLabelIndex values(16236,'文档主题') 
/
insert into HtmlLabelIndex values(16237,'发布状态(正常,新闻,标题新闻)') 
/
insert into HtmlLabelIndex values(16238,'最后查看日期') 
/
insert into HtmlLabelIndex values(16239,'文档的安全级别') 
/
insert into HtmlLabelIndex values(16240,'文档种类') 
/
insert into HtmlLabelIndex values(16241,'无新闻栏目！') 
/
insert into HtmlLabelIndex values(16242,'新闻名称') 
/
insert into HtmlLabelIndex values(16243,'被阅读') 
/
insert into HtmlLabelIndex values(16244,'全部文档:按被阅读次数(降序)') 
/
insert into HtmlLabelIndex values(16245,'调查表单接收情况') 
/
insert into HtmlLabelIndex values(16246,'输入调查表') 
/
insert into HtmlLabelIndex values(16247,'退订成功') 
/
insert into HtmlLabelIndex values(16248,'提交成功') 
/
insert into HtmlLabelIndex values(16249,'部门图形编辑') 
/
insert into HtmlLabelIndex values(16250,'入职') 
/
insert into HtmlLabelIndex values(16251,'应聘库') 
/
insert into HtmlLabelIndex values(16252,'考勤管理') 
/
insert into HtmlLabelIndex values(16253,'工作时间') 
/
insert into HtmlLabelIndex values(16254,'一般工作时间') 
/
insert into HtmlLabelIndex values(16255,'排班种类') 
/
insert into HtmlLabelIndex values(16256,'排班维护') 
/
insert into HtmlLabelIndex values(16257,'打卡用户接口') 
/
insert into HtmlLabelIndex values(16258,'打卡数据导出') 
/
insert into HtmlLabelIndex values(16259,'打卡数据导入') 
/
insert into HtmlLabelIndex values(16260,'合同管理') 
/
insert into HtmlLabelIndex values(16261,'基本设置') 
/
insert into HtmlLabelIndex values(16262,'工资福利税收项目') 
/
insert into HtmlLabelIndex values(16263,'薪酬管理') 
/
insert into HtmlLabelIndex values(16264,'培训管理') 
/
insert into HtmlLabelIndex values(16265,'资产借用申请单') 
/
insert into HtmlLabelIndex values(16266,'国际战略投资有限公司行政管理部车辆维修单') 
/
insert into HtmlLabelIndex values(16267,'维修人') 
/
insert into HtmlLabelIndex values(16268,'维修时间') 
/
insert into HtmlLabelIndex values(16269,'维修费用') 
/
insert into HtmlLabelIndex values(16270,'说明必须输入！') 
/
insert into HtmlLabelIndex values(16271,'个人借款余额：') 
/
insert into HtmlLabelIndex values(16272,'本月工作目标') 
/
insert into HtmlLabelIndex values(16273,'本月工作总结') 
/
insert into HtmlLabelIndex values(16274,'完成情况具体描述') 
/
insert into HtmlLabelIndex values(16275,'考核人评分') 
/
insert into HtmlLabelIndex values(16276,'上月工作总结') 
/
insert into HtmlLabelIndex values(16277,'总结权重指数不能大于100%') 
/
insert into HtmlLabelIndex values(16278,'计划权重指数不能大于100%') 
/
insert into HtmlLabelIndex values(16279,'上周工作总结') 
/
insert into HtmlLabelIndex values(16280,'完成结果') 
/
insert into HtmlLabelIndex values(16281,'未完成事项') 
/
insert into HtmlLabelIndex values(16282,'本周工作计划') 
/
insert into HtmlLabelIndex values(16283,'是否公开') 
/
insert into HtmlLabelIndex values(16284,'详细说明') 
/
insert into HtmlLabelIndex values(16285,'显示财务信息') 
/
insert into HtmlLabelIndex values(16286,'该部门预算已批准') 
/
insert into HtmlLabelIndex values(16287,'该部门预算未批准') 
/
insert into HtmlLabelIndex values(16288,'该部门未有预算') 
/
insert into HtmlLabelIndex values(16289,'部门信息') 
/
insert into HtmlLabelIndex values(16290,'项目信息') 
/
insert into HtmlLabelIndex values(16291,'当期') 
/
insert into HtmlLabelIndex values(16292,'实际(包括本次报销)') 
/
insert into HtmlLabelIndex values(16293,'是否超支') 
/
insert into HtmlLabelIndex values(16294,'项目总预算') 
/
insert into HtmlLabelIndex values(16295,'项目总支出(包括本次报销)') 
/
insert into HtmlLabelIndex values(16296,'本人该项目预算') 
/
insert into HtmlLabelIndex values(16297,'本人该项目实际(包括本次报销)') 
/
insert into HtmlLabelIndex values(16298,'部门该项目预算') 
/
insert into HtmlLabelIndex values(16299,'部门该项目实际(包括本次报销)') 
/
insert into HtmlLabelIndex values(16300,'全部该项目预算') 
/
insert into HtmlLabelIndex values(16301,'全部该项目实际(包括本次报销)') 
/
insert into HtmlLabelIndex values(16302,'总支出(包括本次报销)') 
/
insert into HtmlLabelIndex values(16303,'本人该CRM预算') 
/
insert into HtmlLabelIndex values(16304,'本人该CRM实际(包括本次报销)') 
/
insert into HtmlLabelIndex values(16305,'部门该CRM预算') 
/
insert into HtmlLabelIndex values(16306,'部门该CRM实际(包括本次报销)') 
/
insert into HtmlLabelIndex values(16307,'全部该CRM预算') 
/
insert into HtmlLabelIndex values(16308,'全部该CRM实际(包括本次报销)') 
/
insert into HtmlLabelIndex values(16309,'隐藏财务信息') 
/
insert into HtmlLabelIndex values(16310,'结束讨论') 
/
insert into HtmlLabelIndex values(16311,'办公用品一次性发放配额') 
/
insert into HtmlLabelIndex values(16312,'领用表单') 
/
insert into HtmlLabelIndex values(16313,'品名') 
/
insert into HtmlLabelIndex values(16314,'规格') 
/
insert into HtmlLabelIndex values(16315,'别克') 
/
insert into HtmlLabelIndex values(16316,'日本三菱(Uni)UB150签字笔') 
/
insert into HtmlLabelIndex values(16317,'笔类') 
/
insert into HtmlLabelIndex values(16318,'流水号') 
/
insert into HtmlLabelIndex values(16319,'老三样') 
/
insert into HtmlLabelIndex values(16320,'自己支付') 
/
insert into HtmlLabelIndex values(16321,'公司全付') 
/
insert into HtmlLabelIndex values(16322,'支付费用') 
/
insert into HtmlLabelIndex values(16323,'宾馆预定详细信息') 
/
insert into HtmlLabelIndex values(16324,'宾馆名称') 
/
insert into HtmlLabelIndex values(16325,'房型') 
/
insert into HtmlLabelIndex values(16326,'房间数') 
/
insert into HtmlLabelIndex values(16327,'您没有选中一个请求，所有改变的数据将无法正常保存！') 
/
insert into HtmlLabelIndex values(16328,'评估标准') 
/
insert into HtmlLabelIndex values(16329,'良') 
/
insert into HtmlLabelIndex values(16330,'中') 
/
insert into HtmlLabelIndex values(16331,'评分不能大于5分') 
/
insert into HtmlLabelIndex values(16332,'工作流信息保存错误') 
/
insert into HtmlLabelIndex values(16333,'工作流下一节点或下一节点操作者错误') 
/
insert into HtmlLabelIndex values(16334,'工作流流转...') 
/
insert into HtmlLabelIndex values(16335,'全部删除') 
/
insert into HtmlLabelIndex values(16336,'创建任务') 
/
insert into HtmlLabelIndex values(16337,'任务已完成') 
/
insert into HtmlLabelIndex values(16338,'任务延期') 
/
insert into HtmlLabelIndex values(16339,'任务进行中') 
/
insert into HtmlLabelIndex values(16340,'延期日期') 
/
insert into HtmlLabelIndex values(16341,'最后操作人') 
/
insert into HtmlLabelIndex values(16342,'所有未完成请求') 
/
insert into HtmlLabelIndex values(16343,'所有已完成请求') 
/
insert into HtmlLabelIndex values(16344,'确定删除选定的信息吗?') 
/
insert into HtmlLabelIndex values(16345,'添加用户') 
/
insert into HtmlLabelIndex values(16346,'全部请求') 
/
insert into HtmlLabelIndex values(16347,'所有待处理事宜') 
/
insert into HtmlLabelIndex values(16348,'所有已完成事宜') 
/
insert into HtmlLabelIndex values(16349,'待处理') 
/
insert into HtmlLabelIndex values(16350,'同意延期') 
/
insert into HtmlLabelIndex values(16351,'退回重新执行') 
/
insert into HtmlLabelIndex values(16352,'定制工作流程图') 
/
insert into HtmlLabelIndex values(16353,'已操作者') 
/
insert into HtmlLabelIndex values(16354,'未操作者') 
/
insert into HtmlLabelIndex values(16355,'查看者') 
/
insert into HtmlLabelIndex values(16389,'查看页面属性') 
/
insert into HtmlLabelIndex values(16392,'新建流程') 
/
insert into HtmlLabelIndex values(16394,'我的知识') 
/
insert into HtmlLabelIndex values(16395,'订阅知识') 
/
insert into HtmlLabelIndex values(16400,'新的客户') 
/
insert into HtmlLabelIndex values(16401,'分类客户') 
/
insert into HtmlLabelIndex values(16402,'联系计划') 
/
insert into HtmlLabelIndex values(16404,'销售合同') 
/
insert into HtmlLabelIndex values(16406,'客户审批') 
/
insert into HtmlLabelIndex values(16408,'项目执行') 
/
insert into HtmlLabelIndex values(16411,'当前任务') 
/
insert into HtmlLabelIndex values(16413,'查询项目') 
/
insert into HtmlLabelIndex values(16414,'我的人事') 
/
insert into HtmlLabelIndex values(16415,'我的卡片') 
/
insert into HtmlLabelIndex values(16416,'我的工资') 
/
insert into HtmlLabelIndex values(16417,'考核奖惩') 
/
insert into HtmlLabelIndex values(16418,'查询人员') 
/
insert into HtmlLabelIndex values(16420,'新的会议') 
/
insert into HtmlLabelIndex values(16421,'老的会议') 
/
insert into HtmlLabelIndex values(16422,'会议室分配') 
/
insert into HtmlLabelIndex values(16430,'我的月报') 
/
insert into HtmlLabelIndex values(16435,'收件邮箱') 
/
insert into HtmlLabelIndex values(16436,'发件邮箱') 
/
insert into HtmlLabelIndex values(16440,'查询邮件') 
/
insert into HtmlLabelIndex values(16441,'群发邮件') 
/
insert into HtmlLabelIndex values(16442,'邮箱设置') 
/
insert into HtmlLabelIndex values(16443,'我的短信') 
/
insert into HtmlLabelIndex values(16444,'新建短信') 
/
insert into HtmlLabelIndex values(16445,'版本序列号') 
/
insert into HtmlLabelIndex values(16450,'显示模板') 
/
insert into HtmlLabelIndex values(16451,'页面设置') 
/
insert into HtmlLabelIndex values(16455,'组织结构') 
/
insert into HtmlLabelIndex values(16456,'总部设置') 
/
insert into HtmlLabelIndex values(16457,'分部设置') 
/
insert into HtmlLabelIndex values(16458,'部门设置') 
/
insert into HtmlLabelIndex values(16459,'图形编辑 ') 
/
insert into HtmlLabelIndex values(16460,'职务设置') 
/
insert into HtmlLabelIndex values(16462,'职称设置') 
/
insert into HtmlLabelIndex values(16464,'学历设置') 
/
insert into HtmlLabelIndex values(16467,'人员续签') 
/
insert into HtmlLabelIndex values(16469,'人员离职') 
/
insert into HtmlLabelIndex values(16478,'公众假日') 
/
insert into HtmlLabelIndex values(16481,'薪酬设置') 
/
insert into HtmlLabelIndex values(16483,'路径设置') 
/
insert into HtmlLabelIndex values(16484,'基础设置') 
/
insert into HtmlLabelIndex values(16485,'称呼设置') 
/
insert into HtmlLabelIndex values(16486,'地址类型') 
/
insert into HtmlLabelIndex values(16487,'帐户定义') 
/
insert into HtmlLabelIndex values(16488,'联系定义') 
/
insert into HtmlLabelIndex values(16489,'地址定义') 
/
insert into HtmlLabelIndex values(16496,'价值设置') 
/
insert into HtmlLabelIndex values(16498,'时间设置') 
/
insert into HtmlLabelIndex values(16499,'成功因素') 
/
insert into HtmlLabelIndex values(16500,'失败因素') 
/
insert into HtmlLabelIndex values(16505,'预算设置') 
/
insert into HtmlLabelIndex values(16507,'指标设置') 
/
insert into HtmlLabelIndex values(16513,'新建产品') 
/
insert into HtmlLabelIndex values(16514,'调查设置') 
/
insert into HtmlLabelIndex values(16516,'输入维护') 
/
insert into HtmlLabelIndex values(16519,'输入确认') 
/
insert into HtmlLabelIndex values(16520,'输入监控') 
/
insert into HtmlLabelIndex values(16522,'国家设置') 
/
insert into HtmlLabelIndex values(16524,'城市设置') 
/
insert into HtmlLabelIndex values(16525,'币种设置') 
/
insert into HtmlLabelIndex values(16526,'权限设置') 
/
insert into HtmlLabelIndex values(16528,'权限转移') 
/
insert into HtmlLabelIndex values(16531,'项目报表') 
/
insert into HtmlLabelIndex values(16533,'客户报表') 
/
insert into HtmlLabelIndex values(16543,'人员状况') 
/
insert into HtmlLabelIndex values(16544,'人力列表') 
/
insert into HtmlLabelIndex values(16557,'考勤相关') 
/
insert into HtmlLabelIndex values(16558,'考勤统计') 
/
insert into HtmlLabelIndex values(16574,'项目部门') 
/
insert into HtmlLabelIndex values(16578,'近期操作') 
/
insert into HtmlLabelIndex values(16582,'客户类别') 
/
insert into HtmlLabelIndex values(16586,'合同相关') 
/
insert into HtmlLabelIndex values(16587,'合同列表') 
/
insert into HtmlLabelIndex values(16592,'人员金额') 
/
insert into HtmlLabelIndex values(16599,'部门资产') 
/
insert into HtmlLabelIndex values(16605,'文档目录报表') 
/
insert into HtmlLabelIndex values(16609,'最多文档客户') 
/
insert into HtmlLabelIndex values(16626,'数据中心') 
/
insert into HtmlLabelIndex values(16628,'确定要退出系统吗？') 
/


insert into HtmlLabelIndex values(16631,'数据中心') 
/
insert into HtmlLabelIndex values(16633,'送货信息') 
/
insert into HtmlLabelIndex values(16636,'隐藏') 
/
insert into HtmlLabelIndex values(16637,'邮件组') 
/
insert into HtmlLabelIndex values(16515,'报表设定') 
/
insert into HtmlLabelIndex values(16517,'条件维护') 
/
insert into HtmlLabelIndex values(16518,'输出维护') 
/
insert into HtmlLabelIndex values(16527,'角色设置') 
/
insert into HtmlLabelIndex values(16532,'流程报表') 
/
insert into HtmlLabelIndex values(16534,'财务报表') 
/
insert into HtmlLabelIndex values(16536,'知识报表') 
/
insert into HtmlLabelIndex values(16545,'年龄报表') 
/
insert into HtmlLabelIndex values(16547,'请假报表') 
/
insert into HtmlLabelIndex values(16548,'性别报表') 
/
insert into HtmlLabelIndex values(16549,'工龄报表') 
/
insert into HtmlLabelIndex values(16562,'差异总额') 
/
insert into HtmlLabelIndex values(16563,'变动相关') 
/
insert into HtmlLabelIndex values(16566,'转正情况') 
/
insert into HtmlLabelIndex values(16567,'续签情况') 
/
insert into HtmlLabelIndex values(16580,'定义报表') 
/
insert into HtmlLabelIndex values(16581,'基本报表') 
/
insert into HtmlLabelIndex values(16593,'客户金额') 
/
insert into HtmlLabelIndex values(16606,'最多被阅文档') 
/
insert into HtmlLabelIndex values(16608,'最多文档语言') 
/
insert into HtmlLabelIndex values(16617,'资产组设置') 
/
insert into HtmlLabelIndex values(16622,'数据中心') 
/
insert into HtmlLabelIndex values(16623,'数据中心') 
/
insert into HtmlLabelIndex values(16624,'数据中心') 
/
insert into HtmlLabelIndex values(16635,'发送短信') 
/
insert into HtmlLabelIndex values(16639,'移动到服务器') 
/



insert into HtmlLabelInfo values(57,'',8) 
/
insert into HtmlLabelInfo values(57,'部门导航',7) 
/
insert into HtmlLabelInfo values(58,'Documents',8) 
/
insert into HtmlLabelInfo values(58,'文档',7) 
/
insert into HtmlLabelInfo values(60,'Maintenance',8) 
/
insert into HtmlLabelInfo values(60,'维护',7) 
/
insert into HtmlLabelInfo values(61,'Base',8) 
/
insert into HtmlLabelInfo values(61,'基本',7) 
/
insert into HtmlLabelInfo values(63,'Types',8) 
/
insert into HtmlLabelInfo values(63,'类型',7) 
/
insert into HtmlLabelInfo values(64,'Mould',8) 
/
insert into HtmlLabelInfo values(64,'模板',7) 
/
insert into HtmlLabelInfo values(65,'MainCategory',8) 
/
insert into HtmlLabelInfo values(65,'主目录',7) 
/
insert into HtmlLabelInfo values(66,'SubCategory',8) 
/
insert into HtmlLabelInfo values(66,'分目录',7) 
/
insert into HtmlLabelInfo values(67,'SecCategory',8) 
/
insert into HtmlLabelInfo values(67,'子目录',7) 
/
insert into HtmlLabelInfo values(68,'Setting',8) 
/
insert into HtmlLabelInfo values(68,'设置',7) 
/
insert into HtmlLabelInfo values(70,'News',8) 
/
insert into HtmlLabelInfo values(70,'新闻页',7) 
/
insert into HtmlLabelInfo values(71,'Mail',8) 
/
insert into HtmlLabelInfo values(71,'邮件',7) 
/
insert into HtmlLabelInfo values(72,'Tools',8) 
/
insert into HtmlLabelInfo values(72,'常用工具',7) 
/
insert into HtmlLabelInfo values(73,'User Define',8) 
/
insert into HtmlLabelInfo values(73,'用户自定义',7) 
/
insert into HtmlLabelInfo values(74,'Picture',8) 
/
insert into HtmlLabelInfo values(74,'图片',7) 
/
insert into HtmlLabelInfo values(75,'Upload',8) 
/
insert into HtmlLabelInfo values(75,'上传',7) 
/
insert into HtmlLabelInfo values(76,'Web Site',8) 
/
insert into HtmlLabelInfo values(76,'网站',7) 
/
insert into HtmlLabelInfo values(77,'Copy',8) 
/
insert into HtmlLabelInfo values(77,'复制',7) 
/
insert into HtmlLabelInfo values(78,'Move',8) 
/
insert into HtmlLabelInfo values(78,'移动',7) 
/
insert into HtmlLabelInfo values(79,'Owner',8) 
/
insert into HtmlLabelInfo values(79,'所有者',7) 
/
insert into HtmlLabelInfo values(80,'Trans',8) 
/
insert into HtmlLabelInfo values(80,'转移',7) 
/
insert into HtmlLabelInfo values(81,'Install',8) 
/
insert into HtmlLabelInfo values(81,'安装',7) 
/
insert into HtmlLabelInfo values(82,'New',8) 
/
insert into HtmlLabelInfo values(82,'新建',7) 
/
insert into HtmlLabelInfo values(83,'Log',8) 
/
insert into HtmlLabelInfo values(83,'日志',7) 
/
insert into HtmlLabelInfo values(84,'ID',8) 
/
insert into HtmlLabelInfo values(84,'标识',7) 
/
insert into HtmlLabelInfo values(85,'Description',8) 
/
insert into HtmlLabelInfo values(85,'说明',7) 
/
insert into HtmlLabelInfo values(86,'Save',8) 
/
insert into HtmlLabelInfo values(86,'保存',7) 
/
insert into HtmlLabelInfo values(87,'Info',8) 
/
insert into HtmlLabelInfo values(87,'信息',7) 
/
insert into HtmlLabelInfo values(88,'Order',8) 
/
insert into HtmlLabelInfo values(88,'顺序',7) 
/
insert into HtmlLabelInfo values(89,'Display',8) 
/
insert into HtmlLabelInfo values(89,'显示',7) 
/
insert into HtmlLabelInfo values(91,'Delete',8) 
/
insert into HtmlLabelInfo values(91,'删除',7) 
/
insert into HtmlLabelInfo values(92,'Category',8) 
/
insert into HtmlLabelInfo values(92,'目录',7) 
/
insert into HtmlLabelInfo values(93,'Edit',8) 
/
insert into HtmlLabelInfo values(93,'编辑',7) 
/
insert into HtmlLabelInfo values(95,'Detail',8) 
/
insert into HtmlLabelInfo values(95,'细节',7) 
/
insert into HtmlLabelInfo values(97,'Date',8) 
/
insert into HtmlLabelInfo values(97,'日期',7) 
/
insert into HtmlLabelInfo values(99,'Opeator',8) 
/
insert into HtmlLabelInfo values(99,'操作者',7) 
/
insert into HtmlLabelInfo values(101,'Project',8) 
/
insert into HtmlLabelInfo values(101,'项目',7) 
/
insert into HtmlLabelInfo values(103,'Change',8) 
/
insert into HtmlLabelInfo values(103,'修改',7) 
/
insert into HtmlLabelInfo values(104,'Operation',8) 
/
insert into HtmlLabelInfo values(104,'操作',7) 
/
insert into HtmlLabelInfo values(106,'Object',8) 
/
insert into HtmlLabelInfo values(106,'对象',7) 
/
insert into HtmlLabelInfo values(108,'Client',8) 
/
insert into HtmlLabelInfo values(108,'客户端',7) 
/
insert into HtmlLabelInfo values(110,'Address',8) 
/
insert into HtmlLabelInfo values(110,'地址',7) 
/
insert into HtmlLabelInfo values(112,'Setting',8) 
/
insert into HtmlLabelInfo values(112,'设定',7) 
/
insert into HtmlLabelInfo values(114,'Publish',8) 
/
insert into HtmlLabelInfo values(114,'发布',7) 
/
insert into HtmlLabelInfo values(115,'Use',8) 
/
insert into HtmlLabelInfo values(115,'允许',7) 
/
insert into HtmlLabelInfo values(117,'Replies',8) 
/
insert into HtmlLabelInfo values(117,'回复',7) 
/
insert into HtmlLabelInfo values(119,'Share',8) 
/
insert into HtmlLabelInfo values(119,'共享',7) 
/
insert into HtmlLabelInfo values(120,'Security',8) 
/
insert into HtmlLabelInfo values(120,'安全',7) 
/
insert into HtmlLabelInfo values(122,'Roles',8) 
/
insert into HtmlLabelInfo values(122,'角色',7) 
/
insert into HtmlLabelInfo values(124,'Department',8) 
/
insert into HtmlLabelInfo values(124,'部门',7) 
/
insert into HtmlLabelInfo values(125,'Create',8) 
/
insert into HtmlLabelInfo values(125,'创建',7) 
/
insert into HtmlLabelInfo values(127,'Person',8) 
/
insert into HtmlLabelInfo values(127,'人',7) 
/
insert into HtmlLabelInfo values(129,'Apply',8) 
/
insert into HtmlLabelInfo values(129,'申请',7) 
/
insert into HtmlLabelInfo values(130,'Contractor ',8) 
/
insert into HtmlLabelInfo values(130,'承包商',7) 
/
insert into HtmlLabelInfo values(131,'Employee ',8) 
/
insert into HtmlLabelInfo values(131,'雇员',7) 
/
insert into HtmlLabelInfo values(132,'Agent ',8) 
/
insert into HtmlLabelInfo values(132,'中介机构',7) 
/
insert into HtmlLabelInfo values(134,'Student',8) 
/
insert into HtmlLabelInfo values(134,'学生',7) 
/
insert into HtmlLabelInfo values(136,'Customer',8) 
/
insert into HtmlLabelInfo values(136,'客户',7) 
/
insert into HtmlLabelInfo values(138,'Supplier',8) 
/
insert into HtmlLabelInfo values(138,'供应商',7) 
/
insert into HtmlLabelInfo values(139,'Level',8) 
/
insert into HtmlLabelInfo values(139,'级别',7) 
/
insert into HtmlLabelInfo values(140,'Company',8) 
/
insert into HtmlLabelInfo values(140,'总部',7) 
/
insert into HtmlLabelInfo values(141,'SubCompany',8) 
/
insert into HtmlLabelInfo values(141,'分部',7) 
/
insert into HtmlLabelInfo values(142,'Approve',8) 
/
insert into HtmlLabelInfo values(142,'批准',7) 
/
insert into HtmlLabelInfo values(144,'Manager ',8) 
/
insert into HtmlLabelInfo values(144,'经理',7) 
/
insert into HtmlLabelInfo values(145,'Goods',8) 
/
insert into HtmlLabelInfo values(145,'物品',7) 
/
insert into HtmlLabelInfo values(147,'CRM',7) 
/
insert into HtmlLabelInfo values(147,'CRM',8) 
/
insert into HtmlLabelInfo values(149,'Default',8) 
/
insert into HtmlLabelInfo values(149,'默认',7) 
/
insert into HtmlLabelInfo values(151,'Top',8) 
/
insert into HtmlLabelInfo values(151,'最高',7) 
/
insert into HtmlLabelInfo values(154,'General',8) 
/
insert into HtmlLabelInfo values(154,'一般',7) 
/
insert into HtmlLabelInfo values(155,'Active',8) 
/
insert into HtmlLabelInfo values(155,'活跃',7) 
/
insert into HtmlLabelInfo values(156,'Affix',8) 
/
insert into HtmlLabelInfo values(156,'附件',7) 
/
insert into HtmlLabelInfo values(158,'Number',8) 
/
insert into HtmlLabelInfo values(158,'数目',7) 
/
insert into HtmlLabelInfo values(160,'Used',8) 
/
insert into HtmlLabelInfo values(160,'使用',7) 
/
insert into HtmlLabelInfo values(161,'No',8) 
/
insert into HtmlLabelInfo values(161,'否',7) 
/
insert into HtmlLabelInfo values(163,'Yes',8) 
/
insert into HtmlLabelInfo values(163,'是',7) 
/
insert into HtmlLabelInfo values(165,'No Used',8) 
/
insert into HtmlLabelInfo values(165,'未使用',7) 
/
insert into HtmlLabelInfo values(166,'Optional',8) 
/
insert into HtmlLabelInfo values(166,'可选择',7) 
/
insert into HtmlLabelInfo values(168,'Mandatory',8) 
/
insert into HtmlLabelInfo values(168,'强制性',7) 
/
insert into HtmlLabelInfo values(169,'状况',7) 
/
insert into HtmlLabelInfo values(169,'状况',8) 
/
insert into HtmlLabelInfo values(170,'Future',8) 
/
insert into HtmlLabelInfo values(170,'将来',7) 
/
insert into HtmlLabelInfo values(172,'Selection',8) 
/
insert into HtmlLabelInfo values(172,'选择',7) 
/
insert into HtmlLabelInfo values(174,'Example',8) 
/
insert into HtmlLabelInfo values(174,'例子',7) 
/
insert into HtmlLabelInfo values(176,'Label',8) 
/
insert into HtmlLabelInfo values(176,'标签',7) 
/
insert into HtmlLabelInfo values(178,'Sort',8) 
/
insert into HtmlLabelInfo values(178,'类别',7) 
/
insert into HtmlLabelInfo values(179,'Resource',8) 
/
insert into HtmlLabelInfo values(179,'人力资源',7) 
/
insert into HtmlLabelInfo values(181,'Hired',8) 
/
insert into HtmlLabelInfo values(181,'雇用',7) 
/
insert into HtmlLabelInfo values(182,'Cooperator',8) 
/
insert into HtmlLabelInfo values(182,'合伙人',7) 
/
insert into HtmlLabelInfo values(183,'prospect',7) 
/
insert into HtmlLabelInfo values(183,'prospect',8) 
/
insert into HtmlLabelInfo values(185,'Bank',8) 
/
insert into HtmlLabelInfo values(185,'银行',7) 
/
insert into HtmlLabelInfo values(187,'Transaction',8) 
/
insert into HtmlLabelInfo values(187,'交易',7) 
/
insert into HtmlLabelInfo values(189,'Financial',8) 
/
insert into HtmlLabelInfo values(189,'财务',7) 
/
insert into HtmlLabelInfo values(191,'ref.',8) 
/
insert into HtmlLabelInfo values(191,'参考',7) 
/
insert into HtmlLabelInfo values(193,'Join',8) 
/
insert into HtmlLabelInfo values(193,'加入',7) 
/
insert into HtmlLabelInfo values(195,'Name',8) 
/
insert into HtmlLabelInfo values(195,'名称',7) 
/
insert into HtmlLabelInfo values(197,'Search',8) 
/
insert into HtmlLabelInfo values(197,'搜索',7) 
/
insert into HtmlLabelInfo values(199,'Reset',8) 
/
insert into HtmlLabelInfo values(199,'重新设置',7) 
/
insert into HtmlLabelInfo values(201,'Cancel',8) 
/
insert into HtmlLabelInfo values(201,'取消',7) 
/
insert into HtmlLabelInfo values(203,'width',8) 
/
insert into HtmlLabelInfo values(203,'宽度',7) 
/
insert into HtmlLabelInfo values(207,'height',8) 
/
insert into HtmlLabelInfo values(207,'高度',7) 
/
insert into HtmlLabelInfo values(209,'Resize',8) 
/
insert into HtmlLabelInfo values(209,'调整大小',7) 
/
insert into HtmlLabelInfo values(211,'No,don\''t resize',8) 
/
insert into HtmlLabelInfo values(211,'不改动',7) 
/
insert into HtmlLabelInfo values(212,'Yes,fix as standard',8) 
/
insert into HtmlLabelInfo values(212,'按设置固定',7) 
/
insert into HtmlLabelInfo values(213,'Yes,if smaller',8) 
/
insert into HtmlLabelInfo values(213,'改动，如果小于',7) 
/
insert into HtmlLabelInfo values(214,'Yes,if bigger',8) 
/
insert into HtmlLabelInfo values(214,'改动，如果大于',7) 
/
insert into HtmlLabelInfo values(216,'combine',8) 
/
insert into HtmlLabelInfo values(216,'合并',7) 
/
insert into HtmlLabelInfo values(218,'pixel(s)',8) 
/
insert into HtmlLabelInfo values(218,'像素',7) 
/
insert into HtmlLabelInfo values(219,'Byte(s)',8) 
/
insert into HtmlLabelInfo values(219,'字节',7) 
/
insert into HtmlLabelInfo values(220,'Draft',8) 
/
insert into HtmlLabelInfo values(220,'草稿',7) 
/
insert into HtmlLabelInfo values(221,'Preview',8) 
/
insert into HtmlLabelInfo values(221,'预览',7) 
/
insert into HtmlLabelInfo values(222,'Html',7) 
/
insert into HtmlLabelInfo values(222,'Html',8) 
/
insert into HtmlLabelInfo values(224,'Header',8) 
/
insert into HtmlLabelInfo values(224,'页眉',7) 
/
insert into HtmlLabelInfo values(225,'Normal',8) 
/
insert into HtmlLabelInfo values(225,'正常',7) 
/
insert into HtmlLabelInfo values(227,'Frontpage',8) 
/
insert into HtmlLabelInfo values(227,'主页',7) 
/
insert into HtmlLabelInfo values(229,'Title',8) 
/
insert into HtmlLabelInfo values(229,'标题',7) 
/
insert into HtmlLabelInfo values(231,'Language',8) 
/
insert into HtmlLabelInfo values(231,'语言',7) 
/
insert into HtmlLabelInfo values(233,'No',8) 
/
insert into HtmlLabelInfo values(233,'不',7) 
/
insert into HtmlLabelInfo values(235,'Everybody',8) 
/
insert into HtmlLabelInfo values(235,'所有',7) 
/
insert into HtmlLabelInfo values(236,'Reject',8) 
/
insert into HtmlLabelInfo values(236,'退回',7) 
/
insert into HtmlLabelInfo values(244,'Reopen',8) 
/
insert into HtmlLabelInfo values(244,'重新打开',7) 
/
insert into HtmlLabelInfo values(251,'Archive',8) 
/
insert into HtmlLabelInfo values(251,'归档',7) 
/
insert into HtmlLabelInfo values(256,'Reload',8) 
/
insert into HtmlLabelInfo values(256,'重载',7) 
/
insert into HtmlLabelInfo values(257,'Print',8) 
/
insert into HtmlLabelInfo values(257,'打印',7) 
/
insert into HtmlLabelInfo values(258,'Download',8) 
/
insert into HtmlLabelInfo values(258,'下载',7) 
/
insert into HtmlLabelInfo values(259,'Workflow',8) 
/
insert into HtmlLabelInfo values(259,'工作流',7) 
/
insert into HtmlLabelInfo values(260,'Read',8) 
/
insert into HtmlLabelInfo values(260,'阅读',7) 
/
insert into HtmlLabelInfo values(261,'Fields',8) 
/
insert into HtmlLabelInfo values(261,'字段',7) 
/
insert into HtmlLabelInfo values(264,'Record(s)',8) 
/
insert into HtmlLabelInfo values(264,'记录',7) 
/
insert into HtmlLabelInfo values(265,'PerPage',8) 
/
insert into HtmlLabelInfo values(265,'每页',7) 
/
insert into HtmlLabelInfo values(271,'Creater',8) 
/
insert into HtmlLabelInfo values(271,'创建者',7) 
/
insert into HtmlLabelInfo values(275,'Help',8) 
/
insert into HtmlLabelInfo values(275,'帮助',7) 
/
insert into HtmlLabelInfo values(277,'Time',8) 
/
insert into HtmlLabelInfo values(277,'时间',7) 
/
insert into HtmlLabelInfo values(280,'Size',8) 
/
insert into HtmlLabelInfo values(280,'尺寸',7) 
/
insert into HtmlLabelInfo values(293,'Change',8) 
/
insert into HtmlLabelInfo values(293,'更改',7) 
/
insert into HtmlLabelInfo values(309,'Close',8) 
/
insert into HtmlLabelInfo values(309,'关闭',7) 
/
insert into HtmlLabelInfo values(311,'Clear',8) 
/
insert into HtmlLabelInfo values(311,'清除',7) 
/
insert into HtmlLabelInfo values(316,'News',8) 
/
insert into HtmlLabelInfo values(316,'新闻',7) 
/
insert into HtmlLabelInfo values(320,'List',8) 
/
insert into HtmlLabelInfo values(320,'列表',7) 
/
insert into HtmlLabelInfo values(321,'Perpage Recorder',8) 
/
insert into HtmlLabelInfo values(321,'每页记录',7) 
/
insert into HtmlLabelInfo values(322,'Import News',8) 
/
insert into HtmlLabelInfo values(322,'要闻',7) 
/
insert into HtmlLabelInfo values(323,'Footer',8) 
/
insert into HtmlLabelInfo values(323,'页脚',7) 
/
insert into HtmlLabelInfo values(324,'Standard',8) 
/
insert into HtmlLabelInfo values(324,'标准',7) 
/
insert into HtmlLabelInfo values(325,'Greater than or equal',8) 
/
insert into HtmlLabelInfo values(325,'大于或等于',7) 
/
insert into HtmlLabelInfo values(326,'Smaller than or equal',8) 
/
insert into HtmlLabelInfo values(326,'小于或等于',7) 
/
insert into HtmlLabelInfo values(327,'Equal',8) 
/
insert into HtmlLabelInfo values(327,'等于',7) 
/
insert into HtmlLabelInfo values(328,'Leave ',8) 
/
insert into HtmlLabelInfo values(328,'保留',7) 
/
insert into HtmlLabelInfo values(329,'in days',8) 
/
insert into HtmlLabelInfo values(329,'天以内',7) 
/
insert into HtmlLabelInfo values(330,'Target',8) 
/
insert into HtmlLabelInfo values(330,'目标',7) 
/
insert into HtmlLabelInfo values(331,'Source',8) 
/
insert into HtmlLabelInfo values(331,'源',7) 
/
insert into HtmlLabelInfo values(332,'All',8) 
/
insert into HtmlLabelInfo values(332,'全部',7) 
/
insert into HtmlLabelInfo values(333,'Button',8) 
/
insert into HtmlLabelInfo values(333,'按钮',7) 
/
insert into HtmlLabelInfo values(334,'Backgroud',8) 
/
insert into HtmlLabelInfo values(334,'背景',7) 
/
insert into HtmlLabelInfo values(335,'LOGO',7) 
/
insert into HtmlLabelInfo values(335,'LOGO',8) 
/
insert into HtmlLabelInfo values(336,'Scale',8) 
/
insert into HtmlLabelInfo values(336,'比例',7) 
/
insert into HtmlLabelInfo values(337,'KB',7) 
/
insert into HtmlLabelInfo values(337,'KB',8) 
/
insert into HtmlLabelInfo values(338,'Order',8) 
/
insert into HtmlLabelInfo values(338,'排序',7) 
/
insert into HtmlLabelInfo values(339,'Ascending',8) 
/
insert into HtmlLabelInfo values(339,'升序',7) 
/
insert into HtmlLabelInfo values(340,'Descending',8) 
/
insert into HtmlLabelInfo values(340,'降序',7) 
/
insert into HtmlLabelInfo values(341,'Summary',8) 
/
insert into HtmlLabelInfo values(341,'摘要',7) 
/
insert into HtmlLabelInfo values(342,'Simple',8) 
/
insert into HtmlLabelInfo values(342,'简单',7) 
/
insert into HtmlLabelInfo values(343,'Setting',8) 
/
insert into HtmlLabelInfo values(343,'定制',7) 
/
insert into HtmlLabelInfo values(344,'Subject',8) 
/
insert into HtmlLabelInfo values(344,'主题',7) 
/
insert into HtmlLabelInfo values(345,'Content',8) 
/
insert into HtmlLabelInfo values(345,'内容',7) 
/
insert into HtmlLabelInfo values(346,'Contain',8) 
/
insert into HtmlLabelInfo values(346,'包含',7) 
/
insert into HtmlLabelInfo values(347,'Advance',8) 
/
insert into HtmlLabelInfo values(347,'高级',7) 
/
insert into HtmlLabelInfo values(348,'From',8) 
/
insert into HtmlLabelInfo values(348,'从',7) 
/
insert into HtmlLabelInfo values(349,'To',8) 
/
insert into HtmlLabelInfo values(349,'到',7) 
/
insert into HtmlLabelInfo values(350,'SaveAs',8) 
/
insert into HtmlLabelInfo values(350,'另存为',7) 
/
insert into HtmlLabelInfo values(351,'Report',8) 
/
insert into HtmlLabelInfo values(351,'报告',7) 
/
insert into HtmlLabelInfo values(352,'Miscellaneous',8) 
/
insert into HtmlLabelInfo values(352,'统计',7) 
/
insert into HtmlLabelInfo values(353,'Belong',8) 
/
insert into HtmlLabelInfo values(353,'属于',7) 
/
insert into HtmlLabelInfo values(354,'Refresh',8) 
/
insert into HtmlLabelInfo values(354,'刷新',7) 
/
insert into HtmlLabelInfo values(355,'Count',8) 
/
insert into HtmlLabelInfo values(355,'总数',7) 
/
insert into HtmlLabelInfo values(356,'Result',8) 
/
insert into HtmlLabelInfo values(356,'结果',7) 
/
insert into HtmlLabelInfo values(357,'Job Title',8) 
/
insert into HtmlLabelInfo values(357,'职务',7) 
/
insert into HtmlLabelInfo values(358,'Count',8) 
/
insert into HtmlLabelInfo values(358,'合计',7) 
/
insert into HtmlLabelInfo values(359,'Confirm',8) 
/
insert into HtmlLabelInfo values(359,'审批',7) 
/
insert into HtmlLabelInfo values(360,'Open',8) 
/
insert into HtmlLabelInfo values(360,'打开',7) 
/
insert into HtmlLabelInfo values(361,'More',8) 
/
insert into HtmlLabelInfo values(361,'详细',7) 
/
insert into HtmlLabelInfo values(362,'Employee',8) 
/
insert into HtmlLabelInfo values(362,'员工',7) 
/
insert into HtmlLabelInfo values(363,'Count',8) 
/
insert into HtmlLabelInfo values(363,'计数',7) 
/
insert into HtmlLabelInfo values(364,'ReSearch',8) 
/
insert into HtmlLabelInfo values(364,'重新搜索',7) 
/
insert into HtmlLabelInfo values(365,'New',8) 
/
insert into HtmlLabelInfo values(365,'新建',7) 
/
insert into HtmlLabelInfo values(366,'Recruit',8) 
/
insert into HtmlLabelInfo values(366,'招聘信息',7) 
/
insert into HtmlLabelInfo values(367,'View',8) 
/
insert into HtmlLabelInfo values(367,'查看',7) 
/
insert into HtmlLabelInfo values(368,'Applier',8) 
/
insert into HtmlLabelInfo values(368,'申请人',7) 
/
insert into HtmlLabelInfo values(369,'Schedule',8) 
/
insert into HtmlLabelInfo values(369,'工作时间',7) 
/
insert into HtmlLabelInfo values(370,'Public',8) 
/
insert into HtmlLabelInfo values(370,'公众',7) 
/
insert into HtmlLabelInfo values(371,'Vocation',8) 
/
insert into HtmlLabelInfo values(371,'假日',7) 
/
insert into HtmlLabelInfo values(372,'Different',8) 
/
insert into HtmlLabelInfo values(372,'非一致',7) 
/
insert into HtmlLabelInfo values(374,'HrmDuring',8) 
/
insert into HtmlLabelInfo values(374,'人事期间',7) 
/
insert into HtmlLabelInfo values(375,'Other',8) 
/
insert into HtmlLabelInfo values(375,'其他',7) 
/
insert into HtmlLabelInfo values(376,'Structure',8) 
/
insert into HtmlLabelInfo values(376,'组织',7) 
/
insert into HtmlLabelInfo values(377,'Country',8) 
/
insert into HtmlLabelInfo values(377,'国家',7) 
/
insert into HtmlLabelInfo values(378,'Position',8) 
/
insert into HtmlLabelInfo values(378,'办公地点',7) 
/
insert into HtmlLabelInfo values(380,'Work',8) 
/
insert into HtmlLabelInfo values(380,'工作',7) 
/
insert into HtmlLabelInfo values(381,'Structure',8) 
/
insert into HtmlLabelInfo values(381,'结构',7) 
/
insert into HtmlLabelInfo values(382,'Duty ',8) 
/
insert into HtmlLabelInfo values(382,'职责',7) 
/
insert into HtmlLabelInfo values(383,'Function',8) 
/
insert into HtmlLabelInfo values(383,'职能',7) 
/
insert into HtmlLabelInfo values(384,'Skill',8) 
/
insert into HtmlLabelInfo values(384,'技能',7) 
/
insert into HtmlLabelInfo values(385,'Perview',8) 
/
insert into HtmlLabelInfo values(385,'权限',7) 
/
insert into HtmlLabelInfo values(386,'Budget',8) 
/
insert into HtmlLabelInfo values(386,'预算',7) 
/
insert into HtmlLabelInfo values(387,'Element',8) 
/
insert into HtmlLabelInfo values(387,'要素',7) 
/
insert into HtmlLabelInfo values(388,'Main',8) 
/
insert into HtmlLabelInfo values(388,'主体',7) 
/
insert into HtmlLabelInfo values(389,'Bank Account',8) 
/
insert into HtmlLabelInfo values(389,'银行帐户',7) 
/
insert into HtmlLabelInfo values(390,'Day',8) 
/
insert into HtmlLabelInfo values(390,'日',7) 
/
insert into HtmlLabelInfo values(391,'Hour',8) 
/
insert into HtmlLabelInfo values(391,'小时',7) 
/
insert into HtmlLabelInfo values(392,'Monday',8) 
/
insert into HtmlLabelInfo values(392,'星期一',7) 
/
insert into HtmlLabelInfo values(393,'Tuesday',8) 
/
insert into HtmlLabelInfo values(393,'星期二',7) 
/
insert into HtmlLabelInfo values(394,'Wednesday',8) 
/
insert into HtmlLabelInfo values(394,'星期三',7) 
/
insert into HtmlLabelInfo values(395,'Thursday',8) 
/
insert into HtmlLabelInfo values(395,'星期四',7) 
/
insert into HtmlLabelInfo values(396,'Friday',8) 
/
insert into HtmlLabelInfo values(396,'星期五',7) 
/
insert into HtmlLabelInfo values(397,'Saturday',8) 
/
insert into HtmlLabelInfo values(397,'星期六',7) 
/
insert into HtmlLabelInfo values(398,'Sunday',8) 
/
insert into HtmlLabelInfo values(398,'星期日',7) 
/
insert into HtmlLabelInfo values(399,'ShortName',8) 
/
insert into HtmlLabelInfo values(399,'简称',7) 
/
insert into HtmlLabelInfo values(400,'Not_Define',8) 
/
insert into HtmlLabelInfo values(400,'未定义',7) 
/
insert into HtmlLabelInfo values(401,'Create',8) 
/
insert into HtmlLabelInfo values(401,'建立',7) 
/
insert into HtmlLabelInfo values(402,'Value Added Tax ',8) 
/
insert into HtmlLabelInfo values(402,'增值税',7) 
/
insert into HtmlLabelInfo values(403,'Number',8) 
/
insert into HtmlLabelInfo values(403,'号码',7) 
/
insert into HtmlLabelInfo values(404,'Start ',8) 
/
insert into HtmlLabelInfo values(404,'起始',7) 
/
insert into HtmlLabelInfo values(405,'End ',8) 
/
insert into HtmlLabelInfo values(405,'结束',7) 
/
insert into HtmlLabelInfo values(406,'Currency',8) 
/
insert into HtmlLabelInfo values(406,'币种',7) 
/
insert into HtmlLabelInfo values(407,'Plan',8) 
/
insert into HtmlLabelInfo values(407,'计划',7) 
/
insert into HtmlLabelInfo values(408,'competency',8) 
/
insert into HtmlLabelInfo values(408,'能力',7) 
/
insert into HtmlLabelInfo values(409,'Password',8) 
/
insert into HtmlLabelInfo values(409,'密码',7) 
/
insert into HtmlLabelInfo values(410,'Other Info',8) 
/
insert into HtmlLabelInfo values(410,'其它信息',7) 
/
insert into HtmlLabelInfo values(411,'HRM Info',8) 
/
insert into HtmlLabelInfo values(411,'个人资料',7) 
/
insert into HtmlLabelInfo values(412,'Login ID',8) 
/
insert into HtmlLabelInfo values(412,'登录名',7) 
/
insert into HtmlLabelInfo values(413,'Name',8) 
/
insert into HtmlLabelInfo values(413,'姓名',7) 
/
insert into HtmlLabelInfo values(415,'Inactive',8) 
/
insert into HtmlLabelInfo values(415,'不活跃',7) 
/
insert into HtmlLabelInfo values(416,'Sex',8) 
/
insert into HtmlLabelInfo values(416,'性别',7) 
/
insert into HtmlLabelInfo values(417,'male',8) 
/
insert into HtmlLabelInfo values(417,'男性',7) 
/
insert into HtmlLabelInfo values(418,'female',8) 
/
insert into HtmlLabelInfo values(418,'女性',7) 
/
insert into HtmlLabelInfo values(419,'Work Location',8) 
/
insert into HtmlLabelInfo values(419,'工作地址',7) 
/
insert into HtmlLabelInfo values(420,'Officer',8) 
/
insert into HtmlLabelInfo values(420,'办公室',7) 
/
insert into HtmlLabelInfo values(421,'Telephone',8) 
/
insert into HtmlLabelInfo values(421,'电话',7) 
/
insert into HtmlLabelInfo values(422,'Mobil Phone',8) 
/
insert into HtmlLabelInfo values(422,'手机',7) 
/
insert into HtmlLabelInfo values(423,'Exist',8) 
/
insert into HtmlLabelInfo values(423,'存在',7) 
/
insert into HtmlLabelInfo values(424,'Mender',8) 
/
insert into HtmlLabelInfo values(424,'修改者',7) 
/
insert into HtmlLabelInfo values(425,'Cost ',8) 
/
insert into HtmlLabelInfo values(425,'成本',7) 
/
insert into HtmlLabelInfo values(426,'Center',8) 
/
insert into HtmlLabelInfo values(426,'中心',7) 
/
insert into HtmlLabelInfo values(427,'G/L',8) 
/
insert into HtmlLabelInfo values(427,'总帐',7) 
/
insert into HtmlLabelInfo values(428,'Transactions',8) 
/
insert into HtmlLabelInfo values(428,'收支',7) 
/
insert into HtmlLabelInfo values(430,'Participations',8) 
/
insert into HtmlLabelInfo values(430,'参与',7) 
/
insert into HtmlLabelInfo values(431,'members',8) 
/
insert into HtmlLabelInfo values(431,'成员',7) 
/
insert into HtmlLabelInfo values(432,'Job Groups',8) 
/
insert into HtmlLabelInfo values(432,'工作类型',7) 
/
insert into HtmlLabelInfo values(433,'Description ',8) 
/
insert into HtmlLabelInfo values(433,'描述',7) 
/
insert into HtmlLabelInfo values(434,'involvement',8) 
/
insert into HtmlLabelInfo values(434,'涉及',7) 
/
insert into HtmlLabelInfo values(436,'ratifier',8) 
/
insert into HtmlLabelInfo values(436,'批准者',7) 
/
insert into HtmlLabelInfo values(437,'implement',8) 
/
insert into HtmlLabelInfo values(437,'实现者',7) 
/
insert into HtmlLabelInfo values(438,'handler',8) 
/
insert into HtmlLabelInfo values(438,'处理者',7) 
/
insert into HtmlLabelInfo values(439,'approver',8) 
/
insert into HtmlLabelInfo values(439,'审批者',7) 
/
insert into HtmlLabelInfo values(440,'popedomItem',8) 
/
insert into HtmlLabelInfo values(440,'权限项',7) 
/
insert into HtmlLabelInfo values(441,'Assitant',8) 
/
insert into HtmlLabelInfo values(441,'助理',7) 
/
insert into HtmlLabelInfo values(442,'Subordinates',8) 
/
insert into HtmlLabelInfo values(442,'下属',7) 
/
insert into HtmlLabelInfo values(443,'Last login date',8) 
/
insert into HtmlLabelInfo values(443,'最后登录日期',7) 
/
insert into HtmlLabelInfo values(444,'Mobil Call',8) 
/
insert into HtmlLabelInfo values(444,'寻呼',7) 
/
insert into HtmlLabelInfo values(445,'Year',8) 
/
insert into HtmlLabelInfo values(445,'年',7) 
/
insert into HtmlLabelInfo values(446,'During',8) 
/
insert into HtmlLabelInfo values(446,'期间',7) 
/
insert into HtmlLabelInfo values(447,'changetype',8) 
/
insert into HtmlLabelInfo values(447,'变动',7) 
/
insert into HtmlLabelInfo values(448,'Salary',8) 
/
insert into HtmlLabelInfo values(448,'薪资',7) 
/
insert into HtmlLabelInfo values(449,'Caculate',8) 
/
insert into HtmlLabelInfo values(449,'计算',7) 
/
insert into HtmlLabelInfo values(450,'Difftime',8) 
/
insert into HtmlLabelInfo values(450,'相关时间',7) 
/
insert into HtmlLabelInfo values(451,'Min.',8) 
/
insert into HtmlLabelInfo values(451,'最小',7) 
/
insert into HtmlLabelInfo values(452,'countnum',8) 
/
insert into HtmlLabelInfo values(452,'倍数',7) 
/
insert into HtmlLabelInfo values(453,'fixnum',8) 
/
insert into HtmlLabelInfo values(453,'固定值',7) 
/
insert into HtmlLabelInfo values(454,'Remark',8) 
/
insert into HtmlLabelInfo values(454,'备注',7) 
/
insert into HtmlLabelInfo values(455,'SubCategory',8) 
/
insert into HtmlLabelInfo values(455,'分类',7) 
/
insert into HtmlLabelInfo values(456,'Increase',8) 
/
insert into HtmlLabelInfo values(456,'增加',7) 
/
insert into HtmlLabelInfo values(457,'Decrease',8) 
/
insert into HtmlLabelInfo values(457,'减少',7) 
/
insert into HtmlLabelInfo values(458,'holiday',8) 
/
insert into HtmlLabelInfo values(458,'休息日',7) 
/
insert into HtmlLabelInfo values(459,'Fix',8) 
/
insert into HtmlLabelInfo values(459,'固定',7) 
/
insert into HtmlLabelInfo values(460,'Firstname',8) 
/
insert into HtmlLabelInfo values(460,'名字',7) 
/
insert into HtmlLabelInfo values(461,'Lastname',8) 
/
insert into HtmlLabelInfo values(461,'姓',7) 
/
insert into HtmlLabelInfo values(462,'Title',8) 
/
insert into HtmlLabelInfo values(462,'称呼',7) 
/
insert into HtmlLabelInfo values(463,'Unknow',8) 
/
insert into HtmlLabelInfo values(463,'未知',7) 
/
insert into HtmlLabelInfo values(464,'Birthday',8) 
/
insert into HtmlLabelInfo values(464,'出生日期',7) 
/
insert into HtmlLabelInfo values(465,'Nationality',8) 
/
insert into HtmlLabelInfo values(465,'国籍',7) 
/
insert into HtmlLabelInfo values(466,'P&amp;L',7) 
/
insert into HtmlLabelInfo values(466,'P&amp;L',8) 
/
insert into HtmlLabelInfo values(467,'Oral',8) 
/
insert into HtmlLabelInfo values(467,'母语',7) 
/
insert into HtmlLabelInfo values(468,'System',8) 
/
insert into HtmlLabelInfo values(468,'系统',7) 
/
insert into HtmlLabelInfo values(469,'Marital status',8) 
/
insert into HtmlLabelInfo values(469,'婚姻状况',7) 
/
insert into HtmlLabelInfo values(470,'Single',8) 
/
insert into HtmlLabelInfo values(470,'未婚',7) 
/
insert into HtmlLabelInfo values(471,'Married',8) 
/
insert into HtmlLabelInfo values(471,'已婚',7) 
/
insert into HtmlLabelInfo values(472,'Devorced',8) 
/
insert into HtmlLabelInfo values(472,'离异',7) 
/
insert into HtmlLabelInfo values(473,'Living together',8) 
/
insert into HtmlLabelInfo values(473,'同居',7) 
/
insert into HtmlLabelInfo values(474,'Married date',8) 
/
insert into HtmlLabelInfo values(474,'结婚日期',7) 
/
insert into HtmlLabelInfo values(475,'Aliasname',8) 
/
insert into HtmlLabelInfo values(475,'别名',7) 
/
insert into HtmlLabelInfo values(476,'Work info',8) 
/
insert into HtmlLabelInfo values(476,'办公信息',7) 
/
insert into HtmlLabelInfo values(477,'Email',8) 
/
insert into HtmlLabelInfo values(477,'电子邮件',7) 
/
insert into HtmlLabelInfo values(478,'Home info',8) 
/
insert into HtmlLabelInfo values(478,'家庭信息',7) 
/
insert into HtmlLabelInfo values(479,'Post Code',8) 
/
insert into HtmlLabelInfo values(479,'邮政编码',7) 
/
insert into HtmlLabelInfo values(480,'Temporary',8) 
/
insert into HtmlLabelInfo values(480,'临时',7) 
/
insert into HtmlLabelInfo values(481,'Start date',8) 
/
insert into HtmlLabelInfo values(481,'起始日',7) 
/
insert into HtmlLabelInfo values(482,'Contract end date',8) 
/
insert into HtmlLabelInfo values(482,'合同终止日期',7) 
/
insert into HtmlLabelInfo values(483,'System end date',8) 
/
insert into HtmlLabelInfo values(483,'系统停止日期',7) 
/
insert into HtmlLabelInfo values(484,'Job level',8) 
/
insert into HtmlLabelInfo values(484,'职级',7) 
/
insert into HtmlLabelInfo values(485,'Purchare limit',8) 
/
insert into HtmlLabelInfo values(485,'采购限制',7) 
/
insert into HtmlLabelInfo values(486,'Security no',8) 
/
insert into HtmlLabelInfo values(486,'社会安全号',7) 
/
insert into HtmlLabelInfo values(487,'Credit card',8) 
/
insert into HtmlLabelInfo values(487,'信用卡',7) 
/
insert into HtmlLabelInfo values(488,'Expiry date',8) 
/
insert into HtmlLabelInfo values(488,'到期日',7) 
/
insert into HtmlLabelInfo values(490,'Calendar',8) 
/
insert into HtmlLabelInfo values(490,'日历',7) 
/
insert into HtmlLabelInfo values(491,'List',8) 
/
insert into HtmlLabelInfo values(491,'清单',7) 
/
insert into HtmlLabelInfo values(492,'purviewgroup',8) 
/
insert into HtmlLabelInfo values(492,'权限组',7) 
/
insert into HtmlLabelInfo values(493,'City',8) 
/
insert into HtmlLabelInfo values(493,'城市',7) 
/
insert into HtmlLabelInfo values(494,'Fax',8) 
/
insert into HtmlLabelInfo values(494,'传真',7) 
/
insert into HtmlLabelInfo values(495,'Color',8) 
/
insert into HtmlLabelInfo values(495,'颜色',7) 
/
insert into HtmlLabelInfo values(496,'days',8) 
/
insert into HtmlLabelInfo values(496,'天数',7) 
/
insert into HtmlLabelInfo values(497,'ForeignKey',8) 
/
insert into HtmlLabelInfo values(497,'外键',7) 
/
insert into HtmlLabelInfo values(498,'Fail',8) 
/
insert into HtmlLabelInfo values(498,'失败',7) 
/
insert into HtmlLabelInfo values(499,'Before',8) 
/
insert into HtmlLabelInfo values(499,'前面',7) 
/
insert into HtmlLabelInfo values(500,'Last',8) 
/
insert into HtmlLabelInfo values(500,'后面',7) 
/
insert into HtmlLabelInfo values(501,'Confirm password',8) 
/
insert into HtmlLabelInfo values(501,'确认密码',7) 
/
insert into HtmlLabelInfo values(502,'Old',8) 
/
insert into HtmlLabelInfo values(502,'旧',7) 
/
insert into HtmlLabelInfo values(503,'Payroll',8) 
/
insert into HtmlLabelInfo values(503,'工资单',7) 
/
insert into HtmlLabelInfo values(504,'opinion',8) 
/
insert into HtmlLabelInfo values(504,'意见',7) 
/
insert into HtmlLabelInfo values(505,'DocType',8) 
/
insert into HtmlLabelInfo values(505,'文档类型',7) 
/
insert into HtmlLabelInfo values(506,'DocMould',8) 
/
insert into HtmlLabelInfo values(506,'文档模板',7) 
/
insert into HtmlLabelInfo values(507,'PicUpload',8) 
/
insert into HtmlLabelInfo values(507,'图片上传',7) 
/
insert into HtmlLabelInfo values(508,'DocCopyCut',8) 
/
insert into HtmlLabelInfo values(508,'文档复制转移',7) 
/
insert into HtmlLabelInfo values(509,'DefSchedule',8) 
/
insert into HtmlLabelInfo values(509,'默认工作时间',7) 
/
insert into HtmlLabelInfo values(510,'DeptSchedule',8) 
/
insert into HtmlLabelInfo values(510,'部门工作时间',7) 
/
insert into HtmlLabelInfo values(511,'ResourceSchedule',8) 
/
insert into HtmlLabelInfo values(511,'人力资源工作时间',7) 
/
insert into HtmlLabelInfo values(512,'ScheduleDiff',8) 
/
insert into HtmlLabelInfo values(512,'非一致工作时间',7) 
/
insert into HtmlLabelInfo values(513,'CostCenterMain',8) 
/
insert into HtmlLabelInfo values(513,'成本中心主目录',7) 
/
insert into HtmlLabelInfo values(514,'CostCenterSub',8) 
/
insert into HtmlLabelInfo values(514,'成本中心分目录',7) 
/
insert into HtmlLabelInfo values(515,'CostCenter',8) 
/
insert into HtmlLabelInfo values(515,'成本中心',7) 
/
insert into HtmlLabelInfo values(516,'PubHoliday',8) 
/
insert into HtmlLabelInfo values(516,'公共假日',7) 
/
insert into HtmlLabelInfo values(517,'Location',8) 
/
insert into HtmlLabelInfo values(517,'地区',7) 
/
insert into HtmlLabelInfo values(518,'JobDuty',8) 
/
insert into HtmlLabelInfo values(518,'工作职责',7) 
/
insert into HtmlLabelInfo values(519,'JobFunction',8) 
/
insert into HtmlLabelInfo values(519,'工作职能',7) 
/
insert into HtmlLabelInfo values(520,'WorkSkill',8) 
/
insert into HtmlLabelInfo values(520,'工作技能',7) 
/
insert into HtmlLabelInfo values(521,'SalaryComponentTypes',8) 
/
insert into HtmlLabelInfo values(521,'财务要素主体',7) 
/
insert into HtmlLabelInfo values(522,'Relative',8) 
/
insert into HtmlLabelInfo values(522,'相关',7) 
/
insert into HtmlLabelInfo values(523,'Total',8) 
/
insert into HtmlLabelInfo values(523,'总计',7) 
/
insert into HtmlLabelInfo values(524,'Now',8) 
/
insert into HtmlLabelInfo values(524,'当前',7) 
/
insert into HtmlLabelInfo values(525,'Last One',8) 
/
insert into HtmlLabelInfo values(525,'前一次',7) 
/
insert into HtmlLabelInfo values(526,'Average',8) 
/
insert into HtmlLabelInfo values(526,'平均',7) 
/
insert into HtmlLabelInfo values(527,'Search',8) 
/
insert into HtmlLabelInfo values(527,'查询',7) 
/
insert into HtmlLabelInfo values(528,'Room',8) 
/
insert into HtmlLabelInfo values(528,'房间',7) 
/
insert into HtmlLabelInfo values(529,'Global',8) 
/
insert into HtmlLabelInfo values(529,'全球',7) 
/
insert into HtmlLabelInfo values(530,'Start',8) 
/
insert into HtmlLabelInfo values(530,'开始',7) 
/
insert into HtmlLabelInfo values(531,'ShortCut',8) 
/
insert into HtmlLabelInfo values(531,'快捷方式',7) 
/
insert into HtmlLabelInfo values(532,'Train',8) 
/
insert into HtmlLabelInfo values(532,'培训',7) 
/
insert into HtmlLabelInfo values(533,'SalaryComponent',8) 
/
insert into HtmlLabelInfo values(533,'财务要素',7) 
/
insert into HtmlLabelInfo values(534,'Salary',8) 
/
insert into HtmlLabelInfo values(534,'金额',7) 
/
insert into HtmlLabelInfo values(535,'Logistic',8) 
/
insert into HtmlLabelInfo values(535,'资产',7) 
/
insert into HtmlLabelInfo values(536,'Allowance',8) 
/
insert into HtmlLabelInfo values(536,'津贴',7) 
/
insert into HtmlLabelInfo values(537,'Decrease',8) 
/
insert into HtmlLabelInfo values(537,'减出',7) 
/
insert into HtmlLabelInfo values(538,'PerHalfyear',8) 
/
insert into HtmlLabelInfo values(538,'每半年',7) 
/
insert into HtmlLabelInfo values(539,'PerDay',8) 
/
insert into HtmlLabelInfo values(539,'每日',7) 
/
insert into HtmlLabelInfo values(540,'PerHour',8) 
/
insert into HtmlLabelInfo values(540,'每小时',7) 
/
insert into HtmlLabelInfo values(541,'PerMonth',8) 
/
insert into HtmlLabelInfo values(541,'每月',7) 
/
insert into HtmlLabelInfo values(542,'OnlyOnce',8) 
/
insert into HtmlLabelInfo values(542,'只一次',7) 
/
insert into HtmlLabelInfo values(543,'PerSeason',8) 
/
insert into HtmlLabelInfo values(543,'每季度',7) 
/
insert into HtmlLabelInfo values(544,'PerTwoWeeks',8) 
/
insert into HtmlLabelInfo values(544,'每两周',7) 
/
insert into HtmlLabelInfo values(545,'PerWeek',8) 
/
insert into HtmlLabelInfo values(545,'每周',7) 
/
insert into HtmlLabelInfo values(546,'PerYear',8) 
/
insert into HtmlLabelInfo values(546,'每年',7) 
/
insert into HtmlLabelInfo values(547,'Online',8) 
/
insert into HtmlLabelInfo values(547,'是否在线',7) 
/
insert into HtmlLabelInfo values(548,'IncludeTex',8) 
/
insert into HtmlLabelInfo values(548,'含税',7) 
/
insert into HtmlLabelInfo values(549,'AfterTex',8) 
/
insert into HtmlLabelInfo values(549,'税后',7) 
/
insert into HtmlLabelInfo values(550,'ledger',8) 
/
insert into HtmlLabelInfo values(550,'总帐帐户',7) 
/
insert into HtmlLabelInfo values(551,'AddRow',8) 
/
insert into HtmlLabelInfo values(551,'加入一行',7) 
/
insert into HtmlLabelInfo values(552,'Private',8) 
/
insert into HtmlLabelInfo values(552,'私人',7) 
/
insert into HtmlLabelInfo values(553,'Process',8) 
/
insert into HtmlLabelInfo values(553,'处理',7) 
/
insert into HtmlLabelInfo values(554,'Enter',8) 
/
insert into HtmlLabelInfo values(554,'输入',7) 
/
insert into HtmlLabelInfo values(555,'Done',8) 
/
insert into HtmlLabelInfo values(555,'完成',7) 
/
insert into HtmlLabelInfo values(556,'SelectAll',8) 
/
insert into HtmlLabelInfo values(556,'全选',7) 
/
insert into HtmlLabelInfo values(557,'none',8) 
/
insert into HtmlLabelInfo values(557,'无',7) 
/
insert into HtmlLabelInfo values(558,'NOTE',8) 
/
insert into HtmlLabelInfo values(558,'提示',7) 
/
insert into HtmlLabelInfo values(559,'CheckStr',8) 
/
insert into HtmlLabelInfo values(559,'屏蔽检查',7) 
/
insert into HtmlLabelInfo values(560,'OtherInfoType',8) 
/
insert into HtmlLabelInfo values(560,'其他信息类型',7) 
/
insert into HtmlLabelInfo values(561,'Parameter',8) 
/
insert into HtmlLabelInfo values(561,'参数',7) 
/
insert into HtmlLabelInfo values(562,'Organization chart',8) 
/
insert into HtmlLabelInfo values(562,'组织图表',7) 
/
insert into HtmlLabelInfo values(563,'Data',8) 
/
insert into HtmlLabelInfo values(563,'数据',7) 
/
insert into HtmlLabelInfo values(564,'Indicator',8) 
/
insert into HtmlLabelInfo values(564,'指示器',7) 
/
insert into HtmlLabelInfo values(565,'FIE',8) 
/
insert into HtmlLabelInfo values(565,'工作时间参数',7) 
/
insert into HtmlLabelInfo values(566,'Revenue',8) 
/
insert into HtmlLabelInfo values(566,'收入',7) 
/
insert into HtmlLabelInfo values(567,'Scenario',8) 
/
insert into HtmlLabelInfo values(567,'版本',7) 
/
insert into HtmlLabelInfo values(568,'Abbreviation',8) 
/
insert into HtmlLabelInfo values(568,'缩写',7) 
/
insert into HtmlLabelInfo values(569,'Contact Way',8) 
/
insert into HtmlLabelInfo values(569,'联系方法',7) 
/
insert into HtmlLabelInfo values(570,'Free Field',8) 
/
insert into HtmlLabelInfo values(570,'其他信息',7) 
/
insert into HtmlLabelInfo values(571,'Account',8) 
/
insert into HtmlLabelInfo values(571,'帐户',7) 
/
insert into HtmlLabelInfo values(572,'Contacter',8) 
/
insert into HtmlLabelInfo values(572,'联系人',7) 
/
insert into HtmlLabelInfo values(573,'Delivery Methods',8) 
/
insert into HtmlLabelInfo values(573,'送货类型',7) 
/
insert into HtmlLabelInfo values(574,'Marketing',8) 
/
insert into HtmlLabelInfo values(574,'分类信息',7) 
/
insert into HtmlLabelInfo values(575,'Sector',8) 
/
insert into HtmlLabelInfo values(575,'行业',7) 
/
insert into HtmlLabelInfo values(576,'Sizes',8) 
/
insert into HtmlLabelInfo values(576,'规模',7) 
/
insert into HtmlLabelInfo values(577,'Payment Way',8) 
/
insert into HtmlLabelInfo values(577,'支付方式',7) 
/
insert into HtmlLabelInfo values(578,'Classification ',8) 
/
insert into HtmlLabelInfo values(578,'分级',7) 
/
insert into HtmlLabelInfo values(579,'Rules',8) 
/
insert into HtmlLabelInfo values(579,'规则',7) 
/
insert into HtmlLabelInfo values(580,'Credit Level',8) 
/
insert into HtmlLabelInfo values(580,'信用等级',7) 
/
insert into HtmlLabelInfo values(581,'累计合同金额',7) 
/
insert into HtmlLabelInfo values(581,'累计合同金额',8) 
/
insert into HtmlLabelInfo values(582,'Portal',8) 
/
insert into HtmlLabelInfo values(582,'门户',7) 
/
insert into HtmlLabelInfo values(583,'Prefix',8) 
/
insert into HtmlLabelInfo values(583,'前缀',7) 
/
insert into HtmlLabelInfo values(584,'Postfix',8) 
/
insert into HtmlLabelInfo values(584,'后缀',7) 
/
insert into HtmlLabelInfo values(585,'Ledger',8) 
/
insert into HtmlLabelInfo values(585,'科目',7) 
/
insert into HtmlLabelInfo values(586,'Project Type',8) 
/
insert into HtmlLabelInfo values(586,'项目类型',7) 
/
insert into HtmlLabelInfo values(587,'Project Status',8) 
/
insert into HtmlLabelInfo values(587,'项目状态',7) 
/
insert into HtmlLabelInfo values(588,'Exchange rate',8) 
/
insert into HtmlLabelInfo values(588,'汇率',7) 
/
insert into HtmlLabelInfo values(589,'Reset',8) 
/
insert into HtmlLabelInfo values(589,'还原',7) 
/
insert into HtmlLabelInfo values(590,'Code',8) 
/
insert into HtmlLabelInfo values(590,'代码',7) 
/
insert into HtmlLabelInfo values(591,'上级单位',7) 
/
insert into HtmlLabelInfo values(591,'上级单位',8) 
/
insert into HtmlLabelInfo values(593,'等级名称',7) 
/
insert into HtmlLabelInfo values(593,'等级名称',8) 
/
insert into HtmlLabelInfo values(594,'上限',7) 
/
insert into HtmlLabelInfo values(594,'上限',8) 
/
insert into HtmlLabelInfo values(595,'下限',7) 
/
insert into HtmlLabelInfo values(595,'下限',8) 
/
insert into HtmlLabelInfo values(596,'Superior',8) 
/
insert into HtmlLabelInfo values(596,'上级',7) 
/
insert into HtmlLabelInfo values(597,'Delivery',8) 
/
insert into HtmlLabelInfo values(597,'送货',7) 
/
insert into HtmlLabelInfo values(598,'Send',8) 
/
insert into HtmlLabelInfo values(598,'发货',7) 
/
insert into HtmlLabelInfo values(599,'Term',8) 
/
insert into HtmlLabelInfo values(599,'方式',7) 
/
insert into HtmlLabelInfo values(600,'Ship',8) 
/
insert into HtmlLabelInfo values(600,'运货',7) 
/
insert into HtmlLabelInfo values(601,'Receive',8) 
/
insert into HtmlLabelInfo values(601,'收货',7) 
/
insert into HtmlLabelInfo values(602,'Status',8) 
/
insert into HtmlLabelInfo values(602,'状态',7) 
/
insert into HtmlLabelInfo values(603,'Level',8) 
/
insert into HtmlLabelInfo values(603,'等级',7) 
/
insert into HtmlLabelInfo values(604,'Method',8) 
/
insert into HtmlLabelInfo values(604,'方法',7) 
/
insert into HtmlLabelInfo values(605,'SecVocation',8) 
/
insert into HtmlLabelInfo values(605,'子行业',7) 
/
insert into HtmlLabelInfo values(606,'Label',8) 
/
insert into HtmlLabelInfo values(606,'显示名',7) 
/
insert into HtmlLabelInfo values(607,'Number',8) 
/
insert into HtmlLabelInfo values(607,'数字',7) 
/
insert into HtmlLabelInfo values(608,'Text',8) 
/
insert into HtmlLabelInfo values(608,'文本',7) 
/
insert into HtmlLabelInfo values(609,'YesNo',8) 
/
insert into HtmlLabelInfo values(609,'判断',7) 
/
insert into HtmlLabelInfo values(610,'Project Card',8) 
/
insert into HtmlLabelInfo values(610,'项目卡',7) 
/
insert into HtmlLabelInfo values(611,'Add',8) 
/
insert into HtmlLabelInfo values(611,'添加',7) 
/
insert into HtmlLabelInfo values(612,'Name',8) 
/
insert into HtmlLabelInfo values(612,'名',7) 
/
insert into HtmlLabelInfo values(613,'Original',8) 
/
insert into HtmlLabelInfo values(613,'原始',7) 
/
insert into HtmlLabelInfo values(614,'Contract',8) 
/
insert into HtmlLabelInfo values(614,'合同',7) 
/
insert into HtmlLabelInfo values(615,'Submit',8) 
/
insert into HtmlLabelInfo values(615,'提交',7) 
/
insert into HtmlLabelInfo values(616,'Submiter',8) 
/
insert into HtmlLabelInfo values(616,'提交人',7) 
/
insert into HtmlLabelInfo values(617,'End Date',8) 
/
insert into HtmlLabelInfo values(617,'终止日',7) 
/
insert into HtmlLabelInfo values(618,'Modify Log',8) 
/
insert into HtmlLabelInfo values(618,'修改记录',7) 
/
insert into HtmlLabelInfo values(619,'Home',8) 
/
insert into HtmlLabelInfo values(619,'住宅',7) 
/
insert into HtmlLabelInfo values(620,'Mobile Telephone',8) 
/
insert into HtmlLabelInfo values(620,'移动电话',7) 
/
insert into HtmlLabelInfo values(621,'Contact',8) 
/
insert into HtmlLabelInfo values(621,'联系',7) 
/
insert into HtmlLabelInfo values(622,'Log',8) 
/
insert into HtmlLabelInfo values(622,'情况',7) 
/
insert into HtmlLabelInfo values(623,'By',8) 
/
insert into HtmlLabelInfo values(623,'由',7) 
/
insert into HtmlLabelInfo values(624,'Member Only',8) 
/
insert into HtmlLabelInfo values(624,'成员可见',7) 
/
insert into HtmlLabelInfo values(625,'Whether customer is passive',8) 
/
insert into HtmlLabelInfo values(625,'是否客户主动',7) 
/
insert into HtmlLabelInfo values(626,'Manager View',8) 
/
insert into HtmlLabelInfo values(626,'成员上级可见',7) 
/
insert into HtmlLabelInfo values(627,'Parent View',8) 
/
insert into HtmlLabelInfo values(627,'上级成员可见',7) 
/
insert into HtmlLabelInfo values(628,'True',8) 
/
insert into HtmlLabelInfo values(628,'实际',7) 
/
insert into HtmlLabelInfo values(629,'Expense',8) 
/
insert into HtmlLabelInfo values(629,'支出',7) 
/
insert into HtmlLabelInfo values(630,'Operation',8) 
/
insert into HtmlLabelInfo values(630,'业务',7) 
/
insert into HtmlLabelInfo values(631,'Complain',8) 
/
insert into HtmlLabelInfo values(631,'抱怨',7) 
/
insert into HtmlLabelInfo values(632,'Human Hour',8) 
/
insert into HtmlLabelInfo values(632,'工时',7) 
/
insert into HtmlLabelInfo values(633,'Management',8) 
/
insert into HtmlLabelInfo values(633,'管理',7) 
/
insert into HtmlLabelInfo values(634,'Intro',8) 
/
insert into HtmlLabelInfo values(634,'介绍',7) 
/
insert into HtmlLabelInfo values(635,'Passive',8) 
/
insert into HtmlLabelInfo values(635,'被动',7) 
/
insert into HtmlLabelInfo values(636,'Parent Project',8) 
/
insert into HtmlLabelInfo values(636,'上级项目',7) 
/
insert into HtmlLabelInfo values(637,'Evaluate Doc',8) 
/
insert into HtmlLabelInfo values(637,'评价书',7) 
/
insert into HtmlLabelInfo values(638,'Confirm Doc',8) 
/
insert into HtmlLabelInfo values(638,'确认书',7) 
/
insert into HtmlLabelInfo values(639,'Propose Doc',8) 
/
insert into HtmlLabelInfo values(639,'建议书',7) 
/
insert into HtmlLabelInfo values(640,'Job Title',8) 
/
insert into HtmlLabelInfo values(640,'工作头衔',7) 
/
insert into HtmlLabelInfo values(642,'English',8) 
/
insert into HtmlLabelInfo values(642,'英文',7) 
/
insert into HtmlLabelInfo values(643,'Province',8) 
/
insert into HtmlLabelInfo values(643,'省',7) 
/
insert into HtmlLabelInfo values(644,'County',8) 
/
insert into HtmlLabelInfo values(644,'县',7) 
/
insert into HtmlLabelInfo values(645,'Source',8) 
/
insert into HtmlLabelInfo values(645,'获得途径',7) 
/
insert into HtmlLabelInfo values(646,'Sales Confirm Book',8) 
/
insert into HtmlLabelInfo values(646,'销售确认书',7) 
/
insert into HtmlLabelInfo values(647,'Card',8) 
/
insert into HtmlLabelInfo values(647,'卡',7) 
/
insert into HtmlLabelInfo values(648,'Request',8) 
/
insert into HtmlLabelInfo values(648,'请求',7) 
/
insert into HtmlLabelInfo values(649,'Currency',8) 
/
insert into HtmlLabelInfo values(649,'货币',7) 
/
insert into HtmlLabelInfo values(650,'Credit Salary Modify',8) 
/
insert into HtmlLabelInfo values(650,'信用金额修正',7) 
/
insert into HtmlLabelInfo values(651,'Discount Rate',8) 
/
insert into HtmlLabelInfo values(651,'折扣率',7) 
/
insert into HtmlLabelInfo values(652,'Payment Type',8) 
/
insert into HtmlLabelInfo values(652,'支付类型',7) 
/
insert into HtmlLabelInfo values(653,'增值税号码',7) 
/
insert into HtmlLabelInfo values(653,'增值税号码',8) 
/
insert into HtmlLabelInfo values(654,'Bank Account',8) 
/
insert into HtmlLabelInfo values(654,'银行帐户',7) 
/
insert into HtmlLabelInfo values(655,'Invoice Customer',8) 
/
insert into HtmlLabelInfo values(655,'发票客户',7) 
/
insert into HtmlLabelInfo values(657,'Delivery Type',8) 
/
insert into HtmlLabelInfo values(657,'交货方法',7) 
/
insert into HtmlLabelInfo values(658,'Payment Term',8) 
/
insert into HtmlLabelInfo values(658,'支付条件',7) 
/
insert into HtmlLabelInfo values(659,'Type Since',8) 
/
insert into HtmlLabelInfo values(659,'类型从',7) 
/
insert into HtmlLabelInfo values(660,'Fullname',8) 
/
insert into HtmlLabelInfo values(660,'全名',7) 
/
insert into HtmlLabelInfo values(661,'Office Telephone',8) 
/
insert into HtmlLabelInfo values(661,'办公室电话',7) 
/
insert into HtmlLabelInfo values(662,'Home Telephone',8) 
/
insert into HtmlLabelInfo values(662,'住宅电话',7) 
/
insert into HtmlLabelInfo values(663,'Entries',8) 
/
insert into HtmlLabelInfo values(663,'分录',7) 
/
insert into HtmlLabelInfo values(664,'Process',8) 
/
insert into HtmlLabelInfo values(664,'登帐',7) 
/
insert into HtmlLabelInfo values(665,'Watch',8) 
/
insert into HtmlLabelInfo values(665,'监控',7) 
/
insert into HtmlLabelInfo values(666,'G/L',8) 
/
insert into HtmlLabelInfo values(666,'总分类帐',7) 
/
insert into HtmlLabelInfo values(667,'G/L',8) 
/
insert into HtmlLabelInfo values(667,'明细帐',7) 
/
insert into HtmlLabelInfo values(668,'Analyze',8) 
/
insert into HtmlLabelInfo values(668,'分析',7) 
/
insert into HtmlLabelInfo values(669,'level',8) 
/
insert into HtmlLabelInfo values(669,'层次',7) 
/
insert into HtmlLabelInfo values(670,'leave',8) 
/
insert into HtmlLabelInfo values(670,'请假',7) 
/
insert into HtmlLabelInfo values(671,'age',8) 
/
insert into HtmlLabelInfo values(671,'年龄',7) 
/
insert into HtmlLabelInfo values(672,'FlowIn',8) 
/
insert into HtmlLabelInfo values(672,'流入',7) 
/
insert into HtmlLabelInfo values(673,'FlowOut',8) 
/
insert into HtmlLabelInfo values(673,'流出',7) 
/
insert into HtmlLabelInfo values(674,'login',8) 
/
insert into HtmlLabelInfo values(674,'登录',7) 
/
insert into HtmlLabelInfo values(675,'review',8) 
/
insert into HtmlLabelInfo values(675,'评论',7) 
/
insert into HtmlLabelInfo values(676,'curve',8) 
/
insert into HtmlLabelInfo values(676,'工作活动图表',7) 
/
insert into HtmlLabelInfo values(677,'mailmerge',8) 
/
insert into HtmlLabelInfo values(677,'邮件合并',7) 
/
insert into HtmlLabelInfo values(678,'activity',8) 
/
insert into HtmlLabelInfo values(678,'活动',7) 
/
insert into HtmlLabelInfo values(679,'recent',8) 
/
insert into HtmlLabelInfo values(679,'近期',7) 
/
insert into HtmlLabelInfo values(680,'stock',8) 
/
insert into HtmlLabelInfo values(680,'期权',7) 
/
insert into HtmlLabelInfo values(681,'Insert Images',8) 
/
insert into HtmlLabelInfo values(681,'插入图片',7) 
/
insert into HtmlLabelInfo values(682,'Logistics',8) 
/
insert into HtmlLabelInfo values(682,'后勤',7) 
/
insert into HtmlLabelInfo values(683,'SecurityLevel',8) 
/
insert into HtmlLabelInfo values(683,'安全级别',7) 
/
insert into HtmlLabelInfo values(684,'FieldManage',8) 
/
insert into HtmlLabelInfo values(684,'字段管理',7) 
/
insert into HtmlLabelInfo values(685,'FieldName',8) 
/
insert into HtmlLabelInfo values(685,'字段名称',7) 
/
insert into HtmlLabelInfo values(686,'FieldType',8) 
/
insert into HtmlLabelInfo values(686,'字段类型',7) 
/
insert into HtmlLabelInfo values(687,'ShowType',8) 
/
insert into HtmlLabelInfo values(687,'表现形式',7) 
/
insert into HtmlLabelInfo values(688,'SingleLineText',8) 
/
insert into HtmlLabelInfo values(688,'单行文本框',7) 
/
insert into HtmlLabelInfo values(689,'MultiLineText',8) 
/
insert into HtmlLabelInfo values(689,'多行文本框',7) 
/
insert into HtmlLabelInfo values(690,'SelectCombo',8) 
/
insert into HtmlLabelInfo values(690,'选择框',7) 
/
insert into HtmlLabelInfo values(691,'CheckCombo',8) 
/
insert into HtmlLabelInfo values(691,'Check框',7) 
/
insert into HtmlLabelInfo values(694,'SelectAll',8) 
/
insert into HtmlLabelInfo values(694,'全部选择',7) 
/
insert into HtmlLabelInfo values(695,'BrowserButton',8) 
/
insert into HtmlLabelInfo values(695,'浏览按钮',7) 
/
insert into HtmlLabelInfo values(696,'Int',8) 
/
insert into HtmlLabelInfo values(696,'整数',7) 
/
insert into HtmlLabelInfo values(697,'Float',8) 
/
insert into HtmlLabelInfo values(697,'浮点数',7) 
/
insert into HtmlLabelInfo values(698,'StrLength',8) 
/
insert into HtmlLabelInfo values(698,'文本长度',7) 
/
insert into HtmlLabelInfo values(699,'FormManage',8) 
/
insert into HtmlLabelInfo values(699,'表单管理',7) 
/
insert into HtmlLabelInfo values(700,'Form',8) 
/
insert into HtmlLabelInfo values(700,'表单',7) 
/
insert into HtmlLabelInfo values(701,'AddField',8) 
/
insert into HtmlLabelInfo values(701,'增加字段',7) 
/
insert into HtmlLabelInfo values(702,'DeleteField',8) 
/
insert into HtmlLabelInfo values(702,'删除字段',7) 
/
insert into HtmlLabelInfo values(703,'Asset Type',8) 
/
insert into HtmlLabelInfo values(703,'资产类型',7) 
/
insert into HtmlLabelInfo values(704,'Asset Assortment',8) 
/
insert into HtmlLabelInfo values(704,'资产种类',7) 
/
insert into HtmlLabelInfo values(705,'Measure unit ',8) 
/
insert into HtmlLabelInfo values(705,'计量单位',7) 
/
insert into HtmlLabelInfo values(706,'Asset Relation Type',8) 
/
insert into HtmlLabelInfo values(706,'配置类型',7) 
/
insert into HtmlLabelInfo values(707,'Account Type',8) 
/
insert into HtmlLabelInfo values(707,'核算方法',7) 
/
insert into HtmlLabelInfo values(708,'Order',8) 
/
insert into HtmlLabelInfo values(708,'订货单',7) 
/
insert into HtmlLabelInfo values(709,'Sales Order',8) 
/
insert into HtmlLabelInfo values(709,'出货单',7) 
/
insert into HtmlLabelInfo values(710,'Payment Type',8) 
/
insert into HtmlLabelInfo values(710,'收付款方式',7) 
/
insert into HtmlLabelInfo values(711,'Warehouse',8) 
/
insert into HtmlLabelInfo values(711,'仓库',7) 
/
insert into HtmlLabelInfo values(712,'Stock flowmode',8) 
/
insert into HtmlLabelInfo values(712,'进出库方式',7) 
/
insert into HtmlLabelInfo values(713,'Attribute',8) 
/
insert into HtmlLabelInfo values(713,'属性',7) 
/
insert into HtmlLabelInfo values(714,'mark',8) 
/
insert into HtmlLabelInfo values(714,'编号',7) 
/
insert into HtmlLabelInfo values(715,'Change Mark',8) 
/
insert into HtmlLabelInfo values(715,'重新编号',7) 
/
insert into HtmlLabelInfo values(716,'Assortment',8) 
/
insert into HtmlLabelInfo values(716,'种类',7) 
/
insert into HtmlLabelInfo values(717,'Validy date',8) 
/
insert into HtmlLabelInfo values(717,'生效日',7) 
/
insert into HtmlLabelInfo values(718,'End date',8) 
/
insert into HtmlLabelInfo values(718,'生效至',7) 
/
insert into HtmlLabelInfo values(719,'Cost price',8) 
/
insert into HtmlLabelInfo values(719,'成本价格',7) 
/
insert into HtmlLabelInfo values(720,'Purchase price',8) 
/
insert into HtmlLabelInfo values(720,'采购价',7) 
/
insert into HtmlLabelInfo values(721,'Sales price',8) 
/
insert into HtmlLabelInfo values(721,'销售价',7) 
/
insert into HtmlLabelInfo values(722,'Create date',8) 
/
insert into HtmlLabelInfo values(722,'创建日期',7) 
/
insert into HtmlLabelInfo values(723,'Modify date',8) 
/
insert into HtmlLabelInfo values(723,'修改日期',7) 
/
insert into HtmlLabelInfo values(724,'Relation',8) 
/
insert into HtmlLabelInfo values(724,'配置',7) 
/
insert into HtmlLabelInfo values(725,'Realize',8) 
/
insert into HtmlLabelInfo values(725,'提交',7) 
/
insert into HtmlLabelInfo values(726,'Price',8) 
/
insert into HtmlLabelInfo values(726,'价格',7) 
/
insert into HtmlLabelInfo values(727,'Shop basket',8) 
/
insert into HtmlLabelInfo values(727,'购物车',7) 
/
insert into HtmlLabelInfo values(728,'appertain',8) 
/
insert into HtmlLabelInfo values(728,'附属',7) 
/
insert into HtmlLabelInfo values(729,'relation',8) 
/
insert into HtmlLabelInfo values(729,'关系',7) 
/
insert into HtmlLabelInfo values(730,'View',8) 
/
insert into HtmlLabelInfo values(730,'读取',7) 
/
insert into HtmlLabelInfo values(731,'User Info',8) 
/
insert into HtmlLabelInfo values(731,'用户信息',7) 
/
insert into HtmlLabelInfo values(732,'Pending',8) 
/
insert into HtmlLabelInfo values(732,'未完成',7) 
/
insert into HtmlLabelInfo values(733,'EndDate',8) 
/
insert into HtmlLabelInfo values(733,'结束日',7) 
/
insert into HtmlLabelInfo values(734,'QualityAnylize',8) 
/
insert into HtmlLabelInfo values(734,'质量分析',7) 
/
insert into HtmlLabelInfo values(735,'Websales order',8) 
/
insert into HtmlLabelInfo values(735,'网上订单',7) 
/
insert into HtmlLabelInfo values(736,'Balances Sheet',8) 
/
insert into HtmlLabelInfo values(736,'资产负债表',7) 
/
insert into HtmlLabelInfo values(737,'Active',8) 
/
insert into HtmlLabelInfo values(737,'激活',7) 
/
insert into HtmlLabelInfo values(738,'资产购置计划',7) 
/
insert into HtmlLabelInfo values(738,'资产购置计划',8) 
/
insert into HtmlLabelInfo values(739,'Asset stock ',8) 
/
insert into HtmlLabelInfo values(739,'库存信息',7) 
/
insert into HtmlLabelInfo values(740,'Start Date',8) 
/
insert into HtmlLabelInfo values(740,'开始日期',7) 
/
insert into HtmlLabelInfo values(741,'End Date',8) 
/
insert into HtmlLabelInfo values(741,'结束日期',7) 
/
insert into HtmlLabelInfo values(742,'Start Time',8) 
/
insert into HtmlLabelInfo values(742,'开始时间',7) 
/
insert into HtmlLabelInfo values(743,'End Time',8) 
/
insert into HtmlLabelInfo values(743,'结束时间',7) 
/
insert into HtmlLabelInfo values(744,'P&amp;L Sheet',8) 
/
insert into HtmlLabelInfo values(744,'损益表',7) 
/
insert into HtmlLabelInfo values(745,'Buyer',8) 
/
insert into HtmlLabelInfo values(745,'买方',7) 
/
insert into HtmlLabelInfo values(746,'Seller',8) 
/
insert into HtmlLabelInfo values(746,'卖方',7) 
/
insert into HtmlLabelInfo values(747,'Asset stock',8) 
/
insert into HtmlLabelInfo values(747,'库存',7) 
/
insert into HtmlLabelInfo values(748,'Stock inout Detail',8) 
/
insert into HtmlLabelInfo values(748,'出入库详细',7) 
/
insert into HtmlLabelInfo values(749,'出入库单据',7) 
/
insert into HtmlLabelInfo values(749,'出入库单据',8) 
/
insert into HtmlLabelInfo values(750,'出库单',7) 
/
insert into HtmlLabelInfo values(750,'出库单',8) 
/
insert into HtmlLabelInfo values(751,'入库单',7) 
/
insert into HtmlLabelInfo values(751,'入库单',8) 
/
insert into HtmlLabelInfo values(752,'入库单编号',7) 
/
insert into HtmlLabelInfo values(752,'入库单编号',8) 
/
insert into HtmlLabelInfo values(753,'入库日期',7) 
/
insert into HtmlLabelInfo values(753,'入库日期',8) 
/
insert into HtmlLabelInfo values(754,'入库方式',7) 
/
insert into HtmlLabelInfo values(754,'入库方式',8) 
/
insert into HtmlLabelInfo values(755,'入库单据',7) 
/
insert into HtmlLabelInfo values(755,'入库单据',8) 
/
insert into HtmlLabelInfo values(756,'出库单编号 ',7) 
/
insert into HtmlLabelInfo values(756,'出库单编号 ',8) 
/
insert into HtmlLabelInfo values(757,'默认币种',7) 
/
insert into HtmlLabelInfo values(757,'默认币种',8) 
/
insert into HtmlLabelInfo values(758,'默认币种进库总价',7) 
/
insert into HtmlLabelInfo values(758,'默认币种进库总价',8) 
/
insert into HtmlLabelInfo values(759,'默认币种进库总税额',7) 
/
insert into HtmlLabelInfo values(759,'默认币种进库总税额',8) 
/
insert into HtmlLabelInfo values(760,'进库总价',7) 
/
insert into HtmlLabelInfo values(760,'进库总价',8) 
/
insert into HtmlLabelInfo values(761,'进库总税额',7) 
/
insert into HtmlLabelInfo values(761,'进库总税额',8) 
/
insert into HtmlLabelInfo values(762,'出库方式 ',7) 
/
insert into HtmlLabelInfo values(762,'出库方式 ',8) 
/
insert into HtmlLabelInfo values(763,'Not confine',8) 
/
insert into HtmlLabelInfo values(763,'不限',7) 
/
insert into HtmlLabelInfo values(764,'High school',8) 
/
insert into HtmlLabelInfo values(764,'高中',7) 
/
insert into HtmlLabelInfo values(765,'technical secondary school ',8) 
/
insert into HtmlLabelInfo values(765,'中专',7) 
/
insert into HtmlLabelInfo values(766,'junior college ',8) 
/
insert into HtmlLabelInfo values(766,'大专',7) 
/
insert into HtmlLabelInfo values(767,'undergraduate course ',8) 
/
insert into HtmlLabelInfo values(767,'本科',7) 
/
insert into HtmlLabelInfo values(768,'master degree',8) 
/
insert into HtmlLabelInfo values(768,'硕士研究生',7) 
/
insert into HtmlLabelInfo values(769,'doctor\''s degree',8) 
/
insert into HtmlLabelInfo values(769,'博士研究生',7) 
/
insert into HtmlLabelInfo values(770,'出库日期',7) 
/
insert into HtmlLabelInfo values(770,'出库日期',8) 
/
insert into HtmlLabelInfo values(771,'合同编号 ',7) 
/
insert into HtmlLabelInfo values(771,'合同编号 ',8) 
/
insert into HtmlLabelInfo values(772,'Document Move',8) 
/
insert into HtmlLabelInfo values(772,'文档移动',7) 
/
insert into HtmlLabelInfo values(773,'Career apply information',8) 
/
insert into HtmlLabelInfo values(773,'应聘信息',7) 
/
insert into HtmlLabelInfo values(774,'System Set',8) 
/
insert into HtmlLabelInfo values(774,'系统设置',7) 
/
insert into HtmlLabelInfo values(775,'System Log',8) 
/
insert into HtmlLabelInfo values(775,'系统日志',7) 
/
insert into HtmlLabelInfo values(776,'',8) 
/
insert into HtmlLabelInfo values(776,'重建数据库',7) 
/
insert into HtmlLabelInfo values(777,'',8) 
/
insert into HtmlLabelInfo values(777,'科目－全部',7) 
/
insert into HtmlLabelInfo values(778,'',8) 
/
insert into HtmlLabelInfo values(778,'科目－明细',7) 
/
insert into HtmlLabelInfo values(779,'',8) 
/
insert into HtmlLabelInfo values(779,'会议室联系单',7) 
/
insert into HtmlLabelInfo values(780,'',8) 
/
insert into HtmlLabelInfo values(780,'会议室',7) 
/
insert into HtmlLabelInfo values(781,'',8) 
/
insert into HtmlLabelInfo values(781,'会议人数',7) 
/
insert into HtmlLabelInfo values(782,'',8) 
/
insert into HtmlLabelInfo values(782,'相关项目',7) 
/
insert into HtmlLabelInfo values(783,'',8) 
/
insert into HtmlLabelInfo values(783,'相关客户',7) 
/
insert into HtmlLabelInfo values(784,'',8) 
/
insert into HtmlLabelInfo values(784,'提醒日期',7) 
/
insert into HtmlLabelInfo values(785,'',8) 
/
insert into HtmlLabelInfo values(785,'提醒时间',7) 
/
insert into HtmlLabelInfo values(786,'',8) 
/
insert into HtmlLabelInfo values(786,'个人计划',7) 
/
insert into HtmlLabelInfo values(787,'',8) 
/
insert into HtmlLabelInfo values(787,'提交人',7) 
/
insert into HtmlLabelInfo values(788,'',8) 
/
insert into HtmlLabelInfo values(788,'费用报销单',7) 
/
insert into HtmlLabelInfo values(789,'',8) 
/
insert into HtmlLabelInfo values(789,'报销人',7) 
/
insert into HtmlLabelInfo values(790,'',8) 
/
insert into HtmlLabelInfo values(790,'报销日期',7) 
/
insert into HtmlLabelInfo values(791,'',8) 
/
insert into HtmlLabelInfo values(791,'事由',7) 
/
insert into HtmlLabelInfo values(792,'',8) 
/
insert into HtmlLabelInfo values(792,'相关人员',7) 
/
insert into HtmlLabelInfo values(793,'',8) 
/
insert into HtmlLabelInfo values(793,'相关请求',7) 
/
insert into HtmlLabelInfo values(794,'',8) 
/
insert into HtmlLabelInfo values(794,'报销总金额',7) 
/
insert into HtmlLabelInfo values(795,'',8) 
/
insert into HtmlLabelInfo values(795,'附件总数',7) 
/
insert into HtmlLabelInfo values(796,'',8) 
/
insert into HtmlLabelInfo values(796,'借方科目',7) 
/
insert into HtmlLabelInfo values(797,'',8) 
/
insert into HtmlLabelInfo values(797,'借方摘要',7) 
/
insert into HtmlLabelInfo values(798,'',8) 
/
insert into HtmlLabelInfo values(798,'贷方科目',7) 
/
insert into HtmlLabelInfo values(799,'',8) 
/
insert into HtmlLabelInfo values(799,'贷方摘要',7) 
/
insert into HtmlLabelInfo values(800,'',8) 
/
insert into HtmlLabelInfo values(800,'省份',7) 
/
insert into HtmlLabelInfo values(801,'',8) 
/
insert into HtmlLabelInfo values(801,'经度',7) 
/
insert into HtmlLabelInfo values(802,'',8) 
/
insert into HtmlLabelInfo values(802,'纬度',7) 
/
insert into HtmlLabelInfo values(803,'',8) 
/
insert into HtmlLabelInfo values(803,'专业',7) 
/
insert into HtmlLabelInfo values(804,'',8) 
/
insert into HtmlLabelInfo values(804,'用工性质',7) 
/
insert into HtmlLabelInfo values(805,'',8) 
/
insert into HtmlLabelInfo values(805,'职务类别',7) 
/
insert into HtmlLabelInfo values(806,'职称',7) 
/
insert into HtmlLabelInfo values(806,'职称',8) 
/
insert into HtmlLabelInfo values(807,'',8) 
/
insert into HtmlLabelInfo values(807,'培训类型',7) 
/
insert into HtmlLabelInfo values(808,'',8) 
/
insert into HtmlLabelInfo values(808,'奖惩类型',7) 
/
insert into HtmlLabelInfo values(809,'',8) 
/
insert into HtmlLabelInfo values(809,'奖励',7) 
/
insert into HtmlLabelInfo values(810,'',8) 
/
insert into HtmlLabelInfo values(810,'惩罚',7) 
/
insert into HtmlLabelInfo values(811,'',8) 
/
insert into HtmlLabelInfo values(811,'其它',7) 
/
insert into HtmlLabelInfo values(812,'',8) 
/
insert into HtmlLabelInfo values(812,'工作简历',7) 
/
insert into HtmlLabelInfo values(813,'',8) 
/
insert into HtmlLabelInfo values(813,'教育情况',7) 
/
insert into HtmlLabelInfo values(814,'',8) 
/
insert into HtmlLabelInfo values(814,'家庭情况',7) 
/
insert into HtmlLabelInfo values(815,'',8) 
/
insert into HtmlLabelInfo values(815,'语言能力',7) 
/
insert into HtmlLabelInfo values(816,'',8) 
/
insert into HtmlLabelInfo values(816,'培训记录',7) 
/
insert into HtmlLabelInfo values(817,'奖惩记录',7) 
/
insert into HtmlLabelInfo values(817,'奖惩记录',8) 
/
insert into HtmlLabelInfo values(818,'',8) 
/
insert into HtmlLabelInfo values(818,'学历',7) 
/
insert into HtmlLabelInfo values(819,'',8) 
/
insert into HtmlLabelInfo values(819,'初中',7) 
/
insert into HtmlLabelInfo values(820,'',8) 
/
insert into HtmlLabelInfo values(820,'中技',7) 
/
insert into HtmlLabelInfo values(821,'',8) 
/
insert into HtmlLabelInfo values(821,'良好',7) 
/
insert into HtmlLabelInfo values(822,'',8) 
/
insert into HtmlLabelInfo values(822,'熟练',7) 
/
insert into HtmlLabelInfo values(823,'',8) 
/
insert into HtmlLabelInfo values(823,'精通',7) 
/
insert into HtmlLabelInfo values(824,'',8) 
/
insert into HtmlLabelInfo values(824,'优秀',7) 
/
insert into HtmlLabelInfo values(825,'',7) 
/
insert into HtmlLabelInfo values(825,'',8) 
/
insert into HtmlLabelInfo values(826,'',8) 
/
insert into HtmlLabelInfo values(826,'确定',7) 
/
insert into HtmlLabelInfo values(827,'',8) 
/
insert into HtmlLabelInfo values(827,'请假人',7) 
/
insert into HtmlLabelInfo values(828,'',8) 
/
insert into HtmlLabelInfo values(828,'请假天数',7) 
/
insert into HtmlLabelInfo values(829,'',8) 
/
insert into HtmlLabelInfo values(829,'请假单',7) 
/
insert into HtmlLabelInfo values(830,'',8) 
/
insert into HtmlLabelInfo values(830,'资产状态',7) 
/
insert into HtmlLabelInfo values(831,'',8) 
/
insert into HtmlLabelInfo values(831,'资产组',7) 
/
insert into HtmlLabelInfo values(832,'',8) 
/
insert into HtmlLabelInfo values(832,'子资产组',7) 
/
insert into HtmlLabelInfo values(833,'',8) 
/
insert into HtmlLabelInfo values(833,'培训学时',7) 
/
insert into HtmlLabelInfo values(834,'',8) 
/
insert into HtmlLabelInfo values(834,'培训人数',7) 
/
insert into HtmlLabelInfo values(835,'',8) 
/
insert into HtmlLabelInfo values(835,'折旧法一',7) 
/
insert into HtmlLabelInfo values(836,'',8) 
/
insert into HtmlLabelInfo values(836,'折旧法二',7) 
/
insert into HtmlLabelInfo values(837,'',8) 
/
insert into HtmlLabelInfo values(837,'资产折旧法',7) 
/
insert into HtmlLabelInfo values(838,'',8) 
/
insert into HtmlLabelInfo values(838,'联系实施人',7) 
/
insert into HtmlLabelInfo values(839,'',8) 
/
insert into HtmlLabelInfo values(839,'多人力资源',7) 
/
insert into HtmlLabelInfo values(840,'',8) 
/
insert into HtmlLabelInfo values(840,'多客户',7) 
/
insert into HtmlLabelInfo values(841,'',8) 
/
insert into HtmlLabelInfo values(841,'项目计划',7) 
/
insert into HtmlLabelInfo values(842,'',8) 
/
insert into HtmlLabelInfo values(842,'计划类型',7) 
/
insert into HtmlLabelInfo values(843,'',8) 
/
insert into HtmlLabelInfo values(843,'计划种类',7) 
/
insert into HtmlLabelInfo values(844,'',8) 
/
insert into HtmlLabelInfo values(844,'参考文档',7) 
/
insert into HtmlLabelInfo values(845,'',8) 
/
insert into HtmlLabelInfo values(845,'预算金额',7) 
/
insert into HtmlLabelInfo values(846,'',8) 
/
insert into HtmlLabelInfo values(846,'子项目',7) 
/
insert into HtmlLabelInfo values(847,'',8) 
/
insert into HtmlLabelInfo values(847,'进度',7) 
/
insert into HtmlLabelInfo values(848,'',8) 
/
insert into HtmlLabelInfo values(848,'重要性',7) 
/
insert into HtmlLabelInfo values(849,'',8) 
/
insert into HtmlLabelInfo values(849,'加班申请',7) 
/
insert into HtmlLabelInfo values(850,'',8) 
/
insert into HtmlLabelInfo values(850,'加班人',7) 
/
insert into HtmlLabelInfo values(851,'',8) 
/
insert into HtmlLabelInfo values(851,'加班原因',7) 
/
insert into HtmlLabelInfo values(852,'',8) 
/
insert into HtmlLabelInfo values(852,'总天数',7) 
/
insert into HtmlLabelInfo values(853,'',8) 
/
insert into HtmlLabelInfo values(853,'总小时数',7) 
/
insert into HtmlLabelInfo values(854,'',8) 
/
insert into HtmlLabelInfo values(854,'报销费用类型',7) 
/
insert into HtmlLabelInfo values(855,'',8) 
/
insert into HtmlLabelInfo values(855,'申请日期',7) 
/
insert into HtmlLabelInfo values(856,'',8) 
/
insert into HtmlLabelInfo values(856,'申请金额',7) 
/
insert into HtmlLabelInfo values(857,'',8) 
/
insert into HtmlLabelInfo values(857,'相关文档',7) 
/
insert into HtmlLabelInfo values(858,'',8) 
/
insert into HtmlLabelInfo values(858,'相关资产',7) 
/
insert into HtmlLabelInfo values(859,'',8) 
/
insert into HtmlLabelInfo values(859,'申请原因',7) 
/
insert into HtmlLabelInfo values(860,'',8) 
/
insert into HtmlLabelInfo values(860,'费用申请',7) 
/
insert into HtmlLabelInfo values(861,'',8) 
/
insert into HtmlLabelInfo values(861,'原因',7) 
/
insert into HtmlLabelInfo values(862,'',8) 
/
insert into HtmlLabelInfo values(862,'借款申请',7) 
/
insert into HtmlLabelInfo values(863,'',8) 
/
insert into HtmlLabelInfo values(863,'主分类',7) 
/
insert into HtmlLabelInfo values(864,'',8) 
/
insert into HtmlLabelInfo values(864,'计划部门',7) 
/
insert into HtmlLabelInfo values(865,'',8) 
/
insert into HtmlLabelInfo values(865,'计划人',7) 
/
insert into HtmlLabelInfo values(866,'',8) 
/
insert into HtmlLabelInfo values(866,'总计划金额',7) 
/
insert into HtmlLabelInfo values(867,'',8) 
/
insert into HtmlLabelInfo values(867,'相关客户',7) 
/
insert into HtmlLabelInfo values(868,'',8) 
/
insert into HtmlLabelInfo values(868,'相关文档',7) 
/
insert into HtmlLabelInfo values(869,'',8) 
/
insert into HtmlLabelInfo values(869,'申购部门',7) 
/
insert into HtmlLabelInfo values(870,'',8) 
/
insert into HtmlLabelInfo values(870,'申购人',7) 
/
insert into HtmlLabelInfo values(871,'',8) 
/
insert into HtmlLabelInfo values(871,'用途',7) 
/
insert into HtmlLabelInfo values(872,'',8) 
/
insert into HtmlLabelInfo values(872,'资产申购单',7) 
/
insert into HtmlLabelInfo values(873,'',8) 
/
insert into HtmlLabelInfo values(873,'报价人',7) 
/
insert into HtmlLabelInfo values(874,'',8) 
/
insert into HtmlLabelInfo values(874,'凭证号',7) 
/
insert into HtmlLabelInfo values(875,'',8) 
/
insert into HtmlLabelInfo values(875,'一周工作情况单',7) 
/
insert into HtmlLabelInfo values(876,'',8) 
/
insert into HtmlLabelInfo values(876,'月工作计划单',7) 
/
insert into HtmlLabelInfo values(877,'',8) 
/
insert into HtmlLabelInfo values(877,'月工作总结单',7) 
/
insert into HtmlLabelInfo values(878,'',8) 
/
insert into HtmlLabelInfo values(878,'资产需求',7) 
/
insert into HtmlLabelInfo values(879,'',8) 
/
insert into HtmlLabelInfo values(879,'申购个数',7) 
/
insert into HtmlLabelInfo values(880,'',8) 
/
insert into HtmlLabelInfo values(880,'调拨个数',7) 
/
insert into HtmlLabelInfo values(881,'',8) 
/
insert into HtmlLabelInfo values(881,'领用个数',7) 
/
insert into HtmlLabelInfo values(882,'',8) 
/
insert into HtmlLabelInfo values(882,'创建人',7) 
/
insert into HtmlLabelInfo values(883,'',8) 
/
insert into HtmlLabelInfo values(883,'资产调拨',7) 
/
insert into HtmlLabelInfo values(884,'',8) 
/
insert into HtmlLabelInfo values(884,'原属部门',7) 
/
insert into HtmlLabelInfo values(885,'',8) 
/
insert into HtmlLabelInfo values(885,'原属部门经理',7) 
/
insert into HtmlLabelInfo values(886,'',8) 
/
insert into HtmlLabelInfo values(886,'资产领用',7) 
/
insert into HtmlLabelInfo values(887,'',8) 
/
insert into HtmlLabelInfo values(887,'月份',7) 
/
insert into HtmlLabelInfo values(888,'',8) 
/
insert into HtmlLabelInfo values(888,'原因分析',7) 
/
insert into HtmlLabelInfo values(889,'',8) 
/
insert into HtmlLabelInfo values(889,'建设性意见',7) 
/
insert into HtmlLabelInfo values(890,'',8) 
/
insert into HtmlLabelInfo values(890,'录用通知单',7) 
/
insert into HtmlLabelInfo values(891,'',8) 
/
insert into HtmlLabelInfo values(891,'离职通知单',7) 
/
insert into HtmlLabelInfo values(892,'',8) 
/
insert into HtmlLabelInfo values(892,'总部预算定制单',7) 
/
insert into HtmlLabelInfo values(893,'',8) 
/
insert into HtmlLabelInfo values(893,'被录用人',7) 
/
insert into HtmlLabelInfo values(894,'',8) 
/
insert into HtmlLabelInfo values(894,'用人部门',7) 
/
insert into HtmlLabelInfo values(895,'',8) 
/
insert into HtmlLabelInfo values(895,'任职资格',7) 
/
insert into HtmlLabelInfo values(896,'',8) 
/
insert into HtmlLabelInfo values(896,'接收人',7) 
/
insert into HtmlLabelInfo values(897,'',8) 
/
insert into HtmlLabelInfo values(897,'离职人',7) 
/
insert into HtmlLabelInfo values(898,'',8) 
/
insert into HtmlLabelInfo values(898,'离职时间',7) 
/
insert into HtmlLabelInfo values(899,'',8) 
/
insert into HtmlLabelInfo values(899,'离职说明',7) 
/
insert into HtmlLabelInfo values(900,'',8) 
/
insert into HtmlLabelInfo values(900,'发票号码',7) 
/
insert into HtmlLabelInfo values(901,'',8) 
/
insert into HtmlLabelInfo values(901,'验收人',7) 
/
insert into HtmlLabelInfo values(902,'',8) 
/
insert into HtmlLabelInfo values(902,'验收仓库',7) 
/
insert into HtmlLabelInfo values(903,'',8) 
/
insert into HtmlLabelInfo values(903,'资产编号',7) 
/
insert into HtmlLabelInfo values(904,'',8) 
/
insert into HtmlLabelInfo values(904,'规格型号',7) 
/
insert into HtmlLabelInfo values(905,'',8) 
/
insert into HtmlLabelInfo values(905,'应收数量',7) 
/
insert into HtmlLabelInfo values(906,'',8) 
/
insert into HtmlLabelInfo values(906,'实收数量',7) 
/
insert into HtmlLabelInfo values(907,'',8) 
/
insert into HtmlLabelInfo values(907,'计划价格',7) 
/
insert into HtmlLabelInfo values(908,'',8) 
/
insert into HtmlLabelInfo values(908,'实际价格',7) 
/
insert into HtmlLabelInfo values(909,'',8) 
/
insert into HtmlLabelInfo values(909,'计划金额',7) 
/
insert into HtmlLabelInfo values(910,'',8) 
/
insert into HtmlLabelInfo values(910,'实际金额',7) 
/
insert into HtmlLabelInfo values(911,'',8) 
/
insert into HtmlLabelInfo values(911,'价格差异',7) 
/
insert into HtmlLabelInfo values(912,'',8) 
/
insert into HtmlLabelInfo values(912,'验收入库',7) 
/
insert into HtmlLabelInfo values(913,'',8) 
/
insert into HtmlLabelInfo values(913,'采购人',7) 
/
insert into HtmlLabelInfo values(914,'',8) 
/
insert into HtmlLabelInfo values(914,'交来单位部门',7) 
/
insert into HtmlLabelInfo values(915,'',8) 
/
insert into HtmlLabelInfo values(915,'资产盘点',7) 
/
insert into HtmlLabelInfo values(916,'',8) 
/
insert into HtmlLabelInfo values(916,'盘点人员',7) 
/
insert into HtmlLabelInfo values(917,'',8) 
/
insert into HtmlLabelInfo values(917,'盘点人员2',7) 
/
insert into HtmlLabelInfo values(918,'',8) 
/
insert into HtmlLabelInfo values(918,'盘点部门',7) 
/
insert into HtmlLabelInfo values(919,'',8) 
/
insert into HtmlLabelInfo values(919,'盘点时间',7) 
/
insert into HtmlLabelInfo values(920,'',8) 
/
insert into HtmlLabelInfo values(920,'车辆',7) 
/
insert into HtmlLabelInfo values(921,'',8) 
/
insert into HtmlLabelInfo values(921,'驱车记录',7) 
/
insert into HtmlLabelInfo values(922,'',8) 
/
insert into HtmlLabelInfo values(922,'车辆费用报销',7) 
/
insert into HtmlLabelInfo values(923,'',8) 
/
insert into HtmlLabelInfo values(923,'车辆保养',7) 
/
insert into HtmlLabelInfo values(924,'',8) 
/
insert into HtmlLabelInfo values(924,'车辆维修',7) 
/
insert into HtmlLabelInfo values(925,'',8) 
/
insert into HtmlLabelInfo values(925,'办公用品领用',7) 
/
insert into HtmlLabelInfo values(926,'',8) 
/
insert into HtmlLabelInfo values(926,'相关会议',7) 
/
insert into HtmlLabelInfo values(1000,'',8) 
/
insert into HtmlLabelInfo values(1000,'指标下达人',7) 
/
insert into HtmlLabelInfo values(1001,'',8) 
/
insert into HtmlLabelInfo values(1001,'指标下达部门',7) 
/
insert into HtmlLabelInfo values(1002,'',8) 
/
insert into HtmlLabelInfo values(1002,'相关指标',7) 
/
insert into HtmlLabelInfo values(1003,'',8) 
/
insert into HtmlLabelInfo values(1003,'批准工作流',7) 
/
insert into HtmlLabelInfo values(1004,'',8) 
/
insert into HtmlLabelInfo values(1004,'审批流转单',7) 
/
insert into HtmlLabelInfo values(1005,'',8) 
/
insert into HtmlLabelInfo values(1005,'批注通过',7) 
/
insert into HtmlLabelInfo values(1006,'',8) 
/
insert into HtmlLabelInfo values(1006,'批注',7) 
/
insert into HtmlLabelInfo values(1007,'',8) 
/
insert into HtmlLabelInfo values(1007,'签字',7) 
/
insert into HtmlLabelInfo values(1008,'',8) 
/
insert into HtmlLabelInfo values(1008,'审批意见',7) 
/
insert into HtmlLabelInfo values(1009,'',8) 
/
insert into HtmlLabelInfo values(1009,'审批通过',7) 
/
insert into HtmlLabelInfo values(1010,'',8) 
/
insert into HtmlLabelInfo values(1010,'审批退回',7) 
/
insert into HtmlLabelInfo values(1011,'',8) 
/
insert into HtmlLabelInfo values(1011,'预算费用类型',7) 
/
insert into HtmlLabelInfo values(1012,'',8) 
/
insert into HtmlLabelInfo values(1012,'本部门费用预算表',7) 
/
insert into HtmlLabelInfo values(1013,'',8) 
/
insert into HtmlLabelInfo values(1013,'全年',7) 
/
insert into HtmlLabelInfo values(1014,'',8) 
/
insert into HtmlLabelInfo values(1014,'样式',7) 
/
insert into HtmlLabelInfo values(1015,'',8) 
/
insert into HtmlLabelInfo values(1015,'按部门统计',7) 
/
insert into HtmlLabelInfo values(1016,'',8) 
/
insert into HtmlLabelInfo values(1016,'按预算费用统计',7) 
/
insert into HtmlLabelInfo values(1017,'',8) 
/
insert into HtmlLabelInfo values(1017,'领用资产列表',7) 
/
insert into HtmlLabelInfo values(1018,'',8) 
/
insert into HtmlLabelInfo values(1018,'领用资产规格',7) 
/
insert into HtmlLabelInfo values(1019,'',8) 
/
insert into HtmlLabelInfo values(1019,'领用资产数量',7) 
/
insert into HtmlLabelInfo values(1020,'',8) 
/
insert into HtmlLabelInfo values(1020,'邮箱申请',7) 
/
insert into HtmlLabelInfo values(1021,'',8) 
/
insert into HtmlLabelInfo values(1021,'申请帐户名（英文或拼音）',7) 
/
insert into HtmlLabelInfo values(1022,'',8) 
/
insert into HtmlLabelInfo values(1022,'承诺协议',7) 
/
insert into HtmlLabelInfo values(1023,'',8) 
/
insert into HtmlLabelInfo values(1023,'名片印制',7) 
/
insert into HtmlLabelInfo values(1024,'',8) 
/
insert into HtmlLabelInfo values(1024,'印制盒数',7) 
/
insert into HtmlLabelInfo values(1025,'',8) 
/
insert into HtmlLabelInfo values(1025,'选项',7) 
/
insert into HtmlLabelInfo values(1026,'',8) 
/
insert into HtmlLabelInfo values(1026,'总费用',7) 
/
insert into HtmlLabelInfo values(1027,'',8) 
/
insert into HtmlLabelInfo values(1027,'宾馆预定',7) 
/
insert into HtmlLabelInfo values(1028,'',8) 
/
insert into HtmlLabelInfo values(1028,'入住时间',7) 
/
insert into HtmlLabelInfo values(1029,'',8) 
/
insert into HtmlLabelInfo values(1029,'退房时间',7) 
/
insert into HtmlLabelInfo values(1030,'',8) 
/
insert into HtmlLabelInfo values(1030,'住宿人',7) 
/
insert into HtmlLabelInfo values(1031,'',8) 
/
insert into HtmlLabelInfo values(1031,'报销标准',7) 
/
insert into HtmlLabelInfo values(1032,'',8) 
/
insert into HtmlLabelInfo values(1032,'具体标准',7) 
/
insert into HtmlLabelInfo values(1033,'',8) 
/
insert into HtmlLabelInfo values(1033,'需财务总裁确定',7) 
/
insert into HtmlLabelInfo values(1034,'',8) 
/
insert into HtmlLabelInfo values(1034,'是否超标',7) 
/
insert into HtmlLabelInfo values(1035,'',8) 
/
insert into HtmlLabelInfo values(1035,'完成日期',7) 
/
insert into HtmlLabelInfo values(1036,'',8) 
/
insert into HtmlLabelInfo values(1036,'完成时间',7) 
/
insert into HtmlLabelInfo values(1037,'',8) 
/
insert into HtmlLabelInfo values(1037,'工作提醒',7) 
/
insert into HtmlLabelInfo values(1038,'',8) 
/
insert into HtmlLabelInfo values(1038,'会议日程',7) 
/
insert into HtmlLabelInfo values(1039,'',8) 
/
insert into HtmlLabelInfo values(1039,'部门月工作汇总表',7) 
/
insert into HtmlLabelInfo values(1040,'',8) 
/
insert into HtmlLabelInfo values(1040,'借款人',7) 
/
insert into HtmlLabelInfo values(1041,'',8) 
/
insert into HtmlLabelInfo values(1041,'需要时间',7) 
/
insert into HtmlLabelInfo values(1042,'',8) 
/
insert into HtmlLabelInfo values(1042,'预计还款时间',7) 
/
insert into HtmlLabelInfo values(1043,'',8) 
/
insert into HtmlLabelInfo values(1043,'借款金额',7) 
/
insert into HtmlLabelInfo values(1044,'',8) 
/
insert into HtmlLabelInfo values(1044,'相关流程',7) 
/
insert into HtmlLabelInfo values(1045,'',8) 
/
insert into HtmlLabelInfo values(1045,'启用帐户名',7) 
/
insert into HtmlLabelInfo values(1046,'',8) 
/
insert into HtmlLabelInfo values(1046,'启用时间',7) 
/
insert into HtmlLabelInfo values(1047,'',8) 
/
insert into HtmlLabelInfo values(1047,'经办人',7) 
/
insert into HtmlLabelInfo values(1048,'',8) 
/
insert into HtmlLabelInfo values(1048,'印刷单位',7) 
/
insert into HtmlLabelInfo values(1049,'',8) 
/
insert into HtmlLabelInfo values(1049,'单号',7) 
/
insert into HtmlLabelInfo values(1050,'',8) 
/
insert into HtmlLabelInfo values(1050,'交货日期',7) 
/
insert into HtmlLabelInfo values(1051,'',8) 
/
insert into HtmlLabelInfo values(1051,'预定公司',7) 
/
insert into HtmlLabelInfo values(1052,'',8) 
/
insert into HtmlLabelInfo values(1052,'个人财务销帐',7) 
/
insert into HtmlLabelInfo values(1053,'',8) 
/
insert into HtmlLabelInfo values(1053,'个人往来明细',7) 
/
insert into HtmlLabelInfo values(1054,'',8) 
/
insert into HtmlLabelInfo values(1054,'业务招待费报销',7) 
/
insert into HtmlLabelInfo values(1055,'',8) 
/
insert into HtmlLabelInfo values(1055,'招待人数',7) 
/
insert into HtmlLabelInfo values(1056,'',8) 
/
insert into HtmlLabelInfo values(1056,'招待日期',7) 
/
insert into HtmlLabelInfo values(1057,'',8) 
/
insert into HtmlLabelInfo values(1057,'招待对象',7) 
/
insert into HtmlLabelInfo values(1058,'',8) 
/
insert into HtmlLabelInfo values(1058,'消费形式',7) 
/
insert into HtmlLabelInfo values(1059,'',8) 
/
insert into HtmlLabelInfo values(1059,'消费地点',7) 
/
insert into HtmlLabelInfo values(1060,'',8) 
/
insert into HtmlLabelInfo values(1060,'消费目的',7) 
/
insert into HtmlLabelInfo values(1201,'',8) 
/
insert into HtmlLabelInfo values(1201,'晚上好',7) 
/
insert into HtmlLabelInfo values(1202,'',8) 
/
insert into HtmlLabelInfo values(1202,'上午好',7) 
/
insert into HtmlLabelInfo values(1203,'',8) 
/
insert into HtmlLabelInfo values(1203,'中午好',7) 
/
insert into HtmlLabelInfo values(1204,'',8) 
/
insert into HtmlLabelInfo values(1204,'下午好',7) 
/
insert into HtmlLabelInfo values(1205,'',8) 
/
insert into HtmlLabelInfo values(1205,'退出',7) 
/
insert into HtmlLabelInfo values(1206,'',8) 
/
insert into HtmlLabelInfo values(1206,'我的首页',7) 
/
insert into HtmlLabelInfo values(1207,'',8) 
/
insert into HtmlLabelInfo values(1207,'待办事宜',7) 
/
insert into HtmlLabelInfo values(1208,'',8) 
/
insert into HtmlLabelInfo values(1208,'我的CRM',7) 
/
insert into HtmlLabelInfo values(1209,'',8) 
/
insert into HtmlLabelInfo values(1209,'我的资产',7) 
/
insert into HtmlLabelInfo values(1210,'',8) 
/
insert into HtmlLabelInfo values(1210,'我的请求',7) 
/
insert into HtmlLabelInfo values(1211,'',8) 
/
insert into HtmlLabelInfo values(1211,'我的项目',7) 
/
insert into HtmlLabelInfo values(1212,'',8) 
/
insert into HtmlLabelInfo values(1212,'我的文档',7) 
/
insert into HtmlLabelInfo values(1213,'',8) 
/
insert into HtmlLabelInfo values(1213,'我的邮件',7) 
/
insert into HtmlLabelInfo values(1214,'',8) 
/
insert into HtmlLabelInfo values(1214,'文档 - 近期',7) 
/
insert into HtmlLabelInfo values(1215,'',8) 
/
insert into HtmlLabelInfo values(1215,'文档 - 目录',7) 
/
insert into HtmlLabelInfo values(1216,'统计 - 基本信息',8) 
/
insert into HtmlLabelInfo values(1216,'统计 - 基本信息',7) 
/
insert into HtmlLabelInfo values(1217,'',8) 
/
insert into HtmlLabelInfo values(1217,'统计 - 管理',7) 
/
insert into HtmlLabelInfo values(1218,'',8) 
/
insert into HtmlLabelInfo values(1218,'统计 - 客户信息',7) 
/
insert into HtmlLabelInfo values(1219,'',8) 
/
insert into HtmlLabelInfo values(1219,'获得方式',7) 
/
insert into HtmlLabelInfo values(1220,'',8) 
/
insert into HtmlLabelInfo values(1220,'地理分布',7) 
/
insert into HtmlLabelInfo values(1221,'',8) 
/
insert into HtmlLabelInfo values(1221,'客户联系情况',7) 
/
insert into HtmlLabelInfo values(1222,'',8) 
/
insert into HtmlLabelInfo values(1222,'客户共享情况',7) 
/
insert into HtmlLabelInfo values(1223,'',8) 
/
insert into HtmlLabelInfo values(1223,'登录 - 近期',7) 
/
insert into HtmlLabelInfo values(1224,'',8) 
/
insert into HtmlLabelInfo values(1224,'修改 - 近期',7) 
/
insert into HtmlLabelInfo values(1225,'',8) 
/
insert into HtmlLabelInfo values(1225,'读取 - 近期',7) 
/
insert into HtmlLabelInfo values(1226,'',8) 
/
insert into HtmlLabelInfo values(1226,'邮件发送',7) 
/
insert into HtmlLabelInfo values(1227,'',8) 
/
insert into HtmlLabelInfo values(1227,'批准->基础客户',7) 
/
insert into HtmlLabelInfo values(1228,'',8) 
/
insert into HtmlLabelInfo values(1228,'批准->潜在客户',7) 
/
insert into HtmlLabelInfo values(1229,'',8) 
/
insert into HtmlLabelInfo values(1229,'批准->成功客户',7) 
/
insert into HtmlLabelInfo values(1230,'',8) 
/
insert into HtmlLabelInfo values(1230,'批准->试点客户',7) 
/
insert into HtmlLabelInfo values(1231,'',8) 
/
insert into HtmlLabelInfo values(1231,'批准->典型客户',7) 
/
insert into HtmlLabelInfo values(1232,'',8) 
/
insert into HtmlLabelInfo values(1232,'冻结',7) 
/
insert into HtmlLabelInfo values(1233,'',8) 
/
insert into HtmlLabelInfo values(1233,'解冻',7) 
/
insert into HtmlLabelInfo values(1234,'',8) 
/
insert into HtmlLabelInfo values(1234,'门户申请',7) 
/
insert into HtmlLabelInfo values(1235,'',8) 
/
insert into HtmlLabelInfo values(1235,'门户批准',7) 
/
insert into HtmlLabelInfo values(1236,'',8) 
/
insert into HtmlLabelInfo values(1236,'门户冻结',7) 
/
insert into HtmlLabelInfo values(1237,'',8) 
/
insert into HtmlLabelInfo values(1237,'门户激活',7) 
/
insert into HtmlLabelInfo values(1238,'',8) 
/
insert into HtmlLabelInfo values(1238,'门户密码重生成',7) 
/
insert into HtmlLabelInfo values(1239,'',8) 
/
insert into HtmlLabelInfo values(1239,'新建工作流',7) 
/
insert into HtmlLabelInfo values(1240,'',8) 
/
insert into HtmlLabelInfo values(1240,'门户状态',7) 
/
insert into HtmlLabelInfo values(1241,'',8) 
/
insert into HtmlLabelInfo values(1241,'未开通',7) 
/
insert into HtmlLabelInfo values(1242,'',8) 
/
insert into HtmlLabelInfo values(1242,'申请中',7) 
/
insert into HtmlLabelInfo values(1243,'',8) 
/
insert into HtmlLabelInfo values(1243,'直接转帐收款单',7) 
/
insert into HtmlLabelInfo values(1244,'',8) 
/
insert into HtmlLabelInfo values(1244,'银行直接汇票',7) 
/
insert into HtmlLabelInfo values(1245,'',8) 
/
insert into HtmlLabelInfo values(1245,'以CHF及外币的支付',7) 
/
insert into HtmlLabelInfo values(1246,'',8) 
/
insert into HtmlLabelInfo values(1246,'支票',7) 
/
insert into HtmlLabelInfo values(1247,'',8) 
/
insert into HtmlLabelInfo values(1247,'直接转帐',7) 
/
insert into HtmlLabelInfo values(1248,'',8) 
/
insert into HtmlLabelInfo values(1248,'收款',7) 
/
insert into HtmlLabelInfo values(1249,'',8) 
/
insert into HtmlLabelInfo values(1249,'现金',7) 
/
insert into HtmlLabelInfo values(1250,'',8) 
/
insert into HtmlLabelInfo values(1250,'指定付款',7) 
/
insert into HtmlLabelInfo values(1251,'',8) 
/
insert into HtmlLabelInfo values(1251,'ESR支付',7) 
/
insert into HtmlLabelInfo values(1252,'',8) 
/
insert into HtmlLabelInfo values(1252,'汇票',7) 
/
insert into HtmlLabelInfo values(1253,'',8) 
/
insert into HtmlLabelInfo values(1253,'ES支付',7) 
/
insert into HtmlLabelInfo values(1254,'',8) 
/
insert into HtmlLabelInfo values(1254,'银行支票',7) 
/
insert into HtmlLabelInfo values(1255,'',8) 
/
insert into HtmlLabelInfo values(1255,'新增客户联系情况',7) 
/
insert into HtmlLabelInfo values(1256,'',8) 
/
insert into HtmlLabelInfo values(1256,'继续',7) 
/
insert into HtmlLabelInfo values(1258,'',8) 
/
insert into HtmlLabelInfo values(1258,'上一页',7) 
/
insert into HtmlLabelInfo values(1259,'',8) 
/
insert into HtmlLabelInfo values(1259,'下一页',7) 
/
insert into HtmlLabelInfo values(1260,'',8) 
/
insert into HtmlLabelInfo values(1260,'发件人Email地址',7) 
/
insert into HtmlLabelInfo values(1261,'',8) 
/
insert into HtmlLabelInfo values(1261,'发送到',7) 
/
insert into HtmlLabelInfo values(1262,'',8) 
/
insert into HtmlLabelInfo values(1262,'主联系人',7) 
/
insert into HtmlLabelInfo values(1263,'',8) 
/
insert into HtmlLabelInfo values(1263,'所有联系人',7) 
/
insert into HtmlLabelInfo values(1264,'',8) 
/
insert into HtmlLabelInfo values(1264,'版式',7) 
/
insert into HtmlLabelInfo values(1265,'',8) 
/
insert into HtmlLabelInfo values(1265,'正文',7) 
/
insert into HtmlLabelInfo values(1266,'',8) 
/
insert into HtmlLabelInfo values(1266,'客户代码',7) 
/
insert into HtmlLabelInfo values(1267,'',8) 
/
insert into HtmlLabelInfo values(1267,'方式',7) 
/
insert into HtmlLabelInfo values(1268,'',8) 
/
insert into HtmlLabelInfo values(1268,'客户名称',7) 
/
insert into HtmlLabelInfo values(1269,'',8) 
/
insert into HtmlLabelInfo values(1269,'客户没有科目信息',7) 
/
insert into HtmlLabelInfo values(1270,'',8) 
/
insert into HtmlLabelInfo values(1270,'上限金额',7) 
/
insert into HtmlLabelInfo values(1271,'',8) 
/
insert into HtmlLabelInfo values(1271,'下限金额',7) 
/
insert into HtmlLabelInfo values(1272,'',8) 
/
insert into HtmlLabelInfo values(1272,'读取时间',7) 
/
insert into HtmlLabelInfo values(1273,'',8) 
/
insert into HtmlLabelInfo values(1273,'读取人',7) 
/
insert into HtmlLabelInfo values(1274,'',8) 
/
insert into HtmlLabelInfo values(1274,'联系实施人',7) 
/
insert into HtmlLabelInfo values(1275,'',8) 
/
insert into HtmlLabelInfo values(1275,'联系时间',7) 
/
insert into HtmlLabelInfo values(1276,'',8) 
/
insert into HtmlLabelInfo values(1276,'登录时间',7) 
/
insert into HtmlLabelInfo values(1277,'',8) 
/
insert into HtmlLabelInfo values(1277,'联系时间',7) 
/
insert into HtmlLabelInfo values(1278,'',8) 
/
insert into HtmlLabelInfo values(1278,'客户经理',7) 
/
insert into HtmlLabelInfo values(1279,'',8) 
/
insert into HtmlLabelInfo values(1279,'共享信息',7) 
/
insert into HtmlLabelInfo values(1280,'',8) 
/
insert into HtmlLabelInfo values(1280,'开通',7) 
/
insert into HtmlLabelInfo values(1281,'',8) 
/
insert into HtmlLabelInfo values(1281,'子分类',7) 
/
insert into HtmlLabelInfo values(1282,'',8) 
/
insert into HtmlLabelInfo values(1282,'客户类型',7) 
/
insert into HtmlLabelInfo values(1283,'',8) 
/
insert into HtmlLabelInfo values(1283,'客户描述',7) 
/
insert into HtmlLabelInfo values(1284,'',8) 
/
insert into HtmlLabelInfo values(1284,'客户状况',7) 
/
insert into HtmlLabelInfo values(1285,'',8) 
/
insert into HtmlLabelInfo values(1285,'客户规模',7) 
/
insert into HtmlLabelInfo values(1286,'',8) 
/
insert into HtmlLabelInfo values(1286,'项目新闻',7) 
/
insert into HtmlLabelInfo values(1287,'',8) 
/
insert into HtmlLabelInfo values(1287,'项目组织',7) 
/
insert into HtmlLabelInfo values(1288,'',8) 
/
insert into HtmlLabelInfo values(1288,'CRM 新闻',7) 
/
insert into HtmlLabelInfo values(1289,'',8) 
/
insert into HtmlLabelInfo values(1289,'CRM 组织',7) 
/
insert into HtmlLabelInfo values(1290,'',8) 
/
insert into HtmlLabelInfo values(1290,'返回',7) 
/
insert into HtmlLabelInfo values(1291,'',8) 
/
insert into HtmlLabelInfo values(1291,'项目权限',7) 
/
insert into HtmlLabelInfo values(1292,'',8) 
/
insert into HtmlLabelInfo values(1292,'查看基本信息',7) 
/
insert into HtmlLabelInfo values(1293,'',8) 
/
insert into HtmlLabelInfo values(1293,'查看详细信息',7) 
/
insert into HtmlLabelInfo values(1294,'',8) 
/
insert into HtmlLabelInfo values(1294,'项目简报',7) 
/
insert into HtmlLabelInfo values(1295,'',8) 
/
insert into HtmlLabelInfo values(1295,'计划&任务',7) 
/
insert into HtmlLabelInfo values(1296,'',8) 
/
insert into HtmlLabelInfo values(1296,'跟踪&监控',7) 
/
insert into HtmlLabelInfo values(1297,'',8) 
/
insert into HtmlLabelInfo values(1297,'分析报告',7) 
/
insert into HtmlLabelInfo values(1298,'',8) 
/
insert into HtmlLabelInfo values(1298,'工期',7) 
/
insert into HtmlLabelInfo values(1299,'',8) 
/
insert into HtmlLabelInfo values(1299,'人力成本',7) 
/
insert into HtmlLabelInfo values(1300,'',8) 
/
insert into HtmlLabelInfo values(1300,'设备成本',7) 
/
insert into HtmlLabelInfo values(1301,'',8) 
/
insert into HtmlLabelInfo values(1301,'材料成本',7) 
/
insert into HtmlLabelInfo values(1302,'',8) 
/
insert into HtmlLabelInfo values(1302,'固定资产调拨汇总表',7) 
/
insert into HtmlLabelInfo values(1303,'',8) 
/
insert into HtmlLabelInfo values(1303,'部门固定资产调出一栏表',7) 
/
insert into HtmlLabelInfo values(1304,'',8) 
/
insert into HtmlLabelInfo values(1304,'部门固定资产调入一栏表',7) 
/
insert into HtmlLabelInfo values(1305,'',8) 
/
insert into HtmlLabelInfo values(1305,'各部门固定资产采购计划表',7) 
/
insert into HtmlLabelInfo values(1306,'',8) 
/
insert into HtmlLabelInfo values(1306,'公司固定资产采购明细表',7) 
/
insert into HtmlLabelInfo values(1307,'',8) 
/
insert into HtmlLabelInfo values(1307,'本月各部门申请采购一览表',7) 
/
insert into HtmlLabelInfo values(1308,'',8) 
/
insert into HtmlLabelInfo values(1308,'部门一周工作汇总表',7) 
/
insert into HtmlLabelInfo values(1309,'',8) 
/
insert into HtmlLabelInfo values(1309,'各部门办公用品采购计划表',7) 
/
insert into HtmlLabelInfo values(1310,'',8) 
/
insert into HtmlLabelInfo values(1310,'各部门礼品采购计划表',7) 
/
insert into HtmlLabelInfo values(1311,'',8) 
/
insert into HtmlLabelInfo values(1311,'各部门低值易耗品采购计划表',7) 
/
insert into HtmlLabelInfo values(1312,'',8) 
/
insert into HtmlLabelInfo values(1312,'各部门IT设备采购计划表',7) 
/
insert into HtmlLabelInfo values(1313,'',8) 
/
insert into HtmlLabelInfo values(1313,'各部门家具采购计划表',7) 
/
insert into HtmlLabelInfo values(1314,'',8) 
/
insert into HtmlLabelInfo values(1314,'各部门图书采购计划表',7) 
/
insert into HtmlLabelInfo values(1315,'',8) 
/
insert into HtmlLabelInfo values(1315,'公司办公用品采购计划表',7) 
/
insert into HtmlLabelInfo values(1316,'',8) 
/
insert into HtmlLabelInfo values(1316,'公司礼品采购计划表',7) 
/
insert into HtmlLabelInfo values(1317,'',8) 
/
insert into HtmlLabelInfo values(1317,'公司低值易耗品采购计划表',7) 
/
insert into HtmlLabelInfo values(1318,'',8) 
/
insert into HtmlLabelInfo values(1318,'公司IT设备采购计划表',7) 
/
insert into HtmlLabelInfo values(1319,'',8) 
/
insert into HtmlLabelInfo values(1319,'公司家具采购计划表',7) 
/
insert into HtmlLabelInfo values(1320,'',8) 
/
insert into HtmlLabelInfo values(1320,'公司图书采购计划表',7) 
/
insert into HtmlLabelInfo values(1321,'',8) 
/
insert into HtmlLabelInfo values(1321,'编码',7) 
/
insert into HtmlLabelInfo values(1322,'',8) 
/
insert into HtmlLabelInfo values(1322,'起始日期',7) 
/
insert into HtmlLabelInfo values(1323,'',8) 
/
insert into HtmlLabelInfo values(1323,'结束日期',7) 
/
insert into HtmlLabelInfo values(1324,'',8) 
/
insert into HtmlLabelInfo values(1324,'工期',7) 
/
insert into HtmlLabelInfo values(1325,'',8) 
/
insert into HtmlLabelInfo values(1325,'固定成本',7) 
/
insert into HtmlLabelInfo values(1326,'',8) 
/
insert into HtmlLabelInfo values(1326,'设备',7) 
/
insert into HtmlLabelInfo values(1327,'',8) 
/
insert into HtmlLabelInfo values(1327,'成本/天',7) 
/
insert into HtmlLabelInfo values(1328,'',8) 
/
insert into HtmlLabelInfo values(1328,'材料',7) 
/
insert into HtmlLabelInfo values(1329,'',8) 
/
insert into HtmlLabelInfo values(1329,'单位',7) 
/
insert into HtmlLabelInfo values(1330,'',8) 
/
insert into HtmlLabelInfo values(1330,'单价',7) 
/
insert into HtmlLabelInfo values(1331,'',8) 
/
insert into HtmlLabelInfo values(1331,'数量',7) 
/
insert into HtmlLabelInfo values(1332,'',8) 
/
insert into HtmlLabelInfo values(1332,'任务',7) 
/
insert into HtmlLabelInfo values(1333,'',8) 
/
insert into HtmlLabelInfo values(1333,'计划版本',7) 
/
insert into HtmlLabelInfo values(1334,'',8) 
/
insert into HtmlLabelInfo values(1334,'请求说明',7) 
/
insert into HtmlLabelInfo values(1335,'',8) 
/
insert into HtmlLabelInfo values(1335,'当前状况',7) 
/
insert into HtmlLabelInfo values(1336,'',8) 
/
insert into HtmlLabelInfo values(1336,'项目计划',7) 
/
insert into HtmlLabelInfo values(1337,'',8) 
/
insert into HtmlLabelInfo values(1337,'项目计划通知',7) 
/
insert into HtmlLabelInfo values(1338,'',8) 
/
insert into HtmlLabelInfo values(1338,'执行',7) 
/
insert into HtmlLabelInfo values(1339,'',8) 
/
insert into HtmlLabelInfo values(1339,'创建时间',7) 
/
insert into HtmlLabelInfo values(1340,'',8) 
/
insert into HtmlLabelInfo values(1340,'所有人',7) 
/
insert into HtmlLabelInfo values(1341,'',8) 
/
insert into HtmlLabelInfo values(1341,'文档名称',7) 
/
insert into HtmlLabelInfo values(1342,'',8) 
/
insert into HtmlLabelInfo values(1342,'添加任务',7) 
/
insert into HtmlLabelInfo values(1343,'',8) 
/
insert into HtmlLabelInfo values(1343,'提交批准',7) 
/
insert into HtmlLabelInfo values(1344,'',8) 
/
insert into HtmlLabelInfo values(1344,'计划批准',7) 
/
insert into HtmlLabelInfo values(1345,'',8) 
/
insert into HtmlLabelInfo values(1345,'计划否决',7) 
/
insert into HtmlLabelInfo values(1346,'',8) 
/
insert into HtmlLabelInfo values(1346,'计划删除',7) 
/
insert into HtmlLabelInfo values(1347,'',8) 
/
insert into HtmlLabelInfo values(1347,'计划调整',7) 
/
insert into HtmlLabelInfo values(1348,'',8) 
/
insert into HtmlLabelInfo values(1348,'通知成员',7) 
/
insert into HtmlLabelInfo values(1349,'',8) 
/
insert into HtmlLabelInfo values(1349,'人力使用',7) 
/
insert into HtmlLabelInfo values(1350,'',8) 
/
insert into HtmlLabelInfo values(1350,'设备使用',7) 
/
insert into HtmlLabelInfo values(1351,'',8) 
/
insert into HtmlLabelInfo values(1351,'材料使用',7) 
/
insert into HtmlLabelInfo values(1352,'',8) 
/
insert into HtmlLabelInfo values(1352,'任务名称',7) 
/
insert into HtmlLabelInfo values(1353,'',8) 
/
insert into HtmlLabelInfo values(1353,'项目名称',7) 
/
insert into HtmlLabelInfo values(1354,'',8) 
/
insert into HtmlLabelInfo values(1354,'比较对象',7) 
/
insert into HtmlLabelInfo values(1355,'',8) 
/
insert into HtmlLabelInfo values(1355,'基准计划',7) 
/
insert into HtmlLabelInfo values(1356,'',8) 
/
insert into HtmlLabelInfo values(1356,'当前计划',7) 
/
insert into HtmlLabelInfo values(1357,'',8) 
/
insert into HtmlLabelInfo values(1357,'差值(基准)',7) 
/
insert into HtmlLabelInfo values(1358,'',8) 
/
insert into HtmlLabelInfo values(1358,'差值(当前)',7) 
/
insert into HtmlLabelInfo values(1359,'',8) 
/
insert into HtmlLabelInfo values(1359,'折旧方法',7) 
/
insert into HtmlLabelInfo values(1360,'',8) 
/
insert into HtmlLabelInfo values(1360,'财务相关',7) 
/
insert into HtmlLabelInfo values(1361,'',8) 
/
insert into HtmlLabelInfo values(1361,'基本信息',7) 
/
insert into HtmlLabelInfo values(1362,'',8) 
/
insert into HtmlLabelInfo values(1362,'条形码',7) 
/
insert into HtmlLabelInfo values(1363,'',8) 
/
insert into HtmlLabelInfo values(1363,'单独核算',7) 
/
insert into HtmlLabelInfo values(1364,'',8) 
/
insert into HtmlLabelInfo values(1364,'制造厂商',7) 
/
insert into HtmlLabelInfo values(1365,'',8) 
/
insert into HtmlLabelInfo values(1365,'出厂日期',7) 
/
insert into HtmlLabelInfo values(1366,'',8) 
/
insert into HtmlLabelInfo values(1366,'自制',7) 
/
insert into HtmlLabelInfo values(1367,'',8) 
/
insert into HtmlLabelInfo values(1367,'采购',7) 
/
insert into HtmlLabelInfo values(1368,'',8) 
/
insert into HtmlLabelInfo values(1368,'租赁',7) 
/
insert into HtmlLabelInfo values(1369,'',8) 
/
insert into HtmlLabelInfo values(1369,'出租',7) 
/
insert into HtmlLabelInfo values(1370,'',8) 
/
insert into HtmlLabelInfo values(1370,'租用',7) 
/
insert into HtmlLabelInfo values(1371,'',8) 
/
insert into HtmlLabelInfo values(1371,'替代',7) 
/
insert into HtmlLabelInfo values(1372,'',8) 
/
insert into HtmlLabelInfo values(1372,'开始价格',7) 
/
insert into HtmlLabelInfo values(1373,'',8) 
/
insert into HtmlLabelInfo values(1373,'折旧底价',7) 
/
insert into HtmlLabelInfo values(1374,'',8) 
/
insert into HtmlLabelInfo values(1374,'折旧信息',7) 
/
insert into HtmlLabelInfo values(1375,'',8) 
/
insert into HtmlLabelInfo values(1375,'入库',7) 
/
insert into HtmlLabelInfo values(1376,'',8) 
/
insert into HtmlLabelInfo values(1376,'调入',7) 
/
insert into HtmlLabelInfo values(1377,'',8) 
/
insert into HtmlLabelInfo values(1377,'调出',7) 
/
insert into HtmlLabelInfo values(1378,'',8) 
/
insert into HtmlLabelInfo values(1378,'领用',7) 
/
insert into HtmlLabelInfo values(1379,'',8) 
/
insert into HtmlLabelInfo values(1379,'租借',7) 
/
insert into HtmlLabelInfo values(1380,'',8) 
/
insert into HtmlLabelInfo values(1380,'流转',7) 
/
insert into HtmlLabelInfo values(1381,'',8) 
/
insert into HtmlLabelInfo values(1381,'移交',7) 
/
insert into HtmlLabelInfo values(1382,'',8) 
/
insert into HtmlLabelInfo values(1382,'维修',7) 
/
insert into HtmlLabelInfo values(1383,'',8) 
/
insert into HtmlLabelInfo values(1383,'领用',7) 
/
insert into HtmlLabelInfo values(1384,'',8) 
/
insert into HtmlLabelInfo values(1384,'归还',7) 
/
insert into HtmlLabelInfo values(1385,'',8) 
/
insert into HtmlLabelInfo values(1385,'损失',7) 
/
insert into HtmlLabelInfo values(1386,'',8) 
/
insert into HtmlLabelInfo values(1386,'报废',7) 
/
insert into HtmlLabelInfo values(1387,'',8) 
/
insert into HtmlLabelInfo values(1387,'存放地点',7) 
/
insert into HtmlLabelInfo values(1388,'',8) 
/
insert into HtmlLabelInfo values(1388,'已用年限，月份',7) 
/
insert into HtmlLabelInfo values(1389,'',8) 
/
insert into HtmlLabelInfo values(1389,'当前价值',7) 
/
insert into HtmlLabelInfo values(1390,'',8) 
/
insert into HtmlLabelInfo values(1390,'残值率',7) 
/
insert into HtmlLabelInfo values(1391,'',8) 
/
insert into HtmlLabelInfo values(1391,'月折旧率',7) 
/
insert into HtmlLabelInfo values(1392,'',8) 
/
insert into HtmlLabelInfo values(1392,'报废日期',7) 
/
insert into HtmlLabelInfo values(1393,'',8) 
/
insert into HtmlLabelInfo values(1393,'相关费用',7) 
/
insert into HtmlLabelInfo values(1394,'',8) 
/
insert into HtmlLabelInfo values(1394,'流转日期',7) 
/
insert into HtmlLabelInfo values(1395,'',8) 
/
insert into HtmlLabelInfo values(1395,'地点',7) 
/
insert into HtmlLabelInfo values(1396,'',8) 
/
insert into HtmlLabelInfo values(1396,'出库',7) 
/
insert into HtmlLabelInfo values(1397,'',8) 
/
insert into HtmlLabelInfo values(1397,'盘亏',7) 
/
insert into HtmlLabelInfo values(1398,'',8) 
/
insert into HtmlLabelInfo values(1398,'盘盈',7) 
/
insert into HtmlLabelInfo values(1399,'',8) 
/
insert into HtmlLabelInfo values(1399,'维修单位',7) 
/
insert into HtmlLabelInfo values(1400,'',8) 
/
insert into HtmlLabelInfo values(1400,'经费',7) 
/
insert into HtmlLabelInfo values(1401,'',8) 
/
insert into HtmlLabelInfo values(1401,'移交日期',7) 
/
insert into HtmlLabelInfo values(1402,'',8) 
/
insert into HtmlLabelInfo values(1402,'下一步',7) 
/
insert into HtmlLabelInfo values(1403,'',8) 
/
insert into HtmlLabelInfo values(1403,'入库日期',7) 
/
insert into HtmlLabelInfo values(1404,'',8) 
/
insert into HtmlLabelInfo values(1404,'租借日期',7) 
/
insert into HtmlLabelInfo values(1405,'',8) 
/
insert into HtmlLabelInfo values(1405,'数量超额',7) 
/
insert into HtmlLabelInfo values(1406,'',8) 
/
insert into HtmlLabelInfo values(1406,'损失日期',7) 
/
insert into HtmlLabelInfo values(1408,'',8) 
/
insert into HtmlLabelInfo values(1408,'损失后状态',7) 
/
insert into HtmlLabelInfo values(1409,'',8) 
/
insert into HtmlLabelInfo values(1409,'维修日期',7) 
/
insert into HtmlLabelInfo values(1410,'',8) 
/
insert into HtmlLabelInfo values(1410,'调入日期',7) 
/
insert into HtmlLabelInfo values(1411,'',8) 
/
insert into HtmlLabelInfo values(1411,'调出日期',7) 
/
insert into HtmlLabelInfo values(1412,'',8) 
/
insert into HtmlLabelInfo values(1412,'领用日期',7) 
/
insert into HtmlLabelInfo values(1413,'',8) 
/
insert into HtmlLabelInfo values(1413,'归还日期',7) 
/
insert into HtmlLabelInfo values(1414,'',8) 
/
insert into HtmlLabelInfo values(1414,'归还后状态',7) 
/
insert into HtmlLabelInfo values(1415,'',8) 
/
insert into HtmlLabelInfo values(1415,'盘点日期',7) 
/
insert into HtmlLabelInfo values(1416,'',8) 
/
insert into HtmlLabelInfo values(1416,'盘点人',7) 
/
insert into HtmlLabelInfo values(1417,'',8) 
/
insert into HtmlLabelInfo values(1417,'理论数量',7) 
/
insert into HtmlLabelInfo values(1418,'',8) 
/
insert into HtmlLabelInfo values(1418,'实际数量',7) 
/
insert into HtmlLabelInfo values(1419,'',8) 
/
insert into HtmlLabelInfo values(1419,'盈亏数量',7) 
/
insert into HtmlLabelInfo values(1420,'',8) 
/
insert into HtmlLabelInfo values(1420,'盈亏金额',7) 
/
insert into HtmlLabelInfo values(1421,'',8) 
/
insert into HtmlLabelInfo values(1421,'新增',7) 
/
insert into HtmlLabelInfo values(1422,'',8) 
/
insert into HtmlLabelInfo values(1422,'未审批',7) 
/
insert into HtmlLabelInfo values(1423,'',8) 
/
insert into HtmlLabelInfo values(1423,'已审批',7) 
/
insert into HtmlLabelInfo values(1424,'',8) 
/
insert into HtmlLabelInfo values(1424,'盘点时间',7) 
/
insert into HtmlLabelInfo values(1425,'',8) 
/
insert into HtmlLabelInfo values(1425,'审批日期',7) 
/
insert into HtmlLabelInfo values(1426,'',8) 
/
insert into HtmlLabelInfo values(1426,'选中',7) 
/
insert into HtmlLabelInfo values(1427,'',8) 
/
insert into HtmlLabelInfo values(1427,'时间(月)',7) 
/
insert into HtmlLabelInfo values(1428,'',8) 
/
insert into HtmlLabelInfo values(1428,'添加项',7) 
/
insert into HtmlLabelInfo values(1429,'',8) 
/
insert into HtmlLabelInfo values(1429,'删除项',7) 
/
insert into HtmlLabelInfo values(1430,'',8) 
/
insert into HtmlLabelInfo values(1430,'时限(月)',7) 
/
insert into HtmlLabelInfo values(1431,'',8) 
/
insert into HtmlLabelInfo values(1431,'起始因子',7) 
/
insert into HtmlLabelInfo values(1432,'',8) 
/
insert into HtmlLabelInfo values(1432,'结束因子',7) 
/
insert into HtmlLabelInfo values(1433,'',8) 
/
insert into HtmlLabelInfo values(1433,'折旧函数(t)',7) 
/
insert into HtmlLabelInfo values(1434,'',8) 
/
insert into HtmlLabelInfo values(1434,'原部门',7) 
/
insert into HtmlLabelInfo values(1435,'',8) 
/
insert into HtmlLabelInfo values(1435,'流转至部门',7) 
/
insert into HtmlLabelInfo values(1436,'',8) 
/
insert into HtmlLabelInfo values(1436,'流转至人',7) 
/
insert into HtmlLabelInfo values(1437,'',8) 
/
insert into HtmlLabelInfo values(1437,'调拨',7) 
/
insert into HtmlLabelInfo values(1438,'',8) 
/
insert into HtmlLabelInfo values(1438,'资产总表',7) 
/
insert into HtmlLabelInfo values(1439,'',8) 
/
insert into HtmlLabelInfo values(1439,'资产情况',7) 
/
insert into HtmlLabelInfo values(1440,'',8) 
/
insert into HtmlLabelInfo values(1440,'总报表',7) 
/
insert into HtmlLabelInfo values(1441,'',8) 
/
insert into HtmlLabelInfo values(1441,'折旧报告',7) 
/
insert into HtmlLabelInfo values(1442,'',8) 
/
insert into HtmlLabelInfo values(1442,'工作流 － 统计报表',7) 
/
insert into HtmlLabelInfo values(1443,'',8) 
/
insert into HtmlLabelInfo values(1443,'大类',7) 
/
insert into HtmlLabelInfo values(1444,'',8) 
/
insert into HtmlLabelInfo values(1444,'小类',7) 
/
insert into HtmlLabelInfo values(1445,'',8) 
/
insert into HtmlLabelInfo values(1445,'资产名称',7) 
/
insert into HtmlLabelInfo values(1446,'',8) 
/
insert into HtmlLabelInfo values(1446,'库存数量',7) 
/
insert into HtmlLabelInfo values(1447,'',8) 
/
insert into HtmlLabelInfo values(1447,'总金额',7) 
/
insert into HtmlLabelInfo values(1448,'',8) 
/
insert into HtmlLabelInfo values(1448,'目前状态',7) 
/
insert into HtmlLabelInfo values(1449,'',8) 
/
insert into HtmlLabelInfo values(1449,'谁在使用',7) 
/
insert into HtmlLabelInfo values(1450,'',8) 
/
insert into HtmlLabelInfo values(1450,'现值',7) 
/
insert into HtmlLabelInfo values(1451,'',8) 
/
insert into HtmlLabelInfo values(1451,'当前数量',7) 
/
insert into HtmlLabelInfo values(1452,'',8) 
/
insert into HtmlLabelInfo values(1452,'总帐科目',7) 
/
insert into HtmlLabelInfo values(1453,'',8) 
/
insert into HtmlLabelInfo values(1453,'财务期间',7) 
/
insert into HtmlLabelInfo values(1454,'',8) 
/
insert into HtmlLabelInfo values(1454,'已处理',7) 
/
insert into HtmlLabelInfo values(1455,'',8) 
/
insert into HtmlLabelInfo values(1455,'费用名称',7) 
/
insert into HtmlLabelInfo values(1456,'',8) 
/
insert into HtmlLabelInfo values(1456,'费用描述',7) 
/
insert into HtmlLabelInfo values(1457,'',8) 
/
insert into HtmlLabelInfo values(1457,'报销费用类型名称',7) 
/
insert into HtmlLabelInfo values(1458,'',8) 
/
insert into HtmlLabelInfo values(1458,'报销费用类型描述',7) 
/
insert into HtmlLabelInfo values(1459,'',8) 
/
insert into HtmlLabelInfo values(1459,'期间 从 , 到',7) 
/
insert into HtmlLabelInfo values(1460,'',8) 
/
insert into HtmlLabelInfo values(1460,'期末',7) 
/
insert into HtmlLabelInfo values(1461,'',8) 
/
insert into HtmlLabelInfo values(1461,'比率',7) 
/
insert into HtmlLabelInfo values(1462,'',8) 
/
insert into HtmlLabelInfo values(1462,'费用类型',7) 
/
insert into HtmlLabelInfo values(1463,'',8) 
/
insert into HtmlLabelInfo values(1463,'正方',7) 
/
insert into HtmlLabelInfo values(1464,'',8) 
/
insert into HtmlLabelInfo values(1464,'百分比',7) 
/
insert into HtmlLabelInfo values(1465,'',8) 
/
insert into HtmlLabelInfo values(1465,'借方',7) 
/
insert into HtmlLabelInfo values(1466,'',8) 
/
insert into HtmlLabelInfo values(1466,'贷方',7) 
/
insert into HtmlLabelInfo values(1467,'',8) 
/
insert into HtmlLabelInfo values(1467,'自动明细',7) 
/
insert into HtmlLabelInfo values(1468,'',8) 
/
insert into HtmlLabelInfo values(1468,'客户:预收',7) 
/
insert into HtmlLabelInfo values(1469,'',8) 
/
insert into HtmlLabelInfo values(1469,'客户:应收',7) 
/
insert into HtmlLabelInfo values(1470,'',8) 
/
insert into HtmlLabelInfo values(1470,'供应商:预付',7) 
/
insert into HtmlLabelInfo values(1471,'',8) 
/
insert into HtmlLabelInfo values(1471,'供应商:应付',7) 
/
insert into HtmlLabelInfo values(1472,'',8) 
/
insert into HtmlLabelInfo values(1472,'类型, 余额方向:',7) 
/
insert into HtmlLabelInfo values(1473,'',8) 
/
insert into HtmlLabelInfo values(1473,'负债',7) 
/
insert into HtmlLabelInfo values(1474,'',8) 
/
insert into HtmlLabelInfo values(1474,'所有者权益',7) 
/
insert into HtmlLabelInfo values(1475,'',8) 
/
insert into HtmlLabelInfo values(1475,'损益',7) 
/
insert into HtmlLabelInfo values(1476,'',8) 
/
insert into HtmlLabelInfo values(1476,'货币兑换',7) 
/
insert into HtmlLabelInfo values(1477,'',8) 
/
insert into HtmlLabelInfo values(1477,'历史',7) 
/
insert into HtmlLabelInfo values(1478,'',8) 
/
insert into HtmlLabelInfo values(1478,'目录信息',7) 
/
insert into HtmlLabelInfo values(1479,'',8) 
/
insert into HtmlLabelInfo values(1479,'权限详细信息',7) 
/
insert into HtmlLabelInfo values(1480,'',8) 
/
insert into HtmlLabelInfo values(1480,'期初',7) 
/
insert into HtmlLabelInfo values(1481,'',8) 
/
insert into HtmlLabelInfo values(1481,'选用',7) 
/
insert into HtmlLabelInfo values(1482,'',8) 
/
insert into HtmlLabelInfo values(1482,'期初数',7) 
/
insert into HtmlLabelInfo values(1483,'',8) 
/
insert into HtmlLabelInfo values(1483,'期末数',7) 
/
insert into HtmlLabelInfo values(1484,'',8) 
/
insert into HtmlLabelInfo values(1484,'资产总计',7) 
/
insert into HtmlLabelInfo values(1485,'',8) 
/
insert into HtmlLabelInfo values(1485,'负债和所有者权益',7) 
/
insert into HtmlLabelInfo values(1486,'',8) 
/
insert into HtmlLabelInfo values(1486,'行次',7) 
/
insert into HtmlLabelInfo values(1487,'',8) 
/
insert into HtmlLabelInfo values(1487,'负债总计',7) 
/
insert into HtmlLabelInfo values(1488,'',8) 
/
insert into HtmlLabelInfo values(1488,'所有者权益总计',7) 
/
insert into HtmlLabelInfo values(1489,'',8) 
/
insert into HtmlLabelInfo values(1489,'负债和所有者权益总计',7) 
/
insert into HtmlLabelInfo values(1490,'',8) 
/
insert into HtmlLabelInfo values(1490,'部门费用预算表',7) 
/
insert into HtmlLabelInfo values(1491,'',8) 
/
insert into HtmlLabelInfo values(1491,'费用',7) 
/
insert into HtmlLabelInfo values(1492,'',8) 
/
insert into HtmlLabelInfo values(1492,'一月',7) 
/
insert into HtmlLabelInfo values(1493,'',8) 
/
insert into HtmlLabelInfo values(1493,'二月',7) 
/
insert into HtmlLabelInfo values(1494,'',8) 
/
insert into HtmlLabelInfo values(1494,'三月',7) 
/
insert into HtmlLabelInfo values(1495,'',8) 
/
insert into HtmlLabelInfo values(1495,'四月',7) 
/
insert into HtmlLabelInfo values(1496,'',8) 
/
insert into HtmlLabelInfo values(1496,'五月',7) 
/
insert into HtmlLabelInfo values(1497,'',8) 
/
insert into HtmlLabelInfo values(1497,'六月',7) 
/
insert into HtmlLabelInfo values(1498,'',8) 
/
insert into HtmlLabelInfo values(1498,'七月',7) 
/
insert into HtmlLabelInfo values(1499,'',8) 
/
insert into HtmlLabelInfo values(1499,'八月',7) 
/
insert into HtmlLabelInfo values(1500,'Homepage',8) 
/
insert into HtmlLabelInfo values(1500,'我的首页',7) 
/
insert into HtmlLabelInfo values(1501,'',8) 
/
insert into HtmlLabelInfo values(1501,'流转情况',7) 
/
insert into HtmlLabelInfo values(1502,'',8) 
/
insert into HtmlLabelInfo values(1502,'资格证书',7) 
/
insert into HtmlLabelInfo values(1503,'',8) 
/
insert into HtmlLabelInfo values(1503,'入职简历',7) 
/
insert into HtmlLabelInfo values(1504,'',8) 
/
insert into HtmlLabelInfo values(1504,'薪酬福利',7) 
/
insert into HtmlLabelInfo values(1505,'',8) 
/
insert into HtmlLabelInfo values(1505,'年休假记录',7) 
/
insert into HtmlLabelInfo values(1506,'',8) 
/
insert into HtmlLabelInfo values(1506,'盘点',7) 
/
insert into HtmlLabelInfo values(1507,'',8) 
/
insert into HtmlLabelInfo values(1507,'管理员',7) 
/
insert into HtmlLabelInfo values(1508,'',8) 
/
insert into HtmlLabelInfo values(1508,'使用人',7) 
/
insert into HtmlLabelInfo values(1509,'',8) 
/
insert into HtmlLabelInfo values(1509,'资产资料',7) 
/
insert into HtmlLabelInfo values(1510,'',8) 
/
insert into HtmlLabelInfo values(1510,'资产归总表',7) 
/
insert into HtmlLabelInfo values(1511,'',8) 
/
insert into HtmlLabelInfo values(1511,'费用分摊',7) 
/
insert into HtmlLabelInfo values(1512,'',8) 
/
insert into HtmlLabelInfo values(1512,'领用人',7) 
/
insert into HtmlLabelInfo values(1513,'',8) 
/
insert into HtmlLabelInfo values(1513,'日常办公用品一览表',7) 
/
insert into HtmlLabelInfo values(1514,'',8) 
/
insert into HtmlLabelInfo values(1514,'评价',7) 
/
insert into HtmlLabelInfo values(1515,'',8) 
/
insert into HtmlLabelInfo values(1515,'通讯录',7) 
/
insert into HtmlLabelInfo values(1516,'',8) 
/
insert into HtmlLabelInfo values(1516,'入职日期',7) 
/
insert into HtmlLabelInfo values(1517,'',8) 
/
insert into HtmlLabelInfo values(1517,'现在住址',7) 
/
insert into HtmlLabelInfo values(1518,'',8) 
/
insert into HtmlLabelInfo values(1518,'毕业学校',7) 
/
insert into HtmlLabelInfo values(1519,'',8) 
/
insert into HtmlLabelInfo values(1519,'毕业日期',7) 
/
insert into HtmlLabelInfo values(1520,'',8) 
/
insert into HtmlLabelInfo values(1520,'上月盘存数',7) 
/
insert into HtmlLabelInfo values(1521,'',8) 
/
insert into HtmlLabelInfo values(1521,'本月进货数',7) 
/
insert into HtmlLabelInfo values(1522,'',8) 
/
insert into HtmlLabelInfo values(1522,'本月领用数',7) 
/
insert into HtmlLabelInfo values(1523,'',8) 
/
insert into HtmlLabelInfo values(1523,'领用总价',7) 
/
insert into HtmlLabelInfo values(1524,'',8) 
/
insert into HtmlLabelInfo values(1524,'月末库存',7) 
/
insert into HtmlLabelInfo values(1800,'',8) 
/
insert into HtmlLabelInfo values(1800,'九月',7) 
/
insert into HtmlLabelInfo values(1801,'',8) 
/
insert into HtmlLabelInfo values(1801,'十月',7) 
/
insert into HtmlLabelInfo values(1802,'',8) 
/
insert into HtmlLabelInfo values(1802,'十一月',7) 
/
insert into HtmlLabelInfo values(1803,'',8) 
/
insert into HtmlLabelInfo values(1803,'十二月',7) 
/
insert into HtmlLabelInfo values(1804,'',8) 
/
insert into HtmlLabelInfo values(1804,'工资',7) 
/
insert into HtmlLabelInfo values(1805,'',8) 
/
insert into HtmlLabelInfo values(1805,'福利费',7) 
/
insert into HtmlLabelInfo values(1806,'',8) 
/
insert into HtmlLabelInfo values(1806,'上期累计数',7) 
/
insert into HtmlLabelInfo values(1807,'',8) 
/
insert into HtmlLabelInfo values(1807,'本期累计数',7) 
/
insert into HtmlLabelInfo values(1808,'',8) 
/
insert into HtmlLabelInfo values(1808,'损益报告',7) 
/
insert into HtmlLabelInfo values(1809,'',8) 
/
insert into HtmlLabelInfo values(1809,'明细分类帐',7) 
/
insert into HtmlLabelInfo values(1810,'',8) 
/
insert into HtmlLabelInfo values(1810,'期初余额',7) 
/
insert into HtmlLabelInfo values(1811,'',8) 
/
insert into HtmlLabelInfo values(1811,'余额',7) 
/
insert into HtmlLabelInfo values(1812,'',8) 
/
insert into HtmlLabelInfo values(1812,'期间,从',7) 
/
insert into HtmlLabelInfo values(1813,'',8) 
/
insert into HtmlLabelInfo values(1813,'期间,到',7) 
/
insert into HtmlLabelInfo values(1814,'',8) 
/
insert into HtmlLabelInfo values(1814,'年, 期间',7) 
/
insert into HtmlLabelInfo values(1815,'',8) 
/
insert into HtmlLabelInfo values(1815,'已登帐',7) 
/
insert into HtmlLabelInfo values(1816,'',8) 
/
insert into HtmlLabelInfo values(1816,'结帐',7) 
/
insert into HtmlLabelInfo values(1817,'',8) 
/
insert into HtmlLabelInfo values(1817,'余额方向',7) 
/
insert into HtmlLabelInfo values(1818,'',8) 
/
insert into HtmlLabelInfo values(1818,'方向',7) 
/
insert into HtmlLabelInfo values(1819,'',8) 
/
insert into HtmlLabelInfo values(1819,'分录日期',7) 
/
insert into HtmlLabelInfo values(1820,'',8) 
/
insert into HtmlLabelInfo values(1820,'借方金额',7) 
/
insert into HtmlLabelInfo values(1821,'',8) 
/
insert into HtmlLabelInfo values(1821,'贷方金额',7) 
/
insert into HtmlLabelInfo values(1822,'',8) 
/
insert into HtmlLabelInfo values(1822,'分录数',7) 
/
insert into HtmlLabelInfo values(1823,'',8) 
/
insert into HtmlLabelInfo values(1823,'汇总',7) 
/
insert into HtmlLabelInfo values(1824,'',8) 
/
insert into HtmlLabelInfo values(1824,'年/期间',7) 
/
insert into HtmlLabelInfo values(1825,'',8) 
/
insert into HtmlLabelInfo values(1825,'新:人力资源库',7) 
/
insert into HtmlLabelInfo values(1826,'',8) 
/
insert into HtmlLabelInfo values(1826,'身高(cm)',7) 
/
insert into HtmlLabelInfo values(1827,'',8) 
/
insert into HtmlLabelInfo values(1827,'健康状况',7) 
/
insert into HtmlLabelInfo values(1828,'',8) 
/
insert into HtmlLabelInfo values(1828,'户口所在地',7) 
/
insert into HtmlLabelInfo values(1829,'',8) 
/
insert into HtmlLabelInfo values(1829,'现居住地',7) 
/
insert into HtmlLabelInfo values(1830,'',8) 
/
insert into HtmlLabelInfo values(1830,'应届',7) 
/
insert into HtmlLabelInfo values(1831,'',8) 
/
insert into HtmlLabelInfo values(1831,'在职',7) 
/
insert into HtmlLabelInfo values(1832,'',8) 
/
insert into HtmlLabelInfo values(1832,'待业',7) 
/
insert into HtmlLabelInfo values(1833,'',8) 
/
insert into HtmlLabelInfo values(1833,'学位',7) 
/
insert into HtmlLabelInfo values(1834,'',8) 
/
insert into HtmlLabelInfo values(1834,'入团日期',7) 
/
insert into HtmlLabelInfo values(1835,'',8) 
/
insert into HtmlLabelInfo values(1835,'入党日期',7) 
/
insert into HtmlLabelInfo values(1836,'',8) 
/
insert into HtmlLabelInfo values(1836,'民主日期',7) 
/
insert into HtmlLabelInfo values(1837,'',8) 
/
insert into HtmlLabelInfo values(1837,'政治面貌',7) 
/
insert into HtmlLabelInfo values(1838,'',8) 
/
insert into HtmlLabelInfo values(1838,'证件类别',7) 
/
insert into HtmlLabelInfo values(1839,'',8) 
/
insert into HtmlLabelInfo values(1839,'证件号码',7) 
/
insert into HtmlLabelInfo values(1840,'',8) 
/
insert into HtmlLabelInfo values(1840,'籍贯',7) 
/
insert into HtmlLabelInfo values(1841,'',8) 
/
insert into HtmlLabelInfo values(1841,'培训及持有证书',7) 
/
insert into HtmlLabelInfo values(1842,'',8) 
/
insert into HtmlLabelInfo values(1842,'求职意向',7) 
/
insert into HtmlLabelInfo values(1843,'',8) 
/
insert into HtmlLabelInfo values(1843,'目前年薪',7) 
/
insert into HtmlLabelInfo values(1844,'',8) 
/
insert into HtmlLabelInfo values(1844,'工作年限(年)',7) 
/
insert into HtmlLabelInfo values(1845,'',8) 
/
insert into HtmlLabelInfo values(1845,'年薪底限',7) 
/
insert into HtmlLabelInfo values(1846,'',8) 
/
insert into HtmlLabelInfo values(1846,'流动理由',7) 
/
insert into HtmlLabelInfo values(1847,'',8) 
/
insert into HtmlLabelInfo values(1847,'其他要求',7) 
/
insert into HtmlLabelInfo values(1848,'',8) 
/
insert into HtmlLabelInfo values(1848,'个人主页',7) 
/
insert into HtmlLabelInfo values(1849,'',8) 
/
insert into HtmlLabelInfo values(1849,'自荐书',7) 
/
insert into HtmlLabelInfo values(1850,'',8) 
/
insert into HtmlLabelInfo values(1850,'学校',7) 
/
insert into HtmlLabelInfo values(1851,'',8) 
/
insert into HtmlLabelInfo values(1851,'公司',7) 
/
insert into HtmlLabelInfo values(1852,'',8) 
/
insert into HtmlLabelInfo values(1852,'复审',7) 
/
insert into HtmlLabelInfo values(1853,'',8) 
/
insert into HtmlLabelInfo values(1853,'录用',7) 
/
insert into HtmlLabelInfo values(1854,'',8) 
/
insert into HtmlLabelInfo values(1854,'应聘回复(邮件)',7) 
/
insert into HtmlLabelInfo values(1855,'',8) 
/
insert into HtmlLabelInfo values(1855,'应聘日期',7) 
/
insert into HtmlLabelInfo values(1856,'',8) 
/
insert into HtmlLabelInfo values(1856,'应聘职位',7) 
/
insert into HtmlLabelInfo values(1857,'',8) 
/
insert into HtmlLabelInfo values(1857,'工作国家',7) 
/
insert into HtmlLabelInfo values(1858,'',8) 
/
insert into HtmlLabelInfo values(1858,'职位描述',7) 
/
insert into HtmlLabelInfo values(1859,'',8) 
/
insert into HtmlLabelInfo values(1859,'人数',7) 
/
insert into HtmlLabelInfo values(1860,'',8) 
/
insert into HtmlLabelInfo values(1860,'最低学历',7) 
/
insert into HtmlLabelInfo values(1861,'',8) 
/
insert into HtmlLabelInfo values(1861,'发布人',7) 
/
insert into HtmlLabelInfo values(1862,'',8) 
/
insert into HtmlLabelInfo values(1862,'发布时间',7) 
/
insert into HtmlLabelInfo values(1863,'',8) 
/
insert into HtmlLabelInfo values(1863,'应聘',7) 
/
insert into HtmlLabelInfo values(1864,'',8) 
/
insert into HtmlLabelInfo values(1864,'需求人数',7) 
/
insert into HtmlLabelInfo values(1865,'',8) 
/
insert into HtmlLabelInfo values(1865,'职位种类',7) 
/
insert into HtmlLabelInfo values(1866,'',8) 
/
insert into HtmlLabelInfo values(1866,'用工方式',7) 
/
insert into HtmlLabelInfo values(1867,'',8) 
/
insert into HtmlLabelInfo values(1867,'人员',7) 
/
insert into HtmlLabelInfo values(1868,'',8) 
/
insert into HtmlLabelInfo values(1868,'人员要求',7) 
/
insert into HtmlLabelInfo values(1869,'',8) 
/
insert into HtmlLabelInfo values(1869,'常用查询条件',7) 
/
insert into HtmlLabelInfo values(1870,'',8) 
/
insert into HtmlLabelInfo values(1870,'曾就读学校',7) 
/
insert into HtmlLabelInfo values(1871,'',8) 
/
insert into HtmlLabelInfo values(1871,'曾就业公司',7) 
/
insert into HtmlLabelInfo values(1872,'',8) 
/
insert into HtmlLabelInfo values(1872,'年，期间',7) 
/
insert into HtmlLabelInfo values(1873,'',8) 
/
insert into HtmlLabelInfo values(1873,'指示器,成本中心',7) 
/
insert into HtmlLabelInfo values(1874,'',8) 
/
insert into HtmlLabelInfo values(1874,'货币, 因素',7) 
/
insert into HtmlLabelInfo values(1875,'',8) 
/
insert into HtmlLabelInfo values(1875,'比较, 版本',7) 
/
insert into HtmlLabelInfo values(1876,'',8) 
/
insert into HtmlLabelInfo values(1876,'上一步',7) 
/
insert into HtmlLabelInfo values(1877,'',8) 
/
insert into HtmlLabelInfo values(1877,'还没有键入符合标准的数据。',7) 
/
insert into HtmlLabelInfo values(1878,'',8) 
/
insert into HtmlLabelInfo values(1878,'分部名称',7) 
/
insert into HtmlLabelInfo values(1879,'',8) 
/
insert into HtmlLabelInfo values(1879,'分部描述',7) 
/
insert into HtmlLabelInfo values(1880,'',8) 
/
insert into HtmlLabelInfo values(1880,'所属总部',7) 
/
insert into HtmlLabelInfo values(1881,'',8) 
/
insert into HtmlLabelInfo values(1881,'请假类型',7) 
/
insert into HtmlLabelInfo values(1882,'',8) 
/
insert into HtmlLabelInfo values(1882,'课程',7) 
/
insert into HtmlLabelInfo values(1883,'',8) 
/
insert into HtmlLabelInfo values(1883,'工作流-统计报告',7) 
/
insert into HtmlLabelInfo values(1884,'',8) 
/
insert into HtmlLabelInfo values(1884,'出生年月',7) 
/
insert into HtmlLabelInfo values(1885,'',8) 
/
insert into HtmlLabelInfo values(1885,'出生地',7) 
/
insert into HtmlLabelInfo values(1886,'',8) 
/
insert into HtmlLabelInfo values(1886,'民族',7) 
/
insert into HtmlLabelInfo values(1887,'',8) 
/
insert into HtmlLabelInfo values(1887,'身份证号码',7) 
/
insert into HtmlLabelInfo values(1888,'',8) 
/
insert into HtmlLabelInfo values(1888,'待复审',7) 
/
insert into HtmlLabelInfo values(1889,'',8) 
/
insert into HtmlLabelInfo values(1889,'高级查询条件',7) 
/
insert into HtmlLabelInfo values(1890,'',8) 
/
insert into HtmlLabelInfo values(1890,'计数(小时)',7) 
/
insert into HtmlLabelInfo values(1891,'',8) 
/
insert into HtmlLabelInfo values(1891,'部门-人力资源',7) 
/
insert into HtmlLabelInfo values(1892,'',8) 
/
insert into HtmlLabelInfo values(1892,'人次',7) 
/
insert into HtmlLabelInfo values(1893,'',8) 
/
insert into HtmlLabelInfo values(1893,'基本工资',7) 
/
insert into HtmlLabelInfo values(1894,'',8) 
/
insert into HtmlLabelInfo values(1894,'房贴',7) 
/
insert into HtmlLabelInfo values(1895,'',8) 
/
insert into HtmlLabelInfo values(1895,'车贴',7) 
/
insert into HtmlLabelInfo values(1896,'',8) 
/
insert into HtmlLabelInfo values(1896,'饭贴',7) 
/
insert into HtmlLabelInfo values(1897,'',8) 
/
insert into HtmlLabelInfo values(1897,'调整原因',7) 
/
insert into HtmlLabelInfo values(1898,'',8) 
/
insert into HtmlLabelInfo values(1898,'主要学历',7) 
/
insert into HtmlLabelInfo values(1899,'',8) 
/
insert into HtmlLabelInfo values(1899,'邮编',7) 
/
insert into HtmlLabelInfo values(1900,'',8) 
/
insert into HtmlLabelInfo values(1900,'户籍住址',7) 
/
insert into HtmlLabelInfo values(1901,'',8) 
/
insert into HtmlLabelInfo values(1901,'政治身份',7) 
/
insert into HtmlLabelInfo values(1902,'',8) 
/
insert into HtmlLabelInfo values(1902,'主要学历',7) 
/
insert into HtmlLabelInfo values(1903,'',8) 
/
insert into HtmlLabelInfo values(1903,'学校名称',7) 
/
insert into HtmlLabelInfo values(1904,'',8) 
/
insert into HtmlLabelInfo values(1904,'所学专业',7) 
/
insert into HtmlLabelInfo values(1905,'',8) 
/
insert into HtmlLabelInfo values(1905,'颁发机构',7) 
/
insert into HtmlLabelInfo values(1906,'',8) 
/
insert into HtmlLabelInfo values(1906,'入职前工作经历',7) 
/
insert into HtmlLabelInfo values(1907,'',8) 
/
insert into HtmlLabelInfo values(1907,'入职后工作经历',7) 
/
insert into HtmlLabelInfo values(1908,'',8) 
/
insert into HtmlLabelInfo values(1908,'入职时间',7) 
/
insert into HtmlLabelInfo values(1909,'',8) 
/
insert into HtmlLabelInfo values(1909,'职级',7) 
/
insert into HtmlLabelInfo values(1910,'',8) 
/
insert into HtmlLabelInfo values(1910,'成就和论著',7) 
/
insert into HtmlLabelInfo values(1911,'',8) 
/
insert into HtmlLabelInfo values(1911,'曾受到何种奖励、处罚',7) 
/
insert into HtmlLabelInfo values(1912,'',8) 
/
insert into HtmlLabelInfo values(1912,'主要家庭成员',7) 
/
insert into HtmlLabelInfo values(1913,'',8) 
/
insert into HtmlLabelInfo values(1913,'与本人关系',7) 
/
insert into HtmlLabelInfo values(1914,'',8) 
/
insert into HtmlLabelInfo values(1914,'工作单位',7) 
/
insert into HtmlLabelInfo values(1915,'',8) 
/
insert into HtmlLabelInfo values(1915,'职务',7) 
/
insert into HtmlLabelInfo values(1916,'',8) 
/
insert into HtmlLabelInfo values(1916,'联系电话',7) 
/
insert into HtmlLabelInfo values(1917,'',8) 
/
insert into HtmlLabelInfo values(1917,'公司内部奖惩记录',7) 
/
insert into HtmlLabelInfo values(1918,'',8) 
/
insert into HtmlLabelInfo values(1918,'薪酬福利待遇',7) 
/
insert into HtmlLabelInfo values(1919,'',8) 
/
insert into HtmlLabelInfo values(1919,'病假',7) 
/
insert into HtmlLabelInfo values(1920,'',8) 
/
insert into HtmlLabelInfo values(1920,'事假',7) 
/
insert into HtmlLabelInfo values(1921,'',8) 
/
insert into HtmlLabelInfo values(1921,'产假',7) 
/
insert into HtmlLabelInfo values(1922,'',8) 
/
insert into HtmlLabelInfo values(1922,'婚丧假',7) 
/
insert into HtmlLabelInfo values(1923,'',8) 
/
insert into HtmlLabelInfo values(1923,'休假',7) 
/
insert into HtmlLabelInfo values(1924,'',8) 
/
insert into HtmlLabelInfo values(1924,'缺勤',7) 
/
insert into HtmlLabelInfo values(1925,'',8) 
/
insert into HtmlLabelInfo values(1925,'天',7) 
/
insert into HtmlLabelInfo values(1926,'',8) 
/
insert into HtmlLabelInfo values(1926,'周',7) 
/
insert into HtmlLabelInfo values(1927,'',8) 
/
insert into HtmlLabelInfo values(1927,'图示',7) 
/
insert into HtmlLabelInfo values(1928,'',8) 
/
insert into HtmlLabelInfo values(1928,'无效的日期',7) 
/
insert into HtmlLabelInfo values(1929,'',8) 
/
insert into HtmlLabelInfo values(1929,'当前状态',7) 
/
insert into HtmlLabelInfo values(1930,'',8) 
/
insert into HtmlLabelInfo values(1930,'现居住地电话',7) 
/
insert into HtmlLabelInfo values(1931,'',8) 
/
insert into HtmlLabelInfo values(1931,'现居住地邮编',7) 
/
insert into HtmlLabelInfo values(1932,'',8) 
/
insert into HtmlLabelInfo values(1932,'应聘人',7) 
/
insert into HtmlLabelInfo values(1933,'',8) 
/
insert into HtmlLabelInfo values(1933,'工号',7) 
/
insert into HtmlLabelInfo values(1934,'',8) 
/
insert into HtmlLabelInfo values(1934,'工种',7) 
/
insert into HtmlLabelInfo values(1935,'',8) 
/
insert into HtmlLabelInfo values(1935,'工作开始日期',7) 
/
insert into HtmlLabelInfo values(1936,'',8) 
/
insert into HtmlLabelInfo values(1936,'合同开始时间',7) 
/
insert into HtmlLabelInfo values(1937,'',8) 
/
insert into HtmlLabelInfo values(1937,'现职称',7) 
/
insert into HtmlLabelInfo values(1938,'',8) 
/
insert into HtmlLabelInfo values(1938,'工作权力',7) 
/
insert into HtmlLabelInfo values(1939,'',8) 
/
insert into HtmlLabelInfo values(1939,'公积金帐号',7) 
/
insert into HtmlLabelInfo values(1940,'',8) 
/
insert into HtmlLabelInfo values(1940,'工作开始时间',7) 
/
insert into HtmlLabelInfo values(1941,'',8) 
/
insert into HtmlLabelInfo values(1941,'支付银行',7) 
/
insert into HtmlLabelInfo values(1942,'',8) 
/
insert into HtmlLabelInfo values(1942,'详细描述',7) 
/
insert into HtmlLabelInfo values(1943,'',8) 
/
insert into HtmlLabelInfo values(1943,'家庭成员',7) 
/
insert into HtmlLabelInfo values(1944,'',8) 
/
insert into HtmlLabelInfo values(1944,'称谓',7) 
/
insert into HtmlLabelInfo values(1945,'',8) 
/
insert into HtmlLabelInfo values(1945,'因公流入',7) 
/
insert into HtmlLabelInfo values(1946,'',8) 
/
insert into HtmlLabelInfo values(1946,'因公流出',7) 
/
insert into HtmlLabelInfo values(1947,'',8) 
/
insert into HtmlLabelInfo values(1947,'因私流入',7) 
/
insert into HtmlLabelInfo values(1948,'',8) 
/
insert into HtmlLabelInfo values(1948,'因私流出',7) 
/
insert into HtmlLabelInfo values(1949,'',8) 
/
insert into HtmlLabelInfo values(1949,'费用报销',7) 
/
insert into HtmlLabelInfo values(1950,'',8) 
/
insert into HtmlLabelInfo values(1950,'普通费用申请',7) 
/
insert into HtmlLabelInfo values(1951,'',8) 
/
insert into HtmlLabelInfo values(1951,'出差费用申请',7) 
/
insert into HtmlLabelInfo values(1952,'',8) 
/
insert into HtmlLabelInfo values(1952,'私人还款',7) 
/
insert into HtmlLabelInfo values(1953,'',8) 
/
insert into HtmlLabelInfo values(1953,'私人借款',7) 
/
insert into HtmlLabelInfo values(1954,'',8) 
/
insert into HtmlLabelInfo values(1954,'语种',7) 
/
insert into HtmlLabelInfo values(1955,'',8) 
/
insert into HtmlLabelInfo values(1955,'项目相关',7) 
/
insert into HtmlLabelInfo values(1956,'',8) 
/
insert into HtmlLabelInfo values(1956,'缺勤相关',7) 
/
insert into HtmlLabelInfo values(1957,'',8) 
/
insert into HtmlLabelInfo values(1957,'加班相关',7) 
/
insert into HtmlLabelInfo values(1958,'',8) 
/
insert into HtmlLabelInfo values(1958,'普通加班',7) 
/
insert into HtmlLabelInfo values(1959,'',8) 
/
insert into HtmlLabelInfo values(1959,'节假日加班',7) 
/
insert into HtmlLabelInfo values(1960,'',8) 
/
insert into HtmlLabelInfo values(1960,'进行中',7) 
/
insert into HtmlLabelInfo values(1961,'',8) 
/
insert into HtmlLabelInfo values(1961,'已完成',7) 
/
insert into HtmlLabelInfo values(1962,'',8) 
/
insert into HtmlLabelInfo values(1962,'奖惩日期',7) 
/
insert into HtmlLabelInfo values(1963,'',8) 
/
insert into HtmlLabelInfo values(1963,'录入员',7) 
/
insert into HtmlLabelInfo values(1964,'生日',7) 
/
insert into HtmlLabelInfo values(1964,'生日',8) 
/
insert into HtmlLabelInfo values(1965,'',8) 
/
insert into HtmlLabelInfo values(1965,'结婚日期',7) 
/
insert into HtmlLabelInfo values(1966,'入团,入党日期',7) 
/
insert into HtmlLabelInfo values(1966,'入团,入党日期',8) 
/
insert into HtmlLabelInfo values(1967,'Home address',8) 
/
insert into HtmlLabelInfo values(1967,'家庭地址',7) 
/
insert into HtmlLabelInfo values(1968,'家庭邮编',7) 
/
insert into HtmlLabelInfo values(1968,'家庭邮编',8) 
/
insert into HtmlLabelInfo values(1969,'家庭电话',7) 
/
insert into HtmlLabelInfo values(1969,'家庭电话',8) 
/
insert into HtmlLabelInfo values(1970,'Contract start time',8) 
/
insert into HtmlLabelInfo values(1970,'合同开始日期',7) 
/
insert into HtmlLabelInfo values(1971,'培训开始时间',7) 
/
insert into HtmlLabelInfo values(1971,'培训开始时间',8) 
/
insert into HtmlLabelInfo values(1972,'Training finish time',8) 
/
insert into HtmlLabelInfo values(1972,'培训结束时间',7) 
/
insert into HtmlLabelInfo values(1973,'学时(小时)',7) 
/
insert into HtmlLabelInfo values(1973,'学时(小时)',8) 
/
insert into HtmlLabelInfo values(1974,'培训单位',7) 
/
insert into HtmlLabelInfo values(1974,'培训单位',8) 
/
insert into HtmlLabelInfo values(1975,'Company character',8) 
/
insert into HtmlLabelInfo values(1975,'公司性质',7) 
/
insert into HtmlLabelInfo values(1976,'公司名称',7) 
/
insert into HtmlLabelInfo values(1976,'公司名称',8) 
/
insert into HtmlLabelInfo values(1977,'Describe for work',8) 
/
insert into HtmlLabelInfo values(1977,'工作描述',7) 
/
insert into HtmlLabelInfo values(1978,'离职原因',7) 
/
insert into HtmlLabelInfo values(1978,'离职原因',8) 
/
insert into HtmlLabelInfo values(1979,'Not start',8) 
/
insert into HtmlLabelInfo values(1979,'未开始',7) 
/
insert into HtmlLabelInfo values(1980,'等待他人',7) 
/
insert into HtmlLabelInfo values(1980,'等待他人',8) 
/
insert into HtmlLabelInfo values(1981,'已撤销',7) 
/
insert into HtmlLabelInfo values(1981,'已撤销',8) 
/
insert into HtmlLabelInfo values(1982,'超期',7) 
/
insert into HtmlLabelInfo values(1982,'超期',8) 
/
insert into HtmlLabelInfo values(1983,'文档复制移动',7) 
/
insert into HtmlLabelInfo values(1983,'文档复制移动',8) 
/
insert into HtmlLabelInfo values(1984,'正常',7) 
/
insert into HtmlLabelInfo values(1984,'正常',8) 
/
insert into HtmlLabelInfo values(1985,'文档共享',7) 
/
insert into HtmlLabelInfo values(1985,'文档共享',8) 
/
insert into HtmlLabelInfo values(1986,'新建文档',7) 
/
insert into HtmlLabelInfo values(1986,'新建文档',8) 
/
insert into HtmlLabelInfo values(1987,'',8) 
/
insert into HtmlLabelInfo values(1987,'颜色',7) 
/
insert into HtmlLabelInfo values(1988,'插入行数',7) 
/
insert into HtmlLabelInfo values(1988,'插入行数',8) 
/
insert into HtmlLabelInfo values(1989,'插入列数',7) 
/
insert into HtmlLabelInfo values(1989,'插入列数',8) 
/
insert into HtmlLabelInfo values(1990,'表属性',7) 
/
insert into HtmlLabelInfo values(1990,'表属性',8) 
/
insert into HtmlLabelInfo values(1991,'单元格属性',7) 
/
insert into HtmlLabelInfo values(1991,'单元格属性',8) 
/
insert into HtmlLabelInfo values(1992,'内部设定',7) 
/
insert into HtmlLabelInfo values(1992,'内部设定',8) 
/
insert into HtmlLabelInfo values(1993,'发布类型',7) 
/
insert into HtmlLabelInfo values(1993,'发布类型',8) 
/
insert into HtmlLabelInfo values(1994,'Inside',8) 
/
insert into HtmlLabelInfo values(1994,'内部',7) 
/
insert into HtmlLabelInfo values(1995,'外部',7) 
/
insert into HtmlLabelInfo values(1995,'外部',8) 
/
insert into HtmlLabelInfo values(1996,'显示语言',7) 
/
insert into HtmlLabelInfo values(1996,'显示语言',8) 
/
insert into HtmlLabelInfo values(1997,'Chinese',8) 
/
insert into HtmlLabelInfo values(1997,'中文',7) 
/
insert into HtmlLabelInfo values(1998,'',8) 
/
insert into HtmlLabelInfo values(1998,'英文',7) 
/
insert into HtmlLabelInfo values(1999,'',8) 
/
insert into HtmlLabelInfo values(1999,'新闻页的附加显示条件.例如',7) 
/
insert into HtmlLabelInfo values(2000,'文档摘要',7) 
/
insert into HtmlLabelInfo values(2000,'文档摘要',8) 
/
insert into HtmlLabelInfo values(2001,'回复文档数',7) 
/
insert into HtmlLabelInfo values(2001,'回复文档数',8) 
/
insert into HtmlLabelInfo values(2002,'附件数',7) 
/
insert into HtmlLabelInfo values(2002,'附件数',8) 
/
insert into HtmlLabelInfo values(2003,'文档总数为',7) 
/
insert into HtmlLabelInfo values(2004,'其中非回复',7) 
/
insert into HtmlLabelInfo values(2004,'其中非回复',8) 
/
insert into HtmlLabelInfo values(2005,'关健字',7) 
/
insert into HtmlLabelInfo values(2005,'关健字',8) 
/
insert into HtmlLabelInfo values(2006,'显示回复总数',7) 
/
insert into HtmlLabelInfo values(2006,'显示回复总数',8) 
/
insert into HtmlLabelInfo values(2007,'显示附件总数',7) 
/
insert into HtmlLabelInfo values(2007,'显示附件总数',8) 
/
insert into HtmlLabelInfo values(2008,'默认文档显示模板',7) 
/
insert into HtmlLabelInfo values(2008,'默认文档显示模板',8) 
/
insert into HtmlLabelInfo values(2009,'Documents of news page',8) 
/
insert into HtmlLabelInfo values(2009,'新闻页文档',7) 
/
insert into HtmlLabelInfo values(2010,'新闻页背景',7) 
/
insert into HtmlLabelInfo values(2010,'新闻页背景',8) 
/
insert into HtmlLabelInfo values(2011,'没有权限',7) 
/
insert into HtmlLabelInfo values(2011,'没有权限',8) 
/
insert into HtmlLabelInfo values(2012,'对不起，您暂时没有权限！',7) 
/
insert into HtmlLabelInfo values(2012,'对不起，您暂时没有权限！',8) 
/
insert into HtmlLabelInfo values(2013,'请返回或者进入不同的页面',7) 
/
insert into HtmlLabelInfo values(2013,'请返回或者进入不同的页面',8) 
/
insert into HtmlLabelInfo values(2014,'总计: 项目',7) 
/
insert into HtmlLabelInfo values(2014,'总计: 项目',8) 
/
insert into HtmlLabelInfo values(2015,'总计: 资产',7) 
/
insert into HtmlLabelInfo values(2015,'总计: 资产',8) 
/
insert into HtmlLabelInfo values(2016,'Resource:real',7) 
/
insert into HtmlLabelInfo values(2016,'Resource:real',8) 
/
insert into HtmlLabelInfo values(2017,'Chart:cost center',8) 
/
insert into HtmlLabelInfo values(2017,'组织图表:成本中心',7) 
/
insert into HtmlLabelInfo values(2018,'总计: 客户',7) 
/
insert into HtmlLabelInfo values(2018,'总计: 客户',8) 
/
insert into HtmlLabelInfo values(2019,'Sum',8) 
/
insert into HtmlLabelInfo values(2019,'总价',7) 
/
insert into HtmlLabelInfo values(2020,'剩余总价',7) 
/
insert into HtmlLabelInfo values(2020,'剩余总价',8) 
/
insert into HtmlLabelInfo values(2021,'总计: 文档',7) 
/
insert into HtmlLabelInfo values(2021,'总计: 文档',8) 
/
insert into HtmlLabelInfo values(2022,'Reset',8) 
/
insert into HtmlLabelInfo values(2022,'重置',7) 
/
insert into HtmlLabelInfo values(2023,'登录信息',7) 
/
insert into HtmlLabelInfo values(2023,'登录信息',8) 
/
insert into HtmlLabelInfo values(2024,'帐号',7) 
/
insert into HtmlLabelInfo values(2024,'帐号',8) 
/
insert into HtmlLabelInfo values(2025,'Save password',8) 
/
insert into HtmlLabelInfo values(2025,'保存密码',7) 
/
insert into HtmlLabelInfo values(2026,'Group',8) 
/
insert into HtmlLabelInfo values(2026,'组',7) 
/
insert into HtmlLabelInfo values(2027,'>邮件用户组已存在，请重新输入组名',7) 
/
insert into HtmlLabelInfo values(2027,'>邮件用户组已存在，请重新输入组名',8) 
/
insert into HtmlLabelInfo values(2028,'User exist,please enter the user name again',8) 
/
insert into HtmlLabelInfo values(2028,'用户已存在邮件用户组，请重选择用户名',7) 
/
insert into HtmlLabelInfo values(2029,'新建邮件',7) 
/
insert into HtmlLabelInfo values(2029,'新建邮件',8) 
/
insert into HtmlLabelInfo values(2030,'删除邮件',7) 
/
insert into HtmlLabelInfo values(2030,'删除邮件',8) 
/
insert into HtmlLabelInfo values(2031,'Permanently delete',8) 
/
insert into HtmlLabelInfo values(2031,'永久删除',7) 
/
insert into HtmlLabelInfo values(2032,'邮件菜单',7) 
/
insert into HtmlLabelInfo values(2032,'邮件菜单',8) 
/
insert into HtmlLabelInfo values(2033,'Folder',8) 
/
insert into HtmlLabelInfo values(2033,'邮件夹',7) 
/
insert into HtmlLabelInfo values(2034,'From',8) 
/
insert into HtmlLabelInfo values(2034,'发件人',7) 
/
insert into HtmlLabelInfo values(2035,'发件时间',7) 
/
insert into HtmlLabelInfo values(2035,'发件时间',8) 
/
insert into HtmlLabelInfo values(2036,'大小',7) 
/
insert into HtmlLabelInfo values(2036,'大小',8) 
/
insert into HtmlLabelInfo values(2037,'本地邮件',7) 
/
insert into HtmlLabelInfo values(2037,'本地邮件',8) 
/
insert into HtmlLabelInfo values(2038,'发件箱',7) 
/
insert into HtmlLabelInfo values(2038,'发件箱',8) 
/
insert into HtmlLabelInfo values(2039,'草稿箱',7) 
/
insert into HtmlLabelInfo values(2039,'草稿箱',8) 
/
insert into HtmlLabelInfo values(2040,'垃圾箱',7) 
/
insert into HtmlLabelInfo values(2040,'垃圾箱',8) 
/
insert into HtmlLabelInfo values(2041,'',8) 
/
insert into HtmlLabelInfo values(2041,'永久删除',7) 
/
insert into HtmlLabelInfo values(2042,'本地邮件箱',7) 
/
insert into HtmlLabelInfo values(2042,'本地邮件箱',8) 
/
insert into HtmlLabelInfo values(2043,'Mail box',8) 
/
insert into HtmlLabelInfo values(2043,'邮件箱',7) 
/
insert into HtmlLabelInfo values(2044,'邮件发送成功',7) 
/
insert into HtmlLabelInfo values(2044,'邮件发送成功',8) 
/
insert into HtmlLabelInfo values(2045,'邮件发送失败',7) 
/
insert into HtmlLabelInfo values(2045,'邮件发送失败',8) 
/
insert into HtmlLabelInfo values(2046,'收件人',7) 
/
insert into HtmlLabelInfo values(2046,'收件人',8) 
/
insert into HtmlLabelInfo values(2047,'发件日期',7) 
/
insert into HtmlLabelInfo values(2047,'发件日期',8) 
/
insert into HtmlLabelInfo values(2048,'Move to outbox',8) 
/
insert into HtmlLabelInfo values(2048,'移至发件箱',7) 
/
insert into HtmlLabelInfo values(2049,'移至草稿箱',7) 
/
insert into HtmlLabelInfo values(2049,'移至草稿箱',8) 
/
insert into HtmlLabelInfo values(2050,'移至本地',7) 
/
insert into HtmlLabelInfo values(2050,'移至本地',8) 
/
insert into HtmlLabelInfo values(15881,'',8) 
/
insert into HtmlLabelInfo values(15882,'人事管理',7) 
/
insert into HtmlLabelInfo values(15882,'',8) 
/
insert into HtmlLabelInfo values(15883,'新增人员',7) 
/
insert into HtmlLabelInfo values(15883,'',8) 
/
insert into HtmlLabelInfo values(15884,'返聘',7) 
/
insert into HtmlLabelInfo values(15884,'',8) 
/
insert into HtmlLabelInfo values(15885,'应聘人员',7) 
/
insert into HtmlLabelInfo values(15885,'',8) 
/
insert into HtmlLabelInfo values(15886,'德隆国际战略投资有限公司',7) 
/
insert into HtmlLabelInfo values(15886,'',8) 
/
insert into HtmlLabelInfo values(15887,'年龄层次统计图',7) 
/
insert into HtmlLabelInfo values(15887,'',8) 
/
insert into HtmlLabelInfo values(15888,'人员安全级别统计',7) 
/
insert into HtmlLabelInfo values(15888,'',8) 
/
insert into HtmlLabelInfo values(15889,'人员性别统计',7) 
/
insert into HtmlLabelInfo values(15889,'',8) 
/
insert into HtmlLabelInfo values(15890,'员工状态',7) 
/
insert into HtmlLabelInfo values(15890,'',8) 
/
insert into HtmlLabelInfo values(15891,'人员状态统计',7) 
/
insert into HtmlLabelInfo values(15891,'',8) 
/
insert into HtmlLabelInfo values(15892,'规划名称',7) 
/
insert into HtmlLabelInfo values(15892,'',8) 
/
insert into HtmlLabelInfo values(15893,'规划考评人',7) 
/
insert into HtmlLabelInfo values(15893,'',8) 
/
insert into HtmlLabelInfo values(15894,'规划考评时间',7) 
/
insert into HtmlLabelInfo values(15894,'',8) 
/
insert into HtmlLabelInfo values(15895,'规划开始时间',7) 
/
insert into HtmlLabelInfo values(15895,'',8) 
/
insert into HtmlLabelInfo values(15896,'规划结束时间',7) 
/
insert into HtmlLabelInfo values(15896,'',8) 
/
insert into HtmlLabelInfo values(15897,'规划内容',7) 
/
insert into HtmlLabelInfo values(15897,'',8) 
/
insert into HtmlLabelInfo values(15898,'规划目的',7) 
/
insert into HtmlLabelInfo values(15898,'',8) 
/
insert into HtmlLabelInfo values(15899,'参加率',7) 
/
insert into HtmlLabelInfo values(15899,'',8) 
/
insert into HtmlLabelInfo values(15900,'培训规划名称',7) 
/
insert into HtmlLabelInfo values(15900,'',8) 
/
insert into HtmlLabelInfo values(15901,'相关活动考核情况',7) 
/
insert into HtmlLabelInfo values(15901,'',8) 
/
insert into HtmlLabelInfo values(15902,'相关活动考评情况',7) 
/
insert into HtmlLabelInfo values(15902,'',8) 
/
insert into HtmlLabelInfo values(15903,'相关培训活',7) 
/
insert into HtmlLabelInfo values(15903,'',8) 
/
insert into HtmlLabelInfo values(15904,'动考核情况',7) 
/
insert into HtmlLabelInfo values(15904,'',8) 
/
insert into HtmlLabelInfo values(15905,'动考评情况',7) 
/
insert into HtmlLabelInfo values(15905,'',8) 
/
insert into HtmlLabelInfo values(15906,'极差率',7) 
/
insert into HtmlLabelInfo values(15906,'',8) 
/
insert into HtmlLabelInfo values(15907,'差率',7) 
/
insert into HtmlLabelInfo values(15907,'',8) 
/
insert into HtmlLabelInfo values(15908,'一般率',7) 
/
insert into HtmlLabelInfo values(15908,'',8) 
/
insert into HtmlLabelInfo values(15909,'好率',7) 
/
insert into HtmlLabelInfo values(15909,'',8) 
/
insert into HtmlLabelInfo values(15910,'很好率',7) 
/
insert into HtmlLabelInfo values(15910,'',8) 
/
insert into HtmlLabelInfo values(15911,'不及格率',7) 
/
insert into HtmlLabelInfo values(15911,'',8) 
/
insert into HtmlLabelInfo values(15912,'及格率',7) 
/
insert into HtmlLabelInfo values(15912,'',8) 
/
insert into HtmlLabelInfo values(15913,'良好率',7) 
/
insert into HtmlLabelInfo values(15913,'',8) 
/
insert into HtmlLabelInfo values(15914,'优秀率',7) 
/
insert into HtmlLabelInfo values(15914,'',8) 
/
insert into HtmlLabelInfo values(15915,'培训组织人',7) 
/
insert into HtmlLabelInfo values(15915,'',8) 
/
insert into HtmlLabelInfo values(15916,'培训内容',7) 
/
insert into HtmlLabelInfo values(15916,'',8) 
/
insert into HtmlLabelInfo values(15917,'培训目的',7) 
/
insert into HtmlLabelInfo values(15917,'',8) 
/
insert into HtmlLabelInfo values(15918,'培训地点',7) 
/
insert into HtmlLabelInfo values(15918,'',8) 
/
insert into HtmlLabelInfo values(15919,'活动名称',7) 
/
insert into HtmlLabelInfo values(15919,'',8) 
/
insert into HtmlLabelInfo values(15920,'考核情况',7) 
/
insert into HtmlLabelInfo values(15920,'',8) 
/
insert into HtmlLabelInfo values(15921,'培训规划相关情况',7) 
/
insert into HtmlLabelInfo values(15921,'',8) 
/
insert into HtmlLabelInfo values(15922,'培训活动相关情况',7) 
/
insert into HtmlLabelInfo values(15922,'',8) 
/
insert into HtmlLabelInfo values(15923,'培训资源名称',7) 
/
insert into HtmlLabelInfo values(15923,'',8) 
/
insert into HtmlLabelInfo values(15924,'资源名称',7) 
/
insert into HtmlLabelInfo values(15924,'',8) 
/
insert into HtmlLabelInfo values(15925,'培训资源考评情况',7) 
/
insert into HtmlLabelInfo values(15925,'',8) 
/
insert into HtmlLabelInfo values(15926,'人员用工性质统计',7) 
/
insert into HtmlLabelInfo values(15926,'',8) 
/
insert into HtmlLabelInfo values(15927,'工龄区间',7) 
/
insert into HtmlLabelInfo values(15927,'',8) 
/
insert into HtmlLabelInfo values(15928,'人员工龄统计',7) 
/
insert into HtmlLabelInfo values(15928,'',8) 
/
insert into HtmlLabelInfo values(15929,'人力资源报表',7) 
/
insert into HtmlLabelInfo values(15929,'',8) 
/
insert into HtmlLabelInfo values(15930,'列名',7) 
/
insert into HtmlLabelInfo values(15930,'',8) 
/
insert into HtmlLabelInfo values(15931,'应聘类型',7) 
/
insert into HtmlLabelInfo values(15931,'',8) 
/
insert into HtmlLabelInfo values(15932,'间距',7) 
/
insert into HtmlLabelInfo values(15932,'',8) 
/
insert into HtmlLabelInfo values(15933,'年份',7) 
/
insert into HtmlLabelInfo values(15933,'',8) 
/
insert into HtmlLabelInfo values(15934,'到位日期',7) 
/
insert into HtmlLabelInfo values(15934,'',8) 
/
insert into HtmlLabelInfo values(15935,'显示内容',7) 
/
insert into HtmlLabelInfo values(15935,'',8) 
/
insert into HtmlLabelInfo values(15936,'应聘人员人数统计',7) 
/
insert into HtmlLabelInfo values(15936,'',8) 
/
insert into HtmlLabelInfo values(15937,'应聘类别',7) 
/
insert into HtmlLabelInfo values(15937,'',8) 
/
insert into HtmlLabelInfo values(15938,'人数统计',7) 
/
insert into HtmlLabelInfo values(15938,'',8) 
/
insert into HtmlLabelInfo values(15939,'合同报表',7) 
/
insert into HtmlLabelInfo values(15939,'',8) 
/
insert into HtmlLabelInfo values(15940,'年合同报表',7) 
/
insert into HtmlLabelInfo values(15940,'',8) 
/
insert into HtmlLabelInfo values(15941,'部门合同统计',7) 
/
insert into HtmlLabelInfo values(15941,'',8) 
/
insert into HtmlLabelInfo values(15942,'合同类别统计',7) 
/
insert into HtmlLabelInfo values(15942,'',8) 
/
insert into HtmlLabelInfo values(15943,'合同时间统计',7) 
/
insert into HtmlLabelInfo values(15943,'',8) 
/
insert into HtmlLabelInfo values(15944,'合同结束时间',7) 
/
insert into HtmlLabelInfo values(15944,'',8) 
/
insert into HtmlLabelInfo values(15945,'总人次',7) 
/
insert into HtmlLabelInfo values(15945,'',8) 
/
insert into HtmlLabelInfo values(15946,'合同数',7) 
/
insert into HtmlLabelInfo values(15946,'',8) 
/
insert into HtmlLabelInfo values(15947,'合同部门统计',7) 
/
insert into HtmlLabelInfo values(15947,'',8) 
/
insert into HtmlLabelInfo values(15948,'合同统计',7) 
/
insert into HtmlLabelInfo values(15948,'',8) 
/
insert into HtmlLabelInfo values(15949,'合同具体信息报表',7) 
/
insert into HtmlLabelInfo values(15949,'',8) 
/
insert into HtmlLabelInfo values(15950,'合同部门',7) 
/
insert into HtmlLabelInfo values(15950,'',8) 
/
insert into HtmlLabelInfo values(15951,'合同岗位',7) 
/
insert into HtmlLabelInfo values(15951,'',8) 
/
insert into HtmlLabelInfo values(15952,'合同时间',7) 
/
insert into HtmlLabelInfo values(15952,'',8) 
/
insert into HtmlLabelInfo values(15953,'合同日期',7) 
/
insert into HtmlLabelInfo values(15953,'',8) 
/
insert into HtmlLabelInfo values(15954,'续签时间统计',7) 
/
insert into HtmlLabelInfo values(15954,'',8) 
/
insert into HtmlLabelInfo values(15955,'离职报表',7) 
/
insert into HtmlLabelInfo values(15955,'',8) 
/
insert into HtmlLabelInfo values(15956,'年离职报表',7) 
/
insert into HtmlLabelInfo values(15956,'',8) 
/
insert into HtmlLabelInfo values(15957,'部门离职统计',7) 
/
insert into HtmlLabelInfo values(15957,'',8) 
/
insert into HtmlLabelInfo values(15958,'离职时间统计',7) 
/
insert into HtmlLabelInfo values(15958,'',8) 
/
insert into HtmlLabelInfo values(15959,'离职部门统计',7) 
/
insert into HtmlLabelInfo values(15959,'',8) 
/
insert into HtmlLabelInfo values(15960,'离职具体信息报表',7) 
/
insert into HtmlLabelInfo values(15960,'',8) 
/
insert into HtmlLabelInfo values(15961,'离职日期',7) 
/
insert into HtmlLabelInfo values(15961,'',8) 
/
insert into HtmlLabelInfo values(15962,'续签报表',7) 
/
insert into HtmlLabelInfo values(15962,'',8) 
/
insert into HtmlLabelInfo values(15963,'年续签报表',7) 
/
insert into HtmlLabelInfo values(15963,'',8) 
/
insert into HtmlLabelInfo values(15964,'部门续签统计',7) 
/
insert into HtmlLabelInfo values(15964,'',8) 
/
insert into HtmlLabelInfo values(15965,'续签时间',7) 
/
insert into HtmlLabelInfo values(15965,'',8) 
/
insert into HtmlLabelInfo values(15966,'续签结束时间',7) 
/
insert into HtmlLabelInfo values(15966,'',8) 
/
insert into HtmlLabelInfo values(15967,'续签部门统计',7) 
/
insert into HtmlLabelInfo values(15967,'',8) 
/
insert into HtmlLabelInfo values(15968,'续签统计',7) 
/
insert into HtmlLabelInfo values(15968,'',8) 
/
insert into HtmlLabelInfo values(15969,'续签具体信息报表',7) 
/
insert into HtmlLabelInfo values(15969,'',8) 
/
insert into HtmlLabelInfo values(15970,'续签日期',7) 
/
insert into HtmlLabelInfo values(15970,'',8) 
/
insert into HtmlLabelInfo values(15971,'续签结束日期',7) 
/
insert into HtmlLabelInfo values(15971,'',8) 
/
insert into HtmlLabelInfo values(15972,'解聘报表',7) 
/
insert into HtmlLabelInfo values(15972,'',8) 
/
insert into HtmlLabelInfo values(15973,'年解聘报表',7) 
/
insert into HtmlLabelInfo values(15973,'',8) 
/
insert into HtmlLabelInfo values(15974,'部门解聘统计',7) 
/
insert into HtmlLabelInfo values(15974,'',8) 
/
insert into HtmlLabelInfo values(15975,'解聘时间统计',7) 
/
insert into HtmlLabelInfo values(15975,'',8) 
/
insert into HtmlLabelInfo values(15976,'解聘时间',7) 
/
insert into HtmlLabelInfo values(15976,'',8) 
/
insert into HtmlLabelInfo values(15977,'解聘部门统计',7) 
/
insert into HtmlLabelInfo values(15977,'',8) 
/
insert into HtmlLabelInfo values(15978,'解聘统计',7) 
/
insert into HtmlLabelInfo values(15978,'',8) 
/
insert into HtmlLabelInfo values(15979,'解聘具体信息报表',7) 
/
insert into HtmlLabelInfo values(15979,'',8) 
/
insert into HtmlLabelInfo values(15980,'解聘日期',7) 
/
insert into HtmlLabelInfo values(15980,'',8) 
/
insert into HtmlLabelInfo values(15981,'转正报表',7) 
/
insert into HtmlLabelInfo values(15981,'',8) 
/
insert into HtmlLabelInfo values(15982,'年转正报表',7) 
/
insert into HtmlLabelInfo values(15982,'',8) 
/
insert into HtmlLabelInfo values(15983,'部门转正统计',7) 
/
insert into HtmlLabelInfo values(15983,'',8) 
/
insert into HtmlLabelInfo values(15984,'转正时间统计',7) 
/
insert into HtmlLabelInfo values(15984,'',8) 
/
insert into HtmlLabelInfo values(15985,'转正时间',7) 
/
insert into HtmlLabelInfo values(15985,'',8) 
/
insert into HtmlLabelInfo values(15986,'转正部门统计',7) 
/
insert into HtmlLabelInfo values(15986,'',8) 
/
insert into HtmlLabelInfo values(15987,'转正统计',7) 
/
insert into HtmlLabelInfo values(15987,'',8) 
/
insert into HtmlLabelInfo values(15988,'转正具体信息报表',7) 
/
insert into HtmlLabelInfo values(15988,'',8) 
/
insert into HtmlLabelInfo values(15989,'调动报表',7) 
/
insert into HtmlLabelInfo values(15989,'',8) 
/
insert into HtmlLabelInfo values(15990,'年调动报表',7) 
/
insert into HtmlLabelInfo values(15990,'',8) 
/
insert into HtmlLabelInfo values(15991,'部门调动统计',7) 
/
insert into HtmlLabelInfo values(15991,'',8) 
/
insert into HtmlLabelInfo values(15992,'调动时间统计',7) 
/
insert into HtmlLabelInfo values(15992,'',8) 
/
insert into HtmlLabelInfo values(15993,'调动时间',7) 
/
insert into HtmlLabelInfo values(15993,'',8) 
/
insert into HtmlLabelInfo values(15994,'调动前职级',7) 
/
insert into HtmlLabelInfo values(15994,'',8) 
/
insert into HtmlLabelInfo values(15995,'调动后职级',7) 
/
insert into HtmlLabelInfo values(15995,'',8) 
/
insert into HtmlLabelInfo values(15996,'调动部门统计',7) 
/
insert into HtmlLabelInfo values(15996,'',8) 
/
insert into HtmlLabelInfo values(15997,'调动统计',7) 
/
insert into HtmlLabelInfo values(15997,'',8) 
/
insert into HtmlLabelInfo values(15998,'调动具体信息报表',7) 
/
insert into HtmlLabelInfo values(15998,'',8) 
/
insert into HtmlLabelInfo values(15999,'调出岗位',7) 
/
insert into HtmlLabelInfo values(15999,'',8) 
/
insert into HtmlLabelInfo values(16000,'调入岗位',7) 
/
insert into HtmlLabelInfo values(16000,'',8) 
/
insert into HtmlLabelInfo values(16001,'被调动人',7) 
/
insert into HtmlLabelInfo values(16001,'',8) 
/
insert into HtmlLabelInfo values(16002,'返聘报表',7) 
/
insert into HtmlLabelInfo values(16002,'',8) 
/
insert into HtmlLabelInfo values(16003,'年返聘报表',7) 
/
insert into HtmlLabelInfo values(16003,'',8) 
/
insert into HtmlLabelInfo values(16004,'返聘时间统计',7) 
/
insert into HtmlLabelInfo values(16004,'',8) 
/
insert into HtmlLabelInfo values(16005,'返聘时间',7) 
/
insert into HtmlLabelInfo values(16005,'',8) 
/
insert into HtmlLabelInfo values(16006,'返聘结束时间',7) 
/
insert into HtmlLabelInfo values(16006,'',8) 
/
insert into HtmlLabelInfo values(16007,'返聘部门统计',7) 
/
insert into HtmlLabelInfo values(16007,'',8) 
/
insert into HtmlLabelInfo values(16008,'返聘统计',7) 
/
insert into HtmlLabelInfo values(16008,'',8) 
/
insert into HtmlLabelInfo values(16009,'返聘具体信息报表',7) 
/
insert into HtmlLabelInfo values(16009,'',8) 
/
insert into HtmlLabelInfo values(16010,'返聘部门',7) 
/
insert into HtmlLabelInfo values(16010,'',8) 
/
insert into HtmlLabelInfo values(16011,'返聘岗位',7) 
/
insert into HtmlLabelInfo values(16011,'',8) 
/
insert into HtmlLabelInfo values(16012,'返聘日期',7) 
/
insert into HtmlLabelInfo values(16012,'',8) 
/
insert into HtmlLabelInfo values(16013,'返聘结束日期',7) 
/
insert into HtmlLabelInfo values(16013,'',8) 
/
insert into HtmlLabelInfo values(16014,'部门返聘统计',7) 
/
insert into HtmlLabelInfo values(16014,'',8) 
/
insert into HtmlLabelInfo values(16015,'家庭联系方法',7) 
/
insert into HtmlLabelInfo values(16015,'',8) 
/
insert into HtmlLabelInfo values(16016,'工资帐号',7) 
/
insert into HtmlLabelInfo values(16016,'',8) 
/
insert into HtmlLabelInfo values(16017,'登陆帐号',7) 
/
insert into HtmlLabelInfo values(16017,'',8) 
/
insert into HtmlLabelInfo values(16018,'家庭联系方式',7) 
/
insert into HtmlLabelInfo values(16018,'',8) 
/
insert into HtmlLabelInfo values(16019,'新增统计',7) 
/
insert into HtmlLabelInfo values(16019,'',8) 
/
insert into HtmlLabelInfo values(16020,'加入时间统计',7) 
/
insert into HtmlLabelInfo values(16020,'',8) 
/
insert into HtmlLabelInfo values(16021,'加入部门统计',7) 
/
insert into HtmlLabelInfo values(16021,'',8) 
/
insert into HtmlLabelInfo values(16022,'新增人员报表',7) 
/
insert into HtmlLabelInfo values(16022,'',8) 
/
insert into HtmlLabelInfo values(16023,'年新增人员报表',7) 
/
insert into HtmlLabelInfo values(16023,'',8) 
/
insert into HtmlLabelInfo values(16024,'新增时间统计',7) 
/
insert into HtmlLabelInfo values(16024,'',8) 
/
insert into HtmlLabelInfo values(16025,'退休报表',7) 
/
insert into HtmlLabelInfo values(16025,'',8) 
/
insert into HtmlLabelInfo values(16026,'年退休报表',7) 
/
insert into HtmlLabelInfo values(16026,'',8) 
/
insert into HtmlLabelInfo values(16027,'部门退休统计',7) 
/
insert into HtmlLabelInfo values(16027,'',8) 
/
insert into HtmlLabelInfo values(16028,'退休时间统计',7) 
/
insert into HtmlLabelInfo values(16028,'',8) 
/
insert into HtmlLabelInfo values(16029,'退休时间',7) 
/
insert into HtmlLabelInfo values(16029,'',8) 
/
insert into HtmlLabelInfo values(16030,'退休部门统计',7) 
/
insert into HtmlLabelInfo values(16030,'',8) 
/
insert into HtmlLabelInfo values(16031,'退休统计',7) 
/
insert into HtmlLabelInfo values(16031,'',8) 
/
insert into HtmlLabelInfo values(16032,'退休具体信息报表',7) 
/
insert into HtmlLabelInfo values(16032,'',8) 
/
insert into HtmlLabelInfo values(16033,'退休部门',7) 
/
insert into HtmlLabelInfo values(16033,'',8) 
/
insert into HtmlLabelInfo values(16034,'退休岗位',7) 
/
insert into HtmlLabelInfo values(16034,'',8) 
/
insert into HtmlLabelInfo values(16035,'退休日期',7) 
/
insert into HtmlLabelInfo values(16035,'',8) 
/
insert into HtmlLabelInfo values(16036,'人次统计',7) 
/
insert into HtmlLabelInfo values(16036,'',8) 
/
insert into HtmlLabelInfo values(16037,'考勤开始日期',7) 
/
insert into HtmlLabelInfo values(16037,'',8) 
/
insert into HtmlLabelInfo values(16038,'考勤结束日期',7) 
/
insert into HtmlLabelInfo values(16038,'',8) 
/
insert into HtmlLabelInfo values(16039,'考勤开始时间',7) 
/
insert into HtmlLabelInfo values(16039,'',8) 
/
insert into HtmlLabelInfo values(16040,'考勤结束时间',7) 
/
insert into HtmlLabelInfo values(16040,'',8) 
/
insert into HtmlLabelInfo values(16041,'变动类型',7) 
/
insert into HtmlLabelInfo values(16041,'',8) 
/
insert into HtmlLabelInfo values(16042,'考勤部门统计',7) 
/
insert into HtmlLabelInfo values(16042,'',8) 
/
insert into HtmlLabelInfo values(16043,'天数统计',7) 
/
insert into HtmlLabelInfo values(16043,'',8) 
/
insert into HtmlLabelInfo values(16044,'考勤类别',7) 
/
insert into HtmlLabelInfo values(16044,'',8) 
/
insert into HtmlLabelInfo values(16045,'考勤部门',7) 
/
insert into HtmlLabelInfo values(16045,'',8) 
/
insert into HtmlLabelInfo values(16046,'种类报表',7) 
/
insert into HtmlLabelInfo values(16046,'',8) 
/
insert into HtmlLabelInfo values(16047,'种类天数报表',7) 
/
insert into HtmlLabelInfo values(16047,'',8) 
/
insert into HtmlLabelInfo values(16048,'考勤人员',7) 
/
insert into HtmlLabelInfo values(16048,'',8) 
/
insert into HtmlLabelInfo values(16049,'月份报表',7) 
/
insert into HtmlLabelInfo values(16049,'',8) 
/
insert into HtmlLabelInfo values(16050,'被考勤部门',7) 
/
insert into HtmlLabelInfo values(16050,'',8) 
/
insert into HtmlLabelInfo values(16051,'年人员',7) 
/
insert into HtmlLabelInfo values(16051,'',8) 
/
insert into HtmlLabelInfo values(16052,'月份人次报表',7) 
/
insert into HtmlLabelInfo values(16052,'',8) 
/
insert into HtmlLabelInfo values(16053,'月份天数报表',7) 
/
insert into HtmlLabelInfo values(16053,'',8) 
/
insert into HtmlLabelInfo values(16054,'考勤具体信息报表',7) 
/
insert into HtmlLabelInfo values(16054,'',8) 
/
insert into HtmlLabelInfo values(16055,'被考勤人',7) 
/
insert into HtmlLabelInfo values(16055,'',8) 
/
insert into HtmlLabelInfo values(16056,'实际计算时间',7) 
/
insert into HtmlLabelInfo values(16056,'',8) 
/
insert into HtmlLabelInfo values(16057,'实际计算天数',7) 
/
insert into HtmlLabelInfo values(16057,'',8) 
/
insert into HtmlLabelInfo values(16058,'种类人次报表',7) 
/
insert into HtmlLabelInfo values(16058,'',8) 
/
insert into HtmlLabelInfo values(16059,'年考勤种类',7) 
/
insert into HtmlLabelInfo values(16059,'',8) 
/
insert into HtmlLabelInfo values(16060,'人力资源用工需求',7) 
/
insert into HtmlLabelInfo values(16060,'',8) 
/
insert into HtmlLabelInfo values(16061,'用工需求人数统计',7) 
/
insert into HtmlLabelInfo values(16061,'',8) 
/
insert into HtmlLabelInfo values(16062,'用工需求具体信息报表',7) 
/
insert into HtmlLabelInfo values(16062,'',8) 
/
insert into HtmlLabelInfo values(16063,'人数报表',7) 
/
insert into HtmlLabelInfo values(16063,'',8) 
/
insert into HtmlLabelInfo values(16064,'年用工需求报表',7) 
/
insert into HtmlLabelInfo values(16064,'',8) 
/
insert into HtmlLabelInfo values(16065,'奖惩考核',7) 
/
insert into HtmlLabelInfo values(16065,'',8) 
/
insert into HtmlLabelInfo values(16066,'系统语言',7) 
/
insert into HtmlLabelInfo values(16066,'',8) 
/
insert into HtmlLabelInfo values(16067,'最后登陆日期',7) 
/
insert into HtmlLabelInfo values(16067,'',8) 
/
insert into HtmlLabelInfo values(16068,'正在参加的培训活动',7) 
/
insert into HtmlLabelInfo values(16068,'',8) 
/
insert into HtmlLabelInfo values(16069,'可以参加的培训安排',7) 
/
insert into HtmlLabelInfo values(16069,'',8) 
/
insert into HtmlLabelInfo values(16070,'考勤类型',7) 
/
insert into HtmlLabelInfo values(16070,'',8) 
/
insert into HtmlLabelInfo values(16071,'显示颜色',7) 
/
insert into HtmlLabelInfo values(16071,'',8) 
/
insert into HtmlLabelInfo values(16072,'此员工还没有输入直接上级，确定不输入吗？',7) 
/
insert into HtmlLabelInfo values(16072,'',8) 
/
insert into HtmlLabelInfo values(16073,'合同开始日期不能大于合同结束日期！',7) 
/
insert into HtmlLabelInfo values(16073,'',8) 
/
insert into HtmlLabelInfo values(16074,'工作地点',7) 
/
insert into HtmlLabelInfo values(16074,'',8) 
/
insert into HtmlLabelInfo values(16075,'删除图片',7) 
/
insert into HtmlLabelInfo values(16075,'',8) 
/
insert into HtmlLabelInfo values(16076,'联系信息',7) 
/
insert into HtmlLabelInfo values(16076,'',8) 
/
insert into HtmlLabelInfo values(16077,'离职通知人',7) 
/
insert into HtmlLabelInfo values(16077,'',8) 
/
insert into HtmlLabelInfo values(16078,'有效用户数已到license上限！',7) 
/
insert into HtmlLabelInfo values(16078,'',8) 
/
insert into HtmlLabelInfo values(16079,'被续签人',7) 
/
insert into HtmlLabelInfo values(16079,'',8) 
/
insert into HtmlLabelInfo values(16080,'续签状态',7) 
/
insert into HtmlLabelInfo values(16080,'',8) 
/
insert into HtmlLabelInfo values(16081,'续签备注',7) 
/
insert into HtmlLabelInfo values(16081,'',8) 
/
insert into HtmlLabelInfo values(16082,'续签合同',7) 
/
insert into HtmlLabelInfo values(16082,'',8) 
/
insert into HtmlLabelInfo values(16083,'续签通知人',7) 
/
insert into HtmlLabelInfo values(16083,'',8) 
/
insert into HtmlLabelInfo values(16084,'工资帐户',7) 
/
insert into HtmlLabelInfo values(16084,'',8) 
/
insert into HtmlLabelInfo values(16085,'公积金帐户',7) 
/
insert into HtmlLabelInfo values(16085,'',8) 
/
insert into HtmlLabelInfo values(16086,'被解聘人',7) 
/
insert into HtmlLabelInfo values(16086,'',8) 
/
insert into HtmlLabelInfo values(16087,'解聘原因',7) 
/
insert into HtmlLabelInfo values(16087,'',8) 
/
insert into HtmlLabelInfo values(16088,'解聘合同',7) 
/
insert into HtmlLabelInfo values(16088,'',8) 
/
insert into HtmlLabelInfo values(16089,'解聘通知人',7) 
/
insert into HtmlLabelInfo values(16089,'',8) 
/
insert into HtmlLabelInfo values(16090,'被转正人',7) 
/
insert into HtmlLabelInfo values(16090,'',8) 
/
insert into HtmlLabelInfo values(16091,'转正通知人',7) 
/
insert into HtmlLabelInfo values(16091,'',8) 
/
insert into HtmlLabelInfo values(16092,'密码修改成功',7) 
/
insert into HtmlLabelInfo values(16092,'',8) 
/
insert into HtmlLabelInfo values(16093,'工作日程',7) 
/
insert into HtmlLabelInfo values(16093,'',8) 
/
insert into HtmlLabelInfo values(16094,'日程类型',7) 
/
insert into HtmlLabelInfo values(16094,'',8) 
/
insert into HtmlLabelInfo values(16095,'项目日程',7) 
/
insert into HtmlLabelInfo values(16095,'',8) 
/
insert into HtmlLabelInfo values(16096,'年日程',7) 
/
insert into HtmlLabelInfo values(16096,'',8) 
/
insert into HtmlLabelInfo values(16097,'月日程',7) 
/
insert into HtmlLabelInfo values(16097,'',8) 
/
insert into HtmlLabelInfo values(16098,'周日程',7) 
/
insert into HtmlLabelInfo values(16098,'',8) 
/
insert into HtmlLabelInfo values(16099,'单日日程',7) 
/
insert into HtmlLabelInfo values(16099,'',8) 
/
insert into HtmlLabelInfo values(16100,'周一',7) 
/
insert into HtmlLabelInfo values(16100,'',8) 
/
insert into HtmlLabelInfo values(16101,'周二',7) 
/
insert into HtmlLabelInfo values(16101,'',8) 
/
insert into HtmlLabelInfo values(16102,'周三',7) 
/
insert into HtmlLabelInfo values(16102,'',8) 
/
insert into HtmlLabelInfo values(16103,'周四',7) 
/
insert into HtmlLabelInfo values(16103,'',8) 
/
insert into HtmlLabelInfo values(16104,'周五',7) 
/
insert into HtmlLabelInfo values(16104,'',8) 
/
insert into HtmlLabelInfo values(16105,'周六',7) 
/
insert into HtmlLabelInfo values(16105,'',8) 
/
insert into HtmlLabelInfo values(16106,'周日',7) 
/
insert into HtmlLabelInfo values(16106,'',8) 
/
insert into HtmlLabelInfo values(16107,'现岗位',7) 
/
insert into HtmlLabelInfo values(16107,'',8) 
/
insert into HtmlLabelInfo values(16108,'调动通知人',7) 
/
insert into HtmlLabelInfo values(16108,'',8) 
/
insert into HtmlLabelInfo values(16109,'被反聘人',7) 
/
insert into HtmlLabelInfo values(16109,'',8) 
/
insert into HtmlLabelInfo values(16110,'反聘开始日期',7) 
/
insert into HtmlLabelInfo values(16110,'',8) 
/
insert into HtmlLabelInfo values(16111,'反聘结束日期',7) 
/
insert into HtmlLabelInfo values(16111,'',8) 
/
insert into HtmlLabelInfo values(16112,'反聘原因',7) 
/
insert into HtmlLabelInfo values(16112,'',8) 
/
insert into HtmlLabelInfo values(16113,'反聘合同',7) 
/
insert into HtmlLabelInfo values(16113,'',8) 
/
insert into HtmlLabelInfo values(16114,'反聘通知人',7) 
/
insert into HtmlLabelInfo values(16114,'',8) 
/
insert into HtmlLabelInfo values(16115,'退休人',7) 
/
insert into HtmlLabelInfo values(16115,'',8) 
/
insert into HtmlLabelInfo values(16116,'退休备注',7) 
/
insert into HtmlLabelInfo values(16116,'',8) 
/
insert into HtmlLabelInfo values(16117,'退休合同',7) 
/
insert into HtmlLabelInfo values(16117,'',8) 
/
insert into HtmlLabelInfo values(16118,'退休通知人',7) 
/
insert into HtmlLabelInfo values(16118,'',8) 
/
insert into HtmlLabelInfo values(16119,'员工解聘通知',7) 
/
insert into HtmlLabelInfo values(16119,'',8) 
/
insert into HtmlLabelInfo values(16120,'员工转正通知',7) 
/
insert into HtmlLabelInfo values(16120,'',8) 
/
insert into HtmlLabelInfo values(16121,'员工续签通知',7) 
/
insert into HtmlLabelInfo values(16121,'',8) 
/
insert into HtmlLabelInfo values(16122,'员工调动通知',7) 
/
insert into HtmlLabelInfo values(16122,'',8) 
/
insert into HtmlLabelInfo values(16123,'员工离职通知',7) 
/
insert into HtmlLabelInfo values(16123,'',8) 
/
insert into HtmlLabelInfo values(16124,'员工退休通知',7) 
/
insert into HtmlLabelInfo values(16124,'',8) 
/
insert into HtmlLabelInfo values(16125,'员工反聘通知',7) 
/
insert into HtmlLabelInfo values(16125,'',8) 
/
insert into HtmlLabelInfo values(16126,'登陆名',7) 
/
insert into HtmlLabelInfo values(16126,'',8) 
/
insert into HtmlLabelInfo values(16127,'密码确认',7) 
/
insert into HtmlLabelInfo values(16127,'',8) 
/
insert into HtmlLabelInfo values(16128,'登录名冲突！！！',7) 
/
insert into HtmlLabelInfo values(16128,'',8) 
/
insert into HtmlLabelInfo values(16129,'登录用户数已到license上限,不能再设置新的用户登录信息！',7) 
/
insert into HtmlLabelInfo values(16129,'',8) 
/
insert into HtmlLabelInfo values(16130,'不及格',7) 
/
insert into HtmlLabelInfo values(16130,'',8) 
/
insert into HtmlLabelInfo values(16131,'及格',7) 
/
insert into HtmlLabelInfo values(16131,'',8) 
/
insert into HtmlLabelInfo values(16132,'很好',7) 
/
insert into HtmlLabelInfo values(16132,'',8) 
/
insert into HtmlLabelInfo values(16133,'具体情况',7) 
/
insert into HtmlLabelInfo values(16133,'',8) 
/
insert into HtmlLabelInfo values(16134,'日程内容',7) 
/
insert into HtmlLabelInfo values(16134,'',8) 
/
insert into HtmlLabelInfo values(16135,'未参加',7) 
/
insert into HtmlLabelInfo values(16135,'',8) 
/
insert into HtmlLabelInfo values(16136,'工作记录',7) 
/
insert into HtmlLabelInfo values(16136,'',8) 
/
insert into HtmlLabelInfo values(16137,'变动原因',7) 
/
insert into HtmlLabelInfo values(16137,'',8) 
/
insert into HtmlLabelInfo values(16138,'总公司',7) 
/
insert into HtmlLabelInfo values(16138,'',8) 
/
insert into HtmlLabelInfo values(16139,'系统管理员',7) 
/
insert into HtmlLabelInfo values(16139,'',8) 
/
insert into HtmlLabelInfo values(16140,'参加人员',7) 
/
insert into HtmlLabelInfo values(16140,'',8) 
/
insert into HtmlLabelInfo values(16141,'组织人',7) 
/
insert into HtmlLabelInfo values(16141,'',8) 
/
insert into HtmlLabelInfo values(16142,'目的',7) 
/
insert into HtmlLabelInfo values(16142,'',8) 
/
insert into HtmlLabelInfo values(16143,'培训考核',7) 
/
insert into HtmlLabelInfo values(16143,'',8) 
/
insert into HtmlLabelInfo values(16144,'培训考评',7) 
/
insert into HtmlLabelInfo values(16144,'',8) 
/
insert into HtmlLabelInfo values(16145,'效果',7) 
/
insert into HtmlLabelInfo values(16145,'',8) 
/
insert into HtmlLabelInfo values(16146,'培训人员',7) 
/
insert into HtmlLabelInfo values(16146,'',8) 
/
insert into HtmlLabelInfo values(16147,'此项培训活动已经被删除！！',7) 
/
insert into HtmlLabelInfo values(16147,'',8) 
/
insert into HtmlLabelInfo values(16148,'增加培训人',7) 
/
insert into HtmlLabelInfo values(16148,'',8) 
/
insert into HtmlLabelInfo values(16149,'通知考评',7) 
/
insert into HtmlLabelInfo values(16149,'',8) 
/
insert into HtmlLabelInfo values(16150,'培训日程',7) 
/
insert into HtmlLabelInfo values(16150,'',8) 
/
insert into HtmlLabelInfo values(16151,'增加培训日程',7) 
/
insert into HtmlLabelInfo values(16151,'',8) 
/
insert into HtmlLabelInfo values(16152,'培训活动总结',7) 
/
insert into HtmlLabelInfo values(16152,'',8) 
/
insert into HtmlLabelInfo values(16153,'实际培训费用',7) 
/
insert into HtmlLabelInfo values(16153,'',8) 
/
insert into HtmlLabelInfo values(16154,'总结人',7) 
/
insert into HtmlLabelInfo values(16154,'',8) 
/
insert into HtmlLabelInfo values(16155,'总结日期',7) 
/
insert into HtmlLabelInfo values(16155,'',8) 
/
insert into HtmlLabelInfo values(16156,'培训考评通知',7) 
/
insert into HtmlLabelInfo values(16156,'',8) 
/
insert into HtmlLabelInfo values(16157,'此项培训规划已经被删除！！',7) 
/
insert into HtmlLabelInfo values(16157,'',8) 
/
insert into HtmlLabelInfo values(16158,'实施情况',7) 
/
insert into HtmlLabelInfo values(16158,'',8) 
/
insert into HtmlLabelInfo values(16159,'建议',7) 
/
insert into HtmlLabelInfo values(16159,'',8) 
/
insert into HtmlLabelInfo values(16160,'较好',7) 
/
insert into HtmlLabelInfo values(16160,'',8) 
/
insert into HtmlLabelInfo values(16161,'新考评',7) 
/
insert into HtmlLabelInfo values(16161,'',8) 
/
insert into HtmlLabelInfo values(16162,'培训规划考评通知',7) 
/
insert into HtmlLabelInfo values(16162,'',8) 
/
insert into HtmlLabelInfo values(16163,'对不起，您无权建立此类培训！！！',7) 
/
insert into HtmlLabelInfo values(16163,'',8) 
/
insert into HtmlLabelInfo values(16164,'培训通知',7) 
/
insert into HtmlLabelInfo values(16164,'',8) 
/
insert into HtmlLabelInfo values(16165,'外部资源',7) 
/
insert into HtmlLabelInfo values(16165,'',8) 
/
insert into HtmlLabelInfo values(16166,'内部资源',7) 
/
insert into HtmlLabelInfo values(16166,'',8) 
/
insert into HtmlLabelInfo values(16167,'操作权限人',7) 
/
insert into HtmlLabelInfo values(16167,'',8) 
/
insert into HtmlLabelInfo values(16168,'部门快捷方式',7) 
/
insert into HtmlLabelInfo values(16168,'',8) 
/
insert into HtmlLabelInfo values(16169,'其他信息',7) 
/
insert into HtmlLabelInfo values(16169,'',8) 
/
insert into HtmlLabelInfo values(16170,'泛微插件下载',7) 
/
insert into HtmlLabelInfo values(16170,'',8) 
/
insert into HtmlLabelInfo values(16171,'文档模块升级',7) 
/
insert into HtmlLabelInfo values(16171,'',8) 
/
insert into HtmlLabelInfo values(16172,'修改共享',7) 
/
insert into HtmlLabelInfo values(16172,'',8) 
/
insert into HtmlLabelInfo values(16173,'资产使用',7) 
/
insert into HtmlLabelInfo values(16173,'',8) 
/
insert into HtmlLabelInfo values(16174,'是（可选择）',7) 
/
insert into HtmlLabelInfo values(16174,'',8) 
/
insert into HtmlLabelInfo values(16175,'否（未使用）',7) 
/
insert into HtmlLabelInfo values(16175,'',8) 
/
insert into HtmlLabelInfo values(16176,'是（强制性）',7) 
/
insert into HtmlLabelInfo values(16176,'',8) 
/
insert into HtmlLabelInfo values(16177,'人力资源使用',7) 
/
insert into HtmlLabelInfo values(16177,'',8) 
/
insert into HtmlLabelInfo values(16178,'项目使用',7) 
/
insert into HtmlLabelInfo values(16178,'',8) 
/
insert into HtmlLabelInfo values(16179,'剪切',7) 
/
insert into HtmlLabelInfo values(16179,'cut',8) 
/
insert into HtmlLabelInfo values(16180,'粘贴',7) 
/
insert into HtmlLabelInfo values(16180,'paste',8) 
/
insert into HtmlLabelInfo values(16181,'插入表格',7) 
/
insert into HtmlLabelInfo values(16181,'',8) 
/
insert into HtmlLabelInfo values(16182,'删除行',7) 
/
insert into HtmlLabelInfo values(16182,'',8) 
/
insert into HtmlLabelInfo values(16183,'删除列',7) 
/
insert into HtmlLabelInfo values(16183,'',8) 
/
insert into HtmlLabelInfo values(16184,'插入单元格',7) 
/
insert into HtmlLabelInfo values(16184,'',8) 
/
insert into HtmlLabelInfo values(16185,'删除单元格',7) 
/
insert into HtmlLabelInfo values(16185,'',8) 
/
insert into HtmlLabelInfo values(16186,'合并单元格',7) 
/
insert into HtmlLabelInfo values(16186,'',8) 
/
insert into HtmlLabelInfo values(16187,'拆分单元格',7) 
/
insert into HtmlLabelInfo values(16187,'',8) 
/
insert into HtmlLabelInfo values(16188,'请先选择所需的图片',7) 
/
insert into HtmlLabelInfo values(16188,'',8) 
/
insert into HtmlLabelInfo values(16189,'字体',7) 
/
insert into HtmlLabelInfo values(16189,'',8) 
/
insert into HtmlLabelInfo values(16190,'宋体',7) 
/
insert into HtmlLabelInfo values(16190,'',8) 
/
insert into HtmlLabelInfo values(16191,'新宋体',7) 
/
insert into HtmlLabelInfo values(16191,'',8) 
/
insert into HtmlLabelInfo values(16192,'黑体',7) 
/
insert into HtmlLabelInfo values(16192,'',8) 
/
insert into HtmlLabelInfo values(16193,'隶书',7) 
/
insert into HtmlLabelInfo values(16193,'',8) 
/
insert into HtmlLabelInfo values(16194,'幼园',7) 
/
insert into HtmlLabelInfo values(16194,'',8) 
/
insert into HtmlLabelInfo values(16195,'楷体',7) 
/
insert into HtmlLabelInfo values(16195,'',8) 
/
insert into HtmlLabelInfo values(16196,'仿宋',7) 
/
insert into HtmlLabelInfo values(16196,'',8) 
/
insert into HtmlLabelInfo values(16197,'字号',7) 
/
insert into HtmlLabelInfo values(16197,'',8) 
/
insert into HtmlLabelInfo values(16198,'加粗',7) 
/
insert into HtmlLabelInfo values(16198,'',8) 
/
insert into HtmlLabelInfo values(16199,'倾斜',7) 
/
insert into HtmlLabelInfo values(16199,'',8) 
/
insert into HtmlLabelInfo values(16200,'下划线',7) 
/
insert into HtmlLabelInfo values(16200,'',8) 
/
insert into HtmlLabelInfo values(16201,'突出显示',7) 
/
insert into HtmlLabelInfo values(16201,'',8) 
/
insert into HtmlLabelInfo values(16202,'左对齐',7) 
/
insert into HtmlLabelInfo values(16202,'',8) 
/
insert into HtmlLabelInfo values(16203,'居中',7) 
/
insert into HtmlLabelInfo values(16203,'',8) 
/
insert into HtmlLabelInfo values(16204,'右对齐',7) 
/
insert into HtmlLabelInfo values(16204,'',8) 
/
insert into HtmlLabelInfo values(16205,'项目符号',7) 
/
insert into HtmlLabelInfo values(16205,'',8) 
/
insert into HtmlLabelInfo values(16206,'减少缩进量',7) 
/
insert into HtmlLabelInfo values(16206,'',8) 
/
insert into HtmlLabelInfo values(16207,'增加缩进量',7) 
/
insert into HtmlLabelInfo values(16207,'',8) 
/
insert into HtmlLabelInfo values(16208,'超级链接',7) 
/
insert into HtmlLabelInfo values(16208,'',8) 
/
insert into HtmlLabelInfo values(16209,'插入图像',7) 
/
insert into HtmlLabelInfo values(16209,'',8) 
/
insert into HtmlLabelInfo values(16210,'撤销',7) 
/
insert into HtmlLabelInfo values(16210,'cancel',8) 
/
insert into HtmlLabelInfo values(16211,'恢复',7) 
/
insert into HtmlLabelInfo values(16211,'',8) 
/
insert into HtmlLabelInfo values(16212,'绝对位置',7) 
/
insert into HtmlLabelInfo values(16212,'',8) 
/
insert into HtmlLabelInfo values(16213,'锁定',7) 
/
insert into HtmlLabelInfo values(16213,'',8) 
/
insert into HtmlLabelInfo values(16214,'吸附',7) 
/
insert into HtmlLabelInfo values(16214,'',8) 
/
insert into HtmlLabelInfo values(16215,'请输入文档编号',7) 
/
insert into HtmlLabelInfo values(16215,'',8) 
/
insert into HtmlLabelInfo values(16216,'全部展开',7) 
/
insert into HtmlLabelInfo values(16216,'',8) 
/
insert into HtmlLabelInfo values(16217,'选择颜色',7) 
/
insert into HtmlLabelInfo values(16217,'',8) 
/
insert into HtmlLabelInfo values(16218,'邮件模板',7) 
/
insert into HtmlLabelInfo values(16218,'',8) 
/
insert into HtmlLabelInfo values(16219,'这里HTML代码中的NAME名称应和数据表中的各字段名称一样.',7) 
/
insert into HtmlLabelInfo values(16219,'',8) 
/
insert into HtmlLabelInfo values(16220,'电邮',7) 
/
insert into HtmlLabelInfo values(16220,'E-mail',8) 
/
insert into HtmlLabelInfo values(16221,'工作日期',7) 
/
insert into HtmlLabelInfo values(16221,'',8) 
/
insert into HtmlLabelInfo values(16222,'系统结束日期',7) 
/
insert into HtmlLabelInfo values(16222,'',8) 
/
insert into HtmlLabelInfo values(16223,'工作类别',7) 
/
insert into HtmlLabelInfo values(16223,'',8) 
/
insert into HtmlLabelInfo values(16224,'所属成本中心',7) 
/
insert into HtmlLabelInfo values(16224,'',8) 
/
insert into HtmlLabelInfo values(16225,'物品简介',7) 
/
insert into HtmlLabelInfo values(16225,'',8) 
/
insert into HtmlLabelInfo values(16226,'公司宣传',7) 
/
insert into HtmlLabelInfo values(16226,'',8) 
/
insert into HtmlLabelInfo values(16227,'创建人部门,请参考HRM(大组-组-部门)',7) 
/
insert into HtmlLabelInfo values(16227,'',8) 
/
insert into HtmlLabelInfo values(16228,'文档内容',7) 
/
insert into HtmlLabelInfo values(16228,'',8) 
/
insert into HtmlLabelInfo values(16229,'创建人名称',7) 
/
insert into HtmlLabelInfo values(16229,'',8) 
/
insert into HtmlLabelInfo values(16230,'创建人名称和链接',7) 
/
insert into HtmlLabelInfo values(16230,'',8) 
/
insert into HtmlLabelInfo values(16231,'最后的修改人',7) 
/
insert into HtmlLabelInfo values(16231,'',8) 
/
insert into HtmlLabelInfo values(16232,'最后的修改日期',7) 
/
insert into HtmlLabelInfo values(16232,'',8) 
/
insert into HtmlLabelInfo values(16233,'使用的语言',7) 
/
insert into HtmlLabelInfo values(16233,'',8) 
/
insert into HtmlLabelInfo values(16234,'回复文档的主文档',7) 
/
insert into HtmlLabelInfo values(16234,'',8) 
/
insert into HtmlLabelInfo values(16235,'文档的状态(草稿,打开,正常,归档)',7) 
/
insert into HtmlLabelInfo values(16235,'',8) 
/
insert into HtmlLabelInfo values(16236,'文档主题',7) 
/
insert into HtmlLabelInfo values(16236,'',8) 
/
insert into HtmlLabelInfo values(16237,'发布状态(正常,新闻,标题新闻)',7) 
/
insert into HtmlLabelInfo values(16237,'',8) 
/
insert into HtmlLabelInfo values(16238,'最后查看日期',7) 
/
insert into HtmlLabelInfo values(16238,'',8) 
/
insert into HtmlLabelInfo values(16239,'文档的安全级别',7) 
/
insert into HtmlLabelInfo values(16239,'',8) 
/
insert into HtmlLabelInfo values(16240,'文档种类',7) 
/
insert into HtmlLabelInfo values(16240,'',8) 
/
insert into HtmlLabelInfo values(16241,'无新闻栏目！',7) 
/
insert into HtmlLabelInfo values(16241,'',8) 
/
insert into HtmlLabelInfo values(16242,'新闻名称',7) 
/
insert into HtmlLabelInfo values(16242,'',8) 
/
insert into HtmlLabelInfo values(16243,'被阅读',7) 
/
insert into HtmlLabelInfo values(16243,'',8) 
/
insert into HtmlLabelInfo values(16244,'全部文档:按被阅读次数(降序)',7) 
/
insert into HtmlLabelInfo values(16244,'',8) 
/
insert into HtmlLabelInfo values(16245,'调查表单接收情况',7) 
/
insert into HtmlLabelInfo values(16245,'',8) 
/
insert into HtmlLabelInfo values(16246,'输入调查表',7) 
/
insert into HtmlLabelInfo values(16246,'',8) 
/
insert into HtmlLabelInfo values(16247,'退订成功',7) 
/
insert into HtmlLabelInfo values(16247,'',8) 
/
insert into HtmlLabelInfo values(16248,'提交成功',7) 
/
insert into HtmlLabelInfo values(16248,'',8) 
/
insert into HtmlLabelInfo values(16249,'部门图形编辑',7) 
/
insert into HtmlLabelInfo values(16249,'',8) 
/
insert into HtmlLabelInfo values(16250,'入职',7) 
/
insert into HtmlLabelInfo values(16250,'',8) 
/
insert into HtmlLabelInfo values(16251,'应聘库',7) 
/
insert into HtmlLabelInfo values(16251,'',8) 
/
insert into HtmlLabelInfo values(16252,'考勤管理',7) 
/
insert into HtmlLabelInfo values(16252,'',8) 
/
insert into HtmlLabelInfo values(16253,'工作时间',7) 
/
insert into HtmlLabelInfo values(16253,'',8) 
/
insert into HtmlLabelInfo values(16254,'一般工作时间',7) 
/
insert into HtmlLabelInfo values(16254,'',8) 
/
insert into HtmlLabelInfo values(16255,'排班种类',7) 
/
insert into HtmlLabelInfo values(16255,'',8) 
/
insert into HtmlLabelInfo values(16256,'排班维护',7) 
/
insert into HtmlLabelInfo values(16256,'',8) 
/
insert into HtmlLabelInfo values(16257,'打卡用户接口',7) 
/
insert into HtmlLabelInfo values(16257,'',8) 
/
insert into HtmlLabelInfo values(16258,'打卡数据导出',7) 
/
insert into HtmlLabelInfo values(16258,'',8) 
/
insert into HtmlLabelInfo values(16259,'打卡数据导入',7) 
/
insert into HtmlLabelInfo values(16259,'',8) 
/
insert into HtmlLabelInfo values(16260,'合同管理',7) 
/
insert into HtmlLabelInfo values(16260,'',8) 
/
insert into HtmlLabelInfo values(16261,'基本设置',7) 
/
insert into HtmlLabelInfo values(16261,'',8) 
/
insert into HtmlLabelInfo values(16262,'工资福利税收项目',7) 
/
insert into HtmlLabelInfo values(16262,'',8) 
/
insert into HtmlLabelInfo values(16263,'薪酬管理',7) 
/
insert into HtmlLabelInfo values(16263,'',8) 
/
insert into HtmlLabelInfo values(16264,'培训管理',7) 
/
insert into HtmlLabelInfo values(16264,'',8) 
/
insert into HtmlLabelInfo values(16265,'资产借用申请单',7) 
/
insert into HtmlLabelInfo values(16265,'',8) 
/
insert into HtmlLabelInfo values(16266,'国际战略投资有限公司行政管理部车辆维修单',7) 
/
insert into HtmlLabelInfo values(16266,'',8) 
/
insert into HtmlLabelInfo values(16267,'维修人',7) 
/
insert into HtmlLabelInfo values(16267,'',8) 
/
insert into HtmlLabelInfo values(16268,'维修时间',7) 
/
insert into HtmlLabelInfo values(16268,'',8) 
/
insert into HtmlLabelInfo values(16269,'维修费用',7) 
/
insert into HtmlLabelInfo values(16269,'',8) 
/
insert into HtmlLabelInfo values(16270,'说明必须输入！',7) 
/
insert into HtmlLabelInfo values(16270,'',8) 
/
insert into HtmlLabelInfo values(16271,'个人借款余额：',7) 
/
insert into HtmlLabelInfo values(16271,'',8) 
/
insert into HtmlLabelInfo values(16272,'本月工作目标',7) 
/
insert into HtmlLabelInfo values(16272,'',8) 
/
insert into HtmlLabelInfo values(16273,'本月工作总结',7) 
/
insert into HtmlLabelInfo values(16273,'',8) 
/
insert into HtmlLabelInfo values(16274,'完成情况具体描述',7) 
/
insert into HtmlLabelInfo values(16274,'',8) 
/
insert into HtmlLabelInfo values(16275,'考核人评分',7) 
/
insert into HtmlLabelInfo values(16275,'',8) 
/
insert into HtmlLabelInfo values(16276,'上月工作总结',7) 
/
insert into HtmlLabelInfo values(16276,'',8) 
/
insert into HtmlLabelInfo values(16277,'总结权重指数不能大于100%',7) 
/
insert into HtmlLabelInfo values(16277,'',8) 
/
insert into HtmlLabelInfo values(16278,'计划权重指数不能大于100%',7) 
/
insert into HtmlLabelInfo values(16278,'',8) 
/
insert into HtmlLabelInfo values(16279,'总结权重指数不能大于100%',7) 
/
insert into HtmlLabelInfo values(16279,'',8) 
/
insert into HtmlLabelInfo values(16279,'计划权重指数不能大于100%',7) 
/
insert into HtmlLabelInfo values(16279,'',8) 
/
insert into HtmlLabelInfo values(16279,'上周工作总结',7) 
/
insert into HtmlLabelInfo values(16279,'',8) 
/
insert into HtmlLabelInfo values(16280,'完成结果',7) 
/
insert into HtmlLabelInfo values(16280,'',8) 
/
insert into HtmlLabelInfo values(16281,'未完成事项',7) 
/
insert into HtmlLabelInfo values(16281,'',8) 
/
insert into HtmlLabelInfo values(16282,'本周工作计划',7) 
/
insert into HtmlLabelInfo values(16282,'',8) 
/
insert into HtmlLabelInfo values(16283,'是否公开',7) 
/
insert into HtmlLabelInfo values(16283,'',8) 
/
insert into HtmlLabelInfo values(16284,'详细说明',7) 
/
insert into HtmlLabelInfo values(16284,'',8) 
/
insert into HtmlLabelInfo values(16285,'显示财务信息',7) 
/
insert into HtmlLabelInfo values(16285,'',8) 
/
insert into HtmlLabelInfo values(16286,'该部门预算已批准',7) 
/
insert into HtmlLabelInfo values(16286,'',8) 
/
insert into HtmlLabelInfo values(16287,'该部门预算未批准',7) 
/
insert into HtmlLabelInfo values(16287,'',8) 
/
insert into HtmlLabelInfo values(16288,'该部门未有预算',7) 
/
insert into HtmlLabelInfo values(16288,'',8) 
/
insert into HtmlLabelInfo values(16289,'部门信息',7) 
/
insert into HtmlLabelInfo values(16289,'',8) 
/
insert into HtmlLabelInfo values(16290,'项目信息',7) 
/
insert into HtmlLabelInfo values(16290,'',8) 
/
insert into HtmlLabelInfo values(16291,'当期',7) 
/
insert into HtmlLabelInfo values(16291,'',8) 
/
insert into HtmlLabelInfo values(16292,'实际(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16292,'',8) 
/
insert into HtmlLabelInfo values(16293,'是否超支',7) 
/
insert into HtmlLabelInfo values(16293,'',8) 
/
insert into HtmlLabelInfo values(16294,'项目总预算',7) 
/
insert into HtmlLabelInfo values(16294,'',8) 
/
insert into HtmlLabelInfo values(16295,'项目总支出(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16295,'',8) 
/
insert into HtmlLabelInfo values(16296,'本人该项目预算',7) 
/
insert into HtmlLabelInfo values(16296,'',8) 
/
insert into HtmlLabelInfo values(16297,'本人该项目实际(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16297,'',8) 
/
insert into HtmlLabelInfo values(16298,'部门该项目预算',7) 
/
insert into HtmlLabelInfo values(16298,'',8) 
/
insert into HtmlLabelInfo values(16299,'部门该项目实际(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16299,'',8) 
/
insert into HtmlLabelInfo values(16300,'全部该项目预算',7) 
/
insert into HtmlLabelInfo values(16300,'',8) 
/
insert into HtmlLabelInfo values(16301,'全部该项目实际(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16301,'',8) 
/
insert into HtmlLabelInfo values(16302,'总支出(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16302,'',8) 
/
insert into HtmlLabelInfo values(16303,'本人该CRM预算',7) 
/
insert into HtmlLabelInfo values(16303,'',8) 
/
insert into HtmlLabelInfo values(16304,'本人该CRM实际(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16304,'',8) 
/
insert into HtmlLabelInfo values(16305,'部门该CRM预算',7) 
/
insert into HtmlLabelInfo values(16305,'',8) 
/
insert into HtmlLabelInfo values(16306,'部门该CRM实际(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16306,'',8) 
/
insert into HtmlLabelInfo values(16307,'全部该CRM预算',7) 
/
insert into HtmlLabelInfo values(16307,'',8) 
/
insert into HtmlLabelInfo values(16308,'全部该CRM实际(包括本次报销)',7) 
/
insert into HtmlLabelInfo values(16308,'',8) 
/
insert into HtmlLabelInfo values(16309,'隐藏财务信息',7) 
/
insert into HtmlLabelInfo values(16309,'',8) 
/
insert into HtmlLabelInfo values(16310,'结束讨论',7) 
/
insert into HtmlLabelInfo values(16310,'',8) 
/
insert into HtmlLabelInfo values(16311,'办公用品一次性发放配额',7) 
/
insert into HtmlLabelInfo values(16311,'',8) 
/
insert into HtmlLabelInfo values(16312,'领用表单',7) 
/
insert into HtmlLabelInfo values(16312,'',8) 
/
insert into HtmlLabelInfo values(16313,'品名',7) 
/
insert into HtmlLabelInfo values(16313,'',8) 
/
insert into HtmlLabelInfo values(16314,'规格',7) 
/
insert into HtmlLabelInfo values(16314,'',8) 
/
insert into HtmlLabelInfo values(16315,'别克',7) 
/
insert into HtmlLabelInfo values(16315,'',8) 
/
insert into HtmlLabelInfo values(16316,'日本三菱(Uni)UB150签字笔',7) 
/
insert into HtmlLabelInfo values(16316,'',8) 
/
insert into HtmlLabelInfo values(16317,'笔类',7) 
/
insert into HtmlLabelInfo values(16317,'',8) 
/
insert into HtmlLabelInfo values(16318,'流水号',7) 
/
insert into HtmlLabelInfo values(16318,'',8) 
/
insert into HtmlLabelInfo values(16319,'老三样',7) 
/
insert into HtmlLabelInfo values(16319,'',8) 
/
insert into HtmlLabelInfo values(16320,'自己支付',7) 
/
insert into HtmlLabelInfo values(16320,'',8) 
/
insert into HtmlLabelInfo values(16321,'公司全付',7) 
/
insert into HtmlLabelInfo values(16321,'',8) 
/
insert into HtmlLabelInfo values(16322,'支付费用',7) 
/
insert into HtmlLabelInfo values(16322,'',8) 
/
insert into HtmlLabelInfo values(16323,'宾馆预定详细信息',7) 
/
insert into HtmlLabelInfo values(16323,'',8) 
/
insert into HtmlLabelInfo values(16324,'宾馆名称',7) 
/
insert into HtmlLabelInfo values(16324,'',8) 
/
insert into HtmlLabelInfo values(16325,'房型',7) 
/
insert into HtmlLabelInfo values(16325,'',8) 
/
insert into HtmlLabelInfo values(16326,'房间数',7) 
/
insert into HtmlLabelInfo values(16326,'',8) 
/
insert into HtmlLabelInfo values(16327,'您没有选中一个请求，所有改变的数据将无法正常保存！',7) 
/
insert into HtmlLabelInfo values(16327,'',8) 
/
insert into HtmlLabelInfo values(16328,'评估标准',7) 
/
insert into HtmlLabelInfo values(16328,'',8) 
/
insert into HtmlLabelInfo values(16329,'良',7) 
/
insert into HtmlLabelInfo values(16329,'',8) 
/
insert into HtmlLabelInfo values(16330,'中',7) 
/
insert into HtmlLabelInfo values(16330,'',8) 
/
insert into HtmlLabelInfo values(16331,'评分不能大于5分',7) 
/
insert into HtmlLabelInfo values(16331,'',8) 
/
insert into HtmlLabelInfo values(16332,'工作流信息保存错误',7) 
/
insert into HtmlLabelInfo values(16332,'',8) 
/
insert into HtmlLabelInfo values(16333,'工作流下一节点或下一节点操作者错误',7) 
/
insert into HtmlLabelInfo values(16333,'',8) 
/
insert into HtmlLabelInfo values(16334,'工作流流转...',7) 
/
insert into HtmlLabelInfo values(16334,'',8) 
/
insert into HtmlLabelInfo values(16335,'全部删除',7) 
/
insert into HtmlLabelInfo values(16335,'',8) 
/
insert into HtmlLabelInfo values(16336,'创建任务',7) 
/
insert into HtmlLabelInfo values(16336,'',8) 
/
insert into HtmlLabelInfo values(16337,'任务已完成',7) 
/
insert into HtmlLabelInfo values(16337,'',8) 
/
insert into HtmlLabelInfo values(16338,'任务延期',7) 
/
insert into HtmlLabelInfo values(16338,'',8) 
/
insert into HtmlLabelInfo values(16339,'任务进行中',7) 
/
insert into HtmlLabelInfo values(16339,'',8) 
/
insert into HtmlLabelInfo values(16340,'延期日期',7) 
/
insert into HtmlLabelInfo values(16340,'',8) 
/
insert into HtmlLabelInfo values(16341,'最后操作人',7) 
/
insert into HtmlLabelInfo values(16341,'',8) 
/
insert into HtmlLabelInfo values(16342,'所有未完成请求',7) 
/
insert into HtmlLabelInfo values(16342,'',8) 
/
insert into HtmlLabelInfo values(16343,'所有已完成请求',7) 
/
insert into HtmlLabelInfo values(16343,'',8) 
/
insert into HtmlLabelInfo values(16344,'确定删除选定的信息吗?',7) 
/
insert into HtmlLabelInfo values(16344,'',8) 
/
insert into HtmlLabelInfo values(16345,'添加用户',7) 
/
insert into HtmlLabelInfo values(16345,'',8) 
/
insert into HtmlLabelInfo values(16346,'全部请求',7) 
/
insert into HtmlLabelInfo values(16346,'',8) 
/
insert into HtmlLabelInfo values(16347,'所有待处理事宜',7) 
/
insert into HtmlLabelInfo values(16347,'',8) 
/
insert into HtmlLabelInfo values(16348,'所有已完成事宜',7) 
/
insert into HtmlLabelInfo values(16348,'',8) 
/
insert into HtmlLabelInfo values(16349,'待处理',7) 
/
insert into HtmlLabelInfo values(16349,'',8) 
/
insert into HtmlLabelInfo values(16350,'同意延期',7) 
/
insert into HtmlLabelInfo values(16350,'',8) 
/
insert into HtmlLabelInfo values(16351,'退回重新执行',7) 
/
insert into HtmlLabelInfo values(16351,'',8) 
/
insert into HtmlLabelInfo values(16352,'定制工作流程图',7) 
/
insert into HtmlLabelInfo values(16352,'',8) 
/
insert into HtmlLabelInfo values(16353,'已操作者',7) 
/
insert into HtmlLabelInfo values(16353,'',8) 
/
insert into HtmlLabelInfo values(16354,'未操作者',7) 
/
insert into HtmlLabelInfo values(16354,'',8) 
/
insert into HtmlLabelInfo values(16355,'查看者',7) 
/
insert into HtmlLabelInfo values(16355,'',8) 
/
insert into HtmlLabelInfo values(16389,'查看页面属性',7) 
/
insert into HtmlLabelInfo values(16392,'新建流程',7) 
/
insert into HtmlLabelInfo values(16392,'',8) 
/
insert into HtmlLabelInfo values(16394,'我的知识',7) 
/
insert into HtmlLabelInfo values(16395,'订阅知识',7) 
/
insert into HtmlLabelInfo values(16400,'新的客户',7) 
/
insert into HtmlLabelInfo values(16400,'',8) 
/
insert into HtmlLabelInfo values(16401,'分类客户',7) 
/
insert into HtmlLabelInfo values(16401,'',8) 
/
insert into HtmlLabelInfo values(16403,'',8) 
/
insert into HtmlLabelInfo values(16404,'销售合同',7) 
/
insert into HtmlLabelInfo values(16404,'',8) 
/
insert into HtmlLabelInfo values(16405,'',8) 
/
insert into HtmlLabelInfo values(16406,'客户审批',7) 
/
insert into HtmlLabelInfo values(16406,'',8) 
/
insert into HtmlLabelInfo values(16408,'项目执行',7) 
/
insert into HtmlLabelInfo values(16408,'',8) 
/
insert into HtmlLabelInfo values(16411,'当前任务',7) 
/
insert into HtmlLabelInfo values(16411,'',8) 
/
insert into HtmlLabelInfo values(16412,'',8) 
/
insert into HtmlLabelInfo values(16413,'查询项目',7) 
/
insert into HtmlLabelInfo values(16414,'我的人事',7) 
/
insert into HtmlLabelInfo values(16414,'',8) 
/
insert into HtmlLabelInfo values(16416,'我的工资',7) 
/
insert into HtmlLabelInfo values(16416,'',8) 
/
insert into HtmlLabelInfo values(16417,'',8) 
/
insert into HtmlLabelInfo values(16418,'',8) 
/
insert into HtmlLabelInfo values(16419,'',8) 
/
insert into HtmlLabelInfo values(16420,'新的会议',7) 
/
insert into HtmlLabelInfo values(16421,'老的会议',7) 
/
insert into HtmlLabelInfo values(16421,'',8) 
/
insert into HtmlLabelInfo values(16422,'会议室分配',7) 
/
insert into HtmlLabelInfo values(16423,'',8) 
/
insert into HtmlLabelInfo values(16426,'',8) 
/
insert into HtmlLabelInfo values(16429,'',8) 
/
insert into HtmlLabelInfo values(16430,'',8) 
/
insert into HtmlLabelInfo values(16431,'',8) 
/
insert into HtmlLabelInfo values(16432,'',8) 
/
insert into HtmlLabelInfo values(16435,'收件邮箱',7) 
/
insert into HtmlLabelInfo values(16436,'发件邮箱',7) 
/
insert into HtmlLabelInfo values(16437,'',8) 
/
insert into HtmlLabelInfo values(16438,'',8) 
/
insert into HtmlLabelInfo values(16439,'本地邮箱',7) 
/
insert into HtmlLabelInfo values(16440,'查询邮件',7) 
/
insert into HtmlLabelInfo values(16440,'',8) 
/
insert into HtmlLabelInfo values(16441,'群发邮件',7) 
/
insert into HtmlLabelInfo values(16442,'邮箱设置',7) 
/
insert into HtmlLabelInfo values(16443,'我的短信',7) 
/
insert into HtmlLabelInfo values(16444,'新建短信',7) 
/
insert into HtmlLabelInfo values(16446,'',8) 
/
insert into HtmlLabelInfo values(16448,'',8) 
/
insert into HtmlLabelInfo values(16450,'显示模板',7) 
/
insert into HtmlLabelInfo values(16450,'',8) 
/
insert into HtmlLabelInfo values(16451,'页面设置',7) 
/
insert into HtmlLabelInfo values(16451,'',8) 
/
insert into HtmlLabelInfo values(16455,'组织结构',7) 
/
insert into HtmlLabelInfo values(16456,'总部设置',7) 
/
insert into HtmlLabelInfo values(16457,'分部设置',7) 
/
insert into HtmlLabelInfo values(16458,'部门设置',7) 
/
insert into HtmlLabelInfo values(16459,'图形编辑 ',7) 
/
insert into HtmlLabelInfo values(16460,'职务设置',7) 
/
insert into HtmlLabelInfo values(16460,'',8) 
/
insert into HtmlLabelInfo values(16461,'',8) 
/
insert into HtmlLabelInfo values(16462,'职称设置',7) 
/
insert into HtmlLabelInfo values(16462,'',8) 
/
insert into HtmlLabelInfo values(16463,'专业设置',7) 
/
insert into HtmlLabelInfo values(16463,'',8) 
/
insert into HtmlLabelInfo values(16464,'学历设置',7) 
/
insert into HtmlLabelInfo values(16465,'',8) 
/
insert into HtmlLabelInfo values(16466,'',8) 
/
insert into HtmlLabelInfo values(16467,'人员续签',7) 
/
insert into HtmlLabelInfo values(16468,'',8) 
/
insert into HtmlLabelInfo values(16469,'',8) 
/
insert into HtmlLabelInfo values(16470,'',8) 
/
insert into HtmlLabelInfo values(16471,'',8) 
/
insert into HtmlLabelInfo values(16473,'',8) 
/
insert into HtmlLabelInfo values(16475,'公司时间',7) 
/
insert into HtmlLabelInfo values(16475,'',8) 
/
insert into HtmlLabelInfo values(16478,'公众假日',7) 
/
insert into HtmlLabelInfo values(16481,'薪酬设置',7) 
/
insert into HtmlLabelInfo values(16483,'路径设置',7) 
/
insert into HtmlLabelInfo values(16483,'',8) 
/
insert into HtmlLabelInfo values(16484,'基础设置',7) 
/
insert into HtmlLabelInfo values(16485,'称呼设置',7) 
/
insert into HtmlLabelInfo values(16486,'地址类型',7) 
/
insert into HtmlLabelInfo values(16486,'',8) 
/
insert into HtmlLabelInfo values(16487,'帐户定义',7) 
/
insert into HtmlLabelInfo values(16488,'联系定义',7) 
/
insert into HtmlLabelInfo values(16489,'地址定义',7) 
/
insert into HtmlLabelInfo values(16491,'',8) 
/
insert into HtmlLabelInfo values(16494,'',8) 
/
insert into HtmlLabelInfo values(16495,'',8) 
/
insert into HtmlLabelInfo values(16497,'',8) 
/
insert into HtmlLabelInfo values(16498,'时间设置',7) 
/
insert into HtmlLabelInfo values(16499,'成功因素',7) 
/
insert into HtmlLabelInfo values(16500,'失败因素',7) 
/
insert into HtmlLabelInfo values(16503,'',8) 
/
insert into HtmlLabelInfo values(16505,'预算设置',7) 
/
insert into HtmlLabelInfo values(16506,'',8) 
/
insert into HtmlLabelInfo values(16507,'指标设置',7) 
/
insert into HtmlLabelInfo values(16507,'',8) 
/
insert into HtmlLabelInfo values(16508,'',8) 
/
insert into HtmlLabelInfo values(16509,'',8) 
/
insert into HtmlLabelInfo values(16512,'产品设置',7) 
/
insert into HtmlLabelInfo values(16512,'',8) 
/
insert into HtmlLabelInfo values(16513,'新建产品',7) 
/
insert into HtmlLabelInfo values(16513,'',8) 
/
insert into HtmlLabelInfo values(16514,'调查设置',7) 
/
insert into HtmlLabelInfo values(16514,'',8) 
/
insert into HtmlLabelInfo values(16515,'报表设定',7) 
/
insert into HtmlLabelInfo values(16516,'输入维护',7) 
/
insert into HtmlLabelInfo values(16517,'',8) 
/
insert into HtmlLabelInfo values(16518,'',8) 
/
insert into HtmlLabelInfo values(16519,'输入确认',7) 
/
insert into HtmlLabelInfo values(16520,'输入监控',7) 
/
insert into HtmlLabelInfo values(16521,'',8) 
/
insert into HtmlLabelInfo values(16522,'国家设置',7) 
/
insert into HtmlLabelInfo values(16523,'',8) 
/
insert into HtmlLabelInfo values(16524,'城市设置',7) 
/
insert into HtmlLabelInfo values(16524,'',8) 
/
insert into HtmlLabelInfo values(16525,'币种设置',7) 
/
insert into HtmlLabelInfo values(16525,'',8) 
/
insert into HtmlLabelInfo values(16526,'权限设置',7) 
/
insert into HtmlLabelInfo values(16526,'',8) 
/
insert into HtmlLabelInfo values(16527,'角色设置',7) 
/
insert into HtmlLabelInfo values(16527,'',8) 
/
insert into HtmlLabelInfo values(16528,'权限转移',7) 
/
insert into HtmlLabelInfo values(16528,'',8) 
/
insert into HtmlLabelInfo values(16530,'',8) 
/
insert into HtmlLabelInfo values(16531,'项目报表',7) 
/
insert into HtmlLabelInfo values(16532,'流程报表',7) 
/
insert into HtmlLabelInfo values(16532,'',8) 
/
insert into HtmlLabelInfo values(16533,'客户报表',7) 
/
insert into HtmlLabelInfo values(16533,'',8) 
/
insert into HtmlLabelInfo values(16534,'财务报表',7) 
/
insert into HtmlLabelInfo values(16535,'',8) 
/
insert into HtmlLabelInfo values(16536,'知识报表',7) 
/
insert into HtmlLabelInfo values(16538,'',8) 
/
insert into HtmlLabelInfo values(16543,'',8) 
/
insert into HtmlLabelInfo values(16544,'',8) 
/
insert into HtmlLabelInfo values(16545,'年龄报表',7) 
/
insert into HtmlLabelInfo values(16545,'',8) 
/
insert into HtmlLabelInfo values(16547,'请假报表',7) 
/
insert into HtmlLabelInfo values(16547,'',8) 
/
insert into HtmlLabelInfo values(16548,'性别报表',7) 
/
insert into HtmlLabelInfo values(16549,'工龄报表',7) 
/
insert into HtmlLabelInfo values(16551,'',8) 
/
insert into HtmlLabelInfo values(16552,'',8) 
/
insert into HtmlLabelInfo values(16553,'职务报表',7) 
/
insert into HtmlLabelInfo values(16554,'职称报表',7) 
/
insert into HtmlLabelInfo values(16556,'',8) 
/
insert into HtmlLabelInfo values(16557,'考勤相关',7) 
/
insert into HtmlLabelInfo values(16558,'考勤统计',7) 
/
insert into HtmlLabelInfo values(16558,'',8) 
/
insert into HtmlLabelInfo values(16559,'考勤报表',7) 
/
insert into HtmlLabelInfo values(16560,'薪金统计',7) 
/
insert into HtmlLabelInfo values(16561,'工资差异',7) 
/
insert into HtmlLabelInfo values(16562,'差异总额',7) 
/
insert into HtmlLabelInfo values(16562,'',8) 
/
insert into HtmlLabelInfo values(16563,'变动相关',7) 
/
insert into HtmlLabelInfo values(16564,'',8) 
/
insert into HtmlLabelInfo values(16565,'',8) 
/
insert into HtmlLabelInfo values(16566,'转正情况',7) 
/
insert into HtmlLabelInfo values(16566,'',8) 
/
insert into HtmlLabelInfo values(16567,'续签情况',7) 
/
insert into HtmlLabelInfo values(16567,'',8) 
/
insert into HtmlLabelInfo values(16568,'返聘情况',7) 
/
insert into HtmlLabelInfo values(16568,'',8) 
/
insert into HtmlLabelInfo values(16569,'',8) 
/
insert into HtmlLabelInfo values(16570,'',8) 
/
insert into HtmlLabelInfo values(16571,'解聘情况',7) 
/
insert into HtmlLabelInfo values(16574,'项目部门',7) 
/
insert into HtmlLabelInfo values(16574,'',8) 
/
insert into HtmlLabelInfo values(16575,'',8) 
/
insert into HtmlLabelInfo values(16576,'',8) 
/
insert into HtmlLabelInfo values(16577,'',8) 
/
insert into HtmlLabelInfo values(16578,'近期操作',7) 
/
insert into HtmlLabelInfo values(16578,'',8) 
/
insert into HtmlLabelInfo values(16580,'定义报表',7) 
/
insert into HtmlLabelInfo values(16580,'',8) 
/
insert into HtmlLabelInfo values(16581,'基本报表',7) 
/
insert into HtmlLabelInfo values(16582,'客户类别',7) 
/
insert into HtmlLabelInfo values(16582,'',8) 
/
insert into HtmlLabelInfo values(16586,'合同相关',7) 
/
insert into HtmlLabelInfo values(16587,'合同列表',7) 
/
insert into HtmlLabelInfo values(16588,'',8) 
/
insert into HtmlLabelInfo values(16589,'',8) 
/
insert into HtmlLabelInfo values(16590,'',8) 
/
insert into HtmlLabelInfo values(16591,'',8) 
/
insert into HtmlLabelInfo values(16592,'人员金额',7) 
/
insert into HtmlLabelInfo values(16592,'',8) 
/
insert into HtmlLabelInfo values(16593,'客户金额',7) 
/
insert into HtmlLabelInfo values(16593,'',8) 
/
insert into HtmlLabelInfo values(16595,'',8) 
/
insert into HtmlLabelInfo values(16597,'类型报表',7) 
/
insert into HtmlLabelInfo values(16597,'',8) 
/
insert into HtmlLabelInfo values(16598,'',8) 
/
insert into HtmlLabelInfo values(16599,'部门资产',7) 
/
insert into HtmlLabelInfo values(16601,'',8) 
/
insert into HtmlLabelInfo values(16602,'最近阅读日志',7) 
/
insert into HtmlLabelInfo values(16602,'',8) 
/
insert into HtmlLabelInfo values(16603,'知识沉积报表',7) 
/
insert into HtmlLabelInfo values(16603,'',8) 
/
insert into HtmlLabelInfo values(16605,'',8) 
/
insert into HtmlLabelInfo values(16606,'最多被阅文档',7) 
/
insert into HtmlLabelInfo values(16606,'',8) 
/
insert into HtmlLabelInfo values(16608,'最多文档语言',7) 
/
insert into HtmlLabelInfo values(16609,'最多文档客户',7) 
/
insert into HtmlLabelInfo values(16609,'',8) 
/
insert into HtmlLabelInfo values(16610,'',8) 
/
insert into HtmlLabelInfo values(16611,'最多文档项目',7) 
/
insert into HtmlLabelInfo values(16612,'',8) 
/
insert into HtmlLabelInfo values(16614,'会议室报表',7) 
/
insert into HtmlLabelInfo values(16615,'',8) 
/
insert into HtmlLabelInfo values(16617,'资产组设置',7) 
/
insert into HtmlLabelInfo values(16617,'',8) 
/
insert into HtmlLabelInfo values(16619,'打开预算输入',7) 
/
insert into HtmlLabelInfo values(16622,'更改已成功',7) 
/
insert into HtmlLabelInfo values(16623,'审核状态',7) 
/
insert into HtmlLabelInfo values(16623,'ConfirmStatus',8) 
/
insert into HtmlLabelInfo values(16624,'审核确认',7) 
/
insert into HtmlLabelInfo values(16624,'ConfirmSucc',8) 
/
insert into HtmlLabelInfo values(16627,'',8) 
/
insert into HtmlLabelInfo values(16628,'确定要退出系统吗？',7) 
/
insert into HtmlLabelInfo values(16630,'uploadexcelfile',8) 
/
insert into HtmlLabelInfo values(16631,'确认',7) 
/
insert into HtmlLabelInfo values(16631,'Confirm',8) 
/
insert into HtmlLabelInfo values(16633,'送货信息',7) 
/
insert into HtmlLabelInfo values(16634,'',8) 
/
insert into HtmlLabelInfo values(16635,'发送短信',7) 
/
insert into HtmlLabelInfo values(16635,'',8) 
/
insert into HtmlLabelInfo values(16636,'隐藏',7) 
/
insert into HtmlLabelInfo values(16637,'邮件组',7) 
/
insert into HtmlLabelInfo values(16638,'',8) 
/
insert into HtmlLabelInfo values(16639,'移动到服务器',7) 
/
insert into HtmlLabelInfo values(16639,'',8) 
/
insert into HtmlLabelInfo values(2051,'发送邮件',7) 
/
insert into HtmlLabelInfo values(2051,'发送邮件',8) 
/
insert into HtmlLabelInfo values(2052,'转发邮件',7) 
/
insert into HtmlLabelInfo values(2052,'转发邮件',8) 
/
insert into HtmlLabelInfo values(2053,'回复全部',8) 
/
insert into HtmlLabelInfo values(2053,'回复全部',7) 
/
insert into HtmlLabelInfo values(2054,'回复邮件',8) 
/
insert into HtmlLabelInfo values(2054,'回复邮件',7) 
/
insert into HtmlLabelInfo values(2055,'',8) 
/
insert into HtmlLabelInfo values(2055,'转发邮件',7) 
/
insert into HtmlLabelInfo values(2056,'移动到本地',7) 
/
insert into HtmlLabelInfo values(2056,'移动到本地',8) 
/
insert into HtmlLabelInfo values(2057,'复制到本地',7) 
/
insert into HtmlLabelInfo values(2057,'复制到本地',8) 
/
insert into HtmlLabelInfo values(2058,'邮件服务器',7) 
/
insert into HtmlLabelInfo values(2058,'邮件服务器',8) 
/
insert into HtmlLabelInfo values(2059,'Login log',8) 
/
insert into HtmlLabelInfo values(2059,'登录日志',7) 
/
insert into HtmlLabelInfo values(2060,'类名称',7) 
/
insert into HtmlLabelInfo values(2060,'类名称',8) 
/
insert into HtmlLabelInfo values(2061,'日志日期',7) 
/
insert into HtmlLabelInfo values(2061,'日志日期',8) 
/
insert into HtmlLabelInfo values(2062,'客户联系计划',7) 
/
insert into HtmlLabelInfo values(2062,'客户联系计划',8) 
/
insert into HtmlLabelInfo values(2063,'',8) 
/
insert into HtmlLabelInfo values(2063,'新的工作流到达:新',7) 
/
insert into HtmlLabelInfo values(2064,'',8) 
/
insert into HtmlLabelInfo values(2064,'新的工作流到达:待处理工作流',7) 
/
insert into HtmlLabelInfo values(2065,'',8) 
/
insert into HtmlLabelInfo values(2065,'新的工作流到达:正常',7) 
/
insert into HtmlLabelInfo values(2066,'',8) 
/
insert into HtmlLabelInfo values(2066,'工作流完成',7) 
/
insert into HtmlLabelInfo values(2067,'',8) 
/
insert into HtmlLabelInfo values(2067,'工作流完成(待处理)',7) 
/
insert into HtmlLabelInfo values(2068,'节点超时',7) 
/
insert into HtmlLabelInfo values(2068,'节点超时',8) 
/
insert into HtmlLabelInfo values(2069,'审批文档',7) 
/
insert into HtmlLabelInfo values(2069,'审批文档',8) 
/
insert into HtmlLabelInfo values(2070,'Process ',8) 
/
insert into HtmlLabelInfo values(2070,'处理文档',7) 
/
insert into HtmlLabelInfo values(2071,'数据库服务器',7) 
/
insert into HtmlLabelInfo values(2071,'数据库服务器',8) 
/
insert into HtmlLabelInfo values(2072,'Login name',8) 
/
insert into HtmlLabelInfo values(2072,'用户名',7) 
/
insert into HtmlLabelInfo values(2073,'重设',7) 
/
insert into HtmlLabelInfo values(2073,'重设',8) 
/
insert into HtmlLabelInfo values(2074,'标题内容',7) 
/
insert into HtmlLabelInfo values(2074,'标题内容',8) 
/
insert into HtmlLabelInfo values(2075,'Rate of motion',8) 
/
insert into HtmlLabelInfo values(2075,'移动速度',7) 
/
insert into HtmlLabelInfo values(2076,'字体颜色',7) 
/
insert into HtmlLabelInfo values(2076,'字体颜色',8) 
/
insert into HtmlLabelInfo values(2077,'背景颜色',7) 
/
insert into HtmlLabelInfo values(2077,'背景颜色',8) 
/
insert into HtmlLabelInfo values(2078,'最后操作时间',7) 
/
insert into HtmlLabelInfo values(2078,'最后操作时间',8) 
/
insert into HtmlLabelInfo values(2079,'工作流名称',7) 
/
insert into HtmlLabelInfo values(2079,'工作流名称',8) 
/
insert into HtmlLabelInfo values(2080,'Recent news',8) 
/
insert into HtmlLabelInfo values(2080,'最近新闻',7) 
/
insert into HtmlLabelInfo values(2081,'Favorite',8) 
/
insert into HtmlLabelInfo values(2081,'收藏夹',7) 
/
insert into HtmlLabelInfo values(2082,'Joining day',8) 
/
insert into HtmlLabelInfo values(2082,'加入时间',7) 
/
insert into HtmlLabelInfo values(2083,'Recipient',8) 
/
insert into HtmlLabelInfo values(2083,'发送',7) 
/
insert into HtmlLabelInfo values(2084,'Copy recipient',8) 
/
insert into HtmlLabelInfo values(2084,'抄送',7) 
/
insert into HtmlLabelInfo values(2085,'Confidential recipient',8) 
/
insert into HtmlLabelInfo values(2085,'密送',7) 
/
insert into HtmlLabelInfo values(2086,'Normal',8) 
/
insert into HtmlLabelInfo values(2086,'普通',7) 
/
insert into HtmlLabelInfo values(2087,'Emergent',8) 
/
insert into HtmlLabelInfo values(2087,'紧急',7) 
/
insert into HtmlLabelInfo values(2088,'Not important',8) 
/
insert into HtmlLabelInfo values(2088,'不重要',7) 
/
insert into HtmlLabelInfo values(2089,'Please separate with the English comma between multi-recipient',8) 
/
insert into HtmlLabelInfo values(2089,'多收件人请用逗号分隔',7) 
/
insert into HtmlLabelInfo values(2090,'Please separate with the English comma between multi-copy recipient',8) 
/
insert into HtmlLabelInfo values(2090,'多抄送人请用逗号分隔',7) 
/
insert into HtmlLabelInfo values(2091,'Please separate with the English comma between multi-confidential recipient',8) 
/
insert into HtmlLabelInfo values(2091,'多密送人请用逗号分隔',7) 
/
insert into HtmlLabelInfo values(2092,'Save in outbox',8) 
/
insert into HtmlLabelInfo values(2092,'保存到发件箱',7) 
/
insert into HtmlLabelInfo values(2093,'Priority',8) 
/
insert into HtmlLabelInfo values(2093,'优先级别',7) 
/
insert into HtmlLabelInfo values(2094,'Owner',8) 
/
insert into HtmlLabelInfo values(2094,'文档所有者',7) 
/
insert into HtmlLabelInfo values(2095,'Key word',8) 
/
insert into HtmlLabelInfo values(2095,'关鍵字',7) 
/
insert into HtmlLabelInfo values(2096,'Reply opinion',8) 
/
insert into HtmlLabelInfo values(2096,'批复内容',7) 
/
insert into HtmlLabelInfo values(2097,'Principal',8) 
/
insert into HtmlLabelInfo values(2097,'负责人',7) 
/
insert into HtmlLabelInfo values(2098,'Sub-task',8) 
/
insert into HtmlLabelInfo values(2098,'子任务',7) 
/
insert into HtmlLabelInfo values(2099,'Task Spread',8) 
/
insert into HtmlLabelInfo values(2099,'任务展开',7) 
/
insert into HtmlLabelInfo values(2100,'Save as plan',8) 
/
insert into HtmlLabelInfo values(2100,'保存为计划',7) 
/
insert into HtmlLabelInfo values(2101,'My plans',8) 
/
insert into HtmlLabelInfo values(2101,'我的计划',7) 
/
insert into HtmlLabelInfo values(2102,'My Conference',8) 
/
insert into HtmlLabelInfo values(2102,'我的会议',7) 
/
insert into HtmlLabelInfo values(2103,'Conference',8) 
/
insert into HtmlLabelInfo values(2103,'会议',7) 
/
insert into HtmlLabelInfo values(2104,'Conference type',8) 
/
insert into HtmlLabelInfo values(2104,'会议类型',7) 
/
insert into HtmlLabelInfo values(2105,'Conference place',8) 
/
insert into HtmlLabelInfo values(2105,'会议地点',7) 
/
insert into HtmlLabelInfo values(2106,'Attending person',8) 
/
insert into HtmlLabelInfo values(2106,'参会人员',7) 
/
insert into HtmlLabelInfo values(2107,'Conference service',8) 
/
insert into HtmlLabelInfo values(2107,'会议服务',7) 
/
insert into HtmlLabelInfo values(2108,'Receipt',8) 
/
insert into HtmlLabelInfo values(2108,'回执',7) 
/
insert into HtmlLabelInfo values(2109,'The number of record ',8) 
/
insert into HtmlLabelInfo values(2109,'记录数',7) 
/
insert into HtmlLabelInfo values(2110,'Current page',8) 
/
insert into HtmlLabelInfo values(2110,'当前页码',7) 
/
insert into HtmlLabelInfo values(2111,'The number of record ',8) 
/
insert into HtmlLabelInfo values(2111,'共有记录',7) 
/
insert into HtmlLabelInfo values(2112,'Share setting',8) 
/
insert into HtmlLabelInfo values(2112,'共享设置',7) 
/
insert into HtmlLabelInfo values(2113,'CRM',8) 
/
insert into HtmlLabelInfo values(2113,'客户管理',7) 
/
insert into HtmlLabelInfo values(2114,'Project',8) 
/
insert into HtmlLabelInfo values(2114,'项目管理',7) 
/
insert into HtmlLabelInfo values(2115,'Document',8) 
/
insert into HtmlLabelInfo values(2115,'知识管理',7) 
/
insert into HtmlLabelInfo values(2116,'Logistics',8) 
/
insert into HtmlLabelInfo values(2116,'资产管理',7) 
/
insert into HtmlLabelInfo values(2117,'Financials',8) 
/
insert into HtmlLabelInfo values(2117,'财务管理',7) 
/
insert into HtmlLabelInfo values(2118,'Workflow',8) 
/
insert into HtmlLabelInfo values(2118,'工作流程',7) 
/
insert into HtmlLabelInfo values(2119,'Post-doctor',8) 
/
insert into HtmlLabelInfo values(2119,'博士后',7) 
/
insert into HtmlLabelInfo values(2120,'Direct superior',8) 
/
insert into HtmlLabelInfo values(2120,'直接上级',7) 
/
insert into HtmlLabelInfo values(2121,'The detail',8) 
/
insert into HtmlLabelInfo values(2121,'详细信息',7) 
/
insert into HtmlLabelInfo values(2151,'Conference subject',8) 
/
insert into HtmlLabelInfo values(2151,'会议名称',7) 
/
insert into HtmlLabelInfo values(2152,'Convener ',8) 
/
insert into HtmlLabelInfo values(2152,'召集人',7) 
/
insert into HtmlLabelInfo values(2153,'Approver',8) 
/
insert into HtmlLabelInfo values(2153,'批准人',7) 
/
insert into HtmlLabelInfo values(2154,'Other place',8) 
/
insert into HtmlLabelInfo values(2154,'其他地点',7) 
/
insert into HtmlLabelInfo values(2155,'Service type',8) 
/
insert into HtmlLabelInfo values(2155,'服务类型',7) 
/
insert into HtmlLabelInfo values(2156,'',8) 
/
insert into HtmlLabelInfo values(2156,'负责人员',7) 
/
insert into HtmlLabelInfo values(2157,'Service item',8) 
/
insert into HtmlLabelInfo values(2157,'服务项目',7) 
/
insert into HtmlLabelInfo values(2158,'Please separate with the English comma between multi-items ',8) 
/
insert into HtmlLabelInfo values(2158,'多个服务项目之间请用英文逗号,分隔',7) 
/
insert into HtmlLabelInfo values(2159,'Compart',8) 
/
insert into HtmlLabelInfo values(2159,'分隔',7) 
/
insert into HtmlLabelInfo values(2160,'Conference receipt',8) 
/
insert into HtmlLabelInfo values(2160,'会议回执',7) 
/
insert into HtmlLabelInfo values(2161,'Open',8) 
/
insert into HtmlLabelInfo values(2161,'公开',7) 
/
insert into HtmlLabelInfo values(2162,'',8) 
/
insert into HtmlLabelInfo values(2162,'会议日期',7) 
/
insert into HtmlLabelInfo values(2163,'',8) 
/
insert into HtmlLabelInfo values(2163,'大会议室',7) 
/
insert into HtmlLabelInfo values(2164,'Small meeting room',8) 
/
insert into HtmlLabelInfo values(2164,'小会议室',7) 
/
insert into HtmlLabelInfo values(2165,'Use report of meeting room',8) 
/
insert into HtmlLabelInfo values(2165,'查看会议室使用状况',7) 
/
insert into HtmlLabelInfo values(2166,'Number of people that should arrive',8) 
/
insert into HtmlLabelInfo values(2166,'应到人数',7) 
/
insert into HtmlLabelInfo values(2167,'Customer',8) 
/
insert into HtmlLabelInfo values(2167,'参会客户',7) 
/
insert into HtmlLabelInfo values(2168,'Other attendee',8) 
/
insert into HtmlLabelInfo values(2168,'其他人员',7) 
/
insert into HtmlLabelInfo values(2169,'Agenda ',8) 
/
insert into HtmlLabelInfo values(2169,'议程',7) 
/
insert into HtmlLabelInfo values(2170,'Decision summary',8) 
/
insert into HtmlLabelInfo values(2170,'决议概述',7) 
/
insert into HtmlLabelInfo values(2171,'Decision',8) 
/
insert into HtmlLabelInfo values(2171,'决议',7) 
/
insert into HtmlLabelInfo values(2172,'Executor',8) 
/
insert into HtmlLabelInfo values(2172,'执行人',7) 
/
insert into HtmlLabelInfo values(2173,'Scrutineer ',8) 
/
insert into HtmlLabelInfo values(2173,'检查人',7) 
/
insert into HtmlLabelInfo values(2174,'First class',8) 
/
insert into HtmlLabelInfo values(2174,'头等舱',7) 
/
insert into HtmlLabelInfo values(2175,'Business class',8) 
/
insert into HtmlLabelInfo values(2175,'公务舱',7) 
/
insert into HtmlLabelInfo values(2176,'Economy class',8) 
/
insert into HtmlLabelInfo values(2176,'经济舱',7) 
/
insert into HtmlLabelInfo values(2177,'Soft berth',8) 
/
insert into HtmlLabelInfo values(2177,'软卧',7) 
/
insert into HtmlLabelInfo values(2178,'Hard berth',8) 
/
insert into HtmlLabelInfo values(2178,'硬卧',7) 
/
insert into HtmlLabelInfo values(2179,'Hard seat',8) 
/
insert into HtmlLabelInfo values(2179,'硬座',7) 
/
insert into HtmlLabelInfo values(2180,'Plane',8) 
/
insert into HtmlLabelInfo values(2180,'飞机',7) 
/
insert into HtmlLabelInfo values(2181,'Train',8) 
/
insert into HtmlLabelInfo values(2181,'火车',7) 
/
insert into HtmlLabelInfo values(2182,'Vehicle',8) 
/
insert into HtmlLabelInfo values(2182,'交通工具',7) 
/
insert into HtmlLabelInfo values(2183,'Return date,time',8) 
/
insert into HtmlLabelInfo values(2183,'回程日期.时间',7) 
/
insert into HtmlLabelInfo values(2184,'Order the returen ticket',8) 
/
insert into HtmlLabelInfo values(2184,'是否需订回程票',7) 
/
insert into HtmlLabelInfo values(2185,'Reserve room(room standard)',8) 
/
insert into HtmlLabelInfo values(2185,'是否需订房(标准)',7) 
/
insert into HtmlLabelInfo values(2186,'Arriving Date,Time',8) 
/
insert into HtmlLabelInfo values(2186,'预计到达日期.时间',7) 
/
insert into HtmlLabelInfo values(2187,'Whether attend',8) 
/
insert into HtmlLabelInfo values(2187,'是否参加',7) 
/
insert into HtmlLabelInfo values(2188,'Other Attendee',8) 
/
insert into HtmlLabelInfo values(2188,'其他人参加',7) 
/
insert into HtmlLabelInfo values(2189,'Other attendee',8) 
/
insert into HtmlLabelInfo values(2189,'其他参会人员',7) 
/
insert into HtmlLabelInfo values(2190,'Finish allocating ',8) 
/
insert into HtmlLabelInfo values(2190,'调配完毕',7) 
/
insert into HtmlLabelInfo values(2191,'Adjust',8) 
/
insert into HtmlLabelInfo values(2191,'调整',7) 
/
insert into HtmlLabelInfo values(2192,'Arrange Schedule',8) 
/
insert into HtmlLabelInfo values(2192,'日程安排',7) 
/
insert into HtmlLabelInfo values(2193,'Use report of meeting room',8) 
/
insert into HtmlLabelInfo values(2193,'查看会议室使用情况',7) 
/
insert into HtmlLabelInfo values(2194,'Conference decision',8) 
/
insert into HtmlLabelInfo values(2194,'会议决议',7) 
/
insert into HtmlLabelInfo values(2195,'Attend',8) 
/
insert into HtmlLabelInfo values(2195,'参加',7) 
/
insert into HtmlLabelInfo values(2196,'Arriving time',8) 
/
insert into HtmlLabelInfo values(2196,'到达时间',7) 
/
insert into HtmlLabelInfo values(2197,'Reserve room',8) 
/
insert into HtmlLabelInfo values(2197,'订房',7) 
/
insert into HtmlLabelInfo values(2198,'Room standard',8) 
/
insert into HtmlLabelInfo values(2198,'订房标准',7) 
/
insert into HtmlLabelInfo values(2199,'Order the returen ticket',8) 
/
insert into HtmlLabelInfo values(2199,'订回程票',7) 
/
insert into HtmlLabelInfo values(2200,'Time of return',8) 
/
insert into HtmlLabelInfo values(2200,'回程时间',7) 
/
insert into HtmlLabelInfo values(2201,'Plane first class ',8) 
/
insert into HtmlLabelInfo values(2201,'飞机头等舱',7) 
/
insert into HtmlLabelInfo values(2202,'Plane business class',8) 
/
insert into HtmlLabelInfo values(2202,'飞机公务舱',7) 
/
insert into HtmlLabelInfo values(2203,'Plane economy class',8) 
/
insert into HtmlLabelInfo values(2203,'飞机经济舱',7) 
/
insert into HtmlLabelInfo values(2204,'Train soft berth',8) 
/
insert into HtmlLabelInfo values(2204,'火车软卧',7) 
/
insert into HtmlLabelInfo values(2205,'Train hard berth',8) 
/
insert into HtmlLabelInfo values(2205,'火车硬卧',7) 
/
insert into HtmlLabelInfo values(2206,'Train hard seat',8) 
/
insert into HtmlLabelInfo values(2206,'火车硬座',7) 
/
insert into HtmlLabelInfo values(2207,'The confirmed number of people',8) 
/
insert into HtmlLabelInfo values(2207,'已确定参会人员总计',7) 
/
insert into HtmlLabelInfo values(2208,'Company staff ',8) 
/
insert into HtmlLabelInfo values(2208,'其中公司员工',7) 
/
insert into HtmlLabelInfo values(2209,'Outside Personnel',8) 
/
insert into HtmlLabelInfo values(2209,'外部人员',7) 
/
insert into HtmlLabelInfo values(2210,'Tidy',8) 
/
insert into HtmlLabelInfo values(2210,'整理',7) 
/
insert into HtmlLabelInfo values(2211,'Schedule ',8) 
/
insert into HtmlLabelInfo values(2211,'日程',7) 
/
insert into HtmlLabelInfo values(2212,'Data',8) 
/
insert into HtmlLabelInfo values(2212,'资料',7) 
/
insert into HtmlLabelInfo values(2213,'Realized',8) 
/
insert into HtmlLabelInfo values(2213,'已实现',7) 
/
insert into HtmlLabelInfo values(2214,'',8) 
/
insert into HtmlLabelInfo values(2214,'个人所得税税率表',7) 
/
insert into HtmlLabelInfo values(2215,'',8) 
/
insert into HtmlLabelInfo values(2215,'参照费率',7) 
/
insert into HtmlLabelInfo values(2216,'',8) 
/
insert into HtmlLabelInfo values(2216,'基准等级',7) 
/
insert into HtmlLabelInfo values(2217,'',8) 
/
insert into HtmlLabelInfo values(2217,'工资项目表',7) 
/
insert into HtmlLabelInfo values(2218,'',8) 
/
insert into HtmlLabelInfo values(2218,'个人工资设置',7) 
/
insert into HtmlLabelInfo values(2219,'',8) 
/
insert into HtmlLabelInfo values(2219,'个人工资变动历史记录',7) 
/
insert into HtmlLabelInfo values(2220,'',8) 
/
insert into HtmlLabelInfo values(2220,'短信服务',7) 
/
insert into HtmlLabelInfo values(2221,'',8) 
/
insert into HtmlLabelInfo values(2221,'短信服务管理',7) 
/
insert into HtmlLabelInfo values(2222,'',8) 
/
insert into HtmlLabelInfo values(2222,'短信服务管理-用户自编短信统计',7) 
/
insert into HtmlLabelInfo values(2223,'',8) 
/
insert into HtmlLabelInfo values(2223,'短信服务管理-系统发送短信统计',7) 
/
insert into HtmlLabelInfo values(2224,'',8) 
/
insert into HtmlLabelInfo values(2224,'新入职员工',7) 
/
insert into HtmlLabelInfo values(2225,'',8) 
/
insert into HtmlLabelInfo values(2225,'入职项目表',7) 
/
insert into HtmlLabelInfo values(2226,'',8) 
/
insert into HtmlLabelInfo values(2226,'新入职员工项目设置',7) 
/
insert into HtmlLabelInfo values(2227,'',8) 
/
insert into HtmlLabelInfo values(2227,'销售机会',7) 
/
insert into HtmlLabelInfo values(2228,'',8) 
/
insert into HtmlLabelInfo values(2228,'项目状态：正常',7) 
/
insert into HtmlLabelInfo values(2229,'',8) 
/
insert into HtmlLabelInfo values(2229,'项目状态：延期',7) 
/
insert into HtmlLabelInfo values(2230,'',8) 
/
insert into HtmlLabelInfo values(2230,'项目状态：完成',7) 
/
insert into HtmlLabelInfo values(2231,'',8) 
/
insert into HtmlLabelInfo values(2231,'项目状态：冻结',7) 
/
insert into HtmlLabelInfo values(2232,'',8) 
/
insert into HtmlLabelInfo values(2232,'里程碑任务',7) 
/
insert into HtmlLabelInfo values(2233,'',8) 
/
insert into HtmlLabelInfo values(2233,'前置任务',7) 
/
insert into HtmlLabelInfo values(2234,'',8) 
/
insert into HtmlLabelInfo values(2234,'进度审批状态',7) 
/
insert into HtmlLabelInfo values(2235,'',8) 
/
insert into HtmlLabelInfo values(2235,'未批准',7) 
/
insert into HtmlLabelInfo values(2236,'',8) 
/
insert into HtmlLabelInfo values(2236,'已经审批',7) 
/
insert into HtmlLabelInfo values(2237,'',8) 
/
insert into HtmlLabelInfo values(2237,'进度图表',7) 
/
insert into HtmlLabelInfo values(2238,'',8) 
/
insert into HtmlLabelInfo values(2238,'工作流/文档',7) 
/
insert into HtmlLabelInfo values(2239,'',8) 
/
insert into HtmlLabelInfo values(2239,'监控类型',7) 
/
insert into HtmlLabelInfo values(2240,'',8) 
/
insert into HtmlLabelInfo values(2240,'任务说明',7) 
/
insert into HtmlLabelInfo values(2241,'',8) 
/
insert into HtmlLabelInfo values(2241,'全部选中',7) 
/
insert into HtmlLabelInfo values(2242,'',8) 
/
insert into HtmlLabelInfo values(2242,'待审批',7) 
/
insert into HtmlLabelInfo values(2243,'',8) 
/
insert into HtmlLabelInfo values(2243,'立项批准',7) 
/
insert into HtmlLabelInfo values(2244,'',8) 
/
insert into HtmlLabelInfo values(2244,'延期',7) 
/
insert into HtmlLabelInfo values(2245,'',8) 
/
insert into HtmlLabelInfo values(2245,'无效',7) 
/
insert into HtmlLabelInfo values(2246,'',8) 
/
insert into HtmlLabelInfo values(2246,'有效',7) 
/
insert into HtmlLabelInfo values(2247,'',8) 
/
insert into HtmlLabelInfo values(2247,'销售预期',7) 
/
insert into HtmlLabelInfo values(2248,'',8) 
/
insert into HtmlLabelInfo values(2248,'预期收益',7) 
/
insert into HtmlLabelInfo values(2249,'',8) 
/
insert into HtmlLabelInfo values(2249,'可能性',7) 
/
insert into HtmlLabelInfo values(2250,'',8) 
/
insert into HtmlLabelInfo values(2250,'销售状态',7) 
/
insert into HtmlLabelInfo values(2251,'',8) 
/
insert into HtmlLabelInfo values(2251,'查看：相关交流',7) 
/
insert into HtmlLabelInfo values(2252,'',8) 
/
insert into HtmlLabelInfo values(2252,'成功关键因数',7) 
/
insert into HtmlLabelInfo values(2253,'',8) 
/
insert into HtmlLabelInfo values(2253,'失败关键因数',7) 
/
insert into HtmlLabelInfo values(3000,'File Date',8) 
/
insert into HtmlLabelInfo values(3000,'归档日期',7) 
/
insert into HtmlLabelInfo values(3001,'The last approver',8) 
/
insert into HtmlLabelInfo values(3001,'最后审批人',7) 
/
insert into HtmlLabelInfo values(3002,'The last modifier',8) 
/
insert into HtmlLabelInfo values(3002,'最后修改人',7) 
/
insert into HtmlLabelInfo values(3003,'Saver',8) 
/
insert into HtmlLabelInfo values(3003,'归档人',7) 
/
insert into HtmlLabelInfo values(3004,'Doc.Checkup Workflow',8) 
/
insert into HtmlLabelInfo values(3004,'文档审批工作流类',7) 
/
insert into HtmlLabelInfo values(3005,'Share Level',8) 
/
insert into HtmlLabelInfo values(3005,'共享级别',7) 
/
insert into HtmlLabelInfo values(5000,'weather forcast',8) 
/
insert into HtmlLabelInfo values(5000,'天气预报',7) 
/
insert into HtmlLabelInfo values(5001,'Temperature',8) 
/
insert into HtmlLabelInfo values(5001,'温度',7) 
/
insert into HtmlLabelInfo values(6001,'The next grade',8) 
/
insert into HtmlLabelInfo values(6001,'下一级',7) 
/
insert into HtmlLabelInfo values(6002,'显示栏目',7) 
/
insert into HtmlLabelInfo values(6002,'显示栏目',8) 
/
insert into HtmlLabelInfo values(6003,'工作流到达',7) 
/
insert into HtmlLabelInfo values(6003,'工作流到达',8) 
/
insert into HtmlLabelInfo values(6004,'有新的通知公告发布',7) 
/
insert into HtmlLabelInfo values(6004,'有新的通知公告发布',8) 
/
insert into HtmlLabelInfo values(6005,'分机',7) 
/
insert into HtmlLabelInfo values(6005,'分机',8) 
/
insert into HtmlLabelInfo values(6006,'No new notice now',8) 
/
insert into HtmlLabelInfo values(6006,'现无新的公告发布',7) 
/
insert into HtmlLabelInfo values(6007,'New Notice',8) 
/
insert into HtmlLabelInfo values(6007,'新的公告',7) 
/
insert into HtmlLabelInfo values(6008,'Secretary',8) 
/
insert into HtmlLabelInfo values(6008,'秘书',7) 
/
insert into HtmlLabelInfo values(6009,'Discuss',8) 
/
insert into HtmlLabelInfo values(6009,'讨论交流',7) 
/
insert into HtmlLabelInfo values(6010,'Accepter',8) 
/
insert into HtmlLabelInfo values(6010,'讨论人',7) 
/
insert into HtmlLabelInfo values(6011,'Forward',8) 
/
insert into HtmlLabelInfo values(6011,'转发',7) 
/
insert into HtmlLabelInfo values(6012,'Need law department to verify',8) 
/
insert into HtmlLabelInfo values(6012,'是否需法律部审核',7) 
/
insert into HtmlLabelInfo values(6013,'President',8) 
/
insert into HtmlLabelInfo values(6013,'总裁',7) 
/
insert into HtmlLabelInfo values(6014,'Expense Type',8) 
/
insert into HtmlLabelInfo values(6014,'报销方式',7) 
/
insert into HtmlLabelInfo values(6015,'My report',8) 
/
insert into HtmlLabelInfo values(6015,'我的报告',7) 
/
insert into HtmlLabelInfo values(6016,'实报金额',7) 
/
insert into HtmlLabelInfo values(6016,'real amount',8) 
/
insert into HtmlLabelInfo values(6050,'资产验收入库',7) 
/
insert into HtmlLabelInfo values(6050,'',8) 
/
insert into HtmlLabelInfo values(6051,'资产借用',7) 
/
insert into HtmlLabelInfo values(6051,'',8) 
/
insert into HtmlLabelInfo values(6052,'资产报废',7) 
/
insert into HtmlLabelInfo values(6052,'',8) 
/
insert into HtmlLabelInfo values(6053,'资产维修',7) 
/
insert into HtmlLabelInfo values(6053,'',8) 
/
insert into HtmlLabelInfo values(6054,'资产减损',7) 
/
insert into HtmlLabelInfo values(6054,'',8) 
/
insert into HtmlLabelInfo values(6055,'资产变更',7) 
/
insert into HtmlLabelInfo values(6055,'',8) 
/
insert into HtmlLabelInfo values(6056,'原值',7) 
/
insert into HtmlLabelInfo values(6056,'',8) 
/
insert into HtmlLabelInfo values(6057,'今日工作',7) 
/
insert into HtmlLabelInfo values(6057,'',8) 
/
insert into HtmlLabelInfo values(6058,'查看下属的工作安排',7) 
/
insert into HtmlLabelInfo values(6058,'',8) 
/
insert into HtmlLabelInfo values(6059,'我的客户',7) 
/
insert into HtmlLabelInfo values(6059,'',8) 
/
insert into HtmlLabelInfo values(6060,'查看下属的客户',7) 
/
insert into HtmlLabelInfo values(6060,'',8) 
/
insert into HtmlLabelInfo values(6061,'客户联系提醒',7) 
/
insert into HtmlLabelInfo values(6061,'',8) 
/
insert into HtmlLabelInfo values(6062,'首页定制',7) 
/
insert into HtmlLabelInfo values(6062,'',8) 
/
insert into HtmlLabelInfo values(6063,'降级->无效客户',7) 
/
insert into HtmlLabelInfo values(6063,'',8) 
/
insert into HtmlLabelInfo values(6064,'降级->基础客户',7) 
/
insert into HtmlLabelInfo values(6064,'',8) 
/
insert into HtmlLabelInfo values(6066,'兴趣',7) 
/
insert into HtmlLabelInfo values(6066,'',8) 
/
insert into HtmlLabelInfo values(6067,'爱好',7) 
/
insert into HtmlLabelInfo values(6067,'',8) 
/
insert into HtmlLabelInfo values(6068,'专长',7) 
/
insert into HtmlLabelInfo values(6068,'',8) 
/
insert into HtmlLabelInfo values(6069,'背景资料',7) 
/
insert into HtmlLabelInfo values(6069,'',8) 
/
insert into HtmlLabelInfo values(6070,'客户价值评估',7) 
/
insert into HtmlLabelInfo values(6070,'',8) 
/
insert into HtmlLabelInfo values(6071,'权重',7) 
/
insert into HtmlLabelInfo values(6071,'',8) 
/
insert into HtmlLabelInfo values(6072,'打分',7) 
/
insert into HtmlLabelInfo values(6072,'',8) 
/
insert into HtmlLabelInfo values(6073,'客户价值',7) 
/
insert into HtmlLabelInfo values(6073,'',8) 
/
insert into HtmlLabelInfo values(6074,'主',7) 
/
insert into HtmlLabelInfo values(6074,'',8) 
/
insert into HtmlLabelInfo values(6076,'月',7) 
/
insert into HtmlLabelInfo values(6076,'',8) 
/
insert into HtmlLabelInfo values(6077,'提前时间',7) 
/
insert into HtmlLabelInfo values(6077,'',8) 
/
insert into HtmlLabelInfo values(6078,'是否提醒',7) 
/
insert into HtmlLabelInfo values(6078,'',8) 
/
insert into HtmlLabelInfo values(6079,'客户关怀',7) 
/
insert into HtmlLabelInfo values(6079,'',8) 
/
insert into HtmlLabelInfo values(6080,'客户投诉',7) 
/
insert into HtmlLabelInfo values(6080,'',8) 
/
insert into HtmlLabelInfo values(6081,'客户建议',7) 
/
insert into HtmlLabelInfo values(6081,'',8) 
/
insert into HtmlLabelInfo values(6082,'客户联系',7) 
/
insert into HtmlLabelInfo values(6082,'',8) 
/
insert into HtmlLabelInfo values(6083,'合同性质',7) 
/
insert into HtmlLabelInfo values(6083,'',8) 
/
insert into HtmlLabelInfo values(6084,'分成本中心',7) 
/
insert into HtmlLabelInfo values(6086,'岗位',7) 
/
insert into HtmlLabelInfo values(6087,'个人',7) 
/
insert into HtmlLabelInfo values(6087,'Personal',8) 
/
insert into HtmlLabelInfo values(6088,'转正',7) 
/
insert into HtmlLabelInfo values(6088,'Hire',8) 
/
insert into HtmlLabelInfo values(6089,'续签',7) 
/
insert into HtmlLabelInfo values(6089,'Extend',8) 
/
insert into HtmlLabelInfo values(6090,'调动',7) 
/
insert into HtmlLabelInfo values(6090,'Redeploy',8) 
/
insert into HtmlLabelInfo values(6091,'离职',7) 
/
insert into HtmlLabelInfo values(6091,'Dismiss',8) 
/
insert into HtmlLabelInfo values(6092,'退休',7) 
/
insert into HtmlLabelInfo values(6092,'Retire',8) 
/
insert into HtmlLabelInfo values(6093,'反聘',7) 
/
insert into HtmlLabelInfo values(6093,'Rehire',8) 
/
insert into HtmlLabelInfo values(6094,'解聘',7) 
/
insert into HtmlLabelInfo values(6094,'Fire',8) 
/
insert into HtmlLabelInfo values(6095,'签单',7) 
/
insert into HtmlLabelInfo values(6095,'',8) 
/
insert into HtmlLabelInfo values(6096,'总成本中心',7) 
/
insert into HtmlLabelInfo values(6097,'信用额度',7) 
/
insert into HtmlLabelInfo values(6097,'',8) 
/
insert into HtmlLabelInfo values(6098,'信用期间',7) 
/
insert into HtmlLabelInfo values(6098,'',8) 
/
insert into HtmlLabelInfo values(6099,'奖惩种类',7) 
/
insert into HtmlLabelInfo values(6099,'',8) 
/
insert into HtmlLabelInfo values(6100,'奖惩管理',7) 
/
insert into HtmlLabelInfo values(6100,'',8) 
/
insert into HtmlLabelInfo values(6101,'规划',7) 
/
insert into HtmlLabelInfo values(6101,'Layout',8) 
/
insert into HtmlLabelInfo values(6102,'考评',7) 
/
insert into HtmlLabelInfo values(6102,'Assess',8) 
/
insert into HtmlLabelInfo values(6103,'安排',7) 
/
insert into HtmlLabelInfo values(6103,'Plan',8) 
/
insert into HtmlLabelInfo values(6104,'公开范围',7) 
/
insert into HtmlLabelInfo values(6104,'OpenRange',8) 
/
insert into HtmlLabelInfo values(6105,'资源',7) 
/
insert into HtmlLabelInfo values(6105,'Resource',8) 
/
insert into HtmlLabelInfo values(6106,'考核',7) 
/
insert into HtmlLabelInfo values(6106,'Test',8) 
/
insert into HtmlLabelInfo values(6107,'奖励申请',7) 
/
insert into HtmlLabelInfo values(6107,'',8) 
/
insert into HtmlLabelInfo values(6109,'奖励种类',7) 
/
insert into HtmlLabelInfo values(6109,'',8) 
/
insert into HtmlLabelInfo values(6110,'职位调动',7) 
/
insert into HtmlLabelInfo values(6110,'',8) 
/
insert into HtmlLabelInfo values(6111,'调动日期',7) 
/
insert into HtmlLabelInfo values(6111,'',8) 
/
insert into HtmlLabelInfo values(6112,'原岗位',7) 
/
insert into HtmlLabelInfo values(6112,'',8) 
/
insert into HtmlLabelInfo values(6113,'新岗位',7) 
/
insert into HtmlLabelInfo values(6113,'',8) 
/
insert into HtmlLabelInfo values(6114,'原职级',7) 
/
insert into HtmlLabelInfo values(6114,'',8) 
/
insert into HtmlLabelInfo values(6115,'现职级',7) 
/
insert into HtmlLabelInfo values(6115,'',8) 
/
insert into HtmlLabelInfo values(6116,'调动原因',7) 
/
insert into HtmlLabelInfo values(6116,'',8) 
/
insert into HtmlLabelInfo values(6119,'离职申请',7) 
/
insert into HtmlLabelInfo values(6119,'',8) 
/
insert into HtmlLabelInfo values(6120,'离职合同',7) 
/
insert into HtmlLabelInfo values(6120,'',8) 
/
insert into HtmlLabelInfo values(6121,'转正申请',7) 
/
insert into HtmlLabelInfo values(6121,'',8) 
/
insert into HtmlLabelInfo values(6122,'转正日期',7) 
/
insert into HtmlLabelInfo values(6122,'',8) 
/
insert into HtmlLabelInfo values(6123,'转正备注',7) 
/
insert into HtmlLabelInfo values(6123,'',8) 
/
insert into HtmlLabelInfo values(6124,'考核实施',7) 
/
insert into HtmlLabelInfo values(6124,'',8) 
/
insert into HtmlLabelInfo values(6125,'考核报告',7) 
/
insert into HtmlLabelInfo values(6125,'',8) 
/
insert into HtmlLabelInfo values(6126,'',8) 
/
insert into HtmlLabelInfo values(6126,'实报总金额',7) 
/
insert into HtmlLabelInfo values(6128,'培训规划',7) 
/
insert into HtmlLabelInfo values(6128,'TrainLayout',8) 
/
insert into HtmlLabelInfo values(6130,'培训种类',7) 
/
insert into HtmlLabelInfo values(6130,'TrainType',8) 
/
insert into HtmlLabelInfo values(6131,'用工需求',7) 
/
insert into HtmlLabelInfo values(6131,'UseDemand',8) 
/
insert into HtmlLabelInfo values(6132,'招聘计划',7) 
/
insert into HtmlLabelInfo values(6132,'CareerPlan',8) 
/
insert into HtmlLabelInfo values(6133,'招聘管理',7) 
/
insert into HtmlLabelInfo values(6133,'CareerManage',8) 
/
insert into HtmlLabelInfo values(6134,'面试',7) 
/
insert into HtmlLabelInfo values(6134,'Interview',8) 
/
insert into HtmlLabelInfo values(6135,'结束信息',7) 
/
insert into HtmlLabelInfo values(6135,'FinishInfo',8) 
/
insert into HtmlLabelInfo values(6136,'培训活动',7) 
/
insert into HtmlLabelInfo values(6136,'Train',8) 
/
insert into HtmlLabelInfo values(6137,'入职维护',7) 
/
insert into HtmlLabelInfo values(6137,'HrmInfoMaintenance',8) 
/
insert into HtmlLabelInfo values(6138,'考勤维护',7) 
/
insert into HtmlLabelInfo values(6138,'ScheduleMaintance',8) 
/
insert into HtmlLabelInfo values(6139,'考勤种类',7) 
/
insert into HtmlLabelInfo values(6139,'ScheduleDiffType',8) 
/
insert into HtmlLabelInfo values(6140,'人力资源考勤',7) 
/
insert into HtmlLabelInfo values(6140,'HrmResourceSchedule',8) 
/
insert into HtmlLabelInfo values(6150,'奖惩申请',7) 
/
insert into HtmlLabelInfo values(6150,'',8) 
/
insert into HtmlLabelInfo values(6151,'加班',7) 
/
insert into HtmlLabelInfo values(6151,'',8) 
/
insert into HtmlLabelInfo values(6152,'性质',7) 
/
insert into HtmlLabelInfo values(6152,'',8) 
/
insert into HtmlLabelInfo values(6153,'到位时间',7) 
/
insert into HtmlLabelInfo values(6153,'',8) 
/
insert into HtmlLabelInfo values(6155,'培训申请',7) 
/
insert into HtmlLabelInfo values(6155,'',8) 
/
insert into HtmlLabelInfo values(6156,'培训安排',7) 
/
insert into HtmlLabelInfo values(6156,'',8) 
/
insert into HtmlLabelInfo values(6157,'是否重新设置基准工资',7) 
/
insert into HtmlLabelInfo values(6157,'',8) 
/
insert into HtmlLabelInfo values(6158,'合同种类',7) 
/
insert into HtmlLabelInfo values(6158,'HrmContractType',8) 
/
insert into HtmlLabelInfo values(6159,'加班类型',7) 
/
insert into HtmlLabelInfo values(6159,'',8) 
/
insert into HtmlLabelInfo values(6160,'业务合同',7) 
/
insert into HtmlLabelInfo values(6160,'',8) 
/
insert into HtmlLabelInfo values(6161,'相关合同',7) 
/
insert into HtmlLabelInfo values(6161,'',8) 
/
insert into HtmlLabelInfo values(6162,'合同文档',7) 
/
insert into HtmlLabelInfo values(6162,'',8) 
/
insert into HtmlLabelInfo values(6163,'多文档',7) 
/
insert into HtmlLabelInfo values(6163,'',8) 
/
insert into HtmlLabelInfo values(6164,'会签人',7) 
/
insert into HtmlLabelInfo values(6164,'',8) 
/
insert into HtmlLabelInfo values(6165,'租用个数',7) 
/
insert into HtmlLabelInfo values(6165,'',8) 
/
insert into HtmlLabelInfo values(7014,'考核实施',7) 
/
insert into HtmlLabelInfo values(7014,'',8) 
/
insert into HtmlLabelInfo values(7015,'奖惩考核',7) 
/
insert into HtmlLabelInfo values(7015,'',8) 
/
insert into HtmlLabelInfo values(6117,'考核项目',7) 
/
insert into HtmlLabelInfo values(6117,'',8) 
/
insert into HtmlLabelInfo values(6118,'考核种类',7) 
/
insert into HtmlLabelInfo values(6118,'',8) 
/
insert into HtmlLabelInfo values(7172,'奖惩报告',7) 
/
insert into HtmlLabelInfo values(7172,'',8) 
/
insert into HtmlLabelInfo values(7173,'奖惩人员统计',7) 
/
insert into HtmlLabelInfo values(7173,'',8) 
/
insert into HtmlLabelInfo values(7174,'奖惩趋势图',7) 
/
insert into HtmlLabelInfo values(7174,'',8) 
/
insert into HtmlLabelInfo values(7171,'泛微插件下载',7) 
/
insert into HtmlLabelInfo values(7171,'weaverPlugin_download',8) 
/
insert into HtmlLabelInfo values(7175,'部门＋安全级别',7) 
/
insert into HtmlLabelInfo values(7175,'department+security level',8) 
/
insert into HtmlLabelInfo values(7176,'角色＋安全级别＋级别',7) 
/
insert into HtmlLabelInfo values(7176,'role+security level+role level',8) 
/
insert into HtmlLabelInfo values(7177,'安全级别',7) 
/
insert into HtmlLabelInfo values(7177,'security level',8) 
/
insert into HtmlLabelInfo values(7178,'用户类型＋安全级别',7) 
/
insert into HtmlLabelInfo values(7178,'usertype+security level',8) 
/
insert into HtmlLabelInfo values(7179,'用户类型',7) 
/
insert into HtmlLabelInfo values(7179,'usertype',8) 
/
insert into HtmlLabelInfo values(7180,'总时间',7) 
/
insert into HtmlLabelInfo values(7180,'',8) 
/
insert into HtmlLabelInfo values(7181,'外部系统用户',7) 
/
insert into HtmlLabelInfo values(7181,'OtherSystemUser',8) 
/
insert into HtmlLabelInfo values(6141,'''',8) 
/
insert into HtmlLabelInfo values(6146,'''',8) 
/
insert into HtmlLabelInfo values(6141,'申请部门',7) 
/
insert into HtmlLabelInfo values(6141,'',8) 
/
insert into HtmlLabelInfo values(6146,'合同金额',7) 
/
insert into HtmlLabelInfo values(6146,'',8) 
/
insert into HtmlLabelInfo values(6141,'申请部门',7) 
/
insert into HtmlLabelInfo values(6141,'',8) 
/
insert into HtmlLabelInfo values(6146,'合同金额',7) 
/
insert into HtmlLabelInfo values(6146,'',8) 
/
insert into HtmlLabelInfo values(6166,'相关产品',7) 
/
insert into HtmlLabelInfo values(6166,'',8) 
/
insert into HtmlLabelInfo values(6166,'相关产品',7) 
/
insert into HtmlLabelInfo values(6166,'',8) 
/
insert into HtmlLabelInfo values(6167,'月工作总结与计划',7) 
/
insert into HtmlLabelInfo values(6167,'',8) 
/
insert into HtmlLabelInfo values(16350,'同意延期',7) 
/
insert into HtmlLabelInfo values(16350,'',8) 
/
insert into HtmlLabelInfo values(16351,'退回重新执行',7) 
/
insert into HtmlLabelInfo values(16351,'',8) 
/
insert into HtmlLabelInfo values(16352,'定制工作流程图',7) 
/
insert into HtmlLabelInfo values(16352,'',8) 
/
insert into HtmlLabelInfo values(16353,'已操作者',7) 
/
insert into HtmlLabelInfo values(16353,'',8) 
/
insert into HtmlLabelInfo values(16354,'未操作者',7) 
/
insert into HtmlLabelInfo values(16354,'',8) 
/
insert into HtmlLabelInfo values(16355,'查看者',7) 
/
insert into HtmlLabelInfo values(16355,'',8) 
/
insert into HtmlLabelInfo values(16356,'新闻中心',7) 
/
insert into HtmlLabelInfo values(16356,'',8) 
/
insert into HtmlLabelInfo values(15000,'外部系统接口',7) 
/
insert into HtmlLabelInfo values(15000,'',8) 
/
insert into HtmlLabelInfo values(15001,'请重启',7) 
/
insert into HtmlLabelInfo values(15001,'',8) 
/
insert into HtmlLabelInfo values(15002,'登入系统',7) 
/
insert into HtmlLabelInfo values(15002,'',8) 
/
insert into HtmlLabelInfo values(15003,'新建功能',7) 
/
insert into HtmlLabelInfo values(15003,'',8) 
/
insert into HtmlLabelInfo values(15004,'新建请求',7) 
/
insert into HtmlLabelInfo values(15004,'',8) 
/
insert into HtmlLabelInfo values(15005,'新建人员',7) 
/
insert into HtmlLabelInfo values(15005,'',8) 
/
insert into HtmlLabelInfo values(15006,'新建客户',7) 
/
insert into HtmlLabelInfo values(15006,'',8) 
/
insert into HtmlLabelInfo values(15007,'新建项目',7) 
/
insert into HtmlLabelInfo values(15007,'',8) 
/
insert into HtmlLabelInfo values(15008,'新建会议',7) 
/
insert into HtmlLabelInfo values(15008,'',8) 
/
insert into HtmlLabelInfo values(15009,'新建资产',7) 
/
insert into HtmlLabelInfo values(15009,'',8) 
/
insert into HtmlLabelInfo values(15010,'我的工作日历',7) 
/
insert into HtmlLabelInfo values(15010,'',8) 
/
insert into HtmlLabelInfo values(15011,'知识文档',7) 
/
insert into HtmlLabelInfo values(15011,'',8) 
/
insert into HtmlLabelInfo values(15012,'系统现有',7) 
/
insert into HtmlLabelInfo values(15012,'',8) 
/
insert into HtmlLabelInfo values(15013,'篇文档',7) 
/
insert into HtmlLabelInfo values(15013,'',8) 
/
insert into HtmlLabelInfo values(15014,'您创建',7) 
/
insert into HtmlLabelInfo values(15014,'',8) 
/
insert into HtmlLabelInfo values(15015,'篇',7) 
/
insert into HtmlLabelInfo values(15015,'',8) 
/
insert into HtmlLabelInfo values(15016,'您有未读',7) 
/
insert into HtmlLabelInfo values(15016,'',8) 
/
insert into HtmlLabelInfo values(15017,'浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。',7) 
/
insert into HtmlLabelInfo values(15017,'',8) 
/
insert into HtmlLabelInfo values(15018,'licence文件',7) 
/
insert into HtmlLabelInfo values(15018,'',8) 
/
insert into HtmlLabelInfo values(15019,'识别码',7) 
/
insert into HtmlLabelInfo values(15019,'',8) 
/
insert into HtmlLabelInfo values(15020,'提　示',7) 
/
insert into HtmlLabelInfo values(15020,'',8) 
/
insert into HtmlLabelInfo values(15021,'请将',7) 
/
insert into HtmlLabelInfo values(15021,'',8) 
/
insert into HtmlLabelInfo values(15022,'及',7) 
/
insert into HtmlLabelInfo values(15022,'',8) 
/
insert into HtmlLabelInfo values(15023,'提交给软件供应商,以获取License',7) 
/
insert into HtmlLabelInfo values(15023,'',8) 
/
insert into HtmlLabelInfo values(15024,'数据库',7) 
/
insert into HtmlLabelInfo values(15024,'',8) 
/
insert into HtmlLabelInfo values(15025,'数据库类型',7) 
/
insert into HtmlLabelInfo values(15025,'',8) 
/
insert into HtmlLabelInfo values(15026,'数据库名称',7) 
/
insert into HtmlLabelInfo values(15026,'',8) 
/
insert into HtmlLabelInfo values(15027,'使用现有数据库',7) 
/
insert into HtmlLabelInfo values(15027,'',8) 
/
insert into HtmlLabelInfo values(15028,'软件类型',7) 
/
insert into HtmlLabelInfo values(15028,'',8) 
/
insert into HtmlLabelInfo values(15029,'用户数',7) 
/
insert into HtmlLabelInfo values(15029,'',8) 
/
insert into HtmlLabelInfo values(15030,'有效期',7) 
/
insert into HtmlLabelInfo values(15030,'',8) 
/
insert into HtmlLabelInfo values(15031,'您有新的工作流需要处理',7) 
/
insert into HtmlLabelInfo values(15031,'',8) 
/
insert into HtmlLabelInfo values(15032,'您创建的工作流已经完成',7) 
/
insert into HtmlLabelInfo values(15032,'',8) 
/
insert into HtmlLabelInfo values(15033,'关闭窗口',7) 
/
insert into HtmlLabelInfo values(15033,'',8) 
/
insert into HtmlLabelInfo values(15034,'您想现在处理吗',7) 
/
insert into HtmlLabelInfo values(15034,'',8) 
/
insert into HtmlLabelInfo values(15035,'您想现在查看吗',7) 
/
insert into HtmlLabelInfo values(15035,'',8) 
/
insert into HtmlLabelInfo values(15036,'您收到提醒工作流',7) 
/
insert into HtmlLabelInfo values(15036,'',8) 
/
insert into HtmlLabelInfo values(15037,'邮件系统设置',7) 
/
insert into HtmlLabelInfo values(15037,'',8) 
/
insert into HtmlLabelInfo values(15038,'服务器',7) 
/
insert into HtmlLabelInfo values(15038,'',8) 
/
insert into HtmlLabelInfo values(15039,'是否需要发件认证',7) 
/
insert into HtmlLabelInfo values(15039,'',8) 
/
insert into HtmlLabelInfo values(15040,'群发SMTP服务器',7) 
/
insert into HtmlLabelInfo values(15040,'',8) 
/
insert into HtmlLabelInfo values(15041,'群发默认发件人地址',7) 
/
insert into HtmlLabelInfo values(15041,'',8) 
/
insert into HtmlLabelInfo values(15042,'群发默认认证用户名',7) 
/
insert into HtmlLabelInfo values(15042,'',8) 
/
insert into HtmlLabelInfo values(15043,'群发默认认证用户密码',7) 
/
insert into HtmlLabelInfo values(15043,'',8) 
/
insert into HtmlLabelInfo values(15044,'群发服务器是否需要发件认证',7) 
/
insert into HtmlLabelInfo values(15044,'',8) 
/
insert into HtmlLabelInfo values(15045,'文件系统设置',7) 
/
insert into HtmlLabelInfo values(15045,'',8) 
/
insert into HtmlLabelInfo values(15046,'文件存放目录',7) 
/
insert into HtmlLabelInfo values(15046,'',8) 
/
insert into HtmlLabelInfo values(15047,'文件备份目录',7) 
/
insert into HtmlLabelInfo values(15047,'',8) 
/
insert into HtmlLabelInfo values(15048,'文件备份周期',7) 
/
insert into HtmlLabelInfo values(15048,'',8) 
/
insert into HtmlLabelInfo values(15049,'分钟',7) 
/
insert into HtmlLabelInfo values(15049,'',8) 
/
insert into HtmlLabelInfo values(15050,'是否压缩存放',7) 
/
insert into HtmlLabelInfo values(15050,'',8) 
/
insert into HtmlLabelInfo values(15051,'基础数据报表',7) 
/
insert into HtmlLabelInfo values(15051,'',8) 
/
insert into HtmlLabelInfo values(15052,'系统角色',7) 
/
insert into HtmlLabelInfo values(15052,'',8) 
/
insert into HtmlLabelInfo values(15053,'人员角色',7) 
/
insert into HtmlLabelInfo values(15053,'',8) 
/
insert into HtmlLabelInfo values(15054,'资产管理基础数据',7) 
/
insert into HtmlLabelInfo values(15054,'',8) 
/
insert into HtmlLabelInfo values(15055,'客户管理基础数据',7) 
/
insert into HtmlLabelInfo values(15055,'',8) 
/
insert into HtmlLabelInfo values(15056,'知识管理基础数据',7) 
/
insert into HtmlLabelInfo values(15056,'',8) 
/
insert into HtmlLabelInfo values(15057,'审批工作流',7) 
/
insert into HtmlLabelInfo values(15057,'',8) 
/
insert into HtmlLabelInfo values(15058,'审批流程',7) 
/
insert into HtmlLabelInfo values(15058,'',8) 
/
insert into HtmlLabelInfo values(15059,'默认共享',7) 
/
insert into HtmlLabelInfo values(15059,'',8) 
/
insert into HtmlLabelInfo values(15060,'可',7) 
/
insert into HtmlLabelInfo values(15060,'',8) 
/
insert into HtmlLabelInfo values(15061,'类客户',7) 
/
insert into HtmlLabelInfo values(15061,'',8) 
/
insert into HtmlLabelInfo values(15062,'部门级',7) 
/
insert into HtmlLabelInfo values(15062,'',8) 
/
insert into HtmlLabelInfo values(15063,'分部级',7) 
/
insert into HtmlLabelInfo values(15063,'',8) 
/
insert into HtmlLabelInfo values(15064,'总部级',7) 
/
insert into HtmlLabelInfo values(15064,'',8) 
/
insert into HtmlLabelInfo values(15065,'人力资源基础数据',7) 
/
insert into HtmlLabelInfo values(15065,'',8) 
/
insert into HtmlLabelInfo values(15066,'人员角色基础数据',7) 
/
insert into HtmlLabelInfo values(15066,'',8) 
/
insert into HtmlLabelInfo values(15067,'系统角色基础数据',7) 
/
insert into HtmlLabelInfo values(15067,'',8) 
/
insert into HtmlLabelInfo values(15068,'角色名称',7) 
/
insert into HtmlLabelInfo values(15068,'',8) 
/
insert into HtmlLabelInfo values(15069,'工作流程基础数据',7) 
/
insert into HtmlLabelInfo values(15069,'',8) 
/
insert into HtmlLabelInfo values(15070,'节点名称',7) 
/
insert into HtmlLabelInfo values(15070,'',8) 
/
insert into HtmlLabelInfo values(15071,'无创建人',7) 
/
insert into HtmlLabelInfo values(15071,'',8) 
/
insert into HtmlLabelInfo values(15072,'操作组',7) 
/
insert into HtmlLabelInfo values(15072,'',8) 
/
insert into HtmlLabelInfo values(15073,'操作组定义',7) 
/
insert into HtmlLabelInfo values(15073,'',8) 
/
insert into HtmlLabelInfo values(15074,'目标节点',7) 
/
insert into HtmlLabelInfo values(15074,'',8) 
/
insert into HtmlLabelInfo values(15075,'是否退回',7) 
/
insert into HtmlLabelInfo values(15075,'',8) 
/
insert into HtmlLabelInfo values(15076,'退回节点',7) 
/
insert into HtmlLabelInfo values(15076,'',8) 
/
insert into HtmlLabelInfo values(15077,'流程涉及相关人员',7) 
/
insert into HtmlLabelInfo values(15077,'',8) 
/
insert into HtmlLabelInfo values(15078,'客户状态',7) 
/
insert into HtmlLabelInfo values(15078,'',8) 
/
insert into HtmlLabelInfo values(15079,'创建人本人',7) 
/
insert into HtmlLabelInfo values(15079,'',8) 
/
insert into HtmlLabelInfo values(15080,'创建人经理',7) 
/
insert into HtmlLabelInfo values(15080,'',8) 
/
insert into HtmlLabelInfo values(15081,'创建人本部门',7) 
/
insert into HtmlLabelInfo values(15081,'',8) 
/
insert into HtmlLabelInfo values(15082,'可退回',7) 
/
insert into HtmlLabelInfo values(15082,'',8) 
/
insert into HtmlLabelInfo values(15083,'不可退回',7) 
/
insert into HtmlLabelInfo values(15083,'',8) 
/
insert into HtmlLabelInfo values(15084,'上移',7) 
/
insert into HtmlLabelInfo values(15084,'',8) 
/
insert into HtmlLabelInfo values(15085,'下移',7) 
/
insert into HtmlLabelInfo values(15085,'',8) 
/
insert into HtmlLabelInfo values(15086,'有',7) 
/
insert into HtmlLabelInfo values(15086,'',8) 
/
insert into HtmlLabelInfo values(15087,'份邮件到达',7) 
/
insert into HtmlLabelInfo values(15087,'',8) 
/
insert into HtmlLabelInfo values(15088,'新闻与公告',7) 
/
insert into HtmlLabelInfo values(15088,'',8) 
/
insert into HtmlLabelInfo values(15089,'我的下属',7) 
/
insert into HtmlLabelInfo values(15089,'',8) 
/
insert into HtmlLabelInfo values(15090,'工作安排',7) 
/
insert into HtmlLabelInfo values(15090,'',8) 
/
insert into HtmlLabelInfo values(15091,'会议安排',7) 
/
insert into HtmlLabelInfo values(15091,'',8) 
/
insert into HtmlLabelInfo values(15092,'还款提醒',7) 
/
insert into HtmlLabelInfo values(15092,'',8) 
/
insert into HtmlLabelInfo values(15093,'安排工作',7) 
/
insert into HtmlLabelInfo values(15093,'',8) 
/
insert into HtmlLabelInfo values(15094,'登录名冲突',7) 
/
insert into HtmlLabelInfo values(15094,'',8) 
/
insert into HtmlLabelInfo values(15095,'本系统登陆名',7) 
/
insert into HtmlLabelInfo values(15095,'',8) 
/
insert into HtmlLabelInfo values(15096,'外部系统登陆名',7) 
/
insert into HtmlLabelInfo values(15096,'',8) 
/
insert into HtmlLabelInfo values(15097,'确定要删除吗?',7) 
/
insert into HtmlLabelInfo values(15097,'',8) 
/
insert into HtmlLabelInfo values(15098,'功能列表',7) 
/
insert into HtmlLabelInfo values(15098,'',8) 
/
insert into HtmlLabelInfo values(15099,'添加客户',7) 
/
insert into HtmlLabelInfo values(15099,'',8) 
/
insert into HtmlLabelInfo values(15100,'',7) 
/
insert into HtmlLabelInfo values(15100,'',8) 
/
insert into HtmlLabelInfo values(15101,'报表',7) 
/
insert into HtmlLabelInfo values(15101,'',8) 
/
insert into HtmlLabelInfo values(15102,'销售机会时间分布设置',7) 
/
insert into HtmlLabelInfo values(15102,'',8) 
/
insert into HtmlLabelInfo values(15103,'成功关键因素',7) 
/
insert into HtmlLabelInfo values(15103,'',8) 
/
insert into HtmlLabelInfo values(15104,'失败关键因素',7) 
/
insert into HtmlLabelInfo values(15104,'',8) 
/
insert into HtmlLabelInfo values(15105,'产品及报价',7) 
/
insert into HtmlLabelInfo values(15105,'',8) 
/
insert into HtmlLabelInfo values(15106,'产品类别',7) 
/
insert into HtmlLabelInfo values(15106,'',8) 
/
insert into HtmlLabelInfo values(15107,'产品维护',7) 
/
insert into HtmlLabelInfo values(15107,'',8) 
/
insert into HtmlLabelInfo values(15108,'产品列表',7) 
/
insert into HtmlLabelInfo values(15108,'',8) 
/
insert into HtmlLabelInfo values(15109,'调查',7) 
/
insert into HtmlLabelInfo values(15109,'',8) 
/
insert into HtmlLabelInfo values(15110,'新建调查',7) 
/
insert into HtmlLabelInfo values(15110,'',8) 
/
insert into HtmlLabelInfo values(15111,'后台管理',7) 
/
insert into HtmlLabelInfo values(15111,'',8) 
/
insert into HtmlLabelInfo values(15112,'归档状态',7) 
/
insert into HtmlLabelInfo values(15112,'',8) 
/
insert into HtmlLabelInfo values(15113,'时间分布',7) 
/
insert into HtmlLabelInfo values(15113,'',8) 
/
insert into HtmlLabelInfo values(15114,'区域',7) 
/
insert into HtmlLabelInfo values(15114,'',8) 
/
insert into HtmlLabelInfo values(15115,'产品',7) 
/
insert into HtmlLabelInfo values(15115,'',8) 
/
insert into HtmlLabelInfo values(15116,'销售人员',7) 
/
insert into HtmlLabelInfo values(15116,'',8) 
/
insert into HtmlLabelInfo values(15117,'合同应收应付',7) 
/
insert into HtmlLabelInfo values(15117,'',8) 
/
insert into HtmlLabelInfo values(15118,'合同相关产品',7) 
/
insert into HtmlLabelInfo values(15118,'',8) 
/
insert into HtmlLabelInfo values(15119,'数据库错误',7) 
/
insert into HtmlLabelInfo values(15119,'',8) 
/
insert into HtmlLabelInfo values(15120,'开发手册',7) 
/
insert into HtmlLabelInfo values(15120,'',8) 
/
insert into HtmlLabelInfo values(15121,'客户关系管理',7) 
/
insert into HtmlLabelInfo values(15121,'',8) 
/
insert into HtmlLabelInfo values(15122,'后退',7) 
/
insert into HtmlLabelInfo values(15122,'',8) 
/
insert into HtmlLabelInfo values(15123,'前进',7) 
/
insert into HtmlLabelInfo values(15123,'',8) 
/
insert into HtmlLabelInfo values(15124,'客户卡片相关',7) 
/
insert into HtmlLabelInfo values(15124,'',8) 
/
insert into HtmlLabelInfo values(15125,'帐务',7) 
/
insert into HtmlLabelInfo values(15125,'',8) 
/
insert into HtmlLabelInfo values(15126,'搜索关键字不够精确',7) 
/
insert into HtmlLabelInfo values(15126,'',8) 
/
insert into HtmlLabelInfo values(15127,'还未完成',7) 
/
insert into HtmlLabelInfo values(15127,'',8) 
/
insert into HtmlLabelInfo values(15128,'添加一行',7) 
/
insert into HtmlLabelInfo values(15128,'',8) 
/
insert into HtmlLabelInfo values(15129,'产品名称',7) 
/
insert into HtmlLabelInfo values(15129,'',8) 
/
insert into HtmlLabelInfo values(15130,'折扣',7) 
/
insert into HtmlLabelInfo values(15130,'',8) 
/
insert into HtmlLabelInfo values(15131,'付款方式',7) 
/
insert into HtmlLabelInfo values(15131,'',8) 
/
insert into HtmlLabelInfo values(15132,'付款项目',7) 
/
insert into HtmlLabelInfo values(15132,'',8) 
/
insert into HtmlLabelInfo values(15133,'付款性质',7) 
/
insert into HtmlLabelInfo values(15133,'',8) 
/
insert into HtmlLabelInfo values(15134,'付款金额',7) 
/
insert into HtmlLabelInfo values(15134,'',8) 
/
insert into HtmlLabelInfo values(15135,'付款日期',7) 
/
insert into HtmlLabelInfo values(15135,'',8) 
/
insert into HtmlLabelInfo values(15136,'付款条件',7) 
/
insert into HtmlLabelInfo values(15136,'',8) 
/
insert into HtmlLabelInfo values(15137,'应收',7) 
/
insert into HtmlLabelInfo values(15137,'',8) 
/
insert into HtmlLabelInfo values(15138,'应付',7) 
/
insert into HtmlLabelInfo values(15138,'',8) 
/
insert into HtmlLabelInfo values(15139,'新建客户合同',7) 
/
insert into HtmlLabelInfo values(15139,'',8) 
/
insert into HtmlLabelInfo values(15140,'客户合同',7) 
/
insert into HtmlLabelInfo values(15140,'',8) 
/
insert into HtmlLabelInfo values(15141,'完',7) 
/
insert into HtmlLabelInfo values(15141,'',8) 
/
insert into HtmlLabelInfo values(15142,'合同名称',7) 
/
insert into HtmlLabelInfo values(15142,'',8) 
/
insert into HtmlLabelInfo values(15143,'提交审批',7) 
/
insert into HtmlLabelInfo values(15143,'',8) 
/
insert into HtmlLabelInfo values(15144,'执行完成',7) 
/
insert into HtmlLabelInfo values(15144,'',8) 
/
insert into HtmlLabelInfo values(15145,'实际交货数量',7) 
/
insert into HtmlLabelInfo values(15145,'',8) 
/
insert into HtmlLabelInfo values(15146,'实际交货日期',7) 
/
insert into HtmlLabelInfo values(15146,'',8) 
/
insert into HtmlLabelInfo values(15147,'已完毕',7) 
/
insert into HtmlLabelInfo values(15147,'',8) 
/
insert into HtmlLabelInfo values(15148,'提醒',7) 
/
insert into HtmlLabelInfo values(15148,'',8) 
/
insert into HtmlLabelInfo values(15149,'付款',7) 
/
insert into HtmlLabelInfo values(15149,'',8) 
/
insert into HtmlLabelInfo values(15150,'实际付款日期',7) 
/
insert into HtmlLabelInfo values(15150,'',8) 
/
insert into HtmlLabelInfo values(15151,'已收款',7) 
/
insert into HtmlLabelInfo values(15151,'',8) 
/
insert into HtmlLabelInfo values(15152,'已付款',7) 
/
insert into HtmlLabelInfo values(15152,'',8) 
/
insert into HtmlLabelInfo values(15153,'相关交流',7) 
/
insert into HtmlLabelInfo values(15153,'',8) 
/
insert into HtmlLabelInfo values(15154,'部分',7) 
/
insert into HtmlLabelInfo values(15154,'',8) 
/
insert into HtmlLabelInfo values(15155,'客户门户申请',7) 
/
insert into HtmlLabelInfo values(15155,'',8) 
/
insert into HtmlLabelInfo values(15156,'门户状态变更',7) 
/
insert into HtmlLabelInfo values(15156,'',8) 
/
insert into HtmlLabelInfo values(15157,'客户状态变更',7) 
/
insert into HtmlLabelInfo values(15157,'',8) 
/
insert into HtmlLabelInfo values(15158,'客户级别变更',7) 
/
insert into HtmlLabelInfo values(15158,'',8) 
/
insert into HtmlLabelInfo values(15159,'客户经理变更',7) 
/
insert into HtmlLabelInfo values(15159,'',8) 
/
insert into HtmlLabelInfo values(15160,'确定要合并吗',7) 
/
insert into HtmlLabelInfo values(15160,'',8) 
/
insert into HtmlLabelInfo values(15161,'跟踪',7) 
/
insert into HtmlLabelInfo values(15161,'',8) 
/
insert into HtmlLabelInfo values(15162,'应收总额',7) 
/
insert into HtmlLabelInfo values(15162,'',8) 
/
insert into HtmlLabelInfo values(15163,'第一笔应收款时间',7) 
/
insert into HtmlLabelInfo values(16357,'文档: 所有者',7) 
/
insert into HtmlLabelInfo values(16357,'',8) 
/
insert into HtmlLabelInfo values(16358,'文档: 部门',7) 
/
insert into HtmlLabelInfo values(16358,'',8) 
/
insert into HtmlLabelInfo values(16359,'文档: 阅读',7) 
/
insert into HtmlLabelInfo values(16359,'',8) 
/
insert into HtmlLabelInfo values(16360,'最高 50: 被阅读',7) 
/
insert into HtmlLabelInfo values(16360,'',8) 
/
insert into HtmlLabelInfo values(16361,'最高 20: 所有者',7) 
/
insert into HtmlLabelInfo values(16361,'',8) 
/
insert into HtmlLabelInfo values(16362,'最高 20: 语言',7) 
/
insert into HtmlLabelInfo values(16362,'',8) 
/
insert into HtmlLabelInfo values(16363,'最高 20: CRM',7) 
/
insert into HtmlLabelInfo values(16363,'',8) 
/
insert into HtmlLabelInfo values(16364,'最高 20: 人力资源',7) 
/
insert into HtmlLabelInfo values(16364,'',8) 
/
insert into HtmlLabelInfo values(16365,'最高 20: 项目',7) 
/
insert into HtmlLabelInfo values(16365,'',8) 
/
insert into HtmlLabelInfo values(16366,'最高 20: 部门',7) 
/
insert into HtmlLabelInfo values(16366,'',8) 
/
insert into HtmlLabelInfo values(16367,'模板设置',7) 
/
insert into HtmlLabelInfo values(16367,'',8) 
/
insert into HtmlLabelInfo values(16368,'新闻页设置',7) 
/
insert into HtmlLabelInfo values(16368,'',8) 
/
insert into HtmlLabelInfo values(16369,'文档编辑模板',7) 
/
insert into HtmlLabelInfo values(16369,'',8) 
/
insert into HtmlLabelInfo values(16370,'文档显示模板',7) 
/
insert into HtmlLabelInfo values(16370,'',8) 
/
insert into HtmlLabelInfo values(16371,'数据中心',7) 
/
insert into HtmlLabelInfo values(16371,'',8) 
/
insert into HtmlLabelInfo values(16372,'报表中心',7) 
/
insert into HtmlLabelInfo values(16372,'',8) 
/
insert into HtmlLabelInfo values(16373,'设置中心',7) 
/
insert into HtmlLabelInfo values(16373,'',8) 
/
insert into HtmlLabelInfo values(16374,'操作 - 近期',7) 
/
insert into HtmlLabelInfo values(16374,'',8) 
/
insert into HtmlLabelInfo values(16375,'送货类型',7) 
/
insert into HtmlLabelInfo values(16375,'',8) 
/
insert into HtmlLabelInfo values(16376,'客户价值评估标准',7) 
/
insert into HtmlLabelInfo values(16376,'',8) 
/
insert into HtmlLabelInfo values(16377,'客户价值评估项目',7) 
/
insert into HtmlLabelInfo values(16377,'',8) 
/
insert into HtmlLabelInfo values(16378,'分类信息',7) 
/
insert into HtmlLabelInfo values(16378,'',8) 
/
insert into HtmlLabelInfo values(16379,'权限转移',7) 
/
insert into HtmlLabelInfo values(16379,'',8) 
/
insert into HtmlLabelInfo values(16380,'操作菜单',7) 
/
insert into HtmlLabelInfo values(16380,'',8) 
/
insert into HtmlLabelInfo values(16381,'打开本地文件',7) 
/
insert into HtmlLabelInfo values(16381,'',8) 
/
insert into HtmlLabelInfo values(16382,'存为本地文件',7) 
/
insert into HtmlLabelInfo values(16382,'',8) 
/
insert into HtmlLabelInfo values(16383,'签名印章',7) 
/
insert into HtmlLabelInfo values(16383,'',8) 
/
insert into HtmlLabelInfo values(16384,'打开版本',7) 
/
insert into HtmlLabelInfo values(16384,'',8) 
/
insert into HtmlLabelInfo values(16385,'显示/隐藏痕迹',7) 
/
insert into HtmlLabelInfo values(16385,'',8) 
/
insert into HtmlLabelInfo values(16386,'存为新版本',7) 
/
insert into HtmlLabelInfo values(16386,'',8) 
/
insert into HtmlLabelInfo values(16387,'新建签章',7) 
/
insert into HtmlLabelInfo values(16387,'',8) 
/
insert into HtmlLabelInfo values(16388,'新建模板',7) 
/
insert into HtmlLabelInfo values(16388,'',8) 
/
insert into HtmlLabelInfo values(16389,'',8) 
/
insert into HtmlLabelInfo values(16390,'新闻设置',7) 
/
insert into HtmlLabelInfo values(16390,'',8) 
/
insert into HtmlLabelInfo values(16391,'我的流程',7) 
/
insert into HtmlLabelInfo values(16391,'',8) 
/
insert into HtmlLabelInfo values(16393,'查询流程',7) 
/
insert into HtmlLabelInfo values(16393,'',8) 
/
insert into HtmlLabelInfo values(16394,'',8) 
/
insert into HtmlLabelInfo values(16395,'',8) 
/
insert into HtmlLabelInfo values(16396,'分享知识',7) 
/
insert into HtmlLabelInfo values(16396,'',8) 
/
insert into HtmlLabelInfo values(16397,'最新文档',7) 
/
insert into HtmlLabelInfo values(16397,'',8) 
/
insert into HtmlLabelInfo values(16398,'文档目录',7) 
/
insert into HtmlLabelInfo values(16398,'',8) 
/
insert into HtmlLabelInfo values(16399,'查询文档',7) 
/
insert into HtmlLabelInfo values(16399,'',8) 
/
insert into HtmlLabelInfo values(16402,'联系计划',7) 
/
insert into HtmlLabelInfo values(16402,'',8) 
/
insert into HtmlLabelInfo values(16403,'联系提醒',7) 
/
insert into HtmlLabelInfo values(16405,'联系情况',7) 
/
insert into HtmlLabelInfo values(16407,'查询客户',7) 
/
insert into HtmlLabelInfo values(16407,'',8) 
/
insert into HtmlLabelInfo values(16409,'审批项目',7) 
/
insert into HtmlLabelInfo values(16409,'',8) 
/
insert into HtmlLabelInfo values(16410,'审批任务',7) 
/
insert into HtmlLabelInfo values(16410,'',8) 
/
insert into HtmlLabelInfo values(16412,'超期任务',7) 
/
insert into HtmlLabelInfo values(16413,'',8) 
/
insert into HtmlLabelInfo values(16415,'我的卡片',7) 
/
insert into HtmlLabelInfo values(16415,'',8) 
/
insert into HtmlLabelInfo values(16417,'考核奖惩',7) 
/
insert into HtmlLabelInfo values(16418,'查询人员',7) 
/
insert into HtmlLabelInfo values(16419,'审批会议',7) 
/
insert into HtmlLabelInfo values(16420,'',8) 
/
insert into HtmlLabelInfo values(16422,'',8) 
/
insert into HtmlLabelInfo values(16423,'会议室报表',7) 
/
insert into HtmlLabelInfo values(16424,'查询会议',7) 
/
insert into HtmlLabelInfo values(16424,'',8) 
/
insert into HtmlLabelInfo values(16425,'查询资产',7) 
/
insert into HtmlLabelInfo values(16425,'',8) 
/
insert into HtmlLabelInfo values(16426,'新建计划',7) 
/
insert into HtmlLabelInfo values(16427,'查询计划',7) 
/
insert into HtmlLabelInfo values(16427,'',8) 
/
insert into HtmlLabelInfo values(16428,'我的日报',7) 
/
insert into HtmlLabelInfo values(16428,'',8) 
/
insert into HtmlLabelInfo values(16429,'我的周报',7) 
/
insert into HtmlLabelInfo values(16430,'我的月报',7) 
/
insert into HtmlLabelInfo values(16431,'我的季报',7) 
/
insert into HtmlLabelInfo values(16432,'我的年报',7) 
/
insert into HtmlLabelInfo values(16433,'动态报告',7) 
/
insert into HtmlLabelInfo values(16433,'',8) 
/
insert into HtmlLabelInfo values(16434,'绩效考核',7) 
/
insert into HtmlLabelInfo values(16434,'',8) 
/
insert into HtmlLabelInfo values(16435,'',8) 
/
insert into HtmlLabelInfo values(16436,'',8) 
/
insert into HtmlLabelInfo values(16437,'草稿邮箱',7) 
/
insert into HtmlLabelInfo values(16438,'垃圾邮箱',7) 
/
insert into HtmlLabelInfo values(16439,'',8) 
/
insert into HtmlLabelInfo values(16441,'',8) 
/
insert into HtmlLabelInfo values(16442,'',8) 
/
insert into HtmlLabelInfo values(16443,'',8) 
/
insert into HtmlLabelInfo values(16444,'',8) 
/
insert into HtmlLabelInfo values(15790,'>对应模板',7) 
/
insert into HtmlLabelInfo values(15790,'',8) 
/
insert into HtmlLabelInfo values(16445,'',8) 
/
insert into HtmlLabelInfo values(16446,'版本描述',7) 
/
insert into HtmlLabelInfo values(16447,'目录设置',7) 
/
insert into HtmlLabelInfo values(16447,'',8) 
/
insert into HtmlLabelInfo values(16448,'模版设置',7) 
/
insert into HtmlLabelInfo values(16449,'编辑模板',7) 
/
insert into HtmlLabelInfo values(16449,'',8) 
/
insert into HtmlLabelInfo values(16452,'用户定义',7) 
/
insert into HtmlLabelInfo values(16452,'',8) 
/
insert into HtmlLabelInfo values(16453,'复制移动',7) 
/
insert into HtmlLabelInfo values(16453,'',8) 
/
insert into HtmlLabelInfo values(16454,'泛微插件',7) 
/
insert into HtmlLabelInfo values(16454,'',8) 
/
insert into HtmlLabelInfo values(16455,'',8) 
/
insert into HtmlLabelInfo values(16456,'',8) 
/
insert into HtmlLabelInfo values(16457,'',8) 
/
insert into HtmlLabelInfo values(16458,'',8) 
/
insert into HtmlLabelInfo values(16459,'',8) 
/
insert into HtmlLabelInfo values(16461,'岗位设置',7) 
/
insert into HtmlLabelInfo values(16464,'',8) 
/
insert into HtmlLabelInfo values(16465,'人员入职',7) 
/
insert into HtmlLabelInfo values(16466,'人员转正',7) 
/
insert into HtmlLabelInfo values(16467,'',8) 
/
insert into HtmlLabelInfo values(16468,'人员调动',7) 
/
insert into HtmlLabelInfo values(16469,'人员离职',7) 
/
insert into HtmlLabelInfo values(16470,'人员退休',7) 
/
insert into HtmlLabelInfo values(16471,'人员反聘',7) 
/
insert into HtmlLabelInfo values(16472,'人员解聘',7) 
/
insert into HtmlLabelInfo values(16472,'',8) 
/
insert into HtmlLabelInfo values(16473,'签章设置',7) 
/
insert into HtmlLabelInfo values(16474,'考勤设置',7) 
/
insert into HtmlLabelInfo values(16474,'',8) 
/
insert into HtmlLabelInfo values(16476,'部门时间',7) 
/
insert into HtmlLabelInfo values(16476,'',8) 
/
insert into HtmlLabelInfo values(16477,'人员时间',7) 
/
insert into HtmlLabelInfo values(16477,'',8) 
/
insert into HtmlLabelInfo values(16478,'',8) 
/
insert into HtmlLabelInfo values(16479,'合同模版',7) 
/
insert into HtmlLabelInfo values(16479,'',8) 
/
insert into HtmlLabelInfo values(16480,'工资福利',7) 
/
insert into HtmlLabelInfo values(16480,'',8) 
/
insert into HtmlLabelInfo values(16481,'',8) 
/
insert into HtmlLabelInfo values(16482,'类型设置',7) 
/
insert into HtmlLabelInfo values(16482,'',8) 
/
insert into HtmlLabelInfo values(16484,'',8) 
/
insert into HtmlLabelInfo values(16485,'',8) 
/
insert into HtmlLabelInfo values(16487,'',8) 
/
insert into HtmlLabelInfo values(16488,'',8) 
/
insert into HtmlLabelInfo values(16489,'',8) 
/
insert into HtmlLabelInfo values(16490,'分类设置',7) 
/
insert into HtmlLabelInfo values(16490,'',8) 
/
insert into HtmlLabelInfo values(16491,'行业设置',7) 
/
insert into HtmlLabelInfo values(16492,'规模设置',7) 
/
insert into HtmlLabelInfo values(16492,'',8) 
/
insert into HtmlLabelInfo values(16493,'类别设置',7) 
/
insert into HtmlLabelInfo values(16493,'',8) 
/
insert into HtmlLabelInfo values(16494,'描述设置',7) 
/
insert into HtmlLabelInfo values(16495,'状态设置',7) 
/
insert into HtmlLabelInfo values(16496,'价值设置',7) 
/
insert into HtmlLabelInfo values(16496,'',8) 
/
insert into HtmlLabelInfo values(16497,'评估项目',7) 
/
insert into HtmlLabelInfo values(16498,'',8) 
/
insert into HtmlLabelInfo values(16499,'',8) 
/
insert into HtmlLabelInfo values(16500,'',8) 
/
insert into HtmlLabelInfo values(16501,'合同信用',7) 
/
insert into HtmlLabelInfo values(16501,'',8) 
/
insert into HtmlLabelInfo values(16502,'额度期间',7) 
/
insert into HtmlLabelInfo values(16502,'',8) 
/
insert into HtmlLabelInfo values(16503,'字段定义',7) 
/
insert into HtmlLabelInfo values(16504,'期间设置',7) 
/
insert into HtmlLabelInfo values(16504,'',8) 
/
insert into HtmlLabelInfo values(16505,'',8) 
/
insert into HtmlLabelInfo values(16506,'财务销帐',7) 
/
insert into HtmlLabelInfo values(16508,'类型定义',7) 
/
insert into HtmlLabelInfo values(16509,'新建资料',7) 
/
insert into HtmlLabelInfo values(16510,'属性设置',7) 
/
insert into HtmlLabelInfo values(16510,'',8) 
/
insert into HtmlLabelInfo values(16511,'单位设置',7) 
/
insert into HtmlLabelInfo values(16511,'',8) 
/
insert into HtmlLabelInfo values(16515,'',8) 
/
insert into HtmlLabelInfo values(16516,'',8) 
/
insert into HtmlLabelInfo values(16517,'条件维护',7) 
/
insert into HtmlLabelInfo values(16518,'输出维护',7) 
/
insert into HtmlLabelInfo values(16519,'',8) 
/
insert into HtmlLabelInfo values(16520,'',8) 
/
insert into HtmlLabelInfo values(16521,'用户管理',7) 
/
insert into HtmlLabelInfo values(16522,'',8) 
/
insert into HtmlLabelInfo values(16523,'省份设置',7) 
/
insert into HtmlLabelInfo values(16529,'邮件及文件',7) 
/
insert into HtmlLabelInfo values(16529,'',8) 
/
insert into HtmlLabelInfo values(16530,'人事报表',7) 
/
insert into HtmlLabelInfo values(16531,'',8) 
/
insert into HtmlLabelInfo values(16534,'',8) 
/
insert into HtmlLabelInfo values(16535,'资产报表',7) 
/
insert into HtmlLabelInfo values(16536,'',8) 
/
insert into HtmlLabelInfo values(16537,'通讯录本',7) 
/
insert into HtmlLabelInfo values(16537,'',8) 
/
insert into HtmlLabelInfo values(16538,'统计报表',7) 
/
insert into HtmlLabelInfo values(16539,'计划任务',7) 
/
insert into HtmlLabelInfo values(16539,'',8) 
/
insert into HtmlLabelInfo values(16540,'工作报告',7) 
/
insert into HtmlLabelInfo values(16540,'',8) 
/
insert into HtmlLabelInfo values(16541,'任务统计',7) 
/
insert into HtmlLabelInfo values(16541,'',8) 
/
insert into HtmlLabelInfo values(16542,'流程报告',7) 
/
insert into HtmlLabelInfo values(16542,'',8) 
/
insert into HtmlLabelInfo values(16543,'人员状况',7) 
/
insert into HtmlLabelInfo values(16544,'人力列表',7) 
/
insert into HtmlLabelInfo values(16546,'职级报表',7) 
/
insert into HtmlLabelInfo values(16546,'',8) 
/
insert into HtmlLabelInfo values(16548,'',8) 
/
insert into HtmlLabelInfo values(16549,'',8) 
/
insert into HtmlLabelInfo values(16550,'学历报表',7) 
/
insert into HtmlLabelInfo values(16550,'',8) 
/
insert into HtmlLabelInfo values(16551,'部门报表',7) 
/
insert into HtmlLabelInfo values(16552,'岗位报表',7) 
/
insert into HtmlLabelInfo values(16553,'',8) 
/
insert into HtmlLabelInfo values(16554,'',8) 
/
insert into HtmlLabelInfo values(16555,'状态报表',7) 
/
insert into HtmlLabelInfo values(16555,'',8) 
/
insert into HtmlLabelInfo values(16556,'培训相关',7) 
/
insert into HtmlLabelInfo values(16557,'',8) 
/
insert into HtmlLabelInfo values(16559,'',8) 
/
insert into HtmlLabelInfo values(16560,'',8) 
/
insert into HtmlLabelInfo values(16561,'',8) 
/
insert into HtmlLabelInfo values(16563,'',8) 
/
insert into HtmlLabelInfo values(16564,'调动情况',7) 
/
insert into HtmlLabelInfo values(16565,'新增情况',7) 
/
insert into HtmlLabelInfo values(16569,'退休情况',7) 
/
insert into HtmlLabelInfo values(16570,'离职情况',7) 
/
insert into HtmlLabelInfo values(16571,'',8) 
/
insert into HtmlLabelInfo values(16572,'合同情况',7) 
/
insert into HtmlLabelInfo values(16572,'',8) 
/
insert into HtmlLabelInfo values(16573,'项目经理',7) 
/
insert into HtmlLabelInfo values(16573,'',8) 
/
insert into HtmlLabelInfo values(16575,'近期修改',7) 
/
insert into HtmlLabelInfo values(16576,'近期读取',7) 
/
insert into HtmlLabelInfo values(16577,'未完流程',7) 
/
insert into HtmlLabelInfo values(16579,'流程类型',7) 
/
insert into HtmlLabelInfo values(16579,'',8) 
/
insert into HtmlLabelInfo values(16581,'',8) 
/
insert into HtmlLabelInfo values(16583,'客户行业',7) 
/
insert into HtmlLabelInfo values(16583,'',8) 
/
insert into HtmlLabelInfo values(16584,'共享情况',7) 
/
insert into HtmlLabelInfo values(16584,'',8) 
/
insert into HtmlLabelInfo values(16585,'机会列表',7) 
/
insert into HtmlLabelInfo values(16585,'',8) 
/
insert into HtmlLabelInfo values(16586,'',8) 
/
insert into HtmlLabelInfo values(16587,'',8) 
/
insert into HtmlLabelInfo values(16588,'应收应付',7) 
/
insert into HtmlLabelInfo values(16589,'合同产品',7) 
/
insert into HtmlLabelInfo values(16590,'区域金额',7) 
/
insert into HtmlLabelInfo values(16591,'产品金额',7) 
/
insert into HtmlLabelInfo values(16594,'累计金额',7) 
/
insert into HtmlLabelInfo values(16594,'',8) 
/
insert into HtmlLabelInfo values(16595,'日志报表',7) 
/
insert into HtmlLabelInfo values(16596,'近期登录',7) 
/
insert into HtmlLabelInfo values(16596,'',8) 
/
insert into HtmlLabelInfo values(16598,'人员资产',7) 
/
insert into HtmlLabelInfo values(16599,'',8) 
/
insert into HtmlLabelInfo values(16600,'著者文档数量',7) 
/
insert into HtmlLabelInfo values(16600,'',8) 
/
insert into HtmlLabelInfo values(16601,'部门文档数量 ',7) 
/
insert into HtmlLabelInfo values(16604,'文档被阅报表',7) 
/
insert into HtmlLabelInfo values(16604,'',8) 
/
insert into HtmlLabelInfo values(16605,'文档目录报表',7) 
/
insert into HtmlLabelInfo values(16607,'最多文档著者',7) 
/
insert into HtmlLabelInfo values(16607,'',8) 
/
insert into HtmlLabelInfo values(16608,'',8) 
/
insert into HtmlLabelInfo values(16610,'最多关联人员',7) 
/
insert into HtmlLabelInfo values(16611,'',8) 
/
insert into HtmlLabelInfo values(16612,'最多文档部门',7) 
/
insert into HtmlLabelInfo values(16613,'会议报表',7) 
/
insert into HtmlLabelInfo values(16613,'',8) 
/
insert into HtmlLabelInfo values(16614,'',8) 
/
insert into HtmlLabelInfo values(16615,'会议室设置',7) 
/
insert into HtmlLabelInfo values(16616,'会议类型设置',7) 
/
insert into HtmlLabelInfo values(16616,'',8) 
/
insert into HtmlLabelInfo values(16618,'关闭预算输入',7) 
/
insert into HtmlLabelInfo values(16618,'OpenFinanceInput',8) 
/
insert into HtmlLabelInfo values(16619,'OpenFiananceInput',8) 
/
insert into HtmlLabelInfo values(16620,'更改行列',7) 
/
insert into HtmlLabelInfo values(16620,'ChangeConlumn',8) 
/
insert into HtmlLabelInfo values(16621,'报表项定义',7) 
/
insert into HtmlLabelInfo values(16621,'ReportItemDefine',8) 
/
insert into HtmlLabelInfo values(16622,'changesuccessful',8) 
/
insert into HtmlLabelInfo values(16625,'月修正',7) 
/
insert into HtmlLabelInfo values(16625,'monthedit',8) 
/
insert into HtmlLabelInfo values(16626,'年修正',7) 
/
insert into HtmlLabelInfo values(16626,'yearedit',8) 
/
insert into HtmlLabelInfo values(16627,'签章管理',7) 
/
insert into HtmlLabelInfo values(16628,'',8) 
/
insert into HtmlLabelInfo values(16629,'生成图形',7) 
/
insert into HtmlLabelInfo values(16629,'MakePic',8) 
/
insert into HtmlLabelInfo values(16630,'上传Excel',7) 
/
insert into HtmlLabelInfo values(16632,'商店',7) 
/
insert into HtmlLabelInfo values(16632,'',8) 
/
insert into HtmlLabelInfo values(16633,'',8) 
/
insert into HtmlLabelInfo values(16634,'确认',7) 
/
insert into HtmlLabelInfo values(16636,'',8) 
/
insert into HtmlLabelInfo values(16637,'',8) 
/
insert into HtmlLabelInfo values(16638,'清除密码',7) 
/
insert into HtmlLabelInfo values(16640,'复制到服务器',7) 
/
insert into HtmlLabelInfo values(16640,'',8) 
/
insert into HtmlLabelInfo values(15163,'',8) 
/
insert into HtmlLabelInfo values(15164,'变更客户合同',7) 
/
insert into HtmlLabelInfo values(15164,'',8) 
/
insert into HtmlLabelInfo values(15165,'调查表单的HTML文件',7) 
/
insert into HtmlLabelInfo values(15165,'',8) 
/
insert into HtmlLabelInfo values(15166,'如果你不希望再次收到此类邮件，请点击',7) 
/
insert into HtmlLabelInfo values(15166,'',8) 
/
insert into HtmlLabelInfo values(15167,'退订',7) 
/
insert into HtmlLabelInfo values(15167,'',8) 
/
insert into HtmlLabelInfo values(15168,'注',7) 
/
insert into HtmlLabelInfo values(15168,'',8) 
/
insert into HtmlLabelInfo values(15169,'请把下面的HTML代码粘贴到邮件模板中',7) 
/
insert into HtmlLabelInfo values(15169,'',8) 
/
insert into HtmlLabelInfo values(15170,'系统提示：对不起，空记录不能进行转换',7) 
/
insert into HtmlLabelInfo values(15170,'',8) 
/
insert into HtmlLabelInfo values(15171,'退订失败',7) 
/
insert into HtmlLabelInfo values(15171,'',8) 
/
insert into HtmlLabelInfo values(15172,'系统提示',7) 
/
insert into HtmlLabelInfo values(15172,'',8) 
/
insert into HtmlLabelInfo values(15173,'提交失败',7) 
/
insert into HtmlLabelInfo values(15173,'',8) 
/
insert into HtmlLabelInfo values(15174,'已提交的客户',7) 
/
insert into HtmlLabelInfo values(15174,'',8) 
/
insert into HtmlLabelInfo values(15175,'提交日期',7) 
/
insert into HtmlLabelInfo values(15175,'',8) 
/
insert into HtmlLabelInfo values(15176,'已提交',7) 
/
insert into HtmlLabelInfo values(15176,'',8) 
/
insert into HtmlLabelInfo values(15177,'未提交的客户',7) 
/
insert into HtmlLabelInfo values(15177,'',8) 
/
insert into HtmlLabelInfo values(15178,'未提交',7) 
/
insert into HtmlLabelInfo values(15178,'',8) 
/
insert into HtmlLabelInfo values(15179,'退订的客户',7) 
/
insert into HtmlLabelInfo values(15179,'',8) 
/
insert into HtmlLabelInfo values(15180,'退订日期',7) 
/
insert into HtmlLabelInfo values(15180,'',8) 
/
insert into HtmlLabelInfo values(15181,'调查表内容',7) 
/
insert into HtmlLabelInfo values(15181,'',8) 
/
insert into HtmlLabelInfo values(15182,'调查信息',7) 
/
insert into HtmlLabelInfo values(15182,'',8) 
/
insert into HtmlLabelInfo values(15183,'调查表单名称',7) 
/
insert into HtmlLabelInfo values(15183,'',8) 
/
insert into HtmlLabelInfo values(15184,'输入报表',7) 
/
insert into HtmlLabelInfo values(15184,'',8) 
/
insert into HtmlLabelInfo values(15185,'输入报表名称',7) 
/
insert into HtmlLabelInfo values(15185,'',8) 
/
insert into HtmlLabelInfo values(15186,'数据表名',7) 
/
insert into HtmlLabelInfo values(15186,'',8) 
/
insert into HtmlLabelInfo values(15187,'调查报表',7) 
/
insert into HtmlLabelInfo values(15187,'',8) 
/
insert into HtmlLabelInfo values(15188,'输入信息',7) 
/
insert into HtmlLabelInfo values(15188,'',8) 
/
insert into HtmlLabelInfo values(15189,'调查表名称',7) 
/
insert into HtmlLabelInfo values(15189,'',8) 
/
insert into HtmlLabelInfo values(15190,'数据库表名',7) 
/
insert into HtmlLabelInfo values(15190,'',8) 
/
insert into HtmlLabelInfo values(15191,'格式为',7) 
/
insert into HtmlLabelInfo values(15191,'',8) 
/
insert into HtmlLabelInfo values(15192,'其表名不能重复',7) 
/
insert into HtmlLabelInfo values(15192,'',8) 
/
insert into HtmlLabelInfo values(15193,'请输入您所需要链接的地址',7) 
/
insert into HtmlLabelInfo values(15193,'',8) 
/
insert into HtmlLabelInfo values(15194,'如',7) 
/
insert into HtmlLabelInfo values(15194,'',8) 
/
insert into HtmlLabelInfo values(15195,'邮件版式',7) 
/
insert into HtmlLabelInfo values(15195,'',8) 
/
insert into HtmlLabelInfo values(15196,'格式',7) 
/
insert into HtmlLabelInfo values(15196,'',8) 
/
insert into HtmlLabelInfo values(15197,'调查表信息',7) 
/
insert into HtmlLabelInfo values(15197,'',8) 
/
insert into HtmlLabelInfo values(15198,'邮件模板名',7) 
/
insert into HtmlLabelInfo values(15198,'',8) 
/
insert into HtmlLabelInfo values(15199,'输入项信息',7) 
/
insert into HtmlLabelInfo values(15199,'',8) 
/
insert into HtmlLabelInfo values(15200,'输入项',7) 
/
insert into HtmlLabelInfo values(15200,'',8) 
/
insert into HtmlLabelInfo values(15201,'单行文本型',7) 
/
insert into HtmlLabelInfo values(15201,'',8) 
/
insert into HtmlLabelInfo values(15202,'整数型',7) 
/
insert into HtmlLabelInfo values(15202,'',8) 
/
insert into HtmlLabelInfo values(15203,'浮点型',7) 
/
insert into HtmlLabelInfo values(15203,'',8) 
/
insert into HtmlLabelInfo values(15204,'单选型',7) 
/
insert into HtmlLabelInfo values(15204,'',8) 
/
insert into HtmlLabelInfo values(15205,'多选型',7) 
/
insert into HtmlLabelInfo values(15205,'',8) 
/
insert into HtmlLabelInfo values(15206,'多行文本型',7) 
/
insert into HtmlLabelInfo values(15206,'',8) 
/
insert into HtmlLabelInfo values(15207,'输入项名称',7) 
/
insert into HtmlLabelInfo values(15207,'',8) 
/
insert into HtmlLabelInfo values(15208,'输入项类型',7) 
/
insert into HtmlLabelInfo values(15208,'',8) 
/
insert into HtmlLabelInfo values(15209,'输入项字段名',7) 
/
insert into HtmlLabelInfo values(15209,'',8) 
/
insert into HtmlLabelInfo values(15210,'其字段名不能重复',7) 
/
insert into HtmlLabelInfo values(15210,'',8) 
/
insert into HtmlLabelInfo values(15211,'文本字段宽度',7) 
/
insert into HtmlLabelInfo values(15211,'',8) 
/
insert into HtmlLabelInfo values(15212,'小数位数',7) 
/
insert into HtmlLabelInfo values(15212,'',8) 
/
insert into HtmlLabelInfo values(15213,'调查表单输入项信息',7) 
/
insert into HtmlLabelInfo values(15213,'',8) 
/
insert into HtmlLabelInfo values(15214,'选择项详细值',7) 
/
insert into HtmlLabelInfo values(15214,'',8) 
/
insert into HtmlLabelInfo values(15215,'选择显示值和数据表值应一致',7) 
/
insert into HtmlLabelInfo values(15215,'',8) 
/
insert into HtmlLabelInfo values(15216,'选择显示值',7) 
/
insert into HtmlLabelInfo values(15216,'',8) 
/
insert into HtmlLabelInfo values(15217,'数据表值',7) 
/
insert into HtmlLabelInfo values(15217,'',8) 
/
insert into HtmlLabelInfo values(15218,'调查表单',7) 
/
insert into HtmlLabelInfo values(15218,'',8) 
/
insert into HtmlLabelInfo values(15219,'接收调查表情况',7) 
/
insert into HtmlLabelInfo values(15219,'',8) 
/
insert into HtmlLabelInfo values(15220,'应提交的总客户',7) 
/
insert into HtmlLabelInfo values(15220,'',8) 
/
insert into HtmlLabelInfo values(15221,'实际提交的总客户',7) 
/
insert into HtmlLabelInfo values(15221,'',8) 
/
insert into HtmlLabelInfo values(15222,'退订的总客户',7) 
/
insert into HtmlLabelInfo values(15222,'',8) 
/
insert into HtmlLabelInfo values(15223,'总权重指数不能大于',7) 
/
insert into HtmlLabelInfo values(15223,'',8) 
/
insert into HtmlLabelInfo values(15224,'已收',7) 
/
insert into HtmlLabelInfo values(15224,'',8) 
/
insert into HtmlLabelInfo values(15225,'未收',7) 
/
insert into HtmlLabelInfo values(15225,'',8) 
/
insert into HtmlLabelInfo values(15226,'已付',7) 
/
insert into HtmlLabelInfo values(15226,'',8) 
/
insert into HtmlLabelInfo values(15227,'未付',7) 
/
insert into HtmlLabelInfo values(15227,'',8) 
/
insert into HtmlLabelInfo values(15228,'应交货',7) 
/
insert into HtmlLabelInfo values(15228,'',8) 
/
insert into HtmlLabelInfo values(15229,'已交货',7) 
/
insert into HtmlLabelInfo values(15229,'',8) 
/
insert into HtmlLabelInfo values(15230,'未交货',7) 
/
insert into HtmlLabelInfo values(15230,'',8) 
/
insert into HtmlLabelInfo values(15231,'客户数',7) 
/
insert into HtmlLabelInfo values(15231,'',8) 
/
insert into HtmlLabelInfo values(15232,'上次联系时间',7) 
/
insert into HtmlLabelInfo values(15232,'',8) 
/
insert into HtmlLabelInfo values(15233,'交货提醒',7) 
/
insert into HtmlLabelInfo values(15233,'',8) 
/
insert into HtmlLabelInfo values(15234,'付款提醒',7) 
/
insert into HtmlLabelInfo values(15234,'',8) 
/
insert into HtmlLabelInfo values(15235,'客户合同到期提醒',7) 
/
insert into HtmlLabelInfo values(15235,'',8) 
/
insert into HtmlLabelInfo values(15236,'合同结束日期',7) 
/
insert into HtmlLabelInfo values(15236,'',8) 
/
insert into HtmlLabelInfo values(15237,'销售区间段天数',7) 
/
insert into HtmlLabelInfo values(15237,'',8) 
/
insert into HtmlLabelInfo values(15238,'销售区间段数目',7) 
/
insert into HtmlLabelInfo values(15238,'',8) 
/
insert into HtmlLabelInfo values(15239,'中介机构',7) 
/
insert into HtmlLabelInfo values(15239,'',8) 
/
insert into HtmlLabelInfo values(15240,'来源',7) 
/
insert into HtmlLabelInfo values(15240,'',8) 
/
insert into HtmlLabelInfo values(15241,'请输入0～1之间的数',7) 
/
insert into HtmlLabelInfo values(15241,'',8) 
/
insert into HtmlLabelInfo values(15242,'成功',7) 
/
insert into HtmlLabelInfo values(15242,'',8) 
/
insert into HtmlLabelInfo values(15243,'请输入正确的收益区间',7) 
/
insert into HtmlLabelInfo values(15243,'',8) 
/
insert into HtmlLabelInfo values(15244,'销售机会时间',7) 
/
insert into HtmlLabelInfo values(15244,'',8) 
/
insert into HtmlLabelInfo values(15245,'城市业绩统计',7) 
/
insert into HtmlLabelInfo values(15245,'',8) 
/
insert into HtmlLabelInfo values(15246,'城市名称',7) 
/
insert into HtmlLabelInfo values(15246,'',8) 
/
insert into HtmlLabelInfo values(15247,'销售业绩',7) 
/
insert into HtmlLabelInfo values(15247,'',8) 
/
insert into HtmlLabelInfo values(15248,'省份业绩统计',7) 
/
insert into HtmlLabelInfo values(15248,'',8) 
/
insert into HtmlLabelInfo values(15249,'新建销售机会',7) 
/
insert into HtmlLabelInfo values(15249,'',8) 
/
insert into HtmlLabelInfo values(15250,'编辑销售机会',7) 
/
insert into HtmlLabelInfo values(15250,'',8) 
/
insert into HtmlLabelInfo values(15251,'预期收益合计',7) 
/
insert into HtmlLabelInfo values(15251,'',8) 
/
insert into HtmlLabelInfo values(15252,'机会',7) 
/
insert into HtmlLabelInfo values(15252,'',8) 
/
insert into HtmlLabelInfo values(15253,'已签单合同',7) 
/
insert into HtmlLabelInfo values(15253,'',8) 
/
insert into HtmlLabelInfo values(15254,'请输入正确的合同金额区间',7) 
/
insert into HtmlLabelInfo values(15254,'',8) 
/
insert into HtmlLabelInfo values(15255,'销售经理',7) 
/
insert into HtmlLabelInfo values(15255,'',8) 
/
insert into HtmlLabelInfo values(15256,'区间',7) 
/
insert into HtmlLabelInfo values(15256,'',8) 
/
insert into HtmlLabelInfo values(15257,'销售机会统计',7) 
/
insert into HtmlLabelInfo values(15257,'',8) 
/
insert into HtmlLabelInfo values(15258,'机会计数',7) 
/
insert into HtmlLabelInfo values(15258,'',8) 
/
insert into HtmlLabelInfo values(15259,'销售机会金额',7) 
/
insert into HtmlLabelInfo values(15259,'',8) 
/
insert into HtmlLabelInfo values(15260,'金额百分比',7) 
/
insert into HtmlLabelInfo values(15260,'',8) 
/
insert into HtmlLabelInfo values(15261,'项目功能列表',7) 
/
insert into HtmlLabelInfo values(15261,'',8) 
/
insert into HtmlLabelInfo values(15262,'添加项目',7) 
/
insert into HtmlLabelInfo values(15262,'',8) 
/
insert into HtmlLabelInfo values(15263,'客户可见',7) 
/
insert into HtmlLabelInfo values(15263,'',8) 
/
insert into HtmlLabelInfo values(15264,'项目费用',7) 
/
insert into HtmlLabelInfo values(15264,'',8) 
/
insert into HtmlLabelInfo values(15265,'实际收入',7) 
/
insert into HtmlLabelInfo values(15265,'',8) 
/
insert into HtmlLabelInfo values(15266,'新建任务',7) 
/
insert into HtmlLabelInfo values(15266,'',8) 
/
insert into HtmlLabelInfo values(15267,'新建任务（执行）',7) 
/
insert into HtmlLabelInfo values(15267,'',8) 
/
insert into HtmlLabelInfo values(15268,'编辑任务（执行）',7) 
/
insert into HtmlLabelInfo values(15268,'',8) 
/
insert into HtmlLabelInfo values(15269,'新建任务（计划）',7) 
/
insert into HtmlLabelInfo values(15269,'',8) 
/
insert into HtmlLabelInfo values(15270,'编辑任务（计划）',7) 
/
insert into HtmlLabelInfo values(15270,'',8) 
/
insert into HtmlLabelInfo values(15271,'删除任务（执行）',7) 
/
insert into HtmlLabelInfo values(15271,'',8) 
/
insert into HtmlLabelInfo values(15272,'删除任务（计划）',7) 
/
insert into HtmlLabelInfo values(15272,'',8) 
/
insert into HtmlLabelInfo values(15273,'结束时间不能小于起始时间',7) 
/
insert into HtmlLabelInfo values(15273,'',8) 
/
insert into HtmlLabelInfo values(15274,'项目预算',7) 
/
insert into HtmlLabelInfo values(15274,'',8) 
/
insert into HtmlLabelInfo values(15275,'修改日志',7) 
/
insert into HtmlLabelInfo values(15275,'',8) 
/
insert into HtmlLabelInfo values(15276,'项目通知',7) 
/
insert into HtmlLabelInfo values(15276,'',8) 
/
insert into HtmlLabelInfo values(15277,'前置任务未完成',7) 
/
insert into HtmlLabelInfo values(15277,'',8) 
/
insert into HtmlLabelInfo values(15278,'请输入 0～100 之间的整数',7) 
/
insert into HtmlLabelInfo values(15278,'',8) 
/
insert into HtmlLabelInfo values(15279,'元',7) 
/
insert into HtmlLabelInfo values(15279,'',8) 
/
insert into HtmlLabelInfo values(15280,'通知对象：',7) 
/
insert into HtmlLabelInfo values(15280,'',8) 
/
insert into HtmlLabelInfo values(15281,'通知标题：',7) 
/
insert into HtmlLabelInfo values(15281,'',8) 
/
insert into HtmlLabelInfo values(15282,'通知内容：',7) 
/
insert into HtmlLabelInfo values(15282,'',8) 
/
insert into HtmlLabelInfo values(15283,'新建项目任务',7) 
/
insert into HtmlLabelInfo values(15283,'',8) 
/
insert into HtmlLabelInfo values(15284,'编辑任务',7) 
/
insert into HtmlLabelInfo values(15284,'',8) 
/
insert into HtmlLabelInfo values(15285,'任务负责人',7) 
/
insert into HtmlLabelInfo values(15285,'',8) 
/
insert into HtmlLabelInfo values(15286,'任务比较',7) 
/
insert into HtmlLabelInfo values(15286,'',8) 
/
insert into HtmlLabelInfo values(15287,'未开始任务',7) 
/
insert into HtmlLabelInfo values(15287,'',8) 
/
insert into HtmlLabelInfo values(15288,'进行中任务',7) 
/
insert into HtmlLabelInfo values(15288,'',8) 
/
insert into HtmlLabelInfo values(15289,'已完成任务',7) 
/
insert into HtmlLabelInfo values(15289,'',8) 
/
insert into HtmlLabelInfo values(15290,'超期未开始任务',7) 
/
insert into HtmlLabelInfo values(15290,'',8) 
/
insert into HtmlLabelInfo values(15291,'超期未完成任务',7) 
/
insert into HtmlLabelInfo values(15291,'',8) 
/
insert into HtmlLabelInfo values(15292,'(实际/计划)',7) 
/
insert into HtmlLabelInfo values(15292,'',8) 
/
insert into HtmlLabelInfo values(15293,'财务编号',7) 
/
insert into HtmlLabelInfo values(15293,'',8) 
/
insert into HtmlLabelInfo values(15294,'报警数量',7) 
/
insert into HtmlLabelInfo values(15294,'',8) 
/
insert into HtmlLabelInfo values(15295,'相关工作流',7) 
/
insert into HtmlLabelInfo values(15295,'',8) 
/
insert into HtmlLabelInfo values(15296,'统计报告',7) 
/
insert into HtmlLabelInfo values(15296,'',8) 
/
insert into HtmlLabelInfo values(15297,'帐内或帐外',7) 
/
insert into HtmlLabelInfo values(15297,'',8) 
/
insert into HtmlLabelInfo values(15298,'帐内',7) 
/
insert into HtmlLabelInfo values(15298,'',8) 
/
insert into HtmlLabelInfo values(15299,'帐外',7) 
/
insert into HtmlLabelInfo values(15299,'',8) 
/
insert into HtmlLabelInfo values(15300,'报废的资产',7) 
/
insert into HtmlLabelInfo values(15300,'',8) 
/
insert into HtmlLabelInfo values(15301,'入库部门',7) 
/
insert into HtmlLabelInfo values(15301,'',8) 
/
insert into HtmlLabelInfo values(15302,'入库数量',7) 
/
insert into HtmlLabelInfo values(15302,'',8) 
/
insert into HtmlLabelInfo values(15303,'数量错误',7) 
/
insert into HtmlLabelInfo values(15303,'',8) 
/
insert into HtmlLabelInfo values(15304,'借用的资产',7) 
/
insert into HtmlLabelInfo values(15304,'',8) 
/
insert into HtmlLabelInfo values(15305,'资产归还',7) 
/
insert into HtmlLabelInfo values(15305,'',8) 
/
insert into HtmlLabelInfo values(15306,'入库申请',7) 
/
insert into HtmlLabelInfo values(15306,'',8) 
/
insert into HtmlLabelInfo values(15307,'入库验收',7) 
/
insert into HtmlLabelInfo values(15307,'',8) 
/
insert into HtmlLabelInfo values(15308,'维修的资产',7) 
/
insert into HtmlLabelInfo values(15308,'',8) 
/
insert into HtmlLabelInfo values(15309,'调拨资产',7) 
/
insert into HtmlLabelInfo values(15309,'',8) 
/
insert into HtmlLabelInfo values(15310,'调拨申请人',7) 
/
insert into HtmlLabelInfo values(15310,'',8) 
/
insert into HtmlLabelInfo values(15311,'调往部门',7) 
/
insert into HtmlLabelInfo values(15311,'',8) 
/
insert into HtmlLabelInfo values(15312,'领用的资产',7) 
/
insert into HtmlLabelInfo values(15312,'',8) 
/
insert into HtmlLabelInfo values(15313,'领用的数量',7) 
/
insert into HtmlLabelInfo values(15313,'',8) 
/
insert into HtmlLabelInfo values(15314,'领用用途',7) 
/
insert into HtmlLabelInfo values(15314,'',8) 
/
insert into HtmlLabelInfo values(15315,'展开',7) 
/
insert into HtmlLabelInfo values(15315,'',8) 
/
insert into HtmlLabelInfo values(15316,'资产资料列表',7) 
/
insert into HtmlLabelInfo values(15316,'',8) 
/
insert into HtmlLabelInfo values(15317,'上一级',7) 
/
insert into HtmlLabelInfo values(15317,'',8) 
/
insert into HtmlLabelInfo values(15318,'不可全部为空',7) 
/
insert into HtmlLabelInfo values(15318,'',8) 
/
insert into HtmlLabelInfo values(15319,'数字校验错',7) 
/
insert into HtmlLabelInfo values(15319,'',8) 
/
insert into HtmlLabelInfo values(15320,'固定资产',7) 
/
insert into HtmlLabelInfo values(15320,'',8) 
/
insert into HtmlLabelInfo values(15321,'低值易耗品',7) 
/
insert into HtmlLabelInfo values(15321,'',8) 
/
insert into HtmlLabelInfo values(15322,'至',7) 
/
insert into HtmlLabelInfo values(15322,'',8) 
/
insert into HtmlLabelInfo values(15323,'第',7) 
/
insert into HtmlLabelInfo values(15323,'',8) 
/
insert into HtmlLabelInfo values(15324,'类',7) 
/
insert into HtmlLabelInfo values(15324,'',8) 
/
insert into HtmlLabelInfo values(15325,'借用',7) 
/
insert into HtmlLabelInfo values(15325,'',8) 
/
insert into HtmlLabelInfo values(15326,'统计人',7) 
/
insert into HtmlLabelInfo values(15326,'',8) 
/
insert into HtmlLabelInfo values(15327,'统计日期',7) 
/
insert into HtmlLabelInfo values(15327,'',8) 
/
insert into HtmlLabelInfo values(15328,'驾驶员统计表',7) 
/
insert into HtmlLabelInfo values(15328,'',8) 
/
insert into HtmlLabelInfo values(15329,'生成报表',7) 
/
insert into HtmlLabelInfo values(15329,'',8) 
/
insert into HtmlLabelInfo values(15330,'驾驶员',7) 
/
insert into HtmlLabelInfo values(15330,'',8) 
/
insert into HtmlLabelInfo values(15331,'德隆国际战略投资有限公司行政管理部驾驶员统计表',7) 
/
insert into HtmlLabelInfo values(15331,'',8) 
/
insert into HtmlLabelInfo values(15332,'制表人',7) 
/
insert into HtmlLabelInfo values(15332,'',8) 
/
insert into HtmlLabelInfo values(15333,'日到',7) 
/
insert into HtmlLabelInfo values(15333,'',8) 
/
insert into HtmlLabelInfo values(15334,'工作时间出车次数',7) 
/
insert into HtmlLabelInfo values(15334,'',8) 
/
insert into HtmlLabelInfo values(15335,'平时晚间出车次数',7) 
/
insert into HtmlLabelInfo values(15335,'',8) 
/
insert into HtmlLabelInfo values(15336,'休息日出车次数',7) 
/
insert into HtmlLabelInfo values(15336,'',8) 
/
insert into HtmlLabelInfo values(15337,'外地出车次数',7) 
/
insert into HtmlLabelInfo values(15337,'',8) 
/
insert into HtmlLabelInfo values(15338,'行驶公里数',7) 
/
insert into HtmlLabelInfo values(15338,'',8) 
/
insert into HtmlLabelInfo values(15339,'燃油费',7) 
/
insert into HtmlLabelInfo values(15339,'',8) 
/
insert into HtmlLabelInfo values(15340,'停车过路费',7) 
/
insert into HtmlLabelInfo values(15340,'',8) 
/
insert into HtmlLabelInfo values(15341,'修理费',7) 
/
insert into HtmlLabelInfo values(15341,'',8) 
/
insert into HtmlLabelInfo values(15342,'电话费',7) 
/
insert into HtmlLabelInfo values(15342,'',8) 
/
insert into HtmlLabelInfo values(15343,'加班补助',7) 
/
insert into HtmlLabelInfo values(15343,'',8) 
/
insert into HtmlLabelInfo values(15344,'季考核总分数',7) 
/
insert into HtmlLabelInfo values(15344,'',8) 
/
insert into HtmlLabelInfo values(15345,'车辆统计表',7) 
/
insert into HtmlLabelInfo values(15345,'',8) 
/
insert into HtmlLabelInfo values(15346,'德隆国际战略投资有限公司行政管理部车辆统计表',7) 
/
insert into HtmlLabelInfo values(15346,'',8) 
/
insert into HtmlLabelInfo values(15347,'车辆编号',7) 
/
insert into HtmlLabelInfo values(15347,'',8) 
/
insert into HtmlLabelInfo values(15348,'行驶总公里数',7) 
/
insert into HtmlLabelInfo values(15348,'',8) 
/
insert into HtmlLabelInfo values(15349,'保养费用及时间',7) 
/
insert into HtmlLabelInfo values(15349,'',8) 
/
insert into HtmlLabelInfo values(15350,'维修费用及时间',7) 
/
insert into HtmlLabelInfo values(15350,'',8) 
/
insert into HtmlLabelInfo values(15351,'清洁费用',7) 
/
insert into HtmlLabelInfo values(15351,'',8) 
/
insert into HtmlLabelInfo values(15352,'计划实际比较表',7) 
/
insert into HtmlLabelInfo values(15352,'',8) 
/
insert into HtmlLabelInfo values(15353,'生成图表',7) 
/
insert into HtmlLabelInfo values(15353,'',8) 
/
insert into HtmlLabelInfo values(15354,'各部门费用计划实际比较表',7) 
/
insert into HtmlLabelInfo values(15354,'',8) 
/
insert into HtmlLabelInfo values(15355,'部门需求统计表',7) 
/
insert into HtmlLabelInfo values(15355,'',8) 
/
insert into HtmlLabelInfo values(15356,'费用计划实际比较表',7) 
/
insert into HtmlLabelInfo values(15356,'',8) 
/
insert into HtmlLabelInfo values(15357,'验证',7) 
/
insert into HtmlLabelInfo values(15357,'',8) 
/
insert into HtmlLabelInfo values(15358,'作废',7) 
/
insert into HtmlLabelInfo values(15358,'',8) 
/
insert into HtmlLabelInfo values(15359,'验证入库',7) 
/
insert into HtmlLabelInfo values(15359,'',8) 
/
insert into HtmlLabelInfo values(15360,'列表显示',7) 
/
insert into HtmlLabelInfo values(15360,'',8) 
/
insert into HtmlLabelInfo values(15361,'资产或资料',7) 
/
insert into HtmlLabelInfo values(15361,'',8) 
/
insert into HtmlLabelInfo values(15362,'分级显示',7) 
/
insert into HtmlLabelInfo values(15362,'',8) 
/
insert into HtmlLabelInfo values(15363,'预算管理',7) 
/
insert into HtmlLabelInfo values(15363,'',8) 
/
insert into HtmlLabelInfo values(15364,'条件',7) 
/
insert into HtmlLabelInfo values(15364,'',8) 
/
insert into HtmlLabelInfo values(15365,'预算年度',7) 
/
insert into HtmlLabelInfo values(15365,'',8) 
/
insert into HtmlLabelInfo values(15366,'申报',7) 
/
insert into HtmlLabelInfo values(15366,'',8) 
/
insert into HtmlLabelInfo values(15367,'核准',7) 
/
insert into HtmlLabelInfo values(15367,'',8) 
/
insert into HtmlLabelInfo values(15368,'偏差',7) 
/
insert into HtmlLabelInfo values(15368,'',8) 
/
insert into HtmlLabelInfo values(15369,'导入申报值',7) 
/
insert into HtmlLabelInfo values(15369,'',8) 
/
insert into HtmlLabelInfo values(15370,'月度预算',7) 
/
insert into HtmlLabelInfo values(15370,'',8) 
/
insert into HtmlLabelInfo values(15371,'预算类型',7) 
/
insert into HtmlLabelInfo values(15371,'',8) 
/
insert into HtmlLabelInfo values(15372,'期',7) 
/
insert into HtmlLabelInfo values(15372,'',8) 
/
insert into HtmlLabelInfo values(15373,'季度预算',7) 
/
insert into HtmlLabelInfo values(15373,'',8) 
/
insert into HtmlLabelInfo values(15374,'半年预算',7) 
/
insert into HtmlLabelInfo values(15374,'',8) 
/
insert into HtmlLabelInfo values(15375,'年度预算',7) 
/
insert into HtmlLabelInfo values(15375,'',8) 
/
insert into HtmlLabelInfo values(15376,'通过',7) 
/
insert into HtmlLabelInfo values(15376,'',8) 
/
insert into HtmlLabelInfo values(15377,'核准编辑',7) 
/
insert into HtmlLabelInfo values(15377,'',8) 
/
insert into HtmlLabelInfo values(15378,'审批状态',7) 
/
insert into HtmlLabelInfo values(15378,'',8) 
/
insert into HtmlLabelInfo values(15379,'1、部门的预算申报的各项收入值必须大于或等于核准值(或者没有核准值)，审批才能通过！',7) 
/
insert into HtmlLabelInfo values(15379,'',8) 
/
insert into HtmlLabelInfo values(15380,'2、部门的预算申报的各项支出值必须小于或等于核准值(或者没有核准值)，审批才能通过！',7) 
/
insert into HtmlLabelInfo values(15380,'',8) 
/
insert into HtmlLabelInfo values(15381,'3、审批通过后，该部门本年度预算申报值和核准值便不能改动！',7) 
/
insert into HtmlLabelInfo values(15381,'',8) 
/
insert into HtmlLabelInfo values(15382,'是否继续？',7) 
/
insert into HtmlLabelInfo values(15382,'',8) 
/
insert into HtmlLabelInfo values(15383,'有不满足上述两个条件的申报存在，不能审批通过！',7) 
/
insert into HtmlLabelInfo values(15383,'',8) 
/
insert into HtmlLabelInfo values(15384,'本年',7) 
/
insert into HtmlLabelInfo values(15384,'',8) 
/
insert into HtmlLabelInfo values(15385,'收支类型',7) 
/
insert into HtmlLabelInfo values(15385,'',8) 
/
insert into HtmlLabelInfo values(15386,'周期',7) 
/
insert into HtmlLabelInfo values(15386,'',8) 
/
insert into HtmlLabelInfo values(15387,'偏差允许',7) 
/
insert into HtmlLabelInfo values(15387,'',8) 
/
insert into HtmlLabelInfo values(15388,'预算周期',7) 
/
insert into HtmlLabelInfo values(15388,'',8) 
/
insert into HtmlLabelInfo values(15389,'允许偏差',7) 
/
insert into HtmlLabelInfo values(15389,'',8) 
/
insert into HtmlLabelInfo values(15390,'部门名称',7) 
/
insert into HtmlLabelInfo values(15390,'',8) 
/
insert into HtmlLabelInfo values(15391,'部门编号',7) 
/
insert into HtmlLabelInfo values(15391,'',8) 
/
insert into HtmlLabelInfo values(15392,'销帐人',7) 
/
insert into HtmlLabelInfo values(15392,'',8) 
/
insert into HtmlLabelInfo values(15393,'所属部门',7) 
/
insert into HtmlLabelInfo values(15393,'',8) 
/
insert into HtmlLabelInfo values(15394,'销帐日期',7) 
/
insert into HtmlLabelInfo values(15394,'',8) 
/
insert into HtmlLabelInfo values(15395,'销帐金额',7) 
/
insert into HtmlLabelInfo values(15395,'',8) 
/
insert into HtmlLabelInfo values(15396,'个人帐务往来',7) 
/
insert into HtmlLabelInfo values(15396,'',8) 
/
insert into HtmlLabelInfo values(15397,'发生日期',7) 
/
insert into HtmlLabelInfo values(15397,'',8) 
/
insert into HtmlLabelInfo values(15398,'发生金额',7) 
/
insert into HtmlLabelInfo values(15398,'',8) 
/
insert into HtmlLabelInfo values(15399,'个人销帐',7) 
/
insert into HtmlLabelInfo values(15399,'',8) 
/
insert into HtmlLabelInfo values(15400,'个人欠款累计',7) 
/
insert into HtmlLabelInfo values(15400,'',8) 
/
insert into HtmlLabelInfo values(15401,'部门预算',7) 
/
insert into HtmlLabelInfo values(15401,'',8) 
/
insert into HtmlLabelInfo values(15402,'个人预算',7) 
/
insert into HtmlLabelInfo values(15402,'',8) 
/
insert into HtmlLabelInfo values(15403,'部门收支',7) 
/
insert into HtmlLabelInfo values(15403,'',8) 
/
insert into HtmlLabelInfo values(15404,'个人收支',7) 
/
insert into HtmlLabelInfo values(15404,'',8) 
/
insert into HtmlLabelInfo values(15405,'客户收支',7) 
/
insert into HtmlLabelInfo values(15405,'',8) 
/
insert into HtmlLabelInfo values(15406,'项目收支',7) 
/
insert into HtmlLabelInfo values(15406,'',8) 
/
insert into HtmlLabelInfo values(15407,'管理费用明细报表',7) 
/
insert into HtmlLabelInfo values(15407,'',8) 
/
insert into HtmlLabelInfo values(15408,'回退',7) 
/
insert into HtmlLabelInfo values(15408,'',8) 
/
insert into HtmlLabelInfo values(15409,'科目名称',7) 
/
insert into HtmlLabelInfo values(15409,'',8) 
/
insert into HtmlLabelInfo values(15410,'本期发生',7) 
/
insert into HtmlLabelInfo values(15410,'',8) 
/
insert into HtmlLabelInfo values(15411,'本年累计',7) 
/
insert into HtmlLabelInfo values(15411,'',8) 
/
insert into HtmlLabelInfo values(15412,'期末余额',7) 
/
insert into HtmlLabelInfo values(15412,'',8) 
/
insert into HtmlLabelInfo values(15413,'生成',7) 
/
insert into HtmlLabelInfo values(15413,'',8) 
/
insert into HtmlLabelInfo values(15414,'显示金额为零的记录',7) 
/
insert into HtmlLabelInfo values(15414,'',8) 
/
insert into HtmlLabelInfo values(15415,'显示发生额为零的记录',7) 
/
insert into HtmlLabelInfo values(15415,'',8) 
/
insert into HtmlLabelInfo values(15416,'显示包含未过帐凭证',7) 
/
insert into HtmlLabelInfo values(15416,'',8) 
/
insert into HtmlLabelInfo values(15417,'万元表',7) 
/
insert into HtmlLabelInfo values(15417,'',8) 
/
insert into HtmlLabelInfo values(15418,'货币资金报表',7) 
/
insert into HtmlLabelInfo values(15418,'',8) 
/
insert into HtmlLabelInfo values(15419,'上期余额',7) 
/
insert into HtmlLabelInfo values(15419,'',8) 
/
insert into HtmlLabelInfo values(15420,'本期借方发生',7) 
/
insert into HtmlLabelInfo values(15420,'',8) 
/
insert into HtmlLabelInfo values(15421,'本期贷方发生',7) 
/
insert into HtmlLabelInfo values(15421,'',8) 
/
insert into HtmlLabelInfo values(15422,'本期余额',7) 
/
insert into HtmlLabelInfo values(15422,'',8) 
/
insert into HtmlLabelInfo values(15423,'借方笔数',7) 
/
insert into HtmlLabelInfo values(15423,'',8) 
/
insert into HtmlLabelInfo values(15424,'贷方笔数',7) 
/
insert into HtmlLabelInfo values(15424,'',8) 
/
insert into HtmlLabelInfo values(15425,'个人往来报表',7) 
/
insert into HtmlLabelInfo values(15425,'',8) 
/
insert into HtmlLabelInfo values(15426,'财务年度',7) 
/
insert into HtmlLabelInfo values(15426,'',8) 
/
insert into HtmlLabelInfo values(15427,'预算审批状态',7) 
/
insert into HtmlLabelInfo values(15427,'',8) 
/
insert into HtmlLabelInfo values(15428,'月度收支',7) 
/
insert into HtmlLabelInfo values(15428,'',8) 
/
insert into HtmlLabelInfo values(15429,'季度收支',7) 
/
insert into HtmlLabelInfo values(15429,'',8) 
/
insert into HtmlLabelInfo values(15430,'半年收支',7) 
/
insert into HtmlLabelInfo values(15430,'',8) 
/
insert into HtmlLabelInfo values(15431,'年度收支',7) 
/
insert into HtmlLabelInfo values(15431,'',8) 
/
insert into HtmlLabelInfo values(15432,'相关处理',7) 
/
insert into HtmlLabelInfo values(15432,'',8) 
/
insert into HtmlLabelInfo values(15433,'工作流类型',7) 
/
insert into HtmlLabelInfo values(15433,'',8) 
/
insert into HtmlLabelInfo values(15434,'报表种类',7) 
/
insert into HtmlLabelInfo values(15434,'',8) 
/
insert into HtmlLabelInfo values(15435,'报表定义',7) 
/
insert into HtmlLabelInfo values(15435,'',8) 
/
insert into HtmlLabelInfo values(15436,'固定报表',7) 
/
insert into HtmlLabelInfo values(15436,'',8) 
/
insert into HtmlLabelInfo values(15437,'工作流管理',7) 
/
insert into HtmlLabelInfo values(15437,'',8) 
/
insert into HtmlLabelInfo values(15438,'流程图编辑',7) 
/
insert into HtmlLabelInfo values(15438,'',8) 
/
insert into HtmlLabelInfo values(15439,'默认总金额',7) 
/
insert into HtmlLabelInfo values(15439,'',8) 
/
insert into HtmlLabelInfo values(15440,'该字段名已经被使用',7) 
/
insert into HtmlLabelInfo values(15440,'',8) 
/
insert into HtmlLabelInfo values(15441,'字段名不能用中文,而且必须以英文字母开头(如f4)',7) 
/
insert into HtmlLabelInfo values(15441,'',8) 
/
insert into HtmlLabelInfo values(15442,'可选项文字',7) 
/
insert into HtmlLabelInfo values(15442,'',8) 
/
insert into HtmlLabelInfo values(15443,'添加内容',7) 
/
insert into HtmlLabelInfo values(15443,'',8) 
/
insert into HtmlLabelInfo values(15444,'删除内容',7) 
/
insert into HtmlLabelInfo values(15444,'',8) 
/
insert into HtmlLabelInfo values(15445,'没有选择一个删除项',7) 
/
insert into HtmlLabelInfo values(15445,'',8) 
/
insert into HtmlLabelInfo values(15446,'选择表单字段',7) 
/
insert into HtmlLabelInfo values(15446,'',8) 
/
insert into HtmlLabelInfo values(15447,'可选字段',7) 
/
insert into HtmlLabelInfo values(15447,'',8) 
/
insert into HtmlLabelInfo values(15448,'已选字段',7) 
/
insert into HtmlLabelInfo values(15448,'',8) 
/
insert into HtmlLabelInfo values(15449,'编辑字段',7) 
/
insert into HtmlLabelInfo values(15449,'',8) 
/
insert into HtmlLabelInfo values(15450,'编辑显示名',7) 
/
insert into HtmlLabelInfo values(15450,'',8) 
/
insert into HtmlLabelInfo values(15451,'表单名称',7) 
/
insert into HtmlLabelInfo values(15451,'',8) 
/
insert into HtmlLabelInfo values(15452,'表单描述',7) 
/
insert into HtmlLabelInfo values(15452,'',8) 
/
insert into HtmlLabelInfo values(15453,'全部字段',7) 
/
insert into HtmlLabelInfo values(15453,'',8) 
/
insert into HtmlLabelInfo values(15454,'表单没有字段信息',7) 
/
insert into HtmlLabelInfo values(15454,'',8) 
/
insert into HtmlLabelInfo values(15455,'缺省',7) 
/
insert into HtmlLabelInfo values(15455,'',8) 
/
insert into HtmlLabelInfo values(15456,'字段显示名',7) 
/
insert into HtmlLabelInfo values(15456,'',8) 
/
insert into HtmlLabelInfo values(15457,'必须先选择一种语言',7) 
/
insert into HtmlLabelInfo values(15457,'',8) 
/
insert into HtmlLabelInfo values(15458,'这种语言已经存在,请另外选择一种',7) 
/
insert into HtmlLabelInfo values(15458,'',8) 
/
insert into HtmlLabelInfo values(15459,'确定删除选定的信息吗',7) 
/
insert into HtmlLabelInfo values(15459,'',8) 
/
insert into HtmlLabelInfo values(15460,'序列号',7) 
/
insert into HtmlLabelInfo values(15460,'',8) 
/
insert into HtmlLabelInfo values(15461,'快递类型',7) 
/
insert into HtmlLabelInfo values(15461,'',8) 
/
insert into HtmlLabelInfo values(15462,'调整费用',7) 
/
insert into HtmlLabelInfo values(15462,'',8) 
/
insert into HtmlLabelInfo values(15463,'没有选择一个具体单据',7) 
/
insert into HtmlLabelInfo values(15463,'',8) 
/
insert into HtmlLabelInfo values(15464,'费用月结',7) 
/
insert into HtmlLabelInfo values(15464,'',8) 
/
insert into HtmlLabelInfo values(15465,'单据号',7) 
/
insert into HtmlLabelInfo values(15465,'',8) 
/
insert into HtmlLabelInfo values(15466,'印刷公司',7) 
/
insert into HtmlLabelInfo values(15466,'',8) 
/
insert into HtmlLabelInfo values(15467,'出票公司',7) 
/
insert into HtmlLabelInfo values(15467,'',8) 
/
insert into HtmlLabelInfo values(15468,'订票人',7) 
/
insert into HtmlLabelInfo values(15468,'',8) 
/
insert into HtmlLabelInfo values(15469,'订票日期',7) 
/
insert into HtmlLabelInfo values(15469,'',8) 
/
insert into HtmlLabelInfo values(15470,'市内快递',7) 
/
insert into HtmlLabelInfo values(15470,'',8) 
/
insert into HtmlLabelInfo values(15471,'快递公司',7) 
/
insert into HtmlLabelInfo values(15471,'',8) 
/
insert into HtmlLabelInfo values(15472,'特快专递',7) 
/
insert into HtmlLabelInfo values(15472,'',8) 
/
insert into HtmlLabelInfo values(15473,'机票预定',7) 
/
insert into HtmlLabelInfo values(15473,'',8) 
/
insert into HtmlLabelInfo values(15474,'购置金额',7) 
/
insert into HtmlLabelInfo values(15474,'',8) 
/
insert into HtmlLabelInfo values(15475,'购置用途',7) 
/
insert into HtmlLabelInfo values(15475,'',8) 
/
insert into HtmlLabelInfo values(15476,'要求时间',7) 
/
insert into HtmlLabelInfo values(15476,'',8) 
/
insert into HtmlLabelInfo values(15477,'整个公司合计',7) 
/
insert into HtmlLabelInfo values(15477,'',8) 
/
insert into HtmlLabelInfo values(15478,'固定资产名称',7) 
/
insert into HtmlLabelInfo values(15478,'',8) 
/
insert into HtmlLabelInfo values(15479,'预计总金额',7) 
/
insert into HtmlLabelInfo values(15479,'',8) 
/
insert into HtmlLabelInfo values(15480,'调入部门',7) 
/
insert into HtmlLabelInfo values(15480,'',8) 
/
insert into HtmlLabelInfo values(15481,'调出部门',7) 
/
insert into HtmlLabelInfo values(15481,'',8) 
/
insert into HtmlLabelInfo values(15482,'原价',7) 
/
insert into HtmlLabelInfo values(15482,'',8) 
/
insert into HtmlLabelInfo values(15483,'资产状况',7) 
/
insert into HtmlLabelInfo values(15483,'',8) 
/
insert into HtmlLabelInfo values(15484,'调拨原因',7) 
/
insert into HtmlLabelInfo values(15484,'',8) 
/
insert into HtmlLabelInfo values(15485,'本月工作小结',7) 
/
insert into HtmlLabelInfo values(15485,'',8) 
/
insert into HtmlLabelInfo values(15486,'序号',7) 
/
insert into HtmlLabelInfo values(15486,'',8) 
/
insert into HtmlLabelInfo values(15487,'完成情况描述',7) 
/
insert into HtmlLabelInfo values(15487,'',8) 
/
insert into HtmlLabelInfo values(15488,'权重指数',7) 
/
insert into HtmlLabelInfo values(15488,'',8) 
/
insert into HtmlLabelInfo values(15489,'考核评分',7) 
/
insert into HtmlLabelInfo values(15489,'',8) 
/
insert into HtmlLabelInfo values(15490,'下月工作计划',7) 
/
insert into HtmlLabelInfo values(15490,'',8) 
/
insert into HtmlLabelInfo values(15491,'下月工作目标',7) 
/
insert into HtmlLabelInfo values(15491,'',8) 
/
insert into HtmlLabelInfo values(15492,'达成结果',7) 
/
insert into HtmlLabelInfo values(15492,'',8) 
/
insert into HtmlLabelInfo values(15493,'本周工作小结',7) 
/
insert into HtmlLabelInfo values(15493,'',8) 
/
insert into HtmlLabelInfo values(15494,'主要事项',7) 
/
insert into HtmlLabelInfo values(15494,'',8) 
/
insert into HtmlLabelInfo values(15495,'完成的结果',7) 
/
insert into HtmlLabelInfo values(15495,'',8) 
/
insert into HtmlLabelInfo values(15496,'没完成事项',7) 
/
insert into HtmlLabelInfo values(15496,'',8) 
/
insert into HtmlLabelInfo values(15497,'原因或改进措施',7) 
/
insert into HtmlLabelInfo values(15497,'',8) 
/
insert into HtmlLabelInfo values(15498,'下周工作计划',7) 
/
insert into HtmlLabelInfo values(15498,'',8) 
/
insert into HtmlLabelInfo values(15499,'主要计划事项',7) 
/
insert into HtmlLabelInfo values(15499,'',8) 
/
insert into HtmlLabelInfo values(15500,'预计完成时间',7) 
/
insert into HtmlLabelInfo values(15500,'',8) 
/
insert into HtmlLabelInfo values(15501,'关键因素',7) 
/
insert into HtmlLabelInfo values(15501,'',8) 
/
insert into HtmlLabelInfo values(15502,'操作时间',7) 
/
insert into HtmlLabelInfo values(15502,'',8) 
/
insert into HtmlLabelInfo values(15503,'操作类型',7) 
/
insert into HtmlLabelInfo values(15503,'',8) 
/
insert into HtmlLabelInfo values(15504,'清空',7) 
/
insert into HtmlLabelInfo values(15504,'',8) 
/
insert into HtmlLabelInfo values(15505,'报表条件',7) 
/
insert into HtmlLabelInfo values(15505,'',8) 
/
insert into HtmlLabelInfo values(15506,'不等于',7) 
/
insert into HtmlLabelInfo values(15506,'',8) 
/
insert into HtmlLabelInfo values(15507,'不包含',7) 
/
insert into HtmlLabelInfo values(15507,'',8) 
/
insert into HtmlLabelInfo values(15508,'大于',7) 
/
insert into HtmlLabelInfo values(15508,'',8) 
/
insert into HtmlLabelInfo values(15509,'小于',7) 
/
insert into HtmlLabelInfo values(15509,'',8) 
/
insert into HtmlLabelInfo values(15510,'报表显示项',7) 
/
insert into HtmlLabelInfo values(15510,'',8) 
/
insert into HtmlLabelInfo values(15511,'是否统计',7) 
/
insert into HtmlLabelInfo values(15511,'',8) 
/
insert into HtmlLabelInfo values(15512,'排序字段',7) 
/
insert into HtmlLabelInfo values(15512,'',8) 
/
insert into HtmlLabelInfo values(15513,'显示顺序',7) 
/
insert into HtmlLabelInfo values(15513,'',8) 
/
insert into HtmlLabelInfo values(15514,'报表管理',7) 
/
insert into HtmlLabelInfo values(15514,'',8) 
/
insert into HtmlLabelInfo values(15515,'显示项',7) 
/
insert into HtmlLabelInfo values(15515,'',8) 
/
insert into HtmlLabelInfo values(15516,'是否排序字段',7) 
/
insert into HtmlLabelInfo values(15516,'',8) 
/
insert into HtmlLabelInfo values(15517,'报表名称',7) 
/
insert into HtmlLabelInfo values(15517,'',8) 
/
insert into HtmlLabelInfo values(15518,'重新查询',7) 
/
insert into HtmlLabelInfo values(15518,'',8) 
/
insert into HtmlLabelInfo values(15519,'报表种类管理',7) 
/
insert into HtmlLabelInfo values(15519,'',8) 
/
insert into HtmlLabelInfo values(15520,'种类名称',7) 
/
insert into HtmlLabelInfo values(15520,'',8) 
/
insert into HtmlLabelInfo values(15521,'种类描述',7) 
/
insert into HtmlLabelInfo values(15521,'',8) 
/
insert into HtmlLabelInfo values(15522,'请求类型',7) 
/
insert into HtmlLabelInfo values(15522,'',8) 
/
insert into HtmlLabelInfo values(15523,'最久时间',7) 
/
insert into HtmlLabelInfo values(15523,'',8) 
/
insert into HtmlLabelInfo values(15524,'计划完成统计',7) 
/
insert into HtmlLabelInfo values(15524,'',8) 
/
insert into HtmlLabelInfo values(15525,'接收人',7) 
/
insert into HtmlLabelInfo values(15525,'',8) 
/
insert into HtmlLabelInfo values(15526,'员工任务完成统计图',7) 
/
insert into HtmlLabelInfo values(15526,'',8) 
/
insert into HtmlLabelInfo values(15527,'固定报表管理',7) 
/
insert into HtmlLabelInfo values(15527,'',8) 
/
insert into HtmlLabelInfo values(15528,'页面名称',7) 
/
insert into HtmlLabelInfo values(15528,'',8) 
/
insert into HtmlLabelInfo values(15529,'对应模块',7) 
/
insert into HtmlLabelInfo values(15529,'',8) 
/
insert into HtmlLabelInfo values(15530,'读取者',7) 
/
insert into HtmlLabelInfo values(15530,'',8) 
/
insert into HtmlLabelInfo values(15531,'报表描述',7) 
/
insert into HtmlLabelInfo values(15531,'',8) 
/
insert into HtmlLabelInfo values(15532,'程度',7) 
/
insert into HtmlLabelInfo values(15532,'',8) 
/
insert into HtmlLabelInfo values(15533,'重要',7) 
/
insert into HtmlLabelInfo values(15533,'',8) 
/
insert into HtmlLabelInfo values(15534,'紧急程度',7) 
/
insert into HtmlLabelInfo values(15534,'',8) 
/
insert into HtmlLabelInfo values(15535,'没有相关工作流',7) 
/
insert into HtmlLabelInfo values(15535,'',8) 
/
insert into HtmlLabelInfo values(15536,'节点类型',7) 
/
insert into HtmlLabelInfo values(15536,'',8) 
/
insert into HtmlLabelInfo values(15537,'今天',7) 
/
insert into HtmlLabelInfo values(15537,'',8) 
/
insert into HtmlLabelInfo values(15538,'最后24小时',7) 
/
insert into HtmlLabelInfo values(15538,'',8) 
/
insert into HtmlLabelInfo values(15539,'本周',7) 
/
insert into HtmlLabelInfo values(15539,'',8) 
/
insert into HtmlLabelInfo values(15540,'最后日期',7) 
/
insert into HtmlLabelInfo values(15540,'',8) 
/
insert into HtmlLabelInfo values(15541,'本月',7) 
/
insert into HtmlLabelInfo values(15541,'',8) 
/
insert into HtmlLabelInfo values(15542,'本年度',7) 
/
insert into HtmlLabelInfo values(15542,'',8) 
/
insert into HtmlLabelInfo values(15543,'请先选择需要删除的信息',7) 
/
insert into HtmlLabelInfo values(15543,'',8) 
/
insert into HtmlLabelInfo values(15544,'操作者组',7) 
/
insert into HtmlLabelInfo values(15544,'',8) 
/
insert into HtmlLabelInfo values(15545,'操作组名称',7) 
/
insert into HtmlLabelInfo values(15545,'',8) 
/
insert into HtmlLabelInfo values(15546,'类型的节点只能有一个',7) 
/
insert into HtmlLabelInfo values(15546,'',8) 
/
insert into HtmlLabelInfo values(15547,'能否全程跟踪',7) 
/
insert into HtmlLabelInfo values(15547,'',8) 
/
insert into HtmlLabelInfo values(15548,'操作者条件',7) 
/
insert into HtmlLabelInfo values(15548,'',8) 
/
insert into HtmlLabelInfo values(15549,'人力资源字段',7) 
/
insert into HtmlLabelInfo values(15549,'',8) 
/
insert into HtmlLabelInfo values(15550,'文档字段',7) 
/
insert into HtmlLabelInfo values(15550,'',8) 
/
insert into HtmlLabelInfo values(15551,'项目字段',7) 
/
insert into HtmlLabelInfo values(15551,'',8) 
/
insert into HtmlLabelInfo values(15552,'资产字段',7) 
/
insert into HtmlLabelInfo values(15552,'',8) 
/
insert into HtmlLabelInfo values(15553,'客户字段',7) 
/
insert into HtmlLabelInfo values(15553,'',8) 
/
insert into HtmlLabelInfo values(15554,'门户相关',7) 
/
insert into HtmlLabelInfo values(15554,'',8) 
/
insert into HtmlLabelInfo values(15555,'人力资源字段本人',7) 
/
insert into HtmlLabelInfo values(15555,'',8) 
/
insert into HtmlLabelInfo values(15556,'非会签',7) 
/
insert into HtmlLabelInfo values(15556,'',8) 
/
insert into HtmlLabelInfo values(15557,'会签',7) 
/
insert into HtmlLabelInfo values(15557,'',8) 
/
insert into HtmlLabelInfo values(15558,'依次逐个处理',7) 
/
insert into HtmlLabelInfo values(15558,'',8) 
/
insert into HtmlLabelInfo values(15559,'人力资源字段经理',7) 
/
insert into HtmlLabelInfo values(15559,'',8) 
/
insert into HtmlLabelInfo values(15560,'人力资源字段下属',7) 
/
insert into HtmlLabelInfo values(15560,'',8) 
/
insert into HtmlLabelInfo values(15561,'人力资源字段本分部',7) 
/
insert into HtmlLabelInfo values(15561,'',8) 
/
insert into HtmlLabelInfo values(15562,'人力资源字段本部门',7) 
/
insert into HtmlLabelInfo values(15562,'',8) 
/
insert into HtmlLabelInfo values(15563,'人力资源字段上级部门',7) 
/
insert into HtmlLabelInfo values(15563,'',8) 
/
insert into HtmlLabelInfo values(15564,'文档字段所有者',7) 
/
insert into HtmlLabelInfo values(15564,'',8) 
/
insert into HtmlLabelInfo values(15565,'文档字段分部',7) 
/
insert into HtmlLabelInfo values(15565,'',8) 
/
insert into HtmlLabelInfo values(15566,'文档字段部门',7) 
/
insert into HtmlLabelInfo values(15566,'',8) 
/
insert into HtmlLabelInfo values(15567,'项目字段经理',7) 
/
insert into HtmlLabelInfo values(15567,'',8) 
/
insert into HtmlLabelInfo values(15568,'项目字段分部',7) 
/
insert into HtmlLabelInfo values(15568,'',8) 
/
insert into HtmlLabelInfo values(15569,'项目字段部门',7) 
/
insert into HtmlLabelInfo values(15569,'',8) 
/
insert into HtmlLabelInfo values(15570,'项目字段成员',7) 
/
insert into HtmlLabelInfo values(15570,'',8) 
/
insert into HtmlLabelInfo values(15571,'资产字段管理员',7) 
/
insert into HtmlLabelInfo values(15571,'',8) 
/
insert into HtmlLabelInfo values(15572,'资产字段分部',7) 
/
insert into HtmlLabelInfo values(15572,'',8) 
/
insert into HtmlLabelInfo values(15573,'资产字段部门',7) 
/
insert into HtmlLabelInfo values(15573,'',8) 
/
insert into HtmlLabelInfo values(15574,'客户字段经理',7) 
/
insert into HtmlLabelInfo values(15574,'',8) 
/
insert into HtmlLabelInfo values(15575,'客户字段联系人经理',7) 
/
insert into HtmlLabelInfo values(15575,'',8) 
/
insert into HtmlLabelInfo values(15576,'创建人下属',7) 
/
insert into HtmlLabelInfo values(15576,'',8) 
/
insert into HtmlLabelInfo values(15577,'创建人本分部',7) 
/
insert into HtmlLabelInfo values(15577,'',8) 
/
insert into HtmlLabelInfo values(15578,'创建人上级部门',7) 
/
insert into HtmlLabelInfo values(15578,'',8) 
/
insert into HtmlLabelInfo values(15579,'客户部门',7) 
/
insert into HtmlLabelInfo values(15579,'',8) 
/
insert into HtmlLabelInfo values(15580,'客户字段本人',7) 
/
insert into HtmlLabelInfo values(15580,'',8) 
/
insert into HtmlLabelInfo values(15581,'所有客户',7) 
/
insert into HtmlLabelInfo values(15581,'',8) 
/
insert into HtmlLabelInfo values(15582,'添加条件',7) 
/
insert into HtmlLabelInfo values(15582,'',8) 
/
insert into HtmlLabelInfo values(15583,'删除条件',7) 
/
insert into HtmlLabelInfo values(15583,'',8) 
/
insert into HtmlLabelInfo values(15584,'请先选择操作对象的值',7) 
/
insert into HtmlLabelInfo values(15584,'',8) 
/
insert into HtmlLabelInfo values(15585,'不会签',7) 
/
insert into HtmlLabelInfo values(15585,'',8) 
/
insert into HtmlLabelInfo values(15586,'节点',7) 
/
insert into HtmlLabelInfo values(15586,'',8) 
/
insert into HtmlLabelInfo values(15587,'出口',7) 
/
insert into HtmlLabelInfo values(15587,'',8) 
/
insert into HtmlLabelInfo values(15588,'是否门户相关',7) 
/
insert into HtmlLabelInfo values(15588,'',8) 
/
insert into HtmlLabelInfo values(15589,'非门户相关',7) 
/
insert into HtmlLabelInfo values(15589,'',8) 
/
insert into HtmlLabelInfo values(15590,'单据',7) 
/
insert into HtmlLabelInfo values(15590,'',8) 
/
insert into HtmlLabelInfo values(15591,'是否有效',7) 
/
insert into HtmlLabelInfo values(15591,'',8) 
/
insert into HtmlLabelInfo values(15592,'是否编号',7) 
/
insert into HtmlLabelInfo values(15592,'',8) 
/
insert into HtmlLabelInfo values(15593,'帮组文档',7) 
/
insert into HtmlLabelInfo values(15593,'',8) 
/
insert into HtmlLabelInfo values(15594,'工作流描述',7) 
/
insert into HtmlLabelInfo values(15594,'',8) 
/
insert into HtmlLabelInfo values(15595,'类型的节点有且只能有一个',7) 
/
insert into HtmlLabelInfo values(15595,'',8) 
/
insert into HtmlLabelInfo values(15596,'工作流节点',7) 
/
insert into HtmlLabelInfo values(15596,'',8) 
/
insert into HtmlLabelInfo values(15597,'请选择节点类型',7) 
/
insert into HtmlLabelInfo values(15597,'',8) 
/
insert into HtmlLabelInfo values(15598,'添加节点',7) 
/
insert into HtmlLabelInfo values(15598,'',8) 
/
insert into HtmlLabelInfo values(15599,'删除节点',7) 
/
insert into HtmlLabelInfo values(15599,'',8) 
/
insert into HtmlLabelInfo values(15600,'对应表单',7) 
/
insert into HtmlLabelInfo values(15600,'',8) 
/
insert into HtmlLabelInfo values(15601,'字段信息',7) 
/
insert into HtmlLabelInfo values(15601,'',8) 
/
insert into HtmlLabelInfo values(15602,'请选择当前节点',7) 
/
insert into HtmlLabelInfo values(15602,'',8) 
/
insert into HtmlLabelInfo values(15603,'是否显示',7) 
/
insert into HtmlLabelInfo values(15603,'',8) 
/
insert into HtmlLabelInfo values(15604,'是否可编辑',7) 
/
insert into HtmlLabelInfo values(15604,'',8) 
/
insert into HtmlLabelInfo values(15605,'是否必须输入',7) 
/
insert into HtmlLabelInfo values(15605,'',8) 
/
insert into HtmlLabelInfo values(15606,'出口信息',7) 
/
insert into HtmlLabelInfo values(15606,'',8) 
/
insert into HtmlLabelInfo values(15607,'添加出口',7) 
/
insert into HtmlLabelInfo values(15607,'',8) 
/
insert into HtmlLabelInfo values(15608,'删除出口',7) 
/
insert into HtmlLabelInfo values(15608,'',8) 
/
insert into HtmlLabelInfo values(15609,'是否reject',7) 
/
insert into HtmlLabelInfo values(15609,'',8) 
/
insert into HtmlLabelInfo values(15610,'附加规则',7) 
/
insert into HtmlLabelInfo values(15610,'',8) 
/
insert into HtmlLabelInfo values(15611,'出口名称',7) 
/
insert into HtmlLabelInfo values(15611,'',8) 
/
insert into HtmlLabelInfo values(15612,'请选择目标节点',7) 
/
insert into HtmlLabelInfo values(15612,'',8) 
/
insert into HtmlLabelInfo values(15613,'请先保存新插入的节点出口',7) 
/
insert into HtmlLabelInfo values(15613,'',8) 
/
insert into HtmlLabelInfo values(15614,'此网页使用了框架，但您的浏览器不支持框架。',7) 
/
insert into HtmlLabelInfo values(15614,'',8) 
/
insert into HtmlLabelInfo values(15615,'节点信息',7) 
/
insert into HtmlLabelInfo values(15615,'',8) 
/
insert into HtmlLabelInfo values(15616,'附加操作',7) 
/
insert into HtmlLabelInfo values(15616,'',8) 
/
insert into HtmlLabelInfo values(15617,'删除工作流将删除该工作流下的所有请求,并可能导致系统中相关这些请求的链接出现错误!',7) 
/
insert into HtmlLabelInfo values(15617,'',8) 
/
insert into HtmlLabelInfo values(15618,'第一字段',7) 
/
insert into HtmlLabelInfo values(15618,'',8) 
/
insert into HtmlLabelInfo values(15619,'第二字段',7) 
/
insert into HtmlLabelInfo values(15619,'',8) 
/
insert into HtmlLabelInfo values(15620,'目标字段',7) 
/
insert into HtmlLabelInfo values(15620,'',8) 
/
insert into HtmlLabelInfo values(15621,'加',7) 
/
insert into HtmlLabelInfo values(15621,'',8) 
/
insert into HtmlLabelInfo values(15622,'减',7) 
/
insert into HtmlLabelInfo values(15622,'',8) 
/
insert into HtmlLabelInfo values(15623,'乘',7) 
/
insert into HtmlLabelInfo values(15623,'',8) 
/
insert into HtmlLabelInfo values(15624,'除',7) 
/
insert into HtmlLabelInfo values(15624,'',8) 
/
insert into HtmlLabelInfo values(15625,'当前日期',7) 
/
insert into HtmlLabelInfo values(15625,'',8) 
/
insert into HtmlLabelInfo values(15626,'当前时间',7) 
/
insert into HtmlLabelInfo values(15626,'',8) 
/
insert into HtmlLabelInfo values(15627,'临时时间变量',7) 
/
insert into HtmlLabelInfo values(15627,'',8) 
/
insert into HtmlLabelInfo values(15628,'临时日期变量',7) 
/
insert into HtmlLabelInfo values(15628,'',8) 
/
insert into HtmlLabelInfo values(15629,'临时文本变量',7) 
/
insert into HtmlLabelInfo values(15629,'',8) 
/
insert into HtmlLabelInfo values(15630,'临时整型变量',7) 
/
insert into HtmlLabelInfo values(15630,'',8) 
/
insert into HtmlLabelInfo values(15631,'临时浮点型变量',7) 
/
insert into HtmlLabelInfo values(15631,'',8) 
/
insert into HtmlLabelInfo values(15632,'自定义值',7) 
/
insert into HtmlLabelInfo values(15632,'',8) 
/
insert into HtmlLabelInfo values(15633,'是否跳过周末',7) 
/
insert into HtmlLabelInfo values(15633,'',8) 
/
insert into HtmlLabelInfo values(15634,'是否跳过公共假日',7) 
/
insert into HtmlLabelInfo values(15634,'',8) 
/
insert into HtmlLabelInfo values(15635,'运算法则',7) 
/
insert into HtmlLabelInfo values(15635,'',8) 
/
insert into HtmlLabelInfo values(15636,'表达式',7) 
/
insert into HtmlLabelInfo values(15636,'',8) 
/
insert into HtmlLabelInfo values(15637,'附件规则',7) 
/
insert into HtmlLabelInfo values(15637,'',8) 
/
insert into HtmlLabelInfo values(15638,'跳过周末',7) 
/
insert into HtmlLabelInfo values(15638,'',8) 
/
insert into HtmlLabelInfo values(15639,'跳过公共假日',7) 
/
insert into HtmlLabelInfo values(15639,'',8) 
/
insert into HtmlLabelInfo values(15640,'请先选择第一个字段',7) 
/
insert into HtmlLabelInfo values(15640,'',8) 
/
insert into HtmlLabelInfo values(15641,'请先选择操作符号',7) 
/
insert into HtmlLabelInfo values(15641,'',8) 
/
insert into HtmlLabelInfo values(15642,'目标字段不能为空',7) 
/
insert into HtmlLabelInfo values(15642,'',8) 
/
insert into HtmlLabelInfo values(15643,'整数类型不匹配',7) 
/
insert into HtmlLabelInfo values(15643,'',8) 
/
insert into HtmlLabelInfo values(15644,'浮点数类型不匹配',7) 
/
insert into HtmlLabelInfo values(15644,'',8) 
/
insert into HtmlLabelInfo values(15645,'日期类型不匹配',7) 
/
insert into HtmlLabelInfo values(15645,'',8) 
/
insert into HtmlLabelInfo values(15646,'时间类型不匹配',7) 
/
insert into HtmlLabelInfo values(15646,'',8) 
/
insert into HtmlLabelInfo values(15647,'被考核人信息',7) 
/
insert into HtmlLabelInfo values(15647,'',8) 
/
insert into HtmlLabelInfo values(15648,'被考核人',7) 
/
insert into HtmlLabelInfo values(15648,'',8) 
/
insert into HtmlLabelInfo values(15649,'总成绩',7) 
/
insert into HtmlLabelInfo values(15649,'',8) 
/
insert into HtmlLabelInfo values(15650,'总考核人',7) 
/
insert into HtmlLabelInfo values(15650,'',8) 
/
insert into HtmlLabelInfo values(15651,'已考核人',7) 
/
insert into HtmlLabelInfo values(15651,'',8) 
/
insert into HtmlLabelInfo values(15652,'当前考核',7) 
/
insert into HtmlLabelInfo values(15652,'',8) 
/
insert into HtmlLabelInfo values(15653,'考核名称',7) 
/
insert into HtmlLabelInfo values(15653,'',8) 
/
insert into HtmlLabelInfo values(15654,'总的被考核人',7) 
/
insert into HtmlLabelInfo values(15654,'',8) 
/
insert into HtmlLabelInfo values(15655,'总的考核人',7) 
/
insert into HtmlLabelInfo values(15655,'',8) 
/
insert into HtmlLabelInfo values(15656,'已完成考核',7) 
/
insert into HtmlLabelInfo values(15656,'',8) 
/
insert into HtmlLabelInfo values(15657,'成绩',7) 
/
insert into HtmlLabelInfo values(15657,'',8) 
/
insert into HtmlLabelInfo values(15658,'优良',7) 
/
insert into HtmlLabelInfo values(15658,'',8) 
/
insert into HtmlLabelInfo values(15659,'合格',7) 
/
insert into HtmlLabelInfo values(15659,'',8) 
/
insert into HtmlLabelInfo values(15660,'差',7) 
/
insert into HtmlLabelInfo values(15660,'',8) 
/
insert into HtmlLabelInfo values(15661,'极差',7) 
/
insert into HtmlLabelInfo values(15661,'',8) 
/
insert into HtmlLabelInfo values(15662,'考核人',7) 
/
insert into HtmlLabelInfo values(15662,'',8) 
/
insert into HtmlLabelInfo values(15663,'总分',7) 
/
insert into HtmlLabelInfo values(15663,'',8) 
/
insert into HtmlLabelInfo values(15664,'奖惩人员',7) 
/
insert into HtmlLabelInfo values(15664,'',8) 
/
insert into HtmlLabelInfo values(15665,'奖惩标题',7) 
/
insert into HtmlLabelInfo values(15665,'',8) 
/
insert into HtmlLabelInfo values(15666,'奖惩名称',7) 
/
insert into HtmlLabelInfo values(15666,'',8) 
/
insert into HtmlLabelInfo values(15667,'适用情况',7) 
/
insert into HtmlLabelInfo values(15667,'',8) 
/
insert into HtmlLabelInfo values(15668,'招聘日期',7) 
/
insert into HtmlLabelInfo values(15668,'',8) 
/
insert into HtmlLabelInfo values(15669,'通知人',7) 
/
insert into HtmlLabelInfo values(15669,'',8) 
/
insert into HtmlLabelInfo values(15670,'新员工入职设置',7) 
/
insert into HtmlLabelInfo values(15670,'',8) 
/
insert into HtmlLabelInfo values(15671,'应聘岗位',7) 
/
insert into HtmlLabelInfo values(15671,'',8) 
/
insert into HtmlLabelInfo values(15672,'曾任岗位',7) 
/
insert into HtmlLabelInfo values(15672,'',8) 
/
insert into HtmlLabelInfo values(15673,'年薪低限',7) 
/
insert into HtmlLabelInfo values(15673,'',8) 
/
insert into HtmlLabelInfo values(15674,'体重',7) 
/
insert into HtmlLabelInfo values(15674,'',8) 
/
insert into HtmlLabelInfo values(15675,'应聘者类别',7) 
/
insert into HtmlLabelInfo values(15675,'',8) 
/
insert into HtmlLabelInfo values(15676,'离开原因',7) 
/
insert into HtmlLabelInfo values(15676,'',8) 
/
insert into HtmlLabelInfo values(15677,'培训情况',7) 
/
insert into HtmlLabelInfo values(15677,'',8) 
/
insert into HtmlLabelInfo values(15678,'培训名称',7) 
/
insert into HtmlLabelInfo values(15678,'',8) 
/
insert into HtmlLabelInfo values(15679,'培训开始日期',7) 
/
insert into HtmlLabelInfo values(15679,'',8) 
/
insert into HtmlLabelInfo values(15680,'培训结束日期',7) 
/
insert into HtmlLabelInfo values(15680,'',8) 
/
insert into HtmlLabelInfo values(15681,'颁发单位',7) 
/
insert into HtmlLabelInfo values(15681,'',8) 
/
insert into HtmlLabelInfo values(15682,'奖惩情况',7) 
/
insert into HtmlLabelInfo values(15682,'',8) 
/
insert into HtmlLabelInfo values(15683,'户口',7) 
/
insert into HtmlLabelInfo values(15683,'',8) 
/
insert into HtmlLabelInfo values(15684,'工会会员',7) 
/
insert into HtmlLabelInfo values(15684,'',8) 
/
insert into HtmlLabelInfo values(15685,'暂住证号码',7) 
/
insert into HtmlLabelInfo values(15685,'',8) 
/
insert into HtmlLabelInfo values(15686,'家庭状况',7) 
/
insert into HtmlLabelInfo values(15686,'',8) 
/
insert into HtmlLabelInfo values(15687,'个人信息',7) 
/
insert into HtmlLabelInfo values(15687,'',8) 
/
insert into HtmlLabelInfo values(15688,'工作信息',7) 
/
insert into HtmlLabelInfo values(15688,'',8) 
/
insert into HtmlLabelInfo values(15689,'备用',7) 
/
insert into HtmlLabelInfo values(15689,'',8) 
/
insert into HtmlLabelInfo values(15690,'淘汰',7) 
/
insert into HtmlLabelInfo values(15690,'',8) 
/
insert into HtmlLabelInfo values(15691,'邮件通知',7) 
/
insert into HtmlLabelInfo values(15691,'',8) 
/
insert into HtmlLabelInfo values(15692,'招聘信息发布时间',7) 
/
insert into HtmlLabelInfo values(15692,'',8) 
/
insert into HtmlLabelInfo values(15693,'已有考评',7) 
/
insert into HtmlLabelInfo values(15693,'',8) 
/
insert into HtmlLabelInfo values(15694,'步骤名称',7) 
/
insert into HtmlLabelInfo values(15694,'',8) 
/
insert into HtmlLabelInfo values(15695,'考评人',7) 
/
insert into HtmlLabelInfo values(15695,'',8) 
/
insert into HtmlLabelInfo values(15696,'考评日期',7) 
/
insert into HtmlLabelInfo values(15696,'',8) 
/
insert into HtmlLabelInfo values(15697,'考评结果',7) 
/
insert into HtmlLabelInfo values(15697,'',8) 
/
insert into HtmlLabelInfo values(15698,'评语',7) 
/
insert into HtmlLabelInfo values(15698,'',8) 
/
insert into HtmlLabelInfo values(15699,'不合格',7) 
/
insert into HtmlLabelInfo values(15699,'',8) 
/
insert into HtmlLabelInfo values(15700,'好',7) 
/
insert into HtmlLabelInfo values(15700,'',8) 
/
insert into HtmlLabelInfo values(15701,'已有考核',7) 
/
insert into HtmlLabelInfo values(15701,'',8) 
/
insert into HtmlLabelInfo values(15702,'考核日期',7) 
/
insert into HtmlLabelInfo values(15702,'',8) 
/
insert into HtmlLabelInfo values(15703,'考核结果',7) 
/
insert into HtmlLabelInfo values(15703,'',8) 
/
insert into HtmlLabelInfo values(15704,'备份',7) 
/
insert into HtmlLabelInfo values(15704,'',8) 
/
insert into HtmlLabelInfo values(15705,'是否已通知',7) 
/
insert into HtmlLabelInfo values(15705,'',8) 
/
insert into HtmlLabelInfo values(15706,'未考核',7) 
/
insert into HtmlLabelInfo values(15706,'',8) 
/
insert into HtmlLabelInfo values(15707,'照片',7) 
/
insert into HtmlLabelInfo values(15707,'',8) 
/
insert into HtmlLabelInfo values(15708,'职责描述',7) 
/
insert into HtmlLabelInfo values(15708,'',8) 
/
insert into HtmlLabelInfo values(15709,'直接上级',7) 
/
insert into HtmlLabelInfo values(15709,'',8) 
/
insert into HtmlLabelInfo values(15710,'试用',7) 
/
insert into HtmlLabelInfo values(15710,'',8) 
/
insert into HtmlLabelInfo values(15711,'正式',7) 
/
insert into HtmlLabelInfo values(15711,'',8) 
/
insert into HtmlLabelInfo values(15712,'办公地点',7) 
/
insert into HtmlLabelInfo values(15712,'',8) 
/
insert into HtmlLabelInfo values(15713,'办公电话',7) 
/
insert into HtmlLabelInfo values(15713,'',8) 
/
insert into HtmlLabelInfo values(15714,'其他电话',7) 
/
insert into HtmlLabelInfo values(15714,'',8) 
/
insert into HtmlLabelInfo values(15715,'水平',7) 
/
insert into HtmlLabelInfo values(15715,'',8) 
/
insert into HtmlLabelInfo values(15716,'入职前工作简历',7) 
/
insert into HtmlLabelInfo values(15716,'',8) 
/
insert into HtmlLabelInfo values(15717,'入职前培训',7) 
/
insert into HtmlLabelInfo values(15717,'',8) 
/
insert into HtmlLabelInfo values(15718,'入职前奖惩',7) 
/
insert into HtmlLabelInfo values(15718,'',8) 
/
insert into HtmlLabelInfo values(15719,'网上发布',7) 
/
insert into HtmlLabelInfo values(15719,'',8) 
/
insert into HtmlLabelInfo values(15720,'招聘日程',7) 
/
insert into HtmlLabelInfo values(15720,'',8) 
/
insert into HtmlLabelInfo values(15721,'审核人',7) 
/
insert into HtmlLabelInfo values(15721,'',8) 
/
insert into HtmlLabelInfo values(15722,'审核开始日期',7) 
/
insert into HtmlLabelInfo values(15722,'',8) 
/
insert into HtmlLabelInfo values(15723,'审核结束日期',7) 
/
insert into HtmlLabelInfo values(15723,'',8) 
/
insert into HtmlLabelInfo values(15724,'通知日期',7) 
/
insert into HtmlLabelInfo values(15724,'',8) 
/
insert into HtmlLabelInfo values(15725,'通知考核',7) 
/
insert into HtmlLabelInfo values(15725,'',8) 
/
insert into HtmlLabelInfo values(15726,'确定要通知审核人吗?',7) 
/
insert into HtmlLabelInfo values(15726,'',8) 
/
insert into HtmlLabelInfo values(15727,'面试考核通知',7) 
/
insert into HtmlLabelInfo values(15727,'',8) 
/
insert into HtmlLabelInfo values(15728,'总结建议',7) 
/
insert into HtmlLabelInfo values(15728,'',8) 
/
insert into HtmlLabelInfo values(15729,'具体信息',7) 
/
insert into HtmlLabelInfo values(15729,'',8) 
/
insert into HtmlLabelInfo values(15730,'被考评者',7) 
/
insert into HtmlLabelInfo values(15730,'',8) 
/
insert into HtmlLabelInfo values(15731,'面试步骤',7) 
/
insert into HtmlLabelInfo values(15731,'',8) 
/
insert into HtmlLabelInfo values(15732,'被面试者',7) 
/
insert into HtmlLabelInfo values(15732,'',8) 
/
insert into HtmlLabelInfo values(15733,'面试日期',7) 
/
insert into HtmlLabelInfo values(15733,'',8) 
/
insert into HtmlLabelInfo values(15734,'面试时间',7) 
/
insert into HtmlLabelInfo values(15734,'',8) 
/
insert into HtmlLabelInfo values(15735,'面试地点',7) 
/
insert into HtmlLabelInfo values(15735,'',8) 
/
insert into HtmlLabelInfo values(15736,'注意事项',7) 
/
insert into HtmlLabelInfo values(15736,'',8) 
/
insert into HtmlLabelInfo values(15737,'面试结果',7) 
/
insert into HtmlLabelInfo values(15737,'',8) 
/
insert into HtmlLabelInfo values(15738,'考评情况',7) 
/
insert into HtmlLabelInfo values(15738,'',8) 
/
insert into HtmlLabelInfo values(15739,'考评者',7) 
/
insert into HtmlLabelInfo values(15739,'',8) 
/
insert into HtmlLabelInfo values(15740,'确定要淘汰吗？',7) 
/
insert into HtmlLabelInfo values(15740,'',8) 
/
insert into HtmlLabelInfo values(15741,'确定要通过吗？',7) 
/
insert into HtmlLabelInfo values(15741,'',8) 
/
insert into HtmlLabelInfo values(15742,'确定要转入备用库吗？',7) 
/
insert into HtmlLabelInfo values(15742,'',8) 
/
insert into HtmlLabelInfo values(15743,'招聘负责通知',7) 
/
insert into HtmlLabelInfo values(15743,'',8) 
/
insert into HtmlLabelInfo values(15744,'招聘时间',7) 
/
insert into HtmlLabelInfo values(15744,'',8) 
/
insert into HtmlLabelInfo values(15745,'招聘步骤',7) 
/
insert into HtmlLabelInfo values(15745,'',8) 
/
insert into HtmlLabelInfo values(15746,'未处理',7) 
/
insert into HtmlLabelInfo values(15746,'',8) 
/
insert into HtmlLabelInfo values(15747,'正在招聘',7) 
/
insert into HtmlLabelInfo values(15747,'',8) 
/
insert into HtmlLabelInfo values(15748,'已满足',7) 
/
insert into HtmlLabelInfo values(15748,'',8) 
/
insert into HtmlLabelInfo values(15749,'无用',7) 
/
insert into HtmlLabelInfo values(15749,'',8) 
/
insert into HtmlLabelInfo values(15750,'失效',7) 
/
insert into HtmlLabelInfo values(15750,'',8) 
/
insert into HtmlLabelInfo values(15751,'确定要关闭吗？',7) 
/
insert into HtmlLabelInfo values(15751,'',8) 
/
insert into HtmlLabelInfo values(15752,'考核说明',7) 
/
insert into HtmlLabelInfo values(15752,'',8) 
/
insert into HtmlLabelInfo values(15753,'考核项名称',7) 
/
insert into HtmlLabelInfo values(15753,'',8) 
/
insert into HtmlLabelInfo values(15754,'考核项说明',7) 
/
insert into HtmlLabelInfo values(15754,'',8) 
/
insert into HtmlLabelInfo values(15755,'考核种类名称',7) 
/
insert into HtmlLabelInfo values(15755,'',8) 
/
insert into HtmlLabelInfo values(15756,'考核周期',7) 
/
insert into HtmlLabelInfo values(15756,'',8) 
/
insert into HtmlLabelInfo values(15757,'考核期',7) 
/
insert into HtmlLabelInfo values(15757,'',8) 
/
insert into HtmlLabelInfo values(15758,'考核开始日期',7) 
/
insert into HtmlLabelInfo values(15758,'',8) 
/
insert into HtmlLabelInfo values(15759,'考核资料',7) 
/
insert into HtmlLabelInfo values(15759,'',8) 
/
insert into HtmlLabelInfo values(15760,'考核参与人',7) 
/
insert into HtmlLabelInfo values(15760,'',8) 
/
insert into HtmlLabelInfo values(15761,'参与人',7) 
/
insert into HtmlLabelInfo values(15761,'',8) 
/
insert into HtmlLabelInfo values(15762,'所有上级',7) 
/
insert into HtmlLabelInfo values(15762,'',8) 
/
insert into HtmlLabelInfo values(15763,'本人',7) 
/
insert into HtmlLabelInfo values(15763,'',8) 
/
insert into HtmlLabelInfo values(15764,'直接下级',7) 
/
insert into HtmlLabelInfo values(15764,'',8) 
/
insert into HtmlLabelInfo values(15765,'所有下级',7) 
/
insert into HtmlLabelInfo values(15765,'',8) 
/
insert into HtmlLabelInfo values(15766,'本部门其他人',7) 
/
insert into HtmlLabelInfo values(15766,'',8) 
/
insert into HtmlLabelInfo values(15767,'全称',7) 
/
insert into HtmlLabelInfo values(15767,'',8) 
/
insert into HtmlLabelInfo values(15768,'公司网站',7) 
/
insert into HtmlLabelInfo values(15768,'',8) 
/
insert into HtmlLabelInfo values(15769,'所属分成本中心',7) 
/
insert into HtmlLabelInfo values(15769,'',8) 
/
insert into HtmlLabelInfo values(15770,'新建成本中心',7) 
/
insert into HtmlLabelInfo values(15770,'',8) 
/
insert into HtmlLabelInfo values(15771,'定制部门结构图布局',7) 
/
insert into HtmlLabelInfo values(15771,'',8) 
/
insert into HtmlLabelInfo values(15772,'上级部门',7) 
/
insert into HtmlLabelInfo values(15772,'',8) 
/
insert into HtmlLabelInfo values(15773,'上级部门不能为本部门!',7) 
/
insert into HtmlLabelInfo values(15773,'',8) 
/
insert into HtmlLabelInfo values(15774,'搜索条件',7) 
/
insert into HtmlLabelInfo values(15774,'',8) 
/
insert into HtmlLabelInfo values(15775,'合同类型',7) 
/
insert into HtmlLabelInfo values(15775,'',8) 
/
insert into HtmlLabelInfo values(15776,'合同人',7) 
/
insert into HtmlLabelInfo values(15776,'',8) 
/
insert into HtmlLabelInfo values(15777,'合同起止日期',7) 
/
insert into HtmlLabelInfo values(15777,'',8) 
/
insert into HtmlLabelInfo values(15778,'试用期结束日期',7) 
/
insert into HtmlLabelInfo values(15778,'',8) 
/
insert into HtmlLabelInfo values(15779,'请输入合同人！！',7) 
/
insert into HtmlLabelInfo values(15779,'',8) 
/
insert into HtmlLabelInfo values(15780,'合同类别',7) 
/
insert into HtmlLabelInfo values(15780,'',8) 
/
insert into HtmlLabelInfo values(15781,'通知',7) 
/
insert into HtmlLabelInfo values(15781,'',8) 
/
insert into HtmlLabelInfo values(15782,'确定要通知吗？',7) 
/
insert into HtmlLabelInfo values(15782,'',8) 
/
insert into HtmlLabelInfo values(15783,'人力资源合同到期通知',7) 
/
insert into HtmlLabelInfo values(15783,'',8) 
/
insert into HtmlLabelInfo values(15784,'试用期到期通知',7) 
/
insert into HtmlLabelInfo values(15784,'',8) 
/
insert into HtmlLabelInfo values(15785,'选择合同类别',7) 
/
insert into HtmlLabelInfo values(15785,'',8) 
/
insert into HtmlLabelInfo values(15786,'合同模板',7) 
/
insert into HtmlLabelInfo values(15786,'',8) 
/
insert into HtmlLabelInfo values(15787,'存放目录',7) 
/
insert into HtmlLabelInfo values(15787,'',8) 
/
insert into HtmlLabelInfo values(15788,'入职合同',7) 
/
insert into HtmlLabelInfo values(15788,'',8) 
/
insert into HtmlLabelInfo values(15789,'到期提前提醒期',7) 
/
insert into HtmlLabelInfo values(15789,'',8) 
/
insert into HtmlLabelInfo values(16445,'版本序列号',7) 
/
insert into HtmlLabelInfo values(15791,'是否为入职合同',7) 
/
insert into HtmlLabelInfo values(15791,'',8) 
/
insert into HtmlLabelInfo values(15792,'提醒提前天数',7) 
/
insert into HtmlLabelInfo values(15792,'',8) 
/
insert into HtmlLabelInfo values(15793,'提醒人',7) 
/
insert into HtmlLabelInfo values(15793,'',8) 
/
insert into HtmlLabelInfo values(15794,'请输入合同模板',7) 
/
insert into HtmlLabelInfo values(15794,'',8) 
/
insert into HtmlLabelInfo values(15795,'类型名称',7) 
/
insert into HtmlLabelInfo values(15795,'',8) 
/
insert into HtmlLabelInfo values(15796,'查看新员工',7) 
/
insert into HtmlLabelInfo values(15796,'',8) 
/
insert into HtmlLabelInfo values(15797,'到职日期',7) 
/
insert into HtmlLabelInfo values(15797,'',8) 
/
insert into HtmlLabelInfo values(15798,'个人入职设定',7) 
/
insert into HtmlLabelInfo values(15798,'',8) 
/
insert into HtmlLabelInfo values(15799,'邮件帐户',7) 
/
insert into HtmlLabelInfo values(15799,'',8) 
/
insert into HtmlLabelInfo values(15800,'一卡通',7) 
/
insert into HtmlLabelInfo values(15800,'',8) 
/
insert into HtmlLabelInfo values(15801,'座位号',7) 
/
insert into HtmlLabelInfo values(15801,'',8) 
/
insert into HtmlLabelInfo values(15802,'分机直线',7) 
/
insert into HtmlLabelInfo values(15802,'',8) 
/
insert into HtmlLabelInfo values(15803,'密码与确认密码不符合',7) 
/
insert into HtmlLabelInfo values(15803,'',8) 
/
insert into HtmlLabelInfo values(15804,'系统信息',7) 
/
insert into HtmlLabelInfo values(15804,'',8) 
/
insert into HtmlLabelInfo values(15805,'财务信息',7) 
/
insert into HtmlLabelInfo values(15805,'',8) 
/
insert into HtmlLabelInfo values(15806,'资产信息',7) 
/
insert into HtmlLabelInfo values(15806,'',8) 
/
insert into HtmlLabelInfo values(15807,'任务监控人员',7) 
/
insert into HtmlLabelInfo values(15807,'',8) 
/
insert into HtmlLabelInfo values(15808,'未设置',7) 
/
insert into HtmlLabelInfo values(15808,'',8) 
/
insert into HtmlLabelInfo values(15809,'已设置',7) 
/
insert into HtmlLabelInfo values(15809,'',8) 
/
insert into HtmlLabelInfo values(15810,'确定要完成新员工设置吗？',7) 
/
insert into HtmlLabelInfo values(15810,'',8) 
/
insert into HtmlLabelInfo values(15811,'有一些设置没有完成，确定要强制完成新员工设置吗？',7) 
/
insert into HtmlLabelInfo values(15811,'',8) 
/
insert into HtmlLabelInfo values(15812,'工资银行',7) 
/
insert into HtmlLabelInfo values(15812,'',8) 
/
insert into HtmlLabelInfo values(15813,'有人力资源工资帐户使用该银行,该银行不能删除',7) 
/
insert into HtmlLabelInfo values(15813,'',8) 
/
insert into HtmlLabelInfo values(15814,'薪酬调整',7) 
/
insert into HtmlLabelInfo values(15814,'',8) 
/
insert into HtmlLabelInfo values(15815,'工资项目',7) 
/
insert into HtmlLabelInfo values(15815,'',8) 
/
insert into HtmlLabelInfo values(15816,'改变为',7) 
/
insert into HtmlLabelInfo values(15816,'',8) 
/
insert into HtmlLabelInfo values(15817,'调整历史',7) 
/
insert into HtmlLabelInfo values(15817,'',8) 
/
insert into HtmlLabelInfo values(15818,'被调整人',7) 
/
insert into HtmlLabelInfo values(15818,'',8) 
/
insert into HtmlLabelInfo values(15819,'调整项目',7) 
/
insert into HtmlLabelInfo values(15819,'',8) 
/
insert into HtmlLabelInfo values(15820,'调整日期',7) 
/
insert into HtmlLabelInfo values(15820,'',8) 
/
insert into HtmlLabelInfo values(15821,'调整类型',7) 
/
insert into HtmlLabelInfo values(15821,'',8) 
/
insert into HtmlLabelInfo values(15822,'调整薪酬',7) 
/
insert into HtmlLabelInfo values(15822,'',8) 
/
insert into HtmlLabelInfo values(15823,'调整人',7) 
/
insert into HtmlLabelInfo values(15823,'',8) 
/
insert into HtmlLabelInfo values(15824,'工资表显示',7) 
/
insert into HtmlLabelInfo values(15824,'',8) 
/
insert into HtmlLabelInfo values(15825,'福利',7) 
/
insert into HtmlLabelInfo values(15825,'',8) 
/
insert into HtmlLabelInfo values(15826,'税收',7) 
/
insert into HtmlLabelInfo values(15826,'',8) 
/
insert into HtmlLabelInfo values(15827,'税收基准项目',7) 
/
insert into HtmlLabelInfo values(15827,'',8) 
/
insert into HtmlLabelInfo values(15828,'计算公式',7) 
/
insert into HtmlLabelInfo values(15828,'',8) 
/
insert into HtmlLabelInfo values(15829,'财务费用类型',7) 
/
insert into HtmlLabelInfo values(15829,'',8) 
/
insert into HtmlLabelInfo values(15830,'注意： 代码只能为英文字母和阿拉伯数值，英文字母大小写敏感！',7) 
/
insert into HtmlLabelInfo values(15830,'',8) 
/
insert into HtmlLabelInfo values(15831,'1、计算公式为其它各项代码的加减乘除表达式。例如，基本工资代码为 S001, 岗位工资的代码为 S002，实发工',7) 
/
insert into HtmlLabelInfo values(15831,'',8) 
/
insert into HtmlLabelInfo values(15831,'1、计算公式为其它各项代码的加减乘除表达式。例如，基本工资代码为 S001, 岗位工资的代码为 S002，实发工',7) 
/
insert into HtmlLabelInfo values(15831,'',8) 
/
insert into HtmlLabelInfo values(15831,'职级从',7) 
/
insert into HtmlLabelInfo values(15831,'',8) 
/
insert into HtmlLabelInfo values(15832,'职级到',7) 
/
insert into HtmlLabelInfo values(15832,'',8) 
/
insert into HtmlLabelInfo values(15833,'费率',7) 
/
insert into HtmlLabelInfo values(15833,'',8) 
/
insert into HtmlLabelInfo values(15834,'税率',7) 
/
insert into HtmlLabelInfo values(15834,'',8) 
/
insert into HtmlLabelInfo values(15835,'税收基数',7) 
/
insert into HtmlLabelInfo values(15835,'',8) 
/
insert into HtmlLabelInfo values(15836,'级数',7) 
/
insert into HtmlLabelInfo values(15836,'',8) 
/
insert into HtmlLabelInfo values(15837,'含税级距(从)',7) 
/
insert into HtmlLabelInfo values(15837,'',8) 
/
insert into HtmlLabelInfo values(15838,'含税级距(到)',7) 
/
insert into HtmlLabelInfo values(15838,'',8) 
/
insert into HtmlLabelInfo values(15839,'批处理',7) 
/
insert into HtmlLabelInfo values(15839,'',8) 
/
insert into HtmlLabelInfo values(15840,'批处理将按照该项设置的规则重新设置人力资源工资表,',7) 
/
insert into HtmlLabelInfo values(15840,'',8) 
/
insert into HtmlLabelInfo values(15841,'以前所做的所有改动都将改变,是否继续',7) 
/
insert into HtmlLabelInfo values(15841,'',8) 
/
insert into HtmlLabelInfo values(15842,'人力资源状态',7) 
/
insert into HtmlLabelInfo values(15842,'',8) 
/
insert into HtmlLabelInfo values(15843,'基准工资',7) 
/
insert into HtmlLabelInfo values(15843,'',8) 
/
insert into HtmlLabelInfo values(15844,'试用延期',7) 
/
insert into HtmlLabelInfo values(15844,'',8) 
/
insert into HtmlLabelInfo values(15845,'生成工资单',7) 
/
insert into HtmlLabelInfo values(15845,'',8) 
/
insert into HtmlLabelInfo values(15846,'重新生成',7) 
/
insert into HtmlLabelInfo values(15846,'',8) 
/
insert into HtmlLabelInfo values(15847,'修改工资单',7) 
/
insert into HtmlLabelInfo values(15847,'',8) 
/
insert into HtmlLabelInfo values(15848,'发送工资单',7) 
/
insert into HtmlLabelInfo values(15848,'',8) 
/
insert into HtmlLabelInfo values(15849,'工资单日期',7) 
/
insert into HtmlLabelInfo values(15849,'',8) 
/
insert into HtmlLabelInfo values(15850,'未生成当前月工资单',7) 
/
insert into HtmlLabelInfo values(15850,'',8) 
/
insert into HtmlLabelInfo values(15851,'重新生成工资单将丢失对该工资单的所有修改信息，是否继续？',7) 
/
insert into HtmlLabelInfo values(15851,'',8) 
/
insert into HtmlLabelInfo values(15852,'工资单发送将使系统人员看到自己该月的工资，是否继续？',7) 
/
insert into HtmlLabelInfo values(15852,'',8) 
/
insert into HtmlLabelInfo values(15853,'是否需要重新计算税收项和计算项？',7) 
/
insert into HtmlLabelInfo values(15853,'',8) 
/
insert into HtmlLabelInfo values(15854,'职务类型',7) 
/
insert into HtmlLabelInfo values(15854,'',8) 
/
insert into HtmlLabelInfo values(15855,'所属职务',7) 
/
insert into HtmlLabelInfo values(15855,'',8) 
/
insert into HtmlLabelInfo values(15856,'岗位职责',7) 
/
insert into HtmlLabelInfo values(15856,'',8) 
/
insert into HtmlLabelInfo values(15857,'邮政编码 /城市',7) 
/
insert into HtmlLabelInfo values(15857,'',8) 
/
insert into HtmlLabelInfo values(15858,'联系方式',7) 
/
insert into HtmlLabelInfo values(15858,'',8) 
/
insert into HtmlLabelInfo values(15859,'必要信息不完整！',7) 
/
insert into HtmlLabelInfo values(15859,'',8) 
/
insert into HtmlLabelInfo values(15860,'年龄区间',7) 
/
insert into HtmlLabelInfo values(15860,'',8) 
/
insert into HtmlLabelInfo values(15861,'总人数',7) 
/
insert into HtmlLabelInfo values(15861,'',8) 
/
insert into HtmlLabelInfo values(15862,'人员年龄统计',7) 
/
insert into HtmlLabelInfo values(15862,'',8) 
/
insert into HtmlLabelInfo values(15863,'空',7) 
/
insert into HtmlLabelInfo values(15863,'',8) 
/
insert into HtmlLabelInfo values(15864,'岁',7) 
/
insert into HtmlLabelInfo values(15864,'',8) 
/
insert into HtmlLabelInfo values(15865,'人员成本中心统计',7) 
/
insert into HtmlLabelInfo values(15865,'',8) 
/
insert into HtmlLabelInfo values(15866,'人员部门统计',7) 
/
insert into HtmlLabelInfo values(15866,'',8) 
/
insert into HtmlLabelInfo values(15867,'人员学历统计',7) 
/
insert into HtmlLabelInfo values(15867,'',8) 
/
insert into HtmlLabelInfo values(15868,'人员职务统计',7) 
/
insert into HtmlLabelInfo values(15868,'',8) 
/
insert into HtmlLabelInfo values(15869,'人员职称统计',7) 
/
insert into HtmlLabelInfo values(15869,'',8) 
/
insert into HtmlLabelInfo values(15870,'人员职务类别统计',7) 
/
insert into HtmlLabelInfo values(15870,'',8) 
/
insert into HtmlLabelInfo values(15871,'职级区间',7) 
/
insert into HtmlLabelInfo values(15871,'',8) 
/
insert into HtmlLabelInfo values(15872,'级',7) 
/
insert into HtmlLabelInfo values(15872,'',8) 
/
insert into HtmlLabelInfo values(15873,'人员职级统计',7) 
/
insert into HtmlLabelInfo values(15873,'',8) 
/
insert into HtmlLabelInfo values(15874,'人员岗位统计',7) 
/
insert into HtmlLabelInfo values(15874,'',8) 
/
insert into HtmlLabelInfo values(15875,'人员婚姻状况统计',7) 
/
insert into HtmlLabelInfo values(15875,'',8) 
/
insert into HtmlLabelInfo values(15876,'任务完成统计',7) 
/
insert into HtmlLabelInfo values(15876,'',8) 
/
insert into HtmlLabelInfo values(15877,'人力资源状况',7) 
/
insert into HtmlLabelInfo values(15877,'',8) 
/
insert into HtmlLabelInfo values(15878,'工龄',7) 
/
insert into HtmlLabelInfo values(15878,'',8) 
/
insert into HtmlLabelInfo values(15879,'培训资源',7) 
/
insert into HtmlLabelInfo values(15879,'',8) 
/
insert into HtmlLabelInfo values(15880,'考勤',7) 
/
insert into HtmlLabelInfo values(15880,'',8) 
/
insert into HtmlLabelInfo values(15881,'会议室使用情况',7) 
/







delete ErrorMsgIndex
/

delete ErrorMsgInfo
/

delete HtmlNoteIndex
/

delete HtmlNoteInfo
/


insert into ErrorMsgIndex values (4,'安全级别') 
/
insert into ErrorMsgIndex values (20,'不能删除') 
/
insert into ErrorMsgIndex values (12,'插入记录失败') 
/
insert into ErrorMsgIndex values (19,'超时，重新登录') 
/
insert into ErrorMsgIndex values (30,'登陆名重复') 
/
insert into ErrorMsgIndex values (18,'登录输入不正确') 
/
insert into ErrorMsgIndex values (25,'登帐不成功') 
/
insert into ErrorMsgIndex values (31,'该编号已被引用') 
/
insert into ErrorMsgIndex values (24,'该科目不能建立下级科目') 
/
insert into ErrorMsgIndex values (28,'该类型不能建立下级类型') 
/
insert into ErrorMsgIndex values (11,'角色删除错误') 
/
insert into ErrorMsgIndex values (22,'借贷不平衡,不能通过审批') 
/
insert into ErrorMsgIndex values (16,'密码错误') 
/
insert into ErrorMsgIndex values (8,'模板删除错误－默认') 
/
insert into ErrorMsgIndex values (9,'模板删除错误－子目录') 
/
insert into ErrorMsgIndex values (10,'目标子目录不能为空') 
/
insert into ErrorMsgIndex values (26,'期间关闭不成功') 
/
insert into ErrorMsgIndex values (21,'期间关闭或不存在（不活跃）,不能操作') 
/
insert into ErrorMsgIndex values (14,'权限删除错误') 
/
insert into ErrorMsgIndex values (23,'审批错误') 
/
insert into ErrorMsgIndex values (1,'文档删除错误') 
/
insert into ErrorMsgIndex values (29,'修改记录成功') 
/
insert into ErrorMsgIndex values (13,'修改记录失败') 
/
insert into ErrorMsgIndex values (15,'用户不存在') 
/
insert into ErrorMsgIndex values (17,'用户无效') 
/
insert into ErrorMsgIndex values (3,'子目录为空') 
/
insert into ErrorMsgIndex values (27,'自动明细下不能手动建立明细') 
/



insert into ErrorMsgInfo values (1,'该文档已被使用,不能被删除',7) 
/
insert into ErrorMsgInfo values (1,'Can\''t be deleted',8) 
/
insert into ErrorMsgInfo values (3,'该目录下的子目录为空',7) 
/
insert into ErrorMsgInfo values (3,'SubCategory is Empty',8) 
/
insert into ErrorMsgInfo values (4,'安全级别大于该子目录的最高安全级别',7) 
/
insert into ErrorMsgInfo values (4,'SecLevel is too larger',8) 
/
insert into ErrorMsgInfo values (8,'该模板已被设置为默认模板，不能被删除！',7) 
/
insert into ErrorMsgInfo values (8,'Default mould cann\''t be deleted!',8) 
/
insert into ErrorMsgInfo values (9,'该模板已被子目录使用，不能被删除！',7) 
/
insert into ErrorMsgInfo values (9,'SecCategory mould cann\''t be deleted!',8) 
/
insert into ErrorMsgInfo values (10,'目标子目录或选择文档不能为空！',7) 
/
insert into ErrorMsgInfo values (10,'TargetSecCategory or Selected Doc is null ',8) 
/
insert into ErrorMsgInfo values (11,'该角色下成员不为空，不能被删除',7) 
/
insert into ErrorMsgInfo values (11,'The role cann\''t delete for it contains some members',8) 
/
insert into ErrorMsgInfo values (12,'由于有不能重复的项存在或其它原因,插入记录失败',7) 
/
insert into ErrorMsgInfo values (12,'Insert record failure',8) 
/
insert into ErrorMsgInfo values (13,'修改记录失败',7) 
/
insert into ErrorMsgInfo values (13,'modify record failure',8) 
/
insert into ErrorMsgInfo values (14,'该权限组下成员不为空，不能被删除',7) 
/
insert into ErrorMsgInfo values (14,'System right group can\''t delete for it contain some members',8) 
/
insert into ErrorMsgInfo values (15,'用户不存在',7) 
/
insert into ErrorMsgInfo values (15,'user is not exist',8) 
/
insert into ErrorMsgInfo values (16,'密码错误',7) 
/
insert into ErrorMsgInfo values (16,'Password wrong',8) 
/
insert into ErrorMsgInfo values (17,'用户无效',7) 
/
insert into ErrorMsgInfo values (17,'User Unvalidaty',8) 
/
insert into ErrorMsgInfo values (18,'登录输入不正确',7) 
/
insert into ErrorMsgInfo values (18,'Login id or password is wrong',8) 
/
insert into ErrorMsgInfo values (19,'超时，请重新登录',7) 
/
insert into ErrorMsgInfo values (19,'Time out',8) 
/
insert into ErrorMsgInfo values (20,'该记录被引用,不能删除.',7) 
/
insert into ErrorMsgInfo values (20,'Current record is referenced,Can\''t be deleted.',8) 
/
insert into ErrorMsgInfo values (21,'该期间已关闭或不存在（不活跃）,不能进行相关操作',7) 
/
insert into ErrorMsgInfo values (21,'The period is closed ,exchange rate can\''t be operate',8) 
/
insert into ErrorMsgInfo values (22,'借贷不平衡,不能通过审批',7) 
/
insert into ErrorMsgInfo values (22,'debit not equal credit , can\''t be approved',8) 
/
insert into ErrorMsgInfo values (23,'批准者不能是记录的创建者',7) 
/
insert into ErrorMsgInfo values (23,'approver can\''t be creater',8) 
/
insert into ErrorMsgInfo values (24,'该科目已有期初或收支,不能建立下级科目',7) 
/
insert into ErrorMsgInfo values (24,'can\''t create sub ledger',8) 
/
insert into ErrorMsgInfo values (25,'此期间前有未关闭的期间,不能进行登帐',7) 
/
insert into ErrorMsgInfo values (25,'can\''t process',8) 
/
insert into ErrorMsgInfo values (26,'该期间前有未关闭的活跃期间,或者该期间有未登帐的分录或预算,期间未能关闭',7) 
/
insert into ErrorMsgInfo values (26,'Periods can\''t close',8) 
/
insert into ErrorMsgInfo values (27,'自动明细科目下不能手动建立明细科目',7) 
/
insert into ErrorMsgInfo values (27,'can\''t create ledger manully',8) 
/
insert into ErrorMsgInfo values (28,'该类型不能建立下级类型',7) 
/
insert into ErrorMsgInfo values (28,'No subassortment creation permitted',8) 
/
insert into ErrorMsgInfo values (29,'修改记录成功',7) 
/
insert into ErrorMsgInfo values (29,'Change Success',8) 
/
insert into ErrorMsgInfo values (30,'登陆名重复',7) 
/
insert into ErrorMsgInfo values (30,'Login name conflict',8) 
/
insert into ErrorMsgInfo values (31,'该编号已被引用!',7) 
/
insert into ErrorMsgInfo values (31,'this mark has already being used !',8) 
/


insert into HtmlNoteIndex values (14,'必须项不能为空') 
/
insert into HtmlNoteIndex values (20,'必须项不能相同') 
/
insert into HtmlNoteIndex values (18,'财务要素主体删除出错') 
/
insert into HtmlNoteIndex values (35,'登帐操作提示') 
/
insert into HtmlNoteIndex values (45,'分目录不能删除，还有下级分目录存在') 
/
insert into HtmlNoteIndex values (10,'分目录删除出错') 
/
insert into HtmlNoteIndex values (41,'购物数不能为零') 
/
insert into HtmlNoteIndex values (32,'汇率不能为0') 
/
insert into HtmlNoteIndex values (31,'借贷不平衡') 
/
insert into HtmlNoteIndex values (17,'旧密码不正确') 
/
insert into HtmlNoteIndex values (30,'没有相关信息') 
/
insert into HtmlNoteIndex values (12,'没有找到所需的部门') 
/
insert into HtmlNoteIndex values (15,'密码不能为空') 
/
insert into HtmlNoteIndex values (16,'密码确认不正确') 
/
insert into HtmlNoteIndex values (29,'默认货币选择') 
/
insert into HtmlNoteIndex values (25,'年输入不正确') 
/
insert into HtmlNoteIndex values (28,'期间输入不正确') 
/
insert into HtmlNoteIndex values (23,'请告知') 
/
insert into HtmlNoteIndex values (24,'请稍等片刻') 
/
insert into HtmlNoteIndex values (33,'请选择部门(财务登帐)') 
/
insert into HtmlNoteIndex values (34,'请选择期间(财务登帐)') 
/
insert into HtmlNoteIndex values (42,'请选择至少一个资产') 
/
insert into HtmlNoteIndex values (22,'权限转移成功') 
/
insert into HtmlNoteIndex values (8,'确定删除图片') 
/
insert into HtmlNoteIndex values (26,'确认关闭期间') 
/
insert into HtmlNoteIndex values (7,'确认删除') 
/
insert into HtmlNoteIndex values (27,'确认重新打开期间') 
/
insert into HtmlNoteIndex values (13,'删除系统默认的分目录') 
/
insert into HtmlNoteIndex values (5,'图片格式') 
/
insert into HtmlNoteIndex values (19,'未键入符合标准的数据') 
/
insert into HtmlNoteIndex values (11,'系统默认分部删除') 
/
insert into HtmlNoteIndex values (38,'选择种类或科目') 
/
insert into HtmlNoteIndex values (43,'验收人不能为采购人！') 
/
insert into HtmlNoteIndex values (37,'预算处理提示') 
/
insert into HtmlNoteIndex values (6,'主目录删除出错') 
/
insert into HtmlNoteIndex values (39,'资产(属性移动)') 
/
insert into HtmlNoteIndex values (40,'资产(属性移动) 提示') 
/



insert into HtmlNoteInfo values (5,'图片格式必须为：*.gif, *.jpeg 建议图片大小为300*300 pixels ',7) 
/
insert into HtmlNoteInfo values (5,'Supply the local path to the previously scanned image file in *.gif, *.jpeg format:The recommended size is maximal 300*300 pixels ',8) 
/
insert into HtmlNoteInfo values (6,'该主目录下有分目录存在,不能被删除!',7) 
/
insert into HtmlNoteInfo values (6,'Unable to delete group,This group contains 1 or more documents!',8) 
/
insert into HtmlNoteInfo values (7,'你确定要删除这条记录吗?',7) 
/
insert into HtmlNoteInfo values (7,'Are you sure to delete this record?',8) 
/
insert into HtmlNoteInfo values (8,'你确定要删除这张图片吗?',7) 
/
insert into HtmlNoteInfo values (8,'Are you sure to delete this picture?',8) 
/
insert into HtmlNoteInfo values (10,'该分目录下有子目录存在,不能被删除!',7) 
/
insert into HtmlNoteInfo values (10,'Unable to delete group,This group contains 1 or more documents!',8) 
/
insert into HtmlNoteInfo values (11,'不能删除系统默认的分部!',7) 
/
insert into HtmlNoteInfo values (11,'This item can not be deleted because it has a refence.',8) 
/
insert into HtmlNoteInfo values (12,'没有找到所需的部门',7) 
/
insert into HtmlNoteInfo values (12,'No division found ',8) 
/
insert into HtmlNoteInfo values (13,'不能删除系统默认的分目录!',7) 
/
insert into HtmlNoteInfo values (13,'This item can not be deleted because it has a refence.',8) 
/
insert into HtmlNoteInfo values (14,'必要信息不完整',7) 
/
insert into HtmlNoteInfo values (14,'Please check the integrity of your data, and fill in the form.',8) 
/
insert into HtmlNoteInfo values (15,'密码不能为空',7) 
/
insert into HtmlNoteInfo values (15,'Password can\''t be null',8) 
/
insert into HtmlNoteInfo values (16,'密码确认不正确',7) 
/
insert into HtmlNoteInfo values (16,'Confirm password is wrong',8) 
/
insert into HtmlNoteInfo values (17,'旧密码不正确',7) 
/
insert into HtmlNoteInfo values (17,'Old password is wrong',8) 
/
insert into HtmlNoteInfo values (18,'财务要素主体不为空，删除出错',7) 
/
insert into HtmlNoteInfo values (18,'SalaryComponentTypes Not Null,Can Not Delete',8) 
/
insert into HtmlNoteInfo values (19,'未键入符合标准的数据',7) 
/
insert into HtmlNoteInfo values (19,'Not input standard data yet',8) 
/
insert into HtmlNoteInfo values (20,'必须项不能相同',7) 
/
insert into HtmlNoteInfo values (20,'Must not the same',8) 
/
insert into HtmlNoteInfo values (22,'权限转移成功',7) 
/
insert into HtmlNoteInfo values (22,'RightTransfer success',8) 
/
insert into HtmlNoteInfo values (23,'请告知',7) 
/
insert into HtmlNoteInfo values (23,'Please inform',8) 
/
insert into HtmlNoteInfo values (24,'请稍等片刻',7) 
/
insert into HtmlNoteInfo values (24,'Please wait a moment',8) 
/
insert into HtmlNoteInfo values (25,'年输入不正确',7) 
/
insert into HtmlNoteInfo values (25,'Year is wrong',8) 
/
insert into HtmlNoteInfo values (26,'期间关闭后该期间将不能录入新的分录,你确定要关闭该期间吗?',7) 
/
insert into HtmlNoteInfo values (26,'Are you sure close the period?',8) 
/
insert into HtmlNoteInfo values (27,'期间打开将删除该期间的所有统计信息,你确定重新打开该期间吗?',7) 
/
insert into HtmlNoteInfo values (27,'Are you sure reopen the period?',8) 
/
insert into HtmlNoteInfo values (28,'期间输入不正确',7) 
/
insert into HtmlNoteInfo values (28,'Period is wrong',8) 
/
insert into HtmlNoteInfo values (29,'你选择该货币为默认货币,将使原来的默认货币失去默认,是否继续?',7) 
/
insert into HtmlNoteInfo values (29,'The currency will replace the old default currency!',8) 
/
insert into HtmlNoteInfo values (30,'没有相关信息',7) 
/
insert into HtmlNoteInfo values (30,'No relative information found',8) 
/
insert into HtmlNoteInfo values (31,'借贷不平衡,是否保存该信息',7) 
/
insert into HtmlNoteInfo values (31,'credit and debit not equal',8) 
/
insert into HtmlNoteInfo values (32,'汇率不能为0',7) 
/
insert into HtmlNoteInfo values (32,'Exchange rate cannot be 0',8) 
/
insert into HtmlNoteInfo values (33,'请选择部门',7) 
/
insert into HtmlNoteInfo values (33,'Please select Department',8) 
/
insert into HtmlNoteInfo values (34,'请选择期间',7) 
/
insert into HtmlNoteInfo values (34,'Please select periods',8) 
/
insert into HtmlNoteInfo values (35,'此次操作将会把你所选的期间和部门的已批准分录登帐,分录登帐后,将不能再更改,是否确定进行登帐?',7) 
/
insert into HtmlNoteInfo values (35,'confirm process?',8) 
/
insert into HtmlNoteInfo values (37,'此次操作将会把你所选的期间和部门的已批准预算处理,预算处理后,将不能再更改,是否确定进行处理?',7) 
/
insert into HtmlNoteInfo values (37,'confirm process',8) 
/
insert into HtmlNoteInfo values (38,'请先选择种类或者科目',7) 
/
insert into HtmlNoteInfo values (38,'Please select a category or a ledger',8) 
/
insert into HtmlNoteInfo values (39,'请选择正确的移动项',7) 
/
insert into HtmlNoteInfo values (39,'Please select right ',8) 
/
insert into HtmlNoteInfo values (40,'本次移动所影响的记录数为',7) 
/
insert into HtmlNoteInfo values (40,'the recorder count is ',8) 
/
insert into HtmlNoteInfo values (41,'购物数不能为零',7) 
/
insert into HtmlNoteInfo values (41,'can\''t purchase null',8) 
/
insert into HtmlNoteInfo values (42,'请选择至少一个资产',7) 
/
insert into HtmlNoteInfo values (42,'Please choose at lease one capital',8) 
/
insert into HtmlNoteInfo values (43,'验收人不能为采购人！',7) 
/
insert into HtmlNoteInfo values (43,'The checher can''''t be the buyer!',8) 
/
insert into HtmlNoteInfo values (45,'该分目录下有下级分目录存在,不能被删除!',7) 
/
insert into HtmlNoteInfo values (45,'Unable to delete group,This group contains 1 or more other groups!',8) 
/

delete SystemRights
/

insert into SystemRights (id,rightdesc,righttype) values (1,'文档主目录维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (4,'文档分目录维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (8,'文档子目录维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (9,'文档种类维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (10,'文档模板维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (11,'文档新闻页设置维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (12,'文档系统默认设置维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (13,'文档图片上传维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (14,'文档复制移动维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (15,'财务分录批准','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (16,'文档维护','1') 
/
insert into SystemRights (id,rightdesc,righttype) values (17,'总部维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (18,'分部维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (19,'部门维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (20,'成本中心维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (21,'成本中心类别维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (22,'人力资源维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (23,'部门时间表维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (24,'公众假日维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (25,'角色维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (26,'国家维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (27,'位置维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (28,'工作类型维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (29,'职责维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (30,'职位维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (31,'技能维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (32,'权限维护','7') 
/
insert into SystemRights (id,rightdesc,righttype) values (33,'角色成员维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (34,'权限转移维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (35,'默认时间表维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (36,'人力资源时间表维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (37,'非一致工作时间维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (38,' 财务主体维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (39,'财务要素维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (40,'联系人称呼维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (41,'地址类型维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (42,'联系方法维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (43,'送货方式维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (44,'行业维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (45,'公司规模维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (46,'客户类别维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (47,'累计合同金额维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (48,'信用等级维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (49,'客户状况维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (50,'客户描述维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (51,'客户级别维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (52,'支付条件维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (53,'财务预算批准','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (54,'项目类型维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (55,'工作类别维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (56,'项目状态维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (57,'计划类型维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (58,'计划分类维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (59,'监控类型维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (60,'预算模板维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (61,'币种维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (62,'汇率维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (63,'指示器维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (64,'财务目录维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (65,'财务科目维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (66,'财务期间维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (67,'财务预算查看','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (68,'财务预算维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (69,'财务收支查看','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (70,'财务收支维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (71,'财务收支审批','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (72,'财务收支登帐','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (73,'财务预算登帐','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (74,'财务期间管理','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (75,'资产种类维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (76,'资产类型维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (77,'计量单位维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (78,'配置类型维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (79,'核算方法维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (80,'收付款方式维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (81,'仓库维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (82,'进出库方式维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (83,'资产目录维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (84,'资产维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (85,'资产供应商维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (86,'资产期初维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (87,'资产配置关系维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (88,'资产价格维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (89,'查看财务报表','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (90,'系统设置','7') 
/
insert into SystemRights (id,rightdesc,righttype) values (91,'工作流维护','5') 
/
insert into SystemRights (id,rightdesc,righttype) values (92,'项目空闲字段维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (93,'客户信息空闲字段维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (94,'人力资源空闲字段维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (95,'人力资源技能维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (96,'人力资源能力维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (97,'能力维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (98,'项目维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (99,'项目查看','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (100,'项目成员维护','6') 
/
insert into SystemRights (id,rightdesc,righttype) values (101,'客户维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (102,'客户地址信息维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (103,'客户联系情况维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (104,'客户查看','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (105,'客户联系人维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (106,'系统权限角色维护','7') 
/
insert into SystemRights (id,rightdesc,righttype) values (107,'重建数据库维护','7') 
/
insert into SystemRights (id,rightdesc,righttype) values (108,'标题维护','7') 
/
insert into SystemRights (id,rightdesc,righttype) values (109,'人力资源工资维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (110,'招聘信息维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (111,'应聘信息维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (112,'其他信息类型维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (113,'人力资源银行帐户维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (114,'人力资源其它信息维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (115,'人力资源邮件群发','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (116,'CRM邮件群发','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (117,'查看人力资源计划','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (118,'查看人力资源请假','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (119,'资产空闲字段维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (120,'应聘人审核','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (121,'应聘人录用','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (122,'培训类型维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (123,'奖惩类型维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (124,'职称维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (125,'专业维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (126,'职务类别维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (127,'用工性质维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (128,'工作简历维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (129,'教育情况维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (130,'家庭情况维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (131,'语言能力维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (132,'培训记录维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (133,'奖惩记录维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (134,'省份维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (135,'城市维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (136,'资产维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (137,'资产组维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (138,'资产类型维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (139,'资产状态维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (140,'资产计量单位维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (141,'资产折旧方法维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (142,'资产盘点维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (143,'资产盘点审批','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (144,'资产入库维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (145,'资产调入维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (146,'资产调出维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (147,'资产领用维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (148,'资产租借维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (149,'资产其它维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (150,'资产流转查看维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (151,'资产移交维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (152,'资产维修维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (153,'资产归还维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (154,'资产损失维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (155,'资产报废维护','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (156,'资格证书维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (157,'入职简历维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (158,'薪酬福利维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (159,'年休假记录维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (160,'资产总表查看','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (161,'资产情况查看','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (162,'资产流转情况查看','8') 
/
insert into SystemRights (id,rightdesc,righttype) values (163,'报销费用类型维护','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (164,'预算费用类型维护','4') 
/
insert into SystemRights (id,rightdesc,righttype) values (200,'会议类型维护','9') 
/
insert into SystemRights (id,rightdesc,righttype) values (300,'工作流报表维护','5') 
/
insert into SystemRights (id,rightdesc,righttype) values (301,'天气预报维护','5') 
/
insert into SystemRights (id,rightdesc,righttype) values (302,'管理费用明细查看','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (303,'货币资金查看','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (304,'个人往来查看','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (305,'名片印制费用月结','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (306,'机票预订费用月结','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (307,'特快专递费用月结','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (308,'市内快递费用月结','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (309,'显示卡片栏目','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (310,'日志查看','2') 
/
insert into SystemRights (id,rightdesc,righttype) values (350,'会议室维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (380,'产品维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (351,'客户价值评估维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (352,'客户合同性质维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (353,'客户信用额度/期间维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (370,'培训规划维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (371,'培训安排维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (372,'培训资源维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (373,'培训活动维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (374,'用工需求维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (375,'招聘计划维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (381,'考勤维护维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (382,'学历维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (383,'合同种类维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (384,'合同维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (385,'CRM调查维护','0') 
/
insert into SystemRights (id,rightdesc,righttype) values (386,'人力资源考核种类维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (387,'人力资源考核项目维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (388,'人力资源考核实施维护','3') 
/
insert into SystemRights (id,rightdesc,righttype) values (389,'邮件模板维护','3') 
/



delete SystemRightsLanguage
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1,7,'文档主目录维护','文档主目录添加,删除,修改,日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (8,7,'文档子目录维护','文档子目录添加,删除,修改,查看日志') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (9,7,'文档种类维护','文档种类添加,删除,修改,日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (10,7,'文档模板维护','文档模板的添加，删除，更新和日志改变') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (11,7,'文档新闻页设置维护','文档新闻页设置的添加，删除，更新，日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (13,7,'文档图片上传维护','文档图片上传的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (14,7,'文档复制移动维护','文档的复制，移动和查看日志的权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (16,7,'文档维护','文档的显示，编辑，删除，归档和重载权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (21,7,'成本中心类别维护','成本中心类别的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (23,7,'部门时间表维护','部门时间表的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (25,7,'角色维护','角色的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (31,7,'技能维护','技能的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (33,7,'角色成员维护','角色成员的添加，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (34,7,'权限转移维护','权限转移的许可') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (37,7,'非一致工作时间维护','非一致工作时间的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (42,7,'联系方法维护','联系方法的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (43,7,'送货方式维护','送货方式的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (45,7,'公司规模维护','公司规模的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (46,7,'客户类别维护','客户类别的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (47,7,'累计合同金额维护','累计合同金额的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (48,7,'信用等级维护','信用等级的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (50,7,'客户描述维护','客户描述的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (52,7,'支付条件维护','支付条件的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (53,7,'财务预算批准','财务预算的查看，审批') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (54,7,'项目类型维护','项目类型的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (55,7,'工作类别维护','工作类别的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (57,7,'计划类型维护','计划类型的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (60,7,'预算模板维护','预算模板的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (63,7,'指示器维护','指示器的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (65,7,'财务科目维护','财务科目的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (66,7,'财务期间维护','财务期间的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (69,7,'财务收支查看','财务收支的查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (70,7,'财务收支维护','财务收支的新建,编辑和删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (75,7,'资产种类维护','资产种类的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (77,7,'计量单位维护','计量单位的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (79,7,'核算方法维护','资产核算方法的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (80,7,'收付款方式维护','收付款方式的添加,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (81,7,'仓库维护','仓库的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (82,7,'进出库方式维护','进出库方式的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (83,7,'资产目录维护','资产目录的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (84,7,'资产维护','资产的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (85,7,'资产与CRM维护','资产与CRM的新建,编辑,删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (86,7,'资产期初维护','资产期初的新建,编辑,删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (87,7,'资产配置关系维护','资产配置关系的建立,编辑和删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (89,7,'查看财务报表','查看资产负债表和损益表') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,7,'系统设置','系统设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (91,7,'工作流维护','工作流维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (92,7,'项目空闲字段维护','项目空闲字段维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (93,7,'客户信息空闲字段','客户信息空闲字段编辑') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (94,7,'人力资源空闲字段维护','人力资源空闲字段维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (95,7,'人力资源技能维护','人力资源技能维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (96,7,'人力资源能力维护','人力资源能力维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (97,7,'能力维护','能力维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (98,7,'项目维护','项目维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (99,7,'项目查看','项目查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (101,7,'客户维护','客户维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (102,7,'客户地址信息维护','客户地址信息维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (103,7,'客户联系情况维护','客户联系情况维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (107,7,'重建数据库维护','重建数据库维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (108,7,'标题维护','标题维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (109,7,'人力资源工资维护','人力资源工资维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (110,7,'招聘信息维护','招聘信息维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (111,7,'应聘信息维护','应聘信息维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (112,7,'其他信息类型维护','其他信息类型维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (4,7,'文档分目录维护','文档分目录添加,删除,修改,查看日志') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (12,7,'文档系统默认设置维护','文档系统默认设置的编辑和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (20,7,'成本中心维护','成本中心的添加，删除，更新和日志，统计图表的查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (22,7,'人力资源维护','人力资源的添加，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (24,7,'公众假日维护','公众假日的添加（复制），删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (26,7,'国家维护','国家的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (27,7,'位置维护','位置的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (30,7,'职位维护','职位的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (39,7,'财务要素维护','财务要素的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (40,7,'联系人称呼维护','联系人称呼的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (44,7,'行业维护','行业的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (49,7,'客户状况维护','客户状况的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (58,7,'计划分类维护','计划分类的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (61,7,'币种维护','币种的新建,编辑和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (62,7,'汇率维护','汇率的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (64,7,'财务目录维护','财务目录的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (76,7,'资产类型维护','资产类型的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (100,7,'项目成员维护','项目成员维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (104,7,'客户查看','客户查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (105,7,'客户联系人维护','客户联系人维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (106,7,'系统权限角色维护','系统权限角色维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (15,7,'财务分录维护','财务分录的查看和审批') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (17,7,'总部维护','总部的编辑和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (18,7,'分部维护','分部的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (28,7,'工作类型维护','工作类型的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (29,7,'职责维护','职责的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (41,7,'地址类型维护','地址类型的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (51,7,'客户级别维护','客户级别的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (19,7,'部门维护','部门的添加，删除，更新和查看日志，成本中心统计图表，总帐，收支，预算的权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (32,7,'权限维护','权限的添加，删除，更新,日志查看和添加权限角色') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (35,7,'默认时间表维护','默认时间表的编辑和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (36,7,'人力资源时间表维护','人力资源时间表的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (38,7,'财务主体维护','财务主体的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (56,7,'项目状态维护','项目状态的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (67,7,'财务预算查看','财务预算查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (68,7,'财务预算维护','财务预算的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (78,7,'配置类型维护','配置类型的新建,编辑,删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (88,7,'资产价格维护','资产价格的建立,编辑和删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (59,7,'监控类型维护','监控类型的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (113,7,'人力资源银行帐户维护','人力资源银行帐户维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (71,7,'财务收支审批','财务收支的查看和审批') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (72,7,'财务收支登帐','财务收支的登帐') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (73,7,'财务预算登帐','财务预算的登帐') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (74,7,'财务期间管理','财务期间的关闭和重新打开') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (114,7,'人力资源其它信息维护','人力资源其它信息的查看,新建,编辑和删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (115,7,'人力资源邮件群发','人力资源邮件的群发') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (116,7,'CRM邮件群发','CRM邮件的群发') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (117,7,'查看人力资源计划','查看人力资源计划') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (118,7,'查看人力资源请假','查看人力资源请假') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (119,7,'资产空闲字段维护','资产空闲字段维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (120,7,'应聘人审核','应聘人审核') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (121,7,'应聘人录用','应聘人录用') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (122,7,'培训类型维护','培训类型维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (123,7,'奖惩类型维护','奖惩类型维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (124,7,'职称维护','职称维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (125,7,'专业维护','专业维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (126,7,'职务类别维护','职务类别维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (127,7,'用工性质维护','用工性质维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (128,7,'工作简历维护','工作简历维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (129,7,'教育情况维护','教育情况维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (130,7,'家庭情况维护','家庭情况维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (131,7,'语言能力维护','语言能力维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (132,7,'培训记录维护','培训记录维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (133,7,'奖惩记录维护','奖惩记录维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (134,7,'省份维护','省份维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (135,7,'城市维护','城市维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (136,7,'资产维护','资产维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (137,7,'资产组维护','资产组维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (138,7,'资产类型维护','资产类型维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (139,7,'资产状态维护','资产状态维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (140,7,'资产计量单位维护','资产计量单位维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (141,7,'资产折旧方法维护','资产折旧方法维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (142,7,'资产盘点维护','资产盘点维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (143,7,'资产盘点审批','资产盘点审批') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (144,7,'资产入库维护','资产入库维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (145,7,'资产调入维护','资产调入维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (146,7,'资产调出维护','资产调出维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (147,7,'资产领用维护','资产领用维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (148,7,'资产租借维护','资产租借维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (149,7,'资产其它维护','资产其它维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (150,7,'资产流转查看维护','资产流转查看维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (151,7,'资产移交维护','资产移交维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (152,7,'资产维修维护','资产维修维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (153,7,'资产归还维护','资产归还维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (154,7,'资产损失维护','资产损失维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (155,7,'资产报废维护','资产报废维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (156,7,'资格证书维护','资格证书维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (157,7,'入职简历维护','入职简历维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (158,7,'薪酬福利维护','薪酬福利维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (159,7,'年休假记录维护','年休假记录维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (160,7,'资产总表查看','资产总表查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (161,7,'资产情况查看','资产情况查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (162,7,'资产流转情况查看','资产流转情况查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (163,7,'报销费用类型维护','报销费用类型维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (164,7,'预算费用类型维护','预算费用类型维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (200,7,'会议类型维护','会议类型及相关参数设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (300,7,'工作流报表管理','工作流报表管理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (301,7,'天气预报维护','天气预报维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (302,7,'管理费用明细查看','管理费用明细查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (303,7,'货币资金查看','货币资金查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (304,7,'个人往来查看','个人往来查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (305,7,'名片印制费用月结','名片印制费用月结') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (306,7,'机票预订费用月结','机票预订费用月结') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (307,7,'特快专递费用月结','特快专递费用月结') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (308,7,'市内快递费用月结','市内快递费用月结') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (309,7,'显示卡片栏目','显示卡片栏目') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (310,7,'日志查看','日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (350,7,'会议室维护','会议室维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (380,7,'产品维护','产品维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (351,7,'客户价值评估维护','客户价值评估维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (352,7,'客户合同性质维护','客户合同性质维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (353,7,'客户信用额度/期间维护','客户信用额度/期间维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (382,7,'学历维护','学历维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (370,7,'培训规划维护','培训规划添加，编辑，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (371,7,'培训安排维护','培训安排添加，编辑，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (372,7,'培训资源维护','培训资源添加，编辑，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (373,7,'培训活动维护','培训活动添加，编辑，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (374,7,'用工需求维护','用工需求添加，编辑，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (375,7,'招聘计划维护','招聘计划添加，编辑，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (383,7,'合同种类维护','合同种类添加，编辑，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (384,7,'合同维护','合同添加，编辑，删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (385,7,'CRM调查维护','CRM调查维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (386,7,'人力资源考核种类维护','人力资源考核种类新建，编辑和删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,7,'人力资源考核项目维护','人力资源考核项目新建，编辑和删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (388,7,'人力资源考核实施维护','人力资源考核实施维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (389,7,'邮件模板维护','邮件模板新建，编辑，删除和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (381,7,'考勤维护','考勤维护添加，编辑，删除和日志查看') 
/


insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1,8,'Doc Maincategory maintenance','Add,update,delete and log doc maincategory') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (8,8,'Doc Seccategory maintenance','Add,update,delete and log doc Seccategory') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (9,8,'Doc Type maintenance','Add,update,delete and log doc type') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (10,8,'Doc Mould maintenance','Add,update,delete and log doc Mould') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (11,8,'Doc Frontpage maintenance','Add,update,delete and log doc Frontpage') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (12,8,'Doc SystemDefault maintenance','Update and log doc Syetem default') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (13,8,'Doc PicUpload maintenance','Add,delete,update and log pic upload') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (14,8,'Doc copy and move maintenance','Doc copy,move and log ') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (15,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (16,8,'Doc maintenance','Display,update,delete,archive and reload Doc') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (21,8,'Cost center category maintenance','Add,delete,update and log costcenter category') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (22,8,'Hrm resource maintenance','Add,update and log Hrmresource') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (23,8,'HrmDepartmentSchedule maintenance','Add,delete,update and log HrmDepartmentSchedule') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (25,8,'HrmRoles','Add,delete,update and log HrmRoles') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (31,8,'HrmCompetency','Add,delete,update and log HrmCompetency') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (33,8,'HrmRoleMembers','Add,delete and log HrmRoleMembers') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (34,8,'HrmRrightTransfer','HrmRrightTransfer permission') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (37,8,'HrmScheduleDiff','Add,delete,update and log HrmScheduleDiff') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (42,8,'ContactWay','Add,delete,update and log ContactWay') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (43,8,'DeliverType','Add,delete,update and log DeliverType') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (45,8,'CustomerSize','Add,delete,update and log CustomerSize') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (46,8,'CustomerType','Add,delete,update and log CustomerType') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (47,8,'TradeInfo','Add,delete,update and log TradeInfo') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (48,8,'CreditInfo','Add,delete,update and log CreditInfo') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (50,8,'CustomerDesc','Add,delete,update and log CustomerDesc') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (52,8,'PaymentTerm','Add,delete,update and log PaymentTerm') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (53,8,'FnaBudget Approve','View and approve FnaBudget') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (54,8,'ProjectType Maintenance','Add,delete,update and log ProjectType') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (55,8,'WorkType Maintenance','Add,delete,update and log WorkType') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (57,8,'PlanType Maintenance','Add,delete,update and log PlanType') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (65,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (66,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (69,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (70,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (75,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (77,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (79,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (80,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (81,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (82,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (83,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (84,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (85,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (86,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (87,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (89,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (91,8,'workflow maintenance','workflow maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (92,8,'project freefeild maintenance','project freefeild maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (93,8,'customerfreefeild','customerfreefeild edit') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (95,8,'HrmResource skill maintenance','HrmResource skill maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (96,8,'Hrm resource competency maintenance','Hrm resource competency maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (97,8,'competency maintenance','competency maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (98,8,'Project maintenance','Project maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (99,8,'Project View','Project View') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (101,8,'Customer maintenance','Customer maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (102,8,'Customer address maintenance','Customer address maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (103,8,'Customer contact maintenance','Customer contact maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (107,8,'CreateDB','Create DB') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (108,8,'title maintenance','title maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (109,8,'hrm resource component maintenance','hrm resource component maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (110,8,'Career invite maintenance','Career invite maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (111,8,'Career apply maintenance','Career apply maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (112,8,'other info type maintenance','other info type maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (4,8,'Doc Subcategory maintenance','Add,update,delete and log doc Subcategory') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (63,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (94,8,'Hrm resource free feild  maintenance','Hrm resource free feild  maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (20,8,'Cost center maintenance','Add,delete,update and log ,chart view of cost center') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (24,8,'HrmPubHoliday','Add(dup),delete,update and log HrmPubHoliday') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (26,8,'HrmCountries','Add,delete,update and log HrmCountries') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (27,8,'HrmLocations','Add,delete,update and log HrmLocations') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (30,8,'HrmJobTitles','Add,delete,update and log HrmJobTitles') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (39,8,'HrmSalaryComponent','Add,delete,update and log HrmSalaryComponent') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (40,8,'ContactorTitle','Add,delete,update and log ContactorTitle') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (44,8,'SectorInfo','Add,delete,update and log SectorInfo') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (49,8,'CustomerStatus','Add,delete,update and log CustomerStatus') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (58,8,'PlanSort Maintenance','Add,delete,update and log PlanSort') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (60,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (61,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (62,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (64,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (76,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (100,8,'Project member Maintenance','Project member Maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (104,8,'Customer View','Customer View') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (105,8,'Customer contactor maintenance','Customer contactor maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (106,8,'System right roles','System right roles') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (17,8,'HrmCompany maintenance','Update and log HrmCompany') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (18,8,'Subcompany maintenance ','Add,delete,update and log subcompany') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (28,8,'HrmJobGroups','Add,delete,update and log HrmJobGroups') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (29,8,'HrmJobActiveties','Add,delete,update and log HrmJobActiveties') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (41,8,'AddressType','Add,delete,update and log AddressType') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (51,8,'CustomerRating','Add,delete,update and log CustomerRating') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (19,8,'Hrmdepartment maintenance','Add,delete,update and view log,costcenter,fnaledger,fnacredence,fnabudget of Hrmdepartment') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (32,8,'SystemRightGroup','Add,delete,update,log SystemRightGroup and add SystermRightRoles') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (35,8,'HrmDefaultSchedule','Update and log HrmDefaultSchedule') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (36,8,'HrmResouceScheduleList','Add,delete,update and log HrmResouceScheduleList') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (38,8,'HrmSalaryComponentTypes','Add,delete,update and log HrmSalaryComponentTypes') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (56,8,'ProjectStatus Maintenance','Add,delete,update and log ProjectStatus') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (67,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (68,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (78,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (88,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (59,8,'ProcessingType Maintenance','Add,delete,update and log ProcessingType') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (113,8,'Hrm resource bank account maintenance','Hrm resource bank account maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (71,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (72,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (73,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (74,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (114,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (115,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (116,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (117,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (118,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (119,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (120,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (121,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (122,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (123,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (124,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (125,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (126,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (127,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (128,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (129,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (130,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (131,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (132,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (133,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (134,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (135,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (136,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (137,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (138,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (139,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (140,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (141,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (142,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (143,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (144,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (145,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (146,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (147,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (148,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (149,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (150,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (151,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (152,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (153,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (154,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (155,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (156,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (157,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (158,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (159,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (160,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (161,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (162,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (163,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (164,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (200,8,'Meeting type maintenance','Add,delete meeting type') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (300,8,'workflow report manage','workflow report manage') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (301,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (302,8,'ManageFeeDetail','ManageFeeDetail') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (303,8,'MoneyWeek','MoneyWeek') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (304,8,'OtherArPerson','OtherArPerson') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (305,8,'MonthFeeNamecard','MonthFeeNamecard') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (306,8,'MonthFeePlane','MonthFeePlane') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (307,8,'MonthFeeEMS','MonthFeeEMS') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (308,8,'MonthFeeSNKD','MonthFeeSNKD') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (309,8,'ShowColumn','ShowColumn') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (310,8,'LogView','LogView') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (350,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (380,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (351,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (352,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (353,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (382,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (370,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (371,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (372,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (373,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (374,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (375,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (381,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (383,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (384,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (385,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (386,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (388,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (389,8,'','') 
/
