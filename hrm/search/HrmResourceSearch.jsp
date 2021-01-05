<%@ page import="weaver.general.*,java.util.*,weaver.docs.docs.CustomFieldManager,weaver.interfaces.workflow.browser.*,weaver.conn.*" %>
<%@ page import="weaver.hrm.util.html.*,weaver.hrm.*,weaver.hrm.settings.*,weaver.systeminfo.*"%>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder,org.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="PortalUtil" class="weaver.rdeploy.portal.PortalUtil" scope="page"/>
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<style type="text/css">
.weatable_mouldid{
background:transparent;
}
</style>
</head>
<%
User user = HrmUserVarify.getUser(request, response);
if (PortalUtil.isuserdeploy()) {
    request.getRequestDispatcher("/rdeploy/hrm/RdHrmSearch.jsp").forward(request, response);
    return;
}
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
String from = Util.null2String(request.getParameter("from"));
String cmd = Util.null2String(request.getParameter("cmd"));

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

//日期控件处理
String startdateselect = Util.null2String(request.getParameter("startdateselect"));
String enddateselect = Util.null2String(request.getParameter("enddateselect")); 
String bepartydateselect = Util.null2String(request.getParameter("bepartydateselect"));
String contractdateselect = Util.null2String(request.getParameter("contractdateselect")); 
String bememberdateselect =Util.null2String(request.getParameter("bememberdateselect"));
String birthdaydateselect =Util.null2String(request.getParameter("birthdaydateselect"));

String departmentStr = "";

RecordSet hasRs = new RecordSet() ;

hasRs.executeProc("HrmUserDefine_SelectByID",""+userid);
if(hasRs.next()){} ;

	String resourceid ="";
	String resourcename ="";
	String jobtitle   ="";
	String activitydesc="";
	String jobgroup   ="";
	String jobactivity="";
	String costcenter ="";
	String competency ="";
	String resourcetype ="";
	String status       ="";
	String companyid = Util.null2String(request.getParameter("companyid"));
	String subcompany1 = Util.null2String(request.getParameter("subcompany1"));
	String subcompany2 ="";
	String subcompany3 ="";
	String subcompany4 ="";
	String department = Util.null2String(request.getParameter("department"));
	String departments ="";
	String location   ="";
	String manager    ="";
	String assistant  ="";
	String roles      ="";
	String seclevel  ="";
	String seclevelTo  ="";
	String joblevel  ="";
  String joblevelTo  ="";
	String workroom     ="";
	String telephone    ="";
	String startdate  ="";
	String startdateTo  ="";
	String enddate    ="";
	String enddateTo    ="";
	String contractdate ="";
	String contractdateTo ="";
	String birthdaydate  ="";
	String birthdaydateTo   ="";
  String age        ="";
  String ageTo        ="";
	String sex          ="";
	int accounttype = -1;
	String resourceidfrom = "";
	String resourceidto = "";
	String workcode = "";
	String jobcall = "";
	String mobile = "";
	String mobilecall = "";
	String fax = "";
	String email = "";
	String virtualtype = "";
	String folk = "";
	String nativeplace = "";
	String regresidentplace = "";
	String maritalstatus = "";
	String certificatenum = "";
	String tempresidentnumber = "";
	String residentplace = "";
	String homeaddress = "";
	String healthinfo = "";
	String heightfrom = "";
	String heightto = "";
	String weightfrom = "";
	String weightto = "";
	String educationlevel = "";
	String educationlevelTo = "";
	String degree = "";
	String usekind = "";
	String policy = "";
	String bememberdatefrom = "";
	String bememberdateto = "";
	String bepartydatefrom = "";
	String bepartydateto = "";
	String islabouunion = "";
	String bankid1 = "";
	String accountid1 = "";
	String accumfundaccount = "";
	String loginid = "";
	String systemlanguage = "";
	//自定义字段Begin
	/*日期型Begin*/
	String dff01name ="";
	String dff02name ="";
	String dff03name ="";
	String dff04name ="";
	String dff05name ="";
	String dff01nameto ="";
	String dff02nameto ="";
	String dff03nameto ="";
	String dff04nameto ="";
	String dff05nameto ="";
	/*日期型End*/
	/*数字型Begin*/
	String nff01name = "";
	String nff02name = "";
	String nff03name = "";
	String nff04name = "";
	String nff05name = "";
	String nff01nameto = "";
	String nff02nameto = "";
	String nff03nameto = "";
	String nff04nameto = "";
	String nff05nameto = "";
	/*数字型End*/
	/*文本型Begin*/
	String tff01name = "";
	String tff02name = "";
	String tff03name = "";
	String tff04name = "";
	String tff05name = "";
	/*文本型End*/
	/*booleanBegin*/
	String bff01name = "";
	String bff02name = "";
	String bff03name = "";
	String bff04name = "";
	String bff05name = "";
	/*booleanEnd*/
	//自定义字段End
	String groupid = "";
	String groupVaild = "";
	
	rs1.executeSql("select * from HrmSearchMould where 1=2");
	String[] hrmsearchcol = rs1.getColumnName();
	ArrayList hrmsearchList = new ArrayList();
	for(int i=0;i<hrmsearchcol.length;i++){
		hrmsearchList.add(hrmsearchcol[i]);
	}
	int scopeId = -1;
	CustomFieldManager cfm1 = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
	scopeId = 0;
	cfm1.getCustomFields();
	String mouldcolname = "";
	Map customFieldMapBase=new HashMap();
	ArrayList customFieldListBase = new ArrayList();
	while(cfm1.next()){
		mouldcolname = "column_"+scopeId+"_"+cfm1.getId();
		customFieldListBase.add(mouldcolname);
		if(hrmsearchList.contains(mouldcolname) || hrmsearchList.contains(mouldcolname.toUpperCase())){
			continue;
		}else{
			if("oracle".equals(rs1.getDBType())){
				rs1.executeSql("ALTER TABLE HrmSearchMould ADD " + mouldcolname + " varchar2(200) NULL");
			}else{
				rs1.executeSql("ALTER TABLE HrmSearchMould ADD " + mouldcolname + " varchar(200) NULL");
			}
		}
	}
	for(int i=0;i<hrmsearchList.size();i++){
		String searchcolname = (String)hrmsearchList.get(i);
		if(searchcolname.startsWith("column_"+scopeId+"_")){
			if(!customFieldListBase.contains(searchcolname)){
				rs1.executeSql("ALTER TABLE HrmSearchMould DROP COLUMN  " + searchcolname );
			}
		}
	}
	scopeId = 1;
	cfm1 = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
	cfm1.getCustomFields();
	mouldcolname = "";
	Map customFieldMapPersonal=new HashMap();
	ArrayList customFieldListPersonal = new ArrayList();
	while(cfm1.next()){
		mouldcolname = "column_"+scopeId+"_"+cfm1.getId();
		customFieldListPersonal.add(mouldcolname);
		if(hrmsearchList.contains(mouldcolname) || hrmsearchList.contains(mouldcolname.toUpperCase())){
			continue;
		}else{
			if("oracle".equals(rs1.getDBType())){
				rs1.executeSql("ALTER TABLE HrmSearchMould ADD " + mouldcolname + " varchar2(200) NULL");
			}else{
				rs1.executeSql("ALTER TABLE HrmSearchMould ADD " + mouldcolname + " varchar(200) NULL");
			}
		}
	}
	for(int i=0;i<hrmsearchList.size();i++){
		String searchcolname = (String)hrmsearchList.get(i);
		if(searchcolname.startsWith("column_"+scopeId+"_")){
			//System.out.println("searchcolname:"+searchcolname);
			if(!customFieldListPersonal.contains(searchcolname)){
				rs1.executeSql("ALTER TABLE HrmSearchMould DROP COLUMN  " + searchcolname );
			}
		}
	}
	
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);

