function paramChange(compareoption1){
	jQuery("#div3_2").hide();
	jQuery("#div3_7").hide();
	if(compareoption1==null){
		compareoption1 = "";
	}
	var paramtype = jQuery("#paramtype").val();
	var browsertype = jQuery("#browsertype").val();
	showValueSpan(paramtype, browsertype);

	if(compareoption1!=""){
		jQuery("#compareoption1").val(compareoption1);
	}

	if(browsertype=="161"||browsertype=="162"){
		jQuery("#div3_2").show();
	}else if(browsertype=="256"||browsertype=="257"){
		jQuery("#div3_7").show();
	}
}

function showValueSpan(paramtype, browsertype){
	
	if(paramtype=="3"){
		jQuery("#browsertypeSpan1").show();
	}else{
		jQuery("#browsertypeSpan1").hide();
	}
	
	jQuery("[id=compareoption1] option").remove();
	
	var compareoption1_obj = jQuery("#compareoption1");
	compareoption1_obj.selectbox("detach");

	if(paramtype=="0") //字符串
	{
		compareoption1_obj.append("<option value='5'>"+compareoption1_327+"</option>");
		compareoption1_obj.append("<option value='6'>"+compareoption1_15506+"</option>");
		compareoption1_obj.append("<option value='9'>"+compareoption1_346+"</option>");
		compareoption1_obj.append("<option value='10'>"+compareoption1_15507+"</option>");
		
	} else if((paramtype=="1" || paramtype=="2") || (paramtype==="3" && (browsertype==="2" || browsertype==="19" || browsertype==="_level")))	//数值 或 日期 或时间 人员的安全级别比较特殊
	{
		compareoption1_obj.append("<option value='1'>"+compareoption1_15508+"</option>");
		compareoption1_obj.append("<option value='2'>"+compareoption1_325+"</option>");
		compareoption1_obj.append("<option value='3'>"+compareoption1_15509+"</option>");
		compareoption1_obj.append("<option value='4'>"+compareoption1_326+"</option>");
       	compareoption1_obj.append("<option value='5'>"+compareoption1_327+"</option>");
       	compareoption1_obj.append("<option value='6'>"+compareoption1_15506+"</option>");
		
	} else if(paramtype==="3") //浏览框
	{
		if(browsertype!="152" && browsertype!="37" && browsertype!="9" && browsertype!="135" 
				&& browsertype!="8" && browsertype!="16" && browsertype!="169" && browsertype!="7" && browsertype!="1" 
				&& browsertype!="2" && browsertype!="18" && browsertype!="19" && browsertype!="17" && browsertype!="24" 
				&& browsertype!="160" && browsertype!="4" && browsertype!="57" && browsertype!="164" &&browsertype!="166"
				&& browsertype!="168" && browsertype!="170" && browsertype!="142" && browsertype!="165" &&browsertype!="169"
				&& browsertype!="65" && browsertype!="146" && browsertype!="167" && browsertype!="117" && browsertype!="194" && browsertype!="256" && browsertype!="257"){
			if(browsertype==="162")
			{
				compareoption1_obj.append("<option value='9'>"+compareoption1_346+"</option>");
				compareoption1_obj.append("<option value='10'>"+compareoption1_15507+"</option>");
			}else
			{
				compareoption1_obj.append("<option value='7'>"+compareoption1_353+"</option>");
                compareoption1_obj.append("<option value='8'>"+compareoption1_21473+"</option>");
			}	
		}else if(browsertype==="9" || browsertype==="8" || browsertype==="16" || browsertype==="7" || browsertype==="1"  
				|| browsertype==="165" || browsertype==="169" || browsertype==="4" || browsertype==="164" || browsertype==="146" || browsertype==="167"
				|| browsertype==="24" || browsertype==="256") //单选

		{
			compareoption1_obj.append("<option value='7'>"+compareoption1_353+"</option>");
            compareoption1_obj.append("<option value='8'>"+compareoption1_21473+"</option>");
			if(browsertype==="4" || browsertype==="164" || browsertype==="167" || browsertype==="169")
			{
				compareoption1_obj.append("<option value='11'>"+compareoption1_82763+"</option>");
				compareoption1_obj.append("<option value='12'>"+compareoption1_82764+"</option>");
			}
           creatBrowservalue(parentObj,true,"","",browsertype); 
		}else if(browsertype==="57" || browsertype==="168" || browsertype==="142" || browsertype==="17" || browsertype==="18"
				|| browsertype==="135" || browsertype==="37" || browsertype==="152" || browsertype==="65" || browsertype==="160" || browsertype==="166"
				|| browsertype==="170" || browsertype==="194" || browsertype==="257"){//多选

			compareoption1_obj.append("<option value='9'>"+compareoption1_346+"</option>");
			compareoption1_obj.append("<option value='10'>"+compareoption1_15507+"</option>");
		}

		compareoption1_obj.selectbox("detach");
	}
}
