<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
if(!HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(370,user.getLanguage())+SystemEnv.getHtmlLabelName(371,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(77,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanAdd = HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user);
String countryid=Util.null2String(request.getParameter("countryid"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmPubHoliday.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmmain method=post action="HrmPubHolidayOperation.jsp" onSubmit="return check_form(this,'fromyear,toyear')">
<input class=inputstyle type="hidden" name="operation" value="copy">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
  	<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
  	<wea:item><%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%>
  	<input class=inputstyle type="hidden" name="countryid" value="<%=countryid%>"></wea:item>
  	<wea:item><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>)</wea:item>
  	<wea:item>
  	  <input class=inputstyle type="input" name="fromyear" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("fromyear")' size=15 maxlength=4 style="width: 80px">
  	   - <input class=inputstyle type="input" name="toyear" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("toyear")' size=15 maxlength=4 style="width: 80px">
  	</wea:item>
	</wea:group>
</wea:layout>
</form>
<script language=javascript>
 function submitData() {
     if(check_form(frmmain,'fromyear,toyear')){
         frmmain.submit();
     }
}
</script>
</body>
</html>
