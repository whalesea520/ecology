$(document).ready(function () {
	$(".tabContainer .tabContent .beTabPage").removeClass("beTabPage").addClass("tabPage");
	$(".tabContainer > .tabTitle > ul > li").on("click", function(){
		if(!$(this).hasClass("selected")){
			$(this).siblings("li.selected").removeClass("selected");
			$(this).addClass("selected");
			var tHref = $(this).attr("href");
			$(tHref).siblings(".tabPage.selected").removeClass("selected");
			$(tHref).addClass("selected");
			
			var $tabAbbrs = $("abbr[loaded='false']", $(tHref));
			var formMecMap = {};
			
			$("abbr", $(tHref)).each(function(){//表单插入非表单控件xxb qc:195292
				var isform = $(this).attr("isform");
				var mecId = $(this).attr("id").substring(5);
				var formid = $(this).attr("formid");
				if(isform == 1){
					formMecMap = {};
					formMecMap[mecId] = [];
				}else{
					for(var key in formMecMap){
						formMecMap[key].push(mecId);
						if(formid == key){
							var ids = formMecMap[key];
							for(var id in ids){
								$("#abbr_"+ids[id]).appendTo($("#" + key));
							}
							formMecMap[key] = [];
						}
					}
				}
			});
			
			$tabAbbrs.each(function(){
				if($(this).length>0){
					var mec_id = $(this).attr("id").substring(5);//abbr_C6F94F8BA6300001FDF5ED2312B04D70
					Mobile_NS.triggerLazyLoad(mec_id);
				}
			});
			//解决tab页插件同步加载情况下日历显示不正常问题
			if(typeof(Swipe_sildeCalendar) != 'undefined' && typeof(Swipe_sildeCalendar.reInit) == 'function'){
				Swipe_sildeCalendar.reInit(); //重新初始化Swiper(日历滑动)
			}
			refreshIScroll();
		}
	});
});