
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
		String navName = ""+SystemEnv.getHtmlLabelName(20773,user.getLanguage()); 
		%>
  </head>
  
  <script type="text/javascript">
	jQuery(document).ready(function(){
		$('.e8_box').Tabs({
	        getLine:1,
	        mouldID:"<%= MouldIDConst.getID("workflow")%>",
	        iframe:"tabcontentframe",
	        staticOnLoad:true,
	        objName:"<%=navName%>"
	    });
		
	});
  </script>
  
  <%	
		String frmurl = "CustomSearchs.jsp";
  		String wfid = Util.null2String(request.getParameter("workflowid"));
  		if (!"".equals(wfid)) {
  		  frmurl = "/workflow/search/WFSearchsPageFrame.jsp?fromleftmenu=1&isfrom=customSearch&wfid=" + wfid ;
  		}
  %>
	<body scroll="no">
		<div id="submitloaddingdiv_out" style="display:none;background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;">
		</div>
		<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:240px;position:absolute;z-index:9999;font-size:12px;">
			<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(84041, user.getLanguage()) %></span>
		</span>
	    <div id="mainDiv" class="e8_box demo2">
		    <div class="e8_boxhead">
		        <div class="e8_tablogo" id="e8_tablogo"></div>
				<div class="e8_ultab">
					<div class="e8_navtab" id="e8_navtab">
						<span id="objName"></span>
					</div>
					<div id="rightBox" class="e8_rightBox">
	    			</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<iframe src="<%=frmurl %>"
						onload="update();" id="tabcontentframe" name="tabcontentframe"
						class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
	</body>
</html>