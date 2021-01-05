/**
* auto select for ecology8
* created on 2014-8-6
*/
;(function (jQuery) {
	jQuery.fn.autoSelect = function (options) {
		var isDisabled = false;
		var isHide = false;
		if (typeof(options) == 'string') {
			if (options == 'hide') {
				isHide = true;
			} else if (options == 'disabled') {
				isDisabled = true;
			}
		}

		var defaultOptions = {
			inputClass: 'ac_input',
			resultsClass: 'autoSelect sbPerfectBar ps-container',
			markClass: 'autoSelect',
			callback: null,
			width: 170
		};

		options = jQuery.extend(defaultOptions, options);

		var initSelect = function(selectObj) {
			var $select = jQuery(selectObj).hide();
			var totalWidth = $select.width();
			var width = parseInt(options.width);
			if (!isNaN(width) && width > totalWidth) {
				totalWidth = width;
			}
			var $span = jQuery('<span style="display: inline-block;float: none;"></span>')
						.width(totalWidth)
						.attr('name', $select.attr('name') + '_' + options.markClass)
						.attr('id', $select.attr('id') + '_' + options.markClass)
						.addClass(options.markClass)
						.insertAfter($select);
			var $div = jQuery('<div class="sbHolder" style="display: inline-block;"></div>')
						.width(totalWidth)
						.appendTo($span);
			var $a = jQuery('<a href="javascript:void(0);" class="sbToggle"></a>')
						.appendTo($div);
			var $input = jQuery('<input class="sbSelector" style="border: 0px solid #FFF;border-style: none;width:' + (totalWidth - $a.width()) + 'px!important;"/>')
						.height('22px')
						.appendTo($div);

			jQuery("html").live('mousedown', function(e) {
				e.stopPropagation();
				if (e.which != 1 || jQuery(e.target).parents('.' + options.markClass).length <= 0) {
					$a.removeClass('sbToggleOpen');
					$input.trigger('hideResultsNow');
					$input.trigger('checkResult');
				}
			});
			jQuery("html").live('mouseup', function(e) {
				e.stopPropagation();
				if (e.which != 1 || jQuery(e.target).parents('.' + options.markClass).length <= 0) {
					$a.removeClass('sbToggleOpen');
					$input.trigger('hideResultsNow');
					$input.trigger('checkResult');
				}
			});

			$a.focus(function() {
				$input.addClass('autoSelect_a_focus');
			});

			$a.blur(function() {
				$input.removeClass('autoSelect_a_focus');
			});
			
			var isVisibleResults = false;
			$a.mousedown(function() {
				isVisibleResults = $input.isVisibleResults();
			});

			$a.click(function() {
				if (isVisibleResults) {
					$a.removeClass('sbToggleOpen');
					$input.trigger('hideResultsNow');
				} else {
					$a.addClass('sbToggleOpen');
					$input.focus();
				}
			});

			$input.focus(function() {
				$input.addClass('autoSelect_focus');
				$a.addClass('sbToggleOpen');
				$input.removeClass('autoSelect_a_focus');
			});

			$input.blur(function() {
				$input.removeClass('autoSelect_focus');
			});
			
			$input.bind('checkResult', function() {
				if (getLastValue() != $input.val()) {
					$input.val( "" );
					$input.trigger("result", null);
				}
			});

			var data = [];

			$select.find('option').each(function() {
				data.push({name: jQuery(this).text() || '', id: jQuery(this).val() || '', match: jQuery(this).attr('match') || ''});
			});

			var getRow = function(name) {
				for (var row in data) {
					if (data[row].name == name) {
						return data[row];
					}
				}
				return null;
			};

			var setValue = function(row) {
				var val;
				if (row) {
					val = row.name;
				} else {
					val = $select.find('option:selected').text();					
				}
				if (val != $input.val() && getRow(val)) {
					$input.val(val);
				}
				setLastValue();
			};

			var setLastValue = function() {
				$input.attr('lastSelectValue', $input.val());
			};

			var getLastValue = function() {
				return $input.attr('lastSelectValue');
			};

			$select.change(function() {
				setValue();
			});

			var handleResult = function(row) {
				if (!row) {
					//row = getRow(getLastValue());
					row = getRow('');
				}
				if (row != null) {
					$select.val(row.id);
					$select.trigger('change');
				}
			};

			setValue();

			jQuery($input).autocomplete(data, {
				onlyusecache: true,
				showAll:options.showAll,
				width: totalWidth,
				minChars: 0,
				mustMatch: true,
				scroll: true,
				matchContains: true,
				scrollHeight: 240,
				inputClass: options.inputClass,
				resultsClass: options.resultsClass,
				highlight: function(value, term) {
					return "<a href='#'>" + value.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1") + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>") + "</a>";
				},
				formatItem: function(row, i, max) {
					return row.name;
				},
				formatMatch: function(row, i, max) {
					return row.name + row.match;
				},
				formatResult: function(row) {
					return row.name;
				}
			}).result(function(event, row, formatted) {
				handleResult(row);
				if (typeof(options.callback) == 'function') {
					options.callback.call($select, row);
				}
				setValue(row);
				if (row) {
					$a.removeClass('sbToggleOpen');
					$a.focus();
				}
			});
		};

		return this.each(function() {
			if (isHide) {
				jQuery('span.' + options.markClass + '[id="' + jQuery(this).attr('id') + '_' + options.markClass + '"]').hide();
				return;
			}
			if (isDisabled) {
				jQuery('span.' + options.markClass + '[id="' + jQuery(this).attr('id') + '_' + options.markClass + '"] input').attr('disabled', 'disabled');
				jQuery('span.' + options.markClass + '[id="' + jQuery(this).attr('id') + '_' + options.markClass + '"] a').attr('disabled', 'disabled');
				return;
			}

			if (jQuery(this).is('select')) {
				if (!jQuery(this).attr('autoSelect')) {
					jQuery(this).attr('autoSelect', 'true');
					initSelect(this);
				} else {
					jQuery(this).hide();
					jQuery(this).trigger('change');
					jQuery('span.' + options.markClass + '[id="' + jQuery(this).attr('id') + '_' + options.markClass + '"] input').removeAttr('disabled');
					jQuery('span.' + options.markClass + '[id="' + jQuery(this).attr('id') + '_' + options.markClass + '"] a').removeAttr('disabled');
					jQuery('span.' + options.markClass + '[id="' + jQuery(this).attr('id') + '_' + options.markClass + '"]').show();
				}
			}
		});
	}
})(jQuery);

(function(jQuery) {
	jQuery(document).ready(function() {
		jQuery('.autoSelect').autoSelect();
	});
})(jQuery);
