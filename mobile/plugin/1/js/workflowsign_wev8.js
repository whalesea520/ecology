$(function () {
	var windowHeight = document.body.clientHeight  + window.screen.height - window.screen.availHeight;
    $(".signcontent").click(function () {
		doforwardCloseSign();
        dosigncontent();
		$('.morebutton').hide();
		$('#signaddmorebg').hide();
		//jQuery("#signbg").css("height",(parseInt($(document).scrollTop()) + windowHeight - $("#page_remarksign_Title_div").height() + window.screen.height - window.screen.availHeight)+"px");
	});
    $("#signbg").click(function () {
        $("#signbg,.signbox").css("display", "none");
		$(".signbtn3").show();
		$('.morebutton').hide();
		$('#signaddmorebg').hide();
    });

	$(".moredivclose").click(function(){
	       $("#signaddmorebg").hide();
	});

	$(".signaddmore img").click(function(){
		 if($("#signaddmorebg").css("display")=='black'){
			 $("#signaddmorebg").hide();
		 }else{
	         $("#signaddmorebg").show();
		 }
		  $('.morebutton').hide();
	});
	
	$("#userSignRemark").focus(function(){
	     $('.morebutton').hide();
		 $('#signaddmorebg').hide();
		 setInterval("setRedflag()",1000);
		 
	});
	$("#phrase").focus(function(){
	     $('.morebutton').hide();
		 $('#signaddmorebg').hide();
		 //$("#phrase").blur();
	});
	$("#handWrittenSignLi").click(function(){
	    try{
			doHandWriteSign();
		}catch(e){}
        $('#signaddmorebg').hide();
        $('.morebutton').hide();
	});

	$(".ulcancal").click(function(){
	    $("#signbuttonbg").hide();
		$(".signbuttonbox").hide();

	});

	$(".firstImg").click(function(){
	       dosignImgbutton();
	});

	var firstclickhandler = $(".listbtnhandler").first().attr("onclick");
	var firstbtntext = $(".listbtnhandler").first().children(".listbtntext").text();
	if(firstbtntext!=null && firstbtntext!=''){
		 $(".firstButton").html(firstbtntext);
		 $(".firstButton").attr("onclick",firstclickhandler);
	}

});

function doforwardBtn(){
   if($('#forwardresourceids')&&($('#forwardresourceids').val()==null||$('#forwardresourceids').val()=="")){
             doforward();
		}else{
             doforwardShowSign();
             dosigncontent();
		}
}

function dosignImgbutton(){
	var ulli = "";
	$(".listbtnhandler").each(function(){
		 var onclickvar = $(this).attr("onclick");
		 var id = "";
		  var textvar = $(this).children(".listbtntext").text().replace("\&nbsp;","");
		  if(onclickvar.indexOf('doforwardhandler')==-1){
			  if(onclickvar.indexOf('doforward2')!=-1){
				   id = "doforward2";
			  }else if(onclickvar.indexOf('doforward3')!=-1){
				    id = "doforward3";
			  }else if(onclickvar.indexOf('doreject')!=-1){
                    id="doreject";
			  }else if(onclickvar.indexOf('doretract')!=-1){
				  id="doretract";
			  }
              if(id!=''){
				  ulli += " <li id=\""+id+"\" class=\"ullibutton\" onclick=\""+onclickvar+"\">"+textvar+"</li>"; 
			  }else{
			     ulli += " <li class=\"ullibutton\" onclick=\""+onclickvar+"\">"+textvar+"</li>"; 
			  }
		  }
	});
    $(".ulbtnlist").html(ulli);
	$("#signbuttonbg").show();
    $(".signbuttonbox").show();
   $(".ullibutton").mouseover(function(){
	   if($(this).attr("onclick")!=''){
	     $(this).addClass("signbutcur");
	   }
	});

	$(".ullibutton").mouseout(function(){
		if($(this).attr("onclick")!=''){
	       $(this).removeClass("signbutcur");
		}
	});
}

$(document).ready(function(){
	 $(".signbox").show();
	 adjustmentBtn();
	  $(".signbox").hide();
	  /*try{
		  if(jQuery("#onlyforwardButton").val()=='true'){
			var signmenuwidth=jQuery(".signmenu").width();
		    jQuery(".signbtn").css("right",(signmenuwidth/2)+"px");
		  }
	  }catch(e){
	  }*/
});

