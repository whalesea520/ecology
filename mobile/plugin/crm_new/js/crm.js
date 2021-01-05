FastClick.attach(document.body);
var CRM = {
	lng : "",
	lat : "",
	posStatus : "0",	//定位状态 0.未开始定位, 1.正在定位, 2.定位成功, 3.定位失败
	getCurrentPosition : function(callbackFn){
		var that = this;
		that.posStatus = "1";
		if (navigator.geolocation){
			MLocation.getCurrentPosition(function(position){
				var p_lng = position.coords.longitude;
				var p_lat = position.coords.latitude;
				var gpsPoint = new BMap.Point(p_lng, p_lat);
				BMap.Convertor.translate(gpsPoint,0,function(point){
					that.lng = point.lng;
					that.lat = point.lat;
				});
				that.posStatus = "2";
				callbackFn.call(this);
			},function(error){
				that.posStatus = "3";
				callbackFn.call(this);
			},{
				enableHighAcuracy: true,
				timeout: 5000,
				maximumAge: 3000
			});
		}
	},
	fixEmptyValue : function(v){
		if(v == null || v == ""){
			v = "无"
		}
		return v;
	},
	addJS : function(jsPath, fn){
		var headEle = document.getElementsByTagName("head")[0]; 
		var scriptEle = document.createElement("script");
		scriptEle.setAttribute("type", "text/javascript"); 
		scriptEle.setAttribute("src", jsPath); 
		if(typeof(fn) == "function"){
			scriptEle.onload = fn;
		}
		headEle.appendChild(scriptEle);
	},
	ajax : function(url, data, callback){
		if(typeof(data) == "function"){
			callback = data;
			data = null;
		}
		$.get(url, data, function(responseText){
			var result = $.parseJSON(responseText);
			var status = result["status"];
			if(status == "1"){
				callback.call(this, result);
			}else{
				var errMsg = result["errMsg"];
				alert(errMsg);
			}
		});
	},
	panelChange : function(page_in, page_out){
		var id_in = page_in.id, id_out = "";
		if (!id_in) return;
		this.currPageId = id_in;
		var ele_link_in = null, ele_link_out = null;
		if (ele_link_in = document.querySelector("#crm_main .footer a[href$="+ id_in +"]")) {
			ele_link_in.classList.add("active");
		}
		if (page_out) {
			id_out = page_out.id;
			ele_link_out = id_out && document.querySelector("#crm_main .footer a[href$="+ id_out +"]");
			ele_link_out && ele_link_out.classList.remove("active");
		}
		$("#"+id_in+" .pop_menu").hide();
	},
	freshByTab : function(obj){
		var that = this;
		var $obj = $(obj);
		if($obj.hasClass("active")){
			var href = $obj.attr("href");
			var $crm_list = $(href);
			if($crm_list.length > 0){
				var $content = $(".content", $crm_list);
				if(!$content.hasClass("list_refreshing")){	//不是正在刷新状态
					var _scroll = that.crmListScroll[$crm_list.attr("id")];
					if(_scroll){
						var $pullDown = $(".scroll_scroller .pullDown", $crm_list);
						var h = 0;
						if($pullDown.length > 0){
							h = $pullDown.height();
						}
						$(".iScrollVerticalScrollbar", $crm_list).css("opacity", "1");
						_scroll.scrollTo(0, -h, 500, IScroll.utils.ease.quadratic);
						/*
						setTimeout(function(){
							$(".tab li.selected", $crm_list).triggerHandler("click", ["1"]);
						}, 600);*/
					}
				}
			}
		}
	},
	currPageId : null,
	crmListPageNo : {},
	crmListPageSize : 20,
	crmSearchCondition : {},
	refreshListTimestamp : {},
	pushSearchCondition : function(name, value){
		this.crmSearchCondition[this.currPageId][name] = value;
	},
	clearSearchCondition : function(){
		this.crmSearchCondition[this.currPageId] = {};
	},
	crmListScroll : {},
	refreshCrmListScroll : function(){
		var that = this;
		if(that.crmListScroll[that.currPageId]){
			that.crmListScroll[that.currPageId].refresh();
		}
	},
	createScroll : function(selector, refreshCallback){
		var $wrap = $(selector);
		var $pullDown = $(".pullDown", $wrap);
		var pullDownEl = null;
		var pullDownOffset = 0;
		if($pullDown.length > 0){
			$pullDown.show();
			pullDownEl = $pullDown[0];
			pullDownOffset = pullDownEl.offsetHeight;
		}
		var _scroll = new IScroll(selector, {
			mouseWheel: true,
			topOffset: pullDownOffset,
			preventDefault: false,
			scrollbars: "custom",
			fadeScrollbars: true
		});
		
		if(pullDownEl != null){
			_scroll.on('refresh', function () {
				if (pullDownEl.className.match('scroll_loading')) {
					pullDownEl.className = 'pullDown';
					pullDownEl.querySelector('.pullDownLabel').innerHTML = '下拉可以刷新';
				}
			});
			
			_scroll.on('scrollMove', function () {
				if (this.y > 50 && !pullDownEl.className.match('flip')) {
					pullDownEl.className = 'pullDown flip';
					pullDownEl.querySelector('.pullDownLabel').innerHTML = '释放立即刷新';
					this.minScrollY = 0;
				} else if (this.y < 50 && pullDownEl.className.match('flip')) {
					pullDownEl.className = 'pullDown';
					pullDownEl.querySelector('.pullDownLabel').innerHTML = '下拉可以刷新';
					this.minScrollY = -pullDownOffset;
				}
			});
			
			_scroll.on('scrollEnd', function () {
				if (pullDownEl.className.match('flip')) {
					pullDownEl.className = 'pullDown scroll_loading';
					pullDownEl.querySelector('.pullDownLabel').innerHTML = '正在刷新...';
					if(typeof(refreshCallback) == "function"){
						refreshCallback.call(this);
					}
				}	
			});
		}
		_scroll.refresh();
		$wrap.on("touchmove", function (e) { e.preventDefault(); });
		return _scroll;
	},
	buildCrmListPage : function(pageInto, pageOut, options){
		var that = this;
		var $crm_list = $("#crm_main .panel.in");
		that.currPageId = $crm_list.attr("id");
		
		that.crmListScroll[that.currPageId] = that.createScroll("#" + that.currPageId + " div.listContent", function(){
			that.downRefreshCrmList();
		});
		
		var $tab = $(".tab", $crm_list);
		
		function tabEvnInner(callbackFn){
			$("ul li", $tab).click(function(e, flag){
				if(typeof(callbackFn) == "function"){
					var returnV = callbackFn.call(this);
					if(returnV == false){
						return;
					}
				}
				if(!$(this).hasClass("selected") || flag == "1"){
					$(this).siblings("li.selected").removeClass("selected");
					$(this).addClass("selected");
					that.resetCrmSearch();
					that.refreshCrmList("tabChange");
					$(".pop_menu", $crm_list).hide();
				}
			});	
		}
		
		if(that.currPageId == "crm_list" || that.currPageId == "crm_partner" || that.currPageId == "crm_people"){
			var $aroundTab = $("ul li.around", $tab);
			var rightV = $(window).width() - ($aroundTab.offset().left + $aroundTab.width());
			var $popMenu = $(".pop_menu", $crm_list);
			$popMenu.css("right", rightV + "px");
			
			tabEvnInner(function(){
				if($(this).hasClass("around")){
					if(that.posStatus == "0"){
						var $allPopmenu = $("#crm_main .panel .pop_menu");
						var $pos_msg = $("li.pos_msg", $allPopmenu);
						$pos_msg.html("<a>定位中</a>");
						
						that.getCurrentPosition(function(){
							if(that.posStatus == "2"){
								$("ul", $allPopmenu).append("<li data-value=\"1\"><a>1km</a></li><li data-value=\"3\"><a>3km</a></li><li data-value=\"5\"><a>5km</a></li><li data-value=\"10\"><a>10km</a></li>");
							    $pos_msg.remove();
							    
							    $("li", $allPopmenu).click(function(){
									var t = $(this).text();
									var raidus = $(this).attr("data-value");
									
									var expr = $(this).parent().attr("data-for");
									var $t = $(expr);
									
									$t.html(t);
									$t.attr("data-filter", "&opt=around&raidus="+raidus+"&lng="+that.lng+"&lat="+that.lat);
									$t.siblings("li.selected").removeClass("selected");
									$t.addClass("selected");
									
									$(this).parent().parent().hide();
									
									that.resetCrmSearch();
									that.refreshCrmList();
								});
							    
							}else{
								$pos_msg.html("<a>定位失败</a>")
							}
						});
					}
					$popMenu.toggle();
					return false;
				}else{
					if(!$(this).hasClass("selected")){
						$aroundTab.html("附近");
					}
					return true;
				}
			});
		}else{
			tabEvnInner();
		}
		
		$(".load_more", $crm_list).click(function(){
			that.loadCrmList();
		});
		$("form[disabledEnterSubmit]", $crm_list).keydown(function(event){
			if(event.keyCode == 13){return false;}
		});
		var $searchBtn = $(".listSearch .btn", $crm_list);
		var $searchKey = $(".listSearch input", $crm_list);
		$searchBtn.click(function(){
			that.pushSearchCondition("searchKey", encodeURIComponent($searchKey.val()));
			that.refreshCrmList();
			$searchKey[0].blur();
		});
		var searchName = "";
        if(that.currPageId == "crm_list"){
            searchName = "crm_search";
        }else if(that.currPageId == "crm_contacter"){
            searchName = "crm_contacter_search";
        }
		$searchKey.on("input", function(){
			$("#crm_search input[data-fieldname='searchKey']").val($(this).val());
		}).keyup(function(event){
			if(event.keyCode == 13){
				$searchBtn.triggerHandler("click");
			}
		});
		$("ul li", $tab).eq(0).triggerHandler("click");
		if(that.currPageId == "crm_list" || that.currPageId == "crm_contacter"){
			var $dialogCoverContainer = $(".dialogCoverContainer", $crm_list);
			$(".header .addBtn", $crm_list).click(function(e){
				$dialogCoverContainer.toggle();
				e.stopPropagation();
			});
			
			$(".cancel", $crm_list).click(function(){
				$dialogCoverContainer.hide();
			});
			
			$(".menuLi", $crm_list).click(function(){
				$dialogCoverContainer.hide();
			});
		}
		
	},
	refreshCrmList : function(_action){
		var that = this;
		that.crmListPageNo[that.currPageId] = 0;
		var $crm_list = $("#crm_main .panel.in");
		if(_action == "tabChange"){
			that.buildCrmListFormCache(that.currPageId);
		}
		$(".content", $crm_list).addClass("list_refreshing");
		setTimeout(function(){that.refreshCrmListScroll();}, 300);
		
		that.loadCrmList(true, _action);
	},
	buildCrmListFormCache : function(pageid){
		var that = this;
		var $page = $("#" + pageid);
		var $list = $(".list", $page);
		var html = "";
		if(localStorage){
			var tabId = $(".tab ul li.selected", $page).attr("data-tabId");
			var cacheKey = "CRM_List_" + pageid + "_"  + tabId + "_" + E3005CF26D9F9AC78773E16572827297;
			var listData = localStorage.getItem(cacheKey);
			if(listData != null){
				listData = JSON.parse(listData);
				var buildHtmlFunc = "build" + pageid.replace(/^c|_[\w]/g, function(matchs) {
					if(matchs.indexOf('_') != -1){
						matchs = matchs.substring(1);
					}
					return matchs.toUpperCase();
				}) + "Html";
				html = that[buildHtmlFunc](listData);
			}
		}
		$list.html(html);
		if(pageid == "crm_business"){	//商机
			$("canvas", $list).drawPercent();
		}
		that.refreshCrmListScroll();
	},
	updateCrmListCache : function(pageid, listData){
		if(localStorage){
			var $page = $("#" + pageid);
			var tabId = $(".tab ul li.selected", $page).attr("data-tabId");
			var cacheKey = "CRM_List_" + pageid + "_"  + tabId + "_" + E3005CF26D9F9AC78773E16572827297;
			localStorage.removeItem(cacheKey);
			localStorage.setItem(cacheKey, JSON.stringify(listData));
		}
	},
	downRefreshCrmList : function(){
		var that = this;
		that.crmListPageNo[that.currPageId] = 0;
		that.loadCrmList(true);
	},
	crmListRequestAction : {"crm_list" : "getCustomerList", "crm_business" : "getBusinessList", "crm_partner" : "getCustomerList", "crm_people" : "getCustomerList", "crm_contacter": "getContacterList"},
	loadCrmList : function(unShowloading, _action){
		var that = this;
		
		var timestamp = (new Date()).valueOf();	//时间戳
		var currPageId = that.currPageId;
		that.refreshListTimestamp[currPageId] = timestamp;
		
		that.crmListPageNo[currPageId]++;
		var url = "/mobile/plugin/crm_new/crmAction.jsp?action="+that.crmListRequestAction[currPageId]+"&type="+currPageId+"&pageNo="+that.crmListPageNo[currPageId]+"&pageSize="+that.crmListPageSize;
		var $crm_list = $("#crm_main .panel.in");
		var $currTab = $(".tab ul li.selected", $crm_list);
		var filter = $currTab.attr("data-filter") || "";
		url = url + filter;
		var $loading = $(".crm_loading", $crm_list);
		if(unShowloading != true){
			$loading.show();			
		}
		var $load_more = $(".load_more", $crm_list);
		$load_more.hide();
		that.ajax(url, that.crmSearchCondition[currPageId], function(result){
			if(timestamp != that.refreshListTimestamp[currPageId]){
				return;
			}
			
			$loading.hide();
			
			var $list = $(".list", $crm_list);
			if(that.crmListPageNo[currPageId] == 1){
				$list.find("*").remove();
				that.refreshCrmListScroll();
			}
			var datas = result["datas"];
			var buildHtmlFunc = "build" + currPageId.replace(/^c|_[\w]/g, function(matchs) {
				if(matchs.indexOf('_') != -1){
					matchs = matchs.substring(1);
				}
				return matchs.toUpperCase();
			}) + "Html";
			var html = that[buildHtmlFunc](datas);
			$list.append(html);
			
			if(currPageId == "crm_business"){	//商机
				$("canvas", $list).drawPercent();
			}else{
				$(".contactinfo[data-loaded='0']", $list).each(function(){
					that.loadCrmContactInfo($(this), currPageId);
				});
			}
			ToucherUtil.swipeList($list, ".slideBtnContainer");
			
			var totalSize = result["totalSize"];
			if(totalSize <= 0){
				$(".no_data", $crm_list).show();
			}else{
				$(".no_data", $crm_list).hide();
			}
			var totalPageCount;
			if(totalSize % that.crmListPageSize == 0){
				totalPageCount = totalSize / that.crmListPageSize;
			}else{
				totalPageCount = parseInt(totalSize / that.crmListPageSize) + 1;
			}
			if(that.crmListPageNo[currPageId] >= totalPageCount){
				$load_more.hide();
			}else{
				$load_more.show();
			}
			
			if(_action == "tabChange"){
				that.updateCrmListCache(currPageId, datas);
			}
			
			$(".content", $crm_list).removeClass("list_refreshing");
			setTimeout(function(){that.refreshCrmListScroll();}, 300);
			that.refreshCrmListScroll();
		});
	},
	loadCrmContactInfo : function($contactinfo, pageid){
		var that = this;
		var loaded = $contactinfo.attr("data-loaded");
		if(loaded != "0"){
			return;
		}
		$contactinfo.attr("data-loaded", "1");
		
		var tabId = null;
		if(pageid){
			var $page = $("#" + pageid);
			tabId = $(".tab ul li.selected", $page).attr("data-tabId");
		}
		
		var customerid = $contactinfo.attr("data-customerid");
		that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getLastContactRecord&id="+customerid, function(result){
			var d = result["data"];
			var contactdate = d["contactdate"];
			var days = d["days"];

			var html = that.createCrmContactHtml(contactdate, days);
			$contactinfo.html(html);
			
			if(pageid){
				try{
					that.crmListScroll[pageid].refresh();
				}catch(e){}
				var cacheKey = "CRM_List_" + pageid + "_"  + tabId + "_" + E3005CF26D9F9AC78773E16572827297;
				var listData = localStorage.getItem(cacheKey);
				if(listData != null){
					listData = JSON.parse(listData);
					for(var i = 0; i < listData.length; i++){
						var da = listData[i];
						var id = da["id"];
						if(id == customerid){
							da["contactdate"] = contactdate;
							da["days"] = days;
							break;
						}
					}
					localStorage.setItem(cacheKey, JSON.stringify(listData));
				}
			}
		});
	},
	createCrmContactHtml : function(contactdate, days){
		var cd = "";
		if(contactdate == ""){
			cd = "<span style=\"color:red;\">无记录</span>";
		}else{
			cd = contactdate.replace("-","/").replace("-","/")
									.replace("/0","/").replace("/0","/");
		}
		var cl = "";
		if(days > 0){
			cl = "("+days+"天未联系)";
		}
		var html = cd + " <span style=\"color:red;font-size: 12px;\">"+cl+"</span>";
		return html;
	},
	setCrmAttention : function(objid, settype, operatetype, event){
		var that = this;
		var $box = $(event.target);
		$box.closest("li").trigger("swipeRight");
		
		
		that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=doAttention&id="+objid+"&settype="+settype+"&operatetype="+operatetype, function(result){
			var $common_msg = $("#crm_main > .common_msg");
			$common_msg.show().addClass("show");
			setTimeout(function(){
				$common_msg.removeClass("show").hide();
				that.refreshCrmList();
			},1000);
		});
		
		setTimeout(function(){
			if(settype == "1"){
				$box.parent().removeClass("status_0").addClass("status_1");
			}else{
				$box.parent().removeClass("status_1").addClass("status_0");
			}
		},300);
		
		event.stopPropagation();
	},
	buildCrmListHtml : function(datas){
		var that = this;
		var html = "";
		for(var i = 0; i < datas.length; i++){
			var d = datas[i];
			var contactdate = d["contactdate"];
			var days = d["days"];
			var contactinfoHtml = "";
			if(typeof(contactdate) != "undefined" && typeof(days) != "undefined"){
				contactinfoHtml = that.createCrmContactHtml(contactdate, days);
			}else{
				contactinfoHtml = "<span class=\"contactinfo\" data-customerid=\""+d["id"]+"\" data-loaded=\"0\">...</span>";
			}
			
			var statusHtml = "";
			var status = d["status"];
			if(status != ""){
				statusHtml = "<div class=\"flag flag"+d["statusId"]+"\">"+status+"</div>";
			}
			
			var distance = d["distance"];
			var distanceHtml = "";
			var distanceStyle = "";
			if(distance && $.trim(distance) != ""){
				distanceHtml = "<div class=\"distance\">"+distance+"m</div>";
				distanceStyle = "padding-right:60px;";
			}
			html += "<li>"
						+"<a href=\"/mobile/plugin/crm_new/customer.jsp\" data-formdata=\"id="+d["id"]+"\">"
							+statusHtml
							+"<div class=\"title\">"+d["name"]+"</div>"
							//+"<div>客户经理："+d["manager"]+"，最近联系："+contactdate+" <span style=\"color:red;font-size: 10px;\">"+cl+"</span></div>"
							+"<div style=\""+distanceStyle+"\">客户经理: "+d["manager"]+",最近联系: "+contactinfoHtml+"</div>"
							+distanceHtml
						+"</a>"
						+"<div class=\"slideBtnContainer\">"
							+"<div class=\"btnContainer status_"+d["attention"]+"\">"
								+"<div class=\"btnBox box_0\" style=\"background-color: #da8e2c;\" onclick=\"CRM.setCrmAttention("+d["id"]+",'1','1',event)\">标记关注</div>"
								+"<div class=\"btnBox box_1\" style=\"background-color: #d83202;\" onclick=\"CRM.setCrmAttention("+d["id"]+",'0','1',event)\">取消关注</div>"
							+"</div>"
						+"</div>"
					+"</li>";
		}
		return html;
	},
	buildCrmPartnerHtml : function(datas){
		return this.buildCrmListHtml(datas);
	},
	buildCrmPeopleHtml : function(datas){
		return this.buildCrmListHtml(datas);
	},
	buildCrmBusinessHtml : function(datas){
		var html = "";
		for(var i = 0; i < datas.length; i++){
			var d = datas[i];
			var statusHtml = "";
			var status = d["sellstatus"];
			if(status != ""){
				statusHtml = "<div class=\"flag flag"+d["sellstatusid"]+"\">"+status+"</div>";
			}
			var preyield = d["preyield"];
			if(preyield > 0){
				preyield = preyield + "万";
			}
			var titleHtml = d["subject"];
			if(titleHtml.length>15){
				titleHtml = titleHtml.substring(0,15)+"...";
			}
			var customernameHtml = d["customername"];
			if(customernameHtml.length>15){
				customernameHtml = customernameHtml.substring(0,15)+"...";
			}
			html += "<li>"
						+"<a href=\"/mobile/plugin/crm_new/sellchance.jsp\" data-formdata=\"id="+d["id"]+"\">"
							+"<canvas width='80' height='80' data-value=\""+d["probability"]+"\"></canvas>"
							+statusHtml
							+"<div class=\"title\">"+titleHtml+"</div>"
							+"<div class=\"desc\">客户经理: "+d["creater"]+"，客户: "+customernameHtml+"，预期收益: "+ preyield + "</div>"
						+"</a>"
						+"<div class=\"slideBtnContainer\">"
							+"<div class=\"btnContainer status_"+d["attention"]+"\">"
								+"<div class=\"btnBox box_0\" style=\"background-color: #da8e2c;\" onclick=\"CRM.setCrmAttention("+d["id"]+",'1','2',event)\">标记关注</div>"
								+"<div class=\"btnBox box_1\" style=\"background-color: #d83202;\" onclick=\"CRM.setCrmAttention("+d["id"]+",'0','2',event)\">取消关注</div>"
							+"</div>"
						+"</div>"
					+"</li>";
		}
		return html;
	},
	buildCrmContacterHtml: function (datas) {
        var that = this;
        var html = "";
        for (var i = 0; i < datas.length; i++) {
            var d = datas[i];
            var id = d["id"];
            var jobtitle = that.fixEmptyValue(d["jobtitle"]);
            var fullname = d["fullname"];
            var mobilephone = d["mobilephone"];
            var customerName = d["customerName"];
            var viewname = "";
            if(fullname.length == 1 || fullname.length == 2){
                viewname = fullname;
            }else if(fullname.length > 2){
                viewname = fullname.substring(fullname.length-2);
            }else{
                viewname = "未知";
            }
            html += "<li><a href='/mobile/plugin/crm_new/contacter.jsp?id=" + id + "' data-reload='true'><div class='crm_contacter_li_left' style='font-size: 16px;color:#FFF'>" + viewname + "</div><div class='crm_contacter_li_right'><div class='crm_contacter_li_right_up' style='font-size: 16px;color:black'>" + fullname + " | " + jobtitle + "</div><div class='crm_contacter_li_right_down'>" + customerName + "</div></div><div style='clear:left;'></div></a></li>"
        }
        return html
    },
	buildCrmSearchPage : function(pageInto, pageOut, options){
		var that = this;
		var $crmSearch = $("#crm_search");
		$(".clear-btn", $crmSearch).click(function(){
			var $field = $(this).parents(".field[data-flag]");
			if($field.length > 0){
				var flag = $field.attr("data-flag");
				that.setCrmSearchValue("", "", flag, false);
			}
		});
		
		$(".hori_check", $crmSearch).click(function(e){
			if(e.target && e.target.tagName.toLowerCase() == "li"){
				var $this = $(e.target);
				var $realField = $this.parent().siblings("input[data-fieldname]");
				if($this.hasClass("checked")){
					var type = $this.parent().attr("data-type");
					if(type == "CAN_CANCEL"){
						$this.removeClass("checked");
						$realField.val("");
					}
				}else{
					$this.siblings("li.checked").removeClass("checked");
					$this.addClass("checked");
					var v = $this.attr("data-value");
					$realField.val(v);
				}
			}
		});
		
		that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getLabel", function(result){
			var datas = result["datas"];
			var html = "";
			for(var i = 0; i < datas.length; i++){
				var d = datas[i];
				html += "<li data-value=\""+d["id"]+"\">"+d["name"]+"</li>";
			}
			$(".field[data-flag='label'] .hori_check", $crmSearch).html(html);
		});
		
		$("form[disabledEnterSubmit]", $crmSearch).keydown(function(event){
			if(event.keyCode == 13){return false;}
		});
		
		var $searchBtn = $("#crm_search .header .right");
		var $searchKey = $("input[data-fieldname='searchKey']", $crmSearch);
		$searchBtn.click(function(){
			$("input[data-fieldname]", $crmSearch).each(function(){
				var v = $(this).val();
				if(v == null){
					v = "";
				}
				var name = $(this).attr("data-fieldname");
				that.pushSearchCondition(name, v);
			});
			that.refreshCrmList();
			$searchKey[0].blur();
			history.go(-1);
		});
		
		$searchKey.on("input", function(){
			$("#crm_list .listSearch input").val($(this).val());
		}).keyup(function(event){
			if(event.keyCode == 13){
				$searchBtn.triggerHandler("click");
			}
		});
	},
	buildCrmContacterSearchPage: function (pageInto, pageOut, options) {
        var that = this;
        var $crmSearch = $("#crm_contacter_search");
        $(".clear-btn", $crmSearch).click(function () {
            var $field = $(this).parents(".field[data-flag]");
            if ($field.length > 0) {
                var flag = $field.attr("data-flag");
                that.setCrmContacterSearchValue("", "", flag, false);
            }
        });
        $("form[disabledEnterSubmit]", $crmSearch).keydown(function (event) {
            if (event.keyCode == 13) {
                return false
            }
        });
        var $searchBtn = $("#crm_contacter_search .header .right");
        var $searchKey = $("input[data-fieldname='searchKey']", $crmSearch);
        $searchBtn.click(function () {
            $("input[data-fieldname]", $crmSearch).each(function () {
                var v = $(this).val();
                if (v == null) {
                    v = ""
                }
                var name = $(this).attr("data-fieldname");
                that.pushSearchCondition(name, v)
            });
            that.refreshCrmList();
            $searchKey[0].blur();
            history.go(-1)
        });
        $searchKey.on("input", function () {
            $("#crm_contacter .listSearch input").val($(this).val())
        }).keyup(function (event) {
            if (event.keyCode == 13) {
                $searchBtn.triggerHandler("click")
            }
        })
    },
	refreshCustomerPageContacter : function(id){
		var that = this;
		var $crm_cust = $("#crm_cust");
		that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getCustomer&id="+id, function(result){
			var data = result["data"];
			//联系人
			var contacter = that.fixEmptyValue(data["contacter"]);
			var contacterCount = data["contacterCount"];
			if(contacterCount > 0){
				contacter = "<a href=\"/mobile/plugin/crm_new/crmContacts.jsp\" data-formdata=\"id="+id+"\">"+contacter+"<div class=\"moreNumber\">"+contacterCount+"</div></a>";
			}
			$("[data-field='contacter']", $crm_cust).html(contacter);
		});
	},
	crmSearchPageShow : function(pageInto, pageOut, options){
		var that = this;
		if(options.target){
			var $crmSearch = $("#crm_search");
			var $searchMy = $(".search_my", $crmSearch);
			var $tabSel = $("#"+that.currPageId+" .tab ul li.selected");
			if($tabSel.index() == 0){	//我的客户
				$searchMy.show();
			}else{
				$searchMy.hide();
			}
		}
	},
	resetCrmSearch : function(){
		var that = this;
		var $crmSearch = $("#crm_search");
		$(".field[data-flag]", $crmSearch).each(function(){
			var flag = $(this).attr("data-flag");
			var v = "";
			if(flag == "managerType"){
				v = "my";
			}
			that.setCrmSearchValue(v, "", flag, false);
		});
		var $crm_list = $("#" + that.currPageId);
		var $searchKey = $(".listSearch input", $crm_list);
		$searchKey.val("");
		that.clearSearchCondition();
	},
	setCrmSearchValue : function(value, text, flag, isBack){
		var $field = $("#crm_search .field[data-flag='"+flag+"']");
		var $realField = $("input[data-fieldname='"+flag+"']", $field);
		$realField.val(value);
		
		if(value == ""){
			$field.removeClass("hasValue");
		}else{
			$field.addClass("hasValue");
		}
		
		var $more = $(".more", $field);
		if($more.length > 0){
			$(".text", $more).html(text);
		}
		
		var $horiCheck = $realField.siblings(".hori_check");
		if($horiCheck.length > 0){
			$("li", $horiCheck).removeClass("checked");	
			if(value != ""){
				$("li[data-value='"+value+"']", $horiCheck).addClass("checked");
			}
		}
		
		if(isBack == true){
			history.go(-1);
		}
	},
    setCrmContacterSearchValue: function (value, text, flag, isBack) {
        var $field = $("#crm_contacter_search .field[data-flag='" + flag + "']");
        var $realField = $("input[data-fieldname='" + flag + "']", $field);
        $realField.val(value);
        if (value == "") {
            $field.removeClass("hasValue");
        } else {
            $field.addClass("hasValue");
        }
        var $more = $(".more", $field);
        if ($more.length > 0) {
            $(".text", $more).html(text);
        }
        if (isBack == true) {
            history.go(-1);
        }
    },
	/*单个客户*/
	buildCustomerPage : function(id, canEdit){
		var that = this;
		var $crm_cust = $("#crm_cust");
		var $popMenu = $(".pop_menu", $crm_cust);
		$(".header .addBtn", $crm_cust).click(function(e){
			$popMenu.toggle();
			e.stopPropagation();
		});
		
		$crm_cust.click(function(){
			$popMenu.hide();	
		});
		
		that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getCustomer&id="+id, function(result){
			var data = result["data"];
			$(".header .left", $crm_cust).html(data["name"]);
			var managerHtml = data["manager"];
			if(canEdit){
				var managerid = data["managerid"];
				var callbackData = id + "_" + managerid;
				managerHtml += "<span onclick=\"CRM.confrimChangeCrmManager('"+callbackData+"');\" style=\"display: inline;float: right;color: #0161c9;text-decoration: underline;\">修改</span>";
			}
			$("[data-field='manager']", $crm_cust).html(managerHtml);
			
			var address = data["address"];
			if(address != ""){
				address = "<a href=\"/mobile/plugin/crm_new/custAddr.jsp\" data-formdata=\"id="+id+"\">"+address+"</a>";
			}else{
				address = "无";
			}
			$("[data-field='address']", $crm_cust).html(address);
			$("[data-field='status_rating']", $crm_cust).html(that.fixEmptyValue(data["status"]) + ", " + that.fixEmptyValue(data["rating"]));
			$("[data-field='size_n_sector']", $crm_cust).html(that.fixEmptyValue(data["size_n"]) + ", " + that.fixEmptyValue(data["sector"]));
			//商机
			var sellChance = that.fixEmptyValue(data["sellChance"]);
			var sellChanceCount = data["sellChanceCount"];
			if(sellChanceCount > 0){
				sellChance = "<a href=\"/mobile/plugin/crm_new/crmSellChance.jsp\" data-formdata=\"id="+id+"\">"+sellChance+"<div class=\"moreNumber\">"+sellChanceCount+"</div></a>";
			}
			$("[data-field='sellChance']", $crm_cust).html(sellChance);
			//联系人
			var contacter = that.fixEmptyValue(data["contacter"]);
			var contacterCount = data["contacterCount"];
			if(contacterCount > 0){
				contacter = "<a href=\"/mobile/plugin/crm_new/crmContacts.jsp\" data-formdata=\"id="+id+"\">"+contacter+"<div class=\"moreNumber\">"+contacterCount+"</div></a>";
			}
			$("[data-field='contacter']", $crm_cust).html(contacter);
			
			$(".moreNumber", $crm_cust).each(function(){
				var h = $(this).parent("a").height() - $(this).height();
				if(h < 0){
					h = 0;
				}
				$(this).css("top", (h/2) + "px");
			});
		});
		
		$(".load_more", $crm_cust).click(function(){
			that.loadContactRecordList(id);
		});
		
		that.refreshContactRecordList(id);
	},
	/*联系人查看页面*/
    buildContacterPage: function (id, canEdit,customerId) {
    	var that = this;
        var $crm_contacter_detail = $("#crm_contacter_detail");

        var $popMenu = $(".pop_menu", $crm_contacter_detail);

        $(".header .addBtn", $crm_contacter_detail).unbind().click(function (e) {
            $popMenu.toggle();
            e.stopPropagation();
        });

        $crm_contacter_detail.unbind().click(function () {
            $popMenu.hide();
        });
        $(".mask").show();
        that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getContacter&id=" + id, function (result) {
            $(".mask").hide();
            var data = result["data"];
            $(".header .left", $crm_contacter_detail).html("名片信息");
            var lastname = that.fixEmptyValue(data["lastname"]);
            var fullname = that.fixEmptyValue(data["fullname"]);
            var title = that.fixEmptyValue(data["title"]);
            var jobtitle = that.fixEmptyValue(data["jobtitle"]);
            var mobilephone = that.fixEmptyValue(data["mobilephone"]);
            var phoneoffice = that.fixEmptyValue(data["phoneoffice"]);
            var email = that.fixEmptyValue(data["email"]);
            var customerName = that.fixEmptyValue(data["customerName"]);
            // var department = that.fixEmptyValue(data["department"]);
            var customerAddress = that.fixEmptyValue(data["customerAddress"]);
            if (customerAddress != "无") {
                customerAddress = "<a href=\"/mobile/plugin/crm_new/custAddr.jsp\" data-formdata=\"id=" + customerId + "\" data-reload='true'>" + customerAddress + "</a>";
            } else {
                $("[data-field='customerAddress']", $crm_contacter_detail).removeClass("more");
            }
            var viewname = "";
            if(fullname.length == 1 || fullname.length == 2){
                viewname = fullname;
            }else if(fullname.length > 2){
                viewname = fullname.substring(fullname.length-2);
            }else{
                viewname = "未知";
            }
            $("[data-field='cardLastName']", $crm_contacter_detail).html(viewname);
            $("[data-field='cardTitle']", $crm_contacter_detail).html(fullname + " | " + jobtitle);
            $("[data-field='cardCompany']", $crm_contacter_detail).html("<a href='/mobile/plugin/crm_new/customer.jsp' data-formdata='id="+customerId+"' style='color:white;' data-reload='true'>"+customerName+"</a>");
            $("[data-field='title']", $crm_contacter_detail).html(title);
            // $("[data-field='jobtitle']", $crm_contacter).html(jobtitle);
            if (mobilephone != '无') {
                $("[data-field='mobilephone']", $crm_contacter_detail).html("<div style='margin-top: 3px;'><a href='tel://" + mobilephone + "' style='color:deepskyblue;font-size:14px;'>" + mobilephone + "</a></div><div style='float:right;height:20px;'><a href='sms:"+mobilephone+"'><img style='height:20px;' src='/mobile/plugin/crm_new/images/2.png'></a></div>");
            }else{
                $("[data-field='mobilephone']", $crm_contacter_detail).html(mobilephone);
            }
            if (phoneoffice != '无') {
                $("[data-field='phoneoffice']", $crm_contacter_detail).html("<div style='margin-top: 3px;'><a href='tel://" + phoneoffice + "' style='color:deepskyblue;font-size:14px;'>" + phoneoffice + "</a></div>");
            }else{
                $("[data-field='phoneoffice']", $crm_contacter_detail).html(phoneoffice);
            }
            if (email != '无') {
                $("[data-field='email']", $crm_contacter_detail).html("<div style='margin-top: 3px;'><a href='mailto://" + email + "' style='color:deepskyblue;font-size:14px;'>" + email + "</a></div>");
            }else{
                $("[data-field='email']", $crm_contacter_detail).html(email);
            }
            $("[data-field='customerName']", $crm_contacter_detail).html(customerName);
            // $("[data-field='department']", $crm_contacter_detail).html(department);
            $("[data-field='customerAddress']", $crm_contacter_detail).html(customerAddress);
            $(".moreNumber", $crm_contacter_detail).each(function () {
                var h = $(this).parent("a").height() - $(this).height();
                if (h < 0) {
                    h = 0;
                }
                $(this).css("top", (h / 2) + "px");
            });
        });

        $(".load_more", $crm_contacter_detail).click(function () {
            that.loadContactRecordListByContacter(customerId,id);
        });

        that.refreshContactByContacterRecordList(customerId,id);
    },
	confrimChangeCrmManager : function(callbackData){
		/*
		if(!confirm("提示：修改客户经理后将会失去此客户的默认权限，确定修改吗？")){
			return;
		}*/
		Mobilebone.ajax({
			url: "/mobile/plugin/crm_new/hrmList.jsp?flag=changeCrmManager&callback=CRM.changeCrmManager&callbackData="+callbackData
		});
		return;
	},
	changeCrmManager : function(id, name, callbackData){
		var that = this;
		if(id != "" && callbackData){
			var cArr = callbackData.split("_");
			var customerid = cArr[0];
			var oldManagerid = cArr[1];
			if(id != oldManagerid){
				var $crm_cust = $("#crm_cust");
				var $common_msg = $(".common_msg", $crm_cust);
				setTimeout(function(){
					$common_msg.html("操作中，请稍后...").show().addClass("show");
					
					that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=changeCrmManager&customerid="+customerid+"&newmanagerid="+id+"&oldmanagerid="+oldManagerid, function(result){
						var managerHtml = name;
						var callbackData = customerid + "_" + id;
						managerHtml += "<span onclick=\"CRM.confrimChangeCrmManager('"+callbackData+"');\" style=\"display: inline;float: right;color: #0161c9;text-decoration: underline;\">修改</span>";
						$("[data-field='manager']", $crm_cust).html(managerHtml);
						
						$common_msg.html("修改成功").show().addClass("show");
						setTimeout(function(){
							$common_msg.removeClass("show").hide();
							history.go(-1);
							that.refreshCrmList();
						},1000);
						
					});
				}, 250);
			}else{
				/*alert("sb");*/
			}
		}
		
	},
	crmRecordListPageSize : 10,
	resetCrmRecordListPageNo : function(id){
		var that = this;
		eval("that.crmRecordListPageNo_" + id + " = 0;");
	},
	refreshContactRecordList : function(id){
		var that = this;
		that.resetCrmRecordListPageNo(id);
		that.loadContactRecordList(id);
	},
	loadContactRecordList : function(id){
		var that = this;
		eval("that.crmRecordListPageNo_" + id + "++;");
		eval("var pageNo = that.crmRecordListPageNo_" + id + ";");
		var url = "/mobile/plugin/crm_new/crmAction.jsp?action=getContactRecordList&pageNo="+pageNo+"&pageSize="+that.crmRecordListPageSize+"&id="+id+"&newdate="+new Date().getTime();
		var $crm_cust = $("#crm_cust");
		var $loading = $(".crm_loading", $crm_cust);
		$loading.show();
		var $load_more = $(".load_more", $crm_cust);
		$load_more.hide();
		var $no_data = $(".no_data", $crm_cust);
		$no_data.hide();
		that.ajax(url, function(result){
			$loading.hide();
			
			var $list = $(".list", $crm_cust);
			if(pageNo == 1){
				$list.find("*").remove();
			}
			var datas = result["datas"];
			var html = "";
			var imgurls="";
			//附件处理
			var imgFiles="";
			var otheFiles="";
			var flagtime =  new Date().getTime()
			for(var i = 0; i < datas.length; i++){
				
				var d = datas[i];
				var contacter = d["contacter"];	//联系人
				var sellchance = d["sellchance"];	//商机
				var imageurl = d["imageurl"];//图片
				var imgFile = d["imgFile"];//图片格式
				var otheFile = d["otheFile"];//其他格式
				imgFiles = imgFile.split(",");
				otheFiles = otheFile.split(",");
				
				var contacterHtm = "";
				if(contacter != ""){
					contacterHtm = "相关联系人：" + contacter;
				}
				var sellchanceHtm = "";
				if(sellchance != ""){
					sellchanceHtm = "商机：" + sellchance;
				}
				var ht = "";
				if(contacterHtm != "" && sellchanceHtm != ""){
					ht = contacterHtm + " , " + sellchanceHtm;
				}else{
					ht = (contacterHtm == "") ? ((sellchanceHtm == "") ? "" : sellchanceHtm) : contacterHtm;
				}
				html += "<li>"
							+ "<img class='cimg' src=\""+d["avator"]+"\"/>"
							+ "<div>"+d["creater"]+"</div>"
							+ "<div>"+d["createdate"]+" "+d["createtime"]+"</div>"
							+ "<div>"+d["description"]+"</div>"
							+ ((ht == "") ? "" : "<div>"+ht+"</div>")
							//图片格式
							var imgSrcid='';
							var imgSrcActiveid='';
							if(imgFile!=""){
							html +="<div style=\"display:inline-block;\">";
                            html +="<input type=\"hidden\" id=\"flagtime\" value=\""+flagtime+"\"/>";
                                imgFiles.forEach(function(v){
                                    if(v!="") {
                                        html+="<img class='min' style=\"margin-top:5px;margin:2px;\" _val=\""+imgFile+"\"  onclick=\"imgChange(this,"+v+")\" src=\"/weaver/weaver.file.FileDownload?fileid="+v+"\" />";
                                    }
                                    
                                });
                                html +="</div>"
                            }
							 //其他格式
                            if(otheFile!=""){
                            html+="<div>";
                                otheFiles.forEach(function(v){
                                    if(v!="") { 
                                    html+="</br>";
                                    html+="<a href='javascript:void(0)' _val=\""+v+"\" onclick='fileDownload(this)' ><span style='color:#003399;margin-left: 0px;font-size: 12px;'>"+v.split('-')[1]+"</span></a>";
                                    }
                                    
                                });
                              html+="</div>";  
                            }
						+"</li>";
			}
			$list.append(html);
			
			var totalSize = result["totalSize"];
			if(totalSize <= 0){
				$no_data.show();
			}
			var totalPageCount;
			if(totalSize % that.crmRecordListPageSize == 0){
				totalPageCount = totalSize / that.crmRecordListPageSize;
			}else{
				totalPageCount = parseInt(totalSize / that.crmRecordListPageSize) + 1;
			}
			if(pageNo >= totalPageCount){
				$load_more.hide();
			}else{
				$load_more.show();
			}
		});
	},
	crmRecordListByContacterPageSize: 10,
    resetCrmRecordListByContacterPageNo: function (id) {
        var that = this;
        eval("that.crmRecordListByContacterPageNo_" + id + " = 0;");
    },
    refreshContactByContacterRecordList: function (customerId,id) {
        var that = this;
        that.resetCrmRecordListByContacterPageNo(id);
        that.loadContactRecordListByContacter(customerId,id);
    },
    loadContactRecordListByContacter: function (customerId,id) {
        var that = this;
        eval("that.crmRecordListByContacterPageNo_" + id + "++;");
        eval("var pageNo = that.crmRecordListByContacterPageNo_" + id + ";");
        var url = "/mobile/plugin/crm_new/crmAction.jsp?action=getContactRecordList&pageNo=" + pageNo + "&pageSize=" + that.crmRecordListByContacterPageSize + "&contacterid=" + id+"&id="+customerId+"&tmedatetim="+new Date().getTime();
        var $crm_contacter_detail = $("#crm_contacter_detail");
        var $loading = $(".crm_loading", $crm_contacter_detail);
        $loading.show();
        var $load_more = $(".load_more", $crm_contacter_detail);
        $load_more.hide();
        var $no_data = $(".no_data", $crm_contacter_detail);
        $no_data.hide();
        that.ajax(url, function (result) {
            $loading.hide();

            var $list = $(".list", $crm_contacter_detail);
            if (pageNo == 1) {
                $list.find("*").remove();
            }
            var datas = result["datas"];
            var html = "";
            for (var i = 0; i < datas.length; i++) {
                var d = datas[i];
                var contacter = d["contacter"];	//联系人
                var sellchance = d["sellchance"];	//商机
                var contacterHtm = "";
                if (contacter != "") {
                    contacterHtm = "相关联系人：" + contacter;
                }
                var sellchanceHtm = "";
                if (sellchance != "") {
                    sellchanceHtm = "商机：" + sellchance;
                }
                var ht = "";
                if (contacterHtm != "" && sellchanceHtm != "") {
                    ht = contacterHtm + " , " + sellchanceHtm;
                } else {
                    ht = (contacterHtm == "") ? ((sellchanceHtm == "") ? "" : sellchanceHtm) : contacterHtm;
                }
                html += "<li>"
                    + "<img src=\"" + d["avator"] + "\"/>"
                    + "<div>" + d["creater"] + "</div>"
                    + "<div>" + d["createdate"] + " " + d["createtime"] + "</div>"
                    + "<div>" + d["description"] + "</div>"
                    + ((ht == "") ? "" : "<div>" + ht + "</div>")
                    + "</li>";
            }
            $list.append(html);

            var totalSize = result["totalSize"];
            if (totalSize <= 0) {
                $no_data.show();
            }
            var totalPageCount;
            if (totalSize % that.crmRecordListByContacterPageSize == 0) {
                totalPageCount = totalSize / that.crmRecordListByContacterPageSize;
            } else {
                totalPageCount = parseInt(totalSize / that.crmRecordListByContacterPageSize) + 1;
            }
            if (pageNo >= totalPageCount) {
                $load_more.hide();
            } else {
                $load_more.show();
            }
        });
    }
};
Mobilebone.rootTransition = CRM;
Mobilebone.evalScript = true;

