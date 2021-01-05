
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)) {
	canedit=true;
   }
String meetingtype = Util.null2String(request.getParameter("meetingtype"));
int subcompanyid = Util.getIntValue(request.getParameter("subCompanyId"),user.getUserSubCompany1());
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2107,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/meeting/Maint/MeetingType_left.jsp?subCompanyId="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">

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
<FORM id=weaverA name=weaverA action="MeetingServiceOperation.jsp" method=post  >
<input class=inputstyle type="hidden" name="method" value="add">
<input class=inputstyle type="hidden" name="meetingtype" value="<%=meetingtype%>">
<INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
  <TR class=Spacing style="height:1px;">
          <TD class=Line1 colSpan=4></TD></TR>
          <TD><%=SystemEnv.getHtmlLabelName(2155,user.getLanguage())%></TD>
          <TD class=Field>
              <input name=name class=inputstyle style="width=60%" onchange='checkinput("name","nameimage")'><SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		  </TD>
        </TR>
         <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2156,user.getLanguage())%></TD>
          <TD class=Field>
			  <button type=button  class=Browser id=SelectHrmID onclick="onShowHrmID()"></BUTTON> 
              <SPAN id=hrmidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
              <input class=inputstyle id=hrmid type=hidden name=hrmid>
		  </TD>
        </TR>
         <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2157,user.getLanguage())%></TD>
          <TD class=Field>
              <input name=desc maxlength="255" onblur="checkLength()" class=inputstyle style="width=60%" onchange='checkinput("desc","descimage")'><SPAN id=descimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> <%=SystemEnv.getHtmlLabelName(2158,user.getLanguage())%>
		  </TD>
        </TR>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD action="MeetingServiceOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method" value="delete">
<input class=inputstyle type="hidden" name="meetingtype" value="<%=meetingtype%>">
<INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
<TABLE class=form>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=separator>
          <TD class=Sep1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2>
		  <button  class=btnDelete accessKey=D type=submit onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	  
		  </TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
	  <TABLE class=ListStyle cellspacing=1 >
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th><%=SystemEnv.getHtmlLabelName(2155,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(2156,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(2157,user.getLanguage())%></th>
	    </TR>
       <TR  style="height:1px;" class=Line><TD colspan="4" ></TD></TR> 


<%
RecordSet.executeProc("Meeting_Service_SelectAll",meetingtype);
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><%if(canedit){%><input class=inputstyle type=checkbox name=MeetingServiceIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
			<td><%=RecordSet.getString("name")%></td>
			<td><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid"))%></a></td>
			<td><%=RecordSet.getString("desc_n")%></td>
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
<script language=javascript>  
function submitData() {
 if(check_form(weaverA,"name,hrmid,desc")){
 weaverA.submit();
 }
}

//add by ws 2010-12-03
function checkLength(){
	tmpvalue = $GetEle("desc").value;
	if(realLength(tmpvalue)>255){
		alert("<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)");
		while(true){
			tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
			if(realLength(tmpvalue)<=255){
				$GetEle("desc").value = tmpvalue;
				return;
			}
		}
	}
}
</script>
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowHrmID() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle("hrmidspan")
			, $GetEle("hrmid")
			, true
			, "/hrm/resource/HrmResource.jsp?id=");
}
</script>

</body>
</html>


