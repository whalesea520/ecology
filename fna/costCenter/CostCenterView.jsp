<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
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
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(515,user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
<%
	if(!HrmUserVarify.checkUserRight("BudgetCostCenter:maintenance", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	int title = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	
	BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();
	RecordSet rs = new RecordSet();
	
	int fccId = Util.getIntValue(request.getParameter("fccId"),0);
	if(fccId < 0){
		fccId = 0;
	}
	
	int type = 0;
	String fccName = SystemEnv.getHtmlLabelName(515,user.getLanguage());
	rs.executeSql("select type,name from FnaCostCenter where id = "+fccId);
	if(rs.next()){
		type = Util.getIntValue(rs.getString("type"), 0);
		fccName = Util.null2String(rs.getString("name")).trim();
	}
	

	String url1 = "/fna/costCenter/CostCenterViewInner.jsp?fccId="+fccId;
	String url2 = "/fna/costCenter/CostCenterEditPage.jsp?fccId="+fccId;
	String urlDef = url1;
	if(fccId > 0){
		urlDef = url2;
	}
%>
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
				<%if((fccId > 0 && type == 1) || fccId == 0){ %>
					<li class="defaultTab">
						<a href="#">
							<%=TimeUtil.getCurrentTimeString() %>
						</a>
					</li>
				<%}else{ %>
		    		<li class="current">
			        	<a id="divMainInfo1" href="<%=url2 %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("178,87",user.getLanguage()) %><!-- 类别信息 --> 
			        	</a>
			        </li>
		    		<li>
			        	<a id="divMainInfo2" href="<%=url1 %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(515,user.getLanguage()) %><!-- 成本中心 --> 
			        	</a>
			        </li>
				<%} %>
			    </ul> 
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=urlDef %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
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
	setTabObjName(<%=JSONObject.quote(fccName) %>);
});
</script>
</html>

