

/*以下是杨国生《ecology产品开发工作流增加产品浏览框提交测试报告》的脚本*/

/* 增加工作流浏览框 */
insert into HtmlLabelIndex (id,indexdesc) values (6166	,'相关产品')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6166,'相关产品',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6166,'',8)
GO

INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 6166,'int','/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp','LgcAssetCountry','assetname','assetid','/lgc/asset/LgcAsset.jsp?paraid=')
GO



/*以下是陈英杰《Ecology－产品开发人力资源bug修改(20030725)提交测试报告》的脚本*/

insert into HrmUserDefine (
	userid,
	hasresourceid,
	hasresourcename,
	hasjobtitle,
	hasactivitydesc,
	hasjobgroup,
	hasjobactivity,
	hascostcenter,
	hascompetency,
	hasresourcetype,
	hasstatus,
	hassubcompany,
	hasdepartment,
	haslocation,
	hasmanager,
	hasassistant,
	hasroles,
	hasseclevel,
	hasjoblevel,
	hasworkroom,
	hastelephone,
	hasstartdate,
	hasenddate,
	hascontractdate,
	hasbirthday,
	hassex,
	projectable,
	crmable,
	itemable,
	docable,
	workflowable,
	subordinateable,
	trainable,
	budgetable,
	fnatranable,
	dspperpage,
	hasage,
	hasworkcode,
	hasjobcall,
	hasmobile,
	hasmobilecall,
	hasfax,
	hasemail,
	hasfolk,
	hasregresidentplace,
	hasnativeplace,
	hascertificatenum,
	hasmaritalstatus,
	haspolicy,
	hasbememberdate,
	hasbepartydate,
	hasislabouunion,
	haseducationlevel,
	hasdegree,
	hashealthinfo,
	hasheight,
	hasweight,
	hasresidentplace,
	hashomeaddress,
	hastempresidentnumber,
	hasusekind,
	hasbankid1,
	hasaccountid1,
	hasaccumfundaccount,
	hasloginid,
	hassystemlanguage)
values(-1,' ','1','1','1','1','1',' ',' ',' ','1','1','1','1','1','1',' ',' ','1','1','1',' ',' ',' ',' ','1','1','1','1','1','1','1',' ','1','1',10,' ','1','1','1','1','1','1',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ')
go
