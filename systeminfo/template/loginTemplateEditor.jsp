<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
int templateId = Util.getIntValue(request.getParameter("loginTemplateId"));
String templateType="",loginTemplateTitle="",imageId="";
String isCurrent="0";
loginTemplateTitle = Util.null2String(request.getParameter("loginTemplateTitle"));
templateType = Util.null2String(request.getParameter("templateType"));

String init =Util.null2String(request.getParameter("init"));
// 初始化数据
if(init.equals("true")){
	String clearSql = "drop table SystemLoginTemplateTemp ";	
	rs.executeSql(clearSql);
	String copySql = "SELECT * into SystemLoginTemplateTemp from SystemLoginTemplate where loginTemplateId="+templateId;	
	if("oracle".equals((rs.getDBType())))
		copySql = "create table SystemLoginTemplateTemp as select * from SystemLoginTemplate where loginTemplateId="+templateId;
	rs.executeSql(copySql);
}

String sqlLoginTemplate = "SELECT * FROM SystemLoginTemplateTemp WHERE loginTemplateId="+templateId+"";	
rs.executeSql(sqlLoginTemplate);
if(rs.next()){
	if(templateType.equals(""))	templateType = rs.getString("templateType");
	if(loginTemplateTitle.equals(""))	loginTemplateTitle = rs.getString("loginTemplateTitle");
	imageId = rs.getString("imageId");
	isCurrent=rs.getString("isCurrent");
	
}
if("site".equals(templateType)){
	response.sendRedirect("/systeminfo/template/loginTemplateEdit.jsp?templateId="+templateId);
	return;
} else if("H2".equals(templateType)) {
	response.sendRedirect("/wui/theme/ecology7/page/loginEditor.jsp?templateId="+templateId);
    return;
} else if("E8".equals(templateType)) {
	response.sendRedirect("/wui/theme/ecology8/page/loginEditor.jsp?templateId="+templateId);
    return;
} 

String imagePath ="";
if(imageId.indexOf("/")==-1){
	imagePath = "/LoginTemplateFile/"+imageId;
}else{
	imagePath = imageId;
}
String titlename="";
%>

<html>
<head>
<title><%=loginTemplateTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</head>


