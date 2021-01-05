<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String noImg = "/mobilemode/images/noImg.jpg";
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
if(mmdetachable.equals("1")){
	if(subCompanyId == -1){
		subCompanyId=Util.getIntValue(Util.null2String(session.getAttribute("mobilemode_defaultSubCompanyId")),-1);
	    if(subCompanyId == -1){
	        subCompanyId = user.getUserSubCompany1();
	    }
	}
}else{
	subCompanyId = -1;
}
int operatelevel = getCheckRightSubCompanyParam("MobileModeSet:All",user,mmdetachable ,subCompanyId);//权限等级-> 2完全控制 1 编辑 0 只读
if(operatelevel < 0){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<!DOCTYPE HTML>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(81788,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(127462,user.getLanguage())%><!-- 移动建模-皮肤管理 --></title>
<script src="/formmode/js/codemirror/lib/codemirror_wev8.js"></script>
<link rel="stylesheet" href="/formmode/js/codemirror/lib/codemirror_wev8.css"/>
<script src="/formmode/js/codemirror/mode/javascript/javascript_wev8.js"></script>
<script src="/formmode/js/codemirror/mode/xml/xml_wev8.js"></script>
<script src="/formmode/js/codemirror/mode/css/css_wev8.js"></script>
<script src="/formmode/js/codemirror/mode/htmlmixed/htmlmixed_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/UUID_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/zclip/jquery.zclip.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script> 
<style>
	*{
		font-family: 'Microsoft YaHei', Arial;
	}
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
		overflow: hidden;
	}
	.CodeMirror{
		font-size: 12px;
		line-height: 1.5em;
		border-bottom: 1px solid #DADADA;
		height:auto;position: absolute;top:0px;left:0px;width:100%;bottom:0px;
	}
	.spinner {
	  margin: 0px auto 0px;
	  text-align: center;
	}
	 
	.spinner > div {
	  width: 10px;
	  height: 10px;
	  background-color: rgb(0, 122, 251);
	 
	  border-radius: 100%;
	  display: inline-block;
	  -webkit-animation: bouncedelay 1.4s infinite ease-in-out;
	  animation: bouncedelay 1.4s infinite ease-in-out;
	  /* Prevent first frame from flickering when animation starts */
	  -webkit-animation-fill-mode: both;
	  animation-fill-mode: both;
	}
	 
	.spinner .bounce1 {
	  -webkit-animation-delay: -0.32s;
	  animation-delay: -0.32s;
	}
	 
	.spinner .bounce2 {
	  -webkit-animation-delay: -0.16s;
	  animation-delay: -0.16s;
	}
	 
	@-webkit-keyframes bouncedelay {
	  0%, 80%, 100% { -webkit-transform: scale(0.0) }
	  40% { -webkit-transform: scale(1.0) }
	}
	 
	@keyframes bouncedelay {
	  0%, 80%, 100% {
	    transform: scale(0.0);
	    -webkit-transform: scale(0.0);
	  } 40% {
	    transform: scale(1.0);
	    -webkit-transform: scale(1.0);
	  }
	}
	#s_loading{
		position: absolute;
		top: 0px;
		left: 250px;
		right: 250px;
		text-align: center;
		font-family: 'Microsoft YaHei';
		font-size: 13px;
		z-index: 999;
		height: 60px;
		display:table;   
		line-height: 60px;
		overflow: hidden;
		display: none;
	}
	#message {
		position: absolute;
		top: 0px;
		left: 250px;
		right: 250px;
		text-align: center;
		font-family: 'Microsoft YaHei';
		font-size: 13px;
		z-index: 999;
		height: 60px;
		padding-top: 20px;
		box-sizing: border-box;
		overflow: hidden;
		display: none;
	}
	#message.success{
		color: #007AFB;
	}
	#message.error{
		color: #F699B4;	
	}
	#message.info{
		color: #017afd;	
	}
	#message.fff{
		color: #fff;
	}
	#skin-list-panel{
		position: relative;
		height: 100%;
	}
	.title{
		border-bottom: 1px solid #DADADA;
		overflow: hidden;
		padding: 0px 10px;
		font-family: 'Microsoft YaHei';
		height: 60px;
		overflow: hidden;
	}
	.text{
		float: left;
		background: url("/formmode/images/appIconRounded_wev8.png") no-repeat;
		padding-left: 46px;
		margin-top: 10px;
	}
	.text .big{
		font-size: 18px;
		color: #333;
	}
	.text .small{
		font-size: 12px;
		color: #AFAFAF;
	}
	.button{
		float: right;
		margin-top: 29px;
	}
	.button div{
		background-color: #30b5ff;
		color: #fff;
		padding: 0px 10px;
		height: 23px;
		line-height: 23px;
		cursor: pointer;
	}
	#detachDiv{margin-right:5px;}
	#detachDiv.button div{
		background-image:url(/formmode/images/globalwhite_wev8.png);
		background-position: 2px 50%;
		background-repeat: no-repeat;
		background-size:16px;
		padding-left:20px;
	}
	.button div.disabled{
		background-color: #eee;
		color: #444;	
		cursor: not-allowed;
	}
	.angle{
		background-image: url(/images/ecology8/angle_wev8.png);
		background-position: 50% 50%;
		background-repeat: no-repeat;
		color: rgb(184, 184, 184);
		cursor: pointer;
		height: 19px;
		left: 33px;
		position: absolute;
		top: 48px;
		width: 84px;
	}
	.skin-container{
		position: absolute;
		top: 61px;
		left: 0px;
		bottom: 0px;
		right: 0px;
		padding: 0px 0px 30px 30px;
		background: #ededed;
		overflow-x: hidden;
		overflow-y: auto;
	}
	.skin-card{
		display: block;
		position: relative;
		float: left;
		width: 260px;
		height: 420px;
		margin-top: 30px;
		margin-right: 30px;
		background-color: #f9f9f9;
		border: 1px solid #e3e3e3;
		box-shadow: 0 1px 4px rgba(0,0,0,0.1);
		overflow: hidden;
	}
	.skin-card.import-add, .skin-card.import-override{
		border: 1px solid #2690e3;
		outline: 1px solid #2690e3;
	}
	.skin-card.import-add:before, .skin-card.import-override:before {
		content: ".";
		position: absolute;
		right: -8px;
		transform: rotate(135deg);
		-ms-transform: rotate(135deg);
		-webkit-transform: rotate(135deg);
		top: -33px;
		width: 0px;
		height: 0px;
		border-bottom: 50px solid transparent;
		border-top: 50px solid transparent;
		border-right: 50px solid #2690e3;
		font-size: 0px;
		line-height: 0px;
		z-index: 1;
	}
	.skin-card.import-add:after, .skin-card.import-override:after {
		transform: rotate(45deg);
		-ms-transform: rotate(45deg);
		-webkit-transform: rotate(45deg);
		position: absolute;
		right: -4px;
		top: 13px;
		color: #fff;
		font-size: 14px;
		z-index: 1;
	}
	.skin-card.import-add:after{
		content: "导入新增";
	}
	.skin-card.import-override:after {
		content: "导入覆盖";
	}
	.skin-card .skin-content{
		padding: 10px 10px 0 10px;
	}
	.card-view-panel img {
		display: block;
		width: 238px;
		height: 358px;
		border: 1px solid rgb(245, 245, 245);
	}
	.card-view-panel .head {
		height: 50px;
		line-height: 50px;
		padding: 0 10px;
		font-size: 14px;
		color: #666;
	}
	.card-view-panel .head h2 {
		width: 60%;
		height: 50px;
		line-height: 50px;
		float: left;
		white-space: nowrap;
		overflow: hidden;
		-ms-text-overflow: ellipsis;
		-o-text-overflow: ellipsis;
		text-overflow: ellipsis;
		font-family: 微软雅黑, 微软雅黑, 'Microsoft YaHei', Helvetica, Tahoma, sans-serif;
		font-size: 14px;
		font-weight: normal;
		padding: 0px;
		margin: 0px;
	}
	.add-card{
		cursor: pointer;
	}
	.add-card .line{
		background-color: #ccc;
		position: absolute;
	}
	.add-card .line1{
		height: 2px;
		width: 60px;
		
		top: 210px;
		left: 100px;
	}
	.add-card .line2{
		height: 60px;
		width: 2px;
		top: 180px;
		left: 130px;
	}
	.card-new{
		width: 0px;
	}
	.card-edit .card-view-panel{
		display: none;
	}
	.card-view .card-edit-panel{
		display: none;
	}
	.card-view .card-reference-panel{
		display: none;
	}
	.card-edit-panel .tableWrap{
		width: 220px;
		height: 350px;
		padding: 0px 10px 10px 10px;
		background-color: #fff;
	}
	.card-edit-panel table{
		width: 100%;
		border-collapse: collapse;
		font-size: 13px;
	}
	.card-edit-panel table td{
		vertical-align: top;
		padding-top: 10px;
	}
	.card-edit-panel .textStyle{
		width: 100%;
		height: 24px;
		border: none;
		border-bottom: 1px solid #eee;
	}
	.card-reference-panel .card-reference-data{
		height: 360px;
		overflow-x:hidden;
		overflow-y:auto;
		background-color:#fff;
	}
	.card-reference-data ul{
		margin: 0px;
		padding: 0px;
		list-style: none;
	}
	.card-reference-data ul li{
   	 	padding: 5px 0px 5px 0px;
	}
	.card-reference-data .line{
		height: 1px;
		background-color: #DADADA;
	}
	.card-reference-data .name-label{
    	font-size: 14px;
	}
	.card-reference-data .descriptions-label{
		color: #AFAFAF;
	    font-size: 10px;
	    line-height: 14px;
	}
	.card-reference-data .nodata{
		padding: 15px 0px 0px 0px;
	    text-align: center;
	    font-size: 14px;
	    color: #333;
	}
	.card-view .dragDropStyle{
		cursor: move;
	}
	.Design_FPhoto_EntryWrap{
		padding: 2px 0px 3px 1px;
		overflow: hidden;
	}
	.Design_FPhoto_EntryBorder{
		padding-top: 5px;
		position: relative;
		float: left;
	}
	.Design_FPhoto_Entry{
		margin-right: 8px;
	}
	.Design_FPhoto_Entry img{
		width: 53px;
		height: 53px;
		border-radius:3px;
		border: 1px solid #ccc;
	}
	.Design_FPhoto_DeleteBtn{
		width: 16px;
		height: 18px;
		position: absolute;
		top: 0px;
		right: 2px;
		background: url("/images/delete_wev8.gif") no-repeat;
		background-position: -3px -3px;
		z-index: 1;
	}
	.Design_FPhoto_EntryBtn{
		margin-right: 8px;
		background: url("/mobilemode/images/emobile/photo_wev8.png") no-repeat;
		background-size: 54px 54px;
	}
	.Design_FPhoto_EntryBtn .upLoadFile{
		position: absolute;
		font-size: 20px;
		width: 61px;
		height: 61px;
		bottom: 0px;
		left: 0px;
		filter: alpha(opacity=0);
		opacity: 0;
		cursor: pointer;
	}
	.btn-wrap{
		height: 50px;
	}
	.btn{
		height: 30px;
		padding: 0px 15px;
		float: right;
		line-height: 30px;
		margin: 10px 0px 0px 10px;
		cursor: pointer;
	}
	.saveBtn{
		background-color: #017afd;
		color: #fff;
	}
	.canelBtn{
		background-color: #ddd;
		color: #333;
	}
	.btn.disabled{
		background-color: #ddd;
		color: #333;
	}
	.skin-opt{
		position: absolute;
		left: 0px;
		bottom:0px;
		height: 50px;
		width: 100%;
		background-color: rgba(0, 0, 0, 0.8);
		-webkit-transition: -webkit-transform 0.3s;
		transition: transform 0.3s;
	}
	.skin-opt.hide{
		-webkit-transform: translate3d(0px, 100%, 0);
		transform: translate3d(0px, 100%, 0);
	}
	.skin-opt ul{
		list-style: none;
		overflow: hidden;
		margin: 0px;
		padding: 0px;
	}
	.skin-opt ul li{
		float: left;
		width: 52px;
		height: 50px;
		text-align: center;
		position: relative;
		background-repeat: no-repeat;
		background-position: center 5px;
		background-size: 24px 24px; 
		cursor: pointer;
	}
	.skin-opt ul li:HOVER{
		background-color: rgba(80, 80, 80, 0.8);
	}
	.skin-opt ul li div{
		position: absolute;
		left: 0px;
		bottom: 3px;
		width: 100%;
		color: #fff;
		line-height: normal;
		font-size: 12px;
	}
	.skin-opt ul li.edit{
		background-image: url("/mobilemode/images/emobile/edit_wev8.png");
		background-size: 22px 22px; 
	}
	.skin-opt ul li.delete{
		background-image: url("/mobilemode/images/emobile/delete_wev8.png");
		background-size: 18px 18px; 
		background-position: center 8px;
	}
	.skin-opt ul li.export{
		background-image: url("/mobilemode/images/emobile/daochu_wev8.png");
		background-size: 22px 22px; 
	}
	.skin-opt ul li.reference{
		background-image: url("/mobilemode/images/emobile/yinyong_wev8.png");
		background-size: 27px 27px; 
	}
	.skin-opt ul li.style{
		background-image: url("/mobilemode/images/webhead/homepagedefault_left_wev8.png");
		background-size: 22px 22px; 
		background-position: center 7px;
	}
	.skin-opt ul li.disabled div,.skin-opt ul li.disabled{
		color:#aaa;
		cursor:not-allowed;
	}
	#main-panel{
		position: absolute;
		top: 0px;
		left: 0px;
		bottom: 0px;
		width: 100%;
		overflow: hidden;
	}
	#css-code-panel, #import-panel{
		position: absolute;
		top: 0px;
		left: 0px;
		height: 100%;
		width: 100%;
		overflow: hidden;
		-webkit-transition: -webkit-transform 0.3s;
		transition: transform 0.3s;
	}
	#css-code-panel.hide, #import-panel.hide{
		-webkit-transform: translate3d(0px, 100%, 0);
		transform: translate3d(0px, 100%, 0);
	}
	#css-code-panel.show, #import-panel.show{
		background-color: rgba(0, 0, 0, 0.6);
	}
	.css-code-proxy, .import-proxy{
		position: absolute;
		top: 0px;
		bottom: 0px;
		left: 0px;
		width: 100%;
		background: transparent;
		z-index: 0;
	}
	.css-code-close, .import-close{
		position: absolute;
		width: 50px;
		height: 25px;
		top: 20px;
		right: 20px;
		border-top-left-radius: 25px;
		border-top-right-radius: 25px;
		z-index: 2;
		background: url("/images/delete_wev8.gif") no-repeat;
		background-position: center 2px;
		background-color: #fff;
		cursor: pointer;
	}
	.css-code-wrap, .import-wrap{
		position: absolute;
		top: 40px;
		bottom: 0px;
		left: 0px;
		width: 100%;
		background-color: #fff;
		z-index: 1;
	}
	.css-code-wrap{
		bottom: 80px;
	}
	.css-code-btn-wrap{
		position: absolute;
		z-index: 3;
		top: 60px;
		right: 20px;
	}
	
	.css-code-btn-wrap .code-btn{
		width: 50px;
		height: 50px;
		background-color: rgba(0, 0, 0, 0.8);
		text-align: center;
		color: #fff;
		border-radius: 2.25em;
		margin-bottom: 15px;
		box-sizing: border-box;
		padding-top: 27px;
		cursor: pointer;
	}
	.css-code-btn-wrap .code-btn:hover{
		background-color: rgba(0, 0, 0, 0.6);
	}
	.css-code-btn-wrap .code-btn.save{
		background-image: url("/mobilemode/images/emobile/edit_wev8.png");
		background-repeat: no-repeat;
		background-position: center 4px;
		background-size: 22px 22px;
	}
	.css-code-btn-wrap .code-btn.icon{
		background-image: url("/mobilemode/images/emobile/share_wev8.png");
		background-repeat: no-repeat;
		background-position: center 5px;
		background-size: 20px 20px;
	}
	.css-code-btn-wrap .code-btn.disabled{
		background-color: rgba(0, 0, 0, 0.2);
		cursor:not-allowed;
	}
	.css-code-icon{
		position: absolute;
		height: 80px;
		bottom: 0px;
		left: 0px;
		width: 100%;
		background-color: #f7f7f7;
		z-index: 2;
		-webkit-transition: -webkit-transform 0.3s;
		transition: transform 0.3s;
		border-top: 1px solid #DDDDDD;
	}
	.css-code-icon.hide{
		-webkit-transform: translate3d(0px, 100%, 0);
		transform: translate3d(0px, 100%, 0);
	}
	.css-code-icon .icon-add{
		width: 60px;
		height: 60px;
		background: url("/mobilemode/images/emobile/photo_wev8.png") no-repeat;
		background-position: center center;
		background-size: 58px 58px;
		margin: 10px;
	}
	.css-code-icon .icon-add .icon-file{
		position: absolute;
		font-size: 20px;
		width: 60px;
		height: 60px;
		bottom: 0px;
		left: 0px;
		filter: alpha(opacity=0);
		opacity: 0;
		cursor: pointer;
	}
	.css-code-icon .icon-add.disabled .icon-file{
		display: none;
	}
	.css-code-icon .icon-content{
		position: absolute;
		top: 0px;
		left: 80px;
		right: 0px;
		height: 100%;
		overflow: auto;
	}
	.css-code-icon .icon-content .icon-content-inner{
		padding: 10px 0px 10px 10px;
		height: 100%;
		box-sizing: border-box;
	}
	.css-code-icon .icon-content .icon-wrap{
		width: 60px;
		height: 60px;
		margin-right: 10px;
		display: inline-block;
		position: relative;
		overflow: hidden;
	}
	.css-code-icon .icon-content .icon-wrap img {
		border: 1px solid #ccc;
		border-radius: 3px;
		width: 100%;
		height: 100%;
		box-sizing: border-box;
	}
	/*
	.css-code-icon .icon-content .icon-wrap:HOVER img{
		border: 1px solid rgb(93, 156, 236);
	}
	*/
	.css-code-icon .icon-content .icon-wrap .icon-copy{
		position: absolute;
		left: 0px;
		bottom: 0px;
		width: 100%;
		text-align: center;
		background-color: rgba(0, 0, 0, 0.8);
		font-size: 12px;
		color: #fff;
		height: 30px;
		line-height: 30px;
		cursor: pointer;
		-webkit-transition: -webkit-transform 0.3s;
		transition: transform 0.3s;
		-webkit-transform: translate3d(0px, 100%, 0);
		transform: translate3d(0px, 100%, 0);
	}
	.css-code-icon .icon-content .icon-wrap:HOVER .icon-copy{
		-webkit-transform: translate3d(0px, 0px, 0);
		transform: translate3d(0px, 0px, 0);
	}
	.import-inner{
		margin: 30px 0px 0px 0px;
	}
	.import-choose{
		height: 36px;
		width: 100px;
		background: #3385ff;
		border-bottom: 1px solid #2d78f4;
		color: #fff;
		text-align: center;
		line-height: 36px;
		font-size: 14px;
		letter-spacing: 1px;
		cursor: pointer;
		margin: 0px auto;
		position: relative;
		margin-top:20px;
	}
	.subCompany-choose{
		font-size: 14px;
		margin: 0px auto;
		text-align:center;
		margin-bottom:20px;
		display:table;
	}
	.subCompany-choose div{
		display:inline-block;
	    height: 30px;
	    line-height: 30px;
	    padding: 0 5px;
        color:#333;
        display:table-cell;
	}
	
	.subCompany-choose div:nth-child(2){
		padding-right: 20px;
        background-image: url(/wui/theme/ecology8/skins/default/general/browser_wev8.png);
	    background-position: right center;
	    background-repeat: no-repeat;
	    background-size: 16px;
	    min-width:60px;
	    border-bottom:1px solid #999;
	    cursor:pointer;
	}
	.import-choose:HOVER {
		box-shadow: 1px 1px 1px #ccc;
		background: #317ef3;
		border-bottom: 1px solid #2868c8;
	}
	.import-choose.disabled{
		background: #aaa !important;
		border-bottom: 1px solid #aaa !important;
		box-shadow: none !important;
	}
	.import-file{
		position: absolute;
		font-size: 20px;
		width: 100px;
		height: 36px;
		bottom: 0px;
		left: 0px;
		filter: alpha(opacity=0);
		opacity: 0;
		cursor: pointer;
	}
	.import-choose.disabled .import-file{
		display: none;
	}
	.import-desc{
		color: #aaa;
		width: 530px;
		margin: 30px auto 0px;
		text-align: left;
		border: 1px solid #bbb;
	}
	.import-desc ul{
		margin: 0px;
		padding: 0px;
		list-style: decimal;
		list-style-position: outside;
		padding-left: 25px;
		padding-right: 8px;
		padding-bottom: 3px;
	}
	.import-desc ul li{
		line-height: 25px;
	}
}
</style>
<script type="text/javascript">
function preview(id){
	var file = document.getElementById("file"+id);
	if(file.files && file.files[0]){
		var reader = new FileReader();
	   	reader.onload = function(evt){
			createAPic(id, evt.target.result);
	   	}
	   	reader.readAsDataURL(file.files[0]);
	}
}
function createAPic(mecid, pic64){
	var $field = $("#previewImg"+mecid);
	var fieldValue = $field.val();
	if(fieldValue == ""){
		fieldValue = pic64;
	}else{
		fieldValue = fieldValue + ";;" + pic64;
	}
	$field[0].value = fieldValue;
	
	var temp = 0;
	$("input[type='file']", "#photoEntryWrap"+mecid).each(function(){
		if($(this).attr("fileNum") > temp){
			temp = $(this).attr("fileNum");
		}
	});
	++temp;
	var $file = $("#file"+mecid);
	$file.attr("name","file_"+mecid+"_"+temp);
	$file.attr("id","file_"+mecid+"_"+temp);
	$file.attr("fileNum",(temp));
	$file.css("display","none");
	var $entryImg = $("<div class=\"Design_FPhoto_Entry\"><img src=\""+pic64+"\"></img></div>");
	var $entryDelete = $("<div class=\"Design_FPhoto_DeleteBtn\"></div>");
	var $entryBorder = $("<div class=\"Design_FPhoto_EntryBorder\"></div>");
	$entryBorder.append($entryImg).append($entryDelete).append($file);
	$("#photoBorder"+mecid).before($entryBorder);
	
	$entryDelete.click(function(){
		var $parent = $(this).parent();
		var index = $parent.index();
		var iv = $(".Design_FPhoto_Entry img", $parent).attr("src");
		
		var $field = $("#previewImg"+mecid);
		var fieldValue = $field.val();
		var tmpArr = fieldValue.split(";;");
		tmpArr.splice(index, 1);
		var newValue = "";
		for(var i = 0; i < tmpArr.length; i++){
			if(i == 0){
				newValue = tmpArr[i];
			}else{
				newValue = newValue + ";;" + tmpArr[i];
			}
		}
		$field[0].value = newValue;
		$(this).parent().remove();
	});
	
	var $originalFile = $("<input id=\"file"+mecid+"\" type=\"file\" name=\"file\" fileNum=\"0\" class=\"upLoadFile\" accept=\"image/jpg,image/jpeg,image/png,image/gif\" single=\"single\"  onchange=\"preview('"+mecid+"');\" data-role=\"none\"/>");
	$("#entryBtn"+mecid).append($originalFile);
}

