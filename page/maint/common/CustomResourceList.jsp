
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<script src="/js/weaver_wev8.js" type="text/javascript"></script>
<!-- for swfupload -->
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
<%if(user.getLanguage()==7) {%>
	<script type="text/javascript" src="/js/page/maint/common/lang-cn_wev8.js"></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/page/maint/common/lang-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/page/maint/common/lang-tw_wev8.js'></script>
<%}%>
<link href="/js/jquery/plugins/jqueryFileTree/jqueryFileTree_wev8.css" rel="stylesheet" type="text/css" media="screen" />
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
div#PreviewBox{
  position:absolute;
  padding-left:6px;
  display: none;
  Z-INDEX:2006;
}
div#PreviewBox span{
  width:7px;
  height:13px;
  position:absolute;
  left:0px;
  top:9px;
  background:url() 0 0 no-repeat;
}
div#PreviewBox div.Picture{
  float:left;
  border:1px #666 solid;
  background:#FFF;
}
div#PreviewBox div.Picture div{
  border:4px #e8e8e8 solid;
}
div#PreviewBox div.Picture div a img{
  margin:19px;
  border:1px #b6b6b6 solid;
  display: block;
  /*设置原图显示区域大小*/
  max-height: 250px;
  max-width: 250px;
}
/*表体*/
TABLE.ListStyle tbody tr td {
	color: #929393;
	padding: 5px 5px 5px 5px;
	vertical-align: middle;
	border-bottom:1px solid #DADADA;
	background-color:#fff;
}
div.touming{
  background:rgba(0, 0, 0, 0.0) none repeat scroll 0 0 !important;/*实现FF背景透明，文字不透明*/ 
  filter:Alpha(opacity=0); background:#000000;/*实现IE背景透明*/
  border-style:solid;border-width:2pt; border-color:#5da2f2;
}

.selectedIMG {
border: 1px solid rgb(85,142,213)!important;
}

</style>

<script type="text/javascript">
		
		var parentWin = null;
		var dialog = null;
		try{
			//parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.parent.getDialog(parent.parent);
			if(dialog==null){
				dialog = parent.parent.parent.parent.getDialog(parent.parent.parent);
			}
			
		}catch(e){
			if(dialog==null){
				dialog = parent.parent.parent.parent.getDialog(parent.parent.parent);
			}
		}
	</script>
	
<body>
<% 
	String titlename="";
	String dir = Util.null2String(request.getParameter("dir"));
	String isDialog = Util.null2String(request.getParameter("isDialog"));
	dir = "".equals(dir)?"image":dir;
	String isSingle = Util.null2String(request.getParameter("isSingle"));
	if("null".equals(isSingle)){
		isSingle="";
	}
	boolean canEdit=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)){
		canEdit = true;
	}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<input type="hidden"  id="imgPathVal"/>

		<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="75px"></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<%if("1".equals(isDialog)){ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="e8_btn_top" onclick="onSure();" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" class="e8_btn_top" onclick="onClear();" />
					<%} %>
					<%if(canEdit){ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="delAllImg();" />
					<%} %>
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
<table width="100%" height="55px">
	<tr>
		<td width="50%" style="padding-left:22px;" align="left"><%if(!"".equalsIgnoreCase(isSingle)){%><input type="checkbox" onclick="selectAllImg()" alt="<%=SystemEnv.getHtmlLabelName(556,user.getLanguage()) %>"/><%}%></td>
		<td width="50%" style="padding-right:22px;" align="right"><%if(canEdit){%><span id="spanUpload"></span><%}%></td>
	</tr>
	<tr class="Spacing" style="height:1px!important;"><td colspan="2" class="paddingLeft0"><div class="intervalDivClass"></div></td></tr>
</table>
		

<div id="container_id" style='padding-left:5px'></div>

<div id="PreviewBox" onmouseout="hidePreview(event);">
  <div class="Picture" onmouseout="hidePreview(event);">
   <span></span>
   <div>
    <a id="previewUrl" href="javascript:void(0);" target="_blank">
    	<img oncontextmenu="return(false)" id="PreviewImage" onclick="window.open(this.src);return false;" src="about:blank" border="0" onmouseout="hidePreview(event);" />
    </a>
   </div>
  </div>
