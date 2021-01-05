<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.budget.BudgetYear"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<!-- 自定义设置tab页 -->
<%
String resourceid = Util.null2String(request.getParameter("resourceid")) ; 
String fnayear = Util.null2String(request.getParameter("fnayear")) ; 

String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

//added by lupeng 2004.2.3
//if the user is himself                                                 ok
//if the resourceid is the user's follower                  ok
//if the user have the right of viewing budget          ok
boolean isManager = false;
String managerStr = "";
RecordSet.executeSql(" select managerstr from hrmresource where id = " + resourceid ) ;
if ( RecordSet.next() ) managerStr = Util.null2String(RecordSet.getString(1)) ;
if (managerStr.indexOf(String.valueOf(user.getUID())) != -1)
    isManager = true;

boolean isSameDept = false;
RecordSet.executeSql(" select departmentid from hrmresource where id = " + resourceid ) ;
if ( RecordSet.next() && (user.getUserDepartment() == RecordSet.getInt(1)) )
    isSameDept = true;

if (String.valueOf(user.getUID()).equals(resourceid)) {
    //it's ok.
} else if (isManager) {
    //it's ok.
} else if (HrmUserVarify.checkUserRight("FnaBudget:All" , user) && isSameDept) {
    //it's ok.
} else {
    response.sendRedirect("/notice/noright.jsp") ;
 return ;
}
	
String ysxxUrl = "/fna/report/budget/FnaBudgetResourceDetailInner.jsp?resourceid="+resourceid+"&fnayear="+fnayear;
%>
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("fna") %>",
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(179 , user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())) %>,
        staticOnLoad:true
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
						<a href="#">
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
	            <iframe src="<%=ysxxUrl %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

