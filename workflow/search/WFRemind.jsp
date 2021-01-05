
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
   	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<%
		String flag = request.getParameter("flag");

		String navName = ""+SystemEnv.getHtmlLabelName(16393,user.getLanguage()); 
		if( flag != null ){
			if( flag.equals("newWf")){
				navName = ""+SystemEnv.getHtmlLabelName(84241,user.getLanguage());
			}else if( flag.equals("endWf")){
				navName = ""+SystemEnv.getHtmlLabelName(2066,user.getLanguage());
			}else if( flag.equals("rejectWf")){
				navName = ""+SystemEnv.getHtmlLabelName(24449,user.getLanguage());
			}
		}
		
	    String queryStr = request.getQueryString().replace("needHeader=true", "needHeader=false");
		if(!queryStr.equals("")){
		    //此刻不需协同,协同已配置，以免多生成
		    queryStr = queryStr +"&needsynergy=0";
		}
		String url = "WFSearchResult.jsp?" + queryStr;
	%>
	
	<script type="text/javascript">
		
		jQuery(document).ready(function(){
			$('.e8_box').Tabs({
		        getLine:1,
		        mouldID:"<%= MouldIDConst.getID("workflow")%>",
		        iframe:"tabcontentframe",
		        staticOnLoad:true,
		        objName:"<%=navName%>"
		    });

			jQuery('.flowMenusTd', parent.document).toggle();
			jQuery('.leftTypeSearch', parent.document).toggle();
			jQuery('#e8TreeSwitch').hide();
		});

	</script>
  </head>
 
	<body scroll="no">
	    <div class="e8_box demo2">
		    <div class="e8_boxhead">
			    <div class="div_e8_xtree" id="div_e8_xtree"></div>
		        <div class="e8_tablogo" id="e8_tablogo"></div>
				<div class="e8_ultab">
					<div class="e8_navtab" id="e8_navtab">
						<span id="objName"></span>
					</div>
					<div>
						<ul class="tab_menu" style="visibility:hidden">
							<li class="e8_tree">
								<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
							</li>
							
						</ul>
						<div id="rightBox" class="e8_rightBox"></div>
			    	</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<iframe src="<%=url %>"
						onload="update();" id="tabcontentframe" name="tabcontentframe"
						class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
	</body>
</html>
