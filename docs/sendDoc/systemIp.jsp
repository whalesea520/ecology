
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("SendDoc:Manage",user)) {
	canedit=true;
   }

String name="";
String ip="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeSql("select * from systemIp where id = "+id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 ip=Util.null2String(RecordSet.getString("ip"));
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16989,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){

if(!id.equals(""))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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

<%if(canedit){%>
<FORM id=weaverA name=weaverA action="systemIpOperation.jsp" method=post  >
<%if(id.equals("")){%>
	<input class=inputstyle type="hidden" name="method" value="add">
<%}else{%>
	<input class=inputstyle type="hidden" name="method" value="edit">
	<input class=inputstyle type="hidden" name="id" value="<%=id%>">
<%}%>
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
  <TR class=Spacing>
          <TD class=Sep1 colSpan=4></TD></TR>

          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
              <input name=name class=inputstyle style="width=60%" value="<%=name%>" onchange='checkinput("name","nameimage")'><SPAN id=nameimage><%if(name.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(16989,user.getLanguage())%>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsphttp://</TD>
          <TD class=Field>
              <input class=inputstyle name=ip  style="width=60%" value="<%if(!ip.equals("")){%><%=ip%><%}%>" onchange='checkinput("ip","ipimage")'><SPAN id=ipimage><%if(ip.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		  </TD>
        </TR>
       <TR><TD class=Line colSpan=2></TD></TR>
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD  action="systemIpOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method" value="delete">

<TABLE class=form>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=separator>
          <TD class=Sep1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2><BUTTON class=btnDelete accessKey=D type=submit  onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON></TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
	  <TABLE class=ListStyle cellspacing=1 >
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(16989,user.getLanguage())%></th>
	    </TR>
<TR class=Line><TD colspan="4" ></TD></TR>

<%
RecordSet.executeSql("select * from systemIp order by id desc");
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><%if(canedit){%><input class=inputstyle type=checkbox name=IDs value="<%=RecordSet.getString("id")%>"><%}%></th>
			<td><a href="systemIp.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("name")%></a></td>
			<td>http://<%=RecordSet.getString("ip")%></td>
    </tr>
<%
	isLight = !isLight;
}%>
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
</body>
</html>
<script language=javascript>
function submitData() {
 if(check_form(weaverA,"name,ip")){
 weaverA.submit();
 }
}
</script>