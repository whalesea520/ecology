
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.file.Prop" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowBarCodeSetManager" class="weaver.workflow.workflow.WorkflowBarCodeSetManager" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="BaseBeanOfDocDspExt" class="weaver.general.BaseBean" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String signatureType = Util.null2String(Prop.getPropValue("wps_office_signature","wps_office_signature"));
String wps_version=Util.null2String(Prop.getPropValue("wps_office_signature","wps_version"));
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
int docid = Util.getIntValue(request.getParameter("docid"));
String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc"));
boolean isIWebOffice2006 = Util.null2String(request.getParameter("isIWebOffice2006")).equals("1");
int requestid = Util.getIntValue(request.getParameter("requestid"));
String ifVersion = Util.null2String(request.getParameter("ifVersion"));
String isCompellentMark = Util.null2String(request.getParameter("isCompellentMark"));
String canPostil = Util.null2String(request.getParameter("canPostil"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String isFromAccessory = Util.null2String(request.getParameter("isFromAccessory"));
String topageFromOther = Util.null2String(request.getParameter("topageFromOther"));
String isrequest = Util.null2String(request.getParameter("isrequest"));
int meetingid = Util.getIntValue(request.getParameter("meetingid"));
String hasUsedTemplet = Util.null2String(request.getParameter("hasUsedTemplet"));
String isPrintControl = Util.null2String(request.getParameter("isPrintControl"));
String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
//String docsubject = Util.null2String(request.getParameter("docsubject"));
String userid =  Util.null2String(request.getParameter("userid"));
String hasPrintNode = Util.null2String(request.getParameter("hasPrintNode"));
String isPrintNode = Util.null2String(request.getParameter("isPrintNode"));
String printApplyWorkflowId = Util.null2String(request.getParameter("printApplyWorkflowId"));
String isagentOfprintApply = Util.null2String(request.getParameter("isagentOfprintApply"));
String username =  Util.null2String(request.getParameter("username"));
int countNum = Util.getIntValue(request.getParameter("countNum"));
int isremark = Util.getIntValue(request.getParameter("isremark"));
boolean isUseTempletNode = Util.null2String(request.getParameter("isUseTempletNode")).equals("1");
String wordmouldid = Util.null2String(request.getParameter("wordmouldid"));
int versionId = Util.getIntValue(request.getParameter("versionId"));
String isSignatureNodes = Util.null2String(request.getParameter("isSignatureNodes"));
String CurrentDate = Util.null2String(request.getParameter("CurrentDate"));
String CurrentTime = Util.null2String(request.getParameter("CurrentTime"));
String replyid = Util.null2String(request.getParameter("replyid"));
String parentids = Util.null2String(request.getParameter("parentids"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String PDF417ManagerCopyRight = Util.null2String((String)session.getAttribute("PDF417ManagerCopyRight"));
boolean canPrint = Util.null2String(request.getParameter("canPrint")).equals("1");
int currentnodeid = Util.getIntValue(request.getParameter("currentnodeid"));
boolean isCleanCopyNodes = Util.null2String(request.getParameter("isCleanCopyNodes")).equals("true");
RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsrecycle'");
RecordSet.next();
int docsrecycleIsOpen=Util.getIntValue(RecordSet.getString("propvalue"),0);
RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsautoclean'");
RecordSet.next();
int autoclean=Util.getIntValue(RecordSet.getString("propvalue"),0);
RecordSet.executeSql("select propvalue from   doc_prop  where propkey='autodeletedays'");
RecordSet.next();
int deletedays=Util.getIntValue(RecordSet.getString("propvalue"),30);
DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();
String docsubject=DocManager.getDocsubject();
%>
<script language="javascript">

<%if(fromFlowDoc.equals("1")){%>
jQuery(window.parent.document).find("div#docblock .e8_btn_top_first_disabled").attr("disabled",false);
jQuery(window.parent.document).find("div#docblock .e8_btn_top_disabled").attr("disabled",false);
jQuery(window.parent.document).find("div#docblock .e8_btn_top_first_disabled").removeClass().addClass("e8_btn_top_first"); 
jQuery(window.parent.document).find("div#docblock .e8_btn_top_disabled").removeClass().addClass("e8_btn_top"); 
<%}%>
var checkresult = false;
var nowFunc = null;
var nowObj = null;

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

    function useTemplet(){
		if(SaveDocumentOrSaveDocumentNewV()){
			<%
				        if(!"1".equals(hasUsedTemplet)){
			%>
						    document.getElementById("ClearDocAccessoriesTraceIframe").src="/docs/docs/ClearDocAccessoriesTraceIframe.jsp?operation=ClearDocAccessoriesTrace&docId=<%=docid%>&requestId=<%=requestid%>";
			<%
				        }else{
			%>
				            returnClearDocAccessoriesTrace();
			<%
				        }
			%>
					}
    }
    function getCookie(name){
    	var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
    	if(arr != null){
    		return unescape(arr[2]);
    	}
    	return null;
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
    function onDelete(){
    if(!checkresult) return checkCanSubmit("onDelete",null);
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
			document.getElementById("DocCheckInOutUtilIframe").src="/docs/docs/DocCheckInOutUtilIframe.jsp?operation=whetherCanDelete&docId=<%=docid%>&userId=<%=user.getUID()%>&userLoginType=<%=user.getLogintype()%>&strUserLanguage=<%=user.getLanguage()%>";
		})
    }

//o为返回的错误信息
function checkForDelete(o){
	if(o==""){
		showPrompt("<%=SystemEnv.getHtmlLabelName(18894,user.getLanguage())%>");
		document.weaver.operation.value='delete';
		document.weaver.submit();
	}else{
		alert(o);
	}
}

    function onArchive(){
    if(!checkresult) return checkCanSubmit("onArchive",null);
    

    thedocno = prompt("<%=SystemEnv.getHtmlLabelName(16215,user.getLanguage())%>","") ;
    if(thedocno != null ) {
    while(thedocno.indexOf(" ") == 0)
    thedocno = thedocno.substring(1,thedocno.length);

    if(thedocno != "") {

    document.weaver.docno.value = thedocno ;
    document.weaver.operation.value='archive';
    document.weaver.submit();
    }
    }
    }

    function onPrintDoc(){

<%if(isPrintControl.equals("1")){%>
    if(document.getElementById("WebOffice").FileType==".doc"||document.getElementById("WebOffice").FileType==".docx"){	
	    WebCopysCtrlPrint();
    }else if(document.getElementById("WebOffice").FileType==".xls"||document.getElementById("WebOffice").FileType==".xlsx"){
   	    WebCopysCtrlPrintExcel();   //设置EXCEL对象
    }else{
		document.getElementById("WebOffice").WebOpenPrint();
	}
<%}else{%>		
		document.getElementById("WebOffice").WebOpenPrint();
<%}%>
		/**TD12005 文档日志（打印日志记录）开始*/
		DocDetailLogWrite.writeDetailLog("<%=docid%>", "<%=Util.stringReplace4DocDspExt(docsubject)%>", "21", "<%=user.getUID()%>", "<%=user.getLogintype()%>", "<%=request.getRemoteAddr()%>", "<%=doccreaterid%>", callbackWriteLog);
		/**TD12005 文档日志（打印日志记录）结束*/
    }

//打印份数控制
function WebCopysCtrlPrint(){
	var mCopies,objPrint;
    objPrint = document.getElementById("WebOffice").WebObject.Application.Dialogs(88);     //打印设置对话框
    if (objPrint.Display==-1){
        mCopies=objPrint.NumCopies;    //取得需要打印份数
        document.getElementById("WebOffice").WebSetMsgByName("COMMAND","COPIES");
        document.getElementById("WebOffice").WebSetMsgByName("OFFICEPRINTS",mCopies.toString());   //设置变量OFFICEPRINTS的值，在WebSendMessage()时，一起提交到OfficeServer中
        document.getElementById("WebOffice").WebSetMsgByName("DOCID","<%=docid%>");  
        document.getElementById("WebOffice").WebSetMsgByName("USERID","<%=userid%>");
        document.getElementById("WebOffice").WebSetMsgByName("CLIENTADDRESS","<%=request.getRemoteAddr()%>");	
        document.getElementById("WebOffice").WebSetMsgByName("HASPRINTNODE","<%=hasPrintNode%>");
        document.getElementById("WebOffice").WebSetMsgByName("ISPRINTNODE","<%=isPrintNode%>");				
        document.getElementById("WebOffice").WebSetMsgByName("CANPRINT","<%=canPrint%>");		
        document.getElementById("WebOffice").WebSendMessage();                               //交互OfficeServer的OPTION="SENDMESSAGE"       
        if (document.getElementById("WebOffice").Status=="1") {
            objPrint.Execute;
        }else{
            var maxPrints=document.getElementById("WebOffice").WebGetMsgByName("MAXPRINTS");			
            alert("<%=SystemEnv.getHtmlLabelName(21534 ,user.getLanguage())%>！<%=SystemEnv.getHtmlLabelName(21535 ,user.getLanguage())%>："+maxPrints);
            return false;
        }
    }
}

//打印份数控制   EXCEL
function WebCopysCtrlPrintExcel(){

	document.getElementById("WebOffice").WebOpenPrint();

}
    function onPrintApply(){
		openFullWindow("/workflow/request/AddRequest.jsp?workflowid=<%=printApplyWorkflowId%>&isagent=<%=isagentOfprintApply%>&docid=<%=docid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>");
    }

    function doSign(){

    document.weaver.remark.value+="\n<%=username%>  <%=CurrentDate%>  <%=CurrentTime%>";
    }

    function doRelateWfFun(docid) {
		openFullWindow("/workflow/search/WFSearchTemp.jsp?docids="+docid);
	}   

    function doReply(){

    //location="DocReply.jsp?id=<%=replyid%>&parentids=<%=parentids%>";
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
function getBrowserUrlFn(seccategoryid){
	 wordmouldid=document.getElementById("selectedpubmouldid").value;
	 return "/systeminfo/BrowserMain.jsp?url=/docs/docs/TaoHongTemplate.jsp?seccategory="+seccategoryid+"&wordmouldid="+wordmouldid+"&workflowid=<%=workflowid%>";
}

function afterSelectMould(e,rt,name,params){
	  if(rt != null){
		document.getElementById("WebOffice").Template=rt.id;
        document.getElementById("selectedpubmouldid").value=rt.id;
		document.getElementById("WebOffice").WebSetMsgByName("SHOWDOCMOULDBOOKMARK","<%=fromFlowDoc%>");//载入是否显示“文档模板书签表”数据,这根据“是否来源于流程建文挡”来确定。		
		document.getElementById("WebOffice").WebSetMsgByName("COMMAND","LOADVIEWMOULD");//载入显示模板

		if(document.getElementById("WebOffice").WebLoadTemplate()){//如果打开模板成功
		    //WebToolsVisible("iSignature",false);
		    WebToolsVisibleISignatureFalse();

			var t_EditType = document.getElementById("WebOffice").EditType;
			document.getElementById("WebOffice").EditType = "-1,0,0,0,0,0,1<%=canPostil%>";

		    document.getElementById("WebOffice").RecordID=document.getElementById("versionId").value+"_<%=docid%>";
		    document.getElementById("WebOffice").WebLoadBookMarks();//替换书签

		    //document.getElementById("WebOffice").RecordID=<%=(versionId==0?"":versionId+"")%>;
		    document.getElementById("WebOffice").RecordID=document.getElementById("versionId").value+"_<%=docid%>";

		    document.getElementById("WebOffice").WebInsertFile();//插入正文

<%
//套红时插入二维条码
if(fromFlowDoc.equals("1")){
  String isUseBarCode = Util.null2String(BaseBeanOfDocDspExt.getPropValue("weaver_barcode","ISUSEBARCODE"));
  if(isUseBarCode.equals("1")){
	//判断是否启用二维条码
	RecordSet.executeSql("select * from Workflow_BarCodeSet where workflowId="+workflowid+" and isUse='1'");

	if(RecordSet.next()){
		int barCodeSetId=Util.getIntValue(RecordSet.getString("id"),0);
		String measureUnit=Util.null2String(RecordSet.getString("measureUnit"));
		int printRatio = Util.getIntValue(RecordSet.getString("printRatio"),96);
		int minWidth = Util.getIntValue(RecordSet.getString("minWidth"),30);
		int maxWidth = Util.getIntValue(RecordSet.getString("maxWidth"),70);
		int minHeight = Util.getIntValue(RecordSet.getString("minHeight"),10);
		int maxHeight = Util.getIntValue(RecordSet.getString("maxHeight"),25);
		int bestWidth = Util.getIntValue(RecordSet.getString("bestWidth"),50);
		int bestHeight = Util.getIntValue(RecordSet.getString("bestHeight"),20);

		if(measureUnit.equals("1")){
			minWidth=(int)(0.5+minWidth*printRatio/25.4);
			maxWidth=(int)(0.5+maxWidth*printRatio/25.4);
			minHeight=(int)(0.5+minHeight*printRatio/25.4);
			maxHeight=(int)(0.5+maxHeight*printRatio/25.4);
			bestWidth=(int)(0.5+bestWidth*printRatio/25.4);
			bestHeight=(int)(0.5+bestHeight*printRatio/25.4);
		}

		String PDF417TextValue=WorkflowBarCodeSetManager.getPDF417TextValue(requestid,barCodeSetId,user.getLanguage());
%>
        var hasBarCodeLabel=false;
        var barCodeLabelNum =  document.getElementById("WebOffice").WebObject.Bookmarks.Count;
		for (i=1;i<=barCodeLabelNum;i++){
			if(document.getElementById("WebOffice").WebObject.Bookmarks.Item(i).Name=="barcode"){
				hasBarCodeLabel=true;
				break;
			}
		}

      if(hasBarCodeLabel){

	    weaver.PDF417Manager.CopyRight = "<%=PDF417ManagerCopyRight%>";
	    //设置图片宽度和高度范围,
	    //设置最小和最大均为0，则使用当前图片宽度,高度自动设置
	    var minWidth = <%=minWidth%>;
	    var maxWidth = <%=maxWidth%>;
	    var minHeight = <%=minHeight%>;
	    var maxHeight = <%=maxHeight%>;
	    weaver.PDF417Manager.LimitWidth(minWidth, maxWidth);
	    weaver.PDF417Manager.LimitHeight(minHeight, maxHeight);

	    //设置图片宽度，实际宽度将接近且不大于设置值；
	    //设置为0，则使用当前图片宽度,高度自动设置
	    weaver.PDF417Manager.BestWidth = <%=bestWidth%>;
	    weaver.PDF417Manager.BestHeight = <%=bestHeight%>;

		var PDF417TextValue="<%=PDF417TextValue%>"; 
	    //设置编码字符串
	    mResult = weaver.PDF417Manager.SetBarCodeString(PDF417TextValue,false);

        if (mResult){
			alert("<%=SystemEnv.getHtmlLabelName(21471,user.getLanguage())%>");
		}else{
			var codeFileUrl = weaver.PDF417Manager.GetBarCodeFile(".gif");  //获取条码图片数据_路径
		    codeFileUrl=codeFileUrl.replace(/\\\\/g,'\\');
		    codeFileUrl=codeFileUrl.replace(/\\/g,'\\\\');

            document.getElementById("WebOffice").WebObject.Application.Selection.GoTo(-1,0,0,"barcode");
			document.getElementById("WebOffice").WebObject.Application.Selection.InlineShapes.AddPicture (codeFileUrl);
		}
      }
<%
	}
  }
}
%>

			document.getElementById("WebOffice").EditType = t_EditType;
		}else{
		    document.getElementById("WebOffice").Template="";
		    document.getElementById("WebOffice").WebOpen();
		    document.getElementById("WebOffice").RecordID=document.getElementById("versionId").value+"_<%=docid%>";
			 <%if(isIWebOffice2006 == true){%>
				document.getElementById("WebOffice").ShowType="1";
			 <%}%>
			//WebToolsVisible("iSignature",false);
			WebToolsVisibleISignatureFalse();
		}
	}
}

function selectTemplate(seccategory,wordmouldid){
	jQuery("#selectTaohongMouldBtn").trigger("click");  
}

// repeat submit flag
var mf = false;
// save document
function onSaveOnly() {	
	jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			operation: 'workflowremark',
			requestid: <%=requestid%>,
			currentnodeid:<%=currentnodeid%>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){	
				if("success"==msg.result){			
					if(mf) {
						//console.log("submit repeated data.");
						return ;
					}
					mf = true;

					document.getElementById("hasUsedTemplet").value="1";
					document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
					document.getElementById("noSavePDF").value="TRUE";	
					var saveStatus=SaveDocument();
					document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","FALSE");
					if(saveStatus){
						setWebObjectSaved();
						alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>!");
					} else {
						alert("<%=SystemEnv.getHtmlLabelName(84544,user.getLanguage())%>!");
					}
					mf = false;	
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(24338,user.getLanguage())%>");
				}
		}
	});
}

function toForm() {
	var tab1 = parent.document.getElementById("tab1");
	jQuery(tab1).parent().find("li.current").removeClass("current");
	jQuery(tab1).addClass("current");
	jQuery(tab1).find("a").click();
	var navo = jQuery(tab1).parent().find("li.magic-line");
	navo.css("left", jQuery(tab1).offset().left - (navo.width() - jQuery(tab1).width())/2 - 5);
}

// 返回表单页面
function backToForm() {
	var status = document.getElementById("WebOffice").WebObject.Saved;
	if(status) {
		toForm();
	} else {
		if(confirm("<%=SystemEnv.getHtmlLabelName(19006,user.getLanguage())%>")){
			toForm();
		}
	}
}

function saveTHTemplate(wordmouldid){
	jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			operation: 'workflowremark',
			requestid: <%=requestid%>,
			currentnodeid:<%=currentnodeid%>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){	
				if("success"==msg.result){			
						btndisabledtrue();	
						setTimeout("btndisabledfalse();",10000);
					  if(wordmouldid != null){
						 if(window.confirm('<%=SystemEnv.getHtmlLabelName(21664,user.getLanguage())%>')){
						   document.getElementById("hasUsedTemplet").value="1";
						   <%if(isCleanCopyNodes){%>
							onCleanCopy();
						   <%}%>	   
						  if(<%=isSignatureNodes%>){
							document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
							document.getElementById("noSavePDF").value="TRUE";	
							if(<%if (!ifVersion.equals("1")) {%> SaveDocument()<%} else {%>SaveDocumentNewV()<%}%>){

							  document.getElementById("ClearDocAccessoriesTraceIframe").src="/docs/docs/ClearDocAccessoriesTraceIframe.jsp?operation=useTempletUpdate&docId=<%=docid%>&requestId=<%=requestid%>";
							}
							document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","FALSE");
						  }else{
							useTemplet();
							//if(SaveDocumentOrSaveDocumentNewV()){
							//	parent.document.getElementById("thModeS_id").style.display="none";
							//	parent.document.getElementById("thSure_id").style.display="none";
							//	parent.document.getElementById("thCancel_id").style.display="";
							//	parent.document.getElementById("thSaveAgain_id").style.display="";
							//	alert("<%=SystemEnv.getHtmlLabelNames("20227,15242",user.getLanguage())%>");
							//}
						  }
						   var isUserTemplate = parent.frames["bodyiframe"].document.getElementById("temphasUseTempletSucceed");
						 isUserTemplate.value = true;
						}else{
						  return;
						}
					  }else{
						alert("<%=SystemEnv.getHtmlLabelName(21252,user.getLanguage())%>");
					  }
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(24338,user.getLanguage())%>");
				}
		}
	});
}

