

<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
/*
if (true) {
request.getRequestDispatcher("/workflow/request/RemarkFrame.jsp").forward(request, response);
return ;
}
*/
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;
String requestname_str = Util.fromScreen3(request.getParameter("requestname"),user.getLanguage());
//openDialog("<%=requestname","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid + "&requestname=<=requestname >");
String url = "/workflow/request/RemarkFrame.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid=" + request.getParameter("requestid") + "&workflowRequestLogId=" + request.getParameter("workflowRequestLogId") + "&resourceids=" + request.getParameter("resourceids") +"&forwardflag="+request.getParameter("forwardflag")+"&needwfback="+request.getParameter("needwfback") + "&requestname=" + requestname_str + "&requestname=" + requestname_str; //request.getQueryString();
String requestid=Util.null2String(request.getParameter("requestid"));
String requestname="";
RecordSet.executeSql("select requestname from workflow_requestbase where requestid="+requestid);
if(RecordSet.next()){
	requestname=RecordSet.getString("requestname");
}
/*
if(null==request.getParameter("requestname")){
	RecordSet.executeSql("select requestname from workflow_requestbase where requestid="+requestid);
	if(RecordSet.next()){
		requestname=RecordSet.getString("requestname");
	}
}else{
	requestname=request.getParameter("requestname");
}
*/
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
    
    jQuery('.e8_box').Tabs({
	     getLine:1,
	     mouldID:"<%= MouldIDConst.getID("workflow")%>",
	     needTopTitle:true,
	     staticOnLoad:true,
	     iframe:"tabcontentframe"
	 });
	 
	 init();
}); 

var dialog = null;
var parentWin = null;
try {
	dialog = parent.getDialog(window);
	parentWin = parent.getParentWindow(window);
} catch (e) {}

function init() {
	//获取相关文档-相关流程-相关附件参数
	var remark = "";
	var workflowRequestLogId = ""
	var forwardflag = "<%=request.getParameter("forwardflag")%>";
	var needwfback = "<%=request.getParameter("needwfback")%>";
	var signdocids = "";
	var signworkflowids = "";
	var field_annexupload = "";
	var remarkLocation = "";
	if (parentWin) {
		try{
		   if(jQuery('#remark', parentWin.document).length > 0){
				remark = parentWin.CkeditorExt.getHtml("remark");
		   }else{
		   		workflowRequestLogId=$G("workflowRequestLogId",parentWin.document).value;
		   }
		}catch(e){}
		try {
	    	signdocids = $G("signdocids", parentWin.document).value;
	    } catch (e) {
	    }
	    try {
	    	signworkflowids = $G("signworkflowids", parentWin.document).value;
	    } catch (e) {
	    }
	    try {
	    	field_annexupload = $G("field-annexupload", parentWin.document).value;
	    } catch (e) {
	    }
		try {
	    	forwardflag = $G("forwardflag", parentWin.document).value;
	    } catch (e) {
	    }
	    try {
	    	remarkLocation = $G("remarkLocation", parentWin.document).value;
	    } catch (e) {
	    }
	    
	}
    $G("remark").value = remark;
    $G("signdocids").value = signdocids;
    $G("signworkflowids").value = signworkflowids;
    $G("field-annexupload").value = field_annexupload;
    $G("workflowRequestLogId").value = workflowRequestLogId;
	$G("forwardflag").value = forwardflag;
	$G("remarkLocation").value = remarkLocation;
    $G("remarkForm").submit();

}
</script>
</head>
<BODY scroll="no">

	<div style="display:none;">
		<form action="<%=url %>" method="post" target="tabcontentframe" id="remarkForm">
			<input type="hidden" name="remark" value="">
			<input type="hidden" name="forwardflag" value="<%=request.getParameter("forwardflag")%>">
			<input type="hidden" name="signdocids" value="">
			<input type="hidden" name="signworkflowids" value="">
			<input type="hidden" name="field-annexupload" value="">
			<input type="hidden" name="workflowRequestLogId" value="">
			<input type="hidden" name="needwfback"  id="needwfback"/>
			<input type="hidden" name="remarkLocation" id="remarkLocation"></input>
		</form>
	</div>
    <div class="e8_box demo2">
		   <div class="e8_boxhead">
		    <div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"><%=requestname%></span>
				</div>
			<div>		
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
			<div class="tab_box">
				<iframe src="" onload="" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			</div>
			
		</div>
</body>
</html>