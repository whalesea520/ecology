String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {  
    if (!RegExp.prototype.isPrototypeOf(reallyDo)) {  
        return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);  
    } else {  
        return this.replace(reallyDo, replaceWith);  
    }  
}  


function clearNoNum(obj){
	obj.value = obj.value.replace(/[^\d.]/g,"");
	obj.value = obj.value.replace(/^\./g,"");
	obj.value = obj.value.replace(/\.{2,}/g,".");
	obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
function openDialog(url,title,width,height,blankTab,maxiumnable){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(width){
		dialog.Width = width;
	}else{
		dialog.Width = 600;
	}
	if(height){
		dialog.Height = height;
	}else{
		dialog.Height = 260;
	}
	if(title){
		dialog.Title=title;
	}
	dialog.Drag = true;
	if(maxiumnable&&maxiumnable==true){
		dialog.maxiumnable=true;
	}
	if(blankTab==true){
		dialog.URL = "/cpt/capital/CapitalBlankTab.jsp?url="+url.replaceAll("&","%26",false) +"&title="+title;
	}else{
		dialog.URL = url;
	}
	//console.log("dialogurl:"+dialog.URL);
	dialog.show();
}


function resetForm(obj){
	var form= obj.parents("form").first();
	
	//form.find("input[type='text']").val("");
	form.find(".e8_os").find("span.e8_showNameClass").remove();
	form.find(".e8_os").find("input[type='hidden']").val("");
	form.find("select[name!=mouldid]").selectbox("detach");
	form.find("select[name!=mouldid]").val("");
	form.find("select[name!=mouldid]").trigger("change");
	form.find("span.jNiceCheckbox").removeClass("jNiceChecked");
	beautySelect(form.find("select[name!=mouldid]"));
	form.find(".calendar").siblings("span").html("");
	form.find(".calendar").siblings("input[type='hidden']").val("");
}


jQuery(document).ready(function () {
	
	jQuery("form").find("input[type=reset]").bind('click',function(){resetForm(jQuery(this));}); 
	
	jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   jQuery(this).tzCheckbox({labels:['','']});
	  }
	 });
	
});



function refreshTab(){
	jQuery('.flowMenusTd',parent.document).toggle();
	jQuery('.leftTypeSearch',parent.document).toggle();
} 