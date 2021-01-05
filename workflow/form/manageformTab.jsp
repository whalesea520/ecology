<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<% 
if (!HrmUserVarify.checkUserRight("FormManage:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(699 , user.getLanguage())%>"
    });
}); 
</script>

<%
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String url = "/workflow/form/manageform.jsp?" + request.getQueryString();
	int subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
	session.setAttribute("managefield_subCompanyId",subCompanyId);
%>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
	      <div class="e8_boxhead">
	         <div class="div_e8_xtree" id="div_e8_xtree"></div>
             <div class="e8_tablogo" id="e8_tablogo"></div>
		     <div class="e8_ultab">
			  <div class="e8_navtab" id="e8_navtab">
				 <span id="objName"></span>
			  </div>
		    <div>
		    <ul class="tab_menu">
		    <%if(detachable==1){%>
		    	<li class="e8_tree">
		        	<a onclick="javascript:mnToggleleft();"><<<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></a>
		        </li>		
		   <%}%>
	        	 <li class="current">
		        	<a href="/workflow/form/manageform.jsp?<%=request.getQueryString() %>" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(125025, user.getLanguage()) %>
		        	</a>
		        </li>
	        	 <li>
		        	<a href="/workflow/form/manageform_test.jsp?<%=request.getQueryString() %>" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(125026, user.getLanguage()) %>
		        	</a>
		        </li>
	        	 <li>
		        	<a href="/workflow/form/manageform_sys.jsp?<%=request.getQueryString() %>" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(125027, user.getLanguage()) %>
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
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<script type="text/javascript">
function mnToggleleft(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
			window.parent.wfleftFrame.setHeight();
		}
	}
}
</script>
</html>