/*前台专用*/
$("#drillmenu").live("mouseover",showMoreMenu);

function createMenu(obj,marginLeft,parentId){
	try{
		if(marginLeft==null)marginLeft = "20px";
		var idx=0;
		jQuery(obj).find("ul:first").each(function(i,o1){
			jQuery(o1).children("li").each(function(i,o0){
				var isFirstLevel = false;
				if(jQuery(o0).parent().parent().attr("id")=="drillmenu"){
					isFirstLevel = true;
				}
				jQuery(o0).children("div").each(function(i,o2){
					jQuery(o2).children("a").each(function(i,o3){
						var margin_left = jQuery(o3).closest("ul").siblings("div").css("padding-left");
						var oriMarginLeft = margin_left;
						
						if(!isFirstLevel){
							var parentid = jQuery(o3).closest("li.liCss").children("div.divCss").find("span.e8_number").attr("id");
							
							if(parentid && (parentid=="num_11"||parentid=="num_583")){
								isFirstLevel = true;
							}
							
						}
						if( jQuery(o3).find(".e8_number").attr("id")=="num_583"){
									var li = jQuery("#num_583").closest("li")
									var li2 = document.createElement("li");
									li.children("div.divCss").remove();
									var li2content = jQuery("#drillcrumb").parent().clone();
									li2content.find("#drillcrumb").html(jQuery("#num_583").siblings("span.e8text").text());
									jQuery(li2).addClass("liCss2");
									jQuery(li2).append(li2content);
									li.before(li2);
									li.children("div").hide()
							}
						
						
						jQuery(o3).attr("isfirstlevel",isFirstLevel);
						if(margin_left){
							margin_left = parseInt(margin_left.replace(/[PXpx]/g,""))+10;
							jQuery(o3).closest("div").css("padding-left",margin_left+"px")
						}else{
							jQuery(o3).closest("div").css("padding-left",marginLeft)	
						}
						var iconImg = "";
						var isCustomMenu =false;
						try{	
							iconImg = jQuery(o3).find(".iconImage").text();
							isCustomMenu = jQuery(o3).find(".e8_number").attr("id").indexOf("num_-")!=-1 ? true:false;
						}catch(e){}
						if(jQuery(o3).attr("href").indexOf("javascript")>-1 || jQuery(o3).closest("li").find("ul").length>0){
							jQuery(o3).bind("click",function(){toggleMenu(o3)});
							jQuery(o3).attr("oldClick","toggleMenu(this)");
							//o3.oldClick=o3.onclick;
							if(isFirstLevel){
								if(jQuery(o3).find(".e8_number").attr("id")!="num_583"){
									jQuery(o3).find(".e8_number").html("<img style='margin-right:15px;' src='/wui/theme/ecology8/page/images/u_wev8.png'>")
								}
							}
							jQuery(o3).closest("div").siblings("ul").hide();
							jQuery(o3).closest("div").addClass("divCss");
							jQuery(o3).closest("li").addClass("liCss");
							
							jQuery(o3).children("div.leftMenuItemCenter").html("<span class='bzCls '></span><span class='nameDiv'><span>"+jQuery(o3).children("div.leftMenuItemCenter").html()+"</span></span>");
							if(isFirstLevel){
									if(isCustomMenu && iconImg != null && iconImg != "" ){
										jQuery(o3).find("span.bzCls").css("background-image","url("+iconImg+")")
									}else{
										jQuery(o3).find("span.bzCls").addClass("defaulticon").addClass(jQuery(o3).children("div.leftMenuItemCenter").find(".e8_number").attr("id"))
									}
							}else{
									jQuery(o3).find("span.bzCls").css("background-position","50% 50%").addClass("bzCls_close");
							}
							setNameDivWidth(o3);
							
							createMenu(jQuery(o3).closest("li"),marginLeft);
						}else{
							jQuery(o3).closest("li").addClass("liCss2");
							jQuery(o3).closest("div").addClass("divCss");
							jQuery(o3).children("div.leftMenuItemCenter").html("<span class='bzCls '></span><span class='nameDiv'><span>"+jQuery(o3).children("div.leftMenuItemCenter").html()+"</span></span>");
							if(isFirstLevel){
									if(isCustomMenu &&iconImg != null  && iconImg != "" ){
										jQuery(o3).find("span.bzCls").css("background-image","url("+iconImg+")")
									}else{
										jQuery(o3).find("span.bzCls").addClass("defaulticon").addClass(jQuery(o3).children("div.leftMenuItemCenter").find(".e8_number").attr("id"))
									}
							}else{
									jQuery(o3).find("span.bzCls").css("background-position","50% 50%")
							}
							setNameDivWidth(o3);
							jQuery(o3).bind("click",function(){
								jQuery("li.leftsubmenuselected").removeClass("leftsubmenuselected");
								jQuery(".leftMenuSelected").removeClass("leftMenuSelected");
								jQuery(o3).closest("li").addClass("leftsubmenuselected");
								jQuery(o3).children("div.leftMenuItemCenter").addClass("leftMenuSelected");
							});
						}
						
					});
				});
			});
		});
	if(parentId==616){//公文菜单
			//针对公文模块的菜单进行特殊处理
			//第一，公文标题改为【公文流转】
			jQuery("#drillcrumb").html(SystemEnv.getHtmlNoteName(3573));
			//第二步，查找到发文库菜单，并增加横线标志
			jQuery("#num_627").closest("div.leftMenuItemCenter").css({"border-bottom":"1px solid rgb(86,86,86)","height":"39px"});
			//第三步，查找到发送公文菜单，并增加title标志
			var li = jQuery("#num_624").closest("li.liCss2")
			var li2 = document.createElement("li");
			var li2content = jQuery("#drillcrumb").parent().clone();
			li2content.find("#drillcrumb").html(SystemEnv.getHtmlNoteName(3574));
			jQuery(li2).addClass("liCss2");
			jQuery(li2).append(li2content);
			li.before(li2);
		}
		jQuery("#leftmenucontentcontainer").css("visibility","visible");
			
			$(".menuMore").remove();
			//$("#drillmenu").unbind("mouseover",showMoreMenu);
			if(isShowLeftMenu==0){
				var psize = $("#drillmenu>ul>li").length;
				var maxheight = parseInt($("#leftMenu").height()/3)*2;
				if(maxheight<psize*40){
				
					$("#drillmenu>ul").css("height",maxheight+"px");
					//alert(	$("#drillmenu>ul").css("height"))
					//$("#drillmenu").css("overflow","hidden");
				
					$("#drillmenu").after("<div  class='menuMore leftMenuItemCenter '><span class='bzCls '></span><span class='text' >&nbsp;</span></div>")
					//$("#drillmenu").bind("mouseover",showMoreMenu);
					//alert(1)
					//$(menumore_bright)
					if($("#portalCss").attr("href").indexOf("left6")>-1){
				
						$("#menuMore").css("background-image"," url(/wui/theme/ecology8/page/images/menumore_dark_wev8.png)")
						$("#menuMore .text").css("background-image"," url(/wui/theme/ecology8/page/images/menumoretext_dark_wev8.png)")
					}
				}
			}
		

	}catch(e){
		jQuery("#leftmenucontentcontainer").css("visibility","visible");
	};
}

