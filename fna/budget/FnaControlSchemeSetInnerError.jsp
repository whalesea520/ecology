<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.file.ExcelRow"%>
<%@page import="weaver.file.ExcelStyle"%>
<%@page import="weaver.file.ExcelSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ page import="weaver.file.AESCoder"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="BudgetApproveWFHandler" class="weaver.fna.budget.BudgetApproveWFHandler" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
    //new LabelComInfo().removeLabelCache();
    boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
    if(!canEdit){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }

    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
    String needfav = "1";
    String needhelp = "";

%>
<HTML><HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>

    <script language="javascript" src="/js/weaver_wev8.js"></script>
    <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
    <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
    <script language="javascript" src="/fna/js/e8Common_wev8.js?r=7"></script>
    <script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>

<BODY>
<style>
    .bb_table {
        border-collapse: collapse;/* 边框合并属性  */
        width: 98%;
    }
    .bb_table tr th {
        border: 1px solid #666666;
        height:30px;
        background-color: #999999;
    }
    .bb_table tr td {
        border: 1px solid #666666;
        height:30px;
    }
</style>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//     RCMenu += "{"+SystemEnv.getHtmlLabelName(25649,user.getLanguage())+",javascript:doImp(),_TOP} ";//开始导入
//     RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
    <jsp:include page="/systeminfo/commonTabHead.jsp">
        <jsp:param name="mouldID" value="fna"/>
		<jsp:param name="navName" value=""/>
    </jsp:include>

    <iframe name="ajaxUpload" style="display:none"></iframe>
    <form id=weaver name=frmmain method=post action="" enctype="multipart/form-data" target="ajaxUpload">
        <input type="hidden" name="operation" value="import">
        <input id="_guid1" name="_guid1" value="" type="hidden" />

        <table id="topTitle" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                </td>
<!--                 <td class="rightSearchSpan" style="text-align:right; width:500px!important"> -->
<!--                     <input class="e8_btn_top" type="button" id="btnSave" onclick="doImp();" -->
<%--                            value="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>"/><!-- 开始导入 --> --%>
<%--                     <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 --> --%>
<!--                 </td> -->
            </tr>
        </table>
        <table class="bb_table" cellpadding="0" cellspacing="0">
            <tr>
                <th>错误信息</th>
            </tr>
            <%
                List<String> errors = (List<String>)request.getSession().getAttribute("FNA_IMPORT_ERROR");
            	if(errors!=null){
	                for(String s :errors) {
	                    out.write("<tr><td>"+StringEscapeUtils.escapeHtml(s)+"</td></tr>");
	                }
            	}
            %>
        </table>

        <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
        <wea:group context="">
            <wea:item type="toolbar">
                <input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();"
                       value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 关闭 -->
            </wea:item>
        </wea:group>
    </wea:layout>
</div>
</form>

<script language=javascript>
    var _parent = null;
    var _guid1 = $System.Math.IntUtil.genGUIDV4();
    jQuery(document).ready(function(){
        jQuery("#_guid1").val(_guid1);
        _parent = parent.getParentWindow(window).parent.parent;
    });

    var _getErrorInfoAjax = false;
    function getErrorInfoAjax(_guid1){
        _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
        if(_getErrorInfoAjax){
            _getErrorInfoAjax = false;
            jQuery.ajax({
                url : "/fna/GetErrorInfoAjax.jsp",
                type : "post",
                cache : false,
                processData : false,
                data : "_guid1="+_guid1,
                dataType : "html",
                success: function do4Success(_html){
                    document.getElementById("weaver").action="";
                    if(_html!=""){
                        alert(_html);
                    }else{
                        alert("<%=SystemEnv.getHtmlLabelName(25750,user.getLanguage())%>");
                        try{
                            _parent.leftframe.do_reAsyncChildNodes("0_0","0_0");
                            _parent.document.getElementById("optFrame").src = "/fna/costCenter/CostCenterViewInner.jsp";
                        }catch(ex1){}
                    }
                }
            });
        }
    }

    //读取数据更新进度标志符
    var _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
    //读取数据更新进度函数
    function loadFnaBudgetEditSaveFnaLoadingAjax(_guid1){
        jQuery.ajax({
            url : "/fna/batch/CostCenterBatchAjax.jsp",
            type : "post",
            cache : false,
            processData : false,
            data : "_guid1="+_guid1,
            dataType : "html",
            success: function do4Success(_html){
                try{
                    if(top!=null&&top.document!=null&&top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv")!=null){
                        top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv").innerHTML=_html;
                        if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
                            setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
                        }
                    }else{
                        if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
                            setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
                        }
                    }
                    if(_html=="isDone"){
                        _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
                        try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
                        getErrorInfoAjax(_guid1);
                    }
                }catch(e1){
                    _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
                }
            }
        });
    }

    function doImp(){
        var _filename = jQuery("#filename").val();
        if(_filename==""){
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30213,user.getLanguage())%>");
            return;
        }

        top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>?",
                function(){
                    _guid1 = $System.Math.IntUtil.genGUIDV4();
                    jQuery("#_guid1").val(_guid1);
                    openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
                    document.getElementById("weaver").action="/fna/budget/FnaControlSchemeSetInnerImportOp.jsp?r="+GetRandomNum(8,100000000);
                    document.getElementById("weaver").submit();
                },function(data){
                    alert(data);

                }
        );
    }

    function callbackBB(data) {
        try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
        if(data && data.code == '200') {
            var dialog = parent.getDialog(window);
            dialog.currentWindow._table.reLoad();
            top.Dialog.alert(data.msg);

            doClose();
        }else if(data && data.code == '400') {
            ///top.Dialog.alert(data.msg);
            _fnaOpenDialog("/fna/budget/FnaControlSchemeSetInnerError.jsp?msg="+data.msg,
                    "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33071,user.getLanguage()) %>",
                    500, 600);
        }
    }

    //关闭
    function doClose(){
        var parentWin = parent.getParentWindow(window);
        parentWin.closeDialog();
    }

    function onBtnSearchClick(){}

</script>

</BODY>
</HTML>
