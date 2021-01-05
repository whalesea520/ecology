
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script type="text/javascript">
<!--
function onSelectMainDocument(){
	data = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if(data){
		if(data.id!=""){
			spanMainDocument.innerHTML = data.name;
			weaver.maindoc.value=data.id;
	    }else{
			spanMainDocument.innerHTML = "";
			weaver.maindoc.value = -1;
		}
	}
}

function onShowResource(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data){
	    if (data.id!=""){
			owneridspan.innerHTML = "<a href='javaScript:openhrm("+wuiUtil.getJsonValueByIndex(data,0)+");' onclick='pointerXY(event);'>"+wuiUtil.getJsonValueByIndex(data,1)+"</a>"
			weaver.ownerid.value=wuiUtil.getJsonValueByIndex(data,0)
			docdepartmentidspan.innerHTML = "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+wuiUtil.getJsonValueByIndex(data,2)+"'>"+wuiUtil.getJsonValueByIndex(data,3)+"</a>"
			weaver.docdepartmentid.value=wuiUtil.getJsonValueByIndex(data,2)
	    }else{
			owneridspan.innerHTML = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			weaver.ownerid.value=""
			docdepartmentidspan.innerHTML = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			weaver.docdepartmentid.value=""
	    }
	}
}
function onShowLanguage(){
	data = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	language.innerHTML = data.name
	weaver.doclangurage.value=data.id
}

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {

	var tmpids = $GetEle("customfield" + id).value;
	var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	if (wuiUtil.isNotEmpty(dialogId)) {
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
			shareTypeValues = shareTypeValues.substr(1);
			shareTypeTexts = shareTypeTexts.substr(1);
			relatedShareIdses = relatedShareIdses.substr(1);
			relatedShareNameses = relatedShareNameses.substr(1);
			rolelevelValues = rolelevelValues.substr(1);
			rolelevelTexts = rolelevelTexts.substr(1);
			secLevelValues = secLevelValues.substr(1);
			secLevelTexts = secLevelTexts.substr(1);

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

				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;

				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
				}

			}

			fileIdValue = fileIdValue + "~" + shareTypeValues + "_"
					+ relatedShareIdses + "_" + rolelevelValues + "_"
					+ secLevelValues;

			if (shareTypeValues == "1") {
				sHtml = sHtml + "," + shareTypeTexts + "("
						+ relatedShareNameses + ")";
			} else if (shareTypeValues == "2") {
				sHtml = sHtml
						+ ","
						+ shareTypeTexts
						+ "("
						+ relatedShareNameses
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValues
						+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
			} else if (shareTypeValues == "3") {
				sHtml = sHtml
						+ ","
						+ shareTypeTexts
						+ "("
						+ relatedShareNameses
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValues
						+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
			} else if (shareTypeValues == "4") {
				sHtml = sHtml
						+ ","
						+ shareTypeTexts
						+ "("
						+ relatedShareNameses
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
						+ rolelevelTexts
						+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValues
						+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
			} else {
				sHtml = sHtml
						+ ","
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValues
						+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
			}
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			$GetEle("customfield" + id).value = fileIdValue;
			$GetEle("customfield" + id + "span").innerHTML = sHtml;
		}
	} else {
		if (ismand == 0) {
			$GetEle("customfield" + id + "span").innerHTML = "";
		} else {
			$GetEle("customfield" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		}
		$GetEle("customfield" + id).value = "";
	}
}

