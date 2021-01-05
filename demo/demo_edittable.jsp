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
     <wea:group context="可编辑表格Demo">
            <wea:item type="groupHead">
     			<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction.addRow();"/>
     			<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction();"/>
     		</wea:item>
     		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
     			<div id="FieldList"></div>

     			<script type="text/javascript">
                    var groupAction = null;
                    jQuery(document).ready(function(){
                        var initjsondatas = [[{'name': 'id', 'value': '11','iseditable': 'true','type': 'checkbox'},
                                            {'name': 'fieldid', 'value': '3', 'label': '韦利东', 'iseditable': true,'type': 'browser'},
                                           {'name': 'wb','value': '韦利东','iseditable': false, 'type': 'input' },
                                           {'name': 'xlk','value': '1', 'iseditable': true, 'type': 'select'},
                                           {'name': 'orderid','value': '1', 'iseditable': true, 'type': 'input'}
                                           ], [{'name': 'id', 'value': '12','iseditable': 'true','type': 'checkbox'},
                                           {'name': 'fieldid', 'value': '14', 'label': '隋清', 'iseditable': true, 'type': 'browser'},
                                           {'name': 'wb','value': '隋清','iseditable': true,'type': 'input'},
                                           {'name': 'xlk','value': '2','iseditable': true, 'type': 'select'},
                                           {'name': 'orderid','value': '2', 'iseditable': 'true', 'type': 'input'}
											]]

                        var item_browser  = "<span class='browser' viewType='0' _callback='UserCallBack' _callbackParams='_#rowIndex#' hasInput='true' name='fieldid' getBrowserUrlFn='getBrowserUrlFn' isMustInput='1' isSingle='false' completeUrl='/data.jsp' ></span>" ;
                        var items=[
                            {width:"10%",colname:"浏览按钮<SPAN class=\".e8tips\" style=\"CURSOR: hand\" id=remind_m title=\"<%=tiptitle %>\"><IMG id=ext-gen124 align=absMiddle src=\"/images/remind_wev8.png\"></SPAN>",itemhtml:item_browser},
                            {width:"20%",colname:"文本框",itemhtml:"<input name='wb' id='wb' type='text' value='默认值' />"},
                            {width:"20%",colname:"下拉框",itemhtml:"<select name='xlk' id='xlk' ><option value=''>全部</option><option value='1'>AA</option><option value='2'>BB</option></select>"},
                            {width:"20%",display:'none',colname:"排序",itemhtml:"<input name='orderid' id='orderid' type='text' />"}
                            ];
                        var option = {
                            basictitle:"可编辑表格标题。。。",
                            optionHeadDisplay:"none",
                            colItems:items,
                            container:"#FieldList", //显示容器的id
                            configCheckBox:true,
                            usesimpledata:true, //true|fase 当值为true时,则该可编辑表格默认以初始化数据初始化，初始化的具体数据配置详见initdatas
                            initdatas:initjsondatas,
                            canDrag:true,
                            orderField:'orderid',
                            //addrowCallBack:marcallback,//添加行时，回调的方法
                            checkBoxItem:{"itemhtml":'<input name="id" class="groupselectbox" type="checkbox" value="-1">',width:"5%"}
                        };
                        groupAction=new WeaverEditTable(option);
                        jQuery("#FieldList").append(groupAction.getContainer());
                    });
                    function deleteAction(){
                        //top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("15097",user.getLanguage())%>",function(){
                            groupAction.deleteRows();
                        //});
                    }
                </script>
            </wea:item>
     </wea:group>
</wea:layout>
</form>
<script type="text/javascript">

jQuery(function(){
	jQuery("span[id^=remind]").wTooltip({html:true});// 加载调用wTooltip方法，才能美化提示信息
});

function getBrowserUrlFn(params){
	var urls = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
	return urls;
}

function UserCallBack(event,datas,name,_callbackParams){
    jQuery("#wb"+_callbackParams).val(datas.name);
}

function dosubmit(){
    document.weaver.submit();
}
</script>
 </body>
</html>
