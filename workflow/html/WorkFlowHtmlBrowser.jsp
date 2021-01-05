
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.workflow.html.HtmlLayoutManager" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/activex/target/ocxVersion.jsp" %>
<object ID="File" <%=strWeaverOcxInfo%> STYLE="height=0px;width=0px"></object>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<script language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body id="flowbody">
<%
int annexmaxUploadImageSize = 5;
FileUpload fu = new FileUpload(request, false);
String opttype = Util.null2String(fu.getParameter("opttype"));

if("save".equals(opttype)){
	//String imageId = fu.uploadFiles("cssfile");
	//File thefile = mpdata.getFile(uploadname) ;
	HtmlLayoutManager htmlLayoutManager = new HtmlLayoutManager();
	String layout = htmlLayoutManager.upHtmlFile(fu);
	session.setAttribute("layout_t", layout);
%>
<script language="javascript">
	window.parent.parent.returnValue = Array("1","1");
	window.parent.parent.close();
</script>
<%
	return;

}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:dosubmit(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="WorkFlowHtmlBrowser.jsp" enctype="multipart/form-data">
<input type="hidden" id="opttype" name="opttype" value="save">
<table width="100%" height="95%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

		<table class="ViewForm" cellspacing="1" width="100%">
		<tbody>
		<COL width="15%" >
		<COL width="85%" >
			<tr class="Title">
				<td colspan="2" align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT:bold">Html<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%></font></td>
			</tr>
			<TR class="spacing"><TD class="line1" colSpan="2"></TD></TR>
			<tr>
				<td>Html<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%></td>
				<td class="field">
					<input class="InputStyle" type="file" id="htmlfile" name="htmlfile" temptitle="Html<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>" onchange="accesoryChanage(this);checkinput('htmlfile','htmlfilespan')">(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=annexmaxUploadImageSize%>M)<span id="htmlfilespan"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></span>
				</td>
			</tr>
			<tr><td class="Line2" colSpan="2"></td></tr>
		</table>

		</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</form>
</body>
</html>
<script>
function dosubmit(obj){
	if(check_form(frmmain, "htmlfile")){
		frmmain.submit();
	}
}
function createAndRemoveObj(obj){
	objName = obj.name;
	var newObj = document.createElement("input");
	newObj.name=objName;
	newObj.className="InputStyle";
	newObj.type="file";
	newObj.onchange=function(){accesoryChanage(this);};

	var objParentNode = obj.parentNode;
	var objNextNode = obj.nextSibling;
	obj.removeNode();
	objParentNode.insertBefore(newObj,objNextNode);
}
function accesoryChanage(obj){
	var objValue = obj.value;
	if (objValue=="") return ;
	var fileLenth;
	try {
		File.FilePath=objValue;
		fileLenth = File.getFileSize();
	} catch (e){
		if(e.message=="Type mismatch"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
		createAndRemoveObj(obj);
		return  ;
	}
	if (fileLenth == -1) {
		createAndRemoveObj(obj);
		return ;
	}
	//var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
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
		maxsize = <%=annexmaxUploadImageSize%>;
	if (fileLenthByM > maxsize) {
		alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxsize+"M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>!");
		createAndRemoveObj(obj);
	}
}

</script>
