		function createLeftMenu(module,menuJosn){
			//生成左侧菜单第一级主菜单
			jQuery("#leftmenuContent"+module).empty();
			for (var mainmenu in menuJosn){
				var div = jQuery("<div menmuid="+mainmenu+">"+menuJosn[mainmenu]["name"]+"</div>").addClass("hand").addClass("leftmainmenu");
				if(menuJosn[mainmenu]["url"]!=""){
					div = jQuery("<a href='"+menuJosn[mainmenu]["url"]+"' target='mainframe"+module+"'></a>").append(div);
				}
				jQuery("#leftmenuContent"+module).append(div)
			}
			
			//定义鼠标移动效果
			jQuery("#leftmenuContent"+module).find("div").hover(
				function(){if(jQuery(this).attr("select")!="selected") jQuery(this).removeClass("leftmainmenu").addClass("leftmainmenuselected");},
				function(){if(jQuery(this).attr("select")!="selected") jQuery(this).removeClass("leftmainmenuselected").addClass("leftmainmenu");}
			)

			//定义主菜单点击事件
			jQuery("#leftmenuContent"+module).find("div").bind("click",function(){
					jQuery(".leftmainmenuselected").removeClass("leftmainmenuselected").addClass("leftmainmenu");
					jQuery(this).removeClass("leftmainmenu").addClass("leftmainmenuselected");
					jQuery("#leftsubmenuContent"+module).html("");

					jQuery("#leftmenuContent"+module).find("div").attr("select","");
					jQuery(this).attr("select","selected");
					
					//更新选中菜单名称
					jQuery("#selectedLeftMenu").text(jQuery(this).text());
					jQuery('#menuFloatSpan').text("/ "+jQuery(this).text());
					jQuery('#menuFloatSpan').attr("mainmenu",jQuery(this).text());
					
					var defmenu = jQuery(this).attr("menmuid");
					var lefsubmenu;
					if(jQuery("#leftsubmenuContent"+module).length==0){
						lefsubmenu = jQuery("<div id='leftsubmenuContent"+module+"'></div>")
					}else{
						lefsubmenu = jQuery("#leftsubmenuContent"+module);
					}
					lefsubmenu.html("");
					lefsubmenu.hide();

					for(var i=0; i<menuJosn[defmenu]["subitems"].length;i++){// in leftmenu[defmenu]["subitems"]){
						var sub = menuJosn[defmenu]["subitems"][i];
						var div = jQuery("<div>"+sub.name+"</div>").addClass("leftsubmenu").addClass("hand");
						div = jQuery("<a href='"+sub.url+"' target='mainframe"+module+"'></a>").append(div);
						
						lefsubmenu.append(div);
					}
					
					if(lefsubmenu.html()!=""){
						lefsubmenu.insertAfter(jQuery(this));
						lefsubmenu.show();
					}
					
					//定义子菜单鼠标移动效果
					jQuery("#leftsubmenuContent"+module).find("div").hover(
						function(){if(jQuery(this).attr("select")!="selected"){ jQuery(this).removeClass("leftsubmenu").addClass("leftsubmenuselected");}},
						function(){if(jQuery(this).attr("select")!="selected") jQuery(this).removeClass("leftsubmenuselected").addClass("leftsubmenu");}
					)
					//定义子菜单单击事件
					jQuery("#leftsubmenuContent"+module).find("div").bind("click",function(){
						jQuery(".leftsubmenuselected").removeClass("leftsubmenuselected").addClass("leftsubmenu");
						jQuery(this).removeClass("leftsubmenu").addClass("leftsubmenuselected");

						jQuery("#leftsubmenuContent"+module).find("div").attr("select","");
						jQuery(this).attr("select","selected");
						jQuery('#menuFloatSpan').html("/&nbsp;"+jQuery('#menuFloatSpan').attr("mainmenu")+"&nbsp;/&nbsp;"+jQuery(this).text());
					})
			})
		}
