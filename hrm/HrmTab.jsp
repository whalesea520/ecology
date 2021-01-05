
<%@page import="weaver.filter.XssUtil"%>
<%@page import="weaver.formmode.cuspage.cpt.Cpt4modeUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.common.StringUtil"%>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.login.Account,
								 weaver.login.VerifyLogin,
								 weaver.hrm.common.*,
                 weaver.general.GCONST" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO"%>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO"%>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class = "weaver.hrm.company.CompanyComInfo" scope = "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo"></jsp:useBean>
<jsp:useBean id="HrmResourceBaseTabComInfo" class="weaver.hrm.resource.HrmResourceBaseTabComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="AppDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
	<%
	String titlename = "";
	%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
HashMap<String,String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String(kv.get("_fromURL"));//来源
String cmd = Util.null2String(kv.get("cmd"));
String method = Util.null2String(kv.get("method"));
String companyid = "1";
String mouldid = "resource";

int detachable=0;
if(session.getAttribute("detachable")!=null){
    detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
}else{
    rs.executeSql("select detachable from SystemSet");
    if(rs.next()){
        detachable=rs.getInt("detachable");
        session.setAttribute("detachable",String.valueOf(detachable));
    }
}

//分权管理员也要进入管理员卡片
boolean isdetach = false;
if(detachable==1){
	String id = Util.null2String(request.getParameter("id"));
	if(id.equals("")) id=String.valueOf(user.getUID());
	String sqlUid = "select count(*) cnt from HrmResourceManager where id="+id;
	rs.executeSql(sqlUid);
	if(rs.next() && rs.getInt("cnt") > 0){
		isdetach = true;
	}
}
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/messagejs/messagejs_wev8.js"></script>
<SCRIPT language="javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript">
function showMyTree(){
	jQuery("#e8_tablogo").click();
} 

var myCurrentindex = 0;
function setMyCurrentLi(){
	jQuery("li").removeClass("current");
	jQuery(jQuery("li")[myCurrentindex]).addClass("current");
}

function refreshTab(){
	jQuery('.flowMenusTd',parent.document).toggle();
	jQuery('.leftTypeSearch',parent.document).toggle();
} 

function viewHrm(id){
	var url ="";
	if(id=="1"){
		url = "/hrm/HrmTab.jsp?_fromURL=HrmSysAdminBasic&id="+id;
	}else{
		url = "/hrm/HrmTab.jsp?_fromURL=HrmResourceBase&id="+id;
	}
	<%if(isdetach){%>
	url = "/hrm/HrmTab.jsp?_fromURL=HrmSysAdminBasic&id="+id;
	<%}%>
	openFullWindowForXtable(url,800,600);
}

//人事状态变更使用
function jsShow(url){
 	var resourceid = "";
 	resourceid = jQuery("#tabcontentframe").contents().find("input[name='resourceid']").val();
	if(typeof(resourceid) == "undefined"){
 		resourceid = jQuery("#tabcontentframe").contents().find("input[name='fromid']").val();
	}
 	url += "?resourceid="+resourceid;
 	jQuery("#tabcontentframe").attr("src",url);
}

