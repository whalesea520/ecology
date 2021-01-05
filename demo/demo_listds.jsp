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
<form action="demo_edittableoperation.jsp" method="post" id="weaver" name="weaver">
<wea:layout type="fourCol">
     <wea:group context="数据列表">
     		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
                <%
                    String tableString = "";  //定义表格xml数据
                    //指定分页条数和初始化id以及是否有复选框 以及数据来源  datasource表示数据来源 sourceparams表示传入参数参数格式为"name:value+name1:value1"多个参数用加号连接
                    tableString =   " <table instanceid=\"ds_list\" tabletype=\"checkbox\" datasource=\"weaver.oatest.DemoUtil.getDemoData\" sourceparams=\"userid:"+user.getUID()+"+departmentid:"+user.getUserDepartment()+"\" pagesize=\"5\" >"+
                    				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.oatest.DemoUtil.getCanCheck\" />"+//用于控制checkbox 框是否可用
                                    "       <sql backfields=\"*\" sqlform=\"tmptable\" sqlwhere=\"\"  sqlorderby=\"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"false\" />"+
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
                 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
                 <!-- 显示分页数据 -->
            </wea:item>
     </wea:group>
</wea:layout>
</form>
<script type="text/javascript">

</script>
 </body>
</html>
