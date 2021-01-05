<%@ page import="weaver.general.Util,
                 weaver.hrm.group.GroupAction,
                 weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
boolean cansave=HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
int groupid = Util.getIntValue(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String imagefilename = "/images/hdMaintenance_wev8.gif";

String needfav ="1";
String needhelp ="";
RecordSet rs=GroupAction.getGroup(groupid);
rs.next();
String name =Util.toHtmlForSplitPage(rs.getString("name"));
String type =rs.getString("type");
String creatorid=rs.getString("owner");

String creator=ResourceComInfo.getResourcename(creatorid);
String titlename = SystemEnv.getHtmlLabelName(17748,user.getLanguage())+":"+name;
if((type.equals("0")&&!creatorid.equals(String.valueOf(user.getUID())))||(type.equals("1")&&!cansave)){
%>
<jsp:forward page="/notice/noright.jsp"/>
<%}
rs=GroupAction.getMembers(groupid);
StringBuffer memberids=new StringBuffer();
StringBuffer membernames=new StringBuffer();
while(rs.next()){
String userid=rs.getString("userid");
String username=ResourceComInfo.getResourcename(userid);
memberids.append(userid);
memberids.append(",");
membernames.append("<A href='/hrm/resource/HrmResource.jsp?id="+userid+"'>");
membernames.append(username);
membernames.append("</A>,");
}
String str_memberids=memberids.toString();
if(!str_memberids.equals(""))
str_memberids=str_memberids.substring(0,str_memberids.length()-1);
String str_membernames=membernames.toString();
if(!str_membernames.equals(""))
str_membernames=str_membernames.substring(0,str_membernames.length()-1);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(type.equals("1") ){
RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",/hrm/group/GroupShare.jsp?creatorid="+creatorid+"&groupid="+groupid+"&name="+name+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/group/HrmGroup.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" >
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3">



</td>
</tr>


<tr valign=top>
<td ></td>
<td valign="top">
<TABLE class=Shadow valign=top>
<tr valign="top">
<td valign="top">

<FORM id=weaver name=frmMain action="GroupOperation.jsp" method=post >

<TABLE class=ViewForm valign="top">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <%
if(msgid!=-1){
%>
<DIV >
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</FONT>
</DIV>
<%}%>
  <TR class=Title valign="top">
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17748,user.getLanguage())%></TH></TR>
  <TR class= Spacing style="height: 1px;">
    <TD class=Line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><%=name%></TD>
        </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
        <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field>
          <% 
        if(type.equals("0")){
        %>
        <%=SystemEnv.getHtmlLabelName(17618,user.getLanguage())%>
        <%}else{%>
        <%=SystemEnv.getHtmlLabelName(17619,user.getLanguage())%>
        <%}%>
         </TD>
        </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
          <TD class=Field> 
			
			<span id="hrmidsspan"><%=str_membernames%></span>
		  </TD>
        </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></TD>
          <TD class=Field> 
			<A href="/hrm/resource/HrmResource.jsp?id=<%=creatorid%>"><%=creator%></A>
		  </TD>
        </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
        <input  name="hrmids"  type="hidden" value="<%=str_memberids%>"/>
        <input  name="hrmnames" type="hidden"  value="<%=str_membernames%>"/>
        <input class=inputstyle type="hidden" name=groupid value="<%=groupid%>">
        <input class=inputstyle type="hidden" name=ownerid value="<%=creatorid%>">
        <input class=inputstyle type="hidden" name=name value="<%=name%>">
        <input class=inputstyle type="hidden" name=type value="<%=type%>">
        <input class=inputstyle type="hidden" name=operation value=editgroup>
 </TBODY></TABLE>
 </form>
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
<script language=javascript>
function submitData() {
 frmMain.submit();
}

function deleteData() {
 if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
 frmMain.operation.value="deletegroup";
 frmMain.submit();
 }
}
</script>


</BODY>
</HTML>