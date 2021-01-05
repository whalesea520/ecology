
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<script>

var discussitem;
var btnObj;
var preReplybox;
var editorList={};

function getEditor(editorid){
	return editorList[editorid];
}

function doSave(obj,method){
	if(approvalAtatus=="1"){
	   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83249,user.getLanguage())%>");
	   return;
	}
	btnObj=obj;
	discussitem=$(obj).parents(".discuss_item");
	var remarkarea=discussitem.find("textarea[_editorName=remark_content]");
	var remarkid=remarkarea.attr("_editorid");
	var remark=$("#"+remarkid);
	var editor=getEditor(remarkid);
	
	var remarkValue=getRemarkHtml(remarkid);
	if(remarkValue==""){ //如果内容为空
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%>",function(){
			if(editor)
	           editor.focus();
	        else
	           $("#remarkContentdiv").click();
		});
        return;
	}
	
	$("#remark").val(remarkValue);
	$(obj).attr("disabled","disabled"); //提交时禁用提交按钮 避免重复提交
	jQuery(document.body).focus();
	
	var replayid=discussitem.attr("replayid");
	var oUploader=window[discussitem.find(".uploadDiv").attr("oUploaderIndex")];
	jQuery("#method").val(method);
	
	try{
       if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
         doSaveAfterAccUpload();  //提交回复
       else 
     	 oUploader.startUpload();
	 }catch(e) {
	     doSaveAfterAccUpload(); //提交回复
	 }
}

function doSaveAfterAccUpload(){
	
	var paramnames="id,method,typeid,txtPrincipal,remark,from,isApproval".split(",");
    var param="{";
    for(var i=0;i<paramnames.length;i++){
    	 var value=jQuery("input[name='"+paramnames[i]+"']").val();
    	 param=param+paramnames[i]+":'"+value+"',";
    }
    //附加参数
    discussitem.find("input[type='hidden']").each(function(){
         var element=jQuery(this);
         var name=element.attr("name");
         var value=element.val();
         if(name.indexOf("_temp")!=-1){
         	name=name.substring(0,name.indexOf("_temp"));
         }
         param=param+name+":'"+value+"',";
    });
    
    //匿名
    discussitem.find("input:checked[name=isAnonymous]").each(function(){
    	param=param+"isAnonymous:'1',";
    });
    paramnames="replyType,commentuserid,topdiscussid,replayid,commentuserid".split(",");
    for(var i=0;i<paramnames.length;i++){
    	 var value=discussitem.attr(paramnames[i]);
    	 param=param+paramnames[i]+":'"+value+"',";
    }
    param=param.substr(0,param.length-1)+"}";
    
    var method=jQuery("#method").val();
    //回复评论
    if(method=="doremark"){ 
     	displayLoading(1);
        jQuery.post("CoworkOperation.jsp", eval('('+param+')'),function(data){
        
              var replyType=discussitem.attr("replyType"); 
              var topdiscussid=discussitem.attr("topdiscussid"); 
              
              //加载评论内容
              if(replyType=="comment"){
              	  var discussid=$.trim(data);
              	  $.post("discussOperation.jsp?operation=getComment&discussid="+discussid,function(data){
              	  		cancelReply(btnObj,'comment');
              	  		var commenttr=discussitem.find(".commenttr");
	              	  	commenttr.show();
	              	  	var commentitem=$("<div>"+data+"</div>");
	              	  	commenttr.find(".commentlist").append(coomixImg(commentitem));
	              	  	if(commenttr.find(".commentitem").length>0)
	              	  		commenttr.find(".commentitem:last").prev().addClass("commentline");
	              	  	displayLoading(0);
              	  });
              }else{
              	  //clearRemark();
              	  cancelReply(btnObj,'reply');
              	  toPage(1);
              } 
	 	      
	 	      jQuery(btnObj).attr("disabled","");//恢复提交按钮
	 	      
         });
     }else if(method=="editdiscuss"){ //编辑评论
         jQuery.post("CoworkOperation.jsp", eval('('+param+')'),function(data){
		          displayLoading(0);  //提交等待显示
		          
		          if(jQuery.trim(data)=="1"||jQuery.trim(data)=="2"||jQuery.trim(data)=="3"){ //首先进行是否超过时间判断
		          
			        if(jQuery.trim(data)=="1"){
			           window.top.Dialog.alertt("<%=SystemEnv.getHtmlLabelName(26229 ,user.getLanguage())%>");  //协作有最新回复
			        }   
			        else if(jQuery.trim(data)=="2"){
			           window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131838,user.getLanguage())%>");  //回复时间已经超过10分钟
			           jQuery(".operationTimeOut").hide();
                    }else if(jQuery.trim(data)=="3"){
                       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131836,user.getLanguage())%>");  //回复时间已经超过10分钟
                       jQuery(".operationTimeOut").hide();
                    }
			      }
		          
	 	          toPage(1); //加载第一页内容
	 	          jQuery(btnObj).attr("disabled","");//恢复提交按钮
              });
          jQuery("#method").val("doremark"); //恢复method值
     }
}