<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" margin=0 oncontextmenu="return false;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%" style='display:none'>
		<tr>
			<td width="75px">
								
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>" class="e8_btn_top" onclick="doPreview()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32599,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAndEnable()" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAs()" />
			
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave()" />
			<%if(templateId!=1 && templateId!=2&&!"1".equals(isCurrent)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel()" />
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%
if(templateType.equals("V")){
%>
<table width="100%" height=100% border="0" cellspacing="0" cellpadding="0"  bgcolor="#FFFFFF">
<tr> 
<td width="489" class='eidtor' tbname='systemlogintemplate' field='imageid' dfvalue="/images_face/login/left_wev8.jpg" type='background-image' rowspan="2" valign="top" style="<%if(imageId.equals("")){out.println("background-image:url(/images_face/login/left_wev8.jpg)");}else{out.println("background-image:url("+imagePath+")");}%>"></td>
<td valign="top"> 
  <div align="left">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="220">&nbsp;</td>
	  </tr>
	  <tr>
		<td height="217">
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="217"  background="/images_face/login/tablebg_wev8.jpg">
	<form name=form1 action= "VerifyLogin.jsp"  method=post onSubmit="return checkall();">
			  <tr> 
				<td height="85">&nbsp;</td>
				<td height="85" valign="bottom" style="color:#FF0000;font-size:9pt"><%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>...</td>
			  </tr>
			  <tr> 
				<td height="20" width="150">
				  <table width="150" border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td></td>
					</tr>
				  </table>
				</td>
				<td height="20"> 
				  <input type="text" name="loginid" class="stedit" size="10">
				</td>
			  </tr>
			  <tr> 
				<td colspan="2" height="18">&nbsp; </td>
			  </tr>
			  <tr> 
				<td height="20" width="150"></td>
				<td height="20"> 
				  <input type="password" name="userpassword" class="stedit" size="10" >
				</td>
			  </tr>
			  <tr> 
				<td colspan="2" height="18">&nbsp; </td>
			  </tr>
			  <tr> 
				<td width=150 height="20">&nbsp;</td>
				<td height="20"> 
				  <input type="button" class="submit" name="Submit" value="&gt;&gt; <%=SystemEnv.getHtmlLabelName(674,user.getLanguage())%>">
				</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
			  </tr>
			</form>
		  </table>
		</td>
	  </tr>
	  <tr>
		<td height="19" background="/images_face/login/url_wev8.jpg">&nbsp;</td>
	  </tr>
	  <tr>          
		  <td>	
			 <table width="100%" height=100% border="0" cellspacing="20" cellpadding="0"  bgcolor="#FFFFFF">
			 <tr> 
			 <td><span style="line-height: 20px"> <font style="color:#990000;font-weight: bold"><%=SystemEnv.getHtmlLabelName(82060,user.getLanguage())%></font><%=SystemEnv.getHtmlLabelName(84226,user.getLanguage())%><font style="color:#5F7DD0;font-weight: bold">IE5.0<%=SystemEnv.getHtmlLabelName(84227,user.getLanguage())%></font> <%=SystemEnv.getHtmlLabelName(84228,user.getLanguage())%> <font style="color:#5F7DD0;font-weight: bold">Microsoft <%=SystemEnv.getHtmlLabelName(84229,user.getLanguage())%>(VM)</font>；<%=SystemEnv.getHtmlLabelName(84230,user.getLanguage())%>5.0<%=SystemEnv.getHtmlLabelName(84227,user.getLanguage())%>；Microsoft <%=SystemEnv.getHtmlLabelName(84229,user.getLanguage())%>(VM)<%=SystemEnv.getHtmlLabelName(84231,user.getLanguage())%><a href="/weaverplugin/msjavx86.exe"><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline"><%=SystemEnv.getHtmlLabelName(22012,user.getLanguage())%></font></a><%=SystemEnv.getHtmlLabelName(84232,user.getLanguage())%></span>
			 </td>
			 </tr>
			 </table>
		  </td>
	  </tr>
	</table>
  </div>
</td>
</tr>
</table>
<%
}else{
%>	
<form name=form1 action= "VerifyLogin.jsp"  method=post onSubmit="return checkall();">


<table width="100%" cellspacing="0" cellpadding="0">
<tr>
<td align="right"><img src="/images_face/login/weaverlogo_wev8.gif" width="325" height="50"></td>
</tr>
<tr>
<td class="eidtor" tbname='systemlogintemplate' field='imageid' dfvalue="/images_face/login/loginLanguage_wev8.jpg" type='background-image' style="height:370px;<%if(imageId.equals("")){out.println("background-image:url(/images_face/login/loginLanguage_wev8.jpg)");}else{out.println("background-image:url("+imagePath+")");}%>">
 <table style="margin:100px 0 0 570px;border-collapse:collapse;color:white"><tr><td>&nbsp;<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>...</td></tr></table>
 <input name="loginid" type="text" size="15" style="margin:0px 0 0 570px"><br/>
 <input name="userpassword" type="password" size="15" style="margin:10px 0 0 570px"><br/>
 <button type="" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url(/images_face/login/dengru_wev8.gif); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 78px; CURSOR: hand; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 28px;margin:25px 0 0 608px">
 </td>
</tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="2%" valign="top"><img src="/images_face/login/copyright_wev8.gif" width="449" height="80"></td>
<td width="98%">
<table width="97.5%"  border="0" cellspacing="0" cellpadding="0">
  <tr><td>
		<span style="line-height: 20px; font-size:9pt;" cellspacing="50" cellpadding="50"> <font style="color:#990000;font-weight: bold"><%=SystemEnv.getHtmlLabelName(82060,user.getLanguage())%></font><%=SystemEnv.getHtmlLabelName(84226,user.getLanguage())%><font style="color:#5F7DD0;font-weight: bold">IE6.0</font> <%=SystemEnv.getHtmlLabelName(84228,user.getLanguage())%> <font style="color:#5F7DD0;font-weight: bold">Microsoft <%=SystemEnv.getHtmlLabelName(84229,user.getLanguage())%>(VM)</font>；<%=SystemEnv.getHtmlLabelName(84230,user.getLanguage())%>6.0；Microsoft <%=SystemEnv.getHtmlLabelName(84229,user.getLanguage())%>(VM)<%=SystemEnv.getHtmlLabelName(84231,user.getLanguage())%><a href="/weaverplugin/msjavx86.exe"><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline"><%=SystemEnv.getHtmlLabelName(22012,user.getLanguage())%></font></a><%=SystemEnv.getHtmlLabelName(84232,user.getLanguage())%></span>
  <br> 
</td></tr>
</table>
</td>
</tr>
</table>

</form>
<%}%>
<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();		
			    
		//$(".eidtor").bind("")
		$('.eidtor').hover(
			function(){
				$(this).css("border","1px dashed red");
				$(this).css("cursor","pointer");
				$(this).unbind();
				$(this).bind("click",function(){
					var type = $(this).attr("type");
					showImageDialog($(this));
					event.stopPropagation();
					return false;
				})
			}, 
			function(){
				$(this).css("border","0px dashed red");
				$(this).css("cursor","normal");
			});
	})
	
	/*图片文件选择框回调函数*/
