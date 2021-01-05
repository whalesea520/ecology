<%@ page import="weaver.general.Util,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
RecordSet.executeSql("select * from Base_FreeField where tablename = 'hr'");
RecordSet.first();
if(RecordSet.getCounts()<=0) {
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(570,user.getLanguage()) +" : " + SystemEnv.getHtmlLabelName(179,user.getLanguage()) ;
String needfav ="1";
String needhelp ="1";
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
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<TABLE class=ListStyle cellspacing="1">
  <COLGROUP>
  <COL width="40%">
  <COL width="40%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></th>
  </tr>

<%
boolean isLight = false;
%>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=dff01"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(3).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=dff02"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(4),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(5).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=dff03"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(6),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(7).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=dff04"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(8),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(9).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=dff05"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(10),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(11).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=nff01"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(12),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(13).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=nff02"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(14),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(15).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=nff03"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(16),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(17).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=nff04"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(18),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(19).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=nff05"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(20),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(21).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=tff01"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(22),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(23).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=tff02"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(24),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(25).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=tff03"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(26),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(27).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=tff04"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(28),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(29).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=tff05"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(30),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(31).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=bff01"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(32),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(33).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=bff02"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(34),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(35).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=bff03"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(36),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(37).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=bff04"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(38),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(39).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
<%	if(isLight = !isLight)
	{%>	
  <tr CLASS=DataDark>
<%	}else{%>
  <tr CLASS=DataLight>
<%	}%>
    <td><a href="/base/ffield/EditFreeField.jsp?tablename=hr&ffname=bff05"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</a></td>
    <td><xmp><%=Util.toScreen(RecordSet.getString(40),user.getLanguage())%></xmp></td>
    <td><%if(RecordSet.getString(41).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
  </tr>
 </TABLE>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>

</BODY>
</HTML>
