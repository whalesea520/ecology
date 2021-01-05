/*
 * rule-based design 
 * Date: 2013-11-29 12:34:21 -0500
 * Revision: 1
 */
var rulePanelCenter = (function () {
    return {
        initParamSetPanel:function (container) {
            //初始化数据集选项
            //$("select[name='paramdataset']").append($("<option value=''>工作流程</option>"));
            //初始化数据列
            //$("select[name='paramdatafield']").append($("#category").html());

            container.find("#paramtype").change(function(e){

                 var data=$(this).val();
                 $("#compareoption").find("option").remove();
                 if(data==="0") {
                     $("#compareoption").append("<option value='='>等于</option><option value='<>'>不等于</option><option value='in'>包含</option><option value='not in'>不包含</option>");
                 } else if(data==="1" || data == "2") {
                     $("#compareoption").append("<option value='>'>大于</option><option value='>='>大于等于</option><option value='<'>小于</option><option value='<='>小于等于</option><option value='='>等于</option><option value='<>'>不等于</option>");
                 } else if(data==="3") {
                     $("#compareoption").append("<option value='include'>包含</option><option value='uninclude'>不包含</option><option value='in'>属于</option><option value='not in'>不属于</option>");
                 }

            });


            //高级设置面板内部
            //添加按钮
            container.find("#paramadd").click(function () {
                //var paramdataset = container.find("select[name='paramdataset']").val();
                //var datafield = container.find("select[name='paramdatafield']").val();
                var datafield = container.find("input[name='paramdatafield']").val();
                var compareoption = container.find("select[name='compareoption']").val();
                var compareoptionlabel = container.find("select[name='compareoption']").find("option:selected").text();
                var paramtype = container.find("select[name='paramtype']").val();
                var paramvalue;
                if(paramtype==="2")
                    paramvalue = container.find("select[name='paramvalue']").val();
                else
                paramvalue = container.find("input[name='paramvalue']").val();
                var orignvalue = paramvalue;
                if (compareoption == "in" || compareoption == "not in") {
                    if (paramtype == "1") {
                        var datatemp = paramvalue.split(",");
                        paramvalue = "(";
                        for (var i = 0; i < datatemp.length; i++) {
                            paramvalue = paramvalue + "\"" + datatemp[i] + "\",";
                        }
                        paramvalue = paramvalue.substring(0, paramvalue.length - 1) + ")";
                    }
                    else if(paramtype == "4"   ||  paramtype == "5")
                    {
                        var datatemp = paramvalue.split(",");
                        paramvalue = "(";
                        for (var i = 0; i < datatemp.length; i++) {
                            paramvalue = paramvalue + "" + datatemp[i] + ",";
                        }
                        paramvalue = paramvalue.substring(0, paramvalue.length - 1) + ")";
                    }
                    else
                     if(paramtype == "3")
                         paramvalue = "$(" + paramvalue + ")";

                    else
                         paramvalue = "(" + paramvalue + ")";
                } else if (compareoption == "like") {
                    if (paramtype == "3")
                        paramvalue = "$(" + paramvalue + ")";
                    else
                        paramvalue = "%" + paramvalue + "%";
                }
                else if (paramtype == "1")
                    paramvalue = "\"" + paramvalue + "\"";
                else if(paramtype == "3")
                    paramvalue = "$(" + paramvalue + ")";
                else
                    paramvalue =  paramvalue ;
                    
                 
                var hiddenarea = datafield + "-;-" + compareoption + "-;-" + paramtype + "-;-" + orignvalue + "-;-" + (datafield + " " + compareoption + " " + paramvalue) + "-;-" + (datafield + " " + compareoptionlabel + " " + paramvalue);
                var hiddenElement = $("<input name='child' type='hidden' value='" + hiddenarea + "'>");
                var row = $("<tr class='unclickedColor'><td><input type='checkbox' name='paramcheckbox'><span>" + expressdescElement(hiddenElement) + "</span></td></tr>")
                row.children("td").append(hiddenElement);
                row.click(function () {
                    var trs = container.find("#paramtable tr");
                    for (var i = 0; i < trs.length; i++) {
                        if ($(trs[i]).hasClass("clickedColor")) {
                            $(trs[i]).removeClass("clickedColor");
                            $(trs[i]).addClass("unclickedColor");
                        }
                    }
                    $(this).removeClass("unclickedColor");
                    $(this).addClass("clickedColor");
                    //判断是否可编辑
                    var spandata = $(this).find("span").html();

                    var children = $(this).find("input[name='child']");

                    if (children.length > 1) {
                        container.find("#paramdupdate").attr("disabled", "disabled");
                    }
                    else if (children.length == 1) {
                        container.find("#paramdupdate").removeAttr("disabled");
                        spandata = $(children[0]).val().split("-;-");
                        //container.find("select[name='paramdataset']").val(spandata[0]);
                        //container.find("select[name='paramdatafield']").val(spandata[1]);
                        container.find("input[name='paramdatafield']").val(spandata[0]);
                        container.find("select[name='compareoption']").val(spandata[1]);
                        container.find("select[name='paramtype']").val(spandata[2]);
                        if(spandata[2]==="2")
                        {
                            var  paramboolinfo=$("<select id='paramvalue' name='paramvalue' ><option value='true'>true</option><option value='false'>false</option></select>")
                            container.find("#paramvalue").remove();
                            container.find("#paraminfodiv").append(paramboolinfo);
                            container.find("select[name='paramvalue']").val(spandata[3]);
                        }
                        else{
                            var  paraminput=$("<input id='paramvalue' name='paramvalue'>");
                            container.find("#paramvalue").remove();
                            container.find("#paraminfodiv").append(paraminput);
                            container.find("input[name='paramvalue']").val(spandata[3]);
                        }
                    }
                });
                container.find("#paramtable").append(row);
            });
            //删除按钮
            container.find("#paramdelete").click(function () {
                container.find("#paramtable input[name='paramcheckbox']").each(function () {
                    if ($(this).attr("checked"))
                        $(this).parent().parent().remove();
                });
            });
            //更新操作
            container.find("#paramdupdate").click(function () {
                //var paramdataset = container.find("select[name='paramdataset']").val();
                //var datafield = container.find("select[name='paramdatafield']").val();
                var datafield = container.find("input[name='paramdatafield']").val();
                var compareoption = container.find("select[name='compareoption']").val();
                var compareoptionlabel = container.find("select[name='compareoption']").find("option:selected").text();
                var paramtype = container.find("select[name='paramtype']").val();
                var paramvalue;
                if(paramtype==="2")
                    paramvalue = container.find("select[name='paramvalue']").val();
                else
                    paramvalue = container.find("input[name='paramvalue']").val();
                var orignvalue = paramvalue;
                var orignvalue = paramvalue;
                if (compareoption == "in" || compareoption == "not in") {
                    if (paramtype == "1") {
                        var datatemp = paramvalue.split(",");
                        paramvalue = "(";
                        for (var i = 0; i < datatemp.length; i++) {
                            paramvalue = paramvalue + "\"" + datatemp[i] + "\",";
                        }
                        paramvalue = paramvalue.substring(0, paramvalue.length - 1) + ")";
                    }
                    else if(paramtype == "4"   ||  paramtype == "5")
                    {
                        var datatemp = paramvalue.split(",");
                        paramvalue = "(";
                        for (var i = 0; i < datatemp.length; i++) {
                            paramvalue = paramvalue + "" + datatemp[i] + ",";
                        }
                        paramvalue = paramvalue.substring(0, paramvalue.length - 1) + ")";
                    }
                    else if(paramtype == "3")
                        paramvalue = "$(" + paramvalue + ")";
                    else
                        paramvalue = "(" + paramvalue + ")";
                } else if (compareoption == "like") {
                    if (paramtype == "3")
                        paramvalue = "$(" + paramvalue + ")";
                    else
                        paramvalue = "%" + paramvalue + "%";
                }
                else if (paramtype == "1")
                    paramvalue = "\"" + paramvalue + "\"";
                else   if(paramtype == "3")
                    paramvalue = "$(" + paramvalue + ")";
                else
                    paramvalue =  paramvalue ;
                
                
                
                var hiddenarea = datafield + "-;-" + compareoption + "-;-" + paramtype + "-;-" + orignvalue + "-;-" + (datafield + " " + compareoption + " " + paramvalue) + "-;-" + (datafield + " " + compareoptionlabel + " " + paramvalue);
                var children = $("#paramtable .clickedColor td").find("input[name='child']");
                $(children[0]).val(hiddenarea);
                
                $("#paramtable .clickedColor").find("td span").html(expressdescElement($(children[0]), true));
            });
            
            //添加括号
            var addbracket = function (relationship) {
                var relationDesc = "&nbsp;AND&nbsp;";
                if (relationship == 0) {
                    relationDesc = "&nbsp;OR&nbsp;";
                }
                
                var checkboxarray = [];
                var conditionstr = "";
                container.find("#paramtable input[name='paramcheckbox']").each(function () {
                    if ($(this).attr("checked"))
                        checkboxarray.push($(this));
                });

                for (var i = 0; i < checkboxarray.length; i++) {
                    if (i == 0) {
                        if (checkboxarray.length > 1) {
                            var expressionElement = checkboxarray[0].parent().children("expressions");
                            
                            var expression = $("<expressions type='expressions' relation='" + relationship + "'></expressions>");
                            if (!!expressionElement[0]) {
                                expression.append(expressionElement.clone());
                            } else {
                                expressionElement = checkboxarray[0].parent().children("input[name='child']");
                                expression.append(expressionElement.clone());
                            }
                            expressionElement.remove();
                            checkboxarray[0].parent().append(expression);
                        }
                    } else {
                        var expressionElement = checkboxarray[i].parent().children("expressions");
                        if (!!expressionElement[0]) {
                            checkboxarray[0].parent().children("expressions").append(expressionElement.clone());
                        } else {
                            expressionElement = checkboxarray[i].parent().find("input[name='child']").clone();
                            checkboxarray[0].parent().children("expressions").append(expressionElement);
                        }
                        checkboxarray[i].parent().parent().remove();
                    }
                }
                checkboxarray[0].parent().children("span").html(expressionsToString(checkboxarray[0].parent().children("expressions")));
            };
            
            //获取expressions元素的desc
            var expressionsToString = function (expressions) {
                var result = "";
                var relationship = expressions.attr("relation");
                //var relationDesc = "<span style='color:red;'>&nbsp;AND&nbsp;</span>";
                var relationDesc = "&nbsp;AND&nbsp;";
                if (relationship == '0') {
                    //relationDesc = "<span style='color:red;'>&nbsp;OR&nbsp;</span>";
                    relationDesc = "&nbsp;OR&nbsp;";
                }
                //继续查找expressions
                var children = expressions.children();
                for (var i = 0; i < children.length; i++) {
                    if (i != 0) {
                        result += relationDesc;
                    }
                    if ($(children[i]).attr("type") == "expressions") {
                        result += "(" + expressionsToString($(children[i])) + ")";
                        continue;
                    } 
                    data = $(children[i]).val().split("-;-");
                    result += expressdescElement($(children[i]));
                }
                return result;
            };
            
            //返回表达式显示文字
	        var expressdescElement = function (inputele, udpateflag) {
	            var desc = inputele.val();
                var datatemp = desc.split("-;-");
                var datasetfield = datatemp[0];
                var filtertype = datatemp[1];
                var datatype = datatemp[2];
                var datavalue = datatemp[3];
                
                
                var expIndex = inputele.attr("expindex");
                
                if (!!!udpateflag) {
                    expIndex = getExpIndex();
                }
                
                inputele.attr("expindex", expIndex);
                var compareoptionlabel = $("select[name='compareoption']").find("option[value='" + filtertype + "']").text();
                return "<span key='" + expIndex + "' ondblclick='switchEditMode(this);'><span class='variableNameClass'>" + datasetfield + "</span>&nbsp;<span class='relationClass'>" + compareoptionlabel + "</span>&nbsp;<span class='expressionValueClass'>" + datavalue + "</span></span>"
            };
            
            //获取表达式当前index
            var getExpIndex = function () {
                var expIndex = parseInt($("#expindex").val());
                $("#expindex").val(expIndex + 1);
                return expIndex;
            };
            
            //添加括号
            $("#addorrelation").click(function () {
                addbracket(0);
            });
            //添加括号
            $("#addandrelation").click(function () {
                addbracket(1);
            });
            
            
            //移除括号
            $("#rembracket").click(function () {
                var checkboxarray = [];
                container.find("#paramtable input[name='paramcheckbox']").each(function () {
                    if ($(this).attr("checked"))
                        checkboxarray.push($(this));
                });
                var children;
                var row;
                var data;
                //分步移除
                for (var i = 0; i < checkboxarray.length; i++) {
                    //查找表达式下的expressions元素，如果没有，则表示没有合并过
                    var expressionsChildren = checkboxarray[i].parent().children("expressions");
                    if (!!!expressionsChildren[0]) {
                        continue;
                    }
                    
                    //继续查找expressions
                    children = expressionsChildren.children();
                    for (var i = 1; i < children.length; i++) {
                        var expressionDesc = "";
                        var cloneElement = $(children[i]).clone();
                        if ($(children[i]).attr("type") == "expressions") {
                            expressionDesc = expressionsToString(cloneElement);
	                    } else {
	                        data = $(children[i]).val().split("-;-");
                            expressionDesc = expressdescElement(cloneElement);
	                    }
                        
                        row = $("<tr class='unclickedColor'><td><input type='checkbox' name='paramcheckbox'></td></tr>")
                        row.children("td").append($("<span>" + expressionDesc + "</span>"));
                        row.children("td").append(cloneElement);
                        $(children[i]).remove();
                        container.find("#paramtable").append(row);
                        row.click(function () {
                            var trs = container.find("#paramtable tr");
                            for (var i = 0; i < trs.length; i++) {
                                if ($(trs[i]).hasClass("clickedColor")) {
                                    $(trs[i]).removeClass("clickedColor");
                                    $(trs[i]).addClass("unclickedColor");
                                }
                            }
                            $(this).removeClass("unclickedColor");
                            $(this).addClass("clickedColor");
                            //判断是否可编辑
                            var spandata = $(this).find("span").html();

                            var children = $(this).find("input[name='child']");

                            if (children.length > 1) {
                                container.find("#paramdupdate").attr("disabled", "disabled");
                            } else if (children.length == 1) {
                                container.find("#paramdupdate").removeAttr("disabled");
                                spandata = $(children[0]).val().split("-;-");
                                container.find("input[name='paramdatafield']").val(spandata[0]);
                                container.find("select[name='compareoption']").val(spandata[1]);
                                container.find("select[name='paramtype']").val(spandata[2]);
                                if(spandata[2]==="2")
                                {
                                    var  paramboolinfo=$("<select id='paramvalue' name='paramvalue' ><option value='true'>true</option><option value='false'>false</option></select>")
                                    container.find("#paramvalue").remove();
                                    container.find("#paraminfodiv").append(paramboolinfo);
                                    container.find("select[name='paramvalue']").val(spandata[3]);
                                }
                                else{
                                    var  paraminput=$("<input id='paramvalue' name='paramvalue'>");
                                    container.find("#paramvalue").remove();
                                    container.find("#paraminfodiv").append(paraminput);
                                    container.find("input[name='paramvalue']").val(spandata[3]);
                                }
                            }
                        });

                    }
                    //整理表达式结构
                    children = expressionsChildren.children();
                    if (children.length == 1) {
                        var expele = expressionsChildren.parent();
                        if ($(children[0]).attr("type") == "expressions") {
	                        expele.append($(children[0]).clone());
	                        expele.children("span").html(expressionsToString($(children[0])));
                        } else {
                            expele.append($(children[0]).clone());
                            expele.children("span").html(expressionsToString(expressionsChildren));
                        }
                        expressionsChildren.remove();
                    }
                }
                //checkboxarray[0].parent().find("span").html($(children[0]).val().split("-;-")[5]);

            });
        },
        //保存参数面板里面的过滤条件
        saveParamSetPanel:function (params) {
            // params=[];
            var param;
            var item;
            var children;
            $("#paramtable tr").each(function () {
                param = [];
                var datatemp;
                children = $(this).find("input[name='child']");
                for (var i = 0; i < children.length; i++) {
                    item = {};
                    datatemp = $(children[i]).val().split("-;-");
                    //item.datasetid = datatemp[0];
                    item.datasetfield = datatemp[0];
                    item.filtertype = datatemp[1];
                    item.datatype = datatemp[2];
                    item.paramvalue = datatemp[3];
                    item.value = datatemp[4];
                    item.label = datatemp[5];
                    param.push(item);
                }
                params.push(param);
            });

        },
        //恢复参数设置面板
        restoreParamSetPanel:function (params,ctrlcontainer) {
            var items;
            var row;
            var td;
            var hiddenarea;
            var hidden;
            var label;
            var span;
            var container=$("#paramsset");
            if((ctrlcontainer) != undefined)
                container = ctrlcontainer;
            for (var i = 0; i < params.length; i++) {
                row = $("<tr class='unclickedColor'></tr>");
                td = $("<td></td>");
                row.append(td);
                items = params[i];
                label = "";
                span = $("<span></span>");
                for (var j = 0; j < items.length; j++) {
                    hiddenarea = items[j].datasetid + "-;-" + items[j].datasetfield + "-;-" + items[j].filtertype + "-;-" + items[j].datatype + "-;-" + items[j].paramvalue + "-;-" + items[j].value + "-;-" + items[j].label;
                    if (j == 0) {
                        td.append($("<input type='checkbox' name='paramcheckbox'>"));
                    }
                    td.append(span);
                    if (j != (items.length - 1))
                        label = label + items[j].label + " or ";
                    else
                        label = label + items[j].label;

                    hidden = $("<input name='child' type='hidden' value='" + hiddenarea + "'>");
                    td.append(hidden);

                }
                span.html(label);
                $("#paramtable").append(row);
                row.click(function () {
                    var trs = $("#paramtable tr");
                    for (var i = 0; i < trs.length; i++) {
                        if ($(trs[i]).hasClass("clickedColor")) {
                            $(trs[i]).removeClass("clickedColor");
                            $(trs[i]).addClass("unclickedColor");
                        }
                    }
                    $(this).removeClass("unclickedColor");
                    $(this).addClass("clickedColor");
                    //判断是否可编辑
                    var spandata = $(this).find("span").html();
                    var children = $(this).find("input[name='child']");
                    if (children.length > 1) {
                        $("#paramdupdate").attr("disabled", "disabled");
                    }
                    else if (children.length == 1) {
                        $("#paramdupdate").removeAttr("disabled");
                        spandata = $(children[0]).val().split("-;-");
                        //container.find("select[name='paramdataset']").val(spandata[0]);
                        //container.find("select[name='paramdatafield']").val(spandata[1]);
                        container.find("input[name='paramdatafield']").val(spandata[0]);
                        container.find("select[name='compareoption']").val(spandata[1]);
                        container.find("select[name='paramtype']").val(spandata[2]);
                        if(spandata[2]==="2")
                        {
                            var  paramboolinfo=$("<select id='paramvalue' name='paramvalue' ><option value='true'>true</option><option value='false'>false</option></select>")
                            $("#paramvalue").remove();
                            $("#paraminfodiv").append(paramboolinfo);
                            container.find("select[name='paramvalue']").val(spandata[3]);
                        }
                        else{
                            var  paraminput=$("<input id='paramvalue' name='paramvalue'>");
                            $("#paramvalue").remove();
                            $("#paraminfodiv").append(paraminput);
                            container.find("input[name='paramvalue']").val(spandata[3]);
                        }
                    }
                });
            }
        }
    }
})();

