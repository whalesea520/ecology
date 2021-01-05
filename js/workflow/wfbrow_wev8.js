/**
 * browser回调方法
 */
function wfbrowvaluechange(obj, fieldid, rowindex) {
	var needTri = needTriBrowCallBack(fieldid, rowindex);
	if(!needTri && typeof rowindex == "undefined"){
		//alert("触发3=="+fieldid+"==="+rowindex);
		//仅为了预算自定义表单费控功能使用，切勿擅动!有问题，请联系相关模块负责人!
		try{wfbrowvaluechange_fna(obj, fieldid, rowindex);}catch(e){}
	}
	if(!needTri)
		return;
	//alert("触发3=="+fieldid+"==="+rowindex);
	//仅为了预算自定义表单费控功能使用，切勿擅动!有问题，请联系相关模块负责人!
	try{wfbrowvaluechange_fna(obj, fieldid, rowindex);}catch(e){}
	
	try {
		if(typeof rowindex != "undefined"){
		    var disattr = jQuery("#field" + fieldid + "_" + rowindex + "_browserbtn").attr("disabled");
	        if ((disattr == "true" || disattr == true || disattr == "disabled") && jQuery("#field" + fieldid + "_" + rowindex).val() == '') {
	            __resetBrow(fieldid);
	        }
	        if(("," + $G("needcheck").value + ",").indexOf(",field" + fieldid + "_" + rowindex + ",") >= 0 && jQuery("#field" + fieldid + "_" + rowindex).val() == ''){
                 jQuery(jQuery("#field" + fieldid + "_" + rowindex +"spanimg")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
	        }else{
	             jQuery(jQuery("#field" + fieldid + "_" + rowindex +"spanimg")).html("");
	        }
		}else{
            var disattr = jQuery("#field" + fieldid + "_browserbtn").attr("disabled");
	        if ((disattr == "true" || disattr == true || disattr == "disabled") && jQuery("#field" + fieldid).val() == '') {
	            __resetBrow(fieldid);
	        }
		}
		
	} catch (e) {}
}

/*
 * 解决IE下页面加载浏览按钮字段重复触发wfbrowvaluechange方法
 */
var __propertyBrowCache = new scpCache();
function needTriBrowCallBack(fieldid, rowindex){
	try{
		if(navigator.userAgent.indexOf('MSIE')>-1){
			var _fieldid = "field"+fieldid;
			if(typeof rowindex != "undefined")
				_fieldid = "field"+fieldid+"_"+rowindex;
			var _fieldObj = jQuery("input[type='hidden']#"+_fieldid);
			if(_fieldObj.size() > 0){
				if(__propertyBrowCache.hasCache(_fieldid)){
					if(__propertyBrowCache.getCacheValue(_fieldid) == _fieldObj.val())
						return false;
					__propertyBrowCache.addCache(_fieldid, _fieldObj.val());
				}else{		//第一次不触发
					__propertyBrowCache.addCache(_fieldid, _fieldObj.val());
					return false;
				}
			}
		}
	}catch(e){}
	return true;
}

function scpCache(){
    var cache = {};
    return {
        //将数据添加到缓存里面
        addCache: function(key, value){
            if(!(key in cache)){
                cache[key] = value;
            }else {
                delete cache[key];
                cache[key] = value;
            }
        },
        //移除缓存中的数据
        removeCache: function(key){
            if(key in cache) {
                delete cache[key];
            }
        },
        //移除缓存中的所有数据
        removeAllCache: function(){
        	for(key in cache)
        		delete cache[key];
        },
        //判断缓存中是否有该键值对
        hasCache: function(key){
            if(key in cache)
                return true;
            return false;
        },
        //根据键值获取缓存中的值
        getCacheValue: function(key){
            if(key in  cache)
                return cache[key];
            return "undefined";
        },
        //返回cache对象
        getCache: function(){
            return cache;
        },
        //返回cache对象的大小
        getCacheSize: function(){
        	var i=0;
        	for(key in cache)
        		i++;
        	return i;
        }
    }
};

function getajaxurl(typeId,inputIdOrName,sqlwhere,fieldbodyid,roleid){
	try{
		if(window._FnaSubmitRequestJsFlag && (typeId==1 || typeId==4 || typeId==164 || typeId==251)){
			var _typeId_fna_orgType_hrm = 1;
			var _typeId_fna_orgType_dep = 4;
			var _typeId_fna_orgType_sub = 164;
			var _typeId_fna_orgType_fcc = 251;
			var __fieldId = inputIdOrName.split("_")[0].replace("field", "");
			if(window.dt1_organizationid && __fieldId==window.dt1_organizationid
					 && window.dt1_organizationtype){
				var __dtIdx = "";
				if((window.dt1_organizationtype_isDtl && window.dt1_organizationtype_isDtl=="1") || !window.dt1_organizationtype_isDtl){
					__dtIdx = inputIdOrName.split("_")[1];
				}
				
				var __dt1_organizationtype_isDtl = "1";
				if(window.dt1_organizationtype_isDtl){
					__dt1_organizationtype_isDtl = window.dt1_organizationtype_isDtl;
				}
				var __orgType = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype, __dt1_organizationtype_isDtl, __dtIdx);
				
				if(__orgType!=null && __orgType!=""){
					if(__orgType == '0'){
						typeId=_typeId_fna_orgType_hrm;
					}else if(__orgType == '1'){
						typeId=_typeId_fna_orgType_dep;
					}else if(__orgType == '2'){
						typeId=_typeId_fna_orgType_sub;
					}else if(__orgType=='3' && window._FnaCostCenterStaticIdx){
						typeId=_typeId_fna_orgType_fcc;
					}
				}
			}else if(window.dt1_organizationid2 && __fieldId==window.dt1_organizationid2
					 && window.dt1_organizationtype2){
				var __dtIdx = inputIdOrName.split("_")[1];
				
				var __dt1_organizationtype_isDtl2 = "1";
				var __orgType = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype2, __dt1_organizationtype_isDtl2, __dtIdx);
				
				if(__orgType!=null && __orgType!=""){
					if(__orgType == '0'){
						typeId=_typeId_fna_orgType_hrm;
					}else if(__orgType == '1'){
						typeId=_typeId_fna_orgType_dep;
					}else if(__orgType == '2'){
						typeId=_typeId_fna_orgType_sub;
					}else if(__orgType=='3' && window._FnaCostCenterStaticIdx){
						typeId=_typeId_fna_orgType_fcc;
					}
				}
			}
		}
	}catch(ex001){}
	var url = "";
	var userid=$G("f_weaver_belongto_userid").value;
	var usertype=$G("f_weaver_belongto_usertype").value;
	if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
	   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59){
		url = "/data.jsp?type=" + typeId+'&f_weaver_belongto_userid='+userid+'&f_weaver_belongto_usertype='+ usertype;
	} else if(typeId==160){
		var tmpids = $GetEle("field" + fieldbodyid).value;
		//url = url + roleid + "_" + tmpids;
		url = "/data.jsp?type=" + typeId+"&roleid="+roleid+"_"+tmpids+'&f_weaver_belongto_userid='+userid+'&f_weaver_belongto_usertype='+ usertype;
	}else if(typeId==1 || typeId==165 || typeId==166 || typeId==17||typeId==167||typeId==168 ||typeId==169||typeId==170){
		url = "/data.jsp?type=" + typeId+'&f_weaver_belongto_userid='+userid+'&f_weaver_belongto_usertype='+ usertype;
	} else {
		url = "/data.jsp?type=" + typeId+'&f_weaver_belongto_userid='+userid+'&f_weaver_belongto_usertype='+ usertype;
		if(typeId==161||typeId==162){
			if(inputIdOrName){
				url += "&fielddbtype="+encodeURI(inputIdOrName)+'&f_weaver_belongto_userid='+userid+'&f_weaver_belongto_usertype='+ usertype;
			}
		}
	}
	
	if(typeId==165||typeId==166||typeId==167||typeId==168){
		var fieldid = -1;
		var isdetail = -1;
		var isbill = -1;
		if($G("isbill")){
			isbill=$G("isbill").value;
		}
		
		if(inputIdOrName.indexOf("_")!=-1){ //明细字段
			isdetail = 1;
			var field = inputIdOrName.replace("field","");
			fieldid = field.split("_")[0];
		}else{ //主字段
			isdetail = 0;
			fieldid = inputIdOrName.replace("field","");
		}
		
		if (url.indexOf('?') < 0) {
			url += '?fieldid='+fieldid+'&isdetail='+isdetail+'&isbill='+isbill+'&f_weaver_belongto_userid='+userid+'&f_weaver_belongto_usertype='+ usertype;
		} else {
			url += '&fieldid='+fieldid+'&isdetail='+isdetail+'&isbill='+isbill+'&f_weaver_belongto_userid='+userid+'&f_weaver_belongto_usertype='+ usertype;
		}
	}
	
	//拼接浏览数据自定义参数
    try {
		if (isCanConfigType(typeId)) {
			var reg = /^field([0-9]+)(_[0-9]+)?$/gi;
			if (reg.test(inputIdOrName)) {
				if (url.indexOf('?') < 0) {
					url += '?' + getUserDefinedRequestParam(inputIdOrName);
				} else {
					url += '&' + getUserDefinedRequestParam(inputIdOrName);
				}
			}
		}
	} catch(e) {}
	if(typeof sqlwhere!='undefined' && sqlwhere!=''){
		url+="&whereClause="+sqlwhere;
	}	
	//资产浏览按钮
	if(typeId==23||typeId==26||typeId==3){
		var reqid=-1;
		var billid=-1;
		if($G("requestid")){
			reqid=$G("requestid").value;
		}
		if($G("formid")){
			billid=$G("formid").value;
		}
		url+="&wfid="+$G("workflowid").value+"&reqid="+reqid+"&billid="+billid+'&f_weaver_belongto_userid='+userid+'&f_weaver_belongto_usertype='+ usertype;
	}
	//alert(typeId + "," + url);
	try{
		//自定义费控流程  
		if(typeId==22){
			var __fieldId = inputIdOrName.split("_")[0].replace("field", "");
			
			url += "&workflowid="+$G("workflowid").value+"&fieldid="+__fieldId;
				 
			if(window._FnaSubmitRequestJsFlag||true){
				if(window.dt1_subject && __fieldId==window.dt1_subject
						 && window.dt1_organizationtype && window.dt1_organizationid){
					var __dtIdx = "";
 					if(__fieldId==window.dt1_subject 
 							&& ((window.dt1_subject_isDtl && window.dt1_subject_isDtl=="1") || !window.dt1_subject_isDtl)){
 						__dtIdx = inputIdOrName.split("_")[1];
 					}
 					
					var __dt1_organizationtype_isDtl = "1";
					if(window.dt1_organizationtype_isDtl){
						__dt1_organizationtype_isDtl = window.dt1_organizationtype_isDtl;
					}
					var __orgType = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype, __dt1_organizationtype_isDtl, __dtIdx);

					var __dt1_organizationid_isDtl = "1";
					if(window.dt1_organizationid_isDtl){
						__dt1_organizationid_isDtl = window.dt1_organizationid_isDtl;
					}
					var __orgId = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationid, __dt1_organizationid_isDtl, __dtIdx);
 					
 					//个人
 					if(__orgType == '0'){
 						__orgType = '3';
 					}else if(__orgType == '1'){
 						__orgType = '2';
 					}else if(__orgType == '2'){
 						__orgType = '1';
 					}else if(__orgType=='3' && window._FnaCostCenterStaticIdx){
 						__orgType = window._FnaCostCenterStaticIdx;
 					}
 					
 					url += "&orgType="+__orgType+"&orgId="+__orgId+"&fromFnaRequest=1";
 					
 					if(window.dt1_subject == window.dt1_subject2){
 						var __dtIdx2 = "";
	 					if(__fieldId==window.dt1_subject2 
	 							&& ((window.dt1_subject2_isDtl && window.dt1_subject2_isDtl=="1") || !window.dt1_subject2_isDtl)){
	 						__dtIdx2 = inputIdOrName.split("_")[1];
	 					}
	 					 
						var __dt1_organizationtype2_isDtl = "1";
						if(window.dt1_organizationtype2_isDtl){
							__dt1_organizationtype2_isDtl = window.dt1_organizationtype2_isDtl;
						}
						var __orgType2 = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype2, __dt1_organizationtype2_isDtl, __dtIdx2);

						var __dt1_organizationid2_isDtl = "1";
						if(window.dt1_organizationid2_isDtl){
							__dt1_organizationid2_isDtl = window.dt1_organizationid2_isDtl;
						}
						var __orgId2 = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationid2, __dt1_organizationid2_isDtl, __dtIdx2);
						
						//个人
	 					if(__orgType2 == '0'){
	 						__orgType2 = '3';
	 					}else if(__orgType2 == '1'){
	 						__orgType2 = '2';
	 					}else if(__orgType2 == '2'){
	 						__orgType2 = '1';
	 					}else if(__orgType2=='3' && window._FnaCostCenterStaticIdx){
	 						__orgType2 = window._FnaCostCenterStaticIdx;
	 					}
						
	 					url = url + "&orgType2=" + __orgType2+"&orgId2="+__orgId2;
 					}
 					
				 }else if(window.dt1_subject2 && __fieldId==window.dt1_subject2
						 && window.dt1_organizationtype2 && window.dt1_organizationid2){
					var __dtIdx = "";
 					if(__fieldId==window.dt1_subject2 
 							&& ((window.dt1_subject2_isDtl && window.dt1_subject2_isDtl=="1") || !window.dt1_subject2_isDtl)){
 						__dtIdx = inputIdOrName.split("_")[1];
 					}
 					 
					var __dt1_organizationtype2_isDtl = "1";
					if(window.dt1_organizationtype2_isDtl){
						__dt1_organizationtype2_isDtl = window.dt1_organizationtype2_isDtl;
					}
					var __orgType = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype2, __dt1_organizationtype2_isDtl, __dtIdx);

					var __dt1_organizationid2_isDtl = "1";
					if(window.dt1_organizationid2_isDtl){
						__dt1_organizationid2_isDtl = window.dt1_organizationid2_isDtl;
					}
					var __orgId = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationid2, __dt1_organizationid2_isDtl, __dtIdx);
 					
 					//个人
 					if(__orgType == '0'){
 						__orgType = '3';
 					}else if(__orgType == '1'){
 						__orgType = '2';
 					}else if(__orgType == '2'){
 						__orgType = '1';
 					}else if(__orgType=='3' && window._FnaCostCenterStaticIdx){
 						__orgType = window._FnaCostCenterStaticIdx;
 					}
 					
 					url += "&orgType="+__orgType+"&orgId="+__orgId+"&fromFnaRequest=1";
					
					if(window.dt1_subject == window.dt1_subject2){
						var __dtIdx2 = "";
	 					if(__fieldId==window.dt1_subject 
	 							&& ((window.dt1_subject_isDtl && window.dt1_subject_isDtl=="1") || !window.dt1_subject_isDtl)){
	 						__dtIdx = inputIdOrName.split("_")[1];
	 					}
	 					 
						var __dt1_organizationtype_isDtl = "1";
						if(window.dt1_organizationtype_isDtl){
							__dt1_organizationtype_isDtl = window.dt1_organizationtype_isDtl;
						}
						var __orgType2 = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype, __dt1_organizationtype_isDtl, __dtIdx2);

						var __dt1_organizationid_isDtl = "1";
						if(window.dt1_organizationid_isDtl){
							__dt1_organizationid_isDtl = window.dt1_organizationid_isDtl;
						}
						var __orgId2 = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationid, __dt1_organizationid_isDtl, __dtIdx2);
	 					
	 					//个人
	 					if(__orgType2 == '0'){
	 						__orgType2 = '3';
	 					}else if(__orgType2 == '1'){
	 						__orgType2 = '2';
	 					}else if(__orgType2 == '2'){
	 						__orgType2 = '1';
	 					}else if(__orgType2=='3' && window._FnaCostCenterStaticIdx){
	 						__orgType2 = window._FnaCostCenterStaticIdx;
	 					}
	 					
	 					url = url + "&orgType2=" + __orgType2+"&orgId2="+__orgId2;
					}
				 }
			}
		}
		if(typeId==251){
			var __fieldId = inputIdOrName.split("_")[0].replace("field", "");
			
			url += "&workflowid="+$G("workflowid").value+"&fieldid="+__fieldId;
		}
		
		
	}catch(ex1){}
	try{
		if(window.main_fieldIdSqr_controlBorrowingWf && window.main_fieldIdSqr && typeId==16){
			url += "&main_fieldIdSqr_controlBorrowingWf="+window.main_fieldIdSqr_controlBorrowingWf+"&main_fieldIdSqr_val="+jQuery("#field"+window.main_fieldIdSqr).val();
		}
	}catch(ex1){}
	if(typeId==161||typeId==162){
		return getUrlPara(url, inputIdOrName, fieldbodyid,sqlwhere);
	}else{
		return url;
	}
}

