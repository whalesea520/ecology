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
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//全部
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

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
RCMenu += "{"+SystemEnv.getHtmlLabelNames("82",user.getLanguage())+",javascript:doAdd(),_TOP} ";//新建
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_TOP} ";//批量删除
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form2" method="post"  action="/fna/fnaVoucher/fnaVoucherViewInner.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage()) %>" class="e8_btn_top" onclick="doAdd();"/><!-- 新建-->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=nameQuery %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<%
	//设置好搜索条件
	String backFields =" a.*, "+
		" case when (b.version is null) then 1 else b.version end versionName  ";
	String fromSql = " from fnaVoucherXml a "+
		" join workflow_base b on a.workflowid = b.id ";
	String sqlWhere = " where 1=1 ";
	if(!"".equals(nameQuery)){
		sqlWhere += " and a.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' ";
	}

	String orderBy=" a.xmlName ";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_VOUCHER_XML_VIEW_INNER_LIST\" pageId=\""+PageIdConst.FNA_VOUCHER_XML_VIEW_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_VOUCHER_XML_VIEW_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" />"+
       "<head>"+
             "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"xmlName\" orderkey=\"xmlName\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"doEdit+column:id\"/>"+
			 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"\" column=\"versionName\" orderkey=\"versionName\" "+//版本
					" />"+
             "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"xmlMemo\" "+
 	     			" transmethod=\"weaver.general.Util.toScreenForWorkflow\" />"+
       "</head>"+
		"		<operates>"+
		"			<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+
		"			<operate href=\"javascript:doDel_grid();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"1\"/>"+
		"			<operate href=\"javascript:showLog_grid();\" text=\""+SystemEnv.getHtmlLabelName(83, user.getLanguage())+"\" index=\"2\"/>"+
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="4col">
		<wea:group context="" attributes="{\"groupDisplay\":\"none\"}" ><!-- 科目 -->
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_VOUCHER_XML_VIEW_INNER_LIST %>" />
				<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...


var dialog = null;
function closeDialog(){
	if(dialog){
		dialog.close();
	}
}
//日志
function showLog_grid(id){
	_fnaOpenDialog("/workflow/workflow/WFLog.jsp?wfid=2662", 
			"<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %>", 
			660, 550);
}
//编辑
function doEdit(id){
	//window.parent.location.href = "/fna/fnaVoucher/fnaVoucherXml.jsp?fnaVoucherXmlId="+id;

	dialog = new window.top.Dialog();
	dialog.currentWindow = window; 
	url = "/fna/fnaVoucher/fnaVoucherXml.jsp?fnaVoucherXmlId="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,84672",user.getLanguage())%>";
	dialog.Width = 800;
	dialog.Height = 650;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable = true;
	dialog.show();
}

//新建
function doAdd(supFccId,type,_h){
	//window.parent.location.href = "/fna/fnaVoucher/fnaVoucherXml.jsp";

	dialog = new window.top.Dialog();
	dialog.currentWindow = window; 
	url = "/fna/fnaVoucher/fnaVoucherXml.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,84672",user.getLanguage())%>";
	dialog.Width = 800;
	dialog.Height = 650;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable = true;
	dialog.show();
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
	var _data = "operation=delete_fnaVoucherXml&id="+_id;

	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/fnaVoucher/fnaVoucherOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
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
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(84672,user.getLanguage()) %>");
		return;
	}
	var _data = "operation=batchDel_fnaVoucherXml&batchDelIds="+ids;
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/fnaVoucher/fnaVoucherOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
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
</script>

</body>
</html>