function showMoreMenu(){
	//alert(2)
	if($(".menuMore").length>0){
		$("#drillmenu>ul").css("height","auto");
		//$("#drillmenu").css("height","auto");
		//$("#drillmenu>ul").animate({height:"100%"})
		
		$("#drillmenu").animate({height:"100%"},function(){
			
			$("#drillmenu").css("height","auto");
			$(".menuMore").remove();
			//$("#drillmenu").unbind("mouseover",showMoreMenu);
			$('#leftMenu').perfectScrollbar("update");
		})
	}
	//$("#drillmenu>ul>li").show();
	//$(".menuMore").remove();
}

function setMarginLeft(o){
	var w1 = jQuery(o).closest("li").width();
	var w2 = jQuery(o).closest("div").css("padding-left").replace(/\D/g,"");
	var w3 = jQuery(o).find("span.bzClsLevel").css("padding-right").replace(/\D/g,"");
	w3 = parseInt(w3)+jQuery(o).find("span.bzClsLevel").width();
	var w4 = jQuery(o).find("span.nameDiv").width();
	var w5 = jQuery(o).find("span.expand").width();
	if(jQuery.browser.msie && jQuery.browser.version=="8.0"){
		jQuery(o).find("span.expand").css("margin-left",(w1-w2-w3-w4-w5-30)+"px"); 
	}else{
		jQuery(o).find("span.expand").css("margin-left",(w1-w2-w3-w4-w5-10)+"px");
	}
	
}

