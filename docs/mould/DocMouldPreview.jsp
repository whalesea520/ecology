
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.bookmark.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<%
//编辑：王金永 
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

int id = Util.getIntValue(request.getParameter("id"),0);

MouldManager.setId(id);
MouldManager.getMouldInfoById();
String mouldname=MouldManager.getMouldName();
String mouldtext=MouldManager.getMouldText();
int mouldType = MouldManager.getMouldType();
String docType=".doc";
if(mouldType==2){
    docType=".doc";
}else if(mouldType==3){
    docType=".xls";
}else{
    docType=".doc";
}

MouldManager.closeStatement();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(58,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+":"+mouldname;
String needfav ="1";
String needhelp ="";
%>

<script>
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
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="";
  weaver.WebOffice.Template="<%=id%>";
  weaver.WebOffice.FileName="FnaAccountLog.doc";
  weaver.WebOffice.FileType="<%=docType%>";
  weaver.WebOffice.EditType="1";
  weaver.WebOffice.UserName="<%=user.getUsername()%>";
  weaver.WebOffice.WebSetMsgByName("COMMAND","LOADVIEWMOULD");
  weaver.WebOffice.WebLoadTemplate();
  //alert(weaver.WebOffice.Status);
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


<BODY onload="Load()" onunload="UnLoad()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaver name=weaver action="DocMouldPreview.jsp" method=post>
<br>
<TABLE class=ViewForm>
<TBODY>
<TR class=Spacing><TD aligh=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
</b>
</TD></TR>
<TR class=Spacing><TD class=Line1 colspan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<TR>
	<TD class=Line colSpan=2></TD>
</TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
<td width=85% class=field>
<%=mouldname%>
</td>
</tr>

<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td width=15%>Doc version id</td>
<td width=85% class=field>
<input type="text" name="docid" value="">
</td>
</tr>

<%
MouldBookMarkManager dmbmm = new MouldBookMarkManager();
List bookmarks = dmbmm.getMouldBookMarkByMouldId(id);
for(Iterator it = bookmarks.iterator();it.hasNext();){
	MouldBookMark bm = (MouldBookMark) it.next();
%>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(26364,user.getLanguage())%>:<%=bm.getName()%></td>
<td width=85% class=field>
<input type="hidden" name="bookmark" value="<%=bm.getName()%>">
<input type="text" name="<%=bm.getName()%>" value="<%=bm.getDescript()%>">
</td>
</tr>
<% } %>
<TR><TD class=Line colSpan=2></TD></TR>

<tr><td colspan=2>
<script>
function onReplace(){
  var bmarray = document.weaver.bookmark;
  if(bmarray.value!=null&&bmarray.length==null){
  	var bmname = bmarray.value;
    var bmvalue = eval("document.weaver."+bmname).value;
	weaver.WebOffice.WebSetBookMarks(bmname,bmvalue);
  } else {
	  for(var i=0;bmarray!=null&&i<bmarray.length;i++){
	    var bmname = bmarray[i].value;
	    var bmvalue = eval("document.weaver."+bmname).value;
		weaver.WebOffice.WebSetBookMarks(bmname,bmvalue);
	  }
  }
  //weaver.WebOffice.WebOpenBookMarks();
}

function insertFile(){
	weaver.WebOffice.RecordID=weaver.docid.value;
    weaver.WebOffice.WebInsertFile();
}


</script>
	<input type="button" value="<%=SystemEnv.getHtmlLabelName(83434,user.getLanguage())%>" onclick="onReplace()">
	<input type="button" value="<%=SystemEnv.getHtmlLabelName(83435,user.getLanguage())%>" onclick="insertFile()">
</td></tr>

<TR><TD class=Line colSpan=2></TD></TR>

</tbody>
</table>
<TABLE class=ViewForm>
<TBODY>
<TR class=Spacing>
<TD class=Line1></TD></TR>


<tr><td colspan = 2>
<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
    <OBJECT  id="WebOffice" style="POSITION: relative;top:-20" width="100%"  height="680"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
    </OBJECT>
</div>
</td></tr>
<tr><td colspan = 2>
    <span id=StatusBar>&nbsp;</span>
</td></tr>

</TBODY>
</TABLE>

<input type="hidden" name="id" value="<%=id%>">
</FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>

