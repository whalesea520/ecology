<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.*,weaver.hrm.settings.*,weaver.conn.*,weaver.file.Prop"%>
<%@page import="java.util.*,weaver.hrm.appdetach.*"%>
<%@page import="weaver.general.*,weaver.hrm.util.html.*"%>
<%@ page import="weaver.interfaces.workflow.browser.*" %>
<%@ page import="weaver.general.IsGovProj,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.hrm.tools.HrmValidate" %>

<jsp:include page="/systeminfo/init_wev8.jsp" />

<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hasRs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="getAccountType" class="weaver.general.AccountType" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="PortalUtil" class="weaver.rdeploy.portal.PortalUtil" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
User user = HrmUserVarify.getUser (request , response) ;
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language=javascript src="/hrm/search/HrmResourceSearchResult_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript">
  function sendmail(){
    //openFullWindowForXtable("/sendmail/HrmChoice.jsp?issearch=1");
    var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(1226,user.getLanguage())%>";
	dialog.Width = 800;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = "/hrm/HrmTab.jsp?_fromURL=HrmChoice";
	dialog.show();
   }
   
function sendEmessage(emessageId){
	var isGroup = false;
	if(!emessageId){
		var emessageId = _xtable_CheckedCheckboxId();
		isGroup = true;
	}
	if(!emessageId){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("126853,1867",user.getLanguage())%>");
		return;
	}
	if(emessageId.match(/,$/)){
		emessageId = emessageId.substring(0,emessageId.length-1);
	}
	var openType = isGroup?"2":"0";
	if(isGroup){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(130319,user.getLanguage())%>",function(){
			sendMsgToPCorWeb(emessageId,openType,'','');
		},function(){
		  	return false;
		})
	}else{
		sendMsgToPCorWeb(emessageId,openType,'','');
	}
}
function onSaveas(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceSearchMould&isdialog=1";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>";
	dialog.Width = 500;
	dialog.Height = 203;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
	document.resource.opera.value="delete";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.target="";
	document.resource.submit();
	jQuery("#advancedSearch").click();
	}
}
    function onBtnSearchClickRight(){
	if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
		onBtnSearchClick();
	}else{
		try{
			jQuery("span#searchblockspan",parent.document).find("img:first").click();
		}catch(e){
			onBtnSearchClick();
		}
	}
}
</script>
<style type="text/css">
.weatable_mouldid{
background:transparent;
}
</style>
</head>
<%
if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String from = Util.null2String(request.getParameter("from"));
String cmd = Util.null2String(request.getParameter("cmd"));

boolean cansave = HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
String groupSqlwhere = "";
String pubGroupUser = GroupAction.getPubGroupUser(user);
String priGroupUser = GroupAction.getPriGroupUser(user);

String canSeeGroupids = pubGroupUser+","+priGroupUser;
if(canSeeGroupids.length() > 0){
	groupSqlwhere += " ("+Util.getSubINClause(canSeeGroupids, "id", "in")+") ";
}else{
	groupSqlwhere += " 1 = 2 ";
}
if(!cansave){
	groupSqlwhere += " and type = 0";
}


ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
String checkUnJob = Util.null2String(settings.getCheckUnJob(),"0");//非在职人员信息查看控制 启用后，只有有“离职人员查看”权限的用户才能检索非在职人员

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid = user.getUID();
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();//账号类型
boolean issys = false;
boolean isfin = false;
boolean ishr  = false;
String sql = "select hrmid from HrmInfoMaintenance where id = 1";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    issys = true;
    break;
  }
}
sql = "select hrmid from HrmInfoMaintenance where id = 2";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    isfin = true;
    break;
  }
}
if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
  ishr = true;
}

String qname=Util.null2String(request.getParameter("flowTitle"));
if(qname.length()==0 && Util.null2String(HrmSearchComInfo.getResourcename()).length()>0){
	//处理分页过滤数据无效问题
	qname = HrmSearchComInfo.getResourcename();
}
//日期控件处理
String startdateselect = Util.null2String(request.getParameter("startdateselect"));
String enddateselect = Util.null2String(request.getParameter("enddateselect")); 
String bepartydateselect = Util.null2String(request.getParameter("bepartydateselect"));
String contractdateselect = Util.null2String(request.getParameter("contractdateselect")); 
String bememberdateselect =Util.null2String(request.getParameter("bememberdateselect"));
String birthdaydateselect =Util.null2String(request.getParameter("birthdaydateselect"));
/**
String hasresourceid="";
String hasresourcename="";
String hasjobtitle    ="";
String hasactivitydesc="";
String hasjobgroup    ="";
String hasjobactivity ="";
String hascostcenter  ="";
String hascompetency  ="";
String hasresourcetype="";
String hasstatus      ="";
String hassubcompany  ="";
String hasdepartment  ="";
String hasvirtualdepartment="";
String haslocation    ="";
String hasmanager     ="";
String hasassistant   ="";
String hasroles       ="";
String hasseclevel    ="";
String hasjoblevel    ="";
String hasworkroom    ="";
String hastelephone   ="";
String hasstartdate   ="";
String hasenddate     ="";
String hascontractdate="";
String hasbirthday    ="";
String hassex         ="";
String hasaccounttype = "";
String hasage         ="";
String projectable    ="";
String crmable        ="";
String itemable       ="";
String docable        ="";
String workflowable   ="";
String subordinateable="";
String trainable      ="";
String budgetable     ="";
String fnatranable    ="";
String dspperpage     ="";
String hasworkcode = "";
String hasjobcall = "";
String hasmobile = "";
String hasmobilecall = "";
String hasfax = "";
String hasemail = "";
String hasfolk = "";
String hasnativeplace = "";
String hasregresidentplace = "";
String hasmaritalstatus = "";
String hascertificatenum = "";
String hastempresidentnumber = "";
String hasresidentplace = "";
String hashomeaddress = "";
String hashealthinfo = "";
String hasheight = "";
String hasweight = "";
String haseducationlevel = "";
String hasdegree = "";
String hasusekind = "";
String haspolicy = "";
String hasbememberdate = "";
String hasbepartydate = "";
String hasislabouunion = "";
String hasbankid1 = "";
String hasaccountid1 = "";
String hasaccumfundaccount = "";
String hasloginid = "";
String hassystemlanguage = "";


**/

