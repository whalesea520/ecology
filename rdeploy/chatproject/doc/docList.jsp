<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<jsp:useBean id="multiAclManager"
	class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<%
int pageNo = 1;
int pageSize = 15;
String principalid = "";
int userid = user.getUID();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<script type="text/javascript"
			src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		<script language="javascript" type="text/javascript"
			src="/js/init_wev8.js"></script>
		<link rel="stylesheet" type="text/css"
			href="/rdeploy/assets/css/wf/requestshow.css">
			<script type="text/javascript" src="/js/doc/upload_wev8.js"></script>
		<style type="text/css">
a {
	cursor: pointer;
}

.opBtn {
	background-color: #f2f2f2;
	color: #cdcdcd;
	text-align: center;
	border-radius: 3px;
	cursor: pointer;
}

.downloadOpBtn {
	width: 60px;
	height: 25px;
	line-height: 25px;
	position: absolute;
	left: -190px;
	top: 31px;
}

.delOpBtn {
	width: 60px;
	height: 25px;
	line-height: 25px;
	position: absolute;
	left: -116px;
	top: 31px;
}

.shareOpBtn {
	width: 60px;
	height: 25px;
	line-height: 25px;
	position: absolute;
	left: -42px;
	top: 31px;
}

.box {
	height: 84px;
}

.norecord {
	position: absolute;
	left: 45%;
	top: 30%;
	width: 75px;
	height: 130px;
}

.recordpicture {
	width: 94px;
	height: 85px;
	background-image: url("/rdeploy/assets/img/cproj/doc/f_no_data.png");
	background-repeat: no-repeat;
	background-position: center;
}

