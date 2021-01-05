
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<%
int viewResult = Util.getIntValue(Util.null2String(request.getParameter("viewResult")),0);

// 1 表示模板
int istemplate = Util.getIntValue(Util.null2String(request.getParameter("istemplate")),0);

String votingid =  Util.null2String(request.getParameter("votingid"));

// 获取调查表名称
String votingname = "";
RecordSet.executeSql("select subject from voting where id="+votingid);
while(RecordSet.next()){
	votingname = RecordSet.getString("subject");
	votingname=votingname.replaceAll("\"","&quot;");
}
%>


<script type="text/javascript">

$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("voting")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        //objName:"<%=SystemEnv.getHtmlLabelName(24115,user.getLanguage()) %>"
        <%if(viewResult == 1){%>
             objName:"<%=votingname +"-"+SystemEnv.getHtmlLabelName(24115,user.getLanguage())%>"
        <%}else{%>
             objName:"<%=votingname %>"
        <%}%>
    });

   	attachUrl();
}); 

function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function attachUrl(){
	var requestParameters=$(".voteParameterForm").serialize();
	$("a[target='tabcontentframe']").each(function(){
		var url = "/voting/surveydesign/pages/surveyresultlist.jsp?"+requestParameters;
		/** if($(this).attr("status"))
			url += "&status="+$(this).attr("status"); */
		$(this).attr("href",url);
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}
jQuery(document).ready(function() {
      jQuery("#objName").html(jQuery("#objName").html().replace(/&amp;quot;/g,"\""));
   });
</script>

</head>

<body scroll="no">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
	    <div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
		<div>
	    
		<ul class="tab_menu" >
			<li class="current">
				<a href="" status='0' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(356, user.getLanguage()) %></a>
			</li>
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box">
		<iframe onload="update()" src="/voting/surveydesign/pages/surveyresultlist.jsp?votingid=<%=votingid %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<form class="voteParameterForm">
			<%
				Enumeration<String> e=request.getParameterNames();
				while(e.hasMoreElements()){
					String paramenterName=e.nextElement();
					String value=request.getParameter(paramenterName);
					//System.out.println(paramenterName + ":" + value);
					%>
						<input type="hidden" name="<%=paramenterName %>" value="<%=value %>" class="requestParameters">
					<% 
				}
				
			%>
		</form>
	</div></div>
</body>
</html>

