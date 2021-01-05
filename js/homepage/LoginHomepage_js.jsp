<script language="javascript"><!--
var isSetting=false;
var tempEid=0; //临时元素ID
var objAreaFlags = new Array();
var mode="run"; //确定页面模式  debug run
var initEnd=20; //从门户过来的数据，这个页面需要在前一段时间进行高度自适应


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

var initRefresh=0;

function doResize(){
	if(initRefresh<initEnd){		
		try{				
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
			}else{
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
	
	$(".item").trigger("reload");
	
	
	
	doResize(); 
	

	
});

function elementReload(ebaseid,eid,top,bottom,topRadian,bottomRadian){	

	if($("#item_"+eid).attr('needRefresh')=='false'){
		//alert($("#item_"+eid).attr('needRefresh'))
		return;
	}
	if(top=="Round") {
		$("#header_"+eid).corner("Round top "+topRadian); 
	}

	if(bottom=="Round") {
		$("#content_"+eid).corner("Round bottom "+bottomRadian); 
	}	
	var $this = $("#content_view_id_"+eid);
	var url=$.trim($this.attr("url")).replace(/&amp;/g,"&");
	//All elements use jquery loading
	if(ebaseid=='picture'||ebaseid=='1'||ebaseid=='menu'||ebaseid=='weather'||ebaseid=='login'||true){
		$this.html("<img class='imgWait' src=/images/loading2_wev8.gif> "+wmsg.hp.excuting+"...")
		$this.load(url,function(){
			if(ebaseid=='login'){
				$("#messageSpan_"+eid).html(message);
			}
		});
		return;
	}
	
	
}


function log(s){		 
	if(mode=="debug") {
		$('#txtDebug').val($('#txtDebug').val()+s+"\n");
		var oTxtDebug=$('#txtDebug').get(0);
		oTxtDebug.scrollTop+=oTxtDebug.offsetHeight;
	}
	
}

function  GetContent(divObj,url,isAddElement,code){
	
	divObj.innerHTML="<img src=/images/loading2_wev8.gif> "+wmsg.hp.excuting+"...";
	//return;
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("GET",url, true);
	xmlHttp.onreadystatechange = function () {
		switch (xmlHttp.readyState) {
           case 3 :
			    divObj.innerHTML="<img src=/images/loading2_wev8.gif> "+wmsg.hp.transporting+"...";
		        break;
		   case 4 :
		       if(isAddElement){
			       	$(".group[areaflag='A']").prepend(xmlHttp.responseText);
			       	try{
			       		$(".group[areaflag='A']").children("div:first").bind("reload",function(){
			       			elementReload(this.ebaseid,this.eid,this.cornerTop,this.cornerBottom)
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
	
	function onChanageAllStatus(obj,stropen,strclose){			
		var showSpan;
		var objChilds = obj.childNodes;
		for(var cx=0; cx<objChilds.length; cx++){
			if(objChilds[cx].tagName == "SPAN"){
				showSpan = objChilds[cx];
			}
		}
		var status=showSpan.status;		
		if(status=="show")	{
			$(".content").hide() ;
			showSpan.status="hidden";
			try{showSpan.innerHTML=wmsg.wf.outspread;}catch(e){}			
		} else {
			$(".content").show() ;
			showSpan.status="show";
			try{showSpan.innerHTML=wmsg.wf.shrink;}catch(e){}
		}	
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
		
		document.getElementById("_whereKey_"+eid).value=obj.selecttype+"|"+obj.value+"|"+isHaveReply;		
		
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

		var tables=document.getElementsByTagName("div");		
		for(var i=0;i<tables.length;i++){
			var tbl=tables[i];
			if(tbl.ebaseid==ebaseid) {
				var tblEid=tbl.eid;
				try{
					eval("objE"+tblEid).contentLoad();
				} catch(e){}
			}
		}
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
		objParent.firstChild.value=value;			
	}

function loadContent(eid,url,queryString,e){
	var event = $.event.fix(e);
	var tabId = jQuery(event.target).attr("tabId");
	if(tabId==undefined) tabId = jQuery(event.target).parents("td:first").attr("tabId");
	var ebaseid = $("#item_"+eid).attr("ebaseid");
	url = url + "?tabId="+tabId+"&"+queryString;
	
	var objTd=$("#tabContainer_"+eid).find("td[tabId='"+tabId+"']");
	
	$(objTd).siblings().removeClass("tab2selected").removeClass("tab2unselected").addClass("tab2unselected");
	$(objTd).removeClass("tab2unselected").addClass("tab2selected");
	
	$("#tabContant_"+eid).html("<img src=/images/loading2_wev8.gif>"+wmsg.hp.excuting+"...")
	try{
			if(ebaseid==1||ebaseid==29){
				$.get(url, { name: "John", time: "2pm" },function(data){
				
				$("#tabContant_"+eid).html($.trim(data));
					fixedPosition(eid);
				//	$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
					$('#item_'+eid+' .img_more').parent().attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
			  } ); 
			}else{
				$("#tabContant_"+eid).load(url,{},function(){
					fixedPosition(eid);
			//		$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
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
	
	$("#tabContant_"+eid).html("<img src=/images/loading2_wev8.gif><%=SystemEnv.getHtmlLabelName(19611,7)%>...")
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
	  var redirectUrl = url ;
	  var width = screen.width ;
	  var height = screen.height ;
	  var szFeatures = "top=100," ; 
	  szFeatures +="left=400," ;
	  szFeatures +="width="+width/2+"," ;
	  szFeatures +="height="+height/2+"," ; 
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
			//alert(rssRequest.readyState)
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
						//alert(items_count)

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
								dates[i]=d.getFullYear()+"-"+(d.getMonth() + 1) + "-"+d.getDate() ;

								if(d.getHours()<=9)	times[i]+="0"+d.getHours() + ":";
								else times[i]+= d.getHours() + ":";

								if(d.getMinutes()<=9)	times[i]+="0"+d.getMinutes() + ":";
								else times[i]+= d.getMinutes() + ":";

								if(d.getSeconds()<=9)	times[i]+="0"+d.getSeconds();
								else times[i]+= d.getSeconds() ;
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
								returnStr+="<TR class=\"sparator\"><TD  colspan="+(size+1)+"></TD></TR>";	
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
             objDiv.innerHTML="<%=SystemEnv.getHtmlLabelName(127877,7)%>&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(<%=SystemEnv.getHtmlLabelName(127878,7)%>?)</a>";
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
	}catch(e){}
}
</script>


<script language=vbs>

	sub onSelectBgImg(input,span,eid)	
		imgfileid=document.getElementById("_eBackground_"+eid).value
		
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/element/setting/img.jsp?para="+eid+"_"+imgfileid)
		if (Not IsEmpty(id)) then
			'msgbox(id(0))
			'msgbox(id(1))
			if id(0)<> "" then			
				input.value=id(0)	
				span.innerHtml = id(1)			
			else 
				span.innerHtml = ""
				input.value=""
			end if			
		end if
	end sub		

	sub onShowNew(input,span,eid)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/docs/news/NewsDsp.jsp?id=/docs/news/NewsDsp.jsp?id="&id(0)&"'>" & id(1) &"</a>"
				input.value=id(0)
				
			else 
				span.innerHtml = ""
				input.value="0"
			end if
			call onNewContentCheck(input,eid,"news")
		end if
	end sub





	sub onShowMutiDummy(input,span,eid)	
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value)
		if NOT isempty(id) then
			if id(0)<> "" then	
				dummyidArray=Split(id(0),",")
				dummynames=Split(id(1),",")
				dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 

				For k = 0 To dummyLen
					sHtml = sHtml&"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="&dummyidArray(k)&"'>"&dummynames(k)&"</a>&nbsp"
				Next
				input.value=id(0)
				span.innerHTML=sHtml
				
				
			else			
				input.value="0"
				span.innerHTML=""
			end if
			call onNewContentCheck(input,eid,"dummy")
		end if
	end sub

	sub onShowMultiCatalog(input,span,eid)	
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategoryMBrowser.jsp?selectids="+input.value)
		if NOT isempty(id) then
			if id(0)<> "" then	
				dummyidArray=Split(id(0),",")
				dummynames=Split(id(1),",")
				dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 

				For k = 0 To dummyLen
					sHtml = sHtml&"<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="&dummyidArray(k)&"'>"&dummynames(k)&"</a>&nbsp"
				Next
				input.value=id(0)
				span.innerHTML=sHtml
				
				
			else			
				input.value="0"
				span.innerHTML=""
			end if
		end if 
		call onNewContentCheck(input,eid,"cate")
	end sub

	sub onShowMDocs(input,span,eid)
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&input.value)
			if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					docids = id1(0)
					DocName = id1(1)
					sHtml = ""
					docids = Mid(docids,2,len(docids))
					input.value= docids
					DocName = Mid(DocName,2,len(DocName))
					while InStr(docids,",") <> 0
						curid = Mid(docids,1,InStr(docids,",")-1)
						curname = Mid(DocName,1,InStr(DocName,",")-1)
						docids = Mid(docids,InStr(docids,",")+1,Len(docids))
						DocName = Mid(DocName,InStr(DocName,",")+1,Len(DocName))
						sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&docids&">"&DocName&"</a>&nbsp"
					span.innerHtml = sHtml					
				else
					span.innerHtml =""
					input.value="0"
				end if
				call onNewContentCheck(input,eid,"")
		end if
	end sub


	sub onShowSearchTemplet(input,span,eid)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/DocSearchTempletBrowser.jsp")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = id(1)
				input.value=id(0)
				call onNewContentCheck(input,eid,"")
			else 
				span.innerHtml = ""
				input.value=""
			end if
		end if
	end sub

	sub onShowDoc(input,span,eid)
		id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
		if Not isempty(id) then
			if id(1)<> "" then
				input.value=id(0)
				span.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
			else
				input.value=""
				span.innerHtml = ""
			end if
		end if
	end sub
	sub onShowMenus(input,span,eid)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenusBrowser.jsp")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				if id(0) = "hp" Then
					span.innerHtml = "<a href='/homepage/maint/HomepageLocation.jsp' target='_blank'>" & id(1) &"</a>"
 				ElseIf id(0) = "sys" Then
					span.innerHtml = "<a href='/systeminfo/menuconfig/MenuMaintFrame.jsp?type="&id(0)&"' target='_blank'>" & id(1) &"</a>"
				else
					span.innerHtml = "<a href='/page/maint/menu/MenuEdit.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
			    end if 
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub

	sub onShowMenuTypes(input,span,eid,menutype)
		menutype = menutype.value
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type="&menutype)
		menulink = ""
		if menutype = "element" then
			menulink = "ElementStyleEdit.jsp"
		ElseIf menutype = "menuh" Then
			menulink = "MenuStyleEditH.jsp"
		else
			menulink = "MenuStyleEditV.jsp"
		end if
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/page/maint/style/"&menulink&"?styleid="&id(0)&"&type="&menutype&"&from=list' target='_blank'>"&id(1)&"</a>"
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub
	sub onShowNewNews(input,span,eid,publishtype)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp?publishtype="&publishtype)
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/docs/news/NewsDsp.jsp?id=/docs/news/NewsDsp.jsp?id="&id(0)&"'>" & id(1) &"</a>"
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub

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
 function doPictureInit(){
	hs.graphicsDir = '/page/element/share/highslide/graphics/';
	hs.align = 'center';
	hs.transitions = ['expand', 'crossfade'];
	hs.outlineType = 'rounded-white';
	hs.fadeInOut = true;
	if (hs.addSlideshow) hs.addSlideshow({
		interval: 5000,
		repeat: false,
		useControls: true,
		fixedControls: 'fit',
		overlayOptions: 
		{
			opacity: .75,
			position: 'bottom center',
			hideOnMouseOut: true
		}
	});
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
			//alert(e)
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
			//alert(e)
		}
	}
	
	function doScrollAuto(eid,needButton,speed){

		var myMar;
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
		}
		try{
		picture.onmouseover = function(){clearInterval(myMar);};
		picture.onmouseout = function(){myMar = setInterval(function(){autoMarquee(eid)},speed);};
		if("1"==needButton){ 
			picturenext.onmouseover = function(){clearInterval(myMar);};
			picturenext.onmouseout = function(){myMar = setInterval(function(){autoMarquee(eid)},speed);};
			pictureback.onmouseover = function(){clearInterval(myMar);};
			pictureback.onmouseout = function(){myMar = setInterval(function(){autoMarquee(eid)},speed);};
		}
		
		}catch(e){}
	}
	
	function nextMarquee(eid)
	{
		document.getElementById("picture_"+eid).scrollLeft+=75;
		
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
var isClear = false;
var frmLogin;
function checkall(eid,passwordname,passworduser,needvalidate,needusb)
{
	var errMessage="";
	frmLogin = document.getElementById("frmLogin_"+eid);	
	var loginid = frmLogin.loginid;
	var userpassword = frmLogin.userpassword;
	
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
	if(needusb==1){
		checkusb();
	}
	
	frmLogin.submit(); 	
  	$("#message_"+eid).html("");
  	isClear = true;
}

function fromClear(){
	try{
		if(isClear&&frmLogin!=null){
			frmLogin.loginid.value="";
	   		frmLogin.userpassword.value="";
	   		isClear = false;
		}
		setTimeout(fromClear,1000);
	}catch(e){}
}

setTimeout(fromClear,1000);

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
</script>

<script language=VBScript>
			function getUserPIN(obj)
				Dim vbsserial
				dim hCard
				hCard = 0
				on   error   resume   next
				hCard = obj.OpenDevice(1)'打开设备
				If Err.number<>0 or hCard = 0 then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
					Exit function
				End if
				dim UserName
				on   error   resume   next
				UserName = obj.GetUserName(hCard)'获取用户名
				If Err.number<>0 Then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌2")
					obj.CloseDevice hCard
					Exit function
				End if

				vbsserial = UserName
				obj.CloseDevice hCard
				getUserPIN = vbsserial
				
			End function

			function getRandomKey(randnum,form1,obj)
				dim hCard
				hCard = 0	
				hCard = obj.OpenDevice(1)'打开设备
				If Err.number<>0 or hCard = 0 then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4")
					Exit function
				End if
				dim Digest
				Digest = 0
				on error resume next
					Digest = obj.HTSHA1(randnum, len(randnum))
				if err.number<>0 then
						obj.CloseDevice hCard
						Exit function
				end if

				on error resume next
					Digest = Digest&"04040404"'对SHA1数据进行补码
				if err.number<>0 then
						obj.CloseDevice hCard
						Exit function
				end if

				obj.VerifyUserPin hCard, CStr(form1.userpassword.value) '校验口令
				'alert HRESULT
				If Err.number<>0 Then
					'alert("HashToken compute")
					obj.CloseDevice hCard
					Exit function
				End if
				dim EnData
				EnData = 0
				EnData = obj.HTCrypt(hCard, 0, 0, Digest, len(Digest))'DES3加密SHA1后的数据
				If Err.number<>0 Then 
					'alert("HashToken compute")
					obj.CloseDevice hCard
					Exit function
				End if
				obj.CloseDevice hCard
				getRandomKey = EnData
				'alert "EnData = "&EnData
			End function

		</script>