<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.system.License"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<HTML>
	<HEAD>
		<style>
		#tabPane tr td {
			padding-top: 2px
		}
		
		#monthHtmlTbl td,#seasonHtmlTbl td {
			cursor: hand;
			text-align: center;
			padding: 0 2px 0 2px;
			color: #333;
			text-decoration: underline
		}
		
		.cycleTD {
			background-image: url(/images/tab2.png);
			cursor: hand;
			text-align: center;
			border-bottom: 1px solid #879293;
		}
		
		.cycleTDCurrent {
			padding-top: 2px;
			background-image: url(/images/tab.active2.png);
			cursor: hand;
			text-align: center;
		}
		
		.seasonTDCurrent,.monthTDCurrent {
			color: black;
			font-weight: bold;
			background-color: #CCC
		}
		
		#subTab {
			border-bottom: 1px solid #879293;
			padding: 0
		}
		</style>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	</head>
	<%
		int isIncludeToptitle = 0;
		User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  return ;
		Log logger= LogFactory.getLog(this.getClass());
		if (user.getUID()!=1)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}

		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = "系统监控";
		String needfav = "1";
		String needhelp = "";

		int id = Util.getIntValue(request.getParameter("id"), 0);
		int messageid = Util.getIntValue(request.getParameter("message"), 0);
		int errorcode = Util.getIntValue(request.getParameter("errorcode"), 0);
		int reftree = Util.getIntValue(request.getParameter("reftree"), 0);
		int tab = Util.getIntValue(request.getParameter("tab"), 0);
		String typeid = Util.null2String(request.getParameter("type"));
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp"%>
		<br>
		<TABLE width=98% height=100% border="0" cellspacing="0" cellpadding="0" id="tabPane" style="margin-left:5px;">
			<input type="hidden" name="id" value="<%=id%>">
			<colgroup>
				<col width="79"></col>
				<col width="79"></col>
				<col width="79"></col>
				<col width="79"></col>
				<col width="79"></col>
				<col width="79"></col>
				<col width="*"></col>
			</colgroup>
			<TBODY>
				<tr>
					<td height="10" colspan="8"></td>
				</tr>
				<tr align=left height="22">
					<td class="cycleTDCurrent" name="oTDtype_0" id="oTDtype_0"
						background="/images/tab.active2.png" width=79px align=center
						onmouseover="style.cursor='hand'" onclick="resetbanner(0)">优化计划</td>
					<td class="cycleTDCurrent" name="oTDtype_6" id="oTDtype_6"
						background="/images/tab.active2.png" width=79px align=center
						onmouseover="style.cursor='hand'" onclick="resetbanner(6)">环境信息</td>
					<td class="cycleTD" name="oTDtype_1" id="oTDtype_1"
						background="/images/tab2.png" width=79px align=center
						onmouseover="style.cursor='hand'" onclick="resetbanner(1)">内存</td>
					<td class="cycleTD" name="oTDtype_1" id="oTDtype_2"
						background="/images/tab2.png" width=79px align=center
						onmouseover="style.cursor='hand'" onclick="resetbanner(2)">SQL执行情况</td>
					<td class="cycleTD" name="oTDtype_1" id="oTDtype_3"
						background="/images/tab2.png" width=79px align=center
						onmouseover="style.cursor='hand'" onclick="resetbanner(3)">线程情况</td>
					<td class="cycleTD" name="oTDtype_1" id="oTDtype_4"
						background="/images/tab2.png" width=79px align=center
						onmouseover="style.cursor='hand'" onclick="resetbanner(4)">预警情况</td>
					<td class="cycleTD" name="oTDtype_1" id="oTDtype_5"
						background="/images/tab2.png" width=79px align=center
						onmouseover="style.cursor='hand'" onclick="resetbanner(5)">日志打包</td>
					<td style="border-bottom: 1px solid rgb(145, 155, 156)">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td colspan="8" style="padding: 0;">
						<iframe
							src=""
							ID="iframeAlert" name="iframeAlert" frameborder="0"
							style="width: 100%; height: 100%; border-right: 1px solid #879293; border-bottom: 1px solid #879293; border-left: 1px solid #879293; padding: 10px; padding-right: 0"
							scrolling="auto"></iframe>
					</td>
				</tr>
			</TBODY>
		</table>
<SCRIPT language="javascript">
for(i=0;i<7;i++)
{
	document.all("oTDtype_"+i).background="/images/tab2.png";
	document.all("oTDtype_"+i).className="cycleTD";
}
document.all("oTDtype_0").background="/images/tab.active2.png";
document.all("oTDtype_0").className="cycleTDCurrent";
document.iframeAlert.document.location="/system/systemmonitor/system/MonitorJoin.jsp";

function resetbanner(objid)
{
	for(i=0;i<7;i++)
	{
		document.all("oTDtype_"+i).background="/images/tab2.png";
		document.all("oTDtype_"+i).className="cycleTD";
	}
	document.all("oTDtype_"+objid).background="/images/tab.active2.png";
	document.all("oTDtype_"+objid).className="cycleTDCurrent";
	var o = document.iframeAlert.document;
	if(objid==0)
	{
		o.location="/system/systemmonitor/system/MonitorJoin.jsp";
	}
	else if(objid==6)
	{
		o.location="/system/systemmonitor/system/MonitorStatus.jsp";
	}
	else if(objid==1)
	{
		o.location="/system/systemmonitor/system/MonitorMem.jsp";
	}
	else if(objid==2)
	{
		o.location="/system/systemmonitor/system/MonitorSQL.jsp";
	}
	else if(objid==3)
	{
		o.location="/system/systemmonitor/system/MonitorThread.jsp";
	}
	else if(objid==4)
	{
		o.location="/system/systemmonitor/system/MonitorWarning.jsp";
	}
	else if(objid==5)
	{
		o.location="/system/systemmonitor/system/MonitorLog.jsp";
	}
}
if("<%=reftree%>"==1) window.parent.iframeAlert("leftframe").window.document.location.reload();
if("<%=tab%>"!="0") resetbanner(<%=tab%>);

</script>
	</BODY>
</HTML>