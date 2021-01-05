
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CapitalGroupComInfo" class="weaver.cpt.maintenance.CapitalGroupComInfo" scope="page" />
<%


char separator = Util.getSeparator() ;

String operation = Util.null2String(request.getParameter("operation"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
String parentid = Util.null2String(request.getParameter("parentid"));

if (parentid.equals("")){
	parentid = "0";
}

if (operation.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("CptCapitalGroupAdd:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	   }
	RecordSet.executeProc("CptCapitalGroup_Insert",name+separator+description+separator+parentid);

	CapitalGroupComInfo.removeCapitalGroupCache();
}
else if (operation.equals("edit"))
{
	
	if(!HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	   }
	RecordSet.executeProc("CptCapitalGroup_Update",id+separator+name+separator+description+separator+parentid);

	CapitalGroupComInfo.removeCapitalGroupCache();
}
else if (operation.equals("delete"))
{
	
	if(!HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Delete", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	   }
	RecordSet.executeProc("CptCapitalGroup_Delete",id);
	RecordSet.next();
int returnval = RecordSet.getInt(1);
	if(returnval==-1){
		response.sendRedirect("CptCapitalGroupEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

	CapitalGroupComInfo.removeCapitalGroupCache();
}

response.sendRedirect("/cpt/maintenance/CptCapitalGroup.jsp?parentid="+parentid);
%>