//修复jquery对文本框,textarea.select的复制
(function (original) {
  jQuery.fn.clone = function () {
    var result           = original.apply(this, arguments),
        my_textareas     = this.find('textarea').add(this.filter('textarea')),
        result_textareas = result.find('textarea').add(result.filter('textarea')),

        my_inputs = this.find('input[type="text"]').add(this.filter('input[type="text"]')),
	    result_input = result.find('input[type="text"]').add(this.filter('input[type="text"]')),

        my_checkboxs = this.find('input[type="checkbox"]').add(this.filter('input[type="checkbox"]')),
	    result_checkboxs = result.find('input[type="checkbox"]').add(this.filter('input[type="checkbox"]')),

		 
        my_selects       = this.find('select').add(this.filter('select')),
        result_selects   = result.find('select').add(result.filter('select'));



      for (var i = 0, l = my_textareas.length; i < l; ++i) jQuery(result_textareas[i]).val(jQuery(my_textareas[i]).val());

	  for (var i = 0, l = my_inputs.length; i < l; ++i) jQuery(result_input[i]).val(jQuery(my_inputs[i]).val());

	  for (var i = 0, l = my_checkboxs.length; i < l; ++i) 
	  {
	      if( jQuery(my_checkboxs[i]).is(':checked') )
		  {
		     jQuery(result_checkboxs[i]).attr("checked", true);
		  }
      }

   
    for (var i = 0, l = my_selects.length;   i < l; ++i) {
      for (var j = 0, m = my_selects[i].options.length; j < m; ++j) {
        if (my_selects[i].options[j].selected === true) {
          result_selects[i].options[j].selected = true;
        }
      }
    }
    return result;
  };
}) (jQuery.fn.clone);