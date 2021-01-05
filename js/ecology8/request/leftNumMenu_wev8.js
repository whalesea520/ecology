/**
* 左侧菜单 for ecology8
* Author bpf
* created on 2013-10-25
* 本插件基于JQUERY;纯前端插件，不依赖后台
* 使用本插件时页面中应同时引用leftNumMenu.css
*/
(function ($) {
	var setTimeoutCount = 0;
	$.fn.leftNumMenu = function (menus,options,level,_otheroptions) {
		var _this = this;
		if(!jQuery.fn.zTree){
			setTimeout(function(){
				jQuery(_this).leftNumMenu(menus,options,level,_otheroptions);
			},100);
		}else{
			var $this = jQuery(this).eq(0);
			if(!level)level=1;
			_otheroptions  = jQuery.extend({
				isRec:false,
				parentNode:null,
				treeObj:null,
				operation:null,
				container:$this,
				callback : null,
			},_otheroptions);
			if(!_otheroptions.isRec){
				if(typeof options === "string"){
					if(options==="update"){
						 if(typeof menus === "string"){
							$.ajax({
								type: "POST",
								url: menus,
								dataType:"json",
								async:true,
								success: function(data){
									$this.leftNumMenu(data,"update",level, _otheroptions);
								}
							});
							return;
						 }
						 //if(window.console)console.log("time3---"+new Date());
						 if(!(Object.prototype.toString.call(menus)==="[object Array]")){
							var _menus = [];
							_menus.push(menus);
							menus = _menus;
						}
						var treeObj = jQuery(this).data("treeObj");
						var ztreeObj = $.fn.zTree.getZTreeObj(treeObj.attr("id"));
						var __options = jQuery(this).data("__options");
						var treeLoaded = true;
						for(var i=0;i<menus.length;i++){
							var menu = menus[i];
							var __domid__ = menu.__domid__;
							var numbers  = menu.numbers;
							var attr = menu.attr;
							var treeNode = ztreeObj.getNodeByParam("__domid__",__domid__);
							if(!treeNode)continue;
							for(var _key in attr){
								treeNode.attr[_key] = attr[_key];
							}
							ztreeObj.updateNode(treeNode);
							var numberTypes = null;
							var showZero = false;
							var deleteIfAllZero = false;
							if(__options){
								numberTypes = __options.numberTypes;
								showZero  = __options.showZero;
								deleteIfAllZero = __options.deleteIfAllZero;
							}
							var parentDom = null;
							for(key in numbers){
								var num = numbers[key];
								if(!num)num=0;
								var defaultid = key+"_"+__domid__;
								var defaultdom = jQuery("#"+defaultid);
								var hoverdom = jQuery("#hover_"+defaultid);
								if(hoverdom.length==0&&num){
									treeLoaded = false;
									break;
								}
								if(!parentDom||parentDom.length==0)parentDom = defaultdom.parent();
								defaultdom.html(num);
								hoverdom.html(num);
								var numberType = null;
								var display = true;
								if(numberTypes){
									numberType = numberTypes[key];
									if(numberType){
										display = numberType.display;
									}
								}
								if((showZero==false && !num) || display==false){
									defaultdom.css("display","none");
									//hoverdom.css("display","none");
									if(num && num!="0"){
										hoverdom.css("display","inline-block");
									}
									if(!num||num=="0"){
										hoverdom.css("display","none");
									}
								}else{
									defaultdom.css("display","");
									hoverdom.css("display","inline-block");
								}
							}							
							if(parentDom && parentDom.length>0){
								parentDom.find("span.sepline").css("display","none");
								var doms = parentDom.find("span.defaultSpan");
								var showDoms = 0;
								var isAllZero = true;
								doms.each(function(){
									if(jQuery(this).css("display")!="none"){
										showDoms++;
										isAllZero = false;
									}
									if(showDoms>1){
										jQuery(this).prev("span.sepline").css("display","");
										showDoms--;
									}
								});
								if(isAllZero && deleteIfAllZero){
							  		parentDom.closest("div.e8HoverZtreeDiv").css("display","none");
							  	}
							  	parentDom = null;
							  
						}
						}
						if(!treeLoaded && setTimeoutCount<5){
							setTimeout(function(){
								$this.leftNumMenu(menus,options,level, _otheroptions);
							},50);
							treeLoaded = true;
							setTimeoutCount++;
						}else{
						
							if (!!_otheroptions.callback) {
								_otheroptions.callback(menus);
							}
						}
						// if(window.console)console.log("time4---"+new Date());
						return;
					}
				}
				options = jQuery.extend({
					addDiyDom:true,
					numberTypes:{},
					expand:null,
					showZero:false,
					clickFunction:null,
					multiJson:false,
					rightKey:"hasRight",
					deleteIfAllZero:false,
					setting:{
						view: {
							expandSpeed: "" ,    //效果
							addDiyDom:addDiyDom
						},
						callback: {
							onClick: _leftMenuClickFunction,   //节点点击事件
							beforeExpand:_checkIsAjaxLoad
						}
					}
				},options);
				//if(window.console)console.log("time1::"+new Date());
				try{
					if(jQuery("#oTd1",parent.document).length>0){
						jQuery('.flowMenusTd').show();
						jQuery('.leftTypeSearch').show();
					}
				}catch(e){}
				if(typeof menus == "string"){
					jQuery.ajax({
						url:menus,
						type:"post",
						dataType:"json",
						success:function(data){
							$this.leftNumMenu(data,options,level);
						}
					});
					return;
				}
			}
			
			var zNodes = [];
			var setting = options.setting;
			if(menus instanceof Array){
				for(var i=0;i<menus.length;i++){
					var menu = menus[i];
					if(options.multiJson===true){
						var m = null;
						for(var key in menu){
							m = menu[key];
							break;
						}
						menu = m;
					}
					var json = {};
					json.options = options;
					json.cusLevel = level;
					for(var key in menu){
						if(key==="hasChildren"){
							if(menu[key]===false||menu[key]==="false"){
								json.isParent = false;
							}else{
								json.isParent = true;
							}
						}else if(key===options.rightKey){
							if(menu[key]==="N"){
								json.nocheck = true;
								json.fontClass = "e8Noright";
							}
							json[key] = menu[key];
						}else if(key==="isOpen"){
							if(menu[key]==="false"){
								menu[key] = false;
							}
							if(!(menu[key]===false)){
								json.open = true;
							}
						}else if(key==="attr"){
							json.attr = menu[key];
						}else if(key==="submenus"){
							var subJson = jQuery($this).leftNumMenu(menu[key],options,level+1,{isRec:true});
							if(subJson){
								json.childs = subJson;
							}
						}else{
							json[key] = menu[key];
						}
					}
					zNodes.push(json);
				}
				if(_otheroptions.isRec){
					return zNodes;
				}else if(menus.length!=0){
					var emptyinfo = jQuery("#e8emptyInfo");
					emptyinfo.remove();
					var ulObj = _otheroptions.parentNode;
					if(!ulObj || ulObj.length==0){
						$this.children().remove();
						ulObj = jQuery("<ul>",{
							id:"ztreeObj",
							"class":"ztree"
						});
						$this.append(ulObj);
						$this.data("treeObj",ulObj);
						$this.data("__options",options);
						$.fn.zTree.init(ulObj, setting, zNodes);
						if(options.selectFirst){
							try{
								var treeObj = $.fn.zTree.getZTreeObj("ztreeObj");
								var treeNodes = treeObj.getNodes();
								if(treeNodes.length>0){
									var treeNode = treeNodes[0];
									var treeDom = $("#"+treeNode.tId+"_a");
									treeObj.selectNode(treeNode);
									treeDom.click();
								}
							}catch (e) {
								// TODO: handle exception
								if(window.console){
									console.log(e);
								}
							}	
						}
						try{
							//回调方法
							var callback = options._callback;
							if(callback){
								callback($this,menus,options,level,options._callbackParams);
							}
						}catch(e){
							if(window.console)console.log(e,"leftNumMenu.js#callback");
						}
					}else{
						var treeObj = _otheroptions.treeObj;
						if(!treeObj)var treeObj = $.fn.zTree.getZTreeObj("ztreeObj");
						if(!_otheroptions.operation || _otheroptions.operation==="add"){
							var result = treeObj.addNodes(ulObj,zNodes);
							if(result){
								ulObj.loaded = true;
							}
						}
					}
					//if(window.console)console.log("time2::"+new Date());
				}else{
					$this.children("div").remove();
					var emptyinfo = jQuery("#e8emptyInfo");
					if(emptyinfo.length==0){
						emptyinfo=jQuery("<div id='e8emptyInfo'></div>");
						$this.append(emptyinfo);
					}
					try{
						emptyinfo.html(SystemEnv.getHtmlNoteName(3558,readCookie("languageidweaver")));
					}catch(e){
						emptyinfo.html("没有可以显示的数据");
					}
					emptyinfo.show();
					}
			}else{
				return null;
			}
		}
	};

	function addDiyDom(treeId, treeNode){
		setTimeout(function(){
			var options = treeNode.options;
			if(options && options.addDiyDom===false)return;
			var aObj = $("#" + treeNode.tId + "_a").addClass("e8menu");
			if (aObj.children("span.e8menu_num_text").length>0) return;
			var spanArr = [];
			spanArr.push("<span class='e8menu_num_text' style='float:right;display:block;color:#000;'>");
			var numbers = treeNode.numbers;
			var domid = treeNode.__domid__;
			var numberTypes = treeNode.options.numberTypes;
			var spanNums = [];
			var spanHoverNums = [];
			var idx = 0;
			var __curShow = true;
			var __preShow = 0;
			var __sepline = 0;
			for(var key in numberTypes){
				var nums = numbers[key];
				if(!nums || nums==="0")nums=0;
				var display = numberTypes[key].display;
				var showZero =treeNode.options.showZero;
				var isShow = (nums==0&&showZero===false)?"none":"";
				if(display===false){
				}else{
					if(idx!=0){
						var __display = "none";
						if(__sepline == __preShow-1  && (showZero!=false||nums!=0)){
							__display = "";
							__sepline++;
							__preShow++;
						}
						spanNums.push("<span class='sepline' style='display:"+__display+"'>/</span>");
					}else{
							if(isShow!="none"){
								__preShow++;
							}
						}
					spanNums.push("<span class='defaultSpan' id='"+key+"_"+domid+"' style='color:"+numberTypes[key].color+";display:"+isShow+"'>"+nums+"</span>");
				}
				spanHoverNums.push("<span id='hover_"+key+"_"+domid+"' onclick=__leftMenuClickFunction(event,'"+treeId+"','"+treeNode.tId+"',1,this);  style='display:"+isShow+";background-color:"+numberTypes[key].hoverColor+";' class='e8_block' title='"+numberTypes[key].title+"' e8menu_numbertype='"+key+"'>"+nums+"</span>");
				idx++;
			}
			spanArr.push(spanNums.join(""));
			spanArr.push("</span>");
			spanArr.push("<span class='e8menu_num_block' style='float:right;display:none;'>");
			spanArr.push(spanHoverNums.join(""));
			spanArr.push("</span>");
			aObj.append(spanArr.join(""));
			aObj.data("e8menu_num_text",aObj.children("span.e8menu_num_text"));
			aObj.data("e8menu_num_block",aObj.children("span.e8menu_num_block"));
			aObj.hover(function(e){
				var $this = jQuery(this);
				var e8menu_num_text = $this.data("e8menu_num_text");
				var e8menu_num_block = $this.data("e8menu_num_block");
				e8menu_num_text.hide();	
				e8menu_num_block.css("display","");	
			},function(e){
				var $this = jQuery(this);
				var e8menu_num_text = $this.data("e8menu_num_text");
				var e8menu_num_block = $this.data("e8menu_num_block");
				e8menu_num_text.css("display","");	
				e8menu_num_block.hide();	
			});
		},50);
	}
	
	
	function toggleChildren(options,attr,level,node){
		var childrenNodes=$(node).closest("li").children("ul");
		var menuIcon = jQuery(node).children(".e8menu_icon");
		if(!options.expand){
			menuIcon.removeClass();
			menuIcon.attr("hasChildren",false);
			menuIcon.addClass("e8menu_icon").addClass("e8menu_icon_none");
		}
		if(options.expand && childrenNodes.size()==0){
//			var url=expandUrl(options.expandUrl,attr,level);
			var url=expandUrl(options.expand.url,attr,level);
			if(url==null || url==undefined || url==""){
				menuIcon.removeClass();
				menuIcon.addClass("e8menu_icon").addClass("e8menu_icon_none");
				return ;
			}
			var children = getChildren(url,node,options,level,menuIcon,attr);
		}else{
			if(!window.searchFlag){
				childrenNodes.toggle();
				childrenNodes.find("div").show();
				jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
				jQuery('#overFlowDiv').perfectScrollbar("update");
			}
		}
	}
})(jQuery);

