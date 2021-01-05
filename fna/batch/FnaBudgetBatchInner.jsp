<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.BrowserElement"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
boolean effect = HrmUserVarify.checkUserRight("BudgetDraftBatchEffect:effect", user);//预算草稿批量生效
boolean imp = HrmUserVarify.checkUserRight("BudgetDraftBatchImport:imp", user);//预算草稿批量导入
if(!effect && !imp){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();

boolean fnaBudgetOAOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetOAOrg());//OA组织机构
boolean fnaBudgetCostCenter = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetCostCenter());//成本中心

rs.executeSql("select count(*) cnt from FnaYearsPeriods where status in (0, 1)");//0： 未生效；1 ：生效；-1： 关闭；
boolean fnaYearsPeriods_status_0_1 = (rs.next() && rs.getInt("cnt")>0);

String guid1 = UUID.randomUUID().toString();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//预算草稿批量生效
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);


FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();

boolean isQry = Util.getIntValue(request.getParameter("isQry"), 0) == 1;

int fnayearId = 0;
String fnayear = Util.null2String(request.getParameter("fnayear")).trim();
String sql = "select a.id, a.fnayear, a.startdate, a.enddate from FnaYearsPeriods a where a.fnayear = '"+StringEscapeUtils.escapeSql(fnayear)+"'";
rs.executeSql(sql);
if(rs.next()){
	fnayearId = rs.getInt("id");
}

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();

String organizationtype = Util.null2String(request.getParameter("organizationtype")).trim();

boolean impZb = false;
if("0".equals(organizationtype)){
	impZb = true;
}

String hrmIds = Util.null2String(request.getParameter("hrmIds")).trim();
StringBuffer hrmNames = new StringBuffer();
if(!"".equals(hrmIds)){
	String[] orgIdsArray = hrmIds.split(",");
	int orgIdsLen = orgIdsArray.length;
	for(int i=0;i<orgIdsLen;i++){
		hrmNames.append(fnaSplitPageTransmethod.getOrgName(orgIdsArray[i], "3")+" ");
	}
}

String depIds = Util.null2String(request.getParameter("depIds")).trim();
StringBuffer depNames = new StringBuffer();
if(!"".equals(depIds)){
	String[] orgIdsArray = depIds.split(",");
	int orgIdsLen = orgIdsArray.length;
	for(int i=0;i<orgIdsLen;i++){
		depNames.append(fnaSplitPageTransmethod.getOrgName(orgIdsArray[i], "2")+" ");
	}
}

String subCmpIds = Util.null2String(request.getParameter("subCmpIds")).trim();
StringBuffer subCmpNames = new StringBuffer();
if(!"".equals(subCmpIds)){
	String[] orgIdsArray = subCmpIds.split(",");
	int orgIdsLen = orgIdsArray.length;
	for(int i=0;i<orgIdsLen;i++){
		subCmpNames.append(fnaSplitPageTransmethod.getOrgName(orgIdsArray[i], "1")+" ");
	}
}