String departmentStr = "";

String hasgroup = "";

hasRs.executeProc("HrmUserDefine_SelectByID",""+userid);
if(hasRs.next()){} ;

String dff01use = "";
String dff02use = "";
String dff03use = "";
String dff04use = "";
String dff05use = "";
String tff01use = "";
String tff02use = "";
String tff03use = "";
String tff04use = "";
String tff05use = "";
String nff01use = "";
String nff02use = "";
String nff03use = "";
String nff04use = "";
String nff05use = "";
String bff01use = "";
String bff02use = "";
String bff03use = "";
String bff04use = "";
String bff05use = "";

boolean hasFF = true;
rs2.executeProc("Base_FreeField_Select","hr");
if(rs2.getCounts()<=0){
	hasFF = false;
}else{
	rs2.first();
	dff01use=rs2.getString("dff01use");
	dff02use=rs2.getString("dff02use");
	dff03use=rs2.getString("dff03use");
	dff04use=rs2.getString("dff04use");
	dff05use=rs2.getString("dff05use");
	tff01use=rs2.getString("tff01use");
	tff02use=rs2.getString("tff02use");
	tff03use=rs2.getString("tff03use");
	tff04use=rs2.getString("tff04use");
	tff05use=rs2.getString("tff05use");
	bff01use=rs2.getString("bff01use");
	bff02use=rs2.getString("bff02use");
	bff03use=rs2.getString("bff03use");
	bff04use=rs2.getString("bff04use");
	bff05use=rs2.getString("bff05use");
	nff01use=rs2.getString("nff01use");
	nff02use=rs2.getString("nff02use");
	nff03use=rs2.getString("nff03use");
	nff04use=rs2.getString("nff04use");
	nff05use=rs2.getString("nff05use");
	
}

	String companyid = Util.null2String(request.getParameter("companyid"));
	String subcompany1 = Util.null2String(request.getParameter("subcompany1"));
	String department = Util.null2String(request.getParameter("department"));
	HrmSearchComInfo.initSearchParam(userid,user.getLanguage(),request);
	int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);
	String resourceid   = HrmSearchComInfo.getResourceid();
	String resourcename = HrmSearchComInfo.getResourcename();
	String jobtitle     = HrmSearchComInfo.getJobtitle();
	String activitydesc = HrmSearchComInfo.getActivitydesc();
	String jobgroup     = HrmSearchComInfo.getJobgroup();
	String jobactivity  = HrmSearchComInfo.getJobactivity();
	String costcenter   = HrmSearchComInfo.getCostcenter();
	String competency   = HrmSearchComInfo.getCompetency();
	String resourcetype = HrmSearchComInfo.getResourcetype();
	String status       = HrmSearchComInfo.getStatus();
	subcompany1  = HrmSearchComInfo.getSubcompany1();
	String departments = HrmSearchComInfo.getDepartment();
	ArrayList departmentlist = Util.TokenizerString(departments,",");
	for(int i=0;i<departmentlist.size();i++){
		department += ((String)departmentlist.get(i) + ",");
		departmentStr += DepartmentComInfo.getDepartmentname((String)departmentlist.get(i)) + "&nbsp;,";
	}
	if(!"".equals(department)){
		department = department.substring(0, department.length()-1);
		departmentStr = departmentStr.substring(0, departmentStr.length()-1);
	}
	String location     = HrmSearchComInfo.getLocation();
	String manager      = HrmSearchComInfo.getManager();
	String assistant    = HrmSearchComInfo.getAssistant();
	String roles        = HrmSearchComInfo.getRoles();
	String seclevel     = HrmSearchComInfo.getSeclevel();
	String seclevelTo   = HrmSearchComInfo.getSeclevelTo();
	String joblevel     = HrmSearchComInfo.getJoblevel();
	String joblevelTo   = HrmSearchComInfo.getJoblevelTo();
	String workroom     = HrmSearchComInfo.getWorkroom();
	String telephone    = HrmSearchComInfo.getTelephone();
	String startdate    = HrmSearchComInfo.getStartdate();
	String startdateTo  = HrmSearchComInfo.getStartdateTo();
	String enddate      = HrmSearchComInfo.getEnddate();
	String enddateTo    = HrmSearchComInfo.getEnddateTo();
	String contractdate = HrmSearchComInfo.getContractdate();//试用期结束日期
	String contractdateTo = HrmSearchComInfo.getContractdateTo();
	String birthdaydate   = HrmSearchComInfo.getBirthdaydate();
	String birthdaydateTo = HrmSearchComInfo.getBirthdaydateTo();
	String age            = HrmSearchComInfo.getAge();
	String ageTo          = HrmSearchComInfo.getAgeTo();
	String sex            = HrmSearchComInfo.getSex();
	int accounttype =  HrmSearchComInfo.getAccounttype();
	String resourceidfrom     = HrmSearchComInfo.getResourceidfrom();
	String resourceidto       = HrmSearchComInfo.getResourceidto();
	String workcode           = HrmSearchComInfo.getWorkcode();
	String jobcall            = HrmSearchComInfo.getJobcall();
	String mobile             = HrmSearchComInfo.getMobile();
	String mobilecall         = HrmSearchComInfo.getMobilecall();
	String fax                = HrmSearchComInfo.getFax();
	String email              = HrmSearchComInfo.getEmail();
	String folk               = HrmSearchComInfo.getFolk();
	String nativeplace        = HrmSearchComInfo.getNativeplace();
	String regresidentplace   = HrmSearchComInfo.getRegresidentplace();
	String maritalstatus      = HrmSearchComInfo.getMaritalstatus();
	String certificatenum     = HrmSearchComInfo.getCertificatenum();
	String tempresidentnumber = HrmSearchComInfo.getTempresidentnumber();
	String residentplace      = HrmSearchComInfo.getResidentplace();
	String homeaddress        = HrmSearchComInfo.getHomeaddress();
	String healthinfo         = HrmSearchComInfo.getHealthinfo();
	String heightfrom         = HrmSearchComInfo.getHeightfrom();
	String heightto           = HrmSearchComInfo.getHeightto();
	String weightfrom         = HrmSearchComInfo.getWeightfrom();
	String weightto           = HrmSearchComInfo.getWeightto();
	String educationlevel     = HrmSearchComInfo.getEducationlevel();
	String educationlevelTo   = HrmSearchComInfo.getEducationlevelTo();
	String degree             = HrmSearchComInfo.getDegree();
	String usekind            = HrmSearchComInfo.getUsekind();
	String policy             = HrmSearchComInfo.getPolicy();
	String bememberdatefrom   = HrmSearchComInfo.getBememberdatefrom();
	String bememberdateto     = HrmSearchComInfo.getBememberdateto();
	String bepartydatefrom    = HrmSearchComInfo.getBepartydatefrom();
	String bepartydateto      = HrmSearchComInfo.getBepartydateto();
	String islabouunion       = HrmSearchComInfo.getIslabouunion();
	String bankid1            = HrmSearchComInfo.getBankid1();
	String accountid1         = HrmSearchComInfo.getAccountid1();
	String accumfundaccount   = HrmSearchComInfo.getAccumfundaccount();
	String loginid            = HrmSearchComInfo.getLoginid();
	String systemlanguage     = HrmSearchComInfo.getSystemlanguage();
	
	String dff01name = HrmSearchComInfo.getDff01name();
	String dff02name = HrmSearchComInfo.getDff02name();
	String dff03name = HrmSearchComInfo.getDff03name();
	String dff04name = HrmSearchComInfo.getDff04name();
	String dff05name = HrmSearchComInfo.getDff05name();
	String dff01nameto = HrmSearchComInfo.getDff01nameto();
	String dff02nameto = HrmSearchComInfo.getDff02nameto();
	String dff03nameto = HrmSearchComInfo.getDff03nameto();
	String dff04nameto = HrmSearchComInfo.getDff04nameto();
	String dff05nameto = HrmSearchComInfo.getDff05nameto();
	String nff01name = HrmSearchComInfo.getNff01name();
	String nff02name = HrmSearchComInfo.getNff02name();
	String nff03name = HrmSearchComInfo.getNff03name();
	String nff04name = HrmSearchComInfo.getNff04name();
	String nff05name = HrmSearchComInfo.getNff05name();
	String nff01nameto = HrmSearchComInfo.getNff01nameto();
	String nff02nameto = HrmSearchComInfo.getNff02nameto();
	String nff03nameto = HrmSearchComInfo.getNff03nameto();
	String nff04nameto = HrmSearchComInfo.getNff04nameto();
	String nff05nameto = HrmSearchComInfo.getNff05nameto();
	String tff01name = HrmSearchComInfo.getTff01name();
	String tff02name = HrmSearchComInfo.getTff02name();
	String tff03name = HrmSearchComInfo.getTff03name();
	String tff04name = HrmSearchComInfo.getTff04name();
	String tff05name = HrmSearchComInfo.getTff05name();
	String bff01name = HrmSearchComInfo.getBff01name();
	String bff02name = HrmSearchComInfo.getBff02name();
	String bff03name = HrmSearchComInfo.getBff03name();
	String bff04name = HrmSearchComInfo.getBff04name();
	String bff05name = HrmSearchComInfo.getBff05name();
	String virtualtype = HrmSearchComInfo.getVirtualType();
	
	String groupid = HrmSearchComInfo.getGroupid();
	String groupVaild = HrmSearchComInfo.getGroupVaild();

