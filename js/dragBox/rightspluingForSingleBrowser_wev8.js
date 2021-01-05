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
        "<div class='e8_box_s' style='width:100%;'>" +
        	"<table class='e8_box_srctop e8_box_topmenu'  style='border-collapse: collapse;width:101%;table-layout:fixed;'></table>" +
            "<div style='position:relative;'><div id='src_box_middle' class='e8_box_middle'>" +
            "<table class='e8_box_source' id='e8_src_table' style='border-collapse: collapse;width:100%;table-layout:fixed;'>" +
            "</table>" +
            "</div><div id='src_bottom_scroll_flag' style='display:none;background-color:#00f;width: 100%;height: 20px;position: absolute;left: 0px;bottom: -10px;'></div></div>" +
            "<div class='e8_box_src e8_box_bottommenu' style='display:none;'></div>" +
            "</div>";
	
	var maxPageSize = 1000000;
	var srcMap = null;
	var srcMapKeys = [];
	var key = null;
	var __research = true;
	
var __maxNumbers = 10;
var __extendPageSize = 30;
var __srcContainer = null;
var __stepSize = 40;
var srcAvgWidth = 0;

function initDataByPage(container,config,key){
	var checkitem;
	var delsystemIds = "";
	var heads = config.srchead;
	var checkbox = null;
	 for (var i = 0,j=0; i < srcMapKeys.length && (i<__extendPageSize); i++) {
		dataitem = srcMap[srcMapKeys[i]];
		if(!dataitem || dataitem.__loaded)continue;
		j++;
		checkitem=$("<td style='width: 28px;display:none;'></td>");
		var srcbox = jQuery("<input type='checkbox'>").attr("name","srcitem").css({
			"margin-left":"7px"
		});
		checkitem.append(srcbox);
		tr = $("<tr _index="+i+" style='cursor:pointer;'></tr>");
		tr.hover(function(){
			if(!jQuery(this).hasClass("e8_checked_tr")&&!jQuery(this).hasClass("e8_selected_tr")){
				jQuery(this).addClass("e8_hover_tr");
			}
		},function(){
			jQuery(this).removeClass("e8_hover_tr");
		}).removeClass("e8_hover_tr");
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
				}
				j++;
				td = $("<td style='padding-left:10px;padding-right:5px;width:"+srcAvgWidth+";'>" + dataitem[item] + "</td>");
				tr.append(td);
			}
		}
		container.find(".e8_box_source").append(tr);
	}
	var extendBtn = container.find(".e8_box_s").find("button#extendBtn");
	if(srcMapKeys.length>__extendPageSize){
		if(extendBtn.length>0){
			extendBtn.html(SystemEnv.getHtmlNoteName(3520,readCookie("languageidweaver")).replace(/#\{count\}/g,20));
		}else{
			//var div = $("<div style='height:30px;line-height:40px;text-align:center;'></div>")
			var tr = $("<tr class='moreBtn'></tr>");
			var td = $("<td colspan=3 style='text-align:center;width:100%;border:none;'></td>");
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
			container.find("#e8_src_table").children("tbody").append(tr);

		}
	}else{
		extendBtn.closest("tr.moreBtn").remove();
	}
}



    function PageInfo() {
        this.pagesize = 20;
        this.currentpage = 1;
        this.totalpage = "";
    }
    
    function createOrRefreshScrollBar(div,config,option){
		var nicescroll = jQuery("#"+div).getNiceScroll();
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
        var heads = config.srchead;
        var searchlabel=config.searchLabel;
        var  srctop= container.find(".e8_box_srctop");
        var swidth = container.find(".e8_box_s").width()-28;
        var pageinfo = new PageInfo();
        //td的平均宽度
        srcAvgWidth = (swidth / (heads.length == 0 ? 1 : heads.length)) + "px";
		initThead();
        var tr;
        var td;
        var dataitem;

		function initThead(){
			if( container.find(".e8_box_srctop").find("thead").length>0)return;
			 var thead = $("<thead></thead>");
            var tr = jQuery("<tr></tr>");
            //初始化行头
            for (var i = 0; i <=heads.length; i++) {
                if (i === 0){
                    tr.append("<td style='width: 28px;display:none;'><input type='checkbox' name='srcallitem' style='margin-left: 7px'></td>");
                }else{
					td = $("<td style='padding-left:10px;padding-right:5px;text-align: left;width:"+srcAvgWidth+";'><span>"+heads[i-1]+"</span></td>");
				}
                tr.append(td);
            }
            //附加源行头
            thead.append(tr);
            container.find(".e8_box_srctop").append(thead);
		}

        function init(data) {
			srcMap = null;
			srcMapKeys  = [];
			var datas_idx = 0;
			var _datas_idx = 0;
            container.find(".e8_box_source").html("");
            container.find(".e8_box_src").html("");
            var datas = data.mapList;
			if(!srcMap)srcMap = {};
			for(var i=0;i<datas.length;i++){
				var dataitem = datas[i];
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
				dataitem["__state"] = false;
				dataitem["__checked"] = false;
			}
			srcMap["length"] = datas.length;
            
		   initDataByPage(container,config);
            createOrRefreshScrollBar("src_box_middle",config);
        }
        if(!isSearch){
        	jQuery("#systemIds",config.currentWindow.document).val(config.selectids);
        }
		var params = "pageSize=" + (__extendPageSize+1);
        params = getParams(config,params);
        ajaxHandler(config.srcurl, params, init, "json", true);
         return {

             refresh:function(srcurl)
             {
             	 if(srcurl==null){
             	 	srcurl = config.srcurl;
             	 }
				 var params = "pageSize=" +(__extendPageSize+1);
        		 params = getParams(config,params);
                 ajaxHandler(srcurl, params, init, "json", true);
			}
         }
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
            container.append($(constrctxml));
            /**
            * 自动计算选区可用高度
            */
            if(config.searchAreaId){
            	jQuery("#"+config.searchAreaId).css("max-height","160px");
            	window.setTimeout(function(){
	            	var searchAreaHeight = jQuery("#"+config.searchAreaId).height();
	            	var e8_box_topmenu = jQuery(".e8_box_topmenu").height();
	            	var contentHeight = jQuery("div.zDialog_div_content").height();
	            	var height = contentHeight - e8_box_topmenu - searchAreaHeight - 2;
	            	jQuery("#src_box_middle").height(height);
	            	jQuery("div.e8_box_s").height(height+e8_box_topmenu);
	            	createOrRefreshScrollBar("src_box_middle",config);
	            	jQuery("#"+config.searchAreaId).data("hasBeenCal",true);
	            	createOrRefreshScrollBar(config.searchAreaId,config);
	            	jQuery("#src_box_middle").data("__config",config);
	            	try{
		            	jQuery("#"+config.searchAreaId).find(".e8_innerShowContent").resize(function(e){
		            		var config = $("#src_box_middle").data("__config");
		            		createOrRefreshScrollBar(config.searchAreaId,config,"update");
		            	});
		            }catch(e){
		            	if(window.console)console.log(e,"rightspluingForSingleBrowser_wev8.js");
		            }
	            },300);
            }
			
			$("#src_box_middle").delegate("tr","click",function(e){
				key = jQuery(this).find("input[type='hidden']:first").val();
				ids = key;
				var nameKey = srcMap["__nameKey"];
				if(config.formatCallbackFn){
	        		var json = config.formatCallbackFn(config,srcMap,key);
	        		if(json){
	        			ids = json.id;
	        			names = json.name;
	        		}
	        	}else{
					var dataitem = srcMap[key];
					names = dataitem[nameKey];
				}
	        	//设置返回值并关闭
	        	if(config.okCallbackFn){
	        		config.okCallbackFn(config,srcMap,{id:ids,name:names},key);
	        		__returnValue(config,"","",{});
	        	}else{
	        		__returnValue(config,ids,names,1,dataitem);
	        	}
			});
			 var src=initSrcContainer(config);
			__srcContainer = src;
        },
        
        system_btnok_onclick:function(config){
        	var destMap = {};
        	if(key){
				ids = key;
				var nameKey = srcMap["__nameKey"];
				if(config.formatCallbackFn){
	        		var json = config.formatCallbackFn(config,srcMap,key);
	        		if(json){
	        			ids = json.id;
	        			names = json.name;
	        		}
	        		destMap = json;
	        	}else{
					var dataitem = srcMap[key];
					var obj = null;
					try{
					obj = jQuery(dataitem[nameKey]);
					}catch(e){}
					names = (obj && obj.length>0)?obj.text():dataitem[nameKey];
					destMap = dataitem;
				}
			}
        	//设置返回值并关闭
        	if(config.okCallbackFn){
        		config.okCallbackFn(config,srcMap,{id:ids,name:names},key);
        		__returnValue(config,ids,names,0,destMap);
        	}else{
        		__returnValue(config,ids,names,1,destMap);
        	}
	        
        },
        system_btnclear_onclick:function(config){
        	//设置返回值并关闭
        	if(config.clearCallbackFn){
        		config.cancelCallbackFn(config,srcMap,{id:"",name:""},key);
        		__returnValue(config,"","",0,{});
        	}else{
        		__returnValue(config,"","",1,{});
        	}
        	
        },
        system_btncancel_onclick:function(config){
        	//关闭弹出页面
        	__returnValue(config,"","",0,{});
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
		__returnValue:function(config,ids,names,type,destMap){
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
					__doSetValue(config,ids,names,type,destMap);
				}
			} catch (e) {
				//老式弹出窗口操作
				__doSetValue(config,ids,names,type,destMap);
			}
		},
		__doSetValue:function(config,ids,names,type,destMap){
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
function __returnValue(config,ids,names,type,destMap){
	rightsplugingForBrowser.__returnValue(config,ids,names,type,destMap);
}

//@deprecated
function __doSetValue(config,ids,names,type,destMap){
	rightsplugingForBrowser.__doSetValue(config,ids,names,type,destMap);
}