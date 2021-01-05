
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocMouldAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
if("false".equals(isIE)){	
	request.setAttribute("labelid","125483");
	request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);		
	return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
String  docType=Util.null2String(request.getParameter("docType"));
String id = Util.null2String(request.getParameter("id"));
if(docType.equals("")){
    docType=".doc";
}
String  mouldname=Util.null2String(request.getParameter("mouldname"));

String docMouldExistedId=Util.null2String(request.getParameter("docMouldExistedId"));
if(docMouldExistedId==null||"0".equals(docMouldExistedId)) docMouldExistedId = "";

String docid = Util.null2String(request.getParameter("id"));
if(docid==null||"0".equals(docid)) docid = "";

String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

String docMouldExistedName = "";
String docMouldExistedText = "";
String docMouldExistedType = "";
String mouldName = "";
if(!"".equals(id)){
	MouldManager.setId(Util.getIntValue(id,0));
	MouldManager.getMouldInfoById();
	mouldName=MouldManager.getMouldName();
}
int subcompanyid = 0;
if(!docMouldExistedId.equals("")){
	int currentMouldType = 2;
	MouldManager.setId(Util.getIntValue(docMouldExistedId,0));
	MouldManager.getMouldInfoById();
	docMouldExistedName=MouldManager.getMouldName();
	docMouldExistedText=MouldManager.getMouldText();
	currentMouldType = MouldManager.getMouldType();
	subcompanyid = MouldManager.getSubcompanyid();
	docMouldExistedType=".doc";
	if(currentMouldType==2){
		docMouldExistedType=".doc";
	}else if(currentMouldType==3){
		docMouldExistedType=".xls";
	}else{
		docMouldExistedType=".doc";
	}
	MouldManager.closeStatement();
}
int operatelevel=0;
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
if(detachable==1){
	if(subcompanyid==0){
	String hasRightSub=String.valueOf(session.getAttribute("docdftsubcomid"));
	String hasRightSubFirst="";
	if(!hasRightSub.equals("")){
	 if(hasRightSub.indexOf(',')>-1){  
	      hasRightSubFirst=Util.null2String(hasRightSub.substring(0,hasRightSub.indexOf(',')));
        }else{
          hasRightSubFirst=hasRightSub;
        }
	 subcompanyid=Util.getIntValue(hasRightSubFirst,0);
    }
	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("showMould_subcompanyid")),subcompanyid);
	}
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldAdd:Add",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("DocMouldAdd:Add", user))
        operatelevel=2;
}

%>
<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>

<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<script language="javascript" type="text/javascript">
var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
window.onload=function(){
	//FCKEditorExt.initEditor('weaver','mouldtext',lang);
};
</script>

<script language="javascript">

var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);
if("<%=isclose%>"=="1"){
	//parentWin.location="DocMould.jsp";
	if(jQuery("#from",parentWin.document).val()=="attachMould"){
		var data = {};
		data.id="<%=id%>";
		data.name = "<%=mouldName%>";
		dialog.callback(data);
	}else{
		parentWin._table.reLoad();
		dialog.close();	
	}
}

function StatusMsg(mString){
  //StatusBar.innerText=mString;
}

function WebSaveLocal(){
  try{
    weaver.WebOffice.WebSaveLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){}
}