function switchEditMode(target) {
    container.find("#paramdupdate").removeAttr("disabled");
    spandata = $(children[0]).val().split("-;-");
    container.find("input[name='paramdatafield']").val(spandata[0]);
    container.find("select[name='compareoption']").val(spandata[1]);
    container.find("select[name='paramtype']").val(spandata[2]);
    if(spandata[2]==="2")
    {
        var  paramboolinfo=$("<select id='paramvalue' name='paramvalue' ><option value='true'>true</option><option value='false'>false</option></select>")
        container.find("#paramvalue").remove();
        container.find("#paraminfodiv").append(paramboolinfo);
        container.find("select[name='paramvalue']").val(spandata[3]);
    }
    else{
        var  paraminput=$("<input id='paramvalue' name='paramvalue'>");
        container.find("#paramvalue").remove();
        container.find("#paraminfodiv").append(paraminput);
        container.find("input[name='paramvalue']").val(spandata[3]);
    }
    
    /*
    var trs = container.find("#paramtable tr");
    for (var i = 0; i < trs.length; i++) {
        if ($(trs[i]).hasClass("clickedColor")) {
            $(trs[i]).removeClass("clickedColor");
            $(trs[i]).addClass("unclickedColor");
        }
    }
    */
    //$(this).removeClass("unclickedColor");
    //$(this).addClass("clickedColor");
    //判断是否可编辑
    //var spandata = $(this).find("span").html();

    //var children = $(this).find("input[name='child']");

    //if (children.length > 1) {
    //    container.find("#paramdupdate").attr("disabled", "disabled");
    //} else if (children.length == 1) {
        container.find("#paramdupdate").removeAttr("disabled");
        spandata = $(children[0]).val().split("-;-");
        container.find("input[name='paramdatafield']").val(spandata[0]);
        container.find("select[name='compareoption']").val(spandata[1]);
        container.find("select[name='paramtype']").val(spandata[2]);
        if(spandata[2]==="2")
        {
            var  paramboolinfo=$("<select id='paramvalue' name='paramvalue' ><option value='true'>true</option><option value='false'>false</option></select>")
            container.find("#paramvalue").remove();
            container.find("#paraminfodiv").append(paramboolinfo);
            container.find("select[name='paramvalue']").val(spandata[3]);
        }
        else{
            var  paraminput=$("<input id='paramvalue' name='paramvalue'>");
            container.find("#paramvalue").remove();
            container.find("#paraminfodiv").append(paraminput);
            container.find("input[name='paramvalue']").val(spandata[3]);
        }
    //}
}