function getUrlPara(url, fielddbtype, fieldid,sqlwhere) {
	var formid = getDialogArgumentValueByName("formid");
	var isbill = getDialogArgumentValueByName("isbill");
	var workflowid = getDialogArgumentValueByName("workflowid");
	var browserType = fielddbtype;
	var frombrowserid = fieldid;
	var strdata = "formid="+formid+"&isbill="+isbill+"&workflowid="+workflowid+"&browserType="+browserType+"&frombrowserid="+frombrowserid;
	jQuery.ajax({
		url : "/formmode/browser/GetBrowserParas.jsp",
		type : "post",
		async:false,
		contentType: "application/x-www-form-urlencoded; charset=utf-8",
		processData : false,
		data : strdata,
		dataType : "xml",
		success: function do4Success(msg){
			try{
				var needChangeField = msg.getElementsByTagName("value")[0].childNodes[0].nodeValue;
				var fieldids = needChangeField.split(",");
				for(var i=0;i<fieldids.length;i++){
					var fieldid = fieldids[i].replace(/(^\s*)|(\s*$)/g,"");
					if(fieldid!=""){
						if(fieldid.indexOf("=")>1)
						{
							var newfilenames = fieldid.split("=");
							var searchfieldname = newfilenames[0];
							var workflowfieldid = newfilenames[1];
							url += "&"+searchfieldname+"=";
							//明细行号
							if(typeof sqlwhere!='undefined' && sqlwhere!=''){
								var detail_num=sqlwhere.split('_')[1];
								if(detail_num){
									if($('#'+workflowfieldid+'_'+detail_num)[0]){//判断条件上是否为明细字段	
										workflowfieldid+='_'+detail_num;
									}
								}
							}
							url += getDialogArgumentValueByName(workflowfieldid);
							//var tempfieldid="con"+workflowfieldid.substring(workflowfieldid.indexOf("field")+5)+"_value";
							//url += getDialogArgumentValueByName(tempfieldid);
						}
					}
				}
			}catch(e){
			}
		},
		error:function(){
		}
	});
	return url;
}

function getDialogArgumentValueByName(name) {
	var ele = document.getElementById(name);
	if (ele == undefined || ele == null) {
		var eles = document.getElementsByName(name);
		if (eles != undefined && eles != null && eles.length > 0) {
			ele = eles[0];
		}
	}
	if (ele) {
		return encodeURIComponent(ele.value);
	}else{
		var tmp="";
		jQuery("[name^="+name+"]").each(function(i,val){
			tmp+=","+jQuery(val).val();
		})
		if(tmp.length>0){
			tmp=tmp.substring(1);
		}
		return encodeURIComponent(tmp);
	}
	return "";
}

