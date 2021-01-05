function onSave(){
	if(operatelevel < 1) return;
	//if(check_form(frmMain,"uiname,uiType")){
		rightMenu.style.visibility = "hidden";
		
		$(".loading").show();
		
		if(isSourceShow){	//源码状态下进行保存
			setSource();
		}
		
		Mec_MoveContentFromBottomToEditor();
		
		
		var pageAttr = {};
		if($("#pageAttr_isDownRefresh").is(":checked")){
			var isDownRefresh = 1;
		}else{
			var isDownRefresh = 0;
		}
		pageAttr.isDownRefresh = isDownRefresh;
		
		var isDisabledSkin = $("#pageAttr_isDisabledSkin").is(":checked") ? "1" : "0";
		pageAttr.isDisabledSkin = isDisabledSkin;
		
		var onloadScript = $("#pageAttr_onloadScript").val();
		pageAttr.onloadScript = onloadScript;
		document.getElementById("pageAttr").value = encodeURIComponent(JSON.stringify(pageAttr));
		
		var pageMecJsonArr = MECHandlerPool.getPageMecJsonArr();
		var jsonstr = encodeURIComponent(JSON.stringify(pageMecJsonArr));
		$("#mecJsonStr").val(jsonstr);
		
		var content = encodeURIComponent($("#content_editor").html());
		document.getElementById("uicontent").value = content;
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=save");
		enableAllmenu();
		document.frmMain.submit();
	//}
}

function doInitContent(){
	var beOverride = isEmptyDesignContainer() ? "0" : "1";
	var initDlg = top.createTopDialog();//定义Dialog对象
	initDlg.Model = true;
	initDlg.Width = 900;//定义长度
	initDlg.Height = 600;
	initDlg.URL = "/mobilemode/setup/templateChoose.jsp?appHomepageId="+appHomepageId+"&type=1&beOverride="+beOverride;
	initDlg.Title = SystemEnv.getHtmlNoteName(4099); //初始化页面
	initDlg.show();
	initDlg.onCloseCallbackFn=function(result){
		refresh();
	};
}

function onInitContent(){
	doInitContent();
	return;
	rightMenu.style.visibility = "hidden";
	if(isEmptyDesignContainer()){
		doInitContent();
	}else{
		top.Dialog.confirm(SystemEnv.getHtmlNoteName(4101)+"<br/>"+SystemEnv.getHtmlNoteName(4102),function(){ //初始化会使用选择的模板内容覆盖当前页面的内容。<br/>确定继续吗？
			doInitContent();
		},function(){});
	}
}

function onInitLayout(){
	if(confirm(SystemEnv.getHtmlNoteName(4103))){ //初始化内容会覆盖当前页面的内容。确定继续吗？
		enableAllmenu();
		$(".loading").show();
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=initHomepageContent");
		document.frmMain.submit();
	}
}

function getContentFromMobile(){
	rightMenu.style.visibility = "hidden";
	if(isEmptyDesignContainer()){
		doGetContentFromMobile();
	}else{
		top.Dialog.confirm(SystemEnv.getHtmlNoteName(4104)+"<br/>"+SystemEnv.getHtmlNoteName(4102),function(){ //从Mobile获取的内容会覆盖当前页面的内容。<br/>确定继续吗？
			doGetContentFromMobile();
		},function(){});
	}
}

function onDelete(){
	if(confirm(SystemEnv.getHtmlNoteName(3580))) {  //确定要删除吗?
		enableAllmenu();
		$(".loading").show();
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=delete");
		document.frmMain.submit();
	}
}

function runEffect() {
	var selectedEffect = "blind";
	var options = {};
	if($("#draggable_center").is(":hidden")){
		$( "#draggable_center").show( selectedEffect, options, 100);
		$( "#button").attr("src","images/arrowdown_wev8.png");
	}else{
		$( "#draggable_center").hide( selectedEffect, options, 100);
		$( "#button").attr("src","images/arrowright_wev8.png");
	}
}

function onSaveAsTmp(){
	var tmpDlg = top.createTopDialog();//定义Dialog对象
	tmpDlg.Model = true;
	tmpDlg.Width = 720;//定义长度
	tmpDlg.Height = 400;
	tmpDlg.URL = "/mobilemode/setup/saveAsTmp.jsp?appHomepageId=" + appHomepageId;
	tmpDlg.Title = SystemEnv.getHtmlNoteName(3645); //存为模板
	tmpDlg.show();
	tmpDlg.onCloseCallbackFn=function(result){
	};
}

