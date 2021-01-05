
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />

<jsp:useBean id="func" class="com.weaver.upgrade.FunctionUpgrade" scope="page"/>
<%@ page language="java" import="weaver.file.Prop" %>


<%
    if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
<%
    String titlename = SystemEnv.getHtmlLabelName(23088,user.getLanguage());
    String templatetype = Util.null2String(request.getParameter("templatetype"));
    String templateName = Util.null2String(request.getParameter("templateName"));

    templatetype = "".equals(templatetype)?"0":templatetype;
    String tabType=templatetype;
    String sqlWhere="";
    String hostaddr="";
    try{
        //获取本机IP
        InetAddress ia = InetAddress.getLocalHost();
        //获取本机的ip地址
        hostaddr = ia.getHostAddress();
    }catch (UnknownHostException e){
        //如果获取不到本机IP则默认ip地址为127.0.0.1
        hostaddr="127.0.0.1";
    }
    //判断是否开启了IP集群化控制，1启用，0未启用
    if("1".equals(Prop.getPropValue("ClusterIpController", "flag"))){
        //    0:已启用页面 1：未启用页面
        if("1".equals(tabType)){
            sqlWhere = " where t2.status=0 and t3.serverIP='"+hostaddr+"' " ;
        }else{
            sqlWhere = " where t2.status=1 and t3.serverIP='"+hostaddr+"' " ;
        }
        if(!"".equals(templateName))sqlWhere += " and (t1.name like '%"+templateName+"%' or t1.num like '%"+templateName+"%')";
    }else{
//    0:已启用页面 1：未启用页面
    if("1".equals(tabType)){
        sqlWhere = " where status=0 " ;
    }else{
        sqlWhere = " where status=1 " ;
    }
    if(!"".equals(templateName))sqlWhere += " and (name like '%"+templateName+"%' or num like '%"+templateName+"%')";
    }
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<html>
<head>
    <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
    <style type="text/css">
        .zd_btn_cancle{
            display: none;
        }
        .e8_sep_line{
            display: none;
        }
    </style>
</head>
<body  id="myBody">
<form id="nonStandardSearchForm" name="nonStandardSearchForm" method="post" action="/upgrade/nonStandardFunctionList.jsp">
    <input type="hidden" id="operate" name="operate" value=""/>
    <input type="hidden" id="templatetype" name="templatetype" value="<%=templatetype%>"/>
    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td width="160px">
            </td>
            <td class="rightSearchSpan" style="text-align:right; width:500px!important">
                <%if("0".equals(tabType)){%>
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(26471,user.getLanguage())%>" class="e8_btn_top" onclick="onStop();" />
                <%}else {%>
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>" class="e8_btn_top" onclick="onStart();" />
                <%}%>
                <%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onImportLayout()">--%>
                <input type="text" value="<%=templateName%>" class="searchInput" name="templateName"/>
                &nbsp;&nbsp;&nbsp;
                <input type="hidden" value="<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>" class="advancedSearch" onclick="jQuery('#advancedSearchDiv').toggle('fast');return false;"/>
                <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
            </td>
        </tr>
    </table>
    <div class="advancedSearchDiv" id="advancedSearchDiv">
    </div>