$.fn.drawPercent = function(){
	for(var i = 0; i < this.length; i++){
		var canvas = this[i];
		if($(canvas).attr("drawed") == "true"){
			continue;
		}
		var cts = null;
		if (canvas.getContext) {
			cts = canvas.getContext('2d');
		}else{
			continue;
		}
		var process = parseInt($(canvas).attr("data-value"));
		
		var x=40,y=40,radius=40,backColor='#e5e5e5',proColor='#0161c9',fontColor='#0161c9';
		cts.beginPath();  
		cts.moveTo(x, y);  
		cts.arc(x, y, radius, 0, Math.PI * 2, false);  
		cts.closePath();  
		cts.fillStyle = backColor;  
		cts.fill();

		cts.beginPath();   
		cts.moveTo(x, y);  
		cts.arc(x, y, radius, Math.PI * 1.5, Math.PI * 1.5 -  Math.PI * 2 * process / 100, true);  
		cts.closePath();  
		cts.fillStyle = proColor;  
		cts.fill(); 

		cts.beginPath();  
		cts.moveTo(x, y); 
		cts.arc(x, y, radius - (radius * 0.2), 0, Math.PI * 2, true);  
		cts.closePath();
		cts.fillStyle = 'rgba(255,255,255,1)';  
		cts.fill();  

		cts.font = "normal 20px arial";  
		cts.fillStyle = fontColor;  
		cts.textAlign = 'center';  
		cts.textBaseline = 'middle';  
		cts.moveTo(x, y);  
		cts.fillText(process+"%", x, y); 
		
		$(canvas).attr("drawed", "true");
	}
};