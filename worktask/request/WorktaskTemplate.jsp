
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
	response.sendRedirect("/worktask/task/tasktab.jsp");
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>



<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>


<style>
  .sbSelector{
    font-size:12px;
  }
  #objName{
   margin-right:20px;
  }
 .dateitemwrapper{
   cursor: pointer;
   text-decoration: underline!important;
   color: rgb(13,147,246);
}
#e8TreeSwitch{
  display:none;
}
</style>
</HEAD>


<body scroll="no">
   


	<div class="e8_box demo2" id="rightContent">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						<li class="e8_tree" onclick="javascript:refreshTab();">
							<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelNames("407,64",user.getLanguage()) %></a>
						</li>
						<li class="current" >
							<a href="" target="tabcontentframe" _datetype="year" type='0'><%=SystemEnv.getHtmlLabelNames("407,64",user.getLanguage()) %></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
			<iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			
		<div>
	</div>	






		<script type="text/javascript">
  		
			var src="WorktaskTemplateFrame.jsp";
			
			$(document).ready(function(){
           
                
              $('.e8_box').Tabs({
					getLine : 1,
					iframe : "tabcontentframe",
					mouldID:"<%= MouldIDConst.getID("worktask")%>",
					staticOnLoad:true,
					objName:"<%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%>"
				});
				attachUrl();
			});
		  
		  function attachUrl(){
			
			$("a[target='tabcontentframe']").each(function(){
				
				$(this).attr("href",src);
				
				
			});
			$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
		}
		function refreshTab(){
		}

</script>


</body>