function onBtnSearchClick(){
	parent.location.reload();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function viewJobtitle(jobtitle) {
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
	url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesEdit&id="+jobtitle;
	dialog.Width = 700;
	dialog.Height = 593;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function viewDepartment(departmentid) {
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id="+departmentid)
}

function viewSubCompany(subcompanyid) {
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmSubCompanyDsp&id="+subcompanyid)
}
</script>
<!-- 人力资源基础tab页 -->
<%
	LinkedHashMap<String,String> tabInfo = new LinkedHashMap<String,String>();
	int title = 0;
	boolean hasTree = false;//是否有树形导航
	boolean showDiv = true;
	String url = "";
	boolean isShowRewardsRecord = false;
	ShowTab tab = new ShowTab(rs,user);
	if(_fromURL.equals("SystemRightGroup")){
		//后端设置--权限设置
		if(cmd.equals("SystemRightAuthority")){
			title = 33363;
			url = "/systeminfo/systemright/SystemRightAuthority.jsp?isdialog=0";
		}else{
			title = 16526;
			url = "/systeminfo/systemright/SystemRightGroup.jsp";
		}
	}else if(_fromURL.equals("HrmRightTransfer")){
		//后端设置--权限调整
		title = 34238;
		url = "/hrm/transfer/HrmRightTransfer.jsp";
	}else if(_fromURL.equals("HrmRightCopy")){
		//后端设置--权限复制
		title = 34031;
		url = "/hrm/transfer/HrmRightCopy.jsp";
	}else if(_fromURL.equals("HrmRoles")){
		//后端设置--角色设置
		title = 16527;
		String subcompanyid=Util.null2String(request.getParameter("subCompanyId"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/hrm/roles/HrmRoles.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid;
	}else if(_fromURL.equals("HrmSecuritySetting")){
		//中端设置--安全设置
		title = 32496;
		url = "/hrm/setting/HrmSecuritySetting.jsp";




	}else if(_fromURL.equals("location")){
		//中端设置--办公地点
		title = 378;
		url = "/hrm/location/HrmLocation.jsp";
	}else if(_fromURL.equals("jobactivitiesSet")){
		//中端设置--职务设置索引
		title = 16460;
		url = "/hrm/jobactivities/index.jsp";
	}else if(_fromURL.equals("jobactivities")){
		//中端设置--职务设置
		title = 16460;
		hasTree = true;
		String jobgroup = Util.null2String(kv.get("jobgroup"));
		String jobactivite = Util.null2String(kv.get("jobactivite"));
		url = "/hrm/jobactivities/HrmJobActivities.jsp?jobgroup="+jobgroup+"&jobactivite="+jobactivite;
	}else if(_fromURL.equals("jobactivitiesView")){
		//中端设置--职务设置
		title = 16460;
		hasTree = true;
		String jobactivite = Util.null2String(kv.get("jobactivite"));
		url = "/hrm/jobactivities/HrmJobActivitiesView.jsp?id="+jobactivite;
	}else if(_fromURL.equals("jobgroup")){
		//中端设置--职务类别设置
		String jobgroup = Util.null2String(kv.get("jobgroup"));
		if(jobgroup.length()>0){
			
		}else{
			title = 805;
		}
		url = "/hrm/jobgroups/HrmJobGroups.jsp?jobgroup="+jobgroup;
	}else if(_fromURL.equals("jobgrouptemplet")){
		//中端设置--职务类别设置
		String jobgroup = Util.null2String(kv.get("jobgroup"));
		title = 805;
		url = "/hrm/jobtitlestemplet/HrmJobTitlesTemplet.jsp?jobgroup="+jobgroup;
	}else if(_fromURL.equals("jobactivitiestemplet")){
		//中端设置--职务设置
		title = 16460;
		hasTree = true;
		String jobactivite = Util.null2String(kv.get("jobactivite"));
		url = "/hrm/jobtitlestemplet/HrmJobTitlesTemplet.jsp?jobactivite="+jobactivite;
	}else if(_fromURL.equals("jobtitlestemplet")){
		//中端设置--岗位模板设置
		title = 16461;
		String jobtitles = Util.null2String(kv.get("jobtitles"));
		url = "/hrm/jobtitlestemplet/HrmJobTitlesTemplet.jsp?jobtitles="+jobtitles;
	}else if(_fromURL.equals("jobtitlestempletdsp")){
		//中端设置--岗位模板设置
		title = 16461;
		String jobtitles = Util.null2String(kv.get("jobtitles"));
		url = "/hrm/jobtitlestemplet/HrmJobTitlesTempletDsp.jsp?id="+jobtitles;
	}else if(_fromURL.equals("jobtitles")){
		//中端设置--岗位设置
		title = 16461;
		String from=Util.null2String(kv.get("from"));
		String jobgroup=Util.null2String(kv.get("jobgroup"));
		String jobactivite=Util.null2String(kv.get("jobactivite"));
		String jobtitles = Util.null2String(kv.get("jobtitles"));
		hasTree = true;
		if(from.equals("HrmDepartmentDsp"))hasTree=false;
		if(jobtitles.length()>0){
			url = "/hrm/jobtitles/HrmJobTitlesDsp.jsp?id="+jobtitles;
		}else{
			url = "/hrm/jobtitles/HrmJobTitles.jsp?from=hrmorg&jobgroup="+jobgroup+"&jobactivite="+jobactivite;
		}
	}else if(_fromURL.equals("jobcall")){
		//中端设置--职称设置
		title = 16462;
		url = "/hrm/jobcall/HrmJobCall.jsp";
	}else if(_fromURL.equals("speciality")){
		//中端设置--专业设置
		title = 16463;
		url = "/hrm/speciality/HrmSpeciality.jsp";
	}else if(_fromURL.equals("educationlevel")){
		//中端设置--学历设置
		title = 16464;
		url = "/hrm/educationlevel/HrmEduLevel.jsp";
	}else if(_fromURL.equals("usekind")){
		//中端设置--用工性质
		title = 804;
		url = "/hrm/usekind/HrmUseKind.jsp";
	}else if(_fromURL.equals("useDemand")){
		//中端设置--招聘管理--用工需求
		title = 6131;
		url = "/hrm/career/usedemand/HrmUseDemand.jsp?status=0";
	}else if(_fromURL.equals("careerPlan")){
		//中端设置--招聘管理--招聘计划
		title = 6132;
		url = "/hrm/career/careerplan/HrmCareerPlan.jsp?status=1";
	}else if(_fromURL.equals("inviteInfo")){
		//中端设置--招聘管理--招聘信息
		title = 366;
		url = "/hrm/career/inviteinfo/list.jsp";
	}else if(_fromURL.equals("applyInfo")){
		//中端设置--招聘管理--应聘库
		title = 16251;
		url = "/hrm/career/applyinfo/list.jsp?status=1";
	}else if(_fromURL.equals("hrmCountry")){
		//中端设置--设置中心--基础设置--国家设置
		title = 16522;
		mouldid = "setting";
		url = "/hrm/country/HrmCountries.jsp";
	}else if(_fromURL.equals("hrmProvince")){
		//中端设置--设置中心--基础设置--省份设置
		title = 16523;
		mouldid = "setting";
		String countryid = Util.null2String(kv.get("countryid"));
		url = "/hrm/province/HrmProvince.jsp?countryid="+countryid;
	}else if(_fromURL.equals("hrmCity")){
		//中端设置--设置中心--基础设置--城市设置
		title = 16524;
		mouldid = "setting";
		String countryid = Util.null2String(kv.get("countryid"));
		String provinceid = Util.null2String(kv.get("provinceid"));
		url = "/hrm/city/HrmCity.jsp?countryid="+countryid+"&provinceid="+provinceid;
	}else if(_fromURL.equals("hrmAreaCountry")){
		//中端设置--设置中心--基础设置--行政区域--国家
		title = 377;
		mouldid = "resource";
		String countryid = Util.null2String(kv.get("countryid"));
		url = "/hrm/area/HrmCountry.jsp?countryid="+countryid;
	}else if(_fromURL.equals("hrmAreaProvince")){
		//中端设置--设置中心--基础设置--行政区域--省份
		title = 800;
		mouldid = "resource";
		String countryid = Util.null2String(kv.get("countryid"));
		url = "/hrm/area/HrmProvinceList.jsp?countryid="+countryid;
	}else if(_fromURL.equals("hrmAreaCity")){
		//中端设置--设置中心--基础设置--行政区域--城市设置
		title = 493;
		mouldid = "resource";
		String countryid = Util.null2String(kv.get("countryid"));
		String provinceid = Util.null2String(kv.get("provinceid"));
		url = "/hrm/area/HrmCityList.jsp?countryid="+countryid+"&provinceid="+provinceid;
	}else if(_fromURL.equals("HrmAreaCityTwo")){
		//中端设置--设置中心--基础设置--行政区域--区县设置
		String citytwoid = Util.null2String(request.getParameter("citytwoid"));
		String cityid = Util.null2String(request.getParameter("cityid"));
		title = 25223;
		mouldid = "resource";
		url = "/hrm/area/HrmCityTwo.jsp?citytwoid="+citytwoid+"&cityid="+cityid;
	}else if(_fromURL.equals("fnaCurrencies")){
		//中端设置--设置中心--基础设置--币种设置
		title = 16525;
		mouldid = "setting";
		url = "/fna/maintenance/FnaCurrencies.jsp";
	}else if(_fromURL.equals("lgcAssetUnit")){
		//中端设置--设置中心--基础设置--单位设置
		title = 16511;
		mouldid = "setting";
		url = "/lgc/maintenance/LgcAssetUnit.jsp";
	}else if(_fromURL.equals("licenseInfo")){
		//中端设置--设置中心--基础设置--授权信息
		title = 18014;
		mouldid = "setting";
		url = "/system/licenseInfo.jsp";
	}else if(_fromURL.equals("hrmCheckItem")){
		//中端设置--奖惩考核--考核项目
		title = 6117;
		url = "/hrm/check/HrmCheckItem.jsp";
	}else if(_fromURL.equals("hrmCheckInfo")){
		//中端设置--奖惩考核--考核实施
		title = cmd.equals("15652")?6124:15656;
		url = "/hrm/actualize/HrmCheckInfo.jsp?cmd="+cmd;
	}else if(_fromURL.equals("HrmResourceRewardsRecordDetail")){
		//前端--奖惩考核--我的成绩
		String checkid = Util.null2String(request.getParameter("checkid"));
		title = 6106;
		url = "/hrm/resource/HrmResourceRewardsRecordDetail.jsp?checkid="+checkid;
	}else if(_fromURL.equals("hrmReport")){//前端--报表--人事报表
		if(cmd.equals("schedulediff")){//考勤相关
			if(method.equals("HrmScheduleDiffReport")){//考勤报表
				title = 16559;
				url = "/hrm/report/schedulediff/HrmScheduleDiffReport.jsp";
			}else if(method.equals("HrmRpAbsense")){//请假报表
				title = 16547;
				url = "/hrm/report/HrmRpAbsense.jsp";
			}else if(method.equals("HrmArrangeShiftReport")){//排班管理报表
				title = 16674;
				url = "/hrm/report/schedulediff/HrmArrangeShiftReport.jsp";
			}
		}else if(cmd.equals("hrmConst")){//统计子表
			String scopeid = Util.null2String(request.getParameter("scopeid"));
			String scopeCmd = Util.null2String(request.getParameter("scopeCmd"));
			String templateid = Util.null2String(request.getParameter("templateid"));
			if(method.equals("HrmConstRpSubSearch") && scopeid.equals("1")){//个人信息
				title = 15687;
			}else if(method.equals("HrmConstRpSubSearch") && scopeid.equals("3")){//工作信息
				title = 15688;
			}else if(method.equals("HrmCustomFieldReport") || method.equals("HrmRpSubSearch")){//自定义信息
				title = 17088;
			}
			if(scopeCmd.length()==0){
				scopeCmd = String.valueOf(title);
			}
			url = "/hrm/report/resource/"+method+".jsp?cmd="+scopeCmd+"&scopeid="+scopeid+"&templateid="+templateid;
		}else if(cmd.equals("hrmResource")){//人员状况
			if(method.equals("hrmAgeRp")){//年龄报表
				title = 16545;
			}else if(method.equals("HrmJobLevelRp")){//职级报表
				title = 16546;
			}else if(method.equals("hrmSexRp")){//性别报表
				title = 16548;
			}else if(method.equals("hrmWorkageRp")){//工龄报表
				title = 16549;
			}else if(method.equals("hrmEducationLevelRp")){//学历报表
				title = 16550;
			}else if(method.equals("HrmJobCallRp")){//职称报表
				title = 16554;
			}else if(method.equals("hrmStatusRp")){//状态报表
				title = 16555;
			}else if(method.equals("hrmUsekindRp")){//用工性质
				title = 804;
			}else if(method.equals("hrmMarriedRp")){//婚姻状况
				title = 469;
			}else if(method.equals("hrmSecLevelRp")){//安全级别
				title = 683;
			}else if(method.equals("hrmDepartmentRp")){//部门报表
				title = 16551;
			}else if(method.equals("HrmJobTitleRp")){//岗位报表
				title = 16552;
			}else if(method.equals("HrmJobActivityRp")){//职务报表
				title = 16553;
			}else if(method.equals("HrmJobGroupRp")){//职务类别
				title = 805;
			}
			url = "/hrm/report/"+method+".jsp";
		}else if(cmd.equals("hrmContract")){//合同情况
			title = 16572;
			url = "/hrm/report/contract/HrmRpContract.jsp";
		}else if(cmd.equals("hrmSalary")){//工资报表
			if(method.equals("HrmRpMonthSalarySum")){//时间工资汇总
				title = 17537;
			}else if(method.equals("HrmRpResourceSalarySum")){//人员工资汇总
				title = 17538;
			}
			url = "/hrm/report/"+method+".jsp";
		}else if(cmd.equals("HrmMonthAttendanceReport")){//月考勤日历报表
			title = 82801;
			url = "/hrm/report/schedulediff/HrmScheduleDiffMonthAttDetail.jsp";
		}
	}else if(_fromURL.equals("systemLog")){//前端--报表--系统日志
		if(cmd.equals("SysMaintenanceLog")){//人员登入日志
			title = 18168;
			url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+new XssUtil().put("where operateitem=60")+"&chartType=day&cmd=sr";
		}else if(cmd.equals("HrmOnlineRp")){//在线人数分析
			title = 31277;
			url = "/hrm/report/onlineHrm/HrmOnlineRp.jsp?chartType=day";
		}else if(cmd.equals("HrmRefuseRp")){//并发登录被限统计
			title = 31310;
			url = "/hrm/report/refuseLogin/HrmRefuseRp.jsp?chartType=day";
		}
	}else if(_fromURL.equals("HrmResourceSys")){
		//中端设置--人员系统信息批量设置
		hasTree = true;
		String departmentid=Util.null2String(request.getParameter("departmentid")) ;
		String subcompanyid1 = Util.null2String(request.getParameter("subCompanyId"));
		//String companyid=Util.null2String(request.getParameter("id")) ;
		if(departmentid.length()>0||subcompanyid1.length()>0||companyid.length()>0){
			//无需设置
		}else{
	  	title = 32510;
		}
		url = "/hrm/resource/HrmResourceSys.jsp?subcompanyid1="+subcompanyid1+"&departmentid="+departmentid+"&companyid="+companyid;
	}else if(_fromURL.equals("Security")){
		String _id = Util.null2String((String)kv.get("_id"));
		if(_id.equals("6")){
			title = 32510;
			url = "/hrm/tools/NetworkSegmentStrategy.jsp";
		}else{
			if(_id.length()==0)_id="1";
			title = 32510;
			url = "/hrm/setting/HrmSecuritySetting.jsp";
		}
	}else if(_fromURL.equals("HrmResourceTry")){
		//中端设置--人事状态变更之人员试用
		title = 17513;
		url = "/hrm/resource/HrmResourceTry.jsp";
	}else if(_fromURL.equals("HrmResourceHire")){
		//中端设置--人事状态变更之人员转正
		title = 16466;
		url = "/hrm/resource/HrmResourceHire.jsp";
	}else if(_fromURL.equals("HrmResourceExtend")){
		//中端设置--人事状态变更之人员续签
		title = 16467;
		url = "/hrm/resource/HrmResourceExtend.jsp";
	}else if(_fromURL.equals("HrmResourceRedeploy")){
		//中端设置--人事状态变更之人员调动
		title = 16468;
		url = "/hrm/resource/HrmResourceRedeploy.jsp";
	}else if(_fromURL.equals("HrmResourceDismiss")){
		//中端设置--人事状态变更之人员离职
		title = 16469;
		url = "/hrm/resource/HrmResourceDismiss.jsp";
	}else if(_fromURL.equals("HrmResourceRetire")){
		//中端设置--人事状态变更之人员退休
		title = 16470;
		url = "/hrm/resource/HrmResourceRetire.jsp";
	}else if(_fromURL.equals("HrmResourceFire")){
		//中端设置--人事状态变更之人员解聘
		title = 16472;
		url = "/hrm/resource/HrmResourceFire.jsp";
	}else if(_fromURL.equals("HrmResourceRehire")){
		//中端设置--人事状态变更之人员返聘
		title = 16471;
		url = "/hrm/resource/HrmResourceRehire.jsp";
	}else if(_fromURL.equals("HrmOnlineKqSystemSet")){
		//中端设置--在线考勤设置
		title = 33545;
		url = "/hrm/schedule/HrmOnlineKqSystemSet.jsp";
	}else if(_fromURL.equals("HrmScheduleSignImport")){
		//中端设置--外部集成考勤--考勤外部数据导入
		title = 33539;
		url = "/hrm/schedule/HrmScheduleSignImport.jsp";
	}
	else if(_fromURL.equals("HrmScheduleSignDataSourceSet")){
		//中端设置--外部集成考勤--考勤外部数据同步设置
		title = 33459;
		url = "/hrm/schedule/HrmScheduleSignDataSourceSet.jsp";
	}else if(_fromURL.equals("PSLPeriodView")){
		//中端设置--带薪病假有效期设置
		title = 131559;
	  //String companyid=Util.null2String(request.getParameter("companyid"));
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		url = "/hrm/schedule/PSLPeriodView.jsp?subcompanyid="+subcompanyid+"&companyid="+companyid;
	}else if(_fromURL.equals("PSLBatchView")){
		//中端设置--带薪病假批量处理设置
		title = 131560;
	  //String companyid=Util.null2String(request.getParameter("companyid"));
	  String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		url = "/hrm/schedule/PSLBatchView.jsp?subcompanyid="+subcompanyid+"&companyid="+companyid;
	}else if(_fromURL.equals("PSLManagementView")){
		//中端设置--带薪病假管理
		title = 131556;
	  //String companyid=Util.null2String(request.getParameter("companyid"));
	  String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
	  String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/hrm/schedule/PSLManagementView.jsp?companyid="+companyid+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&cmd="+cmd;
	}else if(_fromURL.equals("HrmOrgGroupList")){
		//中端设置--群组设置
		title = 24001;
		url = "/hrm/orggroup/HrmOrgGroupList.jsp";
	}else if(_fromURL.equals("HrmOrgGroupRelated")){
		//中端设置--群组关联设置
		title = 24662;
		String orgGroupId = Util.null2String(request.getParameter("orgGroupId"));
		url = "/hrm/orggroup/HrmOrgGroupRelated.jsp?isdialog=1&orgGroupId="+orgGroupId;
	}else if(_fromURL.equals("HrmImport")){
		//中端设置--人员导入
		title = 17887;
		url = "/hrm/resource/HrmImport.jsp?isdialog=1";
	}else if(_fromURL.equals("HrmDefaultSechedule")){
		//中端设置--考勤管理--一般工作时间
		title = 16254;
		//String companyid=Util.null2String(request.getParameter("companyid"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
	  String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
		url = "/hrm/schedule/HrmDefaultScheduleList.jsp?companyid="+companyid+"&subcompanyid1="+subcompanyid1+"&departmentid="+departmentid;
	}else if(_fromURL.equals("HrmPubHoliday")){
		//中端设置--考勤管理--工作日期调整
		title = 16750;
		url = "/hrm/schedule/HrmPubHoliday.jsp";
	}else if(_fromURL.equals("HrmArrangeShiftList")){
		//中端设置--考勤管理--排班种类
		title = 16255;
		url = "/hrm/schedule/HrmArrangeShiftList.jsp";
	}else if(_fromURL.equals("HrmScheduleDiff")){
		//中端设置--考勤管理--自定义考勤--考勤种类
		title = 6139;
		hasTree = true;
	  String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
		url = "/hrm/schedule/HrmScheduleDiff.jsp?subcompanyid="+subcompanyid1;
	}else if(_fromURL.equals("HrmScheduleMonth")){
		//中端设置--考勤管理--自定义考勤--考勤月记录
		title = 19397;
		hasTree = true;
	  String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
	  String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/hrm/schedule/HrmScheduleMonth.jsp?subcompanyid="+subcompanyid1+"&departmentid="+departmentid;
	}else if(_fromURL.equals("LeaveTypeColorEdit")){
		//中端设置--考勤管理--请假类型设置
		title = 21609;
		String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
		url = "/hrm/schedule/LeaveTypeColorEdit.jsp?subcompanyid="+subcompanyid1+"&companyid="+companyid;
	}else if(_fromURL.equals("attendanceProcessSettings")){
		//中端设置--考勤管理--考勤流程设置
		title = 82797;
		if(Util.null2String(ManageDetachComInfo.getDetachable()).equals("1")) hasTree = true;
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		url = "/hrm/attendance/hrmAttProcSet/list.jsp?subcompanyid="+subcompanyid;
	}else if(_fromURL.equals("AnnualPeriodView")){
		//中端设置--考勤管理--年假设置--年假有效期设置
		title = 21598;
		//String companyid=Util.null2String(request.getParameter("companyid"));
	  String subcompanyid=Util.null2String(request.getParameter("subcompanyid1"));
		url = "/hrm/schedule/AnnualPeriodView.jsp?subcompanyid="+subcompanyid+"&companyid="+companyid;
	}else if(_fromURL.equals("AnnualBatchView")){
		//中端设置--考勤管理--年假设置--年假批量处理规则
		title = 21599;
		//String companyid=Util.null2String(request.getParameter("companyid"));
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid1"));
		url = "/hrm/schedule/AnnualBatchView.jsp?subcompanyid="+subcompanyid+"&companyid="+companyid;
	}else if(_fromURL.equals("AnnualManagementView")){
		//中端设置--考勤管理--年假设置--年假设置
		title = 21600;
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid1"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/hrm/schedule/AnnualManagementView.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&cmd="+cmd;
	}else if(_fromURL.equals("HrmArrangeShiftMaintance")){
		//中端设置--考勤管理--排班维护
		title = 32765;
		hasTree=true;
		String departmentid=Util.null2String(request.getParameter("departmentid"));
	  String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		url = "/hrm/schedule/HrmArrangeShiftMaintance.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid;
	}else if(_fromURL.equals("paidLeave")){
		//调休管理
		hasTree = true;
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		if(cmd.equals("timeToQuery")){
			title = 82800;
			url = "/hrm/attendance/paidLeave/list.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid;
		} else {
			title = 82799;
			url = "/hrm/attendance/paidLeave/content.jsp?subcompanyid="+subcompanyid;
		}
	}else if(_fromURL.equals("company")){
		//中端--分部卡片显示设置
		title = 32471;
		url = "/hrm/company/editSubcompanyFieldBatch.jsp";
	}else if(_fromURL.equals("department")){
		//中端--部门卡片显示设置
		title = 32474;
		url = "/hrm/company/editDeptFieldBatch.jsp";
	}else if(_fromURL.equals("companyEdit")){
		//中端--组织结构
		title = 32498;
		url = "/hrm/company/HrmCompany_frm.jsp";
	}else if(_fromURL.equals("HrmCompanyDsp")){
		//中端--分部编辑
		title = 33209;
		hasTree=true;
		String id=Util.null2String(kv.get("id"));
		if(id.length()==0)id="0";
		url = "/hrm/company/HrmCompanyDsp.jsp?id="+id;
	}else if(_fromURL.equals("HrmSubCompanyDsp")){
		//中端--分部编辑
		title = 32512;
		String pHasTree = Util.null2String(kv.get("hasTree"), "true");
		hasTree = Boolean.valueOf(pHasTree);
		String id=Util.null2String(kv.get("id"));
		if(id.length()==0)id="0";
		url = "/hrm/company/HrmSubCompanyDsp.jsp?id="+id;
	}	else if(_fromURL.equals("HrmDepartmentDsp")){
		//中端--部门编辑
		title = 16289;
		String pHasTree = Util.null2String(kv.get("hasTree"), "true");
		hasTree = Boolean.valueOf(pHasTree);
		String id=Util.null2String(kv.get("id"));
		if(id.length()==0)id="0";
		url = "/hrm/company/HrmDepartmentDsp.jsp?id="+id;
	}else	if(_fromURL.equals("HrmCompanyList")){
		//总部信息 下级分部
		title = 17898;
		showDiv = false;
		String id=Util.null2String((String)kv.get("id"));
		String qname=Util.null2String((String)kv.get("qname"));
		if(id.length()==0)id="0";
		url = "/hrm/company/HrmCompanyList.jsp?id="+id+"&qname="+qname;
	}else if(_fromURL.equals("HrmSubCompanyList")){
		//分部信息 下级分部 部门
		title = 0;
		String id=Util.null2String((String)kv.get("id"));
		if(id.length()==0)id="0";
		url = "/hrm/company/HrmSubCompanyList.jsp?id="+id;
	} else if(_fromURL.equals("HrmDepartList")){
		//部门信息 下级部门 部门人员
		title = 0;
		String id=Util.null2String((String)kv.get("id"));
		if(id.length()==0)id="0";
		url = "/hrm/company/HrmDepartmentList.jsp?cmd=department&id="+id;
	}else if(_fromURL.equals("HrmValidate")){
		//中端--显示栏目
		title = 32980;
		url = "/hrm/tools/HrmValidate.jsp";
	}else if(_fromURL.equals("HrmCustomFieldManager")){
		//中端--自定义字段
		hasTree=true;		
		String id = Util.null2String(kv.get("id"),"-1");//
		if(id.length()>0){
			title = 17037;
		}else{
			title = 17037;
		}
		url = "/hrm/resource/EditHrmCustomField.jsp?id="+id;
	}else	if(_fromURL.equals("EmployeeInfoMaintenance")){
		//入职维护人设置
	  title = 32775;
		url = "/hrm/employee/EmployeeInfoMaintenance.jsp";
	}else	if(_fromURL.equals("ScheduleApplicationSetting")){
		//考勤应用设置
	  title = 128558;
		url = "/hrm/schedule/ScheduleApplicationSetting.jsp";
	}else if(_fromURL.equals("HrmResourceAdd")){
		//前端--新建人员
		hasTree = true;
		title = 15005;
		String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));
		String departmentid = Util.null2String(kv.get("departmentid"));
		url = "/hrm/resource/HrmResourceAdd.jsp?departmentid="+departmentid+"&subcompanyid1="+subcompanyid1;
	}else if(_fromURL.equals("HrmResourceSearch")){
		//前端--人员查询
		//hasTree = true;
	  title = 16418;
		url = "/hrm/search/HrmResourceSearch.jsp?_fromURL="+_fromURL;
	}else if(_fromURL.equals("HrmResourceSearchResult")){
		//前端--人员查询
		//hasTree = true;
		title = 16418;
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		//图形会有重复id情况
		if(departmentid.length()>0){
			String[] ids = Util.TokenizerString2(departmentid,",");
			List<String> ls = new ArrayList<String>();
			for(String tmpid :ids){
				if(!ls.contains(tmpid))ls.add(tmpid);
			}
			departmentid ="";
			for(String tmpid:ls){
				if(departmentid.length()>0)departmentid+=",";
				departmentid+=tmpid;
			}
		}

		String department=Util.null2String(request.getParameter("department"));//图形编辑传的是department
		if(department.length()>0)department = departmentid;
	  String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
	  String virtualtype=Util.null2String(request.getParameter("virtualtype"));

	  //String companyid=Util.null2String(request.getParameter("id"));
	  String from = Util.null2String(request.getParameter("from"));
		url = "/hrm/search/HrmResourceSearchTmp.jsp?_fromURL="+_fromURL+"&subcompany1="+subcompanyid1+"&department="+departmentid+"&companyid="+companyid+"&from="+from+"&virtualtype="+virtualtype;
	}else if(_fromURL.equals("HrmResourceSalaryLog")){
		//前端--我的卡片--工资福利
		title = 32653;
		showDiv = false;
		String resourceid = Util.null2String(request.getParameter("resourceid"));
		String from = Util.null2String(request.getParameter("from"));
		boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
		url = "/hrm/resource/HrmResourceSalaryLog.jsp?id="+resourceid+"&from="+from+"&isfromtab="+isfromtab;
	}else if(_fromURL.equals("HrmResourceChangeLog")){
		//前端--我的卡片--工资福利
		title = 32653;
		showDiv = false;
		String resourceid = Util.null2String(request.getParameter("resourceid"));
		String from = Util.null2String(request.getParameter("from"));
		boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
		url = "/hrm/resource/HrmResourceChangeLog.jsp?id="+resourceid+"&from="+from+"&isfromtab="+isfromtab;
	}else if(_fromURL.equals("HrmResourceSalaryList")){
		//前端--我的卡片--工资福利
		title = 32653;
		showDiv = false;
		String resourceid = Util.null2String(request.getParameter("resourceid"));
		String from = Util.null2String(request.getParameter("from"));
		boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
		url = "/hrm/resource/HrmResourceSalaryList.jsp?id="+resourceid+"&from="+from+"&isfromtab="+isfromtab;
	}else if(_fromURL.equals("HrmResourceView")){
		//前端--我的下属
		title = 30805;
		String id = Util.null2String(request.getParameter("id"));
		String srcid = Util.null2String(request.getParameter("srcid"));
		url = "/hrm/search/HrmResourceView.jsp?id="+id+"&srcid="+srcid;
	}else if(_fromURL.equals("HrmResourceTrainRecord")){
		//前端--我的培训
		title = 24987;
		String resourceid = Util.null2String(request.getParameter("resourceid"),user.getUID()+"");
		url = "/hrm/resource/HrmResourceTrainRecord.jsp?resourceid="+resourceid;
	}else if(_fromURL.equals("HrmResourceFinanceView")){
		//前端--我的工资\人力资源卡片工资福利
		title = 16416;
		String id = Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourceFinanceView.jsp?isView=1&id="+id;
	}else if(_fromURL.equals("HrmResourceFinanceEdit")){
		//前端--我的工资\人力资源卡片工资福利
		title = 16416;
		String id = Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourceFinanceEdit.jsp?isView=1&id="+id;
	}else if(_fromURL.equals("HrmResourceAbsense")){
		//前端--我的考勤
		String resourceid = Util.null2String(request.getParameter("resourceid"),user.getUID()+"");
		url = "/hrm/resource/HrmResourceAbsense.jsp?resourceid="+resourceid;
	}else if(_fromURL.equals("HrmResourceRewardsRecord")){
		//前端--奖惩考核
		title = 16065;
		String resourceid = Util.null2String(request.getParameter("id"));
		if(resourceid.equals("")) resourceid=String.valueOf(user.getUID());
		Calendar today = Calendar.getInstance();
		String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
							 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
							 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
		String sql = "select count(a.id)" +
		" from HrmByCheckPeople a left join HrmCheckList b on a.checkid = b.id "+
		" where a.checkercount="+resourceid +" and b.enddate>='"+currentdate+"' " ;
		rs.executeSql(sql);
		isShowRewardsRecord = (rs.next()?rs.getInt(1):0)>0;
		if(isShowRewardsRecord){
			url = "/hrm/resource/HrmResourceRewardsRecord.jsp?resourceid="+resourceid;
		}else{
			url = "/hrm/resource/HrmResourceRewardsRecord1.jsp?resourceid="+resourceid;
		}
	}else if(_fromURL.equals("HrmResourcePassword")){
		//前端--密码设置
		title = 20170;
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourcePassword.jsp?id="+id;
	} else if(_fromURL.equals("HrmBirthdayInfo")){
		//前端--人员生日
		title = 22744;
		url = "/hrm/HrmBirthdayInfo.jsp";
	} else if(_fromURL.equals("mobileSignIn")){
		//前端--移动考勤
		title = 82634;
		String id = Util.null2String(request.getParameter("id"));
		String uid = Util.null2String(request.getParameter("uid"));
		String thisDate = Util.null2String(request.getParameter("thisDate"));
		boolean showMap = Boolean.valueOf(Util.null2String(request.getParameter("showMap"), "false"));
		url = "/hrm/mobile/signin/"+(showMap?"map":"time")+"View.jsp?id="+id+"&uid="+uid+"&thisDate="+thisDate;
	} else if(_fromURL.equals("OnlineUser")){
		//前端--在线人员
		hasTree = true;
		String departmentid=Util.null2String(request.getParameter("departmentid"));
	  String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
	  //String companyid=Util.null2String(request.getParameter("id"));
		if(departmentid.length()>0||subcompanyid1.length()>0||companyid.length()>0){
			//无需设置
		}else{
	  	title = 20536;
		}
		url = "/hrm/resource/OnlineUser.jsp?subcompanyid1="+subcompanyid1+"&departmentid="+departmentid+"&companyid="+companyid;
	}else if(_fromURL.equals("HrmTrainType")){
		//中端--培训种类
		title = 6130;
		url = "/hrm/train/traintype/HrmTrainType.jsp";
	}else if(_fromURL.equals("HrmTrainLayout")){
		//中端--培训规划
		title = 6128;
		url = "/hrm/train/trainlayout/HrmTrainLayout.jsp";
	}else if(_fromURL.equals("HrmTrainResource")){
		//中端--培训资源
		title = 15879;
		url = "/hrm/train/trainresource/HrmTrainResource.jsp";
	}else if(_fromURL.equals("HrmTrainPlan")){
		//中端--培训安排
		title = 6156;
		url = "/hrm/train/trainplan/HrmTrainPlan.jsp";
	}else if(_fromURL.equals("HrmTrain")){
		//中端--培训活动
		title = 6136;
		url = "/hrm/train/train/HrmTrain.jsp?type=0";
	}else if(_fromURL.equals("HrmResourceBase")){
		//前端--人力资源卡片--基本信息
		title = 1361;
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourceBase.jsp?id="+id;
	}else if(_fromURL.equals("HrmResourceTotal")){
		//前端--人力资源卡片--工作历程
		title = 1361;
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourceTotal.jsp?id="+id;
	}else if(_fromURL.equals("HrmResourcePersonalView")){
		//前端--人力资源卡片--个人信息
		title = 1361;
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourcePersonalView.jsp?id="+id;
	}else if(_fromURL.equals("HrmResourceWorkView")){
		//前端--人力资源卡片--个人信息
		title = 1361;
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourceWorkView.jsp?id="+id;
	}else if(_fromURL.equals("CptSearchResult")){
		//前端--人力资源卡片--资产信息
		title = 1361;
		String id=Util.null2String(request.getParameter("id"));
		url = "/cpt/search/SearchOperation.jsp?resourceid="+id+"&isdata=2";
		if(Cpt4modeUtil.isUse()){
			url="/formmode/search/CustomSearchBySimple.jsp?customid="+Cpt4modeUtil.getSearchid("wdzc")+"&resourceid="+id+"&from=hrmResourceBase&mymodetype=wdzc&sqlwhere="+new XssUtil().put("where resourceid="+id);
		}
	}else if(_fromURL.equals("HrmResourceSystemView")){
		//前端--人力资源卡片--系统信息
		title = 15804;
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourceSystemView.jsp?id="+id+"&isView=1";
	}else if(_fromURL.equals("HrmResourceSystemEdit")){
		//前端--人力资源卡片--系统信息编辑
		title = 1361;
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmResourceSystemEdit.jsp?id="+id+"&isView=1";
	}
	else if(_fromURL.equals("WorkPlan")){
		//前端--人力资源卡片--计划
		title = 1361;
		String id=Util.null2String(request.getParameter("id"));
		url = "/workplan/data/WorkPlan.jsp?resourceid="+id;
	}else if(_fromURL.equals("HrmResourceNewRoles")){
		//前端--人力资源卡片--角色
		title = 1361;
		String id=Util.null2String(request.getParameter("resourceid"));
		url = "/hrm/roles/HrmResourceNewRoles.jsp?resourceid="+id;
	}else if(_fromURL.equals("SysMaintenanceLog")){
		//系统日志
		String isdialog = Util.null2String(request.getParameter("isdialog"));
		String secid = Util.null2String(request.getParameter("secid"));
		String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
		url = "/systeminfo/SysMaintenanceLog.jsp?from=HrmTab&isdialog="+isdialog+"&secid="+secid+"&sqlwhere="+sqlwhere;
	}else if(_fromURL.equals("DocMould")){
		//中端--合同模板
		title = 15786;
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid1"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/docs/mouldfile/DocMould.jsp?urlfrom=hr&subcompanyid1="+subcompanyid+"&departmentid="+departmentid;
	}else if(_fromURL.equals("HrmContractType")){
		//中端--合同种类
		title = 6158;
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/hrm/contract/contracttype/HrmContractType.jsp?subcompanyid1="+subcompanyid+"&departmentid="+departmentid;
	}else if(_fromURL.equals("SignatureList")){
		//中端--签章管理
		title = 16627;
		hasTree = true;
		String subcompanyid=Util.null2String(request.getParameter("subCompanyId"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/docs/docs/SignatureList.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid;
	}else if(_fromURL.equals("HrmContract")){
		//中端--合同管理
		title = 33741;
		String from=Util.null2String(request.getParameter("from"));
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid1"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/hrm/contract/contract/HrmContract.jsp?from"+from+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid;
	}else if(_fromURL.equals("HrmAwardType")){
		//中端--奖惩考核--奖惩种类
		title = 6099;
		url = "/hrm/award/HrmAwardType.jsp";
	}else if(_fromURL.equals("HrmAward")){
		//中端--奖惩考核--奖惩管理
		title = 6100;
		url = "/hrm/award/HrmAward.jsp";
	}else if(_fromURL.equals("HrmCheckKind")){
		//中端--奖惩考核--考核种类
		title = 6118;
		url = "/hrm/check/HrmCheckKind.jsp";
	}else if(_fromURL.equals("HrmSysAdminBasic")){
		//前端--我的卡片（管理员）
		title = 16139;
		String type=Util.null2String(request.getParameter("type"),"1");
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/resource/HrmSysAdminBasic.jsp?type="+type+"&id="+id;
	}else if(_fromURL.equals("HrmBankList")){
		//中端--薪酬管理--工资银行
		title = 15812;
		url = "/hrm/finance/bank/HrmBankList.jsp";
	}else if(_fromURL.equals("HrmSalaryItemList")){
		//中端--薪酬管理--工资项设置
		title = 33397;
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/hrm/finance/salary/HrmSalaryItemList.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid;		
	}else if(_fromURL.equals("HrmSalaryItemDsp")){
		//中端--薪酬管理--工资项查看
		title = 33397;
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		String id=Util.null2String(request.getParameter("id"));
		url = "/hrm/finance/salary/HrmSalaryItemDsp.jsp?subcompanyid="+subcompanyid+"&id="+id;		
	}else if(_fromURL.equals("CompensationTargetSet")){
		//中端--工资福利--薪酬指标设置
		title = 19427;
		String subCompanyId=Util.null2String(request.getParameter("subCompanyId"));
		url = "/hrm/finance/compensation/CompensationTargetSet.jsp?subCompanyId="+subCompanyId;
	}else if(_fromURL.equals("CompensationTargetMaint")){
		//中端--工资福利--薪酬指标数据维护
		title = 19430;
		String subCompanyId=Util.null2String(request.getParameter("subCompanyId"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		url = "/hrm/finance/compensation/CompensationTargetMaint.jsp?subCompanyId="+subCompanyId+"&departmentid="+departmentid;
	}else if(_fromURL.equals("CompensationTargetMaintList")){
		//中端--工资福利--薪酬指标数据维护
		title = 19430;
		url = "/hrm/finance/compensation/CompensationTargetMaintList.jsp";
	}else if(_fromURL.equals("HrmSalaryManageList")){
		//中端--工资福利--工资单管理
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		title = 33398;
		url = "/hrm/finance/salary/HrmSalaryManageList.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid;
	}else if(_fromURL.equals("HrmSalaryManageView")){
		//中端--工资福利--工资单管理
		String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		title = 19430;
		url = "/hrm/finance/salary/HrmSalaryManageView.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid;
	}else if(_fromURL.equals("HrmSalaryChange")){
		//中端--工资福利--个人工资项调整
		title = 33399;
		url = "/hrm/finance/salary/HrmSalaryChange.jsp";
	}else if(_fromURL.equals("HrmScheduleSignImport")){
		//中端--考勤管理--考勤数据导入
		title = 27177;
		url = "/hrm/schedule/HrmScheduleSignImport.jsp";
	}else if(_fromURL.equals("HrmScheduleSignDataSourceSet")){
		//中端--考勤管理--考勤外部数据源配置
		title = 33459;
		url = "/hrm/schedule/HrmScheduleSignDataSourceSet.jsp";
	}else if(_fromURL.equals("BirthdaySetting")){
		//中端--提醒设置--生日提醒设置
		title = 21946;
		url = "/hrm/setting/BirthdaySetting.jsp";
	}else if(_fromURL.equals("HrmDepartment")){
		//中端--分部信息
		title = 32816;
		String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
		url = "/hrm/company/HrmDepartment.jsp?subcompanyid="+subcompanyid;
	}else if(_fromURL.equals("HrmRpRedeploy")){
		//人事报表--变动相关--调动情况
		title = 16564;
		url = "/hrm/report/redeploy/HrmRpRedeploy.jsp";
	}else if(_fromURL.equals("HrmRpResourceAdd")){
		//人事报表--变动相关--新增情况
		title = 16565;
		url = "/hrm/report/resourceadd/HrmRpResourceAdd.jsp";
	}else if(_fromURL.equals("HrmRpHire")){
		//人事报表--变动相关--转正情况
		title = 16566;
		url = "/hrm/report/hire/HrmRpHire.jsp";
	}else if(_fromURL.equals("HrmRpExtend")){
		//人事报表--变动相关--续签情况
		title = 16567;
		url = "/hrm/report/extend/HrmRpExtend.jsp";
	}else if(_fromURL.equals("HrmRpRehire")){
		//人事报表--变动相关--返聘情况
		title = 16568;
		url = "/hrm/report/rehire/HrmRpRehire.jsp";
	}else if(_fromURL.equals("HrmRpRetire")){
		//人事报表--变动相关--退休情况
		title = 16569;
		url = "/hrm/report/retire/HrmRpRetire.jsp";
	}else if(_fromURL.equals("HrmRpDismiss")){
		//人事报表--变动相关--离职情况
		title = 16570;
		url = "/hrm/report/dismiss/HrmRpDismiss.jsp";
	}else if(_fromURL.equals("HrmRpFire")){
		//人事报表--变动相关--解聘情况
		title = 16571;
		url = "/hrm/report/fire/HrmRpFire.jsp";
	}else if(_fromURL.equals("HrmRpUseDemand")){
		//人事报表--招聘管理--用工需求
		title = 6131;
		url = "/hrm/report/usedemand/HrmRpUseDemand.jsp";
		
	}else if(_fromURL.equals("HrmRpCareerApply")){
		//人事报表--招聘管理--应聘人员
		title = 15885;
		url = "/hrm/report/careerapply/HrmRpCareerApply.jsp";
	}else if(_fromURL.equals("HrmCompanyDspVirtual")){
		//虚拟组织 总部
		String id = request.getParameter("id");
		title = 140;
		url = "/hrm/companyvirtual/HrmCompanyDsp.jsp?id="+id;
	}else if(_fromURL.equals("HrmSubCompanyDspVirtual")){
		//虚拟组织 分部
		String id = request.getParameter("id");
		title = 141;
		url = "/hrm/companyvirtual/HrmSubCompanyDsp.jsp?id="+id;
	}else if(_fromURL.equals("HrmDepartmentDspVirtual")){
		//虚拟组织 部门
		String id = request.getParameter("id");
		title = 124;
		url = "/hrm/companyvirtual/HrmDepartmentDsp.jsp?id="+id;
	}else if(_fromURL.equals("HrmCityTwo")){
		//虚拟组织 部门
		String id = request.getParameter("id");
		title = 25223;
		url = "/hrm/city/HrmCityTwo.jsp?id="+id;
	}else if(_fromURL.equals("WFHrmSearchResult")){
		//工作历程--工作流
		title = 26361;
				mouldid = "workflow";
		String hrmids = request.getParameter("hrmids");
		String nodetype = request.getParameter("nodetype");
		String totalcounts = request.getParameter("totalcounts");
		url = "/workflow/search/WFHrmSearchResult.jsp?hrmids="+hrmids+"&nodetype="+nodetype+"&totalcounts="+totalcounts;
	}else if(_fromURL.equals("Workflows")){
		//未处理流程
		title = 17569;
		mouldid = "workflow";
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Workflows.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("Documents")){
		//未处理文档
		title = 17570;
		mouldid = "doc";
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Documents.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("Customers")){
		//未处理客户
		title = 17571;
		mouldid = "customer";
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Customers.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("Tasks")){
		//未处理项目
		title = 17572;
		mouldid = "proj";
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Tasks.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("Duty")){
		//未处理任务
		title = 21699;
		mouldid = "plan";
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Duty.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("Debts")){
		//未处理欠款
		title = 17573;
		mouldid = "fna";
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Debts.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("Capitals")){
		//未处理资产
		title = 17574;
		mouldid = "assest";
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Capitals.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("Roles")){
		//未处理角色
		title = 17575;
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Roles.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("Coworks")){
		//未处理协作
		mouldid = "collaboration";
		titlename = SystemEnv.getHtmlLabelNames("15746,17855",user.getLanguage());
		String id = request.getParameter("id");
		String total = request.getParameter("total");
		String start = request.getParameter("start");
		String perpage = request.getParameter("perpage");
		url = "/hrm/resign/Coworks.jsp?id="+id+"&total="+total+"&start="+start+"&perpage="+perpage;
	}else if(_fromURL.equals("hrmShowCol")){
		//人员查询显示列定制
		titlename = SystemEnv.getHtmlLabelName(32535,user.getLanguage());
		url = "/hrm/hrmShowCol.jsp";
	}else if(_fromURL.equals("HrmGroupSuggestList")){
		//公共组调整建议
		titlename = SystemEnv.getHtmlLabelName(126253,user.getLanguage());
		url = "/hrm/group/HrmGroupSuggestList.jsp?status=0";
	}else if(_fromURL.equals("HrmBasicDataImport")){
		//基础数据导入
		titlename = SystemEnv.getHtmlLabelName(125428,user.getLanguage());
		url = "/hrm/import/HrmBasicDataImportIndex.jsp";
	}else if(_fromURL.equals("HrmResource")){
		//int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);    
		int isgoveproj = 0;  
		String id = Util.null2String(request.getParameter("id"));
		if(id.equals("")) id=String.valueOf(user.getUID());

		if( id.equals("1") || isdetach ) {
				out.println("<script>window.location.href='/hrm/HrmTab.jsp?_fromURL=HrmSysAdminBasic&id="+id+"';</script>"); 
			//response.sendRedirect("/hrm/HrmTab.jsp?_fromURL=HrmSysAdminBasic&id="+id) ;
       return ;
		}

		//update by fanggsh TD4233 begin
		HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
		HrmResourceManagerVO vo = dao.getHrmResourceManagerByID(id);

		if(vo.getId()!=null&&!(vo.getId()).equals(""))
		{
			if(vo.getId().equals(String.valueOf(id))){
				out.println("<script>window.location.href='/hrm/HrmTab.jsp?_fromURL=HrmResourcePassword&id="+id+"';</script>"); 
		        //response.sendRedirect("/hrm/hrmTab.jsp?_fromURL=HrmResourcePassword&id="+id) ;
		        return ;
			}else{
				out.println("<script>window.location.href='/notice/hrmsystem.jsp';</script>"); 
		        //response.sendRedirect("/notice/hrmsystem.jsp") ;
		        return ;
			}
		}
		Calendar today = Calendar.getInstance();
		String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
		                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
		                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
		rs.executeProc("HrmResource_SelectByID",id);
		rs.next();
		String departmentid = Util.toScreen(rs.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
		String costcenterid = Util.toScreen(rs.getString("costcenterid"),user.getLanguage()) ;
		String subcompanyid = Util.toScreen(rs.getString("subcompanyid1"),user.getLanguage()) ;
		String lastname = Util.toScreen(rs.getString("lastname"),user.getLanguage()) ;			/*姓名*/
		if(subcompanyid==null||subcompanyid.equals("")||subcompanyid.equalsIgnoreCase("null"))
		 subcompanyid="-1";
		session.setAttribute("hrm_subCompanyId",subcompanyid);
		String createrid = Util.toScreen(rs.getString("createrid"),user.getLanguage()) ;		/*创建人id*/
		String createdate = Util.toScreen(rs.getString("createdate"),user.getLanguage()) ;	/*创建日期*/
		String lastmodid = Util.toScreen(rs.getString("lastmodid"),user.getLanguage()) ;		/*最后修改人id*/
		String lastmoddate = Util.toScreen(rs.getString("lastmoddate"),user.getLanguage()) ;	/*修改日期*/
		String lastlogindate = Util.toScreen(rs.getString("lastlogindate"),user.getLanguage()) ;	/*最后登录日期*/
		String jobtype = Util.toScreenToEdit(rs.getString("jobtype"),user.getLanguage()) ;	/*职务类别*/
		String seclevel = Util.toScreen(rs.getString("seclevel"),user.getLanguage()) ;			/*安全级别*/


		/*显示权限判断*/
		int userid = user.getUID();

		boolean isSelf		=	false;
		boolean isManager	=	false;
		boolean displayAll	=	false;
		boolean isHr = false;
		boolean isApp = true;

		boolean isSys = ResourceComInfo.isSysInfoView(userid,id);
		boolean isFin = ResourceComInfo.isFinInfoView(userid,id);
		boolean isCap = ResourceComInfo.isCapInfoView(userid,id);
		boolean ishasF =HrmUserVarify.checkUserRight("HrmResourceWelfareEdit:Edit",user);
		//boolean isCreater = ResourceComInfo.isCreaterOfResource(userid,id);
		if(AppDetachComInfo.isUseAppDetach()){
		  	AppDetachComInfo adci = new AppDetachComInfo(user);
		  	
		  	if(adci.isDetachUser(""+user.getUID())){
			  	isApp = adci.isAllDetachResourceInfo(user,id+"",ResourceComInfo.getDepartmentID(""+id),ResourceComInfo.getSubCompanyID(""+id));
				if(!isApp){
					String errMsg = SystemEnv.getHtmlLabelName(2012,user.getLanguage()); 
					out.println("<script>alert('"+errMsg+"');window.close();</script>"); 
		      		return ;
				}
		  	}
		}
		AllManagers.getAll(id);
		if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid)){
		  isHr = true;
		}
		if(HrmUserVarify.checkUserRight("HrmResource:Display",user))  {
			displayAll		=	true;
		}
		/*
		if(!((currentdate.compareTo(startdate)>=0 || startdate.equals(""))&& (currentdate.compareTo(enddate)<=0 || enddate.equals("")))){
			if (!displayAll){
				response.sendRedirect("/notice/noright.jsp") ;
				return ;
			}
		}
		*/

		if (id.equals(""+user.getUID()) ){
			isSelf = true;
		}

		while(AllManagers.next()){
			String tempmanagerid = AllManagers.getManagerID();
			if (tempmanagerid.equals(""+user.getUID())) {
				isManager = true;
			}
		}

		// 判定是否可以查看该人预算
		boolean canviewbudget = HrmUserVarify.checkUserRight("FnaBudget:All",user, departmentid) ;
		boolean caneditbudget =  HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) &&  (""+user.getUserDepartment()).equals(departmentid) ;
		boolean canapprovebudget = HrmUserVarify.checkUserRight("FnaBudget:Approve",user) ;

		boolean canlinkbudget = canviewbudget || caneditbudget || canapprovebudget || isSelf ;

		// 判定是否可以查看该人收支
		boolean canviewexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user, departmentid) ;
		boolean canlinkexpense = canviewexpense || isSelf ;
		
		tabInfo.put(SystemEnv.getHtmlLabelName(1361,user.getLanguage()), "/hrm/resource/HrmResourceBase.jsp?isfromtab=true&id="+id);
		if(HrmListValidate.isValidate(29)){
			tabInfo.put(SystemEnv.getHtmlLabelName(30804,user.getLanguage()), "/hrm/resource/HrmResourceTotal.jsp?isfromtab=true&id="+id);
		}
		tabInfo.put(SystemEnv.getHtmlLabelName(81554,user.getLanguage()), "/hrm/resource/HrmResourceGroupView.jsp?id="+id);

		int operatelevel=-1;
		if(detachable==1){
		    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
		}else{
		    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
		        operatelevel=2;
		}
		int operatelevelnew = -1;
		if(detachable==1){
			operatelevelnew=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Integer.parseInt(subcompanyid));
		}else{
		    if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user))
		    	operatelevelnew=2;
		}

		//xiaofeng
		String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
		
		//if(isSelf&&HrmListValidate.isValidate(16)&&!(mode!=null&&mode.equals("ldap"))){
			//tabInfo.put(SystemEnv.getHtmlLabelName(409,user.getLanguage()), "/hrm/resource/HrmResourcePassword.jsp?isfromtab=true&id="+id+"&isView=1");
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(409,user.getLanguage())+"',url:'/hrm/resource/HrmResourcePassword.jsp?id="+id+"',id:'t409'}";
		//}
		if(software.equals("ALL") || software.equals("HRM")){
		     if((isSelf||operatelevel>=0)&&HrmListValidate.isValidate(11)){
		    	 //arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15687,user.getLanguage())+"',url:'/hrm/resource/HrmResourcePersonalView.jsp?id="+id+"',id:'t15687'}";
		    	 tabInfo.put(SystemEnv.getHtmlLabelName(15687,user.getLanguage()), "/hrm/resource/HrmResourcePersonalView.jsp?isfromtab=true&id="+id);
		     }
		if((isSelf||isManager||operatelevel>=0)&&HrmListValidate.isValidate(12)){
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15688,user.getLanguage())+"',url:'/hrm/resource/HrmResourceWorkView.jsp?id="+id+"',id:'t15688'}";
			tabInfo.put(SystemEnv.getHtmlLabelName(15688,user.getLanguage()), "/hrm/resource/HrmResourceWorkView.jsp?isfromtab=true&id="+id);
		 }
		}
		
		if((isSelf||operatelevelnew>=0||isSys)&&HrmListValidate.isValidate(15)){
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15804,user.getLanguage())+"',url:'/hrm/resource/HrmResourceSystemView.jsp?id="+id+"&isView=1',id:'t15804'}";
			tabInfo.put(SystemEnv.getHtmlLabelName(15804,user.getLanguage()), "/hrm/resource/HrmResourceSystemView.jsp?isfromtab=true&id="+id+"&isView=1");
		}
		
		if(software.equals("ALL") || software.equals("HRM")){
		if(isgoveproj==0){
		//if((isSelf||operatelevel>=0||isFin || isManager)&&HrmListValidate.isValidate(13)){
		if((isSelf||ishasF)&&HrmListValidate.isValidate(13)){
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(16480,user.getLanguage())+"',url:'/hrm/resource/HrmResourceFinanceView.jsp?id="+id+"&isView=1',id:'t16480'}";
			tabInfo.put(SystemEnv.getHtmlLabelName(16480,user.getLanguage()), "/hrm/resource/HrmResourceFinanceView.jsp?isfromtab=true&id="+id+"&isView=1");
		}
		}
		if((isSelf||operatelevel>=0 || isCap)&&HrmListValidate.isValidate(14)&&"1".equals(MouldStatusCominfo.getStatus("cpt"))){
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15806,user.getLanguage())+"',url:'/cpt/search/SearchOperation.jsp?resourceid="+id+"&isdata=2',id:'t15806'}";
			String cpturl="/cpt/search/SearchOperation.jsp?resourceid="+id+"&isdata=2&from=hrmResourceBase";
			if(Cpt4modeUtil.isUse()){
				cpturl="/formmode/search/CustomSearchBySimpleIframe.jsp?customid="+Cpt4modeUtil.getSearchid("wdzc")+"&resourceid="+id+"&from=hrmResourceBase&mymodetype=wdzc&sqlwhere="+new XssUtil().put("where resourceid="+id);
			}
			tabInfo.put(SystemEnv.getHtmlLabelName(15806,user.getLanguage()), cpturl);
		}
		}
		
		/*
		if(HrmUserVarify.checkUserRight("HrmResource:Log",user,departmentid) ){
			if(HrmListValidate.isValidate(23)){
			    if(rs.getDBType().equals("db2")){
			        //arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"',url:'/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=29 and relatedid="+id+"',id:'t83'}";
			        tabInfo.put(SystemEnv.getHtmlLabelName(83,user.getLanguage()), "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=29 and relatedid="+id );
			    }else{
					
					//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"',url:'/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=29 and relatedid="+id+"',id:'t83'}";
					tabInfo.put(SystemEnv.getHtmlLabelName(83,user.getLanguage()), "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=29 and relatedid="+id );
			    }
			}
			}*/
		
		if((isSelf || isManager || HrmUserVarify.checkUserRight("HrmResource:Workflow",user,departmentid))&&HrmListValidate.isValidate(17)){
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"',url:'/workflow/request/RequestView.jsp?resourceid="+id+"',id:'t259'}";
			//tabInfo.put(SystemEnv.getHtmlLabelName(1207,user.getLanguage()), "/workflow/search/WFSearchResult.jsp?iswaitdo=1&resourceid="+id);
			tabInfo.put(SystemEnv.getHtmlLabelName(1207,user.getLanguage()), "/workflow/search/WFSearchTemp.jsp?method=all&viewScope=doing&complete=0&viewcondition=0&resourceid="+id);
		}
		if((isSelf || isManager || HrmUserVarify.checkUserRight("HrmResource:Plan",user,departmentid))&&HrmListValidate.isValidate(18) ) {
			
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(407,user.getLanguage())+"',url:'/workplan/data/WorkPlan.jsp?resourceid="+id+"',id:'t407'}";
			tabInfo.put(SystemEnv.getHtmlLabelName(2192,user.getLanguage()), "/workplan/data/WorkPlan.jsp?resourceid="+id);
		}
		//added by lupeng 2004-07-08


			if(isgoveproj==0){
				if(software.equals("ALL") || software.equals("HRM")){
				    if(isSelf || isManager || HrmUserVarify.checkUserRight("HrmResource:Absense",user,departmentid)) {
				        if(HrmListValidate.isValidate(20)){
									//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(20080,user.getLanguage())+"',url:'/hrm/resource/HrmResourceAbsense.jsp?resourceid="+id+"',id:'t15880'}";
									tabInfo.put(SystemEnv.getHtmlLabelName(20080,user.getLanguage()), "/hrm/resource/HrmResourceAbsense.jsp?resourceid="+id);
				        }
				    }
				if(isSelf||isManager||HrmUserVarify.checkUserRight("HrmResource:TrainRecord",user)) {
					if(HrmListValidate.isValidate(21)){
						//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(816,user.getLanguage())+"',url:'/hrm/resource/HrmResourceTrainRecord.jsp?resourceid="+id+"',id:'t816'}";
						tabInfo.put(SystemEnv.getHtmlLabelName(816,user.getLanguage()), "/hrm/resource/HrmResourceTrainRecord.jsp?resourceid="+id);
					}
				}
				if(isSelf||isManager||HrmUserVarify.checkUserRight("HrmResource:RewardsRecord",user)) {
					if(HrmListValidate.isValidate(22)){
						tabInfo.put(SystemEnv.getHtmlLabelName(16065,user.getLanguage()), "/hrm/resource/HrmResourceRewardsRecordView.jsp?id="+id);
						//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(16065,user.getLanguage())+"',url:'HrmResourceRewardsRecord.jsp?resourceid="+id+"',id:'t16065'}";
					}
				}
			}
		}
			


		//判断该用户对编辑人员机构是否具有的角色维护权限(TD19119)
		boolean rolesmanage = false;
		int varifylevel=-1;
		if(detachable==1){
		    varifylevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "HrmRolesEdit:Edit", Integer.parseInt(subcompanyid));
				if(varifylevel > 0) {
			   if(HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)){
				   varifylevel=2;       
			   } else {
			       varifylevel=-1;
			   }
			}
		}else{
		    if(HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user))
		        varifylevel=2;
		}
		if(varifylevel > 0) {
			rolesmanage = true;
		}

		if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user) && rolesmanage){
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(16527,user.getLanguage())+"',url:'/hrm/roles/HrmResourceNewRoles.jsp?resourceid="+id+"',id:'t16527'}";
			tabInfo.put(SystemEnv.getHtmlLabelName(16527,user.getLanguage()), "/hrm/roles/HrmResourceNewRoles.jsp?resourceid="+id );
		}

		//取自定义标签页
		HrmResourceBaseTabComInfo.setTofirstRow();
		while(HrmResourceBaseTabComInfo.next())
		{
			if(!HrmResourceBaseTabComInfo.getIsopen().equals("1"))continue;
		    String tab_urlTemp= HrmResourceBaseTabComInfo.getLinkurl();
		    String tab_urlTemp1=tab_urlTemp.replaceAll("\\Q{#id}", ""+id);
		    
				if(tab_urlTemp1.indexOf("?")>=0){
					tab_urlTemp1+="&hrmResourceID="+id;
				}else{
					tab_urlTemp1+="?hrmResourceID="+id;
				}
				String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(HrmResourceBaseTabComInfo.getLabel()),user.getLanguage());
				tabInfo.put(labelname, tab_urlTemp1);
			//tabInfo.put(rs.getString("name"), rs.getString("tab_url")+"&id="+id);
			
		}
	} else if(_fromURL.equals("OrgChartHRM")){
		title = 562;
		//url = "/org/OrgChartShow.jsp?sorgid="+Util.null2String(request.getParameter("sorgid"));
		url = "/org/OrgChartHRM.jsp?sorgid="+Util.null2String(request.getParameter("sorgid"));
	} else if(_fromURL.equals("hrmDepartLayoutEdit")){
		title = 16459;
		//url = "/org/OrgChartEdit.jsp?sorgid="+Util.null2String(request.getParameter("sorgid"));
		url = "/hrm/company/HrmDepartLayoutEdit.jsp?sorgid="+Util.null2String(request.getParameter("sorgid"));
	} else if(_fromURL.equals("HrmChoice")){
		title = 1226;
		url = "/sendmail/HrmChoice.jsp?issearch=1&isdialog=1";
	} else if(_fromURL.equals("PermissionSearch")){
		title = 81553;
		url = "/hrm/transfer/PermissionSearch.jsp";
	}else if(_fromURL.equals("MatrixImport")){
		String matrixid = request.getParameter("matrixid");
		String issystem = request.getParameter("issystem");
		url = "/matrixmanage/pages/MatrixImport.jsp?matrixid="+matrixid+"&issystem="+issystem;
	}
	
	if(title>0&&titlename.length()==0){
		titlename = SystemEnv.getHtmlLabelName(title,user.getLanguage());
	}else if(_fromURL.equals("HrmResourceAbsense")){
		//前端--我的考勤
		String resourceid = Util.null2String(request.getParameter("resourceid"),user.getUID()+"");
		if(Util.null2String(ResourceComInfo.getLastname(resourceid)).length()==0){
			titlename = SystemEnv.getHtmlLabelName(title,user.getLanguage());
		}else{
			String languageStr = "";
			if(user.getLanguage()==8){
				languageStr = " ";
			}
			titlename = ResourceComInfo.getLastname(resourceid)+languageStr+SystemEnv.getHtmlLabelName(125404,user.getLanguage());
		}
	}else if(_fromURL.equals("outresourceList")){
		//外部用户
		titlename = SystemEnv.getHtmlLabelName(125931,user.getLanguage());
		String crmid = Util.null2String(request.getParameter("crmid"));
		url = "/hrm/outinterface/outresourceList.jsp?crmid="+crmid;
	}else if(_fromURL.equals("outresourceAdd")){
		//外部用户
		titlename = SystemEnv.getHtmlLabelName(125931,user.getLanguage());
		String customid = Util.null2String(request.getParameter("customid"));
		url = "/hrm/outinterface/outresourceAdd.jsp?customid="+customid;
	}else if(_fromURL.equals("outresourceEdit")){
		//外部用户
		titlename = SystemEnv.getHtmlLabelName(125931,user.getLanguage());
		String id = Util.null2String(request.getParameter("id"));
		url = "/hrm/outinterface/outresourceEdit.jsp?id="+id;
	}else if(_fromURL.equals("outresourceView")){
		//外部用户
		titlename = SystemEnv.getHtmlLabelName(125931,user.getLanguage());
		String id = Util.null2String(request.getParameter("id"));
		url = "/hrm/outinterface/outresourceView.jsp?id="+id;
	}else if(_fromURL.equals("outresourceAssignList")){
		titlename = SystemEnv.getHtmlLabelName(126086,user.getLanguage());
		url = "/hrm/outinterface/outresourceAssignList.jsp";
	}