function wrapshowhtml2(viewtype, ahtml, id, fieldid) {
	var ismust = 1;
	if (viewtype == '1') {
		ismust = 2;
	}

	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this," + ismust + ",false,{});__resetBrow(" + fieldid + ")\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function wrapshowhtml0(viewtype, ahtml, id) {
	var ismust = 1;
	if (viewtype == '1') {
		ismust = 2;
	}

	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this," + ismust + ",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function wrapshowhtml(viewtype, ahtml, id) {
	var ismust = 1;
	if (viewtype == '1') {
		ismust = 2;
	}

	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this," + ismust + ",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function onShowBrowser3(id,url,linkurl,type1,ismand) {
	onShowBrowser2(id, url, linkurl, type1, ismand, 3);
}
function onShowBrowser2_fna(id,url,linkurl,type1,ismand, funFlag){
	onShowBrowser2(id,url,linkurl,type1,ismand, funFlag, "");
}
/* 传入参数：_fieldStr 表示 参数：id 的前缀，使用示例：
 * spanname = _fieldStr + id + "span";
 * inputname = _fieldStr + id;
 * $GetEle(_fieldStr+id).value;
 * jQuery("#"+ _fieldStr + id).attr('onpropertychange');
 * */
function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag, _fieldStr) {
	var userid,usertype;
	try{
		userid=$G("f_weaver_belongto_userid").value;
		usertype=$G("f_weaver_belongto_usertype").value;
	} catch(e){}
	
	var formid;
	var isbill;
	var workflowid;
	var tmpids = '';
//	var requestid;
	//流程文档标志,默认值为"0"
	var docFlags = "0";
	//若页面上该元素存在，则取该元素的值
	if(document.getElementById("docFlags")){
		docFlags = document.getElementById("docFlags").value;
	}
	try {
		formid = $G("formid").value;
		isbill = $G("isbill").value;
		workflowid = $G("workflowid").value;
		//requestid = $G("requestid").value;
	} catch (e){}
	var dialogurl = url;
	
	if(_fieldStr==null){
		_fieldStr = "field";
	}
	//url = encodeURI(url);
	//alert(url);
	
	var id1 = null;
    if (type1 == 9  && docFlags == "1" ) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
		dialogurl = url;
	}

	/*if (type1 == 16||type1 ==152||type1==171) {
		if(linkurl.indexOf("ViewRequest.jsp?")>-1 && !(linkurl.substring((url.length-4),linkurl.length).indexOf(".jsp")>-1)){
		linkurl += "&f_weaver_belongto_userid="+window.__userid+"&f_weaver_belongto_usertype="+ window.__usertype;
			}else{
		linkurl += "?f_weaver_belongto_userid="+window.__userid+"&f_weaver_belongto_usertype="+ window.__usertype;
			}
	}*/
	//资产浏览
	if (type1 == 23||type1 ==26||type1==3) {
		var reqid=-1;
		if($G("requestid")){
			reqid=$G("requestid").value;
		}

	if(url.indexOf("?")>-1 && !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
		if(url.indexOf("billid")>-1){
			url += "%26wfid="+workflowid+"%26reqid="+reqid+'&f_weaver_belongto_userid='+window.__userid+'&f_weaver_belongto_usertype='+ window.__usertype;
		 }else{
			url += "&billid=" + formid+"%26wfid="+workflowid+"%26reqid="+reqid+'&f_weaver_belongto_userid='+window.__userid+'&f_weaver_belongto_usertype='+ window.__usertype;
		 }		
	}else{
		url += "?billid=" + formid+"%26wfid="+workflowid+"%26reqid="+reqid+'&f_weaver_belongto_userid='+window.__userid+'&f_weaver_belongto_usertype='+ window.__usertype;	
			}
        dialogurl=url;
	}
	if (type1 == 224||type1 == 225||type1 == 226||type1 == 227) {
		if(url.indexOf("|")==-1){
			url += "|"+id;
		}
		if(url.indexOf("-")==-1){
			if(id.split("_")[1]){
				//zzl-拼接行号
				url += "_"+id.split("_")[1];
			}
		}
		url+="&workflowid="+workflowid;
		dialogurl = url;
	}
	
	if (type1 == 2 || type1 == 19 ) {
	    spanname = _fieldStr + id + "span";
	    inputname = _fieldStr + id;
	    
		if (type1 == 2) {
			onFlownoShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand, function(){
				try{onShowTimeCallBack(id);}catch(e){}//added by wcd 2015-07-31 增加回调，同步修改onWorkFlowShowTime
			});
		}
	} else {
		ismand = 0;
	    if (type1 != 256&&type1 != 257&&type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=194 && type1!=278) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161) {
				    //id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
				    dialogurl = url + "|" + id;
				} else {
                   if(type1 ==16){
		            dialogurl = url+tmpids;
					//alert("-------dialogurl----"+dialogurl);
			       		//id1 = window.showModalDialog(url+tmpids, window, "dialogWidth=550px;dialogHeight=550px");
			 	   }else{
			 		  try{
			 			 var __fieldId = id.split("_")[0].replace("field","");
			 				
			 			 if(type1 == 22){
			 				
			 				if(url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("%3F") > -1 
			 						|| url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("?") > -1){
			 					dialogurl = url + "%26workflowid="+$G("workflowid").value+"%26fieldid="+__fieldId;
							}else{
								dialogurl = url + "%3Fworkflowid="+$G("workflowid").value+"%26fieldid="+__fieldId;
							}
			 				
			 				 //自定义费控流程
			 				if(window._FnaSubmitRequestJsFlag||true){
				 				 if(window.dt1_subject && __fieldId==window.dt1_subject
				 						 && window.dt1_organizationtype && window.dt1_organizationid){
				 					var __dtIdx = "";
				 					if(__fieldId==window.dt1_subject 
				 							&& ((window.dt1_subject_isDtl && window.dt1_subject_isDtl=="1") || !window.dt1_subject_isDtl)){
				 						__dtIdx = id.split("_")[1];
				 					}
				 					 
									var __dt1_organizationtype_isDtl = "1";
									if(window.dt1_organizationtype_isDtl){
										__dt1_organizationtype_isDtl = window.dt1_organizationtype_isDtl;
									}
									var __orgType = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype, __dt1_organizationtype_isDtl, __dtIdx);

									var __dt1_organizationid_isDtl = "1";
									if(window.dt1_organizationid_isDtl){
										__dt1_organizationid_isDtl = window.dt1_organizationid_isDtl;
									}
									var __orgId = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationid, __dt1_organizationid_isDtl, __dtIdx);
				 					
				 					//个人
				 					if(__orgType == '0'){
				 						__orgType = '3';
				 					}else if(__orgType == '1'){
				 						__orgType = '2';
				 					}else if(__orgType == '2'){
				 						__orgType = '1';
				 					}else if(__orgType=='3' && window._FnaCostCenterStaticIdx){
				 						__orgType = window._FnaCostCenterStaticIdx;
				 					}
				 					
					 				if(dialogurl.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("%3F") > -1 
					 						|| dialogurl.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("?") > -1){
					 					dialogurl = dialogurl + "%26";
									}else{
										dialogurl = dialogurl + "%3F";
									}
				 					dialogurl = dialogurl + "orgType=" + __orgType+"%26orgId="+__orgId+"%26fromFnaRequest=1";
				 					
				 					if(window.dt1_subject == window.dt1_subject2){
				 						var __dtIdx2 = "";
					 					if(__fieldId==window.dt1_subject2 
					 							&& ((window.dt1_subject2_isDtl && window.dt1_subject2_isDtl=="1") || !window.dt1_subject2_isDtl)){
					 						__dtIdx2 = id.split("_")[1];
					 					}
					 					 
										var __dt1_organizationtype2_isDtl = "1";
										if(window.dt1_organizationtype2_isDtl){
											__dt1_organizationtype2_isDtl = window.dt1_organizationtype2_isDtl;
										}
										var __orgType2 = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype2, __dt1_organizationtype2_isDtl, __dtIdx2);

										var __dt1_organizationid2_isDtl = "1";
										if(window.dt1_organizationid2_isDtl){
											__dt1_organizationid2_isDtl = window.dt1_organizationid2_isDtl;
										}
										var __orgId2 = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationid2, __dt1_organizationid2_isDtl, __dtIdx2);
										
										//个人
					 					if(__orgType2 == '0'){
					 						__orgType2 = '3';
					 					}else if(__orgType2 == '1'){
					 						__orgType2 = '2';
					 					}else if(__orgType2 == '2'){
					 						__orgType2 = '1';
					 					}else if(__orgType2=='3' && window._FnaCostCenterStaticIdx){
					 						__orgType2 = window._FnaCostCenterStaticIdx;
					 					}
										
										dialogurl = dialogurl + "%26orgType2=" + __orgType2+"%26orgId2="+__orgId2;
				 					}
				 				 }else if(window.dt1_subject2 && __fieldId==window.dt1_subject2
				 						 && window.dt1_organizationtype2 && window.dt1_organizationid2){
				 					var __dtIdx = "";
				 					if(__fieldId==window.dt1_subject2 
				 							&& ((window.dt1_subject2_isDtl && window.dt1_subject2_isDtl=="1") || !window.dt1_subject2_isDtl)){
				 						__dtIdx = id.split("_")[1];
				 					}
				 					 
									var __dt1_organizationtype2_isDtl = "1";
									if(window.dt1_organizationtype2_isDtl){
										__dt1_organizationtype2_isDtl = window.dt1_organizationtype2_isDtl;
									}
									var __orgType = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype2, __dt1_organizationtype2_isDtl, __dtIdx);

									var __dt1_organizationid2_isDtl = "1";
									if(window.dt1_organizationid2_isDtl){
										__dt1_organizationid2_isDtl = window.dt1_organizationid2_isDtl;
									}
									var __orgId = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationid2, __dt1_organizationid2_isDtl, __dtIdx);
				 					
				 					//个人
				 					if(__orgType == '0'){
				 						__orgType = '3';
				 					}else if(__orgType == '1'){
				 						__orgType = '2';
				 					}else if(__orgType == '2'){
				 						__orgType = '1';
				 					}else if(__orgType=='3' && window._FnaCostCenterStaticIdx){
				 						__orgType = window._FnaCostCenterStaticIdx;
				 					}
				 					
				 					if(dialogurl.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("%3F") > -1 
					 						|| dialogurl.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("?") > -1){
					 					dialogurl = dialogurl + "%26";
									}else{
										dialogurl = dialogurl + "%3F";
									}
									dialogurl = dialogurl + "orgType=" + __orgType+"%26orgId="+__orgId+"%26fromFnaRequest=1";
									
									if(window.dt1_subject == window.dt1_subject2){
										var __dtIdx2 = "";
					 					if(__fieldId==window.dt1_subject 
					 							&& ((window.dt1_subject_isDtl && window.dt1_subject_isDtl=="1") || !window.dt1_subject_isDtl)){
					 						__dtIdx = id.split("_")[1];
					 					}
					 					 
										var __dt1_organizationtype_isDtl = "1";
										if(window.dt1_organizationtype_isDtl){
											__dt1_organizationtype_isDtl = window.dt1_organizationtype_isDtl;
										}
										var __orgType2 = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationtype, __dt1_organizationtype_isDtl, __dtIdx2);

										var __dt1_organizationid_isDtl = "1";
										if(window.dt1_organizationid_isDtl){
											__dt1_organizationid_isDtl = window.dt1_organizationid_isDtl;
										}
										var __orgId2 = window.getWfMainAndDetailFieldValueForPc(window.dt1_organizationid, __dt1_organizationid_isDtl, __dtIdx2);
					 					
					 					//个人
					 					if(__orgType2 == '0'){
					 						__orgType2 = '3';
					 					}else if(__orgType2 == '1'){
					 						__orgType2 = '2';
					 					}else if(__orgType2 == '2'){
					 						__orgType2 = '1';
					 					}else if(__orgType2=='3' && window._FnaCostCenterStaticIdx){
					 						__orgType2 = window._FnaCostCenterStaticIdx;
					 					}
					 					
					 					dialogurl = dialogurl + "%26orgType2=" + __orgType2+"%26orgId2="+__orgId2;
									}
				 				 }
				 			 }
			 			 }
			 			 if(type1 == 251){
			 				if(url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("%3F") > -1 
			 						|| url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("?") > -1){
			 					dialogurl = url + "%26workflowid="+$G("workflowid").value+"%26fieldid="+__fieldId;
							}else{
								dialogurl = url + "%3Fworkflowid="+$G("workflowid").value+"%26fieldid="+__fieldId;
							}
						}else if(type1==184||type1==268||type1==269||type1==270){
			 				if(url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("%3Fselectedids") > -1 
			 						|| url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("?selectedids") > -1
			 						||url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("%3Fresourceids") > -1
			 						||url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("?resourceids") > -1){
			 					dialogurl = url +$G("field"+id).value;
							}else{
								dialogurl = url + "%3Fselectedids="+$G("field"+id).value+"%26resourceids="+$G("field"+id).value;
							}
			 			 }
			 		  }catch(ex){}
				  // id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				  }

				}
	    	}
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle(_fieldStr+id).value;
				if(url.indexOf("?")>-1 && !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
				dialogurl = url + "&projectids=" + tmpids;
				}else{
				dialogurl = url + "?projectids=" + tmpids;
				}
				//id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) { 
	        //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
	       } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194 || type1 == 278) {
		        tmpids = $GetEle(_fieldStr+id).value;
		        if(tmpids == 0){
					tmpids = "";
				}
		        if((url.indexOf("%3F")>-1 || url.indexOf("?")>-1 )&& !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
		        	dialogurl = url + "&selectedids=" + tmpids;
				}else{
					dialogurl = url + "?selectedids=" + tmpids;
				}
				//id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle(_fieldStr+id).value;
				if(url.indexOf("?")>-1 && !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
		        dialogurl = url + "&documentids=" + tmpids;
				}else{
				 dialogurl = url + "?documentids=" + tmpids;
				}
				//id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle(_fieldStr+id).value;
				if(url.indexOf("?")>-1 && !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
		        dialogurl = url + "&receiveUnitIds=" + tmpids;
				}else{
				dialogurl = url + "?receiveUnitIds=" + tmpids;
				}
				//id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle(_fieldStr+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + encodeURI(url.substr(url.indexOf("url=") + 4));
					dialogurl = url;
					//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + encodeURI(url.substr(url.indexOf("url=") + 4));
					dialogurl = url;
					//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			}else if (type1 == 256|| type1 == 257) {
				tmpids = $GetEle(_fieldStr+id).value;
				url = url + "_" + type1 + "&selectedids=" + tmpids;
				url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
				dialogurl = url;
				//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
			}else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
					if(url.indexOf("?")>-1 && !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
		        	tmpids=uescape("&isdetail=1&isbill=" + isbill + "&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle(_fieldStr+id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
					}else{
					tmpids=uescape("?isdetail=1&isbill=" + isbill + "&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle(_fieldStr+id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
					}
		        	dialogurl = url + tmpids;
		        	//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
					if(url.indexOf("?")>-1 && !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
		        	tmpids = uescape("&fieldid=" + id + "&isbill=" + isbill + "&resourceids=" + $GetEle(_fieldStr + id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
					}else{
					tmpids = uescape("?fieldid=" + id + "&isbill=" + isbill + "&resourceids=" + $GetEle(_fieldStr + id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
					}
		        	dialogurl = url + tmpids;
		        	//把此行的dialogWidth=550px; 改为600px
		        	//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=600px;dialogHeight=550px");
		        }
			} else {
				if (type1 == 17 && id.indexOf('_') == -1) {
					var othparam = null;
					othparam = browUtil.getBrowData(id);
					if (othparam.indexOf(",") == 0) {
						othparam = othparam.substr(1);
					}
					if (dialogurl.indexOf("?") != -1) {
						dialogurl += "?";
					} else {
						dialogurl += "&";
					}
					dialogurl += "workflow=1&selectedids=" + othparam + "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+ usertype;
				} else {
		        	tmpids = $GetEle(_fieldStr + id).value;
					if(url.indexOf("?")>-1 && !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
		        	dialogurl = url + "&resourceids=" + tmpids;
					}else{
					dialogurl = url + "?resourceids=" + tmpids;
					}
					//alert("dialogurl"+dialogurl);
		        }
				//alert("----22224---");
				//id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
				  //id1 = window.showModalDialog(url + "?resourceids=" + tmpids+uescape("&fieldid="+id+"&currworkflowid=" + workflowid),  "", "dialogWidth=550px;dialogHeight=550px");
			}
			/*
			if (type1 == 152 || type1 == 171) {
	            dialogurl += tmpids;
	         	alert(dialogurl);
			}
			*/
		}
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		//dialog.callbackfunParam = null;
//资产浏览按钮
if((type1==23||type1==26||type1==3)&&dialogurl.indexOf("/cpt/capital/CapitalBrowser.jsp?")>=0){
	var reqid=-1;
	if($GetEle("requestid")){
		reqid=$GetEle("requestid").value;
	}
	dialogurl=dialogurl+"%26wfid="+workflowid+"%26reqid="+reqid;
}else if((type1==23||type1==26||type1==3)&&dialogurl.indexOf("/cpt/capital/CapitalBrowser.jsp")>=0){
	var reqid=-1;
	if($GetEle("requestid")){
		reqid=$GetEle("requestid").value;
	}
	dialogurl=dialogurl+"?wfid="+workflowid+"%26reqid="+reqid;
}
		//拼接浏览数据自定义参数
        try {
        	if (isCanConfigType(type1)) {
        		var _tempUrl = dialogurl;
        		if (_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') >= 0) {
        			_tempUrl = _tempUrl.substring(_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') + '/systeminfo/BrowserMain.jsp?url='.length);
        			_tempUrl = unescape(_tempUrl);
        		}
				if (_tempUrl.indexOf('?') < 0) {
					if(type1 == 9 || type1 == 37){
						_tempUrl = uescape(_tempUrl + '?' + getUserDefinedRequestParam(_fieldStr + id));
						dialogurl = '/systeminfo/BrowserMain.jsp?url='+_tempUrl;
					}else{
						dialogurl += uescape('?' + getUserDefinedRequestParam(_fieldStr + id));
					}
				} else {
					if(type1 == 9 || type1 == 37){
						_tempUrl = uescape(_tempUrl + '&' + getUserDefinedRequestParam(_fieldStr + id));
						dialogurl = '/systeminfo/BrowserMain.jsp?url='+_tempUrl;
					}else{
						dialogurl += uescape('&' + getUserDefinedRequestParam(_fieldStr + id));
					}
				}
			}
		} catch(e_bdf) {}
		try{
			if(window.main_fieldIdSqr_controlBorrowingWf && window.main_fieldIdSqr && type1==16){
				dialogurl += "%26main_fieldIdSqr_controlBorrowingWf="+window.main_fieldIdSqr_controlBorrowingWf+"%26main_fieldIdSqr_val="+jQuery("#field"+window.main_fieldIdSqr).val();
			}
		}catch(ex1){}
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1, otherdata) {
			if (id1 != undefined && id1 != null) {
				// 客户自定义验证方法， 返回false则不向下执行
				// 方法名：__browVal4CustomCheck
				// 参数： wfid, reqid, type, ids, names
				try {
					var __customcheckIds = wuiUtil.getJsonValueByIndex(id1, 0);
					//人力资源特殊处理
					if (typeof(__browVal4CustomCheck) == 'function' && type1 == 17 && id.indexOf('_') == -1) {
						var _parsrtvjson = browUtil.paserBrowData(id1, $G(_fieldStr+id).getAttribute("viewtype"), id);
						__customcheckIds = _parsrtvjson.id;
					}
					var __cutomfnrtn  = __browVal4CustomCheck(_fieldStr + id,  jQuery($G("workflowid")).val(), jQuery($G("requestid")).value, type1, __customcheckIds);
					if (__cutomfnrtn == false) {
						return ;
					}
				} catch (_e852) {}
			
				if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170 || type1==194) {
					if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
						var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
						var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
						var sHtml = ""
						
						//人力资源特殊处理
						if (type1 == 17 && id.indexOf('_') == -1) {
							var _rtvjson = browUtil.paserBrowData(id1, $G(_fieldStr+id).getAttribute("viewtype"), id);
							//缓存数据
							//browUtil.saveBrowData(id, testjson, _rtvjson.id);
							
							resourceids = _rtvjson.id;
							sHtml = _rtvjson.html;
							
						} else {
							if (resourceids.indexOf(",") == 0) {
								resourceids = resourceids.substr(1);
								resourcename = resourcename.substr(1);
							}
							var resourceIdArray = resourceids.split(",");
							var resourceNameArray = resourcename.split(",");
							for (var _i=0; _i<resourceIdArray.length; _i++) {
								var curid = resourceIdArray[_i];
								var curname = resourceNameArray[_i];
								if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
									sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp", curid);
								} else if(linkurl.indexOf("/hrm/resource/HrmResource.jsp") > -1){
								    sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp", curid);
								}else if(linkurl.indexOf("/hrm/hrmTab.jsp") > -1){
								    sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp", curid);
								} else {
									sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=" + linkurl + curid + "&f_weaver_belongto_userid="+window.__userid+"&f_weaver_belongto_usertype="+ window.__usertype + " target=_blank>" + curname + "</a>&nbsp", curid);
								}
								
							}
							
						}
						
						
						jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
						$GetEle(_fieldStr + id).value= resourceids;
					} else {
	 					if (ismand == 0) {
	 						jQuery($GetEle(_fieldStr+id+"span")).html("");
	 					} else {
	 						jQuery($GetEle(_fieldStr+id+"span")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
	 					}
	 					$GetEle(_fieldStr+id).value = "";
					}
	
				} else {
					
				   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" ) {
		               if (type1 == 162) {
							var config = null;//wuiUtil.getJsonValueByIndex(id1, 4);
							try{
								config = otherdata.config;
							}catch(e){
								if(window.console)console.log(e);
							}
							
					   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
							var names = wuiUtil.getJsonValueByIndex(id1, 1);
							var descs = "";
							var href = "";
							if(config){
								var destMap = otherdata.destMap;//wuiUtil.getJsonValueByIndex(id1, 2);
								var destMapKeys = otherdata.destMapKeys;//wuiUtil.getJsonValueByIndex(id1, 3);
								
								var nameKey = destMap["__nameKey"];
								var idKey = config.hiddenfield;
								for(var i=0; i<destMapKeys.length;i++ ){
									var key = destMapKeys[i];
									var dataitem = destMap[key];
									for (var item in dataitem) {									
										if(item===idKey||item===nameKey||item==="__state"||item==="__checked"||item==="__loaded" )continue;
										if(descs==""){
											descs = dataitem[item];
											if(descs.indexOf("<a ") > -1){
											    descs = "";
											}
										}else{
											descs=descs + ","+dataitem[item];
										}
										break;
									}
								}
							}else{
								descs = wuiUtil.getJsonValueByIndex(id1, 2);
								
							}
							href = wuiUtil.getJsonValueByIndex(id1, 3);
							sHtml = ""
							if(ids.indexOf(",") == 0){
								ids = ids.substr(1);
								names = names.substr(1);
								descs = descs.substr(1);
							}
							$GetEle(_fieldStr+id).value= ids;
							var idArray = ids.split(",");
							var nameArray = names.split("~~WEAVERSplitFlag~~");
							//由于表单建模依然使用逗号分隔，如果id和name个数不匹配，则重新分割
							if(nameArray.length < idArray.length){
								nameArray = names.split(",");
							}
							var descArray = descs.split(",");
							for (var _i=0; _i<idArray.length; _i++) {
								var curid = idArray[_i];
								var curname = nameArray[_i];
								var curdesc = descArray[_i];
								
								curid = curid.replace(/\(/g, "\\(");
								curid = curid.replace(/\)/g, "\\)");
								
								if(curdesc==''||curdesc=='undefined'||curdesc==null){
									curdesc = curname;
								}
								//if(curdesc){
								//	curdesc = curname;
								//}
								//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
								curname = curname.replace(new RegExp(/(<)/g),"&lt;");
        		                curname = curname.replace(new RegExp(/(>)/g),"&gt;");
								if(href==''){
									sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='" + curdesc + "' >" + curname + "</a>&nbsp", curid);
								}else{
									var tempurl=href + curid;
									tempurl=replaceModeidByFormidAndBillid(tempurl);
									sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='" + curdesc + "' href='" + tempurl+ "' target='_blank'>" + curname + "</a>&nbsp", curid);
								}

							}
							
							jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
							//return;
		               }
					   if (type1 == 161) {
						   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
							var descs = wuiUtil.getJsonValueByIndex(id1, 2);
							var href = wuiUtil.getJsonValueByIndex(id1, 3);
							$GetEle(_fieldStr+id).value = ids;
							names = names.replace(new RegExp(/(<)/g),"&lt;");
        		            names = names.replace(new RegExp(/(>)/g),"&gt;");
							//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
							if(href==''){
								sHtml = wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='" + descs + "'>" + names + "</a>&nbsp", ids);
							}else{

                            	if(isChineseCharacter(href+ids)){
                            	//	sHtml="<a title='"+desc+"' href='javascript:openHrefWithChinese(\""+href+ids+"\");'>"+name+"</a>&nbsp;";
                            		sHtml = wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='" + descs + "' href=' javascript:openHrefWithChinese(\""+href+ids+"\");'>" + names + "</a>&nbsp", ids);
                            	}else{
								    sHtml = wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp", ids);
                            	}
                            }
							jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
							//return ;
					   }
					   if(type1==256||type1==257){
	           	    		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
	           	    		var names = wuiUtil.getJsonValueByIndex(id1, 1);
	           	    		var idArray = ids.split(",");
	           	    		var nameArray = names.split(">,");
	           	    		var sHtml = "";
	           	    		for (var _i=0; _i<idArray.length; _i++) {
								var curid = idArray[_i];
								var curname = (idArray.length-1==_i) ? nameArray[_i] : nameArray[_i] + ">";
								sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"),curname + "&nbsp", curid);
							}
	           	    		$GetEle(_fieldStr+id).value = ids;
				        	jQuery($GetEle(_fieldStr + id + "span")).html(sHtml);
	           	       }
		               if (type1 == 9 && docFlags == "1" && (funFlag == undefined || funFlag != 3)) {
			                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
					        $GetEle(_fieldStr + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\"  type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
		               } else if (type1 != 161 && type1 != 162 && type1 != 256 && type1 != 257){
		               		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
							if(ids.indexOf(",") >-1){
								if(ids.indexOf(",") == 0){
									ids = ids.substr(1);
								}
								var names = wuiUtil.getJsonValueByIndex(id1, 1);
								sHtml = ""
								var idArray = ids.split(",");
								var nameArray = names.split(",");
								for (var _i=0; _i<idArray.length; _i++) {
									var curid = idArray[_i];
									if(curid == 0) continue;
									var curname = nameArray[_i];
									if (linkurl == "") {
										sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javascript:void(0)>" + curname + "</a>&nbsp", curid);
							        } else {
										sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=" + linkurl + curid + "&f_weaver_belongto_userid="+window.__userid+"&f_weaver_belongto_usertype="+ window.__usertype +" target=_blank>" + curname + "</a>&nbsp", curid);
							        }
						        
								}
								jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
							
							}else{
								if(id1 != 0){
				            	    if (linkurl == "") {
							        	jQuery($GetEle(_fieldStr + id + "span")).html(wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), wuiUtil.getJsonValueByIndex(id1, 1), wuiUtil.getJsonValueByIndex(id1, 0)));
							        } else {
										if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
											//alert("21dasdas");
											jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp", wuiUtil.getJsonValueByIndex(id1, 0)));
										} else if(linkurl.indexOf("/hrm/resource/HrmResource.jsp") > -1){
									        jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp", wuiUtil.getJsonValueByIndex(id1, 0)));
									    } else {
											//alert("444444444444444444");
											jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + "&f_weaver_belongto_userid="+window.__userid+"&f_weaver_belongto_usertype="+ window.__usertype + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>", wuiUtil.getJsonValueByIndex(id1, 0)));
										}
							        }
								}else{
									if (ismand == 0) {
										jQuery($GetEle(_fieldStr+id+"span")).html("");
									} else {
										jQuery($GetEle(_fieldStr+id+"span")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>"); 

									}
									$GetEle(_fieldStr+id).value="";
								}
							}
		               }


		               if(type1 != "161" && type1 !="162"){
		                	$GetEle(_fieldStr+id).value = jQuery.trim(wuiUtil.getJsonValueByIndex(id1, 0));
                       }

		                if (type1 == 9 && docFlags == "1" && (funFlag == undefined || funFlag != 3)) {
		                	var evt = getEvent();
		               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
		               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("");
		                }
		                
				   } else {
						if (ismand == 0) {
							jQuery($GetEle(_fieldStr+id+"span")).html("");
						} else {
							jQuery($GetEle(_fieldStr+id+"span")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>"); 
						}
						$GetEle(_fieldStr+id).value="";
						if (type1 == 9 && docFlags == "1" && (funFlag == undefined || funFlag != 3)) {
							var evt = getEvent();
		               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
		               		//jQuery(targetElement).next("span[id=CreateNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, userlanguage)%>'><%=SystemEnv.getHtmlLabelName(82, userlanguage)%></button>");
						}
						
						//人力资源特殊处理
						/*
						if (type1 == 17) {
							browUtil.saveBrowData(id, null);
						} 
						*/
				   }
				}
			}
			hoverShowNameSpan(".e8_showNameClass");
			try {
				if(!isIE() && typeof loadListener !== "function") {
					var onppchgfnstr = jQuery("#"+ _fieldStr + id).attr('onpropertychange');
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				}
			} catch (e) {
			}
			try {
				var onppchgfnstr = jQuery("#"+ _fieldStr + id + "__").attr('onpropertychange').toString();
				eval(onppchgfnstr);
				if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
					onpropertychange();
				}
			} catch (e) {
			}
			
			var _ismand = $G(_fieldStr+id).getAttribute("viewtype");
			var fieldidspanimg = $GetEle(_fieldStr+id+"spanimg");
			if(fieldidspanimg){
				if ($GetEle(_fieldStr + id).value == "") {
					//html模式相关文档，相关流程没有id号，所以生成input时，name不符合规范，没有viewtype属性，ismand为undefined
					if (_ismand == 0||!_ismand) {
						jQuery(fieldidspanimg).html("");
					} else {
						jQuery(fieldidspanimg).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
				} else {
					jQuery(fieldidspanimg).html("");
				}
			}
		} ;
		try{
			dialog.Title = SystemEnv.getHtmlNoteName(3418,languageid);
		}catch(e){
			dialog.Title = SystemEnv.getHtmlNoteName(3418,languageid);
		}
		dialog.Width = 550 ;
		if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){
  		dialog.Width=648;
  	}
		if(dialogurl.indexOf("/MultiRequestBrowser.jsp")!=-1||dialogurl.indexOf("/MultiRequestedBrowser.jsp")!=-1){
			if(jQuery.browser.msie){
				dialog.Height = 570;
			}else{
				dialog.Height = 570;
			}
		}else if(dialogurl.indexOf("/MutiCustomerBrowser.jsp")!=-1){
			if(jQuery.browser.msie){
				dialog.Height = 640;
			}else{
				dialog.Height = 630;
			}
		}else{
			dialog.Height = 600;
		}
		      if (type1 == 1 || type1 == 17){   
			if(linkurl.indexOf("HrmResource.jsp?")>-1){
		 //a = "jsp?dasda=2&f_weaver_belongto_userid=11111&f_weaver_belongto_usertype=0&adsada=2";
		 var b = linkurl.substring(linkurl.indexOf("HrmResource.jsp?"),linkurl.indexOf("HrmResource.jsp?")+16);
		 //alert(b);
		 linkurl = linkurl.replace(b,"HrmResource.jsp?f_weaver_belongto_userid="+window.__userid+"&f_weaver_belongto_usertype="+ window.__usertype);
		// alert(linkurl);
	  }
					}
		dialog.Drag = true;
		//dialog.maxiumnable = true;
		dialog.show();
	}
}

