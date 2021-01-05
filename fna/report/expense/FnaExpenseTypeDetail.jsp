<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

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
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<form id=frmMain name=frmMain method=post action=FnaExpenseTypeDetail.jsp>
  <input class=inputstyle type=hidden name="feetypeid" value="<%=feetypeid%>">
  <input class=inputstyle type=hidden name="departmentid" value="<%=departmentid%>">
  <input class=inputstyle type=hidden name="fnayear" value="<%=fnayear%>">

  <TABLE class=viewForm>
    <COLGROUP> <COL width="15%"><COL width="35%"><COL width="15%"><COL width="35%"> <THEAD> 
    <TR class=Title> 
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH>
    </TR>
    </THEAD> <TBODY> 
    
    <tr> 
      <TD width=15%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
      <TD class=Field> 
      <BUTTON class=Browser onclick="onShowResourceID(resourceidspan,resourceid)"></BUTTON> 
      <INPUT class=inputstyle type=hidden name=resourceid id=resourceid value="<%=resourceidrq%>">
      <span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceidrq),user.getLanguage())%></span>
      </TD>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
      <TD width=35% class=field>
      <button class=Calendar id=selectbememberdate onClick="getDate(startdatespan, startdate)"></button>
      <span id=startdatespan><%=startdate%></span>--&nbsp;<button class=Calendar id=selectbememberdate onClick="getDate(enddatespan, enddate)"></button>
      <span id=enddatespan><%=enddate%></span>
      <input class=inputstyle type="hidden" name="enddate" id="enddate" value="<%=enddate%>">
      <input class=inputstyle type="hidden" name="startdate" id="startdate" value="<%=startdate%>">
        </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    </TBODY> 
  </TABLE>
  <br>
  <TABLE class=ListStyle cellspacing=1  >
    <COLGROUP> 
	<COL width="10%"> 
	<COL width="10%">
    <COL width="12%"> 
	<COL width="15%"> 
	<COL width="15%"> 
	<COL width="10%"> 
	<COL width="28%"> 
    <THEAD> 
    <TR class=Header> 
    <TH colspan="3"> 
    <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%> - <%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(feetypeid),user.getLanguage())%>
    </TH>
    <TH colSpan=4 style="TEXT-ALIGN: right">
    <%=SystemEnv.getHtmlLabelName(15426,user.getLanguage())%>:<%=fnayear%>
    </TH>
  </TR>
  </THEAD> <TBODY> 
    
    <TR class=Header> 
      <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(15397,user.getLanguage())%></TD>
      <TD>CRM</TD>
      <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></TD>
    </TR>
    <TR class=Line><TD colspan="7" ></TD></TR> 
<%
    String sql = " select * from FnaAccountLog where departmentid = " + departmentid ;
    if(!feetypeid.equals(""))  sql += " and feetypeid = " + feetypeid ;
    if(!startdate.equals(""))  sql += " and occurdate >= '" + startdate + "' " ;
    if(!enddate.equals(""))  sql += " and occurdate <= '" + enddate + "' " ;
    if(!resourceidrq.equals(""))  sql += " and resourceid = " + resourceidrq ;
    sql += " order by occurdate desc " ;
    
    RecordSet.executeSql(sql);

    boolean isLight = false;
    while(RecordSet.next()) {
        String feetypeidrs = Util.null2String(RecordSet.getString("feetypeid"));
        String occurdate = Util.null2String(RecordSet.getString("occurdate"));
        String crmid = Util.null2String(RecordSet.getString("crmid"));
        String resourceid = Util.null2String(RecordSet.getString("resourceid"));
        String projectid = Util.null2String(RecordSet.getString("projectid"));
        String amount = Util.null2String(RecordSet.getString("amount"));
        String releatedid = Util.null2String(RecordSet.getString("releatedid"));
        String releatedname = Util.toScreen(RecordSet.getString("releatedname"),user.getLanguage()) ;
        String iscontractid = Util.null2String(RecordSet.getString("iscontractid")) ;
        isLight = !isLight ;
%>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'> 
      <td><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></td>
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
    </tbody> 
  </table>
</form>

<form id=frmMainReturn name=frmMainReturn method=post action=FnaExpenseDetail.jsp>
  <input type=hidden name="departmentid" value="<%=departmentid%>">
  <input type=hidden name="fnayear" value="<%=fnayear%>">
</form>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script language=javascript>
function onReturn() {
    document.frmMainReturn.submit();
}
function submitData() {
 frmMain.submit();
}
</script>
<SCRIPT LANGUAGE=VBS>
  sub onShowResourceID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</SCRIPT>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>