function saveTHTemplateNoConfirm(wordmouldid){
	jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			operation: 'workflowremark',
			requestid: <%=requestid%>,
			currentnodeid:<%=currentnodeid%>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){	
				if("success"==msg.result){			
					//btndisabledtrue();
					//setTimeout("btndisabledfalse();",10000);
					if(wordmouldid != null){
						 document.getElementById("hasUsedTemplet").value=1;
						if(<%=isSignatureNodes%>){
							document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
							document.getElementById("noSavePDF").value="TRUE";	
							if(<%if (!ifVersion.equals("1")) {%> SaveDocument()<%} else {%>SaveDocumentNewV()<%}%>){
								document.getElementById("ClearDocAccessoriesTraceIframe").src="/docs/docs/ClearDocAccessoriesTraceIframe.jsp?operation=useTempletUpdate&docId=<%=docid%>&requestId=<%=requestid%>";
							}
							document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","FALSE");
						}else{
							//useTemplet();
							document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
							var saveFlag = SaveDocumentOrSaveDocumentNewV();
							document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","FALSE");
							if(saveFlag){
								alert("<%=SystemEnv.getHtmlLabelNames("18758",user.getLanguage())%>");
							}
						}

					}else{
						alert("<%=SystemEnv.getHtmlLabelName(21252,user.getLanguage())%>");
					}	
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(24338,user.getLanguage())%>");
				}
		}
	});
}

