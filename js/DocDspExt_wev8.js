/**TD12005 文档日志（日志记录回调函数）开始*/
function callbackWriteLog() {
	return;
}
/**TD12005 文档日志（日志记录回调函数）结束*/
function showMarkFunc(){
	ShowRevision();
	//Ext.getCmp('hide_id').hide()
	document.getElementById('hide_id').style.display = "none";
	//Ext.getCmp('dispaly_id').show()
	document.getElementById('dispaly_id').style.display = "block";
}
function hideMarkFunc(){
	ShowRevision();
	//Ext.getCmp('dispaly_id').hide()
	document.getElementById('dispaly_id').style.display = "none";
	//Ext.getCmp('hide_id').show()
	document.getElementById('hide_id').style.display = "block";
}

function WebSaveLocalWord(){
	var docsType=1;
	try{
		docsType=document.getElementById("WebOffice").WebObject.ProtectionType ;//为-1：未保护
	}catch(e){
		docsType=1;
	}
	if(docsType == -1){//未保护
		try{
			document.getElementById("WebOffice").WebSaveLocal();
			StatusMsg(document.getElementById("WebOffice").Status);
		}catch(e){}
	}else{//保护
		document.getElementById("WebOffice").WebSetProtect(false,"");	//解除保护
		try{
			document.getElementById("WebOffice").WebObject.AcceptAllRevisions();	//接受痕迹
		}catch(e){}
		document.getElementById("WebOffice").WebSetProtect(true,"");	//重新保护控件中的文档
		try{
			document.getElementById("WebOffice").WebSaveLocal();
			StatusMsg(document.getElementById("WebOffice").Status);
		}catch(e){}
		document.getElementById("WebOffice").WebSetProtect(false,"");	//解除保护
		try{
			document.getElementById("WebOffice").WebObject.Undo();	//撤销一步操作
		}catch(e){}
		document.getElementById("WebOffice").WebSetProtect(true,"");	//重新保护控件中的文档
	}
}
function WebSaveLocalExcel(){
	try{
		document.getElementById("WebOffice").WebSaveLocal();
		StatusMsg(document.getElementById("WebOffice").Status);
	}catch(e){}
}

//TD8873 End
function WebOpenLocal(){
	try{
		document.getElementById("WebOffice").WebOpenLocal();
		StatusMsg(document.getElementById("WebOffice").Status);
	}catch(e){}
}

function WebToolsVisible(ToolName,Visible){
	try{
		document.getElementById("WebOffice").WebToolsVisible(ToolName,Visible);
		StatusMsg(document.getElementById("WebOffice").Status);
	}catch(e){}
}

function WebToolsVisibleISignatureFalse(){
	try{
		document.getElementById("WebOffice").WebToolsVisible("iSignature","false");
	}catch(e){}
}

function WebToolsEnable(ToolName,ToolIndex,Enable){
	try{
		document.getElementById("WebOffice").WebToolsEnable(ToolName,ToolIndex,Enable);
		StatusMsg(document.getElementById("WebOffice").Status);
	}catch(e){}
}

function onChanageShowMode(){
	if(DocInfoWindow.style.display == ""){
		DocInfoWindow.style.display = "none";
	}else{
		DocInfoWindow.style.display = "";
	}
}

function changeFileType(xFileType){
	if(xFileType==".docx"||xFileType==".dot"){
		xFileType=".doc";
	}else if(xFileType==".xlsx"||xFileType==".xlt"||xFileType==".xlw"||xFileType==".xla"){
		xFileType=".xls";
	}else if(xFileType==".pptx"){
		xFileType=".ppt";
	}
	return xFileType;
}

