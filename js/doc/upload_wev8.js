var dialog = null;
function uploadAttachment(options){
	var url="/docs/docs/DocUploadCommNew.jsp?mode=" +options.mode+"&docid="+options.docid+"&maxUploadImageSize="+options.maxUploadImageSize;
 	if(options.mode!="add") url+="&isEditionOpen="+(parent.isEditionOpen?1:0);
 	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = options.title;
	dialog.Height = 321;
    dialog.isIframe = false;
	dialog.Width = 600;
	dialog.URL = url;
	dialog.show();
}

var docImgs = [];
//var openEditionNewIds = [];
function addDocImgsData(data){
	docImgs.push(data);
}

function addContainer(mode,_window,options){
	//get parentWin's element
	try{
		if(!parentWin._table.openEditionNewIds){
			parentWin._table.openEditionNewIds = [];
		}
	}catch(e){}
	options = jQuery.extend({filesSize:0},options);
	if(!_window)_window=window;
	var _document = _window.document;
	var imageidsExt = jQuery("#imageidsExt",_document).val();
	var imagenamesExt = jQuery("#imagenamesExt",_document).val();
	for(var i=0;i<docImgs.length;i++){
		if((","+imageidsExt+",").indexOf(","+docImgs[i].imgid+",")==-1){
			try{
				parentWin._table.openEditionNewIds.push(docImgs[i].imgid);
			}catch(e){}
			if(imageidsExt){
				imageidsExt = imageidsExt +","+docImgs[i].imgid;
			}else{
				imageidsExt = docImgs[i].imgid;
			}
			if(imagenamesExt){
				imagenamesExt = imagenamesExt +"|"+docImgs[i].name;
			}else{
				imagenamesExt = docImgs[i].name;
			}
		}
	}
	var accCount = parseInt(jQuery("#accCount",_document).text());
	if(!accCount){
		accCount=0;
	}
	jQuery("#accCount",_document).html(accCount+options.filesSize);
	jQuery("#imageidsExt",_document).val(imageidsExt);
	jQuery("#imagenamesExt",_document).val(imagenamesExt);
	try{
		parentWin._table.customParams = imageidsExt;
		if(parentWin._table.delstrs){
			jQuery.ajax({
				url : "/docs/docs/DocgetJsonForAjax.jsp",
				data : {delimageids : parentWin._table.delstrs},
				type : "post",
				dataType : "json",
				success : function(data){
					parentWin._table.customParams+="~~"+data.delimageids;
					parentWin._table.reLoad();
				}
			});
		}else{
			parentWin._table.reLoad();
		}
	}catch(e){}
	if(dialog)dialog.close();
}

function downloadDocImgs(docid,options){
	options = jQuery.extend({
		_window:window,
		id:"",
		emptyMsg:"",
		downloadBatch:1
	},options);
	var _window = options._window;
	var id = options.id;
	var votingId = options.votingId;
	if(!_window)_window=window;
	var _document = _window.document;
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		_window.top.Dialog.alert(options.emptyMsg);
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	if(options.downloadBatch==1){
		if(_window.isEditionOpen) {		
			window.open("/weaver/weaver.file.FileDownload?fieldvalue="+docid+"&delImgIds="+id+"&download=1&downloadBatch="+options.downloadBatch+"&requestid=&votingId="+votingId);
			//parentWin._table.reLoad();
		 }  else {
			window.open("/weaver/weaver.file.FileDownload?fieldvalue="+docid+"&delImgIds="+id+"&download=1&downloadBatch="+options.downloadBatch+"&requestid=&votingId="+votingId);
			//parentWin._table.reLoad();
		 }	
	}else{
		if(_window.isEditionOpen) {		
			window.open("/weaver/weaver.file.FileDownload?fieldvalue="+docid+"&fileid="+id+"&download=1&downloadBatch="+options.downloadBatch+"&requestid=&votingId="+votingId);
			//parentWin._table.reLoad();
		 }  else {
			window.open("/weaver/weaver.file.FileDownload?fieldvalue="+docid+"&fileid="+id+"&download=1&downloadBatch="+options.downloadBatch+"&requestid=&votingId="+votingId);
			//parentWin._table.reLoad();
		 }	
	}
}