var __weaverTreeNamespace__ = (function(){
	return (function(){
		return {
			expandUrl:function(expandUrl,attrs,level){
				if(!expandUrl)return null;
				if(typeof expandUrl=="function"){
					return expandUrl(attrs,level);
				}else{
					for(attr in attrs){
						expandUrl += expandUrl.indexOf("?")==-1?"?":"&";
						expandUrl += attr+"="+attrs[attr];
					}
					return expandUrl;
				}
			},
			_checkIsAjaxLoad:function(treeId,treeNode){
				var options = treeNode.options;
				var treeObj = $.fn.zTree.getZTreeObj(treeId);
				//处理ajax加载数据事宜
				var expand = options.expand;
				if(expand){
					var url = expandUrl(expand.url,treeNode.attr,treeNode.cusLevel);
					if(treeNode.loaded || !url){
						//treeObj.expandNode(treeNode);
					}else if(url){
						var node = jQuery("#"+treeNode.tId);
						getChildren(url,node,options,treeNode.cusLevel,null,treeNode.attr,{parentNode:treeNode,treeObj:treeObj,operation:"add"});
					}
				}else{
					//treeObj.expandNode(treeNode);
				}
			},
			getChildren:function(url,node,options,level,menuIcon,attr,_otheroptions){
				var returnChildren;
				$.ajax({
					type: "POST",
					url: url,
					dataType:"json",
					success: function(children){
						//returnChildren = children;
						if(!!children && children.length!=0){
							$(node).leftNumMenu(children,options,level+1,_otheroptions);	
						}
						var done=options.expand.done;
						if(done!=null && done!=undefined){
							done(children,attr,level);
						}
						try{
							//回调方法
							var callback = options._callback;
							if(callback){
								callback(_otheroptions.container,children,options,level+1,options._callbackParams);
							}
						}catch(e){
							
						}
					}
				});
				return returnChildren;
			},
			__leftMenuClickFunction:function(event, treeId, tId,clickFlag,targetObj){
				var treeObj = $.fn.zTree.getZTreeObj(treeId);
				var treeNode = treeObj.getNodeByTId(tId);
				_leftMenuClickFunction(event,treeId,treeNode,clickFlag,targetObj);
				try{
					var evt = event || window.event;
					if(window.event){
						window.event.cancelBubble = true;
						return false;
					}else{
						evt.stopPropagation();
					}
				}catch(e){}
			},
			_leftMenuClickFunction:function(event, treeId, treeNode,clickFlag,targetObj){
				var options = treeNode.options;
				var clickFunction = options.clickFunction;
				var treeObj = $.fn.zTree.getZTreeObj(treeId);
				var spanBlk = false;
				if(clickFunction){
					if(!!targetObj){
						var evt = event ? event:(window.event?window.event:null);
						targetObj = $(evt.srcElement ? evt.srcElement : evt.target);
						spanBlk = true;
					}else{
						targetObj = $(targetObj);
						if(treeNode[options.rightKey]==="N"){
						}else{
							treeObj.selectNode(treeNode);
						}
					}
					var numberType = targetObj.hasClass("e8_block")?targetObj.attr("e8menu_numberType"):null;
					try{
						clickFunction(treeNode.attr,treeNode.cusLevel,numberType,treeObj,{treeNode:treeNode,treeObj:treeObj,evt:event});
					}catch(e){
						if(window.console)console.log(e,"/js/ecology8/request/leftNumMenu.js#_leftMenuClickFunction");
					}
				}
				if(!!spanBlk){
					return false;
				}
				//处理ajax加载数据事宜
				var expand = options.expand;
				if(expand){
					var url = expandUrl(expand.url,treeNode.attr,treeNode.cusLevel);
					if(treeNode.loaded || !url){
						treeObj.expandNode(treeNode);
					}else if(url){
						var node = jQuery("#"+treeNode.tId);
						getChildren(url,node,options,treeNode.cusLevel,null,treeNode.attr,{parentNode:treeNode,treeObj:treeObj,operation:"add"});
					}
				}else{
					treeObj.expandNode(treeNode);
				}
			},
			_expandAll:function($this){
				var treeObj = $.fn.zTree.getZTreeObj("ztreeObj");
				treeObj.expandAll();
			},
			getZTreeObj:function(){
				return $.fn.zTree.getZTreeObj("ztreeObj")
			},
			selectDefaultNode:function(key,value){
				var treeObj = getZTreeObj();
				var node = treeObj.getNodeByParam(key, value);
				treeObj.selectNode(node);
			},
			cancelSelectedNode:function(key,value){
				var treeObj = getZTreeObj();
				if(key && value){
					var node = treeObj.getNodeByParam(key, value);
					if(node)
						treeObj.cancelSelectedNode(node);
				}else{
					var nodes = treeObj.getSelectedNodes();
					try{
						treeObj.cancelSelectedNode(nodes[0]);
					}catch(e){}
				}
			},
			checkedDefaultNode:function(key,values){
				var treeObj = getZTreeObj();
				if(!!values){
					values = values.split(",");
					for(var i=0;i<values.length;i++){
						var node = treeObj.getNodeByParam(key, values[i]);
						node.checked = true;
						treeObj.updateNode(node);
						treeObj.selectNode(node);
					}
				}
			},
			expandAll2:function(){
				var imgs = jQuery("div.e8_level_2");
				var i=0;
				window.searchFlag = true;
				imgs.each(function(){
				   jQuery(this).click();
				   i++;
				});
				return i;
			},
			format2:function(searchStr,show){
				var as = jQuery("div span.e8menu_name");
				var hasMore = false;
				as.each(function(){
					var display = jQuery(this).closest("div").css("display");
					if(jQuery(this).text().toLowerCase().indexOf(searchStr)<0 && display!="none"){
						jQuery(this).closest("div").hide();
						hasMore = true;
					}else{
						if(show && jQuery(this).text().toLowerCase().indexOf(searchStr)>-1){
						  jQuery(this).closest("div").show();
						  jQuery(this).parents("ul.e8menu_ul").prev("div").show();
						}
					}
				});
				return hasMore;
			},
			e8_before2:function(){
				jQuery("#overFlowDiv .ulDiv").hide();
				jQuery("#e8emptyInfo").hide();
				var e8_searching = jQuery("div#e8_loading");
				if(e8_searching.length==0){
					e8_searching = getLoadingDiv();
					jQuery("body").append(e8_searching);
					e8_searching.css({
						width:jQuery("#overFlowDiv").width()-12
					});
				}
				jQuery("div#e8_loading").show();
			},
			e8_after2:function(){
				e8_after3(true);
			},
			e8_after3:function(isAnysc){
				var ulDiv = jQuery("#overFlowDiv .ulDiv");
				ulDiv.show();
				jQuery("div#e8_loading").hide();
				window.setTimeout(function(){
					try{
						ulDiv.height(ulDiv.children(":first").height());
					//	alert(ulDiv.css("display")+"::"+ulDiv.height()+"::"+ulDiv.children("li").length);
						if((ulDiv.height()<=10||(ulDiv.children(":first").attr("id")=="e8emptyInfo")) && !isAnysc){
							var emptyinfo = jQuery("#e8emptyInfo");
							if(emptyinfo.length==0){
								emptyinfo=jQuery("<div id='e8emptyInfo'></div>");
								ulDiv.parent().after(emptyinfo);
							}
							try{
								emptyinfo.html(SystemEnv.getHtmlNoteName(3558,readCookie("languageidweaver")));
							}catch(e){
								emptyinfo.html("没有可以显示的数据");
							}
							emptyinfo.show();
						}
						//jQuery('#overFlowDiv').perfectScrollbar("update");
					}catch(e){
						if(window.console)console.log("/js/ecology8/request/leftNumMenu.js-->format2-->"+e);
					}
					window.searchFlag = false;
				},window.searchFlag?10:1000);
			},
			e8_search2:function(searchStr,notExpand){
				var i = 0;
				if(notExpand){
					i=0;
				}else{
					//e8_before2();
					i=expandAll2();
				}
				if(i>0){
					window.setTimeout(function(){
						e8_search2(searchStr,true);
					},1000);
				}else{
					var hasMore = format2(searchStr);
					if(hasMore){
						window.setTimeout(function(){
							e8_search2(searchStr,true);
						},500);
					}else{
						format2(searchStr,true);
						e8_after3();
					}
				}
			}
		}
	})();
})();