</div>
<%
String tableString="<table datasource=\"weaver.admincenter.homepage.PortalDataSource.getImageLib\" sourceparams=\"dir:"+dir+"\" pagesize=\"10\" tabletype=\"thumbnail\">"+
	"<browser imgurl=\"/weaver/weaver.splitepage.transform.SptmForThumbnail\" linkkey=\"filerealpath\" linkvaluecolumn=\"filerealpath\" path=\"\" />"+
	"<sql backfields=\" 1 \" sqlform=\" hpinfo \" sqlprimarykey=\"filename\" sqlsortway=\"desc\" sqlorderby=\"\" sqlwhere=\"\" />"+
	"<head>"+
		"<col width=\"100%\" text=\"\" column=\"filename\" orderkey=\"filename\" transmethod=\"weaver.splitepage.transform.SptmForThumbnail.getHref\" otherpara=\"column:filename\" />"+
	"</head>"
	+ "<operates><popedom transmethod=\"weaver.splitepage.transform.SptmForThumbnail.getOperate\"></popedom> ";
	if(canEdit){
	tableString+= "<operate href=\"javascript:renameImg();\" text=\""+SystemEnv.getHtmlLabelName(19827,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
	 + "<operate href=\"javascript:delImg();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
	}
	
	tableString+= "</operates>"
		+"</table>";
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" isShowThumbnail="1" imageNumberPerRow="5"/>
<div id="img_msg" style='padding-left:5px'></div>
<div id="uploadDiv" style="display:">
	<form id="frmmain" action="/weaver/weaver.page.maint.common.CustomResourceServlet?method=uploadFile" method="post" enctype="multipart/form-data">
			<input type="hidden" name="dir" value="<%=dir %>"/>
			<div class="fieldset flash" id="fsUploadProgress">
			</div>
			<div>
			<input  id="btnCancel" type="hidden" value="Cancel All Uploads" onclick="swfu.cancelQueue();" disabled="disabled" style="margin-left: 2px; font-size: 8pt; height: 29px;" />
			</div>
	</form>
</div>
<div id="divStatus" style="display:none"></div>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if("1".equals(isDialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(canEdit){
	if(!"".equalsIgnoreCase(isSingle)) {
		RCMenu += "{" + SystemEnv.getHtmlLabelName(556, user.getLanguage()) + ",javascript:selectAllImg(),_self} ";
	}
	RCMenuHeight += RCMenuHeightStep ;

		/* RCMenu += "{"+SystemEnv.getHtmlLabelName(19827,user.getLanguage())+",javascript:renameImg(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ; */
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<script type="text/javascript">
 var swfu;

		function init() {
			var language = "<%=user.getLanguage()%>";
			var btnwidth = language==8?86:35;
			var settings = {
				flash_url : "/js/swfupload/swfupload.swf",
				upload_url: "/weaver/weaver.page.maint.common.CustomResourceServlet",
				post_params:{"method":"uploadFile","dir":"<%=dir%>"},
				use_query_string : true,//要传递参数用到的配置
				file_size_limit : "100 MB",
				file_types : "*.jpg;*.gif;*.png;*.swf;*.flv;*.mp3;*.mp4",
				file_types_description : "image file,flash file,flv file,mp3 file,mp4 file",
				file_upload_limit : 100,
				file_queue_limit : 0,
				custom_settings : {
					progressTarget : "fsUploadProgress",
					cancelButtonId : "btnCancel"
				},
				debug: false,

				// Button settings
			button_image_url : "/js/swfupload/upload_wev8.png",
            button_placeholder_id : "spanUpload",
            button_width: 142,
            button_height: 33,
          	button_text: '<span class="buttonText"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></span>',
			button_text_style: '.buttonText {font-family:"微软雅黑","宋体"; color: #1094f6;font-size: 15px;}',
            button_text_top_padding: 3,
            button_text_left_padding: 50,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,
				
				//button_placeholder_id: "spanButtonPlaceHolder",
				// The event handler functions are defined in handlers.js
				file_queued_handler : fileQueued,
				file_queue_error_handler : fileQueueError,
				//file_dialog_start_handler : fileDialogStartselect,
				file_dialog_complete_handler : fileDialogComplete,
				upload_start_handler : uploadStart,
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess,
				upload_complete_handler : uploadComplete,
				queue_complete_handler : queueComplete	// Queue plugin event
			};
			
			swfu = new SWFUpload(settings);
	     };
var selectImgInt = null;
$(document).ready( function() {
	jQuery("#topTitle").topMenuTitle();	
	jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	jQuery("#tabDiv").remove();
	
    init();
    imgBindEvent();
    jQuery(".jNiceCheckbox").attr("title","<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>");
    
    weaverTable.prototype.reLoad = function(){
    	jQuery(".hoverDiv").remove();
    	this.startLoad();	
    	this.load();
    	selectImgInt = setInterval("selectSelectedImg()",500)
    }
    
});

function imgBindEvent(){
	//jQuery("IMG[src^='/weaver/weaver.splitepage.transform.SptmForThumbnail']")
	jQuery(".e8ThumbnailImg")
	.live({
		  click: function() {
		  		selectImg(this);
		  },
		  mouseenter: function() {
		  		showPreview(event);
		  },
		  mouseleave:function(){
		  		hidePreview(event);
		  }
	});
}

/*选择文件之后自动上传*/
function fileDialogComplete(){
	if (this.getStats().files_queued > 0) {
		this.startUpload();
	}
}
/*上一文件上传成功后继续自动上传*/
function uploadComplete(fileObj) {
	try {
		/*  I want the next upload to continue automatically so I'll call startUpload here */
		if (this.getStats().files_queued === 0) {
			location.href="/page/maint/common/CustomResourceList.jsp?dir=<%=dir%>&isDialog=<%=isDialog%>";
		}else{
			this.startUpload();
		}
	} catch (ex) { this.debug(ex); }

}

function fileQueued(file) {
	var dir = "<%=dir%>";
	//dir = encodeURI(dir.replace("：",":"));
	swfu.setUploadURL("/weaver/weaver.page.maint.common.CustomResourceServlet?method=uploadFile&dir="+dir);
	if(!checkFileName(file.name,'')){
		swfu.cancelUpload(file.id);
		return false;
	}
}

/**
 * 判断文件名是否合法
 * @param {} name
 * @return {Boolean}
 */
function checkFileName(name,type) {
    var pattern=/[\/\\\:\*\?\"\<\>\|]/;
    if($.trim(name)==''){
    	alert("<%=SystemEnv.getHtmlLabelName(84078,user.getLanguage())%>");
    	return false;
    }
    
    if(name.indexOf(' ')!=-1) {
        alert("<%=SystemEnv.getHtmlLabelName(84079,user.getLanguage())%>");
        return false;
    }
	var tempStr = name.substring(0,name.lastIndexOf("."));
	if(tempStr.indexOf(".")>=0){
		alert("<%=SystemEnv.getHtmlLabelName(84083,user.getLanguage())%>");
		return false;
	}
   	if(type=='dir'){
   		if(name.length>100){
   			alert();
   		}
	    if (name.match(/[\x7f-\xff]/)) { 
	        alert("<%=SystemEnv.getHtmlLabelName(84080,user.getLanguage())%>");
	        return false;
	    }
		if(!tempStr.toLowerCase().match(/^[0-9^a-za-z]*$/)) {
		    alert("<%=SystemEnv.getHtmlLabelName(84083,user.getLanguage())%>");
		    return false;
		}
   	}else{
   		if (name.match(/[\x7f-\xff]/)) { 
	        alert("<%=SystemEnv.getHtmlLabelName(84080,user.getLanguage())%>");
	        return false;
	    }
		if(!tempStr.toLowerCase().match(/^[a-z0-9A-Z_\-]{1,256}$/)) {
		    alert("<%=SystemEnv.getHtmlLabelName(84083,user.getLanguage())%>");
		    return false;
		}
   	}
    
    if(/.*[\u4e00-\u9fa5]+.*$/.test(name)){
    	alert(urmsg.noChineseChar)
    	return false;
    }
    return true;
}

function renameImg(imgname,currentDir,obj){
	currentDir = "<%=dir%>";
	currentDir = currentDir=="image"?currentDir+="/"+imgname:currentDir+imgname;
	var dir_dialog = new window.top.Dialog();
	dir_dialog.currentWindow = window;   //传入当前window
	dir_dialog.Width = 600;
	dir_dialog.Height = 300;
	dir_dialog.Modal = true;
	dir_dialog.Title = "<%=SystemEnv.getHtmlLabelName(19827,user.getLanguage())%>"; 
	dir_dialog.URL = "/page/maint/common/ImageDirEdit.jsp?method=renameFile&currentDir="+currentDir+"&imgname=" + imgname + "&date=" + new Date().getTime();
	dir_dialog.show();
}
function delImg(imgname,currentDir,obj){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		jQuery.post("/weaver/weaver.page.maint.common.CustomResourceServlet",
		{"method":"deleteFile","filepath":imgname,"dir":"<%=dir%>"},
		function(data){
			if(data.indexOf("SUCCESS")!=-1)location.href="/page/maint/common/CustomResourceList.jsp?dir=<%=dir+"&"+request.getQueryString()%>";
			else if(data.indexOf("ERROR")!=-1) jQuery("#img_msg").html("<%=SystemEnv.getHtmlLabelName(84081,user.getLanguage())%>");
		});
	});
}
function delAllImg(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		var filepath = "";
		jQuery("input[name='chkInTableTag']").each(function(){
			if(jQuery(this).attr("checked"))			
				filepath = filepath +jQuery(this).attr("checkboxId")+",";
		});
		if(filepath!=""){
			jQuery.post("/weaver/weaver.page.maint.common.CustomResourceServlet",
			{"method":"deleteFile","filepath":filepath,"dir":"<%=dir%>"},
			function(data){
				if(data.indexOf("SUCCESS")!=-1)location.href="/page/maint/common/CustomResourceList.jsp?dir=<%=dir+"&"+request.getQueryString()%>";
				else if(data.indexOf("ERROR")!=-1) jQuery("#img_msg").html("<%=SystemEnv.getHtmlLabelName(84081,user.getLanguage())%>");
			});
		}
	});
}
var flag = "false";
function selectAllImg(){
	jQuery(".selectedIMG").attr("isSelected","false");
	if(flag=="false"){
		jQuery(".selectedIMG").removeClass("selectedIMG");
		var imgObj = jQuery(".e8ThumbnailImg");
		for(var i=0;i<imgObj.length;i++){
			selectImg(imgObj[i]);
		}
		jQuery(".jNiceCheckbox").addClass("jNiceChecked");
		flag="true";
	}else{
		jQuery(".selectedIMG").removeClass("selectedIMG");
		jQuery(".jNiceCheckbox").removeClass("jNiceChecked");
		flag = "false";
	}
}

function onSure(){

	var imgObj = jQuery(".selectedIMG").find("IMG");
	
//	if(imgObj.length==0)return;
	//alert(imgObj.length)
	var realpath="";
//	$(imgObj).each(function(){
    	
 //   	var imgsrc = jQuery(this).attr("src");
		
//		var imgindex = imgsrc.indexOf("/weaver/weaver.splitepage.transform.SptmForThumbnail");
//		if(imgindex!=-1)
//			imgsrc=imgsrc.substring(imgsrc.indexOf("=")+1);
//		var regS = new RegExp("\\\\","g");
		
//		imgsrc = imgsrc.replace(regS,"/");
//		if(imgsrc.indexOf("/")>0){
//			imgsrc = "/"+imgsrc;
//		}
		
//		realpath = realpath+imgsrc+","
//    });
	realpath = jQuery('#imgPathVal').val();
	if(realpath.length==0)return;
	if(realpath.indexOf(",") != -1){
		realpath = realpath.substring(0,realpath.length-1);
	}
	
	//alert(realpath)
	if('<%=isDialog%>'==1){
		var returnjson = {id:realpath, name:realpath};
	   try{
          dialog.callback(returnjson);
    	}catch(e){alert(e)}

		try{
		     dialog.close(returnjson);
		
		 }catch(e){alert(e)}
	}else{
		window.parent.returnValue=realpath;
		window.parent.close();
	}
}

function onClear(){
	if('<%=isDialog%>'==1){
		var returnjson = {id:'', name:''};
	   try{
          dialog.callback(returnjson);
    	}catch(e){alert(e)}

		try{
		     dialog.close(returnjson);
		
		 }catch(e){alert(e)}
	}else{
		window.parent.returnValue='';
		window.parent.close();
	}
	
	
}
</script>
<script type="text/javascript">
var previewBox = document.getElementById('PreviewBox');
var previewImage = document.getElementById('PreviewImage');
var previewUrl = document.getElementById('previewUrl');
var previewFrom = null;
var previewTimeoutId = null;
var loadingImg = '/images/loading2_wev8.gif';
var maxWidth=250;
var maxHeight=250;
function getPosXY(a,offset) {
       var p=offset?offset.slice(0):[0,0],tn;
       while(a) {
          tn=a.tagName.toUpperCase();
          if(tn=='IMG') {
             a=a.offsetParent;continue;
          }
          p[0]+=a.offsetLeft-(tn=="DIV"&&a.scrollLeft?a.scrollLeft:0);
          p[1]+=a.offsetTop-(tn=="DIV"&&a.scrollTop?a.scrollTop:0);
          if(tn=="BODY")
             break;
          a=a.offsetParent;
      }
      return p;
}
function checkComplete() {
     if(checkComplete.__img&&checkComplete.__img.complete)
         checkComplete.__onload();
}
checkComplete.__onload=function() {
        clearInterval(checkComplete.__timeId);
        var w=checkComplete.__img.width;
        var h=checkComplete.__img.height;
        ///设置原图显示区域大小
        if(w>=h&&w>maxWidth) {
             previewImage.style.width=maxWidth+'px';
        }
        else if(h>=w&&h>maxHeight) {
              previewImage.style.height=maxHeight+'px';
        }
        else {
              previewImage.style.width=previewImage.style.height='';
        }
       previewImage.src=checkComplete.__img.src;previewUrl.href=checkComplete.href;checkComplete.__img=null;
}
function showPreview(e) {
        hidePreview (e);
        previewFrom=e.target||e.srcElement;    
        var srcStr = $(previewFrom).find("img").attr("src") || $(previewFrom).attr("src");
     	var removeLastName = new Array('.mp3','.flv','.swf');//不显示缩略图的文件
     	var needShow = true;
     	try{
	     	for(var i=0;i<removeLastName.length;i++){
	     		var pos = srcStr.lastIndexOf(removeLastName[i])+4;
	    	    if(pos == srcStr.length ){
	    			needShow = false;
	    			break;
	    		}
	     	}
		}catch(e){}
     	if(!needShow) return;   
        previewImage.src=loadingImg;
        previewImage.style.width=previewImage.style.height='';
         
        previewTimeoutId=setTimeout('_showPreview()',500);
        checkComplete.__img=null;
}
function hidePreview(e) {
        if(e) {
            var toElement=e.relatedTarget||e.toElement;
            while(toElement) {
                  if(toElement.id=='PreviewBox')
                          return;
                  toElement=toElement.parentNode;
            }
       }
       try {
            clearInterval(checkComplete.__timeId);
            checkComplete.__img=null;
            previewImage.src="";
	       clearTimeout(previewTimeoutId);
       }
       catch(e) {}
       previewBox.style.display='none';
}

function _showPreview() {
        checkComplete.__img=new Image();
        //if(previewFrom.tagName.toUpperCase()=='IMG')
        //       previewFrom=previewFrom.getElementsByTagName('img')[0];
        var largeSrc=jQuery(previewFrom)[0].tagName=="IMG"?jQuery(previewFrom).attr("src"):jQuery(jQuery(previewFrom).find("IMG")).attr("src");
        largeSrc = largeSrc.substring(largeSrc.indexOf("\\page\\resource\\userfile\\"));
        var picLink="/";
        if(!largeSrc)
             return;
        else {
             checkComplete.__img.src=largeSrc+"&isrealimg=priview";
             checkComplete.href=picLink;
             checkComplete.__timeId=setInterval("checkComplete()",20);
             var pos=getPosXY(previewFrom,[106,26]);
             previewBox.style.left=(pos[0]-112)+'px';
             previewBox.style.top=(pos[1]+77)+'px';
             previewBox.style.display='block';
        }
}

function selectImg(tdObj){
<%if(isDialog.equals("1")&&"".equals(isSingle)){%>
 	$(".selectedIMG").removeClass("selectedIMG").removeClass("e8ThumbnailImgHover").attr("isSelected","false");
 	$(".e8ThumbnailImgHover").removeClass("e8ThumbnailImgHover");
 	$(".jNiceChecked").removeClass("jNiceChecked");
 <%}%>
	var flag = jQuery(tdObj).attr("isSelected");
	if(flag=="false"||flag=="undefined"||flag==undefined){
		jQuery(tdObj).addClass("selectedIMG").attr("isSelected","true");
		jQuery(tdObj).next().find(".jNiceCheckbox").addClass("jNiceChecked");
		setSelectImgSrc(tdObj,1)
	}else{
		jQuery(tdObj).removeClass("selectedIMG").attr("isSelected","false");
		jQuery(tdObj).next().find(".jNiceCheckbox").removeClass("jNiceChecked");
		setSelectImgSrc(tdObj,0)
	}
	
}

function _xtalbe_chkCheckThumbnail(obj){ 
 selectImg(jQuery(obj).parents("td:first").find(".e8ThumbnailImg"));
 
} 

function setSelectImgSrc(temObj,isSelect){
	
   	var imgsrc = jQuery(temObj).find("img").attr("src");
   	var savedPath = jQuery('#imgPathVal').val();
   	imgsrc = getImgSrc(imgsrc);
	<%if(!"".equalsIgnoreCase(isSingle)){%>
	   	if(isSelect == 1){
	   		if(savedPath.indexOf(imgsrc + ",") == -1){
	   			savedPath +=  imgsrc + ",";
	   		}
	   	}else{
	   		savedPath = savedPath.replace(imgsrc + "," , "");
	   	}
	<%}else{%>
		savedPath  = imgsrc;
	<%}%>
	jQuery('#imgPathVal').val(savedPath);
}
function selectSelectedImg(){
	var message_table_Div  = document.getElementById("message_table_Div");	 	
	//message_table_Div.style.display="none";	
	var isShow = jQuery(message_table_Div).css("display");
	if(isShow != 'none'){
		return;
	}else{
		selectImgInt=window.clearInterval(selectImgInt)
	}
	
	var savedPath = jQuery('#imgPathVal').val();
//	jQuery(".selectedIMG").removeClass("selectedIMG");
	var imgObj = jQuery(".e8ThumbnailImg");
	var tmpSrc  = "";
	for(var i=0;i<imgObj.length;i++){
		tmpSrc = getImgSrc(jQuery(imgObj[i]).find("img").attr("src"));
		if(savedPath.indexOf(tmpSrc) != -1){
			selectImg(imgObj[i]);
			jQuery(imgObj[i]).next('div').find(".jNiceCheckbox").addClass("jNiceChecked");
		}
	}
}
function getImgSrc(imgsrc){
	var imgindex = imgsrc.indexOf("/weaver/weaver.splitepage.transform.SptmForThumbnail");
	if(imgindex!=-1)
		imgsrc=imgsrc.substring(imgsrc.indexOf("=")+1);
	var regS = new RegExp("\\\\","g");
	imgsrc = imgsrc.replace(regS,"/");
	if(imgsrc.indexOf("/")>0){
		imgsrc = "/"+imgsrc;
	}
	return imgsrc;
}
</script>
</HTML>
