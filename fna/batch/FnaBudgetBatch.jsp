<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
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
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(34189, user.getLanguage())) %>,
        staticOnLoad:true
    });
});

function refreshTab(){
	jQuery('.flowMenusTd',parent.document).toggle();
	jQuery('.leftTypeSearch',parent.document).toggle();
} 

</script>
<%
//new LabelComInfo().removeLabelCache();
boolean hasTree = false;//是否有树形导航
boolean showLeftTree = true;//默认是否显示左侧数
int title = 0;
HashMap<String,String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String(kv.get("_fromURL"));//来源

String defFnayear = "";
String _ysxxUrl = "/fna/batch/FnaBudgetBatchInner.jsp";
String ysxxUrl = _ysxxUrl;
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
					<%
					String currentYear = TimeUtil.getCurrentDateString().split("-")[0];
					RecordSet rs = new RecordSet();
				    String sql = "select DISTINCT a.id, a.fnayear, a.startdate, a.enddate \n" +
				    		" from FnaYearsPeriods a \n" +
				    		" where a.status != -1 \n" +
				    		" order by a.fnayear ASC";
					rs.executeSql(sql);
					while(rs.next()){
						String fnayearId = Util.null2String(rs.getString("id")).trim();
						String fnayear = Util.null2String(rs.getString("fnayear")).trim();
						if("".equals(defFnayear)){
							defFnayear = fnayear;
						}
						String _class = "";
						if(Util.getIntValue(currentYear) == Util.getIntValue(fnayear)){
							_class = "current";
							defFnayear = fnayear;
						}
					%>
					<li class="<%=_class %>">
						<a id="divMainInfo_<%=fnayear %>" 
							href="<%=_ysxxUrl+"?fnayear="+fnayear %>" target="tabcontentframe">
			        		<%=fnayear %><!-- 当前预算年度 -->
			        	</a>
					</li>
					<%
					}
					%>
			    </ul>  
			    <div id="rightBox" class="e8_rightBox">
			    </div>	   
			</div>
		</div>
	</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=ysxxUrl+"?fnayear="+defFnayear %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

