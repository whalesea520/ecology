<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
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
// || HrmUserVarify.checkUserRight("FnaBudgetfeeTypeEdit:Edit",user)
boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

boolean fnaSubjectInitE8_checkNeedInit = FnaSubjectInitE8.checkNeedInit();

BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(332,user.getLanguage());//全部
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

int subjectId = Util.getIntValue(request.getParameter("subjectId"),0);

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
String advQryArchive = Util.null2String(request.getParameter("advQryArchive")).trim();
int advQrybudgetAutoMove = Util.getIntValue(request.getParameter("advQrybudgetAutoMove"), -1);
int advQryIsEditFeeType = Util.getIntValue(request.getParameter("advQryIsEditFeeType"), -1);

int feelevel = 0;

String sql = "select a.feelevel from FnaBudgetfeeType a where a.id = "+subjectId;
rs.executeSql(sql);
if(rs.next()){
	feelevel = Util.getIntValue(rs.getString("feelevel"), 0);
}

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter(), 0);


String xjLable = SystemEnv.getHtmlLabelName(27170,user.getLanguage());
if(feelevel==0){
	xjLable = "";
}
xjLable = "";
%>

<%@page import="weaver.fna.general.FnaSubjectInitE8"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%><html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(feelevel<9){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addSub("+subjectId+"),_TOP} ";//新建下级科目
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_TOP} ";//批量删除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(127095,user.getLanguage())+",javascript:exportSelect(),_TOP} ";//导出所选记录
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(125595,user.getLanguage())+",javascript:exportAll(),_TOP} ";//全部导出
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(26601,user.getLanguage())+",javascript:batchImp(),_TOP} ";//批量导入
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form2" method="post"  action="/fna/maintenance/FnaBudgetfeeTypeGridViewInner.jsp">
<input type="hidden" id="subjectId" name="subjectId" value="<%=subjectId %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%if(feelevel<9){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+xjLable+SystemEnv.getHtmlLabelName(585,user.getLanguage())%>" 
				class="e8_btn_top" onclick="addSub(<%=subjectId %>);"/><!-- 新建下级科目 -->
		<%} %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
            <input type="button" value="<%=SystemEnv.getHtmlLabelName(125595,user.getLanguage()) %>" class="e8_btn_top" onclick="exportAll()"/><!-- 全部导出 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage()) %>" class="e8_btn_top" onclick="batchImp()"/><!-- 批量导入 -->
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=FnaCommon.escapeHtml(nameQuery) %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span><!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	
	<wea:layout type="4Col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905, user.getLanguage()) %>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15409,user.getLanguage())%></wea:item><!-- 科目名称 -->
		    <wea:item>
		    	<input type=text id="advQryName" name="advQryName" class=Inputstyle value='<%=FnaCommon.escapeHtml(nameQuery) %>' />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item><!-- 状态 -->
	    	<wea:item>
	            <select class="" id="advQryArchive" name="advQryArchive" style="width: 80px;">
	              <option value=""></option>
	              <option value="0" <% if("0".equals(advQryArchive)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(25456,user.getLanguage())%></option>
	              <option value="1" <% if("1".equals(advQryArchive)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22205,user.getLanguage())%></option>
	            </select>
	    	</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(30786,user.getLanguage())%></wea:item><!-- 是否结转 -->
			<wea:item>
	            <select class=inputstyle id="advQrybudgetAutoMove" name="advQrybudgetAutoMove" style="width: 80px;">
	              <option value="-1" <% if(advQrybudgetAutoMove==-1) {%>selected<%}%>></option>
	              <option value="1" <% if(advQrybudgetAutoMove==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	              <option value="0" <% if(advQrybudgetAutoMove==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
	            </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(128826,user.getLanguage())%></wea:item><!-- 可编制预算 -->
			<wea:item>
	            <select class=inputstyle id="advQryIsEditFeeType" name="advQryIsEditFeeType" style="width: 80px;">
	              <option value="-1" <% if(advQryIsEditFeeType==-1) {%>selected<%}%>></option>
	              <option value="1" <% if(advQryIsEditFeeType==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	              <option value="0" <% if(advQryIsEditFeeType==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
	            </select>
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
	//设置好搜索条件
	String backFields =" a.*, "+
			" case when (a.budgetAutoMove=1) then '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(163,user.getLanguage()))+"' "+
    		" 	else '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(161,user.getLanguage()))+"' end budgetAutoMoveName, "+
			" case when (a.isEditFeeType=1) then '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(163,user.getLanguage()))+"' "+
    		" 	else '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(161,user.getLanguage()))+"' end isEditFeeTypeName, "+
			" case when (a.groupCtrl=1) then '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(163,user.getLanguage()))+"' "+
    		" 	else '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(161,user.getLanguage()))+"' end groupCtrlName, "+
    		" case when (a.budgetCanBeNegative=1) then '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(163,user.getLanguage()))+"' "+
    		" 	else '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(161,user.getLanguage()))+"' end budgetCanBeNegativeName ";		
	String fromSql = " from FnaBudgetfeeType a ";
	String sqlWhere = " where 1=1 ";
	if(subjectId > 0){
		//sqlWhere += "and "+FnaCostCenter.getDbUserName()+"fnaChkSubjectAffi("+subjectId+", a.id)=1 ";
		sqlWhere += "and a.allSupSubjectIds like '"+StringEscapeUtils.escapeSql(budgetfeeTypeComInfo.getAllSupSubjectIds(subjectId+""))+"%' ";
	}
	if(!"".equals(nameQuery)){
		sqlWhere += " and a.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' ";
	}
	if(!"".equals(advQryArchive)){
		if("0".equals(advQryArchive)){//未封存
			sqlWhere += " and (a.archive is null or a.archive = 0) ";
		}else if("1".equals(advQryArchive)){//已封存
			sqlWhere += " and a.archive = 1 ";
		}else{
			sqlWhere += " and a.archive = "+Util.getIntValue(advQryArchive)+" ";
		}
	}
	if(advQrybudgetAutoMove == 0){
		sqlWhere += " and (a.budgetAutoMove = 0 or a.budgetAutoMove is null) ";
	}else if (advQrybudgetAutoMove == 1){
        sqlWhere += " and a.budgetAutoMove = 1 ";
    }
	if(advQryIsEditFeeType == 1){
		sqlWhere += " and a.isEditFeeType = "+advQryIsEditFeeType+" ";
	}else if(advQryIsEditFeeType == 0){
		sqlWhere += " and (a.isEditFeeType is null or a.isEditFeeType = 0) ";
	}

	String orderBy=" a.feeperiod,a.feelevel,a.displayOrder,a.codename,a.name ";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_BUDGET_FEETYPE_GRIDVIEW_INNER_LIST\" pageId=\""+PageIdConst.FNA_BUDGET_FEETYPE_GRIDVIEW_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_BUDGET_FEETYPE_GRIDVIEW_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
	   "<checkboxpopedom showmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaBudgetfeeTypeViewInner_checkboxpopedom\" popedompara=\"column:id\"/>"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\"id\" sqlsortway=\"Asc\" />"+
       "<head>"+
             "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15409,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" "+
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"doEdit_grid+column:id\"/>"+
			 "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1321,user.getLanguage())+"\" column=\"codeName\" orderkey=\"codeName\" "+
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"doEdit_grid+column:id\"/>"+
             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18427,user.getLanguage())+"\" column=\"feelevel\" orderkey=\"feelevel\" otherpara=\""+user.getLanguage()+"\" "+
             	" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getSubjectLevel\" />"+
             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"archive\" orderkey=\"archive\" otherpara=\""+user.getLanguage()+"\" "+
             	" transmethod=\"weaver.fna.maintenance.SplitPageFnaBudget.getSubjectStatus\" />"+
   			 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(128826,user.getLanguage())+"\" column=\"isEditFeeTypeName\" orderkey=\"isEditFeeTypeName\" />"+
			 "<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(32099,user.getLanguage())+"\" column=\"groupCtrlName\" orderkey=\"groupCtrlName\" />"+
			 "<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(130715,user.getLanguage())+"\" column=\"budgetCanBeNegativeName\" orderkey=\"budgetCanBeNegativeName\" />"+
			 "<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(30786,user.getLanguage())+"\" column=\"budgetAutoMoveName\" orderkey=\"budgetAutoMoveName\" />"+
			 "<col width=\"19%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"description\" />"+
       "</head>"+
		"		<operates>"+
		"			<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaBudgetfeeTypeViewInner_popedom\" otherpara=\"column:archive\" ></popedom> "+
		"			<operate href=\"javascript:doEdit_grid();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+
		"			<operate href=\"javascript:doLifted_grid();\" text=\""+SystemEnv.getHtmlLabelName(22152, user.getLanguage())+"\" index=\"1\"/>"+
		"			<operate href=\"javascript:doArchive_grid();\" text=\""+SystemEnv.getHtmlLabelName(22151, user.getLanguage())+"\" index=\"2\"/>"+
		"			<operate href=\"javascript:doDel_grid();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"3\"/>";
	if(subjectFilter){
		tableString+=" <operate href=\"javascript:ruleSet();\" text=\""+SystemEnv.getHtmlLabelNames("33511,19374", user.getLanguage())+"\" index=\"4\"/>";
	}
	tableString+=" </operates>"+
       "</table>";
%>
	<input id="feelevel" value="<%=feelevel %>" type="hidden" />
	<wea:layout type="4col">
<%
	String attributes = "{\"groupDisplay\":\"none\"}";
%>
		<wea:group context='<%=xjLable+SystemEnv.getHtmlLabelName(585,user.getLanguage())%>' attributes="<%=attributes %>" ><!-- 科目 -->
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_BUDGET_FEETYPE_GRIDVIEW_INNER_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//页面初始化事件
jQuery(document).ready(function(){
	var fnaSubjectInitE8_checkNeedInit = <%=fnaSubjectInitE8_checkNeedInit%>;
	if(fnaSubjectInitE8_checkNeedInit){
		//是否要重新初始化预算科目？重新初始化科目将删除所有现有科目！
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128474,user.getLanguage()) %>",
			function(){
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/maintenance/fnaSubjectInitE8Operation.jsp",
					type : "post",
					cache : false,
					processData : false,
					data : "operation=initSubjectE8",
					dataType : "json",
					success: function do4Success(_json){
					    try{
							try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
							if(_json.flag){
								parent.parent.location.href = parent.parent.location.href;
							}else{
								alert(_json.msg._fnaReplaceAll("<br>","\r")._fnaReplaceAll("<br />","\r"));
							}
					    }catch(e1){
							try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					    }
					}
				});	
			}
		);
	}
});

