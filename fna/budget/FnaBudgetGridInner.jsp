<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%
boolean canView = HrmUserVarify.checkUserRight("BudgetAuthorityRule:readOnly", user);//预算编制只读权限
boolean canEdit = (HrmUserVarify.checkUserRight("FnaBudget:View", user) || 
		HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) || 
		HrmUserVarify.checkUserRight("BudgetAuthorityRule:edit", user));//财务预算维护、预算编制权限
if(!canView && !canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
int budgetControlType2 = Util.getIntValue(fnaSystemSetComInfo.get_budgetControlType2(), 0);

BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33060,user.getLanguage());//预算概览
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String organizationtype = Util.null2String(request.getParameter("organizationtype")).trim();
String organizationid = Util.null2String(request.getParameter("organizationid")).trim();

boolean isViewFcc = false;
if("fccType".equals(organizationtype) || (FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
	isViewFcc = true;
}

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post"  action="/fna/budget/FnaBudgetGridInner.jsp">
    <input type="hidden" id="organizationtype" name="organizationtype" value="<%=organizationtype %>" />
    <input type="hidden" id="organizationid" name="organizationid" value="<%=organizationid %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=nameQuery %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<%
List<String> allowSubCmpIdEdit_list = new ArrayList<String>();
boolean allowSubCmpIdEdit = FnaBudgetLeftRuleSet.getAllowSubCmpId(user.getUID(), allowSubCmpIdEdit_list);
List<String> allowDepIdEdit_list = new ArrayList<String>();
boolean allowDepIdEdit = FnaBudgetLeftRuleSet.getAllowDepId(user.getUID(), allowDepIdEdit_list);
List<String> allowHrmIdEdit_list = new ArrayList<String>();
boolean allowHrmIdEdit = FnaBudgetLeftRuleSet.getAllowHrmId(user.getUID(), allowHrmIdEdit_list);
List<String> allowFccIdEdit_list = new ArrayList<String>();
boolean allowFccIdEdit = FnaBudgetLeftRuleSet.getAllowFccId(user.getUID(), allowFccIdEdit_list);

	//设置好搜索条件
	String backFields ="";
	String fromSql = "";
	String sqlWhere = " where 1=1 \n";
	
	if(!"".equals(nameQuery)){
		if(isViewFcc){
			if("fccType".equals(organizationtype)){
				sqlWhere += " and (EXISTS (select 1 from FnaCostCenter h1 where h1.id = a.budgetorganizationid "+
					" and h1.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+") \n";
			}else{
				sqlWhere += " and (a.lastname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n";
			}
		}else{
			if("".equals(organizationtype)){
				sqlWhere += "and ( "+
					" 	(EXISTS (select 1 from HrmCompany h1 where h1.id = a.budgetorganizationid and h1.companyname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = 0) \n" +
					" 	or "+
					" 	(EXISTS (select 1 from HrmSubCompany s1 where s1.id = a.budgetorganizationid and s1.subcompanyname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = 1) \n" +
					" 	or "+
					" 	(EXISTS (select 1 from HrmDepartment d1 where d1.id = a.budgetorganizationid and d1.departmentname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = 2) \n" +
					" ) \n";
			}else if("0".equals(organizationtype)){
				sqlWhere += " and (a.subcompanyname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n";
			}else if("1".equals(organizationtype)){
				sqlWhere += " and (a.departmentname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n";
			}else if("2".equals(organizationtype)){
				sqlWhere += " and (a.lastname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n";
			}
		}
	}

	String sql_flag = "";
	if(isViewFcc){
		if("fccType".equals(organizationtype)){//未点击左侧成本中心树，直接查看所有当前生效预算年度的，有预算生效版本的，预算信息
			sql_flag="1";
			backFields ="c.fnayear, a.id, a.organizationtype, a.budgetorganizationid, a.budgetperiods, sum(b.budgetaccount) sum_budgetaccount, 'ALL' sqlTypeFlag, 0 showorder, '' orgName, "+
					" '"+SystemEnv.getHtmlLabelName(515,user.getLanguage())+"' orgTypeName ";
			fromSql = " from FnaBudgetInfo a "+
					" join FnaBudgetInfoDetail b on a.id = b.budgetinfoid \n" +
					" join FnaYearsPeriods c on a.budgetperiods = c.id ";
			if(user.getUID() != 1 && FnaBudgetLeftRuleSet.enableRuleSet()){
				if(allowFccIdEdit){
					sqlWhere+=(" and (a.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+") ");
				}else if(allowFccIdEdit_list.size() > 0){
					List<String> __allow_list = FnaCommon.initData1(allowFccIdEdit_list);
					int __allow_list_len = __allow_list.size();
					sqlWhere+=(" and ((1=2");
					for(int i=0;i<__allow_list_len;i++){
						sqlWhere+=(" or a.budgetorganizationid in ("+__allow_list.get(i)+")");
					}
					sqlWhere+=(") and a.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+") ");
				}else{
					sqlWhere+=(" and 1=2");
				}
			}
			sqlWhere += " and exists (select 1 from FnaCostCenter fcc where fcc.id = a.budgetorganizationid and fcc.supFccId = "+Util.getIntValue(organizationid, 0)+" ) \n";
			sqlWhere += " and a.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+" and a.status = 1 and c.status = 1 \n";
			String groupBy = " GROUP BY c.fnayear, a.id, a.organizationtype, a.budgetorganizationid, a.budgetperiods \n";
			sqlWhere += groupBy;
			
		}else{//点击成本中心，查看
			sql_flag="2";
			backFields ="c.fnayear, a.id, a.id budgetorganizationid, '"+FnaCostCenter.ORGANIZATION_TYPE+"' organizationtype, a1.budgetperiods, "+
					" '' sum_budgetaccount, '"+FnaCostCenter.ORGANIZATION_TYPE+"' sqlTypeFlag, a.code showorder, a.name orgName, "+
					"'"+SystemEnv.getHtmlLabelName(515,user.getLanguage())+" 'orgTypeName ";
			fromSql = " from FnaCostCenter a "+
			"			join FnaBudgetInfo a1 on a.id = a1.budgetorganizationid and a1.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+" and a1.status = 1  \n" +
			"			join FnaYearsPeriods c on a1.budgetperiods = c.id ";
			sqlWhere += " and ((EXISTS (select 1 from FnaBudgetInfo fbi where fbi.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+" "+
					" and fbi.budgetorganizationid = a.id)) or (a.archive is null or a.archive = '0')) ";
			if(user.getUID() != 1 && FnaBudgetLeftRuleSet.enableRuleSet()){
				if(allowFccIdEdit){
				}else if(allowFccIdEdit_list.size() > 0){
					List<String> __allow_list = FnaCommon.initData1(allowFccIdEdit_list);
					int __allow_list_len = __allow_list.size();
					sqlWhere+=(" and (1=2");
					for(int i=0;i<__allow_list_len;i++){
						sqlWhere+=(" or a.id in ("+__allow_list.get(i)+")");
					}
					sqlWhere+=(") ");
				}else{
					sqlWhere+=(" and 1=2");
				}
			}
			sqlWhere += " and a.supFccId = "+Util.getIntValue(organizationid, 0)+" ";
		}
		
	}else{
		if("".equals(organizationtype)){//未点击左侧组织机构树，直接查看所有当前生效预算年度的，有预算生效版本的，总部、分部、部门预算信息
			sql_flag="3";
			backFields ="c.fnayear, a.id, a.organizationtype, a.budgetorganizationid, a.budgetperiods, sum(b.budgetaccount) sum_budgetaccount, 'ALL' sqlTypeFlag, 0 showorder, '' orgName, "+
					" case when (a.organizationtype=0) then '"+SystemEnv.getHtmlLabelName(140,user.getLanguage())+"' "+
					" when (a.organizationtype=1) then '"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"' "+
					" when (a.organizationtype=2) then '"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"' "+
					" when (a.organizationtype=3) then '"+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+"' else ' ' end orgTypeName ";
			fromSql = " from FnaBudgetInfo a "+
					" join FnaBudgetInfoDetail b on a.id = b.budgetinfoid \n" +
					" join FnaYearsPeriods c on a.budgetperiods = c.id ";
			if(user.getUID() != 1 && FnaBudgetLeftRuleSet.enableRuleSet()){
				sqlWhere += " and ((a.organizationtype = 0) ";
				
				if(allowSubCmpIdEdit){
					sqlWhere+=(" or (a.organizationtype = 1) ");
				}else if(allowSubCmpIdEdit_list.size() > 0){
					List<String> __allow_list = FnaCommon.initData1(allowSubCmpIdEdit_list);
					int __allow_list_len = __allow_list.size();
					sqlWhere+=(" or ((1=2");
					for(int i=0;i<__allow_list_len;i++){
						sqlWhere+=(" or a.budgetorganizationid in ("+__allow_list.get(i)+")");
					}
					sqlWhere+=(") and a.organizationtype = 1) ");
				}

				if(allowDepIdEdit){
					sqlWhere+=(" or (a.organizationtype = 2) ");
				}else if(allowDepIdEdit_list.size() > 0){
					List<String> __allow_list = FnaCommon.initData1(allowDepIdEdit_list);
					int __allow_list_len = __allow_list.size();
					sqlWhere+=(" or ((1=2");
					for(int i=0;i<__allow_list_len;i++){
						sqlWhere+=(" or a.budgetorganizationid in ("+__allow_list.get(i)+")");
					}
					sqlWhere+=(") and a.organizationtype = 2) ");
				}
				
				sqlWhere += " ) ";
				
				if(!FnaBudgetLeftRuleSet.isAllowCmpEdit(user.getUID())){
					sqlWhere += " and a.organizationtype <> 0 ";
				}

				if(allowSubCmpIdEdit){
				}else if(allowSubCmpIdEdit_list.size() > 0){
				}else{
					sqlWhere += " and a.organizationtype <> 1 ";
				}

				if(allowDepIdEdit){
				}else if(allowDepIdEdit_list.size() > 0){
				}else{
					sqlWhere += " and a.organizationtype <> 2 ";
				}
				
			}
			sqlWhere += " and a.organizationtype in (0,1,2) and a.status = 1 and c.status = 1 \n";
			String groupBy = " GROUP BY c.fnayear, a.id, a.organizationtype, a.budgetorganizationid, a.budgetperiods \n";
			sqlWhere += groupBy;
			
		}else if("0".equals(organizationtype)){//点击总部，查看总部的直属分部
			sql_flag="4";
			backFields ="c.fnayear, a.id, a.id budgetorganizationid, '1' organizationtype, a1.budgetperiods, '' sum_budgetaccount, '1' sqlTypeFlag, a.showorder, a.subcompanyname orgName, "+
					"'"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+" 'orgTypeName ";
			fromSql = " from HrmSubCompany a "+
			"			join FnaBudgetInfo a1 on a.id = a1.budgetorganizationid and a1.organizationtype = 1 and a1.status = 1  \n" +
			"			join FnaYearsPeriods c on a1.budgetperiods = c.id ";
			sqlWhere += " and ((EXISTS (select 1 from FnaBudgetInfo fbi where fbi.organizationtype = 1 and fbi.budgetorganizationid = a.id)) or (a.canceled is null or a.canceled = '0')) ";
			if(user.getUID() != 1 && FnaBudgetLeftRuleSet.enableRuleSet()){
				if(allowSubCmpIdEdit){
				}else if(allowSubCmpIdEdit_list.size() > 0){
					List<String> __allow_list = FnaCommon.initData1(allowSubCmpIdEdit_list);
					int __allow_list_len = __allow_list.size();
					sqlWhere+=(" and (1=2");
					for(int i=0;i<__allow_list_len;i++){
						sqlWhere+=(" or a.id in ("+__allow_list.get(i)+")");
					}
					sqlWhere+=(") ");
				}else{
					sqlWhere += " and 1=2 ";
				}
			}
			sqlWhere += " and a.supsubcomid = 0 ";
			
		}else if("1".equals(organizationtype)){//点击分部，查看分部的直属部门
			sql_flag="5";
			backFields ="c.fnayear, a.id, a.id budgetorganizationid, '2' organizationtype, a1.budgetperiods, '' sum_budgetaccount, '2' sqlTypeFlag, a.showorder, a.departmentname orgName, "+
					"'"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+" 'orgTypeName ";
			fromSql = " from HrmDepartment a "+
			"			join FnaBudgetInfo a1 on a.id = a1.budgetorganizationid and a1.organizationtype = 2 and a1.status = 1  \n" +
			"			join FnaYearsPeriods c on a1.budgetperiods = c.id ";
			sqlWhere += " and ((EXISTS (select 1 from FnaBudgetInfo fbi where fbi.organizationtype = 2 and fbi.budgetorganizationid = a.id)) or (a.canceled is null or a.canceled = '0')) ";
			if(user.getUID() != 1 && FnaBudgetLeftRuleSet.enableRuleSet()){
				if(allowDepIdEdit){
				}else if(allowDepIdEdit_list.size() > 0){
					List<String> __allow_list = FnaCommon.initData1(allowDepIdEdit_list);
					int __allow_list_len = __allow_list.size();
					sqlWhere+=(" and (1=2");
					for(int i=0;i<__allow_list_len;i++){
						sqlWhere+=(" or a.id in ("+__allow_list.get(i)+")");
					}
					sqlWhere+=(") ");
				}else{
					sqlWhere += " and 1=2 ";
				}
			}
			sqlWhere += " and a.subcompanyid1 = "+Util.getIntValue(organizationid, 0)+" and a.supdepid = 0 ";
			
		}else if("2".equals(organizationtype)){//点击部门，查看部门的直属人员
			sql_flag="6";
			backFields ="c.fnayear, a.id, a.id budgetorganizationid, '3' organizationtype, a1.budgetperiods, '' sum_budgetaccount, '3' sqlTypeFlag, a.dsporder showorder, a.lastname orgName, "+
					"'"+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+" 'orgTypeName ";
			fromSql = " from HrmResource a "+
			"			left join FnaBudgetInfo a1 on a.id = a1.budgetorganizationid and a1.organizationtype = 3 and a1.status = 1  \n" +
			"			left join FnaYearsPeriods c on a1.budgetperiods = c.id ";
			sqlWhere += " and ((EXISTS (select 1 from FnaBudgetInfo fbi where fbi.organizationtype = 3 and fbi.budgetorganizationid = a.id)) or (a.status in (0,1,2,3))) ";
			if(user.getUID() != 1 && FnaBudgetLeftRuleSet.enableRuleSet()){
				if(allowHrmIdEdit){
				}else if(allowDepIdEdit_list.size() > 0){
					List<String> __allow_list = FnaCommon.initData1(allowDepIdEdit_list);
					int __allow_list_len = __allow_list.size();
					sqlWhere+=(" and (1=2");
					for(int i=0;i<__allow_list_len;i++){
						sqlWhere+=(" or a.departmentid in ("+__allow_list.get(i)+")");
					}
					sqlWhere+=(") ");
				}else{
					sqlWhere += " and 1=2 ";
				}
			}
			sqlWhere += " and a.departmentid = "+Util.getIntValue(organizationid, 0)+" ";
			
		}
	}
	
	String orderBy = " (t11.fnayear*-1), t11.organizationtype, t11.showorder, t11.orgName, t11.budgetorganizationid ";
	
	String sqlprimarykey = "t11.id";
	
	String innerSql = "select "+backFields+" "+fromSql+" "+sqlWhere;
	
	backFields = " * ";
	fromSql = " from ("+innerSql+") t11 ";
	sqlWhere = "";
	

	//out.println("sql_flag="+sql_flag+"<br />"+"select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	String width = "17%";
	if(isViewFcc){
		width = "23%";
	}
	
	String tableString=""+
       "<table instanceid=\"FNA_BUDGET_GRID_INNER_LIST\" pageId=\""+PageIdConst.FNA_BUDGET_GRID_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_BUDGET_GRID_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"Asc\" />"+
       "<head>"+
			"<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(17138,user.getLanguage())+"\" column=\"fnayear\" />"+//年度
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(33062,user.getLanguage())+"\" column=\"budgetorganizationid\" "+//机构名称
					" otherpara=\"column:organizationtype+column:id\" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getOrgNameFnaBudgetGridInner\" />"+
			"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelNames("26505,63",user.getLanguage())+"\" column=\"orgTypeName\" "+//机构类型
					" />"+
									
			"<col width=\""+width+"\"  text=\""+SystemEnv.getHtmlLabelName(18501,user.getLanguage())+"\" column=\"sum_budgetaccount\" "+//预算总额
					" otherpara=\"column:budgetorganizationid+column:organizationtype+column:budgetperiods+column:sqlTypeFlag\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getYsZje\" align=\"right\" />";
	if(!isViewFcc && budgetControlType2!=1){
		tableString += "<col width=\""+width+"\"  text=\""+SystemEnv.getHtmlLabelName(18502,user.getLanguage())+"\" column=\"id\" "+//已分配/汇总预算
						" otherpara=\"column:budgetorganizationid+column:organizationtype+column:budgetperiods+column:sum_budgetaccount+column:sqlTypeFlag\" "+
						" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getYfpJe\" align=\"right\" />";
	}
	tableString += "<col width=\""+width+"\"  text=\""+SystemEnv.getHtmlLabelName(18503,user.getLanguage())+"\" column=\"id\" "+//已发生费用
					" otherpara=\"column:budgetorganizationid+column:organizationtype+column:budgetperiods+column:sum_budgetaccount+column:sqlTypeFlag\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getYfsJe\" align=\"right\" />"+
			"<col width=\""+width+"\"  text=\""+SystemEnv.getHtmlLabelName(18769,user.getLanguage())+"\" column=\"id\" "+//审批中费用
					" otherpara=\"column:budgetorganizationid+column:organizationtype+column:budgetperiods+column:sum_budgetaccount+column:sqlTypeFlag\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getSpzJe\" align=\"right\" />"+
       "</head>"+
		"		<operates>"+
		"			<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaBudgetGridInner_popedom\" "+
		"			 otherpara=\"column:budgetorganizationid+column:organizationtype+column:budgetperiods+column:id+"+user.getUID()+"+"+(canEdit?"true":"false")+"\" ></popedom> "+
		"			<operate href=\"javascript:doView_grid();\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" index=\"0\"/>"+//查看
		"			<operate href=\"javascript:doEdit_grid();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"1\"/>"+//编辑
		"			<operate href=\"javascript:doImp_grid();\" text=\""+SystemEnv.getHtmlLabelName(20209,user.getLanguage())+"\" index=\"2\"/>"+//预算导入
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_BUDGET_GRID_INNER_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	form2.submit();
}

