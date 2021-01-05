/*---------------------------------------*/
/**/ 
/*---------------------------------------*/
function weaverTable(xmlFile,refreshTime,tableInstanceId,tableString,mode,selectedstrs,tableInfo,showExpExcel,isShowTopInfo,isShowBottomInfo,isShowThumbnail,imageNumberPerRow,TopLeftText,BottomLeftText, isCellThumbnailDis){   
	isCellThumbnailDis=true;
	//初始化值	
	this.languageid=readCookie("languageidweaver");
	this.id = XTableHandler.getId();
	XTableHandler.all[this.id] = this;
	this.xmlFile = xmlFile;
	this.refreshTime=refreshTime;
	/*this.loadText = "正在加载，请稍候......";
	if(this.languageid==8) this.loadText = "Loading......";
	if(this.languageid==9) this.loadText = "正在加載，請稍候......";*/
	this.loadText = SystemEnv.getHtmlNoteName(3402,this.languageid);
	this.tableInfo = tableInfo=='null'?'':tableInfo;
	this.TopLeftText=TopLeftText=='null'?'':TopLeftText;
	this.BottomLeftText=BottomLeftText=='null'?'':BottomLeftText;
	this.showExpExcel = showExpExcel=='true'?true:false;
	this.isShowTopInfo = isShowTopInfo=='false'?false:true;
	this.isShowBottomInfo = isShowBottomInfo=='false'?false:true;
	
	/* edited by wdl 2006-05-24 left menu new requirement 显示缩略图 */
	this.isShowThumbnail = isShowThumbnail;
	this.imageNumberPerRow = imageNumberPerRow;
	/* edited by wdl end */
	
	this.div = this.createByName("div");
	
	//tableInfoDiv
	this.tableInfoDiv = this.createByName("div");	
	if((tableInfo!="null"&&tableInfo!="")||showExpExcel){
		jQuery(this.div).append(this.tableInfoDiv);
	}
	
	//info
	this.infoDivTop = this.createByName("div");
	jQuery(this.infoDivTop).attr("class", "xTable_info xTable_infoTop");
	jQuery(this.div).append(this.infoDivTop);


	//table
	this.tableDiv = this.createByName("div");
	jQuery(this.tableDiv).attr("class", "table");
	
	//info
	this.infoDiv = this.createByName("div");
	jQuery(this.infoDiv).attr("class", "xTable_info");

	//this.initDiv = this.createByName("div");
	//this.initDiv.innerHTML="<center><font color=\"AAAAAA\">"+this.loadText+"</font></center>";
	//this.tableDiv.appendChild(this.initDiv);
	//this.div.appendChild(this.tableDiv);
	jQuery(this.div).append(this.tableDiv);
	
	//messagge
	//this.messageDiv = this.createByName("div");
	//this.messageDiv.className="xTable_message";	
	//this.div.appendChild(this.messageDiv);
	
	this.tableInstanceId=tableInstanceId;
	this.tableString=tableString;
	this.mode=mode;
	this.selectedstrs = selectedstrs;
	this.customParams = null;	

	this.orderValue=null;						//排序列
	this.orderType = null;
	this.loading = false;						//是否正在加载
	
	this.page=true;							//是否分页？
	this.needPage = true;
	this.pageId = "";
	this.pageNum=0;
	this.nowPage=0;
	this.recordCount=0;
	this.pagesize=0;
	this.tabletype="";
	this.havaOperates="false";
	this.operatesWidth="";
	this.optUrls = null;
	this.optTexts = null;	
	this.optLinkkeys=null;	
	this.optTargets=null;
	this.isPageAutoWrap=0;
	
	var xttable = this;
	jQuery(function(){
		xttable.load();
	});
	
	//动态刷新
	if(this.refreshTime>0){
		var xt = this;
		window.clearInterval();
		window.setInterval(function(){xt.load();},xt.refreshTime);				
	}
	
	this.isCellThumbnailDis = (isCellThumbnailDis == null || undefined ) ? false : isCellThumbnailDis == true ? true : false;
	
	this.primarykeylist = new Array();
}


weaverTable.prototype.create = function(){
	return this.div;
}
weaverTable.prototype.toString = function(){
	return this.div.outerHTML;	
}

weaverTable.prototype.load = function(){
	//如果正在加载，则不重复加载
	if(this.loading){
		return;	
	}		
	this.loading = true;
	var xmlHttp = XmlHttp.create();	
	/*var postdata = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
		postdata += "<postdata>";
		postdata += "<tableInstanceId>"+this.tableInstanceId+"</tableInstanceId>";
		postdata += "	<tableString>"+this.tableString+"</tableString>";
		postdata += "	<pageIndex>"+this.nowPage+"</pageIndex>";
		postdata += "	<orderBy>"+this.orderValue+"</orderBy>";
		postdata += "	<otype>"+this.orderType+"</otype>";
		postdata += "	<mode>"+this.mode+"</mode>";
		postdata += "	<selectedstrs>"+this.selectedstrs+"</selectedstrs>";
		postdata += "</postdata>";*/
		
		var postdata = "";
		postdata += "tableInstanceId="+this.tableInstanceId+"&";
		postdata += "tableString="+this.tableString+"&";
		postdata += "pageIndex="+this.nowPage+"&";
		postdata += "orderBy="+this.orderValue+"&";
		postdata += "otype="+this.orderType+"&";
		postdata += "mode="+this.mode+"&";
		postdata += "customParams="+this.customParams+"&";
		postdata += "selectedstrs="+this.selectedstrs;
		var pageId = jQuery("#pageId").val();
		if(!!pageId){
			postdata += "&pageId="+pageId;
		}
		var formmodeFlag = jQuery("#formmodeFlag").val();
		if(!!formmodeFlag){
			postdata += "&formmodeFlag="+formmodeFlag;
		}
		postdata = postdata.replace(new RegExp('&nbsp;', 'g'),' ');
		//异步加载数据
		try{
			if(this.xmlFile.indexOf("?")!=-1 && this.xmlFile.indexOf("__mould")!=-1){
				xmlHttp.open("POST", this.xmlFile+"&"+postdata, true);
			}else{
				xmlHttp.open("POST", this.xmlFile+"?"+postdata, true);
			}
		}catch(e){
			xmlHttp.open("POST", this.xmlFile+"?"+postdata, true);
		}
		var weaverTable = this;		
		xmlHttp.onreadystatechange = function () {	
			switch (xmlHttp.readyState) {
			   case 0 :  //uninitialized
					break ;
			   case 1 :   //loading							
					break ;
			   case 2 :   //loaded
				   /*if(readCookie("languageidweaver")==8) 
					   weaverTable.showMessage("Executing....");
				   else if(readCookie("languageidweaver")==9) 
					   weaverTable.showMessage("服務器正在處理,請稍候....");
				   else 
					  weaverTable.showMessage("服务器正在处理,请稍候....");
					  */
					weaverTable.showMessage(SystemEnv.getHtmlNoteName(3403,readCookie("languageidweaver")));
				   break ;
			   case 3 :   //interactive
				   var message=SystemEnv.getHtmlNoteName(3404,readCookie("languageidweaver"));				   

                    weaverTable.showMessage(message);

				   break ;
			   case 4 :  //complete
					if (xmlHttp.status==200)  {
						weaverTable.showMessage(SystemEnv.getHtmlNoteName(3405,readCookie("languageidweaver")));
						var xmlDoc = XmlDocument.create();
						if(xmlHttp.responseXML!=null){
							xmlDoc = jQuery(xmlHttp.responseXML)[0];
						}
						if(xmlHttp.responseXML==null&&xmlHttp.responseText!=null){
							xmlDoc.async = false; 						
							xmlDoc = jQuery(xmlHttp.responseText)[0];
						}
						var responseText_temp = xmlHttp.responseText;
						responseText_temp=responseText_temp.replace(/(^\s*)|(\s*$)/g, "");	
						if(weaverTable.nowPage > 1 && responseText_temp=="NoData") {
							weaverTable.nowPage = 0;
							weaverTable.loading = false;
							weaverTable.reLoad();
							break;
						} else {
							weaverTable.parse(xmlDoc,xmlHttp.responseText);	
							break ;	
						}	
				   } else {	
					   if(xmlHttp.status!=0){
							var showTableDiv  = document.getElementById('_xTable');						
							showTableDiv.innerHTML=creatErrorStr(xmlHttp.status,xmlHttp.statusText,xmlHttp.responseText);
					   }
				   }			  		
			} 
		}
				
		xmlHttp.setRequestHeader("Content-Type","text/xml");	
		xmlHttp.send();		
}

weaverTable.prototype.showMessage= function(info){	
	var message_table_Div  = jQuery(document.getElementById("message_table_Div"));
	message_table_Div.css("display", "inline").html(info);
	
	var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
	var pLeft= document.body.offsetWidth/2-50;
	if(jQuery("div#_xTable").length>0){
		pLeft = pLeft-10;
	}
	message_table_Div.css("position", "absolute").css("top", pTop).css("left", pLeft);
}


weaverTable.prototype.parse = function(oXmlDoc,docStr){
	if (this.mode=="debug"){
		alert(docStr);			
	}		
	//如果用xmlhttp加载失败 显示出错信息
	if(oXmlDoc == null||oXmlDoc.documentElement == null){
	   var showTableDiv  = document.getElementById('_xTable');	
	   if(readCookie("languageidweaver")==8) 
		   showTableDiv.innerHTML=creatErrorStr(0,SystemEnv.getHtmlNoteName(3440,readCookie("languageidweaver")),docStr);
	   else if(readCookie("languageidweaver")==9) 
		   showTableDiv.innerHTML=creatErrorStr(0,SystemEnv.getHtmlNoteName(3440,readCookie("languageidweaver")),docStr);
	   else 
		   showTableDiv.innerHTML=creatErrorStr(0,SystemEnv.getHtmlNoteName(3440,readCookie("languageidweaver")),docStr);
	}
	if( oXmlDoc == null || oXmlDoc.documentElement == null) {
		var showTableDiv  = document.getElementById('_xTable');						
		showTableDiv.innerHTML=creatErrorStr('','',docStr);		
	}else {
		var root = oXmlDoc.documentElement;
	    /* edited by wdl 2006-05-24 left menu new requirement 显示缩略图 */
		if(this.isShowThumbnail==""){
			this.showData(root);
			//add by lsj 2014/1/17处理表格数据隐藏
			if(typeof agentrowspan==='function')
			{
				agentrowspan();
			}
		}else if(this.isShowThumbnail=="2"){//公文显示
			this.showOfficalDoc(root);
			jQuery("#_xTable").css("padding-top","10px")
		}
		else{
			this.showThumbnail(root);
			jQuery("#_xTable").css("padding-top","10px")
		}
			
		/* edited by wdl end */
		
		
		/*add by bpf on 2013-12-18 表格中的checkbox和表格全选的checkbox对齐*/
		var xTable_info = jQuery(".xTable_info");
		xTable_info.each(function(){
			jNiceWrapperLast = jQuery(this).find(".jNiceWrapper");
			jNiceWrapperLast.parent().css("text-align","left");
			if(!!jNiceWrapperLast && jNiceWrapperLast.size()!=0){
			    jQuery(".jNiceWrapper").parent().css("padding-left","10px");
						//jQuery(".ListStyle .jNiceWrapper:first").offset().left-1);
			}
		});
	}
	try{
		if(typeof(lazyLoadBrowser)=="function"){
			setTimeout(lazyLoadBrowser,100);
		}
	} catch(e) {
	}
}

