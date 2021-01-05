jQuery(document).ready(function(){
	//屏蔽右键菜单
	document.oncontextmenu = function(){
		return false;
	};
	
	var favourite = new Favourite();
	favourite.init();
	
	/**从web IM打开时，会带有这个值，默认需要把收藏类型这个查询条件初始化**/
	var _favtype = jQuery("#favtype option:selected").val();
	if(_favtype != "" && _favtype != undefined){
		favourite.setConditions("favtype",_favtype);
	}
	
	var favouriteDir = new FavouriteDir(favourite);
	favouriteDir.init();
	favouriteDir.setSelected("-1");    /**默认选中我的收藏目录*/
	favourite.setConditions("dirId","-1");
	registerOtherEvt(favourite);
	
	/**回车搜索的事件*/
	jQuery("#pagename").bind("keydown",function(e){
		if(e.keyCode == 13){ 
			/**
			 * 搜索前，先去除收藏列表下方的提示信息，搜索结果返回后再加上
			 */
			var loadingDiv = jQuery("#loadingDiv");
			loadingDiv.html("");
			favourite.search();	
		} 
	});
});


/******************************************************************
 * 收藏目录的各种操作
 * @author fmj
 *****************************************************************/
FavouriteDir = function(fav){
	this._favourite = fav;
	this._instance = this;
};

