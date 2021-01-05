<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<% 
boolean canview = HrmUserVarify.checkUserRight("FnaTransaction:All", user);

if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
String fnayear = Util.null2String(request.getParameter("fnayear")).trim();//预算年度

String fnayearstartdate = "1000-01-01";
String fnayearenddate = "1000-12-31";
String budgetperiods = "-1";
String sqlstr =" select startdate, enddate, id from FnaYearsPeriods where status <> -1 and fnayear = " + Util.getIntValue(fnayear);
rs.executeSql(sqlstr);
if(rs.next()) {
	fnayearstartdate = rs.getString("startdate");
	fnayearenddate = rs.getString("enddate");
    budgetperiods = rs.getString("id");
}

String subId = Util.null2String(request.getParameter("subId")).trim();
String depId = Util.null2String(request.getParameter("depId")).trim();
String hrmId = Util.null2String(request.getParameter("hrmId")).trim();

String shownameHrm = "";
String shownameDep = "";
String shownameSub = "";
if (!"".equals(subId)) {
	rs.executeSql("select subcompanyname from HrmSubCompany where id in ("+StringEscapeUtils.escapeSql(subId)+") ");
	while(rs.next()){
		shownameSub += Util.null2String(rs.getString("subcompanyname")).trim()+" ";
	}
} 
if (!"".equals(depId)) {
	rs.executeSql("select departmentname from HrmDepartment where id in ("+StringEscapeUtils.escapeSql(depId)+") ");
	while(rs.next()){
		shownameDep += Util.null2String(rs.getString("departmentname")).trim()+" ";
	}
} 
if (!"".equals(hrmId)) {
	rs.executeSql("select lastname from HrmResource where id in ("+StringEscapeUtils.escapeSql(hrmId)+") ");
	while(rs.next()){
		shownameHrm += Util.null2String(rs.getString("lastname")).trim()+" ";
	}
}

