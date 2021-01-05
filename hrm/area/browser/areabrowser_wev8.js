	var areaisworkflow="0";
	function areaaddBackColor(obj){
	  jQuery(obj).css("background-color","#d7d9e0");
	  //jQuery("#searchImg").attr("width","16");
	}
	function arearemoveBackColor(obj){
	  jQuery(obj).css("background-color","#FFFFFF");
	  
	}
	function areaaddBackColor1(obj){
	  if(jQuery(obj).attr("class") == "areaselected"){
	   return;
	  }
	  jQuery(obj).css("background-color","#348DD9");
	  jQuery(obj).css("color","#FFFFFF");
	  //jQuery("#searchImg").attr("width","16");
	}
	function arearemoveBackColor1(obj){
	  if(jQuery(obj).attr("class") == "areaselected"){
	   return;
	  }
	  jQuery(obj).css("background-color","");
	  jQuery(obj).css("color","");
	  
	}
	function areaaddBackColor2(obj,type){
	  var area_select_tab = jQuery(obj).parent().next().val();
	  if(area_select_tab != type){
	   jQuery(obj).css("background-color","#AEBAC6");
	  }
	}
	function arearemoveBackColor2(obj,type){
	  var area_select_tab = jQuery(obj).parent().next().val();
	  if(area_select_tab != type){
   	   jQuery(obj).css("background-color","");
	  }
	  
	}
	
	function arealimousemove(obj,areaName){
		var this_obj = jQuery(obj);
		this_obj.addClass('ac_over');
		var offset = this_obj.offset();
		//var offsetdata = getElementPos(obj); 
		jQuery('#tip-yellowsimple1').children().first().html(this_obj.attr("_title"));
		//jQuery('#tip-yellowsimple1').css({"visibility":"inherit","left":getElementPos(obj).x+this_obj.width()+13,"top":getElementPos(obj).y});
		jQuery('#tip-yellowsimple1').css({"visibility":"inherit","left":offset.left+this_obj.width()+13,"top":offset.top});
	}
	
	function arealimouseout(obj,areaName){
		jQuery(obj).removeClass('ac_over');
		//jQuery("#tip-yellowsimple1"+areaName).css("visibility","hidden");
		jQuery('#tip-yellowsimple1').css("visibility","hidden");
	}
	function areashowli(obj,areaName,areaType){
		var areainputvalue = jQuery("#areainputvalue"+areaName).val();
		if(areainputvalue == obj.value){
		 return;
		}
		if(obj.value == '' ){
		  jQuery("#areashowlidiv").html('');
		  jQuery("#areashowlidiv").parent().css("visibility","hidden");
		  jQuery("#tip-yellowsimple1").css("visibility","hidden");
		  return;
		}
		areainputvalue = obj.value;
		jQuery("#areainputvalue"+areaName).val(areainputvalue)
		var areadatatype = {"country":1111,"province":2222,"city":58,"citytwo":263};
		jQuery.ajax({
		 data:{"q":obj.value,"type":areadatatype[areaType],"limit":30},
		 type: "post",
		 cache:false,
		 url:"/data.jsp",
		 dataType: 'json',
		 beforeSend :function(xhl){
			jQuery("#areaindicator"+areaName).css("display","");
		 },
		 success:function(data){
		   var areahtml="";
		   if(data.length > 0){
		   	 areahtml='<ul>';
		   	 for(var i = 0;i<data.length;i++){
		   	 	var this_id = data[i].id;
		   	 	var this_name = data[i].name;
		   	 	var this_class = "ac_even";
		   	 	if(i/2 == 0){
		   	 	 	this_class = "ac_odd";
		   	 	}
		   	 	areahtml +='<li class="'+this_class+'" _title="  '+this_name+'" onmouseover="arealimousemove(this,\''+areaName+'\')" onmouseout="arealimouseout(this,\''+areaName+'\')" onclick="setareainputvalue('+this_id+',\''+this_name+'\',1,\''+areaName+'\')">'+this_name+'</li>';
		   	 }
		   	 areahtml +='</ul>';
			 jQuery("#areashowlidiv").html(areahtml);
			 jQuery("#areashowlidiv").parent().css("visibility","inherit");
		   }else{
		   	 jQuery("#areashowlidiv").html('');
		   	 jQuery("#areashowlidiv").parent().css("visibility","hidden");
		   	 jQuery("#tip-yellowsimple1").css("visibility","hidden");
		   }
	  	   jQuery("#areaindicator"+areaName).css("display","none");
		}	
	  });
	}
	
	function areasearch(areaname){
		var areaPlus = false;
		jQuery('.areasearchbox').each(function(){
			var boxType = jQuery(this).attr('type');
			if(boxType != areaname){
				if(jQuery("#areashowbox"+boxType).css("display") != "none"){
					jQuery("#areashowbox"+boxType).css("display","none");
					jQuery("#searchImg"+boxType).attr("src","/hrm/area/browser/image/down.png");
					areaPlus = true;
				}
			}
		});
		var area_thisbodyheight = jQuery(".zDialog_div_content").height();
		if(jQuery("#areashowbox"+areaname).css("display") == "none"){
			jQuery("#areashowbox"+areaname).css("display","");
			jQuery("#searchImg"+areaname).attr("src","/hrm/area/browser/image/up.png");
			if(!areaPlus){
				jQuery('.zDialog_div_content').height(area_thisbodyheight+280);
			}
		}else{
			jQuery("#areashowbox"+areaname).css("display","none");
			jQuery("#searchImg"+areaname).attr("src","/hrm/area/browser/image/down.png");
			jQuery(".zDialog_div_content").height(area_thisbodyheight - 280);
		}
	}
	
	function areachoose(type,areaName,isShow){
		var area_select_array = {"country":0,"province":0,"city":0,"citytwo":0};
		var area_select_tab = jQuery("#area_select_tab"+areaName).val();
		if(area_select_tab == type){
			return;
		}
		if(jQuery("#area_"+type+areaName).attr('isopen') == "1"){
		  return;
		}
		area_select_tab = type;
		jQuery("#area_select_tab"+areaName).val(type);
		for(var name in area_select_array){
			if(name == type){
				jQuery("#area_"+name+areaName).css("background-color","#FFFFFF");
					jQuery("#area_"+name+"_div"+areaName).css("display","");
			}else{
				jQuery("#area_"+name+areaName).css("background-color","");
					jQuery("#area_"+name+"_div"+areaName).css("display","none");
			}
		}
	}
	
	function areaselectitem(type,id,name,areaName,isShow){
		//var thistypeselectid = area_select_array[type];
		var area_next_array = {"country":"province","province":"city","city":"citytwo"};
		var area_select_tab = jQuery("#area_select_tab"+areaName).val();
		var thistypeselectid = jQuery("#area"+type+"hiddenid"+areaName).val();
		if(area_select_tab == type && id == thistypeselectid){
			//return;
		}
		if(thistypeselectid != ''){
		  jQuery("#areaitem_"+areaName+type+"_"+thistypeselectid).removeClass("areaselected");
		  jQuery("#areaitem_"+areaName+type+"_"+thistypeselectid).css("background-color","");
	 	  jQuery("#areaitem_"+areaName+type+"_"+thistypeselectid).css("color","");
		  jQuery("#areaitem_"+areaName+type+"_"+id).addClass("areaselected");
		}else{
		  jQuery("#areaitem_"+areaName+type+"_"+id).addClass("areaselected");
		}
		jQuery("#area"+type+"hiddenid"+areaName).val(id);
		var _areaselectType = jQuery("#areahiddenid"+areaName).attr("areaType");
		if(_areaselectType == type){
			setareainputvalue(id,name,isShow,areaName);
		}else{
			if(jQuery("#area_"+area_next_array[type]+areaName).attr('isopen') == "1"){
			  jQuery("#area_"+area_next_array[type]+areaName).attr('isopen','0');
			}
			var this_area_next_array = area_next_array[type];
			try{
				for(var i= 0;i<3;i++){
					if(area_next_array[this_area_next_array] != ""){
						this_area_next_array = area_next_array[this_area_next_array];
						if(jQuery("#area_"+this_area_next_array+areaName).attr('isopen') == "0"){
				  			jQuery("#area_"+this_area_next_array+areaName).attr('isopen','1');
						}
					}
				}
			}catch(e){
			//alert(e);
			}
			areagetAreaJson(type,id,areaName);
			setTimeout("areachoose(\""+area_next_array[type]+"\",\""+areaName+"\","+isShow+")",100);
		}
	}
	function setareainputvalue(id,name,opt,areaname){
		var areainpuPre = jQuery('#_areainput'+areaname).parent().width();
		var areamaxwidth = 200;
		if(areamaxwidth > (areainpuPre-63)){
			areamaxwidth = areainpuPre-63;
		}
		var showhtml='';
         if(areaisworkflow=='1'){
			   var isdetail = areaname.indexOf("_")!=-1?true:false;
			  showhtml='<span class="e8_showNameClass" '+(areaisworkflow=='1'?'id="'+areaname+'span" name="'+areaname+'span"':'')+' style="height:20px!important;" onmouseover="areacloseshoworhide(this,1)" onmouseout="areacloseshoworhide(this,2)"><a href="#1" onclick="return false;" title="'+name
		          +'" style="max-width:'+areamaxwidth+'px!important;overflow:hidden!important;text-overflow:ellipsis!important;white-space:nowrap!important;display: inline-block!important;">'
		          +name+'</a><span onclick="areadeleteitem(this,\''+areaname+'\')"  class="e8_delClass" id="1" style="visibility: hidden; opacity: 1;position: relative; top: '+(isdetail?"0":"-4")+'px;left: 0px;margin-right:5px;">x</span></span>';
        }else{
	        showhtml='<span class="e8_showNameClass" '+(areaisworkflow=='1'?'id="'+areaname+'span" name="'+areaname+'span"':'')+' style="height:20px!important;" onmouseover="areacloseshoworhide(this,1)" onmouseout="areacloseshoworhide(this,2)"><a href="#1" onclick="return false;" title="'+name
		          +'" style="max-width:'+areamaxwidth+'px!important;overflow:hidden!important;text-overflow:ellipsis!important;white-space:nowrap!important;display: inline-block!important;">'
		          +name+'</a><span onclick="areadeleteitem(this,\''+areaname+'\')"  class="e8_delClass" id="1" style="visibility: hidden; opacity: 1;position: relative; top: -4px;left: 0px;margin-right:5px;">x</span></span>';
        }
		
		jQuery("#areahiddenid"+areaname).val(id);
		jQuery("#areashowtext"+areaname).html(showhtml);
		jQuery("#_areainput"+areaname).val('');
		jQuery('#_areainput'+areaname).css('display','none');
		if(areaisworkflow=='1'){
		      jQuery("#"+areaname+"spanimg").html('');
			  jQuery("#"+areaname).val(id);
			  jQuery("#"+areaname+"__").val(id);
		}else{
			 jQuery("#areaspanimg"+areaname).css("display","none");
		     jQuery("#areaspanimg"+areaname).html('');
		}
		if(opt == 0 ){
			areasearch(areaname);
		}else{
			jQuery("#areainputvalue"+areaname).val("");
		}
		try{
		 var callbackarray = {"id":id,"name":name,"areaname":areaname};
		 var callbackname = jQuery("#areahiddenid"+areaname).parent().attr("areaCallback");
		 if(callbackname){
			 var t = new Thing();
			 t.doAreacallback(eval(callbackname), callbackarray);
		 }
		}catch(e){
			//alert(e);
		}
		
	}
	function Thing() {
	 
	}
	Thing.prototype.doAreacallback = function(callback, salutation) {
	    // Call our callback, but using our own instance as the context
		callback.call(this, salutation);
	} 
	function areainputblur(areaName){
		setTimeout("areainputblurcode(\'"+areaName+"\')",230);
	}
	function areainputblurcode(areaName){
	    jQuery("#areashowlidiv").html('');
		jQuery("#areashowlidiv").parent().css("visibility","hidden");
		jQuery("#areashowlidiv").parent().css("visibility","hidden");
		jQuery("#tip-yellowsimple1").css("visibility","hidden");
		jQuery("#areainputvalue"+areaName).val("");
		jQuery("#_areainput"+areaName).val('');
		//jQuery('#_areainput').css('display','none');
	}
	function set_areacitycss(areaname){
		var thisaspanwidth_ = 0;
		if(jQuery("#areashowtext"+areaname).children('span')){
		 thisaspanwidth_ = jQuery("#areashowtext"+areaname).children('span').width();
		}
		var areainpuPre = jQuery('#_areainput'+areaname).parent().width();
		//alert(areainpuPre+'---'+thisaspanwidth_);
		jQuery('#_areainput'+areaname).css({'display':'','max-width':areainpuPre-42-thisaspanwidth_});
		jQuery('#_areainput'+areaname).focus();
		var offset = jQuery('#_areainput'+areaname).offset(); 
		//var offsetdata 
		jQuery("#areashowlidiv").parent().css({"top":offset.top+25,"left":offset.left});
		//var offset = getElementPos(jQuery('#_areainput'+areaname)); 
		//jQuery("#areashowlidiv"+areaname).parent().css({"margin-left":thisaspanwidth_});
	}
	
	function areadeleteitem(obj,areaname){
		if(areaisworkflow=='1'){
			  if(jQuery("#"+areaname).attr("viewtype")=='1'){
				    jQuery("#_areaselect_"+areaname).attr('areaMustInput','2');
			  }else{
				   jQuery("#_areaselect_"+areaname).attr('areaMustInput','1');
			  }
		}
		var areaMustInput = jQuery("#_areaselect_"+areaname).attr('areaMustInput');
		if(areaMustInput == "2"){
			if(areaisworkflow=='1'){
			     jQuery("#"+areaname+"spanimg").html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
			}else{
				 jQuery("#areaspanimg"+areaname).css({"display":""});
			     jQuery("#areaspanimg"+areaname).html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
			}			
		}
		jQuery("#areashowtext"+areaname).children('span').html('');
		jQuery("#areahiddenid"+areaname).val('');
		jQuery("#"+areaname).val('');
		jQuery("#_areainput"+areaname).css("width","17px");
		set_areacitycss(areaname);
		
		try{
		
		 var callbackarray = {"id":"0","name":"","areaname":areaname};
		 var callbackname = jQuery("#areahiddenid"+areaname).parent().attr("areaCallback");
		 if(callbackname){
			 var t = new Thing();
			 t.doAreacallback(eval(callbackname), callbackarray);
		 }
		}catch(e){
			//alert(e);
		}
		jQuery("#"+areaname).val('');
		
	}
	function areacloseshoworhide(obj,no){
		if(areaisworkflow=='1'){
			jQuery(obj).children('span').css('visibility','visible');
		}else{
			if(no == 1){
				jQuery(obj).children('span').css('visibility','visible');
			}else{
				jQuery(obj).children('span').css('visibility','hidden');
			}
		}
	}
	function areagetAreaJson(type,supid,areaName){
		var area_next_array = {"country":"province","province":"city","city":"citytwo"};
		jQuery.ajax({
		 data:{"id":supid,"type":type},
		 type: "get",
		 cache:false,
		 url:"/hrm/area/Area_json.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		   var areahtml="";
		   if(data.length > 0){
		   	 for(var i = 0;i<data.length;i++){
		   	 	var this_id = data[i].id;
		   	 	var this_name = data[i].name;
		   	 	var this_type = data[i].type;
		   	 	var isSelect = "";
		   	    //if(i==0 && supid ==""){
		   	    	//area_select_country = this_id;
		   	    	//isSelect = "areaselected";
		   	    //}
		   	 	areahtml +='<span id="areaitem_'+areaName+this_type+'_'+this_id+'" class="'+isSelect+'" style="cursor: pointer;text-align: center;min-width:48px;height:23px;padding-top:7px;display:block;float: left;margin:1px;"'
		   	 		+' onclick="areaselectitem(\''+this_type+'\','+this_id+',\''+this_name+'\',\''+areaName+'\',0)" onmouseover="areaaddBackColor1(this)" onmouseout="arearemoveBackColor1(this)">'+this_name+'</span>';
		   	 }
		   }
	   	 if(type == ""){
		   	 jQuery("#area_country_content"+areaName).html(areahtml);
		   	 setTimeout("jQuery('#area_country_div"+areaName+"').perfectScrollbar();",300);
		  }else{
		   	 jQuery("#area_"+area_next_array[type]+"_content"+areaName).html(areahtml);
		   	 setTimeout("jQuery('#area_"+area_next_array[type]+"_div"+areaName+"').perfectScrollbar();",300);
		  }
		}	
	  });
	}
	function setDefaultSelect(type,id,name,areaName){
		if(type == "country"){
			areaselectitem(type,id,name,areaName,1);
			return;
		}
		var typesarray =["country","province","city","citytwo"];
		jQuery.ajax({
		 data:{"id":id,"type":type,"opt":"findSubid"},
		 type: "post",
		 cache:false,
		 url:"/hrm/area/Area_json.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		   var areahtml="";
		   if(data.length > 0){
		   	 for(var i = 0;i<data.length;i++){
		   	 	var this_id = data[i].id;
		   	 	var this_name = data[i].name;
		   	 	var this_type = data[i].type;
		   	 	areaselectitem(this_type,this_id,this_name,areaName,1);
		   	 }
		   	 areaselectitem(type,id,name,areaName,1);
		   }
		}	
	  });
	}
	function areromancedivs(){
		jQuery('._areaselect').each(function(){
				if(!jQuery(this).hasClass('romanced')){
					areromancediv(this);
				}
		});
	}
	function areromancedivbyid(id,showid){
		if(!!showid && showid=='-1'){
			  areaisworkflow ="1";
		}
        
		areromancediv(jQuery("#"+id),showid);
	}
	function areromancediv(obj,showid){

        var languageid=readCookie("languageidweaver");
        
    	var countryName = "国家";       
    	var provinceName = "省份";      
    	var cityName = "城市";          
    	var district = "区县";  
    	
		jQuery.ajax({
		 data:{"opt":"getTitle"},
		 type: "post",
		 cache:false,
		 url:"/hrm/area/Area_json.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		   var areahtml="";
		   if(data.length > 0){
		   	 for(var i = 0;i<data.length;i++){
		   		countryName = data[i].countryName;
		   		provinceName = data[i].provinceName;
		   		cityName = data[i].cityName;
		   		district = data[i].district;
		   	 }
		   }
		}	
		});
        
        
		var _areaType = jQuery(obj).attr('areaType');
		var _areaName = jQuery(obj).attr('areaName');
		if(_areaType == '' || _areaType == null || _areaType == undefined){
			_areaType = 'city';
			jQuery(obj).attr('areaType',_areaType)
		}
		if(_areaName == '' || _areaName == null || _areaName == undefined){
			_areaName = 'cityid';
			jQuery(obj).attr('areaName',_areaName);
		}
		var _areaValue = jQuery(obj).attr('areaValue');
		if(_areaValue == '' || _areaValue == null || _areaValue == undefined || _areaValue == '0'){
			_areaValue = '';
		}
		var _areaMustInput = jQuery(obj).attr('areaMustInput');
		if(_areaMustInput == '' || _areaMustInput == null || _areaMustInput == undefined){
			_areaMustInput = '';
		}
		var _areaSpanValue = jQuery(obj).attr('areaSpanValue');
		var showhtml='';
		if(_areaSpanValue){
			if(!!showid && showid=='-1'){
				var isdetail=_areaName.indexOf("_")!=-1?true:false;
				  showhtml='<span class="e8_showNameClass" id="'+_areaName+'span" name="'+_areaName+'span" style="height:20px!important;" onmouseover="areacloseshoworhide(this,1)" onmouseout="areacloseshoworhide(this,2)"><a href="#1" onclick="return false;" title="'+_areaSpanValue
	          +'" style="max-width: 200px;overflow:hidden!important;text-overflow:ellipsis!important;white-space:nowrap!important;display: inline-block!important;">'
	          +_areaSpanValue+'</a><span onclick="areadeleteitem(this,\''+_areaName+'\')" class="e8_delClass" id="1" style="visibility: hidden; opacity: 1;position: relative; top: '+(isdetail?"0":"-4")+'px;left: 0px;margin-right:5px;">x</span></span>';
			}else{
			 showhtml='<span class="e8_showNameClass" style="height:20px!important;" onmouseover="areacloseshoworhide(this,1)" onmouseout="areacloseshoworhide(this,2)"><a href="#1" onclick="return false;" title="'+_areaSpanValue
	          +'" style="max-width: 200px;overflow:hidden!important;text-overflow:ellipsis!important;white-space:nowrap!important;display: inline-block!important;">'
	          +_areaSpanValue+'</a><span onclick="areadeleteitem(this,\''+_areaName+'\')" class="e8_delClass" id="1" style="visibility: hidden; opacity: 1;position: relative; top: -4px;left: 0px;margin-right:5px;">x</span></span>';
            }
		}else{
			if(!!showid && showid=='-1'){
				  showhtml='<span class="e8_showNameClass" id="'+_areaName+'span" name="'+_areaName+'span" style="height:20px!important;" onmouseover="areacloseshoworhide(this,1)" onmouseout="areacloseshoworhide(this,2)"><a href="#1" onclick="return false;" title="'+_areaSpanValue
	          +'" style="max-width: 200px;overflow:hidden!important;text-overflow:ellipsis!important;white-space:nowrap!important;display: inline-block!important;">'
	          +_areaSpanValue+'</a><span onclick="areadeleteitem(this,\''+_areaName+'\')" class="e8_delClass" id="1" style="visibility: hidden; opacity: 1;position: relative; top: -4px;left: 0px;margin-right:5px;"></span></span>';
			}
		}
		 var _areaselecthtml ='<input type="hidden" name="'+_areaName+'" areaType="'+_areaType+'" id="areahiddenid'+_areaName+'" value="'+_areaValue+'"/>';
		 if(!!showid && showid=='-1'){
			  _areaselecthtml ='<input type="hidden" name="areahiddenid'+_areaName+'" areaType="'+_areaType+'" id="areahiddenid'+_areaName+'" value="'+_areaValue+'"/>';
			 _areaselecthtml += '<input type="hidden" name="'+_areaName+'__" areaType="'+_areaType+'" id="'+_areaName+'__" value="'+_areaValue+'"/>';
		 }
		 _areaselecthtml += '<div style="position: relative;max-width: 332px!important;height:27px;width: inherit;"> <div style="float:left;">' ;
		 _areaselecthtml += '<div  class="areacontext" onclick="set_areacitycss(\''+_areaName+'\')" onblur="">' ;
		 _areaselecthtml += '<div id="areashowtext'+_areaName+'" areaMustInput="'+_areaMustInput+'" style="position: relative;float:left;;height:25px;padding-top: 3px;">'+showhtml+'</div>';
		 _areaselecthtml += '<input  type="text" id="_areainput'+_areaName+'"  class="areainput" style="width:17px;max-width: 278px;min-width: 17px;position: relative;float: left;border: 0px !important;top: 2px;display:none;"  onblur="areainputblur(\''+_areaName+'\');"  value=""/>';
		 _areaselecthtml += '<span id="searchBox'+_areaName+'" type="'+_areaName+'" class="areasearchbox"   onclick="areasearch(\''+_areaName+'\')" onmouseover="areaaddBackColor(this)" onmouseout="arearemoveBackColor(this)">';
		 _areaselecthtml += ' <img id="searchImg'+_areaName+'"  class="" src="/hrm/area/browser/image/down.png" ></span>';
		 _areaselecthtml += ' <span id="areaindicator'+_areaName+'" style="display: none;position:relative ;float:right; padding: 5.2px 0px 4.1px 0px;height: 16px;width: 16px; z-index: 99;" ><img src="/js/jquery-autocomplete/indicator_wev8.gif"/></span>';
		 _areaselecthtml += ' </div></div>';
         if(!!showid && showid=='-1'){
		     _areaselecthtml += ' <span id="'+_areaName+'spanimg" name="'+_areaName+'spanimg" style="position: relative;float: right;padding-top:3px;"></span>';
         }else{
	          _areaselecthtml += ' <span id="areaspanimg'+_areaName+'"  style="position: relative;display:none ;float: right;padding-top:3px;"></span>';
          }
		 _areaselecthtml += ' </div>';
		  if(!!showid && showid=='-1'){
			  _areaselecthtml += ' <div id="areashowbox'+_areaName+'" class="areashowboxcontext" style="display: none;z-index:1000">';
		  }else{
			  _areaselecthtml += ' <div id="areashowbox'+_areaName+'" class="areashowboxcontext" style="display: none;">';
		  }
		 _areaselecthtml += ' <div class="areashowboxdiv">';
		 _areaselecthtml += ' <ul class="areashowbox_ul">';
		 _areaselecthtml += ' <li id="area_country'+_areaName+'" type="'+_areaName+'" isopen="0" style=" background-color: #FFFFFF;" class="areashowbox_li" onclick="areachoose(\'country\',\''+_areaName+'\',0)" onmouseover="areaaddBackColor2(this,\'country\')" onmouseout="arearemoveBackColor2(this,\'country\')">'+countryName+'</li>';
		 _areaselecthtml += ' <li id="area_province'+_areaName+'" type="'+_areaName+'" isopen="1" style="" class="areashowbox_li" onclick="areachoose(\'province\',\''+_areaName+'\',0)" onmouseover="areaaddBackColor2(this,\'province\')" onmouseout="arearemoveBackColor2(this,\'province\')">'+provinceName+'</li>';
		 _areaselecthtml += ' <li id="area_city'+_areaName+'" type="'+_areaName+'" isopen="1" class="areashowbox_li" onclick="areachoose(\'city\',\''+_areaName+'\',0)" onmouseover="areaaddBackColor2(this,\'city\')" onmouseout="arearemoveBackColor2(this,\'city\')">'+cityName+'</li>';
		 _areaselecthtml += ' <li id="area_citytwo'+_areaName+'" type="'+_areaName+'" isopen="1" class="areashowbox_li" onclick="areachoose(\'citytwo\',\''+_areaName+'\',0)" onmouseover="areaaddBackColor2(this,\'citytwo\')" onmouseout="arearemoveBackColor2(this,\'citytwo\')">'+district+'</li>';
		 _areaselecthtml += ' </ul>';
		 _areaselecthtml += ' <input type="hidden"  id="area_select_tab'+_areaName+'" value="country"/>';
		 _areaselecthtml += ' <input type="hidden"  id="areainputvalue'+_areaName+'" value=""/>';
		 _areaselecthtml += ' <input type="hidden"  id="areacountryhiddenid'+_areaName+'"/>';
		 _areaselecthtml += ' <input type="hidden"  id="areaprovincehiddenid'+_areaName+'"/>';
		 _areaselecthtml += ' <input type="hidden"  id="areacityhiddenid'+_areaName+'"/>';
		 _areaselecthtml += ' <input type="hidden"  id="areacitytwohiddenid'+_areaName+'"/>';
		 _areaselecthtml += ' <div id="area_country_div'+_areaName+'" class="areashowbox_div"><div id="area_country_content'+_areaName+'" style="height:100%;"></div></div>';
		 _areaselecthtml += ' <div id="area_province_div'+_areaName+'" class="areashowbox_div" style="display: none;"><div id="area_province_content'+_areaName+'" style="height:100%;"></div></div>';
		 _areaselecthtml += ' <div id="area_city_div'+_areaName+'" class="areashowbox_div" style="display: none;"><div id="area_city_content'+_areaName+'" style="height:100%;"></div></div>';
		 _areaselecthtml += ' <div id="area_citytwo_div'+_areaName+'" class="areashowbox_div" style="display: none;"><div id="area_citytwo_content'+_areaName+'" style="height:100%;"></div></div>';
		 _areaselecthtml += ' </div></div></div>';
		 jQuery(obj).html(_areaselecthtml);
		 jQuery(obj).addClass('romanced');
		 var _areaWidth = jQuery(obj).width();
		  if(_areaWidth > 332){
		  	jQuery(obj).width(332);
		  	jQuery(obj).find('.areacontext').width(319);
	  	 }else if(_areaWidth < 110){
	  	 	jQuery(obj).width(100);
		  	jQuery(obj).find('.areacontext').width(110-13);
		  	jQuery(obj).find('#areashowtext'+_areaName).children('span').children('a').css('max-width',110-13-63);
		 }else{
		  	jQuery(obj).width(_areaWidth);
		  	jQuery(obj).find('.areacontext').width(_areaWidth-13);
		  	jQuery(obj).find('#areashowtext'+_areaName).children('span').children('a').css('max-width',_areaWidth-13-63);
		 }
		 setTimeout('areromancedivbind(\''+_areaName+'\',\''+_areaType+'\',\''+_areaValue+'\',\''+_areaMustInput+'\',\''+_areaWidth+'\',\''+_areaSpanValue+'\')',500);
	}
	
	function areromancedivbind(areaName,areaType,areaValue,areaMustInput,areaWidth,areaSpanValue){
		if(jQuery("#tip-yellowsimple1").html() == null){
		 		jQuery('body').prepend('<div class="tip-yellowsimple1" id="tip-yellowsimple1" style=""><div class="tip-inner1 tip-bg-image1"></div><div class="tip-arrow1 tip-arrow-left1"></div> </div>'+
				'<div id="e8_autocomplete_div1" areaName="citytwoid"  style="visibility:hidden; position: absolute;  overflow-y: hidden;overflow:hidden;height:230px;" class="ac_results areashowli" tabindex="5008"><div style="height:100%;" id="areashowlidiv"></div></div>');
		 }
		 var area_next_array = {"country":"province","province":"city","city":"citytwo"};
		 areagetAreaJson("","",areaName);
		 //var _areaselectType = 	areaType;
		 jQuery('#_areainput'+areaName).bind('input  propertychange', function(event) {
		 	areashowli(this,areaName,areaType);
		 	var areaInTex = jQuery(this).val();
		 	jQuery(this).width(areaInTex.length*20);
		 	
		 });
		 if(areaMustInput == "2" && areaValue == ""){
			 if(areaisworkflow=='1'){
			     jQuery("#"+areaName+"spanimg").html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
			 }else{
				jQuery("#areaspanimg"+areaName).css({"display":""});
			    jQuery("#areaspanimg"+areaName).html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
			 }

		 }
		 jQuery('#areashowlidiv').parent().perfectScrollbar();
		 var liareatype = areaType;
		 while(area_next_array[liareatype]){
		 	 liareatype = area_next_array[liareatype];
			 jQuery("#area_"+liareatype+areaName).css({"display":"none"});
		 }
		 if(areaValue !=""){
			 setDefaultSelect(areaType,areaValue,areaSpanValue,areaName);
		 }
		 jQuery('#_areainput'+areaName).keydown(function(event){
	 		var areaInTex = jQuery(this).val();
            //var e = event || window.event || arguments.callee.caller.arguments[0];
            var e = event;
             if(e && (e.keyCode==46 || e.keyCode==8)){ // enter 键
                 if(areaInTex == ""){
                 	areadeleteitem(this,areaName);
                 }
            }
         });
	}
	
	jQuery(function(){
		 //areromancedivs();
		 //jQuery('body').prepend('<div class="tip-yellowsimple1" id="tip-yellowsimple1" style=""><div class="tip-inner1 tip-bg-image1"></div><div class="tip-arrow1 tip-arrow-left1"></div> </div>'+
			//'<div id="e8_autocomplete_div1" areaName="citytwoid"  style="visibility:hidden; position: absolute;  overflow-y: hidden;overflow:hidden;height:230px;" class="ac_results areashowli" tabindex="5008"><div style="height:100%;" id="areashowlidiv"></div></div>');
	});
	
	