function addSkinCard(data){
	var isNew = typeof(data) == "undefined";
	var id;
	var name;
	var previewImg;
	var cn;
	var firstImg = "";
	var subCompanyId;
	var subCompanyName;
	if(isNew){
		id = new UUID().toString();
		name = "";
		previewImg = "";
		cn = "card-edit card-new";
		subCompanyId = <%=subCompanyId%>;
		subCompanyName = "<%=SubCompanyComInfo.getSubCompanyname(""+subCompanyId)%>";
	}else{
		id = data["id"];
		name = data["name"];
		previewImg = data["previewImg"];
		cn = "card-view";
		subCompanyId = data["subCompanyId"];
		subCompanyName = data["subCompanyName"];
		if($.trim(previewImg) != ""){
			firstImg = previewImg.split(";;")[0];
		}else{
			firstImg = "<%=noImg%>";
		}
	}
	var $card = $("<div class=\"skin-card "+cn+"\" id=\"skin-card-"+id+"\" data-sid=\""+id+"\"></div>");
	
	var html = "<div class=\"skin-content\">"
				 + "<div class=\"card-view-panel\">"
					+ "<img src=\""+firstImg+"\">"
	                + "<div class=\"head\">"
	                    + "<h2>"+name+"</h2>"
	                    + "<div class=\"skin-opt hide\">"
			            	+ "<ul>"
			            		+ "<li class=\"edit <%if(operatelevel < 1){%>disabled<%}%>\"><div><%=SystemEnv.getHtmlLabelName(126036,user.getLanguage())%></div></li>" //编辑
			            		+ "<li class=\"delete <%if(operatelevel < 2){%>disabled<%}%>\"><div><%=SystemEnv.getHtmlLabelName(126371,user.getLanguage())%></div></li>" //删除
			            		+ "<li class=\"export <%if(operatelevel < 2){%>disabled<%}%>\"><div><%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%></div></li>" //导出
			            		+ "<li class=\"reference\" title=\"<%=SystemEnv.getHtmlLabelName(127469,user.getLanguage())%>\"><div><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%></div></li>" //查看具体应用引用该皮肤  引用
			            		+ "<li class=\"style\"><div><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%></div></li>" //样式
			            	+ "</ul>"
			            + "</div>"
	                + "</div>"
				 + "</div>"
				 
				 + "<div class=\"card-edit-panel\">"
				 	+ "<iframe name=\"formFrame"+id+"\" style=\"display: none;\"></iframe>"
				 	+ "<form target=\"formFrame"+id+"\" method=\"post\">"
				 		+ "<input type=\"hidden\" name=\"id\" value=\""+id+"\">"
				 		+ "<div class=\"tableWrap\">"
							+ "<table>"
								+ "<tr>"
									+ "<td><input type=\"text\" name=\"name\" class=\"textStyle\" placeholder=\"<%=SystemEnv.getHtmlLabelName(127471,user.getLanguage())%>\" value=\""+name+"\"/></td>"   //皮肤名称
								+ "</tr>"
								<%if(mmdetachable.equals("1")){%>
								+ "<tr>"
									+ "<td style=\"position:relative;\">"
										+"<input type=\"text\" name=\"subCompanyName\" readonly=\"readonly\" class=\"textStyle\" placeholder=\"<%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%>\" value=\""+subCompanyName+"\"/>"//选择分部
										+ "<input type=\"hidden\" name=\"subCompanyId\" value=\""+subCompanyId+"\">"
										+"<img style=\"position:absolute;top:15px;right:0;cursor: pointer;\" onclick=\"selectSubCompany('"+id+"')\" src=\"/wui/theme/ecology8/skins/default/general/browser_wev8.png\">"
										+"</td>"   
								+ "</tr>"
								<%}else{%>
								+ "<input type=\"hidden\" name=\"subCompanyId\" value=\""+subCompanyId+"\">"
								<%}%>
								+ "<tr>"
									+ "<td>"
										+ "<div>"
											+ "<%=SystemEnv.getHtmlLabelName(127472,user.getLanguage())%>"  //效果图片：
										+ "</div>"
										+ "<div class=\"Design_FPhoto_EntryWrap\">"
											+ "<div class=\"Design_FPhoto_EntryBorder\" id=\"photoBorder"+id+"\">"
												+ "<div class=\"Design_FPhoto_EntryBtn\" id=\"entryBtn"+id+"\" style=\"width:55px;height:55px;\">"
													+ "<input id=\"file"+id+"\" type=\"file\" name=\"file\" filenum=\"0\" class=\"upLoadFile\" accept=\"image/jpg,image/jpeg,image/png,image/gif\" single=\"single\" onchange=\"preview('"+id+"');\" data-role=\"none\">"
												+ "</div>"
											+ "</div>"
											+ "<input type=\"hidden\" name=\"previewImg\" id=\"previewImg"+id+"\" value=\"\">"
										+ "</div>"
									+ "</td>"
								+ "</tr>"
							+ "</table>"
						+ "</div>"
						+ "<div class=\"btn-wrap\">"
							+ "<div class=\"btn canelBtn\"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%></div>"   //取消
							+ "<div class=\"btn saveBtn\"><%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%></div>"   //保存
						+ "</div>"
					+ "</form>"
				+ "</div>"
				
				+ "<div class=\"card-reference-panel\">"
					 + "<div class=\"card-reference-data\"></div>" 
				+ "</div>"
            + "</div>";
    $card.html(html);
	//$(".skin-container .add-card").before($card);
	$(".skin-card-viewContainer .skin-card-flag").before($card);
	
	if($.trim(previewImg) != ""){
		var iArr = previewImg.split(";;");
		for(var i = 0; i < iArr.length; i++){
			createAPic(id, iArr[i]);
		}
	}
	
	$(".canelBtn", $card).click(function(){
		canelCardEdit(id);
		$(".skin-content").addClass("dragDropStyle");
		$(".skin-card-viewContainer").sortable("enable");//启用元素的拖拽功能 
	});
	$(".saveBtn", $card).click(function(){
		submitCardToServer(id);
		$(".skin-content").addClass("dragDropStyle");
		$(".skin-card-viewContainer").sortable("enable");//启用元素的拖拽功能 
	});
	
	if(isNew){
		$card.animate({width: '260px'}, 120, function(){
			$("input[name='name']", $card)[0].focus();
		});
	}
	
	bindOptEvt($card);
}

