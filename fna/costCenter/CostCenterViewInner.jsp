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
if(!HrmUserVarify.checkUserRight("BudgetCostCenter:maintenance", user)){
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

int fccId = Util.getIntValue(request.getParameter("fccId"),0);

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
String advQryArchive = Util.null2String(request.getParameter("advQryArchive")).trim();

int type = 0;
String sql = "select a.type from FnaCostCenter a where a.id = "+fccId;
rs.executeSql(sql);
if(rs.next()){
	type = Util.getIntValue(rs.getString("type"), 0);
}

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
if(type==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,178",user.getLanguage())+",javascript:addLb("+fccId+"),_TOP} ";//新建类别
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,515",user.getLanguage())+",javascript:addSub("+fccId+"),_TOP} ";//新建成本中心
	RCMenuHeight += RCMenuHeightStep ;
}
// RCMenu += "{"+SystemEnv.getHtmlLabelName(127095,user.getLanguage())+",javascript:exportSelect(),_TOP} ";//导出所选记录
// RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(125595,user.getLanguage())+",javascript:exportAll(),_TOP} ";//全部导出
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_TOP} ";//批量删除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(26601,user.getLanguage())+",javascript:batchImp(),_TOP} ";//批量导入
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form2" method="post"  action="/fna/costCenter/CostCenterViewInner.jsp">
<input type="hidden" id="fccId" name="fccId" value="<%=fccId %>" />
<input type="hidden" id="type" name="type" value="<%=type %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82,178",user.getLanguage()) %>" class="e8_btn_top" onclick="addLb(<%=fccId %>);"/><!-- 新建类别 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82,515",user.getLanguage()) %>" class="e8_btn_top" onclick="addSub(<%=fccId %>);"/><!-- 新建成本中心 -->
<%--        <input type="button" value="<%=SystemEnv.getHtmlLabelName(127095,user.getLanguage()) %>" class="e8_btn_top" onclick="exportSelect()"/><!-- 导出所选记录 --> --%>
            <input type="button" value="<%=SystemEnv.getHtmlLabelName(125595,user.getLanguage()) %>" class="e8_btn_top" onclick="exportAll()"/><!-- 全部导出 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
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
	    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item><!-- 名称 -->
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
	int perpage = UserDefaultManager.getNumperpage();
	if(perpage <2) perpage=15;
	
	//设置好搜索条件
	String backFields =" a.* ";
	String fromSql = " from FnaCostCenter a ";
	String sqlWhere = " where 1=1 ";
	if(fccId >= 0){
		sqlWhere += " and a.supFccId = "+fccId+" ";
	}
	if(!"".equals(nameQuery)){
		sqlWhere += " and a.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' ";
	}
	if(!"".equals(advQryArchive)){
		if("0".equals(advQryArchive)){//未封存
			sqlWhere += " and (a.archive = 0 or a.archive is null) ";
		}else if("1".equals(advQryArchive)){//已封存
			sqlWhere += " and a.archive = 1 ";
		}else{
			sqlWhere += " and a.archive = "+Util.getIntValue(advQryArchive)+" ";
		}
	}

	String orderBy=" a.type,a.code,a.name ";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_COST_CENTER_VIEW_INNER_LIST\" pageId=\""+PageIdConst.FNA_COST_CENTER_VIEW_INNER_LIST+"\" "+
      		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_COST_CENTER_VIEW_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
	   "<checkboxpopedom showmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getCostCenterViewInner_checkboxpopedom\" popedompara=\"column:id\"/>"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\"id\" sqlsortway=\"Asc\" />"+
       "<head>"+
             "<col width=\"21%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" "+
     				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"doEdit_grid+column:id\"/>"+
			 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1321,user.getLanguage())+"\" column=\"code\" orderkey=\"code\" "+
					 " transmethod=\"weaver.fna.general.FnaCommon.escapeHtml\" />"+
             "<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" otherpara=\"column:id+"+user.getLanguage()+"\" "+
			 		" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFccTypeName\" />"+
             "<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"archive\" orderkey=\"archive\" otherpara=\""+user.getLanguage()+"\" "+
			 		" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFccStatus\" />"+
             "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(24664,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\""+user.getLanguage()+"\" "+
 			 		" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFccDtl\" />"+
       "</head>"+
		"		<operates>"+
		"			<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getCostCenterViewInner_popedom\" otherpara=\"column:archive\" ></popedom> "+
		"			<operate href=\"javascript:doEdit_grid();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+
		"			<operate href=\"javascript:doLifted_grid();\" text=\""+SystemEnv.getHtmlLabelName(22152, user.getLanguage())+"\" index=\"1\"/>"+
		"			<operate href=\"javascript:doArchive_grid();\" text=\""+SystemEnv.getHtmlLabelName(22151, user.getLanguage())+"\" index=\"2\"/>"+
		"			<operate href=\"javascript:doDel_grid();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"3\"/>"+
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="4col">
		<wea:group context="" attributes="{\"groupDisplay\":\"none\"}" ><!-- 科目 -->
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_COST_CENTER_VIEW_INNER_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//批量导入
function batchImp(){
	var _w = 580;
	var _h = 420;
	_fnaOpenDialog("/fna/batch/CostCenterBatch.jsp", 
			"<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage()) %>", 
			_w, _h);
}

