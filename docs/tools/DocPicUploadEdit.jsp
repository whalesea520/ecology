<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int id=Util.getIntValue(request.getParameter("id"),0);
String errorcode = Util.null2String(request.getParameter("errorcode"));
boolean canedit=HrmUserVarify.checkUserRight("DocPicUploadEdit:Edit", user);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(74,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isClose = Util.null2String(request.getParameter("isclose"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(!isDialog.equals("1")){
if(HrmUserVarify.checkUserRight("DocPicUploadEdit:Delete", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/tools/DocPicUpload.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
<%if(canedit){%>
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmmain action="UploadImage.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="operation">
<input type="hidden" name="id" value=<%=id%>>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<script type="text/javascript">

var dialog = null;
var parentWin = null;
try{
 dialog = parent.parent.getDialog(parent);
 parentWin = parent.parent.getParentWindow(parent);
 <%if("1".equals(isClose)){%>
 	parentWin._table.reLoad();
 	dialog.close();
 <%}%>
}catch(e){}

function btn_cancle(){
	parent.closeDialog();
}

function onSave(){
	if(check_form(document.frmmain,'picname')){
	document.frmmain.operation.value="edit";
	document.frmmain.submit();
	}
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		document.frmmain.operation.value="delete";
		document.frmmain.submit();
	}
}
</script>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    	<%
    	PicUploadManager.resetParameter();
    	PicUploadManager.setId(id);
  	PicUploadManager.selectImageById();
  	if(PicUploadManager.next()){
    	%>
    	<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
    	<wea:item>
    	<script type="text/javascript">
    		try{
				parent.setTabObjName("<%=Util.toScreenToEdit(PicUploadManager.getPicname(),user.getLanguage())%>");
			}catch(e){}
    	</script>
    	<% if(canedit){%>
    	<input type="text" name="picname" value=<%=Util.toScreenToEdit(PicUploadManager.getPicname(),user.getLanguage())%> maxLength=30
    	onchange="checkinput('picname','InvalidFlag_Description')" size=30><SPAN id=InvalidFlag_Description>
    	</span>
    	<% }else{%>
    	<%=Util.toScreen(PicUploadManager.getPicname(),user.getLanguage())%>
    	<%}%>
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
    	<wea:item>
    	<%if(canedit){%>
    	<select class=InputStyle  size=1 name="pictype">
	<option value="1" <%if(PicUploadManager.getPictype().equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2009,user.getLanguage())%></option>
	<option value="3" <%if(PicUploadManager.getPictype().equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2010,user.getLanguage())%></option>
	</select>
	<% }else{%>
		<%if(PicUploadManager.getPictype().equals("1")){%>
  		<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>
  		<%}if(PicUploadManager.getPictype().equals("2")){%>
  		<%=SystemEnv.getHtmlLabelName(285,user.getLanguage())%>
  		<%}if(PicUploadManager.getPictype().equals("3")){%>
  		<%=SystemEnv.getHtmlLabelName(287,user.getLanguage())%>
  		<%}if(PicUploadManager.getPictype().equals("4")){%>
  		<%=SystemEnv.getHtmlLabelName(289,user.getLanguage())%>
  		<%}}%>
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></wea:item>
    	<wea:item>
    	<img border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=PicUploadManager.getImagefileid()%>">
    	<input type="hidden" name="imagefileid" value=<%=PicUploadManager.getImagefileid()%>>
    	<input type="hidden" name="imagefilename" value=<%=PicUploadManager.getImagefilename()%>>
    	<input type="hidden" name="imagefilewidth" value=<%=PicUploadManager.getImagefilewidth()%>>
    	<input type="hidden" name="imagefileheight" value=<%=PicUploadManager.getImagefileheight()%>>
    	<input type="hidden" name="imagefilesize" value=<%=PicUploadManager.getImagefilesize()%>>
    	<input type="hidden" name="imagefilescale" value=<%=PicUploadManager.getImagefilescale()%>>
    	</wea:item>
    	<%if (canedit){%>
    	<wea:item><%=SystemEnv.getHtmlLabelName(293,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></wea:item>
    	<wea:item><input type="file" name="imagefile"></wea:item>
    	<%}}
    	PicUploadManager.closeStatement();
    	%>
	</wea:group>
</wea:layout>

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
 </body></html>
