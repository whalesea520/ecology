function getUEInstance (editorid) {
	return UE.getEditor(editorid);
}
var CkeditorExt = {
	NO_IMAGE : 1,
	//获取content
	getHtml : function (editorid) {
		return getUEInstance(editorid).getContent();
	},
	//获取content（不包含html）
	getText : function (editorid) {
		var __contentText = getUEInstance(editorid).getContentTxt();
		if (__contentText != "") {
			return __contentText;
		}

		var _html = getUEInstance(editorid).getContent()
		if (_html.indexOf("<img src=") != -1) {
			return _html;
		}
		return __contentText;
	},
	//设置html
	setHtml : function (html, editorid) {
		getUEInstance(editorid).setContent(html);
	},
	getTextNew : function (editorid) {
		return CkeditorExt.getText(editorid);
	},
	editorName : [], 
	initEditor : function (formid, editorid, languageid, type, height) {
		return UEUtil.initEditor(editorid);
	},
	checkText : function (arg0, editorid) {
		UEUtil.checkRequired(editorid);
	},
	initParse : function (formid, editorid, languageid, type, height) {
		return UEUtil.initParse(editorid);
	},
	updateContent : function (editorid) {
		for(var key in UE.instants){
			try {
				var _ue = UE.instants[key];
				var _html = _ue.getContent();
				_html = _html.replace(/<p><br\/><\/p>/,"").replace(/&nbsp;/,""); 
				_html = _html.replace(/<p>/g, "<p style=\"font-family:'微软雅黑','Microsoft YaHei';font-size:12px;\">");
			    _ue.setContent(_html);
				_ue.sync();
			} catch (_e98) {}
		}
	}, 
	toolbarExpand : function () {}
};

var FCKEditorExt = CkeditorExt;

