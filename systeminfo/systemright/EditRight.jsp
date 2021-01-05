<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<html>
<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("SystemRights_SelectByID",id);
	RecordSet.next()  ;
	String righttype = RecordSet.getString("righttype");
	String rightdescown = Util.toScreenToEdit(RecordSet.getString("rightdesc"),user.getLanguage());
%>
<head>
<LINK href="/css/BacoSystem_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC_wev8.gif"></TD>
      <TD align=left><SPAN id=BacoTitle class=titlename><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(385, user.getLanguage())%></SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="RightOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>E</U>-<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%></BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199, user.getLanguage())%></BUTTON>
    <br>
        
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelNames("385,87",user.getLanguage()) %></TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TD>
      <TD Class=Field><%=id%>
        <input type="hidden" name="id" value="<%=id%>">
      </TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(716, user.getLanguage())%></td>
      <td class=Field> 
        <select name="righttype">
          <option value="0" <% if(righttype.equals("0")) {%>selected<%}%>>CRM</option>
          <option value="1" <% if(righttype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%></option>
          <option value="2" <% if(righttype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(189, user.getLanguage())%></option>
          <option value="3" <% if(righttype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></option>
          <option value="4" <% if(righttype.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(129306, user.getLanguage())%></option>
          <option value="5" <% if(righttype.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(259, user.getLanguage())%></option>
          <option value="6" <% if(righttype.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%></option>
          <option value="7" <% if(righttype.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(468, user.getLanguage())%></option>
        </select>
      </td>
    </tr>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TD>
      <TD Class=Field>
        <INPUT class=FieldxLong name=rightdescown value="<%=rightdescown%>">
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
        <br>
        
  <TABLE class=Form>
    <COLGROUP><COL width="30%"> <COL width="70%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=3><%=SystemEnv.getHtmlLabelName(2121, user.getLanguage())%></TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep2 colSpan=3></TD>
    </TR>
    <TR> 
      <Td Class=Field><%=SystemEnv.getHtmlLabelName(231, user.getLanguage())%></Td>
      <Td Class=Field colspan="2"><%=SystemEnv.getHtmlLabelName(385, user.getLanguage())%></Td>
    </TR>
    <%
RecordSet.executeProc("SystemRightsLanguage_SByID",id);
while(RecordSet.next())
{
	String rightname = Util.toScreen(RecordSet.getString("rightname"),user.getLanguage());
	String rightdesc = Util.toScreen(RecordSet.getString("rightdesc"),user.getLanguage());
	String languageid= RecordSet.getString("languageid") ;
%>
    <TR> 
      <Td rowspan="2" valign="top"><%=Util.toScreen(LanguageComInfo.getLanguagename(""+languageid),user.getLanguage())%></Td>
      <Td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></Td>
      <Td>
        <input type="text" name="rightname<%=languageid%>" value="<%=rightname%>">
      </Td>
    </TR>
    <TR> 
      <Td><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></Td>
      <Td>
        <input type="text" name="rightdesc<%=languageid%>" size="30" value="<%=rightdesc%>">
      </Td>
    </TR>
    <%
}
%>
  </table>
<input type="hidden" name="operation" value="editright">
      </FORM>
      </BODY>
      </HTML>