function onShowBrowser(id,url,linkurl,type1,ismand){
	if(type1== 2 || type1 == 19){
		id1 = window.showModalDialog(url)
		document.all("customfield"+id+"span").innerHTML = id1.name
		document.all("customfield"+id).value=id1.id
	}else if(type1 == 141){
		onShowResourceConditionBrowser(id,url,linkurl,type1,ismand);
	}else{
		if(type1==143){
			tmpids = document.all("customfield"+id).value;
			id1 = window.showModalDialog(url+"?treeDocFieldIds="+tmpids);
		}else if(type1 != 171 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=142 && type1!=152 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=162){
			id1 = window.showModalDialog(url);
		}else if(type1==142){
			tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url+"?receiveUnitIds="+tmpids);
		}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
			tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else if(type1==162){
			tmpids = document.all("customfield"+id).value;
			url = url + "&beanids=" + tmpids;
			url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
			id1 = window.showModalDialog(url);
		}else{
			tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}

		if(id1){
			if(type1 == 171 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1 == 142 || type1 == 168 || type1 == 166){
				if(id1.id!=0 && id1.id!=""){
					resourceids = id1.id
					resourcename = id1.name
					sHtml = ""
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					//resourceids = Mid(resourceids,2,len(resourceids))
					document.all("customfield"+id).value= resourceids
					//resourcename = Mid(resourcename,2,len(resourcename))
					resourceids = resourceids.split(",");
					resourcename = resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]!=""){
							sHtml = sHtml+"<a target='_blank' href="+linkurl+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
						}
					}
					
					//sHtml = sHtml+"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHTML = sHtml
					
				}else{
					if (ismand==0){
						document.all("customfield"+id+"span").innerHTML = "";
					}else{
						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					document.all("customfield"+id).value=""
					
				}
			}else if(type1 == 152){
				if(id1.id!=0 && id1.id!=""){
					resourceids = id1.id
					resourcename = id1.name
					sHtml = ""
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					//resourceids = Mid(resourceids,2,len(resourceids))
					document.all("customfield"+id).value= resourceids
					//resourcename = Mid(resourcename,2,len(resourcename))
					resourceids = resourceids.split(",");
					resourcename = resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]!=""){
							sHtml = sHtml+"<a target='_blank' href="+linkurl+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
						}
					}
					
					//sHtml = sHtml+"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHTML = sHtml
				}else{
					if (ismand==0){
						document.all("customfield"+id+"span").innerHTML = "";
					}else{
						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					document.all("customfield"+id).value=""
				}
			}else if(type1 == 143){
				if(id1.id!=0 && id1.id!=""){
					resourceids = id1.id
					resourcename = id1.name
					sHtml = ""
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					//resourceids = Mid(resourceids,2,len(resourceids))
					document.all("customfield"+id).value= resourceids
					//resourcename = Mid(resourcename,2,len(resourcename))
					resourceids = resourceids.split(",");
					resourcename = resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]!=""){
							sHtml = sHtml+"<a target='_blank' href="+linkurl+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
						}
					}
					
					//sHtml = sHtml+"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHTML = sHtml
				}else{
					if (ismand==0){
						document.all("customfield"+id+"span").innerHTML = "";
					}else{
						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					document.all("customfield"+id).value=""
				}
		
			}else{
				if(id1.id!=0 && id1.id!=""){
	               if (type1 == 162) {
				   		var ids = id1.id;
						var names =  id1.name;
						var descs =  id1.key3;
						sHtml = ""
						ids = ids.substr(1);
						document.all("customfield"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						document.all("customfield" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = id1.id;
					   	var names = id1.name;
						var descs =  id1.desc;
						document.all("customfield"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						document.all("customfield" + id + "span").innerHTML = sHtml;
						return ;
				   }

					 if (linkurl == ""){
						document.all("customfield"+id+"span").innerHTML = id1.name
					 }else{
						document.all("customfield"+id+"span").innerHTML = "<a target='_blank' href="+linkurl+id1.id+">"+id1.name+"</a>"
					 }
					document.all("customfield"+id).value=id1.id
				}else{
					if (ismand==0){
						document.all("customfield"+id+"span").innerHTML = "";
					}else{
						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					document.all("customfield"+id).value=""
				}

			}
		}
	}
}


function onShowHrmresID(objval){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data){
		if (data.id!=""){
			hrmresspan.innerHTML = "<A href='javaScript:openhrm("+data.id+");' onclick='pointerXY(event);'>"+data.name+"</A>"
			weaver.hrmresid.value=data.id

		}else{
			if (objval=="2"){
				hrmresspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			}else{
				hrmresspan.innerHTML =""
			}
			weaver.hrmresid.value=""
		}
	}
}



