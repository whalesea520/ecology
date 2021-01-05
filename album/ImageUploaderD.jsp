
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import='java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,javax.servlet.http.HttpServletRequest,,weaver.hrm.*'%>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int albumId = Util.getIntValue(request.getParameter("id"));
String ancestorId = p.getAncestorId(""+albumId);
double albumSize=0.0, albumSizeUsed=0.0, albumSizeFree=0.0;
double maxTotalFileSizeByte = 0;
String maxTotalFileSize = "0";
String _albumSizeUsed = "0.00";
rs.executeSql("SELECT * FROM AlbumSubcompany WHERE subcompanyId="+ancestorId+"");
if(rs.next()){
	_albumSizeUsed = Util.null2String(rs.getString("albumSizeUsed"));
	albumSize = Double.parseDouble(rs.getString("albumSize"))/1000;
	albumSizeUsed = _albumSizeUsed.equals("") ? 0.00 : Double.parseDouble(rs.getString("albumSizeUsed"))/1000;
	albumSizeFree = albumSize-albumSizeUsed;
	maxTotalFileSizeByte = albumSizeFree*1024*1024;
	if(maxTotalFileSizeByte>0){
		maxTotalFileSize = String.valueOf(maxTotalFileSizeByte);//Util.round(String.valueOf(maxTotalFileSizeByte), 0);
	}
}

//得操作系统类型
String userAgent = request.getHeader("User-Agent");
String[] userAgentArr = Util.TokenizerString2(userAgent,";"); 
boolean isIe=true;
String osType="";
if(userAgentArr.length>=4){
  osType = userAgentArr[2];
}else{
	isIe=false;
}
osType = osType.trim();

if(osType.indexOf(' ')>-1){osType = osType.substring(0, osType.length());}
if((osType.indexOf("Mozilla/4.0 (compatible;")>-1)&&(0==osType.compareTo("Windows NT 5.0"))){osType = "Windows 2000";}
osType = Util.replace(osType,"NT5.0","2000",0);
osType = Util.replace(osType,"NT 5.0","2000",0);
osType = Util.replace(osType,"NT5.1","XP",0);
osType = Util.replace(osType,"NT 5.1","XP",0);
osType = Util.replace(osType,"NT5.2","2003",0);
osType = Util.replace(osType,"NT 5.2","2003",0);
//osType = osType.replace(')', ' ');
osType = osType.trim();

if(isIe){
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style>body{margin:0}</style>
</head>
<body>
<%//如果客户端是Windows 2003或者Windows XP操作系统下则使用UImageUploaderXPD.cab包%>
<object 
	id="UImageUploaderN" 
	type="application/x-oleobject" 
	classid="clsid:C7F9DEFD-2A17-88E8-862D-ED37D96E86B2" 
	codeBase="<%if(osType.equals("Windows 2003")||osType.equals("Windows XP")){%>UImageUploaderXPN.cab<%}else{%>UImageUploaderN.cab<%}%>#version=5,0,0,5" 
	style="width:100%;height:100%"
	VIEWASTEXT>
</object>
<script language="JavaScript">
//判断组件的版本是不是最新
if(UImageUploaderN.Version != "5.0.0.5"){
	strErrInfo = "<%=SystemEnv.getHtmlLabelName(84059,user.getLanguage())%> : ";
	strErrInfo += UImageUploaderN.Version+" ";
	strErrInfo += "\n\n<%=SystemEnv.getHtmlLabelName(84060,user.getLanguage())%>";
	alert(strErrInfo);
}

UImageUploaderN.Action = "ImageUploadDealN.jsp";
UImageUploaderN.RedirectUrl = "AlbumListTab.jsp?needrefreshtree=1&paraid=<%=albumId%>";
//UImageUploaderN.ExpandLastTimeDirectory = 1;

//设置允许的文件扩展名
//UImageUploaderN.SetAllowedExtensions("*")
//设置不允许的文件扩展名
UImageUploaderN.SetForbiddenExtensions("bmp;")

//一次允许上传的最大文件个数
UImageUploaderN.MaxFileNum = 100
//指定一次上传总共允许文件大小(bytes)
try{
	UImageUploaderN.MaxTotalFileSize = "<%=maxTotalFileSize%>";
}catch(e){
	UImageUploaderN.MaxTotalFileSize = -1;
}

//设置授权信息
UImageUploaderN.SetLicenseSN("25HAB6GRL1H9DYF8-P69P5CLCLCLCP1P2-G81FXHEHFP838WDU-JCJ2C1XBGZ1Y6FZ8");
UImageUploaderN.CompanyName = "<%=SystemEnv.getHtmlLabelName(128189,user.getLanguage())%>";

UImageUploaderN.ListViewIconStyle = 32777;
UImageUploaderN.EnableEditDescription = 0;
UImageUploaderN.ShowEditButton = 0;

//绑定表单变量。服务端将接收该变量
//UImageUploaderN.AddField('FormFieldName1', 'FormFieldValue1')
//UImageUploaderN.AddField('FormFieldName2', 'FormFieldValue2')
UImageUploaderN.AddField('parentId', '<%=albumId%>');
</script>
</body>
</html>

<%}else { 
   response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=20001");
%>
<%} %>
