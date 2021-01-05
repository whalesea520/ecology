var weaverSplit = "||~WEAVERSPLIT~||";
var initParamSetPanel = function (container) {
    $("#paramtype").change(function(e){
         var data=$(this).val();
         $("#compareoption").find("option").remove();
         
         $("#browsertype").next().hide();
         $("#browserSpan").hide();
         
         $("#paramvalue").show();
         
         //$("#valuetype").val("0");
		 //$("#valuetype").attr("disabled", false);
         if(data==="0") {
             $("#compareoption").append("<option value='4'>等于</option><option value='5'>不等于</option><option value='6'>包含</option><option value='7'>不包含</option>");
         } else if(data==="1" || data == "2") {
             $("#compareoption").append("<option value='0'>大于</option><option value='1'>大于等于</option><option value='2'>小于</option><option value='3'>小于等于</option><option value='4'>等于</option><option value='5'>不等于</option>");
         } else if(data==="3") {
             $("#compareoption").append("<option value='6'>包含</option><option value='7'>不包含</option><option value='8'>属于</option><option value='9'>不属于</option>");
             $("#browsertype").show();
             $("#browserSpan").show();
             $("#browsertype").selectbox("detach");
             $("#browsertype").selectbox();
             $("#paramvalue").hide();
         }
         
         $("#valuetype").find("option").remove();
         if (data == "3") {
         	$("#valuetype").append("<option value=\"1\">选择值</option><option value=\"2\">变量</option><option value=\"3\">系统变量</option>");
         } else {
         	$("#valuetype").append("<option value=\"0\">输入值</option><option value=\"2\">变量</option><option value=\"3\">系统变量</option>");
         }
    });
    $("#valuetype").change(function(e){
    	var data=$(this).val();
    	
		$("#browsertype").hide();
		$("#browserSpan").hide();
		$("#paramvalue").show();
    	if (data == "1" || data == "3") {
    		//$("#browsertype").show();
            $("#browserSpan").show();
            $("#paramvalue").hide();
    	}
    });
    

    //添加按钮
    $("#paramadd").click(function () {
    	//自定义变量
    	var datafieldSource = "VAR" + new Date().getTime(); //$("#variabletype").val();
        var datafield = $("#paramdatafield").val();
        //变量ID
        var datafieldID = "VAR" + new Date().getTime(); 
        
        var compareoption = $("#compareoption").val();
        var compareoptionlabel = $("#compareoption").find("option:selected").text();
        //字段大类型
        var paramtype = $("#paramtype").val();
        //浏览框类型
        var browsertype = $("#browsertype").val();
        
        //字段值
        var paramvalue;
        var valuetype = $("#valuetype").val();
        
        var paramtypestr = paramtype; 
        var orignvalue = paramvalue;
        if(valuetype == "1" || valuetype==="3") {
        	var sltids = $("#selectids").val();
        	var selectidsspan = $("#selectidsspan").html();
        	paramvalue = {ids: sltids, names: selectidsspan};
        	paramtypestr = paramtype + weaverSplit + browsertype + weaverSplit + valuetype;
        	orignvalue = sltids + weaverSplit + selectidsspan;
        } else {
        	paramtypestr = paramtype + weaverSplit + datafieldSource + weaverSplit + valuetype;
        	paramvalue = $("#paramvalue").val();
        	orignvalue = paramvalue;
        }
        var msg = "";
        
        if ($.trim(datafield) == "") {
        	msg = "变量名未填写！";
        	alert(msg);
        	$("#paramdatafield")[0].focus();
        	return;
        }
        
        //变量来源-变量id-变量名-
        var datafieldstr = datafieldSource + weaverSplit + datafieldID + weaverSplit + datafield;
        
	    var hiddenarea = datafieldstr + "-;-" + compareoption + "-;-" + paramtypestr + "-;-" + orignvalue + "-;-" + (datafield + " " + compareoption + " " + orignvalue) + "-;-" + (datafield + " " + compareoptionlabel + " " + orignvalue);
        var hiddenElement = $("<input name='child' type='hidden' value='" + hiddenarea + "'>");
        //var row = $("<tr class='unclickedColor'><td>" + expressdescElement(hiddenElement) + "</td></tr>")
        //row.children("td").append(hiddenElement);
        var item = $("<div class='relationItem'></div>");
        item.append($(expressdescElement(hiddenElement)));
        
        $("#mainExpression").append(hiddenElement);
        
        //item.append(hiddenElement);
        $("#mainBlock").append(item);
        $("#mainBlock").show();
//        $("#paramtable").append(row);
    });
    
    //删除按钮
    $("#paramdelete").click(function () {
    
    	$("[_selected=true]").each(function () {
    		var trgelement = null;
    		var key = $(this).attr("key");
           	if ($(this).is("span")) {
				trgelement = $("input[name=child][expindex=" + key + "]");
           	} else {
           		trgelement = $("expressions[rotindex=" + key + "]");
           	}
           	
           	//如果只有两个，则删除关系
    		if ($(this).parent().parent().children(".relationItem").length == 2) {
    		}
    		$(this).parent().remove();
    		
    		trgelement.remove();
    		
        });
        $("#paramtable input[name='paramcheckbox']").each(function () {
            if ($(this).attr("checked"))
                $(this).parent().parent().remove();
        });
    });
    
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
        
        $("[_selected=true]").each(function () {
        	if ($(this).is("div")) {
            	checkboxarray.push($(this));
            }
        });
        
        if (checkboxarray.length == 0) return ;
        
        /*
        $("#paramtable input[name='paramcheckbox']").each(function () {
            if ($(this).attr("checked"))
                checkboxarray.push($(this));
        });
        */
        
        
        var children;
        var row;
        var data;
        //分步移除
        for (var i = 0; i < checkboxarray.length; i++) {
            var key = checkboxarray[i].attr("key");
           	var trgelement = $("expressions[rotindex=" + key + "]"); 
           	
            children = checkboxarray[i].children(".relationItem");
            
            for (var j = 1; j < children.length; j++) {
            	var tktrgeldspelement = $(children[j]).children();
            	var tktrgelement = null;
	            var tky = tktrgeldspelement.attr("key");
	            
	           	if (tktrgeldspelement.is("span")) {
					tktrgelement = $("input[name=child][expindex=" + tky + "]");
	           	} else {
	           		tktrgelement = $("expressions[rotindex=" + tky + "]");
	           	}
	           	
            	var displayCloneElement = tktrgeldspelement.clone();
            	var cloneElement = tktrgelement.clone();
            	//如果是第一层
            	//if ($(checkboxarray[i]).parent().is("td")) {
            	//	row = $("<tr class='unclickedColor'><td></td></tr>");
            	//	row.children("td").append(displayCloneElement);
            	//	row.children("td").append(cloneElement);
            	//	$("#paramtable").append(row);
            	//} else {
            		var expressionItemDivObj = $("<div class='relationItem'></div>");	
           			expressionItemDivObj.append(displayCloneElement);
           			$(checkboxarray[i]).parent().parent().append(expressionItemDivObj);
            		
            		tktrgelement.parent().append(cloneElement);
            	//}
            	
                tktrgelement.remove();
                $(children[j]).remove();
            }
            
            //var displayBlockChildrenItem = $(displayBlockChildrens[0]).children().clone();
            //判断是否是div ，span 
          	//relationBlockElement.remove();
          	//alert(checkboxarray[i].parent().html());
          	//checkboxarray[i].parent().append(displayBlockChildrenItem);
            ///alert(checkboxarray[i].parent().html());
            
            //整理表达式结构
            children = checkboxarray[i].children(".relationItem");
            if (children.length == 1) {
                var expele = null;
               	expele = checkboxarray[i].parent();
              	expele.append(children.children().clone());
                checkboxarray[i].remove();
                
                trgelement.parent().append(trgelement.children().clone());
                trgelement.remove();
            }
            
        }
        //checkboxarray[0].parent().find("span").html($(children[0]).val().split("-;-")[5]);

    });
    //添加括号
    var addbracket = function (relationship) {
        var relationDesc = "&nbsp;AND&nbsp;";
        if (relationship == 0) {
            relationDesc = "&nbsp;OR&nbsp;";
        }
        
        var checkboxarray = [];
        $("[_selected=true]").each(function () {
            checkboxarray.push($(this));
        });
        
        var conditionstr = "";
        /*
        $("#paramtable input[name='paramcheckbox']").each(function () {
            if ($(this).attr("checked"))
                checkboxarray.push($(this));
        });
		*/
		
		if (checkboxarray.length <= 1) {
			return;
		}
		var displayBlock = null;
        var expression = null;
        for (var i = 0; i < checkboxarray.length; i++) {
        	//清除选中
        	checkboxarray[i].attr("_selected", "false");
			checkboxarray[i].removeClass("spanselected");
			
        	var trgelement = null;
            var key = checkboxarray[i].attr("key");
           	if (checkboxarray[i].is("span")) {
				trgelement = $("input[name=child][expindex=" + key + "]");
           	} else {
           		trgelement = $("expressions[rotindex=" + key + "]");
           	}
            if (i == 0) {
            	var rlindex = getRlIndex();
				//合并后，显示的关系图
				displayBlock = $("#displayTemplate").children(".relationblock").clone();
				displayBlock.attr("key", rlindex);
				displayBlock.children(".verticalblock").html(relationDesc);;
				
				var expressionItemDivObj = $("<div class='relationItem'></div>");
				expressionItemDivObj.append(checkboxarray[i].clone());
				displayBlock.append(expressionItemDivObj);
				
				//合并后，实际的关系结构
				expression = $("<expressions type='expressions' relation='" + relationship + "' rotindex='" + rlindex + "'></expressions>");
				expression.append(trgelement.clone());
				
				checkboxarray[i].parent().append(displayBlock);
				//添加关系图
				trgelement.parent().append(expression);
				trgelement.remove();
				checkboxarray[i].remove();
            } else {
                var expressionItemDivObj = $("<div class='relationItem'></div>");
                expressionItemDivObj.append(checkboxarray[i].clone());
				displayBlock.append(expressionItemDivObj);
				
				expression.append(trgelement.clone());
				//if (checkboxarray[i].parent().is("td")) {
				//	checkboxarray[i].parent().parent().remove();
				//} else {
					checkboxarray[i].parent().remove();
					//trgelement.parent().remove();
				//}
				//alert(trgelement.html());
				checkboxarray[i].remove();
				trgelement.remove();
				
				
            }
        }
    };
    
    //返回表达式显示文字
    var expressdescElement = function (inputele, udpateflag) {
        var desc = inputele.val();
        var datatemp = desc.split("-;-");
        var datasetfield = datatemp[0].split(weaverSplit)[2];
        var filtertype = datatemp[1];
        var datatype = datatemp[2];
        var datavalue = datatemp[3];
        if (!!datavalue && datavalue.indexOf(weaverSplit) != -1) {
        	datavalue = datavalue.split(weaverSplit)[1]
        }
        
        var expIndex = inputele.attr("expindex");
        
        if (!!!udpateflag) {
            expIndex = getExpIndex();
        }
        
        inputele.attr("expindex", expIndex);
        var compareoptionlabel = $("#compareoption").find("option[value='" + filtertype + "']").text();
        return "<span class='displayspan' key='" + expIndex + "' onclick='switchSelected(event, this)' ondblclick='switchEditMode(this);'>" + datasetfield + "&nbsp;" + compareoptionlabel + "&nbsp;" + datavalue + "</span>"
    };
    
    //获取表达式当前index
    var getExpIndex = function () {
        var expIndex = parseInt($("#expindex").val());
        $("#expindex").val(expIndex + 1);
        return expIndex;
    };
    
    //获取表达式当前index
    var getRlIndex = function () {
        var rlindex = parseInt($("#rlindex").val());
        $("#rlindex").val(rlindex + 1);
        return rlindex;
    };
    
    //保存
    $("#savebtn").click(function () {
    	var allexprblock = $("#expressionBlock").children("expressions");
    	
    	if (allexprblock.children().length == 0) {
    		alert("没有任何表达式, 不需要保存");
    		return;
    	}
    	var result = "";//"<expressions relation=\"1\">";
    	
    	//if (allexprblock.length > 1 ) {
    	//	result = "<expressions relation=\"1\">";
    	//}
    	
    	allexprblock.each(function (i, ele) {
			var expsChildrens = $("#mainExpression");
			if (!!expsChildrens[0]) {
				result += getExpItemsXmlString(expsChildrens);
			}
    	});
    	
    	//alert(result);
    	
    	result = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" + result;
    	$.ajax({
			type: "post",
		    url: "/formmode/js/ruleDesign/ruleOperation.jsp?_" + new Date().getTime() + "=1&",
		    data: {rulexml: result, ruleid: $("#ruleid").val()},
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success:function (data, textStatus) {
		    	alert("保存成功！");
		    	window.location.reload();
		    } 
	    });
    });
    
    //清空
    $("#btncancel").click(function () {
    	$("#mainBlock").html("");
    	$("#mainExpression").html("");
    });
    
    //获取expressions元素的json
    var getExpItemsXmlString = function (expressions) {
        //表达式关系
        var relationship = parseInt(expressions.attr("relation"));
        //alert(relationship);
        var result = "<expressions relation=\"" + relationship + "\">";
        
        //继续查找expressions
        var children = expressions.children();
        for (var i = 0; i < children.length; i++) {
            if ($(children[i]).attr("type") == "expressions") {
            	result += getExpItemsXmlString($(children[i]))
                continue;
            } 
            //input 表达式单项xml
            result += getExpItemXmlString($(children[i]));
        }
        
        result += "</expressions>";
        return result;
    };
    
    //单项表达式的json字符串
    var getExpItemXmlString = function (expItem) {
	    var children = expItem;
	    if (!!!children[0]) return "";
	    var datatemp = children.val().split("-;-");
	    var datasetfieldinfo = datatemp[0].split(weaverSplit);
	    var filtertype = datatemp[1];
	    var datatype = datatemp[2];
	    var datavalue = datatemp[3];
	    
	    //变量来源、变量id、变量名
	    var datafieldSource = datasetfieldinfo[0];
	    var datafieldID = datasetfieldinfo[1];
	    var datafield = datasetfieldinfo[2];
	    
	    var browserType = "";
	    var valuevarid = "";
		var valueVariableID = "";
		if (!!datatype && datatype.indexOf(weaverSplit) != -1) {
			var datatypearray = datatype.split(weaverSplit);
	        datatype = datatypearray[0];
	        browserType = datatypearray[1];
	        valuetype= datatypearray[2];
	        
	        if (valuetype == "2") {
	        	valueVariableID = browserType;
	        }
	    }
	    
	    var datavaluejson = null;
	    
	    if (!!datavalue && datavalue.indexOf(weaverSplit) != -1) {
	        datavaluejson = {ids: datavalue.split(weaverSplit)[0], names:datavalue.split(weaverSplit)[1]};
	    }
	    
		var result = "<expression id=\"" + datafieldSource + "\" variableID=\"" + datafieldID + "\" variableName=\"" + datafield + "\" ";
        result += "type=\"" + datatype + "\" ";
        result += "browsertype=\"" + browserType + "\" ";
        
        result += "relation=\"" + filtertype + "\" ";
        result += "valueType=\"" + valuetype + "\" ";
        result += "valueVariableID=\"" + valueVariableID + "\" ";
        
        if (!!datavaluejson) {
        	result += "value=\"" + datavaluejson.ids + "\" ";
        	result += "valueName=\"" + datavaluejson.names + "\" ";
        } else {
        	result += "value=\"" + datavalue + "\" ";
        }
        
        result += ">";
        result += "</expression>";
        
        return result;
    };
}


 //获取expressions元素的desc
    function expressionsToString(expressions) {
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
            //data = $(children[i]).val().split("-;-");
            var key = $(children[i]).attr("expindex");
            result += "(" + $("span[key=" + key + "]").html().replace("&nbsp;", " ") + ")";
        }
        return result;
    };
    

