
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST,weaver.general.Util,weaver.rtx.RTXConfig" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsrtx" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<%
rsrtx.executeSql("select * from SystemSet");
String oaaddress = "";
if(rsrtx.next()){
	oaaddress = rsrtx.getString("oaaddress");
}
String loginid = Util.null2String(request.getParameter("loginid"));
RTXConfig rtxConfig = new RTXConfig();
loginid = rtxConfig.getOaLoginidByIMLoginid(loginid);
if("".equals(loginid)){
	response.sendRedirect(oaaddress+"/notice/noright.jsp");
}else{
	String retUrl = Util.null2String(request.getHeader("Referer"));
	String gotoPage = Util.null2String(request.getParameter("gopage"));
	if(retUrl.indexOf("/login/RTXClientLoginOA.jsp") < 0) {
		response.sendRedirect(oaaddress+"/notice/noright.jsp");
	}
	rs.executeQuery("select password,isADAccount from hrmresource where loginid=?",loginid);
	if(rs.next()) {
		String mode = Util.null2String(Prop.getPropValue(GCONST.getConfigFile(), "authentic"));
		String password = Util.null2String(rs.getString("password"));
		String isADAccount = Util.null2String(rs.getString("isADAccount"));
		if (mode != null && mode.equals("ldap") && "1".equals(isADAccount)) {
			password = loginid;
		}
		
    	String loginPage = "login/VerifyRtxLogin.jsp";
		if("".equals(gotoPage)) gotoPage = "wui/main.jsp";
		String para = "/"+gotoPage+"#"+loginid+"#"+password;
		para = PoppupRemindInfoUtil.encrypt(para);
		
		if (mode != null && mode.equals("ldap") && "1".equals(isADAccount)) {
			rs.executeUpdate("insert into RtxLdapLoginLog values (?,?,'0')",loginid,para);
		}
		
		String tempurl = oaaddress + "/"+loginPage + "?para="+para;
		out.println(tempurl);
	}else{
		response.sendRedirect(oaaddress+"/notice/noright.jsp");
	}
}

%>