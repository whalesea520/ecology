
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util"%>  
<%@ page import="weaver.conn.ConnStatement"%>
<jsp:useBean id="spop" class="weaver.splitepage.operate.SpopForDoc" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="docRecycleManager" class="weaver.docs.docs.DocRecycleManager" scope="page"/>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%@ page import="weaver.hrm.*" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
rs.executeSql("select propvalue from   doc_prop  where propkey='docsrecycle'");
rs.next();
int docsrecycleIsOpen=Util.getIntValue(rs.getString("propvalue"),0);
if(docsrecycleIsOpen!=1){
	response.sendRedirect("/docs/docs/DocRecycleRemind.jsp");//没开启回收站
	return;
}
String operation =  Util.null2String(request.getParameter("operation"));
String docid =  Util.null2String(request.getParameter("docid"));
if(docid.equals("")){
	return;
}
String docsubject="";
int docdeleteuserid=0;
String secid="";

String strSql="select docsubject,docdeleteuserid from recycle_docdetail where id="+docid;
rs.executeSql(strSql);
if (rs.next()){
	docsubject = Util.null2String(rs.getString("docsubject"));
	docdeleteuserid = rs.getInt("docdeleteuserid");
	secid = Util.null2String(rs.getString("seccategory"));
}else{
	return;//没有文档  结束
}
//求得权限

boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();

if(!user.getLoginid().equalsIgnoreCase("sysadmin")&&docdeleteuserid!=user.getUID()){
//检查权限//假设包含“回收站文档管理”权限的角色为“文档监控员”，有角色成员A。如果知识管理模块未启用管理分权，则只要A的“成员级别”大于或等于“功能权限”级别，就能够进入回收站文档管理界面管理所有目录下的已逻辑删除的文档。
	if(!HrmUserVarify.checkUserRight("DocumentRecycle:All", user)){
			response.sendRedirect("/notice/noright.jsp");	//没权限的时候跳转无权限页面
			return;
	}else if(isUseDocManageDetach){
		String subcompanyId=SecCategoryComInfo.getSubcompanyIdFQ(secid);
		int  operatelevel= Util.getIntValue(CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocumentRecycle:All",Util.getIntValue(subcompanyId,0))+"",0);
		if(operatelevel<1){
			response.sendRedirect("/notice/noright.jsp");	//没权限的时候跳转无权限页面	//机构权限的“操作级别”为“禁止”或“只读”时，意为对属于所选机构的文档目录下的回收站文档无操作权限
		}	
	}
}
//userType,userId,userSeclevel
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
String userInfo = user.getLogintype()+"_"+user.getUID()+"_"+user.getSeclevel()+"_"+userType+"_"+userdepartment+"_"+usersubcomany;

//如果没有维护权限或者不是删除或者恢复删除人是自己的文档  结束

if ("delete".equals(operation)){
	docRecycleManager.deleteDocFromRecycle(user.getUID(), user.getLogintype(), Util.getIntValue(docid), request.getRemoteAddr());
}else if("recover".equals(operation)){
	docRecycleManager.recoverDocFromRecycle(user.getUID(), user.getLogintype(), Util.getIntValue(docid), request.getRemoteAddr());
}    
    %>

