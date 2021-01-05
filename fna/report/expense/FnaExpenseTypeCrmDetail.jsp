<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>


<%
char separator = Util.getSeparator() ;
String feetypeid = Util.null2String(request.getParameter("feetypeid")) ;
String fnayear = Util.null2String(request.getParameter("fnayear")) ;
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String crmidrq = Util.null2String(request.getParameter("crmid"));
int custoridss = Util.getIntValue(request.getParameter("custoridss"));

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

<form id=frmMain name=frmMain method=post action=FnaExpenseTypeCrmDetail.jsp>
  <input class=inputstyle type=hidden name="feetypeid" value="<%=feetypeid%>">
  <input class=inputstyle type=hidden name="crmid" value="<%=crmidrq%>">
  <input class=inputstyle type=hidden name="fnayear" value="<%=fnayear%>">

  <TABLE class=ViewForm>
    <COLGROUP> <COL width="10%"><COL width="90%"> <THEAD> 
    <TR class=Title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH>
    </TR>
    </THEAD> <TBODY> 
    <TR class=Spacing> 
      <TD class=Sep1 colSpan=2></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
      <TD width=35% class=field>
      <button class=Calendar id=selectbememberdate onClick="getDate(startdatespan, startdate)"></button>
      <span id=startdatespan><%=startdate%></span>--&nbsp;<button class=Calendar id=selectbememberdate onClick="getDate(enddatespan, enddate)"></button>
      <span id=enddatespan><%=enddate%></span>
      <input class=inputstyle type="hidden" name="enddate" id="enddate" value="<%=enddate%>">
      <input class=inputstyle type="hidden" name="startdate" id="startdate" value="<%=startdate%>">
        </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    </TBODY> 
  </TABLE>
  <br>
  <TABLE class=ListStyle cellspacing=1  >
    <COLGROUP>
    <COL width="10%">
	<COL width="15%"> 
	<COL width="10%">
    <COL width="10%">
	<COL width="15%"> 
	<COL width="10%"> 
	<COL width="30%"> 
    <THEAD> 
    <TR class=Header> 
    <TH colspan="3"> 
    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmidrq),user.getLanguage())%> - <%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(feetypeid),user.getLanguage())%>
    </TH>
    <TH colSpan=7 style="TEXT-ALIGN: right">
    <%=SystemEnv.getHtmlLabelName(15426,user.getLanguage())%>:<%=fnayear%>
    </TH>
  </TR>
  </THEAD> <TBODY> 
  
    <TR class=Header>
      <TD><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(15397,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></TD>
    </TR>
    <TR class=Line><TD colspan="7" ></TD></TR> 
<%
    String sql = " select * from FnaAccountLog where iscontractid=1 and  crmid = " + crmidrq ;
    if(!feetypeid.equals(""))  sql += " and feetypeid = " + feetypeid ;
    if(!startdate.equals(""))  sql += " and occurdate >= '" + startdate + "' " ;
    if(!enddate.equals(""))  sql += " and occurdate <= '" + enddate + "' " ;
    sql += " order by occurdate desc " ;
    RecordSet.executeSql(sql);

    boolean isLight = false;
    while(RecordSet.next()) {
        String feetypeidrs = Util.null2String(RecordSet.getString("feetypeid"));
        String occurdate = Util.null2String(RecordSet.getString("occurdate"));
        String departmentid = Util.null2String(RecordSet.getString("departmentid"));
        String resourceid = Util.null2String(RecordSet.getString("resourceid"));
        String projectid = Util.null2String(RecordSet.getString("projectid"));
        String amount = Util.null2String(RecordSet.getString("amount"));
        String releatedid = Util.null2String(RecordSet.getString("releatedid"));
        String releatedname = Util.toScreen(RecordSet.getString("releatedname"),user.getLanguage()) ;
        //String iscontractid = Util.null2String(RecordSet.getString("iscontractid")) ;
        isLight = !isLight ;
%>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'> 
      <td><nobr><%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(feetypeidrs),user.getLanguage())%></td>
      <td><nobr><%=occurdate%></td>
	  <td></td>
      <td><nobr><A href='/hrm/resource/HrmResource.jsp?id=<%=resourceid%>'><%=Util.toScreen(ResourceComInfo.getLastname(resourceid),user.getLanguage())%></A>
      </td>
      <td><nobr>
	  <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%>
      </td>
      <td style="TEXT-ALIGN: right"><nobr><%=amount%></td>
	  <td><nobr>
          <a href='/CRM/data/ContractView.jsp?customerid=<%=crmidrq%>&id=<%=releatedid%>'><%=releatedname%></a>
      </td>
    </tr>
<%  } %>
<%
    sql = " select * from FnaExpenseInfo where relatedcrm = " + crmidrq + " and status=1 ";
    if(!feetypeid.equals(""))  sql += " and subject = " + feetypeid ;
    if(!startdate.equals(""))  sql += " and occurdate >= '" + startdate + "' " ;
    if(!enddate.equals(""))  sql += " and occurdate <= '" + enddate + "' " ;
    sql += " order by occurdate desc " ;
    RecordSet.executeSql(sql);


    while(RecordSet.next()) {
        String feetypeidrs = Util.null2String(RecordSet.getString("subject"));
        String occurdate = Util.null2String(RecordSet.getString("occurdate"));
        String organizationtype = Util.null2String(RecordSet.getString("organizationtype"));
        String organizationid = Util.null2String(RecordSet.getString("organizationid"));
        String projectid = Util.null2String(RecordSet.getString("relatedprj"));
        String amount = Util.null2String(RecordSet.getString("amount"));
        String releatedid = Util.null2String(RecordSet.getString("requestid"));
        String releatedname = Util.null2String(RequestComInfo.getRequestname(releatedid)) ;
        isLight = !isLight ;
        String showname="";
        if(organizationtype.equals("3")){
                        showname="<A href='/hrm/resource/HrmResource.jsp?id="+organizationid+"'>"+Util.toScreen(ResourceComInfo.getLastname(organizationid),user.getLanguage()) +"</A>";
                        }else if(organizationtype.equals("2")){
                        showname=SystemEnv.getHtmlLabelName(124,user.getLanguage())+":"+"<A href='/hrm/company/HrmDepartment.jsp?id="+organizationid+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid),user.getLanguage()) +"</A>";
                        }else if(organizationtype.equals("1")){
                        showname=SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+"<A href='/hrm/company/HrmSubCompany.jsp?id="+organizationid+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid),user.getLanguage())+"</A>";
                        }
%>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
      <td><nobr><%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(feetypeidrs),user.getLanguage())%></td>
      <td><nobr><%=occurdate%></td>
	  <TD></td>
      <td><nobr><%=showname%>
      </td>
      <td><nobr><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%>
      </td>
	  <td style="TEXT-ALIGN: right"><nobr><%=amount%></td>
	  <td><nobr>
          <a href='/workflow/request/ViewRequest.jsp?requestid=<%=releatedid%>'><%=releatedname%></a>
      </td>
    </tr>
<%  } %>
    </tbody> 
  </table>
</form>

<form id=frmMainReturn name=frmMainReturn method=post action=FnaExpenseCrmDetail.jsp>
  <input class=inputstyle type=hidden name="crmid" value="<%=crmidrq%>">
  <input class=inputstyle type=hidden name="fnayear" value="<%=fnayear%>">
 <% if(custoridss==1){%>
  <input class=inputstyle type=hidden name="custoridss" value="<%=custoridss%>">
  <%}%>
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
  sub onShowCrmID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/CrmBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='HrmCrm.jsp?id="&id(0)&"'>"&id(1)&"</A>"
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