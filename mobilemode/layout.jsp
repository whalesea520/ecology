<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("服务器端重置了登录信息，请重新登录");
	return;
}
int appid = NumberHelper.getIntegerValue(request.getParameter("appid"), -1);
int modelid = NumberHelper.getIntegerValue(request.getParameter("modelid"), -1);
int uitype = NumberHelper.getIntegerValue(request.getParameter("uitype"), -1);//布局类型：0新建   1显示   2编辑

//表单建模判断关联授权
String authorizeOpttype  = "";
String authorizeLayoutid  = "";
String authorizeLayoutlevel  = "";

int formid = -1;
rs.executeSql("select formid from mobileAppModelInfo where appid="+appid+" and modelid="+modelid);
if(rs.next()){
	formid = rs.getInt(1);
}
boolean isVirtualForm=VirtualFormHandler.isVirtualForm(formid);
int type = uitype == 0 ? 1 : (uitype == 1 ? 0 : uitype);
int billid = NumberHelper.getIntegerValue(request.getParameter("billid"), 0);

resolveFormMode.setRequest(request);
resolveFormMode.setUser(user);
resolveFormMode.setIscreate(type);
resolveFormMode.setType(type);
resolveFormMode.setVirtualForm(isVirtualForm);
resolveFormMode.setFormId(formid);
resolveFormMode.setModeId(modelid);
resolveFormMode.setBillid(billid);

//获取布局ID
int layoutid = 0;
if(isVirtualForm){
	layoutid = resolveFormMode.getVirLayoutIdOfModeright();
}else{
	layoutid = resolveFormMode.getLayoutIdOfModeright();
}
boolean isDefault = true;
//判断表单建模布局是否是默认布局，如果是则用移动建模现有的默认布局，避免报找不到布局错误 xxb qc:255541
if(layoutid > 0){
	rs.executeSql("select isdefault from modehtmllayout where id="+layoutid);
	if(rs.next()){
		if(rs.getInt("isdefault") != 1){
			isDefault = false;
		}
	}
}
AppHomepage appHomepage = MobileAppHomepageManager.getInstance().getAppHomepage(appid, modelid, uitype, layoutid, isDefault);

String url = "";
if(appHomepage != null){	//优先使用自定义页面布局
	if(uitype != -1){
		url = "/mobilemode/appHomepageExpandView.jsp?appHomepageId="+appHomepage.getId();
	}else{
		url = "/mobilemode/appHomepageView.jsp?appHomepageId="+appHomepage.getId();
	}
	
}else if(isDefault){
	AppFormUI appFormUIView = MobileAppUIManager.getInstance().getFormUI(appid, modelid, uitype);
	if(appFormUIView != null){
		url = "/mobilemode/gmuview.jsp?uiid=" + appFormUIView.getId();
	}else{
		url = "/mobilemode/message.jsp?errorCode=1387&layoutid="+layoutid+"&isdefault="+(isDefault ? 1 : 0);
	}
}else{
	url = "/mobilemode/message.jsp?errorCode=1387&layoutid="+layoutid+"&isdefault="+(isDefault ? 1 : 0);
}

request.getRequestDispatcher(url).forward(request, response);
%>