function switchEditMode(target) {
	if (!!!target) return;
	
	var $this = $(target);
    var key = $this.attr("key");
    var children = $("input[name=child][expindex=" + key + "]");
    if (!!!children[0]) return;
    var editBlock = $("<div id='editblock_" + key + "' class='editBlockClass'></div>");
	editBlock.append($("#editBlockTemplate").children().clone());
    var datatemp = children.val().split("-;-");
    var datasetfieldinfo = datatemp[0].split(weaverSplit);
    var filtertype = datatemp[1];
    var datatype = datatemp[2];
    var datavalue = datatemp[3];
    
//    alert(filtertype);
    //变量来源、变量id、变量名
    var datafieldSource = datasetfieldinfo[0];
    var datafieldID = datasetfieldinfo[1];
    var datafield = datasetfieldinfo[2];
    
    var datavaluejson = null;
    
    if (!!datavalue && datavalue.indexOf(weaverSplit) != -1) {
        datavaluejson = {ids: datavalue.split(weaverSplit)[0], names:datavalue.split(weaverSplit)[1]};
    }
    
    editBlock.find("select[name='compareoption']").find("option").remove();
    editBlock.find("select[name='browsertype']").hide();
    editBlock.find("span[name=ebrowserSpan]").hide();
	editBlock.find("input[name=paramvalue]").show();
	
	var browserType = "";
	var valuetype = "";
	if (!!datatype && datatype.indexOf(weaverSplit) != -1) {
		var datatypearray = datatype.split(weaverSplit);
        datatype = datatypearray[0];
        browserType = datatypearray[1];
        valuetype= datatypearray[2];
    }
    if(datatype==="0") {
        editBlock.find("select[name='compareoption']").append("<option value='4'>等于</option><option value='5'>不等于</option><option value='6'>包含</option><option value='7'>不包含</option>");
    } else if(datatype==="1" || datatype == "2") {
        editBlock.find("select[name='compareoption']").append("<option value='0'>大于</option><option value='1'>大于等于</option><option value='2'>小于</option><option value='3'>小于等于</option><option value='4'>等于</option><option value='5'>不等于</option>");
    } else if(datatype==="3") {
        editBlock.find("select[name='compareoption']").append("<option value='6'>包含</option><option value='7'>不包含</option><option value='8'>属于</option><option value='9'>不属于</option>");
        editBlock.find("select[name='browsertype']").val(browserType);
        editBlock.find("select[name='browsertype']").show();
    	editBlock.find("span[name=ebrowserSpan]").show();
		editBlock.find("input[name=paramvalue]").hide();
    }
    
    editBlock.find("select[name=valuetype]").find("option").remove();
    if (datatype == "3") {
    	editBlock.find("select[name=valuetype]").append("<option value=\"1\">选择值</option><option value=\"2\">变量</option><option value=\"3\">系统变量</option>");
    } else {
    	editBlock.find("select[name=valuetype]").append("<option value=\"0\">输入值</option><option value=\"2\">变量</option><option value=\"3\">系统变量</option>");
    }

    //变量来源
    //editBlock.find("select[name='variabletype']").val(datafieldSource);
    editBlock.append("<input type='hidden' name='datafieldsource' value='" + datafieldSource + "'>");
    editBlock.append("<input type='hidden' name='varid' value='" + datafieldID + "'>");
    //变量名
    editBlock.find("input[name='paramdatafield']").val(datafield);
    editBlock.find("select[name='compareoption']").val(filtertype);
    editBlock.find("select[name='paramtype']").val(datatype);
    editBlock.find("select[name='valuetype']").val(valuetype);
    
   	if (valuetype == "1" || valuetype == "3") {
   		//editBlock.find("select[name='browsertype']").show();
	  	editBlock.find("span[name=ebrowserSpan]").show();
		editBlock.find("input[name=paramvalue]").hide();
   	}
    
    if(!!datavaluejson) {
    	editBlock.find("span[name=eselectidsspan]").html(datavaluejson.names);
		editBlock.find("input[name=eselectids]").val(datavaluejson.ids);
    } else {
    	editBlock.find("input[name=paramvalue]").val(datavalue);
    }
    //绑定事件
    editBlock.find("select[name='paramtype']").change(function () {
    	var $this = $(this);
    	var datatype = $this.val();
	    editBlock.find("select[name='compareoption']").find("option").remove();
	    editBlock.find("select[name='browsertype']").hide();
	    editBlock.find("span[name=ebrowserSpan]").hide();
	    editBlock.find("input[name=paramvalue]").show();
		if(datatype==="0") {
		    editBlock.find("select[name='compareoption']").append("<option value='4'>等于</option><option value='5'>不等于</option><option value='6'>包含</option><option value='7'>不包含</option>");
		} else if(datatype==="1" || datatype == "2") {
		    editBlock.find("select[name='compareoption']").append("<option value='0'>大于</option><option value='1'>大于等于</option><option value='2'>小于</option><option value='3'>小于等于</option><option value='4'>等于</option><option value='5'>不等于</option>");
		} else if(datatype==="3") {
			editBlock.find("select[name='compareoption']").append("<option value='6'>包含</option><option value='7'>不包含</option><option value='8'>属于</option><option value='9'>不属于</option>");
			editBlock.find("select[name='browsertype']").show();
		  	editBlock.find("span[name=ebrowserSpan]").show();
			editBlock.find("input[name=paramvalue]").hide();
		}
		
		editBlock.find("select[name=valuetype]").find("option").remove();
	    if (datatype == "3") {
	    	editBlock.find("select[name=valuetype]").append("<option value=\"1\">选择值</option><option value=\"2\">变量</option><option value=\"3\">系统变量</option>");
	    } else {
	    	editBlock.find("select[name=valuetype]").append("<option value=\"0\">输入值</option><option value=\"2\">变量</option><option value=\"3\">系统变量</option>");
	    }
    });
    
    editBlock.find("select[name='valuetype']").change(function(e){
    	var data=$(this).val();
    	
		//editBlock.find("select[name='browsertype']").hide();
	    editBlock.find("span[name=ebrowserSpan]").hide();
	    editBlock.find("input[name=paramvalue]").show();
    	if (data == "1" || data == "3") {
    		//editBlock.find("select[name='browsertype']").show();
		  	editBlock.find("span[name=ebrowserSpan]").show();
			editBlock.find("input[name=paramvalue]").hide();
    	}
    });
    
    //隐藏span
    $this.hide();
    $this.parent().append(editBlock);
}

