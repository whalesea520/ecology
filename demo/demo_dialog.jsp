<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>

<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<!-- 引入相关JS -->
</HEAD>
<body scroll="no">
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(82487,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{导出当前页,javascript:_xtable_getExcel()(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{导出所有,javascript:_xtable_getAllExcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%

    //获取也没请求参数，凭借查询的sql条件
    String name = Util.null2String(request.getParameter("name"));
    String userid = Util.null2String(request.getParameter("userid"));
    String sqlwhere = "";
    if(!name.equals("")){
        sqlwhere += " and name like '%"+name+"%'";
    }

    if(!userid.equals("")){
        sqlwhere += " and userid  in ("+userid+")";
    }
%>
<form action="demo_listall.jsp" method="post" id="weaver" name="weaver">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top" onclick="newDialog()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="DeleteData()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=name %>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv">
<wea:layout type="fourCol">
    <wea:group context="查询条件">
        <wea:item>数据名称</wea:item>
        <wea:item>
            <input type="text" name='name' id='name' />
        </wea:item>
        <wea:item>用户</wea:item>
        <wea:item>
            <brow:browser name="userid" viewType="0" hasBrowser="true" hasAdd="false"
                          browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp'
                          isMustInput="1"
                          isSingle="false"
                          hasInput="true"
                          completeUrl="/data.jsp?type=1"  width="300px"
                          browserValue=''
                          browserSpanValue=''
                          />
      </wea:item>
    </wea:group>
    <wea:group context="">
        	<wea:item type="toolbar"><!-- 提交、重置、取消相关的操作按钮 -->
        		<input class="e8_btn_submit" type="submit" name="submit" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
        		<input class="e8_btn_cancel" type="button" name="reset" onclick="onReset()" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
        		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
        	</wea:item>
    </wea:group>
</wea:layout>
</div>
</form>
<input type="hidden" name="pageId" id="pageId" value="demolist_all"/>
<wea:layout type="fourCol">
     <wea:group context="数据列表">
     		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
                <%
                    String orderby =" name "; //排序字段
                    String tableString = "";  //定义表格xml数据
                    String backfields = " * "; //查询的字段
                    String fromSql  = " demotable ";//查询的表名或者视图名
                    String sqlWhere = " 1=1 "+sqlwhere ; //查询条件
                    tableString =   " <table instanceid=\"db_list3\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_CUSTOMQUERYTYPETAB,user.getUID())+"\" >"+ //指定分页条数和初始化id以及是否有复选框
                    				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.oatest.DemoUtil.getCanCheck\" />"+//用于控制checkbox 框是否可用
                                    "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
                                     " sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"false\" />"+
                                    "       <head>"+
                                    "           <col width=\"10%\"  text=\"数据ID\" column=\"id\" orderkey=\"id\" />"+
                                    "           <col width=\"20%\"  text=\"数据名称\" column=\"name\" />"+
                                    "           <col width=\"20%\"  text=\"用户名称\" column=\"userid\" orderkey=\"userid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\" />"+
                                    "           <col width=\"20%\"  text=\"数量\" column=\"scount\"  orderkey=\"scount\" />"+
                                    "           <col width=\"10%\"  text=\"单价\" column=\"sprice\" orderkey=\"sprice\" />"+
                                    "       </head>"+
                                    "		<operates>"+//相关操作
                                    "		<popedom column=\"id\" otherpara=\"column:userid\" transmethod=\"weaver.oatest.DemoUtil.getCanOperation\"></popedom> "+//用于控制操作菜单是否可用
                    				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" otherpara=\"column:userid\" target=\"_self\" index=\"0\"/>"+
                    				"		<operate href=\"javascript:onshowlog();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" otherpara=\"column:userid\" target=\"_self\" index=\"1\"/>"+
                    				"		</operates>"+
                                    " </table>";

                %>
                 <wea:SplitPageTag  tableString='<%=tableString%>' mode="run" />
                 <!-- 显示分页数据 -->
            </wea:item>
     </wea:group>
</wea:layout>
<script type="text/javascript">
jQuery(document).ready(function () {//初始化表单查询按钮
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});

function onBtnSearchClick(){
    enableAllmenu();
	var name=$("input[name='flowTitle']",parent.document).val();
	jQuery("input[name='name']").val(name);
    location.href="/demo/demo_listall.jsp?temp="+Math.random()+"&name="+name;
}

function onReset() {
	jQuery('input[name="flowTitle"]', parent.document).val('');
	jQuery('input[name="name"]').val('');
}

function dosubmit(){
    document.weaver.submit();
}

function newDialog(){
    openDialog("新建数据","/demo/demo_dialog1.jsp");
}

function DeleteData(){
    alert("删除数据");
}

function openDialog(title, url) {　
	var dlg = new window.top.Dialog(); //定义Dialog对象
	dlg.currentWindow = window;
	dlg.Model = false;　　　
	dlg.Width = 1060; //定义长度
	dlg.Height = 500;　　　
	dlg.URL = url;　　　
	dlg.Title = title ;
	dlg.maxiumnable = true;　　　
	dlg.show();
	window.dialog = dlg;
}

</script>
 </body>
</html>
