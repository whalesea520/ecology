<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.DesUtil"%>	

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
//附件上传所需
DesUtil desUtilitem = new DesUtil();
String udesid=desUtilitem.encrypt(user.getUID()+"");
String utype=user.getLogintype();

if(!HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String operation = Util.null2String(request.getParameter("operation"));
String groupAttrs="{'groupDisplay':''}";
String itemAttrs="{'display':''}";
String hiddiv="";
if(operation.equals("add")){
 groupAttrs="{'groupDisplay':'none'}"; 
 itemAttrs="{'display':'none'}"; 
 hiddiv="display:none";
}

%>
<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<script>
   window.top.udesid='<%=udesid%>';
   window.top.utype='<%=utype%>';
   window.top.imguploadurl="/docs/docs/DocImgUploadOnly.jsp?userid="+window.top.udesid+"&usertype="+window.top.utype;
</script>  

<!--
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
 -->
 <!--swfupload相关-->
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
 <!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>
<!--图片上传插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorextend_wev8.css" rel="stylesheet"></link>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);
<%if(operation.equals("add")){%>
        parentWin=parent.getParentWindow(window);		
 <%}%>
var ue;
jQuery(document).ready(function(){

	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;


	//FCKEditorExt.initEditor('weaver','mouldtext',lang);
	//CkeditorExt.initEditor('weaver','mouldtext',lang,'',500)
	ue = UE.getEditor('mouldtext',{
	  toolbars:window.UEDITOR_CONFIG.docmoduletoolbars,
	  initialFrameHeight:418,
	  initialFrameWidth:650
	});

});
if("<%=isclose%>"=="1"){
	//parentWin.location="DocMould.jsp";
	parentWin._table.reLoad();
	parentWin.closeDialog();	
}
</script>
</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0);
//int detachable=Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
int detachable = 0;
ManageDetachComInfo comInfo =  new ManageDetachComInfo();
boolean isUseHrmManageDetach=comInfo.isUseDocManageDetach();
if(isUseHrmManageDetach){
	detachable=1;
}
int subcompanyid1= -1;
    if(detachable==1){
    	subcompanyid1=Util.getIntValue(request.getParameter("subcompanyid1"),-1);
        if(subcompanyid1 == -1){
            subcompanyid1 = user.getUserSubCompany1();
        }
    }
String urlfrom = Util.null2String(request.getParameter("urlfrom"));
MouldManager.setId(id);
MouldManager.getMouldInfoById();

String mouldname=MouldManager.getMouldName();
if(operation.equals("add")){
	mouldname="";
	}
String mouldtext=MouldManager.getMouldText();
int mouldType= MouldManager.getMouldType();
subcompanyid1 = MouldManager.getSubcompanyid2();
int operatelevel=0;
	if(detachable==1){
		operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldEdit:Edit",subcompanyid1);
	}else{
	    if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user))
	        operatelevel=2;
	}
MouldManager.closeStatement();

