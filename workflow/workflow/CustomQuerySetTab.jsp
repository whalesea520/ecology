<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String shortName = Util.null2String(request.getParameter("shortName"));
	int otype = Util.getIntValue(Util.null2String(request.getParameter("otype")),0);
	String navName = Util.null2String(request.getParameter("typename"));
	String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
	session.setAttribute("customquery_subcompanyid",subcompanyid);
	session.setAttribute("customquery_otype",otype);
	
	String url = "/workflow/workflow/CustomQuerySet.jsp?shortName="+shortName+"&otype="+otype+"&subcompanyid="+subcompanyid;
	rs.execute("select typename from workflow_customQuerytype where id="+otype);
	if(rs.next()){
		navName = rs.getString("typename");
	}
	if("".equals(navName)) navName = SystemEnv.getHtmlLabelName(20773,user.getLanguage());
%>
	<script type="text/javascript">
		$(function(){
		    $('.e8_box').Tabs({
		        getLine:0,
		        mouldID:"<%= MouldIDConst.getID("workflow")%>",
		        iframe:"tabcontentframe",
		        staticOnLoad:true,
		        objName:"<%=navName%>"
		    });
		});
	</script>
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
	    		<li class="e8_tree">
		        	<a href="#"></a>
		        </li>
	        	<li class="current">
		        	<a href="<%=url %>" target="tabcontentframe">
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
</html>