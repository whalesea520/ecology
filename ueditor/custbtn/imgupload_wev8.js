UE.registerUI('insertimage',function(editor,uiName){
   
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
    
	function init(uuid) {
		var language = "7";
		var btnwidth = language==8?86:35;
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
			upload_url: "/docs/docs/DocImgUploadOnlyForPic.jsp",
			post_params:{
				"method":"uploadFile",
				"userid":window.top.udesid||"",
				"usertype":window.top.utype||"",
				"docfiletype":1
			},
			use_query_string : true,//要传递参数用到的配置
			file_size_limit : "100 MB",
			file_types : "*.jpg;*.gif;*.png;*.jpeg;",
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
		button_placeholder_id : uuid,
		button_width: 19,
		button_height: 19,
		button_text: '',
		button_text_style: '',
		button_text_top_padding: 0,
		button_text_left_padding: 0,
		button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
		button_cursor: SWFUpload.CURSOR.HAND,
			
		//button_placeholder_id: "spanButtonPlaceHolder",
		// The event handler functions are defined in handlers.js
		file_queued_handler : fileQueued,
		file_queue_error_handler : fileQueueError,
		//file_dialog_start_handler : fileDialogStartselect,
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
				   window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3567,readCookie("languageidweaver")));
			}
		},
		upload_start_handler : uploadStart,
		upload_progress_handler : uploadProgress,
		upload_error_handler : uploadError,
		upload_success_handler : function (file, server_data) {
			var img="<img  src='/weaver/weaver.file.FileDownload?fileid="+jQuery.trim(server_data)+"' alt=''/>";
			//插入图片
			editor.execCommand('inserthtml',img); 
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

    //注册按钮执行时的command命令，使用命令默认就会带有回退操作
    editor.registerCommand(uiName,{
        execCommand:function(cmd, opt){
             
    	 opt = UE.utils.isArray(opt) ? opt : [opt];
         if (!opt.length) {
             return;
         }
         var me = this,
             range = me.selection.getRange(),
             img = range.getClosedNode(),
             domUtils = UE.dom.domUtils;

         if(me.fireEvent('beforeinsertimage', opt) === true){
             return;
         }

         if (img && /img/i.test(img.tagName) && (img.className != "edui-faked-video" || img.className.indexOf("edui-upload-video")!=-1) && !img.getAttribute("word_img")) {
             var first = opt.shift();
             var floatStyle = first['floatStyle'];
             delete first['floatStyle'];
////                 img.style.border = (first.border||0) +"px solid #000";
////                 img.style.margin = (first.margin||0) +"px";
//                 img.style.cssText += ';margin:' + (first.margin||0) +"px;" + 'border:' + (first.border||0) +"px solid #000";
             domUtils.setAttributes(img, first);
             me.execCommand('imagefloat', floatStyle);
             if (opt.length > 0) {
                 range.setStartAfter(img).setCursor(false, true);
                 me.execCommand('insertimage', opt);
             }

         } else {
             var html = [], str = '', ci;
             ci = opt[0];
             if (opt.length == 1) {
                 str = '<img src="' + ci.src + '" ' + (ci._src ? ' _src="' + ci._src + '" ' : '') +
                     (ci.width ? 'width="' + ci.width + '" ' : '') +
                     (ci.height ? ' height="' + ci.height + '" ' : '') +
                     (ci['floatStyle'] == 'left' || ci['floatStyle'] == 'right' ? ' style="float:' + ci['floatStyle'] + ';"' : '') +
                     (ci.title && ci.title != "" ? ' title="' + ci.title + '"' : '') +
                     (ci.border && ci.border != "0" ? ' border="' + ci.border + '"' : '') +
                     (ci.alt && ci.alt != "" ? ' alt="' + ci.alt + '"' : '') +
                     (ci.hspace && ci.hspace != "0" ? ' hspace = "' + ci.hspace + '"' : '') +
                     (ci.vspace && ci.vspace != "0" ? ' vspace = "' + ci.vspace + '"' : '') + '/>';
                 if (ci['floatStyle'] == 'center') {
                     str = '<p style="text-align: center">' + str + '</p>';
                 }
                 html.push(str);

             } else {
                 for (var i = 0; ci = opt[i++];) {
                     str = '<p ' + (ci['floatStyle'] == 'center' ? 'style="text-align: center" ' : '') + '><img src="' + ci.src + '" ' +
                         (ci.width ? 'width="' + ci.width + '" ' : '') + (ci._src ? ' _src="' + ci._src + '" ' : '') +
                         (ci.height ? ' height="' + ci.height + '" ' : '') +
                         ' style="' + (ci['floatStyle'] && ci['floatStyle'] != 'center' ? 'float:' + ci['floatStyle'] + ';' : '') +
                         (ci.border || '') + '" ' +
                         (ci.title ? ' title="' + ci.title + '"' : '') + ' /></p>';
                     html.push(str);
                 }
             }

             me.execCommand('insertHtml', html.join(''));
         }

         me.fireEvent('afterinsertimage', opt)

        }
    });

    //创建一个button
    var btn = new UE.ui.Button({
        //按钮的名字
        name:uiName,
        //提示
        title:SystemEnv.getHtmlNoteName(3568,readCookie("languageidweaver")),
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-image: url() !important;background-position: 0px 1px;'
        //点击时执行的命令
      //  onclick:function () {
            //这里可以不用执行命令,做你自己的操作也可
      //     editor.execCommand(uiName);
     //   }
    });

	 //创建上传按钮
	function createUploader(){
      var flag=false;
	  var container = jQuery(editor.container);
      var crmbutton=container.find(".edui-for-insertimage");
      if(crmbutton.length===0){
	     createUploader();
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
		crmbutton.css("visibility","hidden");
        var position=crmbutton.position();
		var uuid = new UUID();
        var placehoder=jQuery("<div style='width:19px;height:19px;position:absolute;z-index:10000;background-image:url(/ueditor/custbtn/images/app-imgupload_wev8.png);border:1px solid #fafafa;'><span id='"+uuid+"'></span></div>");
        placehoder.css("left",position.left+4);
		placehoder.css("top",position.top+3);
		placehoder.addClass("e8fileupload")
	 	container.append(placehoder);
		 
		placehoder.hover(function hoverin(){
		    placehoder.css("background-color","#ffe69f");
            placehoder.css("border","1px solid #dcac6c");
		},function hoverout(){
		    placehoder.css("background-color","#fafafa");
            placehoder.css("border","1px solid #fafafa");
		});
		init(uuid);
		//窗口大小变化
        jQuery(window).resize(function(){
		    function setNewPosition(){
		    	position=crmbutton.position();
		    	if(placehoder.css("left")===((position.left+4)+'px')){
		    	   setTimeout(function(){setNewPosition();},200);
		    	}else{
		    		 placehoder.css("left",position.left+4);
				     placehoder.css("top",position.top+3);
		    	}
		    } 
		    setNewPosition();
		     
		});

		if(flag){
		   container.parents(".remarkDiv").hide();
		}

	  }
	}
	
	

	setTimeout(function(){createUploader();},200);

    //当点到编辑内容上时，按钮要做的状态反射
    editor.addListener('selectionchange', function () {
       // var state = editor.queryCommandState(uiName);
     //   if (state == -1) {
      //      btn.setDisabled(true);
      //      btn.setChecked(false);
      //  } else {
      //      btn.setDisabled(false);
      //      btn.setChecked(state);
      //  }
    });

    //因为你是添加button,所以需要返回这个button
    return btn;
}/*index 指定添加到工具栏上的那个位置，默认时追加到最后,editorId 指定这个UI是那个编辑器实例上的，默认是页面上所有的编辑器都会添加这个按钮*/);