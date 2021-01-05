<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(384,user.getLanguage());
String needfav ="1";
String needhelp ="";
String id = Util.null2String(request.getParameter("id"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String jobactivity = Util.null2String(request.getParameter("jobactivity"));
RecordSet.executeProc("HrmResourceSkill_SelectByID",id);
RecordSet.next();
String skilldesc = Util.toScreenToEdit(RecordSet.getString("skilldesc") , user.getLanguage());
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:EditSkill(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/resource/HrmResourceSkillAdd.jsp?resourceid="+resourceid+"&jobactivity="+jobactivity+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:DeleteSkill(),_self} " ;
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
<FORM id=editskill name=editskill action=HrmResourceSkillOperation.jsp method=post>
<input type=hidden name="operation">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="resourceid" value="<%=resourceid%>">
<input type=hidden name="jobactivity" value="<%=jobactivity%>">
   <TABLE class=viewFORM>
    <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
    <TR class=title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%> 
        - <%=jobactivity%> </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(384,user.getLanguage())%></td>
      <td class=FIELD id=Skill>
        <input class=inputStyle 
      maxlength=60 onChange='checkinput("skilldesc","skilldescimage")' size=60 
      name=skilldesc value="<%=skilldesc%>">
        <span id=skilldescimage></span></td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    </TBODY> 
  </TABLE>
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
<Script language="javascript">
function DeleteSkill() {
if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
document.editskill.operation.value="deleteskill" ;
document.editskill.submit();
}
}
function EditSkill() {
if(check_form(document.editskill ,"skilldesc")) {
document.editskill.operation.value="editskill" ;
document.editskill.submit();
}
}
</SCRIPT>
</BODY></HTML>
