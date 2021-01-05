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
	String fieldId = Util.null2String(request.getParameter("fieldId"));	//字段id
	String fieldSpanId = Util.null2String(request.getParameter("fieldSpanId"));	//字段显示区域id
	String selectedIds = Util.null2String(request.getParameter("selectedIds"));	//选中的id，逗号分隔，如：1,2,3
	String browserType = Util.null2String(request.getParameter("browserType"), "1");	//1.多选  2.单选
	String showType = Util.null2String(request.getParameter("showType"), "1");	//1.所有人 ，2.组织架构，3，常用组
	String resultBtnText = Util.null2String(SystemEnv.getHtmlNoteName(4974,user.getLanguage()), "已选,确 定,返 回,清 空,加载更多,删除,加载数据时出现错误：");
	String controlBtnText = Util.null2String(SystemEnv.getHtmlNoteName(4973,user.getLanguage()), "所有人,组织架构,常用组");
	String showTypeName = controlBtnText;
	String showTypeClassName = "hrm";
	if(showType.equals("1")){
		showTypeName = showTypeName.split(",")[0];//所有人
		showTypeClassName = "hrm";
	}else if(showType.equals("2")){
		showTypeName = showTypeName.split(",")[1];//组织架构
		showTypeClassName = "org";
	}else if(showType.equals("2")){
		showTypeName = showTypeName.split(",")[2];//常用组
		showTypeClassName = "group";
	}
	
	JSONArray selectedArr = new JSONArray();
	if(!selectedIds.trim().equals("")){
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
		
		String[] selectedIdArr = selectedIds.split(",");
		for(String selectedId : selectedIdArr){
			if(!selectedId.trim().equals("")){
				
				String lastname = resourceComInfo.getLastname(selectedId);	//姓名
				String subCompanyID = resourceComInfo.getSubCompanyID(selectedId);	//分部id
				String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//分部名称
				
				String departmentID = resourceComInfo.getDepartmentID(selectedId);	//部门id
				String departmentName = departmentComInfo.getDepartmentname(departmentID);	//部门名称
				
				String jobTitle = resourceComInfo.getJobTitle(selectedId);	//岗位id
				String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//岗位名称
				
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", selectedId);	//id
				selectedObj.put("lastname", Util.formatMultiLang(lastname));	//姓名
				selectedObj.put("subCompanyName", Util.formatMultiLang(subCompanyName));	//分部名称
				selectedObj.put("departmentName", Util.formatMultiLang(departmentName));	//部门名称
				selectedObj.put("jobTitlesName", Util.formatMultiLang(jobTitlesName));	//岗位名称
				selectedArr.add(selectedObj);
			}
		}
	}
	
	CompanyComInfo companyComInfo = new CompanyComInfo();
	String companyname = companyComInfo.getCompanyname("1");	//公司名称
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">

<script type="text/javascript">
var _top = null;var _win = window;try{while((_win.parent) != _win){_win = _win.parent;if(_win._mobilemode_root_page == true){_top = _win;break;}}}catch(e){}if(_top == null){_top = _win;}
var _browserType = "<%=browserType%>";

var _selected_arr = <%=selectedArr%>;
var _fieldId = "<%=fieldId%>";
var _fieldSpanId = "<%=fieldSpanId%>";

var showTypeName = "<%=showTypeName%>";

var _isRunInEmobile = (_top && typeof(_top.isRunInEmobile) == "function") ? _top.isRunInEmobile() : false;

var _resultBtnText = "<%=resultBtnText%>".split(",");
var _controlBtnText = "<%=controlBtnText%>".split(",");
</script>
<script type="text/javascript" src="/mobilemode/js/zepto/zepto.min_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/browser/js/fastclick.min_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/browser/js/jquery.sortable.min.js"></script>
<link type="text/css" rel="stylesheet" href="/mobilemode/browser/css/hrmBrowser_wev8.css?v=2017030701" />
<script type="text/javascript" src="/mobilemode/browser/js/hrmBrowser_wev8.js?v=2018041201"></script>
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
			<div class="header-center"><%=showTypeName%></div>
			<div class="header-right"></div>
		</div>
	</div>
	
	<div id="page-center">
		
		<div id="center-content" class="<%=showTypeClassName%>">
			<div id="center-content-inner">
				<div id="list-hrm-container" class="data-container hrm-container">
					<div id="list-hrm-srarch">
						<div class="srarch-inner">
							<input type="search" id="search-key" />
						</div>
					</div>
					
					<div id="list-hrm-content">
						<div id="hrm-content-inner">
							<div class="group-wrap">
							</div>
							<div id="list-loadMore"></div>
							<div id="list-loading">
							</div>
						</div>
					</div>
				</div>
				
				<div id="tree-org-container" class="data-container org-container">
					<ul class="tree-page root-tree-page">
						<li>
							<div class="one-tree-data company-data closed" data-id="1" data-type="1" data-haschild="1"><%=companyname%></div>
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
		
		<div id="page-control" class="<%=showTypeClassName%>">
			<div class="control-icon">
			
			</div>
			<div class="control-text">
				<%=showTypeName%>
			</div>
		</div>
		
		<div id="control-hrm" class="control-part">
			<div class="icon">
			
			</div>
			<div class="text">
				
			</div>
		</div>
		
		<div id="control-org" class="control-part">
			<div class="icon">
			
			</div>
			<div class="text">
				
			</div>
		</div>
		
		<div id="page-mask">
			
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