function removeDocImgs(docid,options){
	var id = "";
	options = jQuery.extend({
		_window:window,
		id:"",
		emptyMsg:"",
		confirmMsg:"",
		mode:""
	},options);
	var _window = options._window;
	if(!_window)_window=window;
	var _document = _window.document;
	if(!id){
		try{
			id = _xtable_CheckedCheckboxIdForCP();
		}catch(e){}
	}
	if(!id){
		_window.top.Dialog.alert(options.emptyMsg);
		return;
	}
	_window.top.Dialog.confirm(options.confirmMsg,function(){
		var accCount = parseInt(jQuery("#accCount",_document).text());
		if(!accCount){
			accCount=0;
		}
		if(options.mode=="add"){
			if(id.match(/,$/))id = id.substring(0,id.length-1);
			_window.$GetEle("delImageidsExt").value+=id+",";
			var imageidsExt = jQuery("#imageidsExt",_document).val();
			var imagenamesExt = jQuery("#imagenamesExt",_document).val();
			if(imageidsExt)imageidsExt = imageidsExt.split(",");
			if(imagenamesExt)imagenamesExt = imagenamesExt.split("|");
			var _ids = id.split(",");
			for(var i=0;i<_ids.length;i++){
				var idx = jQuery.inArray(_ids[i],imageidsExt);
				imageidsExt.splice(idx,1);
				imagenamesExt.splice(idx,1);
				for(var j=0;j<docImgs.length;j++){
					var imgid = docImgs[j].imgid;
					if(imgid==_ids[i]){
						docImgs.splice(j,1);
						break;
					}
				}
			}
			if(imageidsExt){
				imageidsExt = imageidsExt.join(",");
			}
			if(imagenamesExt){
				imagenamesExt = imagenamesExt.join("|");
			}
			jQuery("#imageidsExt",_document).val(imageidsExt);
			jQuery("#imagenamesExt",_document).val(imagenamesExt);
			try{
				var ids = _xtable_unCheckedCheckboxId();
				if(ids && ids.match(/,$/)){
					ids = ids.substring(0,ids.length-1);
				}
				accCount = ids.split(",").length;
				if(accCount<0)accCount = 0;
				jQuery("#accCount",_document).text(accCount);
				 _table.customParams = ids;
				 _table.reLoad();
			}catch(e){}
			
		}else if(_window.isEditionOpen){
			var imageidsExt = jQuery("#imageidsExt",_document).val();
			var imagenamesExt = jQuery("#imagenamesExt",_document).val();
			if(imageidsExt)imageidsExt = imageidsExt.split(",");
			if(imagenamesExt)imagenamesExt = imagenamesExt.split("|");
			var openEditionNewIds = _table.openEditionNewIds;
			try{
				if(id && id.match(/,$/)){
					id = id.substring(0,id.length-1);
				}
				var _ids = id.split(",");
				accCount = accCount - _ids.length;
				if(accCount<0)accCount = 0;
				jQuery("#accCount",_document).text(accCount);
				for(var i=0;i<_ids.length;i++){
					var idx = jQuery.inArray(_ids[i],imageidsExt);
					if(idx!=-1){
						imageidsExt.splice(idx,1);
						imagenamesExt.splice(idx,1);
					}
					if(openEditionNewIds){
						var __idx = jQuery.inArray(_ids[i],openEditionNewIds);
						if(__idx!=-1){
							openEditionNewIds.splice(__idx,1);
						}
					}
				}
				_table.openEditionNewIds = openEditionNewIds;
			}catch(e){}
			if(imageidsExt){
				imageidsExt = imageidsExt.join(",");
			}
			if(imagenamesExt){
				imagenamesExt = imagenamesExt.join("|");
			}
			jQuery("#imageidsExt",_document).val(imageidsExt);
			jQuery("#imagenamesExt",_document).val(imagenamesExt);
			if(_table.delstrs){
				if(!_table.delstrs.match(/,$/)){
					_table.delstrs+=",";
				}
				_table.delstrs = _table.delstrs+id;
			}else{
				_table.delstrs = id;
			}
			if(_table.delstrs){
				_window.$GetEle("deleteaccessory").value = _table.delstrs;
			}
			if(!openEditionNewIds){
				openEditionNewIds = [];
			}
			jQuery.ajax({
				url : "/docs/docs/DocgetJsonForAjax.jsp",
				data : {delimageids : _table.delstrs},
				type : "post",
				dataType : "json",
				success : function(data){
					_table.customParams = openEditionNewIds.join(",")+"~~"+data.delimageids;
					_table.reLoad();
				}
			});
		}else{
			jQuery.ajax({
				url:"/docs/docs/DocImgsUtil.jsp?method=delImgsOnly&docid="+docid+"&delImgIds="+id,
				type:"get",
				beforeSend:function(){
					e8showAjaxTips(SystemEnv.getHtmlNoteName(3513,readCookie("languageidweaver")),true);
				},
				complete:function(){
					e8showAjaxTips("",false);
					if(id && id.match(/,$/)){
						id = id.substring(0,id.length-1);
					}
					var _ids = id.split(",");
					accCount = accCount - _ids.length;
					if(accCount<0)accCount = 0;
					jQuery("#accCount",_document).text(accCount);
					_table.reLoad();
				}
			});
		}
	});
}