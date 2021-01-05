/*
 * imUploader.js - Jquery Image Uploader
 * 改造来自于dmUploader.js
 */

(function($) {
  var pluginName = 'imUploader';

  // These are the plugin defaults values
  var defaults = {
    url: document.URL,
    method: 'POST',
    extraData: {},
    maxFileSize: 0,
    maxFiles: 0,
    allowedTypes: '*',
    extFilter: null,
    dataType: null,
    fileName: 'Filedata',
    onInit: function(){},
    onFallbackMode: function() {message},
    onNewFile: function(id, file){},
    onBeforeUpload: function(id){},
    onComplete: function(){},
    onUploadProgress: function(id, percent){},
    onUploadSuccess: function(id, data){},
    onUploadError: function(id, message){},
    onFileTypeError: function(file){},
    onFileSizeError: function(file){},
    onFileExtError: function(file){},
    onFilesMaxError: function(file){}
  };
  //工具箱
  var Toolkit =
  {
    CHARS: '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split(''),
    getUUID: function(){
      var chars = Toolkit.CHARS, uuid = new Array(36), rnd=0, r;
      for (var i = 0; i < 36; i++) {
        if (i==8 || i==13 ||  i==18 || i==23) {
          uuid[i] = '-';
        } else if (i==14) {
          uuid[i] = '4';
        } else {
          if (rnd <= 0x02) rnd = 0x2000000 + (Math.random()*0x1000000)|0;
          r = rnd & 0xf;
          rnd = rnd >> 4;
          uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
        }
      }
      return uuid.join('');
    },
    getObjLen: function(obj){
      if(!obj){
        return 0;
      }
      var len = 0;
      for(var key in obj){
        ++len;
      }
      return len;
    },
    getObjByIndex: function(obj, index){
      if(!obj){
        return null;
      }
      var pos = 0;
      for(var key in obj){
        if(index === pos){
          return {"key": key, "value": obj[key]};
        }
        ++pos;
      }
      return null;
    }
  };
  //常量
  var Const = (function(){
    var constants = {
      WAIT: 0,
      UPLOADING: 1,
      SUCCESS: 2,
      FAIL: 3
    };
    var ctor = function(args){

    };
    ctor.get = function(name) {
      return constants[name];
    }
    return ctor;
  })();
  //缩略图盒子
  var ThumbBox = function(mainObj, options){
    this.thumb = _getElementObj();
    this.mainObj = mainObj;
    this.fileId = options ? options.fileId : null;
    this.uploadStatus = Const.get('WAIT');
    function _getElementObj(){
      var boxTmpHtml =
          "<div id='thumbboxTmp' class='thumbbox' style='display:none'> " +
          "		<div class='boxClose animated rotateIn'>×</div> " +
          "		<div class='boxProgress' style='display:none'>×</div> " +
          "		<div class='boxPopMsg' style='display:none'>×</div> " +
          "		<img src=''> " +
          "</div> ";
      return $(boxTmpHtml).attr('fileId', this.fileId);
    }
    this.renderBox();
  };
  ThumbBox.prototype.renderBox = function(){
    var mainObj = this.mainObj;
    var file = mainObj.fileQueue[this.fileId];
    var container = mainObj.element;
    var reader = new FileReader();
    var thumbObj = this;
    reader.onload = function(e) {
      var targetRes = e.target.result;
      var clonedObj = thumbObj.thumb.removeAttr('id');
      clonedObj.find('img').attr('src', targetRes);
      container.find('.thumbbox:nth-child(1)').removeClass('leftbox');
      container.prepend(clonedObj.addClass('leftbox').show());
    };
    reader.readAsDataURL(file);
    //绑定关闭事件
    thumbObj.thumb.find(".boxClose").one('click',function(e){
      thumbObj.removeBox();
    });
  };
  ThumbBox.prototype.removeBox = function(){
    var _status = this.uploadStatus;
    if(_status === Const.get('UPLOADING')){
      return;
    }
    var mainObj = this.mainObj;
    var fileId = this.fileId;
    delete mainObj.fileQueue[fileId];
    delete mainObj.boxQueue[fileId];
    this.thumb.remove();
  };
  ThumbBox.prototype.showUploadPercent = function(percent){
    if(percent===100){
      this.status = Const.get("SUCCESS");
    }else{
      this.status = Const.get("UPLOADING");
    }
    //TODO 显示百分比

  };
  ThumbBox.prototype.showMsg = function(content, style){
    var boxPopMsg = this.thumb.find('.boxPopMsg');
    boxPopMsg.text(content.replace(/\n/gim, '').replace(/\r/gim, ''));
    if(style === 'success'){
      boxPopMsg.addClass(style).removeClass("error");
    }else if(style === 'error'){
      boxPopMsg.addClass(style).removeClass("success");
    }
  };
  var ImUploader = function(element, options)
  {
    this.element = $(element);

    this.settings = $.extend({}, defaults, options);

    if(!this.checkBrowser()){
      return false;
    }

    this.init();

    return true;
  };

  ImUploader.prototype.checkBrowser = function()
  {
    if(window.FormData === undefined){
      this.settings.onFallbackMode.call(this.element, 'Browser doesn\'t support Form API');

      return false;
    }

    if(this.element.find('input[type=file]').length > 0){
      return true;
    }

    if (!this.checkEvent('drop', this.element) || !this.checkEvent('dragstart', this.element)){
      this.settings.onFallbackMode.call(this.element, 'Browser doesn\'t support Ajax Drag and Drop');

      return false;
    }

    return true;
  };

  ImUploader.prototype.checkEvent = function(eventName, element)
  {
    var element = element || document.createElement('div');
    var eventName = 'on' + eventName;

    var isSupported = eventName in element;

    if(!isSupported){
      if(!element.setAttribute){
        element = document.createElement('div');
      }
      if(element.setAttribute && element.removeAttribute){
        element.setAttribute(eventName, '');
        isSupported = typeof element[eventName] == 'function';

        if(typeof element[eventName] != 'undefined'){
          element[eventName] = undefined;
        }
        element.removeAttribute(eventName);
      }
    }

    element = null;
    return isSupported;
  };

  ImUploader.prototype.render = function(){
    var container = this.element;
    var widget = this;
    var addBoxHtml =
    "<div class='thumbbox leftbox addbox'> " +
    "		<input id=\"imgAddInput\" type=\"file\"  " +
    "		  		name=\"imgAddInput\" " +
    "		  		target=\"imgAddInput\" class=\"Inputstyle\"  " +
    "		  		multiple=\"true\" accept=\"image/gif, image/jpeg, image/png, image/gif, image/bmp\"> " +
    "		<div class='addInputLayer'></div> " +
    "</div> ";

    container.empty().append(addBoxHtml);
    container.find('.addInputLayer').off().on('click',function(e){
      var obj = $('#imgAddInput').get(0);
      if(obj.fireEvent){
        return obj.fireEvent("onclick");
      }else if(obj.onclick){
        return obj.onclick();
      }else if(obj.click){
        return obj.click();
      }
    });

    //-- Optional File input to make a clickable area
    widget.element.find('input[type=file]').on('change', function(evt){
      var files = evt.target.files;

      widget.queueFiles(files);

      $(this).val('');
    });
  };

  ImUploader.prototype.init = function()
  {
    var widget = this;
    // 存储fileid 和盒子的映射
    widget.boxQueue = new Object();
    // 存储fileid 和file对象的映射
    widget.fileQueue = new Object();
    widget.queuePos = -1;
    widget.queueRunning = false;

    widget.render();
        
    this.settings.onInit.call(this.element);
  };
  ImUploader.prototype.getFileLen = function(){
    return Toolkit.getObjLen(this.fileQueue);
  };
  ImUploader.prototype.queueFiles = function(files)
  {
    var len = Toolkit.getObjLen(this.fileQueue);
    var j = len;
    for (var i= 0; i < files.length; i++)
    {
      var file = files[i];
      var fileId = Toolkit.getUUID();

      // Check file size
      if((this.settings.maxFileSize > 0) &&
          (file.size > this.settings.maxFileSize)){

        this.settings.onFileSizeError.call(this.element, file);

        continue;
      }
      // Check file type
      if((this.settings.allowedTypes != '*') &&
          !file.type.match(this.settings.allowedTypes)){

        this.settings.onFileTypeError.call(this.element, file);

        continue;
      }

      // Check file extension
      if(this.settings.extFilter != null){
        var extList = this.settings.extFilter.toLowerCase().split(';');

        var ext = file.name.toLowerCase().split('.').pop();

        if($.inArray(ext, extList) < 0){
          this.settings.onFileExtError.call(this.element, file);

          continue;
        }
      }
            
      // Check max files
      if(this.settings.maxFiles > 0) {
        if(len + i + 1 > this.settings.maxFiles) {
          this.settings.onFilesMaxError.call(this.element, file);
          continue;
        }
      }

      this.fileQueue[fileId] = file;
      this.fileLen++;
      this.boxQueue[fileId] = new ThumbBox(this, {"fileId": fileId});

      //var index = len - 1;
    }

    // Only start Queue if we haven't!
    if(this.queueRunning){
      return false;
    }

    // and only if new Failes were successfully added
    //if(len== j){
    //  return false;
    //}

    //this.processQueue();

    return true;
  };
  //判断是否所有文件都上传（其中包括上传失败的）
  ImUploader.prototype.isAllFileQueued = function(){
    var widget = this;
    var FLAG = true;
    for(var fileId in widget.fileQueue){
      if(fileId){
        var thumbBox = widget.boxQueue[fileId];
        if(thumbBox){
          if(thumbBox.uploadStatus === Const.get('WAIT') || thumbBox.uploadStatus === Const.get('UPLOADING')){
            FLAG = false;
          }
        }
      }
    }
    return FLAG;
  };
  //触发上传接口
  ImUploader.prototype.processQueue = function()
  {
    var widget = this;

    var len = Toolkit.getObjLen(widget.fileQueue);
    var isComplete = widget.isAllFileQueued();
    if(isComplete){
      // Cleanup
      widget.settings.onComplete.call(widget.element);

      // Wait until new files are droped
      widget.queuePos = (len - 1);

      widget.queueRunning = false;

      return;
    }
    //重置队列下标，保证上传失败的情况下能够重试
    if(widget.queuePos >= len){
      widget.queuePos = -1;
    }
    widget.queuePos++;
    var fileObj = Toolkit.getObjByIndex(widget.fileQueue, widget.queuePos);
    var fileId = fileObj.key;
    var file = fileObj.value;
    var boxObj = this.boxQueue[fileId];
    //只有就绪和失败状态下进行上传操作
    if(boxObj.uploadStatus !== Const.get('WAIT') && boxObj.uploadStatus !== Const.get('FAIL')){
      return;
    }

    // Form Data
    var fd = new FormData();
    fd.append(widget.settings.fileName, file);

    // Return from client function (default === undefined)
    var can_continue = widget.settings.onBeforeUpload.call(widget.element, widget.queuePos);
    
    // If the client function doesn't return FALSE then continue
    if( false === can_continue ) {
      return;
    }

    // Append extra Form Data
    $.each(widget.settings.extraData, function(exKey, exVal){
      fd.append(exKey, exVal);
    });

    widget.queueRunning = true;
	
    // Ajax Submit
    $.ajax({
      url: widget.settings.url,
      type: widget.settings.method,
      dataType: widget.settings.dataType,
      data: fd,
      cache: false,
      contentType: false,
      processData: false,
      forceSync: false,
      xhr: function(){
        var xhrobj = $.ajaxSettings.xhr();
        if(xhrobj.upload){
          xhrobj.upload.addEventListener('progress', function(event) {
            var percent = 0;
            var position = event.loaded || event.position;
            var total = event.total || e.totalSize;
            if(event.lengthComputable){
              percent = Math.ceil(position / total * 100);
            }
            //thumbBox展示
            boxObj.showUploadPercent(percent);
            widget.settings.onUploadProgress.call(widget.element, widget.queuePos, percent);
          }, false);
        }

        return xhrobj;
      },
      success: function (data, message, xhr){
        boxObj.showMsg("上传成功", "success");
        boxObj.uploadStatus = Const.get('SUCCESS');
        widget.settings.onUploadSuccess.call(widget.element, boxObj.thumb, data);
      },
      error: function (xhr, status, errMsg){
        boxObj.showMsg("上传失败", "error");
        boxObj.uploadStatus = Const.get('FAIL');
        widget.settings.onUploadError.call(widget.element, boxObj.thumb, errMsg);
      },
      complete: function(xhr, textStatus){
        widget.processQueue();
      }
    });
  }

  $.fn.imUploader = function(options){
    return this.each(function(){
      if(!$.data(this, pluginName)){
        $.data(this, pluginName, new ImUploader(this, options));
      }
    });
  };
})(jQuery);
