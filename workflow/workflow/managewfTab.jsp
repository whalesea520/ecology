<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="workType" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<%
	String navName = "";
	String isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0)+"";
	int typeid =Util.getIntValue(Util.null2String(request.getParameter("typeid")),0); 
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
	String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
	String url = "/workflow/workflow/managewf.jsp?isWorkflowDoc="+isWorkflowDoc+"&isTemplate="+isTemplate+"&subCompanyId="+subCompanyId+"&typeid="+typeid;
	
	if(typeid == 0){
		if(isTemplate.equals("1"))
			navName=SystemEnv.getHtmlLabelName(33658,user.getLanguage());
		else if(isTemplate.equals("0"))
			navName = SystemEnv.getHtmlLabelName(16483,user.getLanguage());
	}else{
		navName = workType.getWorkTypename(typeid+"");
	}
	
	if(isWorkflowDoc.equals("1")){
		navName = SystemEnv.getHtmlLabelName(23167,user.getLanguage());
	}
	//是否是分权管理员
	boolean hashpmright = false;
	if (detachable == 1) {
	    String sql = "SELECT 1 FROM HRMRESOURCEMANAGER WHERE ID=" + user.getUID() + " and id<>1";
	    RecordSet rs = new RecordSet();
	    rs.executeSql(sql);
	    if (rs.next()) {
	        hashpmright = true;
	    } else {
	        hashpmright = false;
	    }
	}
%>
<HTML><HEAD>
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
        mouldID:"<%= MouldIDConst.getID(isWorkflowDoc.equals("1")?"offical":"workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true
    });
}); 

jQuery(document).ready(function(){ setTabObjName("<%=Util.toScreenForJs(navName) %>"); });
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
				        <%if(!isWorkflowDoc.equals("1")){ %>
				      	<li class="e8_tree">
				        	<a onclick="javascript:mnToggleleft();"><<<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></a>
				        </li>	
				        <%}if(!isWorkflowDoc.equals("1")&&!"1".equals(isTemplate)){ %>
				        	<li class="current">
					        	<a href="<%=url %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName("1".equals(isTemplate)?33658:16483,user.getLanguage())%></a>
					        </li>
					        <%if(typeid == 0){
					        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){%>
								<li>
						        	<a href="/workflow/workflow/wfRightEdit.jsp" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33805,user.getLanguage())%></a>
						        </li>
							<%}}%>
					     <%} %>			        
			    </ul>
			    <div id="rightBox" class="e8_rightBox"> </div>
		    </div>
		    </div>
	    </div>
    	<div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" scrolling=no></iframe>
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
</script>
</html>