function WebOpenLocal(){
  try{
    weaver.WebOffice.WebOpenLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){
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

function SaveDocument(){

    var tempFileName=document.all("mouldname").value;
	tempFileName=tempFileName.replace(/\\/g,'＼');
	tempFileName=tempFileName.replace(/\//g,'／');
	tempFileName=tempFileName.replace(/:/g,'：');
	tempFileName=tempFileName.replace(/\*/g,'×');
	tempFileName=tempFileName.replace(/\?/g,'？');
	tempFileName=tempFileName.replace(/\"/g,'“');
	tempFileName=tempFileName.replace(/</g,'＜');
	tempFileName=tempFileName.replace(/>/g,'＞');
	tempFileName=tempFileName.replace(/\|/g,'｜');
	tempFileName=tempFileName.replace(/\./g,'．');
	tempFileName = tempFileName+'<%=docType%>';
    document.getElementById("WebOffice").FileName=tempFileName;

    weaver.WebOffice.FileType=changeFileType(weaver.WebOffice.FileType);

  if (!weaver.WebOffice.WebSave(<%=isNoComment%>)){
     StatusMsg(weaver.WebOffice.Status);
     top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19007,user.getLanguage())%>");
     return false;
  }else{
    StatusMsg(weaver.WebOffice.Status);
    //alert(weaver.WebOffice.WebGetMsgByName("CREATEID"));
    weaver.id.value=weaver.WebOffice.WebGetMsgByName("CREATEID");
    weaver.docType.value=weaver.WebOffice.WebGetMsgByName("DOCTYPE");
    //alert(weaver.id.value);
    //alert(weaver.docType.value);
    return true;
  }
}

function SaveBookmarks(){
  <%if(".doc".equals(docType)||".wps".equals(docType)){%>
    var bookmarkNames="";
    var count =  weaver.WebOffice.WebObject.Bookmarks.Count;
    for (i=1;i<=count;i++){
	    bookmarkNames+=","+weaver.WebOffice.WebObject.Bookmarks.Item(i).Name;
	}
	if(bookmarkNames!=""){
		bookmarkNames=bookmarkNames.substr(1);
    }

    weaver.WebOffice.WebSetMsgByName("BOOKMARKNAMES",bookmarkNames);
  <%}%>
if(!weaver.WebOffice.WebSaveBookmarks()){
     StatusMsg(weaver.WebOffice.Status);
     alert(weaver.WebOffice.Status);
     return false;
  }else{
    StatusMsg(weaver.WebOffice.Status);
    return true;
  }
}

function Load(){
  //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="<%=docMouldExistedId%>";
  weaver.WebOffice.Template="";
  weaver.WebOffice.FileName="";
  weaver.WebOffice.FileType="<%=docType%>";
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 鐗规湁鍐呭寮€濮?
  weaver.WebOffice.EditType="1,1";
  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:鏄惁鏄剧ず宸ュ叿鏍?1鏄剧ず,0涓嶆樉绀?
//iWebOffice2006 鐗规湁鍐呭缁撴潫
<%}else{%>
  weaver.WebOffice.EditType="1";
<%}%>
  weaver.WebOffice.UserName="<%=user.getUsername()%>";

<%if(user.getLanguage()==7){%>
  weaver.WebOffice.Language="CH";
<%}else if(user.getLanguage()==9){%>
  weaver.WebOffice.Language="TW";
<%}else{%>
  weaver.WebOffice.Language="EN";
<%}%>
  weaver.WebOffice.WebOpen();  	//鎵撳紑璇ユ枃妗?
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 鐗规湁鍐呭寮€濮?
  weaver.WebOffice.ShowType="1";  //鏂囨。鏄剧ず鏂瑰紡  1:琛ㄧず鏂囧瓧鎵规敞  2:琛ㄧず鎵嬪啓鎵规敞  0:琛ㄧず鏂囨。鏍哥
//iWebOffice2006 鐗规湁鍐呭缁撴潫
<%}%>
  StatusMsg(weaver.WebOffice.Status);

  }catch(e){}
}




function UnLoad(){
  try{
  if (!weaver.WebOffice.WebClose()){
     StatusMsg(weaver.WebOffice.Status);
  }else{
     StatusMsg("<%=SystemEnv.getHtmlLabelName(19716,user.getLanguage())%>");
  }
  }catch(e){}
}


</script>
</head>
<%