String showTitle = SystemEnv.getHtmlLabelName(16418,user.getLanguage());
if(department.length()>0){
	showTitle = DepartmentComInfo.getDepartmentNames(department);
}else if(subcompany1.length()>0){
	showTitle = SubCompanyComInfo.getSubcompanynames(subcompany1);
}else if(companyid.length()>0){
	showTitle = CompanyComInfo.getCompanyname(companyid);
}

showTitle = Util.toHtmlMode(showTitle);

Integer lg=(Integer)user.getLanguage();
weaver.general.AccountType.langId.set(lg);
String mode = Prop.getPropValue(GCONST.getConfigFile(), "authentic");
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String sqlwhere = HrmSearchComInfo.FormatSQLSearch();
/*String temptable = "hrmtemptable"+ Util.getRandom() ;
String Hrm_SearchSql = "";

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0)*/;

String tempsearchsql = HrmSearchComInfo.FormatSQLSearch();
String dbtype=RecordSet.getDBType() ;
String tempstr = "" ;
if(tempsearchsql.length() > 0 && tempsearchsql.indexOf("order by") >=0 ) tempstr = tempsearchsql.substring(0,tempsearchsql.indexOf("order by"));

AppDetachComInfo adci = new AppDetachComInfo();
String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"");
if(!"".equals(tempstr)) tempstr += (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
else tempstr = appdetawhere;
int subcompanyid=-1;
if(!DepartmentComInfo.getSubcompanyid1(department).equals(""))
    subcompanyid=Integer.parseInt(DepartmentComInfo.getSubcompanyid1(department));

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceAdd:Add",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add", user))
        operatelevel=2;
}
%>
<BODY>
<script type="text/javascript">
parent.setTabObjName('<%=showTitle%>');
<%if(!Util.null2String(HrmSearchComInfo.getSearchFrom()).equals("hrmResource")){%>
jQuery(document).ready(function(){
<%if(showTitle.length()>0){%>
 parent.setTabObjName('<%=showTitle%>')
 <%}%>
 <%if(from.equals("QuickSearch")){%>
 parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(16418,user.getLanguage())%>');
 //parent.showMyTree();
 <%}else if(from.equals("hrmorg")){%>
  parent.setTabObjName('<%=virtualtype.equals("1") ? Util.toHtmlMode(DepartmentComInfo.getDepartmentNames(department)) : Util.toHtmlMode(DepartmentVirtualComInfo.getDepartmentNames(department))%>');
 <%}%>
});
<%}%>
function onNewResource(departmentid){
	window.parent.location.href="/hrm/HrmTab.jsp?_fromURL=HrmResourceAdd&departmentid="+departmentid;
}
  function addToGroup(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25468,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/group/MultiGroupBrowser.jsp?sqlwhere=<%=xssUtil.put(groupSqlwhere)%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("126252",user.getLanguage())%>";
	dialog.Width = 576;
	dialog.Height = 632;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callback = addGroupMember;
	dialog.show();
   }