</form>
<%
    String isShowCheckBox="";
    String tableString= "";

    //判断有没有启用IP集群控制
    if("1".equals(Prop.getPropValue("ClusterIpController", "flag"))){
        if("0".equals(tabType)){
            isShowCheckBox="<checkboxpopedom popedompara=\"column:num\" showmethod=\"com.weaver.upgrade.FunctionUpgrade.isShowCheckBox\"/>";
        }
            tableString=""+
            "<table pagesize=\"10\"  tabletype=\"checkbox\">"+
            isShowCheckBox +
            "<sql backfields=\"t1.id,t1.num,t1.name,t1.classpath,t2.status\" sqlform=\"  hp_nonstandard_function_info t1 LEFT JOIN hp_nonstandard_func_server t2 on t2.funcid=t1.id LEFT JOIN hp_server_info t3 on t3.id=t2.serverid \"  sqlorderby=\"t1.num\"  sqlprimarykey=\"t1.num\" sqlsortway=\"asc\" sqlwhere=\""+ Util.toHtmlForSplitPage(sqlWhere)+ "\" sqlisdistinct=\"true\" />"+
            "<head >"+
            "<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(131294,user.getLanguage())+"\"  orderkey=\"num\" column=\"num\"/>"+
            "<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(131295,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />"+
            "</head>"
            + "</table>";
    }else{
        if("0".equals(tabType)){
            isShowCheckBox="<checkboxpopedom popedompara=\"column:num\" showmethod=\"com.weaver.upgrade.FunctionUpgrade.isShowCheckBox\"/>";
        }
         tableString=""+
                "<table pagesize=\"10\"  tabletype=\"checkbox\">"+
                isShowCheckBox +
                "<sql backfields=\"id,num,name,classpath,status\" sqlform=\" from hp_nonstandard_function_info \"  sqlorderby=\"num\"  sqlprimarykey=\"num\" sqlsortway=\"asc\" sqlwhere=\""+ Util.toHtmlForSplitPage(sqlWhere)+ "\" sqlisdistinct=\"true\" />"+
                "<head >"+
                "<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(131294,user.getLanguage())+"\"  orderkey=\"num\" column=\"num\"/>"+
                "<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(131295,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />"+
                "</head>"
                + "</table>";
    }
%>
<TABLE width="100%">
    <TR>
        <TD valign="top">
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </TD>
    </TR>