FavouriteDir.prototype={
	/**
	 * 选中的记录的id
	 */
	_selectid : "-1000",
	/**
	 * 实例
	 */
	_instance : null,
	/**
	 * 收藏内容的实例
	 */
	_favourite : null,
	/**
	 * 初始化
	 */
	init : function(){
		this._instance.registerEvt();
		this.initMoveDirEvt();
		this._instance.perfect();
	},
	/**
	 * 根据id，设定指定的目录选中
	 */
	setSelected : function(id){
		var $this = this._instance;
		var alldirs = jQuery("#leftdir div.diritem");
		alldirs.each(function(){
			var that = jQuery(this);
			that.removeClass("selected");
			that.data("selected","false");
			that.data("isedit","false");
			var itemid = that.data("id");
			if(itemid == id){
				this._selectid = id;
				jQuery("#dirId").val(id);
				that.addClass("selected");
				that.data("selected","true");
				if(itemid != "-1000" && itemid != "-1"){   //itemid=-1000为根目录，itemid=-1，表示默认的目录，都不可编辑和删除
					$this.showOperation(that);
				}
			}else{
				$this.hideOperation(that);
			}
		});
	},
	/**
	 * 设置指定的元素选中
	 * @param itemObj
	 * @return
	 */
	setItemSelected : function(itemObj){
		var $this = this._instance;
		var itemid = itemObj.data("id");
		var alldirs = jQuery("#leftdir div.diritem");
		alldirs.each(function(){
			var that = jQuery(this);
			that.removeClass("selected");
			that.data("selected","false");
			that.data("isedit","false");
			var id = that.data("id");
			if(itemid != id){
				$this.hideOperation(that);
			}
		});
		
		itemObj.addClass("selected");
		itemObj.data("selected","true");
		this._selectid = itemid;
		jQuery("#dirId").val(itemid);
		if(itemid != "-1000" && itemid != "-1"){   //itemid=-1000为根目录，itemid=-1，表示默认的目录，都不可编辑和删除
			$this.showOperation(itemObj);
		}
	},
	/**
	 * 注册事件
	 * @return
	 */
	registerEvt : function(){
		var $this = this._instance;
		var alldirs = jQuery("#leftdir div.diritem");
		alldirs.each(function(i){
			if(i != alldirs.length - 1){   //不是最后一个，最后一个为新建目录的操作
				//取每一个目录的id等信息
				var that = jQuery(this);
				var dataOpts = that.attr("data-options");
				if(!!dataOpts){
					dataOpts = eval("({" + dataOpts +"})");
					that.data(dataOpts);
				}
				that.removeAttr("data-options");
				that.unbind("click").bind("click",function(evt){
					var dirs = jQuery("#leftdir div.diritem");
					var itemid = that.data("id");
					
					var srcEle = evt.srcElement || evt.target;
					var srcObj = jQuery(srcEle);
					if(srcObj.closest("div.dirop").length > 0){   //只是编辑或者删除操作，并不是选中了目录
						//先其他的编辑操作隐藏掉
						dirs.each(function(j){
							var jthis = jQuery(this);
							var selected = jthis.data("selected");
							var isedit = jthis.data("isedit") || "false";
							//if(selected != "true"){
								$this.hideOperation(jthis);
							//}
							jQuery(this).data("isedit","false");
						});
						
						if(i != 0 && itemid != "-1"){   //第一个为全部目录，itemid=-1，表示默认的目录，都不可编辑和删除
							$this.showOperation(that);
							that.data("isedit","true");
						}
					}else{    //选中了目录
						$this.setItemSelected(jQuery(this));
						var favouriteIntance = $this._favourite;
						/**
						 * 选中目录时，加载该目录下的数据，但是先把列表下方的提示信息去除
						 * 加载成功后，再显示该信息
						 */
						var loadingDiv = jQuery("#loadingDiv");
						loadingDiv.html("");   
						favouriteIntance.search();
					}
				});
			}else{
				jQuery(this).unbind("click").bind("click",function(){
					$this.newItem();
				});
			}
		});
		
		alldirs.bind("mouseover",function(){
			jQuery(this).addClass("over");
		}).bind("mouseout",function(){
			jQuery(this).removeClass("over");
		});
		
		alldirs.each(function(i){
			if(i != 0 && i != alldirs.length - 1){   //不是最后一个，最后一个为新建目录的操作
				jQuery(this).bind("mouseover",function(){
					var that = jQuery(this);
					var itemid = that.data("id");
					//每一个目录添加操作的按钮
					if(itemid != "-1"){  //id=-1的为默认的目录，不可编辑和删除
						$this.showOperation(that);
					}
				}).bind("mouseout",function(){
					var that = jQuery(this);
					var selected = that.data("selected");
					var isedit = that.data("isedit");
					isedit = (isedit == null || isedit == undefined) ? "false" : isedit;
					if(/*selected == "false" &&*/ isedit == "false"){
						//隐藏操作的按钮
						$this.hideOperation(that);
					}
				});
			}
		});
	},
	/**
	 * 新建目录
	 * @return
	 */
	newItem : function(){
		var $this = this._instance;
		var _selectid = this._selectid;
		
		var cb = function(instance,data){
			jQuery("#custdirs").html(data);
			instance.init();
			instance.setSelected(_selectid);  //选中原本的目录
			instance.perfect("update");
			instance.reload();      //刷新收藏移动时要显示的目录
		}
		
		var url = "/favourite/FavouriteDir.jsp";
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = favourite.favouritepanel.newfavourite;
		dialog.Width = 400;
		dialog.Height = 250;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.callbackfunParam = $this;
		dialog.callbackfun = cb;
		dialog.show();
	},
	/**
	 * 显示操作按钮
	 * @param dirObj
	 * @return
	 */
	showOperation : function(dirObj){
		var $this = this._instance;
		var opObjs = dirObj.find("div.dirop");
		if(opObjs.length > 0){
			opObjs.show();
		}else{
			var itemid = dirObj.data("id");
			var editTitle = favourite.favouritepanel.edit;
			var deleteTitle = favourite.favouritepanel.deletes;
			var opstr = " <div class=\"dirop\">"
				+ " <span class=\"edit\"><a title=\"" + editTitle + "\" href=\"javascript:void(0);\" ></a></span>"
				+ " <span class=\"delete\"><a title=\"" + deleteTitle + "\" href=\"javascript:void(0);\" ></a></span>"
				+ " </div>";
			jQuery(opstr).appendTo(dirObj).show().find("span").each(function(){
				var that = jQuery(this);
				if(that.hasClass("edit")){
					that.bind("click",function(){
						$this.editItem(dirObj);
					});
				}else{
					that.bind("click",function(){
						$this.deleteItem(dirObj);
					});
				}
				that.bind("mouseover",function(){
					jQuery(this).find("a").addClass("over");
				}).bind("mouseout",function(){
					jQuery(this).find("a").removeClass("over");
				})
			});
		}
	},
	/**
	 * 隐藏操作按钮
	 * @param dirObj
	 * @return
	 */
	hideOperation : function(dirObj){
		var opObjs = dirObj.find("div.dirop");
		if(opObjs.length > 0){
			opObjs.hide();
		}
	},
	/**
	 * 编辑目录
	 * @param itemObj
	 * @return
	 */
	editItem : function(itemObj){
		var $this = this._instance;
		var _selectid = this._selectid;
		var itemId = itemObj.data("id");
		
		var cb = function(instance,data){
			jQuery("#custdirs").html(data);
			instance.init();
			instance.setSelected(_selectid);  //选中原本的目录
			instance.perfect("update");
			instance.reload();      //刷新收藏移动时要显示的目录
		}
		
		var url = "/favourite/FavouriteDir.jsp?id=" + itemId;
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = favourite.favouritepanel.edittitle;
		dialog.Width = 400;
		dialog.Height = 250;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.callbackfunParam = $this;
		dialog.callbackfun = cb;
		dialog.show();
	},
	/**
	 * 删除目录
	 * @param itemObj
	 * @return
	 */
	deleteItem : function(itemObj){
		var $this = this._instance;
		var _selectid = this._selectid;
		var itemId = itemObj.data("id");
		top.Dialog.confirm(favourite.favouritepanel.deletetopic,function(){
			if(itemId != "-1" && itemId != "-1000"){  //-1，我的收藏，-1000根目录“全部目录”
				var postData = {action : "delete",id : itemId};
				jQuery.post("/favourite/FavDirOperation.jsp",postData,function(data){
					jQuery("#custdirs").html(data);
					//因为重新加载过目录，因此事件需要重新初始化
					$this.init();
					$this.setSelected("-1");
					$this.perfect("update");
					$this.reload();      //刷新收藏移动时要显示的目录
					
					/**
					 * 删除目录后，默认选中"我的收藏"目录，并刷新收藏的内容列表
					 */
					var favouriteIntance = $this._favourite;
					/**
					 * 选中目录时，加载该目录下的数据，但是先把列表下方的提示信息去除
					 * 加载成功后，再显示该信息
					 */
					var loadingDiv = jQuery("#loadingDiv");
					loadingDiv.html("");   
					favouriteIntance.search();   //刷新收藏
				});
			}
		});
		
	},
	/**
	 * 美化
	 * @return
	 */
	perfect : function(opt){
		var h1 = 0;
		jQuery("#leftdir>div.diritem").each(function(){
			h1 += jQuery(this).height();
		});
		
		var h2 = jQuery("#custdirs").height();
		var h = h1 + h2;
		jQuery("#leftdir").height(h);
		//jQuery("#leftdir").css("overflow","visible");
		//左侧收藏夹目录美化
		if(opt == null || opt == undefined){
			opt = "init";
		}
		if(opt == "init"){
			jQuery("#scrollcontainer").perfectScrollbar();
		}else{
			jQuery("#scrollcontainer").perfectScrollbar(opt);
			jQuery("#contentDiv").perfectScrollbar("doScrollPos");
		}
	},
	/**
	 * 重新加载
	 * @return
	 */
	reload : function(){
		jQuery("#movePanel").hide();  //隐藏收藏移动的目录
		var $this = this;
		jQuery.post("/favourite/FavDirOperation.jsp",{action:"getExcludeDir"},function(data){
			if(!!data){
				jQuery("#movePanel .main").html(data);
				$this.initMoveDirEvt();
			}
		})
	},
	/**
	 * 初始化移动时要选择的目录的事件
	 * @return
	 */
	initMoveDirEvt : function(){
		var movePanel = jQuery("#movePanel");
		//为每一个目录添加事件
		movePanel.find("li").each(function(){
			var that = jQuery(this);
			var dataOpts = that.attr("data-options");
			if(!!dataOpts){
				dataOpts = eval("({" + dataOpts +"})");
			}
			that.data(dataOpts);
			that.removeAttr("data-options");
			that.bind("mouseover",function(){
				jQuery(this).addClass("over");
			}).bind("mouseout",function(){
				jQuery(this).removeClass("over");
			});
		});
	}
};


