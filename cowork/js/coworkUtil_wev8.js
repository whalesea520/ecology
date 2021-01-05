/*标记为重要不重要*/
function markImportant(obj){
  var important=$(obj).attr("_important");
  var coworkid=$(obj).attr("_coworkid");
  if(important=="1"){
      $(obj).removeClass("important").addClass("important_no");
      $(obj).attr("_important","0");
      markItemAsImportantOrNot(coworkid,"normal")
  }else{
      $(obj).removeClass("important_no").addClass("important");
      $(obj).attr("_important","1");
      markItemAsImportantOrNot(coworkid,"important")
  }
}

//标记为重要或者不重要
function markItemAsImportantOrNot(coworkid,type){
    jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:coworkid,type:type},function(data){
    	return true; 
    });
}

//顶置
function showTop(discussid,coworkid){
	jQuery.post("/cowork/CoworkOperation.jsp?method=dotop", {discussid:discussid,id:coworkid},function(data){
    	toPage(1); 
    });
}	
//取消顶置
function cancelTop(discussid,coworkid){
	jQuery.post("/cowork/CoworkOperation.jsp?method=canceltop", {discussid:discussid,id:coworkid},function(data){
    	toPage(1); 
    });
}

//审批
function doApproveDiscuss(discussid,coworkid){
	var language = readCookie('languageidweaver');
	window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4065,language),function(){
		jQuery.post("/cowork/CoworkOperation.jsp?method=doApproveDiscuss", {discussid:discussid,id:coworkid},function(data){
    		toPage(1); 
    	});
	});	
}

function doBatchDelDiscuss(type){
	var discussid=getCheckedIds();
	var language = readCookie('languageidweaver');
	if(type=="monitor"){
		discussid=_xtable_CheckedCheckboxId();
		discussid=discussid.length>0?discussid.substr(0,discussid.length-1):discussid;
	}
	if(discussid==""){
		window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4040,language));
		return ;
	}
	window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4041,language),function(){
		jQuery.post("/cowork/CoworkOperation.jsp?method=logicDel", {discussid:discussid},function(data){
	    	if(type=="monitor")
	    	   _table. reLoad();
	    	else   
	    		toPage(1); 
	    });
	});
}

function doBatchDelComment(){
    var discussid=_xtable_CheckedCheckboxId();
    var language = readCookie('languageidweaver');
    if(discussid==""){
        window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4040,language));
        return ;
    }
    window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4041,language),function(){
        jQuery.post("/cowork/CoworkOperation.jsp?method=logicDel&isDelAll=false", {discussid:discussid},function(data){
               _table. reLoad();
        });
    });
}

function doBatchDelContent(){
    var discussid=_xtable_CheckedCheckboxId();
    var language = readCookie('languageidweaver');
    if(discussid==""){
        window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4040,language));
        return ;
    }
    var inhtml  = '<div class="deletedialog none-select">';
        inhtml += '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0" style="padding-top:20px"><tbody><tr><td align="right"><img id="Icon_undefined" src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td><td align="left" id="Message_undefined" style="font-size:9pt">'+SystemEnv.getHtmlNoteName(4041,language)+'</td></tr></tbody></table>';
        inhtml += '   <div class="isDelAll" style="padding-top:20px"><input type="checkbox" checked id="isDelAll" name="isDelAll"  />'+SystemEnv.getHtmlNoteName(4828,language)+'</div>';
        inhtml += '</div>';
        
    var diag = new window.top.Dialog();
    diag.Title = '信息确认';
    diag.Width = 280;
    diag.Height = 120;
    diag.normalDialog= false;
    diag.InnerHtml = inhtml;
    diag.OKEvent = function(){
       var isDelAll =$(window.top.document).find('#isDelAll').is(':checked');
         //确认要删除该讨论记录
          jQuery.post("/cowork/CoworkOperation.jsp?method=logicDel&isDelAll="+isDelAll,{discussid:discussid},function(data){
             if(jQuery.trim(data)=="0"){
                  _table. reLoad();
                 diag.close();
             }else if(jQuery.trim(data)=="1"){
                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26229,user.getLanguage())%>");
                  _table. reLoad();
                 jQuery(".operationTimeOut").hide();
              }else if(jQuery.trim(data)=="2"){   
                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131838,user.getLanguage())%>");
                 jQuery(".operationTimeOut").hide();
              }else if(jQuery.trim(data)=="3"){   
                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131836,user.getLanguage())%>");
                 jQuery(".operationTimeOut").hide();
              }
              
       }); 
     };
    diag.CancelEvent = function(){
        diag.close();
    };
        
    diag.show();    
    $(window.top.document).find(".deletedialog").jNice();
    
}

