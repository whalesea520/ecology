
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.login.Account"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UsrTemplate"
	class="weaver.systeminfo.template.UserTemplate" scope="page" />
	<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
	/* if(!user.getLoginid().equalsIgnoreCase("sysadmin")){
		//只有系统管理员才能操作后台
		response.sendRedirect("/notice/noright.jsp");
		return;
	} */
	if(!HrmUserVarify.checkUserRight("License:manager", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
/* 	if(!cu.canOperate(user,"3"))//不具有入口权限
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}	 */
	UsrTemplate.getTemplateByUID(user.getUID(), user
			.getUserSubCompany1());
	String logo = UsrTemplate.getLogo();
	String logoBottom = UsrTemplate.getLogoBottom();
	String templateTitle = UsrTemplate.getTemplateTitle();
	String strDepartment=departmentComInfo.getDepartmentname(String.valueOf(user.getUserDepartment()));
%>
<html><head>
	
	 <link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet" type="text/css" />
	 <link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
	 <link href="/cpcompanyinfo/style/Business_wev8.css" rel="stylesheet"  type="text/css" />
	 <link href="/newportal/style/Contacts_wev8.css" rel="stylesheet"  type="text/css" />
	 <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	 <script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
			
	 <script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	 <link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	 <link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	 <script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
	
 	 <link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
	 <link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
 	 <script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
	 <script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("cpcompany")%>",
        staticOnLoad:true
    });
}); 
window.notExecute=true;
</script>

</head>
<% 
String license = "CompanyLicenseMaintain.jsp";
String timeover = "CompanyOvertimeMaintain.jsp";
String allot= "/cpcompanyinfo/CommanagerTreeRightTab.jsp";
String comSer = "/cpcompanyinfo/CompanyService.jsp";
String Companyattributable = "/cpcompanyinfo/Companyattributable.jsp";
%>
<body scroll="no">

<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"><%=SystemEnv.getHtmlLabelName(33712,user.getLanguage())%></span>
				</div>
			<div>
		    <ul class="tab_menu">
		       		<li class="current">
						<a href="<%=license %>" target="tabcontentframe" > 
							<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>
						</a>
					</li>
					<li>
						<a href="<%=allot %>" target="tabcontentframe" >
							<%=SystemEnv.getHtmlLabelName(31132,user.getLanguage())%>
						</a>
					</li>
					<li>
						<a href="<%=timeover %>" target="tabcontentframe" >
							<%=SystemEnv.getHtmlLabelName(18818,user.getLanguage())%>
						</a>
					</li>
					
					<li>
						<a href="<%=comSer %>" target="tabcontentframe" >
							<%=SystemEnv.getHtmlLabelName(26329,user.getLanguage())  %>
						 </a>
					</li>
					<li>
						<a href="<%=Companyattributable %>" target="tabcontentframe" >
							<%=SystemEnv.getHtmlLabelName(30987,user.getLanguage())  %>
						</a>
					</li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=license %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
</div>    

<script type="text/javascript">
jQuery.fn.slideLeftHide = function( speed, callback ) {
	this.animate({
		width : "hide",
		paddingLeft : "hide",
		paddingRight : "hide",
		marginLeft : "hide",
		marginRight : "hide"
	}, speed, callback );
};
jQuery.fn.slideLeftShow = function( speed, callback ) {
	this.animate({
		width : "show",
		paddingLeft : "show",
		paddingRight : "show",
		marginLeft : "show",
		marginRight : "show"
	}, speed, callback );
};

function hideLeftTree(){
	$('#oTd1', parent.document).slideLeftHide(0);
}

function showLeftTree(){
	$('#oTd1', parent.document).slideLeftShow(0);
}

hideLeftTree();


</script>


	</body>
</html>