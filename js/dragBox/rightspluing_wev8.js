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
var rightspluging = (function () {

    var constrctxml ="<input type='hidden' id='systemIds' name='systemIds'/>"+
    	"<input type='hidden' id='delsystemIds' name='delsystemIds'/>"+
        "<div class='e8_box_s'>" +
            "<div class='e8_box_srctop e8_box_topmenu' style='height:30px;line-height:30px;'></div>" +
            "<div id='src_box_middle' class='e8_box_middle' style='height:321px;'>" +
            "<table class='e8_box_source' style='border-collapse: collapse;'>" +
            "</table>" +
            "</div>" +
            "<div class='e8_box_src e8_box_bottommenu' style='display:none;'></div>" +
            "</div><div class='e8_box_slice'>" +
            "<div ><img id='singleArrowTo' title='"+SystemEnv.getHtmlNoteName(3518,readCookie("languageidweaver"))+"' class='e8_box_mutiarrow e8_first_arrow' src='/js/dragBox/img/4_wev8.png' ></div>" +
            "<div><img id='singleArrowFrom' title='"+SystemEnv.getHtmlNoteName(3519,readCookie("languageidweaver"))+"' class='e8_box_mutiarrow' src='/js/dragBox/img/5_wev8.png' ></div>" +
            "<div><img id='multiArrowTo' title='"+SystemEnv.getHtmlNoteName("3407,3518",readCookie("languageidweaver"))+"' class='e8_box_mutiarrow' src='/js/dragBox/img/6_wev8.png' ></div>" +
            "<div><img id='multiArrowFrom' title='"+SystemEnv.getHtmlNoteName("3407,3519",readCookie("languageidweaver"))+"' class='e8_box_mutiarrow' src='/js/dragBox/img/7_wev8.png' ></div>" +
            "</div><div class='e8_box_d' >" +
            " <div class='e8_box_desttop e8_box_topmenu' style='height:30px;line-height:30px;'></div> " +
            "<div class='e8_box_middle' id='dest_box_middle' style='height:321px;'>" +
            "<table id='e8_dest_table' class='e8_box_target' style='border-collapse: collapse;'> " +
            " </table>" +
            "</div>" +
            "<div class='e8_box_dest e8_box_bottommenu' style='display:none;'></div>" +
            "</div>";

    function PageInfo() {
        this.pagesize = 10;
        this.currentpage = 1;
        this.totalpage = "";

    }
    
    function createOrRefreshScrollBar(div,config,option){
    	//初始化滚动条
        //jQuery("#inner_"+div).height(jQuery("#inner_"+div).children("table").height());
        //console.log(jQuery("#"+div+":first",config.currentWindow.document));
        //console.log(option);
        var nicescroll = jQuery("#"+div).getNiceScroll();
        if(!!option || (nicescroll && nicescroll.length>0)){
			if(!option)option="update";
        	jQuery("#"+div,config.currentWindow.document).perfectScrollbar(option);
        }else{
        	jQuery("#"+div,config.currentWindow.document).perfectScrollbar({horizrailenabled:false,zindex:0});
        }
    }
    
    function registerDragEvent(config){
    	 var fixHelper = function(e, ui) {  
            ui.children().each(function() {  
                $(this).width($(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
            });  
            return ui;  
        };  
         jQuery("#e8_dest_table tbody",config.currentWindow.document).sortable({                //这里是talbe tbody，绑定 了sortable  
             helper: fixHelper,                  //调用fixHelper  
             axis:"y",  
             start:function(e, ui){  
                 ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
                 return ui;  
             },  
             stop:function(e, ui){  
                 //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
                 jQuery(ui.item).hover(function(){
                	jQuery(this).addClass("e8_hover_tr");
                },function(){
                	jQuery(this).removeClass("e8_hover_tr");
                });
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
    
    function delTarget(config,src,isAll,container,hiddenfield){
    	if(!!!container){
    		container = config.container;
    	}
    	if(!!!hiddenfield){
    		hiddenfield = config.hiddenfield
    	}
    	var searchitem=$("<input name='searchitem' size='8' style='margin-top: 3px'>");
    	var checkeditems = [];
    	if(isAll){
    		checkeditems=container.find(".e8_box_target").find("input[type='checkbox'][name='destitem']");
    	}else{
    		checkeditems=container.find(".e8_box_target").find("input[type='checkbox'][name='destitem']:checked:visible");
    	}
    	if(checkeditems.length==0)return;
           var ids="";
           var array=[];
           var systemids = "";
           for(var i=0;i<checkeditems.length;i++)
           {

                 //array.push($(checkeditems[i]).parent().parent());
                 ids=ids+"&ID="+$(checkeditems[i]).parent().parent().find("input[name='"+hiddenfield+"']").val();
                 if(systemids){
                 	systemids += ","+$(checkeditems[i]).parent().parent().find("input[name='"+hiddenfield+"']").val();
                 }else{
                 	systemids = $(checkeditems[i]).parent().parent().find("input[name='"+hiddenfield+"']").val();
                 }
                 jQuery(checkeditems[i]).parent().parent().remove();
            }
            
            var deleteurl = config.delteurl+ids;
            removeFromArray(systemids,config);
			if(config.saveLazy){
				deleteurl += "&systemIds="+jQuery("#delsystemIds",config.currentWindow.document).val();
			}

           ajaxHandler(deleteurl, "", function(data){
                     //var rs=JSON.parse(data);
                      var rs = data;
                      var systemids = data.systemIds;
                      if(rs.result==="1")
                      {
                          for(var i=0;i<array.length;i++)
                          {
                              array[i].remove();
                          }
                          //源容器刷新
                          var srcurl = config.srcurl;
                          if(config.saveLazy){
                          	srcurl += "&includeId="+jQuery("#delsystemIds",config.currentWindow.document).val()+"&excludeId="+jQuery("#systemIds",config.currentWindow.document).val();
                          }
                          src.refresh(srcurl);
                          var  searchitemdata=searchitem.val();
                          var pageinfo = new PageInfo();
                          pageinfo.currentpage=1;
                          //目标容器刷新
                          var desturl = config.desturl;
                          if(config.saveLazy){
                          		desturl += "&excludeId="+jQuery("#delsystemIds",config.currentWindow.document).val()+"&includeId="+jQuery("#systemIds",config.currentWindow.document).val();
                          }
                         // ajaxHandler(desturl, "currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);
		
                      }else
                      {
                          top.Dialog.alert(SystemEnv.getHtmlNoteName(3527,readCookie("languageidweaver")));

                      }
                      createOrRefreshScrollBar("dest_box_middle",config,"update");
                      createOrRefreshScrollBar("src_box_middle",config,"update");



           }, "json", false);
    }
    
    function joinTarget(config,src,isAll,container,hiddenid){
    		if(!!!container){
	    		container = config.container;
	    	}
	    	if(!!!hiddenid){
	    		hiddenid = config.hiddenfield
	    	}
	    	var target = container.find(".e8_box_target");
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
	            createOrRefreshScrollBar
	
	        }
            var selectitems = [];
            if(isAll){
            	selectitems = container.find("input[name='srcitem']");
            }else{
            	selectitems = container.find("input[name='srcitem']:checked");
            }
            if(selectitems.length==0)return;
            var systemIds = "";
            var ids = "";
            for (var i = 0; i < selectitems.length; i++) {
                clone = $(selectitems[i]).parent().parent().clone();
				clone.removeClass("e8_hover_tr");
				clone.hover(function(e){jQuery(this).addClass("e8_hover_tr");},function(e){jQuery(this).removeClass("e8_hover_tr");});
				clone.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowFrom").trigger("click");
				}).disableSelection();
                clone.find("input").attr("class", "e8_box_desitem");
                ids=ids+"&ID="+clone.find("input[name='"+hiddenid+"']").val();
                if(systemIds){
                	systemIds+=","+clone.find("input[name='"+hiddenid+"']").val();
                }else{
                	systemIds = clone.find("input[name='"+hiddenid+"']").val();
                }
                clone.find("input[type=checkbox]").attr("name", "destitem");
                clone.find("input").removeAttr("checked");
                array.push(clone);
            }
            createOrRefreshScrollBar("dest_box_middle",config,"update");
			registerDragEvent(config);
            //此刻做数据存储
            var  saveurl= config.saveurl+ids;
            if(config.saveLazy){
            	saveurl += "&isNot=1"; 
            }
            ajaxHandler(saveurl, "", saveItems, "json", false);
			if(config.saveLazy){
            	appendToArray(systemIds,config);
            }
            var srcurl = config.srcurl;
            if(config.saveLazy){
            	srcurl += "&includeId="+jQuery("#delsystemIds",config.currentWindow.document).val()+"&excludeId="+jQuery("#systemIds",config.currentWindow.document).val();
            }
			 src.refresh(srcurl);
    }







    /**
     * 初始化源容器
     */
    function initSrcContainer(config) {

        var container = config.container;
				var pageId = jQuery("#pageId",parentWin.document).val();


        var heads = config.srchead;
        var searchlabel=config.searchLabel;
        var  srctop= container.find(".e8_box_srctop");
				var label= "";
				if(!!pageId && pageId=="Hrm:resourceSearchResult"){
					label=$("<label style='margin-left: 10px;margin-right:10px;'>"+config.srcLabel+"</label><input type=\"text\" id=\"flowTitle\" name=\"flowTitle\" value=\"\" style=\"width:100px;padding-left:5px;\" onkeyup=\"jsHrmSrcSearch(this)\"/><span class=\"middle searchImg1\"><img class=\"middle\" style=\"vertical-align:top;margin-top:7px;margin-left:-22px;\" src=\"/images/ecology8/request/search-input_wev8.png\" onclick=\"jsHrmSrcSearch(this)\"></span>");
				}else{
        	label=$("<label style='margin-left: 10px;margin-right:10px;'>"+config.srcLabel+"</label>");
				}
        var searchitem=$("<input name='e8_box_searchitem' size='10' style='margin-top: 3px;width:180px;'>");
        var searchbutton=$("<img class='e8_box_search e8_box_search_src' name='search' src='/js/dragBox/img/1_wev8.png'></img>");
        srctop.append(label);//.append(searchitem).append(searchbutton);
        searchbutton.bind("click",function(){
                var  searchitemdata=searchitem.val();
                pageinfo.currentpage=1;
                ajaxHandler(config.srcurl, "includeId="+jQuery("#delsystemIds",config.currentWindow.document).val()+"&excludeId="+jQuery("#systemIds",config.currentWindow.document).val()+"&currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);
            }).hover(function(){
            	jQuery(this).attr("src","/js/dragBox/img/1-h_wev8.png");
            },function(){
            	jQuery(this).attr("src","/js/dragBox/img/1_wev8.png");
            });
		
		//container.find(".e8_box_s").width(jQuery(window).width()*0.45-1);
		container.find(".e8_box_s").css("width","45%");
        var swidth = container.find(".e8_box_s").css("width");
        swidth = parseInt(swidth.substring(0, swidth.indexOf("p"))) - 20;
        var pageinfo = new PageInfo();
        //td的平均宽度
        var avgwidth = (swidth / (heads.length == 0 ? 1 : heads.length)) + "px";
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
                    ajaxHandler(saveurl, "", addItem, "json", false);
                    var  searchitemdata=searchitem.val();
                    var srcurl = config.srcurl;
                    if(config.saveLazy){
                    	srcurl += "&includeId="+jQuery("#delsystemIds",config.currentWindow.document).val()+"&excludeId="+jQuery("#systemIds",config.currentWindow.document).val();
                    }
                    ajaxHandler(srcurl, "currentPage="+parseInt(pageinfo.currentpage)+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);

                }
            });

        }
        

        function init(data) {
            //data = JSON.parse(data);
            //data = eval("("+data+")");
            container.find(".e8_box_source").html("");
            container.find(".e8_box_src").html("");
            tr = $("<thead></thead>");
            //初始化行头
            for (var i = 0; i < heads.length; i++) {
                if (i === 0)
                    tr.append("<td style='width: 28px'><input type='checkbox' name='srcallitem' style='margin-left: 7px'></td>");
                td = $("<td style='text-align: center;width: " + avgwidth + "'>" + heads[i] + "</td>");
                tr.append(td);
            }
            //附加源行头
            container.find(".e8_box_source").append(tr);
            //源端全选
            container.find("input[name='srcallitem']").click(function () {
                var isselect = $(this).is(':checked');
                var selectitems = container.find("input[type=checkbox][name='srcitem']");
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
            //生成分页信息
            container.find(".e8_box_src").append("<div class='e8_box_pageinfo1'>每页<select name='pagesize' disabled='disabled' id='srcpagesize' class='e8_box_pagesize'><option value='10'>10</option><option value='50'>50</option><option value='100'>100</option></select>条</div> <div class='e8_box_pageinfo2'>第" + data.currentPage + "/" + data.totalPage + "页</div> ");
            container.find(".e8_box_src").find("select[name='pagesize']").val(pageinfo.pagesize);
            container.find(".e8_box_src").find("select[name='pagesize']").change(function(){
                pageinfo.pagesize=$(this).val();
                //改变每页条数,将当前页置为1
                pageinfo.currentpage=1;
                var  searchitemdata=searchitem.val();
                ajaxHandler(config.srcurl, "includeId="+jQuery("#delsystemIds").val()+"&excludeId="+jQuery("#systemIds",config.currentWindow.document).val()+"&currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);

            });


            var pimg = $("<img class='e8_box_preimg'>");
            var nimg = $("<img class='e8_box_nextimg'>");
            if (data.currentPage > 1) {
                pimg.attr("src", "/js/dragBox/img/PreBtn2Up_wev8.png");
                pimg.click(function(){
                    var  searchitemdata=searchitem.val();
                    var srcurl = config.srcurl;
                    if(config.saveLazy){
                    	var systemids = jQuery("#systemIds",config.currentWindow.document).val();
                    	srcurl += "&excludeId="+systemids;
                    }
                    ajaxHandler(srcurl, "currentPage="+(parseInt(pageinfo.currentpage)-1)+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);

                });
            } else
                pimg.attr("src", "/js/dragBox/img/PreBtn2Disable_wev8.png");

            if (data.currentPage < data.totalPage) {
                nimg.attr("src", "/js/dragBox/img/NextBtn2Up_wev8.png");
                nimg.click(function(){
                    var  searchitemdata=searchitem.val();
                    var srcurl = config.srcurl;
                    if(config.saveLazy){
                    	var systemids = jQuery("#systemIds",config.currentWindow.document).val();
                    	srcurl += "&excludeId="+systemids;
                    }
                    ajaxHandler(srcurl, "currentPage="+(parseInt(pageinfo.currentpage)+1)+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);


                });
            } else
                nimg.attr("src", "/js/dragBox/img/NextBtn2Disable_wev8.png");
            container.find(".e8_box_src").append(pimg);
            container.find(".e8_box_src").append(nimg);
            pageinfo.totalpage = data.totalPage;
            pageinfo.currentpage = data.currentPage;
            var datas = data.mapList;
            var checkitem;
            var delsystemIds = "";
            for (var i = 0; i < datas.length; i++) {
                checkitem=$("<td style='width: 28px;'></td>");
                checkitem.append($("<input name='srcitem' type='checkbox' style='margin-left: 7px'>"));
                tr = $("<tr></tr>");
                tr.hover(function(){
                	jQuery(this).addClass("e8_hover_tr");
                },function(){
                	jQuery(this).removeClass("e8_hover_tr");
                }).removeClass("e8_hover_tr");
				tr.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowTo").trigger("click");
				});
                tr.append(checkitem);
                dataitem = datas[i];
                for (var item in dataitem) {
                    if(item===config.hiddenfield)
                    {
                    	if(delsystemIds){
		            		delsystemIds += ","+dataitem[item];
		            	}else{
		            		delsystemIds = dataitem[item];
		            	}
                        checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
                    }else
                    {
                    td = $("<td style='width: " + avgwidth + "'>" + dataitem[item] + "</td>");
                    tr.append(td);
                    }
                }
                container.find(".e8_box_source").append(tr);
            }
            //注册拖拉事件
            registerDragAndDrop(config);
            jQuery("#delsystemIds",this.currentWindow).val(delsystemIds);
            createOrRefreshScrollBar("src_box_middle",config);
            //jQuery(".e8_box_source").jNice();
        }

        ajaxHandler(config.srcurl, "currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize, init, "json", false);
         return {

             refresh:function(srcurl)
             {
             	 if(srcurl==null){
             	 	srcurl = config.srcurl;
             	 }
                 var  searchitemdata=searchitem.val();
                 ajaxHandler(srcurl, "currentPage="+parseInt(pageinfo.currentpage)+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);

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
        var  srcdest= container.find(".e8_box_desttop");

        var label=$("<label style='margin-left: 10px;margin-right:10px;'>"+config.targetLabel+"</label>");
        var searchitem=$("<input name='searchitem' size='8' style='margin-top: 3px;width:180px;'>");
        var searchbutton=$("<img class='e8_box_search e8_box_search_dest' name='search' src='/js/dragBox/img/1_wev8.png'></img>");
        var deletebutton=$("<img class='e8_box_search e8_box_search_del' id='delBtn' name='delBtn' src='/js/dragBox/img/2_wev8.png' style='display:none;'></img>");
        //srcdest.append(label).append(searchitem).append(searchbutton).append(deletebutton);
		srcdest.append(label).append(deletebutton);
        searchbutton.bind("click",function(){
                var  searchitemdata=searchitem.val();
                pageinfo.currentpage=1;
                if(config.saveLazy){
	                var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds",config.currentWindow.document).val();
					ajaxHandler(saveurl, "", function(){}, "json", false);
				}
                ajaxHandler(config.desturl, "currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);

            }).hover(function(){
            	jQuery(this).attr("src","/js/dragBox/img/1-h_wev8.png");
            },function(){
            	jQuery(this).attr("src","/js/dragBox/img/1_wev8.png");
            });
        deletebutton.hover(function(){
        	jQuery(this).attr("src","/js/dragBox/img/2-h_wev8.png");
        },function(){
        	jQuery(this).attr("src","/js/dragBox/img/2_wev8.png");
        }).bind("click",function(){
                delTarget(config,src,false,container);
        });

		//container.find(".e8_box_d").width(jQuery(window).width()*0.45-1);
		container.find(".e8_box_d").css("width","45%");
        var swidth = container.find(".e8_box_d").css("width");
        swidth = parseInt(swidth.substring(0, swidth.indexOf("p"))) - 20;
        var pageinfo = new PageInfo();
        //td的平均宽度
        var avgwidth = (swidth / (heads.length == 0 ? 1 : heads.length)) + "px";
        var tr;
        var td;
        var dataitem;


        function init(data) {
            //data = JSON.parse(data);
            container.find(".e8_box_target").html("");
            container.find(".e8_box_dest").html("");
            tr = $("<thead></thead>");
            //初始化行头
            for (var i = 0; i < heads.length; i++) {
                if (i === 0)
                    tr.append("<td style='width: 28px;'><input type='checkbox' name='destallitem' style='margin-left: 7px'></td>");
                td = $("<td style='text-align: center;width: " + avgwidth + "'>" + heads[i] + "</td>");
                tr.append(td);
            }
            //附加源行头
            container.find(".e8_box_target").append(tr);
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
            /*container.find(".e8_box_dest").append("<div class='e8_box_pageinfo1'>每页<select name='pagesize' disabled='disabled' class='e8_box_pagesize'><option value='10'>10</option><option value='50'>50</option><option value='100'>100</option></select>条</div> <div class='e8_box_pageinfo2'>第" + data.currentPage + "/" + data.totalPage + "页</div> ");
            container.find(".e8_box_dest").find("select[name='pagesize']").val(pageinfo.pagesize);
            container.find(".e8_box_dest").find("select[name='pagesize']").change(function(){
                pageinfo.pagesize=$(this).val();
                //改变每页条数,将当前页置为1
                pageinfo.currentpage=1;
                var  searchitemdata=searchitem.val();
                if(config.saveLazy){
	                var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds",config.currentWindow.document).val();
					ajaxHandler(saveurl, "", function(){}, "json", false);
				}
                ajaxHandler(config.desturl, "currentPage="+pageinfo.currentpage+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);
            });*/


            var pimg = $("<img class='e8_box_preimg' style='display:none;'>");
            var nimg = $("<img class='e8_box_nextimg' style='display:none;'>");
            if (data.currentPage > 1) {
                pimg.attr("src", "/js/dragBox/img/PreBtn2Up_wev8.png");
                pimg.click(function(){
                    var  searchitemdata=searchitem.val();
                    var desturl = config.desturl;
                    if(config.saveLazy){
                    	 var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds",config.currentWindow.document).val();
						ajaxHandler(saveurl, "", function(){}, "json", false);
                    }
                    ajaxHandler(desturl, "currentPage="+(parseInt(pageinfo.currentpage)-1)+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);

                });
            } else
                pimg.attr("src", "/js/dragBox/img/PreBtn2Disable_wev8.png");

            if (data.currentPage < data.totalPage) {
                nimg.attr("src", "/js/dragBox/img/NextBtn2Up_wev8.png");
                nimg.click(function(){
                    var  searchitemdata=searchitem.val();
                    var desturl = config.desturl;
                    if(config.saveLazy){
                    	 var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds",config.currentWindow.document).val();
						ajaxHandler(saveurl, "", function(){}, "json", false);
                    }
                    ajaxHandler(desturl, "currentPage="+(parseInt(pageinfo.currentpage)+1)+"&pageSize=" + pageinfo.pagesize+"&searchitem="+searchitemdata, init, "json", false);


                });
            } else
                nimg.attr("src", "/js/dragBox/img/NextBtn2Disable_wev8.png");
            container.find(".e8_box_dest").append(pimg);
            container.find(".e8_box_dest").append(nimg);
            pageinfo.totalpage = data.totalPage;
            pageinfo.currentpage = data.currentPage;
            var datas = data.mapList;
            var checkitem;
            var systemids = "";
            var checkbox = "";
            for (var i = 0; i < datas.length; i++) {
                checkitem=$("<td style='width: 28px'></td>");
                checkbox = $("<input name='destitem' type='checkbox' style='margin-left: 7px'>");
                checkitem.append(checkbox);
                tr = $("<tr></tr>");
                tr.hover(function(){
                	jQuery(this).addClass("e8_hover_tr");
                },function(){
                	jQuery(this).removeClass("e8_hover_tr");
                });
				tr.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowFrom").trigger("click");
				});
                tr.append(checkitem);
                dataitem = datas[i];
                for (var item in dataitem) {
                	if(item==="isfixed" && dataitem[item]){
                		checkbox.css("display","none").attr("disabeld",true);
                	}
                	if(item==="isfixed" || item==="orders")continue;
                    if(item===config.hiddenfield)
                    {
                        checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
                        if(systemids){
		            		systemids += ","+dataitem[item];
		            	}else{
		            		systemids = dataitem[item];
		            	}
                    }else
                    {
                        td = $("<td style='width: " + avgwidth + "'>" + dataitem[item] + "</td>");
                        tr.append(td);
                    }
                }
                container.find(".e8_box_target").append(tr);

            }
            jQuery("#systemIds",config.currentWindow.document).val(systemids);
            registerDragEvent(config);
            createOrRefreshScrollBar("dest_box_middle",config);
        }
		
        ajaxHandler(config.desturl, "currentPage=1&pageSize=" + pageinfo.pagesize, init, "json", false);
    }


    return {

        /**
         * 创建配置信息
         */
        createConfig: function () {
            return new Config();
        },
        /**
         * 根据配置信息生成权限设置界面
         * @param config
         */
        createRightsPluing: function (config) {
            var container = config.container;
            container.append($(constrctxml));
            jQuery("#singleArrowTo",config.currentWindow.document).hover(function(){
            	jQuery(this).attr("src","/js/dragBox/img/4-h_wev8.png")
            },function(){
            	jQuery(this).attr("src","/js/dragBox/img/4_wev8.png")
            });
            jQuery("#singleArrowFrom",config.currentWindow.document).hover(function(){
            	jQuery(this).attr("src","/js/dragBox/img/5-h_wev8.png")
            },function(){
            	jQuery(this).attr("src","/js/dragBox/img/5_wev8.png")
            }).bind("click",function(){
            	jQuery("#delBtn").click();
            });
            jQuery("#multiArrowTo",config.currentWindow.document).hover(function(){
            	jQuery(this).attr("src","/js/dragBox/img/6-h_wev8.png")
            },function(){
            	jQuery(this).attr("src","/js/dragBox/img/6_wev8.png")
            }).bind("click",function(){
            	joinTarget(config,src,true,container);
            });
            jQuery("#multiArrowFrom",config.currentWindow.document).hover(function(){
            	jQuery(this).attr("src","/js/dragBox/img/7-h_wev8.png")
            },function(){
            	jQuery(this).attr("src","/js/dragBox/img/7_wev8.png")
            }).bind("click",function(){
            	delTarget(config,src,true,container);
            });
            var src=initSrcContainer(config);
            initDestContainer(config,src);
            registerArrowEvent(config,src);
            //jQuery(".e8_box_target").jNice();
        }

    }

})();