function doBatchApproveDiscuss(type){
	var language = readCookie('languageidweaver');
	var discussid=getCheckedIds();
	if(type=="monitor"){
		discussid=_xtable_CheckedCheckboxId();
		discussid=discussid.length>0?discussid.substr(0,discussid.length-1):discussid;
	}
	if(discussid==""){
		window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4074,language));
		return ;
	}
	window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4075,language),function(){
		
		jQuery.post("/cowork/CoworkOperation.jsp?method=doApproveDiscuss", {discussid:discussid},function(data){
	    	if(type=="monitor")
	    	   _table. reLoad();
	    	else   
	    		toPage(1); 
	    });
	});    
	
}

function batchDel(){
	var language = readCookie('languageidweaver');
	var coworkids=_xtable_CheckedCheckboxId();
	if(coworkids==""){
		window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4040,language));
		return;
	}
	coworkids=coworkids.substr(0,coworkids.length-1);
      var inhtml  = '<div class="deletedialog none-select">';
        inhtml += '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0" style="padding-top:20px"><tbody><tr><td align="right"><img id="Icon_undefined" src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td><td align="left" id="Message_undefined" style="font-size:9pt">'+SystemEnv.getHtmlNoteName(4041,language)+'</td></tr></tbody></table>';
        inhtml += '   <div class="isDelAll" style="padding-top:20px"><font color="red">'+SystemEnv.getHtmlNoteName(4827,language)+'</font></div>';
        inhtml += '</div>';
        
    var diag = new window.top.Dialog();
    diag.Title = '信息确认';
    diag.Width = 280;
    diag.Height = 120;
    diag.normalDialog= false;
    diag.InnerHtml = inhtml;
    diag.OKEvent = function(){
    		jQuery.post("/cowork/CoworkOperation.jsp?method=delcowork", {coworkids:coworkids},function(data){
    	    	_table. reLoad();
                diag.close();
    	    });
      };
    diag.CancelEvent = function(){
        diag.close();
    };
        
    diag.show();    
    $(window.top.document).find(".deletedialog").jNice();
}

function batchEnd(){
	var language = readCookie('languageidweaver');
	var coworkids=_xtable_CheckedCheckboxId();
	if(coworkids==""){
		window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4042,language));
		return;
	}
	coworkids=coworkids.substr(0,coworkids.length-1);
	window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4043,language),function(){
		jQuery.post("/cowork/CoworkOperation.jsp?method=endCowork", {coworkids:coworkids},function(data){
	    	_table. reLoad();; 
	    });
	});
}

function batchTop(){
	var language = readCookie('languageidweaver');
	var coworkids=_xtable_CheckedCheckboxId();
	if(coworkids==""){
		window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4044,language));
		return;
	}
	coworkids=coworkids.substr(0,coworkids.length-1);
	window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4045,language),function(){
		jQuery.post("/cowork/CoworkOperation.jsp?method=topCowork", {coworkids:coworkids},function(data){
	    	_table. reLoad();; 
	    });
	});
}

