<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
User user=HrmUserVarify.getUser(request, response);


if(user == null){
	out.print("{}");
}else{
	String CurrentDate=TimeUtil.getCurrentDateString();
	String CurrentTime=TimeUtil.getOnlyCurrentTimeString();
	
	String src=Util.null2String(request.getParameter("src"));
	String type=Util.null2String(request.getParameter("type"));
	int photoId=Util.getIntValue(request.getParameter("photoid"));
	JSONObject jsonObject=new JSONObject();


String sql = "";
int userId = user.getUID();
String postdate = TimeUtil.getCurrentTimeString();
StringBuilder content = new StringBuilder(" ");


rs.executeSql("SELECT * FROM AlbumPhotoReview WHERE photoId="+photoId+" ORDER BY postdate DESC");
while(rs.next()){
	content.append("<table class='ListStyle' style='width:100%;border-collapse:collapse'><tr class='DataLight'><td width='*'>");
	content.append("<a href='/hrm/resource/HrmResource.jsp?id="+rs.getString("userId")+"' target='_blank'>"+hrm.getResourcename(rs.getString("userId"))+"</a>&nbsp;:&nbsp; ");
	content.append("<span id='reviewcontent_"+rs.getString("id")+"'>"+Util.toHtml(rs.getString("content"))+"</span>&nbsp;&nbsp;");
	content.append("<span style='font:12px MS Shell Dlg,Arail'>"+"("+rs.getString("postdate")+")"+"</span>");
	content.append("</td><td width='150' style='text-align:right;'>");

	if(HrmUserVarify.checkUserRight("Album:Maint",user) || userId==rs.getInt("userId")){
		content.append("<span id='linkEdit"+rs.getString("id")+"' class='e8_btn_top' reviewId='"+rs.getString("id")+"' onclick='javascript:editReview()'>"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"</span>");
		content.append("&nbsp;<span id='linkSave"+rs.getString("id")+"' class='e8_btn_top' style='display:none' reviewId='"+rs.getString("id")+"' onclick='javascript:saveReview()'>"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+"</span>");
		content.append("&nbsp;<span id='linkCancel"+rs.getString("id")+"' class='e8_btn_top' style='display:none' reviewId='"+rs.getString("id")+"' onclick='javascript:cancelReview()'>"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+"</span>");
		content.append("&nbsp;<span id='linkDelete"+rs.getString("id")+"' class='e8_btn_top' reviewId='"+rs.getString("id")+"' onclick='javascript:deleteReview()'>"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"</span>");
	}
	content.append("</td></tr></table>");
}



sql="select * FROM AlbumPhotos where id="+photoId;
rs.executeSql(sql);
String photo_postdate="";
String photo_title="";
String photo_desc="";
String photo_uploader="";

if(rs.next()){
	photo_postdate=Util.null2String(rs.getString("postdate"));
	photo_title=Util.null2String(rs.getString("photoname"));
	photo_desc=Util.null2String(rs.getString("photoDescription"));
	photo_uploader=hrm.getResourcename( Util.null2String(rs.getString("userid")));
}

jsonObject.put("reviewInfo", content.toString());
jsonObject.put("photo_postdate", photo_postdate);
jsonObject.put("photo_title", photo_title);
jsonObject.put("photo_desc", photo_desc);
jsonObject.put("photo_uploader", photo_uploader);

out.print(jsonObject.toString());

}
%>