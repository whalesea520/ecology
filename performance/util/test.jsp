<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="application" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int create = Util.getIntValue(request.getParameter("create"),0);
if(create==1){
	application.setAttribute("tag","test111");
	application.removeAttribute("");
}
String tag = (String)application.getAttribute("tag");

%>
<HTML>
	<HEAD>
		<title>目标绩效提醒</title>
		<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<script language="javascript" src="../js/jquery-1.8.3.min.js"></script>
		<script language="javascript" src="../js/highcharts.src.js"></script>
		<style type="text/css">
			body{margin: 0px;padding:0px;}
			.tab1{width: 80px;line-height:26px;text-align:center;float: left;cursor: pointer;border-bottom:1px #fff solid;font-size: 12px;}
			.tab1_click{border-bottom-color: #0080FF;}
			
			.tab2{width: auto;padding-left:2px;padding-right:2px;line-height:22px;text-align:center;float: left;cursor: pointer;border-bottom:1px #fff solid;font-size: 12px;}
			.tab2_click{font-weight: bold;}
		
			.list{width: 100%;}
			.list td{line-height: 22px;}
			.list td a,.list td a.link{color: #333333 !important;}
		</style>
	</HEAD>
	<BODY>
		<div id="showreport" style="width: 100%;height: 300px;">
			<%=tag %>
			</div>
				<script type="text/javascript">

    

		</script>
	</BODY>
</HTML>