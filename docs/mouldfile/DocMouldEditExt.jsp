<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
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
String operation = Util.null2String(request.getParameter("operation"));
String groupAttrs="{'groupDisplay':''}";
String groupAttrs2="{'groupDisplay':'none'}";

String itemAttrs="{'display':''}";
String itemAttrs2="{'colspan':'full'}";
String hiddiv="";
if(operation.equals("add")){
 groupAttrs="{'groupDisplay':'none'}"; 
  groupAttrs2="{'groupDisplay':'none','itemAreaDisplay':'none'}"; 
 itemAttrs="{'display':'none'}"; 
 itemAttrs2="{'colspan':'full','display':'none'}"; 
 hiddiv="display:none";
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
var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);
if("<%=isclose%>"=="1"){
	//parentWin.location="/docs/mould/DocMould.jsp";
	parentWin._table.reLoad();
	parentWin.closeDialog();	
}
</script>

</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%

//编辑：王金永
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);
//int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int detachable = 0;
ManageDetachComInfo comInfo =  new ManageDetachComInfo();
boolean isUseHrmManageDetach=comInfo.isUseDocManageDetach();
if(isUseHrmManageDetach){
	detachable=1;
}
int subcompanyid1 = Util.getIntValue(request.getParameter("subcompanyid1"),-1);

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

int id = Util.getIntValue(request.getParameter("id"),0);

String urlfrom = Util.null2String(request.getParameter("urlfrom"));
MouldManager.setId(id);
MouldManager.getMouldInfoById();
String mouldname=MouldManager.getMouldName();
if(operation.equals("add")){
	mouldname="";
	}
String mouldtext=MouldManager.getMouldText();
int mouldType = MouldManager.getMouldType();
int subcompanyid = MouldManager.getSubcompanyid2();
int operatelevel=0;
	if(detachable==1){
		operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldEdit:Edit",subcompanyid);
	}else{
	    if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user))
	        operatelevel=2;
	}
String docType=".doc";
if(mouldType==2){
    docType=".doc";
}else if(mouldType==3){
    docType=".xls";
}else if(mouldType==4){
    docType=".wps";
}else if(mouldType==5){
    docType=".et";
}else{
    docType=".doc";
}


MouldManager.closeStatement();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(64,user.getLanguage());
}else{
  titlename = SystemEnv.getHtmlLabelName(16449,user.getLanguage())+"："+mouldname;
}
String needfav ="1";
String needhelp ="";
%>

<script language="javascript" >

function StatusMsg(mString){
  StatusBar.innerText=mString;
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

function Load(){
  //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="<%=id%>";
  weaver.WebOffice.Template="";
  weaver.WebOffice.FileName="";
  weaver.WebOffice.FileType="<%=docType%>";
  //weaver.WebOffice.EditType="1";
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.EditType="3,1";
  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
//iWebOffice2006 特有内容结束
<%}else{%>
  weaver.WebOffice.EditType="3";
<%}%>
  weaver.WebOffice.UserName="<%=user.getUsername()%>";
  weaver.WebOffice.WebOpen();  	//打开该文档
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
//iWebOffice2006 特有内容结束
<%}%>
  StatusMsg(weaver.WebOffice.Status);

  }catch(e){}
}



function UnLoad(){
  try{
  if (!weaver.WebOffice.WebClose()){
     StatusMsg(weaver.WebOffice.Status);
  }else{
     StatusMsg("<%=SystemEnv.getHtmlLabelName(19716,user.getLanguage())%>...");
  }
  }catch(e){}
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
<%if(operation.equals("add")){%>
    weaver.WebOffice.WebSetMsgByName("SAVETYPE","ADD");
    weaver.WebOffice.RecordID="";
<%}else{%>
    weaver.WebOffice.WebSetMsgByName("SAVETYPE","EDIT");
<%}%>
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
<%if(operation.equals("add")){%>
        weaver.id.value=weaver.WebOffice.WebGetMsgByName("CREATEID");
        weaver.docType.value=weaver.WebOffice.WebGetMsgByName("DOCTYPE");
<%}%>
        StatusMsg(weaver.WebOffice.Status);
        return true;
    }
}

function SaveBookmarks(){
<%if(urlfrom.equals("hr")){%>
        return true;
<%}else{%>

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

    weaver.WebOffice.WebSetMsgByName("ISEDITMOULD","TRUE");
    if(!weaver.WebOffice.WebSaveBookmarks()){
        StatusMsg(weaver.WebOffice.Status);
        top.Dialog.alert(weaver.WebOffice.Status);
        return false;
    }else{
        StatusMsg(weaver.WebOffice.Status);
        return true;
    }
  <%}else{%>
        return true;
  <%}%>
<%}%>


}