function onPreview(){
	rightMenu.style.visibility = "hidden";
	var url;
	if(_isHomePage == "1"){
		url = "/mobilemode/preview.jsp?appid=" + _appid;
	}else{
		url = "/mobilemode/preview.jsp?appHomepageId=" + appHomepageId;
	}
	
	if(_mobiledeviceid == "2"){
		url += "&clienttype=ipad";
	}
	
	url = "/mobilemode/H5Check.jsp?url=" + url;
	window.open(url);
}

function viewUrl(){
	rightMenu.style.visibility = "hidden";
	var url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + appHomepageId;
 	
	var viewUrlDlg = top.createTopDialog();//定义Dialog对象
	viewUrlDlg.Model = true;
	viewUrlDlg.Width = 650;//定义长度
	viewUrlDlg.Height = 215;
	viewUrlDlg.URL = "/mobilemode/setup/viewUrl.jsp?type=0&url="+url;
	viewUrlDlg.Title = _viewUrlTip;
	viewUrlDlg.normalDialog = false;
	viewUrlDlg.show();
}

function viewUrl2(){
	rightMenu.style.visibility = "hidden";
	var url;
	if(_isHomePage == "1"){
		url = "/mobilemode/appHomepageViewWrap.jsp?appid=" + _appid;
	}else{
		url = "/mobilemode/appHomepageViewWrap.jsp?appHomepageId=" + appHomepageId;
	}
	
	var viewUrlDlg = top.createTopDialog();//定义Dialog对象
	viewUrlDlg.Model = true;
	viewUrlDlg.Width = 650;//定义长度
	viewUrlDlg.Height = 215;
	viewUrlDlg.URL = "/mobilemode/setup/viewUrl.jsp?type=1&url="+url;
	viewUrlDlg.Title = _viewUrlPublic;
	viewUrlDlg.normalDialog = false;
	viewUrlDlg.show();
}

var mobiledeviceDlg;
function createMobiledevice(id){
	mobiledeviceDlg = top.createTopDialog();//定义Dialog对象
	mobiledeviceDlg.Model = true;
	mobiledeviceDlg.Width = 500;//定义长度
	mobiledeviceDlg.Height = 350;
	if(typeof(id)=='undefined'){
		id="";
	}
	mobiledeviceDlg.URL = "/mobilemode/mobiledevice.jsp?id="+id;
	mobiledeviceDlg.Title = SystemEnv.getHtmlNoteName(4105); //移动设备
	mobiledeviceDlg.onCloseCallbackFn=function(result){
		refreshMobiledevices();
	}
	mobiledeviceDlg.show();
}

/**
 * 刷新
 */
function refresh(){
	window.location.reload();
}

//刷新移动设备html
function refreshMobiledevices(){
	var mobiledeviceid=$("#mobiledeviceid").val();
	var parentid=$("#parentid").val();
	var ishomepage=$("#ishomepage").val();
	var appid=$("#appid").val();
	var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobiledeviceAction", "action=getDevicesHtml&mobiledeviceid"+mobiledeviceid+"&parentid="+parentid+"&ishomepage="+ishomepage+"&appid="+appid);
	FormmodeUtil.doAjaxDataLoad(url, function(devicesHtml){
		$("#mobiledevices").html(devicesHtml);
	});
}

//打开具体移动设备设计页面
function openUIDesign(id,parentid,mobiledeviceid){
	var ishomepage=$("#ishomepage").val();
	var url = 'appuidesign2.jsp?id='+id+"&parentid="+parentid+"&mobiledeviceid="+mobiledeviceid+"&ishomepage=" + ishomepage;
	location.href=url;
}
//最大化编辑器
function toggleDesignerSize(){
	var $topDoc=$(getTopDoc());
	if($("#imgToggle").attr("src").indexOf("t09_wev8.png")>=0){
		$topDoc.find("#headTable").height(0);
		$topDoc.find("#headTable").closest("tr").hide();
		$topDoc.find("#leftmenuTD").hide();
		$topDoc.find(".e8_leftToggle").hide();
		top.setFrameHeight();
		window.parent.Ext.getCmp("leftPanelModelTree").collapse(false);
		$("#imgToggle").attr("src", "images/toolbar/t10_wev8.png");
	}else{
		$topDoc.find("#headTable").height(90);
		$topDoc.find("#headTable").closest("tr").show();
		$topDoc.find("#leftmenuTD").show();
		$topDoc.find(".e8_leftToggle").show();
		top.setFrameHeight();
		window.parent.Ext.getCmp("leftPanelModelTree").expand(false);
		$("#imgToggle").attr("src", "images/toolbar/t09_wev8.png");
	}
}

