<%@page import="weaver.page.HPTypeEnum"%>
<SCRIPT src="/js/homepage/Article_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/jquery/jquery.scrollTo_wev8.js"></script>

<style type="text/css" rel="STYLESHEET">
.spCss{
	height: 100%;
	padding-top: 5px;
	background:url(/js/jquery/plugins/weavertabs2/lmz_wev8.gif) no-repeat;
	border: 1px;
	text-align: center;
	background-position: center;
	font-style:normal;
	font-size:12px;
	font-family:宋体;
	font-weight:normal;
	text-align:center;
	
	width:77px;
	cursor:pointer;
	vertical-align:middle;
	
	
}
.picturebackhp 
{
    width: 18px;
    height: 32px;
    float:left;
    background: transparent url(/page/element/Picture/resource/image/scroll_left_wev8.gif) no-repeat 0 0;
}
.picturenexthp 
{
    width: 18px;
    height: 32px;
    float:left;
    background: transparent url(/page/element/Picture/resource/image/scroll_right_wev8.gif) no-repeat 0 0;
}
</style>

<script type="text/javascript">
function chooseColor(obj){
	$(".chooseColor").hide();
	$(".chooseColor").attr("item","");
	var item = $(obj).attr("id");
	var top = $(obj).position().top;
	var left = $(obj).position().left+20;
	$(".chooseColor").attr("item",item);
	$(".chooseColor").css("top",top);
	$(".chooseColor").css("left",left);
	//$(".chooseColor").show();
	$(".chooseColor").fadeIn(600);
}

function colorCheck(obj,eid){
	var item = $(".chooseColor").attr("item");
	var color = $(obj).attr("color");
	$("#"+item+"color_"+eid).val(color);
	$("#"+item).css("background",color);
	$(".chooseColor").hide();
}
<!--
	
var setinnerHTML = function (el, htmlCode) {
    var ua = navigator.userAgent.toLowerCase();
    if (ua.indexOf('msie') >= 0 && ua.indexOf('opera') < 0) {
        htmlCode = '<div style="display:none">for IE</div>' + htmlCode;
        htmlCode = htmlCode.replace(/<script([^>]*)>/gi,
                                    '<script$1 defer=true>');
        el.innerHTML = htmlCode;
        el.removeChild(el.firstChild);
        //alert(el.innerHTML);
    } else {
        var el_next = el.nextSibling;
        var el_parent = el.parentNode;
        el_parent.removeChild(el);
        el.innerHTML = htmlCode;
        if (el_next) {
            el_parent.insertBefore(el, el_next)
        } else {
            el_parent.appendChild(el);
        }
    }
}
//-->
</script>

<script language="javascript"><!--
var isSetting=false;
var tempEid=0; //临时元素ID
var objAreaFlags = new Array();
var mode="run"; //确定页面模式  debug run
var initEnd=20; //从门户过来的数据，这个页面需要在前一段时间进行高度自适应

var needInitItemsNum=0;

function setElementLogo(eid,eLogo){
	$("#icon_"+eid).children('img').attr("src",eLogo);
}	

function setElementHeight(eid,height){
	
	if(height==0){
		$("#content_view_id_"+eid).css("height","auto");
	} else {
		$("#content_view_id_"+eid).css("height",height);
	}	
}


function setElementMarginTop(eid,marginTop){
	$("#item_"+eid).css("margin-top",marginTop);
}

function setElementMarginBottom(eid,marginBottom){
	$("#item_"+eid).css("margin-bottom",marginBottom);
}

function setElementMarginLeft(eid,marginLeft){
	$("#item_"+eid).css("margin-left",marginLeft);
}

function setElementMarginRight(eid,marginRight){
	$("#item_"+eid).css("margin-right",marginRight);
}



function onRefresh(eid,ebaseid){
	$("#item_"+eid).attr('needRefresh','true')
	$("#item_"+eid).trigger("reload");  
}
var myRefreshEid;
var myRefreshEbaseId;
function setWorkFlowRefresh(eid,ebaseid){
	myRefreshEid = eid;
	myRefreshEbaseId = ebaseid;
}
var initRefresh=0;

function doResize(){
	if(<%=isfromportal!=1%>)return;
	if(initRefresh<initEnd){		
		try{	
			elementsIsLoad();
			
			var oFrm=parent.document.getElementById("mainFrame");			
			//if(eid=="8166"||eid=="8153") {
				//log(oFrm.style.height+":"+document.body.scrollHeight)
				//alert(oFrm.style.height+":"+document.body.scrollHeight)
			///}
			if(oFrm.style.height==''){
				oFrm.style.height='0';
			}
			if(parseInt(oFrm.style.height)<parseInt(document.body.scrollHeight)) {
				oFrm.style.height=document.body.scrollHeight+"px";
			} else{
				oFrm.style.height=document.body.scrollHeight+"px";
			}
			
			//$("#content_view_id_"+eid).append(oFrm.style.height+":"+document.body.scrollHeight);			
		} catch(e){
			log(e) 
		}
		setTimeout(function(){doResize();},1000); 
		initRefresh++;
		log("initRefresh:"+initRefresh);
	} 	
}
var count=0;
var timeval=3000;

       
function replaceHtml(el, html) {   
    var oldEl = typeof el === "string" ? document.getElementById(el) : el;   
    /*@cc_on // Pure innerHTML is slightly faster in IE  
        oldEl.innerHTML = html;  
        return oldEl;  
    @*/  
    var newEl = oldEl.cloneNode(false);   
    newEl.innerHTML = html;   
    oldEl.parentNode.replaceChild(newEl, oldEl);   
    /* Since we just removed the old element from the DOM, return a reference  
    to the new element, which can be used to restore variable references. */  
    return newEl;   
}
var intNum=0;
$(document).ready(function () {
if(<%=isfromportal==1%>){
	if(window.onbeforeunload){
		$(window).bind("beforeunload",function(){window.onbeforeunload=function(){try{window.parent.document.getElementById("mainFrame").style.height=document.body.scrollHeight+"px";}catch(e){}}});
	}else{
		window.onbeforeunload=function(){try{window.parent.document.getElementById("mainFrame").style.height=document.body.scrollHeight+"px";}catch(e){}}
	}
}
	if(mode=="debug") $('#txtDebug').css("display","");

	$(".item").bind("reload",function(){
		elementReload($(this).attr("ebaseid"),$(this).attr("eid"),$(this).attr("cornerTop"),$(this).attr("cornerBottom"),$(this).attr("cornerTopRadian"),$(this).attr("cornerBottomRadian"))
	});
	
	/*
	$.each($(".item"),function(i,n){
		if(intNum<2){			
			$this=$(this);
			window.setTimeout(function(){
				$this.trigger("reload");
			},0)
			intNum++;
		}
	})
	*/
	
	//$(".item").trigger("reload");

	var win_height = getClientHeight();

	var scroll_top = getScrollTop();
	var itemArray = $(".item");
	var itemArray_length=itemArray.length;
	var lastTop = 0;
	for(var i=0;i<itemArray_length;i++){
		var _item = itemArray[i];
		var jq_item = $("#"+_item.id);
		//if($("#"+_item.id).attr("needRefresh")=="false")continue;
		var el_top1 = getAbsoluteTop(_item);
		document.getElementById("content_view_id_"+$(_item).attr("eid")).innerHTML = "<img class='imgWait' src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...<br /><br /><br /><br /><br /><br /><br />";
		var el_top = getAbsoluteTop(_item);
		
		//document.getElementById("title_"+_item.eid).innerHTML = ("lastTop="+lastTop+";el_top="+el_top+";win_height+scroll_top="+(win_height+scroll_top));
		
		if(el_top+0 < win_height+scroll_top || lastTop > el_top){
			jq_item.attr("isBeforeInit","true");
			jq_item.trigger("reload");
		}else{
			jq_item.attr("isBeforeInit","false");
		}
		lastTop=el_top;
	}
	elementLoad_queue();
	
	// 永远验证刷新页面高度
	
	if(<%=isfromportal==1%>) {
		
		doResize(); //从门户过的数据需要刷新页面高度
	}
	
});

