var brwDlg;

function showBrwDlg(url, urlparam, wid, heig,spanname,inputname,callbkfun){
	if(window.top.Dialog){
		brwDlg = new window.top.Dialog();
	} else {
		brwDlg = new Dialog();
	}
	brwDlg.currentWindow = window;
	brwDlg.Width = wid||500;
	brwDlg.Height = heig||570;
	brwDlg.Modal = true;
	brwDlg.Title = "";
	if(!callbkfun) callbkfun = "";
	if(urlparam != ""){
		brwDlg.URL = url+"?"+encodeURIComponent(urlparam+"&from=1&spanname="+spanname+"&inputname="+inputname+"&callbkfun="+callbkfun);
	} else {
		brwDlg.URL = url+"?"+encodeURIComponent("from=1&spanname="+spanname+"&inputname="+inputname+"&callbkfun="+callbkfun);
	}
	brwDlg.show();
}


function closeBrwDlg(){
	try{
		brwDlg.close();
	}catch(e){}
}

function callBackValue(datas, spanname,inputname){
	closeBrwDlg();
	if (datas != null) {
		if (wuiUtil.getJsonValueByIndex(datas, 0) != "" && wuiUtil.getJsonValueByIndex(datas, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(datas, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(datas, 1);
			var sHtml = ""

			var tlinkurl = "";
			var resourceIdArray = resourceids.split(",");
			var resourceNameArray = resourcename.split(",");
			for (var _i=0; _i<resourceIdArray.length; _i++) {
				var curid = resourceIdArray[_i];
				var curname = resourceNameArray[_i];
 				sHtml = sHtml+curname+",";
				
			}
					
			jQuery("#"+spanname).html(sHtml.substring(0,sHtml.length-1));
			jQuery("#"+inputname).val(resourceids);
		} else {
 			jQuery("#"+spanname).html("");
			jQuery("#"+inputname).val("");
		}
		
	}

}

function showDlg(title,url,diag,_window)
            {
            if(diag){
            	diag.close();
            }
            
			diag.currentWindow = _window;
			diag.Width = 800;
			diag.Height = 550;
						diag.Modal = true;
						diag.maxiumnable = true;
						diag.Title = title;
						diag.URL = url;
						diag.show();
            } 

function onShowCarinfo(tdname,inputename){
	//TODO 车辆使用browser
	return false;
}

function showCars(){
	if(window.top.Dialog){
		var diag = new window.top.Dialog();
	} else {
		diag = new Dialog();
	}
	diag.currentWindow = window;
	diag.Width = 1100;
	diag.Height = 550;
	diag.Modal = true;
	diag.maxiumnable = true;
	diag.Title = "车辆使用情况";
	diag.URL = "/car/CarUseInfo.jsp";
	diag.show();
}

function onShowTask(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的任务数量太多，数据库将无法保存所有的任务，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}

function onShowDoc(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的文档数量太多，数据库将无法保存所有的文档，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}

function onShowProject(tdname,inputename){
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp","","dialogWidth:550px;dialogHeight:550px;");
	if(datas){
	    if (datas.id!=""){
		$("#"+tdname).html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+" target='_blank'>"+datas.name+"</A>");
		$("input[name="+inputename+"]").val(datas.id);
	    }else{
	    	$("#"+tdname).html("");
	    	$("input[name="+inputename+"]").val("");
	    }
	 return true;
	}
	return false;
}

function onShowMultiProject(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的项目数量太多，数据库将无法保存所有的项目，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}

function onShowTask(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的任务数量太多，数据库将无法保存所有的任务，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(0,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}

function checklength(obj, msg) {
        var max = obj.maxlength; 
        if(max == null || max == "" || max == undefined) {
            return;
        }
        if(obj.value.length > max) {
            Dialog.alert(msg+":" + max);
            obj.value=obj.value.substring(0,(max-1));
            return;
        }
    }


function onShowCarType(spanname,inputname,isMuti, ismand,callbkfun) {
      //TODO 车辆类型
}

function onShowCrmID(spanname,inputname,isMuti, ismand) {
	  var tmpids = jQuery("#"+inputname).val();
	  linkurl="/CRM/data/ViewCustomer.jsp?CustomerID=";
	  var url = "";
	  if(isMuti == 0){
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	  } else {
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp";
	  }
	
	  var id = window.showModalDialog(url + "?resourceids=" + tmpids,
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

function onShowCatalog(spanname,inputname, ismand) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result, 0) > 0){
          jQuery("#"+spanname).html(wuiUtil.getJsonValueByIndex(result, 2));
          jQuery("#"+inputname).val(wuiUtil.getJsonValueByIndex(result, 3)+","+wuiUtil.getJsonValueByIndex(result, 4)+","+wuiUtil.getJsonValueByIndex(result, 1));
        }else{
          if (ismand == 0) {
 				jQuery("#"+spanname).html("");
 			} else {
 				jQuery("#"+spanname).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
 			}
          jQuery("#"+inputname).val("");
        }
    }
}

