<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*,java.util.Properties,weaver.filter.ServerDetector,weaver.filter.msg.CheckSecurityUpdateInfo,weaver.security.classLoader.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean>
<jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>


<HTML>
	<HEAD>
		<script type="text/javascript" src="/security/monitor/jquery.min.js"></script>
		<style type="text/css">
			*{
				font-family: 微软雅黑; 
				mso-hansi-font-family: 微软雅黑
			}
			.fieldlabel{
				font-size:12px;
				color:#8e9297;
			}
			.fieldvalue{
				font-size:12px;
				color:#384049;
			}
			a{
				color:#1c7ae3;
				font-size:12px;
				TEXT-DECORATION:none;
			}
		</style>

		<script type="text/javascript">
			function downloadSecurityPackage(){
				if(confirm("确定从服务器下载并自动应用安全补丁吗？")){
					$.ajax({
						url:"/security/monitor/downloadSecurityPackage.jsp",
						type:"GET",
						beforeSend:function(){
								document.getElementById("msg").innerHTML="正在下载并且更新系统，请稍后...";
								document.getElementById("shadow").style.display = "block";
						},
						success:function(data){
							window.location.href="/security/monitor/MonitorStatus.jsp";
						},
						complete:function(){
								document.getElementById("shadow").style.display = "none";
						}
					});
				}
			}
		</script>

	</head>
	<%
		User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  return ;
		int UID = xssUtil.getIntValue(""+xssUtil.getRule().get("userID"),1);
		if (user.getUID()!=UID)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		Properties props=System.getProperties();
		csui.getRemoteServerVersion();
		ReflectMethodCall rmc = new ReflectMethodCall();
		Boolean isInUpdateList = (Boolean)rmc.call(
				"weaver.security.msg.CheckSecurityUpdateInfoUtil",
				"isInUpdateList",
				null);
		Boolean isAutoUpdate = xssUtil.isAutoUpdateRules();
		Boolean joinSystemSecurity = (Boolean)rmc.call(
				"weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),
				"joinSystemSecurity",
				null);
	    if(isInUpdateList == null)isInUpdateList = false;
		if(joinSystemSecurity == null)joinSystemSecurity = true;
	%>
	<BODY>
		<div id="shadow" style="display:none;background-color:#eaeaea;filter:alpha(opacity=70); -moz-opacity:0.7; opacity:0.7;position:absolute;width:100%;height:100%;text-align:center;line-height:100%;">
			<div id="msg" style="margin-top:40px;width:180px;line-height:30px;height:30px;color:#0B84E0;font-size:14px;margin-right:auto;margin-left:auto;"></div>
		</div>
		<div style="width:406px;height:506px;border:1px solid #d2d2d2;margin-top:80px;margin-right:auto;margin-left:auto;">
			<div style="width:100%;height:52px;line-height:52px;text-align:center;font-weight:bold;color:#384049;background-color:#f0f3f4;">
				环境信息
			</div>
			<div style="width:100%;height:100%;">
				<div style="margin-left:80px;padding-top:30px;">
					<div>
						<span class="fieldlabel">系统版本：</span>
						<span class="fieldvalue"><%=props.getProperty("os.name")+" "+props.getProperty("os.arch")+" "+props.getProperty("os.version") %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">ecology信息：</span>
						<span class="fieldvalue"></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">授权：</span>
						<span class="fieldvalue"><%=xssUtil.getCompanyname() %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">版本号：</span>
						<span class="fieldvalue"><%=xssUtil.getEcVersion() %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">web中间件版本：</span>
						<span class="fieldvalue"><%=ServerDetector.getServerId()%></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">JVM信息：</span>
						<span class="fieldvalue"><%=props.getProperty("java.version")+" "+props.getProperty("sun.arch.data.model") %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">客户端安全包软件版本：</span>
						<span class="fieldvalue"><%=csui.getVersion() %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">客户端安全包规则库版本：</span>
						<span class="fieldvalue"><%=csui.getRuleVersion() %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">泛微官网安全包软件版本：</span>
						<span class="fieldvalue"><%=csui.getNewversion() %>&nbsp;&nbsp;&nbsp;&nbsp;<%=csui.getNewversion().compareTo(csui.getVersion())>0?((isInUpdateList&&isAutoUpdate && joinSystemSecurity)?"<a href='#' onclick=\"downloadSecurityPackage()\">下载并应用更新</a>":"<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target='_blank'>下载</a>"):""%></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">泛微官网安全包规则库版本：</span>
						<span class="fieldvalue"><%=csui.getRuleNewVersion() %>&nbsp;&nbsp;&nbsp;&nbsp;<%=csui.getRuleNewVersion().compareTo(csui.getRuleVersion())>0?"<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target='_blank'>下载</a>":""%></span>
					</div>
				</div>
			</div>
		</div>
	</BODY>
</HTML>