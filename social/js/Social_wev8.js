function initAtwho(targetid,url){   
    var allatids = ",";
    var datas=[{"uid":"1","data":"张三","datapy":"zs"},{"uid":"2","data":"李四","datapy":"ls"}];
	/*
	var names =jQuery.map(datas, function(value, i) {
    	if (allatids.indexOf("," + value.id + ",") == -1) { 
     		allatids += value.id + ",";
     		
     		alert("value.uid:"+value.id+" value.data:"+value.name+" value.datapy:"+value.py);
        	return {'id':value.id,'name':value.name, 'py':value.py};
        }
    });
	*/
    url=url?url:"/social/SocialGetData.jsp";
    var at_config = {
        at: "@",
        data: url,
        tpl: "<li data-value='@${name}'>${name}</li>",
        insert_tpl: "<a href='/hrm/HrmTab.jsp?_fromURL=HrmResource&id=${id}' class='hrmecho' _relatedid='${id}' atsome='@${id}' contenteditable='false' style='cursor:pointer;text-decoration:none !important;margin-right:8px;' target='_blank'>${atwho-data-value}</a>", 
        limit: 200,
        callbacks:{before_save:function(data){
        	//alert("1111");
        	var names =jQuery.map(data, function(value, i) {
		    	if (allatids.indexOf("," + value.id + ",") == -1) { 
		     		allatids += value.id + ",";
		        	return {'id':value.id,'name':value.name, 'py':value.py};
		        }
		    });
		    return names;
        }},
        show_the_at: true,
        start_with_space : false,
        with_repeat_matcher : false,
        search_key_py : 'py'
    }
    $('#'+targetid).atwho(at_config);
}

function initCxScroll(){
	
	$("#msgTipList .uimg").each(function(){
		$(this).replaceWith("[图片]");
	});
	$("#msgTipList .faceicon").each(function(){
		$(this).replaceWith("[表情]");
	});
	$('#msgTipList').cxScroll({
		direction: 'bottom',
		speed: 500,
		time: 1500,
		plus: false,
		minus: false,
		prevBtn:false,
		nextBtn:false
	});	
}

function initPageEvent(){
	
	//没有创建群组、百科分享、同事圈分享，右边的提示
	$(".noneTip").live("mouseenter",function(){
		$(this).html($(this).attr("_activeTip"));
	}).live("mouseleave",function(){
		$(this).html($(this).attr("_normalTip"));
	});
	
	$(".groupMsgdiv").live("mouseenter",function(){
		$(this).find(".gmoptdiv").show();
	}).live("mouseleave",function(){
		$(this).find(".gmoptdiv").hide();
	});
	
	$(".sharetable").live("mouseenter",function(){
		$(this).find(".share_optionItems").show();
	}).live("mouseleave",function(){
		$(this).find(".share_optionItems").hide();
	});
	
	
	
}

function initFancyImg(obj){
	$(obj).fancybox({
		'overlayShow'	: false,
		'titleShow':false,
		'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
		'type':'image'
	});
}