var UEUtil = {
	initEditor : function (editorid, objparam, width) {
		try {
			var editortgt = jQuery("textarea[name=" + editorid + "]")[0];
			var h = parseInt(editortgt.getAttribute("rows"));
			jQuery(editortgt).css("height", h*30 + "px");
			jQuery(editortgt).css("margin", "5px 5px");
		} catch (e9) {alert(e9);}
		if (window.__ueditready == undefined) {
			 window.__ueditready = 1;
		} else {
			window.__ueditready++;
		}
		if (!!!objparam) {
			objparam = {
				autoFloatEnabled:false,//不保持工具栏位置
				toolbars: [[
		            'fullscreen', 'source', '|',
		            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 
		            'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 
		            'insertorderedlist', 'insertunorderedlist',
		            'lineheight', 'indent','paragraph', '|',
		            'justifyleft', 'justifycenter', 'justifyright', '|',
		            'insertimage', 'inserttable', '|',
		            'link', 'unlink', 'anchor', '|', 
		            'map', 'insertframe', 'background', 'horizontal',  'spechars', '|',
		            'removeformat', 'formatmatch','pasteplain', '|',
		            'undo', 'redo', '|', 
		        ]], initialStyle : "p{font-family:Microsoft YaHei; font-size:12px;}"
			};
		}	
		var _ue = UE.getEditor(editorid, objparam);
		//只有必填的字段才去绑定事件
			this.bindEvent(editorid);
		jQuery("div#" + editorid).css("width", "");
		jQuery("div#" + editorid).children("div .edui-default").css("width", "");
		
		_ue.addListener('ready', function(){
			try {
				__insertimage(_ue, "insertimage");
			} catch(e_i) {}
			window.__ueditready--;
			if (window.__ueditready == 0) {
				window.__htmlhasuedit = false;
			}
		});
		return _ue;
	},
	initHtmlEditor : function (editorid, objparam, width) {
		try {
			var editortgt = jQuery("textarea[name=" + editorid + "]")[0];
			var h = parseInt(editortgt.getAttribute("rows"));
			jQuery(editortgt).css("height", h*30 + "px");
		} catch (e9) {alert(e9);}
		
		if (!!!objparam) {
			objparam = {
				autoFloatEnabled:false,//不保持工具栏位置
				toolbars: [[
		            'fullscreen', 'source', '|',
		            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 
		            'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 
		            'insertorderedlist', 'insertunorderedlist',
		            'lineheight', 'indent','paragraph', '|',
		            ,'justifyleft', 'justifycenter', 'justifyright', '|',
		            'link', 'unlink', 'anchor', '|', 
		            'insertimage', 'map', 'insertframe', 'background', 'horizontal',  'spechars', '|',
		            'inserttable', 'deletetable', 'insertparagraphbeforetable', 'insertrow', 'deleterow', 'insertcol', 'deletecol','|',
		            'removeformat', 'formatmatch','pasteplain', '|',
		            'undo', 'redo', '|'
		        ]], initialStyle : "p{font-family:Microsoft YaHei; font-size:12px;}"
			};
		}	
		var _ue = UE.getEditor(editorid, objparam);
			this.bindEvent(editorid);
		jQuery("div#" + editorid).css("width", "");
		jQuery("div#" + editorid).children("div .edui-default").css("width", "");
		
		_ue.addListener('ready', function(){
			try {
				__insertimage(_ue, "insertimage");
			} catch(e_i) {}
		});
		
		return _ue;
	},
	bindEvent : function (editorid) {
		var _ue = getUEInstance(editorid);
        _ue.addListener('contentChange', function(){
        	var editortgt = jQuery("textarea[name=" + editorid + "]")[0];
        	if(editortgt.getAttribute("viewtype") == "1"){
		   		UEUtil.checkRequired(editorid);
        	}
		});
	},
	initRemark : function (editorid) {
		//转发页面特殊处理
		if (window.__isremarkPage == true) {
			jQuery("#"+editorid).css("height", "170px");
		}
		var _ue = UE.getEditor(editorid, {
			 autoFloatEnabled:false,//不保持工具栏位置
			 allowDivTransToP:false,//不把div自动转为p
			 disabledTableInTable:false,//允许table嵌套
			 autoHeightEnabled : (window.__isremarkPage == true ? false : true),
       		 toolbars: [[
	            'fullscreen', 'source', '|',
	            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 
	            'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 
	            'insertorderedlist', 'insertunorderedlist','indent', '|',
	            ,'justifyleft', 'justifycenter', 'justifyright', '|',
	            'link', 'unlink', 'insertimage', 'inserttable', '|',  'undo', 'redo','|'
	        ]], theme : "metro", initialStyle : "p{font-family:Microsoft YaHei; font-size:12px;}"
       	});
       	this.bindEvent(editorid);
       	_ue.addListener('ready', function(){
			try {
				__insertimage(_ue, "insertimage");
				var fieldannexuploadname = jQuery("#field-annexupload-name").val();
				if(fieldannexuploadname == "" || fieldannexuploadname == null){
					__fileupload(_ue, "wfannexbutton");
				}
				jQuery(".edui-for-wfphrasebutton").children("div").children("div").children("div").children(".edui-label").html("<span style='cursor:pointer;line-height:20px;color:#949292!important;'>"+SystemEnv.getHtmlNoteName(3998)+"</span>");
				var fieldannexuploadcount = jQuery("#field-annexupload-count").val();
				
				if( fieldannexuploadcount > 0)
				{
					try {
			   			var _targetobj = jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro");
			        	if (document.getElementById("field-annexupload").value != '') {
			        		_targetobj.addClass("wfres_1_slt");
			        		_targetobj.removeClass("wfres_1");
			        	} else {
			        		_targetobj.addClass("wfres_1");
			        		_targetobj.removeClass("wfres_1_slt");
			        	}
			        } catch (e) {}
			        jQuery("#fsUploadProgressfileuploaddiv").attr("banfold","0");
				}
				
				
			} catch (e_4) {}
			window._isremarkcomp = true;
		});
       	_ue.addListener('selectionchange', function(){
       		try {
	        	if (jQuery("#_signinputphraseblock").is(":visible")) {
					jQuery("#_signinputphraseblock").hide();
					jQuery("#_addPhrasebtn").show()
					jQuery("#cg_splitline").show();
					jQuery("#addphraseblock").hide();
				}
	        	var showfor = jQuery("#_fileuploadphraseblock").attr("showfor");
	        	var banfold = jQuery("#fsUploadProgressfileuploaddiv").attr("banfold");
	        	var _filetop = jQuery("#_fileuploadphraseblock").offset().top;
	        	if (_filetop > 0 && showfor != "1" && banfold != "1") {
	        		jQuery("#_fileuploadphraseblock").css("top","-500px");
	        		jQuery("#fsUploadProgressfileuploaddiv").css("top","-500px");
				}else{
					jQuery("#_fileuploadphraseblock").attr("showfor","0");
				}
			} catch (e45) {
			}
		});
       	
       	return _ue;
	},
	checkRequired : function (editorid){
		try {
			var sImg='<img src="/images/BacoError_wev8.gif" align="absMiddle">'; 
			var editortgt = jQuery("textarea[name=" + editorid + "]")[0];
			if(editortgt.getAttribute("viewtype")=="1"){
				var html = getUEInstance(editorid).getContent();
				if(jQuery.trim(html) == "") {
					if ($G(editorid + "span")) {
						$G(editorid + "span").innerHTML = sImg;
					} else {
						$G(editorid + "Span").innerHTML = sImg;
					}
				} else {
					if ($G(editorid + "span")) {
						$G(editorid + "span").innerHTML = "";
					} else {
						$G(editorid + "Span").innerHTML = "";
					}
				}
			}
		} catch (e) {}
	},
	initParse : function (editorid, objparam, width) {
		//
		try {
			var editortgt = jQuery("textarea[name=" + editorid + "]")[0];
			var h = parseInt(editortgt.getAttribute("rows"));
			jQuery(editortgt).css("height", h*30 + "px");
		} catch (e9) {alert(e9);}
		
		if (!!!objparam) {
			 objparam = {
			 autoFloatEnabled:false,//不保持工具栏位置
			 allowDivTransToP:false,//不把div自动转为p
			 disabledTableInTable:false,//允许table嵌套
       		 toolbars: [[
	            'fullscreen', 'source', '|',
	            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 
	            'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 
	            'insertorderedlist', 'insertunorderedlist','indent', '|'
	            ,'justifyleft', 'justifycenter', 'justifyright', '|',
	            'link', 'unlink', 'insertimage', 'inserttable', '|'
	         ]], theme : "metro", initialStyle : "p{font-family:Microsoft YaHei; font-size:12px;}"
			};
		}	
		var _ue = UE.getEditor(editorid, objparam);
		jQuery("div#" + editorid).css("width", "");
		this.bindEvent('phraseDesc');
		jQuery("div#" + editorid).children("div .edui-default").css("width", "");
		_ue.addListener('ready', function(){
			try {
				__insertimage(_ue, "insertimage");
			} catch(e_i) {}
		});
		return _ue;
	}
};


