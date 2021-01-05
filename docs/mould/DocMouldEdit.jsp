<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.DesUtil"%>	

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
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
String groupAttrs="";
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
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0);
	MouldManager.setId(id);
	MouldManager.getMouldInfoById();
	String mouldname=Util.null2String(MouldManager.getMouldName());
	if(operation.equals("add")){
	mouldname="";
	}
	String mouldtext=MouldManager.getMouldText();
	int subcompanyid = MouldManager.getSubcompanyid();
	int operatelevel=0;
	int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
	if(detachable==1){
		operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldEdit:Edit",subcompanyid);
	}else{
	    if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user))
	        operatelevel=2;
	}
	MouldManager.closeStatement();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(16450,user.getLanguage())+"："+mouldname;
String needfav ="1";
String needhelp ="";
%>
<body>
<%if("2".equals(isDialog)){ %>
<div class="zDialog_div_content" style="overflow:hidden;">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!operation.equals("add")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isDialog.equals("2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:openHelp(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
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
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data" onsubmit="return false;">


	<wea:layout attributes="{'groupOperDisplay':'none','layoutTableId':'baseInfo'}">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>" attributes="<%=groupAttrs %>" >

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
			<%if(detachable==1){ %>
				<wea:item attributes="<%=itemAttrs %>" ><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
				<wea:item attributes="<%=itemAttrs %>">
						<span>
							<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
									hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
									completeUrl="/data.jsp?type=164"  temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
									language='<%=""+user.getLanguage() %>'
									browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
				</wea:item>
			<%}%>
			<wea:item attributes="{'colspan':'full','samePair':'imgfield','display':'none'}">
				<div></div>
			</wea:item>
		</wea:group>
	</wea:layout>
	<div id="texteditoritem" style="width:100%;margin-left:176px;<%=hiddiv%>">
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
		<div id='tdfieldlist' style="top:124px;position:absolute;float:left;width:176px;height:498px;">
			<div style="width:100%;text-align:left;display:none;">
					<%=SystemEnv.getHtmlLabelName(32871,user.getLanguage())%>
			</div>
			<div id="outcontainer"  class="labellist" style="overflow:hidden;">
			<div id="innercontainer">
				<ul id="labellist-1" name="labellist-1" style="border:none;width:100%;">
					<li _value="$DOC_SecCategory" title="$<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></li>
					<li _value="$DOC_Department" title="$<%=SystemEnv.getHtmlLabelName(16227,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16227,user.getLanguage())%></li>
					<li _value="$DOC_Content" title="$<%=SystemEnv.getHtmlLabelName(16228,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16228,user.getLanguage())%></li>
					<li _value="$DOC_CreatedByLink" title="$<%=SystemEnv.getHtmlLabelName(16230,user.getLanguage())%>. (full name with link).">$<%=SystemEnv.getHtmlLabelName(16230,user.getLanguage())%>. (full name with link).</li>
					<li _value="$DOC_CreatedByFull" title="$<%=SystemEnv.getHtmlLabelName(16229,user.getLanguage())%>. (full name)">$<%=SystemEnv.getHtmlLabelName(16229,user.getLanguage())%>. (full name)</li>
					<li _value="$DOC_CreatedDate" title="$<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></li>
					<li _value="$DOC_DocId" title="$<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>ID">$<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>ID</li>
					<li _value="$DOC_ModifiedDate" title="$<%=SystemEnv.getHtmlLabelName(16232,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16232,user.getLanguage())%></li>
					<li _value="$DOC_Language" title="$<%=SystemEnv.getHtmlLabelName(16233,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16233,user.getLanguage())%></li>
					<li _value="$DOC_ParentId" title="$<%=SystemEnv.getHtmlLabelName(16234,user.getLanguage())%>ID">$<%=SystemEnv.getHtmlLabelName(16234,user.getLanguage())%>ID</li>
					<li _value="$DOC_Status" title="$<%=SystemEnv.getHtmlLabelName(16235,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16235,user.getLanguage())%></li>
					<li _value="$DOC_Subject" title="$<%=SystemEnv.getHtmlLabelName(16236,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16236,user.getLanguage())%></li>
					<li _value="$DOC_Publish" title="$<%=SystemEnv.getHtmlLabelName(16237,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16237,user.getLanguage())%></li>
					<li _value="$DOC_ApproveDate"  title="$<%=SystemEnv.getHtmlLabelName(1425,user.getLanguage()) %>" >$<%=SystemEnv.getHtmlLabelName(1425,user.getLanguage())%></li>
				</ul>
		</div>
			</div>
		</div>
<input type=hidden name=operation id="operation" value="<%=operation%>">
<input type=hidden name=id value="<%=id%>" id="id">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
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
	jQuery("#edui1").width(winW-jQuery("#tdfieldlist").width());
	jQuery("#edui1_iframeholder").width(winW-jQuery("#tdfieldlist").width());
	jQuery("#edui1_iframeholder").height(jQuery("#tdfieldlist").height()-jQuery("#edui1_toolbarbox").height());
}

function switchEditMode(ename){
	
	//var oEditor = CKEDITOR.instances.mouldtext;
	//oEditor.execCommand("source");
	 ue.execCommand("source");
}

jQuery(document).ready(function(){
	jQuery("#labellist-1").find("li").bind("click",function(){
		 cool_webcontrollabel(this);
	}).bind("selectstart",function(){return false;});
});

//往左边Fck编辑框里加一个字段显示名
function cool_webcontrollabel(obj){
	//var fckHtml = FCKEditorExt.getHtml("newstemptext");
//	var fckHtml = CKEDITOR.instances.mouldtext.getData();
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
	//alert(obj);
	 ue.execCommand('inserthtml', labelhtml); 
}
function onSave(){
	if(check_form(document.weaver,'mouldname,subcompanyid')){
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


function openHelp(){
    window.open('tag_help.jsp',null,'height=600,width=500,scrollbar=true')
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