function submitCardToServer(id){
	var $card = $("#skin-card-" + id);
	var $saveBtn = $(".saveBtn", $card);
	if(!$saveBtn.hasClass("disabled")){
		var $name = $("input[name='name']", $card);
		if($name.val() == ""){
			$name.attr("placeholder", "<%=SystemEnv.getHtmlLabelName(127473,user.getLanguage())%>"); //请填写皮肤名称
			$name[0].focus();
			return;
		}
		<%if(mmdetachable.equals("1")){%>
		var $subCompanyId = $("input[name='subCompanyId']", $card);
		if($subCompanyId.val() == ""){
			showMsg("<%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%>", "info", 10000);//请选择分部
			return;
		}
		<%}%>
		$saveBtn.addClass("disabled");
		var $form = $("form", $card);
		$form[0].action = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=savaOrUpdate");
		showLoading();
		$form.submit();
	}
}

function submitCardCallback(result){
	hideLoading();
	
	var id = result["id"];
	var status = result["status"];
	
	var $card = $("#skin-card-" + id);
	
	if(status == "1"){
		$card.removeClass("card-new");
		
		var $editPanel = $(".card-edit-panel", $card);
		var $viewPanel = $(".card-view-panel", $card);
		
		var name = $("input[name='name']", $editPanel).val();
		var previewImg = $("input[name='previewImg']", $editPanel).val();
		var firstImg = "<%=noImg%>";
		if($.trim(previewImg) != ""){
			firstImg = previewImg.split(";;")[0];
		}
		
		$(".head h2", $viewPanel).html(name);
		$("img", $viewPanel).attr("src", firstImg);
		
		$editPanel.fadeOut(300, function(){
			$viewPanel.fadeIn(300, function(){
				$card.removeClass("card-edit").addClass("card-view");
				showMsg("<%=SystemEnv.getHtmlLabelName(83551,user.getLanguage())%>", "success", 2000); //保存成功！
			});
		});
	}else{
		var message = result["message"];
		showMsg("<%=SystemEnv.getHtmlLabelName(127474,user.getLanguage())%>" + message, "error", 10000);//保存时出现错误：
		
	}
	
	var $saveBtn = $(".saveBtn", $card);
	$saveBtn.removeClass("disabled");
	
	loadData(function(){
		skinSort();
	});
}

