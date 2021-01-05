<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.Util"%> 
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

String requestid = Util.null2String(request.getParameter("requestid"));
String wfid = Util.null2String(request.getParameter("workflowid"));
boolean isFromAutoDirect = Util.getIntValue(request.getParameter("isfromautodirect")) == 1;
%>
<!-- index.html -->
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title></title>
    <script src="/workflow/design/h5display/js/jquery.min.js"></script>
    <script src="/workflow/design/h5display/js/beans_wev8.js"></script>
    <script src="/workflow/design/h5display/js/design_wev8.js"></script>
    <script src="/workflow/design/h5display/js/canvasUtil_wev8.js"></script>
    <script src="/workflow/design/h5display/js/dataParse.js"></script>
    <script src="/workflow/design/h5display/js/handle.js"></script>
    <script src="/workflow/design/h5display/js/baseLine.js"></script>
    
    <script src="/js/init_wev8.js"></script>
    <script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
    <link rel="stylesheet" type="text/css" href="/workflow/design/h5display/css/design_wev8.css" />
    <script>
     var isFromAutoDirect = <%=isFromAutoDirect%>;
     var alertMsg = '<%=SystemEnv.getHtmlLabelName(21430,user.getLanguage())%>';
     var notOperatorMsg = '<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>';
     var operatorMsg = '<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>';
     var viewerMsg = '<%=SystemEnv.getHtmlLabelName(16355,user.getLanguage())%>';
    </script>
  </head>
  <body>

<!--
    <div id="submitloaddingdiv_out" style="background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.1;opacity:0.1;">
    </div>
    -->
    <span id="submitloaddingdiv" style="height:48px;line-height:48px;width:240px;position:absolute;z-index:9999;font-size:12px;left:50%;top:50%;margin-left:-120px;margin-top:-48px;">
      <img src="/workflow/design/h5display/images/loadding.gif" height="16px" width="16px" style="vertical-align:middle;"/><span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(81558, user.getLanguage()) %></span>
    </span>


    <input type="hidden" id="requestid" name="requestid" value="<%=requestid %>">
    <input type="hidden" id="wfid" name="wfid" value="<%=wfid %>">
    <div class="mainContent" id="mainContent">
    </div>
    <script src="/workflow/design/h5display/js/main.js"></script> 

    <div id="content">
      <div id="dialog-overlay"></div> 
      
      <div id="dialog-box" style=""> 
        <div id="msgTitle">
          <div id="msgtleblockleft"></div>
          <div id="msgtleblockright"></div>
          <div id="msgtleblockcenter">
          <!-- 操作者 -->
          <%=SystemEnv.getHtmlLabelName(99,user.getLanguage()) %>
          </div>
        </div>
        <div id="msgblock"> 
          <div id="dialog-message" style="margin-left:5px;margin-right:5px;"></div> 
        </div> 
      </div> 
    </div>

    

    <div class="tip-yellowsimple" id="tipdiv" style="">
      <div class="tip-inner tip-bg-image" id="tipContent"></div>
      <!--
      <div class="tip-arrow tip-arrow-bottom" style="visibility: inherit;"></div>
      -->
    </div>

    <%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
  </body>
</html>

