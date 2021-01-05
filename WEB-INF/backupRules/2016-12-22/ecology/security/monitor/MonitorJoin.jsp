<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.security.classLoader.ReflectMethodCall" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean>



<HTML>
	<HEAD>
		<style>
			*{
				font-family: 微软雅黑; 
				mso-hansi-font-family: 微软雅黑
			}
			a{
				color:#1c7ae3;
				font-size:12px;
				TEXT-DECORATION:none;
			}
			.strongCss{
				font-weight:bold;
				color:#384049;
			}
		</style>
	</head>
	<%
		User user = HrmUserVarify.getUser(request, response);
		if (user == null)
			return;
		if (user.getUID() != 1)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		ReflectMethodCall rmc = new ReflectMethodCall();	
		String isJoinMonitor = xssUtil.null2String(request.getParameter("isJoinMonitor"));
		String operatetype = xssUtil.null2String(request.getParameter("operatetype"));
		
		if (!operatetype.equals(""))
		{
			if (operatetype.equals("autoupdate")){
				xssUtil.setAutoUpdateRules(isJoinMonitor.equals("1")?true:false);
			}else{
				rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"joinSystemSecurity",new Class[]{Boolean.class},new Boolean(isJoinMonitor.equals("1")?true:false));
			}
		}
		Boolean isJoinSystemSecurity = (Boolean)rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"joinSystemSecurity",new Class[]{},null);
		if(isJoinSystemSecurity==null)isJoinSystemSecurity = new Boolean(true);
		//System.out.println("operatetype : "+operatetype+" isJoinMonitor : "+isJoinMonitor);
	%>
	<BODY>
		<form id="frmRemain" name="frmRemain" method=post
			action="MonitorJoin.jsp">
			<div style="margin-left:40px;margin-right:40px;border-bottom:1px solid #e0e0e0;padding-bottom:48px;">
				<div style="font-size:14px;font-weight:bold;margin-top:42px;padding-bottom:18px;border-bottom:1px solid #e0e0e0;color:#384009">服务条款</div>
				<div style="font-size:12px;font-weight:bold;padding-top:28px;color:#384009">【系统安全保障计划说明】</div>
				<div style="font-size:12px;color:#62676d">
					<div style="padding-top:20px;">
						<div>泛微官方会持续关注产品安全，针对产品安全及时发布安全修复补丁，补丁会定期发布到泛微官方网站：<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target="_blank">www.weaver.com.cn/cs/securityDownload.asp</a>，可以手动下载更新，<span style="font-size:12px;font-weight:bold;">也可以通过开启以下服务进行自动更新，以保证系统始终保持最安全的状态</span></div>
					</div>
					<div style="padding-top:16px;">
						<b>如果加入系统安全保障计划，
						<p>
						<font style="color:red;font-weight:bold;">加入安全保障计划后，泛微会自动检测贵方系统的安全状况，如果发现系统有漏洞，会及时报告并修复漏洞，保障系统处于安全的状态。</font>
						</p>
						<p>泛微会采集必要的信息，主要用于泛微安全部门即时了解系统当前的安全状况，采集的信息仅限于：<font style="font-size:16px;color:red;">客户名称、系统版本、安全补丁版本</font>，并且采集的信息会加密后传输到泛微安全服务器上，以供分析.</b></p>
					</div>
					<div style="padding-top:16px;">
						自动更新服务会访问地址：<a href="#">https://update.e-cology.cn/</a> 如果开启服务，请保持应用服务器可以正常访问这个地址.
					</div>
					<div style="font-size:12px;font-weight:bold;padding-top:28px;color:#384009">【安全库升级故障报修】</div>
					<div style="padding-top:20px;">
						泛微紧急值班电话（非工作时间）：13916658651
					</div>
				</div>
			</div>
			<div style="text-align:center;margin-top:30px;">
				<input type="hidden" name="isJoinMonitor" id="isJoinMonitor" value="1"/>
				<input name="operatetype" id="operatetype" type="hidden" value="">
				<span onclick="joinMonitor(1);" style="height:36px;text-align:center;line-height:36px;<%=new Boolean(true).compareTo(isJoinSystemSecurity)==0?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>display:inline-block;padding-left:10px;padding-right:10px;cursor:pointer;">
					<%if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){ %><span style="padding-right:5px;">√</span><%}%>
					加入安全保障计划
				</span>
				<span onclick="joinMonitor(0);" style="cursor:pointer;margin-left:15px;height:36px;<%=new Boolean(true).compareTo(isJoinSystemSecurity)!=0?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;">
					<%if(new Boolean(true).compareTo(isJoinSystemSecurity)!=0){ %><span style="padding-right:5px;">√</span><%}%>
					不加入安全保障计划
				</span>
			</div>
			<%if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){ %>
				<div style="text-align:center;margin-top:30px;">
					<span onclick="enableAutoUpddate(1);" style="height:36px;text-align:center;line-height:36px;<%=xssUtil.isAutoUpdateRules()?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>display:inline-block;padding-left:10px;padding-right:10px;cursor:pointer;">
						<%if(xssUtil.isAutoUpdateRules()){ %><span style="padding-right:5px;">√</span><%}%>
						启用安全补丁自动更新
					</span>
					<span onclick="enableAutoUpddate(0);" style="cursor:pointer;margin-left:15px;height:36px;<%=!xssUtil.isAutoUpdateRules()?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;">
						<%if(!xssUtil.isAutoUpdateRules()){ %><span style="padding-right:5px;">√</span><%}%>
						不启用安全补丁自动更新
					</span>
				</div>
			<%}%>
		</form>
	</BODY>
	<script language="javascript">
	function enableAutoUpddate(value)
	{
		document.getElementById("isJoinMonitor").value=value;
		document.getElementById("operatetype").value="autoupdate";
		document.getElementById("frmRemain").submit();
	}
	function joinMonitor(value)
	{
		document.getElementById("isJoinMonitor").value=value;
		document.getElementById("operatetype").value="join";
		frmRemain.submit();
	}
	</script>
</HTML>