function setViewPanelShow(id, callbackFn){
	var $card = $("#skin-card-" + id);
	var $editPanel = $(".card-edit-panel", $card);
	var $viewPanel = $(".card-view-panel", $card);
	$editPanel.fadeOut(300, function(){
		$viewPanel.fadeIn(300, function(){
			$card.removeClass("card-edit").addClass("card-view");
			if(typeof(callbackFn) == "function"){
				callbackFn.call(this, id);
			}
		});
	});
}

function setEditPanelShow(id, callbackFn){
	var $card = $("#skin-card-" + id);
	var $editPanel = $(".card-edit-panel", $card);
	var $viewPanel = $(".card-view-panel", $card);
	$viewPanel.fadeOut(300, function(){
		$editPanel.fadeIn(300, function(){
			$card.removeClass("card-view").addClass("card-edit");
			if(typeof(callbackFn) == "function"){
				callbackFn.call(this, id);
			}
		});
	});
}

function setReferencePanelShow(id, callbackFn){
	var $card = $("#skin-card-" + id);
	var $referencePanel = $(".card-reference-panel", $card);
	var $viewPanel = $(".card-view-panel", $card);
	$viewPanel.fadeOut(300, function(){
		$referencePanel.fadeIn(300, function(){
			var url = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=getReferenceDataBySkinid&id="+id);
			showLoading();
			FormmodeUtil.doAjaxDataLoad(url, function(data){
				var resultDatas = data["datas"];
				if(resultDatas.length > 0){
					var resultDataStr = "";
					for(var idx = 0; idx < resultDatas.length; idx++){
						var resultData = resultDatas[idx];
						var picpath = resultData.picpath;
						if(picpath == ""){
							picpath = "/mobilemode/images/defaultApp_wev8.png";
						}
						var descriptions = resultData.descriptions == "" ? "<%=SystemEnv.getHtmlLabelName(127449,user.getLanguage())%>" : resultData.descriptions; //无描述信息
						var resultStr = "<li>"
							+ "<div>"
							    + "<table width=\"100%\">"
									+ "<tbody>"
										+ "<tr>"
											+ "<td style=\"padding-right:10px;width:25px;\">"
												+ "<img src=\""+picpath+"\" border=\"0\" width=\"32\" height=\"32\">"
											+ "</td>"
											+ "<td valign=\"top\">"
												+ "<div class=\"name-label\">"+resultData.appname+"</div>"
												+ "<div class=\"descriptions-label\" title=\"\">"+descriptions+"</div>"
											+ "</td>"
											+ "<td width=\"12px\" align=\"right\" style=\"vertical-align:top;\">"
												+ "<div class=\"publishedFlag\" title=\"<%=SystemEnv.getHtmlLabelName(20517,user.getLanguage())%>\"></div>" //已发布
											+ "</td>"
										+ "</tr>"
									+ "</tbody>"
							    + "</table>"
							 + "</div>"
							 + "<div class=\"line\"></div>";
						resultStr += "</li>";
						resultDataStr += resultStr;
					}
					$(".card-reference-data",$card).html("<ul>"+resultDataStr+"</ul>");
				}else{
					$(".card-reference-data",$card).html("<div class=\"nodata\"><%=SystemEnv.getHtmlLabelName(127475,user.getLanguage())%><div>"); //无应用引用该皮肤！
				}
				var canelStr = "<div class=\"btn-wrap\"><div class=\"btn canelBtn\"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%></div></div>";//取消
				$(".card-reference-data",$card).after(canelStr);
				
				$(".canelBtn", $card).click(function(){
					canelCardEdit(id);
					$(".skin-content").addClass("dragDropStyle");
					$(".skin-card-viewContainer").sortable("enable");//启用元素的拖拽功能 
				});
				hideLoading();
			});
		});
	});
}