//多选浏览框按钮，建模浏览框若未关联模块，则替换链接中的modeid参数
function replaceModeidByFormidAndBillid(href){
	if(href.indexOf('modeId=0')==-1||href.indexOf('formId')==-1||href.indexOf('billid')==-1){
		return href;
	}
	jQuery.ajax({
		url : "/weaver/weaver.formmode.servelt.BrowserAction?action=resetBrowserHref&href="+encodeURIComponent(href),
		type : "post",
		dataType : "text",
		async : false,//改为同步
		success: function(msg){
			if(msg!=null){
				href=msg;
			}
		}
		});
	return href;
}
function initDetailBrow(fieldid, detaibrowshowid, detaibrowshowname, detailbrowclick, isSingle, isdemand, completeUrl, onPropertyChange, hasAdd, addOnClick,linkUrl) {
	var hasinput = true;
	if(completeUrl&&(completeUrl.indexOf("getajaxurl(256,")!=-1||completeUrl.indexOf("getajaxurl(257,")!=-1)){
		//hasinput = false;
	}
	//自定义浏览按钮，修改切割符
	if(completeUrl&&(completeUrl.indexOf("getajaxurl(161,")!=-1||completeUrl.indexOf("getajaxurl(162,")!=-1)){
		jQuery("#" + fieldid + "wrapspan").e8Browser({
		   name:fieldid,
		   viewType:"1",
		   browserValue: detaibrowshowid,
		   browserSpanValue: detaibrowshowname,
		   browserOnClick : detailbrowclick,
		   hasInput: hasinput,
		   isSingle: isSingle,
		   hasBrowser: true, 
		   isMustInput: isdemand,
		   completeUrl: completeUrl,
	       nameSplitFlag:'~~WEAVERSplitFlag~~',
		   width: "100%",
		   linkUrl:linkUrl,
		   needHidden: false,
		   onPropertyChange: onPropertyChange,
		   hasAdd: hasAdd,
		   addOnClick: addOnClick,
		   hiddenNotAssign:1
		});
	}else{
		jQuery("#" + fieldid + "wrapspan").e8Browser({
		   name:fieldid,
		   viewType:"1",
		   browserValue: detaibrowshowid,
		   browserSpanValue: detaibrowshowname,
		   browserOnClick : detailbrowclick,
		   hasInput: hasinput,
		   isSingle: isSingle,
		   hasBrowser: true, 
		   isMustInput: isdemand,
		   completeUrl: completeUrl,
		   width: "100%",
		   linkUrl:linkUrl,
		   needHidden: false,
		   onPropertyChange: onPropertyChange,
		   hasAdd: hasAdd,
		   addOnClick: addOnClick,
		   hiddenNotAssign:1
		});
	}
}

