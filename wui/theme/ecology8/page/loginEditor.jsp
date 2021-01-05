
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.Util,weaver.general.MathUtil,weaver.general.GCONST,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>

<%@ page import="weaver.hrm.settings.BirthdayReminder" %>
<%@page import="java.util.List"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<%@page import="weaver.login.VerifyLogin"%>

<!DOCTYPE HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<SCRIPT type=text/javascript src="/wui/common/jquery/jquery.min_wev8.js"></SCRIPT>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>

<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>

<link href="/css/commom_wev8.css" type="text/css" rel="stylesheet">




<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">

<%



String titlename="";
String logintype = Util.null2String(request.getParameter("logintype")) ;
String templateId = Util.null2String(request.getParameter("templateId"));
String templateType = "";
String imageId = "";
String imageId2 = "";
String loginTemplateTitle="";
String backgroundColor = "";
String backgroundUrl="";
String logo="";
int extendloginid=0;
String isCurrent="0";
String recordcode="";
String sqlLoginTemplate1 = "SELECT * FROM SystemLoginTemplateTemp WHERE loginTemplateid='" + templateId + "'";  

rs.executeSql(sqlLoginTemplate1);
if(rs.next()){
    templateId=rs.getString("loginTemplateId");
    templateType = rs.getString("templateType");
    imageId = rs.getString("imageId");
    imageId2 = rs.getString("imageId2");
    loginTemplateTitle = rs.getString("loginTemplateTitle");
    backgroundColor = rs.getString("backgroundColor");
    isCurrent = rs.getString("isCurrent");
	recordcode = rs.getString("recordcode");
}
if(!"".equals(imageId))
	backgroundUrl=imageId;
else{
	backgroundUrl = "images/login/bg_wev8.jpg";
}
if(!"".equals(imageId2)){
	logo = imageId2;
}else{
	logo = "images/login/logo_wev8.png";
}
%>

<script type="text/javascript">
$(document).ready(function() {
          
	$("label.overlabel").overlabel();
});

String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

</script>

<STYLE TYPE="text/css">
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,select{        
    font-size:12px;
}


body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,select{        
    font-size:11px;
    /*font-family:"微软雅黑","宋体"!important;*/ 
}

.loginContainer{
	width:300px;
	height:330px;
	background:url(images/login/login-bg_wev8.png);
}

.loginTitle{
	color:#828282;
	font-weight:500px;
	font-size:18px;
	padding-top:10px;
	padding-bottom:20px;
}

/*For slide*/
.slideDivContinar { height: 436px; width: 100%; padding:0; margin:0; overflow: hidden }
.slideDiv {height:436px; width: 100%;top:0; left:0;margin:0;padding:0;}


/*For Input*/
.inputforloginbg{ width:172px;height:21px;border:none;}
.inputforloginbg input{border:none;height:15px;background:none;}

.lgsm {width:124px;height:36px;background:url(/wui/theme/ecology8/page/images/login/btn_wev8.png) 0px 0px no-repeat; border:none;}
.lgsmMouseOver {width:124px;height:36px;background:url(/wui/theme/ecology8/page/images/login/btn_wev8.png) 0px 0px no-repeat; border:none;}

.crossNav{width:100%;height:30px;position:absolute;margin-top:105px;padding-left:30px;padding-right:30px;}


label.overlabel {
	position:absolute;
	padding-left:5px;
	z-index:1;
	color:#999;
	font-size:14px;
	line-height:36px;
  }

  .input_out{
	height:36px;
	width:248px;
  }

  .input_inner{
	height:36px;
	width:248px;
	margin-top:1px;
	font-size:14px;
	
  }
  
</STYLE>
</head>
<body style="padding:0;margin:0;margin:0;padding:0;" scroll="no">

