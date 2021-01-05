<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<!DOCTYPE HTML>
<html>
	<head>
		<style type="text/css">
.boxhead {
	height: 60px;
	overflow: hidden;
	z-index: 3;
	border-bottom: 1px solid #DADADA;
}
.e8_tablogo {
	background-image: url("/js/tabs/images/nav/default_wev8.png");
	background-repeat: no-repeat;
	background-position: 50% 50%;
	width: 43px;
	height: 60px;
	line-height: 60px;
	margin-left: 12px;
	float: left;
}
.e8_navtab {
	height: 20px;
	line-height: 38px;
	margin-left: 25px;
	padding-top: 10px;
	font-size: 16px;
	font-weight: normal;
}
.topoperator {
    float: right;
    margin-top: 22px;
    font-size: 14px;
    text-align: center;
    margin-right: 38px;
    color: #fff;
    background-color: #30b5ff;
    padding-left: 10px !important;
    padding-right: 10px !important;
    height: 23px;
    line-height: 22px;
    border: 1px solid #30b5ff;
    cursor: pointer;
}
.topoperator:hover {
  background: #6abc50!important;
}
</style>

	</head>
	<%
		String docId = Util.null2String(request.getParameter("docId"));
	    int versionId = Util.getIntValue(request.getParameter("versionId"),0);
	 	String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
	    String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
		int imageFileId = Util.getIntValue(request.getParameter("imageFileId"),0);//附件id
		String imageFileName = Util.null2String(request.getParameter("imageFileName"));//附件名称
		
	%>
	<body>
			<iframe style="border:none;" frameborder="0" width="100%"  height="100%" src="/docs/docs/DocDspExt.jsp?id=<%= docId %>&meegingid=-1&votingId=0&versionId=<%= versionId %>&imagefileId=<%= imageFileId %>&from=docreply&userCategory=0&isFromAccessory=true"></iframe>
	</body>
</html>