<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.hrm.job.JobTitlesComInfo" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.company.CompanyComInfo" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%
	User user = MobileUserInit.getUser(request,response);
	if(user == null){
		out.println("服务器端重置了登录信息，请重新登录");
		return;
	}
	
	boolean isNoHeader = Util.null2String(request.getParameter("noHeader")).equals("1");	//是否不包含头部
	String fromtype = Util.null2String(request.getParameter("fromtype"));	//流程页面打开
	String fieldId = Util.null2String(request.getParameter("fieldId"));	//字段id
	String fieldSpanId = Util.null2String(request.getParameter("fieldSpanId"));	//字段显示区域id
	String selectedIds = Util.null2String(request.getParameter("selectedIds"));	//选中的id，逗号分隔，如：1,2,3
	String browserType = Util.null2String(request.getParameter("browserType"), "1");	//1.多选  2.单选
	
	String browserId = Util.null2String(request.getParameter("browserId"));
	String browserName = Util.null2String(request.getParameter("browserName"));
	String browserText = Util.null2String(request.getParameter("browserText"));	//浏览按钮文本，用于标题显示
	String resultBtnText = Util.null2String(SystemEnv.getHtmlNoteName(4974,user.getLanguage()), "已选,确 定,返 回,清 空,加载更多,删除,加载数据时出现错误：");

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">

<script type="text/javascript">
var _top = null;var _win = window;try{while((_win.parent) != _win){_win = _win.parent;if(_win._mobilemode_root_page == true){_top = _win;break;}}}catch(e){}if(_top == null){_top = _win;}
var _fromtype = "<%=fromtype%>";
var _browserId = "<%=browserId%>";
var _browserName = "<%=browserName%>";
var _browserText = "<%=browserText%>";
var _browserType = "<%=browserType%>";

var _selectedIds = "<%=selectedIds.trim()%>";
var _selected_arr = [];

var _fieldId = "<%=fieldId%>";
var _fieldSpanId = "<%=fieldSpanId%>";

var _isRunInEmobile = (_top && typeof(_top.isRunInEmobile) == "function") ? _top.isRunInEmobile() : false;
var _resultBtnText = "<%=resultBtnText%>".split(",");

</script>
<script type="text/javascript" src="/mobilemode/js/zepto/zepto.min_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/browser/js/fastclick.min_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/browser/js/jquery.sortable.min.js"></script>
<link type="text/css" rel="stylesheet" href="/mobilemode/browser/css/commonTreeBrowser_wev8.css?v=2018050901"/>
<script type="text/javascript" src="/mobilemode/browser/js/commonTreeBrowser_wev8.js?v=2018041201"></script>
<script type="text/javascript">
var _isNoHeader = "<%=isNoHeader%>";
$(document).ready(function(){
	$("#page-center").css("top", "0px");
	$("#page-title").hide();
});
</script>

</head>
<body class="_emobile">
<div id="page">
	<div id="page-title">
		<div id="nav-header">
			<div class="header-left"><%=SystemEnv.getHtmlNoteName(4343,user.getLanguage())%></div><!-- 返回  -->
			<div class="header-center"><%=browserText%></div>
			<div class="header-right"></div>
		</div>
	</div>
	
	<div id="page-center">
		<div id="center-content" class="org">
			<div id="center-content-inner">
				<div id="tree-org-container" class="data-container org-container">
					<ul class="tree-page root-tree-page">
						<li>
							<div class="one-tree-data company-data closed" data-id="0_0" data-type="" data-haschild="1" onclick="initTreeNode(this)"></div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		
		<div id="center-footer">
			<div id="choosedResult">
				
			</div>
			
			<div id="okResult">
				
			</div>
		</div>
		
		
		<div id="selected-result-page">
			<div id="result-center">
				<div id="result-center-inner">
					
					<div id="result-hrm-container">
						<div id="result-hrm-srarch">
							<div class="srarch-inner">
								<input type="search" id="result-search-key" />
							</div>
						</div>
						
						<div id="result-hrm-content">
							<div id="result-data">
							</div>
						</div>
					</div>
				
				</div>
			</div>
			<div id="result-footer">
				<div id="backResult">
				
				</div>
				<div id="clearResult">
					
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
