
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%
		int checkmenu=Util.getIntValue(request.getParameter("checkmenu"), 0);
 %>
<table style="width: 100%">
	<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
</colgroup>
	<tr style="height: 6px">
			<td></td>
			<td></td>
			<td></td>
		</tr>
	<tr>
			<td></td>
			<td>
				<span style='<%if(checkmenu==0){out.println("background-color:#cfe5c3;");}%>cursor: pointer;'   onclick="window.location.href='/integration/sapLog/logMainDetail.jsp?checkmenu=0'"><a>&nbsp;<%=SystemEnv.getHtmlLabelName(31695,user.getLanguage()) %>&nbsp;</a></span>&nbsp;
				<span style='<%if(checkmenu==1){out.println("background-color:#cfe5c3;");}%>cursor: pointer;'   onclick="window.location.href='/integration/Monitoring/FunSystem.jsp?checkmenu=1'"><a>&nbsp;<%=SystemEnv.getHtmlLabelName(31696,user.getLanguage()) %>&nbsp;</a></span>&nbsp;
				<span style='<%if(checkmenu==2){out.println("background-color:#cfe5c3;");}%>cursor: pointer;'   onclick="window.location.href='/integration/Monitoring/FieldSystem.jsp?checkmenu=2'"><a>&nbsp;<%=SystemEnv.getHtmlLabelName(31922,user.getLanguage()) %>&nbsp;</a></span>&nbsp;
				<span style='<%if(checkmenu==3){out.println("background-color:#cfe5c3;");}%>cursor: pointer;'   onclick="window.location.href='/integration/Monitoring/JarSystem.jsp?checkmenu=3'"><a>&nbsp;<%=SystemEnv.getHtmlLabelName(31697,user.getLanguage()) %>&nbsp;</a></span>&nbsp;
				<span style='<%if(checkmenu==4){out.println("background-color:#cfe5c3;");}%>cursor: pointer;'   onclick="window.location.href='/integration/Monitoring/WfSystem.jsp?checkmenu=4'"><a>&nbsp;SAP<%=SystemEnv.getHtmlLabelName(23113,user.getLanguage()) %>&nbsp;</a></span>&nbsp;	
			</td>	
			<td></td>
		</tr>
</table>
<div style="padding-left: 10px;padding-right: 10px;height: 2px;overflow: hidden;">
	<div style='height: 2px;background-color:rgb(245, 250, 250) ;overflow: hidden;'>&nbsp;</div>
</div>
