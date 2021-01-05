
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
int docid = Util.getIntValue(request.getParameter("docid"));
int docmouldid = Util.getIntValue(request.getParameter("docmouldid"));
String username = Util.null2String(request.getParameter("username"));
String CurrentDate = Util.null2String(request.getParameter("CurrentDate"));
String CurrentTime = Util.null2String(request.getParameter("CurrentTime"));
String parentids = Util.null2String(request.getParameter("parentids"));
int meetingid = Util.getIntValue(request.getParameter("docmouldid"));
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
boolean isPDF = Util.getIntValue(request.getParameter("isPDF"),0) == 1;
RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsrecycle'");
RecordSet.next();
int docsrecycleIsOpen=Util.getIntValue(RecordSet.getString("propvalue"),0);
RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsautoclean'");
RecordSet.next();
int autoclean=Util.getIntValue(RecordSet.getString("propvalue"),0);
RecordSet.executeSql("select propvalue from   doc_prop  where propkey='autodeletedays'");
RecordSet.next();
int deletedays=Util.getIntValue(RecordSet.getString("propvalue"),30);	
%>
<script>
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

	function doRelate2Cowork(obj){
		obj.disabled = true;
		if(opener.name=="HomePageIframe2"){
			 if(opener.parent.parent.parent.parent.frames[1].name=="mainFrame")
			      opener.parent.parent.parent.parent.frames[1].location="/cowork/coworkview.jsp?method=relate&docid=<%=docid%>";
		     else  
				 opener.parent.parent.parent.location.href="/cowork/coworkview.jsp?method=relate&docid=<%=docid%>";			
			window.close();
		}else{ 
			//window.opener.location="/cowork/coworkview.jsp?method=relate&docid=<%=docid%>";
			window.open("/cowork/coworkview.jsp?method=relate&docid=<%=docid%>");
		}
	}
	
	function onPublish(obj){
		if(!checkresult) return checkCanSubmit("onPublish",obj);
		
		obj.disabled = true;
        document.weaver.operation.value='publish';
        document.weaver.submit();
	}
	
	function onInvalidate(obj){
		if(!checkresult) return checkCanSubmit("onInvalidate",obj);
		
		obj.disabled = true;
        document.weaver.operation.value='invalidate';
        document.weaver.submit();
	}

	function onCancel(obj){
		if(!checkresult) return checkCanSubmit("onCancel",obj);
	
		obj.disabled = true;
        document.weaver.operation.value='cancel';
        document.weaver.submit();
	}

	function onReopen(obj){
		if(!checkresult) return checkCanSubmit("onReopen",obj);

		obj.disabled = true;	
        document.weaver.operation.value='reopen';
        document.weaver.submit();
	}
	
	function setCookie(name,value){
	  var Days = 1;
	  var exp  = new Date();
	  exp.setTime(exp.getTime()+Days*24*60*60*1000);
	  document.cookie = name + "="+ escape(value) +";expires="+ exp.toGMTString();
	}
	
	function getCookie(name){
	  var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	  if(arr != null) 
	  	return unescape(arr[2]);
	  return null;
	}
	
	function delCookie(name){
	  var exp = new Date();
	  exp.setTime(exp.getTime() - 1);
	  var cval=getCookie(name);
	  if(cval!=null) 
	  	document.cookie=name +"="+cval+";expires="+exp.toGMTString();
	}

	function initExpand(){
		var objstr1 = new Array("edition","reply","properties","mark");
		var objstr2 = new Array("tr","up","down");
		for(var i =0;i<objstr1.length;i++){
			for(var j=0;j<objstr2.length;j++){
				var tmpname = objstr1[i] + "_" + objstr2[j];
				var tmpdisplay = getCookie(tmpname);
				if(tmpdisplay!=null){
					$(tmpname).style.display = tmpdisplay;
				}
			}
		}
	}
	
	initExpand();
	
	function onExpand(objstr){
		if(objstr!=null){
			if($(objstr+"_tr").style.display=="none"){
				$(objstr+"_tr").style.display = "block";
				setCookie(objstr+"_tr","block");
			} else {
				$(objstr+"_tr").style.display = "none";
				setCookie(objstr+"_tr","none");
			}
			if($(objstr+"_up").style.display=="none"){
				$(objstr+"_up").style.display = "block";
				setCookie(objstr+"_up","block");
			} else {
				$(objstr+"_up").style.display = "none";
				setCookie(objstr+"_up","none");
			}
			if($(objstr+"_down").style.display=="none"){
				$(objstr+"_down").style.display = "block";
				setCookie(objstr+"_down","block");
			} else {
				$(objstr+"_down").style.display = "none";
				setCookie(objstr+"_down","none");
			}
		}
	}

    function onDelete(obj){
		var docsrecycleIsOpen=<%=docsrecycleIsOpen%>;
		var autoclean=<%=autoclean%>;
		var deletedays=<%=deletedays%>;
		var deletetips="<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
		if(!checkresult) return checkCanSubmit("onDelete",obj);		
		if(docsrecycleIsOpen==1&&autoclean!=1){
			deletetips="<%=SystemEnv.getHtmlLabelName(130656,user.getLanguage())%>";
		}else if(docsrecycleIsOpen==1&&autoclean==1){
			deletetips="<%=SystemEnv.getHtmlLabelName(130656,user.getLanguage())%><br><span style='color:red'>&nbsp;&nbsp;("+deletedays+"<%=SystemEnv.getHtmlLabelName(130657,user.getLanguage())%>)</span>";
		}
		<%if(user.getLogintype().equals("2")){%>//客户
		deletetips="<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
		<%}%>
		top.Dialog.confirm(deletetips,function (){
			Ext.Ajax.request({
					url : '/docs/docs/DocDwrProxy.jsp' , 
					params : {
								 method : 'DocCheckInOutUtil.whetherCanDelete',
								 paras:'<%=docid%>,<%=user.getUID()%>,<%=user.getLogintype()%>,<%=user.getLanguage()%>'
							 },
					method: 'POST',
					success: function ( result, request) {
						checkForDelete(result.responseText.trim());
					},
					failure: function ( result, request) { 
						Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
					} 
				});
			})
			//DocCheckInOutUtil.whetherCanDelete(<%=docid%>,<%=user.getUID()%>,<%=user.getLogintype()%>,<%=user.getLanguage()%>,checkForDelete);			
        }
    
