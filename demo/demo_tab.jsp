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
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="这里是Tab页的标题" />
</jsp:include>
<wea:layout type="fourCol">
     <wea:group context="常用条件">
      <wea:item>流程</wea:item>
      <wea:item>
        <brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false"
        					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=0&iswfec=1"
        					isMustInput="1" isSingle="true" hasInput="true"
         					completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0"
         					width="300px" browserValue="" browserSpanValue="" />
      </wea:item>
      <wea:item>人员</wea:item>
      <wea:item>
        <brow:browser name="userid" viewType="0" hasBrowser="true" hasAdd="false"
                          browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" %>'
                          isMustInput="2"
                          isSingle="false"
                          hasInput="true"
                          completeUrl="/data.jsp?type=1"  width="300px"
                          browserValue=''
                          browserSpanValue=''
                          />
      </wea:item>
     </wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
 </body>
</html>
