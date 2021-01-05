<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</HEAD>
<body scroll="no">
<%
    String subcompanyid = "5" ;
%>
<wea:layout type="fourCol">
     <wea:group context="常用条件">
      <wea:item>流程</wea:item>
      <wea:item>
        <div id="workflow_browser"></div>
      </wea:item>

      <wea:item>人员</wea:item>
      <wea:item>
        <div id="userid_browser"></div>
      </wea:item>

      <wea:item>文本1</wea:item>
      <wea:item>
          <input type='text' name='wb1' id='wb1' />
      </wea:item>

      <wea:item>文本2</wea:item>
    <wea:item>
        <input type='text' name='wb2' id='wb2' />
    </wea:item>

     </wea:group>
</wea:layout>
<script type="text/javascript">
jQuery("#workflow_browser").e8Browser({
           name:"workflowid",
           viewType:"0",
           browserValue:"0",
           isMustInput:"1",
           browserSpanValue:"",
           hasInput:true,
           isSingle:true,
           completeUrl:"/data.jsp?type=workflowBrowser&isTemplate=0",
           browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=0&iswfec=1",
           width:"150px",
           hasAdd:false,
           isSingle:true,
           _callbackParams:'',
           _callback:'callbackfunction_wf'
          });
jQuery("#userid_browser").e8Browser({
           name:"userid",
           viewType:"0",
           browserValue:"0",
           isMustInput:"2",
           browserSpanValue:"",
           hasInput:true,
           isSingle:true,
           completeUrl:"/data.jsp?type=161&fielddbtype=browser.dbtest",
           browserUrl:"/systeminfo/BrowserMain.jsp?url=/interface/CommonBrowser.jsp?type=browser.dbtest",
           width:"150px",
           hasAdd:false,
           isSingle:false,
           _callbackParams:'',
           _callback:'callbackfunction'
          });


function callbackfunction_wf(event,datas,name,_callbackParams){
    jQuery("#wb1").val(datas.name);
}

function callbackfunction(event,datas,name,_callbackParams){
    jQuery("#wb2").val(datas.name);
}
</script>
 </body>
</html>
