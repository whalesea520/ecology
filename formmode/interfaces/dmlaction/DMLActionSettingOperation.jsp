
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,weaver.conn.*"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="DmlActionInfoService" class="weaver.formmode.interfaces.dmlaction.services.DmlActionInfoService" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	
	return;
}
int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
//操作类型
String operate = Util.null2String(request.getParameter("operate"));
//动作名称
String actionname = Util.null2String(request.getParameter("actionname"));
//流程名称
int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);

//数据源表
String maintablename = Util.null2String(request.getParameter("maintablename"));

//执行顺序
int dmlorder = Util.getIntValue(Util.null2String(request.getParameter("dmlorder")),0);
//节点id
int expandid = Util.getIntValue(Util.null2String(request.getParameter("expandid")),0);

//数据源id
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
//操作类型
String dmltype = Util.null2String(request.getParameter("dmltype"));

int isResetRight = Util.getIntValue(Util.null2String(request.getParameter("isResetRight")),0);//是否重构数据权限 
int targetmodeid = Util.getIntValue(Util.null2String(request.getParameter("targetmodeid")),0);//插入数据目标模块 

if(!datasourceid.equals("")){
	isResetRight = 0;
	targetmodeid = 0;
}else{
	if(dmltype.equals("delete")){
		isResetRight = 0;
		targetmodeid = 0;
	}else if(dmltype.equals("update")){
		targetmodeid = 0;
	}
}

int actionsqlsetid = Util.getIntValue(Util.null2String(request.getParameter("actionsqlsetid")),0);
//DML主表formid
int dmlformid = Util.getIntValue(Util.null2String(request.getParameter("dmlformid")),0);
//DML主表form名称
String dmlformname = Util.null2String(request.getParameter("dmlformname"));
//DML主表form是否为明细
String dmlisdetail = Util.null2String(request.getParameter("dmlisdetail"));
//DML主表名
String dmltablename = Util.null2String(request.getParameter("dmltablename"));
//DML主表别名
String dmltablebyname = Util.null2String(request.getParameter("dmltablebyname"));

//DML主表字段对应关系
String [] dmlfieldnames = request.getParameterValues("dmlfieldname");
//DML主表条件对应关系
String [] wherefieldnames = request.getParameterValues("wherefieldname");
//自定义主表条件
String dmlmainwhere = Util.null2String(request.getParameter("dmlmainwhere"));
//自定义主表DML语句类型
String dmlmainsqltype = Util.null2String(request.getParameter("dmlmainsqltype"));
//自定义主表DML语句
String dmlmainsql = Util.null2String(request.getParameter("dmlmainsql"));


if("add".equals(operate))
{
	actionid = DmlActionInfoService.saveDMLActionSet(actionname,dmlorder,modeid,expandid,datasourceid,dmltype,
			maintablename,dmlformid,dmlformname,dmlisdetail,dmltablename,dmltablebyname,dmlfieldnames,wherefieldnames,dmlmainwhere,dmlmainsqltype,dmlmainsql,isResetRight,targetmodeid);
	out.println("<script language=javascript>parentWin = parent.getParentWindow(window);parentWin.closeDialog();</script>");
	//out.println("<script language=javascript>try{window.parent.opener.location.reload();}catch(e){}window.parent.close();try{dialogArguments.reloadDMLAtion();}catch(e){}</script>");
	//response.sendRedirect("DMLActionSettingView.jsp?actionid="+actionid);
}
else if("edit".equals(operate))
{
	DmlActionInfoService.editDMLActionSet(actionid,actionname,dmlorder,modeid,expandid,
			datasourceid,dmltype,maintablename,actionsqlsetid,dmlformid,dmlformname,dmlisdetail,dmltablename,
			dmltablebyname,dmlfieldnames,wherefieldnames,dmlmainwhere,dmlmainsqltype,dmlmainsql,isResetRight,targetmodeid);
	out.println("<script language=javascript>parentWin = parent.getParentWindow(window);parentWin.closeDialog();</script>");
	//out.println("<script language=javascript>try{window.parent.opener.location.reload();}catch(e){}window.parent.close();try{dialogArguments.reloadDMLAtion();}catch(e){}</script>");
	//response.sendRedirect("DMLActionSettingView.jsp?actionid="+actionid);
}
else if("delete".equals(operate))
{
	DmlActionInfoService.deleteDMLActionSet(actionid,actionsqlsetid,modeid,expandid);
	out.println("<script language=javascript>parentWin = parent.getParentWindow(window);parentWin.closeDialog();</script>");
	//out.println("<script language=javascript>try{window.parent.opener.location.reload();}catch(e){}window.parent.close();try{dialogArguments.reloadDMLAtion();}catch(e){}</script>");
}
%>
