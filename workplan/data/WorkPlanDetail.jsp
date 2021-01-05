
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="workPlanExchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>
<%
	int workID = Util.getIntValue(request.getParameter("workid"));
	String navName = SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	rs.executeSql("select name from workplan where id = " + workID);
	if(rs.next()){
		String name = Util.null2String(rs.getString("name"));
		if(!"".equals(name)){
			navName = name.replace("\"","\\\"");
		} 
	}
	int cnt = workPlanExchange.getWPExchangeNoReadCnt(workID, user.getUID(), Util.getIntValue(user.getLogintype()));
	String tabType = request.getParameter("tabType"); 
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
        mouldID:"<%= MouldIDConst.getID("schedule")%>",
        staticOnLoad:true,
        objName:"<%=navName %>"
    });
    var discussCount=0;
    function getIframeDocument(){
    	var _contentDocument = getIframeDocument2();
    	var _contentWindow = getIframeContentWindow();
    	if(!!_contentDocument){
    		jQuery("#nomal").bind("click",function(){
    			_contentWindow = getIframeContentWindow();
    			_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","");
				jQuery("#discussDiv",_contentDocument).css("display","none");
			});

			jQuery("#discuss").bind("click",function(){
				_contentWindow = getIframeContentWindow();
				_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#discussDiv",_contentDocument).css("display","");
				jQuery("#discuss").text("<%=SystemEnv.getHtmlLabelName(15153, user.getLanguage())%>");
				if("<%=tabType%>"!="2"&&discussCount==0){
					discussCount++;
					_contentWindow.resetDiv();
				}
			});
		
    	}else{
    		window.setTimeout(function(){
    			getIframeDocument();
    		},500);
    	}
    }
    
     getIframeDocument();
});

</script>

<%
	
	String from = Util.null2String(request.getParameter("from"));
	String selectUser = Util.null2String(request.getParameter("selectUser"));
	String selectDate = Util.null2String(request.getParameter("selectDate"));
	String viewType = Util.null2String(request.getParameter("viewType"));
	String workPlanType = Util.null2String(request.getParameter("workPlanType"));
	String workPlanStatus = Util.null2String(request.getParameter("workPlanStatus"));
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	int refresh = Util.getIntValue(request.getParameter("refresh"), -1);
	
	String url = "/workplan/data/WorkPlanDetailDtl.jsp";
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
						<li class='<%=!"2".equals(tabType)?"current":"" %>'>
							<a id="nomal" href="#" onclick="return false;" >
							   <%=SystemEnv.getHtmlLabelName(2121, user.getLanguage())%>
							</a>
						</li>
						<li class='<%="2".equals(tabType)?"current":"" %>'>
							<a id="discuss" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(15153, user.getLanguage())+(cnt > 0?"("+cnt+")":"")%>
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
	<FORM name="frmmain" action="/workplan/data/WorkPlanOperation.jsp" method="post">
	<INPUT type="hidden" name="method" value="view">
	<INPUT type="hidden" name="from" value="<%=from%>">
	<INPUT type="hidden" name="workid" value="<%=workID%>">
	<INPUT type="hidden" name="selectDate" value="<%=selectDate%>">
	<INPUT type="hidden" name="selectUser" value="<%=selectUser%>">
	<INPUT type="hidden" name="viewType" value="<%=viewType%>">
	<INPUT type="hidden" name="workPlanType" value="<%=workPlanType%>">
	<INPUT type="hidden" name="workPlanStatus" value="<%=workPlanStatus%>">
	<INPUT type="hidden" id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=user.getUID()%>">

	</FORM>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
<%if(refresh == 1) {%>
try{
window.parent.refreshCal();
}catch(e){
	var parentWin1 = parent.getParentWindow(window);
	parentWin1.refreshCal();
}
<%}%>
var dialog = parent.getDialog(window);

function btn_cancle(){
	if("<%=tabType%>"=="2"){
		try{
		var parentWin = parent.getParentWindow(window);
		parentWin.closeDialog();
		}catch(e){}
	}else{
		try{
		dialog = parent.getDialog(window);
		dialog.closeByHand();
		}catch(e){}
	}
}

function doEdit(edit_del_user) {
	$('#f_weaver_belongto_userid').val(edit_del_user);
	document.frmmain.action = "/workplan/data/WorkPlanEdit.jsp";
	document.frmmain.submit();
	
	 
}

function doShare(share_user) {
	$('#f_weaver_belongto_userid').val(share_user);
	document.frmmain.action = "/workplan/share/WorkPlanShare.jsp?f_weaver_belongto_userid="+share_user+"&planID=<%=workID%>";
	document.frmmain.submit();
}


function onViewLog() {
	document.frmmain.action = "/workplan/log/WorkPlanViewLog.jsp?from=1&workid=<%=workID%>";
	document.frmmain.submit();
}

function onEditLog() {
	document.frmmain.action = "/workplan/log/WorkPlanEditLog.jsp?from=1&workid=<%=workID%>";
	document.frmmain.submit();
}
</SCRIPT>