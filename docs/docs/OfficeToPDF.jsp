<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


 <%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%

 user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int languageId=user.getLanguage();

int docId=Util.getIntValue(Util.null2String(request.getParameter("docId")),0);
int imageFileId=Util.getIntValue(Util.null2String(request.getParameter("imageFileId")),0);
int versionId=Util.getIntValue(Util.null2String(request.getParameter("versionId")),0);


String imageFileName="";
RecordSet.executeSql("select imageFileName from ImageFile where imageFileId="+imageFileId);
if(RecordSet.next()){
	imageFileName=RecordSet.getString("imageFileName");
}
String filetype=".doc";
if(imageFileName.lastIndexOf(".")>=0){
	filetype=imageFileName.substring(imageFileName.lastIndexOf("."));
}
imageFileName=Util.stringReplace4DocDspExt(imageFileName);



String mServerUrl="/docs/docs/"+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

%>
<html>
<body onload="Load()" onunload="UnLoad()">

<FORM id=weaver name=weaver action="" method=post>

<table>
	<tr height='100%'>
		<td bgcolor=menu id="doccontenttd">
		</td>
	</tr>
</table>

</FORM>

</body>
</html>
<script language="javascript">

function Load(){

		document.getElementById("doccontenttd").innerHTML="<div style=\"POSITION: relative;width:100%;height:100%;OVERFLOW:hidden;\"><OBJECT id=\"WebOffice\" classid=\"<%=mClassId%>\" style=\"POSITION: relative;width:100.5%;height:98%;top:-20;\" codebase=\"<%=mClientUrl%>\"></OBJECT><div style=\"POSITION:relative;top:-12;\" align=\"center\"></div></div>";
		var tempFileName="<%=imageFileName%>";
		
		document.getElementById("WebOffice").WebUrl="<%=mServerUrl%>";
		try{
			document.getElementById("WebOffice").RecordID="<%=versionId%>_<%=docId%>";
			document.getElementById("WebOffice").FileType="<%=filetype%>";
			if(document.getElementById("WebOffice").WebOpen()){
				try{
					document.getElementById("WebOffice").WebObject.AcceptAllRevisions();
				}catch(e){
				}
				document.getElementById("WebOffice").FileName=tempFileName;
				document.getElementById("WebOffice").FileType="<%=filetype%>";
				document.getElementById("WebOffice").WebSetMsgByName("operType","onSavePDFOfAttach");
				document.getElementById("WebOffice").WebSetMsgByName("imageFileId","<%=imageFileId%>");
				if(document.getElementById("WebOffice").WebSavePDF()){
					var retmsg=document.getElementById("WebOffice").WebGetMsgByName("retmsg")
					if(-1!=retmsg.indexOf("<%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>")){
						window.parent.onSavePDFOfAttachReturn();
					}
				}
			} else {
				window.parent.onSavePDFOfAttachReturn();
			}
		}catch(e){
			window.parent.onSavePDFOfAttachReturn();
		}
}

function UnLoad(){
	try{
    if (!document.getElementById("WebOffice").WebClose()){
    	StatusMsg(document.getElementById("WebOffice").Status);
    }else{
    	StatusMsg("<%=SystemEnv.getHtmlLabelName(19716,languageId)%>...");
    }
  }catch(e){}
}


</script>