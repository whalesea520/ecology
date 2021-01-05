<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="multiAclManager" class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
int pageNo = 1;
int pageSize = 15;
String principalid = "";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
  	<link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/wf/requestshow.css">
  	<script type="text/javascript" src="/js/doc/upload_wev8.js"></script>
  	<script type='text/javascript' src='/rdeploy/assets/js/doc/chatproject/menu_nav_wev8.js'></script>
  	<style type="text/css">
  	a {
		cursor:pointer;
	}
  	.opBtn {
		    background-color: #f2f2f2;
		    color: #cdcdcd;
			text-align: center;
			border-radius: 3px;
			cursor:pointer;
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
  	jQuery(document).ready(function(){
	  	//运行瀑布流主函数
  		//设置滚动加载
  		window.onscroll = function(){
  			//校验数据请求
  			if(getCheck()){
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
  		var dataJson = parent.dataJson;
	var privateDataJson = parent.privateDataJson;	
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
				    } 
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
  	$pichandleImg.attr("src","/rdeploy/assets/img/cproj/doc/"+docShowModel.docExtendName);
  	$pichandleImg.bind("error",function(){ 
		this.src="/rdeploy/assets/img/cproj/doc/html.png"; 
	}); 
  	$pichandleImg.css("width","45px");
  	$pichandleImg.css("height","45px");
  	$pichandleImg.css("border-radius","30px");
  	$pichandleImg.css("margin-top","29px");
  	if(docShowModel.readCount > 0)
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
  	$title.css("width","200px");
  	$title.css("text-overflow","ellipsis");
  	$title.css("overflow","hidden");
  	$title.css("white-space","nowrap");
  	
  	$atitle = $("<a />");
  	$atitle.append(docShowModel.doctitle);
  	
  	$title.append($atitle);
  	
  	$user = $("<div />");
  	$user.css("float","right");
  	$user.css("position","absolute");
  	$user.css("left","50%");
  	
  	$auser = $("<a />");
  	$auser.attr("href","javaScript:openhrm("+docShowModel.createrid+");");
  	$auser.click(function() {
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
                $("#"+docShowModel.docid+"box").remove();
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
  	
  		/**
  	$principalid_val = $("<input />");
  	$principalid_val.attr("id","principalid_val");
  	$principalid_val.attr("type","hidden");
  	$principalid_val.attr("name","principalid");
  	$principalid_val.attr("value","");
  	
  	
  	$principalid = $("<input />");
  	$principalid.attr("id","principalid");
  	$principalid.addClass("add_input");
  	$principalid.attr("_init","1");
  	$principalid.attr("_searchwidth","80");
  	$principalid.attr("_searchtype","hrm");
  	
  	
  	$btnBrowser = $("<div />");
  	$btnBrowser.addClass("btn_browser browser_hrm");
  
  	
  */
  	$showtypeDiv.append($downloadBtnDiv).append($deleteBtnDiv).append($shareBtnDiv);
  	
				
	
	$showrequestline = $("<div />");
	$showrequestline.addClass("showrequestline1");
	
	
						var itemData ;
						
						$snav = $("<div />");
							 $snav.css("float","left");
							 $snav.css("position","absolute");
						
						if(docShowModel.doctype == "0")
						{
							itemData = dataJson[docShowModel.categoryid];
							
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
							    itemData = dataJson[itemData.pid];
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
							itemData = privateDataJson[docShowModel.categoryid];
							while(itemData.sname != "<%= user.getLoginid() %>")
							{
							   $a = $("<a />");
							   $a.attr("id",itemData.sid);
							   $a.append(itemData.sname);
							    $a.bind("click",function(){
						            parent.$(".searchshow").css("display", "none");
						           parent.fullItemDataLink(this.id,"privateAll");
						           parent.$(".moveline").css("left","118px");
						             parent.$("#publicLinkA").removeClass("selected");
						           parent.$("#privateLinkA").addClass("selected");
						        });
							   $lable = $("<lable />");
							   $lable.append(" > ");
							   $snav.prepend($lable).prepend($a);
							   $("#seccategoryNav").append($snav);
							   itemData = privateDataJson[itemData.pid];
							}
							
							 $a = $("<a />");
							   $a.append("私人目录");
							   $a.attr("id","privateAll");
							    $a.bind("click",function(){
						            parent.$(".searchshow").css("display", "none");
						           parent.fullItemDataLink(this.id,"privateAll");
						            parent.$(".moveline").css("left","118px");
						            parent.$("#publicLinkA").removeClass("selected");
						           parent.$("#privateLinkA").addClass("selected");
						        });
							   $lable = $("<lable />");
							   $lable.append(" > ");
							   $snav.prepend($lable).prepend($a);
							   $("#seccategoryNav").append($snav);
							   $snav.children("lable:last-child").remove();
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
  		}
  	}
  	</script>
  	
  </body>
</html>