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
if(!HrmUserVarify.checkUserRight("CostStandardDimension:Set", user)){
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
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post"  action="/fna/costStandard/costStandardInner.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doAdd();"/><!-- 新建 -->
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=FnaCommon.escapeHtml(nameQuery) %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<%
	//设置好搜索条件
	String backFields ="a.*, "+
		" case when (a.enabled=1) then '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(18095,user.getLanguage()))+"' "+//启用
		" else '"+StringEscapeUtils.escapeSql(SystemEnv.getHtmlLabelName(18096,user.getLanguage()))+"' end as enabledName ";//禁用
	String fromSql = " from FnaCostStandard a \n";
	String sqlWhere = "";
	if(!"".equals(nameQuery)){
		sqlWhere = " where a.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' \n"; 
	}

	String orderBy = "a.orderNumber,a.name";
	
	String sqlprimarykey = "a.guid1";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_CONTROL_SCHEME_SET_INNER_LIST\" pageId=\""+PageIdConst.FNA_CONTROL_SCHEME_SET_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_CONTROL_SCHEME_SET_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" />"+
       "<head>"+
			"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(125501,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" "+//维度名称
     				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"openEditPage+column:guid1\"/>"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(125502,user.getLanguage())+"\" column=\"paramtype\" orderkey=\"paramtype\" "+//表现形式
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getParamtypeName\" otherpara=\"column:browsertype+"+user.getLanguage()+"+column:fielddbtype\"/>"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(125503,user.getLanguage())+"\" column=\"compareoption1\" orderkey=\"compareoption1\" "+//判断符
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getCompareoption1Name\" otherpara=\""+user.getLanguage()+"\"/>"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(125504,user.getLanguage())+"\" column=\"enabledName\" orderkey=\"enabledName\" "+//是否启用
					" />"+
			"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"Description\" "+//描述
					" />"+
       "</head>"+
		"		<operates>"+
		"			<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getCostStandardInner_popedom\" otherpara=\"column:enabled\" ></popedom> "+
		"			<operate href=\"javascript:doEnable_grid();\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" index=\"0\"/>"+//启用
		"			<operate href=\"javascript:doEnable_grid();\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" index=\"1\"/>"+//禁用
		"			<operate href=\"javascript:openEditPage();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"2\"/>"+//编辑
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_CONTROL_SCHEME_SET_INNER_LIST %>" />
				<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
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
	var _data = "operation=enable&guid="+id;
	
	jQuery.ajax({
		url : "/fna/costStandard/costStandardInnerOp.jsp",
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

					var _obj_table = jQuery("div[class='table']");
					var _obj_listStyle = _obj_table.find("table[class='ListStyle']");
					var _obj_checkboxid = _obj_listStyle.find("input[checkboxid='"+id+"']");
					
					if(_json.enable==1){
						jQuery(_obj).children().html(_disableName);
						_obj_checkboxid.parent().next().next().next().next().html(_enableName);
					}else{
						jQuery(_obj).children().html(_enableName);
						_obj_checkboxid.parent().next().next().next().next().html(_disableName);
					}
				}else{
					top.Dialog.alert(_json.msg);
				}
		    }catch(e1){
		    }
		}
	});	
}

//编辑
function openEditPage(id){
	var _w = 450;
	var _h = 365;
	_fnaOpenDialog("/fna/costStandard/costStandardEdit.jsp?guid="+id, 
			"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(82531,user.getLanguage()) %>", 
			_w, _h);
}

//新建
function doAdd(){
	var _w = 450;
	var _h = 365;
	_fnaOpenDialog("/fna/costStandard/costStandardAdd.jsp", 
			"<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(82531,user.getLanguage()) %>", 
			_w, _h);
}

//关闭
function doClose1(){
	window.closeDialog();
}

</script>

</body>
</html>