function canelCardEdit(id){
	var $card = $("#skin-card-" + id);
	if($card.hasClass("card-new")){
		removeCardOnPage(id);
	}else{
		setViewPanelShow(id);
	}
}

function removeCardOnPage(id){
	var $card = $("#skin-card-" + id);
	$card.animate({width: '0px'}, 120, function(){
		$card.remove();
	});
}

function showMsg(msg, cn, t){
	var $msg = $("#message");
	$msg.html(msg);
	$msg.show();
	
	if(cn){
		$msg[0].className = "";
		$msg.addClass(cn);
	}
	
	if(t){
		setTimeout(function(){
			$msg.hide();
		}, t);
	}
}
function hideMsg(){
	var $msg = $("#message");
	$msg.hide();
}

function showLoading(){
	var $msg = $("#message");
	if($msg.is(":hidden")){
		$("#s_loading").show();
	}
}

function hideLoading(){
	$("#s_loading").hide();
}
function bindOptEvt($card){

	$(".head", $card).hoverIntent({
	    over: function(){
	    	$(".skin-opt", $(this)).removeClass("hide");
	    },
	    out: function(){
	    	$(".skin-opt", $(this)).addClass("hide");
	    },
	    interval: 30
	});
	
	$(".skin-opt ul li", $card).click(function(){
		var $that = $(this);
		
		$that.parent().parent().addClass("hide");
		
		var $cd = $that.closest(".skin-card");
		var id = $cd.attr("data-sid");
			
		if($that.hasClass("edit")){
			<%if(operatelevel > 0){%>
				setEditPanelShow(id);
				$(".skin-content").removeClass("dragDropStyle");
				$(".skin-card-viewContainer").sortable("disable");//禁用元素的拖拽功能 
			<%}%>
		}else if($that.hasClass("delete")){
			<%if(operatelevel > 1){%>
				removeCardOnServer(id);
			<%}%>
		}else if($that.hasClass("style")){
			var $cssForm = $("#cssForm");
			var $cssId = $("input[name='id']", $cssForm);
			if($cssId.val() == id){
				showCssPanel();
			}else{
				$cssId.val(id);
				setEditorValue("");
				//hideIconPanel();
				showCssPanel(function(){
					loadCssOnServer(id);
				});
				
				var $iconForm = $("#iconForm");
				var $iconId = $("input[name='id']", $iconForm);
				$iconId.val(id);
			}
		}else if($that.hasClass("export")){
			<%if(operatelevel > 1){%>
				location.href = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=export&id=" + id);
			<%}%>
		}else if($that.hasClass("reference")){
			setReferencePanelShow(id);
			$(".skin-content").removeClass("dragDropStyle");
			$(".skin-card-viewContainer").sortable("disable");//禁用元素的拖拽功能 
		}
		
	});
}

