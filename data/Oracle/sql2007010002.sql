
delete from workflow_browserurl
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (1, 179, 'integer', '/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp', 'HrmResource', 'lastname', 'id', '/hrm/resource/HrmResource.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL)
 Values
   (2, 97, 'char(10)', '/systeminfo/Calendar.jsp')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (3, 779, 'integer', '/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2 and capitalgroupid=16', 'CptCapital', 'name', 'id', '/cpt/capital/CptCapital.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (4, 124, 'integer', '/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp', 'HrmDepartment', 'concat(concat(departmentmark,''-''),departmentname)', 'id', '/hrm/company/HrmDepartmentDsp.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (5, 711, 'integer', '/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcWarehouseBrowser.jsp', 'LgcWarehouse', 'warehousename', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (6, 515, 'integer', '/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp', 'HrmCostcenter', 'concat(concat(costcentermark,''-''),costcentername)', 'id', '/hrm/company/HrmCostcenterDsp.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (7, 136, 'integer', '/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp', 'CRM_CustomerInfo', 'name', 'id', '/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (8, 101, 'integer', '/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp', 'Prj_ProjectInfo', 'name', 'id', '/proj/data/ViewProject.jsp?isrequest=1&ProjID=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (9, 58, 'integer', '/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1', 'DocDetail', 'docsubject', 'id', '/docs/docs/DocDsp.jsp?isrequest=1&id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (10, 754, 'integer', '/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcStockModeBrowser.jsp?mode=1', 'LgcStockMode', 'modename', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (11, 762, 'integer', '/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcStockModeBrowser.jsp?mode=2', 'LgcStockMode', 'modename', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (12, 406, 'integer', '/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp', 'FnaCurrency', 'currencyname', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (13, 15106, 'integer', '/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp', 'LgcAssetAssortment', 'assortmentname', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (14, 777, 'integer', '/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaLedgerAllBrowser.jsp', 'FnaLedger', 'ledgername', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (15, 778, 'integer', '/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaLedgerBrowser.jsp', 'FnaLedger', 'ledgername', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (16, 648, 'integer', '/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1', 'workflow_requestbase', 'requestname', 'requestid', '/workflow/request/ViewRequest.jsp?isrequest=1&requestid=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (17, 839, 'varchar2(4000)', '/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp', 'HrmResource', 'lastname', 'id', '/hrm/resource/HrmResource.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (18, 840, 'varchar2(4000)', '/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp', 'CRM_CustomerInfo', 'name', 'id', '/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL)
 Values
   (19, 277, 'char(5)', '/systeminfo/Clock.jsp')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (20, 842, 'integer', '/systeminfo/BrowserMain.jsp?url=/proj/plan/PlanTypeBrowser.jsp', 'Prj_PlanType', 'fullname', 'id', '/proj/Maint/EditPlanType.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (21, 843, 'integer', '/systeminfo/BrowserMain.jsp?url=/proj/plan/PlanSortBrowser.jsp', 'Prj_PlanSort', 'fullname', 'id', '/proj/Maint/EditPlanSort.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (22, 854, 'integer', '/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype=to_char(1)', 'FnaBudgetfeeType', 'name', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (23, 535, 'integer', '/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp', 'CptCapital', 'name', 'id', '/cpt/capital/CptCapital.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (24, 357, 'integer', '/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp', 'HrmJobTitles', 'jobtitlename', 'id', '/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (25, 831, 'integer', '/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp', 'CptCapitalAssortment', 'assortmentname', 'id', '/cpt/maintenance/CptAssortment.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (26, 920, 'integer', '/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2 and capitalgroupid=9', 'CptCapital', 'name', 'id', '/cpt/capital/CptCapital.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (27, 1932, 'varchar2(4000)', '/systeminfo/BrowserMain.jsp?url=/hrm/career/MutiCareerBrowser.jsp', 'HrmCareerApply', 'concat(lastname,firstname)', 'id', '/hrm/career/HrmCareerApplyEdit.jsp?applyid=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (28, 2103, 'integer', '/systeminfo/BrowserMain.jsp?url=', 'Meeting', 'name', 'id', '/meeting/data/ViewMeeting.jsp?isrequest=1&meetingid=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (29, 6099, 'int', '/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp?awardtype=0', 'HrmAwardType', 'name', 'id', '/hrm/award/HrmAwardTypeEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (30, 818, 'int', '/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp', 'HrmEducationLevel', 'name', 'id', '/hrm/educationlevel/HrmEduLevelEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (31, 804, 'int', '/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp', 'HrmUseKind', 'name', 'id', '/hrm/usekind/HrmUseKindEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (32, 6156, 'int', '/systeminfo/BrowserMain.jsp?url=/hrm/train/trainplan/HrmTrainPlanBrowser.jsp', 'HrmTrainPlan', 'planname', 'id', '/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (33, 6159, 'int', '/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp?difftype=0', 'HrmScheduleDiff', 'diffname', 'id', '/hrm/schedule/HrmScheduleDiffEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (34, 1881, 'int', '/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp?difftype=1', 'HrmScheduleDiff', 'diffname', 'id', '/hrm/schedule/HrmScheduleDiffEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (35, 6160, 'integer', '/systeminfo/BrowserMain.jsp?url=/CRM/data/ContractBrowser.jsp?status=0', 'CRM_Contract', 'name', 'id', '/CRM/data/ContractView.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (36, 6083, 'integer', '/systeminfo/BrowserMain.jsp?url=/CRM/data/ContractTypeBrowser.jsp', 'CRM_ContractType', 'name', 'id', '/CRM/Maint/CRMContractTypeList.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (37, 6163, 'varchar2(4000)', '/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp', 'DocDetail', 'docsubject', 'id', '/docs/docs/DocDsp.jsp?isrequest=1&id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (38, 6166, 'int', '/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp', 'LgcAssetCountry', 'assetname', 'assetid ', '/lgc/asset/LgcAsset.jsp?paraid=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (52, 16973, 'integer', '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docKindBrowser.jsp', 'DocSendDocKind', 'name', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (53, 15534, 'integer', '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docInstancyLevelBrowser.jsp', 'DocInstancyLevel', 'name', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (54, 16972, 'integer', '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docSecretLevelBrowser.jsp', 'docSecretLevel', 'name', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (55, 16980, 'integer', '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/docNumberBrowser.jsp', 'DocSendDocNumber', 'name', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (56, 16989, 'varchar2(100)', '/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/systemIpBrowser.jsp', 'systemIp', 'name', 'id', '/docs/sendDoc/systemIp.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (57, 17006, 'varchar2(100)', '/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp', 'HrmDepartment', 'departmentmark', 'id', '/hrm/company/HrmDepartmentDsp.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (58, 493, 'integer', '/systeminfo/BrowserMain.jsp?url=/web/broswer/CityBrowser.jsp', 'HrmCity', 'cityname', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (59, 462, 'integer', '/systeminfo/BrowserMain.jsp?url=/web/broswer/ContacterTitleBrowser.jsp', 'CRM_ContacterTitle', 'fullname', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (60, 1282, 'integer', '/systeminfo/BrowserMain.jsp?url=/web/broswer/CustomerTypeBrowser.jsp', 'CRM_ContractType', 'name', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (61, 1283, 'integer', '/systeminfo/BrowserMain.jsp?url=/web/broswer/CustomerDescBrowser.jsp', 'CRM_CustomerDesc', 'fullname', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (62, 1285, 'integer', '/systeminfo/BrowserMain.jsp?url=/web/broswer/CustomerSizeBrowser.jsp', 'CRM_CustomerSize', 'fullname', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (63, 575, 'integer', '/systeminfo/BrowserMain.jsp?url=/web/broswer/SectorInfoBrowser.jsp', 'CRM_SectorInfo', 'fullname', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (64, 17065, 'varchar2(200)', '/systeminfo/BrowserMain.jsp?url=/web/mailList/MailListBrowser.jsp', 'webMailList', 'name', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (87, 780, 'int', '/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp', 'MeetingRoom', 'name', 'id', '/meeting/Maint/MeetingRoom.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (89, 2104, 'integer', '/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingTypeBrowser.jsp', 'Meeting_Type', 'name', 'id', '/meeting/Maint/ListMeetingType.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (65, 17083, 'varchar2(4000)', '/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp', 'HrmRoles', 'RolesName', 'ID', '/hrm/roles/HrmRolesEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, BROWSERURL)
 Values
   (118, 17546, '\meeting\maint\blankMeentingRoomBrowser.jsp')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME)
 Values
   (119, 803, 'int', '/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp', 'HrmSpeciality', 'name', 'id')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (69, 705, 'integer', '/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp', 'LgcAssetUnit', 'unitname', 'id', '/lgc/maintenance/LgcAssetUnitEdit.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (124, 407, 'integer', '/systeminfo/BrowserMain.jsp?url=/hrm/performance/targetPlan/WorkPlanGroupBrowser.jsp', 'WorkPlanGroup', 'planName', 'id', '/hrm/performance/targetPlan/PlanList.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (125, 330, 'integer', '/systeminfo/BrowserMain.jsp?url=/htm/performance/goal/goalGroupBrowser.jsp', 'BPMGoalGroup', 'goalName', 'id', '/hrm/performance/goal/myGoalListIframe.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (126, 351, 'integer', '/systeminfo/BrowserMain.jsp?url=/htm/performance/report/HrmPerformanceReportGroupBrowser.jsp', 'GradeGroup', 'gradeName', 'id', '/hrm/performance/targetCheck/GradeList.jsp?id=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (129, 18375, 'integer', '/systeminfo/BrowserMain.jsp?url=/proj/Templet/TempletBrowser.jsp', 'Prj_Template', 'templetName', 'id', '/proj/Templet/ProjTempletView.jsp?templetId=')
/
Insert into workflow_browserurl
   (ID, LABELID, FIELDDBTYPE, BROWSERURL, TABLENAME, COLUMNAME, KEYCOLUMNAME, LINKURL)
 Values
   (135, 18434, 'text', '/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp', 'Prj_ProjectInfo', 'name', 'id', '/proj/data/ViewProject.jsp?isrequest=1&ProjID=')
/
