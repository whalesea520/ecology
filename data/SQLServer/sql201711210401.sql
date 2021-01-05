delete from HtmlLabelIndex where id=132113 
GO
delete from HtmlLabelInfo where indexid=132113 
GO
INSERT INTO HtmlLabelIndex values(132113,'科目设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(132113,'科目设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132113,'Subject setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132113,'科目設置',9) 
GO

delete from HtmlLabelIndex where id=132114 
GO
delete from HtmlLabelInfo where indexid=132114 
GO
INSERT INTO HtmlLabelIndex values(132114,'科目编码校验规则') 
GO
delete from HtmlLabelIndex where id=132115 
GO
delete from HtmlLabelInfo where indexid=132115 
GO
INSERT INTO HtmlLabelIndex values(132115,'全局唯一') 
GO
delete from HtmlLabelIndex where id=132116 
GO
delete from HtmlLabelInfo where indexid=132116 
GO
INSERT INTO HtmlLabelIndex values(132116,'按科目应用范围唯一') 
GO
delete from HtmlLabelIndex where id=132117 
GO
delete from HtmlLabelInfo where indexid=132117 
GO
INSERT INTO HtmlLabelIndex values(132117,'无唯一性控制') 
GO
INSERT INTO HtmlLabelInfo VALUES(132117,'无唯一性控制',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132117,'Non uniqueness control',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132117,'無唯一性控制',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132116,'按科目应用范围唯一',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132116,'Subject scope is unique',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132116,'按科目應用範圍唯一',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132115,'全局唯一',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132115,'Globally unique',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132115,'全局唯一',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132114,'科目编码校验规则',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132114,'Subject code check rule',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132114,'科目編碼校驗規則',9) 
GO

delete from HtmlLabelIndex where id=132118 
GO
delete from HtmlLabelInfo where indexid=132118 
GO
INSERT INTO HtmlLabelIndex values(132118,'科目应用范围') 
GO
delete from HtmlLabelIndex where id=132119 
GO
delete from HtmlLabelInfo where indexid=132119 
GO
INSERT INTO HtmlLabelIndex values(132119,'不启用【科目应用范围】则无法按科目应用范围进行唯一新控制科目编码') 
GO
delete from HtmlLabelIndex where id=132120 
GO
delete from HtmlLabelInfo where indexid=132120 
GO
INSERT INTO HtmlLabelIndex values(132120,'不启用【科目应用范围】则无法按科目应用范围进行科目编码的唯一控制') 
GO
delete from HtmlLabelIndex where id=132121 
GO
delete from HtmlLabelInfo where indexid=132121 
GO
INSERT INTO HtmlLabelIndex values(132121,'科目编码存在重复！请先调整数据！') 
GO
INSERT INTO HtmlLabelInfo VALUES(132121,'科目编码存在重复！请先调整数据！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132121,'Repetition of subject code! Please adjust the data first!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132121,'科目編碼存在重複！請先調整數據！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132120,'不启用【科目应用范围】则无法按科目应用范围进行科目编码的唯一控制',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132120,'The unique control of subject encoding cannot be applied according to the scope of the application without using the scope of subject application',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132120,'不啓用【科目應用範圍】則無法按科目應用範圍進行科目編碼的唯一控制',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132119,'不启用【科目应用范围】则无法按科目应用范围进行唯一新控制科目编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132119,'If the application scope is not enabled, the only new control subject code cannot be applied according to the scope of the subject application',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132119,'不啓用【科目應用範圍】則無法按科目應用範圍進行唯一新控制科目編碼',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132118,'科目应用范围',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132118,'Subject scope of application',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132118,'科目應用範圍',9) 
GO

delete from HtmlLabelIndex where id=132122 
GO
delete from HtmlLabelInfo where indexid=132122 
GO
INSERT INTO HtmlLabelIndex values(132122,'按科目应用范围唯一（分部级）') 
GO
delete from HtmlLabelIndex where id=132123 
GO
delete from HtmlLabelInfo where indexid=132123 
GO
INSERT INTO HtmlLabelIndex values(132123,'按科目应用范围唯一（部门级）') 
GO
INSERT INTO HtmlLabelInfo VALUES(132123,'按科目应用范围唯一（部门级）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132123,'Subject to application only (department level)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132123,'按科目應用範圍唯一（部門級）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132122,'按科目应用范围唯一（分部级）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132122,'Subject to application only (sub level)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132122,'按科目應用範圍唯一（分部級）',9) 
GO

delete from HtmlLabelIndex where id=132125 
GO
delete from HtmlLabelInfo where indexid=132125 
GO
INSERT INTO HtmlLabelIndex values(132125,'OA系统中所有科目的编码：不允许重复') 
GO
delete from HtmlLabelIndex where id=132126 
GO
delete from HtmlLabelInfo where indexid=132126 
GO
INSERT INTO HtmlLabelIndex values(132126,'OA系统中所有科目的编码：') 
GO
delete from HtmlLabelIndex where id=132127 
GO
delete from HtmlLabelInfo where indexid=132127 
GO
INSERT INTO HtmlLabelIndex values(132127,'1、组织架构：分部级别的应用范围内部不允许重复；总部、部门的应用范围内部允许重复') 
GO
delete from HtmlLabelIndex where id=132128 
GO
delete from HtmlLabelInfo where indexid=132128 
GO
INSERT INTO HtmlLabelIndex values(132128,'2、成本中心的应用范围内部不允许重复') 
GO
delete from HtmlLabelIndex where id=132129 
GO
delete from HtmlLabelInfo where indexid=132129 
GO
INSERT INTO HtmlLabelIndex values(132129,'1、部门级别的应用范围内部不允许重复；总部、分部的应用范围内部允许重复') 
GO
delete from HtmlLabelIndex where id=132130 
GO
delete from HtmlLabelInfo where indexid=132130 
GO
INSERT INTO HtmlLabelIndex values(132130,'OA系统中所有科目的编码：允许重复') 
GO
INSERT INTO HtmlLabelInfo VALUES(132130,'OA系统中所有科目的编码：允许重复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132130,'Code for all subjects in OA system: allow repetition',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132130,'OA系統中所有科目的編碼：允許重複',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132129,'1、部门级别的应用范围内部不允许重复；总部、分部的应用范围内部允许重复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132129,'1, departmental level of application does not allow duplication within the scope of the headquarters, the application of the division within the allowed duplication',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132129,'1、部門級别的應用範圍内部不允許重複；總部、分部的應用範圍内部允許重複',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132128,'2、成本中心的应用范围内部不允许重复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132128,'2, the application scope of the cost center is not allowed to repeat inside',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132128,'2、成本中心的應用範圍内部不允許重複',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132127,'1、组织架构：分部级别的应用范围内部不允许重复；总部、部门的应用范围内部允许重复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132127,'1. Organizational structure: the application scope of departmental level is not allowed to repeat inside; the application scope of headquarters and departments is allowed to repeat internally',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132127,'1、組織架構：分部級别的應用範圍内部不允許重複；總部、部門的應用範圍内部允許重複',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132126,'OA系统中所有科目的编码：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132126,'Coding of all subjects in OA system:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132126,'OA系統中所有科目的編碼：',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132125,'OA系统中所有科目的编码：不允许重复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132125,'The encoding of all subjects in the OA system: not allowed to repeat',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132125,'OA系統中所有科目的編碼：不允許重複',9) 
GO

delete from HtmlLabelIndex where id=132133 
GO
delete from HtmlLabelInfo where indexid=132133 
GO
INSERT INTO HtmlLabelIndex values(132133,'（分部级/成本中心）') 
GO
delete from HtmlLabelIndex where id=132134 
GO
delete from HtmlLabelInfo where indexid=132134 
GO
INSERT INTO HtmlLabelIndex values(132134,'（部门级/成本中心）') 
GO
INSERT INTO HtmlLabelInfo VALUES(132134,'（部门级/成本中心）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132134,'(department level / cost center)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132134,'（部門級/成本中心）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(132133,'（分部级/成本中心）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132133,'(sub level / cost center)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132133,'（分部級/成本中心）',9) 
GO