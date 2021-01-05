<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="AppDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function doAddWorkPlanNew(id) {
	setUserId(id);
	doAddWorkPlan();	
}
</script>
</head>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
                     
String projectable = "1" ;
String crmable = "1" ;
String itemable = "1" ;
String docable = "1" ;
String workflowable = "1" ;
String workplanable = "1" ;
String subordinateable = "1" ;
String trainable = "1" ;
String budgetable = "1" ;
String fnatranable = "1" ;
String id = Util.null2String(request.getParameter("id")) ;
String firstname = ResourceComInfo.getFirstname(id);
String lastname = ResourceComInfo.getLastname(id);
String qname = Util.null2String(request.getParameter("flowTitle")) ;

//added by hubo,20060113
if(id.equals("")) id=String.valueOf(user.getUID());
String theid = id ;
String srcid  = Util.null2String(request.getParameter("srcid")) ;
if(srcid.equals("")) RecordSet.executeProc("HrmUserDefine_SelectByID",id);
else RecordSet.executeProc("HrmUserDefine_SelectByID",srcid);
if(RecordSet.next()){ 
	projectable = Util.null2String(RecordSet.getString("projectable")) ;
	crmable = Util.null2String(RecordSet.getString("crmable")) ;
	itemable = Util.null2String(RecordSet.getString("itemable")) ;
	docable = Util.null2String(RecordSet.getString("docable")) ;
	workflowable = Util.null2String(RecordSet.getString("workflowable")) ;
	subordinateable = Util.null2String(RecordSet.getString("subordinateable")) ;
	trainable = Util.null2String(RecordSet.getString("trainable")) ;
	budgetable = Util.null2String(RecordSet.getString("budgetable")) ;
	fnatranable = Util.null2String(RecordSet.getString("fnatranable")) ;
	workplanable = Util.null2String(RecordSet.getString("workplanable")) ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage()) + " : " + firstname + " " + lastname ;
String needfav ="1";
String needhelp ="";
%>
<script type="text/javascript">
function viewHrm(id){
	var url ="/hrm/resource/HrmResource.jsp?id="+id;
	openFullWindowForXtable(url);
}
	
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function docSearch(id){
	openFullWindowForXtable('/docs/search/DocSearchTemp.jsp?docstatus=6&hrmresid='+id);
}

function cptSearch(id){
	openFullWindowForXtable('/cpt/search/SearchOperation.jsp?resourceid='+id+'&isdata=2');
}

function openCRM(id){
	openFullWindowForXtable('/CRM/search/SearchOperation.jsp?destination=myAccount&resourceid='+id);
}

function openHrmResourceView(id){
	<% if(srcid.equals("")) {%>
  	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResourceView&id="+id+"&srcid="+id);
	<%} else {%>
	  openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResourceView&id="+id+"&srcid=<%=srcid%>");
	<% } %>
}
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(531,user.getLanguage())+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",/hrm/userdefine/MySubordinateInfoDefine.jsp?returnurl=my,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(32535,user.getLanguage())+",/hrm/userdefine/HrmUserDefine.jsp?returnurl=my,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchfrm" name="searchfrm" action="HrmResourceView.jsp">
	<input name="id" type="hidden" value="<%=id %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
//编号 		姓名			机构					部门					岗位					电话			电子邮件
String backfields = " * "; 
String fromSql  = " from HrmResource ";
String sqlWhere = " where status in (0,1,2,3) and managerid= "+id;
String orderby = " dsporder " ;
String tableString = "";
if(qname.length()>0){
	sqlWhere += "and lastname like '%"+qname+"%'";
}
if(AppDetachComInfo.isUseAppDetach()){
	String appdetawhere = AppDetachComInfo.getScopeSqlByHrmResourceSearch(user.getUID()+"",true,"");
	String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
	sqlWhere+=tempstr;
}

//操作字符串
//日程安排    待办事宜    文档    项目    客户    资产    下属    预算    收支
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmPopedomSet.getHrmResourceViewOperate\" otherpara=\""+id+"\" otherpara2=\"srcid:"+srcid+"\"></popedom> ";
 	       if(workplanable.equals("1")){
 	       	operateString+="     <operate href=\"javascript:doAddWorkPlanNew();\" linkkey=\"resourceid\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(2192,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"0\"/>";
 	       }
 	       if(workflowable.equals("1")){
 	       	operateString+="     <operate href=\"/workflow/request/RequestView.jsp\" linkkey=\"resourceid\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(1207,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"1\"/>";
 	       }
 	       if(docable.equals("1")){
 	       	operateString+="     <operate href=\"javascript:docSearch();\" text=\""+SystemEnv.getHtmlLabelName(30041,user.getLanguage())+"\" isalwaysshow='true' index=\"3\"/>";
 	       }
 	       if(projectable.equals("1")){
 	       	operateString+="     <operate href=\"/proj/search/SearchOperation.jsp\" linkkey=\"member\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(22245,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"4\"/>";
 	       }
 	       if(crmable.equals("1")){
 	       	operateString+="     <operate href=\"javascript:openCRM();\" text=\""+SystemEnv.getHtmlLabelName(26356,user.getLanguage())+"\" isalwaysshow='true' index=\"5\"/>";
 	       }
 	       if(itemable.equals("1")){
 	       	operateString+="     <operate href=\"javascript:cptSearch();\" text=\""+SystemEnv.getHtmlLabelName(30044,user.getLanguage())+"\" isalwaysshow='true' index=\"6\"/>";
 	       }
 	       if(subordinateable.equals("1")){
 	       	operateString+="     <operate href=\"javascript:openHrmResourceView();\" text=\""+SystemEnv.getHtmlLabelName(442,user.getLanguage())+"\" isalwaysshow='true' index=\"7\"/>";
 	       }
 	       if(budgetable.equals("1")){
 	       	operateString+="     <operate href=\"/fna/report/budget/FnaBudgetResourceDetail.jsp\" linkkey=\"resourceid\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(32563,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"8\"/>";
 	       }
 	       if(fnatranable.equals("1")){
 	       	operateString+="     <operate href=\"/fna/report/expense/FnaExpenseResourceDetail.jsp\" linkkey=\"resourceid\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(428,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"9\"/>";
 	       }
 	       operateString+="</operates>";	
tableString =" <table pageId=\""+PageIdConst.HRM_ResourceView+"\" tabletype=\"none\" pagesize=\""+ PageIdConst.getPageSize(PageIdConst.HRM_ResourceView,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"10%\" labelid=\"547\" text=\""+SystemEnv.getHtmlLabelName(547,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.isOnline\" />"+
    "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"workcode\" orderkey=\"workcode\"/>"+
    "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" target=\"_fullwindow\" />"+
    "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" linkkey=\"subcompanyid\" href=\"/hrm/company/HrmDepartment.jsp\"   target=\"_fullwindow\"/>"+
    "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/company/HrmDepartmentDsp.jsp?hasTree=false\"   linkkey=\"id\" target=\"_fullwindow\"/>"+
    "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" linkkey=\"id\"  transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" href=\"/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesEdit\" target=\"_fullwindow\"/>"+
    "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(421,user.getLanguage())+"\" column=\"telephone\" orderkey=\"telephone\"/>"+
    "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(477,user.getLanguage())+"\" column=\"email\" orderkey=\"email\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceView %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
</BODY>
</HTML>