/**
 * 角色人员
 */
function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;
	//id1 = window.showModalDialog(url);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = null;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1) {
			if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
					&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
				
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				var sHtml = "";
				
				if (resourceids.indexOf(",") == 0) {
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
				}
				var idArray = resourceids.split(",");
				var nameArray = resourcename.split(",");
				for ( var _i = 0; _i < idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
	
					sHtml += wrapshowhtml0($G("field" + id).getAttribute("viewtype"), 
							"<a title='" + curname + "' href='" + linkurl + 
							curid + "' target='_new'>" + curname + "</a>&nbsp", curid);
				}
	
				//$GetEle("field" + id + "span").innerHTML = sHtml;
				jQuery($GetEle("field" + id + "span")).html(sHtml);
				$GetEle("field" + id).value = resourceids;
				hoverShowNameSpan(".e8_showNameClass");
				try {
					if(!isIE()) {
						var onppchgfnstr = jQuery("#field" + id).attr('onpropertychange');
						eval(onppchgfnstr);
						if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
							onpropertychange();
						}
					}
				} catch (e) {
				}
				try {
					var onppchgfnstr = jQuery("#field" + id + "__").attr('onpropertychange').toString();
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
			} else {
				if (ismand == 0) {
					$GetEle("field" + id + "span").innerHTML = "";
				} else {
					$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
				}
				$GetEle("field" + id).value = "";
			}
			var _ismand = $G("field"+id).getAttribute("viewtype");
			if ($GetEle("field" + id).value == "") {
				if (_ismand == 0) {
					jQuery($GetEle("field"+id+"spanimg")).html("");
				} else {
					jQuery($GetEle("field"+id+"spanimg")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				}
			} else {
				jQuery($GetEle("field"+id+"spanimg")).html("");
			}
		}
	
	};
	try{
		dialog.Title = SystemEnv.getHtmlNoteName(3418,languageid);
	}catch(e){
		dialog.Title = SystemEnv.getHtmlNoteName(3418,languageid);
	}
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){
  		dialog.Width=648;
  }
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}

/**
 * 人力资源条件
 */
function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {
	var tmpids = $GetEle("field" + id).value;
	//var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = null;
	
	dialog.URL = url + "?resourceCondition=" + tmpids;
	dialog.callbackfun = function (paramobj, dialogId) {
	
		if (dialogId) {
			if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
				var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
				var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
				var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
				var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
				var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
				var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
				var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
				var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);
	
				var sHtml = "";
				var fileIdValue = "";
				
				var shareTypeValueArray = shareTypeValues.split("~");
				var shareTypeTextArray = shareTypeTexts.split("~");
				var relatedShareIdseArray = relatedShareIdses.split("~");
				var relatedShareNameseArray = relatedShareNameses.split("~");
				var rolelevelValueArray = rolelevelValues.split("~");
				var rolelevelTextArray = rolelevelTexts.split("~");
				var secLevelValueArray = secLevelValues.split("~");
				var secLevelTextArray = secLevelTexts.split("~");
				for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
					var shareTypeValue = shareTypeValueArray[_i];
					var shareTypeText = shareTypeTextArray[_i];
					var relatedShareIds = relatedShareIdseArray[_i];
					var relatedShareNames = relatedShareNameseArray[_i];
					var rolelevelValue = rolelevelValueArray[_i];
					var rolelevelText = rolelevelTextArray[_i];
					var secLevelValue = secLevelValueArray[_i];
					var secLevelText = secLevelTextArray[_i];
					if (shareTypeValue == "") {
						continue;
					}
					fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
							+ relatedShareIds + "_" + rolelevelValue + "_"
							+ secLevelValue;
					
					if(shareTypeValue == "2" || shareTypeValue == "3" || shareTypeValue == "4" || shareTypeValue == "5"){
						if(secLevelValue.indexOf("|@|") > -1){
							var arraylevel = secLevelValue.split("|@|");
							secLevelValue = arraylevel[0]+"-"+arraylevel[1];
						}
					}
					
					if (shareTypeValue == "1") {
						sHtml = sHtml + "," + shareTypeText + "("
								+ relatedShareNames + ")";
					} else if (shareTypeValue == "2") {
                        sHtml = sHtml
                                + ","
                                + shareTypeText
                                + "("
                                + relatedShareNames
                                + ")";
                                
                        if(typeof js_hrmResourceShow == 'undefined' || js_hrmResourceShow != 2){
	                        sHtml += SystemEnv.getHtmlNoteName(4095,languageid)
	                                + secLevelValue
	                                + SystemEnv.getHtmlNoteName(4094,languageid);
                        }
					} else if (shareTypeValue == "3") {
                        sHtml = sHtml
                                + ","
                                + shareTypeText
                                + "("
                                + relatedShareNames
                                + ")";
                                
                        if(typeof js_hrmResourceShow == 'undefined' || js_hrmResourceShow != 2){
	                        sHtml += SystemEnv.getHtmlNoteName(4095,languageid)
	                                + secLevelValue
	                                + SystemEnv.getHtmlNoteName(4093,languageid);
                        }
					} else if (shareTypeValue == "4") {
                        sHtml = sHtml
                                + ","
                                + shareTypeText
                                + "("
                                + relatedShareNames
                                + ")";
                        if(typeof js_hrmResourceShow == 'undefined' || js_hrmResourceShow != 2){
	                        sHtml += SystemEnv.getHtmlNoteName(4090,languageid)+"="
	                                + rolelevelText
	                                + SystemEnv.getHtmlNoteName(4095,languageid)
	                                + secLevelValue
	                                + SystemEnv.getHtmlNoteName(4092,languageid);
                        }
					} else if (shareTypeValue == "5") {//所有人
                        if(typeof js_hrmResourceShow == 'undefined' || js_hrmResourceShow != 2){
	                        sHtml = sHtml
	                                + ","
	                                + SystemEnv.getHtmlNoteName(4095,languageid)
	                                + secLevelValue
	                                + SystemEnv.getHtmlNoteName(4091,languageid);
                        }else{
                            sHtml = sHtml
                                    + ","
                                    + shareTypeText;
                        }
					} else if (shareTypeValue == "6") {//岗位
						sHtml = sHtml + "," + shareTypeText + "("
						+ relatedShareNames + ")";
					}
	
				}
				
				sHtml = sHtml.substr(1);
				fileIdValue = fileIdValue.substr(1);
	
				$GetEle("field" + id).value = fileIdValue;
				$GetEle("field" + id + "span").innerHTML = sHtml;

                if (!!$GetEle("field" + id + "spanimg")) {
                        $GetEle("field" + id + "spanimg").innerHTML = "";
                }
			} else {
				if (ismand == 0) {
					$GetEle("field" + id + "span").innerHTML = "";
					if (!!$GetEle("field" + id + "spanimg")) {
                        $GetEle("field" + id + "spanimg").innerHTML = "";
                	}
				} else {
					if (!!$GetEle("field" + id + "spanimg")) {
                    	$GetEle("field" + id + "spanimg").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                    	$GetEle("field" + id + "span").innerHTML = "";
					} else {
						$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
				}
				$GetEle("field" + id).value = "";
		    }
		}
	}; 
	try{
		dialog.Title = SystemEnv.getHtmlNoteName(3418,languageid);
	}catch(e){
		dialog.Title =	SystemEnv.getHtmlNoteName(3418,languageid);
	}
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){
  		dialog.Width=648;
  }
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}
//var resourceMap = new Map();

