<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.hrm.company.CompanyComInfo"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>

<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
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

	DecimalFormat df = new DecimalFormat("####################################################0.00");
	FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
	CompanyComInfo cci = new CompanyComInfo();
	SubCompanyComInfo scci = new SubCompanyComInfo();
	DepartmentComInfo dci = new DepartmentComInfo();
	ResourceComInfo rci = new ResourceComInfo();
	FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();
	BudgetHandler budgetHandler = new BudgetHandler();

	RecordSet rs = new RecordSet();
	
	int title = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	int parentid =Util.getIntValue( Util.null2String((String)kv.get("paraid")),0);//

    String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
    String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
    String budgetinfoid = Util.null2String(request.getParameter("budgetinfoid"));
    String[] historyRevisionArray = request.getParameterValues("historyRevision");//要对比的两个预算版本id
    int budgetinfoid_1 = Util.getIntValue(request.getParameter("budgetinfoid_1"), -1);
    int budgetinfoid_2 = Util.getIntValue(request.getParameter("budgetinfoid_2"), -1);

	String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();//打开预算周期tab页类型
	if("".equals(tabFeeperiod)){
		tabFeeperiod = "M";
	}
	
	int _idx = 0;
	String sql = "select a.id \n" +
			" from FnaBudgetInfo a \n" +
			" where a.id in ("+budgetinfoid_1+","+budgetinfoid_2+") \n" +
			" ORDER BY (CASE WHEN (a.status=0) THEN 1 WHEN (a.status=1 OR a.status=3) THEN 2 ELSE 3 END) ASC, a.revision DESC";
	rs.executeSql(sql);
	while(rs.next()){
		if(_idx==0){
			budgetinfoid_1 = rs.getInt("id");
		}else{
			budgetinfoid_2 = rs.getInt("id");
		}
		_idx++;
	}

    String commonPara = "organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid_1="+budgetinfoid_1+"&budgetinfoid_2="+budgetinfoid_2;
    
	boolean fnaBudgetViewFlag = false;
    if("0".equals(organizationtype)){
    	if(FnaBudgetLeftRuleSet.isAllowCmp(user.getUID())){
    		fnaBudgetViewFlag = true;
    	}
    }else if("1".equals(organizationtype)){
    	List<String> allowOrgId_list = new ArrayList<String>();
    	boolean allowOrgId = FnaBudgetLeftRuleSet.getAllowSubCmpId(user.getUID(), allowOrgId_list);
    	if(allowOrgId || allowOrgId_list.contains(organizationid)){
    		fnaBudgetViewFlag = true;
    	}
    }else if("2".equals(organizationtype)){
    	List<String> allowOrgId_list = new ArrayList<String>();
    	boolean allowOrgId = FnaBudgetLeftRuleSet.getAllowDepId(user.getUID(), allowOrgId_list);
    	if(allowOrgId || allowOrgId_list.contains(organizationid)){
    		fnaBudgetViewFlag = true;
    	}
    }else if("3".equals(organizationtype)){
		List<String> __orgId_list = new ArrayList<String>();
		__orgId_list.add(organizationid);
		List<String> allowOrgId_list = new ArrayList<String>();
		boolean allowOrgId = FnaBudgetLeftRuleSet.getAllowHrmId(user.getUID(), null, null, __orgId_list, allowOrgId_list);
    	if(allowOrgId || allowOrgId_list.contains(organizationid)){
    		fnaBudgetViewFlag = true;
    	}
    }else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
    	List<String> allowOrgId_list = new ArrayList<String>();
    	boolean allowOrgId = FnaBudgetLeftRuleSet.getAllowFccId(user.getUID(), allowOrgId_list);
    	if(allowOrgId || allowOrgId_list.contains(organizationid)){
    		fnaBudgetViewFlag = true;
    	}
    }
    //如果没有传入具体哪个预算机构，或者有传入具体哪个预算机构，并判断为不允许允许查看的，则提示无权限
    if(!fnaBudgetViewFlag){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
    }
	
	String ysxxUrl = "/fna/budget/FnaBudgetCompareInner.jsp?";

	String orgTypeName = "";
	String orgName = "";
	
	if("0".equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelName(140,user.getLanguage());//总部
		rs.executeSql("select companyname from hrmCompany");
		if(rs.next()){
			orgName = Util.null2String(rs.getString("companyname")).trim();
		}
	}else if("1".equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelName(141,user.getLanguage());//分部
		rs.executeSql("select subcompanyname from HrmSubCompany where id="+Util.getIntValue(organizationid));
		if(rs.next()){
			orgName = Util.null2String(rs.getString("subcompanyname")).trim();
		}
	}else if("2".equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelName(124,user.getLanguage());//部门
		rs.executeSql("select departmentname from HrmDepartment where id="+Util.getIntValue(organizationid));
		if(rs.next()){
			orgName = Util.null2String(rs.getString("departmentname")).trim();
		}
	}else if("3".equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelName(6087,user.getLanguage());//个人
		rs.executeSql("select lastname from HrmResource where id="+Util.getIntValue(organizationid));
		if(rs.next()){
			orgName = Util.null2String(rs.getString("lastname")).trim();
		}
	}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
		orgTypeName = SystemEnv.getHtmlLabelName(515,user.getLanguage());//成本中心
		rs.executeSql("select name from FnaCostCenter where id="+Util.getIntValue(organizationid));
		if(rs.next()){
			orgName = Util.null2String(rs.getString("name")).trim();
		}
	}
	
	int fnayear = 0;
	int revision1 = -1;
	int status1 = -1;
	double sum_budgetaccount1 = 0.00;
	sql = "select c.fnayear, a.revision, a.status, SUM (b.budgetaccount) sum_budgetaccount "+
		" from FnaBudgetInfo a "+
		" JOIN FnaBudgetInfoDetail b ON a.id = b.budgetinfoid "+ 
		" join FnaYearsPeriods c on a.budgetperiods = c.id "+
		" where a.id = "+budgetinfoid_1+" "+
		" GROUP BY c.fnayear, a.revision, a.status ";
	rs.executeSql(sql);
	if(rs.next()){
		fnayear = rs.getInt("fnayear");
		revision1 = rs.getInt("revision");
		status1 = rs.getInt("status");
		sum_budgetaccount1 = Util.getDoubleValue(df.format(Util.getDoubleValue(rs.getString("sum_budgetaccount"))), 0.00);
	}
	String revision1Name = "V"+revision1;
	if(revision1==0){
		revision1Name=SystemEnv.getHtmlLabelName(220,user.getLanguage());//草稿
	}
	if(status1==3){
		revision1Name=SystemEnv.getHtmlLabelName(2242,user.getLanguage());//待审批
	}

	int revision2 = -1;
	int status2 = -1;
	double sum_budgetaccount2 = 0.00;
	sql = "select a.revision, a.status, SUM (b.budgetaccount) sum_budgetaccount "+
		" from FnaBudgetInfo a "+
		" JOIN FnaBudgetInfoDetail b ON a.id = b.budgetinfoid "+ 
		" where a.id = "+budgetinfoid_2+" "+
		" GROUP BY a.revision, a.status ";
	rs.executeSql(sql);
	if(rs.next()){
		revision2 = rs.getInt("revision");
		status2 = rs.getInt("status");
		sum_budgetaccount2 = Util.getDoubleValue(df.format(Util.getDoubleValue(rs.getString("sum_budgetaccount"))), 0.00);
	}
	String revision2Name = "V"+revision2;
	if(revision2==0){
		revision2Name=SystemEnv.getHtmlLabelName(220,user.getLanguage());//草稿
	}
	if(status2==3){
		revision2Name=SystemEnv.getHtmlLabelName(2242,user.getLanguage());//待审批
	}
	
	double sum_budgetaccount_diff = sum_budgetaccount1 - sum_budgetaccount2;
	String sum_budgetaccount_diff_name = "";
	if(sum_budgetaccount_diff < 0){
		sum_budgetaccount_diff_name = "<font color='red'>"+fnaSplitPageTransmethod.fmtAmountQuartile(sum_budgetaccount_diff)+"</font>";
	}else if(sum_budgetaccount_diff > 0){
		sum_budgetaccount_diff_name = "<font color='blue'>"+fnaSplitPageTransmethod.fmtAmountQuartile(sum_budgetaccount_diff)+"</font>";
	}else{
		sum_budgetaccount_diff_name = fnaSplitPageTransmethod.fmtAmountQuartile(sum_budgetaccount_diff);
	}
	