//取消收藏
function batchCancelCollect(id){
	var language = readCookie('languageidweaver');
	var coworkids = "";
	if(id != undefined && id != "") {
		coworkids = id + ",";
	} else {
		coworkids = _xtable_CheckedCheckboxId();
	}
    if(coworkids==""){
        window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4681 ,language));
        return;
    }
    coworkids=coworkids.substr(0,coworkids.length-1);
    window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4682,language),function(){
        jQuery.post("/cowork/CoworkOperation.jsp?method=cancelCollect", {coworkids:coworkids},function(data){
            _table. reLoad();; 
        });
    });
}

//获取选中的邮件ID
function getCheckedIds() {
	var checkids = new Array();
	jQuery("#discusses").find("input[name=discuss_check]:checked").each(function(){
		checkids.push($(this).val());
	});
	return checkids.toString();
}

function getCoworkDialog(title,width,height){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:680;	
	diag.Height =height?height:420;
	diag.ShowButtonRow=false;
	diag.Title = title;
	return diag;
} 

function changeOrderType(obj){
	
		$("div.tabMenu").find(".active").removeClass("active").addClass("normal");
		$(obj).addClass("active").removeClass("normal");
	
		var target=$(obj).attr("_target");
		
		jQuery("#recordType").val("");
		if(target=="#related"&&$.trim($("#related").html())==""){ //加载相关资源
			displayLoading(1);
			jQuery.post("/cowork/ViewCoWorkDiscussData.jsp?id="+coworkid,{},function(data){
				$(".tab_itemdiv").hide();
   				jQuery(target).html(data);
   				$(target).show();
   				displayLoading(0);
			});
		}else if(target=="#join"&&$.trim($("#join").html())==""){ //加载相关资源
			displayLoading(1);
			jQuery.post("/cowork/CoworkShareData.jsp?coworkid="+coworkid,{},function(data){
				$(".tab_itemdiv").hide();
   				jQuery(target).html(data);
   				$(target).show();
   				displayLoading(0);
			});
		}else if(target=="#relatedme"&&$.trim($("#relatedme").html())==""){ //加载与我相关
			jQuery("#recordType").val("relatedme");
			toPage(1);
			
			$(".tab_itemdiv").hide();
			$(target).show();
			$(obj).find("#remindimg").hide();
			//更新提醒
			jQuery.post("/cowork/CoworkOperation.jsp?method=updateremind&coworkid="+coworkid,{},function(data){});
		}else{
			$(".tab_itemdiv").hide();
			$($(obj).attr("_target")).show();
		}
		clearFixed();
}

function showRemark(obj){
	var _status = $(obj).attr("_status");
	var _hh = $("#remarkHtml").height()+16;
	if(_status==1){
		$("#remarkdiv").animate({height:0},300,null,function(){
			$(this).removeClass("remarkdiv_show_b")
		});
		$(obj).attr("_status",0).css("background-image","url('/cowork/images/icon_down_wev8.png')");
	}else{
		$("#remarkdiv").animate({height:'100%'},300,null,function(){}).addClass("remarkdiv_show_b");
		$(obj).attr("_status",1).css("background-image","url('/cowork/images/icon_up_wev8.png')");
	}
}

//显示缩略图
function showHead(showType){
   if(showType==1){
     jQuery(".userHeadTd").show(); 
     jQuery.post("/cowork/CoworkOperation.jsp?method=showHead&isCoworkHead=1",{},function(){
     });
   }else{
     jQuery(".userHeadTd").hide(); 
     jQuery.post("/cowork/CoworkOperation.jsp?method=showHead&isCoworkHead=0",{},function(){});
   }     
}

function removeHTMLTag(str) {
        str = str.replace(/<\/?[^>]*>/g,''); //去除HTML tag
        str = str.replace(/[ | ]*\n/g,'\n'); //去除行尾空白
        //str = str.replace(/\n[\s| | ]*\r/g,'\n'); //去除多余空行
        str=str.replace(/&nbsp;/ig,'');//去掉&nbsp;
        return str;
}

function showMenu(obj,target,e){
	$(".drop_list").hide();
	$("#"+target).css({
		"left":$(obj).position().left+"px",
		"top":($(obj).position().top+26)+"px"
	}).show();
	stopBubble(e);
}