if(mouldType >1 ){
    response.sendRedirect("DocMouldEditExt.jsp?id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+"");//Modify by 杨国生 2004-10-25 For TD1271
}

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
<body>
<%if("2".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!operation.equals("add")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isDialog.equals("2")){

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data" onsubmit="return false;">
<input type=hidden name=urlfrom value="<%=urlfrom%>">

	<wea:layout attributes="{'groupOperDisplay':'none','layoutTableId':'baseInfo'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="<%=groupAttrs %>" >
	<%if(operation.equals("add")){%>
		<wea:item></wea:item>
			<wea:item>
				
			</wea:item>
			<%}%>
			<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="mouldnamespan" required="true"value='<%=mouldname%>'>
					<input  temptitle="<%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%>"class=InputStyle size=70 name=mouldname value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
				</wea:required>
			</wea:item>
			
				<%if(detachable==1){%>
					<wea:item attributes="<%=itemAttrs %>"><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
					<wea:item attributes="<%=itemAttrs %>">
						<span>
							<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid1 %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
									hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput="2"
									completeUrl="/data.jsp?type=164" width="80%"
									browserSpanValue='<%=subcompanyid1!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid1+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
		
			<wea:item attributes="{'colspan':'full','samePair':'imgfield','display':'none'}">
				<div></div>
			</wea:item>
		</wea:group>
	</wea:layout>
	<div id="texteditoritem" style="width:100%;<%=hiddiv%>">
			<%
				int oldpicnum = 0;
				int pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload");    

				while(pos!=-1){    
					 try {
					   
							pos = mouldtext.indexOf("?fileid=",pos);
							if(pos == -1) {
								pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",pos+1);
								continue ;
							}
							int endpos = mouldtext.indexOf("\"",pos);
							String tmpid = mouldtext.substring(pos+8,endpos);

						%>
						<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
						<%
							pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",endpos);
							oldpicnum += 1;    
					}catch(Exception ex){        
						new weaver.general.BaseBean().writeLog(ex);     
						pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",pos+1);
						continue ;
					}
				}

				%>
				<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">
			<textarea name="mouldtext" id="mouldtext" style="width:100%;height:500px"><%=Util.encodeAnd(mouldtext)%></textarea>
		</div>
		<%if(!urlfrom.equals("hr")){%>
		<div id='tdfieldlist' style="top:124px;position:absolute;float:left;width:176px;height:498px;display:none;<%=hiddiv%>">
			<div style="width:100%;text-align:left;display:none;">
					<%=SystemEnv.getHtmlLabelName(32871,user.getLanguage())%>
			</div>
			<div id="outcontainer"  class="labellist">
			<div id="innercontainer">
			<ul id="labellist-1" name="labellist-1" class="labellist" size="30"  style="border:none;overflow:hidden;width:100%;height:100%;">
				<li _value="$DOC_MainCategory" title="$<%=SystemEnv.getHtmlLabelName(65,user.getLanguage()) %>" >$<%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></li>
				<li _value="$DOC_SubCategory" title="$<%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></li>
				<li _value="$DOC_SecCategory" title="$<%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></li>
				<li _value="$DOC_Department" title="$<%=SystemEnv.getHtmlLabelName(16227,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16227,user.getLanguage())%></li>
				<li _value="$DOC_Content" title="$<%=SystemEnv.getHtmlLabelName(16228,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16228,user.getLanguage())%></li>
				<li _value="$DOC_CreatedByLink" title="$<%=SystemEnv.getHtmlLabelName(16230,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16230,user.getLanguage())%></li>
				<li _value="$DOC_CreatedByFull" title="$<%=SystemEnv.getHtmlLabelName(16229,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16229,user.getLanguage())%></li>
				<li _value="$DOC_CreatedDate" title="$<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></li>
				<li _value="$DOC_DocId" title="$<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></li>
				<li _value="$DOC_ModifiedDate" title="$<%=SystemEnv.getHtmlLabelName(16232,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16232,user.getLanguage())%></li>
				<li _value="$DOC_Language" title="$<%=SystemEnv.getHtmlLabelName(16233,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16233,user.getLanguage())%></li>
				<li _value="$DOC_ParentId" title="$<%=SystemEnv.getHtmlLabelName(16234,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16234,user.getLanguage())%></li>
				<li _value="$DOC_Status" title="$<%=SystemEnv.getHtmlLabelName(16235,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16235,user.getLanguage())%></li>
				<li _value="$DOC_Subject" title="$<%=SystemEnv.getHtmlLabelName(16236,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16236,user.getLanguage())%></li>
				<li _value="$DOC_Publish" title="$<%=SystemEnv.getHtmlLabelName(16237,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16237,user.getLanguage())%></li>

			</ul>
		</div>
			</div>
		</div>
		<%}%>
<input type=hidden name=operation id="operation">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input type=hidden name=id id="id" value="<%=id%>">
</form>
<script type="text/javascript">

try{
	parent.setTabObjName("<%= mouldname %>");
}catch(e){}
jQuery(document).ready(function(){
	window.setTimeout(function(){
		setEditorHeight(true);
	},10);
});

jQuery(window).resize(function(){
	window.setTimeout(function(){
		setEditorHeight();
	},10);
});

function setEditorHeight(isinit){
	var winH = jQuery(".zDialog_div_content").height();
	var winW = jQuery(".zDialog_div_content").width();
	jQuery("#tdfieldlist").height(winH-jQuery("#baseInfo").height());
	jQuery("#tdfieldlist").css("top",jQuery("#baseInfo").height()+"px");
	jQuery("#outcontainer").height(winH-jQuery("#baseInfo").height());
	jQuery("#innercontainer").height(jQuery("#labellist-1").height());
	if(isinit){
		jQuery("#outcontainer").perfectScrollbar();
	}else{
		jQuery("#outcontainer").perfectScrollbar("update");
	}
	jQuery("#edui1").width(winW);
	jQuery("#edui1_iframeholder").width(winW);
	jQuery("#edui1_iframeholder").height(jQuery("#tdfieldlist").height()-jQuery("#edui1_toolbarbox").height());
}

jQuery(document).ready(function(){
	jQuery("#labellist-1").find("li").bind("click",function(){
		 cool_webcontrollabel(this);
	}).bind("selectstart",function(){return false;});
});

//往左边Fck编辑框里加一个字段显示名
function cool_webcontrollabel(obj){
	//var fckHtml = FCKEditorExt.getHtml("newstemptext");
	//var fckHtml = CKEDITOR.instances.mouldtext.getData();
    var fckHtml = ue.getContent();
	//var html = obj.options.item(obj.selectedIndex).text;
	var html = jQuery(obj).attr("_value");
	if(fckHtml.indexOf(html) != -1){
		//obj.options.item(obj.selectedIndex).text = html+"               已添加";
		//alert("<%=SystemEnv.getHtmlLabelName(23723, user.getLanguage())%>");
		return;
	}
	//obj.options.item(obj.selectedIndex).style.color="#bfbfbf";
	var labelhtml = html;
	//FCKEditorExt.insertHtml(labelhtml, "mouldtext");
	ue.execCommand('inserthtml', labelhtml); 
	//alert(obj);
}

function switchEditMode(ename){
	
	//var oEditor = CKEDITOR.instances.mouldtext;
	//oEditor.execCommand("source");
	 ue.execCommand("source");
}
function onSave(){
	if(check_form(document.weaver,'mouldname,subcompanyid1,subcompanyid')){
		//var editor_data = CKEDITOR.instances.mouldtext.getData();
		var editor_data = ue.getContent();
		jQuery("#mouldname").val(editor_data);
		
		
		 <%if(operation.equals("add")){%>
	    	document.weaver.operation.value="add";
	    	jQuery("#id").val("");
	    <%}else{%>
			document.weaver.operation.value="edit";
		<%}%>
		document.weaver.submit();
	}
}

function onHtml(){
	if(document.weaver.mouldtext.style.display==''){
	
		text = document.weaver.mouldtext.innerText;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.mouldtext.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.mouldtext.innerText=text;
		document.weaver.mouldtext.style.display='';
		divifrm.style.display='none';
	}
}
function onShowSubcompany(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=DocMouldEdit:Edit&selectedids="+weaver.subcompanyid1.value,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	issame = false
	if (data){
		if (data.id!=""){
			if (data.id == weaver.subcompanyid1.value){
				issame = true
			}
			subcompanyid1span.innerHtml = data.name
			weaver.subcompanyid1.value=data.id
		}else{
			subcompanyid1span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			weaver.subcompanyid1.value=""
		}
	}
}
</script>
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
</body>

