<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<%
boolean canView = HrmUserVarify.checkUserRight("BudgetAuthorityRule:readOnly", user);//预算编制只读权限
boolean canEdit = (HrmUserVarify.checkUserRight("FnaBudget:View", user) || 
		HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) || 
		HrmUserVarify.checkUserRight("BudgetAuthorityRule:edit", user));//财务预算维护、预算编制权限
boolean canEditSp1 = canEdit;
if(!canView && !canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18552,user.getLanguage());//版本历史
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String organizationtype = Util.null2String(request.getParameter("organizationtype")).trim();
String organizationid = Util.null2String(request.getParameter("organizationid")).trim();
int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
int budgetperiods = 0;

//通过预算版本id获取：预算单位类型、预算单位和预算年度id
if(budgetinfoid > 0){
	String sql = "select a.organizationtype, a.budgetorganizationid, a.budgetperiods, a.status, a.revision from FnaBudgetInfo a where a.id = "+budgetinfoid;
	rs.executeSql(sql);
	if(rs.next()){
		organizationtype = Util.null2String(rs.getString("organizationtype")).trim();
		organizationid = Util.null2String(rs.getString("budgetorganizationid")).trim();
		budgetperiods = rs.getInt("budgetperiods");
	}
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
<%
if(canEditSp1 && user.getUID()==1){//只有系统管理员才有权限做这件事
	RCMenu += "{" + SystemEnv.getHtmlLabelName(126814, user.getLanguage())+",javascript:save2DraftVersion(),_self} ";//（将历史版本）保存为草稿版本
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(18553,user.getLanguage())+",javascript:doCompare(),_self} ";//版本对比
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post"  action="/fna/budget/FnaBudgetHistoryView.jsp">
    <input type="hidden" id="organizationtype" name="organizationtype" value="<%=organizationtype %>" />
    <input type="hidden" id="organizationid" name="organizationid" value="<%=organizationid %>" />
    <input type="hidden" id="budgetinfoid" name="budgetinfoid" value="<%=budgetinfoid %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%if(canEditSp1 && user.getUID()==1){//只有系统管理员才有权限做这件事 %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(126814,user.getLanguage()) %>" id="btnBbdb"
				class="e8_btn_top" onclick="save2DraftVersion();"/><!-- （将历史版本）保存为草稿版本 -->
		<%} %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18553,user.getLanguage()) %>" id="btnBbdb"
				class="e8_btn_top" onclick="doCompare();"/><!-- 版本对比 -->
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
	String backFields ="a.id, a.revision, a.status, a.createrid, a.createdate, a.organizationtype, a.budgetorganizationid, a.budgetperiods, sum(b.budgetaccount) sum_budgetaccount, 'ALL' sqlTypeFlag ";
	String fromSql = " from FnaBudgetInfo a \n" +
			" left join FnaBudgetInfoDetail b on a.id = b.budgetinfoid \n" +
			" join FnaYearsPeriods c on a.budgetperiods = c.id and c.status = 1 ";
	String sqlWhere = " where a.organizationtype = "+organizationtype+" and a.budgetorganizationid = "+organizationid+" and a.budgetperiods = "+budgetperiods+" \n";
	if(user.getUID() != 1 && FnaBudgetLeftRuleSet.enableRuleSet()){
		if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
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
				sqlWhere += " and a.organizationtype <> "+FnaCostCenter.ORGANIZATION_TYPE+" ";
			}

		}else{
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
	}
	
	if(!"".equals(nameQuery)){
		if(SystemEnv.getHtmlLabelName(220, user.getLanguage()).equalsIgnoreCase(nameQuery) || SystemEnv.getHtmlLabelName(83329, user.getLanguage()).equalsIgnoreCase(nameQuery) || SystemEnv.getHtmlLabelName(83330, user.getLanguage()).equalsIgnoreCase(nameQuery)){
			sqlWhere += "and a.status = 0 \n";
		}else if(SystemEnv.getHtmlLabelName(2242, user.getLanguage()).equalsIgnoreCase(nameQuery) || SystemEnv.getHtmlLabelName(83331, user.getLanguage()).equalsIgnoreCase(nameQuery) || SystemEnv.getHtmlLabelName(83332, user.getLanguage()).equalsIgnoreCase(nameQuery) || SystemEnv.getHtmlLabelName(83333, user.getLanguage()).equalsIgnoreCase(nameQuery)){
			sqlWhere += "and a.status = 3 \n";
		}else if("V".equalsIgnoreCase(nameQuery.toUpperCase())){
			sqlWhere += "and a.status <> 0 \n";
		}else{
			nameQuery = nameQuery.toUpperCase().replace("V", "");
			sqlWhere += "and a.revision = "+Util.getIntValue(nameQuery, -1)+" \n";
		}
	}
	
	sqlWhere += " and c.status = 1 ";
	String groupBy = " GROUP BY a.id, a.status, a.revision, a.createrid, a.createdate, a.organizationtype, a.budgetorganizationid, a.budgetperiods ";
	sqlWhere += groupBy;
	
	String sqlInner = "select "+backFields+" "+fromSql+" "+sqlWhere;

	backFields = "*";
	fromSql = " from ("+sqlInner+") tInner1 ";
	sqlWhere = "";

	String orderBy=" (case when (status=1 or status=3) then 3 when (status=0) then 2 else 1 end), revision ";
	
	String sqlprimarykey = "id";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_BUDGET_HISTORY_VIEW\" pageId=\""+PageIdConst.FNA_BUDGET_HISTORY_VIEW+"\" "+
     		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_BUDGET_HISTORY_VIEW,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
     		" sqlorderby=\""+Util.toHtmlForSplitPage(xssUtil.put(orderBy))+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"desc\" />"+
       "<head>"+
			"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"\" column=\"revision\" "+//版本
       				" otherpara=\"column:status+"+user.getLanguage()+"+doView_grid+column:id\" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getRevisionAndJsFunc\" />"+
			"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(18501,user.getLanguage())+"\" column=\"sum_budgetaccount\" "+//预算总额
					" otherpara=\"column:budgetorganizationid+column:organizationtype+column:budgetperiods+column:sqlTypeFlag\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getYsZje\" />"+
			"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrid\" "+//创建人
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getLastName\" />"+
			"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" />"+//创建时间
       "</head>"+
		"		<operates>"+
		"			<operate href=\"javascript:doView_grid();\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" index=\"0\"/>"+//查看
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_BUDGET_HISTORY_VIEW %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	form2.submit();
}