var browUtil = {
	saveBrowData : function (fieldid, jsonsdata, ids) {
	    //resourceMap.put(fieldid, jsonsdata);
	    //resourceMap.put(fieldid + "_back", ids);
	}, 
	deleteBrowData : function (fieldid) {
		//resourceMap.remove(fieldid);
		//resourceMap.remove(fieldid + "_back");
	},
	getBrowData : function (fieldid) {
		var _jefield = jQuery("#field" + fieldid);
		
		if (_jefield.length == 0) {
			return [];
		}
		
		var elevalue = _jefield.val();
		
		if (elevalue == '') {
			return [];
		}
		var resultparam = "";
		//返回值
		var result = [];
		
		var _jefieldgroup = jQuery("#outfield" + fieldid + "div").find("input[name=field" + fieldid + "_group]");
		for (var i=0; i<_jefieldgroup.length; i++) {
			var element = _jefieldgroup[i];
			//结构 type|typeid|ids
			var _jefieldval = jQuery(element).val();
			var _jefieldvalArray = _jefieldval.split("|");
			
			var _type = _jefieldvalArray[0];
			var _typeid = _jefieldvalArray[1];
			var _ids = _jefieldvalArray[2];
						
			var _index = ("," + elevalue + ",").indexOf("," + _ids + ",");
			if (_index != -1) {
				var _gbefore = ("," + elevalue + ",").substring(0, _index);
				var _gbeafter = ("," + elevalue + ",").substr(_index + ("," + _ids + ",").length);
				
				var _itemids = _ids.split(",");
				//item项
				var _tem = {type:_type, typeid:_typeid, ids:_itemids};
				result.push(_tem);
				
				elevalue = _gbefore + ",|" + i + "|," + _gbeafter;
			}
		}
		var _itemids = elevalue.split(",");
		
		for (var i=0; i<_itemids.length; i++) {
			var __val = _itemids[i];
			if (__val == '') {
				continue;
			}
			
			if (__val.indexOf("|") != -1) {
				__val = __val.substring(1, __val.length - 1);
				
				var gitem = result[__val];
				
				var gitype = gitem.type;
				var gitypeid = gitem.typeid;
				var giids = gitem.ids;
				
				var bz = "";
				if (gitype == '2' || gitype == '5') {
					bz = "subcom";
				} else if (gitype == '3' || gitype == '7') {
					bz = "dept";
				} else if (gitype == '4') {
					bz = "group";
				}
				
				resultparam += "," + bz + "_" + gitypeid;
				continue;
			}
			resultparam += "," + __val;
			//var idsarray = [];
			//idsarray.push(__val);
			//item项
			//var _tem = {type:1, typeid:0, ids:idsarray};
			//result.push(_tem);
			
		}
		return resultparam;
	},
	getBrowData2 : function (fieldid) {
		var _jefield = jQuery("#field" + fieldid);
		
		if (_jefield.length == 0) {
			return [];
		}
		
		var elevalue = _jefield.val();
		
		if (elevalue == '') {
			return [];
		}
		
		//返回值
		var result = [];
		
		var _jefieldgroup = jQuery("#outfield" + fieldid + "div").find("input[name=field" + fieldid + "_group]");
		for (var i=0; i<_jefieldgroup.length; i++) {
			var element = _jefieldgroup[i];
			//结构 type|typeid|ids
			var _jefieldval = jQuery(element).val();
			var _jefieldvalArray = _jefieldval.split("|");
			
			var _type = _jefieldvalArray[0];
			var _typeid = _jefieldvalArray[1];
			var _ids = _jefieldvalArray[2];
			
			var _index = ("," + elevalue + ",").indexOf("," + _ids + ",");
			if (_index != -1) {
				var _gbefore = ("," + elevalue + ",").substring(0, _index);
				var _gbeafter = ("," + elevalue + ",").substr(_index + ("," + _ids + ",").length);
				
				var _itemids = _ids.split(",");
				//item项
				var _tem = {type:_type, typeid:_typeid, ids:_itemids};
				result.push(_tem);
				
				elevalue = _gbefore + "," + _gbeafter;
			}
		}
		var _itemids = elevalue.split(",");
		
		for (var i=0; i<_itemids.length; i++) {
			var __val = _itemids[i];
			if (__val != '') {
				var idsarray = [];
				idsarray.push(__val);
				//item项
				var _tem = {type:1, typeid:0, ids:idsarray};
				result.push(_tem);
			}
		}
		return result;
	},
	//备份ids，
	getBrowBackData : function (fieldid) {
		return resourceMap.get(fieldid + "_back");
	},
	//解析返回的json数据
	paserBrowData : function (jsonsdata, viewtype, fieldid) {
		var ids = "";
		var sHtml = "";
		for (var _i=0; _i<jsonsdata.length; _i++) {
			var _item = jsonsdata[_i];
			
			var _title = _item.title;
			var _type = _item.type;
			var _typeid = _item.typeid;
			var _ids = array2string(_item.ids);
			var _names = array2string(_item.names);
			var _jobtitles = array2string(_item.jobtitle);
			
			ids += "," + _ids;
			//单个人力资源
			if (_type == 1) {
				sHtml += wrapshowhtml0(viewtype, "<a href=javaScript:openhrm(" + _ids + "); onclick='pointerXY(event);'>" + _title + "</a>&nbsp", _ids);
			} else if (_type == 2 || _type == 3 || _type == 4 || _type == 5 || _type == 7) { //分部/部门/公共组/虚拟组织
			    //生成隐藏域，用于提交至后台保存
				sHtml += wrapshowhtml0(viewtype, "<a href='javascript:void 0;' onclick='showDetail(this, " + fieldid + ");' _ids='" + _ids + "' _names='" + _names + "' _jobtitles='" + _jobtitles + "'><input type='hidden' name='field" + fieldid + "_group' value='" + _type + "|" +  _typeid + "|" + _ids + "'/> " + _title + "(" + _item.ids.length +" "+SystemEnv.getHtmlNoteName(3654,languageid)+")</a>&nbsp", _ids);
			}
		}
		
		if (ids.length > 1) {
			ids = ids.substr(1);
		}
		return {id:ids, html:sHtml};
	}
}

function showDetail(targetele, fieldid) {
	showAutoCompleteDiv(targetele, fieldid);
}

jQuery(function () {
	jQuery("html").live('mouseup', function (e) {
		if (jQuery("#__brow__detaildiv").is(":visible") && !!!jQuery(e.target).closest("#__brow__detaildiv")[0]) {
			jQuery("#__brow__detaildiv").hide();
		}
		if (jQuery("#_browcommgroupblock").is(":visible") && !!!jQuery(e.target).closest("#_browcommgroupblock")[0]) {
			jQuery("#_browcommgroupblock").hide();
		}
		
		e.stopPropagation();
	});
	jQuery(".resAddGroupClass").attr("title", SystemEnv.getHtmlNoteName(3649,languageid));
	
	if (isIE()) {
		jQuery("a").live("click", function () {
			window.__aeleclicktime = new Date().getTime();
		});
	}
});

/**
 * 显示分部、部门下的人员
 */
function showAutoCompleteDiv(ele, fieldid){

	jQuery("#__brow__detaildiv").remove();

	var target = jQuery(ele);
	var offset = target.offset();
	var __x = offset.left - 225/2 +  jQuery(ele).width()/2;
	var __y = offset.top + 10;
	if (jQuery(ele).height() > 20) {
		__x = offset.left - 225/2 + 5;
		__y = offset.top + 30;
	} 
	
	
	var separator = ",";
	
	var _ids = target.attr("_ids");
	var _names = target.attr("_names");
	var _jobtitles = target.attr("_jobtitles");
	
	var _idArray = _ids.split(separator);
	var _nameArray = _names.split(separator);
	var _jobtitleArray = _jobtitles.split(separator);
	var browgroupHtml = "";
	var _i;
	for (_i=0; _i<_idArray.length; _i++) {
		var className=(_i%2==1?"ac_even":"ac_odd");
		var displaycss = _i > 4 ? " display:none; " : "";
		var resdetailinfohtml = "<span style='display:inline-block;width:80px;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;'><a href=javaScript:openhrm(" + _idArray[_i] + "); onclick='pointerXY(event);' style='overflow: hidden;white-space: nowrap;text-overflow: ellipsis;' title='" + _nameArray[_i] + "'>" + _nameArray[_i] + "</a></span>";
		resdetailinfohtml += "<span style='float:right;display:inline-block;width:130px;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;' title='" + _jobtitleArray[_i] + "'>" + _jobtitleArray[_i] + "</span>";
		
		browgroupHtml += '<li class="'+className+'" _id="'+_idArray[_i]+'" style=\'' + displaycss + '\'>' + resdetailinfohtml +'</li>';
		
		
		
		if (_i > 4 && _i == _idArray.length-1) {
			browgroupHtml += '<li class="'+className+'" title="显示全部" style="text-align:center;" onclick="showalldetail(this, ' + fieldid + ');">显示全部</li>';
		}
	}
	
	if(!!browgroupHtml){
		var autoCompleteDiv = jQuery("<div id='__brow__detaildiv'' style=\"position:absolute;width:225px;z-index:999;left:" + __x + "px;top:" + __y + "px;\"></div>");
		var autoCompleteDiv_html = jQuery("<div class=\"arrowsblock\"><img src=\"/images/ecology8/workflow/multres/arrows_2_wev8.png\" width=\"22px\" height=\"22px\"></div>"
			+ "<div class='ac_results' style='margin-top:20px;background:#fff;z-index:9;'><ul>"+browgroupHtml+"</ul></div>"
		);
		autoCompleteDiv.append(autoCompleteDiv_html);
		//autoCompleteDiv_html.addClass("ac_results");
		jQuery(document.body).append(autoCompleteDiv);
	}
}

/**
 * 显示所有人员（默认显示6个）
 */