function getRemarkHtml(remarkid){
	var editor=getEditor(remarkid);
	if(!editor) return "";
	var editorbody=$(editor.body);
	//过滤编辑内容中可能包含的input button
    editorbody.find("button").remove();
    editorbody.find("input").remove();
    //获取内容中图片大小
	editorbody.find("img").each(function(){
	   var imgWidth=jQuery(this).width();
	   $(this).attr("imgWidth",imgWidth);
	});
	
	var remark=$("#"+remarkid);
	var remarkValue=editor.getContent();
    var sourceState = editor.queryCommandState('source');  // 当前编辑器状态，0：普通模式，1：html模式
	
	if(sourceState == 1) {
        // html模式
        remarkValue = remarkValue.replace(/\n/g,"<br/>");     //替换换行\n
        //remarkValue = htmlEncodeByRegExp(remarkValue);
        remarkValue = stripScriptTag(remarkValue);
     } else {
       remarkValue = remarkValue.replace(/\n/g,"");     //替换换行\n
       remarkValue = remarkValue.replace(/\r/g,"");     //替换单行\r
     }
     
     remarkValue = remarkValue.replace(/\\/g,"\\\\"); //替换斜杠
     remarkValue = remarkValue.replace(/'/g,"\\'");   //转义单引号
     
     return remarkValue;
}

// 过滤html模式里的script标签内容
function stripScriptTag(s) {
    return s.replace(/<script.*?>.*?<\/script>/ig, '');
}

/*显示回复框*/
function showReplay(obj,discussid,replyType,commentuserid,topdiscussid){

   if(preReplybox!=obj){
   		if(preReplybox)
   			cancelReply(preReplybox,'comment');
   		preReplybox=obj;
   }
   
   var discussitem=$(obj).parents(".discuss_item");
   var replaydiv=discussitem.find(".replaydiv");
   replaydiv.show();
   
   var editorId="";
   if(replaydiv.html()==""){
   	   var editorTmp=$("#editorTmp");
   	   //引用添加匿名
   	   if(isCoworkTypeAnonymous == "1" && isAnonymous == "1"){
   	   		editorTmp.find("#isAnonymous_span").html('<input type="checkbox" name="isAnonymous" id="isAnonymous"><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>');
   	   }
   	   
	   replaydiv.html(editorTmp.html().replace(/###/g,topdiscussid));
	   //美化checkbox
	   replaydiv.jNice();
	   
	   editorId="text_"+new Date().getTime();
	   replaydiv.find("textarea[_editorName=remark_content]").attr("id",editorId).attr("_editorid",editorId);
	   highEditor(editorId);
	   if(discussitem.find(".uploadDiv").length>0)
	       bindUploaderDiv(discussitem.find(".uploadDiv"),"relatedacc_temp");
   }else{
   	   editorId=replaydiv.find("textarea[_editorName=remark_content]").attr("_editorid");
   }
   
   var editor=getEditor(editorId);
   editor.focus();
   
   if(replyType=="comment")
   		replaydiv.find(".replay_external").hide();
   else
   		replaydiv.find(".replay_external").show();	 
   
   discussitem.attr("commentuserid",commentuserid);
   discussitem.attr("topdiscussid",topdiscussid);
   discussitem.attr("replayid",discussid);
   discussitem.attr("replyType",replyType);
   
   //显示箭头
   var left=$(obj).offset().left+10;
   var top=$(obj).offset().top+12;
   discussitem.find("div.discuss_arrow").css({"left":left,"top":top}).show();
   
   if(replyType=="comment"){
   		replaydiv.find(".tipcontent").html("<%=SystemEnv.getHtmlLabelName(26965,user.getLanguage())%>");
   		replaydiv.find(".submitBtn").html("<%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%>");
   }else{
   		replaydiv.find(".tipcontent").html("<%=SystemEnv.getHtmlLabelName(83250,user.getLanguage())%>");
   		replaydiv.find(".submitBtn").html("<%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%>");
   }    
   
}

/*隐藏回复框*/
function cancelReply(obj,replytype){
    
   var discussitem=$(obj).parents(".discuss_item");
   var editorid=discussitem.find("textarea[_editorName=remark_content]").attr("_editorid");
   
   var editor=getEditor(editorid);
   if(editorid){
	   if(replytype=="comment"){ //取消评论引用
	   	   editor.destroy();
		   discussitem.find(".replaydiv").hide().html("");
	   }else if(replytype=="edit"){ //取消编辑
	   	   $(document.body).focus(); //避免删除div时 页面焦点丢失
	   	   editor.destroy();
	   	   discussitem.find("#editdiv").remove();
    	   discussitem.find(".discussdiv").show();
	   }else{ //取消回复
		   editor.setContent("");
		   if(discussitem.find(".uploadDiv").length>0)
	       		bindUploaderDiv(discussitem.find(".uploadDiv"),"relatedacc");
	   }
   }
   //隐藏附加操作
   var extendbtn=discussitem.find(".extendbtn");
   if(extendbtn.attr("_status")=="1"){
		extendbtn.click(); 
   }
   
   
   discussitem.find(".externalDiv input[type='hidden']").each(function(){
         var fieldid=$(this).attr("id");
         _writeBackData(fieldid,1,{id:"",name:""},{hasInput:true,replace:true,isSingle:false,isedit:true});
    });
    
   discussitem.find("div.discuss_arrow").hide();
    
   changeCheckboxStatus(discussitem.find("#isAnonymous"),false);
   
}

function resizeImg(){
   $(".discuss_content img").each(function(){
        if(jQuery(this).width()>document.body.clientWidth*0.8)
             jQuery(this).width(document.body.clientWidth*0.8);
   });

   $(".discuss_replayContent img").each(function(){
        if(jQuery(this).width()>document.body.clientWidth*0.6)
             jQuery(this).width(document.body.clientWidth*0.6);
   });
   $(".discuss_commentContent img").each(function(){
        if(jQuery(this).width()>document.body.clientWidth*0.6)
             jQuery(this).width(document.body.clientWidth*0.6);
   });
}

/*附加功能*/
function showExternal(obj){
   var status=$(obj).attr("_status");
   var externalDiv=$(obj).parents(".discuss_item").find(".externalDiv");
   if(status=="1"){
   	  externalDiv.hide();
      jQuery(obj).css("background-image","url('/cowork/images/blue/down_wev8.png')").attr("_status","0");
   }else{
      externalDiv.show();
      jQuery(obj).css("background-image","url('/cowork/images/blue/up_wev8.png')").attr("_status","1");
   }
}

//编辑讨论
function editDiscuss(discussid,replayid){
   if(jQuery("#replay_"+discussid).is(":visible")){
      window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25404,user.getLanguage())%>");
      return ;
    }  
   displayLoading(1,"edit");
   jQuery.post("discussOperation.jsp?operation=edit",{discussid:discussid,typeid:typeid,},function(data){
      if(jQuery.trim(data)=="1"||jQuery.trim(data)=="2"||jQuery.trim(data)=="3"){ //首先进行是否超过时间判断
        displayLoading(0); 
        if(jQuery.trim(data)=="1"){
           window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26229 ,user.getLanguage())%>");  //协作有最新回复
           toPage(1);
        }   
        else if(jQuery.trim(data)=="2"){
           window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131838,user.getLanguage())%>");  //回复时间已经超过10分钟
           jQuery(".operationTimeOut").hide();
        }else if(jQuery.trim(data)=="3"){
           window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131836,user.getLanguage())%>");  //回复时间已经超过10分钟
           jQuery(".operationTimeOut").hide();
        }
        return ;
      }else{ 
        jQuery("#discuss_table_"+discussid).parent().hide();
       
        var discussitem=jQuery("#discuss_div_"+discussid);
	    discussitem.append(data);
	    if(jQuery("#edit_uploadDiv").length>0)
	       bindUploaderDiv(jQuery("#edit_uploadDiv"),"newrelatedacc");
	    
	    
	    var editorId="text_"+new Date().getTime();
	    discussitem.find("textarea[_editorName=remark_content]").attr("id",editorId).attr("_editorid",editorId);
	       
	    highEditor(editorId);
	    displayLoading(0);
      }
   });
 }