function loadData(callbackFn){
	var url = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=getAllSkin&subCompanyId=<%=subCompanyId%>");
	showLoading();
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		hideLoading();
		var status = result["status"];
		if(status == "0"){
			var message = result["message"];
			showMsg("<%=SystemEnv.getHtmlLabelName(127465,user.getLanguage())%>" + message, "error", 10000);//加载皮肤时出现错误：
		}
		$(".skin-container .skin-card").not(".add-card").remove();
		var data = result["data"];
		for(var i = 0; i < data.length; i++){
			addSkinCard(data[i]);
		}
		
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this);
		}
		
	});
}

function removeCardOnServer(id){
	var $card = $("#skin-card-" + id);
	var name = $(".head h2", $card).text();
	if(confirm("<%=SystemEnv.getHtmlLabelName(127477,user.getLanguage())%>")){ //确定要删除此皮肤吗？
		var url = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=delete");
		showLoading();
		FormmodeUtil.doAjaxDataSave(url, {"id" : id}, function(result){
			hideLoading();
			var status = result["status"];
			if(status == "1"){
				removeCardOnPage(id);
				showMsg("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>", "success", 2000);//删除成功
			}else{
				var message = result["message"];
				showMsg("<%=SystemEnv.getHtmlLabelName(127478,user.getLanguage())%>" + message, "error", 10000);//删除时出现错误：
			}
		});
	}
};

function showCssPanel(callbackFn){
	var $codePanel = $("#css-code-panel");
	$codePanel.removeClass("hide");
	setTimeout(function(){
		$codePanel.addClass("show");
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this);
		}
	}, 300);	
}

function hideCssPanel(){
	var $codePanel = $("#css-code-panel");
	$codePanel.removeClass("show");
	$codePanel.addClass("hide");
}

function loadCssOnServer(id){
	var url = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=getCss&id=" + id);
	showLoading();
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		hideLoading();
		var status = result["status"];
		if(status == "1"){
			var css = result["css"];
			if($.trim(css) == ""){
				css = "/* <%=SystemEnv.getHtmlLabelName(127479,user.getLanguage())%> */\n"; //在此处键入样式代码
			}
			setEditorValue(css);
			
			var $iconPanel = $("#css-code-panel .css-code-icon");
			var $iconContent = $(".icon-content .icon-content-inner", $iconPanel);
			$iconContent.find("*").remove();
			
			var iconArr = result["iconArr"];
			for(var i = 0; i < iconArr.length; i++){
				var html = createIconHtml(iconArr[i]);
				var $iconWrap = $(html);
				$iconContent.append($iconWrap);
				
				buildZclip($(".icon-copy", $iconWrap));
			}
			resizeIconContent();
			
		}else{
			var message = result["message"];
			showMsg("<%=SystemEnv.getHtmlLabelName(127480,user.getLanguage())%>" + message, "error", 10000);//加载样式代码时出现错误：
		}
		
	});
}
function submitCssToServer(){
	var $saveBtn = $("#css-code-panel .code-btn.save");
	if(!$saveBtn.hasClass("disabled")){
		$saveBtn.addClass("disabled");
		var $form = $("#cssForm");
		$form[0].action = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=saveCss");
		showLoading();
		$form.submit();
	}
}

function submitCssCallback(result){
	hideLoading();
	
	var status = result["status"];
	
	if(status == "1"){
		showMsg("<%=SystemEnv.getHtmlLabelName(83551,user.getLanguage())%>", "fff", 2000);//保存成功！
	}else{
		var message = result["message"];
		showMsg("<%=SystemEnv.getHtmlLabelName(127474,user.getLanguage())%>" + message, "error", 10000);//保存时出现错误：
		
	}
	
	var $saveBtn = $("#css-code-panel .code-btn.save");
	$saveBtn.removeClass("disabled");
	
}

function showIconPanel(callbackFn){
	var $iconPanel = $("#css-code-panel .css-code-icon");
	$iconPanel.removeClass("hide");
	setTimeout(function(){
		$iconPanel.addClass("show");
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this);
		}
	}, 300);	
}

function hideIconPanel(){
	var $iconPanel = $("#css-code-panel .css-code-icon");
	$iconPanel.removeClass("show");
	$iconPanel.addClass("hide");
}

function isIconPanelShow(){
	var $iconPanel = $("#css-code-panel .css-code-icon");
	return !$iconPanel.hasClass("hide");
}

function submitIconToServer(){
	var $saveBtn = $("#css-code-panel .css-code-icon .icon-add");
	if(!$saveBtn.hasClass("disabled")){
		$saveBtn.addClass("disabled");
		var $form = $("#iconForm");
		$form[0].action = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=saveIcon");
		showLoading();
		$form.submit();
	}
}

function createIconHtml(data){
	var copyContent = "images/" + data["filename"];
	var html = "<div class=\"icon-wrap\">"
					+ "<img src=\""+data["iconPath"]+"\">"
					+ "<div class=\"icon-copy\" copy-content=\""+copyContent+"\"><%=SystemEnv.getHtmlLabelName(127481,user.getLanguage())%></div>" //复制路径
			 + "</div>";
	return html;
}

function submitIconCallback(result){
	hideLoading();
	
	var $iconPanel = $("#css-code-panel .css-code-icon");
			
	var status = result["status"];
	
	if(status == "1"){
		var $iconContent = $(".icon-content .icon-content-inner", $iconPanel);
		var html = createIconHtml(result);
		var $iconWrap = $(html);
		$iconContent.append($iconWrap);
		
		resizeIconContent();
		
		initOrResizeScroll();
		
		buildZclip($(".icon-copy", $iconWrap));
		
		showMsg("<%=SystemEnv.getHtmlLabelName(25388,user.getLanguage())%>", "fff", 2000);//上传成功
	}else{
		var message = result["message"];
		showMsg("<%=SystemEnv.getHtmlLabelName(127482,user.getLanguage())%>" + message, "error", 10000);//上传图标时出现错误：
		
	}
	
	var $saveBtn = $(".icon-add", $iconPanel);
	$saveBtn.removeClass("disabled");
}

