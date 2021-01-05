/**
 * Created with JetBrains WebStorm.
 * User: john
 * Date: 13-9-22
 * Time: 下午2:21
 * To change this template use File | Settings | File Templates.
 */
/**
 * 自定义权限设置组件
 */
var rightsplugingForBrowser = (function () {

    var constrctxml ="<input type='hidden' id='systemIds' name='systemIds'/>"+
    	"<input type='hidden' id='delsystemIds' name='delsystemIds'/>"+
        "<div class='e8_box_s'>" +
        	"<table class='e8_box_srctop e8_box_topmenu'  style='border-collapse: collapse;width:101%;'></table>" +
            "<div style='position:relative;'><div id='src_box_middle' class='e8_box_middle'>" +
            "<table class='e8_box_source' id='e8_src_table' style='border-collapse: collapse;width:100%;'>" +
            "</table>" +
            "</div><div id='src_bottom_scroll_flag' style='display:none;background-color:#00f;width: 100%;height: 20px;position: absolute;left: 0px;bottom: -10px;'></div></div>" +
            "<div class='e8_box_src e8_box_bottommenu' style='display:none;'></div>" +
            "</div><div class='e8_box_slice'><div class='e8_box_topmenu' style='border-bottom:2px solid #b7e0fe;background-color:rgb(248,248,248);'></div>" +
            "<div style='position:absolute;left:14px;top:18px;'><img id='singleArrowTo' title='"+SystemEnv.getHtmlNoteName(3518,readCookie("languageidweaver"))+"' class='e8_box_mutiarrow e8_first_arrow e8_box_disabled' src='/js/dragBox/img/4_wev8.png' ></div>" +
            "<div style='position:absolute;left:14px;top:121px;'><img id='singleArrowFrom' title='"+SystemEnv.getHtmlNoteName(3519,readCookie("languageidweaver"))+"' class='e8_box_mutiarrow e8_box_disabled' src='/js/dragBox/img/5_wev8.png' ></div>" +
            "<div style='position:absolute;left:14px;bottom:58px;' id='multiArrowToDiv'><img id='multiArrowTo' title='"+SystemEnv.getHtmlNoteName(3407,readCookie("languageidweaver"))+SystemEnv.getHtmlNoteName(3518,readCookie("languageidweaver"))+"' class='e8_box_mutiarrow' src='/js/dragBox/img/6_wev8.png' ></div>" +
            "<div style='position:absolute;left:14px;bottom:10px;'><img id='multiArrowFrom' title='"+SystemEnv.getHtmlNoteName(3407,readCookie("languageidweaver"))+SystemEnv.getHtmlNoteName(3519,readCookie("languageidweaver"))+"' class='e8_box_mutiarrow e8_last_arrow' src='/js/dragBox/img/7_wev8.png' ></div>" +
            "</div><div class='e8_box_d' >" +
             " <table class='e8_box_desttop e8_box_topmenu' style='border-collapse: collapse;width:100%;'></table> " +
            "<div style='position:relative;'><div class='e8_box_middle' id='dest_box_middle'>" +
            "<table id='e8_dest_table' class='e8_box_target' style='border-collapse: collapse;width:100%;'> " +
            " </table>" +
            "</div></div>" +
            "<div class='e8_box_dest e8_box_bottommenu' style='display:none;'></div>" +
            "</div>";
	
	var isMouseDown = 0;
	var startIdx = -1;
	var endIdx = -1;
	var direct = 1;//往下
	var lastIdx = -1;
	var isMouseMove = 0;
	var isCtrlKey = false;

	var destIsMouseDown = 0;
	var destIsMouseMove = 0;
	var destStartIdx = -1;
	var destEndIdx = -1;
	var destDirect = 1;//往下
	var destLastIdx = -1;

	var maxPageSize = 1000000;
	var srcMap = null;
	var destMap = null;
	var srcMapKeys = [];
	var destMapKeys = [];
	var __research = true;
	var hasMore = false;
	var oldsrcMapKeys=[];
	
function setChecked(tr,target){
	tr = jQuery(tr);
	//if(tr.hasClass("e8_selected_tr"))return;
	var $obj = tr.find(":checkbox");
	var _checked =  $obj.attr("checked");
	 _checked = !_checked;
	 $obj.attr("checked",_checked);
	 var flag = false;
	 if(target==1){
		 if(!destMap)return;

		 if( destMap[$obj.attr("id")]){

		 	destMap[$obj.attr("id")].__checked = _checked;
         }

         //destMap[$obj.("id")].__checked =_checked;
		 if(_checked){//选中
			jQuery("#singleArrowFrom").attr("src","/js/dragBox/img/5-1_wev8.png").removeClass("e8_box_disabled");
		 }else{
			for(var key in destMap){
				var dataitem = destMap[key];
				if(!dataitem)continue;
				if(dataitem.__checked){
					flag = true;
					jQuery("#singleArrowFrom").attr("src","/js/dragBox/img/5-1_wev8.png").removeClass("e8_box_disabled");
					break;
				}
			}
			if(!flag){
				jQuery("#singleArrowFrom").attr("src","/js/dragBox/img/5_wev8.png").addClass("e8_box_disabled");
			}
		 }
	 }else{
		 if(!srcMap)return;
		 srcMap[$obj.attr("id")].__checked = _checked;
		 if(_checked){//选中
			jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4-1_wev8.png").removeClass("e8_box_disabled");
		 }else{
			for(var key in srcMap){
				var dataitem = srcMap[key];
				if(!dataitem)continue;
				if(dataitem.__checked && !dataitem.__state){
					flag = true;
					jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4-1_wev8.png").removeClass("e8_box_disabled");
					break;
				}
			}
			if(!flag){
				jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4_wev8.png").addClass("e8_box_disabled");
			}
		 }
	 }	
	if(_checked){
		tr.removeClass().addClass("e8_checked_tr");
	}else{
		tr.removeClass();
	}
}

var srcAvgWidth = 0;
var destAvgWidth = 0;
var __maxNumbers = 10;
var __extendPageSize = 30;
var __srcContainer = null;
var __stepSize = 40;

function scrollAndChecked(target,i){
	$("#"+target).scrollTop(__stepSize*i);
}

function initDataByPage(container,config,key){
	var checkitem;
	var delsystemIds = "";
	var heads = config.srchead;
	var checkbox = null;
	if(isNoData(srcMapKeys,srcMap)){//无待选项
		jQuery("#multiArrowTo").attr("src","/js/dragBox/img/6_wev8.png").addClass("e8_box_disabled");
	}else{
		jQuery("#multiArrowTo").attr("src","/js/dragBox/img/6-1_wev8.png").removeClass("e8_box_disabled");
	}
	if(isNoData(destMapKeys,destMap,true)){//无已选项
		jQuery("#multiArrowFrom").attr("src","/js/dragBox/img/7_wev8.png").addClass("e8_box_disabled");
	}else{
		jQuery("#multiArrowFrom").attr("src","/js/dragBox/img/7-1_wev8.png").removeClass("e8_box_disabled");
	}
	if(key){
		dataitem = srcMap[key];
		if(dataitem){
			var checkbox = jQuery(document.getElementById(key));
			if(checkbox.length>0){
				dataitem.__loaded = true;
				checkbox.attr("checked",false);
				checkbox.parent().parent().removeClass("e8_selected_tr");
				checkbox.parent().parent().css("display","");
			}else{
					checkitem=$("<td style='width: 28px;display:none;'></td>");
					var srcbox = jQuery("<input type='checkbox' >").attr("name","srcitem").css({
						"margin-left":"7px"
					});
					checkitem.append(srcbox);
					tr = $("<tr _index="+srcMapKeys.length+"></tr>");
					/*tr.bind("click",function(){
						setChecked(this);
					});*/
					if(destMapKeys && jQuery.inArray(srcMapKeys[i],destMapKeys)!=-1){
						tr.addClass("e8_selected_tr").css("display","none");
						srcbox.attr("checked",true);
						dataitem.__loaded = true;
						dataitem.__checked = true;
						dataitem.__state = true;
					}
					tr.hover(function(){
						if(!jQuery(this).hasClass("e8_checked_tr")&&!jQuery(this).hasClass("e8_selected_tr")){
							jQuery(this).addClass("e8_hover_tr");
						}
					},function(){
						jQuery(this).removeClass("e8_hover_tr");
					}).removeClass("e8_hover_tr");
					if(jQuery.browser.msie){
						tr.bind("dblclick",function(e){
							var trs = $("#src_box_middle").find("tr");
							trs.each(function(){
								var checked = jQuery(this).find(":checkbox").attr("checked");
								if(checked)
									setChecked(this);
							});
							var checkbox = jQuery(this).find("input[type='checkbox']");
							checkbox.attr("checked",true);
							srcMap[checkbox.attr("id")].__checked = true;
							jQuery("#singleArrowTo").trigger("click");
						});
					}
					tr.append(checkitem);
					srcMap[key].__loaded=true;
					var j = 0;
					var tdhtml = "";
					for (var item in dataitem) {
						if(item==="__state"||item==="__checked"||item==="__loaded")continue;
						if(item===config.hiddenfield)
						{
							if(delsystemIds){
								delsystemIds += ","+dataitem[item];
							}else{
								delsystemIds = dataitem[item];
							}
							srcbox.attr("id",dataitem[item]);
							checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
						}else
						{
							if(j==0){
								if(config.labelfield){
									srcMap["__nameKey"] = config.labelfield;
								}else{
									srcMap["__nameKey"] = item;
								}
								tdhtml += "<div class='contentTitle'>"+dataitem[item]+"</div>";
							}else{
								if(config.showHead){
									tdhtml+="<span class='otherInfo'>"+heads[j]+":"+dataitem[item]+"</span>";
								}else{
									tdhtml+="<span class='otherInfo'>"+dataitem[item]+"</span>";
								}
                             }
							 j++;
							 td = $("<td style='display:none;'>" + dataitem[item] + "</td>");
							 tr.append(td);
						}
					}
					td = $("<td style='padding:5px 5px 5px 10px;width:100%;'>" + tdhtml + "</td>");
                    
					var divitem=$("<div></div>").append(td.find(".otherInfo"));
        
		            td.append(divitem);

					tr.append(td);
					var moreBtn = container.find(".e8_box_source tbody tr.moreBtn");
					if(moreBtn.length>0){
						moreBtn.before(tr);
					}else{
						container.find(".e8_box_source").append(tr);
					}
			}
		}
		if(checkbox.length>0||!dataitem){
			return;
		}
	}
	//if(!nums)nums=__maxNumbers
	 for (var i = 0,j=0; i < srcMapKeys.length && (i<__extendPageSize); i++) {
		dataitem = srcMap[srcMapKeys[i]];
		if(!dataitem || dataitem.__loaded)continue;
		j++;
		checkitem=$("<td style='width: 28px;display:none;'></td>");
		var srcbox = jQuery("<input type='checkbox'>").attr("name","srcitem").css({
			"margin-left":"7px"
		});
		checkitem.append(srcbox);
		tr = $("<tr _index="+i+"></tr>");
		/*tr.bind("click",function(){setChecked(this)});*/
		if(destMapKeys && jQuery.inArray(srcMapKeys[i],destMapKeys)!=-1){
			tr.addClass("e8_selected_tr").css("display","none");
			srcbox.attr("checked",true);
			dataitem.__loaded = true;
			dataitem.__checked = true;
			dataitem.__state = true;
		}
		tr.hover(function(){
			if(!jQuery(this).hasClass("e8_checked_tr")&&!jQuery(this).hasClass("e8_selected_tr")){
				jQuery(this).addClass("e8_hover_tr");
			}
		},function(){
			jQuery(this).removeClass("e8_hover_tr");
		}).removeClass("e8_hover_tr");
		if(jQuery.browser.msie){
			tr.bind("dblclick",function(e){
				var trs = $("#src_box_middle").find("tr");
					trs.each(function(){
						var checked = jQuery(this).find(":checkbox").attr("checked");
						if(checked)
							setChecked(this);
					});
				var checkbox = jQuery(this).find("input[type='checkbox']");
				checkbox.attr("checked",true);
				srcMap[checkbox.attr("id")].__checked = true;
				jQuery("#singleArrowTo").trigger("click");
			});
		}
		tr.append(checkitem);
		srcMap[srcMapKeys[i]].__loaded=true;
		var j = 0;
		var tdhtml = "";
		for (var item in dataitem) {
			if(item==="__state"||item==="__checked"||item==="__loaded")continue;
			if(item===config.hiddenfield)
			{
				if(delsystemIds){
					delsystemIds += ","+dataitem[item];
				}else{
					delsystemIds = dataitem[item];
				}
				srcbox.attr("id",dataitem[item]);
				checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
			}else
			{
				if(j==0){
					if(config.labelfield){
						srcMap["__nameKey"] = config.labelfield;
					}else{
						srcMap["__nameKey"] = item;
					}
					tdhtml += "<div class='contentTitle'>"+dataitem[item]+"</div>";
				}else{
					if(config.showHead){
						tdhtml+="<span class='otherInfo'>"+heads[j]+":"+dataitem[item]+"</span>";
					}else{
						tdhtml+="<span class='otherInfo'>"+dataitem[item]+"</span>";
					}
				}
				j++;
				td = $("<td style='display:none;'>" + dataitem[item] + "</td>");
				tr.append(td);
			}
		}
		td = $("<td style='padding:5px 5px 5px 10px;width:100%;'>" + tdhtml + "</td>");

		var divitem=$("<div></div>").append(td.find(".otherInfo"));
        
		td.append(divitem);

		tr.append(td);
		container.find(".e8_box_source").append(tr);
	}
	var extendBtn = container.find(".e8_box_s").find("button#extendBtn");
	if(hasMore){
		if(extendBtn.length>0){
			extendBtn.html(SystemEnv.getHtmlNoteName(3520,readCookie("languageidweaver")).replace(/#\{count\}/g,20));
		}else{
			//var div = $("<div style='height:30px;line-height:40px;text-align:center;'></div>")
			var tr = $("<tr class='moreBtn'></tr>");
			var td = $("<td style='text-align:center;width:100%;border:none;'></td>");
			var extendBtn = $("<button type='button' id='extendBtn' class='extendBtn'></button>");
			extendBtn.html(SystemEnv.getHtmlNoteName(3520,readCookie("languageidweaver")).replace(/#\{count\}/g,20));
			extendBtn.bind("click",function(){
				  var srcurl = config.srcurl;
				  __extendPageSize += 20;
				  __srcContainer.refresh(srcurl);
				  __research = false;
			});
			td.append(extendBtn);
			tr.append(td);
			//div.append(extendBtn);
			//container.find(".e8_box_s div.e8_box_src").before(div);
			if(container.find("#e8_src_table").children("tbody").length ==0){
				container.find("#e8_src_table").append("<tbody></tbody>");
			}
			container.find("#e8_src_table").children("tbody").append(tr);

		}
	}else{
		extendBtn.closest("tr.moreBtn").remove();
	}
}

function isNoData(keys,dataMap,isDest){
	if(keys==null||keys.length==0)return true;
	if(isDest)return false;
	var noData = true;
	for(var i=0;i<keys.length;i++){
		var dataitem = dataMap[keys[i]];
		if(!isDest){
			if(!dataitem.__state){
				noData=false;
				break;
			}
		}else{
			if(dataitem.__state){
				noData=false;
				break;
			}
		}
	}
	return noData;
}

function initDestDataByPage(container,config,nums){
	var checkitem;
	if(!nums)nums=__maxNumbers
		var heads = config.srchead;
	if(isNoData(destMapKeys,destMap,true)){//无已选项
		jQuery("#multiArrowFrom").attr("src","/js/dragBox/img/7_wev8.png").addClass("e8_box_disabled");
	}else{
		jQuery("#multiArrowFrom").attr("src","/js/dragBox/img/7-1_wev8.png").removeClass("e8_box_disabled");
	}
	if(isNoData(srcMapKeys,srcMap)){//无待选项
		jQuery("#multiArrowTo").attr("src","/js/dragBox/img/6_wev8.png").addClass("e8_box_disabled");
	}else{
		jQuery("#multiArrowTo").attr("src","/js/dragBox/img/6-1_wev8.png").removeClass("e8_box_disabled");
	}
	setDestNumber(config);
	for (var i = 0,j=0; i < destMapKeys.length; i++) {
		dataitem = destMap[destMapKeys[i]];
		if(!dataitem || dataitem.__loaded)continue;
		j++;
		checkitem=$("<td style='width: 28px;display:none;'></td>");
		var destbox = jQuery("<input type='checkbox'>").attr("name","destitem").css({
			"margin-left":"7px"
		});
		checkitem.append(destbox);
		tr = $("<tr _index="+i+"></tr>");
		/*tr.bind("click",function(){
			setChecked(this, 1);
		});*/
		tr.hover(function(){
			if(!jQuery(this).hasClass("e8_checked_tr")&&!jQuery(this).hasClass("e8_selected_tr")){
				jQuery(this).addClass("e8_hover_tr");
			}
		},function(){
			jQuery(this).removeClass("e8_hover_tr");
		});
		if(jQuery.browser.msie){
			tr.bind("dblclick",function(e){
				var trs = $("#dest_box_middle").find("tr");
				trs.each(function(){
					var checked = jQuery(this).find(":checkbox").attr("checked");
					if(checked)
						setChecked(this,1);
				});
				var checkbox = jQuery(this).find("input[type='checkbox']");
				checkbox.attr("checked",true);
				destMap[checkbox.attr("id")].__checked = true;
				jQuery("#singleArrowFrom").trigger("click");
			}).disableSelection();
		}
		tr.append(checkitem);
		destMap[destMapKeys[i]].__loaded=true;
		var j = 0;
		var tdhtml = "";
		for (var item in dataitem) {
			if(item==="__state"||item==="__checked"||item==="__loaded")continue;
			if(item===config.hiddenfield)
			{
				checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
				destbox.attr("id",dataitem[item]);
			}else
			{
				if(j==0){
					if(config.labelfield){
						destMap["__nameKey"] = config.labelfield;
					}else{
						destMap["__nameKey"] = item;
					}
					tdhtml += "<div class='contentTitle'>"+dataitem[item]+"</div>";
				}else{
					if(config.showHead){
						tdhtml+="<span class='otherInfo'>"+heads[j]+":"+dataitem[item]+"</span>";
					}else{
						tdhtml+="<span class='otherInfo'>"+dataitem[item]+"</span>";
					}
				}
				j++;
				td = $("<td style='display:none;'>" + dataitem[item] + "</td>");
				tr.append(td);
			}
		}
		var dragDiv = $("<div class='e8_dragDiv'></div>");
		td = $("<td style='padding:5px 5px 5px 10px;100%;position:relative;'>" + tdhtml + "</td>");
		
		var divitem=$("<div></div>").append(td.find(".otherInfo"));
        td.append(divitem);
		
		//td.append(dragDiv);
		tr.append(td);

		container.find(".e8_box_target").append(tr);
	}
}


    function PageInfo() {
        this.pagesize = 20;
        this.currentpage = 1;
        this.totalpage = "";
    }
    
    function createOrRefreshScrollBar(div,config,option){
    	//初始化滚动条
        //jQuery("#inner_"+div).height(jQuery("#inner_"+div).children("table").height());
        //console.log(jQuery("#"+div+":first",config.currentWindow.document));
        //console.log(option);
		var nicescroll = jQuery(document.getElementById(div)).getNiceScroll();
        if(!!option || (nicescroll && nicescroll.length>0)){
			if(!option)option="update";
        	jQuery("#"+div,config.currentWindow.document).perfectScrollbar(option);
        }else{
        	jQuery("#"+div,config.currentWindow.document).perfectScrollbar({horizrailenabled:false,zindex:0});
        }
		if(__research){
			jQuery("#"+div,config.currentWindow.document).scrollTop(0);
		}
    }
    
    function registerDragEvent(config,refresh){
    	 var fixHelper = function(e, ui) {  
            ui.children().each(function() {  
                $(this).width($(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
            });  
            return ui;  
        };  
         jQuery("#e8_dest_table tbody",config.currentWindow.document).sortable({                //这里是talbe tbody，绑定 了sortable  
             helper: fixHelper,                  //调用fixHelper  
             axis:"y",  
			/*handle: ".e8_dragDiv",*/
             start:function(e, ui){  
                 ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper
				 _top = e.clientY-$("#dest_box_middle").offset().top+$("#dest_box_middle").perfectScrollbar("getScrollTop")-ui.helper.height()/2;
				 ui.helper.css("top",_top);
                 return ui;  
             }, 
			sort:function(e,ui){
				 _top = e.clientY-$("#dest_box_middle").offset().top+$("#dest_box_middle").perfectScrollbar("getScrollTop")-ui.helper.height()/2;
				 ui.helper.css("top",_top);
			 },
             stop:function(e, ui){  
                 //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
                 jQuery(ui.item).hover(function(){
                	jQuery(this).addClass("e8_hover_tr");
                },function(){
                	jQuery(this).removeClass("e8_hover_tr");
                });
				if(ui.item.hasClass("e8_checked_tr")){
					setChecked(ui.item,1);
				}
                 appendToArray(jQuery(ui.item).find('input[type=hidden]').val(),config,ui.item.get(0).rowIndex);
                 return ui;  
             }  
         }).disableSelection();  
    }
    
    function appendToArray(id,config,order){
    	if(id){
	    	var systemids = jQuery("#systemIds",config.currentWindow.document).val();
	    	var delsystemids = jQuery("#delsystemIds",config.currentWindow.document).val();
	    	//需要考虑重复元素添加
	    	if(systemids){
	    		var systemidsarr = systemids.split(",");
	    		var delsystemidsarr = delsystemids.split(",");
	    		var idArr = id.split(",");
	    		systemidsarr = uniq(systemidsarr);
	    		for(var i=0;i<idArr.length;i++){
		    		if(order || order==0){
						if(destMapKeys!=null){
							destMapKeys.splice(jQuery.inArray(idArr[i],destMapKeys),1);
							destMapKeys.splice(order,0,idArr[i]);
						}
		    		}else{
		    			order = systemidsarr.length;
		    		}
		    		if(jQuery.inArray(idArr[i],delsystemidsarr)>-1){
		    			delsystemidsarr.splice(jQuery.inArray(idArr[i],delsystemidsarr),1);
		    		}
		    		if(jQuery.inArray(idArr[i],systemidsarr)>-1){
		    			systemidsarr.splice(jQuery.inArray(idArr[i],systemidsarr),1);
		    		}
		    		delsystemidsarr = uniq(delsystemidsarr);
		    		systemidsarr.splice(order,0,idArr[i]);
	    		}
	    		systemids = systemidsarr.join(",");
	    	}else{
	    		systemids = id;
	    		var delsystemidsarr = delsystemids.split(",");
	    		var idArr = id.split(",");
	    		for(var i=0;i<idArr.length;i++){
		    		delsystemidsarr.splice(jQuery.inArray(id,delsystemidsarr),1);
		    		delsystemidsarr = uniq(delsystemidsarr);
	    		}
	    	}
			
	    	jQuery("#delsystemIds",config.currentWindow.document).val(delsystemidsarr.join(","));
	    	jQuery("#systemIds",config.currentWindow.document).val(systemids);
			setDestNumber(config);//解决IE11下确认按钮数字不变的问题
	    }
    }
    
    function removeFromArray(id,config){
    	if(id==null)return;
    	var systemids = jQuery("#systemIds",config.currentWindow.document).val();
    	 var delsystemids = jQuery("#delsystemIds",config.currentWindow.document).val();
          if(delsystemids){
          	delsystemids +=","+id;
          }else{
          	delsystemids = id;
          }
          //去重
        var delsystemids = uniq(delsystemids.split(",")).join(",");
        jQuery("#delsystemIds",config.currentWindow.document).val(delsystemids);
    	var idArr = id.split(",");
    	if(systemids){
    		var systemidsarr = systemids.split(",");
    		for(var i=0;i<idArr.length;i++){
    			systemidsarr.splice(jQuery.inArray(idArr[i],systemidsarr),1);
    		}
    		systemids = systemidsarr.join(",");
    		jQuery("#systemIds",config.currentWindow.document).val(systemids);
    	}
		setDestNumber(config);//解决IE11下确认按钮数字不变的问题
    }
    
    //去重
    function uniq(array) {
		var map={};
		var re=[];
		for(var i=0,l=array.length;i<l;i++) {
			if(typeof map[array[i]] == "undefined"){
				map[array[i]]=1;
				re.push(array[i]);
			}
		}
		return re;
	}
    

    /**
     * 配置信息
     * @constructor
     */
    function Config() {
        //容器对象
        this.container = {};
        //数据源标签
        this.srchead = [];
        //数据源字段名
        this.srcfield = [];
        //搜索框名称
        this.searchLabel="";
        //隐藏字段(一般为id字段)
        this.hiddenfield="";
        //数据源url
        this.srcurl = "";
        //目标url
        this.desturl = "";
        //保存路径
         this.saveurl="";
        //删除路径
          this.delteurl="";
        //每页条数
        this.pagesize = 10;
        //是否延迟保存
        this.saveLazy = false;
        //实际窗口
        this.currentWindow = window;
        
        this.selectids = "";

		this.targetDocument = document;
		
		//若提供该方法，则调用自定义方法进行数据处理，该方法传递4个参数，config对象、选中的json对象，构造好的值选项、选中json对象的key值数组。
		//确定方法
		this.okCallbackFn = null;
		
		//清除方法
		this.clearCallbackFn = null;
		
		//自定义格式化数据，该方法传递3个参数，config对象、选中json对象的key值数组、选中的json对象，需返回一个json结构，格式固定：{id:"1,2,3",name:"李,张,王"}
		this.formatCallbackFn = null;
		
		//返回用显示字段
		this.labelfield = "";
		
		//确定按钮的标识
		this.okBtnId = "#btnok";
		
		//是否需要全部添加的按钮
		this.needAllAddBtn = true;
    }

    /**
     * 注册向右拖拉事件
     */
    function registerArrowEvent(config,srccontainer) {
        var container = config.container;
        var  hiddenid=config.hiddenfield;
        container.find("#singleArrowTo").click(function () {
        	joinTarget(config,srccontainer,false,container);
        });

    }
    
    function setDestNumber(config){
    	var btnok = jQuery(config.okBtnId);
    	if(btnok.length==0 || !btnok.is(":visible"))btnok=jQuery("#btn_Ok");
		var value = btnok.val();
		if(value){
			if(!value.match(/\d+/)){
				value = value+"("+destMapKeys.length+")"
			}else{
				value = value.replace(/\d+/g,destMapKeys.length);
			}
			btnok.val(value);
		}
    }
    
    function delTarget(config,src,isAll,container,hiddenfield,options){
    	__research = false;
    	if(!!!container){
    		container = config.container;
    	}
    	if(!!!hiddenfield){
    		hiddenfield = config.hiddenfield
    	}
		var e8_box_srctop = container.find(".e8_box_srctop");
    	var destMapTmp ={};
		var srclength = 0;
		var destlength = 0;
		 destMapTmp = destMap;
		 var length = destMapKeys.length;
		if(length==0)return;
    	if(isAll){
    		for(var key in destMapTmp){
					destMapTmp[key].__checked = true;
			}
    	}
    	if(!srcMap)srcMap = {};
		if(!srcMap["__nameKey"])srcMap["__nameKey"] = destMap["__nameKey"];
           var ids="";
           var array=[];
           var systemids = "";
		   var src_table = jQuery("#e8_src_table");
			var src_tbody = src_table.children("tbody");
			var dest_table = jQuery("#e8_dest_table");
			var dest_tbody = dest_table.children("tbody");
			for(var key in destMapTmp){
				if(key==="length"||key==="__nameKey")continue;
				var ditem = destMapTmp[key];
				if(ditem.__checked){
					if (destMap[key].__loaded){
                        dest_table.find("input[name='destitem']").each(function(){
                        	if($(this).attr("id")==key){
                        		$(this).parent().parent().remove();
							}
						});
                        //jQuery("#dest_box_middle").find("#"+key).parent().parent().remove();
					}
					delete destMap[key];
					if(jQuery.inArray(key,destMapKeys)!=-1){
						destMapKeys.splice(jQuery.inArray(key,destMapKeys),1);
					}
					if(!srcMap[key]){
						srcMap[key] = jQuery.extend({},ditem);
					}
					srcMap[key].__state = false;
					srcMap[key].__checked = false;
					srcMap[key].__loaded = false;
					if(jQuery.inArray(key,srcMapKeys)==-1){
						srcMapKeys.push(key);
					}
					//var trLen = src_tbody.children("tr").length;
					//if(trLen<10){
						initDataByPage(container,config,key);
						 createOrRefreshScrollBar("src_box_middle",config,"update");
					//}
					//var destTrLen = dest_body.children("tr").length;
					//if(destTrLen<10){
					//	initDestDataByPage(container,config);
					//}
					
					ids = ids+"&ID="+key;
					if(systemids){
						systemids+=","+key;
					}else{
						systemids = key;	
					}
				}
			}
			setDestNumber(config);
			jQuery("#singleArrowFrom").attr("src","/js/dragBox/img/5_wev8.png").addClass("e8_box_disabled");
			 var deleteurl = config.delteurl+ids;
            removeFromArray(systemids,config);
			if(config.saveLazy){
				deleteurl += "&systemIds="+jQuery("#delsystemIds",config.currentWindow.document).val();
			}
			__research = false;
			 createOrRefreshScrollBar("dest_box_middle",config,"update");
             createOrRefreshScrollBar("src_box_middle",config,"update");
    }
    
    function joinTarget(config,src,isAll,container,hiddenid,item,options){
    		if(!!!container){
	    		container = config.container;
	    	}
	    	if(!!!hiddenid){
	    		hiddenid = config.hiddenfield
	    	}			
	    	var target = container.find(".e8_box_target");
			var e8_box_desttop = container.find(".e8_box_desttop");
	        var clone;
	        var ids="";
	        var array=[];
	
	        /**
	         * 保存数据
	         * @param data
	         */
	        function  saveItems(data)
	        {
	            var rs=data;
	            if(rs.result==="1")
	            {
	               for(var i=0;i<array.length;i++)
	               {
	                   target.append(array[i]);
	               }
	
	            }else
	            {
	                top.Dialog.alert(SystemEnv.getHtmlNoteName(3521,readCookie("languageidweaver")));
	            }
	
	        }
            //var selectitems = [];
			var srcMapTmp ={};
			//var destMap = container.find(".e8_box_dest").data("dataMap");
			//if(!destMap)destMap = {};
			var srclength = 0;
			var destlength = 0;
			var length = 0;
            if(!!item){
            	srcMapTmp[item[hiddenid]] = item;
				length=1;
            }else{
				 srcMapTmp = srcMap;//container.find(".e8_box_src").data("dataMap");
				 length = srcMapKeys.length;
	        }
            if(length==0)return;
			if(isAll){
				for(var key in srcMapTmp){
					srcMapTmp[key].__checked = true;
				}
			}
			if(!destMap)destMap = {};
			if(!destMap["__nameKey"])destMap["__nameKey"] = srcMap["__nameKey"];
            var systemIds = "";
            var ids = "";
			var dest_table = jQuery("#e8_dest_table");
			var dest_tbody = dest_table.children("tbody");
			 var src_table = jQuery("#e8_src_table");
			var src_tbody = src_table.children("tbody");
			if(dest_tbody.length==0){
				dest_tbody = jQuery("<tbody>");
				dest_table.append(dest_tbody);
			}
			for(var i = 0 ;i<length;i++){
				var key = srcMapKeys[i];
				if(key=="length"||key=="__nameKey")continue;
				var sitem = srcMapTmp[key];
				if(sitem.__checked && !sitem.__state){
					srcMap[key].__state = true;
					srcMap[key].__checked = false;
					destMap[key] = jQuery.extend({},sitem);
					destMap[key] .__loaded = false;
					if(jQuery.inArray(key,destMapKeys)==-1){
						destMapKeys.push(key);
					}
					destMap[key].__checked = false;
					if(srcMap[key].__loaded){
                        jQuery(document.getElementById(key)).parent().parent().removeClass().addClass("e8_selected_tr");
                        jQuery(document.getElementById(key)).parent().parent().css("display","none");

                        //jQuery("#src_box_middle").find("#"+key).parent().parent().removeClass().addClass("e8_selected_tr");
						//jQuery("#src_box_middle").find("#"+key).parent().parent().css("display","none");
					}
					//delete srcMap[key];
					//if(dest_tbody.children("tr").length<10){
						initDestDataByPage(container,config);
						 createOrRefreshScrollBar("dest_box_middle",config,"update");
						 jQuery("#dest_box_middle").scrollTop(jQuery("#e8_dest_table").height())
					//}
					//if(src_tbody.children("tr").length<10){
					//	initDataByPage(container,config);
					//}
					 ids=ids+"&ID="+key;
					  if(systemIds){
							systemIds=key+","+systemIds;
						}else{
							systemIds = key;
						}
				}
			}
			jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4_wev8.png").addClass("e8_box_disabled");
           
			registerDragEvent(config);
            //此刻做数据存储
            var  saveurl= config.saveurl+ids;
            if(config.saveLazy){
            	saveurl += "&isNot=1"; 
            }
            //ajaxHandler(saveurl, "", saveItems, "json", false);
            var data = {};
            data.result = "1";
            saveItems(data);
			if(config.saveLazy){
            	appendToArray(systemIds,config);
            }
            var srcurl = config.srcurl;
            if(config.saveLazy){
            	srcurl += "&includeId="+jQuery("#delsystemIds",config.currentWindow.document).val()+"&excludeId="+jQuery("#systemIds",config.currentWindow.document).val();
            }
    }
    
    function getParams(config,params){
    	if(!!config.formId){
    		var _document = document;
    		if(!!config.target){
    			try{
    				_document = jQuery("#"+config.target,config.targetDocument).get(0).contentWindow.document;
    			}catch(e){
    				if(window.console)console.log(e);
    				_document = document;
    			}
    		}
        	var _params = jQuery("#"+config.formId,_document).formSerialize();
        	if(!!_params){
        		params=params+"&"+_params;
        	}
        }
        return params;
    }







    /**
     * 初始化源容器
     */
    function initSrcContainer(config,isSearch) {

        var container = config.container;
		//container.find(".e8_box_s").width((jQuery(window).width())*0.45-1);
		container.find(".e8_box_s").css("width","45%");
        var heads = config.srchead;
        var searchlabel=config.searchLabel;
        var  srctop= container.find(".e8_box_srctop");

        var swidth = container.find(".e8_box_s").css("width");
        swidth = parseInt(swidth.substring(0, swidth.indexOf("p"))) - 20;
        var pageinfo = new PageInfo();
		if(!parent.__pageSize__){
				parent.__pageSize__=10;
		}else{
				pageinfo.pagesize = parent.__pageSize__;
		}
		initThead();
        //td的平均宽度
        srcAvgWidth = (swidth / (heads.length == 0 ? 1 : heads.length)) + "px";
        var tr;
        var td;
        var dataitem;


        /**
         * 注册容器拖拉事件
         */
        function  registerDragAndDrop(config)
        {
        	 if(true){
        	 	jQuery(".e8_box_source tr",config.currentWindow.document).disableSelection();
        	 	return;
        	 }
            var  container=config.container;
            var  hiddenid=config.hiddenfield;
            //注册相应的拖拽事件
            jQuery(".e8_box_source tr",config.currentWindow.document).draggable({
                helper: "clone"
            }).disableSelection();
            //注册容器的释放事件
            container.find(".e8_box_d").droppable({
                drop: function (event, ui) {
                	
                    var clone=ui.draggable;
                    
                    var con=  $(this);
                    function  addItem(data)
                    {
                        //var rs=JSON.parse(data);
                        var rs = data;
                        if(rs.result==="1")
                        {
                            clone.removeAttr("class");
                            clone.find("input").attr("class", "e8_box_desitem");
                            clone.find("input[type=checkbox]").attr("name","destitem");
                            clone.find("input").removeAttr("checked");
                            clone.appendTo(con.find(".e8_box_target"));
                            clone.hover(function(){
			                	jQuery(this).addClass("e8_hover_tr");
			                },function(){
			                	jQuery(this).removeClass("e8_hover_tr");
			                });
							clone.bind("dblclick",function(e){
								jQuery(this).find("input[type='checkbox']").attr("checked",true);
								jQuery("#singleArrowFrom").trigger("click");
							}).disableSelection();
			                createOrRefreshScrollBar("dest_box_middle",config,"update");
                      		createOrRefreshScrollBar("src_box_middle",config,"update");
                      		registerDragEvent(config,true);
                        }
                        else
                            top.Dialog.alert(SystemEnv.getHtmlNoteName(3521,readCookie("languageidweaver")));

                    }

                    //此刻做数据存储
                    var  id=clone.find("input[name='"+hiddenid+"']").val();
                    var  saveurl= config.saveurl+"&ID="+id;
                    if(config.saveLazy){
                    	saveurl += "&isNot=1"; 
                    }
                    if(config.saveLazy){
                    	appendToArray(id,config);
                    }
                    //ajaxHandler(saveurl, "", addItem, "json", false);
                     var data = {};
		            data.result = "1";
		            addItem(data);
                    var srcurl = config.srcurl;
                    if(config.saveLazy){
                    	srcurl += "&includeId="+jQuery("#delsystemIds",config.currentWindow.document).val()+"&excludeId="+jQuery("#systemIds",config.currentWindow.document).val();
                    }
                     var params = "currentPage="+(parseInt(pageinfo.currentpage))+"&pageSize=" + pageinfo.pagesize;
        			params = getParams(config,params);
					ajaxHandler(srcurl, params, init, "json", false);
                }
            });

        }
        
		function initThead(){
			if( container.find(".e8_box_srctop").find("thead").length>0)return;
			 var thead = $("<thead></thead>");
            var tr = jQuery("<tr></tr>");
            //初始化行头
            for (var i = 0; i <=heads.length; i++) {
                if (i === 0){
                    tr.append("<td style='width: 28px;display:none;'><input type='checkbox' name='srcallitem' style='margin-left: 7px'></td>");
                }else if(i === 1){
	                td = $("<td style='text-align: left;padding-left:10px;'><span>"+SystemEnv.getHtmlNoteName(3503,readCookie("languageidweaver"))+"</span><span class='e8_clear_btn' id='clearBtn' title='"+SystemEnv.getHtmlNoteName(352,readCookie("languageidweaver"))+"'></span></td>");
					td.children("#clearBtn").bind("click",function(){
						var trs = $("#src_box_middle").find("tr.e8_checked_tr");
							trs.each(function(){
								setChecked(this);
							});
					});
				}else{
					td = $("<td style='text-align: left;padding-left:10px;display:none;'><span>"+SystemEnv.getHtmlNoteName(3503,readCookie("languageidweaver"))+"</span><span class='e8_clear_btn' id='clearBtn' title='"+SystemEnv.getHtmlNoteName(352,readCookie("languageidweaver"))+"'></span></td>");
				}
                tr.append(td);
            }
            //附加源行头
            thead.append(tr);
            container.find(".e8_box_srctop").append(thead);
		}

        function init(data) {
            //data = JSON.parse(data);
            //data = eval("("+data+")");
			srcMap = null;
			srcMapKeys  = [];
			var datas_idx = 0;
			var _datas_idx = 0;
            container.find(".e8_box_source").html("");
            container.find(".e8_box_src").html("");
            //container.find(".e8_box_srctop").html("");
			//initThead();
            //源端全选
            container.find("input[name='srcallitem']").click(function () {
                var isselect = $(this).is(':checked');
                var selectitems = container.find("input[type=checkbox][name='srcitem']");
                if (isselect) {
					for(var key in srcMap){
						srcMap[key].__checked = true;
					}
                    for (var i = 0; i < selectitems.length; i++) {
                        if( !$(selectitems[i]).is(':checked'))
                        //触发checkbox选中
							$(selectitems[i]).attr("checked",true);
                            //$(selectitems[i]).trigger("click");
                    }
                } else {
					for(var key in srcMap){
						srcMap[key].__checked = false;
					}
                    for (var i = 0; i < selectitems.length; i++) {
                        if($(selectitems[i]).is(':checked'))
                           $(selectitems[i]).attr("checked",false);
                    }
                }
            });
			if(!parent.__pageSize__){
				parent.__pageSize__=10;
			}else{
				pageinfo.pagesize = parent.__pageSize__;
			}
            //生成分页信息
            container.find(".e8_box_src").append("<div class='e8_box_pageinfo1'>"+SystemEnv.getHtmlNoteName(3523,readCookie("languageidweaver"))+"<select name='pagesize' id='srcpagesize' class='e8_box_pagesize' style='width:50px;'><option value='10' "+((!parent.__pageSize__||parent.__pageSize__==10)?"selected":"")+">10</option><option value='50' "+(parent.__pageSize__==50?"selected":"")+">50</option><option value='100' "+(parent.__pageSize__==100?"selected":"")+">100</option><option value='"+maxPageSize+"' "+(parent.__pageSize__==maxPageSize?"selected":"")+">"+SystemEnv.getHtmlNoteName(3507,readCookie("languageidweaver"))+"</option></select>"+SystemEnv.getHtmlNoteName(3524,readCookie("languageidweaver"))+"</div> <div class='e8_box_pageinfo2'>"+SystemEnv.getHtmlNoteName(3525,readCookie("languageidweaver"))+" " + data.currentPage + "/" + data.totalPage + " "+SystemEnv.getHtmlNoteName(3526,readCookie("languageidweaver"))+"</div> ");
            container.find(".e8_box_src").find("select[name='pagesize']").val(pageinfo.pagesize);
            container.find(".e8_box_src").find("select[name='pagesize']").change(function(){
                pageinfo.pagesize=$(this).val();
				parent.__pageSize__ = jQuery(this).val();
                //改变每页条数,将当前页置为1
                pageinfo.currentpage=1;
                var params = "includeId="+jQuery("#delsystemIds").val()+"&excludeId="+jQuery("#systemIds",config.currentWindow.document).val()+"&currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize;
        		params = getParams(config,params);
                ajaxHandler(config.srcurl, params, init, "json", true);

            });


            var pimg = $("<img class='e8_box_preimg'>");
            var nimg = $("<img class='e8_box_nextimg'>");
            if (data.currentPage > 1) {
                pimg.attr("src", "/js/dragBox/img/PreBtn2Up_wev8.png");
                pimg.click(function(){
                    var srcurl = config.srcurl;
                    if(config.saveLazy){
                    	var systemids = jQuery("#systemIds",config.currentWindow.document).val();
                    	srcurl += "&excludeId="+systemids;
                    }
                    var params = "currentPage="+(parseInt(pageinfo.currentpage)-1)+"&pageSize=" + pageinfo.pagesize;
        			params = getParams(config,params);
                    ajaxHandler(srcurl, params, init, "json", true);

                });
            } else
                pimg.attr("src", "/js/dragBox/img/PreBtn2Disable_wev8.png");

            if (data.currentPage < data.totalPage) {
                nimg.attr("src", "/js/dragBox/img/NextBtn2Up_wev8.png");
                nimg.click(function(){
                    var srcurl = config.srcurl;
                    if(config.saveLazy){
                    	var systemids = jQuery("#systemIds",config.currentWindow.document).val();
                    	srcurl += "&excludeId="+systemids;
                    }
                     var params = "currentPage="+(parseInt(pageinfo.currentpage)+1)+"&pageSize=" + pageinfo.pagesize;
        			params = getParams(config,params);
                    ajaxHandler(srcurl, params, init, "json", true);


                });
            } else
                nimg.attr("src", "/js/dragBox/img/NextBtn2Disable_wev8.png");
            container.find(".e8_box_src").append(pimg);
            container.find(".e8_box_src").append(nimg);
            pageinfo.totalpage = data.totalPage;
            pageinfo.currentpage = data.currentPage;
            var datas = data.mapList;
            var noRepeatResp = data['noRepeatResp'] ;
			if(!srcMap)srcMap = {};
			if(datas.length>__extendPageSize){
				hasMore = true;
			}else{
				hasMore = false;
			}
			var limitSize = (__extendPageSize == 30) ? 30 : 20 ;
			var add = 0 ;
			
			for(var i=0;i<datas.length;i++){
				if(hasMore && i==datas.length-1)continue;
				if(noRepeatResp == '1' && add >= limitSize) continue ;
				var dataitem = datas[i];
				var newdataitem = null;
				if(config.srcfield && config.srcfield.length>0){
					newdataitem = {};
					for(var j=0;j<config.srcfield.length;j++){
						newdataitem[config.srcfield[j]] = dataitem[config.srcfield[j]];
					}
				}else{
					newdataitem = dataitem;
				}
				srcMap[dataitem[config.hiddenfield]] = newdataitem;
				srcMapKeys.push(dataitem[config.hiddenfield]);
				if(destMapKeys && jQuery.inArray(dataitem[config.hiddenfield],destMapKeys)!=-1){
					// in dest
				}else if(oldsrcMapKeys && jQuery.inArray(dataitem[config.hiddenfield],oldsrcMapKeys)!=-1){
					// in src
				}else{
					add++ ;
				}
				dataitem["__state"] = false;
				dataitem["__checked"] = false;
			}
			srcMap["length"] = hasMore?datas.length-1:datas.length;
            
		   initDataByPage(container,config);
		    //注册拖拉事件
            registerDragAndDrop(config);
           // jQuery("#delsystemIds",this.currentWindow).val(delsystemIds);
            createOrRefreshScrollBar("src_box_middle",config);
			jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4_wev8.png").addClass("e8_box_disabled");
			/*container.find("#src_box_middle").mousewheel(function(e, delta, deltaX, deltaY){
				var pTop = jQuery(this).find(".ps-scrollbar-y").position().top;
				var pcHeight = jQuery(this).height();
				var psHeight = jQuery(this).find(".ps-scrollbar-y").height();
				if(window.console)console.log(pTop+"::"+psHeight+"::"+pcHeight);
				if(pcHeight<(psHeight+pTop)+10){
					initDataByPage(container,config);
					 createOrRefreshScrollBar("src_box_middle",config,"update");
				}
			});*/
            //jQuery(".e8_box_source").jNice();
        }
        if(!isSearch){
        	jQuery("#systemIds",config.currentWindow.document).val(config.selectids);
        }
        //var params = "systemIds="+jQuery("#systemIds",config.currentWindow.document).val()+"&currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize;
		var params = "pageSize=" + (__extendPageSize+1);
        params = getParams(config,params);
        ajaxHandler(config.srcurl, params, init, "json", true);
         return {

             refresh:function(srcurl)
             {
             	 if(srcurl==null){
             	 	srcurl = config.srcurl;
             	 }
             	 oldsrcMapKeys = srcMapKeys ; 
             	 //var params = "systemIds="+jQuery("#systemIds",config.currentWindow.document).val()+"&currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize;
				 var params = "pageSize=" +(__extendPageSize+1);
        		 params = getParams(config,params);
                 ajaxHandler(srcurl, params, init, "json", true);
			}


         }


    }
    
    /**
     * 初始化目标容器
     */
    function initDestContainer(config,src) {

        var container = config.container;
        var heads = config.srchead;
        var  hiddenfield=config.hiddenfield;
        var searchlabel=config.searchLabel;
        var  srcdest= container.find(".e8_box_slice");
		var deletebutton=$("<img class='e8_box_search e8_box_search_del' id='delBtn' name='delBtn' src='/js/dragBox/img/2_wev8.png' style='display:none;'></img>");
		srcdest.append(deletebutton);
		deletebutton.bind("click",function(){
           delTarget(config,src,false,container);
        });
		
		//container.find(".e8_box_d").width((jQuery(window).width())*0.45-1);
		container.find(".e8_box_d").css("width","45%");
        var swidth = container.find(".e8_box_d").css("width");
        swidth = parseInt(swidth.substring(0, swidth.indexOf("p"))) - 20;
        var pageinfo = new PageInfo();
        //td的平均宽度
        destAvgWidth = (swidth / (heads.length == 0 ? 1 : heads.length)) + "px";
        var tr;
        var td;
        var dataitem;
		initThead();


		function initThead(){
			if(container.find(".e8_box_desttop").find("thead").length>0)return;
			var thead = $("<thead></thead>");
            var tr = jQuery("<tr></tr>");
            //初始化行头
            for (var i = 0; i <= heads.length; i++) {
                if (i === 0){
                    tr.append("<td style='width: 28px;display:none;'><input type='checkbox' name='destallitem' style='margin-left: 7px'></td>");
                }else if(i===1){
	                td = $("<td style='text-align: left;padding-left:10px;width: " + destAvgWidth + "'><span>"+SystemEnv.getHtmlNoteName(3504,readCookie("languageidweaver"))+"</span><span class='e8_clear_btn' id='clearBtn2' title='"+SystemEnv.getHtmlNoteName(3522,readCookie("languageidweaver"))+"'></span></td>");
	                td.children("#clearBtn2").bind("click",function(){
						var trs = $("#dest_box_middle").find("tr.e8_checked_tr");
							trs.each(function(){
								setChecked(this,1);
							});
					});
				}else{
					td = $("<td style='display:none;text-align: left;padding-left:10px;width: " + destAvgWidth + "'><span>"+SystemEnv.getHtmlNoteName(3504,readCookie("languageidweaver"))+"</span><span class='e8_clear_btn' id='clearBtn2' title='"+SystemEnv.getHtmlNoteName(3522,readCookie("languageidweaver"))+"'></span></td>");
				}
				tr.append(td);
            }
            //附加源行头
            thead.append(tr);
            container.find(".e8_box_desttop").append(thead);
		}

        function init(data) {
            //data = JSON.parse(data);
			dest_datas_idx = 0;
			_dest_datas_idx = 0;
			destMap = null;
			destMapKeys = [];
            container.find(".e8_box_target").html("");
            container.find(".e8_box_dest").html("");
            //源端全选
            container.find("input[name='destallitem']").click(function () {
                var isselect = $(this).is(':checked');
                var selectitems = container.find("input[type=checkbox][name='destitem']");
                if (isselect) {

                    for (var i = 0; i < selectitems.length; i++) {
                        if( !$(selectitems[i]).is(':checked'))
                        //触发checkbox选中
                            $(selectitems[i]).trigger("click");
                    }
                } else {
                    for (var i = 0; i < selectitems.length; i++) {
                        if($(selectitems[i]).is(':checked'))
                            $(selectitems[i]).removeAttr("checked");
                    }
                }
            });
            container.find(".e8_box_dest").append("<div class='e8_box_pageinfo1' style='display:none;'>每页<select name='pagesize' disabled='disabled' class='e8_box_pagesize' style='width:50px;'><option value='10'>10</option><option value='50'>50</option><option value='100'>100</option><option value='"+maxPageSize+"'>全部</option></select>条</div> <div class='e8_box_pageinfo2' style='display:none;'>第" + data.currentPage + "/" + data.totalPage + "页</div> ");
            container.find(".e8_box_dest").find("select[name='pagesize']").val(pageinfo.pagesize);
            container.find(".e8_box_dest").find("select[name='pagesize']").change(function(){
                pageinfo.pagesize=$(this).val();
                //改变每页条数,将当前页置为1
                pageinfo.currentpage=1;
                if(config.saveLazy){
	                var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds",config.currentWindow.document).val();
					ajaxHandler(saveurl, "", function(){}, "json", true);
				}
                ajaxHandler(config.desturl, "currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize, init, "json", false);
            });


            var pimg = $("<img class='e8_box_preimg' style='display:none;'>");
            var nimg = $("<img class='e8_box_nextimg' style='display:none;'>");
            if (data.currentPage > 1) {
                pimg.attr("src", "/js/dragBox/img/PreBtn2Up_wev8.png");
                pimg.click(function(){
                    var desturl = config.desturl;
                    if(config.saveLazy){
                    	 var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds",config.currentWindow.document).val();
						ajaxHandler(saveurl, "", function(){}, "json", false);
                    }
                    ajaxHandler(desturl, "currentPage="+(parseInt(pageinfo.currentpage)-1)+"&pageSize=" + pageinfo.pagesize, init, "json", false);

                });
            } else
                pimg.attr("src", "/js/dragBox/img/PreBtn2Disable_wev8.png");

            if (data.currentPage < data.totalPage) {
                nimg.attr("src", "/js/dragBox/img/NextBtn2Up_wev8.png");
                nimg.click(function(){
                    var desturl = config.desturl;
                    if(config.saveLazy){
                    	 var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds",config.currentWindow.document).val();
						ajaxHandler(saveurl, "", function(){}, "json", false);
                    }
                    ajaxHandler(desturl, "currentPage="+(parseInt(pageinfo.currentpage)+1)+"&pageSize=" + pageinfo.pagesize, init, "json", false);


                });
            } else
                nimg.attr("src", "/js/dragBox/img/NextBtn2Disable_wev8.png");
            container.find(".e8_box_dest").append(pimg);
            container.find(".e8_box_dest").append(nimg);
            pageinfo.totalpage = data.totalPage;
            pageinfo.currentpage = data.currentPage;
            var datas = data.mapList;
			if(!destMap)destMap = {};
			var systemids = "";
			for(var i=0;i<datas.length;i++){
				var dataitem = datas[i];
				var newdataitem = null;
				if(config.srcfield && config.srcfield.length>0){
					newdataitem = {};
					for(var j=0;j<config.srcfield.length;j++){
						newdataitem[config.srcfield[j]] = dataitem[config.srcfield[j]];
					}
				}else{
					newdataitem = dataitem;
				}
				destMap[dataitem[config.hiddenfield]] = newdataitem;
				destMapKeys.push(dataitem[config.hiddenfield]);
				dataitem["__state"] = false;
				dataitem["__checked"] = false;
				if(systemids){
					systemids += ","+dataitem[config.hiddenfield];
				}else{
					systemids = dataitem[config.hiddenfield];
				}
			}
			destMap["length"] = datas.length;
			initDestDataByPage(container,config);
            registerDragEvent(config);
			jQuery("#systemIds",config.currentWindow.document).val(systemids);
            createOrRefreshScrollBar("dest_box_middle",config);
			/*container.find("#dest_box_middle").mousewheel(function(e, delta, deltaX, deltaY){
				var pTop = jQuery(this).find(".ps-scrollbar-y").position().top;
				var pcHeight = jQuery(this).height();
				var psHeight = jQuery(this).find(".ps-scrollbar-y").height();
				if(window.console)console.log(pTop+"::"+psHeight+"::"+pcHeight);
				if(pcHeight<(psHeight+pTop)+10){
					initDestDataByPage(container,config);
					 createOrRefreshScrollBar("dest_box_middle",config,"update");
				}
			});*/
        }
        jQuery("#systemIds",config.currentWindow.document).val(config.selectids)
        var params = "systemIds="+jQuery("#systemIds",config.currentWindow.document).val()+"&currentPage=1&pageSize=" + pageinfo.pagesize;
        params = getParams(config,params);
        ajaxHandler(config.desturl, params, init, "json", false);
    }

	function isLeftMouseButton(evt){
		evt = evt||window.event;
		if(jQuery.browser.msie){
			if(evt.button!=1 &&  evt.button!=0)return false;
		}else{
			if(evt.button!=0)return false;
		}
		var target = evt.srcElement||evt.target;
		if(jQuery(target).hasClass("e8_dragDiv"))return false;
		return true;
	}


    return {

        /**
         * 创建配置信息
         */
        createConfig: function () {
			var config = new Config();
			window._config = config;
            return config;
        },
        /**
         * 根据配置信息生成权限设置界面
         * @param config
         */
        createRightsPluing: function (config) {
            var container = config.container;
            var constrctxmlnode = jQuery(constrctxml);
            if(!config.needAllAddBtn){
            	constrctxmlnode.find("#multiArrowToDiv").hide();
            }
            container.append(constrctxmlnode);
            /**
            * 自动计算选区可用高度
            */
            if(config.searchAreaId){
            	jQuery("#"+config.searchAreaId).css("max-height","160px");
            	window.setTimeout(function(){
	            	var searchAreaHeight = jQuery(document.getElementById(config.searchAreaId)).height();
	            	var e8_box_topmenu = jQuery(".e8_box_topmenu").height();
	            	var contentHeight = jQuery("div.zDialog_div_content").height();
	            	var height = contentHeight - e8_box_topmenu - searchAreaHeight - 2;
	            	$("#src_box_middle").height(height);
	            	$("div.e8_box_s").height(height+e8_box_topmenu);
	            	$("#dest_box_middle").height(height);
	            	$("div.e8_box_d").height(height+e8_box_topmenu);
	            	$("div.e8_box_slice").height(height+e8_box_topmenu);
	            	jQuery(document.getElementById(config.searchAreaId)).data("hasBeenCal",true);
	            	createOrRefreshScrollBar("src_box_middle",config);
	            	createOrRefreshScrollBar("dest_box_middle",config);
	            	createOrRefreshScrollBar(config.searchAreaId,config);
	            	$("#src_box_middle").data("__config",config);
	            	try{
		            	jQuery(document.getElementById(config.searchAreaId)).find(".e8_innerShowContent").resize(function(e){
		            		var config = $("#src_box_middle").data("__config");
		            		createOrRefreshScrollBar(config.searchAreaId,config,"update");
		            	});
		            }catch(e){
		            	if(window.console)console.log(e,"rightspluingForBrowserNew_wev8.js");
		            }
	            },300);
            }
			var i=1;
			var timer = null;
			/*$("#src_bottom_scroll_flag").bind("mouseover",function(){
				if(isMouseDown && isMouseMove){
					scrollAndChecked("src_box_middle",i);
					i++;
					timer = setInterval(function(){
						scrollAndChecked("src_box_middle",i);
						i++;
					},400);
				}
			}).bind("mouseleave",function(){
				if(timer)
					clearTimeout(timer);
			}).bind("mouseup",function(){
				if(timer){
					clearTimeout(timer);
				}
			});*/
			var delay = 400;
			$(document).bind("keydown",function(e){
				if(e.ctrlKey){
					isCtrlKey = true;
				}else{
					isCtrlKey = false;
				}
			}).bind("keyup",function(e){
				isCtrlKey = false;
			});
			$("#src_box_middle").delegate("tr","mousedown",function(e){
				if(!isLeftMouseButton(e))return;
				var clicks = jQuery(this).data("_clicks");
				if(!clicks)clicks = 0;
				clicks++;
				jQuery(this).data("_clicks",clicks);
				var _this = this;
				setTimeout(function() {
					clicks = 0;
					jQuery(_this).data("_clicks",clicks);
				}, delay);
				if (clicks === 2 && !jQuery.browser.msie) {
					var trs = $("#src_box_middle").find("tr.e8_checked_tr");
					trs.each(function(){
						var checked = jQuery(this).find(":checkbox").attr("checked");
						if(checked)
							setChecked(this);
					});
					var checkbox = jQuery(this).find("input[type='checkbox']");
					checkbox.attr("checked",true);
					srcMap[checkbox.attr("id")].__checked = true;
					jQuery("#singleArrowTo").trigger("click");
					clicks = 0;
					jQuery(this).data("_clicks",clicks);
					isMouseDown = 0;
					return;
				}else{
					isMouseDown = 1;
					startIdx = parseInt(jQuery(this).attr("_index"));
				}
				//console.log("startIdx----"+startIdx);
			});
			$("#src_box_middle").delegate("tr","mouseup",function(e){
				if(!isLeftMouseButton(e))return;
				if(isMouseDown==1){
					isMouseMove = 1;
					if(endIdx==-1){
						endIdx = parseInt(jQuery(this).attr("_index"));
					}
					if(endIdx==startIdx){
						if(!jQuery(this).hasClass("e8_selected_tr")){
							if(!isCtrlKey){
								var trs = $("#src_box_middle").find("tr.e8_checked_tr");
								trs.each(function(){
									var checked = jQuery(this).find(":checkbox").attr("checked");
									if(checked)
										setChecked(this);
								});
							}
							setChecked(this);
						}
					}else{
						var trs = $("#src_box_middle").find("tr.e8_checked_tr");
						trs.each(function(){
							var checked = jQuery(this).find(":checkbox").attr("checked");
							if(!checked)
								setChecked(this);
						});
					}
				}else{
					$("#src_box_middle").find("tr.e8_checked_tr").removeClass("e8_checked_tr");
				}
				startIdx=-1;
				endIdx=-1;
				direct=1;
				isMouseDown = 0;
			});
			$("#src_box_middle").delegate("tr","mousemove",function(e){
				return;
				if(!isLeftMouseButton(e))return;
				if(isMouseDown==1){
					if(jQuery(this).hasClass("moreBtn"))return;
					isMouseMove = 1;
					var _index = parseInt(jQuery(this).attr("_index"));
					//console.log(startIdx+"::::"+_index);
					if(_index>startIdx){
						direct=1;
						var tr = jQuery("tr[_index='"+(_index+1)+"']");
						var checked = tr.find(":checkbox").attr("checked");
						if(!checked)
							tr.removeClass("e8_checked_tr");
					}else if(_index<startIdx){
						direct=0;
						var tr = jQuery("tr[_index='"+(_index-1)+"']");
						var checked = tr.find(":checkbox").attr("checked");
						if(!checked)
							tr.removeClass("e8_checked_tr");
					}else{
						if(direct==1){
							var tr = jQuery("tr[_index='"+(_index+1)+"']");
							var checked = tr.find(":checkbox").attr("checked");
							if(!checked)
								tr.removeClass("e8_checked_tr");
						}else if(direct==0){
							var tr = jQuery("tr[_index='"+(_index-1)+"']");
							var checked = tr.find(":checkbox").attr("checked");
							if(!checked)
								tr.removeClass("e8_checked_tr");
						}
						direct=1;
					}
					endIdx = _index;
					if(!jQuery(this).hasClass("e8_selected_tr")){
						jQuery(this).addClass("e8_checked_tr");
					}
				}
			});
			$("#src_box_middle").bind("mouseup",function(){
				if(isMouseDown==1){
					if(endIdx==startIdx){
						//setChecked(this);
					}else{
						var trs = $("#src_box_middle").find("tr.e8_checked_tr");
						trs.each(function(){
							var checked = jQuery(this).find(":checkbox").attr("checked");
							if(!checked)
								setChecked(this);
						});
					}
				}
			});
			
			$("#dest_box_middle").delegate("tr","mousedown",function(e){
				if(!isLeftMouseButton(e))return;
				var destcliks = jQuery(this).data("_destcliks");
				if(!destcliks)destcliks = 0;
				e.preventDefault();
				destcliks++;
				jQuery(this).data("_destcliks",destcliks);
				var _this = this;
				setTimeout(function() {
					destcliks = 0;
					jQuery(_this).data("_destcliks",destcliks);
				}, delay);
				if (destcliks === 2 && !jQuery.browser.msie) {
					var trs = $("#dest_box_middle").find("tr.e8_checked_tr");
					trs.each(function(){
						var checked = jQuery(this).find(":checkbox").attr("checked");
						if(checked)
							setChecked(this,1);
					});
					var checkbox = jQuery(this).find("input[type='checkbox']");
					checkbox.attr("checked",true);
					destMap[checkbox.attr("id")].__checked = true;
					jQuery("#singleArrowFrom").trigger("click");
					destcliks = 0;
					jQuery(this).data("_destcliks",destcliks);
					destIsMouseDown = 0;
					return;
				}else{
					destIsMouseDown = 1;
					destStartIdx = parseInt(jQuery(this).attr("_index"));
				}
				//console.log("startIdx----"+startIdx);
			});
			$("#dest_box_middle").delegate("tr","mouseup",function(e){
				if(!isLeftMouseButton(e))return;
				if(destIsMouseDown==1){
					if(destEndIdx==-1){
						destEndIdx = parseInt(jQuery(this).attr("_index"));
					}
					if(destEndIdx==destStartIdx){
						if(!jQuery(this).hasClass("e8_selected_tr")){
							if(!isCtrlKey){
								var trs = $("#dest_box_middle").find("tr.e8_checked_tr");
								trs.each(function(){
									var checked = jQuery(this).find(":checkbox").attr("checked");
									if(checked)
										setChecked(this,1);
								});
							}
							setChecked(this,1);
						}
					}else{
						var trs = $("#dest_box_middle").find("tr.e8_checked_tr");
						trs.each(function(){
							var checked = jQuery(this).find(":checkbox").attr("checked");
							if(!checked)
								setChecked(this,1);
						});
					}
				}else{
					$("#dest_box_middle").find("tr.e8_checked_tr").removeClass("e8_checked_tr");
				}
				destStartIdx=-1;
				destEndIdx=-1;
				destDirect=1;
				destIsMouseDown = 0;
			});
			$("#dest_box_middle").delegate("tr","mousemove",function(e){
				return;
				if(!isLeftMouseButton(e))return;
				if(destIsMouseDown==1){
					var _index = parseInt(jQuery(this).attr("_index"));
					//console.log(startIdx+"::::"+_index);
					if(_index>destStartIdx){
						destDirect=1;
						var tr = jQuery("tr[_index='"+(_index+1)+"']");
						var checked = tr.find(":checkbox").attr("checked");
						if(!checked)
							tr.removeClass("e8_checked_tr");
					}else if(_index<destStartIdx){
						destDirect=0;
						var tr = jQuery("tr[_index='"+(_index-1)+"']");
						var checked = tr.find(":checkbox").attr("checked");
						if(!checked)
							tr.removeClass("e8_checked_tr");
					}else{
						if(destDirect==1){
							var tr = jQuery("tr[_index='"+(_index+1)+"']");
							var checked = tr.find(":checkbox").attr("checked");
							if(!checked)
								tr.removeClass("e8_checked_tr");
						}else if(destDirect==0){
							var tr = jQuery("tr[_index='"+(_index-1)+"']");
							var checked = tr.find(":checkbox").attr("checked");
							if(!checked)
								tr.removeClass("e8_checked_tr");
						}
						destDirect=1;
					}
					destEndIdx = _index;
					if(!jQuery(this).hasClass("e8_selected_tr")){
						jQuery(this).addClass("e8_checked_tr");
					}
				}
			});
			$("#dest_box_middle").bind("mouseup",function(){
				if(destIsMouseDown==1){
					if(destEndIdx==destStartIdx){
						//setChecked(this);
					}else{
						var trs = $("#dest_box_middle").find("tr.e8_checked_tr");
						trs.each(function(){
							var checked = jQuery(this).find(":checkbox").attr("checked");
							if(!checked)
								setChecked(this,1);
						});
					}
				}
			});
			

            if(jQuery("#dialog").parent("td.fieldName").length==0){
            	//jQuery("div.e8_box_s").css("padding-left","25px");
            }
            jQuery("#singleArrowTo",config.currentWindow.document).hover(function(){
				if(!jQuery(this).hasClass("e8_box_disabled")){
            		jQuery(this).attr("src","/js/dragBox/img/4-h_wev8.png")
				}
            },function(){
            	if(!jQuery(this).hasClass("e8_box_disabled")){
					jQuery(this).attr("src","/js/dragBox/img/4-1_wev8.png")
				}else{
            		jQuery(this).attr("src","/js/dragBox/img/4_wev8.png")
				}
            });
            jQuery("#singleArrowFrom",config.currentWindow.document).hover(function(){
				if(!jQuery(this).hasClass("e8_box_disabled")){
            		jQuery(this).attr("src","/js/dragBox/img/5-h_wev8.png")
				}
            },function(){
            	if(!jQuery(this).hasClass("e8_box_disabled")){
					jQuery(this).attr("src","/js/dragBox/img/5-1_wev8.png")
				}else{
            		jQuery(this).attr("src","/js/dragBox/img/5_wev8.png")
				}
            }).bind("click",function(){
            	jQuery("#delBtn").click();
            });
            jQuery("#multiArrowTo",config.currentWindow.document).hover(function(){
				if(!jQuery(this).hasClass("e8_box_disabled")){
            		jQuery(this).attr("src","/js/dragBox/img/6-h_wev8.png")
				}
            },function(){
				if(!jQuery(this).hasClass("e8_box_disabled")){
					jQuery(this).attr("src","/js/dragBox/img/6-1_wev8.png")
				}else{
            		jQuery(this).attr("src","/js/dragBox/img/6_wev8.png")
				}
            }).bind("click",function(){
            	joinTarget(config,src,true,container);
            });
            jQuery("#multiArrowFrom",config.currentWindow.document).hover(function(){
            	if(!jQuery(this).hasClass("e8_box_disabled")){
            		jQuery(this).attr("src","/js/dragBox/img/7-h_wev8.png")
				}
            },function(){
            	if(!jQuery(this).hasClass("e8_box_disabled")){
					jQuery(this).attr("src","/js/dragBox/img/7-1_wev8.png")
				}else{
            		jQuery(this).attr("src","/js/dragBox/img/7_wev8.png")
				}
            }).bind("click",function(){
            	delTarget(config,src,true,container);
            });
            var src=initSrcContainer(config);
			__srcContainer = src;
            initDestContainer(config,src);
            registerArrowEvent(config,src);
            //jQuery(".e8_box_target").jNice();
        },
        
        system_btnok_onclick:function(config){
        	//var dest = config.container.find("table.e8_box_target tbody tr");
        	var ids = config.container.find("#systemIds").val();
        	var names = "";
        	if(!!ids){
				ids = "";
				var nameKey = destMap["__nameKey"];
				if(config.formatCallbackFn){
	        		var json = config.formatCallbackFn(config,destMap,destMapKeys);
	        		if(json){
	        			ids = json.id;
	        			names =json.name;
	        		}
	        	}else{
	        		var extHref = window.location.href;
	        		var indexReg = /RoleResourceSelect.jsp|MultiSelectByRight.jsp/; 
	        		var isRoleSelect =  indexReg.test(extHref) ; // 角色人员  分权浏览框
					for(var i=0;destMapKeys&&i<destMapKeys.length;i++){
						var key = destMapKeys[i];
						var dataitem = destMap[key];
						var name = dataitem[nameKey];
						if(isRoleSelect) name = (name ? name.replace(/,/g,'，') : name) ;
						var obj = null;
						try{
							if(name!="*") obj = jQuery(name);
						}catch(e){}
						if(ids==""){
							ids = key;
						}else{
							ids = ids+","+key;
						}
						if(names==""){
							if(name=="*"){
								names=name;
							}else{
		        			 names = (obj && obj.length>0)?obj.text():name;
		        			}
		        		}
						else{
							var strtemp = window.location.href;
							if(window.location.href.indexOf("MultiCommonBrowser.jsp") >= 0){
		        			    names=names + "~~WEAVERSplitFlag~~"+((obj && obj.length>0)?obj.text():name);
							}else{
		        			    names=names + ","+((obj && obj.length>0)?obj.text():name);
							}
		        		}
					}
				}
        	}
        	
        	//设置返回值并关闭
        	if(config.okCallbackFn){
        		config.okCallbackFn(config,destMap,{id:ids,name:names},destMapKeys);
        		__returnValue(config,ids,names,0,destMap,destMapKeys);
        	}else{
        		__returnValue(config,ids,names,1,destMap,destMapKeys);
        	}
        },
        system_btnclear_onclick:function(config){
        	//设置返回值并关闭
        	if(config.clearCallbackFn){
        		config.cancelCallbackFn(config,destMap,{id:"",name:""},destMapKeys);
        		__returnValue(config,"","",0,{},destMapKeys);
        	}else{
        		__returnValue(config,"","",1,{},destMapKeys);
        	}
        	
        },
        system_btncancel_onclick:function(config){
        	//关闭弹出页面
        	__returnValue(config,"","",0,{},destMapKeys);
        },
        system_btnsearch_onclick:function(config){
			__extendPageSize = 30;
			__research = true;
        	initSrcContainer(config,true);
        },
	resetRightspluingParams:function(){
		__extendPageSize = 30;
		research = true;
	},
	__returnValue:function(config,ids,names,type,destMap,destMapKeys){
		try {
			if (config.dialog) {
				//E8弹出窗口模式
				
				//设置值
				if(type==1){
					try {
						config.dialog.callback({
							id : ids,
							name : names
						},{
							destMap:destMap,
							destMapKeys:destMapKeys,
							config:config
						});
					} catch (e) {
					}
					try {
						config.dialog.close({
							id : ids,
							name : names
						},{
							destMap:destMap,
							destMapKeys:destMapKeys,
							config:config
						});
					} catch (e) {
					}
				}
				//关闭
				try {
					config.dialog.close();
				} catch (e) {
				}
			} else {
				//老式弹出窗口操作
				__doSetValue(config,ids,names,type,destMap,destMapKeys);
			}
		} catch (e) {
			//老式弹出窗口操作
			__doSetValue(config,ids,names,type,destMap,destMapKeys);
		}
	},
	__doSetValue:function(config,ids,names,type,destMap,destMapKeys){
		var opWin = window.parent;
		if (config.parentWin)
			opWin = config.parentWin;
		try {
			//chrome37+ 处理
			var dialogflag = (typeof (systemshowModalDialog) == 'undefined' && !!!window.showModalDialog);
			dialogflag = (dialogflag || systemshowModalDialog);
			
			//设置值
			if(type==1){
				if (dialogflag) {
					try {
						opWin.opener.dialogReturnValue = {
							id : ids,
							name : names
						};
					} catch (_96e) {
					}
				}
				opWin.returnValue = {
					id : ids,
					name : names
				};
			}
			//关闭
			if (dialogflag) {
				try {
					opWin.opener.closeHandle();
				} catch (_96e) {
				}
			}
			opWin.close();
		} catch (e) {
			//设置值
			if (type == 1) {
				opWin.returnValue = {
					id : ids,
					name : names
				};
			}
			//关闭
			opWin.close();
		}
	}

    }

})();

//@deprecated
function resetRightspluingParams(){
	rightsplugingForBrowser.resetRightspluingParams();
}

//@deprecated
//设置浏览按钮返回值 兼容老式的弹出窗口及chrome37+
function __returnValue(config,ids,names,type,destMap,destMapKeys){
	rightsplugingForBrowser.__returnValue(config,ids,names,type,destMap,destMapKeys);
}

//@deprecated
function __doSetValue(config,ids,names,type,destMap,destMapKeys){
	rightsplugingForBrowser.__doSetValue(config,ids,names,type,destMap,destMapKeys);
}