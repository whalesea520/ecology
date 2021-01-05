var myScroll,pullDownEl, pullDownOffset;
var rightViewScroll;

function pullDownAction () {
	if(parent && typeof(parent.cloneCurrFrameToRefresh) == "function"){
		parent.cloneCurrFrameToRefresh(window);
	}else{
		window.location.reload();
	}
	return;
}

function refreshIScroll(){
	if(myScroll){
		myScroll.refresh();
	}
}

function refreshRightViewScroll(){
	if(rightViewScroll){
		rightViewScroll.refresh();
	}
}

function loaded() {
	if(disableDownRefresh){
		pullDownOffset = 0;
	}else{
		pullDownEl = document.getElementById('pullDown');
		$(pullDownEl).show();
		pullDownOffset = pullDownEl.offsetHeight;
	}
	myScroll = new IScroll('#scroll_wrapper', {
		mouseWheel: true,
		topOffset: pullDownOffset,
		preventDefault: false
	});
	
	myScroll.on('refresh', function () {
		if(disableDownRefresh){return;}
		if (pullDownEl.className.match('loading')) {
			pullDownEl.className = '';
			pullDownEl.querySelector('.pullDownLabel').innerHTML = _multiLViewJson['4971'];//下拉刷新
		}
	});
	
	myScroll.on('scrollStart', function () {
		if(typeof(isBeScrolling) != "undefined"){
			isBeScrolling = true;
		}
	});
	
	myScroll.on('scrollMove', function () {
		if(disableDownRefresh){return;}
		if (this.y > 50 && !pullDownEl.className.match('flip')) {
			pullDownEl.className = 'flip';
			pullDownEl.querySelector('.pullDownLabel').innerHTML = _multiLViewJson['4986'];//释放立即刷新
			this.minScrollY = 0;
		} else if (this.y < 50 && pullDownEl.className.match('flip')) {
			pullDownEl.className = '';
			pullDownEl.querySelector('.pullDownLabel').innerHTML = _multiLViewJson['4971'];//下拉刷新
			this.minScrollY = -pullDownOffset;
		}
	});
	
	myScroll.on('scrollEnd', function () {
		setTimeout(function(){
			if(typeof(isBeScrolling) != "undefined"){
				isBeScrolling = false;
			}
		}, 500);
		if(disableDownRefresh){return;}
		if (pullDownEl.className.match('flip')) {
			pullDownEl.className = 'loading';
			pullDownEl.querySelector('.pullDownLabel').innerHTML = _multiLViewJson['4987'];//正在刷新...
			pullDownAction();
		}	
	});
	
	myScroll.refresh();
	
	rightViewScroll = new IScroll("#right_view", {
		mouseWheel: true,
		topOffset: 0,
		preventDefault: false
	});
	rightViewScroll.refresh();
}

if(document.addEventListener){
	document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
}else if(document.attachEvent){
	document.attachEvent("ontouchmove", function (e) { e.preventDefault(); });
}


$(document).ready(function(){
	if(typeof(disableDownRefresh) == 'undefined'){
		disableDownRefresh = false;
	}
	setTimeout(loaded, 600);
});
