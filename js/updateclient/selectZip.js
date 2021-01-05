var donext = 0;
$(document).ready(function(){
	  // $("#sub").click(function(){
		//   next();
       //  });
	  });
function next111() {
	if(donext>0) {
		top.Dialog.alert("正在上传附件！");
		return;
	}
	
    if($("#zipfile").val()!=""||$("input:radio[name='localfile']").val()!=""){
    	var uploadzip  = $("input:radio[name='uploadzip']:checked").val();
    	var zipval;
    	if(uploadzip=="local") {
    		zipval = $("input:radio[name='localfile']").val();
        	if(zipval.indexOf(".zip") < 0) {
        		top.Dialog.alert("上传的升级包格式不对！");
        		return;
        	}
        	$("#filename").val(zipval);
    		
    	} else {
    		zipval = $("#zipfile").val();
        	
        	if(zipval.indexOf(".zip") < 0) {
        		top.Dialog.alert("上传的升级包格式不对！");
        		return;
        	}
        	$("#filename").val(zipval);
    	}

   		//$(this).attr("disabled",true);
        document.weaverform.submit();
        donext++;
   }else{
	   top.Dialog.alert("请选择升级包");
	   return;
   } 
}
function checkfile(obj) {
	var val = obj.value;
	if((val!= null && val != undefined) && (val.indexOf(".zip")>-1)) {
		//校验附件内容正确
		return;
	} else {
		val = "";
		top.Dialog.alert("上传的升级包格式不对！");
		$("#zipfile").val("");
		return;
	}
}

$(document).ready(function(){
	//第一次进入页面
	hideEle("localtd");
	showEle("uploadtd");
	$("input:radio[name='uploadzip']").click(function(){
		var checkval = $(this).val();
		if(checkval=="upload") {
			hideEle("localtd");
			showEle("uploadtd");
		} else {
			hideEle("uploadtd");
			showEle("localtd");
		}
	});
});