%>
</head>			        
<BODY scroll="no">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>" id="btnSaveAppover"
				class="e8_btn_top" onclick="goBack();"/><!-- 返回 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>


<div id="div111" style="scr">
<wea:layout type="4col">
	<wea:group context="" attributes="{\"groupDisplay\":\"none\"}" ><!-- 版本历史 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(376,user.getLanguage())+SystemEnv.getHtmlLabelName(26505,user.getLanguage()) %></wea:item><!-- 组织机构 -->
		<wea:item>
			<%=FnaCommon.escapeHtml(orgName) %><span style="color: black; font-weight: bold;">(<%=FnaCommon.escapeHtml(orgTypeName) %>)</span>
       		<input id="organizationtype" name="organizationtype" value="<%=organizationtype%>" type="hidden" />
       		<input id="organizationid" name="organizationid" value="<%=organizationid%>" type="hidden" />
       		<input id="tabFeeperiod" name="tabFeeperiod" value="<%=tabFeeperiod%>" type="hidden" />
       		<input id="budgetinfoid_1" name="budgetinfoid_1" value="<%=budgetinfoid_1%>" type="hidden" />
       		<input id="budgetinfoid_2" name="budgetinfoid_2" value="<%=budgetinfoid_2%>" type="hidden" />
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage()) %></wea:item><!-- 预算年度 -->
		<wea:item>
			<%=fnayear %>
       	</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelName(18501,user.getLanguage())+"("+revision1Name+")" %></wea:item><!-- 预算总额V1 -->
		<wea:item>
			<%=fnaSplitPageTransmethod.fmtAmountQuartile(sum_budgetaccount1) %>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18501,user.getLanguage())+"("+revision2Name+")" %></wea:item><!-- 预算总额V2 -->
		<wea:item>
			<%=fnaSplitPageTransmethod.fmtAmountQuartile(sum_budgetaccount2) %>
       	</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelName(18751,user.getLanguage()) %></wea:item><!-- 变更差额 -->
		<wea:item>
			<%=sum_budgetaccount_diff_name %>
       	</wea:item>
		<wea:item></wea:item>
		<wea:item>
       	</wea:item>
	</wea:group>
