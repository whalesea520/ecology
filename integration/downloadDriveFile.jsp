<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<%
if(!HrmUserVarify.checkUserRight("intergration:SAPsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
%>
<html>

 <head>
 	<title><%= SystemEnv.getHtmlLabelName(82620 ,user.getLanguage()) %></title><!-- 驱动下载 -->
 
 
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>

<style type="text/css">

.container{
	margin-top:10px;
	margin-left:20px;
}

#stepTitle {
	font-size:18px;
	color:#242424;
	vertical-align:middle;
}

.inner_tab {
	width:714px;
	border-collapse:collapse;
}
.inner_tab td{
	border:1px solid #eaeaea;
}
.osInfo{
	height:63px;
	vertical-align:middle;
}

.coldesc{
	width:178px;
	vertical-align:middle;
	text-align:center;
}
.fileInfo{
	height:45px;
}

.fileInfo td{
	vertical-align:middle;
	text-align:center;
}
.fileInfo .title{
	background-color:#fbfbfb;
}

.filePath{
	color:#f47c00;
}

A:link {
 color: #008ef8;
}

.btn_downloadDriver{
	background-color:#008ef5;
	cursor:pointer;
    -webkit-border-radius: 30px;
    -moz-border-radius: 30px;
    border-radius: 30px;
}

.big {
	border:none;
    padding-top: 6px;
    padding-bottom: 8px;
    padding-left:15px;
    padding-right:22px;
    height:40px;
    
}

.big font{
	vertical-align:text-top;
	font-size:13px;
}
.stepTileRow{
	height:60px;
	vertical-align:middle;
}

.download_Img{
	vertical-align:text-top;
}

</style>

<script>
function downloadDriverFile(url){
	window.location.href=url;	
}

</script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	Properties props = System.getProperties();
	String arch =  props.getProperty("os.arch");
	String name = props.getProperty("os.name");
	String javapath = props.getProperty("java.home");
%>
<div class="zDialog_div_content">
	<table class="container">
		<tr class="stepTileRow">
			<td width="50px"><img src="/integration/images/drv_1_wev8.png" style="vertical-align:middle;"></img></td>
			<td id="stepTitle"><%=SystemEnv.getHtmlLabelName(82619 ,user.getLanguage()) %></td><!-- 操作系统信息及驱动包文件 -->
		</tr>
		<tr>
			<td></td>
			<td> 
				<table class="inner_tab">
					<tr class="osInfo">
						<td class="coldesc"><%=SystemEnv.getHtmlLabelName(82621 ,user.getLanguage()) %></td><!-- 服务器操作系统信息 -->
						<td align="left" valign="middle">
							<% if(name.toLowerCase().contains("window")){ %>
							&nbsp;&nbsp;&nbsp;&nbsp;<img style="vertical-align:middle" src="/integration/images/drv_windows_wev8.png"/><span>&nbsp;&nbsp;<%= name %>&nbsp;&nbsp;<%=arch  %>&nbsp;</span>
							<% }else if(name.toLowerCase().contains("linux")){ %>
							&nbsp;&nbsp;&nbsp;&nbsp;<img style="vertical-align:middle" src="/integration/images/drv_redhat_wev8.png"/>&nbsp;&nbsp;<%= name %>&nbsp;&nbsp;<%=arch  %>&nbsp;
							<% } %>
						</td>
					</tr>
					<tr class="osInfo">
						<td class="coldesc"><%=SystemEnv.getHtmlLabelName(82600 ,user.getLanguage()) %></td><!-- 需下载文件  -->
						<td>&nbsp;&nbsp;&nbsp;&nbsp;
							<% 
		  						if(name.toLowerCase().contains("window")){
		  							if(arch.toLowerCase().contains("amd64")){
		  								out.println("<a style='cursor:pointer;' href='/integration/sapjar/sapjco21P_10-20007305.zip'>Windows 64bit sapjco-ntamd64</a>");
		  					%>
		  						&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_downloadDriver big" id="btn_downloadDriver" onclick="downloadDriverFile('/integration/sapjar/sapjco21P_10-20007305.zip')" >
		  							<img src="/integration/images/drv_download_wev8.png" class="download_Img"/><font style="color:#fff">&nbsp;<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %></font><!-- 下载 -->
		  						</span>			
		  					<%
		  							}else if(arch.toLowerCase().contains("ia64")){
		  								out.println("<a style='cursor:pointer;' href='/integration/sapjar/sapjco21P_10-20007306.zip'>Windows 64bit sapjco-ntia64</a>");
		  					%>
		  						&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_downloadDriver big" id="btn_downloadDriver" onclick="downloadDriverFile('/integration/sapjar/sapjco21P_10-20007306.zip')" >
		  							<img src="/integration/images/drv_download_wev8.png" class="download_Img"/><font style="color:#fff">&nbsp;<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %></font><!-- 下载 -->
		  						</span>			
		  					<%
		  							}else{
		  								out.println("<a style='cursor:pointer;' href='/integration/sapjar/sapjco21P_10-20007304.zip'>Windows 32bit</a>");
		  					%>
		  						&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_downloadDriver big" id="btn_downloadDriver" onclick="downloadDriverFile('/integration/sapjar/sapjco21P_10-20007304.zip')" >
		  							<img src="/integration/images/drv_download_wev8.png" class="download_Img"/><font style="color:#fff">&nbsp;<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %></font><!-- 下载 -->
		  						</span>			
		  					<%
		  							}
		  						}else if(name.toLowerCase().contains("linux")){
		  							if(arch.toLowerCase().contains("amd64")){
		  								out.println("<a style='cursor:pointer;' href='/integration/sapjar/sapjco21P_10-20007300.zip'>Linux on x86_64 64bit</a>");
		  					%>
		  						&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_downloadDriver big" id="btn_downloadDriver" onclick="downloadDriverFile('/integration/sapjar/sapjco21P_10-20007300.zip')" >
		  							<img src="/integration/images/drv_download_wev8.png" class="download_Img"/><font style="color:#fff;">&nbsp;<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %></font><!-- 下载 -->
		  						</span>			
		  					<%
		  							}else if(arch.toLowerCase().contains("ia64")){
		  								out.println("<a style='cursor:pointer;' href='/integration/sapjar/sapjco21P_10-10002885.zip'>Linux on IA-64 64bit</a>");
		  					%>
		  						&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_downloadDriver big" id="btn_downloadDriver" onclick="downloadDriverFile('/integration/sapjar/sapjco21P_10-10002885.zip')" >
		  							<img src="/integration/images/drv_download_wev8.png" class="download_Img"/><font style="color:#fff">&nbsp;<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %></font><!-- 下载 -->
		  						</span>			
		  					<%
		  							}else{
		  								out.println("<a style='cursor:pointer;' href='/integration/sapjar/sapjco21P_10-20007301.zip'>Linux on IA32 32bit</a>");
		  					%>
		  						&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_downloadDriver big" id="btn_downloadDriver" onclick="downloadDriverFile('/integration/sapjar/sapjco21P_10-20007301.zip')" >
		  							<img src="/integration/images/drv_download_wev8.png" class="download_Img"/><font style="color:#fff">&nbsp;<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %></font><!-- 下载 -->
		  						</span>			
		  					<%
		  							}
		  						}
		  					 %>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
		<td colspan="2" height="10px"></td>
		</tr>
		<tr class="stepTileRow"> 
			<td><img src="/integration/images/drv_2_wev8.png" style="vertical-align:middle;"></img></td>
			<td id="stepTitle"><%=SystemEnv.getHtmlLabelName(82623 ,user.getLanguage()) %></td><!-- 解压文件包安装以下文件 -->
		</tr>
		<tr>
			<td></td>
			<td>
				<table class="inner_tab">
					<tr class="fileInfo">
						<td rowspan="3" class="coldesc"><%=SystemEnv.getHtmlLabelName(82574,user.getLanguage()) %></td><!-- 驱动包的安放位置 -->
						<td class="title"><%=SystemEnv.getHtmlLabelName(17517,user.getLanguage()) %></td><!-- 文件名称 -->
						<td class="title"><%=SystemEnv.getHtmlLabelName(82622,user.getLanguage()) %></td><!-- 请存放到以下路径 -->
					</tr>
					<tr class="fileInfo">
						<td>sapjco.jar</td>
						<td class="filePath">
							<% out.println(GCONST.getRootPath()+"WEB-INF\\lib"); %>
						</td>
					</tr>
					<tr class="fileInfo">
						<% if(name.toLowerCase().contains("window")){ %>
						<td>librfc32.dll、sapjcorfc.dll</td>
						<% }else if(name.toLowerCase().contains("linux")){ %>
						<td>librfccm.so、libsapjcorfc.so</td>
						<% } %>
						<% if(name.toLowerCase().contains("window")){ %>
						<td class="filePath">
							<% out.println("C:\\Windows\\System32"); %>
						</td>
						<% }else if(name.toLowerCase().contains("linux")){ %>
						<td class="filePath">
							<% out.println(javapath+"/lib/amd64"); %>
						</td>
						<% } %>
					</tr>
				</table>
			</td>
		</tr>
	</table>
  	</div>
  </body>
</html>