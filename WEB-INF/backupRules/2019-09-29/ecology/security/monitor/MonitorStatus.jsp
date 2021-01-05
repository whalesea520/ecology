<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*,java.util.Properties,weaver.filter.ServerDetector,weaver.filter.msg.CheckSecurityUpdateInfo" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean>
<jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>

<HTML>
	<HEAD>
		<style type="text/css">
			*{
				font-family: ΢���ź�; 
				mso-hansi-font-family: ΢���ź�
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
	</head>
	<%
		User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  return ;
		if (user.getUID()!=1)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		Properties props=System.getProperties();
		csui.getRemoteServerVersion();
	%>
	<BODY>
		<div style="width:406px;height:506px;border:1px solid #d2d2d2;margin-top:80px;margin-right:auto;margin-left:auto;">
			<div style="width:100%;height:52px;line-height:52px;text-align:center;font-weight:bold;color:#384049;background-color:#f0f3f4;">
				������Ϣ
			</div>
			<div style="width:100%;height:100%;">
				<div style="margin-left:80px;padding-top:30px;">
					<div>
						<span class="fieldlabel">ϵͳ�汾��</span>
						<span class="fieldvalue"><%=props.getProperty("os.name")+" "+props.getProperty("os.arch")+" "+props.getProperty("os.version") %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">ecology��Ϣ��</span>
						<span class="fieldvalue"></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">��Ȩ��</span>
						<span class="fieldvalue"><%=xssUtil.getCompanyname() %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">�汾�ţ�</span>
						<span class="fieldvalue"><%=xssUtil.getEcVersion() %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">web�м���汾��</span>
						<span class="fieldvalue"><%=ServerDetector.getServerId()%></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">JVM��Ϣ��</span>
						<span class="fieldvalue"><%=props.getProperty("java.version")+" "+props.getProperty("sun.arch.data.model") %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">�ͻ��˰�ȫ�������汾��</span>
						<span class="fieldvalue"><%=csui.getVersion() %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">�ͻ��˰�ȫ�������汾��</span>
						<span class="fieldvalue"><%=csui.getRuleVersion() %></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">��΢������ȫ�������汾��</span>
						<span class="fieldvalue"><%=csui.getNewversion() %>&nbsp;&nbsp;&nbsp;&nbsp;<%=csui.getNewversion().compareTo(csui.getVersion())>0?"<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target='_blank'>����</a>":""%></span>
					</div>
					<div style="padding-top:22px;">
						<span class="fieldlabel">��΢������ȫ�������汾��</span>
						<span class="fieldvalue"><%=csui.getRuleNewVersion() %>&nbsp;&nbsp;&nbsp;&nbsp;<%=csui.getRuleNewVersion().compareTo(csui.getRuleVersion())>0?"<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target='_blank'>����</a>":""%></span>
					</div>
				</div>
			</div>
		</div>
	</BODY>
</HTML>