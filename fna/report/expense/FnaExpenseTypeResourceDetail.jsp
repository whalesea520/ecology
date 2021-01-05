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
String feetypeid = Util.null2String(request.getParameter("feetypeid")) ;
String fnayear = Util.null2String(request.getParameter("fnayear")) ;
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String resourceidrq = Util.null2String(request.getParameter("resourceid"));


String imagefilename = "/images/hdFIN_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(428,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<form id=frmMain name=frmMain method=post action=FnaExpenseTypeResourceDetail.jsp>
  <input class=inputstyle type=hidden name="feetypeid" value="<%=feetypeid%>">
  <input class=inputstyle type=hidden name="resourceid" value="<%=resourceidrq%>">
  <input class=inputstyle type=hidden name="fnayear" value="<%=fnayear%>">
  

<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'><!-- 查询条件 -->
		<wea:item attributes="{\"isTableList\":\"true\"}">
  <table Class="ListStyle" id="oTable">
    <COLGROUP> <COL width="10%"><COL width="90%">
    <tr> 
      <TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
      <td width=35% class=field>
    	<span class="wuiDateSpan" selectId="selectDate_sel" selectValue="">
		    <input class=wuiDateSel type="hidden" name="startdate" value="<%=startdate%>">
		    <input class=wuiDateSel  type="hidden" name="enddate" value="<%=enddate%>">
		</span>
	  </td>
    </tr>
  </table>
		</wea:item>
	</wea:group>
</wea:layout>

  <br>
<%
String _contextStr = Util.toScreen(ResourceComInfo.getResourcename(resourceidrq),user.getLanguage())+" - "+
	Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(feetypeid),user.getLanguage())+" "+
	SystemEnv.getHtmlLabelName(15426,user.getLanguage())+":"+fnayear;
%>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=_contextStr%>'>
		<wea:item attributes="{\"isTableList\":\"true\"}">
  <table Class="ListStyle" id="oTable">
    <COLGROUP>
    <COL width="15%">
	<COL width="15%"> 
	<COL width="15%"> 
	<COL width="15%"> 
	<COL width="10%"> 
	<COL width="30%"> 
    <TR class=Header>
      <TD><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(15397,user.getLanguage())%></TD>
      <TD>CRM</TD>
      <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></TD>
    </TR>
<%
    String sql = " select * from FnaAccountLog where resourceid = " + resourceidrq ;
    if(!feetypeid.equals("") && !"undefined".equals(feetypeid))  sql += " and feetypeid = " + feetypeid ;
    if(!startdate.equals(""))  sql += " and occurdate >= '" + startdate + "' " ;
    if(!enddate.equals(""))  sql += " and occurdate <= '" + enddate + "' " ;
    sql += " order by occurdate desc " ;
    
    RecordSet.executeSql(sql);

    boolean isLight = false;
    while(RecordSet.next()) {
        String feetypeidrs = Util.null2String(RecordSet.getString("feetypeid"));
        String occurdate = Util.null2String(RecordSet.getString("occurdate"));
        String crmid = Util.null2String(RecordSet.getString("crmid"));
        String projectid = Util.null2String(RecordSet.getString("projectid"));
        String amount = Util.null2String(RecordSet.getString("amount"));
        String releatedid = Util.null2String(RecordSet.getString("releatedid"));
        String releatedname = Util.toScreen(RecordSet.getString("releatedname"),user.getLanguage()) ;
        String iscontractid = Util.null2String(RecordSet.getString("iscontractid")) ;
        isLight = !isLight ;
%>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'> 
      <td><nobr><%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(feetypeidrs),user.getLanguage())%></td>
      <td><nobr><%=occurdate%></td>
      <td><nobr><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%>
      </td>
      <td><nobr>
	  <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%>
      </td>
	  <td style="TEXT-ALIGN: right"><nobr><%=amount%></td>
	  <td><nobr>
          <% if( iscontractid.equals("1") ) { %>
          <a href='/CRM/data/ContractView.jsp?customerid=<%=crmid%>&id=<%=releatedid%>'><%=releatedname%></a>
          <% } else { %>
          <a href='/workflow/request/ViewRequest.jsp?requestid=<%=releatedid%>'><%=releatedname%></a>
          <% } %>
      </td>
    </tr>
<%  } %>
  </table>
		</wea:item>
	</wea:group>
</wea:layout>

</form>

<form id=frmMainReturn name=frmMainReturn method=post action=FnaExpenseResourceDetailInner.jsp>
  <input type=hidden name="resourceid" value="<%=resourceidrq%>">
  <input type=hidden name="fnayear" value="<%=fnayear%>">
</form>

<script language=javascript>
function onReturn() {
    document.frmMainReturn.submit();
}
function submitData() {
 frmMain.submit();
}
</script>

</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