//批量导入
function batchImp(){
	var _w = 580;
	var _h = 420;
	_fnaOpenDialog("/fna/batch/FnaBudgetTypeBatch.jsp", 
			"<%=SystemEnv.getHtmlLabelName(20208,user.getLanguage()) %>", 
			_w, _h);
}

//编辑
function doEdit_grid(id){
	var feelevel = null2String(jQuery("#feelevel").val());
	var _h = 650;
	_fnaOpenDialog("/fna/maintenance/FnaBudgetfeeTypeEdit.jsp?id="+id, 
			"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %>", 
			600, _h);
}

//新建下级科目
function addSub(supsubject){
	var feelevel = null2String(jQuery("#feelevel").val());
	var _h = 650;
	_fnaOpenDialog("/fna/maintenance/FnaBudgetfeeTypeAdd.jsp?supsubject="+supsubject, 
			"<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %>", 
			600, _h);
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

//删除
function doDel_grid(_id){
	var _data = "operation=delete&id="+_id;

	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/maintenance/FnaBudgetfeeTypeOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							if(fnaRound(_json.delFeelevel_last,0)==1){
								parent.parent.leftframe.do_reAsyncChildNodes(null);
							}else{
								parent.parent.leftframe.do_reAsyncChildNodes((fnaRound(_json.delFeelevel_last,0)-1)+"_"+_json.delSupsubject_last);
							}
							window._table.reLoad();
						}else{
							top.Dialog.alert(_json.msg);
						}
				    	showRightMenuIframe();
				    }catch(e1){
				    	showRightMenuIframe();
				    }
				}
			});	
		}, function(){}
	);
}