function onShowAssetId(objval){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if (data){
		if(data.id!=""&&data.id!=0){
		assetidspan.innerHTML = "<A href='/cpt/capital/CapitalBrowser.jsp?id="+data.id+"'>"+data.name+"</A>"
		weaver.assetid.value=data.id
		}else{
			if (objval=="2") {
					assetidspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			}else{
				assetidspan.innerHTML =""
			}
		//weaver.assetid.value="0"
			weaver.assetid.value=""
		}
	}
}

function onShowCrmID(objval){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (data){
		if (data.id!=""){
			crmidspan.innerHTML = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="+data.id+"'>"+data.name+"</A>"
			weaver.crmid.value=data.id
		}else{
			if (objval=="2") {
					crmidspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			}else{
				crmidspan.innerHTML =""
			}
			//weaver.crmid.value="0"
			weaver.crmid.value=""
		}
	}
}
function onShowItemID(objval){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if (data) {
		if (data.id!=""){
			itemspan.innerHTML = "<A href='/lgc/asset/LgcAsset.jsp?paraid="+data.id+"'>"+data.name+"</A>"
			weaver.itemid.value=data.id
		}else{
			if(objval=="2"){
				itemspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			}else{
				itemspan.innerHTML =""
			}
			//weaver.itemid.value="0"
			weaver.itemid.value=""
		}
	}
}

function onShowItemmaincategoryID(objval){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp")
	if (data){
		if (data.id!=""){
		itemmaincategorypan.innerHTML = data.name
		weaver.itemmaincategoryid.value=data.id
		}else{
			if (objval=="2"){
				itemmaincategorypan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			}else{
				itemmaincategorypan.innerHTML =""
			}
		//weaver.itemmaincategoryid.value="0"
			weaver.itemmaincategoryid.value=""
		}
	}
}
function onShowProjectID(objval){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (data){
		if (data.id!=""){
		projectidspan.innerHTML = "<A href='/proj/data/ViewProject.jsp?ProjID="+data.id+"'>"+data.name+"</A>"
		weaver.projectid.value=data.id
		}else{
			if (objval=="2"){
				projectidspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			}else{
				projectidspan.innerHTML =""
			}
			//weaver.projectid.value="0"
			weaver.projectid.value=""
		}
	}
}
function onShowMutiDummy(input,span){	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value)
	if(data){
	    if (data.id!=""){
	    	var ids = data.id.substring(1);
		    var names = data.name.substring(1);
			names=names.replace(/</g,"&lt;");
				names=names.replace(/>/g,"&gt;");
			dummyidArray=ids.split(",");
			dummynames=names.split(",");
			//dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 
			var sHtml="";
			
			for(var k=0;k<dummyidArray.length;k++){
				sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp"
			}
			
			input.value=ids
			span.innerHTML=sHtml
	    }else{			
			input.value=""
			span.innerHTML=""
	    }
	}
}
//-->
</script>

<script type='text/javascript' src='/dwr/interface/DocDwrUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language="javascript">
var checkresult = false;
var nowFunc = null;
var nowObj = null;
function checkCanSubmit(onFunc,onObj){
    var s = document.createElement("SCRIPT");
    document.getElementsByTagName("HEAD")[0].appendChild(s);
    s.src="DocCanSubmitCheck.jsp?docid=<%=docid%>";
    
	nowFunc = onFunc;
	nowObj = onObj;
}

function checkCanSubmitCallBack(data){
	if(data>0) {
		checkresult=false;
		alert("<%=SystemEnv.getHtmlLabelName(20411,user.getLanguage())%>");
	}
	else checkresult=true;
	
	if(checkresult&&nowFunc!=null)
		if(nowObj==null) eval(nowFunc+"()");
		else eval(nowFunc+"(nowObj)");
}

function checkDocMain(){

	if(document.weaver.docpublishtype!=null&&document.weaver.docpublishtype.value==2){
		return check_form(document.weaver,'docmain');
	} 
	return true;
}

