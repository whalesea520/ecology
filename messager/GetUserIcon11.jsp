
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
 <%
 String loginid = Util.null2String(request.getParameter("loginid"));
 String isclosed = Util.null2String(request.getParameter("isclosed"));

 
 String defaultUrl="/messager/images/logo_big_wev8.jpg";
 String sysUrl="";
 
 String strSql="select resourceimageid,messagerurl from hrmresource where loginid='"+loginid+"'"; 
 rs.executeSql(strSql);
 if(rs.next()){
	 String messagerurl=Util.null2String(rs.getString("messagerurl"));
	 int resourceimageid=Util.getIntValue(rs.getString("resourceimageid"),0);
	 
	 if(!"".equals(messagerurl)) {
		 defaultUrl=messagerurl;
	 }
	 
	 if(resourceimageid!=0) {
		 sysUrl="/weaver/weaver.file.FileDownload?fileid="+resourceimageid;
	 }
	 
	 
 }
 %>
<HTML>
	<HEAD>	
		<LINK REL="stylesheet" type="text/css" HREF="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/messager/jquery_wev8.js"></script>
	</HEAD>
	<body>
	<form name="frmMain" method="post" action="GetUserIconOpreate.jsp" enctype="multipart/form-data">
		<input name="loginid" value="<%=loginid%>" type="hidden">
		<input name="method" value="usericon" type="hidden">
		<table height="100%" width="100%" align="center"  valign="top" style="background:#eeeeff">			
			<tr>
			<td colspan="3" height="20px">
				<div id="divSelected"><%=SystemEnv.getHtmlLabelName(24502, user.getLanguage())%>:<input class="url" id="fileSrcUrl"  type="file" name="fileSrcUrl"></div>
				<div  id="divInfo" style="display:none"> <%=SystemEnv.getHtmlLabelName(24503, user.getLanguage())%></div>		
			</td>
			</tr>
			<tr>
				<td   id="divLeft" style="color:#666666;" width="80%" valign="top">	
									  												
						<iframe id="ifrmSrcImg" 
						src=""
						 style="border:1px solid #DDDDDD;"  height="96%" width="100%"	BORDER="0" 
						 FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="auto">
						</iframe>
				</td>
				<td   width="4" id="divRight" valign="top">&nbsp;</td>
				<td   id="divRight" valign="top" style="color:#666666;"  width="22%">		
								
						<div id="divSelect">							
							<div id="divTargetImg" style="border:1px solid #DDDDDD;height:102px;width:102px;background:#ffffff;overflow:auto"></div>
							<br>
							
							x1:<input name="x1" style="width:25px">&nbsp;&nbsp;
							y1:<input name="y1"  style="width:25px">
							<br><br>
							x2:<input name="x2"  style="width:25px">&nbsp;&nbsp;
							x2:<input name="y2"  style="width:25px">
							
							<br><br>
							<button onclick="doApply()"><%=SystemEnv.getHtmlLabelName(24504, user.getLanguage())%></button><br><br>
							<button  onclick="reSelect()"><%=SystemEnv.getHtmlLabelName(24505, user.getLanguage())%></button>
						</div>			
				</td>
			</tr>	
		<table>
		</form>
	</body>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
	$(document).ready( function() {	
		$("#fileSrcUrl").change( function() {
			alert("111:"+this.value)
		}); 			
	});

	
	function doApply(){
		frmMain.submit();
	}

	function reSelect(){
		window.location.reload();
	}
</script>
<%
 if("true".equals(isclosed)){
	out.println("<script>parent.imgWindow.hide();parent.reloadMyLogo();window.location='GetUserIcon.jsp?loginid="+loginid+"'</script>"); 
 }
  %>