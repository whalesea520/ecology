<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/ecology8/jquery_wev8.js"></script>
<!--checkbox组件-->
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<!-- 下拉框美化组件-->
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<!-- 泛微可编辑表格组件-->
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

</HEAD>
<body scroll="no">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{提交表单,javascript:dosubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
    String tiptitle = "这里我是个提示信息的描述" ;
%>

<wea:layout type="fourCol">
     <wea:group context="数据列表">
     		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
                <%
                    String orderby =" id "; //排序字段
                    String tableString = "";  //定义表格xml数据
                    String backfields = " * "; //查询的字段
                    String fromSql  = " formtable_main_197 ";//查询的表名或者视图名
                    String sqlWhere = " 1=1 "; //查询条件
                    tableString =   " <table instanceid=\"db_list\" tabletype=\"checkbox\" pagesize=\"10\" >"+ //指定分页条数和初始化id以及是否有复选框
                    				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.oatest.DemoUtil.getCanCheck\" />"+//用于控制checkbox 框是否可用
                                    "    <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
                                     " sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"false\" />"+
                                    "   <head>"+
                                    "    <col width=\"10%\"  text=\"ID\" column=\"id\" orderkey=\"id\" />"+
                                    "    <col width=\"20%\"  text=\"红纺款号\" column=\"hfkh\" />"+
                                    "    <col width=\"20%\"  text=\"权利金\" column=\"qlj\" />"+
                                    "    <col width=\"20%\"  text=\"数量\" column=\"sl\"   />"+
                                    "    <col width=\"10%\"  text=\"单价\" column=\"dj\"  />"+
                                    "   </head>"+
                                    " </table>";

                %>
                 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" showExpExcel="true" />
                 <!-- 显示分页数据 -->
            </wea:item>
     </wea:group>
</wea:layout>

<script type="text/javascript">

</script>
 </body>
</html>