<table id="topTitle" cellpadding="0" cellspacing="0" width="100%" style='display:none'>
	<tr>
		<td width="75px">
							
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>" class="e8_btn_top" onclick="doPreview()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32599,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAndEnable()" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAs()" />
			
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave()" />
			<%if(Util.getIntValue(templateId)!=1 && Util.getIntValue(templateId)!=2&&!"1".equals(isCurrent)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel()" />
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(84255,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="w-all h-all center eidtor" tbname='systemlogintemplate' field='imageid' type='background-image' dfvalue="images/login/bg_wev8.jpg"  style="background:url('<%=backgroundUrl %>') center bottom;" type="background-image">
	<div class="h-150">&nbsp;</div>
	<div class="w-300 center " style="padding-left:45px;">
		<div  >
			<img class="eidtor" tbname='systemlogintemplate' field='imageid2' dfvalue="images/login/logo_wev8.png" type='src'  style="max-width:400px;max-height:150px" src="<%=logo %>">
		</div>
		<div style="height:35px">&nbsp;</div>
		
		<div class="h-15">
			<div class="p-l-30 font14 colorfff left w-150" id="messageDiv" style="text-align: left;">
			&nbsp;
				
			</div>
			<%if(false){%>
				<div class="left w-20" id="qrcodeDiv"><img id="qrcode" class="hand"  src="images/login/qrcode_wev8.png"></div>
				<div class="last p-r-30 "  style="" id="langDiv">
				<span class="hand" id="" style="color:#D5E7E4"><%=SystemEnv.getHtmlLabelName(33597,user.getLanguage()) %>▼</span>
			
				
				<ul class="absolute hide" id="syslangul">
						<%
						while(LanguageComInfo.next()){
							%>
							<li lang="<%=LanguageComInfo.getLanguageid() %>"><%=LanguageComInfo.getLanguagename() %></li> 
							<%
						}
					%>
				</ul>
				</div>
			
			<%}else{ %>
				<div class="last hide w-20 p-r-30" id="qrcodeDiv"><img id="qrcode" class="hand"  src="images/login/qrcode_wev8.png"></div>
				
			<%} %>
			
		
			<div class="clear" style="height: 0px;">&nbsp;</div>
			
		</div>
		
                
		<div id="normalLogin" class="p-l-5">
			<table width="280px;">
				
				<tr>
					<td style="background: url('images/login/input_wev8.png');height:45px;">
					<div class="relative " style="height:45px;">
					   <img class="absolute" style="top:10px;left:20px;" src="images/login/username_wev8.png">	
					   <label for="loginid" class="overlabel"><%=SystemEnv.getHtmlLabelName(20970,user.getLanguage()) %></label>
					   <input class="input" type="hidden" name="loginid" id="loginid" style="">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="h-10"></td>
				</tr>
				<tr>
					<td style="background: url('images/login/input_wev8.png');height:45px;">
					<div class="relative " style="height:45px;">
					   <img class="absolute" style="top:10px;left:20px;" src="images/login/password_wev8.png">	
					   <label for="userpassword" class="overlabel"><%=SystemEnv.getHtmlLabelName(83865,user.getLanguage()) %></label>
					   <input class="input" style=""  name="userpassword" id="userpassword" type="hidden">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="h-10"></td>
				</tr>
			
				<tr style="display:none">
					<td style="background: url('images/login/input_wev8.png');height:45px;">
					<div class="relative " style="height:45px;">
					   <img class="absolute" style="top:10px;left:20px;" src="images/login/password_wev8.png">	<input class="input" style=""  name="" id="" type="">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="h-50">
					</td>
				</tr>
				<tr style="">
					<td >
						<input class=" hand" type="submit" name="submit" id="login" value=""  tabindex="3" style="background: url('images/login/btn_wev8.png');height:45px;width:280px;border:0px;">
					</td>
				</tr>
			</table>
			
		</div>
		
		<div id="qrcodeLogin" class="hide">
			<div class="h-10">&nbsp;</div>
			<div class="center" >
				<div id="qrcodeImg" class="center relative"  style="width:145px;height:145px;background: url(images/login/qrcodebg_wev8.png);background-position: center center;background-repeat: no-repeat"></div>
			</div>
			<div class="h-10">&nbsp;</div>
			<div style="color:#D5E7E4">
				<%=SystemEnv.getHtmlLabelName(84272,user.getLanguage()) %>
			</div>
			<div class="h-10">&nbsp;</div>
			<div>
				<input type="button" name="backbtn" id="backbtn" value="" class="hand"  style="background: url('images/login/back_wev8.png');height:36px;width:154px;border:0px;">
			</div>
		</div>
	   </form>
	</div>
	<div class="e8login-recordcode">
		<style type="text/css">
			.e8login-recordcode {
				height:60px;
				position:absolute;
				bottom:0;
				width:100%;
				left:0;
				text-align:center;
				line-height: 60px;
			}
			.e8login-recordcode-view {
				height: 40px;
				min-width: 600px;
				text-align: center;
				line-height: 40px;
				color: #FFFFFF;
				display: inline-block;
				vertical-align: middle;
				cursor: pointer;
				position: relative;
			}
			.e8login-recordcode-view:hover{
				border: 1px dashed #FF0000;
			}
			.e8login-recordcode-view-edit {
				height: 40px;
				width: 100%;
				text-align: center;
				line-height: 40px;
				display: inline-block;
				vertical-align: middle;
				cursor: pointer;
				position: absolute;
			}
			.e8login-recordcode-view-edit a{
                color: #d5e7e4;
            }
			.e8login-recordcode-view-tip {
				height: 40px;
				width: 100%;
				text-align: center;
				line-height: 40px;
				display: inline-block;
				vertical-align: middle;
				cursor: pointer;
				position: absolute;
				display: none;
			}
		</style>
		<div title="点击设置备案号" onclick="onEdit(event)" class="e8login-recordcode-view">
			<div id="e8login_recordcode_view" class="e8login_recordcode_view_edit">
				<%=recordcode%>
			</div>
			<div id="e8login_recordcode_view_tip" class="e8login-recordcode-view-tip">点击设置备案号</div>
		</div>
		<script type="text/javascript">
			$(document).ready(function(){  
		        var recordcode = $("#e8login_recordcode_view").html();;
				if(!recordcode){
					$("#e8login_recordcode_view_tip").show();
				}
		    });  
			function onEdit(e){
				e.stopPropagation();
				var recordcode = $.trim($("#e8login_recordcode_view").html());
				if(window.top.Dialog){
					calendarDialog = new window.top.Dialog();
				} else {
					calendarDialog = new Dialog();
				};
				calendarDialog.URL ="/wui/theme/ecology8/page/recordcode.jsp?languageid=<%=user.getLanguage()%>";
				calendarDialog.initData = {
					recordcode: recordcode
				};
				calendarDialog.Width = 680;
				calendarDialog.Height = 400;
				calendarDialog.checkDataChange = false;
				calendarDialog.Title="备案号设置";
				calendarDialog.show();
				calendarDialog.callback = function(recordcode){
					if(recordcode){
						$("#e8login_recordcode_view_tip").hide();
					}else{
						$("#e8login_recordcode_view_tip").show();
					}
					$("#e8login_recordcode_view").html(recordcode);
					updateTempData("systemlogintemplate","recordcode",recordcode);
				}
			}
			
		</script>
	</div>
</div>

<!--detection the system font start -->
<DIV style="LEFT: 0px; POSITION: absolute; TOP: 0px;"><OBJECT ID="sfclsid" CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" WIDTH="0px" HEIGHT="0px"></OBJECT></DIV>

<style type="text/css">
	html,body{
		height:100%;
	}
	.input{
		left:50px;
		top:10px;
		height:25px;
		width:210px;
		background:transparent!important;
		color:#ffffff!important;
		border:0px;
		position:absolute;
		font-size: 15px;
		outline:none;
	}
	.langOver{
		color:#797E81!important;
	}
	

	.overlabel{
		position:absolute;
		z-index:1;
		font-size:14px;
		left:50px;
		font-size:14px;
		color:#D5E7E4!important;
		line-height: 40px!important;
		
	}
	#qrcodeImg table{
		position:absolute;
		top:10px;
		left: 10px;
	}
	#syslangul{
		width:80px;
		list-style: none;
		border: 1px solid ;
		padding-left: 5px;
	}
	#syslangul li{
		text-align: left;
	}