/************************************************************
 * 收藏夹内容的各种操作
 ************************************************************/
Favourite = function(){}; 

Favourite.prototype = {
	/**
	 * 初始化操作
	 */
	init : function(){
		this.registerEvt();
		this.perfect();
		this.updatePage();  //先更新分页的参数，再注册分页的事件
		this.updatePageEvt();
	},
	/**更新分页的参数*/
	updatePage : function(jqHtml){
		var $this = this;
		var _total = 0;
		var _current = 0;
		var _maxId = -1;
		var _isinit = this._page.isinit;
		var _isreload = this._page.isreload;
		if(!!jqHtml){   //从分页返回的html中解析这些值
			jqHtml.each(function(){
				var elename = jQuery(this).attr("name");
				if(elename == "total"){   //数据总条数
					_total = jQuery(this).val();
				}
				if(elename == "current"){   //已加载的数据条数
					_current = jQuery(this).val();
				}
				if(elename == "maxId"){   //数据的最大id（所有数据，而非当前页的数据)
					_maxId = jQuery(this).val();
				}
			});
		}else{    //初始化加载时，从页面中解析
			_total = jQuery("#total").val();
			_current = jQuery("#current").val();
			_maxId = jQuery("#maxId").val();
		}
		_total = Number(_total);
		_current = Number(_current);
		_maxId = Number(_maxId);
		$this.setPage("current",_current);
		$this.setPage("total",_total);  //这个值也有可能改变，因为会删除数据
		if(_isinit){  //初始化加载时，才需要更新此值
			$this.setPage("maxId",_maxId);
			$this.setPage("isinit",false);
		}
		
		if(_isreload){   //默认不是重新加载
			$this.setPage("isreload",false);
		}
	},
	/**
	 * 分页加载的事件注册
	 */
	updatePageEvt : function(){
		var $this = this;
		var loadingDiv = jQuery("#loadingDiv");
		var dataOpts = loadingDiv.attr("data-options");
		if(!!dataOpts){
			dataOpts = eval("({" + dataOpts +"})");
		}
		var loadingmsg = dataOpts.loadingmsg;
		var nodata = dataOpts.nodata;
		var nomoredata = dataOpts.nomoredata;
		
		var _total = this._page.total;
		var _current = this._page.current;
		var _pagesize = this._page.pagesize;
		if(_total <= _current && _total > 0 && _total > _pagesize){
			loadingDiv.html(nomoredata);
		}else if(_total == 0){
			loadingDiv.html(nodata);
		}else if(_total <= _pagesize){   //说明只有一页数据
			loadingDiv.html("");
		}
		
		if(_current < _total && _total > 0){
			jQuery("#contentDiv").unbind("scroll").bind("scroll",function(){
				hideLevelPanel();
				jQuery("#movePanel").hide();
				var msgScrollTop = loadingDiv.offset().top;
				var height = 515;   //内容区域的高度
				if(msgScrollTop <= height + 20){   //重新加载数据
					showLoaddingMsg2();
					loadingDiv.html(loadingmsg);
					$this.load();
				}
			});
		}else{
			jQuery("#contentDiv").unbind("scroll").bind("scroll",function(){
				hideLevelPanel();
				jQuery("#movePanel").hide();
			});
		}
	},
	/**
	 * 存放搜索的条件
	 */
	_conditions : {
		dirId : "-1000",   /**收藏夹目录id*/
		favtype : "",      /**收藏类型*/
		pagename : "",     /**收藏标题*/
	},
	/**
	 * 分页的信息
	 */
	_page :{
		isinit : true,     /**是否初始化加载*/
		isreload : false,  /**是否是重新加载，重新加载会加载当前已加载的数据,而非分页加载*/
		total: 0,          /**总的数据条数*/
		current : 0,       /**当前已加载的数据条数*/
		maxId : -1,        /**当前查询到的数据的最大的id*/
		pagesize : 10      /**每一次滚动加载的数据量*/
	},
	/**
	 * 设置条件
	 */
	setConditions : function(key,value){
		if(key in this._conditions){
			value = (value == null) ? "" : value; 
			this._conditions[key] = value;
		}
	},
	/**
	 * 设置分页的信息
	 */
	setPage : function(key,value){
		if(key in this._page){
			value = value;
			this._page[key] = value;
		}
	},
	/**
	 * 重载数据
	 */
	reload : function(){
		var $this = this;
		$this.setPage("isreload",true);
		$this.setPage("isinit",true);
		hideLevelPanel();   //可能存在还未关闭的，先关闭
		jQuery("#movePanel").hide();
		//显示加载中的遮罩，避免此时做了一些操作
		showLoaddingMsg();
		$this.load();
	},
	/**
	 * 加载数据
	 * @return
	 */
	load : function(){
		jQuery("#contentDiv").unbind("scroll");  //首先要先移除滚动的事件
		var $this = this;
		var data = {};
		//搜索条件
		for(key in this._conditions){
			var value1 = this._conditions[key];
			value1 = (value1 == null) ? "" : value1;
			data[key] = value1;
		}
		
		//分页信息
		for(key in this._page){
			var value2 = this._page[key];
			value2 = (value2 == null) ? "" : value2;
			data[key] = value2;
		}
		/*****转发的临时处理方式*****/
		var isshowrepeat = jQuery("#isshowrepeat").val();
		data.isshowrepeat = isshowrepeat;
		
		var _isinit = this._page.isinit;
		var _isreload = this._page.isreload;
		jQuery.post("/favourite/FavouriteQuery.jsp",data,function(result){
			hideLoaddingMsg();
			if(!!result){
				//因为这些隐藏域，初始化加载时就已经有，分页加载完成，处理数据前，先删除，避免页面上存在重复的
				jQuery("#total").remove();
				jQuery("#count").remove();
				jQuery("#current").remove();
				jQuery("#maxId").remove();
				jQuery("#favids").remove();
				var _count = 0;
				var _favids = null;
				jQuery(result).each(function(){
					var elename = jQuery(this).attr("name");
					if(elename == "count"){   //当前页面返回的数据条数
						_count = jQuery(this).val();
					}
					
					if(elename == "favids"){   //当前页所有数据的id
						_favids = jQuery(this).val();
					}
				});
				var jqHtml = jQuery(result);
				$this.updatePage(jqHtml);  //更新分页的参数
				_count = Number(_count);
				//有数据
				if(_count > 0){
					if(_isinit){   //初始化
						jQuery("#favContents").html(result);
					}else{     //分页加载
						jQuery("#favContents").append(result);
					}
					$this.registerEvt(_favids);
					$this.perfectCheckBox(_favids);
				}else{
					var loadingDiv = jQuery("#loadingDiv");
					var dataOpts = loadingDiv.attr("data-options");
					if(!!dataOpts){
						dataOpts = eval("({" + dataOpts +"})");
					}
										
					if(_isinit){   //初始化
						jQuery("#favContents").html(result);
					}
				}
				
				/**
				 * 重新处理滚动条
				 */
				if(_isinit && !_isreload){  //不是重载
					$this.perfect("update");
				}else{
					$this.perfect("update",false);
				}
				
				window.setTimeout(function(){
					//更新分页滚动的事件,添加在滚动条处理后，避免此时滚动条滚动，而触发滚动加载的事件	
					$this.updatePageEvt();      	
				},10);
			}
		});
	},
	/**
	 * 搜索
	 * @return
	 */
	search : function(){
		var dirid = jQuery("#dirId").val();
		var favtype = jQuery("#favtype option:selected").val();
		var pagename = jQuery("#pagename").val();
		this.setConditions("dirId",dirid);
		this.setConditions("favtype",favtype);
		this.setConditions("pagename",pagename);
		
		this.setPage("isinit",true);
		this.setPage("maxId",-1);
		hideLevelPanel();   //可能存在还未关闭的，先关闭
		jQuery("#movePanel").hide();
		//显示加载中的遮罩，避免此时做了一些操作
		showLoaddingMsg();
		this.load();
	},
	
	/**
	 * 事件注册
	 * @param _favids:为空时，就是所有的内容都注册事件，不为空，主要是用于每次加载一页数据时的处理
	 */
	registerEvt : function(_favids){
		var $this = this;
		var jqobjs = jQuery("#favContents div.favitem");
		if(!!_favids){
			var tempObjs = null;
			var idarr = _favids.split(",");
			for(var k = 0; k < idarr.length; k++){
				if(tempObjs == null){
					tempObjs = jQuery("#fav" + idarr[k]);
				}else{
					tempObjs = tempObjs.add(jQuery("#fav" + idarr[k]));
				}
			}
			if(tempObjs.length > 0){
				jqobjs = tempObjs;
			}
		}
		
		jqobjs.each(function(){
			var that = jQuery(this);
			var dataOpts = that.attr("data-options");
			if(!!dataOpts){
				dataOpts = eval("({" + dataOpts +"})");
				that.data(dataOpts);
			}
			that.removeAttr("data-options");
		});
		
		//每一条记录的鼠标点击、移入、移出效果
		jqobjs.bind("click",function(){
			var $that = jQuery(this); 
			var favid = $that.data("id");
			jQuery("#favContents div.favitem").each(function(){
				var that = jQuery(this); 
				var id = that.data("id");
				that.data("isclick","false");
				that.removeClass("click");
				if(favid != id){
					that.find("div.favop").removeClass("showop").addClass("hideop");
					var level = that.data("level");
					if(level == "1"){  //重要级别为普通，则也需要隐藏
						that.find("div.fav_level").css("visibility","hidden");
					}
				}
			});
			//点击时，也要默认将这些操作按钮显示出来
			$that.data("isclick","true");
			$that.addClass("click");
			/*
			$that.find("div.favop").removeClass("hideop").addClass("showop");
			var level = $that.data("level");
			if(level == "1"){  //重要级别为普通，则需要显示
				$that.find("div.fav_level").css("visibility","visible");
			}*/
			
			var movePanel = jQuery("#movePanel");
			var objid1 = movePanel.data("objid");
			if(objid1 == null || objid1 == undefined || objid1 != favid){
				jQuery("#movePanel").hide();  //隐藏收藏移动的目录
			}
			
			var levelPanel = jQuery("#levelPanel");
			var objid2 = levelPanel.data("objid");
			if(objid2 == null || objid2 == undefined || objid2 != favid){
				hideLevelPanel();   //可能存在还未关闭的，先关闭
			}
		}).bind("mouseover",function(){
			jQuery(this).addClass("over");
			jQuery(this).find("div.favop").removeClass("hideop").addClass("showop");
			var level = jQuery(this).data("level");
			if(level == "1"){  //重要级别为普通，则需要显示
				jQuery(this).find("div.fav_level").css("visibility","visible");
			}
		}).bind("mouseout",function(){
			var isclick = jQuery(this).data("isclick");
			var level = jQuery(this).data("level");
			jQuery(this).removeClass("over");
			jQuery(this).find("div.favop").removeClass("showop").addClass("hideop");
			if(level == "1"){  //重要级别为普通，则也需要隐藏
				jQuery(this).find("div.fav_level").css("visibility","hidden");
			}
		});
		
		
		//操作按钮的鼠标移入、移出效果，点击事件
		jqobjs.find("div.favop span").bind("mouseover",function(){
			jQuery(this).find("a").addClass("over");
		}).bind("mouseout",function(){
			jQuery(this).find("a").removeClass("over");
		}).bind("click",function(evt){
			var that = jQuery(this);
			var topParent = that.closest("div.favitem");
			if(topParent.length > 0){
				var favid = topParent.data("id");
				if(that.hasClass("repeat")){
					$this.operation.repeatfav(favid,$this);
				}else if(that.hasClass("edit")){
					$this.operation.editfav(favid,$this);
				}else if(that.hasClass("move")){
					$this.operation.movefav(evt,topParent,$this);
				}else if(that.hasClass("delete")){
					$this.operation.deletefav(favid,$this);
				}
			}
		});
		
		//重要程度的鼠标移入移出效果
		jqobjs.find("div.fav_level span").bind("mouseover",function(){
			jQuery(this).addClass("over");
		}).bind("mouseout",function(){
			jQuery(this).removeClass("over");
		});
		
		//重要程度的点击事件
		jqobjs.each(function(){
			var that = jQuery(this);
			var favid = that.data("id");
			that.find("div.fav_level").bind("click",function(evt){
				$this.operation.editLevel(evt,favid,$this);
			});
		})
	},
	/**
	 * 每一条记录的各种操作
	 */
	operation :{
		/**
		 * 转发
		 */
		repeatfav : function(favid,$instance){
			var content = jQuery("#content_"+favid).val();
			var favouriteObjId = jQuery("#favouriteObjid_"+favid).val();
			var msgobjname = jQuery("#msgobjname_"+favid).val();
			var filesize = jQuery("#filesize_"+favid).val();
			var filetype = jQuery("#filetype_"+favid).val();
			
			var favInfo = {
				favouriteObjId: favouriteObjId,
				msgobjname: msgobjname,
				content: content,
				filesize: filesize,
				filetype: filetype
			};

			parentwin.IM_Ext.repeatFromFav(favInfo, function(issuccess){
				if(issuccess){
					showMsg("转发成功！");
				}
			});
		},
		/**
		 * 编辑
		 */
		editfav : function(favid,$instance){
			var cb = function(instance){
				instance.reload();
			};
			
			var url = "/favourite/EditSysFavourite.jsp?id=" + favid;
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Title = favourite.maingrid.editfavourite;
			dialog.Width = 400;
			dialog.Height = 300;
			dialog.Drag = true;
			dialog.URL = url;
			dialog.callbackfunParam = $instance;
			dialog.callbackfun = cb;
			dialog.show();
		},
		/**
		 * 编辑重要程度
		 */
		editLevel : function(evt,id,$instance){
			var levelPanel = jQuery("#levelPanel");
			var objid = levelPanel.data("objid");
			var favop = jQuery("#level" + id);
			var favLeft = favop.position().left;
			var favTop = favop.position().top;
			favLeft = favLeft + 115;
			favTop = favTop + 75;
			var pos = {left:favLeft,top:favTop};
			levelPanel.css(pos); 
			
			//为每一个选项添加事件
			levelPanel.find("div.levelitem").each(function(){
				var that = jQuery(this);
				that.data("favid",id);
				that.unbind("click").bind("click",function(){
					var favid = jQuery(this).data("favid");
					var level = jQuery(this).data("level");
					levelPanel.hide();
					var postData = {};
					postData.favid = favid;   //收藏的id
					postData.importlevel = level;  //重要程度
					postData.action = "editLevel";
					showLoaddingMsg(operatingMsg);
					jQuery.post("/favourite/FavouriteOp.jsp",postData,function(data){
						$instance.reload();  //重新加载
					});
				});
			});
			
			if(!objid || objid != id){   //不同，说明点击的不是同一个
				levelPanel.data("objid",id);
				levelPanel.show();
			}else{
				levelPanel.toggle();
			}
			stopEvent();
			
			//因为阻止了当前操作的事件冒泡，因此当前一条收藏记录的选中效果就没有了，需要单独去触发
			var favitemObj = jQuery("#fav" + id);
			$instance.operation.selectFavItem(favitemObj);  
		},
		/**
		 * 移动
		 */
		movefav : function(evt,favitemObj,$instance){
			var movePanel = jQuery("#movePanel");
			var objid = movePanel.data("objid");
			var favid = favitemObj.data("id");
			var dirid = favitemObj.data("dirid");
			
			var perfectPanel = function(){
				var h1 = movePanel.find(".top").height();
				var h2 = movePanel.find(".main").height();
				var h3 = movePanel.find(".bottom").height();
				var h = h1 + h2 + h3;
				//movePanel.height(h);
				var scrollObj = jQuery("#moveScrollContainer").perfectScrollbar("getScrollObj");
				if(scrollObj.length > 0){
					jQuery("#moveScrollContainer").perfectScrollbar("update");
					scrollObj.doScrollPos(0,0);
				}else{
					jQuery("#moveScrollContainer").perfectScrollbar();
				}
			}
			
			//计算位置
			var _offset = favitemObj.find("div.favop span.move").position();
			var _top = _offset.top + 70;
			var _left = _offset.left + 105;
			
			var h1 = movePanel.find(".top").height();
			var h2 = 0;
			
			var liObjs = movePanel.find(".main li");
			if(liObjs.length > 0){
				liObjs.each(function(){
					var liObj = jQuery(this);
					var _id = liObj.data("id");
					if(_id == dirid){   //当前目录不是默认的目录，则将该目录隐藏，不允许选择
						liObj.hide();
					}else{
						liObj.show();
						liObj.data("favid",favid);
						h2 += liObj.height();
						//为目录添加事件
						liObj.unbind("click").bind("click",function(){
							jQuery("#movePanel").hide();
							var $that = jQuery(this);
							var $id = $that.data("id");
							var $favid = $that.data("favid");
							var postData = {};
							postData.action = "move";
							postData.dirid = $id;
							postData.favid = $favid;
							showLoaddingMsg(operatingMsg);
							jQuery.post("/favourite/FavouriteOp.jsp",postData,function(data){
								hideLoaddingMsg();
								$instance.reload();  //重新加载
							});
						});
					}
				});
			}
			
			var h3 = movePanel.find(".bottom").height();
			if(h2 >= 250){
				h2 = 250;
				addScrollPanel();
			}else{
				removeScrollPanel();
			}
			var h = h1 + h2 + h3;
			//window.console.log("top1===" + _top);
			//window.console.log("h===" + h);
			if(_top + h > 550){   //当top超过这个值时，下方可能会显示不全，往上方展开
				_top = _top - h - 45;
			}
			//window.console.log("top2===" + _top);
			var pos = {left:_left, top:_top};
			jQuery("#movePanel").css(pos);
			if(!objid || objid != favid){   //不同，说明点击的不是同一个,要新打开
				movePanel.data("objid",favid);
				jQuery("#movePanel").show();
				//添加滚动条
				perfectPanel();
			}else{
				jQuery("#movePanel").toggle();
			}
			stopEvent();
			//因为阻止了当前操作的事件冒泡，因此当前一条收藏记录的选中效果就没有了，需要单独去触发
			$instance.operation.selectFavItem(favitemObj);  
		},
		/**
		 * 批量移动
		 */
		movefavs : function(evt,btnObj,$instance){
			var movePanel = jQuery("#movePanel");
			var objid = movePanel.data("objid");
			var favid = "movebtn";
			var favids = "";
			
			jQuery("#favContents div.favitem").each(function(){
				var that = jQuery(this);
				var checkboxObj = that.find("div.favinfo input[type='checkbox']");
				if(checkboxObj.length > 0){
					var checked = checkboxObj.attr("checked");
					if(checked == "true" || checked == true){
						favids += "," + that.data("id");
					}
				}
			});
			
			if(favids.length <= 0){
				top.Dialog.alert(favourite.maingrid.noselect);
				return;
			}
			
			var perfectPanel = function(){
				var h1 = movePanel.find(".top").height();
				var h2 = movePanel.find(".main").height();
				var h3 = movePanel.find(".bottom").height();
				var h = h1 + h2 + h3;
				//movePanel.height(h);
				var scrollObj = jQuery("#moveScrollContainer").perfectScrollbar("getScrollObj");
				if(scrollObj.length > 0){
					jQuery("#moveScrollContainer").perfectScrollbar("update");
					scrollObj.doScrollPos(0,0);
				}else{
					jQuery("#moveScrollContainer").perfectScrollbar();
				}
			}
			
			//计算位置
			var _offset = btnObj.position();
			var _top = _offset.top + 30;
			var _left = _offset.left + 130;
			
			var h1 = movePanel.find(".top").height();
			var h2 = 0;
			//添加事件
			var liObjs = movePanel.find(".main li");
			if(liObjs.length > 0){
				liObjs.each(function(){
					var liObj = jQuery(this);
					var _id = liObj.data("id");
					liObj.show();
					liObj.data("favids",favids);
					h2 += liObj.height();
					//为目录添加事件
					liObj.unbind("click").bind("click",function(){
						jQuery("#movePanel").hide();
						var $that = jQuery(this);
						var $id = $that.data("id");
						var $favids = $that.data("favids");
						var postData = {};
						postData.action = "move";
						postData.dirid = $id;
						postData.favid = $favids;
						showLoaddingMsg(operatingMsg);
						jQuery.post("/favourite/FavouriteOp.jsp",postData,function(data){
							hideLoaddingMsg();
							$instance.reload();  //重新加载
						});
					});
				});
			}
			
			var h3 = movePanel.find(".bottom").height();
			if(h2 >= 250){
				h2 = 250;
				addScrollPanel();
			}else{
				removeScrollPanel();
			}
			var h = h1 + h2 + h3;
			//window.console.log("top1===" + _top);
			//window.console.log("h===" + h);
			if(_top + h > 550){   //当top超过这个值时，下方可能会显示不全，往上方展开
				_top = _top - h - 45;
			}
			//window.console.log("top2===" + _top);
			var pos = {left:_left, top:_top};
			jQuery("#movePanel").css(pos);
			
			if(!objid || objid != favid){   //不同，说明点击的不是同一个,要新打开
				movePanel.data("objid",favid);
				jQuery("#movePanel").show();
				//添加滚动条
				perfectPanel();
			}else{
				jQuery("#movePanel").toggle();
			}
			stopEvent();
		},
		/**
		 * 删除
		 */
		deletefav : function(favid,$instance){
			var postData = {};
			postData.favid = favid;
			postData.action = "delete";
			
			top.Dialog.confirm(favourite.maingrid.suredelete,function(){
				showLoaddingMsg(operatingMsg);
				jQuery.post("/favourite/FavouriteOp.jsp",postData,function(data){
					$instance.reload();  //重新加载
				});
			});
		},
		/**
		 * 批量删除
		 */
		deletefavs : function($instance){
			var favid = "";
			jQuery("#favContents div.favitem").each(function(){
				var that = jQuery(this);
				var checkboxObj = that.find("div.favinfo input[type='checkbox']");
				if(checkboxObj.length > 0){
					var checked = checkboxObj.attr("checked");
					if(checked == "true" || checked == true){
						favid += "," + that.data("id");
					}
				}
			});
			
			if(favid.length <= 0){
				top.Dialog.alert(multiDeleteMsg);
				return;
			}
			
			//window.console.log("favid===" + favid);
			top.Dialog.confirm(favourite.maingrid.suredelete,function(){
				var postData = {};
				postData.favid = favid;
				postData.action = "delete";
				showLoaddingMsg(operatingMsg);
				jQuery.post("/favourite/FavouriteOp.jsp",postData,function(data){
					$instance.reload();  //重新加载
				});
			});
		},
		/**添加收藏*/
		addfavs : function(type,$instance){
			//窗口的回调事件
			var _callback = function(type,data){
				if(data.id != "" && data.id != "0"){
					var postData = {};
					var ids = data.id;
					var names = data.name;
					postData = data;
					
					var favouritetype = 0;
					if(type == 0){  //文档
						favouritetype = 1;
					}else if(type == 1){  //流程
						favouritetype = 2;
					}else if(type == 2){  //客户
 						favouritetype = 4;
					}else if(type == 3){  //项目
						favouritetype = 3;
					}
					postData.favouritetype = favouritetype;
					//选中的目录
					var dirid = jQuery("#dirId").val();
					postData.dirid = dirid;
					postData.action = "add";
					jQuery.post("/favourite/FavouriteOp.jsp",postData,function(backdata){
						$instance.search();  //重新加载
					});
				}
			};
			
			var url = "";
			var title = "";
			if(type == 0)
			{
				url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp&mouldID=doc";
				title = favourite.mainpanel.adddoc;   //添加文档类收藏
			}
			else if(type == 1)
		    {
		    	url = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
		    	title = favourite.mainpanel.addworkflow;   //添加流程类收藏
		    }
		    else if(type == 3)
		    {
		    	url = "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp&mouldID=proj";
		    	title = favourite.mainpanel.addproj;   //添加项目类收藏
		    }
		    else if(type == 2)
		    {
		    	url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp&mouldID=customer";
		    	title = favourite.mainpanel.addcus;   //添加客户类收藏
		    }
			
			//弹出窗口
			dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Title = title;
			dialog.Width = 500;
			dialog.Height = 600;
			dialog.Drag = true;
			dialog.URL = url;
			dialog.callbackfunParam = type;
			dialog.callbackfun = _callback;
			//dialog.OKEvent = _callback;
			dialog.show();
		},
		/**
		 * 选中一条记录
		 */
		selectFavItem : function(favitemObj){
			var favid = favitemObj.data("id");
			jQuery("#favContents div.favitem").each(function(){
				var that = jQuery(this); 
				var id = that.data("id");
				that.data("isclick","false");
				that.removeClass("click");
			});
			favitemObj.data("isclick","true");
			favitemObj.addClass("click");
		}
	},
	/**
	 * 滚动条美化
	 * @param: opt,初始化或者更新
	 * @param: totop,是否保留滚动条原来滚动到的位置
	 */
	perfect : function(opt,totop){
		var cheight = jQuery("#favContents").height();
		var mheight = jQuery("#loadingDiv").height();
		var theight = cheight + mheight;
		jQuery("#content").height(theight);
		
		if(opt == null || opt == undefined){
			opt = "init";
		}
		if(totop == null || totop == undefined){
			totop = true;
		}
		if(opt == "init"){
			jQuery("#contentDiv").perfectScrollbar();
		}else{
			jQuery("#contentDiv").perfectScrollbar(opt);
			if(totop){   //滚动到原来的位置
				jQuery("#contentDiv").perfectScrollbar("getScrollObj").doScrollPos(0,0);
			}
		}
	},
	/**
	 * 美化check框
	 */
	perfectCheckBox : function(_favids){
		if(!!_favids){
			var tempObjs = null;
			var idarr = _favids.split(",");
			for(var k = 0; k < idarr.length; k++){
				if(tempObjs == null){
					tempObjs = jQuery("#fav" + idarr[k]);
				}else{
					tempObjs = tempObjs.add("#fav" + idarr[k]);
				}
			}
			if(tempObjs.length > 0){
				tempObjs.jNice();
			}
		}
	}
};