function dosigncontent(){
      $("#signbg").css({
            display: "block"
        });
        var $box = $('.signbox');
		$box.slideDown("fast");
		$(".signbtn3").hide();
}

function doforwardShowSign(){
    $(".listfordwardbtnimg").show();
	$(".listfordwardbtntext").show();
	$(".haschosespan").show();
	$(".listbtnimg").hide();
    $(".listbtntext").hide();
	$(".listbtntextmore").hide();
	$(".signlistbtnimg").hide();
    $("#signbuttonbg").hide();
    $(".signbuttonbox").hide();
	var listfordwardbtntext=$(".listfordwardbtntext").text();
	$(".signbtnforwardopration").html(" <div id=\"doforward\" class=\"ulbottomonebtn\" onclick=\"doforwardhandler();\">"+listfordwardbtntext+"</div>");
    $(".signbtnforwardopration").show();
	$(".signbtnopration").hide();
	
}

function doforwardCloseSign(){
    $(".listfordwardbtnimg").hide();
	$(".listfordwardbtntext").hide();
	$(".signbtnforwardopration").hide();
	$(".signbtnopration").show();
	$(".haschosespan").hide();
    $(".listbtnimg").each(function(){
		  if(jQuery(this).attr("overhide")&&jQuery(this).attr("overhide")=='1'){
			   jQuery(this).hide();
		  }else{
			    jQuery(this).show();
		  }
	});
	 $(".listbtntext").each(function(){
		  if(jQuery(this).attr("overhide")&&jQuery(this).attr("overhide")=='1'){
			  jQuery(this).hide();
		  }else{
			   jQuery(this).show();
		  }
	});
	$(".listbtntextmore").show();
	$(".signlistbtnimg").show();

}


function adjustmentBtn(){
	var rowindex=0;
	var rowkey=3;
	var btncount = 0;
	var btn0="";
	var btn1="";
	 $(".listbtnhandler").each(function(count){
         $(this).hide();
          var onclickvar = $(this).attr("onclick");
		  var textvar = $(this).children(".listbtntext").text().replace("\&nbsp;","");
		  if(onclickvar.indexOf('doforwardhandler')==-1){
                 if(btncount==0){
                     btn0="<div class=\"ulbottombtn\" onclick=\""+onclickvar+"\">"+textvar+"</div>";
				 }else if(btncount==1){
                     btn1 = "<div class=\"ulbottombtn\" onclick=\""+onclickvar+"\">"+textvar+"</div>";
				 }
				 btncount++;
		  }
		 /*$(this).append("&nbsp;&nbsp;");
		 var topindex = $(this).offset().top;
		 if(count==0){rowindex =topindex;}
		 if(topindex==rowindex){
             rowindex = topindex;
		 }else{
			 rowkey = count;
			 return false;
		 }
		 if(($(".listbtntext").length-1)==count){
			  rowkey = $(".listbtntext").length;
		 }*/
	 });
	 if(btncount == 1){
		 $(".firstButton").css("float","right").css("margin-right","12%");
		 $(".firstImg").hide();
		 btn0 = btn0.replace("ulbottombtn","ulbottomonebtn");
         $(".signbtnopration").html(btn0);
	 }else if(btncount == 2){
          btn0 = btn0.replace("ulbottombtn","ulbottomtwoleftbtn");
		  btn1 = btn1.replace("ulbottombtn","ulbottomtworightbtn");
		  $(".signbtnopration").html(btn0+btn1);
	 }else if(btncount>2){
		 var btnmore="<div class=\"urlbottombtnimg\" onclick=\"dosignImgbutton();\"><img src=\"/mobile/plugin/1/images/btnmorelist.png\"></img></div>";
         $(".signbtnopration").html(btn0+btn1+btnmore);
	 }

	 if(btncount==0){
		  $(".signmenu").hide();
	 }


   /* var signlistbtnwidth= $(".signlistbtn").width();
	var listbtnWidth=0;
	$(".listbtnhandler").each(function(rcount){
		  listbtnWidth += $(this).width();
		  if(listbtnWidth>(signlistbtnwidth-22)){
                rowkey = rcount;
				return false;
		  }
     });

	if($(".listbtnimg").length>rowkey){
		$(".signlistbtnimg").remove();
		$(".listbtntextmore").remove();
		var listbtnstr="";
        $(".listbtnimg").each(function(rowcount){
		   if(rowcount>(rowkey-1) && $(this).parent().attr("onclick")!=''){
			  listbtnstr+=$(this).parent().attr("onclick")+"@";
              $(this).hide();
			  $(this).attr("overhide","1");
		   }
	    });
		var listtextstr="";
		 $(".listbtntext").each(function(rowcount){
		   if(rowcount>(rowkey-1) && $(this).text()!=''){
			  listtextstr+=$(this).text().trim()+"@";
              $(this).hide();
			  $(this).attr("overhide","1");
		   }
	    });
		var ulstr="<ul>";
        var btnarry=listbtnstr.split("@");
        var textarry=listtextstr.split("@");
		for(var i=0;i<btnarry.length;i++){
			  if(btnarry[i]&&btnarry[i]!=''){
				   ulstr +="<li onclick=\""+btnarry[i]+";$('.morebutton').hide();\">"+textarry[i]+"</li>"; 
			  }
		}
		ulstr +="</ul>";


		//$(".signlistbtn").append("<div class=\"signlistbtnimg\" style=\"text-align:center;\" onclick=\"$('.morebutton').show();\"><img src=\"/mobile/plugin/1/images/more_conner.png\" style=\"display:block;margin:0 auto;\"></img><div>");
		$(".signlistbtn").append("<div class=\"signlistbtnimg\" onclick=\"morebutton();\" style='background-image:url(/mobile/plugin/1/images/more_conner.png);background-size: contain;' \"><div>");
	    $(".morebutton").html(ulstr);
	}*/
	
	
}