function getTopDoc(){
	return top.window.document;
}

var _slideTime = 150;
function selectnav(obj,currRowIndex,mec_id,navfocus){
	
	//隐藏
	$("#navItemsPanel .searchPanel").html("");
	$("#navItemsPanel #nav_custom").val("");
	$("#navItemsPanel #nav_jscode").val("");
	$("#navItemsPanel .panel").hide();
	$("#navItemsPanel .nav_left li").removeClass("selected");
	$("#navItemsPanel .nav_main span").removeClass("sellabel");
	
	var $searchnavli = $("#navItemsPanel ul li[sourcetype='0']");
	$searchnavli.hide();
	
	var selectuid = $("#ui_"+currRowIndex+"_"+mec_id).val();
	var source_type = $("#source_"+currRowIndex+"_"+mec_id).val();
	var custom = $("#custom_"+currRowIndex+"_"+mec_id).val();
	var jscode = $("#jscode_"+currRowIndex+"_"+mec_id).val();
	
	var offset = $("#uiview_"+currRowIndex+"_"+mec_id).offset();
	var window_height = $(window).height();
	
	var oTop=document.body.scrollTop == 0 ?document.documentElement.scrollTop:document.body.scrollTop;
	
	var v_top = offset.top - oTop;
	var $sbt = $("#uiview_"+currRowIndex+"_"+mec_id).parent();
	var sb_hegiht = $sbt.height();
	var top = v_top + sb_hegiht + 2;
	var wHeight = $(window).height();
	var oo = wHeight - top;
	var hh = $("#navItemsPanel").outerHeight(true);
	if(oo < hh){
		top = v_top - hh - 2;
	}
	var left = 100;
	var ol = $(window).width()-offset.left;
	if(ol<300){
		left = left+300-ol+10;
	}
	$("#navItemsPanel").css("top",top+"px");
	$("#navItemsPanel").css("left",(offset.left-left)+"px");	
	$("#navItemsPanel").attr("mec_id",mec_id);
	$("#navItemsPanel").attr("currRowIndex",currRowIndex);
	var _source_type="";
	
	if(source_type==null||source_type==""){
		//添加选择源 source_type为空
		if(!$(obj).hasClass("sbToggle-btc-reverse")){
			$("#navItemsPanel").hide();
			$(".sbHolder a").removeClass("sbToggle-btc-reverse");
			$(obj).addClass("sbToggle-btc-reverse");
			var $navli = $("#navItemsPanel ul li[sourcetype='1']");
			var tHref = $navli.attr("href");
			var $showpanel = $("#navItemsPanel ."+tHref);
			$navli.addClass("selected");
			$showpanel.show();
			$("#navItemsPanel").slideDown(_slideTime);
			$("#uiview_"+currRowIndex+"_"+mec_id).select();
			$navmainScroll.show();
			$navmainScroll.resize();
		}else{
			$("#navItemsPanel").slideUp(_slideTime);
			$navmainScroll.hide();
			$(obj).removeClass("sbToggle-btc-reverse");
		}
		
	}else{
		//判断类型
		if(source_type==1){
			for(var i = 0; i < common_homepage_items.length; i++){
				var uiid = common_homepage_items[i]["uiid"];
				var uiname = common_homepage_items[i]["uiname"];
				if(selectuid == uiid){
					_source_type = 1;
					break;
				}
			}
			for(var i = 0; i < common_mec_nav_layoutpages.length; i++){
				var uiid = common_mec_nav_layoutpages[i]["uiid"];
				var uiname = common_mec_nav_layoutpages[i]["uiname"];
				if(selectuid == uiid){
					_source_type = 2;
					break;
				}
			}
			for(var i = 0; i < common_list_items.length; i++){
				var uiid = common_list_items[i]["uiid"];
				var uiname = common_list_items[i]["uiname"];
				if(selectuid == uiid){
					_source_type = 3;
					break;
				}
			}
			if(_source_type==""){
				_source_type = 1;
			}
		}else if(source_type==2){
			_source_type = 4;
		}else if(source_type==3){
			_source_type = 5;
		}
		
		if(!$(obj).hasClass("sbToggle-btc-reverse")){
			$("#navItemsPanel").hide();
			$(".sbHolder a").removeClass("sbToggle-btc-reverse");
			//未展开
			$(obj).addClass("sbToggle-btc-reverse");
			var $navli = $("#navItemsPanel ul li[sourcetype='"+_source_type+"']");
			var tHref = $navli.attr("href");
			var $showpanel = $("#navItemsPanel ."+tHref);
			$navli.addClass("selected");
			
			$showpanel.show();
			if(source_type==1){
				$("#"+selectuid).addClass("sellabel");
			}else if(source_type==2){
				$("#nav_custom").val(custom);
			}else if(source_type==3){
				$("#nav_jscode").val(jscode);
			}
			$("#navItemsPanel").slideDown(_slideTime);
			$("#uiview_"+currRowIndex+"_"+mec_id).select();
			var containerscroll = $("#navItemsPanel .nav_main");
		    var scrollTo = $("#"+selectuid);
		    if(scrollTo.length>0){
		    	containerscroll.scrollTop(scrollTo.offset().top - containerscroll.offset().top + containerscroll.scrollTop()-5);
		    }
			$navmainScroll.show();
			$navmainScroll.resize();
		}else{
			$("#navItemsPanel").slideUp(_slideTime);
			$navmainScroll.hide();
			$(obj).removeClass("sbToggle-btc-reverse");
		}
	}
	var e=event || window.event;
    if (e && e.stopPropagation){
        e.stopPropagation();    
    }else{
        e.cancelBubble=true;
    }
}

