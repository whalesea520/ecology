
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String tablename = Util.null2String(request.getParameter("tablename"));
boolean canedit = false;

String subTitleName = "";

if (tablename.equals("hr"))
{
	canedit = HrmUserVarify.checkUserRight("HrmResouceFreeFeildEdit:Edit", user);
	subTitleName = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(17037,user.getLanguage());
}
else if (tablename.equals("b1"))
{
	canedit = HrmUserVarify.checkUserRight("WorkflowManage:All", user);
}
else if (tablename.equals("b2"))
{
	canedit = HrmUserVarify.checkUserRight("WorkflowManage:All", user);
}
else if (tablename.equals("b3"))
{
	canedit = HrmUserVarify.checkUserRight("WorkflowManage:All", user);
}
else if (tablename.equals("b4"))
{
	canedit = HrmUserVarify.checkUserRight("WorkflowManage:All", user);
}
else if (tablename.equals("c1"))
{
	canedit = HrmUserVarify.checkUserRight("CustomerAccountFreeFeildEdit:Edit", user);
	subTitleName = SystemEnv.getHtmlLabelName(21313,user.getLanguage())+SystemEnv.getHtmlLabelName(17037,user.getLanguage());
}
else if (tablename.equals("c2"))
{
	canedit = HrmUserVarify.checkUserRight("CustomerContactorFreeFeildEdit:Edit", user);
}
else if (tablename.equals("c3"))
{
	canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
}
else if (tablename.equals("p1"))
{
	canedit = HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit", user);
	subTitleName = SystemEnv.getHtmlLabelName(22245,user.getLanguage())+SystemEnv.getHtmlLabelName(17037,user.getLanguage());
}
else if (tablename.equals("cp"))
{
	canedit = HrmUserVarify.checkUserRight("CptCapitalFreeFeild:Edit", user);
	subTitleName = SystemEnv.getHtmlLabelName(17476,user.getLanguage());
}

String ffname = Util.null2String(request.getParameter("ffname"));

RecordSet.executeSql("select "+ffname+"name,"+ffname+"use"+" from Base_FreeField where tablename='"+tablename+"'");
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (canedit)
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) + ":&nbsp;" 
				+ subTitleName;
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage()) + ":&nbsp;" 
				+ subTitleName;

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/base/ffield/ListFreeField.jsp?tablename="+tablename+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action="/base/ffield/FreeFieldOperation.jsp" method=post>
<input type="hidden" name="tablename" value="<%=tablename%>">
<input type="hidden" name="ffname" value="<%=ffname%>">
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
			<TABLE class=ViewForm>
			  <COLGROUP>
			  <COL width="100%">
			  <TBODY>
			  <TR>
				<TD vAlign=top>
				  <TABLE class=ViewForm>
				  <COLGROUP> 
				<COL width="20%">
				<COL width="80%">
					<TBODY>
					<TR class=Title>
						<TH><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
					  </TR>
					<TR class=Spacing style="height:1px;">
					  <TD class=Line1 colSpan=2></TD></TR>
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%></TD>
					  <TD class=Field><%if(canedit){%><INPUT class=InputStyle maxLength=50 size=20 name="fflabel" value="<%=Util.toScreenToEdit(RecordSet.getString(1),user.getLanguage())%>"><%}else{%><%=Util.toScreenToEdit(RecordSet.getString(1),user.getLanguage())%><%}%></TD>
					</TR>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
					  <TD class=Field><%if(canedit){%>
					<select size="1" name="ffuse" class=InputStyle>
			<%if(RecordSet.getString(2).equals("1")){%>
						<option value=1 selected><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
			<%}else{%>
						<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
			<%}if(RecordSet.getString(2).equals("0")){%>
						<option value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
			<%}else{%>
						s<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
			<%}%>
					</select>
			<%}else{
			   if(RecordSet.getString(2).equals("1")){%>
						<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
			<%}else if(RecordSet.getString(2).equals("0")){%>
					<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>

			<%}
			}%>
					  </TD>
					 </TR>     
					 <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
					</TBODY></TABLE></TD>
				</TR></TBODY></TABLE>
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
</FORM>
<script language=javascript>
 function onSave(){
		document.getElementById("weaver").submit();	
 }
</script>
</BODY>
</HTML>