function showalldetail(ele, fieldid) {
	var target = jQuery(ele);
	var parentDiv = target.closest("div");
	parentDiv.css({
	    "height":parentDiv.height() + "px",
		"overflow" : "auto"
	});
	
	parentDiv.perfectScrollbar({horizrailenabled:false,zindex:1000});
	
	var othli = target.parent().children().not(":visible");
	othli.show();
	target.hide();
}


/**
 * 多人力资源浏览框显示常用组
 */
function showrescommongroup(ele, fieldid, isinit) {
	var target = jQuery(ele);
	var __x = 0;
	var __y = 0;
	if (!!ele) {
		var offset = target.offset();
		__x = offset.left - 234/2 + target.width()/2;
		__y = offset.top + 30;
	}
	
    var userid=$G("f_weaver_belongto_userid").value;
    var usertype=$G("f_weaver_belongto_usertype").value;
	
	if (isinit == true) {
		jQuery("#_browcommgroupblock").remove();
		__isNotGroupFirstInit = false;
	}
	
	if (!!jQuery("#_browcommgroupblock")[0] && !!ele) {
		initgroupinfo(userid, usertype);
		jQuery("#_browcommgroupblock").find("#_cg_currentField").val(fieldid);
		jQuery("#_browcommgroupblock").css({"left":__x+"px", top:__y+"px"});
		jQuery("#_browcommgroupblock").show();
		
		var hideli = jQuery("#_browcommgroupcontentblock ul li[_isdefaulthide=1]").hide();
		jQuery("#_browcommgroupcontentblock").css("height", "");
		jQuery("#_browcommgroupcontentblock").css("overflow-y", "hidden");
		//jQuery("#cg_displayallbtn").show();
		if (jQuery("#_browcommgroupcontentblock li").length > 3) {
			jQuery("#cg_displayallbtn").css("visibility", "visible");
		}
		return;
	}

	var ids = "";
	var sHtml = "";
	var browgroupHtml = "";
	//var userid=$G("f_weaver_belongto_userid").value;
	//var usertype=$G("f_weaver_belongto_usertype").value;
	
	//browgroupHtml += "<li title='所有人' _ids='' _names='' _jobtitles='' style='height:22px;margin:5 0px;'><span style='color:#000;'>所有人（10323人）</span></li>";
	
	//browgroupHtml += "<li class='grploadding'>正在加载...</li>"
	 try{
    var _grouphtml = "<input type=\"hidden\" id=\"_cg_currentField\" value=\"" + fieldid + "\">"
    					+ "<div class=\"arrowsblock1\"><img src=\"/images/ecology8/workflow/multres/arrows_wev8.png\" width=\"22px\" height=\"22px\"></div>"
                        + "<div style=\"background:#fff;\" class=\"cg_block\">"
                        + "    <ul id=\"cg_allresul\">"
                        /*
                        + "        <li class=\"cg_allresli cg_item\" onclick=\"addcg2brow(this, 1)\">"
                        + "            <span class=\"cg_title\" style=\"\">所有人（0人）</span>"
                        + "        </li>"
                        + "        <div class=\"cg_splitline\"></div>"
                        */
                        + "    </ul>"
                        + "    <div id=\"_browcommgroupcontentblock\" style='z-index:9;'>"
                        + "        <ul>"
                        + "            <li class=\"\">"
                        + "                <img src=\"/images/ecology8/workflow/multres/cg_lodding_wev8.gif\" height=\"27px\" width=\"57px\" style=\"vertical-align:middle;\"/><span class=\"cg_title\" style=\"\">"+SystemEnv.getHtmlNoteName(3650,languageid)
                        + "            </li>"
                        + "        </ul>"
                        + "    </div>"
                        + "    <div class=\"cg_splitline\" ></div>"
                        + "    <ul>"
                        + "     <li >"
                        + "            <div class=\"cg_optblock\">"
                        + "              <span class=\"cg_btn\" id=\"cg_displayallbtn\" onclick=\"cgdisplayall(this)\" style='visibility:hidden;'>"
                        + "                    <img src=\"/images/ecology8/workflow/multres/cg_exp_wev8.png\" height=\"16px\" width=\"16px\" style=\"vertical-align:middle;margin-top:-5px;\"/>"+SystemEnv.getHtmlNoteName(3407,languageid)
                        + "                </span>"
                        + "                <span class=\"cg_btn\" style=\"float:right;\" id=\"cg_addcgbtn\" onclick='doAdd();'>"
                        + "                    <img src=\"/images/ecology8/workflow/multres/cg_add_wev8.png\" height=\"16px\" width=\"16px\"  style=\"vertical-align:middle;margin-top:-3px;\"/>"+SystemEnv.getHtmlNoteName(3651,languageid)
                        + "                </span>"
                        + "            </div>"
                        + "        </li>"
                        + "    </ul>"
                        + "</div>";
	 }catch(e){
	   var _grouphtml = "<input type=\"hidden\" id=\"_cg_currentField\" value=\"" + fieldid + "\">"
    					+ "<div class=\"arrowsblock1\"><img src=\"/images/ecology8/workflow/multres/arrows_wev8.png\" width=\"22px\" height=\"22px\"></div>"
                        + "<div style=\"background:#fff;\" class=\"cg_block\">"
                        + "    <ul id=\"cg_allresul\">"
                        /*
                        + "        <li class=\"cg_allresli cg_item\" onclick=\"addcg2brow(this, 1)\">"
                        + "            <span class=\"cg_title\" style=\"\">所有人（0人）</span>"
                        + "        </li>"
                        + "        <div class=\"cg_splitline\"></div>"
                        */
                        + "    </ul>"
                        + "    <div id=\"_browcommgroupcontentblock\" style='z-index:9;'>"
                        + "        <ul>"
                        + "            <li class=\"\">"
                        + "                <img src=\"/images/ecology8/workflow/multres/cg_lodding_wev8.gif\" height=\"27px\" width=\"57px\" style=\"vertical-align:middle;\"/><span class=\"cg_title\" style=\"\">"+SystemEnv.getHtmlNoteName(82857,languageid)
                        + "            </li>"
                        + "        </ul>"
                        + "    </div>"
                        + "    <div class=\"cg_splitline\" ></div>"
                        + "    <ul>"
                        + "     <li >"
                        + "            <div class=\"cg_optblock\">"
                        + "              <span class=\"cg_btn\" id=\"cg_displayallbtn\" onclick=\"cgdisplayall(this)\" style='visibility:hidden;'>"
                        + "                    <img src=\"/images/ecology8/workflow/multres/cg_exp_wev8.png\" height=\"16px\" width=\"16px\" style=\"vertical-align:middle;margin-top:-5px;\"/>"+SystemEnv.getHtmlNoteName(332,languageid)
                        + "                </span>"
                        + "                <span class=\"cg_btn\" style=\"float:right;\" id=\"cg_addcgbtn\" onclick='doAdd();'>"
                        + "                    <img src=\"/images/ecology8/workflow/multres/cg_add_wev8.png\" height=\"16px\" width=\"16px\"  style=\"vertical-align:middle;margin-top:-3px;\"/>"+SystemEnv.getHtmlNoteName(124815,languageid)
                        + "                </span>"
                        + "            </div>"
                        + "        </li>"
                        + "    </ul>"
                        + "</div>";
	 }
    var commongroupDiv = jQuery("<div id=\"_browcommgroupblock\" class=\"_browcommgroupblock\" style=\"display:none;z-index:1000;left:" + __x + "px;top:" + __y + "px;\"></div>");
    commongroupDiv.html(_grouphtml);
    jQuery(document.body).append(commongroupDiv);                 
	
	//<div style='clear:both;width:1px!importnat;height:1px!important;'></div>
	
}
var __isNotGroupFirstInit = false;
function initgroupinfo(userid, usertype) {
    if (!!__isNotGroupFirstInit) {
        return;
    }
    //是不是第一次加载
    __isNotGroupFirstInit = true;
     
    var browgroupHtml = "";
    jQuery.ajax({
        type: "get",
        cache: false,
        url: "/workflow/request/HrmGroupData.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+ usertype,
        dataType: "json",  
        contentType : "application/x-www-form-urlencoded;charset=UTF-8",
        complete: function(){
        },
        error:function (XMLHttpRequest, textStatus, errorThrown) {
        } , 
        success : function (data, textStatus) {
            var jsonsdata = eval(data);
            browgroupHtml = "";
            var _i = 0;
            var _j = 0;
            
            
            var allreshtml = "<li onclick=\"addcg2brow(this, 1)\" class=\"cg_allresli cg_item\">" 
                           + "    <input type='hidden' id='__allres__hidden' value='' _count=''/>"
                           + "    <span class=\"cg_title\" style=\"\">"+SystemEnv.getHtmlNoteName(3653,languageid)+"<span id='__allrescntinfoblock' _u='" + userid + "' _t='" + usertype + "' style='display:none;color:#808080;'>(获取信息&nbsp;&nbsp;<img src=\"/images/ecology8/workflow/multres/allresloadding_wev8.gif\" height=\"3px\" width=\"17px\" style=\"vertical-align:middle;\"/>&nbsp;&nbsp;)</span></span>"
                           + "</li>"
                           + "<div class=\"cg_splitline\"></div>";
            jQuery("#cg_allresul").html(allreshtml);
            
            for (_i=0; _i<jsonsdata.length; _i++) {
                var _item = jsonsdata[_i];
                
                var _title = _item.typename;
                var _type = _item.type;
                var _typeid = _item.typeid;
                var _ids = _item.ids;
                var _names = _item.names;
                var _jobtitles = _item.jobtitles;
                var idArray = _ids.split(",");
                //ids += "," + _ids;
                
                if (_type == 9) { //虚拟组织
                    /*
                    var allrescount = idArray.length;
                    var allreshtml = "<li onclick=\"addcg2brow(this, 1)\" class=\"cg_allresli cg_item\">" 
                                   + "    <input type='hidden' id='__allres__hidden' value='" + _ids + "' _count='" + allrescount + "'/>"
                                   + "    <span class=\"cg_title\" style=\"\">"+SystemEnv.getHtmlNoteName(3653,languageid)+"(" + allrescount +" "+SystemEnv.getHtmlNoteName(3654,languageid)+")</span>"
                                   + "</li>"
                                   + "<div class=\"cg_splitline\"></div>";
                    jQuery("#cg_allresul").html(allreshtml);
                    continue;
                    */
                }
                _j++;
                var displaycss = _j > 3 ? " display:none; " : "";
                
                var resdetailinfohtml = "<span class=\"cg_title\">" + _title + "（" + idArray.length + " "+SystemEnv.getHtmlNoteName(3654,languageid)+"）</span>";
                resdetailinfohtml += "<span class=\"cg_detail\">" + _names + "</span>";
                
                browgroupHtml += "<li onclick=\"addcg2brow(this, 2)\" class=\"cg_item\" _type='" + _type + "' _typeid='" + _typeid + "' _title='"+_title+"' _ids='" + _ids + "' _names='" + _names + "' _jobtitles='" + _jobtitles + "' style='" + displaycss + "'>" + resdetailinfohtml +"</li>";
                
                
            }
            if (_j > 3) {
                jQuery("#cg_displayallbtn").css("visibility", "visible");
            }
            
            jQuery("#_browcommgroupcontentblock ul").html(browgroupHtml);
        } 
    }); 
}


var __isNotAllResFirstInit = false;
function initAllResInfo(target, userid, usertype) {
    if (!!__isNotAllResFirstInit) {
        return;
    }
    //是不是第一次加载
    __isNotAllResFirstInit = true;
     
    var browgroupHtml = "";
    jQuery.ajax({
        type: "get",
        cache: false,
        url: "/workflow/request/HrmGroupData.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+ usertype + "&isgetallres=1",
        dataType: "json",  
        contentType : "application/x-www-form-urlencoded;charset=UTF-8",
        complete: function(){
        },
        error:function (XMLHttpRequest, textStatus, errorThrown) {
        } , 
        success : function (data, textStatus) {
            var jsonsdata = eval(data);
            var ids = jsonsdata.ids;
            var counts = jsonsdata.count;
            
            var allresinfohtml = SystemEnv.getHtmlNoteName(3653,languageid)+"(" + counts +" "+SystemEnv.getHtmlNoteName(3654,languageid)+")";
            var targetinput = target.parent().parent().children("#__allres__hidden");
            targetinput.val(ids);
            targetinput.attr("_count", counts);
            target.parent().html(allresinfohtml);
        } 
    }); 
}