//批量删除
function batchDel(){
	var id = null2String(jQuery("#subjectId").val());
	var feelevel = null2String(jQuery("#feelevel").val());
	if(id==""){
		id="0";
	}
	if(feelevel==""){
		feelevel="0";
	}
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(585,user.getLanguage()) %>");
		return;
	}
	var _data = "operation=batchDel&batchDelIds="+ids;
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/maintenance/FnaBudgetfeeTypeOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							parent.parent.leftframe.do_reAsyncChildNodes(null);
							window._table.reLoad();
						}else{
							top.Dialog.alert(_json.msg);
						}
				    	showRightMenuIframe();
				    }catch(e1){
				    	showRightMenuIframe();
				    }
				}
			});	
		}, function(){}
	);
}

//解封
function doLifted_grid(_id){
	var id = null2String(jQuery("#subjectId").val());
	var feelevel = null2String(jQuery("#feelevel").val());
	if(id==""){
		id="0";
	}
	if(feelevel==""){
		feelevel="0";
	}
	_id += ",";
	var _data = "operation=lifted&checkid="+_id;
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/maintenance/FnaBudgetfeeTypeOperation.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					parent.parent.leftframe.do_reAsyncChildNodes(feelevel+"_"+id, feelevel+"_"+id);
					window._table.reLoad();
				}else{
					top.Dialog.alert(_json.msg);
				}
		    	showRightMenuIframe();
		    }catch(e1){
		    	showRightMenuIframe();
		    }
		}
	});	
}

