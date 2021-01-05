
/*初始化查询搜索框*/
function initSearchText(callbackFn){
	var $searchText = $(".e8_searchText");
	var $searchTextTip = $(".e8_searchText_tip");
	
	$searchTextTip.click(function(){
		$searchText[0].focus();
	});
	
	$searchText.focus(function(){
		$searchTextTip.hide();
	});
	
	$searchText.blur(function(){
		if(this.value == ""){
			$searchTextTip.show();
		}
	});
	
	var preSearchText = "";
	$searchText.keyup(function(event){
		if(this.value != preSearchText){
			preSearchText = this.value;
			if(typeof(callbackFn) == "function"){
				currPageIndex = 0;
				callbackFn.call(this, this.value);
			}
		}
	});
}


/*分页*/		
var pageSize = 10;
var currPageIndex = 0;
var pgHtml = "";
var $pg;
var pageNum;
function doPagination(pgDatas, dataRenderCallFn, pSize){
	if(pSize) pageSize=pSize;
	var totalSize = pgDatas.length;
	pageNum = Math.ceil(totalSize/pageSize);
	if(pageNum>0&&currPageIndex>=pageNum){
		currPageIndex=pageNum-1;
	}
	var isInitPageForCall = true;
	
	$pg = $('#pagination');
	

	
	
	$pg.pagination(totalSize, {
		callback: PageCallback,    
		link_to: 'javascript:void(0);',
		prev_text: SystemEnv.getHtmlNoteName(3445),       //上一页按钮里text    
		next_text: SystemEnv.getHtmlNoteName(3446),       //下一页按钮里text    
		items_per_page: pageSize,  //显示条数    
		num_display_entries: 1,    //连续分页主体部分分页条目数   
		current_page: currPageIndex,   //当前页索引    
		num_edge_entries: 2        //两侧首尾分页条目数    
	});
			
	function changeEventAndStatusOfProxy(){
		var $pg_first = $(".e8_paginationProxy span.e8_pg_first");
		var $pg_prev = $(".e8_paginationProxy span.e8_pg_prev");
		var $pg_next = $(".e8_paginationProxy span.e8_pg_next");
		var $pg_last = $(".e8_paginationProxy span.e8_pg_last");
		
		$pg_first.unbind("click", toFirstPage);
		$pg_prev.unbind("click", toPrevPage);
		$pg_next.unbind("click", toNextPage);
		$pg_last.unbind("click", toLastPage);
		
		if(currPageIndex == 0){
			$pg_first.addClass("disabled");
			$pg_prev.addClass("disabled");
		}else{
			$pg_first.removeClass("disabled");
			$pg_prev.removeClass("disabled");
			$pg_first.bind("click", toFirstPage);
			$pg_prev.bind("click", toPrevPage);
		}
		if(currPageIndex >= (pageNum - 1)){
			$pg_next.addClass("disabled");
			$pg_last.addClass("disabled");
		}else{
			$pg_next.removeClass("disabled");
			$pg_last.removeClass("disabled");
			$pg_next.bind("click", toNextPage);
			$pg_last.bind("click", toLastPage);
		}
	}
			
	function getPagedData() {
		var start = currPageIndex * pageSize
		, end = (currPageIndex + 1) * pageSize
		, part  = [];
 
		if(end > totalSize){
			end = totalSize;  
		}
		for(;start < end; start++) {
			part.push(pgDatas[start]);
		}
		return part;
	}
			
	function PageCallback(index, jq) { 
		currPageIndex = index;
		changeEventAndStatusOfProxy();
		$(".e8_paginationProxy span.e8_pg_label").html("第" + (index + 1) + "页");
		if(typeof(dataRenderCallFn) == "function"){
			var speed = isInitPageForCall ? 0 : 200;
			var $dataContainer = $(".e8_left_center ul");
			$dataContainer.fadeOut(speed, function(){
				$dataContainer.find("*").remove();
				var pagedData = getPagedData();
				if(pagedData.length == 0){
					var $dataLi = $("<li class='nodata'><a>"+SystemEnv.getHtmlNoteName(3656,readCookie("languageidweaver"))+"</a></li>");
					$dataContainer.append($dataLi);
				}else{
					$.each(pagedData, function(i, data){
						var $dataLi = $("<li></li>");
						$dataLi.append(dataRenderCallFn.call(jq, data));
						$dataContainer.append($dataLi);
					});
				}
				$dataContainer.fadeIn(speed, function(){
					if(typeof(onPagedCallback) == "function"){	//翻页时的钩子方法
						onPagedCallback(index);
					}
				});
			});
			
		}
		
		isInitPageForCall = false;
	}
}

function isLessThan10(){
	var flag = false;
	if(currentDatas){
		var size = currentDatas.length;
		var st = $(".e8_searchText").val();
		if(st!=""){
			size = srarchData.length;
		}
		if(size<=10){
			flag = true;
		}
	}
	return flag;
}

function toFirstPage(){
	if(isLessThan10()){
		return;
	}
	$pg.trigger('setPage', [0]); 
}

function toPrevPage(){
	if(isLessThan10()){
		return;
	}
	$pg.trigger('prevPage');
}

function toNextPage(){
	if(isLessThan10()){
		return;
	}
	$pg.trigger('nextPage');
}

function toLastPage(){
	if(isLessThan10()){
		return;
	}
	$pg.trigger('setPage', [pageNum - 1]); 
}