%>
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
 				mouldID:"<%= MouldIDConst.getID(mouldid)%>",
        staticOnLoad:true,
        <%if(_fromURL.equals("HrmResource")){
      		String id = Util.null2String(request.getParameter("id"));
      		if(id.length()==0)id=""+user.getUID();
        %>
        objName:"<%=titlename %>"
        //,navLogo:"<%=ResourceComInfo.getMessagerUrls(id) %>"
        ,navLogo:"<%=weaver.hrm.User.getUserIcon(id,"width: 43px; height: 43px;line-height: 43px;margin-top:8px;border-radius:30px;") %>"
        <%if(!id.equals("1")&&id.equals(""+user.getUID())){%>
        ,navLogoEvent:setUserIcon
        <%}}else if(_fromURL.equals("HrmResourceView")){ 
		    	String id = Util.null2String(request.getParameter("id"));
        	if(id.length()==0)id = ""+user.getUID();
		    %>
		    objName:"<a href='javaScript:openhrm(<%=id%>);' onclick='pointerXY(event);'><%=ResourceComInfo.getLastname(id)%></a><%=SystemEnv.getHtmlLabelName(title,user.getLanguage()) %>"
				<%}else{%>
				 objName:"<%=titlename %>"
				<%}%>
    });
});
function jsOnNavLogClick(){
	tabcontentframe.setUserIcon();
}

