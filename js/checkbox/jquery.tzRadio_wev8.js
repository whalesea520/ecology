(function($){
	$.fn.tzRadio = function(options){
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
				"class"	: 'tzCheckBox '+($(this).val()==='1'?'checked':''),
				"html":	'<span class="tzCBContent">'+labels[this.checked?0:1]+
						'</span><span class="tzCBPart"></span>'
			});
			if(originalCheckBox.attr('disabled')){
				checkBox.attr("title",SystemEnv.getHtmlNoteName(3508,readCookie("languageidweaver"))).attr('disabled',true);
			}
			// Inserting the new checkbox, and hiding the original:
			if(originalCheckBox.next().is("span") && originalCheckBox.next().attr("class")=="tzCheckBox "){
			}else{
				checkBox.insertAfter(originalCheckBox.hide());
			}

			checkBox.click(function(){
				checkBox.toggleClass('checked');				
				var isChecked = checkBox.hasClass('checked');	
				// Synchronizing the original checkbox:
				originalCheckBox.attr('checked',isChecked);
				originalCheckBox.trigger("click");
				originalCheckBox.attr('checked',isChecked);
				checkBox.find('.tzCBContent').html(labels[isChecked?0:1]);
                originalCheckBox.attr("value",(isChecked?1:0));
			});
			
			// Listening for changes on the original and affecting the new one:
		});
	};
})(jQuery);