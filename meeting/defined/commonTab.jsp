<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String formurl=request.getParameter("_fromURL");
	String url="";
	int title = 2103;
	if("InfoFieldSelect".equals(formurl)){
		url="/meeting/defined/FieldSelect.jsp";
		title=32714;
	}else if("RemindInfo".equals(formurl)){
		url="/meeting/defined/remindInfo.jsp";
		title=30425;
	}else if("MeetingWfForm".equals(formurl)){
		int billid=Util.getIntValue(request.getParameter("id"));
		url="/meeting/defined/wfFormInfo.jsp";
		title=24087;
		RecordSet.execute("SELECT namelabel FROM workflow_bill where id="+billid);
		if(RecordSet.next()){
			title=Util.getIntValue(RecordSet.getString("namelabel"),24087);
		}
	}
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString();
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
        objName:"<%=SystemEnv.getHtmlLabelName(title,user.getLanguage())%>"
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