function switchRelationEditMode(target) {
	var parent = $(target).parent();
	var key = parent.attr("key"); 
	//expression = $("<expressions type='expressions' relation='" + relationship + "' rotindex='" + rlindex + "'></expressions>");
	var expselement = $("expressions[rotindex=" + key + "]");
	if (!!!expselement[0]) return;
	
	$(target).css("left", "-20px");
	var relation = parseInt(expselement.attr("relation"));
	$(target).html("<select id='tempRelationEle' onblur='cancelRelationEdit(this);' onchange='confirmRelationEdit(this, " + key + ")'><option value='0' " + (relation==0?" selected ":"") + ">OR</option><option value='1'" + (relation==1?" selected ":"") + ">AND</option></select>");
	$("#tempRelationEle")[0].focus();
}

function confirmRelationEdit(target, key) {
	var expselement = $("expressions[rotindex=" + key + "]");
	if (!!!expselement[0]) return;
	expselement.attr("relation", $(target).val());
}

function cancelRelationEdit(target) {
	var sltval = $(target).val();
	$(target).parent().css("left", "0px");
	if (sltval == "0") {
		$(target).parent().html("&nbsp;OR&nbsp;");
	} else {
		$(target).parent().html("&nbsp;AND&nbsp;");
	}	
}

function confirmEdit(target) {
	var editBlock = $(target).parent();
	if (!!!editBlock) return ;
	var displaySpan = editBlock.parent().children("span");
    var key = displaySpan.attr("key");
    var children = $("input[name=child][expindex=" + key + "]");
    if (!!!children[0]) return;
    
	//自定义变量
	var datafieldSource = editBlock.find("input[name='datafieldsource']").val();//"VAR" + new Date().getTime();//children.split("-;-")[0].split(weaverSplit)[0];//editBlock.find("select[name='variabletype']").val();;
    var datafield = editBlock.find("input[name='paramdatafield']").val();
    //变量ID
    var datafieldID = editBlock.find("input[name='varid']").val();//"VAR" + new Date().getTime(); 
        
    var compareoption = editBlock.find("select[name='compareoption']").val();
    var compareoptionlabel = editBlock.find("select[name='compareoption']").find("option:selected").text();
    //字段大类型
    var paramtype = editBlock.find("select[name='paramtype']").val();
    //浏览框类型
    var browsertype = editBlock.find("select[name='browsertype']").val();
    //字段值
    var paramvalue;
    var valuetype = editBlock.find("select[name='valuetype']").val();
    
    var paramtypestr = paramtype; 
    var orignvalue = paramvalue;
    if(valuetype==="3" || valuetype == "1") {
    	var sltids = editBlock.find("input[name=eselectids]").val();
    	var selectidsspan = editBlock.find("span[name=eselectidsspan]").html();
    	paramvalue = {ids: sltids, names: selectidsspan};
    	paramtypestr = paramtype + weaverSplit + browsertype + weaverSplit + valuetype;
    	orignvalue = sltids + weaverSplit + selectidsspan;
    } else {
    	paramtypestr = paramtype + weaverSplit + "0" + weaverSplit + valuetype;
    	paramvalue = editBlock.find("input[name=paramvalue]").val();
    	orignvalue = paramvalue;
    }
    //变量来源-变量id-变量名-
    var datafieldstr = datafieldSource + weaverSplit + datafieldID + weaverSplit + datafield;
    
 	var hiddenarea = datafieldstr + "-;-" + compareoption + "-;-" + paramtypestr + "-;-" + orignvalue + "-;-" + (datafield + " " + compareoption + " " + orignvalue) + "-;-" + (datafield + " " + compareoptionlabel + " " + orignvalue);
 	//alert(hiddenarea);
 	var displayvalue = orignvalue;
 	if (orignvalue.indexOf(weaverSplit) != -1) {
    	displayvalue = orignvalue.split(weaverSplit)[1]
    }
 	
 	displaySpan.html(datafield + " " + compareoptionlabel + " " + displayvalue);
 	children.val(hiddenarea);
 	
 	editBlock.remove();
 	displaySpan.show();
}