RecordSet.executeProc("HrmSearchMould_SelectByID",""+mouldid);
if(RecordSet.next()){

	 resourceid   =Util.toScreenToEdit(RecordSet.getString("resourceid"),user.getLanguage());
	 resourcename =Util.toScreenToEdit(RecordSet.getString("resourcename"),user.getLanguage());
	 jobtitle     =Util.toScreenToEdit(RecordSet.getString("jobtitle"),user.getLanguage());
	 activitydesc =Util.toScreenToEdit(RecordSet.getString("activitydesc"),user.getLanguage());
	 jobgroup     =Util.toScreenToEdit(RecordSet.getString("jobgroup"),user.getLanguage());
	 jobactivity  =Util.toScreenToEdit(RecordSet.getString("jobactivity"),user.getLanguage());
	 costcenter   =Util.toScreenToEdit(RecordSet.getString("costcenter"),user.getLanguage());
	 competency   =Util.toScreenToEdit(RecordSet.getString("competency"),user.getLanguage());
	 resourcetype =Util.toScreenToEdit(RecordSet.getString("resourcetype"),user.getLanguage());
	 status       =Util.toScreenToEdit(RecordSet.getString("status"),user.getLanguage());
	 subcompany1  =Util.toScreenToEdit(RecordSet.getString("subcompany1"),user.getLanguage());
	 departments = Util.toScreenToEdit(RecordSet.getString("department"),user.getLanguage());
	 ArrayList departmentlist = Util.TokenizerString(departments,",");
		for(int i=0;i<departmentlist.size();i++){
			department += ((String)departmentlist.get(i) + ",");
			departmentStr += DepartmentComInfo.getDepartmentname((String)departmentlist.get(i)) + "&nbsp;,";
		}
		if(!"".equals(department)){
			department = department.substring(0, department.length()-1);
			departmentStr = departmentStr.substring(0, departmentStr.length()-1);
		}
	 location     =Util.toScreenToEdit(RecordSet.getString("location"),user.getLanguage());
	 manager      =Util.toScreenToEdit(RecordSet.getString("manager"),user.getLanguage());
	 assistant    =Util.toScreenToEdit(RecordSet.getString("assistant"),user.getLanguage());
	 roles        =Util.toScreenToEdit(RecordSet.getString("roles"),user.getLanguage());
	 seclevel     =Util.toScreenToEdit(RecordSet.getString("seclevel"),user.getLanguage());
	 seclevelTo   =Util.toScreenToEdit(RecordSet.getString("seclevelTo"),user.getLanguage());
	 joblevel     =Util.toScreenToEdit(RecordSet.getString("joblevel"),user.getLanguage());
	 joblevelTo   =Util.toScreenToEdit(RecordSet.getString("joblevelTo"),user.getLanguage());
	 workroom     =Util.toScreenToEdit(RecordSet.getString("workroom"),user.getLanguage());
	 telephone    =Util.toScreenToEdit(RecordSet.getString("telephone"),user.getLanguage());
	 startdate    =Util.toScreenToEdit(RecordSet.getString("startdate"),user.getLanguage());
	 startdateTo  =Util.toScreenToEdit(RecordSet.getString("startdateTo"),user.getLanguage());
	 enddate      =Util.toScreenToEdit(RecordSet.getString("enddate"),user.getLanguage());
	 enddateTo    =Util.toScreenToEdit(RecordSet.getString("enddateTo"),user.getLanguage());
	 contractdate =Util.toScreenToEdit(RecordSet.getString("contractdate"),user.getLanguage());//试用期结束日期
	 contractdateTo =Util.toScreenToEdit(RecordSet.getString("contractdateTo"),user.getLanguage());
	 birthdaydate       =Util.toScreenToEdit(RecordSet.getString("birthdaydate"),user.getLanguage());
   birthdaydateTo     =Util.toScreenToEdit(RecordSet.getString("birthdaydateTo"),user.getLanguage());
   age            =Util.toScreenToEdit(RecordSet.getString("age"),user.getLanguage());
   ageTo          =Util.toScreenToEdit(RecordSet.getString("ageTo"),user.getLanguage());
	 sex            =Util.toScreenToEdit(RecordSet.getString("sex"),user.getLanguage());
	 accounttype =  RecordSet.getInt("accounttype");
	 resourceidfrom     = Util.toScreenToEdit(RecordSet.getString("resourceidfrom"),user.getLanguage());
	 resourceidto       = Util.toScreenToEdit(RecordSet.getString("resourceidto"),user.getLanguage());
	 workcode           = Util.toScreenToEdit(RecordSet.getString("workcode"),user.getLanguage());
	 jobcall            = Util.toScreenToEdit(RecordSet.getString("jobcall"),user.getLanguage());
	 mobile             = Util.toScreenToEdit(RecordSet.getString("mobile"),user.getLanguage());
	 mobilecall         = Util.toScreenToEdit(RecordSet.getString("mobilecall"),user.getLanguage());
	 fax                = Util.toScreenToEdit(RecordSet.getString("fax"),user.getLanguage());
	 email              = Util.toScreenToEdit(RecordSet.getString("email"),user.getLanguage());
	 virtualtype  = Util.toScreenToEdit(RecordSet.getString("virtualtype"),user.getLanguage());
	 folk               = Util.toScreenToEdit(RecordSet.getString("folk"),user.getLanguage());
	 nativeplace        = Util.toScreenToEdit(RecordSet.getString("nativeplace"),user.getLanguage());
	 regresidentplace   = Util.toScreenToEdit(RecordSet.getString("regresidentplace"),user.getLanguage());
	 maritalstatus      = Util.toScreenToEdit(RecordSet.getString("maritalstatus"),user.getLanguage());
	 certificatenum     = Util.toScreenToEdit(RecordSet.getString("certificatenum"),user.getLanguage());
	 tempresidentnumber = Util.toScreenToEdit(RecordSet.getString("tempresidentnumber"),user.getLanguage());
	 residentplace      = Util.toScreenToEdit(RecordSet.getString("residentplace"),user.getLanguage());
	 homeaddress        = Util.toScreenToEdit(RecordSet.getString("homeaddress"),user.getLanguage());
	 healthinfo         = Util.toScreenToEdit(RecordSet.getString("healthinfo"),user.getLanguage());
	 heightfrom         = Util.toScreenToEdit(RecordSet.getString("heightfrom"),user.getLanguage());
	 heightto           = Util.toScreenToEdit(RecordSet.getString("heightto"),user.getLanguage());
	 weightfrom         = Util.toScreenToEdit(RecordSet.getString("weightfrom"),user.getLanguage());
	 weightto           = Util.toScreenToEdit(RecordSet.getString("weightto"),user.getLanguage());
	 educationlevel     = Util.toScreenToEdit(RecordSet.getString("educationlevel"),user.getLanguage());
	 educationlevelTo   = Util.toScreenToEdit(RecordSet.getString("educationlevelto"),user.getLanguage());
	 degree             = Util.toScreenToEdit(RecordSet.getString("degree"),user.getLanguage());
	 usekind            = Util.toScreenToEdit(RecordSet.getString("usekind"),user.getLanguage());
	 policy             = Util.toScreenToEdit(RecordSet.getString("policy"),user.getLanguage());
	 bememberdatefrom   = Util.toScreenToEdit(RecordSet.getString("bememberdatefrom"),user.getLanguage());
	 bememberdateto     = Util.toScreenToEdit(RecordSet.getString("bememberdateto"),user.getLanguage());
	 bepartydatefrom    = Util.toScreenToEdit(RecordSet.getString("bepartydatefrom"),user.getLanguage());
	 bepartydateto      = Util.toScreenToEdit(RecordSet.getString("bepartydateto"),user.getLanguage());
	 islabouunion       = Util.toScreenToEdit(RecordSet.getString("islabouunion"),user.getLanguage());
	 bankid1            = Util.toScreenToEdit(RecordSet.getString("bankid1"),user.getLanguage());
	 accountid1         = Util.toScreenToEdit(RecordSet.getString("accountid1"),user.getLanguage());
	 accumfundaccount   = Util.toScreenToEdit(RecordSet.getString("accumfundaccount"),user.getLanguage());
	 loginid            = Util.toScreenToEdit(RecordSet.getString("loginid"),user.getLanguage());
	 systemlanguage     = Util.toScreenToEdit(RecordSet.getString("systemlanguage"),user.getLanguage());
	 
	 dff01name = Util.toScreenToEdit(RecordSet.getString("datefield1"),user.getLanguage());
	 dff02name = Util.toScreenToEdit(RecordSet.getString("datefield2"),user.getLanguage());
	 dff03name = Util.toScreenToEdit(RecordSet.getString("datefield3"),user.getLanguage());
	 dff04name = Util.toScreenToEdit(RecordSet.getString("datefield4"),user.getLanguage());
	 dff05name = Util.toScreenToEdit(RecordSet.getString("datefield5"),user.getLanguage());
	 dff01nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto1"),user.getLanguage());
	 dff02nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto2"),user.getLanguage());
	 dff03nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto3"),user.getLanguage());
	 dff04nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto4"),user.getLanguage());
	 dff05nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto5"),user.getLanguage());
	 nff01name = Util.toScreenToEdit(RecordSet.getString("numberfield1"),user.getLanguage());
	 nff02name = Util.toScreenToEdit(RecordSet.getString("numberfield2"),user.getLanguage());
	 nff03name = Util.toScreenToEdit(RecordSet.getString("numberfield3"),user.getLanguage());
	 nff04name = Util.toScreenToEdit(RecordSet.getString("numberfield4"),user.getLanguage());
	 nff05name = Util.toScreenToEdit(RecordSet.getString("numberfield5"),user.getLanguage());
	 nff01nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto1"),user.getLanguage());
	 nff02nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto2"),user.getLanguage());
	 nff03nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto3"),user.getLanguage());
	 nff04nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto4"),user.getLanguage());
	 nff05nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto5"),user.getLanguage());
	 tff01name = Util.toScreenToEdit(RecordSet.getString("textfield1"),user.getLanguage());
	 tff02name = Util.toScreenToEdit(RecordSet.getString("textfield2"),user.getLanguage());
	 tff03name = Util.toScreenToEdit(RecordSet.getString("textfield3"),user.getLanguage());
	 tff04name = Util.toScreenToEdit(RecordSet.getString("textfield4"),user.getLanguage());
	 tff05name = Util.toScreenToEdit(RecordSet.getString("textfield5"),user.getLanguage());
	 bff01name = Util.toScreenToEdit(RecordSet.getString("tinyintfield1"),user.getLanguage());
	 bff02name = Util.toScreenToEdit(RecordSet.getString("tinyintfield2"),user.getLanguage());
	 bff03name = Util.toScreenToEdit(RecordSet.getString("tinyintfield3"),user.getLanguage());
	 bff04name = Util.toScreenToEdit(RecordSet.getString("tinyintfield4"),user.getLanguage());
	 bff05name = Util.toScreenToEdit(RecordSet.getString("tinyintfield5"),user.getLanguage());
	 String customFieldvalue = "";
	 String columnName = "";
	 for(int i=0;i<customFieldListBase.size();i++){
		 columnName = customFieldListBase.get(i).toString();
		 customFieldvalue = Util.toScreenToEdit(RecordSet.getString(columnName),user.getLanguage());
		 customFieldMapBase.put(columnName,customFieldvalue);
	 }
	 for(int i=0;i<customFieldListPersonal.size();i++){
		 columnName = customFieldListPersonal.get(i).toString();
		 customFieldvalue = Util.toScreenToEdit(RecordSet.getString(columnName),user.getLanguage());
		 customFieldMapPersonal.put(columnName,customFieldvalue);
	 }
	 groupid = Util.toScreenToEdit(RecordSet.getString("groupid"),user.getLanguage());
	 groupVaild = Util.toScreenToEdit(RecordSet.getString("groupVaild"),user.getLanguage());
}
String showTitle = "";
if(department.length()>0){
	showTitle = DepartmentComInfo.getDepartmentNames(department);
}else if(subcompany1.length()>0){
	showTitle = SubCompanyComInfo.getSubcompanynames(subcompany1);
}else if(companyid.length()>0){
	showTitle = CompanyComInfo.getCompanyname(companyid);
}
%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(showTitle.length()>0){%>
 <%}%>
 parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(16418,user.getLanguage())%>');
});

