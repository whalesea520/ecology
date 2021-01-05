<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.AES" %>
<%@ page import="weaver.file.Prop" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AESCoder" class="weaver.file.AESCoder" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(user.getUID() != 1){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelNames("103,15024,724,87",user.getLanguage());
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String needfav ="1";
String needhelp ="";

String id = String.valueOf(user.getUID());
String message = Util.null2String(request.getParameter("message"));

String operation = Util.null2String(request.getParameter("operation"));
String keyCode = Util.null2String(RecordSet.getPropValue("DBEncoder", "key"));
if("changeDBpassword".equals(operation)){
	try{
	      Prop prop = Prop.getInstance();
		  String passwordold = Util.null2String(request.getParameter("passwordold"));
		  String passwordnew = Util.null2String(request.getParameter("passwordnew"));
		  String ecology_password = prop.getPropValueBase(GCONST.getConfigFile() , "ecology.password");
		  ecology_password = AESCoder.decrypt(ecology_password, keyCode);
		  if(!ecology_password.equals(passwordold)){
		      response.sendRedirect("DBPasswordAlter.jsp?message=2");
		  }else{
		  	  String username = Util.null2String(request.getParameter("username"));
		      boolean flag = prop.setPropValue(GCONST.getConfigFile(),"ecology.password",AESCoder.encrypt(passwordnew, keyCode));
		      boolean flag2 = prop.setPropValue(GCONST.getConfigFile(),"ecology.user",AESCoder.encrypt(username, keyCode));
		      if(flag && flag2){
		          response.sendRedirect("DBPasswordAlter.jsp?message=1");
		      }else{
		          response.sendRedirect("DBPasswordAlter.jsp?message=3");
		      }
		  }
	}catch(Exception e){
		 RecordSet.writeLog("changeDBpassword:"+e.getMessage());
         response.sendRedirect("DBPasswordAlter.jsp?message=3");
	}
}

%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<%if(isfromtab) {%>
<TABLE width='100%'>
<%}else {%>
<TABLE class=Shadow>
<%} %>
<tr>
<td valign="top">
<% if(message.equals("1")) {%>
<font color="#FF0000"><%=SystemEnv.getHtmlLabelNames("103,15242",user.getLanguage())%></font> 
<%}%>
<% if(message.equals("2")) {%>
<font color="#FF0000"><%=SystemEnv.getHtmlLabelNames("15024,32738,27685",user.getLanguage())%></font> 
<%}%>
<% if(message.equals("3")) {%>
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(22891,user.getLanguage())%></font> 
<%}%>
<FORM id=password name=frmMain style="MARGIN-TOP: 3px" action=DBPasswordAlter.jsp method=post>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type=hidden name=operation value="changeDBpassword">
<wea:layout type="2col">
<wea:group context='<%=SystemEnv.getHtmlLabelNames("103,15024,724,87",user.getLanguage())%>' >

<wea:item><%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())%></wea:item>
<wea:item>
  <span id=keycode name=keycode ><%=keyCode %></span>
</wea:item>

<wea:item><%=SystemEnv.getHtmlLabelNames("15024,2072",user.getLanguage())%></wea:item>
<wea:item><INPUT class=inputstyle id=user type=text style="width: 150px;"
  name=username onchange='checkinput("username","usernameimage")'>
	<SPAN id=usernameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
</wea:item>

<wea:item><%=SystemEnv.getHtmlLabelNames("15024,32738",user.getLanguage())%></wea:item>
<wea:item><INPUT class=inputstyle id=passwordold type=password style="width: 150px;"
  name=passwordold onchange='checkinput("passwordold","passwordoldimage")'>
	<SPAN id=passwordoldimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelNames("15024,27303",user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle id=passwordnew type=password style="width: 150px"
    name=passwordnew onchange='checkinput("passwordnew","passwordnewimage")'> <span id=passwordnewimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span>

		</wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelNames("16631,15024,27303",user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle id=confirmpassword type=password style="width: 150px"
      name=confirmpassword onchange='checkinput("confirmpassword","confirmpasswordimage")'>
        <span id=confirmpasswordimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></wea:item>
  <wea:item></wea:item>

 </wea:group>
 </wea:layout>
</FORM>
<script type="text/javascript">
	function submitData(){
		if(checkpassword()){
			frmMain.submit();
		}
	}
	function checkpassword() {
		if("<%=keyCode%>" == ""){
		 	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())+SystemEnv.getHtmlLabelName(82241,user.getLanguage())%>");
    		return false;
		}
		if(!check_form(password,"username,passwordold,passwordnew,confirmpassword")) 
    		return false;
		if(password.passwordnew.value != password.confirmpassword.value) {
		 	top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
    		return false;
		}
		return true;
	}
</script>
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
</body>
</html>