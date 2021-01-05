(function($){
	$.fn.tzCheckbox = function(options){
		// Default On / Off labels:
		
		options = $.extend({
			labels : ['ON','OFF']
		},options);
		
		return this.each(function(){
			var originalCheckBox = $(this),
				labels = [];
			
			// Checking for the data-on / data-off HTML5 data attributes:
			if(originalCheckBox.data('on')){
				labels[0] = originalCheckBox.data('on');
				labels[1] = originalCheckBox.data('off');
			}
			else labels = options.labels;

			// Creating the new checkbox markup:
			var checkBox = $('<span>',{
				"class": 'tzCheckBox '+(this.checked?'checked':''),
				"html":	'<span class="tzCBContent">'+labels[this.checked?0:1]+
						'</span><span class="tzCBPart"></span>'
			});
			if(originalCheckBox.attr('disabled')){
				checkBox.attr("title",SystemEnv.getHtmlNoteName(3508,readCookie("languageidweaver"))).attr('disabled',true);
			}
			// Inserting the new checkbox, and hiding the original:
			if(originalCheckBox.next().is("span") && (originalCheckBox.next().attr("class")==="tzCheckBox " || originalCheckBox.next().attr("class")==="tzCheckBox checked")){
				
			}else{
				checkBox.insertAfter(originalCheckBox.hide());
			}

			checkBox.click(function(){
				if(originalCheckBox.attr('disabled')) return;
				checkBox.toggleClass('checked');				
				var isChecked = checkBox.hasClass('checked');	
				// Synchronizing the original checkbox:
				originalCheckBox.attr('checked',isChecked);
				originalCheckBox.trigger("click");
				originalCheckBox.attr('checked',isChecked);
				checkBox.find('.tzCBContent').html(labels[isChecked?0:1]);
			});
			
			// Listening for changes on the original and affecting the new one:
		});
	};
})(jQuery);

function changeSwitchStatus(obj,checked){
	if(checked==true||checked==false){
		jQuery(obj).attr("checked",checked);
	}
	if(checked){
		jQuery(obj).next("span.tzCheckBox").addClass("checked");
	}else{
		jQuery(obj).next("span.tzCheckBox").removeClass("checked");
	}
}

function disOrEnableSwitch(obj,disabled){
	if(disabled==true||disabled==false){
		jQuery(obj).attr("disabled",disabled);
	}
	if(disabled){
		jQuery(obj).next("span.tzCheckBox").attr("title",SystemEnv.getHtmlNoteName(3508,readCookie("languageidweaver"))).attr('disabled',true);
	}else{
		jQuery(obj).next("span.tzCheckBox").removeAttr("title").removeAttr('disabled');
	}
}

function removeBeatySwitch(obj){
	if(jQuery(obj).next("span.tzCheckBox").length==0)return;
	jQuery(obj).css("display","");
	var tzCheckBox = jQuery(obj).next("span.tzCheckBox");
	tzCheckBox.remove();
}