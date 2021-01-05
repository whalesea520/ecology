function changeChildField(obj, fieldid, childfieldid){
	var multiselectflag="0";
	if(dataArray["multiselectid"].indexOf(fieldid)>-1){
		multiselectflag="1";
	}
	var customid = jQuery("#customid").val();
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value+"&isSearch=1&customid="+customid+"&multiselectflag="+multiselectflag+"&multiselectvalue="+jQuery("#multiselectValue_con"+fieldid+"_value").val();
    $G("selectChange_"+fieldid).src = "/formmode/search/SelectChange.jsp?"+paraStr;
}

function lazyLoadBrowser(){
	var url = "/formmode/search/LazyLoadBrowserOperation.jsp";
	jQuery(".lazyloadboreser").each(function(){
		var $this = jQuery(this);
		var lazyfieldtype = $this.attr("lazyfieldtype");
		var lazydbtype = $this.attr("lazydbtype");
		var lazyid = $this.attr("lazyid");
		var id = $this.attr("id");
		 jQuery.ajax({
         	url : url,
         	type : "post",
         	processData : false,
         	data : "lazyfieldtype="+lazyfieldtype+"&lazydbtype="+lazydbtype+"&lazyid="+lazyid+"&id="+id,
         	dataType : "json",
         	async : true,
         	success: function do4Success(data){
         		var htmlid = data.id;
         		jQuery("#"+htmlid).html(data.href);
         	}
     });

	});
}
function changeDateType(obj,spanid,dateid,datespan,dateid1,datespan1){
   if(jQuery(obj).val()=='6'){
      jQuery("#"+spanid).css("display","inline");
   }else{
      jQuery("#"+spanid).css("display","none");
   }
   if(obj.value=="0"){
		jQuery("#"+dateid).val("");
		jQuery("#"+datespan).html("");
		jQuery("#"+dateid1).val("");
		jQuery("#"+datespan1).html("");
	}else if(obj.value=="1"){
		jQuery("#"+dateid).val(getTodayDate());
		jQuery("#"+datespan).html(getTodayDate());
		jQuery("#"+dateid1).val(getTodayDate());
		jQuery("#"+datespan1).html(getTodayDate());
	}else if(obj.value=="2"){
		jQuery("#"+dateid).val(getWeekStartDate());
		jQuery("#"+datespan).html(getWeekStartDate());
		jQuery("#"+dateid1).val(getWeekEndDate());
		jQuery("#"+datespan1).html(getWeekEndDate());
	}else if(obj.value=="3"){
		jQuery("#"+dateid).val(getMonthStartDate());
		jQuery("#"+datespan).html(getMonthStartDate());
		jQuery("#"+dateid1).val(getMonthEndDate());
		jQuery("#"+datespan1).html(getMonthEndDate());
	}else if(obj.value=="7"){//上个月
		jQuery("#"+dateid).val(getLastMonthStartDate());
		jQuery("#"+datespan).html(getLastMonthStartDate());
		jQuery("#"+dateid1).val(getLastMonthEndDate());
		jQuery("#"+datespan1).html(getLastMonthEndDate());
	}else if(obj.value=="4"){
		jQuery("#"+dateid).val(getQuarterStartDate());
		jQuery("#"+datespan).html(getQuarterStartDate());
		jQuery("#"+dateid1).val(getQuarterEndDate());
		jQuery("#"+datespan1).html(getQuarterEndDate());
	}else if(obj.value=="5"){
		jQuery("#"+dateid).val(getYearStartDate());
		jQuery("#"+datespan).html(getYearStartDate());
		jQuery("#"+dateid1).val(getYearEndDate());
		jQuery("#"+datespan1).html(getYearEndDate());
	}else if(obj.value=="8"){//上一年
		jQuery("#"+dateid).val(getLastYearStartDate());
		jQuery("#"+datespan).html(getLastYearStartDate());
		jQuery("#"+dateid1).val(getLastYearEndDate());
		jQuery("#"+datespan1).html(getLastYearEndDate());
	}else if(obj.value=="6"){
		jQuery("#"+dateid).val("");
		jQuery("#"+datespan).html("");
		jQuery("#"+dateid1).val("");
		jQuery("#"+datespan1).html("");
	}
}

