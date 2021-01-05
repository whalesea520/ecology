<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    if(!HrmUserVarify.checkUserRight("MonthFeeEMS:Input", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(15472,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15464,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2191,user.getLanguage())+",javascript:doChange(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name=frmmain method=post action="MonthFeeOperation.jsp">
<input type=hidden name=src value="ems">
<input type=hidden name=operate>
<%
String emstype=Util.fromScreen(request.getParameter("emstype"),user.getLanguage());
String serialnum=Util.fromScreen(request.getParameter("serialnum"),user.getLanguage());
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
%>
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

<table class="viewform">
  <colgroup>
  <col width="15%">
  <col width="35%">
  <col width="15%">
  <col width="35%">
  <TR class="Title"><th colspan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th></TR>
  <TR class="Spacing"><TD colspan=4 class=line1></TD></TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(15460,user.getLanguage())%></td>
  <td class=field><input type=text class="InputStyle" name=serialnum value="<%=serialnum%>"></td>
  <td><%=SystemEnv.getHtmlLabelName(15461,user.getLanguage())%></td>
  <td class=field>
    <select class=inputstyle  size=1 name=emstype>
        <option value="" <%if(emstype.equals("")){%> selected <%}%>>  </option>
        <option value="0" <%if(emstype.equals("0")){%> selected <%}%>>EMS</option>
        <option value="1" <%if(emstype.equals("1")){%> selected <%}%>>DHL</option>
        <option value="2" <%if(emstype.equals("2")){%> selected <%}%>>UPS</option>
        <option value="3" <%if(emstype.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%></option>
    </select>
  </td>
  </tr> <TR class="Spacing"><TD colspan=4 class=line></TD></TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(2034,user.getLanguage())%></td>
  <td class=field>
  <button type='button' class=browser onclick="onShowResource()"></button>
  <span id=resourcespan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span>
  <input type=hidden name="resourceid" value="<%=resourceid%>"></td>
  <td><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></td>
  <td class=field><button type='button' class=browser onclick="onShowDepartment()"></button>
  <span id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span>
  <input type=hidden name="departmentid" value="<%=departmentid%>"></td>
  </tr> <TR class="Spacing"><TD colspan=4 class=line1></TD></TR> 
   <TR class="Title"><th colspan=4 ><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></th></TR> 
</table>
<table class=liststyle cellspacing=1  >
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="20%">
  <col width="20%">
  <col width="15%">
  <col width="15%">
  <tbody>

  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15460,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15461,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(2047,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15462,user.getLanguage())%></td></tr>
	<TR class=Line><TD colspan="6" ></TD></TR> 
<%

boolean islight=true;
String sql="select t1.* from workflow_form t1,workflow_requestbase t2 where t1.requestid = t2.requestid "+
            " and t2.workflowid=119 and t2.currentnodetype='3'";
if(serialnum.equals("")&&emstype.equals("")&&resourceid.equals("")&&departmentid.equals("")){
    sql+=" and amount=0";
}
else{
    if(!serialnum.equals("")){
        sql+=" and desc4 like '%"+serialnum+"%'"; 
    }
    if(!emstype.equals("")){
        sql+=" and EMStype = '"+emstype+"'";
    }
    if(!resourceid.equals("")){
        sql+=" and resource_n = '"+resourceid+"'";
    }
    if(!departmentid.equals("")){
        sql+=" and department = '"+departmentid+"'";
    }
}
sql+=" order by date1 ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmprequestname=RecordSet.getString("requestname");
    String tmprequestid=RecordSet.getString("requestid");
    String tmpserialnum=RecordSet.getString("desc4");
    String tmpemstype=RecordSet.getString("EMStype");
    String amountpercase=RecordSet.getString("amount");
    String getdate=RecordSet.getString("date1");
%>
<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
    <td><input type=checkbox name="select_request" value=<%=tmprequestid%>></td>
    <td><%=tmpserialnum%></td>
    <td><%if(tmpemstype.equals("0")){%>EMS<%}%>
    <%if(tmpemstype.equals("1")){%>DHL<%}%>
    <%if(tmpemstype.equals("2")){%>UPS<%}%>
    <%if(tmpemstype.equals("3")){%><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%><%}%>
    </td>
    <td><%=getdate%></td>
    <td>
    <%if(!amountpercase.equals("0.000")){%>
    <%=amountpercase%>
    <%} else { %>
    <input type=text class="InputStyle" name="feeamount_<%=tmprequestid%>" size=10 onKeyPress='ItemNum_KeyPress()' 
    onBlur='checknumber1(this);checkinput1(feeamount_<%=tmprequestid%>,feeamountspan_<%=tmprequestid%>)'>
    <span id="feeamountspan_<%=tmprequestid%>"><img src='/images/BacoError_wev8.gif' align=absmiddle></span>
    <% } %>
    </td>
    <td><input type=text  class="InputStyle" name="changeamount_<%=tmprequestid%>" size=10 onKeyPress='ItemNum_KeyPress()' 
    onBlur='checknumber1(this);checkinput1(changeamount_<%=tmprequestid%>,changeamountspan_<%=tmprequestid%>)'>
    <span id="changeamountspan_<%=tmprequestid%>"><img src='/images/BacoError_wev8.gif' align=absmiddle></span></td>
</tr>
<%}%>
</table>
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

</form>
<script>
function doRefresh(){
    frmmain.action="MonthFeeEMS.jsp";
    frmmain.submit();
}
function doSave(){
    len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	var ischeck = false;
	var parastr="";
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='select_request')
			if(document.forms[0].elements[i].checked){
			    ischeck=true;
			}
	}
	
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='select_request')
			if(document.forms[0].elements[i].checked)
			    parastr+=",feeamount_"+document.forms[0].elements[i].value;
	}
	if(!ischeck){
	    alert("<%=SystemEnv.getHtmlLabelName(15463,user.getLanguage())%>");
	    return;
	}
	parastr=parastr.substring(1);
	if(check_form(document.frmmain,parastr)){
    	document.frmmain.operate.value="save";
        document.frmmain.submit();
    }
}
function doChange(){
    len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	var ischeck = false;
	var parastr="";
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='select_request')
			if(document.forms[0].elements[i].checked){
			    ischeck=true;
			    break;
			}
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='select_request')
		    if(document.forms[0].elements[i].checked)
			    parastr+=",changeamount_"+document.forms[0].elements[i].value;
	}
	if(!ischeck){
	    alert("<%=SystemEnv.getHtmlLabelName(15463,user.getLanguage())%>");
	    return;
	}
	parastr=parastr.substring(1);
	if(check_form(document.frmmain,parastr)){
    	document.frmmain.operate.value="change";
        document.frmmain.submit();
    }
}
</script>
<script language=vbs>
sub onShowCrm()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?type=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	crmspan.innerHtml = id(1)
	frmmain.crmid.value=id(0)
	else
	crmspan.innerHtml = ""
	frmmain.crmid.value=""
	end if
	end if
end sub
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourcespan.innerHtml = id(1)
	frmmain.resourceid.value=id(0)
	else
	resourcespan.innerHtml = ""
	frmmain.resourceid.value=""
	end if
	end if
end sub
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	departmentspan.innerHtml = id(1)
	frmmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmmain.departmentid.value=""
	end if
	end if
end sub
</script>
</body>
</html>