</wea:layout>
</div>

<!-- 预算设置明细数据 -->
<%
String fnaBudgetViewDataMurl = "/fna/budget/FnaBudgetCompareInner.jsp?"+commonPara+"&tabFeeperiod=M";
String fnaBudgetViewDataQurl = "/fna/budget/FnaBudgetCompareInner.jsp?"+commonPara+"&tabFeeperiod=Q";
String fnaBudgetViewDataHurl = "/fna/budget/FnaBudgetCompareInner.jsp?"+commonPara+"&tabFeeperiod=H";
String fnaBudgetViewDataYurl = "/fna/budget/FnaBudgetCompareInner.jsp?"+commonPara+"&tabFeeperiod=Y";

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
			<a id="divMainInfo_m" href="<%=fnaBudgetViewDataMurl %>" target="tabcontentframe2"><%=SystemEnv.getHtmlLabelName(15370,user.getLanguage()) %></a><!-- 月度预算 -->
		</li>
		<li <%=tab_menu_q_className %>>
			<a id="divMainInfo_q" href="<%=fnaBudgetViewDataQurl %>" target="tabcontentframe2"><%=SystemEnv.getHtmlLabelName(15373,user.getLanguage()) %></a><!-- 季度预算 -->
		</li>
		<li <%=tab_menu_h_className %>>
			<a id="divMainInfo_h" href="<%=fnaBudgetViewDataHurl %>" target="tabcontentframe2"><%=SystemEnv.getHtmlLabelName(15374,user.getLanguage()) %></a><!-- 半年预算 -->
		</li>
		<li <%=tab_menu_y_className %>>
			<a id="divMainInfo_y" href="<%=fnaBudgetViewDataYurl %>" target="tabcontentframe2"><%=SystemEnv.getHtmlLabelName(15375,user.getLanguage()) %></a><!-- 年度预算 -->
		</li>
		<li></li>
    </ul>
    <div id="rightBox" class="e8_rightBox">
    </div>
    <div class="tab_box">
        <div>
			<iframe src="<%=fnaBudgetViewDataUrl %>" onload="update();reSize_frmTabcontentframe2();" id="tabcontentframe2" name="tabcontentframe2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
    </div>
</div> 
</body>
<script type="text/javascript">


var _init_frmTabcontentframe2_height = 0;
var _is_reSize_frmTabcontentframe2 = false;
function reSize_frmTabcontentframe2(){
	/*
	if(!_is_reSize_frmTabcontentframe2){
		_is_reSize_frmTabcontentframe2 = true;
		var _frmTabcontentframe2 = document.getElementById("tabcontentframe2");
		var h1 = _frmTabcontentframe2.style.height.replace("px", "");
		if(_init_frmTabcontentframe2_height <= 0){
			_init_frmTabcontentframe2_height = fnaRound(h1, 0);
		}
		var _ulInfo1 = jQuery("#ulInfo1");
		var h21 = _ulInfo1.css("line-height").replace("px", "");
		var _div111 = jQuery("#div111");
		var h22 = _div111.css("height").replace("px", "");
		var h2 = fnaRound(fnaRound(h22, 0)+(fnaRound(h21, 0)/2), 0);
		var h3 = fnaRound(fnaRound(_init_frmTabcontentframe2_height, 0)-fnaRound(h2, 0), 0);
		alert("h1="+h1+";h3="+h3);
		_frmTabcontentframe2.style.height=h3+"px";
	}
	*/
}

jQuery('.e8_boxInner1').Tabs({
	getLine:1,
	iframe:"tabcontentframe2",
	staticOnLoad:true
});

function goBack(){
	document.location.href = "/fna/budget/FnaBudgetHistoryView.jsp?organizationtype=<%=organizationtype %>&organizationid=<%=organizationid %>&tabFeeperiod=<%=tabFeeperiod %>&budgetinfoid=<%=budgetinfoid %>";
}

</script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} ";//返回
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</html>

