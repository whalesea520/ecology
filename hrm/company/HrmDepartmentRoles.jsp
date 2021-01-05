<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function jsSubmit(e,datas, name){
	frmMain.submit();
}
</script>
</head>
<%
String departmentid = Util.null2String(request.getParameter("id"));
String groupby = Util.null2String(request.getParameter("GroupBy"));
if(groupby.equals("")) groupby ="1";

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+" : "+ Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//改搜索为重新设置,xiaofeng
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
/* 去掉新建菜单，td1518,xiaofeng
if(HrmUserVarify.checkUserRight("HrmRoleMembersAdd:Add",user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/roles/HrmRolesMembersAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmMain name=frmMain action=HrmDepartmentRoles.jsp method=post>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
   		<brow:browser viewType="0" name="id" browserValue='<%= departmentid %>' 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
          completeUrl="/data.jsp?type=4" width="165px"
          _callback="jsSubmit"
          browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>'>
  		</brow:browser>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="30%">
  <COL width="10%">
  <COL width="15%">
  <COL width="15%">
  <TBODY>
  <TR class=Header>
    <TH align=left colSpan=5><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TH>
  </TR>
 
  <TR class=header>
    <TH align=left><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TH> 
    <TH align=left><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TH>
    <TH align=left><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
    <TH align=left><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TH>
    <TH align=left><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TH>
  </TR>

<%
String tempresourceid = "-1" ;
boolean writeable = false ;
int i = 0;
if(!"".equals(departmentid)){
RecordSet.executeProc("HrmRoleMembers_SByDepartmentID",departmentid);
while(RecordSet.next()) {
writeable = false ;
String resourceid = RecordSet.getString("resourceid") ;
String roleid = RecordSet.getString("roleid") ;
String rolelevel = RecordSet.getString("rolelevel") ;
String jobtitle = ResourceComInfo.getJobTitle(resourceid);
String resourcetype = ResourceComInfo.getResourcetype(resourceid);
if(i==0){
			i=1;
		%>
		<TR class=DataLight>
		<%
		}else{
			i=0;
		%>
		<TR class=DataDark>
		<%
		}
		%>
    <TD>
	<% if(!resourceid.equals(tempresourceid)) {  tempresourceid = resourceid ; writeable = true ; %>
	<A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A>
	<%}%>
	</TD>
    <TD>
	<% if(writeable) { %>
	<A href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=jobtitle%>"><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></A>
	<%}%>
	</TD>
    <TD>
	<% if(writeable) { if(resourcetype.equalsIgnoreCase("f")) {%>
            <%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%> 
            <%} if(resourcetype.equalsIgnoreCase("h")) {%>
            <%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%> 
            <%} if(resourcetype.equalsIgnoreCase("d")) {%>
            <%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%> 
			<%} if(resourcetype.equalsIgnoreCase("t")) {%>
            <%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%> 
            <%}}%>
	</TD>
    <TD><A href="/hrm/roles/HrmRolesEdit.jsp?id=<%=roleid%>"><%=Util.toScreen(RolesComInfo.getRolesname(roleid),user.getLanguage())%></A></TD>
    <TD>
	<% if(rolelevel.equals("2")) {%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%>
	<% if(rolelevel.equals("1")) {%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%}%>
	<% if(rolelevel.equals("0")) {%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}%>
	</TD></tr>
<% }}%>
 </TBODY></TABLE>

<script language=javascript>
function onShowDepartment(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	if (data!=null){
		if (data.id!="0"){
			if (data.id != jQuery("#departmentid").val()){
				location.href="HrmDepartmentRoles.jsp?id="+data.id;
			}
		}
	}
}

function submitData() {
 frmMain.submit();
}
</script>
 </BODY>
 </HTML>
