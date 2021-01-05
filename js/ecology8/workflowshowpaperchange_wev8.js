(function($){
    $.fn.selectForK13 = function(options){
        var defaults = {
            "width": "", 
            "id": "",  
            "class": "",  
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
            if (options.isWrap == true) {
	            $(this).wrap("<div class='K13_select'></div>"); 
	            $(this).before("<div class='K13_select_checked'><input class='_pageSizeInput' AUTOCOMPLETE='off' maxLength=3 style='width:"+options.width+";background:transparent;text-align:center;border:1px solid transparent;color:#fff;height:26px;vertical-align:top;' type='text' value='"+options.pageSize+"' name='" + idm + "inputText' id='" + idm+ "inputText'/></div><div class='K13_select_list'><ol></ol></div>");
	            
	            $(this).children("option").each(function () {
                        $(this).parent("select").siblings(".K13_select_list").children("ol")
                                .append("<li>" + $(this).text() + "</li>");
                }).end().hide();
	            
            }
            $(this).parent(".K13_select")
                    .click(function () {  
                        $(this).css("z-index","10000").children(".K13_select_list").toggle();
                        if(document.documentMode==5){
                        	$(this).children(".K13_select_list").width($(this).width());
                        }
                    })
                    .mouseleave(function () { 
                        $(this).css("z-index","99").children(".K13_select_list").hide();
                    })
                .children(".K13_select_list").find("li")
                    .click(function (e) {
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


var kkpager = {
		//divID
		pagerid : 'div_pager',
		//当前页码
		pno : 1,
		//总页码
		total : 1,
		pageId:"SIGNVIEW_VIEWID",
		pagesize:'5',
		//总数据条数
		totalRecords : 0,
		//是否显示总页数
		//isShowTotalPage : false,
		//是否显示总记录数
		//isShowTotalRecords : false,
		//是否显示页码跳转输入框
		isGoPage : false,
		//链接前部
		hrefFormer : '',
		//链接尾部
		hrefLatter : '',
		/****链接算法****/
		getLink : function(n){
			//这里的算法适用于比如：
			//hrefFormer=http://www.xx.com/news/20131212
			//hrefLatter=.html
			//那么首页（第1页）就是http://www.xx.com/news/20131212.html
			//第2页就是http://www.xx.com/news/20131212_2.html
			//第n页就是http://www.xx.com/news/20131212_n.html
			if(n == 1){
				return this.hrefFormer + this.hrefLatter;
			}else{
				return this.hrefFormer + '_' + n + this.hrefLatter;
			}
		},
		//跳转框得到输入焦点时
		focus_gopage : function (){
			var btnGo = jQuery('#btn_go' + this.pagerid);
			jQuery('#btn_go_input' + this.pagerid).attr('hideFocus',true);
			btnGo.show();
			btnGo.css('left','0px');
			btnGo.css('margin-top','1px');
			btnGo.css('z-index','100');
			jQuery('#go_page_wrap' + this.pagerid).css('border-color','#6694E3');
			btnGo.animate({left: '+=30'}, 50,function(){
				//jQuery('#go_page_wrap').css('width','88px');
			});
		},
		
		//跳转框失去输入焦点时

		blur_gopage : function(){
			setTimeout(function(){
				var btnGo = jQuery('#btn_go' + this.pagerid);
				//jQuery('#go_page_wrap').css('width','44px');
				btnGo.animate({
				    left: '-=44'
				  }, 100, function() {
					  jQuery('#btn_go' + this.pagerid).css('left','0px');
					  jQuery('#btn_go' + this.pagerid).hide();
					  jQuery('#go_page_wrap' + this.pagerid).css('border-color','#DFDFDF');
				  });
			},400);
		},
		//跳转框页面跳转
		gopage : function(){
			var str_page = jQuery("#btn_go_input" + this.pagerid).val();
			if(isNaN(str_page)){
				jQuery("#btn_go_input" + this.pagerid).val(this.next);
				return;
			}
			var n = parseInt(str_page);
			if(n < 1){
				jQuery("#btn_go_input" + this.pagerid).val(this.next);
				return;
			}
			if(n >this.total){
				jQuery("#btn_go_input" + this.pagerid).val(this.pno);
				return;
			}
			//这里可以按需改window.open
			//window.location = this.getLink(n);
			flipOver(4,n);
		},
		//分页按钮控件初始化
		init : function(config){
			this.pagerid = !!!config.pagerid ? 'div_pager' : config.pagerid;
			//赋值
			this.pno = isNaN(config.pno) ? 1 : parseInt(config.pno);
			this.total = isNaN(config.total) ? 1 : parseInt(config.total);
			this.pagesize = isNaN(config.pagesize) ? 5 : parseInt(config.pagesize);
			this.totalRecords = isNaN(config.totalRecords) ? 0 : parseInt(config.totalRecords);
			if(config.pagerid){this.pagerid = config.pagerid;}
			if(config.isShowTotalPage != undefined){this.isShowTotalPage=config.isShowTotalPage;}
			if(config.isShowTotalRecords != undefined){this.isShowTotalRecords=config.isShowTotalRecords;}
			if(config.isGoPage != undefined){this.isGoPage=config.isGoPage;}
			this.hrefFormer = config.hrefFormer || '';
			this.hrefLatter = config.hrefLatter || '';
			if(config.getLink && typeof(config.getLink) == 'function'){this.getLink = config.getLink;}
			//验证
			if(this.pno < 1) this.pno = 1;
			this.total = (this.total <= 1) ? 1: this.total;
			if(this.pno > this.total) this.pno = this.total;
			this.prv = (this.pno<=2) ? 1 : (this.pno-1);
			this.next = (this.pno >= this.total-1) ? this.total : (this.pno + 1);
			this.hasPrv = (this.pno > 1);
			this.hasNext = (this.pno < this.total);
			this.inited = true;
		},
		//生成分页控件Html
		generPageHtml : function(){

			if(!this.inited){
				return;
			}
			
			var str_prv='',str_next='';
			if(this.hasPrv){
				str_prv="<span style='padding:0px;margin:0px;font-weight:normal;' class=\"e8_numberspan weaverTablePrevPage weaverTablePage\" id=\""+this.pagerid+"-pre\" onClick=\"javascript:flipOver(4,"+this.prv+")\">&lt;</span>";
			}else{
				str_prv='<span style="padding:0px;margin:0px;font-weight:normal;" class=\"e8_numberspan weaverTablePrevPageOfDisabled weaverTablePage\">&lt;</span>';
			}
			var dot = '<span>...</span>';
			if(this.hasNext){
				str_next = "<span class=\"e8_numberspan weaverTableNextPage weaverTablePage\" style='padding:0px;margin:0px;font-weight:normal;' id=\""+this.pagerid+"-next\" onClick=\"javascript:flipOver(4,"+this.next+")\">&gt;</span>";
			}else{
				str_next = '<span style="padding:0px;margin:0px;font-weight:normal;" class=\"e8_numberspan weaverTableNextPageOfDisabled weaverTablePage\">&gt;</span>';
			}			
			var str = '';
			var total_info='';
			//设置每页大小
			var selPageId = "pageSizeSel" + this.pagerid;
			var pageSizeInput = "<select class='_pageSize' id='"+selPageId+"' name='"+selPageId+"' style=\"font-weight:normal;background:transparent;border:none;width:50px;text-align:center;TEXT-DECORATION:none;height:20px;padding-right:2px;margin-left:5px;margin-right:5px;line-height:20px;display:none;\">"+
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
			total_info="<span class=\"e8_splitpageinfo\" style='padding:0px;margin:0px;font-weight:normal;'><span style=\"font-weight:normal;padding:0px;margin:0px;position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;\">"+pageSizeInput+SystemEnv.getHtmlNoteName(3585,languageid)+"&nbsp;|&nbsp;"+SystemEnv.getHtmlNoteName(3586,languageid)+this.totalRecords+SystemEnv.getHtmlNoteName(3524,languageid)+"</span></span><span class=\"e8_splitpageinfo\" style='padding:0px;margin:0px;'>&nbsp;</span>";
			//}
			var gopage_info = '';
			if(this.isGoPage){
				gopage_info = '<span class=\"e8_numberspan\" style="font-weight:normal;padding:0px;margin:0px;">'+SystemEnv.getHtmlNoteName(3525,languageid)+'</span><span class=\"e8_numberspan\"  style="font-weight:normal;display:inline-block;width:30px;height:20px;border:0px solid #DFDFDF;margin:-1px 1px;padding:0px;position:relative;left:0px;top:5px;">'+
					'<input type="button" id="btn_go' + this.pagerid + '" class="btn_go" onclick="kkpager.gopage();" style="font-weight:normal;width:30px;height:22px;line-height:22px;padding:0px;font-family:arial,宋体,sans-serif;text-align:center;border:0px;background-color:#0063DC;color:#FFF;position:absolute;left:0px;top:-1px;display:none;" value="'+SystemEnv.getHtmlNoteName(3588	,languageid)+'" />'+
					'<input type="text" id="btn_go_input' + this.pagerid + '" class="btn_go_input"  onfocus="kkpager.focus_gopage()" onkeypress="if(event.keyCode<48 || event.keyCode>57)return false;" onblur="kkpager.blur_gopage()" style="background-color:#f8f8f8;font-weight:normal;width:30px;height:20px;text-align:center;border:1px;position:absolute;left:0px;top:0px;outline:none;" value="'+this.pno+'" /></span>'+
				    '<span class=\"e8_numberspan\"  style="font-weight:normal;padding:0px;margin:0px;">'+SystemEnv.getHtmlNoteName(3526	,languageid)+'</span>';
			}
			
			//分页处理
		    var z_index = parseInt(this.pno) - 1;
		    var y_num = parseInt(this.pno) + 2;
		    var tempCent = "";
		    var tempLeft = "";
		    var tempRight = "";
			if (z_index > 1) {
		        tempLeft += "<span class=\"e8_numberspan\" style='font-weight:normal;padding:0px;margin:0px;'  _jumpTo=\"" + this.pagerid + "\" onClick=\"javascript:flipOver(4,1)\">1</span>";;
		    }
		    if (z_index > 2) {
		        tempLeft += "<span class=\"e8_numberspan\" style='font-weight:normal;padding:0px;margin:0px;'>&nbsp;...&nbsp;</span>";
		    }
		    
		    if (y_num < (this.total - 1)) {
		        tempRight += "<span class=\"e8_numberspan\"  style='font-weight:normal;padding:0px;margin:0px;'>&nbsp;...&nbsp;</span>";
		    }
		    
		    if (y_num < this.total) {
		        tempRight += "<span class=\"e8_numberspan weaverTableNextPage\" style='padding:0px;margin:0px;font-weight:normal;' id=\""+this.pagerid+"-next\" onClick=\"javascript:flipOver(4,"+this.total+")\">"+this.total+"</span>";
		    }
		    
		    for(;z_index<=y_num; z_index++) {
		        if (z_index>0 && z_index<=this.total) {
		            if (z_index == this.pno) {
		                tempCent +="<span  _jumpTo=\"" + this.pagerid + "\" style='font-weight:normal;padding:0px;margin:0px;' onClick=\"javascript:flipOver(4," +z_index+ ")\" class=\"e8_numberspan weaverTableCurrentPageBg\" >" +z_index+ "</span>";
		            } else {
		                tempCent +="<span class=\"e8_numberspan\" style='font-weight:normal;padding:0px;margin:0px;' _jumpTo=\"" + this.pagerid + "\" onClick=\"javascript:flipOver(4,"+z_index+")\">" +z_index+ "</span>";
		            }
		        }
		    }		    
		    str = tempLeft + tempCent + tempRight;
			str = "<div align='right' ><span class='e8_pageinfo' style='font-weight:normal;padding:0px;margin:0px;'>"+str_prv + str + str_next + gopage_info + total_info +"</span></div>";
			jQuery("#"+this.pagerid).html(str);
			jQuery("#pageSizeSel" + this.pagerid).selectForK13({
				"width":"40px",
				pageSize:this.pagesize,
				pageId:this.pageId,
				callback:savePageSize,
				isWrap:false
			});
		}
};
function getParameter(name) { 
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|jQuery)"); 
	var r = window.location.search.substr(1).match(reg); 
	if (r!=null) return unescape(r[2]); return null;
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
 			window.top.Dialog.alert("每页记录数必须不小于"+minPageSize+"条！");
 			return;
 		}else{
 			if(pageSize!=0&&pageSize>maxPageSize){
 				jQuery(obj).val(maxPageSize);
	 			window.top.Dialog.alert("每页记录数必须不大于"+maxPageSize+"条！");
	 			return;
 			}
 		}
 		if(!!pageId){
 			// try{
		   	//	var flag = e8beforeJump();
		   	//	if(!flag)return;
		    // }catch(e){}	
	 		jQuery.ajax({
	 			url:"/weaver/weaver.common.util.taglib.ShowColServlet?src=savePageSize",
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
	 						
	 						/*
	 						if(jQuery("span#searchblockspan",parent.document).find("img:first").length>0){
	 							jQuery("span#searchblockspan",parent.document).find("img:first").click();
	 						}else{
	 							reloadPage();
	 						}
	 						*/
	 						wfsignlddtcnt = pageSize;
	 						flipOver(-1);
	 					}catch(e){
	 						//window.location.reload();
	 					}
	 				}
	 			},
	 			failure:function(xhr,status,e){
	 				window.top.Dialog.alert("出现错误！记录保存失败！");
	 			}
	 		});
 		}else{
 			window.top.Dialog.alert("未定义页面ID！记录保存失败！");
 			return;
 		}
 	}else if(event.type.toLowerCase()=="keyup"){
 		if(pageSize<0){
 			jQuery(obj).val(defaultPageSize);
 		}
 	}
 }
