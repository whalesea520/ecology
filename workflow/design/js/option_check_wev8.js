/***************************************** 

调用方法为： 
Jselect($("#inputid"),{ 
bindid:'bindid', 
hoverclass:'hoverclass', 
optionsbind:function(){return hqhtml();} 
}); 
inputid为下拉框要绑定的文本框id 
bindid为点击弹出/收回下拉框的控件id 
hoverclass为鼠标移到选项时的样式 
hqhtml为绑定的数据 
******************************************/
(function($) {
    $.showselect = {
        init: function(o, options) {
            var defaults = {
                bindid: null,
                //事件绑定在bindid上 
                hoverclass: null,
                //鼠标移到选项时样式名称 
                optionsbind: function() {}, //下拉框绑定函数 
                callback: function() {}
            }
            var options = $.extend(defaults, options);
            if (options.optionsbind != null) { //如果绑定函数不为空 
                this._setbind(o, options);
            }
            if (options.bindid != null) {
                this._showcontrol(o, options);
            }
            var selarray = new Array();
            $(o).next().find("input[type=checkbox]").each(function() {
                if ($(this).attr("checked")) selarray.push($(this).parent().next().text());
            });
            $(o).val(selarray.join(','));
        },
        _showcontrol: function(o, options) { //控制下拉框显示 
            $("#" + options.bindid).toggle(function() {
                $(o).next().slideDown();
            },
            function() {
                $(o).next().slideUp();
            });
            
            $(document.body).bind("click", function () {
            	$(o).next().slideUp();
            });
        },
        _setbind: function(o, options) { //绑定数据 
            var optionshtml = "<div style=\"z-index: 999; position: absolute;\" class='selectInput'>" + options.optionsbind() + "</div>";
            $(o).after(optionshtml);
            var offset = $(o).offset();
            var w = $(o).width();
            var h = $(o).height();
            if (offset.top == 0) {
            	var prvEle = $($(o).parent().parent().prev().children()[0]).children();
            	offset = prvEle.offset();
            	w = prvEle.width();
            	h = prvEle.height();
            }
            
            $(o).next().css({
                top: offset.top + h,
                left: offset.left,
                width: w
            });
            if (options.hoverclass != null) {
                $(o).next().find("tr").hover(function() {
                    $(this).addClass(options.hoverclass);
                },
                function() {
                    $(this).removeClass(options.hoverclass);
                });
            }
            $(o).next().find("input[type=checkbox]").filter("[lang=checked]").each(function() {
                $(this).attr("checked", "checked");
            });
            $(o).next().find("input[type=checkbox]").click(function(evt) {
                var $ckoption = $(this).attr("checked");
                if ($ckoption) {
                    $(this).attr("checked", "");
                } else {
                    $(this).attr("checked", "checked");
                }
            });
            $(o).next().find("tr").click(function(evt) {
            	try {
            		evt.stopPropagation();
            	} catch (e) {};
                var $ckflag = $(this).find("input[type=checkbox]");
                if ($ckflag.attr("checked")) {
                    $ckflag.attr("checked", "");
                    $ckflag.attr("lang", "");
                } else {
                    $ckflag.attr("checked", "checked");
                    $ckflag.attr("lang", "checked");
                }
                var selarray = new Array();
                $(o).next().find("input[type=checkbox]").each(function() {
                    if ($(this).attr("checked")) selarray.push($(this).parent().next().text());
                });
                $(o).val(selarray.join(','));
                options.callback();
            });
            $(o).next().hide();
        }
    }
    Jselect = function(o, json) {
        $.showselect.init(o, json);
    };
})(jQuery);

function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}