function doImageDialogCallBack(obj,datas){
	var	path=datas.id;
	
	if(path==undefined){
		path=''
	}
	var type = $(obj).attr("type");
	
	if(path==''){
		if(type=="src"){
			$(obj).attr("src",$(obj).attr("dfvalue"));
		}else{
			$(obj).css("background-image","url('"+$(obj).attr("dfvalue")+"')")
		}
	}else{
		if(type=="src"){
			$(obj).attr("src",path);
		}else{
			$(obj).css("background-image","url('"+path+"')")
		}
	}
	
	updateTempData($(obj).attr('tbname'),$(obj).attr("field"),path);
}

/*打开图片文件选择框*/
function showImageDialog(target){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;   //传入当前window
 	dialog.Width = top.document.body.clientWidth-100;
 	dialog.Height = top.document.body.clientHeight-100;
 	dialog.maxiumnable=true;
 	dialog.callbackfun=doImageDialogCallBack;
 	dialog.callbackfunParam=target;
 	dialog.Modal = true;
 	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32467,user.getLanguage())%>"; 
 	dialog.URL = "/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp?isDialog=1";
 	dialog.show();
	
}
	
	//获取系统图片路径
	function getImagePath(){
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
		var src = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp?isDialog=1","","addressbar=no;status=0;dialogHeight=650px;dialogWidth=860px;dialogLeft="+iLeft+";dialogTop="+iTop+";resizable=0;center=1;");
		return src;
	}
	
	function updateTempData(tbname,field,value){
		$.post("/systeminfo/template/loginTemplateTempOperation.jsp",{method:'update',tbname:tbname,field:field,value:value},function(){
		})
	}
	function setWindowSize(){
		var oFrm=parent.document.getElementById("tabcontentframe");
		parent.document.body.style.height = 500;
		oFrm.style.height = 400;
		$(".demo2",parent.document).css("height","500px")
		parent.document.body.style.height = document.body.scrollHeight
		var oFrm=parent.document.getElementById("tabcontentframe");
		oFrm.style.height=document.body.scrollHeight;
		$(".demo2",parent.document).css("height",(oFrm.style.height+50)+"px")
		
	}
	
	function doPreview(){
		//alert("/systeminfo/template/loginTemplatePreview.jsp?loginTemplateId=<%=templateId%>&tmpdata=Tmp")
		var menuStyle_dialog = new window.top.Dialog();
		menuStyle_dialog.currentWindow = window;   //传入当前window
	 	menuStyle_dialog.Width = 700;
	 	menuStyle_dialog.Height = 500;
	 	menuStyle_dialog.maxiumnable=true;
	 	menuStyle_dialog.Modal = true;
	 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
	 	menuStyle_dialog.URL = "/systeminfo/template/loginTemplatePreview.jsp?loginTemplateId=<%=templateId%>&tmpdata=Temp"
	 	menuStyle_dialog.show();
		
	}
	
	function doSave(){
		$.post("/systeminfo/template/loginTemplateTempOperation.jsp",{method:'commit',loginTemplateId:'<%=templateId%>'},function(){
			
			parent.parent.Dialog.close()
		})
		
	}
	
	function doSaveAndEnable(){
		$.post("/systeminfo/template/loginTemplateTempOperation.jsp",{method:'commit&enable',loginTemplateId:'<%=templateId%>'},function(){
			top.getDialog(parent).currentWindow.document.location.reload();	
			parent.parent.Dialog.close()

		})
	}
	
	
function doSaveAs(){
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 400;
 	menuStyle_dialog.Height = 150;
 	menuStyle_dialog.maxiumnable=false;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
 	menuStyle_dialog.URL = "/systeminfo/template/loginTemplateSaveAs.jsp?from=dialog&templateid=<%=templateId%>";
 	menuStyle_dialog.show();
}


function doDel(e){
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){
		$.post("/systeminfo/template/loginTemplateTempOperation.jsp"
		,{method:'delete',loginTemplateId:<%=templateId%>},function(data){
			top.getDialog(parent).currentWindow.document.location.reload();
			dialog = top.getDialog(parent);
			dialog.close();
			
		})
	})
	
}
</script>
</body>
</html>
