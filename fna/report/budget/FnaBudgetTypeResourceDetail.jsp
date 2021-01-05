<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
char separator = Util.getSeparator() ;
String departmentid = Util.null2String(request.getParameter("departmentid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String budgettypeid = Util.null2String(request.getParameter("budgettypeid")) ;
String budgetstatus = Util.null2String(request.getParameter("budgetstatus"));
String fnayear = Util.null2String(request.getParameter("fnayear")) ;
String budgetinfoid = Util.null2String(request.getParameter("budgetinfoid")) ;


String imagefilename = "/images/hdFIN_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386 , user.getLanguage());
String needfav = "1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id=frmMain name=frmMain method=post action=FnaBudgetEdit.jsp>
<%
String _contextStr = Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())+" - "+
		Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(budgettypeid) , user.getLanguage())+" "+
		SystemEnv.getHtmlLabelName(15365,user.getLanguage())+":"+fnayear;
%>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" 
		context="<%=_contextStr %>">
		<wea:item attributes="{\"isTableList\":\"true\"}">
<table Class="ListStyle" id="oTable">
    <COLGROUP> 
	<COL width="30%"> 
	<COL width="10%"> 
	<COL width="10%"> 
	<COL width="10%"> 
	<COL width="10%"> 
	<COL width="30%"> 
	<TBODY> 
     <TR class=header> 
      <TD><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
      <TD>CRM</TD>
      <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
    </TR>
    <TR class=Line><TD colspan="6" ></TD></TR> 
<%
if( !budgetinfoid.equals("") ) {
    RecordSet.executeSql(" select * from FnaBudgetInfoDetail " +
                         " where budgetinfoid = " + budgetinfoid + " and budgettypeid = " +
                         budgettypeid + " and  budgetresourceid =" + resourceid + 
                         " order by budgetperiods ");

    boolean isLight = false;
    boolean budgetperiodsdisplay = false ;
    String tempbudgetperiods = "" ;
    
    while(RecordSet.next()) {
        String budgetperiods = Util.null2String(RecordSet.getString("budgetperiods"));
        String budgetstartdate = Util.null2String(RecordSet.getString("budgetstartdate"));
        String budgetenddate = Util.null2String(RecordSet.getString("budgetenddate"));
        String budgetcrmid = Util.null2String(RecordSet.getString("budgetcrmid"));
        String budgetresourceid = Util.null2String(RecordSet.getString("budgetresourceid"));
        String budgetprojectid = Util.null2String(RecordSet.getString("budgetprojectid"));
        String budgetaccount = Util.null2String(RecordSet.getString("budgetaccount"));
        String budgetremarks = Util.toScreen(RecordSet.getString("budgetremark"),user.getLanguage()) ;
        isLight = !isLight ;
        budgetperiodsdisplay = false ;
        if( ! tempbudgetperiods.equals( budgetperiods ) ) {
            tempbudgetperiods = budgetperiods ;
            budgetperiodsdisplay = true ;
        }
%>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'> 
      <td><nobr><% if(budgetperiodsdisplay) {%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%><%=budgetperiods%>: <%=budgetstartdate%> ~ <%=budgetenddate%><%}%></td>
      <td><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(budgetresourceid),user.getLanguage())%></td>
      <td><nobr><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(budgetcrmid),user.getLanguage())%>
      </td>
      <td><nobr>
	  <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(budgetprojectid),user.getLanguage())%>
      </td>
	  <td style="TEXT-ALIGN: right"><nobr><%=budgetaccount%></td>
	  <td><nobr><%=budgetremarks%></td>
    </tr>
<%  } }%>
</tbody> 
</table>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

<form id=frmMainReturn name=frmMainReturn method=post action=FnaBudgetResourceDetailInner.jsp>
  <input type=hidden name="resourceid" value="<%=resourceid%>">
  <input type=hidden name="fnayear" value="<%=fnayear%>">
</form>
<script language=javascript>
function onReturn() {
    document.frmMainReturn.submit();
}
</script>
</body>
</html>