function useTempletCancel(){
	jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			operation: 'workflowremark',
			requestid: <%=requestid%>,
			currentnodeid:<%=currentnodeid%>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){	
				if("success"==msg.result){			
					btndisabledtrue();
					setTimeout("btndisabledfalse();",10000);

					if(window.confirm('<%=SystemEnv.getHtmlLabelName(22984,user.getLanguage())%>')){
						document.getElementById("DocCheckInOutUtilIframe").src="/docs/docs/DocCheckInOutUtilIframe.jsp?operation=useTempletCancel&docId=<%=docid%>&versionId=<%=versionId%>&userId=<%=user.getUID()%>";
						var isUserTemplate = parent.frames["bodyiframe"].document.getElementById("temphasUseTempletSucceed");
					 isUserTemplate.value = false;
					}
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(24338,user.getLanguage())%>");
				}
		}
	});
}

function useTempletCancelReturn(returnVersionId){

	if(returnVersionId==""){
		return;
	}

		document.getElementById("WebOffice").Template="<%=wordmouldid%>";
        document.getElementById("selectedpubmouldid").value="<%=wordmouldid%>";
		document.getElementById("WebOffice").WebSetMsgByName("SHOWDOCMOULDBOOKMARK","<%=fromFlowDoc%>");//载入是否显示“文档模板书签表”数据,这根据“是否来源于流程建文挡”来确定。		
	    
		document.getElementById("WebOffice").WebSetMsgByName("COMMAND","LOADVIEWMOULD");//载入显示模板

		if(document.getElementById("WebOffice").WebLoadTemplate()){//如果打开模板成功
		    WebToolsVisible("iSignature",false);
			var t_EditType = document.getElementById("WebOffice").EditType;
			document.getElementById("WebOffice").EditType = "-1,0,0,0,0,0,1<%=canPostil%>";
		    document.getElementById("WebOffice").RecordID=document.getElementById("versionId").value+"_<%=docid%>";
		    document.getElementById("WebOffice").WebLoadBookMarks();//替换书签
		    document.getElementById("versionId").value=returnVersionId;
		    document.getElementById("WebOffice").RecordID=document.getElementById("versionId").value+"_<%=docid%>";
		    document.getElementById("WebOffice").WebInsertFile();//插入正文

<%
//套红时插入二维条码
if(fromFlowDoc.equals("1")){
  String isUseBarCode = Util.null2String(BaseBeanOfDocDspExt.getPropValue("weaver_barcode","ISUSEBARCODE"));
  if(isUseBarCode.equals("1")){
	//判断是否启用二维条码
	RecordSet.executeSql("select * from Workflow_BarCodeSet where workflowId="+workflowid+" and isUse='1'");

	if(RecordSet.next()){
		int barCodeSetId=Util.getIntValue(RecordSet.getString("id"),0);
		String measureUnit=Util.null2String(RecordSet.getString("measureUnit"));
		int printRatio = Util.getIntValue(RecordSet.getString("printRatio"),96);
		int minWidth = Util.getIntValue(RecordSet.getString("minWidth"),30);
		int maxWidth = Util.getIntValue(RecordSet.getString("maxWidth"),70);
		int minHeight = Util.getIntValue(RecordSet.getString("minHeight"),10);
		int maxHeight = Util.getIntValue(RecordSet.getString("maxHeight"),25);
		int bestWidth = Util.getIntValue(RecordSet.getString("bestWidth"),50);
		int bestHeight = Util.getIntValue(RecordSet.getString("bestHeight"),20);

		if(measureUnit.equals("1")){
			minWidth=(int)(0.5+minWidth*printRatio/25.4);
			maxWidth=(int)(0.5+maxWidth*printRatio/25.4);
			minHeight=(int)(0.5+minHeight*printRatio/25.4);
			maxHeight=(int)(0.5+maxHeight*printRatio/25.4);
			bestWidth=(int)(0.5+bestWidth*printRatio/25.4);
			bestHeight=(int)(0.5+bestHeight*printRatio/25.4);
		}

		String PDF417TextValue=WorkflowBarCodeSetManager.getPDF417TextValue(requestid,barCodeSetId,user.getLanguage());
%>
        var hasBarCodeLabel=false;
        var barCodeLabelNum =  document.getElementById("WebOffice").WebObject.Bookmarks.Count;
		for (i=1;i<=barCodeLabelNum;i++){
			if(document.getElementById("WebOffice").WebObject.Bookmarks.Item(i).Name=="barcode"){
				hasBarCodeLabel=true;
				break;
			}
		}

      if(hasBarCodeLabel){

	    weaver.PDF417Manager.CopyRight = "<%=PDF417ManagerCopyRight%>";
	    //设置图片宽度和高度范围,
	    //设置最小和最大均为0，则使用当前图片宽度,高度自动设置
	    var minWidth = <%=minWidth%>;
	    var maxWidth = <%=maxWidth%>;
	    var minHeight = <%=minHeight%>;
	    var maxHeight = <%=maxHeight%>;
	    weaver.PDF417Manager.LimitWidth(minWidth, maxWidth);
	    weaver.PDF417Manager.LimitHeight(minHeight, maxHeight);

	    //设置图片宽度，实际宽度将接近且不大于设置值；
	    //设置为0，则使用当前图片宽度,高度自动设置
	    weaver.PDF417Manager.BestWidth = <%=bestWidth%>;
	    weaver.PDF417Manager.BestHeight = <%=bestHeight%>;

		var PDF417TextValue="<%=PDF417TextValue%>"; 
	    //设置编码字符串
	    mResult = weaver.PDF417Manager.SetBarCodeString(PDF417TextValue,false);

        if (mResult){
			alert("<%=SystemEnv.getHtmlLabelName(21471,user.getLanguage())%>");
		}else{
			var codeFileUrl = weaver.PDF417Manager.GetBarCodeFile(".gif");  //获取条码图片数据_路径
		    codeFileUrl=codeFileUrl.replace(/\\\\/g,'\\');
		    codeFileUrl=codeFileUrl.replace(/\\/g,'\\\\');

            document.getElementById("WebOffice").WebObject.Application.Selection.GoTo(-1,0,0,"barcode");
			document.getElementById("WebOffice").WebObject.Application.Selection.InlineShapes.AddPicture (codeFileUrl);
		}
      }
<%
	}
  }
}
%>

			document.getElementById("WebOffice").EditType = t_EditType;
		}else{
		    document.getElementById("WebOffice").Template="";
		    document.getElementById("versionId").value=returnVersionId;
		    document.getElementById("WebOffice").RecordID=document.getElementById("versionId").value+"_<%=docid%>";
		    document.getElementById("WebOffice").WebOpen();
			 <%if(isIWebOffice2006 == true){%>
				document.getElementById("WebOffice").ShowType="1";
			 <%}%>
			WebToolsVisible("iSignature",false);
		}
		try{
			//Ext.getCmp("thCancel_id").hide();
			parent.document.getElementById("thCancel_id").style.display = "none";
		}catch(e){
		}
		try{
			//Ext.getCmp("thSaveAgain_id").hide();
			parent.document.getElementById("thSaveAgain_id").style.display = "none";
		}catch(e){
		}
		try{
			//Ext.getCmp("thSure_id").show();
			parent.document.getElementById("thSure_id").style.display = "";
		}catch(e){
		}
		try{
			<%if(countNum > 1 &&isUseTempletNode&&isremark==0){%>
			    //Ext.getCmp("thModeS_id").show();
			    parent.document.getElementById("thModeS_id").style.display = "";	
			<%}%>

		}catch(e){
		}
        try{
        	//Ext.getCmp("signature_id1").hide();
			parent.document.getElementById("signature_id1").style.display = "none";
        }catch(e){
        }
        try{
        	//Ext.getCmp("signature_id2").hide();
			parent.document.getElementById("signature_id2").style.display = "none";
        }catch(e){
        }

		try{
			document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(19718,user.getLanguage())%>");
		}catch(e){
		}
}

