
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page" />
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%!
//2004-6-16 Edit by Evan:得到user的级别，总部的user可以看到所有部门，分部和部门级的user只能看到所属的部门
    private String getDepartmentSql(User user){
        String sql ="";
       
        String rightLevel = HrmUserVarify.getRightLevel("HrmResourceEdit:Edit",user);
        int departmentID = user.getUserDepartment();
        int subcompanyID = user.getUserSubCompany1();
        if(rightLevel.equals("2") ){
          //总部级别的，什么也不返回
        }else if (rightLevel.equals("1")){ //分部级别的
          sql = " WHERE subcompanyid1="+subcompanyID ;
        }else if (rightLevel.equals("0")){ //部门级别
          sql = " WHERE id="+departmentID ;
        }
       // System.out.println("sql = "+sql);
       // System.out.println("rightlevel = "+rightLevel);
       
        return sql;
    }
//End Edit
%>
<%
//xiaofeng
String rightLevel = HrmUserVarify.getRightLevel("HrmResourceEdit:Edit",user);
int departmentID = user.getUserDepartment();
int subcompanyID = user.getUserSubCompany1();
int userid =user.getUID();
/*权限判断,人力资源管理员以及其所有上级*/

boolean canView = false;
ArrayList allCanView = new ArrayList();
//String tempsql = "select resourceid from HrmRoleMembers where roleid = 4 ";
String tempsql ="select resourceid from HrmRoleMembers where resourceid>1 and roleid in (select roleid from SystemRightRoles where rightid=22)";
RecordSet.executeSql(tempsql);
while(RecordSet.next()){
	String tempid = RecordSet.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while

for (int i=0;i<allCanView.size();i++){
	if(String.valueOf(userid).equals(allCanView.get(i))){
		canView = true&&HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user);
	}
}
 if(!canView) {
 		response.sendRedirect("/notice/noright.jsp") ;
		return ;
 }

/*权限判断结束*/

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage());
String needfav ="1";
String needhelp ="";

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


String hasresourceid="1";
String hasresourcename="1";
String hasjobtitle    ="1";
String hasactivitydesc="1";
String hasjobgroup    ="1";
String hasjobactivity ="1";
String hascostcenter  ="1";
String hascompetency  ="1";
String hasresourcetype="1";
String hasstatus      ="1";
String hassubcompany  ="1";
String hasdepartment  ="1";
String haslocation    ="1";
String hasmanager     ="1";
String hasassistant   ="1";
String hasroles       ="1";
String hasseclevel    ="1";
String hasjoblevel    ="1";
String hasworkroom    ="1";
String hastelephone   ="1";
String hasstartdate   ="1";
String hasenddate     ="1";
String hascontractdate="1";
String hasbirthday    ="1";
String hassex         ="1";
String hasage         ="1";
String projectable    ="1";
String crmable        ="1";
String itemable       ="1";
String docable        ="1";
String workflowable   ="1";
String subordinateable="1";
String trainable      ="1";
String budgetable     ="1";
String fnatranable    ="1";
String dspperpage     ="1";

