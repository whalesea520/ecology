
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%
String temStr = "/docs/docs/";

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title><%=SystemEnv.getHtmlLabelName(22006,user.getLanguage())%>:Office <%=SystemEnv.getHtmlLabelName(22037,user.getLanguage())%></title>
    <style type="text/css">
        <!--
        body {
            margin-left: 0px;
            margin-top: 0px;
        }

        .STYLE8 {
            font-size: 12px;
            font-weight: bold;
            color: #3169ce;
        }
        .STYLE9 {
            font-size: 12px;
            font-weight: bold;
            color:#008d42;
        }
        -->
    </style>
    <script language="JavaScript">
        <!--

if (window.Event)
  document.captureEvents(Event.MOUSEUP);

function nocontextmenu()
{
 event.cancelBubble = true
 event.returnValue = false;

 return false;
}

function norightclick(e)
{
 if (window.Event)
 {
  if (e.which == 2 || e.which == 3)
   return false;
 }
 else
  if (event.button == 2 || event.button == 3)
  {
   event.cancelBubble = true
   event.returnValue = false;
   return false;
  }

}

document.oncontextmenu = nocontextmenu;  // for IE5+
document.onmousedown = norightclick;  // for all others
//-->
        function onLoad()
        {
        try
        {
        WebOffice.WebUrl="<%=mServerUrl%>";

        WebOffice.WebOpen();  	//打开该文档
        WebOffice.style.display='';
        document.all("spnResult").innerHTML = "<span style='font-size:12px;font-weight:bold;color:#008d42;'><%=SystemEnv.getHtmlLabelName(22038, user.getLanguage())%></span>";
        document.all("imgtd").innerHTML="&nbsp;<img src='/images/plugin/right_wev8.gif' width=40 height=40/>";
        }
        catch(e)
        {
        document.all("imgtd").innerHTML="&nbsp;<img src='/images/plugin/warning_wev8.gif' width=40 height=40/>";
        document.all("spnResult").innerHTML = "<span style='font-size:12px;font-weight:bold;color:#FF0000;'><%=SystemEnv.getHtmlLabelName(22039, user.getLanguage())%></span>";
        }
        }
    </script>
</head>
<body onload="onLoad()">
    <table width="660" height="10" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="57759F">
        <tr>
            <td colspan="2" valign="top">
                <table width="660" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                    <tr>
                        <td height="64" background="/images/plugin/back_2_wev8.gif">
                            <table width="226" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="56" rowspan="3" id="imgtd">&nbsp;</td>
                                    <td width="170">
                                        <span class="STYLE8"><%=SystemEnv.getHtmlLabelName(22011,user.getLanguage())%> Office <%=SystemEnv.getHtmlLabelName(22037,user.getLanguage())%></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td><img src="/images/plugin/line_1_wev8.gif" width="84" height="2"/></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="spnResult" class="STYLE9"><img src="/images/loading2_wev8.gif" /><%=SystemEnv.getHtmlLabelName(22372, user.getLanguage())%></div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <OBJECT id="WebOffice" name="WebOffice" classid="<%=mClassId%>" style="display:none;width:100%;height:500;bgcolor:#FFFFFF;top:-23;filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';" codebase="<%=mClientUrl%>" VIEWASTEXT></object>
                        </td>
                    </tr>
                </table>                
            </td>
        </tr>
    </table>
</body>
</html>
