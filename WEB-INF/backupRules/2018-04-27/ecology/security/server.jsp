
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.security.classLoader.ReflectMethodCall" %>
<%@ page import="weaver.hrm.*"%>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean>
<jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>安全包安装情况</title>

<style type="text/css">
	*{
		font-family: 微软雅黑; 
		mso-hansi-font-family: 微软雅黑
	}
	.normal{
		font-size:14px;
		font-weight:bold;
		color:#81878d;
		display:inline-block;
		padding-right:2px;
		padding-left:2px;
		text-align:center;
		height:40px;
		cursor:pointer;
	}

	.current{
		color:#197be0;
		border-bottom:2px solid #2887d7;
	}

	.listTable{
		width:100%;
		border:1px solid #dcdcdc;
		border-collapse:collapse;
	}
	.listTable th{
		height:40px;
	}
	.listTable th, .listTable td{
		border:1px solid #dcdcdc;
		font-size:12px;
		color:#384049;
	}
	.listTable td{
		padding-left:10px;
	}

	#uploadSecurityInfoBtn:hover{
		color:white;
		background-color:#03a996!important;
	}
</style>

</head>

<body style="margin:0;">

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
	Boolean testServer = (Boolean)rmc.call("weaver.security.core.SecurityCheckList","testNetwork",
		            		new Class[]{},null);
	if(testServer==null)testServer=new Boolean(false);
	String isJoinMonitor = xssUtil.null2String(request.getParameter("isJoinMonitor"));
	String operatetype = xssUtil.null2String(request.getParameter("operatetype"));
	
	if (!operatetype.equals(""))
	{
		if (operatetype.equals("autoupdate")){
			xssUtil.setAutoUpdateRules(isJoinMonitor.equals("1")?true:false);
		}else{
			rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"joinSystemSecurity",new Class[]{Boolean.class},new Boolean[]{new Boolean(isJoinMonitor.equals("1")?true:false)});
		}
	}

	Boolean isJoinSystemSecurity = (Boolean)rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"joinSystemSecurity",new Class[]{},null);
	if(isJoinSystemSecurity==null)isJoinSystemSecurity = new Boolean(true);
	String companyName = xssUtil.null2String(xssUtil.getCompanyname());
	String ecversion = xssUtil.null2String(xssUtil.getEcDetailVersion());
	if("".equals(companyName)){
		rs.executeSql("select companyname,cversion from license");
		if(rs.next()){
			companyName = xssUtil.null2String(rs.getString(1));
			ecversion = xssUtil.null2String(rs.getString(2));
		}
	}
	String sysid = xssUtil.null2String(rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"uuid",
		            		new Class[]{},null));
	JSONObject json = new JSONObject();
	json.put("sysid",sysid);
	json.put("companyName",companyName);
	json.put("ecVersion",ecversion);
	json.put("firewallStatus",new Boolean(xssUtil.enableFirewall()));
	json.put("autoUpdateStatus",new Boolean(xssUtil.isAutoUpdateRules()));
	json.put("softwareVersion",csui.getVersion());
	json.put("ruleVersion",csui.getRuleVersion());
	json.put("loginStatus",new Boolean(xssUtil.enableFirewall() && xssUtil.isLoginCheck()));
	json.put("pageStatus",new Boolean(xssUtil.enableFirewall() && xssUtil.getMustXss()));
	json.put("dataStatus",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsSkipRule()));
	json.put("enableServiceCheck",new Boolean(xssUtil.enableFirewall() && xssUtil.getEnableWebserviceCheck()));
	json.put("isUseESAPISQL",new Boolean(xssUtil.enableFirewall() && xssUtil.isUseESAPISQL()));
	json.put("isUseESAPIXSS",new Boolean(xssUtil.enableFirewall() && xssUtil.isUseESAPIXSS()));
	json.put("isResetCookie",new Boolean(xssUtil.enableFirewall() && xssUtil.isResetCookie()));
	json.put("httpOnly",new Boolean(xssUtil.enableFirewall() && xssUtil.getHttpOnly()));
	json.put("hostStatus",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsSkipHost()));
	json.put("isRefAll",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsRefAll()));
	json.put("httpSep",new Boolean(xssUtil.enableFirewall() && xssUtil.getHttpSep()));
	json.put("isCheckSessionTimeout",new Boolean(xssUtil.enableFirewall() && xssUtil.isCheckSessionTimeout()));
	json.put("isEnableForbiddenIp",new Boolean(xssUtil.enableFirewall() && xssUtil.isEnableForbiddenIp()>1));
	json.put("autoRemind",new Boolean(xssUtil.enableFirewall() && xssUtil.getAutoRemind()));
	//SecurityCheckList scl = new SecurityCheckList();
	//json.put("isConfigFirewall",scl.isConfigFirewall());
	//json.put("isEnableAccessLog",scl.isEnableAccessLog());
	//json.put("checkSocketTimeout",scl.checkSocketTimeout());
	//json.put("isResinAdmin",!scl.isResinAdmin());
	//json.put("is404PageConfig",scl.is404PageConfig());
	//json.put("is500PageConfig",scl.is500PageConfig());
	//json.put("isDisabledHttpMethod",scl.isDisabledHttpMethod());
	json.put("joinSystemSecurity",isJoinSystemSecurity);
	json.put("isWlanNetwork",testServer);
	json.put("fileupdate",new Boolean(true));
	json.put("src","uploadSecurityInfo");
	String info = (String)rmc.call("weaver.security.file.AESCoder",null,"encrypt",
								new Class[]{String.class,String.class},
								new String[]{json.toString(),null});
