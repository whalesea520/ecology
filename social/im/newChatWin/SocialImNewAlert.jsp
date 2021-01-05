<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language='javascript' type='text/javascript' src='/social/js/jquery.base64/jquery.base64_wev8.js'></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
</head>

<body>

<%
String content = URLDecoder.decode(Util.null2String(request.getParameter("content"),""), "UTF-8");
%>

<div class="zDialog_div_content" id="zDialog_div_content" align="center">
<center>
   <table height="100%" border="0" align="center" cellpadding="10" cellspacing="0" style='padding-top:25px'>         
   <tbody>
   <tr>
   <td align="right"><img id="alertIcon" src="/wui/theme/ecology8/skins/default/rightbox/icon_alert_wev8.png" style="" width="26" height="26" align="center"></td>
   <td>&nbsp;&nbsp;</td>
   <td align="left" id="alertContent" style="font-size:9pt"></td>
   </tr>      
   </tbody></table>
</center>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout>
        <wea:group context="" attributes="{groupDisplay:none}">
            <wea:item type="toolbar">
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doComfirm()"><!-- 确定 -->
                
            </wea:item>
        </wea:group>
    </wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language="javascript">
jQuery(document).ready(function(){
    var content = '<%=content%>'; 
    $('#alertContent').html(content);
    var parentWin = window.Electron.currentWindow.getParentWindow();
});

function doComfirm(){
    var win = window.Electron.currentWindow;
    win.close();
}
</script>
</body>
        