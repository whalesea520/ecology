<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@page import="weaver.general.BaseBean"%><%@ page import="weaver.general.Util" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%><%
String result = "";
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	result = "";
}else{
	boolean effect = HrmUserVarify.checkUserRight("BudgetDraftBatchEffect:effect", user);//预算草稿批量生效
	boolean imp = HrmUserVarify.checkUserRight("BudgetDraftBatchImport:imp", user);//预算草稿批量导入
	if(!effect && !imp){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
	String zb = Util.null2String(request.getParameter("zb")).trim();
	request.getSession().setAttribute("ExpFnaBatchExcel1.jsp_zb:"+_guid1, zb);
	String fb = Util.null2String(request.getParameter("fb")).trim();
	request.getSession().setAttribute("ExpFnaBatchExcel1.jsp_fb:"+_guid1, fb);
	String bm = Util.null2String(request.getParameter("bm")).trim();
	request.getSession().setAttribute("ExpFnaBatchExcel1.jsp_bm:"+_guid1, bm);
	String ry = Util.null2String(request.getParameter("ry")).trim();
	request.getSession().setAttribute("ExpFnaBatchExcel1.jsp_ry:"+_guid1, ry);
	String fccIds = Util.null2String(request.getParameter("fccIds")).trim();
	request.getSession().setAttribute("ExpFnaBatchExcel1.jsp_fccIds:"+_guid1, fccIds);
	String subjectId = Util.null2String(request.getParameter("subjectId")).trim();
	request.getSession().setAttribute("ExpFnaBatchExcel1.jsp_subjectId:"+_guid1, subjectId);
	int keyWord = Util.getIntValue(request.getParameter("keyWord"), -1);//承担主体重复验证字段
	request.getSession().setAttribute("ExpFnaBatchExcel1.jsp_keyWord:"+_guid1, String.valueOf(keyWord));
	int keyWord2 = Util.getIntValue(request.getParameter("keyWord2"), -1);//科目重复验证字段
	request.getSession().setAttribute("ExpFnaBatchExcel1.jsp_keyWord2:"+_guid1, String.valueOf(keyWord2));
}
%><%=result %>