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

RecordSet.executeProc("LgcAssetRelationType_SByID",id);
RecordSet.next();
String typekind = Util.null2String(RecordSet.getString("typekind"));
String shopadvice = Util.null2String(RecordSet.getString("shopadvice"));
String contractlimit = Util.null2String(RecordSet.getString("contractlimit"));
String typename = RecordSet.getString("typename");
String typedesc = RecordSet.getString("typedesc");

boolean canedit = HrmUserVarify.checkUserRight("LgcAssetRelationTypeEdit:Edit", user) ;


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(706,user.getLanguage())+" : "+Util.toScreen(typename,user.getLanguage());
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
<FORM id=frmMain action=LgcAssetRelationTypeOperation.jsp method=post>
  <DIV style="display:none">
  <% if(canedit) {%>
  <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnSave id=saveB accessKey=S name=SaveB onclick="onEdit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("LgcAssetRelationTypeAdd:Add",user)) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:location.href='LgcAssetRelationTypeAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnNew id=AddNew accessKey=N onclick='location.href="LgcAssetRelationTypeAdd.jsp"'><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("LgcAssetRelationTypeEdit:Delete",user)) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("LgcAssetRelationType:Log",user)) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:frmMain.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnLog accessKey=L name=button2 id=myfun1 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =46 and relatedid=<%=id%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}%>
  </div>
  <input type=hidden name=operation>
  <input type=hidden name=id value="<%=id%>">
  <TABLE class=ViewForm>
  <TBODY>
  <TR>
    <TH class=Title align=left>基本信息</TH></TR>
  <TR class=Spacing>
    <TD class=Line1 colSpan=4></TD></TR></TBODY></TABLE>
  <TABLE class=ViewForm id=tblScenarioCode>
    <THEAD> <COLGROUP> <COL width="15%"> <COL width="30%"> <COL width="15%"> <COL width="40%"></THEAD> 
    <TBODY> 
    <TR> 
      <TD>名称</TD>
      <TD class=FIELD>
        <% if(canedit) {%>
        <input class=InputStyle  id=typename name=typename maxlength="30" onchange='checkinput("typename","typenameimage")' size="30" value="<%=Util.toScreenToEdit(typename,user.getLanguage())%>">
        <SPAN id=typenameimage></SPAN> 
        <%}else {%>
        <%=Util.toScreen(typename,user.getLanguage())%>
        <%}%>
      </TD>
      <TD>购物建议</TD>
      <TD class=field> 
        <input class=InputStyle  type="checkbox" name="shopadvice" value="1" <% if(shopadvice.equals("1")) {%> checked <%} if(!canedit) {%> disabled <%}%>>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>类型</td>
      <td class=FIELD><nobr> 
        <% if(canedit) {%>
        <select class=InputStyle id=State name=typekind>
          <option value="1" <%if(typekind.equals("1")) {%> selected <%}%>>强制</option>
          <option value="2" <%if(typekind.equals("2")) {%> selected <%}%>>必选其一</option>
          <option value="3" <%if(typekind.equals("3")) {%> selected <%}%>>可选</option>
          <option value="4" <%if(typekind.equals("4")) {%> selected <%}%>>可选其一</option>
          <option value="5" <%if(typekind.equals("5")) {%> selected <%}%>>排除</option>
        </select>
        <span id=typedescimage></span> 
        <%}else { 
		if(typekind.equals("1")) {%>强制 
        <%}else if(typekind.equals("2")) {%>必选其一 
        <%}else if(typekind.equals("3")) {%>可选 
        <%}else if(typekind.equals("4")) {%>可选其一 
        <%}else if(typekind.equals("5")) {%>排除 
        <%}}%>
      </td>
      <td>合同限制</td>
      <td class=field>
        <input class=InputStyle  type="checkbox" name="contractlimit" value="1" <% if(contractlimit.equals("1")) {%> checked <%} if(!canedit) {%> disabled <%}%>>
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD>说明</TD>
      <TD class=FIELD><nobr>
        <% if(canedit) {%>
        <textarea class=InputStyle id="typedesc" name="typedesc" onChange="checkinput(&quot;typedesc&quot;,&quot;typedescimage&quot;)" cols="60" rows="6"><%=Util.toScreenToEdit(typedesc,user.getLanguage())%></textarea>
        <SPAN id=typedescimage></SPAN> 
        <%}else {%>
        <%=Util.toScreen(typedesc,user.getLanguage())%>
        <%}%>
      </TD>
      <TD>&nbsp;</TD>
      <TD>&nbsp;</TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    </TBODY> 
  </TABLE>
</FORM>
<Script language=javascript>
function onEdit() {
	if(check_form(frmMain,"typename")) {
		frmMain.shopadvice.disabled = false ;
		frmMain.contractlimit.disabled = false ;
		frmMain.operation.value="edittype";
		frmMain.submit();
	}
}
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			frmMain.operation.value="deletetype";
			frmMain.submit();
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
</BODY></HTML>