jQuery(function () {
	try {
		showrescommongroup(null, 0);
	} catch (e) {}
});

/**
 * 添加组到浏览框中
 */
function addcg2brow(ele, flag) {

	separator = ",";
	
	var target = jQuery(ele);
	
	var fieldid = jQuery("#_cg_currentField").val();
	var viewtype = jQuery($GetEle("field" + fieldid)).attr("viewtype");
	var fieldvalue = jQuery($GetEle("field" + fieldid)).val();
	if (!!!fieldid || fieldid == '') {
		return;	
	}
	
	var clickcgid = "";
	
	var ids = fieldvalue;
	
	var sHtml = ""; 
	if (flag == 1) {
		var allreshdele = target.children("#__allres__hidden");
		var allresids = allreshdele.val();
		//动态加载所有人
		if (allresids == '') {
		    var loadobj = target.find("#__allrescntinfoblock");
		    loadobj.show();
		    initAllResInfo(loadobj, loadobj.attr("_u"), loadobj.attr("_t"));
		    return ;
		}
		
		ids = allresids;
		
		// 客户自定义验证方法， 返回false则不向下执行
		// 方法名：__browVal4CustomCheck
		// 参数： wfid, reqid, type, ids, names
		try {
			var __cutomfnrtn  = __browVal4CustomCheck("field" + fieldid, jQuery($G("workflowid")).val(),  jQuery($G("requestid")).val(), 17, ids, null);
			if (__cutomfnrtn == false) {
				return ;
			}
		} catch (_e852) {}
		
		//sHtml = "所有人（" + allreshdele.attr("_count") + "人）"
		sHtml = wrapshowhtml2(viewtype, "<a href='javascript:void 0;' title='"+SystemEnv.getHtmlNoteName(3653,languageid)+"（" + allreshdele.attr("_count") + " "+SystemEnv.getHtmlNoteName(3654,languageid)+"）'><input type='hidden' name='field" + fieldid + "_group' value='9|0|" + ids + "'/> "+SystemEnv.getHtmlNoteName(3653,languageid)+"（" + allreshdele.attr("_count") + " "+SystemEnv.getHtmlNoteName(3654,languageid)+"）</a>", ids, fieldid);
		//sHtml += wrapshowhtml0(viewtype, "<a href='javascript:void 0;' onclick='showDetail(this, " + fieldid + ");' _ids='" + _ids + "' _names='" + _names + "' _jobtitles='" + _jobtitles + "'><input type='hidden' name='field" + fieldid + "_group' value='" + _type + "|" +  _typeid + "|" + _ids + "'/> " + _title + "(" + _item.ids.length + "人)</a>&nbsp", _ids);
		jQuery($GetEle("field" + fieldid + "span")).html("");
		
		jQuery("#field" + fieldid + "_browserbtn").attr("disabled", "disabled");
		jQuery("#field" + fieldid + "_addbtn").attr("disabled", "disabled");
		try {		
			jQuery('#remarkShowBtn').attr("disabled", "disabled");
		} catch(e) {	}
	} else {
		//公共组信息
		var _ids = target.attr("_ids");
		var _names = target.attr("_names");
		var _jobtitles = target.attr("_jobtitles");
		var _title = target.attr("_title");
		var _type = target.attr("_type");
		var _typeid = target.attr("_typeid");
		
		var _idArray = _ids.split(separator);
		var _nameArray = _names.split(separator);
		//先验证是否已经添加了公共组
		//获取已经选择的组
		var othparam = browUtil.getBrowData2(fieldid);
		
		if (_type == 4 || _type ==6) {
			clickcgid = _typeid;
		}
		
		//var isexist = false;
		for (var _i=0; _i<othparam.length; _i++) {
			var _item = othparam[_i];
			
			var type = _item.type;
			var typeid = _item.typeid;
			//是公共组，且已经选择
			if (type == 4 && typeid == _typeid) {
				//isexist = true;
				jQuery("#_browcommgroupblock").hide();
				return;
			}
		}
		
		//公共组
		if (_type == 4) { 
		    //生成隐藏域，用于提交至后台保存
		    //ids += "," + _ids;
		    if (ids != '') {
				ids += "," + _ids;
			} else {
				ids = _ids;
			}
			sHtml = wrapshowhtml0(viewtype, "<a href='javascript:void 0;' onclick='showDetail(this, " + fieldid + ");' _ids='" + _ids + "' _names='" + _names + "' _jobtitles='" + _jobtitles + "'><input type='hidden' name='field" + fieldid + "_group' value='" + _type + "|" +  _typeid + "|" + _ids + "'/> " + _title + "(" + _idArray.length + " "+SystemEnv.getHtmlNoteName(3654,languageid)+ ")</a>&nbsp", _ids);
		}
		
		//私人组
		if (_type == 6) { 
			for (var _i=0; _i<_idArray.length; _i++) {
				if (("," + ids + ",").indexOf("," + _idArray[_i] + ",") == -1) {
					if (ids != '') {
						ids += "," + _idArray[_i];
					} else {
						ids = _idArray[_i];
					}
					sHtml += wrapshowhtml0(viewtype, "<a href=javaScript:openhrm(" + _idArray[_i] + "); onclick='pointerXY(event);'>" + _nameArray[_i] + "</a>&nbsp", _idArray[_i]);
				}
			}
		}
	}	
	
	// 客户自定义验证方法， 返回false则不向下执行
	// 方法名：__browVal4CustomCheck
	// 参数： wfid, reqid, type, ids, names
	try {
		var __cutomfnrtn  = __browVal4CustomCheck("field" + fieldid, jQuery($G("workflowid")).val(),  jQuery($G("requestid")).val(), 17, ids, null);
		if (__cutomfnrtn == false) {
			return ;
		}
	} catch (_e852) {}
	jQuery($GetEle("field" + fieldid + "span")).append(sHtml);
	$GetEle("field" + fieldid).value= ids;
	
	jQuery("#_browcommgroupblock").hide();
	
	hoverShowNameSpan(".e8_showNameClass");
	try {
		if(!isIE()) {
			var onppchgfnstr = jQuery("#field"+ fieldid).attr('onpropertychange');
			eval(onppchgfnstr);
			if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
				onpropertychange();
			}
		}
	} catch (e) {
	}
	try {
		var onppchgfnstr = jQuery("#field"+ fieldid + "__").attr('onpropertychange').toString();
		eval(onppchgfnstr);
		if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
			onpropertychange();
		}
	} catch (e) {
	}
	
	var _ismand = $G("field"+ fieldid).getAttribute("viewtype");
	if ($GetEle("field"+ fieldid).value == "") {
		//html模式相关文档，相关流程没有id号，所以生成input时，name不符合规范，没有viewtype属性，ismand为undefined
		if (_ismand == 0||!_ismand) {
			jQuery($GetEle("field"+ fieldid+"spanimg")).html("");
		} else {
			jQuery($GetEle("field"+ fieldid+"spanimg")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		}
	} else {
		jQuery($GetEle("field"+ fieldid+"spanimg")).html("");
	}
	//更新点击率，用于排序
	if (flag == 2 && clickcgid != '') {
		try {
			var ajaxUrl = "/workflow/request/commonGroupClickStatictics.jsp";
			ajaxUrl += "?groupid=";
			ajaxUrl += clickcgid;
			ajaxUrl += "&token=";
			ajaxUrl += new Date().getTime();
			
			jQuery.ajax({
			    url: ajaxUrl,
			    dataType: "text", 
			    contentType : "charset=UTF-8", 
			    error:function(ajaxrequest){}, 
			    success:function(content){
			    }  
		    });
		} catch (e) {}
	}
}
var __isperfectScrollbar = false;
/**
 * 显示所有组
 */
function cgdisplayall(ele) {
	var hideli = jQuery("#_browcommgroupcontentblock ul li").not(":visible");
	jQuery("#_browcommgroupcontentblock").css("height", jQuery("#_browcommgroupcontentblock").height() + "px");
	//jQuery("#_browcommgroupcontentblock").css("overflow-y", "auto");
	hideli.attr("_isdefaulthide", 1);
	hideli.show();
	//jQuery(ele).hide();
	jQuery(ele).css("visibility", "hidden");
	jQuery("#_browcommgroupcontentblock").perfectScrollbar({horizrailenabled:false,zindex:999});
	
} 
/**
 * 将Array转换为字符串
 */
function array2string(array, separator) {
	var result = "";
	if (!!!separator) {
		separator = ",";
	}
	try {
		if (!!array) {
			for (var _i=0; _i<array.length; _i++) {
				result += separator + array[_i];
			}
			if (result.length > 1) {
				result = result.substr(1);
			}
			return result;
		}
	} catch (e) {}
	
	return result;
}
function __resetBrow(fieldid) {
	jQuery("#field" + fieldid + "_browserbtn").attr("disabled", "");
	jQuery("#field" + fieldid + "_addbtn").attr("disabled", "");
	try {
		jQuery('#remarkShowBtn').attr("disabled", "");
	} catch(e) {}
	try {
		jQuery("#field" + fieldid + "_browserbtn").removeAttr("disabled");
		jQuery("#field" + fieldid + "_addbtn").removeAttr("disabled");
		jQuery('#remarkShowBtn').removeAttr("disabled");
	} catch (e) {}
	
}

function doOpen(url,title,_dWidth,_dHeight){
	jQuery("#_browcommgroupblock").hide();
	var __dialog = null;
	if(__dialog==null){
		__dialog = new window.top.Dialog();
	}
	__dialog.currentWindow = window;
	__dialog.Title = title;
	__dialog.Width = 550;
	__dialog.Height = 550;
	__dialog.Drag = true;
	__dialog.maxiumnable = true;
	__dialog.URL = url;
	__dialog.show();
	//showrescommongroup
}

function doAdd(){
	var languageid=readCookie("languageidweaver");
	var title = SystemEnv.getHtmlNoteName(4672,languageid);
	doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&isdialog=1",title);
	//doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&isdialog=1","新建自定义组");
}

/*
function Map() {    
    var struct = function(key, value) {    
        this.key = key;    
        this.value = value;    
    }
     
    var put = function(key, value){    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                this.arr[i].value = value;    
                return;    
            }    
        }    
        this.arr[this.arr.length] = new struct(key, value);    
    }    
         
    var get = function(key) {    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                return this.arr[i].value;    
            }    
        }    
        return null;    
    }    
         
    var remove = function(key) {    
        var v;    
        for (var i = 0; i < this.arr.length; i++) {    
            v = this.arr.pop();    
            if ( v.key === key ) {    
                continue;    
            }    
            this.arr.unshift(v);    
        }    
    }    
         
    var size = function() {    
        return this.arr.length;    
    }    
         
    var isEmpty = function() {    
        return this.arr.length <= 0;    
    }    
       
    this.arr = new Array();    
    this.get = get;    
    this.put = put;    
    this.remove = remove;    
    this.size = size;    
    this.isEmpty = isEmpty;    
}
*/

function triggerCallback(tgid) {
    try {
       var onppchgfnstr = jQuery("#"+ tgid + "__").attr('onpropertychange').toString();
       eval(onppchgfnstr);
       if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
           onpropertychange();
       }
    } catch (e) {
    }
}


function browAreaSelectCallback(data) {
    var _areaName = data.areaname;
    var _areaDataVal = data.id;
    var _fieldID = _areaName.replace(/areaselect_/g, "");
    $G(_fieldID).value = _areaDataVal;
}

function isChineseCharacter(s){ 
var patrn=/[\u4E00-\u9FA5]|[\uFE30-\uFFA0]/gi; 
if(!patrn.exec(s)){ 
return false; 
}
else{ 
return true; 
} 
}