.recordmessage {
	width: 94px;
	height: 45px;
	line-height: 45px;
	text-align: center;
	font-size: 16px;
	color: #e4e4e4;
}
</style>
		<script type="text/javascript">
		var fullfinish = false;
		var userid = <%= userid %>;
  	jQuery(document).ready(function(){
	  	//运行瀑布流主函数
  		//设置滚动加载
  		window.onscroll = function(){
  			//校验数据请求
  			if(getCheck()){
  				if(fullfinish)
  				{
  					fullfinish = false;
  					$.ajax({
						type: "post",
					    url: "/rdeploy/chatproject/doc/requestDocList.jsp?<%= request.getQueryString() %>",
					    data: {"actionkey":"requesthandle",
					    		"pageNo":jQuery("#pageNo").val(),
					    		"pageSize": 15
					    	  },
					    dataType: 'json',
					    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
					    success:function (data) {
					    	fullDocItem(data.docList);
			  				waterfall('contentbox','box');
			  				try {
					    		var index = parseInt(jQuery("#pageNo").val());
					    	} catch (e) {}
			  				jQuery("#pageNo").val(index+1);
					    } 
		    		});
  				}
  			}
  		}
	  	
  		jQuery("html").mousedown(function (e){ 
       		parent.$(".hiddensearch").animate({
				height: 0
				}, 200,null,function() {
					parent.jQuery(".hiddensearch").hide();
			}); 
       		parent.jQuery(".opensright").hide();
       		parent.jQuery(".selectstatus").hide();
			parent.jQuery(".sbPerfectBar").hide();
		});
		
		
		function onShowHrm(fieldname) {
	   
	}
  	});
  	/**
  	* 瀑布流主函数
  	* @param  contentbox	[Str] 外层元素的ID
  	* @param  box 	[Str] 每一个box的类名
  	*/
  	function waterfall(contentbox,box){
  		//1.获得外层以及每一个box
  		var contentbox = document.getElementById(contentbox);
  		var boxs  = getClass(contentbox,box);
  		//2.获得屏幕可显示的列数
  		var boxW = boxs[0].offsetWidth;
  		var colsNum = Math.floor(document.documentElement.clientWidth/boxW);
  		contentbox.style.width = boxW*colsNum+'px';//为外层赋值宽度
  		//3.循环出所有的box并按照瀑布流排列
  		var everyH = [];//定义一个数组存储每一列的高度
  		for (var i = 0; i < boxs.length; i++) {
  			if(i<colsNum){
  				everyH[i] = boxs[i].offsetHeight;
  			}else{
  				var minH = Math.min.apply(null,everyH);//获得最小的列的高度
  				var minIndex = getIndex(minH,everyH); //获得最小列的索引
  				getStyle(boxs[i],minH,boxs[minIndex].offsetLeft,i);
  				everyH[minIndex] += boxs[i].offsetHeight;//更新最小列的高度
  			}
  		}
  	}
  	/**
  	* 获取类元素
  	* @param  warp		[Obj] 外层
  	* @param  className	[Str] 类名
  	*/
  	function getClass(contentbox,className){
  		var obj = contentbox.getElementsByTagName('*');
  		var arr = [];
  		for(var i=0;i<obj.length;i++){
  			if(obj[i].className == className){
  				arr.push(obj[i]);
  			}
  		}
  		return arr;
  	}
  	/**
  	* 获取最小列的索引
  	* @param  minH	 [Num] 最小高度
  	* @param  everyH [Arr] 所有列高度的数组
  	*/
  	function getIndex(minH,everyH){
  		for(index in everyH){
  			if (everyH[index] == minH ) return index;
  		}
  	}
  	/**
  	* 数据请求检验
  	*/
  	function getCheck(){
  		var documentH = document.documentElement.clientHeight;
  		var scrollH = document.documentElement.scrollTop || document.body.scrollTop;
  		
  		return documentH+scrollH+40 >= getLastH() ?true:false;
  	}
  	/**
  	* 获得最后一个box所在列的高度
  	*/
  	function getLastH(){
  		var contentbox = document.getElementById('contentbox');
  		var boxs = getClass(contentbox,'box');
  		return boxs[boxs.length-1].offsetTop+boxs[boxs.length-1].offsetHeight;
  	}
  	/**
  	* 设置加载样式
  	* @param  box 	[obj] 设置的Box
  	* @param  top 	[Num] box的top值
  	* @param  left 	[Num] box的left值
  	* @param  index [Num] box的第几个
  	*/
  	var getStartNum = 0;//设置请求加载的条数的位置
  	function getStyle(box,top,left,index){
  	    if (getStartNum>=index) return;
  	    $(box).css({
  	    	'position':'absolute',
  	        'top':top,
  	        "left":left,
  	        "opacity":"0"
  	    });
  	    $(box).stop().animate({
  	        "opacity":"1"
  	    },999);
  	    getStartNum = index;//更新请求数据的条数位置
  	}
  		
  	</script>
	</head>
	<body>
		<div class="contentbox" id="contentbox">
			<!-- item block 循环开始 -->
			<script type="text/javascript">
			$(function(){
				$("#pageNo").val('1');
			$.ajax({
							type: "post",
						    url: "/rdeploy/chatproject/doc/requestDocList.jsp?<%= request.getQueryString() %>",
						    data: {"actionkey":"requesthandle",
						    		"pageNo": 1,
						    		"pageSize": 15
						    	  },
						    dataType: 'json',
						    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
						    success:function (data) {
		  		 				parent.$("#rowCount").empty().append(data.docCount);
						    	fullDocItem(data.docList);
						    	jQuery("#pageNo").val("2");
						    } 
				    	});
			});
  		</script>
		</div>
		<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo+1%>">
		<script type="text/javascript">
  	function fullDocItem(data)
  	{
  		data = eval(data)
  		if(!!data && data.length > 0)
  		{
  	$.each(data,function(key,docShowModel) {
	$boxDiv = $("<div />");
	$boxDiv.addClass("box");
  	$boxDiv.attr("id",docShowModel.docid+"box");
  	
  	$newImgDiv = $("<div />")
  	$newImgDiv.attr("id",docShowModel.docid+"newImgDiv");
    $newImgDiv.css("position","absolute");
    $newImgDiv.css("margin-left","35px");
    $newImgDiv.css("margin-top","24px");
    $newImg = $("<img />");
    $newImg.attr("src", "/rdeploy/assets/img/cproj/doc/new.png");
    $newImgDiv.append($newImg);
  	
  	$boxItemDiv = $("<div />");
  	$boxItemDiv.css("height","84px");
  	
  	$pichandle = $("<div />");
  	$pichandle.addClass("pichandle");
  	$pichandle.css("margin-left","25px");
  	
  	$pichandleImg = $("<img />");
  	$pichandleImg.attr("src","/rdeploy/assets/img/cproj/doc/fileicon/"+docShowModel.docExtendName);
  	$pichandleImg.bind("error",function(){ 
		this.src="/rdeploy/assets/img/cproj/doc/fileicon/html.png"; 
	}); 
  	$pichandleImg.css("width","45px");
  	$pichandleImg.css("height","45px");
  	$pichandleImg.css("border-radius","30px");
  	$pichandleImg.css("margin-top","29px");
  	if(docShowModel.readCount > 0 || docShowModel.createrid == '<%= user.getLoginid() %>')
    {
        $pichandle.append($pichandleImg);
    }
    else
    {
        $pichandle.append($newImgDiv).append($pichandleImg);
    }
  
  	
  	$infoDiv = $("<div />");
  	$infoDiv.addClass("info");
  	$infoDiv.css("margin-left","25px");
  	
  	$titleDiv = $("<div />");
  	$titleDiv.addClass("title");
  	
  	$title = $("<div />");
  	$title.css("float","left");
  	$title.css("width","400px");
  	$title.css("text-overflow","ellipsis");
  	$title.css("overflow","hidden");
  	$title.css("white-space","nowrap");
  	
  	$atitle = $("<a />");
  	$atitle.attr("id",docShowModel.docid);
  	$atitle.append(docShowModel.doctitle);
  	$atitle.click(function (){
  		openFullWindowForXtable("/docs/docs/DocDsp.jsp?id="+$(this).attr("id"));
  		$("#"+$(this).attr("id")+"newImgDiv").remove();
  	});
  	$title.append($atitle);
  	
  	$user = $("<div />");
  	$user.css("float","right");
  	$user.css("position","absolute");
  	$user.css("left","50%");
  	
  	$auser = $("<a />");
  	$auser.attr("href","javaScript:openhrm("+docShowModel.createrid+");");
  	$auser.bind("click",function() {
				        pointerXY(event);
	});
				    
  	$auser.append(docShowModel.creatername).append("&nbsp;");
  	
  	$label = $("<label />");
  	$label.css("color","#8e9598");
  	$label.css("font-weight","normal");
  	$label.append(docShowModel.doccreatedate).append("&nbsp;").append(docShowModel.doccreatetime);
  	
  	$user.append($auser).append($label);
  	
  	$titleDiv.append($title).append($user);
  	
  	
  	
  	$createrinfoDiv = $("<div />");
  	$createrinfoDiv.addClass("createrinfo");
  	$createrinfoDiv.attr("id","createrinfoDivID");

	
  	
  	$divSize = $("<div />");
  	$divSize.append("大小："+docShowModel.fileSize);
  	$divSize.css("float","right");
  	$divSize.css("position","absolute");
  	$divSize.css("left","50%");
  	
  	$infoDiv.append($titleDiv).append($createrinfoDiv);
  	
  	$showtypeDiv = $("<div />");
  	$showtypeDiv.attr("id",docShowModel.docid+"showtypeDiv");
  	$showtypeDiv.addClass("showtype");
  	$showtypeDiv.css("height","84px");
  	$showtypeDiv.css("line-height","84px");
  	$showtypeDiv.hide();
  	
  	$downloadBtnDiv = $("<div />");
	$downloadBtnDiv.attr("id",docShowModel.docid+"downloadBtnDiv");
	$downloadBtnDiv.attr("name","downloadBtnDiv");
  	$downloadBtnDiv.addClass("opBtn downloadOpBtn");
  	$downloadBtnDiv.append("下载");
  	$downloadBtnDiv.click(function() {
                downImageFile(docShowModel.docid, docShowModel.imagefileId);
            });
  	$downloadBtnDiv.bind({
                mouseenter: function(e) {
                    $("#" + docShowModel.docid+"downloadBtnDiv").css('background-color', '#4ba9df');
                    $("#"+docShowModel.docid+"downloadBtnDiv").css('color', '#fff');
                },
                mouseleave: function(e) {
                    $("#"+docShowModel.docid+"downloadBtnDiv").css('background-color', '#f2f2f2');
                    $("#"+docShowModel.docid+"downloadBtnDiv").css('color', '#cdcdcd');
                }
            });
            
            
  	$deleteBtnDiv = $("<div />");
	$deleteBtnDiv.attr("id", docShowModel.docid+"deleteBtnDiv");
	$deleteBtnDiv.attr("name","deleteBtnDiv");
  	$deleteBtnDiv.addClass("opBtn delOpBtn");
  	$deleteBtnDiv.append("删除");
  	$deleteBtnDiv.click(function() {
                doDocDel(docShowModel.docid, docShowModel.categoryid);
            });
  	
  	$deleteBtnDiv.bind({
                mouseenter: function(e) {
                    $("#" + docShowModel.docid+"deleteBtnDiv").css('background-color', '#4ba9df');
                    $("#"+docShowModel.docid+"deleteBtnDiv").css('color', '#fff');
                  
                },
                mouseleave: function(e) {
                    $("#"+docShowModel.docid+"deleteBtnDiv").css('background-color', '#f2f2f2');
                    $("#"+docShowModel.docid+"deleteBtnDiv").css('color', '#cdcdcd');
                }
            });
  				
  	$shareBtnDiv = $("<div />");
	$shareBtnDiv.attr("id","shareBtnDiv");
	$shareBtnDiv.attr("name","shareBtnDiv");
  	$shareBtnDiv.addClass("opBtn shareOpBtn");
  	$shareBtnDiv.append("分享");
  	
	if(docShowModel.isdownload)
	{
		$showtypeDiv.append($downloadBtnDiv);
	}
	
	if(docShowModel.isdelete)
	{
		$showtypeDiv.append($deleteBtnDiv);
	}
	else
	{
		$downloadBtnDiv.css("left","-114px");
	}
	
	$showtypeDiv.append($shareBtnDiv);
	
	$showrequestline = $("<div />");
	$showrequestline.addClass("showrequestline1");
	
	
						var itemData ;
						
						$snav = $("<div />");
							 $snav.css("float","left");
							 $snav.css("position","absolute");
						
						if(docShowModel.doctype == "0")
						{
							itemData = parent.publicIdMap[docShowModel.categoryid];
							
							if(itemData)
							{
								while(itemData.sid != 0)
								{
								   $a = $("<a />");
								   $a.append(itemData.sname);
								   $a.attr("id",itemData.sid);
								   
								    $a.bind("click",function(){
							            parent.$(".searchshow").css("display", "none");
							            parent.fullItemDataLink(this.id,"publicAll");
							            parent.$(".moveline").css("left","29px");
							            parent.$("#privateLinkA").removeClass("selected");
							            parent.$("#publicLinkA").addClass("selected");
							        });
								   
								   $lable = $("<lable />");
								   $lable.append(" > ");
								   $snav.prepend($lable).prepend($a);
								   $("#seccategoryNav").append($snav);
								  	if(itemData.pid == '0')
								  	{
										break;
								  	}
								  	else
								  	{
								  		itemData = parent.publicIdMap[itemData.pid];
								  	}
								}
							}
							
							 $a = $("<a />");
							   $a.append("公共目录");
							   $a.attr("id","0");
							    $a.bind("click",function(){
						            parent.$(".searchshow").css("display", "none");
						             parent.fullItemDataLink(this.id,"publicAll");
						              parent.$(".moveline").css("left","29px");
						               parent.$("#privateLinkA").removeClass("selected");
						             parent.$("#publicLinkA").addClass("selected");
						        });
						        
							   $lable = $("<lable />");
							   $lable.append(" > ");
							   $snav.prepend($lable).prepend($a);
							   $("#seccategoryNav").append($snav);
							   $snav.children("lable:last-child").remove();
						}
						else
						{
							var dcategory = docShowModel.categoryid*-1;
							itemData = parent.privateIdMap[dcategory];
							if(itemData)
							{
								if(docShowModel.createrid == userid+"")
								{
										while(true)
										{
										    if(itemData.pid == '0')
										    {
										    	break;
										    }
										    else
										    {
										    	$a = $("<a />");
											   $a.attr("id",itemData.sid);
											   $a.append(itemData.sname);
											   if(docShowModel.createrid == userid+"")
											   {
												   	 $a.bind("click",function(){
											            parent.$(".searchshow").css("display", "none");
											           parent.fullItemDataLink(this.id,"privateAll");
											           parent.$(".moveline").css("left","118px");
											             parent.$("#publicLinkA").removeClass("selected");
											           parent.$("#privateLinkA").addClass("selected");
											        });
											   }
											   $lable = $("<lable />");
											   $lable.append(" > ");
											   $snav.prepend($lable).prepend($a);
										    	$("#seccategoryNav").append($snav);
										    }
										    itemData = parent.privateIdMap[itemData.pid];
										}
									}
									else
									{
												$spanname = $("<span />");
											   $spanname.append(docShowModel.creatername);
											   $snav.prepend($spanname);
										    	$("#seccategoryNav").append($snav);
									}
							}
							if(docShowModel.createrid == userid+"")
								{
								   $a = $("<a />");
								   $a.append("私人目录");
								   if(docShowModel.createrid == userid+"")
									   {
										   	$a.bind("click",function(){
								            parent.$(".searchshow").css("display", "none");
								           parent.fullItemDataLink('0',"privateAll");
								            parent.$(".moveline").css("left","118px");
								            parent.$("#publicLinkA").removeClass("selected");
								           parent.$("#privateLinkA").addClass("selected");
								        });
									   }
								    
								   $lable = $("<lable />");
								   $lable.append(" > ");
								   $snav.prepend($lable).prepend($a);
								   $("#seccategoryNav").append($snav);
								   $snav.children("lable:last-child").remove();
							   }
							   else
							   {
							   			$spanname = $("<span />");
											   $spanname.append("私人目录");
											   $lable = $("<lable />");
											   $lable.append(" > ");
											   $snav.prepend($lable).prepend($spanname);
										    	$("#seccategoryNav").append($snav);
							   }
						}
						$createrinfoDiv.append($snav);
						$createrinfoDiv.append($divSize);
	
	
	$boxItemDiv.append($pichandle).append($infoDiv).append($showtypeDiv);
	$boxDiv.append($boxItemDiv).append($showrequestline);
	
	$("#contentbox").append($boxDiv);
	
	$("#"+docShowModel.docid+"box").hover(function(){
		$("#"+docShowModel.docid+"showtypeDiv").show();
	},
	function(){
		$("#"+docShowModel.docid+"showtypeDiv").hide();
	});
	});
	if(data.length < <%= pageSize %>)
	{
		$("#boxH").remove();
		
		$boxH = $("<div />");
		$boxH.attr("id","boxH");
		 $boxH.addClass("box");
		$boxH.css("height","40px");
		$("#contentbox").append($boxH);
		fullfinish = false;
	}
	else
	{
		fullfinish = true;
	}
	
	
  		}
  		else
  		{
  			 if(parent.$("#rowCount").text() == '' || parent.$("#rowCount").text() == null || parent.$("#rowCount").text() == "0")
  			 {
  			 	$norecord = $("<div />");
				 $norecord.addClass("norecord");
				 $recordpicture = $("<div />");
				 $recordpicture.addClass("recordpicture");
				 $recordmessage = $("<div />");
				 $recordmessage.addClass("recordmessage");
				 $recordmessage.append("暂无记录");
				 $norecord.append($recordpicture).append($recordmessage);
				 $("#contentbox").append($norecord); 
				 parent.$("#rowCount").empty().append("0");
  			 }
  			 fullfinish = false;
  		}
  		
  		$("#dataloading").hide();
  	}
  	
  	function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width - 10;
  var height = screen.height - 100;
  var szFeatures = "top=0," ; 
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function doDocDel(docid, sid) {
    var url = "/docs/docs/DocOperate.jsp?operation=delete&docid=" + docid;
    jQuery.ajax({
        url: url,
        type: 'post',
        success: function(data) {
        	 $("#"+docid+"box").remove();
        	 var rowct = parseInt(parent.$("#rowCount").text());
        	 parent.$("#rowCount").empty().append((rowct - 1));
        }
    });
}

function downImageFile(docid, imageid) {
	if(imageid == '-100')
	{
		jQuery.ajax({
            url: "/rdeploy/chatproject/doc/SetSession.jsp?docid=" + docid,
            type: "post",
            dataType: "json",
            success: function(data) {
            	var dialog = new window.top.Dialog();
		  		dialog.currentWindow = window;
		  		dialog.URL = "/docs/docs/DocAcc.jsp?canDownload=true&language=7&&mode=view&bacthDownloadFlag=0&docid="+docid;
		  		dialog.Title = "附件列表";    //84075:新建目录
				dialog.Width = 1000;
		  		dialog.Height = 400;
		  		dialog.normalDialog = true;
		  		dialog.Drag = true;
				dialog.show();
            }
        });
	}
	else
	{
	    downloadDocImgs(docid, {
	        id: imageid,
	        _window: parent,
	        downloadBatch: 0,
	        emptyMsg: "s"
	    });
	}
}
  	</script>
					<div id="dataloading" style="text-align:center;position: absolute;left: 45%;top: 20%;">
						<img src="/social/images/loading_large_wev8.gif">
					</div>
	</body>
</html>