/**
 * 生成AJAX请求的URL
 */
 //@deprecated
function expandUrl(expandUrl,attrs,level){
	return __weaverTreeNamespace__.expandUrl(expandUrl,attrs,level);
}

//@deprecated
function _checkIsAjaxLoad(treeId,treeNode){
	__weaverTreeNamespace__._checkIsAjaxLoad(treeId,treeNode);
}

//@deprecated
function getChildren(url,node,options,level,menuIcon,attr,_otheroptions){
		return __weaverTreeNamespace__.getChildren(url,node,options,level,menuIcon,attr,_otheroptions)
}

//@deprecated
function __leftMenuClickFunction(event, treeId, tId,clickFlag,targetObj){
		__weaverTreeNamespace__.__leftMenuClickFunction(event, treeId, tId,clickFlag,targetObj);
}

//@deprecated
function _leftMenuClickFunction(event, treeId, treeNode,clickFlag,targetObj){
	__weaverTreeNamespace__._leftMenuClickFunction(event, treeId, treeNode,clickFlag,targetObj);
}

//@deprecated
function _expandAll($this){
	__weaverTreeNamespace__._expandAll($this);
}

//@deprecated
function getZTreeObj(){
	return __weaverTreeNamespace__.getZTreeObj();
}

//@deprecated
function selectDefaultNode(key,value){
	__weaverTreeNamespace__.selectDefaultNode(key,value);
}

//@deprecated
function cancelSelectedNode(key,value){
	__weaverTreeNamespace__.cancelSelectedNode(key,value);
}

//@deprecated
function checkedDefaultNode(key,values){
	__weaverTreeNamespace__.checkedDefaultNode(key,values);
}

//@deprecated
function expandAll2(){
    return __weaverTreeNamespace__.expandAll2();
}

//@deprecated
function format2(searchStr,show){
	return __weaverTreeNamespace__.format2(searchStr,show);
}

//@deprecated
function e8_before2(){
	__weaverTreeNamespace__.e8_before2();
}

//@deprecated
function e8_after2(){
	__weaverTreeNamespace__.e8_after2();
}

//@deprecated
function e8_after3(isAnysc){
	__weaverTreeNamespace__.e8_after3(isAnysc);
}

//@deprecated
function e8_search2(searchStr,notExpand){
	__weaverTreeNamespace__.e8_search2(searchStr,notExpand);
}

window.isJson = function(obj){
	var isjson = typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length;    
	return isjson;
}
