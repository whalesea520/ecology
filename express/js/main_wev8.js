
require(["jquery","/express/js/jquery.fuzzyquery.min_wev8.js"], function($) {
    //the jquery.alpha_wev8.js and jquery.beta_wev8.js plugins have been loaded.
	
	var firstchar='';
    var secondchar='';
    $(function() {
    
	function doInput(e){
		//alert(3);
			/*
			c =document.body.innerHTML.substring(document.body.innerHTML.length-6)
			if("<br />"==c){
				c=document.body.innerHTML.substring(document.body.innerHTML.length-7,document.body.innerHTML.length-6)
			}else{
				c=document.body.innerHTML.substring(document.body.innerHTML.length-2)
			}
			*/
			//c=document.body.innerHTML.substring(document.body.innerHTML.length-2)
			//alert(c)
			//if(c=="@"){
			if(true){
				var obj = document.createElement('input');  
				
				obj.id = 'test_id';
				obj.autofocus = true;
				
				var inputstr="<input type='text' id='test_id'>";
				//obj.focus();
			
						
							//var cursor=getCursorPos(document);
							
							//document.body.innerHTML=
							//document.body.appendChild(obj);
							var range=window.parent.KE.util._getRng(document);
							if(window.parent.KE.browser.IE){
								range.pasteHTML(inputstr);
							}else{
								//document.body.appendChild(obj);
								var frag = range.createContextualFragment(inputstr);
								range.insertNode(frag);
							}	
						
							window.setTimeout("document.getElementById('test_id').focus();", 50)  ;

							
							//document.body.contentEditable ='false';
							//document.designMode ='off' ;

							//联想输入框事件绑定 *****IE****
						
							$(document.getElementById("test_id")).bind("propertychange",function(){
								alert(1);
										$(this).FuzzyQuery({
											url:"/express/task/data/GetData.jsp",
											record_num:5,
											filed_name:"name",
										    divwidth:'100',
											updatetype:"str",
											updatename:$(this).attr("id"),
											intervalTop:4,
											result:function(data,updatename,updatetype){
												
												
												//alert($("#fuzzyquery_query_div").html())
												//alert($(".fuzzyquery_main_div").length)
												//$(".fuzzyquery_main_div").remove();
												$("#"+updatename).remove();
												$("#fuzzyquery_query_div").remove();
												if(window.parent.KE.browser.IE){
													range.pasteHTML(inputstr);
												}else
													document.body.innerHTML = document.body.innerHTML.substring(0,document.body.innerHTML.length-1)+"<a href='/hrm/resource/HrmResource.jsp?id="+data["id"]+"' ondblclick='return false;' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px;'>"+data["name"]+"</a>";
										
												document.body.contentEditable ='true';
												document.designMode ='on' ;
												$(document.body).focus();
											  //selectUpdate(updatename,data["id"],data["name"],updatetype);
											  
											}
										});
									
									//document.onkeydown=keyListener2;
								}).bind("blur",function(e){
										$(this).remove();
								});

								//联想输入框事件绑定 *****非IE****
								
								$(document.getElementById("test_id")).bind("input",function(e){
									//alert(2);
										$(this).FuzzyQuery({
											url:"/express/task/data/GetData.jsp",
											record_num:5,
											filed_name:"name",
										    divwidth:'100',
											updatetype:"str",
											updatename:$(this).attr("id"),
											intervalTop:4,
											result:function(data,updatename,updatetype){
												//document.body.contentEditable ='true';
												//document.designMode ='on' ;
												$("#fuzzyquery_query_div").remove();
												//alert($(".fuzzyquery_main_div").length)
												//$(".fuzzyquery_main_div").remove();
												$("#"+updatename).remove();
												//alert(document.body.innerHTML);
												var html="<a href='/hrm/resource/HrmResource.jsp?id="+data["id"]+"' ondblclick='return false;' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px;'>"+data["name"]+"</a>";
												if(window.parent.KE.browser.IE){
													range.pasteHTML("<a href='/hrm/resource/HrmResource.jsp?id="+data["id"]+"' ondblclick='return false;' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px;'>"+data["name"]+"</a>");
												}else{
													//document.body.innerHTML = document.body.innerHTML.substring(0,document.body.innerHTML.length-2)+"<a href='/hrm/resource/HrmResource.jsp?id="+data["id"]+"' ondblclick='return false;' unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px;'>"+data["name"]+"</a>";
													var frag = range.createContextualFragment(html);
													range.insertNode(frag);
												}
												$(document.body).focus();
											  //selectUpdate(updatename,data["id"],data["name"],updatetype);
											  
											}
										});
									
									//document.onkeydown=keyListener2;
								}).bind("blur",function(e){
									// $(this).remove();
									//if($(this).attr("id")=="tag" && $(this).val()!=""){
									//	selectUpdate("tag",$(this).val(),$(this).val(),"str");
									//}
									//$(this).val("");
									//$(this).hide();
									//$(this).nextAll("div.btn_add").show();
									//$(this).nextAll("div.btn_browser").show();
									//$(this).prevAll("div.showcon").show();
									//document.onkeydown=null;
								});

			}
			//lastcahr = c
		}
		
		getCursorPos = function(doc) {
			this.sel = null;
			this.range = null;
			this.keRange = null;
			this.isControl = false;
			var win = doc.parentWindow || doc.defaultView;
			var startNode, startPos, endNode, endPos;
			this.init = function() {
				var sel = win.getSelection ? win.getSelection() : doc.selection;
				var range;
				try {
					
					range=window.parent.KE.util._getRng(doc);
					//alert(range);
				} catch(e) {   
				    alert(e);
				}
				if (!range) range = window.parent.KE.util.createRange(doc);
				this.sel = sel;
				this.range = range;
				if (window.parent.KE.browser.IE) {
					if (range.item) {
						this.isControl = true;
						var el = range.item(0);
						startNode = endNode = el;
						startPos = endPos = 0;
					} else {
						this.isControl = false;
						var getStartEnd = function(isStart) {
							var pointRange = range.duplicate();
							pointRange.collapse(isStart);
							var parentNode = pointRange.parentElement();
							var nodes = parentNode.childNodes;
							if (nodes.length == 0) return {node: parentNode, pos: 0};
							var startNode;
							var endElement;
							var startPos = 0;
							var isEnd = false;
							var testRange = range.duplicate();
							window.parent.KE.util.moveToElementText(testRange, parentNode);
							for (var i = 0, len = nodes.length; i < len; i++) {
								var node = nodes[i];
								var cmp = testRange.compareEndPoints('StartToStart', pointRange);
								if (cmp > 0) {
									isEnd = true;
								} else if (cmp == 0) {
									if (node.nodeType == 1) {
										var keRange = new window.parent.KE.range(doc);
										keRange.selectTextNode(node);
										return {node: keRange.startNode, pos: 0};
									} else {
										return {node: node, pos: 0};
									}
								}
								if (node.nodeType == 1) {
									var nodeRange = range.duplicate();
									window.parent.KE.util.moveToElementText(nodeRange, node);
									testRange.setEndPoint('StartToEnd', nodeRange);
									if (isEnd) startPos += nodeRange.text.replace(/\r\n|\n|\r/g, '').length;
									else startPos = 0;
								} else if (node.nodeType == 3) {
									//fix bug: typeof node.nodeValue can return "unknown" in IE.
									if (typeof node.nodeValue === 'string') {
										testRange.moveStart('character', node.nodeValue.length);
										startPos += node.nodeValue.length;
									}
								}
								if (!isEnd) startNode = node;
							}
							if (!isEnd && startNode.nodeType == 1) {
								var startNode = parentNode.lastChild;
								return {node: startNode, pos: startNode.nodeType == 1 ? 1 : startNode.nodeValue.length};
							}
							testRange = range.duplicate();
							window.parent.KE.util.moveToElementText(testRange, parentNode);
							testRange.setEndPoint('StartToEnd', pointRange);
							startPos -= testRange.text.replace(/\r\n|\n|\r/g, '').length;
							return {node: startNode, pos: startPos};
						};
						var start = getStartEnd(true);
						var end = getStartEnd(false);
						startNode = start.node;
						startPos = start.pos;
						endNode = end.node;
						endPos = end.pos;
					}
				} else {
					startNode = range.startContainer;
					startPos = range.startOffset;
					endNode = range.endContainer;
					endPos = range.endOffset;
					if (startNode.nodeType == 1 && typeof startNode.childNodes[startPos] != 'undefined') {
						startNode = startNode.childNodes[startPos];
						startPos = 0;
					}
					if (endNode.nodeType == 1) {
						endPos = endPos == 0 ? 1 : endPos;
						if (typeof endNode.childNodes[endPos - 1] != 'undefined') {
							endNode = endNode.childNodes[endPos - 1];
							endPos = (endNode.nodeType == 1) ? 0 : endNode.nodeValue.length;
						}
					}
					this.isControl = (startNode.nodeType == 1 && startNode === endNode && range.startOffset + 1 == range.endOffset);
					if (startNode.nodeType == 1 && endNode.nodeType == 3 && endPos == 0 && endNode.previousSibling) {
						var node = endNode.previousSibling;
						while (node) {
							if (node === startNode) {
								endNode = startNode;
								break;
							}
							if (node.childNodes.length != 1) break;
							node = node.childNodes[0];
						}
					}
					if (range.collapsed) {
						var keRange = new window.parent.KE.range(doc);
						keRange.setTextStart(startNode, startPos);
						endNode = keRange.startNode;
						endPos = keRange.startPos;
					}
				}
				var keRange = new window.parent.KE.range(doc);
				//alert(startPos);
				keRange.setTextStart(startNode, startPos);
				keRange.setTextEnd(endNode, endPos);
				this.keRange = keRange;
			};
			this.init();
			return startPos;
	};
		
		
          var selectionchange = function() {
          	
                //var range = document.selection.createRange();  
          		var cursor=0;
          	    if(!document.selection) {
          	    	var range = window.parent.KE.util._getRng(document);
		            var startPos = range.startOffset;
		            var srcele=document.body;
		            
		            cursor=startPos;
		            if(srcele.innerHTML.length>=2)
	                	return srcele.innerHTML.substring(cursor - 2, cursor);
	                else
	                	return "";
        		}else{
	          		var range = window.parent.KE.util._getRng(document);
	                var srcele = range.parentElement();  
	          		//var srcele = range.startContainer.parentNode();
	               	var copy = document.body.createTextRange();  
	               	copy.moveToElementText(srcele);  
	  
	                for (cursor = 0; copy.compareEndPoints("StartToStart", range) < 0; cursor++) {  
	                    copy.moveStart("character", 1);  
	                }  
	                //alert(cursor);
	                if(srcele.innerText.length>=2)
	                	return srcele.innerText.substring(cursor - 2, cursor);
	                else
	                	return "";
        		}
             
          	//alert(1111);
          	//window.parent.window.KE.selection(document);
          	//alert(getCursorPos(document));
          	/*
          	var cursor=getCursorPos(document);
          	var htmlstr="";
          	
          	if(window.parent.KE.browser.IE){
	          	var range = document.selection.createRange();  
	            var srcele = range.parentElement();  
	            var copy = document.body.createTextRange();  
	            copy.moveToElementText(srcele);  
	            //alert();
	            //htmlstr=srcele.innerText;
	            htmlstr=$(document.body).html();
          	}else{
          		htmlstr=$(document.body).text();
          	}
          	
          	if(htmlstr.length>=2)
	            return htmlstr.substring(cursor - 2, cursor);
	        else
	            return "";
          	*/
          	//var keRange = new window.parent.KE.range(document);
          	//alert(keRange.startPos);
          	//alert(KE.keRange.startPos);
               //document.getElementById("selection").innerText = srcele.innerText.substring(cursor - 1, cursor);  
           }
	     
		//document.body.oninput = doInput
		//document.body.onpropertychange=doInput
		document.onkeyup =function(e){
			//alert(1111111);
			//alert(firstchar);
			//alert(e.keyCode);
			/*
			if(e.shiftKey&&e.keyCode==50){ //输入@时进行监听
				//alert(0);
				firstchar='@';
			}else{
				if(firstchar=='@'&&e.keyCode==72){ //第二个字符为h时
					//alert(1);
					doInput(e);
				}else{
					//alert(2);
					firstchar='';
				}
			}	
			*/
			//alert(e.keyCode);
			//alert(e.shiftKey&&e.keyCode==50);
			/*
			if(e.shiftKey&&e.keyCode==50){ //输入@时进行监听
				//alert(0);
				firstchar='@';
				alert(firstchar);
			}
			*/
			//alert(selectionchange());
			/*
			var keystr=selectionchange();
			if(keystr=="@h")
			   doInput(e);
			*/   
			//alert(e.keyCode);
			//document.body.innerHTML=document.body.innerHTML+e.keyCode;
			//doInput(e);
		}
		/*
		document.onkeydown=function(e){
			//alert(e.keyCode)
		}
		*/
		document.onkeypress=function(){
			//alert(0);
		}
		
		document.onmouseup=function(e){
			/*
			var keystr=selectionchange();
			if(keystr=="@h")
				doInput(e);
			*/
		}

    });
});
