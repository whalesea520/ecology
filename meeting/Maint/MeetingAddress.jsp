
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)) {
	canedit=true;
   }
String meetingtype = Util.null2String(request.getParameter("meetingtype"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2105,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%if(canedit){%>
<FORM id=weaverA action="MeetingAddressOperation.jsp" method=post onsubmit="return check_form(this,'addressid')">
<input type="hidden" name="method" value="add">
<input type="hidden" name="meetingtype" value="<%=meetingtype%>">
<TABLE class=form>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
  <TR class=separator>
          <TD class=Sep1 colSpan=4></TD></TR>
           <TR>
          <TD colSpan=4>
		  <BUTTON class=btnNew accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		  <BUTTON class=btn accessKey=C onclick="location='/meeting/Maint/ListMeetingType.jsp'"><U>C</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>		  
		  </TD>
        </TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TD>
          <TD class=Field>
			  <BUTTON class=Browser id=SelectAddressID onclick="onShowAddressID()"></BUTTON> 
              <SPAN id=addressidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
              <INPUT id=addressid type=hidden name=addressid>
		  </TD>
        </TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field>
              <input name=desc class=inputstyle style="width=80%">
		  </TD>
        </TR>
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD action="MeetingAddressOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">
<input type="hidden" name="meetingtype" value="<%=meetingtype%>">

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
	  <TABLE class=ListShort>
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></th>
	    </TR>


<%
RecordSet.executeProc("Meeting_Address_SelectAll",meetingtype);
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><%if(canedit){%><input type=checkbox name=MeetingAddressIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
			<td>
			<%if(!RecordSet.getString("addressid").equals("0")){%>
			<A href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("addressid")%>'><%=CapitalComInfo.getCapitalname(RecordSet.getString("addressid"))%></a>
			<%} else {%>
			<%=SystemEnv.getHtmlLabelName(2154,user.getLanguage())%>
			<%}%>
			</td>
			<td><%=RecordSet.getString("desc_n")%></td>
    </tr>
<%	
	isLight = !isLight;
}%>
	  </TBODY>
	  </TABLE>
</FORM>

<script language=vbs>
sub onShowAddressID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where capitalgroupid=16")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	addressidspan.innerHtml ="<A href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaverA.addressid.value=id(0)
	else
	addressidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaverA.addressid.value=""
	end if
	end if
end sub
</script>
</body>
</html>