//查看
function doView_grid(id){
<%
if("fccType".equals(organizationtype) || "".equals(organizationtype)){//查看按budgetinfoid
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?budgetinfoid="+id+"&edit=false";
<%
}else if("0".equals(organizationtype)){//查看分部按orgId
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=1&edit=false";
<%
}else if("1".equals(organizationtype)){//查看部门按orgId
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=2&edit=false";
<%
}else if("2".equals(organizationtype)){//查看个人按orgId
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=3&edit=false";
<%
}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){//查看成本中心按orgId
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=<%=FnaCostCenter.ORGANIZATION_TYPE %>&edit=false";
<%
}
%>
}

//编辑
function doEdit_grid(id){
<%
if("fccType".equals(organizationtype) || "".equals(organizationtype)){//编辑按budgetinfoid
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?budgetinfoid="+id+"&edit=true";
<%
}else if("0".equals(organizationtype)){//编辑分部按orgId
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=1&edit=true";
<%
}else if("1".equals(organizationtype)){//编辑部门按orgId
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=2&edit=true";
<%
}else if("2".equals(organizationtype)){//编辑个人按orgId
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=3&edit=true";
<%
}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){//编辑成本中心按orgId
%>
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=<%=FnaCostCenter.ORGANIZATION_TYPE %>&edit=true";
<%
}
%>
}