function nav_uiviewBind(currRowIndex,mec_id){
	var $uiview_input = $("#uiview_"+currRowIndex+"_"+mec_id);
	var selectuid = $("#ui_"+currRowIndex+"_"+mec_id).val();
	
	$uiview_input.bind('input propertychange',function(event){
		var currval = this.value.replace(/(^\s*)|(\s*$)/g, "");
		var obj = $(this).parent().find("a");
		var spanhtml = "";
		if(currval != null&&currval != ""){
			var spanhtml1 = "";
			var spanhtml2 = "";
			var spanhtml3 = "";
			for(var i = 0; i < common_homepage_items.length; i++){
				var _uiid = common_homepage_items[i]["uiid"];
				var _uiname = common_homepage_items[i]["uiname"];
				var tolow_uiname = _uiname.toLowerCase();
				var tolow_currval = currval.toLowerCase();
				var indexnum = tolow_uiname.indexOf(tolow_currval);
				if(indexnum > -1){
					var temp_currval = _uiname.substring(indexnum,indexnum+currval.length);
					var temp_uiname = _uiname.replace(new RegExp(temp_currval,"gm"),"<label style=\"color:black;background-color:rgba(255, 240, 120, 0.9);\">"+temp_currval+"</label>");
					spanhtml1 += "<span id=\""+_uiid+"\" value=\""+_uiname+"\">"+temp_uiname+"</span>"
				}
			}
			if(spanhtml1 !=""){
				spanhtml += "<label class=\"searchtypeline\">" + SystemEnv.getHtmlNoteName(4106) + "</label>";  //自定义页面
			}
			spanhtml += spanhtml1;
			
			for(var j = 0; j < common_mec_nav_layoutpages.length; j++){
				var _uiid = common_mec_nav_layoutpages[j]["uiid"];
				var _uiname = common_mec_nav_layoutpages[j]["uiname"];
				var tolow_uiname = _uiname.toLowerCase();
				var tolow_currval = currval.toLowerCase();
				var indexnum = tolow_uiname.indexOf(tolow_currval);
				if(indexnum > -1){
					var temp_currval = _uiname.substring(indexnum,indexnum+currval.length);
					var temp_uiname = _uiname.replace(new RegExp(temp_currval,"gm"),"<label style=\"color:black;background-color:rgba(255, 240, 120, 0.9);\">"+temp_currval+"</label>");
					spanhtml2 += "<span id=\""+_uiid+"\" value=\""+_uiname+"\">"+temp_uiname+"</span>"
				}
			}
			if(spanhtml2 !=""){
				spanhtml += "<label class=\"searchtypeline\">" + SystemEnv.getHtmlNoteName(4107) + "</label>"  //布局新建
			}
			spanhtml += spanhtml2;
			
			for(var k = 0; k < common_list_items.length; k++){
				var _uiid = common_list_items[k]["uiid"];
				var _uiname = common_list_items[k]["uiname"];
				var _ishide = common_list_items[k]["ishide"];
				if(_ishide == 1) continue;
				var tolow_uiname = _uiname.toLowerCase();
				var tolow_currval = currval.toLowerCase();
				var indexnum = tolow_uiname.indexOf(tolow_currval);
				if(indexnum > -1){
					var temp_currval = _uiname.substring(indexnum,indexnum+currval.length);
					var temp_uiname = _uiname.replace(new RegExp(temp_currval,"gm"),"<label style=\"color:black;background-color:rgba(255, 240, 120, 0.9);\">"+temp_currval+"</label>");
					spanhtml3 += "<span id=\""+_uiid+"\" value=\""+_uiname+"\">"+temp_uiname+"</span>"
				}
			}
			if(spanhtml3 !=""){
				spanhtml += "<label class=\"searchtypeline\">" + SystemEnv.getHtmlNoteName(4108) + "</label>"; //布局列表
			}
			spanhtml += spanhtml3;
			
			$("#navItemsPanel .nav_left li").removeClass("selected");
			$("#navItemsPanel .nav_main .panel").hide();
			
			var $navli = $("#navItemsPanel ul li[sourcetype='0']");
			$navli.show();
			$navli.addClass("selected");
			if(spanhtml==""){
				spanhtml = "<label style=\"float: left;font-size: 12px;color: #016ee3;padding: 5px 8px;margin: 0px 5px 5px 0px;border: 0;\">" + SystemEnv.getHtmlNoteName(4109) + "</label>" //没有查询结果
			}
			
			$("#navItemsPanel .searchPanel").html(spanhtml).show();
			$("#navItemsPanel").slideDown(_slideTime);
			$navmainScroll.show();
			$navmainScroll.resize();
			
			$("#navItemsPanel .searchPanel span").on("click", function(){
				$("#navItemsPanel .nav_main span").removeClass("sellabel");
				$(this).addClass("sellabel");
				var uiid = $(this).attr("id");
				var unname = $(this).attr("value");
				var mec_id = $("#navItemsPanel").attr("mec_id");
				var currRowIndex = $("#navItemsPanel").attr("currRowIndex");
				$("#ui_"+currRowIndex+"_"+mec_id).val(uiid);
				$("#source_"+currRowIndex+"_"+mec_id).val(1);
				$("#uiview_"+currRowIndex+"_"+mec_id).val(unname);
				$("#navItemsPanel").slideUp(_slideTime);
				$navmainScroll.hide();
				$("#ui_"+currRowIndex+"_"+mec_id).parent().find("a").removeClass("sbToggle-btc-reverse");
			});
		}else{
			spanhtml = "<label style=\"float: left;font-size: 12px;color: #016ee3;padding: 5px 8px;margin: 0px 5px 5px 0px;border: 0;\">" + SystemEnv.getHtmlNoteName(4109) + "</label>" //没有查询结果
			$("#navItemsPanel .searchPanel").html(spanhtml);
		}
		var e=event || window.event;
	    if (e && e.stopPropagation){
	        e.stopPropagation();    
	    }else{
	        e.cancelBubble=true;
	    }
	});
}

