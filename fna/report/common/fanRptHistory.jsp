<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ResourceVirtualComInfo" class="weaver.hrm.companyvirtual.ResourceVirtualComInfo" scope="page"/>
<% 
String rptTypeName = Util.null2String(request.getParameter("rptTypeName")).trim();
boolean canview = FnaReport.checkUserRight(rptTypeName, user) ;
if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String sql = "";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();

String resource = Util.null2String(request.getParameter("resource")) ;
String resourcename = "";
if(!resource.equals("")){
	String[] tmpArr = resource.split(",");
	for(int i=0;i<tmpArr.length;i++){
		if(resourcename.equals("")){
			resourcename = Util.toScreen(ResourceComInfo.getLastname(tmpArr[i]),user.getLanguage());
		}else{
			resourcename = resourcename+","+Util.toScreen(ResourceComInfo.getLastname(tmpArr[i]),user.getLanguage());
		}
	}
}

String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
if(doccreatedateselect.equals("")){
	doccreatedateselect="0";
}
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0") && !doccreatedateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(doccreatedateselect,"0");
	todate = TimeUtil.getDateByOption(doccreatedateselect,"1");
}

%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post"  action="/fna/report/common/fanRptHistory.jsp">
<input id="rptTypeName" name="rptTypeName" value="<%=rptTypeName %>" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
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
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></wea:item><!-- 报表名称 -->
		    <wea:item>
		    	<input type=text id="advQryName" name="advQryName" class=Inputstyle value="<%=FnaCommon.escapeHtml(nameQuery) %>" />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item><!-- 创建人 -->
		    <wea:item>
				<brow:browser viewType="0" name="resource" browserValue='<%= ""+resource %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/resource/MutiResourceBrowser.jsp?show_virtual_org=-1%26resourceids="
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?show_virtual_org=-1" 
					browserSpanValue='<%=resourcename%>'
					
					>
				</brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></wea:item><!-- 创建时间 -->
		    <wea:item>
				<span>
					<select style="width:80px;" name="doccreatedateselect" id="doccreatedateselect" onchange="changeDate(this,'doccreatedate');">
						<option value="0" <%=doccreatedateselect.equals("0")?"selected":"" %>><%= SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<option value="1" <%=doccreatedateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
						<option value="2" <%=doccreatedateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
						<option value="3" <%=doccreatedateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
						<option value="4" <%=doccreatedateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
						<option value="5" <%=doccreatedateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
						<option value="6" <%=doccreatedateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
					</select>
				</span>
				<span id="doccreatedate" style="<%=doccreatedateselect.equals("6")?"":"display:none;" %>">
					<input class=wuiDate  type="hidden" name="fromdate" value="<%=fromdate%>">
					-&nbsp;&nbsp; 
					<input class=wuiDate  type="hidden" name="todate" value="<%=todate%>">
				</span>
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
	String virtualSubCompanyID = Util.null2String(ResourceVirtualComInfo.getSubcompanyids(user.getUID()+"")).trim();
	String virtualDepartmentID = Util.null2String(ResourceVirtualComInfo.getDepartmentids(user.getUID()+"")).trim();
	
	String sqlWhereVrCmp = ""; 
	if(!"".equals(virtualSubCompanyID)){
		sqlWhereVrCmp = " or (b.shareId in ("+virtualSubCompanyID+") and b.shareType=3) ";
	}
	
	String sqlWhereVrDep = ""; 
	if(!"".equals(virtualDepartmentID)){
		sqlWhereVrDep = " or (b.shareId in ("+virtualDepartmentID+") and b.shareType=2) ";
	}
	
	//设置好搜索条件
	String backFields =" a.id, a.guid1, a.tbName, a.creater, a.createDate, a.createTime, a.description ";
	String fromSql = " from fnaTmpTbLog a \n";
	String sqlWhere = " where ( \n"+
		" 	exists ( \n"+
		" 		select 1 from fnaTmpTbLogShare b \n"+
		" 		where a.id = b.fnaTmpTbLogId \n"+
		" 		and ( 1=2 \n"+
		" 			or (exists (select 1 from hrmrolemembers c where c.resourceid = "+user.getUID()+" and c.roleid = b.shareId) and b.shareType=4) \n"+//角色
		" 	        or ( "+
		" 				(b.shareId = "+user.getUserSubCompany1()+" and b.shareType=3) "+
		" 				"+sqlWhereVrCmp+" "+
		" 			) \n"+//分部
		" 	        or ( "+
		" 				(b.shareId = "+user.getUserDepartment()+" and b.shareType=2) "+
		" 				"+sqlWhereVrDep+" "+
		" 			) \n"+//部门
		" 			or (b.shareId = "+user.getUID()+" and b.shareType=1) \n"+//人员
		" 			or (b.shareType=0) \n"+//所有人
		" 		) \n"+
		"		and ((b.secLevel1 >= 0 and b.secLevel1 <= "+user.getSeclevel()+") or b.secLevel1 = -1) \n"+
		"		and ((b.secLevel2 >= 0 and b.secLevel2 >= "+user.getSeclevel()+") or b.secLevel2 = -1) \n"+
		" 	) \n"+
		" 	or \n"+
		" 	(a.creater = "+user.getUID()+") \n"+
		" ) \n";
	if(!"".equals(nameQuery)){
		sqlWhere += " and a.tbName like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' ";
	}
	if(!"".equals(resource)){
		sqlWhere += " and a.creater in ("+resource+") ";
	}
	if(!"".equals(fromdate)){
		sqlWhere += " and a.createDate >= '"+StringEscapeUtils.escapeSql(fromdate)+"' ";
	}
	if(!"".equals(todate)){
		sqlWhere += " and a.createDate <= '"+StringEscapeUtils.escapeSql(todate)+"' ";
	}
	sqlWhere += " and a.isTemp = 0 and a.rptTypeName = '"+StringEscapeUtils.escapeSql(rptTypeName)+"' ";
	String orderBy = "a.createDate,a.createTime";
	
	String sqlprimarykey = "a.id";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	String tableString=""+
       "<table instanceid=\"FNA_FNA_RPT_HISTORY_LIST\" pageId=\""+PageIdConst.FNA_FNA_RPT_HISTORY_LIST+"\" "+
   			" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_FNA_RPT_HISTORY_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
       "<checkboxpopedom showmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaRpt_checkboxpopedom\" popedompara=\"column:id+"+user.getUID()+"\"/>"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
       " sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"desc\" sqlisdistinct=\"true\" "+
       " />"+
       "<head>"+
			"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15517,user.getLanguage())+"\" column=\"tbName\" orderkey=\"tbName\" "+//报表名称
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFanRptTotalBudgetUrl\" otherpara=\"column:id\" "+
					" />"+
			"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"description\" orderkey=\"description\" "+//描述
					" />"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" "+//创建人
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getHrmNameLink\" "+
					" />"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createDate\" orderkey=\"createDate\" "+//创建时间
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFullDateTime\" otherpara=\"column:createTime\" "+
					" />"+
       "</head>"+
		"		<operates>"+
		"			<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaRpt_popedom\" otherpara=\""+user.getUID()+"\"></popedom> "+
		"			<operate href=\"javascript:doQryView();\" text=\""+SystemEnv.getHtmlLabelName(82527, user.getLanguage())+"\" index=\"0\"/>"+//查询中打开
		"			<operate href=\"javascript:doSaveResult();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"1\"/>"+//编辑
		"			<operate href=\"javascript:doShare();\" text=\""+SystemEnv.getHtmlLabelName(119, user.getLanguage())+"\" index=\"2\"/>"+//共享
		"			<operate href=\"javascript:doDelete();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"3\"/>"+//删除
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_FNA_RPT_HISTORY_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>