String urlfrom = request.getParameter("urlfrom");

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16450,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body onLoad="Load()" onUnload="UnLoad()">
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16381,user.getLanguage())+",javascript:WebOpenLocal(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16382,user.getLanguage())+",javascript:WebSaveLocal(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isDialog.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mould/DocMould.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="WebOpenLocal();" value="<%=SystemEnv.getHtmlLabelName(16381, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="WebSaveLocal();" value="<%=SystemEnv.getHtmlLabelName(16382, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input TYPE="hidden" id="id" NAME="id" value="">
<input TYPE="hidden" id="docType" NAME="docType" value="">
<input type="hidden" name="isdialog" value="<%=isDialog%>">

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="mouldnamespan" required="true"value='<%=mouldname%>'>
				<input temptitle="<%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%>" class=InputStyle size=70 name=mouldname value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
			</wea:required>
		</wea:item>
		<%if(detachable==1){ %>
			<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" language='<%=""+user.getLanguage() %>'
							hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
							completeUrl="/data.jsp?type=164" width="80%" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
							browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
					</brow:browser>
				</span>
			</wea:item>
		<%}%>
		<wea:item>
			<script language=javascript>
				var docSelectIndex=0;
				function onChangeDocType(doPage,docType){
					if(confirm("<%=SystemEnv.getHtmlLabelName(18691,user.getLanguage())%>")){
						location=doPage+'?isWorkflowDoc=<%=isWorkflowDoc%>&isdialog=<%=isDialog%>&mouldname='+weaver.mouldname.value+'&docType='+docType;
					}else{
						weaver.sdoctype[docSelectIndex].checked=true;
					}
					//weaver.sdoctype[docSelectIndex].checked=true;
					return false;

				}
			</script>
			<%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<div >
				<%if(!isWorkflowDoc.equals("1")){ %>
					<input TYPE="radio" NAME="sdoctype" <%=(docType.equals(".htm")?"checked":"")%> onClick="onChangeDocType('/docs/mould/DocMouldAdd.jsp','.htm')">HTML&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
				<%} %>
				<input TYPE="radio" NAME="sdoctype" <%=(docType.equals(".doc")?"checked":"")%> onClick="onChangeDocType('/docs/mould/DocMouldAddExt.jsp','.doc')">WORD&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
				<input TYPE="radio" NAME="sdoctype" <%=(docType.equals(".wps")?"checked":"")%>  onClick="onChangeDocType('/docs/mould/DocMouldAddExt.jsp','.wps')"><%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>

			</div>
			<script language=javascript>
			for(i=0; i<weaver.sdoctype.length; i++){
				if(weaver.sdoctype[i].checked){
					docSelectIndex=i;
				}
			}
			</script>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19333,user.getLanguage())%></wea:item>
		<wea:item>
			<span>
				<%String extraparams = "{'docType':'"+docType+"'}"; %>
				   <brow:browser viewType="0" name="docMouldExistedId" browserValue='<%= ""+docMouldExistedId %>' 
					_callback="afterOnShowMould"
					browserUrl='<%="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/mould/DocMouldBrowser.jsp?doctype="+docType%>' language='<%=""+user.getLanguage() %>'
					getBrowserUrlFn="getBrowserUrlFn"
					temptitle='<%=SystemEnv.getHtmlLabelName(19333,user.getLanguage())%>'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=-99996" linkUrl="#" width="90%"
					browserSpanValue='<%= docMouldExistedName %>' extraParams='<%= extraparams %>'></brow:browser>
			   </span>
		</wea:item>
		<wea:item><%= SystemEnv.getHtmlLabelName(85 ,user.getLanguage())%></wea:item>
			<wea:item>
				<%= SystemEnv.getHtmlLabelName(125484 ,user.getLanguage())%>
			</wea:item>
		<wea:item attributes="{'colspan':'full'}"><textarea name=mouldtext style="display:none;width:100%;height:500px"></textarea></wea:item>
		<wea:item attributes="{'colspan':'full'}">
			<iframe id="e8shadowifrm" name="e8shadowifrm" frameborder="none" scrolling="no" style="overflow:hidden;z-index:1;width:100%;height:23px;position:absolute;top:37px;visibility:hidden;left:0px;background-color:#fff;" src="javascript:return false;"></iframe>

			<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;position:relative;">
				<object  id="WebOffice" style="POSITION: relative;top:-23px" width="100%"  height="680"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
				</object>
			</div>
		</wea:item>
		<wea:item attributes="{'colspan':'full'}"><span id=StatusBar>&nbsp;</span></wea:item>
	</wea:group>
</wea:layout>
<input type=hidden name=operation>
<input type=hidden name=urlfrom value="<%=urlfrom%>">
</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
<script>
var isdocexisted = false;

function getBrowserUrlFn(){
	var tmpdoctype = ".doc";
	if(document.weaver.sdoctype[2].checked) tmpdoctype = ".wps";
	return "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/mould/DocMouldBrowser.jsp?doctype="+tmpdoctype;
	
}

function afterOnShowMould(e,id1,fieldid,params){
	if(id1!=null){
		
		if(isdocexisted)
		location="/docs/mould/DocMouldAddExt.jsp?isdialog=<%=isDialog%>&id="+weaver.id.value+"&mouldname="+document.weaver.mouldname.value+"&docType="+tmpdoctype+"&docMouldExistedId="+id1.id;
		else if("<%=docid%>"!="")
		location="/docs/mould/DocMouldAddExt.jsp?isdialog=<%=isDialog%>&id=<%=docid%>&mouldname="+document.weaver.mouldname.value+"&docType="+tmpdoctype+"&docMouldExistedId="+id1.id;
		else
		location="/docs/mould/DocMouldAddExt.jsp?isdialog=<%=isDialog%>&mouldname="+document.weaver.mouldname.value+"&docType="+tmpdoctype+"&docMouldExistedId="+id1.id;
	}
}

function onShowMould(){
	var tmpdoctype = ".doc";
	if(document.weaver.sdoctype[2].checked) tmpdoctype = ".xls";
	var id1 = window.showModalDialog("DocMouldBrowser.jsp?doctype="+tmpdoctype);
	if(id1!=null){
		
		document.weaver.docMouldExistedId.value = id1.id;
		docMouldExistedName.innerHTML = "<a href='DocMouldDspExt.jsp?id="+id1.id+"'>"+id1.name+"</a>";
		if(isdocexisted)
		location="DocMouldAddExt.jsp?isdialog=<%=isDialog%>&id="+weaver.id.value+"&mouldname="+document.weaver.mouldname.value+"&docType="+tmpdoctype+"&docMouldExistedId="+id1.id;
		else if("<%=docid%>"!="")
		location="DocMouldAddExt.jsp?isdialog=<%=isDialog%>&id=<%=docid%>&mouldname="+document.weaver.mouldname.value+"&docType="+tmpdoctype+"&docMouldExistedId="+id1.id;
		else
		location="DocMouldAddExt.jsp?isdialog=<%=isDialog%>&mouldname="+document.weaver.mouldname.value+"&docType="+tmpdoctype+"&docMouldExistedId="+id1.id;
	}
}

function onSave(){
	if(check_form(document.weaver,'mouldname')){
		<%if(detachable==1){ %>
    		if(check_form(document.weaver,'subcompanyid')){
    	<%}%>
		if("<%=docid%>"!=""){
		    document.weaver.id.value="<%=docid%>";
		    document.weaver.docType.value="<%=docType%>";
			weaver.WebOffice.RecordID="<%=docid%>";
  			weaver.WebOffice.FileType="<%=docType%>";
	    	weaver.WebOffice.WebSetMsgByName("SAVETYPE","EDIT");
	    	top.Dialog.alert(weaver.WebOffice.RecordID);
	    	top.Dialog.alert(document.weaver.id.value);
		}
		document.weaver.operation.value='add';
        if(SaveDocument()){
        	if(SaveBookmarks()){
        		if("<%=docid%>"!=""){
				    document.weaver.id.value="<%=docid%>";
				    document.weaver.docType.value="<%=docType%>";
        		}
		    	document.weaver.submit();
		    } else {
			    document.weaver.id.value=weaver.WebOffice.WebGetMsgByName("CREATEID");
			    document.weaver.docType.value=weaver.WebOffice.WebGetMsgByName("DOCTYPE");
				weaver.WebOffice.RecordID=weaver.id.value;
		    	weaver.WebOffice.WebSetMsgByName("SAVETYPE","EDIT");
		    	isdocexisted = true;
		    }
        }
        <%if(detachable==1){ %>
        }
        <%}%>
	}
}
</script>
</body>
