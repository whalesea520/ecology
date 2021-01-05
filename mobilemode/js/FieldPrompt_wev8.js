
//获取相应的字段元素
function getFieldElement(fieldInfo){
	var fieldid = fieldInfo["id"];
	var fieldhtmltype = fieldInfo["fieldhtmltype"];
	if(fieldhtmltype == "1"){	//单行文本框
		return document.getElementById("field" + fieldid);
	}else if(fieldhtmltype == "2"){	//多行文本框
		return null;	//暂觉得多行文本框做唯一性校验也没意思，如需要，可修改此处代码
	}else if(fieldhtmltype == "3"){	//浏览按钮
		return document.getElementById("field" + fieldid);
	}else if(fieldhtmltype == "4"){	//Check框
		return null;	//Check框做唯一性验证没有意义，因为只有两个值
	}else if(fieldhtmltype == "5"){	//选择框
		return document.getElementById("field" + fieldid);
	}else if(fieldhtmltype == "6"){	//附件上传
		return null;
	}else if(fieldhtmltype == "7"){	//特殊字段
		return null;
	}
}

//获取相应的字段元素的值 (可扩展为按照类型增加额外代码进行处理)
function getFieldValue(fieldInfo){
	var fieldElement = getFieldElement(fieldInfo);
	if(!fieldElement){
		return null;
	}
	return fieldElement.value;
}

function fieldIsChanged(fieldElement){
	var isChanged = false;
    var type = fieldElement.type;
    if (type == "text" || type == "hidden" || type == "textarea" || type == "button")
    {
        if (fieldElement.value != fieldElement.defaultValue)
        {
            isChanged = true;
        }
    }
    else if (type == "radio" || type == "checkbox")
    {
        if (fieldElement.checked != fieldElement.defaultChecked)
        {
            isChanged = true;
        }
    }
    else if (type == "select-one")
    {
    	var c = false;
    	var def = 0;
        for (var j = 0; j < fieldElement.options.length; j++)
        {
        	var opt = fieldElement.options[j];
        	c = c || (opt.selected != opt.defaultSelected);
        	if (opt.defaultSelected) def = j;
        }
        if (c && !fieldElement.multiple) c = (def != fieldElement.selectedIndex);
		if (c){
			isChanged = true;
		}
    }
    else
    {
        //do otherthing
    }
	return isChanged;
}

function createLoadingTip(){
	var $docBody = $(document.body);
	var w = document.body.scrollLeft + document.body.clientWidth/2 - 50;
	var h = document.body.scrollTop + document.body.clientHeight/2 - 50;
	var $loadingTip = $("<div id=\"PromptLoadingTip\" style=\"position: absolute;top: "+h+"px;left: "+w+"px;z-index: 10000;border: 1px solid #e9e9e9; background-color: #fff;padding: 6px 10px 3px 30px; vertical-align:middle; background-image: url('/images/messageimages/loading_wev8.gif');background-repeat: no-repeat;background-position: 10px center;\">数据唯一性验证中，请等待...</div>");
	$docBody.append($loadingTip);
}

function dropLoadingTip(){
	$("#PromptLoadingTip").remove();
}