function getAllExcelOut(){ 
	jQuery.ajax({
		url : "/formmode/view/checkExcel.jsp?optype=exp",
		type : "post",
		dataType : "json",
		success: function do4Success(data){
			if(data){
				var msg = data.msg;
				if(msg==""){
					var customid = jQuery("#customid").val();
					var tmpurl='/weaver/weaver.formmode.excel.ExpExcelServer?showOrder=all&iscustomsearch=1&comefrom=frommode&modeCustomid='+customid;
					window.location=tmpurl;
				}else{
					Dialog.alert(msg);
				}
			}
		}
	});
}

function changeChildSelectItemField(obj, fieldid, childfieldid,isinit){
	if(isinit&&isinit==1){//编辑时初始化
		obj = $G("con"+fieldid+"_value");
	}
	if(!obj){
		obj = $G("con"+fieldid+"_value");
	}
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    if(isinit&&isinit==1){
    	paraStr = paraStr + "&isinit="+isinit;
    }
    var iframe = jQuery("#selectChange_"+fieldid);
    if(iframe.length==0){
    	iframe = jQuery("#selectChange");
    }
    iframe.get(0).src = "/formmode/search/SelectItemChangeByQuery.jsp?"+paraStr;
}

function nextSelectRefreshMultiSelect(selectid){
	var tmpmsv = jQuery("#"+selectid).multiselect("getChecked").map(function(){return this.value;}).get();
	jQuery("#multiselectValue_"+selectid).val(tmpmsv.join(","));
	jQuery("#"+selectid).val(jQuery("#multiselectValue_"+selectid).val().split(","));
	jQuery("#"+selectid).multiselect("refresh");
}

function resetDate(){
    jQuery("#advancedSearchDiv td[class='field'] select[id^='datetype_'][ishide!='1']").each(function(){
    	jQuery(this).val("6").change();
    	jQuery(this).closest("td").find("a[class='sbSelector']").html(dataArray["32530"]);
    })
}

function resetSplitPageWidth(){
	//所有列的宽度之和大于100时，重新计算宽度
	var splitPageContiner = $("#splitPageContiner");
	var width = splitPageContiner.width();
	jQuery("#pageWidth").val(width);
	if( dataArray["sumColWidth"]> 100 ) {
		var newwidth = Math.round(dataArray["allSumWidthFix"]*width/100);
		if(newwidth > width){
			splitPageContiner.width(newwidth);
		}
	}
}

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowFormWorkFlow(inputname, spanname) {
	var customid = jQuery("#customid").val();
	var formid = jQuery("#formid").val();
	var tmpids = $G(inputname).value;
	var url = uescape("?customid="+customid+"&value=1_"+formid+"_"+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"+ url;
	disModalDialogRtnM(url, inputname, spanname);
}

function onShowCQWorkFlow(inputname, spanname) {
	var customid = jQuery("#customid").val();
	var formid = jQuery("#formid").val();
	var tmpids = $G(inputname).value;
	var url = uescape("?customid="+customid+"&value=1_"+formid+"_"+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"+ url;
	disModalDialogRtnM(url, inputname, spanname);
}



function submitData()
{
	setSearchName(parent);
	frmmain.submit();
}

function setSapNameBeforeSearch(){
	var sapbrowser_name = $(".sapbrowser_name");
	for(var i=0;i<sapbrowser_name.length;i++){
		var name = $(sapbrowser_name[i]);
		var cid = name.attr("cid");
		name.val($("#con"+cid+"_value").val());
	}
}

function setSearchName(_parent) {
	setSapNameBeforeSearch();
	var searchNameValue="";
    if (_parent){
    	searchNameValue=_parent.document.getElementById("searchName").value;
    }else {
    	searchNameValue=document.getElementById("searchName").value;
    }
    document.frmmain.searchMethod.value = "0";//普通查询
    jQuery("#searchkeyname").val(searchNameValue);
    multselectSetValue();
}


function clearSearchName() {
	document.getElementById("searchkeyname").value = "";
	parent.document.getElementById("searchName").value = "";
}

function BatchImport(detailid){
	var formmodeid = jQuery("#formmodeid").val();
	window.open("/formmode/interfaces/ModeDataBatchImport.jsp?ajax=1&modeid="+formmodeid+"&pageexpandid="+detailid);
}

function batchShare(){
    var billids = _xtable_CheckedCheckboxId();
    if(billids==""){
    	alert(dataArray["20149"]);//请至少选择一条记录。
        return;
    }
    var customid = jQuery("#customid").val();
	var formid = jQuery("#formid").val();
	var formmodeid = jQuery("#formmodeid").val();
    document.frmmain.action="/formmode/view/ModeShareAddMore.jsp?customid="+customid+"&modeId="+formmodeid+"&formId="+formid+"&billids="+billids;
    document.frmmain.submit();
}


function columnMake(){
	var dialogurl = '/formmode/search/CustomSearchColumnMake.jsp';
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.Title = dataArray["32535"];
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();
}


function Del(detailid){
	var CheckedCheckboxId = _xtable_CheckedCheckboxId();
	if(CheckedCheckboxId!=""){
		var isDel = jQuery("#isDel").val(); 
		if(isDel=="true"){
			window.top.Dialog.confirm(dataArray["7"],function(){
				$G("method").value = "del";
				$G("pageexpandid").value=detailid;
				$G("deletebillid").value = CheckedCheckboxId;
				frmmain.submit();
			});
		}
	}else{
		Dialog.alert(dataArray["20149"]);//请至少选择一条记录。
	}
}


function submitClear()
{
	btnclear_onclick();
}
function onSearchWFQTDate(spanname,inputname,inputname1){
	var oncleaingFun = function(){
		  $(spanname).innerHTML = '';
		  inputname.value = '';
		}
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(inputname).value = returnvalue;
			},oncleared:oncleaingFun});
}

