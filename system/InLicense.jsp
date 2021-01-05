<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="LN" class="ln.LN" scope="page" />


<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<HTML><HEAD>
<style type="text/css">
	td,input{
		font-family:"微软雅黑","宋体";
	}
	.e8_btn_top_first_hover{
		background-color:#4393ff!important;
	}
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery(".e8_btn_top_first").hover(function(){
			jQuery(this).addClass("e8_btn_top_first_hover");
		},function(){
			jQuery(this).removeClass("e8_btn_top_first_hover");
		});
		jQuery(".e8_btn_top_file").hover(function(){
			jQuery("#e8filebtn").addClass("e8_btn_top_first_hover");
		},function(){
			jQuery("#e8filebtn").removeClass("e8_btn_top_first_hover");
		});
		try{
			parent.setTabObjName('License提交');
		}catch(e){}
	});
</script>
</head>
<%
String message = Util.null2String(request.getParameter("message")) ;
String code = Util.null2String(request.getParameter("code")) ;
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "LICENSE" ;
String needfav ="1";
String needhelp ="";

String licensecode = "";
licensecode = LN.MakeLicensecode();

//companyname=Util.toScreen(companyname,7);
%>
<BODY>


<FORM id="codeform" style="MARGIN-TOP: 0px" name=frmMain action="LicenseOperation.jsp" method=post onsubmit="return checkcode()" enctype="multipart/form-data">
<%if(message.equals("")){%>
<table width="800px" style="text-align:center;margin-left:auto;margin-right:auto;" height=100% border="0" cellspacing="0" cellpadding="0">
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
  <TABLE class=ViewForm  width="750px" cellspacing="0">
    <COLGROUP> <COL width="15%"> <COL width="80%"><TBODY>
    <tr class=Title >
    	<TD colSpan=2 style="background-color:#f8f8f8;font-weight: bold;text-align:center;height:50px;color:#545454;border:1px solid #eaeaea;padding-bottom:5px;">
    		<span style="display:inline-block;line-height:32px;height:32px;background-image:url(/images/ecology8/license_wev8.png);background-repeat:no-repeat;background-position:0 50%;">
    			<span style="padding-left:42px;display:inline-block;height:32px;line-height:45px;font-size:18px;">License&nbsp;提&nbsp;交</span>
    		</span>
    	</TD>
    </tr>
    <tr>
        <td style="font-size:14px;color:#5c5c5c;height:100px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;">验证码:</td>
        <td  style="font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;text-align:left;">
        	<input style="border:1px solid #c5c5c5;width:300px;height:30px;" class="InputStyle" type=password  id=code name=code maxlength=16 size=16 onchange='checkinput("code","codeimage")'><SPAN id=codeimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN><a style="margin-left:10px;color:#006dff;" href="/system/ModifyCode.jsp">更改验证码</a></td>
    </tr>
    <tr>
        <td style="line-height:30px;font-size:14px;color:#5c5c5c;vertical-align:top;height:140px;border-bottom:1px solid #f4f4f4;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;">license文件:</td>
        <td style="position:relative;font-size:14px;color:#5c5c5c;vertical-align:top;border-bottom:1px solid #f4f4f4;border-right:1px solid #eaeaea;padding-right:5px;text-align:left;">
        	<input id="e8filebtn" type="button" style="margin-left:1px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;" class="e8_btn_top_first" id=btnSave accessKey=S name=btnSave type=button value="选择文件"></input>
        	<SPAN id=licenseimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
        	<span id="fileName">未选择文件</span>
        	<input class="e8_btn_top_file" style="cursor:pointer;opacity:0;filter:alpha(opacity:0);hidden;width:100px;height:35px;left:0;top:0;position:absolute;" class="InputStyle" type=file id="license" name=license size=50 onchange='checkinput("license","licenseimage");document.getElementById("fileName").innerHTML=this.value;'>
        </td>
    </tr>
    <tr>
    	<td colspan="2" style="text-align:right;height:60px;border-left:1px solid #eaeaea;border-bottom:1px solid #eaeaea;border-right:1px solid #eaeaea;">
    	<input style="margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;" class="e8_btn_top_first" id=btnSave accessKey=S name=btnSave type=submit value="提 交"></input> </td>
    </tr>
    </TBODY> 
  </TABLE>
  <br>
	<DIV style="font-size:14px;color:#5c5c5c;text-align:left;">
	识别码:	<span class=fontred style="color:#006dff;"><%=licensecode%></span>
	<br><br>
	
	提　示: <span>请将<span class=fontred style="color:#ffa300;">公司名称</span>及<span class=fontred style="color:#ffa300;">识别码</span>提交给软件供应商,以获取License</span>
	</DIV>

	<%}else if(!message.equals("")){%>
	<table width="800px" style="text-align:center;margin-left:auto;margin-right:auto;" height=100% border="0" cellspacing="0" cellpadding="0">
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
		  <TABLE class=ViewForm  width="750px" cellspacing="0">
		    <COLGROUP> <COL width="15%"> <COL width="80%"><TBODY>
		    <tr class=Title >
		    	<TD colSpan=2 style="background-color:#f8f8f8;font-weight: bold;text-align:center;height:50px;color:#545454;border:1px solid #eaeaea;padding-bottom:5px;">
		    		<span style="display:inline-block;line-height:32px;height:32px;">
		    			<span style="display:inline-block;height:32px;line-height:45px;font-size:18px;">提交反馈信息</span>
		    		</span>
		    	</TD>
		    </tr>
		    <tr>
		    	<%
			//message=0 表示License信息错误;message=1 表示成功;message=2 表示数据库连接或者执行出错;message=3 表示License文件上传出错;
			//message=4 表示License信息错误，License过期;message=5 表示License信息错误，注册用户数大于License申请人数;message=6 表示选择的License文件不正确
			String _mess = message;
			if(message.equals("1")){
				message=" Success ! " ;
			}else if(message.equals("0")){
				message="License信息错误，请检查启动脚本是否包含GBK字符集并重新启动Resin尝试,并且检查License是否正确(E8要求更换公司名称的授权必须清空ecology/license目录再重启Resin提交)！<br><br/>";
				message+="License message error,please check the start script contain 'GBK' and try to restart Resin and check if the License is correct(you must clear ecology/license and restart resin before you upload the difference conpanyname License in E8)!";
			}else if(message.equals("2")){
				message="数据库连接或者执行失败，请按下列步骤检查：<br>1.检查数据库服务器是否正常；<br>2.检查数据库驱动包是否存在；<br>3.检查weaver.properies配置信息是否正确；<br>4.检查ecology日志是否有异常！<br><br>";
				message+="Failed to Connect Data Server,please check by step as below:<br>1.checking the Data Server is OK;<br>2.checking the SQL driver is exist;<br>";
				message+="3.checking the message of the file 'weaver.properies' is right;<br>4.Check ecology log exception !";
			}else if(message.equals("3")){
				message="License文件上传出错！<br><br/>";
				message+="License file uploading error!";
			}else if(message.equals("4")){
				message="License信息错误，License已过期！<br><br/>";
				message+="License message error,license is overdue!";
			}else if(message.equals("5")){
				message="License信息错误，已分配用户数大于License申请人数！<br><br>";
				message+="License message error,the HRMs is larger than the apllied in the license!";
			}else if(message.equals("6")){
				message="没有选择正确的License文件或者License文件不存在！<br><br>";
				message+="Wrong choosing License file or License file is not exist!";
			}else if(message.equals("7")){
				message="1.验证码不得为空！<br>2.系统设置表Systemset字段filesystem值对应路径(默认为空)不存在或者没有写权限，详细见ecology/log/ecology日志!<br><br/>";
				message+="1.Verification code must not be empty! <br>2.System error ,detail to see the ecology log!";
			}
				%>
		    	<%if(!_mess.equals("1")){ %>
			    	<td style="height:240px;border-left:1px solid #eaeaea;border-bottom:1px solid #f4f4f4;text-align:right;padding-right:10px;">
			    		<span><img src="/images/ecology8/fail_wev8.png" style="vertical-align:middle;width:32px;height:32px;"/></span>
			    	</td>
			        <td style="font-size:14px;color:#d62c2c;border-bottom:1px solid #f4f4f4;border-right:1px solid #eaeaea;text-align:left;padding-right:30px;">
						<span>
			    			<span style="color:#d62c2c;font-size:18px;">
				<%=Util.toScreen(message,7,"2")%>
			    			</span>
			    		</span>
					</td>
			<%}else{ %>
				<td colspan="2" style="height:240px;font-size:14px;color:#5c5c5c;border-left:1px solid #eaeaea;border-bottom:1px solid #f4f4f4;border-right:1px solid #eaeaea;text-align:center;padding-right:30px;">
						<span style="display:inline-block;background-image:url(/images/ecology8/success_wev8.png);background-repeat:no-repeat;background-position:0 50%;height:32px;">
			    			<span style="display:inline-block;height:32px;line-height:32px;color:#209e29;font-size:18px;padding-left:42px;">
				<%=Util.toScreen(message,7,"2")%>
			    			</span>
			    		</span>
					</td>
			<%} %>
		    </tr>
		    <tr>
		    	<td colspan="2" style="text-align:right;height:60px;border-left:1px solid #eaeaea;border-bottom:1px solid #eaeaea;border-right:1px solid #eaeaea;">
			    	<%if(_mess.equals("1")){ %>
			    		<input style="margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;" class="e8_btn_top_first" id=btnSave accessKey=S name=btnSave onclick="javascript:top.location='/index.htm'" type=button value="登 录"></input>
			    	<%}else{ %>
			    		<input style="margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;" class="e8_btn_top_first" id=btnSave accessKey=S name=btnSave type=button onclick="javascript:top.location='/system/InLicense.jsp'" value="重新提交"></input>
			    	<%} %>
			    	<input style="margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;display:none;" class="e8_btn_top_first" id=btnClose accessKey=S name=btnSave type=button onclick="javascript:parent.parent.getDialog(parent).close();" value="关 闭"></input>
			    	<script type="text/javascript">
			    		try{
				    		if(parent.setTabObjName){
				    			jQuery("#btnSave").hide();
				    			jQuery("#btnClose").show();
				    		}
				    	}catch(e){}
			    	</script>
			     </td>
		    </tr>
		    </TBODY> 
		  </TABLE>
	<%}%>
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
</FORM>
</BODY>
<script language="javascript">
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
function checkcode() {
	if(!check_form(codeform,"code,license"))
	    return false;
	return true;
}
</script>
</HTML>
