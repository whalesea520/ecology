
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<% 
boolean canedit = HrmUserVarify.checkUserRight("EditContacterTitle:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>

<%
	int msgid = Util.getIntValue(request.getParameter("msgid"), -1);

	String id = request.getParameter("id");
	//modify TD1547 by xys
	//RecordSet.executeSql("Select * from CRM_CustomerContacter where title="+id);
	//int num = RecordSet.getCounts();//查询CRM_CustomerContacter的纪录总数是否大于0;
	
	int num = 0;
	RecordSet.executeSql("select count(id) from CRM_CustomerContacter where title="+id);
	if(RecordSet.next()) num = RecordSet.getInt(1);//查询CRM_CustomerContacter的纪录总数是否大于0;
	
	RecordSet.executeProc("CRM_ContacterTitle_SelectByID",id);
	
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();

	boolean canEdit = HrmUserVarify.checkUserRight("EditContacterTitle:Edit", user);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name,desc,language,abbrev')){
        weaver.submit();
    }
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (canEdit) 
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())
			+":"+SystemEnv.getHtmlLabelName(462,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
else 
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())
			+":"+SystemEnv.getHtmlLabelName(462,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("EditContacterTitle:Delete", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/CRM/Maint/ListContacterTitle.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<DIV>
<%
if (msgid != -1) {
%>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</FONT>
<%}%>
</DIV>

<FORM id=weaver name="form1" action="/CRM/Maint/ContacterTitleOperation.jsp" method=post onsubmit='return check_form(this,"name,desc,language,abbrev")'>
<!--modify TD1547 by xys-->
<BUTTON class=btnDelete id=Delete accessKey=D style="display:none" 	onclick='doDel()'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.	getLanguage())%></BUTTON>

<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="num" value="<%=num%>">
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
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=50 size=20 name="name" value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>" onchange='checkinput("name","nameimage")'><SPAN id=nameimage></SPAN><%} else {%><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%><%}%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=50 name="desc" value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>" onchange='checkinput("desc","descimage")'><SPAN id=descimage></SPAN><%} else {%><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(604,user.getLanguage())%></TD>
          <TD class=Field>
<%
	if (canedit){
%>    <select class=InputStyle  size="1" name="usage">
<%
		if(RecordSet.getString(4).equals("p"))
		{
%>
	       <option value="p" selected><%=SystemEnv.getHtmlLabelName(583,user.getLanguage())%></option>
	       <option value="s"><%=SystemEnv.getHtmlLabelName(584,user.getLanguage())%></option>
<%
		}
		else
		{
%>
	       <option value="p"><%=SystemEnv.getHtmlLabelName(583,user.getLanguage())%></option>
	       <option value="s" selected><%=SystemEnv.getHtmlLabelName(584,user.getLanguage())%></option>
<%
		}
%>	     </select>
<%
	}
	else
	{
		if(RecordSet.getString(4).equals("p")){
%>
			<%=SystemEnv.getHtmlLabelName(583,user.getLanguage())%>
<%      }
		else{
%>
			<%=SystemEnv.getHtmlLabelName(584,user.getLanguage())%>
<%			}
    }
%>
		 </TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%>
              
              <INPUT type=hidden class="wuiBrowser"
              _displayText="<%=Util.toScreen(LanguageComInfo.getLanguagename(RecordSet.getString("language")),user.getLanguage())%>"
               _url="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp" _required="yes"
               name=language  value="<%=Util.toScreenToEdit(RecordSet.getString("language"),user.getLanguage())%>">
              <%} else {%><%=Util.toScreenToEdit(RecordSet.getString("language"),user.getLanguage())%><%}%></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(568,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=50 size=20 name="abbrev" value="<%=Util.toScreenToEdit(RecordSet.getString(6),user.getLanguage())%>" onchange='checkinput("abbrev","abbrevimage")'><SPAN id=abbrevimage></SPAN><%} else {%><%=Util.toScreen(RecordSet.getString(6),user.getLanguage())%><%}%></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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
</BODY>

<script language=javascript >
function doDel(){
	if(canDel()){location.href="/CRM/Maint/ContacterTitleOperation.jsp?method=delete&id=<%=id%>&name=<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"}
}
<!--modify TD1547 by xys-->
function canDel(){
	var a=document.form1.num.value;
	if(isdel()){
		if(a>0){
			alert("<%=SystemEnv.getErrorMsgName(37,user.getLanguage())%>");
			return false;
		}else{
			return true;
		}
	}else{
		return false;
	}
}
</script>
</HTML>