function onSearchWFQTTime(spanname,inputname,inputname1){
    var dads  = document.all.meizzDateLayer2.style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop;
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft;
	var ttyp  = spanname.type;
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop;
		tleft += spanname.offsetLeft;
	}
	var t = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.top = t+"px";
	dads.left = tleft+"px";
	$(document.all.meizzDateLayer2).css("z-index",99999);
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
    CustomQuery=1;
    outValue1 = inputname1;
}
function uescape(url){
    return escape(url);
}
function mouseover(){
	this.focus();
}

function openHrefWithChinese(url){
    url = dealChineseOfFieldParams(url);
    window.open(url);
}

function modeopenFullWindowHaveBar(url,obj){
    url = dealChineseOfFieldParams(url);
	$("[id=span"+obj+"]").remove();
	if(dataArray["mainid"] > 0){
		if(url.indexOf("?")!=-1){
			url = url +"&mainid="+dataArray["mainid"];
		}else{
			url = url +"?mainid="+dataArray["mainid"];
		}
	}

	if(dataArray["customTreeDataId"]&&dataArray["customTreeDataId"]!="null"){
		if(url.indexOf("?")!=-1){
			url = url +"&customTreeDataId="+dataArray["customTreeDataId"];
		}else{
			url = url +"?customTreeDataId="+dataArray["customTreeDataId"];
		}
	}
	url = url.replace(/\+/g,"%2B");
	openFullWindowHaveBar(url);
}



function modeopenFullWindowHaveBarForWFList(url,requestid,obj){
	$("[id=span"+obj+"]").remove();
	openFullWindowHaveBarForWFList(url,requestid);
}

function dealChineseOfFieldParams(url){
	if(url.indexOf("/workflow/request/AddRequest.jsp")==-1 && url.indexOf("/formmode/view/AddFormMode.jsp") != 0) {
		return url;
	}
	var params = "";
	var path = url.substring(0,url.indexOf("?")+1);
	var filedparams = url.substring(url.indexOf("?")+1);
	var fieldparam = filedparams.split("&");
	 for(var i=0;i<fieldparam.length;i++) {
		var tmpindex = fieldparam[i].indexOf("=");
		if(tmpindex != -1) {
			var key = fieldparam[i].substring(0, tmpindex);
			var value = encodeURIComponent(fieldparam[i].substring(tmpindex+1));
			params+="&"+key+"="+value
		}
	} 
	return path+params.substring(1);
}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
		var objname = spanobj.id.replace("_valuespan","_name");
		$G(objname).value = spanobj.innerHTML;
	}
}



function onShowBrowser(id,url) {
	var url = url + "?selectedids=" + $G("con" + id + "_value").value;
	disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
	$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;
}

function setName(id) {
	var name = $("#con"+id+"_valuespan a").text();
	$G("con" + id + "_name").value = name;
}

