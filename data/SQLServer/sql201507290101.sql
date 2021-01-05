delete from HtmlNoteIndex where id=3657 
GO
delete from HtmlNoteInfo where indexid=3657 
GO
INSERT INTO HtmlNoteIndex values(3657,'数据保存成功') 
GO
INSERT INTO HtmlNoteInfo VALUES(3657,'数据保存成功',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(3657,'Save Data Success',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(3657,'數據保存成功',9) 
GO

delete from HtmlNoteIndex where id=3658 
GO
delete from HtmlNoteInfo where indexid=3658 
GO
INSERT INTO HtmlNoteIndex values(3658,'数据保存失败') 
GO
INSERT INTO HtmlNoteInfo VALUES(3658,'数据保存失败',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(3658,'Data Save failed',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(3658,'數據保存失敗',9) 
GO

delete from HtmlLabelIndex where id=124999 
GO
delete from HtmlLabelInfo where indexid=124999 
GO
INSERT INTO HtmlLabelIndex values(124999,'打卡数据必须填入导入文件Excel模板的第一个sheet中') 
GO
INSERT INTO HtmlLabelInfo VALUES(124999,'打卡数据必须填入导入文件Excel模板的第一个sheet中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(124999,'The first sheet card data must fill the import file template in Excel',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(124999,'打卡數據必須填入導入文件Excel模闆的第一個sheet中',9) 
GO

delete from HtmlLabelIndex where id=125000 
GO
delete from HtmlLabelInfo where indexid=125000 
GO
INSERT INTO HtmlLabelIndex values(125000,'模板中的第一行为标题行，不能占用。数据必须从第二行开始，中间不能有空行') 
GO
INSERT INTO HtmlLabelInfo VALUES(125000,'模板中的第一行为标题行，不能占用。数据必须从第二行开始，中间不能有空行',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125000,'The first act of the template can not be occupied. The data must be started from the second row, with no blank line',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125000,'模闆中的第一行爲标題行，不能占用。數據必須從第二行開始，中間不能有空行',9) 
GO

delete from HtmlLabelIndex where id=125001 
GO
delete from HtmlLabelInfo where indexid=125001 
GO
INSERT INTO HtmlLabelIndex values(125001,'导入数据的Excel中每一个数据格的格式必须为字符型') 
GO
INSERT INTO HtmlLabelInfo VALUES(125001,'导入数据的Excel中每一个数据格的格式必须为字符型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125001,'The format of each data grid in the import data Excel must be a character type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125001,'導入數據的Excel中每一個數據格的格式必須爲字符型',9) 
GO

delete from HtmlLabelIndex where id=125002 
GO
delete from HtmlLabelInfo where indexid=125002 
GO
INSERT INTO HtmlLabelIndex values(125002,'同一数据可导入多次，系统会自动排除相同的数据') 
GO
INSERT INTO HtmlLabelInfo VALUES(125002,'同一数据可导入多次，系统会自动排除相同的数据',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125002,'The same data can be imported many times, the system will automatically rule out the same data',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125002,'同一數據可導入多次，系統會自動排除相同的數據',9) 
GO

delete from HtmlLabelIndex where id=125003 
GO
delete from HtmlLabelInfo where indexid=125003 
GO
INSERT INTO HtmlLabelIndex values(125003,'对应OA系统中的人员编号，根据编号取对应的人员id（如果人员关键字对应字段选择了编号，该字段必填）') 
GO
INSERT INTO HtmlLabelInfo VALUES(125003,'对应OA系统中的人员编号，根据编号取对应的人员id（如果人员关键字对应字段选择了编号，该字段必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125003,'Personnel number corresponding to the OA system, according to numbers from corresponding personnel ID (if number is chosen by the keywords corresponding to the field, the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125003,'對應OA系統中的人員編号，根據編号取對應的人員id（如果人員關鍵字對應字段選擇了編号，該字段必填）',9) 
GO

delete from HtmlLabelIndex where id=125004 
GO
delete from HtmlLabelInfo where indexid=125004 
GO
INSERT INTO HtmlLabelIndex values(125004,'对应OA系统中的姓名，根据姓名取对应的人员id（如果人员关键字对应字段选择了姓名，该字段必填）') 
GO
INSERT INTO HtmlLabelInfo VALUES(125004,'对应OA系统中的姓名，根据姓名取对应的人员id（如果人员关键字对应字段选择了姓名，该字段必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125004,'In OA system of corresponding name, according to the name take corresponding personnel ID (if name is chosen by the keywords corresponding to the field, the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125004,'對應OA系統中的姓名，根據姓名取對應的人員id（如果人員關鍵字對應字段選擇了姓名，該字段必填）',9) 
GO

delete from HtmlLabelIndex where id=125005 
GO
delete from HtmlLabelInfo where indexid=125005 
GO
INSERT INTO HtmlLabelIndex values(125005,'对应OA系统考勤表中的考勤类别，1：表示签到，2：表示签退（该字段必填）') 
GO
INSERT INTO HtmlLabelInfo VALUES(125005,'对应OA系统考勤表中的考勤类别，1：表示签到，2：表示签退（该字段必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125005,'Attendance category, attendance table corresponding to the OA system 1: 2: sign, sign and return (the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125005,'對應OA系統考勤表中的考勤類别，1：表示簽到，2：表示簽退（該字段必填）',9) 
GO

delete from HtmlLabelIndex where id=125006 
GO
delete from HtmlLabelInfo where indexid=125006 
GO
INSERT INTO HtmlLabelIndex values(125006,'对应OA系统考勤表中的考勤日期，日期格式：2014-01-01（该字段必填）') 
GO
INSERT INTO HtmlLabelInfo VALUES(125006,'对应OA系统考勤表中的考勤日期，日期格式：2014-01-01（该字段必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125006,'The attendance date, attendance table corresponding to the OA date format: 2014-01-01 (the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125006,'對應OA系統考勤表中的考勤日期，日期格式：2014-01-01（該字段必填）',9) 
GO

delete from HtmlLabelIndex where id=125007 
GO
delete from HtmlLabelInfo where indexid=125007 
GO
INSERT INTO HtmlLabelIndex values(125007,'对应OA系统考勤表中的考勤时间，时间格式：09:31、14:04（该字段必填）') 
GO
INSERT INTO HtmlLabelInfo VALUES(125007,'对应OA系统考勤表中的考勤时间，时间格式：09:31、14:04（该字段必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125007,'Time attendance, attendance system corresponding to the OA table in time format: 09:31, 14:04 (the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125007,'對應OA系統考勤表中的考勤時間，時間格式：09:31、14:04（該字段必填）',9) 
GO

delete from HtmlLabelIndex where id=125008 
GO
delete from HtmlLabelInfo where indexid=125008 
GO
INSERT INTO HtmlLabelIndex values(125008,'对应OA系统考勤表中的IP地址，用于标识用户是在哪个打卡机上打的卡（该字段非必填，但模板中请勿删除）') 
GO
INSERT INTO HtmlLabelInfo VALUES(125008,'对应OA系统考勤表中的IP地址，用于标识用户是在哪个打卡机上打的卡（该字段非必填，但模板中请勿删除）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125008,'Corresponding OA system in the attendance table IP address for user identification is playing cards in which the punch card machines (the field is not required, but the template, please do not delete)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125008,'對應OA系統考勤表中的IP地址，用于标識用戶是在哪個打卡機上打的卡（該字段非必填，但模闆中請勿删除）',9) 
GO

delete from HtmlLabelIndex where id=125010 
GO
delete from HtmlLabelInfo where indexid=125010 
GO
INSERT INTO HtmlLabelIndex values(125010,'组织调整操作统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(125010,'组织调整操作统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125010,'Organization adjustment operation statistics',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125010,'組織調整操作統計',9) 
GO

delete from HtmlLabelIndex where id=125011 
GO
delete from HtmlLabelInfo where indexid=125011 
GO
INSERT INTO HtmlLabelIndex values(125011,'权限调整操作统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(125011,'权限调整操作统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125011,'Authority adjustment operation statistics',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125011,'權限調整操作統計',9) 
GO

delete from HtmlLabelIndex where id=32687 
GO
delete from HtmlLabelInfo where indexid=32687 
GO
INSERT INTO HtmlLabelIndex values(32687,'默认设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(32687,'默认设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32687,'The default settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32687,'默認設置',9) 
GO

delete from HtmlLabelIndex where id=125012 
GO
delete from HtmlLabelInfo where indexid=125012 
GO
INSERT INTO HtmlLabelIndex values(125012,'查看范围设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(125012,'查看范围设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125012,'View range settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125012,'查看範圍設置',9) 
GO

delete from HtmlLabelIndex where id=125013 
GO
delete from HtmlLabelInfo where indexid=125013 
GO
INSERT INTO HtmlLabelIndex values(125013,'查看对象设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(125013,'查看对象设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125013,'View object settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125013,'查看對象設置',9) 
GO

delete from HtmlLabelIndex where id=125014 
GO
delete from HtmlLabelInfo where indexid=125014 
GO
INSERT INTO HtmlLabelIndex values(125014,'请至少选择一条数据!') 
GO
INSERT INTO HtmlLabelInfo VALUES(125014,'请至少选择一条数据!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125014,'Please select at least one of the data!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125014,'請至少選擇一條數據!',9) 
GO

delete from HtmlLabelIndex where id=125015 
GO
delete from HtmlLabelInfo where indexid=125015 
GO
INSERT INTO HtmlLabelIndex values(125015,'数据删除成功!') 
GO
INSERT INTO HtmlLabelInfo VALUES(125015,'数据删除成功!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125015,'Data deletion success!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125015,'數據删除成功!',9) 
GO
 
delete from HtmlLabelIndex where id=125016 
GO
delete from HtmlLabelInfo where indexid=125016 
GO
INSERT INTO HtmlLabelIndex values(125016,'数据删除失败!') 
GO
INSERT INTO HtmlLabelInfo VALUES(125016,'数据删除失败!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125016,'Data deletion failed!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125016,'數據删除失敗!',9) 
GO

delete from HtmlLabelIndex where id=125017 
GO
delete from HtmlLabelInfo where indexid=125017 
GO
INSERT INTO HtmlLabelIndex values(125017,'服务器异常!') 
GO
INSERT INTO HtmlLabelInfo VALUES(125017,'服务器异常!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125017,'Server exception!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125017,'服務器異常!',9) 
GO

delete from HtmlNoteIndex where id=4010 
GO
delete from HtmlNoteInfo where indexid=4010 
GO
INSERT INTO HtmlNoteIndex values(4010,'数据保存成功!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4010,'数据保存成功!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4010,'Data preservation success!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4010,'數據保存成功!',9) 
GO

delete from HtmlNoteIndex where id=4011 
GO
delete from HtmlNoteInfo where indexid=4011 
GO
INSERT INTO HtmlNoteIndex values(4011,'数据保存失败!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4011,'数据保存失败!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4011,'Data save failed!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4011,'數據保存失敗!',9) 
GO

delete from HtmlNoteIndex where id=4012 
GO
delete from HtmlNoteInfo where indexid=4012 
GO
INSERT INTO HtmlNoteIndex values(4012,'显示名不能为空!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4012,'显示名不能为空!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4012,'Display name can not be empty!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4012,'顯示名不能爲空!',9) 
GO

delete from HtmlNoteIndex where id=4013 
GO
delete from HtmlNoteInfo where indexid=4013 
GO
INSERT INTO HtmlNoteIndex values(4013,'字段名只能包含字母和数字，不能含中文!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4013,'字段名只能包含字母和数字，不能含中文!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4013,'Field names can only contain letters and numbers, not chinese!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4013,'字段名隻能包含字母和數字，不能含中文!',9) 
GO

delete from HtmlNoteIndex where id=4014 
GO
delete from HtmlNoteInfo where indexid=4014 
GO
INSERT INTO HtmlNoteIndex values(4014,'字段名不能重名!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4014,'字段名不能重名!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4014,'Field names must be unique!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4014,'字段名不能重名!',9) 
GO

delete from HtmlNoteIndex where id=4015 
GO
delete from HtmlNoteInfo where indexid=4015 
GO
INSERT INTO HtmlNoteIndex values(4015,'自定义浏览框不能为空!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4015,'自定义浏览框不能为空!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4015,'Custom browse box can not be empty!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4015,'自定義浏覽框不能爲空!',9) 
GO

delete from HtmlNoteIndex where id=4016 
GO
delete from HtmlNoteInfo where indexid=4016 
GO
INSERT INTO HtmlNoteIndex values(4016,'字段名不能为空!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4016,'字段名不能为空!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4016,'Field name cannot be empty!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4016,'字段名不能爲空!',9) 
GO

delete from HtmlLabelIndex where id=125018 
GO
delete from HtmlLabelInfo where indexid=125018 
GO
INSERT INTO HtmlLabelIndex values(125018,'邮箱地址的格式不正确或为空') 
GO
INSERT INTO HtmlLabelInfo VALUES(125018,'邮箱地址的格式不正确或为空',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125018,'The format of the mailbox address is not correct or empty',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125018,'郵箱地址的格式不正确或爲空',9) 
GO