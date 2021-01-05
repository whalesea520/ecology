(function ($) {
            $.fn.MultDropList = function (options) {
                    var op = $.extend({ wraperClass: "wraper", width: "", height: "", data: "", selected: "",hiddenElem:"",allDesc:"",selectDesc:"",isMust:false,mustColumn:"" }, options);
                    return this.each(function () {
                        var $this = $(this); //指向TextBox
                        var $hf = $("#"+op.hiddenElem); //指向隐藏控件存
                        var conSelector = "#" + $this.attr("id") + ",#" + $hf.attr("id");
                        var $wraper = $(conSelector).wrapAll("<div><div></div></div>").parent().parent().addClass(op.wraperClass);

                        var $list = $('<div class="list"></div>').appendTo($wraper);
                        $list.css({ "width": op.width, "height": op.height });
                        //控制弹出页面的显示与隐藏
                        
                        $(document).click(function () {
                            $list.hide();
                        });
                        
                        $this.click(function (e) {
                            //$(".list").show();
                            //$list.toggle();
                            if($(".list").css("display") == 'none'){
                                $(".list").show();
                            }else{
                                $(".list").hide();
                            }
                            e.stopPropagation();
                        });

                        $list.filter("*").click(function (e) {
                            e.stopPropagation();
                        });
                        //加载默认数据
                        $list.append('<ul><li><input type="checkbox" class="selectAll" value="" /><span>'+op.allDesc+'</span></li></ul>');
                        var $ul = $list.find("ul");

                        //加载json数据
                        var listArr = op.data;
                        var jsonData;
                        for (var i = 0; i < listArr.length; i++) {
                            jsonData = listArr[i];
                            $ul.append('<li><input type="checkbox" value="' + jsonData.id + '" /><span>' + jsonData.name + '</span></li>');
                        }

                        //加载勾选项
                        var seledArr;
                        if (op.selected.length > 0) {
                            seledArr = selected.split(",");
                        }
                        else {
                            seledArr = $hf.val().split(",");
                        }
                        if(seledArr.length == 1 && seledArr[0] == ''){
                            seledArr = [];
                        }else{
                        }
                        if(seledArr.length > 0 ){
                            $.each(seledArr, function (index) {
                                $("li input[value='" + seledArr[index] + "']", $ul).attr("checked", "checked");
    
                                var vArr = new Array();
                                $("input[class!='selectAll']:checked", $ul).each(function (index) {
                                    vArr[index] = $(this).next().text();
                                });
                                $(".multiselect-selected-text").text(vArr.join(","));
                            });
                        }else{
                            $(".multiselect-selected-text").text(op.selectDesc);
                        }
                        //全部选择或全不选
                        $("li:first input", $ul).click(function () {
                            if ($(this).attr("checked")) {
                                $("li input", $ul).attr("checked", "checked");
                            }
                            else {
                                $("li input", $ul).removeAttr("checked");
                                $(".multiselect-selected-text").text(op.selectDesc);
                            }
                        });
                        //点击其它复选框时，更新隐藏控件值,文本框的值
                        $("input", $ul).click(function () {
                            var kArr = new Array();
                            var vArr = new Array();
                            //如果将选择的给取消了,那么就要判断下要将全选按钮如果选中的话给取消掉
                            if($(this).attr("checked") == false){
                                $("input[class='selectAll']").removeAttr("checked");
                            }
                            //如果全部选择那么就将全选按钮选中
                            var selectAll = true;
                            $("input[class!='selectAll']",$ul).each(function(){
                                if (!$(this).attr("checked")) {
                                    selectAll = false;
                                    return; 
                                }
                            })
                            if(selectAll){
                                $("input[class='selectAll']").attr("checked","checked");
                            }
                            
                            $("input[class!='selectAll']:checked", $ul).each(function (index) {
                                kArr[index] = $(this).val();
                                vArr[index] = $(this).next().text();
                            });
                            if(kArr.length == 0){
                                $(".multiselect-selected-text").text(op.selectDesc);
                                $hf.val('');
                                if(op.isMust){
                                	$("#"+op.mustColumn).css("display","");
                                }
                                
                            }else{
                                $hf.val(kArr.join(","));
                                if($(this).hasClass("selectAll") && $(this).attr("checked")){
                                	$(".multiselect-selected-text").text(op.allDesc);
                                }else{
                                	$(".multiselect-selected-text").text(vArr.join(","));
                                }
                                //当非全部的checkbox都选中的时候也就是全部checkbox被选中,也是显示全部
                                if(selectAll){
                                	$(".multiselect-selected-text").text(op.allDesc);
                                }
                                if(op.isMust){
                                	$("#"+op.mustColumn).css("display","none");
                                }
                            }
                        });
                    });
                };
                $.fn.selectAll = function(){
                    if($(".list")){
                        var $ul = $list.find("ul");
                        $("li input", $ul).attr("checked", "checked");
                        $("input",$ul).each(function(){
                            $(this).attr("checked","checked");
                        })
                    }
                }
        })(jQuery);