//封存检查，并封存
function doArchive2_grid(_id){
	var id = null2String(jQuery("#subjectId").val());
	var feelevel = null2String(jQuery("#feelevel").val());
	if(id==""){
		id="0";
	}
	if(feelevel==""){
		feelevel="0";
	}
	var _data = "operation=archive&checkid="+_id;
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/maintenance/FnaBudgetfeeTypeOperation.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					parent.parent.leftframe.do_reAsyncChildNodes(feelevel+"_"+id, feelevel+"_"+id);
					window._table.reLoad();
				}else{
					top.Dialog.alert(_json.msg);
				}
		    	showRightMenuIframe();
		    }catch(e1){
		    	showRightMenuIframe();
		    }
		}
	});	
}

//grid 封存检查，并封存
function doArchive_grid(_id){
	hideRightMenuIframe();
	try{
		_id += ",";
		var _data = "checkid="+_id;
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/maintenance/FnaBudgetfeeTypeViewAjax.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(_html){
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
		    	_html = jQuery.trim(_html);
				if(_html=="1"){
					top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81278,user.getLanguage())%>",
						function(){
							doArchive2_grid(_id);
						},
						function(){
							showRightMenuIframe();
						},
						360
					);
				}else{
					doArchive2_grid(_id);
				}
			}
		});	
	}catch(e1){
		showRightMenuIframe();
	}
}

//删除
function doDelete(){
	hideRightMenuIframe();
    try{
		var id = null2String(jQuery("#subjectId").val());
	
		var _data = "operation=delete&id="+id;

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/maintenance/FnaBudgetfeeTypeOperation.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						parent.parent.leftframe.do_reAsyncChildNodes("0_0", "0_0");
					}else{
						top.Dialog.alert(_json.msg);
					}
			    	showRightMenuIframe();
			    }catch(e1){
			    	showRightMenuIframe();
			    }
			}
		});	
    }catch(e1){
    	showRightMenuIframe();
    }
}

//保存
function doEdit2(obj){
	hideRightMenuIframe();
    try{
		var id = null2String(jQuery("#subjectId").val());
		var name = null2String(jQuery("#name").val());
		var description = null2String(jQuery("#description").val());
		var feeperiod = null2String(jQuery("#feeperiod").val());
		var feetype = null2String(jQuery("#feetype").val());
		var agreegap = null2String(jQuery("#agreegap").val());
		var feelevel = null2String(jQuery("#feelevel").val());
		var supsubject = null2String(jQuery("#supsubject").val());
		var alertvalue = null2String(jQuery("#alertvalue").val());
		var archive = null2String(jQuery("#archive").val());
		var feeCtlLevel = null2String(jQuery("#feeCtlLevel").val());
	
		var _data = "operation=edit&id="+id+
			"&name="+encodeURI(name)+"&description="+encodeURI(description)+
			"&feeperiod="+feeperiod+"&feetype="+feetype+
			"&agreegap="+agreegap+"&feelevel="+feelevel+
			"&supsubject="+supsubject+"&alertvalue="+alertvalue+
			"&archive="+archive+"&feeCtlLevel="+feeCtlLevel;

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/maintenance/FnaBudgetfeeTypeOperation.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						top.Dialog.alert(_json.msg);
						parent.parent.leftframe.do_reAsyncChildNodes((fnaRound(feelevel,0)-1)+"_"+supsubject, (fnaRound(feelevel,0)-1)+"_"+supsubject);
					}else{
						top.Dialog.alert(_json.msg);
					}
			    	showRightMenuIframe();
			    }catch(e1){
			    	showRightMenuIframe();
			    }
			}
		});	
    }catch(e1){
    	showRightMenuIframe();
    }
}