function onShowBrowserCustom(id, url, type1, funFlag) {
	var urltemp = url;
	var tmpids = $G("con" + id + "_value").value;
	url = url + "|" + id + "&beanids=" + tmpids;
	url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
	url+="&iscustom=1";
	if(type1==256||type1==257){
		url = urltemp+"&selectedids="+tmpids;
	}
	var id1 = window.showModalDialog(url, window, 
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				if(href==''){
					$G("con" + id + "_valuespan").innerHTML = "<a title='" + descs + "'>" + names + "</a>&nbsp";
					$G("con" + id + "_name").value = "<a title='" + descs + "'>" + names + "</a>&nbsp";
				}else{
					$G("con" + id + "_valuespan").innerHTML = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
					$G("con" + id + "_name").value = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
				}
				//$G("con" + id + "_valuespan").innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
				$G("con" + id + "_value").value = ids;
				//$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				var sHtml = "";
				names = names.substr(0);
				descs = descs.substr(0);

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}
					if(href==''){
						sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
					}else{
						sHtml += "<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp";
					}
					//sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				}
				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				//$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
				$G("con" + id + "_name").value = sHtml;
			}
			if (type1 == 256||type1==257) {
				var sHtml = "";
				sHtml = names;
				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = sHtml;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
		hoverShowNameSpan(".e8_showNameClass");
	}
}


function onShowBrowserCustomNew(id, url, type1) {
	
	if (type1 == 256|| type1==257) {
		url+="&iscustom=1";
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
	}else{
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0,url.indexOf("?")+1)+"iscustom=1&"+url.substring(url.indexOf("url="), url.indexOf("url=") + 4) + encodeURI(url.substr(url.indexOf("url=") + 4));
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				var href = "";
				if(id1.href&&id1.href!=""){
					href = id1.href+ids;
				}else{
					href = "";
				}
				var hrefstr="";
				if(href!=''){
					hrefstr=" href='"+href+"' target='_blank' ";
				}
				names = names.replace(new RegExp(/(<)/g),"&lt;")
        	    names = names.replace(new RegExp(/(>)/g),"&gt;")
				var sHtml = "<a "+hrefstr+"  title='" + names + "'>" + names + "</a>";
				$G("con" + id + "_valuespan").innerHTML = wrapshowhtml(sHtml,ids,1);
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = sHtml;
			}
			if (type1 == 162) {
				var href = wuiUtil.getJsonValueByIndex(id1,3);
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");
				var showname = "";
				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}
					curname = curname.replace(new RegExp(/(<)/g),"&lt;")
        		    curname = curname.replace(new RegExp(/(>)/g),"&gt;")
					showname += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
					if(href==""){
						sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}else{
						sHtml +=  wrapshowhtml("<a href='"+href+curid+"' title='" + curdesc + "' target='_blank' >" + curname + "</a>&nbsp",curid,1);
					}
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = showname;
			}
			if (type1 == 256||type1 == 257) {
				var idArray = ids.split(",");
        	    var nameArray = names.split(">,");
        	    var sHtml = "";
        	    var showname = "";
        	    for (var _i=0; _i<idArray.length; _i++) {
				   var curid = idArray[_i];
				   var curname = (idArray.length-1==_i) ? nameArray[_i] : nameArray[_i] + ">";
				   showname += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				   sHtml += wrapshowhtml( curname + "&nbsp", curid,1);
			    }
				$G("con" + id + "_valuespan").innerHTML =  sHtml ;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = showname;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
		
	hoverShowNameSpan(".e8_showNameClass");
	   
	};
	
	dialog.Title = dataArray["18214"];//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();

}


function onShowBrowser1(id,url,type1) {
	if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con" + id + "_valuespan").innerHTML = id1;
		$G("con" + id + "_value").value=id1
	} else if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}

function onShowBrowser2(id, url, type1) {
	var tmpids = "";
	var id1 = null;
	if (type1 == 8) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
	} else if (type1 == 9) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if (type1 == 1) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 4) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?selectedids=" + tmpids
				+ "&resourceids=" + tmpids);
	} else if (type1 == 16) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 7) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 142) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	if (id1 != null) {
		resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
		resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G("con" + id + "_valuespan").innerHTML = resourcename;
			jQuery("input[name=con" + id + "_value]").val(resourceids);
			jQuery("input[name=con" + id + "_name]").val(resourcename);
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
}

function onShowMutiHrm(spanname, inputename) {
	tmpids = $G(inputename).value;
	id1 = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G(inputename).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for ( var i = 0; i < resourceidArray.length(); i++) {
				var curid = resourceidArray[i];
				var curname = resourcenameArray[i];
				sHtml = sHtml + curname + "&nbsp";
			}

			$G(spanname).innerHTML = sHtml;
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = true;
			} else {
				$G("flownextoperator")[0].checked = false;
				$G("flownextoperator")[1].checked = true;
			}
		} else {
			$G(spanname).innerHTML = "";
			$G(inputename).value = "";
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = false;
			} else {
				$G("flownextoperator")[0].checked = true;
				$G("flownextoperator")[1].checked = false;
			}
		}
	}
}


