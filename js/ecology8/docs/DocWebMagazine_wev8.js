	/**
	 *	created by LL in Oct,2013
	**/
	
	/**
	 *	wuiform.init针对本页的功能来说无任何作用，纯粹用于解决兼容init.jsp中的JS/css冲突的问题
	**/
	
	flowPageManager.loadFunctions.leftNumMenu = function(){
		$(".ulDiv").leftNumMenu(demoLeftMenus,{
			numberTypes:{
				magaNum:{hoverColor:"#A6A6A6",color:"black",title:SystemEnv.getHtmlNoteName(3533,readCookie("languageidweaver"))}
			},
			showZero:false,
//			menuStyles:["menu_lv1",""],
			clickFunction:function(attr,level,numberType){
				leftMenuClickFn(attr,level,numberType);
			}
		});
		var sumCount=0;
		jQuery(".e8_level_2").each(function(){
			sumCount+=parseInt(jQuery(this).find(".e8_block:last").html());
		});
		//jQuery("#totalDoc").html("("+sumCount+")");
	}
	
	function leftMenuClickFn(attr,level,numberType){
		if(numberType==null){
			//window.location.href= attr.url;
			jQuery("#flowFrame").attr("src",attr.url);
		}else if(numberType=="magaNum"){
			jQuery("#flowFrame").attr("src",attr.url);
		}else{
			alert(SystemEnv.getHtmlNoteName(3532,readCookie("languageidweaver")));
		}
	}
	
	/**
	*刷新左侧菜单栏
	*/
	function refreshLeftMenu(param,doccreaterid,urlType,url){
		jQuery.ajax({
			url:"DocSearchMenu.jsp",
			data:{
				doccreatedateselect:param,
				doccreaterid:doccreaterid,
				urlType:urlType,
				url:url
			},
			success:function(data){
				jQuery("#menuStr").html(data);
				jQuery(".ulDiv").html("");
				flowPageManager.loadFunctions.leftNumMenu();
				$('#overFlowDiv').perfectScrollbar();
			}
		});
	}
	

	