function getScrollTop(){
    var scrollTop=0;
    var hpid = '<%=Util.null2String(request.getParameter("hpid"))%>';
    var isSetting = '<%="true".equalsIgnoreCase(Util.null2String(request.getParameter("isSetting")))%>';
    if(hpid > 0 ){
	    if(document.documentElement&&document.documentElement.scrollTop){
	        scrollTop=document.documentElement.scrollTop;
	    }
	    else if(document.body){
	        scrollTop=document.body.scrollTop;
	    }
    }else if(hpid < 0){//协同处理
        if(isSetting == 'true'){
    	   scrollTop = document.getElementById("Element_ContainerDiv").scrollTop;
    	}else{
    	   scrollTop = document.getElementById("Element_Container").scrollTop;
    	}
    }
    return scrollTop;
}

function getClientHeight(){
	var yScroll;
    if (window.innerHeight && window.scrollMaxY) {
        yScroll = window.innerHeight + window.scrollMaxY;
    }
    else if (document.body.scrollHeight > document.body.offsetHeight) {
        yScroll = document.body.scrollHeight; // all but Explorer Mac 
    }
    else {
        yScroll = document.body.offsetHeight;  // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari   
    }
    var windowHeight;
    if (self.innerHeight) {
        windowHeight = self.innerHeight; // all except Explorer       
    }
    else if (document.documentElement && document.documentElement.clientHeight) {
        windowHeight = document.documentElement.clientHeight; // Explorer 6 Strict Mode         
    }
    else if (document.body) {
        windowHeight = document.body.clientHeight; // other Explorers           
    }
    if (yScroll < windowHeight) {
        pageHeight = windowHeight; // for small pages with total height less then height of the viewport       
    }
    else {
        pageHeight = yScroll;
    }
 //   return pageHeight;
 return  (document.body.offsetHeight ||  document.documentElement.clientHeight)/2

}
function getAbsoluteTop(element) { 
	if (arguments.length != 1 || element == null) { 
		return null; 
	} 
	var offsetTop = element.offsetTop; 
	while (element = element.offsetParent) { 
		offsetTop += element.offsetTop; 
	} 
	return offsetTop; 
}

var _elementLoad_queue_flag = true;
var ctMax=0;
function elementLoad_queue(){
	if(_elementLoad_queue_flag){
		try{
			_elementLoad_queue_flag=false;
			var itemArray = $(".item[isInited!='true']");
			var flag = false;
			var itemArray_length=itemArray.length;
			for(var i=0;i<itemArray_length;i++){
				var _item = itemArray[i];
				var el_top = getAbsoluteTop(document.getElementById(_item.id));
				var win_height = $(window).height();
				
				var scroll_top = getScrollTop();
				ctMax++;
				if(el_top < win_height+scroll_top || <%=HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(request.getParameter("pagetype"))%>){
					flag = true;
					$("#"+_item.id).trigger("reload");
					break;
				}
			}
			if(!flag && itemArray_length > 0){
				setTimeout(elementLoad_queue, 200);
			}
		}catch(e){
		}
		_elementLoad_queue_flag=true;
	}
}



function elementReload(ebaseid,eid,top,bottom,topRadian,bottomRadian){	
	if(ebaseid===undefined)
		return;
	var _itemObj = $("#item_"+eid);
	//if($("#item_"+eid).attr("needRefresh")=="false")return;
	_itemObj.attr("isInited","true");
	_itemObj.attr("elementLoad_queue_timeout_flag","false");

	/*
	if($("#item_"+eid).attr('needRefresh')=='false'){
		//alert($("#item_"+eid).attr('needRefresh'))
		_itemObj.attr("isInited","true");
		setTimeout(elementLoad_queue, 200);
		return;
	}
	*/
    //获取浏览器信息判断其类别和版本
    var explorer = window.navigator.userAgent.toLowerCase() ;
//    console.log("浏览器info:"+explorer);
//    console.log("上圆角："+topRadian);
//    console.log("下圆角："+bottomRadian);
    if (explorer.indexOf("msie") >= 0) {
        var ver=explorer.match(/msie ([\d.]+)/)[1];
//        console.log("版本："+ver);
        if(parseInt(ver)<=8){
            //防止重复加载圆角样式
            $("#header_"+eid).uncorner();
            if(top=="Round") {
                $("#header_"+eid).corner("Round top "+topRadian);
            }
            $("#content_"+eid).uncorner();
            if(bottom=="Round") {
                $("#content_"+eid).corner("Round bottom "+bottomRadian);
            }
        }else{
            if(top=="Round") {
                $("#header_" + eid).css("border-top-left-radius", "" + topRadian);
                $("#header_" + eid).css("border-top-right-radius", "" + topRadian);
            }
            if(bottom=="Round") {
                $("#content_"+eid).css("border-bottom-left-radius",""+bottomRadian);
                $("#content_"+eid).css("border-bottom-right-radius",""+bottomRadian);
            }
        }
    }else{
        if(top=="Round") {
            $("#header_"+eid).css("border-top-left-radius",""+topRadian);
            $("#header_"+eid).css("border-top-right-radius",""+topRadian);
        }
        if(bottom=="Round") {
            $("#content_" + eid).css("border-bottom-left-radius", "" + bottomRadian);
            $("#content_" + eid).css("border-bottom-right-radius", "" + bottomRadian);
        }
    }
	
	var $this = $("#content_view_id_"+eid);
	$this.html("<img class='imgWait' src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...<br /><br /><br /><br /><br /><br /><br />");
	var url=$.trim($this.attr("url")).replace(/&amp;/g,"&");
	//
	
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	url += "&pagetype=<%=Util.null2String(request.getParameter("pagetype"))%>";
	url += "&fieldids=<%=Util.null2String(request.getParameter("fieldids"))%>";
	url += "&fieldvalues=" + encodeURIComponent("<%=Util.null2String(request.getParameter("fieldvalues"))%>");
	if(ebaseid=='picture'||ebaseid=='1'||ebaseid=='menu'||ebaseid=='weather'||ebaseid=='7'||ebaseid=='8'||ebaseid=='19'){
		if(_itemObj.attr("isBeforeInit")!="true"){
	
			//document.getElementById("title_"+eid).innerHTML += "id="+_itemObj.attr("id");
	
	  	   var _timeOut = 1000;
	  	   if(ebaseid=="weather" || ebaseid=="29"){_timeOut=0;}
	  	   window.setTimeout(function(){
	   	   if(_itemObj.attr("elementLoad_queue_timeout_flag")=="false"){
	   	        _itemObj.attr("elementLoad_queue_timeout_flag","true");
				_itemObj.attr("isInited","true");
				setTimeout(elementLoad_queue, 200);
				//if(ebaseid=="weather" || ebaseid=="29"){window.top.document.title = ebaseid;}
	   	   }	
	  	   },_timeOut);
  	   }else{
  	   		//alert(1);
  	   }
  	   
		//$this.html("<img class='imgWait' src=/images/loading2_wev8.gif> "+wmsg.hp.excuting+"...")
		$this.load(url,function(){
			if(_itemObj.attr("isBeforeInit")!="true"){
				window.setTimeout(function(){
					if(_itemObj.attr("elementLoad_queue_timeout_flag")=="false"){
						_itemObj.attr("elementLoad_queue_timeout_flag","true");
						_itemObj.attr("isInited","true");
						if(_itemObj.attr("isBeforeInit")!="true"){
							setTimeout(elementLoad_queue, 200);
						}
					}
					//var _ifrm = document.getElementById("ifrm_"+eid);
					//if(_ifrm){onLoadComplete(_ifrm);}
				},0);
	  	   }else{
	  	   		//alert(1);
	  	   }
			_itemObj.css("min-height",0)
		});
		return;
	}
	
	if(true){
		log(url);
		
		if(_itemObj.attr("isBeforeInit")!="true"){
		
			//document.getElementById("title_"+eid).innerHTML += "id="+_itemObj.attr("id");
		
	  	   var _timeOut = 1000;
	  	   if(ebaseid=="weather" || ebaseid=="29"){_timeOut=0;}
	  	   window.setTimeout(function(){
	   	   if(_itemObj.attr("elementLoad_queue_timeout_flag")=="false"){
	   	        _itemObj.attr("elementLoad_queue_timeout_flag","true");
				_itemObj.attr("isInited","true");
				setTimeout(elementLoad_queue, 200);
				//if(ebaseid=="weather" || ebaseid=="29"){window.top.document.title = ebaseid;}
	   	   }	
	  	   },_timeOut);
  	   }else{
  	   		//alert(1);
  	   }

/*
		$.get(url, function(data){
			if(_itemObj.attr("elementLoad_queue_timeout_flag")=="false"){
				_itemObj.attr("elementLoad_queue_timeout_flag","true");
				_itemObj.attr("isInited","true");
				if(_itemObj.attr("isBeforeInit")!="true"){
					setTimeout(elementLoad_queue, 200);
				}
			}
			//document.getElementById("content_view_id_"+eid).innerHTML=data;
			//setinnerHTML(document.getElementById("content_view_id_"+eid),data);
			$("#content_view_id_"+eid).html(data);
			
			var _ifrm = document.getElementById("ifrm_"+eid);
			if(_ifrm){onLoadComplete(_ifrm);}
		});
*/

		$.ajax({
		   type: "POST",
		   cache: false,
		   url: url,
		   success: function(data){
				if(_itemObj.attr("elementLoad_queue_timeout_flag")=="false"){
					_itemObj.attr("elementLoad_queue_timeout_flag","true");
					_itemObj.attr("isInited","true");
					if(_itemObj.attr("isBeforeInit")!="true"){
						setTimeout(elementLoad_queue, 200);
					}
				}
				
				//document.getElementById("content_view_id_"+eid).innerHTML=data;
				//setinnerHTML(document.getElementById("content_view_id_"+eid),data);
				//$("#content_view_id_"+eid).html(data);
				$("#content_view_id_"+eid).html( data);
			/*	var regDetectJs = /<script(.|\n)*?>(.|\n|\r\n)*?<\/script>/ig;  
				var jsContained = data.match(regDetectJs);  
				  
				if(jsContained) {  
				    var regGetJS = /<script(.|\n)*?>((.|\n|\r\n)*)?<\/script>/im;  
				  
				    var jsNums = jsContained.length;  
				    for (var i=0; i<jsNums; i++) {  
				        var jsSection = jsContained[i].match(regGetJS);  
				  
				        if(jsSection[2]) {  
				            if(window.execScript) {  
				                window.execScript(jsSection[2]);  
				            } else {  
				                window.eval(jsSection[2]);  
				            }  
				        }  
				    }  
				}
				*/
				var _ifrm = document.getElementById("ifrm_"+eid);
				if(_ifrm){onLoadComplete(_ifrm);}
				_itemObj.css("min-height",0)
		   }
		}); 

		return;
	}
	
	if(url.substring(0,1)!="?")  {
		//$this.html("<img class='imgWait' src=/images/loading2_wev8.gif> "+wmsg.hp.excuting+"...")
		log(url)

		if(_itemObj.attr("isBeforeInit")!="true"){
			//alert(_itemObj.attr("id"));
			
	  	   var _timeOut = 1000;
	  	   if(ebaseid=="weather" || ebaseid=="29"){_timeOut=0;}
	  	   window.setTimeout(function(){
	   	   if(_itemObj.attr("elementLoad_queue_timeout_flag")=="false"){
	   	        _itemObj.attr("elementLoad_queue_timeout_flag","true");
				_itemObj.attr("isInited","true");
				setTimeout(elementLoad_queue, 200);
				//if(ebaseid=="weather" || ebaseid=="29"){window.top.document.title = ebaseid;}
	   	   }	
	  	   },_timeOut);
  	   }else{
  	   		//alert(1);
  	   }
			
		var xmlHttp = XmlHttp.create();	
		xmlHttp.open("POST", url, true);
			
		xmlHttp.onreadystatechange = function () {	
			switch (xmlHttp.readyState) {
			   case 0 :  //uninitialized
					break ;
			   case 1 :   //loading							
					break ;
			   case 2 :   //loaded
				   break ;
			   case 3 :   //interactive				  
				   break ;
			   case 4 :  //complete
				   if (xmlHttp.status==200)  {
				  		 //replaceHtml("content_view_id_"+eid,"aaa")
				   	   //document.getElementById("content_view_id_"+eid).innerText='aaa'
					   //count++;
			
					   var str=$.trim(xmlHttp.responseText);
					   //var re = /<script.*?>.*?<\/script>/gi;	
						////var tmpStr=str;
						//var tmpStr=tmpStr.replace(re,"")
						
						window.setTimeout(function(){
							if(_itemObj.attr("elementLoad_queue_timeout_flag")=="false"){
								_itemObj.attr("elementLoad_queue_timeout_flag","true");
								_itemObj.attr("isInited","true");
								if(_itemObj.attr("isBeforeInit")!="true"){
									setTimeout(elementLoad_queue, 200);
								}
							}
							//document.getElementById("content_view_id_"+eid).innerHTML=str;
							setinnerHTML(document.getElementById("content_view_id_"+eid),str);
							var _ifrm = document.getElementById("ifrm_"+eid);
							if(_ifrm){onLoadComplete(_ifrm);}
						},0);
						
						/*var re2 = /(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)/gi;
						//var arr;
						//var isExec=false;
						
						//while ((arr = re2.exec(str)) != null)	{						
						//	window.setTimeout($this.append(arr[0]),count*timeval+500);
						//	isExec=true;
						}*/
				   } else {				
					   //alert(xmlHttp.responseText);
				   }
			  	   break ;			 
			} 
		}		
		xmlHttp.setRequestHeader("Content-Type","text/xml");	
		xmlHttp.send(null);	

	} 
	
}