String hasworkcode = "1";
String hasjobcall = "1";
String hasmobile = "1";
String hasmobilecall = "1";
String hasfax = "1";
String hasemail = "1";
String hasfolk = "1";
String hasnativeplace = "1";
String hasregresidentplace = "1";
String hasmaritalstatus = "1";
String hascertificatenum = "1";
String hastempresidentnumber = "1";
String hasresidentplace = "1";
String hashomeaddress = "1";
String hashealthinfo = "1";
String hasheight = "1";
String hasweight = "1";
String haseducationlevel = "1";
String hasdegree = "1";
String hasusekind = "1";
String haspolicy = "1";
String hasbememberdate = "1";
String hasbepartydate = "1";
String hasislabouunion = "1";
String hasbankid1 = "1";
String hasaccountid1 = "1";
String hasaccumfundaccount = "1";
String hasloginid = "1";
String hassystemlanguage = "1";


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
	String subcompany1 ="";
	String subcompany2 ="";
	String subcompany3 ="";
	String subcompany4 ="";
	String department ="";
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
	String birthday   ="";
	String birthdayTo   ="";
	String birthdayYear   ="";
	String birthdayMonth   ="";
	String birthdayDay   ="";
        String age        ="";
        String ageTo        ="";
	String sex          ="";

	String resourceidfrom = "";
	String resourceidto = "";
	String workcode = "";
	String jobcall = "";
	String mobile = "";
	String mobilecall = "";
	String fax = "";
	String email = "";
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
	 department   =Util.toScreenToEdit(RecordSet.getString("department"),user.getLanguage());
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
	 birthday       =Util.toScreenToEdit(RecordSet.getString("birthday"),user.getLanguage());
         birthdayTo     =Util.toScreenToEdit(RecordSet.getString("birthdayTo"),user.getLanguage());
         birthdayYear     =Util.toScreenToEdit(RecordSet.getString("birthdayyear"),user.getLanguage());
         birthdayMonth     =Util.toScreenToEdit(RecordSet.getString("birthdaymonth"),user.getLanguage());
         birthdayDay     =Util.toScreenToEdit(RecordSet.getString("birthdayday"),user.getLanguage());
         age            =Util.toScreenToEdit(RecordSet.getString("age"),user.getLanguage());
         ageTo          =Util.toScreenToEdit(RecordSet.getString("ageTo"),user.getLanguage());
	 sex            =Util.toScreenToEdit(RecordSet.getString("sex"),user.getLanguage());

	 resourceidfrom     = Util.toScreenToEdit(RecordSet.getString("resourceidfrom"),user.getLanguage());
	 resourceidto       = Util.toScreenToEdit(RecordSet.getString("resourceidto"),user.getLanguage());
	 workcode           = Util.toScreenToEdit(RecordSet.getString("workcode"),user.getLanguage());
	 jobcall            = Util.toScreenToEdit(RecordSet.getString("jobcall"),user.getLanguage());
	 //mobile             = Util.toScreenToEdit(RecordSet.getString("mobile"),user.getLanguage());
	 mobile = ResourceComInfo.getMobileShow(resourceid, user) ;
	 mobilecall         = Util.toScreenToEdit(RecordSet.getString("mobilecall"),user.getLanguage());
	 fax                = Util.toScreenToEdit(RecordSet.getString("fax"),user.getLanguage());
	 email              = Util.toScreenToEdit(RecordSet.getString("email"),user.getLanguage());
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

}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",/hrm/report/resource/HrmRpResourceDefine.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<form class=ViewForm name="resource" method="post" action="HrmRpResourceSearchTmp.jsp"  onsubmit="return false">
<TABLE cellPadding=0 cellSpacing=0 width="100%" class=ViewForm>
  <TBODY>
  <TR>
    <TD vAlign=top width="84%">
    <TABLE class=ViewForm width="100%">
        <COLGROUP>
        <COL width="49%">
        <COL width=24>
        <COL width="49%">
        <TBODY>
        <TR class=Title>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top>
            <TABLE class=ViewForm>
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>
              <%
              if(hasresourceid.equals("1") && (mouldid==0||!(resourceidfrom.equals("0"))||!(resourceidto.equals("0")))){
              %>
<!--              <TR>
                <TD>标识</TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=resourceidfrom  size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("resourceidfrom")' value="<%=resourceidfrom%>">-
                  <INPUT name=resourceidto  size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("resourceidto")' value="<%=resourceidto%>">
                 </TD>
                </TR>
-->
              <%}%>

              <%
              if(hasworkcode.equals("1") &&(mouldid==0||!(workcode.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=workcode  value="<%=workcode%>"></TD></TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasresourcename.equals("1") && (mouldid==0||!(resourcename.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=resourcename size=20 value="<%=resourcename%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hassex.equals("1") && (mouldid==0||!(sex.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
                <TD class=Field>
                  <select class=inputstyle id=sex name=sex>
                 	<option value="" <% if(sex.equals("")) {%>selected<%}%>></option>
                        <option value=0 <% if(sex.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
                        <option value=1 <% if(sex.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
                        <option value=2 <% if(sex.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%></option>
                  </select>
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
              <%
              if(hasstatus.equals("1") && (mouldid==0||!(status.equals("")))){
              %>
              <TR>
                 <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
                 <TD class=Field>
                  <SELECT class=inputstyle id=status name=status value="<%=status%>">
<%
  //if(ishr){
    if(status.equals("")){
      status = "8";
    }
  //}
%>
                   <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
                   <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
                   <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
                   <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
                   <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
                   <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
                   <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
                   <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
                   <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
                   <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
                 </SELECT>
                 </TD>
                </TR>
                     <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
               <%}%>
              <%
              if(hasdepartment.equals("1") && (mouldid==0||!(department.equals("0")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
               <TD class=Field>
               <input class=wuiBrowser id=department type=hidden name=department value="<%=department%>" 
	             _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	             displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
	           >
               </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hassubcompany.equals("1") && (mouldid==0||!(subcompany1.equals("0")))){
              %>
              <tr>
                <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
                <td class=FIELD>
                  
                  
                <%    if(rightLevel.equals("2") ){//总部级别%>
          
          <select class=inputstyle name="subcompany1" >
                   <option value="0"> </option>
          <%
          while(SubCompanyComInfo.next()){   
        %> 
        <option value="<%=SubCompanyComInfo.getSubCompanyid()%>" ><%=SubCompanyComInfo.getSubCompanyname()%></option>
             <%} 
        }else { //分部或部门级别%>
        <input class=inputstyle type=hidden name=subcompany1 value="<%=subcompanyID%>">
        <select class=inputstyle name="subcompany_1" disabled=true>
                   <option value="0"> </option>
                   <option value="<%=subcompanyID%>" selected><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyID))%></option>
        <%}%>
                  </select>
                </td>
               </tr>
              <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
               <%}%>
<%if(software.equals("ALL") || software.equals("HRM")){%>
              <%
              if(hascostcenter.equals("1") && (mouldid==0||!(costcenter.equals("0")))){
              %>
              <!--<TR>
                 <TD>成本中心 </TD>
                 <TD class=Field>
                  <button class=Browser onClick="onShowCostCenter()"></button>
                  <span class=inputstyle id=costcenterspan><%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenter),user.getLanguage())%></span>
                  <input id=costcenter type=hidden name=costcenter value="<%=costcenter%>">
                </TD>
              </TR>-->
              <%}%>
<%}%>
              <%
              if(hasresourcetype.equals("1") && (mouldid==0||!(resourcetype.equals("")))){
              %>
<!--              <TR>
                 <TD>类型</TD>
                 <TD class=Field>
                   <SELECT class=inputstyle id=resourcetype name=resourcetype>
              	     <OPTION value="" <% if(resourcetype.equals("")) {%>selected<%}%>></OPTION>
                     <OPTION value=F <% if(resourcetype.equals("F")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></OPTION>
                     <OPTION value=H <% if(resourcetype.equals("H")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></OPTION>
                     <OPTION value=D <% if(resourcetype.equals("D")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></OPTION>
                     <OPTION value=T <% if(resourcetype.equals("T")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
                  </SELECT>
                </TD>
              </TR>
-->
              <%}%>

               <%
              if(hasjobtitle.equals("1") && (mouldid==0||!(jobtitle.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
                <TD class=Field>
                 <INPUT class="wuiBrowser" class=inputstyle id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
                 _displayText="<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>"
                 >
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasactivitydesc.equals("1") && (mouldid==0||!(activitydesc.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></TD>
                <TD class=field><INPUT class=inputstyle name=activitydesc size=20 value="<%=activitydesc%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasjobgroup.equals("1") && (mouldid==0||!(jobgroup.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15854,user.getLanguage())%></TD>
                <TD class=Field>
                 <INPUT class=wuiBrowser id=jobgroup type=hidden name=jobgroup value="<%=jobgroup%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp"
                 _displayText="<%=JobGroupsComInfo.getJobGroupsname(jobgroup)%>"
                 >
               </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              <%
              if(hasjobactivity.equals("1") && (mouldid==0||!(jobactivity.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>
                <TD class=Field>
                 <INPUT class=wuiBrowser id=jobactivity type=hidden name=jobactivity value="<%=jobactivity%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp"
                 _display=" <%=JobActivitiesComInfo.getJobActivitiesname(jobactivity)%>"
                 >
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
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

            	  %>
            	  	<%
            	                if((dff01use.equals("1")) && (mouldid==0|| !(dff01name.equals("")) || !(dff01nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("dff01name")%></td>
            	                  <TD class=Field>
            	                    <BUTTON class=Calendar type="button" id=selectdff01name onclick="getDate(dff01namespan,dff01name)"></BUTTON>
            	                    <SPAN id=dff01namespan ><%=dff01name%></SPAN> －
            	                    <BUTTON class=Calendar type="button" id=selectdff01nameto onclick="getDate(dff01nametospan,dff01nameto)"></BUTTON>
            	                    <SPAN id=dff01nametospan ><%=dff01nameto%></SPAN>
            	                    <input class=inputstyle type="hidden" name=dff01name value="<%=dff01name%>">
            	                    <input class=inputstyle type="hidden" name=dff01nameto value="<%=dff01nameto%>">
            	                  </TD>
            	               </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               if((dff02use.equals("1")) && (mouldid==0|| !(dff02name.equals(""))||!(dff02nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("dff02name")%></td>
            	                  <TD class=Field>
            	                    <BUTTON class=Calendar type="button" id=selectdff02name onclick="getDate(dff02namespan,dff02name)"></BUTTON>
            	                    <SPAN id=dff02namespan ><%=dff02name%></SPAN> －
            	                    <BUTTON class=Calendar type="button" id=selectdff02nameto onclick="getDate(dff02nametospan,dff02nameto)"></BUTTON>
            	                    <SPAN id=dff02nametospan ><%=dff02nameto%></SPAN>
            	                    <input class=inputstyle type="hidden" name=dff02name value="<%=dff02name%>">
            	                    <input class=inputstyle type="hidden" name=dff02nameto value="<%=dff02nameto%>">
            	                  </TD>
            	               </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               if((dff03use.equals("1")) && (mouldid==0|| !(dff03name.equals(""))||!(dff03nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("dff03name")%></td>
            	                  <TD class=Field>
            	                    <BUTTON class=Calendar type="button" id=selectdff03name onclick="getDate(dff03namespan,dff03name)"></BUTTON>
            	                    <SPAN id=dff03namespan ><%=dff03name%></SPAN> －
            	                    <BUTTON class=Calendar type="button" id=selectdff03nameto onclick="getDate(dff03nametospan,dff03nameto)"></BUTTON>
            	                    <SPAN id=dff03nametospan ><%=dff03nameto%></SPAN>
            	                    <input class=inputstyle type="hidden" name=dff03name value="<%=dff03name%>">
            	                    <input class=inputstyle type="hidden" name=dff03nameto value="<%=dff03nameto%>">
            	                  </TD>
            	               </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               if((dff04use.equals("1")) && (mouldid==0|| !(dff04name.equals(""))||!(dff04nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("dff04name")%></td>
            	                  <TD class=Field>
            	                    <BUTTON class=Calendar type="button" id=selectdff04name onclick="getDate(dff04namespan,dff04name)"></BUTTON>
            	                    <SPAN id=dff04namespan ><%=dff04name%></SPAN> －
            	                    <BUTTON class=Calendar type="button" id=selectdff04nameto onclick="getDate(dff04nametospan,dff04nameto)"></BUTTON>
            	                    <SPAN id=dff04nametospan ><%=dff04nameto%></SPAN>
            	                    <input class=inputstyle type="hidden" name=dff04name value="<%=dff04name%>">
            	                    <input class=inputstyle type="hidden" name=dff04nameto value="<%=dff04nameto%>">
            	                  </TD>
            	               </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               if((dff05use.equals("1")) && (mouldid==0|| !(dff05name.equals(""))||!(dff05nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("dff05name")%></td>
            	                  <TD class=Field>
            	                    <BUTTON class=Calendar type="button" id=selectdff05name onclick="getDate(dff05namespan,dff05name)"></BUTTON>
            	                    <SPAN id=dff05namespan ><%=dff05name%></SPAN> －
            	                    <BUTTON class=Calendar type="button" id=selectdff05nameto onclick="getDate(dff05nametospan,dff05nameto)"></BUTTON>
            	                    <SPAN id=dff05nametospan ><%=dff05nameto%></SPAN>
            	                    <input class=inputstyle type="hidden" name=dff05name value="<%=dff05name%>">
            	                    <input class=inputstyle type="hidden" name=dff05nameto value="<%=dff05nameto%>">
            	                  </TD>
            	               </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	  	//数字范围搜索
            	                if((nff01use.equals("1")) && (mouldid==0|| !(nff01name.equals(""))||!(nff01nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("nff01name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle name=nff01name size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff01name")' value="<%=nff01name%>">
            	                    －<INPUT class=inputstyle name=nff01nameto size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff01nameto")' value="<%=nff01nameto%>">
            	                  </TD>
            	                </TR>
            	                        <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               if((nff02use.equals("1")) && (mouldid==0|| !(nff02name.equals(""))||!(nff02nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("nff02name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle name=nff02name size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff02name")' value="<%=nff02name%>">
            	                    －<INPUT class=inputstyle name=nff02nameto size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff02nameto")' value="<%=nff02nameto%>">
            	                  </TD>
            	                </TR>
            	                        <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               if((nff03use.equals("1")) && (mouldid==0|| !(nff03name.equals(""))||!(nff03nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("nff03name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle name=nff03name size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff03name")' value="<%=nff03name%>">
            	                    －<INPUT class=inputstyle name=nff03nameto size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff03nameto")' value="<%=nff03nameto%>">
            	                  </TD>
            	                </TR>
            	                        <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               if((nff04use.equals("1")) && ( mouldid==0||!(nff04name.equals(""))||!(nff04nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("nff04name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle name=nff04name size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff04name")' value="<%=nff04name%>">
            	                    －<INPUT class=inputstyle name=nff04nameto size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff04nameto")' value="<%=nff04nameto%>">
            	                  </TD>
            	                </TR>
            	                        <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               if((nff05use.equals("1")) && (mouldid==0|| !(nff05name.equals(""))||!(nff05nameto.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("nff05name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle name=nff05name size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff05name")' value="<%=nff05name%>">
            	                    －<INPUT class=inputstyle name=nff05nameto size=4   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff05nameto")' value="<%=nff05nameto%>">
            	                  </TD>
            	                </TR>
            	                        <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	               <%}
            	               //自定义文本框
            	                if(tff01use.equals("1") && (mouldid==0 || !(tff01name.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("tff01name")%></td>
            	                  <TD class=Field><INPUT class=inputstyle name=tff01name value="<%=tff01name%>">
            	                  </TD>
            	                </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	               if(tff02use.equals("1") && (mouldid==0|| !(tff02name.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("tff02name")%></td>
            	                  <TD class=Field><INPUT class=inputstyle name=tff02name value="<%=tff02name%>">
            	                  </TD>
            	                </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	                if(tff03use.equals("1") && (mouldid==0|| !(tff03name.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("tff03name")%></td>
            	                  <TD class=Field><INPUT class=inputstyle name=tff03name value="<%=tff03name%>">
            	                  </TD>
            	                </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	                if(tff04use.equals("1") && (mouldid==0|| !(tff04name.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("tff04name")%></td>
            	                  <TD class=Field><INPUT class=inputstyle name=tff04name value="<%=tff04name%>">
            	                  </TD>
            	                </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	                if(tff05use.equals("1") && ( mouldid==0||!(tff05name.equals("")))){
            	                %>
            	                <TR>
            	                  <TD><%=rs2.getString("tff05name")%></td>
            	                  <TD class=Field><INPUT class=inputstyle name=tff05name value="<%=tff05name%>">
            	                  </TD>
            	                </TR>
            	                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	                    //自定义boolean
            	  		if((bff01use.equals("1")) && (mouldid==0||!(bff01name.equals("0"))))
            	  		{
            	  			%>
            	                <TR>
            	                  <TD><%=rs2.getString("bff01name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle type=checkbox  name=bff01name value="1" <%if(bff01name.equals("1")){%> checked <%}%> >
            	                  </TD>
            	                </TR>
            	         <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	                if((bff02use.equals("1")) && (mouldid==0||!(bff02name.equals("0"))))
            	  		{
            	  			%>
            	                <TR>
            	                  <TD><%=rs2.getString("bff02name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle type=checkbox  name=bff02name value="1" <%if(bff02name.equals("1")){%> checked <%}%> >
            	                  </TD>
            	                </TR>
            	         <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	                if((bff03use.equals("1")) && (mouldid==0||!(bff03name.equals("0"))))
            	  		{
            	  			%>
            	                <TR>
            	                  <TD><%=rs2.getString("bff03name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle type=checkbox  name=bff03name value="1" <%if(bff03name.equals("1")){%> checked <%}%> >
            	                  </TD>
            	                </TR>
            	         <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	                if((bff04use.equals("1")) && (mouldid==0||!(bff04name.equals("0"))))
            	  		{
            	  			%>
            	                <TR>
            	                  <TD><%=rs2.getString("bff04name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle type=checkbox  name=bff04name value="1" <%if(bff04name.equals("1")){%> checked <%}%> >
            	                  </TD>
            	                </TR>
            	         <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	                if((bff05use.equals("1")) && (mouldid==0||!(bff05name.equals("0"))))
            	  		{
            	  			%>
            	                <TR>
            	                  <TD><%=rs2.getString("bff05name")%></TD>
            	                  <TD class=Field>
            	                    <INPUT class=inputstyle type=checkbox  name=bff05name value="1" <%if(bff05name.equals("1")){%> checked <%}%> >
            	                  </TD>
            	                </TR>
            	         <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
            	                <%}
            	  	
            	  }

            	  %>
            	  
         </TBODY>
        </TABLE>
       </TD>
       <TD>
       </TD>
       <TD align=left vAlign=top>
          <TABLE class=ViewForm>
            <COLGROUP>
            <COL width="30%">
            <COL width="70%">
            <TBODY>
              <%
              if(hasjobcall.equals("1") && (mouldid==0||!(jobcall.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></TD>
                <TD class=Field>
                <INPUT class=wuiBrowser id=jobcall type=hidden name=jobcall value="<%=jobcall%>"
                _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp"
                _displayText="<%=JobCallComInfo.getJobCallname(jobcall)%>"
                >
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasjoblevel.equals("1") && (mouldid==0||!(joblevel.equals("0"))||!(joblevelTo.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=joblevel size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")' value="<%=joblevel%>">
                  -<INPUT class=inputstyle name=joblevelTo size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelTo")' value="<%=joblevelTo%>">
                </TD>
              </TR>
                      <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasmanager.equals("1") && (mouldid==0||!(manager.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></TD>
                <TD class=Field>
                 <input class=wuiBrowser id=manager type=hidden name=manager value="<%=manager%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                 displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>"
                 >
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

                             <%
              if(hasassistant.equals("1") && (mouldid==0||!(assistant.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></TD>
                <TD class=Field id=txtAss>
                <INPUT class=wuiBrowser id=assistantid type=hidden name=assistant value="<%=assistant%>"
                _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(assistant),user.getLanguage())%>"
                >
                </TD>
               </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
               <%}%>

               <%
              if(haslocation.equals("1") && (mouldid==0||!(location.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TD>
                <TD class=Field>
              <input class=wuiBrowser id=location type=hidden name=location value="<%=location%>"
				    _url="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp"
				    _displayText="<%=Util.toScreen(LocationComInfo.getLocationname(location),user.getLanguage())%>"
				    >
               </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasworkroom.equals("1") && (mouldid==0||!(workroom.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=workroom  value="<%=workroom%>"></TD>
                  </TR>
                   <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
               <%}%>

              <%
              if(hastelephone.equals("1") && (mouldid==0||!(telephone.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=telephone   value="<%=telephone%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasmobile.equals("1") && (mouldid==0||!(mobile.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=mobile   value="<%=mobile%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasmobilecall.equals("1") && (mouldid==0||!(mobilecall.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=mobilecall   value="<%=mobilecall%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasfax.equals("1") && (mouldid==0||!(fax.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=fax  value="<%=fax%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasemail.equals("1") && (mouldid==0||!(email.equals("")))){
              %>
              <TR>
                <TD>E-mail</td>
                <TD class=Field><INPUT class=inputstyle name=email   value="<%=email%>"></TD></TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
               <%}%>

              </TBODY>
            </TABLE>
          </TD>
        </TR>
<%if(software.equals("ALL") || software.equals("HRM")){%>
<%
  if(ishr){
%>
	<TR class=Title>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></TH></TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top>
            <TABLE class=ViewForm>
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>
              <%
      //System.out.println("birthdayYear = " + birthdayYear);
      //System.out.println("birthdayMonth = " + birthdayMonth);
      //System.out.println("birthdayDay = " + birthdayDay);
              if(hasbirthday.equals("1") && (mouldid==0||!(birthdayYear.equals("0"))||!(birthdayMonth.equals("0"))||!(birthdayDay.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></td>
                <TD class=Field>
                <%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
                  <select class=inputstyle name="birthdayyear" id="birthdayyear" onchange="changeDay()">
                  <option value="">
<%
                  for(int i=1900; i<2050; i++){
%>
                    <option value="<%=i%>" <%=(""+i).equals(birthdayYear)?"selected":""%>><%=i%>
<%
                  }
%>
                  </select>
                  <%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
                  <select class=inputstyle name="birthdaymonth" id="birthdaymonth" onchange="changeDay()">
                  <option value="">
<%
                  for(int i=1; i<13; i++){
%>
                    <option value="<%=("0"+i).substring(("0"+i).length()-2)%>" <%=(""+i).equals(birthdayMonth)?"selected":""%>><%=i%>
<%
                  }
%>
                  </select>
                  <%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
                  <select class=inputstyle name="birthdayday" id="birthdayday">
                  <option value="">
<%
                  for(int i=1; i<32; i++){
%>
                    <option value="<%=("0"+i).substring(("0"+i).length()-2)%>" <%=(""+i).equals(birthdayDay)?"selected":""%>><%=i%>
<%
                  }
%>
                  </select>
                </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              <%
              if(hasage.equals("1") && (mouldid==0||!(age.equals("0"))||!(ageTo.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=age size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")' value="<%=age%>"><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>－
                <INPUT class=inputstyle name=ageTo size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("ageTo")' value="<%=ageTo%>"><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>
                </TD>
              </TR>
                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasfolk.equals("1") && (mouldid==0||!(folk.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=folk value="<%=folk%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasnativeplace.equals("1") && (mouldid==0||!(nativeplace.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=nativeplace value="<%=nativeplace%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasregresidentplace.equals("1") && (mouldid==0||!(regresidentplace.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></td>
                <TD class=Field>
                <INPUT class=inputstyle type=text name=regresidentplace value="<%=regresidentplace%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasmaritalstatus.equals("1") &&(mouldid==0||!(maritalstatus.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></td>
                <TD class=Field>
                <select class=inputstyle id=maritalstatus name=maritalstatus>
              	  <option value="" <% if(maritalstatus.equals("")) {%>selected<%}%>></option>
                  <option value=0 <% if(maritalstatus.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></option>
                  <option value=1 <% if(maritalstatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></option>
                  <option value=2 <% if(maritalstatus.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%></option> </select>
               </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hascertificatenum.equals("1") && (mouldid==0||!(certificatenum.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=certificatenum value="<%=certificatenum%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hastempresidentnumber.equals("1") && (mouldid==0||!(tempresidentnumber.equals("")))){
              %>
              <TR>

                <TD><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=tempresidentnumber value="<%=tempresidentnumber%>">
                </TD>
              </TR>
                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasresidentplace.equals("1") && (mouldid==0||!(residentplace.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=residentplace size=20 value="<%=residentplace%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hashomeaddress.equals("1") && (mouldid==0||!(homeaddress.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(16018,user.getLanguage())%></TD>
                <TD class=field><INPUT class=inputstyle name=homeaddress size=20 value="<%=homeaddress%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hashealthinfo.equals("1") && (mouldid==0||!(healthinfo.equals("")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></TD>
               <TD class=Field>
               <select class=inputstyle id=healthinfo name=healthinfo value="<%=healthinfo%>">
                 <option value="" <%if(healthinfo.equals("")){%> selected <%}%>></option>
                 <option value=0 <%if(healthinfo.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
                 <option value=1 <%if(healthinfo.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
                 <option value=2 <%if(healthinfo.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
                 <option value=3 <%if(healthinfo.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%></option>
               </select>
               </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>
             <%
    int scopeId = 1;
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue("0",0));
    while(cfm.next()){
        String fieldvalue = cfm.getData("field"+cfm.getId());
%>
    <tr>
      <td <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
      <td class=field >
      <%
        if(cfm.getHtmlType().equals("1")){
            if(cfm.getType()==1){
      %>
        <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" value="" size=50>
      <%
            }else if(cfm.getType()==2){
      %>
      <input  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
      <%
            }else if(cfm.getType()==3){
      %>
        <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
      <%
            }
        }else if(cfm.getHtmlType().equals("2")){
      %>
      	<input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" value="" size=50>
      <%
        }else if(cfm.getHtmlType().equals("3")){

            String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值

            String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
            String newdocid = Util.null2String(request.getParameter("docid"));

            if( fieldtype.equals("37") && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                fieldvalue += newdocid ;
            }

            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")) {
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
                    if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        //showname += tempshowname ;
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();

                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        showname += temRes.get(temstkvalue);
                    }
                }

            }


       if(fieldtype.equals("2") ||fieldtype.equals("19")){
	   %>
        <button class=Calendar type="button"
		<%if(fieldtype.equals("2")){%>
		  onclick="onRpDateShow(customfield<%=cfm.getId()%>startspan,customfield<%=cfm.getId()%>start,'0')" 
		<%}else{%>
		  onclick="onRpTimeShow(customfield<%=cfm.getId()%>startspan,customfield<%=cfm.getId()%>start,'0')" 
		<%}%>
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="customfield<%=cfm.getId()%>start" value="<%=fieldvalue%>">
        <span id="customfield<%=cfm.getId()%>startspan"><%=Util.toScreen(showname,user.getLanguage())%>
        </span> －
		<button class=Calendar type="button" 
		<%if(fieldtype.equals("2")){%>
		  onclick="onRpDateShow(customfield<%=cfm.getId()%>endspan,customfield<%=cfm.getId()%>end,'0')" 
		<%}else{%>
		  onclick="onRpTimeShow(customfield<%=cfm.getId()%>endspan,customfield<%=cfm.getId()%>end,'0')" 
		<%}%>
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="customfield<%=cfm.getId()%>end" value="<%=fieldvalue%>">
        <span id="customfield<%=cfm.getId()%>endspan"><%=Util.toScreen(showname,user.getLanguage())%>
        </span>
      <%}else{%>
        <button class=Browser type="button" onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','0')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="customfield<%=cfm.getId()%>" value="<%=fieldvalue%>">
        <span id="customfield<%=cfm.getId()%>span"><%if(cfm.getId()!=0){%><%=Util.toScreen(showname,user.getLanguage())%><%}%>
        </span>
       <%}
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <select class=InputStyle name="customfield<%=cfm.getId()%>" class=InputStyle>
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
            </td>
        </tr>
          <TR style="height:2px"><TD class=Line colSpan=2></TD>
  </TR>
       <%
    }
       %>
         </TBODY>
       </TABLE>
      </TD>

      <TD></TD>

      <TD align=left vAlign=top>
        <TABLE class=ViewForm>
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
              <%
              if(hasheight.equals("1") && (mouldid==0||!(heightfrom.equals("0"))||!(heightto.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=heightfrom size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("heightfrom")' value="<%=heightfrom%>">cm
                  －<INPUT class=inputstyle name=heightto size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("heightto")' value="<%=heightto%>">cm
                </TD>
              </TR>
                      <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
              <%
              if(hasweight.equals("1") && (mouldid==0||!(weightfrom.equals("0"))||!(weightto.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=weightfrom size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("weightfrom")' value="<%=weightfrom%>">kg
                  －<INPUT class=inputstyle name=weightto size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("weightto")' value="<%=weightto%>">kg
                </TD>
              </TR>
                      <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(haseducationlevel.equals("1") && (mouldid==0||!(educationlevel.equals("0"))||!(educationlevelTo.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </TD>
                <TD class=field>
                <select class=inputstyle id=educationlevel name=educationlevel value="<%=educationlevel%>">
                <option value=""></option>
                <%
                  EducationLevelComInfo.setTofirstRow();
                  while(EducationLevelComInfo.next()){
                %>
                <option value="<%=EducationLevelComInfo.getEducationLevelid()%>" <%if(educationlevel.equals(EducationLevelComInfo.getEducationLevelid())){%> selected <%}%>><%=EducationLevelComInfo.getEducationLevelname()%></option>
                <%
                  }
                %>
              </select>
              --
              <select class=inputstyle id=educationlevelto name=educationlevelto value="<%=educationlevelTo%>">
                <option value=""></option>
                <%
                  EducationLevelComInfo.setTofirstRow();
                  while(EducationLevelComInfo.next()){
                %>
                <option value="<%=EducationLevelComInfo.getEducationLevelid()%>" <%if(educationlevelTo.equals(EducationLevelComInfo.getEducationLevelid())){%> selected <%}%>><%=EducationLevelComInfo.getEducationLevelname()%></option>
                <%
                  }
                %>
              </select>
                </TD>
              </TR>
                    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasdegree.equals("1") && (mouldid==0||!(degree.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></TD>
                <TD class=field><INPUT class=inputstyle name=degree size=20 value="<%=degree%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasusekind.equals("1") && (mouldid==0||!(usekind.equals("")))){
              %>
              <TR>
               <TD ><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></TD>
               <TD class=Field>
                <INPUT class=wuiBrowser type=hidden name=usekind value="<%=usekind%>"
                _url="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp"
                displayText="<%=UseKindComInfo.getUseKindname(usekind)%>"
                >
              </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

             <%
              if(hasroles.equals("1") && (mouldid==0||!(roles.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
               <TD class=Field id=txtAss>
                 <INPUT class=wuiBrowser id=roles type=hidden name=roles value="<%=roles%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
                 displayText="<%=Util.toScreen(RolesComInfo.getRolesname(roles),user.getLanguage())%>"
                 >
               </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

             <%
              if(haspolicy.equals("1") && (mouldid==0||!(policy.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></TD>
                <TD class=field><INPUT class=inputstyle name=policy size=20 value="<%=policy%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasbememberdate.equals("1") && (mouldid==0||!(bememberdatefrom.equals(""))||!(bememberdateto.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></td>
                <TD class=Field>
                  <BUTTON class=Calendar type="button" id=selectbememberdatefrom onclick="getDate(bememberdatefromspan,bememberdatefrom)"></BUTTON>
                  <SPAN id=bememberdatefromspan ><%=bememberdatefrom%></SPAN> －
                  <BUTTON class=Calendar type="button" id=selectbememberdateto onclick="getDate(bememberdatetospan,bememberdateto)"></BUTTON>
                  <SPAN id=bememberdatetospan ><%=bememberdateto%></SPAN>
                  <input class=inputstyle type="hidden" name="bememberdatefrom" value="<%=bememberdatefrom%>">
                  <input class=inputstyle type="hidden" name="bememberdateto" value="<%=bememberdateto%>">
                </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              <%
              if(hasbepartydate.equals("1") && (mouldid==0||!(bepartydatefrom.equals(""))||!(bepartydateto.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></td>
                <TD class=Field>
                  <BUTTON class=Calendar type="button" id=selectbepartydatefrom onclick="getDate(bepartydatefromspan,bepartydatefrom)"></BUTTON>
                  <SPAN id=bepartydatefromspan ><%=bepartydatefrom%></SPAN> －
                  <BUTTON class=Calendar type="button" id=selectbpartydateto onclick="getDate(bepartydatetospan,bepartydateto)"></BUTTON>
                  <SPAN id=bepartydatetospan ><%=bepartydateto%></SPAN>
                  <input class=inputstyle type="hidden" name="bepartydatefrom" value="<%=bepartydatefrom%>">
                  <input class=inputstyle type="hidden" name="bepartydateto" value="<%=bepartydateto%>">
                </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

             <%
              if(hasislabouunion.equals("1") && (mouldid==0||!(islabouunion.equals("")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></TD>
               <TD class=Field>
               <select class=inputstyle id=islabouunion name=islabouunion value="<%=islabouunion%>">
                <option value="" <%if(islabouunion.equals("")){%> selected <%}%>></option>
                <option value=1 <%if(islabouunion.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
                <option value=0 <%if(islabouunion.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
               </select>
              </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

             <%
              if(hasstartdate.equals("1") && (mouldid==0||!(startdate.equals(""))||!(startdateTo.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></td>
                <TD class=Field>
                  <BUTTON class=Calendar type="button" id=selectstartdate onclick="getstartDate()"></BUTTON>
                  <SPAN id=startdatespan ><%=startdate%></SPAN>－
                  <BUTTON class=Calendar type="button" id=selectstartdateTo onclick="getstartDateTo()"></BUTTON>
                  <SPAN id=startdateTospan ><%=startdateTo%></SPAN>
                  <input class=inputstyle type="hidden" name="startdate" value="<%=startdate%>">
                  <input class=inputstyle type="hidden" name="startdateTo" value="<%=startdateTo%>">
                </td>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasenddate.equals("1") && (mouldid==0||!(enddate.equals(""))||!(enddateTo.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></td>
                <TD class=Field>
                 <BUTTON class=Calendar type="button" id=selectenddate onclick="getendDate()"></BUTTON>
                 <SPAN id=enddatespan ><%=enddate%></SPAN>－
                 <BUTTON class=Calendar type="button" id=selectenddateTo onclick="getendDateTo()"></BUTTON>
                 <SPAN id=enddateTospan ><%=enddateTo%></SPAN>
                 <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
                 <input class=inputstyle type="hidden" name="enddateTo" value="<%=enddateTo%>">
               </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              <%
              if(hascontractdate.equals("1") && (mouldid==0||!(contractdate.equals(""))||!(contractdateTo.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></td>
                <TD class=Field>
                 <BUTTON class=Calendar type="button" id=selectcontractdate onclick="getcontractDate()"></BUTTON>
                 <SPAN id=contractdatespan ><%=contractdate%></SPAN>－
                 <BUTTON class=Calendar type="button" id=selectcontractdateTo onclick="getcontractDateTo()"></BUTTON>
                 <SPAN id=contractdateTospan ><%=contractdateTo%></SPAN>
                 <input class=inputstyle type="hidden" name="contractdate" value="<%=contractdate%>">
                 <input class=inputstyle type="hidden" name="contractdateTo" value="<%=contractdateTo%>">
		</TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

            </TBODY>
          </TABLE>
        </TD>
      </TR>
<%
}
%>
<%
  if( ishr || isfin ) {
%>
        <TR class=Title>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH></TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top>
            <TABLE class=ViewForm>
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>
              <%
              if(hasbankid1.equals("1") && (mouldid==0||!(bankid1.equals("")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></TD>
               <TD class=Field>
                 <input class=wuiBrowser id=bankid1 type=hidden name=bankid1 value="<%=bankid1%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/finance/bank/BankBrowser.jsp"
                 _displayText="<%=BankComInfo.getBankname(bankid1)%>"
                 >
               </TD>
             </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>


              <%
              if(hasaccountid1.equals("1") && (mouldid==0||!(accountid1.equals("")))){
              %>
               <TR>
                <TD><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></TD>
                <TD class=Field>
                 <input class=inputstyle type=text name="accountid1" value="<%=accountid1%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
               <%}%>

         </TBODY>
       </TABLE>
      </TD>
      <TD></TD>
      <TD align=left vAlign=top>
        <TABLE class=ViewForm>
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
               <%
              if(hasaccumfundaccount.equals("1") && (mouldid==0||!(accumfundaccount.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1939,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=accumfundaccount size=20  value="<%=accumfundaccount%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              </TBODY>
            </TABLE>
          </TD>
        </TR>
<%
  }
}
%>
<%
  if(ishr || issys){
%>
        <TR class=Title>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%></TH></TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top>
            <TABLE class=ViewForm>
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>

              <%
              if(hasseclevel.equals("1") && (mouldid==0||!(seclevel.equals("0"))||!(seclevelTo.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=seclevel size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel")' value="<%=seclevel%>">-<INPUT class=inputstyle name=seclevelTo size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevelTo")' value="<%=seclevelTo%>">
                </TD>
              </TR>
                      <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasloginid.equals("1") && (mouldid==0||!(loginid.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(16017,user.getLanguage())%></TD>
                <TD class=field>
                  <INPUT class=inputstyle name=loginid size=20 value="<%=loginid%>">
                </TD>
              </TR>
                  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
         </TBODY>
       </TABLE>
     </TD>
     <TD></TD>
     <TD align=left vAlign=top>
       <TABLE class=ViewForm>
         <COLGROUP>
         <COL width="30%">
         <COL width="70%">
         <TBODY>
               <%
              if(hassystemlanguage.equals("1") && (mouldid==0||!(systemlanguage.equals("0")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></TD>
               <TD class=Field>
                 <select class=inputstyle name=systemlanguage value="<%=systemlanguage%>">
                  <option value="" <%if(systemlanguage.equals("")){%>selected<%}%>></option>
                  <option value="7" <%if(systemlanguage.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%></option>
                  <option value="8" <%if(systemlanguage.equals("8")){%>selected<%}%>>English</option>
                 </select>
               </TD>
             </TR>
                      <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              </TBODY>
            </TABLE>
          </TD>
        </TR>
<%
}
%>
      </TBODY>
     </TABLE>
    </TD>
     </TR>
    </TBODY>
   </TABLE>

<input class=inputstyle type="hidden" name="opera">
<input class=inputstyle type="hidden" name="mouldid" value="<%=mouldid%>">
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>

<script language=javascript>
function checkNewmould(){
	if(document.resource.mouldname.value==''){
		oTrname.style.display='';
		return false;
		}
	return true;
}
function onSaveas(){
	if(checkNewmould()){
	document.resource.opera.value="insert";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.submit();
	}
}
function onSave(){
	document.resource.opera.value="update";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.submit();
}
function onDelete(){
	document.resource.opera.value="delete";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.submit();
}
function submitData() {
 resource.submit();
}

function onShowBrowser(id,url,linkurl,type1,ismand){
	if (type1== 2 || type1 == 19){
		id1 = window.showModalDialog(url);
		jQuery("#customfield"+id+"span").html(id1.name);
		jQuery("input[name=customfield"+id+"]").val(id1.id);
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170){
			id1 = window.showModalDialog(url);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else{
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}
		if (id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
						}
					}
					
					jQuery("#customfield"+id+"span").html(sHtml);
					
				}else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
						}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}else{
			   if  (id1.id!="" && id1.id!= "0"){
			        if (linkurl == ""){
						jQuery("#customfield"+id+"span").html(id1.name);
					}else{
						jQuery("#customfield"+id+"span").html("<a href="+linkurl+id1.id+">"+id1.name+"</a>");
					}
					jQuery("input[name=customfield"+id+"]").val(id1.id);
			   }else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}
		}
	}

}

function changeDay(){
   if(jQuery("#birthdayday").length==0||jQuery("#birthdaymonth").length==0)
      return ;
   var month=jQuery("#birthdaymonth").val();
   if(month==1||month==3||month==5||month==7||month==8||month==10||month==12){
      if(jQuery("#birthdayday").find("option[value=29]").length!=1){
         jQuery("#birthdayday").find("option[value=28]").after("<option value='29'>29</option>");
      }
      if(jQuery("#birthdayday").find("option[value=30]").length!=1){
         jQuery("#birthdayday").find("option[value=29]").after("<option value='30'>30</option>");
      }
      if(jQuery("#birthdayday").find("option[value=31]").length!=1){
         jQuery("#birthdayday").find("option[value=30]").after("<option value='31'>31</option>");
      }
      
   }else if(month==4||month==6||month==9||month==11){
      jQuery("#birthdayday").find("option[value=31]").remove();
      if(jQuery("#birthdayday").find("option[value=29]").length!=1){
         jQuery("#birthdayday").find("option[value=28]").after("<option value='29'>29</option>");
      }
      if(jQuery("#birthdayday").find("option[value=30]").length!=1){
         jQuery("#birthdayday").find("option[value=29]").after("<option value='30'>30</option>");
      }
   }else if(month==2){
      jQuery("#birthdayday").find("option[value=31]").remove();
      jQuery("#birthdayday").find("option[value=30]").remove();
      if(jQuery("#birthdayyear").val()!=""&&jQuery("#birthdayyear").val()%4!=0)
         jQuery("#birthdayday").find("option[value=29]").remove();
      else{
         if(jQuery("#birthdayday").find("option[value=29]").length!=1){
         jQuery("#birthdayday").find("option[value=28]").after("<option value='29'>29</option>");
      }
      }   
   }
}

</script>
<!--
<script language=vbs>
sub onShowBrowser(id,url,linkurl,type1,ismand)
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("customfield"+id+"span").innerHtml = id1
		document.all("customfield"+id).value=id1
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("customfield"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.all("customfield"+id+"span").innerHtml = empty
					else
						document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("customfield"+id).value=""
				end if

			else
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						document.all("customfield"+id+"span").innerHtml = id1(1)
					else
						document.all("customfield"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("customfield"+id).value=id1(0)
				else
					if ismand=0 then
						document.all("customfield"+id+"span").innerHtml = empty
					else
						document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("customfield"+id).value=""
				end if
			end if
		end if
	end if

end sub

sub onShowDefaultLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	defaultlanguagespan.innerHtml = id(1)
	resource.defaultlanguage.value=id(0)
end sub

sub onShowSystemLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	systemlanguagespan.innerHtml = id(1)
	resource.systemlanguage.value=id(0)
end sub


sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&resource.department.value)
    if Not isempty(id) then
	if id(0)<> "" then
	departmentspan.innerHtml = Mid(id(1),2)
	resource.department.value=Mid(id(0),2)
	else
	departmentspan.innerHtml = ""
	resource.department.value=""
	end if
	end if
end sub
sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	costcenterspan.innerHtml = id(1)
	resource.costcenter.value=id(0)
	else
	costcenterspan.innerHtml = ""
	resource.costcenter.value=""
	end if
	end if
end sub

sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.manager.value=id(0)
	else
	manageridspan.innerHtml = ""
	resource.manager.value=""
	end if
	end if
end sub

sub onShowAssistantID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> "" then
	assistantidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.assistant.value=id(0)
	else
	assistantidspan.innerHtml = ""
	resource.assistant.value=""
	end if
	end if
end sub

sub onShowRolesID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> "" then
	rolesspan.innerHtml = id(1)
	resource.roles.value=id(0)
	else
	rolesspan.innerHtml = ""
	resource.roles.value=""
	end if
	end if
end sub

sub onShowJobTitles()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	resource.jobtitle.value=id(0)
	else
	jobtitlespan.innerHtml = ""
	resource.jobtitle.value=""
	end if
	end if
end sub

sub onShowJobGroups()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	jobgroupspan.innerHtml = id(1)
	resource.jobgroup.value= id(0)
	else
	jobgroupspan.innerHtml = ""
	resource.jobgroup.value=""
	end if
	end if
end sub

sub onShowJobActivities()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	jobactivityspan.innerHtml = id(1)
	resource.jobactivity.value=id(0)
	else
	jobactivityspan.innerHtml = ""
	resource.jobactivity.value=""
	end if
	end if
end sub

sub onShowJobCall()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	jobcallspan.innerHtml = id(1)
	resource.jobcall.value=id(0)
	else
	jobcallspan.innerHtml = ""
	resource.jobcall.value=""
	end if
	end if
end sub

sub onShowLocation()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	locationspan.innerHtml = id(1)
	resource.location.value=id(0)
	else
	locationspan.innerHtml = ""
	resource.location.value=""
	end if
	end if
end sub

sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	resource.usekind.value=id(0)
	else
	usekindspan.innerHtml = ""
	resource.usekind.value=""
	end if
	end if
end sub

sub onShowBank(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/bank/BankBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</script>
-->
</BODY>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
