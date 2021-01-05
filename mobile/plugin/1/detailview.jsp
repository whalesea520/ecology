
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String sessionkey = Util.null2String((String)request.getParameter("sessionkey"));
if("".equals(sessionkey)){
	return;
}
String workflowId = Util.null2String(request.getParameter("workflowId"));

//2015/12/07 获取次账号信息 start
//int userId = Util.getIntValue(request.getParameter("userid"), 0);

String f_weaver_belongto_userid = Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
String f_weaver_belongto_usertype = Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

if(user == null)  return ;
//2015/12/07 获取次账号信息 end

String content = "";
Map mapWfContents = (Map)StaticObj.getInstance().getObject("SESSION_VIEW_CONTENT_NEWS_OR_WKFLW");
if(mapWfContents != null && mapWfContents.size() != 0){
	String disContent = (String)request.getParameter("content");
	//String wfContentKey = sessionkey + "_"+ workflowId + "_"+ userId + "_" + disContent;
    String wfContentKey = sessionkey + "_"+ workflowId + "_"+ user.getUID() + "_" + disContent;
	content = (String)mapWfContents.get(wfContentKey);
}
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title></title>
	
<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<style type="text/css">
	/* 顶部退回导航栏Start */
	.headNavigation {
		width:100%;
		height:43px;border-bottom:1px solid #838A9A;margin:0;
		background:#AAAFBC;
		background: -moz-linear-gradient(0, #F4F5F7, #AAAFBC);
		background:-webkit-gradient(linear, 0 0, 0 100%, from(#F4F5F7), to(#AAAFBC));
		font-size:12px;
		color:#1D3A66;
	}
	.back {
		float:left;
		margin-left:5px;
		background:url(/images/back_wev8.png) 0 0 no-repeat;
		cursor: hand;
	}
	.logout {
		float:right;
		margin-right:5px;
		background:url(/images/logout_wev8.png) 0 0 no-repeat;
	}
	.oprtbt {
		width:52px;
		height:31px;
		overflow:hidden;
		text-align:center;
		line-height:30px;
		margin-top:6px;
	}
	/* 顶部退回导航栏  END*/
	
	.content {
		background:url(/images/news/viewBg_wev8.png) repeat;margin:0;
		width:100%;
	}
	.maincontent {
		margin-left:8px;margin-right:8px;padding-top:12px;
	}
	
	.articleBody {
		width:100%;
		border-left:1px solid #C5CACE;
		border-right:1px solid #C5CACE;
		border-bottom:1px solid #C5CACE;
		background:#fff;
		-moz-border-bottom-left-radius: 5px;
		-moz-border-bottom-right-radius: 5px;
		-webkit-border-bottom-left-radius: 5px; 
		-webkit-border-bottom-right-radius: 5px; 
		border-bottom-left-radius:5px;
		border-bottom-left-radius:5px;
		width:100%;
	}
	
	.articleBody .viewBlock {
		margin-left:8px;margin-right:8px;padding-top:10px;padding-bottom:10px;font-size:12px;
	}
	
	/* 栏目块Head START */
	.blockHead {
		width:100%;
		height:24px;
		line-height:24px;
		font-size:12px;
		font-weight:bold;
		color:#fff;
		border-top:1px solid #0084CB;
		border-left:1px solid #0084CB;
		border-right:1px solid #0084CB;
		-moz-border-top-left-radius: 5px;
		-moz-border-top-right-radius: 5px;
		-webkit-border-top-left-radius: 5px; 
		-webkit-border-top-right-radius: 5px; 
		border-top-left-radius:5px;
		border-top-left-radius:5px;
		background:#0084CB;
		background: -moz-linear-gradient(0, #31B1F6, #0084CB);
		background:-webkit-gradient(linear, 0 0, 0 100%, from(#31B1F6), to(#0084CB));
	}
	
	.m-l-14 {
		margin-left:14px;
	}
	
	/* 栏目块Head END */
	/* 列表项后置导航 */
	.itemnavpoint {
		float:right;height:100%;width:26px;text-align:center;
	}
	/* 列表项后置导航图 */
	.itemnavpoint img {
		width:10px;
		heigth:14px;
		margin-top:16px;
	}
	.subtitle {
		height:17px;line-height:17px;font-size:12px;
	}
	.title {
		height:33px;line-height:33px;font-weight:bold;
	}
	.linespace {
		height:12px;overflow:hidden;
	}
	
	</style>
		
	<SCRIPT type="text/javascript">
	var contentWidth = -1;
	$(document).ready(function () {
		var scrollWidth = $(".viewBlock")[0].scrollWidth;
		//$(document.body).width(scrollWidth + 100);
		contentWidth = scrollWidth;

		if (window.innerWidth >= contentWidth) {
			$(document.body).width("100%");
		} else {
			$(document.body).width(contentWidth + 100);
		}
	});

	window.onresize = function () {
		if (window.innerWidth >= contentWidth) {
			$(document.body).width("100%");
		} else {
			$(document.body).width(contentWidth + 100);
		}
	};
	
	
	function doLeftButton() {
		goBack();
		return 1;
	}

	function goBack() {
		history.go(-1);
	}
	</SCRIPT>
</head>
<body>
<div>
	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width:100%;height:40px;font-size:13px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="content">
		<div class="maincontent">
			<!-- 内容正文	-->
			<div class="blockHead">
				<span class="m-l-14">原文</span>
			</div>
			<div class="articleBody">
				<div class="viewBlock">
					<%=content %>
				</div>
			</div>
			<!-- 间隔-->
			<div class="linespace"></div>
		</div>
	</div>
</div>
</body></html>