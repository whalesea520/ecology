delete from HtmlLabelIndex where id=128512 
GO
delete from HtmlLabelInfo where indexid=128512 
GO
INSERT INTO HtmlLabelIndex values(128512,'导出所选目录及所有下级目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(128512,'导出所选目录及所有下级目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128512,'Export the selected directory and all the lower directories',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128512,'導出所選目錄及所有下級目錄',9) 
GO


delete from HtmlLabelIndex where id=128514 
GO
delete from HtmlLabelInfo where indexid=128514 
GO
INSERT INTO HtmlLabelIndex values(128514,'仅导出所选目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(128514,'仅导出所选目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128514,'Export the selected directory only',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128514,'僅導出所選目錄',9) 
GO


delete from HtmlLabelIndex where id=128515 
GO
delete from HtmlLabelInfo where indexid=128515 
GO
INSERT INTO HtmlLabelIndex values(128515,'导出当前目录及所有下级目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(128515,'导出当前目录及所有下级目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128515,'Export the current directory and all the lower directories',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128515,'導出當前目錄及所有下級目錄',9) 
GO


delete from HtmlLabelIndex where id=128516 
GO
delete from HtmlLabelInfo where indexid=128516 
GO
INSERT INTO HtmlLabelIndex values(128516,'仅导出当前目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(128516,'仅导出当前目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128516,'Export only the current directory',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128516,'僅導出當前目錄',9) 
GO


delete from HtmlLabelIndex where id=128517 
GO
delete from HtmlLabelInfo where indexid=128517 
GO
INSERT INTO HtmlLabelIndex values(128517,'请选择需要导出的内容：') 
GO
INSERT INTO HtmlLabelInfo VALUES(128517,'请选择需要导出的内容：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128517,'Please select the content that needs to be exported:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128517,'請選擇需要導出的内容：',9) 
GO


delete from HtmlLabelIndex where id=128518 
GO
delete from HtmlLabelInfo where indexid=128518 
GO
INSERT INTO HtmlLabelIndex values(128518,'对系统已有目录进行更新') 
GO
INSERT INTO HtmlLabelInfo VALUES(128518,'对系统已有目录进行更新',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128518,'Update the existing directory of the system',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128518,'對系統已有目錄進行更新',9) 
GO


delete from HtmlLabelIndex where id=128519 
GO
delete from HtmlLabelInfo where indexid=128519 
GO
INSERT INTO HtmlLabelIndex values(128519,'导入模板里填写的目录如在系统中已存在，可选择是否更新目录数据。启用意为更新，不启用则跳过不导入。') 
GO
INSERT INTO HtmlLabelInfo VALUES(128519,'导入模板里填写的目录如在系统中已存在，可选择是否更新目录数据。启用意为更新，不启用则跳过不导入。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128519,'Import template to fill in the directory, such as the system already exists, you can choose whether to update the directory data. Enable means to update, do not enable skip is not imported.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128519,'導入模闆裏填寫的目錄如在系統中已存在，可選擇是否更新目錄數據。啓用意爲更新，不啓用則跳過不導入。',9) 
GO

delete from HtmlLabelIndex where id=128520 
GO
delete from HtmlLabelInfo where indexid=128520 
GO
INSERT INTO HtmlLabelIndex values(128520,'填写模板数据后将文件上传。') 
GO
INSERT INTO HtmlLabelInfo VALUES(128520,'填写模板数据后将文件上传。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128520,'After completing the template data will be uploaded to the file.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128520,'填寫模闆數據後将文件上傳。',9) 
GO


delete from HtmlLabelIndex where id=128521 
GO
delete from HtmlLabelInfo where indexid=128521 
GO
INSERT INTO HtmlLabelIndex values(128521,'【文档目录】字段为必填，其他字段不填写时，导入取默认值。') 
GO
INSERT INTO HtmlLabelInfo VALUES(128521,'【文档目录】字段为必填，其他字段不填写时，导入取默认值。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128521,'[document directory] fields are required, other fields are not complete, the default value of import.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128521,'【文檔目錄】字段爲必填，其他字段不填寫時，導入取默認值。',9) 
GO


