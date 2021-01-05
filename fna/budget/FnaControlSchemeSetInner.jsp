<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
if(!HrmUserVarify.checkUserRight("fnaControlScheme:set", user)){
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

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} ";//新建
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doBatchDel(),_self} ";//批量删除
    RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post"  action="/fna/budget/FnaControlSchemeSetInner.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doAdd();"/><!-- 新建 -->
            <input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="doBatchDel()"/><!-- 批量删除 -->
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=FnaCommon.escapeHtml(nameQuery) %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<%
	//设置好搜索条件
	String backFields ="a.*, b.fnayear, "+
		" case when (a.enabled=1) then '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(18095,user.getLanguage()))+"' "+//启用
		" else '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(18096,user.getLanguage()))+"' end as enabledName ";//禁用
	String fromSql = " from fnaControlScheme a \n" +
			" join FnaYearsPeriods b on a.fnayearid = b.id \n";
	String sqlWhere = "";
	if(!"".equals(nameQuery)){
		sqlWhere = " where (a.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' or a.code like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n"; 
	}

	String orderBy = "b.fnayear, a.enabled, a.code, a.name";
	
	String sqlprimarykey = "a.id";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_CONTROL_SCHEME_SET_INNER_LIST\" pageId=\""+PageIdConst.FNA_CONTROL_SCHEME_SET_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_CONTROL_SCHEME_SET_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"desc\" />"+
       "<head>"+
			"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(33162,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" "+//方案名称
     				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"openEditPage+column:id\"/>"+
			"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(33163,user.getLanguage())+"\" column=\"code\" orderkey=\"code\" "+//方案编码
					" transmethod=\"weaver.fna.general.FnaCommon.escapeHtml\" />"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15365,user.getLanguage())+"\" column=\"fnayear\" orderkey=\"fnayear\" "+//预算年度
					" />"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(33164,user.getLanguage())+"\" column=\"enabledName\" orderkey=\"enabledName\" "+//启用方案
					" />"+
       "</head>"+
		"		<operates>"+
		"			<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaControlSchemeSetEditInner_popedom\" otherpara=\"column:enabled\" ></popedom> "+
		"			<operate href=\"javascript:doEnable_grid();\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" index=\"0\"/>"+//启用
		"			<operate href=\"javascript:doEnable_grid();\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" index=\"1\"/>"+//禁用
		"			<operate href=\"javascript:openEditPage();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"2\"/>"+//编辑
		"			<operate href=\"javascript:doDel_grid();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>"+//删除
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_CONTROL_SCHEME_SET_INNER_LIST %>" />
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

//启用
function doEnable_grid(id, _param2, _obj){
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	var _data = "operation=enable&id="+id;
	
	jQuery.ajax({
		url : "/fna/budget/FnaControlSchemeSetOp.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
		    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					//_table.reLoad();
					var _enableName = "<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage()) %>";//启用
					var _disableName = "<%=SystemEnv.getHtmlLabelName(18096,user.getLanguage()) %>";//禁用
					if(_json.enable==1){
						jQuery(_obj).children().html(_disableName);
						jQuery("#_xTable_"+id).parent().parent().next().next().next().next().html(_enableName);
					}else{
						jQuery(_obj).children().html(_enableName);
						jQuery("#_xTable_"+id).parent().parent().next().next().next().next().html(_disableName);
					}
				}else{
					top.Dialog.alert(_json.msg);
				}
		    }catch(e1){
		    }
		}
	});	
}

//批量删除
function doBatchDel(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==null||ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage()) %>");//请先选择需要删除的数据
		return;
	}
	var _data = "operation=batchDel&ids="+ids;
	
	//确认要删除吗
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage()) %>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/budget/FnaControlSchemeSetOp.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
				    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				    	top.Dialog.alert(_json.msg);
						if(_json.flag){
							_table.reLoad();
						}
				    }catch(e1){
				    }
				}
			});	
		},
		function(){}
	);
}

//删除
function doDel_grid(id,_para2,_obj){
	var _data = "operation=del&id="+id;

	//确认要删除吗
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage()) %>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/budget/FnaControlSchemeSetOp.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
				    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				    	top.Dialog.alert(_json.msg);
						if(_json.flag){
							_table.reLoad();
						}
				    }catch(e1){
				    }
				}
			});	
		},
		function(){}
	);
}

//方案设置
function doLogicSet_grid(id, param2, param3){
	openEditPage(id, param2, param3, 2);
}

//编辑
function openEditPage(id, param2, param3, tabId, parentWin){
	var _w = 750;
	var _h = 365;
	if(parentWin!=null){
		doClose1();
		onBtnSearchClick();
	}
	_fnaOpenDialog("/fna/budget/FnaControlSchemeSetEdit.jsp?id="+id+"&tabId="+tabId, 
			"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(33071,user.getLanguage()) %>", 
			_w, _h);
}

//新建
function doAdd(){
	var _w = 400;
	var _h = 270;
	_fnaOpenDialog("/fna/budget/FnaControlSchemeSetAdd.jsp", 
			"<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33071,user.getLanguage()) %>", 
			_w, _h);
}

//关闭
function doClose1(){
	window.closeDialog();
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
        top.Dialog.alert("<%= SystemEnv.getHtmlLabelName(127108,user.getLanguage())%>");
    }else {
        downExcel(ids);
    }
};
function downExcel(ids){
    try{
        var elemIF = document.createElement("iframe");
        var url = "/fna/budget/FnaControlSchemeSetInnerDownload.jsp";
        if(ids) {
            url += "?type=select&ids="+ids;
        }else {
            url += "?type=all";
        }
        elemIF.src = url;
        elemIF.style.display = "none";
        document.body.appendChild(elemIF);
    }catch(e){
    }
}

//批量导入
function batchImp(){
    var _w = 580;
    var _h = 420;
    _fnaOpenDialog("/fna/budget/FnaControlSchemeSetInnerImport.jsp",
            "<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage()) %>",
            _w, _h);
}
</script>

</body>
</html>
