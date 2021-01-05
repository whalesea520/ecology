 function formatUrl(url){
	if(url.indexOf("https://open.weixin.qq.com/connect/oauth2/authorize")>-1){
		var s="redirect_uri=";
		url=url.substr(url.indexOf(s)+s.length);
		url=url.substr(0,url.indexOf("&"));
		url=url.replace(/%3A/g,":").replace(/%2F/g,"/")
		return url;
	}
	return url;
}


function onShowRole(tdname,inputename){
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","", "dialogWidth:550px;dialogHeight:550px;");
	if(datas){
	    if (datas.id!=""){
		$("#"+tdname).html(datas.name);
		$("input[name="+inputename+"]").val(datas.id);
	    }else{
	    	$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    	$("input[name="+inputename+"]").val("");
	    }
	 return true;
	}
	return false;
}

function onShowHrmResource(spanname,inputname, isMuti, ismand) {
	var tmpids = jQuery("#"+inputname).val();
	if (tmpids == "NULL" || tmpids == "Null" || tmpids == "null") {
		 tmpids = "";
	}
	var url = "";
	if(isMuti == 0){
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else {
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
	}
	
	var id = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	//var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + $GetEle(inputename).value, "", "dialogWidth:550px;dialogHeight:550px;")
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id, 1);
			var sHtml = ""

			if(isMuti == 1){
				resourceids = resourceids.substr(1);
				resourcename = resourcename.substr(1);
			}
			var tlinkurl = "";
			var resourceIdArray = resourceids.split(",");
			var resourceNameArray = resourcename.split(",");
			for (var _i=0; _i<resourceIdArray.length; _i++) {
				var curid = resourceIdArray[_i];
				var curname = resourceNameArray[_i];

				if (tlinkurl != "/hrm/resource/HrmResource.jsp?id=") {
					sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
				} else {
					sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp;";
				}
			}
					
			jQuery("#"+spanname).html(sHtml);
			jQuery("#"+inputname).val(resourceids);
		} else {
			if (ismand == 0) {
 				jQuery("#"+spanname).html("");
 			} else {
 				jQuery("#"+spanname).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
 			}
			jQuery("#"+inputname).val("");
		}
	 return true;
	}
	return false;
}

function onShowDepartment(spanname,inputname, isMuti, ismand){
	  
	  linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	  var url = "";
	  if(isMuti == 0){
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
	  } else {
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp";
	  }
	
	  var id = window.showModalDialog(url + "?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	  "","dialogWidth:550px;dialogHeight:550px;")
	   if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id, 1);
			var sHtml = ""

			if(isMuti == 1){
				resourceids = resourceids.substr(1);
				resourcename = resourcename.substr(1);
			}
			var tlinkurl = "";
			var resourceIdArray = resourceids.split(",");
			var resourceNameArray = resourcename.split(",");
			for (var _i=0; _i<resourceIdArray.length; _i++) {
				var curid = resourceIdArray[_i];
				var curname = resourceNameArray[_i];
 				sHtml = sHtml+"<a href='"+linkurl+curid+"'  >"+curname+"</a>&nbsp;";
				
			}
					
			jQuery("#"+spanname).html(sHtml);
			jQuery("#"+inputname).val(resourceids);
		} else {
			if (ismand == 0) {
 				jQuery("#"+spanname).html("");
 			} else {
 				jQuery("#"+spanname).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
 			}
			jQuery("#"+inputname).val("");
		}
	 return true;
	}
	return false;
}

function onShowSubcompany(spanname,inputname, isMuti, ismand, urlp, detachable, rightStr){
	   var currentids=jQuery("#"+inputname).val();
	   var url = "";
	   if(urlp == "" || urlp == "NULL" || urlp == "Null" || urlp == "null"){
		   if(isMuti == 0){
		        if(detachable != 1){
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+currentids;
				} else {
					var encodeuri=encodeURIComponent("selectedids="+currentids+"&rightStr="+rightStr);
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?"+encodeuri;
				}
			} else {
				url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="+currentids;
			}
		} else {
			url = urlp
		}
	   var id=window.showModalDialog(url);
	   if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id, 1);
			var sHtml = ""

			if(isMuti == 1){
				resourceids = resourceids.substr(1);
				resourcename = resourcename.substr(1);
			}
			var resourceIdArray = resourceids.split(",");
			var resourceNameArray = resourcename.split(",");
			for (var _i=0; _i<resourceIdArray.length; _i++) {
				var curid = resourceIdArray[_i];
				var curname = resourceNameArray[_i];
	            if(curid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmSubCompanyDsp.jsp?id="+curid+"')>"+curname+"</a>&nbsp;";
	          }
	          jQuery("#"+inputname).val(resourceids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          if (ismand == 0) {
 				  jQuery("#"+spanname).html("");
 			   } else {
 				  jQuery("#"+spanname).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
			   }
	       }
        return true;
	}
	return false;
}



function onShowHrmResource4Wechat(fieldid,publicid) {
	var tmpids = jQuery("#"+fieldid).val();
	var publicidvalue = jQuery("#"+publicid).val();
	
	if (tmpids == "NULL" || tmpids == "Null" || tmpids == "null") {
		 tmpids = "";
	}
	var	url = "/systeminfo/BrowserMain.jsp?url=/wechat/bowser/hrm/MutiResourceBrowser.jsp";
	 
	var param=encodeURIComponent("resourceids="+tmpids+"&publicid="+publicidvalue);
	
	var datas = window.showModalDialog(url + "?" +param);
	 
	if (datas) {
		if (wuiUtil.getJsonValueByIndex(datas,0)!= ""){
	    	var idArr = wuiUtil.getJsonValueByIndex(datas,0).split(",");
	    	var nameArr = wuiUtil.getJsonValueByIndex(datas,1).split(",");
	    	var showNames = "";
	    	for(var i=0;i<idArr.length;i++){
	    		var showname = "<a href=javaScript:openhrm(" + idArr[i] + "); onclick='pointerXY(event);'>" + nameArr[i] + "</a>&nbsp";
				showNames += showname;
			}
			jQuery("#"+fieldid+"span").html(showNames);
			jQuery("#"+fieldid).val(wuiUtil.getJsonValueByIndex(datas,0));
		}else{
			jQuery("#"+fieldid+"span").html("");
			jQuery("#"+fieldid).val("");
		}
	}	 
	eval("formatInitData"+fieldid+"()");
}
