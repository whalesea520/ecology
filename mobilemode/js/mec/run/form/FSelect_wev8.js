Mobile_NS.FSelect = {};
Mobile_NS.FSelect.onload = function(p){
	var theId = p["id"];
	var pFieldId = p["pfieldid"];
	var fieldId = p["fieldid"];
	var uitype = p["uitype"];
	if(pFieldId != 0 && fieldId != 0 && uitype !=1){
		var defVal = p["defaultValue"];
		doInitChildSelect(fieldId, pFieldId, defVal);
	}
	
};

function doInitChildSelect(fieldid, pFieldid, defVal){
	try{
		var $pField = $("select[fieldid='"+pFieldid+"']");
		var $field = $("select[fieldid='"+fieldid+"']");
		if($pField != null){
			var pFieldValue = $pField.val();
			if(!pFieldValue){
				$field.get(0).options.length = 0;//清空option
			}else{
				var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=1&selectvalue="+pFieldValue+"&isdetail=1";
				$.ajax({
			     type:'post',    
			     url:'/mobilemode/setup/SelectChangeAjax.jsp?'+paraStr,
			     cache:false,    
			     dataType:'json',
			     async : false,
			     success:function(data){
			        if(data){
			        	var $selectObj = $("select[fieldid='"+fieldid+"']");
			        	$selectObj.get(0).options.length = 0;//清空option
			        	$selectObj.append("<option></option>");//添加空值
						$(data).each(function(index,val){//循环添加值
							var selected = defVal == val.value ? "selected='selected'" : "";
							$selectObj.append("<option value='"+val.value+"' "+selected+">"+val.text+"</option>");
						});
			        }
			      },    
			      error:function(){}    
				});   
			}
		}
	}catch(e){console.log(e.message)}
}

function changeChildField(obj, fieldid, childfieldid){
	var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&selectvalue="+obj.value+"&isdetail=1";
	$.ajax({
     type:'post',    
     url:'/mobilemode/setup/SelectChangeAjax.jsp?'+paraStr,
     cache:false,    
     dataType:'json',
     async : false,
     success:function(data){
        if(data){
        	var $selectObj = $("select[fieldid='"+childfieldid+"']");
        	$selectObj.get(0).options.length = 0;//清空option
        	$selectObj.append("<option></option>");//添加空值
			$(data).each(function(index,val){//循环添加值
				$selectObj.append("<option value='"+val.value+"'>"+val.text+"</option>");
			});
			
			var onchangeStr = $selectObj.attr('onchange');
			if(onchangeStr){
				var selObj = $selectObj.get(0);
				if (selObj.fireEvent){
					selObj.fireEvent('onchange');
				}else{
					selObj.onchange();
				}
			}
        }
      },    
      error:function(){}    
	});   

}