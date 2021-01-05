
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
String sql = "";
int photoId = Util.getIntValue(request.getParameter("id"));
int reviewId = Util.getIntValue(request.getParameter("reviewId"));
int userId = user.getUID();
String postdate = TimeUtil.getCurrentTimeString();
String content = "";
String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("add")){
	content = Util.null2String(request.getParameter("reviewContent"));
	rs.executeSql("INSERT INTO AlbumPhotoReview (photoId,userId,postdate,content) VALUES ("+photoId+","+userId+",'"+postdate+"','"+content+"')");
}else if(operation.equals("delete")){
	rs.executeSql("DELETE FROM AlbumPhotoReview WHERE id="+reviewId+"");
}else if(operation.equals("update")){
	content = Util.null2String(request.getParameter("reviewContentUpdate"));
	rs.executeSql("UPDATE AlbumPhotoReview SET content='"+content+"' WHERE id="+reviewId+"");
}

rs.executeSql("SELECT * FROM AlbumPhotoReview WHERE photoId="+photoId+" ORDER BY postdate DESC");
while(rs.next()){
	out.print("<table class='ListStyle' style='width:100%;border-collapse:collapse'><tr class='DataLight'><td width='*'>");
	//out.print("<input type='checkbox' name='reviewId' value='"+rs.getString("id")+"' style='width:20px'>");
	//out.print("<img src='/images/treeimages/user16_wev8.gif'> ");
	out.print("<a href='/hrm/resource/HrmResource.jsp?id="+rs.getString("userId")+"' target='_blank'>"+hrm.getResourcename(rs.getString("userId"))+"</a>&nbsp;:&nbsp; ");
	out.print("<span id='reviewcontent_"+rs.getString("id")+"'>"+Util.toHtml(rs.getString("content"))+"</span>&nbsp;&nbsp;");
	out.print("<span style='font:12px MS Shell Dlg,Arail'>"+"("+rs.getString("postdate")+")"+"</span>");
	out.print("</td><td width='150' style='text-align:right;'>");

	if(HrmUserVarify.checkUserRight("Album:Maint",user) || userId==rs.getInt("userId")){
		out.print("<span id='linkEdit"+rs.getString("id")+"' class='e8_btn_top' reviewId='"+rs.getString("id")+"' onclick='javascript:editReview()'>"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"</span>");
		out.print("&nbsp;<span id='linkSave"+rs.getString("id")+"' class='e8_btn_top' style='display:none' reviewId='"+rs.getString("id")+"' onclick='javascript:saveReview()'>"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+"</span>");
		out.print("&nbsp;<span id='linkCancel"+rs.getString("id")+"' class='e8_btn_top' style='display:none' reviewId='"+rs.getString("id")+"' onclick='javascript:cancelReview()'>"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+"</span>");
		out.print("&nbsp;<span id='linkDelete"+rs.getString("id")+"' class='e8_btn_top' reviewId='"+rs.getString("id")+"' onclick='javascript:deleteReview()'>"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"</span>");
	}
	out.print("</td></tr></table>");
}
%>