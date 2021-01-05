<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,java.util.*,weaver.docs.docs.CustomFieldManager,weaver.interfaces.workflow.browser.*,weaver.conn.*" %>
<%@ page import="weaver.hrm.util.html.*,weaver.hrm.*,weaver.hrm.settings.*,weaver.systeminfo.*"%>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder,org.json.JSONObject"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%
	int isIncludeToptitle = 0;
	User user = HrmUserVarify.getUser (request , response) ;
	String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage());
	
	String from = Util.null2String(request.getParameter("from"));
	String department = Util.null2String(request.getParameter("department"));
	
	int subcompanyid=-1;
	if(!DepartmentComInfo.getSubcompanyid1(department).equals(""))
	    subcompanyid=Integer.parseInt(DepartmentComInfo.getSubcompanyid1(department));
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	
	int operatelevel=0;
	if(detachable==1){
	    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceAdd:Add",subcompanyid);
	}else{
	    if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add", user))
	        operatelevel=2;
	}
	
	
%>



<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmValidate.hasEmessage(user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(130343,user.getLanguage())+",javascript:sendEmessage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClickRight(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",/hrm/search/HrmResourceSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:sendmail(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(from.equals("hrmorg")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:onRefresh(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",/hrm/userdefine/HrmUserDefine.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:onNewResource("+department+"),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}
//if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
if(HrmUserVarify.checkUserRight("HrmResourceInfo:Import", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"-Excel,javascript:exportExcel(),_self} ";
RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(130759,user.getLanguage())+",javascript:addToGroup(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