delete from HtmlLabelIndex where id=128522 
GO
delete from HtmlLabelInfo where indexid=128522 
GO
INSERT INTO HtmlLabelIndex values(128522,'【文档目录】按目录层级填写，中间用“/”分隔，格式为“1级目录/2级目录/3级目录…”。') 
GO
INSERT INTO HtmlLabelInfo VALUES(128522,'【文档目录】按目录层级填写，中间用“/”分隔，格式为“1级目录/2级目录/3级目录…”。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128522,'[document catalogue] according to the level of the directory to fill in the middle with "/" separation, the format for the 1 directory /2 directory /3...".',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128522,'【文檔目錄】按目錄層級填寫，中間用“/”分隔，格式爲“1級目錄/2級目錄/3級目錄…”。',9) 
GO


delete from HtmlLabelIndex where id=128523 
GO
delete from HtmlLabelInfo where indexid=128523 
GO
INSERT INTO HtmlLabelIndex values(128523,'【默认虚拟目录】按目录层级填写，中间用“/”分隔，格式为“root/1级目录/2级目录/3级目录…”，如root下有虚拟目录“Ecology”则填写为“root/Ecology”即可。') 
GO
INSERT INTO HtmlLabelInfo VALUES(128523,'【默认虚拟目录】按目录层级填写，中间用“/”分隔，格式为“root/1级目录/2级目录/3级目录…”，如root下有虚拟目录“Ecology”则填写为“root/Ecology”即可。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128523,'[default virtual directory] according to the level of the directory to fill in the middle with "/" separated, format for "root/1 directory /2 directory /3..." , such as root under the virtual directory "Ecology" is filled in as "root/Ecology" can be.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128523,'【默認虛拟目錄】按目錄層級填寫，中間用“/”分隔，格式爲“root/1級目錄/2級目錄/3級目錄…”，如root下有虛拟目錄“Ecology”則填寫爲“root/Ecology”即可。',9) 
GO



delete from HtmlLabelIndex where id=128524 
GO
delete from HtmlLabelInfo where indexid=128524 
GO
INSERT INTO HtmlLabelIndex values(128524,'其他字段按列头的选项提示进行填写。') 
GO
INSERT INTO HtmlLabelInfo VALUES(128524,'其他字段按列头的选项提示进行填写。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128524,'Other fields are indicated by the options of the column header.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128524,'其他字段按列頭的選項提示進行填寫。',9) 
GO


delete from HtmlLabelIndex where id=128525 
GO
delete from HtmlLabelInfo where indexid=128525 
GO
INSERT INTO HtmlLabelIndex values(128525,'【新建工作流指定流程】、【打印申请流程】两个字段不在导入模板中，如有需要请导入完成后手动填写。') 
GO
INSERT INTO HtmlLabelInfo VALUES(128525,'【新建工作流指定流程】、【打印申请流程】两个字段不在导入模板中，如有需要请导入完成后手动填写。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128525,'[new workflow specified process], [printing application process] two fields are not imported into the template, if necessary, please fill in the completion of the completion of the manual.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128525,'【新建工作流指定流程】、【打印申請流程】兩個字段不在導入模闆中，如有需要請導入完成後手動填寫。',9) 
GO


delete from HtmlLabelIndex where id=128526 
GO
delete from HtmlLabelInfo where indexid=128526 
GO
INSERT INTO HtmlLabelIndex values(128526,'【对系统已有目录进行更新】默认不开启，当导入模板存在系统已有目录时将不进行导入，如果开启该开关，则导入时对系统已有目录进行更新。') 
GO
INSERT INTO HtmlLabelInfo VALUES(128526,'【对系统已有目录进行更新】默认不开启，当导入模板存在系统已有目录时将不进行导入，如果开启该开关，则导入时对系统已有目录进行更新。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128526,'The system has an existing directory to update the default does not open, when the import template system has the existing directory will not be imported, if the switch is turned on, the system has been updated to update the system.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128526,'【對系統已有目錄進行更新】默認不開啓，當導入模闆存在系統已有目錄時将不進行導入，如果開啓該開關，則導入時對系統已有目錄進行更新。',9) 
GO


delete from HtmlLabelIndex where id=128527 
GO
delete from HtmlLabelInfo where indexid=128527 
GO
INSERT INTO HtmlLabelIndex values(128527,'请选择正确的模板导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(128527,'请选择正确的模板导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128527,'Please select the correct template to import',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128527,'請選擇正确的模闆導入',9) 
GO


delete from HtmlLabelIndex where id=128528 
GO
delete from HtmlLabelInfo where indexid=128528 
GO
INSERT INTO HtmlLabelIndex values(128528,'请使用模板文件！') 
GO
INSERT INTO HtmlLabelInfo VALUES(128528,'请使用模板文件！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128528,'Please use the template file!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128528,'請使用模闆文件！',9) 
GO


delete from HtmlLabelIndex where id=128529 
GO
delete from HtmlLabelInfo where indexid=128529 
GO
INSERT INTO HtmlLabelIndex values(128529,'以下') 
GO
INSERT INTO HtmlLabelInfo VALUES(128529,'以下',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128529,'The following',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128529,'以下',9) 
GO


delete from HtmlLabelIndex where id=128530 
GO
delete from HtmlLabelInfo where indexid=128530 
GO
INSERT INTO HtmlLabelIndex values(128530,'行导入失败:') 
GO
INSERT INTO HtmlLabelInfo VALUES(128530,'行导入失败:',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128530,'line import failed:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128530,'行導入失敗:',9) 
GO