function afterSaveValidate(){
	if(check_form(document.weaver,'<%=needinputitems%>')&&checkSubjectRepeated()&&checkDocMain()){
        /****###@2007-08-24 modify yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
        text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
        document.weaver.doccontent.innerText=text;
		***/
		//var editor_data = CKEDITOR.instances.doccontent.getData();
		//alert(editor_data);
		//console.log(jQuery("textarea[name='doccontent']"));
		var editor_data = ue.getContent();
	    jQuery("#doccontent").val(editor_data);
		//alert(jQuery("#doccontent").val());
		//FCKEditorExt.updateContent();
        document.weaver.operation.value='editsave';
		document.weaver.isSubmit.value='1';
		//var objSubmit;
		try{
			var objDraft=obj.parentNode.parentNode.parentNode.firstChild.nextSibling.firstChild.firstChild;
			objDraft.disabled = true ;

		    var objPreview=obj.parentNode.parentNode.parentNode.firstChild.nextSibling.nextSibling.firstChild.firstChild;
			objPreview.disabled = true ;
		}catch(e){}
		//TD8425 避免提交和草稿状态同时提交
        obj.disabled = true ;
        //Ext.getCmp("divContentTab").getBottomToolbar().disable();
        disableToolBar();
        //TD4213 增加提示信息  开始
		var content="<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>";
		showPrompt(content);
		
        //TD4213 增加提示信息  结束
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
		      document.weaver.submit();
    }
}

function onSave(obj){
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

		DocDwrUtil.ifCheckOutByCurrentUser(document.weaver.id.value,document.weaver.userId.value,
			{callback:function(result){
				if(result){

	if(!checkresult) return checkCanSubmit("onSave",obj);

	if(<%=!isPersonalDoc%>){
		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				return;
			}
			afterSaveValidate();
		});
	}else{
		afterSaveValidate();
	}	

	
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
					return;
				}
			  }
			}
		);
}

function afterDraftValidate(){
	if(check_form(document.weaver,'<%=needinputitems%>')&&checkSubjectRepeated()&&checkDocMain()){
        /*****###@2007-08-24 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
        text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
        document.weaver.doccontent.innerText=text;
		****/
		//FCKEditorExt.updateContent();

		//var editor_data = CKEDITOR.instances.doccontent.getData();
		var editor_data = ue.getContent();
	    jQuery("#doccontent").val(editor_data);
		
        //document.weaver.docstatus.value=0;
        document.weaver.operation.value='editdraft';

		try{
			var objSubmit=obj.parentNode.parentNode.parentNode.firstChild.firstChild.firstChild;
			objSubmit.disabled = true ;

		    var objPreview=obj.parentNode.parentNode.parentNode.firstChild.nextSibling.nextSibling.firstChild.firstChild;
			objPreview.disabled = true ;
		}catch(e){}
		//TD8425 避免提交和草稿状态同时提交
        obj.disabled = true ;
		//Ext.getCmp("divContentTab").getBottomToolbar().disable();
		disableToolBar();
        //TD4213 增加提示信息  开始
		var content="<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>";
		showPrompt(content);
        //TD4213 增加提示信息  结束
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
        document.weaver.submit();
	}
}

function onDraft(obj){
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

		DocDwrUtil.ifCheckOutByCurrentUser(document.weaver.id.value,document.weaver.userId.value,
			{callback:function(result){
				if(result){

	if(!checkresult) return checkCanSubmit("onDraft",obj);

	if(<%=!isPersonalDoc%>){
		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				return;
			}
			afterDraftValidate();
		});
	}else{
		afterDraftValidate();
	}

	
	
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
					return;
				}
			  }
			}
		);
}

