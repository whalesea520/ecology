<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.Prop"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
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
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("hrm") %>",
        objName:<%=JSONObject.quote("人力资源配置检查") %>,
        staticOnLoad:true
    });
});
</script>
</head>			        
<!-- 自定义设置tab页 -->
<%

String show = Util.null2String(request.getParameter("show")).trim();
show = "all";

RecordSet rs = new RecordSet();

String cversion = "";
rs.executeSql("select * from license");
if(rs.next()){
	cversion = Util.null2String(rs.getString("cversion")).trim();
}
//cversion.compareTo("8.100.0531+KB81001612")

Map<String,String> mapProps = new HashMap<String,String>();
Properties props = Prop.loadTemplateProp("hrmGlobalSetTab");
Object[] propsArray = new Object[props.size()];
for(Map.Entry me : props.entrySet()){
	mapProps = new HashMap<String,String>();
	String globalSetValue = Util.null2String(me.getValue());
	String globalSetKey = Util.null2String(me.getKey());
	String[] globalSetKeys = globalSetKey.split("-");
	mapProps.put(globalSetKeys[1],globalSetValue);
	propsArray[Util.getIntValue(globalSetKeys[0])] = mapProps; 
}
%>
<BODY>
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
		    		<li class="current" >
			        	<a id="tabId1" href="/hrm/test/HrmSystemTestSet.jsp" target="tabcontentframe">
			        		人力资源相关配置检查
			        	</a>
			        </li>
			        <%
			        //alert('请确保人力资源相关配置检查都已经检测正常');
for(int i = 0 ; i < propsArray.length ;i++){
	Map<String,String> tmpMap = (Map)propsArray[i];
	if(i == 5){//调班流程
		if(cversion.compareTo("8.100.0531+KB81001601") < 0){
			continue;
		}
	}
	for(Map.Entry me : tmpMap.entrySet()){
			         %>
		    		<li>
			        	<a id="tabId2" href="/hrm/test/<%=me.getValue() %>"  onclick=""  target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames(Util.null2String(me.getKey()),7) %>
			        	</a>
			        </li>
<%
break;
}
} %>			        
			    </ul>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="/hrm/test/HrmSystemTestSet.jsp" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