String fccIds = Util.null2String(request.getParameter("fccIds")).trim();
StringBuffer fccNames = new StringBuffer();
if(!"".equals(fccIds)){
	String[] orgIdsArray = fccIds.split(",");
	int orgIdsLen = orgIdsArray.length;
	for(int i=0;i<orgIdsLen;i++){
		fccNames.append(fnaSplitPageTransmethod.getOrgName(orgIdsArray[i], FnaCostCenter.ORGANIZATION_TYPE+"")+" ");
	}
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:onBtnSearchClick(),_self}";
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(28576,user.getLanguage())+",javascript:doExp(),_self}";
RCMenuHeight += RCMenuHeightStep ;
if(fnaYearsPeriods_status_0_1){
	if(imp){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(26601,user.getLanguage())+",javascript:doImp(),_self}";
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(effect){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(33061,user.getLanguage())+",javascript:doSave(),_self}";
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(33061,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(332,user.getLanguage())+"）,javascript:doSaveAll(),_self}";
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(imp || effect){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self}";
		RCMenuHeight += RCMenuHeightStep ;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post" action="/fna/batch/FnaBudgetBatchInner.jsp">
<input id="operation" name="operation" value="" type="hidden" />
<input id="fnayear" name="fnayear" value="<%=fnayear %>" type="hidden" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(28576,user.getLanguage())%>" class="e8_btn_top" onclick="doExp();"/><!-- 下载模板 -->
	<%if(fnaYearsPeriods_status_0_1){ %>
		<%if(imp){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%>" class="e8_btn_top" onclick="doImp();"/><!-- 批量导入 -->
		<%
		}
		if(effect){ 
		%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33061,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();"/><!-- 批准生效 -->
		<%} %>
	<%} %>
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=nameQuery %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span><!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4Col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("32905",user.getLanguage())%>'><!-- 常用条件 -->
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("34225",user.getLanguage())%></wea:item><!-- 预算机构类型 -->
		    <wea:item>
				<select id="organizationtype" name="organizationtype">
					<option value=""></option>
				<%if(fnaBudgetOAOrg){ %>
					<option value="0" <%=("0".equals(organizationtype))?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("140", user.getLanguage())%></option><!-- 总部 -->
					<option value="1" <%=("1".equals(organizationtype))?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("141", user.getLanguage())%></option><!-- 分部 -->
					<option value="2" <%=("2".equals(organizationtype))?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("124", user.getLanguage())%></option><!-- 部门 -->
					<option value="3" <%=("3".equals(organizationtype))?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("1867", user.getLanguage())%></option><!-- 人员 -->
				<%} %>
				<%if(fnaBudgetCostCenter){ %>
					<option value="<%=FnaCostCenter.ORGANIZATION_TYPE %>" 
						<%=((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype))?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("515", user.getLanguage())%></option><!-- 成本中心 -->
				<%} %>
				</select>
		    </wea:item>
		<%if(fnaBudgetOAOrg){ %>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("141",user.getLanguage())%></wea:item><!-- 分部预算 -->
		    <wea:item>
		        <brow:browser viewType="0" name="subCmpIds" browserValue='<%=subCmpIds %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
		                browserSpanValue='<%=subCmpNames.toString() %>' width="80%" >
		        </brow:browser>
		    </wea:item>
		    
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("124",user.getLanguage())%></wea:item><!-- 部门预算 -->
		    <wea:item>
		        <brow:browser viewType="0" name="depIds" browserValue='<%=depIds %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
		                browserSpanValue='<%=depNames.toString() %>' width="80%" >
		        </brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("1867",user.getLanguage())%></wea:item><!-- 人员预算 -->
		    <wea:item>
		        <brow:browser viewType="0" name="hrmIds" browserValue='<%=hrmIds %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("17")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(179,user.getLanguage())%>'
		                browserSpanValue='<%=hrmNames.toString() %>' width="80%" 
		                >
		        </brow:browser>
		    </wea:item>
		<%} %>
		<%if(fnaBudgetCostCenter){ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></wea:item><!-- 成本中心 -->
			<wea:item>
		        <brow:browser viewType="0" name="fccIds" browserValue='<%=fccIds %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp%3Fselectids=#id#"
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                completeUrl="/data.jsp?type=FnaCostCenter"  temptitle='<%= SystemEnv.getHtmlLabelName(515,user.getLanguage())%>'
		                browserSpanValue='<%=fccNames.toString() %>' width="80%" >
		        </brow:browser>
			</wea:item>
		<%} %>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="button" id="advSubmit" onclick="onBtnSearchClick();" 
	    			value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/><!-- 查询 -->
	    		<input class="e8_btn_submit" type="button" id="advReset" onclick="resetCondtion();"
	    			value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/><!-- 重置 -->
	    		<input class="e8_btn_cancel" type="button" id="cancel" 
	    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>	

<%
List<String> allowSubCmpIdEdit_list = new ArrayList<String>();
boolean allowSubCmpIdEdit = FnaBudgetLeftRuleSet.getAllowSubCmpIdEdit(user.getUID(), allowSubCmpIdEdit_list);
List<String> allowDepIdEdit_list = new ArrayList<String>();
boolean allowDepIdEdit = FnaBudgetLeftRuleSet.getAllowDepIdEdit(user.getUID(), allowDepIdEdit_list);
boolean allowHrmIdEdit = FnaBudgetLeftRuleSet.getAllowHrmIdEdit(user.getUID(), null);
List<String> allowFccIdEdit_list = new ArrayList<String>();
boolean allowFccIdEdit = FnaBudgetLeftRuleSet.getAllowFccIdEdit(user.getUID(), allowFccIdEdit_list);

	//设置好搜索条件
	String backFields =" a.id, a.budgetorganizationid, a.organizationtype, max(a.status) as status, sum(b.budgetaccount) as sum_budgetaccount, " + //c.feetype, 
			" case when (max(a.status)=0) then '"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"' else ' ' end statusName, "+
			" case when (a.organizationtype=0) then '"+SystemEnv.getHtmlLabelName(140,user.getLanguage())+"' "+
			" when (a.organizationtype=1) then '"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"' "+
			" when (a.organizationtype=2) then '"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"' "+
			" when (a.organizationtype=3) then '"+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+"' "+
			" when (a.organizationtype="+FnaCostCenter.ORGANIZATION_TYPE+") then '"+SystemEnv.getHtmlLabelName(515,user.getLanguage())+"' else ' ' end orgTypeName ";
	String fromSql = " from FnaBudgetInfo a join FnaBudgetInfoDetail b on a.id = b.budgetinfoid ";
	StringBuffer sqlWhere = new StringBuffer(" where 1=1 ");
	
	if(user.getUID() != 1 && FnaBudgetLeftRuleSet.enableRuleSet()){
		sqlWhere.append(" and (1=2 ");
		
		if(allowHrmIdEdit){
			sqlWhere.append(" or (a.organizationtype = 3) ");
		}else if(allowDepIdEdit_list.size() > 0){
			List<String> __allow_list = FnaCommon.initData1(allowDepIdEdit_list);
			int __allow_list_len = __allow_list.size();
			sqlWhere.append(" or (exists (select 1 from HrmResource hr where (1=2");
			for(int i=0;i<__allow_list_len;i++){
				sqlWhere.append(" or hr.departmentid in ("+__allow_list.get(i)+")");
			}
			sqlWhere.append(") and hr.id = a.budgetorganizationid) and a.organizationtype = 3) ");
		}
		
		if(allowDepIdEdit){
			sqlWhere.append(" or (a.organizationtype = 2) ");
		}else if(allowDepIdEdit_list.size() > 0){
			List<String> __allow_list = FnaCommon.initData1(allowDepIdEdit_list);
			int __allow_list_len = __allow_list.size();
			sqlWhere.append(" or ((1=2");
			for(int i=0;i<__allow_list_len;i++){
				sqlWhere.append(" or a.budgetorganizationid in ("+__allow_list.get(i)+")");
			}
			sqlWhere.append(") and a.organizationtype = 2) ");
		}
		
		if(allowSubCmpIdEdit){
			sqlWhere.append(" or (a.organizationtype = 1) ");
		}else if(allowSubCmpIdEdit_list.size() > 0){
			List<String> __allow_list = FnaCommon.initData1(allowSubCmpIdEdit_list);
			int __allow_list_len = __allow_list.size();
			sqlWhere.append(" or ((1=2");
			for(int i=0;i<__allow_list_len;i++){
				sqlWhere.append(" or a.budgetorganizationid in ("+__allow_list.get(i)+")");
			}
			sqlWhere.append(") and a.organizationtype = 1) ");
		}
		
		if(FnaBudgetLeftRuleSet.isAllowCmpEdit(user.getUID())){
			sqlWhere.append(" or (a.budgetorganizationid = 1 and a.organizationtype = 0) ");
		}
		
		if(allowFccIdEdit){
			sqlWhere.append(" or (a.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+") ");
		}else if(allowFccIdEdit_list.size() > 0){
			List<String> __allow_list = FnaCommon.initData1(allowFccIdEdit_list);
			int __allow_list_len = __allow_list.size();
			sqlWhere.append(" or ((1=2");
			for(int i=0;i<__allow_list_len;i++){
				sqlWhere.append(" or a.budgetorganizationid in ("+__allow_list.get(i)+")");
			}
			sqlWhere.append(") and a.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+") ");
		}
		
		sqlWhere.append(") ");
	}
	
	if(!"".equals(hrmIds) || !"".equals(depIds) || !"".equals(subCmpIds) || impZb || !"".equals(organizationtype) || !"".equals(nameQuery)){
		sqlWhere.append(" and ( 1=2 ");

		if(!"".equals(nameQuery)){
			sqlWhere.append(" or ( "+
				" 	(EXISTS (select 1 from HrmCompany h1 where h1.id = a.budgetorganizationid and h1.companyname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = 0) \n" +
				" 	or "+
				" 	(EXISTS (select 1 from HrmSubCompany s1 where s1.id = a.budgetorganizationid and s1.subcompanyname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = 1) \n" +
				" 	or "+
				" 	(EXISTS (select 1 from HrmDepartment d1 where d1.id = a.budgetorganizationid and d1.departmentname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = 2) \n" +
				" 	or "+
				" 	(EXISTS (select 1 from HrmResource d1 where d1.id = a.budgetorganizationid and d1.lastname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = 3) \n" +
				" 	or "+
				" 	(EXISTS (select 1 from FnaCostCenter d1 where d1.id = a.budgetorganizationid and d1.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') and a.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+") \n" +
				" ) \n");
		}
		if(!"".equals(organizationtype)){
			sqlWhere.append(" or (a.organizationtype = "+organizationtype+") \n"); 
		}
		if(!"".equals(hrmIds)){
			sqlWhere.append(" or (a.budgetorganizationid in ("+StringEscapeUtils.escapeSql(hrmIds)+") and a.organizationtype = 3) \n"); 
		}
		if(!"".equals(depIds)){
			sqlWhere.append(" or (a.budgetorganizationid in ("+StringEscapeUtils.escapeSql(depIds)+") and a.organizationtype = 2) \n"); 
		}
		if(!"".equals(subCmpIds)){
			sqlWhere.append(" or (a.budgetorganizationid in ("+StringEscapeUtils.escapeSql(subCmpIds)+") and a.organizationtype = 1) \n"); 
		}
		if(impZb){
			sqlWhere.append(" or (a.budgetorganizationid = 1 and a.organizationtype = 0) \n"); 
		}
		if(!"".equals(fccIds)){
			sqlWhere.append(" or (a.budgetorganizationid in ("+StringEscapeUtils.escapeSql(fccIds)+") and a.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+") \n"); 
		}
		
		sqlWhere.append(" ) ");
	}
	sqlWhere.append(" and a.status = 0 and a.budgetperiods = " + fnayearId + " ");
	sqlWhere.append(" group by a.id,a.budgetorganizationid,a.organizationtype ");

	String orderBy = "a.organizationtype,a.budgetorganizationid";
	
	String sqlprimarykey = "a.id";

	String sql_qryAllId = "select a.id "+fromSql+" "+sqlWhere+" order by "+orderBy;
	request.getSession().setAttribute("FnaBudgetBatchInner.jsp_sql_qryAllId_"+guid1, sql_qryAllId);
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String innerFromSql = " from ( select "+backFields+" "+fromSql+" "+sqlWhere+" ) a ";
	
	backFields = " * ";
	fromSql = innerFromSql;
	sqlWhere = new StringBuffer("");
	
	String tabletype = "none";
	if(effect){
		tabletype = "checkbox";
	}
	String tableString=""+
       "<table instanceid=\"FNA_BUDGET_BATCH_INNER_LIST\" pageId=\""+PageIdConst.FNA_BUDGET_BATCH_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_BUDGET_BATCH_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\""+tabletype+"\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere.toString())+"\" "+
       " sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" "+
       //" sumColumns=\"sum_budgetaccount\" decimalFormat=\""+Util.toHtmlForSplitPage("%.2f")+"\" "+
       " />"+
       "<head>"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("81552",user.getLanguage())+"\" column=\"budgetorganizationid\" "+//预算机构
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getOrgNameFnaBudgetBatchInner\" otherpara=\"column:organizationtype+column:id\" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("26505,63",user.getLanguage())+"\" column=\"orgTypeName\" "+//机构类型
					" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"statusName\" "+//状态
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"view_grid+column:id\"/>"+
			
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18501,user.getLanguage())+"\" column=\"sum_budgetaccount\" "+//预算总额
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" />"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18502,user.getLanguage())+"\" column=\"id\" "+//已分配/汇总预算
					" otherpara=\"column:budgetorganizationid+column:organizationtype+"+fnayearId+"+column:sum_budgetaccount+caogao\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getYfpJe\" />"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18503,user.getLanguage())+"\" column=\"id\" "+//已发生费用
					" otherpara=\"column:budgetorganizationid+column:organizationtype+"+fnayearId+"+column:sum_budgetaccount+caogao\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getYfsJe\" />"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18769,user.getLanguage())+"\" column=\"id\" "+//审批中费用
					" otherpara=\"column:budgetorganizationid+column:organizationtype+"+fnayearId+"+column:sum_budgetaccount+caogao\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getSpzJe\" />"+
       "</head>"+
		"		<operates>"+
		"			<operate href=\"javascript:view_grid();\" text=\""+SystemEnv.getHtmlLabelName(22045,user.getLanguage())+"\" index=\"0\"/>"+//详情
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_BUDGET_BATCH_INNER_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _guid1 = "<%=guid1 %>";