function log(s){		 
	if(mode=="debug") {
		$('#txtDebug').val($('#txtDebug').val()+s+"\n");
		var oTxtDebug=$('#txtDebug').get(0);
		oTxtDebug.scrollTop+=oTxtDebug.offsetHeight;
	}
	
}


function  GetContent(divObj,url,isAddElement,code,isNeedRefresh){
	divObj.innerHTML="<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...";
	//return;
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("GET",url, true);
	xmlHttp.onreadystatechange = function () {
		switch (xmlHttp.readyState) {
           case 3 :
			    divObj.innerHTML="<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19612,user.getLanguage())%>...";
		        break;
		   case 4 :
		       if(isAddElement){
			       	$(".group[areaflag='A']").prepend(jQuery.trim(xmlHttp.responseText));
			       	try{
			       		$(".group[areaflag='A']").children("div:first").bind("reload",function(){
			       			elementReload($(this).attr("ebaseid"),$(this).attr("eid"),$(this).attr("cornerTop"),$(this).attr("cornerBottom"));
			       		});
			       		
			       		$(".group[areaflag='A']").children("div:first").trigger("reload");	
			       		
					    //var eid=$(".group[areaflag='A']").children("div:first").attr("eid");					    
				       	//var jsCode = $("#content_js_"+eid).html();
						//eval(jsCode)			       
			       	}catch(e){
			       		//alert(e.name)
			       	} 
			   } else {
				   divObj.innerHTML =xmlHttp.responseText;
			   }
			   if(isNeedRefresh!=undefined){
				   window.location.reload();
			   }
		       if(xmlHttp.status < 400)   if(code!=null&&code!="") eval(code);
               break;
		}
	}
	xmlHttp.setRequestHeader("Content-Type","text/xml")
	xmlHttp.send(null);
}

function  GetContentForSynize(divObj,url,isAddElement,code,isNeedRefresh){
	$(divObj).hide();
	//divObj.innerHTML="<img src=/images/loading2_wev8.gif> "+wmsg.hp.excuting+"...";
	showDoDialog("<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...");
	//return;
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("GET",url, true);
	xmlHttp.onreadystatechange = function () {
		switch (xmlHttp.readyState) {
           case 3 :
			    //divObj.innerHTML="<img src=/images/loading2_wev8.gif> "+wmsg.hp.transporting+"...";
			    closeDoDialog();
			 //   top.Dialog.alert("<font  color=#000> 处理成功! </font>");
		        break;
		   case 4 :
		       if(isAddElement){
			       	$(".group[areaflag='A']").prepend(xmlHttp.responseText);
			       	try{
			       		$(".group[areaflag='A']").children("div:first").bind("reload",function(){
			       			elementReload($(this).attr("ebaseid"),$(this).attr("eid"),$(this).attr("cornerTop"),$(this).attr("cornerBottom"));
			       		});
			       		
			       		$(".group[areaflag='A']").children("div:first").trigger("reload");	
			       		
					    //var eid=$(".group[areaflag='A']").children("div:first").attr("eid");					    
				       	//var jsCode = $("#content_js_"+eid).html();
						//eval(jsCode)			       
			       	}catch(e){
			       		//alert(e.name)
			       	} 
			   } else {
				   //divObj.innerHTML =xmlHttp.responseText;
				    top.Dialog.alert("<font  color=#000> <%=SystemEnv.getHtmlLabelName(83323,user.getLanguage())%></font>");
					closeDoDialog();
			       
			   }
			   if(isNeedRefresh!=undefined){
				   window.location.reload();
			   }
		       if(xmlHttp.status < 400)   if(code!=null&&code!="") eval(code);
               break;
		}
	}
	xmlHttp.setRequestHeader("Content-Type","text/xml")
	xmlHttp.send(null);
}

