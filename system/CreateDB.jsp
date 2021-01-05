<!DOCTYPE HTML>
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
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery(".e8_btn_top_first").hover(function(){
			jQuery(this).addClass("e8_btn_top_first_hover");
		},function(){
			jQuery(this).removeClass("e8_btn_top_first_hover");
		});
	});
</script>
<style type="text/css">
	.e8_btn_top:hover{
		background-color: #03a996 !important;
		color: white!important;
		border: 1px solid #03a996;
	}
</style>
</head>
<%
String message = Util.null2String(request.getParameter("message")) ;
String imagefilename = "/images/hdSystem.gif";
String titlename = "数据库设置" ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CreateDBOperation.jsp">
   
  <TABLE width="800px" style="text-align:center;margin-left:auto;margin-right:auto;margin-top:30px;" height=100% border="0" cellspacing="0" cellpadding="0">
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
	 <tr class=Title >
    	<TD colSpan=2 style="background-color:#f8f8f8;font-weight: bold;text-align:center;height:50px;color:#545454;border:1px solid #eaeaea;padding-bottom:5px;">
    		<span style="display:inline-block;line-height:32px;height:32px;background-image:url(/images/ecology8/dbinit_wev8.png);background-repeat:no-repeat;background-position:0 50%;">
    			<span style="padding-left:42px;display:inline-block;height:32px;line-height:45px;font-size:18px;">数据库</span>
    		</span>
    	</TD>
    </tr>
     <tr>
        <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">验证码:</td>
        <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;"><input style="margin-top:10px;border:1px solid #c5c5c5;width:300px;height:30px;" class="InputStyle"  type=password  name=code maxlength=16 size=16><a style="margin-left:10px;color:#006dff;" href="/system/ModifyCode.jsp?from=db">更改验证码</a></td>
    </tr>
    <tr> 
      <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">数据库类型:</td>
      <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;"> 
	  <span style="padding-top:10px;display:inline-block;">
        <select name=dbtype style="width:300px;height:30px;" onchange="if(this.value==1) {dbport.value='1433';document.getElementById('orclSpan').style.display='none'}else if(this.value==2){ dbport.value='1521'; document.getElementById('orclSpan').style.display='block'} ">
			<option value="1">SqlServer</option>
			<option value="2">Oracle</option>
			<!--option value="3">DB2</option-->
		</select>
    <span id="orclSpan" style="display:none;color:red">(如果为12C容器模式数据库，需要在$ORACLE_HOME/network/admin/sqlnet.ora文件末尾处增加SQLNET.ALLOWED_LOGON_VERSION=8)</span>
	</span>
      </td>
    </tr>
    <tr> 
      <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">数据库服务器IP:</td>
      <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;"> 
        <input style="margin-top:10px;border:1px solid #c5c5c5;width:300px;height:30px;" class="InputStyle" accesskey=Z name=dbserver  maxlength="20" value="127.0.0.1">
      </td>
    </tr>
    <tr>
      <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">数据库端口号:</td>
      <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;">
        <input style="margin-top:10px;border:1px solid #c5c5c5;width:300px;height:30px;" class="InputStyle" accesskey=Z name=dbport  maxlength="20" value="1433">
      </td>
       <script>
           if(document.all('dbtype').value==1){
           document.all('dbport').value='1433';}
           else if(document.all('dbtype').value==2){
            document.getElementById("orclSpan").style.visibility="visible"
            document.all('dbport').value='1521';
           }
       </script>
    </tr>
    <tr>
      <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">数据库名称:</td>
      <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;"> 
        <input style="margin-top:10px;border:1px solid #c5c5c5;width:300px;height:30px;" class="InputStyle" accesskey=Z name=dbname  maxlength="20" value="ecology">
      </td>
    </tr>
    
    
    <tr id="sidtr">
      <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">数据库实例:</td>
      <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;"> 
        <input style="margin-top:10px;border:1px solid #c5c5c5;width:300px;height:30px;" class="InputStyle" accesskey=Z name=sidname  id=sidname maxlength="20" value="MSSQLSERVER" type="text">
      </td>

    </tr>

    
    <tr> 
      <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">用户名:</td>
      <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;"> 
        <input style="margin-top:10px;border:1px solid #c5c5c5;width:300px;height:30px;" class="InputStyle" accesskey=Z name=username  maxlength="20" value="sa">
      </td>
    </tr>
    <tr> 
      <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">密码:</td>
      <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;"> 
        <input style="margin-top:10px;border:1px solid #c5c5c5;width:300px;height:30px;" class="InputStyle" accesskey=Z type=password name=password  maxlength="20" value="">
      </td>
    </tr>
    <tr> 
      <td  style="font-size:14px;color:#5c5c5c;height:33px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;padding-top:6px;">使用现有数据库:</td>
      <td style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;padding-top:10px;"> 
        <input style="margin-top:10px;border:1px solid #c5c5c5;height:30px;" class="InputStyle" accesskey=Z type=checkbox name=isexist  value="1">
      </td>
    </tr>
	<tr>
    	<td colspan="2" style="text-align:right;height:60px;border-left:1px solid #eaeaea;border-bottom:1px solid #eaeaea;border-right:1px solid #eaeaea;">
    	<input style="margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;" class="e8_btn_top_first" id=btnSave accessKey=S name=btnSave type=button    onClick="OnSubmit()"value="初始化数据库"></input> 
		<input style="margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;color:#000;border:1px solid #d8d8d8;" class="e8_btn_top" id=btnClear accessKey=R name=btnClear type=reset value="重  置"></input>
		</td>
    </tr>
    </TBODY> 
  </TABLE>
  </FORM>
	<%
	if(!message.equals("")){
	%>
	<DIV>
	<font color=red size=2>
	<%=message%>
	</font>
	</DIV>
	<%}%>

<SCRIPT language="javascript">
function OnSubmit(){
        document.frmMain.btnSave.disabled = true;
		jQuery("#btnSave").css("background-color", "rgb(224,224,224)");
		jQuery("#btnSave").css("border", "1px solid #d8d8d8");
		jQuery("#btnSave").css("color", "#000");
		document.frmMain.submit();
}
</script>
    
       <script>
function changeselect(){
           if(document.getElementById('dbtype').value==2)
           document.getElementById('sidtr').style.display="none";
           if(document.getElementById('dbtype').value==1)
           document.getElementById('sidtr').style.display="";
}
       </script>
</BODY>
</HTML>