%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post"  action="/fna/report/expense/FnaExpenseResourceInner.jsp">
<input id="fnayear" name="fnayear" value="<%=fnayear %>" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
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
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'><!-- 常用条件 -->
	    	<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item><!-- 分部 -->
		    <wea:item>
		        <brow:browser viewType="0" name="subId" browserValue='<%=subId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fselectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=164"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
		                browserSpanValue='<%=(shownameSub) %>' width="80%" 
		                >
		        </brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item><!-- 部门 -->
	    	<wea:item>
		        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fresourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=4"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
		                browserSpanValue='<%=(shownameDep) %>' width="80%" 
		                >
		        </brow:browser>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item><!-- 人力资源 -->
	    	<wea:item>
		        <brow:browser viewType="0" name="hrmId" browserValue='<%=hrmId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("17")+"%3Fselectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=1"  temptitle='<%= SystemEnv.getHtmlLabelName(179,user.getLanguage())%>'
		                browserSpanValue='<%=(shownameHrm) %>' width="80%" 
		                >
		        </brow:browser>
	    	</wea:item>
	    	<wea:item></wea:item>
	    	<wea:item>
	    	</wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="button" id="advSubmit" onclick="onBtnSearchClick('from_advSubmit');" 
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
    String resourceidsql = "";
    String resourceidsql2 = "";

    String managerstr = "";
    rs.executeSql(" select managerstr from hrmresource where id = " + user.getUID());
    if (rs.next()) managerstr = Util.null2String(rs.getString(1));

    String rightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All", user);

    if (rightlevel.equals("2")) resourceidsql = "";
    else if (rightlevel.equals("1")) {
        resourceidsql = " and a.budgetorganizationid in ( select id from HrmResource where id = " + user.getUID() + " or subcompanyid1 = " + user.getUserSubCompany1() + " or managerstr like '" + managerstr + user.getUID() + ",%' )";
        resourceidsql2 = " where ( t1.id = " + user.getUID() + " or t1.subcompanyid1 = " + user.getUserSubCompany1() + " or t1.managerstr like '" + managerstr + user.getUID() + ",%' ) ";
    } else {
        resourceidsql = " and a.budgetorganizationid in ( select id from HrmResource where id = " + user.getUID() + " or departmentid = " + user.getUserDepartment() + " or managerstr like '" + managerstr + user.getUID() + ",%' ) ";
        resourceidsql2 = " where ( t1.id = " + user.getUID() + " or t1.departmentid = " + user.getUserDepartment() + " or t1.managerstr like '" + managerstr + user.getUID() + ",%' ) ";
    }
    
	sqlstr =" select tt.*, \n" +
			" case when (tt.budgetaccountIn < 0.0 or tt.budgetaccountIn > 0.0) then ((tt.budgetaccountIn-tt.fnaExpenseIn)*100/tt.budgetaccountIn) else 0 end accountgapIn, \n" +
			" case when (tt.budgetaccountOut < 0.0 or tt.budgetaccountOut > 0.0) then ((tt.budgetaccountOut-tt.fnaExpenseOut)*100/tt.budgetaccountOut) else 0 end accountgapOut from ( "+
			" 	select a.budgetorganizationid, max(a.status) as status, sum(b.budgetaccount) as budgetaccount, " +//c.feetype,  
			" 	sum(case when (c.feetype=2) then b.budgetaccount else 0.00 end) budgetaccountIn, "+ //预算 收入
			" 	sum(case when (c.feetype=1) then b.budgetaccount else 0.00 end) budgetaccountOut, "+ //预算 支出
			" 	(select sum(feiIn.amount) from FnaExpenseInfo feiIn join FnaBudgetfeeType fbft on feiIn.subject = fbft.id "+
			"  	 where fbft.feetype = 2 and feiIn.status = 1 and feiIn.organizationtype = 3 and feiIn.organizationid = a.budgetorganizationid and (feiIn.occurdate >= '"+fnayearstartdate+"' and feiIn.occurdate <= '"+fnayearenddate+"')) fnaExpenseIn, "+ //实际 收入
			" 	(select sum(feiIn.amount) from FnaExpenseInfo feiIn join FnaBudgetfeeType fbft on feiIn.subject = fbft.id "+
			"  	 where fbft.feetype = 1 and feiIn.status = 1 and feiIn.organizationtype = 3 and feiIn.organizationid = a.budgetorganizationid and (feiIn.occurdate >= '"+fnayearstartdate+"' and feiIn.occurdate <= '"+fnayearenddate+"')) fnaExpenseOut, "+ //实际 支出
			" 	case when (max(a.status)=1) then '"+SystemEnv.getHtmlLabelName(18431,user.getLanguage())+"' else ' ' end statusName "+
	        " 	from FnaBudgetInfo a ,FnaBudgetInfoDetail b , FnaBudgetfeeType c " +
	        " 	where a.id = b.budgetinfoid and b.budgettypeid = c.id and a.organizationtype = 3 " +
	        " 	and a.status =1 and a.budgetperiods = " + budgetperiods+" ";

    if (!resourceidsql.equals("")) sqlstr += resourceidsql;
	
	sqlstr += " group by a.budgetorganizationid " ;//, c.feetype
	sqlstr += " ) tt " ;
	
	
	
	//设置好搜索条件
	String backFields =" t.*, "+
		" t1.lastname t1lastname, t1.dsporder t1dsporder, t1.id, "+
		" t2.departmentname t2departmentname, t2.id t2id ";
	String fromSql = " from HrmResource t1 \n"+
			" join HrmDepartment t2 on t1.departmentid = t2.id \n"+
			" join HrmSubCompany t3 on t3.id = t2.subcompanyid1 \n"+
			" left join ("+sqlstr+") t on t1.id = t.budgetorganizationid \n";
	String sqlWhere = " where 1=1 ";
    if(!resourceidsql2.equals("")){
    	sqlWhere = resourceidsql2 ; 
    }
    if(!"".equals(nameQuery) || !"".equals(hrmId) || !"".equals(depId) || !"".equals(subId)){
    	sqlWhere += " and (1=2 ";
		if(!"".equals(nameQuery)){
			sqlWhere += " or (t1.lastname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' or t2.departmentname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n"; 
		}
		if(!"".equals(hrmId)){
			sqlWhere += " or t1.id in ("+StringEscapeUtils.escapeSql(hrmId)+") \n"; 
		}
		if(!"".equals(depId)){
			sqlWhere += " or t2.id in ("+StringEscapeUtils.escapeSql(depId)+") \n"; 
		}
		if(!"".equals(subId)){
			sqlWhere += " or t3.id in ("+StringEscapeUtils.escapeSql(subId)+") \n"; 
		}
		sqlWhere += " ) ";
    }
	String orderBy = "t1dsporder";
	
	String sqlprimarykey = "t1.id";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	String tableString=""+
       "<table instanceid=\"FNA_EXPENSE_RESOURCE_INNER_LIST\" pageId=\""+PageIdConst.FNA_EXPENSE_RESOURCE_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_EXPENSE_RESOURCE_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" "+
       " sumColumns=\"fnaExpenseIn,fnaExpenseOut\" decimalFormat=\""+Util.toHtmlForSplitPage("%.2f|%.2f")+"\" />"+
       "<head>"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\" column=\"id\" orderkey=\"t1lastname\" "+//人力资源
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getHrmNameLink\" />"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"t2id\" orderkey=\"t2departmentname\" "+//部门
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getDepNameLink\" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("386,566",user.getLanguage())+"\" column=\"budgetaccountIn\" orderkey=\"budgetaccountIn\" "+//预算收入
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" "+
					" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("628,566",user.getLanguage())+"\" column=\"fnaExpenseIn\" orderkey=\"fnaExpenseIn\" "+//实际收入
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" "+
					" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("566,15368",user.getLanguage())+"\" column=\"accountgapIn\" orderkey=\"accountgapIn\" "+//收入偏差
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" "+
					" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("386,629",user.getLanguage())+"\" column=\"budgetaccountOut\" orderkey=\"budgetaccountOut\" "+//预算支出
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" "+
					" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("628,629",user.getLanguage())+"\" column=\"fnaExpenseOut\" orderkey=\"fnaExpenseOut\" "+//实际支出
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" "+
					" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("629,15368",user.getLanguage())+"\" column=\"accountgapOut\" orderkey=\"accountgapOut\" "+//支出偏差
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" "+
					" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"statusName\" orderkey=\"statusName\" "+//状态
					" />"+
       "</head>"+
		"		<operates>"+
		"			<operate href=\"javascript:view_grid();\" text=\""+SystemEnv.getHtmlLabelName(22045,user.getLanguage())+"\" index=\"0\"/>"+//详情
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_EXPENSE_RESOURCE_INNER_LIST %>" />
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

function view_grid(budgetorganizationid){
	var url = "/fna/report/expense/RptFnaBudgetViewInner.jsp?organizationtype=3&organizationid="+budgetorganizationid+"&goBackUrl=/fna/report/expense/FnaExpenseResourceInner.jsp";
	window.open(url);
}

//关闭
function doClose1(){
	window.closeDialog();
}

</script>

</body>
</html>