/*
Index:
wdPropertyAppName		:9
wdPropertyAuthor		:3
wdPropertyBytes			:22
wdPropertyCategory		:18
wdPropertyCharacters		:16
wdPropertyCharsWSpaces		:30
wdPropertyComments		:5
wdPropertyCompany		:21
wdPropertyFormat		:19
wdPropertyHiddenSlides		:27
wdPropertyHyperlinkBase		:29
wdPropertyKeywords		:4
wdPropertyLastAuthor		:7
wdPropertyLines			:23
wdPropertyManager		:20
wdPropertyMMClips 		:28
wdPropertyNotes			:26
wdPropertyPages			:14
wdPropertyParas			:24
wdPropertyRevision		:8
wdPropertySecurity		:17
wdPropertySlides		:25
wdPropertySubject		:2
wdPropertyTemplate		:6
wdPropertyTimeCreated		:11
wdPropertyTimeLastPrinted	:10
wdPropertyTimeLastSaved		:12
wdPropertyTitle			:1
wdPropertyVBATotalEdit		:13
wdPropertyWords			:15
*/
//获取或设置文档摘要信息
function WebShowDocumentProperties(Index){
	var propertiesValue="";
	try{
		var properties = document.getElementById("WebOffice").WebObject.BuiltInDocumentProperties;
		propertiesValue=properties.Item(Index).Value;
	}catch(e){}
	return propertiesValue;
}

