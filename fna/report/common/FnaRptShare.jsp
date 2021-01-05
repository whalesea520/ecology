<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
	</head>
<%
String rptTypeName = Util.null2String(request.getParameter("rptTypeName")).trim();
boolean canview = FnaReport.checkUserRight(rptTypeName, user) ;
if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

int fnaTmpTbLogId = Util.getIntValue(request.getParameter("id"));


HashMap<String, String> retHm = FnaReport.getFnaReportShareLevel(fnaTmpTbLogId, user.getUID());

boolean isEdit = "true".equals(retHm.get("isEdit"));//编辑
boolean isFull = "true".equals(retHm.get("isFull"));//完全控制
if(!isEdit && !isFull) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

String _guid1 = "";
String tbName = "";
String description = "";
String sql = "select tbName, guid1, id, description from fnaTmpTbLog where isTemp = 0 and id = "+fnaTmpTbLogId;
rs.executeSql(sql);
if(rs.next()){
	tbName = Util.null2String(rs.getString("tbName")).trim();
	_guid1 = Util.null2String(rs.getString("guid1")).trim();
	description = Util.null2String(rs.getString("description")).trim();
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(18645, user.getLanguage()) + ",javascript:onAdd(),_self} ";
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{" + SystemEnv.getHtmlLabelName(18646, user.getLanguage()) + ",javascript:batchDel(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value='<%=tbName+"-"+SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %>'/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18645, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onAdd();">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18646, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="batchDel();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%
//设置好搜索条件
String backFields =" a.groupGuid1, a.shareType, a.secLevel1, a.secLevel2, a.shareLevel ";
String fromSql = " from fnaTmpTbLogShare a \n";
String sqlWhere = " where a.fnaTmpTbLogId = "+fnaTmpTbLogId+" \n"+
	" group by a.groupGuid1, a.shareType, a.secLevel1, a.secLevel2, a.shareLevel \n";
String orderBy = "a.shareType,a.shareLevel";

String sqlprimarykey = "a.groupGuid1";

//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
String tableString=""+
   "<table instanceid=\"FNA_FNA_RPT_SHARE_LIST\" pageId=\""+PageIdConst.FNA_FNA_RPT_SHARE_LIST+"\" "+
  		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_FNA_RPT_SHARE_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
   "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
   " sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"desc\" sqlisdistinct=\"true\" "+
   " />"+
   "<head>"+
		"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"shareType\" orderkey=\"shareType\" "+//对象类型
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFanRptShareTypeName\" otherpara=\""+user.getLanguage()+"\" "+
				" />"+
		"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"groupGuid1\" "+//对象
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFanRptShareIdName\" "+
				" />"+
		"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"secLevel1\" orderkey=\"secLevel1\" "+//安全级别
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFanRptSecLevelName\" otherpara=\"column:secLevel2\" "+
				" />"+
		"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(26137,user.getLanguage())+"\" column=\"shareLevel\" orderkey=\"shareLevel\" "+//共享权限
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFanRptShareLevelName\" otherpara=\""+user.getLanguage()+"\" "+
				" />"+
   "</head>"+
	"		<operates>"+
	"			<operate href=\"javascript:doDelete();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"0\"/>"+//删除
	"			<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"1\"/>"+//编辑
	"		</operates>"+
   "</table>";
%>

<wea:layout type="1col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_FNA_RPT_SHARE_LIST %>" />
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();">
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
var _guid1 = "<%=_guid1 %>";

jQuery(document).ready(function(){
	resizeDialog(document);
});


function hiddenSaveBtn(){
	_table.reLoad();
}

//添加共享
function onAdd(){
	_fnaOpenDialog("/fna/report/common/FnaRptShareSave.jsp?rptTypeName=<%=rptTypeName %>&fnaTmpTbLogId=<%=fnaTmpTbLogId %>", 
			"<%=SystemEnv.getHtmlLabelNames("18645,19467",user.getLanguage()) %>", 
			600, 400);
}

//维护共享
function onEdit(groupGuid1){
	_fnaOpenDialog("/fna/report/common/FnaRptShareSave.jsp?rptTypeName=<%=rptTypeName %>&groupGuid1="+groupGuid1+"&fnaTmpTbLogId=<%=fnaTmpTbLogId %>", 
			"<%=SystemEnv.getHtmlLabelNames("18645,19467",user.getLanguage()) %>", 
			600, 400);
}


//批量删除
function batchDel(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage()) %>");
		return;
	}
	var rptTypeName = "<%=rptTypeName %>";
	var _data = "operation=batchDelFnaRptShare&rptTypeName="+encodeURI(rptTypeName)+"&batchDelIds="+ids;
	
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
function doDelete(groupGuid1){
	var rptTypeName = "<%=rptTypeName %>";
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage()) %>",
			function(){
			    try{
					var _data = "operation=delFnaRptShare&rptTypeName="+encodeURI(rptTypeName)+"&groupGuid1="+groupGuid1;

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

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

function onCancel2(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

//重定义分页控件显示行数选择后刷新页面函数
function reloadPage(){
	window.location.href = window.location.href;
}

</script>
</BODY>
</HTML>