function afterPreviewValidate(){
	if(check_form(document.weaver,'<%=needinputitems%>')&&checkSubjectRepeated()&&checkDocMain()){
        /****###@2007-08-24 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
        text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
        document.weaver.doccontent.value=text;
		****/
		//FCKEditorExt.updateContent();
		//var editor_data = CKEDITOR.instances.doccontent.getData();
		var editor_data = ue.getContent();
	    jQuery("#doccontent").val(editor_data);
        //document.weaver.docstatus.value=0;
        document.weaver.operation.value='editpreview';

		try{
			var objSubmit=obj.parentNode.parentNode.parentNode.firstChild.firstChild.firstChild;
			objSubmit.disabled = true ;

		    var objDraft=obj.parentNode.parentNode.parentNode.firstChild.nextSibling.firstChild.firstChild;
			objDraft.disabled = true ;
		}catch(e){}

        obj.disabled = true ;
   		//Ext.getCmp("divContentTab").getBottomToolbar().disable();
   		disableToolBar();
        //TD4213 增加提示信息  开始
		var content="<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>";
		showPrompt(content);
        //TD4213 增加提示信息  结束
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
        document.weaver.submit();
	}
}

function onPreview(obj){
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

		DocDwrUtil.ifCheckOutByCurrentUser(document.weaver.id.value,document.weaver.userId.value,
			{callback:function(result){
				if(result){

	if(!checkresult) return checkCanSubmit("onPreview",obj);

	if(<%=!isPersonalDoc%>){
		checkDocSubject($GetEle("docsubject"),function(){
			if($GetEle("namerepeated").value==1){
				return;
			}
			afterPreviewValidate();
		});
	}else{
		afterPreviewValidate();
	}

	
	
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
					return;
				}
			  }
			}
		);
}

function btndisabledtrue(){
	try{
		$GetEle("BUTTONbtn_save").disabled=true;
		$GetEle("BUTTONbtn_save").style.color='#cccccc';
	}catch(e){}
	try{
		$GetEle("BUTTONbtn_draft").disabled=true;
		$GetEle("BUTTONbtn_draft").style.color='#cccccc';
	}catch(e){}
	try{
		$GetEle("BUTTONbtn_preview").disabled=true;
		$GetEle("BUTTONbtn_preview").style.color='#cccccc';
	}catch(e){}
	try{
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
			if(window.frames["rightMenuIframe"].document.all.item(a).tagName == "BUTTON"){
				window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
			}
		}
	}catch(e){}
	try{
		parent.disableTabBtn();
	}catch(e){}

}

function btndisabledfalse(){
	try{
		$GetEle("BUTTONbtn_save").disabled=false;
		$GetEle("BUTTONbtn_save").style.color='';
	}catch(e){}
	try{
		$GetEle("BUTTONbtn_draft").disabled=false;
		$GetEle("BUTTONbtn_draft").style.color='';
	}catch(e){}
	try{
		$GetEle("BUTTONbtn_preview").disabled=false;
		$GetEle("BUTTONbtn_preview").style.color='';
	}catch(e){}

	try{
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
			if(window.frames["rightMenuIframe"].document.all.item(a).tagName == "BUTTON"){
				window.frames["rightMenuIframe"].document.all.item(a).disabled=false;
			}
		}
	}catch(e){}
	try{
		parent.enableTabBtn();	
	}catch(e){}
}

function onDelpic(imgid){
if(!checkresult) return checkCanSubmit("onDelpic",imgid);
if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")) {
<% if(SecCategoryComInfo.isEditionOpen(seccategory)&&doceditionid>0){ %>
	var trobj = document.getElementById("accessory_dsp_tr_"+imgid);
	trobj.parentElement.parentElement.deleteRow(trobj.rowIndex+1);
	trobj.parentElement.parentElement.deleteRow(trobj.rowIndex);
	document.weaver.deleteaccessory.value = document.weaver.deleteaccessory.value + "," + imgid;
<% } else { %>
	document.weaver.operation.value='delpic';
	document.weaver.delimgid.value=imgid;
	document.weaver.submit();
<% } %>
}
}

function onHtml(thiswin){
	if(document.weaver.doccontent.style.display==''){
		text = document.weaver.doccontent.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.doccontent.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		document.weaver.doccontent.style.display='';
		divifrm.style.display='none';
	}
}

