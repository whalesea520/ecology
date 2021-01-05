<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page import="weaver.docs.docs.*,java.io.*,java.net.URLEncoder,weaver.general.GCONST" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocSeccategoryUtil" class="weaver.docs.docs.DocSeccategoryUtil" scope="page" />
<%

	if (!HrmUserVarify.checkUserRight("DocSecCategoryAdd:add",user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
boolean include=false;
String ids = Util.null2String(request.getParameter("ids"));
String isinclude = Util.null2String(request.getParameter("isinclude"));
if(isinclude.equals("1")){
	include=true;
}
String filename=System.currentTimeMillis()+".xls";
String temppath="/docs"+File.separatorChar+"category"+File.separatorChar+"tempfile"+File.separatorChar+filename;
String path=GCONST.getRootPath()+"docs"+File.separatorChar+"category"+File.separatorChar+"tempfile"+File.separatorChar+filename;
DocSeccategoryUtil.seccategoryExport(ids,include,path);
response.sendRedirect(temppath);	

%>
