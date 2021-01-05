
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.cowork.po.CoworkBaseSetComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.blog.BlogShareManager"%>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DateFormat"%>
<%
    String userid=""+user.getUID();
    FileUpload fu = new FileUpload(request);
	String itemstate=Util.null2String(fu.getParameter("itemstate"));
	String infostate=Util.null2String(fu.getParameter("infostate"));
	String dealchangeminute=Util.null2String(fu.getParameter("dealchangeminute"));
	String coworkstate=Util.null2String(fu.getParameter("coworkstate"));
    
	Date date=new Date();
    DateFormat format=new SimpleDateFormat("yyyy-MM-dd");
    String time=format.format(date);
    DateFormat format1=new SimpleDateFormat("HH:mm:ss");
    String time1=format1.format(date);
    
	
    //协作附件目录设定入库操作
	RecordSet.executeSql("delete from cowork_base_set");
	RecordSet.executeSql("insert into cowork_base_set(itemstate,infostate,userid,createdate,createtime,dealchangeminute,coworkstate) values('"+itemstate+"','"+infostate+"','"+userid+"','"+time+"','"+time1+"','"+dealchangeminute+"','"+coworkstate+"')");
	
	CoworkBaseSetComInfo coworkBaseSetComInfo = new CoworkBaseSetComInfo();
	coworkBaseSetComInfo.removeCache();
	
	response.sendRedirect("CoworkBaseSetting.jsp");
%>