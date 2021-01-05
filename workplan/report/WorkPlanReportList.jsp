
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.viewform.workplan.WorkPlanVisitViewForm" %>

<%
  String type = request.getParameter("type");
  //显示类型，1为周统计，2为月统计
%>

<script language=javascript>
    function initBanner(objID)
    {       
        for(i = 1; i <= 2; i++)
        {
            document.all("oTDtype_" + i).background="/images/tab2_wev8.png";
            document.all("oTDtype_" + i).className="cycleTD";
        }

        document.all("oTDtype_" + objID).background="/images/tab.active2_wev8.png";
        document.all("oTDtype_" + objID).className="cycleTDCurrent";
        
        var o = document.frames[1].document;
        o.location="WorkPlanReportListContent.jsp?type=" + objID;
    }
    
    function resetBanner(objID)
    {       
        for(i = 1; i <= 2; i++)
        {
            document.all("oTDtype_" + i).background="/images/tab2_wev8.png";
            document.all("oTDtype_" + i).className="cycleTD";
        }

        document.all("oTDtype_" + objID).background="/images/tab.active2_wev8.png";
        document.all("oTDtype_" + objID).className="cycleTDCurrent";
                
        window.location="WorkPlanReportListOperation.jsp?type=" + objID;
    }
</script>

<HTML>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  
  <STYLE>
    #tabPane TR TD{padding-top:2px}
    #monthHtmlTbl TD,#seasonHtmlTbl TD{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
    .cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
    .cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
    .seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
    #subTab{border-bottom:1px solid #879293;padding:0}
  </STYLE>
  
</HEAD>
 
<BODY onload="initBanner(<%= type %>)" style="overflow:auto">

<!--============================= 右键菜单开始 =============================-->
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<!--============================= 右键菜单结束 =============================-->

<TABLE width="100%" height="100%" cellspacing="0" cellpadding="0">
  <TR>
    <TD height="60">
    
    <!--============================= MainFrame标题显示开始 =============================-->
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "";

    titlename = SystemEnv.getHtmlLabelName(19080, user.getLanguage());

    String needhelp ="";    
%>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <!--============================= MainFrame标题显示结束 =============================-->
      
      <FORM name=weaver id=weaver>
        <input type="hidden" name="type" value="1">
        <TABLE style="width:100%;height:95%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
          <colgroup>
            <col width="79"></col>
            <col width="79"></col>
            <col width="*"></col>
            </colgroup>
        <TBODY>
          <TR>
            <TD height="2%"></TD>
          </TR>
          <TR align=left height="20">
            <TD class="cycleTDCurrent" name="oTDtype_1" id="oTDtype_1" background="/images/tab.active2_wev8.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetBanner(1)" ><b><%=SystemEnv.getHtmlLabelName(19057,user.getLanguage())%></b></TD>
            <TD class="cycleTD" name="oTDtype_2" id="oTDtype_2" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetBanner(2)" ><b><%=SystemEnv.getHtmlLabelName(19058,user.getLanguage())%></b></TD>
             <TD style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</TD>
          </TR>
          <TR>
            <TD colspan="4" style="padding:0;">
              <iframe src="" ID="iFrameWorkPlanReportList" name="iFrameWorkPlanReportList" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"/>
            </TD>
          </TR>
        </TBODY>
        </TABLE>
      </FORM>
    </TD>
  </TR>
</TABLE>

</BODY>


