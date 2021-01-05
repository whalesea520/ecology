
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	int _fromURL = Util.getIntValue(kv.get("_fromURL"));
	String url = "";
	String navName = "";
	String mouldID = MouldIDConst.getID("setting");
	
	
	if(_fromURL==1){//新增敏感字
		url = "/security/sensitive/AddSensitiveWord.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==2){//编辑敏感字
		url = "/security/sensitive/EditSensitiveWord.jsp?id="+kv.get("id");
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==4){//敏感词相关设置
		url = "/security/sensitive/SensitiveSetting.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==3){//敏感词拦截日志
		url = "/security/sensitive/SensitiveLogs.jsp";
		navName = SystemEnv.getHtmlLabelName(131598,user.getLanguage());
	}else{//敏感词列表
		url = "/security/sensitive/SensitiveWords.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}

	
%>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= mouldID%>",
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
			       
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	     </div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

