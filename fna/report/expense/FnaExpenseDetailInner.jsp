<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.budget.Expense"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.CompanyComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
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
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

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

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";


String sql = "";
RecordSet rs = new RecordSet();

DecimalFormat df = new DecimalFormat("####################################################0.00");
CompanyComInfo cci = new CompanyComInfo();
SubCompanyComInfo scci = new SubCompanyComInfo();
DepartmentComInfo dci = new DepartmentComInfo();
ResourceComInfo rci = new ResourceComInfo();
FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();
BudgetHandler budgetHandler = new BudgetHandler();

String orgTypeName = "";
String orgName = "";

if("0".equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(140,user.getLanguage());//总部
	orgName = cci.getCompanyname(organizationid);
}else if("1".equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(141,user.getLanguage());//分部
	orgName = scci.getSubCompanyname(organizationid);
}else if("2".equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(124,user.getLanguage());//部门
	orgName = dci.getDepartmentName(organizationid);
}else if("3".equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(6087,user.getLanguage());//个人
	orgName = rci.getLastname(organizationid);
}

String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();//打开预算周期tab页类型
if("".equals(tabFeeperiod)){
	tabFeeperiod = "M";
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>

<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
<script type="text/javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
</script>
</head>
<body style="overflow:hidden;">
<form name="form2" method="post"  action="/fna/budget/FnaBudgetViewInner1.jsp">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="div111">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'><!-- 基本信息 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage()) %></wea:item><!-- 预算年度 -->
		<wea:item>
	        <select class="inputstyle" id="budgetperiods" name="budgetperiods" onchange="feeperiod_onchange();" style="width: 80px;">
			<%
			sql = "select a.id, a.fnayear from FnaYearsPeriods a WHERE a.status in (1, -1) ORDER BY a.fnayear DESC ";
			rs.executeSql(sql);
			while(rs.next()){
				int _id = rs.getInt("id");
				int _fnayear = rs.getInt("fnayear");
			%>
				<option value="<%=_id %>" <% if(_id == Util.getIntValue(budgetperiods)){%>selected<%}%>><%=_fnayear%></option>
			<%
			}
			%>
	        </select>
	        <input id="budgetperiods" name="budgetperiods" value="<%=budgetperiods %>" type="hidden" />
	        <input id="tabFeeperiod" name="tabFeeperiod" value="<%=tabFeeperiod %>" type="hidden" />
	        <input id="organizationtype" name="organizationtype" value="<%=organizationtype %>" type="hidden" />
	        <input id="organizationid" name="organizationid" value="<%=organizationid %>" type="hidden" />
	        <input id="fnabudgetinfoid" name="fnabudgetinfoid" value="<%=fnabudgetinfoid %>" type="hidden" />
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></wea:item><!-- 预算年度 -->
		<wea:item>
			<% if (status.equals("1")) {%><%=SystemEnv.getHtmlLabelName(18431, user.getLanguage())%><%} else if (status.equals("3")) { %><%=SystemEnv.getHtmlLabelName(2242, user.getLanguage())%><%}%>
       	</wea:item>
	</wea:group>
</wea:layout>
</div>

<!-- 预算设置明细数据 -->
<%
String commonPara = "organizationid="+organizationid+"&organizationtype="+organizationtype+"&budgetperiods="+budgetperiods+"&fnabudgetinfoid="+fnabudgetinfoid;
String fnaBudgetViewDataMurl = "/fna/report/expense/FnaExpenseDetailInnerData.jsp?"+commonPara+"&tabFeeperiod=M";
String fnaBudgetViewDataQurl = "/fna/report/expense/FnaExpenseDetailInnerData.jsp?"+commonPara+"&tabFeeperiod=Q";
String fnaBudgetViewDataHurl = "/fna/report/expense/FnaExpenseDetailInnerData.jsp?"+commonPara+"&tabFeeperiod=H";
String fnaBudgetViewDataYurl = "/fna/report/expense/FnaExpenseDetailInnerData.jsp?"+commonPara+"&tabFeeperiod=Y";

String fnaBudgetViewDataUrl = "";

String tab_menu_m_className = "";
String tab_menu_q_className = "";
String tab_menu_h_className = "";
String tab_menu_y_className = "";

if("M".equals(tabFeeperiod)){
	fnaBudgetViewDataUrl = fnaBudgetViewDataMurl;
	tab_menu_m_className = "class=\"current\"";
}else if("Q".equals(tabFeeperiod)){
	fnaBudgetViewDataUrl = fnaBudgetViewDataQurl;
	tab_menu_q_className = "class=\"current\"";
}else if("H".equals(tabFeeperiod)){
	fnaBudgetViewDataUrl = fnaBudgetViewDataHurl;
	tab_menu_h_className = "class=\"current\"";
}else if("Y".equals(tabFeeperiod)){
	fnaBudgetViewDataUrl = fnaBudgetViewDataYurl;
	tab_menu_y_className = "class=\"current\"";
}
%>
<div class="e8_box demo2 e8_boxInner1">
    <ul id="ulInfo1" class="tab_menu">
		<li <%=tab_menu_m_className %>>
			<a id="divMainInfo_m" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataMurl %>');return false;" href="#"><%=SystemEnv.getHtmlLabelName(15370,user.getLanguage()) %></a><!-- 月度预算 -->
		</li>
		<li <%=tab_menu_q_className %>>
			<a id="divMainInfo_q" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataQurl %>');return false;" href="#"><%=SystemEnv.getHtmlLabelName(15373,user.getLanguage()) %></a><!-- 季度预算 -->
		</li>
		<li <%=tab_menu_h_className %>>
			<a id="divMainInfo_h" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataHurl %>');return false;" href="#"><%=SystemEnv.getHtmlLabelName(15374,user.getLanguage()) %></a><!-- 半年预算 -->
		</li>
		<li <%=tab_menu_y_className %>>
			<a id="divMainInfo_y" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataYurl %>');return false;" href="#"><%=SystemEnv.getHtmlLabelName(15375,user.getLanguage()) %></a><!-- 年度预算 -->
		</li>
    </ul>
    <div id="rightBox" class="e8_rightBox">
    </div>
    <div class="tab_box">
        <div>
			<iframe src="<%=fnaBudgetViewDataUrl %>" onload="update();" id="tabcontentframe2" name="tabcontentframe2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
    </div>
</div> 

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display: none;">
</div>

<script language="javascript">
//tab切换事件
function tabMainInfo_onclick(_url,canEdit,edit){
	document.getElementById("tabcontentframe2").src = _url;
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

function feeperiod_onchange(){
	var organizationtype = jQuery("#organizationtype").val();
	var organizationid = jQuery("#organizationid").val();
	var budgetperiods = jQuery("#budgetperiods").val();
	var tabFeeperiod = jQuery("#tabFeeperiod").val();
	var fnabudgetinfoid = jQuery("#fnabudgetinfoid").val();
	
	var commonPara = "organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetperiods="+budgetperiods+"&tabFeeperiod="+tabFeeperiod+"&fnabudgetinfoid="+fnabudgetinfoid;
	parent.location.href = "/fna/report/expense/FnaExpenseDetail.jsp?"+commonPara;
}

jQuery('.e8_boxInner1').Tabs({
	getLine:1,
	iframe:"tabcontentframe2",
	staticOnLoad:true,
	noParentMenu:true
});

</script>
</form>
</body>
</html>