function showHightSearch(obj,e){
	//clearFixed();
	var _status = $(obj).attr("_status");
	if(_status=="1"){
		$("#highSearchdiv").animate({height:0},200,null,function(){});
		$(obj).attr("_status","0");
	}else{
		$("#highSearchdiv").animate({height:$("#searchTable").height()+12},200,null,function(){});
		$(obj).attr("_status","1");
	}
	stopBubble();
}

function hideHightSearch(){
	var _status = $("#highsearchBtn").attr("_status");
	if(_status=="1"){
		showHightSearch($("#highsearchBtn"));
	}
}

//阻止事件冒泡函数
 function stopBubble()
 {
     if (event.stopPropagation){
         event.stopPropagation()
     }else{
         window.event.cancelBubble=true
     }
     
}

function showExtend(obj){
	var _status = $(obj).attr("_status");
	if(_status==1){
		$("#external").animate({height:0},200,null,function(){
			$("#external").hide();
		});
		$(obj).attr("_status",0).css("background-image","url('/cowork/images/blue/down_wev8.png')");
	}else{
		$("#external").show();
		$("#external").animate({height:$("#table1").height()},200,null,function(){
			
		});
		$(obj).attr("_status",1).css("background-image","url('/cowork/images/blue/up_wev8.png')");
	}
	hideHightSearch();
}

function hideExtend(){
	$("#external").animate({height:0},200,null,function(){});
	$("#extendbtn").attr("_status",0).css("background-image","url('/cowork/images/blue/down_wev8.png')");
}

//初始化导航
function initNav(){
	$(".navitem").hover(function(){
		$(this).find("div").show();
	},function(){
		$(this).find("div").hide();
	}).bind("click",function(){
		if($(this).hasClass("navitemt")){
		    $('body,html').animate({scrollTop:0},200);
		}else{
			$('body,html').animate({scrollTop:$('#footer').offset().top},200);
		}
	});
}

function moveToTop(){
	$('body,html').animate({scrollTop:0},200);
}

//初始化数字
function initNum(){
	$(".numitem").hover(function(){
		$(this).find(".numdiv").css("color","#fff");
		$(this).find(".numb").animate({height:30},150);
	},function(){
		var color=$(this).attr("_color");
		$(this).find(".numdiv").css("color",color);
		$(this).find(".numb").animate({height:0},150);
	});
}

//初始化选择框
function initCheckbox(){
	$(".check_item").bind("click",function(){
		if($(this).hasClass("normal")){
		   $(this).removeClass("normal").addClass("active");
		   
		   if($(this).attr("_target")=="#showHead"){
		   		showHead(1)
		   }else{
			   $($(this).attr("_target")).val(1);
			   toPage(1);
		   }
		}else{
		   $(this).removeClass("active").addClass("normal");
		   
		   if($(this).attr("_target")=="#showHead"){
		   		showHead(0)
		   }else{
			   	$($(this).attr("_target")).val("");
			   	toPage(1);
		   }
		}
	 });
}

//初始化remark
function initRemark(){
	$("#remarkContentdiv").bind("click",function(){
		   $("#operationdiv").animate({height:36},200,null,function(){});
		   $("#remarkContent").show();
           if(infostate==1){
             $(".extendbtn").click();
            }
		   $(this).hide();
		   highEditor("remarkContent");
		   hideHightSearch(); //隐藏高级搜索框
	}).hover(
		function(){
			  $(this).addClass("remarkContent_hover")
		},function(){
			  $(this).removeClass("remarkContent_hover")
		}
	);
}

