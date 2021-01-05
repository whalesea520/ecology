
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page import="java.io.File" %>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageManager" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
//把权限判断放到最上面，不影响下面的初始化对象、参数
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
}
%>
<%@ page import="weaver.file.FileUpload,java.io.File"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="newsTemplate" class="weaver.page.maint.layout.NewsTemplate" scope="page"/>
<%
FileUpload fu = new FileUpload(request, false, "page/news");
String newstempPath = pc.getConfig().getString("news.path");
String operation = Util.null2String(fu.getParameter("operation"));
String newstempid = Util.null2String(fu.getParameter("newstempid"));
String newstemptype = Util.null2String(fu.getParameter("newstemptype"));
String pageUrl = Util.null2String(fu.getParameter("pageUrl"));
if("edit".equals(pageUrl)){
	pageUrl = "/page/maint/template/news/NewsTemplateEdit.jsp?closeDialog=close";
}else if("list".equals(pageUrl)){
	pageUrl = "/page/maint/template/news/NewsTemplateList.jsp";
}
if("save".equals(operation)){
	String url = newsTemplate.saveTemplate(fu);
	//baseBean.writeLog(url+"==="+request.getProtocol()+"://"+request.getHeader("Host")+":"+request.getServerPort());
	response.sendRedirect(pageUrl);
}else if("saveNew".equals(operation)){
	String newstempname = Util.null2String(fu.getParameter("newstempname"));
	String newstempdesc = Util.null2String(fu.getParameter("newstempdesc"));
	rs.executeSql("select templatename,templatedesc,templatedir,templatetype from pagenewstemplate where id="+newstempid);
	long temp = System.currentTimeMillis();		
	if(rs.next()){
		String templatedir = rs.getString("templatedir");
		File src = new File(pm.getRealPath(newstempPath+templatedir+"index.htm"));
		File target = new File(pm.getRealPath(newstempPath+temp+"/index.htm"));
		FileUtils.copyFile(src,target);
		//baseBean.writeLog(templatedir+" src target "+temp);
	}
	newstempdesc = "".equals(newstempdesc)?newstempname:newstempdesc;
	rs.executeSql("insert into pagenewstemplate (templatename,templatedesc,templatetype,templatedir,zipname,allowArea) "
	+"values ('"+newstempname+"','"+newstempdesc+"','"+newstemptype+"','"+temp+"/"+"','0','')");
	out.print("OK");
	response.sendRedirect(pageUrl);
}else if("delTemplate".equals(operation)){
	rs.executeSql("select templatedir from pagenewstemplate where id="+newstempid);
	if(rs.next()){
		String templatedir = rs.getString("templatedir");
		baseBean.writeLog(templatedir);
		File f = new File(pm.getRealPath(newstempPath+templatedir));
		//baseBean.writeLog(newstempPath+templatedir+" del");
		if(f.exists()) f.delete();	
	}
	rs.executeSql("delete from pagenewstemplate where id="+newstempid);
	out.print("OK");
	response.sendRedirect(pageUrl);
}
%>