function nav_stopEventClink(obj,currRowIndex,mec_id){
	var $aobj = $(obj).parent().find("a");
	selectnav($aobj,currRowIndex,mec_id,"navfocus");
}

function nav_closePanel(){
	var mec_id = $("#navItemsPanel").attr("mec_id");
	var currRowIndex = $("#navItemsPanel").attr("currRowIndex");
	var source_type = $("#source_"+currRowIndex+"_"+mec_id).val();
	var custom = $("#custom_"+currRowIndex+"_"+mec_id).val();
	var jscode = $("#jscode_"+currRowIndex+"_"+mec_id).val();
	if(source_type==1){
		var ui_id = $("#ui_"+currRowIndex+"_"+mec_id).val();
		$("#uiview_"+currRowIndex+"_"+mec_id).val(getCommonNavNameByUid(ui_id));
	}else if(source_type==2){
		$("#uiview_"+currRowIndex+"_"+mec_id).val(custom);
	}else if(source_type==3){
		$("#uiview_"+currRowIndex+"_"+mec_id).val(SystemEnv.getHtmlNoteName(4634)); //脚本
	}else{
		$("#uiview_"+currRowIndex+"_"+mec_id).val("");
	}
	$("#ui_"+currRowIndex+"_"+mec_id).parent().find("a").removeClass("sbToggle-btc-reverse");
	$("#navItemsPanel").slideUp(_slideTime);
	$navmainScroll.hide();
}

