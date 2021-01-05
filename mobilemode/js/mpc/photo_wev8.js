function _p_addPhoto(e, fieldid){
	if(top && typeof(top.registMPCWindow) == "function"){
		top.registMPCWindow(window);
	}
	location = "emobile:upload:_p_addPhoto_uploaded:"+fieldid+":"+e.clientY+":_p_addPhoto_clear";
}

function _p_addPhoto_uploaded(name,data,fieldid){
	if(fieldid){
		var $imageCount = $("#imageCount" + fieldid);
		var imageCountVal = parseInt($imageCount.val());
		var currImgCount = imageCountVal + 1;
		$imageCount.val(currImgCount);
		
		var uploadKey = data.substring("emobile:upload:".length);
		var url = "/client.do?method=getupload&uploadID="+uploadKey;
		
		var $photoEntryWrap = $("<div class=\"photoEntryWrap\"></div>");
		
		var $photoEntry = $("<div class=\"photoEntry\"></div>");
		var htm = "<img src=\""+url+"\"/>";
		htm += "<input type=\"hidden\" name=\"uploadname_"+fieldid+"_"+currImgCount+"\" value=\""+name+"\"/>";
		htm += "<input type=\"hidden\" name=\"uploaddata_"+fieldid+"_"+currImgCount+"\" value=\""+data+"\"/>";
		$photoEntry.html(htm);
		
		$photoEntryWrap.append($photoEntry);
		
		var $photoDel = $("<div class=\"photoDel\"></div>");
		$photoEntryWrap.append($photoDel);
		
		$("#photoContainer_" + fieldid).append($photoEntryWrap);
		
		$photoDel.click(function(){
			$(this).parent().remove();
			if(typeof(_when_photo_removed) == "function"){
				_when_photo_removed();
			}
		});
		
		if(typeof(_when_photo_uploaded) == "function"){
			_when_photo_uploaded();
		}
	}
}

function _p_addPhoto_remove(e, fieldid, imageUrl){
	var $field = $("#field" + fieldid);
	var sourceVal = $field.val() + ";";
	var newVal = sourceVal.replace(imageUrl+";", "");
	if(newVal != ""){
		newVal = newVal.substring(0, newVal.length - 1);
	}
	$field.val(newVal);
	
	var obj = e.srcElement || e.target;
	$(obj).parent().remove();
	
	if(typeof(_when_photo_removed) == "function"){
		_when_photo_removed();
	}
}

function _p_addPhoto_clear(fieldid){
	$("#field" + fieldid).val("");
	$("#imageCount" + fieldid).val(0);
	$("#photoContainer_" + fieldid).children().remove();
	if(typeof(_when_photo_cleared) == "function"){
		_when_photo_cleared();
	}
}