function resizeIconContent(){
	var $iconPanel = $("#css-code-panel .css-code-icon");
	var $iconContent = $(".icon-content .icon-content-inner", $iconPanel);
	var w = 0;
	$(".icon-wrap", $iconContent).each(function(){
		w = w + $(this).outerWidth(true);
	});
	$iconContent.width(w);
}

function buildZclip($obj){
	$obj.zclip({
		path : "/mobilemode/js/zclip/ZeroClipboard.swf",
		copy : function(){
			return $(this).attr("copy-content");
		},
		afterCopy : function(){
			showMsg("<%=SystemEnv.getHtmlLabelName(127484,user.getLanguage())%>", "fff", 3000);//已复制到剪切板
		}
	});
}

function showImportPanel(callbackFn){
	var $importPanel = $("#import-panel");
	$importPanel.removeClass("hide");
	setTimeout(function(){
		$importPanel.addClass("show");
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this);
		}
	}, 300);	
}

function hideImportPanel(callbackFn){
	var $importPanel = $("#import-panel");
	$importPanel.removeClass("show");
	$importPanel.addClass("hide");
	setTimeout(function(){
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this);
		}
	}, 300);
}

function doImport(){
	var $importPanel = $("#import-panel");
	var $file = $(".import-file", $importPanel);
	if($file[0].value != ""){
		if(!$file[0].value.match(/.zip|.rar/i)){
			alert("<%=SystemEnv.getHtmlLabelName(127485,user.getLanguage())%>");//文件格式错误，请选择一个压缩文件(.zip | .rar)
		}else{
			submitImportToServer();
		}
	}
}

function submitImportToServer(){
	var $impBtn = $("#import-panel .import-choose");
	if(!$impBtn.hasClass("disabled")){
		$impBtn.addClass("disabled");
		var $form = $("#importForm");
		$form[0].action = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=import");
		showLoading();
		$form.submit();
	}
}

function submitImportCallback(result){
	var status = result["status"];
	
	function resetImp(){
		hideLoading();
		var $impBtn = $("#import-panel .import-choose");
		$impBtn.removeClass("disabled");
		
		var $importPanel = $("#import-panel");
		var file = $(".import-file", $importPanel)[0];
		if (file.outerHTML) {
			file.outerHTML = file.outerHTML;
		} else {
			file.value = "";
		}
	}
		
	if(status == "1"){
		var impMeta = result["impMeta"];
		var status2 = impMeta["status"];
		var id = impMeta["id"];
		if(status2 == "1"){
			var dirname = impMeta["dirname"];
			var isoverride = confirm("<%=SystemEnv.getHtmlLabelName(127486,user.getLanguage())%>");//系统已包含将导入的皮肤，确定要覆盖吗？\n\n单击“确定”将使用导入的皮肤覆盖系统中已存在的皮肤。\n\n单击“取消”终止导入。
			var url = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=import2");
			var subCompanyId = $("#subCompanyId").val();
			FormmodeUtil.doAjaxDataSave(url, {"id" : id, "dirname" : dirname, "isoverride" : isoverride,"subCompanyId":subCompanyId}, function(result2){
				var status3 = result2["status"];
				if(status3 == "1"){
					resetImp();
					if(isoverride){
						hideImportPanel(function(){
							showMsg("<%=SystemEnv.getHtmlLabelName(25750,user.getLanguage())%>", "success", 2000);//导入成功
							loadData(function(){
								var $card = $("#skin-card-" + id);
								$card.addClass("import-override");
								setTimeout(function(){
									$card.removeClass("import-override");
								}, 6000);
							});
						});
					}else{
						showMsg("<%=SystemEnv.getHtmlLabelName(127487,user.getLanguage())%>", "fff", 2000);//已终止导入
					}
				}else{
					resetImp();
					var message = result2["message"];
					if(isoverride){
						showMsg("<%=SystemEnv.getHtmlLabelName(127488,user.getLanguage())%>" + message, "error", 10000); //导入时出现错误：
					}else{
						showMsg("<%=SystemEnv.getHtmlLabelName(127489,user.getLanguage())%>" + message, "error", 10000); //终止导入时出现错误：
					}
				}
			});
		}else if(status2 == "2"){
			resetImp();
			hideImportPanel(function(){
				showMsg("<%=SystemEnv.getHtmlLabelName(25750,user.getLanguage())%>", "success", 2000);//导入成功
				loadData(function(){
					var $card = $("#skin-card-" + id);
					$card.addClass("import-add");
					setTimeout(function(){
						$card.removeClass("import-add");
					}, 6000);
				});
			});
		}
	}else{
		resetImp();
		var message = result["message"];
		showMsg("<%=SystemEnv.getHtmlLabelName(127488,user.getLanguage())%>" + message, "error", 10000);//导入时出现错误：
	}
}

function skinSort(){

   	$(".skin-content").addClass("dragDropStyle"); 
	var $cardContainerList = $(".skin-card-viewContainer"); 
    $cardContainerList.sortable({ 
        opacity: 0.6, //设置拖动时候的透明度 
        revert: true, //缓冲效果 
        cursor: 'move', //拖动的时候鼠标样式 
        handle: $(".skin-content"),  //可以拖动的部位
        update: function(){ 
        	var skinid = "";
        	$(".card-view",$cardContainerList).each(function(i){
				skinid += $(this).attr("data-sid")+",";
        	});
        	if(skinid != ""){
        		skinid = skinid.substring(0,skinid.length-1);
        		var url = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=updateSkinOrder");
	            showLoading();
				FormmodeUtil.doAjaxDataSave(url, {"skinids" : skinid}, function(result){
					hideLoading();
					var status = result["status"];
					if(status == "1"){
						showMsg("<%=SystemEnv.getHtmlLabelName(127490,user.getLanguage())%>", "success", 2000);//排序成功
					}else{
						var message = result["message"];
						showMsg("<%=SystemEnv.getHtmlLabelName(127491,user.getLanguage())%>" + message, "error", 10000);//排序出错：
					}
				});
        	}
        } 
    }); 
}

function setEditorValue(v){
	editor.setValue(v);
}

var $iconScroll = null;
function initOrResizeScroll(){
	if($iconScroll == null){
		$iconScroll = $("#css-code-panel .css-code-icon .icon-content").niceScroll({cursorcolor:"#666"});
	}else{
		$iconScroll.resize();
	}
}

function selectOrg(){
	var winHight = jQuery(window).height();
	var winWidth = jQuery(window).width();
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 580;
	dialog.Height = 630;
	dialog.normalDialog = false;
	dialog.URL = "/systeminfo/BrowserMain.jsp?url=/mobilemode/setup/SubcompanyBrowser.jsp?rightStr=MobileModeSet:All";
	dialog.callbackfun = function (paramobj, id1) {
		if(id1){
			var id = id1.id;
			var name = id1.name;
			if(id!=""){
				window.location.href="/mobilemode/setup/skinManage.jsp?subCompanyId="+id;
			}
		}
	};
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33256,user.getLanguage())%>";//选择分部
	dialog.Drag = false;
	dialog.show();
}

