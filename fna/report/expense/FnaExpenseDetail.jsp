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
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
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
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("fna") %>",
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(16505, user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
<%
	boolean canView = true;//可查看
	
	String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
	String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
	String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID
	
	String budgetyears = "";//期间年
	
	String sqlstr = "";
	char separator = Util.getSeparator();
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
	        Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	        Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	
	//如果期间为空
	if ("".equals(budgetperiods)) {
	    //取前一次操作的期间
	    budgetperiods = (String) session.getAttribute("budgetperiods");
	    //System.out.println("session budgetperiods:"+budgetperiods);
	    if (budgetperiods == null || "".equals(budgetperiods)) {
	        //如果未取到，取得默认生效期间
	        sqlstr = " select id from FnaYearsPeriods where status = 1 order by fnayear desc";
	        RecordSet.executeSql(sqlstr);
	        if (RecordSet.next()) {
	            budgetperiods = RecordSet.getString("id");
	        } else {
	            //如果未取到，取最大年
	            RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear", "");
	            if (RecordSet.next()) {
	                budgetperiods = RecordSet.getString("id");
	            }
	        }
	        //System.out.println("empty budgetperiods:"+budgetperiods);
	    }
	} else {
	    session.setAttribute("budgetperiods", budgetperiods);
	}
	
	//如果组织为空，取得当前期间默认总公司
	//检查权限
	int right = -1;//-1：禁止、0：只读、1：编辑、2：完全操作
	if ("0".equals(organizationtype) || "".equals(organizationid)) {
	    organizationid = "1";
	    organizationtype = "0";
	    if (HrmUserVarify.checkUserRight("HeadBudget:Maint", user)) {
	        right = Util.getIntValue(HrmUserVarify.getRightLevel("HeadBudget:Maint", user), 0);
	    } else {
	        organizationtype = "1";
	        SubCompanyComInfo.setTofirstRow();
	        SubCompanyComInfo.next();
	        organizationid = SubCompanyComInfo.getSupsubcomid();
	    }
	}
	if (!"0".equals(organizationtype)) {
	    if (Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0) == 1) {//如果分权
	        int subCompanyId = 0;
	        if ("1".equals(organizationtype))
	            subCompanyId = (new Integer(organizationid)).intValue();
	        else if ("2".equals(organizationtype))
	            subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(organizationid))).intValue();
	        else if ("3".equals(organizationtype))
	            subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(organizationid)))).intValue();
	        right = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "SubBudget:Maint", subCompanyId);
	    } else {
	        if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
	            right = Util.getIntValue(HrmUserVarify.getRightLevel("SubBudget:Maint", user), 0);
	    }
	}
	
	String fnabudgetinfoid = "";
	String status = "";
	if (!"".equals(budgetperiods) && !"".equals(organizationid) && !"".equals(organizationtype)) {
	    sqlstr = " select id,status from FnaBudgetInfo where status in (1,3) and budgetperiods = "
	            + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = "
	            + organizationtype;
	
	    //System.out.println(sqlstr);
	
	    RecordSet.executeSql(sqlstr);
	    if (RecordSet.next()) {
	        fnabudgetinfoid = RecordSet.getString("id");
	        status = RecordSet.getString("status");
	        //System.out.println("get id:"+fnabudgetinfoid+" by revision:"+revision+",budgetperiods:"+budgetperiods+",budgetorganizationid:"+organizationid+",organizationtype:"+organizationtype);
	    }
	} else {
	    canView = false;
	}
	
	if (right < 0) canView = false;//可查看
	
	if (!canView) {
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}

    String commonPara = "organizationid="+organizationid+"&organizationtype="+organizationtype;
	String ysxxUrl = "/fna/report/expense/FnaExpenseDetailInner.jsp?"+commonPara;

	

	FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
	String orgName = fnaSplitPageTransmethod.getOrgName(organizationid, organizationtype);
	if("".equals(orgName)){
		orgName = JSONObject.quote(SystemEnv.getHtmlLabelName(16505, user.getLanguage()));
	}
	
	String orgTypeName = "";
	if("0".equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelNames("140,428",user.getLanguage());//总部收支
	}else if("1".equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelNames("141,428",user.getLanguage());//分部收支
	}else if("2".equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelNames("124,428",user.getLanguage());//部门收支
	}else if("3".equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelNames("6087,428",user.getLanguage());//个人收支
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
	            <iframe src="<%=ysxxUrl %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
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
	setTabObjName("<%=orgName%>（<%=orgTypeName %>）");
});
</script>
</html>

