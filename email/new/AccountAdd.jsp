<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>

<script type="text/javascript" src="/kindeditor/kindeditor_wev8.js"></script>
<script type="text/javascript" src="/kindeditor/kindeditor-Lang_wev8.js"></script>

<script type="text/javascript" src="/email/js/autocomplete/jquery.autocomplete_wev8.js"></script>
<link href="/email/js/autocomplete/jquery.autocomplete_wev8.css" rel="stylesheet" type="text/css" />


<div class="w-all h-all ">

<div id="addAccount" class="addAccountContainer" >
	<div><%=SystemEnv.getHtmlLabelName(30907,user.getLanguage()) %></div>
</div>	
</div>

<style>
<!--
.addAccountContainer{
	background-color:#fafafa;
	height: 35px;
	font-size: 14px;
	color:#999999;
}
.btn{
	padding-left :14px;
	padding-right:14px;
	height: 28px;
	background-image: url("/email/images/btn_wev8.png");
	background-repeat:no-repeat;
	line-height: 28px;
	text-align: center;
	cursor: pointer;
	color:#555555;
	border: 1px solid #bbbbbb;
	border-radius:3px;
}
.leftMenu{
	width: 201px;
	background: #f6f6f6;
	border-bottom: 1px solid #cccccc;
 	border-left: 1px solid #cccccc;
 	border-right: 1px solid #cccccc;
 	height: 100%;
}
.addContacts{
	background: url("/email/images/contactsIconBg_wev8.png") no-repeat;
	color:#3C6692;
	height: 34px;
	width: 88px;
	margin-top: 10px;
	cursor: pointer;
	outline: 0;
	padding: 0;
	display: inline-block;
	height: 34px;
	width: 88px;
	font-size: 14px;
	line-height: 34px;
	position: relative;
	z-index: 1;
	text-align: center;
	line-height: 34px;
	
}

.addGroup{
	background: url("/email/images/contactsIconBg_wev8.png") no-repeat;
	background-position:	-87px 0px;
	color:#3C6692;
	height: 34px;
	width: 89px;
	margin-top: 10px;
	cursor: pointer;
	outline: 0;
	padding: 0;
	display: inline-block;
	height: 34px;
	width: 89px;
	font-size: 14px;
	line-height: 34px;
	position: relative;
	z-index: 1;
	text-align: center;
	line-height: 34px;
}

.addContacts:hover{
	background-position:	0px -48px;
} 

.addGroup:hover{
	background-position:	-87px -48px;
} 

.contactsGroup{
	line-height: 30px;
}
.contactsGroup:hover{
	background: #e6e6e6;
}

.contactsAll{
	line-height: 30px;
	background: #e6e6e6;
}

 .searchFrom{
 	background: url('/email/images/search_wev8.png') no-repeat;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	right: 15px;
 	top:15px;
 }
  .clearFrom{
  	color:#cccccc;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	right: 15px;
 	top:13px;
 	font-family: verdana!important;
 }
 
 div{
 	font-size: 12px;
 }
 
-->
</style>

<script>
jQuery(document).ready(function(){
	highEditor("emailEditor","450")
	
	$("#fromSearch").bind("change",function(){
		if($(this).val()!=""){
			$(".searchFrom").hide();
			$(".clearFrom").show();
		}else{
			$(".searchFrom").show();
			$(".clearFrom").hide();
		}
	})
});

/*高级编辑器*/
function highEditor(remarkid,height){
    height=!height||height<150?150:height;
    if(jQuery("#"+remarkid).is(":visible")){
		
		var  items=[
						'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable','remote_image'
				   ];
			 
	    KE.init({
					id : remarkid,
					height :height+'px',
					width:'auto',
					resizeMode:1,
					imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
				    allowFileManager : false,
	                newlineTag:'br',
	                items : items,
				    afterCreate : function(id) {
						KE.util.focus(id);
				    }
	   });
	   KE.create(remarkid);
	}
}
</script>