function getElementPos(elementId){
    var ua = navigator.userAgent.toLowerCase();
    var isOpera = (ua.indexOf('opera') != -1);
    var isIE = (ua.indexOf('msie') != -1 && !isOpera); // not opera spoof
    var el = elementId;

    if(el.parentNode === null || el.style.display == 'none') 
    {
        return false;
    } 

    var parent = null;
    var pos = [];     
    var box;
	//alert(el.getBoundingClientRect);
    if(el.getBoundingClientRect)    //IE
    {         
        box = el.getBoundingClientRect();
        var scrollTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
        var scrollLeft = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);
        //var parentscrollTop = Math.max(window.parent.document.documentElement.scrollTop, window.parent.document.body.scrollTop);
        //var parentscrollLeft = Math.max(window.parent.document.documentElement.scrollLeft, window.parent.document.body.scrollLeft);
        //alert(parentscrollTop);
        return {x:box.left + scrollLeft, y:box.top + scrollTop};
    }
    else if(document.getBoxObjectFor)    // gecko    
    {
        box = document.getBoxObjectFor(el); 
        var borderLeft = (el.style.borderLeftWidth)?parseInt(el.style.borderLeftWidth):0; 
        var borderTop = (el.style.borderTopWidth)?parseInt(el.style.borderTopWidth):0; 
        pos = [box.x - borderLeft, box.y - borderTop];
    }
    else    // safari & opera    
    {
        pos = [el.offsetLeft, el.offsetTop];  
        parent = el.offsetParent;   
        if (parent != el) 
        { 
            while (parent) 
            {  
                pos[0] += parent.offsetLeft; 
                pos[1] += parent.offsetTop; 
                parent = parent.offsetParent;
            }  
        } 
        if (ua.indexOf('opera') != -1 || ( ua.indexOf('safari') != -1 && el.style.position == 'absolute' )) 
        { 
            pos[0] -= document.body.offsetLeft;

            pos[1] -= document.body.offsetTop;         
        }    
    } 
    if (el.parentNode) 
    { 
        parent = el.parentNode;
    } 
    else 
    {
        parent = null;
    }
    while (parent && parent.tagName != 'BODY' && parent.tagName != 'HTML') 
    { // account for any scrolled ancestors
        pos[0] -= parent.scrollLeft;
        pos[1] -= parent.scrollTop;
        if (parent.parentNode) 
        {
            parent = parent.parentNode;
        } 
        else 
        {
            parent = null;
        }
    }
    return {x:pos[0], y:pos[1]};
}
	
	