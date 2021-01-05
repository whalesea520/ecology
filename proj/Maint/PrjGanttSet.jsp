
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
int userid=user.getUID();
if(!HrmUserVarify.checkUserRight("Pm:GanttSetting", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
  String method = Util.null2String(request.getParameter("method"));
  String showplan = "";
  int warning_day = 3;
  if(method.equals("save")){
	  showplan = Util.null2String(request.getParameter("showplan"));
	  warning_day = Util.getIntValue (request.getParameter("warning_day"),3);
	  RecordSet.executeSql("delete pm_ganttset");
		RecordSet.executeSql("insert into pm_ganttset(showplan_,warning_day) values('"+showplan+"',"+warning_day+")"); 	
	  %>
    <script language=javascript>
	  alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
	  window.location = "PrjGanttSet.jsp";
    </script>
  <%}
  RecordSet.executeSql("select * from pm_ganttset ");
	if(RecordSet.next()){
		showplan = Util.null2String(RecordSet.getString("showplan_"));
		warning_day = Util.getIntValue(RecordSet.getString("warning_day"),3);
	}
  %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31958,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<tr>
<td height="10" colspan="2"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=weaver action="PrjGanttSet.jsp" method=post>
<input type=hidden id='method' name='method'>
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
	  <tr>
	  <td>显示计划图例</td>
	    <td class=field>
	    
	    <INPUT class=InputStyle type=checkbox id='showplan' name='showplan' value="1" <%="1".equals(showplan)?"checked":"" %>>
	    </td>
	  </tr>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
	  <tr>
	  <td>预警提前天数</td>
	    <td class=field>
	    
	    <INPUT class=InputStyle type=text id=warning_day name='warning_day' onkeypress='ItemCount_KeyPress()' value="<%=warning_day %>">
	    </td>
	  </tr>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
  </TBODY>
</TABLE>
</FORM>
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
function submitData(){
	document.getElementById("method").value="save";
	weaver.submit();
}
</script>