var stSign = 0x00000001;     //电子签章
var stHand = 0x00000002;     //手写签名
var stSign_360 = 0x00000000;  //360电子签章
var stHand_360 = 0x00000001;  //360手写签名
var  ssSucceeded = 0x0000;   //成功
var  ssDocumentLocked    = 0x0003;     //文档已经锁定

//作用：设置活动文档对象
function SetActiveDocument(){

	if(weaver.WebOffice.WebObject != null){
		//若为360签章
		if("2" == signatureType){
			if (weaver.WebOffice.FileType == ".doc") {
				weaver.SignatureAPI.SetActiveDocument(weaver.WebOffice.WebObject);   //设置WORD对象
			}
			if (weaver.WebOffice.FileType == ".xls") {
				weaver.SignatureAPI.SetActiveDocument(weaver.WebOffice.WebObject);   //设置EXCEL对象
			}
		}else{
			if (document.getElementById("WebOffice").FileType==".doc"){
				weaver.SignatureAPI.ActiveDocument=document.getElementById("WebOffice").WebObject;   //设置WORD对象
			}  
			if (document.getElementById("WebOffice").FileType==".xls"){
				weaver.SignatureAPI.ActiveDocument=document.getElementById("WebOffice").WebObject.Application.ActiveWorkbook.ActiveSheet;   //设置EXCEL对象
			}
		}
	} 
}

