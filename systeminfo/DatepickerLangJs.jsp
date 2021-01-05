<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>

<%
      int  languageId=Util.getIntValue(request.getParameter("languageId"),7);
%>
<%if(languageId==7) {%>
	<script src="/workplan/calendar/src/Plugins/datepicker_lang_ZH_wev8.js" type="text/javascript"></script> 
<%} else if(languageId==9) {%>
	<script src="/workplan/calendar/src/Plugins/datepicker_lang_HK_wev8.js" type="text/javascript"></script> 
<%} else {%>
	<script src="/workplan/calendar/src/Plugins/datepicker_lang_US_wev8.js" type="text/javascript"></script> 
<%} %>
