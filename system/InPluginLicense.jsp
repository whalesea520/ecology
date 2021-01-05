
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="PluginLicense" class="weaver.license.PluginLicenseForInterface" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
User user = HrmUserVarify.getUser (request , response) ;
String curskin = (String)session.getAttribute("SESSION_CURRENT_SKIN");

String type=request.getParameter("type");  //type 表示插件种类  mobile代表手机版 

String message = Util.null2String(request.getParameter("message")) ;
String code = Util.null2String(request.getParameter("code")) ;
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "授权信息 - Mobile License提交" ;
String needfav ="1";
String needhelp ="";
int isIncludeToptitle = 1; 

Map license = PluginLicense.getLicenseInfo(type);
String licenseCode = (String)license.get("licensecode");

//companyname=Util.toScreen(companyname,7);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM id="codeform" style="MARGIN-TOP: 0px" name=frmMain action="PluginLicenseOperation.jsp" method=post onsubmit="return checkcode()" enctype="multipart/form-data">
<input type="hidden" name="type" value="<%=type%>">
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
	<div>
	<BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>提交</BUTTON> 
	</div><br>
  	<TABLE class=ViewForm>
    <COLGROUP><COL width="10%"> <COL width="80%"><TBODY>
    <TR class=Title>
				<TH colSpan=2>MOBILE LICENSE提交</TH>
			</TR>
    <TR class=Spacing>
		<TD class=Line1 colSpan=2></TD>
	</TR>
    <tr>
        <td>验证码:</td>
        <td class=Field><input class="InputStyle" type=password  id=code name=code maxlength=16 size=16 onchange='checkinput("code","codeimage")'><SPAN id=codeimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN><a href="\system\ModifyCode.jsp">更改验证码</a></td>
    </tr>
    <TR><TD class=Line colspan=2></TD></TR>
    <tr>
        <td>license文件:</td>
        <td class=Field><input class="InputStyle" type=file id="license" name=license size=50 onchange='checkinput("license","licenseimage")'><SPAN id=licenseimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></td>
    </tr>
    <TR><TD class=Line colspan=2></TD></TR>
    </TBODY> 
  </TABLE>
  <br>
  <br>
	<DIV>
	识别码:	<span class=fontred><%=licenseCode%></span>
	<br><br>
	提　示: 如果还没有<span class=fontred>识别码</span>,请先访问手机版以便生成<span class=fontred>识别码</span><br><br>请将<span class=fontred>公司名称</span>及<span class=fontred>识别码</span>提交给软件供应商,以获取License
	</DIV>

	<%if(!message.equals("")){%>
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="10%"> <COL width="80%"><TBODY>
    <br>
    <br>
    <br>
		<tr class=Title><TH colSpan=2>提交反馈信息</TH></tr>	
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
	    </TBODY> 
  </TABLE>	
		<DIV class=fontred>
	
		<%
		//message=0 表示License信息错误;message=1 表示成功;message=2 表示数据库连接或者执行出错;message=3 表示License文件上传出错;
		//message=4 表示License信息错误，License过期;message=5 表示License信息错误，注册用户数大于License申请人数;message=6 表示选择的License文件不正确
		if(message.equals("1")){
			message=" Success ! " ;
			message+="";
		}else if(message.equals("0")){
			message="License信息错误，请重新启动Resin尝试,并且检查License是否正确！<br>";
			message+="License message error,please try to restart Resin and check if the License is correct!";
		}else if(message.equals("2")){
			message="数据库连接或者执行失败，请按下列步骤检查：1.检查数据库服务器是否正常；2.检查数据库驱动包是否存在；3.检查weaver.properies配置信息是否正确！<br>";
			message+="Failed to Connect Data Server,please check by step as below:1.checking the Data Server is OK;2.checking the SQL driver is exist;<br>";
			message+="3.checking the message of the file 'weaver.properies' is right!";
		}else if(message.equals("3")){
			message="License文件上传出错！<br>";
			message+="License file uploading error!";
		}else if(message.equals("4")){
			message="License信息错误，License已过期！<br>";
			message+="License message error,license is overdue!";
		}else if(message.equals("5")){
			message="License信息错误，已分配用户数大于License申请人数！<br>";
			message+="License message error,the HRMs is larger than the apllied in the license!";
		}else if(message.equals("6")){
			message="没有选择正确的License文件或者License文件不存在！<br>";
			message+="Wrong choosing License file or License file is not exist!";
		}
			%>
			<%=Util.toScreen(message,7,"2")%>
			</DIV>
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
		 alert("必填信息不完整！");
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

<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/<%=curskin %>/wui_wev8.css'/>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script language="javascript"> 
var osVersion = window.navigator.userAgent.split(";")[2]; 
var osV = osVersion.substr(osVersion.length-3,3); 
if (osV >= 6) {
	addCssByStyle(" * { font-family:微软雅黑!important;}");
}


function addCssByStyle(cssString){
	var doc=document;
	var style=doc.createElement("style");
	style.setAttribute("type", "text/css");

	if(style.styleSheet){// IE
		style.styleSheet.cssText = cssString;
	} else {// w3c
		var cssText = doc.createTextNode(cssString);
		style.appendChild(cssText);
	}

	var heads = doc.getElementsByTagName("head");
	if(heads.length) {
		heads[0].appendChild(style);
	} else {
		doc.documentElement.appendChild(style);
	}
}
</script> 
</HTML>