/*结束协作*/
function doEnd(){
 	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18899,user.getLanguage())%>",function(){
       	reLoadCoworkList();
	    frmmain.method.value="end";
	 	document.frmmain.submit();
 	});
}
/*打开协作*/
function doOpen(){
  window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18900,user.getLanguage())%>",function(){
 		reLoadCoworkList();
		frmmain.method.value="open";
 		document.frmmain.submit();
 	});
 }

function viewLog(){
    var title="<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage())%>";
	diag=getCoworkDialog(title,680,500);
	diag.URL = "/cowork/CoworkLogView.jsp?id="+coworkid;
	diag.show();
	document.body.click();
}

function doEdit(){
    var title="<%=SystemEnv.getHtmlLabelName(83251,user.getLanguage())%>";
	diag=getCoworkDialog(title,720,550);
	diag.URL = "/cowork/EditCoWork.jsp?id="+coworkid+"&needfresh=1";
	diag.show();
	document.body.click();
}

function editCoworkCallback(id){
	reLoadCoworkList();
	location.reload();
	diag.close();
}

function　reLoadCoworkList(){
	if(from=="cowork")
		window.parent.reLoadCoworkList();
}

//打开附件
function opendoc(showid,versionid,docImagefileid,coworkid){
    openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&coworkid="+coworkid+"&isFromAccessory=true&isfromcoworkdoc=1");
}
//打开附件
function opendoc1(showid,coworkid){
   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&coworkid="+coworkid+"&isfromcoworkdoc=1");
}
//下载附件
function downloads(files,coworkid){
   jQuery("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&coworkid="+coworkid);
}
//打开文档
   function opendoc2(showid,coworkid){ 
   openFullWindowForXtable("/docs/docs/DocDsp.jsp?coworkid="+coworkid+"&id="+showid);
}