function morebutton(){
     $('#signaddmorebg').hide();
	 if($('.morebutton').css("display") =='block'){
		    $('.morebutton').hide();
	 }else{
		  $('.morebutton').show();
		
	 }
}

function resetselect(){
	 jQuery("#phrase option[value='0']").attr("selected", "selected");
}


function addBackImges(url,typeurl,idstr){
			 var bgimage= $("#"+idstr).css("background-image");
			 var bgrepeat=$("#"+idstr).css("background-repeat");
			 var bgposition=$("#"+idstr).css("background-position");
			 var bgsize=$("#"+idstr).css("background-size");
			  if(bgimage !='none'){
				  var bgimageReplace=bgimage.replace("url(\"data:image/png;base64,","").replace("url(data:image/png;base64,","");
				 if(bgimageReplace.indexOf(",")>-1){ //存在多张背景图片
					 var bgImagearry =  bgimageReplace.split(",");
					 var bgResultStr="";
					 for(var i=0;i<bgImagearry.length;i++){
						    var bgia=bgImagearry[i];
							if(bgia.indexOf("/weaver/weaver.file.SignatureDownLoad?markId=")==-1){
								if(bgia.indexOf("data:image/png;base64")==-1){
									bgia="url(\"data:image/png;base64,"+bgia;
								} 
							}
							if(bgia.indexOf(typeurl)>-1){
                                  bgResultStr += "url(\""+url+"\")" +",";
							}else{
								bgResultStr += bgia +",";
							}
					 }
					 bgResultStr=bgResultStr.substring(0, bgResultStr.length - 1);
                     $("#"+idstr).css("background-image",bgResultStr);
				 }else{//只有一张背景图片
					 if(bgimage.indexOf(typeurl)>-1){ //已经包含
					     $("#"+idstr).css("background-image","url(\""+url+"\")");
						 $("#"+idstr).css("background-repeat","no-repeat");
						 $("#"+idstr).css("background-position","0 60px");
						 $("#"+idstr).css("background-size","60px 60px");
				     }else{//没有包含
					    $("#"+idstr).css("background-image",bgimage+","+"url(\""+url+"\")");
						$("#"+idstr).css("background-repeat",bgrepeat+",no-repeat");
						$("#"+idstr).css("background-position",bgposition+",0 120px");
						$("#"+idstr).css("background-size",bgsize+",60px 60px");
				     }
				 }
			  }else{
				 $("#"+idstr).css("background-image","url(\""+url+"\")");
				 $("#"+idstr).css("background-repeat","no-repeat");
				 $("#"+idstr).css("background-position","0 60px");
				 $("#"+idstr).css("background-size","60px 60px");
			  }
}

