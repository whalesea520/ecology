
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.formmode.interfaces.action.WSActionManager"%>

<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operate = Util.null2String(request.getParameter("operate"));
int actionid = Util.getIntValue(request.getParameter("actionid"), 0);
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int expandid = Util.getIntValue(request.getParameter("expandid"),0);
String actionname = Util.null2String(request.getParameter("actionname"));
int actionorder = Util.getIntValue(request.getParameter("actionorder"), 0);
String wsurl = Util.null2String(request.getParameter("wsurl"));//web service地址
String wsoperation = Util.null2String(request.getParameter("wsoperation"));//调用的web service的方法
String xmltext = Util.null2String(request.getParameter("xmltext"));
String retstr = Util.null2String(request.getParameter("retstr"));
int rettype = Util.getIntValue(request.getParameter("rettype"), 0);
String inpara = Util.null2String(request.getParameter("inpara"));
//out.println("operate = " + operate + "<br>");
//out.println("actionid = " + actionid + "<br>");
WSActionManager wsActionManager = new WSActionManager();
wsActionManager.setActionid(actionid);
wsActionManager.setModeid(modeid);
wsActionManager.setExpandid(expandid);
wsActionManager.setActionorder(actionorder);
wsActionManager.setActionname(actionname);
wsActionManager.setWsurl(wsurl);
wsActionManager.setWsoperation(wsoperation);
wsActionManager.setXmltext(xmltext);
wsActionManager.setRetstr(retstr);
wsActionManager.setRettype(rettype);
wsActionManager.setInpara(inpara);
if("delete".equals(operate)){
	wsActionManager.doDeleteWsAction();
}else if("save".equals(operate)){
	actionid = wsActionManager.doSaveWsAction();
	//out.println("actionid 222 = " + actionid + "<br>");
}
out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");

%>