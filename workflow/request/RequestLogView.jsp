
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String requestid = Util.null2String(request.getParameter("requestid"));
String requestname="";
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
RecordSet.next();
requestname=RecordSet.getString("requestname");

RecordSet.executeProc("workflow_RequestLog_SNSave",requestid);
if(RecordSet.getCounts()<=0){
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage())+" - "
	+SystemEnv.getHtmlLabelName(648,user.getLanguage())+":<a href=ViewRequest.jsp?requestid="+requestid+">"
	+Util.toScreen(requestname,user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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



<table class="viewform">
  <colgroup> <col width="100%"> 
  <tr class="Title"> 
    <th><%=SystemEnv.getHtmlLabelName(1380,user.getLanguage())%></th>
  </tr>
  <tr class="Spacing"> 
    <td class="Line1"></td>
  </tr>
  <tr> 
    <td valign=top> 
      <table class=liststyle cellspacing=1  >
        <colgroup> <col width="35%"> <col width="20%"> <col width="20%"> <col width="20%"> 
        <tbody> 
        <tr class=Header> 
          <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
          <th><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></th>
          <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
          <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
        </tr>
		<TR class=Line><Th colspan="4" ></Th></TR> 
        <%
boolean isLight = false;
while(RecordSet.next())
{
%>
        <tr <%if(isLight){%> class=datalight <%} else {%>  class=datadark  <%}%>> 
          <td><%=Util.toScreen(RecordSet.getString("operatedate"),user.getLanguage())%> 
            &nbsp<%=Util.toScreen(RecordSet.getString("operatetime"),user.getLanguage())%></td>
          <td><a href="javaScript:openhrm(<%=RecordSet.getString("operator")%>);" onclick='pointerXY(event);'> 
            <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("operator")),user.getLanguage())%></a></td>
          <td><%=Util.toScreen(RecordSet.getString("nodename"),user.getLanguage())%> 
          </td>
          <td> 
            <%
	String logtype = RecordSet.getString("logtype");
	if(logtype.equals("9"))
	{
		%>
            <%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%> 
            <%
	}
	else if(logtype.equals("2"))
	{
		%>
            <%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%> 
            <%
	}
	else if(logtype.equals("3"))
	{
		%>
            <%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%> 
            <%
	}
	else if(logtype.equals("4"))
	{
		%>
            <%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%> 
            <%
	}
	else if(logtype.equals("5"))
	{
		%>
            <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%> 
            <%
	}
	else if(logtype.equals("6"))
	{
		%>
            <%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%> 
            <%
	}
	else if(logtype.equals("7"))
	{
		%>
            <%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%> 
            <%
	}
%>
          </td>
        </tr>
        <tr <%if(isLight){%> class=datalight <%} else {%>  class=datadark  <%}%>> 
          <td colspan="4"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="15%"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(1007,user.getLanguage())%></font></td>
                <td width="85%"> 
                  <%if(RecordSet.getString("remark").equals("")){%>
                  &nbsp 
                  <%}%>
                  <%=Util.toScreen(RecordSet.getString("remark"),user.getLanguage())%></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td colspan="4" height=8></td>
        </tr>
        <%
	isLight = !isLight;
}
%>
        </tbody> 
      </table>
    </td>
  </tr>
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

</BODY>
</HTML>