var Show_dialog;
function showDoDialog(content){
		Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;  
	 	Show_dialog.Width = 240;
	 	Show_dialog.Height = 120;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = "<%=SystemEnv.getHtmlLabelName(15172,user.getLanguage())%>";
	 	Show_dialog.InnerHtml="<div style='text-align:center;color:#000;font-size:14px;height: 120px;line-height: 120px;'>"+content+"</div>";
	 	Show_dialog.show();
}


function closeDoDialog(){
		Show_dialog.close();
}

//添加新节点
function  GetContentForDragAdd(divObj,url,isAddElement,code,isNeedRefresh){
	//alert(url);
	divObj.innerHTML="<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...";
	//return;
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("GET",url, true);
	xmlHttp.onreadystatechange = function () {
		switch (xmlHttp.readyState) {
           case 3 :
			    divObj.innerHTML="<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19612,user.getLanguage())%>...";
		        break;
		   case 4 :
		       if(isAddElement){
                    var itemholder=$(".itemholder");

			        var itemnew=$(xmlHttp.responseText);
					//添加新节点
					itemnew.insertBefore(itemholder);

					itemholder.hide();

					try{
			       		itemnew.bind("reload",function(){
			       			elementReload($(this).attr("ebaseid"),$(this).attr("eid"),$(this).attr("cornerTop"),$(this).attr("cornerBottom"));
			       		});
			       		
						itemnew.trigger("reload");    
			       	}catch(e){
			       		//alert(e.name)
			       	} 
			   } else {
				   divObj.innerHTML =xmlHttp.responseText;
			   }
			   if(xmlHttp.status < 400)   if(code!=null&&code!="") eval(code);
               break;
		}
	}
	xmlHttp.setRequestHeader("Content-Type","text/xml")
	xmlHttp.send(null);
}

	
	function onShowOrHideE(eid){	
		$("#content_"+eid).toggle();
	}
	
		
	function onChanageAllStatus(obj){			
		
		var rightspanmenu=$("#rightMenuIframe").contents().find("#spanStatus");

		var showSpan=jQuery(obj);
		
		var status=showSpan.attr("stas");
	
		if(status=="show" || typeof(status) == "undefined")	{
			$(".content").hide();
			showSpan.attr("stas","hidden");
			$(window.parent.document).find("#btnStatus").attr("value",'<%=SystemEnv.getHtmlLabelName(16216,user.getLanguage())%>');
			if(showSpan.attr("id")  == "spanStatus") try{showSpan.html('<%=SystemEnv.getHtmlLabelName(16216,user.getLanguage())%>');}catch(e){}	
			if(rightspanmenu.length>0){
			   rightspanmenu.html('<%=SystemEnv.getHtmlLabelName(16216,user.getLanguage())%>');
			}
			$(".item[isInited!='true']").css("min-height",0)
		} else {
			$(".content").show() ;			
			$(showSpan).attr("stas","show");
			$(window.parent.document).find("#btnStatus").attr("value",'<%=SystemEnv.getHtmlLabelName(18466,user.getLanguage())%>');
			if(showSpan.attr("id")  == "spanStatus") try{showSpan.html('<%=SystemEnv.getHtmlLabelName(18466,user.getLanguage())%>');}catch(e){}
			if(rightspanmenu.length>0){
			   rightspanmenu.html('<%=SystemEnv.getHtmlLabelName(18466,user.getLanguage())%>');
			}
			$(".item[isInited!='true']").css("min-height","160px")
		}	
	}
	
	
	function onChanageSynersyStatus(hpid){			
		var synersy=$("#synersyStatus");
		var status=synersy.attr("stas");
		if(status=="1" || typeof(status) == "undefined")	{//已启用
			synersy.attr("stas","0");
		} else {// 不启用
			synersy.attr("stas","1");
		}	
		
		$.ajax({
		   type: "POST",
		   cache: false,
		   url: "/homepage/element/EsettingOperate.jsp?method=synernyisusechange&hpid="+hpid+"&isuse="+synersy.attr("stas"),
		   success: function(data){
				if(data.trim() == '1'){
				   if(status=="1" || typeof(status) == "undefined")	{//已启用
						$(window.parent.document).find("#synersyStatus").attr("value","<%=SystemEnv.getHtmlLabelName(31676,user.getLanguage())%>");
					} else {// 不启用
						$(window.parent.document).find("#synersyStatus").attr("value","<%=SystemEnv.getHtmlLabelName(31675,user.getLanguage())%>");
					}	
				   top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83323,user.getLanguage())%>!");
				}else{
				   top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83798,user.getLanguage())%>!");
				}
		   }
		}); 
	}
	
	
	
	function chkReplyClick(obj,eid,name){
		onNewContentCheck(document.getElementById(name+"_"+eid),eid,name)
	}


	function onNewContentCheck(obj,eid,name){	
		obj.checked=true;			
		var isHaveReply="0";
		try{
			if(document.getElementById("chk"+name+"_"+eid).checked) isHaveReply="1";
		} catch(e){
		}
		
		document.getElementById("_whereKey_"+eid).value=$(obj).attr("selecttype")+"|"+obj.value+"|"+isHaveReply;		
		
	}

	function onShowCatalog(input,span,eid) {
		var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
		if (result != null) {
		    if (result[0] > 0)  {
				input.value=result[1]
				span.innerHTML=result[5];
			}else{
				input.value="0";
				span.innerHTML="";
			}
		}
		onNewContentCheck(input,eid,'cate')
	}

	function onWFEClick(obj){
		if(!obj.checked){ //如果取消选择,则后面所有的选择都取消
			//得到后面所有的节点checkbox 设为非选
			var objNextTd=obj.parentNode.nextSibling;
			var objNodes=objNextTd.getElementsByTagName("input");
			for(var i=0;i<objNodes.length;i++){
				var objNode=objNodes[i];
				objNode.checked=false;
				//alert(objNode.value);
			}
		}
	}	
	function onWFENodeClick(obj){
		if(obj.checked){ //如果选择,流程就选择
			var objPreTd=obj.parentNode.previousSibling;
			var objNodes=objPreTd.getElementsByTagName("input");
			for(var i=0;i<objNodes.length;i++){
				var objNode=objNodes[i];
				objNode.checked=true;
				//alert(objNode.value);
			}
		}
	}
	
	function onViewTypeChange(obj,eid){		
		document.getElementById("ifrmViewType_"+eid).src="/homepage/element/setting/WorkflowCenterBrowser.jsp?viewType="+obj.value+"&eid="+eid;
		//alert(obj.value)
	}

	function elmentReLoad(ebaseid){

		/*var tables=document.getElementsByTagName("div");		
		for(var i=0;i<tables.length;i++){
			var tbl=tables[i];
			if(tbl.ebaseid==ebaseid) {
				var tblEid=tbl.eid;
				try{
					eval("objE"+tblEid).contentLoad();
				} catch(e){}
			}
		}*/
		
		$(".item[ebaseid="+ebaseid+"]").attr('needRefresh','true')
		$(".item[ebaseid="+ebaseid+"]").trigger("reload");
	}
	
	function onWorktaskSetting(obj){
		var objParent=obj.parentNode;
		var children=objParent.getElementsByTagName("INPUT");
		var value="";
		for(var i=0;i<children.length;i++){
			var child=children[i];			
			if(child.type=="checkbox" && child.checked){
				value+=child.value+"|";
			}						
		}
		if(value!="") value=value.substring(0,value.length-1);
		//objParent.firstChild.value=value;	
	    jQuery(objParent).find("input[type='hidden']:first").val(value);
	}

