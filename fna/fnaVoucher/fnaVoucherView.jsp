<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	int title = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	
	String tabObjName = SystemEnv.getHtmlLabelName(84672,user.getLanguage());

	String _class1 = "current";
	String _class2 = "";
	String _ysxxUrl1 = "/fna/fnaVoucher/fnaVoucherViewInner.jsp";
	String _ysxxUrl2 = "/fna/fnaVoucher/dataSetListInner.jsp";
	String ysxxUrl = _ysxxUrl1;
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
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        contentID:"#divMainInfo",
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("fna") %>",
        objName:<%=JSONObject.quote(tabObjName) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
</head>			        
<BODY scroll="no">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo" onclick="mnToggleleft(this);"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
					<li id="tabTop1" class="<%=_class1 %>">
						<a id="divMainInfo_1" 
							href="<%=_ysxxUrl1 %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(84672, user.getLanguage()) %><!-- XML模板 -->
			        	</a>
					</li>
					<li id="tabTop2" class="<%=_class2 %>">
						<a id="divMainInfo_2" 
							href="<%=_ysxxUrl2 %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(84712, user.getLanguage()) %><!-- 数据集 -->
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
	            <iframe src="<%=ysxxUrl %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<script type="text/javascript">
function mnToggleleft(obj){
	if(window!=null&&window.parent!=null&&window.parent.oTd1!=null&&window.parent.oTd1.style!=null){
		var f = window.parent.oTd1.style.display;
		if(f==null||f==""){
			obj.innerHTML=obj.innerHTML.replace("&lt;&lt;","&gt;&gt;");
			window.parent.oTd1.style.display='none';
		}else{
			obj.innerHTML=obj.innerHTML.replace("&gt;&gt;","&lt;&lt;");
			window.parent.oTd1.style.display='';
		}
	}
}
jQuery(document).ready(function(){
	setTabObjName(<%=JSONObject.quote(tabObjName) %>);
});
</script>
</html>

