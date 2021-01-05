var weaverSplit = "||~WEAVERSPLIT~||";
var lang = readCookie("languageidweaver");
var initParamSetPanel = function (container) {
    $("#valuetype").change(function(e){
    	if($("#paramdatafield").val() != "-1")
    	{
	    	var data=$(this).val();
	    	if(data === "5")
	    	{
				$("#browserSpan").hide();
				$("#paramselect").hide();
				$("#paramvalue").attr("disabled",true).show();
	    	} else if (data === "0") {
	    		$("#browserSpan").hide();
	    		$("#paramvalue").show();
	    	}
	    	else
	    	{
	    		$("#paramvalue").removeAttr("disabled");
	    		if (data == "2" || data == "3" || data == "6") {
		            $("#browserSpan").show();
		            $("#paramvalue").hide();
		            $("#paramselect").hide();
		            clearSltValue($('#selectids'), $('selectidsspan'));
		    	}else if(data === "4")
		    	{
		    		$("#paramvalue").hide();
		    		$("#paramselect").show();
		    		$("#browserSpan").hide();
		    	}
	    	}
    	}
    	
    });
    

    //添加按钮
    $("#paramadd").click(function () {
    	//自定义变量
    	var datafieldSource = "VAR" + new Date().getTime(); //$("#variabletype").val();
        var datafield = $("#paramdatafield").val();
        var dfname = $("#pname").val();
        var dflabel = $("#paramdatafieldspan").find("a").text();
        var dftype = $("#ptype").val();
        var dfbrowid = $("#pbrowid").val();
        //变量ID
        var datafieldID = "VAR" + new Date().getTime(); 
        
        var compareoption = $("#compareoption").val();
        var compareoptionlabel = $("#compareoption").find("option:selected").text();
        var paramtype = "1";
        //浏览框类型
        var browsertype = $("#browsertype").val();
        
        //字段值
        var paramvalue;
        var valuetype = $("#valuetype").val();
        var paramtypestr = ""; 
        var orignvalue = paramvalue;
        //是否系统定义参数:0/流程表单字段:1
        var paramsysid = $("#psysid").val();
        var paramformid = $("#pformid").val();
        var paramisbill = $("#pisbill").val();
        if(valuetype === "1" || valuetype === "2" || valuetype==="3" || valuetype==="6") {
        	
        	var sltids = $("#selectids").val();
        	
        	var selectidsspan = $("#selectidsspan").find("a").text();
        	if(valuetype==="3")
        		selectidsspan = $("#selectidsspan").find("a").text();
        	paramvalue = {ids: sltids, names: selectidsspan};
        	if(valuetype==='6'){
        		paramtypestr = paramtype + weaverSplit + browsertype + weaverSplit + valuetype + weaverSplit + $("#wfformidfilter").val();
        	}else{
        		paramtypestr = paramtype + weaverSplit + browsertype + weaverSplit + valuetype;
        	}
        	orignvalue = sltids + weaverSplit + selectidsspan;
        	
        }else if(valuetype === "4"){
        	var soval = $("#paramselect").val();
        	var solbl = $("#paramselect").find('option:selected').text();
        	//alert(solbl);
        	paramvalue = {ids: soval, names: solbl};
        	paramtypestr = paramtype + weaverSplit + browsertype + weaverSplit + valuetype;
        	orignvalue = soval + weaverSplit + solbl;
        }else if(valuetype === "0"){
        	paramtypestr = datafieldSource + weaverSplit + "-1" + weaverSplit + valuetype;
        	paramvalue = $("#paramvalue").val();
        	orignvalue = paramvalue;
        }else
        {	//值取至页面值
        	paramtypestr = datafieldSource + weaverSplit + "-1" + weaverSplit + valuetype;
        	orignvalue = SystemEnv.getHtmlNoteName(3630,lang);
        }
        
        var msg = "";
        
        if ($.trim(datafield) == "" || $.trim(datafield) == "-1") {
        	msg = SystemEnv.getHtmlNoteName(3631,lang);
        	alert(msg);
        	return;
        }
        
        //变量来源-变量id-变量名-
        var datafieldstr = datafieldSource + weaverSplit + datafieldID + weaverSplit + datafield + weaverSplit + dfname + weaverSplit + dflabel + weaverSplit + dftype + weaverSplit + dfbrowid;
        var wffieldstr = "";
        if(paramsysid === "1")
        	wffieldstr = paramsysid + weaverSplit + paramformid + weaverSplit + paramisbill;
        else 
        	wffieldstr = paramsysid;
	    var hiddenarea = datafieldstr + "-;-" + compareoption + "-;-" + paramtypestr + "-;-" + orignvalue + "-;-" + wffieldstr;
       	
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

        //递归后续遍历(删除没有子条件的item)
        function  removeAllNoNeed($el){
            var relationItems=$el.find(".relationItem");
			var current;
			for(var i=0,len=relationItems.length;i<len;i++){
			     current=$(relationItems[i]);
			     if(current.find(".relationblock").length>0 ){
				      removeAllNoNeed(current);
				 } 	 
			}
			if($el.find(".relationblock").length>0 && $el.find(".relationItem").length===0){
		            $el.remove(); 
		    }
            
		}

        $("#mainBlock .relationItem").each(function(){
		     var current=$(this);
			 removeAllNoNeed(current);
		});
        
		if($("#mainBlock .relationItem").length===0){
		     $("#mainBlock").hide();
		}

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
        var datasetfieldlabel = datatemp[0].split(weaverSplit)[4];
        var datasetfiledname = datatemp[0].split(weaverSplit)[3];
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
        return "<span class='displayspan' key='" + expIndex + "' onclick='switchSelected(event, this)' ondblclick='switchEditMode(this);'>" + datasetfieldlabel + "&nbsp;" + compareoptionlabel + "&nbsp;" + datavalue + "<input type=hidden name=fname valuel="+ datasetfiledname +"></span>";
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
  
    
    //清空
    $("#btncancel").click(function () {
    	$("#mainBlock").html("");
    	$("#mainExpression").html("");
    });
    
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
	return;

	if (!!!target) return;
	
	var ispagedealel=$("#ispagedeal");
	if(ispagedealel.length===1){
	    ispagedeal=ispagedealel.val();
	}
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
    var wfstr = datatemp[4];
    
//    alert(filtertype);
    //变量来源、变量id、变量名
    var datafieldSource = datasetfieldinfo[0];
    var datafieldID = datasetfieldinfo[1];
    var datafield = datasetfieldinfo[2];
    var dfname = datasetfieldinfo[3];
    var dflabel = datasetfieldinfo[4];
    var dftype = datasetfieldinfo[5];
    var dfbrowsid = datasetfieldinfo[6];
    
    
    var datavaluejson = null;
    if (!!datavalue && datavalue.indexOf(weaverSplit) != -1) {
        datavaluejson = {ids: datavalue.split(weaverSplit)[0], names:datavalue.split(weaverSplit)[1]};
    }
    
    
   	var _psysid = editBlock.find("input[name =epsysid").val(wfstr.split(weaverSplit)[0]);
	if(_psysid.val() === "1")
	{
		editBlock.find("input[name =epformid").val(wfstr.split(weaverSplit)[1]);
		editBlock.find("input[name =episbill").val(wfstr.split(weaverSplit)[2]);
	}
	
	var browserType = "";
	var valuetype = "";
	if (!!datatype && datatype.indexOf(weaverSplit) != -1) {
		var datatypearray = datatype.split(weaverSplit);
        datatype = datatypearray[0];
        browserType = datatypearray[1];
        valuetype= datatypearray[2];
    }
    editBlock.find("input[name=eptype]").val(dftype);
    editBlock.find("input[name=epname]").val(dfname);
    editBlock.find("input[name=epbrowid]").val(dfbrowsid);
    
   	editBlock.find("input[name=eparamdatafield]").val(datafield);
   	editBlock.find("span[name = eparamdatafieldspan]").find("a").html(dflabel);
    
   	setEditPublicBrow(editBlock,dfbrowsid,dftype,"undefined",_psysid.val());
   	

    //变量来源
    //editBlock.find("select[name='variabletype']").val(datafieldSource);
    editBlock.append("<input type='hidden' name='datafieldsource' value='" + datafieldSource + "'>");
    editBlock.append("<input type='hidden' name='varid' value='" + datafieldID + "'>");
    //变量名
    editBlock.find("input[name='eparamdatafield']").val(datafield);
    editBlock.find("select[name='ecompareoption']").val(filtertype);
    editBlock.find("select[name='eparamtype']").val(datatype);
    editBlock.find("select[name='evaluetype']").val(valuetype);
    //alert(!!datavaluejson)
	if(_psysid.val()==='1' && ispagedeal==='1'){
		  //回复设置
	      editBlock.find("span[name=eselectidsspan]").find("a").text(datavaluejson.names);
		  editBlock.find("input[name=eselectids]").val(datavaluejson.ids);
	}else if(dftype === "1" || dftype === "2") {
    	//选择框
    	//输入框
    	editBlock.find("input[name=eparamvalue]").val(datavalue);
    	
    } else if(dftype === "3") {
    	editBlock.find("span[name=eselectidsspan]").find("a").text(datavaluejson.names);
		editBlock.find("input[name=eselectids]").val(datavaluejson.ids);
    }else if(dftype === "5")
    {
    
    }
   	if (valuetype == "1" || valuetype == "2" || valuetype == "3" || valuetype==="6") {
   		//editBlock.find("select[name='browsertype']").show();
	  	editBlock.find("span[name=ebrowserSpan]").show();
		editBlock.find("input[name=eparamvalue]").hide();
   	}
   	if(valuetype === "5")
   	{
   		editBlock.find("span[name=ebrowserSpan]").hide();
		editBlock.find("select[name=eparamselect").hide();
		editBlock.find("input[name=eparamvalue").attr("disabled",true).show();
   		editBlock.find("input[name=eparamvalue]").val("");
	}
    editBlock.find("select[name='evaluetype']").change(function(e){
    	if(editBlock.find("input[name=eparamdatafield").val() != "-1")
    	{
	    	var data=$(this).val();
	    	if(data === "5")
	    	{
				editBlock.find("span[name=ebrowserSpan]").hide();
				editBlock.find("select[name=eparamselect").hide();
				editBlock.find("input[name=eparamvalue").attr("disabled",true).show();
	    	}
	    	else
	    	{
	    		editBlock.find("input[name=eparamvalue").removeAttr("disabled");
	    		if (data == "2" || data == "3") {
		            editBlock.find("span[name=ebrowserSpan").show();
		            editBlock.find("input[name=eparamvalue").hide();
		            clearSltValue(editBlock.find("input[name=eselectids]"), editBlock.find("span[name=eselectidsspan]"));
		    	}else if(data === "4")
		    	{
		    		editBlock.find("input[name=eparamvalue").hide();
		    		editBlock.find("select[name=eparamselect").show();
		    	}
	    	}
    	}
    });
    
    //隐藏span
    $this.hide();
    $this.parent().append(editBlock);
}

function setEditPublicBrow(editBlock,browserid,dftype,psolo,sysid)
{

	var ispagedeal="";
	var ispagedealel=$("#ispagedeal");
	if(ispagedealel.length===1){
	    ispagedeal=ispagedealel.val();
	}
	editBlock.find("select[name = ecompareoption]").find("option").remove();
	editBlock.find("select[name = evaluetype]").find("option").remove();
   
    if(sysid==='1' && ispagedeal==='1'){
		
		editBlock.find("select[name = ecompareoption]").append("<option value='4'>"+SystemEnv.getHtmlNoteName(3632,lang)+"</option><option value='5'>"+SystemEnv.getHtmlNoteName(3633,lang)+"</option><option value='6'>"+SystemEnv.getHtmlNoteName(3634,lang)+"</option><option value='7'>"+SystemEnv.getHtmlNoteName(3635,lang)+"</option>");
		editBlock.find("select[name = evaluetype]").append("<option value=\"6\">"+SystemEnv.getHtmlNoteName(3636,lang)+"</option>");
		editBlock.find("select[name = evaluetype]").selectbox();
		//字符串
		editBlock.find("input[name=eparamvalue]").hide();
		editBlock.find("span[name=ebrowserSpan]").show();
		editBlock.find("select[name=eparamselect]").hide();
	 
	 }else if(dftype === "1" || dftype === "2")
	{
		//输入（字符串、整数、浮点数等）
		editBlock.find("select[name = ecompareoption]").append("<option value='4'>"+SystemEnv.getHtmlNoteName(3632,lang)+"</option><option value='5'>"+SystemEnv.getHtmlNoteName(3633,lang)+"</option><option value='6'>"+SystemEnv.getHtmlNoteName(3634,lang)+"</option><option value='7'>"+SystemEnv.getHtmlNoteName(3635,lang)+"</option>");
		editBlock.find("select[name = evaluetype]").append("<option value=\"0\">"+SystemEnv.getHtmlNoteName(3637,lang)+"</option>");
		editBlock.find("input[name=eparamvalue]").show();
		editBlock.find("input[name=eparamvalue]").val("");
		editBlock.find("span[name=ebrowserSpan]").hide();
		editBlock.find("select[name=eparamselect]").hide();
	}else if(dftype === "3")
	{
		///浏览框
		editBlock.find("select[name = ecompareoption]").append("<option value='8'>"+SystemEnv.getHtmlNoteName(3638,lang)+"</option><option value='9'>"+SystemEnv.getHtmlNoteName(3639,lang)+"</option>");
		editBlock.find("select[name = evaluetype]").append("<option value=\"2\">"+SystemEnv.getHtmlNoteName(3640,lang)+"</option><option value=\"3\">"+SystemEnv.getHtmlNoteName(3641,lang)+"</option>");
		editBlock.find("span[name=ebrowserSpan]").show();
		editBlock.find("input[name=eparamvalue]").hide();
		editBlock.find("select[name = ebrowsertype]").find("option[value="+browserid+"]").attr("selected",true);
		editBlock.find("select[name=eparamselect]").hide();
	}else if(dftype === "5")
	{
		//下拉框
		editBlock.find("select[name=eparamselect]").find("option").remove();
		editBlock.find("select[name = ecompareoption]").append("<option value='4'>"+SystemEnv.getHtmlNoteName(3632,lang)+"</option><option value='5'>"+SystemEnv.getHtmlNoteName(3633,lang)+"</option>");
		editBlock.find("select[name = evaluetype]").append("<option value=\"4\">"+SystemEnv.getHtmlNoteName(3642,lang)+"</option>");
		editBlock.find("input[name=eparamvalue]").hide();
		editBlock.find("span[name=ebrowserSpan]").hide();
		editBlock.find("select[name=eparamselect]").show();
		if(psolo != "undefined")
		{
			var sevalues = psolo.split("+")[0];
			var selabels = psolo.split("+")[1];
			var seval = sevalues.split(",");
			var selbl = selabels.split("<br>");
			
			for(var i=0;i<seval.length;i++)
				editBlock.find("select[name=eparamselect]").append("<option value="+seval[i]+">"+selbl[i]+"</option>");
		}
	}

	
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
	var editBlock = $(target).parent().parent();
	if (!!!editBlock) return ;
	var displaySpan = editBlock.parent().children("span");
    var key = displaySpan.attr("key");
    var children = $("input[name=child][expindex=" + key + "]");
    if (!!!children[0]) return;
	//自定义变量
    	var datafieldSource = "VAR" + new Date().getTime(); //$("#variabletype").val();
        var datafield = editBlock.find("input[name=eparamdatafield]").val();
        var dfname = editBlock.find("input[name=epname]").val();
        var dflabel = editBlock.find("span[name=eparamdatafieldspan]").text().substr(0,editBlock.find("span[name=eparamdatafieldspan]").text().length-3);
        var dftype = editBlock.find("input[name=eptype]").val();
        var dfbrowid = editBlock.find("input[name=epbrowid]").val();
        //变量ID
        var datafieldID = "VAR" + new Date().getTime(); 
        
        var compareoption = editBlock.find("select[name=ecompareoption]").val();
        var compareoptionlabel = editBlock.find("select[name=ecompareoption]").find("option:selected").text();
        var paramtype = "1";
        //浏览框类型
        var browsertype = editBlock.find("select[name=ebrowsertype]").val();
        
        //字段值
        var paramvalue;
        var valuetype = editBlock.find("select[name=evaluetype]").val();
        var paramtypestr = ""; 
        var orignvalue = paramvalue;
		 var msg = "";
        //是否系统定义参数:0/流程表单字段:1
        var paramsysid = editBlock.find("input[name=epsysid").val();
        var paramformid = editBlock.find("input[name=epformid").val();
        var paramisbill = editBlock.find("input[name=episbill").val();

        if(valuetype === "1" || valuetype === "2" || valuetype==="3" || valuetype==="6") {
        	
        	var sltids = editBlock.find("input[name=eselectids]").val();
        	var selectidsspan = $.trim(editBlock.find("span[name=eselectidsspan]").text().substr(0,editBlock.find("span[name=eselectidsspan]").text().length-3));
        	paramvalue = {ids: sltids, names: selectidsspan};
			if(valuetype==='6'){
			    var appenditem=sltids+"||~WEAVERSPLIT~||||~WEAVERSPLIT~||||~WEAVERSPLIT~||||~WEAVERSPLIT~||||~WEAVERSPLIT~||||~WEAVERSPLIT~||"+paramformid+"||~WEAVERSPLIT~||"+paramisbill;
                paramtypestr= paramtype + weaverSplit + browsertype + weaverSplit + valuetype+weaverSplit+appenditem;
			}else{
            	paramtypestr = paramtype + weaverSplit + browsertype + weaverSplit + valuetype;
			}
        	orignvalue = sltids + weaverSplit + selectidsspan;
        	
        }else if(valuetype === "4"){
        	var soval = editBlock.find("select[name=eparamselect]").val();
        	var solbl = editBlock.find("select[name=eparamselect]").find('option:selected').text();
        	//alert(solbl);
        	paramvalue = {ids: soval, names: solbl};
        	paramtypestr = paramtype + weaverSplit + browsertype + weaverSplit + valuetype;
        	orignvalue = soval + weaverSplit + solbl;
        }
         else if(valuetype === "0"){
        	paramtypestr = datafieldSource + weaverSplit + "-1" + weaverSplit +valuetype;
        	paramvalue = editBlock.find("input[name=eparamvalue]").val();
        	orignvalue = paramvalue;
        }
        else
        {
        	//页面值
        	paramtypestr = datafieldSource + weaverSplit + "-1" + weaverSplit +valuetype;
        	orignvalue = SystemEnv.getHtmlNoteName(3630,lang);
        }
      
        
        if ($.trim(datafield) == "" || $.trim(datafield) == "-1") {
        	msg = SystemEnv.getHtmlNoteName(3631,lang);
        	alert(msg);
        	return;
        }
        
        //变量来源-变量id-变量名-
        var datafieldstr = datafieldSource + weaverSplit + datafieldID + weaverSplit + datafield + weaverSplit + dfname + weaverSplit + dflabel + weaverSplit + dftype + weaverSplit + dfbrowid;
        var wffieldstr = "";
        if(paramsysid === "1")
        	wffieldstr = paramsysid + weaverSplit + paramformid + weaverSplit + paramisbill;
        else 
        	wffieldstr = paramsysid;
	    var hiddenarea = datafieldstr + "-;-" + compareoption + "-;-" + paramtypestr + "-;-" + orignvalue + "-;-" + wffieldstr;
       	
 	var displayvalue = orignvalue;
 	if (orignvalue.indexOf(weaverSplit) != -1) {
    	displayvalue = orignvalue.split(weaverSplit)[1];
    }
 	
 	displaySpan.html(dflabel + " " + compareoptionlabel + " " + displayvalue);
 	children.val(hiddenarea);
 	
 	editBlock.remove();
 	displaySpan.show();
}

function cancelEdit(target) {
	var editBlock = $(target).parent().parent();
	if (!!!editBlock) return ;
	var displaySpan = editBlock.parent().children("span");
	editBlock.remove();
 	displaySpan.show();
}

function clearSltValue(elid, spanelid) {
	elid.val("");
	spanelid.html("");
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