function removeBackImages(url,idstr){
               var bgimage= $("#"+idstr).css("background-image");
			   var bgrepeat=$("#"+idstr).css("background-repeat");
			   var bgposition=$("#"+idstr).css("background-position");
			   var bgsize=$("#"+idstr).css("background-size");
			   if(bgimage!='none'){
				   var bgimageReplace=bgimage.replace("url(\"data:image/png;base64,","").replace("url(data:image/png;base64,","");
				   
                    if(bgimageReplace.indexOf(",")>0){ //多张的时候
						  //图片
						 var bgImagearry =  bgimageReplace.split(",");
						 var bgResultStr="";
						 var countindex;
						 var style="";
						 for(var i=0;i<bgImagearry.length;i++){
								var bgia=bgImagearry[i];
                                if(bgia.indexOf("/weaver/weaver.file.SignatureDownLoad?markId=")==-1){
								    if(bgia.indexOf("data:image/png;base64,")==-1){
										 if(bgimage.indexOf('url(\"data:image/png;base64,')>-1){
											   bgia="url(\"data:image/png;base64,"+bgia;
				                         }
										 if(bgimage.indexOf('url(data:image/png;base64,')>-1){
											   bgia="url(data:image/png;base64,"+bgia;
										 }
								    }
							    }
								if(bgia.indexOf(url)>-1){
									  bgResultStr += "";
									  countindex = i;
								}else{
									  bgResultStr += bgia +",";
								}
						 }
						 bgResultStr = bgResultStr.trim();
						 bgResultStr=bgResultStr.substring(0, bgResultStr.length - 1);
						 style += "background-image:"+bgResultStr+";";
						 //$("#"+idstr).css("background-image",bgResultStr);
						  
						 
						 var bgrepeatarry =  bgrepeat.split(",");
						  var bgRepeatResultStr="";
						 for(var i=0;i<bgrepeatarry.length;i++){
								var bgia=bgrepeatarry[i];
								if(countindex == i){
									  bgRepeatResultStr += "";
								}else{
									  bgRepeatResultStr += bgia +",";
								}
						 }
						  bgRepeatResultStr = bgRepeatResultStr.trim();
						 bgRepeatResultStr=bgRepeatResultStr.substring(0, bgRepeatResultStr.length - 1);
						 style += "background-repeat:"+bgRepeatResultStr+";";
						 //$("#"+idstr).css("background-repeat",bgRepeatResultStr);  

						 var bgpositionarry =  bgposition.split(",");
						  var bgPosResultStr="";
						 for(var i=0;i<bgpositionarry.length;i++){
								var bgia=bgpositionarry[i];
								if(countindex == i){
									  bgPosResultStr += "";
								}else{
									  bgPosResultStr += bgia +",";
								}
						 }
						 bgPosResultStr = bgPosResultStr.trim();
						 bgPosResultStr=bgPosResultStr.substring(0, bgPosResultStr.length - 1);
						 style += "background-position:"+bgPosResultStr+";";
						 //$("#"+idstr).css("background-position",bgPosResultStr);

                         
						 var bgsizearry =  bgsize.split(",");
						  var bgSizeResultStr="";
						 for(var i=0;i<bgsizearry.length;i++){
								var bgia=bgsizearry[i];
								if(countindex == i){
									  bgSizeResultStr += "";
								}else{
									  bgSizeResultStr += bgia +",";
								}
						 }
						 bgSizeResultStr = bgSizeResultStr.trim();
						 bgSizeResultStr=bgSizeResultStr.substring(0, bgSizeResultStr.length - 1);
						 style += "background-size:"+bgSizeResultStr+";";
						 //$("#"+idstr).css("background-size",bgSizeResultStr);
						 $("#"+idstr).attr("style",style);
			    }else{ //只有一张图片的时候
					  if(bgimage.indexOf(url)>-1){ //已经包含
					     $("#"+idstr).css("background-image",""); 
						 $("#"+idstr).css("background-repeat","");
						 $("#"+idstr).css("background-position","");
						 $("#"+idstr).css("background-size","");
				     }
				}
			  }
}