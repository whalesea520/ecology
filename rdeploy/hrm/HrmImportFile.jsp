<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String result = Util.null2String(request.getParameter("result"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<style type="text/css">
.file {
    position: relative;
    display: inline-block;
    background: #5d9ffe;
    border: 1px solid #99D3F5;
    border-radius: 4px;
    padding: 4px 12px;
    overflow: hidden;
    color: #1E88C7;
    text-decoration: none;
    text-indent: 0;
    line-height: 35px;
    width: 120px;
}

.file1 {
		background-image:url(/rdeploy/hrm/img/excelicon.png);
    position: relative;
    display: inline-block;
    overflow: hidden;
    text-decoration: none;
    text-indent: 0;
    line-height: 65px;
    width: 60px;
}

.file1  input {
    line-height: 65px;
    font-size: 60px;
    height:65px;
    right: 0;
    top: 0;
    opacity: 0;
    filter:alpha(opacity=0);-moz-opacity:0;opacity: 0;
}

.file input {
    position: absolute;
    line-height: 35px;
    font-size: 120px;
    height:40px;
    right: 0;
    top: 0;
    opacity: 0;
    filter:alpha(opacity=0);-moz-opacity:0;opacity: 0;
}
.file:hover {
    background: #AADFFD;
    border-color: #78C3F3;
    color: #004974;
    text-decoration: none;
}
</style>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=result%>"=="1"){
	parentWin.doHrmImportFieldSetting();
}

function doSubmit(){
	var filepath = jQuery("#excelfile").val();
	if(filepath==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125332,user.getLanguage())%>!"); 
		return false;
	}
	frmMain.submit();
}

function jsSelectFile(){
	jQuery("#excelfile").click();
}

function jsOnChange(){
	//判断文件类型
	var filepath = jQuery("#excelfile").val();
	var extend = filepath.substring(filepath.lastIndexOf(".")+1); 
	jQuery("#filepath").html("");
	jQuery("#tdFile").css("padding-top","40px");
	if(extend!=""){
		if(extend=="xls"||extend=="xlsx"){ 
			jQuery("#filepath").html(filepath.split("\\")[filepath.split("\\").length-1]);
			jQuery("#tdFileTitle").html("");
			jQuery("#aFile").removeClass().addClass("file1");
			jQuery("#tdFile").css("padding-top","30px");
	  }else{
	  	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125332,user.getLanguage())%>!"); 
	  }
	}else{
  	jQuery("#aFile").removeClass().addClass("file");
  	jQuery("#tdFileTitle").html("<%=SystemEnv.getHtmlLabelName(125333,user.getLanguage())%>");
	}
}
</script>
</head>
<body style="text-align: center;">
<FORM id=weaver name=frmMain action="HrmImportOperation.jsp" method=post enctype="multipart/form-data">
<input type=hidden id="operation" name=cmd value="savefile">
<table style="width: 100%;text-align: center;padding-top: 60px">
	<tbody>
		<tr>
			<td><font style="font-size: 14px;color: #546186"><%=SystemEnv.getHtmlLabelName(125335,user.getLanguage())%>：</font></td>
		</tr>
		<tr>
			<td><font style="color: #94b2b9"><%=SystemEnv.getHtmlLabelName(125334,user.getLanguage())%></font></td>
		</tr>
		<tr>
			<td id="tdFile" style="padding-top: 40px">
				<a id="aFile" href="javascript:" class="file">
				<font id="tdFileTitle" style="color: white;"><%=SystemEnv.getHtmlLabelName(125333,user.getLanguage())%></font>
					<input type="file" name="excelfile" id="excelfile" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" onchange="jsOnChange(this);">					
				</a>
			</td>
		</tr>
		<tr>
			<td id="filepath" style="color: #546186;height: 30px"></td>
		</tr>
	</tbody>
</table>
</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSubmit()">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
</body>
</<HTML>