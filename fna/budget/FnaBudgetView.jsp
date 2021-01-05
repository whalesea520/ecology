<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
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

<%@page import="weaver.fna.general.FnaCommon"%><HTML><HEAD>
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
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("fna") %>",
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(16505, user.getLanguage())) %>,
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

	RecordSet rs = new RecordSet();

	int title = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	int parentid =Util.getIntValue( Util.null2String((String)kv.get("paraid")),0);//
	
	//如果未设置生效或关闭的预算期间，则提示用户设置期间
	rs.executeSql("select count(*) cnt from FnaYearsPeriods WHERE status <> 0");
    if(!(rs.next() && rs.getInt("cnt") > 0)){
       response.sendRedirect("/fna/budget/FnaBudgetHelp.jsp");
       return;
    }
	
	BudgetHandler budgetHandler = new BudgetHandler();
	
	String currentDate = TimeUtil.getCurrentDateString();

    String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
    String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
    int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
    int budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), 0);//预算年度id
    boolean edit = "true".equalsIgnoreCase(Util.null2String(request.getParameter("edit")).trim());//是否直接打开编辑页面
    int status = 0;//预算状态
    int revision = 0;//预算版本
	
    if(!"".equals(organizationtype) && !"".equals(organizationid)){
    	//如果没有预算版本id
    	if(budgetinfoid <= 0){
    		//如果没有预算年度id
        	if(budgetperiods <= 0){
        		BudgetYear currentEnableBudgetYear = BudgetHandler.getDefBudgetYear();
        	    if(currentEnableBudgetYear==null){
        	        response.sendRedirect("/fna/budget/FnaBudgetHelp.jsp");
        	        return;
        	     }
        		budgetperiods = currentEnableBudgetYear.getPeriod();
        	}
    		budgetinfoid = BudgetHandler.getAndCreateDefFnaBudgetInfoId(organizationtype, organizationid, budgetperiods+"", user.getUID(), user, false);
    	}
    }
    
    //通过预算版本id获取：预算单位类型、预算单位和预算年度id
    if(budgetinfoid > 0){
    	String sql = "select a.organizationtype, a.budgetorganizationid, a.budgetperiods, a.status, a.revision from FnaBudgetInfo a where a.id = "+budgetinfoid;
    	rs.executeSql(sql);
    	if(rs.next()){
    		organizationtype = Util.null2String(rs.getString("organizationtype")).trim();
    		organizationid = Util.null2String(rs.getString("budgetorganizationid")).trim();
    		budgetperiods = rs.getInt("budgetperiods");
    		status = rs.getInt("status");
    		revision = rs.getInt("revision");
    	}
    }

	String FnaCommon_checkPermissionsFnaBudgetForEdit = "FnaCommon_checkPermissionsFnaBudgetForEdit_orgType_"+organizationtype+"_orgId_"+organizationid+"_userId_"+user.getUID();
	boolean fnaBudgetViewFlagForEdit = false;
	if(request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForEdit)==null){
		fnaBudgetViewFlagForEdit = FnaCommon.checkPermissionsFnaBudgetForEdit(organizationtype, organizationid, user.getUID());
		request.getSession().setAttribute(FnaCommon_checkPermissionsFnaBudgetForEdit, fnaBudgetViewFlagForEdit?"true":"false");
	}else{
		fnaBudgetViewFlagForEdit = "true".equalsIgnoreCase((String)request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForEdit));
	}
	String FnaCommon_checkPermissionsFnaBudgetForView = "FnaCommon_checkPermissionsFnaBudgetForView_orgType_"+organizationtype+"_orgId_"+organizationid+"_userId_"+user.getUID();
	boolean fnaBudgetViewFlagForView = false;
	if(request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForView)==null){
		fnaBudgetViewFlagForView = FnaCommon.checkPermissionsFnaBudgetForView(organizationtype, organizationid, user.getUID());
		request.getSession().setAttribute(FnaCommon_checkPermissionsFnaBudgetForView, fnaBudgetViewFlagForView?"true":"false");
	}else{
		fnaBudgetViewFlagForView = "true".equalsIgnoreCase((String)request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForView));
	}
	//如果没有传入具体哪个预算机构，或者有传入具体哪个预算机构，并判断为不允许允许查看的，则提示无权限
	if(!fnaBudgetViewFlagForEdit && !fnaBudgetViewFlagForView){
		response.sendRedirect("/fna/budget/FnaBudgetGrid.jsp?organizationtype="+organizationtype+"&organizationid="+organizationid);
		return;
	}
	
    String commonPara = "organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+budgetinfoid+"&budgetperiods="+budgetperiods+
    		"&status="+status+"&revision="+revision;
	String ysxxUrl = "/fna/budget/FnaBudgetViewInner1.jsp?"+commonPara;

	String bblsUrl = "/fna/budget/FnaBudgetHistoryView.jsp?"+commonPara;
	String xjysUrl = "/fna/budget/FnaBudgetGridInner.jsp?"+commonPara;
	

	FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
	String orgName = fnaSplitPageTransmethod.getOrgName(organizationid, organizationtype);
	if("".equals(orgName)){
		orgName = JSONObject.quote(SystemEnv.getHtmlLabelName(16505, user.getLanguage()));
	}
	
	String xjysName = "";
	if("0".equals(organizationtype)){
		xjysName = SystemEnv.getHtmlLabelName(18654,user.getLanguage());//分部预算
	}else if("1".equals(organizationtype)){
		xjysName = SystemEnv.getHtmlLabelName(15401,user.getLanguage());//部门预算
	}else if("2".equals(organizationtype)){
		xjysName = SystemEnv.getHtmlLabelName(15402,user.getLanguage());//个人预算
	}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
		xjysName = SystemEnv.getHtmlLabelNames("515,386",user.getLanguage());//成本中心预算
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
		    		<li class="current">
			        	<a id="divMainInfo" href="<%=ysxxUrl %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(33045,user.getLanguage()) %><!-- 预算信息 --> 
			        	</a>
			        </li>
		    		<li>
			        	<a href="<%=bblsUrl %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(18552,user.getLanguage()) %><!-- 版本历史 --> 
			        	</a>
			        </li>
		        <%
		        if(!"3".equals(organizationtype) && !(FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
		        %>
		    		<li>
			        	<a href="<%=xjysUrl %>" target="tabcontentframe"><!-- 下级组织架构预算grid --> 
			        		<%=xjysName %>
			        	</a>
			        </li>
		        <%
				}
		        %>
			    </ul>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=ysxxUrl+"&edit="+edit %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
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

