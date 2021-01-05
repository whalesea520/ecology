<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocMailMouldEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String operation = Util.null2String(request.getParameter("operation"));
%>
<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<script language="javascript" type="text/javascript">
jQuery(document).ready(function(){

	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;


	//FCKEditorExt.initEditor('weaver','mouldtext',lang);
	CkeditorExt.initEditor('weaver','mouldtext',lang,'',500)
});
var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);
if("<%=isclose%>"=="1"){
	//parentWin.location="DocMould.jsp";
	parentWin._table.reLoad();
	parentWin.closeDialog();	
}


</script>
</head>
<jsp:useBean id="MailMouldManager" class="weaver.docs.mail.MailMouldManager" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0);
	MailMouldManager.setId(id);
	MailMouldManager.getMailMouldInfoById();
	String mouldname=MailMouldManager.getMailMouldName();
	String mouldtext=MailMouldManager.getMailMouldText();
	int subcompanyid = MailMouldManager.getSubcompanyid();
	int operatelevel=0;
	int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
	if(detachable==1){
		operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocTypeEdit:Edit",subcompanyid);
	}else{
	    if(HrmUserVarify.checkUserRight("DocTypeEdit:Edit", user))
	        operatelevel=2;
	}
	MailMouldManager.closeStatement();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(71,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+":"+mouldname;
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
if(!isDialog.equals("2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isDialog.equals("2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:window.open(\\\"/email/MailTemplateTag.jsp\\\",null,\\\"height=600,width=500,scrollbar=true\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
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
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">

<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="mouldnamespan" required="true"value='<%=mouldname%>'>
					<input  temptitle="<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>"class=InputStyle size=70 name=mouldname value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
				</wea:required>
			</wea:item>
			<%if(detachable==1){ %>
				<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
				<wea:item>
						<span>
							<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
									hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
									completeUrl="/data.jsp?type=164" width="80%" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
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
	<wea:layout needImportDefaultJsAndCss="false" attributes="{'cw1':'80%','cw2':'20%'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item>
				<%
				int oldpicnum = 0;
				int pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload");
				while(pos!=-1){
					pos = mouldtext.indexOf("?fileid=",pos);
					int endpos = mouldtext.indexOf("\"",pos);
					String tmpid = mouldtext.substring(pos+8,endpos);
					int startpos = mouldtext.lastIndexOf("\"",pos);
					//String servername = request.getServerName();
					//if(request.getServerPort()!=80)servername+=":"+request.getServerPort();
					String tmpcontent = mouldtext.substring(0,startpos+1);
					//tmpcontent += "http://"+servername;
					tmpcontent += mouldtext.substring(startpos+1);
					mouldtext=tmpcontent;
				%>
				<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
				<%
					pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",endpos);
					oldpicnum += 1;
				}
				%>
				<input type="hidden" name="olddocimagesnum" id="olddocimagesnum" value="<%=oldpicnum%>">
				<textarea name="mouldtext" id="mouldtext" style="display:none;width:100%;height:500px"><%=Util.encodeAnd(mouldtext)%></textarea>
			</wea:item>
			<wea:item attributes="{'id':'tdfieldlist'}">
				<div style="width:100%;text-align:left;">
						<%=SystemEnv.getHtmlLabelName(32871,user.getLanguage())%>
				</div>
				<select id="labellist-1" name="labellist-1" class="labellist" size="30" ondblclick="javascript:cool_webcontrollabel(this);" style="border:none;overflow:hidden;width:100%;height:100%;" notBeauty=true>
					<option value="$HRM_Loginid" title="$<%=SystemEnv.getHtmlLabelName(412,user.getLanguage()) %>" >$<%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
					<option value="$HRM_Name" title="$<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></option>
					<option value="$HRM_Title" title="$<%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></option>
					<option value="$HRM_Telephone" title="$<%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></option>
					<option value="$HRM_Email" title="$<%=SystemEnv.getHtmlLabelName(16220,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16220,user.getLanguage())%></option>
					<option value="$HRM_Startdate" title="$<%=SystemEnv.getHtmlLabelName(16221,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16221,user.getLanguage())%></option>
					<option value="$HRM_Enddate" title="$<%=SystemEnv.getHtmlLabelName(16222,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16222,user.getLanguage())%></option>
					<option value="$HRM_Contractdate" title="$<%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></option>
					<option value="$HRM_Jobtitle" title="$<%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></option>
					<option value="$HRM_Jobgroup" title="$<%=SystemEnv.getHtmlLabelName(16223,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16223,user.getLanguage())%></option>
					<option value="$HRM_Jobactivity" title="$<%=SystemEnv.getHtmlLabelName(382,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(382,user.getLanguage())%></option>
					<option value="$HRM_Jobactivitydesc" title="$<%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></option>
					<option value="$HRM_Joblevel" title="$<%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%></option>
					<option value="$HRM_Seclevel" title="$<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
					<option value="$HRM_Department" title="$<%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></option>
					<option value="$HRM_Costcenter" title="$<%=SystemEnv.getHtmlLabelName(16224,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16224,user.getLanguage())%></option>
					<option value="$HRM_Manager" title="$<%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></option>
					<option value="$HRM_Assistant" title="$<%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></option>

				</select>
			</wea:item>
		</wea:group>
	</wea:layout>
<input type=hidden name=operation id="operation">
<input type=hidden name=id value="<%=id%>" id="id">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
</form>
<script type="text/javascript">

try{
	parent.setTabObjName("<%= mouldname %>");
}catch(e){}

function switchEditMode(ename){
	
	var oEditor = CKEDITOR.instances.mouldtext;
	oEditor.execCommand("source");
}

//往左边Fck编辑框里加一个字段显示名
function cool_webcontrollabel(obj){
	//var fckHtml = FCKEditorExt.getHtml("newstemptext");
	var fckHtml = CKEDITOR.instances.mouldtext.getData();
	//var html = obj.options.item(obj.selectedIndex).text;
	var html = jQuery(obj).val();
	if(fckHtml.indexOf(html) != -1){
		//obj.options.item(obj.selectedIndex).text = html+"               已添加";
		//alert("<%=SystemEnv.getHtmlLabelName(23723, user.getLanguage())%>");
		return;
	}
	obj.options.item(obj.selectedIndex).style.color="#bfbfbf";
	var labelhtml = html;
	FCKEditorExt.insertHtml(labelhtml, "mouldtext");
	//alert(obj);
}

function onSave(){
	if(check_form(document.weaver,'mouldname')){
		/***###@2007-08-24 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
			text = "<HTML><HEAD><META NAME='GENERATOR' Content='Weaver DHTML Editing Control'>"+
				   "<TITLE></TITLE></HEAD>"+text.substring(text.indexOf("<BODY>"), text.length) ;
		document.weaver.mouldtext.innerText=text;
		***/
		<%if(detachable==1){ %>
    		if(check_form(document.weaver,'subcompanyid')){
    	<%}%>
		var editor_data = CKEDITOR.instances.mouldtext.getData();
		jQuery("#mouldname").val(editor_data);
		
		<%if(operation.equals("add")){%>
	    	document.weaver.operation.value="add";
	    	jQuery("#id").val("");
	    <%}else{%>
			document.weaver.operation.value="edit";
		<%}%>
		document.weaver.submit();
		<%if(detachable==1){ %>
        }
        <%}%>
	}
}

/*
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
        text = "<HTML><HEAD><META NAME='GENERATOR' Content='Weaver DHTML Editing Control'>"+
               "<TITLE></TITLE></HEAD>"+text.substring(text.indexOf("<BODY>"), text.length) ;
		document.weaver.mouldtext.innerText=text;
		document.weaver.mouldtext.style.display='';
		divifrm.style.display='none';
	}
}
*/
</script>
<%if("2".equals(isDialog)){ %>
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
</body>