//生成分页
function initPageInfo(pagerid,totalPage,pageNo){ 
	var language = readCookie('languageidweaver');
	kkpager.generPageHtml({
		pagerid:pagerid,
		pno : pageNo,
		total : totalPage, //总页码
		lang : {
			prePageText : '<',
			nextPageText : '>',
			gopageBeforeText : SystemEnv.getHtmlNoteName(4046,language),
			gopageButtonOkText : SystemEnv.getHtmlNoteName(3451,language),
			gopageAfterText : SystemEnv.getHtmlNoteName(3526,language),
			buttonTipBeforeText : SystemEnv.getHtmlNoteName(3525,language),
			buttonTipAfterText : SystemEnv.getHtmlNoteName(3526,language)
		},
		isShowTotalPage:false,
		isShowTotalRecords:false,
		isShowFirstPageBtn:false,
		isShowLastPageBtn:false,
		isGoPage:false,
		mode : 'click',//默认值是link，可选link或者click
		click : function(n){
			//alert(n);
			this.selectPage(n);
			toPage(n);
		    return false;
		}
	},true);
}

//提交回复时，提交等待
function displayLoading(state,flag){
  if(state==1){
  		var loadingHeight=jQuery("#loadingMsg").height();
	    var loadingWidth=jQuery("#loadingMsg").width();
	    jQuery("#loadingMsg").css({"top":document.body.clientHeight/2 - loadingHeight/2,"left":document.body.scrollLeft + document.body.clientWidth/2 - loadingWidth/2});
	    jQuery("#coworkLoading").show();
    }else{
        jQuery("#coworkLoading").hide();
    }
}

//全选
function selectAll(e){
	jQuery("#_xTable").find(".table input:checkbox").each(function(){
		$(this).next().addClass("jNiceChecked");
	});
	jQuery("#chkALL").attr("checked",true);
	stopBubble(e);
	return true;
}

//取消全选
function clearAll(){
	jQuery("#coworkList").contents().find("#list input:checkbox").attr("checked",false);
	jQuery("#chkALL").attr("checked",false);
	return true;
}

function clearFixed(){
	$("#fixeddiv").removeClass("fixeddiv");
	$('body,html').animate({scrollTop:0},200);
}

$(document).ready(function(){
	initNav();//初始化导航
	initCheckbox();//初始化选择框
	initRemark();//初始化remark
		
	$(document.body).bind("click",function(event){
		if($("#remarkContentdiv").is(":hidden")){
			//var remarkText=KE.html("remarkContent");
			if($(event.target).parents("#submitdiv").length==1||$(event.target).parents("#edui_fixedlayer").length==1) return; //提交区域内不隐藏输入框
			var editor=getEditor("remarkContent");
			var remarkText=editor.getContent();
			if(remarkText==""){
				
				$("#operationdiv").animate({height:0},200,null,function(){});
				
				//隐藏附加功能
				$("#external").animate({height:0},200,null,function(){});
				$("#extendbtn").attr("_status",0).css("background-image","url('/cowork/images/blue/down_wev8.png')");
				
				editor.destroy();
				$("#remarkContent").hide();
				$("#remarkContentdiv").show();
			}
		}
		
		//隐藏高级搜索
		if($(event.target).parents("#highSearchdiv").length!=1){ //搜索区域不隐藏
			$("#highSearchdiv").animate({height:0},200,null,function(){});
			$("#highsearchBtn").attr("_status","0");
		}
	});
	
	
	
	 $(window).scroll(function(){     
        var bodyTop = document.documentElement.scrollTop + document.body.scrollTop;             
        //当滚动条滚到一定距离时，执行代码  
        if(72<=bodyTop){
        	$("#fixeddiv").addClass("fixeddiv");
        }else{
        	//alert(2);
        	$("#fixeddiv").removeClass("fixeddiv");
        }
        //alert($("#operationdiv").offset().top);	
        if(bodyTop>600){
           $(".nav").show(500);
     	}else{
		   $(".nav").hide(500);     		
     	}
	 });
	
	 //选择框
	$("#chkALL").next().bind("click",function(event){
		
		if($(this).hasClass("jNiceChecked")){
			selectAll(event);
		}else{
			clearAll();
		}
		
	});
		

})

//阻止事件冒泡
function stopEvent() {
	if (event.stopPropagation) { 
		event.stopPropagation();
	} 
	else if (window.event) { 
		window.event.cancelBubble = true; 
	}
}








