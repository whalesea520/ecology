<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/formmode/checkright4setting.jsp" %>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="com.weaver.formmodel.util.FileHelper"%>
<%@ page import="com.weaver.formmodel.util.DynamicCompiler"%>
<%@ page import="java.io.File"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.formmode.customjavacode.JavaCodeManager"%>
<%@ include file="/formmode/pub_init.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)&&!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

response.reset();
out.clear();
String action = Util.null2String(request.getParameter("action"));
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
JSONObject jsonObject = new JSONObject();
if(action.equals("deleteFlowRight")){//删除流程赋权
		modeRightInfo.deleteFlowRight(modeId);
		jsonObject.put("status",1);
		response.getWriter().write(jsonObject.toString());
		return;
}
%>