(function(window, undefined) {
	var i18nMap = {
		'tip0': {
			'7': '已经是最后一张',
			'8': 'Reach the last',
			'9': '已經是最後一張'
		},
		'tip1': {
			'7': '已经是第一张',
			'8': 'Reach the first',
			'9': '已經是第一張'
		}
	}
	if(window.CarouselUtils) {
		window.CarouselUtils.i18nMap = i18nMap;
	} else if(window.top.CarouselUtils) {
		window.top.CarouselUtils.i18nMap = i18nMap;
	}
	
})(window)