function loadContent(eid,url,queryString,e){
	var event = $.event.fix(e);
	var tabId = jQuery(event.target).attr("tabId");
	if(tabId==undefined) tabId = jQuery(event.target).parents("td:first").attr("tabId");

	var ebaseid = $("#item_"+eid).attr("ebaseid");
	url = url + "?tabId="+tabId+"&"+queryString;
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var objTd=event.target;
	if(event.target.tagName!='TD') objTd=jQuery(event.target).parents("td:first");
	
	$(objTd).siblings().removeClass("tab2selected").removeClass("tab2unselected").addClass("tab2unselected");
	$(objTd).removeClass("tab2unselected").addClass("tab2selected");
	
	$("#tabContant_"+eid).html("<img src=/images/loading2_wev8.gif><%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...")
	try{
			if(ebaseid==1||ebaseid==29){
				$.get(url, { name: "John", time: "2pm" },function(data){
				
				$("#tabContant_"+eid).html($.trim(data));
					fixedPosition(eid);
					//$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
					$('#item_'+eid+' .img_more').parent().attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
			  } ); 
			}else{
				$("#tabContant_"+eid).load(url,{},function(){
					fixedPosition(eid);
					//$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
					$('#item_'+eid+' .img_more').parent().attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
				});
			}
		} catch(e){}
}

function loadContentForChart(eid,url,queryString,tabId){

	var ebaseid = $("#item_"+eid).attr("ebaseid");
	url = url + "?tabId="+tabId+"&"+queryString;
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var objTd=$("#tabContainer_"+eid).find("td[tabId='"+tabId+"']");
	
	$(objTd).siblings().removeClass("tab2selected").removeClass("tab2unselected").addClass("tab2unselected");
	$(objTd).removeClass("tab2unselected").addClass("tab2selected");
	
	$("#tabContant_"+eid).html("<img src=/images/loading2_wev8.gif><%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...")
	try{
			if(ebaseid==1||ebaseid==29){
				$.get(url, { name: "John", time: "2pm" },function(data){
				
				$("#tabContant_"+eid).html($.trim(data));
					fixedPosition(eid);
					$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
			  } ); 
			}else{
				$("#tabContant_"+eid).load(url,{},function(){
					fixedPosition(eid);
					$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
				});
			}
		} catch(e){}
}


function showDBSetting(eid){
	if(parseInt(event.srcElement.value)==1){
		$("#dbSetting_"+eid).css("display","")
	}else{
		$("#dbSetting_"+eid).css("display","none")
	}
}
function openFullWindowForXtable(url){
	//添加协同参数传递
	var reqid='<%=Util.null2String(request.getParameter("requestid"))%>';
	var hpid='<%=Util.null2String(request.getParameter("hpid"))%>';
	var pagetype='<%=Util.null2String(request.getParameter("pagetype"))%>';
	var fieldids='<%=Util.null2String(request.getParameter("fieldids"))%>';
	var fieldvalues='<%=Util.null2String(request.getParameter("fieldvalues"))%>';
	if(url.indexOf("/")==0){
		if (url.indexOf("?") != -1) {
			url += "&";
		} else {
			url += "?";
		}
		url += "e7" + new Date().getTime() + "=";	
		if(reqid!=='')
			url+="&requestid="+reqid;
		if(hpid!=='')
            url+="&hpid="+hpid;
		if(pagetype!=='')
            url+="&pagetype="+pagetype;
		if(fieldids!=='')
            url+="&fieldids="+fieldids;
		if(fieldvalues!=='')
            url+="&fieldvalues="+fieldvalues;
	}
	var redirectUrl = url ;
	var width = screen.availWidth ;
	var height = screen.availHeight ;
	var szFeatures = "top=0," ; 
	szFeatures +="left=0," ;
	if(url.indexOf("ebaseid=15")!=-1){
		//td61285
		//szFeatures +="width=800," ;
		szFeatures +="width="+(width-10)+"," ;
	}else{
		szFeatures +="width="+(width-10)+"," ;
	}
	szFeatures +="height="+(jQuery.browser.msie?height:(height-60))+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ;
	window.open(redirectUrl,"",szFeatures) ;
}