/**
 * 隐藏重要程度的div
 * @return
 */
function hideLevelPanel(){
	jQuery("#levelPanel").hide();
}

/**
 * 显示加载中div
 * @return
 */
function showLoaddingMsg(msgTxt){
	if(msgTxt == null || msgTxt == undefined){
		msgTxt = loaddingMsg;
	}
	jQuery("#loaddingCover div.text").html(msgTxt);
	jQuery("#loaddingCover div.icon").show();
	jQuery("#loaddingCover").show();
	jQuery("#msgCover").show();
}

function showLoaddingMsg2(){
	jQuery("#loaddingCover div.text").html("");
	jQuery("#loaddingCover div.icon").hide();
	jQuery("#loaddingCover").show();
	jQuery("#msgCover").show();
}

/**
 * 隐藏加载中div
 * @return
 */
function hideLoaddingMsg(){
	jQuery("#loaddingCover").hide();
	jQuery("#msgCover").hide();
}


/**
 * 注册其他的事件
 * @return
 */
function registerOtherEvt(_favourite){
	/**
	 * 添加按钮的点击、鼠标移入移出
	 */
	jQuery("#addbtn").bind("click",function(){
		
	}).bind("mouseover",function(){
		jQuery("#addbtn>div").addClass("click");
		jQuery("#addItems").show();
		jQuery("#addbtn div.bottom").show();
	}).bind("mouseout",function(){
		jQuery("#addbtn>div").removeClass("click");
		jQuery("#addItems").hide();
		jQuery("#addbtn div.bottom").hide();
	});
	
	/**
	 * 批量添加按钮的下拉菜单
	 */
	jQuery("#addItems li.addItem").each(function(i){
		var that = jQuery(this);
		that.bind("mouseover",function(){
			jQuery(this).addClass("over");
		}).bind("mouseout",function(){
			jQuery(this).removeClass("over");
		}).bind("click",function(){  //批量添加收藏
			_favourite.operation.addfavs(i,_favourite);
			jQuery("#addItems").hide();
		});
	});
	
	/**
	 * 移动、删除按钮的鼠标移入、移出效果
	 */
	jQuery("div.opbtns>div").bind("mouseover",function(){
		jQuery(this).addClass("over");
	}).bind("mouseout",function(){
		jQuery(this).removeClass("over");
	});
	
	/**
	 * 批量移动按钮的事件
	 */
	jQuery("#movebtn").bind("click",function(evt){
		var that = jQuery(this);
		_favourite.operation.movefavs(evt,that,_favourite);
	});
	
	/**
	 * 批量删除按钮的事件
	 */
	jQuery("#deletebtn").bind("click",function(){
		_favourite.operation.deletefavs(_favourite);
	});
	
	/**
	 * 搜索按钮的事件
	 */
	jQuery("div.searchinput div.icon").bind("click",function(){
		_favourite.search();	
	});
	
	/**
	 * 修改重要程度的菜单的鼠标移入、移出效果
	 */
	jQuery("#levelPanel").find("div.levelitem").each(function(){
		var that = jQuery(this);
		var dataOpts = that.attr("data-options");
		if(!!dataOpts){
			dataOpts = eval("({" + dataOpts +"})");
			that.data(dataOpts);
		}
		that.removeAttr("data-options");
	}).bind("mouseover",function(){
		jQuery(this).addClass("over");
	}).bind("mouseout",function(){
		jQuery(this).removeClass("over");
	});
}

/**
 * 为移动要显示的目录，添加滚动条
 * @return
 */
function addScrollPanel(){
	var scrollObj = jQuery("#moveScrollContainer");
	if(scrollObj.length > 0){
		//nothing to do
	}else{
		jQuery("#movePanel div.moveto").after(jQuery("<div id=\"moveScrollContainer\" style=\"overflow:hidden;height:250px;width:100px;\"></div>"));
		scrollObj = jQuery("#moveScrollContainer");
		jQuery("#movePanel div.main").appendTo(scrollObj);
	}
}

function removeScrollPanel(){
	var scrollObj = jQuery("#moveScrollContainer");
	if(scrollObj.length > 0){
		var mainHtml = scrollObj.html();
		scrollObj.remove();
		jQuery("#movePanel div.moveto").after(jQuery(mainHtml));
	}
}
//阻止事件冒泡
function stopEvent() {
	var event = window.event || arguments.callee.caller.arguments[0]
  		if(!event){
  			return false;
  		}
		if (event.stopPropagation) { 
			// this code is for Mozilla and Opera 
		event.stopPropagation();
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
	return false;
}
$(document).bind('click.autoHide', function(e){
	jQuery("#levelPanel").hide();
	jQuery("#movePanel").hide();
});
