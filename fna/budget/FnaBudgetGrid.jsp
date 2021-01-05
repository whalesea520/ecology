<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
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
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33177, user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
<%
	boolean canView = HrmUserVarify.checkUserRight("BudgetAuthorityRule:readOnly", user);//预算编制只读权限
	boolean canEdit = (HrmUserVarify.checkUserRight("FnaBudget:View", user) || 
			HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) || 
			HrmUserVarify.checkUserRight("BudgetAuthorityRule:edit", user));//财务预算维护、预算编制权限
	if(!canView && !canEdit){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	int title = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	int parentid =Util.getIntValue( Util.null2String((String)kv.get("paraid")),0);//
	
	RecordSet rs = new RecordSet();

	String organizationtype = Util.null2String(request.getParameter("organizationtype")).trim();
	String organizationid = Util.null2String(request.getParameter("organizationid")).trim();

	String url = "/fna/budget/FnaBudgetGridInner.jsp?organizationtype="+organizationtype+"&organizationid="+organizationid;

	FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
	String orgName = fnaSplitPageTransmethod.getOrgName(organizationid, organizationtype);
	if("".equals(orgName)){
		orgName = SystemEnv.getHtmlLabelName(33177, user.getLanguage());
	}
	
	String FnaCommon_checkPermissionsFnaBudgetForView = "FnaCommon_checkPermissionsFnaBudgetForView_orgType_"+organizationtype+"_orgId_"+organizationid+"_userId_"+user.getUID();
	boolean fnaBudgetViewFlagForView = false;
	if(request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForView)==null){
		fnaBudgetViewFlagForView = FnaCommon.checkPermissionsFnaBudgetForView(organizationtype, organizationid, user.getUID());
		request.getSession().setAttribute(FnaCommon_checkPermissionsFnaBudgetForView, fnaBudgetViewFlagForView?"true":"false");
	}else{
		fnaBudgetViewFlagForView = "true".equalsIgnoreCase((String)request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForView));
	}
    
    //如果有传入具体哪个预算机构，并判断为允许查看的，则再次跳转到预算查看界面，否则，显示预算概览
    if(fnaBudgetViewFlagForView){
		//response.sendRedirect("/fna/budget/FnaBudgetView.jsp?organizationtype="+organizationtype+"&organizationid="+organizationid);
%>
		<script type="text/javascript">
		window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationtype=<%=organizationtype %>&organizationid=<%=organizationid %>";
		</script>
<%
		return;
    }
%>
</head>			        
<BODY scroll="no">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo" onclick="mnToggleleft(this);"></div>
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
	            <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<script type="text/javascript">
function mnToggleleft(obj){
	if(window!=null&&window.parent!=null&&window.parent.oTd1!=null&&window.parent.oTd1.style!=null){
		var f = window.parent.oTd1.style.display;
		if(f==null||f==""){
			obj.innerHTML=obj.innerHTML.replace("&lt;&lt;","&gt;&gt;");
			window.parent.oTd1.style.display='none';
		}else{
			obj.innerHTML=obj.innerHTML.replace("&gt;&gt;","&lt;&lt;");
			window.parent.oTd1.style.display='';
		}
	}
}
jQuery(document).ready(function(){
	setTabObjName("<%=orgName%>");
});
</script>
</html>
