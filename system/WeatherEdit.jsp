<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript>
function doSave(){
	document.frmmain.operation.value="save";
	if(check_form(document.frmmain,'picid,thedate,thedesc'))
	document.frmmain.submit();	
}
function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmmain.operation.value="delete";
		document.frmmain.submit();
	}
}
</script> 
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(5000,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanAll = HrmUserVarify.checkUserRight("WeatherMaintenance:All", user);
String id=Util.null2String(request.getParameter("id"));
RecordSet.executeProc("Weather_SelectByID",id);
RecordSet.next();
String thedate=Util.toScreen(RecordSet.getString("thedate"),user.getLanguage());
String picid=RecordSet.getString("picid");
String thedesc=Util.toScreen(RecordSet.getString("thedesc"),user.getLanguage());
String temperature=Util.toScreen(RecordSet.getString("temperature"),user.getLanguage());

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<br>
<FORM id=weaver name=frmmain method=post action="WeatherOperation.jsp">
<input type="hidden" name="operation">
<input type="hidden" name="id" value="<%=id%>">
<div>
<%
if(CanAll){
%>
<BUTTON class=btnSave accessKey=S onClick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<BUTTON class=btnNew accessKey=N onClick="location='WeatherAdd.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<BUTTON class=btnDelete accessKey=D onClick="doDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
</div>
<table class=form>
  <colgroup>
    <col width="20%">
    <col width="80%">
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class=field>
      <%if(CanAll){ %>
      <BUTTON class=Calendar id=SelectDate onclick="getDate(holidaydatespan,thedate)"></BUTTON><%}%>
      <SPAN id=holidaydatespan ><%if(!thedate.equals("")){%><%=thedate%><%}%></SPAN>
      <input type="hidden" name="thedate" value="<%=thedate%>"></td>
    </tr>
	<tr>
	<td><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></td>
	<td>
	<INPUT TYPE="radio" NAME="picid" value="1" <%if(picid.equals("1")){%>checked<%}%>><IMG src="../../images/sun_wev8.gif" align=absMiddle>
	<INPUT TYPE="radio" NAME="picid" value="2" <%if(picid.equals("2")){%>checked<%}%>><IMG src="../../images/yun_wev8.gif" align=absMiddle>
	<INPUT TYPE="radio" NAME="picid" value="3" <%if(picid.equals("3")){%>checked<%}%>><IMG src="../../images/yin_wev8.gif" align=absMiddle>
	<INPUT TYPE="radio" NAME="picid" value="4" <%if(picid.equals("4")){%>checked<%}%>><IMG src="../../images/yu_wev8.gif" align=absMiddle>
	</td>
   </tr>
   <tr>
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
      <td class=field>
      <%if(CanAll) {%>
      <INPUT maxLength=30 onchange="checkinput('thedesc','InvalidFlag_Description')" size=30 
      name="thedesc" value="<%=thedesc%>"><%} else {%><%=thedesc%><%}%>
      <SPAN id=InvalidFlag_Description>
      <%if(thedesc.equals("")){ %><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></td>
   </tr>
   <tr>
      <td><%=SystemEnv.getHtmlLabelName(5001,user.getLanguage())%></td>
      <td class=field><INPUT maxLength=30 size=30 name="temperature" value=<%=temperature%>><SPAN id=InvalidFlag_Description></SPAN></td>
   </tr>
	
</table>
</form>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>