
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />

<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String url = "/workflow/request/RequestUserDefault.jsp";
	String navName = SystemEnv.getHtmlLabelName(18166,user.getLanguage());
	String mouldID = MouldIDConst.getID("setting");
	String callback = "";
	
	if(_fromURL.equals("1")||_fromURL.equals("")){//工作流程
		url = "/workflow/request/RequestUserDefault.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("2")){//人力资源
		url = "/hrm/group/HrmGroup.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("3")){//门户管理
		url = "/systeminfo/menuconfig/MenuMaintenanceManage.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("4")){//其他设置
		url = "/systeminfo/setting/HrmUserSettingEdit.jsp?"+request.getQueryString();
	}
	
%>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= mouldID%>",
        staticOnLoad:true,
        objName:"<%=navName%>",
        ifrmCallback:<%=callback.equals("")?null:callback%>
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
		    		<li class="current">
		        	<a href="/workflow/request/RequestUserDefault.jsp" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(2118,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li>
		        	<a href="/hrm/group/HrmGroup.jsp" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %>
		        	</a>
		        </li>
		         <li>
		        	<a href="/systeminfo/menuconfig/MenuMaintenanceManage.jsp" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(20613,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li>
		        	<a href="/systeminfo/setting/HrmUserSettingEdit.jsp" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(20824,user.getLanguage()) %>
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