//预算导入
function doImp_grid(id){
	var _w = 580;
	var _h = 420;
	<%
	if("fccType".equals(organizationtype) || "".equals(organizationtype)){//导入按budgetinfoid
	%>
	_fnaOpenDialog("/fna/budget/FnaBudgetImport.jsp?fnabudgetinfoid="+id, 
				"<%=SystemEnv.getHtmlLabelName(20209,user.getLanguage()) %>", 
				_w, _h);
	<%
	}else if("0".equals(organizationtype)){//导入分部按orgId
	%>
	_fnaOpenDialog("/fna/budget/FnaBudgetImport.jsp?organizationid="+id+"&organizationtype=1", 
				"<%=SystemEnv.getHtmlLabelName(20209,user.getLanguage()) %>", 
				_w, _h);
	<%
	}else if("1".equals(organizationtype)){//导入部门按orgId
	%>
	_fnaOpenDialog("/fna/budget/FnaBudgetImport.jsp?organizationid="+id+"&organizationtype=2", 
				"<%=SystemEnv.getHtmlLabelName(20209,user.getLanguage()) %>", 
				_w, _h);
	<%
	}else if("2".equals(organizationtype)){//导入个人按orgId
	%>
	_fnaOpenDialog("/fna/budget/FnaBudgetImport.jsp?organizationid="+id+"&organizationtype=3", 
				"<%=SystemEnv.getHtmlLabelName(20209,user.getLanguage()) %>", 
				_w, _h);
	<%
	}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){//导入成本中心按orgId
	%>
	_fnaOpenDialog("/fna/budget/FnaBudgetImport.jsp?organizationid="+id+"&organizationtype=<%=FnaCostCenter.ORGANIZATION_TYPE %>", 
				"<%=SystemEnv.getHtmlLabelName(20209,user.getLanguage()) %>", 
				_w, _h);
	<%
	}
	%>
}

</script>

</body>
</html>