function getFileSize(){
	var fileSize=new String((1.0*WebShowDocumentProperties(22))/(1024*1024));

	var len = fileSize.length;

	var afterDotCount=0;
	var hasDot=false;
	var newIntValue="";
	var newDecValue="";

	for(i = 0; i < len; i++){
		if(fileSize.charAt(i) == "."){
			hasDot=true;
		}else{
			if(hasDot==false){
				newIntValue+=fileSize.charAt(i);
			}else{
				afterDotCount++;
				if(afterDotCount<=2){
					newDecValue+=fileSize.charAt(i);
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
	return newValue;
}
function checkCanSubmit(onFunc,onObj){
	var s = document.createElement("SCRIPT");
	document.getElementsByTagName("HEAD")[0].appendChild(s);
	s.src="DocCanSubmitCheck.jsp?docid="+docid;
	nowFunc = onFunc;
	nowObj = onObj;
}

function doRelate2Cowork(){
	if(opener.name=="HomePageIframe2"){
		if(opener.parent.parent.parent.parent.frames[1].name=="mainFrame"){
			opener.parent.parent.parent.parent.frames[1].location="/cowork/coworkview.jsp?method=relate&docid="+docid;
		}else{
			opener.parent.parent.parent.location.href="/cowork/coworkview.jsp?method=relate&docid="+docid;
		}
	}else{
		window.opener.location="/cowork/coworkview.jsp?method=relate&docid="+docid;
	}
	window.close();
}

function onPublish(){
	if(!checkresult){
		return checkCanSubmit("onPublish",null);
	}
	document.weaver.operation.value='publish';
	document.weaver.submit();
}

function onInvalidate(){
	if(!checkresult){
		return checkCanSubmit("onInvalidate",null);
	}
	document.weaver.operation.value='invalidate';
	document.weaver.submit();
}

function onCancel(){
	if(!checkresult){
		return checkCanSubmit("onCancel",null);
	}

	document.weaver.operation.value='cancel';
	document.weaver.submit();
}

function onReopen(){
	if(!checkresult){
		return checkCanSubmit("onReopen",null);
	}
	document.weaver.operation.value='reopen';
	document.weaver.submit();
}

function onCheckOut(){
	document.weaver.operation.value='checkOut';
	document.weaver.submit();
}

function onCheckIn(){
	document.weaver.operation.value='checkIn';
	document.weaver.submit();
}
function returnClearDocAccessoriesTrace(){
	document.weaver.operation.value='useTemplet';
	document.weaver.submit();
}
function useTempletNoChangeDocAccessories(){
	if(SaveDocumentOrSaveDocumentNewV()){
		document.weaver.operation.value='useTemplet';
		document.weaver.submit();
	}
}

function GetFile4Replace(){
	document.weaver.target="iframe4replace";
	document.weaver.action="/docs/docs/DocImgUpload.jsp";
	document.weaver.operation.value='replacefile';
	document.weaver.submit();
}

function onSave(){

	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

	var Modify = true;
	try{
		Modify = document.getElementById("WebOffice").WebObject.Saved;
	}catch(e){
	}
	if(!Modify){
		if(window.confirm(message21700+"，"+message21701+"！"+"\n"+message24355+"？")){
			document.weaver.operation.value='editsave';
			document.weaver.submit();
		}
	}else{
		document.weaver.operation.value='editsave';
		document.weaver.submit();
	}
}

function btndisabledtrue(){
	try{
		document.getElementById("BUTTONbtn_save").disabled=true;
	}catch(e){}
	try{
		document.getElementById("thSure_id").disabled=true;
	}catch(e){}
	try{
		document.getElementById("thSaveAgain_id").disabled=true;
	}catch(e){}
	try{
		document.getElementById("signature_id2").disabled=true;
	}catch(e){}
	try{
		document.getElementById("thCancel_id").disabled=true;
	}catch(e){}
	try{
		document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20227,user.getLanguage())%>");
	}catch(e){}
	try{
		parent.disableTabBtn();
	}catch(e){}
}

function btndisabledfalse(){
	try{
		document.getElementById("BUTTONbtn_save").disabled=false;
	}catch(e){}
	try{
		document.getElementById("thSure_id").disabled=false;
	}catch(e){}
	try{
		document.getElementById("thSaveAgain_id").disabled=false;
	}catch(e){}
	try{
		document.getElementById("signature_id2").disabled=false;
	}catch(e){}
	try{
		document.getElementById("thCancel_id").disabled=false;
	}catch(e){}
	try{
		document.getElementById("WebOffice").EnableMenu("<%=SystemEnv.getHtmlLabelName(20227,user.getLanguage())%>");
	}catch(e){}
	try{
		parent.enableTabBtn();	
	}catch(e){}
}


function setCookie(name,value){
	var Days = 1;
	var exp	= new Date();
	exp.setTime(exp.getTime()+Days*24*60*60*1000);
	document.cookie = name + "="+ escape(value) +";expires="+ exp.toGMTString();
}

function delCookie(name){
	var exp = new Date();
	exp.setTime(exp.getTime() - 1);
	var cval=getCookie(name);
	if(cval!=null){
		document.cookie=name +"="+cval+";expires="+exp.toGMTString();
	}
}

function onExpand(objstr){
	if(objstr!=null){
		if($(objstr+"_tr").style.display=="none"){
			$(objstr+"_tr").style.display = "block";
			setCookie(objstr+"_tr","block");
		}else{
			$(objstr+"_tr").style.display = "none";
			setCookie(objstr+"_tr","none");
		}
		if($(objstr+"_up").style.display=="none"){
			$(objstr+"_up").style.display = "block";
			setCookie(objstr+"_up","block");
		}else{
			$(objstr+"_up").style.display = "none";
			setCookie(objstr+"_up","none");
		}
		if($(objstr+"_down").style.display=="none"){
			$(objstr+"_down").style.display = "block";
			setCookie(objstr+"_down","block");
		}else{
			$(objstr+"_down").style.display = "none";
			setCookie(objstr+"_down","none");
		}
	}
}

function openVersion(vid){
	docVersionWord(vid);
}
function onApprove(){
	document.weaver.operation.value='approve';
	document.weaver.submit();
}
function onReturn(){
	document.weaver.operation.value='return';
	document.weaver.submit();
}
function onReopen(){
	document.weaver.operation.value='reopen';
	document.weaver.submit();
}
function onReload(){
	document.weaver.operation.value='reload';
	document.weaver.submit();
}
function onPrintLog(){
		openFullWindow("/docs/docs/DocPrintLog.jsp?docid="+docid);
}

function setWebObjectSaved(){
	try{
		document.getElementById("WebOffice").WebObject.Saved=true;
	}catch(e){}
}

function doRemark(){
	if(document.weaver.isbill.value==1&&document.weaver.formid.value==28){
		document.weaver.action="/workflow/request/BillApproveOperation.jsp";
	}else if(document.weaver.isbill.value==1&&document.weaver.formid.value==67){
		document.weaver.action="/workflow/request/BillInnerSendDocOperation.jsp";
	}else{
		document.weaver.action="/workflow/request/BillOrFormApproveOperation.jsp";
	}

	document.weaver.isremark.value='1';
	document.weaver.src.value='save';
	document.weaver.submit();
}
function doSubmit(){
	if(document.weaver.isbill.value==1&&document.weaver.formid.value==28){
		document.weaver.action="/workflow/request/BillApproveOperation.jsp";
	}else if(document.weaver.isbill.value==1&&document.weaver.formid.value==67){
		document.weaver.action="/workflow/request/BillInnerSendDocOperation.jsp";
	}else{
		document.weaver.action="/workflow/request/BillOrFormApproveOperation.jsp";
	}
	document.weaver.src.value='submit';
	document.weaver.submit();
}
function doForward(){
	var forwardurl = "/workflow/request/Remark.jsp?requestid="+requestid;
 	var windforward = new Ext.Window({
		layout: 'fit',
		width: 500,
		resizable: true,
		height: 300,
		closeAction: 'hide',
		modal: true,
		title: wmsg.wf.forward,
 		html:'<iframe id="wfforward" name= "wfforward" BORDER=0 FRAMEBORDER=no height="100%" width="100%" scrolling="auto" src="'+forwardurl+'"></iframe>',
		autoScroll: true,
		buttons: [{
					text: wmsg.wf.submit,// '提交',
					handler: function(){
						document.frames['wfforward'].doSave(windforward);						
					}
				},{
					text: wmsg.wf.close,// '关闭',
					handler: function(){
						windforward.hide();
					}
				}]
	});
	windforward.show("");
}
function doReject(){
	if(document.weaver.isbill.value==1&&document.weaver.formid.value==28){
		document.weaver.action="/workflow/request/BillApproveOperation.jsp";
	}else if(document.weaver.isbill.value==1&&document.weaver.formid.value==67){
		document.weaver.action="/workflow/request/BillInnerSendDocOperation.jsp";
	}else{
		document.weaver.action="/workflow/request/BillOrFormApproveOperation.jsp";
	}
	document.weaver.src.value='reject';
	document.weaver.submit();
}
function doViewLog(){
	//DocAllPropPanel.expand(true);
	onExpandOrCollapse(true);
	//DocSetTabPanel.setActiveTab("DocDetailLog");
	onActiveTab("divViewLog");
}

function doShare(){
	//DocAllPropPanel.expand(true);
	onExpandOrCollapse(true);
	//DocSetTabPanel.setActiveTab("DocShare");
	onActiveTab("divShare");
}

function showPrompt(content){

}

function hiddenPrompt(){
	var showTableDiv = document.getElementById('_xTable');
	if(showTableDiv!=null){
		showTableDiv.style.display="none";
	}
}
function SetActiveDocument(){
	if(document.getElementById("WebOffice").FileType==".doc"){
		weaver.SignatureAPI.ActiveDocument=document.getElementById("WebOffice").WebObject;	//设置WORD对象
	}
	if(document.getElementById("WebOffice").FileType==".xls"){
		weaver.SignatureAPI.ActiveDocument=document.getElementById("WebOffice").WebObject.Application.ActiveWorkbook.ActiveSheet;	//设置EXCEL对象
	}
}
function saveIsignatureFunReturn(){
	document.getElementById("WebOffice").WebSetMsgByName("CLEARHANDWRITTEN","TRUE");//ClearHandwritten	清除手写批注
	useTempletNoChangeDocAccessories();
}
function doImgAcc(){
	//DocAllPropPanel.expand(true);
	onExpandOrCollapse(true);
	//DocSetTabPanel.setActiveTab("DocImgs");
	onActiveTab("divAcc");
}
function SetHidRevision(){
	try{
		document.getElementById("WebOffice").WebSetProtect(false,"");			//解保护
		try{
			document.getElementById("WebOffice").WebObject.TrackRevisions=false;
			document.getElementById("WebOffice").WebObject.PrintRevisions=false;
			document.getElementById("WebOffice").WebObject.ShowRevisions=false;
		}catch(e){}
		document.getElementById("WebOffice").WebSetProtect(true,"");			//保护
	}catch(e){}
}
function iSignatureFunc(rev){
	var resValue = "true";
	if(resValue == rev){
		try{
			//Ext.getCmp('thSure_id').hide();
			parent.document.getElementById('thSure_id').style.display = "none";
		}catch(e){
		}
		try{	
		    //Ext.getCmp('thModeS_id').hide();
			parent.document.getElementById('thModeS_id').style.display = "none";
		}catch(e){
		}
		try{
		    //Ext.getCmp('signature_id1').show();
		    parent.document.getElementById('signature_id1').style.display = "";
		}catch(e){
		}
		try{
		    //Ext.getCmp('signature_id2').show();
			parent.document.getElementById('signature_id2').style.display = "";
		}catch(e){
		}
		try{
		    //Ext.getCmp('thCancel_id').show();
			parent.document.getElementById('thCancel_id').style.display = "";
		}catch(e){
		}
	    if(window.confirm(message21658)){
			CreateSignature(0);
			WebToolsVisibleISignatureFalse();
		}
	}
}