function nav_customSave(){
	var customurl = $("#nav_custom").val();	
	var mec_id = $("#navItemsPanel").attr("mec_id");
	var currRowIndex = $("#navItemsPanel").attr("currRowIndex");
	$("#source_"+currRowIndex+"_"+mec_id).val(2);
	$("#custom_"+currRowIndex+"_"+mec_id).val(customurl);
	$("#uiview_"+currRowIndex+"_"+mec_id).val(customurl);
	$("#ui_"+currRowIndex+"_"+mec_id).parent().find("a").removeClass("sbToggle-btc-reverse");
	$("#navItemsPanel").slideUp(_slideTime);
	$navmainScroll.hide();
	
}
function nav_jscodeSave(obj){
	var jscode = $("#nav_jscode").val();
	var mec_id = $("#navItemsPanel").attr("mec_id");
	var currRowIndex = $("#navItemsPanel").attr("currRowIndex");
	$("#source_"+currRowIndex+"_"+mec_id).val(3);
	$("#jscode_"+currRowIndex+"_"+mec_id).val(jscode);
	$("#uiview_"+currRowIndex+"_"+mec_id).val(SystemEnv.getHtmlNoteName(4634));  //脚本
	$("#ui_"+currRowIndex+"_"+mec_id).parent().find("a").removeClass("sbToggle-btc-reverse");
	$("#navItemsPanel").slideUp(_slideTime);
	$navmainScroll.hide();
}

function getCommonNavNameByUid(uid){
	for(var i = 0; i < common_mec_nav_items.length; i++){
		var _uiid = common_mec_nav_items[i]["uiid"];
		var _uiname = common_mec_nav_items[i]["uiname"];
		if(uid == _uiid){
			return _uiname;
		}
	}
}

function formatNumber(num, pattern) {
	var vprefix = "";
	var vsuffix = "";
	var m = /^\[(.*?)\]/.exec(pattern);//获取开头[]
	if(m) {
		vprefix = m[1];
	}				
	m = /.*\[([^\]]*)\]$/.exec(pattern);
	if(m) {
		vsuffix = m[1];
	}
	if(vprefix.length > 0 && vprefix == vsuffix){
		var pstr = pattern.substring(1,pattern.length - 1);
		if(vsuffix == pstr) vprefix = "";
	}
	pattern = pattern.replace(/\[.*?\]/g,'');//去除所有中括号及内容
    if (!isNaN(parseFloat(num)) && isFinite(num) && pattern.length > 0) {
		var comma = false;  
		if(pattern.indexOf("#,##") != -1) comma = true;  				
		var fmtarr = pattern ? pattern.split('.') : [''];
		var precision = -1;
		if(fmtarr.length > 1){
			if(fmtarr[1].length > 0 && fmtarr[1].match(/0/g)){
				precision = fmtarr[1].match(/0/g).length;
			}else{
				precision = 0;
			}
		}
		var parts;
        num = Number(num);
	    num = (precision !== -1 ? num.toFixed(precision) : num).toString(); 
        parts = num.split('.');
        if(comma){
	        parts[0] = parts[0].toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1' + (','));
        }
        num = parts.join('.');
    }
    return vprefix + num + vsuffix;
}  
