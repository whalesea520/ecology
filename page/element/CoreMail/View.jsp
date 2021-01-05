<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SecurityHelper" %>
<%@ page import="weaver.interfaces.email.CoreMailAPI" %>
<%@ page import="weaver.interfaces.email.CoreMailXML" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/element/viewCommon.jsp" %>

<html>
<body>
<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<% } %>

<%
    String result = "";
	//String operation = "test";
	String operation = "";
	if("test".equals(operation)) {
		CoreMailXML xml = new CoreMailXML(eid);
		result = xml.getHtmlTest();
	} else {
		try {
			CoreMailAPI api = CoreMailAPI.getInstance();
			CoreMailXML xml = new CoreMailXML(eid);
		    boolean flag = false;
			flag = api.InitClient();
		    if(flag) {
			    //String address = api.getSystemAddress();
			    String address=new BaseBean().getPropValue("coremail", "wbaddress");//qc:275204 满足地产coremail邮件系统对接集成联调提交
			    if(!"".equals(address)) {
				    String email = Util.null2String(user.getEmail());
				    rs.executeSql("select email from hrmresource where id = " + user.getUID());
					if(rs.next()) {
						email = Util.null2String(rs.getString("email"));
					}
					
				    String sysid = xml.getCoreMailSysid();
				    if(!"".equals(sysid)) {
					    String password = "";
					    rs.executeSql("select password from outter_account where sysid = '"+ sysid + "' and userid = " + user.getUID());
						if(rs.next()) {
							password = rs.getString("password");
					        if(!"".equals(password)) {// 解密
					        	password = SecurityHelper.decryptSimple(password);
					        }
						} else {
							out.println("<span style='color:red'>"+SystemEnv.getHtmlLabelName(130003,user.getLanguage())+"</span>");
							response.sendRedirect("/interface/AccountSetting.jsp?sysid=" + sysid);
							return;
						}
					    
					    String sid = "";
					    if(!"".equals(email)) {
					    	if(api.authenticate(email, password)) {
						    	sid = api.userLogin(email);
							    if(!"".equals(sid)) {
								    //String linkurl = "http://" + address + "/coremail/demo/newmsg/getNewMailsInfo.jsp?returnDetails=true&sid=" + sid;
									String xmlstr = api.getNewMailList(email,"20");
									new weaver.general.BaseBean().writeLog("xmlstr="+xmlstr);
									result = xml.getHtml(xmlstr);
							    } else {
							    	result = "<span style='color:red'>"+SystemEnv.getHtmlLabelName(130002,user.getLanguage())+"</span>";
							    }
					    	} else {
					    		result = "<span style='color:red'>"+SystemEnv.getHtmlLabelName(130001,user.getLanguage())+
					    		"</span><a href='"+"/interface/AccountSetting.jsp?sysid=" + sysid+"&backPage=/page/element/CoreMail/View.jsp'>点此链接设置</a>";//qc:281168上海地产集团coremail邮箱输入密码界面没有密码校验-集成模块
					    	}
					    }
				    }
			    } else {
			    	result = "<span style='color:red'>"+SystemEnv.getHtmlLabelName(130000,user.getLanguage())+"</span>";
			    }
		    } else {
		    	result = "<span style='color:red'>"+SystemEnv.getHtmlLabelName(129999,user.getLanguage())+"</span>";
		    }
		} catch(Exception e) {
			result = "<span style='color:red'>"+SystemEnv.getHtmlLabelName(129999,user.getLanguage())+"</span>";
	    }
	}
%>

<table class="Econtent" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td width="1px"></td>
		<td width="*" valign="top">
			<table width="100%" style='table-layout: fixed;'>
				<%=result %>
			</table>
		</td>
		<td width="1px"></td>
	</tr>
</table>
</body>
</html>