accessorynum = 2 ;
function addannexRow()
{
	nrewardTR = $('rewardTR');
	nrewardTable = nrewardTR.parentElement.parentElement;
	oRow = nrewardTable.insertRow(nrewardTR.rowIndex);
	oRow.height=20;
	for(j=0; j<2; j++) {
		oCell = oRow.insertCell();
		switch(j) {
    		case 0:
						var sHtml = "<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>";
						oCell.innerHTML = sHtml;
						break;
        case 1:
        		oCell.colSpan = 3;
        		oCell.className = "field";
            //var sHtml = "<input class=InputStyle  type=file size=70 name='accessory"+accessorynum+"' onchange='accesoryChanage(this)'>(此目录下最大只能上传<%=maxUploadImageSize%>M/个的附件)";
            var sHtml = "<input class=InputStyle  type=file size=70 name='accessory"+accessorynum+"' onchange='accesoryChanage(this)'>(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=maxUploadImageSize%>M)";
            <%if (isPersonalDoc){%>
                sHtml = "<input class=InputStyle  type=file size=70 name='accessory"+accessorynum+"'>";
            <%}%>
						oCell.innerHTML = sHtml;
						break;
		}
	}
	accessorynum = accessorynum*1 +1;
	document.weaver.accessorynum.value = accessorynum ;

	oRow = nrewardTable.insertRow(nrewardTR.rowIndex);
	oRow.className = "Spacing";
	oCell = oRow.insertCell();
	oCell.colSpan = 2;
	oCell.className = "Line";
}

function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
    	if(e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>")
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
        else
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1);
	var fileLenthByK =  fileLenth/1024;
	var fileLenthByM =  fileLenthByK/1024;

	var fileLenthName;
	if(fileLenthByM>=0.1){
		fileLenthName=fileLenthByM.toFixed(1)+"M";
	}else if(fileLenthByK>=0.1){
		fileLenthName=fileLenthByK.toFixed(1)+"K";
	}else{
		fileLenthName=fileLenth+"B";
	}

    if (fileLenthByM><%=maxUploadImageSize%>) {
        //alert("所传附件为:"+fileLenthByM+"M,此目录下不能上传超过<%=maxUploadImageSize%>M的文件,如果需要传送大文件,请与管理员联系!");
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthName+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>");		
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.size=70;
    newObj.onchange=function(){accesoryChanage(this);};
    
    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode); 
}

function returnTrue(o){
	alert(o+'aaa');
	return;
}

function docCheckIn(docId) {
	//DocCheckInOutUtil.docCheckIn(docId,returnTrue);
	/*Ext.Ajax.request({
					url : '/docs/docs/DocDwrProxy.jsp' , 
					params : {
								 method : 'DocCheckInOutUtil.docCheckIn',
								 paras: docId
							 },
					method: 'POST',
					success: function ( result, request) {
						returnTrue(result.responseText.trim());
					},
					failure: function ( result, request) { 
						Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
					} 
				});*/
	jQuery.ajax({
		url:"/docs/docs/DocDwrProxy.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype,
		data:{
			 method : 'DocCheckInOutUtil.docCheckIn',
			 paras: docId
		},
		type:"post",
		success:function(data){
			return true;
		},
		error:function(xhr,error,e){
			top.Dialog.alert(error);
		}
	});
		
}
//document.getElementById('rightMenu').style.display = "none";
//showPrompt("<%=SystemEnv.getHtmlLabelName(18974,user.getLanguage())%>");
</script>


<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<!-- added by cyril on 20080610 for td8828-->
<script>
function checkChange(event) {
	//document.getElementById('ecology_verify_DIV').style.display = '';

	try{
		//FCKEditorExt.updateContent();
		var editor_data = CKEDITOR.instances.doccontent.getData();
		jQuery("#doccontent").val(editor_data);
	}catch(e){
	}

	if(!checkDataChange())
         event.returnValue="<%=SystemEnv.getHtmlLabelName(19006,user.getLanguage())%>";
}
   function wfchangetab(){    		
    	if(!checkDataChange()) {
    	  return true;
    	}else{
    	  return false;
    	}
    }
</script>
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 20080610 for td8828-->