function addGroupMember(data){
	var id = _xtable_CheckedCheckboxId();
	jQuery.ajax({
		type: "post",
		url: "/hrm/group/HrmGroupData.jsp",
		data: {method:"addGroupMember",userid:id, groupid:data.id},
		dataType: "JSON",
		success: function(result){
			window.location.reload();
		}
	});
} 
</script>

<jsp:include page="/hrm/search/HrmResourceSearchResult_click.jsp" />


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(from.equals("HrmResourceAdd")){ %>
			<input type=button class="e8_btn_top" onclick="onNewResource('<%=department %>');" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>">
			<%} %>
			<%
			if(HrmValidate.hasEmessage(user)){
			 %>
			<input type=button class="e8_btn_top" onclick="sendEmessage();" value="<%=SystemEnv.getHtmlLabelName(130343, user.getLanguage())%>"></input>
			<%} %>	
			<input type=button class="e8_btn_top" onclick="addToGroup();" value="<%=SystemEnv.getHtmlLabelName(130759, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" id="flowTitle" name="flowTitle" value="<%=qname %>" onchange="setKeyword('flowTitle','resourcename','resource');"/>
			<%if (!PortalUtil.isuserdeploy()) {%>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form class=ViewForm id="resource" name="resource" method="post" action="HrmResourceSearchTmp.jsp">
<input id=searchForm name=searchForm type="hidden" value="">
<input id=belongto name=belongto type="hidden" value="<%=HrmSearchComInfo.getBelongto() %>">
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>' attributes="{'isColspan':'false'}">
   	<wea:item  type="groupHead">
			<select name="mouldid"  onchange="jsChangeMould(this)" style="width: 135px;" _notreset=true>
     		<option value="0"><%=SystemEnv.getHtmlLabelNames("149,64",user.getLanguage())%></option>
     		<%
     		RecordSet.executeProc("HrmSearchMould_SelectByUserID",""+userid);
				while(RecordSet.next()){
				%>
					<option value="<%=RecordSet.getString(1)%>" <%=RecordSet.getString(1).equals(""+mouldid)?"selected":""%>><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></option>
    	  <%}%>
     </select>
		</wea:item>
    <%if("1".equals(Util.fromScreen(hasRs.getString(3),user.getLanguage())) && (mouldid==0||!(resourcename.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
    <wea:item><INPUT type="text" class=inputstyle id=resourcename name=resourcename style="width: 165px" size=20 value='<%=resourcename%>'></wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString(15),user.getLanguage())) && (mouldid==0||!(manager.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0"  name="manager" browserValue='<%=manager %>' 
    browserOnClick=""
    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp" width="165px"
    browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>'></brow:browser>
    </wea:item>
  	<%}if("1".equals(Util.fromScreen(hasRs.getString(12),user.getLanguage())) && (mouldid==0||!(subcompany1.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
    <wea:item>
    <%String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="; %>
   	<brow:browser viewType="0" name="subcompany1" browserValue='<%=subcompany1 %>' 
           browserUrl='<%= browserUrl %>'
           hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
           completeUrl="/data.jsp?type=164"
           browserSpanValue='<%=subcompany1.length()>0?Util.toScreen(SubCompanyComInfo.getSubcompanynames(subcompany1+""),user.getLanguage()):""%>'>
   	</brow:browser>
    	<input type='hidden' name='shareid' value='0'>
    	<span id="showrelatedsharename" class='showrelatedsharename'  name='showrelatedsharename'></span>
  	 </wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString(13),user.getLanguage())) && (mouldid==0||!(department.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
    <wea:item>
    <%
    	String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?excludeid="+department+"&selectedids=";
    %>
    <brow:browser viewType="0"  name="department" browserValue='<%=department %>' 
     browserOnClick=""
     browserurl='<%=browserUrl %>'
     hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
     completeUrl="/data.jsp?type=4"
     browserSpanValue='<%=Util.toScreen(departmentStr,user.getLanguage())%>'></brow:browser>
    </wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString("hasvirtualdepartment"),user.getLanguage())) && (mouldid==0||!(virtualtype.equals("")))){
   		//有虚拟部门才显示
			if(CompanyVirtualComInfo.getCompanyNum()>0){ 
     %>
     <wea:item><%=SystemEnv.getHtmlLabelName(34069,user.getLanguage())%></wea:item>
  	 <wea:item>
    	<select name=virtualtype style="width: 135px">
    		<option value=""></option>
    		<%
    		if(CompanyComInfo.getCompanyNum()>0){
    			CompanyComInfo.setTofirstRow();
    			while(CompanyComInfo.next()){
    		%>
    		<option value="<%=CompanyComInfo.getCompanyid() %>" <%=virtualtype.equals(CompanyComInfo.getCompanyid())?"selected":"" %>><%=CompanyComInfo.getCompanyname() %></option>
    		<%} }%>
    		<%
    		CompanyVirtualComInfo.setTofirstRow();
    		while(CompanyVirtualComInfo.next()){
    		%>
    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" <%=virtualtype.equals(CompanyVirtualComInfo.getCompanyid())?"selected":"" %>><%=CompanyVirtualComInfo.getVirtualType() %></option>
    		<%} %>
    	</select>
  	</wea:item>
     <%}}if("1".equals(Util.fromScreen(hasRs.getString(21),user.getLanguage())) && (mouldid==0||!(telephone.equals("")))){ %>
    <wea:item><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></wea:item>
    <wea:item><INPUT type="text"  class=inputstyle name=telephone style="width: 165px" value='<%=telephone%>'>
    </wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString("hasmobile"),user.getLanguage())) && (mouldid==0||!(mobile.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type="text" name=mobile style="width: 165px"  value='<%=mobile%>'></wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString("hasmobilecall"),user.getLanguage())) && (mouldid==0||!(mobilecall.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type="text" name=mobilecall  style="width: 165px" value='<%=mobilecall%>'></wea:item>
  	<%}if("1".equals(Util.fromScreen(hasRs.getString(4),user.getLanguage())) && (mouldid==0||!(jobtitle.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
    <wea:item>
    	<!-- 
    	<brow:browser viewType="0" name="jobtitle" browserValue='<%= jobtitle %>' 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=hrmjobtitles" width="165px"
      browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>'>
      </brow:browser>	
    	 -->
      <input name="jobtitle" type="text"  class=inputstyle value="<%=jobtitle%>" style="width: 165px">	 
    </wea:item>
    <%}
    
    if(hasgroup.equals("1") && (mouldid==0||!(groupid.equals("")))){
		String dataBrowser = "/data.jsp?type=hrmgroup&sqlwhere="+xssUtil.put(groupSqlwhere);
    	String groupBrowserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/group/MultiGroupBrowser.jsp?sqlwhere="+xssUtil.put(groupSqlwhere)+"&selectedids=";
    %>
    <wea:item><%=SystemEnv.getHtmlLabelName(81554,user.getLanguage())%></wea:item>
    <wea:item>
			<table style="width:100%">
				<tr>
					<td style="width:55%">
					<% String emptyStr = "" ;  %>
			<brow:browser viewType="0" name="groupid" browserValue="<%=groupid %>" 
	          browserUrl="<%=groupBrowserUrl %>"
	          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	          completeUrl="<%=dataBrowser %>"  nameSplitFlag=","
	          browserSpanValue="<%=groupid.length()>0?Util.toScreen(GroupAction.getGroupNames(groupid),user.getLanguage()): emptyStr %>" >
	      </brow:browser>
					</td>
					<td style="width:45%;">
	      <input name="groupVaild" <%if ("1".equals(groupVaild)) out.println("checked");%>   tzCheckbox="true" type="checkbox" value="1">
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(131423,user.getLanguage())%>" />
					</td>
				</tr>
			</table>
    </wea:item>
    <%}%>
    </wea:group>
    <wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item attributes="{'colspan':'full'}">
	    	<div style="width: 100%;text-align: right;">
	    		<span _status="1" class="myHideBlockDiv" style="color: rgb(204, 204, 204);">
					<%=SystemEnv.getHtmlLabelName(89, user.getLanguage())%> <img src="/wui/theme/ecology8/templates/default/images/1_wev8.png"></span>&nbsp;&nbsp;
	    	</div>
    	</wea:item>
    </wea:group>
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','isColspan':'false','groupOperDisplay':'none'}">
    <%if("1".equals(Util.fromScreen(hasRs.getString("hassex"),user.getLanguage())) && (mouldid==0||!(sex.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
    <wea:item>
    	<select class=inputstyle id=sex name=sex style="width: 135px">
   		<option value="" <% if(sex.equals("")) {%>selected<%}%>></option>
       <option value=0 <% if(sex.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
       <option value=1 <% if(sex.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
      <!-- 
      <option value=2 <% if(sex.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%></option>
       -->
    	</select>
  	 </wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString(11),user.getLanguage())) && (mouldid==0||!(status.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
    <wea:item>
    	<%if(status.equals("")){status = "8";}%>
     	<SELECT class=inputstyle id=status name=status value="<%=status%>" style="width: 135px">
     		<%
     		if("1".equals(checkUnJob)){//启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
     		if(HrmUserVarify.checkUserRight("hrm:departureView",user)){ %>
	       	 	<OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
	        <%}}else{%>
	       	 	<OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
	        <%} %>
        <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
        <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
        <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
        <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
        <%
   		if("1".equals(checkUnJob)){//启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
        	if(HrmUserVarify.checkUserRight("hrm:departureView",user)){ %>
        <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
        <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
        <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
        <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
        <%}}else{%>
        <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
        <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
        <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
        <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
        <%} %>
        <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
    	</SELECT>
    </wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString("hasworkcode"),user.getLanguage())) &&(mouldid==0||!(workcode.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type="text" name=workcode style="width: 165px" value='<%=workcode%>'></wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString(16),user.getLanguage())) && (mouldid==0||!(assistant.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0"  name="assistant" browserValue='<%=assistant %>' 
    browserOnClick=""
    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp" width="165px"
    browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(assistant),user.getLanguage())%>'></brow:browser>
    </wea:item>
    <%}if(flagaccount && "1".equals(Util.fromScreen(hasRs.getString("hasaccounttype"),user.getLanguage())) && (mouldid ==0 || !("".equals(Util.fromScreen(hasRs.getString("hasaccounttype"),user.getLanguage()))))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></wea:item>
    <wea:item>
    	<select class=inputstyle id=accounttype name=accounttype style="width: 135px">
   			<option value="" <% if(sex.equals("")) {%>selected<%}%>></option>
        <option value=0 <% if(accounttype ==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
        <option value=1 <% if(accounttype ==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
    	</select>
    </wea:item>
		<%}if("1".equals(Util.fromScreen(hasRs.getString(5),user.getLanguage())) && (mouldid==0||!(activitydesc.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type="text" name=activitydesc size=20 value='<%=activitydesc%>' style="width: 165px"></wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString(7),user.getLanguage())) && (mouldid==0||!(jobactivity.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0" name="jobactivity" browserValue='<%= jobactivity %>' 
    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp?type=jobactivity" width="165px"
    browserSpanValue='<%=JobActivitiesComInfo.getJobActivitiesname(jobactivity)%>'>
    </brow:browser>
    </wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString("hasjobcall"),user.getLanguage())) && (mouldid==0||!(jobcall.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0"  name="jobcall" browserValue='<%=jobcall %>' 
    browserOnClick=""
    browserurl="/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp?type=jobcall" width="165px"
    browserSpanValue='<%=JobCallComInfo.getJobCallname(jobcall)%>'></brow:browser>
    </wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString(6),user.getLanguage())) && (mouldid==0||!(jobgroup.equals("0")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(15854,user.getLanguage())%></wea:item>
       <wea:item>
       		<brow:browser viewType="0" name="jobgroup" browserValue='<%= jobgroup %>' 
              browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp?selectedids="
              hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
              completeUrl="/data.jsp?type=jobgroup" width="165px"
              browserSpanValue='<%=JobGroupsComInfo.getJobGroupsname(jobgroup)%>'>
      		</brow:browser>
       </wea:item>
      <%}if("1".equals(Util.fromScreen(hasRs.getString(19),user.getLanguage())) && (mouldid==0||!(joblevel.equals("0"))||!(joblevelTo.equals("0")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></wea:item>
       <wea:item>
       	<INPUT class=inputstyle type="text" name=joblevel size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")' value="<%=joblevel%>" style="width: 50px">
        -<INPUT class=inputstyle type="text" name=joblevelTo size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelTo")' value="<%=joblevelTo%>" style="width: 50px">
       </wea:item>
       <%}if("1".equals(Util.fromScreen(hasRs.getString(20),user.getLanguage())) && (mouldid==0||!(workroom.equals("")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></wea:item>
       <wea:item><INPUT class=inputstyle type="text" name=workroom  value='<%=workroom%>' style="width: 165px"></wea:item>
       <%}if("1".equals(Util.fromScreen(hasRs.getString(14),user.getLanguage())) && (mouldid==0||!(location.equals("0")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></wea:item>
       <wea:item>
      	<brow:browser viewType="0" name="location" browserValue='<%= location %>' 
              browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp?selectedids="
              hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
              completeUrl="/data.jsp?type=location" width="165px"
              browserSpanValue='<%=Util.toScreen(LocationComInfo.getLocationname(location),user.getLanguage())%>'>
      	</brow:browser>
       </wea:item>
       <%}if("1".equals(Util.fromScreen(hasRs.getString("hasfax"),user.getLanguage())) && (mouldid==0||!(fax.equals("")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
       <wea:item><INPUT type="text" class=inputstyle name=fax  value='<%=fax%>' style="width: 165px"></wea:item>
       <%}if("1".equals(Util.fromScreen(hasRs.getString("hasemail"),user.getLanguage())) && (mouldid==0||!(email.equals("")))){%>
       <wea:item>E-mail</wea:item>
       <wea:item><INPUT class=inputstyle type="text" name=email   value='<%=email%>' style="width: 165px"></wea:item>
       <%}%>
         <%
			if(hasFF || mouldid==0){
			if((dff01use.equals("1")) && (mouldid==0|| !(dff01name.equals("")) || !(dff01nameto.equals("")))){%>
        <wea:item><%=rs2.getString("dff01name")%></wea:item>
        <wea:item>
          <BUTTON class=Calendar type="button" id=selectdff01name onclick="getDate(dff01namespan,dff01name)"></BUTTON>
          <SPAN id=dff01namespan ><%=dff01name%></SPAN> －
          <BUTTON class=Calendar type="button" id=selectdff01nameto onclick="getDate(dff01nametospan,dff01nameto)"></BUTTON>
          <SPAN id=dff01nametospan ><%=dff01nameto%></SPAN>
          <input class=inputstyle type="hidden" name=dff01name value="<%=dff01name%>">
          <input class=inputstyle type="hidden" name=dff01nameto value="<%=dff01nameto%>">
        </wea:item>
       <%}if((dff02use.equals("1")) && (mouldid==0|| !(dff02name.equals(""))||!(dff02nameto.equals("")))){%>
         <wea:item><%=rs2.getString("dff02name")%></wea:item>
         <wea:item>
           <BUTTON class=Calendar type="button" id=selectdff02name onclick="getDate(dff02namespan,dff02name)"></BUTTON>
           <SPAN id=dff02namespan ><%=dff02name%></SPAN> －
           <BUTTON class=Calendar type="button" id=selectdff02nameto onclick="getDate(dff02nametospan,dff02nameto)"></BUTTON>
           <SPAN id=dff02nametospan ><%=dff02nameto%></SPAN>
           <input class=inputstyle type="hidden" name=dff02name value="<%=dff02name%>">
           <input class=inputstyle type="hidden" name=dff02nameto value="<%=dff02nameto%>">
         </wea:item>
        <%}if((dff03use.equals("1")) && (mouldid==0|| !(dff03name.equals(""))||!(dff03nameto.equals("")))){%>
         <wea:item><%=rs2.getString("dff03name")%></wea:item>
         <wea:item>
           <BUTTON class=Calendar type="button" id=selectdff03name onclick="getDate(dff03namespan,dff03name)"></BUTTON>
           <SPAN id=dff03namespan ><%=dff03name%></SPAN> －
           <BUTTON class=Calendar type="button" id=selectdff03nameto onclick="getDate(dff03nametospan,dff03nameto)"></BUTTON>
           <SPAN id=dff03nametospan ><%=dff03nameto%></SPAN>
           <input class=inputstyle type="hidden" name=dff03name value="<%=dff03name%>">
           <input class=inputstyle type="hidden" name=dff03nameto value="<%=dff03nameto%>">
         </wea:item>
         <%}if((dff04use.equals("1")) && (mouldid==0|| !(dff04name.equals(""))||!(dff04nameto.equals("")))){%>
         <wea:item><%=rs2.getString("dff04name")%></wea:item>
         <wea:item>
         	<BUTTON class=Calendar type="button" id=selectdff04name onclick="getDate(dff04namespan,dff04name)"></BUTTON>
           <SPAN id=dff04namespan ><%=dff04name%></SPAN> －
           <BUTTON class=Calendar type="button" id=selectdff04nameto onclick="getDate(dff04nametospan,dff04nameto)"></BUTTON>
           <SPAN id=dff04nametospan ><%=dff04nameto%></SPAN>
           <input class=inputstyle type="hidden" name=dff04name value="<%=dff04name%>">
           <input class=inputstyle type="hidden" name=dff04nameto value="<%=dff04nameto%>">
         </wea:item>
         <%}if((dff05use.equals("1")) && (mouldid==0|| !(dff05name.equals(""))||!(dff05nameto.equals("")))){%>
         <wea:item><%=rs2.getString("dff05name")%></wea:item>
         <wea:item>
           <BUTTON class=Calendar type="button" id=selectdff05name onclick="getDate(dff05namespan,dff05name)"></BUTTON>
           <SPAN id=dff05namespan ><%=dff05name%></SPAN> －
           <BUTTON class=Calendar type="button" id=selectdff05nameto onclick="getDate(dff05nametospan,dff05nameto)"></BUTTON>
           <SPAN id=dff05nametospan ><%=dff05nameto%></SPAN>
           <input class=inputstyle type="hidden" name=dff05name value="<%=dff05name%>">
           <input class=inputstyle type="hidden" name=dff05nameto value="<%=dff05nameto%>">
         </wea:item>
         <%}if((nff01use.equals("1")) && (mouldid==0|| !(nff01name.equals(""))||!(nff01nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff01name")%></wea:item>
         <wea:item>
         	<INPUT class=inputstyle type="text" name=nff01name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff01name")' value="<%=nff01name%>" style="width: 50px">
             －<INPUT class=inputstyle type="text" name=nff01nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff01nameto")' value="<%=nff01nameto%>" style="width: 50px">
         </wea:item>
         <%}if((nff02use.equals("1")) && (mouldid==0|| !(nff02name.equals(""))||!(nff02nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff02name")%></wea:item>
         <wea:item>
           <INPUT class=inputstyle type="text" name=nff02name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff02name")' value="<%=nff02name%>" style="width: 50px">
           －<INPUT class=inputstyle type="text" name=nff02nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff02nameto")' value="<%=nff02nameto%>" style="width: 50px">
         </wea:item>
         <%}if((nff03use.equals("1")) && (mouldid==0|| !(nff03name.equals(""))||!(nff03nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff03name")%></wea:item>
         <wea:item>
           <INPUT class=inputstyle type="text" name=nff03name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff03name")' value="<%=nff03name%>" style="width: 50px" style="width: 50px">
           	－<INPUT class=inputstyle type="text" name=nff03nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff03nameto")' value="<%=nff03nameto%>">
         </wea:item>
         <%}if((nff04use.equals("1")) && ( mouldid==0||!(nff04name.equals(""))||!(nff04nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff04name")%></wea:item>
         <wea:item>
           <INPUT class=inputstyle type="text" name=nff04name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff04name")' value="<%=nff04name%>" style="width: 50px">
           	－<INPUT class=inputstyle type="text" name=nff04nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff04nameto")' value="<%=nff04nameto%>" style="width: 50px">
         </wea:item>
         <%}if((nff05use.equals("1")) && (mouldid==0|| !(nff05name.equals(""))||!(nff05nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff05name")%></wea:item>
         <wea:item>
           <INPUT class=inputstyle type="text" name=nff05name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff05name")' value="<%=nff05name%>" style="width: 50px">
           	－<INPUT class=inputstyle type="text" name=nff05nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff05nameto")' value="<%=nff05nameto%>" style="width: 50px">
         </wea:item>
         <%}if(tff01use.equals("1") && (mouldid==0 || !(tff01name.equals("")))){%>
         <wea:item><%=rs2.getString("tff01name")%></wea:item>
         <wea:item><INPUT type="text" class=inputstyle name=tff01name value='<%=tff01name%>' style="width: 165px"></wea:item>
         <%}if(tff02use.equals("1") && (mouldid==0|| !(tff02name.equals("")))){%>
         <wea:item><%=rs2.getString("tff02name")%></wea:item>
				<wea:item><INPUT type="text" class=inputstyle name=tff02name value='<%=tff02name%>' style="width: 165px"></wea:item>
         <%}if(tff03use.equals("1") && (mouldid==0|| !(tff03name.equals("")))){%>
         <wea:item><%=rs2.getString("tff03name")%></wea:item>
         <wea:item><INPUT type="text" class=inputstyle name=tff03name value='<%=tff03name%>' style="width: 165px"></wea:item>
         <%}if(tff04use.equals("1") && (mouldid==0|| !(tff04name.equals("")))){%>
         <wea:item><%=rs2.getString("tff04name")%></wea:item>
         <wea:item><INPUT type="text" class=inputstyle name=tff04name value='<%=tff04name%>' style="width: 165px"></wea:item>
         <%}if(tff05use.equals("1") && ( mouldid==0||!(tff05name.equals("")))){%>
         <wea:item><%=rs2.getString("tff05name")%></wea:item>
				<wea:item><INPUT type="text" class=inputstyle name=tff05name value='<%=tff05name%>' style="width: 165px"></wea:item>
         <%}if((bff01use.equals("1")) && (mouldid==0||!(bff01name.equals("0")))){%>
         <wea:item><%=rs2.getString("bff01name")%></wea:item>
         <wea:item><INPUT class=inputstyle type=checkbox  name=bff01name value="1" <%if(bff01name.equals("1")){%> checked <%}%> ></wea:item>
         <%}if((bff02use.equals("1")) && (mouldid==0||!(bff02name.equals("0")))){%>
         <wea:item><%=rs2.getString("bff02name")%></wea:item>
         <wea:item><INPUT class=inputstyle type=checkbox  name=bff02name value="1" <%if(bff02name.equals("1")){%> checked <%}%> ></wea:item>
         <%}if((bff03use.equals("1")) && (mouldid==0||!(bff03name.equals("0")))){%>
         <wea:item><%=rs2.getString("bff03name")%></wea:item>
         <wea:item><INPUT class=inputstyle type=checkbox  name=bff03name value="1" <%if(bff03name.equals("1")){%> checked <%}%> ></wea:item>
         <%}if((bff04use.equals("1")) && (mouldid==0||!(bff04name.equals("0")))){%>
         <wea:item><%=rs2.getString("bff04name")%></wea:item>
         <wea:item><INPUT class=inputstyle type=checkbox  name=bff04name value="1" <%if(bff04name.equals("1")){%> checked <%}%> ></wea:item>
         <%}if((bff05use.equals("1")) && (mouldid==0||!(bff05name.equals("0")))){%>
         <wea:item><%=rs2.getString("bff05name")%></wea:item>
         <wea:item><INPUT class=inputstyle type=checkbox  name=bff05name value="1" <%if(bff05name.equals("1")){%> checked <%}%> ></wea:item>
         <%}}%>
         </wea:group>
		 <wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="submitData();">
			  <%if(mouldid==0){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="resetConditionHrmSearch();jQuery('#flowTitle').val('');jQuery('#flowTitle',parent.document).val('')">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18418, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="onSaveas();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32668, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="HrmUserDefine();">
			  <%}else{ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="onUpdateSaveas();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(350, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="onSaveas();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="onDelSaveas();">
				<%} %>
			  <input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage()) %>" id="cancel" class="e8_btn_cancel" >
			</wea:item>
			</wea:group>
</wea:layout>
<jsp:include page="HrmResourceSearchResult_inner.jsp" />
</div>
<input class=inputstyle type="hidden" name="opera">
<input class=inputstyle type="hidden" name="mouldid" value="<%=mouldid%>">
<input class=inputstyle type="hidden" name="mouldname" value="">
</FORM>

<input type="hidden" name="pageId" id="pageId" _showCol=<%=!PortalUtil.isuserdeploy() %> value="<%=HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)?PageIdConst.HRM_ResourceSearchResultByManager:PageIdConst.HRM_ResourceSearchResult %>"/>


<%
request.getSession().setAttribute("hrmSearchTmpStr",tempstr);
%>
<jsp:include page="/hrm/search/HrmResourceSearchinc.jsp" />

<iframe name="excels" id="excels" src="" style="display:none" ></iframe> 
<FORM id=weaver name=frmMain action="HrmResourceSearchResult.jsp" method=post>
    <input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>" >
</FORM>
</BODY>
<script type="text/javascript">
<%if(!from.equals("hrmorg")){%>
parent.rebindNavEvent(null,null,null,parent.parent.loadLeftTree,{_window:window,hasLeftTree:true});
<%}%>

function resetConditionHrmSearch(){
	var selector="#advancedSearchDiv";
	//清空文本框
	jQuery(selector).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(selector).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(selector).find(".e8_os").find("input[type='hidden']").val("");
	//清空下拉框
	try{
		jQuery(selector).find("select").selectbox("reset");
	}catch(e){
		jQuery(selector).find("select").each(function(){
			var $target = jQuery(this);
			var _defaultValue = $target.attr("_defaultValue");
			if(!_defaultValue){
				var option = $target.find("option:first");
				_defaultValue = option.attr("value");
			}
			$target.val(_defaultValue).trigger("change");
		});
	}
	jQuery("#status").selectbox("change",8);
	//清空日期
	jQuery(selector).find(".calendar").siblings("span").html("");
	jQuery(selector).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find(".Calendar").siblings("span").html("");
	jQuery(selector).find(".Calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find("input[type='checkbox']").each(function(){
		try{
			changeCheckboxStatus(this,false);
		}catch(e){
			this.checked = false;
		}
	});
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
