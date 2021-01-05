Mobile_NS.fsoundInit = function(mecid){
	$("#soundRecord"+mecid).bind("click", function(){
		Mobile_NS.fsoundRecord(this);
	});
	$("#deleteBtn"+mecid).bind("click", function(){
		Mobile_NS.fsoundDelete(this);
	});
}

Mobile_NS.fsoundRecord = function(obj){// 语音录制
	var mecid = $(obj).attr("mecid");
	$(obj).addClass("link_active");
	setTimeout(function(){$(obj).removeClass("link_active");},300);
	Mobile_NS.addSound(mecid);
}

Mobile_NS.fsoundDelete = function(obj){// 语音删除
	var mecid = $(obj).attr("mecid");
	
	$("#soundContent"+mecid).val("");
	$("#soundRecord"+mecid).show();
	$("#soundDelete"+mecid).hide();
}

Mobile_NS.addSound = function(mecid){
	mecid = mecid + "_" + ((new Date()).valueOf());
	if(top && typeof(top.registMPCWindow) == "function"){
		window.sound_fieldid = mecid; 
		top.registMPCWindow(window);
	}
	location = "emobile:speech:_p_addSound_uploaded:" + mecid;
}

function _p_addSound_uploaded(result, mecid){
	if(result && mecid){
		var mecid = mecid.substring(0, mecid.lastIndexOf("_"));
		
		$("#soundContent" + mecid).val(result);
		$("#soundRecord"+mecid).hide();
		$("#soundDelete"+mecid).show();
	}
}