//签章
function CreateSignature(id){
  <%if(isIWebOffice2006 == true){%>
	   if(document.getElementById("WebOffice").Pages >=1){
		  document.getElementById("WebOffice").ShowType="1";								 
	   }
  <%}%>
  SetActiveDocument();   //设置活动文档

    var revisionsCount=0;

    try{
	    revisionsCount=document.getElementById("WebOffice").WebObject.Revisions.Count;
    }catch(e){
    }

    var signatureCount=0;
    try{
		try{
			weaver.SignatureAPI.InitSignatureItems();  //当签章数据发生变化时，请重新执行该方法
		}catch(e){}
		if("1" == signatureType){//WPS混合签章
			signatureCount = weaver.SignatureAPI.iSignatureCount();
		}else if("2" == signatureType){//360签章
			signatureCount = weaver.SignatureAPI.AllSignatureCount;
		}else{
			signatureCount=weaver.SignatureAPI.SignatureCount;
		}
    }catch(e){
    }
    if(revisionsCount>0&&signatureCount<=0){
		document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
		document.getElementById("noSavePDF").value="TRUE";	
<%
if(ifVersion.equals("1")){
%>
        SaveDocumentNewV();
<%
}else if("1".equals(isCompellentMark)){
%>
	    if(hasAcceptAllRevisions=="true"){
            SaveDocumentNewV();
            hasAcceptAllRevisions="false";
        }else{
			SaveDocument();
		}
<%
}else{
%>
        SaveDocument();
<%
}
%>
        document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","FALSE");
	    if("1" == signatureType){//WPS混合签章
		    weaver.SignatureAPI.UnLockDocument();	//解保护
		}else{
			if(weaver.SignatureAPI.SelectionState==ssDocumentLocked) {
				weaver.SignatureAPI.UnLockDocument();	//解保护
			}
		}
        //在清样稿上加盖公章
        document.getElementById("WebOffice").WebObject.AcceptAllRevisions(); //接受痕迹
        hasAcceptAllRevisions="true";
    }

    var t_EditType = document.getElementById("WebOffice").EditType;
	//document.getElementById("WebOffice").EditType = "-1,0,0,0,0,0,1<%=canPostil%>";

    var t_TrackRevisions = false;
	try{
		t_TrackRevisions = document.getElementById("WebOffice").WebObject.TrackRevisions;
	    document.getElementById("WebOffice").WebObject.TrackRevisions = false;  //取消修订
	}catch(e){}

    //电子签章
  if(id==0){
		//WPS混合签章
	   if("1" == signatureType){
			weaver.SignatureAPI.ActiveDocument=weaver.WebOffice.WebObject;
			try{
			  weaver.SignatureAPI.CreateSignature(stSign);	//建立电子签章			
			}catch(e){
				try{
					weaver.SignatureAPI.EndLoadSignature();          //释放调用资源             
					weaver.SignatureAPI.ReleaseActiveDocument();
				}catch(e){}		
			}
	   }else if("2" == signatureType){//360签章
		   	try{				
				weaver.SignatureAPI.SetSignatureParam("SealPosLock","true",1); 	//锁定签章不移动
				weaver.SignatureAPI.Action_Do(stSign_360);	//建立电子签章
			}catch(e){	
			}
	   }else{//Office签章	
			if(weaver.SignatureAPI.SelectionState==ssSucceeded) {
				try{
					weaver.SignatureAPI.CreateSignature(stSign);	//建立电子签章
				}catch(e){
					try{
						weaver.SignatureAPI.ActionAddinButton(stSign);	//建立电子签章
						weaver.SignatureAPI.ReleaseActiveDocument();
					}catch(e){}		
				}
			}else if(weaver.SignatureAPI.SelectionState==ssDocumentLocked) {

				 weaver.SignatureAPI.UnLockDocument();	//解保护
				try{
					weaver.SignatureAPI.CreateSignature(stSign);	//建立电子签章
				}catch(e){
					try{
						weaver.SignatureAPI.ActionAddinButton(stSign);	//建立电子签章
						weaver.SignatureAPI.ReleaseActiveDocument();
					}catch(e){}		
				}
			}
	   }
    }

	try{
		document.getElementById("WebOffice").WebObject.TrackRevisions = t_TrackRevisions;  
	}catch(e){}

	//document.getElementById("WebOffice").EditType = t_EditType;
 }

  //签章确认
 function saveIsignatureFun(){
	btndisabledtrue();
	setTimeout("btndisabledfalse();",10000);

  <%if(isIWebOffice2006 == true){%>
	   if(document.getElementById("WebOffice").Pages >=1){
		  document.getElementById("WebOffice").ShowType="1";								 
	   }
  <%}%>
  if(window.confirm('<%=SystemEnv.getHtmlLabelName(21667,user.getLanguage())%>')){

	   try{
		    SetActiveDocument();   //设置活动文档
		    try{
				weaver.SignatureAPI.InitSignatureItems();  //当签章数据发生变化时，请重新执行该方法
		    }catch(e){}	
			//签章个数
			var newSignatureCount=0;
			if("1" == signatureType){//WPS混合签章
				newSignatureCount = weaver.SignatureAPI.iSignatureCount();
			}else if("2" == signatureType){//360签章
				newSignatureCount = weaver.SignatureAPI.AllSignatureCount;
			}else{
				newSignatureCount=weaver.SignatureAPI.SignatureCount;
			}
			if(newSignatureCount!=document.getElementById("signatureCount").value){

				document.getElementById("DocCheckInOutUtilIframe").src="/docs/docs/DocCheckInOutUtilIframe.jsp?operation=saveIsignatureFun&requestid=<%=requestid%>&nodeId=<%=nodeid%>&userId=<%=user.getUID()%>&loginType=<%=Util.getIntValue(user.getLogintype(),1)%>&signNum="+(newSignatureCount-document.getElementById("signatureCount").value);
				return ;
			}
	   }catch(e){

	   }

       document.getElementById("WebOffice").WebSetMsgByName("CLEARHANDWRITTEN","TRUE");//ClearHandwritten   清除手写批注

       useTempletNoChangeDocAccessories();
  }
}
function docVersionWord(vid){
	used4SelectAccVersion(vid);
    
	
}

