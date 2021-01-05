<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="OtherInfoTypeComInfo" class="weaver.hrm.tools.OtherInfoTypeComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(375,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanEdit=HrmUserVarify.checkUserRight("HrmOtherInfoTypeEdit:Edit", user);
boolean CanDelete=HrmUserVarify.checkUserRight("HrmOtherInfoTypeEdit:Delete", user);
boolean CanAdd=HrmUserVarify.checkUserRight("HrmOtherInfoTypeAdd:Add", user);

String id=Util.null2String(request.getParameter("id"));
String typename=OtherInfoTypeComInfo.getTypename(id);
String typeremark=OtherInfoTypeComInfo.getTyperemark(id);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/tools/HrmOtherInfoTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanDelete){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<form name=frmmain method=post action="HrmOtherInfoTypeOperation.jsp">
<input class=inputstyle type=hidden name="operation" >
<input class=inputstyle type=hidden name="id" value="<%=id%>">
<table class=viewform>
  <col width="20%">
  <col width="80%">
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
     <td class=field>
     <%if(CanEdit){%>
     <input class=inputstyle type="input" name="typename" onchange="checkinput('typename','typenamespan')" 
     size=15 maxlength=30 value="<%=Util.toScreenToEdit(typename,user.getLanguage())%>">
     <%if(typename.equals("")){%><span id=typenamespan><IMG src="../../images/BacoError_wev8.gif" align=absMiddle></span><%}%>
     <%} else {%><%=Util.toScreen(typename,user.getLanguage())%><%}%>
     </td>
  </tr>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td> 
     <%if(CanEdit){%>
     <td class=field><input class=inputstyle type="input" name="typeremark" size=50 maxlength=100 
     value="<%=Util.toScreenToEdit(typeremark,user.getLanguage())%>">
     <%} else {%><%=Util.toScreen(typeremark,user.getLanguage())%><%}%>
     </td>
  </tr>
<TR><TD class=Line colSpan=2></TD></TR> 
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script language=javascript>
	function doSave(){
		if(check_form(document.frmmain,'typename')){
			document.frmmain.operation.value="save";
			document.frmmain.submit();
		}
	}
	function doDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmmain.operation.value="delete";
			document.frmmain.submit();
		}
	}
</script>
</body>
</html>