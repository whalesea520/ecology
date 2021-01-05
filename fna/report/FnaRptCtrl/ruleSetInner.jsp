<%@page import="org.apache.commons.lang.StringEscapeUtils"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<%
String userid=""+user.getUID();

if(!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit",user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(128636,user.getLanguage());//财务报表权限设置
String needfav ="1";
String needhelp ="";

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(82, user.getLanguage())+",javascript:addRecord(),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{" + SystemEnv.getHtmlLabelName(32136, user.getLanguage())+",javascript:batchDel(),_self} ";
RCMenuHeight += RCMenuHeightStep;

//日志
if(HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit",user) ){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<div class="zDialog_div_content">
<form id=form2 name=form2 method=post action="/fna/report/FnaRptCtrl/ruleSetInner.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" 
				class="e8_btn_top" onclick="addRecord();"/><!-- 新建 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=nameQuery %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" style="display: none;"></span><!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<%
String tableString = "";
      
String backfields = " a.id, a.name, a.roleid, b.rolesmark ";
String fromSql = " from fnaRptRuleSet a \n" +
		   		" join HrmRoles b on a.roleid = b.id ";
String sqlWhere = " where 1=1 ";
if(!"".equals(nameQuery)){
	sqlWhere += " and (a.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' or b.rolesmark like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') ";
}
String orderby = " b.rolesmark, a.id ";

String sqlprimarykey = "a.id";

//out.println("select "+backfields+fromSql+sqlWhere);
tableString =" <table instanceid=\"FNA_RULE_SET_INNER_LIST\" pageId=\""+PageIdConst.FNA_RULE_SET_INNER_LIST+"\" "+
			" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_RULE_SET_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\" >"+
"	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" "+
			" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\" "+
			" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />"+
"			<head>";
tableString+="				<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(122,user.getLanguage())+"\" column=\"rolesmark\" orderkey=\"rolesmark\" "+//角色
								" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"doOpen+column:id\"/>";
tableString+="				<col width=\"70%\"  text=\""+SystemEnv.getHtmlLabelName(128645,user.getLanguage())+"\" column=\"id\" "+
								" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaRptNameRuleSetInner\" otherpara=\""+user.getLanguage()+"\" />";//可查询机构范围
tableString+="			</head>";
tableString+="		<operates>";
tableString+="			<operate href=\"javascript:doOpen();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>";//编辑
tableString+="			<operate href=\"javascript:gridDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"1\"/>";//删除
tableString+="		</operates>";   
tableString+="</table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_RULE_SET_INNER_LIST %>" />
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
</form>

<!--   added by xwj for td2023 on 2005-05-20  end  -->
     
<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  
	  </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//页面初始化事件
jQuery(document).ready(function(){
	resizeDialog(document);
});

//关闭
function doClose(){
	parent.btnClose_onclick();
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	form2.submit();
}

//删除
function gridDel(ids){
	//确定要删除吗?
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			gridDel2(ids);
		}, function(){}
	);
}
function gridDel2(ids){
	var _data = "op=del&id="+ids;
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/report/FnaRptCtrl/ruleSetOp.jsp",
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
}
//批量删除
function batchDel(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage()) %>");
		return;
	}
	//确定要删除吗?
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			batchDel2(ids);
		}, function(){}
	);
}
function batchDel2(ids){
	var _data = "op=batchDel&batchDelIds="+ids;
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/report/FnaRptCtrl/ruleSetOp.jsp",
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
}
//新建
function addRecord(_id){
	_fnaOpenDialog("/fna/report/FnaRptCtrl/ruleSetAdd.jsp?id="+_id,  
			"<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(128646,user.getLanguage()) %>", 
			660, 430);
}

//编辑
function doOpen(_id){
	_fnaOpenDialog("/fna/report/FnaRptCtrl/ruleSetAdd.jsp?id="+_id,  
			"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(128646,user.getLanguage()) %>", 
			660, 430);
}


function onLog(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/SysMaintenanceLog.jsp?operateitem=61410001";//61410001表示类型是 财务报表权限设置
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}


</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
