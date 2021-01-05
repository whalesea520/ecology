<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	String wfid = Util.null2String(request.getParameter("wfid"));

    
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(wfid), 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String versionclick = Util.getIntValue(Util.null2String(request.getParameter("versionclick")), 0)+ "";
	String isnodemode = Util.null2String(request.getParameter("isnodemode"));
	String fromWfEdit = Util.null2String(request.getParameter("fromWfEdit"));
	if (wfid.equals(""))
		wfid = "0";
	//是否为流程模板
	String isTemplate = Util.getIntValue(Util.null2String(request.getParameter("isTemplate")), 0)+ "";
	int typeid = Util.getIntValue(request.getParameter("typeid"), 0);
	int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);

	//流程版本START by CC
	//流程版本控制类
	WorkflowVersion wfversion = new WorkflowVersion(wfid);
	//是否存在版本
	boolean hasVersion = false;
	//所有版本列表
	List wfversions = null;
	//当前流程最大版本号
	int lastVersionid = 0;
	//当前流程的活动版本
	String activeVersionId = "0";
	//流程模板不存在版本
	if (!"1".equals(isTemplate)) {
		wfversions = wfversion.getAllVersionList();
		
		if (wfversions.size() > 1) {
			hasVersion = true;
		}
				
		lastVersionid = wfversion.getLastVersionID();
		//当前流程的活动流程
		activeVersionId = wfversion.getActiveVersionWFID();
	}
	//流程版本END by CC
	String tempVersionid = "0";
	Iterator it = wfversions.iterator();
	while (it.hasNext()) {
		Map versionkv = (Map)it.next();
		String tempWfid = (String)versionkv.get("id");
		tempVersionid = (String)versionkv.get("version");
			
		if (tempWfid.equals(activeVersionId)) {
			break;
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
        iframe:"tabcontentframe",
        staticOnLoad:true
    });
}); 
</script>

<%
	String url = "/workflow/workflow/addfreewfTab.jsp?versionclick="+versionclick+"&isnodemode="+isnodemode+"&wfid="+wfid+"&fromWfEdit="+fromWfEdit+"&isTemplate="+isTemplate+"&typeid="+typeid;
  
%>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		    <ul class="tab_menu">
			    	<li class="e8_tree">
			        	<a onclick="javascript:mnToggleleft();"><%if(detachable==1){%><<<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>/<%}else{%><<<%}%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></a>
			        </li>
			        <li>
			        	<a onclick="childShowVersion()" target="tabcontentframe">V<%=tempVersionid %></a>
			        </li>	
		        	 <li class="current">
			        	<a href="<%=url %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></a>
			        </li>
					<li>
			        	<a onclick="childSelectTile('flowset')" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15615, user.getLanguage())%></a>
			        </li>	
			        <li>
			        	<a onclick="childSelectTile('hightset')" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(21220, user.getLanguage())%></a>
			        </li>			        		        
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
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
			<%if(detachable==1){%>
			window.parent.parent.oTd1.style.display='';
			<%}%>
		}
	}
	tabcontentframe.window.lavlinit();
}

function childSelectTile(tab){
	tabcontentframe.window.selectedTitle(tab);
}

function childShowVersion(){
	tabcontentframe.window.showVersion();
}
</script>
</html>