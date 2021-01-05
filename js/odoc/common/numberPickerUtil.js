

function bindSpinEvent(obj) {
	var maxNum = jQuery(obj).attr("maxnum");
	var minNum = jQuery(obj).attr("minnum");
	jQuery(obj).spin({max:maxNum,min:minNum});
	jQuery(obj).blur(function() {
		var num = Number(this.value);
		if(isNaN(num) || num > 59) {
			num = 59;
		} else if(num < 0) {
			num = 0;
		}
		jQuery(obj).val(num);
	})
}