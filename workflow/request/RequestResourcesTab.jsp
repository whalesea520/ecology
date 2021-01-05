<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>

<%
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID(); 
int usertype = 0 ;
int requestid = Util.getIntValue(request.getParameter("requestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int isbill = Util.getIntValue(request.getParameter("isbill"));
int formid = Util.getIntValue(request.getParameter("formid"));
String showupload="";
String showdoc="";
String showworkflow="";
String reportid = Util.null2String(request.getParameter("reportid"));
String isfromreport = Util.null2String(request.getParameter("isfromreport"));
String isfromflowreport = Util.null2String(request.getParameter("isfromflowreport"));
String iswfshare = Util.null2String(request.getParameter("iswfshare"));

String urlparam = "workflowid=" + workflowid + "&requestid=" + requestid + "&isbill=" + isbill + "&formid=" + formid + "&reportid=" + reportid + "&isfromreport=" + isfromreport + "&isfromflowreport=" + isfromflowreport + "&iswfshare=" + iswfshare +"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
String navName = "";
/*
String sql="select showuploadtab,showdoctab,showworkflowtab from workflow_base where id="+workflowid+" and formid="+formid+" and isbill="+isbill;
RecordSet.executeSql(sql);
if(RecordSet.next()){
	showupload=Util.null2String(RecordSet.getString("showuploadtab"));
	showdoc=Util.null2String(RecordSet.getString("showdoctab"));
	showworkflow=Util.null2String(RecordSet.getString("showworkflowtab"));
}
*/
%>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.getParentWindow(window);
		dialog = parent.getDialog(window);
	}catch(e){}
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true
    });
}); 
jQuery(document).ready(function(){ setTabObjName("<%=Util.toScreenForJs(navName) %>"); });
</script>
<style type="text/css">

#reqresnavblock ul li,#reqresnavblock ul li a, #reqresnavblock ul {
	height:30px;
	line-height:28px;
}

.h24 {
/*
	height:24px;
	line-height:24px;
	*/
}
</style>
<%
	String url = "/workflow/request/RequestResources.jsp?tabindex=0&" + urlparam;
	int current = Util.getIntValue(request.getParameter("current"), 0);
	//System.out.println("current = "+current);
%>

</head>
<BODY scroll="no">
    <div class="e8_box demo2" id="reqresnavblock">
        <ul class="tab_menu" style="" class="h24" >
	   		<li <%if(current==0){%>class="current"<%} %> class="h24" >
	        	<a href="/workflow/request/RequestResources.jsp?tabindex=0&<%=urlparam %>" target="tabcontentframe" class="h24" style="">
	        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
	        	</a>
	        </li>
	      
	       	 <li <%if(current==1){%>class="current"<%} %> class="h24" >
	        	<a href="/workflow/request/RequestResources.jsp?tabindex=1&<%=urlparam %>" target="tabcontentframe" class="h24" style="">
	        		<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%> 
	        	</a>
	        </li>
	        
	         <li <%if(current==2){%>class="current"<%} %> class="h24" >
	        	<a href="/workflow/request/RequestResources.jsp?tabindex=2&<%=urlparam %>" target="tabcontentframe" class="h24" style="">
	        		<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>  
	        	</a>
	        </li> 
	        
	        <li <%if(current==3){%>class="current"<%} %> class="h24" >
	        	<a href="/workflow/request/RequestResources.jsp?tabindex=3&<%=urlparam %>" target="tabcontentframe" class="h24">
	        		<%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>  
	        	</a>
	        </li>
	        
		</ul>
	    <div class="tab_box">
	        <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	    </div>
	</div>  
</body>
</html>