function cancelEdit(target) {
	var editBlock = $(target).parent();
	if (!!!editBlock) return ;
	var displaySpan = editBlock.parent().children("span");
	editBlock.remove();
 	displaySpan.show();
}

function clearSltValue(elid, spanelid) {
	$("input[name=" + elid + "]").val("");
	$("span[name=" + spanelid + "]").html("");
}

function switchSelected(e, target) {
	var e = e || window.event;
	var selected = $(target).attr("_selected");
	
	var targetisdiv = $(target).is("div");
	
	var selectedElements = $("[_selected=true]");
	if (selectedElements.length > 0) {
		for (var k=0; k<selectedElements.length; k++) {
			var sltElement = selectedElements[k];
			//if ($(target).parent().is("td")) {
			//	if (!$(sltElement).parent().is("td")) {
			//		selectedElements.attr("_selected", "false");
			//		selectedElements.removeClass("spanselected");
			//		break ;
			//	}
			//} else {
				if ($(target).parent().parent()[0] != $(sltElement).parent().parent()[0]) {
					selectedElements.attr("_selected", "false");
					selectedElements.removeClass("spanselected");
					break ;
				}
			//}
		}
	}
	
	if (selected != "true") {
		$(target).attr("_selected", "true");
		$(target).addClass("spanselected");
	} else {
		$(target).attr("_selected", "false");
		$(target).removeClass("spanselected");
	}
	stopBubble(e);
}

//阻止事件冒泡函数
function stopBubble(e) {
    if (e && e.stopPropagation)
        e.stopPropagation()
    else
        window.event.cancelBubble=true
}