function setUserIcon(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = encodeURI(encodeURI("/hrm/HrmDialogTab.jsp?_fromURL=GetUserIcon&isManager=0&userId=<%=user.getUID()%>&subcompanyid=<%=user.getUserSubCompany1()%>&loginid=<%=user.getLoginid()%>"));
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(28062,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function changeOrg(id){
	window.location.href = "/hrm/HrmTab.jsp?_fromURL=<%=_fromURL%>&sorgid="+id;
}
</script>
</head>
<BODY scroll="no">
	<div class="e8_box demo2">
				<%if(showDiv){ %>
				<div class="e8_boxhead">
					<div class="div_e8_xtree" id="div_e8_xtree"></div>
			        <div class="e8_tablogo" id="e8_tablogo"></div>
					<div class="e8_ultab">
					<div class="e8_navtab" id="e8_navtab">
						<span id="objName"></span>
					</div>
				<div>
				<%} %>
		    <ul class="tab_menu">
		     <%if(hasTree){%>
					<li class="e8_tree">
						<a onClick="javascript:refreshTab();"></a>
					</li>
					<%} %>			
					<%
						/*if(_fromURL.equals("hrmDepartLayoutEdit") || _fromURL.equals("OrgChartHRM")){
							String sorgid = Util.null2String(request.getParameter("sorgid"));
							if(CompanyVirtualComInfo.getCompanyNum()>0){
					%>
							<select name="sOrg" onchange="changeOrg(this.value);">
								<%
									if(CompanyComInfo.next()){
								%>
								<option value="<%=CompanyComInfo.getCompanyid()%>"><%=CompanyComInfo.getCompanyname()%></option>
								<%
									}
									String _vcId = "";
									while(CompanyVirtualComInfo.next()){
										_vcId = CompanyVirtualComInfo.getCompanyid();
								%>
								<option value="<%=_vcId%>" <%=sorgid.equals(_vcId)?"selected":""%>><%=CompanyVirtualComInfo.getVirtualType()%></option>
								<%
									}
								%>
							<select>
					<%
							}
						}*/
					%>
						<%if(_fromURL.equals("HrmResourceAdd")){ 
							String departmentid=Util.null2String(request.getParameter("departmentid"));
						  String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
						  //String companyid=Util.null2String(request.getParameter("id"));
						  String from = Util.null2String(request.getParameter("from"));
						%>
						<li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceAdd.jsp?departmentid=<%=departmentid %>"><%=SystemEnv.getHtmlLabelName(15005,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="<%="/hrm/search/HrmResourceSearchTmp.jsp?from=HrmResourceAdd&subcompany1="+subcompanyid1+"&department="+departmentid+"&companyid="+companyid+"&from="+from %>"><%=SystemEnv.getHtmlLabelName(33198,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmSysAdminBasic")){
		        	 String id = Util.null2String(request.getParameter("id"));
		        %>
		        <li>
							<a target="tabcontentframe" href="/hrm/resource/HrmSysAdminBasic.jsp?type=0&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></a>
						</li>
		       	<li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/resource/HrmSysAdminBasic.jsp?type=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/resource/HrmSysAdminBasic.jsp?type=2&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/resource/HrmSysAdminBasic.jsp?type=3&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/resource/HrmSysAdminBasic.jsp?type=4&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/resource/HrmSysAdminBasic.jsp?type=5&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmSecuritySetting")){ 
		        	String needEncoder = "";
		        	needEncoder = StringUtil.vString(rs.getPropValue("DBEncoder", "needEncoder"),"");
		        %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/setting/HrmSecuritySetting.jsp"><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/setting/advancedSet.jsp"><%=SystemEnv.getHtmlLabelName(19332,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/tools/NetworkSegmentStrategy.jsp"><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage()) %></a>
						</li>
						<%
						if("1".equals(needEncoder)){
						 %>
		       	<li>
							<a target="tabcontentframe" href="/hrm/setting/DBPasswordAlter.jsp"><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())+SystemEnv.getHtmlLabelName(17589,user.getLanguage()) %></a>
						</li>
						<%
						} %>
						<%}else if(_fromURL.equals("jobgroup")){ 
							String jobgroup = Util.null2String(kv.get("jobgroup"));
							String jobactivite = Util.null2String(kv.get("jobactivite"));
						%>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/jobgroups/HrmJobGroups.jsp?jobgroup=<%=jobgroup %>"\><%=SystemEnv.getHtmlLabelName(805,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/jobactivities/HrmJobActivities.jsp?jobgroup=<%=jobgroup %>&jobactivite=<%=jobactivite %>"><%=SystemEnv.getHtmlLabelName(33228,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("company")){ %>
		       	<li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/company/editSubcompanyFieldBatch.jsp"><%=SystemEnv.getHtmlLabelName(15449 ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/company/HrmFieldLabel.jsp?grouptype=<%=4 %>"><%=SystemEnv.getHtmlLabelName(32815,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/definedform/HrmFieldGroup.jsp?grouptype=<%=4 %>"><%=SystemEnv.getHtmlLabelName(34105,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("department")){ %>
		       	<li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/company/editDeptFieldBatch.jsp"><%=SystemEnv.getHtmlLabelName(15449 ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/company/HrmFieldLabel.jsp?grouptype=<%=5 %>"><%=SystemEnv.getHtmlLabelName(32815,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/definedform/HrmFieldGroup.jsp?grouptype=<%=5 %>"><%=SystemEnv.getHtmlLabelName(34105,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("companyEdit")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/company/HrmCompany_frm.jsp"><%=SystemEnv.getHtmlLabelName(32498 ,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/company/HrmDepartLayoutEdit.jsp"><%=SystemEnv.getHtmlLabelName(16459,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("HrmSubCompanyList")){ 
							String id=Util.null2String((String)kv.get("id"));
						%>
						<li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/company/HrmSubCompanyList.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(17898,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/company/HrmDepartmentList.jsp?cmd=subcompany&id=<%=id%>"><%=SystemEnv.getHtmlLabelName(27511 ,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("HrmDepartList")){
							String id=Util.null2String((String)kv.get("id"));
						%>
						<li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/company/HrmDepartmentList.jsp?cmd=department&id=<%=id%>"><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/company/HrmResourceList.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(179 ,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("HrmValidate")){ %>
		        <li  class="current" onMouseOver="javascript:showSecTabMenu();">
		        	<a target="tabcontentframe" href="/hrm/tools/HrmValidate.jsp"><%=SystemEnv.getHtmlLabelName(32980 ,user.getLanguage()) %></a>
		        </li>
						<li>
							<a target="tabcontentframe" href="/hrm/tools/HrmValidatePrivate.jsp"><%=SystemEnv.getHtmlLabelName(32744,user.getLanguage())%></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceTry")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resource/HrmResourceTry.jsp');"><%=SystemEnv.getHtmlLabelName(17513,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resign/Resign.jsp');"><%=SystemEnv.getHtmlLabelNames("15746,21561" ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/transfer/PermissionToAdjust.jsp');"><%=SystemEnv.getHtmlLabelName(34238 ,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceHire")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resource/HrmResourceHire.jsp');"><%=SystemEnv.getHtmlLabelName(16466,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resign/Resign.jsp');"><%=SystemEnv.getHtmlLabelNames("15746,21561" ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/transfer/PermissionToAdjust.jsp');"><%=SystemEnv.getHtmlLabelName(34238 ,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceExtend")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resource/HrmResourceExtend.jsp');"><%=SystemEnv.getHtmlLabelName(16467,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resign/Resign.jsp');"><%=SystemEnv.getHtmlLabelNames("15746,21561" ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/transfer/PermissionToAdjust.jsp');"><%=SystemEnv.getHtmlLabelName(34238 ,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceRedeploy")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resource/HrmResourceRedeploy.jsp');"><%=SystemEnv.getHtmlLabelName(16468,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resign/Resign.jsp');"><%=SystemEnv.getHtmlLabelNames("15746,21561" ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/transfer/PermissionToAdjust.jsp');"><%=SystemEnv.getHtmlLabelName(34238 ,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceDismiss")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resource/HrmResourceDismiss.jsp');"><%=SystemEnv.getHtmlLabelName(16469,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resign/Resign.jsp');"><%=SystemEnv.getHtmlLabelNames("15746,21561" ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/transfer/PermissionToAdjust.jsp');"><%=SystemEnv.getHtmlLabelName(34238 ,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceRetire")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resource/HrmResourceRetire.jsp');"><%=SystemEnv.getHtmlLabelName(16470,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resign/Resign.jsp');"><%=SystemEnv.getHtmlLabelNames("15746,21561" ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/transfer/PermissionToAdjust.jsp');"><%=SystemEnv.getHtmlLabelName(34238 ,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceFire")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resource/HrmResourceFire.jsp');"><%=SystemEnv.getHtmlLabelName(16472,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resign/Resign.jsp');"><%=SystemEnv.getHtmlLabelNames("15746,21561" ,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/transfer/PermissionToAdjust.jsp');"><%=SystemEnv.getHtmlLabelName(34238 ,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceRehire")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resource/HrmResourceRehire.jsp');"><%=SystemEnv.getHtmlLabelName(16471,user.getLanguage()) %></a>
						</li>
						<!-- 
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/resign/Resign.jsp');"><%=SystemEnv.getHtmlLabelNames("15746,21561" ,user.getLanguage()) %></a>
						</li>
						 -->
						<li>
							<a target="tabcontentframe" href="javascript:void('0')" onClick="jsShow('/hrm/transfer/PermissionToAdjust.jsp');"><%=SystemEnv.getHtmlLabelName(34238 ,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmResourceTrainRecord")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceTrainRecord.jsp?resourceid=<%=+user.getUID()%>"><%=SystemEnv.getHtmlLabelName(24987,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceTraindetail.jsp?resourceid=<%=+user.getUID()%>"><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage()) %></a>
						</li>
		       <%}else if(_fromURL.equals("HrmResourceSalaryLog") || _fromURL.equals("HrmResourceChangeLog") || _fromURL.equals("HrmResourceSalaryList")){ 
		       String resourceid = Util.null2String(request.getParameter("resourceid"));
		      	boolean isfromtab =  true;//Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
		        int idx =0;
		        if(HrmListValidate.isValidate(61)){
		        	idx=0;
		        }else{
		        	if(HrmListValidate.isValidate(62)){
		        		idx=1;
		        	}else{
		        		if(HrmListValidate.isValidate(63)){
			        		idx=2;
			        	}
		        	}
		        }
		        if(isfromtab){
		        %>
		        <%if(HrmListValidate.isValidate(61)){ 
		        %>
		        <li class="<%=idx==0?"current":"" %>" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceSalaryLog.jsp?id=<%=resourceid%>&from=psersonalView"><%=SystemEnv.getHtmlLabelName(32653,user.getLanguage()) %></a>
						</li>
		        <%}if(HrmListValidate.isValidate(62)){ %>
		        <li class="<%=idx==1?"current":"" %>">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceSalaryList.jsp?id=<%=resourceid%>"><%=SystemEnv.getHtmlLabelName(19576,user.getLanguage()) %></a>
						</li>
						<%}if(HrmListValidate.isValidate(63)){ %>
		       	<li class="<%=idx==2?"current":"" %>">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceChangeLog.jsp?id=<%=resourceid%>"><%=SystemEnv.getHtmlLabelName(32656,user.getLanguage()) %></a>
						</li>
						<%} }else{%>
		        <li class="<%=idx==0?"current":"" %>" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceSalaryLog.jsp?id=<%=resourceid%>&from=psersonalView"><%=SystemEnv.getHtmlLabelName(32653,user.getLanguage()) %></a>
						</li>
		        <li class="<%=idx==1?"current":"" %>">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceSalaryList.jsp?id=<%=resourceid%>"><%=SystemEnv.getHtmlLabelName(19576,user.getLanguage()) %></a>
						</li>
		       	<li class="<%=idx==2?"current":"" %>">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceChangeLog.jsp?id=<%=resourceid%>"><%=SystemEnv.getHtmlLabelName(32656,user.getLanguage()) %></a>
						</li>
						<%} %>
		        <%} else if(_fromURL.equals("HrmResourceRewardsRecord")){						
					String resourceid = Util.null2String(request.getParameter("resourceid"));
					if(resourceid.equals("")) resourceid=String.valueOf(user.getUID());
					if(isShowRewardsRecord){
		        %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceRewardsRecord.jsp?resourceid=<%=resourceid%>"><%=SystemEnv.getHtmlLabelName(17503,user.getLanguage()) %></a>
						</li>
				<%}%>
		        <li <%=isShowRewardsRecord?"":"class=\"current\" onMouseOver=\"javascript:showSecTabMenu();\""%>>
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceRewardsRecord1.jsp?resourceid=<%=resourceid%>"><%=SystemEnv.getHtmlLabelName(32740,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceRewardsRecord2.jsp?resourceid=<%=resourceid%>"><%=SystemEnv.getHtmlLabelName(15682,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmArrangeShiftList")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/schedule/HrmArrangeShiftList.jsp"><%=SystemEnv.getHtmlLabelName(32753,user.getLanguage()) %></a>
						</li>
		        <li>
							<a target="tabcontentframe" href="/hrm/schedule/HrmArrangeShiftHistory.jsp"><%=SystemEnv.getHtmlLabelName(32754,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmArrangeShiftMaintance")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/schedule/HrmArrangeShiftMaintance.jsp"><%=SystemEnv.getHtmlLabelName(32765,user.getLanguage()) %></a>
						</li>
		        <li>
							<a target="tabcontentframe" href="/hrm/schedule/HrmArrangeShiftSet.jsp"><%=SystemEnv.getHtmlLabelName(32766,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmSalaryChange")){ %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/finance/salary/HrmSalaryChange.jsp"><%=SystemEnv.getHtmlLabelName(33404 ,user.getLanguage()) %></a>
						</li>
		        <li>
							<a target="tabcontentframe" href="/hrm/finance/salary/HrmSalaryChangeLog.jsp"><%=SystemEnv.getHtmlLabelName(15817,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmCompanyDsp")){ 
		      		String id=Util.null2String((String)kv.get("id"));
		      		String qname=Util.null2String((String)kv.get("qname"));
		        %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
						<a target="tabcontentframe" href="/hrm/company/HrmCompanyDsp.jsp?id=<%=id %>&fromHrmTab=1"><%=SystemEnv.getHtmlLabelName(33209,user.getLanguage()) %></a>
						</li>
		        <li>
							<a target="tabcontentframe" href="/hrm/company/HrmCompanyList.jsp?id=<%=id %>&qname=<%=qname %>"><%=SystemEnv.getHtmlLabelName(17898,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmCompanyDspVirtual")){ 
		      		String id=Util.null2String((String)kv.get("id"));
		      		String qname=Util.null2String((String)kv.get("qname"));
		        %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
						<a target="tabcontentframe" href="/hrm/companyvirtual/HrmCompanyDsp.jsp?id=<%=id %>&fromHrmTab=1"><%=SystemEnv.getHtmlLabelName(33209,user.getLanguage()) %></a>
						</li>
		        <%if(!id.equals("0")) {%>
		        <li>
							<a target="tabcontentframe" href="/hrm/companyvirtual/HrmSubCompanyList.jsp?id=<%=id %>&qname=<%=qname %>&from=HrmCompanyDsp"><%=SystemEnv.getHtmlLabelName(17898,user.getLanguage()) %></a>
						</li>
						<%} %>
		        <%}else if(_fromURL.equals("HrmSubCompanyDsp")){ 
		      		String id=Util.null2String((String)kv.get("id"));
		        %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu();">
						<a target="tabcontentframe" href="/hrm/company/HrmSubCompanyDsp.jsp?id=<%=id %>&fromHrmTab=1"><%=SystemEnv.getHtmlLabelName(32816,user.getLanguage()) %></a>
						</li>
		        <li>
							<a target="tabcontentframe" href="/hrm/company/HrmSubCompanyList.jsp?id=<%=id %>"><%=SystemEnv.getHtmlLabelName(17898,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/company/HrmDepartmentList.jsp?cmd=subcompany&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("HrmSubCompanyDspVirtual")){ 
		      		String id=Util.null2String((String)kv.get("id"));
			        %>
			        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/companyvirtual/HrmSubCompanyDsp.jsp?id=<%=id %>&fromHrmTab=1"><%=SystemEnv.getHtmlLabelName(32816,user.getLanguage()) %></a>
							</li>
			        <li>
								<a target="tabcontentframe" href="/hrm/companyvirtual/HrmSubCompanyList.jsp?id=<%=id %>"><%=SystemEnv.getHtmlLabelName(17898,user.getLanguage()) %></a>
							</li>
						  <li>
								<a target="tabcontentframe" href="/hrm/companyvirtual/HrmDepartmentList.jsp?cmd=subcompany&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage()) %></a>
							</li>
							<%}else if(_fromURL.equals("HrmTrain")){
						//中端--培训活动
						%>
						<li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrain.jsp?type=0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrain.jsp?type=1"><%=SystemEnv.getHtmlLabelName(24324,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrain.jsp?type=2"><%=SystemEnv.getHtmlLabelName(22348,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("BirthdaySetting")){
		      		//中端--提醒设置--生日提醒设置
		      	%>
		      	<li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/setting/BirthdaySetting.jsp"><%=SystemEnv.getHtmlLabelName(17534,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/setting/ContractSetting.jsp"><%=SystemEnv.getHtmlLabelName(19149,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/setting/EnterSetting.jsp"><%=SystemEnv.getHtmlLabelName(19148,user.getLanguage()) %></a>
						</li>
		      	<%}else if(_fromURL.equals("HrmGroupSuggestList")){
		      		//中端--常用组变更提醒
			      	%>
			      	<li class="current" onMouseOver="javascript:showSecTabMenu();">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupSuggestList.jsp?status=0"><%=SystemEnv.getHtmlLabelName(16349,user.getLanguage()) %></a>
							</li>
						  <li>
								<a target="tabcontentframe" href="/hrm/group/HrmGroupSuggestList.jsp?status=1"><%=SystemEnv.getHtmlLabelName(1454,user.getLanguage()) %></a>
							</li>
			      	<%}else if(_fromURL.equals("HrmDepartmentDsp")){ 
		      		String id=Util.null2String((String)kv.get("id"));
			        %>
			        <li class="current" onMouseOver="javascript:showSecTabMenu();">
							<a target="tabcontentframe" href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=id %>&fromHrmTab=1"><%=SystemEnv.getHtmlLabelName(16289,user.getLanguage()) %></a>
							</li>
			        <li>
								<a target="tabcontentframe" href="/hrm/company/HrmDepartmentList.jsp?cmd=department&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage()) %></a>
							</li>
							<li>
								<a target="tabcontentframe" href="/hrm/jobtitles/HrmJobTitles.jsp?departmentid=<%=id %>"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage()) %></a>
							</li>
						  <li>
								<a target="tabcontentframe" href="/hrm/company/HrmResourceList.jsp?id=<%=id %>"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %></a>
							</li>
			        <%}else if(_fromURL.equals("HrmDepartmentDspVirtual")){ 
			      		String id=Util.null2String((String)kv.get("id"));
				        %>
				        <li class="current" onMouseOver="javascript:showSecTabMenu();">
								<a target="tabcontentframe" href="/hrm/companyvirtual/HrmDepartmentDsp.jsp?id=<%=id %>&fromHrmTab=1"><%=SystemEnv.getHtmlLabelName(16289,user.getLanguage()) %></a>
								</li>
				        <li>
									<a target="tabcontentframe" href="/hrm/companyvirtual/HrmDepartmentList.jsp?cmd=department&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage()) %></a>
								</li>
							  <li>
									<a target="tabcontentframe" href="/hrm/companyvirtual/HrmResourceList.jsp?id=<%=id %>"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %></a>
								</li>
				        <%}else if(_fromURL.equals("HrmCustomFieldManager")){ 
				      		String id=Util.null2String((String)kv.get("id"),"-1");
				      		boolean showItem = false;
				      		if(id.equals("-1")||id.equals("1")||id.equals("3"))showItem=true;
					        %>
					        <li class="current" onMouseOver="javascript:showSecTabMenu();">
									<a target="tabcontentframe" href="/hrm/resource/EditHrmCustomField.jsp?id=<%=id %>&fromHrmTab=1"><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage()) %></a>
									</li>
					        <li>
										<a target="tabcontentframe" href="/hrm/definedform/HrmFieldLabel.jsp?grouptype=<%=id %>"><%=SystemEnv.getHtmlLabelName(32815,user.getLanguage()) %></a>
									</li>
									<%if(showItem){ %>
								  <li>
										<a target="tabcontentframe" href="/hrm/definedform/HrmFieldGroup.jsp?grouptype=<%=id %>"><%=SystemEnv.getHtmlLabelName(34105,user.getLanguage()) %></a>
									</li>
									<%} %>
								<%}else if(_fromURL.equals("HrmResource")){
								Iterator<Map.Entry<String,String>> iter = tabInfo.entrySet().iterator();
			          int index = 0;
			          String tempURL = "";
								while (iter.hasNext()) {
								Map.Entry<String,String> entry = iter.next();
								String name = entry.getKey();
								tempURL = entry.getValue();
								index++;
								if(index==1)url=tempURL;
		          %>
		           <li <%=index==1?"class=\"current\"":"" %> onMouseOver="javascript:showSecTabMenu();">
		            <a href="<%=tempURL %>" target="tabcontentframe"><%=name %></a>
		           </li>
		           <%}%>
		        <%
					} else if(_fromURL.equals("useDemand")){ 
						tab.setCondition(Constants.NO_RESULT);
						tab.setSQL("select a.status,(case when (COUNT(a.id)) > 0 then 'true' else 'false' end) as result from HrmUseDemand a group by a.status");
						tab.add(new TabLi("/hrm/career/usedemand/HrmUseDemand.jsp",SystemEnv.getHtmlLabelName(332,user.getLanguage())));
						tab.add(new TabLi("/hrm/career/usedemand/HrmUseDemand.jsp?status=0",SystemEnv.getHtmlLabelName(15746,user.getLanguage()),"0",true));
						tab.add(new TabLi("/hrm/career/usedemand/HrmUseDemand.jsp?status=1",SystemEnv.getHtmlLabelName(15747,user.getLanguage()),"1"));
						tab.add(new TabLi("/hrm/career/usedemand/HrmUseDemand.jsp?status=2",SystemEnv.getHtmlLabelName(15748,user.getLanguage()),"2"));
						tab.add(new TabLi("/hrm/career/usedemand/HrmUseDemand.jsp?status=3",SystemEnv.getHtmlLabelName(15749,user.getLanguage()),"3"));
						out.println(tab.show());
					} else if(_fromURL.equals("careerPlan")){
						tab.add(new TabLi("/hrm/career/careerplan/HrmCareerPlan.jsp",SystemEnv.getHtmlLabelName(332,user.getLanguage())));
						tab.add(new TabLi("/hrm/career/careerplan/HrmCareerPlan.jsp?status=1",SystemEnv.getHtmlLabelName(24324,user.getLanguage()),true));
						tab.add(new TabLi("/hrm/career/careerplan/HrmCareerPlan.jsp?status=2",SystemEnv.getHtmlLabelName(22348,user.getLanguage())));
						out.println(tab.show());
					} else if(_fromURL.equals("applyInfo")){
						tab.add(new TabLi("/hrm/career/applyinfo/list.jsp",SystemEnv.getHtmlLabelName(332,user.getLanguage())));
						tab.add(new TabLi("/hrm/career/applyinfo/list.jsp?status=1",SystemEnv.getHtmlLabelName(16349,user.getLanguage()),true));
						tab.add(new TabLi("/hrm/career/applyinfo/list.jsp?status=2",SystemEnv.getHtmlLabelName(15689,user.getLanguage())));
						//tab.add(new TabLi("/hrm/career/applyinfo/list.jsp?status=0",SystemEnv.getHtmlLabelName(15690,user.getLanguage())));
						out.println(tab.show());
					} else if(_fromURL.equals("hrmCheckInfo")){
						tab.add(new TabLi("/hrm/actualize/HrmCheckInfo.jsp?cmd=15652",SystemEnv.getHtmlLabelName(15652,user.getLanguage()),cmd.equals("15652")));
						tab.add(new TabLi("/hrm/actualize/HrmCheckInfo.jsp?cmd=15656",SystemEnv.getHtmlLabelName(15656,user.getLanguage()),cmd.equals("15656")));
						out.println(tab.show());
					} else if(_fromURL.equals("fnaCurrencies")){
						tab.add(new TabLi("/fna/maintenance/FnaCurrencies.jsp?cmd=",SystemEnv.getHtmlLabelName(332,user.getLanguage()),cmd.equals("")));
						tab.add(new TabLi("/fna/maintenance/FnaCurrencies.jsp?cmd=1",SystemEnv.getHtmlLabelName(18095,user.getLanguage()),cmd.equals("1")));
						tab.add(new TabLi("/fna/maintenance/FnaCurrencies.jsp?cmd=0",SystemEnv.getHtmlLabelName(18096,user.getLanguage()),cmd.equals("0")));
						out.println(tab.show());
					}else if(_fromURL.equals("OrgChartHRM")){
						String sorgid = Util.null2String(request.getParameter("sorgid"));
						tab.add(new TabLi("/org/OrgChartHRM.jsp?cmd=&sorgid="+sorgid,SystemEnv.getHtmlLabelName(179,user.getLanguage()),cmd.equals("")));
						tab.add(new TabLi("/org/OrgChartHRM.jsp?cmd=doc&sorgid="+sorgid,SystemEnv.getHtmlLabelName(58,user.getLanguage()),cmd.equals("doc")));
						tab.add(new TabLi("/org/OrgChartHRM.jsp?cmd=customer&sorgid="+sorgid,SystemEnv.getHtmlLabelName(136,user.getLanguage()),cmd.equals("customer")));
						tab.add(new TabLi("/org/OrgChartHRM.jsp?cmd=project&sorgid="+sorgid,SystemEnv.getHtmlLabelName(101,user.getLanguage()),cmd.equals("project")));
						
						/*tab.add(new TabLi("/org/OrgChartShow.jsp?cmd=&sorgid="+sorgid,SystemEnv.getHtmlLabelName(179,user.getLanguage()),cmd.equals("")));
						tab.add(new TabLi("/org/OrgChartDoc.jsp?cmd=doc&sorgid="+sorgid,SystemEnv.getHtmlLabelName(58,user.getLanguage()),cmd.equals("doc")));
						tab.add(new TabLi("/org/OrgChartCRM.jsp?cmd=customer&sorgid="+sorgid,SystemEnv.getHtmlLabelName(136,user.getLanguage()),cmd.equals("customer")));
						tab.add(new TabLi("/org/OrgChartProj.jsp?cmd=project&sorgid="+sorgid,SystemEnv.getHtmlLabelName(101,user.getLanguage()),cmd.equals("project")));*/
						out.println(tab.show());
					} else if(_fromURL.equals("HrmDefaultSechedule")){
						String departmentid=Util.null2String(request.getParameter("departmentid"));
						String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
						tab.add(new TabLi("/hrm/schedule/HrmDefaultScheduleList.jsp?companyid="+companyid+"&subcompanyid1="+subcompanyid1+"&departmentid="+departmentid,SystemEnv.getHtmlLabelName(16254,user.getLanguage()),true));
						out.println(tab.show());
					}else if(_fromURL.equals("HrmRightTransfer")){
						tab.add(new TabLi("/hrm/transfer/HrmRightTransfer.jsp",SystemEnv.getHtmlLabelName(16379,user.getLanguage()),cmd.equals("")));
						tab.add(new TabLi("/hrm/transfer/HrmRightCopy.jsp",SystemEnv.getHtmlLabelName(34031,user.getLanguage()),cmd.equals("copy")));
						tab.add(new TabLi("/hrm/transfer/HrmRightDelete.jsp",SystemEnv.getHtmlLabelName(34239,user.getLanguage()),cmd.equals("delete")));
						out.println(tab.show());
					}else if(_fromURL.equals("AnnualManagementView")){
						String subcompanyid=Util.null2String(request.getParameter("subcompanyid1"));
						String departmentid=Util.null2String(request.getParameter("departmentid"));
						tab.add(new TabLi("/hrm/schedule/AnnualManagementView.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&cmd="+cmd,SystemEnv.getHtmlLabelName(21600,user.getLanguage()),true));
						out.println(tab.show());
					}else if(_fromURL.equals("PSLManagementView")){
						String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
						String departmentid=Util.null2String(request.getParameter("departmentid"));
						tab.add(new TabLi("/hrm/schedule/PSLManagementView.jsp?companyid="+companyid+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&cmd="+cmd,SystemEnv.getHtmlLabelName(131557,user.getLanguage()),true));
						out.println(tab.show());
					} else if(_fromURL.equals("HrmResourcePassword")){
						String id = Util.null2String(request.getParameter("id"));
						tab.add(new TabLi("/hrm/resource/HrmResourcePassword.jsp?id="+id,SystemEnv.getHtmlLabelName(81631,user.getLanguage()),true));
						tab.add(new TabLi("/hrm/password/passwordProtection.jsp?id="+id,SystemEnv.getHtmlLabelName(81604,user.getLanguage())));
						out.println(tab.show());
					} else if(_fromURL.equals("mobileSignIn")){//前端--移动考勤
						String uid = Util.null2String(request.getParameter("uid"));
						String thisDate = Util.null2String(request.getParameter("thisDate"));
						boolean showMap = Boolean.valueOf(Util.null2String(request.getParameter("showMap"), "false"));
						tab.add(new TabLi("/hrm/mobile/signin/timeView.jsp",SystemEnv.getHtmlLabelNames("277,32559",user.getLanguage()), !showMap));
						tab.add(new TabLi("/hrm/mobile/signin/mapView.jsp",SystemEnv.getHtmlLabelNames("82639,32559",user.getLanguage()), showMap));
						tab.add(new TabLi("/hrm/mobile/report/mobileSignReport.jsp",SystemEnv.getHtmlLabelName(20241,user.getLanguage()), showMap));
						out.println(tab.show());
					} else if(_fromURL.equals("systemLog")){//前端--报表--系统日志
						if(cmd.equals("SysMaintenanceLog")){//人员登入日志
							tab.add(new TabLi("/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+new XssUtil().put("where operateitem=60")+"&chartType=all&cmd=sr",SystemEnv.getHtmlLabelName(332,user.getLanguage())));
							tab.add(new TabLi("/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+new XssUtil().put("where operateitem=60")+"&chartType=day&cmd=sr",SystemEnv.getHtmlLabelName(15537,user.getLanguage()),true));
							tab.add(new TabLi("/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+new XssUtil().put("where operateitem=60")+"&chartType=week&cmd=sr",SystemEnv.getHtmlLabelName(15539,user.getLanguage())));
							tab.add(new TabLi("/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+new XssUtil().put("where operateitem=60")+"&chartType=month&cmd=sr",SystemEnv.getHtmlLabelName(15541,user.getLanguage())));
							tab.add(new TabLi("/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+new XssUtil().put("where operateitem=60")+"&chartType=quarter&cmd=sr",SystemEnv.getHtmlLabelName(21904,user.getLanguage())));
							tab.add(new TabLi("/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+new XssUtil().put("where operateitem=60")+"&chartType=year&cmd=sr",SystemEnv.getHtmlLabelName(15384,user.getLanguage())));
							out.println(tab.show());
						}else if(cmd.equals("HrmOnlineRp")){//在线人数分析
							tab.add(new TabLi("/hrm/report/onlineHrm/HrmOnlineRp.jsp?chartType=day",SystemEnv.getHtmlLabelName(31299,user.getLanguage()),true));
							tab.add(new TabLi("/hrm/report/onlineHrm/HrmOnlineRp.jsp?chartType=week",SystemEnv.getHtmlLabelName(15539,user.getLanguage())));
							tab.add(new TabLi("/hrm/report/onlineHrm/HrmOnlineRp.jsp?chartType=month",SystemEnv.getHtmlLabelName(15541,user.getLanguage())));
							tab.add(new TabLi("/hrm/report/onlineHrm/HrmOnlineRp.jsp?chartType=quarter",SystemEnv.getHtmlLabelName(21904,user.getLanguage())));
							tab.add(new TabLi("/hrm/report/onlineHrm/HrmOnlineRp.jsp?chartType=year",SystemEnv.getHtmlLabelName(15384,user.getLanguage())));
							tab.add(new TabLi("/hrm/report/onlineHrm/HrmOnlineRp.jsp?chartType=self_time",SystemEnv.getHtmlLabelName(31298,user.getLanguage())));
							out.println(tab.show());
						}else if(cmd.equals("HrmRefuseRp")){//并发登陆被限统计
							tab.add(new TabLi("/hrm/report/refuseLogin/HrmRefuseRp.jsp?chartType=day",SystemEnv.getHtmlLabelName(31299,user.getLanguage()),true));
							tab.add(new TabLi("/hrm/report/refuseLogin/HrmRefuseRp.jsp?chartType=week",SystemEnv.getHtmlLabelName(15539,user.getLanguage())));
							tab.add(new TabLi("/hrm/report/refuseLogin/HrmRefuseRp.jsp?chartType=month",SystemEnv.getHtmlLabelName(15541,user.getLanguage())));
							tab.add(new TabLi("/hrm/report/refuseLogin/HrmRefuseRp.jsp?chartType=quarter",SystemEnv.getHtmlLabelName(21904,user.getLanguage())));
							tab.add(new TabLi("/hrm/report/refuseLogin/HrmRefuseRp.jsp?chartType=year",SystemEnv.getHtmlLabelName(15384,user.getLanguage())));
							tab.add(new TabLi("/hrm/report/refuseLogin/HrmRefuseRp.jsp?chartType=self_time",SystemEnv.getHtmlLabelName(31298,user.getLanguage())));
							out.println(tab.show());
						}
					}else if(cmd.equals("hrmConst")){//统计子表
						String scopeid = Util.null2String(request.getParameter("scopeid"));
						String scopeCmd = Util.null2String(request.getParameter("scopeCmd"));
						String templateid = Util.null2String(request.getParameter("templateid"));
						if(method.equals("HrmConstRpSubSearch") && scopeid.equals("1")){//个人信息
							scopeCmd = scopeCmd.length()==0?"15687":scopeCmd;
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=15687&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("15687")?templateid:""),SystemEnv.getHtmlLabelName(15687,user.getLanguage()),scopeCmd.equals("15687")));
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=814&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("814")?templateid:""),SystemEnv.getHtmlLabelName(814,user.getLanguage()),scopeCmd.equals("814")));
							out.println(tab.show());
						}else if(method.equals("HrmConstRpSubSearch") && scopeid.equals("3")){//工作信息
							scopeCmd = scopeCmd.length()==0?"15688":scopeCmd;
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=15688&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("15688")?templateid:""),SystemEnv.getHtmlLabelName(15688,user.getLanguage()),scopeCmd.equals("15688")));
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=815&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("815")?templateid:""),SystemEnv.getHtmlLabelName(815,user.getLanguage()),scopeCmd.equals("815")));
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=813&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("813")?templateid:""),SystemEnv.getHtmlLabelName(813,user.getLanguage()),scopeCmd.equals("813")));
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=15716&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("15716")?templateid:""),SystemEnv.getHtmlLabelName(15716,user.getLanguage()),scopeCmd.equals("15716")));
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=15717&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("15717")?templateid:""),SystemEnv.getHtmlLabelName(15717,user.getLanguage()),scopeCmd.equals("15717")));
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=1502&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("1502")?templateid:""),SystemEnv.getHtmlLabelName(1502,user.getLanguage()),scopeCmd.equals("1502")));
							tab.add(new TabLi("/hrm/report/resource/"+method+".jsp?cmd=15718&scopeid="+scopeid+"&templateid="+(scopeCmd.equals("15718")?templateid:""),SystemEnv.getHtmlLabelName(15718,user.getLanguage()),scopeCmd.equals("15718")));
							out.println(tab.show());
						}
					} else if(showDiv){
				%>
					<li class="defaultTab">
						<a href="#" target="tabcontentframe" onClick="javascript:void('0')"><%=TimeUtil.getCurrentTimeString() %></a>
					</li>
		        <%} %>
		    </ul>
				    <div id="rightBox" class="e8_rightBox"></div>
			<%if(showDiv){ %>
	    		</div>
				</div>
			</div>
	    <%} %>
	    <div class="tab_box">
	    	<div>
       		<%
       		if(url.endsWith(".jsp")){
       			url +="?fromHrmTab=1";
       		}else{
       			url +="&fromHrmTab=1";
       		}
       		%>
       		<%
       			String scroll = "auto";
       			if(_fromURL.equals("HrmSalaryManageList")||_fromURL.equals("HrmSalaryManageView")){
       				scroll = "no";
       			}
       		 %>
	        <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" scrolling="<%=scroll %>"></iframe>
	      </div>
	    </div>
	</div>     
</body>
<%if(_fromURL.equals("HrmResourceSearch")||_fromURL.equals("HrmResourceSearchResult")
		||_fromURL.equals("HrmResourceAdd")||_fromURL.equals("OnlineUser")){%>
<script type="text/javascript">
window.notExecute = true;
</script>
<%}%>
</html>

