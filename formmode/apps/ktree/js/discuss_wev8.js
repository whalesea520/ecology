$(document).ready(function(){
	initRemark();//初始化编辑器
});
function initRemark(){
	$(this).val("");
		   $("#operationdiv").animate({height:36},200,null,function(){});
		   highEditor("remarkContent");
}
/*高级编辑器*/
function highEditor(remarkid){
    if(jQuery("#"+remarkid).is(":visible")){
		
		var items;
		if(remarkid=="remarkContent")
		  items=[
						'source','fullscreen','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bgcolor', 'bold',
						'italic', 'underline', 'image', 'advtable','emoticons', 'link', 'unlink'
				 ];
		else
		  items=[
						'source','justifyleft', 'justifycenter', 'justifyright','insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bgcolor', 'bold',
						'italic', 'underline', 'strikethrough', 'image', 'advtable'
				 ];		 
	    KE.init({
					id : remarkid,
					height : '100px',
					width:'100%',
					resizeMode:1,
					imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
				    allowFileManager : false,
	                newlineTag:'br',
	                items : items,
				    afterCreate : function(id) {
						//KE.util.focus(remarkid);
				    }
	   });
	   KE.create(remarkid);
	   if(remarkid=="remarkContent"){
	     jQuery("#highEditorImg").attr("src","/cowork/images/normal_edit_wev8.png");  
	   }  
	}
}
function showExtend(obj){
	var _status = $(obj).attr("_status");
	if(_status==1){
		$("#external").animate({height:0},200,null,function(){});
		$(obj).attr("_status",0).css("background-image","url('/cowork/images/blue/down_wev8.png')");
	}else{
		$("#external").animate({height:$("#table1").height()},200,null,function(){});
		$(obj).attr("_status",1).css("background-image","url('/cowork/images/blue/up_wev8.png')");
	}
}