function selectSubCompany(skinid){
	var winHight = jQuery(window).height();
	var winWidth = jQuery(window).width();
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 580;
	dialog.Height = 630;
	dialog.normalDialog = false;
	dialog.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=MobileModeSet:All&isedit=1";
	dialog.callbackfun = function (paramobj, id1) {
		if(id1){
			var id = id1.id;
			var name = id1.name;
			if(skinid){
				var $card = $("#skin-card-" + skinid);
				$("input[name=subCompanyName]",$card).val(name);
				$("input[name=subCompanyId]",$card).val(id);
			}else{
				if(id){
					$("#subCompanyName").html(name);
					$("#subCompanyId").val(id);
				}
			}
		}
	};
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33256,user.getLanguage())%>";//选择分部
	dialog.Drag = false;
	dialog.show();
}

var editor;
$(document).ready(function(){

	$(".skin-container .add-card").click(function(){
		addSkinCard();
	});
	
	loadData(function(){
		skinSort();
	});
	
	editor = CodeMirror.fromTextArea(document.getElementById("cssContent"), {
		lineNumbers: true,
		indentUnit: 4,
		dragDrop: false,
		mode: "css"
	});
	
	$("#css-code-panel .css-code-close, #css-code-panel .css-code-proxy").click(function(){
		hideCssPanel();
	});
	$("#css-code-panel .code-btn.save").click(function(){
		<%if(operatelevel > 1){%>
		submitCssToServer();
		<%}%>
	});
	
	/*
	$("#css-code-panel .code-btn.icon").click(function(){
		if(isIconPanelShow()){
			hideIconPanel();
		}else{
			showIconPanel(function(){
				initOrResizeScroll();
			});
		}
		
	});
	
	$("#css-code-panel .css-code-wrap").click(function(){
		hideIconPanel();
	});
	*/
	
	$("#impBtn").click(function(){
		<%if(operatelevel > 1){%>
		showImportPanel();
		<%}%>
	});
	
	$("#import-panel .import-close, #import-panel .import-proxy").click(function(){
		hideImportPanel();
	});
});
</script>
</head>
<body>
<div id="s_loading">
	<div class="spinner">
	  <div class="bounce1"></div>
	  <div class="bounce2"></div>
	  <div class="bounce3"></div>
	</div>
</div>
<div id="message"></div>
<div id="main-panel">
	<div id="skin-list-panel">
		<div class="title">
			<div class="text">
				<div class="big"><%=SystemEnv.getHtmlLabelName(81788,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(127462,user.getLanguage())%><!-- 移动建模-皮肤管理 --></div>
				<div class="small">Skin Manage</div>
			</div>
			<div class="button">
				<div id="impBtn" class="<%if(operatelevel < 2){ %>disabled<%}%>"><%=SystemEnv.getHtmlLabelName(32935,user.getLanguage())%><!-- 导入 --></div>
			</div>
			<%if(mmdetachable.equals("1")){%>
			<div id="detachDiv" onclick="selectOrg()" class="button">
				<div>
					<%if(subCompanyId == -1){%>
						<%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%><!-- 请选择分部 -->
					<%}else{%>
						<%=SubCompanyComInfo.getSubCompanyname(""+subCompanyId) %>
					<% } %>
				</div>	
			</div> 
			<%}%>
		</div>
		<div class="skin-container">
			<div class="skin-card-viewContainer">
				<div class="skin-card-flag"></div>
			</div>
			<%if(operatelevel > 1){ %>
			<div class="skin-card add-card">
				<div class="skin-content">
					<div class="line1 line"></div>
					<div class="line2 line"></div>
	            </div>
			</div>
			<%} %>
		</div>
	</div>
	<div id="css-code-panel" class="hide">
		<div class="css-code-proxy"></div>
		<div class="css-code-close"></div>
		<div class="css-code-btn-wrap">
			<div class="code-btn <%if(operatelevel < 1){ %>disabled<%} %> save">
				<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%><!-- 保存 -->
			</div>
			<div class="code-btn icon" style="display: none;">
				<%=SystemEnv.getHtmlLabelName(125075,user.getLanguage())%><!-- 图标 -->
			</div>
		</div>
		<div class="css-code-wrap">
			<iframe name="cssFormFrame" style="display: none;"></iframe>
			<form target="cssFormFrame" id="cssForm" method="post">
				<input type="hidden" name="id" value=""/>
				<textarea id="cssContent" name="css"></textarea>
			</form>
		</div>
		
		<div class="css-code-icon">
			<div class="icon-add">
				<iframe name="iconFormFrame" style="display: none;"></iframe>
				<form target="iconFormFrame" id="iconForm" method="post" enctype="multipart/form-data">
					<input type="hidden" name="id" value=""/>
					<input type="file" name="file" class="icon-file" accept="image/jpg,image/jpeg,image/png,image/gif" single="single" onchange="submitIconToServer();" />
				</form>
			</div>
			<div class="icon-content">
				<div class="icon-content-inner">
				
				</div>
			</div>
		</div>
	</div>
	
	<div id="import-panel" class="hide">
		<div class="import-proxy"></div>
		<div class="import-close"></div>
		<div class="import-wrap">
			<div class="import-inner">
				<iframe name="importFormFrame" style="display: none;"></iframe>
				<form target="importFormFrame" id="importForm" method="post" enctype="multipart/form-data">
				<%if(mmdetachable.equals("1")){%>
				<div class="subCompany-choose">
					<div><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%>:<!-- 所属分部 --></div>
					<div onclick="selectSubCompany()">
					<span id="subCompanyName"><%if(subCompanyId == -1){%>
						<%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%><!-- 请选择分部 -->
					<%}else{%>
						<%=SubCompanyComInfo.getSubCompanyname(""+subCompanyId) %>
					<% } %></span>
					<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId %>"/>
					<input type="hidden" name="userid" value="<%=user.getUID()%>"/>
					</div>
				</div>
				<%}else{%>
				<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId %>"/>
				<%} %>
				<div class="import-choose">
					<%=SystemEnv.getHtmlLabelName(125333,user.getLanguage())%><!-- 选择文件 -->
					<input type="file" name="file" class="import-file" accept="application/x-zip-compressed" single="single" onchange="doImport();" />
				</div>
				</form>
				
				<div class="import-desc">
					<div style="background-color: #aaa;color: #fff;padding:8px;"><%=SystemEnv.getHtmlLabelName(127463,user.getLanguage())%><!-- 导入说明： --></div>
					<div style="padding:5px 8px;"><%=SystemEnv.getHtmlLabelName(127464,user.getLanguage())%><!-- 每个皮肤都有一个唯一的ID。 --></div>
					<ul>
						<li><%=SystemEnv.getHtmlLabelName(127467,user.getLanguage())%><!-- 如果导入的皮肤和现有的皮肤ID一样，则在导入时会使用导入的皮肤覆盖现有的皮肤(常见操作为从系统中导出皮肤后再进行导入操作，此时则会覆盖掉系统现有皮肤，系统会有覆盖提示)。 --></li>
						<li><%=SystemEnv.getHtmlLabelName(127468,user.getLanguage())%><!-- 如果导入的皮肤和现有的皮肤ID不一样，则在导入后会将导入的皮肤作为一种新皮肤添加到系统中(常见操作为从其他系统或者皮肤库中导出一种新的皮肤，导入到当前系统)。 --></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
