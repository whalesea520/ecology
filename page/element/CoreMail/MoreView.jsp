<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SecurityHelper" %>
<%@ page import="weaver.interfaces.email.CoreMailAPI" %>
<%@ page import="weaver.interfaces.email.CoreMailXML" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<style>
.headTable th {
    background-color: rgb(248, 248, 248);
	border-bottom-color: rgb(183, 224, 254);
	border-bottom-style: solid;
	border-bottom-width: 2px;
	border-collapse: collapse;
	border-right-color: rgba(0, 0, 0, 0);
	border-right-style: solid;
	border-right-width: 1px;
	color: rgb(0, 0, 0);
	cursor: pointer;
	display: table-cell;
	font-family: 'Microsoft YaHei';
	font-size: 12px;
	font-weight: normal;
	height: 32px;
	line-height: 30px;
	list-style-type: circle;
	margin-bottom: 0px;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	max-width: 35px;
	padding-bottom: 0px;
	padding-left: 10px;
	padding-right: 5px;
	padding-top: 0px;
	text-align: left;
	text-overflow: clip;
	vertical-align: middle;
	white-space: nowrap;
	word-break: keep-all;
}

.headTable,.contentDiv td {
    background-color: rgb(255, 255, 255);
	border-collapse: collapse;
	color: rgb(36, 36, 36);
	display: table-cell;
	font-family: 'Microsoft YaHei';
	font-size: 12px;
	height: 32px;
	list-style-type: circle;
	margin-bottom: 0px;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	overflow-x: hidden;
	overflow-y: hidden;
	padding-bottom: 0px;
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 0px;
	text-align: left;
	text-overflow: ellipsis;
	vertical-align: middle;
	white-space: nowrap;
	word-break: keep-all;
}

</style>
</head>

<body>
<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<% } %>

<%	
	String eid = Util.null2String(request.getParameter("eid"));
	String head = "";
    String result = "";
    
	//String operation = "test";
	String operation = "";
	if("test".equals(operation)) {
		CoreMailXML xml = new CoreMailXML(eid);
		head = xml.getHeadTest(user.getLanguage());
		result = xml.getHtmlTestMore();
	} else {
		try {
			CoreMailAPI api = CoreMailAPI.getInstance();
			CoreMailXML xml = new CoreMailXML(eid);
			head = xml.getHead(user.getLanguage());
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
								    String linkurl = "http://" + address + "/coremail/demo/newmsg/getNewMailsInfo.jsp?returnDetails=true&sid=" + sid;
									String xmlstr = xml.getXML(linkurl, "utf-8");
									result = xml.getHtmlMore(xmlstr);
							    } else {
							    	result = "<span style='color:red'>"+SystemEnv.getHtmlLabelName(130002,user.getLanguage())+"</span>";
							    }
					    	} else {
					    		result = "<span style='color:red'>"+SystemEnv.getHtmlLabelName(130001,user.getLanguage())+"</span>";
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

<div class="headTable">
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" style="table-layout: fixed;">
		<tr>
			<td width="*" valign="top">
				<table width="100%" style='table-layout: fixed;'>
					<%=head %>
				</table>
			</td>
		</tr>
	</table>
</div>
<div class="contentDiv">
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" style="table-layout: fixed;">
		<tr>
			<td width="*" valign="top">
				<table width="100%" style='table-layout: fixed;'>
					<%=result %>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
