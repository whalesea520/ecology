;(function($){
    $.fn.selectForK13 = function(options){
        var defaults = {
            "width": "",  //设置宽度
            "id": "",  //追加id
            "class": "",  //追加class
            "pageSize":"10",
            "pageId":"",
            "callback":null,
            "isWrap" : true
        }
        var options = $.extend(defaults, options);
        var idm = jQuery(this).attr("id") || jQuery(this).attr("name");
		if(!idm){
			return jQuery(this);
		}
        return this.each(function(){
        /*
            $(this)
                .wrap("<div class='K13_select'></div>")  //模块包裹
                .before("<div class='K13_select_checked'><input class='_pageSizeInput' AUTOCOMPLETE='off' style='width:"+options.width+";background:transparent;text-align:center;border:1px solid transparent;color:#fff;height:26px;vertical-align:top;' type='text' value='"+options.pageSize+"' name='" + idm + "inputText' id='" + idm+ "inputText'/></div><div class='K13_select_list'><ol></ol></div>")  // 插入结构及默认选中的内容
                .children("option")  //将默认选项内容添加至自定义结构中
                    .each(function () {
                        $(this)
                            .parent("select").siblings(".K13_select_list").children("ol")
                                .append("<li>" + $(this).text() + "</li>");
                    })
                .end()  //返回之前操作
                .hide()  //隐藏select
                
                */
                
            if (options.isWrap == true) {
                $(this).wrap("<div class='K13_select'></div>"); 
                $(this).before("<div class='K13_select_checked'><input class='_pageSizeInput' AUTOCOMPLETE='off' maxLength=3 style='width:"+options.width+";background:transparent;text-align:center;border:1px solid transparent;color:#fff;height:26px;vertical-align:top;' type='text' value='"+options.pageSize+"' name='" + idm + "inputText' id='" + idm+ "inputText'/></div><div class='K13_select_list'><ol></ol></div>");
                
                $(this).children("option").each(function () {
                        $(this).parent("select").siblings(".K13_select_list").children("ol")
                                .append("<li>" + $(this).text() + "</li>");
                }).end().hide();
                
            }
            $(this).parent(".K13_select")
                    .click(function () {  //模拟点击下拉菜单
//                        $(this).css("z-index","10000").children(".K13_select_list").slideToggle("fast");
                        $(this).css("z-index","19999").children(".K13_select_list").toggle();
                        if(document.documentMode==5){
                        	$(this).children(".K13_select_list").width($(this).width());
                        }
                    })
                    .mouseleave(function () {  //鼠标一开下拉关闭
//                        $(this).css("z-index","9999").children(".K13_select_list").slideUp("fast");
                        $(this).css("z-index","99").children(".K13_select_list").hide();
                    })
                .children(".K13_select_list").find("li")
                    .click(function (e) {  //点击模拟下拉选项，改变select选项值和显示选中内容
                        $(this).parents(".K13_select_list").siblings(".K13_select_checked")
                                .find("input").val(($(this).text()))
                            .siblings("select").children("option").eq($(this).index())
                                .attr("selected",true)
                            .siblings("option")
                                .attr("selected",false);
                        var inputtext = jQuery("#" + idm + "inputText");
						inputtext.val(jQuery(this).text());	
						savePageSize(e,inputtext,options.pageId,true);
                    }).hover(function(){
                    	jQuery(this).addClass("hover");
                    },function(){jQuery(this).removeClass("hover")});
                var height = $(".K13_select_list").height();
                if(!height)height = 124;
				$(".K13_select_list").css("padding-bottom", "1px");
				var _top = jQuery("#"+idm+"inputText").offset().top;
				if(_top<=height+1){
					_top = jQuery("#"+idm+"inputText").height()+5;
				}else{
					_top = -(height+1);
				}
				$(".K13_select_list").css("top", _top + "px");
            if (options.width) {
                $(this).parent(".K13_select").css("width",options.width);
            }

            if (options.id) {
                $(this).parent(".K13_select").attr("id",options.id)
            }
            /*if (options.class) {
                $(this).parent(".K13_select").addClass(options.class);
            }*/
            
            if(!!options.callback){
				jQuery("#" + idm + "inputText").bind("keyup",function(e){
					options.callback(e,this,options.pageId)
				}).bind("keypress",function(e){
						if((e.keyCode<48&&e.keyCode!=8&&e.keyCode!=13&&e.keyCode!=0) || e.keyCode>57)return false;
					});
			}

        })     
    };
})(jQuery);