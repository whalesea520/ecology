<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.system.License"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.security.classLoader.ReflectMethodCall" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean>
<jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>
<HTML>
	<HEAD>
		<title>系统安全包服务监控</title>
		<style style="text/css">
		*{
			font-family: 微软雅黑; 
			mso-hansi-font-family: 微软雅黑
		}
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

		.mainDiv{
			width:100%;
			height:54px;
			border-bottom: 1px solid #d2d2d2;
			background-color:#eaeaea;
			font-size:14px;
			line-height:54px;
			text-align: center;
		}
		
		.cycleTD {
			cursor: pointer;
			height:100%;
			color:#777b7e;
			padding-right:42px;
		}
		
		.cycleTDCurrent {
			color: #1a7ee4;
			font-weight:bold;
			height:100%;
			cursor: pointer;			
			padding-right:42px;
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
		table{
			font-size:9pt;
		}
		</style>
		<LINK href="Weaver.css" type=text/css rel=STYLESHEET>
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

		String imagefilename = "images/hdMaintenance.gif";
		String titlename = "系统安全包服务";
		String needfav = "1";
		String needhelp = "";

		int id = Util.getIntValue(request.getParameter("id"), 0);
		int messageid = Util.getIntValue(request.getParameter("message"), 0);
		int errorcode = Util.getIntValue(request.getParameter("errorcode"), 0);
		int reftree = Util.getIntValue(request.getParameter("reftree"), 0);
		int tab = Util.getIntValue(request.getParameter("tab"), 0);
		String url = "";
		url = request.getRequestURL().toString();
		String uri = request.getRequestURI();
		if(uri!=null){
			url = url.replace(uri,"/");
		}
		ReflectMethodCall rmc = new ReflectMethodCall();
		/*String params = "src=sendURLtoServer&url="+url;
		String sysid = (String)rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"uuid",
		            		new Class[]{},null);
		params = params+"&sysid="+sysid;
		params = (String)rmc.call("weaver.security.file.AESCoder",null,"encrypt",
		            		new Class[]{String.class,String.class},
		            		params,null);
		*/
						
		//String typeid = Util.null2String(request.getParameter("type"));
	%>
	<BODY style="overflow:hidden;margin:0;">
		<!--<div style="display:none;">
			<iframe
				src="https://update.e-cology.cn/cs/securityUpdateInfo.jsp?info="
				id="iframeURL" name="iframeURL" frameborder="0"
				style="width: 100%; height: 100%; border-right: 1px solid #879293; border-bottom: 1px solid #879293; border-left: 1px solid #879293;"
				scrolling="auto"></iframe>
		</div>-->
		<input type="hidden" name="id" value="<%=id%>">
		<div class="mainDiv">
			<input type="hidden" name="id" value="<%=id%>">
			<div name="oTDtype_0" id="oTDtype_0" align=center style="padding-left:40px;float:left;"
				onmouseover="style.cursor='hand'" onclick="resetbanner(0)">自动更新计划</div>
			<div name="oTDtype_5" id="oTDtype_5"
				 align=center
				onmouseover="style.cursor='hand'" onclick="resetbanner(5)"style="float:left;">安全包概要</div>
			<div name="oTDtype_6" id="oTDtype_6"  align=center style="float:left;"
				onmouseover="style.cursor='hand'" onclick="resetbanner(6)"style="float:left;">环境信息</div>
			<div name="oTDtype_3" id="oTDtype_3"
				  align=center
				onmouseover="style.cursor='hand'" onclick="resetbanner(3)"style="float:left;">安全体检</div>
			<div name="oTDtype_4" id="oTDtype_4"
				  align=center
				onmouseover="style.cursor='hand'" onclick="resetbanner(4)"style="float:left;">安全监控</div>
			<div name="oTDtype_1" id="oTDtype_1"
				 align=center
				onmouseover="style.cursor='hand'" onclick="resetbanner(1)"style="float:left;">备份与恢复</div>
			<div name="oTDtype_2" id="oTDtype_2"
				 align=center
				onmouseover="style.cursor='hand'" onclick="resetbanner(2)"style="float:left;">安全开启详情</div>
			<div style="clear:both;"></div>
		</div>
		<div style="width:100%;height:100%;">
			<iframe
				src=""
				id="iframeAlert" name="iframeAlert" frameborder="0"
				style="width: 100%; height: 100%; border-right: 1px solid #879293; border-bottom: 1px solid #879293; border-left: 1px solid #879293;"
				scrolling="auto"></iframe>
		</div>
<SCRIPT language="javascript">
	try{
		document.getElementById("iframeAlert").style.height=(window.innerHeight-55)+"px";
	}catch(e){
		document.getElementById("iframeAlert").style.height=(document.documentElement.clientHeight-55)+"px";
	}
for(i=0;i<7;i++)
{
	try{
		//document.getElementById("oTDtype_"+i).style.background="images/tab2.png";
		document.getElementById("oTDtype_"+i).className="cycleTD";
	}catch(e){alert(e);}
}
//document.getElementById("oTDtype_0").style.background="images/tab.active2.png";
document.getElementById("oTDtype_0").className="cycleTDCurrent";
document.getElementById("iframeAlert").src="MonitorJoin.jsp";

function resetbanner(objid)
{
	for(i=0;i<8;i++)
	{	try{
			//document.getElementById("oTDtype_"+i).style.background="images/tab2.png";
			document.getElementById("oTDtype_"+i).className="cycleTD";
		}catch(e){}
	}
	//document.getElementById("oTDtype_"+objid).background="images/tab.active2.png";
	document.getElementById("oTDtype_"+objid).className="cycleTDCurrent";
	var o = document.iframeAlert.document;
	if(objid==0)
	{
		o.location="MonitorJoin.jsp";
	}
	else if(objid==6)
	{
		o.location="MonitorStatus.jsp";
	}
	else if(objid==1)
	{
		o.location="MonitorBakRecv.jsp";
	}
	else if(objid==2)
	{
		o.location="MonitorSecurityStatus.jsp";
	}
	else if(objid==3)
	{
		o.location="checkdone.jsp";
	}
	else if(objid==4)
	{
		o.location="MonitorSecurity.jsp?cmd=viewForbiddenDetail";
	}
	else if(objid==5)
	{
		o.location="/security/monitor/checkdone.jsp?operation=showExceptionFile";
	}
}
if("<%=reftree%>"==1) window.parent.iframeAlert("leftframe").window.document.location.reload();
if("<%=tab%>"!="0") resetbanner(<%=tab%>);

</script>
	</BODY>
</HTML>