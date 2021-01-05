<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*,weaver.monitor.*,weaver.monitor.monitor.*,weaver.monitor.beans.*" %>
<%@page import="weaver.monitor.logs.MonitorLogMan"%>
<jsp:useBean id="list" class="java.util.ArrayList" scope="session" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<style type="text/css">
		td{
			border:'1px solid black';
			text-align:center;
		}
		tr.title td{
			border:'1px solid black';
			text-align:center;
			background-color:#99bbff;
			height:30px;
		}
		</style>
	</head>
	<%
		User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  return ;
		if (user.getUID()!=1)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		java.text.DecimalFormat df=new java.text.DecimalFormat("###.##");
		
		//获取内存信息
		Monitor mm = MonitorFactory.getMonitor(2);
		mm.getMonitorInfo();
		MemBean mb = (MemBean)mm.getMonitorToShow();
		//轮转信息
		if(list.size()==10)
		{
			for(int i = 0;i<list.size();i++)
			{
				if((i+1)<list.size())
				{
					list.set(i,list.get(i+1));
				}
			}
			list.set(9,mb);
		}
		else
		{
			list.add(mb);
		}
	%>
	<BODY>
		<table class=ViewForm width="60%" style="width:80%;border:'1px solid black';" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
			<tbody>
				<tr class="title" height="30px" style="height:30px;">
					<td height="30px" style="height:30px;">
						系统时间
					</td>
					<td>
						S
					</td>
					<td>
						E
					</td>
					<td>
						O
					</td>
					<td>
						P
					</td>
					<td>
						YGC
					</td>
					<td>
						YGCT
					</td>
					<td>
						FGC
					</td>
					<td>
						FGCT
					</td>
					<td>
						GCT
					</td>
				</tr>
				<%
				for(int i = 0;i<list.size();i++)
				{
					MemBean mb1 = (MemBean)list.get(i);
				%>
				<tr>
					<td>
						<%=mb1.getCurrentTime() %>&nbsp;
					</td>
					<td>
						<%=MemMonitor.FormatValueLog(mb1.getSCommitted(),mb1.getSUsed(),df) %>&nbsp;
					</td>
					<td>
						<%=MemMonitor.FormatValueLog(mb1.getECommitted(),mb1.getEUsed(),df) %>&nbsp;
					</td>
					<td>
						<%=MemMonitor.FormatValueLog(mb1.getTCommitted(),mb1.getTUsed(),df) %>&nbsp;
					</td>
					<td>
						<%=MemMonitor.FormatValueLog(mb1.getPCommitted(),mb1.getPUsed(),df) %>&nbsp;
					</td>
					<td>
						<%=mb1.getYGC() %>&nbsp;
					</td>
					<td>
						<%=df.format(mb1.getYGCT()/(1000f)) %>&nbsp;
					</td>
					<td>
						<%=mb1.getFGC() %>&nbsp;
					</td>
					<td>
						<%=df.format(mb1.getFGCT()/(1000f)) %>&nbsp;
					</td>
					<td>
						<%=df.format((mb1.getFGCT()+mb1.getYGCT())/(1000f)) %>&nbsp;
					</td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
	</BODY>
</HTML>