</TABLE>
</body>
<!-- for zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript">
    $(document).ready(function(){
        jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
        jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
        jQuery("#tabDiv").remove();
    });
    function onStart(){
        var ids=_xtable_CheckedCheckboxId();
        if(ids==""){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131297,user.getLanguage())%>");
            return;
        }else{
            doStart(ids);
        }
    }

    function doStart(ids){
        top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(131305,user.getLanguage())%>",function(){
            jQuery.post("/upgrade/nonStandardFunctionHandle.jsp?method=start&ids="+ids,
                function(data){onStartDialog(data);});
        });
    }

    function onStartDialog(data) {
        var title = "<%=SystemEnv.getHtmlLabelName(131329,user.getLanguage())%>";
        //若返回的是空对象，说明FunctionUpgrade.class文件版本不对
        if($.isEmptyObject(data)){
            var diag = new Dialog();
            diag.Width = 568;
            diag.Height = 375;
            diag.Title = title;
            diag.InnerHtml='<div style="width:568px;height: 375px;overflow: auto;margin-left: 22px">'+
                '<div style="height: 17px;margin-top: 11px;line-height: 17px">'+
                '<div style="height: 100%;float: left"><img src="/images/ecology8/images/portal/fail_wev8.png"/></div>'+
                '<div style="height: 100%;float: left; text-align: center;margin-left: 16px;">非标文件版本不正确</div>'+
                '</div>'+
                '<div style="background-color: #FFEEE6;border: 1px solid #FFDDCC;border-radius:5px;padding-top:5px;padding-bottom:5px;margin-top: 12px;margin-left: 0px;margin-right: 20px;">'+
                '<div style="height: 30px;margin-top: 5px;margin-bottom:5px;line-height: 18px;">'+
                '<div style="float: left;width: 500px;height: 30px;margin-left: 30px;font-size: 12px;color: #F32000;"><span>文件版本落后！请联系泛微配置管理组人员，重新申请非标补丁包，更新ecology/classbean/com/weaver/upgrade/FunctionUpgrade.class的文件版本！</span></div>'+
                '</div>'+
                '</div>'+
                '</div>';
            diag.OKEvent = function(){diag.close();location.reload();};//点击确定后调用的方法
            diag.CancelEvent=function(){diag.close();location.reload();};
            diag.show();
        }else {
        var successHtml='';
        var successDiv='';
        var suggestInfo='';
        var successArray=data.successList;
        if(successArray.length>0){
            for(var i=0;i<successArray.length;i++){
                if(!(undefined==successArray[i].suggest||null==successArray[i].suggest)){
                    suggestInfo= '<div style="float: left;margin-left: 20px"><a href="#" style="float: left;font-size: 12px;color: #666666;" title="'+successArray[i].suggest+'">提示</a></div>';
                }
                successDiv=successDiv+'<div style="height: 17px;margin-top: 5px;margin-bottom:5px;line-height: 18px;">'+
                    '<div style="float: left;width: 19px;height: 17px;margin-left: 30px;font-size: 12px;color: #398817;"><span>'+successArray[i].id+'</span></div>'+
                    '<div title="'+successArray[i].name+'" style="float: left;margin-left: 26px;width: 200px;height: 100%;text-align:left;font-size: 12px;color: #398817;overflow: hidden;text-overflow: ellipsis;"><nobr>'+successArray[i].name+'</nobr></div>'+
                    suggestInfo+
                    '</div>';
            }
            successHtml='<div style="height: 17px;margin-top: 13px;line-height: 17px">'+
                '<div style="height: 100%;float: left">'+
                '<img src="/images/ecology8/images/portal/sucess_wev8.png"/>'+
                '</div>'+
                '<div style="height: 100%;float: left; text-align: center;margin-left: 16px;">'+
                '以下非标功能启用成功'+
                '</div>'+
                '</div>'+
                '<div style="background-color: #F3FAF0;border: 1px solid #E7F5E0;border-radius:5px;padding-top:5px;padding-bottom:5px;margin-top: 15px;margin-left: 0px;margin-right: 20px;">'+
                successDiv+

                '</div>';
        }
        var failHtml='';
        var failDiv='';
        var failArray=data.failList;
        if(failArray.length>0){
            for(var i=0;i<failArray.length;i++){
                failDiv=failDiv+  '<div style="height: 17px;margin-top: 5px;margin-bottom:5px;line-height: 18px;">'+
                    '<div style="float: left;width: 19px;height: 17px;margin-left: 30px;font-size: 12px;color: #F32000;"><span>'+failArray[i].id+'</span></div>'+
                    '<div title="'+failArray[i].name+'" style="float: left;margin-left: 26px;text-align:left;width: 200px;height:100%;font-size: 12px;color: #F32000;overflow: hidden;text-overflow: ellipsis"><nobr>'+failArray[i].name+'</nobr></div>'+
                    '<div style="float: left;margin-left: 20px"><a href="#" style="float: left;font-size: 12px;color: #666666;" title="'+failArray[i].msg+'">失败原因</a></div>'+
                    '</div>';
            }
            failHtml='<div style="height: 17px;margin-top: 11px;line-height: 17px">'+
                '<div style="height: 100%;float: left"><img src="/images/ecology8/images/portal/fail_wev8.png"/></div>'+
                '<div style="height: 100%;float: left; text-align: center;margin-left: 16px;">以下非标功能启用失败</div>'+
                '</div>'+
                '<div style="background-color: #FFEEE6;border: 1px solid #FFDDCC;border-radius:5px;padding-top:5px;padding-bottom:5px;margin-top: 12px;margin-left: 0px;margin-right: 20px;">'+
                failDiv+
                '</div>';
        }
        var diag = new Dialog();
        diag.Width = 568;
        diag.Height = 375;
        diag.Title = title;
        diag.InnerHtml='<div style="width:568px;height: 375px;overflow: auto;margin-left: 22px">'+
            successHtml+failHtml+
            '</div>';
        diag.OKEvent = function(){diag.close();location.reload();};//点击确定后调用的方法
        diag.CancelEvent=function(){diag.close();location.reload();};
        diag.show();
        }
    }

    function onStopDialog(data) {
        var title = "<%=SystemEnv.getHtmlLabelName(131329,user.getLanguage())%>";
        var successHtml='';
        var failHtml='';
        var successDiv='';
        var failDiv='';
        var successArray=data.successList;
        var failArray=data.failList;
        if(failArray.length>0){
            for(var i=0;i<failArray.length;i++){
                failDiv=failDiv+  '<div style="height: 17px;margin-top: 5px;margin-bottom:5px;line-height: 18px;">'+
                    '<div style="float: left;width: 19px;height: 17px;margin-left: 30px;font-size: 12px;color: #F32000;"><span>'+failArray[i].id+'</span></div>'+
                    '<div title="'+failArray[i].name+'" style="float: left;margin-left: 26px;text-align:left;width: 200px;height:100%;font-size: 12px;color: #F32000;overflow: hidden;text-overflow: ellipsis"><nobr>'+failArray[i].name+'</nobr></div>'+
                    '<div style="float: left;margin-left: 20px"><a href="#" style="float: left;font-size: 12px;color: #666666;" title="'+failArray[i].msg+'">失败原因</a></div>'+
                    '</div>';
            }
            failHtml='<div style="height: 17px;margin-top: 11px;line-height: 17px">'+
                '<div style="height: 100%;float: left"><img src="/images/ecology8/images/portal/fail_wev8.png"/></div>'+
                '<div style="height: 100%;float: left; text-align: center;margin-left: 16px;">以下非标功能停用失败</div>'+
                '</div>'+
                '<div style="background-color: #FFEEE6;border: 1px solid #FFDDCC;border-radius:5px;padding-top:5px;padding-bottom:5px;margin-top: 12px;margin-left: 0px;margin-right: 20px;">'+
                failDiv+
                '</div>';
        }

        if(successArray.length>0){
            for(var i=0;i<successArray.length;i++){
                successDiv=successDiv+'<div style="height: 17px;margin-top: 5px;margin-bottom:5px;line-height: 18px;">'+
                    '<div style="float: left;width: 19px;height: 17px;margin-left: 30px;font-size: 12px;color: #398817;"><span>'+successArray[i].id+'</span></div>'+
                    '<div title="'+successArray[i].name+'" style="float: left;margin-left: 26px;width: 200px;height: 100%;text-align:left;font-size: 12px;color: #398817;overflow: hidden;text-overflow: ellipsis;"><nobr>'+successArray[i].name+'</nobr></div>'+
                    '</div>';
            }
            successHtml='<div style="height: 17px;margin-top: 13px;line-height: 17px">'+
                '<div style="height: 100%;float: left">'+
                '<img src="/images/ecology8/images/portal/sucess_wev8.png"/>'+
                '</div>'+
                '<div style="height: 100%;float: left; text-align: center;margin-left: 16px;">'+
                '以下非标功能停用成功'+
                '</div>'+
                '</div>'+
                '<div style="background-color: #F3FAF0;border: 1px solid #E7F5E0;border-radius:5px;padding-top:5px;padding-bottom:5px;margin-top: 15px;margin-left: 0px;margin-right: 20px;">'+
                successDiv+

                '</div>';
        }
        var diag = new Dialog();
        diag.Width = 568;
        diag.Height = 375;
        diag.Title = title;
        diag.InnerHtml='<div style="width:568px;height: 375px;overflow: auto;margin-left: 22px">'+
            successHtml+failHtml+
            '</div>';
        diag.OKEvent = function(){diag.close();location.reload();};//点击确定后调用的方法
        diag.CancelEvent=function(){diag.close();location.reload();};
        diag.show();
    }

    function onStop(){
        var ids=_xtable_CheckedCheckboxId();
        if(ids==""){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131296,user.getLanguage())%>");
            return;
        }else{
            doStop(ids);
        }
    }
    function doStop(ids){
        top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(131304,user.getLanguage())%>",function(){
            jQuery.post("/upgrade/nonStandardFunctionHandle.jsp?method=stop&ids="+ids,
                function(data){ onStopDialog(data);});
        });
    }

    function onSearch(){
        nonStandardSearchForm.submit();
    }


    function showDialogshowDialog(title,url,width,height,showMax){
        var Show_dialog = new window.top.Dialog();
        Show_dialog.currentWindow = window;   //传入当前window
        Show_dialog.Width = width;
        Show_dialog.Height = height;
        Show_dialog.maxiumnable=showMax;
        Show_dialog.Modal = true;
        Show_dialog.Title = title;
        Show_dialog.URL = url;
        Show_dialog.show();
    }

</script>
</html>
