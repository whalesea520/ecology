<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*,java.util.*,weaver.security.classLoader.*,weaver.filter.XssUtil" %>
<jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>
<HTML>
	<HEAD>
		<style type="text/css">
			*{
				font-family: ΢���ź�; 
				mso-hansi-font-family: ΢���ź�
			}
			.theader{
				display:inline-block;
				font-weight:bold;
				font-size:14px;
				width:72px;
			}
			.tvalue{
				display:inline-block;
				font-size:12px;
				width:72px;
			}
			.operationBtn{
				font-size:12px;
				color:#197be0;
				border:1px solid #acacac;
				text-align:center;
				width:80px;
				height:30px;
				display:inline-block;
				line-height:30px;
				cursor:pointer;
			}
		</style>
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
		XssUtil xssUtil = new XssUtil();
		String dateStr = xssUtil.null2String(request.getParameter("dateStr"));
		
		if(!"".equals(dateStr)){
			if(csui.restoreUpdateFiles(dateStr)){
				xssUtil.writeLog("Security recovery success! ",true);
				try {
					xssUtil.initRules(true);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					xssUtil.writeError(e);
				}
				out.println("<script type='text/javascript'>alert('�ָ���ȫ��ɹ���');</script>");
			}else{
				out.println("<script type='text/javascript'>alert('�ָ���ȫ��ʧ�ܣ������²�����');</script>");
			}
		}
		String operation = xssUtil.null2String(request.getParameter("operation"));
		if("backup".equals(operation)){
			if(csui.bakUpdateFiles()){
				xssUtil.writeLog("Security backup success! ",true);
				out.println("<script type='text/javascript'>alert('���ݰ�ȫ��ɹ���');</script>");
			}else{
				out.println("<script type='text/javascript'>alert('���ݰ�ȫ��ʧ�ܣ������²�����');</script>");
			}
		}
		List files = csui.listAllBackups();
		ReflectMethodCall rmc = new ReflectMethodCall();
	%>
	<script type="text/javascript">
		function recovery(obj,datestr){
			if(!datestr){
				alert("��ѡ��Ҫ�ָ��İ汾");
				return;
			}
			if(confirm("ȷ��Ҫ�ָ���"+datestr+"�汾��")){
				document.getElementById("msg").innerHTML="���ڻָ���ȫ��...";
				document.getElementById("shadow").style.display = "block";
				location.href="MonitorBakRecv.jsp?dateStr="+datestr;
			}
		}
		function backup(obj){
			//obj.disabled = true;
			//obj.value="���ڱ���...";
			document.getElementById("msg").innerHTML="���ڱ��ݰ�ȫ��...";
			document.getElementById("shadow").style.display = "block";
			location.href="MonitorBakRecv.jsp?operation=backup";
		}
	</script>
	<BODY style="margin:0;">
		<div id="shadow" style="display:none;background-color:#eaeaea;filter:alpha(opacity=70); -moz-opacity:0.7; opacity:0.7;position:absolute;width:100%;height:100%;text-align:center;line-height:100%;">
			<div id="msg" style="margin-top:40px;width:180px;line-height:30px;height:30px;color:#0B84E0;font-size:14px;margin-right:auto;margin-left:auto;"></div>
		</div>
		<div style="width:100%;height:80px;">&nbsp;</div>
		<div style="width:680px;border:1px solid #d2d2d2;margin-right:auto;margin-left:auto;">
			<div style="width:100%;height:44px;line-height:44px;text-align:left;font-weight:bold;color:#384049;background-color:#f0f3f4;border-bottom:1px solid #d2d2d2;">
				<span class="theader" style="margin-left:36px">��������</span>
				<span class="theader" style="margin-left:92px">������汾</span>
				<span class="theader" style="margin-left:92px">��ȫ��汾</span>
				<span class="theader" style="margin-left:118px">����</span>
			</div>
			<div style="max-height:500px;overflow:auto">
			<%
				Object obj = rmc.newInstance("weaver.security.msg.CheckSecurityUpdateInfo");
				for(int i = 0;i<files.size();i++)
				{
					String file = xssUtil.null2String(files.get(i));
					Map info = (Map)rmc.call("weaver.security.msg.CheckSecurityUpdateInfo",obj,"getVersionInfo",new Class[]{String.class},new Object[]{file});
				%>
					<div style="width:100%;height:52px;line-height:52px;text-align:left;color:#384049;border-bottom:1px solid #d2d2d2;">
						<span class="tvalue" style="margin-left:36px"><%=file %></span>
						<span class="tvalue" style="margin-left:92px"><%=xssUtil.null2String(info.get("software-version"))%></span>
						<span class="tvalue" style="margin-left:92px"><%=xssUtil.null2String(info.get("rule-version"))%></span>
						<span class="tvalue" style="margin-left:118px;">
							<span id="backup" style="display:none;" onclick="recovery(this,'<%=file%>');" class="operationBtn">һ���ָ�</span>
						</span>
					</div>
				<%
				}
				%>
				</div>
				<div style="height:62px;width:100%;text-align:center;">
					<span  id="backup" onclick="backup(this);" style="cursor:pointer;margin-top:15px;width:80px;height:30px;display:inline-block;background-color:#2c91e6;color:white;line-height:30px;">һ������</span>
				</div>
		</div>
	</BODY>
</HTML>