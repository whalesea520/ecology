
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp"%>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<head>
    <style type="text/css">
.href {
    color: blue;
    text-decoration: underline;
    cursor: hand
}
</style>
</head>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "" + SystemEnv.getHtmlLabelName(24266, user.getLanguage());
    String needfav = "1";
    String needhelp = "";

    String showTop = Util.null2String(request.getParameter("showTop"));

    int userId = user.getUID();

    rs.execute("SELECT id FROM MailSign WHERE userId = " + userId + "  AND isActive = 1");
    String defaultId = null;
    while (rs.next()) {
        defaultId = rs.getString("id");
    }
%>
    <script type="text/javascript">
        function submitForRule() {
            var chk = document.getElementsByName("isActive");
            for (var i = 0; i < chk.length; i++) {
                if (chk[i].checked) {
                    fMailSign.defaultSignId.value = chk[i].value;
                }
            }
            fMailSign.submit();
        }
        
        var dialog = null;
        
        function closeDialog() {
            if (dialog) dialog.close();
            _table.reLoad();
        }
        
        function deleteSign(id) {
            if (confirm("<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>")) {
                location.href = "/email/MailSignOperation.jsp?ids=" + id;
            }
        }
        
        function batchDelete() {
            var id = _xtable_CheckedCheckboxId();
            if (id == "") {
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568, user.getLanguage())%>!");
                return;
            }
            window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83062, user.getLanguage())%>？", function() {
                id = id.substring(0, id.length - 1);
                deleteSign(id);
            });
        }
        
        function addInfo() {
            dialog = new window.top.Dialog();
            dialog.currentWindow = window;
            var url = "/email/MailSignAdd.jsp";
            dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,24266", user.getLanguage())%>";  //新建
            dialog.Width = 850;
            dialog.Height = 650;
            dialog.Drag = true;
            dialog.URL = url;
            dialog.show();
        }
        
        function editInfo(id) {
            dialog = new window.top.Dialog();
            dialog.currentWindow = window;
            var url = "/email/MailSignEdit.jsp?id=" + id;
            dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,24266", user.getLanguage())%>";  //编辑
            dialog.Width = 850;
            dialog.Height = 550;
            dialog.Drag = true;
            dialog.URL = url;
            dialog.show();
        }
        
        var defaultId = "<%=defaultId%>";
        var isClear = false;
        
        function detectRadioStatus(obj) {
            if (defaultId == obj.value && !isClear) {
                isClear = true;
                jQuery("#isclear").val("1");
                clearRadioSelected();
            } else {
                isClear = false;
                jQuery("#isclear").val("0");
                defaultId = obj.value;
                changeRadioStatus(obj, true);
            }
        }
        
        function clearRadioSelected() {
            var radios = document.getElementsByName("isActive");;
            for (var i = 0; i < radios.length; i++) {
                changeRadioStatus(radios[i], false);
            }
        }
        
        function showSignInfo() {}
    </script>
    <script type="text/javascript" src="/email/js/waitdeal/jquery.qtip-1.0.0-rc3.js"></script>

<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitForRule(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + ",javascript:addInfo(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(32136, user.getLanguage()) + ",javascript:batchDelete(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

<%
    int perpage = 10;
    int languageid = user.getLanguage();
    String orderBy = "signName";
    String backFields = "id , signName , signDesc ,isActive, signType";
    String sqlFrom = "from MailSign";
    String sqlwhere = "userId = "+userId;
    String operateString= "<operates width=\"15%\">";
           operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getSignOpratePopedom\"></popedom> ";
           operateString+="     <operate href=\"javascript:editInfo()\" target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
           operateString+="     <operate href=\"javascript:deleteSign()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
           operateString+="</operates>";
    String tableString="<table  pageId=\""+PageIdConst.Email_Sign+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Sign,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"checkbox\">";
           tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
           tableString+="<head>";
           tableString+="<col width=\"25%\"  target=\"_self\" text=\""+ SystemEnv.getHtmlLabelName(20148,user.getLanguage()) +"\" column=\"signName\""+
                 " otherpara=\"column:id+column:signType\" transmethod=\"weaver.email.MailSettingTransMethod.getSignInfo\" />";
                tableString+="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("20148,63",user.getLanguage())+"\" transmethod=\"weaver.email.MailSettingTransMethod.geSignType\" otherpara=\"column:signType+"+languageid+"\" column=\"signType\"/>";
           tableString+="<col width=\"50%\"  text=\""+ SystemEnv.getHtmlLabelName(85,user.getLanguage()) +"\" column=\"signDesc\"/>";
           tableString+="<col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(149,user.getLanguage()) +"\" column=\"id\""+
                 " otherpara=\"column:isActive\" transmethod=\"weaver.email.MailSettingTransMethod.geSignCheckInfo\" />";
           tableString+="</head>"+operateString;
           tableString+="</table>";
%>

<html>
    <body>
        <wea:layout attributes="{layoutTableId:topTitle}">
            <wea:group context="" attributes="{groupDisplay:none}">
                <wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">

                    <input class="e8_btn_top middle" onclick="submitForRule()" type="button"
                        value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" />
                    <input class="e8_btn_top middle" onclick="addInfo()" type="button"
                        value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>" />
                    <input class="e8_btn_top middle" onclick="batchDelete()" type="button"
                        value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>" />
                    <span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage())%>"
                        class="cornerMenu"></span>
                </wea:item>
            </wea:group>
        </wea:layout>

        <form id="fMailSign" method="post" action="MailSignOperation.jsp">
            <input type="hidden" name="operation" value="default" />
            <input type="hidden" name="isclear" id="isclear" value="0">
            <input type="hidden" name="defaultSignId" value="" />
            <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_Sign%>">
            <wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
        </form>
    </body>
</html>