</script>
<body onLoad="Load()" onUnload="UnLoad()">
<%if("2".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!operation.equals("add")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16381,user.getLanguage())+",javascript:WebOpenLocal(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16382,user.getLanguage())+",javascript:WebSaveLocal(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isDialog.equals("2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mouldfile/DocMould.jsp?urlfrom="+urlfrom+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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

<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data" onsubmit="return false;" >
<input type=hidden name=urlfrom value="<%=urlfrom%>">

<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="<%=groupAttrs %>" >
		<%if(operation.equals("add")){%>
		<wea:item></wea:item>
			<wea:item>
				
			</wea:item>
			<%}%>
			<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="mouldnamespan" required="true"value='<%=mouldname%>'>
					<input class=InputStyle size=70 name=mouldname value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
				</wea:required>
			</wea:item>
			<%if(detachable==1){ %>
				<wea:item attributes="<%=itemAttrs %>"><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
				<wea:item attributes="<%=itemAttrs %>">
						<span>
							<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
									hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
									language='<%=""+user.getLanguage() %>'
									completeUrl="/data.jsp?type=164" width="80%" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
									browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
				</wea:item>
			<%}%>
			
		</wea:group>

		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="<%=groupAttrs2 %>" >
         <wea:item attributes="{'colspan':'full','samePair':'imgfield','display':'none'}">
				<div></div>
			</wea:item>
			<wea:item attributes="{'colspan':'full','display':'none'}">
				<%
					int oldpicnum = 0;
					int pos = mouldtext.indexOf("<img alt=\"");
					while(pos!=-1){
						pos = mouldtext.indexOf("?fileid=",pos);
						int endpos = mouldtext.indexOf("\"",pos);
						String tmpid = mouldtext.substring(pos+8,endpos);
						int startpos = mouldtext.lastIndexOf("\"",pos);
						String servername = request.getServerName();
						String tmpcontent = mouldtext.substring(0,startpos+1);
						tmpcontent += "http://"+servername;
						tmpcontent += mouldtext.substring(startpos+1);
						mouldtext=tmpcontent;
					%>
					<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
					<%
						pos = mouldtext.indexOf("<img alt=\"",endpos);
						oldpicnum += 1;
					}
					%>
					<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">
				<textarea name="mouldtext" style="display:none;width:100%;height:500px"><%=Util.encodeAnd(mouldtext)%></textarea>
			</wea:item>
			<wea:item attributes="<%=itemAttrs2 %>">
				<iframe id="e8shadowifrm" name="e8shadowifrm" frameborder="none" scrolling="no" style="overflow:hidden;z-index:1;width:100%;height:23px;position:absolute;top:37px;visibility:hidden;left:0px;background-color:#fff;" src="javascript:return false;"></iframe>
				<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;position:relative;">
					<object  id="WebOffice" style="POSITION: relative;top:-23px" width="100%"  height="680"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
					</object>
				</div>
			</wea:item>
			<wea:item attributes="<%=itemAttrs2 %>">
				<span id=StatusBar>&nbsp;</span>
			</wea:item>
		</wea:group>
	</wea:layout>
<input type=hidden name=operation>
<input type=hidden name=id  id="id" value="<%=id%>">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input TYPE="hidden" id="docType" name="docType" value="">
</form>

<%if("2".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<%if("add".equals(operation)){ %>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onSave();">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="window.top.Dialog.close();">
					<%}else{ %>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="window.top.Dialog.close();">
					<%} %>				
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
<script type="text/javascript">
try{
	parent.setTabObjName("<%= mouldname %>");
}catch(e){}
function onSave(){
	if(check_form(document.weaver,'mouldname,subcompanyid1,subcompanyid')){
<%if(operation.equals("add")){%>
	document.weaver.operation.value="add";
<%}else{%>
	document.weaver.operation.value='edit';
<%}%>
	if(SaveDocument()){
    	if(SaveBookmarks()){
   	        document.weaver.submit();
			<%if(operation.equals("add")){%>
        parentWin=parent.getParentWindow(window);
		parentWin._table.reLoad();
	    parentWin.closeDialog();
      <%}%>
   		}
    }
	}
}

</script>
<script language="VBScript">
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=DocMouldEdit:Edit&selectedids="&weaver.subcompanyid1.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = weaver.subcompanyid1.value then
		issame = true
	end if
	subcompanyid1span.innerHtml = id(1)
	weaver.subcompanyid1.value=id(0)
	else
	subcompanyid1span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.subcompanyid1.value=""
	end if
	end if
end sub
</script>
</body>
