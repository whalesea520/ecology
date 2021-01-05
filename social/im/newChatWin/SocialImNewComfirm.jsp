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
//System.out.println(content);
String id = URLDecoder.decode(Util.null2String(request.getParameter("doid"),""), "UTF-8");
//System.out.println(id);
String openurl="";
//String arrayContent = new String[2];
String comfirmText = "";
if(id.equals("4")){
    //arrayContent = content.split("\\|");
    comfirmText = URLDecoder.decode(Util.null2String(request.getParameter("comfirmText"),""), "UTF-8");
    //System.out.println("arrayContent[0]"+arrayContent[0]);
    //System.out.println("arrayContent[1]="+arrayContent[1]);
}

%>

<div class="zDialog_div_content" id="zDialog_div_content" align="center">
<center>
   <table id="comfirmTable" height="100%" border="0" align="center" cellpadding="10" cellspacing="0" style='padding-top:17px'>         
   <tbody>
   <tr>
   <td align="right"><img id="comfirmIcon" src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" style="" width="26" height="26" align="center"></td>
   <td>&nbsp;&nbsp;</td>
   <td align="left" id="comfirmContent" style="font-size:9pt"></td>
   </tr>      
   </tbody></table>
</center>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout>
        <wea:group context="" attributes="{groupDisplay:none}">
            <wea:item type="toolbar">
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doComfirm()"><!-- 确定 -->
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doClose()">
            </wea:item>
        </wea:group>
    </wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language="javascript">
jQuery(document).ready(function(){
    var content = '<%=content%>';
    var id = '<%=id%>';
    if(id==='4'){
        var content1 = '<%=comfirmText%>';
        content = '<div style=\"margin-left:5px;margin-right:5px;\">' + content;
        content += "<br><br><span style=\"color:red;\">"+content1+"</span>";
        content += "</div>";
    }
    $('#comfirmContent').html(content);
    if(id==='2'||id==='3'||id==='6'){
        $('#comfirmTable').attr("style","padding-top:23px;");
    }
    if(id==='5'){
        $('#comfirmIcon').css('padding-left','20px');
    }
    
    var parentWin = window.Electron.currentWindow.getParentWindow();
});

function closeWin(){
    var win = window.Electron.currentWindow;
    win.close();
}

function doClose(){
    var id = '<%=id%>';
    var dowhat = 'deleteCancel';
    if(id==='2'){
        dowhat = 'signInComfirmCancel';
    }else if(id==='3'){
        dowhat = 'signOutComfirmCancel';
    }else if(id==='4'){
        dowhat = 'signOutComfirmCancelSec';
    }else if(id==='5'){
        dowhat = 'moveToGroupCancel';
    }else if(id==='6'){
        dowhat = 'deleteGroupCancel';
    }
    var args = {
        'doFor':dowhat,
        'doID':id
     }; 
     window.Electron.ipcRenderer.send('plugin-systemComfirm-cb',args);
     closeWin();
}

function doComfirm(){
     var id = '<%=id%>';
     var dowhat = '';
     if(id==='1'){
        dowhat = 'deleteGroupSub';
     }else if(id==='2'){
        dowhat = 'signInComfirmOk';
     }else if(id==='3'){
        dowhat = 'signOutComfirmOk';
     }else if(id==='4'){
        dowhat = 'signOutComfirmOkSec';
        //var openurl = $.base64.decode('<%=openurl%>');
        //window.open(openurl);
     }else if(id==='5'){
        dowhat = 'moveToGroupComfirm';
     }else if(id==='6'){
        dowhat = 'deleteGroupOk';
     }
     var args = {
        'doFor' : dowhat,
        'doID' : id
     }; 
     window.Electron.ipcRenderer.send('plugin-systemComfirm-cb',args);
     closeWin();
}
</script>
</body>
        