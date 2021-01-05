<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.request.WFDocPrintUtil" %>
<%
if("false".equals(isIE)){	
	request.setAttribute("labelid","125483");
	request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);		
	return;
}
String requestid = Util.null2String(request.getParameter("requestid"));
int nodeid=Util.getIntValue(request.getParameter("nodeid"),0);
String docType=".doc";
String docMouldExistedId=WFDocPrintUtil.getWFTemplateByRequestid(nodeid)+"";//通过nodeid获取模板ID
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);
String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;
%>
<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript">
function onPrintDoc(){
  try{
    weaver.WebOffice.WebOpenPrint();
  }catch(e){}
}
function Load(){
  try{
	  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
	  weaver.WebOffice.RecordID="<%=docMouldExistedId%>";
	  weaver.WebOffice.Template="";
	  weaver.WebOffice.FileName="";
	  weaver.WebOffice.FileType="<%=docType%>";
	<%if(isIWebOffice2006 == true){%>
	  weaver.WebOffice.EditType="1,1";
	  weaver.WebOffice.ShowToolBar="0";     
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
	  weaver.WebOffice.WebSetMsgByName("REQUESTID","<%=requestid%>");
	  weaver.WebOffice.WebSetMsgByName("NODEID","<%=nodeid%>");
	  weaver.WebOffice.WebOpen();
	  //weaver.WebOffice.WebLoadBookMarks();//替换书签  	
	<%if(isIWebOffice2006 == true){%>
	  weaver.WebOffice.ShowType="1"; 
	<%}%>
	var pageHeight=document.body.clientHeight;
	jQuery("#WebOffice").height(pageHeight-5);
  }catch(e){}
}
function UnLoad(){
  try{
	  if (!weaver.WebOffice.WebClose()){
	
	  }else{
	
	  }
  }catch(e){}
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="";
String needhelp ="";
%>
<body onLoad="Load()" onUnload="UnLoad()">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onPrintDoc();" value="<%=SystemEnv.getHtmlLabelName(257, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">	
	<div style="POSITION: relative;width:100%;height:100%;OVERFLOW:hidden;position:relative;">
		<object  id="WebOffice" style="POSITION: relative;top:-23px" width="100%"  height="100%"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
		</object>
	</div>
</form>
</body>