function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearchBySimple.jsp";
				$G("frmmain").submit();
			}
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
			$G("frmmain").action = "WFSearch.jsp";
			$G("frmmain").submit();

		}
	}
}

function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0);
			var names = wuiUtil.getJsonValueByIndex(id, 1);
			
			if (ids.indexOf(",") == 0) {
				ids = ids.substr(1);
				names = names.substr(0);
			}
			$G(inputname).value = ids;
			var sHtml = "";
			
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {
				var curid = ridArray[i];
				var curname = rNameArray[i];
				if (i != ridArray.length - 1) sHtml += curname + "，"; 
				else sHtml += curname;
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

function clickThisDate(obj){
	var checked = obj.checked; 
	jQuery("input[name='thisdate']").attr("checked",false);
	obj.checked = checked;
	frmmain.submit();
}
function clickThisOrg(obj){
	var checked = obj.checked; 
	jQuery("input[name='thisorg']").attr("checked",false);
	obj.checked = checked;
	frmmain.submit();
}
function quickSearchDate(index){
	jQuery("input[name='thisdate']").attr("checked",false);
	jQuery("input[name='thisdate']")[index-1].checked=true;
	frmmain.submit();
}
function quickSearchOrg(index){
	jQuery("input[name='thisorg']").attr("checked",false);
	jQuery("input[name='thisorg']")[index-1].checked=true;
	frmmain.submit();
}
function clickEnabled(obj){
	var checked = obj.checked; 
	jQuery("input[name='enabled']").attr("checked",false);
	obj.checked = checked;
	frmmain.submit();
}
function doCustomFunction(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,doCustomFunctionCallBack,detailid);
}

function doCustomFunctionCallBack(detailid){
	_table.reLoad();
    eval(eval("url_id_"+detailid));
}

function windowOpenOnSelf(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,windowOpenOnSelfCallBack,detailid);
}

function windowOpenOnSelfCallBack(detailid){
	_table.reLoad();
   	var url = eval("url_id_"+detailid);
	parent.location.href = url;
}

function windowOpenOnNew(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,windowOpenOnNewCallBack,detailid);
}

function batchmodifyfeildvalue(detailid,hrefid){
	var CheckedCheckboxId = _xtable_CheckedCheckboxId();
	if(CheckedCheckboxId==""){
		Dialog.alert(dataArray["20149"]);//请至少选择一条记录。
		return;
	}
	var dialogurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/setup/batchmodifyfeildvalue.jsp?id="+hrefid+"&detailid="+detailid+"&billids="+CheckedCheckboxId);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();
}

function windowOpenOnNewCallBack(detailid){
	_table.reLoad();
	var redirectUrl = eval("url_id_"+detailid);
    var width = screen.availWidth-10 ;
    var height = screen.availHeight-50 ;
    var szFeatures = "top=0," ;
	   	szFeatures +="left=0," ;
    szFeatures +="width="+width+"," ;
    szFeatures +="height="+height+"," ;
    szFeatures +="directories=no," ;
    szFeatures +="status=yes,toolbar=no,location=no," ;
    szFeatures +="menubar=no," ;
    szFeatures +="scrollbars=yes," ;
    szFeatures +="resizable=yes" ; //channelmode
    window.open(redirectUrl,"",szFeatures) ;
}


//执行接口动作
function doInterfacesAction(detailid,issystemflag,callBackFun,param1){
	var CheckedCheckboxId = _xtable_CheckedCheckboxId();
	if(CheckedCheckboxId!=""){
		var CheckedCheckboxIds = CheckedCheckboxId.split(",");
		var formmodeid = jQuery("#formmodeid").val();
		var formid = jQuery("#formid").val();
		for(var i=0;i<CheckedCheckboxIds.length;i++){
			var billid = CheckedCheckboxIds[i];
			if(billid==""){
				continue;
			}
			var url = "/formmode/data/ModeDataInterfaceAjax.jsp";
			jQuery.ajax({
				url : url,
				type : "post",
				processData : false,
				data : "pageexpandid="+detailid+"&modeid="+formmodeid+"&formid="+formid+"&billid="+billid,
				dataType : "text",
				async : true,//
				success: function do4Success(msg){
					
				}
			});
		}
	}
	
	if(typeof(callBackFun)=="function"){
		if(param1){
			callBackFun(param1);
		}else{
        	callBackFun();
		}
		return true;
	}
}

