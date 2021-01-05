	/**
	 *	created by LL in Oct,2013
	**/
	
	/**
	 *	wuiform.init针对本页的功能来说无任何作用，纯粹用于解决兼容init.jsp中的JS/css冲突的问题
	**/
	
	flowPageManager.loadFunctions.leftNumMenu = function(){
		$(".ulDiv").leftNumMenu(demoLeftMenus,{
			numberTypes:{
				docNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:SystemEnv.getHtmlNoteName(3530,readCookie("languageidweaver"))},
				docAll:{hoverColor:"#A6A6A6",color:"black",title:SystemEnv.getHtmlNoteName(3531,readCookie("languageidweaver"))}
			},
			showZero:false,
			expand:{
					url:function(attr,level){
						return attr.urlSum;
					},
					done:function(children,attr,level){
						jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
						jQuery('#overFlowDiv').perfectScrollbar("update");
					}
			},
			
			clickFunction:function(attr,level,numberType,node){
				leftMenuClickFn(attr,level,numberType,node);
			}
		});
		var sumCount=0;
		jQuery(".e8_level_2").each(function(){
			sumCount+=parseInt(jQuery(this).find(".e8_block:last").html());
		});
		//formatLeftMenu(demoLeftMenus,".ulDiv",0);
	}
	
	function leftMenuClickFn(attr,level,numberType,node){
		if(numberType==null){
			/*if(level==2){
				var childrenNodes=jQuery(node).parent().find(".e8menu_ul").size();
				if(childrenNodes==0 && !!attr.urlSum){
					expandSubNode(attr.urlSum,node,level);
				}else if(childrenNodes>0){
					jQuery(node).siblings("ul.e8menu_ul").toggle();
				}
			}*/
			jQuery("#flowFrame").attr("src",attr.urlAll);
		}else if(numberType=="docNew"){
			jQuery("#flowFrame").attr("src",attr.urlNew);
		}else if(numberType=="docAll"){
			jQuery("#flowFrame").attr("src",attr.urlAll);
		}else{
			alert(SystemEnv.getHtmlNoteName(3532,readCookie("languageidweaver")));
		}
	}
	
	/*function expandSubNode(url,node,level){
		jQuery.ajax({
			url:url,
			type:"get",
			async:false,
			dataType:"json",
			success:function(data){
				formatLeftMenu(data,level+1,jQuery(node).parent())
				
			},
			error:function(data){
				
			}
		});
	}
	
	function formatLeftMenu(data,level,node){
		jQuery(node).leftNumMenu(data,{
			numberTypes:{
				docNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"新的文档"},
				docAll:{hoverColor:"#A6A6A6",color:"black",title:"全部文档"}
			},
			showZero:false,
			clickFunction:function(attr,level,numberType,node){
				leftMenuClickFn(attr,level,numberType,node);
			}
		},level);
		var sumCount=0;
		jQuery(".e8_level_2").each(function(){
			sumCount+=parseInt(jQuery(this).find(".e8_block:last").html());
		});
		jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
		jQuery('#overFlowDiv').perfectScrollbar("update");
	}*/
	
	/**
	*刷新左侧菜单栏
	*/
	function refreshLeftMenu(param,doccreaterid,urlType,url,options){
		var _options = {};
		if(options){
			options.doccreatedateselect = param;
			options.doccreaterid = doccreaterid;
			options.urlType = urlType;
			options.url = url;
		}else{
			_options.doccreatedateselect = param;
			_options.doccreaterid = doccreaterid;
			_options.urlType = urlType;
			_options.url = url;
			options = _options;
		}
		var showtype=parseInt(jQuery("#showtype").val());
		if(showtype==2){
			//e8_initTree("DocSearchByOrgLeft.jsp?rightStr=Car:Maintenance");
		}else{
			jQuery.ajax({
				url:"DocSearchMenu.jsp",
				data:options,
				success:function(data){
					jQuery("#menuStr").html(data);
					jQuery(".ulDiv").html("");
					flowPageManager.loadFunctions.leftNumMenu();
					$('#overFlowDiv').perfectScrollbar();
				}
			});
		}
	}
	

	