function __insertimage(editor,uiName){
   //唯一标识uuid对象
   function UUID() {
     this.id = this.createUUID();
	}
	UUID.prototype.valueOf = function () {
		return this.id;
	}
	UUID.prototype.toString = function () {
		return this.id;
	}
    UUID.prototype.createUUID = function () {
		var dg = new Date(1582, 10, 15, 0, 0, 0, 0);
		var dc = new Date();
		var t = dc.getTime() - dg.getTime();
		var h = '-';
		var tl = UUID.getIntegerBits(t, 0, 31);
		var tm = UUID.getIntegerBits(t, 32, 47);
		var thv = UUID.getIntegerBits(t, 48, 59) + '1'; // version 1, security version is 2
		var csar = UUID.getIntegerBits(UUID.rand(4095), 0, 7);
		var csl = UUID.getIntegerBits(UUID.rand(4095), 0, 7);
		var n = UUID.getIntegerBits(UUID.rand(8191), 0, 7) +
			UUID.getIntegerBits(UUID.rand(8191), 8, 15) +
			UUID.getIntegerBits(UUID.rand(8191), 0, 7) +
			UUID.getIntegerBits(UUID.rand(8191), 8, 15) +
			UUID.getIntegerBits(UUID.rand(8191), 0, 15); // this last number is two octets long
		return tl + h + tm + h + thv + h + csar + csl + h + n;
	}
	UUID.getIntegerBits = function (val, start, end) {
		var base16 = UUID.returnBase(val, 16);
		var quadArray = new Array();
		var quadString = '';
		var i = 0;
		for (i = 0; i < base16.length; i++) {
			quadArray.push(base16.substring(i, i + 1));
		}
		for (i = Math.floor(start / 4); i <= Math.floor(end / 4); i++) {
			if (!quadArray[i] || quadArray[i] == '') quadString += '0';
			else quadString += quadArray[i];
		}
		return quadString;
	}
	UUID.returnBase = function (number, base) {
		var convert = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
		if (number < base) var output = convert[number];
		else {
			var MSD = '' + Math.floor(number / base);
			var LSD = number - MSD * base;
			if (MSD >= base) var output = this.returnBase(MSD, base) + convert[LSD];
			else var output = convert[MSD] + convert[LSD];
		}
		return output;
	}
	UUID.rand = function (max) {
		return Math.floor(Math.random() * max);
	}

    //swf上传对象
	var swfu;
    var splitcharImg = "////~~weaversplit~~////"
	function init(uuid) {
		var language = "7";
		var btnwidth = language==8?86:35;
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
			upload_url: "/docs/reply/upload/UploadForReplyImage.jsp",
			post_params:{"method":"uploadFile"},
			use_query_string : true,//要传递参数用到的配置
			file_size_limit : "100 MB",
			file_types : "*.jpg;*.gif;*.png;",
			file_types_description : "image file,flash file,flv file,mp3 file",
			file_upload_limit : 50,
			file_queue_limit : 0,
			custom_settings : {
				progressTarget : "fsUploadProgress_"+uuid,
				cancelButtonId : "btnCancel"
			},
			debug: false,

			// Button settings
		button_image_url : "",
		secid : window._secid,
		button_placeholder_id : uuid,
		button_width: 19,
		button_height: 19,
		button_text: '',
		button_text_style: '',
		button_text_top_padding: 0,
		button_text_left_padding: 0,
		button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
		button_cursor: SWFUpload.CURSOR.HAND,
		file_queued_handler : fileQueued,
		file_queue_error_handler : fileQueueError,
		file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
			var editoroffset = jQuery(editor.iframe).offset();
			if (numFilesSelected > 0) {		
				if(editor.queryCommandState("source")===0){	
				   var process = jQuery("#fsUploadProgress_"+uuid);
				   if(process.length===0){
					   process=jQuery("<div  style='position:absolute;left:10px;top:10px;z-index: 100;'  id='fsUploadProgress_"+uuid+"'></div>");
					   jQuery(document.body).append(process);
				   }
                   process.css("left",editoroffset.left);
				   process.css("top",editoroffset.top);
				   process.show();
				   this.startUpload();
				}else
				   window.top.Dialog.alert("请将编辑器切换到可视化模式！");
			}
		},
		upload_start_handler : uploadStart,
		upload_progress_handler : uploadProgress,
		upload_error_handler : uploadError,
		upload_success_handler : function (file, server_data) {
			var img="<img style='max-width: 60px; max-height: 60px;' onclick='playImgs(this);' src='/weaver/weaver.docs.docs.reply.FileDownload?docid="+docid+"&fileid="+jQuery.trim(server_data)+"' alt='"+jQuery.trim(file.name)+"'/>";
			//插入图片
			editor.execCommand('inserthtml',img);
			$("#imgFileids").val($("#imgFileids").val()+","+jQuery.trim(server_data));
			$("#imgFilenames").val($("#imgFilenames").val()+splitcharImg+jQuery.trim(file.name));
		},
		upload_complete_handler : function(){
		     var process = jQuery("#fsUploadProgress_"+uuid);
             process.html("");
		},
		queue_complete_handler : function(){
		
		}	// Queue plugin event
		};
		
		swfu = new SWFUpload(settings);
	}
	
	function showImgDialog(path)
	{
		
	}

	 //创建上传按钮
	function createUploader(){
      var flag=false;
	  var container = jQuery(editor.container);
      var crmbutton=container.find(".edui-for-insertimage");
	  
      if(crmbutton.length===0){
	     setTimeout(function(){createUploader();},200);
	  }else{
         if(crmbutton.length>1){
         	var len=crmbutton.length,buttons=crmbutton;
         	 crmbutton=jQuery(crmbutton.eq(0));
             for(var i=1;i<len;i++){
                 //jQuery(buttons[i]).remove();
             	 jQuery(buttons[i]).html('');
                 jQuery(buttons[i]).hide();
             }
         }
          jQuery("#remarkShadowDivInnerDiv").click(function(){
		      if(container.parents(".remarkDiv").is(":visible")){
			      position=crmbutton.position();
		          placehoder.css("left",position.left+4);
		          placehoder.css("top",position.top+3);
			  }
		  });

		 if(container.parents(".remarkDiv").length===1  &&  !container.parents(".remarkDiv").is(":visible")){
			 container.parents(".remarkDiv").show();
			 flag=true;
		 }
        var position=crmbutton.position();
        if(position.left < 0)
	    {
	      	createUploader();
	    }
		crmbutton.css("visibility","hidden");
		var uuid = new UUID();
        var placehoder=jQuery("<div title="+SystemEnv.getHtmlNoteName(3568)+" style='width:20px;height:20px;position:absolute;z-index:10000;background-image:url(/ueditor/themes/metro/images/icons_wev8.png);background-position: -726px -77px;border:1px solid transparent;'><span id='"+uuid+"'></span></div>");
        placehoder.css("left",position.left+4);
		placehoder.css("top",position.top+3);
		placehoder.addClass("e8fileupload")
	 	container.append(placehoder);

		placehoder.hover(function hoverin(){
            placehoder.css("background-color","#fff5d4");
            placehoder.css("border-color","#dcac6c");
		},function hoverout(){
		    placehoder.css("background-color","");
            placehoder.css("border-color","transparent");
		});
		init(uuid);
        
		//窗口大小变化
        jQuery(window).resize(function(){
		     position=crmbutton.position();
		     placehoder.css("left",position.left+4);
		     placehoder.css("top",position.top+3);
		});

		if(flag){
		   container.parents(".remarkDiv").hide();
		}

	  }
	}
	
	setTimeout(function(){createUploader();},200);
}

