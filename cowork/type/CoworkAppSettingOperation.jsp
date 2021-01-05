
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.cowork.po.CoworkAppComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.blog.BlogShareManager"%>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    String userid=""+user.getUID();
    FileUpload fu = new FileUpload(request);
	String operation=Util.null2String(fu.getParameter("operation"));
	String pathcategory=Util.null2String(fu.getParameter("pathcategory"));
	String maincategory=Util.null2String(fu.getParameter("maincategory"));
	String subcategory=Util.null2String(fu.getParameter("subcategory"));
	String seccategory=Util.null2String(fu.getParameter("seccategory"));
	
	if(operation.equals("editApp")){ //保存微博应用选项 
		String[] appids=fu.getParameterValues("appid"); 
		
		CoworkAppComInfo coworkAppComInfo = new CoworkAppComInfo();
		
		String isActives[]=new String[appids.length];
		for(int i=0;i<appids.length;i++){
			String isActive=fu.getParameter("isActive_"+appids[i]);
			isActive=isActive.equals("1")?"1":"0";
			String sql="update cowork_app set isActive="+isActive+" where id="+appids[i];
			RecordSet.execute(sql);
			
			coworkAppComInfo.updateCache(appids[i]);
		}
		
    //协作附件目录设定入库操作
	RecordSet.executeSql("delete from CoworkAccessory");
	RecordSet.executeSql("insert into CoworkAccessory values('"+pathcategory+"','"+maincategory+"','"+subcategory+"','"+seccategory+"')"); 
	
	response.sendRedirect("CoworkAppSetting.jsp");
    }
%>