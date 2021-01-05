
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
  int uid=user.getUID();
  int isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0);
  int iswfec=Util.getIntValue(Util.null2String(request.getParameter("iswfec")),0);
  String workflowsingle=(String)session.getAttribute("workflowsingle");
  String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
  if(workflowsingle==null){
  Cookie[] cks= request.getCookies();

    for(int i=0;i<cks.length;i++){
      //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
      if(cks[i].getName().equals("workflowsingle"+uid)){
        workflowsingle=cks[i].getValue();
        break;
      }
    }
  }
  String tabid="1";
  if(workflowsingle!=null&&workflowsingle.length()>0){
  String[] atts=Util.TokenizerString2(workflowsingle,"|");
  tabid=atts[0];

  String initUrl = "/workflow/workflow/WorkflowBrowser1.jsp?isWorkflowDoc="+isWorkflowDoc+"&isTemplate="+isTemplate+"&iswfec="+iswfec;
}
%>
<html>
  <head>  
  <script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
  <link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
  <link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
  <script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

  <link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
  <link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
  <script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
  <script type="text/javascript">
    var rootWindow = parent.parent;
    var dialog = rootWindow.getDialog( parent );

    $(function(){
        $('.e8_box').Tabs({
            getLine:1,
            mouldID:"<%=MouldIDConst.getID("workflow")%>",
            iframe:"tabcontentframe",
            staticOnLoad:true,
            objName:"<%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%>"
         });
    }); 

    function viewSourceUrl(){
          prompt("",location);
    }

    function openTab(tabId){
      if(tabId == 1)
        $("#tabcontentframe").attr("src","/workflow/workflow/WorkflowBrowser1.jsp?isWorkflowDoc=<%=isWorkflowDoc%>&isTemplate=<%=isTemplate%>&iswfec=<%=iswfec%>");
      else if(tabId == 2)
        $("#tabcontentframe").attr("src","/workflow/workflow/WorkflowSearch.jsp?isWorkflowDoc=<%=isWorkflowDoc%>&isTemplate=<%=isTemplate%>&iswfec=<%=iswfec%>");
    }

    jQuery(document).ready(function(){
       $("#tabcontentframe").attr("src","/workflow/workflow/WorkflowBrowser1.jsp?isWorkflowDoc=<%=isWorkflowDoc%>&isTemplate=<%=isTemplate%>&iswfec=<%=iswfec%>");
    });

    function doClear() {
      var result = {id : '', name : ''};
      
      if(dialog){
        dialog.callback(result);
      }else{  
        rootWindow.returnValue  = result;
        rootWindow.close();
      } 
    }

    function doCancel() {
      if(dialog){
        dialog.close();
      }else{  
        rootWindow.close();
      }
    }
  </script>
</head>
<body>
  <div class="e8_box demo2">
    <div class="e8_boxhead">
        <div class="div_e8_xtree" id="div_e8_xtree"></div>
          <div class="e8_tablogo" id="e8_tablogo"></div>
      <div class="e8_ultab">
        <div class="e8_navtab" id="e8_navtab">
           <span id="objName"></span>
        </div>
        <div>
            <ul class="tab_menu">
              <li class="current">
                  <a onclick="openTab(1)" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></a>
                </li>
              <li>
                  <a onclick="openTab(2)" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(18412, user.getLanguage())%></a>
                </li>
            </ul>
            <div id="rightBox" class="e8_rightBox"></div>
          </div>
      </div>
    </div> 
    <div class="tab_box">
          <div>
              <iframe onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="250" width="100%;"></iframe>
          </div>
    </div>
  </div>

  <div style='height:250px;'>
    <iframe name=frame2 id=frame2 src="/workflow/workflow/WorkflowSelect.jsp?isWorkflowDoc=<%=isWorkflowDoc %>&tabid=1&isTemplate=<%=isTemplate%>&iswfec=<%=iswfec%>" width=100%  height=100% frameborder=no scrolling=no>
    <%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%>
    </iframe>
  </div>

  <div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0px!important;height:40px;">
    <div style="padding:5px 0px;">
      <wea:layout needImportDefaultJsAndCss="false">
        <wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
          <wea:item type="toolbar">
             <input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doClear()" style="width: 50px!important;">
              <input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
          </wea:item>
        </wea:group>
      </wea:layout>
    </div>
  </div>
</body>
</html>
