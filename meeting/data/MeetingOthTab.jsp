
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	String toflag=Util.null2String(request.getParameter("toflag"));
	if("".equals(toflag)){
		out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
		return;
	}
	String url = "";
	String navName="";
	String mouldID = MouldIDConst.getID("meeting");
	if("TopicDate".equals(toflag)){
		url = "/meeting/data/MeetingTopicDate.jsp";
		navName = SystemEnv.getHtmlLabelName(68, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2169, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(277, user.getLanguage());
	} else if("Topic".equals(toflag)){
		url = "/meeting/data/MeetingTopic.jsp";
		navName = SystemEnv.getHtmlLabelName(2210, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2169, user.getLanguage());
	} else if("Decision".equals(toflag)){
		url = "/meeting/data/MeetingDecision.jsp";
		navName = SystemEnv.getHtmlLabelName(2194,user.getLanguage());
	} else if("ReCrm".equals(toflag)){
		url = "/meeting/data/MeetingReCrm.jsp";
		navName = SystemEnv.getHtmlLabelName(2103, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(430, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2108, user.getLanguage());
	} else if("ReHrm".equals(toflag)){
		url = "/meeting/data/MeetingReHrm.jsp";
		navName = SystemEnv.getHtmlLabelName(2103, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(430, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2108, user.getLanguage());
	}else if("ReOthers".equals(toflag)){
		url = "/meeting/data/MeetingReOthers.jsp";
		navName = SystemEnv.getHtmlLabelName(2103, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(430, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(454, user.getLanguage());
	}else if("discuss".equals(toflag)){
		url = "/meeting/data/EditMeetingDiscuss.jsp";
		String types=Util.null2String(request.getParameter("types"));
		if("WP".equals(types)){
			mouldID = MouldIDConst.getID("schedule");
		}
		navName = SystemEnv.getHtmlLabelName(15153, user.getLanguage());
	}else if("chgrepeat".equals(toflag)){
		url = "/meeting/data/MeetingChgRepeatDate.jsp";
		navName = SystemEnv.getHtmlLabelName(18082, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2103, user.getLanguage());
	}else if("signByHand".equals(toflag)){
		url = "/meeting/data/MeetingSignByHand.jsp";
		navName = SystemEnv.getHtmlLabelName(20032, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(27203, user.getLanguage());
	}else {
		out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
		return;
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
         mouldID:"<%=mouldID %>",
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
						<li class="defaultTab">
							<a href="#" target="tabcontentframe">
								<%=TimeUtil.getCurrentTimeString() %>
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

