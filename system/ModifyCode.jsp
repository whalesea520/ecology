<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<style type="text/css">
	td,input{
		font-family:"微软雅黑","宋体";
	}
	.e8_btn_top_first_hover{
		background-color:#4393ff!important;
	}
</style>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery(".e8_btn_top_first").hover(function(){
			jQuery(this).addClass("e8_btn_top_first_hover");
		},function(){
			jQuery(this).removeClass("e8_btn_top_first_hover");
		});
	});
</script>
</head>
<%
String message = Util.null2String(request.getParameter("message"));
String from = Util.null2String(request.getParameter("from"));
%>
<BODY style="margin:0 auto;">

<table style="text-align:center;margin-left:auto;margin-right:auto;" width="800px" border="0" cellspacing="0" cellpadding="0">
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
<% if(message.equals("1")) {%>
<font color="#FF0000">旧的验证码不正确！</font>
<%}%>
<% if(message.equals("2")) {%>
<font color="#FF0000"></font>
<%}%>
<FORM id=password name=frmMain style="MARGIN-TOP: 3px" action=CodeOperation.jsp method=post onsubmit="return checkpassword()">
<input type=hidden name=operation value="changecode">
<TABLE class=viewForm class=ViewForm  width="750px" cellspacing="0">
  <COLGROUP>
  <COL width="30%">
  <COL width="70%">
  <TBODY>
  <TR class=title>
    <TD colSpan=2 style="background-color:#f8f8f8;font-weight: bold;text-align:center;height:50px;color:#545454;border:1px solid #eaeaea;padding-bottom:5px;">
   		<span style="display:inline-block;line-height:32px;height:32px;">
   			<span style="display:inline-block;height:32px;line-height:32px;font-size:18px;">验证码变更</span>
   		</span>
   	</TD>
    </TR>
    <tr>
      <TD style="vertical-align:bottom;font-size:14px;color:#5c5c5c;height:60px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;">旧验证码:</TD>
    <TD style="vertical-align:bottom;font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;"><INPUT class=inputstyle id=passwordold type=password
    name=passwordold style="border:1px solid #c5c5c5;width:300px;height:30px;"  onchange='checkinput("passwordold","passwordoldimage")'>
	<SPAN id=passwordoldimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
	</TD>
    </TR>
  <TR>
      <TD style="font-size:14px;color:#5c5c5c;height:60px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;">新验证码:</TD>
    <TD  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;"><INPUT style="border:1px solid #c5c5c5;width:300px;height:30px;"  class=inputstyle id=passwordnew type=password
    name=passwordnew onchange='checkinput("passwordnew","passwordnewimage")'>
        <span id=passwordnewimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></TD>
    </TR>
  <TR>
      <TD style="vertical-align:top;font-size:14px;color:#5c5c5c;height:60px;border-bottom:1px solid #f4f4f4;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;">确认新验证码:</TD>
    <TD  style="vertical-align:top;font-size:14px;color:#5c5c5c;border-bottom:1px solid #f4f4f4;border-right:1px solid #eaeaea;"><INPUT class=inputstyle id=confirmpassword type=password
      name=confirmpassword style="border:1px solid #c5c5c5;width:300px;height:30px;"  onchange='checkinput("confirmpassword","confirmpasswordimage")'>
        <span id=confirmpasswordimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></TD>
    </TR>
    <tr>
    	<td colspan="2" style="text-align:right;height:60px;border-left:1px solid #eaeaea;border-bottom:1px solid #eaeaea;border-right:1px solid #eaeaea;">
    	<input style="margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;" class="e8_btn_top_first" id=btnSave accessKey=S name=btnSave type=submit value="提 交"></input> 
    	<input style="margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;" class="e8_btn_top_first" id=btnSaves accessKey=S name=btnSaves type=button onclick="javascript:top.location='<%=from.equals("db")?"/system/CreateDB.jsp":"/system/InLicense.jsp"%>'" value="返 回"></input> 
    	</td>
    </tr>
    </TBODY>
    </TABLE>
    </FORM>
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
function submitData() {
 if(checkpassword ()){
 frmMain.submit();
 }
}
function check_form(thiswins,items)
{
	thiswin = thiswins
	items = items + ",";

	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);

	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 top.Dialog.alert("必填信息不完整！");
		 return false;
		}

	}
	return true;
}

function checkpassword() {
if(!check_form(password,"passwordold,passwordnew,confirmpassword"))
    return false;
if(password.passwordnew.value != password.confirmpassword.value) {
    top.Dialog.alert("两次输入的新验证码不同!");
    return false;
}
return true;
	}
	</script>
	 </BODY>
    </HTML>