/* edited by wdl 2006-05-24 left menu new requirement 显示缩略图 */
weaverTable.prototype.showThumbnail = function(re){
	try{
		var showColMenu = jQuery("button[onclick*='showColDialog']",document.getElementById("rightMenuIframe").contentWindow.document);
	    if(showColMenu.length>0){
	    	var menuIndex = showColMenu.closest("div[id^=menuItemDivId]").attr("id").replace(/\D/g,"");
	    	hiddenRCMenuItem(menuIndex);
	    }
	}catch(e){
		if(window.console)console.log(e);
	}
	var $re = jQuery(re);
	this.page = $re.attr("page");
	this.pageNum = $re.attr("pagenum");
	this.nowPage = $re.attr("nowpage");
	this.recordCount = $re.attr("recordCount");
	this.tabletype = $re.attr("tabletype");
	this.orderValue = $re.attr("orderValue");
	this.orderType = $re.attr("orderType");
	this.pagesize=$re.attr("pagesize");
	//added by wcd 2015-10-19
	this.rowClick = $re.attr("rowClick");
	
	this.havaOperates = $re.attr("havaOprates");
	this.operatesWidth = $re.attr("operatesWidth");
	
	if(this.imageNumberPerRow==""||this.imageNumberPerRow=="0") this.imageNumberPerRow = 5;

	// checkbox ids arrays
	var checkboxArrays = new Array(this.pagesize);

	var tab = this.createByName("table");
	var $tab = jQuery(tab);
	if (this.isCellThumbnailDis) {
		$tab.css("table-layout","fixed");
	} 
	
	$tab.css("width", jQuery(re).attr("width"));
	
	//by bpf 2013-10-16 start(去掉单元格空隙)
	//tab.cellSpacing="1pt";
	tab.cellSpacing="0";
	//by bpf 2013-10-16	end

	jQuery(this.div).css("width", jQuery(re).attr("width"));
	//tab.className="ListStyle";
	$tab.attr("class", "ListStyle");
	
	var tbody = this.createByName("tbody");	
	//tab.appendChild(tbody);	
	$tab.append(tbody);

	var rows = $re.children();
	var size = rows.length;
	var tempi = 0;				//记录奇偶行
	var _aligns;				//每列对齐样式
	var _hrefs;				//每列的链接
	var _colids;				//链接列的参数
	var _targets;				//每列链接的目标框架
	var _keys;				//主键列
	var row;
	var celstr;
	var titlestrs;
	var currentDocId = 0;
	var _widths;
	var _heights;
	
	if(this.recordCount==0){
		var tr =jQuery(this.createByName("tr"));
		tr.addClass("e8EmptyTR");
		var td = jQuery(this.createByName("td"));
		td.css("text-align","center").css("height","30px").css("color","#000").attr("colspan",hSize);
		var infoMsg=SystemEnv.getHtmlNoteName(3558,readCookie("languageidweaver"));
		td.html(infoMsg);
		tr.append(td);
		jQuery(tbody).append(tr);
		jQuery(".xTable_info").remove();
		jQuery("#msgBox").hide();
	}
	
	for(var i = 0;i<size;i++){		
		//表头
		if(rows[i].tagName=="head"){
			var heads = jQuery(rows[i]).children();
			
			var hSize = heads.length;			
		
			_aligns = new Array(hSize);
			_hrefs = new Array(hSize);
			_targets = new Array(hSize);
			_colids = new Array(hSize);
			_keys = new Array(hSize);
			_widths = new Array(hSize);
			_heights = new Array(hSize);
			var __coli = 0;
			
			titlestrs = new Array(hSize);
			
			for(var hi=0;hi<hSize;hi++){
				if(heads[hi].tagName!="col"){
					continue;
				}
				
				_hrefs[__coli] = jQuery(heads[hi]).attr("href");
				_targets[__coli] = jQuery(heads[hi]).attr("target");
				_keys[__coli] = jQuery(heads[hi]).attr("key");

				titlestrs[__coli] = jQuery(heads[hi]).attr("text");
				_widths[__coli] = jQuery(heads[hi]).attr("cusWidth");
				_heights[__coli] = jQuery(heads[hi]).attr("cusHeight");
				__coli++;
			}
		
			if(this.havaOperates=="true"){
			}

			continue;
		}
		
		if(rows[i].tagName!="row"){	
			continue;	
		}

		tempi ++;
		if(tempi == 1){
		    row = this.createByName("tr");
		}

		var cels = jQuery(rows[i]).children();
		var cSize = cels.length;

		var __coli = 0;
		var __optIds = new Array(cSize);
		
 		var cel = this.createByName("td");
		var $cel = jQuery(cel);
		//TD29472 注销此行 相册中显示的高度被固定，无法显示出全部的缩略图
 		if (this.isCellThumbnailDis) {
 			cel.style.height = "30px";
 			if(jQuery.browser.msie){
 				cel.style.height = "150px";
 			}
 		}
		//End TD29472 
 		if (this.isCellThumbnailDis && !(this.isPageAutoWrap==1||this.isPageAutoWrap=="1")) {
			jQuery(cel).css("text-Overflow", "ellipsis").css("white-Space", "nowrap").css("word-Break", "keep-all").css("overflow", "hidden");
 		}else{
 			jQuery(cel).css("word-break", "break-all").css("word-wrap", "break-word");
 		}
   		celstr = "";
   		var _tdstyle= this.isCellThumbnailDis && !(this.isPageAutoWrap==1||this.isPageAutoWrap=="1") ? " style=\"display:inline-block;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:100%;\" " : " style=\"word-wrap:break-word;word-break:break-all;\"";
		//行
		for(var j = 0;j<cSize;j++){
			var $celj = jQuery(cels[j]);
			if(cels[j].tagName=="col"){
			
				var __nowId = ($celj.attr("linkvalue")==null)?$celj.attr("text"):$celj.attr("linkvalue");
				
				var showvalue=$celj.attr("showvalue");
				var isChecked = ($celj.attr("checked")=="true"?true:false);
				
				//checkbox
				if ($celj.attr("type")=="checkbox") {//checkbox
					celstr+="<div style='margin-bottom:10px;'>"
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;
					}
					 
					celstr = celstr + "<input type=checkbox name=chkInTableTag id=_xTable_"+__nowId+" checkboxId="+__nowId+"  value=\""+showvalue+"\"  onClick=_xtalbe_chkCheck(this)>";					
					
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;
					}

					//check
					if (isChecked){

					}
					__coli++;				
					continue ;				
				
				} else if ($celj.attr("type")=="radio") {//radio
					celstr+="<div style='margin-bottom:10px;'>"
					if (_xtalbe_radiocheckId == __nowId||isChecked)	{
						
						celstr = celstr + "<input type=radio name=rdoInTableTag  radioId="+__nowId+" checked id=_xTable_"+__nowId+" value=\""+showvalue+"\" onClick=rdoCheck(this)>";
					    
					} else {
						
						celstr = celstr + "<input type=radio name=rdoInTableTag radioId="+__nowId+" id=_xTable_"+__nowId+" value=\""+showvalue+"\" onClick=rdoCheck(this)>";
					    
					}
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;
					}
					__coli++;
					continue ;
				
				} else if ($celj.attr("type")=="none") {
					
					celstr = celstr + "&nbsp;<input type=checkbox  style='display:none' id="+__nowId+" value=\""+showvalue+"\">";// xwj for td2180 20050818
					
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}
					
					__coli++;
					continue ;
				} else if ($celj.attr("type")=="thumbnail") {
					celstr+="<div style='margin-bottom:10px;'>"
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;
					}
					if($celj.attr("type2")=="none"){
						celstr = celstr + "&nbsp;<input type=checkbox  style='display:none' id="+__nowId+" value="+showvalue+">";// xwj for td2180 20050818
					}else{
						celstr = celstr + "<input type=checkbox name=chkInTableTag id=_xTable_"+__nowId+" checkboxId="+__nowId+"  value=\""+showvalue+"\"  onClick=_xtalbe_chkCheckThumbnail(this)>";
					}

					var imgsrc = $celj.attr("imgsrc");
			        //显示图片
			        celstr = "<div class='e8ThumbnailImg' style='line-height:152px;'>" +
			        		 "<img src='"+imgsrc+"' style='max-width:140px;max-height:145px;vertical-align:middle;'>" +
			        		 "</div>"+
			        		 celstr;
			        		 
				
					__coli++;
					continue ;
				} else if ($celj.attr("type")=="thumbnailNoCheck") {
					celstr+="<div style='margin-bottom:10px;'>"
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;
					}

					var imgsrc = $celj.attr("imgsrc");
					//alert(imgsrc)
			        //显示图片
					if(imgsrc.indexOf("?div=")>-1){
						imgsrc = imgsrc.replace("?div=","");
						  celstr = "<div class='e8ThumbnailImg' style='line-height:152px;'>" +
						  	"<div style='max-width:140px;max-height:145px;vertical-align:middle;text-align:center;height:142px;position:relative'>"
			        		  +imgsrc+
			        		   "</div>"+
			        		 "</div>"+
			        		 celstr;
					__coli++;
					}else{
						 celstr = "<div class='e8ThumbnailImg' style='line-height:152px;'>" +
			        		 "<img src='"+imgsrc+"' style='max-width:140px;max-height:145px;vertical-align:middle;'>" +
			        		 "</div>"+
			        		 celstr;
					}
			        
			       
				

					continue ;
				}
				
				//是否为主键
				if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
					__optIds[__coli] = __nowId;	
				}
				if(_hrefs[__coli]!=null){
				
					var str = $celj.text();
					if (_targets[__coli]=="_fullwindow"){
						if(str.indexOf("</a>")!=-1){
							
						}else{
							if(__nowId!=""){
								var tempUrl = _hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+jQuery(cels[j]).attr("linkkey")+"="+__nowId;
								var options = {cusWidth:_widths[__coli],cusHeight:_heights[__coli]};
								str = "<a href=\"javascript:this.openFullWindowForXtable('"+tempUrl+"',this,{cusWidth:"+_widths[__coli]+",cusHeight:"+_heights[__coli]+"})\""  + _tdstyle + ">"+ jQuery(cels[j]).text()+"</a>";
							}
						}
					} else {
					     if(__nowId!=""){
							 str = "<a href=\""+_hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+jQuery(cels[j]).attr("linkkey")+"="+__nowId+
							       "\" target=\""+_targets[__coli]+"\" " + _tdstyle + ">"+jQuery(cels[j]).text()+"</a>";
					     }
					}
					
					celstr = celstr + "<span>"+str+"<span>";
					
				} else {
				    var str = $celj.text();
				    
				    //if(celstr.substr(celstr.length-4)!="<br>") celstr = celstr + "<br>";
					celstr = celstr + "<span>"+str+"<span>";
					
				}
				
				__coli++;
				
			} else if (cels[j].tagName=="operates"){
			
				//显示操作栏				
				var optStrAll="";

				//var opas = cels[j].childNodes;
				var opas = $celj.children();
				for(var opti = 0;opti<opas.length;opti++){
					var opa = opas[opti];
					var $opa = jQuery(opa);
					var text = $opa.attr("text");
					var href = $opa.attr("href");
					var target = $opa.attr("target");
					var linkkey = $opa.attr("linkkey");
					var value = $opa.attr("value");
					var otherpara = $opa.attr("otherpara");
					var options = {cusWidth:$opa.attr("width"),cusHeight:$opa.attr("height")};
					if(otherpara==null)otherpara="";
					var operateStr="";
					if (href!=null) {				
						var operateStrLower = href.toLowerCase(); 				
						var pos =operateStrLower.indexOf("javascript:");						
						if (pos != -1)  {
							var strJavaScript="";
							var posBracketStart = href.lastIndexOf("(");
							var posBracketEnd = href.lastIndexOf(")");	
							var strInBracket = href.substring(posBracketStart+1,posBracketEnd);
							
							if (strInBracket.replace(/(^\s*)|(\s*$)/g, "")=="") {  //删除空格
								strJavaScript = href.substring(0,posBracketEnd)+"\""+value+"\",\""+otherpara+"\",this"+href.substring(posBracketEnd);		
							} else {
								strJavaScript = href.substring(0,posBracketEnd)+",\""+value+"\",\""+otherpara+"\",this"+href.substring(posBracketEnd);		
							}
							//operateStr = "<a href='"+strJavaScript+"'>"+text+"</a>";
							if(jQuery.browser.msie){
								operateStr = "<a href='#' onclick='"+strJavaScript+"'>"+text+"</a>";
							}else{
								operateStr = "<a href='#' onclick='"+strJavaScript+";return false;'>"+text+"</a>";
							}
						} else {
							if (target=="_fullwindow") {
								var tempStr = href+"?"+linkkey+"="+value;					
								operateStr = "<a href=javascript:this.openFullWindowForXtable('"+tempStr+"',this,{cusWidth:"+jQuery(opa).attr("width")+",cusHeight:"+jQuery(opa).attr("height")+"})>"+text+"</a>";	
							} else {
								operateStr = "<a href="+href+"?"+linkkey+"="+value+" target="+target+">"+text+"</a>";	
							}
						}									
					} else {
						operateStr=text;
					}
					optStrAll += "<span style='padding-left:5px;padding-right:5px;'>"+operateStr +"</span>";
				}
				celstr = celstr + "<div class='e8thumbnailop' style='top:123px;left:13px;'><div style='padding-left:5px;padding-right:5px;'>" + optStrAll+"</div></div>";
     		}
		}
		
		cel.align = "center";
		
		cel.vAlign = "top";
		celstr += "</div>";
		cel.innerHTML = celstr;
		$cel.css("position","relative");
		var thubnailImg = $cel.find("div.e8ThumbnailImg");
		var e8thumbnailop = $cel.find("div.e8thumbnailop");
		e8thumbnailop.css({
			"display":"none",
			"position":"absolute"
		});
		$cel.hover(function(){
			var $this = jQuery(this);
			var thubnailImg1 = $this.find("div.e8ThumbnailImg");
			thubnailImg1.addClass("e8ThumbnailImgHoverH");
			var e8thumbnailop1 = $this.find("div.e8thumbnailop");
			e8thumbnailop1.css({
				"top":thubnailImg1.position().top+thubnailImg1.height()-29,
				"left":thubnailImg1.position().left+1
			});
			e8thumbnailop1.fadeIn("normal",function(){
				e8thumbnailop1.css({
					"top":thubnailImg1.position().top+thubnailImg1.height()-e8thumbnailop1.height()+1,
					"left":thubnailImg1.position().left+1
				});
			});
			
		},function(){
			var $this = jQuery(this);
			var thubnailImg1 = $this.find("div.e8ThumbnailImg");
			thubnailImg1.removeClass("e8ThumbnailImgHoverH");
			var e8thumbnailop1 = $this.find("div.e8thumbnailop");
			e8thumbnailop1.fadeOut("normal");
		});
		thubnailImg.css("cursor","pointer")
				.bind("click",function(){
					var $this = jQuery(this);
					var checkbox = $this.next("div").children("span.jNiceWrapper").children("input");
					var isRadio = false;
					var _this = this;
					var tables = $cel.find("div.e8ThumbnailImgHover");
						tables.each(function(){
							if(_this===this){
							}else{
								jQuery(this).removeClass("e8ThumbnailImgHover");
							}
						});
					if(checkbox.attr("type")=="radio"){
						isRadio = true;
						var tables = $cel.find("div.e8ThumbnailImgHover");
						tables.each(function(){
							if(_this===this){
							}else{
								$this.removeClass("e8ThumbnailImgHover");
							}
						});
					}
					if($this.hasClass("e8ThumbnailImgHover")){
						if(checkbox.length>0){
							$this.removeClass("e8ThumbnailImgHover");
							if(isRadio && checkbox.length>0){
								changeRadioStatus(checkbox,false);
							}else if(checkbox.length>0){
								changeCheckboxStatus(checkbox,false);
							}
						}
					}else{
						if(checkbox.length>0){
							$this.removeClass("e8ThumbnailImgHoverH").addClass("e8ThumbnailImgHover");
							if(isRadio && checkbox.length>0){
								changeRadioStatus(checkbox,true);
							}else if(checkbox.length>0){
								changeCheckboxStatus(checkbox,true);
							}
						}
					}
				});
		
		cel.width = (100 / this.imageNumberPerRow).toString()+"%";
		celstr = "";
		
		jQuery(row).append(cel);
		if((tempi % this.imageNumberPerRow == 0 && tempi>1)||tempi==size-1){
		    if((tempi==size-1)&&(tempi%this.imageNumberPerRow!=0)){
		        for(var bi=0;bi< this.imageNumberPerRow - (tempi % this.imageNumberPerRow) ; bi++){
		            var nullcel = this.createByName("td");
		            nullcel.innerHTML = "&nbsp;";
		            //row.appendChild(nullcel);
		            jQuery(row).append(nullcel);
		        }
		        jQuery(tbody).append(row);
		    } else {
    		    //tbody.appendChild(row);
		    	jQuery(tbody).append(row);
    		    row = this.createByName("tr");
    		}
		}
	}

	//是否是重新加载
	if(this.tableDiv.firstChild!=null){
//		this.tableDiv.removeChild(this.tableDiv.firstChild);
		jQuery(this.tableDiv).empty();
	}
	//this.tableDiv.appendChild(tab);	
	jQuery(this.tableDiv).append(tab);
	if((this.page=="true"||this.page=="TRUE"||this.page=="Y")&&this.recordCount!=0){
		//this.div.appendChild(this.infoDiv);
		jQuery(this.div).append(this.infoDiv);
		if (this.isShowTopInfo){
			this.infoDivTop.innerHTML =  this.buildInfo("top");  //1:top 2:buttom
		}
		if (this.isShowBottomInfo){
			this.infoDiv.innerHTML =  this.buildInfo("buttom");	
		}
		this.tableInfoDiv.innerHTML =  this.buildInfo("tableInfoDiv");
		try{
			var pageId = this.pageId;
			if(!pageId){
				pageId = jQuery("#pageId").val();
			}
			jQuery("#pageSizeSel0").selectForK13({
				"width":"40px",
				pageSize:this.pagesize,
				pageId:pageId,
				callback:savePageSize,
				isWrap:false
			});
			jQuery("#pageSizeSel1").selectForK13({
				"width":"40px",
				pageSize:this.pagesize,
				pageId:pageId,
				callback:savePageSize,
                isWrap:false
			});
		}catch(e){
		}
	}

	this.loading = false;
	this.loadOver();
	
	//checked checkbox
	for (var i=0;i<checkboxArrays.length ;i++ )	{
		var temp = checkboxArrays[i];
		if (temp!=null&&temp!=this.pagesize)	{	
			var tempobj = document.getElementById(temp);
			if (tempobj.tagName=="INPUT")	{
				tempobj.checked=true;				
				//tempobj.parentElement.parentElement.className = "Selected"
				thumbnailSelected(tempobj);
			}
		}
	}
	try{
		//缩略图
		jQuery("IMG[src^='/weaver/weaver.splitepage.transform.SptmForThumbnail?fileid=']").live({
			  click: function() {
			  		selectImg(this);
			  },
			  mouseover: function() {
			  		showPreview(event);
			  		//showborder(this);
			    	jQuery(this).parents("table:first").css("border","1px solid #558ed5");
			  },
			  mouseout:function(){
			  		hidePreview(event);
			  		//hideborder();
			  		jQuery(this).parents("table:first").css("border","1px solid #ddd");
			  }
		});
	}catch(e){
		//console.log(e);
	}
	var $_xTable = jQuery("div#_xTable");
	try {
		weaverTableCallbackFunction();
	} catch (e) {
		window.setTimeout(function(){
			try {
				weaverTableCallbackFunction();
			} catch (e) {}
		},300);
	}
	try{
		$_xTable.jNice();
	}catch(e){
		window.setTimeout(function(){
			try{
				$_xTable.jNice();
			}catch(e){}
		},300);
	}
	
	try{
		jQuery("input[type=checkbox]").each(function(){
			if(jQuery(this).attr("tzCheckbox")=="true"){
				jQuery(this).tzCheckbox({labels:['','']});
			}
		});
	}
	catch(e){
		window.setTimeout(function(){
			try{
				jQuery("input[type=checkbox]").each(function(){
					if(jQuery(this).attr("tzCheckbox")=="true"){
						jQuery(this).tzCheckbox({labels:['','']});
					}
				});
			}catch(e){}
		},300);
	}
	
	try{
		var callbackpara = {
			pageNum : this.pageNum,
			nowPage : this.nowPage,
			recordCount : this.recordCount
		};
		//当列表加载完成后调用一个处理函数
		afterDoWhenLoaded(callbackpara);
	}catch(e){
		window.setTimeout(function(){
			try{
				var callbackpara = {
					pageNum : this.pageNum,
					nowPage : this.nowPage,
					recordCount : this.recordCount
				};
				//当列表加载完成后调用一个处理函数
				afterDoWhenLoaded(callbackpara);
			}catch(e){
				if(window.console)console.log(e);
			}
		},300);
	}
	

}
/* edited by wdl end */