//封存检查，并保存
function doEdit(obj){
    if(check_form(form2,"name")&&check_form(form2,"supsubject")){
		hideRightMenuIframe();
		try{
			var id = null2String(jQuery("#subjectId").val());
			var archive = null2String(jQuery("#archive").val());
			var _data = "checkid="+id;
			if(archive=="1"){
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/maintenance/FnaBudgetfeeTypeViewAjax.jsp",
					type : "post",
					cache : false,
					processData : false,
					data : _data,
					dataType : "html",
					success: function do4Success(_html){
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				    	_html = jQuery.trim(_html);
						if(_html=="1"){
							top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81278,user.getLanguage())%>",
								function(){
									doEdit2(obj);
								},
								function(){
								  	showRightMenuIframe();
								},
								360
							);
						}else{
							doEdit2(obj);
						}
					}
				});	
			}else{
				doEdit2(obj);
			}
		}catch(e1){
			showRightMenuIframe();
		}
    }
}

function onShowBudgetfeeType(){
    level=jQuery("select[name=feelevel]").val()-1;
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?level="+level);
    if (data!=null){
		if (data.id!= 0){
			if(data.id!="<%=subjectId%>"){
            jQuery("#supsubjectspan").html(data.name);
			jQuery("input[name=supsubject]").val(data.id);
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(24125,user.getLanguage())%>");
			}
		}else{
			jQuery("#supsubjectspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=supsubject]").val("");
		}
	}
}

function OpenNewWindow(sURL,w,h){
  var iWidth = 0 ;
  var iHeight = 0 ;
  iWidth=(window.screen.availWidth-10)*w;
  iHeight=(window.screen.availHeight-50)*h;
  ileft=(window.screen.availWidth - iWidth)/2;
  itop= (window.screen.availHeight - iHeight + 50)/2;
  var szFeatures = "" ;
  szFeatures =	"resizable=no,status=no,menubar=no,width=" + iWidth + ",height=" + iHeight*h + ",top="+itop+",left="+ileft
  window.open(sURL,"",szFeatures)
}

function ruleSet(id){
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/maintenance/FnaBudgetfeeTypeViewAjax2.jsp?checkid="+id,
		type : "post",
		cache : false,
		processData : false,
		dataType : "json",
		success: function do4Success(_jsonObj){
			try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			if(_jsonObj.result1=="2"){
				//批量设置将影响所选科目及其下级的所有科目,是否继续？
				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128832,user.getLanguage())%>",
					function(){
						_fnaOpenDialog("/fna/maintenance/FnaBudgetfeetypeRuleSetAdd.jsp?ids="+id,  
							"<%=SystemEnv.getHtmlLabelNames("33511,19374",user.getLanguage()) %>", 600, 380);
					}, 
					function(){}
				);
			}else{
				_fnaOpenDialog("/fna/maintenance/FnaBudgetfeetypeRuleSetAdd.jsp?ids="+id,  
						"<%=SystemEnv.getHtmlLabelNames("33511,19374",user.getLanguage()) %>", 600, 380);
			}
		}
	});	
}

/**
 *   导出全部数据
 */
function exportAll() {
    downExcel();
};
/**
 * 导出列表中所勾选的数据
 */
function exportSelect() {
    var ids = _xtable_CheckedCheckboxId();
    if(!ids || ids =='' ) {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127108,user.getLanguage())%>");
    }else {
        downExcel(ids);
    }
};
function downExcel(ids){
    try{
        var elemIF = document.createElement("iframe");
        elemIF.style.display = "none";
        var url = "/fna/maintenance/FnaBudgetfeeTypeDownload.jsp";
        if(ids) {
            url += "?type=select&ids="+ids;
        }else {
            url += "?type=all";
        }
        elemIF.src = url;
        document.body.appendChild(elemIF);
    }catch(e){
    }
}
</script>

</body>
</html>