//o为返回的错误信息
function checkForDelete(o){
	if(o==""){
			document.weaver.operation.value='delete';
			
			var content="<%=SystemEnv.getHtmlLabelName(18894,user.getLanguage())%>";
			showPrompt(content);
			
			document.weaver.submit();
	}else{
		alert(o);
	}
}

    function onApprove(){
        document.weaver.operation.value='approve';
        document.weaver.submit();
    }
    
    function onReturn(){
        document.weaver.operation.value='return';
        document.weaver.submit();
    }
    /*
    function onReopen(){
        document.weaver.operation.value='reopen';
        document.weaver.submit();
    }
    */
    
    function onArchive(obj){
		if(!checkresult) return checkCanSubmit("onArchive",obj);
		
        thedocno = prompt("<%=SystemEnv.getHtmlLabelName(16215,user.getLanguage())%>","") ;
        if(thedocno != null ) {
            while(thedocno.indexOf(" ") == 0)
                thedocno = thedocno.substring(1,thedocno.length);

            if(thedocno != "") {
				obj.disabled = true;	
                document.weaver.docno.value = thedocno ;
                document.weaver.operation.value='archive';
                document.weaver.submit();
            }
        }
    }

    function onCheckOut(){
        document.weaver.operation.value='checkOut';
        document.weaver.submit();
    }

    function onCheckIn(){
        document.weaver.operation.value='checkIn';
        document.weaver.submit();
    }

    function onReload(){
        document.weaver.operation.value='reload';
        document.weaver.submit();
    }
    function onPrint(){
		<%if(!isPDF) { %>
			window.open('DocPrint.jsp?id=<%=docid%>&docmouldid=<%=docmouldid%>');
		<% } else {%>
			document.getElementById("doccontentifm").contentWindow.onPrint();
		<% } %>
    }

	function doRemark(){
        //if(document.weaver.formid.value==28) document.weaver.action="/workflow/request/BillApproveOperation.jsp";
        //if(document.weaver.formid.value==67) document.weaver.action="/workflow/request/BillInnerSendDocOperation.jsp";
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

    //if(document.weaver.formid.value==28) document.weaver.action="/workflow/request/BillApproveOperation.jsp";
    //if(document.weaver.formid.value==67) document.weaver.action="/workflow/request/BillInnerSendDocOperation.jsp";
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
	function doReject(){
        //if(document.weaver.formid.value==28)
		//    document.weaver.action="/workflow/request/BillApproveOperation.jsp";
        //if(document.weaver.formid.value==67)
		//    document.weaver.action="/workflow/request/BillInnerSendDocOperation.jsp";
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
	function doSign(){
		document.weaver.remark.value+="\n<%=username%>  <%=CurrentDate%>  <%=CurrentTime%>";
	}

    function setDownload(fileid){

    }

    function docVersionF(iid,vid){
        docVersion(iid,vid);
    }
	var dialog = null;
    function doReply(){  	
		//winReply.show(null);
		//ifrmReply.location="/docs/docs/DocReply.jsp?id=<%=docid%>&parentids=<%=parentids%>";
		
    	//openFullWindowForXtable("/docs/docs/DocReply.jsp?id=<%=docid%>&parentids=<%=parentids%>");
    	var forwardurl = "/docs/tabs/DocCommonTab.jsp?_fromURL=72&dialog=1&id=<%=docid%>&parentids=<%=parentids%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
    	dialog = new window.top.Dialog();
    	dialog.currentWindow = window;
    	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32830,user.getLanguage())%>";
    	dialog.Width = jQuery(window).width()*0.8;
		dialog.Height = jQuery(window).height()*0.8;
		dialog.Drag = true;
		dialog.URL = forwardurl;
		dialog.maxiumnable = false;
		dialog.show();	
		
    }
    
    function newDoReply()
    {
    	fromTab = "1";
    	onActiveTab('divReplay');
    }

	function doReplyList(){       
		//if(isDocPropPaneHidden){
			onExpandOrCollapse(true);
			onActiveTab("divReplay");  
		//} else {
		//	 DocAllPropPanel.collapse(true);
		//}
		
    }

	function doImgAcc(){      
		//alert(isDocPropPaneHidden)
		//if(isDocPropPaneHidden){
			onExpandOrCollapse(true);
			onActiveTab("divAcc");  
		//} else {
		//	 DocAllPropPanel.collapse(true);
		//}
		
    }

    function doViewLog(){
        //document.docsharelog.action="/docs/DocDetailLog.jsp" ;
        //document.docsharelog.submit() ;
        onExpandOrCollapse(true);
        onActiveTab("divViewLog");  
    }

    function doShare(){
		//if(isDocPropPaneHidden){
			onExpandOrCollapse(true);
			onActiveTab("divShare");  
		//} else {
		//	 DocAllPropPanel.collapse(true);
		//}
    }

	function doAddWorkPlan() {
		document.location.href = "/workplan/data/WorkPlan.jsp?docid=<%=docid%>&add=1";
	}

	function doRelateWfFun(docid) {
		openFullWindow("/workflow/search/WFSearchTemp.jsp?docids="+docid);
	} 
	
function onEdit(docid){
	document.location.href = "/docs/docs/DocEdit.jsp?id="+docid;
}  

function onSave(obj){

	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

		//TD8583  DS
		//window.location="/docs/docs/DocOtherSave.jsp?docid=<%=docid%>&message=editsave";
		//TD8912 chj
    	//FCKEditorExt.updateContent();
		document.weaver.isSubmit.value='1';
        document.weaver.operation.value='editsave';
        //TD4213 增加提示信息  开始
		var content="<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>";
		showPrompt(content);
        //TD4213 增加提示信息  结束
        document.weaver.submit();
		//enableAllmenu();
}

function btndisabledtrue(){
	try{
		$GetEle("BUTTONbtn_save").disabled=true;
		$GetEle("BUTTONbtn_save").style.color='#cccccc';
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
function onDocShare(docid,docsubject){
	var message='[{"shareid":'+docid+',"sharetitle":"'+docsubject+'","sharetype":"doc","objectname":"FW:CustomShareMsg"}]';
	socialshareToEmessage(message);
}
</script>
<script language="VBScript">
    function docVersion(iid,vid)
        url=escape("/docs/docs/listVersion.jsp?versionId="&vid&"&docid=<%=docid%>")
        id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
        if (Not IsEmpty(id)) then
            if id(0)<> "" then
                'msgbox ("selectVersion" & iid)
                'msgbox id(0)&"  "&id(1)&"   "&iid
                document.getElementById("selectVersion" & iid).href="DocDspExt.jsp?id=<%=docid%>&versionId="&id(0)&"&isFromAccessory=true&meetingid=<%=meetingid%>&imagefileId="&id(1)
                onclickStr=chr(34)&"top.location='/weaver/weaver.file.FileDownload?fileid="&id(1)&"&download=1'"&chr(34)
                document.getElementById("selectDownload" & iid).innerHtml="<a href='#'  onclick="&onclickStr&"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>"
            end if
        end if
    end function
</script>