function save2DraftVersion(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(567,user.getLanguage()) %>");//请选择版本
		return;
	}
	var idsArray = ids.split(",");
	if(idsArray.length!=2){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage()) %>");//请选择一条记录
		return;
	}
	var budgetinfoid = idsArray[0];
	var tabFeeperiod = "";
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126815,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/budget/FnaBudgetEditSave2DraftVersionAjax.jsp",
				type : "post",
				cache : false,
				data : "budgetinfoid="+budgetinfoid+"&tabFeeperiod="+tabFeeperiod+"&fromPage=FnaBudgetHistoryView", 
				processData : false,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						try{showToolBarBtn();}catch(ex1){}
						if(_json.flag){
							window.parent.location.href = _json.locationHref+"&edit=false&isClearTmpData=true";
						}else{
							alert(_json.msg);
						}
				    }catch(e1){
				    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				    	try{showToolBarBtn();}catch(ex1){}
				    }
				}
			});	
		}, function(){}
	);
}

function doCompare(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(567,user.getLanguage()) %>");//请选择版本
		return;
	}
	var idsArray = ids.split(",");
	if(idsArray.length!=3){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18687,user.getLanguage()) %>");//请选择2个要对比版本！
		return;
	}
	var organizationtype = jQuery("#organizationtype").val();
	var organizationid = jQuery("#organizationid").val();
	var budgetinfoid = jQuery("#budgetinfoid").val();
	window.location.href = "/fna/budget/FnaBudgetCompare.jsp?budgetinfoid_1="+idsArray[0]+"&budgetinfoid_2="+idsArray[1]+
			"&organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+budgetinfoid;
}

//查看
function doView_grid(id){
	parent.window.location.href = "/fna/budget/FnaBudgetView.jsp?budgetinfoid="+id+"&edit=false";
}
</script>

</body>
</html>