function onCleanCopy(){
	try{
	  <%if(isIWebOffice2006 == true){%>
		   if(document.getElementById("WebOffice").Pages >=1){
			  document.getElementById("WebOffice").ShowType="1";								 
		   }
	  <%}%>


		var revisionsCount=0;

		try{
			revisionsCount=document.getElementById("WebOffice").WebObject.Revisions.Count;
		}catch(e){
		}

		if(revisionsCount>0){
			document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");

			SaveDocumentNewV();

			document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","FALSE");

			document.getElementById("WebOffice").WebObject.AcceptAllRevisions(); 
		}

	}catch(e){
	}
}
function onDocShare(docid,docsubject){
	var message='[{"shareid":'+docid+',"sharetitle":"'+docsubject+'","sharetype":"doc","objectname":"FW:CustomShareMsg"}]';
	socialshareToEmessage(message);
}	 
</script>
<script language="vbs">
    function docVersionWord2(vid)
    url=escape("/docs/docs/listVersion.jsp?versionId="&vid&"&docid=<%=docid%>")
    id2 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if (Not IsEmpty(id1)) then
    if id1(0)<> "" then
    window.location="DocDspExt.jsp?id=<%=docid%>&versionId="&id1(0)&"&fromFlowDoc=<%=fromFlowDoc%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&isFromAccessory=<%=isFromAccessory%>&isNoTurnWhenHasToPage=true&topage=<%=URLEncoder.encode(topageFromOther)%>&meetingid=<%=meetingid%>"
    end if
    end if
    end function

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