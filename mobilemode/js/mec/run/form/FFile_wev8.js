Mobile_NS.FFile = {};

Mobile_NS.FFile.onload = function(p){
	var that = this;
	var mecid = p["id"];
	var file = document.getElementById("file"+mecid);
	if(file != null){
		file.onchange = function(){
			that.preview(p);
		};
	}
};

function delFFile(obj, mecid, docid){
	var $this = $(obj);
	
	var $field = $("#fileField"+mecid);
	var fieldValue = $field.val();
	var len = 0;
	$("input[type='file']", "#FileEntryWrap"+mecid).each(function(){
		if(Number($(this).attr("fileNum")) > 0){
			++len;
		}
	});
	if(fieldValue.indexOf("#") != -1){
		if(--len <= 0){
			$field.val("");
		}else{
			$field.val("#" + len);
		}
	}else{
		var newValue = "";
		var tmpArr = fieldValue.split(",");
		for(var i = 0; i< tmpArr.length; i++){
			if(tmpArr[i] == docid){
				tmpArr.splice(i, 1);
				break;
			}
		}
		
		for(var i = 0; i < tmpArr.length; i++){
			var oneValue = tmpArr[i];
			if(i == 0){
				newValue = oneValue;
			}else{
				newValue = newValue + "," + oneValue;
			}
		}
		if(newValue == "" && len > 0){
			newValue = "#"+len;
		}
		$field[0].value = newValue;
	}
	$this.parent().remove();
}

function downloadFile(fileid){
	location.href="/weaver/weaver.file.FileDownload?fileid="+fileid;
}

Mobile_NS.FFile.preview = function(p){
	var that = this;
	var mecid = p["id"];
	var file = document.getElementById("file"+mecid);
	if(file.files && file.files[0]){
		var filefullname = file.files[0].name;
		var splitpoint = filefullname.lastIndexOf(".");
		var filename = filefullname.substring(0, splitpoint);
		var filetype = "";
		if(splitpoint != -1){
			filetype = filefullname.substring(splitpoint + 1);
		}
		
		var imagesrc = "";
		if(filetype.toLowerCase() == "jpg" || filetype.toLowerCase() == "jpeg" || filetype.toLowerCase() == "png" || filetype.toLowerCase() == "gif" || filetype.toLowerCase() == "bmp") {
			imagesrc = "/mobilemode/images/icon/jpg_wev8.png";
		}else if(filetype.toLowerCase() == "doc" || filetype.toLowerCase() == "docx") {
			imagesrc = "/mobilemode/images/icon/doc_wev8.png";
		}else if(filetype.toLowerCase() == "xls" || filetype.toLowerCase() == "xlsx") {
			imagesrc = "/mobilemode/images/icon/xls_wev8.png";
		}else if(filetype.toLowerCase() == "pdf") {
			imagesrc = "/mobilemode/images/icon/pdf_wev8.png";
		}else if(filetype.toLowerCase() == "htm" || filetype.toLowerCase() == "html") {
			imagesrc = "/mobilemode/images/icon/html_wev8.png";
		}else if(filetype.toLowerCase() == "ppt") {
			imagesrc = "/mobilemode/images/icon/ppt_wev8.png";
		}else {
			imagesrc = "/mobilemode/images/icon/txt_wev8.png";
		}
		
		var filesize = file.files[0].size;
    	var showfilesize = "";
    	if(filesize>=(1024 * 1024)){
    		showfilesize = (filesize / 1024 / 1024).toFixed(2) + "M";
    	} else if(filesize>=1024){
    		showfilesize = Math.floor(filesize / 1024) + "K";
    	} else{
    		showfilesize = filesize+ "B";
    	}
		
		var reader = new FileReader();
	   	reader.onload = function(evt){
	   		var $field = $("#fileField"+mecid);
	   		
			var temp = 0;
			$("input[type='file']", "#FileEntryWrap"+mecid).each(function(){
				if($(this).attr("fileNum") > temp){
					temp = $(this).attr("fileNum");
				}
			});
			
			++temp;
			var $file = $("#file"+mecid);
			$file.attr("name","file"+mecid+(temp));
			$file.attr("id","file"+mecid+(temp));
			$file.attr("fileNum",(temp));
			$file.css("display","none");
			if($field.val() == ""){
				$field.val("#" + temp);
			}
			var $entryFile = 
				$("<div class=\"Design_FFile_Entry\">" +
						"<table style=\"width: 100%; table-layout: fixed;\">" +
							"<tr>" +
								"<td class=\"icon\"><img src=\"" + imagesrc + "\"></td>" +
								"<td class=\"name\">" + filefullname + "</td>" +
								"<td class=\"size\">" + showfilesize + "</td>" +
								"<td class=\"flag\"><span></span></td>" +
							"</tr>" +
						"</table>" +
					"</div>");
			var $entryDelete = $("<div class=\"Design_FFile_DeleteBtn\" onclick=\"delFFile(this, '"+mecid+"')\"></div>");
			var $entryborder = $("<div class=\"Design_FFile_EntryBorder\"></div>");
			$entryborder.append($entryFile).append($entryDelete).append($file);
			
			$("#fileBorder"+mecid).before($entryborder);
			
			var $originalFile = $("<input id=\"file"+mecid+"\" type=\"file\" name=\"file\" fileNum=\"0\" class=\"upLoadFile\" single=\"single\" data-role=\"none\"/>");
			$originalFile[0].onchange = function(){
				that.preview(p);
			};
			$("#entryBtn"+mecid).append($originalFile);
			$originalFile.focus();
	   	}
	   	reader.readAsDataURL(file.files[0]);
	}
};