<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
});

function hiddenSaveBtn(){
	_table.reLoad();
}


//批量删除
function batchDel(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage()) %>");
		return;
	}
	var _data = "operation=batchDel&rptTypeName=<%=rptTypeName %>&batchDelIds="+ids;
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/report/common/FnaRptSaveOp.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							_table.reLoad();
						}else{
							top.Dialog.alert(_json.msg);
						}
				    }catch(e1){
				    }
				}
			});	
		}, function(){}
	);
}

//单个删除
function doDelete(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage()) %>",
			function(){
			    try{
					var _data = "operation=delete&rptTypeName=<%=rptTypeName %>&id="+id;

					openNewDiv_FnaBudgetViewInner1(_Label33574);
					jQuery.ajax({
						url : "/fna/report/common/FnaRptSaveOp.jsp",
						type : "post",
						cache : false,
						processData : false,
						data : _data,
						dataType : "json",
						success: function do4Success(_json){
						    try{
								try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
								if(_json.flag){
									_table.reLoad();
								}else{
									top.Dialog.alert(_json.msg);
								}
						    }catch(e1){
						    }
						}
					});	
			    }catch(e1){
			    }
		},function(){
		}
	);
}

//共享
function doShare(id){
	_fnaOpenDialog("/fna/report/common/FnaRptShare.jsp?rptTypeName=<%=rptTypeName %>&id="+id, 
			"<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %>", 
			800, 600);
}

//保存查询结果
function doSaveResult(id){
	_fnaOpenDialog("/fna/report/common/FnaRptSave.jsp?rptTypeName=<%=rptTypeName %>&id="+id, 
			"<%=SystemEnv.getHtmlLabelName(82523,user.getLanguage()) %>", 
			200, 230);
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	if(from_advSubmit=="from_advSubmit"){
		jQuery("#nameQuery").val(jQuery("#advQryName").val());
	}else{
		jQuery("#advQryName").val(jQuery("#nameQuery").val());
	}
	form2.submit();
}

//查询中打开
function doQryView(id){
	window.location.href="/fna/report/common/FnaRptSubmitPage.jsp?id="+id;
}

//关闭
function doClose1(){
	window.closeDialog();
}

//重定义分页控件显示行数选择后刷新页面函数
function reloadPage(){
	window.location.href = window.location.href;
}

</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
