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
	String isTemplate = Util.getIntValue(Util.null2String(request.getParameter("isTemplate")), 0) + "";
	String info = Util.null2String(request.getParameter("infoKey"));
	int typeid = Util.getIntValue(request.getParameter("typeid"),0);
	String navName = Util.null2String(request.getParameter("typename"));
	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    session.setAttribute("monitoryjktypeid",typeid);
	String url = "/system/systemmonitor/workflow/systemMonitorStatic.jsp?subcompanyid="+subcompanyid+
				"&infoKey="+info+"&isTemplate="+isTemplate;

	rs.execute("select typename from Workflow_MonitorType where id="+typeid);
	if(rs.next()){
		navName = rs.getString("typename");
	}
	
	if("".equals(navName)) navName = SystemEnv.getHtmlLabelName(17989,user.getLanguage()) ;
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
		        	<a onclick="javascript:mnToggleleft();" title="<%=SystemEnv.getHtmlLabelName(84031,user.getLanguage())%>"><%if(detachable==1){%><<分部/<%}else{%><<<%}%>类型</a>
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
<script type="text/javascript">
function mnToggleleft(){
		var f = window.parent.oTd1.style.display;
		if (f != null) {
			if(f==''){
				window.parent.oTd1.style.display='none';
				<%if(detachable==1){%>
				window.parent.parent.oTd1.style.display='none';
				<%}%>
			}else{ 
				window.parent.oTd1.style.display='';
				var divHeght = window.parent.wfleftFrame.setHeight();
				<%if(detachable==1){%>
				window.parent.parent.leftframe.setHeight(divHeght);
				window.parent.parent.oTd1.style.display='';
				<%}%>
			}
		}
	}

jQuery(document).ready(function(){
      <% if (typeid != 0){%>
	  setTabObjName("<%=navName%>");
	  <%}%>
	}); 	
</script>
</html>