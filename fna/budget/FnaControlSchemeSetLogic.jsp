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
String titlename = "";//费控流程 //33075
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

int mainId = Util.getIntValue(request.getParameter("id"), 0);
boolean isFromLeftMainMenu = false;

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
<%
if(!isFromLeftMainMenu){ 
%>
<div class="zDialog_div_content">
<%
}
%>
<form id="form2" name="form2" method="post" action="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doAdd();"/><!-- 新建 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="doBatchDel()"/><!-- 批量删除 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<%
	//设置好搜索条件
	String backFields ="a.id, a.mainId, a.kmIds, a.orgType, a.orgIds, a.promptSC, a.promptTC, a.promptEN, a.kmIdsCondition, a.orgIdsCondition, a.intensity, "+
		" case when (intensity=1) then '"+SystemEnv.getHtmlLabelName(26009,user.getLanguage())+"' "+//不控制
		"		when (intensity=2) then '"+SystemEnv.getHtmlLabelName(32137,user.getLanguage())+"' "+//强控
		"		when (intensity=3) then '"+SystemEnv.getHtmlLabelName(32138,user.getLanguage())+"' "+//弱控
		" end intensityName";
	if(user.getLanguage()==7){
		backFields += ", a.promptSC prompt";
	}else if(user.getLanguage()==8){
		backFields += ", a.promptEN prompt";
	}else if(user.getLanguage()==9){
		backFields += ", a.promptTC prompt";
	}
	String fromSql = " from fnaControlSchemeDtl a \n";
	String sqlWhere = " where a.mainId = "+mainId+" ";

	String orderBy = " a.intensity ";
	
	String sqlprimarykey = "a.id";
	
	String tabletype = "checkbox";
	
	String operates = "		<operates>"+
					"			<operate href=\"javascript:doEdit_grid();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"1\"/>"+//编辑
					"			<operate href=\"javascript:doDel_grid();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"2\"/>"+//删除
					"		</operates>";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_CONTROL_SCHEME_SET_LOGIC_LIST\" pageId=\""+PageIdConst.FNA_CONTROL_SCHEME_SET_LOGIC_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_CONTROL_SCHEME_SET_LOGIC_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\""+tabletype+"\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" />"+
       "<head>"+
			"<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(27955,user.getLanguage())+"\" column=\"id\" "+//触发条件
					" otherpara=\"column:kmIds+column:orgType+column:orgIds+column:kmIdsCondition+column:orgIdsCondition+"+user.getLanguage()+"\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getWfSetPageLogicConditionsFnaWfSetEditPageLogicSet\" "+
					" />"+
			"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(32134,user.getLanguage())+"\" column=\"intensityName\" orderkey=\"intensity\" "+//费控强度
					" />"+
			"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(33141,user.getLanguage())+"\" column=\"prompt\" orderkey=\"prompt\" "+//提示语句
					" transmethod=\"weaver.fna.general.FnaCommon.escapeHtml\" />"+
       "</head>"+
				operates+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_CONTROL_SCHEME_SET_LOGIC_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<%
if(!isFromLeftMainMenu){ 
%>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="onCancel();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<%
}
%>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
<%
if(!isFromLeftMainMenu){ 
%>
	resizeDialog(document);
<%
}
%>
});

//快速（高级）搜索事件
function onBtnSearchClick(){
	form2.submit();
}

//批量删除
function doBatchDel(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==null||ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage()) %>");//请先选择需要删除的数据
		return;
	}
	var _data = "operation=batchFnaControlSchemeSetLogicDel&mainId=<%=mainId %>&ids="+ids;
	
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
							onBtnSearchClick();
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
function doDel_grid(id){
	var _data = "operation=FnaControlSchemeSetLogicDel&mainId=<%=mainId %>&id="+id;

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
							onBtnSearchClick();
						}
				    }catch(e1){
				    }
				}
			});	
		},
		function(){}
	);
}

//进入详细设置
function doEdit_grid(id, param2, param3, tabId, parentWin){
	var _w = 650;
	var _h = 525;
	if(parentWin!=null){
		doClose1();
		onBtnSearchClick();
	}
	_fnaOpenDialog("/fna/budget/FnaControlSchemeSetLogicEditPage.jsp?mainId=<%=mainId %>&id="+id, 
			"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(32132,user.getLanguage()) %>", 
			_w, _h);
}

//新建
function doAdd(){
	var _w = 650;
	var _h = 525;
	_fnaOpenDialog("/fna/budget/FnaControlSchemeSetLogicEditPage.jsp?mainId=<%=mainId %>", 
			"<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(32132,user.getLanguage()) %>", 
			_w, _h);
}

function onCancel(){
	parent.onCancel();	
}

</script>

</body>
</html>