function setNameDivWidth(o){
	var w1 = jQuery(o).closest("div#drillmenu").width();
	var w2 = jQuery(o).closest("div").css("padding-left").replace(/\D/g,"");
	var w3 = jQuery(o).find("span.bzCls").css("padding-right").replace(/\D/g,"");
	if(jQuery.browser.msie){
		jQuery(o).find("span.nameDiv").width(w1-w2-w3-12);
	}else{
		jQuery(o).find("span.nameDiv").width(w1-w2-w3);
	}
}



function toggleMenu(o){
	//alert(jQuery(".liCss2").parent(":visible").length)


	try{
		if(jQuery(o).attr("href").indexOf("Homepage.jsp")>-1){
			jQuery(o).closest("div").siblings("ul").css("background-color",$("#leftmenucontainer").css("background-color")).addClass("leftMenuOverride")
		}else{
			jQuery("#drillmenu").find("li.liSelected").removeClass("liSelected");
		}
	if(jQuery(o).closest("div").siblings("ul").css("display") && jQuery(o).closest("div").siblings("ul").css("display")!="none"){
		
	
	
		if(jQuery(o).attr("isFirstLevel")=="true"){
				if(jQuery(o).find(".e8_number").attr("id")!="num_583"){
					$(o).find(".e8_number").html("<img style='margin-right:15px;' src='/wui/theme/ecology8/page/images/u_wev8.png'>")
				}
		}else{
				$(o).find("span.bzCls").removeClass("bzCls_open").addClass("bzCls_close");
		
		}
	}else{
		if(jQuery(o).attr("isFirstLevel")=="true"){
			if(jQuery(o).find(".e8_number").attr("id")!="num_583"){
				$(o).find(".e8_number").html("<img style='margin-right:15px;' src='/wui/theme/ecology8/page/images/d_wev8.png'>")
			}
		}else{
				$(o).find("span.bzCls").removeClass("bzCls_close").addClass("bzCls_open");
		}	
		
	
	}
	jQuery(o).closest("div").siblings("ul").toggle();
	
	
	window.setTimeout(function(){
		jQuery("#drillmenu").height(jQuery("#drillmenu").children("ul").height());
		$('#leftMenu').perfectScrollbar("update");
	},1);
	}catch(e){}
	
	if($(".liCss2").parent(":visible").parent("li").length>0){
			showMoreMenu();
	}
}

function updateScroll(outerContainer,innerContainer,parentId){
		//邮件菜单比较特殊，需要特殊处理
		if(jQuery(innerContainer).children("ul").height()==null){
			window.setTimeout(function(){
				jQuery(innerContainer).height(jQuery("#emailCenter").height());
			},200);
		}else{
			createMenu(innerContainer,null,parentId);
			jQuery(innerContainer).height(jQuery(innerContainer).children("ul").height());
		}
		$(outerContainer).perfectScrollbar("update");
		
}