function showCalaogCallBk(event,datas,name,ismand){
	if (datas != null) {
        if (wuiUtil.getJsonValueByIndex(datas, 0) > 0){
          jQuery("#"+name+"span").html("<a href=/docs/category/DocMainCategory.jsp?id=" + wuiUtil.getJsonValueByIndex(datas, 1) + " target=_new>" + wuiUtil.getJsonValueByIndex(datas, 2) + "</a>&nbsp;" );
          jQuery("#"+name).val(wuiUtil.getJsonValueByIndex(datas, 3)+","+wuiUtil.getJsonValueByIndex(datas, 4)+","+wuiUtil.getJsonValueByIndex(datas, 1));
        }else{
          if (ismand == 1) {
          		jQuery("#"+name+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
 				
 			} else {
 				jQuery("#"+name+"span").html("");
 			}
          jQuery("#"+name).val("");
        }
    }
}



function onShowWorkflow(spanname,inputname, isMuti, ismand, sqlwhere) {
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	  var url = "";
	  if(isMuti == 0){
		url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= "+sqlwhere;
	  } else {
		url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?sqlwhere= "+sqlwhere+"&wfids="+$("input[name="+inputname+"]").val();
	  }
	
	  var id = window.showModalDialog(url , "","dialogWidth:550px;dialogHeight:550px;")
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
 				sHtml = sHtml+curname+"&nbsp;";
				
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

function onShowRequest(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的流程数量太多，数据库将无法保存所有的流程，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
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
 				sHtml = sHtml+"<a href='"+linkurl+curid+"' target='_blank' >"+curname+"</a>&nbsp;";
				
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
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?rightStr="+rightStr;
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
	                sHtml = sHtml+"<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+curid+"' target='_blank'>"+curname+"&nbsp;</a>";
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

/**
*清空搜索条件
*/
function resetCondtionAVS(){
	//清空文本框
	jQuery("#advancedSearchDiv").find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery("#advancedSearchDiv").find(".Browser").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery("#advancedSearchDiv").find("select").val("0");
	jQuery("#advancedSearchDiv").find("select").trigger("change");
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery("#advancedSearchDiv").find("select").selectbox('detach');
	jQuery("#advancedSearchDiv").find("select").selectbox('attach');
}

/**
*清空搜索条件
*/
function resetCondtionBrw(eleid){
	//清空文本框
	jQuery("#"+eleid).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery("#"+eleid).find(".Browser").siblings("span").html("");
	jQuery("#"+eleid).find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#"+eleid).find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#"+eleid).find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery("#"+eleid).find("select").val("0");
	jQuery("#"+eleid).find("select").trigger("change");
	//清空日期
	jQuery("#"+eleid).find(".calendar").siblings("span").html("");
	jQuery("#"+eleid).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery("#"+eleid).find("select").selectbox('detach');
	jQuery("#"+eleid).find("select").selectbox('attach');
}

function clearBrwInEle(eleId){
	jQuery("#"+eleId).find(".Browser").siblings("span").html("");
	jQuery("#"+eleId).find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#"+eleId).find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#"+eleId).find(".e8_outScroll .e8_innerShow span").html("");
}

/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.getElementById(elementName).value;
	
	var len = -1;
	if(elementName){
		len = tmpvalue.length;
	}
	
	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;
	
	var newIntValue="";
	var newDecValue="";
	for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
	}
	
	var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
	document.getElementById(elementName).value=newValue;
}

/**
*日期更改
*/
function changeDate(obj,id,val){
	if(val==null)val='6';
	if(obj.value==val){
		jQuery("#"+id).show();
	}else{
		jQuery("#"+id).hide();
		jQuery("#"+id).siblings("input[type='hidden']").val("");
	}
}
/**
新增设备 获取值 追加html位置 span的name 允许的长度
*/
function addDevice(obj,id,name,len,title){
	var addVal=jQuery("#"+obj).val();
	var currentlength=0;
	if(addVal==null||addVal=="") return;
	//判断添加的元素是否存在
	var aa=jQuery("span[name='"+name+"']");
	for(var key=0;key<aa.size();key++){
		currentlength+=jQuery(aa[key]).attr("val").length+1;
		if(jQuery(aa[key]).attr("val")==addVal){
			Dialog.alert(title+"已存在");
			return; 
		}
	}
	currentlength+=addVal.length;
	if(currentlength>len && len>0){
		Dialog.alert(title+"超出长度");
		return; 
	}
	var insertHtml='<span class="e8_showNameClass" name="'+name+'" val="'+addVal+'">&nbsp;'+addVal+'<span class="e8_delClass" onclick="delsp(this,1);">&nbsp;x&nbsp;</span></span>'
	jQuery('#'+id).append(insertHtml);
	jQuery("#"+obj).val("");
}

function delsp(obj,isMustInput){
		try{
			jQuery(obj).closest("div.e8_innerShow").find("input[type=text]").show().focus();
			var id = ","+jQuery(obj).attr("id")+",";
			var ele = jQuery(obj).closest("span.e8_showNameClass").parent("span").attr("id");
			var ids = ","+jQuery(obj).closest("div.e8_innerShow").find("#"+ele.replace("span","")).val()+",";
			var newids = ids.replace(id,",");
			newids = newids.substring(1,newids.length-1);
			if(newids==","){
				newids="";
				if(isMustInput==2){
					jQuery(obj).closest("span.e8_showNameClass").parent("span").html("<span class='e8_spanFloat'><img align='absmiddle' src='/images/BacoError_wev8.gif'></span>");
				}
			}
			jQuery(obj).closest("div.e8_innerShow").find("#"+ele.replace("span","")).val(newids);
			
			try {
				eval(jQuery(obj).closest("div.e8_innerShow").find("#"+ele.replace("span","")).attr('onpropertychange'));
			} catch (e) {
			}
			jQuery(obj).closest("span.e8_showNameClass").remove();
		}catch(e){
			if(window.console)console.log(e);
		}
	}


//人员多选
function addHrmidsBrowser(eleId, parentid){
	var pluginHrmids={
		type:"browser",
			addIndex:false,
			attr:{
				name:eleId,				
				viewType:"0",
				browserValue:"0",
				isMustInput:"1",
				browserSpanValue:"",
				hasInput:true,
				linkUrl:"javascript:openhrm($id$);",
				completeUrl:"/data.jsp",
				browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=",
				width:"100",
				hasAdd:false,
				isSingle:false
			}
	};	
	jQuery("#"+parentid).addEditPlugin({editPlugin:pluginHrmids,delayedFunctions:[]},true);	
}

function addHrmidsBrowserW(eleId, parentid,width){
	var pluginHrmids={
		type:"browser",
			addIndex:false,
			attr:{
				name:eleId,				
				viewType:"0",
				browserValue:"0",
				isMustInput:"1",
				browserSpanValue:"",
				hasInput:true,
				linkUrl:"javascript:openhrm($id$);",
				completeUrl:"/data.jsp",
				browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=",
				width:width,
				hasAdd:false,
				isSingle:false
			}
	};	
	jQuery("#"+parentid).addEditPlugin({editPlugin:pluginHrmids,delayedFunctions:[]},true);	
}

//人员多选
function addHrmidBrowserSinge(eleId, parentid){
	var pluginHrmids={
		type:"browser",
			addIndex:false,
			attr:{
				name:eleId,				
				viewType:"0",
				browserValue:"0",
				isMustInput:"1",
				browserSpanValue:"",
				hasInput:true,
				linkUrl:"javascript:openhrm($id$);",
				completeUrl:"/data.jsp",
				browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
				width:"100",
				hasAdd:false,
				isSingle:true
			}
	};	
	jQuery("#"+parentid).addEditPlugin({editPlugin:pluginHrmids,delayedFunctions:[]},true);	
}
function addHrmidBrowserSingeW(eleId, parentid, width){
	var pluginHrmids={
		type:"browser",
			addIndex:false,
			attr:{
				name:eleId,				
				viewType:"0",
				browserValue:"0",
				isMustInput:"1",
				browserSpanValue:"",
				hasInput:true,
				linkUrl:"javascript:openhrm($id$);",
				completeUrl:"/data.jsp",
				browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
				width:width,
				hasAdd:false,
				isSingle:true
			}
	};	
	jQuery("#"+parentid).addEditPlugin({editPlugin:pluginHrmids,delayedFunctions:[]},true);	
}

//项目单选多选
function addProjectBrowser(eleId, parentid){
	var pluginProjid={
		type:"browser",
		addIndex:false,
		attr:{
			name:eleId,
			viewType:"0",
			browserValue:"0",
			isMustInput:"1",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#",
			completeUrl:"/data.jsp?type=8",
			browserUrl:"/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp",
			width:"100",
			hasAdd:false,
			isSingle:true
		}
	};
	jQuery("#"+parentid).addEditPlugin({editPlugin:pluginProjid,delayedFunctions:[]},true);	
}

function addProjectBrowserW(eleId, parentid,width){
	var pluginProjid={
		type:"browser",
		addIndex:false,
		attr:{
			name:eleId,
			viewType:"0",
			browserValue:"0",
			isMustInput:"1",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#",
			completeUrl:"/data.jsp?type=8",
			browserUrl:"/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp",
			width:width,
			hasAdd:false,
			isSingle:true
		}
	};
	jQuery("#"+parentid).addEditPlugin({editPlugin:pluginProjid,delayedFunctions:[]},true);	
}

//客户多选
function addCRMsBrowser(eleId, parentid){
	var pluginCrmid={
		type:"browser",
		addIndex:false,
		attr:{
			name:eleId,
			viewType:"0",
			browserValue:"0",
			isMustInput:"1",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#",
			completeUrl:"/data.jsp?type=8",
			browserUrl:"/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=",
			width:"100",
			hasAdd:false,
			isSingle:false
		}
	};
	jQuery("#"+parentid).addEditPlugin({editPlugin:pluginCrmid,delayedFunctions:[]},true);	
}

function addCRMsBrowserW(eleId, parentid, width){
	var pluginCrmid={
		type:"browser",
		addIndex:false,
		attr:{
			name:eleId,
			viewType:"0",
			browserValue:"0",
			isMustInput:"1",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#",
			completeUrl:"/data.jsp?type=8",
			browserUrl:"/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=",
			width:width,
			hasAdd:false,
			isSingle:false
		}
	};
	jQuery("#"+parentid).addEditPlugin({editPlugin:pluginCrmid,delayedFunctions:[]},true);	
}
