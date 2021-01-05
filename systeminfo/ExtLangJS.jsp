<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>

<%
      //获取语言id，默认为7：简体中文
      int  languageId=Util.getIntValue(request.getParameter("languageId"),7);
	  //在没有维护语言js的情形下，默认取8：英文
%>
<%if(languageId==7) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk_wev8.js'></script>
<%} else if(languageId==9) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_TW_wev8.js'></script>
<%} else {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en_wev8.js'></script>
<%} %>