function initremarkat(ifr) {
	var initat = function (ifr) {
		try {
			var datas = window.__atdata;
			if (window.__atdataready != true || !!!datas) {
				setTimeout(function () {
					initat(ifr);
				}, 1000);
				return ;
			}
			
			var allatids = ",";
	        var names = jQuery.map(datas, function(value, i) {
	        	if (allatids.indexOf("," + value.uid + ",") == -1) { 
		        	allatids += value.uid + ",";
		            return {'id':value.uid,'name':value.data, 'py':value.datapy};
	            }
	        });
		    var at_config = {
		        at: "@",
		        data: names,
		        tpl: "<li data-value='@${name}'>${name}</li>",
		        insert_tpl: "<a href='/hrm/HrmTab.jsp?_fromURL=HrmResource&id=${id}' atsome='@${id}' contenteditable='false' style='cursor:pointer;text-decoration:none !important;margin-right:8px;' target='_blank'>${atwho-data-value}</a>", 
		        limit: 200,
		        show_the_at: true,
		        start_with_space : false,
		        with_repeat_matcher : false,
		        search_key_py : 'py'
		    }
		
			ifrBody = ifr.contentDocument.body
		    jQuery(ifrBody).atwho('setIframe', ifr).atwho(at_config)
		    var atwhoblockobj = jQuery(".atwho-view");
		    atwhoblockobj.perfectScrollbar({horizrailenabled:false,zindex:11111});
		    //atwhoblockobj.addClass("ac_results");
		    //atwhoblockobj.css("width", "150px!important");
		    //atwhoblockobj.removeClass("atwho-view");
	    } catch (e) {}
	}
	
	if (window.location.href.indexOf("AddRequestIframe.jsp") == -1) {
		initat(ifr);
	}
}
var x=0;
function __fileupload(editor,uiName){
	   //唯一标识uuid对象
	   function UUID() {
	     this.id = this.createUUID();
		}
		UUID.prototype.valueOf = function () {
			return this.id;
		}
		UUID.prototype.toString = function () {
			return this.id;
		}
	    UUID.prototype.createUUID = function () {
			var dg = new Date(1582, 10, 15, 0, 0, 0, 0);
			var dc = new Date();
			var t = dc.getTime() - dg.getTime();
			var h = '-';
			var tl = UUID.getIntegerBits(t, 0, 31);
			var tm = UUID.getIntegerBits(t, 32, 47);
			var thv = UUID.getIntegerBits(t, 48, 59) + '1'; // version 1, security version is 2
			var csar = UUID.getIntegerBits(UUID.rand(4095), 0, 7);
			var csl = UUID.getIntegerBits(UUID.rand(4095), 0, 7);
			var n = UUID.getIntegerBits(UUID.rand(8191), 0, 7) +
				UUID.getIntegerBits(UUID.rand(8191), 8, 15) +
				UUID.getIntegerBits(UUID.rand(8191), 0, 7) +
				UUID.getIntegerBits(UUID.rand(8191), 8, 15) +
				UUID.getIntegerBits(UUID.rand(8191), 0, 15); // this last number is two octets long
			return tl + h + tm + h + thv + h + csar + csl + h + n;
		}
		UUID.getIntegerBits = function (val, start, end) {
			var base16 = UUID.returnBase(val, 16);
			var quadArray = new Array();
			var quadString = '';
			var i = 0;
			for (i = 0; i < base16.length; i++) {
				quadArray.push(base16.substring(i, i + 1));
			}
			for (i = Math.floor(start / 4); i <= Math.floor(end / 4); i++) {
				if (!quadArray[i] || quadArray[i] == '') quadString += '0';
				else quadString += quadArray[i];
			}
			return quadString;
		}
		UUID.returnBase = function (number, base) {
			var convert = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
			if (number < base) var output = convert[number];
			else {
				var MSD = '' + Math.floor(number / base);
				var LSD = number - MSD * base;
				if (MSD >= base) var output = this.returnBase(MSD, base) + convert[LSD];
				else var output = convert[MSD] + convert[LSD];
			}
			return output;
		}
		UUID.rand = function (max) {
			return Math.floor(Math.random() * max);
		}

	    //swf上传对象
		var oUploadannexupload;
		
		var splitchar = "////~~weaversplit~~////"
		function init(uuid) {
			var annexmainId = jQuery("#annexmainId").val();
			var annexsubId = jQuery("#annexsubId").val();
			var annexsecId = jQuery("#annexsecId").val();
			var fileuserid = jQuery("#fileuserid").val();
			var fileloginyype = jQuery("#fileloginyype").val();
			var language = "7";
			var btnwidth = language==8?86:35;
			var settings = {
				flash_url : "/js/swfupload/swfupload.swf",
				upload_url: "/docs/reply/upload/UploadForReplyImage.jsp",
				post_params:{"method":"uploadFile",
					"mainId": annexmainId,
					"subId": annexsubId,
					"secId": annexsecId,
					"userid": fileuserid,
					"logintype": fileloginyype
				},
				use_query_string : true,//要传递参数用到的配置
				file_size_limit : "100 MB",
				file_types : "*.*",
				file_types_description : "All Files",
				file_upload_limit : 50,
				file_queue_limit : 0,
				custom_settings : {
					progressTarget : "fsUploadProgressfileupload",
					cancelButtonId : "fileCancel"
				},
				debug: false,

				// Button settings
			button_image_url : "",
			secid : window._secid,
			button_placeholder_id : uuid,
			button_width: 18,
			button_height: 18,
			button_text: '',
			button_text_style: '',
			button_text_top_padding: 0,
			button_text_left_padding: 0,
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
				
			file_queued_handler : fileQueued,
			file_queue_error_handler : fileQueueError,
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
				var editoroffset = jQuery(editor.iframe).offset();
				if (numFilesSelected > 0) {		
					if(editor.queryCommandState("source")===0){	
					   var container = jQuery(editor.container);
					   container.find(".edui-for-wfannexbutton").css("visibility","visible");
					   container.find(".edui-for-wfannexbutton").css("cursor","pointer");
					   container.find(".edui-for-wfannexbutton").css("z-index","101");
					   jQuery("#promptinformation").html("");
					   var el = jQuery(".edui-for-wfannexbutton");
			           var px=el.offset().left;
				       var py=el.offset().top + 17;
				       jQuery("#fsUploadProgressfileuploaddiv").css({"top":py + "px", "left":px+"px"});
					   jQuery("#field-annexupload-count").val(numFilesQueued);
					   jQuery("#fsUploadProgressfileuploaddiv").attr("banfold","1");
					   enableAllmenu();
					   this.startUpload();
					}else
					   window.top.Dialog.alert("请将编辑器切换到可视化模式！");
				}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,
			upload_error_handler : uploadError,
			upload_success_handler : function (file, server_data) {
				var rtvids = "";
				var rtvnames = "";
				var rtvsizes = "";
				if (!!file) {
					if (rtvids == "") {
						rtvids = jQuery.trim(server_data);
						rtvnames = jQuery.trim(file.name);
						rtvsizes = file.size;
					} else {
						rtvids += "," + jQuery.trim(server_data);
						rtvnames += splitchar + jQuery.trim(file.name);
						rtvsizes += splitchar + file.size;
					}
				}
				var fieldannexuploadid = jQuery.trim(jQuery("#field-annexupload").val());
				var fieldannexuploadidname = jQuery.trim(jQuery("#field-annexupload-name").val());
				if(fieldannexuploadid != "" && fieldannexuploadid !=null){
					jQuery("#field-annexupload").val(fieldannexuploadid+","+jQuery.trim(rtvids));
					jQuery("#field-annexupload-name").val(fieldannexuploadidname+splitchar+jQuery.trim(rtvnames));
				}else{
					jQuery("#field-annexupload").val(jQuery.trim(rtvids));
					jQuery("#field-annexupload-name").val(jQuery.trim(rtvnames));
				}
			},
			upload_complete_handler : function(){
				
				var fieldannexuploadcount = jQuery("#field-annexupload-count").val();
				x++;
				if(x == fieldannexuploadcount){
					jQuery("#fsUploadProgressfileupload").html("");
					jQuery("#fsUploadProgressfileuploaddiv").css("top","-500px");
					try {
	           			var _targetobj = jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro");
		            	if (document.getElementById("field-annexupload").value != '') {
		            		_targetobj.addClass("wfres_1_slt");
		            		_targetobj.removeClass("wfres_1");
		            	} else {
		            		_targetobj.addClass("wfres_1");
		            		_targetobj.removeClass("wfres_1_slt");
		            	}
		            } catch (e) {}
		            jQuery("#fsUploadProgressfileuploaddiv").attr("banfold","0");
		            addli();
		            
					displayAllmenu();
				}
			},
			queue_complete_handler : function(){
			
			}
			};
			
			oUploadannexupload = new SWFUpload(settings);
		}

		 //创建附件上传按钮
		function createFieldUploader(){
	      var flag=false;
		  var container = jQuery(editor.container);
	      var crmbutton=container.find(".edui-for-wfannexbutton");
	      if(crmbutton.length===0){
	    	  setTimeout(function(){
	    		  try {
	    			  createUploader();
	    		  } catch (e) {}
	    	  },200);
		  }else{
	         if(crmbutton.length>1){
	         	var len=crmbutton.length,buttons=crmbutton;
	         	 crmbutton=jQuery(crmbutton.eq(0));
	             for(var i=1;i<len;i++){
	                 //jQuery(buttons[i]).remove();
	             	 jQuery(buttons[i]).html('');
	                 jQuery(buttons[i]).hide();
	             }
	         }
	          jQuery("#remarkShadowDivInnerDiv").click(function(){
			      if(container.parents(".remarkDiv").is(":visible")){
				      position=crmbutton.position();
			          placehoder.css("left",position.left+3);
			          placehoder.css("top",position.top+3);
				  }
			  });

			 if(container.parents(".remarkDiv").length===1  &&  !container.parents(".remarkDiv").is(":visible")){
				 container.parents(".remarkDiv").show();
				 flag=true;
			 }
	        var position=crmbutton.position();
	        if(position.left < 0)
	        {
	        	createUploader();
	        }
			crmbutton.css("visibility","hidden");
			var uuid = new UUID();
			$("#placehoderDiv").remove();
	        var placehoder=jQuery("<div id='placehoderDiv' title="+SystemEnv.getHtmlNoteName(3457)+" style='width:18px;height:18px;position:absolute;z-index:100;background-image:url(/ueditor/custbtn/images/wf_annex_wev8.png);border:1px solid transparent;'><span id='"+uuid+"'></span></div>");
	        placehoder.css("left",position.left+3);
			placehoder.css("top",position.top+3);
			placehoder.addClass("e8fileupload")
		 	container.append(placehoder);

			placehoder.hover(function hoverin(){
	            placehoder.css("background-color","#fff5d4");
	            placehoder.css("border-color","#dcac6c");
			},function hoverout(){
			    placehoder.css("background-color","");
	            placehoder.css("border-color","transparent");
			});
			
			init(uuid);
	        
			//窗口大小变化
	        jQuery(window).resize(function(){
			     position=crmbutton.position();
			     placehoder.css("left",position.left+3);
			     placehoder.css("top",position.top+3);
			});

			if(flag){
			   container.parents(".remarkDiv").hide();
			}

		  }
		}
		

		function enableAllmenu()
		{
			
		}

		function displayAllmenu()
		{
		}
		
		function addli(){
			var el = jQuery(".edui-for-wfannexbutton");
	        var px=el.offset().left;
		    var py=el.offset().top + 17;
		    jQuery("#_fileuploadphraseblock").css("z-index","999");
		    jQuery("#_fileuploadphraseblock").css({"top":py + "px", "left":px+"px"});
			//jQuery("#_fileuploadphraseblock").show();
				var ids = jQuery.trim(jQuery("#field-annexupload").val());
				var names = jQuery.trim(jQuery("#field-annexupload-name").val());
				var _ul = jQuery("#_fileuploadphraseblock").find("#_filecontentblock ul");
				if(ids != "" && ids != null){
					var fieldcancle = jQuery("#field-cancle").val();
					jQuery("#promptinformation").html("").css("padding","2px");
					if(ids.indexOf(",") > -1){
						var idArray = ids.split(",");
						var nameArray = names.split(splitchar);
						for (var i=0; i<idArray.length; i++) {
					    	var curid = jQuery.trim(idArray[i]);
			                var curname = jQuery.trim(nameArray[i]);
			                if(!checkliid(jQuery.trim(curid))){
			                	_ul.append("<li id='li_"+curid+"' onclick=\"onAddUploadFile("+curid+",'"+curname+"')\" class=\"cg_item\"><span class='cg_detail' style='width:130px;' title='" + curname + "' >" + curname + "</span><a onmouseover=\"showBt("+curid+")\" onmouseout=\"hiddenBt("+curid+")\" onclick=\"deletefile("+curid+",'"+curname+"')\" style=\"float:right;width:10px;height:10px;margin-right:5px;margin-top:8px;background-image:url(/images/ecology8/workflow/annexdel_wev8.png);\" class=\"e8_delClass1\" title='"+fieldcancle+"' ></a></li>");
			                }
					    }
					}else{
						if(!checkliid(jQuery.trim(ids))){
		                	_ul.append("<li id='li_"+ids+"' onclick=\"onAddUploadFile("+ids+",'"+names+"')\" class=\"cg_item\"><span class='cg_detail' style='width:130px;' title='" + names + "'>" + names + "</span><a onmouseover=\"showBt("+ids+")\" onmouseout=\"hiddenBt("+ids+")\" onclick=\"deletefile("+ids+",'"+names+"')\" style=\"float:right;width:10px;height:10px;margin-right:5px;margin-top:8px;background-image:url(/images/ecology8/workflow/annexdel_wev8.png);\" class=\"e8_delClass1\" title='"+fieldcancle+"' ></a></li>");
						}
					}
				}
		    	var _outdiv = jQuery("#_filecontentblock");
		    	var _li = jQuery("#_filecontentblock ul li");
		    	if (_li.length > 4)  {
					jQuery("#_filecontentblock").css("height", "124px");
					jQuery("#_filecontentblock").css("overflow", "hidden");
					jQuery("#_filecontentblock").perfectScrollbar({horizrailenabled:false,zindex:1000});
					_li.show();
				}
		    	if (_li.length == 4)  {
					jQuery("#_filecontentblock").css("height", "94px");
					jQuery("#_filecontentblock").css("overflow","");
				}
		    	if (_li.length == 3)  {
					jQuery("#_filecontentblock").css("height", "64px");
					jQuery("#_filecontentblock").css("overflow","");
				}
		    	if (_li.length == 2)  {
					jQuery("#_filecontentblock").css("height", "34px");
					jQuery("#_filecontentblock").css("overflow","");
				}
		    	if (_li.length == 1)  {
					jQuery("#_filecontentblock").css("height", "34px");
					jQuery("#_filecontentblock").css("overflow","");
				}
		}
		
		setTimeout(function(){createFieldUploader();},200);
}

