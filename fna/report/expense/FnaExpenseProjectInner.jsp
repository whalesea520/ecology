<%@page import="weaver.hrm.resource.AllSubordinate"%>
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
boolean canview = HrmUserVarify.checkUserRight("FnaBudget:All",user) ;

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
String sqlstr =" select startdate, enddate, id from FnaYearsPeriods where status <> -1 and fnayear = '"+Util.getIntValue(fnayear)+"'";
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
<form id="form2" name="form2" method="post"  action="/fna/report/expense/FnaExpenseProjectInner.jsp">
<input id="fnayear" name="fnayear" value="<%=fnayear %>" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=nameQuery %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<!-- 
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			 -->
			<!-- 高级搜索 -->
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
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("194") %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=164"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
		                browserSpanValue='<%=(shownameSub) %>' width="80%" 
		                >
		        </brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item><!-- 部门 -->
	    	<wea:item>
		        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("57") %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=4"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
		                browserSpanValue='<%=(shownameDep) %>' width="80%" 
		                >
		        </brow:browser>
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
	sqlstr = " select a.id, a.name, a.manager, \n" +
			" (select sum(feiIn.amount) from FnaExpenseInfo feiIn join FnaBudgetfeeType fbft on feiIn.subject = fbft.id\n" +
			"  where fbft.feetype = 2 and feiIn.status = 1 and feiIn.relatedprj = a.id and (feiIn.occurdate >= '"+fnayearstartdate+"' and feiIn.occurdate <= '"+fnayearenddate+"')) fnaExpenseIn, \n" +
			" (select sum(feiIn.amount) from FnaExpenseInfo feiIn join FnaBudgetfeeType fbft on feiIn.subject = fbft.id\n" +
			" where fbft.feetype = 1 and feiIn.status = 1 and feiIn.relatedprj = a.id and (feiIn.occurdate >= '"+fnayearstartdate+"' and feiIn.occurdate <= '"+fnayearenddate+"')) fnaExpenseOut \n" +
			" from Prj_ProjectInfo a where 1=1 ";
	if( !canview ) {
		AllSubordinate allSubordinate = new AllSubordinate();
		String subresource = "0" ;
		allSubordinate.getAll( "" +  user.getUID() ) ;
		while( allSubordinate.next() ) {
		    subresource += "," + allSubordinate.getSubordinateID() ;
		}
		sqlstr += " and (a.manager = "+user.getUID()+" or a.manager in ("+subresource+")) " ;
	}
	
	//设置好搜索条件
	String backFields =" t.* ";
	String fromSql = " from ("+sqlstr+") t \n";
	String sqlWhere = " where 1=1 ";
	if(!"".equals(nameQuery)){
		sqlWhere += " and t.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' \n"; 
	}

	String orderBy = "name";
	
	String sqlprimarykey = "id";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	String tableString=""+
       "<table instanceid=\"FNA_EXPENSE_PROJECT_INNER_LIST\" pageId=\""+PageIdConst.FNA_EXPENSE_PROJECT_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_EXPENSE_PROJECT_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" sumColumns=\"fnaExpenseIn,fnaExpenseOut\" decimalFormat=\""+Util.toHtmlForSplitPage("%.2f|%.2f")+"\" />"+
       "<head>"+
			"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(101,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" "+//项目
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"view_grid+column:id\"/>"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(16573,user.getLanguage())+"\" column=\"manager\" "+//项目经理
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getHrmNameLink\" />"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(566,user.getLanguage())+"\" column=\"fnaExpenseIn\" orderkey=\"fnaExpenseIn\" "+//收入
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" "+
					" />"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(629,user.getLanguage())+"\" column=\"fnaExpenseOut\" orderkey=\"fnaExpenseOut\" "+//支出
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" "+
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
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_EXPENSE_PROJECT_INNER_LIST %>" />
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

function view_grid(projectid){
	//var url = "/fna/report/expense/Rpt1FnaBudgetViewInner.jsp?organizationtype=prj&organizationid="+projectid+"&fnayear=<%=Util.getIntValue(fnayear) %>&goBackUrl=/fna/report/expense/FnaExpenseDepartmentInner.jsp";
	var url = "/fna/report/expense/FnaExpenseProjectDetail.jsp?projectid="+projectid+"&fnayear=<%=Util.getIntValue(fnayear) %>";
	window.open(url);
}

//关闭
function doClose1(){
	window.closeDialog();
}

</script>

</body>
</html>