function coomixImg(tempdiv){

	tempdiv.find('.discuss_content img').each(function(){
		  initImg(this);
     }); 
     tempdiv.find('.discuss_replayContent img').each(function(){
		  initImg(this);
     }); 
     tempdiv.find('.discuss_commentContent img').each(function(){
		  initImg(this);
     });
     
	return tempdiv;
}

//初始化图片
function initImg(obj){
       var imgWidth=jQuery(obj).attr("imgWidth");
	   if(imgWidth>400)
	      jQuery(obj).width(400);
	   else if(imgWidth==0)
	      jQuery(obj).width(400);   
	   else{
	      if(jQuery(obj).width()>400)
	         jQuery(obj).width(400);
	   }  
	   //alert(imgWidth);
	
	   jQuery(obj).coomixPic({
			path: '/blog/js/weaverImgZoom/images',	// 设置coomixPic图片文件夹路径
			preload: true,		// 设置是否提前缓存视野内的大图片
			blur: true,			// 设置加载大图是否有模糊变清晰的效果
			
			// 语言设置
		    left: '<%=SystemEnv.getHtmlLabelName(26921,user.getLanguage())%>',		// 左旋转按钮文字
		    right: '<%=SystemEnv.getHtmlLabelName(26922,user.getLanguage())%>',		// 右旋转按钮文字
		    source: '<%=SystemEnv.getHtmlLabelName(26923,user.getLanguage())%>',    // 查看原图按钮文字
			hide:'<%=SystemEnv.getHtmlLabelName(26985,user.getLanguage())%>'       //收起
	   });
	
 }
 
//删除评论
function delComment(discussid,obj,type){
	 window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83252,user.getLanguage())%>",function(){
        if(1==type){
          var  method = "delComment";//本人删除
        }else{
          var  method = "logicDelComment";//管理员删除
        }
	 	jQuery.post("CoworkOperation.jsp?method="+method, {"discussid":discussid},function(data){
           if(1==type){
    	 	   var commenttr=$(obj).parents(".commenttr:first");
               var commentitem=$(obj).parents(".commentitem:first");
               commentitem.prev().removeClass("commentline");
               commentitem.remove();
               if(commenttr.find(".commentitem").length==0) commenttr.hide();
           }else{
               toPage(1);
           }
     	});
	 });
}

/*高级编辑器*/
function highEditor(remarkid){
    if(jQuery("#"+remarkid).is(":visible")){
		
	   var editor = UE.getEditor(remarkid,{
	  		 autoFloatEnabled:false,//不保持工具栏位置 
			 allowDivTransToP:false,//不把div自动转为p
			 disabledTableInTable:false,//允许table嵌套
			 autoHeightEnabled:true,
			 height:120,
       		 toolbars: [[
	            'fullscreen', 'source', '|',
	            'bold', 'italic', 'underline', 'strikethrough','forecolor', 'backcolor', '|', 
	            'justifyleft', 'justifycenter', 'justifyright', '|',
	            'link', 'unlink',
	            'inserttable','insertimage','|',
	            'fontfamily', 'fontsize'
	        ]],
	        theme : "metro", 
		    fontfamily:[{
				    label: '',
				    name: 'songti',
				    val: '宋体,SimSun !important'
				}, {
				    label: '',
				    name: 'kaiti',
				    val: '楷体,楷体_GB2312, SimKai !important'
				}, {
				    label: '',
				    name: 'yahei',
				    val: '微软雅黑,Microsoft YaHei !important'
				}, {
				    label: '',
				    name: 'heiti',
				    val: '黑体, SimHei !important'
				}, {
				    label: '',
				    name: 'lishu',
				    val: '隶书, SimLi !important'
				}],
	        focus:true,
	        textarea:remarkid,
	        initialStyle : "p{font-family:Microsoft YaHei; font-size:12px;}"
	   });
	   
	   editorList[remarkid]=editor;
	   
	   if(remarkid=="remarkContent"){
	     jQuery("#highEditorImg").attr("src","/cowork/images/normal_edit_wev8.png");  
	   }  
	}
}

</script>