function onNewResource(departmentid){
	window.parent.location.href="/hrm/HrmTab.jsp?_fromURL=HrmResourceAdd&departmentid="+departmentid;
}
</script>
<BODY>

<jsp:include page="HrmResourceSearch_click.jsp"></jsp:include>

<form class=ViewForm id="resource" name="resource" method="post" action="HrmResourceSearchTmp.jsp">
<input name=searchForm type="hidden" value="hrmResource">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>">
			<%if(mouldid==0){ %>
			<input type=button class="e8_btn_top" onclick="resetCondtion();" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>">
  			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(18418, user.getLanguage()) %>" id="zd_btn_submit" onclick="onSaveas();">
  			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(32668, user.getLanguage()) %>" id="zd_btn_submit" onclick="HrmUserDefine();">
  		<%}else{ %>
  			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" onclick="onUpdateSaveas();">
  			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(350, user.getLanguage()) %>" id="zd_btn_submit" onclick="onSaveas();">
  			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" id="zd_btn_submit" onclick="onDelSaveas();">
  		<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="advancedSearchDiv">
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'isColspan':'false'}">
    <wea:item  type="groupHead">
			<select name="mouldid"  onchange="jsChangeMould(this)" style="width: 135px;">
     		<option value="0"><%=SystemEnv.getHtmlLabelNames("149,64",user.getLanguage())%></option>
     		<%
     		RecordSet.executeProc("HrmSearchMould_SelectByUserID",""+userid);
				while(RecordSet.next()){
				%>
					<option value="<%=RecordSet.getString(1)%>" <%=RecordSet.getString(1).equals(""+mouldid)?"selected":""%>><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></option>
    	  <%}%>
     </select>
		</wea:item>
    <%if("1".equals(hasRs.getString(3)) && (mouldid==0||!(resourcename.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
    <wea:item><INPUT type="text" class=inputstyle name=resourcename style="width: 165px" size=20 value='<%=resourcename%>'></wea:item>
    <%}if("1".equals(hasRs.getString(15)) && (mouldid==0||!(manager.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0"  name="manager" browserValue='<%=manager %>' 
    browserOnClick=""
    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' linkUrl="javascript:openhrm($id$)"
    completeUrl="/data.jsp" width="165px"
    browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>'></brow:browser>
    </wea:item>
  	<%}if("1".equals(hasRs.getString(12)) && (mouldid==0||!(subcompany1.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
    <wea:item>
    <%String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=";%>
   	<brow:browser viewType="0" name="subcompany1" browserValue='<%=subcompany1 %>' 
           browserUrl='<%= browserUrl %>'
           hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
           completeUrl="/data.jsp?type=164"
           browserSpanValue='<%=subcompany1.length()>0?Util.toScreen(SubCompanyComInfo.getSubcompanynames(subcompany1+""),user.getLanguage()):""%>'>
   	</brow:browser>
    	<input type='hidden' name='shareid' value='0'>
    	<span id="showrelatedsharename" class='showrelatedsharename'  name='showrelatedsharename'></span>
  	 </wea:item>
    <%}if("1".equals(hasRs.getString(13)) && (mouldid==0||!(department.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0" name="department" browserValue='<%=department %>' 
     browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
     hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
     completeUrl="/data.jsp?type=4"
     browserSpanValue='<%=Util.toScreen(departmentStr,user.getLanguage())%>'></brow:browser>
    </wea:item>
    <%
    }if("1".equals(hasRs.getString("hasvirtualdepartment")) && (mouldid==0||!(virtualtype.equals("")))){
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
     <%}}if("1".equals(hasRs.getString(21)) && (mouldid==0||!(telephone.equals("")))){ %>
    <wea:item><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></wea:item>
    <wea:item><INPUT type="text"  class=inputstyle name=telephone style="width: 165px" value='<%=telephone%>'>
    </wea:item>
    <%}if("1".equals(hasRs.getString("hasmobile")) && (mouldid==0||!(mobile.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type="text" name=mobile style="width: 165px"  value='<%=mobile%>'></wea:item>
    <%}if("1".equals(hasRs.getString("hasmobilecall")) && (mouldid==0||!(mobilecall.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type="text" name=mobilecall  style="width: 165px" value='<%=mobilecall%>'></wea:item>
  	<%}if("1".equals(hasRs.getString(4)) && (mouldid==0||!(jobtitle.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
    <wea:item>
      <input name="jobtitle" type="text"  class=inputstyle value="<%=jobtitle%>" style="width: 165px">	
    </wea:item>
    <%}if("1".equals(Util.fromScreen(hasRs.getString("hasgroup"),user.getLanguage())) && (mouldid==0||!(groupid.equals("")))){
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
	          completeUrl="<%=dataBrowser %>" nameSplitFlag=","
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
    <%} %>
    <%if("1".equals(hasRs.getString("hassex")) && (mouldid==0||!(sex.equals("")))){%>
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
    <%}if("1".equals(hasRs.getString(11)) && (mouldid==0||!(status.equals("")))){%>
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
        <%if("0".equals(checkUnJob) || HrmUserVarify.checkUserRight("hrm:departureView",user)){ //没有启动或者 拥有权限的人员 可以看离职
        %>
        <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
        <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
        <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
        <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
        <%}%>
        <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
    	</SELECT>
    </wea:item>
    <%}if("1".equals(hasRs.getString("hasworkcode")) &&(mouldid==0||!(workcode.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type="text" name=workcode style="width: 165px" value='<%=workcode%>'></wea:item>
    <%}if("1".equals(hasRs.getString(16)) && (mouldid==0||!(assistant.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0"  name="assistant" browserValue='<%=assistant %>' 
    browserOnClick=""
    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp" width="165px"
    browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(assistant),user.getLanguage())%>'></brow:browser>
    </wea:item>
    <%}if(flagaccount && "1".equals(hasRs.getString("hasaccounttype")) && (mouldid ==0 || !("".equals(hasRs.getString("hasaccounttype"))))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></wea:item>
    <wea:item>
    	<select class=inputstyle id=accounttype name=accounttype style="width: 135px">
   			<option value="" <% if(sex.equals("")) {%>selected<%}%>></option>
        <option value=0 <% if(accounttype ==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
        <option value=1 <% if(accounttype ==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
    	</select>
    </wea:item>
		<%}if("1".equals(hasRs.getString(5)) && (mouldid==0||!(activitydesc.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle style="width: 165px" type="text" name=activitydesc size=20 value='<%=activitydesc%>'></wea:item>
    <%}if("1".equals(hasRs.getString(7)) && (mouldid==0||!(jobactivity.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0" name="jobactivity" browserValue='<%= jobactivity %>' 
    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp?type=jobactivity" width="165px"
    browserSpanValue='<%=JobActivitiesComInfo.getJobActivitiesname(jobactivity)%>'>
    </brow:browser>
    </wea:item>
    <%}if("1".equals(hasRs.getString("hasjobcall")) && (mouldid==0||!(jobcall.equals("0")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></wea:item>
    <wea:item>
    <brow:browser viewType="0"  name="jobcall" browserValue='<%=jobcall %>' 
    browserOnClick=""
    browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobcall/JobCallBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp?type=jobcall" width="165px"
    browserSpanValue='<%=JobCallComInfo.getJobCallname(jobcall)%>'></brow:browser>
    </wea:item>
    <%}if("1".equals(hasRs.getString(6)) && (mouldid==0||!(jobgroup.equals("0")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></wea:item>
       <wea:item>
       		<brow:browser viewType="0" name="jobgroup" browserValue='<%= jobgroup %>' 
              browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobgroups/JobGroupsBrowser.jsp?selectedids="
              hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
              completeUrl="/data.jsp?type=jobgroup" width="165px"
              browserSpanValue='<%=JobGroupsComInfo.getJobGroupsname(jobgroup)%>'>
      		</brow:browser>
       </wea:item>
      <%}if("1".equals(hasRs.getString(19)) && (mouldid==0||!(joblevel.equals("0"))||!(joblevelTo.equals("0")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></wea:item>
       <wea:item>
       	<INPUT class=inputstyle type="text" name=joblevel size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")' value="<%=joblevel%>" style="width: 50px">&nbsp;-&nbsp;<INPUT class=inputstyle type="text" name=joblevelTo size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelTo")' value="<%=joblevelTo%>" style="width: 50px">
       </wea:item>
       <%}if("1".equals(hasRs.getString(20)) && (mouldid==0||!(workroom.equals("")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></wea:item>
       <wea:item><INPUT class=inputstyle style="width: 165px" type="text" name=workroom  value='<%=workroom%>'></wea:item>
       <%}if("1".equals(hasRs.getString(14)) && (mouldid==0||!(location.equals("0")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></wea:item>
       <wea:item>
      	<brow:browser viewType="0" name="location" browserValue='<%= location %>' 
              browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/location/LocationBrowser.jsp?selectedids="
              hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
              completeUrl="/data.jsp?type=location" width="165px"
              browserSpanValue='<%=Util.toScreen(LocationComInfo.getLocationname(location),user.getLanguage())%>'>
      	</brow:browser>
       </wea:item>
       <%}if("1".equals(hasRs.getString("hasfax")) && (mouldid==0||!(fax.equals("")))){%>
       <wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
       <wea:item><INPUT type="text" class=inputstyle style="width: 165px" name=fax  value='<%=fax%>'></wea:item>
       <%}if("1".equals(hasRs.getString("hasemail")) && (mouldid==0||!(email.equals("")))){%>
       <wea:item>E-mail</wea:item>
       <wea:item><INPUT class=inputstyle type="text" name=email style="width: 165px"  value='<%=email%>'></wea:item>
       <%}%>
         <%
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
			if(hasFF || mouldid==0){
			if((dff01use.equals("1")) && (mouldid==0|| !(dff01name.equals("")) || !(dff01nameto.equals("")))){%>
        <wea:item><%=rs2.getString("dff01name")%></wea:item>
        <wea:item>
          <BUTTON type="button" class=Calendar id=selectdff01name onclick="getDate(dff01namespan,dff01name)"></BUTTON>
          <SPAN id=dff01namespan ><%=dff01name%></SPAN> －
          <BUTTON type="button" class=Calendar id=selectdff01nameto onclick="getDate(dff01nametospan,dff01nameto)"></BUTTON>
          <SPAN id=dff01nametospan ><%=dff01nameto%></SPAN>
          <input class=inputstyle type="hidden" name=dff01name value="<%=dff01name%>">
          <input class=inputstyle type="hidden" name=dff01nameto value="<%=dff01nameto%>">
        </wea:item>
       <%}if((dff02use.equals("1")) && (mouldid==0|| !(dff02name.equals(""))||!(dff02nameto.equals("")))){%>
         <wea:item><%=rs2.getString("dff02name")%></wea:item>
         <wea:item>
           <BUTTON type="button" class=Calendar id=selectdff02name onclick="getDate(dff02namespan,dff02name)"></BUTTON>
           <SPAN id=dff02namespan ><%=dff02name%></SPAN> －
           <BUTTON type="button" class=Calendar id=selectdff02nameto onclick="getDate(dff02nametospan,dff02nameto)"></BUTTON>
           <SPAN id=dff02nametospan ><%=dff02nameto%></SPAN>
           <input class=inputstyle type="hidden" name=dff02name value="<%=dff02name%>">
           <input class=inputstyle type="hidden" name=dff02nameto value="<%=dff02nameto%>">
         </wea:item>
        <%}if((dff03use.equals("1")) && (mouldid==0|| !(dff03name.equals(""))||!(dff03nameto.equals("")))){%>
         <wea:item><%=rs2.getString("dff03name")%></wea:item>
         <wea:item>
           <BUTTON type="button" class=Calendar id=selectdff03name onclick="getDate(dff03namespan,dff03name)"></BUTTON>
           <SPAN id=dff03namespan ><%=dff03name%></SPAN> －
           <BUTTON type="button" class=Calendar id=selectdff03nameto onclick="getDate(dff03nametospan,dff03nameto)"></BUTTON>
           <SPAN id=dff03nametospan ><%=dff03nameto%></SPAN>
           <input class=inputstyle type="hidden" name=dff03name value="<%=dff03name%>">
           <input class=inputstyle type="hidden" name=dff03nameto value="<%=dff03nameto%>">
         </wea:item>
         <%}if((dff04use.equals("1")) && (mouldid==0|| !(dff04name.equals(""))||!(dff04nameto.equals("")))){%>
         <wea:item><%=rs2.getString("dff04name")%></wea:item>
         <wea:item>
         	<BUTTON type="button" class=Calendar id=selectdff04name onclick="getDate(dff04namespan,dff04name)"></BUTTON>
           <SPAN id=dff04namespan ><%=dff04name%></SPAN> －
           <BUTTON type="button" class=Calendar id=selectdff04nameto onclick="getDate(dff04nametospan,dff04nameto)"></BUTTON>
           <SPAN id=dff04nametospan ><%=dff04nameto%></SPAN>
           <input class=inputstyle type="hidden" name=dff04name value="<%=dff04name%>">
           <input class=inputstyle type="hidden" name=dff04nameto value="<%=dff04nameto%>">
         </wea:item>
         <%}if((dff05use.equals("1")) && (mouldid==0|| !(dff05name.equals(""))||!(dff05nameto.equals("")))){%>
         <wea:item><%=rs2.getString("dff05name")%></wea:item>
         <wea:item>
           <BUTTON type="button" class=Calendar id=selectdff05name onclick="getDate(dff05namespan,dff05name)"></BUTTON>
           <SPAN id=dff05namespan ><%=dff05name%></SPAN> －
           <BUTTON type="button" class=Calendar id=selectdff05nameto onclick="getDate(dff05nametospan,dff05nameto)"></BUTTON>
           <SPAN id=dff05nametospan ><%=dff05nameto%></SPAN>
           <input class=inputstyle type="hidden" name=dff05name value="<%=dff05name%>">
           <input class=inputstyle type="hidden" name=dff05nameto value="<%=dff05nameto%>">
         </wea:item>
         <%}if((nff01use.equals("1")) && (mouldid==0|| !(nff01name.equals(""))||!(nff01nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff01name")%></wea:item>
         <wea:item>
         	<INPUT class=inputstyle type="text" name=nff01name size=4  style="width: 165px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff01name")' value="<%=nff01name%>">
             －<INPUT class=inputstyle type="text" name=nff01nameto size=4 style="width: 165px"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff01nameto")' value="<%=nff01nameto%>">
         </wea:item>
         <%}if((nff02use.equals("1")) && (mouldid==0|| !(nff02name.equals(""))||!(nff02nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff02name")%></wea:item>
         <wea:item>
           <INPUT class=inputstyle type="text" name=nff02name size=4  style="width: 165px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff02name")' value="<%=nff02name%>">
           －<INPUT class=inputstyle type="text" name=nff02nameto size=4  style="width: 165px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff02nameto")' value="<%=nff02nameto%>">
         </wea:item>
         <%}if((nff03use.equals("1")) && (mouldid==0|| !(nff03name.equals(""))||!(nff03nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff03name")%></wea:item>
         <wea:item>
           <INPUT class=inputstyle type="text" name=nff03name size=4  style="width: 165px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff03name")' value="<%=nff03name%>">
           	－<INPUT class=inputstyle type="text" name=nff03nameto size=4  style="width: 165px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff03nameto")' value="<%=nff03nameto%>">
         </wea:item>
         <%}if((nff04use.equals("1")) && ( mouldid==0||!(nff04name.equals(""))||!(nff04nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff04name")%></wea:item>
         <wea:item>
           <INPUT class=inputstyle type="text" name=nff04name size=4  style="width: 165px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff04name")' value="<%=nff04name%>">
           	－<INPUT class=inputstyle type="text" name=nff04nameto size=4  style="width: 165px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff04nameto")' value="<%=nff04nameto%>">
         </wea:item>
         <%}if((nff05use.equals("1")) && (mouldid==0|| !(nff05name.equals(""))||!(nff05nameto.equals("")))){%>
         <wea:item><%=rs2.getString("nff05name")%></wea:item>
         <wea:item>
           <INPUT class=inputstyle type="text" name=nff05name size=4  style="width: 165px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff05name")' value="<%=nff05name%>">
           	－<INPUT class=inputstyle type="text" name=nff05nameto size=4 style="width: 165px"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff05nameto")' value="<%=nff05nameto%>">
         </wea:item>
         <%}if(tff01use.equals("1") && (mouldid==0 || !(tff01name.equals("")))){%>
         <wea:item><%=rs2.getString("tff01name")%></wea:item>
         <wea:item><INPUT type="text" class=inputstyle style="width: 165px" name=tff01name value='<%=tff01name%>'></wea:item>
         <%}if(tff02use.equals("1") && (mouldid==0|| !(tff02name.equals("")))){%>
         <wea:item><%=rs2.getString("tff02name")%></wea:item>
				<wea:item><INPUT type="text" class=inputstyle style="width: 165px" name=tff02name value='<%=tff02name%>'></wea:item>
         <%}if(tff03use.equals("1") && (mouldid==0|| !(tff03name.equals("")))){%>
         <wea:item><%=rs2.getString("tff03name")%></wea:item>
         <wea:item><INPUT type="text" class=inputstyle style="width: 165px" name=tff03name value='<%=tff03name%>'></wea:item>
         <%}if(tff04use.equals("1") && (mouldid==0|| !(tff04name.equals("")))){%>
         <wea:item><%=rs2.getString("tff04name")%></wea:item>
         <wea:item><INPUT type="text" class=inputstyle style="width: 165px" name=tff04name value='<%=tff04name%>'></wea:item>
         <%}if(tff05use.equals("1") && ( mouldid==0||!(tff05name.equals("")))){%>
         <wea:item><%=rs2.getString("tff05name")%></wea:item>
				<wea:item><INPUT type="text" class=inputstyle style="width: 165px" name=tff05name value='<%=tff05name%>'></wea:item>
         <%}if((bff01use.equals("1")) && (mouldid==0||!(bff01name.equals("0")))){%>
         <wea:item><%=rs2.getString("bff01name")%></wea:item>
         <wea:item><INPUT class=inputstyle type=checkbox name=bff01name value="1" <%if(bff01name.equals("1")){%> checked <%}%> ></wea:item>
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
         <%}
          scopeId =-1;
         	CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
	    		cfm.getCustomFields();
	    		scopeId =0;
	    		while(cfm.next()){
	        	String fieldvalue = Util.null2String((String)customFieldMapBase.get("column_"+scopeId+"_"+cfm.getId()));
	        	if(cfm.getHtmlType().equals("6")||!cfm.isUse())continue;
	        	if(mouldid==0||!("").equals(fieldvalue)){
				 %>
	      <wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(cfm.getLable()),user.getLanguage())%></wea:item>
	      <wea:item>
	      <%
	        if(cfm.getHtmlType().equals("1")){
	            if(cfm.getType()==1){
	      %>
        <input datatype="text" style="width: 165px" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=scopeId %>_<%=cfm.getId()%>" value="" size=20>
      <%
            }else if(cfm.getType()==2){
      %>
      <input  datatype="int" style="width: 165px" type=text  value="<%=fieldvalue%>" class=Inputstyle name="column_<%=scopeId %>_<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
      <%
            }else if(cfm.getType()==3){
      %>
        <input datatype="float" style="width: 165px" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=scopeId %>_<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
      <%
            }
        }else if(cfm.getHtmlType().equals("2")){
      %>
      	<input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=scopeId %>_<%=cfm.getId()%>" value="" size=20>
      <%
        }else if(cfm.getHtmlType().equals("3")){
        String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值
		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
		    	url = url + "?type=" + cfm.getDmrUrl();
		    	if(!"".equals(fieldvalue)) {
			    	Browser browser=(Browser) StaticObj.getServiceByFullname(cfm.getDmrUrl(), Browser.class);
					try{
						String[] fieldvalues = fieldvalue.split(",");
						for(int i = 0;i < fieldvalues.length;i++) {
	                        BrowserBean bb=browser.searchById(fieldvalues[i]);
	                        String desc=Util.null2String(bb.getDescription());
	                        String name=Util.null2String(bb.getName());
	                        if(!"".equals(showname)) {
		                        showname += ",";
	                        }
	                        showname += name;
						}
					}catch (Exception e){}
		    	}
		    }
            String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
            String newdocid = Util.null2String(request.getParameter("docid"));

            if( fieldtype.equals("37") && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                fieldvalue += newdocid ;
            }

            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")&& !("161".equals(fieldtype) || "162".equals(fieldtype))) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();
                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }
                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals("")&&false)
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();

                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                    	if(showname.length()>0)showname += ",";
                        showname += temRes.get(temstkvalue);
                    }
                }
            }
       if(fieldtype.equals("2") ||fieldtype.equals("19")){
			String classname="Calendar";
			if(fieldtype.equals("19")) classname="Clock";
	   %>
        <button type="button" class=<%=classname%> 
		<%if(fieldtype.equals("2")){%>
		  onclick="onRpDateShow(column_<%=scopeId %>_<%=cfm.getId()%>startspan,column_<%=scopeId %>_<%=cfm.getId()%>start,'0')" 
		<%}else{%>
		  onclick="onWorkFlowShowTime(column_<%=scopeId %>_<%=cfm.getId()%>startspan,column_<%=scopeId %>_<%=cfm.getId()%>start,'0')" 
		<%}%>
		title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="column_<%=scopeId %>_<%=cfm.getId()%>start" value="<%=fieldvalue%>">
        <span id="column_<%=scopeId %>_<%=cfm.getId()%>startspan"><%=Util.toScreen(showname,user.getLanguage())%>
        </span> －
		<button type="button" class=<%=classname%> 
		<%if(fieldtype.equals("2")){%>
		  onclick="onRpDateShow(column_<%=scopeId %>_<%=cfm.getId()%>endspan,column_<%=scopeId %>_<%=cfm.getId()%>end,'0')" 
		<%}else{%>
		  onclick="onWorkFlowShowTime(column_<%=scopeId %>_<%=cfm.getId()%>endspan,column_<%=scopeId %>_<%=cfm.getId()%>end,'0')" 
		<%}%>
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="column_<%=scopeId %>_<%=cfm.getId()%>end" value="<%=fieldvalue%>">
        <span id="column_<%=scopeId %>_<%=cfm.getId()%>endspan"><%=Util.toScreen(showname,user.getLanguage())%>
        </span>
      <%}else{%>
         <%
      	int id=cfm.getId();
        String fieldname="column_"+scopeId+"_"+cfm.getId();
        String type=fieldtype;
      	String eleclazzname=HtmlUtil.getHtmlClassName("3");
      	
        JSONObject hrmFieldConf=new JSONObject();
        hrmFieldConf.put("id", id);
        hrmFieldConf.put("fieldname", fieldname);
        hrmFieldConf.put("fielddbtype", "");
        hrmFieldConf.put("fieldhtmltype", 3);
        hrmFieldConf.put("type", type);
        hrmFieldConf.put("issystem", 1);
        hrmFieldConf.put("fieldkind", "hrmresourcesearch");
        hrmFieldConf.put("ismand", 0);
        hrmFieldConf.put("isused", 1);
        hrmFieldConf.put("dmlurl", cfm.getDmrUrl());
        hrmFieldConf.put("fieldlabel", "");
        hrmFieldConf.put("dsporder", "");
        %>
      	<%=((HtmlElement)Class.forName(eleclazzname).newInstance()).getHtmlElementString(fieldvalue, hrmFieldConf, user) %>
       <%}
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="column_<%=scopeId %>_<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <select class=InputStyle name="column_<%=scopeId %>_<%=cfm.getId()%>" class=InputStyle style="width: 135px">
       <option></option>    
       <%
            while(cfm.nextSelect()){
       %>
            <option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%>
       <%
            }
       %>
       </select>
       <%
        }
       %>
       </wea:item>
       
       <%
	    }
		    }%>
         <%}%>
         </wea:group>
</wea:layout>
<jsp:include page="HrmResourceSearch_inner.jsp"></jsp:include>
</div>
<input class=inputstyle type="hidden" name="opera">
<input class=inputstyle type="hidden" name="mouldid" value="<%=mouldid%>">
<input class=inputstyle type="hidden" name="mouldname" value="">
</FORM>
<jsp:include page="HrmResourceSearch_foot.jsp"></jsp:include>