%>

<form id="frmRemain" name="frmRemain" method=post
			action="server.jsp">
<input type="hidden" name="info" id="info" value="<%=info%>"/>
<div style="overflow:auto;margin-top:36px;">
	<div style="font-size:24px;color:red;font-weight:bold;text-align:center;margin-top:30px;margin-bottom:50px;">如果能够看到此页面，则表示安全补丁正常安装！</div>
	<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:50px;line-height:50px;">
		<span style="display:inline-block;color:#384049;font-weight:bold;width:200px;text-align:right;">客户名称：</span>
		<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;"><%=companyName%></span>
	</div>
	<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:50px;line-height:50px;">
		<span style="display:inline-block;color:#384049;font-weight:bold;width:200px;text-align:right;">系统安全补丁机器标识：</span>
		<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;"><%=sysid%></span>
	</div>
	<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:50px;line-height:50px;">
		<span style="display:inline-block;color:#384049;font-weight:bold;width:200px;text-align:right;">服务器的外网联通情况：</span>
		<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;"><%=new Boolean(true).compareTo(testServer)==0?"<font style='color:green;font-weight:bold;'>可以联通外网</font>":"<font style='color:red;font-weight:bold;'>不可以联通外网</font>"%></span>
	</div>
		<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:50px;line-height:50px;">
			<span style="display:inline-block;color:#384049;font-weight:bold;width:200px;text-align:right;">是否加入安全保障计划：</span>
			<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;">
				<input type="hidden" name="isJoinMonitor" id="isJoinMonitor" value="1"/>
					<input name="operatetype" id="operatetype" type="hidden" value="">
					<span onclick="joinMonitor(1);" style="height:36px;text-align:center;line-height:36px;<%=new Boolean(true).compareTo(isJoinSystemSecurity)==0?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>display:inline-block;padding-left:10px;padding-right:10px;cursor:pointer;">
						<%if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){ %><span style="padding-right:5px;">√</span><%}%>
						加  入
					</span>
					<span onclick="joinMonitor(0);" style="cursor:pointer;margin-left:15px;height:36px;<%=new Boolean(true).compareTo(isJoinSystemSecurity)!=0?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;">
						<%if(new Boolean(true).compareTo(isJoinSystemSecurity)!=0){ %><span style="padding-right:5px;">√</span><%}%>
						不加入
					</span>
			</span>
		</div>
		<%if(false && new Boolean(true).compareTo(isJoinSystemSecurity)==0){ %>
			<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:50px;line-height:50px;">
				<span style="display:inline-block;color:#384049;font-weight:bold;width:200px;text-align:right;">是否启用自动更新：</span>
				<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;">
						<span onclick="enableAutoUpddate(1);" style="height:36px;text-align:center;line-height:36px;<%=xssUtil.isAutoUpdateRules()?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>display:inline-block;padding-left:10px;padding-right:10px;cursor:pointer;">
							<%if(xssUtil.isAutoUpdateRules()){ %><span style="padding-right:5px;">√</span><%}%>
							启  用
						</span>
						<span onclick="enableAutoUpddate(0);" style="cursor:pointer;margin-left:15px;height:36px;<%=!xssUtil.isAutoUpdateRules()?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;">
							<%if(!xssUtil.isAutoUpdateRules()){ %><span style="padding-right:5px;">√</span><%}%>
							不启用
						</span>
				</span>
			</div>
		<%}%>
		<div style="border-bottom:1px dotted #dcdcdc;margin-top:30px;margin-left:auto;margin-right:auto;max-width:800px;line-height:40px;font-size:20px;color:red;font-weight:bold;">
			<span style="display:inline-block;color:#384049;font-weight:bold;width:200px;text-align:right;">安全保障计划内容：</span>
			<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;font-weight:normal;line-height:30px;font-size:24px;color:red;font-weight:bold;">
				<p>
					<span style="padding-left:40px;">加入安全保障计划后，泛微会自动检测贵方系统的安全状况，如果发现系统有漏洞，会及时报告并修复漏洞，保障系统处于安全的状态。<span>
				</p>
				<p>
				<span style="padding-left:40px;">如果选择加入安全保障计划，泛微会自动收集<font style="color:green;font-weight:bold;">客户名称、系统版本、安全补丁</font>信息，保证不会收集其他无关信息，加密后安全地传输到泛微安全服务器上，以便我们能够准确掌握贵方系统的安全状况，如果发现有问题，会主动联系贵方协助处理，共同保障系统的安全运行。</span>
				</p>
				
			</span>
		</div>
		<%if(new Boolean(true).compareTo(testServer)!=0){%>
			<div style="border-bottom:1px dotted #dcdcdc;margin-top:30px;margin-left:auto;margin-right:auto;max-width:800px;line-height:40px;font-size:20px;color:red;font-weight:bold;">
			<span style="display:inline-block;color:#384049;font-weight:bold;width:200px;text-align:right;">备注：</span>
			<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;font-weight:normal;line-height:30px;font-size:24px;color:red;font-weight:bold;">
				<p>
					<span style="padding-left:40px;">检测到贵方OA服务器无法联通外网，所以即使选择加入安全保障计划，也无法为您提供安全补丁自动修复功能！<span>
				</p>
				<p>				
			</span>
		</div>
		<%}%>
	  <div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:50px;line-height:50px;text-align:center;">
			<span onclick="uploadSecurityInfo();" id="uploadSecurityInfoBtn" style="cursor:pointer;margin-top:5px;height:36px;text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;border:1px solid #c0c0c0;background-color:#30b5ff;color:white;">
				上报系统安全补丁安装情况至泛微安全服务器
			</span>
	</div>
</div>
</form>	
</body>
<script language="javascript">
function enableAutoUpddate(value)
{
	document.getElementById("isJoinMonitor").value=value;
	document.getElementById("operatetype").value="autoupdate";
	document.getElementById("frmRemain").target="_self";
	document.getElementById("frmRemain").action = "server.jsp";
	document.getElementById("frmRemain").submit();
}

function joinMonitor(value)
{
	document.getElementById("isJoinMonitor").value=value;
	document.getElementById("operatetype").value="join";
	document.getElementById("frmRemain").target="_self";
	document.getElementById("frmRemain").action = "server.jsp";
	document.getElementById("frmRemain").submit();
}

function uploadSecurityInfo(){
	document.getElementById("frmRemain").action = "https://update.e-cology.cn/cs/uploadSecurityInfo.jsp";
	document.getElementById("frmRemain").target="_blank";
	document.getElementById("frmRemain").submit();
}

</script>
</html>