Mobile_NS.FFile.preview2 = function(p){
	var that = this;
	var mecid = p["id"];
	var file = document.getElementById("file"+mecid);
	if(file.files && file.files[0]){
		var filefullname = file.files[0].name;
		var splitpoint = filefullname.lastIndexOf(".");
		var filename = filefullname.substring(0, splitpoint);
		var filetype = "";
		if(splitpoint != -1){
			filetype = filefullname.substring(splitpoint + 1);
		}
		
		var imagesrc = "";
		if(filetype.toLowerCase() == "jpg" || filetype.toLowerCase() == "jpeg" || filetype.toLowerCase() == "png" || filetype.toLowerCase() == "gif" || filetype.toLowerCase() == "bmp") {
			imagesrc = "/mobilemode/images/icon/jpg_wev8.png";
		}else if(filetype.toLowerCase() == "doc" || filetype.toLowerCase() == "docx") {
			imagesrc = "/mobilemode/images/icon/doc_wev8.png";
		}else if(filetype.toLowerCase() == "xls" || filetype.toLowerCase() == "xlsx") {
			imagesrc = "/mobilemode/images/icon/xls_wev8.png";
		}else if(filetype.toLowerCase() == "pdf") {
			imagesrc = "/mobilemode/images/icon/pdf_wev8.png";
		}else if(filetype.toLowerCase() == "htm" || filetype.toLowerCase() == "html") {
			imagesrc = "/mobilemode/images/icon/html_wev8.png";
		}else if(filetype.toLowerCase() == "ppt") {
			imagesrc = "/mobilemode/images/icon/ppt_wev8.png";
		}else {
			imagesrc = "/mobilemode/images/icon/txt_wev8.png";
		}
		
		var filesize = file.files[0].size;
    	var showfilesize = "";
    	if(filesize>=(1024 * 1024)){
    		showfilesize = (filesize / 1024 / 1024).toFixed(2) + "M";
    	} else if(filesize>=1024){
    		showfilesize = Math.floor(filesize / 1024) + "K";
    	} else{
    		showfilesize = filesize+ "B";
    	}
		
		var reader = new FileReader();
	   	reader.onload = function(evt){
	   		var file64 = filetype + "-" + evt.target.result;
			var $field = $("#fileField"+mecid);
			var fieldValue = $field.val();
			if(fieldValue == ""){
				fieldValue = file64;
			}else{
				fieldValue = fieldValue + ";;" + file64;
			}
			$field[0].value = fieldValue;
			
			var $file = $("#file"+mecid);
			$file.remove();
			var $entryFile = 
				$("<div class=\"Design_FFile_Entry\">" +
						"<table style=\"width: 100%; table-layout: fixed;\">" +
							"<tr>" +
								"<td class=\"icon\"><img width=\"20\" height=\"20\" src=\"" + imagesrc + "\"></td>" +
								"<td class=\"name\">" + filefullname + "</td>" +
								"<td class=\"size\">" + showfilesize + "</td>" +
								"<td class=\"flag\"><img width=\"20\" height=\"20\" src=\"/mobilemode/images/mec/arrow_right_wev8.png\"></td>" +
							"</tr>" +
						"</table>" +
					"</div>");
			var $entryDelete = $("<div class=\"Design_FFile_DeleteBtn\"></div>");
			var $entryborder = $("<div class=\"Design_FFile_EntryBorder\" style=\"padding-right: 30px;\"></div>");
			$entryborder.append($entryFile).append($entryDelete);
			
			$("#fileBorder"+mecid).before($entryborder);
			
			$entryDelete.click(function(){
				var $parent = $(this).parent();
				var index = $parent.index();
				var $field = $("#fileField"+mecid);
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
			
			var $originalFile = $("<input id=\"file"+mecid+"\" type=\"file\" name=\"file\" fileNum=\"0\" class=\"upLoadFile\" single=\"single\" data-role=\"none\"/>");
			$originalFile[0].onchange = function(){
				that.preview(p);
			};
			$("#entryBtn"+mecid).append($originalFile);
			$originalFile.focus();
	   	}
	   	reader.readAsDataURL(file.files[0]);
	}
};