//快速（高级）搜索事件
function onBtnSearchClick(){
	form2.submit();
}

function doExp(){
	var _w = 580;
	var _h = 510;
	_fnaOpenDialog("/fna/batch/ExpFnaBatchExcel.jsp?_guid1="+_guid1+"&budgetperiods=<%=fnayearId %>", 
			"<%=SystemEnv.getHtmlLabelName(28576,user.getLanguage()) %>", 
			_w, _h);
}

function doImp(){
	var _w = 580;
	var _h = 330;
	_fnaOpenDialog("/fna/batch/FnaBudgetBatchImport.jsp?budgetperiods=<%=fnayearId %>", 
			"<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage()) %>", 
			_w, _h);
}

function doSave(){
	_doSave(0);
}

function doSaveAll(){
	_doSave(1);
}

function _doSave(isAll){
	var fnaBudgetInfoIds = _xtable_CheckedCheckboxId();
	if(isAll==0 && fnaBudgetInfoIds==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34197,user.getLanguage()) %>");//请选择要生效的数据
		return;
	}
	
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33207,user.getLanguage()) %>", 
		function(){
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
			
			var _data = "op=update&_guid1="+_guid1+"&isAll="+isAll+"&fnaBudgetInfoIds="+fnaBudgetInfoIds+"&fnayearId=<%=fnayearId %>"+
				"&r="+$System.Math.IntUtil.genGUIDV4();
			jQuery.ajax({
				url : "/fna/batch/FnaBudgetBatchOp.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "html",
				success: function do4Success(_html){
				}
			});	
		},function(){}
	);
}

