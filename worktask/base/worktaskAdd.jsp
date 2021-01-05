
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
    //权限控制
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}


	String items = "";
	String divStr = "";
	int isnew = Util.getIntValue(request.getParameter("isnew"), 0);
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
    //System.out.println("wtid============="+wtid);
    String titlename = "";
    if(wtid == 0){
			titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(18177, user.getLanguage());
    }else{
		String name = "";
		RecordSet.execute("select name from worktask_base where id="+wtid);
		if(RecordSet.next()){
			name = ":" + Util.null2String(RecordSet.getString("name"));
		}
		titlename = SystemEnv.getHtmlLabelName(93, user.getLanguage())+name;
    }
%>

<script type="text/javascript">

$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("worktask")%>", 
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=titlename %>"
       
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
	    var url = "";
	    if($(this).attr("urs"))url = $(this).attr("urs");
		url += "&"+requestParameters;
		$(this).attr("href",url);
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}
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
			
			<%if(isnew == 1 || wtid == 0){ %>
			    <li class="current">
					<a href="" urs='/worktask/base/addwt0.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %></a>
				</li>
			   
			<%}else{ %>
			    <li class="current">
					<a href="" urs='/worktask/base/addwt0.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %></a>
				</li>
				<li class="">
					<a href="" urs='/worktask/base/worktaskCreateRight.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(21945, user.getLanguage()) %></a>
				</li>
				<li class="">
					<a href="" urs='/worktask/base/worktaskFieldEdit.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16510, user.getLanguage()) %></a>
				</li>
				<!--<li class="">
					<a href="" urs='/worktask/base/worktaskListEdit.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(21929, user.getLanguage()) %></a>
				</li>
				<li class="">
					<a href="" urs='/worktask/base/WorkTaskShareSet.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(2112, user.getLanguage()) %></a>
				</li>-->
				<li class="">
					<a href="" urs='/worktask/base/WTApproveWfEdit.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(18436, user.getLanguage()) %></a>
				</li>
				<li class="">
					<a href="" urs='/worktask/base/worktaskMonitorSet.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(17989, user.getLanguage()) %></a>
				</li>
				<!--<li class="">
					<a href="" urs='/worktask/base/WTCode.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(19504, user.getLanguage()) %></a>
				</li>
				--><!--<li class="">
					<a href="" urs='/worktask/base/RemindedSet.jsp?wtid=<%=wtid%>' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(21946, user.getLanguage()) %></a>
				</li>-->
			
			<%} %>
			
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box">
		<iframe onload="update()" src="" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
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