function onChangeTemplate(obj) {
	document.frmmain.action = "/formmode/search/CustomSearchBySimpleIframe.jsp?"+dataArray["tempquerystring"];
	document.frmmain.templateid.value = obj.value;
	document.frmmain.searchMethod.value = "1";//模板查询
	document.frmmain.submit();
}

function templateManage(sourcetype){
	var customid = jQuery("#customid").val();
	window.open("/formmode/template/TemplateManage.jsp?customid="+customid+"&sourcetype="+sourcetype);
}


var diag_vote;
function onSaveTempalte(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 360;
	diag_vote.Height = 150;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	//模板管理
	diag_vote.Title = dataArray["16388"];//新建模板
	diag_vote.maxiumnable = true;
	var customid = jQuery("#customid").val();
	diag_vote.URL = "/formmode/template/CreateTemplate.jsp?"+dataArray["tempquerystring"]+"&flag=true&isdialog=1&customid="+customid+"&sourcetype=2";
	diag_vote.show();
}

function onSaveTempalte2(){
	multselectSetValue();
	document.frmmain.method.value="saveTemplateValue";
	document.frmmain.action = "/formmode/template/SaveTemplateOperation.jsp?"+dataArray["tempquerystring"]+"&flag=true&sourcetype=2&returnType=2";
	document.frmmain.submit();
}

function closeDlgARfsh(templateid){
	diag_vote.close();
	if (templateid) {
		multselectSetValue();
		document.frmmain.templateid.value=templateid;
		document.frmmain.method.value="saveTemplateValue2";
	    document.frmmain.action = "/formmode/template/SaveTemplateOperation.jsp?"+dataArray["tempquerystring"]+"&flag=true&sourcetype=2";
		document.frmmain.submit();
	}
}

function change_con_name(e,json,name,_callbackParams){
	$("input[name='con"+_callbackParams+"_name']").val(json.name);
}
function change_multiselectValue_con_value(id,val){
	$("input[name='multiselectValue_con"+id+"_value']").val(val);
}

function mapdisabled(){
	jQuery(".mapimage").attr("src","/formmode/images/mapunuse.png");
	jQuery(".mapimage").attr("title",dataArray["127295"]);
}
function showFormModeMap(fieldvalue,maptype){
	if(ispingmap==1){
		showMapDialog(fieldvalue,maptype);
	}else if(ispingmap = 0){
		pingmap(fieldid);
	}else if(ispingmap = -1){
		return;//ping不通外网则不弹出地图
	}
}

function onBtnSearchClick(){
	setSearchName();
	if(dataArray["searchKeyNum"]==1){
		try{
			var searchNameValue=jQuery("#searchName").val();
			jQuery("input[name='con"+dataArray["parfield"]+"_value']").val(searchNameValue);
		}catch(e){}
	}
	jQuery("#isusersearchkey").val("1");
	jQuery("#frmmain").submit();
}

var ispingmap = 1;//0没有ping -1 ping不通   1 ping通
function pingmap(){

}

function showMapDialog(fieldvalue,maptype){
	var dialogurl ="";
	if(maptype&&maptype=='D'){
		var mapvalue = fieldvalue;
		dialogurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/view/FormModeMap.jsp?maptype="+maptype+"&fieldvalue="+mapvalue); 
	}
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.Width = 800 ;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();
}

function showMapPage(){
	if(dataArray["isUseMap"]==0){
		Dialog.alert("该查询列表未勾选地图定位配置！");
		return;
	}
	var customid = jQuery("#customid").val();
	var url ="";
	url = "/formmode/view/FormModeMap.jsp?maptype=customsearch&customid="+customid; 
	openFullWindowHaveBar(url);
}


$(document).ready(function(){
	if(dataArray["isShowQueryCondition"]!=1){
		return;
	}
	jQuery("#advancedSearchDiv").unwrap();
	$('.hideBlockDiv').unbind('click').bind('click',function(){
		var shadowDiv=$("div.e8_shadowDiv",parent.document);
		var advancedSearch=$('#advancedSearch',parent.document);
		$('#advancedSearchDiv').css('display','none');
		shadowDiv.hide();
		advancedSearch.removeClass("click");
	});
	$('#cancel').unbind('click').bind('click',function(){
		var shadowDiv=$("div.e8_shadowDiv",parent.document);
		var advancedSearch=$('#advancedSearch',parent.document);
		$('#advancedSearchDiv').css('display','none');
		shadowDiv.hide();
		advancedSearch.removeClass("click");
	});
});