function view_grid(budgetinfoid){
	var url = "/fna/budget/FnaBudgetView.jsp?budgetinfoid="+budgetinfoid;
	window.open(url);
}


function getErrorInfoAjax(resultJson){
	if(resultJson.flag){
		alert("<%=SystemEnv.getHtmlLabelName(34214,user.getLanguage())%>");
		try{
			//_table.reLoad();
			window.location.href = "/fna/batch/FnaBudgetBatchInner.jsp?fnayear=<%=fnayear %>";
		}catch(ex1){}
	}else{
		alert(resultJson.msg._fnaReplaceAll("<br>","\r")._fnaReplaceAll("<br />","\r"));
	}
}

//读取数据更新进度标志符
var _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
//读取数据更新进度函数
function loadFnaBudgetEditSaveFnaLoadingAjax(_guid1){
	jQuery.ajax({
		url : "/fna/FnaLoadingAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "guid="+_guid1,
		dataType : "json",
		success: function do4Success(_jsonObj){
		    try{
	    		if(_jsonObj.flag){
			    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					getErrorInfoAjax(_jsonObj.resultJson);
	    		}else{
		    		if(top!=null&&top.document!=null&&top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv")!=null){
			    		top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv").innerHTML=null2String(_jsonObj.infoStr);
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
				    		setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
			    		}
		    		}else{
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
				    		setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
			    		}
		    		}
	    		}
		    }catch(e1){
		    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				alert(e1.message);
		    }
		}
	});	
}

function doDelete(){
	var fnaBudgetInfoIds = _xtable_CheckedCheckboxId();
	if(fnaBudgetInfoIds==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage()) %>");//请选择要删除的记录!
		return;
	}
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage()) %>", 
		function(){
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			
			var _data = "op=delete&fnaBudgetInfoIds="+fnaBudgetInfoIds+"&fnayearId=<%=fnayearId %>"+
				"&r="+$System.Math.IntUtil.genGUIDV4();
			jQuery.ajax({
				url : "/fna/batch/FnaBudgetBatchOp.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(jsonObj){
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					top.Dialog.alert(jsonObj.msg);
					if(jsonObj.flag){
						_table.reLoad();
					}
				}
			});	
		},function(){}
	);
}

</script>
</body>
</html>
