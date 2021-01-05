<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.outter.OutterDisplayHelper"%>
<%@ page import="weaver.interfaces.outter.CheckIpNetWork"%>
<%@ page import="weaver.interfaces.email.CoreMailAPI" %>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
response.setHeader("Pragma", "No-Cache");
response.setHeader("Cache-Control", "No-Cache");
response.setDateHeader("Expires", 0);
%>

<%
//集成日志
Logger newlog = LoggerFactory.getLogger();

String operationType = "";

Enumeration paramList = request.getParameterNames();
if(paramList != null) {
	while(paramList.hasMoreElements()) {
		String tempName = Util.null2String((String) paramList.nextElement());
		if("operationType".equals(tempName)) {
			String tempValue = request.getParameter(tempName);
			if("test".equals(tempValue)) {
				operationType = tempValue;
			}
		}
	}
}

String sysid = Util.null2String(request.getParameter("id"));// 系统标识
String mid = Util.null2String(request.getParameter("mid"));
if("".equals(operationType)) {
	// 权限判断
	// 得到有权限查看的集成登录
	OutterDisplayHelper ohp = new OutterDisplayHelper();
	String sqlright = ohp.getShareOutterSql(user);
	String sql = "select sysid from outter_sys a where sysid='"+sysid+"' and EXISTS (select 1 from ("+sqlright+") b where a.sysid=b.sysid )";
	RecordSet.executeSql(sql);
	if(RecordSet.getCounts() < 1) {
		response.sendRedirect("/notice/noright.jsp");
	 	return;
	}
	
	String password = "";// 密码
	String autologinflag = "";// 是否内外网自动登录
	String logintype = "1";// 访问类型
	String iurl = "";
	String ourl = "";
	String serverurl = "AccountSetting.jsp?sysid=" + sysid;
	
	RecordSet.executeSql("select * from outter_sys where sysid = '"+sysid+"' ");
	if (RecordSet.next()) {
		autologinflag = Util.null2String(RecordSet.getString("autologin"));
		iurl = Util.null2String(RecordSet.getString("iurl"));
		ourl = Util.null2String(RecordSet.getString("ourl"));
	}
	
	RecordSet.executeSql("select account, password, logintype from outter_account where sysid='"+ sysid + "' and userid=" + user.getUID());
	if (RecordSet.next()) {
		password = RecordSet.getString("password");
        if(!"".equals(password)) {// 解密
        	password = SecurityHelper.decryptSimple(password);
        }
		
		if("1".equals(autologinflag)) {// 开启内外网自动登录
			CheckIpNetWork checkipnetwork = new CheckIpNetWork();
			String clientIP = request.getRemoteAddr();
			boolean checktmp = checkipnetwork.checkIpSeg(clientIP,sysid);// true表示在网段之外，false表示在网段之内
			if(checktmp) {
				serverurl = ourl;
			} else {
				serverurl = iurl;
			}
		} else {
			logintype = RecordSet.getString("logintype");
			if ("1".equals(logintype)) {
				serverurl = iurl;
			} else {
				serverurl = ourl;
			}
		}
	}
	
	if (serverurl.indexOf("AccountSetting.jsp") > -1) {
		response.sendRedirect(serverurl);
		return;
	}
	
	try {
		CoreMailAPI coremailapi = CoreMailAPI.getInstance();
		boolean flag = false;
		flag = coremailapi.InitClient();
		if(!flag) {
			newlog.error("登录失败，请检查OA中CoreMail邮箱地址是否配置正确、CoreMail邮箱是否开启、CoreMail邮箱安全设置中是否添加OA地址！");
			return;
		}
		
		String sid = "";
		RecordSet.execute("select email from hrmresource where id = " + user.getUID());
		if(RecordSet.next()) {
			String email = Util.null2String(RecordSet.getString("email"));
			if(!"".equals(email)) {
				if(coremailapi.authenticate(email, password)) {
					sid = coremailapi.userLogin(email);
					if(!"".equals(sid)) {
						response.sendRedirect(serverurl + "?sid=" + sid+"#mail.read|{\"fid\":1,\"mid\":\""+mid+"\"}");
						return;
					} else {
						newlog.error("登录失败，CoreMail邮箱不存在此账号！");
					}
				} else {
					newlog.error("登录失败，请检查CoreMail账号或密码是否正确！");
				}
			}
		}
	} catch(Exception e) {
		
	}
} else {
	String password = "";// 密码
	String autologinflag = "";// 是否内外网自动登录
	String logintype = "1";// 访问类型
	String baseparam2 = "";// 密码参数名
	String iurl = "";
	String ourl = "";
	String serverurl = "";
	
	RecordSet.executeSql("select * from outter_sys where sysid = '"+sysid+"' ");
	if (RecordSet.next()) {
		autologinflag = Util.null2String(RecordSet.getString("autologin"));
		baseparam2 = Util.null2String(RecordSet.getString("baseparam2"));
		iurl = Util.null2String(RecordSet.getString("iurl"));
		ourl = Util.null2String(RecordSet.getString("ourl"));
	}
	
	// 集成登录测试传入参数
	Enumeration paramList1 = request.getParameterNames();
	while(paramList1.hasMoreElements()) {
		String tempName = Util.null2String((String) paramList1.nextElement());
		if(baseparam2.equals(tempName)) {
			password = request.getParameter(tempName);
		}
		if("logintype_sysparam".equals(tempName)) {
			logintype = request.getParameter(tempName);
		}
	}
	
	if("1".equals(autologinflag)) {// 开启内外网自动登录
		CheckIpNetWork checkipnetwork = new CheckIpNetWork();
		String clientIP = request.getRemoteAddr();
		boolean checktmp = checkipnetwork.checkIpSeg(clientIP, sysid);// true表示在网段之外，false表示在网段之内
		if(checktmp) {
			serverurl = ourl;
		} else {
			serverurl = iurl;
		}
	} else {
		if ("1".equals(logintype)) {
			serverurl = iurl;
		} else {
			serverurl = ourl;
		}
	}
	
	try {
		CoreMailAPI coremailapi = CoreMailAPI.getInstance();
		boolean flag = false;
		flag = coremailapi.InitClient();
		if(!flag) {
			newlog.error("登录失败，请检查OA中CoreMail邮箱地址是否配置正确、CoreMail邮箱是否开启、CoreMail邮箱安全设置中是否添加OA地址！");
			return;
		}
		
		String sid = "";
		String email = Util.null2String(request.getParameter("email"));
		if(!"".equals(email)) {
			if(coremailapi.authenticate(email, password)) {
				sid = coremailapi.userLogin(email);
				if(!"".equals(sid)) {
					response.sendRedirect(serverurl + "?sid=" + sid);
					return;
				} else {
					newlog.error("登录失败，CoreMail邮箱不存在此账号！");
				}
			} else {
				newlog.error("登录失败，请检查CoreMail账号或密码是否正确！");
			}
		}
	} catch(Exception e) {
		
	}
}

%>





