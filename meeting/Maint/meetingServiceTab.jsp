<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.meeting.MeetingServiceUtil" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("Meeting:Service", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//新的无数据,老的有数据
RecordSet.execute("select count(*) as c from Meeting_Service_type");
if(RecordSet.next()){
	int newType=RecordSet.getInt("c");
	if(newType==0){
		RecordSet.execute("select count(*) as c from Meeting_Service");
		if(RecordSet.next()){
			if(RecordSet.getInt("c")>0){
				//初始化历史数据
				MeetingServiceUtil.init();
			}
		}
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
         mouldID:"<%= MouldIDConst.getID("meeting")%>",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(81892,user.getLanguage())%>"
    });
    
});


</script>

<%
	String url = "/meeting/Maint/MeetingServiceTypeList.jsp";
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString();
	}
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
				   
						 <li class="current">
							<a href="/meeting/Maint/MeetingServiceTypeList.jsp" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(2155,user.getLanguage()) %>
							</a>
						</li>
						<li>
							<a href="/meeting/Maint/MeetingServiceItemList.jsp"  target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(2157,user.getLanguage()) %>
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
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update()"></iframe>
	        </div>
	    </div>
	</div>
	
</body>
</html>

<script type="text/javascript">

function closeWinAFrsh(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDlgARfsh();
}

function closeDialog(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

</script>