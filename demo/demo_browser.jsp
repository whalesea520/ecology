<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
</HEAD>
<body scroll="no">
<%
    String subcompanyid = "5" ;
%>
<wea:layout type="fourCol">
     <wea:group context="常用条件">
      <wea:item>流程</wea:item>
      <wea:item>
	  <input type='text' id="t" name='t' value="" />
        <brow:browser name="workflowid"
		viewType="0" 
		hasBrowser="true" 
		hasAdd="true"
		addUrl="/demo.jsp"
        getBrowserUrlFn="geturl"
		isMustInput="1" isSingle="true" hasInput="true"
        completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0"
        width="300px" browserValue="1" browserSpanValue="Test" />
      </wea:item>
      <wea:item>人员</wea:item>
      <wea:item>
        <brow:browser name="userid" 
		viewType="0" 
		hasBrowser="true" 
		hasAdd="false"
	  browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" %>'
	  isMustInput="2"
	  isSingle="false"
	  hasInput="true"
	  completeUrl="/data.jsp?type=1"  width="300px"
	  browserValue='12,24'
	  browserSpanValue='张三,李四'
	  _callback="callback"
	  _callbackParams="testabc"
                          />
      </wea:item>
     </wea:group>
</wea:layout>
<script type="text/javascript">
function geturl(){
	var t = jQuery("#t").val();
	if(t=='1'){
		return "/systeminfo/BrowserMain.jsp?url=/meeting/meetingbrowser.jsp";
	}else{
		return "/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp";
	}
}

function callback(event,datas,name,_callbackParams){
	console.log("_callbackParams = "+_callbackParams);
	console.log("name = "+name+"选中的值为："+datas.id+""+datas.name);
	
}
</script>
 </body>
</html>
