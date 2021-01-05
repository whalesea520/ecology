<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.security.classLoader.ReflectMethodCall" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean>
<jsp:useBean id="sc" class="weaver.security.core.SecurityCore"></jsp:useBean>



<HTML>
	<HEAD>
		<style>
			*{
				font-family: ΢���ź�; 
				mso-hansi-font-family: ΢���ź�
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
		int UID = xssUtil.getIntValue(""+xssUtil.getRule().get("userID"),1);
		if (user.getUID() != UID)
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
				<div style="font-size:14px;font-weight:bold;margin-top:42px;padding-bottom:18px;border-bottom:1px solid #e0e0e0;color:#384009">��������</div>
				<div style="font-size:12px;font-weight:bold;padding-top:28px;color:#384009">��ϵͳ��ȫ���ϼƻ�˵����</div>
				<div style="font-size:12px;color:#62676d">
					<div style="padding-top:20px;">
						<div>��΢�ٷ��������ע��Ʒ��ȫ����Բ�Ʒ��ȫ��ʱ������ȫ�޸������������ᶨ�ڷ�������΢�ٷ���վ��<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target="_blank">www.weaver.com.cn/cs/securityDownload.asp</a>�������ֶ����ظ��£�<span style="font-size:12px;font-weight:bold;">Ҳ����ͨ���������·�������Զ����£��Ա�֤ϵͳʼ�ձ����ȫ��״̬</span></div>
					</div>
					<div style="padding-top:16px;">
						<b>�������ϵͳ��ȫ���ϼƻ���
						<p>
						<font style="color:red;font-weight:bold;">���밲ȫ���ϼƻ��󣬷�΢���Զ�����ϵͳ�İ�ȫ״�����������ϵͳ��©�����ἰʱ���沢�޸�©��������ϵͳ���ڰ�ȫ��״̬��</font>
						</p>
						<p>��΢��ɼ���Ҫ����Ϣ����Ҫ���ڷ�΢��ȫ���ż�ʱ�˽�ϵͳ��ǰ�İ�ȫ״�����ɼ�����Ϣ�����ڣ�<font style="font-size:16px;color:red;">�ͻ����ơ�ϵͳ�汾����ȫ�����汾</font>�����Ҳɼ�����Ϣ����ܺ��䵽��΢��ȫ�������ϣ��Թ�����.</b></p>
					</div>
					<div style="padding-top:16px;">
						�Զ����·������ʵ�ַ��<a href="#">https://update.e-cology.cn/</a> ������������뱣��Ӧ�÷����������������������ַ�����������ʾ404ҳ���˵��������.
					</div>
					<div style="font-size:12px;font-weight:bold;padding-top:28px;color:#384009">����ȫ���������ϱ��ޡ�</div>
					<div style="padding-top:20px;">
						��΢����ֵ��绰���ǹ���ʱ�䣩��139-1862-9764
					</div>
				</div>
			</div>
			<div style="text-align:center;margin-top:30px;">
				<input type="hidden" name="isJoinMonitor" id="isJoinMonitor" value="1"/>
				<input name="operatetype" id="operatetype" type="hidden" value="">
				<span onclick="joinMonitor(1);" style="height:36px;text-align:center;line-height:36px;<%=new Boolean(true).compareTo(isJoinSystemSecurity)==0?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>display:inline-block;padding-left:10px;padding-right:10px;cursor:pointer;">
					<%if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){ %><span style="padding-right:5px;">��</span><%}%>
					���밲ȫ���ϼƻ�
				</span>
				<span onclick="joinMonitor(0);" style="cursor:pointer;margin-left:15px;height:36px;<%=new Boolean(true).compareTo(isJoinSystemSecurity)!=0?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;">
					<%if(new Boolean(true).compareTo(isJoinSystemSecurity)!=0){ %><span style="padding-right:5px;">��</span><%}%>
					�����밲ȫ���ϼƻ�
				</span>
			</div>
			<%if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){ %>
				<div style="text-align:center;margin-top:30px;">
					<span onclick="enableAutoUpddate(1);" style="height:36px;text-align:center;line-height:36px;<%=xssUtil.isAutoUpdateRules()?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>display:inline-block;padding-left:10px;padding-right:10px;cursor:pointer;">
						<%if(xssUtil.isAutoUpdateRules()){ %><span style="padding-right:5px;">��</span><%}%>
						���ð�ȫ�����Զ�����
					</span>
					<span onclick="enableAutoUpddate(0);" style="cursor:pointer;margin-left:15px;height:36px;<%=!xssUtil.isAutoUpdateRules()?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"%>text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;">
						<%if(!xssUtil.isAutoUpdateRules()){ %><span style="padding-right:5px;">��</span><%}%>
						�����ð�ȫ�����Զ�����
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