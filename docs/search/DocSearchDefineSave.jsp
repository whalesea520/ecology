<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="DocSearchDefineManager" class="weaver.docs.search.DocSearchDefineManager" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String savetype=Util.null2String(request.getParameter("savetype"));
String operation=Util.null2String(request.getParameter("operation"));
int userid=user.getUID();
String subjectdef=Util.null2String(request.getParameter("subject")); if(subjectdef.equals("")) subjectdef="1"; 
String contentdef=Util.null2String(request.getParameter("content")); if(contentdef.equals("")) contentdef="1"; 
String replydef=Util.null2String(request.getParameter("reply")); if(replydef.equals("")) replydef="1"; 
String dociddef=Util.null2String(request.getParameter("docid")); if(dociddef.equals("")) dociddef="1"; 
String createrdef=Util.null2String(request.getParameter("creater")); if(createrdef.equals("")) createrdef="1"; 
String categorydef=Util.null2String(request.getParameter("category")); if(categorydef.equals("")) categorydef="1"; 
String doctypedef=Util.null2String(request.getParameter("doctype")); if(doctypedef.equals("")) doctypedef="1"; 
String departmentdef=Util.null2String(request.getParameter("department")); if(departmentdef.equals("")) departmentdef="1"; 
String languragedef=Util.null2String(request.getParameter("langurage")); if(languragedef.equals("")) languragedef="1"; 
String hrmresdef=Util.null2String(request.getParameter("hrm")); if(hrmresdef.equals("")) hrmresdef="1"; 
String itemdef=Util.null2String(request.getParameter("item")); if(itemdef.equals("")) itemdef="1"; 
String itemmaincategorydef=Util.null2String(request.getParameter("itemcategory")); if(itemmaincategorydef.equals("")) itemmaincategorydef="1"; 
String crmdef=Util.null2String(request.getParameter("crm")); if(crmdef.equals("")) crmdef="1"; 
String projectdef=Util.null2String(request.getParameter("project")); if(projectdef.equals("")) projectdef="1"; 
String financedef=Util.null2String(request.getParameter("finance")); if(financedef.equals("")) financedef="1"; 
String financerefdef1=Util.null2String(request.getParameter("financeref1")); if(financerefdef1.equals("")) financerefdef1="1"; 
String financerefdef2=Util.null2String(request.getParameter("financeref2")); if(financerefdef2.equals("")) financerefdef2="1"; 
String publishdef=Util.null2String(request.getParameter("publish")); if(publishdef.equals("")) publishdef="1"; 
String statusdef=Util.null2String(request.getParameter("status")); if(statusdef.equals("")) statusdef="1"; 
//String sharedef=Util.null2String(request.getParameter("share")); if(sharedef.equals("")) sharedef="1"; 
//String secleveldef=Util.null2String(request.getParameter("seclevel")); if(secleveldef.equals("")) secleveldef="1"; 
String keyworddef=Util.null2String(request.getParameter("keyword"));if(keyworddef.equals("")) keyworddef="1";
String ownerdef=Util.null2String(request.getParameter("owner"));if(ownerdef.equals(""))
ownerdef="1";

if (savetype.equals("default")){
	DocSearchDefineManager.setUserid(userid);
	DocSearchDefineManager.deleteSearchDefine();
}

if(savetype.equals("save")){
	DocSearchDefineManager.setUserid(userid); 
  	DocSearchDefineManager.setSubjectdef(subjectdef);
  	DocSearchDefineManager.setContentdef(contentdef);
  	DocSearchDefineManager.setReplydef(replydef);
  	DocSearchDefineManager.setDociddef(dociddef);
  	DocSearchDefineManager.setCreaterdef(createrdef);
  	DocSearchDefineManager.setCategorydef(categorydef);
  	DocSearchDefineManager.setDoctypedef(doctypedef);
  	DocSearchDefineManager.setDepartmentdef(departmentdef);
  	DocSearchDefineManager.setLanguragedef(languragedef);
  	DocSearchDefineManager.setHrmresdef(hrmresdef);
  	DocSearchDefineManager.setItemdef(itemdef);
  	DocSearchDefineManager.setItemmaincategorydef(itemmaincategorydef);
  	DocSearchDefineManager.setCrmdef(crmdef);
  	DocSearchDefineManager.setProjectdef(projectdef);
  	DocSearchDefineManager.setFinancedef(financedef);
  	DocSearchDefineManager.setFinancerefdef1(financerefdef1);
  	DocSearchDefineManager.setFinancerefdef2(financerefdef2);
  	DocSearchDefineManager.setPublishdef(publishdef);
  	DocSearchDefineManager.setStatusdef(statusdef);
  	//DocSearchDefineManager.setSharedef(sharedef);
  	//DocSearchDefineManager.setSecleveldef(secleveldef);
	DocSearchDefineManager.setKeyworddef(keyworddef);
    DocSearchDefineManager.setOwnerdef(ownerdef);
	if(operation.equals("insert"))   DocSearchDefineManager.insertSearchDefine();
	if(operation.equals("update"))   DocSearchDefineManager.updateSearchDefine();
}
response.sendRedirect("DocSearch.jsp");
%>
