<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="java.util.*,weaver.wechat.util.*,java.net.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%
String nid=request.getParameter("nid");
String userid=request.getParameter("uid");
String dsp=request.getParameter("dsp");
String content="";
String title="";
if(!"".equals(nid)&&!"".equals(userid)&&!"".equals(dsp)){
	rs.execute("select * from wechat_news_material where newsid="+nid+" and userid="+userid+" and dsporder="+dsp);
	if(rs.next()){
		title=rs.getString("title");
		content=rs.getString("content");
	}else{
		response.sendRedirect("result.jsp?type=news&msg=404");
		return;
	}
}else{
	response.sendRedirect("result.jsp?type=news&msg=405");
	return;
}

 

 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	img {     display: block;     height: auto;     width: 100%; }

#activity-name
{
	line-height: 24px;
	font-weight: 700;
	font-size: 20px;
	word-wrap: break-word;
	-webkit-hyphens: auto;
	-ms-hyphens: auto;
	hyphens: auto;
	padding-bottom: 10px;
	margin-bottom: 5px;
	border-bottom: 1px solid #e7e7eb;
}

</style>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title></title>
<link rel="stylesheet" href="css/jquery.mobile-1.1.1.min_wev8.css" />
<link rel="stylesheet" href="css/my_wev8.css" />
<style>/* App custom styles */</style>
<script	src="js/jquery-1.7.1.min_wev8.js"></script>
<script	src="js/custom-jqm-mobileinit_wev8.js"></script>
<script	src="js/jquery.mobile-1.1.1.min_wev8.js"></script>
<script src="js/my_wev8.js"></script>
</head>	
	<body>
		<div data-role="content">
			<h2 id="activity-name" >
                <%=title%>
            </h2>
			<br>
			<div data-controltype="textblock">
			<%=content%>
			</div>
	   </div>
    </body>
</html>