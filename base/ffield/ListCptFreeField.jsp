
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(true){
	response.sendRedirect("/cpt/ffield/CptFreefieldTab.jsp");
	return;
}
RecordSet.executeSql("select * from Base_FreeField where tablename = 'cp'");
RecordSet.first();
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17476,user.getLanguage());
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
			  <TR class=Line><TD colspan="3" ></TD></TR> 
			<%
			boolean isLight = false;
			%>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=dff01"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</a></td>
				<td><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(3).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=dff02"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</a></td>
				<td><%=Util.toScreen(RecordSet.getString(4),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(5).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=dff03"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</a></td>
				<td><%=Util.toScreen(RecordSet.getString(6),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(7).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=dff04"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</a></td>
				<td><%=Util.toScreen(RecordSet.getString(8),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(9).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=dff05"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</a></td>
				<td><%=Util.toScreen(RecordSet.getString(10),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(11).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=nff01"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</a></td>
				<td><%=Util.toScreen(RecordSet.getString(12),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(13).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=nff02"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</a></td>
				<td><%=Util.toScreen(RecordSet.getString(14),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(15).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=nff03"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</a></td>
				<td><%=Util.toScreen(RecordSet.getString(16),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(17).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=nff04"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</a></td>
				<td><%=Util.toScreen(RecordSet.getString(18),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(19).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=nff05"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</a></td>
				<td><%=Util.toScreen(RecordSet.getString(20),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(21).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=tff01"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</a></td>
				<td><%=Util.toScreen(RecordSet.getString(22),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(23).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=tff02"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</a></td>
				<td><%=Util.toScreen(RecordSet.getString(24),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(25).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=tff03"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</a></td>
				<td><%=Util.toScreen(RecordSet.getString(26),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(27).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=tff04"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</a></td>
				<td><%=Util.toScreen(RecordSet.getString(28),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(29).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=tff05"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</a></td>
				<td><%=Util.toScreen(RecordSet.getString(30),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(31).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=bff01"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</a></td>
				<td><%=Util.toScreen(RecordSet.getString(32),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(33).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=bff02"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</a></td>
				<td><%=Util.toScreen(RecordSet.getString(34),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(35).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=bff03"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</a></td>
				<td><%=Util.toScreen(RecordSet.getString(36),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(37).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=bff04"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</a></td>
				<td><%=Util.toScreen(RecordSet.getString(38),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(39).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=bff05"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</a></td>
				<td><%=Util.toScreen(RecordSet.getString(40),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(41).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=docff01"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(6163,user.getLanguage())%>1</a></td>
				<td><%=Util.toScreen(RecordSet.getString(42),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(43).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=docff02"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(6163,user.getLanguage())%>2</a></td>
				<td><%=Util.toScreen(RecordSet.getString(44),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(45).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=docff03"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(6163,user.getLanguage())%>3</a></td>
				<td><%=Util.toScreen(RecordSet.getString(46),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(47).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=docff04"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(6163,user.getLanguage())%>4</a></td>
				<td><%=Util.toScreen(RecordSet.getString(48),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(49).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=docff05"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(6163,user.getLanguage())%>5</a></td>
				<td><%=Util.toScreen(RecordSet.getString(50),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(51).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=depff01"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%>1</a></td>
				<td><%=Util.toScreen(RecordSet.getString(52),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(53).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=depff02"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%>2</a></td>
				<td><%=Util.toScreen(RecordSet.getString(54),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(55).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=depff03"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%>3</a></td>
				<td><%=Util.toScreen(RecordSet.getString(56),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(57).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=depff04"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%>4</a></td>
				<td><%=Util.toScreen(RecordSet.getString(58),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(59).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=depff05"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%>5</a></td>
				<td><%=Util.toScreen(RecordSet.getString(60),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(61).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=crmff01"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(840,user.getLanguage())%>1</a></td>
				<td><%=Util.toScreen(RecordSet.getString(62),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(63).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=crmff02"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(840,user.getLanguage())%>2</a></td>
				<td><%=Util.toScreen(RecordSet.getString(64),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(65).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=crmff03"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(840,user.getLanguage())%>3</a></td>
				<td><%=Util.toScreen(RecordSet.getString(66),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(67).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=crmff04"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(840,user.getLanguage())%>4</a></td>
				<td><%=Util.toScreen(RecordSet.getString(68),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(69).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=crmff05"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(840,user.getLanguage())%>5</a></td>
				<td><%=Util.toScreen(RecordSet.getString(70),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(71).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=reqff01"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(20156,user.getLanguage())%>1</a></td>
				<td><%=Util.toScreen(RecordSet.getString(72),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(73).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=reqff02"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(20156,user.getLanguage())%>2</a></td>
				<td><%=Util.toScreen(RecordSet.getString(74),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(75).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=reqff03"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(20156,user.getLanguage())%>3</a></td>
				<td><%=Util.toScreen(RecordSet.getString(76),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(77).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=reqff04"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(20156,user.getLanguage())%>4</a></td>
				<td><%=Util.toScreen(RecordSet.getString(78),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(79).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			<%	if(isLight = !isLight)
				{%>	
			  <tr CLASS=DataDark>
			<%	}else{%>
			  <tr CLASS=DataLight>
			<%	}%>
				<td><a href="/base/ffield/EditFreeField.jsp?tablename=cp&ffname=reqff05"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(20156,user.getLanguage())%>5</a></td>
				<td><%=Util.toScreen(RecordSet.getString(80),user.getLanguage())%></td>
				<td><%if(RecordSet.getString(81).equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
			  </tr>
			 </TABLE>
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
