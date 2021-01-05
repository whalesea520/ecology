<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<jsp:useBean id="rs_child" class="weaver.conn.RecordSet"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/js/ecology8/hrm/e8Common_wev8.js?r=1"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31978, user.getLanguage());
String needfav ="1";
String needhelp ="";

int mainId = Util.getIntValue(request.getParameter("id"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addNewRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doBatchDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="frmMain" name="frmMain" method="post" action="/system/sysdetach/AppDetachEditMembers.jsp">
<input id="id" name="id" value="<%=mainId %>" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top" onclick="addNewRow()"/><!-- 添加 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="doBatchDel()"/><!-- 批量删除 -->
			<!-- 
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			 --><!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(83721, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
String pageId = PageIdConst.Hrm_sysadminEditBatchTable;
int pagesize = Util.getIntValue(PageIdConst.getPageSize(pageId, user.getUID(), PageIdConst.HRM), 10);

String backfields = "a.*, "+
				" case when (type1=1) then '"+SystemEnv.getHtmlLabelNames("6087", user.getLanguage())+"' "+
				" when (type1=2) then '"+SystemEnv.getHtmlLabelNames("141", user.getLanguage())+"' "+
				" when (type1=3) then '"+SystemEnv.getHtmlLabelNames("124", user.getLanguage())+"' "+
				" when (type1=4) then '"+SystemEnv.getHtmlLabelNames("122", user.getLanguage())+"' "+
				" else '' end sourcetypeName";
String sqlform = " from SysDetachDetail a ";
String sqlwhere = " a.infoid = "+mainId+" and sourcetype = 2 ";
String sqlorderby = "a.id";
String sqlprimarykey = "a.id";

String tableString=""+
	"<table pageId=\""+pageId+"\" instanceid=\"sysadminEditBatchTable\" "+
		" pagesize=\""+pagesize+"\" tabletype=\"checkbox\">"+
		"<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" "+
			" sqlorderby=\""+Util.toHtmlForSplitPage(sqlorderby)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
		"<head>"+							 
			"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelNames("63", user.getLanguage())+"\"  column=\"sourcetypeName\" />"+//共享类型
			"<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelNames("139", user.getLanguage())+"\" column=\"operator\""+
				" otherpara=\""+user.getLanguage()+"+column:seclevel+column:seclevelto+column:type1+column:rolelevel\" "+
				" transmethod=\"weaver.splitepage.transform.SptmForHR.getSeclevel\"/>"+//级别
			"<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelNames("106", user.getLanguage())+"\" column=\"content\""+
				" otherpara=\"column:type1\" "+
				" transmethod=\"weaver.splitepage.transform.SptmForHR.getContent\"/>"+//范围
			//"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelNames("128725", user.getLanguage())+"\"  column=\"iscontains\""+
				//" otherpara=\""+user.getLanguage()+"\" "+
			  //" transmethod=\"weaver.splitepage.transform.SptmForHR.getIscontains\"/>"+//包含下级
		"</head>"+
		"<operates>"+
		"	<operate href=\"javascript:doEdit_grid();\" text=\""+SystemEnv.getHtmlLabelNames("93", user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
		"	<operate href=\"javascript:doDel_grid();\" text=\""+SystemEnv.getHtmlLabelNames("91", user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
		"</operates>"+  
	"</table>";
%>
<div class="zDialog_div_content">
	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
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
</form>

<script language=javascript>

function onBtnSearchClick(){
	document.frmMain.submit();
}

function onCancel(){
	var dialog = parent.parent.getDialog(parent.window);	
	dialog.closeByHand();
}

function afterDoWhenLoaded(){
}

function lazyLoadBrowser(){
	setFmHeight();
}

function setFmHeight(){
	var $fm = $('#frmMain') ;
	$fm.height($fm.height()+35);
}



//批量删除
function doBatchDel(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==null||ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage()) %>");//请先选择需要删除的数据
		return;
	}
	var _data = "operation=membersBatchDel&mainId=<%=mainId %>&ids="+ids;
	
	//确认要删除吗
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage()) %>",
		function(){
			jQuery.ajax({
				url : "/system/sysdetach/AppDetachOperation.jsp",
				type : "post",
				async : true,
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
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
	var _data = "operation=membersDel&mainId=<%=mainId %>&id="+id;

	//确认要删除吗
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage()) %>",
		function(){
			jQuery.ajax({
				url : "/system/sysdetach/AppDetachOperation.jsp",
				type : "post",
				async : true,
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
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
	var _w = 500;
	var _h = 280;
	if(parentWin!=null){
		doClose1();
		onBtnSearchClick();
	}
	openDialog("/system/sysdetach/AppDetachEditMembersEdit.jsp?mainId=<%=mainId %>&id="+id, 
			"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelNames("106,68",user.getLanguage()) %>", 
			_w, _h);
}

//新建
function addNewRow(){
	var _w = 500;
	var _h = 280;
	openDialog("/system/sysdetach/AppDetachEditMembersEdit.jsp?mainId=<%=mainId %>", 
			"<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelNames("106,68",user.getLanguage()) %>", 
			_w, _h);
}

</script>
</BODY>
</HTML>
