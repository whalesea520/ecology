
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%session.setAttribute("fromlogin","yes");%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page" />
<%
	int isfromportal = Util.getIntValue(request.getParameter("isfromportal"),0);
	String hasTemplate = Util.null2String(request.getParameter("hastemplate"));
	String hpid = Util.null2String(request.getParameter("hpid"));
	String defalutHp = (String)session.getAttribute("defaultHp");
	String hpurl = "";
	if(!"".equals(defalutHp)){
		hpurl=hpu.getHomepageUrl(user,false,defalutHp);
	}else{
		hpurl=hpu.getHomepageUrl(user,false);
	}
	String redirectUrl="";
	if(hpid.equals("")){
		if(hpurl.indexOf("?")!=-1){
			redirectUrl=hpurl+"&isfromhp=1&isfromportal="+isfromportal+"&hastemplate="+hasTemplate;
		} else {
			redirectUrl=hpurl+"?isfromhp=1&isfromportal="+isfromportal+"&hastemplate="+hasTemplate;
		}
	}else{
		redirectUrl="/homepage/Homepage.jsp?"+request.getQueryString()+"&hastemplate="+hasTemplate;
	}
	response.sendRedirect(redirectUrl);
%>