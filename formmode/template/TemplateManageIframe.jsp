<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.*"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
int customid = Util.getIntValue(request.getParameter("customid"),0);
String templatename = Util.null2String(request.getParameter("templatename"));
String templatetype = Util.null2String(request.getParameter("templatetype"));
String sourcetype = Util.null2String(request.getParameter("sourcetype"));//来源：1-高级搜索；2-普通查询

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83141 ,user.getLanguage()); //高级搜索条件列表;
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
//模板管理界面
RCMenu += "{"+SystemEnv.getHtmlLabelName(82 ,user.getLanguage())+",javascript:createTemplate(),_self} " ;//创建
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:onSearch(),_self} " ;//搜索
RCMenuHeight += RCMenuHeightStep;
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/formmode/js/modebrow_wev8.js"></script>
<style>

</style>
</head>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %>" class="e8_btn_top" onclick="createTemplate();"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %><!-- 高级搜索 --></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:hide;overflow: auto">
<form name="frmmain" id="frmmain" method="post"  action="SaveTemplateOperation.jsp" >
<input type="hidden" name="method" value="" />
<input type="hidden" name="templateid" value="" />
<input type="hidden" name="customid" value="<%=customid %>" />
<input type="hidden" name="sourcetype" value="<%=sourcetype %>" />
<wea:layout type="4col">
    <wea:group context="" attributes="{groupDisplay:none}">
    	<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage()) %><!--模板名称--></wea:item>
		<wea:item attributes="{'colspan':'3'}">
			<input class=InputStyle maxlength=60 name="templatename" size=30 value="<%=templatename%>">
		</wea:item>
		<%--<wea:item><%=SystemEnv.getHtmlLabelName(19471,user.getLanguage()) %><!--模板类型--></wea:item>
		<wea:item>
			<select name="templatetype" id="templatetype" style="width: 135px;">
				<option value="" />
	    		<option value="0" <%if("0".equals(templatetype)) { %>selected<%} %>><%=SystemEnv.getHtmlLabelName(83139,user.getLanguage()) %><!-- 私人模板 --></option>
	    		<option value="1" <%if("1".equals(templatetype)) { %>selected<%} %>><%=SystemEnv.getHtmlLabelName(83140,user.getLanguage()) %><!-- 公共模板 --></option>
	    	</select>
		</wea:item>--%>
    </wea:group>
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="button" name="search" onclick="onSearch();" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>"/><!-- 搜索 -->
    		<input class="zd_btn_cancle" type="button" name="clear" onclick="onClear();" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>"/><!-- 重置 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</form>
</div>
<div id="splitPageContiner">      
<% 
String backfields = " t1.id,t1.templatename,t1.templatetype,t1.displayorder,t1.isdefault,t1.createrid,t1.createdate ";
String fromSql = " from mode_templateinfo t1 ";
String sqlWhere = " where customid='"+customid+"' and createrid='"+user.getUID()+"'";
if (!"".equals(templatename)) sqlWhere += " and templatename like '%"+templatename+"%'";
if (!"".equals(templatetype)) sqlWhere += " and templatetype='"+templatetype+"'";
if (!"".equals(sourcetype)) sqlWhere += " and sourcetype='"+sourcetype+"'";
String orderby = " displayorder asc";
String temptableString = "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\" column=\"templatename\" orderkey=\"displayorder\" />"; //模板名称
       temptableString += "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19471,user.getLanguage())+"\" column=\"templatetype\" transmethod=\"weaver.formmode.template.service.TemplateInfoService.getTemplateType\" orderkey=\"displayorder\" />";//模板类型
	   temptableString += "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"displayorder\" orderkey=\"displayorder\" />";//显示顺序
	   temptableString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(33731,user.getLanguage())+"\" column=\"isdefault\" transmethod=\"weaver.formmode.template.service.TemplateInfoService.getIsDefault\" orderkey=\"displayorder\" />";//是否默认
	   temptableString += "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" orderkey=\"displayorder\" />";//创建人
	   temptableString += "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"displayorder\" />";//创建日期

String tableString = " <table instanceid=\"templateInfoTable\" tabletype=\"none\"  pagesize=\"20\">"+
                     "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\" excelFileName=\""+SystemEnv.getHtmlLabelName(19853 ,user.getLanguage())+"\"/>"+//模板信息
                     "	   <head>";
       tableString += temptableString;
       tableString += "	   </head>";
       tableString += "	   <operates> " +
                      "		 <operate href=\"javascript:setQueryCondition();\" text=\""+SystemEnv.getHtmlLabelName(83142,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>" + //查询条件定义
                      "		 <operate href=\"javascript:setDisplayColumn();\" text=\""+SystemEnv.getHtmlLabelName(84342,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>" + //查询条件字段定义
                      //"		 <operate href=\"javascript:preview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>" + //预览
                      "		 <operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>" + //编辑
                      "		 <operate href=\"javascript:setDefault();\" text=\""+SystemEnv.getHtmlLabelName(83144,user.getLanguage())+"\" target=\"_self\" index=\"4\"/>" + //设置为默认
                      "		 <operate href=\"javascript:onDelete();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"5\"/>" + //删除
                      "	   </operates>";  
       tableString += " </table>";
%>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</div>
</body>
</html>
<script>
var diag_vote;
function createTemplate(){ //创建模板
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 360;
	diag_vote.Height = 150;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	//模板管理
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(16388 ,user.getLanguage()) %>";//新建模板
	diag_vote.maxiumnable = true;
	diag_vote.URL = "/formmode/template/CreateTemplate.jsp?isdialog=1&customid=<%=customid%>&sourcetype=<%=sourcetype%>";
	diag_vote.show();
}
function closeDlgARfsh(){
	diag_vote.close();
    onSearch();
}
function setQueryCondition(id) {
	document.frmmain.action="/formmode/search/CustomSearchByAdvancedSave.jsp";
	document.frmmain.templateid.value = id;
	document.frmmain.submit();
}
function setDisplayColumn(id) {
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	//模板管理
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(84342  ,user.getLanguage()) %>";//查询条件字段定义
	diag_vote.maxiumnable = true;
	diag_vote.URL = "/formmode/template/SetTemplateColumn.jsp?isdialog=1&customid=<%=customid%>&templateid="+id+"&sourcetype=<%=sourcetype%>";
	diag_vote.show();
}
function preview(id) {
	document.frmmain.action="/formmode/search/CustomSearchByAdvancedIframe.jsp";
	document.frmmain.templateid.value=id;
	document.frmmain.submit();
}
function onEdit(id) {
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 360;
	diag_vote.Height = 150;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(16449  ,user.getLanguage()) %>";//编辑模板
	diag_vote.maxiumnable = true;
	diag_vote.URL = "/formmode/template/UpdateTemplate.jsp?isdialog=1&customid=<%=customid%>&templateid="+id;
	diag_vote.show();
}
function setDefault(id) {
	document.frmmain.method.value="setDefault";
	document.frmmain.templateid.value = id;
	document.frmmain.submit();
}
function onDelete(id) {
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){  //确定要删除选中的记录吗？
		document.frmmain.method.value="ondelete";
		document.frmmain.templateid.value = id;
		document.frmmain.submit();
	});
}
function onSearch() {
	document.frmmain.action="/formmode/template/TemplateManageIframe.jsp";
	document.frmmain.submit();
}
function onClear() {
	document.frmmain.templatename.value="";
	document.frmmain.templatetype.value="";
}
function onBtnSearchClick(){
	
}
</script>
