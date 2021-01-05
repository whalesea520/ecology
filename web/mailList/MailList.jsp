
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>

<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("WebSiteView:View",user)) {
	canedit=true;
   }
String name="";
String mailDesc="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeSql("select * from WebMailList where id = " + id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 mailDesc=Util.null2String(RecordSet.getString("mailDesc"));
	}
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = Util.toScreen("邮件列表",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
    if(id.equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
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
<FORM id=weaverA name="weaverA" action="MailListOperation.jsp" method=post >
<input type="hidden" name="changeType" value="1">
<%if(id.equals("")){%>
	<input type="hidden" name="method" value="add">
<%}else{%>
	<input type="hidden" name="method" value="edit">
	<input type="hidden" name="id" value="<%=id%>">
<%}%>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
          <TR>
          <TD>名称</TD>
          <TD class=Field>
              <input name=name class=inputstyle  onchange='checkinput("name","nameimage")' value="<%if(!name.equals("")){%><%=name%><%}%>"><SPAN id=nameimage><%if(name.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		  </TD>
        </TR>
		<tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD>描述</TD>
          <TD class=Field>
              <input name=mailDesc class=inputstyle  value="<%if(!mailDesc.equals("")){%><%=mailDesc%><%}%>">
		  </TD>
        </TR>
		<tr><td class=Line colspan=2></td></tr>
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD action="MailListOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">

<TABLE class=form>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=separator>
          <TD class=Sep1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2>
		  <BUTTON class=btnDelete accessKey=D type=submit onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	  
		  </TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
	  <TABLE class=ListStyle cellspacing=1>
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th>名称</th>
			<th>描述</th>
	    </TR>
		<TR class=Line><TD colSpan=3></TD></TR>

<%
RecordSet.executeSql("select * from webMailList order by id ");
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><%if(canedit){%><input type=checkbox name=webIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
			<td>
			<A href='MailList.jsp?id=<%=RecordSet.getString("id")%>'>
			<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
			</A>
			</td>
			<td><%=Util.toScreen(RecordSet.getString("mailDesc"),user.getLanguage())%></td>	
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
<script language="javascript">
function submitData() {
	if(check_form(weaverA,"name")){
	weaverA.submit();
	}
}
</script>
</body>
</html>


