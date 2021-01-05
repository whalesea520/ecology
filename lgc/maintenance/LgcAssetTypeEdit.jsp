<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("LgcAssetType_SelectByID",id);
RecordSet.next();
String typemark = RecordSet.getString("typemark");
String typename = RecordSet.getString("typename");
String typedesc = RecordSet.getString("typedesc");
boolean canedit = HrmUserVarify.checkUserRight("LgcAssetTypeEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(713,user.getLanguage())+" : "+ Util.toScreen(typename,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
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
  <FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="LgcAssetTypeOperation.jsp">
    <input type="hidden" name="operation">
    <input type="hidden" name="id" value="<%=id%>">
<div style="display:none">
<% if(canedit) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn id=btnSave accessKey=S name=btnSave onclick="onEdit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:frmMain.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
<% } 
if(HrmUserVarify.checkUserRight("LgcAssetTypeEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%
}
 if(HrmUserVarify.checkUserRight("LgcAssetType:Log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:frmMain.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnLog accessKey=L name=button2 id=myfun1  onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =44 and relatedid=<%=id%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}
%>
</div>    <br>
   
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Title> 
      <TH colSpan=2>资产类型信息</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>标识</td>
      <td class=Field> 
        <% if(canedit) { %>
        <input class=InputStyle  accesskey=Z name=typemark onChange='checkinput("typemark","typemarkimage")' value="<%=Util.toScreenToEdit(typemark,user.getLanguage())%>" maxlength="20">
        <span id=typemarkimage></span> 
        <% } else {%>
        <%=Util.toScreen(typemark,user.getLanguage())%> 
        <%}%>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD>名称</TD>
      <TD Class=Field> 
        <% if(canedit) { %>
        <input class=InputStyle  accesskey=Z name=typename size="30" onChange='checkinput("typename","typenameimage")' value="<%=Util.toScreenToEdit(typename,user.getLanguage())%>" maxlength="30">
        <span id=typenameimage></span> 
        <% } else {%>
        <%=Util.toScreen(typename,user.getLanguage())%> 
        <%}%>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>详细</td>
      <td class=Field> 
        <% if(canedit) { %>
        <textarea class=InputStyle accesskey="Z" name="typedesc" cols="60"><%=Util.toScreenToEdit(typedesc,user.getLanguage())%></textarea>
        <% } else {%>
        <%=Util.toScreen(typedesc,user.getLanguage())%> 
        <%}%>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    </TBODY> 
  </TABLE>
  </FORM>
<script language=javascript>
 function onEdit(){
 	if(check_form(document.frmMain,'typemark,typename')){
 		document.frmMain.operation.value="edittype";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deletetype";
			document.frmMain.submit();
		}
}
 </script>

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
</BODY>
</HTML>
