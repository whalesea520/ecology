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

BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(332,user.getLanguage());//全部
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

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
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_TOP} ";//新建
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_TOP} ";//批量删除
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form2" method="post"  action="/fna/fnaVoucher/dataSetListInner.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top" onclick="doAdd();"/><!-- 新建 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=nameQuery %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<%
	//设置好搜索条件
	String backFields =" a.* ";
	String fromSql = " from fnaDataSet a ";
	String sqlWhere = " where fnaVoucherXmlId is null ";
	if(!"".equals(nameQuery)){
		sqlWhere += " and a.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' ";
	}

	String orderBy=" a.dSetName ";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_DATA_SET_LIST_INNER_LIST\" pageId=\""+PageIdConst.FNA_DATA_SET_LIST_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_DATA_SET_LIST_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" "+
      		" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\"id\" sqlsortway=\"Asc\" />"+
       "<head>"+
             "<col width=\"21%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"dSetName\" orderkey=\"dSetName\" "+
     				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"doEdit_grid+column:id\"/>"+
			 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"dsMemo\" "+
	     			" transmethod=\"weaver.general.Util.toScreenForWorkflow\" />"+
       "</head>"+
		"		<operates>"+
		"			<operate href=\"javascript:doEdit_grid();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+
		"			<operate href=\"javascript:doDel_grid();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"1\"/>"+
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="4col">
		<wea:group context="" attributes="{\"groupDisplay\":\"none\"}" ><!-- 科目 -->
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_DATA_SET_LIST_INNER_LIST %>" />
				<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//编辑
function doEdit_grid(id){
	_fnaOpenDialog("/fna/fnaVoucher/dataSetEdit.jsp?id="+id, 
			"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(84712,user.getLanguage()) %>", 
			660, 550);
}

//新建
function doAdd(){
	_fnaOpenDialog("/fna/fnaVoucher/dataSetEdit.jsp", 
			"<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(84712,user.getLanguage()) %>", 
			660, 550);
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
				url : "/fna/fnaVoucher/dataSetOperation.jsp",
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
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(84712,user.getLanguage()) %>");
		return;
	}
	var _data = "operation=batchDel&batchDelIds="+ids;
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/fnaVoucher/dataSetOperation.jsp",
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