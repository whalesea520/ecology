<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*,weaver.monitor.*,weaver.monitor.monitor.*,weaver.monitor.beans.*" %>
<%@page import="weaver.monitor.logs.MonitorLogMan"%>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	</head>
	<%
		User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  return ;
		if (user.getUID()!=1)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		String operatetype = Util.null2String(request.getParameter("operatetype"));
		MonitorLogMan MonitorLogMan = new MonitorLogMan();
		String filename = "";
		if("delete".equals(operatetype))
		{
			filename = Util.null2String(request.getParameter("filename"));
			MonitorLogMan.setFilename(filename);
			MonitorLogMan.deletePackLogFiles("warning");
		}
		MonitorLogMan.getLogs("warning");
		Map fileMap = MonitorLogMan.getFileMap();
	%>
	<BODY>
	<form id="frmRemain" name="frmRemain" method=post action="/system/systemmonitor/system/MonitorWarning.jsp" >
			<input name="operatetype" type="hidden" value="">
			<input name="filename" type="hidden" value="">
			<table class=ViewForm width="60%" style="width:60%;">
				<colgroup>
						<col width="20%">
						<col width="30%">
						<col width="20%">
						<col width="30%">
				<tbody>
					<%
					Set filenames = fileMap.keySet();
					for(Iterator i = filenames.iterator();i.hasNext();)
					{
						filename = (String)i.next();
					%>
					<tr>
						<td>
							<%=filename %>
						</td>
						<td class="field">
							<%=fileMap.get(filename) %>K
						</td>
						<td>
							<a href="/log/warning/<%=filename %>" target="_blank">下载</a>
						</td>
						<td class="field">
							<input type="button" class="submit" name="delete" value="删除" onclick="deletefile(this,'<%=filename %>');">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
					<TR>
						<TD class=Line colSpan=4></TD>
					</TR>
					<%
					}
					if(null==fileMap||fileMap.size()==0)
					{
					%>
					<tr>
						<td colSpan=4>
							今天未出现预警日志,具体请查看/log/warning目录...
						</td>
					</tr>
					<TR>
						<TD class=Line colSpan=4></TD>
					</TR>
					<%} %>
				</tbody>
			</table>
		</form>
	</BODY>
	<script language="javascript">
	function deletefile(obj,filename)
	{
		obj.disabled = false;
		frmRemain.operatetype.value="delete";
		frmRemain.filename.value=filename;
		frmRemain.submit();
	}
	</script>
</HTML>