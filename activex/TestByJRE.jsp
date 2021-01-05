
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String serverstr=request.getScheme()+"://"+request.getHeader("Host");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title><%=SystemEnv.getHtmlLabelName(22006,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(22042,user.getLanguage())%></title>
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
        function window.onload()
        {
        try
        {
        obj = new ActiveXObject("JavaWebStart.isInstalled");
        obj=null;
        jreobj.style.display='';
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
<body>
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
                                        <span class="STYLE8"><%=SystemEnv.getHtmlLabelName(22011,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22042,user.getLanguage())%></span>
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
                            <object name="jreobj" style="display:none;width:100%;height:500;bgcolor:#FFFFFF;" classid="clsid:CAFEEFAC-0013-0001-0004-ABCDEFFEDCBA" codebase="<%=serverstr%>/resource/j2re-1_3_1_04-windows-i586.exe">
                            <param name = CODE value = weaver.workflow.layout.WorkflowEditor.class >
                            <param name = CODEBASE value = /classbean >
                            <param name="type" value="application/x-java-applet;jpi-version=1.3.1">
                            <param name="scriptable" value="false">
                            <param name="MAYSCRIPT" value="true">
                            <param name = "downloadUrl" value="<%=serverstr%>/weaver/weaver.workflow.layout.DownloadWFLayoutServlet"/>
                            <param name = "id" value="1">
                            <param name = actionRedirectToLogin value = "redirect"/>
                            </object>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