function openFullWindowForDoc(url,docid){
    try{
		$("#doclist_"+docid+"img").hide();
		$("#doclist_"+docid+"img").parent('.docdetail').find('.docnamedetail').removeAttr("style");
		$("#doclist_"+docid+"img").parent('.docdetail').find('.docnamedetail').css("color","#242424");
	}catch(e){}
    
	if(url.indexOf("/")==0){
		if (url.indexOf("?") != -1) {
			url += "&";
		} else {
			url += "?";
		}
		url += "e7" + new Date().getTime() + "=";	
	}
	var redirectUrl = url ;
	var width = screen.availWidth ;
	var height = screen.availHeight ;
	var szFeatures = "top=0," ; 
	szFeatures +="left=0," ;
	szFeatures +="width="+(width-10)+"," ;
	szFeatures +="height="+(height-60)+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ;
	window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowHaveBarForWFList(url,requestid){
	try{
		document.getElementById("wflist_"+requestid+"span").innerHTML = "";
	}catch(e){}
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var redirectUrl = url ;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	//if (height == 768 ) height -= 75 ;
	//if (height == 600 ) height -= 60 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
	
	
function openFullWindowHaveBar(url){    
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var redirectUrl = url ;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	//if (height == 768 ) height -= 75 ;
	//if (height == 600 ) height -= 60 ;
	 var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}


function openFullWindowHaveBarForWF(url,requestid){
    
    try{
		$("#wflist_"+requestid+"img").hide();
		$("#wflist_"+requestid+"img").parent('.reqdetail').find('.reqname').removeAttr("style");
	}catch(e){}
     
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var redirectUrl = url ;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	//if (height == 768 ) height -= 75 ;
	//if (height == 600 ) height -= 60 ;
	 var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}

function  readCookie(name){  
   var  cookieValue  =  "7";  
   var  search  =  name  +  "=";
   try{
	   if(document.cookie.length  >  0) {    
	       offset  =  document.cookie.indexOf(search);  
	       if  (offset  !=  -1)  
	       {    
	           offset  +=  search.length;  
	           end  =  document.cookie.indexOf(";",  offset);  
	           if  (end  ==  -1)  end  =  document.cookie.length;  
	           cookieValue  =  unescape(document.cookie.substring(offset,  end))  
	       }  
	   }  
   }catch(exception){
   }
   return  cookieValue;  
} 


function loadRssElementContent(eid,rssUrl,imgSymbol,hasTitle,hasDate,hasTime,titleWidth,dateWidth,timeWidth,rssTitleLength,linkmode,size,perpage,languageid){
 	var returnStr="";
 		
	var objDiv = document.getElementById("rssContent_"+eid);
	try{
		var rssRequest = XmlHttp.create();
		rssRequest.open("GET",rssUrl, true);	
		rssRequest.onreadystatechange = function () {
			switch (rssRequest.readyState) {
			   case 3 : 					
					break;
			   case 4 : 
				   if (rssRequest.status==200)  {

                     returnStr+="<TABLE id=\"_contenttable_"+eid+"\" style=\"width:100%\" class=\"Econtent\">"+
						  " <TR>"+
						  " <TD width=\"1px\"></TD>"+
						  " <TD width=\"*\" valign=\"center\">"+
						  "	    <TABLE  width=\"100%\">";
				   
						var items=rssRequest.responseXML;
						var titles=new Array(),pubDates=new Array(); dates=new Array(), times=new Array(), linkUrls=new Array(), descriptions=new Array()	
							
						var items_count=items.getElementsByTagName('item').length;

						if(items_count>perpage) items_count=perpage;
				
						for(var i=0; i<items_count; i++) {
							titles[i]="";
							pubDates[i]="";
							linkUrls[i]="";
							descriptions[i]="";
							dates[i]="";
							times[i]="";

							if(items.getElementsByTagName('item')[i].getElementsByTagName('title').length==1)
								titles[i]=items.getElementsByTagName('item')[i].getElementsByTagName('title')[0].firstChild.nodeValue;


							if(items.getElementsByTagName('item')[i].getElementsByTagName('pubDate').length==1)
								pubDates[i]=items.getElementsByTagName('item')[i].getElementsByTagName('pubDate')[0].firstChild.nodeValue;

							if(items.getElementsByTagName('item')[i].getElementsByTagName('link').length==1)
								linkUrls[i]=items.getElementsByTagName('item')[i].getElementsByTagName('link')[0].firstChild.nodeValue;

							
							returnStr+="<TR height=18px>"+
									   "  <TD width=\"8\">"+imgSymbol+"</TD>";

							
							if(hasTitle=="true"){
								 returnStr+="<TD width="+titleWidth+">";
								 var tempTitle = "";
								 /*if(titles[i].length>rssTitleLength){
								 	tempTitle = titles[i].substring(0,rssTitleLength)+"...";
								 }else{
								 	tempTitle = titles[i];
								 }*/
								 tempTitle = titles[i];
								
								 if(linkmode=="1"){
									returnStr+="<a class='ellipsis' href=\""+linkUrls[i]+"\" target=\"_self\" title=\""+titles[i]+"\"><FONT class=\" font\" >"+tempTitle+"</FONT></a>";
								 } else {
									returnStr+="<a class='ellipsis' href=\"javascript:openFullWindowForXtable('"+linkUrls[i]+"')\" title=\""+titles[i]+"\"><FONT class=\" font\"  >"+tempTitle+"</FONT></a>";
								 } 
								 returnStr+="</TD>";
							} 
							
							if(pubDates[i]!=""){
								var d = new Date(pubDates[i]);
							
								if(d!='NaN'){
									dates[i]=d.getFullYear()+"-"+(d.getMonth() + 1) + "-"+d.getDate() ;
	
									if(d.getHours()<=9)	times[i]+="0"+d.getHours() + ":";
									else times[i]+= d.getHours() + ":";
	
									if(d.getMinutes()<=9)	times[i]+="0"+d.getMinutes() + ":";
									else times[i]+= d.getMinutes() + ":";
	
									if(d.getSeconds()<=9)	times[i]+="0"+d.getSeconds();
									else times[i]+= d.getSeconds() ;
								}else{
									dates[i]="";
									times[i]="";
								}
							} else {
								dates[i]="";
								times[i]="";
							}
							if(hasDate=="true"){
								returnStr+="<TD width="+dateWidth+">"+"<font class=font>"+dates[i]+"</font>"+"</TD>";
							}
							if(hasTime=="true"){
								returnStr+="<TD width="+timeWidth+">"+"<font class=font>"+times[i]+"</font>"+"</TD>";
							}
							returnStr+="</TR>";

							if(i<items_count-1){
								returnStr+="<TR class=\"sparator\" style='height:1px'><TD style='padding:0px' colspan="+(size+1)+"></TD></TR>";	
							}
					
						}
					

						returnStr+="		</TABLE>"+
								  "	</TD>"+
								  " <TD width=\"1px\"></TD>"+
								  " </TR>"+
								  "</TABLE>";
						
						objDiv.innerHTML=returnStr;
				   } else {
					   objDiv.innerHTML=rssRequest.responseText;
				   }
				   break;
			} 
		}	
		rssRequest.setRequestHeader("Content-Type","text/xml")	
		rssRequest.send(null);	
	} catch(e){      
        if(e.number==-2147024891){
              objDiv.innerHTML="<%=SystemEnv.getHtmlLabelName(127877,user.getLanguage())%>&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(<%=SystemEnv.getHtmlLabelName(127878,user.getLanguage())%>?)</a>";
        }   else {
            objDiv.innerHTML=e.number+":"+e.description;
        }
    }
	
}

function onChangeImgType(eid,value){
	if(event.srcElement.value==0){
		$("#imgsrcDiv_"+eid).hide()
	}else{
		$("#imgsrcDiv_"+eid).show()
		if(document.getElementById("_imgsrc"+eid).className=='filetree'){
			$("#_imgsrc"+eid).filetree();
		}
	}
}

function onLoadComplete(ifm){
	try{
		if(ifm.readyState=="complete"){   
			if(ifm.contentWindow.document.body.scrollHeight>ifm.height){
				ifm.style.height = ifm.height;
			}else{
				ifm.style.height = ifm.contentWindow.document.body.scrollHeight;
			}
		}
	}catch(e){
		//alert(e.message);
	}
	//$("#item_"+eid).attr("isInited","true");
	//alert(ifm.outerHTML);
	//setTimeout(elementLoad_queue, 200);
	//elementLoad_queue();
}
function onShowMultiCatalog(input,span,eid){	
       splitflag = ",,,"
	   var dlg=new window.top.Dialog();//定义Dialog对象
	   dlg.Model=true;
	   dlg.Width=550;//定义长度
	   dlg.Height=550;
	   dlg.URL="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategoryMBrowser.jsp?para="+input.value+"&splitflag="+splitflag;
	   dlg.Title="<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%>";
	   dlg.callbackfun=function(params,datas){

			if (datas) {
			    if (datas.id!= "") {
			        ids = datas.id.split(",");
				    names =datas.name.split(",");
				    sHtml = "";
				    for( var i=0;i<ids.length;i++){
					    if(ids[i]!=""){
					    	sHtml = sHtml+"<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="+ids[i]+"' target='_blank'>"+names[i]+"</a>&nbsp";
					    }
				    }
				    $(span).html(sHtml);
				    $(input).val(datas.id);
			    }
			    else	{
		    	     $(span).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				     $(input).val("");
			    }
			    onNewContentCheck(input,eid,"cate");
			}
	   }
	   dlg.show();


			
			
}


function onShowMultiCatalog2(input,span,eid){	
       splitflag = ",,,"
	   var dlg=new window.top.Dialog();//定义Dialog对象
	   dlg.Model=true;
	   dlg.Width=550;//定义长度
	   dlg.Height=550;
	   dlg.URL="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategoryMBrowser.jsp?para="+input.value+"&splitflag="+splitflag;
	   dlg.Title="<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%>";
	   dlg.callback=function(datas){
			if (datas) {
			    if (datas.id!= "") {
			        tempids = ","+datas.id;
			        temppaths = "," + datas.path;
			        var ids = tempids.split(",");
				    var paths =temppaths.split(",");
				    sHtml = "";
				   
				    for( var i=0;i<ids.length;i++){
					    if(ids[i]!=""){
					    	sHtml = sHtml+"<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="+ids[i]+"' target='_blank'>"+paths[i]+"</a>&nbsp";
					    }
				    }
				    $(span).html(sHtml);
				    $(input).val(datas.id);
			    }
			    else{
		    	     $(span).html("");
				     $(input).val("");
			    }
			    onNewContentCheck(input,eid,"cate");
			}
	   }
	   dlg.show();


			
			
}

function onShowDoc(input,span,eid){

	       var dlg=new window.top.Dialog();//定义Dialog对象
           dlg.Model=true;
           dlg.Width=550;//定义长度
           dlg.Height=550;
           dlg.URL="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?from=hpelement";
           dlg.Title="<%=SystemEnv.getHtmlLabelName(20885,user.getLanguage())%>";
		   dlg.callbackfun=function(params,datas){
			    if(datas){
					if(datas.id!=""){
						$(input).val(datas.id);
						$(span).html( "<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"'  target='_blank'>"+datas.name+"</a>");
					}
					else{
						$(input).val("");
						$(span).html("");
					}
			     }
	       }
           dlg.show();
	
	
			
}
function onShowMutiDummy(input,span,eid)	{
	splitflag = ",,,";
   var dlg=new window.top.Dialog();//定义Dialog对象
   dlg.Model=true;
   dlg.Width=550;//定义长度
   dlg.Height=550;
   dlg.URL="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"&splitflag="+splitflag;
   dlg.Title="<%=SystemEnv.getHtmlLabelName(18441,user.getLanguage())%>";
   dlg.callbackfun=function(params,datas){
		if (datas) {
			if (datas.id!= ""){
				dummyidArray=datas.id.split(",");
				dummynames=datas.name.split(",");
				dummyLen=dummyidArray.length;
				sHtml="";
				for(var k=0;k<dummyLen;k++){
					sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'   target='_blank'>"+dummynames[k]+"</a>&nbsp;";
				}
				input.value=datas.id;
				span.innerHTML=sHtml;
			}
			else{			
				input.value="";
				span.innerHTML="";
			}
			onNewContentCheck(input,eid,"");
	   }
   }
   dlg.show();	
}

function onSelectBgImg(input, span, eid) {
    imgfileid = document.getElementById("_eBackground_" + eid).value;

    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/element/setting/img.jsp?para=" + eid + "_" + imgfileid);
    if (data) {
        //alert(id(0));
        //alert(id(1));
        if (data.id != "") {
            input.value = data.id;
            span.innerHTML = data.name;
        } else {
            span.innerHTML = "";
            input.value = "";
        }
    }
}

function onShowNew(input, span, eid) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp");
    if (data) {
        if (data.id != "") {
            span.innerHTML = "<a href='/docs/news/NewsDsp.jsp?id=" + data.id + "' target='_blank'>" + data.name + "</a>";
            input.value = data.id;

        } else {;
            span.innerHTML = "";
            input.value = "0";
        }
        onNewContentCheck(input, eid, "news");
    }
}

function onShowSearchTemplet(input, span, eid) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/DocSearchTempletBrowser.jsp");
    if (data) {
        if (data.id != "") {
            span.innerHTML = data.name;
            input.value = data.id;
            onNewContentCheck(input, eid, "");
        } else {;
            span.innerHTML = "";
            input.value = "";
        }
    }
}

function onShowMenus(input, span, eid) {
    //console.dir(arguments);
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.Width=550;//定义长度
	dlg.Height=560;
	dlg.URL="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenusBrowser.jsp";
	//console.log("=======================");
	dlg.callbackfun=function(data){
		if (data) {
	        if (data.id != "") {
	           if (data.id == "hp") {
	                span.innerHTML = "<a href='/homepage/maint/HomepageLocation.jsp' target='_blank'>" + data.name + "</a>";
	            } else if (data.id == "sys") {
	                span.innerHTML = "<a href='/systeminfo/menuconfig/MenuMaintFrame.jsp?type=" + data.id + "' target='_blank'>" + data.name + "</a>";
	            } else {
	               span.innerHTML = "<a href='/page/maint/menu/MenuEdit.jsp?id=" + data.id + "' target='_blank'>" + data.name + "</a>";
	            }
	           input.value = data.id;
	        } else {
	           span.innerHTML = "";
	           input.value = "0";
	        }
	    }
	}
	dlg.show();
 
}


function onClickMenuType(obj,eid){
        var menuType = document.getElementById("menuTypeId_"+eid);
		var spanMenuType = document.getElementById("spanMenuTypeId_"+eid);
		var tempMenuType = document.getElementById("tempMenuTypeId_"+eid);
		var mTypes = document.getElementById("menuType_"+eid);
		menuType.value = "";
		spanMenuType.innerHTML = "";
		tempMenuType.value = obj.value;
}

function onShowMenuTypes(input, span, eid, menutype) {
    menutype = menutype.value;
    var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.Width=550;//定义长度
	dlg.Height=560;
	dlg.URL="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=" + menutype;
	dlg.callbackfun=function(data){
		menulink = "";
	    if (menutype == "element") {
	        menulink = "ElementStyleEdit.jsp";
	    } else if (menutype == "menuh") {
	        menulink = "MenuStyleEditH.jsp";
	    } else {
	        menulink = "MenuStyleEditV.jsp";
	    }
	    if (data) {
	        if (data.id != "") {
	            span.innerHTML = "<a href='/page/maint/style/" + menulink + "?styleid=" +data.id + "&type=" + menutype + "&from=list' target='_blank'>" + data.name + "</a>";
	            input.value = data.id;
	        } else {
	            span.innerHTML = "";
	            input.value = "0";
	        }
	    }
	}
	dlg.show();
}

function onShowMenuTypes2(input, span, eid, menutype) {
    menutype = menutype.value;
    var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.Width=550;//定义长度
	dlg.Height=560;
	dlg.URL="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=" + menutype;
	dlg.callback=function(data){
		menulink = "";
	    if (menutype == "element") {
	        menulink = "ElementStyleEdit.jsp";
	    } else if (menutype == "menuh") {
	        menulink = "MenuStyleEditH.jsp";
	    } else {
	        menulink = "MenuStyleEditV.jsp";
	    }
	    if (data) {
	        if (data.id != "") {
	            span.innerHTML = "<a href='/page/maint/style/" + menulink + "?styleid=" +data.id + "&type=" + menutype + "&from=list' target='_blank'>" + data.name + "</a>";
	            input.value = data.id;
	        } else {
	            span.innerHTML = "";
	            input.value = "0";
	        }
	    }
	}
	dlg.show();
}
</script>


<SCRIPT language="VBScript">
	Function URLEncoding(vstrIn)
    strReturn = ""	
	dim i
    For i = 1 To Len(vstrIn)
        ThisChr = Mid(vStrIn,i,1)
        If Abs(Asc(ThisChr)) < &HFF Then
            strReturn = strReturn & ThisChr
        Else
            innerCode = Asc(ThisChr)
            If innerCode < 0 Then
                innerCode = innerCode + &H10000
            End If
            Hight8 = (innerCode  And &HFF00)\ &HFF
            Low8 = innerCode And &HFF
            strReturn = strReturn & "%" & Hex(Hight8) &  "%" & Hex(Low8)
        End If
    Next
    URLEncoding = strReturn
End Function
</SCRIPT>

<script type="text/javascript">
	function onShowNewNews(input,span,eid,publishtype){
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
		var dlg=new window.top.Dialog();//定义Dialog对象
		dlg.Model=true;
		dlg.Width=550;//定义长度
		dlg.Height=550;
		dlg.URL = "/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp?publishtype="+publishtype;
		dlg.callback=function(datas){
			if (datas){
						if (datas.id){
							$(span).html( "<a href='/docs/news/NewsDsp.jsp?id="+datas.id+"' target='_blank'>" +datas.name+"</a>");
							$(input).val(datas.id);
						}else{ 
							$(span).html( "");
							$(input).val("");
						}
				   }
		   }
	    dlg.show();
	}
	function setPictureWidth(eid,needButton)
	{
		try
		{
			var pictureTable = document.getElementById("pictureTable_"+eid);
			var picture = document.getElementById("picture_"+eid);
			pictureTable.style.display = "none";
			var pwidth = pictureTable.parentNode.offsetWidth;
			
			if(needButton=="1")
			{
				if(pwidth>64)
				{
					pwidth = pwidth-64;
				}
			}
			else
			{
				pwidth = pwidth-6;
			}
			
			picture.style.width=pwidth;
			$("#picture_"+eid).width(pwidth);
			pictureTable.style.display = "";
		}
		catch(e)
		{
		}
	}
	function autoMarquee(eid)
	{
		try
		{
			var pictureothertd = document.getElementById("pictureothertd_"+eid);
			var picture  = document.getElementById("picture_"+eid);
			var picturetd = document.getElementById("picturetd_"+eid);
			
			if(pictureothertd.offsetWidth-picture.scrollLeft<=0)
			{
				picture.scrollLeft -= picturetd.offsetWidth;
			}
			else
			{
				picture.scrollLeft ++ ;
			}
		}
		catch(e)
		{
		
		}
	}
	
	function doScrollAuto(eid,needButton,speed){

		var myMar = window["mars_"+eid];
		var picture = document.getElementById("picture_"+eid);
		var picturetd = document.getElementById("picturetd_"+eid);
		var pictureothertd = document.getElementById("pictureothertd_"+eid);
		var pictureotherlinktd = document.getElementById("pictureotherlinktd_"+eid);
		var picturelinktd = document.getElementById("picturelinktd_"+eid); 
		var picturenext = document.getElementById("picturenext_"+eid);
		var pictureback = document.getElementById("pictureback_"+eid);
		
		if(picture.offsetWidth < picturetd.offsetWidth){
			pictureothertd.innerHTML=picturetd.innerHTML;
			pictureotherlinktd.innerHTML=picturelinktd.innerHTML;
			clearInterval(myMar);
			myMar=setInterval(function(){autoMarquee(eid)},speed);
			window["mars_"+eid]=myMar;
		}
		
		picture.onmouseover = function(){clearInterval(myMar);};
		picture.onmouseout = function(){myMar = setInterval(function(){autoMarquee(eid)},speed);window["mars_"+eid]=myMar;};
		if("1"==needButton){ 
			picturenext.onmouseover = function(){clearInterval(myMar);};
			picturenext.onmouseout = function(){myMar = setInterval(function(){autoMarquee(eid)},speed);window["mars_"+eid]=myMar;};
			pictureback.onmouseover = function(){clearInterval(myMar);};
			pictureback.onmouseout = function(){myMar = setInterval(function(){autoMarquee(eid)},speed);window["mars_"+eid]=myMar;};
		}
		
		
	}
	
	function nextMarquee(eid)
	{
		//if(pictureothertd.offsetWidth-picture.scrollLeft<=0)
			//{
			//	picture.scrollLeft -= picturetd.offsetWidth;
			//}
			//else
			//{
			//	picture.scrollLeft ++ ;
			//}
		document.getElementById("picture_"+eid).scrollLeft+=75;
		//alert(document.getElementById("picture_"+eid).scrollLeft)
		//autoMarquee(eid)
		//	alert(document.getElementById("picture_"+eid).scrollLeft)
	}
	
	function backMarquee(eid)
	{
		document.getElementById("picture_"+eid).scrollLeft-=75;
		
	}
	
	function selectEngine(eid)
	{
		var keyword =document.getElementById("searchf_"+eid).keyword.value;
		var saction = "/page/element/SearchEngine/NewsSearchList.jsp?eid="+eid+"&keyword=";	
		saction +=keyword;
		openFullWindowForXtable(saction)
	
	}
</script>

<script type="text/javascript">
function changeMsg(eid,msg)
{	
	var frmLogin = document.getElementById("frmLogin_"+eid);
	var validatecode = frmLogin.validatecode;
    if(msg==0)
    {
       	if(validatecode.value=='<%=SystemEnv.getHtmlLabelName(22909,7)%>') 
           	validatecode.value='';
    }
    else if(msg==1)
    {
        if(validatecode.value=='') 
            validatecode.value='<%=SystemEnv.getHtmlLabelName(22909,7)%>';
    }
}
function checkall(eid,userparamname,userparampass,needvalidate,usbType)
{
	var errMessage="";
	var frmLogin = document.getElementById("frmLogin_"+eid);	
	var loginid = document.getElementById(userparamname);
	var userpassword = document.getElementById(userparampass);
	
	if (loginid&&loginid.value=="") 
	{
		errMessage="<%=SystemEnv.getHtmlLabelName(16647,7)%>";
		alert(errMessage);
		loginid.focus();
		return false ;
	}
	if (userpassword&&userpassword.value=="") 
	{
		errMessage="<%=SystemEnv.getHtmlLabelName(16648,7)%>";
		alert(errMessage);
		userpassword.focus();
		return false ;
	}
	if(needvalidate=="1"){
		var validatecode = frmLogin.validatecode;
		if (validatecode&&(validatecode.value==""||validatecode.value=='<%=SystemEnv.getHtmlLabelName(22909,7)%>')) 
		{
			errMessage="<%=SystemEnv.getHtmlLabelName(22909,7)%>";
			alert(errMessage);
			validatecode.focus();
			return false ;
		}
	}
	frmLogin.submit(); 
	loginid.value="";
   	userpassword.value="";
  	$("#message_"+eid).html("");

}


function getBytesLength(str) {
	// 在GBK编码里，除了ASCII字符，其它都占两个字符宽
	return str.replace(/[^\x00-\xff]/g, 'xx').length;
}

/**
 * 根据字符长来截取字符串
 */
function subStringByBytes(val, maxBytesLen) {
	var len = maxBytesLen;
	var result = val.slice(0, len);
	while(getBytesLength(result) > maxBytesLen) 
	{
		result = result.slice(0, --len);
	}
	return result;
}

function saveScratchpad(eid,userid)
{
	var scratchpadareatext = document.getElementById("scratchpadarea_"+eid);
	scratchpadareatext.disabled = true;
	
	var padcontent = jQuery(scratchpadareatext).val();
	
	var len = getBytesLength(padcontent);
	//alert("len : "+len);
	if(len>4000)
	{
		var reply=confirm("<%=SystemEnv.getHtmlLabelName(22934, user.getLanguage())%>?");
		if(reply)
		{
			padcontent = subStringByBytes(padcontent,4000);
			$.post("/page/element/scratchpad/ScratchpadOperation.jsp", { eid:eid, userid:userid, operation: "save",padcontent:padcontent },function(data){
			    	data = data.replace(/(^\s*)|(\s*$)/g, "");
			    	var scratchpadareatext = document.getElementById("scratchpadarea_"+eid);
			    	jQuery(scratchpadareatext).val(data);
	    			scratchpadareatext.disabled = false;
			});
		}
		else
		{
			scratchpadareatext.focus();
			scratchpadareatext.disabled = false;
		}
	}
	else
	{
		$.post("/page/element/scratchpad/ScratchpadOperation.jsp", { eid:eid,userid:userid, operation: "save",padcontent:padcontent },function(data){
			scratchpadareatext.disabled = false;
		});
	}
}

    /**
	*天气元素滚动控制
	*/
   function weatherAutoScroll(weatherId){
                
                var demo=document.getElementById(weatherId+"_0");
				
                var demo1=document.getElementById(weatherId+"_1");
				
                var demo2=document.getElementById(weatherId+"_2");
                
                var speed=30;
				var flag=0;  //用于记录 demo.scrollLeft 的位置，防止设置宽度过短时，出现滚动停止现象
				demo2.innerHTML=demo1.innerHTML;
				var Marquee=function(){
					if(demo2.offsetWidth-demo.scrollLeft<=0){
					     demo.scrollLeft-=demo1.offsetWidth;
					  }
					else if(flag==demo.scrollLeft&&demo.scrollLeft!=0)
					    demo.scrollLeft-=demo1.offsetWidth;
					else{
					    flag=demo.scrollLeft;
					    demo.scrollLeft++;
					}
				};
				var MyMar=setInterval(Marquee,speed);
				demo.onmouseover=function() {clearInterval(MyMar)};
				demo.onmouseout=function() {MyMar=setInterval(Marquee,speed)};

    }
/**
	*天气元素手动滚动控制
	*/
	function nextWeatherMarquee(eid)
	{
		//if(pictureothertd.offsetWidth-picture.scrollLeft<=0)
			//{
			//	picture.scrollLeft -= picturetd.offsetWidth;
			//}
			//else
			//{
			//	picture.scrollLeft ++ ;
			//}
		document.getElementById("weather_"+eid+"_0").scrollLeft+=75;
		//alert(document.getElementById("picture_"+eid).scrollLeft)
		//autoMarquee(eid)
		//	alert(document.getElementById("picture_"+eid).scrollLeft)
	}
	
	function backWeatherMarquee(eid)
	{
		document.getElementById("weather_"+eid+"_0").scrollLeft-=75;
		
	}

    //设置提示信息
    function setRemindInfo(eid, isremind,tdclass,nameclass){
	    var tempremind="";
		if(isremind.indexOf("#")>-1){
		   tempremind=isremind.substring(0,isremind.indexOf("#")-1);
		}else{
		   tempremind=isremind;
		}
	    //无new标签
		if(tempremind.indexOf("0")===-1){
			 $("#item_"+eid).find("."+tdclass).find("img").hide();
		} 
		
		var obj = [];
		 var reminditems={};
		 if("reqdetail" == tdclass){	//流程特别处理，
//			reminditems=$("#item_"+eid).find("."+tdclass).find("a").next().find("img").parents("."+tdclass);//有主从账号的新到图标外层有span，还有人力资源图标
             reminditems=$("#item_"+eid).find("."+tdclass).find(".notRead").parents("."+tdclass);//找到所有class名为notRead的a标签的父dom元素
			if(reminditems.length == 0){//主从账号没有选到对象时，还需要非主从账号的情况（img有id，新到图标外层没有有span，没有人力资源图标）
				reminditems=$("#item_"+eid).find("."+tdclass).find("img[id]").parents("."+tdclass);
			}
		}else{
			reminditems=$("#item_"+eid).find("."+tdclass).find("img").parents("."+tdclass);
		}
		 var reminditem,color,reqname,reqfontname;
		 for(var i=0,len=reminditems.length;i<len;i++){
			 reminditem=$(reminditems[i]);
			 reqname=reminditem.find("."+nameclass);
			 var str = "";
			 //粗体
			 if(tempremind.indexOf("1")!==-1){
                 if("reqdetail" == tdclass) {	//流程特别处理，
                     //将class名为reqname的span标签的子标签去除font的class
                     reqfontname=reqname.find("font");
                     reqfontname.removeClass("font");
                 }
				  reqname.css("font-weight","bold"); 
			      obj.push("font-weight:bold");
			 }
			 //斜体
			 if(tempremind.indexOf("2")!==-1){
                 if("reqdetail" == tdclass) {	//流程特别处理，
                     //将class名为reqname的span标签的子标签去除font的class
                     reqfontname=reqname.find("font");
                     reqfontname.removeClass("font");
                 }
				  reqname.css("font-style","italic");
				  obj.push("font-style:italic");
			 }
			 //颜色
			 if(tempremind.indexOf("3")!==-1){
				color=isremind.substr(isremind.indexOf("#"));
				//reqname.css("color",color +" !important");
				//reqname[0].style.setProperty('color', color, 'important');
				//reqname.removeClass("font");
                 if("reqdetail" == tdclass) {	//流程特别处理，
                     //将class名为reqname的span标签的子标签去除font的class
                     reqfontname=reqname.find("font");
                     reqfontname.removeClass("font");
                 }
				reqname.attr('style', '');
			    obj.push("color:"+color+"!important;");
			 }
			 $(reqname).attr('style', obj.join(";"));
			 
			 
		 }
	}
</script>