//编辑
function doEdit_grid(id){
	var type = null2String(jQuery("#tript_"+id+"_type").val());
	var _h = 340;
	if(type==1){
		_h = 600;
	}
	var _titleName = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(515,user.getLanguage()) %>";
	if(type==0){
		_titleName = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(178,user.getLanguage()) %>";
	}
	_fnaOpenDialog("/fna/costCenter/CostCenterEdit.jsp?id="+id, 
			_titleName, 
			550, _h);
}

//新建
function doAdd(supFccId,type,_h){
	var _titleName = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(515,user.getLanguage()) %>";
	if(type==0){
		_titleName = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(178,user.getLanguage()) %>";
	}
	_fnaOpenDialog("/fna/costCenter/CostCenterAdd.jsp?supFccId="+supFccId+"&type="+type, 
			_titleName, 
			550, _h);
}

//新建成本中心
function addSub(supFccId){
	doAdd(supFccId,1,600);
}

//新建成本中心类别
function addLb(supFccId){
	doAdd(supFccId,0,340);
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
	var id = null2String(jQuery("#fccId").val());
	var type = null2String(jQuery("#type").val());
	if(id==""){
		id="0";
	}
	if(type==""){
		type="0";
	}
	var _data = "operation=delete&id="+_id;

	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/costCenter/CostCenterOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							parent.parent.leftframe.do_reAsyncChildNodes(type+"_"+id, type+"_"+id);
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
	var id = null2String(jQuery("#fccId").val());
	var type = null2String(jQuery("#type").val());
	if(id==""){
		id="0";
	}
	if(type==""){
		type="0";
	}
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(515,user.getLanguage()) %>");
		return;
	}
	var _data = "operation=batchDel&batchDelIds="+ids;
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/costCenter/CostCenterOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							parent.parent.leftframe.do_reAsyncChildNodes(type+"_"+id, type+"_"+id);
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
	var id = null2String(jQuery("#fccId").val());
	var type = null2String(jQuery("#type").val());
	if(id==""){
		id="0";
	}
	if(type==""){
		type="0";
	}
	_id += ",";
	var _data = "operation=lifted&checkid="+_id;
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/costCenter/CostCenterOperation.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					parent.parent.leftframe.do_reAsyncChildNodes(type+"_"+id, type+"_"+id);
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
	var id = null2String(jQuery("#fccId").val());
	var type = null2String(jQuery("#type").val());
	if(id==""){
		id="0";
	}
	if(type==""){
		type="0";
	}
	var _data = "operation=archive&checkid="+_id;
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/costCenter/CostCenterOperation.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					parent.parent.leftframe.do_reAsyncChildNodes(type+"_"+id, type+"_"+id);
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
			url : "/fna/costCenter/CostCenterViewAjax.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(_html){
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
		    	_html = jQuery.trim(_html);
				if(_html=="1"){
					top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126350,user.getLanguage())%>",
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
        var url = "/fna/costCenter/CostCenViewInnerDownload.jsp";
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
</script>

</body>
</html>