/* edited by ll 2014-08-20 left menu new requirement 公文显示 */
weaverTable.prototype.showOfficalDoc = function(re){
	try{
		var showColMenu = jQuery("button[onclick*='showColDialog']",document.getElementById("rightMenuIframe").contentWindow.document);
	    if(showColMenu.length>0){
	    	var menuIndex = showColMenu.closest("div[id^=menuItemDivId]").attr("id").replace(/\D/g,"");
	    	hiddenRCMenuItem(menuIndex);
	    }
	}catch(e){
		if(window.console)console.log(e);
	}
	var $re = jQuery(re);
	this.page = $re.attr("page");
	this.pageNum = $re.attr("pagenum");
	this.nowPage = $re.attr("nowpage");
	this.recordCount = $re.attr("recordCount");
	this.tabletype = $re.attr("tabletype");
	this.orderValue = $re.attr("orderValue");
	this.orderType = $re.attr("orderType");
	this.pagesize=$re.attr("pagesize");
	//added by wcd 2015-10-19
	this.rowClick = $re.attr("rowClick");
	
	this.havaOperates = $re.attr("havaOprates");
	this.operatesWidth = $re.attr("operatesWidth");
	
	if(this.imageNumberPerRow==""||this.imageNumberPerRow=="0") this.imageNumberPerRow = 5;

	// checkbox ids arrays
	var checkboxArrays = new Array(this.pagesize);

	var tab = this.createByName("table");
	var $tab = jQuery(tab);
	if (this.isCellThumbnailDis) {
		$tab.css("table-layout","fixed");
	} 
	
	$tab.css("width", $re.attr("width"));
	
	//by bpf 2013-10-16 start(去掉单元格空隙)
	//tab.cellSpacing="1pt";
	tab.cellSpacing="0";
	//by bpf 2013-10-16	end

	jQuery(this.div).css("width", $re.attr("width"));
	//tab.className="ListStyle";
	$tab.attr("class", "ListStyle");
	
	var tbody = this.createByName("tbody");	
	//tab.appendChild(tbody);	
	$tab.append(tbody);

	var rows = $re.children();
	var size = rows.length;
	var tempi = 0;				//记录奇偶行
	var _aligns;				//每列对齐样式
	var _hrefs;				//每列的链接
	var _colids;				//链接列的参数
	var _targets;				//每列链接的目标框架
	var _keys;				//主键列
	var row;
	var celstr;
	var titlestrs;
	var currentDocId = 0;
	var _widths;
	var _heights;
	
	if(this.recordCount==0){
		var tr =jQuery(this.createByName("tr"));
		tr.addClass("e8EmptyTR");
		var td = jQuery(this.createByName("td"));
		td.css("text-align","center").css("height","30px").css("color","#000").attr("colspan",hSize);
		var infoMsg=SystemEnv.getHtmlNoteName(3558,readCookie("languageidweaver"));
		td.html(infoMsg);
		tr.append(td);
		jQuery(tbody).append(tr);
		jQuery(".xTable_info").remove();
	}
	
	for(var i = 0;i<size;i++){		
		//表头
		if(rows[i].tagName=="head"){
			var heads = jQuery(rows[i]).children();
			
			var hSize = heads.length;			
		
			_aligns = new Array(hSize);
			_hrefs = new Array(hSize);
			_targets = new Array(hSize);
			_colids = new Array(hSize);
			_keys = new Array(hSize);
			_widths = new Array(hSize);
			_heights = new Array(hSize);
			var __coli = 0;
			
			titlestrs = new Array(hSize);
			
			for(var hi=0;hi<hSize;hi++){
				if(heads[hi].tagName!="col"){
					continue;
				}
				
				_hrefs[__coli] = jQuery(heads[hi]).attr("href");
				_targets[__coli] = jQuery(heads[hi]).attr("target");
				_keys[__coli] = jQuery(heads[hi]).attr("key");

				titlestrs[__coli] = jQuery(heads[hi]).attr("text");
				_widths[__coli] = jQuery(heads[hi]).attr("cusWidth");
				_heights[__coli] = jQuery(heads[hi]).attr("cusHeight");
				__coli++;
			}
		
			if(this.havaOperates=="true"){
			}

			continue;
		}
		
		if(rows[i].tagName!="row"){	
			continue;	
		}

		tempi ++;
		if(tempi == 1){
		    row = this.createByName("tr");
		}

		var cels = jQuery(rows[i]).children();
		var cSize = cels.length;

		var __coli = 0;
		var __optIds = new Array(cSize);
		
 		var cel = this.createByName("td");
 		var $cel = jQuery(cel);
		
		//TD29472 注销此行 相册中显示的高度被固定，无法显示出全部的缩略图
 		if (this.isCellThumbnailDis) {
 			cel.style.height = "30px";
 			if(jQuery.browser.msie){
 				cel.style.height = "150px";
 			}
 		}
		//End TD29472 
 		if (this.isCellThumbnailDis && !(this.isPageAutoWrap==1||this.isPageAutoWrap=="1")) {
			$cel.css("text-Overflow", "ellipsis");
			$cel.css("white-Space", "nowrap");
			$cel.css("word-Break", "keep-all");
			$cel.css("overflow", "hidden");
 		}else{
 			$cel.css("word-break", "break-all");
 			$cel.css("word-wrap", "break-word");
 		}
   		celstr = "<div class='e8BGImg'></div>";
   		var _tdstyle= this.isCellThumbnailDis && !(this.isPageAutoWrap==1||this.isPageAutoWrap=="1") ? " style=\"display:inline-block;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:100%;\" " : " style=\"word-wrap:break-word;word-break:break-all;\"";
		//行
		for(var j = 0;j<cSize;j++){
			var $celj = jQuery(cels[j]);
			if(cels[j].tagName=="col"){
			
				var __nowId = ($celj.attr("linkvalue")==null)?$celj.attr("text"):$celj.attr("linkvalue");
				
				var showvalue=$celj.attr("showvalue");
				var isChecked = ($celj.attr("checked")=="true"?true:false);
				
				//checkbox
				if ($celj.attr("type")=="checkbox") {//checkbox
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;
					}
					 
					celstr = celstr + "<input type=checkbox name=chkInTableTag id=_xTable_"+__nowId+" checkboxId="+__nowId+"  value=\""+showvalue+"\"  onClick=_xtalbe_chkCheck(this)>";					
					
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;
					}

					//check
					if (isChecked){

					}
					__coli++;				
					continue ;				
				
				} else if ($celj.attr("type")=="radio") {//radio
				
					if (_xtalbe_radiocheckId == __nowId||isChecked)	{
						
						celstr = celstr + "<input type=radio name=rdoInTableTag  radioId="+__nowId+" checked id=_xTable_"+__nowId+" value=\""+showvalue+"\" onClick=rdoCheck(this)>";
					    
					} else {
						
						celstr = celstr + "<input type=radio name=rdoInTableTag radioId="+__nowId+" id=_xTable_"+__nowId+" value=\""+showvalue+"\" onClick=rdoCheck(this)>";
					    
					}
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;
					}
					__coli++;
					continue ;
				
				} else if ($celj.attr("type")=="none") {
					
					celstr = celstr + "&nbsp;<input type=checkbox  style='display:none' id="+__nowId+" value=\""+showvalue+"\">";// xwj for td2180 20050818
					
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}
					
					__coli++;
					continue ;
				} else if ($celj.attr("type")=="officalDoc") {
					
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;
					}
					if(false && jQuery(cels[j]).attr("type2")=="none"){
						celstr = celstr + "&nbsp;<input type=checkbox  style='display:none' id="+__nowId+" value="+showvalue+">";// xwj for td2180 20050818
					}else{
						celstr = celstr + "<div style='text-align:center;display:none;'><input type=checkbox name=chkInTableTag id=_xTable_"+__nowId+" checkboxId="+__nowId+"  value=\""+showvalue+"\"  onClick=_xtalbe_chkCheckThumbnail(this)></div>";
					}

					/*var imgsrc = jQuery(cels[j]).attr("imgsrc");
			        //显示图片
			        celstr = "<table class='e8ThumbnailImg' cellpadding=\"1\" style=\"border:1px solid #DDD;border-collapse:collapse\">" +
			        		 "<tr><td style=\"width:96px;height:96px;text-align:center\">" +
			        		 "<img src='"+imgsrc+"'>" +
			        		 "</td></tr>" +
			        		 "</table>" +
			        		 celstr;*/
			        celstr = "<div class='e8ThumbnailImg e8OfficalDoc'>"+
				        		 "<div class='e8OfficalDocInner'>"+
				        		 	"<div class='e8OfficalDocTitle' title='#_titledocsubject#'>#_docsubject#</div>"+//显示docsubject
				        		 	"<div><div class='e8OfficalDocContent' title='#_docnumber#'><span style='padding-left:15px;'>#_docnumber#</span></div>"+//显示文号
				        		 		"<div class='e8OfficalDocContent' title='#_docisuser#'><span style='padding-left:15px;'>#_docisuser#</span></div>"+//显示签发人
				        		 	"</div>"+
				        		 "</div>"+
				        	 "</div>"
			        		 +celstr
			        		 	
			        		 
				
					__coli++;
					continue ;
				}
				
				//是否为主键
				if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
					__optIds[__coli] = __nowId;	
				}
				if(_hrefs[__coli]!=null){
				
					var str = $celj.text();
					if (_targets[__coli]=="_fullwindow"){
						_tdstyle+="margin-bottom:10px;";
						if(str.indexOf("</a>")!=-1){
							
						}else{
							if(__nowId!=""){
								var tempUrl = _hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+jQuery(cels[j]).attr("linkkey")+"="+__nowId;
								var options = {cusWidth:_widths[__coli],cusHeight:_heights[__coli]};
								str = "<a href=\"javascript:this.openFullWindowForXtable('"+tempUrl+"',this,{cusWidth:"+_widths[__coli]+",cusHeight:"+_heights[__coli]+"})\""  + _tdstyle + ">"+ jQuery(cels[j]).text()+"</a>";
							}
						}
					} else {
					     if(__nowId!=""){
							 str = "<a href=\""+_hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+jQuery(cels[j]).attr("linkkey")+"="+__nowId+
							       "\" target=\""+_targets[__coli]+"\" " + _tdstyle + ">"+jQuery(cels[j]).text()+"</a>";
					     }
					}
					
					//celstr = celstr + "<span style='margin-bottom:10px;'>"+str+"<span>";
					if(celstr.match(/#_docsubject#/)){
						celstr = celstr.replace(/#_titledocsubject#/g,jQuery(str).text());
						celstr = celstr.replace(/#_docsubject#/g,str);
					}else if(celstr.match(/#_docnumber#/)){
						celstr = celstr.replace(/#_docnumber#/g,str);
					}else if(celstr.match(/#_docisuser#/)){
						celstr = celstr.replace(/#_docisuser#/g,str);
					}
					
				} else {
				    var str = $celj.text();
				    
				    //if(celstr.substr(celstr.length-4)!="<br>") celstr = celstr + "<br>";
					//celstr = celstr + "<span style='margin-bottom:10px;'>"+str+"<span>";
					if(celstr.match(/#_docsubject#/)){
						celstr = celstr.replace(/#_titledocsubject#/g,jQuery(str).text());
						celstr = celstr.replace(/#_docsubject#/g,str);
					}else if(celstr.match(/#_docnumber#/)){
						celstr = celstr.replace(/#_docnumber#/g,SystemEnv.getHtmlNoteName(3582,readCookie("languageidweaver"))+str);
					}else if(celstr.match(/#_docisuser#/)){
						celstr = celstr.replace(/#_docisuser#/g,SystemEnv.getHtmlNoteName(3583,readCookie("languageidweaver"))+str);
					}
					
				}
				
				__coli++;
				
			} else if (cels[j].tagName=="operates"){
			
				//显示操作栏				
				var optStrAll="";

				//var opas = cels[j].childNodes;
				var opas = jQuery(cels[j]).children();
				for(var opti = 0;opti<opas.length;opti++){
					var opa = opas[opti];
					var $opa = jQuery(opa);
					var text = $opa.attr("text");
					var href = $opa.attr("href");
					var target = $opa.attr("target");
					var linkkey = $opa.attr("linkkey");
					var value = $opa.attr("value");
					var otherpara = $opa.attr("otherpara");
					var options = {cusWidth:$opa.attr("width"),cusHeight:$opa.attr("height")};
					if(otherpara==null)otherpara="";
					var operateStr="";
					if (href!=null) {				
						var operateStrLower = href.toLowerCase(); 				
						var pos =operateStrLower.indexOf("javascript:");						
						if (pos != -1)  {
							var strJavaScript="";
							var posBracketStart = href.lastIndexOf("(");
							var posBracketEnd = href.lastIndexOf(")");	
							var strInBracket = href.substring(posBracketStart+1,posBracketEnd);
							
							if (strInBracket.replace(/(^\s*)|(\s*$)/g, "")=="") {  //删除空格
								strJavaScript = href.substring(0,posBracketEnd)+"\""+value+"\",\""+otherpara+"\",this"+href.substring(posBracketEnd);		
							} else {
								strJavaScript = href.substring(0,posBracketEnd)+",\""+value+"\",\""+otherpara+"\",this"+href.substring(posBracketEnd);		
							}
							//operateStr = "<a href='"+strJavaScript+"'>"+text+"</a>";
							if(jQuery.browser.msie){
								operateStr = "<a href='#' onclick='"+strJavaScript+"'>"+text+"</a>";
							}else{
								operateStr = "<a href='#' onclick='"+strJavaScript+";return false;'>"+text+"</a>";
							}
						} else {
							if (target=="_fullwindow") {
								var tempStr = href+"?"+linkkey+"="+value;					
								operateStr = "<a href=javascript:this.openFullWindowForXtable('"+tempStr+"',this,{cusWidth:"+$opa.attr("width")+",cusHeight:"+$opa.attr("height")+"})>"+text+"</a>";	
							} else {
								operateStr = "<a href="+href+"?"+linkkey+"="+value+" target="+target+">"+text+"</a>";	
							}
						}									
					} else {
						operateStr=text;
					}
					optStrAll += "<span style='padding-left:5px;padding-right:5px;'>"+operateStr +"</span>";
				}
				celstr = celstr + "<div class='e8thumbnailop'><div style='padding-left:5px;padding-right:5px;'>" + optStrAll+"</div></div>";
     		}
		}
		
		cel.align = "center";
		
		cel.vAlign = "top";

		cel.innerHTML = celstr;
		$cel.css("position","relative");
		var thubnailImg = $cel.find("div.e8ThumbnailImg");
		var e8thumbnailop = $cel.find("div.e8thumbnailop");
		e8thumbnailop.css({
			"display":"none",
			"position":"absolute"
		});
		$cel.hover(function(){
			var $this = jQuery(this);
			var thubnailImg1 = $this.find("div.e8ThumbnailImg");
			var e8bgimg = $this.find("div.e8BGImg");
			e8bgimg.addClass("e8BGImgHover");
			thubnailImg1.addClass("e8ThumbnailImgHoverH");
			var e8thumbnailop1 = $this.find("div.e8thumbnailop");
			//e8thumbnailop1.show();
			e8thumbnailop1.css({
				"top":thubnailImg1.position().top+thubnailImg1.height()-24,
				"left":thubnailImg1.position().left+1
			});
			e8thumbnailop1.fadeIn("normal",
				function(){
					e8thumbnailop1.css({
						"top":thubnailImg1.position().top+thubnailImg1.height()-e8thumbnailop1.height()+6,
						"left":thubnailImg1.position().left+1
					});
				});
		},function(){
			var $this = jQuery(this);
			var thubnailImg1 = $this.find("div.e8ThumbnailImg");
			thubnailImg1.removeClass("e8ThumbnailImgHoverH");
			var e8bgimg = $this.find("div.e8BGImg");
			e8bgimg.removeClass("e8BGImgHover");
			var e8thumbnailop1 = $this.find("div.e8thumbnailop");
			//e8thumbnailop1.hide();
			e8thumbnailop1.fadeOut("normal");
		});
		thubnailImg.css("cursor","pointer")
				.bind("click",function(){
					var $this = jQuery(this);
					var checkbox = $this.next("div").next("div").children("span.jNiceWrapper").children("input");
					var isRadio = false;
					var _this = this;
					var tables = $cel.find("div.e8ThumbnailImgHover");
						tables.each(function(){
							if(_this===this){
							}else{
								jQuery(this).removeClass("e8ThumbnailImgHover");
							}
						});
					if(checkbox.attr("type")=="radio"){
						isRadio = true;
						var tables = jQuery(cel).find("div.e8ThumbnailImgHover");
						tables.each(function(){
							if(_this===this){
							}else{
								var $this = jQuery(this);
								$this.removeClass("e8ThumbnailImgHover");
								$this.siblings(".e8BGImg").removeClass("e8BGImgHover").removeClass("e8BGImgSel");
							}
						});
					}
					if($this.hasClass("e8ThumbnailImgHover")){
						if(checkbox.length>0){
							$this.removeClass("e8ThumbnailImgHover");
							$this.siblings(".e8BGImg").removeClass("e8BGImgSel");
							if(isRadio && checkbox.length>0){
								changeRadioStatus(checkbox,false);
							}else if(checkbox.length>0){
								changeCheckboxStatus(checkbox,false);
							}
						}
					}else{
						if(checkbox.length>0){
							$this.addClass("e8ThumbnailImgHover");
							$this.siblings(".e8BGImg").addClass("e8BGImgSel");
							if(isRadio && checkbox.length>0){
								changeRadioStatus(checkbox,true);
							}else if(checkbox.length>0){
								changeCheckboxStatus(checkbox,true);
							}
						}
					}
				});
		
		cel.width = (100 / this.imageNumberPerRow).toString()+"%";
		celstr = "";
		
		jQuery(row).append(cel);
		if((tempi % this.imageNumberPerRow == 0 && tempi>1)||tempi==size-1){
		    if((tempi==size-1)&&(tempi%this.imageNumberPerRow!=0)){
		        for(var bi=0;bi< this.imageNumberPerRow - (tempi % this.imageNumberPerRow) ; bi++){
		            var nullcel = this.createByName("td");
		            nullcel.innerHTML = "&nbsp;";
		            //row.appendChild(nullcel);
		            jQuery(row).append(nullcel);
		        }
		        jQuery(tbody).append(row);
		    } else {
    		    //tbody.appendChild(row);
		    	jQuery(tbody).append(row);
    		    row = this.createByName("tr");
    		}
		}
	}

	//是否是重新加载
	if(this.tableDiv.firstChild!=null){
//		this.tableDiv.removeChild(this.tableDiv.firstChild);
		jQuery(this.tableDiv).empty();
	}
	//this.tableDiv.appendChild(tab);	
	jQuery(this.tableDiv).append(tab);
	if((this.page=="true"||this.page=="TRUE"||this.page=="Y")&&this.recordCount!=0){
		//this.div.appendChild(this.infoDiv);
		jQuery(this.div).append(this.infoDiv);
		if (this.isShowTopInfo){
			this.infoDivTop.innerHTML =  this.buildInfo("top");  //1:top 2:buttom
		}
		if (this.isShowBottomInfo){
			this.infoDiv.innerHTML =  this.buildInfo("buttom");	
		}
		this.tableInfoDiv.innerHTML =  this.buildInfo("tableInfoDiv");
		try{
			var pageId = this.pageId;
			if(!pageId){
				pageId = jQuery("#pageId").val();
			}
			jQuery("#pageSizeSel0").selectForK13({
				"width":"40px",
				pageSize:this.pagesize,
				pageId:pageId,
				callback:savePageSize,
                isWrap:false
			});
			jQuery("#pageSizeSel1").selectForK13({
				"width":"40px",
				pageSize:this.pagesize,
				pageId:pageId,
				callback:savePageSize,
                isWrap:false
			});
		}catch(e){
		}
	}

	this.loading = false;
	this.loadOver();
	
	//checked checkbox
	for (var i=0;i<checkboxArrays.length ;i++ )	{
		var temp = checkboxArrays[i];
		if (temp!=null&&temp!=this.pagesize)	{	
			var tempobj = document.getElementById(temp);
			if (tempobj.tagName=="INPUT")	{
				tempobj.checked=true;				
				//tempobj.parentElement.parentElement.className = "Selected"
				thumbnailSelected(tempobj);
			}
		}
	}
	try{
		//缩略图
		jQuery("IMG[src^='/weaver/weaver.splitepage.transform.SptmForThumbnail?fileid=']").live({
			  click: function() {
			  		selectImg(this);
			  },
			  mouseover: function() {
			  		showPreview(event);
			  		//showborder(this);
			    	jQuery(this).parents("table:first").css("border","1px solid #558ed5");
			  },
			  mouseout:function(){
			  		hidePreview(event);
			  		//hideborder();
			  		jQuery(this).parents("table:first").css("border","1px solid #ddd");
			  }
		});
	}catch(e){
		//console.log(e);
	}
	try {
		weaverTableCallbackFunction();
	} catch (e) {
		window.setTimeout(function(){
			try {
				weaverTableCallbackFunction();
			} catch (e) {}
		},300);
	}
	try{
		jQuery('div#_xTable').jNice();
	}catch(e){
		window.setTimeout(function(){
			try{
				jQuery('div#_xTable').jNice();
			}catch(e){}
		},300);
	}
	
	try{
		jQuery("input[type=checkbox]").each(function(){
			if(jQuery(this).attr("tzCheckbox")=="true"){
				jQuery(this).tzCheckbox({labels:['','']});
			}
		});
	}
	catch(e){
		window.setTimeout(function(){
			try{
				jQuery("input[type=checkbox]").each(function(){
					if(jQuery(this).attr("tzCheckbox")=="true"){
						jQuery(this).tzCheckbox({labels:['','']});
					}
				});
			}catch(e){}
		},300);
	}
	
	try{
		var callbackpara = {
			pageNum : this.pageNum,
			nowPage : this.nowPage,
			recordCount : this.recordCount
		};
		//当列表加载完成后调用一个处理函数
		afterDoWhenLoaded(callbackpara);
	}catch(e){
		window.setTimeout(function(){
			try{
				var callbackpara = {
					pageNum : this.pageNum,
					nowPage : this.nowPage,
					recordCount : this.recordCount
				};
				//当列表加载完成后调用一个处理函数
				afterDoWhenLoaded(callbackpara);
			}catch(e){
				if(window.console)console.log(e);
			}
		},300);
	}
	

}
/* edited by ll end */


weaverTable.prototype.showData = function(re){
	var delayedFunctions=[];
	var $re = jQuery(re);
	this.page = $re.attr("page");
	this.pageId = $re.attr("pageId");
	this.pageNum = $re.attr("pagenum");
	this.nowPage = $re.attr("nowpage");
	this.isFromFromMode = $re.attr("isFromFromMode")=="true";
	this.isPageAutoWrap = $re.attr("isPageAutoWrap");
	var tbodyIframe = null;
	try{
		tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	}catch(e)
	{
		tbodyIframe = "";
	}
	
	//操作菜单异步加载提示
	var loadingAsync = jQuery("div#loadingAsycForPage");
	try{		
		if(loadingAsync.length==0){
			loadingAsync = jQuery("<div id='loadingAsycForPage'></div>").css({
				"width":"18px",
				"height":"18px",
				"background-image":"url(/images/loading-small_wev8.gif)",
				"background-repeat":"no-repeat",
				"display":"none",
				"position":"absolute",
				"top":"0px",
				"left":"0px"
			});
			jQuery(document.body).append(loadingAsync);
		}
	}catch(e){
	}
	/*
	if(tbodyIframe!=""&&tbodyIframe!=null){
	if(tbodyIframe.cells != undefined) {    // 使用右键菜单
		if(parseInt(this.nowPage)==1){	
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("新建首页") > 0 || val.indexOf("新建首頁") > 0 || val.indexOf("Newfirst page") > 0) {
					continue;
				}
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
			}	
		}
		if(parseInt(this.pageNum)==1){
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
			}
		}
	}else{// 不使用右键菜单
		if(parseInt(this.nowPage)==1){
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("新建首页") > 0 || val.indexOf("新建首頁") > 0 || val.indexOf("Newfirst page") > 0) {
					continue;
				}
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
			}
		}
		if(parseInt(this.pageNum)==1){	
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
			}
		}
	}
	}
	*/
	this.primarykeylist = new Array();
	
	this.recordCount = $re.attr("recordCount");
	this.tabletype = $re.attr("tabletype");
	this.orderValue = $re.attr("orderValue");
	this.orderType = $re.attr("orderType");
	this.pagesize=$re.attr("pagesize");
	this.havaOperates = $re.attr("havaOprates");
	this.operatesWidth = $re.attr("operatesWidth");
	this.needPage = $re.attr("needPage");
	//added by wcd 2015-10-19
	this.rowClick = $re.attr("rowClick");
	// checkbox ids arrays
	var checkboxArrays = new  Array(this.pagesize);
	var tab = this.createByName("table");
	var $tab = jQuery(tab);
	//重置计数器
	$tab.resetTableMax();
	if (this.isCellThumbnailDis) {
		$tab.css("table-layout","fixed");
	}
	
	$tab.css("width", $re.attr("width"));
	
	//by bpf 2013-10-16 start(去掉单元格空隙)
	tab.cellSpacing="0";
	//by bpf 2013-10-16	end

	this.valign=$re.attr("valign");
    if (this.valign==null) this.valign="middle"

	/*tab.onmousemove = this.mouseMove;
	tab.onmouseup = this.mouseUp;
	tab.onmousedown = this.mouseDown;
	//onmouseover
	tab.onmouseover=function (e){
		try{
			var evt = e ? e:(window.event?window.event:null);
			var targetObj = evt.srcElement ? evt.srcElement : evt.target;
			var targetObjParent = null;
			if (targetObj.tagName == "TD") {
				targetObjParent = jQuery(targetObj).parent(); 
			}else if( targetObj.tagName == "A" || (targetObj.tagName == "INPUT"&&targetObj.name!="_allselectcheckbox")){
				targetObjParent = jQuery(targetObj).closest("tr");
			}
			
			 
			
			// tr (每行鼠标移上去样式)
			targetObjParent.addClass("Selected");
		}catch(e){
			//TODO
		}
	};
	//onmouseout
	tab.onmouseout=function (e){	
		try{
			var evt = e ? e:(window.event?window.event:null);
			var targetObj = evt.srcElement ? evt.srcElement : evt.target;
			if (targetObj.tagName == "TD"||targetObj.tagName == "A" ||(targetObj.tagName == "INPUT"&&targetObj.name!="_allselectcheckbox")){		
				var p = null;
				if (targetObj.tagName == "TD") {
					p = jQuery(targetObj).parent()[0];
				} else {
					p = jQuery(targetObj).closest("tr").get(0);
				}
				jQuery(p).removeClass("Selected");
			
			}else{
				jQuery(".hover").remove();
			}
		}catch(e){
			//TODO
			alert(e);
		}
	};*/
	
	jQuery(this.div).css("width", $re.attr("width"));
	$tab.attr("class", "ListStyle");	
	var thead = this.createByName("thead");
	var tbody = this.createByName("tbody");	
	var colgroup = this.createByName("colgroup");
	$tab.append(colgroup);
	$tab.append(thead);
	$tab.append(tbody);
	

	//操作列
	var optNameColumn = null;

	var rows = jQuery(re).children();
	var size = rows.length;
	var tempi = 0;				//记录奇偶行
	var _aligns;				//每列对齐样式
	var _hrefs;				//每列的链接
	var _colids;				//链接列的参数
	var _targets;				//每列链接的目标框架
	var _keys;				//主键列
	var _widths;
	var _heights;
	var _needTitles=[];				
	var _definedCssRender=window._cssRender;
	var _renderFns=[];	
	var _spans = [];//用于遮罩处理
	for(var i = 0;i<size;i++){	
		
		//表头
		if(rows[i].tagName=="head"){
			var hd = this.createByName("tr");
			jQuery(hd).attr("class", "HeaderForXtalbe");
			
			var heads = jQuery(rows[i]).children();
			
			var hSize = heads.length;			
		
			_aligns = new Array(hSize);
			_hrefs = new Array(hSize);
			_targets = new Array(hSize);
			_colids = new Array(hSize);
			_keys = new Array(hSize);
			_widths = new Array(hSize);
			_heights = new Array(hSize);
			var __coli = 0;		
			
			var editPlugins=[];
			
			if(this.recordCount==0){
				var tr =jQuery(this.createByName("tr"));
				tr.addClass("e8EmptyTR");
				var td = jQuery(this.createByName("td"));
				td.attr("colspan",hSize);
				td.css("text-align","center");
				td.css("height","30px");
				td.css("color","#000");
				var infoMsg=SystemEnv.getHtmlNoteName(3558,readCookie("languageidweaver"));
				td.html(infoMsg);
				tr.append(td);
				jQuery(tbody).append(tr);
				jQuery(".xTable_info").remove();
			}
			
			/*
			表头循环
			*/
			var colTotalWidth = 0;
			var hasCheckbox = false;
			for(var hi=0;hi<hSize;hi++){	
				if(heads[hi].tagName!="col"){
					continue;
				}
				var hdi = this.createByName("th");	
				var col = this.createByName("col");
				jQuery(hdi).css("height", "30px");
				if (this.isCellThumbnailDis) {
					jQuery(hdi).css("text-overflow", "ellipsis").css("white-space", "nowrap")
						.css("word-break", "keep-all")
						.css("overflow", "hidden");
				}
				var _xtb = this;
				//排序操作
				var  hid = jQuery(heads[hi]).attr("orderkey");
				
				if(hid!=null){
					hdi.id = hid;
					//hdi.onclick=function(){_xtb.orderByCol(this);};
					jQuery(document.body).delegate("th","mouseup",function(e){
						var $this = jQuery(this);
						//alert(__weaverTableNamespace__.getCurrentTarget().css("cursor"));
						//console.log(jQuery(this).css("cursor"));
						if(e.which===1 && $this.attr("_canSort")){
							try{
								if(!__weaverTableNamespace__.getCurrentTarget() ||__weaverTableNamespace__.getCurrentTarget().css("cursor")!=="e-resize"){
									_xtb.orderByCol(this);
								}
							}catch(e){
								_xtb.orderByCol(this);
							}
						}
					});
					jQuery(hdi).attr("_canSort","true");
					 /*if(readCookie("languageidweaver")==8) 
					    hdi.title="click order by this"
					 if(readCookie("languageidweaver")==9) 
					    hdi.title="單擊按此列排序"
				     else 
						hdi.title="单击按此列排序"
						*/
						hdi.title = SystemEnv.getHtmlNoteName(3441,readCookie("languageidweaver"));
				}
				//宽度
				var colWidth = 0;
				var $headhi = jQuery(heads[hi]);
				var $col = jQuery(col);
				if($headhi.attr("width")!=null){
					//hdi.width = jQuery(heads[hi]).attr("width");
					jQuery(hdi).width($headhi.attr("width"));
					$col.width($headhi.attr("width"));
					try{
						var headW = $headhi.attr("width");
						if(headW&&!this.isFromFromMode){
							var fixNum = false;
							if(headW.indexOf("px")!=-1){
								fixNum = true;
							}
							headW = parseInt(headW.replace(/[%a-zA-Z]/g,""));
							if(fixNum){
								headW = Math.round(headW/jQuery(window).width());
							}
							if(headW<1)headW = 1;
							while(headW>100){
								headW = headW/10;
							}
							headW = Math.round(headW)+"%";
						}
						$col.attr("width",headW);
						$col.attr("_itemid",hi).attr("");
						$col.attr("_systemid",$headhi.attr("systemid"))
						jQuery(hdi).attr("_itemid",hi).attr("_systemid",$headhi.attr("systemid"));
					}catch(e){
						try{
							col.width = $headhi.attr("width");
						}catch(ex){}
					}
					colWidth =  $headhi.attr("width").replace(/[%a-zA-Z]/g,"");
					//hdi.width = 100;
				}	
				
				var needCol = true;
				if($headhi.attr("hide")=="true" || $headhi.attr("display")=="none"){
					//hdi.style.display ="none";
					jQuery(hdi).css("display", "none");
					jQuery(col).css("display", "none");
					jQuery(col).attr("_display","none");
					//needCol = false;
				}else{
					colTotalWidth += parseInt(colWidth);
				}	
				//对齐
				var __align  = $headhi.attr("align");			
				if (__align==null)	{
					__align="left";
				}
				/*if(__align!=null){
					hdi.align=__align;
				}*/				
				_aligns[__coli] = __align;
				jQuery(hdi).attr("align", __align);
				jQuery(hdi).attr("class",$headhi.attr("rowClass"));
				
				_hrefs[__coli] = $headhi.attr("href");
				_targets[__coli] = $headhi.attr("target");
				_keys[__coli] = $headhi.attr("key");
				_widths[__coli] = $headhi.attr("cusWidth");
				_heights[__coli] = $headhi.attr("cusHeight");
				
				_needTitles.push($headhi.attr("needTitle"));
				_colids[__coli] = hid;
				__coli++;
				
				var _istr = $headhi.attr("text");
				var algorithmdesc = $headhi.attr("algorithmdesc");
				
				
				
				//bpf start 2013-10-14
				var _renderFn;
				var renderId=$headhi.attr("id");
				if(renderId==null || renderId==undefined){
					renderId=$headhi.attr("column");
				}
				
				if(renderId!=null && renderId!=undefined){
					if(_definedCssRender!=null && _definedCssRender!=undefined){
						_renderFn=_definedCssRender[renderId];
					}		
				}
				if(_renderFn==undefined ){
					_renderFn=null;
				}
				_renderFns.push({renderId:renderId,_renderFn:_renderFn});
				
				
				
				//bpf end 2013-10-14
				var editPluginI=jQuery(heads[hi]).attr("editPlugin");
				if( (editPluginI==null || editPluginI==undefined) && jQuery(heads[hi]).attr("type")=="checkbox"){
					editPluginI={
						type:"checkbox",
						name:"chkInTableTag"
					};
				}
				editPlugins.push(editPluginI);
				
				
				//alert(_istr)
				//排序
				if(this.orderValue!=null&&this.orderValue==hid){
					if(this.orderType=="DESC"){
						if (window.ActiveXObject) {
							_istr += "<span class=\"xTable_order xTable_order_desc\">"+ this.getOrderButton("-") +"</span>";
						} else {
							_istr += "<span class=\"xTable_order_desc\" style=\"overflow:hidden;padding-left:5px;\">"+ "▼" +"</span>";
						}
					}else{
						if (window.ActiveXObject) {
							_istr += "<span class=\"xTable_order xTable_order_asc\">"+ this.getOrderButton("+") +"</span>";
						} else {
							_istr += "<span class=\"xTable_order_asc\" style=\"overflow:hidden;padding-left:5px;\">"+ "▲" +"</span>";
						}
						
					}
				}else if(hid!=null){
					_istr+="&nbsp;";
				}else{
					if(algorithmdesc){
						_istr="<span>"+_istr+"</span>"+"<span class=\"xTable_algorithmdesc\" title="+algorithmdesc+"><img src='/images/info_wev8.png' style='vertical-align:top;'/></span>"
					}
				}
				
				var otherWidth = 0;
				
				//-----------------------------
				// 当此列需要排序时，title的显示
				//-----------------------------
				var tabTitleStr = "";
				if (hdi.title != undefined && hdi.title != null && hdi.title != ""  ) {
					tabTitleStr = _istr.replace("&nbsp;", "").replace("", "") + "(" + hdi.title + ")";
				} else {
					tabTitleStr = _istr.replace("&nbsp;", "");
				}
				if (this.isCellThumbnailDis) {
					//-----------------------------
					// 当此列为checkbox时的处理
					//-----------------------------
					if (_istr.indexOf("checkbox") != -1 || _istr.indexOf("CHECKBOX") != -1) {
						tabTitleStr = "";
						hdi.width = "35px";// checkbox modified by bpf 2013-11-07
						jQuery(hdi).css("width","35px").css("max-width","35px").css("text-overflow","inherit");
						jQuery(col).css("width","35px").css("max-width","35px").attr("width","35px");
						if(colTotalWidth==0){
							if(this.isFromFromMode) {
								otherWidth += 35;
							} else {
								colTotalWidth+=3;
							}
						}
						hasCheckbox = true;
					}
					var spanExist = _istr.toLowerCase().indexOf("<span");
					if (spanExist != -1) {
						tabTitleStr = _istr.substring(0, spanExist);
					}
				}
				
				
				hdi.title = tabTitleStr;
				hdi.innerHTML = _istr;//这里显示表头中的文字
				
				jQuery(hd).append(hdi);
				if(needCol){
					jQuery(colgroup).append(col);
				}
				
			}
			if(this.havaOperates=="true"){
				if(this.isFromFromMode) {
					otherWidth +=35;
				} else {
					colTotalWidth += 2;
				}
			}
			var leftColWidth = 0;
			if(this.isFromFromMode) {
				var splitPageContiner = $("#splitPageContiner");
				var allwidth = splitPageContiner.width() - otherWidth;
				var cols = jQuery(colgroup).children("col[_display!='none']");
				cols.each(function(idx,obj){
					if(!hasCheckbox || idx!=0){
						var width = jQuery(obj).attr("width");
						if(width){
							width = parseInt(width.replace(/\D/g,""));
							var newWidth = Math.round(allwidth*width/colTotalWidth);
						
							jQuery(obj).css("width",newWidth+"px");
							try{
								jQuery(obj).attr("width",newWidth+"px");
							}catch(e){
								try{
									obj.width = newWidth+"px";
								}catch(ex){}
							}
						}
					}
				});
			} else {
			
			if(colTotalWidth<100){
				leftColWidth = 100-colTotalWidth;
				var cols = jQuery(colgroup).children("col[_display!='none']");
				var length = cols.length;
				if(hasCheckbox){
					length = length - 1;
				}
				var pointWidth = 0;
				cols.each(function(idx,obj){
					if(!hasCheckbox || idx!=0){
						var width = jQuery(obj).attr("width");
						//var width = jQuery(obj).css("width");
						if(width){
							width = parseInt(width.replace(/\D/g,""));
							var newWidth = leftColWidth/length;
							pointWidth += newWidth - Math.floor(newWidth*100)/100;

							if(idx==cols.length-1){
								newWidth = Math.floor(newWidth)+Math.round(pointWidth);

							}else{
								newWidth = Math.floor(newWidth);


							}
							jQuery(obj).css("width",(width+newWidth)+"%");
							try{
								jQuery(obj).attr("width",(width+newWidth)+"%");
							}catch(e){
								try{
									obj.width = (width+newWidth)+"%";
								}catch(ex){}
							}
						}
					}
				});
			}else if(colTotalWidth>100){
				leftColWidth = colTotalWidth - 100;
				var cols = jQuery(colgroup).children("col[_display!='none']");
				var length = cols.length;
				if(hasCheckbox){
					length = length - 1;
				}
				var pointWidth = 0;
				cols.each(function(idx,obj){
					if(!hasCheckbox || idx!=0){
						var $this = jQuery(this);
						var width = $this.attr("width");
						if(width){
							width = parseInt(width.replace(/\D/g,""));
							var newWidth = leftColWidth/length;
							/*pointWidth += newWidth - Math.floor(newWidth*100)/100;
							if(idx==cols.length-1){
								newWidth = Math.floor(newWidth)+Math.round(pointWidth);
							}else{
								newWidth = Math.floor(newWidth);
							}*/
							$this.css("width",(width-newWidth)+"%");
							try{
								$this.attr("width",(width-newWidth)+"%");
							}catch(e){
							
							}
						}
					}
				});
			}
			}
			
			jQuery(tab).data("editPlugins",editPlugins);
			
			
			//操作列的表头
			if(this.havaOperates=="true"){
				var optCol = this.createByName("th");
				var optColw = this.createByName("col");
				jQuery(optCol).attr("class", "Header");
				optNameColumn = optCol;
				if (false && this.operatesWidth!=null){
					optCol.width=this.operatesWidth;
					jQuery(optColw).css("width",this.operatesWidth);
				}else{
					jQuery(optCol).css("width","35px");
					jQuery(optColw).css("width","35px");
				}	
				jQuery(colgroup).append(optColw);
				//bpf 2013-10-15 start
				//操作列不再显示
				jQuery(hd).append(optCol);
				//bpf 2013-10-15 end
			}
			if (this.isCellThumbnailDis) {
				if (optCol != undefined && optCol != null) {
					optCol.title = optCol.innerHTML;
				}
			}
			//thead.appendChild(hd);
			jQuery(thead).append(hd);
			// 表头下面的线
			var lineAfterHead = this.createByName("tr");
			jQuery(lineAfterHead).attr("class", "Line");

			var tempTD= this.createByName("th");
			tempTD.colSpan=50;		
			lineAfterHead.appendChild(tempTD);		
			//tbody.appendChild(lineAfterHead);
			continue;
		}		
		if(rows[i].tagName!="row"){	
			continue;	
		}
		tempi ++;
		
		$tab.addTableMax();
		var row = this.createByName("tr");
		var $row = jQuery(row);
		var $rowi = jQuery(rows[i]);
		$row.hover(function(){
			jQuery(this).addClass("Selected");
		},function(){
			jQuery(this).removeClass("Selected");
		});
		$row.css("vertical-align", this.valign);
		//row.style.verticalAlign =this.valign;
		if($rowi.attr("PageCount")=="true"){
			$row.addClass("e8PageCountClass");
		}
		if($rowi.attr("TotalCount")=="true"){
			$row.addClass("e8TotalCountClass");
		}
		if($rowi.attr("firstRow")=="true"){
			$row.addClass("e8FirstCountClass");
		}
		var cels = $rowi.children();
		var  cSize = cels.length;
		var __coli = 0;
		var __optIds = new Array(cSize);
		
		var _tdstyle= this.isCellThumbnailDis && !(this.isPageAutoWrap==1||this.isPageAutoWrap=="1") ? " style=\"display:inline-block;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;\" " : " style=\"word-wrap:break-word;word-break:break-all;\"";
		
		
		//bpf start 2013-10-14
		for(var j = 0;j<_renderFns.length;j++){
			_renderFns[j].value=jQuery(cels[j]).text();
		}		
		var _rowDatas={};
		jQuery.each(_renderFns,function(){
			var _renderId=this.renderId;
			var _value=this.value;
			if(_renderId!=null && _renderId!=undefined){
				_rowDatas[_renderId]=_value;
			}
		});
		//bpf end 2013-10-14
		
		//行
		//cSize 为每一行的列数
		for(var j = 0;j<cSize;j++){
			var $celj = jQuery(cels[j]);
			if(cels[j].tagName=="col"){
				var __nowId = ($celj.attr("linkvalue")==null)?$celj.attr("text"):$celj.attr("linkvalue");			
				var cel = this.createByName("td");
				var $cel = jQuery(cel);
				var _name = $celj.attr("name");
				if(_name){
					$cel.attr("name",_name);
				}
                $cel.attr("spacevalue",__nowId);
 				//TD高度设置
				//cel.style.height = "30px";
				$cel.css("height", "30px");
				
				try{
					if(jQuery(heads[j]).attr("hide")=="true"){
						//hdi.style.display ="none";
						$cel.css("display", "none");
					}
				}catch(ee22){}
				
				var celTitle = "";
				
				var showvalue=$celj.attr("showvalue");
				var isChecked = ($celj.attr("checked")=="true"?true:false)				
				
				
				//bpf start 2013-10-14
				try{
					var _renderFn=_renderFns[j]._renderFn;
					if(_renderFn!=null){
						var returnVal=_renderFn(_rowDatas);
						if(returnVal!=null && returnVal!=undefined){
							if(typeof returnVal=="string"){
								$cel.addClass(returnVal);
							}else{
								var csses=returnVal.css;
								if(csses!=null && csses!=undefined){
									for(var c in csses){
										$cel.css(c, csses[c]);
									}
								}
								var className=returnVal.className;
								if(className!=null && className!=undefined){
									$cel.addClass(className);
								}
							}
						}
					}
				}catch(e){}
				//bpf end 2013-10-14
				var css=$celj.attr("css");
				if(css!=null && css!=undefined){
					var jsonCss=jQuery.parseJSON(css);
					var styles=jsonCss.map;
					var classnames=jsonCss.classnames;
					for(var style in styles){
						$cel.css(style,styles[style]);
					}
					jQuery.each(classnames,function(){
						$cel.addClass(this+"");
					});
				}
				
				var tdClass=$celj.attr("tdClass");
				if(tdClass!=null && tdClass!=undefined){
					$cel.addClass(tdClass);
				}	
				
				//是否为主键
				if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
					//this.ckcolids += "," + __nowId;	
					this.primarykeylist.push(__nowId);
				}
				//checkbox	
				if ($celj.attr("type")=="checkbox") {		
//xxxxxx			
					try{		
						if(showvalue.indexOf("</a>")!=-1){
							showvalue = jQuery(showvalue).text();
						}
						showvalue = showvalue.replace(/'|"/g,"");
					}catch(e){}
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;						
					} 
					cel.innerHTML ="<input type=checkbox name=chkInTableTag id=_xTable_"+__nowId+" checkboxId="+__nowId+"  value=\""+showvalue+"\"  onClick=_xtalbe_chkCheck(this)>";					
					//row.appendChild(cel);
					
					
					$row.append(cel);
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}

					//check
					if (isChecked){

					}
					__coli++;				
					continue ;				
				} else if ($celj.attr("type")=="radio") {		//radio		
					if (_xtalbe_radiocheckId == __nowId||isChecked)	{					
						cel.innerHTML ="<input type=radio name=rdoInTableTag  radioId="+__nowId+" checked id=_xTable_"+__nowId+" value=\""+showvalue+"\" onClick=rdoCheck(this)>";
					} else {
						cel.innerHTML ="<input type=radio name=rdoInTableTag radioId="+__nowId+"  id=_xTable_"+__nowId+"  value=\""+showvalue+"\"　 onClick=rdoCheck(this)>";
					}
					//row.appendChild(cel);
					$row.append(cel);
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}
					__coli++;
					continue ;
				} else if ($celj.attr("type")=="none") {
					cel.innerHTML ="&nbsp;<input type=checkbox  style='display:none' id='"+__nowId+"' checkboxId=\""+showvalue+"\" value=\""+showvalue+"\">";// xwj for td2180 20050818				
					if (this.tabletype=="none"){
						//cel.style.display="none";
						$cel.css("display", "none");
					}
					//row.appendChild(cel);
					$row.append(cel);
					$cel.css("width","3%");// checkbox modified by bpf 2013-11-07
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}
					__coli++;	
					continue ;
				}
							
				if(_aligns[__coli]!=null){
					cel.align=_aligns[__coli];	
				}
				//是否为主键
				if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
					__optIds[__coli] = __nowId;	
				}
				
				if(_hrefs[__coli]!=null){				
					var str = "";
					if(_hrefs[__coli].indexOf("javascript:")==-1){
					if (_targets[__coli]=="_fullwindow"){
						var thref = _hrefs[__coli];
						if(thref=="/hrm/resource/HrmResource.jsp")
						{
							if(__nowId!=""&&__nowId!="0"){
								
								str = "<a href='javaScript:openhrm("+__nowId+");' onclick='pointerXY(event);' " + _tdstyle + ">"+ $celj.text()+"</a>";
							}
						}
						else
						{
							if(__nowId!=""){
								var tempUrl = _hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+$celj.attr("linkkey")+"="+__nowId;
								var options = {cusWidth:_widths[__coli],cusHeight:_heights[__coli]};
								if ($celj.text().indexOf("<a") != -1 || $celj.text().indexOf("<A") != -1) {
									str = "<span href=\"javascript:this.openFullWindowForXtable('"+tempUrl+"',this,{cusWidth:"+_widths[__coli]+",cusHeight:"+_heights[__coli]+"})\" " + (this.isCellThumbnailDis ? "" : "") + ">"+ $celj.text().substring(0, 2) + _tdstyle + $celj.text().substr(2) +"</span>";
								} else {
									str = "<a href=\"javascript:this.openFullWindowForXtable('"+tempUrl+"',this,{cusWidth:"+_widths[__coli]+",cusHeight:"+_heights[__coli]+"})\" " + _tdstyle + ">"+ $celj.text()+"</a>";
								}
							}
						}
						
					} else {
						if(__nowId!=""){
							 str = "<a href=\""+
							  _hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+$celj.attr("linkkey")+"="+__nowId+
							  "\" target=\""+_targets[__coli]+"\" " + _tdstyle + ">"+				
							  $celj.text()+
								  "</a>";
						}
					}
					}else{
						if(__nowId!=""){
							 var tempurl=_hrefs[__coli].replace("{0}",__nowId);
							 str = "<a href=\""+tempurl+"\""+_tdstyle +">"+$celj.text()+"</a>";
						}
					}
					cel.innerHTML = str;
				}else{
					var celValue=$celj.text();
					var editPlugin = $celj.attr("editPlugin");
					var canEdit = $celj.attr("canedit");
					$cel.addEditPlugin({celValue:celValue,editPlugin:editPlugin,rowIndex:i-1,delayedFunctions:delayedFunctions},canEdit,this.isFromFromMode);
					
					//---------------------
					// 当td中为纯文本时
					//---------------------
					if (this.isCellThumbnailDis) {

						if(($rowi.attr("PageCount")=="true"||$rowi.attr("TotalCount")=="true") && j==1){
							$cel.css("text-align","right");
							$cel.css("color","rgb(120,119,117");
						}
						if($rowi.attr("PageCount")=="true"){
							$cel.css("color","rgb(120,119,117");
						}
						if(!!$cel.text() && $cel.text().match(/browserValue/)){
						}else{
							if(this.isPageAutoWrap==1||this.isPageAutoWrap=="1"){
								$cel.css("word-wrap", "break-word");
								$cel.css("word-break", "break-all");
							}else{
								$cel.css("white-space", "nowrap");
								$cel.css("text-overflow", "ellipsis");
								$cel.css("word-break", "keep-all");
								$cel.css("overflow", "hidden");
							}
							
						}
						

					}
				}
				var tempTitleStr = "";
				if ($celj.text().toLowerCase().indexOf("<a") != -1) {
					var astartIndex = $celj.text().indexOf(">");
					var aendIndex = $celj.text().indexOf("</");
					tempTitleStr = $celj.text().substring(astartIndex + 1, aendIndex);
				} else {
					tempTitleStr = $celj.text().replace(new RegExp("<br>","gm"), " ");
				}
				
				if (tempTitleStr.toLowerCase().indexOf("<span") != -1) {
					var astartIndex = tempTitleStr.indexOf(">");
					var aendIndex = tempTitleStr.indexOf("</");
					tempTitleStr = tempTitleStr.substring(astartIndex + 1, aendIndex);
					
					astartIndex = tempTitleStr.indexOf(">");
					if (astartIndex != -1) {
						tempTitleStr = tempTitleStr.substr(astartIndex + 1);
					}
				}
				if (this.isCellThumbnailDis) {
					if(!!$celj.text() && $celj.text().match(/browserValue/)){
					}else{
						if(!$cel.attr("_notitle")){
							if(this.isPageAutoWrap==1||this.isPageAutoWrap=="1"){
								
							}else{
								cel.title = removeHTMLTag($celj.text());
							}
						}
					}
				
					if ($cel.children("Table").length != 0) {
						var innerTr = jQuery($cel.children("Table")[0]).children("Tbody").children("TR");
						$cel.css("height", 38 + innerTr.length * 32 + "px");
					} 
				}
				__coli++;
				$row.append(cel);
				if(_needTitles[j]==true || _needTitles[j]=="true"){
					$cel.addClass("needTitle");
				}
			} else if (cels[j].tagName=="operates"){
				//显示操作栏				
				var optCol = this.createByName("td");
				
				var optTextCnt = "";			
				
				var optStrAll="";

				var opas = $celj.children();
				
				var opAsync = $celj.attr("async");
				var md5Str = $celj.attr("_md5");
				
				var optLength=opas.length;
				if(optLength!=0){
					for(var opti = 0;opti<opas.length;opti++){
						var opa = opas[opti];
						var $opa = jQuery(opa);
						var text = $opa.attr("text");
						var title = text;
						var href = $opa.attr("href");
						var target = $opa.attr("target");
						var linkkey = $opa.attr("linkkey");
						var value = $opa.attr("value");
						var otherpara = $opa.attr("otherpara");
						var async = $opa.attr("async");
						var _indexid = $opa.attr("index");
						var options = {cusWidth:$opa.attr("cusWidth"),cusHeight:$opa.attr("cusHeight")};
						if(otherpara==null)otherpara="";
						
						var operateStr="";
						var isABtn=false;
						if (href!=null) {				
							var operateStrLower = href.toLowerCase(); 				
							var pos =operateStrLower.indexOf("javascript:");						
							if (pos != -1)  {
								var strJavaScript="";
								var posBracketStart = href.lastIndexOf("(");
								var posBracketEnd = href.lastIndexOf(")");	
								var strInBracket = href.substring(posBracketStart+1,posBracketEnd);
								
								if (strInBracket.replace(/(^\s*)|(\s*$)/g, "")=="") {  //删除空格
									strJavaScript = href.substring(0,posBracketEnd)+"\""+value+"\",\""+otherpara+"\",this"+href.substring(posBracketEnd);		
								} else {
									strJavaScript = href.substring(0,posBracketEnd)+",\""+value+"\",\""+otherpara+"\",this"+href.substring(posBracketEnd);		
								}
								if(jQuery.browser.msie){
									operateStr = "<a href='#' _indexid='"+_indexid+"' onclick='"+strJavaScript+"' title=" + title + "><span class='operHoverSpan operHover_hand'>&nbsp;"+text+"&nbsp;</span></a>";
								}else{
									operateStr = "<a href='#' _indexid='"+_indexid+"' onclick='"+strJavaScript+";return false;' title=" + title + "><span class='operHoverSpan operHover_hand'>&nbsp;"+text+"&nbsp;</span></a>";
								}
							} else {
							    var tempStr = "";
						        if(href.indexOf("?") > -1){
						           tempStr = href+"&"+linkkey+"="+value;	
						        }else{
						           tempStr = href+"?"+linkkey+"="+value;
						        }				
								if (target=="_fullwindow") {											
									operateStr = "<a _indexid='"+_indexid+"' href=javascript:this.openFullWindowForXtable('"+tempStr+"',this,{cusWidth:"+jQuery(opa).attr("width")+",cusHeight:"+jQuery(opa).attr("height")+"}) title=" + title + "><span class='operHoverSpan operHover_hand'>&nbsp;"+text+"&nbsp;</span></a>";	
								} else {
									operateStr = "<a _indexid='"+_indexid+"' href="+tempStr+" target="+target+" title=" + title + "><span class='operHoverSpan operHover_hand'>&nbsp;"+text+"&nbsp;</span></a>";	
								}
							}									
							isABtn=true;
						} else {
							operateStr="<span class='operHoverSpan' _md5='"+md5Str+"'>&nbsp;"+text+"&nbsp;</span>";
						}
						optStrAll +=operateStr;
						optTextCnt += text + " ";
					}
					$row.append(optCol);
					jQuery(optCol).addClass("hoverOptCell")
						.css("text-align","center")
						.css("vertical-align","middle").css("line-height","30px")
						.html("<div class='e8operate' async="+async+" _md5='"+md5Str+"'>&nbsp;</div>");
					
					
					var hoverDiv=jQuery("<div class='hoverDiv' async="+opAsync+" _md5='"+md5Str+"'>&nbsp;&nbsp;&nbsp;" +optStrAll +"&nbsp;&nbsp;&nbsp;</div>");
					$row.data("hoverDiv",hoverDiv);
					hoverDiv.data("relatedRow",jQuery(row));
					
					jQuery(optCol).children("div.e8operate").hover(
						function(e){
							var $this = jQuery(this);
							var async = $this.attr("async");
							if((async!==false && async!=="false") || $this.attr("_loaded")){
								var _row = $this.closest("tr");
								jQuery(".hoverDiv").hide();
								var rowHoverDiv=jQuery(_row).data("hoverDiv");
								jQuery(row).parent().parent().before(rowHoverDiv);
								var topHeight=jQuery(_row).offset().top;
								if(rowHoverDiv.lastRowHoverDivWidth && rowHoverDiv.lastRowHoverDivWidth>jQuery(rowHoverDiv).width()){
									jQuery(rowHoverDiv).width(rowHoverDiv.lastRowHoverDivWidth);
								}else{
									rowHoverDiv.lastRowHoverDivWidth = jQuery(rowHoverDiv).width();
								}
								var _rowHeight = jQuery(_row).height();
								var _marginTop = jQuery(_row).offset().top-jQuery(_row).parent().parent().offset().top;
								if(window.__weaverTableNamespace__){
									var contentTable = __weaverTableNamespace__.getContentTable();
									if(contentTable && contentTable.length>0){
										var _ctop = contentTable.perfectScrollbar("getScrollTop");
										//console.log("ctop::"+_ctop);
										_marginTop -= _ctop;
									}
								}
								//console.log(_marginTop);
								if(_rowHeight>32){
									_marginTop = _marginTop+_rowHeight-32;
									_rowHeight=32;
	
								}
								rowHoverDiv.css("height",_rowHeight+"px");
								rowHoverDiv.css("line-height",_rowHeight+"px");
								rowHoverDiv.css("width",jQuery(rowHoverDiv).width()+"px");
								//rowHoverDiv.css("margin-top",_marginTop);
								var _table = jQuery("#_xTable div.table");
								var scroll = null;
								var scrollLeft = 0;
								var scrollTop = 0;
								try{
									if(_table.attr("_oriScrollbar")){
										scroll = jQuery("#_xTable table.ListStyle").offset();
										scrollLeft = scroll.left;
										scrollTop = scroll.top;
									}
								}catch(e){}
								if(!_table.attr("_oriScrollbar")){
									scrollLeft = 0;
									scrollTop = 0;
								}
								rowHoverDiv.css("margin-left",(jQuery(row).width()-jQuery(rowHoverDiv).width()+scrollLeft)+"px");
								rowHoverDiv.css("margin-top",_marginTop+scrollTop);
								rowHoverDiv.show();
								var _this = this;
								jQuery(_this).hide();
								rowHoverDiv.hover(function(){
									jQuery(this).data("relatedRow").addClass("Selected");
									jQuery(_this).hide();
								},function(){
									jQuery(this).data("relatedRow").removeClass("Selected");
									jQuery(this).hide();
									jQuery(_this).show();
								});
							}else{
								var _this = this;
								jQuery.ajax({
									url:"/weaver/weaver.common.util.taglib.SplitPageXmlServlet?src=getOperateStatus&md5="+$this.attr("_md5"),
									dataType:"json",
									beforeSend:function(){
										if(loadingAsync){
											try{
												loadingAsync.css("top",$this.offset().top+9).css("left",$this.offset().left-18).css("display","block");
											}catch(e){
											}
										}
									},
									complete:function(){
										if(loadingAsync){
											loadingAsync.hide();
										}
									},
									error:function(){
										top.Dialog.alert("error!");
									},
									success:function(data){
										if(data.msg){
											top.Dialog.alert(data.msg);
											return;
										}
										var _row = $this.closest("tr");
										jQuery(".hoverDiv").hide();
										var rowHoverDiv=jQuery(_row).data("hoverDiv");
										var operates = rowHoverDiv.children("a");
										operates.each(function(i,obj){
											var _$this = jQuery(this);
											var index = _$this.attr("_indexid")
											if(data["index_"+index]===false || data["index_"+index]==="false"){
												_$this.remove();
											}
										});
										$this.attr("_loaded",true);
										jQuery(row).parent().parent().before(rowHoverDiv);
										
										var topHeight=jQuery(_row).offset().top;
										if(rowHoverDiv.lastRowHoverDivWidth && rowHoverDiv.lastRowHoverDivWidth>jQuery(rowHoverDiv).width()){
											jQuery(rowHoverDiv).width(rowHoverDiv.lastRowHoverDivWidth);
										}else{
											rowHoverDiv.lastRowHoverDivWidth = jQuery(rowHoverDiv).width();
										}
										var _rowHeight = jQuery(_row).height();
										var _marginTop = jQuery(_row).offset().top-jQuery(_row).parent().parent().offset().top;
										if(window.__weaverTableNamespace__){
											var contentTable = __weaverTableNamespace__.getContentTable();
											if(contentTable && contentTable.length>0){
												var _ctop = contentTable.perfectScrollbar("getScrollTop");
												//console.log("ctop::"+_ctop);
												_marginTop -= _ctop;
											}
										}
										//console.log(_marginTop);
										if(_rowHeight>32){
											_marginTop = _marginTop+_rowHeight-32;
											_rowHeight=32;
			
										}
										rowHoverDiv.css("height",_rowHeight+"px");
										rowHoverDiv.css("line-height",_rowHeight+"px");
										
										var _table = jQuery("#_xTable div.table");
										var scroll = null;
										var scrollLeft = 0;
										var scrollTop = 0;
										try{
											if(_table.attr("_oriScrollbar")){
												scroll = jQuery("#_xTable table.ListStyle").offset();
												scrollLeft = scroll.left;
												scrollTop = scroll.top;
											}
										}catch(e){}
										if(!_table.attr("_oriScrollbar")){
											scrollLeft = 0;
											scrollTop = 0;
										}
										rowHoverDiv.css("margin-left",(jQuery(row).width()-jQuery(rowHoverDiv).width()+scrollLeft)+"px");
										rowHoverDiv.css("margin-top",_marginTop+scrollTop);
										rowHoverDiv.show();
										jQuery(_this).hide();
										rowHoverDiv.hover(function(){
											jQuery(this).data("relatedRow").addClass("Selected");
											jQuery(_this).hide();
										},function(){
											jQuery(this).data("relatedRow").removeClass("Selected");
											jQuery(this).hide();
											jQuery(_this).show();
										});
									}
								});
							}
						},function(e){
						}
					);
					$row.bind("mouseleave",function(e){
						var evt = e ? e:(window.event?window.event:null);
						var targetObj = jQuery(evt.toElement ? evt.toElement : evt.relatedTarget);
						jQuery(this).find("div.e8operate").show();
						if (targetObj.hasClass("hoverDiv") || targetObj.parent().hasClass("hoverDiv") || targetObj.parent().parent().hasClass("hoverDiv")) {
							
						}else{
							if(targetObj.closest("td.hoverOptCell").length==0){
								jQuery(this).data("hoverDiv").hide();
							}
						}
						/*if(window.event){
							window.event.cancelBubble = true ;
							return false;
						}else{
							evt.stopPropagation();
							evt.preventDefault()
						}*/
					});
					//bpf 2013-10-15 end
				}else if(this.havaOperates=="true"){
					$row.append(optCol);
				}
				
				if (this.isCellThumbnailDis) {
					try {
						if (parseInt(optNameColumn.width.replace("px"),"") < (optTextCnt.length * 11)) {
							optNameColumn.width = (optTextCnt.length * 11) + "px";
						}
					} catch (e) {}
				}
     		}
		}		
		//tbody.appendChild(row);
		jQuery(tbody).append(row);
		//added by wcd 2015-10-19
		if($rowi.attr("rowClick")!="") {
			$row.attr('onclick', '').click(eval("0,(function(){"+$rowi.attr("rowClick")+";});"));
		}
		var trSpacing = jQuery("<tr class='Spacing' style='height:1px!important;'></tr>")
		var tdSpacing = jQuery("<td></td>");
		var divSpacing = jQuery("<div class='intervalDivClass'></div>");
		if(jQuery(rows[i]).attr("PageCount")=="true"){
			trSpacing.addClass("e8PageCountSpacingClass");
		}else if(jQuery(rows[i]).attr("TotalCount")=="true"){
			trSpacing.addClass("e8TotalCountSpacingClass");
		}else{
			tdSpacing.append(divSpacing);
		}
		var hiddenLength = 0;
		$row.children("td").each(function(){
			if(jQuery(this).css("display")=="none"){
				hiddenLength++;
			}
		});
		tdSpacing.attr("colspan",$row.children("td").length-hiddenLength);
		trSpacing.append(tdSpacing);
		if(i!=size-1){
			if(i==size-3 && jQuery(rows[i+1]).attr("PageCount")=="true"){
				tdSpacing.addClass("paddingLeft0Table");
			}else{
				tdSpacing.addClass("paddingLeft0Table");
			}
			
		}else{
			tdSpacing.addClass("paddingLeft0Table");
		}
		jQuery(tbody).append(trSpacing);
		/*对于样式，移动到最后来处理*/
		//处理整行的样式
		var generatedRowStyle=jQuery(rows[i]).attr("css");
		if(generatedRowStyle!=null && generatedRowStyle!=undefined){
			var jsonCss=jQuery.parseJSON(generatedRowStyle);
			var styles=jsonCss.map;
			var classnames=jsonCss.classnames;
			var lastVisibleTD = null;
			jQuery(row).children("td").each(function(){
				if(jQuery(this).css("display")!="none"){
					lastVisibleTD = this;
				}
			});
			for(var style in styles){
				jQuery(lastVisibleTD).css(style,styles[style]);
			}
			jQuery.each(classnames,function(){
				jQuery(row).addClass(this+"");
			});
		}
	}
	// 最后一行 是一条线
	var lineAfterLast = this.createByName("tr");
	//lineAfterLast.className="xTable_line";
	jQuery(lineAfterLast).attr("class", "xTable_line");
	
	

	var tempTD= this.createByName("th");
	tempTD.colSpan=50;		
	
	jQuery(lineAfterLast).append(tempTD);

	
	
	//是否是重新加载/
	if(this.tableDiv.firstChild!=null){
//		this.tableDiv.removeChild(this.tableDiv.firstChild);
		jQuery(this.tableDiv).empty();
	}
	jQuery(this.tableDiv).append(tab);
	
	
	if((this.page=="true"||this.page=="TRUE"||this.page=="Y")&&this.recordCount!=0){
		//this.div.appendChild(this.infoDiv);
		jQuery(this.div).append(this.infoDiv);
		if (this.isShowTopInfo){
			this.infoDivTop.innerHTML =  this.buildInfo("top");  //1:top 2:buttom
		}
		if (this.isShowBottomInfo){
			this.infoDiv.innerHTML =  this.buildInfo("buttom");	
		}
		this.tableInfoDiv.innerHTML =  this.buildInfo("tableInfoDiv");	
		try{
			var pageId = this.pageId;
			if(!pageId){
				pageId = jQuery("#pageId").val();
			}
			jQuery("#pageSizeSel0").selectForK13({
				"width":"40px",
				pageSize:this.pagesize,
				pageId:pageId,
				callback:savePageSize,
                isWrap:false
			});
			jQuery("#pageSizeSel1").selectForK13({
				"width":"40px",
				pageSize:this.pagesize,
				pageId:pageId,
				callback:savePageSize,
                isWrap:false
			});
		}catch(e){
		}
	}

	this.loading = false;
	this.loadOver();
	
	//checked checkbox
	for (var i=0;i<checkboxArrays.length ;i++ )	{
		var temp = checkboxArrays[i];
		if (temp!=null&&temp!=this.pagesize)	{	
			var tempobj = document.getElementById(temp);
			if (tempobj.tagName=="INPUT")	{
				tempobj.checked=true;				
				jQuery(tempobj).closest("tr").attr("class", "Selected");
			}
		}
	}
	
	//处理门户里的列表开始
	try{		
		var oFrm=parent.document.frames["mainFrame"];			
		var realHeight=oFrm.document.body.scrollHeight;
		parent.document.getElementById("mainFrame").height=realHeight;		
	} catch(e){
		//alert(e)
	}
	//--门户里的列表结束
	
	jQuery("body").append(delayedFunctions.join(" "));
	
	try{
		__beforeJNice__();
	}catch(e){
	
	}
	
	//固定表头及配置可拖拽列宽
	try{
		var iscustom = jQuery("#iscustom").val();
		var formmodeFlag = jQuery("#formmodeFlag").val();
		if(formmodeFlag==1){
			if(iscustom == 1){
				if(jQuery("#pageId").length>0 && !window.__useOriScrollBar){
					__weaverTableNamespace__.init("#_xTable");
					__weaverTableNamespace__.fixHeader();
					__weaverTableNamespace__.resizeColumnWidth();
				}	
			}else{
				__weaverTableNamespace__.init("#_xTable");
				__weaverTableNamespace__.fixHeader();
			}
		}else{
			if(jQuery("#pageId").length>0 && !window.__useOriScrollBar){
				__weaverTableNamespace__.init("#_xTable");
				__weaverTableNamespace__.fixHeader();
				__weaverTableNamespace__.resizeColumnWidth();
			}
		}
	}catch(e){
		if(window.console)console.log(e+"--->weaverTable.js-->fixHeader");
	}
	
	try {
		weaverTableCallbackFunction();
	} catch (e) {
		window.setTimeout(function(){
			try {
				weaverTableCallbackFunction();
			} catch (e) {}
		},300);
	}
	try{
		jQuery('div#_xTable').jNice();
	}catch(e){
		window.setTimeout(function(){
			try{
				jQuery('div#_xTable').jNice();
			}catch(e){}
		},300);
	}
	
	try{
		beautySelect("div#_xTable select");
	}catch(e){
		window.setTimeout(function(){
			try{
				beautySelect("div#_xTable select");
			}catch(e){
				if(window.console)console.log(e+"-->weaverTable.js-->beautySelect()");
			}
		},300);
	}
	
	try{
		jQuery("input[type=checkbox]").each(function(){
			if(jQuery(this).attr("tzCheckbox")=="true"){
				jQuery(this).tzCheckbox({labels:['','']});
			}
		});
	}
	catch(e){
		window.setTimeout(function(){
			try{
				jQuery("input[type=checkbox]").each(function(){
					if(jQuery(this).attr("tzCheckbox")=="true"){
						jQuery(this).tzCheckbox({labels:['','']});
					}
				});
			}catch(e){}
		},300);
	}
	
	try{
		var callbackpara = {
			pageNum : this.pageNum,
			nowPage : this.nowPage,
			recordCount : this.recordCount
		};
		//当列表加载完成后调用一个处理函数
		afterDoWhenLoaded(callbackpara);
	}catch(e){
		window.setTimeout(function(){
			try{
				var callbackpara = {
					pageNum : this.pageNum,
					nowPage : this.nowPage,
					recordCount : this.recordCount
				};
				//当列表加载完成后调用一个处理函数
				afterDoWhenLoaded(callbackpara);
			}catch(e){
				if(window.console)console.log(e);
			}
		},300);
	}
}
//页面跳转
weaverTable.prototype.buildInfo = function(type){
	var returnStr="";
	
	if (type=="tableInfoDiv")	{
		var strExpExcel="";
		if (this.showExpExcel)	{
			 strExpExcel="<div align='right'><img title='"+SystemEnv.getHtmlNoteName(3442,readCookie("languageidweaver"))+"' onmouseover=\"javascript:this.src='/images/expExcel1_hover_wev8.png'\" onmouseout=\"javascript:this.src='/images/expExcel1_wev8.png'\" src='/images/expExcel1_wev8.png' style='cursor:pointer' onclick='javaScript:_xtable_getExcel()'>&nbsp;&nbsp;&nbsp;&nbsp;<img title='"+SystemEnv.getHtmlNoteName(3584,readCookie("languageidweaver"))+"'  onmouseover=\"javascript:this.src='/images/expExcel2_hover_wev8.png'\" onmouseout=\"javascript:this.src='/images/expExcel2_wev8.png'\" src='/images/expExcel2_wev8.png' style='cursor:pointer' onclick='javaScript:_xtable_getAllExcel()'></div>";
		}	
		returnStr="<table width=100%><tr><td><div align='left'>"+this.tableInfo+"</div></td><td>"+strExpExcel+"</td></tr> <tr class='xTable_line1'><td colspan=2></td></tr> </table>"		
		return returnStr;
	}
	var str = "";
	var pageSizeInput = this.pagesize;
	if(this.needPage=="false")return returnStr;
	if(!!jQuery("#pageId").val() || !!this.pageId){
		var pageId = this.pageId;
		if(!pageId){
			pageId = jQuery("#pageId").val();
		}
		var selPageId = "pageSizeSel";
		var spanPageId = "spanPage";
		if(type=="top"){
			selPageId+="0";
			spanPageId += "0";
		}else{
			selPageId+="1";
			spanPageId += "1";
		}
		//pageSizeInput = "<span onclick=\"jQuery('#"+selPageId+"').click();\" id=\""+spanPageId+"\" name=\""+spanPageId+"\" style=\"cursor:pointer;display: inline-block; width: 22px; height: 22px; position: absolute; top: 0px; left: 33px; background: none repeat scroll 0% 0% rgb(79, 151, 38);\" ></span>"+
		pageSizeInput = "<select class='_pageSize' id='"+selPageId+"' name='"+selPageId+"' style=\"background:transparent;border:none;width:50px;text-align:center;TEXT-DECORATION:none;height:20px;padding-right:2px;margin-left:5px;margin-right:5px;line-height:20px;display:none;\">"+
						"<option value='10'>10</option>"+
						"<option value='20'>20</option>"+
						"<option value='50'>50</option>"+
						"<option value='100'>100</option>"+
						"</select>";
        var pageSizeInputLis = "<li>10</li>"+
                        "<li>20</li>"+
                        "<li>50</li>"+
                        "<li>100</li>";
                        
        pageSizeInput = "<div class='K13_select'>"
                      + "    <div class='K13_select_checked'><input class='_pageSizeInput' AUTOCOMPLETE='off' maxLength=3 style='width:"+"40px"+";background:transparent;text-align:center;border:1px solid transparent;color:#fff;height:26px;vertical-align:top;' type='text' value='"+this.pagesize+"' name='" + selPageId + "inputText' id='" + selPageId+ "inputText'/></div><div class='K13_select_list'><ol>" + pageSizeInputLis + "</ol></div>" 
                      + "    " + pageSizeInput 
                      + "</div>"
		//pageSizeInput = "<input type=\"text\" onkeyup=\"savePageSize(event,this,'"+pageId+"');\" name=\"pagesize\" maxLength=2 value='"+this.pagesize+"' style=\"width:30px;text-align:center;TEXT-DECORATION:none;height:20px;padding-right:2px;margin-left:5px;margin-right:5px;line-height:20px\"/>";
	}
	var rightStr = "<span class=\"e8_splitpageinfo\">";
	/*if(readCookie("languageidweaver")==8) {
		//str = "&raquo; record:"+this.recordCount+"&nbsp&nbsp&nbsp current/page: "+this.nowPage+"/"+this.pageNum+"&nbsp&nbsp&nbsp ";
		//rightStr = "<span style=\"position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">&raquo; record:"+this.recordCount + "</span>";
		rightStr += "<span style=\"position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">"+pageSizeInput+"record/page&nbsp;|&nbsp;total"+this.recordCount+"records</span>";
	} else if(readCookie("languageidweaver")==9) { 
		//str = "&raquo; 共"+this.recordCount+"條記錄&nbsp&nbsp&nbsp每頁"+this.pagesize+"條&nbsp&nbsp&nbsp共"+this.pageNum+"頁&nbsp&nbsp&nbsp當前第"+this.nowPage + "頁";
		//rightStr = "<span style=\"position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">&raquo; 共"+this.recordCount+"條記錄&nbsp&nbsp&nbsp每頁"+pageSizeInput+"條" + "</span>";
		rightStr += "<span style=\"position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">"+pageSizeInput+"條/頁&nbsp;|&nbsp;共"+this.recordCount+"條</span>";
	} else { 
		//str = "&raquo; 共"+this.recordCount+"条记录&nbsp&nbsp&nbsp每页"+this.pagesize+"条&nbsp&nbsp&nbsp共"+this.pageNum+"页&nbsp&nbsp&nbsp当前第"+this.nowPage + "页";	
		//rightStr = "<span style=\"position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">&raquo; 共"+this.recordCount+"条记录&nbsp&nbsp&nbsp每页"+pageSizeInput+"条" + "</span>";
		rightStr += "<span style=\"position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">"+pageSizeInput+"条/页&nbsp;|&nbsp;共"+this.recordCount+"条</span>";
	}*/
	rightStr += "<span style=\"position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">"+pageSizeInput+SystemEnv.getHtmlNoteName(3585,readCookie("languageidweaver"))+"&nbsp;|&nbsp;"+SystemEnv.getHtmlNoteName(3586,readCookie("languageidweaver"))+this.recordCount+(readCookie("languageidweaver")==8?"":SystemEnv.getHtmlNoteName(3524,readCookie("languageidweaver")))+"</span>";
	rightStr += "</span>"
	
	
	//-------------------------------------------------
    // new page start 
    //-------------------------------------------------
    var sbf = "";
    var z_index = parseInt(this.nowPage) - 2;
    var y_num = parseInt(this.nowPage) + 2;
    var tempCent = "";
    var tempLeft = "";
    var tempRight = "";
	if (z_index > 1) {
        tempLeft += "<span class=\"e8_numberspan\" _jumpTo=\"" + this.id + "\" onClick=\"XTableHandler.jumpTo(this, 1)\">" + 1 + "</span>";
    }
    if (z_index > 2) {
        tempLeft += "<span class=\"e8_numberspan\">&nbsp;...&nbsp;</span>";
    }
    
    if (y_num < (this.pageNum - 1)) {
        tempRight += "<span class=\"e8_numberspan\">&nbsp;...&nbsp;</span>";
    }
    
    if (y_num < this.pageNum) {
        tempRight += "<span class=\"e8_numberspan\" _jumpTo=\"" + this.id + "\" onClick=\"XTableHandler.jumpTo(this, " + this.pageNum + ")\">" + this.pageNum + "</span>";
    }
    
    for(;z_index<=y_num; z_index++) {
        if (z_index>0 && z_index<=this.pageNum) {
            if (z_index == this.nowPage) {
                tempCent +="<span  _jumpTo=\"" + this.id + "\" onClick=\"XTableHandler.jumpTo(this, " + z_index + ")\" class=\"e8_numberspan weaverTableCurrentPageBg\" >" + z_index + "</span>";                
            } else {
                tempCent +="<span class=\"e8_numberspan\" _jumpTo=\"" + this.id + "\" onClick=\"XTableHandler.jumpTo(this, " + z_index + ")\">" + z_index + "</span>";
            }
        }
    }
    
    sbf = tempLeft + tempCent + tempRight;
	
	
	if(this.pageNum>=1){
		if(parseInt(this.nowPage)>1){
			str +="<span class=\"e8_numberspan weaverTablePrevPage weaverTablePage\" id=\""+this.id+"-pre\" onClick=\"+XTableHandler.prePage(this)\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\">&lt;</span>"	
			
		}else{
			str += "<span class=\"e8_numberspan weaverTablePrevPageOfDisabled weaverTablePage\">&lt;</span>";
		}
	}
	str += sbf;
	if(this.pageNum>=1){
		if(parseInt(this.nowPage)<this.pageNum){
			str +="<span class=\"e8_numberspan weaverTableNextPage weaverTablePage\" id=\""+this.id+"-next\" onClick=\"+XTableHandler.nextPage(this)\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\">&gt;</span>"	
		}else{
			str += "<span class=\"e8_numberspan weaverTableNextPageOfDisabled weaverTablePage\">&gt;</span>";
		}
	}	

	var tempTableInfo = this.tableInfo;
	if (type=="top"){
		/*if(readCookie("languageidweaver")==8){
			str += jumpInternational(this.id, this.nowPage, "", "PAGE", "jump", "_XTABLE_GOPAGE_top", "top",this.pageNum);
		}
		else if(readCookie("languageidweaver")==9){
			str += jumpInternational(this.id, this.nowPage, "第", "頁", "跳轉", "_XTABLE_GOPAGE_top", "top",this.pageNum);
		}else {
			str += jumpInternational(this.id, this.nowPage, "第", "页", "跳转", "_XTABLE_GOPAGE_top", "top",this.pageNum);  
		}*/
		str += jumpInternational(this.id, this.nowPage, SystemEnv.getHtmlNoteName(3587,readCookie("languageidweaver")), (readCookie("languageidweaver")==9?"&nbsp;":SystemEnv.getHtmlNoteName(3526,readCookie("languageidweaver"))),SystemEnv.getHtmlNoteName(3588,readCookie("languageidweaver")), "_XTABLE_GOPAGE_top", "top",this.pageNum);  
	} else {
		tempTableInfo = "" ;
		if(readCookie("languageidweaver")==8){
            str += jumpInternational(this.id, this.nowPage, "", "page", "GO", "_XTABLE_GOPAGE_buttom", "buttom",this.pageNum);
        } else {
            str += jumpInternational(this.id, this.nowPage, SystemEnv.getHtmlNoteName(3587,readCookie("languageidweaver")), SystemEnv.getHtmlNoteName(3526,readCookie("languageidweaver")), SystemEnv.getHtmlNoteName(3588,readCookie("languageidweaver")), "_XTABLE_GOPAGE_buttom", "buttom",this.pageNum);
        }
	}		
	str += "";	
	var strExcel="";	
	var selectAll="";
	/*if(readCookie("languageidweaver")==8){
		selectAll = "Select All";
	}else if(readCookie("languageidweaver")==9){
		selectAll = "全選";
	}else{
		selectAll = "全选";
	}*/
	selectAll = SystemEnv.getHtmlNoteName(3443,readCookie("languageidweaver"));
	str += rightStr;
	//var strExcel="<div align=left><button class=xTable_btnExcel onclick='javascript:_xtable_getExcel()'>export this</button>&nbsp;<button class=xTable_btnExcel onclick='javascript:_xtable_getAllExcel()'>export all</button></div>";
	if (this.tabletype=="checkbox"){	
			if (type=="top"){
				returnStr = "<div><table width=100%><tr><td>"+this.TopLeftText+"</td><td><div align=right><span class=\"e8_pageinfo\">"+str+"</span></div></td></tr></table></div>"
			} else {				
				returnStr = "<div><table width=100%><tr><td>"+this.BottomLeftText+" <input name='_allselectcheckbox' type=checkbox onClick='checkAllChkBox(this.checked)'> "+selectAll+"</td><td><div align=right><span class=\"e8_pageinfo\">"+str+"</span></div></td></tr></table></div>"
			}
	} else if(this.tabletype=="thumbnail"){
			if (type=="top"){
				returnStr = "<div><table width=100%><tr><td>"+this.TopLeftText+"</td><td><div align=right>"+str+"</div></td></tr></table></div>"
			} else {				
				returnStr = "<div><table width=100%><tr><td>"+this.BottomLeftText+" <input name='_allselectcheckbox' type=checkbox onClick='checkAllThumbnailBox(this.checked)'> "+selectAll+"</td><td><div align=right><span class=\"e8_pageinfo\">"+str+"</span></div></td></tr></table></div>"
			}
	} else if(this.tabletype=="thumbnailNoCheck"){
			if (type=="top"){
				returnStr = "<div><table width=100%><tr><td>"+this.TopLeftText+"</td><td><div align=right><span class=\"e8_pageinfo\">"+str+"</span></div></td></tr></table></div>"
			} else {				
				returnStr = "<div><table width=100%><tr><td>"+this.BottomLeftText+"</td><td><div align=right><span class=\"e8_pageinfo\">"+str+"</span></div></td></tr></table></div>"
			}
	} else {
		if (type=="top"){
				returnStr = "<div><table width=100%><tr><td>"+this.TopLeftText+" "+strExcel+"</td><td><div  align=right><span class=\"e8_pageinfo\">"+str+"</span></div></td></tr></table></div>"		
			} else {				
				returnStr = "<div><table width=100%><tr><td>"+this.BottomLeftText+" "+strExcel+"</td><td><div  align=right><span class=\"e8_pageinfo\">"+str+"</span></div></td></tr></table></div>"		
			}	
	}
	return returnStr;
}


//转到按钮的语言设置
function jumpInternational(id, nowPage, jTo, jPg, jJump, topOrButtom, what,pageNum) {
    var result = "";
    result += "<span style=\""+(pageNum>=1?"":"padding-left:10px;")+"float:left;TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;\">" + jTo + "</span>";
    result += "<span id=\""+id+topOrButtom+"_go_page_wrap\" style=\"float:left;display:inline-block;width:30px;height:20px;border:1px solid #FFF;margin:0px 1px;padding:0px;position:relative;left:0px;top:5px;\">";
    result += "<span id=\""+id+topOrButtom+"-goPage\" onclick=\"+XTableHandler.goPage(this,'" + what + "')\" style=\"float:left;cursor:pointer;width: 44px; height: 22px; line-height: 20px; padding: 0px; text-align: center; border: 0px; background-color: rgb(0, 99, 220); color: rgb(255, 255, 255); position: absolute; left: 0px; top: -1px; display: none;z-index:10000\">" + jJump + "</span>";
    result += "<input id=\""+ id + topOrButtom + "\" type=\"text\"  onfocus=\"+XTableHandler.focus_goPage(this)\" onkeypress=\"return weaverTable_checkInput(event);\" onblur=\"+XTableHandler.blur_goPage(this)\" value=\""+nowPage+"\" size=\"3\" onMouseOver=\"if(jQuery('#"+id+topOrButtom+"-goPage').css('display')=='none'){jQuery(this).css('border','1px solid #DDDDDD');}\" onMouseout=\"jQuery(this).css('border','1px solid transparent')\" style=\"color:#666666;width:30px;height:18px;line-height:18px;float:left;text-align:center;border:0px;position:absolute;left:0px;top:0px;outline:none;border:1px solid transparent;\"/></span>";
    result += "<span style=\"float:left;TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;padding-right:10px;\">" + jPg + "</span>"
//    result += "&nbsp;<span id=\""+id+"-goPage\" onClick=\"+XTableHandler.goPage(this,'" + what + "')\" style=\"display:inline-block;line-height:21px;cursor:pointer;background:url(/wui/theme/" + GLOBAL_CURRENT_THEME + "/skins/" + GLOBAL_SKINS_FOLDER + "/table/jump_wev8.png) no-repeat;height:21px;width:30px;margin-right:5px;text-align:center;border:none;\">" + jJump + "</span>";
    return result;
}

function pmouseover(obj, flag) {
    if (obj == undefined) {
        return;
    }
    if (flag == true) {
    	if (jQuery(obj).hasClass("weaverTableNextPage")) {
    		//obj.className = "weaverTableNextSltPage";
    		jQuery(obj).removeClass("weaverTableNextPage").addClass("weaverTableNextSltPage");
    	} else {
    		//obj.className = "weaverTablePrevSltPage";
    		jQuery(obj).removeClass("weaverTablePrePage").addClass("weaverTablePrevSltPage");
    	}
    } else {
        if (jQuery(obj).hasClass("weaverTableNextSltPage")) {
        	jQuery(obj).removeClass("weaverTableNextSltPage").addClass("weaverTableNextPage");
        } else {
        	jQuery(obj).removeClass("weaverTablePrevSltPage").addClass("weaverTablePrevPage");
        }
    }
}
//排序按钮
weaverTable.prototype.getOrderButton = function(x1){
	var ch = "";
	if(document.all){
		switch(x1){
			case "+":ch="5";break;
			case "-":ch="6";break;
		}
	}else{
		switch(x1){
			case "+":ch=">";break;
			case "-":ch="<";break;
		}
	}
	return ch;
}
//翻页按钮
weaverTable.prototype.getPageButton = function(x1,useable){
	var c = (useable?"class=\"xTable_pageua\"":"class=\"xTable_pageda\"");
	var ch = "";
	//if(readCookie("languageidweaver")==8){
		if(document.all){
			switch(x1){
				case 1:ch=SystemEnv.getHtmlNoteName(3444,readCookie("languageidweaver"));break;
				case 2:ch=SystemEnv.getHtmlNoteName(3445,readCookie("languageidweaver"));break;
				case 3:ch=SystemEnv.getHtmlNoteName(3446,readCookie("languageidweaver"));break;
				case 4:ch=SystemEnv.getHtmlNoteName(3447,readCookie("languageidweaver"));break;
			}
		}else{
			var alt = "";
			var gif = "";
			switch(x1){
				case 1:ch=SystemEnv.getHtmlNoteName(3444,readCookie("languageidweaver"));break;
				case 2:ch=SystemEnv.getHtmlNoteName(3445,readCookie("languageidweaver"));break;
				case 3:ch=SystemEnv.getHtmlNoteName(3446,readCookie("languageidweaver"));break;
				case 4:ch=SystemEnv.getHtmlNoteName(3447,readCookie("languageidweaver"));break;
			}
		}
	//}
	/*else if(readCookie("languageidweaver")==9) {
		if(document.all)
		{ 
			switch(x1)
			{ 
				case 1:ch="首頁";break; 
				case 2:ch="上一頁";break; 
				case 3:ch="下一頁";break; 
				case 4:ch="尾頁";break; 
			} 
		}
		else
		{ 
			var alt = ""; 
			var gif = ""; 
			switch(x1){ 
				case 1:ch="首頁";break; 
				case 2:ch="上一頁";break; 
				case 3:ch="下一頁";break; 
				case 4:ch="尾頁";break; 
			} 
		}
    } 
	else{
		if(document.all){
			switch(x1){
				case 1:ch="首页";break;
				case 2:ch="上一页";break;
				case 3:ch="下一页";break;
				case 4:ch="尾页";break;
			}
		}else{
			var alt = "";
			var gif = "";
			switch(x1){
				case 1:ch="首页";break;
				case 2:ch="上一页";break;
				case 3:ch="下一页";break;
				case 4:ch="尾页";break;
			}
		}
    }*/
	return str ="<span>"+ch+"</span>";
}


//显示加载信息
weaverTable.prototype.startLoad = function(){
	var message_table_Div  = document.getElementById("message_table_Div");
	//message_table_Div.style.display="inline";	
	jQuery(message_table_Div).css("display", "inline").html(SystemEnv.getHtmlNoteName(3403,readCookie("languageidweaver")));	
	/*if(readCookie("languageidweaver")==8)
    	jQuery(message_table_Div).html("Executing....");
    else if(readCookie("languageidweaver")==9)
    	jQuery(message_table_Div).html("服務器正在處理,請稍候....");
	else 
		jQuery(message_table_Div).html("服务器正在处理,请稍候....");
	*/
	var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
	var pLeft= document.body.offsetWidth/2-50;
	
//	message_table_Div.style.position="absolute"
//	message_table_Div.style.posTop=pTop;
//	message_table_Div.style.posLeft=pLeft;
	
	jQuery(message_table_Div).css("position", "absolute");
	jQuery(message_table_Div).css("top", pTop);
	jQuery(message_table_Div).css("left", pLeft);
}
//隐藏加载信息
weaverTable.prototype.loadOver = function(){
	var message_table_Div  = document.getElementById("message_table_Div");	 	
	//message_table_Div.style.display="none";	
	jQuery(message_table_Div).css("display", "none");	
}
//得到消息层的位置。
weaverTable.prototype.getPosition = function(element){
	var xy = new Array(2);
    	if ( arguments.length != 1 || element == null ) 
    	{ 
        	element = this.div;
    	} 
    	var offsetTop = element.offsetTop; 
    	var offsetLeft = element.offsetLeft; 
    	var offsetWidth = element.offsetWidth; 
    	var offsetHeight = element.offsetHeight; 
    	while( element = element.offsetParent ){ 
	        offsetTop += element.offsetTop; 
	        offsetLeft += element.offsetLeft; 
    	} 
    	offsetLeft += offsetWidth/2 - this.messageDiv.offsetWidth;
    	offsetTop += offsetHeight/2 - this.messageDiv.offsetHeight;
    	xy[0] = offsetLeft;
    	xy[1] = offsetTop;
    	return xy;
}

weaverTable.prototype.getAttendChar = function(str){
	return /\?/g.test(str)?"&":"?";
}
//排序
weaverTable.prototype.orderByCol = function(oid){
	if(this.orderValue!=null&&this.orderValue==oid.id){		
		if(this.orderType=="DESC"){			
			this.orderType = "ASC";
		}else{
			this.orderType = "DESC";
		}
	}else if(this.orderValue!=oid.id){
		this.orderType = "DESC";
	}
	this.orderValue = oid.id;
	this.reLoad();
}
//重新加载
weaverTable.prototype.reLoad = function(){
	jQuery(".hoverDiv").remove();
	this.startLoad();	
	this.load();
}

weaverTable.prototype.firstPage=function(){
	if(parseInt(this.nowPage)!=1){
		this.nowPage=0;
		this.reLoad();
	}
	if(window.frames["rightMenuIframe"]==undefined || window.frames["rightMenuIframe"]==null || window.frames["rightMenuIframe"].length==0){
		return;
	}
	/*var tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	if(tbodyIframe.cells != undefined) {   // 使用右键菜单
		for(var i = 0; i < tbodyIframe.cells.length; i++) {
			//var val = tbodyIframe.cells[i].outerHTML;
			var val = jQuery(tbodyIframe.cells[i]).html();
			if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = true;
			}
			if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = true;
			}
			if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = '';
			}
			if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = '';
			}
		}
	}else{// 不使用右键菜单
		for(var i = 0; i < tbodyIframe.children.length; i++) {
			//var val = tbodyIframe.children[i].outerHTML;
			var val = jQuery(tbodyIframe.children[i]).html();
			
			if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = true;
			}
			if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = true;
			}
			if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = '';
			}
			if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = '';
			}
		}
	}*/
}

weaverTable.prototype.prePage=function(){
	if(parseInt(this.nowPage)>1){
		this.nowPage--;
		this.reLoad();
	}
	this.pre();
}

weaverTable.prototype.nextPage=function(){
	if(parseInt(this.nowPage)<parseInt(this.pageNum)){
		this.nowPage++;
		this.reLoad();
	}
	this.next();
}


weaverTable.prototype.lastPage=function(){
	if(this.nowPage!=this.pageNum){
		this.nowPage=this.pageNum;
		this.reLoad();
	}
	
	if(window.frames["rightMenuIframe"]==undefined || window.frames["rightMenuIframe"]==null || window.frames["rightMenuIframe"].length==0){
		return;
	}
	
	/*var tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	if(tbodyIframe.cells != undefined) {    // 使用右键菜单
		for(var i = 0; i < tbodyIframe.cells.length; i++) {
			//var val = tbodyIframe.cells[i].outerHTML;
			var val = jQuery(tbodyIframe.cells[i]).html();
			if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = '';
			}
			if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = '';
			}
			if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = true;
			}
			if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = true;
			}
		}
	}else{// 不使用右键菜单
		for(var i = 0; i < tbodyIframe.children.length; i++) {
			//var val = tbodyIframe.children[i].outerHTML;
			var val = jQuery(tbodyIframe.children[i]).html();
			if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = '';
			}
			if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = '';
			}
			if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = true;
			}
			if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = true;
			}
		}
	}*/
}

weaverTable.prototype.goPage=function(a){
	 try{
   		var flag = e8beforeJump();
   		if(!flag)return;
   }catch(e){}	
	if(a>0&&a<=this.pageNum&&a!=this.nowPage){
		this.nowPage=a;
		this.reLoad();
	}
	this.pre();
	this.next();
}

weaverTable.prototype.focus_goPage = function (id){
	var btnGo = jQuery('#'+id+"-goPage");
	jQuery('#'+id).attr('hideFocus',true);
	//btnGo.show();
	btnGo.get(0).style.display="block";
	btnGo.css('left','0px');
	jQuery('#'+id+'_go_page_wrap').css('border-color','#6694E3');
	btnGo.animate({left: '+=30'}, 50,function(){
		//$('#go_page_wrap').css('width','88px');
	});
}


weaverTable.prototype.blur_goPage = function(id){
	setTimeout(function(){
		var btnGo = jQuery('#'+id+"-goPage");
		//$('#go_page_wrap').css('width','44px');
		btnGo.animate({
		    left: '-=44'
		  }, 100, function() {
			  jQuery('#'+id+"-goPage").css('left','0px');
			  jQuery('#'+id+"-goPage").hide();
			  jQuery('#'+id+'_go_page_wrap').css('border-color','#fff');
		  });
	},400);
}

weaverTable.prototype.createByName = function(n){
	return document.createElement(n);
}


//事件监听
XTableHandler = {
	idCounter : 0,
	idPrefix  : "-weaverTable-",
	all       : {},
	getId     : function() { return this.idPrefix + this.idCounter++; },
	firstPage : function (oItem) { this.all[oItem.id.replace('-first','')].firstPage(); },	
	prePage   : function (oItem) { this.all[oItem.id.replace('-pre','')].prePage(); },
	nextPage  : function (oItem) { this.all[oItem.id.replace('-next','')].nextPage(); },
	lastPage  : function (oItem) { this.all[oItem.id.replace('-last','')].lastPage(); },
	goPage	  :function(oItem,type){			
		//跳转到第几页
		
		var nid=oItem.id.replace('-goPage','');
		var goPage ;
		if(nid.indexOf("_XTABLE_GOPAGE_")==-1){
			if (type=="top"){
				goPage = document.getElementById(nid+"_XTABLE_GOPAGE_top");
			} else {
				goPage = document.getElementById(nid+"_XTABLE_GOPAGE_buttom");
			}
		}else{
			goPage = document.getElementById(nid);
		}
		nid = nid.replace("_XTABLE_GOPAGE_top","");
		nid = nid.replace("_XTABLE_GOPAGE_buttom","");			
		 if(goPage!=null){
		 	var goone = parseInt(jQuery(goPage).val());
		 	//检查是否越界
		 	if(goone>0&&goone<=this.all[nid].pageNum&&goone!=this.all[nid].nowPage){
		 		this.all[nid].goPage(goone);
			}else{
				//重新赋值
				goPage.value=this.all[nid].nowPage;
			}
		}
	},
	focus_goPage:function(oItem){
		jQuery(oItem).css("border","1px solid transparent");
		var nid=oItem.id.replace('_XTABLE_GOPAGE_top','').replace('_XTABLE_GOPAGE_buttom','');
		this.all[nid].focus_goPage(oItem.id);
	},
	blur_goPage:function(oItem){
		var nid=oItem.id.replace('_XTABLE_GOPAGE_top','').replace('_XTABLE_GOPAGE_buttom','');
		this.all[nid].blur_goPage(oItem.id);
	},
	jumpTo  : function(obj, a) {
	   var nid = jQuery(obj).attr("_jumpTo");
	   this.all[nid].goPage(a);
	}
}

/***********************************************************/

function creatErrorStr(status,statusText,responseText){
	var returnStr ="";
	responseText=responseText.replace(/(^\s*)|(\s*$)/g, "");	
	if(responseText=="NoData"){
		returnStr=SystemEnv.getHtmlNoteName(3448,readCookie("languageidweaver"));
	} else {
		 returnStr =""+	
		"<font size=2>"+SystemEnv.getHtmlNoteName(3589,readCookie("languageidweaver"))+"<br>"+
		SystemEnv.getHtmlNoteName(3590,readCookie("languageidweaver"))+":"+status+"<br>"+
		SystemEnv.getHtmlNoteName(3591,readCookie("languageidweaver"))+":"+statusText+"<br>"+
		SystemEnv.getHtmlNoteName(3592,readCookie("languageidweaver"))+":<a href=\"javaScript:isShowErrorDiv()\""+SystemEnv.getHtmlNoteName(3593,readCookie("languageidweaver"))+"</a><br></font><br>"+
		"<div id='showerrordiv' style=\"overflow:auto;height:300px;width:100%;display:none\">"+responseText+"</div>"+
		"<hr>"+
		"<font size=2>"+SystemEnv.getHtmlNoteName(3594,readCookie("languageidweaver"))+": <br>"+
		"</font>"+
		"<UL>"+
			"<li>"+SystemEnv.getHtmlNoteName(3595,readCookie("languageidweaver"))+"<a href=javascript:location.reload()>"+SystemEnv.getHtmlNoteName(3596,readCookie("languageidweaver"))+"</a>"+SystemEnv.getHtmlNoteName(3597,readCookie("languageidweaver"))+
			"<li>"+SystemEnv.getHtmlNoteName(3598,readCookie("languageidweaver"))+"<a  href='javascript:document.URL=\"http://\"+location.host;'>"+SystemEnv.getHtmlNoteName(3599,readCookie("languageidweaver"))+"</a>)"+
			"<li>"+SystemEnv.getHtmlNoteName(3600,readCookie("languageidweaver"))+				
		"</UL>";
	}
	
   return returnStr;
}
function isShowErrorDiv(){
//	if(document.getElementById('showerrordiv').style.display=='none'){
//		document.getElementById('showerrordiv').style.display='';
//	}else{
//		document.getElementById('showerrordiv').style.display='none';
//	}
	if(jQuery("#showerrordiv").css("display") == "none"){
		jQuery("#showerrordiv").css("display", "");
	}else{
		jQuery("#showerrordiv").css("display", "none");
	}
}


function  rowOnMouseOver(obj){
	//obj.parentElement.parentElement.className = "Selected"
	//jQuery(obj).parent().parent().attr("class", "Selected");
	jQuery(obj).closest("tr").attr("class", "Selected");
	//jQuery(obj).closest("tr").next("tr.Spacing").find("div").addClass("intervalHoverClass");
}

function  rowOnMouseOut(obj){
	//var p = obj.parentElement.parentElement;
	
	/*by bpf 2013-10-29
	var p = jQuery(obj).parent().parent()[0];
	if (p.rowIndex % 2==0)	{				
		//p.className = "DataLight"
		jQuery(p).attr("class", "DataLight");
	} else {
		//p.className = "DataDark"
		jQuery(p).attr("class", "DataDark");
	}
	*/
}
/***************checkbo radio*******************************/

function checkAllChkBox(btnChecked){
    var chkboxElems= document.getElementsByName("chkInTableTag")  
    var _allselectcheckboxs = document.getElementsByName("_allselectcheckbox")
    for (i=0;i<_allselectcheckboxs.length;i++){
    	var $span = jQuery(_allselectcheckboxs[i]).next('span');
        if (btnChecked) { 
            _allselectcheckboxs[i].checked = true ;
            if(!$span.hasClass('jNiceChecked')){
             	$span.addClass('jNiceChecked');
             }
        } else {
            _allselectcheckboxs[i].checked = false ;
            if($span.hasClass('jNiceChecked')){
            	$span.removeClass('jNiceChecked');
            }
        }
   }
    for (j=0;j<chkboxElems.length;j++){
    	var $span = jQuery(chkboxElems[j]).next('span');
        if (btnChecked) {
            chkboxElems[j].checked = true ;
            if(!$span.hasClass('jNiceChecked')){	
		    	$span.addClass('jNiceChecked');
		    }
        } else {       
            chkboxElems[j].checked = false ;
            if($span.hasClass('jNiceChecked')){
	        	$span.removeClass('jNiceChecked');
	        }
        }
        _xtalbe_chkCheck(chkboxElems[j]);   
    }
    
    
}
function _xtalbe_chkCheck(obj){
 if (obj.checked){
     if (!_xtable_checkedList.contains(jQuery(obj).attr("checkboxId"))){
         _xtable_checkedList.add(jQuery(obj).attr("checkboxId"));
         _xtalbe_checkedValueList.add(jQuery(obj).attr("value"));
     }
	 //rowOnMouseOver(obj);
 } else {
     if (_xtable_checkedList.contains(jQuery(obj).attr("checkboxId"))){
         var tempPos = _xtable_checkedList.indexOf(jQuery(obj).attr("checkboxId"));
         _xtable_checkedList.setElementAt(tempPos,null);
         _xtalbe_checkedValueList.setElementAt(tempPos,null);
     }   
	  rowOnMouseOut(obj);
 }
}
function checkAllThumbnailBox(btnChecked){
    var chkboxElems= document.getElementsByName("chkInTableTag")  
    var _allselectcheckboxs = document.getElementsByName("_allselectcheckbox")  
    for (i=0;i<_allselectcheckboxs.length;i++){
    	var $span = jQuery(_allselectcheckboxs[i]).next('span');
        if (btnChecked) {
        	if(!$span.hasClass('jNiceChecked')){	
		    	$span.addClass('jNiceChecked');
		    } 
            _allselectcheckboxs[i].checked = true ;
        } else {
            _allselectcheckboxs[i].checked = false ;
		    if($span.hasClass('jNiceChecked')){
            	$span.removeClass('jNiceChecked');
            }
        }
   }
    for (j=0;j<chkboxElems.length;j++){
    	var $span = jQuery(chkboxElems[j]).next('span'); 
        if (btnChecked) {
            chkboxElems[j].checked = true ;
             if(!$span.hasClass('jNiceChecked')){	
		    	$span.addClass('jNiceChecked');
		    }
        } else {       
            chkboxElems[j].checked = false ;
            if($span.hasClass('jNiceChecked')){
	        	$span.removeClass('jNiceChecked');
	        }
        }
        _xtalbe_chkCheckThumbnail(chkboxElems[j]);   
    }
}
function _xtalbe_chkCheckThumbnail(obj){ 

 if (obj.checked){

     if (!_xtable_checkedList.contains(jQuery(obj).attr("checkboxId"))){
         _xtable_checkedList.add(jQuery(obj).attr("checkboxId"));
         _xtalbe_checkedValueList.add(jQuery(obj).attr("value"));
     }
	 thumbnailSelected(obj)
 } else {
     if (_xtable_checkedList.contains(jQuery(obj).attr("checkboxId"))){
         var tempPos = _xtable_checkedList.indexOf(jQuery(obj).attr("checkboxId"));
         _xtable_checkedList.setElementAt(tempPos,null);
         _xtalbe_checkedValueList.setElementAt(tempPos,null);
     }
	 thumbnailUnSelected(obj)
 }
}
function thumbnailSelected(obj){
	/*while(obj.tagName!="TD"){obj = jQuery(obj).parent()[0];}
	//obj.style.backgroundColor = "aliceblue";
	jQuery(obj).css("background-color", "aliceblue");*/
	jQuery(obj).closest("td").children(".e8ThumbnailImg").addClass("e8ThumbnailImgHover");
	
}
function thumbnailUnSelected(obj){
	/*while(obj.tagName!="TD"){obj = jQuery(obj).parent()[0];}
	//obj.style.backgroundColor = "";
	jQuery(obj).css("background-color", "");*/
	jQuery(obj).closest("td").children(".e8ThumbnailImg").removeClass("e8ThumbnailImgHover");
}
//radio
function rdoCheck(obj){	
	if (obj.checked) {
		_xtalbe_radiocheckId =  jQuery(obj).attr("radioId");
		_xtalbe_radiocheckValue = jQuery(obj).val();
	} else {		
		rowOnMouseOut(obj);
	}
}


function openFullWindowForXtable(url,$this,options){
  var redirectUrl = url ;
  var width = screen.availWidth ;
  var height = screen.availHeight ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "";
  if(!!options && !!options.cusWidth){
  	if(options.cusWidth<=1){
  		options.cusWidth = options.cusWidth*screen.width;
  	}
  	szFeatures ="left="+(screen.width - options.cusWidth) / 2+"," ;
  	szFeatures +="width="+options.cusWidth+"," ;
  }else{
  	//szFeatures ="left="+(screen.width - width*2/3-50) / 2+"," ;
  	//szFeatures +="width="+width*2/3+"," ;
	szFeatures ="left=0," ;
  	szFeatures +="width="+(width-10)+"," ;
  }
  if(!!options && !!options.cusHeight){
  	if(options.cusHeight<=1){
  		options.cusHeight = options.cusHeight*screen.height;
  	}
  	szFeatures += "top="+(screen.height - options.cusHeight) / 2+"," ; 
	szFeatures +="height="+options.cusHeight+"," ; 
  }else{
  	//szFeatures += "top="+(screen.height - height*2/3-50) / 2+"," ; 
	//szFeatures +="height="+height*2/3+"," ; 
	szFeatures += "top=0," ; 
	szFeatures +="height="+(height-60)+"," ;
  }
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}
/*******************以下是功能函数***************************/
//得到checked　ids
 function _xtable_CheckedCheckboxId(){
 var strSelected = "";
 for (i=0;i<_xtable_checkedList.size();i++)  {
     if  (_xtable_checkedList.get(i)==null) continue;
     strSelected += _xtable_checkedList.get(i)+",";
 }
 return strSelected;
}

 function _xtable_CheckedCheckboxIdForCP(){
 var strSelected = "";
 var checkboxs = jQuery("#_xTable").find("table.ListStyle tbody").find("input[type='checkbox'][name='chkInTableTag']:checked");
 checkboxs.each(function(){
 	 strSelected += jQuery(this).attr("checkboxid")+",";
 });
 return strSelected;
}

//得到unchecked　ids
function _xtable_unCheckedCheckboxId(){
	var strSelected = "";
	var checkboxs = jQuery("#_xTable").find("table.ListStyle tbody").find("input[type='checkbox'][name='chkInTableTag']").not(":checked");
	 checkboxs.each(function(){
	 	 strSelected += jQuery(this).attr("checkboxid")+",";
	 });
	 return strSelected;
}

//得到checked values
function  _xtable_CheckedCheckboxValue(){
     var strSelected = "";
     for (i=0;i<_xtalbe_checkedValueList.size();i++)  {
         if  (_xtalbe_checkedValueList.get(i)==null) continue;
         strSelected += _xtalbe_checkedValueList.get(i)+",";
     }
	 return strSelected;    
}
function  _xtable_CheckedCheckboxValueForCP(){
     var strSelected = "";
      var checkboxs = jQuery("#_xTable").find("table.ListStyle tbody").find("input[type='checkbox'][name='chkInTableTag']:checked");
	 checkboxs.each(function(){
	 	 strSelected += jQuery(this).attr("value")+",";
	 });
 return strSelected;    
}

//得到unchecked values
function  _xtable_unCheckedCheckboxValue(){
     var strSelected = "";
      var checkboxs = jQuery("#_xTable").find("table.ListStyle tbody").find("input[type='checkbox'][name='chkInTableTag']").not(":checked");
	 checkboxs.each(function(){
	 	 strSelected += jQuery(this).attr("value")+",";
	 });
 return strSelected;    
}

//清空checked
function _xtable_CleanCheckedCheckbox(){
	while(!_xtable_checkedList.isEmpty()){
    	_xtable_checkedList.remove();
    }
    while(!_xtalbe_checkedValueList.isEmpty()){
    	_xtalbe_checkedValueList.remove();
    }
    checkAllChkBox(false);
    $GetEle("_allselectcheckbox").checked=false;
}

//得到 radio　id
function _xtable_CheckedRadioId(){
    return _xtalbe_radiocheckId
}

//得到 radio　value
function _xtable_CheckedRadioValue(){
    return  _xtalbe_radiocheckValue;
}

//清空 radio　id
function _xtable_CleanCheckedRadio(){
    document.getElementById(_xtalbe_radiocheckId).checked=false;
    _xtalbe_radiocheckId =""; 
    _xtalbe_radiocheckValue = "";
}
 
 //得到当前页的excel
function _xtable_getExcel(){ 	
	window.location='/weaver/weaver.common.util.taglib.CreateExcelServer'
}


 //得到全部的excel
function _xtable_getAllExcel(from,objpara2){ 
	var tmpurl='/weaver/weaver.common.util.taglib.CreateExcelServer?showOrder=all';
	if(from&&from.length){
		tmpurl+="&from="+from;
	}
	if(objpara2){
		for(var s in objpara2){
			if(typeof(objpara2[s])=="function"){  
				objpara2[s]();  
			}else{  
				tmpurl+="&"+s+"="+objpara2[s];  
	        }
		}
	}
    window.location=tmpurl;
}

//
weaverTable.prototype.mouseMove = function(re){}
weaverTable.prototype.mouseUp = function(re){}
weaverTable.prototype.mouseDown = function(re){}

weaverTable.prototype.pre=function(){
	if(window.frames["rightMenuIframe"]==undefined || window.frames["rightMenuIframe"]==null || window.frames["rightMenuIframe"].length==0){
		return;
	}
	/*var tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	if(tbodyIframe.cells != undefined) {    // 使用右键菜单
		if(parseInt(this.nowPage)==1){			
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
			}
		}
		
		if(parseInt(this.nowPage)<parseInt(this.pageNum)){
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = '';
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = '';
				}
			}
		}
	}else{// 不使用右键菜单
		if(parseInt(this.nowPage)==1){			
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
			}
		}
		
		if(parseInt(this.nowPage)<parseInt(this.pageNum)){
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = '';
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = '';
				}
			}
		}
	}*/
}
weaverTable.prototype.next=function(){
	if(window.frames["rightMenuIframe"]==undefined || window.frames["rightMenuIframe"]==null || window.frames["rightMenuIframe"].length==0){
		return;
	}
	/*var tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	if(tbodyIframe.cells != undefined) {    // 使用右键菜单
		if(parseInt(this.nowPage)>=parseInt(this.pageNum)){
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
			}
		}
		if(parseInt(this.nowPage)>1){	
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = '';
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = '';
				}
			}	
		}
	}else{// 不使用右键菜单
		if(parseInt(this.nowPage)>=parseInt(this.pageNum)){
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
			}
		}
		if(parseInt(this.nowPage)>1){	
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = '';
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = '';
				}
			}	
		}
	}*/
}
function removeHTMLTag(str) {
    str = str.replace(/<\/?[^>]*>/g,''); //去除HTML tag
    str = str.replace(/[ | ]*\n/g,'\n'); //去除行尾空白
    //str = str.replace(/\n[\s| | ]*\r/g,'\n'); //去除多余空行
    str=str.replace(/&nbsp;/ig,'');//去掉&nbsp;
    str = str.replace(/&gt;/ig,">");
    str = str.replace(/&lt;/ig,"<");
	str = str.replace(/&quot;/ig,"\"");
    return str;
}

//add by bpf 2013-10-30 start
  /*jQuery(".operHoverSpan").on('mouseenter', function() {
      jQuery(this).addClass("operHoverSpan_hover");
  }).on('mouseleave', function() {
      jQuery(this).removeClass("operHoverSpan_hover");
  });*/
  jQuery(".table").delegate("operHover_hand","click",function(){
  	jQuery(this).find("a").click();
  });
 //add by bpf 2013-10-30 end
 
 
 
//add by bpf 2013-11-05 start
(function (jQuery) {
	jQuery.fn.addEditPlugin = function (options,canedit, isformmode) {
		var cell=jQuery(this);
		cell.css("vertical-align","middle");
		var celValue=options.celValue;
		var editPlugin=options.editPlugin;
		var rowIndex=options.rowIndex;
		if(editPlugin!=null && editPlugin!=undefined){
			var tempEditPlugin=window[editPlugin];
			if(tempEditPlugin==null || tempEditPlugin==undefined ){
				tempEditPlugin=editPlugin;
			}
			
			var type=tempEditPlugin.type;
			var name=tempEditPlugin.name;
			if(celValue == null || celValue==undefined ){
				celValue=tempEditPlugin.defaultValue;
			}
			if(celValue == null || celValue==undefined ){
				celValue="";
			}
			if(type==null || type==undefined){
				type="input";
			}
			if(type=="hidden"){
				var input=jQuery("<input type='hidden' value=''/>");
				if(rowIndex!=null){
					if(!!name && name.match(/#rowIndex#/)){
						name = name.replace(/#rowIndex#/,rowIndex);
					}else if(tempEditPlugin.addIndex==false){
						
					}else{
						name = name+"_"+rowIndex;
					}
				}
				input.css("width","90%");
				input.val(celValue);
				input.attr("name",name);
				cell.append(input);
		        cell.hide();		
				input.keyup(function(){
					jQuery(this).validateVal();
				});
			}else if(type=="input"){
				if(canedit=="false"){
					cell.html(celValue);
				}else{
					var input=jQuery("<input class='inputStyle' type='text' value=''/>");
					if(rowIndex!=null){
						if(!!name && name.match(/#rowIndex#/)){
							name = name.replace(/#rowIndex#/,rowIndex);
						}else if(tempEditPlugin.addIndex==false){
						}else{
							name = name+"_"+rowIndex;
						}
					}
					input.css("width","90%");
					input.val(celValue);
					input.attr("name",name);
					cell.append(input);
					
					input.keyup(function(){
						jQuery(this).validateVal();
					});
				}
				
			}else if(type=="password"){
				if(canedit=="false"){
					cell.html(celValue);
				}else{
					var input=jQuery("<input type='password' value=''/>");
					if(rowIndex!=null){
						if(!!name && name.match(/#rowIndex#/)){
							name = name.replace(/#rowIndex#/,rowIndex);
						}else if(tempEditPlugin.addIndex==false){
						}else{
							name = name+"_"+rowIndex;
						}
					}
					input.css("width","90%");
					input.val(celValue);
					input.attr("name",name);
					cell.append(input);
					
					input.keyup(function(){
						jQuery(this).validateVal();
					});
				}
				
			}else if(type=="select"){
				var select=jQuery("<select></select>");
				if(canedit=="false"){
					select.attr("disabled",true);
				}
				//select.css("width","90%");
				var options=tempEditPlugin.options;
				jQuery.each(options,function(){
					select.append("<option value='"+this.value+"'>"+this.text+"</option>");
				});
				if(rowIndex!=null){
					if(!!name && name.match(/#rowIndex#/)){
						name = name.replace(/#rowIndex#/,rowIndex);
					}else if(tempEditPlugin.addIndex==false){
					}else{
						name = name+"_"+rowIndex;
					}
				}
				
				select.val(celValue);
				select.attr("name",name);
				cell.append(select);
				
				select.change(function(){
					jQuery(this).validateVal();
				});
			}else if(type=="browser"){
				var browserOptions=tempEditPlugin.attr;
				if(!browserOptions.nameBak){
					browserOptions.nameBak = browserOptions.name;
				}else{
					browserOptions.name = browserOptions.nameBak;
				}
				if(!browserOptions.browserOnClickBak){
					browserOptions.browserOnClickBak = browserOptions.browserOnClick;
				}else{
					browserOptions.browserOnClick = browserOptions.browserOnClickBak;
				}
				if(rowIndex!=null){
					if(!!browserOptions.name && browserOptions.name.match(/#rowIndex#/)){
						browserOptions.name = browserOptions.name.replace(/#rowIndex#/g,rowIndex);
					}else if(tempEditPlugin.addIndex==false){
					
					}else{
						browserOptions.name=browserOptions.name+"_"+rowIndex;
					}
					
					if(!!browserOptions.browserOnClick && browserOptions.browserOnClick.match(/#rowIndex#/)){
						browserOptions.browserOnClick = browserOptions.browserOnClick.replace(/#rowIndex#/g,rowIndex);
					}
				}
				
				var browserKeyValues=jQuery.parseJSON(celValue);
				if(jQuery.isArray(browserKeyValues)){
					var browserValues=[];
					var browserSpanValues=[];
					jQuery.each(browserKeyValues,function(i,browserKeyValue){
						browserValues.push(browserKeyValue.browserValue);
						browserSpanValues.push(browserKeyValue.browserSpanValue);
					});
					browserOptions.browserValue=browserValues.join(",");
					browserOptions.browserSpanValue=browserSpanValues.join("__");
				}else{
					browserOptions.browserValue = "";
					browserOptions.browserSpanValue = "";
				}
				if(canedit=="false"){
					try{
						browserOptions["isMustInput"] = "0";
					}catch(e){
						if(window.console){
							console.log(e);
						}
					}
				}
				var js=cell.e8Browser(browserOptions);
				options.delayedFunctions.push(js);
				jQuery(cell).attr("_notitle",true);
			}else if(type=="checkbox"){
				var options=tempEditPlugin.options;
				if(options==null || options==undefined ){
					var checkbox=jQuery("<input type='checkbox' />");
					checkbox.val(celValue);
					checkbox.attr("name",name);
					if(canedit=="false"){
						checkbox.attr("readonly",true);
					}
					cell.append(checkbox);
				}else{
					jQuery.each(options,function(i,option){
						if(option){
							var name = option.name;
							if(rowIndex!=null && !!name){
								if(name.match(/#rowIndex#/)){
									name = name.replace(/#rowIndex#/,rowIndex);
								}else if(tempEditPlugin.addIndex==false){
								}else{
									name = name+"_"+rowIndex;
								}
							}
							var checkbox = jQuery("<input type='checkbox' />")
							checkbox.val(option.value);
							checkbox.attr("name",name);
							if(canedit=="false"){
								checkbox.attr("readonly",true);
							}
							cell.append(checkbox);
							cell.append(option.text);
							//cell.append("&nbsp;&nbsp;");
						}
					});
				}
				
				if(celValue!=null && celValue!=undefined && celValue!=""){
					var checkedValues=celValue.split(",");
					jQuery.each(checkedValues,function(i,checkedValue){
						cell.find("[value='"+checkedValue+"']").attr("checked","true");
					});
				}
				cell.find("[type='checkbox']").click(function(){
					jQuery(this).validateVal();
				});
				jQuery(cell).attr("_notitle",true);
				
			}else if(type=="radio"){
				var options=tempEditPlugin.options;
				jQuery.each(options,function(i,option){
					if(rowIndex!=null){
						if(!!name && name.match(/#rowIndex#/)){
							name = name.replace(/#rowIndex#/,rowIndex);
						}else if(tempEditPlugin.addIndex==false){
						}else{
								name = name+"_"+rowIndex;
						}
					}
					var radio = jQuery("<input type='radio' />");
					radio.val(option.value);
					radio.attr("name",name);
					if(canedit=="false"){
							radio.attr("readonly",true);
						}
					cell.append(radio);
					cell.append(option.text);
					cell.append("&nbsp;&nbsp;");
				});
				
				if(celValue!=null && celValue!=undefined){
					cell.find("[value='"+celValue+"']").attr("checked","true");
				}
				
				cell.find("[type='radio']").click(function(){
					jQuery(this).validateVal();
				});
				jQuery(cell).attr("_notitle",true);
			}
			var mustSpan=jQuery("<span><img class='notNullImg' align='absmiddle' src='/images/BacoError_wev8.gif'></span>");
			var notNull=tempEditPlugin.notNull;
			if(notNull==true){
				cell.append(mustSpan);
				if(celValue==undefined || celValue=="" || celValue==null){
				
				}else{
					mustSpan.find("img").hide();
				}
			}
			cell.find("[name]").e8bindFn(tempEditPlugin.bind);
		}else{
			if(celValue == null || celValue==undefined ){
				celValue="&nbsp;";
			}
			if(isformmode) {
				
			} else {
				celValue=celValue.replace(new RegExp("<br>","gm"), "&nbsp;");
			}
			
			if(jQuery.trim(celValue)==""){
				celValue="&nbsp;";
			}
			cell.html(celValue);
		}
	};
	
	//添加新行
	jQuery.fn.addNewRow = function (options) {
		var table=jQuery(this);
		table.find("tr.e8EmptyTR").remove();
		var editPlugins=table.data("editPlugins");
		var tr=jQuery("<tr></tr>");
		
		var delayedFunctions=[];
		
		jQuery.each(editPlugins,function(i,editPlugin){
			var td=jQuery("<td></td>");
			var tableMax=jQuery("form [name='tableMax']");
			if(tableMax.size()==0){
				tableMax=0;
			}else{
				tableMax=parseInt(tableMax.val());
			}
			
			td.addEditPlugin({editPlugin:editPlugin,rowIndex:tableMax,delayedFunctions:delayedFunctions});
			tr.append(td);
		});
		
		
		table.children("tbody tr.Spacing:last").children("td").attr("class","paddingLeft0Table");
		
		table.append(tr);
		var trSpacing = jQuery("<tr class='Spacing' style='height:1px!important;'></tr>")
		var tdSpacing = jQuery("<td></td>");
		var divSpacing = jQuery("<div class='intervalDivClass'></div>");
		tdSpacing.append(divSpacing);
		tdSpacing.attr("colspan",tr.children("td").length);
		trSpacing.append(tdSpacing);
		tdSpacing.addClass("paddingLeft0Table");
		
		table.append(trSpacing);
		
		table.addTableMax();
		jQuery("body").append(delayedFunctions.join(" "));
		try{
			//resetDivPosition("pageSizeSel0",jQuery("#pageSizeSel0"),true);
			//resetDivPosition("pageSizeSel1",jQuery("#pageSizeSel1"),true);
		}catch(e){
		}
	};
	
	//删除表格中被选中的行
	jQuery.fn.deleteSelectedRow = function (options) {
		var table=jQuery(this);
		var selectedTrs=table.find("tr:has([name='chkInTableTag']:checked)");
		if(selectedTrs.size()==0){
			window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3529,readCookie("languageidweaver")));
			return;
		}
		window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(3580,readCookie("languageidweaver")),function(){
			selectedTrs.each(function(){
				jQuery(this).next("tr.Spacing").remove();
				jQuery(this).remove();
				table.children("tbody tr.Spacing:last").children("td").attr("class","paddingLeft0Table");
			});
			
			try{
				//resetDivPosition("pageSizeSel0",jQuery("#pageSizeSel0"),true);
				//resetDivPosition("pageSizeSel1",jQuery("#pageSizeSel1"),true);
			}catch(e){
			}
		});
	};
	
	
	jQuery.fn.validateVal = function (options) {
		var changedElement=jQuery(this);
		var name=changedElement.attr("name");
		var isNull=true;
		if(changedElement.is("select") || changedElement.is(":text") || changedElement.is(":password")){
			isNull=(jQuery.trim(changedElement.val())=="");
		}
		if(changedElement.is(":checkbox") || changedElement.is(":radio")){
			isNull=changedElement.parent().find(":checked").size()==0;
		}
		if(isNull){
			changedElement.parent().find(".notNullImg").show();
		}else{
			changedElement.parent().find(".notNullImg").hide();
		}
	};
	
	//验证
	jQuery.fn.validateTable = function (options) {
		var table=jQuery(this);//notNullImg
		return table.find(".notNullImg:visible").size()==0;
	};
	
	jQuery.fn.addTableMax = function () {
//		var table=jQuery(this);
		var tableMax=jQuery("form [name='tableMax']");
		if(tableMax.size()==0){
			jQuery("form").append("<input type='hidden' name='tableMax' value='0'/>");
		}
		tableMax=jQuery("form [name='tableMax']");
		var newaddTableMax=parseInt(tableMax.val())+1;
		tableMax.val(newaddTableMax);
		return newaddTableMax;
	};
	
	jQuery.fn.resetTableMax = function () {
//		var table=jQuery(this);
		var tableMax=jQuery("form [name='tableMax']");
		if(tableMax.size()==0){
			try{
				jQuery("form").append("<input type='hidden' name='tableMax' value='0'/>");
			}catch(e){
				if(window.console){
					console.log(e+"--->weaverTable_wev8.js resetTableMax");
				}
			}
		}
		tableMax=jQuery("form [name='tableMax']");
		var newaddTableMax=0;
		tableMax.val(newaddTableMax);
		return newaddTableMax;
	};
	
	//为每一行中的可编辑元素添加绑定事件
	jQuery.fn.e8bindFn = function (bind) {
		if(bind==null || bind==undefined){
			return;
		}
		var node=this;
		jQuery.each(bind,function(i,bindFn){
			node.bind(bindFn.type,bindFn.fn);
		});
	};
	
	//add by bpf on 2013-11-14获取鼠标悬停所在的行对象
	jQuery.getSelectedRow = function () {
		return jQuery(".ListStyle .Selected").get(0);
	};
})(jQuery);
//add by bpf 2013-11-05 end
 
 
 function hideTH(){
 	var cols = jQuery("div#_xTable").find("colgroup col");
 	jQuery("div#_xTable").find("thead tr.HeaderForXtalbe th").each(function(){
 		//console.log(parseInt(jQuery(this).css("width").replace(/[ |px]/g,"")));
 		var $this = jQuery(this);
		if(!$this.css("width")||parseInt($this.css("width").replace(/[ |px]/g,""))<=0){
			$this.hide();
			var _itemid = $this.attr("_itemid");
			if(_itemid){
				var idx = parseInt(_itemid)-1;
				if(idx>0)
					cols.eq(parseInt(_itemid)-1).hide();
			}
		}
	});
 }
 
 //保存每页显示的记录数
 function savePageSize(e,obj,pageId,save){
 	var event = e||window.event;
 	var pageSize = parseInt(jQuery(obj).val());
 	var minPageSize = 1;
 	var defaultPageSize = 10;
 	var maxPageSize = 100;
 	if((event.type.toLowerCase()=="keyup"&&event.keyCode==13) || !!save){
 		if(pageSize!=0 && pageSize<minPageSize){
 			jQuery(obj).val(minPageSize);
 			//window.top.Dialog.alert("每页记录数必须不小于"+minPageSize+"条！");
 			return;
 		}/*else{
 			if(pageSize!=0&&pageSize>maxPageSize){
 				jQuery(obj).val(maxPageSize);
	 			window.top.Dialog.alert("每页记录数必须不大于"+maxPageSize+"条！");
	 			return;
 			}
 		}*/
 		if(!!pageId){
 			 try{
		   		var flag = e8beforeJump();
		   		if(!flag)return;
		   }catch(e){}	
	 		jQuery.ajax({
	 			url:"/weaver/weaver.common.util.taglib.ShowColServlet?src=savePageSize&timestap="+new Date().getTime(),
	 			type:"get",
	 			dataType:"json",
	 			data:{
	 				pageSize:pageSize,
	 				pageId:pageId
	 			},
	 			success:function(data){
	 				if(data.result==0){
	 					window.top.Dialog.alert(data.msg);
	 				}else{
	 					try{
	 						reloadPage();
	 					}catch(e){
	 						if(jQuery("span#searchblockspan",parent.document).find("img:first").length>0){
	 							jQuery("span#searchblockspan",parent.document).find("img:first").click();
	 						}else{
	 							window.location.reload();
							}
	 					}
	 				}
	 			},
	 			failure:function(xhr,status,e){
	 				window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3601,readCookie("languageidweaver")));
	 			}
	 		});
 		}else{
 			window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3602,readCookie("languageidweaver")));
 			return;
 		}
 	}else if(event.type.toLowerCase()=="keyup"){
 		if(pageSize<0){
 			jQuery(obj).val(defaultPageSize);
 		}
 	}
 }
 
 function weaverTable_checkInput(e){
 	var evt = e||window.event;
 	if((evt.keyCode<48&&evt.keyCode!=8&&evt.keyCode!=13&&evt.keyCode!=0) || evt.keyCode>57){return false;}
 	return true;
 }
 