</style>
</body>
</html>
<script type="text/javascript"><!--

jQuery(document).ready(function () {
	jQuery("#topTitle").topMenuTitle();	
	jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	jQuery("#tabDiv").remove();	

	$('.eidtor').hover(
			function(){
				var table = $(this);
				$(table).css("border","1px dashed red");
				$(table).css("cursor","pointer");
				$(table).unbind();
				$(table).bind("click",function(event){
					var type = $(table).attr("type");
					showImageDialog($(table));
					event.stopPropagation();
					return false;
				})
			}, 
			function(){
				$(this).css("border","0px dashed red");
				$(this).css("cursor","normal");
			});
});

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
	
	$.post("/systeminfo/template/loginTemplateTempOperation.jsp",
	{method:'update',tbname:tbname,field:field,value:value},function(data){})
}


jQuery(window).bind("resize",function(){
	jQuery(".overlabel-wrapper").css("position","relative");
})
	
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
	$.post("/systeminfo/template/loginTemplateTempOperation.jsp",
	{method:'commit',loginTemplateId:'<%=templateId%>'},function(){
		parent.parent.Dialog.close()
	})
	
}

function doSaveAndEnable(){
	$.post("/systeminfo/template/loginTemplateTempOperation.jsp",
	{method:'commit&enable',loginTemplateId:'<%=templateId%>'},function(){
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
function showDialog(title,url,width,height,showMax){
	var Show_dialog = new window.top.Dialog();
	Show_dialog.currentWindow = window;   //传入当前window
 	Show_dialog.Width = width;
 	Show_dialog.Height = height;
 	Show_dialog.maxiumnable=showMax;
 	Show_dialog.Modal = true;
 	Show_dialog.Title = title;
 	Show_dialog.URL = url;
 	Show_dialog.show();
}
</script>